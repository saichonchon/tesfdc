/**
*   This test class is for CtrlOppyPartDateLookupPage.
*
*/
@isTest(SeeAllData=true)
private class CtrlOppyPartDateLookupPage_Test {

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
        ApexPages.currentPage().getParameters().put('status','Test');
        ApexPages.currentPage().getParameters().put('fieldId','Test');        
        
        CtrlOppyPartDateLookupPage ctrl = new CtrlOppyPartDateLookupPage();
        
        Test.stopTest();
    }   
}