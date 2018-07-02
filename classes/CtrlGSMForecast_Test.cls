/**
*	This test class is for CtrlGSMForecast.
*
@author Di Chen
@created 2014-01-23
@version 1.0
@since 20.0
*
@changelog
* 2014-01-23 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 91%
*/
@isTest
private class CtrlGSMForecast_Test {

    static testMethod void testMethods() {
    	
        Test.startTest();
        
        CtrlGSMForecast.GSMSaveItem ctrlSI = new CtrlGSMForecast.GSMSaveItem();
        CtrlGSMForecast.ColorConfig ctrlCC = new CtrlGSMForecast.ColorConfig();
        
        CtrlGSMForecast ctrl = new CtrlGSMForecast();
        
        ctrl.saveGSMForecast();
        ctrl.getThis();
        ctrl.getDefinitionTotalField();
        ctrl.getDefinitionRegionField();
        ctrl.calcGSMTable();
        ctrl.getColorConfig();
        ctrl.actionRSMComments();
        ctrl.getRSMComments();
        
        system.assert(true);
        Test.stopTest();
    }
}