/**
*   This test class is for CtrlOppyForecastToolEnhancementAPL.
*
@author Minghao Li
@created 2017-09-26
@version 1.0
@since 38.0
*
@changelog
* 2017-09-26 Minghao Li <minghao.li@capgemini.com>
* - Created
* - Test coverage 85%
*/
@isTest(SeeAllData=false)
private class CtrlOppyForecastToolEnhancementAPL_Test {
    
    @testSetup static void createConfig(){
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOrgWideSettings();
        ClsTestCustomSettingHelper.getADMTerritoryCode();
        ClsTestHelp.createTestOPTG4();
        
        map<Integer, String> map_MonthQuarter = new map<Integer, String> {
            1=>'01',2=>'01',3=>'01',4=>'02',5=>'02',6=>'02',7=>'03',8=>'03',9=>'03',10=>'04',11=>'04',12=>'04'
        };
        APL_Lost_Dead_Project_Show_Hide__c aldpsh = new APL_Lost_Dead_Project_Show_Hide__c(
                Name = 'Show/Hide Sections', Show_Forecast_Total__c = true, Show_Business_Won__c = true, Show_Business_Lost__c = true
            );
            insert aldpsh;
            
            RecordType rt25 = ClsTestHelp.createTestRecordType25();
            APL_Forecast_Management__c apl = new APL_Forecast_Management__c();
            apl.Name = 'testName';
            apl.A6_Code__c = 'A007341';
            apl.Manager__c = userInfo.getUserId();  
            apl.GAM_Code__c = '1234';
            apl.RecordTypeId = rt25.Id;
            insert apl;
            
            
            Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
            sh.Level_2_Territory_Code__c = '103004';
            insert sh;
            
            /*Load_Status__c loadStatus = new Load_Status__c();
            loadStatus.Current_Fiscal_Year__c = '2018';
            loadStatus.Current_Fiscal_Month__c = 4;
            loadStatus.Data_Source_Description__c = 'Bookings/Billings Direct PN detail Monthly';
            insert loadStatus;
            
            List<ADMTerritoryCode__c> list_admt = new List<ADMTerritoryCode__c> {
                new ADMTerritoryCode__c(Name = 'DND Opportunity', Territory_Code__c = '111111'),
                new ADMTerritoryCode__c(Name = 'ADMTerritoryCode', Territory_Code__c = '111111')
            };
            insert list_admt;
                        
            list<Group> list_pgs = [select Name from Group where id in (select GroupId from GroupMember where userorgroupid = :UserInfo.getUserId())];
            */
            RecordType rt = ClsTestHelp.createTestRecordType6();
            RecordType rt2 = ClsTestHelp.createTestRecordType16();
            RecordType rt3 = ClsTestHelp.createTestRecordType31();
            
            Account acc = ClsTestHelp.createTestAccounts();
            acc.RecordTypeId = rt.Id;
            acc.Account_Manager__c = UserInfo.getUserId();
            acc.Name = 'TestAccNo1';
            insert acc;

        
            Account acc2 = ClsTestHelp.createTestAccounts();
            acc2.RecordTypeId = rt.Id;
            acc2.Account_Manager__c = UserInfo.getUserId();
            insert acc2;
                
            Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Program_level_Forecasting__c =true; 
            oppy2.Name = 'Pain of Queen';
            oppy2.Type = 'CM';
            oppy2.Request_Type__c = 'Extension';
            oppy2.RecordTypeId = rt3.Id;
            oppy2.accountid = acc2.Id;
            oppy2.Sum_Part_Allocation__c = 100;
            oppy2.New_Business_Percentage__c = '30%';
            insert oppy2;  
            /*
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Program__c = oppy2.Id;   
            oppy.Type = 'CM';
            oppy.Request_Type__c = 'Extension';
            oppy.Method__c = 'BOM';
            oppy.Level__c = 'Yearly';
            oppy.Amount = 1;
            oppy.CurrencyIsoCode = 'EUR';
            oppy.Five_Year_Revenue__c = 1;
            oppy.lost_start_date__c = date.today();
            oppy.RecordTypeId = rt2.Id;
            oppy.accountid = acc2.Id;
            insert oppy;
            */
            list<Product_Hierarchy__c> list_ph = new list<Product_Hierarchy__c>();
            
            Product_Hierarchy__c ph1 = new Product_Hierarchy__c();
            ph1.Hierarchy_Level_Type__c = 'CBC1';
            ph1.Description__c = 'Industrial'; 
            list_ph.add(ph1);
            
            
            Product_Hierarchy__c ph2 = new Product_Hierarchy__c();
            ph2.Hierarchy_Level_Type__c = 'CBC2';
            ph2.CBC2__c = '30012';
            ph2.Description__c = 'Industrial'; 
            list_ph.add(ph2);
            
            Product_Hierarchy__c ph3 = new Product_Hierarchy__c();
            ph3.Hierarchy_Level_Type__c = 'CBC3';
            ph3.CBC3__c = '41553';
            ph3.Description__c = 'Industrial'; 
            list_ph.add(ph3);
            
            insert list_ph;

            list<Part__c> list_part = new list<Part__c>();
            Part__c part = new Part__c();
            part.Description__c = 'Sniper';
            part.Product_Hierarchy__c = ph1.Id;
            list_part.add(part);
            
            Part__c part2 = new Part__c();
            part2.Description__c = 'Sniper';
            part2.Product_Hierarchy__c = ph2.Id;
            list_part.add(part2);
            
            Part__c part3 = new Part__c();
            part3.Description__c = 'Sniper';
            part3.Product_Hierarchy__c = ph3.Id;
            list_part.add(part3);
            
            insert list_part;
            
            list<Opportunity_Part__c> lst_opp = new list<Opportunity_Part__c>();
            Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
            oppypart.Opportunity__c = oppy2.Id;
            oppypart.Part__c = part.Id;
            oppypart.Similar_TE_Part_Number__c = part.Id;
            oppypart.initial_billing_date__c = date.today();
            oppypart.Initial_Order_Date__c = date.today();
            oppypart.Process_Status__c = 'Production';
            lst_opp.add(oppypart);
            
            
            Opportunity_Part__c oppypart2 = ClsTestHelp.createTestOpportunityPart();
            oppypart2.CM_Part_Number__c = 'TESTOppyPart2';
            oppypart2.Opportunity__c = oppy2.Id;
            oppypart2.Part__c = part.Id;
            oppypart2.Similar_TE_Part_Number__c = part.Id;
            oppypart2.initial_billing_date__c = date.today();
            oppypart2.Initial_Order_Date__c = date.today();
            oppypart2.Process_Status__c = 'Production';
            oppypart2.Status__c = 'Won';
            oppypart2.Won_Date__c = date.today().addMonths(3);
            
            lst_opp.add(oppypart2);
            
            Opportunity_Part__c oppypart3 = ClsTestHelp.createTestOpportunityPart();
            oppypart3.Opportunity__c = oppy2.Id;
            oppypart3.Part__c = part.Id;
            oppypart3.Similar_TE_Part_Number__c = part.Id;
            oppypart3.initial_billing_date__c = date.today();
            oppypart3.Initial_Order_Date__c = date.today();
            oppypart3.Process_Status__c = 'Production';
            oppypart3.Status__c = 'Won';
            oppypart3.Won_Date__c = date.today().addMonths(-1);
            lst_opp.add(oppypart3);
            
            Opportunity_Part__c oppypartwon2 = ClsTestHelp.createTestOpportunityPart();
            oppypartwon2.CM_Part_Number__c = 'TESTOppyPartWon2';
            oppypartwon2.Opportunity__c = oppy2.Id;
            oppypartwon2.Part__c = part2.Id;
            oppypartwon2.Similar_TE_Part_Number__c = part2.Id;
            oppypartwon2.initial_billing_date__c = date.today();
            oppypartwon2.Initial_Order_Date__c = date.today();
            oppypartwon2.Process_Status__c = 'Production';
            oppypartwon2.Status__c = 'Won';
            oppypartwon2.Won_Date__c = date.today().addMonths(-1);
            lst_opp.add(oppypartwon2);
            
            Opportunity_Part__c oppypartwon3 = ClsTestHelp.createTestOpportunityPart();
            oppypartwon3.CM_Part_Number__c = 'TESTOppyPartWon3';
            oppypartwon3.Opportunity__c = oppy2.Id;
            oppypartwon3.Part__c = part3.Id;
            oppypartwon3.Similar_TE_Part_Number__c = part3.Id;
            oppypartwon3.initial_billing_date__c = date.today();
            oppypartwon3.Initial_Order_Date__c = date.today();
            oppypartwon3.Process_Status__c = 'Production';
            oppypartwon3.Status__c = 'Won';
            oppypartwon3.Won_Date__c = date.today().addMonths(-1);
            lst_opp.add(oppypartwon3);
            
            insert lst_opp;
            
            
            Date d = date.today().addMonths(5);
            String quarter = map_MonthQuarter.get(d.month());
            String month = String.valueOf(d.month());
            month = month.length() == 2 ? month : '0'+month;

            Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast.Opportunity__c = oppy2.Id;
            oppyForecast.Quantity__c = 12;
            oppyForecast.Part__c = oppypart.Id;
            oppyForecast.Date__c = d;
            oppyForecast.Sales_Price__c = 123;
            oppyForecast.Fiscal_Month__c = month;
            oppyForecast.Fiscal_Year__c = d.year()+'';
            oppyForecast.Fiscal_Quarter__c = quarter;
            oppyForecast.Amount__c = 1;
            //insert oppyForecast;
            
            Opportunity_Forecast__c oppyForecast2 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast2.Opportunity__c = oppy2.Id;
            oppyForecast2.Quantity__c = 12;
            oppyForecast2.Part__c = oppypart.Id;
            oppyForecast2.Date__c = d;
            oppyForecast2.Sales_Price__c = 123;
            oppyForecast2.Amount__c = 1;
            oppyForecast2.Fiscal_Month__c = month;
            oppyForecast2.Fiscal_Year__c = d.year()+'';
            oppyForecast2.Fiscal_Quarter__c = quarter;
             
            Opportunity_Forecast__c oppyForecast3 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast3.Opportunity__c = oppy2.Id;
            oppyForecast3.Quantity__c = 12;        
            oppyForecast3.Date__c = d;
            oppyForecast3.Fiscal_Month__c = month;
            oppyForecast3.Fiscal_Year__c = d.year()+'';
            oppyForecast3.Sales_Price__c = 123;
            oppyForecast3.Fiscal_Quarter__c = quarter;
            oppyForecast3.Amount__c = 1;
            oppyForecast3.part__c = oppypart3.Id;
            
            Opportunity_Forecast__c oppyForecastwon2 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecastwon2.Opportunity__c = oppy2.Id;
            oppyForecastwon2.Quantity__c = 12;        
            oppyForecastwon2.Date__c = d;
            oppyForecastwon2.Fiscal_Month__c = month;
            oppyForecastwon2.Fiscal_Year__c = d.year()+'';
            oppyForecastwon2.Fiscal_Quarter__c = quarter;
            oppyForecastwon2.Sales_Price__c = 123;
            oppyForecastwon2.Amount__c = 1;
            oppyForecastwon2.part__c = oppypartwon2.Id;
            
            Opportunity_Forecast__c oppyForecastwon3 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecastwon3.Opportunity__c = oppy2.Id;
            oppyForecastwon3.Quantity__c = 12;        
            oppyForecastwon3.Date__c = d;
            oppyForecastwon3.Fiscal_Month__c = month;
            oppyForecastwon3.Fiscal_Year__c = d.year()+'';
            oppyForecastwon3.Fiscal_Quarter__c = quarter;
            oppyForecastwon3.Sales_Price__c = 123;
            oppyForecastwon3.Amount__c = 1;
            oppyForecastwon3.part__c = oppypartwon3.Id;
            
            insert new list<Opportunity_Forecast__c>{oppyForecast, oppyForecast2, oppyForecast3, oppyForecastwon2, oppyForecastwon3};
            
            
            Period p = [select FiscalYearSettingsId, FiscalYearSettings.Name, PeriodLabel, Number, StartDate, EndDate from Period 
                        where type = 'Year' and FiscalYearSettings.IsStandardYear = false 
                        and StartDate <= :system.today() and EndDate >= :system.today()
                        order by FiscalYearSettings.Name limit 1];
                        
            String fiscalYear = p.FiscalYearSettings.Name;
            
            
            
            /*
            
            APL_Lost_Dead_Project_Show_Hide__c aldpsh = new APL_Lost_Dead_Project_Show_Hide__c();
            aldpsh.Name = 'Show/Hide Sections';
            aldpsh.Show_Forecast_Total__c = true;
            aldpsh.Show_Business_Won__c = true;
            aldpsh.Show_Business_Lost__c = true;
            upsert aldpsh;
            */
            list<Opportunity_Partner__c> lst_OP = new list<Opportunity_Partner__c>();
            Opportunity_Partner__c opp = ClsTestHelp.createTestOpportunityPartner();
            opp.Opportunity__c = oppy2.Id;
            opp.Within_S_OP__c = true;
            opp.Account__c = acc2.id;
            opp.Allocation__c = 0;
            lst_OP.add(opp);
            /*
            Opportunity_Partner__c opp2 = ClsTestHelp.createTestOpportunityPartner();
            opp2.Opportunity__c = oppy2.Id;
            opp2.Within_S_OP__c = true;
            opp2.Account__c = acc2.id;
            opp2.Allocation__c = 0;
            lst_OP.add(opp2);*/
            insert lst_OP;
        
        
    }
    
    
    static testMethod void myUnitTest() {
        Test.startTest();
        Account acc = [Select Id from Account where Name = 'TestAccNo1'];
        Opportunity oppy2 = [select Id from Opportunity where name = 'Pain of Queen'];
        Opportunity_Part__c oppypart2 =null, oppypartwon2=null, oppypartwon3=null;
        for(Opportunity_Part__c op : [select Id, CM_Part_Number__c from Opportunity_Part__c where CM_Part_Number__c IN ('TESTOppyPart2', 'TESTOppyPartWon2', 'TESTOppyPartWon3')]) {
            if(op.CM_Part_Number__c == 'TESTOppyPart2') {
                oppypart2 = op;
            }else if(op.CM_Part_Number__c == 'TESTOppyPartWon2') {
                oppypartwon2 = op;
            }else if(op.CM_Part_Number__c == 'TESTOppyPartWon3') {
                oppypartwon3 = op;
            }
        }
        
        /*User u = [select Id, Name, GIBU__c, PMV_Type_Initialization__c, Sub_Vertical__c from User 
                        where GIBU__c = 'Industrial' and PMV_Type_Initialization__c = 'Standard' and Sub_Vertical__c = 'A&C' and IsActive = true limit 1];*/
        /*User u = new User();
        u.FirstName = 'ltkp';
        u.LastName = 'ltkp';
        u.Username = 'ltkpunit@test.com';
        u.IsActive = true;
        u.Alias = 'alikp';
        u.Email = 'ltkpunit@test.com';
        u.CommunityNickname = u.Alias;
        u.ProfileId = [Select Id from Profile Where Name = 'System Administrator' ].Id; 
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.ManagerId = UserInfo.getUserId();
        insert u;
        system.runAs(u) {*/
            
            Date d = date.today().addMonths(5);
            
            
            
            CtrlOppyForecastToolEnhancementAPL ctrl = new CtrlOppyForecastToolEnhancementAPL();
            
            ctrl.getThis();
            ctrl.getCookieTotal();
            ctrl.getCookieLost();
            ctrl.getCookieOther();
            
            CtrlOppyForecastToolEnhancementAPL.CustomPramas cp = new CtrlOppyForecastToolEnhancementAPL.CustomPramas();
            cp.intCurrentFiscalYear = d.year();
            cp.intCurrentFiscalMonth = d.month();
            cp.periodYear = d.year();
            
            cp.sql = 'Select Id From Account limit 10';//ctrl.co.sqlLost;
            String result = CtrlOppyForecastToolEnhancementAPL.exsitingBusinessLost(JSON.serialize(cp));
            
            APL_Lost_Dead_Project__c aldp = new APL_Lost_Dead_Project__c();
            aldp.Name = 'test';
            aldp.Account_Name__c = acc.id;
            aldp.Estimated_Business_Value_Per_Quarter__c = 2000;
            aldp.Primary_Product__c = '217';
            aldp.Major_Part_Number__c = 'testNumber';
            aldp.Lost_Start_Fiscal_Year__c = '2016';
            aldp.Lost_Start_Fiscal_Month__c = '01';
            aldp.Description__c = 'test';
            aldp.Existing_Business_Lost_reason__c = 'Customer Program Cancellation / End of Life';
            
            String sAldp = CtrlOppyForecastToolEnhancementAPL.saveExsitingBusinessLost(JSON.serialize(aldp));
            
            APL_Lost_Dead_Project__c rAldp = (APL_Lost_Dead_Project__c)JSON.deserialize(sAldp, APL_Lost_Dead_Project__c.class);
            
            
            list<String> list_ids = new list<String>{rAldp.Id};
            
            String delResult = CtrlOppyForecastToolEnhancementAPL.deleteExsitingBusinessLost(JSON.serialize(list_ids));
            
            
            cp.sql = ctrl.co.sqlOther;
            cp.sql = 'Select Id, APL_Relay_forecast_Plan_Account__c,Relay_Specialist_Territory_Code__c From Account limit 10';
            //system.assertEquals('==', JSON.serialize(ctrl.co));
            String otherResult = CtrlOppyForecastToolEnhancementAPL.otherWon(JSON.serialize(cp));
            
            cp.isRemove = true;
            cp.idmap = new map<String, set<String>>();
            cp.idmap.put(oppy2.Id,new set<String>{oppypart2.Id, oppypartwon2.Id, oppypartwon3.Id});
            CtrlOppyForecastToolEnhancementAPL.addremoveOtherWon(JSON.serialize(cp));
            cp.isRemove = false;
            CtrlOppyForecastToolEnhancementAPL.addremoveOtherWon(JSON.serialize(cp));
            CtrlOppyForecastToolEnhancementAPL.addremoveOtherWonWithinSOP(JSON.serialize(cp));
            
            cp.isRemove = true;
            CtrlOppyForecastToolEnhancementAPL.addremoveOtherWon(JSON.serialize(cp));
            
            CtrlOppyForecastToolEnhancementAPL.CustomOther customOther = new CtrlOppyForecastToolEnhancementAPL.CustomOther();
            CtrlOppyForecastToolEnhancementAPL.CustomSelectOption selectOption = new CtrlOppyForecastToolEnhancementAPL.CustomSelectOption('test', 'test');
            Test.stopTest();
        /*}*/
    }
    
