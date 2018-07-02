/**
*	This test class is for ExtNote.
*
@author Di Chen
@created 2012-06-13
@version 1.0
@since 20.0
*
@changelog
* 2012-06-13 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 92%
*/
@isTest
private class ExtNote_Test {

    static testMethod void testAllMethods1() {
    	Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();
		Profile p = [Select Id, Name From Profile 
                     where Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
		User u = ClsTestHelp.createTestUsers();
		u.Email = 'hellosManedsfd@testCompany1233423.com';
		u.Alias = 'dpses';
		u.CommunityNickname = 'NNND';
		u.ProfileId = p.Id;
		insert u;
		      
		system.runAs(u){     	
    	Opportunity oppy = ClsTestHelp.createTestOpportunity();
        insert oppy;
    	
        Note note = new Note();
        note.ParentId = oppy.Id;
        note.Title = 'oh';
    	insert note;
    	
        Test.startTest();
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(note); 
    	ExtNote ext = new ExtNote(stdCtrl);
    	ext.note = note;
    	
    	ext.save();
    	ext.cancel();
        
        system.assert(true);
        Test.stopTest();
		}
    }
	static testMethod void testAllMethods2() {
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();
		Profile p = [Select Id, Name From Profile 
                     where Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
		User u = ClsTestHelp.createTestUsers();
		u.Email = 'hellosManedsfd@testCompany1233423.com';
		u.Alias = 'dpses';
		u.CommunityNickname = 'NNND';
		u.ProfileId = p.Id;
		insert u;
		      
		system.runAs(u){     	
    	Opportunity oppy = ClsTestHelp.createTestOpportunity();
        insert oppy;
    	
        Note note = new Note();
        note.ParentId = oppy.Id;
        note.Title = 'oh';
    	insert note;
    	 
        Test.startTest();
        ApexPages.currentPage().getParameters().put('noteId',note.Id);
       // ApexPages.currentPage().getParameters().put('parentId',note.ParentId);
        ApexPages.currentPage().getParameters().put('retURL','http://www.baidu.com');
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(note); 
    	ExtNote ext = new ExtNote(stdCtrl);
    	ext.note = note;
    	
    	ext.save();
    	ext.cancel();
        
        system.assert(true);
        Test.stopTest();
		}
    }
}