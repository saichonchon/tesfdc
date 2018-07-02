/**
*  This test class used to test class ClsBatch_copyValuesForPMVFields.
*
@author Jinbo Shan
@created 2014-06-25
@version 1.0   
@since 29.0
*
@changelog
* coverage  90%
* 
* 
2014-06-25 Jinbo Shan <jinbo.shan@itbconsult.com>
* - Created
*/
@isTest(SeeAllData = true)
private class ClsBatch_copyValuesForPMVFields_Test {

    static testMethod void myUnitTest() {
        ClsBatch_copyValuesForPMVFields cls = new ClsBatch_copyValuesForPMVFields();
        cls.filter = ' limit 1';
        database.executeBatch(cls);
        
    }
}