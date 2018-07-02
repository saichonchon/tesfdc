@istest
public class ClsBatch_fetchSIPReportResult_test
{
    static testmethod void ClsBatch_fetchSIPReportResult_TM()
    {
        Test.startTest();
        //Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
            //ClsTestCustomSettingHelper.getSIP_Sharing_Setting();
            ClsBatch_fetchSIPReportResult o = new ClsBatch_fetchSIPReportResult();
            
            database.executebatch(o);
            Database.BatchableContext BC;
            o.execute(BC, new list<SIP__c>{new SIP__c(SIP_Report_Instance__c = 'test')});
        Test.stoptest();        
    }
}