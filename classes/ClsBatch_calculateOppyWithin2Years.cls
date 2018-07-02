/**
 *  This class is used to Calculate the field "Created_Within_2_Years__c" for Oppoetunity.
 *  
 * @author Jinbo Shan
 * @created 2014-06-24
 * @version 1.0
 * @since 29.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2014-06-24 Jinbo Shan <jinbo.shan@itbconsult.com>
 * - Created   
 *
 */
global class ClsBatch_calculateOppyWithin2Years implements Database.Batchable<SObject>,Database.Stateful{
    
    //global set<Id> set_rtIds = new set<Id>();
    global boolean hasCalculated;
    global DateTime monthsAgo;
    global string ERROR;
    global string SUCCESS;
    global integer errorNum;
    global static boolean isRunningBatch = false;
    global string filter = '';
    
    global ClsBatch_calculateOppyWithin2Years() {
        errorNum = 0;
        string rtids = '';
        Integer months = 0;
        for(Oppy_Created_Config__c occ : Oppy_Created_Config__c.getAll().values()) {
            if(occ.Months__c != null) {
                months = occ.Months__c.intValue();
            }
            hasCalculated = occ.Default_Value__c;
        }
        //set_rtIds = ClsPMV_Util.getAllPMVRecordtypes();
        monthsAgo = system.now().addMonths(-months);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'select Id, Created_Within_2_Years__c, CreatedDate from Opportunity '
                        + 'where ((Created_Within_2_Years__c = :hasCalculated '
                        + 'and CreatedDate <= :monthsAgo) or (Created_Within_2_Years__c != :hasCalculated and CreatedDate > :monthsAgo))';
        if(filter != '') {
        	query += filter;
        }
        system.debug('**@@ query = ' + query);
        return Database.getQueryLocator(query); 
    }
    
    global void execute(Database.BatchableContext BC, list<Opportunity> scope){
        list<Opportunity> list_oppys = new list<Opportunity>();
        for(Opportunity oppy : scope) {
            if(oppy.CreatedDate <= monthsAgo) {
                oppy.Created_Within_2_Years__c = !hasCalculated;
            }else {
                oppy.Created_Within_2_Years__c = hasCalculated;
            }
            
            list_oppys.add(oppy);
        }
        isRunningBatch = true;
        if(list_oppys.size() > 0) {
            List<Database.SaveResult> srList = database.update(list_oppys, false);
            for (integer i = 0; i < srList.size(); i++) {
                if (srList.get(i).isSuccess()) {
                    if(SUCCESS == null) {
                        SUCCESS = 'Successfully Calculated Opportunity. Opportunity ID: </br>';
                    }
                    SUCCESS += srList.get(i).getId() + '</br>';
                }
                else {
                    if(ERROR == null) {
                        ERROR = 'The following opportunities has calculated failing: </br>';
                    }
                    errorNum ++;
                    ERROR += list_oppys.get(i).Id + ': ';
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
        if(UserInfo.getUserId() != null && (ERROR != null || SUCCESS != null) ){
            if(ERROR == null) {
                ERROR = '';   
            }
            if(SUCCESS == null) {
                SUCCESS = '';
            }
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(UserInfo.getUserId());
            mail.setToAddresses(new list<string>{'jinbo.shan@itbconsult.com', 'bin.yu@itbconsult.com', 'jason.lucas@itbconsult.com', 'michael_ludwig@te.com', 'manuel.goetz@itbconsult.com'});
            mail.setSubject('Calculating all opportunities that are created in the last 24 months or not is completed.');
            system.debug('**@@ ERROR = ' + ERROR);
            string htmlBody = SUCCESS + '</br></br> We got the error is ' + errorNum + ':</br>' + ERROR;
            mail.setHtmlBody(htmlBody);
            
            mail.setSaveAsActivity(false); //If "yes" Activity will be created for Visit Report, If "no" no Activity will be created
            mail.setUseSignature(false); //Sender Signature from SFDC           
            if(!test.isRunningTest()){
            	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
    }
}