/**
*  This test class used to test class ExtRecalculateBudget.
*
@author Lili Zhao
@created 2014-03-25
@version 1.0   
@since 28.0
*
@changelog
* coverage 89% 
* 
* 
2014-03-25 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest(SeeAllData = false)
private class ClsPMVTeamViewUtil_Test {
        
    /*Opportunity_Record_Type_Groups__c  org1 = ClsTestHelp.createTestOPTG1();
    Opportunity_Record_Type_Groups__c  org2 = ClsTestHelp.createTestOPTG2();
    PMV_Language_Config__c slc1 = ClsTestHelp.createTestSLC1();
    PMV_Language_Config__c slc2 = ClsTestHelp.createTestSLC2();
    PMV_Language_Config__c slc3 = ClsTestHelp.createTestSLC3();
    PMV_Sales_Process_Settings__c ssps1 = ClsTestHelp.createTestSSPS1();
    PMV_Sales_Process_Settings__c ssps2 = ClsTestHelp.createTestSSPS1();
    PMV_Sales_Stage_Setting__c ssss1 = ClsTestHelp.createTestSSSS1();
    PMV_Sales_Stage_Setting__c ssss2 = ClsTestHelp.createTestSSSS2();
    PMV_Sales_Stage_Setting__c ssss3 = ClsTestHelp.createTestSSSS3();
    PMV_Sales_Stage_Setting__c ssss4 = ClsTestHelp.createTestSSSS4();
    PMV_Sales_Stage_Setting__c ssss5 = ClsTestHelp.createTestSSSS5();
    PMV_Sales_Stage_Setting__c ssss6 = ClsTestHelp.createTestSSSS6();
    PMV_Sales_Stage_Setting__c ssss7 = ClsTestHelp.createTestSSSS7();
    PMV_Sales_Stage_Setting__c ssss8 = ClsTestHelp.createTestSSSS8();
    PMV_Sales_Stage_Setting__c ssss9 = ClsTestHelp.createTestSSSS9();
    PMV_Sales_Stage_Setting__c ssss10 = ClsTestHelp.createTestSSSS10();
    PMV_Stage_Config__c ssc1 = ClsTestHelp.createTestSSC1();
    PMV_Stage_Config__c ssc2 = ClsTestHelp.createTestSSC2();
    PMV_Stage_Config__c ssc3 = ClsTestHelp.createTestSSC3();
    PMV_Stage_Config__c ssc4 = ClsTestHelp.createTestSSC4();
    PMV_Stage_Config__c ssc5 = ClsTestHelp.createTestSSC5();
    PMV_Stage_Config__c ssc6 = ClsTestHelp.createTestSSC6();
    PMV_Stage_Config__c ssc7 = ClsTestHelp.createTestSSC7();*/
    
    static testMethod void myUnitTest() {
        // TO DO: implement unit test

        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
        ClsTestCustomSettingHelper.getPMV_Sales_Stage_Setting();
        ClsTestCustomSettingHelper.getPMV_Stage_Config();
        Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;
           Profile p = [Select Id, Name From Profile 
                     where Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
        User user = [select id from user   where isActive=true and ProfileId =:p.Id and GIBU__c='Industrial'  and Sub_Vertical__c ='Industrial' limit 1];
 
        
        system.runAs(user){
        
            Pricebook2 pb2 = new Pricebook2();
            for(Pricebook2 pb1 : [SELECT id FROM Pricebook2 WHERE IsActive=true AND IsStandard = true limit 1]){
                pb2 = pb1;
            }
            if(pb2.Id == null){
                pb2.IsActive = true;
                pb2.Name = 'Standard Price Book';
                insert pb2;
            } 
            String oppyRT;
            RecordType rt = ClsTestHelp.createPMVTestRecordType1();
            oppyRT = rt.Id;
            
            List<Trigger_Configuration__c> lstTriggerConfig = new  List<Trigger_Configuration__c>();
            Trigger_Configuration__c tc3 = new Trigger_Configuration__c(); 
            tc3.Name='Identify Fiscal Year';
            tc3.isRun__c=true;
            lstTriggerConfig .add(tc3);
            
            Trigger_Configuration__c tc4 = new Trigger_Configuration__c(); 
            tc4.Name='Populate Opportunity Partner';
            tc4.isRun__c=true;
            lstTriggerConfig .add(tc4);
            
            Trigger_Configuration__c tc5 = new Trigger_Configuration__c(); 
            tc5.Name='updateAccountBusinessUnit';
            tc5.isRun__c=true;
            lstTriggerConfig .add(tc5);
            insert lstTriggerConfig;
            
            OpportunityStage os = [SELECT MasterLabel, Id FROM OpportunityStage where isActive=true limit 1];
            
            ClsPMV_Util.getPMVSalesStageSetting();
               Account acct1 = ClsTestHelp.createTestAccounts();
        acct1.Name = 'axx';
        acct1.RecordTypeId = oppyRT;
        acct1.AccountNumber = '1234:12345678';
        acct1.Account_Manager__c = user.Id;
        acct1.SALES_TERRITORY_CDE__c = '123456';
        acct1.Active__c = true;
        acct1.STATDESC__c = 'Active';
        acct1.WWCORPACCT__c = '123412345678';
    //    insert acct1;
            
           /*   Opportunity oppy = new Opportunity();
          
            Account acc = ClsTestHelp.createTestAccounts();
            acc.AccountNumber = '1149test';     
            acc.Type='Prospect';
            insert acc;
            for(Account account : [Select Id from Account where Type = 'Prospect' and Id =: acc.Id]) {
                acc = account;
            }
            if(acc.Id == null) {
                acc = ClsTestHelp.createTestAccounts();
                acc.Type = 'Prospect';
                insert acc;
            }
          
            
           // oppy.AccountId = acc.Id;
            oppy.Name = 'test';
            oppy.CurrencyIsoCode = 'EUR';
            oppy.currency_confirm__c = true;
            oppy.Type = 'New Business';
            oppy.Description = 'test';
            oppy.Distributor__c = 'Dachs';
            oppy.StageName = 'Initiating';
            oppy.Manufacturing_Start_Date__c = date.today();
            oppy.CloseDate = date.today().addMonths(1);
            oppy.RecordTypeId = oppyRT;
            oppy.Lead_ID__c = '01x000000000fgh';
            oppy.PMV_Type__c = 'IND China ENG opp';//'IND Standard Sales opp';
            oppy.StageName = 'Exploring Needs';
            oppy.Stage_Change_Error_Message__c = 'test';
              oppy.Request_Type__c = 'IND_Sales_Project';
              oppy.Manufacturing_Start_Date__c=System.today();
            insert oppy;
            //oppy.AccountId = acc.Id;
            //update oppy;
            */  
              Opportunity oppy3 = ClsTestHelp.createTestOpportunity();
        oppy3.Program_level_Forecasting__c =true; 
        oppy3.Name = 'Pain of Queen';
        //oppy3.AccountId=acct1.Id;
        oppy3.Type = 'CM';
        oppy3.Request_Type__c = 'IND_Sales_Project';
        oppy3.RecordTypeId = clsTestHelp.createPMVTestRecordType1().Id;  ///clsTestHelp.createTestCSD7().id; //
        oppy3.stagename= 'New Opportunity';
        //oppy3.PMV_Type__c ='IND China Sales opp';
        oppy3.OEM_Name__c=acct1.Id;
        oppy3.Lead_ID__c='Test lead';
                oppy3.Manufacturing_Start_Date__c=System.today();
                oppy3.PMV_Type__c ='IND China ENG opp';
              insert oppy3;  
          
                
            
            ClsPMVTeamViewUtil clsTeamView = new ClsPMVTeamViewUtil();
            ClsPMVTeamViewUtil.DateRange  dateRange = new ClsPMVTeamViewUtil.DateRange('test1', 'test2');
            list<ClsPMVTeamViewUtil.DateRange> list_dateRange = new list<ClsPMVTeamViewUtil.DateRange>();
            list_dateRange.add(dateRange );
            list<ClsPMVTeamViewUtil.DateRangeType> list_dateRangeType = New list<ClsPMVTeamViewUtil.DateRangeType>();
            set<String> set_membIds = new set<String>();
            set<String> set_membIds1 = new set<String>();
            set_membIds.add(UserInfo.getUserId());
            CtrlPMVTeamView.DatePicker dateInfo = new CtrlPMVTeamView.DatePicker();
            dateInfo.selectedMembId = 'testId';
            dateInfo.oppick = 'Custom';
            dateInfo.fcpick = 'Custom';
            dateInfo.opstart = system.today();
            dateInfo.opend = system.today();
            dateInfo.fcstart = system.today();
            dateInfo.fcend = system.today();        
            dateInfo.orderField = 'test3';
            dateInfo.orderASC = 'test4';
            
            CtrlPMVTeamView.PageConfig pageConf = new CtrlPMVTeamView.PageConfig();
            pageConf.dateInfoJson = Json.serialize(dateInfo) ;
            map<String, String> map_queryKey_query = new map<String, String>();
            CtrlPMVTeamView.OppyViewObj oppyForMemb = new CtrlPMVTeamView.OppyViewObj();
            list<CtrlPMVTeamView.OppyViewObj> list_oppysForMemb = new list<CtrlPMVTeamView.OppyViewObj>();
            list_oppysForMemb.add(oppyForMemb);
            list<Opportunity> list_oppys = new list<Opportunity>();
            list_oppys.add(oppy3);
            map<String, String> map_stage_teamViewColumn = new map<String, String>();
            map_stage_teamViewColumn.put('Pending', 'Pending');
            map_stage_teamViewColumn.put('test', 'test');
            Test.startTest();
            ClsPMVTeamViewUtil.generateDateRange(list_dateRangeType);     
            ClsPMVTeamViewUtil.getOppysForMemb(set_membIds, dateInfo);
            ClsPMVTeamViewUtil.generateOppyViewObjs(list_oppys, list_oppysForMemb, dateInfo);
            ClsPMVTeamViewUtil.getStageMapping(map_stage_teamViewColumn);        
            ClsPMVTeamViewUtil.getBigOppyAmountFromCustomsetting(pageConf);
            ClsPMVTeamViewUtil.getSize(oppy3, oppyForMemb);
            ClsPMVTeamViewUtil.getProjected(oppy3, oppyForMemb);
            ClsPMVTeamViewUtil.getForecastRecords(set_membIds, dateInfo);
            ClsPMVTeamViewUtil.getForecastMixRecords(set_membIds, dateInfo);
            ClsPMVTeamViewUtil.transformIsoCode(3.5,'USD','USD');
            Test.stopTest();   
        }
    }
}