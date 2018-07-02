/**
*   This test class is for ClsOppyTeamMemberUtil.cls and OpportunityTeamMember.trigger.
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
public class ClsOppyTeamMemberUtil_Test {

    static testMethod void myUnitTest() {
        Profile stusrprof; 
        Profile sysadmnprof;
        for(profile oProfile : [SELECT Id, name FROM Profile WHERE Name='Standard User' or Name='System Administrator']) {
            if(oProfile.Name =='Standard User')
                stusrprof = oProfile;
            else if(oProfile.Name =='System Administrator')
                sysadmnprof = oProfile;
        }
        
        User sysadmn = new User(Alias = 'stprf2', Email='standardusers@testorg.com', 
                                EmailEncodingKey='UTF-8', LastName='Testings', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = sysadmnprof.Id, 
                                TimeZoneSidKey='America/Los_Angeles', UserName='standarduser_te_c2s2@testorg.com');
        insert sysadmn;
        
        system.runAs(sysadmn) {
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
            
            RecordType rt = ClsTestHelp.createTestRecordType14();
            RecordType rt2 = ClsTestHelp.createTestRecordType10();
            
            OpportunityTeamMemberTrgHelper__c oppyTeamHelper = new OpportunityTeamMemberTrgHelper__c();
            oppyTeamHelper.Name = 'test oppyTeamHelper';
            oppyTeamHelper.Value__c = String.valueOf(rt2.Id).subString(0,15);
            insert oppyTeamHelper;
            OpportunityTeamMemberTrgHelper__c oppyTeamHelper2 = new OpportunityTeamMemberTrgHelper__c();
            oppyTeamHelper2.Name = 'test oppyTeamHelper2.0';
            oppyTeamHelper2.Value__c = String.valueOf(sysadmnprof.Id).subString(0,15);
            insert oppyTeamHelper2;
            
            Opportunity_Record_Type_Groups__c optg4return = new Opportunity_Record_Type_Groups__c();
            optg4return.Name = 'GAM Code/Team Member Record Type';
            optg4return.Active__c = true;
            optg4return.Default_Record_Type_Lead_Conversion__c = true;
            optg4return.Group__c = 'GAM Code/Team Member Record Type';
            optg4return.Is_Sales_Only__c = true;
            optg4return.Migration_Record_Type__c = '012E0000000XrBY';
            optg4return.RecordTypeID__c  = rt2.Id;
            insert optg4return;
            
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
            insert oppy;
            
            Test.startTest();
            OpportunityTeamMember ot = new OpportunityTeamMember();
            ot.UserId = u.Id;
            ot.OpportunityId = oppy.Id;
            ot.TeamMemberRole = 'Global Account Manager (GAM)';
            insert ot;
            ot.TeamMemberRole = 'test';
            update ot;
            delete ot;
            Test.stopTest();
        }
    }
}