/***********************************************************************************************************************
 Name: LeadConversionUtil 
 Copyright © 2012 TE Connectivity | Salesforce Instance : BU Org
========================================================================================================================
 Purpose: Captures Key Salesforce Identifiers from BU org and sends it to Central Org for closing the converted lead 
          loop  
------------------------------------------------------------------------------------------------------------------------
 Classes utilizing "LeadConversionUtil" :  
------------------------------------------------------------------------------------------------------------------------
 Triggers utilizing "LeadConversionUtil": LeadAU                                           
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                       
------------------------------------------------------------------------------------------------------------------------
 VERSION AUTHOR              DATE       DETAIL                                            MERCURY REQUEST #
------------------------------------------------------------------------------------------------------------------------
    1.0 Umasankar Subbaian  06/05/2012 Initial Development - SF2SF                       271483     
***********************************************************************************************************************/
public class LeadConversionUtil 
{
 /*_____________________________________________________________________________________________________________________
 | Purpose : Create records in "Lead Conversion Map" sObject to close lead loop                                        |
 |_____________________________________________________________________________________________________________________|
 | Input Parameter  :                                                                                                  |
 |_____________________________________________________________________________________________________________________|
 |  I1. Name        : pLstLead                                                                                         | 
 |      Data Type   : List<Lead>                                                                                       | 
 |      Description : List of Lead Records                                                                             |
 |_____________________________________________________________________________________________________________________|
 | Output Parameter : None                                                                                             |
 |____________________________________________________________________________________________________________________*/ 
 public static void buildLeadConversionMap(List<Lead> pLstLead) 
 {
  /* _____________________________ D1. COLLECTION VARIABLE DECLARATION ____________________________*/  
  List<Lead_Conversion_Map__c> vLstLeadConMap;
  /* _______________________________ D2. OBJECT VARIABLE DECLARATION ______________________________*/
  Lead_Conversion_Map__c vLeadConMap;
  
  if (pLstLead != null)
  {
   if (pLstLead.size() > 0)
   {
    vLstLeadConMap = new List<Lead_Conversion_Map__c>();   
    for (Lead vLead : pLstLead)
    {
     vLeadConMap = new Lead_Conversion_Map__c();
        
     vLeadConMap.LeadID_BU__c = vLead.Id;
     vLeadConMap.LeadID_CO__c = vLead.X18_Digit_ID_CO__c;
      
     // if a new account was created
     if (vLead.ConvertedAccountId != null) 
	 {
      vLeadConMap.Converted_AccountId__c = vLead.ConvertedAccountId;   
      vLeadConMap.Time_Converted__c      = DateTime.now(); 	  
     } // if (vLead.ConvertedAccountId != null)          
     
     // if a new contact was created
     if (vLead.ConvertedContactId != null) 
	 {
      vLeadConMap.Converted_ContactId__c= vLead.ConvertedContactId;
     } // if (vLead.ConvertedContactId != null) 
     
     // if a new opportunity was created
     if (vLead.ConvertedOpportunityId != null) 
	 {
      vLeadConMap.Converted_OpportunityId__c = vLead.ConvertedOpportunityId ;
     } // if (vLead.ConvertedOpportunityId != null)         
          
     vLstLeadConMap.add(vLeadConMap);     
    } // for (Lead vLead : pLstLead)
            
    if (vLstLeadConMap != null)
	{
     insert vLstLeadConMap; // // insert a custom object associated with lead             
     //LeadUtil.insertLCMPNRC(vLstLeadConMap); // Create entry for Lead_conv_map in PNRC // 2015-09-25 Phil Hiemstra - Removed because connections are disabled
    } // if (vLstLeadConMap != null)
   } // if (pLstLead.size() > 0)		
  } // if (pLstLead != null)
 } // Method # : 1 buildLeadConversionMap
 
/*____________________________________________________________________________________________________________________*/
 
} // public class LeadConversionUtil