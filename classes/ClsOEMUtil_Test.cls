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
private class ClsOEMUtil_Test {

    static testMethod void oemMapRulesByTypeTest() {
        account a = clstesthelp.createTestAccounts();
        a.AccountNumber ='0000:00000000'; 
        a.WWCORPACCT__c ='00000000';
        a.BillingCountry='CN';
        //a.name ='Test Account One';
        a.Account_Manager__c = UserInfo.getUserId();
        a.OwnerId = UserInfo.getUserId();
        
        insert a;
                
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
               
        if(ClsOEMUtil.CurrentFM == null)
        {
            ClsOEMUtil.setCurrentFiscalDateValues();
        }
        string FiscalMonth = string.valueOf(ClsOEMUtil.CurrentFM).leftpad(2).replace(' ', '0');
        string FiscalYear = string.valueOf(Integer.valueOf(ClsOEMUtil.CurrentFY) + 1);        
 
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
        
        OEM_Mapping_Rule__c m1p1 = new OEM_Mapping_Rule__c();               
        m1p1.Part_Number__c = part1.id;
        m1p1.Sold_To_Account_Code__c = '00000000';
        m1p1.WWAC__c = '00000000';
        m1p1.Type__c = 'Customer+PN';       
        mapsToInsert.add(m1p1);
        
        OEM_Mapping_Rule__c m2p1 = new OEM_Mapping_Rule__c();               
        m2p1.Part_Number__c = part1.id;
        m2p1.WWAC__c = '00000000';
        m2p1.Type__c = 'WWAC+PN';
        mapsToInsert.add(m2p1);     

        OEM_Mapping_Rule__c m3p1 = new OEM_Mapping_Rule__c();               
        m3p1.Part_Number__c = part1.id;
        m3p1.Type__c = 'PN';
        mapsToInsert.add(m3p1);
        
        OEM_Mapping_Rule__c m4p1 = new OEM_Mapping_Rule__c();               
        m4p1.Sold_To_Account_Code__c = '00000000';
        m4p1.WWAC__c = '00000000';
        m4p1.Type__c = 'Customer';
        mapsToInsert.add(m4p1);
        
        OEM_Mapping_Rule__c m5p1 = new OEM_Mapping_Rule__c();               
        m5p1.WWAC__c = '00000000';
        m5p1.Type__c = 'WWAC';
        mapsToInsert.add(m5p1);
        
        OEM_Mapping_Rule__c m1p2 = new OEM_Mapping_Rule__c();               
        m1p2.Part_Number__c = part2.id;
        m1p2.Sold_To_Account_Code__c = '00000000';
        m1p2.Type__c = 'Customer+PN';       
        mapsToInsert.add(m1p2);                             

        OEM_Mapping_Rule__c m2p2 = new OEM_Mapping_Rule__c();               
        m2p2.Part_Number__c = part2.id;
        m2p2.Type__c = 'PN';        
        mapsToInsert.add(m2p2);

        for(OEM_Mapping_Rule__c m : mapsToInsert)
        {
            m.Allocation__c = 100;
            m.Fiscal_Month__c = FiscalMonth;
            m.Fiscal_Year__c = FiscalYear;
            m.OEM__c = d.id;
            m.OEM__r = d;           
        }
        
        insert mapsToInsert;
                
        ClsOEMUtil.checkForActive = false;
        ClsOEMUtil.listOEMMapBatchInput = ClsOEMUtil.setOEMMapBatchInput(FiscalMonth, FiscalYear);
                
        //system.assert(ClsOEMUtil.listOEMMapBatchInput.size() == 2);
        
        list<OEM_Details__c> detailsToInsert = new list<OEM_Details__c>();
        detailsToInsert.add(d);        

        string nextMonth;
        string nextYear;
        
        if(FiscalMonth == '12')
        {
            nextMonth = '01';
            nextYear = string.valueOf(Integer.valueOf(FiscalYear) + 1);
        }
        else
        {
            nextMonth = string.valueOf(Integer.valueOf(FiscalMonth) + 1).leftpad(2).replace(' ', '0');
            nextYear = FiscalYear;
        }

        ClsOEMUtil.cloneOEMDetailsAndMaps(nextMonth, nextYear, detailsToInsert, ClsOEMUtil.listOEMMapBatchInput);

        list<OEM_Details__c> nextD = [Select Id from OEM_Details__c where fiscal_month__c =: nextMonth and fiscal_year__c =: nextYear and OEM__c =: d.OEM__c];
        
        list<OEM_Mapping_Rule__c> nextRules = [Select Id, Active__c from OEM_Mapping_Rule__c where fiscal_month__c =: nextMonth and fiscal_year__c =: nextYear and Active__c = false and OEM__c in: nextD];
        
        system.assert(nextD.size() > 0, 'Next month OEM Details not created');
        system.assert(nextRules.size() > 0, 'Next month OEM Mapping Rules not created correctly');               
    }
    
