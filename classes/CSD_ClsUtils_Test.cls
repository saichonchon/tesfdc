/**
 *  This class used to cover CSD_ClsUtils
 *
 @author Rajendra Shahane
 @created 2016-09-19
 @version 1.0
 @since 37.0 (Force.com ApiVersion)
 *
 @changelog
 * 2016-09-19 Rajendra <Shahane rajendra.shahane@zensar.com>
 * - Created
* - Class Covered : CSD_ClsUtils
 */
@istest(seeAllData=false)
public class CSD_ClsUtils_Test
{
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
        
        RecordType rtsoldto = ClsTestHelp.createTestRecordType8();
        RecordType rtoem = ClsTestHelp.createCSDTestRecordType7(); 
        system.debug('!@# rtoem :'+rtoem);    
        Consumer_Device_Opportunity_Record_Types__c cdort1 = ClsTestHelp.createTestCSD1();
        Consumer_Device_Opportunity_Record_Types__c cdort2 = ClsTestHelp.createTestCSD2();
        Consumer_Device_Opportunity_Record_Types__c cdort3 = ClsTestHelp.createTestCSD3();
        Consumer_Device_Opportunity_Record_Types__c cdort4 = ClsTestHelp.createTestCSD4();
        Consumer_Device_Opportunity_Record_Types__c cdort5 = ClsTestHelp.createTestCSD5();
        Consumer_Device_Opportunity_Record_Types__c cdort6 = ClsTestHelp.createTestCSD6();
        Consumer_Device_Opportunity_Record_Types__c cdort7 = ClsTestHelp.createTestCSD7();
        
        User user = ClsTestHelp.createTestUsers(); 
        user.Te_Network_Id__c = 'ABCDEFG';
        user.email = 'test@test.test';
        User user3 = ClsTestHelp.createTestUsers(); 
        user3.CommunityNickname = 'user3';
        user3.Te_Network_Id__c = 'ABCDEFh';
       
        insert new list<user>{user, User3};

        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
        sh.Level_2_Territory_Code__c = '103004';
        sh.Level_7_Territory_Code__c = '123456';
        sh.Level_1_Assigned_User_Network_Ids__c = 'ABCDEFG;ABCDEFh';
        sh.Level_2_Assigned_User_Network_Ids__c = 'ABCDEFG;ABCDEFh';
        sh.Level_3_Assigned_User_Network_Ids__c = 'ABCDEFG;ABCDEFh';
        sh.Level_4_Assigned_User_Network_Ids__c = 'ABCDEFG;ABCDEFh';
        sh.Level_5_Assigned_User_Network_Ids__c = 'ABCDEFG;ABCDEFh';
        sh.Level_6_Assigned_User_Network_Ids__c = 'ABCDEFG;ABCDEFh';
        sh.Level_7_Assigned_User_Network_Ids__c = 'ABCDEFG;ABCDEFh';
        sh.Level_1_Assigned_Users__c = user.id;
        sh.Level_2_Assigned_Users__c = user.id;
        sh.Level_3_Assigned_Users__c = user.id;
        sh.Level_4_Assigned_Users__c = user.id;
        sh.Level_5_Assigned_Users__c = user.id;
        sh.Level_6_Assigned_Users__c = user.id;
        sh.Level_7_Assigned_Users__c = user.id;
        
        Sales_Hierarchy__c sh2 = ClsTestHelp.createTestSalesHierarchy();
        sh2.Level_2_Territory_Code__c = '103004';
        sh2.Level_7_Territory_Code__c = '123456';
        sh2.Level_1_Assigned_User_Network_Ids__c = 'ABCDEFG';
        sh2.Level_2_Assigned_User_Network_Ids__c = 'ABCDEFG';
        sh2.Level_3_Assigned_User_Network_Ids__c = 'ABCDEFG';
        sh2.Level_4_Assigned_User_Network_Ids__c = 'ABCDEFG';
        sh2.Level_5_Assigned_User_Network_Ids__c = 'ABCDEFG';
        sh2.Level_6_Assigned_User_Network_Ids__c = 'ABCDEFG';
        sh2.Level_7_Assigned_User_Network_Ids__c = 'ABCDEFG';
        sh2.Level_1_Assigned_Users__c = user.id;
        sh2.Level_2_Assigned_Users__c = user.id;
        sh2.Level_3_Assigned_Users__c = user.id;
        sh2.Level_4_Assigned_Users__c = user.id;
        sh2.Level_5_Assigned_Users__c = user.id;
        sh2.Level_6_Assigned_Users__c = user.id;
        sh2.Level_7_Assigned_Users__c = user.id;
        
        insert new list<Sales_Hierarchy__c > {sh, sh2};
                
        Account samsung = ClsTestHelp.createTestAccounts();
        samsung.Name = 'samsung';
        samsung.RecordTypeId = rtoem.Id;
        samsung.Account_Manager__c = user.Id;
        samsung.Design_In_Region__c = 'KOREA';
        samsung.STATDESC__c = 'Active';
        samsung.Active__c = true;
        //insert samsung;
        Account acct1 = ClsTestHelp.createTestAccounts();
        acct1.Name = 'axx';
        acct1.RecordTypeId = rtsoldto.Id;
        acct1.AccountNumber = '1234:12345678';
        acct1.Account_Manager__c = user.Id;
        acct1.SALES_TERRITORY_CDE__c = '123456';
        acct1.Active__c = true;
        acct1.STATDESC__c = 'Active';
        acct1.WWCORPACCT__c = '123412345678';
        //insert acct1;     
        Account acct11 = ClsTestHelp.createTestAccounts();
        acct11.Name = 'axx1';
        acct11.RecordTypeId = rtsoldto.Id;
        acct11.AccountNumber = '1234:12345679';
        acct11.Account_Manager__c = user.Id;
        acct11.SALES_TERRITORY_CDE__c = '123456';
        acct11.Active__c = true;
        acct11.STATDESC__c = 'Active';
        acct11.WWCORPACCT__c = '123412345678';
        //insert acct11;
        
