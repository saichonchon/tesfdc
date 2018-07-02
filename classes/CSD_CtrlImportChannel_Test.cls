/**
*  This test class used to test class CSD_CtrlImportChannel.
*
@author Lili Zhao
@created 2015-06-18
*
@changelog
* coverage  80%
*  
2015-06-18 Lili Zhao <lili.zhao@itbconsult.com>
* - Created

 * - 02/09/2016 Rajendra <Shahane rajendra.shahane@zensar.com>
* - Modified for project DND Forecast Tool Enhancement 2
* - Coverage 85%
 */
@isTest
private class CSD_CtrlImportChannel_Test {

    static testMethod void myUnitTest() {
        
        
        Test.startTest();
        
        CSD_CtrlImportChannel importChannel = new CSD_CtrlImportChannel();
        CSD_CtrlImportChannel.ExceptionObj ce = new CSD_CtrlImportChannel.ExceptionObj('test', 1);
        
        list<CSD_CtrlImportChannel.CustomChannel> list_fc = new list<CSD_CtrlImportChannel.CustomChannel>();
        CSD_CtrlImportChannel.CustomChannel c = new CSD_CtrlImportChannel.CustomChannel();
        c.oemname = 'test';
        c.oemId = 'test';
        c.fYear = '2015';
        c.fMonth = '6';
        c.forecast = 21;
        c.billingregion = 'test';
        c.index = 0;
        
        CSD_CtrlImportChannel.CustomChannel c1 = new CSD_CtrlImportChannel.CustomChannel();
        c1.oemname = '';
        c1.oemId = '';
        c1.fYear = '2015';
        c1.fMonth = '6';
        c1.forecast = 21;
        c1.billingregion = '';
        c1.index = 0;
        c1.list_fc = new list<CSD_CtrlImportChannel.CustomChannel>();
        list<CSD_CtrlImportChannel.CustomChannel> lst = c1.list_fc;
        list_fc.add(c1);
        
        CSD_CtrlImportChannel.upsertListObject( JSON.serialize(list_fc) );
        insert new CSD_Channel_Forecast__c();
        importChannel.deleteObject();
        
        
        Test.stopTest();
    }
}