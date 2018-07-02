/**********************************************************************************************************************************************
*******
Name: BI_Email_BulkEmailCustomer
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose:This trigger for Bulk Email duplicate subjects
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE          DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Narasimha Narra    3/4/2014      Trigger  
 
***********************************************************************************************************************************************
*****/
trigger BI_Email_BulkEmailCustomer on EmailMessage (before insert) 
{
   /*if(CaseUtil_CCP.BI_Email_BulkEmailCustomer==false){
       CaseUtil_CCP.BI_Email_BulkEmailCustomer=true; 
       BI_Email_BulkEmailCustomerClass.controlingDuplicateEmails(trigger.new);
   }*/
}