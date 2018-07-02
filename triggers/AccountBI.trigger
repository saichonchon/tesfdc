/**************************************************************************************************************************************************
Name: AccountBI 
Copyright © 2011 TE Connectivity | Salesforce Instance : BU Org
===================================================================================================================================================
Purpose: This trigger populate user information (BU Owner Name, BU Owner Email, BU Owner Phone) and Source BU in the account custom fields.                                                  
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR                DATE       DETAIL                                                   Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 RAHUL GHARAT       10/25/2011 Initial Development - SF2SF                                  1453487  
    1.1 UMASANKAR SUBBAIAN 12/06/2011 Allow account and child records to share with Central Org    1453487 
    1.2 SHANTINATH PATIL   05/15/2013 Added method for the Sales Hierarchy and Code null mapping      
**************************************************************************************************************************************************/
trigger AccountBI on Account (before insert) 
{
 /*-- 1 Collection variable declaration --------------------------------------*/  
 List<Account> vLstFilteredAccount;
 List<Account> vLstNewAccount;
  
 if (!ExecuteOnce.SF2SF_ACCOUNT)
 {
  vLstNewAccount      = Trigger.new; // Use this variable for future 
  //vLstFilteredAccount = new List<Account>();
  //system.debug('Total account records : ' + vLstNewAccount.size());
  //vLstFilteredAccount = AccountUtil.FilterAccs(vLstNewAccount);
 // AccountUtil.getUserMap(vLstNewAccount);
  AccountUtil.setSalesHerarchyLookup(vLstNewAccount);
 } // if (!ExecuteOnce.SF2SF_ACCOUNT)
 
 /**** Set Account billing country code ****/
  AccountUtil.setAccountBillingCountry(Trigger.new); // added for case# 00901064 by Subramanian
 
 /*-----------------------------------------------------------------------------------------------------------------------------------------------*/

} // trigger AccountBI on Account (before insert)