        Account acct2 = ClsTestHelp.createTestAccounts();
        acct2.Name = 'relayAcctaxx';
        acct2.RecordTypeId = rtoem.Id;
        acct2.Account_Manager__c = user.Id;
        acct2.Design_In_Region__c = 'AMERICAS';
        acct2.STATDESC__c = 'Active';
        acct2.Active__c = true;
        //insert acct2;
        
        Account acct22 = ClsTestHelp.createTestAccounts();
        acct22.Name = 'relayAcctaxx2';
        acct22.RecordTypeId = rtoem.Id;
        acct22.Account_Manager__c = user.Id;
        acct22.Design_In_Region__c = 'AMERICAS';
        acct22.STATDESC__c = 'Active';
        acct22.Active__c = true;
        //insert acct22;
        insert new List<Account>{samsung,acct1,acct11,acct2,acct22};
            
        CSD_Configuration__c setting = new CSD_Configuration__c();
        setting.Name = 'Samsung OEM Account';
        setting.Value__c = samsung.Id;
        //insert setting;
        
        CSD_Configuration__c setting2 = new CSD_Configuration__c();
        setting2.Name = 'Non OEM Account';
        setting2.Value__c = samsung.Id;
        //insert setting2;
        
        insert new List<CSD_Configuration__c>{setting,setting2};
        

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
        //insert ph2;
        insert new List<Product_Hierarchy__c>{ph,ph1,ph2};
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
        part1.PRODUCT_CDE__c = 'TEST2';
        part1.PROD_NAME__c = 'test name2';
        //insert part1;
        
        Part__c part2 = new Part__c();
        part2.Name = 'testPart';
        part2.GPL__c = ph2.Id;
        part2.Product_Hierarchy__c = ph2.Id; 
        part2.Description__c = 'test';
        part2.PRODUCT_CDE__c = 'TEST3';
        part2.PROD_NAME__c = 'test name3';
        //insert part2;
        insert new List<Part__c>{part,part1,part2};
            
        CSD_Sales_Forecast__c csdFC1 = new CSD_Sales_Forecast__c();
        csdFC1.Type__c = 'Sold-To';
        csdFC1.Fiscal_Year__c = '2015';
        csdFC1.Fiscal_Month__c = '9';
        csdFC1.Sold_To_Number__c = '1234:12345678';
        csdFC1.Sold_To_Name__c = 'Test';
        csdFC1.Forecast__c = 1000;
        csdFC1.Billing_Region__c = 'AMERICAS';
        //insert csdFC1;
        
        CSD_Sales_Forecast__c csdFC2 = new CSD_Sales_Forecast__c();
        csdFC2.type__c = 'OEM';
        csdFC2.Fiscal_Year__c = '2015';
        csdFC2.Fiscal_Month__c = '9';
        csdFC2.Sold_To_Number__c = '1234:12345678';
        csdFC2.Sold_To_Name__c = 'Test';
        csdFC2.OEM__c = acct2.Id;
        csdFC2.Forecast__c = 1000;
        csdFC2.Billing_Region__c = 'AMERICAS';
        //insert csdFC2;        
        
        CSD_Sales_Forecast__c csdFC3 = new CSD_Sales_Forecast__c();
        csdFC3.type__c = 'Part';
        csdFC3.Fiscal_Year__c = '2015';
        csdFC3.Fiscal_Month__c = '9';
        csdFC3.Sold_To_Number__c = '1234:12345678';
        csdFC3.Sold_To_Name__c = 'Test';
        csdFC3.Part__c = part1.Id;
        csdFC3.Forecast__c = 100;
        csdFC3.OEM__c = acct2.Id;
        csdFC3.Price__c = 10;
        csdFC3.Quantity__c = 10;
        csdFC3.Billing_Region__c = 'AMERICAS';
        //insert csdFC3;
        insert new List<CSD_Sales_Forecast__c>{csdFC1,csdFC2,csdFC3};
            
        CSD_Channel_Forecast__c channel = new CSD_Channel_Forecast__c();
        channel.Billing_Region__c = 'AMERICAS';
        channel.Fiscal_Year__c = '2015';
        channel.Fiscal_Month__c = '9';
        channel.Forecast__c = 200;
        channel.OEM__c = acct2.Id;
        channel.Name = 'ChannelForecast';
        insert channel;
        
        RecordType rt25 = ClsTestHelp.createTestRecordType25(); 
        CSD_Forecast_Management__c csd = new CSD_Forecast_Management__c();
        csd.Name = 'testName';
        csd.Role__c = 'Sales Leader';
        csd.Region__c = 'AMERICAS';
        csd.WWAC_Code__c = '123412345678';
        csd.User__c = user.Id;
        insert csd;
        
        OEM_Details__c oemd = new OEM_Details__c();
        oemd.OEM__c = acct2.Id;
        insert oemd;
        
        OEM_Mapping_Rule__c oemmap = new OEM_Mapping_Rule__c();
        oemmap.OEM__c = oemd.Id;
        oemmap.Allocation__c = 100;
        oemmap.Sold_To_Account_Code__c = '12345678';
        oemmap.Type__c = 'Customer';
        insert oemmap;
        
