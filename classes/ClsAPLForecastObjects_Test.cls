/**
*  This test class used to test class ClsBatch_setBBBDayByPartYearAndMonth.
*
@author Lili Zhao
@created 2014-08-15
*
@changelog
* coverage  84%
*  
2014-08-15 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest
private class ClsAPLForecastObjects_Test {

    static testMethod void myUnitTest() {
    	
    	Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();
        
    	RecordType rt = ClsTestHelp.createTestRecordType6();
    	RecordType rt2 = ClsTestHelp.createTestRecordType8();
    	
    	Consumer_Device_Opportunity_Record_Types__c cdort1 = ClsTestHelp.createTestCSD1();
    	Consumer_Device_Opportunity_Record_Types__c cdort2 = ClsTestHelp.createTestCSD2();
    	Consumer_Device_Opportunity_Record_Types__c cdort3 = ClsTestHelp.createTestCSD3();
    	Consumer_Device_Opportunity_Record_Types__c cdort4 = ClsTestHelp.createTestCSD4();
    	Consumer_Device_Opportunity_Record_Types__c cdort5 = ClsTestHelp.createTestCSD5();
    	Consumer_Device_Opportunity_Record_Types__c cdort6 = ClsTestHelp.createTestCSD6();
    	Consumer_Device_Opportunity_Record_Types__c cdort7 = ClsTestHelp.createTestCSD7();
    	
    	Account acct = ClsTestHelp.createTestAccounts();
    	acct.Name = 'axx';
    	acct.RecordTypeId = rt2.Id;
    	acct.Account_Manager__c = userInfo.getUserId();
    	insert acct;

		
		APL_Sales_Forecast__c aplFC1 = new APL_Sales_Forecast__c();
		aplFC1.type__c = 'GPL';
		aplFC1.customer__c = acct.Id;
    	
    	
        Test.startTest();
        //ClsAPLForecastObjects.newClassInstance('');
        ClsAPLForecastObjects.ForecastSaveBaseObj forecastSaveBaseObj = new ClsAPLForecastObjects.ForecastSaveBaseObj();
        ClsAPLForecastObjects.FCBaseObj fcBaseObj = new ClsAPLForecastObjects.FCBaseObj(); 
        
        ClsAPLForecastObjects.AccountObject accountObject = new ClsAPLForecastObjects.AccountObject();
        accountObject.saveFC(Json.serialize(accountObject), new list<APL_Sales_Forecast__c>());
        
        ClsAPLForecastObjects.CbcObject cbcObject = new ClsAPLForecastObjects.CbcObject();
        cbcObject.cbc2Code = '';
        cbcObject.map_dateKey_fc = new map<String, decimal>();
        cbcObject.saveFC(Json.serialize(cbcObject), new list<APL_Sales_Forecast__c>());
        
        ClsAPLForecastObjects.GplObject gplObject = new ClsAPLForecastObjects.GplObject();
        gplObject.gplId = acct.Id;
        gplObject.cbc2Code = 'test';
        gplObject.list_partFC = new list<ClsAPLForecastObjects.PartObject>();
        gplObject.saveFC(Json.serialize(gplObject), new list<APL_Sales_Forecast__c>());
        
        ClsAPLForecastObjects.OtherCBCObject otherCBCObject = new ClsAPLForecastObjects.OtherCBCObject();
        otherCBCObject.list_partFC = new list<ClsAPLForecastObjects.PartObject>();
        otherCBCObject.saveFC(Json.serialize(otherCBCObject), new list<APL_Sales_Forecast__c>());
        
        ClsAPLForecastObjects.PartObject partObject = new ClsAPLForecastObjects.PartObject();
        partObject.gplId = '';
        partObject.partId = '';
        partObject.saveFC(Json.serialize(partObject), new list<APL_Sales_Forecast__c>());
        Test.stopTest();
    }
}