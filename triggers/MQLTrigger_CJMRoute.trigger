/**************************************************************************************************************************************************
Name:  MQLTrigger_CJMRoute
Copyright © 2011 TE Connectivity
===================================================================================================================================================
Purpose: This Trigger contains business process sharing LeadMQL & ContactMQL records with CJM Team Members for Select and Target Customers.
---------------------------------------------------------------------------------------------------------------------------------------------------       

===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
Version Developer          Date             Detail                               Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
1.0 Subramanian       01/05/2018      Initial Development                      Select growth long term project

**************************************************************************************************************************************************/

trigger MQLTrigger_CJMRoute on TEMarketing__MQLRecord__c (Before Insert) {
    if(Trigger.isBefore && Trigger.IsInsert){
        MQLTriggerHandler.AssignToCJMUser(Trigger.new, Trigger.OldMap);
     }
}