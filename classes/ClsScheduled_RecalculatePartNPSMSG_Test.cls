@isTest(seealldata=false)
private class ClsScheduled_RecalculatePartNPSMSG_Test {
    static testMethod void TestClsScheduled_RecalculatePartNPSMSG()
    {
        test.startTest();
        
        ClsScheduled_RecalculatePartNPSMSG clsSchedule = new ClsScheduled_RecalculatePartNPSMSG();
        string STime ='0 0 23 * * ?';
        system.schedule('Test Schedule1', STime, clsSchedule);
        
        test.stopTest();
    }

}