/**
*   This test class is for OpportunityPart_BIU_updateBUprofitcenter.trigger.
*
@author Xiaona Liu
@created 2013-06-17
@version 1.0
@since 20.0
*
@changelog
* 2013-06-17 Xiaona Liu <xiaona.liu@itbconsult.com>
* - Created
* - 2013-06-19 Di Chen <di.chen@itbconsult.com> 
* - Modified
*/
//Added (seeAllData=true) by Abhijeet 17-8-2013
@isTest (seeAllData=true) 
private class OpportunityPart_BIU_updateBUprof_Test {

    static testMethod void myUnitTest() {
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
        Apex_Helper_Settings__c ahs12 = ClsTestHelp.createTestName12();    
        TE_Connection__c tec = ClsTestHelp.createTestTEConnection();
        Opportunity_Approvers__c oa = ClsTestHelp.createTestOpportunityApprovers();
        Opportunity_Approvers__c oa2 = ClsTestHelp.createTestOpportunityApprovers2();
        Opportunity_Approvers__c oa3 = ClsTestHelp.createTestOpportunityApprovers3();
        Opportunity_Approvers__c oa4 = ClsTestHelp.createTestOpportunityApprovers4();
        Profit_BU_Center_Mapping_Rule1__c pb1 = ClsTestHelp.createTestProfitBUCenterMapping1();
        Profit_BU_Center_Mapping_Rule2__c pb2 = ClsTestHelp.createTestProfitBUCenterMapping2();
        Profit_BU_Center_Mapping_Rule3__c pb3 = ClsTestHelp.createTestProfitBUCenterMapping3();
        ClsTestCustomSettingHelper.getLast_Modified_Field_Update_Permission();
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
        Profile p = [Select Id, Name From Profile 
                     where Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
       
         User u = [Select Id, Name,Email , country,GIBU__c,Sub_Vertical__c  From User 
                     where ProfileId =:p.id  and GIBU__c='Industrial' and Sub_Vertical__c='Industrial'  and isactive=true 
                      limit 1];
        system.runAs(u){ 
        RecordType rt = ClsTestHelp.createTestRecordType();
        RecordType rt2 = ClsTestHelp.createTestRecordType16();
        Opportunity_Record_Type_Groups__c rec = Opportunity_Record_Type_Groups__c.getInstance('DND Opportunity');       
                
        //create Account
        Account testAcct = ClsTestHelp.createTestAccounts();
        testAcct.AccountNumber = 'test';
        testAcct.RecordTypeId=Schema.SObjectType.account.getRecordTypeInfosByName().get('OEM').getRecordTypeId();
        insert testAcct;
        
        //create Product hierarchy
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        ph.CBC5__c = '30183';
        //insert ph;
        
        Product_Hierarchy__c ph1 = new Product_Hierarchy__c();
        ph1.Hierarchy_Level_Type__c = 'CBC1';
        ph1.Description__c = 'Industrial';
        ph1.CBC5__c = '30157';
        insert new list<Product_Hierarchy__c> {ph, ph1};
        
        //create opportunity
        /*Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.StageName = 'Won - Closed';
        oppy.Program_level_Forecasting__c =true; 
        oppy.Name = 'Test_Won';
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.RecordTypeId = rt2.Id;
        oppy.AccountId = testAcct.Id;
        //oppy.Mass_prod_Status__c = true;
        insert oppy;*/
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Defined_GPLs__c = 'asdf\\|adfa'; 
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        //oppy.Tender__c = oppy2.Id; 
        oppy.StageName = 'Lead';
        oppy.AccountId = testAcct.Id;
        insert oppy;
        
        Opportunity oppy1 = ClsTestHelp.createTestOpportunity();
        oppy1.Defined_GPLs__c = 'asdf\\|adfa'; 
        oppy1.Type = 'CM';
        oppy1.Request_Type__c = 'Extension';
        oppy1.Method__c = 'BOM';
        oppy1.Level__c = 'Yearly';
        oppy1.Amount = 1;
        oppy1.CurrencyIsoCode = 'EUR';
        oppy1.Five_Year_Revenue__c = 1;
        //oppy.Tender__c = oppy2.Id; 
        oppy1.StageName = 'Lead';
        oppy1.AccountId = testAcct.Id;
        oppy1.RecordTypeId = rec.RecordTypeID__c;
        insert oppy1;
        
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
        
        Opportunity_Part__c oppPart2 = ClsTestHelp.createTestOpportunityPart();
        oppPart2.Opportunity__c = oppy.Id;
        oppPart2.Status__c = 'Won';
        oppPart2.Process_Status__c = 'Production';
        oppPart2.Part__c = part.Id;    
        list_oppPart.add(oppPart2);
        
        Opportunity_Part__c oppPart1 = ClsTestHelp.createTestOpportunityPart();
        oppPart1.Opportunity__c = oppy1.Id;
        oppPart1.Status__c = 'Won';
        oppPart1.Process_Status__c = 'Pre-prod';
        oppPart1.Part__c = part.Id;
        list_oppPart.add(oppPart1);
        
        Opportunity_Part__c oppPart3 = ClsTestHelp.createTestOpportunityPart();
        oppPart3.Opportunity__c = oppy1.Id;
        oppPart3.Status__c = 'Dead';
        oppPart3.Process_Status__c = 'Pre-prod';
        oppPart3.Part__c = part.Id;
        list_oppPart.add(oppPart3);
        
        Opportunity_Part__c oppPart4 = ClsTestHelp.createTestOpportunityPart();
        oppPart4.Opportunity__c = oppy.Id;
        oppPart4.Status__c = 'Won';
        oppPart4.Process_Status__c = 'Pre-prod';
        oppPart4.Part__c = part.Id;    
        list_oppPart.add(oppPart4);
               
        Test.startTest();
        insert list_oppPart;
        ClsPMV_Util.runningTriggerName = '';
        oppPart3.Status__c = 'Won';
        oppPart.Status__c = 'Dead';
        oppPart4.Process_Status__c = 'Production';
        update list_oppPart;        
        ClsPMV_Util.runningTriggerName = '';
        //delete list_oppPart;
        delete oppPart;
        delete oppPart4;        
        Test.stopTest();
        }     
    }
}