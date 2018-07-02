/**********************************************************************
Name:  ADMOpportunityHelper_Test
Copyright © 2017
======================================================
======================================================
Purpose: Test Class for ADMOpportunityHelper that validates Relevant for SOP Check based on mulitple conditions.
-------                                      
======================================================
======================================================
History                                                                                                                        
VERSION      AUTHOR                DATE             DETAIL Description
0.1          akshay dhopey         10/07/2017       INITIAL DEVELOPMENT
***********************************************************************/
@isTest
public class ADMOpportunityHelper_Test{
    static testMethod void testTrigger(){
        
        //Account record type should be 'Account' and Opportunity record type should be 'ADM'.
        //Opportunity Forecast(s) need to be forecasted on Monthly Level, Manual Method, and Monthly data needs to be present.
        //Save the opportunity record by making Relevant for SOP=True
        
        Id accId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account').getRecordTypeId();
        Id acc1Id= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        Id admId= Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('ADM').getRecordTypeId();
        Id oppFrcastId = Schema.SObjectType.Opportunity_Forecast__c.getRecordTypeInfosByName().get('Part').getRecordTypeId();
        ClsTestCustomSettingHelper.getAllSettings();
        ClsTestCustomSettingHelper.getPMV_Sales_Stage_Setting();
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ADMTestDataFactory.getADM_CustomSetting();
        
        
        //Insert Trigger configuration Custom Settings
        Trigger_Configuration__c tcadm = new Trigger_Configuration__c();
        tcadm.Name = 'ADMSOPCheck';
        tcadm.isRun__c = true;
        insert tcadm;
        
        Test.startTest();    
        //Insert Account
        List<Account> accList = new List<Account>();
        Account acc = ADMTestDataFactory.createTestAccounts();
        acc.RecordTypeId = accId;
        Account acc1 = ADMTestDataFactory.createTestAccounts();
        acc1.RecordTypeId = acc1Id;
        
        accList.add(acc);
        accList.add(acc1);
        insert accList;
        
        //Create  Opportunity Record
        List<Opportunity> oppNewlist = new List<Opportunity>();
        Opportunity oppNew = new Opportunity();
        oppNew.Name = 'Opportunity1';
        oppNew.Account = acc;
        oppNew.accountId = acc.id;
        oppNew.Type = 'New Business';
        oppNew.Primary_Market_Type__c = 'Commercial Aerospace: Business Jets';
        oppNew.CurrencyIsoCode = 'USD';
        oppNew.Currency_Confirm__c = True;
        oppNew.CloseDate = system.today();
        oppNew.Amount = 1;
        oppNew.Opportunity_Health__c = 'Caution';
        oppNew.RecordTypeId = admId;
        oppNew.Level__c ='Monthly';
        oppNew.Method__c = 'Manual';
        oppNew.Probability = 80.00;
        oppNew.StageName = 'Test';
        insert oppNew;
        System.debug('oppNew-------'+oppNew);       
        
        //Create  Opportunity Forecast Records
        List<Opportunity_Forecast__c> oppFrcastlist= new List<Opportunity_Forecast__c>();
        
        Opportunity_Forecast__c oppFrcast = new Opportunity_Forecast__c();
        oppFrcast.RecordTypeId = oppFrcastId;
        oppFrcast.CurrencyIsoCode = 'USD';
        oppFrcast.Amount__c = 50.00;
        oppFrcast.Fiscal_Year__c='2018';
        oppFrcast.NPS1__c = 10;
        oppFrcast.MSG1__c = 40;
        oppFrcast.Opportunity__c = oppNew.id;
        oppFrcastlist.add(oppFrcast);
        
        Opportunity_Forecast__c oppFrcast1 = new Opportunity_Forecast__c();
        oppFrcast1.RecordTypeId = oppFrcastId;
        oppFrcast1.CurrencyIsoCode = 'USD';
        oppFrcast1.Amount__c = 60.00;
        oppFrcast1.Fiscal_Year__c='2019';
        oppFrcast1.NPS1__c = 10;
        oppFrcast1.MSG1__c = 40;
        oppFrcast1.Opportunity__c = oppNew.id;
        oppFrcastlist.add(oppFrcast1);
        
        insert oppFrcastlist;        
        try{
            
            //For cover code Relevant for SOP checked
            oppNew.Relevant_for_S_OP__c = True;
            update oppNew; 
            
            //For cover code level change part
            oppNew.Relevant_for_S_OP__c = True;
            oppNew.Level__c ='Monthly';
            oppNew.Method__c = 'Manual'; 
            update oppNew; 
            
            //Create  Opportunity Record again for test separate error msg call exception
            Opportunity oppinsert = new Opportunity();
            oppinsert.Name = 'oppinsert';
            oppinsert.Account = acc;
            oppinsert.accountId = acc.id;
            oppinsert.Type = 'New Business';
            oppinsert.Primary_Market_Type__c = 'Commercial Aerospace: Business Jets';
            oppinsert.CurrencyIsoCode = 'USD';
            oppinsert.Currency_Confirm__c = True;
            oppinsert.CloseDate = system.today();        
            oppinsert.Amount = 1;
            oppinsert.Opportunity_Health__c = 'Caution';
            oppinsert.Relevant_for_S_OP__c = True;
            oppinsert.RecordTypeId = admId;
            oppinsert.Level__c ='Monthly';
            oppinsert.Method__c = 'Manual';
            oppinsert.Probability = 80.00;
            oppinsert.StageName = 'Test';
            insert oppinsert;           
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('ADM Opportunity record') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
        
        try{
            //Create  Opportunity Record again for test separate error msg call exception for diffrect account record type
            Opportunity oppinsert1 = new Opportunity();
            oppinsert1.Name = 'oppinsert';
            oppinsert1.Account = acc1;
            oppinsert1.accountId = acc1.id;
            oppinsert1.Type = 'New Business';
            oppinsert1.Primary_Market_Type__c = 'Commercial Aerospace: Business Jets';
            oppinsert1.CurrencyIsoCode = 'USD';
            oppinsert1.Currency_Confirm__c = True;
            oppinsert1.CloseDate = system.today();        
            oppinsert1.Amount = 1;
            oppinsert1.Opportunity_Health__c = 'Caution';
            oppinsert1.Relevant_for_S_OP__c = True;
            oppinsert1.RecordTypeId = admId;
            oppinsert1.Level__c ='Monthly';
            oppinsert1.Method__c = 'Manual';
            oppinsert1.Probability = 80.00;
            oppinsert1.StageName = 'Test';
            insert oppinsert1;
            
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('ADM Opportunity record') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
        
        Test.stopTest();
    } 
    
    
}