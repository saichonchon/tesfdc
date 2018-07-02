/**
   This test class is used to test APL_CtrlSearchForecastBilling
 *  
 * @author Mingxing Qiu
 * @created 2016-06-22
 * @version 1.0
 * @since 29.0 (Force.com ApiVersion)  
 * 
 */
@isTest
private class APL_ClsSearchBillAPLUtil_Test {

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
    		list<Load_Status__c> list_loadStatus = new list<Load_Status__c>();
			list<Opportunity_Forecast__c> list_opportunityFore = new list<Opportunity_Forecast__c>();

	    	//custom setting 
	    	List<APL_Billing__c> list_APLbilling = new List<APL_Billing__c>();
	    	list_APLbilling.add(new APL_Billing__c (name = 'Oppy', Column_API_Names__c='Opportunity_Number__c,Name,Account.Account_Combined_Data__c,Customer_Region__c,Customer_Country__c,GAM_Code__c,Opportunity_Owner__c,Account_Manager__c,Field_Engineer_Name__c,New_Business_Percentage__c', Column_Names__c ='Opportunity Number,Opportunity Name,Account Combine data,Customer Region,Customer Country,GAM Code,Opp Owner,AM Name,FE Name,New Business Percentage'));
	    	list_APLbilling.add(new APL_Billing__c (name = 'OppyPart', Column_API_Names__c ='Part_Number__c,Won_Date__c,Account_Name__c,Customer_Region__c,CBC_1_Name__c,CBC_2_Name__c,GPL_Name__c,Product_Code_Name__c,Opportunity_owner__c,Part_Number_txt__c', Column_Names__c = 'Part Number,Won Date,Account Name,Customer Region,CBC1 Description,CBC2 Description,GPL Code,Product Code,Opp Owner,Part Description'));
	    	list_APLbilling.add(new APL_Billing__c (name = 'OppyPartner', Column_API_Names__c ='Partner_Account_Name__c,Partner_Role__c,Allocation__c,Partner_Account_Number__c,Partner_Region__c,Partner_Country__c,Partner_GAM_Code__c,Partner_Account_Manager__c,Partner_City__c,Opportunity_Owner__c', Column_Names__c = 'Partner Account Name,Partner role,Allocation,Parnter Account number,Partner Account Region,Partner Account Country,GAM Code,Partner AM,Partner City,Opp Owner'));
	        insert list_APLbilling;
	        
	        Load_Status__c loadStatus = new  Load_Status__c();
	        loadStatus.Data_Source_Description__c = 'Bookings/Billings direct PN detail monthly';
	        loadStatus.Current_Fiscal_Month__c = 5;
	        list_loadStatus.add(loadStatus);
	        
