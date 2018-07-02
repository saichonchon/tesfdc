@isTest(SeeAllData=false)
private class Cls_BatchRecalculateForecastSnap_Test
{
    static testmethod void Cls_BatchRecalculateForecastSnap_TM()
    {
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        ID oRTid = (Id)Consumer_Device_Opportunity_Record_Types__c.getInstance('Engineering_Opportunity_CSD').Record_Type_Id__c;
        
        Opportunity oppy = new Opportunity(CloseDate = date.today().addDays(5), recordtypeid = oRTid, name = 'Pain of Queen2', StageName = 'New', Type = 'CM', Request_Type__c = 'Extension', Method__c = 'BOM', Level__c = 'Yearly', Amount = 1, Five_Year_Revenue__c = 1, Currency_Confirm__c = true);
        insert oppy;

        oppy.stageName = 'Production';
        oppy.Won_Date__c = date.today();
        update oppy;
        
        oppy.stageName = 'Won';
        oppy.Won_Date__c = date.today();
        update oppy;

        oppy.stageName = 'Won - Closed';
        update oppy;

        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        insert ph;
          
        Part__c part = new Part__c();
        part.Description__c = 'Sniper1';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppypart.Part__c = part.Id;
        oppypart.Status__c = 'Won';
        oppypart.Lost_Reason__c = 'Other';
        oppypart.Lost_Reason_Text__c = null;
        oppypart.GPL__c = ph.Id;
        oppypart.Initial_Order_Date__c = date.today();
        oppypart.need_recalculate_PartNPSMSGRevenue__c = true;
        oppypart.BU_profit_center__c = 'Appliances';
        insert oppypart;
        
        Forecast_Snapshot__c oFS = new Forecast_Snapshot__c(Snapshot_Type__c = 'Monthly', Opportunity__c = oppy.Id, Part__c = oppypart.ID);
        //Forecast_Snapshot__c oFS2 = new Forecast_Snapshot__c(Snapshot_Type__c = 'Won', Opportunity__c = oppy.Id, Part__c = oppypart.ID);
        insert new list<Forecast_Snapshot__c>{oFS};
        
        map<Id, DateTime> map_oppyId_wonDate = new map<Id, DateTime>{oppy.ID => date.today()};
        test.starttest();   
        
            Cls_BatchRecalculateForecastSnapshot_Won o = new Cls_BatchRecalculateForecastSnapshot_Won();
            database.executebatch(o);
            Database.BatchableContext BC;
            o.execute(BC, new list<opportunity>{oppy});    
            Cls_BatchRecalculateForecastSnapshot_Won.cloneMonthlySnapshot(new list<Forecast_Snapshot__c>{ofS}, map_oppyId_wonDate , DateTime.now(), '', new set<Id>());
        
        test.stoptest();
        
    }
}