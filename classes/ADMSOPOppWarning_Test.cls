/**********************************************************************
Name: ADMSOPOppWarning_Test
Copyright © 2017
======================================================
======================================================
Purpose: Test class for ADMSOPOppWarning is used for displaying the custom message on a page for opportinities and its 
child forecast records which have Relevant for S&OP marked true, but opportunity is below 90% probability
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR               DATE             DETAIL Description
0.1         akshay dhopey      10/8/2017           INITIAL DEVELOPMENT
***********************************************************************/
@isTest
public class ADMSOPOppWarning_Test{
    static testMethod void testOppWarning(){
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> ForecastRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id rtId = ForecastRecordTypeInfo.get('ADM').getRecordTypeId();
        Id accId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account').getRecordTypeId();
        Id oppFrcastId = Schema.SObjectType.Opportunity_Forecast__c.getRecordTypeInfosByName().get('Part').getRecordTypeId();
    
        ClsTestCustomSettingHelper.getAllSettings();
        ClsTestCustomSettingHelper.getPMV_Sales_Stage_Setting();
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
             
        ADMTerritoryCode__c ADMTeritoryCode = new ADMTerritoryCode__c();
        ADMTeritoryCode.Name = 'ADMTerritoryCode';
        ADMTeritoryCode.Territory_Code__c ='101485';
        insert ADMTeritoryCode;
      
        ADM_Custom_Setting__c admConfig = new ADM_Custom_Setting__c();
        admConfig.Name = 'ADM_JDA_Probability';
        admConfig.Value__c = '90';
        insert admConfig;
        
     Test.startTest();    
        Account acc = ADMTestDataFactory.createTestAccounts();
        acc.RecordTypeId = accId;
        insert acc; 
     
        Opportunity oppNew = new Opportunity();
        oppNew.Name = 'Opportunity1';
        oppNew.Account = acc;
        oppNew.accountId = acc.id;
        oppNew.Type = 'New Business';
        oppNew.Primary_Market_Type__c = 'Commercial Aerospace: Business Jets';
        oppNew.CurrencyIsoCode = 'USD';
        oppNew.Currency_Confirm__c = True;
        oppNew.CloseDate = system.today();
        //oppNew.Phase__c = 'Design';
        oppNew.Amount = 1;
        oppNew.Opportunity_Health__c = 'Caution';
        //oppNew.Relevant_for_S_OP__c = True;
        oppNew.RecordTypeId = rtId;
        //oppNew.Level__c ='Monthly';
       /// oppNew.Method__c = 'Manual';
        oppNew.Probability = 80.00;
        oppNew.StageName = 'Test';
        insert oppNew;
        System.debug('oppNew----'+oppNew);
    
         
        Opportunity_Forecast__c oppFrcast = new Opportunity_Forecast__c();
        oppFrcast.RecordTypeId = oppFrcastId;
        oppFrcast.CurrencyIsoCode = 'USD';
        oppFrcast.Amount__c = 50.00;
        oppFrcast.NPS1__c = 10;
        oppFrcast.MSG1__c = 40;
        oppFrcast.Opportunity__c = oppNew.id;
        //oppFrcast.RecordTypeId=oppForecastRecordTypeId;
        oppFrcast.Fiscal_Month__c='01';
        oppFrcast.Fiscal_Year__c='2019';
        oppFrcast.Amount__c=10;
        //oppFrcast.Part__c = opppart.id;
        insert oppFrcast; 
    
        oppNew.Relevant_for_S_OP__c = True;
        oppNew.Level__c ='Monthly';
        oppNew.Method__c = 'Manual';
        update oppNew;
    
     
        PageReference pageRef = Page.ADMOppSOPWarning;
        Test.setCurrentPage(pageRef);
        //ID pageId = pageRef.getParameters().put('id', String.valueOf(oppNew.Id));
        ApexPages.CurrentPage().getparameters().put('id', oppNew.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(oppNew);
        ADMSOPOppWarning sopOpp = new ADMSOPOppWarning(sc); 
     Test.stopTest();
}
}