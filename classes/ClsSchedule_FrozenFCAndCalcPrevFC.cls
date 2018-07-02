/**
 *  Schedule class to frozen AM & RSM forecast and calc previous month forecast
 *
 @author    Bin Yuan
 @created   2014-03-27
 @version   1.0
 @since     29.0 (Force.com ApiVersion)
 *
 @changelog
 * 2014-03-27 Bin Yuan <bin.yuan@itbconsult.com>
 * - Created
 */
global class ClsSchedule_FrozenFCAndCalcPrevFC implements Schedulable {
    global void execute(SchedulableContext sc) {
        Date fiscalMonthStartDate;
        for(Period p : [select EndDate, StartDate
                        from Period 
                        where Type = 'Month'
                        and EndDate >=: system.today()
                        and StartDate <=: system.today()]) {
                            
            fiscalMonthStartDate = p.StartDate;             
        }
        // add lili 2014-06-30 begin due to get the add days from custom setting Financial_Planning_Configuration__c
        Integer ASMFiscalMonthStartDate = 21;
        Integer RSMFiscalMonthStartDate = 26;
        // get the ASMFiscalMonthStartDate(22 days) from custom setting Financial_Planning_Configuration__c
        if(Financial_Planning_Configuration__c.getInstance('AM Frozen Date') != null 
            && Financial_Planning_Configuration__c.getInstance('AM Frozen Date').Is_Active__c  
            && Financial_Planning_Configuration__c.getInstance('AM Frozen Date').Date_Parameter__c != null ) { 
            ASMFiscalMonthStartDate = Integer.valueOf(Financial_Planning_Configuration__c.getInstance('AM Frozen Date').Date_Parameter__c);
            ASMFiscalMonthStartDate = (ASMFiscalMonthStartDate > 0 ? ASMFiscalMonthStartDate -1 : ASMFiscalMonthStartDate);
            
        }
        // get the RSMFiscalMonthStartDate(27 days) from custom setting Financial_Planning_Configuration__c
        if(Financial_Planning_Configuration__c.getInstance('RSM Frozen Date') != null 
            && Financial_Planning_Configuration__c.getInstance('RSM Frozen Date').Is_Active__c  
            && Financial_Planning_Configuration__c.getInstance('RSM Frozen Date').Date_Parameter__c != null ) {
                
            RSMFiscalMonthStartDate = Integer.valueOf(Financial_Planning_Configuration__c.getInstance('RSM Frozen Date').Date_Parameter__c);
            RSMFiscalMonthStartDate = (RSMFiscalMonthStartDate > 0 ? RSMFiscalMonthStartDate -1 : RSMFiscalMonthStartDate);
        }
        // end
        //AM forecast freeze  at Fiscal day 22
        // add lili 2014-06-30 begin due to set the 21 to ASMFiscalMonthStartDate begin
        if(fiscalMonthStartDate.addDays(ASMFiscalMonthStartDate) == system.today()) {
            ClsBatch_setLastASMFrozenDate cls= new ClsBatch_setLastASMFrozenDate();
            cls.frozenDate = system.today().addMonths(6);
            ID batchprocessid = Database.executeBatch(cls);
        }
        //RSM Forecast freeze  At Fiscal day 27
        // add lili 2014-06-30 begin due to set the 26 to RSMFiscalMonthStartDate begin
        if(fiscalMonthStartDate.addDays(RSMFiscalMonthStartDate) == system.today()) {
            ClsBatch_setLastRSMFrozenDate cls= new ClsBatch_setLastRSMFrozenDate();
            cls.frozenDate = system.today().addMonths(6);
            ID batchprocessid = Database.executeBatch(cls);
        }
        //Copy previous month forecast  (AM, RSM and GSM)  on day 1 on new fiscal
        if(fiscalMonthStartDate == system.today()) {
            ClsBatch_recalculateAccountForecast cls = new ClsBatch_recalculateAccountForecast();
            ID batchprocessid = Database.executeBatch(cls);
        }
    }
}