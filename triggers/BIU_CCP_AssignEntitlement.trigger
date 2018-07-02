/**********************************************************************************************************************************************
*******
Name: BIU_CCP_AssignEntitlement 
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose:This trigger assigns entitlement to case which is created via Email to Case.
        It checks if Entitlement is null and Account is not null then assigns entitlement related to account.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE          DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Abhijeet Manepatil   20/09/2013    Trigger                       
***********************************************************************************************************************************************
*****/
trigger BIU_CCP_AssignEntitlement on Case (before insert,before update) {
    if(trigger.isInsert && CaseUtil_CCP.AssignEntlmnboolean == false){
        CaseUtil_CCP.AssignEntlmnboolean = true;
        AssignEntitlementtoCase vAETC= new AssignEntitlementtoCase();
        vAETC.AssignEntltoCaseonInsert(trigger.new);
    }
    if(trigger.isUpdate)
    {
        //CaseUtil_CCP.AssignEntlmnboolean_update = true;
        AssignEntitlementtoCase AETC= new AssignEntitlementtoCase();
        AETC.AssignEntlmnttmailtoupdateCase(trigger.newMap,trigger.oldMap);
    }
         
   
}