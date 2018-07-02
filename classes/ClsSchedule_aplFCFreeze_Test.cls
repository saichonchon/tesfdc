/**
*  This test class used to test class ClsBatch_aplSalesForecastFrozen.
*
@author Lili Zhao
@created 2014-08-15
*
@changelog
* coverage  94%
*  
2014-08-15 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest
private class ClsSchedule_aplFCFreeze_Test {

    static testMethod void myUnitTest() {
    	
    	APL_Forecast_Settings__c aplSetting = new APL_Forecast_Settings__c();	
    	APL_Forecast_Settings__c aplSetting1 = new APL_Forecast_Settings__c();	
    	APL_Forecast_Settings__c aplSetting2 = new APL_Forecast_Settings__c();	
    	APL_Forecast_Settings__c aplSetting3 = new APL_Forecast_Settings__c();	
    	APL_Forecast_Settings__c aplSetting4 = new APL_Forecast_Settings__c();	
		
		
		for(APL_Forecast_Settings__c apl : [select value__c,Name from APL_Forecast_Settings__c where Name = 'AM Unfreeze Setting']) {
			aplSetting = apl;
		}
		if(aplSetting.Name == null ) {
			aplSetting.Name = 'AM Unfreeze Setting';
			aplSetting.Value__c = '15';
			insert aplSetting;
		}
		
		for(APL_Forecast_Settings__c apl : [select value__c,Name from APL_Forecast_Settings__c where Name = 'GAM Unfreeze Setting']) {
			aplSetting1 = apl;
		}
		if(aplSetting1.Name == null ) {
			aplSetting1.Name = 'GAM Unfreeze Setting';
			aplSetting1.Value__c = '19';
			insert aplSetting1;
		}
		
		for(APL_Forecast_Settings__c apl : [select value__c,Name from APL_Forecast_Settings__c where Name = 'RSM Unfreeze Setting']) {
			aplSetting2 = apl;
		}
		if(aplSetting2.Name == null ) {
			aplSetting2.Name = 'RSM Unfreeze Setting';
			aplSetting2.Value__c = '22';
			insert aplSetting2;
		}
		
		for(APL_Forecast_Settings__c apl : [select value__c,Name from APL_Forecast_Settings__c where Name = 'Relay RSM Unfreeze Setting']) {
			aplSetting3 = apl;
		}
		if(aplSetting3.Name == null ) {
			aplSetting3.Name = 'Relay RSM Unfreeze Setting';
			aplSetting3.Value__c = '26';
			insert aplSetting3;
		}
        
        for(APL_Forecast_Settings__c apl : [select value__c,Name from APL_Forecast_Settings__c where Name = 'Freeze All']) {
			aplSetting4 = apl;
		}
		if(aplSetting4.Name == null ) {
			aplSetting4.Name = 'Freeze All';
			aplSetting4.Value__c = String.valueOf(system.today().toStartOfMonth().daysBetween(system.today()) + 1);
			insert aplSetting4;
		}
		
		DateTime currTime = DateTime.now();
        Integer min = currTime.minute();
        Integer hour = currTime.hour();
        String sch;
        
        if(min <= 58)
            sch = '0 '+ (min + 1) + ' ' + hour + ' * * ? '+ currTime.year();
        else          
            sch = '0 0 '+ (hour + 1) + ' * * ? '+ currTime.year();
        
        Test.startTest();
        
        ClsSchedule_aplFCFreeze obj = new ClsSchedule_aplFCFreeze();                
        String jobId = system.schedule('test_ClsSchedule_aplFCFreeze', sch, obj); 
    
        system.assert(true);
        Test.stopTest();
    }
}