/**
*  This test class used to test class ClsBatch_setBBBDayByPartYearAndMonth.
*
@author Lili Zhao
@created 2014-08-13
*
@changelog
* coverage  100%
*  
2014-08-13 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest
private class ClsDailyBookBilliBacklogByPartsUtil_Test {

    static testMethod void myUnitTest() {
    	Profile p = [select Id from Profile where Name = 'System Administrator' limit 1];
    	
    	User u = ClsTestHelp.createTestUsers();
    	u.ProfileId = p.Id;
    	u.Username = 'KO@testKOitbconsult.com';
    	u.Email = 'hoho@testItbconsult.com';
    	u.CommunityNickname = 'xxx.xxx';
    	u.Alias = 'rrr';
    	insert u;
        
        Test.startTest();
    	
    	system.runAs(u){
    	
	    	Date maxDate = system.today();
	    	Date minDate = system.today();
	    	list<BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c> list_bbbDayBillBookBklgCustPNs = new list<BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c>();
	    	
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

	        
	        Product_Hierarchy__c prodH = new Product_Hierarchy__c();
	        prodH.Name = 'A00';
	        prodH.CBC1__c = '99999';
	        prodH.CBC1_Description__c = 'Test Produce Hierarchy';
	        insert prodH;
	        
	        // Part Record
	        Part__c part = new Part__c();
	        part.Name = '1-1705765-6';
	        part.Product_Hierarchy__c = prodH.id;
	        insert part;  
	        
	        BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c bbb = new BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c();
	    	bbb.Customer__c = acc.Id;
	    	bbb.Part__c = part.Id;
	    	bbb.Customer_Request_Date__c = date.today();
	    	bbb.Current_Schedule_Date__c = date.today();
	    	insert bbb;
	        list_bbbDayBillBookBklgCustPNs.add(bbb);
	        
	        ClsDailyBookingBillingBacklogByPartsUtil.setBbbDayBillBookBklgCustPNYearAndMonth(list_bbbDayBillBookBklgCustPNs, maxDate, minDate, true);
    	}
        system.assert(true);
        Test.stopTest();
        
    }
}