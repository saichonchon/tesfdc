/**  
 * @Author: Srinath Thallapally
 * @Date :08/01/2016
 * @Description : This test class is used for testing the SchedularCls_DeleteSObjects
 * @Version:1 - Initial Development
 */
@isTest
public class SchedularCls_DeleteSObjects_Test{
    public static testMethod void testData() { 
        Batch_Delete_Inputs__c inputs = new Batch_Delete_Inputs__c();
        inputs.Age_in_Days__c = 180;
        inputs.Email_Body_of_Report__c = 'test';
        inputs.Email_For_Notifications__c = 'prabhanjan.nandyala@zensar.in,prabhanjan.nandyala@te.com';
        inputs.Name = 'JOB1';
        inputs.Parent_Record_Types__c = 'All';
        
        insert inputs;                 
        SchedularCls_DeleteSObjects vObjSchClass = new SchedularCls_DeleteSObjects();
        String testSchedulerString = '0 0 22 * * ?';        
        system.schedule('Test Scheduler for Delete Archive Cases EamilMessages', testSchedulerString, vObjSchClass);
        
    }
}