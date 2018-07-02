/**************************************************************************************************************************************************
Name:  Account_AddSpecialist_Test
Copyright © 2011 TE Connectivity
===================================================================================================================================================
Purpose: This class contain Test Methods for Account_AddSpecialist
---------------------------------------------------------------------------------------------------------------------------------------------------       
Related Trigger : Account_AddSpecialist
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
Version Developer          Date       Detail                                  Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Mrunal Parate     08/13/2014 Initial Development                      R-1113                                   
**************************************************************************************************************************************************/
@isTest(SeeAllData=true)
public class Account_AddSpecialist_Test {
  static testMethod void testMethod1() {
  Test.starttest();
  Profile p = [Select Id, Name From Profile 
                                    where Name = 'Production Support' 
                                    or Name = 'Service Account' 
                                    or Name ='System Administrator' 
                                    or Name ='Systemadministrator' limit 1];
        User u = new User();
        u.FirstName ='First';
        u.LastName = 'Tester';
        u.username = 'Lion123732@testCompany999.com';
        u.Email = 'Lion123732@testCompany999.com';
        u.Alias = 'SF';
        u.ProfileId = p.Id;
        u.CommunityNickname = 'QPS';
        u.IsActive = true;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        insert u;
        
        User identoU =new User();
        identoU.FirstName ='FirstName';
        identoU.LastName = 'TesterName';
        identoU.Email = 'testme@teatmail.com';
        identoU.Alias = 'SFFH';
        identoU.ProfileId = p.Id;
        identoU.CommunityNickname = 'ASD';
        identoU.IsActive = true;
        identoU.Username = identoU.Email+'2';
        identoU.TimeZoneSidKey = 'America/Chicago';
        identoU.LocaleSidKey = 'en_US';
        identoU.EmailEncodingKey = 'UTF-8';
        identoU.LanguageLocaleKey = 'en_US';
        insert identoU;
                 
        Account acc=new Account();  
        acc.Name='Test1000';
        acc.BillingCountry='US';
        acc.Account_Manager__c = u.id;
        acc.Relays_Application_Engineer__c=u.id;
        acc.Account_Team_Partner_Function__c = u.id;
        insert acc;                   

        acc.Account_Team_Partner_Function__c = identoU.id;
        acc.Relays_Application_Engineer__c=identoU.Id;
        update acc;
        try{
        Account_Team__c at = [Select Id, Name From Account_Team__c where Account__c =: acc.id 
                                    and Role__c = 'Idento Labels Specialist'];
                                    
        Delete at;
        }catch(exception e){} 
         
   
        acc.Account_Team_Partner_Function__c = null;
        acc.Relays_Application_Engineer__c=null;
        update acc;
        
         Account_Team__c accTeamMember = new Account_Team__c();
         accTeamMember.Account__c = acc.id;
         accTeamMember.Team_Member__c = identoU.id;
         accTeamMember.Opportunity_Access__c = 'Edit';
         accTeamMember.Role__c = 'Default';
         insert accTeamMember;
         
         acc.Account_Team_Partner_Function__c = identoU.id;
         update acc;
         
         Test.stoptest();
           
        }

}