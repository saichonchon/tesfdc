/**
*  This test class used to Cls_BatchCalculateForecastBilling_PLM.
*
@author Jinbo Shan
@created 2015-03-27
@version 1.0   
@since 30.0
*
@changelog
* coverage  78%
* 
* 
2015-03-27 Jinbo Shan <jinbo.shan@itbconsult.com>
* - Created
*/
@isTest(seeAllData=true) 
private class Cls_BatchCalculateForecastBilling_PLTest {

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
              
        system.runAs(u){  
	    	list<Account> list_sos = new list<Account>();
	    	
	        Account acc = ClsTestHelp.createTestAccounts();
	        acc.Name='testdssaa';
	        acc.Type = 'CM';
            //Test.startTest();
	        insert acc;
	    	//Test.stopTest();
            
	    	list_sos.add(acc);
	    	
            Test.startTest();
	        Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Name = 'test111221';
            oppy.CurrencyIsoCode = 'EUR';
            oppy.Type = 'New Business';
            oppy.Description = 'test1';
            oppy.Distributor__c = 'Dachs1';
            oppy.Manufacturing_Start_Date__c = date.today();
            oppy.CloseDate = date.today().addMonths(1);
	        oppy.RecordTypeId = rt3.Id;
	        oppy.Level__c = 'Quarterly';
	        oppy.AccountId = acc.Id;
	        oppy.PLM_Id__c = 'JinboTest123456';
	        insert oppy;
            Test.stopTest();

	    	Product_Hierarchy__c ph = new Product_Hierarchy__c();
	    	ph.Name = '00122333';
	    	insert ph;
	    	
	    	Part__c p = new Part__c();
	    	p.Product_Hierarchy__c = ph.Id;
	    	p.PLM_Id__c = 'JinboTest123456';
	    	insert p;
	    	
	    	Opportunity_Part__c op = new Opportunity_Part__c();
	    	op.Part__c = p.Id;
	    	op.Opportunity__c = oppy.Id;
	    	insert op;
	    	
	    	Opportunity_Forecast__c ofc = new Opportunity_Forecast__c();
	    	ofc.Opportunity__c = oppy.Id;
	    	ofc.Amount__c = 10;
	    	ofc.Part__c = op.Id;
	    	ofc.Date__c = startDate;
	    	ofc.Fiscal_Quarter__c = '0' + currentQuarter;
	    	ofc.Fiscal_Year__c = currentYear;
	    	insert ofc;
	    	oppy.StageName = oppyStageName;
	        update oppy;
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
			
            Forecast_Snapshot__c snap = new Forecast_Snapshot__c();
            snap.Part__c = op.Id;            
            snap.Opportunity__c = oppy.Id;
            snap.Date__c = startDate;
            insert snap;
	    	//Test.startTest();
	    	Cls_BatchCalculateForecastBilling_PLM clsBatch = new Cls_BatchCalculateForecastBilling_PLM();
	    	//Database.BatchableContext BC;
	    	clsBatch.filter = 'Id = \'' + oppy.Id + '\'';
	    	database.executeBatch(clsBatch);
	      	//clsBatch.start(BC);
	    	//clsBatch.execute(BC, list_sos);
	    	//clsBatch.finish(BC);
	    	//Test.stopTest();
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
              
        system.runAs(u){
	    	list<Account> list_sos = new list<Account>();
	    	
	        Account acc = ClsTestHelp.createTestAccounts();
	        acc.Type = 'CM';
	        acc.Name = 'sdsaaaatest';
	        insert acc;
	    	list_sos.add(acc);
	    	
	        Opportunity oppyMonth = ClsTestHelp.createTestOpportunity();
	        oppyMonth.Name = 'tssest111';
            oppyMonth.CurrencyIsoCode = 'EUR';
            oppyMonth.Type = 'New Business';
            oppyMonth.Description = 'test11';
            oppyMonth.Distributor__c = 'Dachs11';
            oppyMonth.Manufacturing_Start_Date__c = date.today();
            oppyMonth.CloseDate = date.today().addMonths(1);
	        oppyMonth.RecordTypeId = rt3.Id;
	        oppyMonth.Level__c = 'Monthly';
	        oppyMonth.AccountId = acc.Id;
	        oppyMonth.PLM_Id__c = 'JinboTest12345';
	        insert oppyMonth;
	        
	    	Product_Hierarchy__c ph1 = new Product_Hierarchy__c();
	    	ph1.Name = '001223332';
	    	insert ph1;
	    	
	    	Part__c p1 = new Part__c();
	    	p1.Product_Hierarchy__c = ph1.Id;
	    	p1.PLM_Id__c = 'JinboTest12345';
	    	insert p1;
	    	
	    	Opportunity_Part__c op1 = new Opportunity_Part__c();
	    	op1.Part__c = p1.Id;
	    	op1.Opportunity__c = oppyMonth.Id;
	    	insert op1;
	    	
	    	Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
	        oppyForecast.Opportunity__c = oppyMonth.Id;
	        oppyForecast.Part__c = op1.Id;
	        //oppyForecast.Date__c = startDate;
	        oppyForecast.Amount__c = 10;
	        oppyForecast.Fiscal_Month__c = currentMonthString;
	        oppyForecast.Fiscal_Year__c = currentYear;
	        insert oppyForecast;
	    	
            Test.startTest();
	    	oppyMonth.StageName = oppyStageName;
	        update oppyMonth;
            Test.stopTest();
            
            Forecast_Snapshot__c snap = new Forecast_Snapshot__c();
            snap.Part__c = op1.Id;            
            snap.Opportunity__c = oppyMonth.Id;
            snap.Date__c = startDate;
            insert snap;
	    	
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
	    	
	    	//Test.startTest();
	    	Cls_BatchCalculateForecastBilling_PLM clsBatch = new Cls_BatchCalculateForecastBilling_PLM();
	    	//Database.BatchableContext BC;
	    	clsBatch.filter = 'Id = \'' + oppyMonth.Id + '\'';
	    	database.executeBatch(clsBatch);
	      	//clsBatch.start(BC);
	    	//clsBatch.execute(BC, list_sos);
	    	//clsBatch.finish(BC);
	    	//Test.stopTest();
        }
    }
}