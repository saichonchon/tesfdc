/**********************************************************************************************************************************************
*******
Name: CCP_AddContoEntitlement
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This trigger used to create entitlement contact if contact's account has entitlement .
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE       DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Abhijeet Manepatil  11/14/2013    Trigger                       
***********************************************************************************************************************************************
*****/
trigger CCP_AddContoEntitlement on Contact (after insert,after update) {
    if(CaseUtil_CCP.AddEntlContact == false){
        CaseUtil_CCP.AddEntlContact = true;
        if(trigger.isAfter && Trigger.IsInsert){
        AssignEntltoContact_CCP vInsert_EntlCon = new AssignEntltoContact_CCP();
        vInsert_EntlCon.getDataonInsert(trigger.new);
        }
        if(trigger.isAfter && Trigger.IsUpdate){
        AssignEntltoContact_CCP vUpdate_EntlCon = new AssignEntltoContact_CCP();
        vUpdate_EntlCon.getDataonUpdate(trigger.oldMap,trigger.newMap);
        }
    }
}