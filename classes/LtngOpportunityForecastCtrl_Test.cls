/**
*  This test class is used to test APL_ClsAMService
*  
* @author Minghao Li
* @created 2017-05-08
* @version 1.0
* @since 38.0 (Force.com ApiVersion)  
* 
*
* @changelog
* 2017-05-08 Minghao Li <minghao.li@capgemini.com>
* - Created
* Test coverage 87%
*
*/
@isTest
private class LtngOpportunityForecastCtrl_Test {
    
    static testMethod void myUnitTest() {
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
        
        system.debug('Customsettings::insertsucceed'+Limits.getQueries());
        
        list<Group> list_pgs = [select Name from Group where id in (select GroupId from GroupMember where userorgroupid = :UserInfo.getUserId())];
        
        ADMTerritoryCode__c ADMTerritoryCode = new ADMTerritoryCode__c(Name='ADMTerritoryCode', Territory_Code__c='101485');
        insert ADMTerritoryCode;
        
        //Added by Buwen Guo 2018-06-04 to check the details.
        system.debug('ADMTerritoryCode::insertsucceed'+Limits.getQueries());
        
        RecordType rt = ClsTestHelp.createTestRecordType6();
        RecordType rt2 = ClsTestHelp.createTestRecordType16();
        RecordType rt3 = ClsTestHelp.createTestRecordType23();
        
        Account acc1 = ClsTestHelp.createTestAccounts();
        acc1.Industry_Code_Description__c='Appliances';
       // acc.recordtypeid= ClsTestHelp.createCSDTestRecordType7().Id;//ClsTestHelp.createProspectAccount().Id;
        acc1.SAP_Account_Number__c='1234';
        acc1.AccountNumber='0406:00127625';
        acc1.Active__c=true;
        //insert acc1;
        
        system.debug('acc1::insertsucceed'+Limits.getQueries());
        
        Account acc2 = ClsTestHelp.createTestAccounts();
        acc2.Industry_Code_Description__c='Appliances';
       // acc.recordtypeid= ClsTestHelp.createCSDTestRecordType7().Id;//ClsTestHelp.createProspectAccount().Id;
        acc2.SAP_Account_Number__c='1235';
        acc2.AccountNumber='0406:00127626';
        acc2.Active__c=true;
        //insert acc2;
        insert new list<Account>{acc1, acc2};
        
        system.debug('acc2::insertsucceed'+Limits.getQueries());
        
        //Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        //oppy2.PMV_Type__c = 'IND Standard Sales opp';
        oppy2.Name = 'Pain of Queen';
        oppy2.Type = 'CM';
        oppy2.CurrencyIsoCode = 'USD';
        oppy2.Request_Type__c = 'Extension';
        oppy2.RecordTypeId = rt3.Id;
        oppy2.accountid = acc2.Id;
        insert oppy2;
        
        system.debug('oppy2::insertsucceed'+Limits.getQueries());
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial'; 
        insert ph;
        
        system.debug('ph::insertsucceed'+Limits.getQueries());
        
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        system.debug('part::insertsucceed'+Limits.getQueries());
        
        Period p = [select FiscalYearSettingsId, FiscalYearSettings.Name, PeriodLabel, Number, StartDate, EndDate from Period 
                        where type = 'Year' and FiscalYearSettings.IsStandardYear = false 
                        and StartDate <= :system.today() and EndDate >= :system.today()
                        order by FiscalYearSettings.Name limit 1];
        
        String fiscalYear = p.FiscalYearSettings.Name;
        
        Test.startTest();/////////////////////////////////////////////////
        try {
            Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
            oppypart.Opportunity__c = oppy2.Id;
            oppypart.Part__c = part.Id;
            oppypart.Status__c = 'Commit';
            oppypart.Lost_Reason__c = 'Other';
            oppypart.Lost_Reason_Text__c = null;
            oppypart.GPL__c = ph.Id;
            oppypart.Initial_Order_Date__c = date.today();
            insert oppypart;
            
            system.debug('oppypart::insertsucceed'+Limits.getQueries());
            
            Date d = date.today();
            String month = d.month()+'';
            month = month.length() == 2 ? month : '0'+month;
            
            Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast.Opportunity__c = oppy2.Id;
            oppyForecast.Quantity__c = 12;
            oppyForecast.Part__c = oppypart.Id;
            oppyForecast.Date__c = date.today();
            oppyForecast.Sales_Price__c = 123;
            oppyForecast.Fiscal_Month__c = month;
            oppyForecast.Fiscal_Year__c = d.year()+'';
            oppyForecast.Amount__c = 1;
            //insert oppyForecast;
            
            Opportunity_Forecast__c oppyForecast2 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast2.Opportunity__c = oppy2.Id;
            oppyForecast2.Quantity__c = 12;
            oppyForecast2.Part__c = oppypart.Id;
            oppyForecast2.Date__c = date.today();
            oppyForecast2.Sales_Price__c = 123;
            oppyForecast2.Amount__c = 1;
            oppyForecast2.Fiscal_Month__c = month;
            oppyForecast2.Fiscal_Year__c = d.year()+'';
            
            Opportunity_Forecast__c oppyForecast3 = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast3.Opportunity__c = oppy2.Id;
            oppyForecast3.Quantity__c = 12;        
            oppyForecast3.Date__c = date.today();
            oppyForecast3.Fiscal_Month__c = month;
            oppyForecast3.Fiscal_Year__c = d.year()+'';
            oppyForecast3.Sales_Price__c = 123;
            oppyForecast3.Amount__c = 1;
            insert new list<Opportunity_Forecast__c>{oppyForecast, oppyForecast2, oppyForecast3};
                
            system.debug('oppyForecast3::insertsucceed'+Limits.getQueries());
            
            LtngOpportunityForecastCtrl.TPicklistEntry te = new LtngOpportunityForecastCtrl.TPicklistEntry();
            
            LtngOpportunityForecastCtrl.CustomParams cp = new LtngOpportunityForecastCtrl.CustomParams();
            cp.oppyId = oppy2.Id+'';
            String param = JSON.serialize(cp);
            
            LtngOpportunityForecastCtrl.CustomObject co = new LtngOpportunityForecastCtrl.CustomObject();
            //LtngOpportunityForecastCtrl.setAPLPickList(co, true);
            co.list_Confidence.add('Won');
            //LtngOpportunityForecastCtrl.getProcessStatusItems(co.list_Confidence, false);
            //LtngOpportunityForecastCtrl.getProcessStatusItems(co.list_Confidence, true);
            
            map<String, Decimal> map_partId_price = new map<String, Decimal>{oppypart.Id+'' => 123};
                map<String, list<Opportunity_Forecast__c>> map_ofc = new map<String, list<Opportunity_Forecast__c>>();
            map_ofc.put(d.year()+'', new list<Opportunity_Forecast__c>());
            co.map_partId_year_oppyForecast.put(oppypart.Id, map_ofc);
            cp.level = 'Yearly';
            LtngOpportunityForecastCtrl.setOppyForecast(oppypart.Id, d.year()+'', map_partId_price, cp, co);
            cp.level = 'Quarterly';
            LtngOpportunityForecastCtrl.setOppyForecast(oppypart.Id, d.year()+'', map_partId_price, cp, co);
            cp.level = 'Monthly';
            LtngOpportunityForecastCtrl.setOppyForecast(oppypart.Id, d.year()+'', map_partId_price, cp, co);
            
            set<string> status1 = new set<string>(); 
            set<string> status2 = new set<string>(); 
            set<string> Gstatus5 = new set<string>(new string[]{'Concept','Quoted','Designed','On Customer AVL'});
            set<string> Gstatus6 = new set<string>(new string[]{'Concept','Quoted','Designed','On Customer AVL','Pre-prod','Production'});
            set<string> set_processStatusValue = new set<string>();
            
            //LtngOpportunityForecastCtrl.setDNDPickList(status1, status2, Gstatus5, Gstatus6, set_processStatusValue, true, co);
            
            LtngOpportunityForecastCtrl.getPartList(param); //@AuraEnabled
            
            cp.list_PartIds = new list<String>{oppypart.Id+''};
                cp.level = oppy2.Level__c;
            for(Integer i = 0; i < 10; i++) {
                cp.list_Years.add(String.valueOf(Integer.valueOf(fiscalYear)+i));
            }
            param = JSON.serialize(cp);
            
            LtngOpportunityForecastCtrl.getForecastList(param); //@AuraEnabled
            
            LtngOpportunityForecastCtrl.SaveData sd = new LtngOpportunityForecastCtrl.SaveData();
            sd.list_Parts.add(oppypart);
            param = JSON.serialize(sd);
            
            LtngOpportunityForecastCtrl.saveParts(param);   //@AuraEnabled
            
            cp.competitorName = 'test';
            param = JSON.serialize(cp);
            LtngOpportunityForecastCtrl.searchCompetitor(param);    //@AuraEnabled
            
            
            sd.oppyId = oppy2.Id+'';
            for(Integer i = 0; i < 10; i++) {
                sd.list_fiscalYear.add(String.valueOf(Integer.valueOf(fiscalYear)+i));
            }
            
            param = JSON.serialize(sd);
            
            LtngOpportunityForecastCtrl.saveParts(param);   //@AuraEnabled
            
            sd.opportunity = oppy2;
            sd.opportunity.Level__c = 'Monthly';
            param = JSON.serialize(sd);
            
            LtngOpportunityForecastCtrl.saveOpportunity(param);     //@AuraEnabled
            
            
            sd.oppyId = oppy2.Id;
            param = JSON.serialize(sd);
            LtngOpportunityForecastCtrl.updateForecastHitory(param);    //@AuraEnabled
            
            
            Opportunity_Forecast__c of2 = ClsTestHelp.createTestOpportunityForecasts();
            of2.Opportunity__c = oppy2.Id;
            of2.Quantity__c = 12;
            of2.Part__c = oppypart.Id;
            of2.Date__c = date.today();
            of2.Sales_Price__c = 123;
            of2.Amount__c = 1;
            of2.Fiscal_Month__c = month;
            of2.Fiscal_Year__c = (d.year()+1)+'';
            
            sd.list_oppyForecast.add(of2);
            param = JSON.serialize(sd);
            
            LtngOpportunityForecastCtrl.saveForecastList(param);    //@AuraEnabled
            
            param = JSON.serialize(sd);
            LtngOpportunityForecastCtrl.deleteForecast(param);  //@AuraEnabled
            
        }catch(Exception ex) {
            ex.getMessage();
        }
        system.debug('All::insertsucceed'+Limits.getQueries());        
        Test.stopTest();    /////////////////////////////////////////////////
    }
}