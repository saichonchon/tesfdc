/**************************************************************************************************************************************************
Name: ContactAU 
Copyright © 2011 TE Connectivity | Salesforce Instance : BU Org
===================================================================================================================================================
Purpose: This trigger shares the changes in contact records from child org to central org                                                  
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR                DATE       DETAIL                                            Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Rahul Gharat          10/27/2011 Initial Development - SF2SF                       1453487  
    1.1 Umasankar Subbaian    11/02/2011 Exception Handling                                1453487
**************************************************************************************************************************************************/
trigger ContactAU on Contact (after update) 
{
 /*-- 1 Collection variable declaration --------------------------------------*/     
 List<Contact> vLstContact;
 List<Contact> notinPNRC;
 List<Contact> ParentedUnrestrictedContacts;
 
 /*-- 2. Primitive variable declaration --------------------------------------*/ 
 String  vStrErrorCategory       = '';
 String  vStrLineNumber          = '';
 String  vStrStackTrace          = '';
 String  vStrError               = '';
 String  vStrLog                 = ''; 
 String  vStrSfdcRecId           = ''; 
 
 try
 {
  if (!ExecuteOnce.SF2SF_CONTACT)
  {
   vLstContact = trigger.new;  
   // Processing Not in PNRC... 
   notinPNRC                    = new List<Contact>();
   ParentedUnrestrictedContacts = new List<Contact>();
        
   // Get list of Contact which are not in central org by calling inPNRC method
    
   notinPNRC = ContactUtil.inPNRC(Trigger.newmap.keySet(), vLstContact, false);
   system.debug('Not in PNRC size' + notinPNRC);
    
   // Get the contacts where parent id not null and Legally Restricted is false

   ParentedUnrestrictedContacts = ContactUtil.getParentedUnrestrictedContacts(notinPNRC);
   system.debug('ParentedUnrestrictedContacts  size ' + ParentedUnrestrictedContacts );
    
   // Insert PNRC for unrestricted Contacts
   if (ParentedUnrestrictedContacts != null)
   {
    ContactUtil.Insert_PNRC(ParentedUnrestrictedContacts );
   } // if (ParentedUnrestrictedContacts != null)
   
   ExecuteOnce.SF2SF_CONTACT = true;
  } // if (!ExecuteOnce.SF2SF_CONTACT)
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
    if (ParentedUnrestrictedContacts != null)  
    {
     if (ParentedUnrestrictedContacts.size() > 0)
     {
      vStrSfdcRecId = '';
      for (Contact vContact : ParentedUnrestrictedContacts)
      {
       vStrSfdcRecId += vContact.Id + ' ^ ';   
      } // for (Contact vContact : ParentedUnrestrictedContacts)
     } // if (ParentedUnrestrictedContacts.size() > 0)
    } // if (ParentedUnrestrictedContacts != null)  
    
    SalesforceException.putError('ContactAU', '', vStrError, SalesforceConstant.strSfdc, SalesforceConstant.strError,
    '', 'SF2SF', '', '5', vStrSfdcRecId, '',vStrErrorCategory, vStrLineNumber,vStrStackTrace);  
   } // if (vStrError != null)
  } // finally 

 /*----------------------------------------------------------------------------------------------------------------------------------------------*/
  
} // End of trigger ContactAU on Contact