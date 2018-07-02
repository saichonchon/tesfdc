/***********************************************************************************************************************
Name: InactiveUser_test
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S
========================================================================================================================
Purpose: test class for inactiveuser                                                   
========================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR                DATE       DETAIL                                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------
1.0    Ravi                 06/20/2013     Initial Development                                         
***********************************************************************************************************************/
@istest
public class  InactiveUser_test
{
    public static testmethod void inactive_user()
    {
     
     list<profile> p =[select Id from Profile  where Name = 'System Administrator'];
                                        
       user u = new user();
       u.FirstName='ravi';
       u.LastName='kumar';
       u.Alias='zen'; 
       u.Email='ravikumar.vasimalla@zensar.in';     
       u.Username ='test_'+''+u.Email;
       u.CommunityNickname=u.Alias;
       u.ProfileId = p[0].Id;
       u.TimeZoneSidKey='America/Chicago'; 
       u.LocaleSidKey='en_US';
       u.EmailEncodingKey ='UTF-8';
       u.LanguageLocaleKey='en_US';
       u.Expiration_date__c=system.today();
       u.isactive=true;
       insert u;
       InactiveUser inactive_user = new InactiveUser(); 
       
    }
}