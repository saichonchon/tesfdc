/**********************************************************************
Name:  ADMYOYForecastDetails_Batch_Test
Copyright © 2017
======================================================
======================================================
Purpose: Test Class for ADMYOYForecastDetails_Batch
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR           DATE                  DETAIL                      Description
=============================================================================================================================
1.0         Altaf          11/06/2017         INITIAL DEVELOPMENT        Test Class for ADMYOYForecastDetails_Batch
*****************************************************************************************************************************/
@isTest
public class ADMYOYForecastDetails_Batch_Test{    
    
    @TestSetup
    public static void testDataSetup() 
    {
        
        Date todaydate = System.Today();
        FiscalYearSettings currentfisobj = [select id,name,EndDate from FiscalYearSettings WHERE StartDate <=: todaydate and EndDate>=: todaydate];
        Integer currentyr = Integer.valueOf(currentfisobj.name);
        Integer nextyr= Integer.valueOf(Integer.ValueOf(currentyr)+1);
        Integer pastyr= Integer.valueOf(Integer.ValueOf(currentyr)-1);
        Integer pPastyr= Integer.valueOf(Integer.ValueOf(currentyr)-2);
        
        //Create Forecast Record with type Portfolio
        Forecast__c frCast = new Forecast__c();
        
        frCast= ADMTestDataFactory.createForecastObj('TestForecastExtid001','CON','BA','CAM','TestComments','Australia','Part Level',null,'Australiaregion','Non-Portfolio'); 
        
        //Create Forecast Detail records
        List<Forecast_Detail__c> frcDetailsList = new List<Forecast_Detail__c>();
        
        frcDetailsList=ADMTestDataFactory.createForCastDetails(frCast.id,'Auto-Forecast');
        
        ADM_Forecast_Page_Customization__c GuiFcstDay = new  ADM_Forecast_Page_Customization__c();
        GuiFcstDay.Name ='CommentWidthandColorCoding';
        System.debug(' GuiFcstDay.Name...'+ GuiFcstDay.Name);
        GuiFcstDay.GuiFcstDay__c='15';
        GuiFcstDay.Color_Coding__c='#008000';
        GuiFcstDay.Comment_Width__c='150';
        insert GuiFcstDay;
        
        ADM_Custom_Setting__c forecastType = new  ADM_Custom_Setting__c();
        forecastType.Name ='Forecast_TypeBatch';
        forecastType.Value__c = 'NON-Portfolio';
        insert forecastType;
        
        List<MonthlyActualSales__x> monthlyActualSalesList = new List<MonthlyActualSales__x>();         
        
        MonthlyActualSales__x mockedRequest = new MonthlyActualSales__x(
            SFDC_EXTERNAL_ID__c='TestForecastExtid001-'+currentyr,
            FISCAL_YEAR_ID__c=currentyr,M1_AMOUNT__c = 5,M2_AMOUNT__c = 5,M3_AMOUNT__c = 5,M4_AMOUNT__c = 5,M5_AMOUNT__c = 5,M6_AMOUNT__c = 5,M7_AMOUNT__c = 5
            ,M8_AMOUNT__c = 5,M9_AMOUNT__c = 5,M10_AMOUNT__c = 5,M11_AMOUNT__c = null,M12_AMOUNT__c = 5
            
        );
        MonthlyActualSales__x mockedRequest2 = new MonthlyActualSales__x(
            SFDC_EXTERNAL_ID__c='TestForecastExtid001-'+pastyr,
            FISCAL_YEAR_ID__c=pastyr,M1_AMOUNT__c = 6,M2_AMOUNT__c = null,M3_AMOUNT__c = 6,M4_AMOUNT__c = 6,M5_AMOUNT__c = 6,M6_AMOUNT__c = 6,M7_AMOUNT__c = 5
            ,M8_AMOUNT__c = 6,M9_AMOUNT__c =6,M10_AMOUNT__c = 6,M11_AMOUNT__c = 6,M12_AMOUNT__c = 6
            
        );
        
        monthlyActualSalesList.add(mockedRequest);  
        monthlyActualSalesList.add(mockedRequest2);
        
        Set<String> forecastexids = new Set<String>();        
        forecastexids.add(mockedRequest.SFDC_EXTERNAL_ID__c);        
        system.debug('forecastexids--> '+forecastexids);        
        
        ADMYOYForecastDetails_Batch.mockedRequests.add(mockedRequest);
        ADMYOYForecastDetails_Batch.mockedRequests.add(mockedRequest2); 
        
    }
    
