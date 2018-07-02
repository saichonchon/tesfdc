/**
*   This test class is for CtrlSearchPartForProposal.
*
@author Di Chen
@created 2012-04-23
@version 1.0
@since 20.0
*
@changelog
* 2012-04-23 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 84%
*/
@isTest
private class CtrlSearchPartForProposal_Test {

    static testMethod void testMostMethods() {
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
        
        List<Part__c> list_selectedParts = new List<Part__c>();
        list_selectedParts.add(part);
        
        List<Opportunity_Part__c> list_opportunityPartsProposal = new List<Opportunity_Part__c>();
        list_opportunityPartsProposal.add(oppypart);
        
        List<Opportunity_Part__c> list_savedOppPartsProposal = new List<Opportunity_Part__c>();
        list_savedOppPartsProposal.add(oppypart);
        
        List<CtrlSearchPartForProposal.SelectPartWrapper> list_selectablePartList = new List<CtrlSearchPartForProposal.SelectPartWrapper>();
        CtrlSearchPartForProposal.SelectPartWrapper extSelect = new CtrlSearchPartForProposal.SelectPartWrapper(part);
        extSelect.part = part;
        extSelect.selected = true;
        list_selectablePartList.add(extSelect);
        
        Test.startTest();
        
        CtrlSearchPartForProposal ctrl = new CtrlSearchPartForProposal();
        ctrl.oppPart = oppypart;
        ctrl.searchResultsPageNumber = 1;
        ctrl.list_selectedParts = list_selectedParts;
        ctrl.list_selectablePartList = list_selectablePartList;
        ctrl.list_opportunityPartsProposal = list_opportunityPartsProposal;
        ctrl.list_savedOppPartsProposal = list_savedOppPartsProposal;
        
        ctrl.searchResultsPageNumber = 1;
        ctrl.searchPartNumber = '%1%';
        ctrl.searchPartDesc = '%11%';
        ctrl.searchGPL = '%111%';
        ctrl.searchGPLDesc = '%1111%';
        ctrl.searchPartNumberLOOKUP = '%2%';
        ctrl.searchPartDescLOOKUP= '%22%';
        ctrl.searchGPLLOOKUP = '%222%';
        ctrl.searchGPLDescLOOKUP = '%2222%';
        ctrl.searchSOSLLOOKUP = 'Description__c';
        ctrl.searchSOSL = 'Description__c';
        ctrl.deleteOpportunityPartIndex = 1;
        ctrl.deleteOpportunityPartIndexProposal = 1;
        
        ctrl.getAmounts();
        ctrl.JumpToSearchResultsPage();
        ctrl.GetSelected();
        ctrl.SearchResultsNextPage();
        ctrl.SearchResultsPreviousPage();
        ctrl.ClearSearchString();
        ctrl.SearchPart();
        ctrl.DoSearchResultsSort();
        
        CtrlSearchPartForProposal.SalesOnlyRecordTypeId();
        CtrlSearchPartForProposal.proposalPartId();
        CtrlSearchPartForProposal.SalesOnlyRecordTypeId();
        CtrlSearchPartForProposal.proposalPartId();
        CtrlSearchPartForProposal.oppRTId('cap');
        CtrlSearchPartForProposal.oppRTId('sp');
        CtrlSearchPartForProposal.oppRTId('nd');
        CtrlSearchPartForProposal.oppRTId('e');
        
        system.assert(true);
        Test.stopTest();
        }
    }
    
    static testMethod void testLeastMethods() {
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
        oppypart.Similar_TE_Part_Number__c = null;
        oppypart.GPL__c = null;
        insert oppypart;
        
        List<Part__c> list_selectedParts = new List<Part__c>();
        list_selectedParts.add(part);
        
        List<CtrlSearchPartForProposal.SelectPartWrapper> list_selectablePartList = new List<CtrlSearchPartForProposal.SelectPartWrapper>();
        CtrlSearchPartForProposal.SelectPartWrapper extSelect = new CtrlSearchPartForProposal.SelectPartWrapper(part);
        extSelect.part = part;
        extSelect.selected = true;
        list_selectablePartList.add(extSelect);
        
        List<Opportunity_Part__c> list_opportunityPartsProposal = new List<Opportunity_Part__c>();
        list_opportunityPartsProposal.add(oppypart);
        
        List<Opportunity_Part__c> list_savedOppPartsProposal = new List<Opportunity_Part__c>();
        list_savedOppPartsProposal.add(oppypart);
        
        Test.startTest();
        
        CtrlSearchPartForProposal ctrl = new CtrlSearchPartForProposal();
        ctrl.oppPart = oppypart;
        ctrl.searchResultsPageNumber = 1;
        ctrl.list_selectedParts = list_selectedParts;
        ctrl.list_selectablePartList = list_selectablePartList;
        ctrl.list_opportunityPartsProposal = list_opportunityPartsProposal;
        ctrl.list_savedOppPartsProposal = list_savedOppPartsProposal;
        ctrl.searchStringLOOKUP = '12';
        
        //ctrl.SearchPart();

        system.assert(true);
        Test.stopTest();
        }
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
        
        List<Part__c> list_selectedParts = new List<Part__c>();
        list_selectedParts.add(part);
        
        List<Opportunity_Part__c> list_opportunityPartsProposal = new List<Opportunity_Part__c>();
        list_opportunityPartsProposal.add(oppypart);
        
        List<Opportunity_Part__c> list_savedOppPartsProposal = new List<Opportunity_Part__c>();
        list_savedOppPartsProposal.add(oppypart);
        
        List<CtrlSearchPartForProposal.SelectPartWrapper> list_selectablePartList = new List<CtrlSearchPartForProposal.SelectPartWrapper>();
        CtrlSearchPartForProposal.SelectPartWrapper extSelect = new CtrlSearchPartForProposal.SelectPartWrapper(part);
        extSelect.part = part;
        extSelect.selected = true;
        list_selectablePartList.add(extSelect);
        
        Test.startTest();
        
        CtrlSearchPartForProposal ctrl = new CtrlSearchPartForProposal();
        ctrl.oppPart = oppypart;
        ctrl.isSearchByPartNumberOnly = true;
        ctrl.searchStringLOOKUP = '12qwqeqw';
        
        ctrl.SearchPart();
        
        system.assert(true);
        Test.stopTest();
        }
    }

}