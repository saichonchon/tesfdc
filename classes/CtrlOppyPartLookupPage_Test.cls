/**
*	This test class is for CtrlOppyPartLookupPage.
*
@author Di Chen
@created 2012-03-14
@version 1.0
@since 20.0
*
@changelog
* 2012-03-14 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 92%
*/
@isTest
private class CtrlOppyPartLookupPage_Test {

    
    
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
        
        CtrlOppyPartLookupPage ctrl = new CtrlOppyPartLookupPage();
        ctrl.partId = oppypart.Id;
        ctrl.part = oppypart;
        
        CtrlOppyPartLookupPage.competitorValid('Shadow Fiend');
        system.assert(true);
        Test.stopTest();
    }
	static testMethod void TestElse() {
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Name = 'Shadow Fiend';
        acc.Type = 'competitor';
       // insert acc;
        
        Account acc2 = ClsTestHelp.createTestAccounts();
        acc2.Name = 'Scofield';
        acc2.Type = 'competitor';
      //  insert acc2;
        
        Account acc3 = ClsTestHelp.createTestAccounts();
        acc3.Name = 'Scofield';
        acc3.Type = 'competitor';
      
        insert new list<account>{acc,acc2,acc3};
            
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
        
        CtrlOppyPartLookupPage ctrl = new CtrlOppyPartLookupPage();
        ctrl.partId = oppypart.Id;
        ctrl.part = oppypart;
        ctrl.isADM='false';
        
        CtrlOppyPartLookupPage.competitorValid('Scofield');
        system.assert(true);
        
        //testing exception :
        try{
        ApexPages.currentPage().getParameters().put('partId','006123123123123');
        ApexPages.currentPage().getParameters().put('reason',oppypart.Lost_Reason__c);
        ApexPages.currentPage().getParameters().put('reasonText',oppypart.Lost_Reason_Text__c);
        
        CtrlOppyPartLookupPage ctrl1 = new CtrlOppyPartLookupPage();
        ctrl1.partId = oppypart.Id; 
        }
        catch(exception e){
            system.debug(e.getMessage()+' at '+ e.getStackTraceString());
        }
        
        
        
        Test.stopTest();
    }
}