/**********************************************************************************************************************************************
*******
Name: DefaultEmailTemplateForCaseFeed 
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This class is added to support setting for send default emailtemplate.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE       DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Narasimha Narra   10/30/2013     Class                       
***********************************************************************************************************************************************
*****/
global class DefaultEmailTemplateForCaseFeed implements Support.EmailTemplateSelector {
    // Empty constructor
    global DefaultEmailTemplateForCaseFeed() {    }
    // The main interface method
    global ID getDefaultEmailTemplateId(ID caseId) {
        // get the template ID
        List<EmailTemplate> ets = [SELECT id FROM EmailTemplate WHERE DeveloperName = :'DefaultEmailTemplate'];
        //Return the ID of the template selected
        if (!ets.isEmpty()) {
        EmailTemplate et = ets[0];
        
        return et.id;
        }
        else
        return null;
    }
}