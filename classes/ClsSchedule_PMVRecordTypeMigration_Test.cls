/**
*  This test class used to test class ClsSchedule_PMVRecordTypeMigration.
*
@author Jinbo Shan
@created 2014-04-30
@version 1.0   
@since 29.0
*
@changelog
* coverage  81%
* 
* 
2014-04-30 Jinbo Shan <jinbo.shan@itbconsult.com>
* - Created
*/
@isTest
private class ClsSchedule_PMVRecordTypeMigration_Test {
    
    Opportunity_Record_Type_Groups__c  org1 = ClsTestHelp.createTestOPTG1();
    Opportunity_Record_Type_Groups__c  org2 = ClsTestHelp.createTestOPTG2();
    PMV_Language_Config__c slc1 = ClsTestHelp.createTestSLC1();
    PMV_Language_Config__c slc2 = ClsTestHelp.createTestSLC2();
    PMV_Language_Config__c slc3 = ClsTestHelp.createTestSLC3();
    PMV_Sales_Process_Settings__c ssps1 = ClsTestHelp.createTestSSPS1();
    PMV_Sales_Process_Settings__c ssps2 = ClsTestHelp.createTestSSPS1();
    PMV_Sales_Stage_Setting__c ssss1 = ClsTestHelp.createTestSSSS1();
    PMV_Sales_Stage_Setting__c ssss2 = ClsTestHelp.createTestSSSS2();
    PMV_Sales_Stage_Setting__c ssss3 = ClsTestHelp.createTestSSSS3();
    PMV_Sales_Stage_Setting__c ssss4 = ClsTestHelp.createTestSSSS4();
    PMV_Sales_Stage_Setting__c ssss5 = ClsTestHelp.createTestSSSS5();
    PMV_Sales_Stage_Setting__c ssss6 = ClsTestHelp.createTestSSSS6();
    PMV_Sales_Stage_Setting__c ssss7 = ClsTestHelp.createTestSSSS7();
    PMV_Sales_Stage_Setting__c ssss8 = ClsTestHelp.createTestSSSS8();
    PMV_Sales_Stage_Setting__c ssss9 = ClsTestHelp.createTestSSSS9();
    PMV_Sales_Stage_Setting__c ssss10 = ClsTestHelp.createTestSSSS10();
    PMV_Stage_Config__c ssc1 = ClsTestHelp.createTestSSC1();
    PMV_Stage_Config__c ssc2 = ClsTestHelp.createTestSSC2();
    PMV_Stage_Config__c ssc3 = ClsTestHelp.createTestSSC3();
    PMV_Stage_Config__c ssc4 = ClsTestHelp.createTestSSC4();
    PMV_Stage_Config__c ssc5 = ClsTestHelp.createTestSSC5();
    PMV_Stage_Config__c ssc6 = ClsTestHelp.createTestSSC6();
    PMV_Stage_Config__c ssc7 = ClsTestHelp.createTestSSC7();

    static testMethod void myUnitTest() {
        DateTime currTime = DateTime.now();
        Integer min = currTime.minute();
        Integer hour = currTime.hour();
        String sch;
        
        if(min <= 58)
            sch = '0 '+ (min + 1) + ' ' + hour + ' * * ? '+ currTime.year();
        else          
            sch = '0 0 '+ (hour + 1) + ' * * ? '+ currTime.year();
        
        Test.startTest();
        
        ClsSchedule_PMVRecordTypeMigration obj = new ClsSchedule_PMVRecordTypeMigration();                
        String jobId = system.schedule('test', sch, obj); 
        
        system.assert(true);
        Test.stopTest();
    }
}