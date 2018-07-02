/**
*   This test class is for OpportunityPart_BIU_validateApproverPM.
*
@author Di Chen
@created 2012-02-23
@version 1.0
@since 20.0
*
@changelog
* 2012-02-23 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 
*/
@isTest
private class TrgOppyPart_BIU_validateApproverPM_Test {

    static testMethod void testUpdate() {
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
        RecordType rt = ClsTestHelp.createTestRecordType10();
        RecordType rt2 = ClsTestHelp.createTestRecordType9();
            
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        acc.AccountNumber = 'test';
        insert acc;

        Opportunity oppy = ClsTestHelp.createTestOpportunity(); 
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        oppy.AccountId = acc.Id;
        insert oppy;
            
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        ph.Product_Manager__c = UserInfo.getUserId();
        insert ph;
            
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
            
        Test.startTest();
            
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppypart.Part__c = part.Id;
        oppypart.Status__c = 'Lost';
        oppypart.Lost_Reason__c = 'Other';
        oppypart.Lost_Reason_Text__c = null;
        oppypart.GPL__c = ph.Id;
        insert oppypart;
    
        Opportunity_Part__c oppypart1 = [select Id ,Status__c,Product_Manager_Id__c from Opportunity_Part__c where Id =: oppypart.Id];
        oppypart1.Lost_Reason_Text__c = 'nihao';
        update oppypart1;
        
        system.assertEquals('Lost', oppypart1.Status__c);
        Test.stopTest();
    }
    static testMethod void testUpdate2() {
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
        RecordType rt = ClsTestHelp.createTestRecordType10();
        RecordType rt2 = ClsTestHelp.createTestRecordType9();
            
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        acc.AccountNumber = 'test';
        insert acc;

        Opportunity oppy = ClsTestHelp.createTestOpportunity(); 
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        oppy.AccountId = acc.Id;
        insert oppy;
            
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        insert ph;
            
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
            
        Test.startTest();
            
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppypart.Part__c = part.Id;
        oppypart.Status__c = 'Won';
        oppypart.Lost_Reason__c = 'Other';
        oppypart.Lost_Reason_Text__c = null;
        oppypart.GPL__c = ph.Id;
        oppypart.Process_Status__c = 'Production';
        insert oppypart;
        
        oppypart.Process_Status__c = 'Ramp-down';
        update oppypart;
        
        Opportunity_Part__c oppypart1 = [select Id ,Status__c,Product_Manager_Id__c from Opportunity_Part__c where Id =: oppypart.Id];
        update oppypart1;
        
        system.assertEquals('Won', oppypart1.Status__c);        
        Test.stopTest();
        
    }
    static testMethod void testUpdate3() {
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
        RecordType rt = ClsTestHelp.createTestRecordType10();
        RecordType rt2 = ClsTestHelp.createTestRecordType9();
        
        Profile p = [Select Id, Name From Profile 
                                where Name ='DND Standard User' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'treews@testCompany999.com';
        u.Alias = 'sf45';
        u.ProfileId = p.Id;
        u.CommunityNickname = 'ondj';
        u.IsActive = true;
        u.Username='WhoAmI@xx.com';
        u.Te_Network_Id__c = 'Test1665165';
        insert u;            
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        acc.AccountNumber = 'test';
        insert acc;

        Opportunity oppy = ClsTestHelp.createTestOpportunity(); 
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        oppy.AccountId = acc.Id;
        insert oppy;
            
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        ph.Product_Manager__c = UserInfo.getUserId();
        insert ph;
        
        Product_Hierarchy__c ph2 = new Product_Hierarchy__c();
        ph2.Hierarchy_Level_Type__c = 'CBC1';
        ph2.Description__c = 'Industrial';
        ph2.Product_Manager__c = u.Id;
        insert ph2;        
            
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
            
        Test.startTest();
            
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppypart.Part__c = part.Id;
        oppypart.Status__c = 'Lost';
        oppypart.Lost_Reason__c = 'Other';
        oppypart.Lost_Reason_Text__c = null;
        oppypart.GPL__c = ph.Id;
        insert oppypart;
        
        oppypart.GPL__c = ph2.Id;
        update oppypart;
    
        Opportunity_Part__c oppypart1 = [select Id ,Status__c,Product_Manager_Id__c from Opportunity_Part__c where Id =: oppypart.Id];
        oppypart1.Lost_Reason_Text__c = 'nihao';
        update oppypart1;
        
        system.assertEquals('Lost', oppypart1.Status__c);
        Test.stopTest();
    }
    
    static testMethod void testUpdate4() {
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
        RecordType rt = ClsTestHelp.createTestRecordType10();
        RecordType rt2 = ClsTestHelp.createTestRecordType9();
            
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        acc.AccountNumber = 'test';
        insert acc;

        Opportunity oppy = ClsTestHelp.createTestOpportunity(); 
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        oppy.AccountId = acc.Id;
        insert oppy;
            
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        insert ph;
            
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
            
        Test.startTest();
            
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppypart.Part__c = part.Id;
        oppypart.Status__c = 'Won';
        oppypart.Lost_Reason__c = 'Other';
        oppypart.Lost_Reason_Text__c = null;
        oppypart.GPL__c = ph.Id;
        oppypart.Process_Status__c = 'Ramp-down';
        insert oppypart;
        
        oppypart.Process_Status__c = 'Production';
        update oppypart;
        
        Opportunity_Part__c oppypart1 = [select Id ,Status__c,Product_Manager_Id__c from Opportunity_Part__c where Id =: oppypart.Id];
        update oppypart1;
        
        system.assertEquals('Won', oppypart1.Status__c);        
        Test.stopTest();
        
    }    
 
}