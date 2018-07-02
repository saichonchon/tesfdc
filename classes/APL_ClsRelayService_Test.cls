/**
 *  This test class is used to test APL_ClsAMService
 *  
 * @author Weihang Li
 * @created 2015-06-12
 * @version 1.0
 * @since 29.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2015-06-12 Weihang Li <weihang.li@itbconsult.com>
 * - coverage 87% 
 * - Created
 *
 */
@isTest
private class APL_ClsRelayService_Test {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();       
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();     
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        
    	RecordType rt2 = ClsTestHelp.createTestRecordType8();
        
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
    	
        List<Account> lstAccount = new List<Account>();
    	Account acct = ClsTestHelp.createTestAccounts();
    	acct.Name = 'axx';
    	acct.RecordTypeId = rt2.Id;
    	acct.AccountNumber = '123456';
    	//acct.APL_Relay_forecast_Plan_Account__c = acct.Id;
    	acct.APL_Relay_Currency__c = 'USD';
    	acct.APL_Relay_Display_Name__c = 'testName';
    	acct.APL_AM_forecast_Plan_Account__c = acct.Id;
        acct.APL_Relay_forecast_Plan_Account__c = acct.Id;
    	acct.APL_AM_Currency__c = 'USD';
    	acct.APL_AM_Display_Name__c = 'amTestName';
    	acct.Account_Manager__c = userInfo.getUserId();
    	acct.STATDESC__c = 'Active';
    	acct.SALES_TERRITORY_CDE__c = '123456';
    	acct.Relay_Specialist_Territory_Code__c = '123456';   
    	lstAccount.add(acct);
    	//insert acct;        
        
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
    	//relayAcct.Sales_Hierarchy__c = sh.Id;	
    	relayAcct.STATDESC__c = 'Active';
    	lstAccount.add(relayAcct);
    	
    	Account amAcct = ClsTestHelp.createTestAccounts();
    	amAcct.Name = 'axx';
    	amAcct.RecordTypeId = rt2.Id;
    	amAcct.APL_AM_forecast_Plan_Account__c = acct.Id;
        amAcct.APL_Relay_forecast_Plan_Account__c = acct.Id;
    	amAcct.APL_AM_Currency__c = 'USD';
    	amAcct.APL_AM_Display_Name__c = 'amTestName';
    	amAcct.APL_AM_ParentAccount__c = acct.Id;    	
    	amAcct.Account_Manager__c = userInfo.getUserId();
    	amAcct.SALES_TERRITORY_CDE__c = '123456';
    	amAcct.Relay_Specialist_Territory_Code__c = '123456';
    	amAcct.GAMCD__c = '1234';
    	//amAcct.Sales_Hierarchy__c = sh.Id;	
    	amAcct.STATDESC__c = 'Active';
    	lstAccount.add(amAcct);
    	    	
        insert lstAccount;
        Account qmxAcc = [select id,APL_Relay_forecast_Plan_Account__c from Account where id  = :relayAcct.id];
        qmxAcc.APL_Relay_forecast_Plan_Account__c =acct.id;
        update qmxAcc;
         Account qmxAcc2 = [select id,APL_Relay_forecast_Plan_Account__c from Account where id  = :relayAcct.id];
        system.debug('qmx_qmxAcc2::'+qmxAcc.APL_Relay_forecast_Plan_Account__c);
        system.debug('qmx_acct.id::'+acct.id);
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
    	ph.Name = '123';
    	ph.CBC2__c = '30012';
    	ph.CBC3__c = '30033';
    	ph.CBC1_Description__c = 'Appliances';
        //insert ph;
        
        Product_Hierarchy__c ph1 = new Product_Hierarchy__c();
    	ph1.Name = '1234';
    	ph1.CBC2__c = '13213';
    	ph1.CBC3__c = '30033';
    	ph1.CBC1_Description__c = 'Appliances';
        //insert ph1;
        
        Product_Hierarchy__c ph2 = new Product_Hierarchy__c();
    	ph2.Name = '1234';
    	ph2.CBC1__c = '45678';
    	ph2.CBC2__c = '13213';
    	ph2.CBC3__c = '30033';
    	ph2.CBC1_Description__c = 'Appliances';
        insert new List<Product_Hierarchy__c>{ph2,ph1,ph};
        
