/**
 * 
 *   This batch class is used to migrate PMV record type
 *
 * @author      Jinbo Shan
 * @created     2014-04-11
 * @since       29.0     
 * @version     1.0                                                                
 * 
 * @changelog
 * 2014-04-11 Jinbo Shan <jinbo.shan@itbconsult.com>
 * - Created
 *    
 */
global class BatchCls_PMVRecordTypeMigration implements Database.Batchable<SObject>, Database.Stateful{
    
    global map<string, string> map_stage_status = new map<string, string>(); 
    global Id engOppyRTId;
    global map<String, String> map_recordType_PMVRT = new map<String, String>();
    global map<Id, set<Id>> map_spId_set_stageIds = new map<Id, set<Id>>();
    global map<Id, Id> map_rtId_bpId = new map<Id,Id>();
    global map<Id, decimal> map_stageId_order = new map<Id, decimal>();
    global decimal wonSortOrder = 100;
    global string errorMsg;
    global String succMsg;
    global decimal i;
    
    global BatchCls_PMVRecordTypeMigration(){
        i = 0;
        map_stage_status.put('New', 'New');
        map_stage_status.put('In Approval', 'G0 in Approval');
        map_stage_status.put('Rejected', 'G0 Rejected');
        map_stage_status.put('Approved/Active', 'G0 Approved');
        map_stage_status.put('won/open', 'G0 Approved');
        map_stage_status.put('won/closed', 'G0 approved');
        for(RecordType rt : [select Id, DeveloperName from RecordType where DeveloperName = 'Opportunity_Engineering_Project']){
            engOppyRTId = rt.Id;
        }
        
        for(Opportunity_Record_Type_Groups__c rtg: [Select RecordTypeID__c, Migration_Record_Type__c from Opportunity_Record_Type_Groups__c where Active__c = true and Group__c = 'PMV' and Migration_Record_Type__c != null and RecordTypeID__c != null]){
            for(String r : rtg.Migration_Record_Type__c.split(',')){
                if(r!=null && r.trim() != ''){
                    map_recordType_PMVRT.put(r.substring(0,15), rtg.RecordTypeID__c);
                }
            }
        }
        
        for(OpportunityStage os : [select Id, SortOrder, MasterLabel from OpportunityStage where IsActive = true]){
            map_stageId_order.put(os.Id, os.SortOrder);
            if(os.MasterLabel == 'Won'){
                wonSortOrder = os.SortOrder;
            }
        }
        system.debug('map_recordType_PMVRT: ' + map_recordType_PMVRT);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, RecordTypeId, OwnerId, StageName, Approval_Status_PMV__c , PMV_Migration_Setup__c, PMV_Type__c, Pause_Reactivation_Date__c FROM Opportunity WHERE PMV_Migration_Setup__c != null and RecordTypeId in :map_recordType_PMVRT.keySet() and StageName != 'In Approval']);
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> scope){
        ClsPMV_Util.isRunningMigration  = true;
        list<Opportunity> list_oppys_int = new list<Opportunity>();
        list<Opportunity> list_oppys_won = new list<Opportunity>();
        list<Opportunity> list_oppys_onhold = new list<Opportunity>();
        set<Id> set_rtIds = ClsPMV_Util.getAllPMVRecordtypes();
        for(Opportunity oppy : scope){
            
            if(engOppyRTId != null && engOppyRTId == oppy.RecordTypeId){ 
                if(map_stage_status.containsKey(oppy.StageName)){
                    oppy.Approval_Status_PMV__c = map_stage_status.get(oppy.StageName);
                }
            }
            else{
                oppy.Approval_Status_PMV__c = 'New';
            }
                        
            if(oppy.PMV_Migration_Setup__c == 'Initiating'){
                list_oppys_int.add(oppy);
            }
            else if(oppy.PMV_Migration_Setup__c == 'Won'){
                oppy.Buying_Cycle__c = 'Implementation';
                if(engOppyRTId != null && engOppyRTId == oppy.RecordTypeId){ //eng. only
                    oppy.Approval_Status_PMV__c = 'G0 Approved';
                }
                list_oppys_won.add(oppy);
            }
            else if(oppy.PMV_Migration_Setup__c == 'OnHold' || oppy.PMV_Migration_Setup__c == 'On Hold'){
                list_oppys_onhold.add(oppy);
                oppy.Pause_Reactivation_Date__c = date.newInstance(2014, 8, 1);
            }
  			oppy.RecordTypeId = map_recordType_PMVRT.get(String.valueOf(oppy.RecordTypeId).subString(0,15));
            
        }
        
        Database.SaveResult[] srListint = new list<Database.SaveResult>();
        Database.SaveResult[] srListWon = new list<Database.SaveResult>();
        Database.SaveResult[] srListOnHold = new list<Database.SaveResult>();
        
        if(list_oppys_int.size() > 0){
            ClsPMV_Util.hasUpdate = false;
            ClsPMV_Util.dontChangeStage = false;        
            srListint = database.update(list_oppys_int, false);     
        }

        if(list_oppys_won.size() > 0){
            ClsPMV_Util.hasUpdate = false;
            ClsPMV_Util.dontChangeStage = false;
            srListWon = database.update(list_oppys_won, false);     
        }

        if(list_oppys_onhold.size() > 0){
            ClsPMV_Util.hasUpdate = false;
            ClsPMV_Util.dontChangeStage = false;
            srListOnHold = database.update(list_oppys_onhold, false);     
        }  
        
        //int
        for (Database.SaveResult sr : srListint) {
            if (!sr.isSuccess()) {
                if(errorMsg == null){
                    errorMsg = 'Following opportunities have not been migrated:</br>';
                }
                errorMsg += sr.getId() + ':</br>';
                i=0;
                for(Database.Error err : sr.getErrors()) {
                    errorMsg += (i++) + '.' + err.getStatusCode() + ':' + err.getMessage() + '</br>';
                }
            }
            else{
                if(succMsg == null){
                    succMsg = 'Following opportunities have been migrated:</br>';
                }
                succMsg += sr.getId() + ':</br>';            
            }
        }
        
        //won
        set<id> set_oppyWonIds = new set<id>();
        list<Quality_Assessment_Answer__c> list_qaas4won = new list<Quality_Assessment_Answer__c>();
        
        for (Database.SaveResult sr : srListWon) {
            if (sr.isSuccess()) {
                set_oppyWonIds.add(sr.getId());
            }else {
                if(errorMsg == null){
                    errorMsg = 'Following opportunities have not been migrated:</br>';
                }
                errorMsg += sr.getId() + ':</br>';
                i=0;
                for(Database.Error err : sr.getErrors()) {
                    errorMsg += (i++) + '.' + err.getStatusCode() + ':' + err.getMessage() + '</br>';
                }
            }
        }
        system.debug('**@@'+set_oppyWonIds);
        system.debug('**@@map_stageId_order'+map_stageId_order);
        for(Quality_Assessment_Answer__c qaa : [select Opportunity__c, Sales_Process_Question_Assignment__r.OpportunityStage__c, Status__c, Sales_Process_Question_Assignment__r.PMV_Type__c, Sales_Process_Question_Assignment__r.BusinessProcess__c from Quality_Assessment_Answer__c where Opportunity__c IN: set_oppyWonIds]){
            qaa.Active__c = true;
            if(map_stageId_order.containsKey(qaa.Sales_Process_Question_Assignment__r.OpportunityStage__c) && map_stageId_order.get(qaa.Sales_Process_Question_Assignment__r.OpportunityStage__c) < wonSortOrder){
                qaa.Status__c = 'Yes';
            }
            list_qaas4won.add(qaa);
        }  
        system.debug('**@@ list_qaas4won'+ list_qaas4won);
        if(list_qaas4won.size() > 0){
            ClsPMV_Util.hasUpdate = false;
            ClsPMV_Util.dontChangeStage = false;
            try{
                update list_qaas4won;
                for(String oid: set_oppyWonIds){
                    if(succMsg == null){
                        succMsg = 'Following opportunities have been migrated:</br>';
                    }
                    succMsg += oid + ':</br>';   
                }                 
            }catch(exception ex){
                if(errorMsg == null){
                    errorMsg = 'Following opportunities have not been migrated:</br>';
                }
                for(String oid: set_oppyWonIds){
                    errorMsg += oid +': </br>';
                }
                errorMsg += ex.getMessage() + '</br>';
            }
            
        }    
        //On Hold
        set<id> set_oppyOnHoldIds = new set<id>();
        list<Opportunity> list_oppy4onHold = new list<Opportunity>();
        for (Database.SaveResult sr : srListOnHold) {
            if (sr.isSuccess()) {
                set_oppyOnHoldIds.add(sr.getId());
            }else {
                if(errorMsg == null){
                    errorMsg += '</br>Following opportunities have not been migrated:</br>';
                }
                errorMsg += sr.getId() + ':</br>';
                i=0;
                for(Database.Error err : sr.getErrors()) {
                    errorMsg += (i++) + '.' + err.getStatusCode() + ':' + err.getMessage() + '</br>';
                }
            }
        }
        
        system.debug('**@@ set_oppyOnHoldIds'+ set_oppyOnHoldIds);
        for(Opportunity oppy : [select Id, StageName from Opportunity where Id IN : set_oppyOnHoldIds]){
            oppy.StageName = 'On Hold';
            list_oppy4onHold.add(oppy);
        }       
        Database.SaveResult[] srList4onHold = new list<Database.SaveResult>();
        if(list_oppy4onHold.size() > 0){
           ClsPMV_Util.hasUpdate = false;
           srList4onHold = database.update( list_oppy4onHold, false);
        }
        
        for (Database.SaveResult sr : srList4onHold) {
            if (!sr.isSuccess()) {
                if(errorMsg == null){
                    errorMsg = 'Following opportunities have not been migrated:</br>';
                }
                errorMsg += sr.getId() + ':</br>';
                i=0;
                for(Database.Error err : sr.getErrors()) {
                    errorMsg += (i++) + '.' + err.getStatusCode() + ':' + err.getMessage() + '</br>';
                }
            }
            else{
                if(succMsg == null){
                    succMsg = 'Following opportunities have been migrated:</br>';
                }
                succMsg += sr.getId() + ':</br>';            
            }
        }
        
    }
    
    global void finish(Database.BatchableContext BC){  
        if(!Test.isRunningTest()){
            try {
                if(UserInfo.getUserId() != null){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setTargetObjectId(UserInfo.getUserId());
                    //mail.setToAddresses(new list<string>{'jinbo.shan@itbconsult.com', 'bin.yu@itbconsult.com'});
                    mail.setSubject('PMV RecordType Migration is completed.');
                    if(succMsg == null){
                        succMsg = '';
                    }
                    if(errorMsg == null){
                        errorMsg = '';
                    }
                    mail.setHtmlBody(succMsg + '</br>' + errorMsg );
        
                    mail.setSaveAsActivity(false); //If "yes" Activity will be created for Visit Report, If "no" no Activity will be created
                    mail.setUseSignature(false); //Sender Signature from SFDC           
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }
            }catch(Exception ex){
                
            }
        }
    }
    
}