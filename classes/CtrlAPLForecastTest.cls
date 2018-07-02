/**
 *  Test class for CtrlAPLForecast
 *
 @author    Jason Zang
 @created   2017-11-15
 @version   1.0
 @since     39.0 (Force.com ApiVersion)
 *
 @changelog
 * 2017-11-20 Jason Zang <jason.zang@capgemini.com>
 * - Created
 */
@isTest
public class CtrlAPLForecastTest {
	public static testMethod void testGeneral() {
        Id amRecordTypeId = Schema.SObjectType.APL_Forecast_Management__c.getRecordTypeInfosByName().get('AM').getRecordTypeId();
        Id relayRecordTypeId = Schema.SObjectType.APL_Forecast_Management__c.getRecordTypeInfosByName().get('Relay').getRecordTypeId();
        APL_Forecast_Management__c aplObj1 = new APL_Forecast_Management__c();
        aplObj1.RecordTypeId = amRecordTypeId;
        aplObj1.Manager__c = UserInfo.getUserId();
        aplObj1.A6_Code__c = '1000066';
        upsert aplObj1;
		APL_Forecast_Management__c aplObj2 = new APL_Forecast_Management__c();
        aplObj2.RecordTypeId = relayRecordTypeId;
        aplObj2.Manager__c = UserInfo.getUserId();
        aplObj2.A6_Code__c = '1000077';
        upsert aplObj2;
        Test.startTest();
        CtrlAPLForecast ctrlObj = new CtrlAPLForecast();
        Test.stopTest();
    }
    
    public static testMethod void testGeneral2() {
        Id amRecordTypeId = Schema.SObjectType.APL_Forecast_Management__c.getRecordTypeInfosByName().get('AM').getRecordTypeId();
        Id relayRecordTypeId = Schema.SObjectType.APL_Forecast_Management__c.getRecordTypeInfosByName().get('Relay').getRecordTypeId();
        APL_Forecast_Management__c aplObj1 = new APL_Forecast_Management__c();
        aplObj1.RecordTypeId = amRecordTypeId;
        aplObj1.Manager__c = UserInfo.getUserId();
        aplObj1.A6_Code__c = '1000066';
        upsert aplObj1;
        Test.startTest();
        CtrlAPLForecast ctrlObj = new CtrlAPLForecast();
        Test.stopTest();
    }
}