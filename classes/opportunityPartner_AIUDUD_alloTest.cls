/**
*  This used as test class for opportunityPartner_AIUDUD_calOppyAllocation
*
@author Nelson Zheng ,
@created 11/17/2015
@changelog
Rajendra Shahane 04/11/2016  Modified for case - 900786
*/

@isTest(seealldata=false)
private class opportunityPartner_AIUDUD_alloTest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        // Start : Rajendra Shahane 04/11/2016  Modified for case - 900786
		ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
		// End: Rajendra Shahane 04/11/2016  Modified for case - 900786
        Last_Modified_Field_Update_Permission__c oLast_Modified_Field_Update_Permission = Last_Modified_Field_Update_Permission__c.getInstance();
        if(oLast_Modified_Field_Update_Permission == null || oLast_Modified_Field_Update_Permission.Allow_Update__c == false)
        {
            oLast_Modified_Field_Update_Permission = new Last_Modified_Field_Update_Permission__c();
            oLast_Modified_Field_Update_Permission.Allow_Update__c = true;
            upsert oLast_Modified_Field_Update_Permission;
        }

        /*Opportunity_Record_Type_Groups__c a = new Opportunity_Record_Type_Groups__c();
        a.name= 'DND Opportunity';
        a.Active__c = true;
        a.RecordTypeID__c = '012c00000008oxY';
        insert a;*/
        RecordType rt8 = ClsTestHelp.createTestRecordType8();
        
       Profile p = [Select Id, Name From Profile 
                                    where Name = 'Appliance Engineering User w/Cost'
                                     limit 1];


        
        List<User> uList = new List<User>();
        User u = ClsTestHelp.createTestUsers();
        /*u.Email = 'helloSand0728@testCompany1407281004.com';
        u.FirstName ='Test0728';
        u.LastName = 'User0728';
        u.Alias = 'dpse0728';
        u.CommunityNickname = 'TMD0711';
        u.ProfileId = p.Id;
        u.GIBU__c = 'Appliances';
        u.Username = 'helloSand0728@testCompany1407281004.com';
        */
        u = [select id from user where profileid = :p.id and GIBU__c = :'Appliances' limit 1];
        //uList.add(u);
        
        User u1 = ClsTestHelp.createTestUsers();
        u1.Email = 'helloSand01111@testCompany1407281004.com';
        u1.FirstName ='Test0728';
        u1.LastName = 'User0728';
        u1.Alias = 'dpse012';
        u1.CommunityNickname = 'TMD071';
        u1.ProfileId = p.Id;
        u1.GIBU__c = 'Appliances';
        u1.Te_Network_Id__c = 'TE111111';
        u1.Username = 'helloSand01111@testCompany1407281004.com';
        uList.add(u1);
        
        User u2 = ClsTestHelp.createTestUsers();
        u2.Email = 'helloSand02222@testCompany1407281004.com';
        u2.FirstName ='Test07281';
        u2.LastName = 'User07281';
        u2.Alias = 'dpse44';
        u2.CommunityNickname = 'TMD04';
        u2.ProfileId = p.Id;
        u2.GIBU__c = 'Appliances';
        u2.Te_Network_Id__c = 'TE222222';
        u2.Username = 'helloSand02222@testCompany1407281004.com';
        uList.add(u2);
        insert uList;
        
        RecordType rt2 = ClsTestHelp.createTestRecordType10();
        RecordType rt = ClsTestHelp.createTestRecordType14();
        

       /* Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
        sh.Level_2_Territory_Code__c = '103004';
        sh.Level_7_Default_Owner__c = u1.Id;
        sh.Level_7_Territory_Code__c = '123456';
        insert sh;
        */
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        List<Account> accList = new List<Account>();
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt.Id;
        acc.Type = 'Global Account';
        acc.Industry_Code_Description__c = 'Appliances';
        acc.LEVEL_1_INDUSTRY_CDE__c = '0283';
        acc.owner = u;

        acc.Account_Manager__c = u.Id;
        acc.GAMCD__c = 'G287';
        accList.add(acc); 
        
        Account acc1 = ClsTestHelp.createTestAccounts();
        acc1.RecordTypeId = rt.Id;
        acc1.Type = 'Global Account';
        acc1.Industry_Code_Description__c = 'Appliances';
        acc1.LEVEL_1_INDUSTRY_CDE__c = '0283';
        acc1.owner = u1;
        acc1.Account_Manager__c = u1.Id;
        acc1.GAMCD__c = 'G287';
        accList.add(acc1); 
        
        insert accList;
        
        BBB_Year_Bill_Book_Cust_PN__c oYBBB = new BBB_Year_Bill_Book_Cust_PN__c (Customer__c = acc.id, Part__c = part.id);
        insert oYBBB;
        
        
        Opportunity oppy = new Opportunity();
        oppy.StageName = 'New';
        oppy.AccountId = acc.Id;
        oppy.Account = acc;
        oppy.Name = 'SandKing';
        oppy.CloseDate = date.today();
        oppy.Manufacturing_Start_Date__c = date.today().addMonths(1);
        oppy.RecordTypeId = rt2.Id;            
        oppy.currency_confirm__c = true;
        oppy.Mass_prod_Status__c = true;
        oppy.ownerid = u.id; 

        insert oppy;Test.startTest();
        
        Opportunity_Partner__c oppPartner = new Opportunity_Partner__c();
        oppPartner.Opportunity__c = oppy.Id;
        oppPartner.Account__c = acc.Id;
        oppPartner.Allocation__c = 0;
        oppPartner.Partner_Role__c = 'Distributor';

        insert oppPartner;
        
        Opportunity_Part__c oOpportunity_Part = new Opportunity_Part__c(opportunity__c = oppy.Id, Process_Status__c = 'Production', Part__c = Part.id);
        insert oOpportunity_Part;        
        
        Opportunity_Partner__c oppPartner1 = new Opportunity_Partner__c();
        oppPartner1.Opportunity__c = oppy.Id;
        oppPartner1.Account__c = acc1.Id;
        oppPartner1.Allocation__c = 0;
        oppPartner1.Partner_Role__c = 'Distributor';
        insert oppPartner1;
        
        oppPartner1.Account__c = acc.Id;

        ClsOppyPartUtil.needCriteria = false;

        update oppPartner1;
        
        
        
        //acc1.Account_Manager__c = u2.Id;
        //update acc1;
        
        delete oppPartner1;
        try
        {
            update oppPartner1;
        }
        catch(DMLException ex)
        {
            opportunityPartnertriggerHelper.opportunityPartnerTriggerExceptionhandler(ex, new list<Opportunity_Partner__c>{oppPartner1}, new list<Opportunity_Partner__c>{oppPartner1}, false);
        }
        try
        {
            update oppPartner1;
        }
        catch(DMLException ex)
        {
            opportunityPartnertriggerHelper.opportunityPartnerTriggerExceptionhandler(ex, new list<Opportunity_Partner__c>{oppPartner1}, new list<Opportunity_Partner__c>{oppPartner1}, true);
        }
        
        undelete oppPartner1;
        
        Test.stopTest();
    }
}