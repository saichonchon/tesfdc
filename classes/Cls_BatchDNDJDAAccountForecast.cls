/***********************************************************************************************************************
      Name : Cls_BatchDNDJDAAccountForecast
Test Class Name : Cls_BatchDNDJDAAccountForecast_Test
       Org : C2S
 Copyright : © 2015 TE Connectivity 
========================================================================================================================
   Summary : A batch class to create records in INFRA Account Forecast object
   Reference: the apex class by the name 'Cls_BatchJDAAccountForecast' was referenced for creating this class.
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION    AUTHOR       DATE           DETAIL                               User Story #                  
________________________________________________________________________________________________________________________
 1.0    Prabhanjan   07/Aug/2014 Initial Development 
 1.1    Padmaja      14/Dec/2015 Enhancement         
 1.2    Rajendra S   22/08/2016  Enhancement for DND forecast project to sync 18 month data with JDA
***********************************************************************************************************************/
global class Cls_BatchDNDJDAAccountForecast implements Database.Batchable<sObject>, Database.Stateful{
    /* _______________________________________ GLOBAL VARIABLE DECLARATION ___________________________________________*/    
    global String vQuery;
     /* Added global variables for Filter forecast data by padmaja  14/12/2015*/
    global String Jdanotin;
    global String strGiants; 
    global Date vFiscalStartDate;
    global Date fiscalMonth1Date;
    global Date fiscalMonth12Date;
    global Set<Id> vRTSetToAdd = new Set<Id>();
    global Set<Id> vEngOppRTSet = new Set<Id>();
    global Set<Id> vSalesOppRTSet = new Set<Id>();
    global Map<String, Decimal> vConversionMap = new Map<String, Decimal>();
    global Map<String, Decimal> vAmountMap = new Map<String, Decimal>();
    global Map<String, List<Decimal>> vMapAccountToAmt = new Map<String, List<Decimal>>();
    
    global Cls_BatchDNDJDAAccountForecast(){
        
        INFRA_JDA_Settings__c vConfig = INFRA_JDA_Settings__c.getValues('DND');
        Date vManSchDate = Date.Today();
        Date myDate;
        Period vCurrPeriod = [SELECT StartDate, EndDate 
                            FROM Period 
                            WHERE Type = 'Month' 
                            AND StartDate <=: vManSchDate 
                            AND EndDate >=: vManSchDate];
        vFiscalStartDate = vCurrPeriod.StartDate;
        
        //START - Comments and Changes By Sandeep (12/07/2015)
        /*
        Fiscal Start Date from period object is actual date, but the date stored in forecast object is constructed date (formula field) based on fiscal month and year, 
        which does not match with actual date. So we need to construct the fiscal date.       
        */
        //get current fiscal year (using existing functions developed by ITB team)
        Integer vCurrentFiscalYear = Integer.valueof(ClsOppyForecastUtil.getFiscalYear());
        
        //get current fiscal month value (using existing functions developed by ITB team)
        Integer vCurrentFiscalMonth = Integer.valueof(ClsBudgetPlanningUtil.getFiscalMonth(vFiscalStartDate));

        //create next fiscal month date        
        fiscalMonth1Date = Date.newInstance(vCurrentFiscalYear, vCurrentFiscalMonth+1, 1);

        /* Start: Commented by Rajendra Shahane to create fiscal month date for month after 18 months from next fiscal month(22/08/2016)
        //create fiscal month date for month after 12 months from next fiscal month
        fiscalMonth12Date = Date.newInstance(vCurrentFiscalYear + 1, vCurrentFiscalMonth+1, 1);
        End */
        // Start: Added by Rajendra Shahane for DND forecast project to sync 18 month data with JDA(22/08/2016)
        fiscalMonth12Date = fiscalMonth1Date.addMonths(18);
        // End: Added by Rajendra
        // 
        //END - Comments and Changes By Sandeep (12/07/2015)
        /* Added JDA Type and Fiscal Year Filter criteria for forecast data by padmaja  14/12/2015*/
        Jdanotin ='6'; 
            vQuery = 'Select Billing_Region__c, Sold_To_Number__c, Fiscal_Date__c,OEM_Code__c,OEM__c, '+
                    +'Part_Number__c, Sale_Territory__c, ID, Fiscal_Year_Plus_Month__c, '+
                    +'Forecast__c, Quantity__c, Price__c, Type__c,JDA_Type__c From CSD_Sales_Forecast__c '+
                    +'Where Part_Number__c = null and JDA_Type__c != null and JDA_Type__c !=: Jdanotin '
                    +'and Fiscal_Date__c >=:fiscalMonth1Date '           
                    +'and Fiscal_Date__c <:fiscalMonth12Date';
         
        
            if(Test.isRunningTest()) vQuery += ' LIMIT 10';
        
    }
    
    //STANDARD QueryLocator METHOD TO EXECUTE THE QUERY IN CONSTRUCTOR
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(vQuery);
        
    }

    //ACTUAL LOGIC TO CREATE FORECAST RECORDS
    global void execute(Database.BatchableContext BC, List<CSD_Sales_Forecast__c> paccountForecastList){
           
        //FOR FORECAST
            List<INFRA.ForecastData.AccountData> forecastList = new List<INFRA.ForecastData.AccountData>();
            for(CSD_Sales_Forecast__c accountForecast: paccountForecastList){
                //FOR PARENT FORECAST DATA
                INFRA.ForecastData.AccountData forecastHeader1  = new INFRA.ForecastData.AccountData();
                IF(accountForecast.Billing_Region__c=='AMERICAS')      forecastHeader1.region = '1001';
                ELSE IF(accountForecast.Billing_Region__c=='EMEA')     forecastHeader1.region = '1002';
                //ELSE IF(accountForecast.Billing_Region__c=='JAPAN')    forecastHeader1.region = '1003';
                //ELSE IF(accountForecast.Billing_Region__c=='KOREA')    forecastHeader1.region = '1004'; 
                //ELSE IF(accountForecast.Billing_Region__c=='ASIA EXCL JP&KR') forecastHeader1.region = '1005';
                ELSE IF(accountForecast.Billing_Region__c=='ASIA') forecastHeader1.region = '1005';
                ELSE    forecastHeader1.region = '1099';
                    
                forecastHeader1.dataStream                   = INFRA.ForecastUtil.DataStream.SalesDemandForecast;
                forecastHeader1.customer                     = (accountForecast.OEM_Code__c!=null?accountForecast.OEM_Code__c:''); 
                //commented by sandeep, since we have to check for OEM__c
                //IF(accountForecast.OEM_Code__c==null||accountForecast.OEM_Code__c=='')    forecastHeader1.customerIndicator            = INFRA.ForecastUtil.CustomerIndicator.SoldTo;
                IF(accountForecast.OEM__c==null)    forecastHeader1.customerIndicator            = INFRA.ForecastUtil.CustomerIndicator.SoldTo;
                ELSE    forecastHeader1.customerIndicator            = INFRA.ForecastUtil.CustomerIndicator.SoldToWithOEM;
                  
                forecastHeader1.businessUnitForecastSourceId = accountForecast.ID;
                string soldtonum = accountForecast.Sold_To_Number__c;
                
                if(soldtonum!=null&&soldtonum.length()>=4)   {
                    forecastHeader1.site = soldtonum.substring(0,4);  
                }
                else{
                    forecastHeader1.site=''; 
                }
                  
                forecastHeader1.siteIndicator                = INFRA.ForecastUtil.SiteIndicator.LegalOrg;
                if (accountForecast.Sale_Territory__c != null && !string.isNotEmpty(accountForecast.Sale_Territory__c))
                {
                    forecastHeader1.territoryCode                = accountForecast.Sale_Territory__c;
                    forecastHeader1.territoryIndicator           = INFRA.ForecastUtil.TerritoryIndicator.DD7;
                }

                //FOR DETAIL Record
                List<INFRA.ForecastDetail.AccountDetail> forecastDetailList1 = new List<INFRA.ForecastDetail.AccountDetail>();
                INFRA.ForecastDetail.AccountDetail forecastDetail1 = new INFRA.ForecastDetail.AccountDetail();
                
                If(accountForecast.Forecast__c != NULL) forecastDetail1.amount = accountForecast.Forecast__c.setScale(4); 
                    
                forecastDetail1.period = accountForecast.Fiscal_Year_Plus_Month__c;
                forecastDetail1.periodIndicator = INFRA.ForecastUtil.ForecastPeriodIndicator.Monthly; 
                forecastDetail1.ATTRIB_NM_2= accountForecast.JDA_Type__c;
                forecastDetailList1.add(forecastDetail1);
                forecastHeader1.forecastDetail = forecastDetailList1;
                forecastList.Add(forecastHeader1);
            }
                //Create the 'ForecastPublishManagerClass' class object by passing the BU Name in the constructor
                INFRA.ForecastPublishManagerClass clsObj = new INFRA.ForecastPublishManagerClass('DND');
                //invoke the Account publish function and pass the forecast list
                clsObj.publishAccountForecast(forecastList);                                   

    }


    global void finish(Database.BatchableContext BC) {
          //SCHEDULE FOR NEXT RUN AT 1ST OF NEXT FISCAL MONTH
        INFRA_JDA_Settings__c vConfig = INFRA_JDA_Settings__c.getValues('DND');
        Date sysDate = Date.Today();
        // Prabhanjan 14-Jun-16 Case:00901003 Adding 10 days to get to the next month as it will run on the last week of every month.
        Date vManSchDate =  sysDate.addDays((Integer)vConfig.CountingForward__c );
        Date myDate;
        Period vNextPeriod = [SELECT StartDate, EndDate 
                            FROM Period 
                            WHERE Type = 'Month' 
                            AND StartDate <=: vManSchDate 
                            AND EndDate >=: vManSchDate];
        // Prabhanjan 14-Jun-16 Case:00901003 Adding countingBack variable to get the last Saturday of next month by substracting 6 days from last day.
         
        myDate =vNextPeriod.EndDate.addDays((Integer)vConfig.CountingBack__c);
        //Prabhanjan 14-Jun-16 Case:00901003 Commenting previous functionality.
      //  myDate = vNextFiscalStartDate.addDays(Integer.valueOf(vConfig.N_th_Day_of_Fiscal_Month__c-1));
        /* changed cron statement to 5 P.M IST by padmaja  14/12/2015*/        
        String sch = '0 0 15 '+myDate.Day()+' '+myDate.Month()+' ? '+myDate.Year();
        //THE CRON STATEMENT FORMED HERE IS IN FORMAT SEC/MIN/HH/DAY_OF_MONTH/MONTH/DAY_OF_WEEK/YEAR
        //0 0 0 XX XX ? XXXX
        Cls_SchedularDNDJDASchedular m = new Cls_SchedularDNDJDASchedular();
        if(!Test.isRunningTest())
            system.schedule('DND JDA PART AND ACCOUNT FORECAST AT '+System.NOW(), sch, m); 
    }
}