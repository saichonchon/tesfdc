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
*/
@isTest(seeAllData=false)
private class ClsOppyPartUtil_Test { 

    static testMethod void testMostMethods() {
    
        ClsTestCustomSettingHelper.getAllSettings();
        ClsTestCustomSettingHelper.getPMV_Sales_Stage_Setting();
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getChannel_Oppty_Header_Level_Change();  
        Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;      
        //ClsTestCustomSettingHelper.getProfitBUCenterMapping();
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
        //RecordType rt = ClsTestHelp.createTestRecordType();
        //RecordType rt2 = ClsTestHelp.createTestRecordType15();
        //Id rt2Id = ClsTestHelp.createTestRecordType15();
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        acc.AccountNumber = 'test';
        acc.Industry_Code_Description__c = 'Rail';
        acc.INDUSTRY_BUSINESS_CDE__c = '115';        

        
        Account acc1 = ClsTestHelp.createTestAccounts();
        acc1.Type = 'TE Dummy Account';
        acc1.Name = 'Test Account11';
        acc1.AccountNumber = 'test11';
        acc1.Industry_Code_Description__c = 'Rail'; 
        acc1.INDUSTRY_BUSINESS_CDE__c = '113';       
        insert new list<Account>{acc, acc1};

        //Id tender_rt_id = ClsOppyPartUtil.TenderOpportunityRecordTypeId();
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        
        oppy2.Name = 'Pain of Queen';
        oppy2.Type = 'CM';
        oppy2.Request_Type__c = 'Extension';
        oppy2.RecordTypeId = Apex_Helper_Settings__c.getInstance('Tender Opportunity Record Type Id').Value__c;
        oppy2.Defined_GPLs__c = 'asdf\\|adfa';    
        oppy2.AccountId = acc1.Id;    
        oppy2.StageName = 'concept';
      
        //insert oppy2;
        //oppy2.POS_Customer_is_same_as_Account__c = true;
        
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
        oppy.AccountId = acc.Id;
        oppy.Distributor__c = 'Future';
        oppy.RecordTypeId = Apex_Helper_Settings__c.getInstance('Tender Opportunity Record Type Id').Value__c;
        oppy.stagename = 'concept';
       // insert oppy;
        //oppy.POS_Customer_is_same_as_Account__c = true;
        insert new list<opportunity>{oppy2, oppy};
          
        oppy2.Name = 'Pain of Queen1';
        oppy2.accountid = acc.Id;
       // update oppy2;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        ph.CBC5__c = '30044';

        
        Product_Hierarchy__c ph1 = new Product_Hierarchy__c();
        ph1.Hierarchy_Level_Type__c = 'CBC1';
        ph1.Description__c = 'Industrial';
        ph1.CBC5__c = '10600';
        insert new list<Product_Hierarchy__c>{ph, ph1};
        
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
       // insert part;
        
        Part__c part1 = new Part__c();
        part1.Description__c = 'SniperTest';
        part1.Product_Hierarchy__c = ph1.Id;
        //insert part1;
        insert new List<Part__c>{part,  part1};
        
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
        //oppypart.CBC5_Code__c = '10600';
        /*Opportunity_Part__c oppypart3 = ClsTestHelp.createTestOpportunityPart();
        oppypart3.Opportunity__c = oppy.Id;
        oppypart3.Part__c = part.Id;
        oppypart3.Status__c = 'Likely';
        oppypart3.Lost_Reason__c = 'Other';
        oppypart3.Lost_Reason_Text__c = null;
        oppypart3.GPL__c = ph.Id;       
        oppypart3.BU_profit_center__c = 'Appliances';
        oppypart3.SAP_Profit_Center_Short_Desc_Filter__c = cdf.Id;*/
        ///insert ;
        
        Opportunity_Part__c oppypart1 = ClsTestHelp.createTestOpportunityPart();
        oppypart1.Opportunity__c = oppy2.Id;
        oppypart1.Part__c = part1.Id;
        oppypart1.Status__c = 'Won';
        oppypart1.Lost_Reason__c = 'Other';
        oppypart1.Lost_Reason_Text__c = null;
        oppypart1.Part_Number__c = '0-0000000-0';
        oppypart1.GPL__c = ph1.Id;       
        oppypart1.BU_profit_center__c = 'undefined'; 
        
        /*Opportunity_Part__c oppypart2 = ClsTestHelp.createTestOpportunityPart();
        oppypart2.Opportunity__c = oppy2.Id;
        oppypart2.recordtypeid = Apex_Helper_Settings__c.getInstance('NDR Opportunity').Value__c;
        oppypart2.Part__c = part1.Id;
        oppypart2.Status__c = 'Won';
        oppypart2.Lost_Reason__c = 'Other';
        oppypart2.Lost_Reason_Text__c = null;
        oppypart2.Part_Number__c = '0-0000000-0';
        oppypart2.GPL__c = ph1.Id;       
        oppypart2.BU_profit_center__c = 'undefined';        */
        
        insert new list<Opportunity_Part__c> {oppypart, oppypart1};
        
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
        
        ClsOppyPartUtil.ProgramOpportunityRecordTypeId();
        //ClsOppyPartUtil.PopulateOpptyPartner('INSERT', map_oppId_accId_new, map_oppId_accId_old);
        //ClsOppyPartUtil.PopulateOpptyPartner('UPDATE', map_oppId_accId_new, map_oppId_accId_old);
        
        ClsOppyPartUtil.updateOppyDefinedGPLs(map_oppyId_gpls);
        ClsOppyPartUtil.validatePartManager(map_oppyId_parts, set_deletePartId);
        
        ClsOppyPartUtil.allocateBUProfitCenter(list_oppypart);
        ClsOppyPartUtil.TenderOpportunityRecordTypeId();
        ClsOppyPartUtil.UpdateTenderOpportunity(set_tendarOpportunityIds);
        
        /*****************/
        
        /*****************/        
        
        ClsOppyPartUtil.getOppyPartDefaultConfidenceAndProcessStatus(oppy.Id);
        ClsOppyPartUtil.getOpportunityById(oppy.Id);
        //ClsOppyPartUtil.updateNDROppyStage(new set<Id>{oppy3.id});
        
        ClsOppyPartUtil.updateOppyPartForOppyStage(new set<Id> {oppy.Id});
        
        ClsOppyPartUtil.updateOppyStageOnPartConfChange(new set<Id>{oppy.id});
        oppypart.Status__c = 'Lost';
        update oppypart;
        ClsOppyPartUtil.updateOppyStageOnPartConfChange(new set<Id>{oppy.id});

        oppypart.Status__c = 'Dead';
        update oppypart;
        ClsOppyPartUtil.updateOppyStageOnPartConfChange(new set<Id>{oppy.id});
        
        oppy.stagename = 'Lost - Closed';
        
        update oppy;
        oppypart.Status__c = 'On Hold';
        update oppypart;
        
        ClsOppyPartUtil.updateOppyPartForOppyStage(new set<Id> {oppy.Id});

        ClsOppyPartUtil.getOppyPhase(oppy, new list<Opportunity_Part__c> {oppypart});

        /***************/
        CSD_Opportunity_Record_Type__c CSDRecTypeObj = NEW CSD_Opportunity_Record_Type__c();
        CSDRecTypeObj.Name = 'Testing';        
        CSDRecTypeObj.Group__c = 'CSD';        
        insert CSDRecTypeObj;
        
        Profit_BU_Center_Mapping_Rule1__c profObj = NEW Profit_BU_Center_Mapping_Rule1__c();
        profObj.Name = 'Tester';
        insert profObj;
        
        ClsOppyPartUtil.getProfitBUCenterMapping();
        
        /***************/        
        
        ClsOppyPartUtil.getAllCSDOppyRecordType();
        ClsOppyPartUtil.map_ProfitRule2.put('10600', 'Enterprise Networks');
        ClsOppyPartUtil.allocateBUProfitCenter(new list<Opportunity_Part__c> {oppypart});
        Test.stopTest();  
        //}
    }
    static testMethod void testMostMethods2() {
    
        ClsTestCustomSettingHelper.getAllSettings();
        ClsTestCustomSettingHelper.getPMV_Sales_Stage_Setting();
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getChannel_Oppty_Header_Level_Change();

        Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;        
        
        //ClsTestCustomSettingHelper.getProfitBUCenterMapping();
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
        //RecordType rt = ClsTestHelp.createTestRecordType();
        //RecordType rt2 = ClsTestHelp.createTestRecordType15();
        //Id rt2Id = ClsTestHelp.createTestRecordType15();
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        acc.AccountNumber = 'test';
        acc.INDUSTRY_BUSINESS_CDE__c = '115';        

        
        Account acc1 = ClsTestHelp.createTestAccounts();
        acc1.Type = 'TE Dummy Account';
        acc1.Name = 'Test Account11';
        acc1.AccountNumber = 'test11';
        acc1.Industry_Code_Description__c = 'Rail'; 
        acc1.INDUSTRY_BUSINESS_CDE__c = '113';       
        insert new list<Account>{acc, acc1};
            
        //Id tender_rt_id = ClsOppyPartUtil.TenderOpportunityRecordTypeId();
        
        
        Opportunity oppy3 = ClsTestHelp.createTestOpportunity();
        oppy3.Program_level_Forecasting__c =true; 
        oppy3.Name = 'Pain of Queen';
        oppy3.Type = 'CM';
        oppy3.Request_Type__c = 'Extension';
        oppy3.RecordTypeId = Apex_Helper_Settings__c.getInstance('NDR Opportunity').Value__c;
        oppy3.Defined_GPLs__c = 'asdf\\|adfa';    
        oppy3.AccountId = acc1.Id;    
        oppy3.StageName = 'concept';
        insert oppy3;        
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        ph.CBC5__c = '30044';

        
        Product_Hierarchy__c ph1 = new Product_Hierarchy__c();
        ph1.Hierarchy_Level_Type__c = 'CBC1';
        ph1.Description__c = 'Industrial';
        ph1.CBC5__c = '12302';
        insert new list<Product_Hierarchy__c>{ph, ph1};
        
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;

        
        Part__c part1 = new Part__c();
        part1.Description__c = 'SniperTest';
        part1.Product_Hierarchy__c = ph1.Id;
        insert new List<Part__c>{part,  part1};
        
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
        oppypart.Opportunity__c = oppy3.Id;
        oppypart.Part__c = part.Id;
        oppypart.Status__c = 'Won';
        oppypart.Lost_Reason__c = 'Other';
        oppypart.Lost_Reason_Text__c = null;
        oppypart.GPL__c = ph.Id;       
        oppypart.BU_profit_center__c = 'Appliances';
        oppypart.SAP_Profit_Center_Short_Desc_Filter__c = cdf.Id;
        ///insert ;
        
        Opportunity_Part__c oppypart1 = ClsTestHelp.createTestOpportunityPart();
        oppypart1.Opportunity__c = oppy3.Id;
        oppypart1.Part__c = part1.Id;
        oppypart1.Status__c = 'Won';
        oppypart1.Lost_Reason__c = 'Other';
        oppypart1.Lost_Reason_Text__c = null;
        oppypart1.Part_Number__c = '0-0000000-0';
        oppypart1.GPL__c = ph1.Id;       
        oppypart1.BU_profit_center__c = 'undefined';        

        
        Opportunity_Part__c oppypart2 = ClsTestHelp.createTestOpportunityPart();
        oppypart2.Opportunity__c = oppy3.Id;
        //oppypart2.recordtypeid = Apex_Helper_Settings__c.getInstance('NDR Opportunity').Value__c;
        oppypart2.Part__c = part1.Id;
        oppypart2.Status__c = 'Weak';
        oppypart2.Lost_Reason__c = 'Other';
        oppypart2.Lost_Reason_Text__c = null;
        oppypart2.Part_Number__c = '0-0000000-0';
        oppypart2.GPL__c = ph1.Id;       
        oppypart2.BU_profit_center__c = 'undefined';
        
        insert new list<Opportunity_Part__c> {oppypart, oppypart1, oppypart2};
        
        map<Id,Id> map_oppId_accId_new = new map<Id,Id>();
        //map_oppId_accId_new.put(oppy.Id,acc.Id);
        
        map<Id,Id> map_oppId_accId_old = new map<Id,Id>();
        //map_oppId_accId_old.put(oppy.Id,acc.Id);
        
        map<Id, Id> map_oppyPartId_oppyId = new map<Id, Id>();
        //map_oppyPartId_oppyId.put(oppypart.Id,oppy.Id);
        
        map<Id, Opportunity_Part__c> map_oppyPartId_oppyPart = new map<Id, Opportunity_Part__c>();
        //map_oppyPartId_oppyPart.put(oppypart.Id,oppypart);
        
        list<Opportunity_Part__c> list_oppypart = new list<Opportunity_Part__c>();
        list_oppypart.add(oppypart);
        list_oppypart.add(oppypart1);
        map<Id, list<Opportunity_Part__c>> map_oppyId_parts = new map<Id, list<Opportunity_Part__c>>();
        //map_oppyId_parts.put(oppy.Id,list_oppypart);
        
        set<Id> set_deletePartId = new set<Id>();
        set_deletePartId.add(oppypart.Id);
        
        set<Id> set_tendarOpportunityIds = new set<Id>();
        //set_tendarOpportunityIds.add(oppy2.Id);
        
        set<String> set_gpl = new set<String>();
        set_gpl.add('asdf\\|adfa');
        map<Id, set<String>> map_oppyId_gpls = new map<Id, set<String>>();
        //map_oppyId_gpls.put(oppy.Id,set_gpl);
       
         
        Test.startTest();
        
        ClsOppyPartUtil.updateOppyPartForOppyStage(new set<Id>{oppy3.id});
        ClsOppyPartUtil.updateNDROppyStage(new set<Id>{oppy3.id});
        oppy3.StageName = 'Commit';
        ClsOppyPartUtil.updateOppyPartForOppyStage(new set<Id>{oppy3.id});
        Test.stopTest();  
        //}
    }
     static testMethod void testMostMethods3() {
    
        ClsTestCustomSettingHelper.getAllSettings();
        ClsTestCustomSettingHelper.getPMV_Sales_Stage_Setting();
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        
        Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;
              
        //system.runAs(u){ 
        //RecordType rt = ClsTestHelp.createTestRecordType();
        //RecordType rt2 = ClsTestHelp.createTestRecordType15();
        //Id rt2Id = ClsTestHelp.createTestRecordType15();
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        acc.AccountNumber = 'test';
        acc.INDUSTRY_BUSINESS_CDE__c = '115';        

        
        Account acc1 = ClsTestHelp.createTestAccounts();
        acc1.Type = 'TE Dummy Account';
        acc1.Name = 'Test Account11';
        acc1.AccountNumber = 'test11';
        acc1.Industry_Code_Description__c = 'Rail'; 
        acc1.INDUSTRY_BUSINESS_CDE__c = '113';       
        insert new list<Account>{acc, acc1};
            
        //Id tender_rt_id = ClsOppyPartUtil.TenderOpportunityRecordTypeId();
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        
        oppy2.Name = 'Pain of Queen';
        oppy2.Type = 'CM';
        oppy2.Request_Type__c = 'Extension';
        oppy2.RecordTypeId = Apex_Helper_Settings__c.getInstance('Tender Opportunity Record Type Id').Value__c;
        oppy2.Defined_GPLs__c = 'asdf\\|adfa';    
        oppy2.AccountId = acc1.Id;    
        oppy2.StageName = 'concept';
        oppy2.POS_Customer_is_same_as_Account__c = true;
        
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
        oppy.AccountId = acc.Id;
        oppy.Distributor__c = 'Future';
        oppy.RecordTypeId = Apex_Helper_Settings__c.getInstance('Tender Opportunity Record Type Id').Value__c;
        oppy.stagename = 'concept';
        oppy.POS_Customer_is_same_as_Account__c = true;
        insert new list<opportunity>{oppy2, oppy};
            
        oppy2.Name = 'Pain of Queen1';
        
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        ph.CBC5__c = '30044';

        
        Product_Hierarchy__c ph1 = new Product_Hierarchy__c();
        ph1.Hierarchy_Level_Type__c = 'CBC1';
        ph1.Description__c = 'Industrial';
        ph1.CBC5__c = '12302';
        insert new list<Product_Hierarchy__c>{ph, ph1};
        
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;

        
        Part__c part1 = new Part__c();
        part1.Description__c = 'SniperTest';
        part1.Product_Hierarchy__c = ph1.Id;
        insert new List<Part__c>{part,  part1};
        
         
        
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
        ///insert ;
        
        Opportunity_Part__c oppypart1 = ClsTestHelp.createTestOpportunityPart();
        oppypart1.Opportunity__c = oppy2.Id;
        oppypart1.Part__c = part1.Id;
        oppypart1.Status__c = 'Won';
        oppypart1.Lost_Reason__c = 'Other';
        oppypart1.Lost_Reason_Text__c = null;
        oppypart1.Part_Number__c = '0-0000000-0';
        oppypart1.GPL__c = ph1.Id;       
        oppypart1.BU_profit_center__c = 'undefined';        
        
        
      
        
        insert new list<Opportunity_Part__c> {oppypart, oppypart1};
        
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
        map<Id, set<String>> map_oppyId_gpls = new map<Id, set<String>>();
        map_oppyId_gpls.put(oppy.Id,set_gpl);
       
         
        Test.startTest();
        oppy2.accountid = acc.Id;
        update oppy2;
    
        /***************/
        
        Product_Hierarchy__c ph2 = new Product_Hierarchy__c();
        ph2.Hierarchy_Level_Type__c = 'CBC1';
        ph2.Description__c = 'Industrial';
        ph2.CBC5__c = '30044';

        Product_Hierarchy__c ph3 = new Product_Hierarchy__c();
        ph3.Hierarchy_Level_Type__c = 'CBC1';
        ph3.Description__c = 'Industrial';
        ph3.CBC5__c = '10600';
        insert new list<Product_Hierarchy__c>{ph2, ph3};        
    
        List<Part__c> oldpartList = new List<Part__c>();
        
        Part__c oldpart = NEW Part__c();
        oldpart.Description__c = 'Sniper2';
        oldpart.Product_Hierarchy__c = ph2.Id;
        oldpartList.add(oldpart);
        
        Part__c oldpart2 = NEW Part__c();
        oldpart2.Description__c = 'Sniper2';
        oldpart2.Product_Hierarchy__c = ph2.Id;
        oldpartList.add(oldpart2);        
        
        insert oldpartList;
        
        List<Part__c> newpartList = new List<Part__c>();
               
        Part__c newpart = NEW Part__c();
        newpart.Description__c = 'SniperTest';
        newpart.Product_Hierarchy__c = ph3.Id;
        newpartList.add(newpart);

        Part__c newpart2 = NEW Part__c();
        newpart2.Description__c = 'SniperTest';
        newpart2.Product_Hierarchy__c = ph3.Id;
        newpartList.add(newpart2);
        
        insert newpartList;
        
        Opportunity_Part__c oppypart2 = ClsTestHelp.createTestOpportunityPart();
        oppypart2.Opportunity__c = oppy.Id;
        oppypart2.Part__c = oldpart.Id;
        oppypart2.Status__c = 'Won';
        oppypart2.Lost_Reason__c = 'Other';
        oppypart2.Lost_Reason_Text__c = null;
        oppypart2.GPL__c = ph.Id;       
        oppypart2.BU_profit_center__c = 'Appliances';
        oppypart2.SAP_Profit_Center_Short_Desc_Filter__c = cdf.Id;

        Opportunity_Part__c oppypart3 = ClsTestHelp.createTestOpportunityPart();
        oppypart3.Opportunity__c = oppy2.Id;
        oppypart3.Part__c = newpart.Id;
        oppypart3.Status__c = 'Won';
        oppypart3.Lost_Reason__c = 'Other';
        oppypart3.Lost_Reason_Text__c = null;
        oppypart3.Part_Number__c = '0-0000000-0';
        oppypart3.GPL__c = ph1.Id;       
        oppypart3.BU_profit_center__c = 'undefined'; 
        
        insert new list<Opportunity_Part__c> {oppypart2, oppypart3};        
        
        ClsOppyPartUtil.updateGPL(oldpartList, newpartList);

        /********/
        //ClsOppyPartUtil.updateOppyPartForOppyStage(new set<Id> {oppy.Id});
        oppy2.StageName = 'Lost - Closed';
        update oppy2;
        
        oppy.StageName = 'Lost - Closed';        
        update oppy;
        ClsOppyPartUtil.updateOppyPartForOppyStage(new set<Id> {oppy2.Id});
        ClsOppyPartUtil.getOppyPhase(oppy, new list<Opportunity_Part__c>());
        /********/        

        Test.stopTest();  
        //}
    }
}