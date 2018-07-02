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


@isTest(SeeAllData=true)
private class ManageAccountsforGAMEntry_Test {


    static testMethod void addAccountsAndSave() {
        String testGamCode = 'G444TEST';

        User me = [ select Id from User where Id = :UserInfo.getUserId() ];
        User usr = C2ForecastTestHelp.createTestUsers();
        Sales_Hierarchy__c sh = C2ForecastTestHelp.createTestSalesHierarchy();
        //Id systemAdminProfileId = Apex_Helper_Settings__c.getInstance('System Admin Profile Id').Value__c;   
        System.runAs ( me ) {
            usr.isActive = true;
            insert usr;
        }

        system.debug('--------------------------- testGamCode ' +testGamCode);
        sh.Name = 'nameOfTestRecord'+testGamCode;
        sh.Level_7_Territory_Name__c = 'nameOfTestRecord'+testGamCode;
        sh.Level_7_Territory_Code__c = testGamCode;
        sh.Level_7_Assigned_User_Network_Ids__c = usr.EmployeeNumber;
        //sh.Level_7_Assigned_Users__c = usr.id;
        sh.Level_7_Default_Owner__c = usr.id;
        insert sh;

        Account acc = C2ForecastTestHelp.createTestAccounts();
        acc.recordType = C2ForecastTestHelp.createTestRecordType();
        acc.GAMCD__c = testGamCode;
        acc.accountNumber = '4455:44445555';
        insert acc;

        Overall_Forecast__c ovF = C2ForecastTestHelp.CreateTestOverallForecast();
        ovF.Gam_Code__c = sh.Level_7_Territory_Code__c;
        ovF.Sales_Hierarchy__c = sh.Id;
        insert ovF;
        
        Account_Forecast__c accountForecast = C2ForecastTestHelp.CreateTestAccountForecast();
        accountForecast.Account__c = acc.id;
        accountForecast.Overall_Forecast__c = ovF.id;
        insert accountForecast;
        
        list<ManageAccountsforGAMEntry.AccountForecastInnerClass> list_accountForecasts = new list<ManageAccountsforGAMEntry.AccountForecastInnerClass>();
        ManageAccountsforGAMEntry.AccountForecastInnerClass afCls = new ManageAccountsforGAMEntry.AccountForecastInnerClass();
        afCls.afc = accountForecast;
        afCls.index = 1;
        list_accountForecasts.add(afCls);
        
        ApexPages.currentPage().getParameters().put('GamCode', testGamCode);
        
        
        ////////////////////////////////////////////////////////////////////////////////////////////
        Test.startTest();
        ////////////////////////////////////////////////////////////////////////////////////////////
        
        System.RunAs(usr) {
            ApexPages.StandardController ctrl = new ApexPages.StandardController(accountForecast); 
            ManageAccountsforGAMEntry ext = new ManageAccountsforGAMEntry(ctrl);
            //ext.gamCode = sh.Level_7_Territory_Code__c;
            ext.gamCode = testGamCode;
            ext.addAmount = 5;
            ext.list_accountForecasts = list_accountForecasts;
            
            system.debug('----------------------- ext.list_accountForecasts ' +ext.list_accountForecasts);
            
            ext.AddPartners();
            ext.getAmounts();
            ext.checkDuplicatePartner();
            ext.DeleteOpportunityPartner();
            ext.saveAndReturn(); 
            ext.cancel();
            ext.QuickSave();
            
           }
        
        ////////////////////////////////////////////////////////////////////////////////////////////
        Test.stopTest();
        ////////////////////////////////////////////////////////////////////////////////////////////
    }
}