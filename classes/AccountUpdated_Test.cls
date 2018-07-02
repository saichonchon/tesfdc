@isTest(seeAllData = false)   
private class AccountUpdated_Test {
	static testMethod void TestAccountUpdated()
    {
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        test.startTest();
        
        Global_Account__c TestGAM = new Global_Account__c();
        TestGAM.Name = 'Test GAM' + String.valueOf(Date.today());
         Global_Account__c TestGAM1 = new Global_Account__c();
        TestGAM1.Name = 'Test GAM' + String.valueOf(Date.today());
        insert new List<Global_Account__c>{TestGAM, TestGAM1};
            
        Market__c mrkt = new Market__c(Name='Test',Pricebook_Id__c=test.getStandardPricebookId());
        Market__c mrkt1 = new Market__c(Name='Test',Pricebook_Id__c=test.getStandardPricebookId());
        insert new List<Market__c>{mrkt, mrkt1};
        
        RecordType rt = ClsTestHelp.createTestRecordType();
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt.Id;
        acc.Global_Account__c = TestGAM.Id;
        acc.Channel_Market__c = mrkt1.Id;
        acc.Account_Manager__c = UserInfo.getUserId();
        insert acc;
        
        
        
        Customer_Focus_Team_Member__c cftm = new Customer_Focus_Team_Member__c();
        cftm.Global_Account_Lkp__c = acc.Id;
        cftm.Global_Account__c = TestGAM.Id;
        cftm.Salesforce_User_Name__c = UserInfo.getUserId();
        
        Customer_Focus_Team_Member__c cftm1 = new Customer_Focus_Team_Member__c();
        cftm1.Global_Account_Lkp__c = acc.Id;
        cftm1.Global_Account__c = TestGAM1.Id;
        cftm1.Salesforce_User_Name__c = UserInfo.getUserId();
        insert new List<Customer_Focus_Team_Member__c> {cftm, cftm1};
        
        Sales_Team__c STMember = new Sales_Team__c();
        STMember.Market__c = mrkt1.Id;
        STMember.Team_Member__c = userinfo.getUserId();
        
        Sales_Team__c STMember1 = new Sales_Team__c();
        STMember1.Market__c = mrkt.Id;
        STMember1.Team_Member__c = userinfo.getUserId();
        insert new List<Sales_Team__c> {STMember, STMember1};
        
        //acc.Channel_Market__c = mrkt.Id;
        acc.Global_Account__c = TestGAM1.Id;
        update acc;
        
        acc.Channel_Market__c = mrkt.Id;
        //acc.Global_Account__c = TestGAM1.Id;
        update acc;
        
        test.stopTest();
    }
}