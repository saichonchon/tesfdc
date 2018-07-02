/**
 *  This test class is for ClsScheduled_recalcBBBMCurrency .
 *
 @author Lili Zhao
 @created 2014-03-07
 @version 1.0
 @since 29.0
 *
 @changelog
 * 2014-03-07 Lili Zhao<bin.yuan@itbconsult.com>
 * - Created
 * - Test coverage 100%
 */
@isTest
private class  ClsSchedule_FrozenFCAndCalcPrevFC_Test {
  static testMethod void testAll() {
  
        DateTime currTime = DateTime.now();
        Integer min = currTime.minute();
        Integer hour = currTime.hour();
        String sch;
        
        if(min <= 58)
            sch = '0 '+ (min + 1) + ' ' + hour + ' * * ? '+ currTime.year();
        else          
            sch = '0 0 '+ (hour + 1) + ' * * ? '+ currTime.year();
        
        Test.startTest();
      
      ClsTestCustomSettingHelper.getFinancialPlanningConfiguration();
      
     	 Date fiscalMonthStartDate;
        for(Period p : [select EndDate, StartDate
                        from Period 
                        where Type = 'Month'
                        and EndDate >=: system.today()
                        and StartDate <=: system.today()]) {
                            
            fiscalMonthStartDate = p.StartDate;             
        }
        Integer Date_Parameter = fiscalMonthStartDate.daysBetween(date.today())+1;

        Financial_Planning_Configuration__c customSetting = Financial_Planning_Configuration__c.getInstance('AM Frozen Date');
        customSetting.Is_Active__c = true;
        customSetting.Date_Parameter__c = string.valueOf(Date_Parameter);
        
        Financial_Planning_Configuration__c customSetting1 = Financial_Planning_Configuration__c.getInstance('RSM Frozen Date');
        customSetting1.Is_Active__c = true;
        customSetting1.Date_Parameter__c = string.valueOf(Date_Parameter);
      
        update new List<Financial_Planning_Configuration__c>{customSetting1, customSetting};
        
        
        ClsSchedule_FrozenFCAndCalcPrevFC obj = new ClsSchedule_FrozenFCAndCalcPrevFC();                
        String jobId = system.schedule('test_Schedule_FrozenFCAndCalcPrevFC', sch, obj); 
    
        system.assert(true);
        Test.stopTest();
    }
}