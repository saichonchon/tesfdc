/**
*   This test class is for BatchCls_UpdateOppySalesTeam.
*
@author Chen Chen
@created 2017-02-06
@version 1.0
*
@changelog
* 2017-02-06 Chen Chen <chen.chen@oinio.com>
* - Created
* - Test coverage 100%
*/
@isTest
private class BatchCls_UpdateOppySalesTeam_Test {

    static testMethod void myUnitTest() {
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        
        RecordType rt2 = ClsTestHelp.createTestRecordType10();
        
        Profile p2 = [Select Id, Name From Profile 
                     Where Name like '%Appliance%' limit 1];
        User u2 = ClsTestHelp.createTestUsers();
        u2.Email = 'helloC456@testCompany.com';
        u2.Alias = 'C456';
        u2.CommunityNickname = 'C456';
        u2.ProfileId = p2.Id;
        insert u2;
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        acc.AccountNumber = 'test';
        acc.INDUSTRY_BUSINESS_CDE__c = '115';        

        
        Account acc1 = ClsTestHelp.createTestAccounts();
        acc1.Type = 'TE Dummy Account';
        acc1.Name = 'Test Account11';
        acc1.AccountNumber = 'test11';
        acc1.Industry_Code_Description__c = 'Rail'; 
        acc1.INDUSTRY_BUSINESS_CDE__c = '113';       
        insert new list<Account>{acc, acc1};
        
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        
        oppy2.Name = 'Pain of Queen';
        oppy2.Type = 'CM';
        oppy2.Request_Type__c = 'Extension';
        //oppy2.RecordTypeId = Apex_Helper_Settings__c.getInstance('Tender Opportunity Record Type Id').Value__c;
        oppy2.RecordTypeId = rt2.Id;
        oppy2.Defined_GPLs__c = 'asdf\\|adfa';    
        oppy2.AccountId = acc1.Id;    
        oppy2.StageName = 'New';
        //oppy2.POS_Customer_is_same_as_Account__c = true;
        oppy2.OwnerId = u2.Id;
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Defined_GPLs__c = 'asdf\\|adfa'; 
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        oppy.AccountId = acc.Id;
        oppy.Distributor__c = 'Future';
        //oppy.RecordTypeId = Apex_Helper_Settings__c.getInstance('Tender Opportunity Record Type Id').Value__c;
        oppy.RecordTypeId = rt2.Id;
        oppy.stagename = 'New';
        //oppy.POS_Customer_is_same_as_Account__c = true;
        oppy.OwnerId = u2.Id;
        insert new list<opportunity>{oppy2, oppy};
            
        oppy2.Name = 'Pain of Queen1';   
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        ph.CBC5__c = '30044';

        
        Product_Hierarchy__c ph1 = new Product_Hierarchy__c();
        ph1.Hierarchy_Level_Type__c = 'CBC1';
        ph1.Description__c = 'Industrial';
        ph1.CBC5__c = '12302';
        insert new list<Product_Hierarchy__c>{ph, ph1};
        
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;

        
        Part__c part1 = new Part__c();
        part1.Description__c = 'SniperTest';
        part1.Product_Hierarchy__c = ph1.Id;
        insert new List<Part__c>{part,  part1};
        
        Cross_Dashboard_Filter__c cdf = new Cross_Dashboard_Filter__c();
        cdf.Filter_Value__c = 'Appliances';
        cdf.Type__c = 'SAP Profit Center Group Short Description';
        cdf.Name = 'Appliances';
        insert cdf;
        
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppypart.Part__c = part.Id;
        oppypart.Status__c = 'Won';
        oppypart.Lost_Reason__c = 'Other';
        oppypart.Lost_Reason_Text__c = null;
        oppypart.GPL__c = ph.Id;       
        oppypart.BU_profit_center__c = 'Appliances';
        oppypart.SAP_Profit_Center_Short_Desc_Filter__c = cdf.Id;
        
        Opportunity_Part__c oppypart1 = ClsTestHelp.createTestOpportunityPart();
        oppypart1.Opportunity__c = oppy2.Id;
        oppypart1.Part__c = part1.Id;
        oppypart1.Status__c = 'Won';
        oppypart1.Lost_Reason__c = 'Other';
        oppypart1.Lost_Reason_Text__c = null;
        oppypart1.Part_Number__c = '0-0000000-0';
        oppypart1.GPL__c = ph1.Id;       
        oppypart1.BU_profit_center__c = 'undefined';
        insert new list<Opportunity_Part__c> {oppypart, oppypart1};
        
        Test.startTest();
        BatchCls_UpdateOppySalesTeam cls = new BatchCls_UpdateOppySalesTeam();
		database.executeBatch(cls);
        Test.stopTest();
    }
}