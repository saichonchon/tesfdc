/**
*  This test class used to test class ExtRecalculateBudget.
*
@author Bin Yuan
@created 2014-01-20
@version 1.0   
@since 28.0
*
@changelog
* coverage % 
* 
* 
2014-01-20 Bin Yuan <bin.yuan@itbconsult.com>
* - Created
*/
@isTest(seeAllData = true) 
private class ClsRSMForecastUtil_Test {
    static testMethod void myUnitTest1() {
        //insert account manager
        User acctMger = new User();
        acctMger = ClsTestHelp.createTestUsers();
        acctMger.FirstName ='First';
        acctMger.LastName = 'acctMger';
        acctMger.Alias = 'acctMger';
        acctMger.Email = 'mtesteracctMger@ItbTestcompany.com';
        acctMger.Username = acctMger.Email;
        acctMger.Te_Network_Id__c = 'acctMger';
        acctMger.CommunityNickname = acctMger.Alias;
        
        insert acctMger;        
        //insert RSM user
        User rsmUser = new User();
        rsmUser = ClsTestHelp.createTestUsers();
        rsmUser.FirstName ='First';
        rsmUser.LastName = 'rsmUser';
        rsmUser.Alias = 'rsmUser';
        rsmUser.Email = 'mtesterrsmUser@ItbTestcompany.com';
        rsmUser.Username = rsmUser.Email;
        rsmUser.Te_Network_Id__c = 'rsmUser';
        rsmUser.CommunityNickname = rsmUser.Alias;
        insert rsmUser;
        //insert GSM user
        User gsmUser = new User();
        gsmUser = ClsTestHelp.createTestUsers();
        gsmUser.FirstName ='First';
        gsmUser.LastName = 'gsmUser';
        gsmUser.Alias = 'gsmUser';
        gsmUser.Email = 'mtestergsmUser@ItbTestcompany.com';
        gsmUser.Username = gsmUser.Email;
        gsmUser.Te_Network_Id__c = 'gsmUser';
        gsmUser.CommunityNickname = gsmUser.Alias;
        insert gsmUser;
        //insert forecast definition
        Forecast_Definition__c fDef1 = new Forecast_Definition__c();
        fDef1.RSM__c = rsmUser.Id;
        fDef1.GSM__c = gsmUser.Id;
        fDef1.Category__c = 'A';
        fDef1.Name = 'Alstom Rail';
        fDef1.RSM_Se_quence__c = 1;
        fDef1.Subtotal__c = false;
        fDef1.Region__c = 'EMEA';
        fDef1.Profit_Center__c = 'Rail';
        fDef1.GSM_Name__c = 'Alstom Rail';
        fDef1.GSM_Sequence__c = 1;
        fDef1.IND_Customer_Classification__c = 'A';
        fDef1.RSM_Forecast_Category_Includes__c = '';
        fDef1.RSM_Forecast_Category_Excludes__c = '';
        fDef1.Industrial_Sales_Team_Include__c = '';
        fDef1.Category_Label__c = 'A';
        insert fDef1;
        //insert manager forecast for rsm
        Manager_Forecast__c mf = new Manager_Forecast__c();
        mf.Billings_USD__c = 1234;
        mf.Bookings_USD__c = 1234;
        mf.Forecast_USD__c = 1234;
        mf.AM_Forecast_USD__c = 1234;
        mf.Forecast_Definition__c = fDef1.id;
        mf.Previous_Month_Forecast_Document__c = 1234;
        mf.Fiscal_Month__c = 1;
        mf.Fiscal_Year__c = '1234';
        mf.Comment__c = '<comments><comment value="100">Comment about a positive forecast risk</comment><comment value="-80">Comment about a negative forecast risk</comment></comments>';
        insert mf;
        //insert accounts
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
        acc.IND_Billing_Region__c = 'test';
        insert acc;
        
        //insert bbb monthly records for rsm
        BBB_Month_Bill_Book_Cust__c bbb = new BBB_Month_Bill_Book_Cust__c();
        bbb.Customer__c = acc.Id;
        bbb.Fiscal_Year__c = '2014';
        bbb.Fiscal_Month__c = 1;
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
        bbb.Comment__c = '<comments><comment value="100">Comment about a positive forecast risk</comment><comment value="-80">Comment about a negative forecast risk</comment></comments>';
        insert bbb;
        BBB_Month_Bill_Book_Cust__c bbb2 = new BBB_Month_Bill_Book_Cust__c();
        bbb2.Customer__c = acc.Id;
        bbb2.Fiscal_Year__c = '2014';
        bbb2.Fiscal_Month__c = 2;
        bbb2.Bill_Type__c = 'Direct';
        bbb2.Budget_Direct__c = 1;
        bbb2.Budget_POS__c = 2;
        bbb2.Budget_CMA__c = 3;
        bbb2.Budget_TBR_NY__c = 12;
        bbb2.Budget_Document_Currency__c = 11; 
        bbb2.CurrencyIsoCode = 'EUR';
        bbb2.Monthly_BBB_External_Key__c = null;
        bbb2.Is_Comment__c = true;
        bbb2.IND_Profit_Centre_Groups__c = 'abc';
        bbb2.SAP_Profit_Center_Group_Code__c = 'G0123';
        bbb2.Is_Comment__c = true;
        bbb2.IND_Profit_Centre_Groups__c = 'test';
        bbb2.Comment__c = '<comments><comment value="100">Comment about a positive forecast risk</comment><comment value="-80">Comment about a negative forecast risk</comment></comments>';
        insert bbb2;
        
        
        Test.startTest();
        System.runAs(rsmUser) {
            CtrlRSMForecast ctrl = new CtrlRSMForecast();
            ctrl.regionCenters = 'EMEA_Rail';
            ctrl.init();
            ctrl.getAFields();
            ctrl.getThis();
            ctrl.getOthFields();
            ctrl.getColorConfig();
            ctrl.actionComments();
            //get Comments
            ctrl.str_selectedCmt = Json.serialize(new map<String, String>{String.valueOf(fDef1.id) => '1234-1'});
            ctrl.getComments();
            
            
            
            
            
            //save forecast
            list<CtrlRSMForecast.RSMForecastItem> list_comts = new list<CtrlRSMForecast.RSMForecastItem>();
            CtrlRSMForecast.RSMForecastItem rsmItem1= new CtrlRSMForecast.RSMForecastItem();
            rsmItem1.billings = 100;
            rsmItem1.bookings = 100;
            rsmItem1.rsmForecast = 100;
            rsmItem1.asmForecast = 100;
            rsmItem1.definition = fDef1.id;
            rsmItem1.fiscalDate = '1234-1';
            list_comts.add(rsmItem1);
            
            ctrl.jsonSaveData = json.serialize(list_comts);
            ctrl.saveForecast();
            //save comments
            list<CtrlRSMForecast.Comment> list_comts2Save = new list<CtrlRSMForecast.Comment>();
            CtrlRSMForecast.Comment comt = new CtrlRSMForecast.Comment();
            comt.fcDefId = fDef1.id;
            comt.fiscalDate = '1234-1';
            comt.value = '100';
            comt.comment = 'Test 1--';
            list_comts2Save.add(comt);
            map<String, map<String, list<CtrlRSMForecast.Comment>>> map_fcDefId_fiscalDate_listComts = new map<String, map<String, list<CtrlRSMForecast.Comment>>>();
            map_fcDefId_fiscalDate_listComts.put(fDef1.id, new map<String, list<CtrlRSMForecast.Comment>> {'1234-1' => list_comts2Save});
            ctrl.str_comment2Save = json.serialize(map_fcDefId_fiscalDate_listComts);
            ctrl.saveComments();
            
            String region = 'region';
            String pcenter = 'profit ctr';
            Map<String, Set<Integer>> map_Month = new map<String, set<Integer>>{'2013' => new set<Integer> {1, 2, 3}};
            String filter = 'a';
            String dateKey = '2013_10';
            ClsRSMForecastUtil.getQueryStrForBBBM(dateKey, region, pcenter);
            ClsRSMForecastUtil.getQueryStrForScheduledAgreements(dateKey, region);
            
            List<Forecast_Definition__c> list_fDefinition = new list<Forecast_Definition__c>();
            list_fDefinition.add(fDef1);
            Map<String, List<CtrlRSMForecast.RSMDefinitionItem>> map_rSMDefinitionItems = new Map<String, List<CtrlRSMForecast.RSMDefinitionItem>>();
            map_rSMDefinitionItems.put('a', new List<CtrlRSMForecast.RSMDefinitionItem>());
            map_rSMDefinitionItems.put('b', new List<CtrlRSMForecast.RSMDefinitionItem>());
            map_rSMDefinitionItems.put('c', new List<CtrlRSMForecast.RSMDefinitionItem>());
            
            Map<String, List<CtrlRSMForecast.RSMDefinitionItem>> map_totalItems = new Map<String, List<CtrlRSMForecast.RSMDefinitionItem>>();
            map_totalItems.put('a', new List<CtrlRSMForecast.RSMDefinitionItem>());
            map_totalItems.put('b', new List<CtrlRSMForecast.RSMDefinitionItem>());
            map_totalItems.put('c', new List<CtrlRSMForecast.RSMDefinitionItem>());
            
            Map<String, Map<String, List<CtrlRSMForecast.RSMDefinitionItem>>> map_otherItems = new Map<String, Map<String, List<CtrlRSMForecast.RSMDefinitionItem>>>(); 
            map_otherItems.put('a', new Map<String, List<CtrlRSMForecast.RSMDefinitionItem>>());
            map_otherItems.put('b', new Map<String, List<CtrlRSMForecast.RSMDefinitionItem>>());
            map_otherItems.put('c', new Map<String, List<CtrlRSMForecast.RSMDefinitionItem>>());
            
            map<String, String> map_classifications = new map<String, String>();
            ClsRSMForecastUtil.getRSMDefinitionItemMap(list_fDefinition, map_rSMDefinitionItems, map_totalItems, map_otherItems, map_classifications);
            
            String viewType = 'ProfitCenterView';
            String viewTypeOther = 'other';
            ClsRSMForecastUtil.getChangeScreenBBBMQuery(viewType);
            ClsRSMForecastUtil.getQueryStrForScheduledAgreements(viewType);
            
            
            
            CtrlRSMForecast.ASMCommentSearch searchObj = new CtrlRSMForecast.ASMCommentSearch();
            searchObj.cls2 = fDef1.id;
            searchObj.cls3 = '2014_1';
            list<CtrlRSMForecast.Comment> list_asmComments = new list<CtrlRSMForecast.Comment>();
            list<CtrlRSMForecast.RSMDefinitionItem > list_fcDefs = new list<CtrlRSMForecast.RSMDefinitionItem >();
            CtrlRSMForecast.RSMDefinitionItem item = new CtrlRSMForecast.RSMDefinitionItem();
            item.id = fDef1.id;
            item.oldClassifications = '';
            item.categoryInclude = '';
            item.categoryExclude = '';
            list_fcDefs.add(item);
            ClsRSMForecastUtil.getASMComments(list_fcDefs, searchObj, list_asmComments, 'test', 'test');
        }
        Test.stopTest();
    }
}