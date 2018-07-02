/**
 *  A batch job for Yearly billing monthly amount.
 *  
 * @author Jinbo Shan
 * @created 2014-11-03
 * @version 1.0
 * @since 30.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 *
 * 2014-11-03 Jinbo Shan <jinbo.shan@itbconsult.com>
 * - Created   
 *
 */
global class Cls_BatchCalculateMonthlyAmount implements Database.Batchable<SObject>,Database.Stateful {
    
    global Date currentDate;
    global String currentYear;
    global Integer currentMonth;
    global string filter;
    global set<Id> set_lockRecordIds;
    global String ERROR;
    global Integer errorNum;
    
    public static final map<String, Integer> MAP_MONTHLABELNUMBER = new map<String, Integer>{
        'Jan' => 4, 'Feb' => 5, 'Mar' => 6, 'Apr' => 7, 'May' => 8, 'Jun' => 9,
        'Jul' => 10, 'Aug' => 11, 'Sep' => 12, 'Oct' => 1, 'Nov' => 2, 'Dec' => 3
    };
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        set<Id> set_lockIds = new set<Id>();
        if(set_lockRecordIds != null) {
            set_lockIds = set_lockRecordIds.clone();
        }
        set_lockRecordIds = new set<Id>();
        if(currentDate == null) {
            currentDate = system.today();
        }
        //get the last Month and corresponding to year.
        for (Period period : [select Id, FiscalYearSettings.Name, PeriodLabel 
                            from Period where StartDate <= :currentDate and EndDate >=:currentDate and Type = 'Month']) {
            if(period.FiscalYearSettings.Name != null){ //set current year
                currentYear = period.FiscalYearSettings.Name;
            }
            if(period.PeriodLabel != null && MAP_MONTHLABELNUMBER.containsKey(period.PeriodLabel)){ //set current month
                currentMonth = MAP_MONTHLABELNUMBER.get(period.PeriodLabel);
            }                       
        }
        if(currentMonth == 1) {
            currentMonth = 12;
            currentYear = Integer.valueOf(currentYear) - 1 + '';
        }else {
            currentMonth = currentMonth - 1;
        }
        
        string query = 'select Bill_Year_to_Date_Amount_Document__c, Billings_Month_1__c, ' + 
                        'Billings_Month_10__c, Billings_Month_11__c, Billings_Month_12__c, ' + 
                        'Billings_Month_2__c, Billings_Month_3__c, Billings_Month_4__c, ' + 
                        'Billings_Month_5__c, Billings_Month_6__c, Billings_Month_7__c, ' + 
                        'Billings_Month_8__c, Billings_Month_9__c ' + 
                        'from BBB_Year_Bill_Book_Cust_PN__c where Year__c = : currentYear ' + 
                        'and Bill_Year_to_Date_Amount_Document__c != null ';
        if(filter != null) {
            query += 'and ' + filter + ' ';
        }
        if(set_lockIds.size() > 0) {
            query += 'and Id IN :set_lockIds ';
        }
        query += 'order by Customer__c, Part__c';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, list<BBB_Year_Bill_Book_Cust_PN__c> list_ybillings) {   
        
        list<BBB_Year_Bill_Book_Cust_PN__c> list_yearbills = new list<BBB_Year_Bill_Book_Cust_PN__c>();
        
        for(BBB_Year_Bill_Book_Cust_PN__c ybbcp : list_ybillings) {
            if(currentMonth != null) {
                decimal currentMonthBilling = 0;
                if(ybbcp.Bill_Year_to_Date_Amount_Document__c != null) {
                    currentMonthBilling = ybbcp.Bill_Year_to_Date_Amount_Document__c;
                }
                string apiName;
                string currentFieldApiName = 'Billings_Month_' + currentMonth + '__c';
                for(Integer i = 12; i > 1; i--) {
                	if(i <= currentMonth) {
            			apiName = 'Billings_Month_' + (i-1) + '__c';
                        if(ybbcp.get(apiName) != null) {// && currentMonthBilling > decimal.valueOf(string.valueOf(ybbcp.get(apiName)))
                            currentMonthBilling = currentMonthBilling - decimal.valueOf(string.valueOf(ybbcp.get(apiName)));
                        }
                	}else {
                		ybbcp.put('Billings_Month_' + i + '__c', null);
                	}
                }
                ybbcp.put(currentFieldApiName, currentMonthBilling);
                list_yearbills.add(ybbcp);
            }
        }
        if(list_yearbills.size() > 0) {
            Database.SaveResult[] srList = Database.update(list_yearbills, false);
    
            // added by Jinbo Shan 2014-10-28
            for (integer i = 0; i < srList.size(); i++) {
                if (srList.get(i).isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                }
                else {
                    // Operation failed, so get all errors 
                    boolean isLockRecord = false;
                    for(Database.Error err : srList.get(i).getErrors()) {    
                        if((err.getStatusCode() + '').contains('UNABLE_TO_LOCK_ROW')) {
                            set_lockRecordIds.add(list_yearbills.get(i).Id);
                            isLockRecord = true;
                            break;
                        }
                    }
                    if(!isLockRecord) {
                        
                        ERROR = (ERROR == null) ? 'The following month billing has calculated failing: </br>' : ERROR;
                        errorNum = (errorNum == null) ? 0 : errorNum;
                        errorNum ++;
                        ERROR += list_yearbills.get(i).Id + ': ';
                        for(Database.Error err : srList.get(i).getErrors()) {  
                            ERROR += err.getStatusCode() + ': ' + err.getMessage() + '</br>';
                        }
                    }
                }
            }
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        if(set_lockRecordIds != null && set_lockRecordIds.size() > 0) {
            Cls_BatchCalculateMonthlyAmount cls = new Cls_BatchCalculateMonthlyAmount();
            cls.set_lockRecordIds = set_lockRecordIds;
            cls.currentDate = currentDate;
            database.executeBatch(cls);
        }
        if(UserInfo.getUserId() != null && ERROR != null){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(UserInfo.getUserId());
            mail.setToAddresses(new list<string>{'jinbo.shan@itbconsult.com'});
            mail.setSubject('Calculating monthly amount for current fisical month is completed.');
            system.debug('**@@ ERROR = ' + ERROR);
            string htmlBody = 'We got the error is ' + errorNum + ':</br>' + ERROR;
            mail.setHtmlBody(htmlBody);
            
            mail.setSaveAsActivity(false); //If "yes" Activity will be created for Visit Report, If "no" no Activity will be created
            mail.setUseSignature(false); //Sender Signature from SFDC           
            if(!test.isRunningTest()){
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
    }
    
}