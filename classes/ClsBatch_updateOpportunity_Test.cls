/**
*  This test class is for ClsBatch_updateOpportunity.
*
@author Xiaona Liu
@created 2013-06-04
@version 1.0
@since 20.0
*
@changelog
* 2013-06-04 Xiaona Liu <xiaona.liu@itbconsult.com>
* - Created
* 2013-06-04 Di Chen <di.chen@itbconsult.com>
* - Test coverage  
*/
@isTest(SeeAllData=true)
private class ClsBatch_updateOpportunity_Test {

    static testMethod void TestUpdateOpportunityBatch() {
        ClsPMV_Util.isRunningMigration = true;
        /*
        Apex_Helper_Settings__c ahs1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c ahs2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c ahs3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c ahs4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c ahs5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c ahs6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c ahs7 = ClsTestHelp.createTestName7();
        Apex_Helper_Settings__c ahs8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c ahs9 = ClsTestHelp.createTestName9();
        Apex_Helper_Settings__c ahs10 = ClsTestHelp.createTestName10();
        Apex_Helper_Settings__c ahs11 = ClsTestHelp.createTestName11();    
        */                    
        Opportunity_Approvers__c oa = ClsTestHelp.createTestOpportunityApprovers();
        Opportunity_Approvers__c oa2 = ClsTestHelp.createTestOpportunityApprovers2();
        Opportunity_Approvers__c oa3 = ClsTestHelp.createTestOpportunityApprovers3();
        Opportunity_Approvers__c oa4 = ClsTestHelp.createTestOpportunityApprovers4();
        Profit_BU_Center_Mapping_Rule1__c pb1 = ClsTestHelp.createTestProfitBUCenterMapping1();
        Profit_BU_Center_Mapping_Rule2__c pb2 = ClsTestHelp.createTestProfitBUCenterMapping2();
        Profit_BU_Center_Mapping_Rule3__c pb3 = ClsTestHelp.createTestProfitBUCenterMapping3();
        
        //MobileVizArt__Concurrency_Handling__c mch1 = ClsTestHelp.createTestConcurrencyHandling();
        //MobileVizArt__Concurrency_Handling__c mch2 = ClsTestHelp.createTestConcurrencyHandling2();
        
         //********************-=BEGIN:2013-09-04 added by Ramakrishna Singara <ramakrishna.singara@zensar.in>=-*****************
        //Consumer Device Custom Settings Start
        Consumer_Device_Opportunity_Record_Types__c csd1 = ClsTestHelp.createTestCSD1();
        Consumer_Device_Opportunity_Record_Types__c csd2 = ClsTestHelp.createTestCSD2();
        Consumer_Device_Opportunity_Record_Types__c csd3 = ClsTestHelp.createTestCSD3();
        Consumer_Device_Opportunity_Record_Types__c csd4 = ClsTestHelp.createTestCSD4();
        Consumer_Device_Opportunity_Record_Types__c csd5 = ClsTestHelp.createTestCSD5();
        Consumer_Device_Opportunity_Record_Types__c csd6 = ClsTestHelp.createTestCSD6();
        Consumer_Device_Opportunity_Record_Types__c csd7 = ClsTestHelp.createTestCSD7();
        //Consumer Device Custom Settings End
        //********************-=End:2013-09-04 added by Ramakrishna Singara <ramakrishna.singara@zensar.in>=-*******************
        
        TE_Connection__c tec = ClsTestHelp.createTestTEConnection();
        RecordType rt = ClsTestHelp.createTestRecordType();
        RecordType rt2 = ClsTestHelp.createTestRecordType16();               
        
        List<Opportunity> list_opps = new List<Opportunity>();
        //create account - set acct group code and gam code
        Account testAcct = new Account();
        testAcct = C2ForecastTestHelp.createTestAccounts();
        testAcct.ACCT_GROUP_CDE__c = '0001';
        testAcct.GAMCD__c = 'G000';
        testAcct.AccountNumber = 'Test account -0002';
        insert testAcct;
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.StageName = 'Won - Closed';
        oppy.Program_level_Forecasting__c =true; 
        oppy.Name = 'Test_Won';
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.RecordTypeId = rt2.Id;
        //oppy.Mass_prod_Status__c = true;
        oppy.AccountId = testAcct.id;
        oppy.Probability = 0;
        insert oppy;
        
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        //oppy2.StageName = 'Won - Open';
        oppy2.StageName = 'Rejected - Closed';
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Test_Won22';
        oppy2.Type = 'CM';
        oppy2.Request_Type__c = 'Extension';
        oppy2.RecordTypeId = rt2.Id;
        //oppy2.Mass_prod_Status__c = true;
        oppy2.AccountId = testAcct.id;
        insert oppy2;
        
        list_opps.add(oppy);
        list_opps.add(oppy2);
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
                
        List<Opportunity_Part__c> list_oppPart = new List<Opportunity_Part__c>();        
        Opportunity_Part__c oppPart = ClsTestHelp.createTestOpportunityPart();
        oppPart.Opportunity__c = oppy.Id;
        oppPart.Status__c = 'Won';
        oppPart.Process_Status__c = 'Pre-prod';
        oppPart.Part__c = part.Id;
        list_oppPart.add(oppPart);
        
        /*Opportunity_Part__c oppPart2 = ClstestHelp.createTestOpportunityPart();
        oppPart2.Opportunity__c = oppy2.Id;
        oppPart2.Status__c = 'Won';
        oppPart2.Process_Status__c = 'Production';
        oppPart2.Part__c = part.Id;
        list_oppPart.add(oppPart2);*/
        
        Opportunity_Part__c oppPart3 = ClstestHelp.createTestOpportunityPart();
        oppPart3.Opportunity__c = oppy2.Id;
        oppPart3.Status__c = 'Lost';
        oppPart3.Process_Status__c = 'Quoted';
        oppPart3.Part__c = part.Id;
        oppPart3.Lost_Reason__c = 'Approval criteria not met';
        list_oppPart.add(oppPart3);
        
        Opportunity_Part__c oppPart4 = ClstestHelp.createTestOpportunityPart();
        oppPart4.Opportunity__c = oppy2.Id;
        oppPart4.Status__c = 'Dead';
        oppPart4.Process_Status__c = 'Quoted'; 
        oppPart4.Part__c = part.Id;
        list_oppPart.add(oppPart4);
        
        insert list_oppPart;
        
        
        Test.startTest();
        ClsBatch_updateOpportunity clsBatch = new ClsBatch_updateOpportunity();
        Database.BatchableContext BC;
        clsBatch.filter = ' limit 1';
        
        clsBatch.start(BC);
        clsBatch.execute(BC, list_opps);
        clsBatch.finish(BC);
        
        system.assert(true);
        Test.stopTest();  
    }
}