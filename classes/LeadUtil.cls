/**********************************************************************************************************************
 Name:  LeadUtil
 Copyright © 2011 TE Connectivity | Salesforce Instance : BU Org
=======================================================================================================================
 Purpose: This utility class contains business process methods and technical process methods for transferring Leads 
          from BU Org to Central Org
-----------------------------------------------------------------------------------------------------------------------
 APEX Classes utilize this class : 
-----------------------------------------------------------------------------------------------------------------------
 APEX Triggers utilize this class: LeadAI, LeadAU
=======================================================================================================================
Requirement Information & Development Information:                                                     
-----------------------------------------------------------------------------------------------------------------------
Version Developer          Date       Detail                                   Mercury Request #
-----------------------------------------------------------------------------------------------------------------------
    1.0 Rahul Gharat       01/06/2012 Initial Development                      1453487
    1.1 Umasankar Subbaian 01/10/2012 Insert entry for Lead in PNRC            1453487                              
    1.2 Sandeep Yadav      7/24/2013  Source BU change related to 
                                      Case # 00438548
**********************************************************************************************************************/
public class LeadUtil
{

//Lead Conversion function-I
public static void leadConvMap(List<Lead> Leads) 
{
      List<Lead_Conversion_Map__c> vLstLeadConMap= new List<Lead_Conversion_Map__c> ();

      
      for(Lead ConvLead:Leads)
      {
        Lead_Conversion_Map__c L_ConvMap= new Lead_Conversion_Map__c();
        
          L_ConvMap.LeadID_BU__c=ConvLead.Id;
          L_ConvMap.LeadID_CO__c=ConvLead.X18_Digit_ID_CO__c;
      
      // if a new account was created
          if (ConvLead.ConvertedAccountId != null) {
     
            L_ConvMap.Converted_AccountId__c= ConvLead.ConvertedAccountId;       
          }          
     
          // if a new contact was created
          if (ConvLead.ConvertedContactId != null) {
     
            L_ConvMap.Converted_ContactId__c= ConvLead.ConvertedContactId ;
     
          }
     
          // if a new opportunity was created
          if (ConvLead.ConvertedOpportunityId != null) {
     
            L_ConvMap.Converted_OpportunityId__c= ConvLead.ConvertedOpportunityId ;
          }         
          
          vLstLeadConMap.add(L_ConvMap);
     
    }// end of for loop
        
        // insert a custom object associated with lead
        if(vLstLeadConMap!=null)
        Insert vLstLeadConMap;
        
        //Create entry for Lead_conv_map in PNRC
        
        insertLCMPNRC(vLstLeadConMap);


}// end of Lead_Conv_Map function

        public static void putCOLeadId(List<Lead> LeadsIds) 
                {
                set<Id> LeadidSET =new set<Id>();
                Map<ID,ID> PNRCmap =new Map<ID,ID>();
                for(Lead tempLead: LeadsIds)
                {
                LeadidSET .add(tempLead.id);                
                }
                
            List<PartnerNetworkRecordConnection> PNRCLeads = [select localrecordid ,PartnerRecordId  from PartnerNetworkRecordConnection where localrecordid in :LeadidSET and status !='Converted'];
    
            for(PartnerNetworkRecordConnection pnrc : PNRCLeads )
            {
            PNRCmap.put(pnrc.localrecordid ,pnrc.PartnerRecordId  );
            
            }
            
            for(Lead LeadUpdate: LeadsIds)
            {
            LeadUpdate.X18_Digit_ID_CO__c=PNRCmap.get(LeadUpdate.Id);            
            }
            
            
        }
        
        
        

//user info

    public static void getUserMap(List<Lead> LeadsUser) 
    {
           Set<Id> UserId=new Set<Id>();
                For(Lead a :LeadsUser)
                { 
                    UserId.add(a.OwnerId);
                }
            
           system.debug('Inside getUserMap UserId'+UserId);
            
            
             Map<ID,User> Usermap= new Map<ID,User>([SELECT ID, Name, Email, Phone, GIBU__c from User where ID IN :UserId]) ;
             
             /*String strSourceBu  = '';
             try{
             strSourceBu =TE_Connection__c.getInstance('CentralOrg').Source_BU__c;
               } catch (Exception e) {  
               System.debug(Logginglevel.INFO,  '******* connection info null******');
               }*/
            For(Lead L:LeadsUser)
            { 
                    User thisUser = UserMap.get(L.OwnerId);
                If (thisUser != null) {
    
                    L.BU_Owner_Email__c=thisUser.Email;
                    
                    L.BU_Owner_Name__c=thisUser.Name;
                    
                    L.BU_Owner_Phone__c=thisUser.Phone ;
                    
                    //Lead Source BU been retrieved from Owner’s user record [Case # 00438548]
                    L.Source_BU__c   = thisUser.GIBU__c;
                    
                    //L.Source_BU__c   = strSourceBu;
                    
                    system.debug('Inside getUserMap'+L.BU_Owner_Name__c);
            
            }
           
          }
    }

//Lead Conversion function-II
//Function to Insert the PNRC records -Insert_LCM_PNRC  
   
