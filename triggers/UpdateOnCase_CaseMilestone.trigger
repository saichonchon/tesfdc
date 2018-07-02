/**********************************************************************************************************************************************
Name: UpdateOnCase_CaseMilestone 
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================
Purpose: This trigger combines the functionality of triggers(UpdateCase and AI_UpdateCaseMilestone_CCP)to update the Case and Case Milestone.
===============================================================================================================================================
VERSION       AUTHOR              DATE                                   
 1.0       Nooreen Shaikh       28/11/2014       
***********************************************************************************************************************************************/

trigger UpdateOnCase_CaseMilestone on EmailMessage (after insert) {

    CaseUpdate vCsUpdate = new CaseUpdate();
    vCsUpdate.CaseUpdateMethod(trigger.new);
       
}