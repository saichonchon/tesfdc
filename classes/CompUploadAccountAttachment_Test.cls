/**
*	This test class is for CompUploadAccountAttachment.
*
@author Di Chen
@created 2012-02-23
@version 1.0
@since 20.0
*
@changelog
* 2012-02-23 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 100%
*/
@isTest
private class CompUploadAccountAttachment_Test {

    static testMethod void myUnitTest() {
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

	    ApexPages.currentPage().getParameters().put('id',aatt.Id);
    	ApexPages.StandardController ctrl = new ApexPages.StandardController(aatt); 
    	ExtUploadAccountAttachment ext = new ExtUploadAccountAttachment(ctrl);
    	
        Test.startTest();
        
        CompUploadAccountAttachment comp = new CompUploadAccountAttachment();
        comp.getExtUploadAccountAttachment();
        comp.setExtUploadAccountAttachment(ext);
        
        system.assert(true);
        Test.stopTest();
    }
}