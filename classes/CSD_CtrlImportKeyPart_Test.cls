/**
*  This test class used to test class CSD_CtrlImportKeyPart.
*
@author Lili Zhao
@created 2015-06-18
*
@changelog
* coverage  81%
*  
2015-06-18 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest
private class CSD_CtrlImportKeyPart_Test {

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
        user.FirstName ='TeFirst';
        user.LastName = 'Tester';
        user.Username = 'tetest@tetest.com';
        user.Te_Network_Id__c = 'ABCDEFG';
        user.Email = 'tetest@tetest.com';
        insert user;

        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
    	sh.Level_2_Territory_Code__c = '103004';
    	sh.Level_7_Territory_Code__c = '123456';
    	sh.Level_7_Assigned_User_Network_Ids__c = 'ABCDEFG';
        insert sh;
				
		Account samsung = ClsTestHelp.createTestAccounts();
    	samsung.Name = 'samsung';
    	samsung.RecordTypeId = rtoem.Id;
    	samsung.Account_Manager__c = user.Id;
    	samsung.Design_In_Region__c = 'KOREA';
    	samsung.STATDESC__c = 'Active';
    	samsung.Active__c = true;
    	insert samsung;

		CSD_Configuration__c setting = new CSD_Configuration__c();
		setting.Name = 'Samsung OEM Account';
		setting.Value__c = samsung.Id;
		insert setting;
		
		CSD_Configuration__c setting2 = new CSD_Configuration__c();
		setting2.Name = 'Non OEM Account';
		setting2.Value__c = samsung.Id;
		insert setting2;
		
		
    	Account acct1 = ClsTestHelp.createTestAccounts();
    	acct1.Name = 'axx';
    	acct1.RecordTypeId = rtsoldto.Id;
    	acct1.AccountNumber = '1234:12345678';
    	acct1.Account_Manager__c = user.Id;
    	acct1.SALES_TERRITORY_CDE__c = '123456';
    	acct1.Active__c = true;
    	acct1.STATDESC__c = 'Active';
    	acct1.WWCORPACCT__c = '123412345678';
    	insert acct1;
    	
    	Account acct11 = ClsTestHelp.createTestAccounts();
    	acct11.Name = 'axx1';
    	acct11.RecordTypeId = rtsoldto.Id;
    	acct11.AccountNumber = '1234:12345679';
    	acct11.Account_Manager__c = user.Id;
    	acct11.SALES_TERRITORY_CDE__c = '123456';
    	acct11.Active__c = true;
    	acct11.STATDESC__c = 'Active';
    	acct11.WWCORPACCT__c = '123412345679';
    	insert acct11;
    	
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
        part1.Name = 'testPart1';
        part1.GPL__c = ph1.Id;
        part1.Product_Hierarchy__c = ph1.Id; 
        part1.Description__c = 'test';
        part1.PRODUCT_CDE__c = 'TEST2';
        part1.PROD_NAME__c = 'test name2';
        insert part1;
        
        Part__c part2 = new Part__c();
        part2.Name = 'testPart2';
        part2.GPL__c = ph2.Id;
        part2.Product_Hierarchy__c = ph2.Id; 
        part2.Description__c = 'test';
        part2.PRODUCT_CDE__c = 'TEST3';
        part2.PROD_NAME__c = 'test name3';
        insert part2;
        
        
        
        CSD_Key_Part_Management__c ckpm = new CSD_Key_Part_Management__c();
        insert ckpm;
        
        Test.startTest();
        
        CSD_CtrlImportKeyPart keyPart = new CSD_CtrlImportKeyPart();
        CSD_CtrlImportKeyPart.ExceptionObj ce = new CSD_CtrlImportKeyPart.ExceptionObj('test', 1);
        
        keyPart.deleteObject();
        
        list<CSD_CtrlImportKeyPart.CustomKeyPart> list_fc = new list<CSD_CtrlImportKeyPart.CustomKeyPart>();
        CSD_CtrlImportKeyPart.CustomKeyPart key = new CSD_CtrlImportKeyPart.CustomKeyPart();
        key.soldtonumber = '';
        key.oemname = '';
        key.partnumber = 'testPart';
        key.accountId = '';
        key.oemId = '';
        key.partId = part.Id;
        key.index = 0;
		list_fc.add(key);
		
		CSD_CtrlImportKeyPart.CustomKeyPart key1 = new CSD_CtrlImportKeyPart.CustomKeyPart();
        key1.soldtonumber = '';
        key1.oemname = '';
        key1.partnumber = '';
        key1.accountId = '';
        key1.oemId = '';
        key1.partId = '';
        key1.index = 1;
		list_fc.add(key1);
		
        CSD_CtrlImportKeyPart.upsertListObject( JSON.serialize(list_fc) );
        
        Test.stopTest();
    }
}