public class CSD_CloneOpptyWithPartsCtrl {

    public opportunity opp {get;set;}
    public opportunity oppnew {get;set;}
    public list<Opportunity_Part__c> pl {get;set;}
    public list<Opportunity_Forecast__c> fl {get;set;}
    public List<OpportunityContactRole> crl {get;set;}//added by nelson zheng 06/01/2015
    public List<Opportunity_Competitor__c> ocl {get;set;}//added by nelson zheng 07/08/2015
    public List<Opportunity_Partner__c> opl {get;set;}//added by nelson zheng 07/08/2015
    public Id userId;
    public String processStatusValue;
    public String statusValue;    
    map<id,id> oldnewpartids;
    public set<String> opptyPartExcludeField;
    public set<String> opptyForecastExcludeField;
    id opptyid;
    id oid;

    public CSD_CloneOpptyWithPartsCtrl(ApexPages.StandardController controller) 
    {
        opp = new opportunity ();
        oppnew = new opportunity ();
        pl = new list<Opportunity_Part__c>();
        fl = new list<Opportunity_Forecast__c>();
        crl = new List<OpportunityContactRole>();//added by nelson zheng 06/01/2015
        ocl = new List<Opportunity_Competitor__c>();//added by nelson zheng 07/08/2015
        opl = new List<Opportunity_Partner__c>();//added by nelson zheng 07/08/2015
        opptyPartExcludeField = new set<String>();
        opptyForecastExcludeField = new set<String>();
        oid = apexpages.currentpage().getparameters().get('id');
        oldnewpartids = new map<id,id>();
        //add CreatedDate. by nelson zheng 2015-10-30
        opp = [select CreatedDate,id,RecordTypeId,Amount,Probability,RecordType.DeveloperName,Owner.gibu__c from opportunity where id=:oid];
        userId = UserInfo.getUserId();

        if(Apex_Helper_Settings__c.getInstance('C2S Default Clone Process Status Value') != null && Apex_Helper_Settings__c.getInstance('C2S Default Clone Process Status Value').Active__c && Apex_Helper_Settings__c.getInstance('C2S Default Clone Process Status Value').value__c != null)
            processStatusValue = Apex_Helper_Settings__c.getInstance('C2S Default Clone Process Status Value').value__c;
        if(Apex_Helper_Settings__c.getInstance('C2S Default Clone Status Value') != null && Apex_Helper_Settings__c.getInstance('C2S Default Clone Status Value').Active__c && Apex_Helper_Settings__c.getInstance('C2S Default Clone Status Value').value__c != null)
            statusValue = Apex_Helper_Settings__c.getInstance('C2S Default Clone Status Value').value__c;
    }
    
    public pagereference CloneOpty()
    {
        //Added by nelson zheng 06/01/2015 to validate that the opportunity has contact roles or not.
        
        List<Opportunity> validateList = new List<Opportunity>();
        validateList.add(opp);
        TEMarketing.OpportunityTriggerHandler handler = new TEMarketing.OpportunityTriggerHandler();
        Map<Id, String> err = handler.validateOpportunityContactRolesWithErrors(validateList);
        System.debug('--------err--------'+err);
        if(err.size() > 0){
                
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,err);
            //ApexPages.addMessage(myMsg);
            return null;
            
        }
        //end
        
        map<String, String> defaultValue = new map<String, String>();
        ClsOppyUtil.cloneOppty = true;    
        
        string query = 'select Accountid';

        for(Opportunity_Clone_Fields_Settings__c cs:[select Field_API_Name__c, Default_Value__c, Parent_Record_Type_Id__c from Opportunity_Clone_Fields_Settings__c where Parent_Record_Type_Id__c =:opp.RecordTypeId or Parent_Record_Type_Id__c = 'OpportunityPart' or Parent_Record_Type_Id__c = 'OpptyForecast']) 
        {
            if(cs.Parent_Record_Type_Id__c == 'OpportunityPart')
                opptyPartExcludeField.add(cs.Field_API_Name__c.toLowerCase());
             
            if(cs.Parent_Record_Type_Id__c == 'OpptyForecast')
                opptyForecastExcludeField.add(cs.Field_API_Name__c.toLowerCase());
            
            if(cs.Parent_Record_Type_Id__c == String.valueOf(opp.RecordTypeId))
                query = query + ', '+ cs.Field_API_Name__c;
                
            if(cs.Default_Value__c != null && cs.Default_Value__c != '' && cs.Parent_Record_Type_Id__c == String.valueOf(opp.RecordTypeId))
                defaultValue.put(cs.Field_API_Name__c, cs.Default_Value__c);
        } 
        
