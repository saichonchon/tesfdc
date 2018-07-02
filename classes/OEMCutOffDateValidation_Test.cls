@isTest

(SeeAllData=true)
private class OEMCutOffDateValidation_Test{
    
    public static testMethod void MytestTrigger() {
        
        // User Record
        Profile p = [SELECT Id FROM Profile WHERE Name='DND Engineering User w/Cost']; 
        
        User u = new User(GIBU__c='Consumer Devices', Alias = 'standt', Email='test@testorg.com', EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='tst123@test.com', CSD_Region__c='Taiwan');
        System.runAs(u) {
        }
                
        //Account Record types
        Schema.DescribeSObjectResult cfrAccSchema = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> AccountRecordTypeInfo = cfrAccSchema.getRecordTypeInfosByName(); 
        Id CSDAccountrtId = AccountRecordTypeInfo.get('Account').getRecordTypeId();
        Id CSDOEMrtId = AccountRecordTypeInfo.get('OEM').getRecordTypeId();
                
        //Date dt= System.today().addMonths(1);
        
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9(); 
        Apex_Helper_Settings__c ahs10 = ClsTestHelp.createTestName10();
        Apex_Helper_Settings__c ahs11 = ClsTestHelp.createTestName11();                   
        
        // Account Record
        Account acc = new Account();
        acc.RecordTypeId = CSDAccountrtId;
        acc.Name = 'Test';
        acc.ownerId = UserInfo.getUserId();        
        acc.Account_Manager__c = UserInfo.getUserId();
        acc.type='TE_01536';
        insert acc;
        
        
        OEM_Details__c oem = new OEM_Details__c();
        oem.OEM__c = acc.id;
        
        if(ClsOEMUtil.CurrentFM == null)
        {
            ClsOEMUtil.setCurrentFiscalDateValues();
        }
        
        if(ClsOEMUtil.CurrentFM == 12)
        {
            oem.Fiscal_Year__c  = string.valueOf(integer.valueOf(ClsOEMUtil.CurrentFY) + 1);
            oem.Fiscal_Month__c = '01';         
        }
        else
        {
            oem.Fiscal_Year__c  = ClsOEMUtil.CurrentFY;
            oem.Fiscal_Month__c = string.valueOf(ClsOEMUtil.CurrentFM + 1).leftpad(2).replace(' ', '0');     
        }
        
        oem.Cutoff_Date__c = '15';
        insert oem;
                
        /*
        OEM_Details__c oem = new OEM_Details__c();
        oem.OEM__c = acc.id;
        oem.Fiscal_Year__c  = '2013';
        oem.Fiscal_Month__c = '07';
        oem.Cutoff_Date__c = '25';
        insert oem;
        */    
        
    }
}