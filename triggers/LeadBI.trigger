/**************************************************************************************************************************************************
Name: LeadBI 
Copyright © 2012 TE Connectivity | Salesforce Instance : BU Org
===================================================================================================================================================
Purpose: This trigger populate user information (BU Owner Name, BU Owner Email, BU Owner Phone) and Source BU in the Lead custom fields.                                                  
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR                DATE       DETAIL                                                   Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 UMASANKAR SUBBAIAN    01/09/2012 Initial Development - SF2SF                                  1453487  
       
**************************************************************************************************************************************************/
trigger LeadBI on Lead(before insert) 
{
 /*-- 1 Collection variable declaration --------------------------------------*/  

 List<Lead> vLstNewLead;
  
 if (!ExecuteOnce.SF2SF_LEAD)
 {
  vLstNewLead  =  LeadUtil.getBULeads(Trigger.new);  // Use this variable for future 
  
  LeadUtil.getUserMap(vLstNewLead);
 } // if (!ExecuteOnce.SF2SF_LEAD)
 
 /*-----------------------------------------------------------------------------------------------------------------------------------------------*/

} // trigger LeadtBI on Lead (before insert)