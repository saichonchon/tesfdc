/**************************************************************************************************************************************************
Name: ContactBI 
Copyright © 2011 TE Connectivity | Salesforce Instance : BU Org
===================================================================================================================================================
Purpose: This trigger populate user information (BU Owner Name, BU Owner Email, BU Owner Phone) and Source BU in the Contact custom fields.                                                  
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR                DATE       DETAIL                                            Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Rahul Gharat          10/25/2011 Initial Development - SF2SF                       1453487 
    1.1 Umasankar Subbaian    12/06/2011 Make contact creatable with account               1453487 
**************************************************************************************************************************************************/
trigger ContactBI on Contact(before insert) 
{
 /*-- 1 Collection variable declaration --------------------------------------*/ 
 List<Contact> vLstContact;
 List<Contact> ParentedUnrestrictedContacts;
 List<Contact> ParentedrestrictedContacts;
     
 if (!ExecuteOnce.SF2SF_CONTACT)
 {
  vLstContact                  = Trigger.new;
  ParentedUnrestrictedContacts = new List<Contact>();
  ParentedrestrictedContacts   = new List<Contact>();      
     
  // Get list of ParentedUnrestrictedContacts 
  ParentedUnrestrictedContacts = ContactUtil.getParentedUnrestrictedContacts(vLstContact);
     
  // Make Orphan restrcted
  ContactUtil.MakeOrphanrestricted(vLstContact);
     
  // Get list of contacts where the corresponding parent is restricted     
  ParentedrestrictedContacts = ContactUtil.IsParentRestricted(ParentedUnrestrictedContacts, true);
     
  // Make the child restricted
  ContactUtil.Makechildrestricted(ParentedrestrictedContacts);
     
  // Populate the User information
  ContactUtil.getUserMap(vLstContact);
   
 } // if (!ExecuteOnce.SF2SF_CONTACT)
 
 /*----------------------------------------------------------------------------------------------------------------------------------------------*/
 
} // End of trigger ContactBI on Contact(before insert)