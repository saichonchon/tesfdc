/**************************************************************************************************************************************************
Name:  AccountUtil
Copyright © 2011 TE Connectivity
===================================================================================================================================================
Purpose: This utility class contains business process methods and technical process methods for sharing account records with central org 
---------------------------------------------------------------------------------------------------------------------------------------------------       
APEX Classes utilize this class : AccountUtil  
---------------------------------------------------------------------------------------------------------------------------------------------------       
APEX Triggers utilize this class: AccountAI, AccountAU, AccountBI, AccountBU
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
Version Developer          Date       Detail                                   Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Rahul Gharat       10/25/2011 Initial Development                      1453487
    1.1 Umasankar Subbaian 10/31/2011 Exception Handling                       1453487
    1.2 Shantinath Patil   05/15/2013 Added metod for Sales Heirarchy Lookup
                                      and Code mapping                                   
    1.3 Sandeep Yadav      07/24/2013 Source BU change related to 
                                      Case # 00438548
    1.4 Shantinath Patil   10/16/2013 Updated the Sales Heirarchy Lookup for
                                      GAM Code
**************************************************************************************************************************************************/
public class AccountUtil 
{

 //  Function to Create UserMap which would be use to add the owner details to custom fields for each record
 public static void getUserMap(List<Account> Accs)
 {
           
           system.debug('Inside getUserMap Accs' + Accs);
            
            Set<Id> UserId=new Set<Id>();
                For(Account a :Accs)
                { 
                    UserId.add(a.OwnerId);
                }
            
           system.debug('Inside getUserMap UserId'+UserId);
            
            
             Map<ID,User> Usermap= new Map<ID,User>([SELECT ID, Name, Email, Phone, GIBU__c from User where ID IN :UserId]) ;
             //String strSourceBu  = TE_Connection__c.getInstance('CentralOrg').Source_BU__c;
              
            For(Account Acc :Accs)
            { 
                    User thisUser = UserMap.get(Acc.OwnerId);
                If (thisUser != null) {
    
                    Acc.BU_Owner_Email__c=thisUser.Email;
                    
                    Acc.BU_Owner_Name__c=thisUser.Name;
                    
                    Acc.BU_Owner_Phone__c=thisUser.Phone ;
                    
                    //Account Source BU been retrieved from Owner’s user record [Case # 00438548]
                    Acc.Source_BU__c   = thisUser.GIBU__c;
                    //Acc.Source_BU__c   = strSourceBu;
                    
                    system.debug('Inside getUserMap'+Acc.BU_Owner_Name__c);
            
            }
           
          }
          
     }    
 

public static void SetAccManagerAsAccOwner(map<Id, Id> map_accId_accManager, map<Id, String> map_accId_accSalesTerritoryCDE, map<Id, Id> map_accId_salesHierarchyId, list<Account> list_accounts){
        
        map<Id, String> map_accManager_userPrimarySalesTerritory = new map<Id, String>();
        map<Id, String> map_accManager_teNetworkId = new map<Id, String>();
        map<Id, String> map_salesHierarchyIds_teNetworkId = new map<Id, String>();
        map<Id, Id> map_accId_ownerId = new map<Id, Id>();
        map<Id, Id> map_accId_salesHierarchyId2Search = new map<Id, Id>();
        
        set<Id> set_accManagerIds = new set<Id>();
        set_accManagerIds.addAll(map_accId_accManager.values());
        
        if(!map_accId_accManager.isEmpty() && !map_accId_accSalesTerritoryCDE.isEmpty()){
            //Step 1: If primary territory code of account manager's user record matches account territory code, then we set Account Owner = Account Manager.
            for(User u : [Select Id, Te_Network_Id__c, Primary_Sales_Territory__c from User]){
                if(set_accManagerIds.contains(u.Id)) map_accManager_userPrimarySalesTerritory.put(u.Id, u.Primary_Sales_Territory__c);
                map_accManager_teNetworkId.put(u.Id, u.Te_Network_Id__c);
            }
            for(Id accId : map_accId_accSalesTerritoryCDE.keySet()){
                if(map_accId_accSalesTerritoryCDE.get(accId) == map_accManager_userPrimarySalesTerritory.get( map_accId_accManager.get(accId) )) 
                    map_accId_ownerId.put(accId,  map_accId_accManager.get(accId));
                else if(map_accId_salesHierarchyId.get(accId) != null && String.ValueOf(map_accId_salesHierarchyId.get(accId)) != ''){
                    map_accId_salesHierarchyId2Search.put(accId, map_accId_salesHierarchyId.get(accId));
                }
            }
            
            //Step 2
            if(!map_accId_salesHierarchyId2Search.isEmpty()){
                for(Sales_Hierarchy__c sh : [SELECT Id, Level_6_Assigned_User_Network_Ids__c FROM Sales_Hierarchy__c WHERE Id in: map_accId_salesHierarchyId2Search.values()]){
                    map_salesHierarchyIds_teNetworkId.put(sh.Id, sh.Level_6_Assigned_User_Network_Ids__c);
                }
                for(Id accId : map_accId_salesHierarchyId2Search.keySet()){
                    for(Id shId : map_salesHierarchyIds_teNetworkId.keySet()){
                        for(Id userId : map_accManager_teNetworkId.keySet()){
                            if(map_accId_salesHierarchyId2Search.get(accId) == shId && map_salesHierarchyIds_teNetworkId.get(shId) == map_accManager_teNetworkId.get(userId))
                                map_accId_ownerId.put(accId,userId);
                        }
                    }
                }   
            }
        }
        if(!map_accId_ownerId.isEmpty()){
            for(Account acc : list_accounts){
                if(map_accId_ownerId.containsKey(acc.Id)) acc.OwnerId = map_accId_ownerId.get(acc.Id);
            }
        }       
    }
    //Account : SALES_TERRITORY_CDE__c  Text(255)
    //Account : Account_Manager__c  Lookup(User)
    //User : Territory_Code__c  Text(10) (External ID) (Unique Case Insensitive)
    //User : Primary_Sales_Territory__c Text(10)    
    
/**                                                    |
|  Commented by Subramanian Jairam for Case# 00901064  |               
|  This method no longer been used                   **/
/*
//Function to Insert the PNRC records      
 public static void Insert_PNRC (List<Account> Accs) 
    {
        
        List<PartnerNetworkRecordConnection> partnerNetworkRecordList = new List<PartnerNetworkRecordConnection>();
  // Fetching the PartnerNetworkConnection Id from the Custom settings   
    
        String conId  = TE_Connection__c.getInstance('CentralOrg').Id_value__c;
        
         for(Account Acc :Accs)
                  {
                    
                    partnerNetworkRecordList.add(SF2SFUtil.newPNRC(conId, Acc.id, 'Contact,Opportunity')); // Calling newPNRC method inside Sharing util class
            }
             //Start Auto sharing
                    if (partnerNetworkRecordList.size() > 0)
                    {
                        insert partnerNetworkRecordList;
                        
                    }  
            
            
        }   
//Filering the Account records based on the Legally_Restricted__c flag and Inserting PartnerNetworkRecordConnection records.
*/
public static List<Account> FilterAccs (List<Account> Accs) 
    {
        system.debug('inside FilterAccs'+Accs);
        List<Account> FilteredAcc= new List<Account>();
        for(Account Acc :Accs)
                  {
                    if(acc.Legally_Restricted__c!=true)
                    FilteredAcc.add(Acc); 
            }
    
        Return FilteredAcc;
    
    }
    
//Filering the Account records based on the Legally_Restricted__c flag true
      
public static List<Account> notFilterAccs (List<Account> Accs) 
    {
        List<Account> FilteredAcc= new List<Account>();
        for(Account Acc :Accs)
                  {
                    if(acc.Legally_Restricted__c==true)
                    FilteredAcc.add(Acc); 
            }
    
        Return FilteredAcc;
    
    } 
    
//To Restrict Child records
    
public static void childRestrict (List<Account> Accs) 
    {
        List<string> AccsId= new List<string> ();
        for(Account acc:Accs)
            {
            Accsid.add(String.valueOf(acc.Id).substring(0,15));
            }
       List<Contact> Con_Rest= new List<Contact>();
       List<Opportunity> Opp_Rest= new List<Opportunity>();
                
       Con_Rest=ContactDAO.getContactsByAccountId(Accsid);
       Opp_Rest= OpportunityDAO.getOpportunitiesByAccountId(Accsid);
       
    
        Integer ChildCount = 0;
  
          if(Opp_Rest!=null)
          ChildCount = Opp_Rest.size();
          
          if(Con_Rest!=null)
          ChildCount +=Con_Rest.size();
       
       
              
       if(ChildCount<=1000)
           {
                    if(Con_Rest!=null)
               {     
               //Further processing     
                for(Contact cons:Con_Rest)
                    {
                    cons.Legally_Restricted__c=true;
                        
                    }
               update Con_Rest; 
               }
          
                    if(Opp_Rest!=null)
               {    
                for(Opportunity opps:Opp_Rest)
                    {
                    opps.Legally_Restricted__c=true;
                        
                    }
                update Opp_Rest; 
                
                }
         }
         else 
             {
                 futurechildRestrict(AccsId);
             }
    }        
    