        Part__c part = new Part__c();
        part.Name = 'testPart';
        part.GPL__c = ph.Id;
        part.Product_Hierarchy__c = ph.Id; 
        part.Description__c = 'test';
        part.PRODUCT_CDE__c = 'TEST1';
        part.PROD_NAME__c = 'test name1';
        //insert part;
        
        Part__c part1 = new Part__c();
        part1.Name = 'testPart';
        part1.GPL__c = ph1.Id;
        part1.Product_Hierarchy__c = ph1.Id; 
        part1.Description__c = 'test';
        part1.PRODUCT_CDE__c = 'TEST3';
        part1.PROD_NAME__c = 'test name2';
        //insert part1;
        
        Part__c part2 = new Part__c();
        part2.Name = 'testPart';
        part2.GPL__c = ph2.Id;
        part2.Product_Hierarchy__c = ph2.Id; 
        part2.Description__c = 'test';
        part2.PRODUCT_CDE__c = 'TEST3';
        part2.PROD_NAME__c = 'test name3';
        insert new List<Part__c>{part,part1,part2};
    	
    	APL_Sales_Forecast__c aplFC1 = new APL_Sales_Forecast__c();
		aplFC1.type__c = 'GPL';
		aplFC1.Fiscal_Year__c = '2015';
		aplFC1.Fiscal_Quarter__c = '04';
		aplFC1.customer__c = amAcct.Id;
		aplFC1.RSM_Forecast__c = 10;
		aplFC1.GPL__c = ph.Id;
		aplFC1.Part__c = part.Id;
		//insert aplFC1;
		
		APL_Sales_Forecast__c aplFC3 = new APL_Sales_Forecast__c();
		aplFC3.type__c = 'Relay Product Code';
		aplFC3.Fiscal_Year__c = '2015';
		aplFC3.Fiscal_Quarter__c = '04';
		aplFC3.customer__c = relayAcct.Id;
		aplFC3.PRODUCT_CDE__c = part1.PRODUCT_CDE__c;
		aplFC3.PROD_NAME__c = part1.PROD_NAME__c;
		aplFC3.Relay_CBC2_Code__c = ph1.CBC2__c;
		aplFC3.RSM_Forecast__c = 10;
		//insert aplFC3;
		
		
		APL_Sales_Forecast__c aplFC2 = new APL_Sales_Forecast__c();
		aplFC2.type__c = 'Relay';
		aplFC2.Fiscal_Year__c = '2015';
		aplFC2.Fiscal_Quarter__c = '04';
		aplFC2.customer__c = relayAcct.Id;
		aplFC2.Part__c = part1.Id;
		aplFC2.GPL__c = ph1.Id;
		aplFC2.RSM_Forecast__c = 10;
        insert new List<APL_Sales_Forecast__c>{aplFC1,aplFC2,aplFC3};
            
 		APL_Sales_Forecast__c aplsfc = [Select  Customer__r.STATDESC__c, Part__r.Product_Hierarchy__r.CBC2__c, Customer__r.Relay_Specialist_Territory_Code__c,Customer__r.APL_Relay_forecast_Plan_Account__c,Fiscal_Quarter__c,Fiscal_Year__c, Type__c ,Part__r.PRODUCT_CDE__c From  APL_Sales_Forecast__c where Type__c= 'Relay'  limit 1]; 
        system.debug('qmx_aplsfc:'+aplsfc.Customer__r.STATDESC__c) ; 
        system.debug('qmx_aplsfc:'+aplsfc.Part__r.Product_Hierarchy__r.CBC2__c) ; 
        system.debug('qmx_aplsfc:'+aplsfc.Customer__r.Relay_Specialist_Territory_Code__c) ; 
        system.debug('qmx_aplsfc:'+aplsfc.Customer__r.APL_Relay_forecast_Plan_Account__c) ; 
		system.debug('qmx_aplsfc:'+aplsfc.Part__r.PRODUCT_CDE__c); 
        
		APL_RSM__c aplRsm = new APL_RSM__c();
		aplRsm.Manager__c = userInfo.getUserId();
		aplRsm.Display_Name__c = 'test';
		//insert aplRsm;
		