	         Load_Status__c loadStatus2 = new  Load_Status__c();
	        loadStatus2.Data_Source_Description__c = 'Bookings/Billings POS/CMA PN detail Monthly';
	        loadStatus2.Current_Fiscal_Month__c = 6;
	         list_loadStatus.add(loadStatus2);
	        insert list_loadStatus;
	        
	        
	        Opportunity oppy = ClsTestHelp.createTestOpportunity();
		    oppy.StageName = 'Won - Closed';
		    oppy.OwnerId = user.Id;
		    oppy.Name = 'testXing';
		    oppy.Probability = 50;
		    insert oppy;
	        
	        
	        Opportunity_Part__c oppyPart = new Opportunity_Part__c();
	        oppyPart.Opportunity__c = oppy.Id;
	        oppyPart.Status__c = 'Won';
	        oppyPart.Process_Status__c = 'Production';
	        oppyPart.Won_Fiscal_Year__c = '2016';
	        oppyPart.Initial_12_months__c = 12;
	        insert oppyPart;
	        
	        
	        Opportunity_Forecast__c  oppyFore = new Opportunity_Forecast__c();
	        oppyFore.Opportunity__c = oppy.Id;
	        oppyFore.part__c = oppyPart.Id;
	        oppyFore.Fiscal_Year__c = '2016';
	        oppyFore.Fiscal_Quarter__c ='01';
	        oppyFore.Amount__c = 10;
	        list_opportunityFore.add(oppyFore);
	        
	        
	        Opportunity_Forecast__c  oppyFore2 = new Opportunity_Forecast__c();
	        oppyFore2.Opportunity__c = oppy.Id;
	        oppyFore2.part__c = oppyPart.Id;
	        oppyFore2.Fiscal_Year__c = '2016';
	        oppyFore2.Fiscal_Quarter__c ='02';
	        oppyFore2.Amount__c = 20;
	        list_opportunityFore.add(oppyFore2);
	        
	        
	        Opportunity_Forecast__c  oppyFore3 = new Opportunity_Forecast__c();
	        oppyFore3.Opportunity__c = oppy.Id;
	        oppyFore3.part__c = oppyPart.Id;
	        oppyFore3.Fiscal_Year__c = '2016';
	        oppyFore3.Fiscal_Quarter__c ='03';
	        oppyFore3.Amount__c = 30;
	       list_opportunityFore.add(oppyFore3);
	        
	        
	        Opportunity_Forecast__c  oppyFore4 = new Opportunity_Forecast__c();
	        oppyFore4.Opportunity__c = oppy.Id;
	        oppyFore4.part__c = oppyPart.Id;
	        oppyFore4.Fiscal_Year__c = '2016';
	        oppyFore4.Fiscal_Quarter__c ='04';
	        oppyFore4.Amount__c = 40;
	        list_opportunityFore.add(oppyFore4);
	        insert list_opportunityFore;

	        APL_CtrlSearchForecastBilling apl_ctrlBill = new APL_CtrlSearchForecastBilling();
	        APL_CtrlSearchForecastBilling.befYear = true;
	        APL_CtrlSearchForecastBilling.fisYear = true;
	        APL_CtrlSearchForecastBilling.nextYear = true;
	        APL_CtrlSearchForecastBilling.dirBillMonth = 0;
	        APL_CtrlSearchForecastBilling.PosBillMonth = 0;
	        APL_CtrlSearchForecastBilling.thousandSep = '';
	        APL_CtrlSearchForecastBilling.fiscalYear = 2016;
	        
	        list<APL_CtrlSearchForecastBilling.paramlFilter> list_innerClass = new list<APL_CtrlSearchForecastBilling.paramlFilter>();
	        APL_CtrlSearchForecastBilling.paramlFilter paramlFilter = new  APL_CtrlSearchForecastBilling.paramlFilter();
	        paramlFilter.objectName='Opportunity_Part__c';
	        paramlFilter.queryString = 'Won_Date__c = THIS_FISCAL_YEAR';
	        list_innerClass.add(paramlFilter);
            APL_CtrlSearchForecastBilling.paramlFilter paramlFilter2 = new  APL_CtrlSearchForecastBilling.paramlFilter();
	        paramlFilter2.objectName='APL_Billing_Result_of_Covnerted_Opp__c';
	        paramlFilter2.queryString = 'Bill_Type__c IN(\'Direct\',\'POS\',\'CMA\')';
            list_innerClass.add(paramlFilter2);
	      
	        String Json_set_oppyIds = '[]';
	        APL_CtrlSearchForecastBilling.doSearch(list_innerClass,Json_set_oppyIds);
	        
	        String Json_set_oppyIds2 = '["'+oppy.Id+'"]';
            String choosePartOrPartner = 'opportunity_part__c,opportunity_partner__c';
            String choosePartOrPartner2 = 'opportunity_part__c';
            String choosePartOrPartner3 = 'opportunity_partner__c';
	        APL_CtrlSearchForecastBilling.doSearch(list_innerClass,Json_set_oppyIds2);
	        APL_CtrlSearchForecastBilling.searchPartAndPartner(list_innerClass,Json_set_oppyIds2,choosePartOrPartner2);
            APL_CtrlSearchForecastBilling.searchPartAndPartner(list_innerClass,Json_set_oppyIds2,choosePartOrPartner); 
	        APL_CtrlSearchForecastBilling.searchPartAndPartner(list_innerClass,Json_set_oppyIds2,choosePartOrPartner3); 
            set<String> set_oppyIds = new set<String>();
            set_oppyIds.add(oppy.Id);
            APL_ClsSearchBillAPLUtil.findOppyIdInBill(set_oppyIds);
            
