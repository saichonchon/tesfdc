/**
*   This test class is for ClsAccountTeamUtil.
*
@author Di Chen
@created 2012-11-20
@version 1.0
@since 20.0
*
@changelog
* 2012-11-20 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 
*/
@isTest
private class ClsAccountTeamUtil_Test {

    static testMethod void testMostMethods() {
        ClsTestCustomSettingHelper.getAllSettings();       
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
              
        Account acc = ClsTestHelp.createTestAccounts();  
        acc.Account_Manager__c = null;
        insert acc;
        
        AccountTeamMember aTeamMember = new AccountTeamMember();
        aTeamMember.AccountId = acc.Id;
        aTeamMember.UserId = UserInfo.getUserId();
        insert aTeamMember;
        
        Account_Team__c aTeam = new Account_Team__c();
        aTeam.Account__c = acc.Id;
        aTeam.Role__c = 'Field Engineer (FE)';
        aTeam.Team_Member__c = UserInfo.getUserId();
        insert aTeam;
        
        Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
        sh.Level_7_Territory_Code__c = 'A007357';
        sh.Level_7_Default_Owner__c = UserInfo.getUserId();
        sh.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
        sh.Level_7_Assigned_Users__c = UserInfo.getUserId();
        insert sh;
                
        list<Account_Team__c> list_atm = new list<Account_Team__c>();
        list_atm.add(aTeam);
                
        set<Id> set_accountIds = new set<Id>();
        set_accountIds.add(acc.Id);
        
                
        set<Id> set_userIds = new set<Id>(); 
        set_userIds.add(UserInfo.getUserId());
        
        map<Id, String> map_uId_oppyAccess = new map<Id,String>();
        map_uId_oppyAccess.put(UserInfo.getUserId(),'Read');
        
        map<Id, map<Id, String>> map_acctId_userId_oppyAccess = new map<Id, map<Id, String>>();
        map_acctId_userId_oppyAccess.put(acc.Id,map_uId_oppyAccess);
        
        list<Account> list_acc = new list<Account>();
        list_acc.add(acc);
        
        map<String, list<Account>> map_hierarchyId_listAccts = new map<String, list<Account>>();
        map_hierarchyId_listAccts.put(sh.Id,list_acc);
        
        map<String, list<Account>> map_hierarchyId_listAccts2 = new map<String, list<Account>>();
        map_hierarchyId_listAccts2.put(sh.Id,list_acc);
        
        map<String, Sales_Hierarchy__c> map_hierarchyId_userId = new map<String, Sales_Hierarchy__c>();
        map_hierarchyId_userId.put(sh.Id,sh);
        
        map<String, Sales_Hierarchy__c> map_hierarchyCode_userId = new  map<String, Sales_Hierarchy__c>();
        map_hierarchyCode_userId.put('A007357',sh);
        
        Test.startTest();
        
        ClsAccountTeamUtil.generateStdAcctTeamFromCustomAcctTeam(list_atm);
        ClsAccountTeamUtil.copyCustomAcctTeam(aTeam);
        ClsAccountTeamUtil.updateAcctSharing(set_userIds, map_acctId_userId_oppyAccess);
        ClsAccountTeamUtil.getAccountTeamMember(map_hierarchyId_listAccts, true);
        //ClsAccountTeamUtil.refreshAccountTeamMemberByHierarchyId(map_hierarchyId_listAccts2, map_hierarchyId_userId,new map<Id,string>());
        ClsAccountTeamUtil.refreshAccountTeamMemberByHierarchyCode(map_hierarchyId_listAccts2, map_hierarchyCode_userId, 'Sales Hierarchy (AM)',new map<Id,string>());
        ClsAccountTeamUtil.deleteOldStdAccountTeam(set_accountIds);
        
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void testMostMethods2() {
        Profile p = [Select Id, Name From Profile 
                                    where Name = 'Production Support' 
                                    or Name = 'Service Account' 
                                    or Name ='System Administrator' 
                                    or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'Lion@testCompany999.com';
        u.Alias = 'SF';
        u.ProfileId = p.Id;
        u.CommunityNickname = 'QPS';
        u.IsActive = true;
        insert u;
        
        ClsTestCustomSettingHelper.getAllSettings();       
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
        
        Account acc = ClsTestHelp.createTestAccounts();  
        acc.Account_Manager__c = null;
        insert acc;
        
        AccountTeamMember aTeamMember = new AccountTeamMember();
        aTeamMember.AccountId = acc.Id;
        aTeamMember.UserId = u.Id;
        insert aTeamMember;
        
        Account_Team__c aTeam = new Account_Team__c();
        aTeam.Account__c = acc.Id;
        aTeam.Role__c = 'Field Engineer (FE)';
        aTeam.Team_Member__c = u.Id;
        insert aTeam;
        
        list<Sales_Hierarchy__c> list_sh = new list<Sales_Hierarchy__c>();

            
        for(Integer i = 0 ; i <= 5; i ++){
            Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
            sh.Level_7_Territory_Code__c = 'A007357';
            sh.Level_7_Default_Owner__c = u.Id;
            sh.Level_7_Assigned_Users__c = UserInfo.getUserId();
            sh.Level_7_Assigned_User_Network_Ids__c = 'US030516;US002083';
            list_sh.add(sh);
        }
         Sales_Hierarchy__c sh2 = new Sales_Hierarchy__c();
            sh2.Level_7_Territory_Code__c = 'A007357';
            
            sh2.Level_7_Assigned_Users__c = UserInfo.getUserId();
            //sh2.Level_7_Assigned_User_Network_Ids__c = 'US030516;US002083';
            
        insert sh2;
        insert list_sh;
                
        list<Account> list_acc = new list<Account>();
        list_acc.add(acc); 
        
        map<String, list<Account>> map_hierarchyId_listAccts = new map<String, list<Account>>();
        map_hierarchyId_listAccts.put(list_sh[2].Id,list_acc);
        
        
        Test.startTest();
        
        ClsAccountTeamUtil.getAccountTeamMember(map_hierarchyId_listAccts, true);
        map_hierarchyId_listAccts.clear();
        map_hierarchyId_listAccts.put(sh2.Id,list_acc);
        ClsAccountTeamUtil.getAccountTeamMember(map_hierarchyId_listAccts, true);
        
        system.assert(true);
        Test.stopTest();
    }
    
    
}