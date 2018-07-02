/**********************************************************************
Name:  ADMYOYForecastDetails_Batch
Copyright © 2017
======================================================
======================================================
Purpose: ADMYOYForecastDetails_Batch is used for creating Forecast Detail  records of Type YOY Forecast for Forecast
for current and next fiscal year                                                     
======================================================
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR                DATE              Description
============================================================================================================================

1.0          Altaf              11/02/2017         INITIAL DEVELOPMENT

*************************************************************************************************************************/

global class ADMYOYForecastDetails_Batch implements Database.Batchable<sobject> {
    //Get Current Date and Current And Next Fiscal Year
    Date todaydate = System.Today();
    FiscalYearSettings currentfisobj = [select id,name,EndDate from FiscalYearSettings WHERE StartDate <=: todaydate and EndDate>=: todaydate];
    Private String currentyr = currentfisobj.name;
    Private String nextyr= String.valueOf(Integer.ValueOf(currentyr)+1);
    Private String pastYear= String.valueOf(Integer.ValueOf(currentyr)-1);
    Private List<String> listyrs = new list<String>{currentyr, nextyr};    
    public ADM_Custom_Setting__c forecastType = ADM_Custom_Setting__c.getValues('Forecast_TypeBatch');    
    public String portfolioType;
    Private String forcastrecordtypeid=Schema.Sobjecttype.Forecast__c.getRecordTypeInfosByName().get('ADM').getRecordTypeId();   
    @TestVisible private static List<MonthlyActualSales__x> mockedRequests = new List<MonthlyActualSales__x>();
    
    
    global ADMYOYForecastDetails_Batch (){
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        if(forecastType != null){
            portfolioType = String.valueOf(forecastType.Value__c);
        }
        
        String forecastDetailType;        
        if(portfolioType == 'Non-Portfolio'){
            forecastDetailType = 'Auto-Forecast';
        }else{
            forecastDetailType = 'Forecast';
        }
        system.debug('forecastDetailType--> '+forecastDetailType);
        //Query for getting Forecast Detail record for Type Forecast and Auto-Forecast
        String query = 'select id, type__c, (SELECT Id, Type__c ,Period__c,Parent_Forecast__c,M1__c,M2__c,M3__c,M4__c,M5__c ,M6__c ,M7__c ,M8__c ,M9__c ,M10__c ,M11__c ,M12__c FROM Forecast_Details__r where Period__c IN :listyrs AND (Type__c = \''+forecastDetailType+'\' OR Type__c = \'YoY Variance\')), Name,External_ID__c from Forecast__c where type__c=\''+portfolioType+'\' AND RecordTypeId=\''+forcastrecordtypeid+'\'';
        system.debug('query--> '+query);
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Forecast__c> scope){
        try{
            Map<String, List<Forecast_Detail__c>> ForecastDetailmap = new Map<String, List<Forecast_Detail__c>>();
            List<Forecast_Detail__c> forecastDetailList = new List<Forecast_Detail__c>();
            Map<String,Forecast_Detail__c> AutoForecast = new Map<String,Forecast_Detail__c>(); 
            Map<String,Forecast_Detail__c> YoyVarianceForecast = new Map<String,Forecast_Detail__c>(); 
            List<Forecast_Detail__c> YOYforecastDetailList = new List<Forecast_Detail__c>();
            Forecast_Detail__c obPastActual;
            Forecast_Detail__c obCurrentActual;
            String forecastDetailType;
            forecastDetailList.clear();
            Set<String> ForecastExternalIds = new Set<String>(); 
            if(forecastType != null){
                portfolioType = String.valueOf(forecastType.Value__c);
            }
            for(Forecast__c fd:scope){
                ForecastExternalIds.add(fd.External_ID__c+'-'+pastYear);
                ForecastExternalIds.add(fd.External_ID__c+'-'+currentyr);                
                forecastDetailList.addAll(fd.Forecast_Details__r);            
            }
            system.debug('ForecastExternalId-=-> '+ForecastExternalIds);
            if(portfolioType == 'Non-Portfolio'){
                forecastDetailType = 'Auto-Forecast';
            }else{
                forecastDetailType = 'Forecast';
            }system.debug('forecastDetailType--> '+forecastDetailType);
            if(!forecastDetailList.isEmpty()){               
                for(Forecast_Detail__c fdRec : forecastDetailList){   
                    String str = fdRec.Parent_Forecast__c+'-'+fdRec.Period__c;                    
                    if(fdRec.Type__c == forecastDetailType){
                       AutoForecast.put(str,fdRec);  
                    }
                    else{
                       YoyVarianceForecast.put(str, fdRec);
                    }                    
                }
            }
            
            List<MonthlyActualSales__x> ExtMonthlyEactualualSales = new List<MonthlyActualSales__x>();
            Map<String, MonthlyActualSales__x> extActual= new Map<String,MonthlyActualSales__x >();
            
            ExtMonthlyEactualualSales = [SELECT FISCAL_YEAR_ID__c,M1_AMOUNT__c,M2_AMOUNT__c,M3_AMOUNT__c,M4_AMOUNT__c,M5_AMOUNT__c,M6_AMOUNT__c,M7_AMOUNT__c,M8_AMOUNT__c,M9_AMOUNT__c,M10_AMOUNT__c,M11_AMOUNT__c,M12_AMOUNT__c,SFDC_EXTERNAL_ID__c,YEARLYTOT_AMOUNT__c FROM MonthlyActualSales__x WHERE SFDC_EXTERNAL_ID__c IN : ForecastExternalIds];
            system.debug('ExtMonthlyEactualualSales--> '+ExtMonthlyEactualualSales);
 
            if(Test.isRunningTest()){                      
                ExtMonthlyEactualualSales = (!mockedRequests.isEmpty()) ? mockedRequests : [SELECT FISCAL_YEAR_ID__c,M1_AMOUNT__c,M2_AMOUNT__c,M3_AMOUNT__c,M4_AMOUNT__c,M5_AMOUNT__c,M6_AMOUNT__c,M7_AMOUNT__c,M8_AMOUNT__c,M9_AMOUNT__c,M10_AMOUNT__c,M11_AMOUNT__c,M12_AMOUNT__c,SFDC_EXTERNAL_ID__c,YEARLYTOT_AMOUNT__c FROM MonthlyActualSales__x WHERE SFDC_EXTERNAL_ID__c IN :ForecastExternalIds];
            }            
            if(!ExtMonthlyEactualualSales.isEmpty())
            {
                for(MonthlyActualSales__x actualRecord:ExtMonthlyEactualualSales)
                {                 
                    extActual.put(actualRecord.SFDC_EXTERNAL_ID__c,actualRecord);
                }
            }
            
            for(Forecast__c f:scope){
                
                MonthlyActualSales__x  Eactual = new MonthlyActualSales__x();              
                obPastActual = new Forecast_Detail__c();
                obCurrentActual = new Forecast_Detail__c();
                Forecast_Detail__c   obcurrentAutoForecast = new Forecast_Detail__c();
                Forecast_Detail__c   obNextAutoForecast = new Forecast_Detail__c();
                Forecast_Detail__c   YOYCurrentFDRecord;
                Forecast_Detail__c   YOYNextFDRecord;
                String currentYearForecast = f.Id+'-'+currentyr;
                String nextYearForecast = f.Id+'-'+nextyr;
                
                if(!extActual.isEmpty() || !AutoForecast.isEmpty()){      
                    
                    //Creation of YOY current year records for NON-Portfolio                       
                    obcurrentAutoForecast = AutoForecast.get(f.Id+'-'+currentyr);
                    Eactual = extActual.get(f.External_Id__c+ '-' + pastYear );
                    YOYCurrentFDRecord = YoyVarianceForecast.get(f.Id+'-'+currentyr);
                    if(YOYCurrentFDRecord == null){
                        YOYCurrentFDRecord = new Forecast_Detail__c();                        
                        YOYCurrentFDRecord.Parent_Forecast__c=f.Id;
                        YOYCurrentFDRecord.Type__c='YoY Variance';
                        YOYCurrentFDRecord.Period__c=currentyr;
                    }
                    for(integer j=1; j<13; j++){
                        
                        Decimal ActualPast = 0;
                        if(Eactual != Null) {
                        ActualPast = (Eactual.get('M'+j +'_AMOUNT__c') == null)?0:(Decimal)Eactual.get('M'+j +'_AMOUNT__c');
                        }
                        
                        Decimal ForecastCurrent = 0;
                        if(obcurrentAutoForecast != null) {
                        ForecastCurrent =(obcurrentAutoForecast.get('M'+j +'__c') == null)?0:(Decimal)obcurrentAutoForecast.get('M'+j +'__c');
                        }
                        
                        Decimal monthTotal = ForecastCurrent - ActualPast;
                        system.debug('monthTotal--> '+monthTotal+' ForecastCurrent--> '+ForecastCurrent+' ActualPast--> '+ActualPast);
                        YOYCurrentFDRecord.put('M'+j +'__c',monthTotal);                                          
                    }                                     
                    
                    //Creation of YOY next year records for NON-Portfolio                    
                    Eactual = new MonthlyActualSales__x();                                        
                    Eactual = extActual.get(f.External_Id__c+ '-' + currentyr);
                    obNextAutoForecast = AutoForecast.get(f.Id+'-'+nextyr); 
                    YOYNextFDRecord = YoyVarianceForecast.get(f.Id+'-'+nextyr);
                    if(YOYNextFDRecord == null){
                        YOYNextFDRecord = new Forecast_Detail__c();
                        YOYNextFDRecord.Parent_Forecast__c=f.Id;
                        YOYNextFDRecord.Type__c='YoY Variance';
                        YOYNextFDRecord.Period__c=nextyr;
                    }
                    System.Debug('EactualNext :'+Eactual);
                    
                    for(integer j=1; j<13; j++){
                        Decimal ActualCurrent = 0;
                        if(Eactual != Null) {
                        ActualCurrent = (Eactual.get('M'+j +'_AMOUNT__c') == null)?0:(Decimal)Eactual.get('M'+j +'_AMOUNT__c');
                        }
                        
                        Decimal ForecastNext = 0;
                        if(obNextAutoForecast != null) {
                        ForecastNext =(obNextAutoForecast.get('M'+j +'__c') == null)?0:(Decimal)obNextAutoForecast.get('M'+j +'__c');
                        }
                        
                        Decimal monthTotal = ForecastNext - ActualCurrent;
                        
                        YOYNextFDRecord.put('M'+j +'__c',monthTotal);                     
                    }                    
                }                
                YOYforecastDetailList.add(YOYCurrentFDRecord);
                YOYforecastDetailList.add(YOYNextFDRecord);                
            } 
            system.debug('YOYforecastDetailList--> '+YOYforecastDetailList);
            
            //Save All forecast detail records            
            if(YOYforecastDetailList.size()>0)
            {
                Database.UpsertResult[] DR_Upserts = Database.upsert(YOYforecastDetailList, false);           
                ADMForecastBatch_Helper.upsertedForecastDetail(YOYforecastDetailList, DR_Upserts);
            }            
        }
        catch(Exception e){
            System.debug('errMessage' + ': ' + e.getMessage());
        }
    }    
    
    global void finish(Database.BatchableContext BC){
        // Retriving the current job information from "AsyncApexJob" Object. 
        AsyncApexJob Apexjob = [SELECT Id,Status,MethodName,NumberOfErrors,JobItemsProcessed,TotalJobItems,CreatedBy.Email FROM AsyncApexJob WHERE Id =: BC.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSaveAsActivity(false);
        mail.setTargetObjectId(Userinfo.getuserId());
        mail.setSubject('ADM YOY batch job ' + Apexjob.Status);
        mail.setPlainTextBody('"ADMYOYForecastDetails_Batch "  Apex job processed '+Apexjob.TotalJobItems+' batches with '+Apexjob.NumberOfErrors+' Errors.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
        
        /*ADM_Forecast_Page_Customization__c result = ADM_Forecast_Page_Customization__c.getValues('CommentWidthandColorCoding');
        String Batchday = result.GuiFcstDay__c;         
        
        Date newbatchdate = batchdate.adddays(Integer.valueOf(Batchday));
        String sch = '0 0 8 '+newbatchdate.Day()+' '+newbatchdate.Month()+' ? '+newbatchdate.Year();
        //THE CRON STATEMENT FORMED HERE IS IN FORMAT SEC/MIN/HH/DAY_OF_MONTH/MONTH/DAY_OF_WEEK/YEAR
        //0 0 0 XX XX ? XXXX
        ADMYOYForecastDetails_Schedule m = new ADMYOYForecastDetails_Schedule();        
        if(!Test.isRunningTest())
        system.schedule('ADMYOYForecastDetails_Schedule '+System.NOW(), sch, m); */
    }     
    
}