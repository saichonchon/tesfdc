/**
*  This test class used to Cls_BatchCalculateForecastBilling.
*
@author Jinbo Shan
@created 2014-11-12
@version 1.0   
@since 30.0
*
@changelog
* coverage  78%
* 
* 
2014-11-12 Jinbo Shan <jinbo.shan@itbconsult.com>
* - Created
* 2017-1-12 Pavan T <pavan.temididepati@te.com>
* - Modified for Case 901115
*/
@isTest(seeAllData=false) 
private class Cls_BatchCalculateForecastBilling_Test {
    
    static String currentYear;
    static Integer currentMonth;
    static Integer currentQuarter;
    static Date startDate;
    static String currentMonthString;
    static String oppyStageName;
    static RecordType rt3;
    
    static{
        rt3 = ClsTestHelp.createTestRecordType10();
        map<String, Integer> MAP_MONTHLABELNUMBER = new map<String, Integer>{
            'Jan' => 4, 'Feb' => 5, 'Mar' => 6, 'Apr' => 7, 'May' => 8, 'Jun' => 9,
            'Jul' => 10, 'Aug' => 11, 'Sep' => 12, 'Oct' => 1, 'Nov' => 2, 'Dec' => 3
        };
        map<Integer, String> MAP_NUMBERMONTHLABEL = new map<Integer, String>{
            4 => 'Jan', 5 => 'Feb', 6 => 'Mar', 7 => 'Apr', 8 => 'May', 9 => 'Jun',
            10 => 'Jul', 11 => 'Aug', 12 => 'Sep', 1 => 'Oct', 2 => 'Nov', 3 => 'Dec'
        };
        list<Forecast_Snapshot_Setup__c> list_fsss = new list<Forecast_Snapshot_Setup__c>();
        Forecast_Snapshot_Setup__c fssTemp;
        for(Forecast_Snapshot_Setup__c fss : [select Name, Value__c from Forecast_Snapshot_Setup__c where Name='Opportunity Stage']) {
            fssTemp = fss;
        }
        if(fssTemp == null) {
            fssTemp = new Forecast_Snapshot_Setup__c();
            fssTemp.Name = 'Opportunity Stage';
            fssTemp.Value__c = 'Won';
            list_fsss.add(fssTemp);
        }
        
        Forecast_Snapshot_Setup__c fssTemp1;
        for(Forecast_Snapshot_Setup__c fss : [select Name, Value__c from Forecast_Snapshot_Setup__c where Name='Approval Stage']) {
            fssTemp1 = fss;
        }
        if(fssTemp1 == null) {
            fssTemp1 = new Forecast_Snapshot_Setup__c();
            fssTemp1.Name = 'Approval Stage';
            fssTemp1.Value__c = 'G0 Approved';
            list_fsss.add(fssTemp1);
        }
        insert list_fsss;
        
        for (Period period : [select Id, FiscalYearSettings.Name, PeriodLabel 
                        from Period where StartDate <= Today and EndDate >= Today and Type = 'Month']) {
            if(period.FiscalYearSettings.Name != null){ //set current year
                currentYear = period.FiscalYearSettings.Name;
            }
            if(period.PeriodLabel != null && MAP_MONTHLABELNUMBER.containsKey(period.PeriodLabel)){ //set current month
                currentMonth = MAP_MONTHLABELNUMBER.get(period.PeriodLabel);
            }                       
        }
        
        for (Period period : [select Id, FiscalYearSettings.Name, Number 
                            from Period where StartDate <= Today and EndDate >= Today and Type = 'Quarter']) {
            if(period.FiscalYearSettings.Name != null){ //set current year
                currentYear = period.FiscalYearSettings.Name;
            }
            if(period.Number != null){ //set current month
                currentQuarter = period.Number;
            }                       
        }
        
        if(Math.mod(currentMonth, 3) == 1) {
            currentQuarter = currentQuarter - 1;
        }
        
        if(currentQuarter <= 0) {
            currentQuarter = currentQuarter + 4;
        }
        
        if(currentMonth == 1) {
            currentMonth = 12;
            currentYear = Integer.valueOf(currentYear) - 1 + '';
        }else {
            currentMonth = currentMonth - 1;
        }
        
        if(currentMonth < 10) {
            currentMonthString = '0' + currentMonth;
        }else {
            currentMonthString = '' + currentMonth;
        }
        
        for (Period period : [select Id, StartDate 
                        from Period where FiscalYearSettings.Name = :currentYear and PeriodLabel = :MAP_NUMBERMONTHLABEL.get(currentMonth) and Type = 'Month']) {
            startDate = period.StartDate;
        }
        for(Opportunity oppyTemp : [select StageName from Opportunity where isClosed = true and isWon = true and RecordTypeId = :rt3.Id order by LastModifiedDate desc limit 1]) {
            oppyStageName = oppyTemp.StageName;
        }
    }

