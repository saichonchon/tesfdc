@isTest
private class opportunityPartner_AIUDUD_calOppyAl_Test {

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
    		
    		list<Account> list_accs = new list<Account>();
    		Account acct = new Account();
		 	acct.Name  = 'testAcct';
			acct.Account_Manager__c = user2.Id;
			acct.BillingCountry = 'China';
			list_accs.add(acct);
			
			Account acc = new Account();
		 	acc.Name  = 'testAcc';
			acc.Account_Manager__c = user2.Id;
			acc.BillingCountry = 'China';
			list_accs.add(acc);
			insert list_accs;
			
			RecordType rt = [SELECT Name, Id,BusinessProcessId FROM RecordType where SobjectType='Opportunity' and DeveloperName = 'IND_Engineering_project'];
        	
        	Opportunity oppy = ClsTestHelp.createTestOpportunity();
	        oppy.Type = 'CM';
	        oppy.RecordTypeId = rt.Id;
	        oppy.Approval_Status_PMV__c = 'New';
	        oppy.PMV_Type__c = 'IND Standard ENG opp';
	        oppy.StageName = 'On Hold';
	        oppy.OwnerId = user.Id;
	        oppy.PMV_Migration_Setup__c = 'OnHold';
	        oppy.Name = 'testqmx';
	        
	        insert oppy;
    		
    		Opportunity oppytemp = [SELECT Name, Id,isAPLOpp__c FROM Opportunity where Id= :oppy.Id ];
			system.debug('!@# oppytemp:'+oppytemp);
			
			Product_Hierarchy__c proHieray = new Product_Hierarchy__c();
			insert proHieray;
				
			Part__c part = new Part__c();
			part.Product_Hierarchy__c  = proHieray.Id;
			insert part;
			
			Opportunity_Part__c  oppyPart = new Opportunity_Part__c();
	    	oppyPart.opportunity__c = oppy.Id;
	    	oppyPart.Part__c = part.Id;
	    	oppyPart.Process_Status__c = 'Production';
	    	oppyPart.APL_need_to_capture_billing__c = false;
	    	insert oppyPart;
	    	Opportunity_Part__c  oppyPartSelect =  [select  id, opportunity__c, Part__c, APL_need_to_capture_billing__c from Opportunity_Part__c where opportunity__c =: oppy.Id and Part__c =:part.Id and APL_need_to_capture_billing__c = false limit 1];
	    	system.debug('!@# test oppyPartSelect:'+oppyPartSelect);
	    	
	    	BBB_Year_Bill_Book_Cust_PN__c test_bbb = new BBB_Year_Bill_Book_Cust_PN__c();
			test_bbb.Customer__c = acct.Id;
			test_bbb.Part__c = part.Id;
			test_bbb.APL_need_to_capture_billing__c = false;
			insert test_bbb;
			test_bbb.APL_need_to_capture_billing__c = false;
			update test_bbb;
			
			BBB_Year_Bill_Book_Cust_PN__c  bbb = [select id from BBB_Year_Bill_Book_Cust_PN__c where Id=:test_bbb.Id limit 1] ;
	    	system.debug('!@# test bbb:'+bbb);
	    	
	    	//oppyPartner2.Allocation__c = 50;
	    	//oppyPartner2.Account__c = acc.Id;
	    	//update oppyPartner2;
	    	
	    	APL_Billing_Result_of_Covnerted_Opp__c aplBill = new APL_Billing_Result_of_Covnerted_Opp__c ();
	        aplBill.opportunity__c = oppy.Id;
	        aplBill.Part__c = part.Id;
	        aplBill.Opportunity_Partner__c = acct.Id;
	        insert aplBill;
			
			
			
    		list<Opportunity_Partner__c> list_partner = new  list<Opportunity_Partner__c>();
    		Opportunity_Partner__c oppyPartner = new Opportunity_Partner__c();
	    	oppyPartner.Opportunity__c = oppy.Id;
	    	oppyPartner.Allocation__c = 100;
	    	oppyPartner.Account__c = acct.Id;
	    	//oppyPartner.isAPLOpp__c = true;
	    	list_partner.add(oppyPartner);
	    	
	    	Opportunity_Partner__c oppyPartner2 = new Opportunity_Partner__c();
	    	oppyPartner2.Opportunity__c = oppy.Id;
	    	oppyPartner2.Allocation__c = 0;
	    	oppyPartner2.Account__c = acct.Id;
	    	//oppyPartner.isAPLOpp__c = true;
	    	list_partner.add(oppyPartner2);
	    	insert list_partner;
			
			ClsOppyPartUtil.needCriteria = false;
			
	    	oppyPartner.Account__c = acc.Id;
	    	update oppyPartner;
	    	
	    	
	    	Delete oppyPartner2;
	    	
    		
    	}
    }
}