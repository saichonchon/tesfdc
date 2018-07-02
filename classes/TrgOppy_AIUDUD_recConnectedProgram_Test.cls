/**
*   This test class is for opportunity_AIUDUD_recalculateConnectedProgram.
*
@author Di Chen
@created 2012-09-20
@version 1.0
@since 20.0
*
@changelog
* 2012-09-20 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage  90%
*/
@isTest
private class TrgOppy_AIUDUD_recConnectedProgram_Test {
 
    static testMethod void testInsert() {    
        User u =  [Select Id, Name,Email , country,GIBU__c,Sub_Vertical__c,PMV_Type_Initialization__c  From User 
                 where GIBU__c='Industrial' and Sub_Vertical__c='Industrial' and country != 'China' and PMV_Type_Initialization__c = 'Standard' and isactive=true 
                  limit 1];
                              
        system.runAs(u){
            
            RecordType rt2 = ClsTestHelp.createTestRecordType16();

            ClsTestCustomSettingHelper.getApex_Helper_Settings();
            ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
            ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
            ClsTestCustomSettingHelper.getOpportunity_Approvers();
            ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
            ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();

            List<Trigger_Configuration__c> lstTC = new List<Trigger_Configuration__c>();
            Trigger_Configuration__c tc = new Trigger_Configuration__c();
            tc.Name = 'Identify Fiscal Year';
            tc.isRun__c = true;
            lstTC.add(tc);
            
            Trigger_Configuration__c tc1 = new Trigger_Configuration__c();
            tc1.Name = 'Populate Opportunity Partner';
            tc1.isRun__c = true;
            lstTC.add(tc1);
            
            Trigger_Configuration__c tc2 = new Trigger_Configuration__c();
            tc2.Name = 'updateAccountBusinessUnit';
            tc2.isRun__c = true;
            lstTC.add(tc2);
            insert lstTC;
                                    
            Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Program_level_Forecasting__c =true; 
            oppy2.Name = 'Pain of Queen';
            oppy2.Type = 'CM';
            oppy2.Request_Type__c = 'Extension';
            oppy2.RecordTypeId = rt2.Id;            
            insert oppy2;  
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.StageName = 'Approved/Active';
            oppy.RecordTypeId = rt2.Id;
            oppy.Program__c = oppy2.Id;  
            
            Test.startTest();
        
            insert oppy;
            system.assert(true);
            Test.stopTest();
        }
    }
    
   
    static testMethod void testUpdate() {
        User u =  [Select Id, Name,Email , country,GIBU__c,Sub_Vertical__c,PMV_Type_Initialization__c  From User 
                 where GIBU__c='Industrial' and Sub_Vertical__c='Industrial' and country != 'China' and PMV_Type_Initialization__c = 'Standard' and isactive=true 
                  limit 1];        
        system.runAs(u){
            
            ClsTestCustomSettingHelper.getApex_Helper_Settings();
            ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
            ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
            ClsTestCustomSettingHelper.getOpportunity_Approvers();
            ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
            ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();

            List<Trigger_Configuration__c> lstTC = new List<Trigger_Configuration__c>();
            Trigger_Configuration__c tc = new Trigger_Configuration__c();
            tc.Name = 'Identify Fiscal Year';
            tc.isRun__c = true;
            lstTC.add(tc);
            
            Trigger_Configuration__c tc1 = new Trigger_Configuration__c();
            tc1.Name = 'Populate Opportunity Partner';
            tc1.isRun__c = true;
            lstTC.add(tc1);
            
            Trigger_Configuration__c tc2 = new Trigger_Configuration__c();
            tc2.Name = 'updateAccountBusinessUnit';
            tc2.isRun__c = true;
            lstTC.add(tc2);
            insert lstTC;
                        
            RecordType rt2 = ClsTestHelp.createTestRecordType16();
            
            Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Program_level_Forecasting__c =true; 
            oppy2.Name = 'Pain of Queen';
            oppy2.Type = 'CM';
            oppy2.Request_Type__c = 'Extension';
            oppy2.RecordTypeId = rt2.Id;
            insert oppy2;  
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.StageName = 'Approved/Active';
            oppy.RecordTypeId = rt2.Id;
            oppy.Program__c = null;
            
            Test.startTest();
        
            insert oppy;
            
            oppy.Program__c = oppy2.Id;  
            oppy.stageName  = 'Lost';
            update oppy;
        
            system.assert(true);
            Test.stopTest();
        }
    }

