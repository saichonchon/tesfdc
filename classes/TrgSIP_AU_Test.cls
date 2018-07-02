/**
*  This test class used to test class ExtRecalculateBudget.
*
@author Lili Zhao
@created 2013-09-16
@version 1.0
@since 27.0
*
@changelog
* coverage 77% 
* 
* 
2013-09-16 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest 
private class TrgSIP_AU_Test {

    static testMethod void myUnitTest() {
    	test.startTest(); 
    	User user = new User();
		user=ClsTestHelp.createTestUsers();
		user.Te_Network_Id__c = 'testUser';
		insert user;
		
		String recordTypeAM;
		String recordTypeFE;
		String recordTypeGAM;
		String recordTypeMM;
		
		for (RecordType recordType : [select Id, Name, DeveloperName from RecordType where SobjectType = 'SIP__c' and IsActive = true and (DeveloperName = 'AM_plan' or DeveloperName = 'FE_Plan' or DeveloperName = 'GAM_plan' or DeveloperName = 'Sales_Manager_Plan')]) {
			if(recordType.DeveloperName == 'AM_plan'){
				recordTypeAM = recordType.Id;				
			} else if(recordType.DeveloperName == 'FE_Plan') {				
				recordTypeFE = recordType.Id;
			}else if (recordType.DeveloperName == 'GAM_plan') {				
				recordTypeGAM = recordType.Id;
			}else {			
				recordTypeMM = recordType.Id;
			}
		}
		
		SIP_master__c sipMaster = new SIP_master__c();
		sipMaster.Name = 'Test Master';
		insert sipMaster;
		
    	SIP__c sipAM = new SIP__c();
		sipAM.Plan_Participant__c = user.Id;
		sipAM.RecordTypeId = recordTypeAM;
		sipAM.Plan_Year__c = '2013';
		sipAM.Name = 'test AM';		
		sipAM.SIP_master_record__c = sipMaster.Id;		
		insert sipAM;
		sipAM = [Select AM_codes__c, Approver__c, Business_Driver_1__c, Business_Driver_1_Achieved__c, Business_Driver_1_Weighting__c, Business_Driver_1_details__c, Business_Driver_2__c, Business_Driver_2_Achieved__c, Business_Driver_2_Weighting__c, Business_Driver_2_details__c, Business_Driver_3__c, Business_Driver_3_Achieved__c, Business_Driver_3_Weighting__c, Business_Driver_3_details__c, Business_Driver_4__c, Business_Driver_4_Achieved__c, Business_Driver_4_Weighting__c, Business_Driver_4_details__c, Conversion_result__c, CreatedById, CreatedDate, CurrencyIsoCode, Current_Fiscal_Year_Direct__c, Current_Fiscal_Year_Indirect__c, IsDeleted, Exceptional_Perf_Conversion_Target_Dolla__c, Exceptional_Perf_Conversion_Target__c, Exceptional_Perf_Growth_Target_Dollar__c, Exceptional_Perf_Growth_Reve__c, FE_codes__c, GAM_codes__c, Industrial_Performance_Weighting__c, LastModifiedById, LastModifiedDate, Level_1_Conversion_Target_Dollar__c, Level_1_Conversion_target__c, Level_1_Growth_Target_Dollar__c, Level_1_Growth_Target__c, Level_1_Pipeline_Target_Dollar__c, Level_1_Pipeline_Target__c, Level_2_Conversion_Target_Dollar__c, Level_2_Conversion_Target__c, Level_2_Growth_Target_Dollar__c, Level_2_Growth_Target__c, Level_2_Pipeline_Target_Dollar__c, Level_2_Pipeline_Target__c, Level_3_Conversion_Target_Dollar__c, Level_3_Conversion_Target__c, Level_3_Growth_Target_Dollar__c, Level_3_Growth_Target__c, Level_3_Pipeline_Target_Dollar__c, Level_3_Pipeline_Target__c, Load_Status_Direct_Billings__c, Load_Status_Monthly_Direct__c, Load_Status_POS__c, Load_Status_Record_Indirect__c, OwnerId, Participants_Manager__c, Participants_TE_Network_ID__c, Pipeline_Result__c, Plan_Comments__c, Plan_Participant__c, Plan_Year__c, Current_Year_Direct_Bill_YTD__c, Current_Year_Direct_Billings_Run_Rate__c, Current_Year_POS_Bill_YTD__c, Current_Year_POS_Run_Rate__c, Prev_Year_1__c, Prev_Year_1_POS_Result__c, Prev_Year_1_Total_Result__c, Prev_Year_Conversion_YTD_Result_Dollar__c, Prev_Year_Conversion_YTD_Result__c, Prev_Year_Dir_Bill_Run_Rate_Result__c, Prev_Year_Growth__c, Prev_Year_POS_Run_Rate_Result__c, Prev_Year_Pipeline_YTD_Result_Dollar__c, Prev_Year_Pipeline_YTD_Result__c, Total_Revenue_Baseline__c, Prev_Year_YTD_Direct_billings__c, Prev_Year_YTD_POS__c, Profit_Center_Codes__c, ConnectionReceivedId, Id, RecordTypeId, Region__c, Name, ConnectionSentId, SystemModstamp from SIP__c where Id =: sipAM.Id];
		sipAM.Approver__c = user.Id;
		update sipAM;
		
    	test.stopTest();       
    }
    static testMethod void myUnitTest2() {
    	test.startTest(); 
    	
		User u = new User();
        u.FirstName ='First2';
        u.LastName = 'Tester2';
        u.Alias = 'mtst2';
        u.Email = 'test@ItbTestcompany.com';   
        u.Username = u.Email;
        u.CommunityNickname = u.Alias;
        u.ProfileId = [select Id  from Profile where Name = 'System Administrator'][0].Id;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
		insert u;
		
		User user = new User();
		user=ClsTestHelp.createTestUsers();
		user.Te_Network_Id__c = 'testUser';
		insert user;
		
		String recordTypeAM;
		String recordTypeFE;
		String recordTypeGAM;
		String recordTypeMM;
		
		for (RecordType recordType : [select Id, Name, DeveloperName from RecordType where SobjectType = 'SIP__c' and IsActive = true and (DeveloperName = 'AM_plan' or DeveloperName = 'FE_Plan' or DeveloperName = 'GAM_plan' or DeveloperName = 'Sales_Manager_Plan')]) {
			if(recordType.DeveloperName == 'AM_plan'){
				recordTypeAM = recordType.Id;				
			} else if(recordType.DeveloperName == 'FE_Plan') {				
				recordTypeFE = recordType.Id;
			}else if (recordType.DeveloperName == 'GAM_plan') {				
				recordTypeGAM = recordType.Id;
			}else {			
				recordTypeMM = recordType.Id;
			}
		}
		
		SIP_master__c sipMaster = new SIP_master__c();
		sipMaster.Name = 'Test Master';
		insert sipMaster;
		
    	SIP__c sipAM = new SIP__c();
		sipAM.Plan_Participant__c = user.Id;
		sipAM.RecordTypeId = recordTypeAM;
		sipAM.Plan_Year__c = '2013';
		sipAM.Name = 'test AM';
		sipAM.Approver__c = u.Id;
		sipAM.SIP_master_record__c = sipMaster.Id;
		
		insert sipAM;
		sipAM = [Select AM_codes__c, Approver__c, Business_Driver_1__c, Business_Driver_1_Achieved__c, Business_Driver_1_Weighting__c, Business_Driver_1_details__c, Business_Driver_2__c, Business_Driver_2_Achieved__c, Business_Driver_2_Weighting__c, Business_Driver_2_details__c, Business_Driver_3__c, Business_Driver_3_Achieved__c, Business_Driver_3_Weighting__c, Business_Driver_3_details__c, Business_Driver_4__c, Business_Driver_4_Achieved__c, Business_Driver_4_Weighting__c, Business_Driver_4_details__c, Conversion_result__c, CreatedById, CreatedDate, CurrencyIsoCode, Current_Fiscal_Year_Direct__c, Current_Fiscal_Year_Indirect__c, IsDeleted, Exceptional_Perf_Conversion_Target_Dolla__c, Exceptional_Perf_Conversion_Target__c, Exceptional_Perf_Growth_Target_Dollar__c, Exceptional_Perf_Growth_Reve__c, FE_codes__c, GAM_codes__c, Industrial_Performance_Weighting__c, LastModifiedById, LastModifiedDate, Level_1_Conversion_Target_Dollar__c, Level_1_Conversion_target__c, Level_1_Growth_Target_Dollar__c, Level_1_Growth_Target__c, Level_1_Pipeline_Target_Dollar__c, Level_1_Pipeline_Target__c, Level_2_Conversion_Target_Dollar__c, Level_2_Conversion_Target__c, Level_2_Growth_Target_Dollar__c, Level_2_Growth_Target__c, Level_2_Pipeline_Target_Dollar__c, Level_2_Pipeline_Target__c, Level_3_Conversion_Target_Dollar__c, Level_3_Conversion_Target__c, Level_3_Growth_Target_Dollar__c, Level_3_Growth_Target__c, Level_3_Pipeline_Target_Dollar__c, Level_3_Pipeline_Target__c, Load_Status_Direct_Billings__c, Load_Status_Monthly_Direct__c, Load_Status_POS__c, Load_Status_Record_Indirect__c, OwnerId, Participants_Manager__c, Participants_TE_Network_ID__c, Pipeline_Result__c, Plan_Comments__c, Plan_Participant__c, Plan_Year__c, Current_Year_Direct_Bill_YTD__c, Current_Year_Direct_Billings_Run_Rate__c, Current_Year_POS_Bill_YTD__c, Current_Year_POS_Run_Rate__c, Prev_Year_1__c, Prev_Year_1_POS_Result__c, Prev_Year_1_Total_Result__c, Prev_Year_Conversion_YTD_Result_Dollar__c, Prev_Year_Conversion_YTD_Result__c, Prev_Year_Dir_Bill_Run_Rate_Result__c, Prev_Year_Growth__c, Prev_Year_POS_Run_Rate_Result__c, Prev_Year_Pipeline_YTD_Result_Dollar__c, Prev_Year_Pipeline_YTD_Result__c, Total_Revenue_Baseline__c, Prev_Year_YTD_Direct_billings__c, Prev_Year_YTD_POS__c, Profit_Center_Codes__c, ConnectionReceivedId, Id, RecordTypeId, Region__c, Name, ConnectionSentId, SystemModstamp from SIP__c where Id =: sipAM.Id];
		sipAM.Approver__c = user.Id;
		sipAM.Plan_Participant__c = u.Id;
		sipAm.Status__c = 'Completed for Results';
		update sipAM;
    	test.stopTest();
        
    }
        
	static testMethod void myUnitTest3() {
    	test.startTest(); 
    	
    	User user = new User();
		user=ClsTestHelp.createTestUsers();
		user.Te_Network_Id__c = 'testUser';
		insert user;
    	
		User u = new User();
        u.FirstName ='First2';
        u.LastName = 'Tester2';
        u.Alias = 'mtst2';
        u.Email = 'test@ItbTestcompany.com';   
        u.Username = u.Email;
        u.CommunityNickname = u.Alias;
        u.ProfileId = [select Id  from Profile where Name = 'System Administrator'][0].Id;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
		insert u;
		
		String recordTypeAM;
		String recordTypeFE;
		String recordTypeGAM;
		String recordTypeMM;
		
		for (RecordType recordType : [select Id, Name, DeveloperName from RecordType where SobjectType = 'SIP__c' and IsActive = true and (DeveloperName = 'AM_plan' or DeveloperName = 'FE_Plan' or DeveloperName = 'GAM_plan' or DeveloperName = 'Sales_Manager_Plan')]) {
			if(recordType.DeveloperName == 'AM_plan'){
				recordTypeAM = recordType.Id;				
			} else if(recordType.DeveloperName == 'FE_Plan') {				
				recordTypeFE = recordType.Id;
			}else if (recordType.DeveloperName == 'GAM_plan') {				
				recordTypeGAM = recordType.Id;
			}else {			
				recordTypeMM = recordType.Id;
			}
		}
		
		SIP_master__c sipMaster = new SIP_master__c();
		sipMaster.Name = 'Test Master';
		insert sipMaster;
		
    	SIP__c sipAM = new SIP__c();
		sipAM.Plan_Participant__c = user.Id;
		sipAM.RecordTypeId = recordTypeAM;
		sipAM.Plan_Year__c = '2013';
		sipAM.Name = 'test AM';
		sipAM.Approver__c = u.Id;
		sipAM.SIP_master_record__c = sipMaster.Id;
		
		insert sipAM;
		sipAM = [Select AM_codes__c, Approver__c, Business_Driver_1__c, Business_Driver_1_Achieved__c, Business_Driver_1_Weighting__c, Business_Driver_1_details__c, Business_Driver_2__c, Business_Driver_2_Achieved__c, Business_Driver_2_Weighting__c, Business_Driver_2_details__c, Business_Driver_3__c, Business_Driver_3_Achieved__c, Business_Driver_3_Weighting__c, Business_Driver_3_details__c, Business_Driver_4__c, Business_Driver_4_Achieved__c, Business_Driver_4_Weighting__c, Business_Driver_4_details__c, Conversion_result__c, CreatedById, CreatedDate, CurrencyIsoCode, Current_Fiscal_Year_Direct__c, Current_Fiscal_Year_Indirect__c, IsDeleted, Exceptional_Perf_Conversion_Target_Dolla__c, Exceptional_Perf_Conversion_Target__c, Exceptional_Perf_Growth_Target_Dollar__c, Exceptional_Perf_Growth_Reve__c, FE_codes__c, GAM_codes__c, Industrial_Performance_Weighting__c, LastModifiedById, LastModifiedDate, Level_1_Conversion_Target_Dollar__c, Level_1_Conversion_target__c, Level_1_Growth_Target_Dollar__c, Level_1_Growth_Target__c, Level_1_Pipeline_Target_Dollar__c, Level_1_Pipeline_Target__c, Level_2_Conversion_Target_Dollar__c, Level_2_Conversion_Target__c, Level_2_Growth_Target_Dollar__c, Level_2_Growth_Target__c, Level_2_Pipeline_Target_Dollar__c, Level_2_Pipeline_Target__c, Level_3_Conversion_Target_Dollar__c, Level_3_Conversion_Target__c, Level_3_Growth_Target_Dollar__c, Level_3_Growth_Target__c, Level_3_Pipeline_Target_Dollar__c, Level_3_Pipeline_Target__c, Load_Status_Direct_Billings__c, Load_Status_Monthly_Direct__c, Load_Status_POS__c, Load_Status_Record_Indirect__c, OwnerId, Participants_Manager__c, Participants_TE_Network_ID__c, Pipeline_Result__c, Plan_Comments__c, Plan_Participant__c, Plan_Year__c, Current_Year_Direct_Bill_YTD__c, Current_Year_Direct_Billings_Run_Rate__c, Current_Year_POS_Bill_YTD__c, Current_Year_POS_Run_Rate__c, Prev_Year_1__c, Prev_Year_1_POS_Result__c, Prev_Year_1_Total_Result__c, Prev_Year_Conversion_YTD_Result_Dollar__c, Prev_Year_Conversion_YTD_Result__c, Prev_Year_Dir_Bill_Run_Rate_Result__c, Prev_Year_Growth__c, Prev_Year_POS_Run_Rate_Result__c, Prev_Year_Pipeline_YTD_Result_Dollar__c, Prev_Year_Pipeline_YTD_Result__c, Total_Revenue_Baseline__c, Prev_Year_YTD_Direct_billings__c, Prev_Year_YTD_POS__c, Profit_Center_Codes__c, ConnectionReceivedId, Id, RecordTypeId, Region__c, Name, ConnectionSentId, SystemModstamp from SIP__c where Id =: sipAM.Id];
		sipAM.Approver__c = user.Id;
		sipAM.Plan_Participant__c = user.Id;
		update sipAM;
    	test.stopTest();
        
    }
    static testMethod void myUnitTest4() {
    	test.startTest(); 
    	
    	User user = new User();
		user=ClsTestHelp.createTestUsers();
		user.Te_Network_Id__c = 'testUser';
		insert user;
    	
		User u = new User();
        u.FirstName ='First2';
        u.LastName = 'Tester2';
        u.Alias = 'mtst2';
        u.Email = 'test@ItbTestcompany.com';   
        u.Username = u.Email;
        u.CommunityNickname = u.Alias;
        u.ProfileId = [select Id  from Profile where Name = 'System Administrator'][0].Id;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.ManagerId = user.Id;
		insert u;
		
		String recordTypeAM;
		String recordTypeFE;
		String recordTypeGAM;
		String recordTypeMM;
		
		for (RecordType recordType : [select Id, Name, DeveloperName from RecordType where SobjectType = 'SIP__c' and IsActive = true and (DeveloperName = 'AM_plan' or DeveloperName = 'FE_Plan' or DeveloperName = 'GAM_plan' or DeveloperName = 'Sales_Manager_Plan')]) {
			if(recordType.DeveloperName == 'AM_plan'){
				recordTypeAM = recordType.Id;				
			} else if(recordType.DeveloperName == 'FE_Plan') {				
				recordTypeFE = recordType.Id;
			}else if (recordType.DeveloperName == 'GAM_plan') {				
				recordTypeGAM = recordType.Id;
			}else {			
				recordTypeMM = recordType.Id;
			}
		}
		
		SIP_master__c sipMaster = new SIP_master__c();
		sipMaster.Name = 'Test Master';
		insert sipMaster;
		
    	SIP__c sipAM = new SIP__c();
		sipAM.Plan_Participant__c = user.Id;
		sipAM.RecordTypeId = recordTypeAM;
		sipAM.Plan_Year__c = '2013';
		sipAM.Name = 'test AM';
		sipAM.Approver__c = user.Id;
		sipAM.SIP_master_record__c = sipMaster.Id;
		
		insert sipAM;
		sipAM = [Select AM_codes__c, Approver__c, Business_Driver_1__c, Business_Driver_1_Achieved__c, Business_Driver_1_Weighting__c, Business_Driver_1_details__c, Business_Driver_2__c, Business_Driver_2_Achieved__c, Business_Driver_2_Weighting__c, Business_Driver_2_details__c, Business_Driver_3__c, Business_Driver_3_Achieved__c, Business_Driver_3_Weighting__c, Business_Driver_3_details__c, Business_Driver_4__c, Business_Driver_4_Achieved__c, Business_Driver_4_Weighting__c, Business_Driver_4_details__c, Conversion_result__c, CreatedById, CreatedDate, CurrencyIsoCode, Current_Fiscal_Year_Direct__c, Current_Fiscal_Year_Indirect__c, IsDeleted, Exceptional_Perf_Conversion_Target_Dolla__c, Exceptional_Perf_Conversion_Target__c, Exceptional_Perf_Growth_Target_Dollar__c, Exceptional_Perf_Growth_Reve__c, FE_codes__c, GAM_codes__c, Industrial_Performance_Weighting__c, LastModifiedById, LastModifiedDate, Level_1_Conversion_Target_Dollar__c, Level_1_Conversion_target__c, Level_1_Growth_Target_Dollar__c, Level_1_Growth_Target__c, Level_1_Pipeline_Target_Dollar__c, Level_1_Pipeline_Target__c, Level_2_Conversion_Target_Dollar__c, Level_2_Conversion_Target__c, Level_2_Growth_Target_Dollar__c, Level_2_Growth_Target__c, Level_2_Pipeline_Target_Dollar__c, Level_2_Pipeline_Target__c, Level_3_Conversion_Target_Dollar__c, Level_3_Conversion_Target__c, Level_3_Growth_Target_Dollar__c, Level_3_Growth_Target__c, Level_3_Pipeline_Target_Dollar__c, Level_3_Pipeline_Target__c, Load_Status_Direct_Billings__c, Load_Status_Monthly_Direct__c, Load_Status_POS__c, Load_Status_Record_Indirect__c, OwnerId, Participants_Manager__c, Participants_TE_Network_ID__c, Pipeline_Result__c, Plan_Comments__c, Plan_Participant__c, Plan_Year__c, Current_Year_Direct_Bill_YTD__c, Current_Year_Direct_Billings_Run_Rate__c, Current_Year_POS_Bill_YTD__c, Current_Year_POS_Run_Rate__c, Prev_Year_1__c, Prev_Year_1_POS_Result__c, Prev_Year_1_Total_Result__c, Prev_Year_Conversion_YTD_Result_Dollar__c, Prev_Year_Conversion_YTD_Result__c, Prev_Year_Dir_Bill_Run_Rate_Result__c, Prev_Year_Growth__c, Prev_Year_POS_Run_Rate_Result__c, Prev_Year_Pipeline_YTD_Result_Dollar__c, Prev_Year_Pipeline_YTD_Result__c, Total_Revenue_Baseline__c, Prev_Year_YTD_Direct_billings__c, Prev_Year_YTD_POS__c, Profit_Center_Codes__c, ConnectionReceivedId, Id, RecordTypeId, Region__c, Name, ConnectionSentId, SystemModstamp from SIP__c where Id =: sipAM.Id];
		sipAM.Approver__c = null;
		sipAM.Plan_Participant__c = user.Id;
		update sipAM;
    	test.stopTest();
        
    }
     static testMethod void myUnitTest5() {
    	test.startTest(); 
    	
    	User user = new User();
		user=ClsTestHelp.createTestUsers();
		user.Te_Network_Id__c = 'testUser';
		insert user;
    	
		User u = new User();
        u.FirstName ='First2';
        u.LastName = 'Tester2';
        u.Alias = 'mtst2';
        u.Email = 'test@ItbTestcompany.com';   
        u.Username = u.Email;
        u.CommunityNickname = u.Alias;
        u.ProfileId = [select Id  from Profile where Name = 'System Administrator'][0].Id;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.ManagerId = user.Id;
		insert u;
		
		String recordTypeAM;
		String recordTypeFE;
		String recordTypeGAM;
		String recordTypeMM;
		
		for (RecordType recordType : [select Id, Name, DeveloperName from RecordType where SobjectType = 'SIP__c' and IsActive = true and (DeveloperName = 'AM_plan' or DeveloperName = 'FE_Plan' or DeveloperName = 'GAM_plan' or DeveloperName = 'Sales_Manager_Plan')]) {
			if(recordType.DeveloperName == 'AM_plan'){
				recordTypeAM = recordType.Id;				
			} else if(recordType.DeveloperName == 'FE_Plan') {				
				recordTypeFE = recordType.Id;
			}else if (recordType.DeveloperName == 'GAM_plan') {				
				recordTypeGAM = recordType.Id;
			}else {			
				recordTypeMM = recordType.Id;
			}
		}
		
		SIP_master__c sipMaster = new SIP_master__c();
		sipMaster.Name = 'Test Master';
		insert sipMaster;
		
    	SIP__c sipAM = new SIP__c();
		sipAM.Plan_Participant__c = user.Id;
		sipAM.RecordTypeId = recordTypeAM;
		sipAM.Plan_Year__c = '2013';
		sipAM.Name = 'test AM';
		sipAM.Approver__c = u.Id;
		sipAM.SIP_master_record__c = sipMaster.Id;
		
		insert sipAM;
		sipAM = [Select AM_codes__c, Approver__c, Business_Driver_1__c, Business_Driver_1_Achieved__c, Business_Driver_1_Weighting__c, Business_Driver_1_details__c, Business_Driver_2__c, Business_Driver_2_Achieved__c, Business_Driver_2_Weighting__c, Business_Driver_2_details__c, Business_Driver_3__c, Business_Driver_3_Achieved__c, Business_Driver_3_Weighting__c, Business_Driver_3_details__c, Business_Driver_4__c, Business_Driver_4_Achieved__c, Business_Driver_4_Weighting__c, Business_Driver_4_details__c, Conversion_result__c, CreatedById, CreatedDate, CurrencyIsoCode, Current_Fiscal_Year_Direct__c, Current_Fiscal_Year_Indirect__c, IsDeleted, Exceptional_Perf_Conversion_Target_Dolla__c, Exceptional_Perf_Conversion_Target__c, Exceptional_Perf_Growth_Target_Dollar__c, Exceptional_Perf_Growth_Reve__c, FE_codes__c, GAM_codes__c, Industrial_Performance_Weighting__c, LastModifiedById, LastModifiedDate, Level_1_Conversion_Target_Dollar__c, Level_1_Conversion_target__c, Level_1_Growth_Target_Dollar__c, Level_1_Growth_Target__c, Level_1_Pipeline_Target_Dollar__c, Level_1_Pipeline_Target__c, Level_2_Conversion_Target_Dollar__c, Level_2_Conversion_Target__c, Level_2_Growth_Target_Dollar__c, Level_2_Growth_Target__c, Level_2_Pipeline_Target_Dollar__c, Level_2_Pipeline_Target__c, Level_3_Conversion_Target_Dollar__c, Level_3_Conversion_Target__c, Level_3_Growth_Target_Dollar__c, Level_3_Growth_Target__c, Level_3_Pipeline_Target_Dollar__c, Level_3_Pipeline_Target__c, Load_Status_Direct_Billings__c, Load_Status_Monthly_Direct__c, Load_Status_POS__c, Load_Status_Record_Indirect__c, OwnerId, Participants_Manager__c, Participants_TE_Network_ID__c, Pipeline_Result__c, Plan_Comments__c, Plan_Participant__c, Plan_Year__c, Current_Year_Direct_Bill_YTD__c, Current_Year_Direct_Billings_Run_Rate__c, Current_Year_POS_Bill_YTD__c, Current_Year_POS_Run_Rate__c, Prev_Year_1__c, Prev_Year_1_POS_Result__c, Prev_Year_1_Total_Result__c, Prev_Year_Conversion_YTD_Result_Dollar__c, Prev_Year_Conversion_YTD_Result__c, Prev_Year_Dir_Bill_Run_Rate_Result__c, Prev_Year_Growth__c, Prev_Year_POS_Run_Rate_Result__c, Prev_Year_Pipeline_YTD_Result_Dollar__c, Prev_Year_Pipeline_YTD_Result__c, Total_Revenue_Baseline__c, Prev_Year_YTD_Direct_billings__c, Prev_Year_YTD_POS__c, Profit_Center_Codes__c, ConnectionReceivedId, Id, RecordTypeId, Region__c, Name, ConnectionSentId, SystemModstamp from SIP__c where Id =: sipAM.Id];
		sipAM.Approver__c = null;
		sipAM.Plan_Participant__c = user.Id;
		update sipAM;
    	test.stopTest();
        
    }
    
    static testMethod void myUnitTest7() {
    	test.startTest(); 
    	
		User u = new User();
        u.FirstName ='test12345';
        u.LastName = 'testljgs';
        u.Alias = 'mfsreet2';
        u.Email = 'vhskf@vfsjgdvf.com';   
        u.Username = u.Email;
        u.CommunityNickname = u.Alias;
        u.ProfileId = [select Id  from Profile where Name = 'System Administrator'][0].Id;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.ManagerId = UserInfo.getUserId();
		insert u;
		
		User user = new User();
		user=ClsTestHelp.createTestUsers();
		user.Te_Network_Id__c = 'testUser';
		insert user;
		
		String recordTypeAM;
		String recordTypeFE;
		String recordTypeGAM;
		String recordTypeMM;
		
		for (RecordType recordType : [select Id, Name, DeveloperName from RecordType where SobjectType = 'SIP__c' and IsActive = true and (DeveloperName = 'AM_plan' or DeveloperName = 'FE_Plan' or DeveloperName = 'GAM_plan' or DeveloperName = 'Sales_Manager_Plan')]) {
			if(recordType.DeveloperName == 'AM_plan'){
				recordTypeAM = recordType.Id;				
			} else if(recordType.DeveloperName == 'FE_Plan') {				
				recordTypeFE = recordType.Id;
			}else if (recordType.DeveloperName == 'GAM_plan') {				
				recordTypeGAM = recordType.Id;
			}else {			
				recordTypeMM = recordType.Id;
			}
		}
		
		SIP_master__c sipMaster = new SIP_master__c();
		sipMaster.Name = 'Test Master';
		insert sipMaster;
		
    	SIP__c sipAM = new SIP__c();
		sipAM.Plan_Participant__c = user.Id;
		sipAM.RecordTypeId = recordTypeAM;
		sipAM.Plan_Year__c = '2013';
		sipAM.Name = 'test AM';
		sipAM.Approver__c = UserInfo.getUserId();
		sipAM.SIP_master_record__c = sipMaster.Id;
		
		insert sipAM;
		sipAM = [Select AM_codes__c, Approver__c, Business_Driver_1__c, Business_Driver_1_Achieved__c, Business_Driver_1_Weighting__c, Business_Driver_1_details__c, Business_Driver_2__c, Business_Driver_2_Achieved__c, Business_Driver_2_Weighting__c, Business_Driver_2_details__c, Business_Driver_3__c, Business_Driver_3_Achieved__c, Business_Driver_3_Weighting__c, Business_Driver_3_details__c, Business_Driver_4__c, Business_Driver_4_Achieved__c, Business_Driver_4_Weighting__c, Business_Driver_4_details__c, Conversion_result__c, CreatedById, CreatedDate, CurrencyIsoCode, Current_Fiscal_Year_Direct__c, Current_Fiscal_Year_Indirect__c, IsDeleted, Exceptional_Perf_Conversion_Target_Dolla__c, Exceptional_Perf_Conversion_Target__c, Exceptional_Perf_Growth_Target_Dollar__c, Exceptional_Perf_Growth_Reve__c, FE_codes__c, GAM_codes__c, Industrial_Performance_Weighting__c, LastModifiedById, LastModifiedDate, Level_1_Conversion_Target_Dollar__c, Level_1_Conversion_target__c, Level_1_Growth_Target_Dollar__c, Level_1_Growth_Target__c, Level_1_Pipeline_Target_Dollar__c, Level_1_Pipeline_Target__c, Level_2_Conversion_Target_Dollar__c, Level_2_Conversion_Target__c, Level_2_Growth_Target_Dollar__c, Level_2_Growth_Target__c, Level_2_Pipeline_Target_Dollar__c, Level_2_Pipeline_Target__c, Level_3_Conversion_Target_Dollar__c, Level_3_Conversion_Target__c, Level_3_Growth_Target_Dollar__c, Level_3_Growth_Target__c, Level_3_Pipeline_Target_Dollar__c, Level_3_Pipeline_Target__c, Load_Status_Direct_Billings__c, Load_Status_Monthly_Direct__c, Load_Status_POS__c, Load_Status_Record_Indirect__c, OwnerId, Participants_Manager__c, Participants_TE_Network_ID__c, Pipeline_Result__c, Plan_Comments__c, Plan_Participant__c, Plan_Year__c, Current_Year_Direct_Bill_YTD__c, Current_Year_Direct_Billings_Run_Rate__c, Current_Year_POS_Bill_YTD__c, Current_Year_POS_Run_Rate__c, Prev_Year_1__c, Prev_Year_1_POS_Result__c, Prev_Year_1_Total_Result__c, Prev_Year_Conversion_YTD_Result_Dollar__c, Prev_Year_Conversion_YTD_Result__c, Prev_Year_Dir_Bill_Run_Rate_Result__c, Prev_Year_Growth__c, Prev_Year_POS_Run_Rate_Result__c, Prev_Year_Pipeline_YTD_Result_Dollar__c, Prev_Year_Pipeline_YTD_Result__c, Total_Revenue_Baseline__c, Prev_Year_YTD_Direct_billings__c, Prev_Year_YTD_POS__c, Profit_Center_Codes__c, ConnectionReceivedId, Id, RecordTypeId, Region__c, Name, ConnectionSentId, SystemModstamp from SIP__c where Id =: sipAM.Id];
		sipAM.Approver__c = user.Id;
		sipAM.Plan_Participant__c = u.Id;
		update sipAM;
    	test.stopTest();
        
    }
    
    static testMethod void myUnitTest8() {
    	test.startTest(); 
    	
		User u = new User();
        u.FirstName ='dfgre';
        u.LastName = 'kjfsv';
        u.Alias = 'ashndvl';
        u.Email = 'fxdcjh@olksertg.com';   
        u.Username = u.Email;
        u.CommunityNickname = u.Alias;
        u.ProfileId = [select Id  from Profile where Name = 'System Administrator'][0].Id;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.ManagerId = UserInfo.getUserId();
		insert u;
		
		User user = new User();
		user=ClsTestHelp.createTestUsers();
		user.Te_Network_Id__c = 'testUser';
		insert user;
		
		String recordTypeAM;
		String recordTypeFE;
		String recordTypeGAM;
		String recordTypeMM;
		
		for (RecordType recordType : [select Id, Name, DeveloperName from RecordType where SobjectType = 'SIP__c' and IsActive = true and (DeveloperName = 'AM_plan' or DeveloperName = 'FE_Plan' or DeveloperName = 'GAM_plan' or DeveloperName = 'Sales_Manager_Plan')]) {
			if(recordType.DeveloperName == 'AM_plan'){
				recordTypeAM = recordType.Id;				
			} else if(recordType.DeveloperName == 'FE_Plan') {				
				recordTypeFE = recordType.Id;
			}else if (recordType.DeveloperName == 'GAM_plan') {				
				recordTypeGAM = recordType.Id;
			}else {			
				recordTypeMM = recordType.Id;
			}
		}
		
		SIP_master__c sipMaster = new SIP_master__c();
		sipMaster.Name = 'Test Master';
		insert sipMaster;
		
    	SIP__c sipAM = new SIP__c();
		sipAM.Plan_Participant__c = user.Id;
		sipAM.RecordTypeId = recordTypeAM;
		sipAM.Plan_Year__c = '2013';
		sipAM.Name = 'test AM';
		sipAM.Approver__c = UserInfo.getUserId();
		sipAM.SIP_master_record__c = sipMaster.Id;
		
		insert sipAM;
		sipAM = [Select AM_codes__c, Approver__c, Business_Driver_1__c, Business_Driver_1_Achieved__c, Business_Driver_1_Weighting__c, Business_Driver_1_details__c, Business_Driver_2__c, Business_Driver_2_Achieved__c, Business_Driver_2_Weighting__c, Business_Driver_2_details__c, Business_Driver_3__c, Business_Driver_3_Achieved__c, Business_Driver_3_Weighting__c, Business_Driver_3_details__c, Business_Driver_4__c, Business_Driver_4_Achieved__c, Business_Driver_4_Weighting__c, Business_Driver_4_details__c, Conversion_result__c, CreatedById, CreatedDate, CurrencyIsoCode, Current_Fiscal_Year_Direct__c, Current_Fiscal_Year_Indirect__c, IsDeleted, Exceptional_Perf_Conversion_Target_Dolla__c, Exceptional_Perf_Conversion_Target__c, Exceptional_Perf_Growth_Target_Dollar__c, Exceptional_Perf_Growth_Reve__c, FE_codes__c, GAM_codes__c, Industrial_Performance_Weighting__c, LastModifiedById, LastModifiedDate, Level_1_Conversion_Target_Dollar__c, Level_1_Conversion_target__c, Level_1_Growth_Target_Dollar__c, Level_1_Growth_Target__c, Level_1_Pipeline_Target_Dollar__c, Level_1_Pipeline_Target__c, Level_2_Conversion_Target_Dollar__c, Level_2_Conversion_Target__c, Level_2_Growth_Target_Dollar__c, Level_2_Growth_Target__c, Level_2_Pipeline_Target_Dollar__c, Level_2_Pipeline_Target__c, Level_3_Conversion_Target_Dollar__c, Level_3_Conversion_Target__c, Level_3_Growth_Target_Dollar__c, Level_3_Growth_Target__c, Level_3_Pipeline_Target_Dollar__c, Level_3_Pipeline_Target__c, Load_Status_Direct_Billings__c, Load_Status_Monthly_Direct__c, Load_Status_POS__c, Load_Status_Record_Indirect__c, OwnerId, Participants_Manager__c, Participants_TE_Network_ID__c, Pipeline_Result__c, Plan_Comments__c, Plan_Participant__c, Plan_Year__c, Current_Year_Direct_Bill_YTD__c, Current_Year_Direct_Billings_Run_Rate__c, Current_Year_POS_Bill_YTD__c, Current_Year_POS_Run_Rate__c, Prev_Year_1__c, Prev_Year_1_POS_Result__c, Prev_Year_1_Total_Result__c, Prev_Year_Conversion_YTD_Result_Dollar__c, Prev_Year_Conversion_YTD_Result__c, Prev_Year_Dir_Bill_Run_Rate_Result__c, Prev_Year_Growth__c, Prev_Year_POS_Run_Rate_Result__c, Prev_Year_Pipeline_YTD_Result_Dollar__c, Prev_Year_Pipeline_YTD_Result__c, Total_Revenue_Baseline__c, Prev_Year_YTD_Direct_billings__c, Prev_Year_YTD_POS__c, Profit_Center_Codes__c, ConnectionReceivedId, Id, RecordTypeId, Region__c, Name, ConnectionSentId, SystemModstamp from SIP__c where Id =: sipAM.Id];
		sipAM.Approver__c = null;
		sipAM.Plan_Participant__c = u.Id;
		update sipAM;
    	test.stopTest();        
    }
    
    static testMethod void myUnitTest6() {
    	test.startTest(); 

		User user = new User();
		user=ClsTestHelp.createTestUsers();
		user.Te_Network_Id__c = 'testUser';
		insert user;
		
		String recordTypeAM;
		String recordTypeFE;
		String recordTypeGAM;
		String recordTypeMM;
		
		for (RecordType recordType : [select Id, Name, DeveloperName from RecordType where SobjectType = 'SIP__c' and IsActive = true and (DeveloperName = 'AM_plan' or DeveloperName = 'FE_Plan' or DeveloperName = 'GAM_plan' or DeveloperName = 'Sales_Manager_Plan')]) {
			if(recordType.DeveloperName == 'AM_plan'){
				recordTypeAM = recordType.Id;				
			} else if(recordType.DeveloperName == 'FE_Plan') {				
				recordTypeFE = recordType.Id;
			}else if (recordType.DeveloperName == 'GAM_plan') {				
				recordTypeGAM = recordType.Id;
			}else {			
				recordTypeMM = recordType.Id;
			}
		}
		
		SIP_master__c sipMaster = new SIP_master__c();
		sipMaster.Name = 'Test Master';
		insert sipMaster;
		
    	SIP__c sipAM = new SIP__c();
		sipAM.Plan_Participant__c = user.Id;
		sipAM.RecordTypeId = recordTypeAM;
		sipAM.Plan_Year__c = '2013';
		sipAM.Name = 'test AM';
		sipAM.Approver__c = UserInfo.getUserId();
		sipAM.SIP_master_record__c = sipMaster.Id;
		
		insert sipAM;
		sipAM = [Select AM_codes__c, Approver__c, Business_Driver_1__c, Business_Driver_1_Achieved__c, Business_Driver_1_Weighting__c, Business_Driver_1_details__c, Business_Driver_2__c, Business_Driver_2_Achieved__c, Business_Driver_2_Weighting__c, Business_Driver_2_details__c, Business_Driver_3__c, Business_Driver_3_Achieved__c, Business_Driver_3_Weighting__c, Business_Driver_3_details__c, Business_Driver_4__c, Business_Driver_4_Achieved__c, Business_Driver_4_Weighting__c, Business_Driver_4_details__c, Conversion_result__c, CreatedById, CreatedDate, CurrencyIsoCode, Current_Fiscal_Year_Direct__c, Current_Fiscal_Year_Indirect__c, IsDeleted, Exceptional_Perf_Conversion_Target_Dolla__c, Exceptional_Perf_Conversion_Target__c, Exceptional_Perf_Growth_Target_Dollar__c, Exceptional_Perf_Growth_Reve__c, FE_codes__c, GAM_codes__c, Industrial_Performance_Weighting__c, LastModifiedById, LastModifiedDate, Level_1_Conversion_Target_Dollar__c, Level_1_Conversion_target__c, Level_1_Growth_Target_Dollar__c, Level_1_Growth_Target__c, Level_1_Pipeline_Target_Dollar__c, Level_1_Pipeline_Target__c, Level_2_Conversion_Target_Dollar__c, Level_2_Conversion_Target__c, Level_2_Growth_Target_Dollar__c, Level_2_Growth_Target__c, Level_2_Pipeline_Target_Dollar__c, Level_2_Pipeline_Target__c, Level_3_Conversion_Target_Dollar__c, Level_3_Conversion_Target__c, Level_3_Growth_Target_Dollar__c, Level_3_Growth_Target__c, Level_3_Pipeline_Target_Dollar__c, Level_3_Pipeline_Target__c, Load_Status_Direct_Billings__c, Load_Status_Monthly_Direct__c, Load_Status_POS__c, Load_Status_Record_Indirect__c, OwnerId, Participants_Manager__c, Participants_TE_Network_ID__c, Pipeline_Result__c, Plan_Comments__c, Plan_Participant__c, Plan_Year__c, Current_Year_Direct_Bill_YTD__c, Current_Year_Direct_Billings_Run_Rate__c, Current_Year_POS_Bill_YTD__c, Current_Year_POS_Run_Rate__c, Prev_Year_1__c, Prev_Year_1_POS_Result__c, Prev_Year_1_Total_Result__c, Prev_Year_Conversion_YTD_Result_Dollar__c, Prev_Year_Conversion_YTD_Result__c, Prev_Year_Dir_Bill_Run_Rate_Result__c, Prev_Year_Growth__c, Prev_Year_POS_Run_Rate_Result__c, Prev_Year_Pipeline_YTD_Result_Dollar__c, Prev_Year_Pipeline_YTD_Result__c, Total_Revenue_Baseline__c, Prev_Year_YTD_Direct_billings__c, Prev_Year_YTD_POS__c, Profit_Center_Codes__c, ConnectionReceivedId, Id, RecordTypeId, Region__c, Name, ConnectionSentId, SystemModstamp from SIP__c where Id =: sipAM.Id];
		sipAM.Approver__c = null;
		sipAM.Plan_Participant__c = null;
		sipAm.Status__c = 'Completed for Results';
		update sipAM;
    	test.stopTest();        
    }
    
    
}