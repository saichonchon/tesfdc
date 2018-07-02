/**************************************************************************************************************************************************
Name: ContactBU 
Copyright © 2011 TE Connectivity | Salesforce Instance : BU Org
===================================================================================================================================================
Purpose: This trigger shares the contact from child org to central org                                                  
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR                DATE       DETAIL                                            Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Rahul Gharat          10/25/2011 Initial Development - SF2SF                       1453487 
    1.1 Umasankar Subbaian    10/26/2011 Exception Handling                                1453487 
**************************************************************************************************************************************************/
trigger ContactBU on Contact(before update) 
{
 /*-- 1 Collection variable declaration -------------------------------------*/
 List<Contact> vLstContact;
 List<Contact> inPNRC;
 List<Contact> notinPNRC;
 
 if (!ExecuteOnce.SF2SF_CONTACT)
 {       
  vLstContact = Trigger.new;
  inPNRC      = new List<Contact>();
  notinPNRC   = new List<Contact>();
    
  // Get the list of Contact which are already shared with the central org
  // by calling inPNRC method
    
  System.Debug('Keyset is'+Trigger.newmap.keySet());
    
  inPNRC = ContactUtil.inPNRC(Trigger.newmap.keySet(), vLstContact, true);
  System.Debug('in PNRC size ' + inPNRC);
    
  // Similary get list of Contact which are not in central org
    
  notinPNRC = ContactUtil.inPNRC(Trigger.newmap.keySet(), vLstContact, false);
  System.Debug('Not in PNRC size : ' + notinPNRC);
    
  // not in PNRC precessing...
    
  List<Contact > ParentedUnrestrictedContacts =  new List<Contact >();
  
  List<Contact > ParentedrestrictedContacts =  new List<Contact >();
       
  // Get list of ParentedUnrestrictedContacts 
  ParentedUnrestrictedContacts = ContactUtil.getParentedUnrestrictedContacts(notinPNRC);
     
  // Make contact restricted if new Parent is restricted
  if (ParentedUnrestrictedContacts != null)
  {
   ParentedrestrictedContacts = ContactUtil.IsParentRestricted(ParentedUnrestrictedContacts,true );
   if(ParentedrestrictedContacts !=null)
   {
    ContactUtil.Makechildrestricted(ParentedrestrictedContacts );
   }  
  } // if (ParentedUnrestrictedContacts != null)
  
      
  // To copy User data if Parent is not restricted
  if (ParentedUnrestrictedContacts != null)
  {  
   ContactUtil.getUserMap(ContactUtil.IsParentRestricted(ParentedUnrestrictedContacts,false)); 
  } // if (ParentedUnrestrictedContacts != null)
     
  // ....end of not in PNRC processing     
         
  // In PNRC processing >>>>    
     
  // If record is not restricted but Orphan make it restricted
  ContactUtil.MakeOrphanrestricted(inPNRC);
     
 // List<Contact > ParentedUnrestrictedContacts_OwnerChk =  new List<Contact >();
       
  // To get list of records where parent id not null and Legally Restricted is false     
 // ParentedUnrestrictedContacts_OwnerChk=ContactUtil.getParentedUnrestrictedContacts(inPNRC);
         
  // check for owner change
 // if (ParentedUnrestrictedContacts_OwnerChk != null) 
 
   ContactUtil.Chk_Ownerchange(vLstContact);
   // if (ParentedUnrestrictedContacts_OwnerChk != null) 
           
 } // if (!ExecuteOnce.SF2SF_CONTACT)

 /*----------------------------------------------------------------------------------------------------------------------------------------------*/
 
} // trigger ContactBU on Contact(before update)