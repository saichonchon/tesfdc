/**************************************************************************************************************************************************
Name: AccountBU 
Copyright © 2011 TE Connectivity | Salesforce Instance : BU Org
===================================================================================================================================================
Purpose: This trigger populate user information (BU Owner Name, BU Owner Email, BU Owner Phone) and Source BU in the Account custom fields.                                                  
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR                DATE       DETAIL                                            Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Rahul Gharat          10/26/2011 Initial Development - SF2SF                       1453487 
    1.1 Umasankar Subbaian    12/06/2011 Make contact creatable with account               1453487
    1.2 SHANTINATH PATIL      05/15/2013 Added method for the Sales Hierarchy and Code 
                                         null mapping  
**************************************************************************************************************************************************/
trigger AccountBU on Account(before update) 
{
 /*-- 1 Collection variable declaration --------------------------------------*/
 List<Account> inPNRC;
 List<Account> notinPNRC;
 List<Account> vLstAccount;
 
 if (!ExecuteOnce.SF2SF_ACCOUNT)
 {
  vLstAccount = Trigger.new; 
 /* inPNRC      = new List<Account>();
  notinPNRC   = new List<Account>(); 
  
  // Get the list of Account which are already shared with the central org
  // by calling inPNRC method   
  System.Debug('Keyset is : ' + Trigger.newmap.keySet());    
  inPNRC = AccountUtil.inPNRC(Trigger.newmap.keySet(), vLstAccount, true);
  System.Debug('in PNRC size : ' + inPNRC);
    
  // Similary get list of Account which are not in central org    
  notinPNRC = AccountUtil.inPNRC(Trigger.newmap.keySet(), vLstAccount, false);
  System.Debug('Not in PNRC size : ' + notinPNRC);
    
  // To copy owner accounts if not in PNRC and unrestricted.    
  List<Account> notinPNRC_Unres = new List<Account>();
  notinPNRC_Unres = AccountUtil.FilterAccs(notinPNRC);
  System.debug('notinPNRC_Unres size : ' + notinPNRC_Unres);
    
    */
    
  // Copy owner info    
 // AccountUtil.getUserMap(notinPNRC_Unres);
        
  // To process in PNRC accounts  :if restricted NO: chk for owner change   
  //List<Account> inPNRC_Unres = new List<Account>();
  //inPNRC_Unres = AccountUtil.FilterAccs(inPNRC);
        
  // Check for owner change
 // if (inPNRC_Unres != null)
  
  // AccountUtil.getUserMap(vLstAccount);
   AccountUtil.setSalesHerarchyLookup(vLstAccount);
     
 } // if (!ExecuteOnce.SF2SF_ACCOUNT)   
 
 /*----------------------------------------------------------------------------------------------------------------------------------------------*/
 
} // trigger AccountBU on Account(before update)