		APL_RSM__c aplRsm1 = new APL_RSM__c();
		aplRsm1.Manager__c = userInfo.getUserId();
		aplRsm1.Type__c = 'Relay';
		aplRsm1.Display_Name__c = 'test2';
		//insert aplRsm1;
		
		APL_RSM__c aplRsm2 = new APL_RSM__c();
		aplRsm2.Manager__c = userInfo.getUserId();
		aplRsm2.Type__c = 'AM';
		aplRsm2.Display_Name__c = 'test1';
		aplRsm2.APL_RSM__c = aplRsm1.Id;
        insert new List<APL_RSM__c>{aplRsm,aplRsm1,aplRsm2};
    	
    	RecordType rt25 = ClsTestHelp.createTestRecordType26(); 
    	APL_Forecast_Management__c apl = new APL_Forecast_Management__c();
    	apl.Name = 'testName';
    	apl.A6_Code__c = '123456';
    	apl.Manager__c = userInfo.getUserId();  
    	apl.RSM__c = aplRsm2.Id;
    	apl.GAM_Code__c = '1234';
    	apl.RecordTypeId = rt25.Id;
    	//insert apl;
    	
    	APL_Forecast_Management__c apl1 = new APL_Forecast_Management__c();
    	apl1.Name = 'testName1';
    	apl1.A6_Code__c = '123456';
    	apl1.GAM_Code__c = '1234';
    	apl1.Manager__c = userInfo.getUserId();
    	apl1.RecordTypeId = rt25.Id;
    	apl1.RSM__c = aplRsm1.Id;
        insert new List<APL_Forecast_Management__c>{apl,apl1};
    	
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
        
        so.set_fiscalMonth.add('2117_11');
        so.set_fiscalMonth.add('2015_8');
        String sData = JSON.serialize(so);
        
        APL_ClsEntityType.APLForecastValueObj so2 = new APL_ClsEntityType.APLForecastValueObj();
        
        so2.grouping ='test';
    	so2.cbc2Code ='13213';
    	so2.productcode ='test';
    	so2.productname ='test';
        so2.accnumber ='test';
        so2.partId =part.id;
        so2.gplId ='test';
        so2.territoryCode ='test';
        so2.managerId ='test';
        so2.price =10;
        so2.currencyIso ='test';
        so2.map_year_quartersFuture = new map<String, set<String>>{
        	'2015'=> new set<String>{'03', '04'},
        	'2016'=> new set<String>{'01', '02', '03', '04'},
        	'2017'=> new set<String>{'01'}
        };
        so2.map_datekey_csFC = new map<String,decimal>{
            'test'=>10 
        };
        String sData2 = JSON.serialize(so2);
        
        APL_ClsRelayService.SearchLevel1 level1 = new APL_ClsRelayService.SearchLevel1();
        level1.getRefData(sData);
        level1.getBacklogRefData(sData);
        

        APL_ClsRelayService.SearchLevel2 level2 = new APL_ClsRelayService.SearchLevel2();
        
        so.cbc2Code =  ph2.CBC2__c;
        sData = JSON.serialize(so);
        level2.getExistResult(sData);
        level2.getRefData(sData);
        level2.getBacklogRefData(sData);
        
        
        APL_ClsRelayService.SearchLevel3 level3 = new APL_ClsRelayService.SearchLevel3();
        so.isOtherMethod = false;
        level3.getSearchResult(sData);
        level3.getExistResult(sData);
        
        so.accnumber = part2.PRODUCT_CDE__c;
        sData = JSON.serialize(so);
        level3.getRefData(sData);
        level3.getBacklogRefData(sData);
        level3.saveSObjectData(sData2);
        level3.deleteAPLObject(sdata);
        
        APL_ClsRelayService.SearchLevel4 level4 = new APL_ClsRelayService.SearchLevel4();
        
        level4.getSearchResult(sData);
        
        so.isOtherMethod = true;
        sData = JSON.serialize(so);
        level4.getSearchResult(sData);
        
        level4.getExistResult(sData);
        
        so.partId = part2.Id;
        sData = JSON.serialize(so);
        level4.getRefData(sData);
        level4.getBacklogRefData(sData);
        level4.saveSObjectData(sData2);
        level4.deleteAPLObject(sData);
        
        
        Test.stopTest();
    }
}