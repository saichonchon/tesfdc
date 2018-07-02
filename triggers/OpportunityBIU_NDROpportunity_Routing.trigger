/**********************************************************************************************************************************************
*******
Name: OpportunityBIU_NDROpportunity_Routing   
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This trigger routes the NDR opportunity to respective DMM based upon information received from SAP.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE       DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Abhijeet Manepatil  01/24/2013    Trigger
 1.1   Mrunal Parate       02/05/2015    Modidfied for Case 00790664  
 1.2   Mrunal Parate       11/05/2015    For NDR Phase II Enhancement project to Update END and POS Account fields              
***********************************************************************************************************************************************
*****/

trigger OpportunityBIU_NDROpportunity_Routing on Opportunity (before insert,before update){
    if(NDRUtility.NDRboolean == false){
    NDRUtility.NDRboolean = true;
    UpdateNDROpportunityDateFields vNDROpptyDate = new UpdateNDROpportunityDateFields();
    vNDROpptyDate.Update_date_fields(trigger.new);
    if(trigger.isInsert){   
        Route_NDR_Opportunity vNDROppty = new Route_NDR_Opportunity();
        vNDROppty.AssignDMMtoNDROpportunity(trigger.new);  
    }
    if(trigger.isUpdate){
       NDROpportunityChangeInOwner vChng = new NDROpportunityChangeInOwner();
       vChng.UpdateDMMEmailAddress(trigger.new,trigger.oldmap,trigger.newmap);
       Route_NDR_Opportunity vNDROppty = new Route_NDR_Opportunity();// Added for CCR
       vNDROppty.UpdateRegSalesForNDROpportunity(trigger.new,trigger.oldmap);// added by Mrunal for case 00790664
       vNDROppty.UpdateENDandPOSAccountFields(trigger.new,trigger.oldmap);// added by Mrunal For NDR Phase II Enhancement project to Update END and POS Account fields.
    }
    }
/*---------------------------------------------------------------------------------*/    
}//End of trigger