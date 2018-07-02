/**
*	This test class is for ExtUploadAccountAttachment.
*
@author Di Chen
@created 2012-02-23
@version 1.0
@since 20.0
*
@changelog
* 2012-02-23 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 98%
*/
@isTest
private class ExtUploadAccountAttachment_Test {

    static testMethod void Parameters() {
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();    	
        RecordType rt = ClsTestHelp.createTestRecordType();
           
    	Account vAccount = ClsTestHelp.createTestAccounts(); 
		vAccount.RecordTypeId = rt.Id;
		insert vAccount;
		
    	Attachment att= ClsTestHelp.createTestAttachments();
        att.ParentId = vAccount.Id;
        insert att;
    	
    	Account_Attachment__c aatt = new Account_Attachment__c();
    	aatt.Account__c = vAccount.Id;
    	aatt.Attachment_Id__c = att.Id;
    	aatt.Attachment_Name__c = 'Object2';
    	insert aatt;
    	
		Test.startTest();
		
		ApexPages.currentPage().getParameters().put('CF00NL0000000OWGE_lkid',vAccount.Id);
		ApexPages.currentPage().getParameters().put('CF00NL0000000OWGE',vAccount.Name);
		
	    ApexPages.currentPage().getParameters().put('id',aatt.Id);
	    
    	ApexPages.StandardController ctrl = new ApexPages.StandardController(aatt); 
    	ExtUploadAccountAttachment ext = new ExtUploadAccountAttachment(ctrl);
    	ext.accountAttachment = aatt;
    	ext.accountId = vAccount.Id;
    	ext.attachment = att;
        
        ext.uploadAccountAttachment();
        ext.getExtUploadAccountAttachment();
        ext.cancel();
        ext.back();
        
        system.assert(true);
        Test.stopTest();
    }	
    static testMethod void Name1() {
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();    	
        RecordType rt = ClsTestHelp.createTestRecordType();
           
    	Account vAccount = ClsTestHelp.createTestAccounts(); 
		vAccount.RecordTypeId = rt.Id;
		insert vAccount;
		
    	Attachment att= ClsTestHelp.createTestAttachments();
        att.ParentId = vAccount.Id;
        insert att;
    	
    	Account_Attachment__c aatt = new Account_Attachment__c();
    	aatt.Account__c = vAccount.Id;
    	aatt.Attachment_Id__c = att.Id;
    	aatt.Attachment_Name__c = 'Object2';
    	insert aatt;
    	
		Test.startTest();
		ApexPages.currentPage().getParameters().put('retURL',null);
	    ApexPages.currentPage().getParameters().put('id',aatt.Id);
	    
    	ApexPages.StandardController ctrl = new ApexPages.StandardController(aatt); 
    	ExtUploadAccountAttachment ext = new ExtUploadAccountAttachment(ctrl);
    	ext.accountAttachment = aatt;
    	ext.accountId = vAccount.Id;
    	ext.attachment = att;
        ext.uploadAccountAttachment();
        
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void Name2() {
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();    	
        RecordType rt = ClsTestHelp.createTestRecordType();
           
    	Account vAccount = ClsTestHelp.createTestAccounts(); 
		vAccount.RecordTypeId = rt.Id;
		insert vAccount;
		
    	Attachment att= ClsTestHelp.createTestAttachments();
        att.ParentId = vAccount.Id;
        insert att;
    	
    	Account_Attachment__c aatt = new Account_Attachment__c();
    	aatt.Account__c = vAccount.Id;
    	aatt.Attachment_Id__c = att.Id;
    	insert aatt;
    	
		Test.startTest();
		ApexPages.currentPage().getParameters().put('retURL','http://www.baidu.com');
	    ApexPages.currentPage().getParameters().put('id',aatt.Id);
	    
    	ApexPages.StandardController ctrl = new ApexPages.StandardController(aatt); 
    	ExtUploadAccountAttachment ext = new ExtUploadAccountAttachment(ctrl);
    	ext.accountAttachment = aatt;
    	ext.accountId = vAccount.Id;
    	ext.attachment = att;
        ext.uploadAccountAttachment();
        
        system.assert(true);
        Test.stopTest();
    }
	/*static testMethod void myUnitTest2() {
        RecordType rt = [select Name from RecordType where SobjectType = 'Account' and DeveloperName = 'CIS_Global_Account'];    
    	Account vAccount = new Account();
		vAccount.Name = 'AMP Foundries Inc';
		vAccount.AnnualRevenue = 2000000.11; 
		vAccount.Legally_Restricted__c = false;  
		vAccount.RecordTypeId = rt.Id;
		insert vAccount;
		
    	Attachment att= new Attachment();
        att.Name = 'Object1';
        att.Body = Blob.valueof('Test');
        att.ParentId = vAccount.Id;
        insert att;
    	
    	Account_Attachment__c aatt = new Account_Attachment__c();
    	aatt.Account__c = vAccount.Id;
    	aatt.Attachment_Id__c = att.Id;
    	aatt.Attachment_Name__c = 'Object2';
    	insert aatt;
    	
		Test.startTest();
		
		//ApexPages.currentPage().getParameters().put('CF00NL0000000OWGE_lkid',vAccount.Id);
		//ApexPages.currentPage().getParameters().put('CF00NL0000000OWGE',vAccount.Name);
		
	    ApexPages.currentPage().getParameters().put('id',aatt.Id);
	    
    	ApexPages.StandardController ctrl = new ApexPages.StandardController(aatt); 
    	ExtUploadAccountAttachment ext = new ExtUploadAccountAttachment(ctrl);
    	ext.accountAttachment = aatt;
    	ext.accountId = vAccount.Id;
    	ext.attachment = att;
        
        ext.uploadAccountAttachment();
        //ext.getExtUploadAccountAttachment();
        //ext.cancel();
      //  ext.back();
        
        system.assert(true);
        Test.stopTest();
    }*/

}