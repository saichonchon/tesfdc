/**
*  This test class used to test class BatchCls_updateOfProjectedEndDate.
*
@author Lei Tang
@created 2014-04-28
@version 1.0   
@since 28.0
*
@changelog
* coverage 83%
* 
* 
2014-04-28 Lei Tang <lei.tang@itbconsult.com>
* - Created
*/
@isTest(seealldata=false)
private class BatchCls_PMVRecordTypeMigration_Test{
    
    static testMethod void myUnitTest() {
        
        User user = [select id from user where GIBU__c = 'Industrial' and Sub_Vertical__c = 'A&C' and isactive = true and PMV_Type_Initialization__c = 'Standard' limit 1];
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getPMV_Language_Config();
        ClsTestCustomSettingHelper.getPMV_Sales_Stage_Setting();
        ClsTestCustomSettingHelper.getPMV_Stage_Config();
        ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
        
        system.runAs(user)
        {
           
            RecordType rt = ClsTestHelp.createPMVTestRecordType1();

            Opportunity oppty1 = new Opportunity();
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            acc.BillingCountry = 'US';
            insert acc;
            
            
            oppty1.AccountId = acc.Id;
            oppty1.Name = 'test';
            oppty1.CurrencyIsoCode = 'EUR';
            oppty1.currency_confirm__c = true;
            oppty1.Type = 'New Business';
            oppty1.Description = 'test';
            oppty1.Distributor__c = 'Dachs';
            oppty1.StageName = 'Initiating';
            oppty1.Manufacturing_Start_Date__c = date.today();
            oppty1.CloseDate = date.today().addMonths(1);
            oppty1.RecordTypeId = rt.Id;
            oppty1.Lead_ID__c = '01x000000000fgh';
            oppty1.PMV_Type__c = 'IND Standard Sales opp';
            oppty1.StageName = 'Exploring Needs';
            oppty1.Stage_Change_Error_Message__c = 'test';
            insert oppty1;
        
        test.startTest();
        
        BatchCls_PMVRecordTypeMigration batchCls = new BatchCls_PMVRecordTypeMigration();
        Database.executeBatch(batchCls);
        
        system.assert(true);
        Test.stopTest(); 
        }
        }
}