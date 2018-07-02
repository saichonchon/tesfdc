/**************************************************************************************************************************************************
Name: OpportunityBI 
Copyright © 2011 TE Connectivity | Salesforce Instance : BU Org
===================================================================================================================================================
Purpose: This trigger populate user information (BU Owner Name, BU Owner Email, BU Owner Phone) and Source BU in the Opportunity custom fields.                                                  
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR                DATE       DETAIL                                            Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Rahul Gharat          10/25/2011 Initial Development - SF2SF                       1453487 
    1.1 Umasankar Subbaian    12/06/2011 Make opportunity can be created with account      1453487 
**************************************************************************************************************************************************/
trigger OpportunityBI on Opportunity(before insert) 
{
 /*-- 1 Collection variable declaration --------------------------------------*/     
 List<Opportunity> ParentedUnrestrictedOpps;
 List<Opportunity> ParentRestrictedopps;
 List<Opportunity> vLstNewOppty;
 
 if (!ExecuteOnce.SF2SF_OPPORTUNITY)
 {
  vLstNewOppty             = Trigger.New; // Use this variable for future coding   
 
  ParentedUnrestrictedOpps = new List<Opportunity>();
  ParentRestrictedopps     = new List<Opportunity>(); 
  
  // Get list of Parented & Unrestricted Opportunities 
  ParentedUnrestrictedOpps = OpptyUtil.getParentedUnrestrictedOpportunities(vLstNewOppty);
       
  // Make Orphan opportunities restricted
  OpptyUtil.MakeOrphanrestricted(vLstNewOppty);
     
  // Get list of Opportunity where the corresponding parent is restricted   
  ParentRestrictedopps = OpptyUtil.IsParentRestricted(ParentedUnrestrictedOpps, true);
     
  // Make the child restricted
  OpptyUtil.Makechildrestricted(ParentRestrictedopps);
     
  // Populate User information
  OpptyUtil.getUserMap(vLstNewOppty);
     
 } // if (!ExecuteOnce.SF2SF_OPPORTUNITY)

 /*----------------------------------------------------------------------------------------------------------------------------------------------*/
 
} // End of trigger OpportunityBI on Opportunity(before insert)