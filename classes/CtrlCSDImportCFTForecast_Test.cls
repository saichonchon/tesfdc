/**
*   This test class is for CtrlCSDExportCSVFile.
*
@author Minghao Li
@created 2014-09-24
@version 1.0
@since 30.0
*
@changelog
* 2014-09-24 Minghao Li <minghao.li@itbconsult.com>
* - Created
* - Test coverage 76%
* - 02/09/2016 Rajendra <Shahane rajendra.shahane@zensar.com>
* - Modified
* - Class covered : CtrlCSDImportCFTForecast
* - Coverage 88%
*/
@isTest
private class CtrlCSDImportCFTForecast_Test {

    static testMethod void myUnitTest() {
        CtrlCSDImportCFTForecast c = new CtrlCSDImportCFTForecast();
        c.deleteObject();
    }
    
    static testMethod void remoteActionTest() {

        CtrlCSDImportCFTForecast.CustomCFTForecast fc = new CtrlCSDImportCFTForecast.CustomCFTForecast();
        fc.soldToName = '';
        fc.oemName = '';
        fc.partName = '';
        fc.fYear = '2014';
        fc.fMonth = '6';
        fc.qty = 205555;
        fc.list_qty = new list<CtrlCSDImportCFTForecast.CustomCFTForecast>();
        list<CtrlCSDImportCFTForecast.CustomCFTForecast> list_fc = new list<CtrlCSDImportCFTForecast.CustomCFTForecast>();
        list_fc.add(fc);
        insert new CSD_CFT_Forecast__c();
        String q = 'select Id,Sold_To_Number__c,Billing_Region__c,Sold_To_Name__c,Fiscal_Month__c,Fiscal_Year__c,OEM__r.Name,OEM__c,Part__c,Part__r.Name,Quantity__c,LastModifiedDate from CSD_CFT_Forecast__c';
        CtrlCSDImportCFTForecast.runReportData(q);
        CtrlCSDImportCFTForecast.runFilterReportData(q);
        CtrlCSDImportCFTForecast.runAllReportData(q);
        
        CtrlCSDImportCFTForecast.upsertListCFTForecast( Json.serialize(list_fc) );
        
        CtrlCSDImportCFTForecast.CustomCFTFilter oCustomCFTFilter = new CtrlCSDImportCFTForecast.CustomCFTFilter('', '', '');
        fc.accName = '';
        fc.LastModifiedDate = system.today();
        fc.externalKey = '';
        fc.billingRegion = '';
        
        CtrlCSDImportCFTForecast.CustomReport oCustomReport = new CtrlCSDImportCFTForecast.CustomReport('', new list<CtrlCSDImportCFTForecast.CustomCFTForecast>());
        
    }
}