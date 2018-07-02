/**********************************************************************************************************************************************
*******
Name: OpportunityPart_BIU_NDROpportunityPart
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This trigger calls UpdateNDROpportunityPartDateFields class.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE       DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Abhijeet Manepatil   04/22/2013    Class                       
***********************************************************************************************************************************************
*****/
trigger OpportunityPart_BIU_NDROpportunityPart on Opportunity_Part__c (before insert, before update) {
    if(NDRUtility.NDRPartboolean == false){
        NDRUtility.NDRPartboolean = true;
        UpdateNDROpportunityPartDateFields vOpptypart = new UpdateNDROpportunityPartDateFields();
        vOpptypart.update_date_fields(trigger.new);
    }

}