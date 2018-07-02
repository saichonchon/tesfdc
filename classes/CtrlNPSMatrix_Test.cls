/**
*	Test class for class CtrlNPSMatrix.
*
@author Yuanyuan Zhang
@created 2013-10-23
@version 1.0
@since 29.0
*
@changelog
* 2013-10-23 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>
* - Created
*- Test coverage 92%
Rajendra Shahane 03/29/2016  Modified for case - 900703
*/
@isTest(seealldata = false)
private class CtrlNPSMatrix_Test 
{
	static testMethod void testgetMatrixDataMethod1() 
    {
         //Start: Rajendra Shahane Modified for case - 900703
        ClsTestCustomSettingHelper.getCCPTriggerSettings();
        //End: Rajendra Shahane Modified for case - 900703
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        
        
        account a = clstesthelp.createTestAccounts();
        a.AccountNumber ='0000:00000000';
        a.WWCORPACCT__c ='00000000';
        a.BillingCountry='CN';
        a.Account_Manager__c = UserInfo.getUserId();
        a.NPS_Score__c = 10;
        a.OwnerId = UserInfo.getUserId();
        
        insert new list<account>{a};

        Product_Hierarchy__c prodH = new Product_Hierarchy__c(Name = 'A00', CBC1__c = '99999', CBC1_Description__c = 'Test Produce Hierarchy');
        insert prodH;
                
        Part__c part1 = new Part__c(Name = '0123456879', Product_Hierarchy__c = prodH.id);        
        Part__c part2 = new Part__c(Name = '9-9999999-9', Product_Hierarchy__c = prodH.id);
        insert new list<Part__c > {part1, part2};
        
        BBB_Year_Bill_Book_Cust_PN__c bbbtemp = new BBB_Year_Bill_Book_Cust_PN__c(part__c = part1.id, year__c = '2015', customer__c = a.id, Bill_Year_to_Date_Amount_USD__c = 1000, Bill_Year_To_Date_Cost_Amount__c = 1000, Bill_Prior_Year_to_Date_Amount_USD__c = 1000);
        insert bbbtemp;
        Campaign oCampaign = new Campaign(Name = 'testcampaign', StartDate = date.today().adddays(-10), EndDate = date.today(), Status = 'Completed' );
        insert oCampaign;
        contact ocontact = new contact(lastname = 'testlastname', email = 'test@ctrlNPSMatrix.com', accountid = a.id, Survey_Attended_Date__c = date.today().adddays(-2));
        insert ocontact;
        campaignmember ocampaignmember = new campaignmember(campaignID = ocampaign.id, contactid = ocontact.id);
        insert ocampaignmember;
		test.startTest();
            CtrlNPSMatrix cm = new CtrlNPSMatrix();
        
            cm.campaignTypeApp = 'NPS IND';
            cm.acc4choose = new Account();
            cm.acc4choose.Customer_Classification__c = 'A';
            cm.acc4choose.GAMCD__c = '';
            cm.acc4choose.AccountNumber = '';
            cm.selectedRegion = 'North America';
            cm.selectedIndustry = 'A&C';
            
        	cm.getIndustryOption();
            cm.getCampaignNameOption();
            cm.getRegionOption();
        	cm.getIndustryOption();
            cm.calType = 'prof';
            cm.getMatrixData();
        
            cm.acc4choose = new Account();
            cm.acc4choose.GAMCD__c = '123';
            cm.acc4choose.AccountNumber = '456';
            cm.getMatrixData();
            
            cm.calType = 'growth';
            cm.getMatrixData();
         	CtrlNPSMatrix cm2 = new CtrlNPSMatrix();
			cm2.acc4choose = new Account();
        	cm2.map_accId_allShownAccount = new map<id, Account>();
        	cm2.map_accId_allShownAccount.put(a.ID, a);

        	cm2.getMatrixData();
        	cm2.calType = 'prof';
        	cm2.getMatrixData();
            CtrlNPSMatrix.accountPoint oaccountPoint = new CtrlNPSMatrix.accountPoint();
		test.stopTest();
	}
}