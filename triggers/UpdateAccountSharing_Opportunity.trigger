trigger UpdateAccountSharing_Opportunity on Account ( after update) {
 
    Map<String, Consumer_Device_Opportunity_Record_Types__c> ConsumerMap=Consumer_Device_Opportunity_Record_Types__c.getall();
    Consumer_Device_Opportunity_Record_Types__c CN=new Consumer_Device_Opportunity_Record_Types__c();
    //Added by Padmaja Dadi for DND merge project on 06/09/2015
    Map<String, Opportunity_Record_Type_Groups__c> DNDMap=Opportunity_Record_Type_Groups__c.getall();
    Opportunity_Record_Type_Groups__c DN=new Opportunity_Record_Type_Groups__c();

    Map<String, String> CustSetsMap=new Map<String, String>();
    CustSetsMap.put(ConsumerMap.get('OEM').Record_Type_Id__c, 'OEM');
    
    Set<Id> RTIdSet=new Set<Id>();
    RTIdSet.add(ConsumerMap.get('Sales Opportunity-CSD').Record_Type_Id__c);
    RTIdSet.add(ConsumerMap.get('Engineering Opportunity-CSD').Record_Type_Id__c);
    //Added by Padmaja Dadi for DND merge project on 06/09/2015
    if(DNDMap.get('DND Opportunity') != null) RTIdSet.add(DNDMap.get('DND Opportunity').RecordTypeID__c);
    System.debug('******RTIdSet********'+RTIdSet);
    List<OpportunityShare> oppShareList = new List<OpportunityShare>();
    Set<id> accidSet  = new Set<id>();   
    Set<id> uidSet = new Set<id>();
    Map<id, Opportunity> oppidRecMap = new Map<id,Opportunity>();
    List<Opportunity> oppList=new List<Opportunity>();
    Map<id,List<Opportunity>> aidOpplistMap = new Map<id, List<Opportunity>>();
     
    for(Account A:trigger.new){          
        
        //if(RTMap.get(A.Recordtypeid).Name=='OEM' && A.Account_Manager__c!=null ){                           
        if(CustSetsMap.get(A.Recordtypeid)=='OEM' && A.Account_Manager__c!=null ){                          
            if(trigger.oldmap.get(A.id).Account_Manager__c != A.Account_Manager__c){
                accidSet.add(A.id);
                if(trigger.oldmap.get(A.id).Account_Manager__c  !=  null)
                uidSet.add(trigger.oldmap.get(A.id).Account_Manager__c);
            }                
        }        
    }
        
    if(accidSet != null && accidSet.size()>0)   
        
       for(Opportunity  tempOpp: [select id,OEM_Name__c,OEM_Name__r.Account_Manager__c   from Opportunity where OEM_Name__c in :accidSet and recordTypeId in :RTIdSet]) 
       oppList.add(tempOpp);
       
       
    if(oppList!= null && oppList.size()>0){
        oppidRecMap.putAll(oppList);
        for(Opportunity opp:oppList){
            if(aidOpplistMap.containskey(opp.OEM_Name__c))
            {
                aidOpplistMap.get(opp.OEM_Name__c).add(opp);
            }
            else{
                aidOpplistMap.put(opp.OEM_Name__c,new List<Opportunity>());
                aidOpplistMap.get(opp.OEM_Name__c).add(opp);
            }
        }
    } 
    if(accidSet != null && accidSet.size()>0){
        
        for(id sid:accidSet){
            if(aidOpplistMap.containskey(sid)){
                 for(Opportunity op: aidOpplistMap.get(sid)){
                     OpportunityShare os = new OpportunityShare();
                     os.OpportunityAccessLevel  = 'Read';
                     os.OpportunityId  = op.id;
                     os.UserOrGroupId =  op.OEM_Name__r.Account_Manager__c ;                     
                     oppShareList.add(os);
                 }
            }                
        }           
            
    }
    List<OpportunityShare> oppSharetobeDel=new   List<OpportunityShare>();
    
     for( OpportunityShare oppShare:[SELECT Id,OpportunityAccessLevel,OpportunityId,UserOrGroupId FROM OpportunityShare where OpportunityId in:oppidRecMap.keyset() and UserOrGroupId in :uidSet])
   oppSharetobeDel.add(oppShare);
   
    if(!(Test.isRunningTest())){   
        if(oppSharetobeDel != null && oppSharetobeDel.size()>0){
            //delete oppSharetobeDel;
            Database.DeleteResult[] drList = Database.delete(oppSharetobeDel, false);
            // Iterate through each returned result
            for(Database.DeleteResult dr : drList) {
                if (dr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully deleted Opportunity with ID: ' + dr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : dr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Opportunity Sharing fields that affected this error: ' + err.getFields());
                    }
                }
            }
            
        }
    }
    if(oppShareList != null & oppShareList.size()>0){
        if(!(Test.isRunningTest())){
            //insert oppShareList;  
            Database.SaveResult[] srList = Database.insert(oppShareList, false);

            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Account fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }
    
    } 
    
    
}