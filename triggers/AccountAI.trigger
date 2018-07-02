/**************************************************************************************************************************************************
Name: AccountAI 
Copyright © 2011 TE Connectivity | Salesforce Instance : BU Org
===================================================================================================================================================
Purpose: This trigger shares the Account from child org to central org                                                  
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR                DATE       DETAIL                                                         Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Rahul Gharat          10/25/2011 Initial Development - SF2SF                                    1453487  
    1.1 Umasankar Subbaian    11/02/2011 Exception Handling                                             1453487
    1.2 Umasankar Subbaian    12/06/2011 Allow sharing account and its child records to central org     1453487
**************************************************************************************************************************************************/
trigger AccountAI on Account (after insert) 
{
 /*-- 1 Collection variable declaration --------------------------------------*/     
 List<Account> vLstFilteredAccount;
 List<Account> vLstNewAccount;
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
   vLstNewAccount      = Trigger.new; // Use this variable for future coding  
   vLstFilteredAccount = new List<Account>();
   vLstFilteredAccount = AccountUtil.FilterAccs(vLstNewAccount);
   system.debug('Total account records : ' + vLstNewAccount.size());
   ExecuteOnce.SF2SF_ACCOUNT = true;
   AccountUtil.Insert_PNRC(vLstFilteredAccount);
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
   System.debug(vStrLog);
   if (vStrError != null)
   {
    if (vLstFilteredAccount != null)
    {
     if (vLstFilteredAccount.size() > 0)
     {
      vStrSfdcRecId = '';
      for (Account vAccount : vLstFilteredAccount)
      {
       vStrSfdcRecId += vAccount.Id + ' ^ ';   
      } // for (Account vAccount : vLstFilteredAccount)
     } // if (vLstFilteredAccount.size() > 0)
    } // if (vLstFilteredAccount != null)   
    SalesforceException.putError('AccountAI', '', vStrError, SalesforceConstant.strSfdc, SalesforceConstant.strError,
    '', 'SF2SF', '', '5', vStrSfdcRecId, '',vStrErrorCategory, vStrLineNumber,vStrStackTrace);  
   } // if (vStrError != null)
  } // finally    
  
 /*----------------------------------------------------------------------------------------------------------------------------------------------*/
  
} // trigger AccountAI on Account