/**********************************************************************
Name:  ADMNPForecastSummary_Controller_Test
Copyright © 2017
======================================================
======================================================
Purpose: Test Class for ADMNPForecastSummary_Controller
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR                DATE             DETAIL                  Description
1.0        Altaf ur Rahman      10/12/2017      INITIAL DEVELOPMENT
***********************************************************************/

@isTest
public class ADMNPForecastSummary_Controller_Test {
    
    Public static testmethod void ADMforecasting_NonPortfolio(){    
       
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();        
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();        
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();        
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ADMTestDataFactory.getADM_CustomSetting();
        ADMTestDataFactory.getADM_CustomSetting1();                
        
        String CurrentUserid = UserInfo.getUserId();        
        
       Profile p = [SELECT Id FROM Profile WHERE Name='ADM Standard User']; 
        User u = new User( ADM_User_Type__c= 'Distribution Manager',Te_Network_Id__c='TE3241861', Alias = 'ktest', Email='testings.test@te.com', 
                          UserName='testings.test@te.com.admdev',EmailEncodingKey='UTF-8', LastName='Testing', 
                          LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles');    
        
        System.runAs(u) {            
            ADM_Forecast_Page_Customization__c fpc = new ADM_Forecast_Page_Customization__c();
            fpc.Name='CommentWidthandColorCoding';
            fpc.Color_Coding__c = '#FF0000';
            fpc.Comment_Width__c='180';
            fpc.GuiFcstDay__c='82';
            insert fpc;             
            
        Date todaydate = System.Today();
        FiscalYearSettings currentfisobj = [select id,name,EndDate from FiscalYearSettings WHERE StartDate <=: todaydate and EndDate>=: todaydate];
        Integer currentyr = Integer.valueOf(currentfisobj.name);
        Integer nextyr= Integer.valueOf(Integer.ValueOf(currentyr)+1);
        Integer pastyr= Integer.valueOf(Integer.ValueOf(currentyr)-1);
        Integer pPastyr= Integer.valueOf(Integer.ValueOf(currentyr)-2);   

            
            List<account> acc = new List<account>();  
            acc = ADMTestDataFactory.accountDetails('system.now().millisecond()+math.round(math.random()*10000)', '12345', 'Musterstadt','CN', 'OEM','072','77777' );
            
            system.debug('acc--> '+acc);
            
            List<Forecast__c> forecastListRec = new List<Forecast__c>();
             Forecast__c frCast = new Forecast__c();
            
            frCast= ADMTestDataFactory.createForecastObj2('TestForecastExtid001','12345','BA','CAM','TestComments','Australia','GPL Level',null,'Australiaregion','Non-Portfolio',acc[0].id); 
            
            system.debug('frCast==='+frCast);
            
             Forecast__c frCast2 = new Forecast__c();
            
            frCast2= ADMTestDataFactory.createForecastObj2('TestForecastExtid006','12345','BA','CAM','TestComments2','Australia','GPL Level',null,'Australiaregion','Non-Portfolio',acc[0].id); 
            
            system.debug('frCast22==='+frCast2);
            
             Forecast__c frCast3 = new Forecast__c();
            
            frCast3= ADMTestDataFactory.createForecastObj2('TestForecastExtid007','12345','BA','CAM','TestComments3','Australia','GPL Level',null,'Australiaregion','Non-Portfolio',acc[0].id); 
            
            system.debug('frCast333==='+frCast3);
            
            forecastListRec.add(frCast);
            forecastListRec.add(frCast2);
            forecastListRec.add(frCast3);
            
            
            List<MonthlyActualSales__x> monthlyActualSalesList = new List<MonthlyActualSales__x>();    
            
            
            MonthlyActualSales__x mockedRequest = new MonthlyActualSales__x(
                SFDC_EXTERNAL_ID__c='TestForecastExtid001-'+currentyr,
            FISCAL_YEAR_ID__c=currentyr,M1_AMOUNT__c = 5,M2_AMOUNT__c = 5,M3_AMOUNT__c = 5,M4_AMOUNT__c = 5,M5_AMOUNT__c = 5,M6_AMOUNT__c = 5,M7_AMOUNT__c = 5
            ,M8_AMOUNT__c = 5,M9_AMOUNT__c = 5,M10_AMOUNT__c = 5,M11_AMOUNT__c = null,M12_AMOUNT__c = 5
            
            );
            MonthlyActualSales__x mockedRequest2 = new MonthlyActualSales__x(
                SFDC_EXTERNAL_ID__c='TestForecastExtid001-'+pastyr,
            FISCAL_YEAR_ID__c=currentyr,M1_AMOUNT__c = 5,M2_AMOUNT__c = 5,M3_AMOUNT__c = 5,M4_AMOUNT__c = 5,M5_AMOUNT__c = 5,M6_AMOUNT__c = 5,M7_AMOUNT__c = 5
            ,M8_AMOUNT__c = 5,M9_AMOUNT__c = 5,M10_AMOUNT__c = 5,M11_AMOUNT__c = null,M12_AMOUNT__c = 5
            
            );
            
            MonthlyActualSales__x mockedRequest3 = new MonthlyActualSales__x(
            SFDC_EXTERNAL_ID__c='TestForecastExtid006-'+currentyr,
            FISCAL_YEAR_ID__c=currentyr,M1_AMOUNT__c = 5,M2_AMOUNT__c = 5,M3_AMOUNT__c = 5,M4_AMOUNT__c = 5,M5_AMOUNT__c = 5,M6_AMOUNT__c = 5,M7_AMOUNT__c = 5
            ,M8_AMOUNT__c = 5,M9_AMOUNT__c = 5,M10_AMOUNT__c = 5,M11_AMOUNT__c = null,M12_AMOUNT__c = 5
            
            );
            MonthlyActualSales__x mockedRequest4 = new MonthlyActualSales__x(
                SFDC_EXTERNAL_ID__c='TestForecastExtid006-'+pastyr,
            FISCAL_YEAR_ID__c=currentyr,M1_AMOUNT__c = 5,M2_AMOUNT__c = 5,M3_AMOUNT__c = 5,M4_AMOUNT__c = 5,M5_AMOUNT__c = 5,M6_AMOUNT__c = 5,M7_AMOUNT__c = 5
            ,M8_AMOUNT__c = 5,M9_AMOUNT__c = 5,M10_AMOUNT__c = 5,M11_AMOUNT__c = null,M12_AMOUNT__c = 5
            
            );
                 MonthlyActualSales__x mockedRequest11 = new MonthlyActualSales__x(
                SFDC_EXTERNAL_ID__c='TestForecastExtid006-'+pPastyr,
            FISCAL_YEAR_ID__c=currentyr,M1_AMOUNT__c = 5,M2_AMOUNT__c = 5,M3_AMOUNT__c = 5,M4_AMOUNT__c = 5,M5_AMOUNT__c = 5,M6_AMOUNT__c = 5,M7_AMOUNT__c = 5
            ,M8_AMOUNT__c = 5,M9_AMOUNT__c = 5,M10_AMOUNT__c = 5,M11_AMOUNT__c = null,M12_AMOUNT__c = 5
            
            );
            
            
            monthlyActualSalesList.add(mockedRequest);  
            monthlyActualSalesList.add(mockedRequest2);
            monthlyActualSalesList.add(mockedRequest3);
            monthlyActualSalesList.add(mockedRequest4);
            monthlyActualSalesList.add(mockedRequest11);
            system.debug('monthlyActualSalesList--> '+monthlyActualSalesList);
            Set<String> forecastexids = new Set<String>();
            
            forecastexids.add(mockedRequest2.SFDC_EXTERNAL_ID__c+'-'+pastyr);
            forecastexids.add(mockedRequest3.SFDC_EXTERNAL_ID__c+'-'+currentyr);
            system.debug('forecastexids--> '+forecastexids);
            
            ADMEntryScreenHelper.mockedRequests.add(mockedRequest);
            ADMEntryScreenHelper.mockedRequests.add(mockedRequest2);
            ADMEntryScreenHelper.mockedRequests.add(mockedRequest3);
            ADMEntryScreenHelper.mockedRequests.add(mockedRequest4);
            ADMEntryScreenHelper.mockedRequests.add(mockedRequest11);
            List<MonthlyActualSales__x> request = ADMEntryScreenHelper.getExMonthlyActualSales(forecastexids);
            
            system.debug('request--> '+request);          
            
            //Mock test data for Daily actual sales for external object DailyActualSales__x
            List<DailyActualSales__x> dailyActualSalesList = new List<DailyActualSales__x>();    
            
            
            DailyActualSales__x mockedRequest5 = new DailyActualSales__x(
                SFDC_EXTERNAL_ID__c='TestForecastExtid001',
                YEAR_ID__c=currentyr,MONTH_ID__c = 2, MTD_AMOUNT__c = 11
                
            );
            DailyActualSales__x mockedRequest6 = new DailyActualSales__x(
                SFDC_EXTERNAL_ID__c='TestForecastExtid001',
                YEAR_ID__c=currentyr,MONTH_ID__c = 1, MTD_AMOUNT__c = 13
                
            );
            
            dailyActualSalesList.add(mockedRequest5);  
            dailyActualSalesList.add(mockedRequest6);  
            system.debug('monthlyActualSalesList--> '+dailyActualSalesList);
            Set<String> forecastexidsDaily = new Set<String>();
            
            forecastexidsDaily.add(mockedRequest5.SFDC_EXTERNAL_ID__c);
            
            system.debug('forecastexidsDaily--> '+forecastexidsDaily);
            
            ADMEntryScreenHelper.mockedRequests2.add(mockedRequest5);
            ADMEntryScreenHelper.mockedRequests2.add(mockedRequest6);
            List<DailyActualSales__x> request2 = ADMEntryScreenHelper.getExForecastDailyActual(forecastexidsDaily);
            
            system.debug('request2 daily for--> '+request2);  
            
            List<Forecast__c> frCastList = new List<Forecast__c>();
            
            frCastList =  ADMTestDataFactory.forecastObjList('TestForecastExtid002','CON','BA','CAM','TestComments','Australia','GPL Level',null,'Australiaregion','Non-Portfolio');
            
            
            List<Forecast_Detail__c> frcDetailsListForecast = new List<Forecast_Detail__c>();
            
            frcDetailsListForecast=ADMTestDataFactory.createForCastDetails(frCast.id,'Auto-Forecast');
            system.debug('frcDetailsListForecast---> '+frcDetailsListForecast);
            
            List<Forecast_Detail__c> frcDetailsListActual = new List<Forecast_Detail__c>();
            
            frcDetailsListActual=ADMTestDataFactory.createForCastDetails(frCast.id,'Actuals');
            
            List<Forecast_Detail__c> frcDetailsListGuidance = new List<Forecast_Detail__c>();
            
            frcDetailsListGuidance=ADMTestDataFactory.createForCastDetails(frCast.id,'Guidance Forecast');   
            
            List<Forecast_Detail__c> frcDetailsListAll = new List<Forecast_Detail__c>();
            
            frcDetailsListAll.addAll(frcDetailsListForecast);
            frcDetailsListAll.addAll(frcDetailsListActual);
            frcDetailsListAll.addAll(frcDetailsListGuidance);
            
                List<Forecast_Detail__c> frcDetailsListForecast2 = new List<Forecast_Detail__c>();
            
            frcDetailsListForecast2=ADMTestDataFactory.createForCastDetails(frCast3.id,'Auto-Forecast');
            system.debug('frcDetailsListForecast222---> '+frcDetailsListForecast2);
            frcDetailsListAll.addAll(frcDetailsListForecast2);
            
            string OEM = 'OEM';
            
            System.currentPageReference().getParameters().put('selectedOptions','OEM');
            System.currentPageReference().getParameters().put('ProfitCentre',null);
            System.currentPageReference().getParameters().put('SoldToCust',acc[0].id);
            System.currentPageReference().getParameters().put('SoldToCustNum',null);
            System.currentPageReference().getParameters().put('WWCNum',null);
            System.currentPageReference().getParameters().put('WWCustmN',null);
            System.currentPageReference().getParameters().put('Dstr',null);
            System.currentPageReference().getParameters().put('Reg',null);
            System.currentPageReference().getParameters().put('Userid',null);        
            System.currentPageReference().getParameters().put('cbc3',null);
            System.currentPageReference().getParameters().put('nonPortfolioCount','200'); 
            System.currentPageReference().getParameters().put('PaginationRecords','15');                                                      
            
            frCastList.add(frCast);
            system.debug('frCastList========>> '+frCastList);
            
            ADMNPForecastSummary_Controller ADMControl = new ADMNPForecastSummary_Controller();                              
            
            ADMControl.Comment = 'testData';
            ADMControl.usertype = 'Sales Engineer';            
            ADMControl.forecastList = forecastListRec;
            ADMControl.typeofaccount = 'OEM';
            
            
            ADMNPForecastSummary_Controller.ForecastWrapper forecastWrap = new ADMNPForecastSummary_Controller.ForecastWrapper();
            forecastWrap.forecast=frCast;
            List<Forecast_Detail__c> foreFD = ADMTestDataFactory.createForCastDetails(frCast.id,'Forecast');
            forecastWrap.FCurrObj=foreFD[0];
            forecastWrap.FNextObj=foreFD[1];
            forecastWrap.latestComment='newcommt';
            forecastWrap.LastmodifiedByName='kart';
            forecastWrap.LastModifiedDate=System.today();
            forecastWrap.ForecastCrecId='12';
            forecastWrap.ForecastCrecName='Reckar';
            forecastWrap.CBC2='12345';
            forecastWrap.CBC3='12121';
            forecastWrap.CBC4='24242';
            forecastWrap.Region='Australia';
            forecastWrap.District='Japan';
            forecastWrap.RegSalesMngr='Salesmgr';
            forecastWrap.DistSalesMngr='Dstmgr';
            forecastWrap.SalesEng='SalesEng';
            forecastWrap.DistMngr='DistMngr';
            forecastWrap.TEUserID='1234';        
            forecastWrap.forecastType='typefc';
            
            ADMNPForecastSummary_Controller.YOYWrapper yoywrap = new  ADMNPForecastSummary_Controller.YOYWrapper();
            ADMNPForecastSummary_Controller.ActualWrapper   actualWrap = new ADMNPForecastSummary_Controller.ActualWrapper(); 
            ADMNPForecastSummary_Controller.GuidenceWrapper guidenceWrap = new ADMNPForecastSummary_Controller.GuidenceWrapper();        
            
            actualWrap.forecast=frCast;
            List<Forecast_Detail__c> actFD = ADMTestDataFactory.createForCastDetails(frCast.id,'Actuals');
            actualWrap.ACurrObj=actFD[0];
            actualWrap.ANextObj=actFD[1];
            actualWrap.CBC2='12345';
            actualWrap.CBC3='12121';
            actualWrap.CBC4='24242';
            actualWrap.Region='Australia';
            actualWrap.District='Japan';
            actualWrap.RegSalesMngr='Salesmgr';
            actualWrap.DistSalesMngr='Dstmgr';
            actualWrap.SalesEng='SalesEng';
            actualWrap.DistMngr='DistMngr';
            actualWrap.TEUserID='1234';
            forecastWrap.relatedFDetailRecords = new List<ADMNPForecastSummary_Controller.ActualWrapper>();
            forecastWrap.relatedFDetailRecords.add(actualWrap);
            
            guidenceWrap.forecast=frCast;
            List<Forecast_Detail__c> guiFD = ADMTestDataFactory.createForCastDetails(frCast.id,'Guidance Forecast');
            guidenceWrap.GCurrObj=guiFD[0];
            guidenceWrap.GNextObj=guiFD[1];
            guidenceWrap.CBC2='12345';
            guidenceWrap.CBC3='12121';
            guidenceWrap.CBC4='24242';
            guidenceWrap.Region='Australia';
            guidenceWrap.District='Japan';
            guidenceWrap.RegSalesMngr='Salesmgr';
            guidenceWrap.DistSalesMngr='Dstmgr';
            guidenceWrap.SalesEng='SalesEng';
            guidenceWrap.DistMngr='DistMngr';
            guidenceWrap.TEUserID='1234';
            forecastWrap.relatedFDetailRecords1 = new List<ADMNPForecastSummary_Controller.GuidenceWrapper>();
            forecastWrap.relatedFDetailRecords1.add(guidenceWrap);
            
            yoywrap.forecast=frCast;
            List<Forecast_Detail__c> yoyFD = ADMTestDataFactory.createForCastDetails(frCast.id,'YoY Variance');
            yoywrap.YoYCurrObj=yoyFD[0];
            yoywrap.YoYNextObj=yoyFD[1];
            yoywrap.CBC2='12345';
            yoywrap.CBC3='12121';
            yoywrap.CBC4='24242';
            yoywrap.Region='Australia';
            yoywrap.District='Japan';
            yoywrap.RegSalesMngr='Salesmgr';
            yoywrap.DistSalesMngr='Dstmgr';
            yoywrap.SalesEng='SalesEng';
            yoywrap.DistMngr='DistMngr';
            yoywrap.TEUserID='1234';
            forecastWrap.relatedFDetailRecords2 = new List<ADMNPForecastSummary_Controller.YOYWrapper>();
            forecastWrap.relatedFDetailRecords2.add(yoywrap);
            
            
            ADMControl.forecastLineItems = new List<ADMNPForecastSummary_Controller.ForecastWrapper>();
            ADMControl.forecastLineItems.add(forecastWrap);
            
               
            Note nott = new Note();
            nott.Body = 'Test';
            nott.ParentId = frCast.Id;
            nott.Title = 'Test';
            insert nott; 
            string createdName = nott.CreatedBy.Name;
            string dat = string.valueof(nott.CreatedDate);  
            
            Test.startTest();
            
            ADMControl.Exit();
            ADMControl.Back();            
            ADMControl.NonPortfolioForecast();
         
            ADMControl.editforecastId = frCast.Id;
            ADMControl.forecastName = 'new test comments';
            ADMControl.addComment();             
            
            Test.stopTest();          
        }
    }
    Public static testmethod void ADMforecasting_NonPortfolio2(){    
        
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();        
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();        
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();        
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ADMTestDataFactory.getADM_CustomSetting();
        ADMTestDataFactory.getADM_CustomSetting1();        
        
        Date todaydate = System.Today();
        FiscalYearSettings currentfisobj = [select id,name,EndDate from FiscalYearSettings WHERE StartDate <=: todaydate and EndDate>=: todaydate];
        
        Integer currentyr = Integer.valueOf(currentfisobj.name);
        Integer nextyr= Integer.valueOf(Integer.ValueOf(currentyr)+1);
        Integer pastyr= Integer.valueOf(Integer.ValueOf(currentyr)-1);
        Integer pPastyr= Integer.valueOf(Integer.ValueOf(currentyr)-2);
        
        String CurrentUserid = UserInfo.getUserId();
        
        
       Profile p = [SELECT Id FROM Profile WHERE Name='ADM Standard User']; 
        User u = new User( ADM_User_Type__c= 'Distribution Manager',Te_Network_Id__c='TE3241861', Alias = 'ktest', Email='testings.test@te.com', 
                          UserName='testings.test@te.com.admdev',EmailEncodingKey='UTF-8', LastName='Testing', 
                          LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles');    
        
        
        System.runAs(u) {
            
            ADM_Forecast_Page_Customization__c fpc = new ADM_Forecast_Page_Customization__c();
            fpc.Name='CommentWidthandColorCoding';
            fpc.Color_Coding__c = '#FF0000';
            fpc.Comment_Width__c='180';
            fpc.GuiFcstDay__c='82';
            insert fpc;
            
            
            List<account> acc = new List<account>();  
            acc = ADMTestDataFactory.accountDetails('system.now().millisecond()+math.round(math.random()*10000)', '123456', 'Musterstadt','CN', 'Distributor','072','77771' );
            
            system.debug('acc222222222--> '+acc);
            
             Forecast__c frCast = new Forecast__c();
            
            frCast= ADMTestDataFactory.createForecastObj2('TestForecastExtid003','CON','BA','CAM','TestComments','Australia','Part Level',null,'Australiaregion','Non-Portfolio',acc[0].id); 
            
            system.debug('frCast222222222==='+frCast);            
          
            
            //Mock test data for Daily actual sales for external object DailyActualSales__x
            List<DailyActualSales__x> dailyActualSalesList = new List<DailyActualSales__x>();    
            
            
            DailyActualSales__x mockedRequest3 = new DailyActualSales__x(
                SFDC_EXTERNAL_ID__c='TestForecastExtid003',
                YEAR_ID__c=pastyr,MONTH_ID__c = 12, MTD_AMOUNT__c = 11
                
            );
            DailyActualSales__x mockedRequest4 = new DailyActualSales__x(
                SFDC_EXTERNAL_ID__c='TestForecastExtid003',
                YEAR_ID__c=currentyr,MONTH_ID__c = 1, MTD_AMOUNT__c = 13
                
            );
            
            dailyActualSalesList.add(mockedRequest3);  
            dailyActualSalesList.add(mockedRequest4);  
            system.debug('dailyActualSalesList222222222--> '+dailyActualSalesList);
            Set<String> forecastexidsDaily = new Set<String>();
            
            forecastexidsDaily.add(mockedRequest3.SFDC_EXTERNAL_ID__c);
            
            system.debug('forecastexidsDaily222222--> '+forecastexidsDaily);
            
            ADMEntryScreenHelper.mockedRequests2.add(mockedRequest3);
            ADMEntryScreenHelper.mockedRequests2.add(mockedRequest4);
            List<DailyActualSales__x> request2 = ADMEntryScreenHelper.getExForecastDailyActual(forecastexidsDaily);
            
            system.debug('request2 daily for22222222--> '+request2);   
            
            List<Forecast__c> frCastList = new List<Forecast__c>();
            
            frCastList =  ADMTestDataFactory.forecastObjList('TestForecastExtid002','CON','BA','CAM','TestComments','Australia','Part Level',null,'Australiaregion','Non-Portfolio');
                       
            List<Forecast_Detail__c> frcDetailsListGuidance = new List<Forecast_Detail__c>();
            
            frcDetailsListGuidance=ADMTestDataFactory.createForCastDetails(frCast.id,'Guidance Forecast');   
            
            List<Forecast_Detail__c> frcDetailsListAll = new List<Forecast_Detail__c>();
         
            frcDetailsListAll.addAll(frcDetailsListGuidance);
            
            
            string OEM = 'OEM';
            
            System.currentPageReference().getParameters().put('selectedOptions','Distributor');
            System.currentPageReference().getParameters().put('ProfitCentre',null);
            System.currentPageReference().getParameters().put('SoldToCust',acc[0].id);
            System.currentPageReference().getParameters().put('SoldToCustNum',null);
            System.currentPageReference().getParameters().put('WWCNum',null);
            System.currentPageReference().getParameters().put('WWCustmN',null);
            System.currentPageReference().getParameters().put('Dstr',null);
            System.currentPageReference().getParameters().put('Reg',null);
            System.currentPageReference().getParameters().put('Userid',null);        
            System.currentPageReference().getParameters().put('cbc3',null);
            System.currentPageReference().getParameters().put('nonPortfolioCount','200');      
            System.currentPageReference().getParameters().put('PaginationRecords','15');                                                             
            
            frCastList.add(frCast);
            system.debug('frCastList22222222========>> '+frCastList);
            
            ADMNPForecastSummary_Controller ADMControl = new ADMNPForecastSummary_Controller();
           
            ADMControl.Comment = 'testData';
            ADMControl.usertype = 'Sales Engineer Manager';            
            ADMControl.forecastList = frCastList;
            
            
            ADMNPForecastSummary_Controller.ForecastWrapper forecastWrap = new ADMNPForecastSummary_Controller.ForecastWrapper();
            forecastWrap.forecast=frCast;
            List<Forecast_Detail__c> foreFD = ADMTestDataFactory.createForCastDetails(frCast.id,'Forecast');
            forecastWrap.FCurrObj=foreFD[0];
            forecastWrap.FNextObj=foreFD[1];
            forecastWrap.latestComment='newcommt';
            forecastWrap.LastmodifiedByName='kart';
            forecastWrap.LastModifiedDate=System.today();
            forecastWrap.ForecastCrecId='12';
            forecastWrap.ForecastCrecName='Reckar';
            forecastWrap.CBC2='12345';
            forecastWrap.CBC3='12121';
            forecastWrap.CBC4='24242';
            forecastWrap.Region='Australia';
            forecastWrap.District='Japan';
            forecastWrap.RegSalesMngr='Salesmgr';
            forecastWrap.DistSalesMngr='Dstmgr';
            forecastWrap.SalesEng='SalesEng';
            forecastWrap.DistMngr='DistMngr';
            forecastWrap.TEUserID='1234';        
            forecastWrap.forecastType='typefc';
            
            ADMNPForecastSummary_Controller.YOYWrapper yoywrap = new  ADMNPForecastSummary_Controller.YOYWrapper();
            ADMNPForecastSummary_Controller.ActualWrapper   actualWrap = new ADMNPForecastSummary_Controller.ActualWrapper(); 
            ADMNPForecastSummary_Controller.GuidenceWrapper guidenceWrap = new ADMNPForecastSummary_Controller.GuidenceWrapper();        
            
            actualWrap.forecast=frCast;
            List<Forecast_Detail__c> actFD = ADMTestDataFactory.createForCastDetails(frCast.id,'Actuals');
            actualWrap.ACurrObj=actFD[0];
            actualWrap.ANextObj=actFD[1];
            actualWrap.CBC2='12345';
            actualWrap.CBC3='12121';
            actualWrap.CBC4='24242';
            actualWrap.Region='Australia';
            actualWrap.District='Japan';
            actualWrap.RegSalesMngr='Salesmgr';
            actualWrap.DistSalesMngr='Dstmgr';
            actualWrap.SalesEng='SalesEng';
            actualWrap.DistMngr='DistMngr';
            actualWrap.TEUserID='1234';
            forecastWrap.relatedFDetailRecords = new List<ADMNPForecastSummary_Controller.ActualWrapper>();
            forecastWrap.relatedFDetailRecords.add(actualWrap);
            
            guidenceWrap.forecast=frCast;
            List<Forecast_Detail__c> guiFD = ADMTestDataFactory.createForCastDetails(frCast.id,'Guidance Forecast');
            guidenceWrap.GCurrObj=guiFD[0];
            guidenceWrap.GNextObj=guiFD[1];
            guidenceWrap.CBC2='12345';
            guidenceWrap.CBC3='12121';
            guidenceWrap.CBC4='24242';
            guidenceWrap.Region='Australia';
            guidenceWrap.District='Japan';
            guidenceWrap.RegSalesMngr='Salesmgr';
            guidenceWrap.DistSalesMngr='Dstmgr';
            guidenceWrap.SalesEng='SalesEng';
            guidenceWrap.DistMngr='DistMngr';
            guidenceWrap.TEUserID='1234';
            forecastWrap.relatedFDetailRecords1 = new List<ADMNPForecastSummary_Controller.GuidenceWrapper>();
            forecastWrap.relatedFDetailRecords1.add(guidenceWrap);
            
            yoywrap.forecast=frCast;
            List<Forecast_Detail__c> yoyFD = ADMTestDataFactory.createForCastDetails(frCast.id,'YoY Variance');
            yoywrap.YoYCurrObj=yoyFD[0];
            yoywrap.YoYNextObj=yoyFD[1];
            yoywrap.CBC2='12345';
            yoywrap.CBC3='12121';
            yoywrap.CBC4='24242';
            yoywrap.Region='Australia';
            yoywrap.District='Japan';
            yoywrap.RegSalesMngr='Salesmgr';
            yoywrap.DistSalesMngr='Dstmgr';
            yoywrap.SalesEng='SalesEng';
            yoywrap.DistMngr='DistMngr';
            yoywrap.TEUserID='1234';
            forecastWrap.relatedFDetailRecords2 = new List<ADMNPForecastSummary_Controller.YOYWrapper>();
            forecastWrap.relatedFDetailRecords2.add(yoywrap);
            
            ADMControl.currentuser = u;
            ADMControl.total_size = 100;          
            ADMControl.counter = 0;
            ADMControl.list_size = 20;
            ADMControl.NonPortfolio = 'Non-Portfolio';
            ADMControl.forecastLineItems = new List<ADMNPForecastSummary_Controller.ForecastWrapper>();
            ADMControl.forecastLineItems.add(forecastWrap);
            
            Test.startTest();
            
            Note nott = new Note();
            nott.Body = 'Test';
            nott.ParentId = frCast.Id;
            nott.Title = 'Test';
            insert nott; 
            string createdName = nott.CreatedBy.Name;
            string dat = string.valueof(nott.CreatedDate);    
            
            
            ADMControl.Exit();
            ADMControl.Back(); 
            ADMControl.NonPortfolioForecast();
            
 
            
            ADMControl.editforecastId = frCast.Id;
            ADMControl.forecastName = 'new test comments';
            ADMControl.addComment();
            
            ADMControl.viewforecastId = frCast.Id;        
            
            Test.stopTest();          
        }
        }
    
}