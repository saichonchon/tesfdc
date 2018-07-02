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
    2014-09-18 Harinath Chittala <harinath.chittala@te.com> 
    Modified the class to increase code coverage
    2015-07-31 Rajendra Shahane 84% */  
 
@isTest
private class ClsBatch_OEM_MonthlyBBBtoMapping_test {

    static testMethod void testCMBeforeCutoff() {
        
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getType_Priority();
        
        
        account a = clstesthelp.createTestAccounts();
        a.AccountNumber ='0000:00000000';
        a.WWCORPACCT__c ='00000000';
        a.BillingCountry='CN';
        a.Account_Manager__c = UserInfo.getUserId();
        a.OwnerId = UserInfo.getUserId();
        
        account OemAcct = clstesthelp.createTestAccounts();
        OemAcct.Name = 'NON OEM';
        OemAcct.Account_Manager__c = UserInfo.getUserId();
        OemAcct.OwnerId = UserInfo.getUserId();         
        
        insert new list<account>{a, OemAcct};

        Product_Hierarchy__c prodH = new Product_Hierarchy__c(Name = 'A00', CBC1__c = '99999', CBC1_Description__c = 'Test Produce Hierarchy');
        insert prodH;
                
        Part__c part1 = new Part__c(Name = '0123456879', Product_Hierarchy__c = prodH.id);        
        Part__c part2 = new Part__c(Name = '9-9999999-9', Product_Hierarchy__c = prodH.id);
        insert new list<Part__c > {part1, part2};
        
        if(ClsOEMUtil.CurrentFM == null)
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
            temp.Customer__c = a.id;
            temp.Customer__r = a;
            temp.Profit_Center__c = 'DND';
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
        
        OEM_Details__c dp = new OEM_Details__c(Fiscal_Month__c = PFiscalMonth, Fiscal_Year__c = PFiscalYear, Cutoff_Date__c = '15', OEM__c = OemAcct.id, OEM__r = OemAcct);
        OEM_Details__c dc = new OEM_Details__c(Fiscal_Month__c = FiscalMonth, Fiscal_Year__c = FiscalYear, Cutoff_Date__c = '15', OEM__c = OemAcct.id, OEM__r = OemAcct);
        
        insert new list<OEM_Details__c>{dp, dc};

        list<OEM_Mapping_Rule__c> mapsToInsert = new list<OEM_Mapping_Rule__c>();

        mapsToInsert.add(new OEM_Mapping_Rule__c(Part_Number__c = part1.id, Sold_To_Account_Code__c = '00000000', WWAC__c = '00000000', Type__c = 'Customer+PN'));
        mapsToInsert.add(new OEM_Mapping_Rule__c(Part_Number__c = part1.id, WWAC__c = '00000000', Type__c = 'WWAC+PN'));
        mapsToInsert.add(new OEM_Mapping_Rule__c(Part_Number__c = part1.id, Type__c = 'PN'));
        mapsToInsert.add(new OEM_Mapping_Rule__c(Sold_To_Account_Code__c = '00000000', WWAC__c = '00000000', Type__c = 'Customer', Allocation__c = 100));
        mapsToInsert.add(new OEM_Mapping_Rule__c(Sold_To_Account_Code__c = '00000000', WWAC__c = '00000000', Type__c = 'WWAC'));
        mapsToInsert.add(new OEM_Mapping_Rule__c(Part_Number__c = part2.id, Sold_To_Account_Code__c = '00000000', WWAC__c = '00000000', Type__c = 'Customer+PN'));                             
        mapsToInsert.add(new OEM_Mapping_Rule__c(Part_Number__c = part2.id, Type__c = 'PN'));

        for(OEM_Mapping_Rule__c m : mapsToInsert)
        {
            if(m.Type__c == 'WWAC') m.Allocation__c = 99;
            else m.Allocation__c = 100;
            m.Active__c = true;
            m.Fiscal_Month__c = FiscalMonth;
            m.Fiscal_Year__c = FiscalYear;
            m.OEM__c = dp.id;
            m.OEM__r = dp;
            
        }
        
        OEM_Mapping_Rule__c currentMap = new OEM_Mapping_Rule__c(Part_Number__c = part2.id, Type__c = 'PN', Allocation__c = 100, Active__c = false, Fiscal_Month__c = FiscalMonth, Fiscal_Year__c = FiscalYear, OEM__c = dc.id, WWAC__c = '12345', OEM__r = dc);
        mapsToInsert.add(currentMap);        
        
        insert mapsToInsert;
        
       
        Test.startTest();
        ClsBatch_OEM_MonthlyBBBtoMapping oemMBBB = new ClsBatch_OEM_MonthlyBBBtoMapping(string.valueOf(FiscalMonth).leftpad(2).replace(' ', '0'), FiscalYear);
        Database.executeBatch(oemMBBB);
        
        Test.stopTest();
    }   
    
}