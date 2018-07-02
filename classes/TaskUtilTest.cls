/**************************************************************************************************************************************************
Name:  TaskUtilTest

===================================================================================================================================================
Purpose: This class contain Test Methods for Task Insert Triggers  and TaskUtility class 
---------------------------------------------------------------------------------------------------------------------------------------------------       
Related APEX Class : TaskUtil                                                              
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
Version Developer          Date       Detail                                  Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Rahul Gharat 16/02/2012 Initial Development                      
**************************************************************************************************************************************************/
@isTest
public class TaskUtilTest
{

public static void ptInsertLead()
{
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();
 Lead vLead = new Lead();
  vLead.FirstName                 = 'xyzc2';    
  vLead.LastName                  = 'abc1';
  vLead.Email                     = vLead.FirstName + '.' + vLead.LastName + '@sampledomain.com';    
  vLead.Company                   = 'Company 2';
  vLead.Phone                     = '1011001000';  
  vLead.Description               = 'Description 2';
  vLead.Industry                  = 'Aerospace and Defense';      
  vLead.LeadSource                = 'Preliminary Talk';  
  vLead.Status                    = 'Assigned Unaccepted';
  vLead.Rating                    = 'Hot';  
  Insert vLead;
/*
List<Lead> vLeads= [select Id from Lead limit 1];
if (vLeads.size() > 0)
vLead= vLeads[0].Id;
*/

Task vTask = new Task();
vTask.Subject='Call';
VTask.Status='Not Started';
vTask.Priority='Normal';
vTask.WhoId=vLead.Id;
vTask.activitydate=system.today();
Insert vTask;
} 
 
 public static testMethod void TestTrigger()
 {
 	    Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();
  test.StartTest();
  ptInsertLead(); 
 // ptUpdateLead();
  test.StopTest();
 } 
 
} // public class TaskUtilTest