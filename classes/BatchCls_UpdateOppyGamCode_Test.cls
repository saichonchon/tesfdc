/**
*   This test class is for BatchCls_UpdateOppyGamCode.
*
@author Chen Chen
@created 2017-02-06
@version 1.0
*
@changelog
* 2017-02-06 Chen Chen <chen.chen@oinio.com>
* - Created
* - Test coverage 100%
*/
@isTest
private class BatchCls_UpdateOppyGamCode_Test {

    static testMethod void myUnitTest() {
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        OpportunityTeamTriggerRole__c OppyTeamRole = new OpportunityTeamTriggerRole__c();
        OppyTeamRole.Name = 'test';
        OppyTeamRole.Opp_Team_Role__c = 'Global Account Manager (GAM);';
        insert OppyTeamRole;
        
        Profile p = [Select Id, Name From Profile 
                     Where Name = 'Service Account' 
                     Or Name ='System Administrator' 
                     Or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'helloManesfd4@testCompany1233423.com';
        u.Alias = 'dp4e';
        u.CommunityNickname = 'TMD';
        u.ProfileId = p.Id;
        insert u;
        
        Profile p2 = [Select Id, Name From Profile 
                     Where Name like '%Appliance%' limit 1];
        User u2 = ClsTestHelp.createTestUsers();
        u2.Email = 'helloManesfd456@testCompany1233423456.com';
        u2.Alias = 'dp4e456';
        u2.CommunityNickname = 'TMD456';
        u2.ProfileId = p2.Id;
        insert u2;
        
        RecordType rt = ClsTestHelp.createTestRecordType14();
        RecordType rt2 = ClsTestHelp.createTestRecordType10();
        
        Account acc = new Account();
        acc.Name = 'test acct';
        acc.RecordTypeId = rt.Id;
        acc.Type = 'Global Account';
        acc.Industry_Code_Description__c = 'Appliances';
        acc.LEVEL_1_INDUSTRY_CDE__c = '0283';
        insert acc;
        
        Opportunity oppy = new Opportunity();
        oppy.Description = 'Test';
        oppy.AccountId = acc.Id;
        oppy.Account = acc;
        oppy.Name = 'SandKing';
        oppy.currency_confirm__c = true;
        oppy.CloseDate = date.today();
        oppy.Manufacturing_Start_Date__c = date.today().addMonths(1);
        oppy.RecordTypeId = rt2.Id;             
        oppy.Mass_prod_Status__c = true;
        oppy.StageName = 'New';
        oppy.OwnerId = u2.Id;
        insert oppy;
        
        OpportunityTeamMember ot = new OpportunityTeamMember();
        ot.UserId = u.Id;
        ot.OpportunityId = oppy.Id;
        ot.TeamMemberRole = 'Global Account Manager (GAM)';
        insert ot;
        
        Test.startTest();
        BatchCls_UpdateOppyGamCode cls = new BatchCls_UpdateOppyGamCode();
		database.executeBatch(cls);
        Test.stopTest();
    }
}