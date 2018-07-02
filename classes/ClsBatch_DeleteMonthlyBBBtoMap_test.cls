/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
 /* changed the accounts name manually to control duplication
    2014-09-18 Harinath Chittala <harinath.chittala@te.com> */ 
    
@isTest(SeeAllData=true) 
private class ClsBatch_DeleteMonthlyBBBtoMap_test 
{
    static testMethod void testMonthlyBBBBatch1() 
    {
        // TO DO: implement unit test
        account a = clstesthelp.createTestAccounts();
        a.AccountNumber ='0000:10000000';
        a.WWCORPACCT__c ='00000200';
        a.BillingCountry='CN';
        //a.name ='Test Account One';
        a.Account_Manager__c = UserInfo.getUserId();
        a.OwnerId = UserInfo.getUserId();
        
        insert a;

        account b = clstesthelp.createTestAccounts();
        b.AccountNumber ='0000:40000000';
        b.WWCORPACCT__c ='00000500';
        b.BillingCountry='CN';
        //b.name ='Test Account Two';
        b.Account_Manager__c = UserInfo.getUserId();
        b.OwnerId = UserInfo.getUserId();
        
        insert b;
                
        // GPL or Product Hierarchy Record
        Product_Hierarchy__c prodH = new Product_Hierarchy__c();
        prodH.Name = 'A00';
        prodH.CBC1__c = '99999';
        prodH.CBC1_Description__c = 'Test Produce Hierarchy';
        insert prodH;
                
        // Part Records
        Part__c part1 = new Part__c();
        part1.Name = '0123456879';
        part1.Product_Hierarchy__c = prodH.id;
        insert part1;
        Part__c part2 = new Part__c();
        part2.Name = '9-9999999-9';
        part2.Product_Hierarchy__c = prodH.id;
        insert part2;
        
        ClsOEMUtil.CurrentFM = 5;
        ClsOEMUtil.CurrentFY = '2014'; 
        /*       
        if(ClsOEMUtil.CurrentFM == null)
        {
            ClsOEMUtil.setCurrentFiscalDateValues();
        }*/
        string FiscalMonth = string.valueOf(ClsOEMUtil.CurrentFM).leftpad(2).replace(' ', '0');
        string FiscalYear = string.valueOf(Integer.valueOf(ClsOEMUtil.CurrentFY) - 1);        
        
        BBB_Month_Bill_Book_Cust_PN__c bbbs = new BBB_Month_Bill_Book_Cust_PN__c();               
        bbbs.Customer__c = a.id;
        bbbs.Customer__r = a;
        bbbs.Part__c = part1.id;
        bbbs.Part__r = part1;      
        bbbs.Bill_Amount_USD__c = 50;
        bbbs.Fiscal_Year__c = FiscalYear;
        bbbs.Fiscal_Month__c = Integer.valueOf(FiscalMonth);              
        insert bbbs;

        account OemAcct = clstesthelp.createTestAccounts();
        //OemAcct.name ='Test OEM Account';
        OemAcct.Account_Manager__c = UserInfo.getUserId();
        OemAcct.OwnerId = UserInfo.getUserId();         
        
        insert OemAcct;
        
        OEM_Details__c d = new OEM_Details__c();
        d.Fiscal_Month__c = FiscalMonth;
        d.Fiscal_Year__c = FiscalYear;
        d.Cutoff_Date__c = '15';
        d.OEM__c = OemAcct.id;
        d.OEM__r = OemAcct;
        
        insert d;
        
        list<OEM_Mapping_Rule__c> mapsToInsert = new list<OEM_Mapping_Rule__c>();
        
        OEM_Mapping_Rule__c m1 = new OEM_Mapping_Rule__c();               
        m1.Part_Number__c = part1.id;
        m1.Sold_To_Account_Code__c = '10000000';
        m1.Type__c = 'Customer+PN';               
        m1.Allocation__c = 100;
        m1.Fiscal_Month__c = FiscalMonth;
        m1.Fiscal_Year__c = FiscalYear;
        m1.OEM__c = d.id;
        m1.OEM__r = d;           

        
        insert m1;
        
        CSD_OEM_Mapping_Monthly_BBB__c c = new CSD_OEM_Mapping_Monthly_BBB__c();
        c.OEM_Mapping__c = m1.Id;
        c.Monthly_Billings_Bookings_by_Part__c = bbbs.id;
        insert c;
        
        Test.startTest();
        
        ClsBatch_DeleteMonthlyBBBtoMappingRecord oemMBBB = new ClsBatch_DeleteMonthlyBBBtoMappingRecord();
        
        Database.executeBatch(oemMBBB);
        
        Test.stopTest();
 
    }
    static testMethod void testMonthlyBBBBatch2() 
    {
        // TO DO: implement unit test
        account a = clstesthelp.createTestAccounts();
        a.AccountNumber ='0000:10000000';
        a.WWCORPACCT__c ='00000200';
        a.BillingCountry='CN';
        //a.name ='Test Account One';
        a.Account_Manager__c = UserInfo.getUserId();
        a.OwnerId = UserInfo.getUserId();
        
        insert a;

        account b = clstesthelp.createTestAccounts();
        b.AccountNumber ='0000:40000000';
        b.WWCORPACCT__c ='00000500';
        b.BillingCountry='CN';
        //b.name ='Test Account Two';
        b.Account_Manager__c = UserInfo.getUserId();
        b.OwnerId = UserInfo.getUserId();
        
        insert b;
                
        // GPL or Product Hierarchy Record
        Product_Hierarchy__c prodH = new Product_Hierarchy__c();
        prodH.Name = 'A00';
        prodH.CBC1__c = '99999';
        prodH.CBC1_Description__c = 'Test Produce Hierarchy';
        insert prodH;
                
        // Part Records
        Part__c part1 = new Part__c();
        part1.Name = '0123456879';
        part1.Product_Hierarchy__c = prodH.id;
        insert part1;
        Part__c part2 = new Part__c();
        part2.Name = '9-9999999-9';
        part2.Product_Hierarchy__c = prodH.id;
        insert part2;
        
        ClsOEMUtil.CurrentFM = 4;
        ClsOEMUtil.CurrentFY = '2014'; 
        /*       
        if(ClsOEMUtil.CurrentFM == null)
        {
            ClsOEMUtil.setCurrentFiscalDateValues();
        }*/
        string FiscalMonth = string.valueOf(ClsOEMUtil.CurrentFM).leftpad(2).replace(' ', '0');
        string FiscalYear = string.valueOf(Integer.valueOf(ClsOEMUtil.CurrentFY) - 1);        
        
        BBB_Month_Bill_Book_Cust_PN__c bbbs = new BBB_Month_Bill_Book_Cust_PN__c();               
        bbbs.Customer__c = a.id;
        bbbs.Customer__r = a;
        bbbs.Part__c = part1.id;
        bbbs.Part__r = part1;      
        bbbs.Bill_Amount_USD__c = 50;
        bbbs.Fiscal_Year__c = FiscalYear;
        bbbs.Fiscal_Month__c = Integer.valueOf(FiscalMonth);              
        insert bbbs;

        account OemAcct = clstesthelp.createTestAccounts();
        //OemAcct.name ='Test OEM Account';
        OemAcct.Account_Manager__c = UserInfo.getUserId();
        OemAcct.OwnerId = UserInfo.getUserId();         
        
        insert OemAcct;
        
        OEM_Details__c d = new OEM_Details__c();
        d.Fiscal_Month__c = FiscalMonth;
        d.Fiscal_Year__c = FiscalYear;
        d.Cutoff_Date__c = '15';
        d.OEM__c = OemAcct.id;
        d.OEM__r = OemAcct;
        
        insert d;
        
        list<OEM_Mapping_Rule__c> mapsToInsert = new list<OEM_Mapping_Rule__c>();
        
        OEM_Mapping_Rule__c m1 = new OEM_Mapping_Rule__c();               
        m1.Part_Number__c = part1.id;
        m1.Sold_To_Account_Code__c = '10000000';
        m1.Type__c = 'Customer+PN';               
        m1.Allocation__c = 100;
        m1.Fiscal_Month__c = FiscalMonth;
        m1.Fiscal_Year__c = FiscalYear;
        m1.OEM__c = d.id;
        m1.OEM__r = d;           

        
        insert m1;
        
        CSD_OEM_Mapping_Monthly_BBB__c c = new CSD_OEM_Mapping_Monthly_BBB__c();
        c.OEM_Mapping__c = m1.Id;
        c.Monthly_Billings_Bookings_by_Part__c = bbbs.id;
        insert c;
        
        Test.startTest();
        
        ClsBatch_DeleteMonthlyBBBtoMappingRecord oemMBBB = new ClsBatch_DeleteMonthlyBBBtoMappingRecord();
        
        Database.executeBatch(oemMBBB);
        
        Test.stopTest();
 
    }
    static testMethod void testMonthlyBBBBatch3() 
    {
        // TO DO: implement unit test
        account a = clstesthelp.createTestAccounts();
        a.AccountNumber ='0000:10000000';
        a.WWCORPACCT__c ='00000200';
        a.BillingCountry='CN';
        //a.name ='Test Account One';
        a.Account_Manager__c = UserInfo.getUserId();
        a.OwnerId = UserInfo.getUserId();
        
        insert a;

        account b = clstesthelp.createTestAccounts();
        b.AccountNumber ='0000:40000000';
        b.WWCORPACCT__c ='00000500';
        b.BillingCountry='CN';
        //b.name ='Test Account Two';
        b.Account_Manager__c = UserInfo.getUserId();
        b.OwnerId = UserInfo.getUserId();
        
        insert b;
                
        // GPL or Product Hierarchy Record
        Product_Hierarchy__c prodH = new Product_Hierarchy__c();
        prodH.Name = 'A00';
        prodH.CBC1__c = '99999';
        prodH.CBC1_Description__c = 'Test Produce Hierarchy';
        insert prodH;
                
        // Part Records
        Part__c part1 = new Part__c();
        part1.Name = '0123456879';
        part1.Product_Hierarchy__c = prodH.id;
        insert part1;
        Part__c part2 = new Part__c();
        part2.Name = '9-9999999-9';
        part2.Product_Hierarchy__c = prodH.id;
        insert part2;
        
        ClsOEMUtil.CurrentFM = 3;
        ClsOEMUtil.CurrentFY = '2014'; 
        /*       
        if(ClsOEMUtil.CurrentFM == null)
        {
            ClsOEMUtil.setCurrentFiscalDateValues();
        }*/
        string FiscalMonth = string.valueOf(ClsOEMUtil.CurrentFM).leftpad(2).replace(' ', '0');
        string FiscalYear = string.valueOf(Integer.valueOf(ClsOEMUtil.CurrentFY) - 1);        
        
        BBB_Month_Bill_Book_Cust_PN__c bbbs = new BBB_Month_Bill_Book_Cust_PN__c();               
        bbbs.Customer__c = a.id;
        bbbs.Customer__r = a;
        bbbs.Part__c = part1.id;
        bbbs.Part__r = part1;      
        bbbs.Bill_Amount_USD__c = 50;
        bbbs.Fiscal_Year__c = FiscalYear;
        bbbs.Fiscal_Month__c = Integer.valueOf(FiscalMonth);              
        insert bbbs;

        account OemAcct = clstesthelp.createTestAccounts();
        //OemAcct.name ='Test OEM Account';
        OemAcct.Account_Manager__c = UserInfo.getUserId();
        OemAcct.OwnerId = UserInfo.getUserId();         
        
        insert OemAcct;
        
        OEM_Details__c d = new OEM_Details__c();
        d.Fiscal_Month__c = FiscalMonth;
        d.Fiscal_Year__c = FiscalYear;
        d.Cutoff_Date__c = '15';
        d.OEM__c = OemAcct.id;
        d.OEM__r = OemAcct;
        
        insert d;
        
        list<OEM_Mapping_Rule__c> mapsToInsert = new list<OEM_Mapping_Rule__c>();
        
        OEM_Mapping_Rule__c m1 = new OEM_Mapping_Rule__c();               
        m1.Part_Number__c = part1.id;
        m1.Sold_To_Account_Code__c = '10000000';
        m1.Type__c = 'Customer+PN';               
        m1.Allocation__c = 100;
        m1.Fiscal_Month__c = FiscalMonth;
        m1.Fiscal_Year__c = FiscalYear;
        m1.OEM__c = d.id;
        m1.OEM__r = d;           

        
        insert m1;
        
        CSD_OEM_Mapping_Monthly_BBB__c c = new CSD_OEM_Mapping_Monthly_BBB__c();
        c.OEM_Mapping__c = m1.Id;
        c.Monthly_Billings_Bookings_by_Part__c = bbbs.id;
        insert c;
        
        Test.startTest();
        
        ClsBatch_DeleteMonthlyBBBtoMappingRecord oemMBBB = new ClsBatch_DeleteMonthlyBBBtoMappingRecord();
        
        Database.executeBatch(oemMBBB);
        
        Test.stopTest();
 
    }
}