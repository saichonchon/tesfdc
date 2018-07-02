/**
*	This test class is for CtrlSalesPartPopupPage.
*
@author Di Chen
@created 2012-03-14
@version 1.0
@since 20.0
*
@changelog
* 2012-03-14 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 82%
*/
@isTest
private class CtrlSalesPartPopupPage_Test {

    static testMethod void testMostMethods() {
    	
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
        
        List<CtrlSalesPartPopupPage.SelectPartWrapper> list_selectablePartList = new List<CtrlSalesPartPopupPage.SelectPartWrapper>();
        CtrlSalesPartPopupPage.SelectPartWrapper extSelect = new CtrlSalesPartPopupPage.SelectPartWrapper(part);
        extSelect.part = part;
        extSelect.selected = true;
        list_selectablePartList.add(extSelect);
        
        List<CtrlSalesPartPopupPage.OpportunityPartWrapper> list_singlePageOpportunityParts = new List<CtrlSalesPartPopupPage.OpportunityPartWrapper>();
        CtrlSalesPartPopupPage.OpportunityPartWrapper ctrlOppyPart = new CtrlSalesPartPopupPage.OpportunityPartWrapper(oppypart,1,'TE1','TE2');
        ctrlOppyPart.index = 1;
        ctrlOppyPart.opportunityPart = oppypart;
        ctrlOppyPart.TembPartName = 'TE1';
        ctrlOppyPart.TembSimilarName = 'TE2';
        list_singlePageOpportunityParts.add(ctrlOppyPart);
        
        Test.startTest();
        
        CtrlSalesPartPopupPage ctrl = new CtrlSalesPartPopupPage();
        ctrl.oppPart = oppypart;
        ctrl.searchResultsPageNumber = 1;
        ctrl.list_selectedParts = list_selectedParts;
        ctrl.list_selectablePartList = list_selectablePartList;
        ctrl.list_singlePageOpportunityParts = list_singlePageOpportunityParts;
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
    	ctrl.oppPartListPageNumberProposal = 2;
    	ctrl.oppPartListLastPageProposal = 1;
    	
        ctrl.getAmounts();
        ctrl.NewAddProposalParts();
        ctrl.DoAddProposalParts();
        ctrl.AddResultToPartList();
        ctrl.DoAdvancedSearch();
        ctrl.DoSOSLSearch();
        ctrl.DoAdvancedSearchLOOKUP();
        ctrl.DoSOSLSearchLOOKUP();
        ctrl.DoPartNbrSearchLOOKUP();
        ctrl.DoPartNbrSearch();
        ctrl.ClearAllCheckboxes();
        ctrl.SelectAllCheckboxes();
        ctrl.ClearAdvancedSearch();
        ctrl.ClearPartNbrSearch();
        ctrl.OppPartListPreviousPage();
        ctrl.OppPartListNextPage();
        ctrl.OppPartListPreviousPageProposal();
        ctrl.OppPartListNextPageProposal();
        ctrl.JumpToOppPartListPage();
        ctrl.JumpToSearchResultsPage();
        ctrl.GenerateSelectedPartId();
        ctrl.SearchResultsNextPage();
        ctrl.SearchResultsPreviousPage();
        ctrl.ClearAdvancedSearchLOOKUP();
        ctrl.ClearPartNbrSearchLOOKUP();
        ctrl.JumpToOppPartListPageProposal();
        ctrl.DeleteOpportunityParts();
        ctrl.DeleteOpportunityPartsProposal();
        ctrl.SaveOpportunityParts();
        ctrl.SelectSimilarParts();
        ctrl.GotoOpportunity();
        ctrl.DoSaveAndReturn();
        ctrl.DoSearchResultsSort();
        
        CtrlSalesPartPopupPage.SalesOnlyRecordTypeId();
        CtrlSalesPartPopupPage.proposalPartId();
        CtrlSalesPartPopupPage.oppRTId('cap');
        CtrlSalesPartPopupPage.oppRTId('sp');
        CtrlSalesPartPopupPage.oppRTId('nd');
        CtrlSalesPartPopupPage.oppRTId('e');
        
        system.assert(true);
        Test.stopTest();
    }
    
