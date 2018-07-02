/**********************************************************************************************************************
Name:  UserDAOTest
Copyright © 2012 TE Connectivity | Salesforce Instance : BU Org 
=======================================================================================================================
Purpose: This class contain Test Methods for UserDAO
-----------------------------------------------------------------------------------------------------------------------
Related APEX Class : UserDAO                                                              
=======================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                        
-----------------------------------------------------------------------------------------------------------------------
Version Developer          Date       Detail                                  Mercury Request #
-----------------------------------------------------------------------------------------------------------------------
    1.0 Umasankar Subbaian 02/16/2012 Initial Development                     1453487 (SMO - Build 3.0)                                   
**********************************************************************************************************************/
@isTest
public class UserDAOTest
{
 /*____________________________________________________________________________________________________________________
 | Purpose : Create test data for User sObject                                                                        |
 |____________________________________________________________________________________________________________________|
 | Input Parameter  : None                                                                                            |
 |____________________________________________________________________________________________________________________|
 | Output Parameter : None                                                                                            |
 |___________________________________________________________________________________________________________________*/ 
 public static void createUser()
 {
  /*-- 1.0 Object variable declaration ---------------------------------------------*/ 
  User vUser;
  vUser                      = new User();
  vUser.FirstName            = 'Dinesh';  
  vUser.LastName             = 'Umasankar';  
  vUser.email                = 'dinesh1.umasankar@test.com';
  vUser.alias                = 'udinesh1';
  vUser.UserName             = vUser.email;
  vUser.CommunityNickname    = vUser.alias;
  vUser.ProfileId            = UserInfo.getProfileId();  
  vUser.TimeZoneSidKey       = 'GMT';
  vUser.LocaleSidKey         = 'en_US';
  vUser.EmailEncodingKey     = 'UTF-8';
  vUser.LanguageLocaleKey    = 'en_US'; 
  Insert vUser;
  System.assert(vUser != null, 'Salesforce.com is not allowing us to insert user in the temporary memory'); 
 } // public static void createUser()

 /*____________________________________________________________________________________________________________________
 | Purpose : Test - Reading users | Test Behavior : Positive                                                          |
 |____________________________________________________________________________________________________________________|
 | Input Parameter  : None                                                                                            |
 |____________________________________________________________________________________________________________________|
 | Output Parameter : None                                                                                            |
 |___________________________________________________________________________________________________________________*/  
 public static void ptGetUsers()
 {
  /*-- 1.0 Collection variable declaration -----------------------------------------*/ 
  Set<Id>      vSetUserId;
  List<String> vLstUserId;  
  Map<ID,User> vMapUserIdUser;
  /*-- 1.1 Object variable declaration ---------------------------------------------*/ 
  User vUser;
  
  vUser = 
  [
   SELECT u.Id 
     FROM User u
     WHERE u.IsActive = true
    AND u.email    = 'dinesh1.umasankar@test.com'
  LIMIT 1
  ];  
  vSetUserId = new Set<Id>();
  vSetUserId.add(vUser.Id);  
  vMapUserIdUser = UserDAO.mapUserIdUser(vSetUserId);
  System.assert(vMapUserIdUser != null, 'We cannot read users for the correct SFDC record Id s as input');
 } // public static void ptGetUsers 
 /*____________________________________________________________________________________________________________________
 | Purpose : Call positive behavioral Tests and Negative behavioral test for UserDAO  class                           |
 |____________________________________________________________________________________________________________________|
 | Input Parameter  : None                                                                                            |
 |____________________________________________________________________________________________________________________|
 | Output Parameter : None                                                                                            |
 |___________________________________________________________________________________________________________________*/  
 public static testMethod void core()
 {
  test.StartTest();
  createUser();
  ptGetUsers();
  
  test.StopTest();
 } // public static testMethod void core()  
 
 /*__________________________________________________________________________________________________________________*/ 
 
} // public class UserDAOTest