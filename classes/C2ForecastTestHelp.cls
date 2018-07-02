/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
public class C2ForecastTestHelp {
    
    public static User createTestUsers() {
        User u = new User();
        u.FirstName ='First';
        u.LastName = 'Tester';
        u.Alias = 'mtst';
        u.Email = 'mtester@ItbTestcompany.com';
        u.Username = u.Email;
        u.CommunityNickname = u.Alias;
        u.ProfileId = [select Id 
                        from Profile
                        where Name = 'System Administrator'][0].Id;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.EmployeeNumber = 'TE123456';
        u.LanguageLocaleKey = 'en_US';
        return u;
    }
    
    public static Account createTestAccounts() {
        Account acc = new Account();
        acc.Name = 'AMP Foundries Inc';
        acc.AnnualRevenue = 2000000.11; 
        acc.Legally_Restricted__c = false;  
        acc.BillingCity = 'Musterstadt';
        acc.BillingStreet = 'Teststr. 1';
        acc.BillingCountry = 'Germany';
        acc.BillingPostalCode = '77777';
        acc.STATDESC__c = 'Active';
        acc.ACCT_GROUP_CDE__c = '0001';
        acc.GAMCD__c = 'G999';
        acc.Type = 'CM';
        return acc;
    }
    public static Opportunity createTestOpportunity() {
        RecordType rt2 = ClsTestHelp.createTestRecordType16();
        Opportunity oppy = new Opportunity();
        oppy.currency_confirm__c = true;
        oppy.StageName = 'New';
        oppy.Name = 'SandKing';
        oppy.CloseDate = date.today();
        oppy.RecordTypeId = rt2.Id;
        //oppy.Tender__c = null;
        return oppy;
    }
    public static Opportunity_Forecast__c createTestOpportunityForecasts() {
        Opportunity_Forecast__c oppyForecast = new Opportunity_Forecast__c();
        oppyForecast.Date__c = date.today();
        oppyForecast.CurrencyIsoCode = 'EUR';
        return oppyForecast;
    }
     public static RecordType createTestRecordType() {
        RecordType rt = [select Name from RecordType where SobjectType = 'Account' and DeveloperName = 'CIS_Account'];
        return rt;
    } 
    public static Opportunity_Part__c createTestOpportunityPart() {
        Opportunity_Part__c oppypart = new Opportunity_Part__c();
        oppypart.Cable_Assembly_Type__c = 'Fiber Optic';
        return oppypart;
    }
    public static Sales_Hierarchy__c createTestSalesHierarchy() {
        Sales_Hierarchy__c sh = new Sales_Hierarchy__c(); 
        sh.Hierarchy_Type__c = 'Global Account Manager Hierarchy (GAM)';
        return sh;
    }
    public static Overall_Forecast__c CreateTestOverallForecast(){
        Overall_Forecast__c ovf = new Overall_Forecast__c();
        ovf.Month_0__c = 0000.00;
        ovf.Month_1__c = 1111.11;
        ovf.Month_2__c = 2222.22;
        ovf.Month_3__c = 3333.33;
        ovf.Month_4__c = 4444.44;
        ovf.Month_5__c = 5555.55;
        ovf.Month_6__c = 6666.66;
        ovf.Month_7__c = 7777.77;
        ovf.Month_8__c = 8888.88;
        ovf.Month_9__c = 9999.99;
        ovf.Month_10__c = 0000.00;
        ovf.Month_11__c = 0000.00;
        ovf.Month_12__c = 0000.00;
        ovf.Month_13__c = 0000.00;
        ovf.Month_14__c = 0000.00;
        ovf.Month_15__c = 0000.00;
        ovf.Month_16__c = 0000.00;
        ovf.Month_17__c = 0000.00;
        ovf.Previous_Month_1__c = 0000.00;
        ovf.Previous_Month_2__c = 0000.00;
        ovf.Previous_Month_3__c = 0000.00;
        ovf.Previous_Month_4__c = 0000.00;
        ovf.Previous_Month_5__c = 0000.00;
        ovf.Previous_Month_6__c = 0000.00;
    return ovf;
    }
    public static Overall_Measures__c CreateTestOverallMeasures(){
        Overall_Measures__c ovm = new Overall_Measures__c();
        ovm.Month_0__c = 0000.00;
        ovm.Month_1__c = 1111.11;
        ovm.Month_2__c = 2222.22;
        ovm.Month_3__c = 3333.33;
        ovm.Month_4__c = 4444.44;
        ovm.Month_5__c = 5555.55;
        ovm.Month_6__c = 6666.66;
        ovm.Month_7__c = 7777.77;
        ovm.Month_8__c = 8888.88;
        ovm.Month_9__c = 9999.99;
        ovm.Month_10__c = 0000.00;
        ovm.Month_11__c = 0000.00;
        ovm.Month_12__c = 0000.00;
        ovm.Month_13__c = 0000.00;
        ovm.Month_14__c = 0000.00;
        ovm.Month_15__c = 0000.00;
        ovm.Month_16__c = 0000.00;
        ovm.Month_17__c = 0000.00;
        ovm.Previous_Month_1__c = 0000.00;
        ovm.Previous_Month_2__c = 0000.00;
        ovm.Previous_Month_3__c = 0000.00;
        ovm.Previous_Month_4__c = 0000.00;
        ovm.Previous_Month_5__c = 0000.00;
        ovm.Previous_Month_6__c = 0000.00;
    return ovm;
    }
    public static Account_Forecast__c CreateTestAccountForecast(){
        Account_Forecast__c af = new Account_Forecast__c();
        af.Month_0__c = 0000.00;
        af.Month_1__c = 1111.11;
        af.Month_2__c = 2222.22;
        af.Month_3__c = 3333.33;
        af.Month_4__c = 4444.44;
        af.Month_5__c = 5555.55;
        af.Month_6__c = 6666.66;
        af.Month_7__c = 7777.77;
        af.Month_8__c = 8888.88;
        af.Month_9__c = 9999.99;
        af.Month_10__c = 0000.00;
        af.Month_11__c = 0000.00;
        af.Month_12__c = 0000.00;
        af.Month_13__c = 0000.00;
        af.Month_14__c = 0000.00;
        af.Month_15__c = 0000.00;
        af.Month_16__c = 0000.00;
        af.Month_17__c = 0000.00;
        af.Previous_Month_1__c = 0000.00;
        af.Previous_Month_2__c = 0000.00;
        af.Previous_Month_3__c = 0000.00;
        af.Previous_Month_4__c = 0000.00;
        af.Previous_Month_5__c = 0000.00;
        af.Previous_Month_6__c = 0000.00;
    return af;
    }
    public static Account_Measures__c CreateTestAccountMeasures(){
        Account_Measures__c am = new Account_Measures__c();
        am.Month_0__c = 0000.00;
        am.Month_1__c = 1111.11;
        am.Month_2__c = 2222.22;
        am.Month_3__c = 3333.33;
        am.Month_4__c = 4444.44;
        am.Month_5__c = 5555.55;
        am.Month_6__c = 6666.66;
        am.Month_7__c = 7777.77;
        am.Month_8__c = 8888.88;
        am.Month_9__c = 9999.99;
        am.Month_10__c = 0000.00;
        am.Month_11__c = 0000.00;
        am.Month_12__c = 0000.00;
        am.Month_13__c = 0000.00;
        am.Month_14__c = 0000.00;
        am.Month_15__c = 0000.00;
        am.Month_16__c = 0000.00;
        am.Month_17__c = 0000.00;
        am.Previous_Month_1__c = 0000.00;
        am.Previous_Month_2__c = 0000.00;
        am.Previous_Month_3__c = 0000.00;
        am.Previous_Month_4__c = 0000.00;
        am.Previous_Month_5__c = 0000.00;
        am.Previous_Month_6__c = 0000.00;
    return am;
    }
}