    static testMethod void myUnitTest2() {
        
        
        Date d = date.today().addMonths(5);
        
        Test.startTest();
        
        CtrlOppyForecastToolEnhancementAPL ctrl = new CtrlOppyForecastToolEnhancementAPL();
        
        ctrl.getThis();
        ctrl.getCookieTotal();
        ctrl.getCookieLost();
        ctrl.getCookieOther();
        
        CtrlOppyForecastToolEnhancementAPL.CustomPramas cp = new CtrlOppyForecastToolEnhancementAPL.CustomPramas();
        cp.intCurrentFiscalYear = d.year();
        cp.intCurrentFiscalMonth = d.month();
        cp.periodYear = d.year();
        
        cp.sql = 'Select Id From Account limit 10';//ctrl.co.sqlLost;
        String result = CtrlOppyForecastToolEnhancementAPL.exsitingBusinessLost(JSON.serialize(cp));
        
        cp.sql = ctrl.co.sqlOther;
        cp.sql = 'Select Id, APL_Relay_forecast_Plan_Account__c,Relay_Specialist_Territory_Code__c From Account limit 10';
        //system.assertEquals('==', JSON.serialize(ctrl.co));
        String otherResult = CtrlOppyForecastToolEnhancementAPL.otherWon(JSON.serialize(cp));
        
        
        CtrlOppyForecastToolEnhancementAPL.CustomOther customOther = new CtrlOppyForecastToolEnhancementAPL.CustomOther();
        CtrlOppyForecastToolEnhancementAPL.CustomSelectOption selectOption = new CtrlOppyForecastToolEnhancementAPL.CustomSelectOption('test', 'test');
        Test.stopTest();
        /*}*/
    }
    
