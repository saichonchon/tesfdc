/**
*  This test class is for Cls_batchUtil.
*
@author Bin Yuan
@created 2014-11-28
@version 1.0
@since 20.0
*
@changelog
* 2014-11-28 Bin Yuan <bin.yuan@itbconsult.com>
* - Created
* - Test coverage 85%
*/
@isTest
private class Cls_batchUtil_Test {
	static testMethod void testMostMethods() {
		list<String> list_errorInfo = new list<String>();
		list_errorInfo.add('Test');
		String subject = 'Test';
		Cls_batchUtil.errorReportForBatch(list_errorInfo, subject);
	}
}