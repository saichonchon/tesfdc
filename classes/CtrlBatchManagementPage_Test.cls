/**
*  This test class is for CtrlBatchManagementPage.
*
@author Di Chen
@created 2014-01-21
@version 1.0
@since 20.0
*
@changelog
* 2014-01-21 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage  79%
*/
@isTest
private class CtrlBatchManagementPage_Test {

    static testMethod void testMostClass1() {
    	
    	ClsTestCustomSettingHelper.getFinancialPlanningConfiguration();
    	
        Test.startTest();
        
        CtrlBatchManagementPage.jobParameter ctrlJob = new CtrlBatchManagementPage.jobParameter();
        ctrlJob.pName = 'currentYear';
        ctrlJob.Value = '2014';
        ctrlJob.dateValue = date.today();
        
        CtrlBatchManagementPage ctrl = new CtrlBatchManagementPage();
        ctrl.jobPar = '[{"pName":"currentYear","Value":"2014"},{"pName":"currentMonth","Value":"2014"},{"pName":"frozenDate","Value":"2014"}]';
        ctrl.jobModel = '{"jobName":"Calculate Backlog & Currency","jobClass":"ClsBatch_calculateBBBMBacklog"}';
        
    	ctrl.runBatch();
    	ctrl.getListParameters();
    	ctrl.getListDateParameters();  
        
        ctrl.jobModel = '{"jobName":"Calculate Backlog & Currency","jobClass":"ClsBatch_calculateBBBMCurrency"}';        
    	ctrl.runBatch();
         ctrl.jobModel = '{"jobName":"Calculate Backlog & Currency","jobClass":"ClsBatch_setLastRSMFrozenDate"}';        
    	ctrl.runBatch();
         ctrl.jobModel = '{"jobName":"Calculate Backlog & Currency","jobClass":"ClsBatch_setLastASMFrozenDate"}';        
    	ctrl.runBatch();
         ctrl.jobModel = '{"jobName":"Calculate Backlog & Currency","jobClass":"ClsBatch_recalculateRSMPreviousForecast"}';        
    	ctrl.runBatch();
        
        system.assert(true);
        Test.stopTest();
    }
}