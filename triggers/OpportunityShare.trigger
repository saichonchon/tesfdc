trigger OpportunityShare on Opportunity (after insert ,after update) {

    //List<RecordType> opRTList =[SELECT DeveloperName,Name,SobjectType FROM RecordType where Sobjecttype='Opportunity' and (DeveloperName ='Sales_Opportunity_CSD' or DeveloperName ='Engineering_Opportunity_CSD')];
     //Map<Id, RecordType> RTMap = new Map<Id, RecordType>();
     //Map<Id, RecordType> opRTMap = new Map<Id, RecordType>();
     //List<RecordType> RTList = [Select id, name from Recordtype where Sobjecttype='Account'];
     List<OpportunityShare> oppShareList = new List<OpportunityShare>();
     //RTMap.putall(RTList);
     //opRTMap.putall(opRTList);
     Set<id> oppidSet = new Set<id>();
     Map<id, Opportunity> oldMap = Trigger.oldMap;
     Map<id, Opportunity> newMap =Trigger.newMap;
     Set<id> aidset = new Set<id>();
     List<Account> accList  = new List<Account>();
      Map<id, Account> aidRecMap = new Map<id,Account>();
     List<Opportunity> tobeProcess = new List<Opportunity>();
     set<id> oldaccIdSet = new Set<id>();
     Map<id, String> OptyRTMap = new Map<Id, String>();
     Map<String, Consumer_Device_Opportunity_Record_Types__c> ConsumerMap = Consumer_Device_Opportunity_Record_Types__c.getall();
     Map<String, Opportunity_Record_Type_Groups__c> OppRtMap = Opportunity_Record_Type_Groups__c.getall(); //DND
     OptyRTMap.put(ConsumerMap.get('Engineering Opportunity-CSD').Record_Type_Id__c, ConsumerMap.get('Engineering Opportunity-CSD').Name);
     OptyRTMap.put(ConsumerMap.get('Sales Opportunity-CSD').Record_Type_Id__c, ConsumerMap.get('Sales Opportunity-CSD').Name);
     if(OppRtMap.get('DND Opportunity')!=null)OptyRTMap.put(OppRtMap.get('DND Opportunity').RecordTypeID__c,OppRtMap.get('DND Opportunity').Name); //DND
     for(Opportunity opp:Trigger.new){
        //if(opp.OEM_Name__c != null && (opp.recordTypeId == label.Sales_Opportunity_CSD || opp.recordTypeId == label.Engineering_Opportunity_CSD) ){
        // Added DND Opportunity record type for DND merge project Padmaja Dadi 06/09/2015
        if(opp.OEM_Name__c != null && (OptyRTMap.containskey(opp.recordTypeId))){    
            if(Trigger.isupdate)
            {
                if(oldMap.get(opp.id).OEM_Name__c != opp.OEM_Name__c){
                    tobeProcess.add(opp);
                    aidset.add(opp.OEM_Name__c);
                    oldaccIdSet.add(oldMap.get(opp.id).OEM_Name__c);
                    oppidSet.add(opp.id);
                }
            }
            else if(Trigger.isinsert)
            {
                tobeProcess.add(opp);
                aidset.add(opp.OEM_Name__c);
            }
        }
    }
     
     if(aidset != null && aidset.size()>0)
     accList = [Select id, Account_Manager__c from Account where id in :aidset];
     
     if(accList != null && accList.size()>0)
     {
        aidRecMap.putAll(accList);
        
     }
     
    for(Opportunity opp: tobeProcess){
            
        if(aidRecMap.containskey(opp.OEM_Name__c) )
        {
             if(aidRecMap.get(opp.OEM_Name__c).Account_Manager__c != null )
             {
                 OpportunityShare os = new OpportunityShare();
                 os.OpportunityAccessLevel  = 'Read';
                 os.OpportunityId  = opp.id;             
                 os.UserOrGroupId =  aidRecMap.get(opp.OEM_Name__c).Account_Manager__c ; 
                 System.debug('****os.UserOrGroupId**********' + os.UserOrGroupId);             
                 oppShareList.add(os);
             }
        }
        
    }
    if(oppShareList != null && oppShareList.Size()>0){
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
    if(oppidSet != null && oppidSet.size()>0){
        
        if(oldaccIdSet != null && oldaccIdSet.size()>0)
        {
            Set<id> uidset = new Set<id>();
            for(Account acc:[Select id, Account_Manager__c from Account where id in :oldaccIdSet])
            {
                if(acc.Account_Manager__c != null )
                uidset.add(acc.Account_Manager__c);
            }
            if(uidset != null && uidset.size()>0)
            {
                List<OpportunityShare> oppSharetobeDel = [SELECT Id,OpportunityAccessLevel,OpportunityId,UserOrGroupId FROM OpportunityShare where OpportunityId in:oppidSet and UserOrGroupId in :uidSet];
                if(oppSharetobeDel != null && oppSharetobeDel.size()>0){
                    if(!(Test.isRunningTest())){
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
            }
        }
    }
     
     

}