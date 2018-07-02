/**
 *  This class is used to Calculate Opportunity DGI value.
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
global class ClsBatch_calculateDGIIndicator implements Database.Batchable<SObject>,Database.Stateful {
    
    global string ERROR;
    global string filter;
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        string query = 'select Id from Opportunity';
        query += (filter != null) ? filter : '';
        return Database.getQueryLocator(query); 
    }
    
    global void execute(Database.BatchableContext BC, list<Opportunity> scope){
        set<Id> set_oppyIds = new set<Id>();
        for(Opportunity oppy : scope) {
            set_oppyIds.add(oppy.Id);
        }
        
        map<Id, set<string>> map_oppyId_set_GDIs = new map<Id, set<string>>();
        List<Opportunity> list_oppys = new List<Opportunity>();
        
        for(Opportunity_Part__c op : [select Id, Name, GPL__c, GPL__r.GDI_Classification__c, 
                                        Opportunity__c 
                                        from Opportunity_Part__c 
                                        where Opportunity__c IN : set_oppyIds]) {
            if(op.GPL__c != null) {
                if(!map_oppyId_set_GDIs.containsKey(op.Opportunity__c)) {
                    map_oppyId_set_GDIs.put(op.Opportunity__c, new set<string>());
                }
                map_oppyId_set_GDIs.get(op.Opportunity__c).add(op.GPL__r.GDI_Classification__c);
            }
        }
        
        for(Opportunity opp : [select Id, DGI_Value__c from Opportunity where Id IN: set_oppyIds]) {
            if(map_oppyId_set_GDIs.containsKey(opp.Id)) {
                if(map_oppyId_set_GDIs.get(opp.Id).contains('Invest')) {
                    opp.DGI_Value__c = 'Invest';
                } else if(map_oppyId_set_GDIs.get(opp.Id).contains('Grow')) {
                    opp.DGI_Value__c = 'Grow';
                } else {
                    opp.DGI_Value__c = 'None';
                }
            }else {
                opp.DGI_Value__c = 'None';
            }
            list_oppys.add(opp);
        }
        if(list_oppys.size() > 0) {
            List<Database.SaveResult> srList = database.update(list_oppys, false);
            for (integer i = 0; i < srList.size(); i++) {
                if (!srList.get(i).isSuccess()) {
                    if(ERROR == null) {
                        ERROR = 'The following opportunities has calculated failure: </br>';
                    }
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
        if(UserInfo.getUserId() != null){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(UserInfo.getUserId());
            mail.setToAddresses(new list<string>{'jinbo.shan@itbconsult.com', 'bin.yu@itbconsult.com'});
            mail.setSubject('Calculating all opportunities DGI values that is completed.');
            
            if(ERROR == null) {
            	ERROR = 'Congratulations!';
            }
            
            string htmlBody = ERROR;
            mail.setHtmlBody(htmlBody);
            
            mail.setSaveAsActivity(false); //If "yes" Activity will be created for Visit Report, If "no" no Activity will be created
            mail.setUseSignature(false); //Sender Signature from SFDC           
			if(!test.isRunningTest()) {         
            	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        	}
        }
        
    }
    
}