/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 */
@isTest
private class TestCls_BatchJDAAccountPartForecast3_ENG {
	private static void createConfigSetting(){
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getADMTerritoryCode();
        ClsTestHelp.createTestOPTG4();
    	Consumer_Device_Opportunity_Record_Types__c cdort1 = ClsTestHelp.createTestCSD1();
    	Consumer_Device_Opportunity_Record_Types__c cdort2 = ClsTestHelp.createTestCSD2();
    	Consumer_Device_Opportunity_Record_Types__c cdort3 = ClsTestHelp.createTestCSD3();
    	Consumer_Device_Opportunity_Record_Types__c cdort4 = ClsTestHelp.createTestCSD4();
    	Consumer_Device_Opportunity_Record_Types__c cdort5 = ClsTestHelp.createTestCSD5();
    	Consumer_Device_Opportunity_Record_Types__c cdort6 = ClsTestHelp.createTestCSD6();
    	Consumer_Device_Opportunity_Record_Types__c cdort7 = ClsTestHelp.createTestCSD7();
	}
    static testMethod void myUnitTest() {
    	createConfigSetting();
        //1.create 2 accounts.  Each account should have 2 opportunities on it
        Account acctBaseBusiness = ClsTestHelp.createTestAccounts();
        acctBaseBusiness.Type = 'CM';
        acctBaseBusiness.AccountNumber = 'testBaseBusiness';
        acctBaseBusiness.INDUSTRY_BUSINESS_CDE__c = '115'; 
        acctBaseBusiness.DD1_Industry_Business_Code__c = '104';
        acctBaseBusiness.DD2_Industry_Business_Code__c = '203';
        acctBaseBusiness.GAMCD__c = 'Test GAMCD1';
        Account acctNoBaseBusiness = ClsTestHelp.createTestAccounts();
        acctNoBaseBusiness.Type = 'CM';
        acctNoBaseBusiness.AccountNumber = 'testNoBaseBusiness';
        acctNoBaseBusiness.INDUSTRY_BUSINESS_CDE__c = '116'; 
        acctNoBaseBusiness.DD1_Industry_Business_Code__c = '105';
        acctNoBaseBusiness.DD2_Industry_Business_Code__c = '204';
        acctNoBaseBusiness.GAMCD__c = 'Test GAMCD2';
        List<Account> list_Accounts = new List<Account>{acctBaseBusiness,acctNoBaseBusiness};
        insert list_Accounts;
        //2.The first should be Is_Base_Business__c=TRUE and the second should be Is_Base_Business__c=FALSE
        RecordType rtEnergy = ClsTestHelp.createTestRecordType32();
        Opportunity oppyBaseBusiness1 = ClsTestHelp.createTestOpportunity();
        
        oppyBaseBusiness1.Is_Base_Business__c = true;
        oppyBaseBusiness1.AccountId = acctBaseBusiness.Id;
        oppyBaseBusiness1.RecordTypeId = rtEnergy.Id;
        oppyBaseBusiness1.Probability__c = '60';
        Opportunity oppyBaseBusiness2 = ClsTestHelp.createTestOpportunity();
        
        oppyBaseBusiness2.Is_Base_Business__c = true;
        oppyBaseBusiness2.AccountId = acctBaseBusiness.Id;
        oppyBaseBusiness2.RecordTypeId = rtEnergy.Id;
        oppyBaseBusiness2.Probability__c = '60';
        Opportunity oppyNoBaseBusiness1 = ClsTestHelp.createTestOpportunity();
        
        oppyNoBaseBusiness1.Is_Base_Business__c = false;
        oppyNoBaseBusiness1.AccountId = acctNoBaseBusiness.Id;
        oppyNoBaseBusiness1.RecordTypeId = rtEnergy.Id;
        oppyNoBaseBusiness1.Probability__c = '60';
        Opportunity oppyNoBaseBusiness2 = ClsTestHelp.createTestOpportunity();
        
        oppyNoBaseBusiness2.Is_Base_Business__c = false;
        oppyNoBaseBusiness2.AccountId = acctNoBaseBusiness.Id;
        oppyNoBaseBusiness2.RecordTypeId = rtEnergy.Id;
        oppyNoBaseBusiness2.Probability__c = '60';
        List<Opportunity> list_Opportunities = new List<Opportunity>{oppyBaseBusiness1,oppyBaseBusiness2,oppyNoBaseBusiness1,oppyNoBaseBusiness2};
        insert list_Opportunities;
        //3.add 2 parts to each opportunity (qty=1 for the first part and Qty=2 for the second part) and set the target Price to be $1000 for the first part and $2000 for the second part.
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial'; 
        insert ph;
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        List<Opportunity_Forecast__c> list_OppyForecasts = new List<Opportunity_Forecast__c>();
        for(Opportunity oppy : list_Opportunities){
        	for(Integer monthNum = 1; monthNum < 19; monthNum++){
		        Date targetDate = System.today().toStartOfMonth().addMonths(monthNum);
		        Opportunity_Forecast__c oppyForecast1 = ClsTestHelp.createTestOpportunityForecasts();
		        oppyForecast1.Opportunity__c = oppy.Id;
		        //oppyForecast1.Part__c = oppypart.Id;
		        oppyForecast1.Amount__c = 50000;
		        oppyForecast1.Actual_Value__c = 50000;
		        oppyForecast1.CurrencyIsoCode = 'USD';
		        oppyForecast1.Confidence_Level__c = '100';
		        oppyForecast1.Fiscal_Month__c = String.valueOf(targetDate.month());
		        //oppyForecast1.Fiscal_Quarter__c = 'Q4';
		        oppyForecast1.Fiscal_Year__c = String.valueOf(targetDate.year());
		        list_OppyForecasts.add(oppyForecast1);
        	}
        }
        insert list_OppyForecasts;
        System.debug('---list_OppyForecasts:::' + list_OppyForecasts);
        Test.startTest();
        //4.Then create OppForecast records for the next 18 months for all 4 opportunitites where the Forecast revenue for each month is $50000.
        List<Opportunity_Part__c> list_OppyParts = new List<Opportunity_Part__c>();
        for(Opportunity oppy : list_Opportunities){
        	Opportunity_Part__c oppyPart = ClsTestHelp.createTestEnergyOpportunityPart();
	        oppyPart.Opportunity__c = oppy.Id;
	        oppyPart.Part__c = part.Id;
	        oppyPart.Offered_Price__c = 1000;
	        oppyPart.Quantity__c = 1;
	        
	        Opportunity_Part__c oppyPart2 = ClsTestHelp.createTestEnergyOpportunityPart();
	        oppyPart2.Opportunity__c = oppy.Id;
	        oppyPart2.Part__c = part.Id;
	        oppyPart2.Offered_Price__c = 2000;
	        oppyPart2.Quantity__c = 2;
	        list_OppyParts.add(oppyPart);
	        list_OppyParts.add(oppyPart2);
        }
        insert list_OppyParts;
        System.debug('---list_OppyParts:::' + list_OppyParts);
        //5.Then verify (System.assert()) that the OppPartForecast records for the first part on the opportunity is always $10000 for each OPF record and that the OPF forecast for the second part if always $40000 (because the fraction of sale for the second part is 80%).
        List<Opportunity_Part_Forecast__c> list_OppyPartForecasts = [SELECT forecast_value2__c , Opportunity_Part__r.Quantity__c
		    														FROM Opportunity_Part_Forecast__c 
		    														WHERE Opportunity_Part__r.Quantity__c = 1 
		    														OR Opportunity_Part__r.Quantity__c = 2];
        System.assert(list_OppyPartForecasts.size() > 0,'The size of listOpportunityPartForecast is not expected');
        for(Opportunity_Part_Forecast__c oppyPartForecast : [SELECT forecast_value2__c , Opportunity_Part__r.Quantity__c
    														FROM Opportunity_Part_Forecast__c 
    														WHERE Opportunity_Part__r.Quantity__c = 1 
    														OR Opportunity_Part__r.Quantity__c = 2]){
    		System.debug('---oppyPartForecast:::' + oppyPartForecast);
    		if(oppyPartForecast.Opportunity_Part__r.Quantity__c == 1){
    			System.assert(oppyPartForecast.forecast_value2__c  == 10000);
    		}else if(oppyPartForecast.Opportunity_Part__r.Quantity__c == 2){
    			System.assert(oppyPartForecast.forecast_value2__c  == 40000);
    		}	        
        }
        //6.run the batch
        
        Cls_BatchJDAAccountPartForecast3_ENG batch = new Cls_BatchJDAAccountPartForecast3_ENG();
        Database.executeBatch(batch);
        Test.stopTest();
    }
}