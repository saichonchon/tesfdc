@isTest

(SeeAllData=true)
private class CutoffDateUpdate_Test{
    
    public static testMethod void MytestTrigger() {
    
    /*
        // User Record.
        Profile p = [SELECT Id FROM Profile WHERE Name='CSD Engineering User w/Cost']; 
        
        User u = new User(GIBU__c='Consumer Devices', Alias = 'standt', Email='test@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='test@testorg.com', CSD_Region__c='Taiwan');
        System.runAs(u) {
        }
        */
        //Account Record types
        Schema.DescribeSObjectResult cfrAccSchema = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> AccountRecordTypeInfo = cfrAccSchema.getRecordTypeInfosByName(); 
        Id CSDAccountrtId = AccountRecordTypeInfo.get('Account').getRecordTypeId();
        Id CSDOEMrtId = AccountRecordTypeInfo.get('OEM').getRecordTypeId();
                
        Account acc = new Account();
        acc.RecordTypeId = CSDAccountrtId;
        acc.Name = 'Test';
        acc.ownerId = UserInfo.getUserId();        
        acc.Account_Manager__c = UserInfo.getUserId();
        insert acc;
        
        Account acc1 = new Account();
        acc1.RecordTypeId = CSDAccountrtId;
        acc1.Active__c = true;
        acc1.Name = 'Test1';
        acc1.ownerId = UserInfo.getUserId(); 
        acc1.Account_Manager__c = UserInfo.getUserId();
        insert acc1;
       
        OEM_Details__c oem1 = new OEM_Details__c();
        oem1.OEM__c = acc1.id;
        oem1.Cutoff_Date__c = null;
        oem1.Fiscal_Month__c = '07';
        oem1.Fiscal_Year__c = '2013';
        try{insert oem1;}            
        catch(exception e1){
        }
        
        
        Utils_SDF_Methodology.removeFromRunOnce(oem1.Cutoff_Date__c);
        oem1.Cutoff_Date__c = '25';
        try{update oem1;}            
        catch(exception e1){
        }
        
        
    }
}