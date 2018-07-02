/**************************************************************************************************************************************************
Name: LeadBU 
Copyright © 2012 TE Connectivity | Salesforce Instance : BU Org
===================================================================================================================================================
Purpose: This trigger populate BU user information (BU Owner Name, BU Owner Email, BU Owner Phone) and Source BU in the Lead custom fields.                                                  
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR                DATE       DETAIL                                                   Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 UMASANKAR SUBBAIAN    01/12/2012 Initial Development - SF2SF                              1453487         
**************************************************************************************************************************************************/
trigger LeadBU on Lead(before update) 
{
 /*-- 1 Collection variable declaration --------------------------------------*/  

 List<Lead> vLstNewLead;
  
 if (!ExecuteOnce.SF2SF_LEAD)
 {
  vLstNewLead = LeadUtil.getBULeads(Trigger.new,Trigger.old); // Use this variable for future 
  
  LeadUtil.getUserMap(vLstNewLead);  
  LeadUtil.putCOLeadId(vLstNewLead);
  LeadUtil.determineRejectionAtBuOrg(Trigger.new,Trigger.old);
 } // if (!ExecuteOnce.SF2SF_LEAD)
 
 /*-----------------------------------------------------------------------------------------------------------------------------------------------*/

} // trigger LeadBU on Account (before update)