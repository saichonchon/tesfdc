/**
*  This test class used to test class ExtRecalculateBudget.
*
@author Bin Yuan
@created 2014-01-20
@version 1.0   
@since 28.0
*
@changelog
* coverage % 
* 
* 
2014-01-20 Bin Yuan <bin.yuan@itbconsult.com>
* - Created
*/
@isTest(seeAllData = false) 
private class CtrlRSMChangeScreen_Test {
	static testMethod void myUnitTest1() {
		
		Forecast_Definition__c fDef1 = new Forecast_Definition__c();
		fDef1.RSM__c = Userinfo.getUserId();
		fDef1.GSM__c = Userinfo.getUserId();
		fDef1.Category__c = 'A';
		fDef1.Name = 'Alstom Rail';
		fDef1.RSM_Se_quence__c = 1;
		fDef1.Subtotal__c = false;
		fDef1.Region__c = 'EMEA';
		fDef1.Profit_Center__c = 'Rail';
		fDef1.GSM_Name__c = 'Alstom Rail';
		fDef1.GSM_Sequence__c = 1;
		fDef1.IND_Customer_Classification__c = 'A';
		fDef1.RSM_Forecast_Category_Includes__c = '';
		fDef1.RSM_Forecast_Category_Excludes__c = '';
		fDef1.Industrial_Sales_Team_Include__c = '';
		fDef1.Category_Label__c = 'A';
		insert fDef1;
		//insert manager forecast for rsm
		Manager_Forecast__c mf = new Manager_Forecast__c();
		mf.Billings_USD__c = 1234;
		mf.Bookings_USD__c = 1234;
		mf.Forecast_USD__c = 1234;
		mf.AM_Forecast_USD__c = 1234;
		mf.Forecast_Definition__c = fDef1.id;
		mf.Previous_Month_Forecast_Document__c = 1234;
		mf.Fiscal_Month__c = 1;
		mf.Fiscal_Year__c = '1234';
		mf.Comment__c = '<comments><comment value="100">Comment about a positive forecast risk</comment><comment value="-80">Comment about a negative forecast risk</comment></comments>';
		insert mf;
        
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
    	
    	RecordType rt2 = ClsTestHelp.createTestRecordType8();
    	List<User> lstUser = [Select Id,Te_Network_Id__c from user where Id =:userinfo.getUserId()];
        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
        if(lstUser != null && lstUser.size() >0)
        {
            sh.Level_4_Assigned_User_Network_Ids__c = lstUser[0].Te_Network_Id__c;
            sh.Level_5_Assigned_User_Network_Ids__c = lstUser[0].Te_Network_Id__c;
            sh.Level_6_Assigned_User_Network_Ids__c = lstUser[0].Te_Network_Id__c;
            sh.Level_7_Assigned_User_Network_Ids__c = lstUser[0].Te_Network_Id__c;
        }
        
        insert sh;
        
        Account acc2 = ClsTestHelp.createTestAccounts();
        acc2.RecordTypeId = rt2.Id;
        acc2.Name = 'Xxx1';
        acc2.Account_Manager__c = UserInfo.getUserId();
        acc2.SALES_TERRITORY_CDE__c = 'A103754';
        acc2.Sales_Hierarchy__c = sh.Id;
        acc2.Legally_Restricted__c = true;
        acc2.Individually_Planned__c = true;
        acc2.Individually_Forecasted__c = true;
        acc2.Customer_Classification__c = 'A';
    	acc2.Type = 'Global Account';
    	acc2.GAMCD__c = '1000';
    	acc2.SALES_TERRITORY_CDE__c = 'A004841';
    	acc2.Account_Manager__c = userinfo.getUserId();
        acc2.IND_Billing_Region__c = null;
        insert acc2;
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Account_Manager__c = UserInfo.getUserId();
        acc.RecordTypeId = rt2.Id;
        acc.SALES_TERRITORY_CDE__c = 'A103754';
        acc.Sales_Hierarchy__c = sh.Id;
        acc.Legally_Restricted__c = true;
        acc.Individually_Planned__c = false;
        acc.Individually_Forecasted__c = true;
        acc.Plan_Group_Account__c = acc2.Id;
        acc.Plan_Group_Id__c = acc2.Id;
        acc.Customer_Classification__c = 'A';
    	acc.Type = 'Global Account';
    	acc.GAMCD__c = '1000';
    	acc.SALES_TERRITORY_CDE__c = 'A004841';
    	acc.IND_Billing_Region__c = null;//'test';
    	//acc.Account_Manager__c = acctMger.Id;
        insert acc;
        
		//insert bbb monthly records for rsm
    	BBB_Month_Bill_Book_Cust__c bbb = new BBB_Month_Bill_Book_Cust__c();
    	bbb.Customer__c = acc.Id;
    	bbb.Fiscal_Year__c = '2014';
    	bbb.Fiscal_Month__c = 1;
    	bbb.Bill_Type__c = 'Direct';
    	bbb.Budget_Direct__c = 1;
    	bbb.Budget_POS__c = 2;
    	bbb.Budget_CMA__c = 3;
    	bbb.Budget_TBR_NY__c = 12;
    	bbb.Budget_Document_Currency__c = 11; 
    	bbb.CurrencyIsoCode = 'EUR';
    	bbb.Monthly_BBB_External_Key__c = null;
    	bbb.Is_Comment__c = true;
    	bbb.IND_Profit_Centre_Groups__c = 'abc';
    	bbb.SAP_Profit_Center_Group_Code__c = 'G0123';
    	bbb.Comment__c = '<comments><comment value="100">Comment about a positive forecast risk</comment><comment value="-80">Comment about a negative forecast risk</comment></comments>';
    	//insert bbb;
    	BBB_Month_Bill_Book_Cust__c bbb2 = new BBB_Month_Bill_Book_Cust__c();
    	bbb2.Customer__c = acc.Id;
    	bbb2.Fiscal_Year__c = '2014';
    	bbb2.Fiscal_Month__c = 2;
    	bbb2.Bill_Type__c = 'Direct';
    	bbb2.Budget_Direct__c = 1;
    	bbb2.Budget_POS__c = 2;
    	bbb2.Budget_CMA__c = 3;
    	bbb2.Budget_TBR_NY__c = 12;
    	bbb2.Budget_Document_Currency__c = 11; 
    	bbb2.CurrencyIsoCode = 'EUR';
    	bbb2.Monthly_BBB_External_Key__c = null;
    	bbb2.Is_Comment__c = true;
    	bbb2.IND_Profit_Centre_Groups__c = 'abc';
    	bbb2.SAP_Profit_Center_Group_Code__c = 'G0123';
    	bbb2.Is_Comment__c = true;
    	bbb2.IND_Profit_Centre_Groups__c = 'test';
    	bbb2.Comment__c = '<comments><comment value="100">Comment about a positive forecast risk</comment><comment value="-80">Comment about a negative forecast risk</comment></comments>';
        insert new List<BBB_Month_Bill_Book_Cust__c>{bbb, bbb2};
		Test.startTest();
		
		CtrlRSMChangeScreen cls = new CtrlRSMChangeScreen();
		cls.getColorConfig();
		cls.viewType = 'ProfitCenterView';
		cls.changeScreen();
		cls.getThis();
		
		CtrlRSMChangeScreen.LocaleConfig lc = new CtrlRSMChangeScreen.LocaleConfig();
        
        CtrlRSMChangeScreen.ColorConfig CC = new CtrlRSMChangeScreen.ColorConfig();
        CC.colorName = 'red';        CC.maxValue = 10.00;        CC.minValue = 10.00;
        
		CtrlRSMChangeScreen.RSMDefinitionItem rDef = new CtrlRSMChangeScreen.RSMDefinitionItem();
        rDef.id = 'test';rDef.name = 'test';rDef.category = 'test';rDef.sequence = 10.00;rDef.label = 'test';rDef.subtotal = true;rDef.profitCenter = 'test';
        rDef.categoryInclude = 'Test';rDef.categoryExclude = 'test';rDef.industrialSalesTeamInclude = 'test';
        
		CtrlRSMChangeScreen.RSMForecastItem rFC = new CtrlRSMChangeScreen.RSMForecastItem();
        rfc.billings = 10.00; rfc.bookings = 10.00; rfc.rsmForecast  = 10.00; rfc.asmForecast = 10.00; rfc.definition  = '10.00'; rfc.fiscalDate = '10.00';
		
        cls.acctId4Comment = acc.Id;
		cls.year4Comment = '2014';
		cls.month4Comment = 2;
        
        map<String, String> map_viewType = cls.map_viewType;
		cls.getComments();
        
		Test.stopTest();
	}
}