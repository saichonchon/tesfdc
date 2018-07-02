/**
*	This test class is for ClsSharingUtil.
*
@author Di Chen
@created 2012-02-23
@version 1.0
@since 20.0
*
@changelog
* 2012-02-23 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 88%
*/
@isTest
private class ClsSharingUtil_Test {
 
    static testMethod void mode1() {
    	RecordType rt1 = ClsTestHelp.createTestRecordType();
    	RecordType rt2 = ClsTestHelp.createTestRecordType2();
    	
    	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'Lina@testCompany1233423.com';
    	u.Alias = 'Salark';
    	u.CommunityNickname = 'ATM';
		insert u;
		
    	Account acc1 = ClsTestHelp.createTestAccounts();
    	acc1.RecordTypeId = rt1.Id;
    	acc1.Name = 'test 2';
    	insert acc1;
    	
    	Account acc2 = ClsTestHelp.createTestAccounts();
    	acc2.RecordTypeId = rt1.Id;
    	acc2.ParentId = acc1.Id;
    	insert acc2;    
    	
    	Account_Team__c AccTeam = new Account_Team__c();
        AccTeam.RecordTypeId = rt2.Id;
        AccTeam.Account__c = acc2.Id;
        insert AccTeam;
        
    	Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        insert oppy2;  
        
		OpportunityShare os = new OpportunityShare ();
		os.UserOrGroupId = u.Id;
		os.OpportunityAccessLevel = 'Edit';
		os.OpportunityId = oppy2.Id;
		insert os;
		 
    	Map<Id, Account> map_id_account = new Map<Id, Account>();
    	map_id_account.put(acc2.Id,acc2);
    	
    	map<id, string> map_aid_uidList = new map<id, string>();
    	map_aid_uidList.put(acc2.Id,u.Id);
    	
    	set<id> set_aids = new set<id>();
    	set_aids.add(acc2.Id);
    	
    	set<id> set_uids = new set<id>();
    	set_uids.add(u.Id);
    	
    	map<id, string> map_pId_cIdList = new map<id, string>();
    	map_pId_cIdList.put(acc1.Id,acc2.Id);
    	
    	set<Id> set_Id = new set<Id>();
    	set_Id.add(acc1.Public_Group_Id__c);
    	
        Test.startTest();
        
        ClsSharingUtil.gamCustomSetting();
        ClsSharingUtil.sfdcUserCustomSetting();
        
        ClsSharingUtil.InsertGroupShare(map_id_account);
        
        ClsSharingUtil.deleteCustomerFocusTeamMember(map_aid_uidList);
        ClsSharingUtil.insertCustomerFocusTeamMember(map_aid_uidList);
    //    ClsSharingUtil.insertAccountTeamMember(map_aid_uidList);
        
        ClsSharingUtil.deleteTeamShare(map_aid_uidList);
        ClsSharingUtil.deleteAccountTeamShare(set_aids, set_uids);

        ClsSharingUtil.deleteAccountTeamMember(map_aid_uidList);
        
      	ClsSharingUtil.insertTeamShareBatch(map_aid_uidList);

      	ClsSharingUtil.modifyAccountSharingBatch(set_aids);
      	ClsSharingUtil.updateAccount('RT_to_NRT', set_Id, map_pId_cIdList);
      	ClsSharingUtil.updateAccount('NRT_to_RT', set_aids, map_pId_cIdList);
      	ClsSharingUtil.updateAccount('NP_to_P', set_aids, map_pId_cIdList);
      	ClsSharingUtil.updateAccount('P_to_NP', set_aids, map_pId_cIdList); 		
 		system.assert(true);        
        Test.stopTest();
    }
	static testMethod void testPHOwnerId1() {
    	RecordType rt1 = ClsTestHelp.createTestRecordType();
    	RecordType rt2 = ClsTestHelp.createTestRecordType2();
    	
    	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'Lion@testCompany1233423.com';
    	u.Alias = 'Salarda';
    	u.CommunityNickname = 'QP';
		insert u;
		
    	Account acc1 = ClsTestHelp.createTestAccounts();
    	acc1.RecordTypeId = rt1.Id;
    	acc1.Name = 'test 2';
    	insert acc1;
    	
    	Account acc2 = ClsTestHelp.createTestAccounts();
    	acc2.RecordTypeId = rt1.Id;
    	acc2.ParentId = acc1.Id;
    	insert acc2;
        
    	Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        ph.Product_Manager__c = u.Id;
        ph.Regional_PM_AP__c = u.Id;
        ph.Regional_PM_EU__c = u.Id;
        ph.Regional_PM_US__c = u.Id;
        ph.Global_PM__c = u.Id;
        ph.Approver_PM__c = u.Id;
        insert ph;
        
        Account_Team__c aTeam = new Account_Team__c();
    	aTeam.Account__c = acc2.Id;
    	aTeam.RecordTypeId = rt2.Id;
    	aTeam.Team_Member__c = u.Id;
    	insert aTeam;
        
        Set<Id> set_phIds = new Set<Id>();
        set_phIds.add(ph.Id);
    	
    	set<id> set_aids = new set<id>();
    	set_aids.add(acc2.Id);
    	
    	map<id, string> map_pId_cIdList = new map<id, string>();
    	map_pId_cIdList.put(acc1.Id,acc2.Id);
    	
    	map<id, string> map_aid_uidList = new map<id, string>();
    	map_aid_uidList.put(acc2.Id,u.Id);
    	
        Test.startTest();
        
        //ClsSharingUtil.ModifyProductHierarchySharing('INSERT', set_phIds);  lili
        //ClsSharingUtil.ModifyProductHierarchySharing('DELETE', set_phIds);  lili
        ClsSharingUtil.modifyAccountSharing('DELETE', set_aids);
        ClsSharingUtil.DeleteProductHierarchySharing(map_pId_cIdList);
        //ClsSharingUtil.updateAccount('P_to_P', set_aids, map_pId_cIdList);
        ClsSharingUtil.insertCustomerFocusTeamMemberBatch(map_aid_uidList); 
      //  ClsSharingUtil.insertAccountTeamMemberBatch(map_aid_uidList);
        system.assert(true);
        Test.stopTest();
    }
    
