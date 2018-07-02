/**************************************************************************************************************************************************
Name: AccountAU 
Copyright © 2011 TE Connectivity | Instance : BU Org (Energy)
===================================================================================================================================================
Purpose: This trigger shares the changes in account records from child org to central org via SF2SF                                                 
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR                DATE       DETAIL                                            Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Rahul Gharat          10/25/2011 Initial Development - SF2SF                       1453487  
    1.1 Umasankar Subbaian    11/02/2011 Exception Handling & Cascade Unrestriction        1453487
**************************************************************************************************************************************************/
trigger AccountAU on Account (after update) 
{
 /*-- 1 Collection variable declaration -------------------------------------*/        
 List<Account> inPNRC;
 List<Account> notinPNRC;
 List<Account> notinPNRC_Unres;
 List<Account> inPNRC_res;
 List<Account> vLstNewAccount;
 List<Account> vLstOldAccount;
 
 /*-- 2. Primitive variable declaration --------------------------------------*/ 
 String  vStrErrorCategory       = ''; 
 String  vStrLineNumber          = '';
 String  vStrStackTrace          = '';
 String  vStrError               = '';
 String  vStrLog                 = '';
 String  vStrSfdcRecId           = ''; 
 
 try
 {
  if (!ExecuteOnce.SF2SF_ACCOUNT)   
  {
   inPNRC         = new List<Account>();
   notinPNRC      = new List<Account>();
   vLstNewAccount = trigger.new;
   vLstOldAccount = trigger.old;
   // get the list of Account which are already shared with the central org
   // by calling inPNRC method
    
   system.debug('Keyset is' + Trigger.newmap.keySet());
    
   inPNRC=AccountUtil.inPNRC(Trigger.newmap.keySet(), vLstNewAccount, true);
   system.debug('in PNRC size' + inPNRC);
   // Similary get list of Account which are not in central org
    
   notinPNRC=AccountUtil.inPNRC(Trigger.newmap.keySet(), vLstNewAccount, false);
   system.debug('Not in PNRC size' + notinPNRC);
   // To insert accounts if not in PNRC
    
   notinPNRC_Unres = new List<Account>();
   notinPNRC_Unres = AccountUtil.FilterAccs(notinPNRC);    
    
   if (notinPNRC_Unres != null)
   {
    AccountUtil.Insert_PNRC(notinPNRC_Unres);
   } // if (notinPNRC_Unres != null)
  
   // To process in PNRC accounts :if isrestricted=false : Do nothing
   // else (if flag is True ) make child record restricted
    
   inPNRC_res = new List<Account>();
   inPNRC_res = AccountUtil.NotFilterAccs(inPNRC);   
   
   if (inPNRC_res != null)
   {
    AccountUtil.childRestrict(inPNRC_res);
   } // if (inPNRC_res != null)  
   AccountUtil.cascadeRestriction(vLstNewAccount, vLstOldAccount);  
   AccountUtil.cascadeUnrestriction(vLstNewAccount, vLstOldAccount); 
   ExecuteOnce.SF2SF_ACCOUNT = True; 
  } // if (!ExecuteOnce.SF2SF_ACCOUNT)   
 } // try
 catch(DmlException vDmlException) 
  {
   vStrErrorCategory = vDmlException.getTypeName();
   vStrLineNumber    = vDmlException.getLineNumber() + '';
   vStrStackTrace    = vDmlException.getStackTraceString();  
   for (Integer j = 0; j < vDmlException.getNumDml(); j++) 
    {
     System.debug(vDmlException.getDmlMessage(j)); 
     vStrError += vDmlException.getDmlMessage(j);   
    } // for (Integer j = 0; j < vDmlException.getNumDml(); j++)  
  } // catch(DmlException vDmlException) 
  catch(Exception vException)
  {
   vStrErrorCategory = vException.getTypeName();
   vStrLineNumber    = vException.getLineNumber() + '';
   vStrStackTrace    = vException.getStackTraceString();  
   vStrError        += vException.getMessage();
  } // catch(Exception vException)
  finally
  {
   ExecuteOnce.SF2SF_ACCOUNT = True; 
   System.debug(vStrLog);
   if (vStrError != null)
   {
    if (vLstNewAccount != null)
    {
     if (vLstNewAccount.size() > 0)
     {
      vStrSfdcRecId = '';
      for (Account vAccount : vLstNewAccount)
      {
       vStrSfdcRecId += vAccount.Id + ' ^ ';   
      } // for (Account vAccount : vLstNewAccount)
     } // if (vLstNewAccount.size() > 0)
    } // if (vLstNewAccount != null)     
    SalesforceException.putError('AccountAU', '', vStrError, SalesforceConstant.strSfdc, SalesforceConstant.strError,
    '', 'SF2SF', '', '5', vStrSfdcRecId, '',vStrErrorCategory, vStrLineNumber,vStrStackTrace);  
   } // if (vStrError != null)
  } // finally    
} // trigger AccountAU on Account(after update)