 //future method to process(restrict) >1000 childs
    @future
    public static void futurechildRestrict (List <String> Accsid ) 
    {
        
       List<Contact> Con_Rest= new List<Contact>();
       List<Opportunity> Opp_Rest= new List<Opportunity>();
                
       Con_Rest=[select Id,Legally_Restricted__c from Contact where accountid  = :Accsid ];
       Opp_Rest=[select Id,Legally_Restricted__c from Opportunity where accountid  = :Accsid];

       //Further processing     
        for(Contact cons:Con_Rest)
    {
    cons.Legally_Restricted__c=true;
        
    }
    update Con_Rest; 
  
        for(Opportunity opps:Opp_Rest)
            {
            opps.Legally_Restricted__c=true;
                
            }
        update Opp_Rest; 

    }        
    
/**                                                    |
|  Commented by Subramanian Jairam for Case# 00901064  |               
|  This method no longer been used                   **/
/*    
// For Update: To get list of Account which are in PNRC    
public static List<Account> inPNRC (Set<Id> Accs,List<Account> AccsNew,boolean Flag) 
    {
        Set<Id> inPNRCId= new Set<Id>();
        Set<Id> NotinPNRCId= new Set<Id>();
        List<Account> inPNRC = new List<Account> ();
        List<Account> NotinPNRC = new List<Account>();
        String conId  = TE_Connection__c.getInstance('CentralOrg').Id_value__c;
        
                for (PartnerNetworkRecordConnection accountSharingRecord : 
                     [SELECT p.Status, p.LocalRecordId, p.ConnectionId
                      FROM PartnerNetworkRecordConnection p             
                      WHERE p.LocalRecordId IN :Accs]) 
                      {
                              if ((accountSharingRecord.status.equalsignorecase('Sent')
                      || accountSharingRecord.status.equalsignorecase('Received'))
                      && (accountSharingRecord.ConnectionId == conId)) 
                          {
                                inPNRCId.add(accountSharingRecord.LocalRecordId);
                             } 
                            
                                                        
                         }
*/
     /*                      
        for(Account accnot:[select Id from account where Id in:Accs])   
        {
        if(!inPNRCId.contains(accnot.id))
            {
                NotinPNRCId.add(accnot.id);
            }
      
        } */
/*
        for(Account a:AccsNew)
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
*/
        /*
        Return [select Id,OwnerId,Legally_Restricted__c from Account where Id in :inPNRCId];
        else
        Return [select Id,OwnerId,Legally_Restricted__c from Account where Id in :NotinPNRCId]; */
        
//    }    

 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Update Contacts and Opportunities are legally unrestricted when Account changes from legally restricted to unrestricted              |
 |   Input : List of Accounts                                                                                                                     |  
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
 public static void cascadeUnrestriction(List<Account> pLstNewAccount, List<Account> pLstOldAccount)
 {
  /*-- 1.0 Collection variable declaration -----------------------------------------*/  
  List<string>      vLstAccountId;
  List<Contact>     vLstContact;
  List<Opportunity> vLstOppty;
  /*-- 1.1 Primitive variable declaration ------------------------------------------*/  
  Integer i; 
  Integer vIntTotalAccounts;
  
  vIntTotalAccounts = pLstNewAccount.size();
  vLstAccountId     = new List<string>();
  
  for (i = 0; i < vIntTotalAccounts; i++)
  {
   if (pLstNewAccount[i].Legally_Restricted__c == false && pLstOldAccount[i].Legally_Restricted__c)  
   {
    vLstAccountId.add(String.valueOf(pLstNewAccount[i].Id).substring(0,15));
   } // if ((pLstNewAccount[i].Legally_Restricted__c == false) && (pLstOldAccount[i].Legally_Restricted__c == true))  
   i++; 
  } // for (i = 0; i < vIntTotalAccounts; i++)
  
  if (vLstAccountId.size() > 0)
  {
   vLstOppty   = OpportunityDAO.getOpportunitiesByAccountId(vLstAccountId);
   vLstContact = ContactDAO.getContactsByAccountId(vLstAccountId);
  } // if (vLstAccountId.size() > 0)
  
  
  Integer ChildCount = 0;
  
  if(vLstOppty != null)
  ChildCount = vLstOppty.size();
  
  if(vLstContact != null)
  ChildCount +=vLstContact.size();
   
       
       if(ChildCount<=1000)
       {
              if (vLstOppty != null)
              {
               if (vLstOppty.size() > 0)
               {
                i = 0;
                for (Opportunity vOppty: vLstOppty)
                {
                 vLstOppty[i].Legally_Restricted__c = false;     
                 i++;
                } // for (Opportunity vOppty: vLstOppty)
                Update vLstOppty;   
               } // if (vLstOppty.size() > 0)  
              } // if (vLstOppty != null)
            
                      if (vLstContact != null)
                      {
                       if (vLstContact.size() > 0)
                       {
                        i = 0;
                        for (Contact vContact: vLstContact)
                        {
                         vLstContact[i].Legally_Restricted__c = false; 
                         i++;    
                        } // for (Contact vOppty: vLstContact)
                        Update vLstContact; 
                        } // if (vLstContact.size() > 0)  
                      } // if (vLstContact != null)
          }      
           else { futurechildUnRestrict(vLstAccountId);}     
                
 } // public static void cascadeUnrestriction
 
 
 //future method to process(Unrestrict) >1000 childs
  @future
    public static void futurechildUnRestrict (List <String> Accsid ) 
    {
        
       List<Contact> Con_Rest= new List<Contact>();
       List<Opportunity> Opp_Rest= new List<Opportunity>();
                
       Con_Rest=[select Id,Legally_Restricted__c from Contact where accountid = :Accsid ];
       Opp_Rest=[select Id,Legally_Restricted__c from Opportunity where accountid = :Accsid];

       //Further processing     
        for(Contact cons:Con_Rest)
    {
    cons.Legally_Restricted__c=False;
        
    }
    update Con_Rest; 
  
        for(Opportunity opps:Opp_Rest)
            {
            opps.Legally_Restricted__c=False;
                
            }
        update Opp_Rest; 

    }  
 
 

 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Update Contacts and Opportunities are legally Restricted when Account changes from legally unrestricted to restricted                |
 |   Input : List of Accounts                                                                                                                     |  
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
 public static void cascadeRestriction(List<Account> pLstNewAccount, List<Account> pLstOldAccount)
 {
  /*-- 1.0 Collection variable declaration -----------------------------------------*/  
  List<string>      vLstAccountId;
  List<Contact>     vLstContact;
  List<Opportunity> vLstOppty;
  /*-- 1.1 Primitive variable declaration ------------------------------------------*/  
  Integer i; 
  Integer vIntTotalAccounts;
  
  vIntTotalAccounts = pLstNewAccount.size();
  vLstAccountId     = new List<string>();
  
  for (i = 0; i < vIntTotalAccounts; i++)
  {
   if (pLstNewAccount[i].Legally_Restricted__c && pLstOldAccount[i].Legally_Restricted__c == false)  
   {
    vLstAccountId.add(String.valueOf(pLstNewAccount[i].Id).substring(0,15));    
   } // if (pLstNewAccount[i].Legally_Restricted__c && pLstOldAccount[i].Legally_Restricted__c == false)  
   i++; 
  } // for (i = 0; i < vIntTotalAccounts; i++)
  
  if (vLstAccountId.size() > 0)
  {
   vLstOppty   = OpportunityDAO.getOpportunitiesByAccountId(vLstAccountId);
   vLstContact = ContactDAO.getContactsByAccountId(vLstAccountId);
System.Debug('Cascaded Restriction on opportunities ' + vLstOppty.size());   
  } // if (vLstAccountId.size() > 0)
  
  if (vLstOppty != null)
  {
   if (vLstOppty.size() > 0)
   {
    i = 0;
    for (Opportunity vOppty: vLstOppty)
    {
     vLstOppty[i].Legally_Restricted__c = true;      
     i++;
    } // for (Opportunity vOppty: vLstOppty)
    Update vLstOppty;   
   } // if (vLstOppty.size() > 0)  
  } // if (vLstOppty != null)

  if (vLstContact != null)
  {
   if (vLstContact.size() > 0)
   {
    i = 0;
    for (Contact vContact: vLstContact)
    {
     vLstContact[i].Legally_Restricted__c = true; 
     i++;    
    } // for (Contact vOppty: vLstContact)
    Update vLstContact; 
   } // if (vLstContact.size() > 0)  
  } // if (vLstContact != null)
  
 } // public static void cascadeRestriction
 
 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : This method checks if the related code for Sales Hierarchy lookup is null or not. If the code is null then set the related           |
 |           lookup to null                                                                                                                       |
 |   Input : List of Accounts                                                                                                                     |  
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
 public static void setSalesHerarchyLookup(List<Account> pListAccount){
   if(pListAccount != null){
     if(!pListAccount.isEmpty()){       
       Set<Id> vParetAccIdSet = new Set<Id>();
       Map<Id, Id> vAccToParentMap = new Map<Id, Id>();
       
       for(Account vTempAccount : pListAccount){
         vAccToParentMap.put(vTempAccount.id, vTempAccount.ParentId);
         vParetAccIdSet.add(vTempAccount.ParentId);
       }
       
       Map<Id, String> vAccToGAMMap = new Map<Id, String>();
       if(!vParetAccIdSet.isEmpty()){
         List<Account> vParentAccList = [SELECT Id, GAMCD__c FROM Account WHERE Id in: vParetAccIdSet AND GAMCD__c != NULL];
         if(!vParentAccList.isEmpty()){
           for(Account vTempAcc : vParentAccList){
              vAccToGAMMap.put(vTempAcc.Id, vTempAcc.GAMCD__c);
           }   
         }
       } 
            
       for(Account vTempAccount : pListAccount){
         if(SalesforceUtil.isNull(vTempAccount.ACCTMGRCD__c)){           
           vTempAccount.FE_Hierarchy__c = null;
         }
         if(SalesforceUtil.isNull(vTempAccount.Relay_Specialist_Territory_Code__c)){
           vTempAccount.Relay_Hierarchy__c = null;
         }
         if(SalesforceUtil.isNull(vTempAccount.SALES_TERRITORY_CDE__c)){
           vTempAccount.Sales_Hierarchy__c = null;
         }
         if(SalesforceUtil.isNull(vTempAccount.GAMCD__c)){
           if(!vAccToGAMMap.values().isEmpty()){
             if(!SalesforceUtil.isNull(vAccToGAMMap.get(vAccToParentMap.get(vTempAccount.Id)))){
               vTempAccount.ParentId = null;    
             }
           }
         }
       }//End of FOR
     }//if(pListAccount.size() > 0)
   }//if(!pListAccount.isEmpty())
 }//public static void setSalesHerarchyLookup(List<Account> pListAccount)
 
 
 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : This method is to populate Country Code on Account Billing Country on insert                                                                 |
 |   Input : List of Accounts                                                                                                                  |  
 | Returns : None                                                                                                                              |
 |    Case : 00901064                                                                                                                          |
 |  Author : Subramanian Jairam                                                                                                                |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 