    static testMethod void oemMapRulesByValuesTest() {
        account a = clstesthelp.createTestAccounts();
        a.AccountNumber ='0000:00000000';
        a.WWCORPACCT__c ='00000000';
        a.BillingCountry='CN';
        //a.name ='Test Account One';
        a.Account_Manager__c = UserInfo.getUserId();
        a.OwnerId = UserInfo.getUserId();
        
        insert a;
                
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
               
        if(ClsOEMUtil.CurrentFM == null)
        {
            ClsOEMUtil.setCurrentFiscalDateValues();
        }
        string FiscalMonth = string.valueOf(ClsOEMUtil.CurrentFM).leftpad(2).replace(' ', '0');
        string FiscalYear = string.valueOf(Integer.valueOf(ClsOEMUtil.CurrentFY) + 1);        
 
        account OemAcct = clstesthelp.createTestAccounts();
        OemAcct.name ='Test OEM Account';
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
        
        OEM_Mapping_Rule__c m1p1 = new OEM_Mapping_Rule__c();               
        m1p1.Part_Number__c = part1.id;
        m1p1.Sold_To_Account_Code__c = '00000000';
        m1p1.WWAC__c = '00000000';
        m1p1.Type__c = 'Customer+PN';       
        mapsToInsert.add(m1p1);
        
        OEM_Mapping_Rule__c m2p1 = new OEM_Mapping_Rule__c();               
        m2p1.Part_Number__c = part1.id;
        m2p1.WWAC__c = '00000000';
        m2p1.Type__c = 'WWAC+PN';
        mapsToInsert.add(m2p1);     

        OEM_Mapping_Rule__c m3p1 = new OEM_Mapping_Rule__c();               
        m3p1.Part_Number__c = part1.id;
        m3p1.Type__c = 'PN';
        mapsToInsert.add(m3p1);
        
        OEM_Mapping_Rule__c m4p1 = new OEM_Mapping_Rule__c();               
        m4p1.Sold_To_Account_Code__c = '00000000';
        m4p1.WWAC__c = '00000000';
        m4p1.Type__c = 'Customer';
        mapsToInsert.add(m4p1);
        
        OEM_Mapping_Rule__c m5p1 = new OEM_Mapping_Rule__c();               
        m5p1.WWAC__c = '00000000';
        m5p1.Type__c = 'WWAC';
        mapsToInsert.add(m5p1);
        
        OEM_Mapping_Rule__c m1p2 = new OEM_Mapping_Rule__c();               
        m1p2.Part_Number__c = part2.id;
        m1p2.Sold_To_Account_Code__c = '00000000';
        m1p2.Type__c = 'Customer+PN';       
        mapsToInsert.add(m1p2);                             

        OEM_Mapping_Rule__c m2p2 = new OEM_Mapping_Rule__c();               
        m2p2.Part_Number__c = part2.id;
        m2p2.Type__c = 'PN';        
        mapsToInsert.add(m2p2);

        for(OEM_Mapping_Rule__c m : mapsToInsert)
        {
            m.Allocation__c = 100;
            m.Fiscal_Month__c = FiscalMonth;
            m.Fiscal_Year__c = FiscalYear;
            m.OEM__c = d.id;
            m.OEM__r = d;           
        }
        
        insert mapsToInsert;
        
        ClsOEMUtil.listOEMMapBatchInput = ClsOEMUtil.ValidateOEMMapRulesByValues(mapsToInsert);
        system.assert(ClsOEMUtil.listOEMMapBatchInput.size() == 5);
    }
    
