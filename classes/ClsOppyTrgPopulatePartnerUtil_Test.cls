/**
*   This test class is for ClsOppyTrgPopulatePartnerUtil.
*
@author Jun Yu
@created 2016-08-16
@version 1.0
@since 37.0
*
@changelog
* 2016-08-16 Jun Yu <jun.yu@oinio.com>
* - Created
* - Test coverage 100%
*/
@isTest(SeeAllData=false)
public class ClsOppyTrgPopulatePartnerUtil_Test {
    static testMethod void testCreatePartner() {
        
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        Channelinsightdata_test.Channelinsightdata_test();
        //create Account
        Account testAcct = ClsTestHelp.createTestAccounts();
        testAcct.AccountNumber = 'test1';
        insert testAcct;
        //create opportunity
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.AccountId = testAcct.Id;
        oppy.Name = 'TestOppy1';
        insert oppy;
        list<Opportunity> list_oppys = new list<Opportunity>();
        list_oppys.add(oppy);
        //ClsOppyTrgPopulatePartnerUtil.createPartner(list_oppys);
    } 
    static testMethod void testUpdatePartner() {
       
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        Channelinsightdata_test.Channelinsightdata_test();
        //create Account
        list<account> testAccounts = new list<account>();
        Account testAcct1 = ClsTestHelp.createTestAccounts();
        testAcct1.AccountNumber = 'test1';
        //insert testAcct1;
        testAccounts.add(testAcct1);
        Account testAcct2 = ClsTestHelp.createTestAccounts();
        testAcct2.AccountNumber = 'test2';
        //insert testAcct2;
        testAccounts.add(testAcct2);
        insert testAccounts;
        
        //create opportunity
        list<Opportunity> testOppys = new list<Opportunity>();
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.AccountId = testAcct1.Id;
        oppy.Name = 'TestOppy1';
        //insert oppy;
        testOppys.add(oppy);
        
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.AccountId = testAcct2.Id;
        oppy2.Name = 'TestOppy2';
        //insert oppy2;
        testOppys.add(oppy2);
        insert testOppys;
        
        Map<Id,Opportunity> map_Id_oppys = new Map<Id,Opportunity>();     
        map_Id_oppys.put(oppy2.Id,oppy2);
        oppy2.AccountId = testAcct1.Id;
        update oppy2;
        list<Opportunity> list_oppys = new list<Opportunity>();
        list_oppys.add(oppy2);

        ClsOppyTrgPopulatePartnerUtil.updatePartner(list_oppys, map_Id_oppys);
    }
}