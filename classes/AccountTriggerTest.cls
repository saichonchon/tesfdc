/**************************************************************************************************************************************************
Name:  AccountTriggerTest
Copyright © 2013 TE Connectivity
===================================================================================================================================================
Purpose: This class contain Test Methods for AccountBU 
---------------------------------------------------------------------------------------------------------------------------------------------------       
Related APEX Trigger : AccountBU                                                             
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
Version Developer             Date       Detail                                  Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Chiranjeevi Neelam 12/09/2011   Initial Development                           1453487                                   
  ---------------------------------------------------------------------------------------------------------------------------------------------------
    1.1 Rajendra Shahane 03/21/2016  Modified for case - 900703                                   
**************************************************************************************************************************************************/
//@IsTest(SeeAllData=true)
@IsTest
public class AccountTriggerTest{
    /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Test - Inserting Account record at the Child Org(BU Org)                                                                             |
 |   Input : None                                                                                                                                 |  
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
 public  static testMethod void changeOwner()
 {
      test.startTest();            
      
            ClsTestCustomSettingHelper.getApex_Helper_Settings();
      ClsTestCustomSettingHelper.getCCPTriggerSettings();
            ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
            ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
            ClsTestCustomSettingHelper.getOpportunity_Approvers();
            ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
            ClsTestCustomSettingHelper.getAplRoutingProcess();
            ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
            ClsTestCustomSettingHelper.getPMV_Sales_Stage_Setting();
            ClsTestCustomSettingHelper.getPMV_Stage_Config();
            
            Profile stusrprof; 
            Profile sysadmnprof;
            for(profile oProfile : [SELECT Id, name FROM Profile WHERE Name='Standard User' or Name='System Administrator'])
            {
                if(oProfile.Name =='Standard User')
                    stusrprof = oProfile;
                else if(oProfile.Name =='System Administrator')
                    sysadmnprof = oProfile;
            }
            User stduser = new User(Alias = 'stprf1', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = stusrprof.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser_te_c2s1@testorg.com');
            //insert stduser;
        
            User sysadmn = new User(Alias = 'stprf2', Email='standardusers@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testings', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = sysadmnprof.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser_te_c2s2@testorg.com');
            //insert sysadmn;
            
            User sysadmn2 = new User(Alias = 'stprf22', Email='standardusers2@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testings2', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = sysadmnprof.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser_te_c2s22@testorg.com');
            insert new List<User> {stduser,sysadmn2,sysadmn};
      
            Account acct = new Account();
            acct.Name = 'User Test';
            acct.BillingCountry = 'CN';
            acct.BillingCountry='CN';
            acct.Account_Manager__c = stduser.id;
            insert acct;

            List<Account_Team__c> ATeamList = new List<Account_Team__c>();
            Account_Team__c ATeam = new Account_Team__c();
            ATeam.Account__c=acct.id;
            ATeam.Role__c='Account Manager (AM)';
            ATeam.Team_Member__c=sysadmn.id;
            ATeamList.add(ATeam);
            
            ATeam = new Account_Team__c();
            ATeam.Account__c=acct.id;
            ATeam.Role__c='Field Engineer (FE)';
            ATeam.Team_Member__c=stduser.id;
            ATeamList.add(ATeam);
            insert ATeamList;
            
            List<Contact> vLstContact = new List<Contact>();
            Contact vContact = new Contact();  
            vContact.AccountId = acct.Id;  
            vContact.FirstName = 'Testneelam'; 
            vContact.LastName = 'Testchiru';  
            vContact.Legally_Restricted__c = false; 
            vContact.OwnerId=stduser.id; 
         //vContact.Salutation = 'Mr.';
            vLstContact = new List<Contact>();  
            vLstContact.add(vContact);  
            
            vContact = new Contact();  
            vContact.AccountId = acct.Id;  
            vContact.FirstName = 'TestRahul';  
            vContact.LastName = 'TestGharat';  
            vContact.Legally_Restricted__c = true;  
            vContact.OwnerId=sysadmn.id;
         //vContact.Salutation = 'Mr.';
            vLstContact.add(vContact);   
                     
            insert vLstContact;
                        
            //system.assertNotEquals([Select id from ContactHistory].Size(), 0);
            User UserEcs = sysadmn;//[Select id, name from User where id=:sysadmn.id];
            UserEcs.LastName='Admin';
            UserEcs.FirstName='TEIS';            
            update UserEcs;
            system.runas(UserEcs){                                  
                vLstContact[0].OwnerId = stduser.id;
                vLstContact[1].OwnerId = sysadmn2.id;
                update vLstContact;
                vLstContact[0].OwnerId = sysadmn2.id;
                vLstContact[1].OwnerId = stduser.id;
                update vLstContact;
                
                acct.OwnerId = stduser.id;
                update acct;
                acct.OwnerId = sysadmn2.id;
                update acct;
            }        
        test.stoptest();
    }
}