    static testMethod void testUpdate1() {
        User u =  [Select Id, Name,Email , country,GIBU__c,Sub_Vertical__c,PMV_Type_Initialization__c  From User 
                 where GIBU__c='Industrial' and Sub_Vertical__c='Industrial' and country != 'China' and PMV_Type_Initialization__c = 'Standard' and isactive=true 
                  limit 1];        
        system.runAs(u){
            
            ClsTestCustomSettingHelper.getApex_Helper_Settings();
            ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
            ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
            ClsTestCustomSettingHelper.getOpportunity_Approvers();
            ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
            ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();

            List<Trigger_Configuration__c> lstTC = new List<Trigger_Configuration__c>();
            Trigger_Configuration__c tc = new Trigger_Configuration__c();
            tc.Name = 'Identify Fiscal Year';
            tc.isRun__c = true;
            lstTC.add(tc);
            
            Trigger_Configuration__c tc1 = new Trigger_Configuration__c();
            tc1.Name = 'Populate Opportunity Partner';
            tc1.isRun__c = true;
            lstTC.add(tc1);
            
            Trigger_Configuration__c tc2 = new Trigger_Configuration__c();
            tc2.Name = 'updateAccountBusinessUnit';
            tc2.isRun__c = true;
            lstTC.add(tc2);
            insert lstTC;
                        
            RecordType rt2 = ClsTestHelp.createTestRecordType16();
            RecordType rt = ClsTestHelp.createTestRecordType10();
            
            Test.startTest();
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            insert acc;
            
            Opportunity oppy1 = ClsTestHelp.createTestOpportunity();
            oppy1.Program_level_Forecasting__c =true; 
            oppy1.Name = 'Pain of Queen1';
            oppy1.Type = 'CM';
            oppy1.Request_Type__c = 'Extension';
            oppy1.RecordTypeId = rt2.Id;
            oppy1.StageName = 'Initiating';
            insert oppy1; 
            
            Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Program_level_Forecasting__c =true; 
            oppy2.Name = 'Pain of Queen1';
            oppy2.Type = 'CM';
            oppy2.Request_Type__c = 'Extension';
            oppy2.RecordTypeId = rt2.Id;
            oppy2.StageName = 'Initiating';
            insert oppy2; 
                        
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.StageName = 'Approved/Active';
            oppy.RecordTypeId = rt2.Id;
            oppy.Program__c = oppy1.Id;
            oppy.StageName = 'Initiating'; 
            insert oppy;
            system.assertequals(oppy.Program__c,oppy1.Id);

            oppy.Program__c = oppy2.Id;  
            oppy.stageName  = 'Dead';
            update oppy;
            system.assertequals(oppy.Program__c,oppy2.Id);
            
            system.assert(true);
            Test.stopTest();
        }
    }
       
    static testMethod void testDelete() {
        User u =  [Select Id, Name,Email , country,GIBU__c,Sub_Vertical__c,PMV_Type_Initialization__c  From User 
                 where GIBU__c='Industrial' and Sub_Vertical__c='Industrial' and country != 'China' and PMV_Type_Initialization__c = 'Standard' and isactive=true 
                  limit 1];        
        system.runAs(u){
            
            ClsTestCustomSettingHelper.getApex_Helper_Settings();
            ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
            ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
            ClsTestCustomSettingHelper.getOpportunity_Approvers();
            ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
            ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();

            List<Trigger_Configuration__c> lstTC = new List<Trigger_Configuration__c>();
            Trigger_Configuration__c tc = new Trigger_Configuration__c();
            tc.Name = 'Identify Fiscal Year';
            tc.isRun__c = true;
            lstTC.add(tc);
            
            Trigger_Configuration__c tc1 = new Trigger_Configuration__c();
            tc1.Name = 'Populate Opportunity Partner';
            tc1.isRun__c = true;
            lstTC.add(tc1);
            
            Trigger_Configuration__c tc2 = new Trigger_Configuration__c();
            tc2.Name = 'updateAccountBusinessUnit';
            tc2.isRun__c = true;
            lstTC.add(tc2);
            insert lstTC;
                        
            RecordType rt2 = ClsTestHelp.createTestRecordType16();
            
            Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Program_level_Forecasting__c =true; 
            oppy2.Name = 'Pain of Queen';
            oppy2.Type = 'CM';
            oppy2.Request_Type__c = 'Extension';
            oppy2.RecordTypeId = rt2.Id;
            insert oppy2;  
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.StageName = 'Approved/Active';
            oppy.RecordTypeId = rt2.Id;
            oppy.Program__c = null;
            
            Test.startTest();
        
            insert oppy;
            
            delete oppy2;
        
            system.assert(true);
            Test.stopTest();
        }
    }
        
}