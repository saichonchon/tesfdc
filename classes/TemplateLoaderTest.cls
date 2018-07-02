@isTest

private class TemplateLoaderTest {
    static testMethod void testLoadTemplate() {
        //TemplateLoader chooser = new TemplateLoader(); 
        ClsTestCustomSettingHelper.getAllSettings();
        List<Smart_Template_Loader_Conf__c> lstSTLC = new List<Smart_Template_Loader_Conf__c>();
        lstSTLC.add(new Smart_Template_Loader_Conf__c (Name = 'Answer_Customer_Web_Template', Case_Region__c = 'Japan',Case_Status__c = 'Assigned', Template_Name__c = 'Answer_Customer_Web_Template'));
        lstSTLC.add(new Smart_Template_Loader_Conf__c (Name = 'Dummy', Case_Region__c = '',Case_Status__c = '', Template_Name__c = ''));
        insert lstSTLC;
        // Create a simulated case to test with
        /*RecordType rt = ClsTestHelp.createTestRecordType();                                                   
        Account acc = ClsTestHelp.createTestAccounts();  
        //acc.RecordTypeId = rt.Id;
        insert acc;
        
        Contact con = ClsTestHelp.createTestContacts();  
        con.AccountId = acc.Id;
        insert con;*/
        
        Case c = new Case(); 
        //c.AccountId = acc.Id;
        //c.ContactId = con.Id;
        c.RecordTypeId = Apex_Helper_Settings__c.getInstance('PIC Service Cloud').Value__c; 
        c.Origin = 'Web';
        c.Subject = 'This is a load template test';
        c.Description = 'This is a load template test description';
        c.Status = 'Assigned';
        c.Country__c = 'Japan';
        insert(c);

        // Make sure the proper template is chosen for this subject
        TemplateLoader chooser = new TemplateLoader(); 
        Id actualTemplateId = chooser.getDefaultEmailTemplateId(c.Id);
        EmailTemplate expectedTemplate = [SELECT id FROM EmailTemplate WHERE DeveloperName = 'Answer_Customer_Web_Template'];
        Id expectedTemplateId = expectedTemplate.Id;
        System.assertEquals(actualTemplateId, expectedTemplateId);
        
        // Change the case properties to match a different template
        /*c.Subject = 'Updating case details';
        c.Status = '';
        c.Country__c = '';
        Database.update(c);
               
        // Make sure the correct template is chosen in this case
        actualTemplateId = chooser.getDefaultEmailTemplateId(c.Id);
        expectedTemplate = [SELECT id FROM EmailTemplate WHERE DeveloperName = 'Dummy'];
        expectedTemplateId = expectedTemplate.Id;
        System.assertEquals(actualTemplateId, expectedTemplateId);*/
    }
}