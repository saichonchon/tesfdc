/**********************************************************************
Name:  ADMJDAOppForecast_Batch_Test 
Copyright © 2017
======================================================
======================================================
Purpose: Test  Class for ADMJDAOppForecast_Batch
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR                DATE             DETAIL               
0.1        Kartik G          10/11/2017         INITIAL DEVELOPMENT     
***********************************************************************/

@isTest
public class ADMJDAOppForecast_Batch_Test {
        
    static testmethod void ADMJDAOppFcstTest(){
       Test.startTest();
        INFRA_JDA_Settings__c adminfra1config = new INFRA_JDA_Settings__c();
        adminfra1config.Name = 'ADM1';
        adminfra1config.N_th_Day_of_Fiscal_Month__c = 7;
        insert adminfra1config;
            
        INFRA_JDA_Settings__c adminfra2config = new INFRA_JDA_Settings__c();
        adminfra2config.Name = 'ADM2';
        adminfra2config.N_th_Day_of_Fiscal_Month__c = 14;
        insert adminfra2config;

        Id accId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account').getRecordTypeId();
        Id admId= Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('ADM').getRecordTypeId();
        Id oppFrcastId = Schema.SObjectType.Opportunity_Forecast__c.getRecordTypeInfosByName().get('Part').getRecordTypeId();
        
        ClsTestCustomSettingHelper.getAllSettings();
        ClsTestCustomSettingHelper.getPMV_Sales_Stage_Setting();
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getTrigger_Configuration(); 
        
        ADMTerritoryCode__c ADMTeritoryCode = new ADMTerritoryCode__c();
        ADMTeritoryCode.Name = 'ADMTerritoryCode';
        ADMTeritoryCode.Territory_Code__c ='101485';
        insert ADMTeritoryCode;
        
        Product_Hierarchy__c producthierarchy = new Product_Hierarchy__c();
        producthierarchy.CBC1__c='13009';
        producthierarchy.Name='Hierarchy1';
        producthierarchy.GPL_Description__c='AMP Communications Outlet';
        insert producthierarchy;
        
        Account acc = ADMTestDataFactory.createTestAccounts();
        acc.Name = 't'+system.now().millisecond()+math.round(math.random()*10000);
        acc.RecordTypeId = accId;
        acc.AnnualRevenue = 2000000.11; 
        acc.Legally_Restricted__c = false;  
        acc.BillingCity = 'Musterstadt';
        acc.BillingStreet = 'Teststr. 1';
        acc.BillingCountry = 'CN';
        acc.Type = 'Distributor';
        acc.BillingPostalCode = '77777';
        //acc.Sales_Hierarchy__c=ClsTestHelp.createTestSalesHierarchy().Id;
        acc.Industry_Code_Description__c='Industrial';
        acc.Business_Unit_Level_2__c='Rail';
        acc.AccountNumber = '1011:00180388';
        acc.LAYER2_ORGANIZATION_ID__c='EMEA';
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
        oppNew.RecordTypeId = admId;
        //oppNew.Level__c ='Monthly';
        //oppNew.Method__c = 'Manual';
        oppNew.Probability = 80.00;
        oppNew.StageName = 'Test';
        //oppNew.RecordTypeId=oppRecordTypeId;
        insert oppNew;
        
        Part__c prtrec = new  Part__c();
        prtrec.Product_Hierarchy__c = producthierarchy.id;
        prtrec.GPL_DESC__c='System 6'; 
        prtrec.GPL__c = producthierarchy.id;       
        insert prtrec;
        System.debug('prtrec..'+prtrec);
        
        Opportunity_Part__c opppart = new  Opportunity_Part__c();
        opppart.Opportunity__c =oppNew.id; 
        opppart.Part__c = prtrec.id;    
        opppart.Status__c='Won';
        insert opppart;     
        System.debug('opppart..'+opppart);
        
        List<Opportunity_Forecast__c> oppfrcastList = new List<Opportunity_Forecast__c>();
        Opportunity_Forecast__c oppFrcast = new Opportunity_Forecast__c();
        oppFrcast.RecordTypeId = oppFrcastId;
        oppFrcast.CurrencyIsoCode = 'USD';
        oppFrcast.Amount__c = 50.00;
        oppFrcast.NPS1__c = 10;
        oppFrcast.MSG1__c = 40;
        oppFrcast.Opportunity__c = oppNew.id;
        oppFrcast.Fiscal_Month__c='01';
        oppFrcast.Fiscal_Year__c='2018';
        oppFrcast.Amount__c=10;
        oppFrcast.Part__c = opppart.id;
        oppfrcastList.add(oppFrcast); 
        
        Opportunity_Forecast__c oppFrcast1 = new Opportunity_Forecast__c();
        oppFrcast1.RecordTypeId = oppFrcastId;
        oppFrcast1.CurrencyIsoCode = 'USD';
        oppFrcast1.Amount__c = 50.00;
        oppFrcast1.NPS1__c = 10;
        oppFrcast1.MSG1__c = 40;
        oppFrcast1.Opportunity__c = oppNew.id;
        oppFrcast1.Fiscal_Month__c='01';
        oppFrcast1.Fiscal_Year__c='2019';
        oppFrcast1.Amount__c=10;
        oppFrcast1.Part__c = opppart.id;
        oppfrcastList.add(oppFrcast1); 
        insert oppfrcastList;
        
        oppNew.Relevant_for_S_OP__c = True;
        oppNew.Level__c ='Monthly';
        oppNew.Method__c = 'Manual';
        update oppNew;
        
        ADMJDAOppForecast_Batch OppForecast  = new ADMJDAOppForecast_Batch();
        Database.executeBatch(OppForecast);
       Test.stopTest();
    }
}