/**
*   This test class is for AccountTrgHandler.
*
@author Chen Chen
@created 2017-03-24
@version 1.0
*
@changelog
* 2017-02-06 Chen Chen <chen.chen@oinio.com>
* - Created
*
* 2017-05-04 Michael Ludwig <michael_ludwig@te.com>
* added changes for Case 809067
*/
@isTest
public class AccountTrgHandler_Test {
    static testMethod void testMethods() {
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
            ClsTestCustomSettingHelper.getAllSettings();
            ClsTestCustomSettingHelper.getPMV_Sales_Stage_Setting();
            ChannelinsightData_test.ChannelinsightData_test();
            ClsTestCustomSettingHelper.getTrigger_Configuration();
            ClsTestCustomSettingHelper.getADMTerritoryCode();
            //Change code
            Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
            insert ah;            
            
            OpportunityPartnerTrgHelper__c oppyTeamHelper = new OpportunityPartnerTrgHelper__c();
            oppyTeamHelper.Name = 'test oppyTeamHelper';
            oppyTeamHelper.Value__c = Apex_Helper_Settings__c.getInstance('Tender Opportunity Record Type Id').Value__c;
            insert oppyTeamHelper;
            OpportunityPartnerTrgHelper__c oppyTeamHelper2 = new OpportunityPartnerTrgHelper__c();
            oppyTeamHelper2.Name = 'test oppyTeamHelper2.0';
            oppyTeamHelper2.Value__c = String.valueOf(sysadmnprof.Id).subString(0,15);
            insert oppyTeamHelper2;
            
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            acc.AccountNumber = 'test';
            acc.INDUSTRY_BUSINESS_CDE__c = '115'; 
            acc.DD1_Industry_Business_Code__c = '104';
            acc.DD2_Industry_Business_Code__c = '203';
            
            
            Account acc1 = ClsTestHelp.createTestAccounts();
            acc1.Type = 'TE Dummy Account';
            acc1.Name = 'Test Account11';
            acc1.AccountNumber = 'test11';
            acc1.Industry_Code_Description__c = 'Rail'; 
            acc1.INDUSTRY_BUSINESS_CDE__c = '113';       
            insert new list<Account>{acc, acc1};
                
                //added details for AccountTrgHandler.updateAccountBusinessUnit Michael Ludwig START
                RecordType rt = ClsTestHelp.createTestRecordType8();
            Account acc2 = ClsTestHelp.createTestAccounts();
            acc2.RecordTypeId =rt.Id;
            acc2.Account_Manager__c = UserInfo.getUserId();
            acc2.INDUSTRY_BUSINESS_CDE__c = null;
            acc2.Name = 'Test account Michael';
            
            Account acc3 = ClsTestHelp.createTestAccounts();
            acc3.RecordTypeId =rt.Id;
            acc3.Account_Manager__c = UserInfo.getUserId();
            acc3.DD1_Industry_Business_Code__c = '116';
            acc3.Name = 'Test account Michael 2';
            
            Account acc4 = ClsTestHelp.createTestAccounts();
            acc4.RecordTypeId =rt.Id;
            acc4.Account_Manager__c = UserInfo.getUserId();
            acc4.INDUSTRY_BUSINESS_CDE__c = '211';
            acc4.Name = 'Test account Michael 3';
            
            Account acc5 = ClsTestHelp.createTestAccounts();
            acc5.RecordTypeId =rt.Id;
            acc5.Account_Manager__c = UserInfo.getUserId();
            acc5.INDUSTRY_BUSINESS_CDE__c = '104';
            acc5.Name = 'Test account Michael 4';
            insert new List <Account>{acc2, acc3, acc4, acc5};
                //added details for AccountTrgHandler.updateAccountBusinessUnit Michael Ludwig END
                
                
                Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Program_level_Forecasting__c =true; 
            
            oppy2.Name = 'Pain of Queen';
            oppy2.Type = 'CM';
            oppy2.Request_Type__c = 'Extension';
            oppy2.RecordTypeId = Apex_Helper_Settings__c.getInstance('Tender Opportunity Record Type Id').Value__c;
            oppy2.Defined_GPLs__c = 'asdf\\|adfa';    
            oppy2.AccountId = acc1.Id;    
            oppy2.StageName = 'concept';
            oppy2.POS_Customer_is_same_as_Account__c = true;
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Defined_GPLs__c = 'asdf\\|adfa'; 
            oppy.Type = 'CM';
            oppy.Request_Type__c = 'Extension';
            oppy.Method__c = 'BOM';
            oppy.Level__c = 'Yearly';
            oppy.Amount = 1;
            oppy.CurrencyIsoCode = 'EUR';
            oppy.Five_Year_Revenue__c = 1;
            oppy.AccountId = acc.Id;
            oppy.Distributor__c = 'Future';
            oppy.RecordTypeId = Apex_Helper_Settings__c.getInstance('Tender Opportunity Record Type Id').Value__c;
            oppy.stagename = 'concept';
            oppy.POS_Customer_is_same_as_Account__c = true;
            insert new list<opportunity>{oppy2, oppy};
                
                Opportunity_Partner__c oppyPartner = ClsTestHelp.createTestOpportunityPartner();
            oppyPartner.Opportunity__c = oppy.Id;
            oppyPartner.Account__c = acc.Id;
            oppyPartner.Allocation__c = 0;
            insert oppyPartner;
            Test.startTest();
            acc1.GAMCD__c = '005';
            update acc1;
            delete acc1;
            
            //added details for AccountTrgHandler.updateAccountBusinessUnit Michael Ludwig START
            List<Account> accs = new List<Account>();
            accs=[Select ID,Industry_Code_Description__c, Business_Unit_Level_2__c,INDUSTRY_BUSINESS_CDE__c FROM Account];
            For(Account a:accs){
                IF(a.INDUSTRY_BUSINESS_CDE__c== null){
                    system.assertEquals(null, a.Industry_Code_Description__c);
                    system.assertEquals(null, a.Business_Unit_Level_2__c);
                }
                IF(a.INDUSTRY_BUSINESS_CDE__c=='211'){
                    system.assertEquals('Subcontractor', a.Industry_Code_Description__c);
                    system.assertEquals(null, a.Business_Unit_Level_2__c);
                }
                IF(a.INDUSTRY_BUSINESS_CDE__c=='116'){
                    system.assertEquals('Industrial', a.Industry_Code_Description__c);
                    system.assertEquals('A&C', a.Business_Unit_Level_2__c);
                }
                IF(a.INDUSTRY_BUSINESS_CDE__c=='104'){
                    system.assertEquals(null, a.Industry_Code_Description__c);
                    system.assertEquals(null, a.Business_Unit_Level_2__c);
                }
            }
            
            //check update
            acc4.INDUSTRY_BUSINESS_CDE__c = '205';
            update acc4;
            
            Account b =[Select ID,Industry_Code_Description__c, Business_Unit_Level_2__c, INDUSTRY_BUSINESS_CDE__c FROM Account Where ID =:acc4.Id];
            system.assertEquals('Automotive', b.Industry_Code_Description__c);
            system.assertEquals(null, b.Business_Unit_Level_2__c);
            
            //added details for AccountTrgHandler.updateAccountBusinessUnit Michael Ludwig END
            Test.stopTest(); 
        }      
    }
}