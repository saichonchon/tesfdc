/**
for trigger opportunity_AIAU_AddOpptyTeam
**/
@isTest(SeeAllData=false)
private class opportunity_AIAU_AddOpptyTeamTest {

    static testMethod void myUnitTest() {
        Test.startTest();
        
        // User Record
        Profile p = [SELECT Id FROM Profile WHERE Name='DND Engineering User w/Cost']; 
        
        User u = [Select Id,UserName from User Where Id !=:UserInfo.getUserId() and IsActive = true and Profile.Name='DND Engineering User w/Cost' LIMIT 1];

        System.runAs(u) {
        }
        User u1 = new User();
        u1.GIBU__c='Consumer Devices'; 
        u1.Alias = 'standt'; 
        u1.Email='tst@testorg.com'; 
        u1.EmailEncodingKey='UTF-8'; 
        u1.LastName='Tst'; 
        u1.LanguageLocaleKey='en_US'; 
        u1.LocaleSidKey='en_US'; 
        u1.ProfileId = p.Id; 
        u1.TimeZoneSidKey='America/Los_Angeles'; 
        u1.UserName='tst02611@test.com'; 
        u1.CSD_Region__c='Taiwan';
        
        User u2 = new User();
        u2.GIBU__c='Consumer Devices'; 
        u2.Alias = 'standt'; 
        u2.Email='tt@testorg.com'; 
        u2.EmailEncodingKey='UTF-8'; 
        u2.LastName='Tt'; 
        u2.LanguageLocaleKey='en_US'; 
        u2.LocaleSidKey='en_US'; 
        u2.ProfileId = p.Id; 
        u2.TimeZoneSidKey='America/Los_Angeles'; 
        u2.UserName='tst0311@test.com'; 
        u2.CSD_Region__c='Taiwan';
        
        insert new List<User> {u1,u2}; 
        //Account Record types
        Schema.DescribeSObjectResult cfrAccSchema = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> AccountRecordTypeInfo = cfrAccSchema.getRecordTypeInfosByName(); 
        Id CSDAccountrtId = AccountRecordTypeInfo.get('Account').getRecordTypeId();
        Id CSDOEMrtId = AccountRecordTypeInfo.get('OEM').getRecordTypeId();
        
        //Opportunity Record types
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> OpportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id CSDrtId = OpportunityRecordTypeInfo.get('Sales Opportunity-CSD').getRecordTypeId();
        Id EnggrtId = OpportunityRecordTypeInfo.get('Engineering Opportunity-CSD').getRecordTypeId();
        
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        Channelinsightdata_test.Channelinsightdata_test();
        account a = clstesthelp.createTestAccounts();
        a.AccountNumber ='0000:00000000';
        a.WWCORPACCT__c ='00000000';
        a.BillingCountry='CN';
        //a.name ='Test Account One';
        a.Account_Manager__c = UserInfo.getUserId();
        a.OwnerId = UserInfo.getUserId();
        
        insert a;
        
        List<Opportunity> oppList = new List<Opportunity>();
        //Opportunity Records
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = CSDrtId;
        opp.Name = 'Test';
        opp.AccountId = a.id;
        opp.Type = 'New Business';
        opp.Description = 'Test';
        opp.currency_confirm__c = true;
        opp.StageName = 'New';
        opp.CloseDate = system.today();
        opp.Probability = 0;
        opp.OEM_Name__c = a.id;
        opp.Amount = 100;
        opp.Ownerid=u1.id;
        opp.Explanation_of_Change__c = 'Test';
        opp.currency_confirm__c= true;
        oppList.add(opp);
        
        Opportunity opp1 = new Opportunity();
        opp1.RecordTypeId = CSDrtId;
        opp1.Name = 'Test1';
        opp1.AccountId = a.id;
        opp1.Type = 'New Business';
        opp1.Description = 'Test';
        opp1.StageName = 'New';
        opp1.currency_confirm__c = true;
        opp1.CloseDate = system.today();
        opp1.Probability = 0;
        opp1.OEM_Name__c = a.id;
        opp1.Amount = 100;
        opp1.Ownerid=u1.id;
        opp1.Explanation_of_Change__c = 'Test';
        opp1.currency_confirm__c = true;
        oppList.add(opp1);
        
        insert oppList;
        
        List<Opportunity> oppList1 = new List<Opportunity>();
        opp.OwnerId = u2.Id;
        opp1.OwnerId = u2.Id;
        
        oppList1.add(opp);
        oppList1.add(opp1);
        update oppList1;
        
        Test.stopTest();
    }
}