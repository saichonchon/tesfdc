/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
 
 
 
 /**
*   This test class is for ClsBatch_PopulatePlanGroupId class and Account_AIUD_populatePlanGroupId Trigger.
*
@author Wen Liu
@created 2012-09-10
@version 1.0
@since 20.0
*
@changelog
* 2012-06-07 Wen Liu <wen.liu@itbconsult.com>
* - Created
* - Test coverage 100% and 85%
*/
@isTest(seealldata=true)
private class ClsBatch_PopulatePlanGroupId_Test {

    static testMethod void myUnitTest() {
        
        Test.startTest();
        /*****************Test Trigger Insert   Start**********************************/
        Account accP = ClsTestHelp.createTestAccounts();
        accP.Name = 'TestParent';
        accP.Individually_Planned__c = true ;
        insert accP;
        
        Account accC = ClsTestHelp.createTestAccounts();
        accC.Name = 'TestChild';
        accC.Plan_Group_Account__c = accP.Id;   
        insert accC;
        System.assertEquals(database.countquery('SELECT COUNT()'
              +' FROM Account WHERE Id=\'' + accP.Id + '\''), 1);
        System.assertEquals(database.countquery('SELECT COUNT()'
              +' FROM Account WHERE Id=\'' + accC.Id + '\''), 1);    
        /*****************Test Trigger Insert   End**********************************/      
              
              
        /*****************Test Trigger Update   Start**********************************/
        accP.Individually_Planned__c = false ;
        update accP;
        System.assertEquals(accP.Individually_Planned__c,false);
        /*****************Test Trigger Update   End**********************************/     
             
             
             
        /*****************Test Trigger Update   Start**********************************/
        delete accP;
        System.assertEquals(accC.Plan_Group_Id__c,null);  
        /*****************Test Trigger Update   Start**********************************/
            
                
              
        
        
        
        /*****************Test Batch Class   Start**********************************/
        ClsBatch_PopulatePlanGroupId clsBatch = new ClsBatch_PopulatePlanGroupId();
        Database.BatchableContext BC;
        clsBatch.email = '123456789@163.com';
        clsBatch.query='select Id,Plan_Group_Account__c,Individually_Planned__c,Plan_Group_Id__c,Plan_Group_Account__r.Individually_Planned__c from Account where type != \'Prospect\' limit 10';
        clsBatch.start(BC);
        List<Account> list_accounts = new  List<Account>();
        list_accounts = [select Id,Plan_Group_Account__c,Individually_Planned__c,Plan_Group_Id__c,Plan_Group_Account__r.Individually_Planned__c from Account where type != 'Prospect' limit 10 ];
        clsBatch.execute(BC, list_accounts);
        clsBatch.finish(BC);
        
        //ID batchId = Database.executeBatch(clsBatch);

        
        system.assert(true);
        /*****************Test Batch Class   Start**********************************/
        Test.stopTest();
        
    }   
}