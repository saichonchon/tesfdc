@isTest(seeAllData=false)
private class OpportunityPartAPLeditController_Test {
    static testMethod void TestOpportunityPartAPLeditController()
    {
        Apex_Helper_Settings__c hlpSetting = new Apex_Helper_Settings__c (name = 'GIBU of Applience', Value__c = 'test11');
        insert hlpSetting;
        test.starttest();
        
        OpportunityPartAPLeditController objCls = new OpportunityPartAPLeditController(new ApexPages.standardController(New Opportunity()));
        objCls.vOpptyPart = new Opportunity_Part__c();
        objCls.Redir();
        User currentUser = [select Id, GIBU__c from User where Id =: UserInfo.getUserId()];
        hlpSetting.value__c = currentUser.GIBU__c;
        update hlpSetting;
        objCls.Redir();

        test.stoptest();
    }

}