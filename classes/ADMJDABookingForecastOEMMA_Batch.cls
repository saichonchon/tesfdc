/**********************************************************************
Name: ADMJDABookingForecastOEMMA_Batch
Copyright © 2017
==========================================================================================================
==========================================================================================================
Purpose: ADMJDABookingForecast_Batch push Forecast details records with type as OEM
and Market Adjustment to INFRA Managed Package                                                        
======================================================
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR               DATE             DETAIL Description
0.1          Vaibhav  M           10/11/2017       INITIAL DEVELOPMENT
***********************************************************************/
global class ADMJDABookingForecastOEMMA_Batch implements Database.Batchable<sObject> {

Date todayDate = System.Today();
  
String currentYear;
String nextYear;
String distyForecastLevel;
String oemForecastLevel;
Integer currentMonth;
Map<String, String> rgmap;
Id ForecastRecordTypeId;
String stringForecastRecordTypeId;


global ADMJDABookingForecastOEMMA_Batch(){
    List<ADM_Region__c> Regionmap = ADM_Region__c.getall().values();
    
    rgmap= new Map<String, String>();
    for(ADM_Region__c singlerg :Regionmap){
        rgmap.put(singlerg.Region_Value__c, singlerg.name);
       }
       
    ForecastRecordTypeId = Schema.SObjectType.Forecast__c.getRecordTypeInfosByName().get('ADM').getRecordTypeId(); 
    stringForecastRecordTypeId ='\''+ForecastRecordTypeId+'\'';
     
    /*Query to fetch current year*/   
    FiscalYearSettings currentfisobj = [select id,name from FiscalYearSettings WHERE StartDate <=: todayDate and EndDate>=: todayDate];
    currentYear = currentfisobj.name;
    nextYear = String.valueOf(Integer.ValueOf(currentfisobj.name)+1);
    
    LIST<period> listperiodcurr = [SELECT StartDate, EndDate FROM Period WHERE type='Month'  AND FiscalYearSettingsId =:currentfisobj.id order by StartDate];
    Integer p=0;
    
    for(Period periodmonth: listperiodcurr)
    {
        p++;
        if(periodmonth.StartDate<=todayDate && periodmonth.EndDate>=todayDate)
        {
            currentMonth=p;        
            break;
        }
    }
    
    //fetch disty for check not equal in soql and get rest types
    distyForecastLevel = 'CBC3 Level';                
    ADM_Custom_Setting__c distySetting = ADM_Custom_Setting__c.getValues('ADM_DISTYForecastLevel');
    if(distySetting != null){
        distyForecastLevel = distySetting.Value__c;
    }
    
    oemForecastLevel = 'GPL Level';
    ADM_Custom_Setting__c oemSetting = ADM_Custom_Setting__c.getValues('ADM_OEMForecastLevel');
    if(oemSetting != null){
        oEMForecastLevel = oemSetting.Value__c;
    }
}

global Database.QueryLocator start(Database.BatchableContext BC){
     
    /*fetch forecast detail for oem, marketing adjustment*/    
    String  query = 'SELECT Id,Name,Type__c,Forecast_Level__c,CBC3__c,Region__c,GPL__r.Name,Accountid__r.LAYER2_ORGANIZATION_SHORT_NM__c,Accountid__r.Account_Number_JDA_bridge_format__c,Accountid__r.DD1_Industry_Business_Code__c FROM Forecast__c where (RecordTypeId='+ stringForecastRecordTypeId +' and Forecast_Level__c = \''+ oEMForecastLevel +'\' and type__C in (\'Portfolio\',\'Non-Portfolio\')) OR (RecordTypeId='+ stringForecastRecordTypeId +' and Forecast_Level__c = \''+distyForecastLevel+'\' and type__C in (\'Market Adjustment\'))';
    return Database.getQueryLocator(query);
}

global void execute(Database.BatchableContext BC, List<Forecast__c> scope){
 set<string> Setyrs =new set<string>{currentYear,nextYear};
 Set<id> scopeforecastids=new Set<id>();
 for (Forecast__c objf : scope)
  {
      scopeforecastids.add(objf.id);
  }
 
 
 system.debug('scope--'+scope);
 system.debug('scopesize--'+scope.size());
 String logrdid='';
 try{
      Map<String, List<Forecast_Detail__c>> mapfd= new Map<String, List<Forecast_Detail__c>>();
      List <Forecast_Detail__c> fdlist= [Select Id,Parent_Forecast__c,Name,Total__c,Type__c ,Period__c,M1__c,M2__c,M3__c,M4__c,M5__c ,M6__c ,M7__c ,M8__c ,M9__c ,M10__c ,M11__c ,M12__c from Forecast_Detail__c where Parent_Forecast__r.RecordTypeId=: ForecastRecordTypeId and Parent_Forecast__r.type__C in ('Portfolio','Non-Portfolio','Market Adjustment') and type__c in ('forecast','Auto-Forecast') and Period__c in: Setyrs and Parent_Forecast__c in: scopeforecastids];
      System.debug('fdlist'+fdlist);
      if(fdlist.size() > 0){
      for(Forecast_Detail__c singlefd : fdlist)
      {
           if(mapfd.containsKey(String.Valueof(singlefd.Parent_Forecast__c))){              
                   mapfd.get(String.Valueof(singlefd.Parent_Forecast__c)).add(singlefd);}      
           else{
                   mapfd.put(String.Valueof(singlefd.Parent_Forecast__c),new list<Forecast_Detail__c>{singlefd});}
       } }     
      //Collection of Part Forecast. 
      List<INFRA.ForecastData.PartData> forecastList = new List<INFRA.ForecastData.PartData>();
      forecastList.clear();      
      
      for (Forecast__c sObjectpf : scope)
      {
            system.debug('sObjectpf --'+sObjectpf);
            INFRA.ForecastData.PartData forecastHeader1;
            forecastHeader1 =null;
            logrdid=(String)sObjectpf.Id;

            /*check for OEM Level- Portfolio and Non-Portfolio*/
            if(sObjectpf.Type__c == 'Portfolio'|| sObjectpf.Type__c == 'Non-Portfolio')
            {                                
                /*OEM forecast*/                
                
                
                if(sObjectpf.Forecast_Level__c == oemForecastLevel)
                {                                       
                    List<Forecast_Detail__c> ffd=mapfd.get(String.valueof(sObjectpf.Id));
                    if(ffd != null){                    
                    
                    forecastHeader1 = new INFRA.ForecastData.PartData();            
                    forecastHeader1.customer = (String)sObjectpf.Accountid__r.Account_Number_JDA_bridge_format__c;                
                    forecastHeader1.customerIndicator = INFRA.ForecastUtil.CustomerIndicator.SoldTo;
                    forecastHeader1.dataStream = INFRA.ForecastUtil.DataStream.SalesOpportunity;
                    forecastHeader1.productHierarchyIndicator = INFRA.ForecastUtil.ProductHierarchyIndicator.GPL;
                    forecastHeader1.productCode = (String)sObjectpf.GPL__r.Name;
                    forecastHeader1.region = (String)sObjectpf.Accountid__r.LAYER2_ORGANIZATION_SHORT_NM__c;
                    forecastHeader1.site = 'OTHERS';
                    forecastHeader1.siteIndicator = INFRA.ForecastUtil.SiteIndicator.Others;
                    forecastHeader1.businessUnitForecastSourceId = (String)sObjectpf.Id;
                                        
                    List<INFRA.ForecastDetail.PartDetail> forecastDetailList1 =new List<INFRA.ForecastDetail.PartDetail>();
                    forecastDetailList1.clear();
                    
                    
                    for(Forecast_Detail__c sObjectfd : ffd){
                  
                    //forecastDetail.clear();
                    integer cnti=1;
                    if(sObjectfd.period__c == currentYear)
                    cnti=currentMonth;
                                        
                    while(cnti<=12){
                        INFRA.ForecastDetail.PartDetail forecastDetail1; 
                        forecastDetail1 = null;
                        forecastDetail1 =new INFRA.ForecastDetail.PartDetail();
                        String mcnt = 'M'+cnti+'__c';
                        String periods=String.valueof(cnti);
                        if(periods.length()== 1)
                        periods= '0'+periods;
                        
                        if(sObjectfd.get(mcnt) != null)
                        forecastDetail1.amount = ((Decimal)sObjectfd.get(mcnt)).setScale(2);
                        else
                        forecastDetail1.amount = 0.00;
                        
                        String rdyear=(String)sObjectfd.period__c;
                        forecastDetail1.period = rdyear+periods;
                        forecastDetail1.periodIndicator = INFRA.ForecastUtil.ForecastPeriodIndicator.Monthly;
                        forecastDetail1.ATTRIB_NM_1 = '1';
                        
                        //Add the foreecast detail to the list
                        forecastDetailList1.Add(forecastDetail1);
                        cnti++;
                    }                   
                   }
                  forecastHeader1.forecastDetail = forecastDetailList1; 
                  system.debug('forecastHeader1OEM----'+forecastHeader1);
                 }               
                }                                
              }
              
              /*Market Adjustment forecast*/
              if(sObjectpf.Type__c == 'Market Adjustment'){
              
                    List<Forecast_Detail__c> ffd=mapfd.get(String.valueof(sObjectpf.Id));
                    if(ffd != null){                    
                    
                    forecastHeader1 = new INFRA.ForecastData.PartData();            
                    forecastHeader1.customer = 'N/A-'+rgmap.get(String.valueof(sObjectpf.Region__c));                
                    forecastHeader1.customerIndicator = INFRA.ForecastUtil.CustomerIndicator.CustomerIndicator207;
                    forecastHeader1.dataStream = INFRA.ForecastUtil.DataStream.SalesOpportunity;
                    forecastHeader1.productHierarchyIndicator = INFRA.ForecastUtil.ProductHierarchyIndicator.ProductHierInd307;
                    forecastHeader1.productCode = (String)sObjectpf.CBC3__c;
                    if(rgmap.get(String.valueof(sObjectpf.Region__c))!= null)
                    forecastHeader1.region = rgmap.get(String.valueof(sObjectpf.Region__c));
                    forecastHeader1.site = 'OTHERS';
                    forecastHeader1.siteIndicator = INFRA.ForecastUtil.SiteIndicator.Others;
                    forecastHeader1.businessUnitForecastSourceId = (String)sObjectpf.Id;
                                        
                    List<INFRA.ForecastDetail.PartDetail> forecastDetailList1 =new List<INFRA.ForecastDetail.PartDetail>();
                    forecastDetailList1.clear();
                    
                    
                    for(Forecast_Detail__c sObjectfd : ffd){
                                    
                    //forecastDetail.clear();
                    integer cnti=1;
                    if(sObjectfd.period__c == currentYear)
                    cnti=currentMonth;
                                        
                    while(cnti<=12){
                        INFRA.ForecastDetail.PartDetail forecastDetail1; 
                        forecastDetail1 = null;
                        forecastDetail1 =new INFRA.ForecastDetail.PartDetail();
                        String mcnt = 'M'+cnti+'__c';
                        String periods=String.valueof(cnti);
                        if(periods.length()== 1)
                        periods= '0'+periods;
                        
                        if(sObjectfd.get(mcnt) != null)
                        forecastDetail1.amount = ((Decimal)sObjectfd.get(mcnt)).setScale(2);
                        else
                        forecastDetail1.amount = 0.00;
                        
                        String rdyear=(String)sObjectfd.period__c;
                        forecastDetail1.period = rdyear+periods;
                        forecastDetail1.periodIndicator = INFRA.ForecastUtil.ForecastPeriodIndicator.Monthly;
                        forecastDetail1.ATTRIB_NM_1 = '4';
                        
                        //Add the foreecast detail to the list
                        forecastDetailList1.Add(forecastDetail1);
                        cnti++;
                     }
                    }
                   forecastHeader1.forecastDetail = forecastDetailList1;
                   }
                   system.debug('forecastHeader1M----'+forecastHeader1);
              }
                
                system.debug('forecastHeader1'+forecastHeader1);
                if(forecastHeader1 != null)
                {
                    forecastList.Add(forecastHeader1);
                }
         }
           system.debug('forecastList----'+forecastList);
           //Create the 'ForecastPublishManagerClass' class object by passing the BU Name in the constructor
            INFRA.ForecastPublishManagerClass clsObj = new INFRA.ForecastPublishManagerClass('AER');
            
            //invoke the publish function and pass the forecast list
            if(forecastList.size() > 0){
            if(!Test.isRunningTest()){
            clsObj.publishPartForecast(forecastList); 
            } }
    }
    catch(Exception e){
                System.debug('errMessage' + ': ' + e.getMessage());
                ErrorLogging.Log(e, 'ADMJDABookingForecastOEMMA_Batch', 'execute',logrdid);
                //return null;    
    }
}


global void finish(Database.BatchableContext BC){
        ADMJDAOppForecast_Batch oppBatch = new ADMJDAOppForecast_Batch();
        Id batchInstanceId = Database.executeBatch(oppBatch, 100);       
} 

}