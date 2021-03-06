/**
 *  This test class is for ClsSchedule_ConvertedOppPartEmailAlert.
 *  Rajendra Shahane 04/11/2016  Modified for case - 900786
 */
@isTest(seeAllData = false)
public class ClsSchedule_ConvertedOppPartTest {
    
    static testMethod void testAll() {
        
        DateTime currTime = DateTime.now();
        Integer min = currTime.minute();
        Integer hour = currTime.hour();
        String sch;
        
        if(min <= 58)
            sch = '0 '+ (min + 1) + ' ' + hour + ' * * ? '+ currTime.year();
        else          
            sch = '0 0 '+ (hour + 1) + ' * * ? '+ currTime.year();
        Profile p = [Select Id, Name From Profile 
                                where Name = 'Channel Standard User' 
                                or Name = 'Service Account' 
                                or Name ='System Administrator' 
                                or Name ='Systemadministrator' limit 1];
        //start : Rajendra Shahane 04/11/2016  Modified for case - 900786
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings(); 
        Opportunity_Approvers__c oa = ClsTestHelp.createTestOpportunityApprovers();        
        Opportunity_Approvers__c oa2 = ClsTestHelp.createTestOpportunityApprovers2();        
        Opportunity_Approvers__c oa3 = ClsTestHelp.createTestOpportunityApprovers3();
        Opportunity_Approvers__c oa4 = ClsTestHelp.createTestOpportunityApprovers4();        
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
        Apex_Helper_Settings__c newSetting = new Apex_Helper_Settings__c (name = 'APL_Email_Alert_Template',value__c = 'https://c2s.my.salesforce.com/servlet/servlet.ImageServer?;id=015E0000000P3MB;id=015E0000001hKDe;&oid=00DE0000000Hkve;https://c2s.my.salesforce.com/');
        Apex_Helper_Settings__c exceptUser= new Apex_Helper_Settings__c();
        exceptUser.name = 'Currency Confirm Except Users';
        exceptUser.value__c = 'test';
        exceptUser.Active__c = true;
        //insert exceptUser;
        Apex_Helper_Settings__c csdGPL= new Apex_Helper_Settings__c();
        csdGPL.name = 'CSD GPL Code Id';
        csdGPL.value__c = 'test';
        csdGPL.Active__c = true;
        //insert csdGPL;
        Apex_Helper_Settings__c aplRecord = new Apex_Helper_Settings__c();
        aplRecord.name = 'Appliance Opportunity Record Type Id';
        aplRecord.value__c = 'test';
        aplRecord.Active__c = true;
        insert new List<Apex_Helper_Settings__c> {aplRecord,csdGPL,exceptUser,newSetting};
                                                    
        TE_Connection__c tec = ClsTestHelp.createTestTEConnection();
        Profit_BU_Center_Mapping_Rule1__c pb1 = ClsTestHelp.createTestProfitBUCenterMapping1();
        Profit_BU_Center_Mapping_Rule2__c pb2 = ClsTestHelp.createTestProfitBUCenterMapping2();
        Profit_BU_Center_Mapping_Rule3__c pb3 = ClsTestHelp.createTestProfitBUCenterMapping3();
        Consumer_Device_Opportunity_Record_Types__c csd1 = ClsTestHelp.createTestCSD1();
        Consumer_Device_Opportunity_Record_Types__c csd2 = ClsTestHelp.createTestCSD2();
        Consumer_Device_Opportunity_Record_Types__c csd3 = ClsTestHelp.createTestCSD3();
        Consumer_Device_Opportunity_Record_Types__c csd4 = ClsTestHelp.createTestCSD4();
        Consumer_Device_Opportunity_Record_Types__c csd5 = ClsTestHelp.createTestCSD5();
        Consumer_Device_Opportunity_Record_Types__c csd6 = ClsTestHelp.createTestCSD6();
        Consumer_Device_Opportunity_Record_Types__c csd7 = ClsTestHelp.createTestCSD7();
        
        //RecordType rt = ClsTestHelp.createTestRecordType();
        RecordType rt2 = ClsTestHelp.createTestRecordType16();      
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        insert acc; 
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        //oppy.Program__c = oppy2.Id;   
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Converted_Email_Alert_Date__c = System.today() -1;
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.StageName = 'New';
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Currency_confirm__c = true;
        oppy.Five_Year_Revenue__c = 1;
        oppy.RecordTypeId = rt2.Id; 
        //oppy.Mass_prod_Status__c = true;
        insert oppy;
         
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        insert ph;
        
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppypart.Status__c = 'Test';
        oppypart.won_date__c = System.today()-1;
        oppypart.GPL__c = ph.Id;
        oppypart.Initial_Order_Date__c = date.today()-4;
        oppypart.Quantity__c = 12;
        oppypart.already_sent_convert_email__c= false;
        insert oppypart;
        oppypart.won_date__c = System.today()-1;
        update oppypart; 
        //End : Rajendra Shahane 04/11/2016  Modified for case - 900786
        Test.startTest();
        
        ClsSchedule_ConvertedOppPartEmailAlert obj = new ClsSchedule_ConvertedOppPartEmailAlert();                
        String jobId = system.schedule('test_NPSMSG', sch, obj); 
        
        Test.stopTest();
        
    }
}