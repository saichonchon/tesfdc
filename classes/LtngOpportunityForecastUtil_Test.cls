/**
*   This test class is for LtngOpportunityForecastUtil.
*
@author Minghao Li
@created 2017-05-11
@version 1.0
@since 20.0
*
@changelog
* 2017-05-11 Minghao Li <minghao.li@capgemini.com>
* - Created
* - Test coverage 83%
*/
@isTest
private class LtngOpportunityForecastUtil_Test {

    static testMethod void myUnitTest() {
        list<Opportunity> list_oppys = new list<Opportunity>();
        list<Forecast_History__c> list_forecastHistorys = new list<Forecast_History__c>();
        
        User tempUser = [select id from user where GIBU__c = 'Industrial' and Sub_Vertical__c = 'A&C' and isactive = true and PMV_Type_Initialization__c = 'Standard' limit 1];
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        //ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
        ClsTestCustomSettingHelper.getPMV_Language_Config();
        ClsTestCustomSettingHelper.getPMV_Sales_Stage_Setting();
        ClsTestCustomSettingHelper.getPMV_Stage_Config();
        ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
        
        list<Group> list_pgs = [select Name from Group where id in (select GroupId from GroupMember where userorgroupid = :UserInfo.getUserId())];
        
        ADMTerritoryCode__c ADMTerritoryCode = new ADMTerritoryCode__c(Name='ADMTerritoryCode', Territory_Code__c='101485');
        insert ADMTerritoryCode;
        
        RecordType rt = ClsTestHelp.createTestRecordType6();
        RecordType rt2 = ClsTestHelp.createTestRecordType16();
        RecordType rt3 = ClsTestHelp.createTestRecordType23();

        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt.Id;
        acc.Account_Manager__c = UserInfo.getUserId();
        insert acc;
        
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        oppy2.Type = 'CM';
        oppy2.Request_Type__c = 'Extension';
        oppy2.RecordTypeId = rt3.Id;
        oppy2.accountid = acc.Id;
        list_oppys.add(oppy2);
       
        insert list_oppys;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        insert ph;
        
          
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        list<Opportunity_Part__c> lst_OP = new list<Opportunity_Part__c>();
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy2.Id;
        oppypart.Part__c = part.Id;
        oppypart.Status__c = 'Commit';
        oppypart.Lost_Reason__c = 'Other';
        oppypart.Lost_Reason_Text__c = null;
        oppypart.GPL__c = ph.Id;
        oppypart.Initial_Order_Date__c = date.today();
        lst_OP.add(oppypart);
        
        Opportunity_Part__c oppypart2 = ClsTestHelp.createTestOpportunityPart();
        oppypart2.Opportunity__c = oppy2.Id;
        oppypart2.Part__c = part.Id;
        oppypart2.Status__c = 'Commit';
        oppypart2.Lost_Reason__c = 'Other';
        oppypart2.Lost_Reason_Text__c = null;
        oppypart2.GPL__c = ph.Id;
        oppypart2.Initial_Order_Date__c = date.today();
        lst_OP.add(oppypart2);
        
        Opportunity_Part__c oppypart3 = ClsTestHelp.createTestOpportunityPart();
        oppypart3.Opportunity__c = oppy2.Id;
        oppypart3.Part__c = part.Id;
        oppypart3.Status__c = 'Commit';
        oppypart3.Lost_Reason__c = 'Other';
        oppypart3.Lost_Reason_Text__c = null;
        oppypart3.GPL__c = ph.Id;
        oppypart3.Initial_Order_Date__c = date.today();
        lst_OP.add(oppypart3);
       
        insert lst_OP;
        
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast.Opportunity__c = oppy2.Id;
        oppyForecast.Quantity__c = 12;
        oppyForecast.Part__c = oppypart.Id;
        oppyForecast.Date__c = date.newInstance(2013, 09, 28);
        oppyForecast.Amount__c = 1;
        oppyForecast.Sales_Price__c = 1;
        oppyForecast.Fiscal_Year__c = '2013';
        oppyForecast.Fiscal_Quarter__c = '21';
        oppyForecast.CurrencyIsoCode = 'USD';
        insert oppyForecast; 
        
        Forecast_History__c  forecastHistory = new Forecast_History__c();
        forecastHistory.Part__c = oppypart.Id;
        forecastHistory.Fiscal_Year__c = '2013';
        forecastHistory.Old_Value__c = 2000;
        forecastHistory.New_Value__c = 1800;
        forecastHistory.Opportunity__c = oppy2.Id;        
        //insert forecastHistory;
        list_forecastHistorys.add(forecastHistory);
        
        Forecast_History__c  forecastHistory1 = new Forecast_History__c();
        forecastHistory1.Part__c = oppypart.Id;
        forecastHistory1.Fiscal_Year__c = '2013';
        forecastHistory1.Old_Value__c = 2000;
        forecastHistory1.New_Value__c = 1800;
        forecastHistory1.Opportunity__c = oppy2.Id;        
        //insert forecastHistory1;
        list_forecastHistorys.add(forecastHistory1);

        
        Forecast_History__c  forecastHistory2 = new Forecast_History__c();
        forecastHistory2.Part__c = oppypart2.Id;
        forecastHistory2.Fiscal_Year__c = '2014';
        forecastHistory2.Old_Value__c = 1800;
        forecastHistory2.New_Value__c = 1800;
        forecastHistory2.Opportunity__c = oppy2.Id;        
        list_forecastHistorys.add(forecastHistory2);
        
        
        insert list_forecastHistorys;
        
        Test.startTest();
        Opportunity oppy3 = ClsTestHelp.createTestOpportunity();
        oppy3.Program_level_Forecasting__c =true; 
        oppy3.Name = 'Pain of Queen';
        oppy3.Type = 'CM';
        oppy3.Request_Type__c = 'Extension';
        oppy3.RecordTypeId = rt3.Id;
        oppy3.accountid = acc.Id;
        insert oppy3;
        
        
        Opportunity_Part__c oppypart1 = ClsTestHelp.createTestOpportunityPart();
        oppypart1.Opportunity__c = oppy3.Id;
        oppypart1.Part__c = part.Id;
        oppypart1.Status__c = 'Commit';
        oppypart1.Lost_Reason__c = 'Other';
        oppypart1.Lost_Reason_Text__c = null;
        oppypart1.GPL__c = ph.Id;
        oppypart1.Initial_Order_Date__c = date.today();
        insert oppypart1;
        
        map<String, String> map_partId_partNumber = new map<String, String>();
        map_partId_partNumber.put(oppypart1.Id, 'tets');
        
        list<Forecast_History__c> list_forecast2Upsert = new list<Forecast_History__c>();
        list_forecast2Upsert.add(forecastHistory);
        
        list<Forecast_History__c> list_forecast2Delete = new list<Forecast_History__c>();
        list_forecast2Delete.add(forecastHistory1);
        
        map<String, String> map_partId_partDescription = new map<String, String>();
        map_partId_partDescription.put(oppypart.id, 'test description');
        
        set<string> set_years = new set<string>();
        set_years.add('2013');
        set_years.add('2014');
        
        set<String> set_partIds = new set<String>();
        set_partIds.add(oppypart.Id);
        set_partIds.add(oppypart1.Id);
        
        
        //Test.startTest();
        
        LtngOpportunityForecastUtil.isAppOrIndBu('Appliances');
        LtngOpportunityForecastUtil.applianceOpptyRecordTypeId();
        
        LtngOpportunityForecastUtil.transformIsoCode(123, 'USD', 'USD');
        
        LtngOpportunityForecastUtil.forecastHistoryInfos fhi= new LtngOpportunityForecastUtil.forecastHistoryInfos('2', new map<String, String>());
        LtngOpportunityForecastUtil.getOpportunityById(oppy2.Id);
        
        String str_mapPartId_listForecastHistoryStructure = LtngOpportunityForecastUtil.getOppyForecastHistory(oppy2.Id);
        LtngOpportunityForecastUtil.saveOppForecastHitory(str_mapPartId_listForecastHistoryStructure,oppy2,'test');
        
        
        map<String, map<String, LtngOpportunityForecastUtil.ForecastHistoryStructure>> map_partId_map_fiscalYear_historyNew = new map<String,map<String, LtngOpportunityForecastUtil.ForecastHistoryStructure>>();
        map<String, LtngOpportunityForecastUtil.ForecastHistoryStructure> map_fhs = new map<String, LtngOpportunityForecastUtil.ForecastHistoryStructure>();
        map_fhs.put('2014', new LtngOpportunityForecastUtil.ForecastHistoryStructure('2014', 12, 3222));
        map_partId_map_fiscalYear_historyNew.put(oppypart.Id, map_fhs);
        
        decimal threshold = 29;
        String bu = '', selectedReason = '';
        
        LtngOpportunityForecastUtil.getMapOppForecast(set_years, set_partIds);
        
        
        LtngOpportunityForecastUtil.updateForecastHistory(map_partId_map_fiscalYear_historyNew, oppy2, bu, threshold, selectedReason);
        
        map_fhs.clear();
        map_partId_map_fiscalYear_historyNew.clear();
        map_fhs.put('2018', new LtngOpportunityForecastUtil.ForecastHistoryStructure('2018', 12, 3222));
        map_partId_map_fiscalYear_historyNew.put(oppypart2.Id, map_fhs);
        
        LtngOpportunityForecastUtil.updateForecastHistory(map_partId_map_fiscalYear_historyNew, oppy2, bu, threshold, selectedReason);
        
        map_fhs.put('2014', new LtngOpportunityForecastUtil.ForecastHistoryStructure('2014', 12, 12));
        map_fhs.put('2015', new LtngOpportunityForecastUtil.ForecastHistoryStructure('2015', 21, 21));
        map_partId_map_fiscalYear_historyNew.put(oppypart3.Id, map_fhs);
        LtngOpportunityForecastUtil.updateForecastHistory(map_partId_map_fiscalYear_historyNew, oppy2, bu, threshold, selectedReason);
        
        map<String,list<LtngOpportunityForecastUtil.ForecastHistoryStructure>> map_partId_list_ForecastHistoryStructure = (map<String,list<LtngOpportunityForecastUtil.ForecastHistoryStructure>>) JSON.deserializeStrict(str_mapPartId_listForecastHistoryStructure, map<String,list<LtngOpportunityForecastUtil.ForecastHistoryStructure>>.class);
        
        LtngOpportunityForecastUtil.checkUpdateForecastHistory(map_partId_list_ForecastHistoryStructure, map_partId_map_fiscalYear_historyNew, oppy2, selectedReason, bu);
        
        String partId = (part.Id+'');
        String oppyId = (oppy2.Id+'');
        
        
        LtngOpportunityForecastUtil.ForecastHistoryStructure fhs = new LtngOpportunityForecastUtil.ForecastHistoryStructure('2014', 12, 3222);
        list<Forecast_History__c> list_forecast2Notify = new list<Forecast_History__c>(); 
        
        LtngOpportunityForecastUtil.copyHistoryData(fhs, forecastHistory, partId, oppyId, list_forecast2Upsert,  list_forecast2Notify, map_partId_partNumber, threshold, set_years, set_partIds);
        
        
        LtngOpportunityForecastUtil.getPartForecastHistory(oppy2.Id);
        
        LtngOpportunityForecastUtil.sentForecastApprovalNotification(list_forecast2Upsert,oppy2,list_forecast2Delete, map_partId_partNumber, map_partId_partDescription, 'Quantity Changes');
        
        list<String> list_userEmail = new list<String>{'test@aa.com'};
        LtngOpportunityForecastUtil.generateUpsertHistoryTable(list_userEmail, list_forecast2Upsert, oppy2,list_forecast2Delete, map_partId_partNumber, map_partId_partDescription, 'Quantity Changes');
        
        list_forecast2Upsert.clear();
        LtngOpportunityForecastUtil.generateUpsertHistoryTable(list_userEmail, list_forecast2Upsert, oppy2,list_forecast2Delete, map_partId_partNumber, map_partId_partDescription, 'Quantity Changes');
        
        LtngOpportunityForecastUtil.getSendUserEmail(oppy2.Id);
        LtngOpportunityForecastUtil.getBU(oppy2);
        
        
        Profile profile = LtngOpportunityForecastUtil.getUserProfile(UserInfo.getProfileId());
        
        for(Opportunity o : [Select Id, RecordType.DeveloperName From Opportunity where Id =: oppy2.Id]){
            oppy2 = o;
        }
        
        profile.Name = 'Industrial Engineering User w/Cost';
        oppy2.RecordType.DeveloperName = 'IND_Engineering_project';
        LtngOpportunityForecastUtil.checkIND(profile, oppy2);
        
        profile.Name = 'Appliance User w/ Cost';
        oppy2.RecordType.DeveloperName = 'Opportunity_Engineering_Project';
        LtngOpportunityForecastUtil.checkOpportunityCompetitor(profile, oppy2);
        
        
        profile.Name = 'Appliance User w/ Cost';
        oppy2.RecordType.DeveloperName = 'Opportunity_Engineering_Project';
        LtngOpportunityForecastUtil.checkOpportunityContactRole(profile, oppy2);
        
        
        profile.Name = 'Medical Standard User';
        oppy2.RecordType.DeveloperName = 'Opportunity_Engineering_Project';
        LtngOpportunityForecastUtil.checkOpportunityContactRole(profile, oppy2);
        
        
        
        profile.Name = 'DND Engineering User w/Cost';
        oppy2.RecordType.DeveloperName = 'DND_Opportunity';
        LtngOpportunityForecastUtil.checkOpportunityContactRole(profile, oppy2);
        
        
        
        profile.Name = 'ADM Standard User';
        oppy2.RecordType.DeveloperName = 'ADM';
        LtngOpportunityForecastUtil.checkOpportunityContactRole(profile, oppy2);
        
        
        
        profile.Name = 'Channel Distributor Portal Manager';
        oppy2.RecordType.DeveloperName = 'Channel_Engineering_Opportunity';
        LtngOpportunityForecastUtil.checkOpportunityContactRole(profile, oppy2);
        
        
        
        profile.Name = 'ADM Standard User';
        oppy2.RecordType.DeveloperName = 'ADM';
        LtngOpportunityForecastUtil.checkADM(true, profile, oppy2);
        
        
        
        system.assert(true);
        Test.stopTest();
    }
}