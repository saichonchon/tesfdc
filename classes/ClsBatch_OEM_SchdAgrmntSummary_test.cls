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
@isTest(SeeAllData=true) 
private class ClsBatch_OEM_SchdAgrmntSummary_test {

    static testMethod void testSABatch1() {
        account a = clstesthelp.createTestAccounts();
        a.AccountNumber ='0000:00000000';
        a.WWCORPACCT__c ='00000000';
        a.BillingCountry='CN';
        a.name ='Test Account One';
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
        
        list<Scheduled_Agreements__c> sas = new list<Scheduled_Agreements__c>();
        
        for(Integer i=0;i < 10; i++)
        {
            Scheduled_Agreements__c temp = new Scheduled_Agreements__c();
            temp.Sold_To_Customer__c = a.id;
            temp.Sold_To_Customer__r = a;
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
            temp.Forecast_Amount_USD__c = i;
            temp.Fiscal_Year__c = FiscalYear;
            temp.Fiscal_Month__c = Integer.valueOf(FiscalMonth);
            
            sas.add(temp);
        }
        
        insert sas;
 
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
        
        Test.startTest();
        
        ClsOEMUtil.listOEMMapBatchInput = ClsOEMUtil.ValidateOEMMapRulesByType(mapsToInsert);
        
        ClsBatch_OEM_SchdAgrmntSummary oem = new ClsBatch_OEM_SchdAgrmntSummary(ClsOEMUtil.listOEMMapBatchInput, fiscalMonth, fiscalYear);
        ID batchprocessid = Database.executeBatch(oem);
        
        Test.stopTest();

        account resultA = [Select Id, Latest_SA__c from Account where Id =: OemAcct.id limit 1];
        list<OEM_Mapping_Rule__c> ResultMappings = [Select Id, Tech_Latest_SA__c from OEM_Mapping_Rule__c where OEM__c =: d.id and type__c = 'Customer+PN' order by part_number__r.Name asc];         
        
        //need to change Latest_SA__c on Account from text to number before uncommenting this assertion
        //system.assert(resultA.Latest_SA__c == 45, 'OEM account Scheduled Agreement value does not match expected output');
        
        //system.assert(ResultMappings[0].Tech_Latest_SA__c == 10,'OEM mapping Scheduled Agreement value does not match expected output');                
        //system.assert(ResultMappings[1].Tech_Latest_SA__c == 35,'OEM mapping Scheduled Agreement does not match expected output');                                      

    }
}