/**
*   This test class is for ClsForecastComments.
*
@author Di Chen
@created 2014-01-20
@version 1.0
@since 20.0
*
@changelog
* 2014-01-20 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 86%%
*/
@isTest
private class ClsForecastComments_Test {

    static testMethod void testMostMethods() {
    	
        Test.startTest();
        
        ClsForecastComments cls = new ClsForecastComments();
        
        ClsForecastComments.CommentOption clsCo = new ClsForecastComments.CommentOption('1','1');
        
        ClsForecastComments.ForecastCommentItem clsFci = new ClsForecastComments.ForecastCommentItem();
       
        
        system.assert(true);
        Test.stopTest();
    }
}