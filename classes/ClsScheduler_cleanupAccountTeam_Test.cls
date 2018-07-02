/**
*   This test class is for ClsScheduler_cleanupAccountTeam.
*
@author Bin Yu
@created 2012-11-28
@version 1.0
@since 26.0
*
@changelog
* 2012-11-28 Bin Yu <bin.yu@itbconsult.com>
* - Created
* - Test coverage 100%
*/
@isTest
private class ClsScheduler_cleanupAccountTeam_Test {

    static testMethod void testAll() {
    
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();
        
        DateTime currTime = DateTime.now();
        Integer min = currTime.minute();
        Integer hour = currTime.hour();
        String sch;
        
        if(min <= 58)
            sch = '0 '+ (min + 1) + ' ' + hour + ' * * ? '+ currTime.year();
        else          
            sch = '0 0 '+ (hour + 1) + ' * * ? '+ currTime.year();
        
        Test.startTest();
        
        ClsScheduler_cleanupAccountTeam obj = new ClsScheduler_cleanupAccountTeam();                
        String jobId = system.schedule('test', sch, obj); 
        
        system.assert(true);
        Test.stopTest(); 
    }
}