 public static void setAccountBillingCountry(List<Account> pListAccount)
 {
    // Declaring Variables
    Map<String, String> countryCodeList = new Map<String, String>();
    
    // Fetching Country code from table Live Agent country list
    List<Live_Agent_Country_List__c> liveAgentCountryList = [select Country_Code_2_Digit__c, English__c from Live_Agent_Country_List__c];
    
    // Adding Country code in a Map
    for(Live_Agent_Country_List__c LAC: liveAgentCountryList){
        countryCodeList.put(LAC.English__c.toLowercase(), LAC.Country_Code_2_Digit__c);
    }
    
    // Converting full country name to country code
    for(account acc: pListAccount){        
        if(acc.billingcountry != Null && acc.billingcountry != ''){ 
            if(countryCodeList.containskey(acc.billingcountry.toLowercase()) == TRUE){
                acc.billingcountry = string.ValueOf(countryCodeList.get(acc.billingcountry.toLowercase()));
            } else if(acc.billingcountry.length() > 2){
                acc.billingcountry = 'US';
            }           
        }else{
            acc.billingcountry = 'US';
        }   
        
    }// Ending for loop
 }//public static void setAccountBillingCountry(List<Account> pListAccount)
 
/*-----------------------------------------------------------------------------------------------------------------------------------------------*/
 
} // public class AccountUtil