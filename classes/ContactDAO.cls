/**************************************************************************************************************************************************
Name: ContactDAO 
Copyright © 2011 TE Connectivity | Instance : BU Org (Eng)
===================================================================================================================================================
Purpose: This class contains all SOQL s and related reusable methods specific to the Contact sObject which can be reused in future. 
---------------------------------------------------------------------------------------------------------------------------------------------------
APEX Class utilize this class : AccountUtil                                        
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------                                                         
VERSION AUTHOR        DATE       DETAIL                          Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------   
    1.1 Umasankar     11/04/2011 Initial Development             1453487   
**************************************************************************************************************************************************/
public class ContactDAO
{
 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Get Contact records                                                                                                                  |
 |   Input : List of Account Id s                                                                                                                 |  
 | Returns : List of contacts                                                                                                                     |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/
 public static List<Contact> getContactsByAccountId(List<String> pLstAccountId)
 {
  /*-- 1.0 Collection variable declaration -----------------------------------------*/  
  List<Contact> vLstContact;
  
  if (pLstAccountId != null)
  {
   if (pLstAccountId.size() > 0 )
   {
    vLstContact = 
     [
      SELECT o.Id,
             o.Legally_Restricted__c
        FROM Contact o
       WHERE o.AccountId = :pLstAccountId       
     ];
   } // if (pLstAccountId.size() > 0 )
  } // if (pLstAccountId != null)
  return vLstContact;
 } // public static List<Contact> getContactsByAccountId
 
 /*-----------------------------------------------------------------------------------------------------------------------------------------------*/ 
 
} // public class ContactDAO