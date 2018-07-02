/***********************************************************************************************************************
      Name : Cls_BatchJDAAccountForecast
       Org : C2S
 Copyright : © 2014 TE Connectivity 
========================================================================================================================
   Summary : A batch class to create records in INFRA Account Forecast object
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR       DATE       DETAIL                               User Story #                  
________________________________________________________________________________________________________________________
     1.0 Shantinath   04/07/2014 Initial Development                  42 
     1.1 Mrunal       06/05/2014 Change to display region             42
                                 names in short instead of code.       
     1.2 Mrunal       23/07/2014 Changed cron statement to schedule    42
                                 batch on 3rd friday of every month              
***********************************************************************************************************************/
global class Cls_BatchJDAAccountForecast implements Database.Batchable<sObject>, Database.Stateful{
    /* _______________________________________ GLOBAL VARIABLE DECLARATION ___________________________________________*/    
    global String vQuery;
    global Set<Id> vRTSetToAdd = new Set<Id>();
    global Map<String, Decimal> vConversionMap = new Map<String, Decimal>();
    global Map<String, Decimal> vAmountMap = new Map<String, Decimal>();
    
    global Cls_BatchJDAAccountForecast(Map<String, Decimal> pConversionMap, Map<String, Decimal> pAmountMap){
        vConversionMap = pConversionMap.clone();
        vAmountMap = pAmountMap.clone();
        vRTSetToAdd.add(Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account').getRecordTypeId());
        if(!vRTSetToAdd.isEmpty()){
        // Changed By Mrunal from 'LAYER2_ORGANIZATION_ID__c' to 'LAYER2_ORGANIZATION_SHORT_NM__c' to show Short Name instead of code
            vQuery = 'SELECT Id, LAYER2_ORGANIZATION_SHORT_NM__c, Account_Number_JDA_bridge_format__c FROM Account '+
                    +'WHERE Territory_L2_Code__c = \'102202\' AND RecordTypeId in: vRTSetToAdd';
             if(Test.isRunningTest())
                vQuery += ' LIMIT 200';
        }
    }
    
    //STANDARD QueryLocator METHOD TO EXECUTE THE QUERY IN CONSTRUCTOR
    global Database.QueryLocator start(Database.BatchableContext BC){
        if(vQuery != null){
            return Database.getQueryLocator(vQuery);
        }
        return null;          
    }

    //ACTUAL LOGIC TO CREATE FORECAST RECORDS
    global void execute(Database.BatchableContext BC, List<Account> pAccountList){
        if(!pAccountList.isEmpty()){
            Map<Id, Account> vMapIdToAccount = new Map<Id, Account>();
            
            for(Account vTempAcc : pAccountList){
                vMapIdToAccount.put(vTempAcc.Id, vTempAcc);
            }
            
            List<BBB_Month_Bill_Book_Cust__c> vListMonthlyBBB = [SELECT Id,
                                                                        Fiscal_Year_Month_short__c,
                                                                        Forecast__c,
                                                                        Customer__c,
                                                                        CurrencyIsoCode
                                                                   FROM BBB_Month_Bill_Book_Cust__c
                                                                  WHERE Customer__c in: vMapIdToAccount.keySet()
                                                                    AND Sales_Period__c >= TODAY
                                                                    AND Sales_Period__c <= NEXT_N_MONTHS:18
                                                                    AND Forecast__c <> NULL];
            if(!vListMonthlyBBB.isEmpty()){
                Map<Id, List<BBB_Month_Bill_Book_Cust__c>> vMapAccToBBB = new Map<Id, List<BBB_Month_Bill_Book_Cust__c>>();
                
                for(BBB_Month_Bill_Book_Cust__c vTempMBBB : vListMonthlyBBB){
                    List<BBB_Month_Bill_Book_Cust__c> vTempBBBList = new List<BBB_Month_Bill_Book_Cust__c>();
                    if(!vMapAccToBBB.containsKey(vTempMBBB.Customer__c)){
                        vTempBBBList.add(vTempMBBB);
                        vMapAccToBBB.put(vTempMBBB.Customer__c, vTempBBBList);
                    }else{
                        vTempBBBList = vMapAccToBBB.get(vTempMBBB.Customer__c);
                        vTempBBBList.add(vTempMBBB);
                        vMapAccToBBB.put(vTempMBBB.Customer__c, vTempBBBList);
                    }
                }
                                
                //COLLECTION OF ACCOUNT FORECAST
                List<INFRA.ForecastData.AccountData> forecastList = new List<INFRA.ForecastData.AccountData>();
                
                for(Id vTempId : vMapAccToBBB.keySet()){
                    //INFRA MASTER RECORD
                    INFRA.ForecastData.AccountData forecastHeader1 = new INFRA.ForecastData.AccountData();
                     
                    forecastHeader1.customer          = vMapIdToAccount.get(vTempId).Account_Number_JDA_bridge_format__c;                   
                    forecastHeader1.customerIndicator = INFRA.ForecastUtil.CustomerIndicator.SoldTo;                    
                    forecastHeader1.dataStream        = INFRA.ForecastUtil.DataStream.SalesDemandForecast;               
                    forecastHeader1.region            = vMapIdToAccount.get(vTempId).LAYER2_ORGANIZATION_SHORT_NM__c;// Changed By Mrunal from 'LAYER2_ORGANIZATION_ID__c' to show Short Name instead of code             
                    forecastHeader1.site              = 'OTHERS';
                    forecastHeader1.siteIndicator     = INFRA.ForecastUtil.SiteIndicator.Others;
                    
                    //Unique id that represents the SFDC forecast source record, can be Account SFDC Id
                    forecastHeader1.businessUnitForecastSourceId = vTempId;
                    
                    List<INFRA.ForecastDetail.AccountDetail> forecastDetailList1 = new List<INFRA.ForecastDetail.AccountDetail>();
                    for(BBB_Month_Bill_Book_Cust__c vTempMBBB : vMapAccToBBB.get(vTempId)){ 
                        INFRA.ForecastDetail.AccountDetail forecastDetail1 = new INFRA.ForecastDetail.AccountDetail();                       
                        
                        //forecast period (period month format YYYYMM, quater format YYYYQ#, year format YYYY)
                        forecastDetail1.period = vTempMBBB.Fiscal_Year_Month_short__c;
                        String vAmountKey = forecastHeader1.customer+'_'+forecastDetail1.period;
                        //forecast amount
                        Decimal vTempAmount = 0;
                        if(vTempMBBB.Forecast__c == NULL) vTempMBBB.Forecast__c = 0;
                        if(vTempMBBB.CurrencyIsoCode == 'USD'){
                            vTempAmount = vTempMBBB.Forecast__c;
                        }else{
                            vTempAmount = vTempMBBB.Forecast__c / vConversionMap.get(vTempMBBB.CurrencyIsoCode);
                        }
                        if(!vAmountMap.keySet().contains(vAmountKey)){
                            forecastDetail1.amount = vTempAmount;
                        }else{
                            forecastDetail1.amount = vTempAmount - math.abs(vAmountMap.get(vAmountKey));
                        }
                        forecastDetail1.periodIndicator = INFRA.ForecastUtil.ForecastPeriodIndicator.Monthly;     
                        forecastDetailList1.Add(forecastDetail1);
                    }
                    forecastHeader1.forecastDetail = forecastDetailList1;
                    forecastList.Add(forecastHeader1);
                }
                //Create the 'ForecastPublishManagerClass' class object by passing the BU Name in the constructor
                INFRA.ForecastPublishManagerClass clsObj = new INFRA.ForecastPublishManagerClass('IND');
                //invoke the Account publish function and pass the forecast list
                clsObj.publishAccountForecast(forecastList);    
            }   
        }
    }

    global void finish(Database.BatchableContext BC) {
        //SCHEDULE FOR NEXT RUN AT 21ST OF NEXT FISCAL MONTH
        INFRA_JDA_Settings__c vConfig = INFRA_JDA_Settings__c.getValues('Default');
        Date vManSchDate = Date.Today();
        Date myDate;
        Period vCurrPeriod = [SELECT StartDate, EndDate 
                            FROM Period 
                            WHERE Type = 'Month' 
                            AND StartDate <=: vManSchDate 
                            AND EndDate >=: vManSchDate];
        Date vFiscalStartDate = vCurrPeriod.StartDate;
        Integer noOfDays = vFiscalStartDate.daysBetween(vManSchDate);
        if(noOfDays < Integer.valueOf(vConfig.N_th_Day_of_Fiscal_Month__c-1)){
            myDate = vFiscalStartDate.addDays(Integer.valueOf(vConfig.N_th_Day_of_Fiscal_Month__c-1));
        }else{
            Date vNextMonthDate = Date.Today().addDays(Integer.valueOf(vConfig.N_th_Day_of_Fiscal_Month__c-1));
            Period vNextPeriod = [SELECT StartDate, EndDate 
                            FROM Period 
                           WHERE Type = 'Month' 
                             AND StartDate <=: vNextMonthDate 
                             AND EndDate >=: vNextMonthDate];
                             
            Date vNextFiscalStartDate = vNextPeriod.StartDate;
            myDate = vNextFiscalStartDate.addDays(Integer.valueOf(vConfig.N_th_Day_of_Fiscal_Month__c-1));
        }
                
        String sch = '0 0 6 '+myDate.Day()+' '+myDate.Month()+' ? '+myDate.Year();
        //THE CRON STATEMENT FORMED HERE IS IN FORMAT SEC/MIN/HH/DAY_OF_MONTH/MONTH/DAY_OF_WEEK/YEAR
        //0 0 0 XX XX ? XXXX
        Cls_SchedularJDASchedular m = new Cls_SchedularJDASchedular();
        system.schedule('JDA PART AND ACCOUNT FORECAST AT '+System.NOW(), sch, m); 
    }
}