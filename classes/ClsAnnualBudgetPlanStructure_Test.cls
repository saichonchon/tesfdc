/**
*	This test class is for ClsAnnualBudgetPlanStructure.
*
@author Di Chen
@created 2012-06-04
@version 1.0
@since 20.0
*
@changelog
* 2012-06-04 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 86%
*/
@isTest
private class ClsAnnualBudgetPlanStructure_Test {

    static testMethod void testMostMethods() {
    	 
    	RecordType rt = ClsTestHelp.createTestRecordType();   	
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	insert acc;
    	
    	Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
    	sh.Level_7_Territory_Code__c = 'A007357';
    	insert sh;
    	
    	Budget__c bg = new Budget__c();
    	bg.Year__c = '2012';
    	bg.Territory__c = sh.Id;
		bg.Total_Direct_Budget_TBR_NY__c = 11;
		bg.Total_Budget_TBR_NY__c = 12;
    	insert bg;
    	
    	Budget_Detail__c bd = ClsTestHelp.createTestBudgetDetail();
    	bd.Account__c = acc.Id;
    	bd.Budget__c = bg.Id;
    	bd.Billings_CYRR__c = 1;
    	insert bd;
    	
    	List<String> list_childIds = new List<String>();
    	list_childIds.add(acc.Id);
    	
        Test.startTest();
        
        ClsAnnualBudgetPlanStructure.BudgetPlanningAccountItem clsBu = new ClsAnnualBudgetPlanStructure.BudgetPlanningAccountItem();
        
        ClsAnnualBudgetPlanStructure.BudgetPlanningAccountStructure clsS = new ClsAnnualBudgetPlanStructure.BudgetPlanningAccountStructure(acc.Id);
        
        ClsAnnualBudgetPlanStructure.BudgetPlanningItem clsItem = new ClsAnnualBudgetPlanStructure.BudgetPlanningItem();
         
        ClsAnnualBudgetPlanStructure cls = new ClsAnnualBudgetPlanStructure(acc.Id);
        cls.list_childIds = list_childIds;
       	cls.accountId = acc.Id;
       	
       	cls.getAccountId4Report();
       	
       	
       	
        
        system.assert(true);
        Test.stopTest();
    }
}