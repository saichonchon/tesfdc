/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
 /* changed the accounts name manually to control duplication
    2014-09-18 Harinath Chittala <harinath.chittala@te.com> */  
    
@isTest(SeeAllData=false) 
private class ClsBatch_OEM_DailyBBBSummary_test {

    static testMethod void testDailyBBBBatch1() {
        
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        
        account a = clstesthelp.createTestAccounts();
        a.AccountNumber ='0000:10000000';
        a.WWCORPACCT__c ='00000200';
        a.BillingCountry='CN';
        a.Account_Manager__c = UserInfo.getUserId();
        a.OwnerId = UserInfo.getUserId();
        insert a;
                
        Product_Hierarchy__c prodH = new Product_Hierarchy__c(Name = 'A00', CBC1__c = '99999', CBC1_Description__c = 'Test Produce Hierarchy');
        insert prodH;
                
        Part__c part1 = new Part__c(Name = '0123456879', Product_Hierarchy__c = prodH.id);
        insert part1;
        
        OEM_Details__c oemd = new OEM_Details__c(OEM__c = a.Id);
        insert oemd;
        
        OEM_Mapping_Rule__c oemmap = new OEM_Mapping_Rule__c(OEM__c = oemd.Id, Allocation__c = 100, Sold_To_Account_Code__c = '12345678', Type__c = 'Customer');
        insert oemmap;

        
        BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c bbbDay = new BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c(Backlog_Amount_USD__c = 10, Bill_Amount_USD__c = 10, Book_Amount_USD__c = 10, Customer__c = a.Id, Fiscal_Year__c = '2015', Fiscal_Month__c = 9, Customer_Request_Date_Fiscal_Year__c = '2015', Customer_Request_Date_Fiscal_Month__c = 9, Profit_Center__c = 'CSD', Part__c = part1.Id);
        insert bbbDay;
        
        CSD_OEM_Mapping_Daily_BBB__c daymap = new CSD_OEM_Mapping_Daily_BBB__c(Daily_Booking_Billing_Backlog_By_Part__c = bbbDay.Id, CSD_OEM_Mapping__c  = oemmap.Id, need_summary__c = true);
        insert daymap;
        
        Test.startTest();
        
            ClsBatch_OEM_DailyBBBSummary oem = new ClsBatch_OEM_DailyBBBSummary();
            ID batchprocessid = Database.executeBatch(oem);
        
        Test.stopTest();
    }
}