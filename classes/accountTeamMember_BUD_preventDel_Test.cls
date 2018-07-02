/***********************************************************************************************************************
 Name: accountTeamMember_BUD_preventDel_Test
 Org : C2S
 Copyright : © 2016 TE Connectivity 
========================================================================================================================
 Summary : Test class for Trigger accountTeamMember_BUD_preventUpdateDelete, Code Coverage - 87%
 -----------------------------------------------------------------------------------------------------------------------
 VERSION  AUTHOR              DATE              DETAIL                              
 -----------------------------------------------------------------------------------------------------------------------
   1.0   Rajendra Shahane            07/08/2016        Initial Development accountTeamMember_BUD_preventDel_Test
***********************************************************************************************************************/ 
@isTest(SeeAllData=false)
public class accountTeamMember_BUD_preventDel_Test
{
    public testMethod static void testaccountTeamMember_BUD_preventDel()
    {
        
        ClsTestCustomSettingHelper.getCCPTriggerSettings();
        ClsTestCustomSettingHelper.getApex_Helper_Settings(); 
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getCaseFinalVariables();        
        ClsTestCustomSettingHelper.getWebToCaseStrings();
        
        insert new List<Specialist_Field__c> {new Specialist_Field__c(Name = 'Idento',API_Name__c = 'Account_Team_Partner_Function__c',Role__c = 'Idento Labels Specialist'),new Specialist_Field__c(Name = 'Relay',API_Name__c = 'Relays_Application_Engineer__c',Role__c = 'Relay Specialist')};
        
        Profile p = [Select Id, Name From Profile 
                                    where Name = 'Production Support' 
                                    or Name = 'Service Account' 
                                    or Name ='System Administrator' 
                                    or Name ='Systemadministrator' limit 1];
        
        User identoU =new User();
        identoU.FirstName ='FirstName';
        identoU.LastName = 'TesterName';
        identoU.Email = 'testme@teatmail.com';
        identoU.Alias = 'SFFH';
        identoU.ProfileId = p.Id;
        identoU.CommunityNickname = 'ASD';
        identoU.IsActive = false;
        identoU.Username = identoU.Email+'2';
        identoU.TimeZoneSidKey = 'America/Chicago';
        identoU.LocaleSidKey = 'en_US';
        identoU.EmailEncodingKey = 'UTF-8';
        identoU.LanguageLocaleKey = 'en_US';
        
        User identoU1 =new User();
        identoU1.FirstName ='FirstName123';
        identoU1.LastName = 'TesterName123';
        identoU1.Email = 'testme@teatmail123.com';
        identoU1.Alias = 'SFFH11';
        identoU1.ProfileId = p.Id;
        identoU1.CommunityNickname = 'ASD11';
        identoU1.IsActive = false;
        identoU1.Username = identoU.Email+'211';
        identoU1.TimeZoneSidKey = 'America/Chicago';
        identoU1.LocaleSidKey = 'en_US';
        identoU1.EmailEncodingKey = 'UTF-8';
        identoU1.LanguageLocaleKey = 'en_US';
        insert new List<User> {identoU,identoU1};
                 
        test.startTest();
        
        Account acc=new Account();  
        acc.Name='Test1000';
        acc.BillingCountry='US';
        acc.Account_Manager__c = userinfo.getUserId();
        acc.Relays_Application_Engineer__c=identoU.id;
        acc.Account_Team_Partner_Function__c = identoU.id;
        insert acc; 
        
        Account_Team__c accTeamMember = new Account_Team__c();
        accTeamMember.Account__c = acc.id;
        accTeamMember.Team_Member__c = identoU.id;
        accTeamMember.Opportunity_Access__c = 'Edit';
        accTeamMember.Role__c = 'Relay Specialist';
        Account_Team__c accTeamMember1 = new Account_Team__c();
        accTeamMember1.Account__c = acc.id;
        accTeamMember1.Team_Member__c = identoU1.id;
        accTeamMember1.Opportunity_Access__c = 'Edit';
        accTeamMember1.Role__c = 'Relay Specialist';
        insert new List<Account_Team__c> {accTeamMember,accTeamMember1};
        
        accTeamMember.Opportunity_Access__c = 'View';
        update accTeamMember;
        
        try{
            delete accTeamMember;
        }catch(exception ex){}
        
        try{
            delete accTeamMember1;
        }catch(exception ex){}
        
        test.stopTest();
    }
}