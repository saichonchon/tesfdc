/**********************************************************************************************************************
Name: LeadConvertonOpp 
=======================================================================================================================
Purpose: This trigger Update the stage name Closed/Lost to New Opportunity in Lead conversion process.                                                   
=======================================================================================================================
History:                                                        
-------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR                DATE       DETAIL                                                           CASE #
-----------------------------------------------------------------------------------------------------------------------
    1.0 Padmaja D       09/22/2014 Opportunity stageupdateon Lead conversion                         00740363
    1.1 Padmaja D       06/09/2015 DND Opportunity record type added and updated OEM Name as NON OEM 
*********************************************************************************************************************************/

trigger LeadConvertonOpp on Lead (after update) {

   if (Trigger.new.size() == 1) {

    if (Trigger.old[0].isConverted == false && Trigger.new[0].isConverted == true) {

      // if a new opportunity was created
      if (Trigger.new[0].ConvertedOpportunityId != null) {

        // update the converted opportunity with some text from the lead  
        Apex_Helper_Settings__c vSalesId = Apex_Helper_Settings__c.getInstance('Sales Opportunity CSD');                                          
        Apex_Helper_Settings__c vEngId = Apex_Helper_Settings__c.getInstance('Engineering Opportunity CSD Id');
        // Added DND Opportunity record type for DND merge project Padmaja Dadi 06/09/2015
        //Changed OEM Name to NON OEM for DND 
        Opportunity_Record_Type_Groups__c vDndId = Opportunity_Record_Type_Groups__c.getInstance('DND Opportunity');                                          
        Opportunity opp = [Select o.Id, o.Description,o.recordtypeid from Opportunity o Where o.Id = :Trigger.new[0].ConvertedOpportunityId];
        Account a = [Select Id, Name from Account Where Name=:'NON OEM' LIMIT 1];                 
        if(opp.recordtypeid == vSalesId.Value__c || opp.recordtypeid == vEngId.Value__c || opp.recordtypeid == vDndId.RecordTypeID__c) {                            
        opp.StageName='New Opportunity';             
        opp.OEM_Name__c=a.Id;                     
        opp.amount=0;                                     
        update opp;

         }

      }         

    }

  }     

}