    //If there is no forecast detail record
    static testmethod void batchGuiFcstTest() {   
        Date todaydate = System.Today();
        FiscalYearSettings currentfisobj = [select id,name,EndDate from FiscalYearSettings WHERE StartDate <=: todaydate and EndDate>=: todaydate];
        Integer currentyr = Integer.valueOf(currentfisobj.name);
        Integer nextyr= Integer.valueOf(Integer.ValueOf(currentyr)+1);
        Integer pastyr= Integer.valueOf(Integer.ValueOf(currentyr)-1);
        Integer pPastyr= Integer.valueOf(Integer.ValueOf(currentyr)-2);
        
        ADM_Custom_Setting__c forecastType = new  ADM_Custom_Setting__c();
        forecastType.Name ='Forecast_TypeBatch';
        forecastType.Value__c = 'NON-Portfolio';
        insert forecastType;
        //Create Forecast Record with type Portfolio
        Forecast__c frCast = new Forecast__c();
        
        frCast= ADMTestDataFactory.createForecastObj('TestForecastExtid002','CON','BA','CAM','TestComments','Australia','Part Level',null,'Australiaregion','Non-Portfolio'); 
        
        List<MonthlyActualSales__x> monthlyActualSalesList = new List<MonthlyActualSales__x>();         
        
        MonthlyActualSales__x mockedRequest = new MonthlyActualSales__x(
           SFDC_EXTERNAL_ID__c='TestForecastExtid001-'+currentyr,
            FISCAL_YEAR_ID__c=currentyr,M1_AMOUNT__c = 5,M2_AMOUNT__c = 5,M3_AMOUNT__c = 5,M4_AMOUNT__c = 5,M5_AMOUNT__c = 5,M6_AMOUNT__c = 5,M7_AMOUNT__c = 5
            ,M8_AMOUNT__c = 5,M9_AMOUNT__c = 5,M10_AMOUNT__c = 5,M11_AMOUNT__c = null,M12_AMOUNT__c = 5
            
        );
        MonthlyActualSales__x mockedRequest2 = new MonthlyActualSales__x(
            SFDC_EXTERNAL_ID__c='TestForecastExtid001-'+pastyr,
            FISCAL_YEAR_ID__c=pastyr,M1_AMOUNT__c = 6,M2_AMOUNT__c = null,M3_AMOUNT__c = 6,M4_AMOUNT__c = 6,M5_AMOUNT__c = 6,M6_AMOUNT__c = 6,M7_AMOUNT__c = 5
            ,M8_AMOUNT__c = 6,M9_AMOUNT__c =6,M10_AMOUNT__c = 6,M11_AMOUNT__c = 6,M12_AMOUNT__c = 6
            
        );
        
        monthlyActualSalesList.add(mockedRequest);  
        monthlyActualSalesList.add(mockedRequest2);
        
        Set<String> forecastexids = new Set<String>();        
        forecastexids.add(mockedRequest.SFDC_EXTERNAL_ID__c);        
        system.debug('forecastexids--> '+forecastexids);        
        
        ADMYOYForecastDetails_Batch.mockedRequests.add(mockedRequest);
        ADMYOYForecastDetails_Batch.mockedRequests.add(mockedRequest2);     
      
        Test.startTest();
        ADMYOYForecastDetails_Batch BatchGuiFcst  = new  ADMYOYForecastDetails_Batch();
        Database.executeBatch(BatchGuiFcst);
        Test.stopTest();
    }
    
    //For forecast detail record for Current Fiscal Year
    Public static testmethod void batchGuiFcstQrtr1(){
        
        Date todaydate = System.Today();
        FiscalYearSettings currentfisobj = [select id,name,EndDate from FiscalYearSettings WHERE StartDate <=: todaydate and EndDate>=: todaydate];
        Integer currentyr = Integer.valueOf(currentfisobj.name);
        Integer nextyr= Integer.valueOf(Integer.ValueOf(currentyr)+1);
        Integer pastyr= Integer.valueOf(Integer.ValueOf(currentyr)-1);
        Integer pPastyr= Integer.valueOf(Integer.ValueOf(currentyr)-2);
        
        ADM_Custom_Setting__c forecastType = new  ADM_Custom_Setting__c();
        forecastType.Name ='Forecast_TypeBatch';
        forecastType.Value__c = 'NON-Portfolio';
        insert forecastType;
        
        Forecast__c frCast= [ select Id,Name, External_ID__c from Forecast__c where External_ID__c=: 'TestForecastExtid001' ];
        List<MonthlyActualSales__x> monthlyActualSalesList = new List<MonthlyActualSales__x>();         
        
        
        MonthlyActualSales__x mockedRequest2 = new MonthlyActualSales__x(
            SFDC_EXTERNAL_ID__c='TestForecastExtid001-'+pastyr,
            FISCAL_YEAR_ID__c=pastyr,M1_AMOUNT__c = 6,M2_AMOUNT__c = null,M3_AMOUNT__c = 6,M4_AMOUNT__c = 6,M5_AMOUNT__c = 6,M6_AMOUNT__c = 6,M7_AMOUNT__c = 5
            ,M8_AMOUNT__c = 6,M9_AMOUNT__c =6,M10_AMOUNT__c = 6,M11_AMOUNT__c = 6,M12_AMOUNT__c = 6
            
        );
        
        monthlyActualSalesList.add(mockedRequest2);
        
        Set<String> forecastexids = new Set<String>();        
        forecastexids.add(mockedRequest2.SFDC_EXTERNAL_ID__c);        
        system.debug('forecastexids--> '+forecastexids);        
        
        ADMYOYForecastDetails_Batch.mockedRequests.add(mockedRequest2); 
     
        //Create Forecast Detail records of Type YOY Forecast
        Forecast_Detail__c YOYFcstdet = new Forecast_Detail__c();
        YOYFcstdet.Type__c='YoY Variance';        
        YOYFcstdet.M1__c=0;
        YOYFcstdet.M2__c=0;
        YOYFcstdet.M3__c=0;        
        YOYFcstdet.M4__c=0;
        YOYFcstdet.M5__c=0;
        YOYFcstdet.M6__c=0;        
        YOYFcstdet.M8__c=0;
        YOYFcstdet.M9__c=0;
        YOYFcstdet.M10__c=0;
        YOYFcstdet.M11__c=0;
        YOYFcstdet.M12__c=0;        
        YOYFcstdet.Parent_Forecast__c=frCast.id;
        YOYFcstdet.Period__c=String.valueOf(currentyr);
        
        insert YOYFcstdet;
        
        Test.startTest();
        ADMYOYForecastDetails_Batch BatchGuiFcst  = new  ADMYOYForecastDetails_Batch ();       
        Database.executeBatch(BatchGuiFcst);
        Test.stopTest();
        
    }
    
