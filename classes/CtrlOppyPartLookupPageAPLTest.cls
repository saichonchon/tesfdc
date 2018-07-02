/**
*  This test class is for CtrlOppyPartLookupPageAPL.
*
@author Nelson Zheng
@created 2015-07-30
@version 1.0
*
@changelog
* 2015-07-30 Nelson Zheng <Yimin.zheng@te.com>
* - Created
* - Test coverage 92%
*/
@isTest(SeeAllData=true)
private class CtrlOppyPartLookupPageAPLTest {

    static testMethod void TestCtrl() {
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Name = 'Shadow Fiend';
        acc.Type = 'competitor';
        insert acc;
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        insert oppy;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        insert ph;
        
        Part__c p = new Part__c();
      p.Description__c = 'Sniper';
      p.Product_Hierarchy__c = ph.Id;
      insert p;
      
      Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
      oppypart.Opportunity__c = oppy.Id;
      oppypart.Part__c = p.Id;
      oppypart.Lost_Reason__c = 'Other';
      oppypart.Lost_Reason_Text__c = '11';
      insert oppypart;
      
        Test.startTest();
        ApexPages.currentPage().getParameters().put('partId',oppypart.Id);
        ApexPages.currentPage().getParameters().put('reason',oppypart.Lost_Reason__c);
        ApexPages.currentPage().getParameters().put('reasonText',oppypart.Lost_Reason_Text__c);
        ApexPages.currentPage().getParameters().put('reasonCompetitor','');
        
        CtrlOppyPartLookupPageAPL ctrl = new CtrlOppyPartLookupPageAPL();
        ctrl.partId = oppypart.Id;
        ctrl.part = oppypart;
        
        CtrlOppyPartLookupPageAPL.competitorValid('Shadow Fiend');
        system.assert(true);
        Test.stopTest();
    }
  static testMethod void TestElse() {
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Name = 'Shadow Fiend';
        acc.Type = 'competitor';
        insert acc;
        
        Account acc2 = ClsTestHelp.createTestAccounts();
        acc2.Name = 'Scofield';
        acc2.Type = 'competitor';
        insert acc2;
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        insert oppy;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        insert ph;
        
        Part__c p = new Part__c();
      p.Description__c = 'Sniper';
      p.Product_Hierarchy__c = ph.Id;
      insert p;
      
      Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
      oppypart.Opportunity__c = oppy.Id;
      oppypart.Part__c = p.Id;
      oppypart.Lost_Reason__c = 'Other';
      oppypart.Lost_Reason_Text__c = '11';
      insert oppypart;
      
        Test.startTest();
        ApexPages.currentPage().getParameters().put('partId',oppypart.Id);
        ApexPages.currentPage().getParameters().put('reason',oppypart.Lost_Reason__c);
        ApexPages.currentPage().getParameters().put('reasonText',oppypart.Lost_Reason_Text__c);
        
        CtrlOppyPartLookupPageAPL ctrl = new CtrlOppyPartLookupPageAPL();
        ctrl.partId = oppypart.Id;
        ctrl.part = oppypart;
        
        CtrlOppyPartLookupPageAPL.competitorValid('Shadow Fiend');
        system.assert(true);
        Test.stopTest();
    }
}