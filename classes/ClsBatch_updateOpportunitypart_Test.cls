//****************************************************************************************************************************
//   Name    : ClsBatch_updateOpportunitypart_Test
//   Purpose : Test class for batch that updates the BU Profit Center and SAP Profit Center lookup value.(ClsBatch_updateOpportunitypart)    
//   @Author Nooreen Shaikh
//   @created 09-02-2014             
//*****************************************************************************************************************************

@isTest(SeeAllData=false)
private class ClsBatch_updateOpportunitypart_Test {

    static testMethod void TestOppPartBatchBU() {  
        
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        //ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        ClsTestCustomSettingHelper.getAplRoutingProcess();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        
        /*Profit_BU_Center_Mapping_Rule1__c pb1 = Profit_BU_Center_Mapping_Rule1__c.getInstance('30183');
        Profit_BU_Center_Mapping_Rule2__c pb2 = Profit_BU_Center_Mapping_Rule2__c.getInstance('Account_IBC_code__c');
        Profit_BU_Center_Mapping_Rule3__c pb3 = Profit_BU_Center_Mapping_Rule3__c.getInstance('241');*/
    
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        acc.AccountNumber = 'test';
        acc.Account_Manager__c = userinfo.getUserId();
        acc.INDUSTRY_BUSINESS_CDE__c = '115';        
        //insert acc;
        
        Account acc1 = ClsTestHelp.createTestAccounts();
        acc1.Type = 'TE Dummy Account';
        acc1.Name = 'Test Account11';
        acc1.AccountNumber = 'test11';
        acc1.Account_Manager__c = userinfo.getUserId();
        acc1.Industry_Code_Description__c = 'Rail'; 
        acc1.INDUSTRY_BUSINESS_CDE__c = '113';       
        insert new List<Account>{acc, acc1};
  
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        oppy2.Type = 'CM';
        oppy2.Request_Type__c = 'Extension';
        //oppy2.RecordTypeId = rt2.Id;
        oppy2.Defined_GPLs__c = 'asdf\\|adfa';    
        oppy2.AccountId = acc1.Id;    
        //insert oppy2;  
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Defined_GPLs__c = 'asdf\\|adfa'; 
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        //oppy.Tender__c = oppy2.Id; 
        oppy.StageName = 'Lead';
        oppy.AccountId = acc.Id;
        oppy.Distributor__c = 'Future';
        insert new List<Opportunity>{oppy, oppy2};
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        ph.CBC5__c = '30044';
        insert ph;
        
        Product_Hierarchy__c ph1 = new Product_Hierarchy__c();
        ph1.Hierarchy_Level_Type__c = 'CBC1';
        ph1.Description__c = 'Industrial';
        ph1.CBC5__c = '12302';
        insert ph1;
        
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        Part__c part1 = new Part__c();
        part1.Description__c = 'SniperTest';
        part1.Product_Hierarchy__c = ph1.Id;
        insert part1;
  
        Cross_Dashboard_Filter__c cdf = new Cross_Dashboard_Filter__c();
        cdf.Filter_Value__c = 'Appliances';
        cdf.Type__c = 'SAP Profit Center Group Short Description';
        cdf.Name = 'Appliances';
        insert cdf;
        //OpportunityPartTriggerHandler.isRecursive = false;
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppypart.Part__c = part.Id;
        oppypart.Status__c = 'Won';
        oppypart.Lost_Reason__c = 'Other';
        oppypart.Lost_Reason_Text__c = null;
        oppypart.GPL__c = ph.Id;       
        oppypart.BU_profit_center__c = 'Appliances';
        oppypart.SAP_Profit_Center_Short_Desc_Filter__c = cdf.Id;
        
        
        Opportunity_Part__c oppypart1 = ClsTestHelp.createTestOpportunityPart();
        oppypart1.Opportunity__c = oppy2.Id;
        oppypart1.Part__c = part1.Id;
        oppypart1.Status__c = 'Won';
        oppypart1.Lost_Reason__c = 'Other';
        oppypart1.Lost_Reason_Text__c = null;
        oppypart1.Part_Number__c = '0-0000000-0';
        oppypart1.GPL__c = ph1.Id;       
        oppypart1.BU_profit_center__c = 'undefined';        
        insert new List<Opportunity_Part__c>{oppypart, oppypart1};
        
        List<Opportunity_Part__c> list_oppypart = new List<Opportunity_Part__c>();
        list_oppypart.add(oppypart);
        list_oppypart.add(oppypart1);
                      
        Test.startTest();
        
        ClsBatch_updateOpportunitypart clsBatchOp = new ClsBatch_updateOpportunitypart();
        Database.BatchableContext BC;
        database.executeBatch(clsBatchOp);
        
		ClsBatch_updateOpportunitypart clsBatchOp1 = new ClsBatch_updateOpportunitypart();
        Database.BatchableContext BC1;
        
        ClsBatch_updateOpportunitypart.filter = ' limit 1';        
        
        list_oppypart = new List<Opportunity_Part__c>();
        list_oppypart.add(new Opportunity_Part__c());
        clsBatchOp.execute(BC1,list_oppyPart);
       
        Test.stopTest();  
    }
}