/**************************************************************************************************************************************************
Name:  LeadTriggerTest
Copyright © 2012 TE Connectivity | Salesforce Instance : BU Org
===================================================================================================================================================
Purpose: This class contain Test Methods for LeadAI 
---------------------------------------------------------------------------------------------------------------------------------------------------       
APEX Classes covered : SalesforceUtil, LeadUtil                                                              
---------------------------------------------------------------------------------------------------------------------------------------------------       
APEX Triggers covered : LeadAI, LeadBI                                                               
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
Version Developer          Date       Detail                                  Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Umasankar Subbaian 01/10/2012 Initial Development                     1453487                                   
**************************************************************************************************************************************************/
@isTest(SeeAllData=true)
public class LeadTriggerTest
{
 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Test - After Insert of Lead | Positive behavioral test                                                                               |
 |   Input : None                                                                                                                                 |  
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
 public static void ptInsertLead()
 {
  /*-- D2. Object variable declaration ---------------------------------------------*/
  Lead vLead = new Lead();
  vLead.FirstName                 = 'xyzc';    
  vLead.LastName                  = 'abcd';
  vLead.Email                     = vLead.FirstName + '.' + vLead.LastName + '@sampledomain.com';    
  vLead.Company                   = 'Company 1';
  vLead.Phone                     = '1011001000';  
  vLead.Description               = 'Description 1';
  vLead.Industry                  = 'Aerospace and Defense';      
  vLead.LeadSource                = 'Preliminary Talk';  
  vLead.Status                    = 'Assigned Unaccepted';
  vLead.Rating                    = 'Hot';  
  Insert vLead;
  System.assert(vLead != null, 'The test lead is not created in the volatile memory');    
 } // public static void ptInsertLead()

 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Test - After Update of Lead | Positive behavioral test                                                                               |
 |   Input : None                                                                                                                                 |  
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
 public static void ptUpdateLead()
 {
  /*-- D2. Object variable declaration ---------------------------------------------*/
  Lead vLead = 
   [
    SELECT l.Id,
           l.Description 
      FROM Lead l
     WHERE l.FirstName = 'xyzc'
     LIMIT 1     
   ];
  vLead.Description = 'After Update Trigger Test';
  ExecuteOnce.SF2SF_LEAD = false;
  Update vLead;
  System.assert(vLead != null, 'The test lead is not updated in the volatile memory');
 } // public static void ptUpdateLead()
 
 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Test - Account before update trigger                                                                                                 |
 |   Input : None                                                                                                                                 |  
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
 public static testMethod void TestTrigger()
 {
  test.StartTest();
  ptInsertLead(); 
  ptUpdateLead();
  test.StopTest();
 } // public static testMethod void TestTrigger()
 
 /*----------------------------------------------------------------------------------------------------------------------------------------------*/ 
 
} // End of public class LeadTriggerTest