    static testMethod void myUnitTest1() {
        Profile pro = [Select Id, Name From Profile 
                     where Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'hellEFD@testCompany1233423.com';
        u.Alias = 'dpED';
        u.CommunityNickname = 'NNDU';
        u.ProfileId = pro.Id;
        insert u;
        insert new Admin_Profile_Exception__c(setupownerid=pro.Id,Skip_Opportuntiy_Validation__c=true);
        system.runAs(u){  
            list<Account> list_sos = new list<Account>();
            ClsTestCustomSettingHelper.getApex_Helper_Settings();
            ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
            ClsTestCustomSettingHelper.getOpportunity_Approvers();
            ClsTestCustomSettingHelper.getTrigger_Configuration();
            ClsTestCustomSettingHelper.getProfitBUCenterMapping();
            ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
            
            ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            acc.AccountNumber = 'test1234';
            insert acc;
            list_sos.add(acc);
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Name = 'test11';
            oppy.CurrencyIsoCode = 'EUR';
            oppy.Type = 'New Business';
            oppy.Description = 'test1';
            oppy.Distributor__c = 'Dachs1';
            oppy.Manufacturing_Start_Date__c = date.today();
            oppy.CloseDate = date.today().addMonths(1);
            oppy.RecordTypeId = rt3.Id;
            oppy.Level__c = 'Quarterly';
            oppy.AccountId = acc.Id;
            oppy.StageName = 'Won - Closed';
            oppy.Probability = 10;
            insert oppy;
            Product_Hierarchy__c ph = new Product_Hierarchy__c();
            ph.Name = '00122333';
            insert ph;
            Part__c p = new Part__c();
            p.Product_Hierarchy__c = ph.Id;
            insert p;
            Opportunity_Part__c op = new Opportunity_Part__c();
            op.Part__c = p.Id;
            op.Opportunity__c = oppy.Id;
            insert op;
            Opportunity_Forecast__c ofc = new Opportunity_Forecast__c();
            ofc.Opportunity__c = oppy.Id;
            ofc.Amount__c = 10;
            ofc.Part__c = op.Id;
            //ofc.Date__c = startDate; 
            ofc.Fiscal_Quarter__c = '0' + currentQuarter;
            ofc.Fiscal_Year__c = currentYear;
            insert ofc;
            //oppy.StageName = oppyStageName;
           // update oppy; // commented by Pavan T for case 901115
            BBB_Year_Bill_Book_Cust_PN__c so = new BBB_Year_Bill_Book_Cust_PN__c();
            so.Bill_Year_to_Date_Amount_Document__c = 100;
            so.Year__c = currentYear;
            so.Part__c = p.Id;
            so.Customer__c = acc.Id;
            so.Billings_Month_1__c = 10;
            so.Billings_Month_2__c = 11;
            so.Billings_Month_3__c = 12;
            so.Billings_Month_4__c = 5;
            so.Billings_Month_5__c = 5;
            so.Billings_Month_6__c = 5;
            so.Billings_Month_7__c = 4;
            so.Billings_Month_8__c = 5;
            so.Billings_Month_9__c = 16;
            so.Billings_Month_10__c = 7;
            so.Billings_Month_11__c = 10;
            so.Billings_Month_12__c = 10;
            so.Bill_Type__c = 'POS';
            insert so;
            
            set<id> failedIds = new set<id>(); // Added by Pavan T for case 901115
            Test.startTest(); 
            Cls_BatchCalculateForecastBilling clsBatch = new Cls_BatchCalculateForecastBilling(failedIds,0,false); // Added parameter for constructor by Pavan T for case 901115
            //Database.BatchableContext BC;
            // clsBatch.filter = 'Id = \'' + acc.Id + '\''; // commented by Pavan T for case 901115
            database.executeBatch(clsBatch);
            //clsBatch.start(BC);
            //clsBatch.execute(BC, list_sos);
            //clsBatch.finish(BC);
            Test.stopTest();
        
        }
    }
    
    static testMethod void myUnitTest2() {
        Profile pro = [Select Id, Name From Profile 
                     where Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'hellEFD@testCompany1233423.com';
        u.Alias = 'dpED';
        u.CommunityNickname = 'NNDU';
        u.ProfileId = pro.Id;
        insert u;
        insert new Admin_Profile_Exception__c(setupownerid=pro.Id,Skip_Opportuntiy_Validation__c=true);
        system.runAs(u){  
            list<Account> list_sos = new list<Account>();
            ClsTestCustomSettingHelper.getApex_Helper_Settings();
            ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
            ClsTestCustomSettingHelper.getOpportunity_Approvers();
            ClsTestCustomSettingHelper.getTrigger_Configuration();
            ClsTestCustomSettingHelper.getProfitBUCenterMapping();
            ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
            
            ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            acc.AccountNumber = 'test123';
            insert acc;
            
            list_sos.add(acc);
            
            Opportunity oppyMonth = ClsTestHelp.createTestOpportunity();
            oppyMonth.Name = 'test111';
            oppyMonth.CurrencyIsoCode = 'EUR';
            oppyMonth.Type = 'New Business';
            oppyMonth.Description = 'test11';
            oppyMonth.Distributor__c = 'Dachs11';
            oppyMonth.Manufacturing_Start_Date__c = date.today();
            oppyMonth.CloseDate = date.today().addMonths(1);
            oppyMonth.RecordTypeId = rt3.Id;
            oppyMonth.Level__c = 'Monthly';
            oppyMonth.AccountId = acc.Id;
            oppyMonth.StageName = 'Won - Closed';
            oppyMonth.Probability = 10;
            insert oppyMonth;
            
            Product_Hierarchy__c ph1 = new Product_Hierarchy__c();
            ph1.Name = '001223332';
            insert ph1;
            
            Part__c p1 = new Part__c();
            p1.Product_Hierarchy__c = ph1.Id;
            insert p1;
            
            Opportunity_Part__c op1 = new Opportunity_Part__c();
            op1.Part__c = p1.Id;
            op1.Opportunity__c = oppyMonth.Id;
            insert op1;
            
            Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast.Opportunity__c = oppyMonth.Id;
            oppyForecast.Part__c = op1.Id;
            oppyForecast.Date__c = startDate;
            oppyForecast.Amount__c = 10;
            oppyForecast.Fiscal_Month__c = currentMonthString;
            oppyForecast.Fiscal_Year__c = currentYear;
            insert oppyForecast;
            
            oppyMonth.StageName = oppyStageName;
            // update oppyMonth;
            Forecast_Billing__c OppFB = new Forecast_Billing__c();
            OppFB.RecordTypeId = [select Id from RecordType where DeveloperName = 'Regular'][0].Id;
            OppFB.Date__c = StartDate;
            OppFB.Opportunity_Forecast__c = oppyForecast.Id;
            insert OppFB;
            
            Forecast_Snapshot__c OppFS = new Forecast_Snapshot__c();
            OppFS.Part__c = op1.Id;
            OppFS.Opportunity__c = oppyMonth.Id;
            OppFS.Date__c = StartDate;
            insert OppFS;
            
            BBB_Year_Bill_Book_Cust_PN__c so = new BBB_Year_Bill_Book_Cust_PN__c();
            so.Bill_Year_to_Date_Amount_Document__c = 100;
            so.Year__c = currentYear;
            so.Part__c = p1.Id;
            so.Customer__c = acc.Id;
            so.Billings_Month_1__c = 10;
            so.Billings_Month_2__c = 11;
            so.Billings_Month_3__c = 12;
            so.Billings_Month_4__c = 5;
            so.Billings_Month_5__c = 5;
            so.Billings_Month_6__c = 5;
            so.Billings_Month_7__c = 4;
            so.Billings_Month_8__c = 5;
            so.Billings_Month_9__c = 16;
            so.Billings_Month_10__c = 7;
            so.Billings_Month_11__c = 10;
            so.Billings_Month_12__c = 10;
            so.Bill_Type__c = 'Direct';
            insert so;
            Load_Status__c ls = new Load_Status__c(Name='BBB_Year_Bill_Book_Cust_PN__c Direct',Current_Fiscal_Month__c=Decimal.valueof(currentMonthString),Fiscal_Working_Days_until_today__c=10.00);
            insert ls;
            insert new Batch_Email_message_Users__c(name='Error_BatchCalculateForecastBilling',Email_ID__c='test@te.com;test1@te.com');
            insert new Load_Status_Of_Forecast_Billing__c(Name='Regular',Load_Status_Id__c=ls.id);
            set<id> failedIds = new set<id>(); // Added by Pavan T for case 901115
            
            Test.startTest();
            Cls_BatchCalculateForecastBilling clsBatch = new Cls_BatchCalculateForecastBilling(failedIds,0,true);  // Added parameter for constructor by Pavan T for case 901115
            database.executeBatch(clsBatch);
            
            Cls_BatchCalculateForecastBilling clsBatch1 = new Cls_BatchCalculateForecastBilling(new set<id>(),1,false);
            Database.BatchableContext BC;
            clsBatch1.failedIds.add(acc.id);
            clsBatch1.finish(BC);
            Test.stopTest();
        }
    }
    
}