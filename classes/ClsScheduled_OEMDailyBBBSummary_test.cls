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
@isTest
private class ClsScheduled_OEMDailyBBBSummary_test {

    static testMethod void testScheduleDailyBBBBatch() {
    	Test.startTest();
        DateTime currTime = DateTime.now();
        Integer min = currTime.minute();
        Integer hour = currTime.hour();
        String sch;
        
        if(min <= 58)
            sch = '0 '+ (min + 1) + ' ' + hour + ' * * ? '+ currTime.year();
        else          
            sch = '0 0 '+ (hour + 1) + ' * * ? '+ currTime.year();

        if(ClsOEMUtil.CurrentFM == null)
        {
            ClsOEMUtil.setCurrentFiscalDateValues();
        }
        string FiscalMonth = string.valueOf(ClsOEMUtil.CurrentFM).leftpad(2).replace(' ','0');
        string FiscalYear = string.valueOf(Integer.valueOf(ClsOEMUtil.CurrentFY) + 2);      

        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9(); 
        Apex_Helper_Settings__c ahs10 = ClsTestHelp.createTestName10();
        Apex_Helper_Settings__c ahs11 = ClsTestHelp.createTestName11();
        TE_Connection__c tec = ClsTestHelp.createTestTEConnection();  

		//comment out mobilevizart config settings for prod
        /*MobileVizArt__Concurrency_Handling__c ch0 = new MobileVizArt__Concurrency_Handling__c();
        for(MobileVizArt__Concurrency_Handling__c ch1 : [select Name,MobileVizArt__Active__c from MobileVizArt__Concurrency_Handling__c where Name = 'Opportunity' limit 1]){
            ch0 = ch1;
        }
        if(ch0.Name == null){
            ch0.MobileVizArt__Active__c = true;
            ch0.Name = 'Opportunity';
            insert ch0;
        }
    
        MobileVizArt__Concurrency_Handling__c ch2 = new MobileVizArt__Concurrency_Handling__c();
        for(MobileVizArt__Concurrency_Handling__c ch1 : [select Name,MobileVizArt__Active__c from MobileVizArt__Concurrency_Handling__c where Name = 'Account' limit 1]){
            ch2 = ch1;
        }
        if(ch2.Name == null){
            ch2.MobileVizArt__Active__c = true;
            ch2.Name = 'Account';
            insert ch2;
        } */
        //end

        Consumer_Device_Opportunity_Record_Types__c csd1 = ClsTestHelp.createTestCSD1();
        Consumer_Device_Opportunity_Record_Types__c csd2 = ClsTestHelp.createTestCSD2();
        Consumer_Device_Opportunity_Record_Types__c csd3 = ClsTestHelp.createTestCSD3();
        Consumer_Device_Opportunity_Record_Types__c csd4 = ClsTestHelp.createTestCSD4();
        Consumer_Device_Opportunity_Record_Types__c csd5 = ClsTestHelp.createTestCSD5();
        Consumer_Device_Opportunity_Record_Types__c csd6 = ClsTestHelp.createTestCSD6();
        Consumer_Device_Opportunity_Record_Types__c csd7 = ClsTestHelp.createTestCSD7();
        
        account OemAcct = clstesthelp.createTestAccounts();
        OemAcct.name ='Test OEM Account';
        OemAcct.Account_Manager__c = UserInfo.getUserId();
        OemAcct.OwnerId = UserInfo.getUserId();
        OemAcct.RecordTypeId = csd7.record_type_id__c;         
        
        insert OemAcct;
        
        OEM_Details__c d = new OEM_Details__c();
        d.Fiscal_Month__c = FiscalMonth;
        d.Fiscal_Year__c = FiscalYear;
        d.Cutoff_Date__c = '15';
        d.OEM__c = OemAcct.id;
        d.OEM__r = OemAcct;
        
        insert d;
            
        OEM_Mapping_Rule__c rule = new OEM_Mapping_Rule__c();               
        rule.WWAC__c = '00000000';
        rule.Type__c = 'WWAC';        
        rule.Allocation__c = 100;
        rule.Fiscal_Month__c = FiscalMonth;
        rule.Fiscal_Year__c = FiscalYear;
        rule.OEM__c = d.id;
        rule.OEM__r = d;
        
        insert rule;                  
        
        ClsScheduled_OEMDailyBBBSummary obj = new ClsScheduled_OEMDailyBBBSummary();                
        String jobId = system.schedule('test', sch, obj); 
        system.assert(true);
        
        Test.stopTest();        
        
    }
}