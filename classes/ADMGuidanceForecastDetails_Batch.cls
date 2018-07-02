/**********************************************************************
Name:  ADMGuidanceForecastDetails_Batch
Copyright © 2017
======================================================
======================================================
Purpose: ADMGuidanceForecastDetails_Batch is used for creating Forecast Detail  records of Type Guidance Forecast for Forcast
for current and next fiscal year
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR                DATE             DETAIL Description
0.1          Kartik  G           09/05/2017         INITIAL DEVELOPMENT
***********************************************************************/


global class ADMGuidanceForecastDetails_Batch implements Database.Batchable<sobject> {
    //Get Current Date and Current And Next Fiscal Year
    Date todaydate = System.Today();
    FiscalYearSettings currentfisobj = [select id,name,EndDate from FiscalYearSettings WHERE StartDate <=: todaydate and EndDate>=: todaydate];
    Private String currentyr = currentfisobj.name;
    Private String nextyr= String.valueOf(Integer.ValueOf(currentyr)+1);
    Private List<String> listyrs = new list<String>{currentyr, nextyr};
        Private String currentdate=String.valueOf(System.Today());
    
    public List<Forecast_Detail__c> GuiForecastDetaillist= new List<Forecast_Detail__c>();
    public  List<Period> Qrtrlist = new List<Period>();
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        //Fetch Forecast of Record Type ADM
        Id ForecastRecordTypeId = Schema.SObjectType.Forecast__c.getRecordTypeInfosByName().get('ADM').getRecordTypeId();  
        String stringForecastRecordTypeId ='\''+ForecastRecordTypeId+'\'';
        
        
        //Query for getting Forecast Detail record for Type Forecast and Auto-Forecast
        String query = 'select id,M1__c,M2__c,M3__c,M4__c,M5__c,M6__c,M7__c,M8__c,M9__c,M10__c,M11__c,M12__c,Parent_Forecast__c,Type__c,Period__c from Forecast_Detail__c where  Parent_Forecast__r.RecordTypeId='+ stringForecastRecordTypeId +' AND (Type__c = \'Forecast\'  OR Type__c = \'Auto-Forecast\')  AND Period__c IN :listyrs';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Forecast_Detail__c> scope){
        try{
            Map<String, Forecast_Detail__c> ForecastDetailmap = new Map<String, Forecast_Detail__c>();
            
            integer i=1;
            
            List<Id> Forecastid = new List<Id>(); 
            for(Forecast_Detail__c fd:scope){
                Forecastid.add(fd.Parent_Forecast__c);
            }
            
            //Query for getting Forecast Detail record for Type Guidance Forecast
            String Queryfd  = 'select id,M1__c,M2__c,M3__c,M4__c,M5__c,M6__c,M7__c,M8__c,M9__c,M10__c,M11__c,M12__c,Parent_Forecast__c,Period__c,Type__c from Forecast_Detail__c where Type__c= \'Guidance Forecast\' AND Parent_Forecast__c IN :Forecastid AND Period__c IN :listyrs '; 
            if (Queryfd!=null){
                GuiForecastDetaillist = Database.query(Queryfd);  
            }
            
            List<Forecast_Detail__c> upsertFdlist = new List<Forecast_Detail__c>();  
            List<Forecast_Detail__c> insertFdlist = new List<Forecast_Detail__c>();          
            
            for(Forecast_Detail__c fd : GuiForecastDetaillist)
            {                
                ForecastDetailmap.put(fd.Parent_Forecast__c+'_'+fd.Period__c, fd);               
            }
            
            //Query for getting Current Quarter of the year
            String Queryqd ='SELECT Id, QuarterLabel, StartDate, EndDate, Type, FiscalYearSettingsId ,Number FROM Period WHERE StartDate <= TODAY and EndDate>= TODAY and Type=\'Quarter\' ' ;
            if(Queryqd!=null){
                Qrtrlist = Database.query(Queryqd); 
            }
            
            //Checking if Parent Forecast contains Forecast Detail of Type Guidance Forecast else create it
            
            for(Forecast_Detail__c fd:scope)
            {
                Forecast_Detail__c obj = new Forecast_Detail__c();
                obj.clear();
                obj=ForecastDetailmap.get(fd.Parent_Forecast__c+'_'+fd.Period__c);
                
                if(obj == null)
                {   
                    //To create Forecast Detail Record of Type Guidance Forecast
                    Forecast_Detail__c newobj = new Forecast_Detail__c(); // fd.clone();
                    newobj.Type__c='Guidance Forecast';
                    
                    newobj.Parent_Forecast__c=fd.Parent_Forecast__c;
                    //Assigning values to Guidance Forecast Record
                    newobj.M1__c = fd.M1__c;
                    newobj.M2__c= fd.M2__c;
                    newobj.M3__c= fd.M3__c;
                    newobj.M4__c= fd.M4__c;
                    newobj.M5__c= fd.M5__c;
                    newobj.M6__c= fd.M6__c;
                    newobj.M7__c= fd.M7__c;
                    newobj.M8__c= fd.M8__c;
                    newobj.M9__c= fd.M9__c;
                    newobj.M10__c= fd.M10__c;
                    newobj.M11__c= fd.M11__c;
                    newobj.M12__c= fd.M12__c;
                    newobj.Period__c= fd.Period__c;
                    upsertFdlist.add(newobj); 
                }    
                // Updating values in Guidance Forecast Record based upon year and current Quarter
                else
                {
                    
                    if(fd.Period__c==currentyr)
                    {
                        if(Qrtrlist.size()>0){
                            
                            if(Qrtrlist[0].number == 1)
                            {
                                i =1;
                                
                            }
                            else if(Qrtrlist[0].number == 2)
                            {
                                i =4;
                                
                            }
                            else if(Qrtrlist[0].number == 3)
                            {
                                i =7; 
                                
                            }
                            else if(Qrtrlist[0].number == 4)
                            {
                                i =10;
                                
                            }  
                        }
                    }
                    else
                    {
                        
                        i =1;
                    }
                    
                    while(i<=12)
                    {                    
                        obj.put('M'+i +'__c', fd.get('M'+i +'__c'));                
                        i++;
                    }
                    
                    upsertFdlist.add(obj);
                }
                
            }
            //Save All forecast detail records
            
            if(upsertFdlist.size()>0)
            {
                Database.UpsertResult[] DR_Upserts = Database.upsert(upsertFdlist, false);
                ADMForecastBatch_Helper.upsertedForecastDetail(upsertFdlist, DR_Upserts);
            }
        }
        catch(Exception e){
            System.debug('errMessage' + ': ' + e.getMessage());
        }
    }
    
    
    global void finish(Database.BatchableContext BC){
        ADM_Forecast_Page_Customization__c result = ADM_Forecast_Page_Customization__c.getValues('CommentWidthandColorCoding');
        String Batchday = result.GuiFcstDay__c; 
        
        //For getting Start Date of Quarter
        String Queryqd ='SELECT Id, QuarterLabel, StartDate, EndDate, Type, FiscalYearSettingsId ,Number FROM Period WHERE StartDate <= TODAY and EndDate>= TODAY and Type=\'Quarter\' ' ;
        List<Period> Qrtrlist = Database.query(Queryqd);
        
        Date batchdate = Qrtrlist[0].EndDate;
        
        Date newbatchdate = batchdate.adddays(Integer.valueOf(Batchday));
        String sch = '0 0 8 '+newbatchdate.Day()+' '+newbatchdate.Month()+' ? '+newbatchdate.Year();
        //THE CRON STATEMENT FORMED HERE IS IN FORMAT SEC/MIN/HH/DAY_OF_MONTH/MONTH/DAY_OF_WEEK/YEAR
        //0 0 0 XX XX ? XXXX
        ADMGuidanceForecastDetails_Schedule m = new ADMGuidanceForecastDetails_Schedule();
        // Retriving the current job information from "AsyncApexJob" Object. 
        AsyncApexJob Apexjob = [SELECT Id,Status,MethodName,NumberOfErrors,JobItemsProcessed,TotalJobItems,CreatedBy.Email FROM AsyncApexJob WHERE Id =: BC.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSaveAsActivity(false);
        mail.setTargetObjectId(Userinfo.getuserId());
        mail.setSubject('ADM Guidance forecast create ' + Apexjob.Status);
        mail.setPlainTextBody('"ADMGuidanceForecastDetails_Batch "  Apex job processed '+Apexjob.TotalJobItems+' batches with '+Apexjob.NumberOfErrors+' Errors.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
        
        if(!Test.isRunningTest())
            system.schedule('ADMGuidanceForecastDetails_Schedule '+System.NOW(), sch, m); 
    } 
    
}