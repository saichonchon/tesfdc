/**
*  This test class used to test class ClsFinancialFCBatchUtil.
*
@author Lili Zhao
@created 2013-11-18
@version 1.0   
@since 28.0
*
@changelog
* 
* 
2013-11-18 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
* 2014-01-22 Di Chen <di.chen@itbconsult.com>
* coverage 83% 
*/
@isTest
private class ClsFinancialFCBatchUtil_Test {        

    static testMethod void myUnitTest() {       
        map<String, Set<Integer>> map_financialMonth = new map<String, Set<Integer>>();
        map<String, Set<Integer>> map_financialMonthTest = new map<String, Set<Integer>>();        
        map_financialMonthTest.put('2012',new Set<Integer>());
        map_financialMonthTest.get('2012').add(10);
        map_financialMonthTest.get('2012').add(11);

              
        Test.startTest(); 
        ClsFinancialFCBatchUtil.PageConfig pageConf = new ClsFinancialFCBatchUtil.PageConfig();
        ClsFinancialFCBatchUtil.setCurrent(pageConf); 
        ClsFinancialFCBatchUtil.setfinancialMonths(map_financialMonth);
        ClsFinancialFCBatchUtil.buildMonthFilter(map_financialMonthTest);
        ClsFinancialFCBatchUtil.getCurrentMonthIndex(map_financialMonthTest,'2012',12);
                
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void myUnitTest1() {       
        Set<Date> set_date = new Set<Date>();      
        Test.startTest(); 
        ClsFinancialFCBatchUtil.setDate(7, 2012, 2, set_date);  
        ClsFinancialFCBatchUtil.setDate(8, 2012, 1, set_date); 
        ClsFinancialFCBatchUtil.setDate(8, 2012, 7, set_date);  
        ClsFinancialFCBatchUtil.setDate(9, 2012, 1, set_date);   
        ClsFinancialFCBatchUtil.setDate(9, 2012, 2, set_date);
        ClsFinancialFCBatchUtil.setDate(9, 2012, 12, set_date);          
        system.assert(true);
        Test.stopTest();
    }

    static testMethod void myUnitTest2() { 
        Manager_Forecast__c manForecast = new Manager_Forecast__c();
        manForecast.Last_Frozen_Month_Date__c = date.newinstance(2012, 2, 15);
        manForecast.Fiscal_Year__c = '2012';
        manForecast.Fiscal_Month__c = 6;
        insert manForecast;  
        List<Manager_Forecast__c> list_mgForecasts = New List<Manager_Forecast__c>();
        //list_mgForecasts.add(manForecast);
        list_mgForecasts = [select Last_Frozen_Month_Date__c,Forecast_USD__c,Forecast_0_Months_Document__c,Forecast_2_Months_Document__c,Forecast_3_Months_Document__c,Id,Fiscal_Year__c,Fiscal_Date__c,Forecast_Definition__c,Fiscal_Month__c from Manager_Forecast__c where Id =: manForecast.Id];
                  
        Test.startTest(); 
        
        ClsFinancialFCBatchUtil.setManagerForecast(list_mgForecasts, date.newinstance(2013, 9, 15) , false, true); 
        ClsFinancialFCBatchUtil.setManagerForecast(list_mgForecasts, date.newinstance(2013, 2, 15), false, true);  
        ClsFinancialFCBatchUtil.setManagerForecast(list_mgForecasts, date.newinstance(2012, 7, 15), false, true);  
        ClsFinancialFCBatchUtil.setManagerForecast(list_mgForecasts, date.newinstance(2012, 7, 15), false, true);  
        ClsFinancialFCBatchUtil.setManagerForecast(list_mgForecasts, date.newinstance(2012, 6, 15), false, true); 
        ClsFinancialFCBatchUtil.setManagerForecast(list_mgForecasts, date.newinstance(2012, 5, 15), false, true); 
        ClsFinancialFCBatchUtil.setManagerForecast(list_mgForecasts, date.newinstance(2012, 5, 15), false, true);  
        ClsFinancialFCBatchUtil.setManagerForecast(list_mgForecasts, date.newinstance(2012, 3, 15), false, true);
        ClsFinancialFCBatchUtil.setManagerForecast(list_mgForecasts, date.newinstance(2012, 2, 15), false, true);
        ClsFinancialFCBatchUtil.setManagerForecast(list_mgForecasts, date.newinstance(2012, 1, 15), false, true);        
        system.assert(true);
        Test.stopTest();
    }


    static testMethod void myUnitTest3() { 
        Manager_Forecast__c manForecast = new Manager_Forecast__c();
        manForecast.Last_Frozen_Month_Date__c = date.newinstance(2012, 2, 15);
        manForecast.Fiscal_Year__c = '2013';
        manForecast.Fiscal_Month__c = 6;
        insert manForecast;  
        List<Manager_Forecast__c> list_mgForecasts = New List<Manager_Forecast__c>();
        list_mgForecasts = [select Last_Frozen_Month_Date__c,Forecast_USD__c,Forecast_0_Months_Document__c,Forecast_2_Months_Document__c,Forecast_3_Months_Document__c,Id,Fiscal_Year__c,Fiscal_Date__c,Forecast_Definition__c,Fiscal_Month__c from Manager_Forecast__c where Id =: manForecast.Id];
                  
        Test.startTest(); 
        ClsFinancialFCBatchUtil.setManagerForecast(list_mgForecasts, date.newinstance(2012, 12, 15), false, true);                
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void myUnitTest4() { 
        Manager_Forecast__c manForecast = new Manager_Forecast__c();
        manForecast.Last_Frozen_Month_Date__c = date.newinstance(2012, 2, 15);
        manForecast.Fiscal_Year__c = '2013';
        manForecast.Fiscal_Month__c = 6;
        insert manForecast;  
        List<Manager_Forecast__c> list_mgForecasts = New List<Manager_Forecast__c>();
        list_mgForecasts = [select Last_Frozen_Month_Date__c,Forecast_USD__c,Forecast_0_Months_Document__c,Forecast_2_Months_Document__c,Forecast_3_Months_Document__c,Id,Fiscal_Year__c,Fiscal_Date__c,Forecast_Definition__c,Fiscal_Month__c from Manager_Forecast__c where Id =: manForecast.Id];        
          
        Test.startTest(); 
        ClsFinancialFCBatchUtil.setManagerForecast(list_mgForecasts, date.newinstance(2012, 12, 15), false, true);                
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void myUnitTest5() { 
        Manager_Forecast__c manForecast = new Manager_Forecast__c();
        manForecast.Last_Frozen_Month_Date__c = date.newinstance(2012, 2, 15);
        manForecast.Fiscal_Year__c = '2013';
        manForecast.Fiscal_Month__c = 5;
        insert manForecast;  
        List<Manager_Forecast__c> list_mgForecasts = New List<Manager_Forecast__c>();
        list_mgForecasts = [select Last_Frozen_Month_Date__c,Forecast_USD__c,Forecast_0_Months_Document__c,Forecast_2_Months_Document__c,Forecast_3_Months_Document__c,Id,Fiscal_Year__c,Fiscal_Date__c,Forecast_Definition__c,Fiscal_Month__c from Manager_Forecast__c where Id =: manForecast.Id];        
        
          
        Test.startTest(); 
        ClsFinancialFCBatchUtil.setManagerForecast(list_mgForecasts, date.newinstance(2012, 12, 15), false, true);                
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void myUnitTest6() { 
        Manager_Forecast__c manForecast = new Manager_Forecast__c();
        manForecast.Last_Frozen_Month_Date__c = date.newinstance(2012, 2, 15);
        manForecast.Fiscal_Year__c = '2013';
        manForecast.Fiscal_Month__c = 5;
        insert manForecast;  
        List<Manager_Forecast__c> list_mgForecasts = New List<Manager_Forecast__c>();
        list_mgForecasts = [select Last_Frozen_Month_Date__c,Forecast_USD__c,Forecast_0_Months_Document__c,Forecast_2_Months_Document__c,Forecast_3_Months_Document__c,Id,Fiscal_Year__c,Fiscal_Date__c,Forecast_Definition__c,Fiscal_Month__c from Manager_Forecast__c where Id =: manForecast.Id];        
        
        Test.startTest(); 
        ClsFinancialFCBatchUtil.setManagerForecast(list_mgForecasts, date.newinstance(2012, 12, 15), false, true);                
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void myUnitTest7() { 
        Manager_Forecast__c manForecast = new Manager_Forecast__c();
        manForecast.Last_Frozen_Month_Date__c = date.newinstance(2012, 2, 15);
        manForecast.Fiscal_Year__c = '2013';
        manForecast.Fiscal_Month__c = 5;
        insert manForecast;  
        List<Manager_Forecast__c> list_mgForecasts = New List<Manager_Forecast__c>();
        list_mgForecasts = [select Last_Frozen_Month_Date__c,Forecast_USD__c,Forecast_0_Months_Document__c,Forecast_2_Months_Document__c,Forecast_3_Months_Document__c,Id,Fiscal_Year__c,Fiscal_Date__c,Forecast_Definition__c,Fiscal_Month__c from Manager_Forecast__c where Id =: manForecast.Id];        
        
        Test.startTest(); 
        ClsFinancialFCBatchUtil.setManagerForecast(list_mgForecasts, date.newinstance(2012, 12, 15), false, true);                
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void myUnitTest8() { 
        Manager_Forecast__c manForecast = new Manager_Forecast__c();
        manForecast.Last_Frozen_Month_Date__c = date.newinstance(2012, 2, 15);
        manForecast.Fiscal_Year__c = '2013';
        manForecast.Fiscal_Month__c = 6;
        insert manForecast;  
        List<Manager_Forecast__c> list_mgForecasts = New List<Manager_Forecast__c>();
        list_mgForecasts = [select Last_Frozen_Month_Date__c,Forecast_USD__c,Forecast_0_Months_Document__c,Forecast_2_Months_Document__c,Forecast_3_Months_Document__c,Id,Fiscal_Year__c,Fiscal_Date__c,Forecast_Definition__c,Fiscal_Month__c from Manager_Forecast__c where Id =: manForecast.Id];        
          
        Test.startTest(); 
        ClsFinancialFCBatchUtil.setManagerForecast(list_mgForecasts, date.newinstance(2012, 12, 15), false, true);                
        system.assert(true);
        Test.stopTest();
    }
    //
    static testMethod void myUnitTest9() {       
        Map<Integer,set<Integer>> map_year_months = new Map<Integer,set<Integer>>();     
        Test.startTest(); 
        ClsFinancialFCBatchUtil.setYearMonth(7, 2012, 2, map_year_months);  
        ClsFinancialFCBatchUtil.setYearMonth(8, 2012, 1, map_year_months);  
        ClsFinancialFCBatchUtil.setYearMonth(8, 2012, 7, map_year_months);  
        ClsFinancialFCBatchUtil.setYearMonth(9, 2012, 1, map_year_months); 
        ClsFinancialFCBatchUtil.setYearMonth(9, 2012, 2, map_year_months); 
        ClsFinancialFCBatchUtil.setYearMonth(9, 2012, 12, map_year_months);              
        system.assert(true);
        Test.stopTest();
    }    
    
    //
    static testMethod void myUnitTest10() { 
        /*Profile p = [Select Id, Name From Profile 
                                    where Name = 'Production Support' 
                                    or Name = 'Service Account' 
                                    or Name ='System Administrator' 
                                    or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'Lion@testCompany999.com';
        u.Alias = 'SF';
        u.ProfileId = p.Id;
        u.CommunityNickname = 'QPS';
        u.IsActive = true;
        insert u;
        
        User identoU = ClsTestHelp.createTestUsers();
        identoU.FirstName ='FirstName';
        identoU.LastName = 'TesterName';
        identoU.Email = 'testme@teatmail.com';
        identoU.Alias = 'SFFH';
        identoU.ProfileId = p.Id;
        identoU.CommunityNickname = 'ASD';
        identoU.IsActive = true;
        identoU.Username = identoU.Email+'2';
        insert identoU;
        
        Account acc = ClsTestHelp.createTestAccounts();  
        acc.Account_Manager__c = u.id;
        //acc.Account_Team_Partner_Function__c = u.id; // add lili 2013.11.28
        insert acc;
        date frozenDate = date.newinstance(2013, 12, 15);
        
        BBB_Month_Bill_Book_Cust__c bbbM1 = new BBB_Month_Bill_Book_Cust__c();
        bbbM1.Customer__c = acc.Id;
        bbbM1.Fiscal_Year__c = '2012';
        bbbM1.Fiscal_Month__c = 7;
        bbbM1.forecast__c = 150;
        bbbM1.Previous_Month_Forecast_Document__c = 200;
        bbbM1.Forecast_2_Months_Document__c = 100;
        bbbM1.Forecast_3_Months_Document__c = 200;
        bbbM1.Forecast_4_Months_Document__c = 300;
        bbbM1.Forecast_5_Months_Document__c = 400;
        bbbM1.Forecast_6_Months_Document__c = 500;
        bbbM1.Forecast_Begin_of_Quarter_Document__c = 700;
        bbbM1.Last_Frozen_Month_Date__c = date.newinstance(2012, 2, 15);

        insert bbbM1; */
            	Apex_Helper_Settings__c ahs1 = ClsTestHelp.createTestName1();
    	Apex_Helper_Settings__c ahs2 = ClsTestHelp.createTestName2();
    	Apex_Helper_Settings__c ahs3 = ClsTestHelp.createTestName3();
    	Apex_Helper_Settings__c ahs4 = ClsTestHelp.createTestName4();
    	Apex_Helper_Settings__c ahs5 = ClsTestHelp.createTestName5();
    	Apex_Helper_Settings__c ahs6 = ClsTestHelp.createTestName6();
    	Apex_Helper_Settings__c ahs7 = ClsTestHelp.createTestName7();
    	Apex_Helper_Settings__c ahs8 = ClsTestHelp.createTestName8();
    	Apex_Helper_Settings__c ahs9 = ClsTestHelp.createTestName9();
    	Apex_Helper_Settings__c ahs10 = ClsTestHelp.createTestName10();
    	Apex_Helper_Settings__c ahs11 = ClsTestHelp.createTestName11();
    	
    	Consumer_Device_Opportunity_Record_Types__c cdort1 = ClsTestHelp.createTestCSD1();
    	Consumer_Device_Opportunity_Record_Types__c cdort2 = ClsTestHelp.createTestCSD2();
    	Consumer_Device_Opportunity_Record_Types__c cdort3 = ClsTestHelp.createTestCSD3();
    	Consumer_Device_Opportunity_Record_Types__c cdort4 = ClsTestHelp.createTestCSD4();
    	Consumer_Device_Opportunity_Record_Types__c cdort5 = ClsTestHelp.createTestCSD5();
    	Consumer_Device_Opportunity_Record_Types__c cdort6 = ClsTestHelp.createTestCSD6();
    	Consumer_Device_Opportunity_Record_Types__c cdort7 = ClsTestHelp.createTestCSD7();
    	
    	RecordType rt2 = ClsTestHelp.createTestRecordType8();
    	
        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
        insert sh;
        
        Account acc2 = ClsTestHelp.createTestAccounts();
        acc2.RecordTypeId = rt2.Id;
        acc2.Name = 'Xxx1';
        acc2.Account_Manager__c = UserInfo.getUserId();
        acc2.SALES_TERRITORY_CDE__c = 'A103754';
        acc2.Sales_Hierarchy__c = sh.Id;
        acc2.Legally_Restricted__c = true;
        acc2.Individually_Planned__c = true;
        acc2.Individually_Forecasted__c = true;
        acc2.Customer_Classification__c = 'A';
    	acc2.Type = 'Global Account';
    	acc2.GAMCD__c = '1000';
    	acc2.SALES_TERRITORY_CDE__c = 'A004841';
        insert acc2;
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Account_Manager__c = UserInfo.getUserId();
        acc.RecordTypeId = rt2.Id;
        acc.SALES_TERRITORY_CDE__c = 'A103754';
        acc.Sales_Hierarchy__c = sh.Id;
        acc.Legally_Restricted__c = true;
        acc.Individually_Planned__c = false;
        acc.Individually_Forecasted__c = true;
        acc.Plan_Group_Account__c = acc2.Id;
        acc.Plan_Group_Id__c = acc2.Id;
        acc.Customer_Classification__c = 'A';
    	acc.Type = 'Global Account';
    	acc.GAMCD__c = '1000';
    	acc.SALES_TERRITORY_CDE__c = 'A004841';
        insert acc;
        
     	BBB_Month_Bill_Book_Cust__c bbb = new BBB_Month_Bill_Book_Cust__c();
    	bbb.Customer__c = acc.Id;
    	bbb.Fiscal_Year__c = '2014';
    	bbb.Fiscal_Month__c = 07;
    	bbb.Bill_Type__c = 'Direct';
    	bbb.Budget_Direct__c = 1;
    	bbb.Budget_POS__c = 2;
    	bbb.Budget_CMA__c = 3;
    	bbb.Budget_TBR_NY__c = 12;
    	bbb.Budget_Document_Currency__c = 11;
    	bbb.CurrencyIsoCode = 'EUR';
    	bbb.Monthly_BBB_External_Key__c = null;
    	bbb.Is_Comment__c = true;
    	bbb.IND_Profit_Centre_Groups__c = 'abc';
    	bbb.SAP_Profit_Center_Group_Code__c = 'G0123';
    	bbb.forecast__c = 1;
    	bbb.Bill_Amount_USD__c = 12;
    	bbb.Backlog_0__c = 1;
    	bbb.Backlog_4__c = 1;
    	bbb.Backlog_5__c = 1;
    	bbb.Backlog_6__c = 1;
    	bbb.Last_Frozen_Month_Date__c = date.today();
    	bbb.Comment__c = '<comments><comment value="100">Comment about a positive forecast risk</comment><comment value="-80">Comment about a negative forecast risk</comment></comments>';
    	insert bbb;
    	
        Forecast_Definition__c fd = new Forecast_Definition__c();
    	fd.Region__c = 'Americas';
    	fd.Profit_Center__c = 'A&C';
    	fd.GSM__c = UserInfo.getUserId();
    	fd.GSM_Name__c = '1234';
    	insert fd;
    	
        Manager_Forecast__c manForecast = new Manager_Forecast__c();
        manForecast.Fiscal_Year__c = '2014';
        manForecast.Fiscal_Month__c = date.today().addMonths(1).month();//modifyied by lili 2014.2.20
        manForecast.Forecast_Definition__c = fd.Id;
        manForecast.Forecast_USD__c = 11;
		insert manForecast;
		
        List<BBB_Month_Bill_Book_Cust__c> list_BBMonths = [select Bill_Amount_USD__c,Backlog_0__c,Backlog_4__c,Backlog_5__c,Backlog_6__c,Last_Frozen_Month_Date__c,Id,forecast__c,Fiscal_Date__c,Comment__c,SAP_Profit_Center_Group_Code__c,IND_Profit_Centre_Groups__c,Monthly_BBB_External_Key__c,Is_Comment__c,CurrencyIsoCode,Budget_Document_Currency__c,Budget_TBR_NY__c,Budget_CMA__c,Budget_POS__c,Customer__c,Fiscal_Year__c,Fiscal_Month__c,Bill_Type__c,Budget_Direct__c from BBB_Month_Bill_Book_Cust__c where Id =: bbb.Id];
        List<Manager_Forecast__c> list_mgForecasts = [select Last_Frozen_Month_Date__c,Forecast_USD__c,Forecast_0_Months_Document__c,Id,Fiscal_Year__c,Fiscal_Date__c,Forecast_Definition__c,Fiscal_Month__c from Manager_Forecast__c where Id =: manForecast.Id];
        //system.debug('list_mgForecasts::::'+list_mgForecasts);
        Test.startTest(); 
        
        ClsFinancialFCBatchUtil.setBBBMonthBillBookCust(list_BBMonths, date.newinstance(2014, 8, 15), false, false); 
        ClsFinancialFCBatchUtil.setBBBMonthBillBookCust(list_BBMonths, date.newinstance(2014, 9, 15), false, true); 
        ClsFinancialFCBatchUtil.setBBBMonthBillBookCust(list_BBMonths, date.newinstance(2014, 10, 15), true, false); 
        ClsFinancialFCBatchUtil.setBBBMonthBillBookCust(list_BBMonths, date.newinstance(2014, 11, 15), false, false); 
        ClsFinancialFCBatchUtil.setBBBMonthBillBookCust(list_BBMonths, date.newinstance(2014, 12, 15), false, true); 
        ClsFinancialFCBatchUtil.setBBBMonthBillBookCust(list_BBMonths, date.newinstance(2015, 1, 15), true, false); 
        
        
        
        ClsFinancialFCBatchUtil.setManagerForecast(list_mgForecasts, date.today(), false, true);
        ClsFinancialFCBatchUtil.setBBBMonthBacklog(list_BBMonths, date.today(), ' Select id From BBB_Month_Bill_Book_Cust__c where id != null ');
        ClsFinancialFCBatchUtil.setBBBMonthCurrency(list_BBMonths);
        
        system.assert(true);
        Test.stopTest();
    }

}