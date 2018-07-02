@isTest
private class CopyNDROpportunityTest{
    
    static testMethod void testMethod1()
    {
        RecordType rt = ClsTestHelp.createTestRecordType23();
        
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        
        Opportunity oppty1 = new Opportunity();
        oppty1.RecordTypeId = rt.id;
        oppty1.Name = 'Test Opportunity 1';
        oppty1.CloseDate = Date.today().addDays(60);
        oppty1.currency_confirm__c = true;
        oppty1.StageName = 'Sampling';
        oppty1.NDR_Quote_Status_Description__c = 'complete';  
        oppty1.Level__c = ClsOppyForecastUtil.QUARTERLY;
        oppty1.Life_of_Program_in_Years__c = '3';
        insert oppty1;

        test.startTest();
 
        test.setCurrentPage(Page.CopyNDRPage);
        ApexPages.currentPage().getParameters().put('Id', oppty1.Id);
        apexpages.StandardController sc =new apexpages.StandardController(oppty1);  
        CopyNDROpportunity objCls=new CopyNDROpportunity(sc);      
        PageReference pageRef = Page.CopyNDRPage;
        objCls.copyNDR();  
        
        test.stopTest();       
    }

}