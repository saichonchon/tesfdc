@isTest
private class Case_CloneVF_Controller_Test {
    static testMethod void TestCase_CloneVF_Controller()
    {
        test.startTest();
            Apexpages.currentPage().getHeaders().put('id', UserInfo.getUserID());
            ApexPages.standardController BC;
            Case_CloneVF_Controller objCls = new Case_CloneVF_Controller(BC);
            objCls.CloneCase();        
        test.stopTest();        
    }

}