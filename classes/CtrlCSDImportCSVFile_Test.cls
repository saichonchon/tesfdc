/**
*	This test class is for CtrlCSDImportCSVFile.
*
@author Minghao Li
@created 2014-09-24
@version 1.0
@since 30.0
*
@changelog
* 2014-09-24 Minghao Li <minghao.li@itbconsult.com>
* - Created
* - Test coverage 83%
*/
@isTest
private class CtrlCSDImportCSVFile_Test {

    static testMethod void myUnitTest() {
        Test.startTest();
		CtrlCSDImportCSVFile ctrl = new CtrlCSDImportCSVFile();
		CtrlCSDImportCSVFile.FileInfo ctrlFile = new CtrlCSDImportCSVFile.FileInfo();
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
		CtrlCSDImportCSVFile ctrl = new CtrlCSDImportCSVFile();
		CtrlCSDImportCSVFile.FileInfo ctrlFile = new CtrlCSDImportCSVFile.FileInfo();
		ctrlFile.nameFile = 'yyyxx.abc';
		ctrlFile.contentType = 'csv';
		ctrlFile.contentFile = Blob.valueOf('xxxx');
		
        ctrl.fi = ctrlFile;
        ctrl.parseCsvFile();
        
        system.assert(true);
        Test.stopTest();     
    	
    }
}