    static testMethod void detectOverlappingMappingsTest() {
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
        
        ClsOEMUtil.setCurrentFiscalDateValues();
        string FiscalMonth = string.valueOf(ClsOEMUtil.CurrentFM).leftpad(2).replace(' ', '0');
        string FiscalYear = string.valueOf(Integer.valueOf(ClsOEMUtil.CurrentFY) + 1);
        string PFiscalMonth;
        string PFiscalYear;        
        
        if(FiscalMonth == '01')
        {
            PFiscalMonth = '12';
            PFiscalYear = ClsOEMUtil.CurrentFY;
        }
        else
        {
            PFiscalMonth = String.valueOf(Integer.valueOf(FiscalMonth) - 1).leftpad(2).replace(' ', '0');
            PFiscalYear = FiscalYear;
        }        
        
        list<BBB_Month_Bill_Book_Cust_PN__c> bbbs = new list<BBB_Month_Bill_Book_Cust_PN__c>();
                
        for(Integer i=0;i < 10; i++)
        {
            BBB_Month_Bill_Book_Cust_PN__c temp = new BBB_Month_Bill_Book_Cust_PN__c();
        if(math.mod(i,2) == 0)
        {   
                temp.Customer__c = a.id;
                temp.Customer__r = a;
        }
        else
        {   
                temp.Customer__c = b.id;
                temp.Customer__r = b;
        }
            if(i < 5)
            {
                temp.Part__c = part1.id;
                temp.Part__r = part1;
            }
            else
            {
                temp.Part__c = part2.id;
                temp.Part__r = part2;                                               
            }
            temp.Bill_Amount_USD__c = i;
            temp.Fiscal_Year__c = PFiscalYear;
            temp.Fiscal_Month__c = Integer.valueOf(PFiscalMonth);
            
            bbbs.add(temp);
        }
        
        insert bbbs;
 
        account OemAcct = clstesthelp.createTestAccounts();
        //OemAcct.name ='Test OEM Account';
        OemAcct.Account_Manager__c = UserInfo.getUserId();
        OemAcct.OwnerId = UserInfo.getUserId();         
        
        insert OemAcct;
        
        OEM_Details__c dp = new OEM_Details__c();
        dp.Fiscal_Month__c = PFiscalMonth;
        dp.Fiscal_Year__c = PFiscalYear;
        dp.Cutoff_Date__c = '15';
        dp.OEM__c = OemAcct.id;
        dp.OEM__r = OemAcct;
        
        OEM_Details__c dc = new OEM_Details__c();
        dc.Fiscal_Month__c = FiscalMonth;
        dc.Fiscal_Year__c = FiscalYear;
        dc.Cutoff_Date__c = '15';
        dc.OEM__c = OemAcct.id;
        dc.OEM__r = OemAcct;        
        
        insert dp;
        insert dc;
        
        list<OEM_Mapping_Rule__c> mapsToInsert = new list<OEM_Mapping_Rule__c>();
        
        OEM_Mapping_Rule__c m1 = new OEM_Mapping_Rule__c();               
        m1.Part_Number__c = part1.id;
        m1.Sold_To_Account_Code__c = '10000000';
        m1.Type__c = 'Customer+PN';       
        mapsToInsert.add(m1);

        OEM_Mapping_Rule__c m2 = new OEM_Mapping_Rule__c();               
        m2.Part_Number__c = part1.id;
        m2.Sold_To_Account_Code__c = '20000000';
        m2.Type__c = 'Customer+PN';       
        mapsToInsert.add(m2);
        
        OEM_Mapping_Rule__c m3 = new OEM_Mapping_Rule__c();               
        m3.Part_Number__c = part1.id;
        m3.WWAC__c = '00000100';
        m3.Type__c = 'WWAC+PN';
        mapsToInsert.add(m3);     

        OEM_Mapping_Rule__c m4 = new OEM_Mapping_Rule__c();               
        m4.Part_Number__c = part1.id;
        m4.WWAC__c = '00000200';
        m4.Type__c = 'WWAC+PN';
        mapsToInsert.add(m4);

        OEM_Mapping_Rule__c m5 = new OEM_Mapping_Rule__c();               
        m5.Part_Number__c = part1.id;
        m5.Type__c = 'PN';
        mapsToInsert.add(m5);

        OEM_Mapping_Rule__c m6 = new OEM_Mapping_Rule__c();               
        m6.Part_Number__c = part2.id;
        m6.Type__c = 'PN';
        mapsToInsert.add(m6);
        
        OEM_Mapping_Rule__c m7 = new OEM_Mapping_Rule__c();               
        m7.Sold_To_Account_Code__c = '30000000';
        m7.Type__c = 'Customer';
        mapsToInsert.add(m7);

        OEM_Mapping_Rule__c m8 = new OEM_Mapping_Rule__c();               
        m8.Sold_To_Account_Code__c = '40000000';
        m8.Type__c = 'Customer';
        mapsToInsert.add(m8);
        
        OEM_Mapping_Rule__c m9 = new OEM_Mapping_Rule__c();               
        m9.WWAC__c = '00000400';
        m9.Type__c = 'WWAC';
        mapsToInsert.add(m9);

        OEM_Mapping_Rule__c m10 = new OEM_Mapping_Rule__c();               
        m10.WWAC__c = '00000500';
        m10.Type__c = 'WWAC';
        mapsToInsert.add(m10);

        for(OEM_Mapping_Rule__c m : mapsToInsert)
        {
            m.Allocation__c = 100;
            m.Active__c = true;
            m.Fiscal_Month__c = PFiscalMonth;
            m.Fiscal_Year__c = PFiscalYear;
            m.OEM__c = dp.id;
            m.OEM__r = dp;           
        }
        
        OEM_Mapping_Rule__c priorMap = new OEM_Mapping_Rule__c();               
        priorMap.Part_Number__c = part2.id;
        priorMap.Type__c = 'PN';
        priorMap.Allocation__c = 100;
        priorMap.Active__c = true;
        priorMap.Fiscal_Month__c = PFiscalMonth;
        priorMap.Fiscal_Year__c = PFiscalYear;
        priorMap.OEM__c = dp.id;
        priorMap.OEM__r = dp;                    
        mapsToInsert.add(priorMap);       
        
        insert mapsToInsert;
        
        ClsOEMUtil.DetectOverlappingOEMMapRules(mapsToInsert);
    }                    
}