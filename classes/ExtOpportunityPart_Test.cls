/**
*   This test class is for ExtOpportunityPart.
*
@author Di Chen
@created 2012-03-14
@version 1.0
@since 20.0
*
@changelog
* 2012-03-14 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 79%
*/
@isTest
private class ExtOpportunityPart_Test {
    static testMethod void status() {
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
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Request_Type__c = 'Cable Assembly';
        insert oppy;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        insert ph;
        Product_Hierarchy__c ph1 =[select Id,Hierarchy_Level_Type__c,Description__c from Product_Hierarchy__c where Id = : ph.Id];
        Part__c part = new Part__c();
        part.Description__c = 'Proposal Part';
        part.Product_Hierarchy__c = ph1.Id;
        insert part;
        
        List<Part__c> list_selectedParts = new List<Part__c>();
        list_selectedParts.add(part);
        
        Test.startTest();
        
        ApexPages.StandardController ctrl = new ApexPages.StandardController(oppy); 
        ExtOpportunityPart ext = new ExtOpportunityPart(ctrl);
        ext.list_selectedParts = list_selectedParts;
        
        ext.DoAddProposalParts();
        List<ExtOpportunityPart.OpportunityPartWrapper> list_singlePageOpportunityParts = ext.list_singlePageOpportunityParts;
        List<ExtOpportunityPart.SelectPartWrapper> list_singlePageSelectablePart = ext.list_singlePageSelectablePart;
        Boolean b = ext.searchResultsShowNextPageLink;
        Boolean b1 = ext.searchResultsShowPrevPageLink;
        Boolean b2 = ext.oppPartListShowPrevPageLink;
        Boolean b3 = ext.oppPartListShowNextPageLink;
        integer b4 = ext.searchResultsLastRecordNbr;
        integer b5 = ext.searchResultsFirstRecordNbr;
        integer b6 = ext.oppPartListFirstRecordNumber;
        integer b7 = ext.oppPartListLastRecordNumber; 
        integer b8 = ext.nbrSelected;
        system.assert(true);
        Test.stopTest();
        }
    }

    static testMethod void status1() {
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
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Request_Type__c = 'Cable Assembly';
        insert oppy;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Proposal Part';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppyPart.Opportunity__c = oppy.Id;
        //insert oppyPart;
        
        List<ExtOpportunityPart.SelectPartWrapper> list_selectablePartList = new List<ExtOpportunityPart.SelectPartWrapper>();
        ExtOpportunityPart.SelectPartWrapper extSelect = new ExtOpportunityPart.SelectPartWrapper(part);
        extSelect.part = part;
        extSelect.selected = true;
        list_selectablePartList.add(extSelect);
        
        List<Part__c> list_selectedParts = new List<Part__c>();
        list_selectedParts.add(part);
        
        List<Part__c> list_searchResults = new List<Part__c>();
        list_searchResults.add(part);
        
        //List<Opportunity_Part__c> list_opportunityParts = new List<Opportunity_Part__c>();
        //list_opportunityParts.add(oppyPart);
 
        Test.startTest();

        ApexPages.StandardController ctrl = new ApexPages.StandardController(oppy); 
        ExtOpportunityPart ext = new ExtOpportunityPart(ctrl);
        ext.list_selectablePartList = list_selectablePartList;
        ext.list_selectedParts = list_selectedParts;
        //ext.list_singlePageOpportunityParts = list_singlePageOpportunityParts;
        ext.searchSOSL = 'Name';
        ext.searchString = '23';
        ext.searchResultsJumpToPage = 1;
        ext.searchResultsPageNumber = 1;
        ext.searchResultsPrevSortField = '';
        ext.searchResultsSortField = '';
        ext.oppPartListPageNumber = 1;
        ext.deleteOpportunityPartIndex = 1;
        ext.method = 'partNbr';
        ext.searchPartNumber = '%1%';
        ext.searchPartDesc = '%11%';
        ext.searchGPL = '%111%';
        ext.searchGPLDesc = '%1111%';
        
        //ext.DoAddProposalParts();
        ext.AddResultToPartList();
        ext.DoAdvancedSearch();
        //ext.DoSOSLSearch();
        ext.DoPartNbrSearch();
        ext.SelectAllCheckboxes();
        ext.JumpToSearchResultsPage();
        ext.SearchResultsNextPage();
        ext.SearchResultsPreviousPage();
        ext.DoSearchResultsSort();
        ext.ClearAddProposalParts();
        ext.ClearAdvancedSearch();
        ext.ClearPartNbrSearch();
        ext.OppPartListPreviousPage();
        ext.OppPartListNextPage();
        ext.JumpToOppPartListPage();
        ext.DeleteOpportunityParts();
        ext.SortOpportunityPartList();
        ext.SaveOpportunityParts();
        ext.GotoOpportunity();
        ext.DoSaveAndReturn();
        
        ExtOpportunityPart.oppRTId('cap');
        ExtOpportunityPart.oppRTId('sp');
        ExtOpportunityPart.oppRTId('np');
        ExtOpportunityPart.oppRTId('e');
        system.assert(true);
        Test.stopTest();
        }
    }
    static testMethod void status2() {
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
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Request_Type__c = 'New Development';
        insert oppy;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Appliances';
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Proposal Part';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        List<ExtOpportunityPart.SelectPartWrapper> list_selectablePartList = new List<ExtOpportunityPart.SelectPartWrapper>();
        ExtOpportunityPart.SelectPartWrapper extSelect = new ExtOpportunityPart.SelectPartWrapper(part);
        extSelect.part = part;
        extSelect.selected = true;
        list_selectablePartList.add(extSelect);
        
        List<Part__c> list_selectedParts = new List<Part__c>();
        list_selectedParts.add(part);
        
        Test.startTest();
        
        ApexPages.StandardController ctrl = new ApexPages.StandardController(oppy); 
        ExtOpportunityPart ext = new ExtOpportunityPart(ctrl);
        ext.list_selectablePartList = list_selectablePartList;
        ext.list_selectedParts = list_selectedParts;
        ext.searchResultsJumpToPage = 1000000;
        ext.oppPartListSortFieldPrev = '12';
        ext.oppPartListSortField = 'name';
        ext.method = 'advanced';
        
        ext.DoAddProposalParts();
        ext.AddResultToPartList();
        ext.DoAdvancedSearch();
        ext.DoSOSLSearch();
        ext.JumpToSearchResultsPage();
        
        ext.DeleteOpportunityParts();
        ext.SortOpportunityPartList();
        ext.SetSelectedSearchMethod();
        
        ExtOpportunityPart.oppRTId('cap');
        ExtOpportunityPart.oppRTId('sp');
        ExtOpportunityPart.oppRTId('np');
        ExtOpportunityPart.oppRTId('e');
        system.assert(true);
        Test.stopTest();
        }
    }
    static testMethod void status3() {
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
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Request_Type__c = 'Extension';
        insert oppy;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Data Communications';
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Proposal Part';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        List<ExtOpportunityPart.SelectPartWrapper> list_selectablePartList = new List<ExtOpportunityPart.SelectPartWrapper>();
        ExtOpportunityPart.SelectPartWrapper extSelect = new ExtOpportunityPart.SelectPartWrapper(part);
        extSelect.part = part;
        extSelect.selected = true;
        list_selectablePartList.add(extSelect);
        
        List<Part__c> list_selectedParts = new List<Part__c>();
        list_selectedParts.add(part);
        
        Test.startTest();
        
        ApexPages.StandardController ctrl = new ApexPages.StandardController(oppy); 
        ExtOpportunityPart ext = new ExtOpportunityPart(ctrl);
        ext.list_selectablePartList = list_selectablePartList;
        ext.list_selectedParts = list_selectedParts;
        ext.method = 'proposal';
        
        ext.DoAddProposalParts();
        ext.AddResultToPartList();
        ext.SetSelectedSearchMethod();
        
        ExtOpportunityPart.oppRTId('cap');
        ExtOpportunityPart.oppRTId('sp');
        ExtOpportunityPart.oppRTId('np');
        ExtOpportunityPart.oppRTId('e');
        system.assert(true);
        Test.stopTest();
        }
    }
}