/**
*  This class is test class for CFTTeamMemberUpdated trigger.
*
@author Rajendra Shahane
@created 8/17/2015
@version 1.0   
@since 34.0
*
@changelog
* coverage  93%
* 
* 
8/17/2015 Rajendra Shahane rajendra.shahane@zensar.in
* - Created
*/
@isTest(seeAllData=false)
private class CFTTeamMemberUpdated_Test {
    static testmethod void testCFTTeamMemberUpdated()
    {
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();       
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();     
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();

        Global_Account__c TestGAM = new Global_Account__c();
        TestGAM.Name = 'Test GAM' + String.valueOf(Date.today());
        insert TestGAM;
        
        RecordType rt = ClsTestHelp.createTestRecordType();
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt.Id;
        acc.Global_Account__c = TestGAM.Id;
        acc.Account_Manager__c = UserInfo.getUserId();
        insert acc;
        
        Profile p = [Select Id, Name From Profile 
                                where Name = 'Channel Standard User' 
                                or Name = 'Service Account' 
                                or Name ='System Administrator' 
                                or Name ='Systemadministrator' limit 1];
          User u = ClsTestHelp.createTestUsers();
          u.Email = 'pol@testCompany1233423.com';
          u.Alias = 'pol';
          u.CommunityNickname = 'pol';
          u.ProfileId = p.Id;
          insert u;
        
        test.startTest();
        
        List<Customer_Focus_Team_Member__c> lstCFTM = new List<Customer_Focus_Team_Member__c>();
        
        Customer_Focus_Team_Member__c cftm = new Customer_Focus_Team_Member__c();
        cftm.Global_Account_Lkp__c = acc.Id;
        cftm.Global_Account__c = TestGAM.Id;
        cftm.Salesforce_User_Name__c = UserInfo.getUserId(); 
        lstCFTM.add(cftm);
        
        Customer_Focus_Team_Member__c cftm1 = new Customer_Focus_Team_Member__c();
        cftm1.Global_Account_Lkp__c = acc.Id;
        cftm1.Global_Account__c = TestGAM.Id;
        cftm1.Salesforce_User_Name__c = UserInfo.getUserId(); 
        lstCFTM.add(cftm1);
        
        insert lstCFTM;
        
        cftm1.Salesforce_User_Name__c = U.Id;
        update cftm1;
        
        delete lstCFTM;
        
        test.stopTest();
    }

}