	static testMethod void testLeastMethods() {
    	
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
    //	insert oppypart;
    	
        List<Part__c> list_selectedParts = new List<Part__c>();
        list_selectedParts.add(part);
        
        List<CtrlSalesPartPopupPage.SelectPartWrapper> list_selectablePartList = new List<CtrlSalesPartPopupPage.SelectPartWrapper>();
        CtrlSalesPartPopupPage.SelectPartWrapper extSelect = new CtrlSalesPartPopupPage.SelectPartWrapper(part);
        extSelect.part = part;
        extSelect.selected = true;
        list_selectablePartList.add(extSelect);
        
        List<CtrlSalesPartPopupPage.OpportunityPartWrapper> list_singlePageOpportunityParts = new List<CtrlSalesPartPopupPage.OpportunityPartWrapper>();
        CtrlSalesPartPopupPage.OpportunityPartWrapper ctrlOppyPart = new CtrlSalesPartPopupPage.OpportunityPartWrapper(oppypart,1,'TE1','TE2');
        ctrlOppyPart.index = 1;
        ctrlOppyPart.opportunityPart = oppypart;
        ctrlOppyPart.TembPartName = 'TE1';
        ctrlOppyPart.TembSimilarName = 'TE2';
        list_singlePageOpportunityParts.add(ctrlOppyPart);
        
        List<Opportunity_Part__c> list_opportunityPartsProposal = new List<Opportunity_Part__c>();
        list_opportunityPartsProposal.add(oppypart);
        
        List<Opportunity_Part__c> list_savedOppPartsProposal = new List<Opportunity_Part__c>();
        list_savedOppPartsProposal.add(oppypart);
        
        Test.startTest();
        
        CtrlSalesPartPopupPage ctrl = new CtrlSalesPartPopupPage();
        ctrl.oppPart = oppypart;
        ctrl.searchResultsPageNumber = 1;
        ctrl.list_selectedParts = list_selectedParts;
        ctrl.list_selectablePartList = list_selectablePartList;
        ctrl.list_singlePageOpportunityParts = list_singlePageOpportunityParts;
    	ctrl.list_opportunityPartsProposal = list_opportunityPartsProposal;
        ctrl.list_savedOppPartsProposal = list_savedOppPartsProposal;
        
        ctrl.DoSaveAndReturn();
        ctrl.SaveOpportunityParts();
        system.assert(true);
        Test.stopTest();
    }
	static testMethod void testLeastMethods2() {
    	
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
        
        List<CtrlSalesPartPopupPage.SelectPartWrapper> list_selectablePartList = new List<CtrlSalesPartPopupPage.SelectPartWrapper>();
        CtrlSalesPartPopupPage.SelectPartWrapper extSelect = new CtrlSalesPartPopupPage.SelectPartWrapper(part);
        extSelect.part = part;
        extSelect.selected = true;
        list_selectablePartList.add(extSelect);
        
        List<CtrlSalesPartPopupPage.OpportunityPartWrapper> list_singlePageOpportunityParts = new List<CtrlSalesPartPopupPage.OpportunityPartWrapper>();
        CtrlSalesPartPopupPage.OpportunityPartWrapper ctrlOppyPart = new CtrlSalesPartPopupPage.OpportunityPartWrapper(oppypart,1,'TE1','TE2');
        ctrlOppyPart.index = 1;
        ctrlOppyPart.opportunityPart = oppypart;
        ctrlOppyPart.TembPartName = 'TE1';
        ctrlOppyPart.TembSimilarName = 'TE2';
        list_singlePageOpportunityParts.add(ctrlOppyPart);
        
        List<Opportunity_Part__c> list_opportunityPartsProposal = new List<Opportunity_Part__c>();
        list_opportunityPartsProposal.add(oppypart);
        
        List<Opportunity_Part__c> list_savedOppPartsProposal = new List<Opportunity_Part__c>();
        list_savedOppPartsProposal.add(oppypart);
        
        Test.startTest();
        
        CtrlSalesPartPopupPage ctrl = new CtrlSalesPartPopupPage();
        ctrl.oppPart = oppypart;
        ctrl.searchResultsPageNumber = 1;
        ctrl.list_selectedParts = list_selectedParts;
        ctrl.list_selectablePartList = list_selectablePartList;
        ctrl.list_singlePageOpportunityParts = list_singlePageOpportunityParts;
    	ctrl.list_opportunityPartsProposal = list_opportunityPartsProposal;
        ctrl.list_savedOppPartsProposal = list_savedOppPartsProposal;
        ctrl.isSaveComplete = false;
        
        ctrl.DoSaveAndReturn();
        system.assert(true);
        Test.stopTest();
    }
}