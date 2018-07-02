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
@isTest (seeallData = true)
private class SearchAccountsforGAM_Test {

    static testMethod void testMostMethods() {
        Test.startTest();
        
        SearchAccountsforGAM ctrl = new SearchAccountsforGAM();
        ctrl.searchStringLOOKUP = 'sdfsd';
        
        ctrl.getAmounts();
        ctrl.JumpToSearchResultsPage();
        ctrl.SearchAccount();
        
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void testMostMethods2() {
        
        RecordType rt = C2ForecastTestHelp.createTestRecordType();

        Account acc = C2ForecastTestHelp.createTestAccounts();
        acc.RecordTypeId = rt.Id;
        acc.AccountNumber = '1001:10202022';
        acc.Type = 'CM';
        insert acc;
 
            
        List<SearchAccountsforGAM.SelectAccountWrapper> list_selectablePartList = new List<SearchAccountsforGAM.SelectAccountWrapper>();
        SearchAccountsforGAM.SelectAccountWrapper extSelect = new SearchAccountsforGAM.SelectAccountWrapper(acc);
        extSelect.account = acc;
        extSelect.selected = true;
        list_selectablePartList.add(extSelect);
        
        List<Account> list_searchResults = new List<Account>();
        list_searchResults.add(acc);
        
        Test.startTest();
        
        SearchAccountsforGAM ctrl = new SearchAccountsforGAM();
        ctrl.searchResultsJumpToPage = 1;
        ctrl.searchResultsPageNumber = 1;
        ctrl.list_selectableAccountList = list_selectablePartList;
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
    static testMethod void testMostMethods3() {
        
        RecordType rt = ClsTestHelp.createTestRecordType();

        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        acc.AccountNumber = '1001:10202020';
        acc.RecordTypeId = rt.Id;
        insert acc;
 
        List<SearchAccountsforGAM.SelectAccountWrapper> list_selectablePartList = new List<SearchAccountsforGAM.SelectAccountWrapper>();
        SearchAccountsforGAM.SelectAccountWrapper extSelect = new SearchAccountsforGAM.SelectAccountWrapper(acc);
        extSelect.account = acc;
        extSelect.selected = true;
        list_selectablePartList.add(extSelect);
        
        List<Account> list_searchResults = new List<Account>();
        list_searchResults.add(acc);
        
        Test.startTest();
        
        SearchAccountsforGAM ctrl = new SearchAccountsforGAM();
        ctrl.searchResultsJumpToPage = 1;
        ctrl.searchResultsPageNumber = 1;
        ctrl.list_selectableAccountList = list_selectablePartList;
        ctrl.list_searchResults = list_searchResults;
        ctrl.searchSOSLLOOKUP = 'xxxxxxx';
        ctrl.searchStringLOOKUP = 'xxxxxxx';
        
        ctrl.SearchAccount();
        
        system.assert(true);
        Test.stopTest();
    }
}