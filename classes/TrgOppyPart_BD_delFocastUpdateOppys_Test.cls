/**
*   This test class is for opportunityPart_AIU_checkCrossBUupdOppy.
*
@author Di Chen
@created 2012-06-01
@version 1.0
@since 20.0
*
@changelog
* 2012-06-01 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 80%
*/
@isTest(SeeAllData=false)
private class TrgOppyPart_BD_delFocastUpdateOppys_Test {

    static testMethod void testDel() {
        
        /*if (Type.forName('Channelinsight__CI_Configuration__c') != null) {
            Channelinsight__CI_Configuration__c c = new Channelinsight__CI_Configuration__c();
            c.Name = 'Default';
            c.Channelinsight__CONF_Stop_Matching_POS_to_Opportunity__c = 'Opportunity Is Closed';
            c.Channelinsight__CONF_Salesforce_Environment__c = 'Sandbox';
            c.Channelinsight__CONF_Reprocess_Reviewed__c = true;
            c.Channelinsight__CONF_Disable_Address_Type_Matching__c = true;  
            c.Channelinsight__CONF_Auto_mark_POS_Reviewed__c = false; 
            c.Channelinsight__CONF_Acct_Sales_Trending_Default_Address__c = 'Bill-to';
            insert c;
       }*/
                       
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
        u.GIBU__c = 'Industrial';
        u.Sub_Vertical__c = 'Industrial';
        insert u;
        system.runAs(u){ 
        ClsTestCustomSettingHelper.getApex_Helper_Settings(); // moved by Bhavya to avoid test failure
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();//added by Bhavya to fix test failure
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();//added by Bhavya to fix test failure
        ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();//added by Bhavya to fix test failure
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        
        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
        sh.Level_7_Assigned_Users__c = u.Id;
        sh.Level_6_Assigned_Users__c = 'xxxxxxxxxxxxxxxxxxxxxxxxx';
        insert sh;
        //commented by Bhavya for code optimization
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
        oppy.PMV_Type__c = 'IND Standard ENG opp';
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
        fb.Opportunity_Forecast__c = oppyForecast.Id;
        fb.Amount__c = 3;
        insert fb;
        Test.startTest();
        
        delete oppypart;
        
        Test.stopTest();
        }
    }
    //method added by Bhavya to increase code coverage   
    static testMethod void testDel1() {
                             
        //ClsTestHelp.initAPLTestData();
        
        Profile p = [Select Id, Name From Profile                                      
                                    WHERE Name ='DND Standard User' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'helloManesfd4@testCompany1233423.com';
        u.Alias = 'dp4e';
        u.CommunityNickname = 'TMD';
        u.ProfileId = p.Id;
        u.GIBU__c = 'Data & Devices';
        u.Sub_Vertical__c = 'DataComm';
        insert u;
        
        system.runAs(u){ 
        ClsTestCustomSettingHelper.getApex_Helper_Settings(); 
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();//added by Bhavya to fix test failure
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();//added by Bhavya to fix test failure
        ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();//added by Bhavya to fix test failure
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types(); 
        Opportunity_Record_Type_Groups__c rec = Opportunity_Record_Type_Groups__c.getInstance('DND Opportunity');  
        Consumer_Device_Opportunity_Record_Types__c con = Consumer_Device_Opportunity_Record_Types__c.getInstance('OEM');  
        Account acc = ClsTestHelp.createTestAccounts();              
        insert acc;
        
        Account acc1 = ClsTestHelp.createTestAccounts(); 
        acc1.RecordTypeId = con.Record_Type_Id__c;             
        insert acc1;
                
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.AccountId = acc.Id;
        oppy.OEM_Name__c = acc1.id;       
        oppy.StageName = 'New Opportunity';
        oppy.PMV_Type__c = 'IND Standard ENG opp';
        oppy.Type = 'New Business';
        oppy.RecordTypeId = rec.RecordTypeID__c ;
        insert oppy;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';       
        insert ph;
        
        Part__c part = new Part__c();        
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppypart.Part__c = part.Id;
        oppypart.Status__c = 'Won';        
        oppypart.GPL__c = ph.Id;
        insert oppypart;
        Test.startTest();               
        try{
            delete oppypart;
        }
        catch(Exception e) {
            System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
        }               
        Test.stopTest();
        }
    }
}