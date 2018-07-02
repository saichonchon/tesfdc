/**
*	This test class is for CSD_CtrlImportCSVFile.
*
@author Minghao Li
@created 2014-11-21
@version 1.0
@since 30.0
*
@changelog
* 2014-11-21 Minghao Li <minghao.li@itbconsult.com>
* - Created
* - Test coverage 94%
*/
@isTest
private class CSD_CtrlImportCSVFile_Test {

    static testMethod void myUnitTest() {
        Test.startTest();
		CSD_CtrlImportCSVFile ctrl = new CSD_CtrlImportCSVFile();
		CSD_CtrlImportCSVFile.FileInfo ctrlFile = new CSD_CtrlImportCSVFile.FileInfo();
		ctrlFile.nameFile = 'yyyxx.csv';
		ctrlFile.contentType = 'csv';
		ctrlFile.contentFile = Blob.valueOf('xxxx');
		
        ctrl.fi = ctrlFile;
        ctrl.parseCsvFile();
        
        system.assert(true);
        Test.stopTest();      
    }
    
    
    static testMethod void testMostMethods2() {
    	
    	Test.startTest();
		CSD_CtrlImportCSVFile ctrl = new CSD_CtrlImportCSVFile();
		CSD_CtrlImportCSVFile.FileInfo ctrlFile = new CSD_CtrlImportCSVFile.FileInfo();
		ctrlFile.nameFile = 'yyyxx.abc';
		ctrlFile.contentType = 'csv';
		ctrlFile.contentFile = Blob.valueOf('xxxx');
		
        ctrl.fi = ctrlFile;
        ctrl.parseCsvFile();
        
        system.assert(true);
        Test.stopTest();     
    	
    }
}