    static testMethod void myUnitTest3() {
        Test.startTest();
        Account acc = [Select Id from Account where Name = 'TestAccNo1'];
        Opportunity oppy2 = [select Id from Opportunity where name = 'Pain of Queen'];
        Opportunity_Part__c oppypart2 =null, oppypartwon2=null, oppypartwon3=null;
        for(Opportunity_Part__c op : [select Id, CM_Part_Number__c from Opportunity_Part__c where CM_Part_Number__c IN ('TESTOppyPart2', 'TESTOppyPartWon2', 'TESTOppyPartWon3')]) {
            if(op.CM_Part_Number__c == 'TESTOppyPart2') {
                oppypart2 = op;
            }else if(op.CM_Part_Number__c == 'TESTOppyPartWon2') {
                oppypartwon2 = op;
            }else if(op.CM_Part_Number__c == 'TESTOppyPartWon3') {
                oppypartwon3 = op;
            }
        }
        
        Date d = date.today().addMonths(5);
        
        
        
        CtrlOppyForecastToolEnhancementAPL ctrl = new CtrlOppyForecastToolEnhancementAPL();
        
        ctrl.getThis();
        ctrl.getCookieTotal();
        ctrl.getCookieLost();
        ctrl.getCookieOther();
        
        CtrlOppyForecastToolEnhancementAPL.CustomPramas cp = new CtrlOppyForecastToolEnhancementAPL.CustomPramas();
        cp.intCurrentFiscalYear = d.year();
        cp.intCurrentFiscalMonth = d.month();
        cp.periodYear = d.year();
        cp.sql = ctrl.co.sqlOther;
        cp.sql = 'Select Id, APL_Relay_forecast_Plan_Account__c,Relay_Specialist_Territory_Code__c From Account limit 10';
        //system.assertEquals('==', JSON.serialize(ctrl.co));
        
        cp.isRemove = true;
        cp.idmap = new map<String, set<String>>();
        cp.idmap.put(oppy2.Id,new set<String>{oppypart2.Id, oppypartwon2.Id, oppypartwon3.Id});
        CtrlOppyForecastToolEnhancementAPL.addremoveOtherWon(JSON.serialize(cp));
        cp.isRemove = false;
        CtrlOppyForecastToolEnhancementAPL.addremoveOtherWon(JSON.serialize(cp));
        CtrlOppyForecastToolEnhancementAPL.addremoveOtherWonWithinSOP(JSON.serialize(cp));
        
        cp.isRemove = true;
        CtrlOppyForecastToolEnhancementAPL.addremoveOtherWon(JSON.serialize(cp));
        
        Test.stopTest();
        /*}*/
    }
}