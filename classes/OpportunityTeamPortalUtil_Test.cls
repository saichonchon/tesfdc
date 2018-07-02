/**************************************************************************************************************************************************
Name:  OpportunityTeamPortalUtil_Test
Copyright © 2015 TE Connectivity
===================================================================================================================================================
Purpose: Test class for OpportunityTeamPortalUtil
---------------------------------------------------------------------------------------------------------------------------------------------------       
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
Version Developer          Date       Detail                                  Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
1.0 Phil Hiemstra     10/2/2015 Initial Development            
**************************************************************************************************************************************************/
@isTest
(SeeAllData=true)
public class OpportunityTeamPortalUtil_Test {
    
    public static testMethod void MytestTrigger() {
        
        Test.startTest();
        
        // User Record
        Profile p = [SELECT Id FROM Profile WHERE Name='Channel Distributor Portal User']; 
        Profile pc = [SELECT Id FROM Profile WHERE Name='Channel Standard User']; 
        
        User uChannel = new User(GIBU__c='Channel', Alias = 'standt', Email='ttOpportunityTeamPortalUtil_Test@testorg.com', EmailEncodingKey='UTF-8', LastName='Tt', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = pc.Id, TimeZoneSidKey='America/Los_Angeles', UserName='tst03@test.com.OpportunityTeamPortalUtil_Test');
        insert uChannel;
        /*
Contact c = new Contact();
c.LastName = 'Testing';
insert c;
*/
        User uPortal = new User(GIBU__c='Channel', Alias = 'standt', Email='testOpportunityTeamPortalUtil_Test@testorg.com', EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = pc.Id, TimeZoneSidKey='America/Los_Angeles', UserName='tst01@test.com.OpportunityTeamPortalUtil_Test');
        
        insert uPortal;
        
        System.runAs(new User(Id = Userinfo.getUserId())){
        
            Account acc = ClsTestHelp.createTestAccounts();
            RecordType rt2 = ClsTestHelp.createTestRecordType();
            
            acc.Name = 'axx';
            acc.RecordTypeId = rt2.Id;
            insert acc;
            
            //Opportunity Record types
            Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
            Map<String,Schema.RecordTypeInfo> OpportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
            Id ChannelSalesRTId = OpportunityRecordTypeInfo.get('Channel- Sales Opportunity').getRecordTypeId();
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.AccountId = acc.Id;
            oppy.RecordTypeId = ChannelSalesRTId;
            oppy.Portal_Channel_User__c = uChannel.Id;
            oppy.Portal_Converting_User__c = uPortal.Id;
            oppy.Portal_Create_Opp_Team__c = true;
            oppy.StageName = 'Concept';
            insert oppy;
            
            List<Id> opportunityIds = new List<Id>();
            opportunityIds.add(oppy.Id);
            OpportunityTeamPortalUtil.createPortalOppTeam(opportunityIds);
            
        }
        Test.stopTest();
    }
}