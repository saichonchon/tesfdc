/***********************************************************************************************************************
      Name : Cls_BatchDNDJDAPartForecast
Test Class Name : Cls_BatchDNDJDAAccountForecast_Test
       Org : C2S
 Copyright : © 2015 TE Connectivity 
========================================================================================================================
   Summary : A batch class to create records in INFRA Part Forecast object
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR       DATE       DETAIL                               User Story #   
Prabhanjan Nandyala  06-Aug-15  To Send DND forecast to JDA
Padmaja Devineni     14-Dec-15  Enhancement
Rajendra Shahane	 22/08/2016	 Enhancement for DND forecast project to sync 18 month data with JDA
***********************************************************************************************************************/
global class Cls_BatchDNDJDAPartForecast implements Database.Batchable<sObject>, Database.Stateful{
    /* _______________________________________ GLOBAL VARIABLE DECLARATION ___________________________________________*/    
    global String vQuery;
    /* Added global variables for Filter forecast data by padmaja  14/12/2015*/
    global String Jdanotin;
    global String strGiants;
    global Date vFiscalStartDate;
    global Date fiscalMonth1Date;
    global Date fiscalMonth12Date;
    //global Set<Id> vRTSetToAdd = new Set<Id>();
    //global Set<Id> vEngOppRTSet = new Set<Id>();
    //global Set<Id> vSalesOppRTSet = new Set<Id>();
    //global Map<String, Decimal> vConversionMap = new Map<String, Decimal>();
    //global Map<String, Decimal> vAmountMap = new Map<String, Decimal>();
    //global Map<String, List<Decimal>> vMapAccountToAmt = new Map<String, List<Decimal>>();
    
    global Cls_BatchDNDJDAPartForecast(){
        
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
        
        //END - Comments and Changes By Sandeep (12/07/2015)
        /* Added JDA Type and Fiscal Year Filter criteria for forecast data by padmaja  14/12/2015*/
        Jdanotin ='6';
            vQuery = 'Select Billing_Region__c, Sold_To_Number__c, OEM_Code__c,Fiscal_Date__c, OEM__c, '+
                    +'Part_Number__c, Sale_Territory__c, ID, Fiscal_Year_Plus_Month__c, '+
                    +'Forecast__c, Quantity__c, Price__c, Type__c,JDA_Type__c From CSD_Sales_Forecast__c '+
                    +'Where Part_Number__c != null and JDA_Type__c != null and JDA_Type__c !=: Jdanotin '+
                    +'and Fiscal_Date__c >=:fiscalMonth1Date '           
                    +'and Fiscal_Date__c <:fiscalMonth12Date';     
       
            if(Test.isRunningTest())
                vQuery += ' LIMIT 10';
        
    }
    
    //STANDARD QueryLocator METHOD TO EXECUTE THE QUERY IN CONSTRUCTOR
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(vQuery);
        
    }

    //ACTUAL LOGIC TO CREATE FORECAST RECORDS
    global void execute(Database.BatchableContext BC, List<CSD_Sales_Forecast__c> pPartForecastList){
           
        //FOR FORECAST
            List<INFRA.ForecastData.PartData> forecastList = new List<INFRA.ForecastData.PartData>();
            for(CSD_Sales_Forecast__c partForecast: pPartForecastList){
                //FOR PARENT FORECAST DATA
                INFRA.ForecastData.PartData forecastHeader1  = new INFRA.ForecastData.PartData();
                IF(partForecast.Billing_Region__c=='AMERICAS')      forecastHeader1.region = '1001';
                ELSE IF(partForecast.Billing_Region__c=='EMEA')     forecastHeader1.region = '1002';
                //ELSE IF(partForecast.Billing_Region__c=='JAPAN')    forecastHeader1.region = '1003';
                //ELSE IF(partForecast.Billing_Region__c=='KOREA')    forecastHeader1.region = '1004'; 
                //ELSE IF(partForecast.Billing_Region__c=='ASIA EXCL JP&KR') forecastHeader1.region = '1005';
                ELSE IF(partForecast.Billing_Region__c=='ASIA') forecastHeader1.region = '1005';
                ELSE    forecastHeader1.region = '1099';
                    
                forecastHeader1.dataStream                   = INFRA.ForecastUtil.DataStream.SalesDemandForecast;
             
                forecastHeader1.customer                     = partForecast.OEM_Code__c; 
                //IF(partForecast.OEM_Code__c==null||partForecast.OEM_Code__c=='')    forecastHeader1.customerIndicator            = INFRA.ForecastUtil.CustomerIndicator.SoldTo;
                IF(partForecast.OEM__c == null)    forecastHeader1.customerIndicator  = INFRA.ForecastUtil.CustomerIndicator.SoldTo;
                ELSE    forecastHeader1.customerIndicator            = INFRA.ForecastUtil.CustomerIndicator.SoldToWithOEM;
                 
                forecastHeader1.productHierarchyIndicator    = INFRA.ForecastUtil.ProductHierarchyIndicator.Part;
                forecastHeader1.productCode                  = partForecast.Part_Number__c;
                forecastHeader1.businessUnitForecastSourceId = partForecast.ID;
                string soldtonum = partForecast.Sold_To_Number__c;
                if(soldtonum.length()>=4)  forecastHeader1.site = soldtonum.substring(0,4); 
                forecastHeader1.siteIndicator                = INFRA.ForecastUtil.SiteIndicator.LegalOrg;
                
                if (partForecast.Sale_Territory__c != null && !string.isNotEmpty(partForecast.Sale_Territory__c))
                {
                    forecastHeader1.territoryIndicator           = INFRA.ForecastUtil.TerritoryIndicator.DD7;
                    forecastHeader1.territoryCode                = partForecast.Sale_Territory__c;
                }

                //FOR DETAIL Record
                List<INFRA.ForecastDetail.PartDetail> forecastDetailList1 = new List<INFRA.ForecastDetail.PartDetail>();
                INFRA.ForecastDetail.PartDetail forecastDetail1 = new INFRA.ForecastDetail.PartDetail();
                if(partForecast.Forecast__c != NULL)	forecastDetail1.amount = partForecast.Forecast__c.setScale(4);
                forecastDetail1.quantity = Integer.valueOf(partForecast.Quantity__c);
                forecastDetail1.period = partForecast.Fiscal_Year_Plus_Month__c;
                forecastDetail1.periodIndicator = INFRA.ForecastUtil.ForecastPeriodIndicator.Monthly;
                if(partForecast.Price__c<>null)  forecastDetail1.ATTRIB_NM_1 = partForecast.Price__c.setScale(4).toPlainString();
                forecastDetail1.ATTRIB_NM_2= partForecast.JDA_Type__c;
                forecastDetailList1.add(forecastDetail1);
                forecastHeader1.forecastDetail = forecastDetailList1;
                forecastList.Add(forecastHeader1);
            }
            //THIS IS THE PUBLISHER CLASS INITIALIZATION WITH CUSTOM SETTING NAME - 'DND'
            INFRA.ForecastPublishManagerClass clsObj = new INFRA.ForecastPublishManagerClass('DND');
            //invoke the Part publish function and pass the forecast list
            clsObj.publishPartForecast(forecastList);                                  

    }


    global void finish(Database.BatchableContext BC) {

        Cls_BatchDNDJDAAccountForecast vBatch = new Cls_BatchDNDJDAAccountForecast();
        Id batchInstanceId;
        if(!Test.isRunningTest())   batchInstanceId = Database.executeBatch(vBatch, 20); 
        else    batchInstanceId = Database.executeBatch(vBatch, 100); 
        
    }
}