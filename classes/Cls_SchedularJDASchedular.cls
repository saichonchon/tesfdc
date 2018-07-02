/***********************************************************************************************************************
      Name : Cls_SchedularJDASchedular
       Org : C2S
 Copyright : © 2014 TE Connectivity 
========================================================================================================================
   Summary : This is a schedular for the Batch Cls_BatchJDAPartForecast.
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR       DATE       DETAIL               User Story #                  
________________________________________________________________________________________________________________________
     1.0 Shantinath   04/09/2014 Initial Development  42                  
***********************************************************************************************************************/
global class Cls_SchedularJDASchedular implements Schedulable{
    global void execute(SchedulableContext SC){
        INFRA_JDA_Settings__c vConfig = INFRA_JDA_Settings__c.getValues('Default');
        Period vPeriod = [SELECT StartDate, EndDate 
                            FROM Period 
                           WHERE Type = 'Month' 
                             AND StartDate <= TODAY 
                             AND EndDate >= TODAY];
                             
        Date vFisaclStartDate = vPeriod.StartDate;
        if(Date.Today() == vFisaclStartDate.addDays(Integer.valueOf(vConfig.N_th_Day_of_Fiscal_Month__c-1)) || Test.isRunningTest()){
            //DELETE EXISTING RECORDS
            List<INFRA__Part_Forecast__c> vListINFRAPart = [SELECT Id FROM INFRA__Part_Forecast__c WHERE INFRA__Business_Unit__c = 'IND' LIMIT 9999]; // Added filter condition INFRA Business Unit for Case #00886342 on 28-Aug-2015
            List<INFRA__Account_Forecast__c> vListINFRAAccount = [SELECT Id FROM INFRA__Account_Forecast__c WHERE INFRA__Business_Unit__c = 'IND' LIMIT 9999]; // Added filter condition INFRA Business Unit for Case #00886342 on 28-Aug-2015
            
            if(!vListINFRAPart.isEmpty()){
                DELETE vListINFRAPart;
            }
            if(!vListINFRAAccount.isEmpty()){
                DELETE vListINFRAAccount;
            }
            
            //CREATE AN CONVERSION RATES MAP
            List<CurrencyType> currencyTypeList = [select IsoCode, ConversionRate from CurrencyType];
            Map<String, Decimal> vConversionMap = new Map<String, Decimal>();
            for(CurrencyType vTempCurrency : currencyTypeList){
                vConversionMap.put(vTempCurrency.IsoCode, vTempCurrency.ConversionRate);
            }
            //CALL THE PART FORECAST BATCH CLASS
            Cls_BatchJDAPartForecast vBatch = new Cls_BatchJDAPartForecast(vConversionMap);
            Id batchInstanceId = Database.executeBatch(vBatch, 100);  
        }
    }   
}