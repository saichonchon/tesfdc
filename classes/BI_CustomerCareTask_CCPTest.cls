/**********************************************************************************************************************************************
*******
Name: BI_CustomerCareTask_CCPTest
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This test class covers test coverage for BI_StandardTask_CCP trigger.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE       DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Abhijeet Manepatil  10/16/2013    Test Class                       
***********************************************************************************************************************************************
*****/
@isTest(seeAllData=true)
public class BI_CustomerCareTask_CCPTest{
 static testmethod void BI_CustomerCareTask_CCPTestMethod(){
        test.startTest();
        Apex_Helper_Settings__c vTaskRT = Apex_Helper_Settings__c.getInstance('Customer Care Task');
        Apex_Helper_Settings__c vCaseRT = Apex_Helper_Settings__c.getInstance('Customer Care Cloud');
        Case vCs = new Case();
        vCs.recordtypeid = vCaseRT.Value__c;
        vCs.Origin = 'Email-cip1';
        vCs.Inquiry_Type__c = 'Cancellation';
        vCs.Status= 'In Progress';
        vCs.Description = 'Test Description';
        insert vCs;
        Task vtsk = new Task();
        vtsk.recordtypeid = vTaskRT.Value__c;
        vtsk.Subject = 'Escalated';
        vtsk.whatid = vCs.id;
        vtsk.Escalation_Reason__c = 'CCP Initiated';
        insert vtsk;
        test.StopTest();
        }
}