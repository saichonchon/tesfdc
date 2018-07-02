/***********************************************************************************************************************
Name: ClsBatch_DeleteDailyBBBtoMappingRecords
Copyright © 2014 TE Connectivity | Salesforce Instance : C2S
========================================================================================================================
Purpose: Delete the DailyBBB to Mapping Records(By Keeping the DailyBBB to Mapping records of last 4 months into the system)                                                  
========================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR                DATE       DETAIL                                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------
1.0    Michael Cui            04/23/2014     Initial Development                                         
***********************************************************************************************************************/
global class ClsBatch_DeleteDailyBBBtoMappingRecords implements Database.Batchable<SObject>, Database.Stateful{    
    global String query;
    global String prior4PeriodFM;
    global String prior4PeriodFY;
    public ClsBatch_DeleteDailyBBBtoMappingRecords()
    {
        if(ClsOEMUtil.CurrentFM == null)
        {
            ClsOEMUtil.setCurrentFiscalDateValues();
        }
        if(ClsOEMUtil.CurrentFM >4)
        {
            prior4PeriodFM = string.valueOf(ClsOEMUtil.CurrentFM -4).leftpad(2).replace(' ','0');
            prior4PeriodFY = ClsOEMUtil.CurrentFY;
        }
        else if(ClsOEMUtil.CurrentFM == 4)
        {
            prior4PeriodFM = '12';
            prior4PeriodFY = String.valueOf(Integer.valueOf(ClsOEMUtil.CurrentFY) - 1);
        }
        else if(ClsOEMUtil.CurrentFM < 4)
        {
            prior4PeriodFM = String.valueOf(Integer.valueOf(ClsOEMUtil.CurrentFM ) + 8).leftpad(2).replace(' ', '0');
            prior4PeriodFY = String.valueOf(Integer.valueOf(ClsOEMUtil.CurrentFY) - 1);
        }        
    }    
                                                                                               
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        if (query == '' || query == null){
             
             query = 'Select Id, CSD_OEM_Mapping__r.Fiscal_Year__c, CSD_OEM_Mapping__r.Fiscal_Month__c, CSD_OEM_Mapping__c, Daily_Booking_Billing_Backlog_By_Part__c From CSD_OEM_Mapping_Daily_BBB__c where (CSD_OEM_Mapping__r.Fiscal_Month__c <=: prior4PeriodFM and CSD_OEM_Mapping__r.Fiscal_Year__c <=: prior4PeriodFY) or CSD_OEM_Mapping__r.Fiscal_Year__c <: prior4PeriodFY or Daily_Booking_Billing_Backlog_By_Part__c = null';
        }
        if(Test.isRunningTest()){
            if (query != '' || query != null){
                query+= ' LIMIT 1';
            }
        }
        return Database.getQueryLocator(query);     
    }

    
    global void execute(Database.BatchableContext BC, list<CSD_OEM_Mapping_Daily_BBB__c> list_DailyBBBtoMappingRecords){
        if(list_DailyBBBtoMappingRecords != null && list_DailyBBBtoMappingRecords.size()>0) {
           
            delete list_DailyBBBtoMappingRecords;
            Database.emptyRecycleBin(list_DailyBBBtoMappingRecords);  
        }
    }         
    global void finish(Database.BatchableContext info) 
    {  
        //ClsBatch_DeleteMonthlyBBBtoMappingRecord oemMBBB = new ClsBatch_DeleteMonthlyBBBtoMappingRecord();        
        //Database.executeBatch(oemMBBB);   
    }     
}