/**
*  This test class used to test class ExtRecalculateBudget.
*
@author Lili Zhao
@created 2013-08-28
@version 1.0
@since 27.0
*
@changelog
* coverage 100% 
* 
* 
2013-08-28 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest(seeAllData = true) 
private class TrgSIP_BI_Test {

    static testMethod void myUnitTest() {
        test.startTest(); 
        list<SIP__c> sips= new list<SIP__c>();    
        User user = new User();
        user=ClsTestHelp.createTestUsers();
        user.Te_Network_Id__c = 'testUser';
        insert user;
        User user1 = new User();
        user1.FirstName ='First1';
        user1.LastName = 'Tester1';
        user1.Alias = 'mtst1';
        user1.Email = 'mtester1@ItbTestcompany.com';
        user1.Username = user1.Email;
        user1.CommunityNickname = user1.Alias;
        user1.ProfileId = [select Id 
                        from Profile
                        where Name = 'System Administrator'][0].Id;
        user1.TimeZoneSidKey = 'America/Chicago';
        user1.LocaleSidKey = 'en_US';
        user1.EmailEncodingKey = 'UTF-8';
        user1.LanguageLocaleKey = 'en_US';
        user1.Te_Network_Id__c = 'testUser1';
        insert user1;
        
        Sales_Hierarchy__c salesHierarchyAM1 = new Sales_Hierarchy__c(Hierarchy_Type__c  = 'Sales Hierarchy (AM)' ,Level_7_Assigned_User_Network_Ids__c='testUser',Level_7_Territory_Code__c = 'testAM1');
        Sales_Hierarchy__c salesHierarchyAM2 = new Sales_Hierarchy__c(Hierarchy_Type__c  = 'Sales Hierarchy (AM)' ,Level_7_Assigned_User_Network_Ids__c='testUser;testUser1',Level_7_Territory_Code__c = 'testAM2');
        Sales_Hierarchy__c salesHierarchyAM3 = new Sales_Hierarchy__c(Hierarchy_Type__c  = 'Account Manager Hierarchy (FE)' ,Level_7_Assigned_User_Network_Ids__c='testUser;testUser2',Level_7_Territory_Code__c = 'testFE');
        insert salesHierarchyAM1;

        insert salesHierarchyAM2;

        insert salesHierarchyAM3;
        
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
        sipAM.Prev_Year_YTD_Direct_billings__c  = 100;
        sipAM.Application__c='Servo Drive; Servo Motor';
        insert sipAM;
        sipAM = [Select AM_codes__c, Approver__c, Business_Driver_1__c, Business_Driver_1_Achieved__c, Business_Driver_1_Weighting__c, Business_Driver_1_details__c, Business_Driver_2__c, Business_Driver_2_Achieved__c, Business_Driver_2_Weighting__c, Business_Driver_2_details__c, Business_Driver_3__c, Business_Driver_3_Achieved__c, Business_Driver_3_Weighting__c, Business_Driver_3_details__c, Business_Driver_4__c, Business_Driver_4_Achieved__c, Business_Driver_4_Weighting__c, Business_Driver_4_details__c, Conversion_result__c, CreatedById, CreatedDate, CurrencyIsoCode, Current_Fiscal_Year_Direct__c, Current_Fiscal_Year_Indirect__c, IsDeleted, Exceptional_Perf_Conversion_Target_Dolla__c, Exceptional_Perf_Conversion_Target__c, Exceptional_Perf_Growth_Target_Dollar__c, Exceptional_Perf_Growth_Reve__c, FE_codes__c, GAM_codes__c, Industrial_Performance_Weighting__c, LastModifiedById, LastModifiedDate, Level_1_Conversion_Target_Dollar__c, Level_1_Conversion_target__c, Level_1_Growth_Target_Dollar__c, Level_1_Growth_Target__c, Level_1_Pipeline_Target_Dollar__c, Level_1_Pipeline_Target__c, Level_2_Conversion_Target_Dollar__c, Level_2_Conversion_Target__c, Level_2_Growth_Target_Dollar__c, Level_2_Growth_Target__c, Level_2_Pipeline_Target_Dollar__c, Level_2_Pipeline_Target__c, Level_3_Conversion_Target_Dollar__c, Level_3_Conversion_Target__c, Level_3_Growth_Target_Dollar__c, Level_3_Growth_Target__c, Level_3_Pipeline_Target_Dollar__c, Level_3_Pipeline_Target__c, Load_Status_Direct_Billings__c, Load_Status_Monthly_Direct__c, Load_Status_POS__c, Load_Status_Record_Indirect__c, OwnerId, Participants_Manager__c, Participants_TE_Network_ID__c, Pipeline_Result__c, Plan_Comments__c, Plan_Participant__c, Plan_Year__c, Current_Year_Direct_Bill_YTD__c, Current_Year_Direct_Billings_Run_Rate__c, Current_Year_POS_Bill_YTD__c, Current_Year_POS_Run_Rate__c, Prev_Year_1__c, Prev_Year_1_POS_Result__c, Prev_Year_1_Total_Result__c, Prev_Year_Conversion_YTD_Result_Dollar__c, Prev_Year_Conversion_YTD_Result__c, Prev_Year_Dir_Bill_Run_Rate_Result__c, Prev_Year_Growth__c, Prev_Year_POS_Run_Rate_Result__c, Prev_Year_Pipeline_YTD_Result_Dollar__c, Prev_Year_Pipeline_YTD_Result__c, Total_Revenue_Baseline__c, Prev_Year_YTD_Direct_billings__c, Prev_Year_YTD_POS__c, Profit_Center_Codes__c, ConnectionReceivedId, Id, RecordTypeId, Region__c, Name, ConnectionSentId, SystemModstamp from SIP__c where Id =: sipAM.Id];
        
        sipAm.Plan_Participant__c = user1.Id;
        update sipAM;
        System.assertEquals('testUser', sipAM.Participants_TE_Network_ID__c);
        sips.add(sipAM);
                
        SIP__c sipFE = new SIP__c();
        sipFE.Plan_Participant__c = user.Id;
        sipFE.RecordTypeId = recordTypeFE;
        sipFE.Plan_Year__c = '2013';
        sipFE.Name = 'test FE';
        sipFE.SIP_master_record__c = sipMaster.Id;
        sipFE.Prev_Year_YTD_Direct_billings__c  = 100;
        sipFE.Application__c='Machine Tools; MV Switchgear Control Cabinets; Outdoor Commercial & Industrial Lighting; Packing Machine; Plastic Molding Machine; PLC; Rail Traction; Robotics; Robotics and Production Line Integration; Safety Controllers; Semi-conductor Manufacturing Equipment; Servo Drive; Servo Motor; HVAC General Purpose Controllers';
        insert sipFE;
        sipFE = [Select AM_codes__c, Approver__c, Business_Driver_1__c, Business_Driver_1_Achieved__c, Business_Driver_1_Weighting__c, Business_Driver_1_details__c, Business_Driver_2__c, Business_Driver_2_Achieved__c, Business_Driver_2_Weighting__c, Business_Driver_2_details__c, Business_Driver_3__c, Business_Driver_3_Achieved__c, Business_Driver_3_Weighting__c, Business_Driver_3_details__c, Business_Driver_4__c, Business_Driver_4_Achieved__c, Business_Driver_4_Weighting__c, Business_Driver_4_details__c, Conversion_result__c, CreatedById, CreatedDate, CurrencyIsoCode, Current_Fiscal_Year_Direct__c, Current_Fiscal_Year_Indirect__c, IsDeleted, Exceptional_Perf_Conversion_Target_Dolla__c, Exceptional_Perf_Conversion_Target__c, Exceptional_Perf_Growth_Target_Dollar__c, Exceptional_Perf_Growth_Reve__c, FE_codes__c, GAM_codes__c, Industrial_Performance_Weighting__c, LastModifiedById, LastModifiedDate, Level_1_Conversion_Target_Dollar__c, Level_1_Conversion_target__c, Level_1_Growth_Target_Dollar__c, Level_1_Growth_Target__c, Level_1_Pipeline_Target_Dollar__c, Level_1_Pipeline_Target__c, Level_2_Conversion_Target_Dollar__c, Level_2_Conversion_Target__c, Level_2_Growth_Target_Dollar__c, Level_2_Growth_Target__c, Level_2_Pipeline_Target_Dollar__c, Level_2_Pipeline_Target__c, Level_3_Conversion_Target_Dollar__c, Level_3_Conversion_Target__c, Level_3_Growth_Target_Dollar__c, Level_3_Growth_Target__c, Level_3_Pipeline_Target_Dollar__c, Level_3_Pipeline_Target__c, Load_Status_Direct_Billings__c, Load_Status_Monthly_Direct__c, Load_Status_POS__c, Load_Status_Record_Indirect__c, OwnerId, Participants_Manager__c, Participants_TE_Network_ID__c, Pipeline_Result__c, Plan_Comments__c, Plan_Participant__c, Plan_Year__c, Current_Year_Direct_Bill_YTD__c, Current_Year_Direct_Billings_Run_Rate__c, Current_Year_POS_Bill_YTD__c, Current_Year_POS_Run_Rate__c, Prev_Year_1__c, Prev_Year_1_POS_Result__c, Prev_Year_1_Total_Result__c, Prev_Year_Conversion_YTD_Result_Dollar__c, Prev_Year_Conversion_YTD_Result__c, Prev_Year_Dir_Bill_Run_Rate_Result__c, Prev_Year_Growth__c, Prev_Year_POS_Run_Rate_Result__c, Prev_Year_Pipeline_YTD_Result_Dollar__c, Prev_Year_Pipeline_YTD_Result__c, Total_Revenue_Baseline__c, Prev_Year_YTD_Direct_billings__c, Prev_Year_YTD_POS__c, Profit_Center_Codes__c, ConnectionReceivedId, Id, RecordTypeId, Region__c, Name, ConnectionSentId, SystemModstamp from SIP__c where Id =: sipFE.Id];
        sips.add(sipFE);
                
        SIP__c sipGAM = new SIP__c();
        sipGAM.GAM_codes__c = 'testGAM';
        sipGAM.Plan_Participant__c = user.Id;       
        sipGAM.RecordTypeId = recordTypeGAM;
        sipGAM.Plan_Year__c = '2014';
        sipGAM.Name = 'test GAM';
        sipGAM.SIP_master_record__c = sipMaster.Id;
        sipGAM.Prev_Year_YTD_Direct_billings__c  = 100;
         sipFE.Application__c='Machine Tools; MV Switchgear Control Cabinets; Outdoor Commercial & Industrial Lighting; Packing Machine; Plastic Molding Machine; PLC; Rail Traction; Robotics; Robotics and Production Line Integration; Safety Controllers; Semi-conductor Manufacturing Equipment; Servo Drive; Servo Motor; HVAC General Purpose Controllers;Automation Warehouse/Material Handling/AGV; Elevator Safety & Efficiency Equipment; EV Charging Station /BMS/ESS';
        insert sipGAM;
        sipGAM = [Select AM_codes__c, Approver__c, Business_Driver_1__c, Business_Driver_1_Achieved__c, Business_Driver_1_Weighting__c, Business_Driver_1_details__c, Business_Driver_2__c, Business_Driver_2_Achieved__c, Business_Driver_2_Weighting__c, Business_Driver_2_details__c, Business_Driver_3__c, Business_Driver_3_Achieved__c, Business_Driver_3_Weighting__c, Business_Driver_3_details__c, Business_Driver_4__c, Business_Driver_4_Achieved__c, Business_Driver_4_Weighting__c, Business_Driver_4_details__c, Conversion_result__c, CreatedById, CreatedDate, CurrencyIsoCode, Current_Fiscal_Year_Direct__c, Current_Fiscal_Year_Indirect__c, IsDeleted, Exceptional_Perf_Conversion_Target_Dolla__c, Exceptional_Perf_Conversion_Target__c, Exceptional_Perf_Growth_Target_Dollar__c, Exceptional_Perf_Growth_Reve__c, FE_codes__c, GAM_codes__c, Industrial_Performance_Weighting__c, LastModifiedById, LastModifiedDate, Level_1_Conversion_Target_Dollar__c, Level_1_Conversion_target__c, Level_1_Growth_Target_Dollar__c, Level_1_Growth_Target__c, Level_1_Pipeline_Target_Dollar__c, Level_1_Pipeline_Target__c, Level_2_Conversion_Target_Dollar__c, Level_2_Conversion_Target__c, Level_2_Growth_Target_Dollar__c, Level_2_Growth_Target__c, Level_2_Pipeline_Target_Dollar__c, Level_2_Pipeline_Target__c, Level_3_Conversion_Target_Dollar__c, Level_3_Conversion_Target__c, Level_3_Growth_Target_Dollar__c, Level_3_Growth_Target__c, Level_3_Pipeline_Target_Dollar__c, Level_3_Pipeline_Target__c, Load_Status_Direct_Billings__c, Load_Status_Monthly_Direct__c, Load_Status_POS__c, Load_Status_Record_Indirect__c, OwnerId, Participants_Manager__c, Participants_TE_Network_ID__c, Pipeline_Result__c, Plan_Comments__c, Plan_Participant__c, Plan_Year__c, Current_Year_Direct_Bill_YTD__c, Current_Year_Direct_Billings_Run_Rate__c, Current_Year_POS_Bill_YTD__c, Current_Year_POS_Run_Rate__c, Prev_Year_1__c, Prev_Year_1_POS_Result__c, Prev_Year_1_Total_Result__c, Prev_Year_Conversion_YTD_Result_Dollar__c, Prev_Year_Conversion_YTD_Result__c, Prev_Year_Dir_Bill_Run_Rate_Result__c, Prev_Year_Growth__c, Prev_Year_POS_Run_Rate_Result__c, Prev_Year_Pipeline_YTD_Result_Dollar__c, Prev_Year_Pipeline_YTD_Result__c, Total_Revenue_Baseline__c, Prev_Year_YTD_Direct_billings__c, Prev_Year_YTD_POS__c, Profit_Center_Codes__c, ConnectionReceivedId, Id, RecordTypeId, Region__c, Name, ConnectionSentId, SystemModstamp from SIP__c where Id =: sipGAM.Id];       
        sips.add(sipGAM);
        
        SIP__c sipGAM2 = new SIP__c();
        sipGAM2.GAM_codes__c = 'test1,testGAM2';
        sipGAM2.Plan_Participant__c = user.Id;      
        sipGAM2.RecordTypeId = recordTypeGAM;
        sipGAM2.Plan_Year__c = '2014';
        sipGAM2.Name = 'test GAM';
        sipGAM2.SIP_master_record__c = sipMaster.Id;
        sipGAM2.Prev_Year_YTD_Direct_billings__c  = 100;
        insert sipGAM2;
        sipGAM2 = [Select AM_codes__c, Approver__c, Business_Driver_1__c, Business_Driver_1_Achieved__c, Business_Driver_1_Weighting__c, Business_Driver_1_details__c, Business_Driver_2__c, Business_Driver_2_Achieved__c, Business_Driver_2_Weighting__c, Business_Driver_2_details__c, Business_Driver_3__c, Business_Driver_3_Achieved__c, Business_Driver_3_Weighting__c, Business_Driver_3_details__c, Business_Driver_4__c, Business_Driver_4_Achieved__c, Business_Driver_4_Weighting__c, Business_Driver_4_details__c, Conversion_result__c, CreatedById, CreatedDate, CurrencyIsoCode, Current_Fiscal_Year_Direct__c, Current_Fiscal_Year_Indirect__c, IsDeleted, Exceptional_Perf_Conversion_Target_Dolla__c, Exceptional_Perf_Conversion_Target__c, Exceptional_Perf_Growth_Target_Dollar__c, Exceptional_Perf_Growth_Reve__c, FE_codes__c, GAM_codes__c, Industrial_Performance_Weighting__c, LastModifiedById, LastModifiedDate, Level_1_Conversion_Target_Dollar__c, Level_1_Conversion_target__c, Level_1_Growth_Target_Dollar__c, Level_1_Growth_Target__c, Level_1_Pipeline_Target_Dollar__c, Level_1_Pipeline_Target__c, Level_2_Conversion_Target_Dollar__c, Level_2_Conversion_Target__c, Level_2_Growth_Target_Dollar__c, Level_2_Growth_Target__c, Level_2_Pipeline_Target_Dollar__c, Level_2_Pipeline_Target__c, Level_3_Conversion_Target_Dollar__c, Level_3_Conversion_Target__c, Level_3_Growth_Target_Dollar__c, Level_3_Growth_Target__c, Level_3_Pipeline_Target_Dollar__c, Level_3_Pipeline_Target__c, Load_Status_Direct_Billings__c, Load_Status_Monthly_Direct__c, Load_Status_POS__c, Load_Status_Record_Indirect__c, OwnerId, Participants_Manager__c, Participants_TE_Network_ID__c, Pipeline_Result__c, Plan_Comments__c, Plan_Participant__c, Plan_Year__c, Current_Year_Direct_Bill_YTD__c, Current_Year_Direct_Billings_Run_Rate__c, Current_Year_POS_Bill_YTD__c, Current_Year_POS_Run_Rate__c, Prev_Year_1__c, Prev_Year_1_POS_Result__c, Prev_Year_1_Total_Result__c, Prev_Year_Conversion_YTD_Result_Dollar__c, Prev_Year_Conversion_YTD_Result__c, Prev_Year_Dir_Bill_Run_Rate_Result__c, Prev_Year_Growth__c, Prev_Year_POS_Run_Rate_Result__c, Prev_Year_Pipeline_YTD_Result_Dollar__c, Prev_Year_Pipeline_YTD_Result__c, Total_Revenue_Baseline__c, Prev_Year_YTD_Direct_billings__c, Prev_Year_YTD_POS__c, Profit_Center_Codes__c, ConnectionReceivedId, Id, RecordTypeId, Region__c, Name, ConnectionSentId, SystemModstamp from SIP__c where Id =: sipGAM2.Id];     
        sips.add(sipGAM2);

        test.stopTest();    
    }
}