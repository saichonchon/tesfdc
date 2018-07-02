@isTest(seeAllData=false)
private class TestFundClaim {
	
	@testSetup static void createConfig(){
		ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
        ClsTestCustomSettingHelper.getPMV_Sales_Stage_Setting();
        ClsTestCustomSettingHelper.getPMV_Stage_Config();
        ClsTestCustomSettingHelper.getADMTerritoryCode();
        Channelinsightdata_test.Channelinsightdata_test();
        ClsTestCustomSettingHelper.getBestPriceWebspeedSetting();
        ClsTestHelp.createTestOPTG4();
	}
	
	static testMethod void TestFundClaim() {
		Profile profile = [select Id from Profile limit 1];
	                             
	    User user = new User(
		    Username = 'klmn@jktech.com',
		    Email = 'abc@jktech.com',
		    LastName = 'xyz@jktech.com',
		    Alias = 'test',
		    CommunityNickname='TestTrigger',
		    ProfileID = profile.id,
		    LocaleSidKey = 'en_US',
		    LanguageLocaleKey = 'en_US',
		    TimeZoneSidKey = 'America/Los_Angeles',
		    EmailEncodingKey = 'UTF-8'
	    );
		try {        
	        insert user;
		} catch(Exception e) {}  
		Account accObj = ClsTestHelp.createTestAccounts();
        accObj.Source_System__c = 50;
    	accObj.AccountNumber = '123456';
        insert accObj;
	    SFDC_Budget__c Budget = new SFDC_Budget__c();
	    Budget.Account__c = accObj.id;
	    insert Budget;
	    
	    SFDC_MDF__c Fundrequest = new SFDC_MDF__c();
	    Fundrequest.Account__c = accObj.id;
	    Fundrequest.Budget__c = Budget.id;
	    Fundrequest.Partner_Owner__c = user.id;
	    insert Fundrequest;	
	    SFDC_MDF_Claim__c SfdcClaim = new SFDC_MDF_Claim__c();
		SfdcClaim.Account__c = accObj.id;
		SfdcClaim.Budget__c = Budget.id;
		SfdcClaim.Fund_Request__c = Fundrequest.id;
		SfdcClaim.Remit_to__c = accObj.id;
		SfdcClaim.Partner_Owner__c = user.id;
		insert sfdcClaim;
		
	    Test.setCurrentPageReference(new PageReference('Page.FundClaimPDF')); 
		System.currentPageReference().getParameters().put('id',sfdcClaim.id);
		//ApexPages.StandardController controller=new ApexPages.StandardController(sfdcClaim);
		// FundClaim Fund=new FundClaim(sfdcClaim);
	    FundClaim Controller = new FundClaim();
	    //Controller.getClaimDetails();
	    Controller.anzDateFormat(system.now(), system.now());
	    Controller.getDateformat();
	    Controller.getDateformat1();
	}
	
}