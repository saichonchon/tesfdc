/**************************************************************************************************************************************************
Name: ContactAI 
Copyright © 2011 TE Connectivity | Salesforce Instance : BU Org
===================================================================================================================================================
Purpose: This trigger shares the contact from child org to central org                                                  
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR                DATE       DETAIL                                            Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Rahul Gharat          10/25/2011 Initial Development - SF2SF                       Multi Structured Org (1453487)  
    1.1 Umasankar Subbaian    10/26/2011 Exception Handling                                1453487 
**************************************************************************************************************************************************/
trigger ContactAI on Contact(after insert) 
{
 /*-- 1 Collection variable declaration -------------------------------------*/
 List<Contact> vLstContact; 
 List<Contact> ParentedUnrestrictedContacts =  new List<Contact>();
 List<Contact> ParentedrestrictedContacts   =  new List<Contact>();
 
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
   // Get list of Parented cum Unrestricted Contacts 
   ParentedUnrestrictedContacts = ContactUtil.getParentedUnrestrictedContacts(vLstContact);
     
     
   // Get list of contacts where the corresponding parent is not restricted 
   ParentedrestrictedContacts = ContactUtil.IsParentRestricted(ParentedUnrestrictedContacts, false );      
   ExecuteOnce.SF2SF_CONTACT = True;
   ContactUtil.Insert_PNRC(ParentedrestrictedContacts);
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
    if (ParentedrestrictedContacts != null)
    {
     if (ParentedrestrictedContacts.size() > 0)
     {
      vStrSfdcRecId = '';
      for (Contact vContact : ParentedrestrictedContacts)
      {
       vStrSfdcRecId += vContact.Id + ' ^ ';   
      } // for (Contact vContact : ParentedrestrictedContacts)
     } // if (ParentedrestrictedContacts.size() > 0)
    } // if (ParentedrestrictedContacts != null)    
    SalesforceException.putError('ContactAI', '', vStrError, SalesforceConstant.strSfdc, SalesforceConstant.strError,
    '', 'SF2SF', '', '5', vStrSfdcRecId, '',vStrErrorCategory, vStrLineNumber,vStrStackTrace);  
   } // if (vStrError != null)
  } // finally
  
 /*----------------------------------------------------------------------------------------------------------------------------------------------*/
 
} // End of trigger ContactAI on Contact (after insert)