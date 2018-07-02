/**
 *  This class is used to populate the sales period in bbb monthly records
 *  
 * @author 
 * @created 2012-10-19
 * @version 1.0
 * @since 23.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2012-10-19 Min Liu<min.liu@itbconsult.com>
 * - Created   
 *
 */
global class ClsBatch_PopulateSalesPeriod implements Database.Batchable<SObject>{
	/**
     * the email address to tell people the status of the batch class after run the batch class
     * before run the batch class, we can define the email manual
     * if not define email address, after the batch completed, will not send email
    */ 
    public String email;       
    public String filter;
    
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        String query;   
        query = 'SELECT id, Sales_Period__c, Fiscal_Year__c, Fiscal_Month__c FROM BBB_Month_Bill_Book_Cust__c WHERE Monthly_BBB_External_Key__c = null ';       
        if(filter != null) query += filter;
        return Database.getQueryLocator(query);  
    }
    
    global void execute(Database.BatchableContext BC, List<BBB_Month_Bill_Book_Cust__c> list_bbbMonthly){
    	for(BBB_Month_Bill_Book_Cust__c bbbM :list_bbbMonthly){
    		bbbM.Sales_Period__c = ClsBudgetPlanningUtil.salesPeriodDate(bbbM.Fiscal_Year__c, bbbM.Fiscal_Month__c);
    	}
    	// update bbbMonthly
    	update list_bbbMonthly;
    }
    global void finish(Database.BatchableContext BC){ 
    	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    	if(email != null) {           
            mail.setToAddresses(new String[] {email});            
        } 
        else{
            User currentUser = [Select email from User where id = :UserInfo.getUserId() limit 1];
            mail.setToAddresses(new String[] {currentUser.email});
            
        }
        mail.setReplyTo(Email);
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Batch Processing ClsBatch_PopulateSalesPeriod Completed');
        mail.setPlainTextBody('Batch Processing ClsBatch_PopulateSalesPeriod has completed');
        //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
    }
}