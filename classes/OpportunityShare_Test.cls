/**************************************************************************************************************************************************
Name:  Globla_Product_ManageNameByGPLCode_Test
Copyright © 2013 TE Connectivity
===================================================================================================================================================
Purpose: This class contain Test Methods for Globla_Product_ManageNameByGPLCode
---------------------------------------------------------------------------------------------------------------------------------------------------       
Related APEX Trigger : Globla_Product_ManageNameByGPLCode
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
Version Developer          Date       Detail                                  Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Ramakrishna Singara 5/7/2013 Initial Development            
    2.0 Ramakrishna Singara 12/30/2013 Enhancement                                            
**************************************************************************************************************************************************/
@isTest

(SeeAllData=true)
private class OpportunityShare_Test{
    
    public static testMethod void MytestTrigger() {
    
        Test.startTest();
        
        // User Record
        Profile p = [SELECT Id FROM Profile WHERE Name='DND Engineering User w/Cost']; 
        
        User u = new User(GIBU__c='Data & Devices', Alias = 'standt', Email='test@testorg.com', EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='tst01@test.com', CSD_Region__c='Taiwan');
        System.runAs(u) {
        
        User u1 = new User(GIBU__c='Data & Devices', Alias = 'standt', Email='tst@testorg.com', EmailEncodingKey='UTF-8', LastName='Tst', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='tst026@test.com', CSD_Region__c='Taiwan');
        User u2 = new User(GIBU__c='Data & Devices', Alias = 'standt', Email='tt@testorg.com', EmailEncodingKey='UTF-8', LastName='Tt', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='tst03@test.com', CSD_Region__c='Taiwan');
        insert u1;
        insert u2; 
        //Account Record types
        Schema.DescribeSObjectResult cfrAccSchema = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> AccountRecordTypeInfo = cfrAccSchema.getRecordTypeInfosByName(); 
        Id CSDAccountrtId = AccountRecordTypeInfo.get('Account').getRecordTypeId();
        Id CSDOEMrtId = AccountRecordTypeInfo.get('OEM').getRecordTypeId();
        
        //Opportunity Record types
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> OpportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id CSDrtId = OpportunityRecordTypeInfo.get('Sales Opportunity-CSD').getRecordTypeId();
        Id DNDId = OpportunityRecordTypeInfo.get('DND Opportunity').getRecordTypeId();
        
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9(); 
        Apex_Helper_Settings__c ahs10 = ClsTestHelp.createTestName10();
        Apex_Helper_Settings__c ahs11 = ClsTestHelp.createTestName11();                
        
        //Account Records
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = CSDAccountrtId;
        //acc.Name = 'Test1';
        acc.ownerId = UserInfo.getUserId();        
        acc.Account_Manager__c =u.id;
        acc.type='TE_01536';
        acc.AccountNumber = '1234:12345678';
        insert acc;
        
        Account acc1 = ClsTestHelp.createTestAccounts();
        acc1.RecordTypeId = CSDOEMrtId;
        acc1.Active__c = true;
       // acc1.Name = 'Test2';
        acc1.ownerId = UserInfo.getUserId(); 
        acc1.Account_Manager__c = u1.id;
        acc.AccountNumber = '1234:12345677';
        acc1.type='TE_01537';
        insert acc1;
        
        Account acc2 = ClsTestHelp.createTestAccounts();
        acc2.RecordTypeId = CSDOEMrtId;
        acc2.Active__c = true;
        //acc2.Name = 'Test3';
        acc2.ownerId = UserInfo.getUserId(); 
        acc2.Account_Manager__c = u2.id;
        acc2.type='TE_01538';
        insert acc2;
        
        //Opportunity Records
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = DNDId;
        opp.Name = 'Test';
        opp.AccountId = acc.id;
        opp.Type = 'New Business';
        opp.Description = 'Test';
        opp.StageName = 'New Opportunity';
        opp.CloseDate = system.today();
        opp.Probability = 0;
        opp.OEM_Name__c = acc1.id;
        opp.Amount = 100;
        opp.Ownerid=u.id;
        opp.Explanation_of_Change__c = 'Test';
        opp.Currency_Confirm__c=true;
        insert opp;
                
        opp.OEM_Name__c = acc2.id;
        update opp;
       }
            
        Test.stopTest();
        
    }
}