/**
 *  This class is used to Calculate Budget with Budget Rates of next year
 *  
 * @author Yinfeng Guo
 * @created 2012-07-09
 * @version 1.0
 * @since 23.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2012-07-09 Yinfeng Guo <yinfeng.guo@itbconsult.com>
 * - Created   
 *
 */
global class ClsBatch_BudgetDetailRateCalculating implements Database.Batchable<SObject>, Database.Stateful{
    public String email;
    public String filter;
    public Integer fiscalYear;
    global map<String, Decimal> map_currencyISOCode_rate;

    public ClsBatch_BudgetDetailRateCalculating(){
        if(fiscalYear == null){
            Date runDate = Date.today();
            for(Period p: [select FiscalYearSettingsId, FiscalYearSettings.Name, PeriodLabel, Number, StartDate, EndDate from Period where type = 'year'  and FiscalYearSettings.IsStandardYear = false order by FiscalYearSettings.Name]){
                if(runDate >= p.StartDate && runDate <= p.EndDate){
                    fiscalYear = Integer.valueOf(p.FiscalYearSettings.Name);
                    break;
                }
            }
        }
        map_currencyISOCode_rate = new map<String, Decimal>();
        for(Budget_Rate__c rate: [SELECT  CurrencyIsoCode, Effective_Date__c, Expiration_Date__c, Rate__c FROM Budget_Rate__c]){
            map_currencyISOCode_rate.put(rate.CurrencyIsoCode, rate.Rate__c);
        }   
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        String query;  
        query = 'select Id,  Account__r.CurrencyISOCode,Budget_TBR_NY__c, Budget_Document_Currency__c,type__c from Budget_Detail__c WHERE Budget__r.Year__c ='+'\''+fiscalYear+'\' and Budget_Document_Currency__c != null ';     //Id= \'a0CM0000003zv4KMAQ\' and
        if(filter != null) query += filter;
        return Database.getQueryLocator(query);  
    }

    global void execute(Database.BatchableContext BC, list<Budget_Detail__c> list_bd){
        list<Budget_Detail__c> list_bd2Update = new list<Budget_Detail__c>();
        
        for(Budget_Detail__c bd : list_bd){
            if(map_currencyISOCode_rate.containsKey(bd.Account__r.CurrencyISOCode)){
                Decimal actualRate = map_currencyISOCode_rate.get(bd.Account__r.CurrencyISOCode);
                if(actualRate != 0 && bd.Budget_Document_Currency__c != null) bd.Budget_TBR_NY__c = bd.Budget_Document_Currency__c/actualRate;
            }
            else bd.Budget_TBR_NY__c = bd.Budget_Document_Currency__c;
            
            list_bd2Update.add(bd);    
        }
        
        if(!list_bd2Update.isEmpty()) update list_bd2Update;
    }

    global void finish(Database.BatchableContext BC){ 
        if(email != null) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] {email});
            mail.setReplyTo(Email);
            mail.setSenderDisplayName('Batch Processing');
            mail.setSubject('Batch Processing ClsBatch_BudgetDetailRateCalculating Completed');
            mail.setPlainTextBody('Batch Processing ClsBatch_BudgetDetailRateCalculating has completed');
            //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
        } 
        else{
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            User currentUser = [Select email from User where id = :UserInfo.getUserId() limit 1];
            mail.setToAddresses(new String[] {currentUser.email});
            mail.setReplyTo(Email);
            mail.setSenderDisplayName('Batch Processing');
            mail.setSubject('Batch Processing ClsBatch_BudgetDetailRateCalculating Completed');
            mail.setPlainTextBody('Batch Processing ClsBatch_BudgetDetailRateCalculating has completed');
            //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
        }
    }

}