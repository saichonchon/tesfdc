/**
 * Test class for ClsBatch_recalculateNPSForAPL
 * Created by Nelson Zheng 06/12/2015
 *
 *
 */
@isTest
private class ClsBatch_recalculateNPSForAPLTest {

    static testMethod void myUnitTest() {
        User tempUser = [select id from user where GIBU__c = 'Industrial' and Sub_Vertical__c = 'A&C' and isactive = true and PMV_Type_Initialization__c = 'Standard' limit 1];
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        //ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
        ClsTestCustomSettingHelper.getPMV_Language_Config();
        ClsTestCustomSettingHelper.getPMV_Sales_Stage_Setting();
        ClsTestCustomSettingHelper.getPMV_Stage_Config();
        ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
        
        list<Group> list_pgs = [select Name from Group where id in (select GroupId from GroupMember where userorgroupid = :UserInfo.getUserId())];
        
        ADMTerritoryCode__c ADMTerritoryCode = new ADMTerritoryCode__c(Name='ADMTerritoryCode', Territory_Code__c='101485');
        insert ADMTerritoryCode;
        
        RecordType rt = ClsTestHelp.createTestRecordType6();
        RecordType rt2 = ClsTestHelp.createTestRecordType16();
        RecordType rt3 = ClsTestHelp.createTestRecordType23();
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt.Id;
        acc.Account_Manager__c = UserInfo.getUserId();
        insert acc;
        
        Account acc2 = ClsTestHelp.createTestAccounts();
        acc2.RecordTypeId = rt.Id;
        acc2.Account_Manager__c = UserInfo.getUserId();
        insert acc2;
            
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        oppy2.Type = 'CM';
        oppy2.Request_Type__c = 'Extension';
        oppy2.RecordTypeId = rt3.Id;
        //oppy2.RecordTypeId = oppyRtId;
        oppy2.accountid = acc2.Id;
        insert oppy2;  
    
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial'; 
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy2.Id;
        oppypart.Part__c = oppypart.Id;
        oppypart.Similar_TE_Part_Number__c = part.Id;
        oppypart.initial_billing_date__c = date.today();
        oppypart.Initial_Order_Date__c = date.today();
        oppypart.Process_Status__c = 'Production';
        //oppypart.Opportunity_Record_Type__c = Opportunity_Record_Type_Groups__c.getInstance('DND Opportunity').RecordTypeID__c;
        insert oppypart;
        
        Date d = date.today();
        String month = d.month()+'';
        month = month.length() == 2 ? month : '0'+month;
        
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast.Opportunity__c = oppy2.Id;
        oppyForecast.Quantity__c = 12;
        oppyForecast.Part__c = oppypart.Id;
        oppyForecast.Date__c = date.today();
        oppyForecast.Sales_Price__c = 123;
        oppyForecast.Fiscal_Month__c = month;
        oppyForecast.Fiscal_Year__c = d.year()+'';
        oppyForecast.Amount__c = 1;
        //insert oppyForecast;
        
        List<Opportunity_Forecast__c> list_fcs = new List<Opportunity_Forecast__c>{oppyForecast};
        insert list_fcs;
        
        Test.startTest();
            ClsBatch_recalculateNPSForAPL bb = new ClsBatch_recalculateNPSForAPL(list_fcs);
            Database.executeBatch(bb);
        Test.stopTest();
    }
    
    static testMethod void test_DndOppy() {
        User tempUser = [select id from user where GIBU__c = 'Industrial' and Sub_Vertical__c = 'A&C' and isactive = true and PMV_Type_Initialization__c = 'Standard' limit 1];
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        //ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
        ClsTestCustomSettingHelper.getPMV_Language_Config();
        ClsTestCustomSettingHelper.getPMV_Sales_Stage_Setting();
        ClsTestCustomSettingHelper.getPMV_Stage_Config();
        ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
        
        list<Group> list_pgs = [select Name from Group where id in (select GroupId from GroupMember where userorgroupid = :UserInfo.getUserId())];
        
        ADMTerritoryCode__c ADMTerritoryCode = new ADMTerritoryCode__c(Name='ADMTerritoryCode', Territory_Code__c='101485');
        insert ADMTerritoryCode;
        
        RecordType rt = ClsTestHelp.createTestRecordType6();
        RecordType rt2 = ClsTestHelp.createTestRecordType16();
        RecordType rt3 = ClsTestHelp.createTestRecordType23();
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt.Id;
        acc.Account_Manager__c = UserInfo.getUserId();
        insert acc;
        
        Account acc2 = ClsTestHelp.createTestAccounts();
        acc2.RecordTypeId = rt.Id;
        acc2.Account_Manager__c = UserInfo.getUserId();
        insert acc2;

        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Program_level_Forecasting__c =true; 
        oppy.Name = 'Pain of Queen';
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.RecordTypeId = rt3.Id;
        oppy.accountid = acc2.Id;
        insert oppy;  
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial'; 
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        insert part;    
        
        Opportunity_Part__c oppypartDnd = ClsTestHelp.createTestOpportunityPart();
        oppypartDnd.Opportunity__c = oppy.Id;
        oppypartDnd.Part__c = oppypartDnd.Id;
        oppypartDnd.Similar_TE_Part_Number__c = part.Id;
        oppypartDnd.initial_billing_date__c = date.today();
        oppypartDnd.Initial_Order_Date__c = date.today();
        oppypartDnd.Process_Status__c = 'Production';
        //oppypartDnd.Opportunity_Record_Type__c = Opportunity_Record_Type_Groups__c.getInstance('DND Opportunity').RecordTypeID__c;
        insert oppypartDnd;
        
        Date d = date.today();
        String month = d.month()+'';
        month = month.length() == 2 ? month : '0'+month;
        
        Opportunity_Forecast__c fc1 = ClsTestHelp.createTestOpportunityForecasts();
        fc1.Opportunity__c = oppy.Id;
        fc1.Quantity__c = 12;
        fc1.Part__c = oppypartDnd.Id;
        fc1.Date__c = date.today();
        fc1.Sales_Price__c = 123;
        fc1.Fiscal_Month__c = month;
        fc1.Fiscal_Year__c = d.year()+'';
        fc1.Amount__c = 1;
        
        List<Opportunity_Forecast__c> list_fcs = new List<Opportunity_Forecast__c>{fc1};
        insert list_fcs;
        
        Test.startTest();
            ClsBatch_recalculateNPSForAPL bb = new ClsBatch_recalculateNPSForAPL(list_fcs);
            Database.executeBatch(bb);
        Test.stopTest();
    }
}