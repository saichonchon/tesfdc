@isTest

public class AccountOperationsTest {

    @isTest static void testAccountHasDefaultDescription() {       

        // Perform test

        Test.startTest();
   ClsTestCustomSettingHelper.getAllSettings();
            ClsTestCustomSettingHelper.getPMV_Sales_Stage_Setting();
            ChannelinsightData_test.ChannelinsightData_test();
            ClsTestCustomSettingHelper.getTrigger_Configuration();
            ClsTestCustomSettingHelper.getADMTerritoryCode();
        Account acc = new Account();
        acc.Name = 't'+system.now().millisecond()+math.round(math.random()*10000);//Modified by Harinath to get Unique AccountName for each Account.
        acc.AnnualRevenue = 2000000.11; 
        acc.Legally_Restricted__c = false;  
        acc.BillingCity = 'Musterstadt';
        acc.BillingStreet = 'Teststr. 1';
        acc.BillingCountry = 'CN';
        acc.Type = 'Distributor';
        acc.BillingPostalCode = '77777';
        acc.Sales_Hierarchy__c=ClsTestHelp.createTestSalesHierarchy().Id;       
        acc.Industry_Code_Description__c='Industrial';      
        acc.Business_Unit_Level_2__c='Rail';
        acc.AccountNumber = '';
       // return acc;
        //acc.RecordTypeId = rt.Id;
        insert acc;

    }

}