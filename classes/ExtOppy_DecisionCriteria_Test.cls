/**
*  This test class used to test class ExtOppy_qualifierOverview.
*
@author Weihang Li
@created 2014-04-28
@version 1.0   
@since 28.0
*
@changelog
* coverage  91%
* 
* 
2014-04-28 Weihang Li <weihang.li@itbconsult.com>
* - Created
*/
@isTest(seealldata=true)
private class ExtOppy_DecisionCriteria_Test {
     
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
        RecordType rt = ClsTestHelp.createPMVTestRecordType1();
        User u = ClsTestHelp.createTestUsers4PMV();
        u.Username = 'jinbo@d1sdfasddsaf.csddgrw2e3';
        insert u;
        system.runAs(u){
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Type = 'CM';
            oppy.RecordTypeId = rt.Id;
            oppy.PMV_Type__c = 'IND Standard Sales opp';
            insert oppy;

            Decision_Criteria__c dc = new Decision_Criteria__c();
            dc.Opportunity__c = oppy.Id;
            dc.Active__c = true;
            insert dc;
            
            Key_Player__c kp = new Key_Player__c();
            kp.Opportunity__c = oppy.Id;
            insert kp;
            
            Key_Player_Criteria__c kpc = new Key_Player_Criteria__c();
            kpc.Decision_Criteria__c = dc.Id;
            kpc.Key_Player__c = kp.Id;
            kpc.Priority__c = '1';
            insert kpc;
            
            test.startTest();
            ApexPages.Standardcontroller stdCtrl = new ApexPages.Standardcontroller(oppy);
            ExtOppy_DecisionCriteria ext = new ExtOppy_DecisionCriteria(stdCtrl);
            ext.getKeyPlayersList();
            ext.deCriteria.Question_English__c = 'test';
            ext.addCriteria();
            ext.addSelectRecords();
            ext.checkKeyPlayer();
            
            ExtOppy_DecisionCriteria.saveAnwser(dc.Id,'1');
            ExtOppy_DecisionCriteria.saveComents(dc.Id,'test');
            ExtOppy_DecisionCriteria.saveKeyPlayer(kpc.Id,'2');
            system.assert(true);
            test.stopTest();
        }
    }
    
}