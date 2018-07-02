/**
 *  A batch job to refresh BBB Monthly. 
 *  
 * @author Bin Yu
 * @created 2012-10-24
 * @version 1.0
 * @since 25.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2012-10-24 Bin Yu <bin.yu@itbconsult.com>
 * - Created   
 *
 */
global class ClsBatch_refreshBBBMonthly implements Database.Batchable<SObject> {
    /**
     * the sql query statement that will select the data will be used in this batch class
     */     
	public String query;
	public String filter;
 	public String email;
 	
   	global Database.QueryLocator start(Database.BatchableContext BC){ 
        if (query == '' || query == null){
            query = 'select id,Original_Budget__c, Budget__c,CurrencyIsoCode,Budget_TBR_NY__c, Budget_Document_Currency__c, Customer__c, Fiscal_Year__c, Fiscal_Month__c, Bill_Type__c from BBB_Month_Bill_Book_Cust__c where Monthly_BBB_External_Key__c = null';
        }
        if(filter != null) query += filter;
        return Database.getQueryLocator(query);   
    }

    global void execute(Database.BatchableContext BC, list<BBB_Month_Bill_Book_Cust__c> scrope){   
    }

    global void finish(Database.BatchableContext BC){ 
        
        if(email != null) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] {email});
            mail.setReplyTo(Email);
            mail.setSenderDisplayName('Batch Processing');
            mail.setSubject('Batch Processing ClsBatch_recalculateOppyRevenue Completed');
            mail.setPlainTextBody('Batch Processing ClsBatch_recalculateOppyRevenue has completed');
            //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
        } 
        else{
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            User currentUser = [Select email from User where id = :UserInfo.getUserId() limit 1];
            mail.setToAddresses(new String[] {currentUser.email});
            mail.setReplyTo(Email);
            mail.setSenderDisplayName('Batch Processing');
            mail.setSubject('Batch Processing ClsBatch_recalculateOppyRevenue Completed');
            mail.setPlainTextBody('Batch Processing ClsBatch_recalculateOppyRevenue has completed');
            //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
        }
    }    
}