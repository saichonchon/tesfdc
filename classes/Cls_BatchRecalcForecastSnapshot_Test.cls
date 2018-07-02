/**
*   This test class is for Cls_BatchRecalculateForecastSnapshot.
*
@author Rajendra Shahane
@created 2015-07-31
@version 1.0
*
@changelog
* 2015-07-31 
* - Created
* - Test coverage 79%
*/
@isTest
private class Cls_BatchRecalcForecastSnapshot_Test {
  
    static testmethod void Cls_BatchRecalculateForecastSnap_TM()
    {
        user oUser = [select id from user where profile.Name = 'system administrator' and isActive = :true limit 1];
        system.runas(oUser)
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
            //insert oppypart;
            
            Opportunity_Part__c oppypart1 = ClsTestHelp.createTestOpportunityPart();
            oppypart1.Opportunity__c = oppy.Id;
            oppypart1.Part__c = part.Id;
            oppypart1.Status__c = 'Won';
            oppypart1.Lost_Reason__c = 'Other';
            oppypart1.Lost_Reason_Text__c = null;
            oppypart1.GPL__c = ph.Id;
            oppypart1.Initial_Order_Date__c = date.today();
            oppypart1.need_recalculate_PartNPSMSGRevenue__c = true;
            oppypart1.BU_profit_center__c = 'Appliances';
            insert new list<Opportunity_Part__c > {oppypart1, oppypart};
            
            Forecast_Snapshot__c oFS = new Forecast_Snapshot__c(Snapshot_Type__c = 'Monthly', Opportunity__c = oppy.Id, Part__c = oppypart.ID,Fiscal_Year__c='2016');
            Forecast_Snapshot__c oFS2 = new Forecast_Snapshot__c(Snapshot_Type__c = 'Monthly', Opportunity__c = oppy.Id, Part__c = oppypart1.ID,Fiscal_Year__c='2016');
            insert new list<Forecast_Snapshot__c>{oFS};
            
            map<Id, DateTime> map_oppyId_wonDate = new map<Id, DateTime>{oppy.ID => date.today()};
    
            test.starttest();   
    
                Cls_BatchRecalculateForecastSnapshot oemMBBB = new Cls_BatchRecalculateForecastSnapshot();
                Database.executeBatch(oemMBBB); 
                Cls_BatchRecalculateForecastSnapshot.cloneMonthlySnapshot(new list<Forecast_Snapshot__c>{oFS}, new set<Id>{oppy.id}, DateTime.now().adddays(-10), 'Won', null);
            
            test.stoptest();
        }
        
    }

}