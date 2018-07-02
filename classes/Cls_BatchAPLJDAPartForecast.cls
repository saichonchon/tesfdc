/***********************************************************************************************************************
      Name : Cls_BatchAPLJDAPartForecast
       Org : C2S
       Test class : Cls_BatchAPLJDAPartForecast_Test
       Code coverage: 89%
========================================================================================================================
   Summary : A batch class to create records in INFRA Part Forecast object for APL from APL_Sales_Forecast__c
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR       DATE       DETAIL                               User Story #   


***********************************************************************************************************************/
global class Cls_BatchAPLJDAPartForecast implements Database.Batchable<sObject>, Database.Stateful{
    /* _______________________________________ GLOBAL VARIABLE DECLARATION ___________________________________________*/    
    global String strQuery;
    /* Added global variables for Filter forecast data by padmaja  14/12/2015*/
    global String Jdanotin;
    global Date DStartDate;
    global Date DEndDate;

    //global Set<Id> vRTSetToAdd = new Set<Id>();
    //global Set<Id> vEngOppRTSet = new Set<Id>();
    //global Set<Id> vSalesOppRTSet = new Set<Id>();
    //global Map<String, Decimal> vConversionMap = new Map<String, Decimal>();
    //global Map<String, Decimal> vAmountMap = new Map<String, Decimal>();
    //global Map<String, List<Decimal>> vMapAccountToAmt = new Map<String, List<Decimal>>();
    public static map<String, Decimal> map_isoCode_exchangeRate = new map<String, Decimal>();
    global Cls_BatchAPLJDAPartForecast(){
        
        INFRA_JDA_Settings__c vConfig = INFRA_JDA_Settings__c.getValues('APL');

        
    }
    
    //STANDARD QueryLocator METHOD TO EXECUTE THE QUERY IN CONSTRUCTOR
    global Database.QueryLocator start(Database.BatchableContext BC){
        set<string> setFiscalYearQuarter = new set<string>();
        list<Period> lstYearPeriod = [SELECT StartDate, EndDate FROM Period where Enddate > :Date.Today() and type = :'Year' order by startdate limit 3];
        list<Period> lstCurrPeriod = [SELECT StartDate, EndDate, NUMBER FROM Period where Enddate > :Date.Today() and type = :'Quarter' order by startdate limit 7];
        
        for(Period oPeriod :lstCurrPeriod)
        {
            string FiscalYear = string.ValueOf(oPeriod.Enddate.year());
            for(Period oPeriodYear :lstYearPeriod )
            {
                If(oPeriod.EndDate <= oPeriodYear.EndDate && oPeriod.EndDate > oPeriodYear.StartDate)
                    FiscalYear = string.ValueOf(oPeriodYear.EndDate.year());
            }
            setFiscalYearQuarter.add(FiscalYear  + '-0' + string.ValueOf(oPeriod.Number));
        }
        set<string> SetType1 = new set<string>{'GPL','Other CBC2'};
        set<string> SetType2 = new set<string>{'Relay Product Code'};
        strQuery = 'Select id, Type__c, GPL__c, GPL__r.name, GPL__r.CBC1__c, CBC2__c, CBC2__r.name, PRODUCT_CDE__c, RSM_Price__c, CurrencyIsoCode, Fiscal_YEAR_Quarter__c, RSM_Forecast__c, RSM_Quantity__c, Customer__r.APL_AM_Display_Name__c, Customer__r.Company_Organization_ID__c, Customer__r.Account_Number_JDA_bridge_format__c, Customer__r.SALES_TERRITORY_CDE__c '+
                    +' From APL_Sales_Forecast__c '+
                    +' Where customer__r.Account_Number_JDA_bridge_format__c != null AND ((Type__c IN :SetType1 AND Customer__r.STATDESC__c = \'Active\' AND Customer__r.SALES_TERRITORY_CDE__c <> \'\' AND (RSM_Forecast__c >= 0.01 OR RSM_Forecast__c <= -0.01)) OR (Customer__r.Relay_Specialist_Territory_Code__c <> \'\' AND Type__c IN :SetType2 AND Customer__r.STATDESC__c = \'Active\' AND (RSM_Quantity__c > 0.01 OR RSM_Quantity__c <= -0.01))) AND (Customer__r.Territory_L1_Code__c = \'102260\' OR Customer__r.SALES_TERRITORY_CDE__c = \'A000666\') AND Fiscal_YEAR_Quarter__c IN :setFiscalYearQuarter';

//                    +' Where ((Type__c IN :SetType1 AND Fiscal_YEAR_Quarter__c NOT IN :setfiscalYearQuarter AND Customer__r.STATDESC__c = \'Active\' AND Customer__r.SALES_TERRITORY_CDE__c <> \'\' AND (RSM_Forecast__c >= 0.01 OR RSM_Forecast__c <= -0.01)) OR (Customer__r.Relay_Specialist_Territory_Code__c <> \'\' AND Type__c IN :SetType1 AND Fiscal_YEAR_Quarter__c NOT IN :setfiscalYearQuarter AND Customer__r.STATDESC__c = \'Active\' AND (RSM_Quantity__c > 0.01 OR RSM_Quantity__c <= -0.01))) AND (Customer__r.Territory_L1_Code__c = \'102260\' OR Customer__r.SALES_TERRITORY_CDE__c = \'A000666\') AND Fiscal_Date__c > :dStartDate AND Fiscal_Date__c < :dEndDate';  
        if(Test.isRunningTest())
            strQuery += ' LIMIT 10';
        return Database.getQueryLocator(strQuery);
        
    }

    //ACTUAL LOGIC TO CREATE FORECAST RECORDS
    global void execute(Database.BatchableContext BC, List<APL_Sales_Forecast__c> pPartForecastList)
    {
            map<string, APL_CBC_setting__c> mapAPL_CBC_setting = APL_CBC_setting__c.getAll();
            List<INFRA.ForecastData.PartData> forecastList = new List<INFRA.ForecastData.PartData>();
            getExchangeRate();
            for(APL_Sales_Forecast__c partForecast: pPartForecastList)
            {
                INFRA.ForecastData.PartData forecastHeader1 = new INFRA.ForecastData.PartData();
                forecastHeader1.region = 'NA';
                forecastHeader1.dataStream = INFRA.ForecastUtil.DataStream.SalesDemandForecast;
                forecastHeader1.site = partForecast.Customer__r.Company_Organization_ID__c;
                forecastHeader1.siteIndicator = INFRA.ForecastUtil.SiteIndicator.LegalOrg;
                forecastHeader1.customer = partForecast.Customer__r.Account_Number_JDA_bridge_format__c;
                forecastHeader1.customerIndicator = INFRA.ForecastUtil.CustomerIndicator.SoldTo;
                forecastHeader1.territoryCode = partForecast.Customer__r.SALES_TERRITORY_CDE__c;
                forecastHeader1.territoryIndicator = INFRA.ForecastUtil.TerritoryIndicator.DD7;
                forecastHeader1.businessUnitForecastSourceId = partForecast.id;
                
                List<INFRA.ForecastDetail.PartDetail> forecastDetailList1 = new List<INFRA.ForecastDetail.PartDetail>();
                INFRA.ForecastDetail.PartDetail forecastDetail1 = new INFRA.ForecastDetail.PartDetail();
                
                if(partForecast.Type__c == 'GPL' && !mapAPL_CBC_setting.containsKey(partForecast.GPL__r.CBC1__c))
                {
                    forecastHeader1.productCode = partForecast.GPL__r.name;
                    forecastHeader1.productHierarchyIndicator =  INFRA.ForecastUtil.ProductHierarchyIndicator.GPL;
                    forecastDetail1.ATTRIB_NM_1 = '1';
                }
                else if(partForecast.Type__c == 'GPL' && mapAPL_CBC_setting.containsKey(partForecast.GPL__r.CBC1__c))
                {
                    forecastHeader1.productCode = partForecast.GPL__r.CBC1__c;
                    forecastHeader1.productHierarchyIndicator =  INFRA.ForecastUtil.ProductHierarchyIndicator.CBC1;
                    forecastDetail1.ATTRIB_NM_1 = '3';
                }
                else if(partForecast.Type__c == 'Relay Product Code')
                {
                    forecastHeader1.productCode = partForecast.PRODUCT_CDE__c;
                    forecastHeader1.productHierarchyIndicator =  INFRA.ForecastUtil.ProductHierarchyIndicator.Product;
                    forecastDetail1.ATTRIB_NM_1 = '2';
                    forecastDetail1.ATTRIB_NM_3 = string.valueOf(getexchangedAmount(partForecast.RSM_Price__c, partForecast.CurrencyIsoCode));
                }
                else if(partForecast.Type__c == 'Other CBC2')
                {
                    forecastHeader1.productCode = '';
                    forecastHeader1.productHierarchyIndicator =  INFRA.ForecastUtil.ProductHierarchyIndicator.OtherBU;
                    forecastDetail1.ATTRIB_NM_1 = '4';
                }
                
                if(partForecast.Fiscal_YEAR_Quarter__c != null)
                    forecastDetail1.period = partForecast.Fiscal_YEAR_Quarter__c.replace('-0', 'Q') ;
                forecastDetail1.periodIndicator = INFRA.ForecastUtil.ForecastPeriodIndicator.Quaterly;
                
                forecastDetail1.amount = getexchangedAmount(partForecast.RSM_Forecast__c != null? partForecast.RSM_Forecast__c : 0, partForecast.CurrencyIsoCode);
                forecastDetail1.quantity = integer.valueOf(partForecast.RSM_Quantity__c != null? partForecast.RSM_Quantity__c :0);
                forecastDetail1.ATTRIB_NM_2 = partForecast.Customer__r.APL_AM_Display_Name__c;
                
                forecastDetailList1.add(forecastDetail1);
                forecastHeader1.forecastDetail = forecastDetailList1;
                forecastList.Add(forecastHeader1);
            }
            
            INFRA.ForecastPublishManagerClass clsObj = new INFRA.ForecastPublishManagerClass('APL');
            clsObj.publishPartForecast(forecastList);                                  
    }


    global void finish(Database.BatchableContext BC) 
    {

        INFRA_JDA_Settings__c vConfig = INFRA_JDA_Settings__c.getValues('APL');
        Date sysDate = Date.Today();
        Date vManSchDate =  sysDate.addDays((Integer)vConfig.CountingForward__c );
        Date myDate;
        Period vNextPeriod = [SELECT StartDate, EndDate FROM Period WHERE Type = 'Month' AND StartDate <=: vManSchDate AND EndDate >=: vManSchDate];
        myDate =vNextPeriod.EndDate.addDays((Integer)vConfig.CountingBack__c);
        String sch = '0 0 17 '+myDate.Day()+' '+myDate.Month()+' ? '+myDate.Year();
        if(!Test.isRunningTest())
            system.schedule('APL JDA PART AND ACCOUNT FORECAST AT '+System.NOW(), sch, new Cls_SchedularAPLJDAPartForecast());
    }
    public static Decimal getexchangedAmount(Decimal Amount, string strFromISOCode)
    {
        if(map_isoCode_exchangeRate.containsKey(strFromISOCode) && map_isoCode_exchangeRate.get(strFromISOCode) != null && map_isoCode_exchangeRate.get(strFromISOCode) != 0)
            return (Amount / map_isoCode_exchangeRate.get(strFromISOCode));
        return Amount;
    }
    @TestVisible
    private static void getExchangeRate()
    {
        if(map_isoCode_exchangeRate == null || map_isoCode_exchangeRate.size() == 0)
        {
            map_isoCode_exchangeRate = new map<String, Decimal>();
            for(CurrencyType ct : [SELECT  IsActive, IsCorporate, CreatedById, CreatedDate, IsoCode, Id, DecimalPlaces, LastModifiedById, LastModifiedDate, SystemModstamp, ConversionRate  from CurrencyType])
                map_isoCode_exchangeRate.put(ct.IsoCode, ct.ConversionRate);
        }
    }
}