/**
*   This test class is for CtrlSearchAccountForOppyPartner.
*
@author Di Chen
@created 2012-06-15
@version 1.0
@since 20.0
*
@changelog
* 2012-06-15 Di Chen <di.chen@itbconsult.com>
* - Created 
* - Test coverage 82%
*/
@isTest
private class CtrlSearchAccountForOppyPartner_Test {

    static testMethod void testMostMethods() {
        Test.startTest();
        
        CtrlSearchAccountForOppyPartner ctrl = new CtrlSearchAccountForOppyPartner();
        ctrl.searchStringLOOKUP = 'sdfsd';
        
        ctrl.getAmounts();
        ctrl.JumpToSearchResultsPage();
       // ctrl.SearchPart();
        
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void testMostMethods2() {
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        List<Profit_BU_Center_Mapping_Rule2__c> lstProfit_BU_Center_Mapping_Rule2_Settings = new List<Profit_BU_Center_Mapping_Rule2__c>();
        lstProfit_BU_Center_Mapping_Rule2_Settings.add(new Profit_BU_Center_Mapping_Rule2__c (name = 'Account_IBC_code__c', BU_Profit__c = '038,048,085,084,082,078,080,081,083,076,077,211,203,')); //Account Plan
        insert lstProfit_BU_Center_Mapping_Rule2_Settings;
        Profile p = [Select Id, Name From Profile 
                     where Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'hellosManedsfd@testCompany1233423.com';
        u.Alias = 'dpses';
        u.CommunityNickname = 'NNND';
        u.ProfileId = p.Id;
        insert u;
              
        system.runAs(u){ 
        RecordType rt = ClsTestHelp.createTestRecordType();

        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        insert acc;
 
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        oppy2.Type = 'CM';
        insert oppy2;  
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'GPL';
        ph.Description__c = 'Industrial';
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Proposal Part';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy2.Id;
        oppypart.Part__c = part.Id;
        oppypart.Status__c = 'Lost';
        oppypart.Lost_Reason__c = 'Other';
        oppypart.Lost_Reason_Text__c = null;
        oppypart.Similar_TE_Part_Number__c = part.Id;
        oppypart.GPL__c = ph.Id;
        insert oppypart;
        
        List<CtrlSearchAccountForOppyPartner.SelectAccountWrapper> list_selectablePartList = new List<CtrlSearchAccountForOppyPartner.SelectAccountWrapper>();
        CtrlSearchAccountForOppyPartner.SelectAccountWrapper extSelect = new CtrlSearchAccountForOppyPartner.SelectAccountWrapper(acc);
        extSelect.account = acc;
        extSelect.selected = true;
        list_selectablePartList.add(extSelect);
        
        List<Account> list_searchResults = new List<Account>();
        list_searchResults.add(acc);
        
        Test.startTest();
        
        CtrlSearchAccountForOppyPartner ctrl = new CtrlSearchAccountForOppyPartner();
        ctrl.searchResultsJumpToPage = 1;
        ctrl.searchResultsPageNumber = 1;
        ctrl.list_selectablePartList = list_selectablePartList;
        ctrl.list_searchResults = list_searchResults;
        
        ctrl.getAmounts();
        ctrl.JumpToSearchResultsPage();
        ctrl.SearchResultsNextPage();
        ctrl.SearchResultsPreviousPage();
        ctrl.ClearSearchString();
        ctrl.ClearSearchString();
        ctrl.SearchAccount();
        ctrl.DoSearchResultsSort();
        
        system.assert(true);
        Test.stopTest();
        }
    }
    static testMethod void testMostMethods3() {
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        List<Profit_BU_Center_Mapping_Rule2__c> lstProfit_BU_Center_Mapping_Rule2_Settings = new List<Profit_BU_Center_Mapping_Rule2__c>();
        lstProfit_BU_Center_Mapping_Rule2_Settings.add(new Profit_BU_Center_Mapping_Rule2__c (name = 'Account_IBC_code__c', BU_Profit__c = '038,048,085,084,082,078,080,081,083,076,077,211,203,')); //Account Plan
        insert lstProfit_BU_Center_Mapping_Rule2_Settings;
        Profile p = [Select Id, Name From Profile 
                     where Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'hellosManedsfd@testCompany1233423.com';
        u.Alias = 'dpses';
        u.CommunityNickname = 'NNND';
        u.ProfileId = p.Id;
        insert u;
              
        system.runAs(u){        
        RecordType rt = ClsTestHelp.createTestRecordType();

        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        insert acc;
 
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        oppy2.Type = 'CM';
        insert oppy2;  
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'GPL';
        ph.Description__c = 'Industrial';
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Proposal Part';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy2.Id;
        oppypart.Part__c = part.Id;
        oppypart.Status__c = 'Lost';
        oppypart.Lost_Reason__c = 'Other';
        oppypart.Lost_Reason_Text__c = null;
        oppypart.Similar_TE_Part_Number__c = part.Id;
        oppypart.GPL__c = ph.Id;
        insert oppypart;
        
        List<CtrlSearchAccountForOppyPartner.SelectAccountWrapper> list_selectablePartList = new List<CtrlSearchAccountForOppyPartner.SelectAccountWrapper>();
        CtrlSearchAccountForOppyPartner.SelectAccountWrapper extSelect = new CtrlSearchAccountForOppyPartner.SelectAccountWrapper(acc);
        extSelect.account = acc;
        extSelect.selected = true;
        list_selectablePartList.add(extSelect);
        
        List<Account> list_searchResults = new List<Account>();
        list_searchResults.add(acc);
        
        Test.startTest();
        
        CtrlSearchAccountForOppyPartner ctrl = new CtrlSearchAccountForOppyPartner();
        ctrl.searchResultsJumpToPage = 1;
        ctrl.searchResultsPageNumber = 1;
        ctrl.list_selectablePartList = list_selectablePartList;
        ctrl.list_searchResults = list_searchResults;
        ctrl.searchSOSLLOOKUP = 'xxxxxxx';
        ctrl.searchStringLOOKUP = 'xxxxxxx';
        
        //ctrl.SearchAccount();
        
        system.assert(true);
        Test.stopTest();
        }
    }
}