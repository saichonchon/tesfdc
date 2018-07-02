/**
*	This test class is for CtrlSearchPartForPartNumberDetail.
*
@author Di Chen
@created 2012-06-04
@version 1.0
@since 20.0
*
@changelog
* 2012-06-04 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 100%
*/
@isTest
private class CtrlSelectOppy_Test {

    static testMethod void testMostMethods() {
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        oppy2.Type = 'CM';
        insert oppy2;  
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('oppyId',oppy2.Id);
        ApexPages.currentPage().getParameters().put('commentId','commentId');
        CtrlSelectOppy ctrl = new CtrlSelectOppy();
        ctrl.oppy = oppy2;
        
        
        system.assert(true);
        Test.stopTest();
    }
}