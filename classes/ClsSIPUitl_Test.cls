/**
*  This test class used to test class ExtRecalculateBudget.
*
@author Lili Zhao
@created 2013-08-28
@version 1.0
@since 27.0
*
@changelog
* coverage 85% 
* 
* 
2013-08-28 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest(seeAllData = false)   
private class ClsSIPUitl_Test {

    static testMethod void myUnitAMTest() {
    	addCustomSetting();
    	list<SIP__c> list_sipPopulateOpportunityData = new list<SIP__c>();
		list<SIP__c> list_sipPopulateBillings = new list<SIP__c>();
		set<String> set_AMCodes = new set<String>();
		set<String> set_FECodes = new set<String>();
		set<String> set_GAMCodes = new set<String>();
		map<Id,set<String>> map_sipId_set_amCode = new map<Id,set<String>>();
		map<Id,set<String>> map_sipId_set_feCode = new map<Id,set<String>>();
		map<Id,set<String>> map_sipId_set_gamCode = new map<Id,set<String>>();
		map<String, set<String>> map_sipId_set_profitCtrs4GAM = new map<String, set<String>>();
    	test.startTest(); 
    	Test.setMock(HttpCalloutMock.class, new ClsTestWSMockUtil.RunReportMockHttpResponseGenerator());

		User user = new User();
		user=ClsTestHelp.createTestUsers();
		user.Te_Network_Id__c = 'testUser';
		user.username = 'test333333.te@test31111.com';
		insert user;
		
		list<Sales_Hierarchy__c> list_Hierarchy = new list<Sales_Hierarchy__c>();
		Sales_Hierarchy__c salesHierarchyAM1 = new Sales_Hierarchy__c(Hierarchy_Type__c  = 'Sales Hierarchy (AM)' ,Level_7_Assigned_User_Network_Ids__c='testUser',Level_7_Territory_Code__c = 'testAM1');
		Sales_Hierarchy__c salesHierarchyAM2 = new Sales_Hierarchy__c(Hierarchy_Type__c  = 'Sales Hierarchy (AM)' ,Level_7_Assigned_User_Network_Ids__c='testUser;testUser2',Level_7_Territory_Code__c = 'testAM2');
		Sales_Hierarchy__c salesHierarchyAM3 = new Sales_Hierarchy__c(Hierarchy_Type__c  = 'Account Manager Hierarchy (FE)' ,Level_7_Assigned_User_Network_Ids__c='testUser;testUser2',Level_7_Territory_Code__c = 'testFE');
		//insert salesHierarchyAM1;
		System.assertEquals('testUser', salesHierarchyAM1.Level_7_Assigned_User_Network_Ids__c);
		System.assertEquals('testAM1', salesHierarchyAM1.Level_7_Territory_Code__c);
		//insert salesHierarchyAM2;
		System.assertEquals('testUser;testUser2', salesHierarchyAM2.Level_7_Assigned_User_Network_Ids__c);
		System.assertEquals('testAM2', salesHierarchyAM2.Level_7_Territory_Code__c);
		//insert salesHierarchyAM3;
		list_Hierarchy.add(salesHierarchyAM1);
		list_Hierarchy.add(salesHierarchyAM2);
		list_Hierarchy.add(salesHierarchyAM3);
		insert list_Hierarchy;
		
		String recordTypeAM;
		String recordTypeFE;
		String recordTypeGAM;
		String recordTypeMM;
		
		for (RecordType recordType : [select Id, Name, DeveloperName from RecordType where SobjectType = 'SIP__c' and IsActive = true and (DeveloperName = 'AM_Plan' or DeveloperName = 'FE_Plan' or DeveloperName = 'GAM_Plan' or DeveloperName = 'Sales_Manager_Plan')]) {
			if(recordType.DeveloperName == 'AM_Plan'){
				recordTypeAM = recordType.Id;				
			} else if(recordType.DeveloperName == 'FE_Plan') {				
				recordTypeFE = recordType.Id;
			}else if (recordType.DeveloperName == 'GAM_Plan') {				
				recordTypeGAM = recordType.Id;
			}else {			
				recordTypeMM = recordType.Id;
			}
		}
		SIP_master__c sipMaster = new SIP_master__c();
		sipMaster.Name = 'Test Master';
		insert sipMaster;
		
		list<SIP__c> list_sips2Insert = new list<SIP__c>();
		list<SIP__c> list_sips = new list<SIP__c>();
		
		SIP__c sipAM = new SIP__c();
		sipAM.Plan_Participant__c = user.Id;
		sipAM.RecordTypeId = recordTypeAM;
		sipAM.Plan_Year__c = '2013';
		sipAM.Name = 'test AM';
		sipAM.SIP_master_record__c = sipMaster.Id;
		sipAM.Prev_Year_YTD_Direct_billings__c  = 100;
		//sipAM.Exclude_From_Automatic_Update__c = false;
		sipAM.Profit_Center_Codes__c = 'A&C';
		list_sips2Insert.add(sipAM);
				
		SIP__c sipFE = new SIP__c();
		sipFE.Plan_Participant__c = user.Id;
		sipFE.RecordTypeId = recordTypeFE;
		sipFE.Plan_Year__c = '2013';
		sipFE.Name = 'test FE';
		sipFE.SIP_master_record__c = sipMaster.Id;
		sipFE.Prev_Year_YTD_Direct_billings__c  = 100;
		sipFE.Profit_Center_Codes__c = 'A&C';
		list_sips2Insert.add(sipFE);
				
		SIP__c sipGAM = new SIP__c();
		sipGAM.GAM_codes__c = 'testGAM';
		sipGAM.Plan_Participant__c = user.Id;		
		sipGAM.RecordTypeId = recordTypeGAM;
		sipGAM.Plan_Year__c = '2014';
		sipGAM.Name = 'test GAM';
		sipGAM.SIP_master_record__c = sipMaster.Id;
		sipGAM.Prev_Year_YTD_Direct_billings__c  = 100;
		sipGAM.Profit_Center_Codes__c = 'A&C';
		list_sips2Insert.add(sipGAM);

		
		SIP__c sipGAM2 = new SIP__c();
		sipGAM2.GAM_codes__c = 'test1,testGAM2';
		sipGAM2.Plan_Participant__c = user.Id;		
		sipGAM2.RecordTypeId = recordTypeGAM;
		sipGAM2.Plan_Year__c = '2014';
		sipGAM2.Name = 'test GAM';
		sipGAM2.SIP_master_record__c = sipMaster.Id;
		sipGAM2.Prev_Year_YTD_Direct_billings__c  = 100;
		sipGAM2.Profit_Center_Codes__c = 'A&C';
		list_sips2Insert.add(sipGAM2);
		
		insert list_sips2Insert;
		for(SIP__c s : [Select AM_codes__c, RecordType.DeveloperName, Approver__c, Business_Driver_1__c, 
							   Business_Driver_1_Achieved__c, Business_Driver_1_Weighting__c, Business_Driver_1_details__c, 
							   Business_Driver_2__c, Business_Driver_2_Achieved__c, Business_Driver_2_Weighting__c, 
							   Business_Driver_2_details__c, Business_Driver_3__c, Business_Driver_3_Achieved__c, 
							   Business_Driver_3_Weighting__c, Business_Driver_3_details__c, Business_Driver_4__c, 
							   Business_Driver_4_Achieved__c, Business_Driver_4_Weighting__c, Business_Driver_4_details__c, 
							   Conversion_result__c, CreatedById, CreatedDate, CurrencyIsoCode, Current_Fiscal_Year_Direct__c, 
							   Current_Fiscal_Year_Indirect__c, IsDeleted, Exceptional_Perf_Conversion_Target_Dolla__c, 
							   Exceptional_Perf_Conversion_Target__c, Exceptional_Perf_Growth_Target_Dollar__c, 
							   Exceptional_Perf_Growth_Reve__c, FE_codes__c, GAM_codes__c, Industrial_Performance_Weighting__c, 
							   LastModifiedById, LastModifiedDate, Level_1_Conversion_Target_Dollar__c, Level_1_Conversion_target__c, 
							   Level_1_Growth_Target_Dollar__c, Level_1_Growth_Target__c, Level_1_Pipeline_Target_Dollar__c, 
							   Level_1_Pipeline_Target__c, Level_2_Conversion_Target_Dollar__c, Level_2_Conversion_Target__c, 
							   Level_2_Growth_Target_Dollar__c, Level_2_Growth_Target__c, Level_2_Pipeline_Target_Dollar__c, 
							   Level_2_Pipeline_Target__c, Level_3_Conversion_Target_Dollar__c, Level_3_Conversion_Target__c, 
							   Level_3_Growth_Target_Dollar__c, Level_3_Growth_Target__c, Level_3_Pipeline_Target_Dollar__c, 
							   Level_3_Pipeline_Target__c, Load_Status_Direct_Billings__c, Load_Status_Monthly_Direct__c, 
							   Load_Status_POS__c, Load_Status_Record_Indirect__c, OwnerId, Participants_Manager__c, 
							   Participants_TE_Network_ID__c, Pipeline_Result__c, Plan_Comments__c, Plan_Participant__c, 
							   Plan_Year__c, Current_Year_Direct_Bill_YTD__c, Current_Year_Direct_Billings_Run_Rate__c, 
							   Current_Year_POS_Bill_YTD__c, Current_Year_POS_Run_Rate__c, Prev_Year_1__c, Prev_Year_1_POS_Result__c, 
							   Prev_Year_1_Total_Result__c, Prev_Year_Conversion_YTD_Result_Dollar__c, Prev_Year_Conversion_YTD_Result__c, 
							   Prev_Year_Dir_Bill_Run_Rate_Result__c, Prev_Year_Growth__c, Prev_Year_POS_Run_Rate_Result__c, 
							   Prev_Year_Pipeline_YTD_Result_Dollar__c, Prev_Year_Pipeline_YTD_Result__c, Total_Revenue_Baseline__c, 
							   Prev_Year_YTD_Direct_billings__c, Prev_Year_YTD_POS__c, Profit_Center_Codes__c, ConnectionReceivedId, 
							   Id, RecordTypeId, Region__c, Name, ConnectionSentId, SystemModstamp 
						from SIP__c 
						where Id =: sipFE.Id
						or Id =: sipGAM.Id
						or Id =: sipGAM2.Id
						or Id =: sipAM.Id
						]) {
		
			list_sips.add(s);				
		}
		ClsSIPUitl.recalcBillingAndOppyData(list_sips, list_sipPopulateOpportunityData, list_sipPopulateBillings, set_AMCodes, set_FECodes, set_GAMCodes, map_sipId_set_amCode, map_sipId_set_feCode, map_sipId_set_gamCode, map_sipId_set_profitCtrs4GAM);
		delete sipGAM;	
		
		test.stopTest();
		

// TO DO: implement unit test
    }       
 	static testMethod void myUnitAMTest2() {
 		addCustomSetting();
 		list<SIP__c> list_sips = new list<SIP__c>();    	
    	list<SIP__c> list_sipPopulateOpportunityData = new list<SIP__c>();
		list<SIP__c> list_sipPopulateBillings = new list<SIP__c>();
		set<String> set_AMCodes = new set<String>();
		set<String> set_FECodes = new set<String>();
		set<String> set_GAMCodes = new set<String>();
		map<Id,set<String>> map_sipId_set_amCode = new map<Id,set<String>>();
		map<Id,set<String>> map_sipId_set_feCode = new map<Id,set<String>>();
		map<Id,set<String>> map_sipId_set_gamCode = new map<Id,set<String>>();
		map<String, set<String>> map_sipId_set_profitCtrs4GAM = new map<String, set<String>>();
		
     	
   
		User user = new User();
		user=ClsTestHelp.createTestUsers();
		user.Te_Network_Id__c = 'testUser';
		user.username = 'test5133371.te@test611.com';
		insert user;
		
		list<Sales_Hierarchy__c> list_Hierarchy1 = new list<Sales_Hierarchy__c>();
		Sales_Hierarchy__c salesHierarchyAM1 = new Sales_Hierarchy__c(Hierarchy_Type__c  = 'Sales Hierarchy (AM)' ,Level_7_Assigned_User_Network_Ids__c='testUser',Level_7_Territory_Code__c = 'testAM1');
		Sales_Hierarchy__c salesHierarchyAM2 = new Sales_Hierarchy__c(Hierarchy_Type__c  = 'Sales Hierarchy (AM)' ,Level_7_Assigned_User_Network_Ids__c='testUser;testUser2',Level_7_Territory_Code__c = 'testAM2');
		Sales_Hierarchy__c salesHierarchyAM3 = new Sales_Hierarchy__c(Hierarchy_Type__c  = 'Account Manager Hierarchy (FE)' ,Level_7_Assigned_User_Network_Ids__c='testUser;testUser2',Level_7_Territory_Code__c = 'testFE');
		//insert salesHierarchyAM1;
		System.assertEquals('testUser', salesHierarchyAM1.Level_7_Assigned_User_Network_Ids__c);
		System.assertEquals('testAM1', salesHierarchyAM1.Level_7_Territory_Code__c);
		//insert salesHierarchyAM2;
		System.assertEquals('testUser;testUser2', salesHierarchyAM2.Level_7_Assigned_User_Network_Ids__c);
		System.assertEquals('testAM2', salesHierarchyAM2.Level_7_Territory_Code__c);
		//insert salesHierarchyAM3;
		
		list_Hierarchy1.add(salesHierarchyAM1);
		list_Hierarchy1.add(salesHierarchyAM2);
		list_Hierarchy1.add(salesHierarchyAM3);
		insert list_Hierarchy1;
		
		
		String recordTypeAM;
		String recordTypeFE;
		String recordTypeGAM;
		String recordTypeMM;
		
		for (RecordType recordType : [select Id, Name, DeveloperName from RecordType where SobjectType = 'SIP__c' and IsActive = true and (DeveloperName = 'AM_Plan' or DeveloperName = 'FE_Plan' or DeveloperName = 'GAM_Plan' or DeveloperName = 'Sales_Manager_Plan')]) {
			if(recordType.DeveloperName == 'AM_Plan'){
				recordTypeAM = recordType.Id;				
			} else if(recordType.DeveloperName == 'FE_Plan') {				
				recordTypeFE = recordType.Id;
			}else if (recordType.DeveloperName == 'GAM_Plan') {				
				recordTypeGAM = recordType.Id;
			}else {			
				recordTypeMM = recordType.Id;
			}
		}
		SIP_master__c sipMaster = new SIP_master__c();
		sipMaster.Name = 'Test Master';
		insert sipMaster;
		
		SIP__c sipGAM2 = new SIP__c();
		sipGAM2.GAM_codes__c = 'test1,testGAM2';
		sipGAM2.Plan_Participant__c = user.Id;		
		sipGAM2.RecordTypeId = recordTypeGAM;
		sipGAM2.Plan_Year__c = '2014';
		sipGAM2.Name = 'test GAM';
		sipGAM2.SIP_master_record__c = sipMaster.Id;
		sipGAM2.Prev_Year_YTD_Direct_billings__c  = 100;
		sipGAM2.Profit_Center_Codes__c = 'A&C;IB';
		insert sipGAM2;
		sipGAM2 = [Select AM_codes__c, Approver__c, Business_Driver_1__c, Business_Driver_1_Achieved__c, Business_Driver_1_Weighting__c, Business_Driver_1_details__c, Business_Driver_2__c, Business_Driver_2_Achieved__c, Business_Driver_2_Weighting__c, Business_Driver_2_details__c, Business_Driver_3__c, Business_Driver_3_Achieved__c, Business_Driver_3_Weighting__c, Business_Driver_3_details__c, Business_Driver_4__c, Business_Driver_4_Achieved__c, Business_Driver_4_Weighting__c, Business_Driver_4_details__c, Conversion_result__c, CreatedById, CreatedDate, CurrencyIsoCode, Current_Fiscal_Year_Direct__c, Current_Fiscal_Year_Indirect__c, IsDeleted, Exceptional_Perf_Conversion_Target_Dolla__c, Exceptional_Perf_Conversion_Target__c, Exceptional_Perf_Growth_Target_Dollar__c, Exceptional_Perf_Growth_Reve__c, FE_codes__c, GAM_codes__c, Industrial_Performance_Weighting__c, LastModifiedById, LastModifiedDate, Level_1_Conversion_Target_Dollar__c, Level_1_Conversion_target__c, Level_1_Growth_Target_Dollar__c, Level_1_Growth_Target__c, Level_1_Pipeline_Target_Dollar__c, Level_1_Pipeline_Target__c, Level_2_Conversion_Target_Dollar__c, Level_2_Conversion_Target__c, Level_2_Growth_Target_Dollar__c, Level_2_Growth_Target__c, Level_2_Pipeline_Target_Dollar__c, Level_2_Pipeline_Target__c, Level_3_Conversion_Target_Dollar__c, Level_3_Conversion_Target__c, Level_3_Growth_Target_Dollar__c, Level_3_Growth_Target__c, Level_3_Pipeline_Target_Dollar__c, Level_3_Pipeline_Target__c, Load_Status_Direct_Billings__c, Load_Status_Monthly_Direct__c, Load_Status_POS__c, Load_Status_Record_Indirect__c, OwnerId, Participants_Manager__c, Participants_TE_Network_ID__c, Pipeline_Result__c, Plan_Comments__c, Plan_Participant__c, Plan_Year__c, Current_Year_Direct_Bill_YTD__c, Current_Year_Direct_Billings_Run_Rate__c, Current_Year_POS_Bill_YTD__c, Current_Year_POS_Run_Rate__c, Prev_Year_1__c, Prev_Year_1_POS_Result__c, Prev_Year_1_Total_Result__c, Prev_Year_Conversion_YTD_Result_Dollar__c, Prev_Year_Conversion_YTD_Result__c, Prev_Year_Dir_Bill_Run_Rate_Result__c, Prev_Year_Growth__c, Prev_Year_POS_Run_Rate_Result__c, Prev_Year_Pipeline_YTD_Result_Dollar__c, Prev_Year_Pipeline_YTD_Result__c, Total_Revenue_Baseline__c, Prev_Year_YTD_Direct_billings__c, Prev_Year_YTD_POS__c, Profit_Center_Codes__c, ConnectionReceivedId, Id, RecordType.DeveloperName,RecordTypeId, Region__c, Name, ConnectionSentId, SystemModstamp from SIP__c where Id =: sipGAM2.Id];		
	
		list_sips.add(sipGAM2);
		test.startTest(); 
 		Test.setMock(HttpCalloutMock.class, new ClsTestWSMockUtil.RunReportMockHttpResponseGenerator());
		ClsSIPUitl.recalcBillingAndOppyData(list_sips, list_sipPopulateOpportunityData, list_sipPopulateBillings, set_AMCodes, set_FECodes, set_GAMCodes, map_sipId_set_amCode, map_sipId_set_feCode, map_sipId_set_gamCode, map_sipId_set_profitCtrs4GAM);		
		
		test.stopTest();
 	}   
 	
 	static testMethod void myUnitFE() {
 		addCustomSetting();
		list<SIP__c> list_sips = new list<SIP__c>();    	
    	list<SIP__c> list_sipPopulateOpportunityData = new list<SIP__c>();
		list<SIP__c> list_sipPopulateBillings = new list<SIP__c>();
		set<String> set_AMCodes = new set<String>();
		set<String> set_FECodes = new set<String>();
		set<String> set_GAMCodes = new set<String>();
		map<Id,set<String>> map_sipId_set_amCode = new map<Id,set<String>>();
		map<Id,set<String>> map_sipId_set_feCode = new map<Id,set<String>>();
		map<Id,set<String>> map_sipId_set_gamCode = new map<Id,set<String>>();
		map<String, set<String>> map_sipId_set_profitCtrs4GAM = new map<String, set<String>>();
    	  
		User user = new User();
		user=ClsTestHelp.createTestUsers();
		user.Te_Network_Id__c = 'testUser';
		user.username = 'test2081.te@test991.com';
		insert user;
			
		Sales_Hierarchy__c salesHierarchyAM3 = new Sales_Hierarchy__c(Hierarchy_Type__c  = 'Account Manager Hierarchy (FE)' ,Level_7_Assigned_User_Network_Ids__c='testUser;testUser2',Level_7_Territory_Code__c = 'testFE');
  		
		insert salesHierarchyAM3;
		
  		Product_Hierarchy__c ph = new Product_Hierarchy__c();
  		ph.Hierarchy_Level_Type__c = 'CBC1';
  		ph.Description__c = 'Industrial';
  		ph.Name = 'T01';
  		ph.Regional_PM_EU__c = user.Id;
  		insert ph;
		String recordTypeFE;
		
		for (RecordType recordType : [select Id, Name, DeveloperName from RecordType where SobjectType = 'SIP__c' and IsActive = true and DeveloperName = 'FE_Plan']) {
			if(recordType.DeveloperName == 'FE_Plan') {				
				recordTypeFE = recordType.Id;
			}
		}
		SIP_master__c sipMaster = new SIP_master__c();
		sipMaster.Name = 'Test Master';
		insert sipMaster;				
		
		SIP__c sipFE = new SIP__c();
		sipFE.Plan_Participant__c = user.Id;
		sipFE.RecordTypeId = recordTypeFE;
		sipFE.Plan_Year__c = '2013';
		sipFE.Name = 'test FE';
		sipFE.SIP_master_record__c = sipMaster.Id;
		sipFE.Prev_Year_YTD_Direct_billings__c  = 100;
		sipFE.Profit_Center_Codes__c = 'A&C';
		insert sipFE;
		
		sipFE = [Select GPLs__c, AM_codes__c, RecordType.DeveloperName, Approver__c, Business_Driver_1__c, Business_Driver_1_Achieved__c, Business_Driver_1_Weighting__c, Business_Driver_1_details__c, Business_Driver_2__c, Business_Driver_2_Achieved__c, Business_Driver_2_Weighting__c, Business_Driver_2_details__c, Business_Driver_3__c, Business_Driver_3_Achieved__c, Business_Driver_3_Weighting__c, Business_Driver_3_details__c, Business_Driver_4__c, Business_Driver_4_Achieved__c, Business_Driver_4_Weighting__c, Business_Driver_4_details__c, Conversion_result__c, CreatedById, CreatedDate, CurrencyIsoCode, Current_Fiscal_Year_Direct__c, Current_Fiscal_Year_Indirect__c, IsDeleted, Exceptional_Perf_Conversion_Target_Dolla__c, Exceptional_Perf_Conversion_Target__c, Exceptional_Perf_Growth_Target_Dollar__c, Exceptional_Perf_Growth_Reve__c, FE_codes__c, GAM_codes__c, Industrial_Performance_Weighting__c, LastModifiedById, LastModifiedDate, Level_1_Conversion_Target_Dollar__c, Level_1_Conversion_target__c, Level_1_Growth_Target_Dollar__c, Level_1_Growth_Target__c, Level_1_Pipeline_Target_Dollar__c, Level_1_Pipeline_Target__c, Level_2_Conversion_Target_Dollar__c, Level_2_Conversion_Target__c, Level_2_Growth_Target_Dollar__c, Level_2_Growth_Target__c, Level_2_Pipeline_Target_Dollar__c, Level_2_Pipeline_Target__c, Level_3_Conversion_Target_Dollar__c, Level_3_Conversion_Target__c, Level_3_Growth_Target_Dollar__c, Level_3_Growth_Target__c, Level_3_Pipeline_Target_Dollar__c, Level_3_Pipeline_Target__c, Load_Status_Direct_Billings__c, Load_Status_Monthly_Direct__c, Load_Status_POS__c, Load_Status_Record_Indirect__c, OwnerId, Participants_Manager__c, Participants_TE_Network_ID__c, Pipeline_Result__c, Plan_Comments__c, Plan_Participant__c, Plan_Year__c, Current_Year_Direct_Bill_YTD__c, Current_Year_Direct_Billings_Run_Rate__c, Current_Year_POS_Bill_YTD__c, Current_Year_POS_Run_Rate__c, Prev_Year_1__c, Prev_Year_1_POS_Result__c, Prev_Year_1_Total_Result__c, Prev_Year_Conversion_YTD_Result_Dollar__c, Prev_Year_Conversion_YTD_Result__c, Prev_Year_Dir_Bill_Run_Rate_Result__c, Prev_Year_Growth__c, Prev_Year_POS_Run_Rate_Result__c, Prev_Year_Pipeline_YTD_Result_Dollar__c, Prev_Year_Pipeline_YTD_Result__c, Total_Revenue_Baseline__c, Prev_Year_YTD_Direct_billings__c, Prev_Year_YTD_POS__c, Profit_Center_Codes__c, ConnectionReceivedId, Id, RecordTypeId, Region__c, Name, ConnectionSentId, SystemModstamp from SIP__c where Id =: sipFE.Id];
					
		list_sips.add(sipFE);
		test.startTest(); 
 		Test.setMock(HttpCalloutMock.class, new ClsTestWSMockUtil.RunReportMockHttpResponseGenerator());
		
		ClsSIPUitl.recalcBillingAndOppyData(list_sips, list_sipPopulateOpportunityData, list_sipPopulateBillings, set_AMCodes, set_FECodes, set_GAMCodes, map_sipId_set_amCode, map_sipId_set_feCode, map_sipId_set_gamCode, map_sipId_set_profitCtrs4GAM);
		
		ClsSIPUitl.generateSIPGPLCodes('Test', new set<SIP__c> { sipFE });
		
		ClsSIPUitl.fillGPLCodesForPMSIP(new map<String, set<SIP__c>> {user.Id => new set<SIP__c>{sipFE}});
		ClsSIPUitl.getPMRTId();
		
		SIP_Mapping__c sipMapping = new SIP_Mapping__c();		
		sipMapping.Report_Field_1__c = 'T!0_1';
		sipMapping.Report_ID_1__c = '00OE0000002QYDq';
		sipMapping.Report_Parameters_1__c = 'AM_Codes__c,2';
		sipMapping.Target_Field_1__c = 'Prev_Year_YTD_POS__c';
		sipMapping.Target_Field_Name_1__c = 'Revenue Base Line';
		insert sipMapping;
		
		String recordTypeAM;
		String recordTypeGAM;
		String recordTypeMM;
		
		for (RecordType recordType : [select Id, Name, DeveloperName from RecordType where SobjectType = 'SIP__c' and IsActive = true and (DeveloperName = 'AM_Plan' or DeveloperName = 'FE_Plan' or DeveloperName = 'GAM_Plan' or DeveloperName = 'Sales_Manager_Plan')]) {
			if(recordType.DeveloperName == 'AM_Plan'){
				recordTypeAM = recordType.Id;				
			} else if(recordType.DeveloperName == 'FE_Plan') {				
				recordTypeFE = recordType.Id;
			}else if (recordType.DeveloperName == 'GAM_Plan') {				
				recordTypeGAM = recordType.Id;
			}else {			
				recordTypeMM = recordType.Id;
			}
		}
		SIP__c sipAM = new SIP__c();
		sipAM.Plan_Participant__c = user.Id;
		sipAM.RecordTypeId = recordTypeAM;
		sipAM.Plan_Year__c = '2013';
		sipAM.Name = 'test AM';
		sipAM.SIP_master_record__c = sipMaster.Id;
		sipAM.SIP_Mapping__c = sipMapping.Id;
		insert sipAM;
		
		sipMapping.Name = 'Test mapping';
		
		update sipMapping;
		
		test.stopTest();
		
    } 
    static testMethod void myUnitAM1Test() {
    	addCustomSetting();
    	list<SIP__c> list_sipPopulateOpportunityData = new list<SIP__c>();
		list<SIP__c> list_sipPopulateBillings = new list<SIP__c>();
		set<String> set_AMCodes = new set<String>();
		set<String> set_FECodes = new set<String>();
		set<String> set_GAMCodes = new set<String>();
		map<Id,set<String>> map_sipId_set_amCode = new map<Id,set<String>>();
		map<Id,set<String>> map_sipId_set_feCode = new map<Id,set<String>>();
		map<Id,set<String>> map_sipId_set_gamCode = new map<Id,set<String>>();
		map<String, set<String>> map_sipId_set_profitCtrs4GAM = new map<String, set<String>>();
    	
		User user = new User();
		user=ClsTestHelp.createTestUsers();
		user.Te_Network_Id__c = 'testUser';
		user.username = 'test1111.te@test1111.com';
		insert user;
		
		Sales_Hierarchy__c salesHierarchyAM1 = new Sales_Hierarchy__c(Hierarchy_Type__c  = 'Sales Hierarchy (AM)' ,Level_7_Assigned_User_Network_Ids__c='testUser',Level_7_Territory_Code__c = 'testAM1');
		
		insert salesHierarchyAM1;
		System.assertEquals('testUser', salesHierarchyAM1.Level_7_Assigned_User_Network_Ids__c);
		System.assertEquals('testAM1', salesHierarchyAM1.Level_7_Territory_Code__c);
		
		
		String recordTypeAM;
		
		for (RecordType recordType : [select Id, Name, DeveloperName from RecordType where SobjectType = 'SIP__c' and IsActive = true and (DeveloperName = 'AM_Plan' or DeveloperName = 'FE_Plan' or DeveloperName = 'GAM_Plan' or DeveloperName = 'Sales_Manager_Plan')]) {
			if(recordType.DeveloperName == 'AM_Plan'){
				recordTypeAM = recordType.Id;				
			}
		}
		SIP_master__c sipMaster = new SIP_master__c();
		sipMaster.Name = 'Test Master';
		insert sipMaster;
		
		list<SIP__c> list_sips = new list<SIP__c>();
		
		SIP__c sipAM = new SIP__c();
		sipAM.Plan_Participant__c = user.Id;
		sipAM.RecordTypeId = recordTypeAM;
		sipAM.Plan_Year__c = '2013';
		sipAM.Name = 'test AM';
		sipAM.SIP_master_record__c = sipMaster.Id;
		sipAM.Prev_Year_YTD_Direct_billings__c  = 100;
		//sipAM.Exclude_From_Automatic_Update__c = false;
		sipAM.Profit_Center_Codes__c = 'A&C';
		insert sipAM;
		
		sipAM = [Select AM_codes__c, RecordType.DeveloperName, Approver__c, Business_Driver_1__c, Business_Driver_1_Achieved__c, Business_Driver_1_Weighting__c, Business_Driver_1_details__c, Business_Driver_2__c, Business_Driver_2_Achieved__c, Business_Driver_2_Weighting__c, Business_Driver_2_details__c, Business_Driver_3__c, Business_Driver_3_Achieved__c, Business_Driver_3_Weighting__c, Business_Driver_3_details__c, Business_Driver_4__c, Business_Driver_4_Achieved__c, Business_Driver_4_Weighting__c, Business_Driver_4_details__c, Conversion_result__c, CreatedById, CreatedDate, CurrencyIsoCode, Current_Fiscal_Year_Direct__c, Current_Fiscal_Year_Indirect__c, IsDeleted, Exceptional_Perf_Conversion_Target_Dolla__c, Exceptional_Perf_Conversion_Target__c, Exceptional_Perf_Growth_Target_Dollar__c, Exceptional_Perf_Growth_Reve__c, FE_codes__c, GAM_codes__c, Industrial_Performance_Weighting__c, LastModifiedById, LastModifiedDate, Level_1_Conversion_Target_Dollar__c, Level_1_Conversion_target__c, Level_1_Growth_Target_Dollar__c, Level_1_Growth_Target__c, Level_1_Pipeline_Target_Dollar__c, Level_1_Pipeline_Target__c, Level_2_Conversion_Target_Dollar__c, Level_2_Conversion_Target__c, Level_2_Growth_Target_Dollar__c, Level_2_Growth_Target__c, Level_2_Pipeline_Target_Dollar__c, Level_2_Pipeline_Target__c, Level_3_Conversion_Target_Dollar__c, Level_3_Conversion_Target__c, Level_3_Growth_Target_Dollar__c, Level_3_Growth_Target__c, Level_3_Pipeline_Target_Dollar__c, Level_3_Pipeline_Target__c, Load_Status_Direct_Billings__c, Load_Status_Monthly_Direct__c, Load_Status_POS__c, Load_Status_Record_Indirect__c, OwnerId, Participants_Manager__c, Participants_TE_Network_ID__c, Pipeline_Result__c, Plan_Comments__c, Plan_Participant__c, Plan_Year__c, Current_Year_Direct_Bill_YTD__c, Current_Year_Direct_Billings_Run_Rate__c, Current_Year_POS_Bill_YTD__c, Current_Year_POS_Run_Rate__c, Prev_Year_1__c, Prev_Year_1_POS_Result__c, Prev_Year_1_Total_Result__c, Prev_Year_Conversion_YTD_Result_Dollar__c, Prev_Year_Conversion_YTD_Result__c, Prev_Year_Dir_Bill_Run_Rate_Result__c, Prev_Year_Growth__c, Prev_Year_POS_Run_Rate_Result__c, Prev_Year_Pipeline_YTD_Result_Dollar__c, Prev_Year_Pipeline_YTD_Result__c, Total_Revenue_Baseline__c, Prev_Year_YTD_Direct_billings__c, Prev_Year_YTD_POS__c, Profit_Center_Codes__c, ConnectionReceivedId, Id, RecordTypeId, Region__c, Name, ConnectionSentId, SystemModstamp from SIP__c where Id =: sipAM.Id];
		System.assertEquals('testUser', sipAM.Participants_TE_Network_ID__c);				
		
		list_sips.add(sipAM);
		test.startTest(); 
    	Test.setMock(HttpCalloutMock.class, new ClsTestWSMockUtil.RunReportMockHttpResponseGenerator());

		ClsSIPUitl.recalcBillingAndOppyData(list_sips, list_sipPopulateOpportunityData, list_sipPopulateBillings, set_AMCodes, set_FECodes, set_GAMCodes, map_sipId_set_amCode, map_sipId_set_feCode, map_sipId_set_gamCode, map_sipId_set_profitCtrs4GAM);
		
		test.stopTest();

    } 
    static testMethod void addCustomSetting() {
        ClsTestCustomSettingHelper.getAllSettings();
        ClsTestCustomSettingHelper.getTrigger_Configuration();//added by Michael Ludwig
    	list<SIP_Sharing_Setting__c> list_settings = new list<SIP_Sharing_Setting__c>();
    	SIP_Sharing_Setting__c setting01 = new SIP_Sharing_Setting__c();
    	setting01.Name = 'SIP Run Report Scheduled Job Id';
    	setting01.Value__c = '000x0x0x0x0x0';
    	list_settings.add(setting01);
    	SIP_Sharing_Setting__c setting02 = new SIP_Sharing_Setting__c();
    	setting02.Name = 'SIP Running Scheduled';
    	setting02.Value__c = '000x0x0x0x0x0';
    	list_settings.add(setting02);
    	SIP_Sharing_Setting__c setting1 = new SIP_Sharing_Setting__c();
    	setting1.Name = 'SIP batch refresh token';
    	setting1.Value__c = 'SIP batch refresh token';
    	list_settings.add(setting1);
    	SIP_Sharing_Setting__c setting2 = new SIP_Sharing_Setting__c();
    	setting2.Name = 'SIP batch customer Id';
    	setting2.Value__c = 'SIP batch customer Id';
    	list_settings.add(setting2);
    	SIP_Sharing_Setting__c setting3 = new SIP_Sharing_Setting__c();
    	setting3.Name = 'SIP batch secret Id';
    	setting3.Value__c = 'SIP batch secret Id';
    	list_settings.add(setting3);
    	SIP_Sharing_Setting__c setting4 = new SIP_Sharing_Setting__c();
    	setting4.Name = 'Approver';
    	setting4.Value__c = 'Read';
    	list_settings.add(setting4);
    	SIP_Sharing_Setting__c setting5 = new SIP_Sharing_Setting__c();
    	setting5.Name = 'Participant';
    	setting5.Value__c = 'Read';
    	list_settings.add(setting5);
    	SIP_Sharing_Setting__c setting6 = new SIP_Sharing_Setting__c();
    	setting6.Name = 'Participant Manager';
    	setting6.Value__c = 'Read';
    	list_settings.add(setting6);
    	SIP_Sharing_Setting__c setting7 = new SIP_Sharing_Setting__c();
    	setting7.Name = 'FE SIP Oppy RecordTypeId';
    	for(RecordType recordType : [select Id, Name, DeveloperName 
    								 from RecordType 
    								 where SobjectType = 'Opportunity'
    								 And DeveloperName IN ('Opportunity_Engineering_Project',
    								 'Opportunity_Sales_Parts_Only', 'IND_Sales_Project', 'IND_Engineering_project')]) {
    		
	    	setting7.Value__c += (recordType.Id + ',');
    	}
    	list_settings.add(setting7);
    	
    	SIP_Sharing_Setting__c setting8 = new SIP_Sharing_Setting__c();
    	setting8.Name = 'Callout End Point';
    	setting8.Value__c = 'xxxx';
    	list_settings.add(setting8);
    	
    	SIP_Sharing_Setting__c setting9 = new SIP_Sharing_Setting__c();
    	setting9.Name = 'SIP PM RecordType DeveloperNames';
    	setting9.Value__c = 'PM_Plan_FY15,PM_CCAO_FY15,PM_Plan_FY16';
    	list_settings.add(setting9);
    	
    	SIP_Sharing_Setting__c setting10 = new SIP_Sharing_Setting__c();
    	setting10.Name = 'SIP FE RecordType DeveloperNames';
    	setting10.Value__c = 'PFE_Plan_FY15,FE_Plan_FY16,FE_Plan';
    	list_settings.add(setting10);
    	
    	SIP_Sharing_Setting__c setting11 = new SIP_Sharing_Setting__c();
    	setting11.Name = 'SIP AM RecordType DeveloperNames';
    	setting11.Value__c = 'AM_Plan_FY15,AM_Plan_FY16,AM_Plan';
    	list_settings.add(setting11);
    	SIP_Sharing_Setting__c setting12 = new SIP_Sharing_Setting__c();
    	setting12.Name = 'Fetch Job Start Time';
    	setting12.Job_Start_Time__c = system.now().addHours(-1);
    	list_settings.add(setting12);
    	SIP_Sharing_Setting__c setting13 = new SIP_Sharing_Setting__c();
    	setting13.Name = 'Max Run Hours';
    	setting13.value__c = '3';
    	list_settings.add(setting13);
		
    	Apex_Helper_Settings__c ahs1 = ClsTestHelp.createTestName1();
    	Apex_Helper_Settings__c ahs2 = ClsTestHelp.createTestName2();
    	Apex_Helper_Settings__c ahs3 = ClsTestHelp.createTestName3();
    	Apex_Helper_Settings__c ahs4 = ClsTestHelp.createTestName4();
    	Apex_Helper_Settings__c ahs5 = ClsTestHelp.createTestName5();
    	Apex_Helper_Settings__c ahs6 = ClsTestHelp.createTestName6();
    	Apex_Helper_Settings__c ahs7 = ClsTestHelp.createTestName7();
    	Apex_Helper_Settings__c ahs8 = ClsTestHelp.createTestName8();
    	Apex_Helper_Settings__c ahs9 = ClsTestHelp.createTestName9();
    	Apex_Helper_Settings__c ahs10 = ClsTestHelp.createTestName10();
    	Apex_Helper_Settings__c ahs11 = ClsTestHelp.createTestName11();
    	
    	Consumer_Device_Opportunity_Record_Types__c cdort1 = ClsTestHelp.createTestCSD1();
    	Consumer_Device_Opportunity_Record_Types__c cdort2 = ClsTestHelp.createTestCSD2();
    	Consumer_Device_Opportunity_Record_Types__c cdort3 = ClsTestHelp.createTestCSD3();
    	Consumer_Device_Opportunity_Record_Types__c cdort4 = ClsTestHelp.createTestCSD4();
    	Consumer_Device_Opportunity_Record_Types__c cdort5 = ClsTestHelp.createTestCSD5();
    	Consumer_Device_Opportunity_Record_Types__c cdort6 = ClsTestHelp.createTestCSD6();
    	Consumer_Device_Opportunity_Record_Types__c cdort7 = ClsTestHelp.createTestCSD7();
    	
    	insert list_settings;
    }
    static testMethod void tokenUnitTest() {
    	addCustomSetting();
    	Test.startTest();
    	Test.setMock(HttpCalloutMock.class, new ClsTestWSMockUtil.TokenMockHttpResponseGenerator());
    	ClsSIPUitl.getSessionId();
    	ClsSIPUitl.getCurrentFiscalYear();
    	Test.stopTest();
    }
    static testMethod void getSipBillingTest() {
    	addCustomSetting();
		list<SIP__c> list_sipPopulateOpportunityData = new list<SIP__c>();
		list<SIP__c> list_sipPopulateBillings = new list<SIP__c>();
		set<String> set_AMCodes = new set<String>();
		set<String> set_FECodes = new set<String>();
		set<String> set_GAMCodes = new set<String>();
		map<Id,set<String>> map_sipId_set_amCode = new map<Id,set<String>>();
		map<Id,set<String>> map_sipId_set_feCode = new map<Id,set<String>>();
		map<Id,set<String>> map_sipId_set_gamCode = new map<Id,set<String>>();
		map<String, set<String>> map_sipId_set_profitCtrs4GAM = new map<String, set<String>>();
    	test.startTest(); 
    	Test.setMock(HttpCalloutMock.class, new ClsTestWSMockUtil.RunReportMockHttpResponseGenerator());

		User user = new User();
		user=ClsTestHelp.createTestUsers();
		user.Te_Network_Id__c = 'testUser';
		user.username = 'test333333.te@test31111.com';
		insert user;
		
		list<Sales_Hierarchy__c> list_Hierarchy = new list<Sales_Hierarchy__c>();
		Sales_Hierarchy__c salesHierarchyAM1 = new Sales_Hierarchy__c(Hierarchy_Type__c  = 'Sales Hierarchy (AM)' ,Level_7_Assigned_User_Network_Ids__c='testUser',Level_7_Territory_Code__c = 'testAM1');
		Sales_Hierarchy__c salesHierarchyAM2 = new Sales_Hierarchy__c(Hierarchy_Type__c  = 'Sales Hierarchy (AM)' ,Level_7_Assigned_User_Network_Ids__c='testUser;testUser2',Level_7_Territory_Code__c = 'testAM2');
		Sales_Hierarchy__c salesHierarchyAM3 = new Sales_Hierarchy__c(Hierarchy_Type__c  = 'Account Manager Hierarchy (FE)' ,Level_7_Assigned_User_Network_Ids__c='testUser;testUser2',Level_7_Territory_Code__c = 'testFE');
		//insert salesHierarchyAM1;
		System.assertEquals('testUser', salesHierarchyAM1.Level_7_Assigned_User_Network_Ids__c);
		System.assertEquals('testAM1', salesHierarchyAM1.Level_7_Territory_Code__c);
		//insert salesHierarchyAM2;
		System.assertEquals('testUser;testUser2', salesHierarchyAM2.Level_7_Assigned_User_Network_Ids__c);
		System.assertEquals('testAM2', salesHierarchyAM2.Level_7_Territory_Code__c);
		//insert salesHierarchyAM3;
		list_Hierarchy.add(salesHierarchyAM1);
		list_Hierarchy.add(salesHierarchyAM2);
		list_Hierarchy.add(salesHierarchyAM3);
		insert list_Hierarchy;
		
		String recordTypeAM;
		String recordTypeFE;
		String recordTypeGAM;
		String recordTypeMM;
		
		for (RecordType recordType : [select Id, Name, DeveloperName from RecordType where SobjectType = 'SIP__c' and IsActive = true and (DeveloperName = 'AM_Plan' or DeveloperName = 'FE_Plan' or DeveloperName = 'GAM_Plan' or DeveloperName = 'Sales_Manager_Plan')]) {
			if(recordType.DeveloperName == 'AM_Plan'){
				recordTypeAM = recordType.Id;				
			} else if(recordType.DeveloperName == 'FE_Plan') {				
				recordTypeFE = recordType.Id;
			}else if (recordType.DeveloperName == 'GAM_Plan') {				
				recordTypeGAM = recordType.Id;
			}else {			
				recordTypeMM = recordType.Id;
			}
		}
		SIP_master__c sipMaster = new SIP_master__c();
		sipMaster.Name = 'Test Master';
		insert sipMaster;
		
		list<SIP__c> list_sips2Insert = new list<SIP__c>();
		list<SIP__c> list_sips = new list<SIP__c>();
		
		SIP__c sipAM = new SIP__c();
		sipAM.Plan_Participant__c = user.Id;
		sipAM.RecordTypeId = recordTypeAM;
		sipAM.Plan_Year__c = '2014';
		sipAM.Name = 'test AM';
		sipAM.SIP_master_record__c = sipMaster.Id;
		sipAM.Prev_Year_YTD_Direct_billings__c  = 100;
		//sipAM.Exclude_From_Automatic_Update__c = false;
		sipAM.Profit_Center_Codes__c = 'A&C';
		
		insert sipAM;
		RecordType rt2 = ClsTestHelp.createTestRecordType8();
        Account acc2 = ClsTestHelp.createTestAccounts();
        acc2.RecordTypeId = rt2.Id;
        acc2.Name = 'Xxx1';
        acc2.Account_Manager__c = UserInfo.getUserId();
        acc2.SALES_TERRITORY_CDE__c = 'A103754';
        acc2.Sales_Hierarchy__c = salesHierarchyAM1.Id;
        acc2.Legally_Restricted__c = true;
        acc2.Individually_Planned__c = true;
        acc2.Individually_Forecasted__c = true;
        acc2.Customer_Classification__c = 'A';
    	acc2.Type = 'Global Account';
    	acc2.GAMCD__c = '1000';
    	acc2.SALES_TERRITORY_CDE__c = 'A004841';
        insert acc2;
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Account_Manager__c = UserInfo.getUserId();
        acc.RecordTypeId = rt2.Id;
        acc.SALES_TERRITORY_CDE__c = 'A103754';
        acc.Sales_Hierarchy__c = salesHierarchyAM1.Id;
        acc.Legally_Restricted__c = true;
        acc.Individually_Planned__c = false;
        acc.Individually_Forecasted__c = true;
        acc.Plan_Group_Account__c = acc2.Id;
        acc.Plan_Group_Id__c = acc2.Id;
        acc.Customer_Classification__c = 'A';
    	acc.Type = 'Global Account';
    	acc.GAMCD__c = '1000';
    	acc.SALES_TERRITORY_CDE__c = 'A004841';
        insert acc;
        list<BBB_Month_Bill_Book_Cust__c> list_bbbm = new list<BBB_Month_Bill_Book_Cust__c>();
        
    	BBB_Month_Bill_Book_Cust__c bbb = new BBB_Month_Bill_Book_Cust__c();
    	bbb.Customer__c = acc.Id;
    	bbb.Fiscal_Year__c = '2013';
    	bbb.Fiscal_Month__c = 1;
    	bbb.Bill_Type__c = 'Direct';
    	bbb.Budget_Direct__c = 1;
    	bbb.Budget_POS__c = 2;
    	bbb.Budget_CMA__c = 3;
    	bbb.Budget_TBR_NY__c = 12;
    	bbb.Bill_Amount_USD__c = 1200;
    	bbb.Budget_Document_Currency__c = 11;
    	bbb.CurrencyIsoCode = 'EUR';
    	bbb.Monthly_BBB_External_Key__c = null;
    	bbb.Is_Comment__c = true;
    	bbb.IND_Profit_Centre_Groups__c = 'abc';
    	bbb.SAP_Profit_Center_Code__c = 'G0123';
    	bbb.Comment__c = '<comments><comment value="100">Comment about a positive forecast risk</comment><comment value="-80">Comment about a negative forecast risk</comment></comments>';
    	//insert bbb;
		list_bbbm.add(bbb);
		
    	BBB_Month_Bill_Book_Cust__c bbb1 = new BBB_Month_Bill_Book_Cust__c();
    	bbb1.Customer__c = acc.Id;
    	bbb1.Fiscal_Year__c = '2013';
    	bbb1.Fiscal_Month__c = 1;
    	bbb1.Bill_Type__c = 'POS';
    	bbb1.Budget_Direct__c = 1;
    	bbb1.Bill_Amount_USD__c = 100;
    	bbb1.Budget_POS__c = 2;
    	bbb1.Budget_CMA__c = 3;
    	bbb1.Budget_TBR_NY__c = 12;
    	bbb1.Budget_Document_Currency__c = 11;
    	bbb1.CurrencyIsoCode = 'EUR';
    	bbb1.Monthly_BBB_External_Key__c = null;
    	bbb1.Is_Comment__c = true;
    	bbb1.IND_Profit_Centre_Groups__c = 'abc';
    	bbb1.SAP_Profit_Center_Code__c = 'G0123';
    	bbb1.Comment__c = '<comments><comment value="100">Comment about a positive forecast risk</comment><comment value="-80">Comment about a negative forecast risk</comment></comments>';
    	//insert bbb;
		list_bbbm.add(bbb1);
		
    	BBB_Month_Bill_Book_Cust__c bbb2 = new BBB_Month_Bill_Book_Cust__c();
    	bbb2.Customer__c = acc.Id;
    	bbb2.Fiscal_Year__c = '2012';
    	bbb2.Fiscal_Month__c = 1;
    	bbb2.Bill_Type__c = 'Direct';
    	bbb2.Budget_Direct__c = 1;
    	bbb2.Budget_POS__c = 2;
    	bbb2.Budget_CMA__c = 3;
    	bbb2.Budget_TBR_NY__c = 12;
    	bbb2.Bill_Amount_USD__c = 1200;
    	bbb2.Budget_Document_Currency__c = 11;
    	bbb2.CurrencyIsoCode = 'EUR';
    	bbb2.Monthly_BBB_External_Key__c = null;
    	bbb2.Is_Comment__c = true;
    	bbb2.IND_Profit_Centre_Groups__c = 'abc';
    	bbb2.SAP_Profit_Center_Code__c = 'G0123';
    	bbb2.Comment__c = '<comments><comment value="100">Comment about a positive forecast risk</comment><comment value="-80">Comment about a negative forecast risk</comment></comments>';
    	//insert bbb;
		list_bbbm.add(bbb2);
		
    	BBB_Month_Bill_Book_Cust__c bbb3 = new BBB_Month_Bill_Book_Cust__c();
    	bbb3.Customer__c = acc.Id;
    	bbb3.Fiscal_Year__c = '2012';
    	bbb3.Fiscal_Month__c = 1;
    	bbb3.Bill_Type__c = 'POS';
    	bbb3.Budget_Direct__c = 1;
    	bbb3.Bill_Amount_USD__c = 100;
    	bbb3.Budget_POS__c = 2;
    	bbb3.Budget_CMA__c = 3;
    	bbb3.Budget_TBR_NY__c = 12;
    	bbb3.Budget_Document_Currency__c = 11;
    	bbb3.CurrencyIsoCode = 'EUR';
    	bbb3.Monthly_BBB_External_Key__c = null;
    	bbb3.Is_Comment__c = true;
    	bbb3.IND_Profit_Centre_Groups__c = 'abc';
    	bbb3.SAP_Profit_Center_Code__c = 'G0123';
    	bbb3.Comment__c = '<comments><comment value="100">Comment about a positive forecast risk</comment><comment value="-80">Comment about a negative forecast risk</comment></comments>';
    	//insert bbb;
		list_bbbm.add(bbb3);
    	BBB_Month_Bill_Book_Cust__c bbb4 = new BBB_Month_Bill_Book_Cust__c();
    	bbb4.Customer__c = acc.Id;
    	bbb4.Fiscal_Year__c = '2014';
    	bbb4.Fiscal_Month__c = 1;
    	bbb4.Bill_Type__c = 'POS';
    	bbb4.Budget_Direct__c = 1;
    	bbb4.Bill_Amount_USD__c = 100;
    	bbb4.Budget_POS__c = 2;
    	bbb4.Budget_CMA__c = 3;
    	bbb4.Budget_TBR_NY__c = 12;
    	bbb4.Budget_Document_Currency__c = 11;
    	bbb4.CurrencyIsoCode = 'EUR';
    	bbb4.Monthly_BBB_External_Key__c = null;
    	bbb4.Is_Comment__c = true;
    	bbb4.IND_Profit_Centre_Groups__c = 'abc';
    	bbb4.SAP_Profit_Center_Code__c = 'G0123';
    	bbb4.Comment__c = '<comments><comment value="100">Comment about a positive forecast risk</comment><comment value="-80">Comment about a negative forecast risk</comment></comments>';
    	//insert bbb;
		list_bbbm.add(bbb4);
    	BBB_Month_Bill_Book_Cust__c bbb5 = new BBB_Month_Bill_Book_Cust__c();
    	bbb5.Customer__c = acc.Id;
    	bbb5.Fiscal_Year__c = '2014';
    	bbb5.Fiscal_Month__c = 1;
    	bbb5.Bill_Type__c = 'Direct';
    	bbb5.Budget_Direct__c = 1;
    	bbb5.Bill_Amount_USD__c = 100;
    	bbb3.Budget_POS__c = 2;
    	bbb5.Budget_CMA__c = 3;
    	bbb5.Budget_TBR_NY__c = 12;
    	bbb5.Budget_Document_Currency__c = 11;
    	bbb5.CurrencyIsoCode = 'EUR';
    	bbb5.Monthly_BBB_External_Key__c = null;
    	bbb5.Is_Comment__c = true;
    	bbb5.IND_Profit_Centre_Groups__c = 'abc';
    	bbb5.SAP_Profit_Center_Code__c = 'G0123';
    	bbb5.Comment__c = '<comments><comment value="100">Comment about a positive forecast risk</comment><comment value="-80">Comment about a negative forecast risk</comment></comments>';
    	//insert bbb;
		list_bbbm.add(bbb5);
		
    	BBB_Month_Bill_Book_Cust__c bbb6 = new BBB_Month_Bill_Book_Cust__c();
    	bbb6.Customer__c = acc.Id;
    	bbb6.Fiscal_Year__c = '2016';
    	bbb6.Fiscal_Month__c = 1;
    	bbb6.Bill_Type__c = 'Direct';
    	bbb6.Budget_Direct__c = 1;
    	bbb6.Budget_POS__c = 2;
    	bbb6.Budget_CMA__c = 3;
    	bbb6.Budget_TBR_NY__c = 12;
    	bbb6.Budget_Document_Currency__c = 11;
    	bbb6.CurrencyIsoCode = 'EUR';
    	bbb6.Monthly_BBB_External_Key__c = null;
    	bbb6.Is_Comment__c = true;
    	bbb6.IND_Profit_Centre_Groups__c = 'abc';
    	bbb6.SAP_Profit_Center_Code__c = 'G0123';
    	bbb6.Comment__c = '<comments><comment value="100">Comment about a positive forecast risk</comment><comment value="-80">Comment about a negative forecast risk</comment></comments>';
    	//insert bbb;
		list_bbbm.add(bbb6);
		insert list_bbbm;
		for(AggregateResult  bMonBilBoCu :[Select sum(Bill_Amount_USD__c) sum_billAmoutUSD,Customer__c salesTerritoryCde, Bill_Type__c billType, Fiscal_Year__c fiscalYear  
                                              From BBB_Month_Bill_Book_Cust__c   
                                              where Customer__r.Sales_Hierarchy__c != null  and (Bill_Type__c = 'POS'  or Bill_Type__c = 'Direct')
                                              group by  Fiscal_Year__c, Bill_Type__c,Customer__c ]) {
        	ClsSIPUitl.getSipBilling(sipAM, bMonBilBoCu);
        }
        
        list<ClsSIPUitl.ReportMap> list_maps = new list<ClsSIPUitl.ReportMap>();
        ClsSIPUitl.ReportMap map1 = new ClsSIPUitl.ReportMap();
        map1.reportId = '001';
        map1.reportInstanceId = '001';
        list_maps.add(map1);
        ClsSIPUitl.ReportMap map2 = new ClsSIPUitl.ReportMap();
        map2.reportId = '002';
        map2.reportInstanceId = '002';
        list_maps.add(map2);
        list_maps.sort();
        
        ClsSIPUitl.ReportRequestMetadata rtMeta = new ClsSIPUitl.ReportRequestMetadata();
        rtMeta.STRCURRENCY = 'xxx';
        rtMeta.developerName = 'xxx';
        rtMeta.aggregates = new list<String>();
        rtMeta.detailColumns = new list<String>();
        
		test.stopTest();
    }
    
    static testMethod void populatDataFromReportAsyn_UnitTest() {

    	addCustomSetting();
    	Test.startTest();
    	list<User> list_user = new list<User>();
		User user = new User();
		user=ClsTestHelp.createTestUsers();
		user.Te_Network_Id__c = 'testUser';
		user.username = 'test2081.te@test991.com';
		//insert user;
		list_user.add(user);
		User user2 = new User();
		user2=ClsTestHelp.createTestUsers();
		user2.Te_Network_Id__c = 'testUser2';
		user2.username = 'test2082.te@test991.com';
		user2.FirstName ='First1';
        user2.LastName = 'Tester2';
        user2.Alias = 'mtst2';
        user2.CommunityNickname = user2.Alias;
		//insert user2;
		list_user.add(user2);
		User user3 = new User();
		user3=ClsTestHelp.createTestUsers();
		user3.Te_Network_Id__c = 'testUser3';
		user3.username = 'test2083.te@test991.com';
		user3.FirstName ='First3';
        user3.LastName = 'Tester3';
        user3.Alias = 'mtst3';
        user3.CommunityNickname = user3.Alias;
		list_user.add(user3);
		
		User user4 = new User();
		user4=ClsTestHelp.createTestUsers();
		user4.Te_Network_Id__c = 'testUser4';
		user4.username = 'test2084.te@test991.com';
		user4.FirstName ='First4';
        user4.LastName = 'Tester4';
        user4.Alias = 'mtst4';
        user4.CommunityNickname = user4.Alias;
		list_user.add(user4);
		insert list_user;
			
		Sales_Hierarchy__c salesHierarchyAM3 = new Sales_Hierarchy__c(Hierarchy_Type__c  = 'Account Manager Hierarchy (FE)' ,Level_7_Assigned_User_Network_Ids__c='testUser;testUser2',Level_7_Territory_Code__c = 'testFE');
  		
		insert salesHierarchyAM3;
		
  		Product_Hierarchy__c ph = new Product_Hierarchy__c();
  		ph.Hierarchy_Level_Type__c = 'CBC1';
  		ph.Description__c = 'Industrial';
  		ph.Name = 'T01';
  		ph.Regional_PM_EU__c = user.Id;
  		insert ph;
		String recordTypeFE;
		
		for (RecordType recordType : [select Id, Name, DeveloperName from RecordType where SobjectType = 'SIP__c' and IsActive = true and DeveloperName = 'FE_Plan']) {
			if(recordType.DeveloperName == 'FE_Plan') {				
				recordTypeFE = recordType.Id;
			}
		}
		SIP_master__c sipMaster = new SIP_master__c();
		sipMaster.Name = 'Test Master';
		insert sipMaster;				
		SIP_Mapping__c sipMapping = new SIP_Mapping__c();		
		sipMapping.Report_Field_1__c = 'T!0_1';
		sipMapping.Report_ID_1__c = '00OE0000002QYDq';
		sipMapping.Report_Parameters_1__c = 'AM_Codes__c,2';
		sipMapping.Target_Field_1__c = 'Prev_Year_YTD_POS__c';
		sipMapping.Target_Field_Name_1__c = 'Revenue Base Line';
		insert sipMapping;
		
		SIP__c sipFE = new SIP__c();
		sipFE.Plan_Participant__c = user.Id;
		sipFE.RecordTypeId = recordTypeFE;
		sipFE.Plan_Year__c = '2013';
		sipFE.Name = 'test FE';
		sipFE.SIP_master_record__c = sipMaster.Id;
		sipFE.Prev_Year_YTD_Direct_billings__c  = 100;
		sipFE.Profit_Center_Codes__c = 'A&C';
		sipFE.SIP_Mapping__c = sipMapping.Id;
		sipFE.Plan_Participant__c = user.Id;
		insert sipFE;
		
		SIP__Share sipShare = new SIP__Share();
        sipShare.ParentId = sipFE.Id;
        sipShare.UserOrGroupId = user3.Id;
        sipShare.AccessLevel = 'Read';
        sipShare.RowCause = 'Participant_And_Manager__c';
        insert sipShare;
                        
		sipFE = [Select GPLs__c, AM_codes__c, RecordType.DeveloperName, Approver__c, Business_Driver_1__c, Business_Driver_1_Achieved__c, Business_Driver_1_Weighting__c, Business_Driver_1_details__c, Business_Driver_2__c, Business_Driver_2_Achieved__c, Business_Driver_2_Weighting__c, Business_Driver_2_details__c, Business_Driver_3__c, Business_Driver_3_Achieved__c, Business_Driver_3_Weighting__c, Business_Driver_3_details__c, Business_Driver_4__c, Business_Driver_4_Achieved__c, Business_Driver_4_Weighting__c, Business_Driver_4_details__c, Conversion_result__c, CreatedById, CreatedDate, CurrencyIsoCode, Current_Fiscal_Year_Direct__c, Current_Fiscal_Year_Indirect__c, IsDeleted, Exceptional_Perf_Conversion_Target_Dolla__c, Exceptional_Perf_Conversion_Target__c, Exceptional_Perf_Growth_Target_Dollar__c, Exceptional_Perf_Growth_Reve__c, FE_codes__c, GAM_codes__c, Industrial_Performance_Weighting__c, LastModifiedById, LastModifiedDate, Level_1_Conversion_Target_Dollar__c, Level_1_Conversion_target__c, Level_1_Growth_Target_Dollar__c, Level_1_Growth_Target__c, Level_1_Pipeline_Target_Dollar__c, Level_1_Pipeline_Target__c, Level_2_Conversion_Target_Dollar__c, Level_2_Conversion_Target__c, Level_2_Growth_Target_Dollar__c, Level_2_Growth_Target__c, Level_2_Pipeline_Target_Dollar__c, Level_2_Pipeline_Target__c, Level_3_Conversion_Target_Dollar__c, Level_3_Conversion_Target__c, Level_3_Growth_Target_Dollar__c, Level_3_Growth_Target__c, Level_3_Pipeline_Target_Dollar__c, Level_3_Pipeline_Target__c, Load_Status_Direct_Billings__c, Load_Status_Monthly_Direct__c, Load_Status_POS__c, Load_Status_Record_Indirect__c, OwnerId, Participants_Manager__c, Participants_TE_Network_ID__c, Pipeline_Result__c, Plan_Comments__c, Plan_Participant__c, Plan_Year__c, Current_Year_Direct_Bill_YTD__c, Current_Year_Direct_Billings_Run_Rate__c, Current_Year_POS_Bill_YTD__c, Current_Year_POS_Run_Rate__c, Prev_Year_1__c, Prev_Year_1_POS_Result__c, Prev_Year_1_Total_Result__c, Prev_Year_Conversion_YTD_Result_Dollar__c, Prev_Year_Conversion_YTD_Result__c, Prev_Year_Dir_Bill_Run_Rate_Result__c, Prev_Year_Growth__c, Prev_Year_POS_Run_Rate_Result__c, Prev_Year_Pipeline_YTD_Result_Dollar__c, Prev_Year_Pipeline_YTD_Result__c, Total_Revenue_Baseline__c, Prev_Year_YTD_Direct_billings__c, Prev_Year_YTD_POS__c, Profit_Center_Codes__c, ConnectionReceivedId, Id, RecordTypeId, Region__c, Name, ConnectionSentId, SystemModstamp from SIP__c where Id =: sipFE.Id];
		map<String, SIP__c> map_sipId_sip = new map<String, sip__c>{sipFE.Id => sipFE}; 
		map<String, ClsSIPUitl.SIPCustomExcMSG> map_sipId_exception = new map<String, ClsSIPUitl.SIPCustomExcMSG>();
		map<String, list<ClsSIPUitl.ReportMap>> map_sipMappingId_list_reportMap = new map<String, list<ClsSIPUitl.ReportMap>>{sipMapping.Id => new list<ClsSIPUitl.ReportMap>()};
    	Test.setMock(HttpCalloutMock.class, new ClsTestWSMockUtil.RunReportMockHttpResponseGenerator());
		ClsSIPUitl.populatDataFromReportAsyn(map_sipId_sip, map_sipId_exception, map_sipMappingId_list_reportMap, 'token');
		ClsSIPUitl.reScheduleJobToRunReport(false, 3, 'xxxx', new list<ClsSIPUitl.SIPCustomExcMSG>());
		
		list<ClsSIPUitl.SIPCustomExcMSG> list_exceptions = new list<ClsSIPUitl.SIPCustomExcMSG>();
		ClsSIPUitl.SIPCustomExcMSG ex = new ClsSIPUitl.SIPCustomExcMSG();
		ex.sipId = 'xxxx';
		ex.errorMsg = 'xxxxx';
		list_exceptions.add(ex);
		set<String> set_successIds = new set<String>{'1111', '2222'};
		boolean isSubmit = true;
		ClsSIPUitl.reportBatchStatus(list_exceptions, set_successIds, isSubmit);
		ClsSIPUitl.reScheduleJobToRunReport(true, 2, 'xxxxx', list_exceptions);
		ClsSIPUitl.reScheduleJobToFetchReportData(true, '', new map<String, ClsSIPUitl.SIPCustomExcMSG>(), true);
		
		map<String,map<String, String>> map_sipId_map_userIds_access1 = new map<String,map<String, String>>();
		map_sipId_map_userIds_access1.put(sipFE.Id, new map<String, String>{user2.Id => 'Read', user.Id => 'Read'});
		map<String,map<String, String>> map_sipId_map_userIds_access = new map<String,map<String, String>>();
		map_sipId_map_userIds_access.put(sipFE.Id, new map<String, String>{user2.Id => 'Edit', user.Id => 'Read', user4.Id => 'Read'});
		for(SIP__c sip : [select Id, Plan_Participant__r.isActive, Plan_Participant__c 
						  From SIP__c
						  Where Id =: sipFE.Id]) {
						  
			sipFE = sip;
		}
		map<String, SIP__c> map_sipId_sipTEST = new map<String, SIP__c>{sipFE.Id => sipFE};
		ClsSIPUitl.reportBatchStatus(list_exceptions, set_successIds, isSubmit);
		
		ClsSIPUitl.sharingToParticipant(map_sipId_map_userIds_access1);
		ClsSIPUitl.createSharingToParticipant(map_sipId_map_userIds_access, map_sipId_sipTEST);
		ClsSIPUitl.deleteSharingToParticipant(new set<Id>{sipFE.Id});
		ClsSIPUitl.createSharingToParticipant(map_sipId_map_userIds_access, map_sipId_sipTEST);
		ClsSIPUitl.removeSIPSharing(map_sipId_map_userIds_access, new set<String>{user.Id});
		ClsSIPUitl.buildSharingMap(new map<String, map<String, String>>(), sipFE,'Read', user.Id);
		list<ClsSIPUitl.ReportMap> list_map = new list<ClsSIPUitl.ReportMap>();
		ClsSIPUitl.buildReportMap(list_map, sipMapping, new set<String>(), sipFE);
		ClsSIPUitl.generateReportLinks(sipFE, list_map);
    	Test.stopTest();
    }
    static testMethod void fetchDataFromReportAsyn_UnitTest() {

    	addCustomSetting();
    	Test.startTest();
    	list<User> list_user = new list<User>();
		User user = new User();
		user=ClsTestHelp.createTestUsers();
		user.Te_Network_Id__c = 'testUser';
		user.username = 'test2081.te@test991.com';
		list_user.add(user);
		
		User user2 = new User();
		user2=ClsTestHelp.createTestUsers();
		user2.Te_Network_Id__c = 'testUser2';
		user2.username = 'test2082.te@test991.com';
		user2.FirstName ='First1';
        user2.LastName = 'Tester2';
        user2.Alias = 'mtst2';
        user2.CommunityNickname = user2.Alias;
		list_user.add(user2);
		insert list_user;
		Sales_Hierarchy__c salesHierarchyAM3 = new Sales_Hierarchy__c(Hierarchy_Type__c  = 'Account Manager Hierarchy (FE)' ,Level_7_Assigned_User_Network_Ids__c='testUser;testUser2',Level_7_Territory_Code__c = 'testFE');
  		
		insert salesHierarchyAM3;
		
  		Product_Hierarchy__c ph = new Product_Hierarchy__c();
  		ph.Hierarchy_Level_Type__c = 'CBC1';
  		ph.Description__c = 'Industrial';
  		ph.Name = 'T01';
  		ph.Regional_PM_EU__c = user.Id;
  		insert ph;
		String recordTypeFE;
		
		for (RecordType recordType : [select Id, Name, DeveloperName from RecordType where SobjectType = 'SIP__c' and IsActive = true and DeveloperName = 'FE_Plan']) {
			if(recordType.DeveloperName == 'FE_Plan') {				
				recordTypeFE = recordType.Id;
			}
		}
		SIP_master__c sipMaster = new SIP_master__c();
		sipMaster.Name = 'Test Master';
		insert sipMaster;				
		SIP_Mapping__c sipMapping = new SIP_Mapping__c();		
		sipMapping.Report_Field_1__c = 'T!0_1';
		sipMapping.Report_ID_1__c = '00OE0000002QYDq';
		sipMapping.Report_Parameters_1__c = 'AM_Codes__c,2';
		sipMapping.Target_Field_1__c = 'Prev_Year_YTD_POS__c';
		sipMapping.Target_Field_Name_1__c = 'Revenue Base Line';
		insert sipMapping;
		list<SIP__c> list_sip2Insert = new list<SIP__c>();
		SIP__c sipFE = new SIP__c();
		sipFE.Plan_Participant__c = user.Id;
		sipFE.RecordTypeId = recordTypeFE;
		sipFE.Plan_Year__c = '2013';
		sipFE.Name = 'test FE';
		sipFE.SIP_master_record__c = sipMaster.Id;
		sipFE.Prev_Year_YTD_Direct_billings__c  = 100;
		sipFE.Profit_Center_Codes__c = 'A&C';
		sipFE.SIP_Mapping__c = sipMapping.Id;
		sipFE.Plan_Participant__c = user.Id;
		sipFE.SIP_Report_Instance__c = 'T!0_1,Prev_Year_YTD_POS__c,xxxxxx,xxxxx;';
		list_sip2Insert.add(sipFE);
		SIP__c sipFE2 = new SIP__c();
		sipFE2.Plan_Participant__c = user.Id;
		sipFE2.RecordTypeId = recordTypeFE;
		sipFE2.Plan_Year__c = '2013';
		sipFE2.Name = 'test FE';
		sipFE2.SIP_master_record__c = sipMaster.Id;
		sipFE2.Prev_Year_YTD_Direct_billings__c  = 100;
		sipFE2.Profit_Center_Codes__c = 'A&C';
		sipFE2.SIP_Mapping__c = sipMapping.Id;
		sipFE2.Plan_Participant__c = user.Id;
		list_sip2Insert.add(sipFE2);
		insert list_sip2Insert;
		

		sipFE = [Select GPLs__c, AM_codes__c, RecordType.DeveloperName, Approver__c, Business_Driver_1__c, Business_Driver_1_Achieved__c, Business_Driver_1_Weighting__c, Business_Driver_1_details__c, Business_Driver_2__c, Business_Driver_2_Achieved__c, Business_Driver_2_Weighting__c, Business_Driver_2_details__c, Business_Driver_3__c, Business_Driver_3_Achieved__c, Business_Driver_3_Weighting__c, Business_Driver_3_details__c, Business_Driver_4__c, Business_Driver_4_Achieved__c, Business_Driver_4_Weighting__c, Business_Driver_4_details__c, Conversion_result__c, CreatedById, CreatedDate, CurrencyIsoCode, Current_Fiscal_Year_Direct__c, Current_Fiscal_Year_Indirect__c, IsDeleted, Exceptional_Perf_Conversion_Target_Dolla__c, Exceptional_Perf_Conversion_Target__c, Exceptional_Perf_Growth_Target_Dollar__c, Exceptional_Perf_Growth_Reve__c, FE_codes__c, GAM_codes__c, Industrial_Performance_Weighting__c, LastModifiedById, LastModifiedDate, Level_1_Conversion_Target_Dollar__c, Level_1_Conversion_target__c, Level_1_Growth_Target_Dollar__c, Level_1_Growth_Target__c, Level_1_Pipeline_Target_Dollar__c, Level_1_Pipeline_Target__c, Level_2_Conversion_Target_Dollar__c, Level_2_Conversion_Target__c, Level_2_Growth_Target_Dollar__c, Level_2_Growth_Target__c, Level_2_Pipeline_Target_Dollar__c, Level_2_Pipeline_Target__c, Level_3_Conversion_Target_Dollar__c, Level_3_Conversion_Target__c, Level_3_Growth_Target_Dollar__c, Level_3_Growth_Target__c, Level_3_Pipeline_Target_Dollar__c, Level_3_Pipeline_Target__c, Load_Status_Direct_Billings__c, Load_Status_Monthly_Direct__c, Load_Status_POS__c, Load_Status_Record_Indirect__c, OwnerId, Participants_Manager__c, Participants_TE_Network_ID__c, Pipeline_Result__c, Plan_Comments__c, Plan_Participant__c, Plan_Year__c, Current_Year_Direct_Bill_YTD__c, Current_Year_Direct_Billings_Run_Rate__c, Current_Year_POS_Bill_YTD__c, Current_Year_POS_Run_Rate__c, Prev_Year_1__c, Prev_Year_1_POS_Result__c, Prev_Year_1_Total_Result__c, Prev_Year_Conversion_YTD_Result_Dollar__c, Prev_Year_Conversion_YTD_Result__c, Prev_Year_Dir_Bill_Run_Rate_Result__c, Prev_Year_Growth__c, Prev_Year_POS_Run_Rate_Result__c, Prev_Year_Pipeline_YTD_Result_Dollar__c, Prev_Year_Pipeline_YTD_Result__c, Total_Revenue_Baseline__c, Prev_Year_YTD_Direct_billings__c, Prev_Year_YTD_POS__c, Profit_Center_Codes__c, ConnectionReceivedId, Id, RecordTypeId, Region__c, Name, ConnectionSentId, SystemModstamp from SIP__c where Id =: sipFE.Id];
		map<String, SIP__c> map_sipId_sip = new map<String, sip__c>{sipFE.Id => sipFE, sipFE2.Id => sipFE2}; 
		map<String, ClsSIPUitl.SIPCustomExcMSG> map_sipId_exception = new map<String, ClsSIPUitl.SIPCustomExcMSG>();
		map<String, list<ClsSIPUitl.ReportMap>> map_sipMappingId_list_reportMap = new map<String, list<ClsSIPUitl.ReportMap>>{sipMapping.Id => new list<ClsSIPUitl.ReportMap>()};
    	Test.setMock(HttpCalloutMock.class, new ClsTestWSMockUtil.ReportResultMockHttpResponseGenerator());
		ClsSIPUitl.fetchDataFromReportAsyn(map_sipId_sip, map_sipId_exception, 'xxxx', new set<String>{'AM_Codes__c', 'Prev_Year_YTD_POS__c'});
		ClsSIPUitl.removeSettingBeforeBatchRun();
		ClsSIPUitl.isKillFetchJob();
        //create a fake result
        ClsSIPUitl.ReportResultAttribute att = new ClsSIPUitl.ReportResultAttribute();
        att.id = 'xxxxxId';
        att.status = 'xxxxxId';
        att.ownerId = 'xxxxxownerId';
        att.completionDate = system.now();
        att.requestDate = system.now().addHours(-6);
        att.type = 'type';
        att.reportId = 'xxxxxreportId';
        att.reportName = 'xxxxxreportName';
        ClsSIPUitl.ResultFactAggregate fact1 = new ClsSIPUitl.ResultFactAggregate();
        fact1.label = '$16,000.01';
        fact1.value = 16000.010000;
        
        ClsSIPUitl.ResultFactValue factValue = new ClsSIPUitl.ResultFactValue();
        factValue.aggregates = new list<ClsSIPUitl.ResultFactAggregate>{fact1};
        factValue.rows = new list<ClsSIPUitl.ResultFactAggregate>{fact1};
        
        
        
        ClsSIPUitl.SIPReportResult result = new ClsSIPUitl.SIPReportResult();
        result.hasDetailRows = true;
        result.attributes = att;
        result.allData = true;
        result.factMap = new map<String, ClsSIPUitl.ResultFactValue>{'T!0_1' => factValue};
        result.attributes = att;
		ClsSIPUitl.parseReportJson(Json.serialize(result), 'T!0_1');
		Test.stopTest();
    }
}