        BBB_Month_Bill_Book_Cust_PN__c bbbMon = new BBB_Month_Bill_Book_Cust_PN__c();
        bbbMon.Customer__c = acct1.Id;
        bbbMon.Bill_Amount_USD__c = 10;
        bbbMon.Book_Amount_USD__c = 10; 
        bbbMon.Fiscal_Year__c = '2015';
        bbbMon.Fiscal_Month__c = 8;
        bbbMon.Profit_Center__c = 'CSD';
        bbbMon.Part__c = part.Id;
        insert bbbMon;

        CSD_OEM_Mapping_Monthly_BBB__c monmap = new CSD_OEM_Mapping_Monthly_BBB__c();
        monmap.Monthly_Billings_Bookings_by_Part__r = bbbMon;
        monmap.OEM_Mapping__c = oemmap.Id;
        
        
        BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c bbbDay = new BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c();
        bbbDay.Backlog_Amount_USD__c = 10;
        bbbDay.Bill_Amount_USD__c = 10; 
        bbbDay.Book_Amount_USD__c = 10;
        bbbDay.Customer__c = acct1.Id;
        bbbDay.Fiscal_Year__c = '2015';
        bbbDay.Fiscal_Month__c = 9;
        bbbDay.Customer_Request_Date_Fiscal_Year__c = '2015';
        bbbday.Customer_Request_Date_Fiscal_Month__c = 9;
        bbbDay.Profit_Center__c = 'CSD';
        bbbDay.Part__c = part.Id;
        insert bbbDay;

        CSD_OEM_Mapping_Daily_BBB__c daymap = new CSD_OEM_Mapping_Daily_BBB__c();
        daymap.Daily_Booking_Billing_Backlog_By_Part__c = bbbDay.Id;
        daymap.CSD_OEM_Mapping__c  = oemmap.Id;
        insert daymap;
        
        CSD_Samsung_Mapping__c oCSD_Samsung_Mapping = new CSD_Samsung_Mapping__c(Sales_Email__c = user.email, GPL_Family__c = 'test', GPL_Code__c = 'test');
        
        insert oCSD_Samsung_Mapping;
        
        CSD_ClsEntityType.SearchObj so = new CSD_ClsEntityType.SearchObj();
        so.set_fiscalMonth = new set<String>();
        so.set_fiscalMonth.add('2015_5');
        so.set_fiscalMonth.add('2015_9');
        so.set_fiscalMonth.add('2015_8');
        
        so.map_year_monthsFuture = new map<String, set<Integer>>{
            '2015'=> new set<Integer>{3,4,5,6,7,8,9,10,11}
        };
        
        so.map_quarter_months =  new map<String, String>{
            '01'=>'1,2,3',
            '02'=>'4,5,6',
            '03'=>'7,8,9',
            '04'=>'10,11,12'
        };
        so.set_selectedId = new set<String>();
        so.startDate = '2015-03-15';
        so.endDate = '2015-11-15';
        so.managerId = user.Id;
        so.searchKey = '';
        //View Mode
        so.viewMode = 'billingRegion';
        so.isOtherMethod = false;
        so.accnumber = '1234:12345678';
        String sData = JSON.serialize(so);
        String result = '';
        
