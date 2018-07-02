/**********************************************************************************************************************
Name:  LeadConvTest
Copyright © 2012 TE Connectivity | Salesforce Instance : BU Org 
=======================================================================================================================
Purpose: This class contain Test Methods for Lead conversion 
-----------------------------------------------------------------------------------------------------------------------
APEX Classes covered : 
-----------------------------------------------------------------------------------------------------------------------
APEX Triggers covered :                                   
=======================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                        
-----------------------------------------------------------------------------------------------------------------------
Version Developer          Date       Detail                                  Mercury Request #
-----------------------------------------------------------------------------------------------------------------------
    1.0 Rahul Gharat 01/11/2012 Initial Development                           1453487 (SMO - Build 3.0) 
    1.1 Umasankar    03/06/2012 Converted Vs picklist value for Lead Status   1667283 (SMO - Build 3.0 Maintenance)  
**********************************************************************************************************************/
@isTest(SeeAllData = true)
public class LeadConvTest
{
 /*____________________________________________________________________________________________________________________
 | Purpose : Test - After update of Lead                                                                              |
 |____________________________________________________________________________________________________________________|
 | Behavior: Positive behavioral test                                                                                 |
 |___________________________________________________________________________________________________________________*/   
 public static void ptupdateLead()
 {
  /*-- D1. Collection variable declaration -----------------------------------------*/
  List<LeadStatus> vLstLeadStatus;
  /*-- D2. Object variable declaration ---------------------------------------------*/
  Lead vLead = new Lead();
   
  vLead.FirstName                 = 'xyzc';    
  vLead.LastName                  = 'abcd';
  vLead.Email                     = vLead.FirstName + '.' + vLead.LastName + '@sampledomain.com';    
  vLead.Company                   = 'Company 1';
  vLead.Phone                     = '+1 8015551212';  
  vLead.Description               = 'Description 1';
  vLead.Industry                  = 'Aerospace and Defense';      
  vLead.LeadSource                = 'Preliminary Talk';  
  vLead.Status                    = 'Assigned Unaccepted';
  vLead.Rating                    = 'Hot';  
  Insert vLead;
  System.assert(vLead != null, 'The test lead is not created in the volatile memory'); 
  ExecuteOnce.SF2SF_LEAD=false;
  
  
  vLstLeadStatus = LeadStatusDAO.getValuesMarkedForConverted();
  if (vLstLeadStatus != null)
  {
   if (vLstLeadStatus.size() > 0 )
   {
    System.Debug(vLstLeadStatus);
    // To update the Lead
  
    Database.Leadconvert leadConvert = new Database.Leadconvert();
    leadConvert.setLeadId(vLead.Id);
    leadConvert.setConvertedStatus(vLstLeadStatus[0].MasterLabel);
    leadConvert.setDoNotCreateOpportunity(false);
    leadConvert.setSendNotificationEmail(false);
    //Database.Leadconvertresult lcr = Database.convertLead(leadConvert);
   // System.debug('leadConvert' + lcr.isSuccess());
   } // if (vLstLeadStatus.size() > 0 )         
  } // if (vLstLeadStatus != null) 
   
 } // public static void ptupdateLead()
 
 /*____________________________________________________________________________________________________________________
 | Purpose : Call positive behavioral Tests and Negative behavioral test for Lead Conversion                          |
 |___________________________________________________________________________________________________________________*/ 
 public static testMethod void core()
 {
  test.StartTest();
  ptupdateLead(); 
  test.StopTest();
 } // public static testMethod void core()
 
 /*__________________________________________________________________________________________________________________*/ 
 
} // End of public class LeadConvTest