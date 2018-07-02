/**
 *  This test class is used to test ClsBatch_captureBillingWhenbbInsert
 *  
 * @author Mingxing Qiu
 * @created 2016-05-05
 * @version 1.0
 * @since 29.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2015-06-12 Mingxing Qiu <Mingxing Qiu@itbconsult.com>
 * - Created
 *
 */

@isTest
private class ClsBatch_captureBillingWhenbbInsert_Test {

    static testMethod void myUnitTest() {
        user user = [SELECT Profile.name FROM User where Profile.name = 'System Administrator' and IsActive = true limit 1 ];
         
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        test.startTest();
        system.runAs(user) {        
            Trigger_Configuration__c customval = new Trigger_Configuration__c();
            customval.Name = 'updateAccountBusinessUnit';
            customval.isRun__c = true;
            insert customval;
            
            ADMTerritoryCode__c ADMTCode= new ADMTerritoryCode__c();
            ADMTCode.Name = 'ADMTerritoryCode';
            insert ADMTCode;
            
            Account acct = new Account();
            acct.Name  = 'testAcct';
            acct.Account_Manager__c = user.Id;
            insert acct;
            
            Product_Hierarchy__c proHieray = new Product_Hierarchy__c();
            insert proHieray;
            
            Part__c part = new Part__c();
            part.Product_Hierarchy__c  = proHieray.Id;
            insert part;
            
            BBB_Year_Bill_Book_Cust_PN__c test_bbb = new BBB_Year_Bill_Book_Cust_PN__c();
            test_bbb.Customer__c = acct.Id;
            test_bbb.Part__c = part.Id;
            test_bbb.APL_need_to_capture_billing__c = true;
            insert test_bbb;
            
            APL_Billing_Result_of_Covnerted_Opp__c apl_billing = new APL_Billing_Result_of_Covnerted_Opp__c();
            apl_billing.Opportunity_Partner__c = acct.Id;
            apl_billing.part__c = part.Id;
            insert apl_billing;
            
            ClsBatch_captureBillingWhenbbInsert cls = new ClsBatch_captureBillingWhenbbInsert();
            dataBase.executeBatch(cls);
            
            test.stopTest();
       
         }
        
    }
}