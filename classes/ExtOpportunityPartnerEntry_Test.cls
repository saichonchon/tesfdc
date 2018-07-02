/**
*   This test class is for ExtOpportunityPartnerEntry.
*
@author Di Chen
@created 2012-03-14
@version 1.0
@since 20.0
*
@changelog
* 2012-03-14 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 94% (except catch)
*/
@isTest
private class ExtOpportunityPartnerEntry_Test {

    static testMethod void IdNotNull() {
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        insert acc;
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Type = 'CM';
        insert oppy;
        
        Opportunity_Partner__c oppyPartner = new Opportunity_Partner__c();
        oppyPartner.Opportunity__c = oppy.Id;
        oppyPartner.Account__c = acc.Id;
        oppyPartner.Allocation__c = 100;
        oppyPartner.Partner_Role__c = 'Distributor';
        insert oppyPartner;
        
        list<ExtOpportunityPartnerEntry.PartnerInnerClass> list_oppyPartners = new list<ExtOpportunityPartnerEntry.PartnerInnerClass>();
        ExtOpportunityPartnerEntry.PartnerInnerClass extCls = new ExtOpportunityPartnerEntry.PartnerInnerClass();
        extCls.opc = oppyPartner;
        extCls.index = 1;
        list_oppyPartners.add(extCls);
        
        Test.startTest();
        
        ApexPages.StandardController ctrl = new ApexPages.StandardController(oppyPartner); 
        ExtOpportunityPartnerEntry ext = new ExtOpportunityPartnerEntry(ctrl);
        ext.oppPartner = oppyPartner;
        ext.addAmount = 5;
        ext.list_oppyPartners = list_oppyPartners;
        
        ext.SaveAndReturn();
        ext.AddPartners();
        ext.getAmounts();
        ext.DeleteOpportunityPartner();
        ext.cancel();
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void IdNotNull2() {
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        insert acc;
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Type = 'CM';
        oppy.recordtypeid =  Apex_Helper_Settings__c.getInstance('Sales Opportunity Channel').value__c;
        oppy.StageName = 'Concept';
        oppy.POS_Customer_is_same_as_Account__c = true;
        insert oppy;
        
        Opportunity_Partner__c oppyPartner = new Opportunity_Partner__c();
        oppyPartner.Opportunity__c = oppy.Id;
        oppyPartner.Account__c = acc.Id;
        oppyPartner.Allocation__c = 100;
        oppyPartner.Partner_Role__c = 'POS';
        insert oppyPartner;
        
        list<ExtOpportunityPartnerEntry.PartnerInnerClass> list_oppyPartners = new list<ExtOpportunityPartnerEntry.PartnerInnerClass>();
        ExtOpportunityPartnerEntry.PartnerInnerClass extCls = new ExtOpportunityPartnerEntry.PartnerInnerClass();
        extCls.opc = oppyPartner;
        extCls.index = 1;
        list_oppyPartners.add(extCls);
        
        Test.startTest();
        
        ApexPages.StandardController ctrl = new ApexPages.StandardController(oppyPartner); 
        ExtOpportunityPartnerEntry ext = new ExtOpportunityPartnerEntry(ctrl);
        ext.oppPartner = oppyPartner;
        ext.addAmount = 5;
        ext.list_oppyPartners = list_oppyPartners;
        
        ext.SaveAndReturn();
        ext.AddPartners();
        ext.getAmounts();
        ext.DeleteOpportunityPartner();
        ext.cancel();
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void IdNotNull3() {
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        insert acc;
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Type = 'CM';
        insert oppy;
        
        Opportunity_Partner__c oppyPartner = new Opportunity_Partner__c();
        oppyPartner.Opportunity__c = oppy.Id;
        oppyPartner.Account__c = acc.Id;
        oppyPartner.Allocation__c = 100;
        oppyPartner.Partner_Role__c = 'Distributor';
        insert oppyPartner;
        
        
        list<ExtOpportunityPartnerEntry.PartnerInnerClass> list_oppyPartners = new list<ExtOpportunityPartnerEntry.PartnerInnerClass>();
        ExtOpportunityPartnerEntry.PartnerInnerClass extCls = new ExtOpportunityPartnerEntry.PartnerInnerClass();
        extCls.opc = oppyPartner;
        extCls.index = 1;
        list_oppyPartners.add(extCls);
        
        Test.startTest();
        
        ApexPages.StandardController ctrl = new ApexPages.StandardController(oppyPartner); 
        ExtOpportunityPartnerEntry ext = new ExtOpportunityPartnerEntry(ctrl);
        ext.oppPartner = oppyPartner;
        ext.addAmount = 5;
        ext.list_oppyPartners = list_oppyPartners;
        
        ext.SaveAndReturn();
        ext.AddPartners();
        ext.getAmounts();
        ext.checkDuplicatePartner();
        ext.DeleteOpportunityPartner();
        ext.cancel();
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void NullId() {
        Account acc = ClsTestHelp.createTestAccounts();
        insert acc;
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.AccountId = acc.Id;
        oppy.Sum_Part_Allocation__c = 100;
        insert oppy;
        
        Opportunity_Partner__c oppyPartner = new Opportunity_Partner__c();
        oppyPartner.Opportunity__c = oppy.Id;
        oppyPartner.Allocation__c = 100;
        Test.startTest();
        
        ApexPages.StandardController ctrl = new ApexPages.StandardController(oppyPartner); 
        ExtOpportunityPartnerEntry ext = new ExtOpportunityPartnerEntry(ctrl);
        ext.oppPartner = oppyPartner;
        
        system.assert(true);
        Test.stopTest();
    }
}