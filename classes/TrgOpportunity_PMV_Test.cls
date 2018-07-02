/**
*   This test class is for Opportunity_PMV.
*
@author Yuanyuan Zhang
@created 2014-04-28
@version 1.0
@since 29.0
*
@changelog
* 2014-04-28 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>
* - Created
* - Test coverage 84%
*/
@isTest(seealldata=true)
private class TrgOpportunity_PMV_Test {
    
    static testmethod void testinsert1(){
        User u = ClsTestHelp.createTestUsers4PMV();
        u.Username = 'jinbo@sdfasdf.csddgrw';
        insert u;
        
        system.runAs(u){
            test.startTest();
            
            String oppyRT = ClsTestHelp.createPMVTestRecordType1().Id;
            
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            acc.BillingCountry = 'US';
            insert acc;
            
            Opportunity opp = new Opportunity();
            opp.AccountId = acc.Id;
            opp.Name = 'test';
            opp.CurrencyIsoCode = 'EUR';
            opp.Type = 'New Business';
            opp.currency_confirm__c = true;
            opp.Description = 'test';
            opp.Distributor__c = 'Dachs';
            opp.StageName = 'Initiating';
            opp.Manufacturing_Start_Date__c = date.today();
            opp.CloseDate = date.today().addMonths(1);
            opp.RecordTypeId = oppyRT;
            opp.Lead_ID__c = '01x000000000fgh';
            opp.PMV_Type__c = 'IND Standard Sales opp';
            insert opp;
            
            test.stoptest();
        }
    }
    static testmethod void testUpdate1(){
    	User u = ClsTestHelp.createTestUsers4PMV();
        u.Username = 'jinbo@sdfasdf.csddgrw23';
        insert u;
        system.runAs(u){
            test.startTest();
            
            String oppyRT = ClsTestHelp.createPMVTestRecordType1().Id;
            
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            acc.BillingCountry = 'US';
            insert acc;
            
            Opportunity opp = new Opportunity();
            opp.AccountId = acc.Id;
            opp.Name = 'test';
            opp.CurrencyIsoCode = 'EUR';
            opp.Type = 'New Business';
            opp.Description = 'test';
            opp.currency_confirm__c = true;
            opp.Distributor__c = 'Dachs';
            opp.StageName = 'Initiating';
            opp.Manufacturing_Start_Date__c = date.today();
            opp.CloseDate = date.today().addMonths(1);
            opp.RecordTypeId = oppyRT;
            opp.PMV_Type__c = 'IND Standard Sales opp';
            insert opp;
            opp.StageName = 'Exploring Needs';
            opp.Stage_Change_Error_Message__c = 'test';
            update opp;
            
            test.stoptest();
        }
    }
    
    
    static testmethod void testUpdate2(){
        User u = ClsTestHelp.createTestUsers4PMV();
        u.Username = 'jinbo@sdfasdf.csddgrw2e3';
        insert u;
        system.runAs(u){
            test.startTest();
            
            String oppyRT = ClsTestHelp.createPMVTestRecordType1().Id;
            String nonePMV;
            
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            acc.BillingCountry = 'US';
            insert acc;
            
            Opportunity opp = new Opportunity();
            opp.AccountId = acc.Id;
            opp.Name = 'test';
            opp.CurrencyIsoCode = 'EUR';
            opp.Type = 'New Business';
            opp.currency_confirm__c = true;
            opp.Description = 'test';
            opp.Distributor__c = 'Dachs';
            opp.StageName = 'Initiating';
            opp.Manufacturing_Start_Date__c = date.today();
            opp.CloseDate = date.today().addMonths(1);
            opp.RecordTypeId = oppyRT;
            opp.Approval_Status_PMV__c = 'G0 In Approval';
            opp.PMV_Type__c = 'IND Standard Sales opp';
            insert opp;
            opp.StageName = 'Exploring Needs';
            
            update opp;
            
           
            test.stoptest();
        }
    }
}