        system.runAs(user){
            Test.startTest();
            
            CSD_CtrlSoldToForecast ctrl = new CSD_CtrlSoldToForecast();
            
            CSD_ClsSoldToService.SearchTotal total = new CSD_ClsSoldToService.SearchTotal();
            result = total.getTotalBillingData(sData);
            
            
            CSD_ClsSoldToService.SearchSoldTo level1 = new CSD_ClsSoldToService.SearchSoldTo();
            
            
            
            CSD_ClsEntityType.AccountObj valueobj = new CSD_ClsEntityType.AccountObj();
            valueobj.accnumber = '1234:12345678';
            valueobj.csFC = new map<String, decimal>(); 
            valueobj.csFC.put('2015_9',1200);
            valueobj.csFC.put('2015_10',1300);
            valueobj.csFC.put('2015_11',1400);
            valueobj.name = 'Test';
            String save = JSON.serialize(valueobj);
            result = level1.saveSObjectData(save);
            
            result = level1.getSearchResult(sData);
            result = level1.getRefData(sData);
            result = level1.getBacklogRefData(sData);
            
            
            CSD_ClsSoldToService.SearchRestSoldTo rest = new CSD_ClsSoldToService.SearchRestSoldTo();
            
            result = rest.getRefData(sData);
            result = rest.getBacklogRefData(sData);
            
            
            CSD_ClsSoldToService.SearchOEM level2 = new CSD_ClsSoldToService.SearchOEM();
            
            result = level2.getExistResult(sData);
            
            so.oemId = acct2.Id;
            sData = JSON.serialize(so);
            
            
            CSD_ClsEntityType.AccountObj valueobj1 = new CSD_ClsEntityType.AccountObj();
            valueobj1.accnumber = '1234:12345678';
            valueobj1.oemId = acct2.Id;
            valueobj1.csFC = new map<String, decimal>(); 
            valueobj1.csFC.put('2015_9',1200);
            valueobj1.csFC.put('2015_10',1300);
            valueobj1.csFC.put('2015_11',1400);
            valueobj1.restPNFC = new map<String, decimal>(); 
            valueobj1.restPNFC.put('2015_9',100);
            valueobj1.restPNFC.put('2015_10',100);
            valueobj1.restPNFC.put('2015_11',100);
            valueobj1.name = 'Test';
            valueobj1.region = 'AMERICAS';
            save = JSON.serialize(valueobj1);
            result = level2.saveSObjectData(save);
            
            result = level2.getSearchResult(sData);
            so.isOtherMethod = true;
            sData = JSON.serialize(so);
            result = level2.getSearchResult(sData);
            result = level2.getRefData(sData);
            result = level2.getBacklogRefData(sData);
            

            CSD_ClsSoldToService.SearchPart level3 = new CSD_ClsSoldToService.SearchPart();
            
            result = level3.getExistResult(sData);
            
            so.partId = part1.Id;
            sData = JSON.serialize(so);
            
            
            CSD_ClsEntityType.CSDForecastValueObj valueobj2 = new CSD_ClsEntityType.CSDForecastValueObj();
            valueobj2.accnumber = '1234:12345678';
            valueobj2.oemId = acct2.Id;
            valueobj2.name = 'Test';
            valueobj2.region = 'AMERICAS';
            valueobj2.partId = part1.Id;
            valueobj2.csFC = new map<String, CSD_ClsEntityType.AccountValueobj>();
            CSD_ClsEntityType.AccountValueobj detail1 = new CSD_ClsEntityType.AccountValueobj();
            detail1.price = 12;
            detail1.quantity = 10;
            detail1.forecast = 120;
            valueobj2.csFC.put('2015_9',detail1);
            save = JSON.serialize(valueobj2);
            result = level3.saveSObjectData(save);
            
            result = level3.getSearchResult(sData);
            so.isOtherMethod = false;
            sData = JSON.serialize(so);
            result = level3.getSearchResult(sData);
            
            result = level3.getRefData(sData);
            result = level3.getBacklogRefData(sData);
            
            
            result = level2.deleteCSDObject(sData);
            result = level2.deleteCSDObject(sData);
            result = level1.deleteCSDObject(sData);
            
            
            CSD_ClsSoldToService.SearchNonOEMs nonoem = new CSD_ClsSoldToService.SearchNonOEMs();
            CSD_ClsEntityType.AccountObj valueobjnon = new CSD_ClsEntityType.AccountObj();
            valueobjnon.accnumber = '1234:12345679';
            valueobjnon.csFC = new map<String, decimal>(); 
            valueobjnon.csFC.put('2015_9',1200);
            valueobjnon.csFC.put('2015_10',1300);
            valueobjnon.csFC.put('2015_11',1400);
            valueobjnon.restPNFC = new map<String, decimal>(); 
            valueobjnon.restPNFC.put('2015_9',100);
            valueobjnon.restPNFC.put('2015_10',100);
            valueobjnon.restPNFC.put('2015_11',100);
            valueobjnon.name = 'Test';
            valueobjnon.region = 'AMERICAS';
            save = JSON.serialize(valueobjnon);
            result = nonoem.saveSObjectData(save);
            
            CSD_ClsUtils.Convert15CharTo18CharId(userinfo.getUserId());
            CSD_ClsUtils.decryptionFormInput(CSD_ClsUtils.encryptionFormID('01pE0000002Hf6K'));
            CSD_ClsUtils.getStartDate('11_2016');
            CSD_ClsUtils.getEndDate('2016_11');
            CSD_ClsUtils.getFiscalMonthMap(new list<String> {'2016_11'});
            CSD_ClsUtils.getRelayPartQuery();
            map<String, Set<String>> map_year_quarter = new map<String, Set<String>>();
            map_year_quarter.put('2017',new set<String>{'1','2'});
            CSD_ClsUtils.getMonthFilter(map_year_quarter);
            CSD_ClsUtils.getFormatString(new list<String> {'abc','asdf'});
            CSD_ClsUtils.getCurrentFiscalDate();
            map<String, Set<Integer>> map_financialMonth = new map<String, Set<Integer>>();
            map_financialMonth.put('2017',new set<Integer>{1,2});
            CSD_ClsUtils.getCustomRequestMonthFilter(map_financialMonth);
            CSD_ClsUtils.setTerritoryAccountSetBySubordinate(new set<String> {samsung.Id,acct1.Id}, new set<String> {user.id});
            CSD_ClsUtils.getTerritoryCodeByUserId(userinfo.getUserId());
            CSD_ClsUtils.Convert15CharTo18CharId('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
            string str;
            CSD_ClsUtils.setUserLocale(new CSD_ClsEntityType.LocaleConfig(), str);
            CSD_ClsUtils.getDividedFiscalMap(Date.today() , new list<String>{'2016_2','2016_3','2016_4','2017_1','2017_2'}, new  map<String, set<Integer>>(), new map<String, set<Integer>>());
            list<CSD_ClsEntityType.UserObj> list_users = new list<CSD_ClsEntityType.UserObj>();
            CSD_ClsUtils.setSubordinateUser(user.id, list_users);
            CSD_ClsUtils.setSubordinateUserForMultilevelHead(user.Id, new list<CSD_ClsEntityType.UserObj>());
            CSD_ClsUtils.setSubordinateUserForMultilevel(new set<String>{user.Id});
            CSD_ClsUtils.createAccountObjForComprison(new CSD_ClsEntityType.AccountObjForComparison(), new map<String, String>());
            CSD_ClsUtils.setRegionMapRefData('', new set<String>{'2016'}, new set<Integer>{1}, new set<String>(),  new  list<String>{'Fiscal_Date__c refdate ', ' CSD_Sales_Forecast__c ', ' group by Fiscal_Date__c '}, new map<String, map<String, AggregateResult>>());
            CSD_ClsUtils.setOEMPartMapRefData(new set<string>{'1'}, new  list<String>{'Fiscal_Date__c refdate, OEM__c refId', ' CSD_Sales_Forecast__c ', ' group by Fiscal_Date__c, OEM__c '}, new map<String, map<String, AggregateResult>>());
            CSD_ClsUtils.setGAMOEMMapRefData('', new set<String>{'1'}, new  list<String>{'Fiscal_Date__c refdate, OEM__c refId', ' CSD_Sales_Forecast__c ', ' group by Fiscal_Date__c, OEM__c '}, new map<String, map<String, AggregateResult>>());
            CSD_ClsEntityType.CSDRefObj CSDRefObj = new CSD_ClsEntityType.CSDRefObj();
            CSDRefObj.map_billingrefdata = new map<String, decimal>();
            CSDRefObj.map_bookingrefdata = new map<String, decimal>();
            CSDRefObj.map_backlogrefdata = new map<String, decimal>();
            CSDRefObj.map_statisticalrefdata = new map<String, decimal>();
            CSD_ClsUtils.setRefDateObject(new list<Date>{date.today().addDays(-30)}, new list<Date>{date.today().addDays(30), date.today().addDays(60)}, new list<Date>{date.today()}, date.today(), CSDRefObj, new map<String, map<String, AggregateResult>>(), new map<String, map<String, AggregateResult>>());
            CSD_ClsUtils.setRefDateObject(new list<Date>{date.today().addDays(-30)}, new list<Date>{date.today().addDays(30)}, CSDRefObj , NEW map<String, map<String, AggregateResult>>(), NEW map<String, map<String, AggregateResult>>());
            
            CSD_ClsUtils.getSamsungGPLFamilyByUser(user.Id, 'test', 'test', new set<String>(), new set<String>(), new set<String>(), new set<String>());
            CSD_ClsUtils.getSamsungGPLFamilyByManage('test', 'test',new set<String>(), new set<String>(), new set<String>(), new set<String>());
            CSD_ClsEntityType.SearchObj SearchObj = new CSD_ClsEntityType.SearchObj();
            SearchObj.startDate = string.valueOf(date.today());
            SearchObj.endDate = string.valueOf(date.today());
            SearchObj.map_year_monthsFuture = new map<String, set<Integer>>{'2016' => new set<integer>{1}};
            SearchObj.accnumber = '1234:12345678';
            SearchObj.partId = part.Id;
            CSD_ClsUtils.copyCFTForecast(JSON.serialize(SearchObj));
            CSD_ClsUtils.hasCFTForecastForSamsung('', '', new set<String>(), Date.today(), Date.today(), new set<String>());
            CSD_ClsUtils.getRegionForCreateSoldTo(new set<String>{'1234:12345678'});
                
            Test.stoptest();
        }
    }
    static testMethod void myUnitTest2() 
    {
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
        
        RecordType rtsoldto = ClsTestHelp.createTestRecordType8();
        RecordType rtoem = ClsTestHelp.createCSDTestRecordType7(); 
        system.debug('!@# rtoem :'+rtoem);    
        Consumer_Device_Opportunity_Record_Types__c cdort1 = ClsTestHelp.createTestCSD1();
        Consumer_Device_Opportunity_Record_Types__c cdort2 = ClsTestHelp.createTestCSD2();
        Consumer_Device_Opportunity_Record_Types__c cdort3 = ClsTestHelp.createTestCSD3();
        Consumer_Device_Opportunity_Record_Types__c cdort4 = ClsTestHelp.createTestCSD4();
        Consumer_Device_Opportunity_Record_Types__c cdort5 = ClsTestHelp.createTestCSD5();
        Consumer_Device_Opportunity_Record_Types__c cdort6 = ClsTestHelp.createTestCSD6();
        Consumer_Device_Opportunity_Record_Types__c cdort7 = ClsTestHelp.createTestCSD7();
        
        User user = ClsTestHelp.createTestUsers(); 
        user.Te_Network_Id__c = 'ABCDEFG';
        User user3 = ClsTestHelp.createTestUsers(); 
        user3.CommunityNickname = 'user3';
        user3.Te_Network_Id__c = 'ABCDEFh';
       
        insert new list<user>{user, User3};

        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
        sh.Level_2_Territory_Code__c = '103004';
        sh.Level_7_Territory_Code__c = '123456';
        sh.Level_1_Assigned_User_Network_Ids__c = 'ABCDEFG;ABCDEFh';
        sh.Level_2_Assigned_User_Network_Ids__c = 'ABCDEFG;ABCDEFh';
        sh.Level_3_Assigned_User_Network_Ids__c = 'ABCDEFG;ABCDEFh';
        sh.Level_4_Assigned_User_Network_Ids__c = 'ABCDEFG;ABCDEFh';
        sh.Level_5_Assigned_User_Network_Ids__c = 'ABCDEFG;ABCDEFh';
        sh.Level_6_Assigned_User_Network_Ids__c = 'ABCDEFG;ABCDEFh';
        sh.Level_7_Assigned_User_Network_Ids__c = 'ABCDEFG;ABCDEFh';
        sh.Level_1_Assigned_Users__c = user.id;
        sh.Level_2_Assigned_Users__c = user.id;
        sh.Level_3_Assigned_Users__c = user.id;
        sh.Level_4_Assigned_Users__c = user.id;
        sh.Level_5_Assigned_Users__c = user.id;
        sh.Level_6_Assigned_Users__c = user.id;
        sh.Level_7_Assigned_Users__c = user.id;
        
        Sales_Hierarchy__c sh2 = ClsTestHelp.createTestSalesHierarchy();
        sh2.Level_2_Territory_Code__c = '103004';
        sh2.Level_7_Territory_Code__c = '123456';
        sh2.Level_1_Assigned_User_Network_Ids__c = 'ABCDEFG';
        sh2.Level_2_Assigned_User_Network_Ids__c = 'ABCDEFG';
        sh2.Level_3_Assigned_User_Network_Ids__c = 'ABCDEFG';
        sh2.Level_4_Assigned_User_Network_Ids__c = 'ABCDEFG';
        sh2.Level_5_Assigned_User_Network_Ids__c = 'ABCDEFG';
        sh2.Level_6_Assigned_User_Network_Ids__c = 'ABCDEFG';
        sh2.Level_7_Assigned_User_Network_Ids__c = 'ABCDEFG';
        sh2.Level_1_Assigned_Users__c = user.id;
        sh2.Level_2_Assigned_Users__c = user.id;
        sh2.Level_3_Assigned_Users__c = user.id;
        sh2.Level_4_Assigned_Users__c = user.id;
        sh2.Level_5_Assigned_Users__c = user.id;
        sh2.Level_6_Assigned_Users__c = user.id;
        sh2.Level_7_Assigned_Users__c = user.id;
        
        insert new list<Sales_Hierarchy__c > {sh, sh2};
                
        Account samsung = ClsTestHelp.createTestAccounts();
        samsung.Name = 'samsung';
        samsung.RecordTypeId = rtoem.Id;
        samsung.Account_Manager__c = user.Id;
        samsung.Design_In_Region__c = 'KOREA';
        samsung.STATDESC__c = 'Active';
        samsung.Active__c = true;
        //insert samsung;
        Account acct1 = ClsTestHelp.createTestAccounts();
        acct1.Name = 'axx';
        acct1.RecordTypeId = rtsoldto.Id;
        acct1.AccountNumber = '1234:12345678';
        acct1.Account_Manager__c = user.Id;
        acct1.SALES_TERRITORY_CDE__c = '123456';
        acct1.Active__c = true;
        acct1.STATDESC__c = 'Active';
        acct1.WWCORPACCT__c = '123412345678';
        //insert acct1;     
        Account acct11 = ClsTestHelp.createTestAccounts();
        acct11.Name = 'axx1';
        acct11.RecordTypeId = rtsoldto.Id;
        acct11.AccountNumber = '1234:12345679';
        acct11.Account_Manager__c = user.Id;
        acct11.SALES_TERRITORY_CDE__c = '123456';
        acct11.Active__c = true;
        acct11.STATDESC__c = 'Active';
        acct11.WWCORPACCT__c = '123412345678';
        //insert acct11;
        
        Account acct2 = ClsTestHelp.createTestAccounts();
        acct2.Name = 'relayAcctaxx';
        acct2.RecordTypeId = rtoem.Id;
        acct2.Account_Manager__c = user.Id;
        acct2.Design_In_Region__c = 'AMERICAS';
        acct2.STATDESC__c = 'Active';
        acct2.Active__c = true;
        //insert acct2;
        
        Account acct22 = ClsTestHelp.createTestAccounts();
        acct22.Name = 'relayAcctaxx2';
        acct22.RecordTypeId = rtoem.Id;
        acct22.Account_Manager__c = user.Id;
        acct22.Design_In_Region__c = 'AMERICAS';
        acct22.STATDESC__c = 'Active';
        acct22.Active__c = true;
        //insert acct22;
        insert new List<Account>{samsung,acct1,acct11,acct2,acct22};
            
        CSD_Configuration__c setting = new CSD_Configuration__c();
        setting.Name = 'Samsung OEM Account';
        setting.Value__c = samsung.Id;
        //insert setting;
        
        CSD_Configuration__c setting2 = new CSD_Configuration__c();
        setting2.Name = 'Non OEM Account';
        setting2.Value__c = samsung.Id;
        //insert setting2;
        
        insert new List<CSD_Configuration__c>{setting,setting2};
        

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
        //insert ph2;
        insert new List<Product_Hierarchy__c>{ph,ph1,ph2};
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
        part1.PRODUCT_CDE__c = 'TEST2';
        part1.PROD_NAME__c = 'test name2';
        //insert part1;
        
        Part__c part2 = new Part__c();
        part2.Name = 'testPart';
        part2.GPL__c = ph2.Id;
        part2.Product_Hierarchy__c = ph2.Id; 
        part2.Description__c = 'test';
        part2.PRODUCT_CDE__c = 'TEST3';
        part2.PROD_NAME__c = 'test name3';
        //insert part2;
        insert new List<Part__c>{part,part1,part2};
            
        CSD_Sales_Forecast__c csdFC1 = new CSD_Sales_Forecast__c();
        csdFC1.Type__c = 'Sold-To';
        csdFC1.Fiscal_Year__c = '2015';
        csdFC1.Fiscal_Month__c = '9';
        csdFC1.Sold_To_Number__c = '1234:12345678';
        csdFC1.Sold_To_Name__c = 'Test';
        csdFC1.Forecast__c = 1000;
        csdFC1.Billing_Region__c = 'AMERICAS';
        //insert csdFC1;
        
        CSD_Sales_Forecast__c csdFC2 = new CSD_Sales_Forecast__c();
        csdFC2.type__c = 'OEM';
        csdFC2.Fiscal_Year__c = '2015';
        csdFC2.Fiscal_Month__c = '9';
        csdFC2.Sold_To_Number__c = '1234:12345678';
        csdFC2.Sold_To_Name__c = 'Test';
        csdFC2.OEM__c = acct2.Id;
        csdFC2.Forecast__c = 1000;
        csdFC2.Billing_Region__c = 'AMERICAS';
        //insert csdFC2;        
        
        CSD_Sales_Forecast__c csdFC3 = new CSD_Sales_Forecast__c();
        csdFC3.type__c = 'Part';
        csdFC3.Fiscal_Year__c = '2015';
        csdFC3.Fiscal_Month__c = '9';
        csdFC3.Sold_To_Number__c = '1234:12345678';
        csdFC3.Sold_To_Name__c = 'Test';
        csdFC3.Part__c = part1.Id;
        csdFC3.Forecast__c = 100;
        csdFC3.OEM__c = acct2.Id;
        csdFC3.Price__c = 10;
        csdFC3.Quantity__c = 10;
        csdFC3.Billing_Region__c = 'AMERICAS';
        //insert csdFC3;
        insert new List<CSD_Sales_Forecast__c>{csdFC1,csdFC2,csdFC3};
            
        CSD_Channel_Forecast__c channel = new CSD_Channel_Forecast__c();
        channel.Billing_Region__c = 'AMERICAS';
        channel.Fiscal_Year__c = '2015';
        channel.Fiscal_Month__c = '9';
        channel.Forecast__c = 200;
        channel.OEM__c = acct2.Id;
        channel.Name = 'ChannelForecast';
        insert channel;
        
        RecordType rt25 = ClsTestHelp.createTestRecordType25(); 
        CSD_Forecast_Management__c csd = new CSD_Forecast_Management__c();
        csd.Name = 'testName';
        csd.Role__c = 'Sales Leader';
        csd.Region__c = 'AMERICAS';
        csd.WWAC_Code__c = '123412345678';
        csd.User__c = user.Id;
        insert csd;
        
        OEM_Details__c oemd = new OEM_Details__c();
        oemd.OEM__c = acct2.Id;
        insert oemd;
        
        OEM_Mapping_Rule__c oemmap = new OEM_Mapping_Rule__c();
        oemmap.OEM__c = oemd.Id;
        oemmap.Allocation__c = 100;
        oemmap.Sold_To_Account_Code__c = '12345678';
        oemmap.Type__c = 'Customer';
        insert oemmap;
        
        BBB_Month_Bill_Book_Cust_PN__c bbbMon = new BBB_Month_Bill_Book_Cust_PN__c();
        bbbMon.Customer__c = acct1.Id;
        bbbMon.Bill_Amount_USD__c = 10;
        bbbMon.Book_Amount_USD__c = 10; 
        bbbMon.Fiscal_Year__c = '2015';
        bbbMon.Fiscal_Month__c = 8;
        bbbMon.Profit_Center__c = 'CSD';
        bbbMon.Part__c = part.Id;
        insert bbbMon;

        CSD_OEM_Mapping_Monthly_BBB__c monmap = new CSD_OEM_Mapping_Monthly_BBB__c();
        monmap.Monthly_Billings_Bookings_by_Part__r = bbbMon;
        monmap.OEM_Mapping__c = oemmap.Id;
        
        
        BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c bbbDay = new BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c();
        bbbDay.Backlog_Amount_USD__c = 10;
        bbbDay.Bill_Amount_USD__c = 10; 
        bbbDay.Book_Amount_USD__c = 10;
        bbbDay.Customer__c = acct1.Id;
        bbbDay.Fiscal_Year__c = '2015';
        bbbDay.Fiscal_Month__c = 9;
        bbbDay.Customer_Request_Date_Fiscal_Year__c = '2015';
        bbbday.Customer_Request_Date_Fiscal_Month__c = 9;
        bbbDay.Profit_Center__c = 'CSD';
        bbbDay.Part__c = part.Id;
        insert bbbDay;

        CSD_OEM_Mapping_Daily_BBB__c daymap = new CSD_OEM_Mapping_Daily_BBB__c();
        daymap.Daily_Booking_Billing_Backlog_By_Part__c = bbbDay.Id;
        daymap.CSD_OEM_Mapping__c  = oemmap.Id;
        insert daymap;
        
        
        CSD_ClsEntityType.SearchObj so = new CSD_ClsEntityType.SearchObj();
        so.set_fiscalMonth = new set<String>();
        so.set_fiscalMonth.add('2015_5');
        so.set_fiscalMonth.add('2015_9');
        so.set_fiscalMonth.add('2015_8');
        
        so.map_year_monthsFuture = new map<String, set<Integer>>{
            '2015'=> new set<Integer>{3,4,5,6,7,8,9,10,11}
        };
        
        so.map_quarter_months =  new map<String, String>{
            '01'=>'1,2,3',
            '02'=>'4,5,6',
            '03'=>'7,8,9',
            '04'=>'10,11,12'
        };
        so.set_selectedId = new set<String>();
        so.startDate = '2015-03-15';
        so.endDate = '2015-11-15';
        so.managerId = user.Id;
        so.searchKey = '';
        //View Mode
        so.viewMode = 'billingRegion';
        so.isOtherMethod = false;
        so.accnumber = '1234:12345678';
        String sData = JSON.serialize(so);
        String result = '';
        
        system.runAs(user){
            Test.startTest();

            list<AggregateResult> lstAGR = database.query( ' select Fiscal_Month__c year, Fiscal_Year__c month, OEM__c oem, name name, sum(DC_Forecast_Price__c) sumFC, sum(DC_Forecast_Quantity__c) sumPMFC , sum(DC_Forecast_Amount__c) sumDCFC, sum(Previous_10_Month_Forecast__c) restPNFC   from  CSD_Sales_Forecast__c  group by Fiscal_Month__c, Fiscal_Year__c, OEM__c, name ');
            CSD_ClsEntityType.SearchObj SearchObj = new CSD_ClsEntityType.SearchObj();
            SearchObj.startDate = string.valueOf(date.today());
            SearchObj.endDate = string.valueOf(date.today());
            SearchObj.map_year_monthsFuture = new map<String, set<Integer>>{'2016' => new set<integer>{1}};
            SearchObj.accnumber = '1234:12345678';
            SearchObj.partId = part.Id;
            SearchObj.set_selectedId = new set<string>();
            CSD_ClsUtils.getASP(JSON.serialize(SearchObj));
            CSD_ClsUtils.setStatisticalForecastDate(new set<String>(), new set<Integer>(), new list<Date>{date.today()});
            CSD_ClsUtils.setAllPeriodStartEndDateForComparison(new map<String, Date>());
            CSD_ClsUtils.setFiscalMonthForComparison(new CSD_ClsEntityType.PageConfig());
            CSD_ClsEntityType.PageConfig PageConfig = new CSD_ClsEntityType.PageConfig();
            PageConfig.currentYear = '2016';
            PageConfig.list_yearMonth = new List<String>{'2016_01','2016_02','2016_03','2016_04','2016_05','2016_06','2016_01','2016_02','2016_03','2016_04','2016_05','2016_06','2016_01','2016_02','2016_03','2016_04','2016_05','2016_06'};
            PageConfig.currentMonthIndex = 0;
            
            CSD_ClsUtils.createDateItemForComparison(PageConfig, new list<CSD_ClsEntityType.DateItem>());
            CSD_ClsUtils.getExistResultForComparisonBase(lstAGR , new map<String, String>{'2015' => '9_2015'}, 'name', true, 'name');
            CSD_ClsUtils.getExistResultForComparisonBaseNew(lstAGR , new map<String, CSD_ClsEntityType.AccountObjForComparison>(), new map<String, String>{'2015' => '9_2015'}, 'name', true, 'name', true);
            CSD_ClsUtils.compareListByDate(new map<String, CSD_ClsEntityType.AccountObjForComparison>());
            CSD_ClsUtils.getExistResultForComparison(new map<String, String>(), new map<String, CSD_ClsEntityType.AccountObjForComparison>(), new set<String>(), new list<String>{'Fiscal_Month__c year, Fiscal_Year__c month, OEM__c refId, name name ', ' CSD_Sales_Forecast__c', ' group by Fiscal_Month__c, Fiscal_Year__c, OEM__c, name '}, Date.today(), Date.today(), 'refId', true, 'name', true);
            CSD_ClsUtils.autoCreateOEMForecast(new map<String, set<String>>{acct2.AccountNumber => new set<string>()}, Date.today(), new set<String>());
            CSD_ClsUtils.getSoldtoLevel1Data(new list<Object>(),JSON.serialize(SearchObj), new set<String>(), new set<String>(), new set<String>());
            CSD_ClsUtils.setMapSoldtohasKeyOEM(new map<String, Boolean>(), new set<String>(), new set<String>(), Date.today());
            CSD_ClsUtils.autoCreateOEMForecastAndGetSoldtoData(new list<Object>(), JSON.serialize(SearchObj));
            CSD_ClsUtils.setGAMViewAccountObjMap(new map<String, CSD_ClsEntityType.AccountObj>(), new CSD_ClsEntityType.PageConfig(), new list<String>{'Fiscal_Month__c year, Fiscal_Year__c month, OEM__c oem, name accname, sum(DC_Forecast_Price__c) sumFC, sum(DC_Forecast_Quantity__c) sumPMFC , sum(DC_Forecast_Amount__c) sumDCFC, sum(Previous_10_Month_Forecast__c) restPNFC   ', ' CSD_Sales_Forecast__c', ' group by Fiscal_Month__c, Fiscal_Year__c, OEM__c, name '}, new set<String>(), Date.today(), Date.today());
            CSD_ClsUtils.setGAMOEMCompetence('', new set<String>());
            
            Date startDate, endDate;
            CSD_ClsUtils.setFiscalDateRangeNew(date.today(), startDate, endDate);
            CSD_ClsUtils.setRegionMapRefDataBacklog('',date.today(), date.today(),date.today(), new set<String>(), new list<String>{' Fiscal_Date__c refdate ', ' CSD_Sales_Forecast__c ', ' group by Fiscal_Date__c '}, new map<String, map<String, AggregateResult>>());
			CSD_ClsUtils.setSoldToMapRefDataBacklog(Date.today(), Date.today(), Date.today(), new list<String>{' Customer__r.AccountNumber refId, sum(Backlog_Amount_USD__c) amount ', ' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ', ' WHERE Customer__r.STATDESC__c = \'Active\' Group by Customer__r.AccountNumber '}, new map<String, map<String, AggregateResult>>());
			CSD_ClsUtils.setTotelBillingDataBacklog(Date.today(), Date.today(), Date.today(), new set<String>(), new list<String>{' sum(Backlog_Amount_USD__c) amount ', ' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ', ' WHERE Customer__r.STATDESC__c = \'Active\' Group by Customer__r.AccountNumber '}, new map<String, map<String, AggregateResult>>());
			CSD_ClsUtils.setOEMPartMapRefDataBacklog(Date.today(), new set<String>(), new list<String>{' Customer__r.AccountNumber refId, sum(Backlog_Amount_USD__c) amount ', ' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ', ' WHERE Customer__r.STATDESC__c = \'Active\' Group by Customer__r.AccountNumber '}, new map<String, map<String, AggregateResult>>());
 			CSD_ClsUtils.setGAMOEMMapRefDataBacklog(Date.today(), '', new set<String>(), new list<String>{' Customer__r.AccountNumber refId, sum(Backlog_Amount_USD__c) amount ', ' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ', ' WHERE Customer__r.STATDESC__c = \'Active\' Group by Customer__r.AccountNumber '}, new map<String, map<String, AggregateResult>>());
 			
 			
            /*CSD_ClsUtils.
            CSD_ClsUtils.
            CSD_ClsUtils.
                CSD_ClsUtils.
                CSD_ClsUtils.
                CSD_ClsUtils.
                CSD_ClsUtils.
                CSD_ClsUtils.
                CSD_ClsUtils.
                CSD_ClsUtils.*/
                
                
            Test.stoptest();
        }
    }   
}