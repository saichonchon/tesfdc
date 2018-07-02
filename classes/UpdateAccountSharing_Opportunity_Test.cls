@isTest
(SeeAllData=false)
private class UpdateAccountSharing_Opportunity_Test{
    
    public static testMethod void MytestTrigger() {
    
        Profile p =new Profile();
         for(profile oProfile : [SELECT Id, name FROM Profile WHERE Name='DND Engineering User w/Cost']) 
              p=oProfile ;
        User u = new User(GIBU__c='Consumer Devices', Alias = 'standt', Email='test432@testorg.com', EmailEncodingKey='UTF-8', LastName='Test432', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='test432@testorg.com', CSD_Region__c='Taiwan');
        insert u;
        
         //* Added by Archana...code changes start
        List<Trigger_Configuration__c> lstTriggerConfig = new  List<Trigger_Configuration__c>();
       
        Trigger_Configuration__c tc = new Trigger_Configuration__c(); 
        tc.Name='Avoid Duplicate PLM Id';
        tc.isRun__c=true;
        lstTriggerConfig .add(tc);
               
        Trigger_Configuration__c tc2 = new Trigger_Configuration__c(); 
        tc2.Name='DND Lead Conversion Initialization';
        tc2.isRun__c=true;
        lstTriggerConfig .add(tc2);
        
        Trigger_Configuration__c tc3 = new Trigger_Configuration__c(); 
        tc3.Name='Identify Fiscal Year';
        tc3.isRun__c=true;
        lstTriggerConfig .add(tc3);
        
        Trigger_Configuration__c tc4 = new Trigger_Configuration__c(); 
        tc4.Name='Populate Opportunity Partner';
        tc4.isRun__c=true;
        lstTriggerConfig .add(tc4);
        
        Trigger_Configuration__c tc5 = new Trigger_Configuration__c(); 
        tc5.Name='updateAccountBusinessUnit';
        tc5.isRun__c=true;
        lstTriggerConfig .add(tc5);
        
        insert lstTriggerConfig ;
        
        ADMTerritoryCode__c admTerritoryCode= new ADMTerritoryCode__c();
        admTerritoryCode.Name='ADMTerritoryCode';
        admTerritoryCode.Territory_Code__c='101485';
        insert admTerritoryCode;
        
                //* Added by Archana...code changes end
       
        
        //Account Record Type
        Schema.DescribeSObjectResult cfrSchema1 = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> AccountRecordTypeInfo = cfrSchema1.getRecordTypeInfosByName(); 
        //Opportunity Record types
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> OpportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        
       ClsTestCustomSettingHelper.getApex_Helper_Settings();
       ClsTestCustomSettingHelper.getOpportunity_Approvers();       
       ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
       ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();     
       ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        
       Id CSDrtId = Consumer_Device_Opportunity_Record_Types__c.getInstance('Sales Opportunity-CSD').Record_Type_Id__c;
        Id EnggrtId = Consumer_Device_Opportunity_Record_Types__c.getInstance('Engineering Opportunity-CSD').Record_Type_Id__c;
        Id CSDAccrtId = Consumer_Device_Opportunity_Record_Types__c.getInstance('OEM').Record_Type_Id__c;
        //Account Records        
        Account acc = new Account();
        acc.Name = 'Test';
        acc.ownerId = UserInfo.getUserId();        
        acc.Account_Manager__c = U.Id;
        acc.BillingCountry = 'CN';
        acc.billingstate='LA';
        acc.AccountNumber = '0451:01319551';
       acc.Website='www.salesforce.com';
        acc.Type='CM';
        acc.SicDesc='test';
        acc.Sic='test';
        acc.Shippingcity='test';
        acc.Shippingstate='test';
        acc.Shippingcountry='test';
        //acc.pincode=522301;
        acc.Rating='hot';
        acc.Phone='22090099';
        acc.Ownership='Public';
        acc.Industry='Appliance';
        acc.Fax='900900';
        acc.NumberOfEmployees=10;
        acc.Description='test';
        acc.Jigsaw='00kiludgsj';
        //acc.BillingAddress='test';
        acc.AnnualRevenue=4;
        acc.Site='www.google.com';
        acc.CurrencyIsoCode='USD';       
        acc.RecordTypeId = CSDAccrtId;
        insert acc;
        
        Opportunity opp = new Opportunity(Currency_Confirm__c = true,isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = CSDrtId, CloseDate = system.today() , StageName = 'New', Probability = 0,Fulfillment_Region__c = userinfo.getuserid(), OEM_Name__c = acc.id, Amount = 100, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');
        insert opp;
        acc.Account_Manager__c =UserInfo.getUserId();
        update acc;        
    }
}