@isTest(seealldata=false)
private class SalesTeamUpdated_Test {
    static testMethod void TestSalesTeamUpdated()
    {  
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        
		test.startTest();        
        
        Market__c mkt = new Market__c();
        mkt.Name = 'Test Market';
        mkt.Region__c = 'Mexico';
        
        Market__c mkt1 = new Market__c();
        mkt1.Name = 'Test Market1';
        mkt1.Region__c = 'Mexico';
        insert new List<Market__c>{mkt, mkt1} ; 
            
        Account a = ClsTestHelp.createTestAccounts();
        a.Name = 'Test Account';
        a.Channel_Market__c = mkt.Id;
        a.OwnerId = userinfo.getUserId();
        
        Account a1 = ClsTestHelp.createTestAccounts();
        a1.Name = 'Test Account';
        a1.Channel_Market__c = mkt1.Id;
        a1.OwnerId = userinfo.getUserId();
        
        insert new List<Account>{a, a1};
        
        Sales_Team__c newMember;
        newMember = new Sales_Team__c();
        //newMember.Name = 'John Doe';
        newMember.Market__c = mkt.Id;//a.Channel_Market__c;
        newMember.Team_Member__c = userinfo.getUserId();
        insert newMember;
        
        newMember.Market__c = mkt1.Id;
        update newMember;
        
        newMember.Team_Role__c = 'Distribution Market Manager (DMM)';
        update newMember;
        
        delete newMember;
        
        test.stopTest();
    }
}