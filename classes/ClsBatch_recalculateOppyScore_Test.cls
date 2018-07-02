/**
*  This test class used to test class ClsBatch_recalculateOppyScore.
*
@author Jinbo Shan
@created 2014-06-25
@version 1.0   
@since 29.0
*
@changelog
* coverage  86%
* 
* 
2014-06-25 Jinbo Shan <weihang.li@itbconsult.com>
* - Created
*/
@isTest(SeeAllData = true)
private class ClsBatch_recalculateOppyScore_Test {

    static testMethod void myUnitTest() {
        ClsBatch_recalculateOppyScore cls = new ClsBatch_recalculateOppyScore();
        cls.filter = ' limit 1';
        database.executeBatch(cls);
    }
}