/**
 *  This class is used to populate won fiscal date information
 *  
 * @author 
 * @created 2012-11-06
 * @version 1.0
 * @since 23.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2012-11-06 Min Liu<min.liu@itbconsult.com>
 * - Created   
 *
 */
global class ClsBatch_PopulateWonFiscalDate implements Database.Batchable<SObject> {
	/**
     * the email address to tell people the status of the batch class after run the batch class
     * before run the batch class, we can define the email manual
     * if not define email address, after the batch completed, will not send email
    */ 
    public String email;
    public String filter;
    
	global Database.QueryLocator start(Database.BatchableContext BC){ 
        String query;   
        query = 'SELECT Won_Date__c, Won_Fiscal_Month__c, Won_Fiscal_Quarter__c, Won_Fiscal_Year__c, Status__c FROM Opportunity_Part__c where Status__c = \'Won\' AND Won_Date__c != null ';
        if(filter != null) query += filter;
        return Database.getQueryLocator(query); 
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity_Part__c> list_parts){
    	ClsOppyUtil.getAllFiscalQuarter();
    	for(Opportunity_Part__c part :list_parts){
    		// fiscal year
    		part.Won_Fiscal_Year__c = ClsOppyUtil.getForecastYear(part.Won_Date__c);
    		// fiscal quarter
    		String quarter = ClsOppyUtil.getForecastQuarter(part.Won_Date__c);
        	if(quarter != '') part.Won_Fiscal_Quarter__c = '0' + quarter;
        	// fiscal month
        	part.Won_Fiscal_Month__c = ClsOppyUtil.getForecastMonthNum(part.Won_Date__c);
    	}
    	if(!list_parts.isEmpty()) update list_parts;
    }
    
    global void finish(Database.BatchableContext BC){ 
    	/*
        if(email != null) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] {email});
            mail.setReplyTo(Email);
            mail.setSenderDisplayName('Batch Processing');
            mail.setSubject('Batch Processing ClsBatch_recalculateOppyRevenue Completed');
            mail.setPlainTextBody('Batch Processing ClsBatch_recalculateOppyRevenue has completed');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
        } 
        else{
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            User currentUser = [Select email from User where id = :UserInfo.getUserId() limit 1];
            mail.setToAddresses(new String[] {currentUser.email});
            mail.setReplyTo(Email);
            mail.setSenderDisplayName('Batch Processing');
            mail.setSubject('Batch Processing ClsBatch_recalculateOppyRevenue Completed');
            mail.setPlainTextBody('Batch Processing ClsBatch_recalculateOppyRevenue has completed');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
        }
        */
    }
}