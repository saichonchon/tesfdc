/**
 *  A batch job to ReCalculate Oppy Score. 
 *  
 * @author Jinbo Shan
 * @created 2014-07-16
 * @version 1.0
 * @since 30.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2014-07-16 Jinbo Shan <jinbo.shan@itbconsult.com>
 * - Created   
 *
 */
 
 global class ClsBatch_recalculateOppyScore implements Database.Batchable<SObject>,Database.Stateful {
    
    global string filter;
    global set<Id> set_rtIds = ClsPMV_Util.getAllPMVRecordtypes();
    global string ERROR;
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        string query = 'select Id, PMV_Type__c, Score__c, StageName, Buying_Cycle__c, RecordTypeId from Opportunity where RecordTypeId IN :set_rtIds';
        if(filter != null && filter != '') {
            query += filter;
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> list_oppys){   
        
        list<Opportunity> list_oppys4update = new list<Opportunity>();
        
        map<Id,String> map_setting_opId_stageName = new map<Id,String>();
        
        map<Id, Id> map_rtId_bpId = new map<Id, Id>();
        
        for(RecordType rt : [select Id, BusinessProcessId from RecordType where isActive = true]) {
            map_rtId_bpId.put(rt.Id, rt.BusinessProcessId);
        }
        
        for(Opportunity opp:list_oppys){
            for(PMV_Sales_Stage_Setting__c st:PMV_Sales_Stage_Setting__c.getAll().values()){
                if(opp.PMV_Type__c == st.PMV_Type__c && map_rtId_bpId.get(opp.RecordTypeId) == st.Sales_Process_ID__c && opp.Buying_Cycle__c == st.Buyer_Cycle__c){
                    map_setting_opId_stageName.put(opp.Id,st.Sales_Stage__c);
                }
            }
        }
        
        map<String,Integer> map_stageName_sortOrder = new map<String,Integer>();
        for(OpportunityStage os:[Select SortOrder, MasterLabel From OpportunityStage where isActive = true]){
            map_stageName_sortOrder.put(os.MasterLabel, os.SortOrder);
        }
        
        for(Opportunity opp: list_oppys){
            if(!map_setting_opId_stageName.isEmpty() && map_setting_opId_stageName.containsKey(opp.Id)){
                if(map_stageName_sortOrder.get(opp.StageName) >= map_stageName_sortOrder.get(map_setting_opId_stageName.get(opp.Id))){
                    opp.Score__c = 3;
                }else if((map_stageName_sortOrder.get(opp.StageName)) + 1 == map_stageName_sortOrder.get(map_setting_opId_stageName.get(opp.Id))){
                    opp.Score__c = 2;
                }else{
                    opp.Score__c = 1;
                }
            } else {
                opp.Score__c = 1;
            }
            list_oppys4update.add(opp);
        }
        
        if(list_oppys4update.size() > 0) {
            List<Database.SaveResult> srList = database.update(list_oppys4update, false);
            for (integer i = 0; i < srList.size(); i++) {
                if (!srList.get(i).isSuccess()) {
                    if(ERROR == null) {
                        ERROR = 'The following error has occurred: </br>';
                    }
                    ERROR += list_oppys4update.get(i).Id + ': ';
                    // Operation failed, so get all errors                
                    for(Database.Error err : srList.get(i).getErrors()) {                  
                        ERROR += err.getStatusCode() + ': ' + err.getMessage() + '</br>';
                        //System.debug('Account fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
        if(UserInfo.getUserId() != null ){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(UserInfo.getUserId());
            mail.setToAddresses(new list<string>{'jinbo.shan@itbconsult.com', 'bin.yu@itbconsult.com'});
            mail.setSubject('Calculating Opportunities Scores is completed.');
            
            if(ERROR == null) {
            	ERROR = 'Congratulations!';
            }
            
            string htmlBody = ERROR;
            mail.setHtmlBody(htmlBody);
            
            mail.setSaveAsActivity(false); //If "yes" Activity will be created for Visit Report, If "no" no Activity will be created
            mail.setUseSignature(false); //Sender Signature from SFDC  
            if(!test.isRunningTest()){         
            	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
    }
    
 }