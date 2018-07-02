/**
*   This test class is for CSD_Utils_Class.
*
@author Michael Cui
@created 2014-07-28
@version 1.0
*
@changelog
* 2014-07-28 
* - Created
* - Test coverage 85%
*/
@isTest(SeeAllData=true)
private class CSD_Utils_Class_Test {
  
    static testMethod void testCase1() {
       Profile p = [Select Id, Name From Profile 
                                    where Name = 'Production Support'
                                    or Name ='System Administrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        
        
        u.Email = 'helloSand0728@testCompany1407281004.com';
        u.FirstName ='Test0728';
        u.LastName = 'User0728';
        u.Alias = 'dpse0728';
        u.CommunityNickname = 'TMD0728';
        u.ProfileId = p.Id;
        u.GIBU__c = 'Appliances';
        u.Username = 'helloSand0728@testCompany1407281004.com';
        insert u;
        
        RecordType rt2 = ClsTestHelp.createTestRecordType10();
        RecordType rt = ClsTestHelp.createTestRecordType14();
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt.Id;
        acc.Type = 'Global Account';
        acc.Industry_Code_Description__c = 'Appliances';
        acc.LEVEL_1_INDUSTRY_CDE__c = '0283';
        acc.owner = u;
        insert acc;
        Account acc1 = [select Id, Customer_Industry__c from account where id =: acc.id limit 1];
        
        system.runAs(u)
        {
            Test.startTest();
            
            Opportunity oppy = new Opportunity();
            oppy.StageName = 'Approved/Active';
            oppy.AccountId = acc1.Id;
            oppy.Account = acc1;
            oppy.Name = 'SandKing';
            oppy.currency_confirm__c = true;
            oppy.CloseDate = date.today();
            oppy.Manufacturing_Start_Date__c = date.today().addMonths(1);
            oppy.RecordTypeId = rt2.Id;             
            oppy.Mass_prod_Status__c = true;
            oppy.owner = u;            
            insert oppy;
            opportunity o = [select account.Id, account.Customer_Industry__c, account.Industry_Code_Description__c, account.LEVEL_1_INDUSTRY_CDE__c,Industry_Code__c, Owner.GIBU__c from opportunity where id =: oppy.id limit 1];                                     
            system.debug('Industry_Code__c ===>' + o.Industry_Code__c + '===' + o.Owner.GIBU__c + o.account.Customer_Industry__c + '===' + o.account.LEVEL_1_INDUSTRY_CDE__c + '===' + o.account.Id);
            Product_Hierarchy__c ph = new Product_Hierarchy__c();
            ph.Hierarchy_Level_Type__c = 'CBC1';
            ph.Description__c = 'Industrial';
            insert ph;
            
            Part__c part = new Part__c();
            part.Description__c = 'Sniper';
            part.Product_Hierarchy__c = ph.Id;
            part.Market_Date__c = date.today();
            insert part;
            
            Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
            oppypart.Opportunity__c = oppy.Id;
            oppypart.Part__c = part.Id;
            insert oppypart;
            
            Opportunity_Part__c oppypart1 = ClsTestHelp.createTestOpportunityPart();
            oppypart1.Opportunity__c = oppy.Id;            
            insert oppypart1;                       
            
            List<Opportunity_Forecast__c> lst_oppyf = new List<Opportunity_Forecast__c>();
            List<Opportunity_Forecast__c> lst_oppyf1 = new List<Opportunity_Forecast__c>();
            Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast.Opportunity__c = oppy.Id;
            oppyForecast.Quantity__c = 12;
            oppyForecast.Part__c = oppypart.Id;
            oppyForecast.Fiscal_Year__c = String.valueOf(date.today().year());
            oppyForecast.Fiscal_Quarter__c = '4';
            oppyForecast.Date__c = date.today().addMonths(1);
            oppyForecast.Amount__c = 1;
            lst_oppyf.add(oppyForecast);
            
            Opportunity_Forecast__c oppyForecast1 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast1.Opportunity__c = oppy.Id;
            oppyForecast1.Quantity__c = 12;
            oppyForecast1.Part__c = oppypart.Id;
            oppyForecast1.Fiscal_Year__c = String.valueOf(date.today().year()+1);
            oppyForecast1.Fiscal_Quarter__c = '1';
            oppyForecast1.Date__c = date.today().addMonths(1);
            oppyForecast1.Amount__c = 1;
            lst_oppyf.add(oppyForecast1);
            
            Opportunity_Forecast__c oppyForecast2 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast2.Opportunity__c = oppy.Id;
            oppyForecast2.Quantity__c = 12;
            oppyForecast2.Part__c = oppypart.Id;
            oppyForecast2.Fiscal_Year__c = String.valueOf(date.today().year()+1);
            oppyForecast2.Fiscal_Quarter__c = '2';
            oppyForecast2.Date__c = date.today().addMonths(1);
            oppyForecast2.Amount__c = 1;
            lst_oppyf.add(oppyForecast2);
            
            Opportunity_Forecast__c oppyForecast3 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast3.Opportunity__c = oppy.Id;
            oppyForecast3.Quantity__c = 12;
            oppyForecast3.Part__c = oppypart.Id;
            oppyForecast3.Fiscal_Year__c = String.valueOf(date.today().year()+1);
            oppyForecast3.Fiscal_Quarter__c = '3';
            oppyForecast3.Date__c = date.today().addMonths(1);
            oppyForecast3.Amount__c = 1;
            lst_oppyf.add(oppyForecast3);
            
            Opportunity_Forecast__c oppyForecast4 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast4.Opportunity__c = oppy.Id;
            oppyForecast4.Quantity__c = 12;
            oppyForecast4.Part__c = oppypart.Id;
            oppyForecast4.Fiscal_Year__c = String.valueOf(date.today().year()+1);
            oppyForecast4.Fiscal_Quarter__c = '4';
            oppyForecast4.Date__c = date.today().addMonths(1);
            oppyForecast4.Amount__c = 1;
            lst_oppyf.add(oppyForecast4);
            
            Opportunity_Forecast__c oppyForecast5 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast5.Opportunity__c = oppy.Id;
            oppyForecast5.Quantity__c = 12;
            oppyForecast5.Part__c = oppypart.Id;
            oppyForecast5.Fiscal_Year__c = String.valueOf(date.today().year()+2);
            oppyForecast5.Fiscal_Quarter__c = '1';
            oppyForecast5.Date__c = date.today().addMonths(1);
            oppyForecast5.Amount__c = 1;
            lst_oppyf.add(oppyForecast5);
            
            Opportunity_Forecast__c oppyForecast6 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast6.Opportunity__c = oppy.Id;
            oppyForecast6.Quantity__c = 12;
            oppyForecast6.Part__c = oppypart.Id;
            oppyForecast6.Fiscal_Year__c = String.valueOf(date.today().year()+2);
            oppyForecast6.Fiscal_Quarter__c = '2';
            oppyForecast6.Date__c = date.today().addMonths(1);
            oppyForecast6.Amount__c = 1;
            lst_oppyf.add(oppyForecast6);
            
            Opportunity_Forecast__c oppyForecast7 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast7.Opportunity__c = oppy.Id;
            oppyForecast7.Quantity__c = 12;
            oppyForecast7.Part__c = oppypart.Id;
            oppyForecast7.Fiscal_Year__c = String.valueOf(date.today().year()+2);
            oppyForecast7.Fiscal_Quarter__c = '3';
            oppyForecast7.Date__c = date.today().addMonths(1);
            oppyForecast7.Amount__c = 1;
            lst_oppyf.add(oppyForecast7);
            
            Opportunity_Forecast__c oppyForecast8 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast8.Opportunity__c = oppy.Id;
            oppyForecast8.Quantity__c = 12;
            oppyForecast8.Part__c = oppypart.Id;
            oppyForecast8.Fiscal_Year__c = String.valueOf(date.today().year()+2);
            oppyForecast8.Fiscal_Quarter__c = '4';
            oppyForecast8.Date__c = date.today().addMonths(1);
            oppyForecast8.Amount__c = 1;
            lst_oppyf.add(oppyForecast8);
            
            Opportunity_Forecast__c oppyForecast9 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast9.Opportunity__c = oppy.Id;
            oppyForecast9.Quantity__c = 12;
            oppyForecast9.Part__c = oppypart.Id;
            oppyForecast9.Fiscal_Year__c = String.valueOf(date.today().year()+3);
            oppyForecast9.Fiscal_Quarter__c = '1';
            oppyForecast9.Date__c = date.today().addMonths(1);
            oppyForecast9.Amount__c = 1;
            lst_oppyf.add(oppyForecast9);
            
            Opportunity_Forecast__c oppyForecast10 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast10.Opportunity__c = oppy.Id;
            oppyForecast10.Quantity__c = 12;
            oppyForecast10.Part__c = oppypart.Id;
            oppyForecast10.Fiscal_Year__c = String.valueOf(date.today().year()+3);
            oppyForecast10.Fiscal_Quarter__c = '2';
            oppyForecast10.Date__c = date.today().addMonths(1);
            oppyForecast10.Amount__c = 1;
            lst_oppyf.add(oppyForecast10);
            
            Opportunity_Forecast__c oppyForecast11 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast11.Opportunity__c = oppy.Id;
            oppyForecast11.Quantity__c = 12;
            oppyForecast11.Part__c = oppypart.Id;
            oppyForecast11.Fiscal_Year__c = String.valueOf(date.today().year()+3);
            oppyForecast11.Fiscal_Quarter__c = '3';
            oppyForecast11.Date__c = date.today().addMonths(1);
            oppyForecast11.Amount__c = 1;
            lst_oppyf.add(oppyForecast11);
            
            Opportunity_Forecast__c oppyForecast12 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast12.Opportunity__c = oppy.Id;
            oppyForecast12.Quantity__c = 12;
            oppyForecast12.Part__c = oppypart.Id;
            oppyForecast12.Fiscal_Year__c = String.valueOf(date.today().year()+3);
            oppyForecast12.Fiscal_Quarter__c = '4';
            oppyForecast12.Date__c = date.today().addMonths(1);
            oppyForecast12.Amount__c = 1;
            lst_oppyf.add(oppyForecast12);
            
            Opportunity_Forecast__c oppyForecast13 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast13.Opportunity__c = oppy.Id;
            oppyForecast13.Quantity__c = 12;
            oppyForecast13.Part__c = oppypart.Id;
            oppyForecast13.Fiscal_Year__c = String.valueOf(date.today().year()+4);
            oppyForecast13.Fiscal_Quarter__c = '1';
            oppyForecast13.Date__c = date.today().addMonths(1);
            oppyForecast13.Amount__c = 1;
            lst_oppyf.add(oppyForecast13);
            
            Opportunity_Forecast__c oppyForecast14 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast14.Opportunity__c = oppy.Id;
            oppyForecast14.Quantity__c = 12;
            oppyForecast14.Part__c = oppypart.Id;
            oppyForecast14.Fiscal_Year__c = String.valueOf(date.today().year()+4);
            oppyForecast14.Fiscal_Quarter__c = '2';
            oppyForecast14.Date__c = date.today().addMonths(1);
            oppyForecast14.Amount__c = 1;
            lst_oppyf.add(oppyForecast14);
            
            Opportunity_Forecast__c oppyForecast15 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast15.Opportunity__c = oppy.Id;
            oppyForecast15.Quantity__c = 12;
            oppyForecast15.Part__c = oppypart.Id;
            oppyForecast15.Fiscal_Year__c = String.valueOf(date.today().year()+4);
            oppyForecast15.Fiscal_Quarter__c = '3';
            oppyForecast15.Date__c = date.today().addMonths(1);
            oppyForecast15.Amount__c = 1;
            lst_oppyf.add(oppyForecast15);
            
            Opportunity_Forecast__c oppyForecast16 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast16.Opportunity__c = oppy.Id;
            oppyForecast16.Quantity__c = 12;
            oppyForecast16.Part__c = oppypart.Id;
            oppyForecast16.Fiscal_Year__c = String.valueOf(date.today().year()+4);
            oppyForecast16.Fiscal_Quarter__c = '4';
            oppyForecast16.Date__c = date.today().addMonths(1);
            oppyForecast16.Amount__c = 1;
            lst_oppyf.add(oppyForecast16);
            
            Opportunity_Forecast__c oppyForecast17 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast17.Opportunity__c = oppy.Id;
            oppyForecast17.Quantity__c = 12;
            oppyForecast17.Part__c = oppypart.Id;
            oppyForecast17.Fiscal_Year__c = String.valueOf(date.today().year()+5);
            oppyForecast17.Fiscal_Quarter__c = '1';
            oppyForecast17.Date__c = date.today().addMonths(1);
            oppyForecast17.Amount__c = 1;
            lst_oppyf.add(oppyForecast17);
            
            Opportunity_Forecast__c oppyForecast18 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast18.Opportunity__c = oppy.Id;
            oppyForecast18.Quantity__c = 12;
            oppyForecast18.Part__c = oppypart.Id;
            oppyForecast18.Fiscal_Year__c = String.valueOf(date.today().year()+5);
            oppyForecast18.Fiscal_Quarter__c = '2';
            oppyForecast18.Date__c = date.today().addMonths(1);
            oppyForecast18.Amount__c = 1;
            lst_oppyf.add(oppyForecast18);
            
            Opportunity_Forecast__c oppyForecast19 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast19.Opportunity__c = oppy.Id;
            oppyForecast19.Quantity__c = 12;
            oppyForecast19.Part__c = oppypart.Id;
            oppyForecast19.Fiscal_Year__c = String.valueOf(date.today().year()+5);
            oppyForecast19.Fiscal_Quarter__c = '3';
            oppyForecast19.Date__c = date.today().addMonths(1);
            oppyForecast19.Amount__c = 1;
            lst_oppyf.add(oppyForecast19);
            
            Opportunity_Forecast__c oppyForecast20 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast20.Opportunity__c = oppy.Id;
            oppyForecast20.Quantity__c = 12;
            oppyForecast20.Part__c = oppypart.Id;
            oppyForecast20.Fiscal_Year__c = String.valueOf(date.today().year()+5);
            oppyForecast20.Fiscal_Quarter__c = '4';
            oppyForecast20.Date__c = date.today().addMonths(1);
            oppyForecast20.Amount__c = 1;
            lst_oppyf.add(oppyForecast20);
            
            Opportunity_Forecast__c oppyForecast51 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast51.Opportunity__c = oppy.Id;
            oppyForecast51.Quantity__c = 12;
            oppyForecast51.Part__c = oppypart1.Id;
            oppyForecast51.Fiscal_Year__c = String.valueOf(date.today().year());
            oppyForecast51.Fiscal_Quarter__c = '4';
            oppyForecast51.Date__c = date.today().addMonths(1);
            oppyForecast51.Amount__c = 1;
            lst_oppyf1.add(oppyForecast51);
            
            Opportunity_Forecast__c oppyForecast21 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast21.Opportunity__c = oppy.Id;
            oppyForecast21.Quantity__c = 12;
            oppyForecast21.Part__c = oppypart1.Id;
            oppyForecast21.Fiscal_Year__c = String.valueOf(date.today().year()+1);
            oppyForecast21.Fiscal_Quarter__c = '1';
            oppyForecast21.Date__c = date.today().addMonths(1);
            oppyForecast21.Amount__c = 1;
            lst_oppyf1.add(oppyForecast21);
            
            Opportunity_Forecast__c oppyForecast22 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast22.Opportunity__c = oppy.Id;
            oppyForecast22.Quantity__c = 12;
            oppyForecast22.Part__c = oppypart1.Id;
            oppyForecast22.Fiscal_Year__c = String.valueOf(date.today().year()+1);
            oppyForecast22.Fiscal_Quarter__c = '2';
            oppyForecast22.Date__c = date.today().addMonths(1);
            oppyForecast22.Amount__c = 1;
            lst_oppyf1.add(oppyForecast22);
            
            Opportunity_Forecast__c oppyForecast23 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast23.Opportunity__c = oppy.Id;
            oppyForecast23.Quantity__c = 12;
            oppyForecast23.Part__c = oppypart1.Id;
            oppyForecast23.Fiscal_Year__c = String.valueOf(date.today().year()+1);
            oppyForecast23.Fiscal_Quarter__c = '3';
            oppyForecast23.Date__c = date.today().addMonths(1);
            oppyForecast23.Amount__c = 1;
            lst_oppyf1.add(oppyForecast23);
            
            Opportunity_Forecast__c oppyForecast24 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast24.Opportunity__c = oppy.Id;
            oppyForecast24.Quantity__c = 12;
            oppyForecast24.Part__c = oppypart1.Id;
            oppyForecast24.Fiscal_Year__c = String.valueOf(date.today().year()+1);
            oppyForecast24.Fiscal_Quarter__c = '4';
            oppyForecast24.Date__c = date.today().addMonths(1);
            oppyForecast24.Amount__c = 1;
            lst_oppyf1.add(oppyForecast24);
            
            Opportunity_Forecast__c oppyForecast25 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast25.Opportunity__c = oppy.Id;
            oppyForecast25.Quantity__c = 12;
            oppyForecast25.Part__c = oppypart1.Id;
            oppyForecast25.Fiscal_Year__c = String.valueOf(date.today().year()+2);
            oppyForecast25.Fiscal_Quarter__c = '1';
            oppyForecast25.Date__c = date.today().addMonths(1);
            oppyForecast25.Amount__c = 1;
            lst_oppyf1.add(oppyForecast25);
            
            Opportunity_Forecast__c oppyForecast26 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast26.Opportunity__c = oppy.Id;
            oppyForecast26.Quantity__c = 12;
            oppyForecast26.Part__c = oppypart1.Id;
            oppyForecast26.Fiscal_Year__c = String.valueOf(date.today().year()+2);
            oppyForecast26.Fiscal_Quarter__c = '2';
            oppyForecast26.Date__c = date.today().addMonths(1);
            oppyForecast26.Amount__c = 1;
            lst_oppyf1.add(oppyForecast26);
            
            Opportunity_Forecast__c oppyForecast27 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast27.Opportunity__c = oppy.Id;
            oppyForecast27.Quantity__c = 12;
            oppyForecast27.Part__c = oppypart1.Id;
            oppyForecast27.Fiscal_Year__c = String.valueOf(date.today().year()+2);
            oppyForecast27.Fiscal_Quarter__c = '3';
            oppyForecast27.Date__c = date.today().addMonths(1);
            oppyForecast27.Amount__c = 1;
            lst_oppyf1.add(oppyForecast27);
            
            Opportunity_Forecast__c oppyForecast28 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast28.Opportunity__c = oppy.Id;
            oppyForecast28.Quantity__c = 12;
            oppyForecast28.Part__c = oppypart1.Id;
            oppyForecast28.Fiscal_Year__c = String.valueOf(date.today().year()+2);
            oppyForecast28.Fiscal_Quarter__c = '4';
            oppyForecast28.Date__c = date.today().addMonths(1);
            oppyForecast28.Amount__c = 1;
            lst_oppyf1.add(oppyForecast28);
            
            Opportunity_Forecast__c oppyForecast29 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast29.Opportunity__c = oppy.Id;
            oppyForecast29.Quantity__c = 12;
            oppyForecast29.Part__c = oppypart1.Id;
            oppyForecast29.Fiscal_Year__c = String.valueOf(date.today().year()+3);
            oppyForecast29.Fiscal_Quarter__c = '1';
            oppyForecast29.Date__c = date.today().addMonths(1);
            oppyForecast29.Amount__c = 1;
            lst_oppyf1.add(oppyForecast29);
            
            Opportunity_Forecast__c oppyForecast30 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast30.Opportunity__c = oppy.Id;
            oppyForecast30.Quantity__c = 12;
            oppyForecast30.Part__c = oppypart1.Id;
            oppyForecast30.Fiscal_Year__c = String.valueOf(date.today().year()+3);
            oppyForecast30.Fiscal_Quarter__c = '2';
            oppyForecast30.Date__c = date.today().addMonths(1);
            oppyForecast30.Amount__c = 1;
            lst_oppyf1.add(oppyForecast30);
            
            Opportunity_Forecast__c oppyForecast31 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast31.Opportunity__c = oppy.Id;
            oppyForecast31.Quantity__c = 12;
            oppyForecast31.Part__c = oppypart1.Id;
            oppyForecast31.Fiscal_Year__c = String.valueOf(date.today().year()+3);
            oppyForecast31.Fiscal_Quarter__c = '3';
            oppyForecast31.Date__c = date.today().addMonths(1);
            oppyForecast31.Amount__c = 1;
            lst_oppyf1.add(oppyForecast31);
            
            Opportunity_Forecast__c oppyForecast32 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast32.Opportunity__c = oppy.Id;
            oppyForecast32.Quantity__c = 12;
            oppyForecast32.Part__c = oppypart1.Id;
            oppyForecast32.Fiscal_Year__c = String.valueOf(date.today().year()+3);
            oppyForecast32.Fiscal_Quarter__c = '4';
            oppyForecast32.Date__c = date.today().addMonths(1);
            oppyForecast32.Amount__c = 1;
            lst_oppyf1.add(oppyForecast32);
            
            Opportunity_Forecast__c oppyForecast33 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast33.Opportunity__c = oppy.Id;
            oppyForecast33.Quantity__c = 12;
            oppyForecast33.Part__c = oppypart1.Id;
            oppyForecast33.Fiscal_Year__c = String.valueOf(date.today().year()+4);
            oppyForecast33.Fiscal_Quarter__c = '1';
            oppyForecast33.Date__c = date.today().addMonths(1);
            oppyForecast33.Amount__c = 1;
            lst_oppyf1.add(oppyForecast33);
            
            Opportunity_Forecast__c oppyForecast34 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast34.Opportunity__c = oppy.Id;
            oppyForecast34.Quantity__c = 12;
            oppyForecast34.Part__c = oppypart1.Id;
            oppyForecast34.Fiscal_Year__c = String.valueOf(date.today().year()+4);
            oppyForecast34.Fiscal_Quarter__c = '2';
            oppyForecast34.Date__c = date.today().addMonths(1);
            oppyForecast34.Amount__c = 1;
            lst_oppyf1.add(oppyForecast34);
            
            Opportunity_Forecast__c oppyForecast35 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast35.Opportunity__c = oppy.Id;
            oppyForecast35.Quantity__c = 12;
            oppyForecast35.Part__c = oppypart1.Id;
            oppyForecast35.Fiscal_Year__c = String.valueOf(date.today().year()+4);
            oppyForecast35.Fiscal_Quarter__c = '3';
            oppyForecast35.Date__c = date.today().addMonths(1);
            oppyForecast35.Amount__c = 1;
            lst_oppyf1.add(oppyForecast35);
            
            Opportunity_Forecast__c oppyForecast36 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast36.Opportunity__c = oppy.Id;
            oppyForecast36.Quantity__c = 12;
            oppyForecast36.Part__c = oppypart1.Id;
            oppyForecast36.Fiscal_Year__c = String.valueOf(date.today().year()+4);
            oppyForecast36.Fiscal_Quarter__c = '4';
            oppyForecast36.Date__c = date.today().addMonths(1);
            oppyForecast36.Amount__c = 1;
            lst_oppyf1.add(oppyForecast36);
            
            Opportunity_Forecast__c oppyForecast37 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast37.Opportunity__c = oppy.Id;
            oppyForecast37.Quantity__c = 12;
            oppyForecast37.Part__c = oppypart1.Id;
            oppyForecast37.Fiscal_Year__c = String.valueOf(date.today().year()+5);
            oppyForecast37.Fiscal_Quarter__c = '1';
            oppyForecast37.Date__c = date.today().addMonths(1);
            oppyForecast37.Amount__c = 1;
            lst_oppyf1.add(oppyForecast37);
            
            Opportunity_Forecast__c oppyForecast38 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast38.Opportunity__c = oppy.Id;
            oppyForecast38.Quantity__c = 12;
            oppyForecast38.Part__c = oppypart1.Id;
            oppyForecast38.Fiscal_Year__c = String.valueOf(date.today().year()+5);
            oppyForecast38.Fiscal_Quarter__c = '2';
            oppyForecast38.Date__c = date.today().addMonths(1);
            oppyForecast38.Amount__c = 1;
            lst_oppyf1.add(oppyForecast38);
            
            Opportunity_Forecast__c oppyForecast39 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast39.Opportunity__c = oppy.Id;
            oppyForecast39.Quantity__c = 12;
            oppyForecast39.Part__c = oppypart1.Id;
            oppyForecast39.Fiscal_Year__c = String.valueOf(date.today().year()+5);
            oppyForecast39.Fiscal_Quarter__c = '3';
            oppyForecast39.Date__c = date.today().addMonths(1);
            oppyForecast39.Amount__c = 1;
            lst_oppyf1.add(oppyForecast39);
            
            Opportunity_Forecast__c oppyForecast40 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast40.Opportunity__c = oppy.Id;
            oppyForecast40.Quantity__c = 12;
            oppyForecast40.Part__c = oppypart1.Id;
            oppyForecast40.Fiscal_Year__c = String.valueOf(date.today().year()+5);
            oppyForecast40.Fiscal_Quarter__c = '4';
            oppyForecast40.Date__c = date.today().addMonths(1);
            oppyForecast40.Amount__c = 1;
            lst_oppyf1.add(oppyForecast40);
            
            insert lst_oppyf;
            insert lst_oppyf1;
            
            oppy.Manufacturing_Start_Date__c = date.today().addMonths(2);            
            update oppy;
            
            part.Market_Date__c = date.today().addMonths(1);
            update part;
            Test.stopTest();
        }
    }
    static testMethod void testCase2() {
       Profile p = [Select Id, Name From Profile 
                                    where Name = 'Production Support'                                     
                                    or Name ='System Administrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        
        
        u.Email = 'helloSand0808@testCompany1407281004.com';
        u.FirstName ='Test0828';
        u.LastName = 'User0828';
        u.Alias = 'dpse0828';
        u.CommunityNickname = 'TMD0828';
        u.ProfileId = p.Id;
        u.GIBU__c = 'Appliances';
        u.Username = 'helloSand0808@testCompany1407281004.com';
        insert u;        
        
        RecordType rt2 = ClsTestHelp.createTestRecordType10();
        RecordType rt = ClsTestHelp.createTestRecordType14();
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt.Id;
        acc.Type = 'Global Account';
        acc.Industry_Code_Description__c = 'Appliances';
        acc.LEVEL_1_INDUSTRY_CDE__c = '0283';
        acc.owner = u;
        insert acc;
        Account acc1 = [select Id, Customer_Industry__c from account where id =: acc.id limit 1];
        
        system.runAs(u)
        {
            Test.startTest();
            
            Opportunity oppy = new Opportunity();
            oppy.StageName = 'Approved/Active';
            oppy.AccountId = acc1.Id;
            oppy.Account = acc1;
            oppy.Name = 'SandKing';
            oppy.CloseDate = date.today();
            oppy.Manufacturing_Start_Date__c = date.today().addMonths(1);
            oppy.RecordTypeId = rt2.Id;            
            oppy.currency_confirm__c = true;
            oppy.Mass_prod_Status__c = true;
            oppy.owner = u;            
            insert oppy;
            opportunity o = [select account.Id, account.Customer_Industry__c, account.Industry_Code_Description__c, account.LEVEL_1_INDUSTRY_CDE__c,Industry_Code__c, Owner.GIBU__c from opportunity where id =: oppy.id limit 1];                                     
            
            Product_Hierarchy__c ph = new Product_Hierarchy__c();
            ph.Hierarchy_Level_Type__c = 'CBC1';
            ph.Description__c = 'Industrial';
            insert ph;
            
            Part__c part = new Part__c();
            part.Description__c = 'Sniper';
            part.Product_Hierarchy__c = ph.Id;            
            insert part;
            
            Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
            oppypart.Opportunity__c = oppy.Id;
            oppypart.Part__c = part.Id;
            oppypart.Initial_Order_Date__c = date.today().addMonths(1);
            insert oppypart;                                              
            
            List<Opportunity_Forecast__c> lst_oppyf = new List<Opportunity_Forecast__c>();
            List<Opportunity_Forecast__c> lst_oppyf1 = new List<Opportunity_Forecast__c>();
            Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast.Opportunity__c = oppy.Id;
            oppyForecast.Quantity__c = 12;
            oppyForecast.Part__c = oppypart.Id;
            oppyForecast.Fiscal_Year__c = String.valueOf(date.today().year());
            oppyForecast.Fiscal_Quarter__c = '4';
            oppyForecast.Date__c = date.today().addMonths(1);
            oppyForecast.Amount__c = 1;
            lst_oppyf.add(oppyForecast);
            
            Opportunity_Forecast__c oppyForecast1 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast1.Opportunity__c = oppy.Id;
            oppyForecast1.Quantity__c = 12;
            oppyForecast1.Part__c = oppypart.Id;
            oppyForecast1.Fiscal_Year__c = String.valueOf(date.today().year()+1);
            oppyForecast1.Fiscal_Quarter__c = '1';
            oppyForecast1.Date__c = date.today().addMonths(1);
            oppyForecast1.Amount__c = 1;
            lst_oppyf.add(oppyForecast1);
            
            Opportunity_Forecast__c oppyForecast2 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast2.Opportunity__c = oppy.Id;
            oppyForecast2.Quantity__c = 12;
            oppyForecast2.Part__c = oppypart.Id;
            oppyForecast2.Fiscal_Year__c = String.valueOf(date.today().year()+1);
            oppyForecast2.Fiscal_Quarter__c = '2';
            oppyForecast2.Date__c = date.today().addMonths(1);
            oppyForecast2.Amount__c = 1;
            lst_oppyf.add(oppyForecast2);
            
            Opportunity_Forecast__c oppyForecast3 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast3.Opportunity__c = oppy.Id;
            oppyForecast3.Quantity__c = 12;
            oppyForecast3.Part__c = oppypart.Id;
            oppyForecast3.Fiscal_Year__c = String.valueOf(date.today().year()+1);
            oppyForecast3.Fiscal_Quarter__c = '3';
            oppyForecast3.Date__c = date.today().addMonths(1);
            oppyForecast3.Amount__c = 1;
            lst_oppyf.add(oppyForecast3);
            
            Opportunity_Forecast__c oppyForecast4 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast4.Opportunity__c = oppy.Id;
            oppyForecast4.Quantity__c = 12;
            oppyForecast4.Part__c = oppypart.Id;
            oppyForecast4.Fiscal_Year__c = String.valueOf(date.today().year()+1);
            oppyForecast4.Fiscal_Quarter__c = '4';
            oppyForecast4.Date__c = date.today().addMonths(1);
            oppyForecast4.Amount__c = 1;
            lst_oppyf.add(oppyForecast4);
            
            Opportunity_Forecast__c oppyForecast5 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast5.Opportunity__c = oppy.Id;
            oppyForecast5.Quantity__c = 12;
            oppyForecast5.Part__c = oppypart.Id;
            oppyForecast5.Fiscal_Year__c = String.valueOf(date.today().year()+2);
            oppyForecast5.Fiscal_Quarter__c = '1';
            oppyForecast5.Date__c = date.today().addMonths(1);
            oppyForecast5.Amount__c = 1;
            lst_oppyf.add(oppyForecast5);
            
            Opportunity_Forecast__c oppyForecast6 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast6.Opportunity__c = oppy.Id;
            oppyForecast6.Quantity__c = 12;
            oppyForecast6.Part__c = oppypart.Id;
            oppyForecast6.Fiscal_Year__c = String.valueOf(date.today().year()+2);
            oppyForecast6.Fiscal_Quarter__c = '2';
            oppyForecast6.Date__c = date.today().addMonths(1);
            oppyForecast6.Amount__c = 1;
            lst_oppyf.add(oppyForecast6);
            
            Opportunity_Forecast__c oppyForecast7 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast7.Opportunity__c = oppy.Id;
            oppyForecast7.Quantity__c = 12;
            oppyForecast7.Part__c = oppypart.Id;
            oppyForecast7.Fiscal_Year__c = String.valueOf(date.today().year()+2);
            oppyForecast7.Fiscal_Quarter__c = '3';
            oppyForecast7.Date__c = date.today().addMonths(1);
            oppyForecast7.Amount__c = 1;
            lst_oppyf.add(oppyForecast7);
            
            Opportunity_Forecast__c oppyForecast8 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast8.Opportunity__c = oppy.Id;
            oppyForecast8.Quantity__c = 12;
            oppyForecast8.Part__c = oppypart.Id;
            oppyForecast8.Fiscal_Year__c = String.valueOf(date.today().year()+2);
            oppyForecast8.Fiscal_Quarter__c = '4';
            oppyForecast8.Date__c = date.today().addMonths(1);
            oppyForecast8.Amount__c = 1;
            lst_oppyf.add(oppyForecast8);
            
            Opportunity_Forecast__c oppyForecast9 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast9.Opportunity__c = oppy.Id;
            oppyForecast9.Quantity__c = 12;
            oppyForecast9.Part__c = oppypart.Id;
            oppyForecast9.Fiscal_Year__c = String.valueOf(date.today().year()+3);
            oppyForecast9.Fiscal_Quarter__c = '1';
            oppyForecast9.Date__c = date.today().addMonths(1);
            oppyForecast9.Amount__c = 1;
            lst_oppyf.add(oppyForecast9);
            
            Opportunity_Forecast__c oppyForecast10 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast10.Opportunity__c = oppy.Id;
            oppyForecast10.Quantity__c = 12;
            oppyForecast10.Part__c = oppypart.Id;
            oppyForecast10.Fiscal_Year__c = String.valueOf(date.today().year()+3);
            oppyForecast10.Fiscal_Quarter__c = '2';
            oppyForecast10.Date__c = date.today().addMonths(1);
            oppyForecast10.Amount__c = 1;
            lst_oppyf.add(oppyForecast10);
            
            Opportunity_Forecast__c oppyForecast11 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast11.Opportunity__c = oppy.Id;
            oppyForecast11.Quantity__c = 12;
            oppyForecast11.Part__c = oppypart.Id;
            oppyForecast11.Fiscal_Year__c = String.valueOf(date.today().year()+3);
            oppyForecast11.Fiscal_Quarter__c = '3';
            oppyForecast11.Date__c = date.today().addMonths(1);
            oppyForecast11.Amount__c = 1;
            lst_oppyf.add(oppyForecast11);
            
            Opportunity_Forecast__c oppyForecast12 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast12.Opportunity__c = oppy.Id;
            oppyForecast12.Quantity__c = 12;
            oppyForecast12.Part__c = oppypart.Id;
            oppyForecast12.Fiscal_Year__c = String.valueOf(date.today().year()+3);
            oppyForecast12.Fiscal_Quarter__c = '4';
            oppyForecast12.Date__c = date.today().addMonths(1);
            oppyForecast12.Amount__c = 1;
            lst_oppyf.add(oppyForecast12);
            
            Opportunity_Forecast__c oppyForecast13 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast13.Opportunity__c = oppy.Id;
            oppyForecast13.Quantity__c = 12;
            oppyForecast13.Part__c = oppypart.Id;
            oppyForecast13.Fiscal_Year__c = String.valueOf(date.today().year()+4);
            oppyForecast13.Fiscal_Quarter__c = '1';
            oppyForecast13.Date__c = date.today().addMonths(1);
            oppyForecast13.Amount__c = 1;
            lst_oppyf.add(oppyForecast13);
            
            Opportunity_Forecast__c oppyForecast14 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast14.Opportunity__c = oppy.Id;
            oppyForecast14.Quantity__c = 12;
            oppyForecast14.Part__c = oppypart.Id;
            oppyForecast14.Fiscal_Year__c = String.valueOf(date.today().year()+4);
            oppyForecast14.Fiscal_Quarter__c = '2';
            oppyForecast14.Date__c = date.today().addMonths(1);
            oppyForecast14.Amount__c = 1;
            lst_oppyf.add(oppyForecast14);
            
            Opportunity_Forecast__c oppyForecast15 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast15.Opportunity__c = oppy.Id;
            oppyForecast15.Quantity__c = 12;
            oppyForecast15.Part__c = oppypart.Id;
            oppyForecast15.Fiscal_Year__c = String.valueOf(date.today().year()+4);
            oppyForecast15.Fiscal_Quarter__c = '3';
            oppyForecast15.Date__c = date.today().addMonths(1);
            oppyForecast15.Amount__c = 1;
            lst_oppyf.add(oppyForecast15);
            
            Opportunity_Forecast__c oppyForecast16 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast16.Opportunity__c = oppy.Id;
            oppyForecast16.Quantity__c = 12;
            oppyForecast16.Part__c = oppypart.Id;
            oppyForecast16.Fiscal_Year__c = String.valueOf(date.today().year()+4);
            oppyForecast16.Fiscal_Quarter__c = '4';
            oppyForecast16.Date__c = date.today().addMonths(1);
            oppyForecast16.Amount__c = 1;
            lst_oppyf.add(oppyForecast16);
            
            Opportunity_Forecast__c oppyForecast17 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast17.Opportunity__c = oppy.Id;
            oppyForecast17.Quantity__c = 12;
            oppyForecast17.Part__c = oppypart.Id;
            oppyForecast17.Fiscal_Year__c = String.valueOf(date.today().year()+5);
            oppyForecast17.Fiscal_Quarter__c = '1';
            oppyForecast17.Date__c = date.today().addMonths(1);
            oppyForecast17.Amount__c = 1;
            lst_oppyf.add(oppyForecast17);
            
            Opportunity_Forecast__c oppyForecast18 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast18.Opportunity__c = oppy.Id;
            oppyForecast18.Quantity__c = 12;
            oppyForecast18.Part__c = oppypart.Id;
            oppyForecast18.Fiscal_Year__c = String.valueOf(date.today().year()+5);
            oppyForecast18.Fiscal_Quarter__c = '2';
            oppyForecast18.Date__c = date.today().addMonths(1);
            oppyForecast18.Amount__c = 1;
            lst_oppyf.add(oppyForecast18);
            
            Opportunity_Forecast__c oppyForecast19 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast19.Opportunity__c = oppy.Id;
            oppyForecast19.Quantity__c = 12;
            oppyForecast19.Part__c = oppypart.Id;
            oppyForecast19.Fiscal_Year__c = String.valueOf(date.today().year()+5);
            oppyForecast19.Fiscal_Quarter__c = '3';
            oppyForecast19.Date__c = date.today().addMonths(1);
            oppyForecast19.Amount__c = 1;
            lst_oppyf.add(oppyForecast19);
            
            Opportunity_Forecast__c oppyForecast20 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast20.Opportunity__c = oppy.Id;
            oppyForecast20.Quantity__c = 12;
            oppyForecast20.Part__c = oppypart.Id;
            oppyForecast20.Fiscal_Year__c = String.valueOf(date.today().year()+5);
            oppyForecast20.Fiscal_Quarter__c = '4';
            oppyForecast20.Date__c = date.today().addMonths(1);
            oppyForecast20.Amount__c = 1;            
            lst_oppyf.add(oppyForecast20);                        
            
            insert lst_oppyf;
                        
            oppypart.Initial_Order_Date__c = date.today().addMonths(2);
            update oppypart;
            
            Test.stopTest();
        }
    }             
}