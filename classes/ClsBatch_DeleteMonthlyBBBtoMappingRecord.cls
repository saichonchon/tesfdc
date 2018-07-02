/***********************************************************************************************************************
Name: ClsBatch_DeleteMonthlyBBBtoMappingRecords
Copyright © 2014 TE Connectivity | Salesforce Instance : C2S
========================================================================================================================
Purpose: Delete the MonthlyBBB to Mapping Records(By Keeping the MonthlyBBB to Mapping records of last 4 months into the system)                                                  
========================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR                DATE       DETAIL                                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------
1.0    Michael Cui            04/23/2014     Initial Development                                         
***********************************************************************************************************************/
global class ClsBatch_DeleteMonthlyBBBtoMappingRecord implements Database.Batchable<SObject>, Database.Stateful{    
    global String query;
    global String prior4PeriodFM;
    global String prior4PeriodFY;
    public ClsBatch_DeleteMonthlyBBBtoMappingRecord()
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
            prior4PeriodFM = String.valueOf(Integer.valueOf(ClsOEMUtil.CurrentFM) + 8).leftpad(2).replace(' ', '0');
            prior4PeriodFY = String.valueOf(Integer.valueOf(ClsOEMUtil.CurrentFY) - 1);
        }        
    }    
                                                                                               
    global Database.QueryLocator start(Database.BatchableContext BC){
        if (query == '' || query == null){
             
             query = 'Select OEM_Mapping__r.Fiscal_Year__c, OEM_Mapping__r.Fiscal_Month__c, OEM_Mapping__c, Monthly_Billings_Bookings_by_Part__c, Id From CSD_OEM_Mapping_Monthly_BBB__c where (OEM_Mapping__r.Fiscal_Month__c <=: prior4PeriodFM and OEM_Mapping__r.Fiscal_Year__c<=: prior4PeriodFY) or OEM_Mapping__r.Fiscal_Year__c<: prior4PeriodFY or Monthly_Billings_Bookings_by_Part__c = null';
        }
        if(Test.isRunningTest()){
            if (query != '' || query != null){
                query+= ' LIMIT 1';
            }
        }
        return Database.getQueryLocator(query);     
    }

    
    global void execute(Database.BatchableContext BC, list<CSD_OEM_Mapping_Monthly_BBB__c> list_MonthlyBBBtoMappingRecords){
        if(list_MonthlyBBBtoMappingRecords != null && list_MonthlyBBBtoMappingRecords.size()>0) {
           
            delete list_MonthlyBBBtoMappingRecords;
            Database.emptyRecycleBin(list_MonthlyBBBtoMappingRecords);  
        }
    }         
    global void finish(Database.BatchableContext info) 
    {     
    }     
}