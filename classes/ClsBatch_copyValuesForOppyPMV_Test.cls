/**
*  This test class used to test class ClsBatch_copyValuesForOppyPMVFields.
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
private class ClsBatch_copyValuesForOppyPMV_Test {

    static testMethod void myUnitTest() {
    	
        ClsBatch_copyValuesForOppyPMVFields cls = new ClsBatch_copyValuesForOppyPMVFields();
        cls.filter = ' limit 1';
        database.executeBatch(cls);
    }
}