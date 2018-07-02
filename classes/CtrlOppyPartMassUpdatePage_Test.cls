/**
*   This test class is for CtrlOppyPartMassUpdatePage.
*
@author Michael Cui
@created 2014-09-05
@version 1.0
*
*/
@isTest(SeeAllData=true)
private class CtrlOppyPartMassUpdatePage_Test {

    static testMethod void TestCtrl() {
        
        Profile p = [Select Id, Name From Profile 
                                    where Name = 'Production Support'
                                    or Name ='System Administrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        
        
        u.Email = 'helloSand0728@testCompany1407281004.com';
        u.FirstName ='Test0728';
        u.LastName = 'User0728';
        u.Alias = 'dpse0728';
        u.CommunityNickname = 'TMD0728';
        u.ProfileId = p.Id;
        u.GIBU__c = 'Appliances';
        u.Username = 'helloSand0728@testCompany1407281004.com';
        insert u;
        
        RecordType rt2 = ClsTestHelp.createTestRecordType10();
        RecordType rt = ClsTestHelp.createTestRecordType14();
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt.Id;
        acc.Type = 'Global Account';
        acc.Industry_Code_Description__c = 'Appliances';
        acc.LEVEL_1_INDUSTRY_CDE__c = '0283';
        acc.owner = u;
        insert acc;        
        Account acc1 = [select Id, Customer_Industry__c from account where id =: acc.id limit 1];
        
        Account acc2 = ClsTestHelp.createTestAccounts();
        acc2.Name = 'Shadow Fiend1';
        acc2.Type = 'competitor';
        insert acc2;
        
        Opportunity oppy = new Opportunity();
        oppy.StageName = 'New';
        oppy.AccountId = acc1.Id;
        oppy.Account = acc1;
        oppy.Name = 'SandKing';
        oppy.currency_confirm__c = true;
        oppy.CloseDate = date.today();
        oppy.Manufacturing_Start_Date__c = date.today().addMonths(1);
        oppy.RecordTypeId = rt2.Id;             
        oppy.Mass_prod_Status__c = true;
        oppy.owner = u;            
        insert oppy;        
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        part.Market_Date__c = date.today();
        insert part;
        
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppypart.Part__c = part.Id;
        insert oppypart;
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('partId',oppypart.Id);
        ApexPages.currentPage().getParameters().put('selectChk','1234567890');        
        
        CtrlOppyPartMassUpdatePage ctrl = new CtrlOppyPartMassUpdatePage();
        ctrl.partId = oppypart.Id;
        ctrl.part = oppypart;
        
        CtrlOppyPartMassUpdatePage.competitorValid('Shadow Fiend');
        ctrl.getProcessStatusItems();
        system.assert(true);
        Test.stopTest();
    }   
}