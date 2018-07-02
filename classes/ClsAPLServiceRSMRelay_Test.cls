/**
*  This test class used to test class ClsAPLServiceRSMRelay.
*
@author Lili Zhao
@created 2014-08-15
*
@changelog
* coverage  84%
*  
2014-08-15 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest
private class ClsAPLServiceRSMRelay_Test {

    static testMethod void myUnitTest() {
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        
        //RecordType rt = ClsTestHelp.createTestRecordType8();
        RecordType rt2 = ClsTestHelp.createTestRecordType8();
                
        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy1();
    	sh.Level_2_Territory_Code__c = '103004';
        insert sh;
    	
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
        
        Account acct = ClsTestHelp.createTestAccounts();
        acct.Name = 'axx';
        acct.RecordTypeId = rt2.Id;
        acct.AccountNumber = '123456';
        acct.APL_Relay_forecast_Plan_Account__c = acct.Id;
        acct.APL_Relay_Currency__c = 'USD';
        acct.APL_Relay_Display_Name__c = 'testName';
        acct.APL_AM_forecast_Plan_Account__c = acct.Id;
        acct.APL_AM_Currency__c = 'USD';
        acct.APL_AM_Display_Name__c = 'amName';
        acct.Account_Manager__c = userInfo.getUserId();
        insert acct;
        
        Account relayAcct = ClsTestHelp.createTestAccounts();
        relayAcct.Name = 'relayAcctaxx';
        relayAcct.STATDESC__c = 'Active';
        relayAcct.RecordTypeId = rt2.Id;
        relayAcct.Account_Manager__c = userInfo.getUserId();
        relayAcct.APL_Relay_forecast_Plan_Account__c = acct.Id;
        relayAcct.APL_AM_forecast_Plan_Account__c = acct.Id;
        relayAcct.APL_Relay_Currency__c = 'USD';
        relayAcct.APL_Relay_Display_Name__c = 'testName';
        relayAcct.APL_Relay_ParentAccount__c = acct.Id;
        relayAcct.Relay_Specialist_Territory_Code__c = 'test';   
        relayAcct.GAMCD__c = '1234'; 
        //relayAcct.Sales_Hierarchy__c = sh.Id;   
        relayAcct.SALES_TERRITORY_CDE__c = 'test';
       // relayAcct.Sales_Hierarchy__c = sh.Id; 
        insert relayAcct;
        
        Account relayAcct1 = ClsTestHelp.createTestAccounts();
        relayAcct1.Name = 'relayAcctaxx';
        relayAcct1.RecordTypeId = rt2.Id;
        relayAcct1.Account_Manager__c = userInfo.getUserId();
        relayAcct1.APL_Relay_forecast_Plan_Account__c = null;
        relayAcct1.APL_Relay_Currency__c = 'USD';
        relayAcct1.APL_Relay_Display_Name__c = 'testName';
        relayAcct1.APL_Relay_ParentAccount__c = acct.Id;
        relayAcct1.Relay_Specialist_Territory_Code__c = 'test';   
        relayAcct1.GAMCD__c = '1234';   
        relayAcct1.SALES_TERRITORY_CDE__c = 'test';
        //relayAcct1.Sales_Hierarchy__c = sh.Id; 
        insert relayAcct1;
        
        Account amAcct = ClsTestHelp.createTestAccounts();
        amAcct.Name = 'axx';
        amAcct.RecordTypeId = rt2.Id;
        amAcct.APL_AM_forecast_Plan_Account__c = acct.Id;
        amAcct.APL_AM_Currency__c = 'USD';
        amAcct.APL_AM_Display_Name__c = 'amName';
        amAcct.APL_AM_ParentAccount__c = acct.Id;       
        amAcct.Account_Manager__c = userInfo.getUserId();
        amAcct.SALES_TERRITORY_CDE__c = 'test';
        amAcct.GAMCD__c = '1234';
        //amAcct.Sales_Hierarchy__c = sh.Id;  
        insert amAcct;
        
        Account amAcct1 = ClsTestHelp.createTestAccounts();
        amAcct1.Name = 'axx';
        amAcct1.RecordTypeId = rt2.Id;
        amAcct1.APL_AM_forecast_Plan_Account__c = null;
        amAcct1.APL_AM_Currency__c = 'USD';
        amAcct1.APL_AM_Display_Name__c = 'amName';
        amAcct1.APL_AM_ParentAccount__c = acct.Id;      
        amAcct1.Account_Manager__c = userInfo.getUserId();
        amAcct1.SALES_TERRITORY_CDE__c = 'test';
        amAcct1.GAMCD__c = '1234';
        //amAcct1.Sales_Hierarchy__c = sh.Id; 
        //insert new List<Account>{relayAcct, relayAcct1, amAcct, amAcct1};
            insert amAcct1;
        
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
        insert new list<Product_Hierarchy__c>{ph,  ph1};
        
        Part__c part = new Part__c();
        part.Name = 'testPart';
        part.GPL__c = ph.Id;
        part.Product_Hierarchy__c = ph.Id; 
        part.Description__c = 'test';
        //insert part;
        
        Part__c part1 = new Part__c();
        part1.Name = 'testPart';
        part1.GPL__c = ph1.Id;
        part1.Product_Hierarchy__c = ph1.Id; 
        part1.Description__c = 'test';
        insert new List<Part__c>{part, part1};
            
        map<String, String> map_partId_partName = new map<String, String>();
        map_partId_partName.put(part.Id,part.Name);
        map_partId_partName.put(part1.Id,part1.Name);
        
        APL_Sales_Forecast__c aplFC1 = new APL_Sales_Forecast__c();
        aplFC1.type__c = 'GPL';
        aplFC1.Fiscal_Year__c = '2014';
        aplFC1.Fiscal_Quarter__c = '04';
        aplFC1.customer__c = amAcct.Id;
        aplFC1.RSM_Forecast__c = 10;
        aplFC1.GPL__c = ph.Id;
        aplFC1.Part__c = part.Id;
        //insert aplFC1;
        
        APL_Sales_Forecast__c aplFC2 = new APL_Sales_Forecast__c();
        aplFC2.type__c = 'Relay Product Code';
        aplFC2.Fiscal_Year__c = '2014';
        aplFC2.Fiscal_Quarter__c = '04';
        aplFC2.customer__c = relayAcct.Id;
        aplFC2.Part__c = part1.Id;
        aplFC2.GPL__c = ph1.Id;
        aplFC2.RSM_Forecast__c = 10;
        
        APL_Sales_Forecast__c aplFC3 = new APL_Sales_Forecast__c();
        aplFC3.type__c = 'Relay';
        aplFC3.Fiscal_Year__c = '2014';
        aplFC3.Fiscal_Quarter__c = '04';
        aplFC3.customer__c = relayAcct.Id;
        aplFC3.Part__c = part1.Id;
        aplFC3.GPL__c = ph1.Id;
        aplFC3.RSM_Forecast__c = 10;
        
        insert new List<APL_Sales_Forecast__c>{aplFC1, aplFC2, aplFC3};
        
        APL_RSM__c aplRsm = new APL_RSM__c();
        aplRsm.Manager__c = userInfo.getUserId();
        aplRsm.Display_Name__c = 'test';
        //insert aplRsm;
        
        APL_RSM__c aplRsm1 = new APL_RSM__c();
        aplRsm1.Manager__c = userInfo.getUserId();
        aplRsm1.Type__c = 'Relay';
        aplRsm1.Display_Name__c = 'test2';
        insert new List<APL_RSM__c>{aplRsm, aplRsm1};
        
        APL_RSM__c aplRsm2 = new APL_RSM__c();
        aplRsm2.Manager__c = userInfo.getUserId();
        aplRsm2.Type__c = 'AM';
        aplRsm2.Display_Name__c = 'test1';
        aplRsm2.APL_RSM__c = aplRsm1.Id;
        insert aplRsm2;
        
        RecordType rt25 = ClsTestHelp.createTestRecordType25(); 
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
        apl1.A6_Code__c = '1234567';
        apl1.GAM_Code__c = '1234';
        apl1.Manager__c = userInfo.getUserId();
        apl1.RecordTypeId = rt25.Id;
        apl1.RSM__c = aplRsm1.Id;
        insert new List<APL_Forecast_Management__c>{apl, apl1};
        
        BBB_Month_Bill_Book_Cust_PN__c bbbMon = new BBB_Month_Bill_Book_Cust_PN__c();
        bbbMon.Customer__c = relayAcct.Id;
        bbbMon.Bill_Amount_USD__c = 10;
        bbbMon.Book_Amount_USD__c = 10; 
        bbbMon.Fiscal_Year__c = '2014';
        bbbMon.Fiscal_Month__c = 4;
        //update by nelson zheng 2015-10-21 for case 00900375
        //bbbMon.Profit_Center__c = 'RPA';
        bbbMon.Profit_Center__c = 'APL';
        bbbMon.Part__c = part1.Id;
        insert bbbMon;
        
        BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c bbbDay = new BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c();
        bbbDay.Backlog_Amount_USD__c = 10;
        bbbDay.Bill_Amount_USD__c = 10; 
        bbbDay.Book_Amount_USD__c = 10;
        bbbDay.Customer__c = relayAcct.Id;
        bbbDay.Fiscal_Year__c = '2014';
        bbbDay.Fiscal_Month__c = 4;
        bbbDay.Customer_Request_Date_Fiscal_Year__c = '2014';
        bbbday.Customer_Request_Date_Fiscal_Month__c = 4;
        //update by nelson zheng 2015-10-21 for case 00900375
        //bbbDay.Profit_Center__c = 'RPA';
        bbbDay.Profit_Center__c = 'APL';
        bbbDay.Part__c = part1.Id;
        insert bbbDay;
        
        APL_RSM_Overall_Forecast__c aplOver = new APL_RSM_Overall_Forecast__c();
        aplOver.Fiscal_Quarter__c = '04';
        aplOver.Fiscal_Year__c = '2014';
        aplOver.APL_RSM__c = aplRsm.Id;
        aplOver.RSM_Overall_Forecast__c = 10;   
        aplOver.Relay_RSM_Overall_Forecast__c = 10; 
        insert aplOver;
        
        BBB_Year_Bill_Book_Cust_PN__c bbb = new BBB_Year_Bill_Book_Cust_PN__c();
        bbb.Part__c = part1.id;
        //bbb.Bill_Amount_current_prior__c = 10;
        bbb.Bill_Prior_Year_Amount_USD__c = 10;
        bbb.Bill_Year_to_Date_Amount_USD__c = 10;
        bbb.Customer__c = amAcct1.id;
        bbb.BU_Profit_Center__c = 'APL';
		//bbb.Bill_Amount_current_prior__c =10;
        insert bbb;
        
        ClsAPLEntityTypes.PageConfig pageConf = new ClsAPLEntityTypes.PageConfig();
        pageConf.set_rsmRelayDisplayNames = new set<String>();
        pageConf.set_rsmRelayDisplayNames.add('test');
        pageConf.set_rsmRelayTerritoryCodes = new set<String>();
        pageConf.set_rsmRelayTerritoryCodes.add('test');
        pageConf.map_year_quartersFuture.put('2014', new set<String>());
        pageConf.map_year_quartersFuture.get('2014').add('04'); 
        
        ClsAPLEntityTypes.RSMRelayOverRallInfo rsmOverRall = new ClsAPLEntityTypes.RSMRelayOverRallInfo();
        rsmOverRall.set_displayNames = new set<String>();
        rsmOverRall.set_displayNames.add('test');
        rsmOverRall.set_displayNames.add('test1');
        rsmOverRall.set_rsmIds = new set<String>();
        rsmOverRall.set_rsmIds.add(aplRsm.Id);
        rsmOverRall.map_year_quartersFuture = new map<String, set<String>>();    
        rsmOverRall.map_year_quartersFuture.put('2014', new set<String>());
        rsmOverRall.map_year_quartersFuture.get('2014').add('04');
        
        ClsAPLEntityTypes.RSMRelayTotalFCInfo rsmTotal = new ClsAPLEntityTypes.RSMRelayTotalFCInfo();
        rsmTotal.list_dateKey = new list<String>();
        rsmTotal.list_dateKey.add('2014_4');
        rsmTotal.list_dateKey.add('2014_4');
        rsmTotal.list_dateKey.add('2014_4');
        rsmTotal.currentYear = '2014';
        rsmTotal.currentMonth = 4;
        rsmTotal.set_terrtoryCodes = new set<String>();
        rsmTotal.set_terrtoryCodes.add('test');
        
        ClsAPLEntityTypes.RSMRelayTotalFCInfo rsmTotal1 = new ClsAPLEntityTypes.RSMRelayTotalFCInfo();
        rsmTotal1.list_dateKey = new list<String>();
        rsmTotal1.list_dateKey.add('2014_3');
        rsmTotal1.list_dateKey.add('2014_4');
        rsmTotal1.list_dateKey.add('2014_5');
        rsmTotal1.currentYear = '2014';
        rsmTotal1.currentMonth = 4;
        rsmTotal1.set_terrtoryCodes = new set<String>();
        rsmTotal1.set_terrtoryCodes.add('test');
        
        ClsAPLEntityTypes.RSMRelayTotalFCInfo rsmTotal2 = new ClsAPLEntityTypes.RSMRelayTotalFCInfo();
        rsmTotal2.list_dateKey = new list<String>();
        rsmTotal2.list_dateKey.add('2014_4');
        rsmTotal2.list_dateKey.add('2014_4');
        rsmTotal2.list_dateKey.add('2014_4');
        rsmTotal2.currentYear = '2016';
        rsmTotal2.currentMonth = 4;
        rsmTotal2.set_terrtoryCodes = new set<String>();
        rsmTotal2.set_terrtoryCodes.add('test');
        
        ClsAPLEntityTypes.RSMRelayTerritoryFCInfo rsmTerritory = new ClsAPLEntityTypes.RSMRelayTerritoryFCInfo();
        rsmTerritory.territoryCode = 'test';
        rsmTerritory.map_year_quartersFuture = new map<String, set<String>>();  
        rsmTerritory.map_year_quartersFuture.put('2014', new set<String>());
        rsmTerritory.map_year_quartersFuture.get('2014').add('04');
        rsmTerritory.list_dateKey = new list<String>();
        rsmTerritory.list_dateKey.add('2014_4');
        rsmTerritory.list_dateKey.add('2014_4');
        rsmTerritory.list_dateKey.add('2014_4');
        rsmTerritory.currentYear = '2014';
        rsmTerritory.currentMonth = 4;
        
        ClsAPLEntityTypes.RSMRelayTerritoryFCInfo rsmTerritory1 = new ClsAPLEntityTypes.RSMRelayTerritoryFCInfo();
        rsmTerritory1.territoryCode = 'test';
        rsmTerritory1.map_year_quartersFuture = new map<String, set<String>>(); 
        rsmTerritory1.map_year_quartersFuture.put('2014', new set<String>());
        rsmTerritory1.map_year_quartersFuture.get('2014').add('04');
        rsmTerritory1.list_dateKey = new list<String>();
        rsmTerritory1.list_dateKey.add('2014_3');
        rsmTerritory1.list_dateKey.add('2014_4');
        rsmTerritory1.list_dateKey.add('2014_5');
        rsmTerritory1.currentYear = '2014';
        rsmTerritory1.currentMonth = 4;
        
        ClsAPLEntityTypes.RSMRelayTerritoryFCInfo rsmTerritory2 = new ClsAPLEntityTypes.RSMRelayTerritoryFCInfo();
        rsmTerritory2.territoryCode = 'test';
        rsmTerritory2.map_year_quartersFuture = new map<String, set<String>>(); 
        rsmTerritory2.map_year_quartersFuture.put('2014', new set<String>());
        rsmTerritory2.map_year_quartersFuture.get('2014').add('04');
        rsmTerritory2.list_dateKey = new list<String>();
        rsmTerritory2.list_dateKey.add('2014_4');
        rsmTerritory2.list_dateKey.add('2014_4');
        rsmTerritory2.list_dateKey.add('2014_4');
        rsmTerritory2.currentYear = '2016';
        rsmTerritory2.currentMonth = 4;
        
        ClsAPLEntityTypes.RSMRelayAcctFCInfo rsmAcct = new ClsAPLEntityTypes.RSMRelayAcctFCInfo();
        rsmAcct.territoryCode = 'test';
        rsmAcct.acctId = acct.Id;
        rsmAcct.map_year_quartersFuture = new map<String, set<String>>();   
        rsmAcct.map_year_quartersFuture.put('2014', new set<String>());
        rsmAcct.map_year_quartersFuture.get('2014').add('04');
        rsmAcct.list_dateKey = new list<String>();
        rsmAcct.list_dateKey.add('2014_4');
        rsmAcct.list_dateKey.add('2014_4');
        rsmAcct.list_dateKey.add('2014_4');
        rsmAcct.currentYear = '2014';
        rsmAcct.currentMonth = 4;
        
        ClsAPLEntityTypes.RSMRelayAcctFCInfo rsmAcct1 = new ClsAPLEntityTypes.RSMRelayAcctFCInfo();
        rsmAcct1.territoryCode = 'test';
        rsmAcct1.acctId = acct.Id;
        rsmAcct1.map_year_quartersFuture = new map<String, set<String>>();  
        rsmAcct1.map_year_quartersFuture.put('2014', new set<String>());
        rsmAcct1.map_year_quartersFuture.get('2014').add('04');
        rsmAcct1.list_dateKey = new list<String>();
        rsmAcct1.list_dateKey.add('2014_3');
        rsmAcct1.list_dateKey.add('2014_4');
        rsmAcct1.list_dateKey.add('2014_5');
        rsmAcct1.currentYear = '2014';
        rsmAcct1.currentMonth = 4;
        
        ClsAPLEntityTypes.RSMRelayAcctFCInfo rsmAcct2 = new ClsAPLEntityTypes.RSMRelayAcctFCInfo();
        rsmAcct2.territoryCode = 'test';
        rsmAcct2.acctId = amAcct.Id;
        rsmAcct2.map_year_quartersFuture = new map<String, set<String>>();  
        rsmAcct2.map_year_quartersFuture.put('2014', new set<String>());
        rsmAcct2.map_year_quartersFuture.get('2014').add('04');
        rsmAcct2.list_dateKey = new list<String>();
        rsmAcct2.list_dateKey.add('2014_4');
        rsmAcct2.list_dateKey.add('2014_4');
        rsmAcct2.list_dateKey.add('2014_4');
        rsmAcct2.currentYear = '2016';
        rsmAcct2.currentMonth = 4;
        
        ClsAPLEntityTypes.RSMRelayCBCFCInfo rsmCBC = new ClsAPLEntityTypes.RSMRelayCBCFCInfo();
        rsmCBC.acctId = acct.Id;
        rsmCBC.territoryCode = 'test';
        rsmCBC.cbc2Code = '13213';
        rsmCBC.map_year_quartersFuture = new map<String, set<String>>();    
        rsmCBC.map_year_quartersFuture.put('2014', new set<String>());
        rsmCBC.map_year_quartersFuture.get('2014').add('04');
        rsmCBC.list_dateKey = new list<String>();
        rsmCBC.list_dateKey.add('2014_4');
        rsmCBC.list_dateKey.add('2014_4');
        rsmCBC.list_dateKey.add('2014_4');
        rsmCBC.currentYear = '2014';
        rsmCBC.currentMonth = 4;
        rsmCBC.map_cbcRowKey_cbcName = new map<String, String>();
        rsmCBC.map_cbcRowKey_cbcName.put('13213', 'Power/Signal');
        
        ClsAPLEntityTypes.RSMRelayCBCFCInfo rsmCBC1 = new ClsAPLEntityTypes.RSMRelayCBCFCInfo();
        rsmCBC1.acctId = acct.Id;
        rsmCBC1.territoryCode = 'test';
        rsmCBC1.cbc2Code = '13213';
        rsmCBC1.map_year_quartersFuture = new map<String, set<String>>();   
        rsmCBC1.map_year_quartersFuture.put('2014', new set<String>());
        rsmCBC1.map_year_quartersFuture.get('2014').add('04');
        rsmCBC1.list_dateKey = new list<String>();
        rsmCBC1.list_dateKey.add('2013_4');
        rsmCBC1.list_dateKey.add('2014_4');
        rsmCBC1.list_dateKey.add('2015_4');
        rsmCBC1.currentYear = '2014';
        rsmCBC1.currentMonth = 4;
        rsmCBC1.map_cbcRowKey_cbcName = new map<String, String>();
        rsmCBC1.map_cbcRowKey_cbcName.put('13213', 'Power/Signal');
        
        ClsAPLEntityTypes.RSMRelayCBCFCInfo rsmCBC2 = new ClsAPLEntityTypes.RSMRelayCBCFCInfo();
        rsmCBC2.acctId = acct.Id;
        rsmCBC2.territoryCode = 'test';
        rsmCBC2.cbc2Code = '13213';
        rsmCBC2.map_year_quartersFuture = new map<String, set<String>>();   
        rsmCBC2.map_year_quartersFuture.put('2014', new set<String>());
        rsmCBC2.map_year_quartersFuture.get('2014').add('04');
        rsmCBC2.list_dateKey = new list<String>();
        rsmCBC2.list_dateKey.add('2014_4');
        rsmCBC2.list_dateKey.add('2014_4');
        rsmCBC2.list_dateKey.add('2014_4');   
        rsmCBC2.currentYear = '2016';
        rsmCBC2.currentMonth = 4;
        rsmCBC2.map_cbcRowKey_cbcName = new map<String, String>();
        rsmCBC2.map_cbcRowKey_cbcName.put('13213', 'Power/Signal');
        
        APL_Forecast_Settings__c setting1 = ClsTestHelp.createAPLSetting1();
        APL_Forecast_Settings__c setting2 = ClsTestHelp.createAPLSetting2();
        
        ClsAPLEntityTypes.RSMRelayGPLFCInfo rsmPart = new ClsAPLEntityTypes.RSMRelayGPLFCInfo();
        rsmPart.acctId = acct.Id;
        rsmPart.territoryCode = 'test';
        rsmPart.cbc2Code = '13213';
        rsmPart.gplId = ph1.Id;
        //rsmPart.partId = part1.Id;
        rsmPart.map_year_quartersFuture = new map<String, set<String>>();   
        rsmPart.map_year_quartersFuture.put('2014', new set<String>());
        rsmPart.map_year_quartersFuture.get('2014').add('04');      
        rsmPart.map_year_monthsHistory = new map<String, set<Integer>>();   
        rsmPart.map_year_monthsHistory.put('2014', new set<Integer>());
        rsmPart.map_year_monthsHistory.get('2014').add(4);
        rsmPart.map_year_monthsFuture = new map<String, set<Integer>>();
        rsmPart.map_year_monthsFuture.put('2014', new set<Integer>());
        rsmPart.map_year_monthsFuture.get('2014').add(4);
        rsmPart.refStartDate = '2014-04-01';
        rsmPart.periodStartDate = '2014-04-21';
        rsmPart.refEndDate = '2014-04-01';
        rsmPart.currentYear = '2014';
        rsmPart.currentMonth = 4;  
        rsmPart.map_dateKey_fc = new map<String, decimal>();
        rsmPart.map_dateKey_fc.put('2014_04', 20);
        rsmPart.map_dateKey_fc.put('2015_01', 20);
        rsmPart.map_dateKey_fc.put('2013_01', 20);
        
        ClsAPLEntityTypes.RelayFC relayfc = new ClsAPLEntityTypes.RelayFC();
        relayfc.amount = 10;
        relayfc.price = 2;
        relayfc.total = 20;
        
        
        ClsAPLEntityTypes.RelayPartFCInfo partFC = new ClsAPLEntityTypes.RelayPartFCInfo();
        //partFC.acctId = acct.Id;
        partFC.territoryCode = 'test';
        partFC.cbc2Code = '13213';
        partFC.gplId = ph1.Id;
        partFC.partId = part1.Id;
        partFC.map_dateKey_relayFC = new map<String, ClsAPLEntityTypes.RelayFC>();
        partFC.map_dateKey_relayFC.put('2014_04', relayfc);
        partFC.map_dateKey_relayFC.put('2015_01', relayfc);
        partFC.map_dateKey_relayFC.put('2013_01', relayfc);
        
        
        
        ClsAPLEntityTypes.RSMRelayCBCFCInfo releyCbcFC = new ClsAPLEntityTypes.RSMRelayCBCFCInfo();
        releyCbcFC.cbc2Code = '13213';
        //releyCbcFC.parentId = acct.Id;
        releyCbcFC.acctId = acct.Id;
        releyCbcFC.quarterNumb = '02';
        releyCbcFC.map_year_quartersFuture = new map<String, set<String>>();    
        releyCbcFC.map_year_quartersFuture.put('2014', new set<String>());
        releyCbcFC.map_year_quartersFuture.get('2014').add('04'); 
        releyCbcFC.list_partFC = new list<ClsAPLEntityTypes.RelayPartFCInfo>();
        releyCbcFC.list_partFC.add(partFC);
        
        ClsAPLEntityTypes.RSMRelayOverRallInfo overRallInfo = new ClsAPLEntityTypes.RSMRelayOverRallInfo();
        overRallInfo.set_displayNames = new set<String>();
        overRallInfo.set_displayNames.add('test');
        overRallInfo.set_rsmIds = new set<String>();
        overRallInfo.set_rsmIds.add(aplRsm.Id);
        overRallInfo.map_year_quartersFuture = new map<String, set<String>>();  
        overRallInfo.map_year_quartersFuture.put('2014', new set<String>());
        overRallInfo.map_year_quartersFuture.get('2014').add('04');
        overRallInfo.map_name_map_dateKey_fc = new map<String, map<String,decimal>>();
        overRallInfo.map_name_map_dateKey_fc.put('test', new map<String,decimal>());
        overRallInfo.map_name_map_dateKey_fc.get('test').put('2013_01', 20);
        overRallInfo.map_name_map_dateKey_fc.get('test').put('2014_04', 20);
        overRallInfo.map_name_map_dateKey_fc.get('test').put('2015_01', 20);
        
        
        Test.startTest();
        //ClsAPLServiceRSMRelay.setAcctRow(new list<ClsAPLEntityTypes.AcctColumns>());
        ClsAPLServiceRSMRelay.getAcctTotalFC(pageConf, new list<ClsAPLEntityTypes.TotalFCViewFields>());
        ClsAPLServiceRSMRelay.getRSMRelayOverRallFC(rsmOverRall);
        ClsAPLServiceRSMRelay.getRSMTotalRefData(rsmTotal);
        ClsAPLServiceRSMRelay.getRSMTotalRefData(rsmTotal1);
        ClsAPLServiceRSMRelay.getRSMTotalRefData(rsmTotal2);
        ClsAPLServiceRSMRelay.getRSMTerritoryFC(rsmTerritory);
        ClsAPLServiceRSMRelay.getRSMTerritoryRefData(rsmTerritory);
        ClsAPLServiceRSMRelay.getRSMTerritoryRefData(rsmTerritory1);
        ClsAPLServiceRSMRelay.getRSMTerritoryRefData(rsmTerritory2);
        ClsAPLServiceRSMRelay.getRelayAcctFC(rsmAcct);
        ClsAPLServiceRSMRelay.getRSMRelayAcctRefData(rsmAcct);
        ClsAPLServiceRSMRelay.getRSMRelayAcctRefData(rsmAcct1);
        ClsAPLServiceRSMRelay.getRSMRelayAcctRefData(rsmAcct2);
        ClsAPLServiceRSMRelay.getRelayCBCFC(rsmCBC);
        ClsAPLServiceRSMRelay.getRSMRelayCBCRefData(rsmCBC);
        ClsAPLServiceRSMRelay.getRSMRelayCBCRefData(rsmCBC1);
        ClsAPLServiceRSMRelay.getRSMRelayCBCRefData(rsmCBC2);
        
        ClsAPLServiceRSMRelay.getPartFC(rsmPart);
        ClsAPLServiceRSMRelay.savePartFC(releyCbcFC);
        ClsAPLServiceRSMRelay.getRSMTotalReferRow();
        ClsAPLServiceRSMRelay.saveOverRallFC(overRallInfo);
        ClsAPLServiceRSMRelay obj = new ClsAPLServiceRSMRelay();
            obj.setAcctRow(new list<ClsAPLEntityTypes.AcctColumns>());
        obj.getAcctInfo(pageConf);
        ClsAPLServiceRSMRelay.setMapPartIdName(map_partId_partName);
        String parentId = releyCbcFC.parentId;
        String cbcCode = releyCbcFC.cbc2Code;
        String territoryCode = releyCbcFC.territoryCode;
        String quartNumb = releyCbcFC.quarterNumb;
        map<String, decimal> map_acctId_avgPercent = new map<String, decimal>();
        map<String, map<String, decimal>> map_partId_map_acctId_partPercent = new map<String, map<String, decimal>>();
        ClsAPLServiceRSMRelay.getProductCodePercentForSave(parentId,cbcCode,territoryCode,quartNumb,map_acctId_avgPercent,map_partId_map_acctId_partPercent);
        
        Test.stopTest();
    }
}