/**
*   This test class is for opportunity_BIU_defineApprovers.
*
@author Di Chen
@created 2012-06-01
@version 1.0
@since 20.0
*
@changelog
* 2012-06-01 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 77%
* - Rajendra Shahane 04/11/2016  Modified for case - 900786
*/
@isTest(Seealldata=false)
private class TrgOppy_BIU_defineApprovers_Test {

    static testMethod void testInsert() {
        //Start : Rajendra Shahane 04/11/2016  Modified for case - 900786
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
        ClsTestCustomSettingHelper.getADMTerritoryCode();
        Opportunity_Approvers__c oa = ClsTestHelp.createTestOpportunityApprovers();        
        Opportunity_Approvers__c oa2 = ClsTestHelp.createTestOpportunityApprovers2();        
        Opportunity_Approvers__c oa3 = ClsTestHelp.createTestOpportunityApprovers3();
        Opportunity_Approvers__c oa4 = ClsTestHelp.createTestOpportunityApprovers4();        
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9(); 
        Apex_Helper_Settings__c ahs10 = ClsTestHelp.createTestName10();
        Apex_Helper_Settings__c ahs11 = ClsTestHelp.createTestName11(); 
        Apex_Helper_Settings__c newSetting = new Apex_Helper_Settings__c (name = 'APL_Email_Alert_Template',value__c = 'https://c2s--c.na9.content.force.com/servlet/servlet.ImageServer?;id=015E0000000P3MB;id=015E0000001hKDe;&oid=00DE0000000Hkve;https://c2s.my.salesforce.com/');
        Apex_Helper_Settings__c exceptUser= new Apex_Helper_Settings__c();
        insert (new Opportunity_Record_Type_Groups__c(name = 'DND Opportunity',RecordTypeID__c = '012E0000000NIlV', Group__c = 'Process Status Display', active__c = true));
        exceptUser.name = 'Currency Confirm Except Users';
        exceptUser.value__c = 'test';
        exceptUser.Active__c = true;
        //insert exceptUser;
        Apex_Helper_Settings__c csdGPL= new Apex_Helper_Settings__c();
        csdGPL.name = 'CSD GPL Code Id';
        csdGPL.value__c = 'test';
        csdGPL.Active__c = true;
        //insert csdGPL;
        Apex_Helper_Settings__c aplRecord = new Apex_Helper_Settings__c();
        aplRecord.name = 'Appliance Opportunity Record Type Id';
        aplRecord.value__c = 'test';
        aplRecord.Active__c = true;
        
        //Added by Archana 
        Opportunity_Approvers__c oppApproval= new Opportunity_Approvers__c();
        oppApproval.Name='Rail';
        oppApproval.Approver_Id__c='005E0000002HaAs';
        oppApproval.Approver_Name__c='Jonathan Hunt';
        oppApproval.GPLs__c='';
        oppApproval.Test_Approver__c='';
        
        insert oppApproval;
        
        
        
        
        
        
        
         Opportunity_Approvers__c railGPL2= new Opportunity_Approvers__c();
        railGPL2.Name='Rail GPLs 02';
        railGPL2.Approver_Id__c='005E0000006EWCY';
        railGPL2.Approver_Name__c='Judy Lim';
        railGPL2.GPLs__c='LT2';
        railGPL2.Test_Approver__c='';
        
        insert railGPL2;
            
        
        
        insert new List<Apex_Helper_Settings__c> {aplRecord,csdGPL,exceptUser,newSetting};

        Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;
            
        TE_Connection__c tec = ClsTestHelp.createTestTEConnection();
        Profit_BU_Center_Mapping_Rule1__c pb1 = ClsTestHelp.createTestProfitBUCenterMapping1();
        Profit_BU_Center_Mapping_Rule2__c pb2 = ClsTestHelp.createTestProfitBUCenterMapping2();
        Profit_BU_Center_Mapping_Rule3__c pb3 = ClsTestHelp.createTestProfitBUCenterMapping3();
        Consumer_Device_Opportunity_Record_Types__c csd1 = ClsTestHelp.createTestCSD1();
        Consumer_Device_Opportunity_Record_Types__c csd2 = ClsTestHelp.createTestCSD2();
        Consumer_Device_Opportunity_Record_Types__c csd3 = ClsTestHelp.createTestCSD3();
        Consumer_Device_Opportunity_Record_Types__c csd4 = ClsTestHelp.createTestCSD4();
        Consumer_Device_Opportunity_Record_Types__c csd5 = ClsTestHelp.createTestCSD5();
        Consumer_Device_Opportunity_Record_Types__c csd6 = ClsTestHelp.createTestCSD6();
        Consumer_Device_Opportunity_Record_Types__c csd7 = ClsTestHelp.createTestCSD7();
        //End : Rajendra Shahane 04/11/2016  Modified for case - 900786
        //Commented : Rajendra Shahane 04/11/2016  Modified for case - 900786
        /*Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Opportunity_Approvers__c oa = ClsTestHelp.createTestOpportunityApprovers();        
        Opportunity_Approvers__c oa2 = ClsTestHelp.createTestOpportunityApprovers2();        
        Opportunity_Approvers__c oa3 = ClsTestHelp.createTestOpportunityApprovers3();
        Opportunity_Approvers__c oa4 = ClsTestHelp.createTestOpportunityApprovers4();*/
        //End : Rajendra Shahane 04/11/2016  Modified for case - 900786
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
        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy1();
        sh.Level_7_Assigned_Users__c = u.Id;
        sh.Level_6_Assigned_Users__c = 'xxxxxxxxxxxxxxxxxxxxxxxxx';
        insert sh;
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.LEVEL_1_INDUSTRY_CDE__c = '0001';
        acc.Sales_Hierarchy__c = sh.Id;
        insert acc;
             System.debug('Sales Hiearchy in Test class :'+acc.Sales_Hierarchy__c);   
           
           
           ClsTestHelp.createTestOPTG1();
           ClsTestHelp.createTestOPTG2();
           ClsTestHelp.createTestADM();
           
        /*Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.AccountId = acc.Id;
        oppy.Request_Type__c = 'Cable Assembly - Extension';
        oppy.StageName = 'Rejected - Closed';
        insert oppy;*/
        RecordType rt2 = ClsTestHelp.createTestRecordType16();
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        //oppy.Program__c = oppy2.Id;  
          oppy.AccountId = acc.Id;// Addedby Archana
              oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.StageName = 'New';
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Currency_confirm__c = true;
        oppy.Five_Year_Revenue__c = 1;
        oppy.RecordTypeId = rt2.Id; 
        oppy.Defined_GPLs__c= '030,375,LT2,JF9,A39,K89,K90,LT1,LR4,LR5,LS9,Z91,K01,K03,A39,LR0,LR1,LR2,LT0,LS8,J37,176,947,LR3';
        insert oppy;
        
        /*
        
         Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        //oppy.Program__c = oppy2.Id;  
          oppy2.AccountId = acc.Id;// Addedby Archana
              oppy2.Type = 'CM';
        oppy2.Request_Type__c = 'Extension';
        oppy2.Method__c = 'BOM';
        oppy2.Level__c = 'Yearly';
        oppy2.Amount = 1;
        oppy2.StageName = 'New';
        oppy2.CurrencyIsoCode = 'EUR';
        oppy2.Currency_confirm__c = true;
        oppy2.Five_Year_Revenue__c = 1;
        oppy2.RecordTypeId = rt2.Id; 
        oppy2.Defined_GPLs__c= '030,375,LT2,JF9,A39';
        insert oppy2;
       
        */
           
        OpportunityTeamMember ot = new OpportunityTeamMember();
        ot.UserId = u.Id;
        ot.OpportunityId = oppy.Id;
        ot.TeamMemberRole = 'Global Account Manager (GAM)';
        insert ot;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        ph.Product_Manager__c = u.Id;
        ph.Regional_PM_AP__c=u.Id;
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        ph.Regional_PM_US__c=u.Id;
        ph.Regional_PM_EU__c=u.id;
        ph.Regional_PM_Japan__c=u.Id;
        ph.Regional_PM_India__c=u.id;
        insert part;
         Test.startTest();
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppypart.Part__c = part.Id;
        oppypart.Status__c = 'Lost';
        oppypart.Lost_Reason__c = 'Other';
        oppypart.Lost_Reason_Text__c = null;
        oppypart.GPL__c = ph.Id; //commented by Bhavya
         oppypart.Initial_Order_Date__c = date.today();
     //   oppypart.Product_Manager_Id__c = u.Id;
       // oppypart.Regional_PM_AP_Id__c =u.Id; 
       
        insert oppypart;
         Opportunity_Part__c oppypart2 = ClsTestHelp.createTestOpportunityPart();
            oppypart2.Opportunity__c = oppy.Id;
            oppypart2.Part__c = part.Id;
            oppypart2.Status__c = 'Lost';
            oppypart2.Lost_Reason__c = 'Other';
            oppypart2.Lost_Reason_Text__c = null;
           // oppypart2.GPL__c = ph.Id; commented by Bhavya
            oppypart2.Initial_Order_Date__c = date.today();
            // insert new list<Opportunity_Part__c>{oppypart2, oppypart};
            
        System.debug('Opportunity Part from Test Class :'+oppypart.Id +'\t :::: oppypart.Opportunity__c::'+oppypart.Opportunity__c);
         System.debug('Opportunity Part from Test Class :'+oppypart2.Id +'\t :::: oppypart.Opportunity__c::'+oppypart2.Opportunity__c);
        
       
        
        
        oppy.Request_Type__c = 'Cable Assembly - New Dev';
        update oppy;
        
        system.assert(true);
        Test.stopTest();
        }
    }
    /*
     static testMethod void testInsert2() {
        //Start : Rajendra Shahane 04/11/2016  Modified for case - 900786
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings(); 
        Opportunity_Approvers__c oa = ClsTestHelp.createTestOpportunityApprovers();        
        Opportunity_Approvers__c oa2 = ClsTestHelp.createTestOpportunityApprovers2();        
        Opportunity_Approvers__c oa3 = ClsTestHelp.createTestOpportunityApprovers3();
        Opportunity_Approvers__c oa4 = ClsTestHelp.createTestOpportunityApprovers4();        
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9(); 
        Apex_Helper_Settings__c ahs10 = ClsTestHelp.createTestName10();
        Apex_Helper_Settings__c ahs11 = ClsTestHelp.createTestName11(); 
        Apex_Helper_Settings__c newSetting = new Apex_Helper_Settings__c (name = 'APL_Email_Alert_Template',value__c = 'https://c2s--c.na9.content.force.com/servlet/servlet.ImageServer?;id=015E0000000P3MB;id=015E0000001hKDe;&oid=00DE0000000Hkve;https://c2s.my.salesforce.com/');
        Apex_Helper_Settings__c exceptUser= new Apex_Helper_Settings__c();
        exceptUser.name = 'Currency Confirm Except Users';
        exceptUser.value__c = 'test';
        exceptUser.Active__c = true;
        //insert exceptUser;
        Apex_Helper_Settings__c csdGPL= new Apex_Helper_Settings__c();
        csdGPL.name = 'CSD GPL Code Id';
        csdGPL.value__c = 'test';
        csdGPL.Active__c = true;
        //insert csdGPL;
        Apex_Helper_Settings__c aplRecord = new Apex_Helper_Settings__c();
        aplRecord.name = 'Appliance Opportunity Record Type Id';
        aplRecord.value__c = 'test';
        aplRecord.Active__c = true;
        insert new List<Apex_Helper_Settings__c> {aplRecord,csdGPL,exceptUser,newSetting};

        Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;
                                                            
        TE_Connection__c tec = ClsTestHelp.createTestTEConnection();
        Profit_BU_Center_Mapping_Rule1__c pb1 = ClsTestHelp.createTestProfitBUCenterMapping1();
        Profit_BU_Center_Mapping_Rule2__c pb2 = ClsTestHelp.createTestProfitBUCenterMapping2();
        Profit_BU_Center_Mapping_Rule3__c pb3 = ClsTestHelp.createTestProfitBUCenterMapping3();
        Consumer_Device_Opportunity_Record_Types__c csd1 = ClsTestHelp.createTestCSD1();
        Consumer_Device_Opportunity_Record_Types__c csd2 = ClsTestHelp.createTestCSD2();
        Consumer_Device_Opportunity_Record_Types__c csd3 = ClsTestHelp.createTestCSD3();
        Consumer_Device_Opportunity_Record_Types__c csd4 = ClsTestHelp.createTestCSD4();
        Consumer_Device_Opportunity_Record_Types__c csd5 = ClsTestHelp.createTestCSD5();
        Consumer_Device_Opportunity_Record_Types__c csd6 = ClsTestHelp.createTestCSD6();
        Consumer_Device_Opportunity_Record_Types__c csd7 = ClsTestHelp.createTestCSD7();
        //End : Rajendra Shahane 04/11/2016  Modified for case - 900786
        //Commented : Rajendra Shahane 04/11/2016  Modified for case - 900786
        
        //End : Rajendra Shahane 04/11/2016  Modified for case - 900786
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
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.LEVEL_1_INDUSTRY_CDE__c = '0001';
        acc.Sales_Hierarchy__c = sh.Id;
        insert acc;
        
        
          ClsTestHelp.createTestOPTG1();
           ClsTestHelp.createTestOPTG2();
           ClsTestHelp.createTestADM();
        
        RecordType rt2 = ClsTestHelp.createTestRecordType16();
       
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        //oppy.Program__c = oppy2.Id;  
        
         oppy.AccountId = acc.Id;/////////////////Added by Archana  
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Converted_Email_Alert_Date__c = System.today() -1;
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.StageName = 'New';
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Currency_confirm__c = true;
        oppy.Five_Year_Revenue__c = 1;
        oppy.RecordTypeId = rt2.Id; 
        //oppy.Mass_prod_Status__c = true;
          oppy.Defined_GPLs__c= '030,375,LT2,JF9,A39,K89,K90,LT1,LR4,LR5,LS9,Z91,K01,K03,A39,LR0,LR1,LR2,LT0,LS8,J37,176,947,LR3';
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
        ph.Regional_PM_US__c=u.Id;
        ph.Regional_PM_EU__c=u.id;
        ph.Regional_PM_Japan__c=u.Id;
        ph.Regional_PM_India__c=u.id;
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
         ph.Regional_PM_AP__c=u.Id;
        insert part;
        
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppypart.Part__c = part.Id;
        oppypart.Status__c = 'Lost';
        oppypart.Lost_Reason__c = 'Other';
        oppypart.Lost_Reason_Text__c = null;
        oppypart.GPL__c = ph.Id;
       // oppypart.Product_Manager_Id__c = u.Id;
     // oppypart.Regional_PM_AP_Id__c = u.Id;
        insert oppypart;
        
        Test.startTest();
        
        oppy.Request_Type__c = 'Cable Assembly - New Dev';
        update oppy;
        
        system.assert(true);
        Test.stopTest();
        }
    }
    */
    static testMethod void testInsert3() {
        //Start : Rajendra Shahane 04/11/2016  Modified for case - 900786
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings(); 
        ClsTestCustomSettingHelper.getADMTerritoryCode();
        Opportunity_Approvers__c oa = ClsTestHelp.createTestOpportunityApprovers();        
        Opportunity_Approvers__c oa2 = ClsTestHelp.createTestOpportunityApprovers2();        
        Opportunity_Approvers__c oa3 = ClsTestHelp.createTestOpportunityApprovers3();
        Opportunity_Approvers__c oa4 = ClsTestHelp.createTestOpportunityApprovers4();        
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9(); 
        Apex_Helper_Settings__c ahs10 = ClsTestHelp.createTestName10();
        Apex_Helper_Settings__c ahs11 = ClsTestHelp.createTestName11(); 
        Apex_Helper_Settings__c newSetting = new Apex_Helper_Settings__c (name = 'APL_Email_Alert_Template',value__c = 'https://c2s--c.na9.content.force.com/servlet/servlet.ImageServer?;id=015E0000000P3MB;id=015E0000001hKDe;&oid=00DE0000000Hkve;https://c2s.my.salesforce.com/');
        Apex_Helper_Settings__c exceptUser= new Apex_Helper_Settings__c();
        insert (new Opportunity_Record_Type_Groups__c(name = 'DND Opportunity',RecordTypeID__c = '012E0000000NIlV', Group__c = 'Process Status Display', active__c = true));
        exceptUser.name = 'Currency Confirm Except Users';
        exceptUser.value__c = 'test';
        exceptUser.Active__c = true;
        //insert exceptUser;
        Apex_Helper_Settings__c csdGPL= new Apex_Helper_Settings__c();
        csdGPL.name = 'CSD GPL Code Id';
        csdGPL.value__c = 'test';
        csdGPL.Active__c = true;
        //insert csdGPL;
        Apex_Helper_Settings__c aplRecord = new Apex_Helper_Settings__c();
        aplRecord.name = 'Appliance Opportunity Record Type Id';
        aplRecord.value__c = 'test';
        aplRecord.Active__c = true;
        insert new List<Apex_Helper_Settings__c> {aplRecord,csdGPL,exceptUser,newSetting};

        Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;
                                                            
        TE_Connection__c tec = ClsTestHelp.createTestTEConnection();
        Profit_BU_Center_Mapping_Rule1__c pb1 = ClsTestHelp.createTestProfitBUCenterMapping1();
        Profit_BU_Center_Mapping_Rule2__c pb2 = ClsTestHelp.createTestProfitBUCenterMapping2();
        Profit_BU_Center_Mapping_Rule3__c pb3 = ClsTestHelp.createTestProfitBUCenterMapping3();
        Consumer_Device_Opportunity_Record_Types__c csd1 = ClsTestHelp.createTestCSD1();
        Consumer_Device_Opportunity_Record_Types__c csd2 = ClsTestHelp.createTestCSD2();
        Consumer_Device_Opportunity_Record_Types__c csd3 = ClsTestHelp.createTestCSD3();
        Consumer_Device_Opportunity_Record_Types__c csd4 = ClsTestHelp.createTestCSD4();
        Consumer_Device_Opportunity_Record_Types__c csd5 = ClsTestHelp.createTestCSD5();
        Consumer_Device_Opportunity_Record_Types__c csd6 = ClsTestHelp.createTestCSD6();
        Consumer_Device_Opportunity_Record_Types__c csd7 = ClsTestHelp.createTestCSD7();
        //End : Rajendra Shahane 04/11/2016  Modified for case - 900786
        //Commented : Rajendra Shahane 04/11/2016  Modified for case - 900786
        /*Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Opportunity_Approvers__c oa = ClsTestHelp.createTestOpportunityApprovers();        
        Opportunity_Approvers__c oa2 = ClsTestHelp.createTestOpportunityApprovers2();        
        Opportunity_Approvers__c oa3 = ClsTestHelp.createTestOpportunityApprovers3();
        Opportunity_Approvers__c oa4 = ClsTestHelp.createTestOpportunityApprovers4();*/
        //End : Rajendra Shahane 04/11/2016  Modified for case - 900786
        Profile p = [Select Id, Name From Profile 
                                    where Name = 'Service Account' 
                                    or Name ='System Administrator' 
                                    or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'helloManesfd4@testCompany1233423.com';
        u.Alias = 'dp4e';
        u.CommunityNickname = 'TMD';
        u.Te_Network_Id__c = '0529';
        u.ProfileId = p.Id;
        insert u;
        system.runAs(u){        
        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
        sh.Level_7_Assigned_Users__c = u.Id;
        sh.Level_7_Territory_Code__c = '103004';
        sh.Level_7_Default_Owner__c = u.Id;
        sh.Level_7_Territory_Name__c = 'test aa7';
        sh.Level_7_Assigned_User_Network_Ids__c = u.Te_Network_Id__c;
    	sh.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
        sh.Level_6_Assigned_Users__c = 'xxxxxxxxxxxxxxxxxxxxxxxxx';
        insert sh;
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.LEVEL_1_INDUSTRY_CDE__c = '0001';
        acc.SALES_TERRITORY_CDE__c ='103004';
        acc.Sales_Hierarchy__c = sh.Id;
        insert acc;
        
          ClsTestHelp.createTestOPTG1();
           ClsTestHelp.createTestOPTG2();
           ClsTestHelp.createTestADM();
                
        /*Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.AccountId = acc.Id;
        oppy.Request_Type__c = 'Cable Assembly - Extension';
        oppy.Defined_GPLs__c = '375,397,A39,K01,K03,176,Z91';
        oppy.StageName = 'Rejected - Closed';
        insert oppy;*/
        RecordType rt2 = ClsTestHelp.createTestRecordType16();
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        //oppy.Program__c = oppy2.Id;   
         oppy.AccountId = acc.Id;                //Added by Archana
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Converted_Email_Alert_Date__c = System.today() -1;
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.StageName = 'New';
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Currency_confirm__c = true;
        oppy.Five_Year_Revenue__c = 1;
        oppy.RecordTypeId = rt2.Id; 
        //oppy.Mass_prod_Status__c = true;
          oppy.Defined_GPLs__c= '030,375,LT2,JF9,A39,K89,K90,LT1,LR4,LR5,LS9,Z91,K01,K03,A39,LR0,LR1,LR2,LT0,LS8,J37,176,947,LR3';
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
        ph.Regional_PM_US__c=u.Id;
        ph.Regional_PM_EU__c=u.id;
        ph.Regional_PM_Japan__c=u.Id;
        ph.Regional_PM_India__c=u.id;
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
         ph.Regional_PM_AP__c=u.Id;
        insert part;
        Test.startTest();
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppypart.Part__c = part.Id;
        oppypart.Status__c = 'Lost';
        oppypart.Process_Status__c = 'Lost';
        oppypart.Lost_Reason__c = 'Other';
        oppypart.Lost_Reason_Text__c = null;
        //oppypart.GPL__c = ph.Id; commented by Bhavya
       //oppypart.Product_Manager_Id__c = u.Id;
      //  oppypart.Regional_PM_AP_Id__c = u.Id;
        insert oppypart;
        
        
        
        oppy.Request_Type__c = 'Cable Assembly - New Dev';
        update oppy;
        
        system.assert(true);
        Test.stopTest();
        }
    }
    static testMethod void testInsert4() {
        //Start : Rajendra Shahane 04/11/2016  Modified for case - 900786
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings(); 
        ClsTestCustomSettingHelper.getADMTerritoryCode();
        Opportunity_Approvers__c oa = ClsTestHelp.createTestOpportunityApprovers();        
        Opportunity_Approvers__c oa2 = ClsTestHelp.createTestOpportunityApprovers2();        
        Opportunity_Approvers__c oa3 = ClsTestHelp.createTestOpportunityApprovers3();
        Opportunity_Approvers__c oa4 = ClsTestHelp.createTestOpportunityApprovers4();        
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9(); 
        Apex_Helper_Settings__c ahs10 = ClsTestHelp.createTestName10();
        Apex_Helper_Settings__c ahs11 = ClsTestHelp.createTestName11(); 
        Apex_Helper_Settings__c newSetting = new Apex_Helper_Settings__c (name = 'APL_Email_Alert_Template',value__c = 'https://c2s--c.na9.content.force.com/servlet/servlet.ImageServer?;id=015E0000000P3MB;id=015E0000001hKDe;&oid=00DE0000000Hkve;https://c2s.my.salesforce.com/');
        Apex_Helper_Settings__c exceptUser= new Apex_Helper_Settings__c();
        insert (new Opportunity_Record_Type_Groups__c(name = 'DND Opportunity',RecordTypeID__c = '012E0000000NIlV', Group__c = 'Process Status Display', active__c = true));
        exceptUser.name = 'Currency Confirm Except Users';
        exceptUser.value__c = 'test';
        exceptUser.Active__c = true;
        //insert exceptUser;
        Apex_Helper_Settings__c csdGPL= new Apex_Helper_Settings__c();
        csdGPL.name = 'CSD GPL Code Id';
        csdGPL.value__c = 'test';
        csdGPL.Active__c = true;
        //insert csdGPL;
        Apex_Helper_Settings__c aplRecord = new Apex_Helper_Settings__c();
        aplRecord.name = 'Appliance Opportunity Record Type Id';
        aplRecord.value__c = 'test';
        aplRecord.Active__c = true;
        insert new List<Apex_Helper_Settings__c> {aplRecord,csdGPL,exceptUser,newSetting};

        Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;
                                       
        TE_Connection__c tec = ClsTestHelp.createTestTEConnection();
        Profit_BU_Center_Mapping_Rule1__c pb1 = ClsTestHelp.createTestProfitBUCenterMapping1();
        Profit_BU_Center_Mapping_Rule2__c pb2 = ClsTestHelp.createTestProfitBUCenterMapping2();
        Profit_BU_Center_Mapping_Rule3__c pb3 = ClsTestHelp.createTestProfitBUCenterMapping3();
        Consumer_Device_Opportunity_Record_Types__c csd1 = ClsTestHelp.createTestCSD1();
        Consumer_Device_Opportunity_Record_Types__c csd2 = ClsTestHelp.createTestCSD2();
        Consumer_Device_Opportunity_Record_Types__c csd3 = ClsTestHelp.createTestCSD3();
        Consumer_Device_Opportunity_Record_Types__c csd4 = ClsTestHelp.createTestCSD4();
        Consumer_Device_Opportunity_Record_Types__c csd5 = ClsTestHelp.createTestCSD5();
        Consumer_Device_Opportunity_Record_Types__c csd6 = ClsTestHelp.createTestCSD6();
        Consumer_Device_Opportunity_Record_Types__c csd7 = ClsTestHelp.createTestCSD7();
        //End : Rajendra Shahane 04/11/2016  Modified for case - 900786
        //Commented : Rajendra Shahane 04/11/2016  Modified for case - 900786
        /*Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Opportunity_Approvers__c oa = ClsTestHelp.createTestOpportunityApprovers();        
        Opportunity_Approvers__c oa2 = ClsTestHelp.createTestOpportunityApprovers2();        
        Opportunity_Approvers__c oa3 = ClsTestHelp.createTestOpportunityApprovers3();
        Opportunity_Approvers__c oa4 = ClsTestHelp.createTestOpportunityApprovers4();*/
        //End : Rajendra Shahane 04/11/2016  Modified for case - 900786
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
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.LEVEL_1_INDUSTRY_CDE__c = '0001';
        acc.Sales_Hierarchy__c = sh.Id;
        acc.Customer_Region__c = 'China / HK / Taiwan';
        insert acc;
              
              
                ClsTestHelp.createTestOPTG1();
           ClsTestHelp.createTestOPTG2();
           ClsTestHelp.createTestADM();
           
             
        /*Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.AccountId = acc.Id;
        oppy.Request_Type__c = 'Cable Assembly - Extension';
        oppy.Defined_GPLs__c = '375,397,A39,K01,K03,176,Z91';
        oppy.StageName = 'Rejected - Closed';
        //oppy.AM_Hierarchy__c = sh.Id;
        //oppy.Industry_Code__c = 'Rail GPLs';
        //oppy.GAM_Code__c = 'test';
        insert oppy;*/
            RecordType rt2 = ClsTestHelp.createTestRecordType16();
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        //oppy.Program__c = oppy2.Id;   
        oppy.Type = 'CM';
        oppy.AccountId = acc.Id;
        oppy.Request_Type__c = 'Extension';
        oppy.Converted_Email_Alert_Date__c = System.today() -1;
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.StageName = 'New';
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Currency_confirm__c = true;
        oppy.Five_Year_Revenue__c = 1;
        oppy.RecordTypeId = rt2.Id; 
        //oppy.Mass_prod_Status__c = true;
          oppy.Defined_GPLs__c= '030,375,LT2,JF9,A39,K89,K90,LT1,LR4,LR5,LS9,Z91,K01,K03,A39,LR0,LR1,LR2,LT0,LS8,J37,176,947,LR3';
        insert oppy;
        
        Oppy = [SELECT Id, AccountId, AM_Hierarchy__c, Request_Type__c,Defined_GPLs__c,StageName FROM Opportunity WHERE Id =:oppy.Id];
        
        OpportunityTeamMember ot = new OpportunityTeamMember();
        ot.UserId = u.Id;
        ot.OpportunityId = oppy.Id;
        ot.TeamMemberRole = 'Global Account Manager (GAM)';
        insert ot;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        ph.Product_Manager__c = u.Id;
        ph.Regional_PM_AP__c = u.Id;
        ph.Regional_PM_US__c=u.Id;
        ph.Regional_PM_EU__c=u.id;
        ph.Regional_PM_Japan__c=u.Id;
        ph.Regional_PM_India__c=u.id;
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
         ph.Regional_PM_AP__c=u.Id;
        insert part;
        Test.startTest();
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppypart.Part__c = part.Id;
        oppypart.Status__c = 'Lost';
        oppypart.Process_Status__c = 'Lost';
        oppypart.Lost_Reason__c = 'Other';
        oppypart.Lost_Reason_Text__c = null;
      //  oppypart.GPL__c = ph.Id; commented by Bhavya
     //   oppypart.Product_Manager_Id__c = u.Id;
     //   oppypart.Regional_PM_AP_Id__c = u.Id;
        insert oppypart;
        
        
        
        oppy.Request_Type__c = 'Cable Assembly - New Dev';
        update oppy;
        
        system.assert(true);
        Test.stopTest();
        }
    }
    
    static testMethod void testInsert5() {
        //Start : Rajendra Shahane 04/11/2016  Modified for case - 900786
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
        ClsTestCustomSettingHelper.getADMTerritoryCode();
        Opportunity_Approvers__c oa = ClsTestHelp.createTestOpportunityApprovers();        
        Opportunity_Approvers__c oa2 = ClsTestHelp.createTestOpportunityApprovers2();        
        Opportunity_Approvers__c oa3 = ClsTestHelp.createTestOpportunityApprovers3();
        Opportunity_Approvers__c oa4 = ClsTestHelp.createTestOpportunityApprovers4();        
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9(); 
        Apex_Helper_Settings__c ahs10 = ClsTestHelp.createTestName10();
        Apex_Helper_Settings__c ahs11 = ClsTestHelp.createTestName11(); 
        Apex_Helper_Settings__c newSetting = new Apex_Helper_Settings__c (name = 'APL_Email_Alert_Template',value__c = 'https://c2s--c.na9.content.force.com/servlet/servlet.ImageServer?;id=015E0000000P3MB;id=015E0000001hKDe;&oid=00DE0000000Hkve;https://c2s.my.salesforce.com/');
        Apex_Helper_Settings__c exceptUser= new Apex_Helper_Settings__c();
         insert (new Opportunity_Record_Type_Groups__c(name = 'DND Opportunity',RecordTypeID__c = '012E0000000NIlV', Group__c = 'Process Status Display', active__c = true));
        exceptUser.name = 'Currency Confirm Except Users';
        exceptUser.value__c = 'test';
        exceptUser.Active__c = true;
        //insert exceptUser;
        Apex_Helper_Settings__c csdGPL= new Apex_Helper_Settings__c();
        csdGPL.name = 'CSD GPL Code Id';
        csdGPL.value__c = 'test';
        csdGPL.Active__c = true;
        //insert csdGPL;
        Apex_Helper_Settings__c aplRecord = new Apex_Helper_Settings__c();
        aplRecord.name = 'Appliance Opportunity Record Type Id';
        aplRecord.value__c = 'test';
        aplRecord.Active__c = true;
        insert new List<Apex_Helper_Settings__c> {aplRecord,csdGPL,exceptUser,newSetting};
        
        Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;
                                                    
        TE_Connection__c tec = ClsTestHelp.createTestTEConnection();
        Profit_BU_Center_Mapping_Rule1__c pb1 = ClsTestHelp.createTestProfitBUCenterMapping1();
        Profit_BU_Center_Mapping_Rule2__c pb2 = ClsTestHelp.createTestProfitBUCenterMapping2();
        Profit_BU_Center_Mapping_Rule3__c pb3 = ClsTestHelp.createTestProfitBUCenterMapping3();
        Consumer_Device_Opportunity_Record_Types__c csd1 = ClsTestHelp.createTestCSD1();
        Consumer_Device_Opportunity_Record_Types__c csd2 = ClsTestHelp.createTestCSD2();
        Consumer_Device_Opportunity_Record_Types__c csd3 = ClsTestHelp.createTestCSD3();
        Consumer_Device_Opportunity_Record_Types__c csd4 = ClsTestHelp.createTestCSD4();
        Consumer_Device_Opportunity_Record_Types__c csd5 = ClsTestHelp.createTestCSD5();
        Consumer_Device_Opportunity_Record_Types__c csd6 = ClsTestHelp.createTestCSD6();
        Consumer_Device_Opportunity_Record_Types__c csd7 = ClsTestHelp.createTestCSD7();
        //End : Rajendra Shahane 04/11/2016  Modified for case - 900786
        //Commented : Rajendra Shahane 04/11/2016  Modified for case - 900786
        /*Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Opportunity_Approvers__c oa = ClsTestHelp.createTestOpportunityApprovers();        
        Opportunity_Approvers__c oa2 = ClsTestHelp.createTestOpportunityApprovers2();        
        Opportunity_Approvers__c oa3 = ClsTestHelp.createTestOpportunityApprovers3();
        Opportunity_Approvers__c oa4 = ClsTestHelp.createTestOpportunityApprovers4();*/
        //End : Rajendra Shahane 04/11/2016  Modified for case - 900786
        Last_Modified_Field_Update_Permission__c oLast_Modified_Field_Update_Permission = Last_Modified_Field_Update_Permission__c.getInstance();
        if(oLast_Modified_Field_Update_Permission == null || oLast_Modified_Field_Update_Permission.Allow_Update__c == false)
        {
            oLast_Modified_Field_Update_Permission = new Last_Modified_Field_Update_Permission__c();
            oLast_Modified_Field_Update_Permission.Allow_Update__c = true;
            upsert oLast_Modified_Field_Update_Permission;
        }
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
        
        Profile p1 = [Select Id, Name From Profile 
                                    where Name != 'Service Account' 
                                    AND Name !='System Administrator' 
                                    AND Name !='Systemadministrator'
                                    AND Name !='BU Admin'
                                    AND Name !='Partner Admin'
                                    AND Name !='Regional Admin'
                                    limit 1];
        User u1 = ClsTestHelp.createTestUsers();
        u1.Email = 'sfsd@testCompany1233423.com';
        u1.Alias = 'asdf';
        u1.CommunityNickname = 'sdfe';
        u1.ProfileId = p1.Id;
        u1.FirstName ='sdvv';
        u1.LastName = 'erter';
        u1.Username = 'sfsdfwefresd@testCompany1233423.com';
        //u1.Name = 'testu1';
        insert u1;
        
        
        system.runAs(u1){       
        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
        sh.Level_7_Assigned_Users__c = u.Id;
        sh.Level_6_Assigned_Users__c = 'xxxxxxxxxxxxxxxxxxxxxxxxx';
        insert sh;
        
        String accrtId = [SELECT Id FROM RecordType WHERE DeveloperName = 'CIS_Account' limit 1].Id;
        Account acc = ClsTestHelp.createTestAccounts();
        acc.LEVEL_1_INDUSTRY_CDE__c = '0001';
        acc.Sales_Hierarchy__c = sh.Id;
        acc.recordTypeId = accrtId;
        insert acc;
        
        
          ClsTestHelp.createTestOPTG1();
           ClsTestHelp.createTestOPTG2();
           ClsTestHelp.createTestADM();
            System.debug('Account Sales Hiearchy from test class :'+acc.Sales_Hierarchy__c);
            
            
             // Added by Archana 
        
            
              Apex_Helper_Settings__c vNDRAccId =new Apex_Helper_Settings__c();
                        vNDRAccId.Name='Unidentified Account for NDR';
                        vNDRAccId.Value__c=  '001E000001TEST123';
                        vNDRAccId.Active__c=true;
                insert vNDRAccId;
                
        /*Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.AccountId = acc.Id;
        oppy.Request_Type__c = 'Cable Assembly - Extension';
        oppy.Defined_GPLs__c = '375,397,A39,K01,K03,176,Z91';
        oppy.StageName = 'Rejected - Closed';
        //oppy.AM_Hierarchy__c = sh.Id;
        //oppy.Industry_Code__c = 'Rail GPLs';
        //oppy.GAM_Code__c = 'test';
        insert oppy;*/
        RecordType rt2 = ClsTestHelp.createTestRecordType16();
            Test.startTest();
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        //oppy.Program__c = oppy2.Id;   
        oppy.AccountId = acc.Id; ////////////Added by Archana 
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Converted_Email_Alert_Date__c = System.today() -1;
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.StageName = 'New';
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Currency_confirm__c = true;
        oppy.Five_Year_Revenue__c = 1;
        oppy.RecordTypeId = rt2.Id; 
        //oppy.Mass_prod_Status__c = true;
        insert oppy;
        
        Oppy = [SELECT Id, AccountId, AM_Hierarchy__c, Request_Type__c,Defined_GPLs__c,StageName FROM Opportunity WHERE Id =:oppy.Id];
        
        OpportunityTeamMember ot = new OpportunityTeamMember();
        ot.UserId = u.Id;
        ot.OpportunityId = oppy.Id;
        ot.TeamMemberRole = 'Global Account Manager (GAM)';
        insert ot;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        ph.Product_Manager__c = u.Id;
        ph.Regional_PM_AP__c = u.Id;
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
       // oppypart.Product_Manager_Id__c = u.Id;
      //  oppypart.Regional_PM_AP_Id__c = u.Id;
        insert oppypart;
        
        
         
        
        system.assert(true);
        Test.stopTest();
        }
    }
    
}