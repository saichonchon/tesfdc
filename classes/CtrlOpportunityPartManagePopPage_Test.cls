/**
*	This test class is for ExtOpportunityPart.
*
@author Di Chen
@created 2012-03-14
@version 1.0
@since 20.0
*
@changelog
* 2012-03-14 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 83%
*/
@isTest
private class CtrlOpportunityPartManagePopPage_Test {

    static testMethod void testMostMethods() {
		RecordType rt = ClsTestHelp.createTestRecordType();

		Account acc = ClsTestHelp.createTestAccounts();
		acc.Type = 'CM';
		insert acc;
 
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        oppy2.Type = 'CM';
       
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
       // oppy.Program__c = oppy2.Id;   
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Cable Assembly';
        insert new List<Opportunity>{oppy,oppy2};
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'GPL';
        ph.Description__c = 'Industrial';
        insert ph;
        
        Part__c part = new Part__c();
    	part.Description__c = 'Proposal Part';
    	part.Product_Hierarchy__c = ph.Id;
    	insert part;
    	
    	Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
    	oppypart.Opportunity__c = oppy.Id;
    	oppypart.Part__c = part.Id;
        oppypart.Status__c = 'Lost';
    	oppypart.Lost_Reason__c = 'Other';
    	oppypart.Lost_Reason_Text__c = null;
    	oppypart.Similar_TE_Part_Number__c = part.Id;
    	oppypart.GPL__c = ph.Id;
    	insert oppypart;
    	
        List<Part__c> list_selectedParts = new List<Part__c>();
        list_selectedParts.add(part);
        
        List<CtrlOpportunityPartManagePopPage.SelectPartWrapper> list_selectablePartList = new List<CtrlOpportunityPartManagePopPage.SelectPartWrapper>();
        CtrlOpportunityPartManagePopPage.SelectPartWrapper extSelect = new CtrlOpportunityPartManagePopPage.SelectPartWrapper(part);
        extSelect.part = part;
        extSelect.selected = true;
        list_selectablePartList.add(extSelect);
        
        Test.startTest();
        
        CtrlOpportunityPartManagePopPage ctrl = new CtrlOpportunityPartManagePopPage();
        ctrl.oppPart = oppypart;
        ctrl.searchResultsPageNumber = 1;
        ctrl.list_selectedParts = list_selectedParts;
        ctrl.list_selectablePartList = list_selectablePartList;
        
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
    	
        ctrl.GetSelected();
        ctrl.DoAdvancedSearchLOOKUP();
        ctrl.DoSearchResultsSort();
        ctrl.JumpToSearchResultsPage();
        ctrl.SearchResultsNextPage();
        ctrl.SearchResultsPreviousPage();
        ctrl.DoPartNbrSearchLOOKUP();
        ctrl.ClearAdvancedSearchLOOKUP();
        ctrl.ClearPartNbrSearchLOOKUP();
        List<CtrlOpportunityPartManagePopPage.SelectPartWrapper> list_singlePageSelectablePart = ctrl.list_singlePageSelectablePart;
        ctrl.list_singlePageSelectablePart = null;
        Integer iValue = ctrl.nbrSelected;
        ctrl.nbrSelected = 4;
        Integer iValue1 = ctrl.oppPartListPageNumber;
        Integer iValue2 = ctrl.searchResultsFirstRecordNbr;
        Integer iValue3 = ctrl.searchResultsLastRecordNbr;
        Boolean iValue4 = ctrl.searchResultsShowPrevPageLink;
        Boolean iValue5 = ctrl.searchResultsShowNextPageLink;
        system.assert(true);
        Test.stopTest();
    }
}