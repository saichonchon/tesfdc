/**
 *  This class provides test coverage for the Sandbox_Refresh class
 *  
 * @author Sebasten Raffal
 * @created 2016-04-12
 * @version 1.0
 * @since 36.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2016-04-12 Jasmine Ver <jasmine.ver@te.com>
 * - Created
 *
 */
 
@isTest 
public class Sandbox_Refresh_Test{ 
    public static testmethod void runTest(){ 
        Sandbox_Refresh ClassInstance1 = new Sandbox_Refresh(); 
        Test.startTest();
        
        //Populate Custom Settings to get through triggers on account insert
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        
        Test.testSandboxPostCopyScript(ClassInstance1, UserInfo.getOrganizationId(), '00DQ000000GKUoL', 'SB2');
        Account TestAccount = [Select Id, Name from Account limit 1]; 
        System.assertEquals(TestAccount.Name,'Org Id: ' + UserInfo.getOrganizationId() + ' Sandbox Id: 00DQ000000GKUoLMAX Sandbox Name: SB2','Test something');
        Test.stopTest(); 
    } 
}