/**
 *  Calss covered : Cls_BatchForecastBillingReparenting
 *  
 * @author Rajendra Shahane
 * @created 2016-11-11
 * @version 1.0
 * @since 36.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 *
 * 2016-11-11 Rajendra Shahane <Rajendra.shahane@zensar.com>
 * - Created   
 * - Code coverage : 91%
 */
@isTest(Seealldata=false)
private class Cls_BatchForecastBillingReparenting_Test {
    static testMethod void testDel() {
       
       ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        //ClsTestHelp.initAPLTestData();
        
        Profile p = [Select Id, Name From Profile 
                                    where Name = 'Service Account' 
                                    or Name ='System Administrator' 
                                    or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'helloManesfd4@testCompany1233423.com';
        u.Alias = 'dp4e';
        u.CommunityNickname = 'TMD';
        u.ProfileId = p.Id;
        insert u;
        system.runAs(u){    
        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
        sh.Level_7_Assigned_Users__c = u.Id;
        sh.Level_6_Assigned_Users__c = 'xxxxxxxxxxxxxxxxxxxxxxxxx';
        insert sh;
        /*Opportunity_Approvers__c oa12= new Opportunity_Approvers__c();
        oa12.Approver_Id__c = u.id;
        oa12.Name = 'FilterCenter';
        insert oa12;*/
        Account acc = ClsTestHelp.createTestAccounts();
        acc.LEVEL_1_INDUSTRY_CDE__c = '0001';
        acc.Sales_Hierarchy__c = sh.Id;
        acc.Account_Manager__c = u.Id;
        
        insert acc;
                
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.AccountId = acc.Id;
        oppy.Request_Type__c = 'Cable Assembly - Extension';
        oppy.StageName = 'Rejected - Closed';
        insert oppy;
        
        OpportunityTeamMember ot = new OpportunityTeamMember();
        ot.UserId = u.Id;
        ot.OpportunityId = oppy.Id;
        ot.TeamMemberRole = 'Global Account Manager (GAM)';
        insert ot;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        ph.Product_Manager__c = u.Id;
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
        oppypart.GPL__c = ph.Id;
        insert oppypart;
        
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast.Opportunity__c = oppy.Id;
        oppyForecast.Quantity__c = 12;
        oppyForecast.Part__c = oppypart.Id;
        oppyForecast.Date__c = date.newInstance(2012, 09, 28);
        oppyForecast.Amount__c = 1;
        oppyForecast.Sales_Price__c = 1;
        insert oppyForecast;
        
        Forecast_Billing__c fb = new Forecast_Billing__c();
        fb.Opportunity_Part__c = oppypart.Id;
        fb.Date__c = oppyForecast.Date__c;
        //fb.Opportunity_Forecast__c = oppyForecast.Id;
        fb.Amount__c = 3;
        insert fb;
        Test.startTest();
        
        Cls_BatchForecastBillingReparenting obj = new Cls_BatchForecastBillingReparenting();
		//obj.StartDate = date.today();
		database.executeBatch(obj, 100);
        
        Test.stopTest();
        }
    }
}