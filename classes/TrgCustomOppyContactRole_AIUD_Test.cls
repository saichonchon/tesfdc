/**
*  This test class used to test trigger CustomOpportunityContactRole_AIUD_updateOppyNPSScore.
*
@author Jinbo Shan
@created 2014-06-16
@version 1.0
@since 29.0
*
@changelog
* 2014-06-16 Jinbo Shan <jinbo.shan@itbconsult.com>
* - Created
* - Test coverage 77%
*/
@isTest(SeeAllData=true)
private class TrgCustomOppyContactRole_AIUD_Test {

    static testMethod void myUnitTest() {
        /*
        Apex_Helper_Settings__c ahs1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c ahs3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c ahs4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c ahs2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c ahs5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c ahs6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c ahs7 = ClsTestHelp.createTestName7();
        Apex_Helper_Settings__c ahs8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c ahs9 = ClsTestHelp.createTestName9();
        Apex_Helper_Settings__c ahs10 = ClsTestHelp.createTestName10();
        Apex_Helper_Settings__c ahs11 = ClsTestHelp.createTestName11();
        Apex_Helper_Settings__c ahs12 = ClsTestHelp.createTestName12();
        
        Opportunity_Approvers__c oa = ClsTestHelp.createTestOpportunityApprovers();        
        Opportunity_Approvers__c oa2 = ClsTestHelp.createTestOpportunityApprovers2();        
        Opportunity_Approvers__c oa3 = ClsTestHelp.createTestOpportunityApprovers3();
        Opportunity_Approvers__c oa4 = ClsTestHelp.createTestOpportunityApprovers4();
        
        Consumer_Device_Opportunity_Record_Types__c cdort1 = ClsTestHelp.createTestCSD1();
        Consumer_Device_Opportunity_Record_Types__c cdort2 = ClsTestHelp.createTestCSD2();
        Consumer_Device_Opportunity_Record_Types__c cdort3 = ClsTestHelp.createTestCSD3();
        Consumer_Device_Opportunity_Record_Types__c cdort4 = ClsTestHelp.createTestCSD4();
        Consumer_Device_Opportunity_Record_Types__c cdort5 = ClsTestHelp.createTestCSD5();
        Consumer_Device_Opportunity_Record_Types__c cdort6 = ClsTestHelp.createTestCSD6();
        Consumer_Device_Opportunity_Record_Types__c cdort7 = ClsTestHelp.createTestCSD7();
        
        OrgWideSettings__c ows1 = ClsTestHelp.createTestOrgWideSettings1();
        OrgWideSettings__c ows2 = ClsTestHelp.createTestOrgWideSettings2();
        */
        RecordType rt = ClsTestHelp.createPMVTestRecordType1();
        User u = ClsTestHelp.createTestUsers4PMV();
        u.Username = 'test@itbconsult.com.test1';
        insert u;
        system.runAs(u){
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'Prospect';
            acc.BillingCountry = 'US';
            insert acc;
            
            Opportunity opp = new Opportunity();
            opp.AccountId = acc.Id;
            opp.Name = 'test';
            opp.CurrencyIsoCode = 'EUR';
            opp.Type = 'New Business';
            opp.Description = 'test';
            opp.Distributor__c = 'Dachs';
            opp.StageName = 'Initiating';
            opp.currency_confirm__c = true;
            opp.Manufacturing_Start_Date__c = date.today();
            opp.CloseDate = date.today().addMonths(1);
            opp.RecordTypeId = rt.Id;
            opp.PMV_Type__c = 'IND Standard Sales opp';
            insert opp;
        
            Contact con = ClsTestHelp.createTestContacts();
            insert con;
            
            Custom_Opportunity_Contact_Role__c cocr = new Custom_Opportunity_Contact_Role__c();
            cocr.Contact__c = con.Id;
            cocr.Opportunity__c = opp.Id;
            cocr.Role__c = 'Evaluator';
            cocr.Primary__c = false;
            insert cocr;
            
            cocr.Role__c = 'Influencer';
            update cocr;
        }
    }
}