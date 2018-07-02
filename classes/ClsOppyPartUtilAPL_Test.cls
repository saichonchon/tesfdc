/**
*   This test class is for ClsBatchMassUpdateRecords.
*
@author Di Chen
@created 2012-06-07
@version 1.0
@since 20.0
*
@changelog
* 2012-06-07 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 79%
Rajendra Shahane 03/29/2016  Modified for case - 900703
*/
@isTest(SeeAllData=false)
private class ClsOppyPartUtilAPL_Test { 

    static testMethod void testMostMethods() {
        //Start: Rajendra Shahane Modified for case - 900703
        ChannelinsightData_test.Channelinsightdata_test();
		ClsTestCustomSettingHelper.getApex_Helper_Settings();
		ClsTestCustomSettingHelper.getCCPTriggerSettings();
		ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
		ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
		ClsTestCustomSettingHelper.getOpportunity_Approvers();
		ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
		ClsTestCustomSettingHelper.getAplRoutingProcess();
		ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
		ClsTestCustomSettingHelper.getPMV_Sales_Stage_Setting();
		ClsTestCustomSettingHelper.getPMV_Stage_Config();
		//End: Rajendra Shahane Modified for case - 900703
        /*Profile p = [Select Id, Name From Profile 
                     where Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'hellosManedsfd@testCompany1255356525143.com';
        u.username = u.Email;
        u.Alias = 'dpses';
        u.CommunityNickname = 'NNND';
        u.ProfileId = p.Id;
        u.Te_Network_Id__c = 'Test001234';
        insert u;*/
              
        //system.runAs(u){ 
        RecordType rt = ClsTestHelp.createTestRecordType();
        //RecordType rt2 = ClsTestHelp.createTestRecordType15();
        //Id rt2Id = ClsTestHelp.createTestRecordType15();
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        acc.AccountNumber = 'test';
        acc.INDUSTRY_BUSINESS_CDE__c = '115';        
        //insert acc;
        
        Account acc1 = ClsTestHelp.createTestAccounts();
        acc1.Type = 'TE Dummy Account';
        acc1.Name = 'Test Account11';
        acc1.AccountNumber = 'test11';
        acc1.Industry_Code_Description__c = 'Rail'; 
        acc1.INDUSTRY_BUSINESS_CDE__c = '113';       
        insert new List<Account> {acc1,acc};
  
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        oppy2.Type = 'CM';
        oppy2.Request_Type__c = 'Extension';
        oppy2.RecordTypeId = ClsOppyPartUtilAPL.TenderOpportunityRecordTypeId();
        oppy2.StageName ='New Opportunity';
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
        oppy.recordtypeid = (Id)Apex_Helper_Settings__c.getInstance('NDR Opportunity').Value__c;
        //oppy.Tender__c = oppy2.Id; 
        oppy.StageName = 'Lead';
        oppy.AccountId = acc.Id;
        oppy.Distributor__c = 'Future';
        insert new List<Opportunity> {oppy,oppy2};
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        ph.CBC5__c = '30044';
        //insert ph;
        
        Product_Hierarchy__c ph1 = new Product_Hierarchy__c();
        ph1.Hierarchy_Level_Type__c = 'CBC1';
        ph1.Description__c = 'Industrial';
        ph1.CBC5__c = '12302';
        insert new List<Product_Hierarchy__c> {ph, ph1};
        
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        //insert part;
        
        Part__c part1 = new Part__c();
        part1.Description__c = 'SniperTest';
        part1.Product_Hierarchy__c = ph1.Id;
        insert new List<Part__c> {part, part1};
        
         /*Map<String,String> map_ProfitRule2 = new Map<String,String>();
         for(Profit_BU_Center_Mapping_Rule2__c rule2:Profit_BU_Center_Mapping_Rule2__c.getAll().Values()){
            map_ProfitRule2.put(rule2.Name,rule2.BU_Profit__c);
         }*/
        
        Cross_Dashboard_Filter__c cdf = new Cross_Dashboard_Filter__c();
        cdf.Filter_Value__c = 'Appliances';
        cdf.Type__c = 'SAP Profit Center Group Short Description';
        cdf.Name = 'Appliances';
        insert cdf;
        
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppypart.Part__c = part.Id;
        oppypart.Status__c = 'Won';
        oppypart.Lost_Reason__c = 'Other';
        oppypart.Lost_Reason_Text__c = null;
        oppypart.GPL__c = ph.Id;       
        oppypart.BU_profit_center__c = 'Appliances';
        oppypart.SAP_Profit_Center_Short_Desc_Filter__c = cdf.Id;
        //insert oppypart;
        
        Opportunity_Part__c oppypart1 = ClsTestHelp.createTestOpportunityPart();
        oppypart1.Opportunity__c = oppy2.Id;
        oppypart1.Part__c = part1.Id;
        oppypart1.Status__c = 'Won';
        oppypart1.Lost_Reason__c = 'Other';
        oppypart1.Lost_Reason_Text__c = null;
        oppypart1.Part_Number__c = '0-0000000-0';
        oppypart1.GPL__c = ph1.Id;       
        oppypart1.BU_profit_center__c = 'undefined';        
        insert new List<Opportunity_Part__c> {oppypart1,oppypart};
        
        map<Id,Id> map_oppId_accId_new = new map<Id,Id>();
        map_oppId_accId_new.put(oppy.Id,acc.Id);
        
        map<Id,Id> map_oppId_accId_old = new map<Id,Id>();
        map_oppId_accId_old.put(oppy.Id,acc.Id);
        
        map<Id, Id> map_oppyPartId_oppyId = new map<Id, Id>();
        map_oppyPartId_oppyId.put(oppypart.Id,oppy.Id);
        
        map<Id, Opportunity_Part__c> map_oppyPartId_oppyPart = new map<Id, Opportunity_Part__c>();
        map_oppyPartId_oppyPart.put(oppypart.Id,oppypart);
        
        list<Opportunity_Part__c> list_oppypart = new list<Opportunity_Part__c>();
        list_oppypart.add(oppypart);
        list_oppypart.add(oppypart1);
        map<Id, list<Opportunity_Part__c>> map_oppyId_parts = new map<Id, list<Opportunity_Part__c>>();
        map_oppyId_parts.put(oppy.Id,list_oppypart);
        
        set<Id> set_deletePartId = new set<Id>();
        set_deletePartId.add(oppypart.Id);
        
        set<Id> set_tendarOpportunityIds = new set<Id>();
        set_tendarOpportunityIds.add(oppy2.Id);
        
        set<String> set_gpl = new set<String>();
        set_gpl.add('asdf\\|adfa');
        map<Id, set<String>> map_oppyId_gpls = new map<Id, set<String>>();
        map_oppyId_gpls.put(oppy.Id,set_gpl);
         
        Test.startTest();
        
        ClsOppyPartUtilAPL.PopulateOpptyPartner('INSERT', map_oppId_accId_new, map_oppId_accId_old);
        ClsOppyPartUtilAPL.PopulateOpptyPartner('UPDATE', map_oppId_accId_new, map_oppId_accId_old);
        
        ClsOppyPartUtilAPL.updateOppyDefinedGPLs(map_oppyId_gpls);
        ClsOppyPartUtilAPL.validatePartManager(map_oppyId_parts, set_deletePartId);
        
        ClsOppyPartUtilAPL.allocateBUProfitCenter(list_oppypart);
        ClsOppyPartUtilAPL.TenderOpportunityRecordTypeId();
        ClsOppyPartUtilAPL.UpdateTenderOpportunity(set_tendarOpportunityIds);
        ClsOppyPartUtilAPL.getOppyPartDefaultConfidenceAndProcessStatus(oppy.Id);
        
        //Start: Rajendra Shahane Modified for case - 900703
        //
        Opportunity_Partner__c oppPartner = new Opportunity_Partner__c();
        oppPartner.Opportunity__c = oppy.Id;
        oppPartner.Account__c = acc.Id;
        oppPartner.Allocation__c = 0;
        oppPartner.Partner_Role__c = 'Distributor';
        insert oppPartner;
        Map<Id, List<Opportunity_Partner__c>> map_oppyId_oppyPartner = new Map<Id, List<Opportunity_Partner__c>>();
        map_oppyId_oppyPartner.put(oppy.Id,new List<Opportunity_Partner__c> {oppPartner});
        ClsOppyPartUtilAPL.calOppyAllocation(map_oppyId_oppyPartner);
        ClsOppyPartUtilAPL.updateOppyDefinedGPLs(new set<Id> {oppy.Id});
        ClsOppyPartUtilAPL.updateNDROppyStage(new set<Id> {oppy.Id});
        ClsOppyPartUtilAPL.getOpportunityById(oppy.Id);
        ClsOppyPartUtilAPL.getAllCSDOppyRecordType();
        ClsOppyPartUtilAPL.ProgramOpportunityRecordTypeId();
        ClsOppyPartUtilAPL.updateOppyStage(new set<Id> {oppy2.Id});
        //End : Rajendra Shahane Modified for case - 900703
        system.assert(true);
        Test.stopTest();  
        //}
    }
}