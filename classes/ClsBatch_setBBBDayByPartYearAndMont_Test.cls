/**
*  This test class used to test class ClsBatch_setBBBDayByPartYearAndMonth.
*
@author Lili Zhao
@created 2014-08-13
*
@changelog
* coverage  95%
*  
2014-08-13 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest 
private class ClsBatch_setBBBDayByPartYearAndMont_Test {
	static testMethod void testMethod1() {
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
    	
    	Account acc = ClsTestHelp.createTestAccounts();
    	acc.Name = 'axx';
    	acc.RecordTypeId = rt2.Id;
    	insert acc;

        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        insert ph;
        
        Part__c part = new Part__c();
    	part.Description__c = 'Sniper';
    	part.Product_Hierarchy__c = ph.Id;
    	insert part;
    	 
    	BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c bbb = new BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c();
    	bbb.Customer__c = acc.Id;
    	bbb.Part__c = part.Id;
    	bbb.Customer_Request_Date__c = date.today();
    	bbb.Current_Schedule_Date__c = date.today();
    	insert bbb;
    	
    	BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c bbb1 = new BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c();
    	bbb1.Customer__c = acc.Id;
    	bbb1.Part__c = part.Id;
    	bbb1.Customer_Request_Date__c = date.today().addDays(2);
    	bbb1.Current_Schedule_Date__c = date.today();
    	insert bbb1;
    	
        list<BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c> list_bbbDailyBookingBillingBacklog = new list<BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c>();
        list_bbbDailyBookingBillingBacklog.add(bbb);
        list_bbbDailyBookingBillingBacklog.add(bbb1);
        
        Test.startTest();
	    ClsBatch_setBBBDayByPartYearAndMonth clsBatch = new ClsBatch_setBBBDayByPartYearAndMonth();
        Database.BatchableContext BC;
		clsBatch.start(BC);
		clsBatch.execute(BC, list_bbbDailyBookingBillingBacklog);
		clsBatch.finish(BC);
	    
	        
	    Test.stopTest();
    }
}