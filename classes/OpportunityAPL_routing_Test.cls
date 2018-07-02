@isTest(seeAllData = false)   
private class OpportunityAPL_routing_Test {
    static testMethod void myUnitAMTest()
    {
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        ClsTestCustomSettingHelper.getAplRoutingProcess();
        ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
        ClsTestCustomSettingHelper.getPMV_Sales_Stage_Setting();
        ClsTestCustomSettingHelper.getPMV_Stage_Config();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
        
        
        
       // User user = [select id from user where GIBU__c = 'Industrial' and  Sub_Vertical__c = 'A&C' and isactive = true limit 1];
         Profile p = [SELECT Name, Id FROM Profile where Name in('Appliance Engineering User w/Cost','Appliance Standard User','Appliance User w/ Cost') limit 1];
        
        User user1 = new User();
        user1.FirstName ='FirstName';
        user1.LastName = 'TesterName';
        user1.Email = 'testme@teatmail.com';
        user1.Alias = 'SFFH';
        user1.ProfileId = p.Id;
        user1.CommunityNickname = 'ASD';
        user1.IsActive = true;
        user1.Username = user1.Email+'2';
        user1.TimeZoneSidKey = 'America/Chicago';
        user1.LocaleSidKey = 'en_US';
        user1.EmailEncodingKey = 'UTF-8';
        user1.LanguageLocaleKey = 'en_US';
        insert user1;
        
        system.runAs(user1)
        {
            //ID oRTid = (Id)AplRoutingProcess__c.getInstance('Opportunity - Engineering Project').Record_Type_Id__c;
            ID oRTid = (Id)AplRoutingProcess__c.getInstance('Opportunity - Product Platform').Record_Type_Id__c;
            test.startTest();
            
            RecordType rt = ClsTestHelp.createTestRecordType14();
            
            Account acc = ClsTestHelp.createTestAccounts();
            acc.RecordTypeId = rt.Id;
            acc.Type = 'Global Account';
            acc.Industry_Code_Description__c = 'Appliances';
            acc.LEVEL_1_INDUSTRY_CDE__c = '0283';
            acc.ownerId = userinfo.getUserId();
            acc.Account_Manager__c = userinfo.getUserId();
            insert acc;
            
            Opportunity oppy = new Opportunity(Account = acc,AccountId = acc.Id,CloseDate = date.today().addDays(5),Is_approved_Regional_Sales_Director__c = false, recordtypeid = oRTid, name = 'Pain of Queen', StageName = 'New', Type = 'CM', Request_Type__c = 'Extension', Method__c = 'BOM', Level__c = 'Yearly', Amount = 1, Five_Year_Revenue__c = 1, Currency_Confirm__c = true);
            insert oppy;
            
            oppy.Is_approved_Regional_Sales_Director__c = true;
            oppy.APL_ENG_routing_Process__c = null;
            oppy.APL_Billing_Share_1__c='100';
            oppy.APL_Billing_Share_2__c='100';
            update oppy;
            
            
            test.stopTest();
        }
    }
}