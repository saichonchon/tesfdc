/**********************************************************************************************************************
 Name: UserDAO 
 Copyright © 2012 TE Connectivity | Salesforce Instance : BU Org
=======================================================================================================================
 Purpose: This class contains all the database queries (SOQL) specific to the User sObject which can be reused in 
          future. 
-----------------------------------------------------------------------------------------------------------------------
 Related Class: TaskUtil                                         
=======================================================================================================================
 Requirement Information & Development Information:                                                       
-----------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR        DATE       DETAIL                                     Mercury Request #
-----------------------------------------------------------------------------------------------------------------------
    1.0 Umasankar     02/14/2012 Initial Develeopment                       SMO (1453487)  
    1.1 Sandeep Y     07/24/2013 Source BU change related
                                 to Case # 00438548.
                                 Added the GIBU column in User SOQL
**********************************************************************************************************************/
public class UserDAO
{
 /*____________________________________________________________________________________________________________________
 | Purpose : To get the map of User Id with User Record                                                               |
 |____________________________________________________________________________________________________________________|
 | Input Parameter :                                                                                                  |
 |____________________________________________________________________________________________________________________|
 |   1. Name        : List of "User Record Id"                                                                        |
 |      Data Type   : List<String>                                                                                    |
 |      Description : List of SFDC record id s - User sObject                                                         | 
 |____________________________________________________________________________________________________________________|
 | Output Parameter :                                                                                                 |
 |____________________________________________________________________________________________________________________|
 |   1. Name        : Map of User ID with User Record                                                                 |
 |      Data Type   : Map<Id, User>                                                                                   |
 |      Description : Map - key = User Record Id; Map - Value = User Record                                           |
 |___________________________________________________________________________________________________________________*/
 public static Map<ID,User> mapUserIdUser(Set<Id> pSetUserId)
 {
  /*-- D1. Collection variable declaration --------------------------------------*/
  Map<ID,User> vMapUserIdUser;
  if (pSetUserId != null)
  {
   if (pSetUserId.size() > 0)
   {
    vMapUserIdUser = new Map<ID,User>(
     [SELECT u.Id, 
             u.Name, 
             u.Email, 
             u.Phone,
             u.GIBU__c 
        FROM User u 
       WHERE u.Id IN :pSetUserId
     ]);
   } // if (pSetUserId.size() > 0)
  } // if (pSetUserId != null)
  return vMapUserIdUser; 
 } // public static Map<ID,User> mapUserIdUser
 
 /*__________________________________________________________________________________________________________________*/ 
  
} // public class UserDAO