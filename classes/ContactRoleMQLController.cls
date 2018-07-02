public class ContactRoleMQLController {
    // public String oppId {get; set;}
    public List<OpportunityContactRole> oppConRole{get;set;}
    public List<TEMarketing__MQLRecord__c> MQLlist {get;set;}
    public List<Contact> Conlist {get;set;}
    public List<TEMarketing__MQLRecord__c> existMQLlist {get;set;}
    set<id> conId = new set<id>();
    public Boolean isChecked {get; set;}
    public Id recordid{get;set;}
    public string name{get;set;}
    public blob img{set; get;} 
    public Opportunity opp{get;set;}
    public String Oppid{get;set;}
    public Boolean requiredRole {get;set;}
    public string Mqlrecord {get;set;}
    public string selectedcon{ get; set; }
    List<String> Names11 = new list<String>();
    List<String> Names32 = new list<String>();
    List<String> Names43 = new list<String>();
    List<String> Names15 = new list<String>();
    List<String> Names36 = new list<String>();
    List<String> Names48 = new list<String>();
    List<String> Names26 = new list<String>();
    List<String> Names28 = new list<String>();
    List<String> Names56 = new list<String>();
    List<String> Names58 = new list<String>(); 
    List<String> Names23 = new list<String>();
    List<String> Names33 = new list<String>();
    List<String> Names44 = new list<String>();
    List<String> Names73 = new list<String>();
    List<String> Names83 = new list<String>();
    List<String> Names104 = new list<String>();
    List<String> Names105 = new list<String>();
    List<String> Names106 = new list<String>();
    List<String> Names107 = new list<String>();
    List<String> Names108 = new list<String>();
    List<String> Names109 = new list<String>();
    List<String> Names110 = new list<String>();
    
    Integer count;
    public list<MQLwrapper>mqlWrap{get;set;} // to display in page 
    map<id,TEMarketing__MQLRecord__c> mqlMap = new map<id,TEMarketing__MQLRecord__c>();
    List<String> Names = new list<String>();
    List<String> Names1 = new list<String>();
    List<String> Names2 = new list<String>();
    List<String> Names3 = new list<String>();
    List<String> Names4 = new list<String>();
    List<String> Names88 = new list<String>();
    List<String> Names61 = new list<String>();
    List<String> Names62 = new list<String>();
    List<String> Names30= new list<String>();
    List<String> Names74 = new list<String>();
    List<String> Names75 = new list<String>();
    List<String> Names91 = new list<String>();
    List<String> Names92 = new list<String>();
    List<String> Names93 = new list<String>();
    List<String> Names94 = new list<String>();
    List<String> Names111 = new list<String>();
    List<String> Names112 = new list<String>();
    List<String> Names113 = new list<String>();
    List<String> Names114 = new list<String>();
    List<String> Names115 = new list<String>();    
    // list<OpportunityContactRole> a1= new list<OpportunityContactRole>();
    // List<OpportunityContactRole> a2= new List<OpportunityContactRole>();
    
    //public set<id> conIdList;
    public ContactRoleMQLController(ApexPages.StandardController controller) {
        opp = new Opportunity ();
        Oppid = ApexPages.currentPage().getParameters().get('oppid');
        existMQLlist = new List<TEMarketing__MQLRecord__c>();
        mqlWrap=new list<MQLwrapper>();
        if(Oppid !=NULL)
        {
            opp = [Select Id,Name FROM Opportunity WHERE Id =:Oppid];
            oppConRole = [Select Id,ContactId,Contact.Level__c,Contact.MQL_age__c,Contact.MQL_Flag_Contact__c,IsPrimary,OpportunityId,Opportunity.ContactRole__c,Role FROM OpportunityContactRole Where OpportunityId =: Oppid];   
            system.debug('oppConRole>>'+oppConRole);
            for(OpportunityContactRole opprole : oppConRole)
            {
                if(opprole.ContactId != null)
                {
                    conId.add(opprole.ContactId);
                }
                if(opprole.IsPrimary==true && selectedcon==''){
                    selectedcon=opprole.ContactId;
                }
            }
            system.debug('conId><><>' + conId);
            //map<id,TEMarketing__MQLRecord__c> mqlMap=new map<id,TEMarketing__MQLRecord__c>();
            //existMQLlist = [select id,name from TEMarketing__MQLRecord__c where TEMarketing__Contact__c =:conId];
            MQLlist = [Select Id,Name,MQL_Flag__c,TEMarketing__MQL_Date__c,TEMarketing__Contact__r.MQL_age__c,TEMarketing__Contact__r.MQL_Flag_Contact__c from TEMarketing__MQLRecord__c where TEMarketing__Contact__c IN :conId   order by createdDate ASC];
            system.debug('MQLlist><><>' + MQLlist);
            for(TEMarketing__MQLRecord__c mqlrec : MQLlist)
            {
                if(mqlrec.TEMarketing__Contact__c != null){
                    
                    mqlMap.put(mqlrec.TEMarketing__Contact__c, mqlrec);
                    
                }
                
            }
            system.debug('mqlMap><><>' + mqlMap);
            if(!mqlMap.isEmpty() && mqlMap.values() != null)
            {
                existMQLlist.addall(mqlMap.values());
            }
            system.debug('existMQLlist><><>' + existMQLlist);
            contactValue();
            for(OpportunityContactRole opcr: oppConRole){
                mqlWrap.add(new MQLwrapper(opcr,mqlMap.get(opcr.ContactId)));
            }
            System.debug('==mqlWrap=='+mqlWrap);
        }
        if(!test.isRunningTest())
        {
            for(integer i=1; i<=3; i++)
            {
                OpportunityContactRole objOppCon = new OpportunityContactRole();         
                oppConRole.add(objOppCon);
                mqlWrap.add(new MQLwrapper(objOppCon,mqlMap.get(objOppCon.ContactId)));
            }
            
        }
    }
    /*
* public PageReference showContacts(){
string conId=System.currentPageReference().getParameters().get('selCon');
system.debug('===conId==>'+conId);
if(conId!=null){
Contact oc=[Select Id,Level__c,MQL_Flage1__c,MQL_Flag_Contact__c FROM contact Where Id=:conId];
system.debug('===oc==>'+oc);
}
return null;   
} */
    public void contactValue() {
        Id contactId;
        if(string.valueof(Apexpages.currentPage().getParameters().get('contact')) != null && string.valueof(Apexpages.currentPage().getParameters().get('contact')) != '')
        {
            contactId = Apexpages.currentPage().getParameters().get('contact');
        }
        System.debug('****contactId '+contactId);
        System.debug('****isChecked '+isChecked);
        if(string.valueof(contactId) != '' && string.valueOf(contactId) != null)
        {
            recordid=contactId;
            
        }
        if (string.valueOf(contactId) != null && string.valueOf(contactId) != '')
        {
            //for(TEMarketing__MQLRecord__c c : [Select Id,Name,MQL_Flag__c from TEMarketing__MQLRecord__c where TEMarketing__Contact__c =:contactId Limit 1]){
            //  MQLlist = c;
            //MQLlist = [Select Id,Name,MQL_Flag__c from TEMarketing__MQLRecord__c where TEMarketing__Contact__c =:contactId order by createdDate DESC limit 1];
            // MQLlist = [Select Id,Name,MQL_Flag__c,TEMarketing__MQL_Date__c,TEMarketing__Contact__r.MQL_age__c,TEMarketing__Contact__r.MQL_Flag_Contact__c from TEMarketing__MQLRecord__c where TEMarketing__Contact__c IN :conId   order by createdDate DESC Limit 1];
            Conlist = [Select id, name, (Select TEMarketing__Full_Name__c From TEMarketing__MQLRecords__r) From Contact c  where Id IN :conId   order by createdDate DESC Limit 1];
            //}
            if(MQLlist != null && !MQLlist.isEmpty())
            {
                name=MQLlist[0].Name;
            }
            else
                name = '';
        } 
        
        System.debug('****MQLlist '+MQLlist);    
    }
    
    public pagereference CancelOppCon()
    {
        
        PageReference Pg = new PageReference('/'+opp.Id);
        Pg.setRedirect(true);
        return Pg;
    }
    
    public Pagereference MqlNav()
    {
        String recid = system.currentpagereference().getparameters().get('mqlrecId');
        system.debug('recid<><><' + recid);
        PageReference Mq = new PageReference('/'+recid);
        //Mq.getParameters().put('id',Mqlrecord);
        Mq.setRedirect(true);
        return Mq;
    }
    
    public pagereference SaveOppCon()
    {
        List<OpportunityContactRole>lstOpp1 = new List<OpportunityContactRole>();
        List<OpportunityContactRole>lstOpp2 = new List<OpportunityContactRole>();
        System.Debug('selectedcon=======>' +selectedcon);
        id Oprid = ApexPages.currentPage().getParameters().get('oppid');
        System.Debug('selectedcon=======>' +Oprid);
        //selectedcon='003g000001XoC26AAF';
        if(selectedcon==null || selectedcon==''){
            for(OpportunityContactRole op:[Select Id,ContactId,Contact.MQL_Flag_Contact__c,Role,IsPrimary FROM OpportunityContactRole Where OpportunityId =:Oprid])
                
            {
                if(op.IsPrimary==true){
                    selectedcon=op.ContactId;
                  }
            }
        }
        System.Debug('mqlWrap=======>' +mqlWrap);
        //====changed by Nagaraju===
        system.debug('selectedcon -->' + selectedcon); 
        if(mqlWrap!=NULL){
            for(MQLwrapper ocr: mqlWrap){
                system.debug('OCR -->' + ocr); 
                system.debug('selectedcon -->' +selectedcon);
                if(ocr.oc.ContactId !=NULL && selectedcon!=''){
                    system.debug('ContactId -->' + ocr.oc.ContactId);
                    system.debug('OpportunityId -->' + ocr.oc.OpportunityId); 
                    system.debug('selectedcon -->' +selectedcon); 
                    id primaryConId=selectedcon;
                    if(ocr.oc.ContactId ==primaryConId){
                        
                        if(ocr.oc.OpportunityId!= NULL){ 
                            system.debug('selectedcon -->' + selectedcon); 
                            ocr.oc.IsPrimary = true; 
                           // ocr.oc.Role = 'Opportunity Contact';
                            lstOpp1.add(ocr.oc);
                        }system.debug('>>lstOpp1>>'+lstOpp1);
                        
                        if(ocr.oc.OpportunityId== NULL){
                            System.Debug('==mqlWrap=======>' +ocr.oc.OpportunityId );
                            ocr.oc.IsPrimary = true;
                            ocr.oc.OpportunityId = Oppid; 
                           // ocr.oc.Role = 'Opportunity Contact';
                            Opp.ContactRole__c = ocr.oc.Opportunity.ContactRole__c;
                            lstOpp2.add(ocr.oc);
                        }
                    }else{
                        system.debug('i am in else part'); 
                        if(ocr.oc.ContactId !=NULL && ocr.oc.OpportunityId==null){
                            
                            system.debug('=Oppid=>'+Oppid);
                            system.debug('=selectedcon=>'+selectedcon);
                            ocr.oc.IsPrimary= false;
                            lstOpp1.add(ocr.oc);
                        }
                        //==new condition=
                        if(ocr.oc.ContactId !=NULL && ocr.oc.OpportunityId!=null){
                            
                            system.debug('=Oppid=>'+Oppid);
                            system.debug('=selectedcon=>'+selectedcon);
                            ocr.oc.IsPrimary= false;
                            Opp.ContactRole__c = ocr.oc.Opportunity.ContactRole__c;  
                           // ocr.oc.Role = 'Opportunity Contact';
                            lstOpp1.add(ocr.oc);
                        }
                        system.debug('>>lstOpp1.1>>'+lstOpp1);
                    }
                }
                /*else if(selectedcon==null){
ocr.oc.IsPrimary=true;
ocr.oc.OpportunityId = Oppid; 
// ocr.Opportunity.ContactRole__c = '';
lstOpp1.add(ocr.oc);
system.debug('=lstOpp1=>'+lstOpp1);
if(ocr.oc.OpportunityId !=NULL){
ocr.oc.IsPrimary = true;
lstOpp1.add(ocr.oc);
}
system.debug('>>lstOpp1.2>>'+lstOpp1);
if(ocr.oc.OpportunityId == NULL){
ocr.oc.IsPrimary = true;
ocr.oc.OpportunityId = Oppid; 
//Opp.ContactRole__c = ocr.oc.ContactRole__c;                            
lstOpp2.add(ocr.oc);
}
}*/
                else{  
                    if(ocr.oc.ContactId !=NULL && selectedcon==''){
                        
                        //ocr.oc.IsPrimary=true;
                        //ocr.oc.OpportunityId = Oppid; 
                        // ocr.Opportunity.ContactRole__c = '';
                        //lstOpp1.add(ocr.oc);
                        system.debug('=lstOpp1=>'+lstOpp1);
                        if(ocr.oc.OpportunityId !=NULL){
                            //ocr.oc.IsPrimary = true;
                            //ocr.oc.Role = 'Opportunity Contact';
                            lstOpp1.add(ocr.oc);
                        }
                        system.debug('>>lstOpp1>>'+lstOpp1);
                        if(ocr.oc.OpportunityId == NULL){
                            //ocr.oc.IsPrimary = true;
                            ocr.oc.OpportunityId = Oppid; 
                            //Opp.ContactRole__c = ocr.oc.ContactRole__c;                            
                            //Opp.ContactRole__c = ocr.oc.Opportunity.ContactRole__c;  
                            lstOpp2.add(ocr.oc);
                        }
                        system.debug('>>lstOpp2>>'+lstOpp2);
                    }
                }
                System.Debug('lstOpp2>>' +lstOpp2);
                if(ocr.oc.OpportunityId== NULL && ocr.oc.ContactId !=NULL ){
                    if(ocr.oc.IsPrimary==true)ocr.oc.IsPrimary = true;
                    if(ocr.oc.IsPrimary==false)ocr.oc.IsPrimary= false;
                    ocr.oc.OpportunityId = Oppid; 
                   // ocr.oc.Role = 'Opportunity Contact';
                    Opp.ContactRole__c = ocr.oc.Opportunity.ContactRole__c;
                    lstOpp2.add(ocr.oc);
                }
            }
            
            
        }
        
        //=====end===
        
        if(lstOpp1.size() > 0)
        {          
            upsert lstOpp1;
        }
        // System.Debug('lstOpp2>>' +lstOpp2);
        if(lstOpp2.size() > 0)
        {
            upsert lstOpp2;
        } 
        
        PageReference oppConSave = new PageReference('/'+opp.Id);
        oppConSave.setRedirect(true);            
        return oppConSave ;
    } 
    
    public class MQLwrapper{
        public OpportunityContactRole oc{get; set;}
        public TEMarketing__MQLRecord__c tMQL{get; set;}
        public MQLwrapper(OpportunityContactRole ocr, TEMarketing__MQLRecord__c tm){
            oc=ocr;
            tMQL=tm;
            //selected= false;
        }
    }
    
    
}