 public static void insertLCMPNRC(List<Lead_Conversion_Map__c> LCMs) 
    {
        
        List<PartnerNetworkRecordConnection> partnerNetworkRecordList = new List<PartnerNetworkRecordConnection>();
  // Fetching the PartnerNetworkConnection Id from the Custom settings   
    
        String conId  = TE_Connection__c.getInstance('CentralOrg').Id_value__c;
        
         for (Lead_Conversion_Map__c L_convMap:LCMs)
         {             
          partnerNetworkRecordList.add(SF2SFUtil.newPNRC(conId, L_convMap.id,'')); // Calling newPNRC method inside Sharing util class
         }
             //Start Auto sharing
              if (partnerNetworkRecordList.size() > 0)
                    {
                        insert partnerNetworkRecordList;
                        
                    }  
            
            }
            
 /*____________________________________________________________________________________________________________________
 | Purpose : Create entries for list of leads in PNRC, so as to transfer from BU Org to Central Org                   |
 |____________________________________________________________________________________________________________________|
 | Input Parameter  :                                                                                                 |
 |____________________________________________________________________________________________________________________|
 |  I1. Name        : List of Leads                                                                                   | 
 |      Data Type   : List<Lead>                                                                                      | 
 |      Description :                                                                                                 |  
 |____________________________________________________________________________________________________________________|
 | Output Parameter : None                                                                                            |
 |___________________________________________________________________________________________________________________*/ 
 public static void createLeadInPNRC(List<Lead> vLstLead)
 {
  /*-- D1 Collection variable declaration --------------------------------------*/
  List<PartnerNetworkRecordConnection>  vLstPnrc = new List<PartnerNetworkRecordConnection>(); 
  String vStrConId  = TE_Connection__c.getInstance('CentralOrg').Id_value__c;
  for (Lead vLead: vLstLead)
  {
   if (vLead.IsConverted == false)
   { // Insufficient access on the entity - Fix 03/30/2012
    vLstPnrc.add(SF2SFUtil.newPNRC(vStrConId,vLead.Id));
   } // if (vLead.IsConverted == false) 
  } // for (Lead vLead: vLstLead)
  
  if (vLstPnrc.size() > 0)
  {
   Insert vLstPnrc;
  } // if (vLstPnrc.size() > 0)
     
 } // public static void createLeadInPNRC(List<Lead> vLstLead)

/*-------------------------------------------------------------------------------------------------------------------------------------------------
 |    Purpose : Get entries in PNRC to be created for Lead                                                                                        |
 | Parameters : List of Leads                                                                                                                     |
 |    Returns : List of Leads                                                                                                                     |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
 public static List<Lead> getTobeEnteredLeadsInPnrc(List<Lead> pLstLead)
 {
  /*-- D1 Collection variable declaration --------------------------------------*/
  List<Lead>                            vLstLead   = new List<Lead>();
  List<PartnerNetworkRecordConnection>  vLstPnrc   = new List<PartnerNetworkRecordConnection>(); 
  List<Id>                              vLstLeadId = new List<Id>(); 
  Map<Id,Id>                            vMapLeadIdInPnrc;
  for (Lead vLead : pLstLead)
  {
   vLstLeadId.add(vLead.Id);
  } // for (Lead vLead : pLstLead)
  vLstPnrc = ConnectionDAO.getPnrcByLocalRecId(vLstLeadId);      
  if (vLstPnrc != null)
  {
   if (vLstPnrc.size() > 0)
   {
    vMapLeadIdInPnrc = new Map<Id,Id>();
    for (PartnerNetworkRecordConnection vPnrc: vLstPnrc)
    {
     vMapLeadIdInPnrc.put(vPnrc.LocalRecordId,vPnrc.LocalRecordId);
    } // for (PartnerNetworkRecordConnection vPnrc: vLstPnrc)
   } // if (vLstPnrc.size() > 0)
  } // if (vLstPnrc != null) 
  
