/*
 * Rajendra Shahane 03/29/2016  Modified for case - 900703
 */
@isTest(seealldata=false)
private class ViewOpportunityPartController_Test {
    static testMethod void TestViewOpportunityPartController()
    {
         //Start: Rajendra Shahane Modified for case - 900703
        ChannelinsightData_test.Channelinsightdata_test();
        //End: Rajendra Shahane Modified for case - 900703
        
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        Apex_Helper_Settings__c hlpSetting1 = Apex_Helper_Settings__c.getInstance('GIBU of Applience');
        Apex_Helper_Settings__c hlpSetting = Apex_Helper_Settings__c.getInstance('NDR Opportunity Parts');
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        recordtype oRT = [select id from recordtype where sobjecttype = :'Opportunity' and developername = :'Engineering_Opportunity_CSD'];
        
        Opportunity oppy = new Opportunity(Won_Date__c = date.today(),CloseDate = date.today().addDays(5), recordtypeid = oRT.id, name = 'Pain of Queen2', StageName = 'New', Type = 'CM', Request_Type__c = 'Extension', Method__c = 'BOM', Level__c = 'Yearly', Amount = 1, Five_Year_Revenue__c = 1, Currency_Confirm__c = true);
        insert oppy;

        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        insert ph;
          
        Part__c part = new Part__c();
        part.Description__c = 'Sniper1';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
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
        insert oppypart1;

        test.starttest();
        
        ViewOpportunityPartController objCls = new ViewOpportunityPartController(new ApexPages.standardController(oppypart1));

        User currentUser = [select Id, GIBU__c from User where Id =: UserInfo.getUserId()];
        hlpSetting.Value__c = oppypart1.RecordTypeId;
        
        update hlpSetting;
        objCls.Redirect();
        
        hlpSetting1.value__c = currentUser.GIBU__c;
        update hlpSetting1;
        objCls.Redirect();
        objCls.vNDROppPart = true;

        test.stoptest();
    }

}