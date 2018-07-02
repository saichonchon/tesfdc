@isTest(seealldata=false)
private class OpportunityAU_Test {
        
    static testMethod void TestOpportunityAUTrigger()
    {
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        
        ID oRTid = (Id)Consumer_Device_Opportunity_Record_Types__c.getInstance('Engineering_Opportunity_CSD').Record_Type_Id__c;
       
        
        Opportunity oppy = new Opportunity(CloseDate = date.today().addDays(5), recordtypeid = oRTid, name = 'Pain of Queen2', StageName = 'New', Type = 'CM', Request_Type__c = 'Extension', Method__c = 'BOM', Level__c = 'Yearly', Amount = 1, Five_Year_Revenue__c = 1, Currency_Confirm__c = true);
        Opportunity oppy1 = new Opportunity(CloseDate = date.today().addDays(5), recordtypeid = oRTid, name = 'Pain of Queen2', StageName = 'New', Type = 'CM', Request_Type__c = 'Extension', Method__c = 'BOM', Level__c = 'Yearly', Amount = 1, Five_Year_Revenue__c = 1, Currency_Confirm__c = true);
        List<Opportunity> lstOppy =  new List<Opportunity>{oppy, oppy1};
        insert lstOppy;
        
        test.startTest();
        
        ExecuteOnce.SF2SF_OPPORTUNITY = false;
        
        lstOppy[0].stageName = 'Production';
        lstOppy[0].Won_Date__c = date.today();
        lstOppy[1].stageName = 'Production';
        lstOppy[1].Won_Date__c = date.today();
        update lstOppy;
        
        ClsTestCustomSettingHelper.getTE_Connection();
		lstOppy[0].stageName = 'New';
        lstOppy[1].stageName = 'New';
        update lstOppy;    
        
        ExecuteOnce.SF2SF_OPPORTUNITY = true;
        
        test.stopTest();
    }
    
    static testMethod void TestOpportunityAUTrigger1()
    {
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        
        ID oRTid = (Id)Consumer_Device_Opportunity_Record_Types__c.getInstance('Engineering_Opportunity_CSD').Record_Type_Id__c;
         RecordType rt = ClsTestHelp.createTestRecordType14();
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt.Id;
        acc.Type = 'Global Account';
        acc.Industry_Code_Description__c = 'Appliances';
        acc.LEVEL_1_INDUSTRY_CDE__c = '0283';
        acc.ownerId = userinfo.getUserId();
        acc.Account_Manager__c = userinfo.getUserId();
        insert acc;
        
        Opportunity oppy = new Opportunity(account = acc,accountId = acc.id,Legally_Restricted__c = false,CloseDate = date.today().addDays(5), recordtypeid = oRTid, name = 'Pain of Queen2', StageName = 'New', Type = 'CM', Request_Type__c = 'Extension', Method__c = 'BOM', Level__c = 'Yearly', Amount = 1, Five_Year_Revenue__c = 1, Currency_Confirm__c = true);
        Opportunity oppy1 = new Opportunity(account = acc,accountId = acc.id,Legally_Restricted__c = false,CloseDate = date.today().addDays(5), recordtypeid = oRTid, name = 'Pain of Queen2', StageName = 'New', Type = 'CM', Request_Type__c = 'Extension', Method__c = 'BOM', Level__c = 'Yearly', Amount = 1, Five_Year_Revenue__c = 1, Currency_Confirm__c = true);
        List<Opportunity> lstOppy =  new List<Opportunity>{oppy, oppy1};
        insert lstOppy;
        
        test.startTest();
        
        ExecuteOnce.SF2SF_OPPORTUNITY = false;
        
        ClsTestCustomSettingHelper.getTE_Connection();
		lstOppy[0].stageName = 'Production';
        lstOppy[0].Won_Date__c = date.today();
        lstOppy[0].Legally_Restricted__c = false;
        lstOppy[1].stageName = 'Production';
        lstOppy[1].Won_Date__c = date.today();
        lstOppy[1].Legally_Restricted__c = false;
        update lstOppy;    
        
        ExecuteOnce.SF2SF_OPPORTUNITY = true;
        
        test.stopTest();
    }
    
   
}