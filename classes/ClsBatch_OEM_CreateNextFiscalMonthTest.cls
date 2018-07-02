/**
Name:  ClsBatch_OEM_CreateNextFiscalMonthTest
Copyright © 2014 TE Connectivity
===================================================================================================================================================
Purpose: This class contain Test Methods for ClsBatch_OEM_CreateNextFiscalMonthRule 
---------------------------------------------------------------------------------------------------------------------------------------------------       
Related APEX Class : ClsBatch_OEM_CreateNextFiscalMonthRule                                                              
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
Version Developer          Date       Detail                               Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Nelson Zheng   12/31/2014  Initial Development                                                       
***************************************************************************************************
 */
@isTest(SeeAllData=true)
private class ClsBatch_OEM_CreateNextFiscalMonthTest {

    static testMethod void myUnitTest() {
        
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
            temp.Customer__c = a.id;
            temp.Customer__r = a;
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
            temp.Fiscal_Year__c = FiscalYear;
            temp.Fiscal_Month__c = Integer.valueOf(FiscalMonth);
            
            bbbs.add(temp);
        }
        
        insert bbbs;
 
        account OemAcct = clstesthelp.createTestAccounts();
        //OemAcct.name ='OTHERS';
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
            m.Active__c = true;
            m.Fiscal_Month__c = PFiscalMonth;
            m.Fiscal_Year__c = PFiscalYear;
            m.OEM__c = dp.id;
            m.OEM__r = dp;           
        }
        
        OEM_Mapping_Rule__c currentMap = new OEM_Mapping_Rule__c();               
        currentMap.Part_Number__c = part2.id;
        currentMap.Type__c = 'PN';
        currentMap.Allocation__c = 100;
        currentMap.Active__c = false;
        currentMap.Fiscal_Month__c = FiscalMonth;
        currentMap.Fiscal_Year__c = FiscalYear;
        currentMap.OEM__c = dc.id;
        currentMap.OEM__r = dc;                    
        mapsToInsert.add(currentMap);        
        
        insert mapsToInsert;
        Test.startTest();
               
        ClsBatch_OEM_CreateNextFiscalMonthRule oemMBBB = new ClsBatch_OEM_CreateNextFiscalMonthRule(string.valueOf(FiscalMonth).leftpad(2).replace(' ', '0'), FiscalYear);
        
        //Period comparePeriod = [SELECT PeriodLabel, FiscalYearSettings.Name FROM Period where type = 'Month' and startdate <= today and enddate >= today];
          
        //oemMBBB.compareDate = ClsOEMUtil.CalculateCalendarDate(FiscalMonth, FiscalYear, '10');     
        //oemMBBB.compareDate = date.newinstance(Integer.valueOf(FiscalYear), Integer.valueOf(ClsOEMUtil.MAP_MONTHCALENDARNUMBER.get(comparePeriod.PeriodLabel)), 10);   
        Database.executeBatch(oemMBBB);
        
        Test.stopTest();
    }
}