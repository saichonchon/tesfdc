/**
*  This test class used to test class APL_ClsRSMRelayService.
*
@author Lili Zhao
@created 2014-08-20
*
@changelog
* coverage  78%
*  
2014-08-15 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest
private class APL_ClsRSMRelayService_Test {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();
        
    	RecordType rt2 = ClsTestHelp.createTestRecordType8();
    	
    	Consumer_Device_Opportunity_Record_Types__c cdort1 = ClsTestHelp.createTestCSD1();
    	Consumer_Device_Opportunity_Record_Types__c cdort2 = ClsTestHelp.createTestCSD2();
    	Consumer_Device_Opportunity_Record_Types__c cdort3 = ClsTestHelp.createTestCSD3();
    	Consumer_Device_Opportunity_Record_Types__c cdort4 = ClsTestHelp.createTestCSD4();
    	Consumer_Device_Opportunity_Record_Types__c cdort5 = ClsTestHelp.createTestCSD5();
    	Consumer_Device_Opportunity_Record_Types__c cdort6 = ClsTestHelp.createTestCSD6();
    	Consumer_Device_Opportunity_Record_Types__c cdort7 = ClsTestHelp.createTestCSD7();
        
        List<Trigger_Configuration__c> lstTriggerConfig = new  List<Trigger_Configuration__c>();
       
        Trigger_Configuration__c tc = new Trigger_Configuration__c(); 
        tc.Name='Avoid Duplicate PLM Id';
        tc.isRun__c=true;
        lstTriggerConfig .add(tc);
               
        Trigger_Configuration__c tc2 = new Trigger_Configuration__c(); 
        tc2.Name='DND Lead Conversion Initialization';
        tc2.isRun__c=true;
        lstTriggerConfig .add(tc2);
        
        Trigger_Configuration__c tc3 = new Trigger_Configuration__c(); 
        tc3.Name='Identify Fiscal Year';
        tc3.isRun__c=true;
        lstTriggerConfig .add(tc3);
        
        Trigger_Configuration__c tc4 = new Trigger_Configuration__c(); 
        tc4.Name='Populate Opportunity Partner';
        tc4.isRun__c=true;
        lstTriggerConfig .add(tc4);
        
        Trigger_Configuration__c tc5 = new Trigger_Configuration__c(); 
        tc5.Name='updateAccountBusinessUnit';
        tc5.isRun__c=true;
        lstTriggerConfig .add(tc5);
        
        insert lstTriggerConfig ;
        
        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy1();
    	sh.Level_2_Territory_Code__c = '103004';
        insert sh;
    	
    	Account acct = ClsTestHelp.createTestAccounts();
    	acct.Name = 'axx';
    	acct.RecordTypeId = rt2.Id;
    	acct.AccountNumber = '123456';
    	acct.APL_Relay_forecast_Plan_Account__c = acct.Id;
    	acct.APL_Relay_Currency__c = 'USD';
    	acct.APL_Relay_Display_Name__c = 'testName';
    	acct.APL_AM_forecast_Plan_Account__c = acct.Id;
    	acct.APL_AM_Currency__c = 'USD';
    	acct.APL_AM_Display_Name__c = 'amTestName';
    	acct.Account_Manager__c = userInfo.getUserId();
    	acct.STATDESC__c = 'Active';
    	acct.SALES_TERRITORY_CDE__c = '123456';
    	acct.Relay_Specialist_Territory_Code__c = '123456';   
    	insert acct;
    	
    	Account relayAcct = ClsTestHelp.createTestAccounts();
    	relayAcct.Name = 'relayAcctaxx';
    	relayAcct.RecordTypeId = rt2.Id;
    	relayAcct.Account_Manager__c = userInfo.getUserId();
    	relayAcct.APL_Relay_forecast_Plan_Account__c = acct.Id;
    	relayAcct.APL_AM_forecast_Plan_Account__c = acct.Id;
    	relayAcct.APL_Relay_Currency__c = 'USD';
    	relayAcct.APL_Relay_Display_Name__c = 'testName';
    	relayAcct.APL_Relay_ParentAccount__c = acct.Id;
    	relayAcct.SALES_TERRITORY_CDE__c = '123456';
    	relayAcct.Relay_Specialist_Territory_Code__c = '123456';  
    	relayAcct.GAMCD__c = '1234'; 
    	relayAcct.Sales_Hierarchy__c = sh.Id;	
    	relayAcct.STATDESC__c = 'Active';
    	insert relayAcct;
    	
    	Account relayAcct1 = ClsTestHelp.createTestAccounts();
    	relayAcct1.Name = 'relayAcctaxx';
    	relayAcct1.RecordTypeId = rt2.Id;
    	relayAcct1.Account_Manager__c = userInfo.getUserId();
    	relayAcct1.APL_Relay_forecast_Plan_Account__c = acct.Id;
    	relayAcct1.APL_Relay_Currency__c = 'USD';
    	relayAcct1.APL_Relay_Display_Name__c = 'testName';
    	relayAcct1.APL_Relay_ParentAccount__c = acct.Id;
    	relayAcct1.SALES_TERRITORY_CDE__c = '123456';   
    	relayAcct1.GAMCD__c = '1234'; 	
    	relayAcct1.Relay_Specialist_Territory_Code__c = '123456';
    	relayAcct1.STATDESC__c = 'Active';
    	insert relayAcct1;
    	
    	Account amAcct = ClsTestHelp.createTestAccounts();
    	amAcct.Name = 'axx';
    	amAcct.RecordTypeId = rt2.Id;
    	amAcct.APL_AM_forecast_Plan_Account__c = acct.Id;
    	amAcct.APL_AM_Currency__c = 'USD';
    	amAcct.APL_AM_Display_Name__c = 'amTestName';
    	amAcct.APL_AM_ParentAccount__c = acct.Id;    	
    	amAcct.Account_Manager__c = userInfo.getUserId();
    	amAcct.SALES_TERRITORY_CDE__c = '123456';
    	amAcct.Relay_Specialist_Territory_Code__c = '123456';
    	amAcct.GAMCD__c = '1234';
    	amAcct.Sales_Hierarchy__c = sh.Id;	
    	amAcct.STATDESC__c = 'Active';
    	insert amAcct;
    	
    	Account amAcct1 = ClsTestHelp.createTestAccounts();
    	amAcct1.Name = 'axx';
    	amAcct1.RecordTypeId = rt2.Id;
    	amAcct1.APL_AM_forecast_Plan_Account__c = null;
    	amAcct1.APL_AM_Currency__c = 'USD';
    	amAcct1.APL_AM_Display_Name__c = 'amTestName';
    	amAcct1.APL_AM_ParentAccount__c = acct.Id;    	
    	amAcct1.Account_Manager__c = userInfo.getUserId();
    	amAcct1.SALES_TERRITORY_CDE__c = '123456';
    	amAcct1.Relay_Specialist_Territory_Code__c = '123456';
    	amAcct1.GAMCD__c = '1234';
    	amAcct1.Sales_Hierarchy__c = sh.Id;	
    	insert amAcct1;
    	
    	Product_Hierarchy__c ph = new Product_Hierarchy__c();
    	ph.Name = '123';
    	ph.CBC2__c = '30012';
    	ph.CBC3__c = '30033';
    	ph.CBC1_Description__c = 'Appliances';
        insert ph;
        
        Product_Hierarchy__c ph1 = new Product_Hierarchy__c();
    	ph1.Name = '1234';
    	ph1.CBC2__c = '13213';
    	ph1.CBC3__c = '30033';
    	ph1.CBC1_Description__c = 'Appliances';
        insert ph1;
        
        Product_Hierarchy__c ph2 = new Product_Hierarchy__c();
    	ph2.Name = '1234';
    	ph2.CBC1__c = '45678';
    	ph2.CBC2__c = '13213';
    	ph2.CBC3__c = '30033';
    	ph2.CBC1_Description__c = 'Appliances';
        insert ph2;
        
        Part__c part = new Part__c();
        part.Name = 'testPart';
        part.GPL__c = ph.Id;
        part.Product_Hierarchy__c = ph.Id; 
        part.Description__c = 'test';
        part.PRODUCT_CDE__c = 'TEST1';
        part.PROD_NAME__c = 'test name1';
        insert part;
        
        Part__c part1 = new Part__c();
        part1.Name = 'testPart';
        part1.GPL__c = ph1.Id;
        part1.Product_Hierarchy__c = ph1.Id; 
        part1.Description__c = 'test';
        part1.PRODUCT_CDE__c = 'TEST2';
        part1.PROD_NAME__c = 'test name2';
        insert part1;
        
        Part__c part2 = new Part__c();
        part2.Name = 'testPart';
        part2.GPL__c = ph2.Id;
        part2.Product_Hierarchy__c = ph2.Id; 
        part2.Description__c = 'test';
        part2.PRODUCT_CDE__c = 'TEST3';
        part2.PROD_NAME__c = 'test name3';
        insert part2;
    	
    	APL_Sales_Forecast__c aplFC1 = new APL_Sales_Forecast__c();
		aplFC1.type__c = 'GPL';
		aplFC1.Fiscal_Year__c = '2015';
		aplFC1.Fiscal_Quarter__c = '04';
		aplFC1.customer__c = amAcct.Id;
		aplFC1.RSM_Forecast__c = 10;
		aplFC1.GPL__c = ph.Id;
		aplFC1.Part__c = part.Id;
		insert aplFC1;
		
		APL_Sales_Forecast__c aplFC3 = new APL_Sales_Forecast__c();
		aplFC3.type__c = 'Relay Product Code';
		aplFC3.Fiscal_Year__c = '2015';
		aplFC3.Fiscal_Quarter__c = '04';
		aplFC3.customer__c = relayAcct.Id;
		aplFC3.PRODUCT_CDE__c = part1.PRODUCT_CDE__c;
		aplFC3.PROD_NAME__c = part1.PROD_NAME__c;
		aplFC3.Relay_CBC2_Code__c = ph1.CBC2__c;
		aplFC3.RSM_Forecast__c = 10;
		insert aplFC3;
		
		
		APL_Sales_Forecast__c aplFC2 = new APL_Sales_Forecast__c();
		aplFC2.type__c = 'Relay';
		aplFC2.Fiscal_Year__c = '2015';
		aplFC2.Fiscal_Quarter__c = '04';
		aplFC2.customer__c = relayAcct.Id;
		aplFC2.Part__c = part1.Id;
		aplFC2.GPL__c = ph1.Id;
		aplFC2.RSM_Forecast__c = 10;
		insert aplFC2;
		
		APL_RSM__c aplRsm = new APL_RSM__c();
		aplRsm.Manager__c = userInfo.getUserId();
		aplRsm.Display_Name__c = 'test';
		aplRsm.Active__c = true;
		insert aplRsm;
		
		APL_RSM__c aplRsm1 = new APL_RSM__c();
		aplRsm1.Manager__c = userInfo.getUserId();
		aplRsm1.Type__c = 'Relay';
		aplRsm1.Display_Name__c = 'test2';
		aplRsm1.Active__c = true;
		insert aplRsm1;
		
		APL_RSM__c aplRsm2 = new APL_RSM__c();
		aplRsm2.Manager__c = userInfo.getUserId();
		aplRsm2.Type__c = 'AM';
		aplRsm2.Display_Name__c = 'test1';
		aplRsm2.APL_RSM__c = aplRsm1.Id;
		aplRsm2.Active__c = true;
		insert aplRsm2;
    	
    	RecordType rt25 = ClsTestHelp.createTestRecordType26(); 
    	APL_Forecast_Management__c apl = new APL_Forecast_Management__c();
    	apl.Name = 'testName';
    	apl.A6_Code__c = '123456';
    	apl.Manager__c = userInfo.getUserId();  
    	apl.RSM__c = aplRsm2.Id;
    	apl.GAM_Code__c = '1234';
    	apl.RecordTypeId = rt25.Id;
    	insert apl;
    	
    	APL_Forecast_Management__c apl1 = new APL_Forecast_Management__c();
    	apl1.Name = 'testName1';
    	apl1.A6_Code__c = '123456';
    	apl1.GAM_Code__c = '1234';
    	apl1.Manager__c = userInfo.getUserId();
    	apl1.RecordTypeId = rt25.Id;
    	apl1.RSM__c = aplRsm1.Id;
    	insert apl1;
    	
    	BBB_Month_Bill_Book_Cust_PN__c bbbMon = new BBB_Month_Bill_Book_Cust_PN__c();
    	bbbMon.Customer__c = amAcct.Id;
    	bbbMon.Bill_Amount_USD__c = 10;
    	bbbMon.Book_Amount_USD__c = 10; 
    	bbbMon.Fiscal_Year__c = '2015';
    	bbbMon.Fiscal_Month__c = 8;
    	bbbMon.Profit_Center__c = 'APL';
    	bbbMon.Part__c = part.Id;
    	insert bbbMon;
    	
    	BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c bbbDay = new BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c();
    	bbbDay.Backlog_Amount_USD__c = 10;
    	bbbDay.Bill_Amount_USD__c = 10; 
    	bbbDay.Book_Amount_USD__c = 10;
    	bbbDay.Customer__c = amAcct.Id;
    	bbbDay.Fiscal_Year__c = '2015';
    	bbbDay.Fiscal_Month__c = 9;
    	bbbDay.Customer_Request_Date_Fiscal_Year__c = '2015';
    	bbbday.Customer_Request_Date_Fiscal_Month__c = 9;
    	bbbDay.Profit_Center__c = 'APL';
    	bbbDay.Part__c = part.Id;
    	insert bbbDay;
		
		APL_RSM_Overall_Forecast__c aplOver = new APL_RSM_Overall_Forecast__c();
		aplOver.Fiscal_Quarter__c = '04';
		aplOver.Fiscal_Year__c = '2015';
		aplOver.APL_RSM__c = aplRsm.Id;
		aplOver.RSM_Overall_Forecast__c = 10;		
		insert aplOver;
		
		Test.startTest();
		
        APL_ClsEntityType.SearchObj so = ClsTestHelp.createSearchObj();
        so.set_fiscalMonth = new set<String>();
        so.set_fiscalMonth.add('2015_5');
        so.currencyIso = 'USD';
        so.territoryCode = '123456';
        so.managerId = userInfo.getUserId();
        so.rsmgrouping = APL_ClsUtils.OTHER;
        
        so.grouping = acct.Id;
        so.map_year_quartersFuture = new map<String, set<String>>{
        	'2015'=> new set<String>{'03', '04'},
        	'2016'=> new set<String>{'01', '02', '03', '04'},
        	'2017'=> new set<String>{'01'}
        };
        so.set_selectedId = new set<String>();
        so.set_fiscalMonth.add('2016_9');
        so.set_fiscalMonth.add('2015_8');
        String sData = JSON.serialize(so);
        
        APL_ClsRSMRelayService.SearchLevelTotal totalLevel = new APL_ClsRSMRelayService.SearchLevelTotal();
        totalLevel.getRefData(sData);
        totalLevel.getBacklogRefData(sData);
        
        APL_ClsRSMRelayService.SearchLevel1 level1 = new APL_ClsRSMRelayService.SearchLevel1();
        level1.getRefData(sData);
        level1.getBacklogRefData(sData);
        

        APL_ClsRSMRelayService.SearchLevel2 level2 = new APL_ClsRSMRelayService.SearchLevel2();
        
        so.cbc2Code =  ph2.CBC2__c;
        sData = JSON.serialize(so);
        level2.getExistResult(sData);
        level2.getRefData(sData);
        level2.getBacklogRefData(sData);
        
        
        APL_ClsRSMRelayService.SearchLevel3 level3 = new APL_ClsRSMRelayService.SearchLevel3();
        level3.setCBC2Column(new list<APL_ClsEntityType.Cbc2Object>());
        level3.getSearchResult(sData);
        level3.getExistResult(sData);
        
        so.accnumber = part2.PRODUCT_CDE__c;
        sData = JSON.serialize(so);
        level3.getRefData(sData);
        level3.getBacklogRefData(sData);
        
        APL_ClsRSMRelayService.SearchLevel4 level4 = new APL_ClsRSMRelayService.SearchLevel4();

        so.isOtherMethod = true;
        sData = JSON.serialize(so);

        level4.getExistResult(sData);
        
        so.partId = part2.Id;
        sData = JSON.serialize(so);
        level4.getRefData(sData);
        level4.getBacklogRefData(sData);
        
        
        APL_ClsRSMRelayService.SearchLevel5 level5 = new APL_ClsRSMRelayService.SearchLevel5();

        so.isOtherMethod = true;
        sData = JSON.serialize(so);

        level5.getExistResult(sData);
        
        so.partId = part2.Id;
        sData = JSON.serialize(so);
        level5.getRefData(sData);
        level5.getBacklogRefData(sData);
        
        
        APL_ClsEntityType.RSMRelayOverRallInfo overRallInfo = new APL_ClsEntityType.RSMRelayOverRallInfo();
        overRallInfo.set_displayNames = new set<String>();
        overRallInfo.set_rsmIds = new set<String>();
        overRallInfo.map_year_quartersFuture = new map<String, set<String>>();
        overRallInfo.map_name_map_dateKey_fc = new map<String, map<String, decimal>>();
        
        overRallInfo.set_displayNames.add('test');
        overRallInfo.set_rsmIds.add(aplRsm.Id);
        map<String, decimal> map_month_dec = new map<String, decimal>();
        map_month_dec.put('2015_04', 11);
        set<String> set_quarters = new set<String>();
        set_quarters.add('04');
        overRallInfo.map_year_quartersFuture.put('2015', set_quarters);
        overRallInfo.map_name_map_dateKey_fc.put('test', map_month_dec);
        sData = Json.serialize(overRallInfo);
        totalLevel.saveSObjectData(sData);
        
        Test.stopTest();
    }
}