            map<String,String> map_api_time = new map<String,String>();
            map_api_time.put('Won_Date__c', 'Custom Date;6/21/2016;6/22/2016');
            //APL_ClsSearchBillAPLUtil.getParsingTime(false, map_api_time);
            //APL_ClsSearchBillAPLUtil.getParsingTime(true, map_api_time);
            
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
		system.debug('user2::' + user2);
        
    	test.startTest();
        system.runAs(user2) {
        	list<Load_Status__c> list_loadStatus = new list<Load_Status__c>();
			list<Opportunity_Forecast__c> list_opportunityFore = new list<Opportunity_Forecast__c>();
            //custom setting 
	    	List<APL_Billing__c> list_APLbilling = new List<APL_Billing__c>();
	    	list_APLbilling.add(new APL_Billing__c (name = 'Oppy', Column_API_Names__c='Opportunity_Number__c,Name,Account.Account_Combined_Data__c,Customer_Region__c,Customer_Country__c,GAM_Code__c,Opportunity_Owner__c,Account_Manager__c,Field_Engineer_Name__c,New_Business_Percentage__c', Column_Names__c ='Opportunity Number,Opportunity Name,Account Combine data,Customer Region,Customer Country,GAM Code,Opp Owner,AM Name,FE Name,New Business Percentage'));
	    	list_APLbilling.add(new APL_Billing__c (name = 'OppyPart', Column_API_Names__c ='Part_Number__c,Won_Date__c,Account_Name__c,Customer_Region__c,CBC_1_Name__c,CBC_2_Name__c,GPL_Name__c,Product_Code_Name__c,Opportunity_owner__c,Part_Number_txt__c', Column_Names__c = 'Part Number,Won Date,Account Name,Customer Region,CBC1 Description,CBC2 Description,GPL Code,Product Code,Opp Owner,Part Description'));
	    	list_APLbilling.add(new APL_Billing__c (name = 'OppyPartner', Column_API_Names__c ='Partner_Account_Name__c,Partner_Role__c,Allocation__c,Partner_Account_Number__c,Partner_Region__c,Partner_Country__c,Partner_GAM_Code__c,Partner_Account_Manager__c,Partner_City__c,Opportunity_Owner__c', Column_Names__c = 'Partner Account Name,Partner role,Allocation,Parnter Account number,Partner Account Region,Partner Account Country,GAM Code,Partner AM,Partner City,Opp Owner'));
	        insert list_APLbilling;
	        
	        Load_Status__c loadStatus = new  Load_Status__c();
	        loadStatus.Data_Source_Description__c = 'Bookings/Billings direct PN detail monthly';
	        loadStatus.Current_Fiscal_Month__c = 5;
	        list_loadStatus.add(loadStatus);
	        
	         Load_Status__c loadStatus2 = new  Load_Status__c();
	        loadStatus2.Data_Source_Description__c = 'Bookings/Billings POS/CMA PN detail Monthly';
	        loadStatus2.Current_Fiscal_Month__c = 6;
	        list_loadStatus.add(loadStatus2);
	        insert list_loadStatus;
            
            Account acct = new Account();
		 	acct.Name  = 'testAcct';
			acct.Account_Manager__c = user2.Id;
			acct.BillingCountry = 'China';
            acct.Customer_Region__c = 'EMEA (excl. India)';
            acct.ACCTMGRNM__c = 'null';
            acct.GAMCD__c = 'G077';
			insert acct;
            
            RecordType rt = Clstesthelp.createPMVTestRecordType3();
            
             Opportunity oppy = ClsTestHelp.createTestOpportunity();
             oppy.Type = 'CM';
             //oppy.RecordTypeId = rt.Id;
             oppy.Approval_Status_PMV__c = 'New';
             oppy.PMV_Type__c = 'IND Standard ENG opp';
             oppy.StageName = 'On Hold';
             oppy.OwnerId = user.Id;
             oppy.PMV_Migration_Setup__c = 'OnHold';
             oppy.Name = 'testjinte';
             oppy.Level__c = 'Quarterly';
             insert oppy;		    
            
            Opportunity_Partner__c oppyPartner = new Opportunity_Partner__c();
	    	oppyPartner.Opportunity__c = oppy.Id;
	    	oppyPartner.Allocation__c = 100;
	    	oppyPartner.Account__c = acct.Id;
	    	insert oppyPartner;
             
            
            Product_Hierarchy__c proHieray = new Product_Hierarchy__c();
			insert proHieray;
			Part__c part = new Part__c();
			part.Product_Hierarchy__c  = proHieray.Id;
			insert part;
            BBB_Year_Bill_Book_Cust_PN__c test_bbb = new BBB_Year_Bill_Book_Cust_PN__c();
            test_bbb.Customer__c = acct.Id;
            test_bbb.Part__c = part.Id;
            test_bbb.APL_need_to_capture_billing__c = true;
            test_bbb.Bill_Type__c = 'POS';
           	insert test_bbb;
            APL_Billing_Result_of_Covnerted_Opp__c aplBill = new APL_Billing_Result_of_Covnerted_Opp__c ();
            aplBill.opportunity__c = oppy.Id;
            aplBill.Part__c = part.Id;
            aplBill.Opportunity_Partner__c = acct.Id;
            aplBill.Yearly_Booking_Billings_By_Part__c = test_bbb.Id;
            insert aplBill;
            
            date myDate = date.newInstance(2015, 6, 21);
            Opportunity_Part__c oppyPart = new Opportunity_Part__c();
	        oppyPart.Opportunity__c = oppy.Id;
	        oppyPart.Status__c = 'Won';
	        oppyPart.Process_Status__c = 'Production';
	        oppyPart.Won_Fiscal_Year__c = '2016';
			oppyPart.Initial_12_months__c = 1;   
            oppyPart.Part__c = part.Id;
            oppyPart.Won_Date__c = myDate;
	        insert oppyPart;
            
            Opportunity_Forecast__c  oppyFore = new Opportunity_Forecast__c();
	        oppyFore.Opportunity__c = oppy.Id;
	        oppyFore.part__c = oppyPart.Id;
	        oppyFore.Fiscal_Year__c = '2016';
	        oppyFore.Fiscal_Quarter__c ='01';
	        oppyFore.Amount__c = 10;
	        list_opportunityFore.add(oppyFore);
	        
	        
	        Opportunity_Forecast__c  oppyFore2 = new Opportunity_Forecast__c();
	        oppyFore2.Opportunity__c = oppy.Id;
	        oppyFore2.part__c = oppyPart.Id;
	        oppyFore2.Fiscal_Year__c = '2016';
	        oppyFore2.Fiscal_Quarter__c ='02';
	        oppyFore2.Amount__c = 20;
	        list_opportunityFore.add(oppyFore2);
	        
	        
	        Opportunity_Forecast__c  oppyFore3 = new Opportunity_Forecast__c();
	        oppyFore3.Opportunity__c = oppy.Id;
	        oppyFore3.part__c = oppyPart.Id;
	        oppyFore3.Fiscal_Year__c = '2016';
	        oppyFore3.Fiscal_Quarter__c ='03';
	        oppyFore3.Amount__c = 30;
	     	list_opportunityFore.add(oppyFore3);
	        
	        
	        Opportunity_Forecast__c  oppyFore4 = new Opportunity_Forecast__c();
	        oppyFore4.Opportunity__c = oppy.Id;
	        oppyFore4.part__c = oppyPart.Id;
	        oppyFore4.Fiscal_Year__c = '2016';
	        oppyFore4.Fiscal_Quarter__c ='04';
	        oppyFore4.Amount__c = 40;
	        list_opportunityFore.add(oppyFore4);
            
            Opportunity_Forecast__c  oppyFore5 = new Opportunity_Forecast__c();
	        oppyFore5.Opportunity__c = oppy.Id;
	        oppyFore5.part__c = oppyPart.Id;
	        oppyFore5.Fiscal_Year__c = '2017';
	        oppyFore5.Fiscal_Quarter__c ='01';
	        oppyFore5.Amount__c = 40;
	        list_opportunityFore.add(oppyFore5);
            
            Opportunity_Forecast__c  oppyFore6 = new Opportunity_Forecast__c();
	        oppyFore6.Opportunity__c = oppy.Id;
	        oppyFore6.part__c = oppyPart.Id;
	        oppyFore6.Fiscal_Year__c = '2015';
	        oppyFore6.Fiscal_Quarter__c ='01';
	        oppyFore6.Amount__c = 40;
	        list_opportunityFore.add(oppyFore6);
            
	        insert list_opportunityFore;
            
    		
            list<APL_CtrlSearchForecastBilling.paramlFilter> list_innerClass = new list<APL_CtrlSearchForecastBilling.paramlFilter>();
	        APL_CtrlSearchForecastBilling.paramlFilter paramlFilter = new  APL_CtrlSearchForecastBilling.paramlFilter();
	        paramlFilter.objectName='Opportunity_Part__c';
	        paramlFilter.queryString = 'Won_Date__c = THIS_FISCAL_YEAR';
	        list_innerClass.add(paramlFilter);
            APL_CtrlSearchForecastBilling.paramlFilter paramlFilter2 = new  APL_CtrlSearchForecastBilling.paramlFilter();
	        paramlFilter2.objectName='APL_Billing_Result_of_Covnerted_Opp__c';
	        paramlFilter2.queryString = 'Bill_Type__c IN(\'Direct\',\'POS\',\'CMA\')';
            list_innerClass.add(paramlFilter2);
            APL_CtrlSearchForecastBilling.paramlFilter paramlFilter3 = new  APL_CtrlSearchForecastBilling.paramlFilter();
	        paramlFilter3.objectName='Opportunity';
	        paramlFilter3.queryString = 'Customer_Region__c IN(\'Japan\')';
            list_innerClass.add(paramlFilter3);
            APL_CtrlSearchForecastBilling.paramlFilter paramlFilter4 = new  APL_CtrlSearchForecastBilling.paramlFilter();
	        paramlFilter4.objectName='Opportunity_Partner__c';
	        paramlFilter4.queryString = 'Partner_GAM_Code__c=\'G077\'';
            list_innerClass.add(paramlFilter4);
            
            set<String> set_oppyIds = new set<String>();
            set_oppyIds.add(oppy.Id);
            APL_ClsSearchBillAPLUtil apl = new APL_ClsSearchBillAPLUtil();
            String multipleType = apl.getMultipleType();
            set<String> testString = new set<String>();
            testString = APL_ClsSearchBillAPLUtil.findSet_oppyId(list_innerClass);
            APL_ClsSearchBillAPLUtil.getoppyPartnerFcBilling(list_innerClass, set_oppyIds, 2016, 1);
            APL_ClsSearchBillAPLUtil.getOppyPartFcBilling(list_innerClass, set_oppyIds, 2016, 1);
            APL_ClsSearchBillAPLUtil.getOppyPart(oppy.Id);
            APL_ClsSearchBillAPLUtil.getOppyPartIds(oppy.Id);
            APL_ClsSearchBillAPLUtil.getoppyPartner(oppy.Id);
            APL_ClsSearchBillAPLUtil.findOppyIdInOppPart(set_oppyIds, list_innerClass);
            APL_ClsSearchBillAPLUtil.findOppyIdInOppPartner(set_oppyIds);
            APL_ClsSearchBillAPLUtil.getBill(set_oppyIds, APL_CtrlSearchForecastBilling.map_billFileds);
        }
        test.stopTest();
    }
}