  if (vMapLeadIdInPnrc == null)
  {
   
   vLstLead.addAll(pLstLead);
  } // if (vMapLeadIdInPnrc == null) 
  else
  {
   for (Lead vLead: pLstLead)
   {
    if (vMapLeadIdInPnrc.get(vLead.Id)== null)
    {
     vLstLead.add(vLead);
    } // e..if (vMapLeadIdInPnrc.contains(vLead.Id))    
   } // for (Lead vLead: pLstLead)
   
  } // if (vMapLeadIdInPnrc == null)
  
  return vLstLead;
 } // public static void getTobeEnteredLeadsInPnrc()
 
 
 
  public static List<Lead> getBULeads(List<Lead> pLstNewLead)
 {
  /*-- D1. Collection variable declaration --------------------------------------*/
  List<Lead> vLstLead;
  
  if (pLstNewLead!= null)
  {
   if (pLstNewLead.size() > 0)
   {
     vLstLead = new List<Lead>();
    
    for (integer i=0;i<pLstNewLead.size();i++) 
    {
     if (pLstNewLead[i].ConnectionReceivedId == null   )
     {
      vLstLead.add(pLstNewLead[i]);
     } // if (vLead.ConnectionReceivedId  == null)
    } // for (Lead vLead: pLstLead) 
   } // if (pLstLead.size() > 0)
  } // if (pLstLead != null)
  return vLstLead ;
 } // public static List<Lead> getBULeads
 
 
 
 public static List<Lead> getBULeads(List<Lead> pLstNewLead,List<Lead> pLstOldLead)
 {
  /*-- D1. Collection variable declaration --------------------------------------*/
  List<Lead> vLstLead;
  
  if (pLstNewLead!= null)
  {
   if (pLstNewLead.size() > 0)
   {
     vLstLead = new List<Lead>();
    
    for (integer i=0;i<pLstNewLead.size();i++) 
    {
     if (pLstNewLead[i].ConnectionReceivedId == null && pLstOldLead[i].ConnectionReceivedId == null  )
     {
      vLstLead.add(pLstNewLead[i]);
     } // if (vLead.ConnectionReceivedId  == null)
    } // for (Lead vLead: pLstLead) 
   } // if (pLstLead.size() > 0)
  } // if (pLstLead != null)
  return vLstLead ;
 } // public static List<Lead> getBULeads

 /*____________________________________________________________________________________________________________________
 | Purpose : Determine whether the central org originated lead is rejected at BU org and set the controlling          |
 |           attribute 'IsCoLeadRejected__c' to true                                                                  |
 |____________________________________________________________________________________________________________________|
 | Input Parameter  :                                                                                                 |
 |____________________________________________________________________________________________________________________|
 |  I1. Name        : List of Leads                                                                                   | 
 |      Data Type   : List<Lead>                                                                                      | 
 |      Description : Trigger.New                                                                                     |
 |  I2. Name        : List of Leads                                                                                   | 
 |      Data Type   : List<Lead>                                                                                      | 
 |      Description : Trigger.Old                                                                                     | 
 |____________________________________________________________________________________________________________________| 
 | Output Parameter : None                                                                                            |
 |___________________________________________________________________________________________________________________*/  
 public static void determineRejectionAtBuOrg(List<Lead> pLstNewLead, List<Lead> pLstOldLead)
 {
  /*-- D1. Primitive variable declaration --------------------------------------*/
  Integer i = 0;
  Integer vIntTotalLeads = 0;
  if (pLstNewLead != null)
  {
   vIntTotalLeads = pLstNewLead.size();
   
   for (i = 0; i < vIntTotalLeads; i++)
   {
    if (pLstNewLead[i].ConnectionReceivedId != null && pLstNewLead[i].Status.toUpperCase() == 'REJECTED' && 
        pLstOldLead[i].Status.toUpperCase() != 'REJECTED')
    {
     pLstNewLead[i].IsCoLeadRejected__c = true;
    } // if (pLstNewLead[i].ConnectionReceivedId != null && pLstNewLead[i].Status.toUpperCase() == 'REJECTED' && ...
   } // for (i = 0; i < vIntTotalLeads; i++)  
  } // if (pLstNewLead != null)
  
 } // public static void determineRejectionAtBuOrg
 
 /*__________________________________________________________________________________________________________________*/ 
  
 } // End of public class LeadUtil