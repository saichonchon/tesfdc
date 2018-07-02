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
@isTest
private class ANZClauseController_Test {
    @testSetup static void createConfig(){
    	ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        ClsTestCustomSettingHelper.getQuoteValiditySetting();
        ClsTestCustomSettingHelper.getQuoteExpirationSetting();
        ClsTestHelp.createTestOrgWideSettings1();
        ClsTestCustomSettingHelper.getADMTerritoryCode();
    }
    
    static testMethod void myUnitTest() {
        User u = ClsTestHelp.createTestUsers();
        System.runAs(u) {
            Account vAccount = ClsTestHelp.createTestAccounts();
            vAccount.Name = 'AMP Iron Foundries Inc';
            vAccount.AnnualRevenue = 2000000.11; 
            vAccount.Legally_Restricted__c = false;  
            vAccount.BillingCity = 'Shanghai';  
            vAccount.BillingCountry = 'China';
            vAccount.BillingState = '000000';
            vAccount.BillingStreet = 'Changning';
            vAccount.BillingPostalCode = '200051';
            vAccount.BU_Owner_Email__c = 'testMail@oinio.com';
            insert vAccount;
            
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Name = 'testOppy2';
            oppy.AccountId = vAccount.Id;
            oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
            insert oppy;
            
            ANZ_Clause__c anzCls = ClsTestHelp.createTestANZClause();
            anzCls.Opportunity__c = oppy.Id;
            anzCls.Opportynity_Type__c = 'Quote';
            insert anzCls;
          
            Test.startTest();
            PageReference pageRef = Page.NewANZClausePage;
            Test.setCurrentPage(pageRef);
            ANZClauseController CtrlAnz = new ANZClauseController(new ApexPages.StandardController(anzCls));
            CtrlAnz.saveRecords();
            CtrlAnz.saveandmore();         
            CtrlAnz.cancel();
            Test.stopTest();
            System.assert([SELECT Id FROM ANZ_Clause__c].size() == 1);
        }
    }
    
    static testMethod void myUnitTestException() {
        User u = ClsTestHelp.createTestUsers();
        System.runAs(u) {
            Account vAccount = ClsTestHelp.createTestAccounts();
            vAccount.Name = 'AMP Iron Foundries Inc';
            vAccount.AnnualRevenue = 2000000.11; 
            vAccount.Legally_Restricted__c = false;  
            vAccount.BillingCity = 'Shanghai';  
            vAccount.BillingCountry = 'China';
            vAccount.BillingState = '000000';
            vAccount.BillingStreet = 'Changning';
            vAccount.BillingPostalCode = '200051';
            vAccount.BU_Owner_Email__c = 'testMail@oinio.com';
            insert vAccount;
            
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Name = 'testOppy2';
            oppy.AccountId = vAccount.Id;
            oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
            insert oppy;
            
            ANZ_Clause__c anzCls = ClsTestHelp.createTestANZClause();
            anzCls.Opportunity__c = oppy.Id;
            anzCls.Opportynity_Type__c = 'Quote';
            insert anzCls;
          
            Test.startTest();
            PageReference pageRef = Page.NewANZClausePage;
            Test.setCurrentPage(pageRef);
            ANZClauseController CtrlAnz = new ANZClauseController(new ApexPages.StandardController(anzCls));
            anzCls.Opportunity__c = vAccount.Id;
            CtrlAnz.saveRecords();
            CtrlAnz.saveandmore();         
            CtrlAnz.cancel();
            Test.stopTest();
        }
    }
}