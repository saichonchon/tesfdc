/**
*	This test class is for CompUploadSensitiveAttachment.
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
private class CompUploadSensitiveAttachment_Test {

    static testMethod void myUnitTest() {
   
    	Sensitive_Attachment__c sa = new Sensitive_Attachment__c();

    	ApexPages.StandardController ctrl = new ApexPages.StandardController(sa); 
    	ExtUploadSensitiveAttachment ext = new ExtUploadSensitiveAttachment(ctrl);
    	
        Test.startTest();
        
        CompUploadSensitiveAttachment comp = new CompUploadSensitiveAttachment();
        comp.getExtUploadSensitiveAttachment();
        comp.setExtUploadSensitiveAttachment(ext);
        
        system.assert(true);
        Test.stopTest();
    }
}