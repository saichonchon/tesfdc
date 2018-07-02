/**
*   This test class is for opportunity_BAU_snapshotForecastData.
*
@author Di Chen
@created 2012-06-01
@version 1.0
@since 20.0
*
@changelog
* 2012-06-01 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 91%
* - Modified
* - 2016-02-17 Rajendra Shahane <rajendra.shahane@zensar.in>For case 00900678
* - Test coverage 91%
*/
@isTest(seealldata=false)
private class TrgOppy_BAU_snapshotForecastData_Test {

    static testMethod void testTrgOppy_BAU_snapshotForecastData() {
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getForecast_Snapshot_Setup();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        
        List<Trigger_Configuration__c> lstTC = new List<Trigger_Configuration__c>();
        Trigger_Configuration__c tc = new Trigger_Configuration__c();
        tc.Name = 'Identify Fiscal Year';
        tc.isRun__c = true;
        lstTC.add(tc);
        
        Trigger_Configuration__c tc1 = new Trigger_Configuration__c();
        tc1.Name = 'Populate Opportunity Partner';
        tc1.isRun__c = true;
        lstTC.add(tc1);
        
        Trigger_Configuration__c tc2 = new Trigger_Configuration__c();
        tc2.Name = 'updateAccountBusinessUnit';
        tc2.isRun__c = true;
        lstTC.add(tc2);
        insert lstTC;
        
        Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;

        Profile p = [Select Id, Name From Profile 
                                    where Name = 'Service Account' 
                                    or Name ='System Administrator' 
                                    or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'helloManesfd9@testCompany1233423.com';
        u.Alias = 'dp9e';
        u.CommunityNickname = 'TMD';
        u.ProfileId = p.Id;
        u.Username = 'mmnn@itlk.com';
        insert u;
        
        system.runAs(u){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.AccountNumber = '901019';
        insert acc;
        
        RecordType rt2 = ClsTestHelp.createTestRecordType9();
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.StageName = 'Approved/Active';
        oppy.Currency_Confirm__c = true;
        oppy.RecordTypeId = rt2.Id;
        oppy.AccountId = acc.Id;
        Test.startTest();
        
        insert oppy;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        insert ph;

        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppypart.Part__c = part.Id;
        oppypart.Status__c = 'Lost';
        oppypart.Lost_Reason__c = 'Other';
        oppypart.Lost_Reason_Text__c = null;
        insert oppypart;
        
        Opportunity_Forecast__c ofo = new Opportunity_Forecast__c();
        ofo.Opportunity__c = oppy.Id;
        ofo.Part__c = oppypart.Id;
        insert ofo;
        
        Forecast_Snapshot__c fs = new Forecast_Snapshot__c();
        fs.Opportunity__c = oppy.Id;
        fs.Opportunity_Stage__c = 'Won - Open';
        fs.Snapshot_Type__c = 'Approval';
        //insert fs;
        
        Forecast_Snapshot__c fs1 = new Forecast_Snapshot__c();
        fs1.Opportunity__c = oppy.Id;
        fs1.Opportunity_Stage__c = 'Won - Open';
        fs1.Snapshot_Type__c = 'Won';
            insert new List<Forecast_Snapshot__c> {fs,fs1};
        
        oppy.StageName = 'Production';
        oppy.Approval_Status_PMV__c = 'G0 Approved';
        update oppy;
        oppy.StageName = 'Won';
        update oppy;
        
        system.assert(true);
        Test.stopTest();
        }
    }
}