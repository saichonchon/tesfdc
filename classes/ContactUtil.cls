/**************************************************************************************************************************************************
Name: ContactUtil 
Copyright © 2011 TE Connectivity
===================================================================================================================================================
Purpose: This is the utility class for contact based business process methods and technical process methods
---------------------------------------------------------------------------------------------------------------------------------------------------
Classes Called  : AccountDAO
---------------------------------------------------------------------------------------------------------------------------------------------------
Related Trigger : ContactAI                                                
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR              DATE       DETAIL                                            Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Rahul Gharat        10/25/2011 Initial Development - SF2SF                       Multi Structured Org (1453487)  
    1.1 Umasankar Subbaian  10/26/2011 Calling AccountDAO                                1453487    
    1.3 Sandeep Yadav       7/24/2013  Source BU change related to 
                                       Case # 00438548
**************************************************************************************************************************************************/
public class ContactUtil 
{

 public static List<Contact> IsParentRestricted (List<Contact> Cons, boolean Isrestricted)
     {
            
            List<Contact> ParentRestrictedCons   = new List<Contact>();
            List<Contact> NOtParentRestrictedCons= new List<Contact>();
            
            Set<Id> AccId=new Set<Id>();
                For(Contact c :Cons)
                { 
                    AccId.add(c.AccountId);
                }
      
             Map<ID,Account> Accmap= new Map<ID,Account>([SELECT ID, Name, Legally_Restricted__c from Account where ID IN :AccId]) ;
            
            For(Contact con :Cons)
            { 
                    Account TempAcc = Accmap.get(con.AccountId);
                    System.debug('TempAcc is'+TempAcc );
                    
               if(   TempAcc !=null)
             {    
                If (TempAcc.Legally_Restricted__c ==True) 
                {
                        ParentRestrictedCons.add(con);
                }
                else{
                        NOtParentRestrictedCons.add(con);
                
                }
              }  
           
          }
          if(Isrestricted==true)
          {
          Return ParentRestrictedCons;
                    }
          else
          Return NOtParentRestrictedCons;
          
         
          
          
          //Processing if Parent is not restrcted : Do nothing as Owner info is already populated.
          
     }
     
      //Processing if Parent is Restricted
  public static void Makechildrestricted (List<Contact> Cons)
     {   
        For(Contact con :Cons)
            { 
             con.Legally_Restricted__c=True;                
            }
          
        
     }
     
  public static void MakeOrphanrestricted (List<Contact> Cons)
     {   
        For(Contact con :Cons)
            { 
                 if(con.AccountId == null)
                 { 
                 con.Legally_Restricted__c=True;                
                }
            }
        
     }
     
     //Function to Insert the PNRC records      
 public static void Insert_PNRC (List<Contact> Cons) 
    {
        
        List<PartnerNetworkRecordConnection> partnerNetworkRecordList = new List<PartnerNetworkRecordConnection>();
  // Fetching the PartnerNetworkConnection Id from the Custom settings   
    
        String conId  = TE_Connection__c.getInstance('CentralOrg').Id_value__c;
        
         for(Contact con :Cons)
                  {
                    
                    partnerNetworkRecordList.add(SF2SFUtil.newPNRC(conId, con.id,con.AccountId)); //Calling newPNRC method inside Sharing util class
            }
             //Start Auto sharing
                    if (partnerNetworkRecordList.size() > 0)
                    {
                        insert partnerNetworkRecordList;
                        
                    }  
            
            
        } 
        
          
// For Update: To get list of Contact which are in PNRC    
   
