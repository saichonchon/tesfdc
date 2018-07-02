/**
 *  This test class is used to test ClsBatch_captureBillingWhenPartConv
 *  
 * @author Mingxing Qiu
 * @created 2016-05-06
 * @version 1.0
 * @since 29.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2015-06-12 Mingxing Qiu <Mingxing Qiu@itbconsult.com>
   - Coverage 80%
 * - Created
 *
 */
 
@isTest
private class ClsBatch_captureBillingWhenPartConv_Test {

    static testMethod void myUnitTest() {
    	User user;
    	User user2;
    	for(User tempuser : [SELECT Id, GIBU__c, Profile.Name FROM User where ((Profile.Name = 'Appliance Standard User' and GIBU__c = 'Appliances') or Profile.name = 'System Administrator') and IsActive = true ]) {
    		if(user == null && tempuser.Profile.Name == 'Appliance Standard User' && tempuser.GIBU__c == 'Appliances') {
    			user = tempuser;
    		}
    		if(user2 == null && tempuser.Profile.Name == 'System Administrator') {
    			user2 = tempuser;
    		}
    		if(user != null && user2 != null) {
    			break;
    		}
    	}
    	
    	//user user = [SELECT GIBU__c ,Profile.Name FROM User where Profile.Name = 'Appliance Standard User'and GIBU__c = 'Appliances' and IsActive = true limit 1 ];
    	//user user2 = [SELECT Profile.name FROM User where Profile.name = 'System Administrator' and IsActive = true limit 1 ];
    	
    	ClsTestCustomSettingHelper.getApex_Helper_Settings();
    	ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
    	ClsTestCustomSettingHelper.getOpportunity_Approvers();
    	ClsTestCustomSettingHelper.getTrigger_Configuration();
    	ClsTestCustomSettingHelper.getProfitBUCenterMapping();
    	ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
    	
    	Channelinsightdata_test.Channelinsightdata_test();
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
    	
    	test.startTest();
    	system.runAs(user2) {

    		//RecordType rt = [SELECT Name, Id,BusinessProcessId FROM RecordType where SobjectType='Opportunity' and DeveloperName = 'IND_Engineering_project'];
    		
    		Account acct = new Account();
		 	acct.Name  = 'testAcct';
			acct.Account_Manager__c = user2.Id;
			acct.BillingCountry = 'China';
			insert acct;
			
			Account acct2 = new Account();
		 	acct2.Name  = 'testAcct2';
			acct2.Account_Manager__c = user2.Id;
			acct2.BillingCountry = 'China';
			insert acct2;
			
			//RecordType rt = [SELECT Name, Id,BusinessProcessId FROM RecordType where SobjectType='Opportunity' and DeveloperName = 'IND_Engineering_project'];
        	RecordType rt = Clstesthelp.createPMVTestRecordType3();
        	
        	Opportunity oppy = ClsTestHelp.createTestOpportunity();
	        oppy.Type = 'CM';
	        oppy.RecordTypeId = rt.Id;
	        oppy.Approval_Status_PMV__c = 'New';
	        oppy.PMV_Type__c = 'IND Standard ENG opp';
	        oppy.StageName = 'On Hold';
	        oppy.OwnerId = user.Id;
	        oppy.PMV_Migration_Setup__c = 'OnHold';
	        oppy.Name = 'testjinte';
	        oppy.Level__c = 'Quarterly';
	        insert oppy;
	        
	        
	        Opportunity opp = ClsTestHelp.createTestOpportunity();
	        opp.Type = 'CM';
	        opp.RecordTypeId = rt.Id;
	        opp.Approval_Status_PMV__c = 'New';
	        opp.PMV_Type__c = 'IND Standard ENG opp';
	        opp.StageName = 'On Hold';
	        opp.OwnerId = user.Id;
	        opp.PMV_Migration_Setup__c = 'OnHold';
	        opp.Name = 'testjin';
	        opp.Level__c = 'Monthly';
	        insert opp;
	    	
	    	Product_Hierarchy__c proHieray = new Product_Hierarchy__c();
			insert proHieray;
				
			Part__c part = new Part__c();
			part.Product_Hierarchy__c  = proHieray.Id;
			insert part;
	    	
	    	Opportunity_Partner__c oppyPartner = new Opportunity_Partner__c();
	    	oppyPartner.Opportunity__c = oppy.Id;
	    	oppyPartner.Allocation__c = 100;
	    	oppyPartner.Account__c = acct.Id;
	    	//oppyPartner.isAPLOpp__c = true;
	    	insert oppyPartner;
	    	
	    	Opportunity_Part__c oppyPart = new Opportunity_Part__c();
	        oppyPart.APL_need_to_capture_billing__c = true;
	        oppyPart.APL_need_to_delete_captured_billing__c = true;
	        oppyPart.Opportunity__c = oppy.Id;
	        oppyPart.Initial_12_months__c = null;
	        oppyPart.Part__c = part.Id;
	        oppyPart.Won_Date__c = system.today();
	        insert oppyPart;
	        
	    	
	    	BBB_Year_Bill_Book_Cust_PN__c yearBBB = new BBB_Year_Bill_Book_Cust_PN__c();
	    	yearBBB.Customer__c = acct.Id;
	    	yearBBB.Part__c = part.Id;
	    	yearBBB.APL_need_to_capture_billing__c = false;
	    	insert yearBBB;
	    	ClsBatch_captureBillingWhenbbInsert cls = new ClsBatch_captureBillingWhenbbInsert();
			dataBase.executeBatch(cls);
	    	
	    	//BBB_Year_Bill_Book_Cust_PN__c  bbb = [select id from BBB_Year_Bill_Book_Cust_PN__c where APL_need_to_capture_billing__c = true limit 1] ;
			//insert bbb;
	       
	        
	        Opportunity_Part__c oppyPart2 = new Opportunity_Part__c();
	        oppyPart2.APL_need_to_capture_billing__c = false;
	        oppyPart2.APL_need_to_delete_captured_billing__c = true;
	        oppyPart2.Opportunity__c = opp.Id;
	        oppyPart2.Initial_12_months__c = null;
	        oppyPart2.Part__c = part.Id;
	        oppyPart.Won_Date__c = system.today();
	        insert oppyPart2;
	        
	        
	        APL_Billing_Result_of_Covnerted_Opp__c aplBill = new APL_Billing_Result_of_Covnerted_Opp__c ();
	        aplBill.opportunity__c = oppy.Id;
	        aplBill.Part__c = part.Id;
	        aplBill.Opportunity_Partner__c = acct.Id;
	        insert aplBill;
	        
	        
	        //Select Id,Fiscal_Year__c ,Fiscal_Quarter__c,Fiscal_Month__c,Quantity__c,part__c,Date__c, Amount__c From Opportunity_Forecast__c where part__c in: map_oppypartId_level.keySet() and Date__c > = : minDate order by Date__c
	        //Select Number, Id, StartDate, Type From Period Where type = 'Quarter' And StartDate > = : minDate order by StartDate
	        
	        Opportunity_Forecast__c forec = new Opportunity_Forecast__c();
	        forec.part__c = oppyPart.Id;
	        forec.Opportunity__c = oppy.Id;
	        forec.Date__c = system.today();
	        forec.Fiscal_Year__c = '2016';
	        forec.Fiscal_Quarter__c = '01';
	        forec.Fiscal_Month__c = '01';
	        forec.Amount__c = 100;
	        insert forec;
	        
	        list<Period> list_per = new  list<Period>();
	        for (Period per :[Select Number, Id, StartDate, Type From Period Where type = 'Quarter' And StartDate > = : system.today() order by StartDate]) {
	        	list_per.add(per);
	        	system.debug('::per::'+per);
	        }
	        
	        
	        
	        ClsBatch_captureBillingWhenPartConverted clsy = new ClsBatch_captureBillingWhenPartConverted();
			dataBase.executeBatch(clsy);
	        
	        test.stopTest();
    		
    	}
    	
        
    }
    
    
    static testMethod void myUnitTest2() {
    	User user;
    	User user2;
    	for(User tempuser : [SELECT Id, GIBU__c, Profile.Name FROM User where ((Profile.Name = 'Appliance Standard User' and GIBU__c = 'Appliances') or Profile.name = 'System Administrator') and IsActive = true ]) {
    		if(user == null && tempuser.Profile.Name == 'Appliance Standard User' && tempuser.GIBU__c == 'Appliances') {
    			user = tempuser;
    		}
    		if(user2 == null && tempuser.Profile.Name == 'System Administrator') {
    			user2 = tempuser;
    		}
    		if(user != null && user2 != null) {
    			break;
    		}
    	}
    	
    	//user user = [SELECT GIBU__c ,Profile.Name FROM User where Profile.Name = 'Appliance Standard User'and GIBU__c = 'Appliances' and IsActive = true limit 1 ];
    	//user user2 = [SELECT Profile.name FROM User where Profile.name = 'System Administrator' and IsActive = true limit 1 ];
    	
    	ClsTestCustomSettingHelper.getApex_Helper_Settings();
    	ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
    	ClsTestCustomSettingHelper.getOpportunity_Approvers();
    	ClsTestCustomSettingHelper.getTrigger_Configuration();
    	ClsTestCustomSettingHelper.getProfitBUCenterMapping();
    	ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
    	
    	Channelinsightdata_test.Channelinsightdata_test();
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
    	
    	test.startTest();
    	system.runAs(user2) {

    		//RecordType rt = [SELECT Name, Id,BusinessProcessId FROM RecordType where SobjectType='Opportunity' and DeveloperName = 'IND_Engineering_project'];
    		
    		Account acct = new Account();
		 	acct.Name  = 'testAcct';
			acct.Account_Manager__c = user2.Id;
			acct.BillingCountry = 'China';
			insert acct;
			
			Account acct2 = new Account();
		 	acct2.Name  = 'testAcct2';
			acct2.Account_Manager__c = user2.Id;
			acct2.BillingCountry = 'China';
			insert acct2;
			
			//RecordType rt = [SELECT Name, Id,BusinessProcessId FROM RecordType where SobjectType='Opportunity' and DeveloperName = 'IND_Engineering_project'];
        	RecordType rt = Clstesthelp.createPMVTestRecordType3();
        	
        	Opportunity oppy = ClsTestHelp.createTestOpportunity();
	        oppy.Type = 'CM';
	        oppy.RecordTypeId = rt.Id;
	        oppy.Approval_Status_PMV__c = 'New';
	        oppy.PMV_Type__c = 'IND Standard ENG opp';
	        oppy.StageName = 'On Hold';
	        oppy.OwnerId = user.Id;
	        oppy.PMV_Migration_Setup__c = 'OnHold';
	        oppy.Name = 'testjinte';
	        oppy.Level__c = 'Quarterly';
	        insert oppy;
	        
	        
	        Opportunity opp = ClsTestHelp.createTestOpportunity();
	        opp.Type = 'CM';
	        opp.RecordTypeId = rt.Id;
	        opp.Approval_Status_PMV__c = 'New';
	        opp.PMV_Type__c = 'IND Standard ENG opp';
	        opp.StageName = 'On Hold';
	        opp.OwnerId = user.Id;
	        opp.PMV_Migration_Setup__c = 'OnHold';
	        opp.Name = 'testjin';
	        opp.Level__c = 'Monthly';
	        insert opp;
	        
	    	
	    	Product_Hierarchy__c proHieray = new Product_Hierarchy__c();
			insert proHieray;
				
			Part__c part = new Part__c();
			part.Product_Hierarchy__c  = proHieray.Id;
			insert part;
	    	
	    	Opportunity_Partner__c oppyPartner = new Opportunity_Partner__c();
	    	oppyPartner.Opportunity__c = oppy.Id;
	    	oppyPartner.Allocation__c = 100;
	    	oppyPartner.Account__c = acct.Id;
	    	//oppyPartner.isAPLOpp__c = true;
	    	insert oppyPartner;
	    	
	    	
	    	Opportunity_Part__c oppyPart = new Opportunity_Part__c();
	        oppyPart.APL_need_to_capture_billing__c = true;
	        oppyPart.APL_need_to_delete_captured_billing__c = true;
	        oppyPart.Opportunity__c = oppy.Id;
	        oppyPart.Initial_12_months__c = null;
	        oppyPart.Part__c = part.Id;
	        oppyPart.Won_Date__c = system.today();
	        insert oppyPart;
	        
	        Opportunity_Part__c oppyPart2 = new Opportunity_Part__c();
	        oppyPart2.APL_need_to_capture_billing__c = false;
	        oppyPart2.APL_need_to_delete_captured_billing__c = true;
	        oppyPart2.Opportunity__c = opp.Id;
	        oppyPart2.Initial_12_months__c = null;
	        oppyPart2.Part__c = part.Id;
	        oppyPart.Won_Date__c = system.today();
	        insert oppyPart2;
	        
	        
	        APL_Billing_Result_of_Covnerted_Opp__c aplBill = new APL_Billing_Result_of_Covnerted_Opp__c ();
	        aplBill.opportunity__c = oppy.Id;
	        aplBill.Part__c = part.Id;
	        aplBill.Opportunity_Partner__c = acct.Id;
	        insert aplBill;
	        
	        
	        //Select Id,Fiscal_Year__c ,Fiscal_Quarter__c,Fiscal_Month__c,Quantity__c,part__c,Date__c, Amount__c From Opportunity_Forecast__c where part__c in: map_oppypartId_level.keySet() and Date__c > = : minDate order by Date__c
	        //Select Number, Id, StartDate, Type From Period Where type = 'Quarter' And StartDate > = : minDate order by StartDate
	        
	        Opportunity_Forecast__c forec = new Opportunity_Forecast__c();
	        forec.part__c = oppyPart.Id;
	        forec.Opportunity__c = oppy.Id;
	        forec.Date__c = system.today();
	        forec.Fiscal_Year__c = '2016';
	        forec.Fiscal_Quarter__c = '01';
	        forec.Fiscal_Month__c = '01';
	        forec.Amount__c = 100;
	        insert forec;
	        
	        list<Period> list_per = new  list<Period>();
	        for (Period per :[Select Number, Id, StartDate, Type From Period Where type = 'Quarter' And StartDate > = : system.today() order by StartDate]) {
	        	list_per.add(per);
	        	system.debug('::per::'+per);
	        }
	        
	        
	        
	        ClsBatch_captureBillingWhenPartConverted clsy = new ClsBatch_captureBillingWhenPartConverted();
			dataBase.executeBatch(clsy);
	        
	        test.stopTest();
    		
    	}
    	
        
    }
}