    //For forecast detail record for Next Fiscal Year
    Public static testmethod void batchGuiFcstQrtr2(){
        Date todaydate = System.Today();
        FiscalYearSettings currentfisobj = [select id,name,EndDate from FiscalYearSettings WHERE StartDate <=: todaydate and EndDate>=: todaydate];
        Integer currentyr = Integer.valueOf(currentfisobj.name);
        Integer nextyr= Integer.valueOf(Integer.ValueOf(currentyr)+1);
        Integer pastyr= Integer.valueOf(Integer.ValueOf(currentyr)-1);
        Integer pPastyr= Integer.valueOf(Integer.ValueOf(currentyr)-2);
        
        ADM_Custom_Setting__c forecastType = new  ADM_Custom_Setting__c();
        forecastType.Name ='Forecast_TypeBatch';
        forecastType.Value__c = 'NON-Portfolio';
        insert forecastType;
        
        Forecast__c frCast= [ select Id,Name, External_ID__c from Forecast__c where External_ID__c=: 'TestForecastExtid001' ];
        
        List<MonthlyActualSales__x> monthlyActualSalesList = new List<MonthlyActualSales__x>();                 
        MonthlyActualSales__x mockedRequest = new MonthlyActualSales__x(
        	SFDC_EXTERNAL_ID__c='TestForecastExtid001-'+currentyr,
            FISCAL_YEAR_ID__c=currentyr,M1_AMOUNT__c = 5,M2_AMOUNT__c = 5,M3_AMOUNT__c = 5,M4_AMOUNT__c = 5,M5_AMOUNT__c = 5,M6_AMOUNT__c = 5,M7_AMOUNT__c = 5
            ,M8_AMOUNT__c = 5,M9_AMOUNT__c = 5,M10_AMOUNT__c = 5,M11_AMOUNT__c = null,M12_AMOUNT__c = 5
            
        );             
        monthlyActualSalesList.add(mockedRequest);     
        
        Set<String> forecastexids = new Set<String>();        
        forecastexids.add(mockedRequest.SFDC_EXTERNAL_ID__c);        
        system.debug('forecastexids--> '+forecastexids);        
        
        ADMYOYForecastDetails_Batch.mockedRequests.add(mockedRequest);     
       
        //Create Forecast Detail records of Type YOY Forecast
        Forecast_Detail__c YOYFcstdet = new Forecast_Detail__c();
        YOYFcstdet.Type__c='YoY Variance';        
        YOYFcstdet.M1__c=0;
        YOYFcstdet.M2__c=0;
        YOYFcstdet.M3__c=0;
        YOYFcstdet.M4__c=0;        
        YOYFcstdet.M6__c=0;
        YOYFcstdet.M7__c=0;
        YOYFcstdet.M8__c=0;
        YOYFcstdet.M9__c=0;
        YOYFcstdet.M10__c=0;
        YOYFcstdet.M11__c=0;
        YOYFcstdet.M12__c=0;
        YOYFcstdet.Parent_Forecast__c=frCast.id;
        YOYFcstdet.Period__c=String.valueOf(nextyr);
        
        insert YOYFcstdet;
        
        Test.startTest();
        ADMYOYForecastDetails_Batch BatchGuiFcst  = new  ADMYOYForecastDetails_Batch();
        system.debug('BatchGuiFcst...'+BatchGuiFcst);
        Database.executeBatch(BatchGuiFcst);
        Test.stopTest();
        
    }
}