   public static List<Contact> inPNRC (Set<Id> Cons,List<Contact> ConsNew,boolean Flag) 
    {
        Set<Id> inPNRCId= new Set<Id>();
        
        List<Contact> inPNRC = new List<Contact> ();
        List<Contact> NotinPNRC = new List<Contact>();
        
        String conId  = TE_Connection__c.getInstance('CentralOrg').Id_value__c;
        
        for (PartnerNetworkRecordConnection ContactSharingRecord : 
                     [SELECT p.Status, p.LocalRecordId, p.ConnectionId
                      FROM PartnerNetworkRecordConnection p             
                      WHERE p.LocalRecordId IN :Cons]) 
                      {
                       
                        // List for inPnrc
                         if ( (ContactSharingRecord.status.equalsignorecase('Deleted') || ContactSharingRecord.status.equalsignorecase('Inactive')))                       
                         { // Nothing
                         }
                         else
                         {                       
                          inPNRCId.add(ContactSharingRecord.LocalRecordId);
                          }                                                       
                        
                                          
        }
        

        for(Contact a:ConsNew)
        {
        if(inPNRCId.contains(a.id))
        inPNRC.add(a);
        else
        NotinPNRC.add(a);
        }
                     
       if(Flag==True)
        Return inPNRC;
        else
        Return NotinPNRC;
             
        
    }  
   
     
    //For Before Update:To check for Owner change and call Get user to populate new Owner information       
public static void Chk_Ownerchange (List<Contact> Cons) 
    {
        /*List<Contact> Cons_U= new List<Contact>();
        for(Contact con :Cons)
            {
                       
                Id oldOwnerId = oldMap.get(con.Id).OwnerId;
                if(oldOwnerId!=con.OwnerId)
                    {
                    Cons_U.add(con);
                    }
            } */
            getUserMap(Cons);
    } 
     
 /*
 |    Purpose : To Populate User information                                              |
 | Parameters : List of Contacts                                                                                                                  |
 |    Returns : List of Contacts
 
 */    
  public static void getUserMap(List<Contact> Cons)
  {
            //String strSourceBu  = TE_Connection__c.getInstance('CentralOrg').Source_BU__c;
            
            Set<Id> UserId=new Set<Id>();
                For(Contact a :Cons)
                { 
                    UserId.add(a.OwnerId);
                }
      
             Map<ID,User> Usermap= new Map<ID,User>([SELECT ID, Name, Email, Phone, GIBU__c from User where ID IN :UserId]) ;
            
            For(Contact con :Cons)
            { 
                    User thisUser = UserMap.get(con.OwnerId);
                If (thisUser != null) {
    
                    con.BU_Owner_Email__c=thisUser.Email;
                    
                    con.BU_Owner_Name__c=thisUser.Name;
                    
                    con.BU_Owner_Phone__c=thisUser.Phone ;
            
                    //Contact Source BU been retrieved from Owner’s user record [Case # 00438548]
                    con.Source_BU__c   = thisUser.GIBU__c;
                    
                    //con.Source_BU__c   = strSourceBu;
                    
            }// end of If (thisUser != null)
           
          }// end of forloop Acc
          
     }    
     
 /*------------------------------------------------------------------------------------------------------------------------------------------------
 |    Purpose : Filter and get the contacts where parent id not null and Legally Restricted is false                                              |
 | Parameters : List of Contacts                                                                                                                  |
 |    Returns : List of Contacts                                                                                                                  |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
 public static List<Contact> getParentedUnrestrictedContacts(List<Contact> pLstcontact)
 {
  /*-- 1.0 Collection variable declaration --------------------------------------*/
  List<Contact> vLstContact;
  if (pLstcontact != null)
  {
   if (pLstcontact.size() > 0)
   {
    vLstContact = new List<Contact>();
    for (Contact vContact: pLstcontact)
    {   
     if ((vContact.AccountId != null) && (vContact.Legally_Restricted__c == false))
     {
      vLstContact.add(vContact);
     } // if ((vContact.ParentId != null) && (vContact.Legally_Restricted__c == false))
    } // for (Contact vContact: pLstcontact)
   } // if (pLstcontact.size() > 0)
  } // if (pLstcontact != null)
  
  return vLstContact;   
 } // public static List<Contact> getParentedContacts

 /*-----------------------------------------------------------------------------------------------------------------------------------------------*/ 
 
} // End of ContactUtil