/**********************************************************************
Name: ADMJDABookingForecastDisty_Batch
Copyright © 2017
==========================================================================================================
==========================================================================================================
Purpose: ADMJDABookingForecastDisty_Batch push Forecast details records with type as Disty to INFRA Managed Package                                                        
======================================================
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR               DATE             DETAIL Description
0.1          Vaibhav  M           11/20/2017       INITIAL DEVELOPMENT
***********************************************************************/
global class ADMJDABookingForecastDisty_Batch implements Database.Batchable<AggregateResult> {

Date todayDate = System.Today();
  
String currentYear;
String nextYear;
String distyForecastLevel;
Integer currentMonth;
Map<String, String> rgmap;
Id ForecastRecordTypeId;
String stringForecastRecordTypeId;


global ADMJDABookingForecastDisty_Batch(){
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
    
    distyForecastLevel = 'CBC3 Level';                
    ADM_Custom_Setting__c distySetting = ADM_Custom_Setting__c.getValues('ADM_DISTYForecastLevel');
    if(distySetting != null){
        distyForecastLevel = distySetting.Value__c;
    }
}


global Iterable<AggregateResult> start(Database.BatchableContext BC){
    /*fetch forecast detail for disty using Iterable*/
     return new ADMAggregateResultIterable();
           
    //String  query = 'SELECT Worldwide_Account_Number__c,CBC3__c,Region__c FROM Forecast__c where RecordTypeId='+ stringForecastRecordTypeId +' and Forecast_Level__c = \''+distyForecastLevel+'\' and type__C in (\'Portfolio\',\'Non-Portfolio\') and id in (Select Parent_Forecast__c from Forecast_Detail__c where type__c in (\'forecast\',\'Auto-Forecast\') and Period__c in (\''+currentYear+'\',\''+nextYear+'\') ) Group by Worldwide_Account_Number__c,CBC3__c,Region__c';    
    //system.debug('query --'+query);
    //return Database.getQueryLocator(query);     
}

global void execute(Database.BatchableContext BC, List<AggregateResult> scope){

set<string> Setyrs =new set<string>{currentYear,nextYear};
 String logrdid='';
 try{
     set<string> SetWWA =new set<string>();
     set<string> SetCBC =new set<string>();
     for (AggregateResult sObjectwf : scope)
      {
          SetWWA.add((String)sObjectwf.get('Worldwide_Account_Number__c'));
          SetCBC.add((String)sObjectwf.get('CBC3__c'));
      }
      
      Map<String, List<AggregateResult>> mapfd= new Map<String, List<AggregateResult>>();
      List <AggregateResult> fdlist= [Select Parent_Forecast__r.Worldwide_Account_Number__c,Parent_Forecast__r.CBC3__c,Parent_Forecast__r.Region__c,Period__c,sum(M1__c) SMM1,sum(M2__c) SMM2,sum(M3__c) SMM3,sum(M4__c) SMM4,sum(M5__c) SMM5,sum(M6__c) SMM6,sum(M7__c) SMM7,sum(M8__c) SMM8,sum(M9__c) SMM9,sum(M10__c) SMM10,sum(M11__c) SMM11,sum(M12__c) SMM12 from Forecast_Detail__c where Parent_Forecast__r.RecordTypeId=: ForecastRecordTypeId and Parent_Forecast__r.Forecast_Level__c =: distyForecastLevel and Parent_Forecast__r.type__C in ('Portfolio','Non-Portfolio') and type__c in ('forecast','Auto-Forecast') and Period__c in: Setyrs and Parent_Forecast__r.Worldwide_Account_Number__c in: SetWWA and Parent_Forecast__r.CBC3__c in: SetCBC Group by Parent_Forecast__r.Worldwide_Account_Number__c,Parent_Forecast__r.CBC3__c,Parent_Forecast__r.Region__c,Period__c];
      system.debug('scopesi'+scope.size());
      
      if(fdlist.size() > 0){
      for(AggregateResult singlefd : fdlist)
      {
           String mapkey= (String)singlefd.get('Worldwide_Account_Number__c')+'_'+(String)singlefd.get('CBC3__c')+'_'+(String)singlefd.get('Region__c');
           if(mapfd.containsKey(mapkey)){              
                   mapfd.get(mapkey).add(singlefd);}      
           else{
                   mapfd.put(mapkey,new list<AggregateResult>{singlefd});}
       } }     
      //Collection of Part Forecast. 
      List<INFRA.ForecastData.PartData> forecastList = new List<INFRA.ForecastData.PartData>();
      forecastList.clear();      
      
      for (AggregateResult sObjectpf : scope)
      {            
            system.debug('sObjectpfdisty1 --'+sObjectpf);
            INFRA.ForecastData.PartData forecastHeader1;
            forecastHeader1 =null;
            String scoperecord =(String)sObjectpf.get('Worldwide_Account_Number__c')+'_'+(String)sObjectpf.get('CBC3__c')+'_'+(String)sObjectpf.get('Region__c');
            logrdid=scoperecord;
                        
            
                //Disty forecast 
                List<AggregateResult> ffd=mapfd.get(scoperecord);
                if(ffd != null){                                                                      
                
                    forecastHeader1 = new INFRA.ForecastData.PartData();            
                    forecastHeader1.customer = (String)sObjectpf.get('Worldwide_Account_Number__c');                
                    forecastHeader1.customerIndicator = INFRA.ForecastUtil.CustomerIndicator.WWAN;
                    forecastHeader1.dataStream = INFRA.ForecastUtil.DataStream.SalesOpportunity;
                    forecastHeader1.productHierarchyIndicator = INFRA.ForecastUtil.ProductHierarchyIndicator.ProductHierInd307;
                    forecastHeader1.productCode = (String)sObjectpf.get('CBC3__c');
                    if(rgmap.get((String)sObjectpf.get('Region__c'))!= null)
                    forecastHeader1.region = rgmap.get((String)sObjectpf.get('Region__c'));
                    forecastHeader1.site = 'OTHERS';
                    forecastHeader1.siteIndicator = INFRA.ForecastUtil.SiteIndicator.Others;
                    forecastHeader1.businessUnitForecastSourceId = scoperecord;
                                        
                    List<INFRA.ForecastDetail.PartDetail> forecastDetailList1 =new List<INFRA.ForecastDetail.PartDetail>();
                    forecastDetailList1.clear();
                    
                    for(AggregateResult sObjectfd : ffd){
                                      
                    //forecastDetail.clear();
                    integer cnti=1;
                    if((String)sObjectfd.get('period__c') == currentYear)
                    cnti=currentMonth;
                                        
                    while(cnti<=12){
                        INFRA.ForecastDetail.PartDetail forecastDetail1; 
                        forecastDetail1 = null;
                        forecastDetail1 =new INFRA.ForecastDetail.PartDetail();
                        String mcnt = 'SMM'+cnti;
                        String periods=String.valueof(cnti);
                        if(periods.length()== 1)
                        periods= '0'+periods;
                        
                        if(sObjectfd.get(mcnt) != null)
                        forecastDetail1.amount = ((Decimal)sObjectfd.get(mcnt)).setScale(2);
                        else
                        forecastDetail1.amount = 0.00;
                        
                        String rdyear=(String)sObjectfd.get('period__c');
                        forecastDetail1.period = rdyear+periods;
                        forecastDetail1.periodIndicator = INFRA.ForecastUtil.ForecastPeriodIndicator.Monthly;
                        forecastDetail1.ATTRIB_NM_1 = '2';
                        
                        //Add the foreecast detail to the list
                        forecastDetailList1.Add(forecastDetail1);
                        cnti++;
                    }
                   }
                   forecastHeader1.forecastDetail = forecastDetailList1;
                   
                   system.debug('forecastHeader1Disty----'+forecastHeader1);
                }                  
                              
                
                if(forecastHeader1 != null)
                {
                    forecastList.Add(forecastHeader1);
                }
         }
            system.debug('forecastList----'+forecastList);
            //Create the 'ForecastPublishManagerClass' class object by passing the BU Name in the constructor
            INFRA.ForecastPublishManagerClass clsObj = new INFRA.ForecastPublishManagerClass('AER');
            
            //invoke the Account publish function and pass the forecast list
            if(forecastList.size() > 0){
            if(!Test.isRunningTest()){
            clsObj.publishPartForecast(forecastList); 
            } }
    }
    catch(Exception e){
                System.debug('errMessage' + ': ' + e.getMessage());
                ErrorLogging.Log(e, 'ADMJDABookingForecastDisty_Batch', 'execute',logrdid);
                //return null;    
    }
}


global void finish(Database.BatchableContext BC){
        ADMJDABookingForecastOEMMA_Batch oemmaBatch = new ADMJDABookingForecastOEMMA_Batch();        
        Id batchInstanceId = Database.executeBatch(oemmaBatch, 100);       
} 

}