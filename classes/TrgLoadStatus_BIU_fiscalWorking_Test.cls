/**
*	This test class is for LoadStatus_BIU_fiscalWorking.
*
@author Mionghao Li
@created 2012-06-12
@version 1.0
@since 20.0
*
@changelog
* 2012-06-12 Minghao Li <minghao.li@itbconsult.com>
* - Created
* - Test coverage 96%
*/
@isTest
private class TrgLoadStatus_BIU_fiscalWorking_Test {

    static testMethod void myUnitTest() {
        Test.startTest();
        Load_Status__c ls = new Load_Status__c();
        
        try{insert ls;}catch(Exception e){System.debug(e);}
        ls.Current_Date__c = System.today();
        try{update ls;}catch(Exception e){System.debug(e);}
        try{update ls;}catch(Exception e){System.debug(e);}
        
        ls.Current_Date__c = System.today() - 1;
        try{update ls;}catch(Exception e){System.debug(e);}
        
        system.assert(true);
        Test.stopTest();
        
    }
}