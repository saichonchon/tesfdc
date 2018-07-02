/***********************************************************************************************************************
      Name : Cls_SchedularDNDJDASchedular
       Org : C2S
 Copyright : © 2014 TE Connectivity 
========================================================================================================================
   Summary : This is a schedular for the Batch Cls_BatchDNDJDAPartForecast.
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR       DATE       DETAIL               User Story #                  
________________________________________________________________________________________________________________________
     1.0 Prabhanjan   08/13/2015 Initial Development                   
***********************************************************************************************************************/
global class Cls_SchedularDNDJDASchedular implements Schedulable{
    global void execute(SchedulableContext SC){
        
        /* Prabhanjan 14-Jun-16 Case:00901003  Commenting previous logic
         
        INFRA_JDA_Settings__c vConfig = INFRA_JDA_Settings__c.getValues('DND');
        Period vPeriod = [SELECT StartDate, EndDate 
                            FROM Period 
                           WHERE Type = 'Month' 
                             AND StartDate <= TODAY 
                             AND EndDate >= TODAY];
                             
        Date vFisaclStartDate = vPeriod.StartDate;
        system.debug(Date.Today());
        system.debug(vFisaclStartDate);
        system.debug(vConfig);
        system.debug(vConfig.N_th_Day_of_Fiscal_Month__c);
        
        system.debug(Integer.valueOf(vConfig.N_th_Day_of_Fiscal_Month__c-1));
        system.debug(vFisaclStartDate.addDays(Integer.valueOf(vConfig.N_th_Day_of_Fiscal_Month__c-1))); 
        system.debug(Test.isRunningTest());
        //
       // if(Date.Today() == vFisaclStartDate.addDays(Integer.valueOf(vConfig.N_th_Day_of_Fiscal_Month__c-1)) || Test.isRunningTest()){
       if(Test.isRunningTest()){
            //DELETE EXISTING RECORDS
             
            List<INFRA__Part_Forecast__c> vListINFRAPart = [SELECT Id FROM INFRA__Part_Forecast__c where INFRA__Business_Unit__c = 'DND' LIMIT 9999];
            List<INFRA__Account_Forecast__c> vListINFRAAccount = [SELECT Id FROM INFRA__Account_Forecast__c where INFRA__Business_Unit__c = 'DND' LIMIT 9999];
            
            if(!vListINFRAPart.isEmpty()){                DELETE vListINFRAPart;            }
            if(!vListINFRAAccount.isEmpty()){                DELETE vListINFRAAccount;            }
             
            //Commented by Sandeep
            //CREATE AN CONVERSION RATES MAP
            List<CurrencyType> currencyTypeList = [select IsoCode, ConversionRate from CurrencyType];
            Map<String, Decimal> vConversionMap = new Map<String, Decimal>();
            for(CurrencyType vTempCurrency : currencyTypeList){
                vConversionMap.put(vTempCurrency.IsoCode, vTempCurrency.ConversionRate);
            }*/
            //CALL THE PART FORECAST BATCH CLASS
        //}
        Cls_BatchDNDJDAPartForecast vBatch = new Cls_BatchDNDJDAPartForecast();
        Id batchInstanceId = Database.executeBatch(vBatch, 1000);  
        
    }   
}