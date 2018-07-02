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
@isTest (SeeAllData=true)
private class ClsBatch_buildOpportunityMeasures_Test {

    static testMethod void testQuarterBatch() {
        Test.startTest();
        
        list<Opportunity_Partner__c> oppyPartners = new list<Opportunity_Partner__c>();
        
        //Build some opportunities, parts, partners, and quarterly forecasts here
        Id ForecastRTOppy = [SELECT Id FROM RecordType WHERE DeveloperName = 'Opportunity' and SObjectType = 'Opportunity_Forecast__c' Limit 1].Id;
        
        //create account - set acct group code and gam code
        Account testAcct = new Account();
        testAcct = C2ForecastTestHelp.createTestAccounts();
        testAcct.ACCT_GROUP_CDE__c = '0001';
        testAcct.GAMCD__c = 'G000';
        testAcct.AccountNumber = 'Test account -0002';
        insert testAcct;
        //create sales hierarchy - set gam code and type
        Sales_Hierarchy__c testHier = C2ForecastTestHelp.createTestSalesHierarchy();
        testHier.Level_7_Territory_Code__c = 'G000';
        testHier.Hierarchy_Type__c = 'Global Account Manager Hierarchy (GAM)';
        insert testHier;
        //create opportunity - set mass prod status
        Opportunity testOpp = C2ForecastTestHelp.createTestOpportunity();
        testOpp.Mass_Prod_Status__c = true;
        testOpp.StageName = 'Won - Closed';
        testOpp.AccountId = testAcct.id;
        testOpp.Account = testAcct;
        testOpp.Probability = 10;
        insert testOpp;
        
        //create opportunity partner - set primary, allocation
        list<Opportunity_Partner__c> existingPartners = [SELECT Id, Opportunity__c, Account__c, Primary__c from Opportunity_Partner__c where opportunity__c =: testOpp.Id];
        Opportunity_Partner__c oppyPartner = existingPartners[0];//new Opportunity_Partner__c();        
        //oppyPartner.Opportunity__c = testOpp.Id;
        oppyPartner.Account__c = testAcct.Id;
        oppyPartner.Account__r = testAcct;
        //oppyPartner.Opportunity__r = testOpp;
        oppyPartner.Primary__c = true;
        oppyPartner.Allocation__c = 100;
        oppyPartner.CurrencyIsoCode = 'USD';
        update oppyPartner;        
        
        //create opportunity parts - proposal, stages
        Opportunity_Part__c oppyPart = new Opportunity_Part__c();
        oppyPart = C2ForecastTestHelp.createTestOpportunityPart();
        oppyPart.opportunity__c = testOpp.Id;
        insert oppyPart;
        
        list<String> years = new list<String>();
        years.add(string.valueOf(datetime.now().year()));
        years.add(string.valueOf(datetime.now().year() - 1));        
        years.add(string.valueOf(datetime.now().year() + 1));
        years.add(string.valueOf(datetime.now().year() + 2));                        
        
        list<Period> fcstPeriods = [SELECT startdate, FiscalYearSettings.Name from period where type = 'Quarter' and FiscalYearSettings.Name in: years order by startdate];
        //create opportunity forecasts - opportunity type - start date = current qtr start date     

        list<Opportunity_Forecast__c> fcstToAdd = new list<Opportunity_Forecast__c>();
        
        integer quarterCounter = 1;
        
        for(Period p : fcstPeriods)
        {
            Opportunity_Forecast__c newFcst = new Opportunity_Forecast__c();
            newFcst.date__c = p.startdate;
            newFcst.opportunity__c = testOpp.Id;
            newFcst.opportunity__r = testOpp;
            newFcst.Amount__c = 3;
            newFcst.Fiscal_Year__c = p.FiscalYearSettings.Name;
            newFcst.Fiscal_Quarter__c = ('0' + string.valueOf(quarterCounter));
            newFcst.CurrencyIsoCode = 'USD';
            newFcst.RecordTypeId = ForecastRTOppy;
            fcstToAdd.add(newFcst); 
            
            if(quarterCounter == 4)
            {
                quarterCounter = 1;
            }
            else
            {
                quarterCounter = quarterCounter+1;              
            }
        }       
        insert fcstToAdd;
        
        oppyPartners.add(oppyPartner);
        
        ClsBatch_buildOpportunityMeasures clsBatch1 = new ClsBatch_buildOpportunityMeasures();
        Database.BatchableContext BC1;
        clsBatch1.query = 'Select Id from Opportunity_Partner__c limit 1';
        clsBatch1.start(BC1);
        clsBatch1.execute(BC1, oppyPartners);
        clsBatch1.finish(BC1);
        
        list<Overall_Measures__c> testMeasure = [SELECT Id, Gam_Code__c, Month_0__c from Overall_Measures__c Where Gam_Code__c = 'G000' limit 1];
        
        system.assert(testMeasure[0].Month_0__c == 1, 'Monthly measure value does not match expected output');
        
        //Test where start month is not first month in quarter
        ClsBatch_buildOpportunityMeasures clsBatch2 = new ClsBatch_buildOpportunityMeasures();
        Database.BatchableContext BC2;
        clsBatch2.query = 'Select Id from Opportunity_Partner__c limit 1';
        clsBatch2.start(BC2);
        clsBatch2.StartMonthNumber = 3;
        clsBatch2.EndMonthNumber = 2;
        clsBatch2.execute(BC2, oppyPartners);
        clsBatch2.finish(BC2);
        
        ClsBatch_buildOpportunityMeasures clsBatch3 = new ClsBatch_buildOpportunityMeasures();
        Database.BatchableContext BC3;
        clsBatch3.query = 'Select Id from Opportunity_Partner__c limit 1';
        clsBatch3.start(BC3);
        clsBatch3.StartMonthNumber = 2;
        clsBatch3.EndMonthNumber = 1;
        clsBatch3.execute(BC3, oppyPartners);
        clsBatch3.finish(BC3); 
        
        Test.stopTest();
    }
    static testMethod void testMonthBatch() {
        
        Test.startTest();
        
        list<Opportunity_Partner__c> oppyPartners = new list<Opportunity_Partner__c>();
               
        //Build some opportunities, parts, partners, and monthly forecasts here
        Id ForecastRTOppy = [SELECT Id FROM RecordType WHERE DeveloperName = 'Opportunity' and SObjectType = 'Opportunity_Forecast__c' Limit 1].Id;
        
        //create account - set acct group code and gam code
        Account testAcct = new Account();
        testAcct = C2ForecastTestHelp.createTestAccounts();
        testAcct.ACCT_GROUP_CDE__c = '0001';
        testAcct.GAMCD__c = 'G000';
        testAcct.AccountNumber='Test Account -0001';
        insert testAcct;
        //create sales hierarchy - set gam code and type
        Sales_Hierarchy__c testHier = C2ForecastTestHelp.createTestSalesHierarchy();
        testHier.Level_7_Territory_Code__c = 'G000';
        testHier.Hierarchy_Type__c = 'Global Account Manager Hierarchy (GAM)';
        insert testHier;
        //create opportunity - set mass prod status
        Opportunity testOpp = C2ForecastTestHelp.createTestOpportunity();
        testOpp.mass_prod_status__c = true;
        testOpp.StageName = 'Won - Closed';
        testOpp.AccountId = testAcct.id;
        testOpp.Account = testAcct;
        testOpp.Probability = 10;
        insert testOpp;
        
        //create opportunity partner - set primary, allocation
        list<Opportunity_Partner__c> existingPartners = [SELECT Id, Opportunity__c, Account__c, Primary__c from Opportunity_Partner__c where opportunity__c =: testOpp.Id];
        Opportunity_Partner__c oppyPartner = existingPartners[0];//new Opportunity_Partner__c();        
        //oppyPartner.Opportunity__c = testOpp.Id;
        oppyPartner.Account__c = testAcct.Id;
        oppyPartner.Account__r = testAcct;
        //oppyPartner.Opportunity__r = testOpp;
        oppyPartner.Primary__c = true;
        oppyPartner.Allocation__c = 100;
        oppyPartner.CurrencyIsoCode = 'USD';
        update oppyPartner;        
        
        //create opportunity parts - proposal, stages
        Opportunity_Part__c oppyPart = new Opportunity_Part__c();
        oppyPart = C2ForecastTestHelp.createTestOpportunityPart();
        oppyPart.opportunity__c = testOpp.Id;
        insert oppyPart;
        
        list<String> years = new list<String>();
        years.add(string.valueOf(datetime.now().year()));
        years.add(string.valueOf(datetime.now().year() - 1));        
        years.add(string.valueOf(datetime.now().year() + 1));                
        
        list<Period> fcstPeriods = [SELECT startdate, FiscalYearSettings.Name from period where type = 'Month' and FiscalYearSettings.Name in: years order by startdate];
        //create opportunity forecasts - opportunity type - start date = current qtr start date     

        list<Opportunity_Forecast__c> fcstToAdd = new list<Opportunity_Forecast__c>();
        
        integer monthCounter = 1;
        
        for(Period p : fcstPeriods)
        {
            Opportunity_Forecast__c newFcst = new Opportunity_Forecast__c();
            newFcst.date__c = p.startdate;
            newFcst.opportunity__c = testOpp.Id;
            newFcst.opportunity__r = testOpp;
            newFcst.Amount__c = 1;
            newFcst.Fiscal_Year__c = p.FiscalYearSettings.Name;
            if(monthCounter <= 3)
            {
                newFcst.Fiscal_Quarter__c = '01';
            }   
            else if(monthCounter <= 6)
            {
                newFcst.Fiscal_Quarter__c = '02';
            }
            else if(monthCounter <= 9)
            {
                newFcst.Fiscal_Quarter__c = '03';
            }
            else
            {
                newFcst.Fiscal_Quarter__c = '04';
            }                               
            newFcst.CurrencyIsoCode = 'USD';
            newFcst.RecordTypeId = ForecastRTOppy;          
            fcstToAdd.add(newFcst); 
            
            if(monthCounter == 12) 
            {
                monthCounter = 1;
            }
            else
            {
                monthCounter = monthcounter+1;
            }           
        }       
        insert fcstToAdd;
        
        oppyPartners.add(oppyPartner);
        
        ClsBatch_buildOpportunityMeasures clsBatch = new ClsBatch_buildOpportunityMeasures();
        Database.BatchableContext BC;
        clsbatch.query = 'Select Id from Opportunity_Partner__c limit 1';        
        clsBatch.start(BC);
        clsBatch.execute(BC, oppyPartners);
        clsBatch.finish(BC);
                
        list<Overall_Measures__c> testMeasure = [SELECT Id, Gam_Code__c, Month_0__c from Overall_Measures__c Where Gam_Code__c = 'G000' limit 1];
        
        system.assert(testMeasure[0].Month_0__c == 1, 'Monthly measure value does not match expected output');
        Test.stopTest();
    }
}