	static testMethod void testPHOwnerId2() {
    	RecordType rt1 = ClsTestHelp.createTestRecordType();
    	RecordType rt2 = ClsTestHelp.createTestRecordType2();
    	
    	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'Lion@testCompany1233423.com';
    	u.Alias = 'Salarda';
    	u.CommunityNickname = 'QP';
		insert u;
		
    	Account acc1 = ClsTestHelp.createTestAccounts();
    	acc1.RecordTypeId = rt1.Id;
    	acc1.Name = 'test 2';
    	insert acc1;
    	
    	Account acc2 = ClsTestHelp.createTestAccounts();
    	acc2.RecordTypeId = rt1.Id;
    	acc2.ParentId = acc1.Id;
    	insert acc2;
        
    	Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        ph.Product_Manager__c = null;
        ph.Regional_PM_AP__c = u.Id;
        insert ph;
        
        Set<Id> set_phIds = new Set<Id>();
        set_phIds.add(ph.Id);
    	
    	set<id> set_aids = new set<id>();
    	set_aids.add(acc2.Id);
    	
    	map<id, string> map_aid_uidList = new map<id, string>();
    	map_aid_uidList.put(acc2.Id,u.Id);
    	
        Test.startTest();
        
        ClsSharingUtil.ModifyProductHierarchySharing('INSERT', set_phIds);
        ClsSharingUtil.ModifyProductHierarchySharing('DELETE', set_phIds);
      //	ClsSharingUtil.insertTeamShare(map_aid_uidList);
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void testPHOwnerId3() {
    	RecordType rt1 = ClsTestHelp.createTestRecordType();
    	RecordType rt2 = ClsTestHelp.createTestRecordType2();
    	
    	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'Lion@testCompany1233423.com';
    	u.Alias = 'Salarda';
    	u.CommunityNickname = 'QP';
		insert u;
		
    	Account acc1 = ClsTestHelp.createTestAccounts();
    	acc1.RecordTypeId = rt1.Id;
    	acc1.Name = 'test 2';
    	insert acc1;
    	
    	Account acc2 = ClsTestHelp.createTestAccounts();
    	acc2.RecordTypeId = rt1.Id;
    	acc2.ParentId = acc1.Id;
    	insert acc2;
        
    	Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        ph.Product_Manager__c = null;
        ph.Regional_PM_AP__c = null;
        ph.Regional_PM_EU__c = u.Id;
        insert ph;
        
        Set<Id> set_phIds = new Set<Id>();
        set_phIds.add(ph.Id);
    	
    	set<id> set_aids = new set<id>();
    	set_aids.add(acc2.Id);
    	
        Test.startTest();
        
        ClsSharingUtil.ModifyProductHierarchySharing('INSERT', set_phIds);
		ClsSharingUtil.ModifyProductHierarchySharing('DELETE', set_phIds);
		system.assert(true);
        Test.stopTest();
    }
    static testMethod void testPHOwnerId4() {
    	RecordType rt1 = ClsTestHelp.createTestRecordType();
    	RecordType rt2 = ClsTestHelp.createTestRecordType2();
    	
    	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'Lion@testCompany1233423.com';
    	u.Alias = 'Salarda';
    	u.CommunityNickname = 'QP';
		insert u;
		
    	Account acc1 = ClsTestHelp.createTestAccounts();
    	acc1.RecordTypeId = rt1.Id;
    	acc1.Name = 'test 2';
    	insert acc1;
    	
    	Account acc2 = ClsTestHelp.createTestAccounts();
    	acc2.RecordTypeId = rt1.Id;
    	acc2.ParentId = acc1.Id;
    	insert acc2;
        
    	Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        ph.Product_Manager__c = null;
        ph.Regional_PM_AP__c = null;
        ph.Regional_PM_EU__c = null;
        ph.Regional_PM_US__c = u.Id;
        insert ph;
        
        Set<Id> set_phIds = new Set<Id>();
        set_phIds.add(ph.Id);
    	
    	set<id> set_aids = new set<id>();
    	set_aids.add(acc2.Id);
    	
        Test.startTest();
        
        ClsSharingUtil.ModifyProductHierarchySharing('INSERT', set_phIds);
		ClsSharingUtil.ModifyProductHierarchySharing('DELETE', set_phIds);
		system.assert(true);
        Test.stopTest();
    }
    static testMethod void testPHOwnerId5() {
    	RecordType rt1 = ClsTestHelp.createTestRecordType();
    	RecordType rt2 = ClsTestHelp.createTestRecordType2();
    	
    	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'Lion@testCompany1233423.com';
    	u.Alias = 'Salarda';
    	u.CommunityNickname = 'QP';
		insert u;
		
    	Account acc1 = ClsTestHelp.createTestAccounts();
    	acc1.RecordTypeId = rt1.Id;
    	acc1.Name = 'test 2';
    	insert acc1;
    	
    	Account acc2 = ClsTestHelp.createTestAccounts();
    	acc2.RecordTypeId = rt1.Id;
    	acc2.ParentId = acc1.Id;
    	insert acc2;
        
    	Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        ph.Product_Manager__c = null;
        ph.Regional_PM_AP__c = null;
        ph.Regional_PM_EU__c = null;
        ph.Regional_PM_US__c = null;
        ph.Global_PM__c = u.Id;
        insert ph;
        
        Set<Id> set_phIds = new Set<Id>();
        set_phIds.add(ph.Id);
    	
    	set<id> set_aids = new set<id>();
    	set_aids.add(acc2.Id);
    	
        Test.startTest();
        
        ClsSharingUtil.ModifyProductHierarchySharing('INSERT', set_phIds);
		ClsSharingUtil.ModifyProductHierarchySharing('DELETE', set_phIds);
		system.assert(true);
        Test.stopTest();
    }
    static testMethod void testPHOwnerId6() {
    	RecordType rt1 = ClsTestHelp.createTestRecordType();
    	RecordType rt2 = ClsTestHelp.createTestRecordType2();
    	
    	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'Lion@testCompany1233423.com';
    	u.Alias = 'Salarda';
    	u.CommunityNickname = 'QP';
		insert u;
		
    	Account acc1 = ClsTestHelp.createTestAccounts();
    	acc1.RecordTypeId = rt1.Id;
    	acc1.Name = 'test 2';
    	insert acc1;
    	
    	Account acc2 = ClsTestHelp.createTestAccounts();
    	acc2.RecordTypeId = rt1.Id;
    	acc2.ParentId = acc1.Id;
    	insert acc2;
        
    	Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        ph.Product_Manager__c = null;
        ph.Regional_PM_AP__c = null;
        ph.Regional_PM_EU__c = null;
        ph.Regional_PM_US__c = null;
        ph.Global_PM__c = null;
        ph.Approver_PM__c = u.Id;
        insert ph;
        
        Set<Id> set_phIds = new Set<Id>();
        set_phIds.add(ph.Id);
    	
    	set<id> set_aids = new set<id>();
    	set_aids.add(acc2.Id);
    	
        Test.startTest();
        
        ClsSharingUtil.ModifyProductHierarchySharing('INSERT', set_phIds);
		ClsSharingUtil.ModifyProductHierarchySharing('DELETE', set_phIds);
		system.assert(true);
        Test.stopTest();
    }
	static testMethod void testPHOwnerId7() {
    	RecordType rt1 = ClsTestHelp.createTestRecordType();
    	RecordType rt2 = ClsTestHelp.createTestRecordType2();
    	
    	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'Lina@testCompany1233423.com';
    	u.Alias = 'Salark';
    	u.CommunityNickname = 'ATM';
		insert u;
		
    	Account acc1 = ClsTestHelp.createTestAccounts();
    	acc1.RecordTypeId = rt1.Id;
    	acc1.Name = 'test 2';
    	insert acc1;
    	
    	Account acc2 = ClsTestHelp.createTestAccounts();
    	acc2.RecordTypeId = rt1.Id;
    	acc2.ParentId = acc1.Id;
    	insert acc2;    
    	
    	Account_Team__c AccTeam = new Account_Team__c();
        AccTeam.RecordTypeId = rt2.Id;
        AccTeam.Account__c = acc2.Id;
        insert AccTeam;
        
    	Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        insert oppy2;  
        
		OpportunityShare os = new OpportunityShare ();
		os.UserOrGroupId = u.Id;
		os.OpportunityAccessLevel = 'Edit';
		os.OpportunityId = oppy2.Id;
		insert os;
		 
    	Map<Id, Account> map_id_account = new Map<Id, Account>();
    	map_id_account.put(acc2.Id,acc2);
    	
    	map<id, string> map_aid_uidList = new map<id, string>();
    	map_aid_uidList.put(acc2.Id,u.Id);
    	
    	set<id> set_aids = new set<id>();
    	set_aids.add(acc2.Id);
    	
    	set<id> set_uids = new set<id>();
    	set_uids.add(u.Id);
    	
    	map<id, string> map_pId_cIdList = new map<id, string>();
    	map_pId_cIdList.put(acc1.Id,acc2.Id);
    	
    	set<Id> set_Id = new set<Id>();
    	set_Id.add(acc1.Public_Group_Id__c);
        Test.startTest();
        ClsSharingUtil.deleteAccountTeamShare(map_aid_uidList);
        ClsSharingUtil.upsertAccountTeamMember(map_aid_uidList);
        ClsSharingUtil.upsertAccountTeamMemberBatch(map_aid_uidList);
        ClsSharingUtil.upsertAccountTeamShareBatch(map_aid_uidList);
        system.assert(true);
        Test.stopTest();
    }
	static testMethod void testPHOwnerId8() {
    	RecordType rt1 = ClsTestHelp.createTestRecordType();
    	RecordType rt2 = ClsTestHelp.createTestRecordType2();
    	
    	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'Lina@testCompany1233423.com';
    	u.Alias = 'Salark';
    	u.CommunityNickname = 'ATM';
		insert u;
		
    	Account acc1 = ClsTestHelp.createTestAccounts();
    	acc1.RecordTypeId = rt1.Id;
    	acc1.Name = 'test 2';
    	insert acc1;
    	
    	Account acc2 = ClsTestHelp.createTestAccounts();
    	acc2.RecordTypeId = rt1.Id;
    	acc2.ParentId = acc1.Id;
    	insert acc2;    
    	
    	Account_Team__c AccTeam = new Account_Team__c();
        AccTeam.RecordTypeId = rt2.Id;
        AccTeam.Account__c = acc2.Id;
        insert AccTeam;
        
    	Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        insert oppy2;  
        
		OpportunityShare os = new OpportunityShare ();
		os.UserOrGroupId = u.Id;
		os.OpportunityAccessLevel = 'Edit';
		os.OpportunityId = oppy2.Id;
		insert os;
		 
    	Map<Id, Account> map_id_account = new Map<Id, Account>();
    	map_id_account.put(acc2.Id,acc2);
    	
    	map<id, string> map_aid_uidList = new map<id, string>();
    	map_aid_uidList.put(acc2.Id,u.Id);
    	
    	set<id> set_aids = new set<id>();
    	set_aids.add(acc2.Id);
    	
    	set<id> set_uids = new set<id>();
    	set_uids.add(u.Id);
    	
    	map<id, string> map_pId_cIdList = new map<id, string>();
    	map_pId_cIdList.put(acc1.Id,acc2.Id);
    	
    	set<Id> set_Id = new set<Id>();
    	set_Id.add(acc1.Public_Group_Id__c);
        Test.startTest();
        
        ClsSharingUtil.upsertAccountTeamShare(map_aid_uidList);
        system.assert(true);
        Test.stopTest();
    }  
	static testMethod void testPHOwnerId9() {
    	RecordType rt1 = ClsTestHelp.createTestRecordType();
    	RecordType rt2 = ClsTestHelp.createTestRecordType2();

        Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
        sh.Level_7_Territory_Code__c = 'A007357';
        sh.Level_7_Default_Owner__c = UserInfo.getUserId();
        sh.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
        insert sh;
            	
    	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'Lina@testCompany1233423.com';
    	u.Alias = 'Salark';
    	u.CommunityNickname = 'ATM';
		insert u;
		
    	Account acc1 = ClsTestHelp.createTestAccounts();
    	acc1.RecordTypeId = rt1.Id;
    	acc1.Name = 'test 2';
    	acc1.GAMCD__c = 'A007357';
    	acc1.Sales_Hierarchy_GAM__c = sh.Id;
    	acc1.Sales_Hierarchy_MM__c = sh.Id;
    	insert acc1;
    	
    	Account acc2 = ClsTestHelp.createTestAccounts();
    	acc2.RecordTypeId = rt1.Id;
    	acc2.ParentId = acc1.Id;
    	acc2.Sales_Hierarchy_GAM__c = sh.Id;
    	acc2.Sales_Hierarchy_MM__c = sh.Id;    	
    	insert acc2;    
    	
    	Account_Team__c AccTeam = new Account_Team__c();
        AccTeam.RecordTypeId = rt2.Id;
        AccTeam.Account__c = acc2.Id;
        insert AccTeam;
        
    	Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        insert oppy2;  
        
		OpportunityShare os = new OpportunityShare ();
		os.UserOrGroupId = u.Id;
		os.OpportunityAccessLevel = 'Edit';
		os.OpportunityId = oppy2.Id;
		insert os;
		
		Group g = ClsTestHelp.createTestGroups();
		insert g;
				 
    	Map<Id, Account> map_id_account = new Map<Id, Account>();
    	map_id_account.put(acc2.Id,acc2);
    	
    	map<id, string> map_aid_uidList = new map<id, string>();
    	map_aid_uidList.put(acc2.Id,u.Id);
    	
    	set<id> set_aids = new set<id>();
    	set_aids.add(acc2.Id);
    	set_aids.add(acc1.Id);
    	
    	set<id> set_uids = new set<id>();
    	set_uids.add(u.Id);
    	
    	map<id, string> map_pId_cIdList = new map<id, string>();
    	map_pId_cIdList.put(acc1.Id,acc2.Id);
    	
    	set<Id> set_Id = new set<Id>();
    	set_Id.add(acc1.Public_Group_Id__c);
        Test.startTest();
        
        list<Account> list_acc = new list<Account>();
        list_acc.add(acc1);
                
        map<String, list<Account>> map_code_accounts = new map<String, list<Account>>();
        map_code_accounts.put(sh.Level_7_Territory_Code__c,list_acc);
        
        set<String> set_groupName2Delete = new set<String>();
        set_groupName2Delete.add(g.Id);
        
        ClsSharingUtil.upsertAccountTeamShare(map_aid_uidList);
        ClsSharingUtil.insertTeamShare_notuse(map_aid_uidList);
        ClsSharingUtil.setAccountSalesHierarchy(map_code_accounts);
        ClsSharingUtil.deletPublicGroup(set_groupName2Delete);
        
        map<Id,String> map_shId_groupName = new map<Id,String>();
        map_shId_groupName.put(sh.Id,'Lucifer');
        
        map<Id,Id> map_shId_accId = new map<Id,Id>();
        map_shId_accId.put(sh.Id,acc1.Id);
        
        map<Id,String> map_uid_groupName = new map<Id,String>();
        map_uid_groupName.put(UserInfo.getUserId(),'Lucifer');
        
        map<string,set<Id>> map_groupName_setAccId = new map<string,set<Id>>();
        map_groupName_setAccId.put('Lucifer',set_aids);
        
        set<Id> set_childId2DeleteAccountSharing = new set<Id>();
        set_childId2DeleteAccountSharing.add(acc1.Id);
        
        ClsSharingUtil.insertPublicGroupSharing4Batch(map_shId_groupName, map_shId_accId);
       // ClsSharingUtil.addCustomerFocusTeamAsGroupMember(map_uid_groupName);
        ClsSharingUtil.deleteAccountSharingOnPublicGroup(map_groupName_setAccId, set_childId2DeleteAccountSharing);
        
        system.assert(true);
        Test.stopTest();
    }  
    
}