        Savepoint sp = Database.setSavepoint();

        try
        {
            query = query+' FROM Opportunity where id=:oid'; 
            List<opportunity > opptys= Database.query(query);
            opp = opptys[0];
            oppnew = opp.clone(false);
            oppnew.name = 'Copy Of - '+ oppnew.name ;
            oppnew.OwnerId = userId;
            /*if(opp.RecordTypeId == Apex_Helper_Settings__c.getInstance('Sales Opportunity CSD').value__c)
                oppnew.StageName = csdStageValue;
            if(opp.RecordTypeId == Apex_Helper_Settings__c.getInstance('Engineering Opportunity CSD Id').value__c)
                oppnew.StageName = csdStageValue;
            if(opp.RecordTypeId == Apex_Helper_Settings__c.getInstance('Sales Parts Only').value__c)
                oppnew.StageName = salesStageValue;
            if(opp.RecordTypeId == Apex_Helper_Settings__c.getInstance('Opportunity Product Platform').value__c)
                oppnew.StageName = aplStageValue;
            if(opp.RecordTypeId == Apex_Helper_Settings__c.getInstance('Opportunity Engineering Project Id').value__c)
                oppnew.StageName = aplStageValue;*/
            if(defaultValue.containsKey('StageName'))
                oppnew.StageName = defaultValue.get('StageName');
            insert oppnew;
            opptyid = oppnew.id;
            
            Schema.DescribeSObjectResult r = Opportunity_Part__c.sObjectType.getDescribe(); 
            Map<String, Schema.SObjectField> M = r.fields.getMap();
            String SOQL = 'Select '; 
            for (String fieldName : M.keySet())
            {               
                //if(fieldName != 'TOPS_ID__c')
                if(!opptyPartExcludeField.contains(fieldName.toLowerCase()))
                    SOQL += fieldName + ',';  
            } 
            SOQL = SOQL.substring(0,SOQL.length()-1);  
            SOQL += ' From Opportunity_Part__c where Opportunity__c=:oid';                      
            List<sObject> S = Database.query(SOQL);                    
            
            for(sObject OP: S)
            {
                Opportunity_Part__c oldOP = (Opportunity_Part__c)OP;
                oldOP.id_for_clone__c = oldOP.Id;
                Opportunity_Part__c newOP = oldOP.clone(false);
                newOP.Opportunity__c = opptyid;
                newOP.Process_Status__c = processStatusValue;
                newOP.Status__c = statusValue;
                if(newOP.RecordTypeId == Apex_Helper_Settings__c.getInstance('Cable Asssembly Part RT Id').Value__c || newOP.RecordTypeId == Apex_Helper_Settings__c.getInstance('New Development RT Id').Value__c || newOP.RecordTypeId == Apex_Helper_Settings__c.getInstance('Extension RT Id').Value__c)
                    newOP.Part__c = null;
                pl.add(newOP);
            }   
        
            ClsOppyPartUtil.isRunTrigger = false;
            if(pl.size()>0){
            
                insert pl;
            
            for(opportunity_part__c opc:pl)
            {
                oldnewpartids.put(opc.id_for_clone__c, opc.id);
            } 
            
            Schema.DescribeSObjectResult r1 = Opportunity_Forecast__c.sObjectType.getDescribe(); 
            Map<String, Schema.SObjectField> M1 = r1.fields.getMap();
            String SOQL1 = 'Select '; 
            for (String fieldName : M1.keySet())
            {               
                //if(fieldName != 'Last_PLM_Integration_Date__c')
                if(!opptyForecastExcludeField.contains(fieldName.toLowerCase()))
                    SOQL1 += fieldName + ',';  
            } 
            SOQL1 = SOQL1.substring(0,SOQL1.length()-1);  
            SOQL1 += ' From Opportunity_Forecast__c where Opportunity__c=:oid';                         
            List<sObject> S1 = Database.query(SOQL1);                              
            
            for(sObject a: S1)
            {
                Opportunity_Forecast__c oldOF = (Opportunity_Forecast__c)a;
                Opportunity_Forecast__c newOF = oldOF.clone(false);
                newOF.opportunity__c = opptyid;
                                
                if(oldnewpartids.containsKey(newOF.Part__c))
                    newOF.Part__c= oldnewpartids.get(newOF.Part__c);
                fl.add(newOF);
             } 
            
            if(fl.size()>0)           
                insert fl;
                    
            }
            
            //Added by nelson zheng 06/01/2015 clone the contast roles,competitor and partner as well
           
                Schema.DescribeSObjectResult r2 = OpportunityContactRole.sObjectType.getDescribe(); 
                Map<String, Schema.SObjectField> M2 = r2.fields.getMap();
                String SOQL2 = 'Select '; 
                for (String fieldName : M2.keySet())
                {               
                    //if(fieldName != 'Last_PLM_Integration_Date__c')
                    //if(fieldName != 'External_ID__c')
                        SOQL2 += fieldName + ',';  
                } 
                SOQL2 = SOQL2.substring(0,SOQL2.length()-1);  
                SOQL2 += ' From OpportunityContactRole  where OpportunityId=:oid';                         
                List<sObject> S2 = Database.query(SOQL2);                              
                
                for(sObject a: S2)
                {
                    OpportunityContactRole oldCR = (OpportunityContactRole)a;
                    
                    OpportunityContactRole newCR = oldCR.clone(false);
                    //newCR.External_ID__c = null;
                    newCR.opportunityId = opptyid;
                    crl.add(newCR);
                 } 
                
                if(crl.size()>0){           
                    insert crl;
                        
                }
                
                //Added by nelson zheng 07/08/2015 clone the competitor as well
                Schema.DescribeSObjectResult r3 = Opportunity_Competitor__c.sObjectType.getDescribe(); 
                Map<String, Schema.SObjectField> M3 = r3.fields.getMap();
                String SOQL3 = 'Select '; 
                for (String fieldName : M3.keySet())
                {               
                    SOQL3 += fieldName + ',';  
                } 
                SOQL3 = SOQL3.substring(0,SOQL3.length()-1);  
                SOQL3 += ' From Opportunity_Competitor__c where Opportunity__c=:oid';                         
                List<sObject> S3 = Database.query(SOQL3);                              
                
                for(sObject a: S3)
                {
                    Opportunity_Competitor__c oldOC = (Opportunity_Competitor__c)a;
                    
                    Opportunity_Competitor__c newOC = oldOC.clone(false);
                    newOC.opportunity__c = opptyid;
                    ocl.add(newOC);
                 } 
                
                if(ocl.size()>0){           
                    insert ocl;
                        
                }
                
                //Added by nelson zheng 07/08/2015 clone the Partner as well
                //check whether the new opportunity has Partner or not
                List<Opportunity_Partner__c> oppPartnerList = [select Id from Opportunity_Partner__c where opportunity__c =: opptyid];
                if(oppPartnerList.size() > 0){
                    APL_Utils_Class.calAllocation = false;
                    delete oppPartnerList;
                    APL_Utils_Class.calAllocation = true;
                }
                Schema.DescribeSObjectResult r4 = Opportunity_Partner__c.sObjectType.getDescribe(); 
                Map<String, Schema.SObjectField> M4 = r4.fields.getMap();
                String SOQL4 = 'Select '; 
                for (String fieldName : M4.keySet()){               
                    SOQL4 += fieldName + ',';  
                } 
                SOQL4 = SOQL4.substring(0,SOQL4.length()-1);  
                SOQL4 += ' From Opportunity_Partner__c where Opportunity__c=:oid';                         
                List<sObject> S4 = Database.query(SOQL4);                              
                for(sObject a: S4){
                    Opportunity_Partner__c oldOP = (Opportunity_Partner__c)a;
                    Opportunity_Partner__c newOP = oldOP.clone(false);
                    newOP.opportunity__c = opptyid;
                    opl.add(newOP);
                } 
                    
                if(opl.size()>0){           
                    insert opl;
                }
          
         }catch (Exception e)
         {
            // roll everything back in case of error
            Database.rollback(sp);
            ApexPages.addMessages(e);
            ClsOppyUtil.cloneOppty = false;
            return null;
         }            
        ClsOppyUtil.cloneOppty = false;    
        if(opptyid<>null)
        {
            pagereference page = new pagereference ('/'+opptyid+'/e?retURL=/'+opptyid); 
            return page;
        }
        else            
            return null;        
        
    }  
}