@isTest
public class ClsBatch_APLForecastAccuracyTest {
	
	static testMethod void test() {
		
		List<APL_Forecast_Management__c> l = new List<APL_Forecast_Management__c>();
		
		APL_Forecast_Management__c apl = new APL_Forecast_Management__c();
    	apl.Name = 'testName';
    	apl.A6_Code__c = '123456';
    	apl.Manager__c = userInfo.getUserId();  
    	apl.RecordTypeId = '012E0000000NDPf';
    	l.add(apl);
    	
    	APL_Forecast_Management__c apl1 = new APL_Forecast_Management__c();
    	apl1.Name = 'testName1';
    	apl1.A6_Code__c = '1234567';
    	apl1.Manager__c = userInfo.getUserId();
    	apl1.RecordTypeId = '012E0000000NDPh';
    	l.add(apl1);
    	
    	insert l;
    	
    	Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();
        
    	RecordType rt = ClsTestHelp.createTestRecordType6();
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
    	
    	List<Account> aL = new List<Account>();
    	Account relayAcct = ClsTestHelp.createTestAccounts();
    	relayAcct.Name = 'relayAcctaxx';
    	relayAcct.RecordTypeId = rt2.Id;
    	relayAcct.STATDESC__c = 'active';
    	relayAcct.Account_Manager__c = userInfo.getUserId();
    	relayAcct.APL_Relay_Currency__c = 'USD';
    	relayAcct.APL_Relay_Display_Name__c = 'testName';
    	relayAcct.Relay_Specialist_Territory_Code__c = '1234567';    	
    	aL.add(relayAcct);
    	
    	Account amAcct = ClsTestHelp.createTestAccounts();
    	amAcct.Name = 'axx';
    	amAcct.RecordTypeId = rt2.Id;
    	amAcct.STATDESC__c = 'active';
    	amAcct.APL_AM_Currency__c = 'USD';
    	amAcct.APL_AM_Display_Name__c = 'amName';   	
    	amAcct.Account_Manager__c = userInfo.getUserId();
    	amAcct.SALES_TERRITORY_CDE__c = '123456';
    	aL.add(amAcct);
    	insert aL;
    	// GPL or Product Hierarchy Record
    	List<Product_Hierarchy__c> prodHL = new List<Product_Hierarchy__c>();
        Product_Hierarchy__c prodH = new Product_Hierarchy__c();
        prodH.Name = 'A00';
        prodH.CBC1__c = '99999';
        prodH.CBC1_Description__c = 'Test Produce Hierarchy';
        prodH.CBC2__c = '30012';
        prodH.CBC2_Description__c = 'Test Produce Hierarchy';
        prodHL.add(prodH);
        
        Product_Hierarchy__c prodH1 = new Product_Hierarchy__c();
        prodH1.Name = 'A00';
        prodH1.CBC1__c = '99999';
        prodH1.CBC1_Description__c = 'Test Produce Hierarchy';
        prodH1.CBC2__c = '31112';
        prodH1.CBC2_Description__c = 'Test Produce Hierarchy';
        prodH1.CBC3__c = '41553';
        prodHL.add(prodH1);
        
        Product_Hierarchy__c prodH2 = new Product_Hierarchy__c();
        prodH2.Name = 'A00';
        prodH2.CBC1__c = '99999';
        prodH2.CBC1_Description__c = 'Test Produce Hierarchy';
        prodH2.CBC2__c = '30014';
        prodH2.CBC2_Description__c = 'CBCoutside';
        prodH2.GPL_Description__c = 'CBCoutside';
        prodHL.add(prodH2);
        
        Product_Hierarchy__c prodH3 = new Product_Hierarchy__c();
        prodH3.Name = 'A03';
        prodH3.CBC1__c = '00003';
        prodH3.CBC1_Description__c = 'Test Produce Hierarchy';
        prodHL.add(prodH3);
        
        insert prodHL;
    	
    	List<APL_Sales_Forecast__c> l1 = new List<APL_Sales_Forecast__c>();
    	APL_Sales_Forecast__c aplFC1 = new APL_Sales_Forecast__c();
		aplFC1.type__c = 'GPL';
		aplFC1.Fiscal_Year__c = '2015';
		aplFC1.Fiscal_Quarter__c = '03';
		aplFC1.customer__c = amAcct.Id;
		aplFC1.GPL__c = prodH.Id;
		aplFc1.Current_month_2_RSM_forecast__c = 100;
		aplFc1.Current_month_3_RSM_forecast__c = 100;
		aplFc1.Current_month_4_RSM_forecast__c = 100;
		l1.add(aplFC1);
		
		
		APL_Sales_Forecast__c aplFC4 = new APL_Sales_Forecast__c();
		aplFC4.type__c = 'GPL';
		aplFC4.Fiscal_Year__c = '2015';
		aplFC4.Fiscal_Quarter__c = '03';
		aplFC4.customer__c = amAcct.Id;
		aplFC4.GPL__c = prodH2.Id;
		aplFC4.Current_month_2_RSM_forecast__c = 100;
		aplFC4.Current_month_3_RSM_forecast__c = 100;
		aplFC4.Current_month_4_RSM_forecast__c = 100;
		l1.add(aplFC4);

		APL_Sales_Forecast__c aplFC2 = new APL_Sales_Forecast__c();
		aplFC2.type__c = 'Other CBC2';
		aplFC2.Fiscal_Year__c = '2015';
		aplFC2.Fiscal_Quarter__c = '03';
		aplFC2.customer__c = amAcct.Id;
		aplFC2.GPL__c = prodH1.Id;
		aplFC2.Current_month_2_RSM_forecast__c = 100;
		aplFC2.Current_month_3_RSM_forecast__c = 100;
		aplFC2.Current_month_4_RSM_forecast__c = 100;
		l1.add(aplFC2);
		
		APL_Sales_Forecast__c aplFC3 = new APL_Sales_Forecast__c();
		aplFC3.type__c = 'Relay Product Code';
		aplFC3.Fiscal_Year__c = '2015';
		aplFC3.Fiscal_Quarter__c = '03';
		aplFC3.customer__c = relayAcct.Id;
		aplFC3.GPL__c = prodH.Id;
		aplFC3.Current_month_2_RSM_forecast__c = 100;
		aplFC3.Current_month_3_RSM_forecast__c = 100;
		aplFC3.Current_month_4_RSM_forecast__c = 100;
		l1.add(aplFC3);
		
		APL_Sales_Forecast__c aplFC5 = new APL_Sales_Forecast__c();
		aplFC5.type__c = 'Other CBC2';
		aplFC5.Fiscal_Year__c = '2015';
		aplFC5.Fiscal_Quarter__c = '03';
		aplFC5.customer__c = amAcct.Id;
		aplFC5.GPL__c = prodH3.Id;
		aplFC5.Current_month_2_RSM_forecast__c = 100;
		aplFC5.Current_month_3_RSM_forecast__c = 100;
		aplFC5.Current_month_4_RSM_forecast__c = 100;
		l1.add(aplFC5);
		
		APL_Sales_Forecast__c aplFC6 = new APL_Sales_Forecast__c();
		aplFC6.type__c = 'Relay Product Code';
		aplFC6.Fiscal_Year__c = '2015';
		aplFC6.Fiscal_Quarter__c = '03';
		aplFC6.customer__c = amAcct.Id;
		aplFC6.GPL__c = prodH3.Id;
		aplFC6.Current_month_2_RSM_forecast__c = 100;
		aplFC6.Current_month_3_RSM_forecast__c = 100;
		aplFC6.Current_month_4_RSM_forecast__c = 100;
		l1.add(aplFC6);
		
		insert l1;
        
        // Part Records
        List<Part__c> partList = new List<Part__c>();
        Part__c part1 = new Part__c();
        part1.Name = '0123456879';
        part1.Product_Hierarchy__c = prodH.id;
        partList.add(part1);
        Part__c part2 = new Part__c();
        part2.Name = '9-9999999-9';
        part2.Product_Hierarchy__c = prodH1.id;
        partList.add(part2);
        insert partList;
        
        list<BBB_Month_Bill_Book_Cust_PN__c> bbbs = new list<BBB_Month_Bill_Book_Cust_PN__c>();
        
        for(Integer i=0;i < 10; i++)
        {
            BBB_Month_Bill_Book_Cust_PN__c temp = new BBB_Month_Bill_Book_Cust_PN__c();
            
            if(i < 5)
            {
            	temp.Customer__c = amAcct.Id;
            	temp.Customer__r = amAcct;
                temp.Part__c = part1.id;
                temp.Part__r = part1;
                temp.profit_center__c = 'APL';
            }
            else
            {
            	temp.Customer__c = relayAcct.Id;
            	temp.Customer__r = relayAcct;
                temp.Part__c = part2.id;
                temp.Part__r = part2; 
                temp.profit_center__c = 'APL';                                           
            }
            temp.Bill_Amount_USD__c = i;
            temp.Bill_Quantity__c = i +1;
            temp.Fiscal_Year__c = '2015';
            temp.Fiscal_MOnth__c = 8;
            bbbs.add(temp);
        }
        BBB_Month_Bill_Book_Cust_PN__c relaybill = new BBB_Month_Bill_Book_Cust_PN__c();
        relaybill.Customer__c = amAcct.Id;
    	relaybill.Customer__r = amAcct;
        relaybill.Part__c = part2.id;
        relaybill.Part__r = part2;
        relaybill.profit_center__c = 'APL';
        relaybill.Bill_Amount_USD__c = 20;
        relaybill.Bill_Quantity__c = 10;
        relaybill.Fiscal_Year__c = '2015';
        relaybill.Fiscal_MOnth__c = 8;
        bbbs.add(relaybill);
        
        insert bbbs;
        
        APL_Forecast_Settings__c afs = new APL_Forecast_Settings__c(Name = 'Forecast accuracy exception',Value__c='30014:CBCoutside;');
        insert afs;

        Test.startTest();
		ClsBatch_APLForecastAccuracy batch = new ClsBatch_APLForecastAccuracy(null,'2015','3');	
		Database.executeBatch(batch);
		Test.stopTest();
	}
}