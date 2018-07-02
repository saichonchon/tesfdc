/**********************************************************************
Name: ADMJDAOppForecast_Batch
Copyright © 2017
==========================================================================================================
==========================================================================================================
Purpose: ADMJDAOppForecast_Batch push opportunity Forecast records with based  on account-GPL with account 
record type “account” and opportunity record type “ADM” and Relevant for S&OP is checked to INFRA Managed Package                                                        
======================================================
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR               DATE             DETAIL Description
0.1          Vaibhav  M           10/11/2017       INITIAL DEVELOPMENT
***********************************************************************/
global class ADMJDAOppForecast_Batch implements Database.Batchable<sObject> {

Date todayDate = System.Today();
String currentYear;
String nextYear;
Integer currentMonth;
Period currentPeriod;

global ADMJDAOppForecast_Batch(){

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
            currentPeriod=periodmonth;
            currentMonth=p;        
            break;
        }
    }
}


global Database.QueryLocator start(Database.BatchableContext BC){
    /*fetch Opportunity & Opportunity forecast*/
    Id accountRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Account').getRecordTypeId();
    Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('ADM').getRecordTypeId(); 
    
    String stringaccountRecordTypeId='\''+accountRecordTypeId+'\'';
    String stringoppRecordTypeId='\''+oppRecordTypeId+'\'';
    String query = 'Select id, Account_Number_JDA_bridge_format__c, LAYER2_ORGANIZATION_SHORT_NM__c from account where id in (select accountid From Opportunity Where Relevant_for_S_OP__c=true and RecordTypeId='+stringoppRecordTypeId+' and account.RecordTypeId='+stringaccountRecordTypeId+')';
        
    //system.debug('query --'+query);
    return Database.getQueryLocator(query);
}


global void execute(Database.BatchableContext BC, List<account> scope){
  
 String logrdid='';
 set<string> Setyrs =new set<string>{currentYear,nextYear};
 set<string> SetPartConfidence = new set<string>{'50/50', 'Likely', 'Commit', 'Weak', 'Won'};
 Id oppForecastRecordTypeId = Schema.SObjectType.Opportunity_Forecast__c.getRecordTypeInfosByName().get('Part').getRecordTypeId();
 Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('ADM').getRecordTypeId(); 
 Set<id> scopeaccountids=new Set<id>();
 for (account objaccnt : scope)
  {
      scopeaccountids.add(objaccnt.id);
  }
  
  //Create Account=>GPL Map
  Map<string, List<AggregateResult>>scopegpl = new Map<string, List<AggregateResult>>();
  List<AggregateResult> scopeoppforcastgpls=[SELECT Opportunity__r.accountid, Part__r.GPL__c, Part__r.GPL__r.name FROM Opportunity_Forecast__c WHERE Opportunity__r.Relevant_for_S_OP__c = true AND Opportunity__r.accountid in:scopeaccountids AND Opportunity__r.RecordTypeId=:oppRecordTypeId AND RecordTypeId=:oppForecastRecordTypeId AND Fiscal_Year__c in: Setyrs AND Part_Confidence__c in: SetPartConfidence group by Opportunity__r.accountid, Part__r.GPL__c, Part__r.GPL__r.name];
  if(scopeoppforcastgpls.size() > 0){
  for(AggregateResult scopeoppforecastgpl : scopeoppforcastgpls)
  {
       if(scopegpl.containsKey((String)scopeoppforecastgpl.get('accountid'))){              
               scopegpl.get((String)scopeoppforecastgpl.get('accountid')).add(scopeoppforecastgpl);}      
       else{
       scopegpl.put((String)scopeoppforecastgpl.get('accountid'),new list<AggregateResult>{scopeoppforecastgpl});}
   } }
    
  //Create Account-GPL => Opportunity forecast map respective account-GPL base
  Map<String, List<AggregateResult>>scopeoppforecastfdlist = new Map<String, List<AggregateResult>>();
  List<AggregateResult> oppforecastfdlist=[SELECT Opportunity__r.accountid,Part__r.GPL__c,Fiscal_Month__c,Fiscal_Year__c,sum(Amount__c) amt FROM Opportunity_Forecast__c WHERE Opportunity__r.Relevant_for_S_OP__c = true AND Opportunity__r.accountid in: scopeaccountids AND Fiscal_Year__c in: Setyrs AND Part_Confidence__c in: SetPartConfidence group by Opportunity__r.accountid,Part__r.GPL__c,Fiscal_Year__c,Fiscal_Month__c];
  if(oppforecastfdlist.size()>0){
  for(AggregateResult oppforecastfd : oppforecastfdlist)
  {
      if(scopeoppforecastfdlist.containsKey((String)oppforecastfd.get('accountid')+'_'+(String)oppforecastfd.get('GPL__c'))){
      scopeoppforecastfdlist.get((String)oppforecastfd.get('accountid')+'_'+(String)oppforecastfd.get('GPL__c')).add(oppforecastfd);              
      }
    else{
        scopeoppforecastfdlist.put((String)oppforecastfd.get('accountid')+'_'+(String)oppforecastfd.get('GPL__c'),new list<AggregateResult>{oppforecastfd});
       }
  } }  
 
 try{
      //Collection of Part Forecast. 
      List<INFRA.ForecastData.PartData> forecastList = new List<INFRA.ForecastData.PartData>();
      forecastList.clear();
      INFRA.ForecastData.PartData forecastHeader1 ;
      
      
      for (account objaccount : scope)
      {           
              logrdid=(String)objaccount.Id;
               
              List<AggregateResult> oppforcastgpls=scopegpl.get(String.valueof(objaccount.Id));
              
             if (oppforcastgpls != null)
             { 
                for(AggregateResult oppforecastgpl : oppforcastgpls)
                {
                                       
                    String gplname=(String)oppforecastgpl.get('Name');
                    
                    forecastHeader1 =null;
                    forecastHeader1 = new INFRA.ForecastData.PartData();            
                    forecastHeader1.customer = objaccount.Account_Number_JDA_bridge_format__c;                
                    forecastHeader1.customerIndicator = INFRA.ForecastUtil.CustomerIndicator.SoldTo;
                    forecastHeader1.dataStream = INFRA.ForecastUtil.DataStream.SalesBookingForecast;
                    forecastHeader1.productHierarchyIndicator = INFRA.ForecastUtil.ProductHierarchyIndicator.GPL;
                    forecastHeader1.productCode = gplname;
                    forecastHeader1.region = objaccount.LAYER2_ORGANIZATION_SHORT_NM__c; 
                    forecastHeader1.site = 'OTHERS';
                    forecastHeader1.siteIndicator = INFRA.ForecastUtil.SiteIndicator.Others;
                    forecastHeader1.businessUnitForecastSourceId = objaccount.Id;
                                        
                    List<INFRA.ForecastDetail.PartDetail> forecastDetailList1 =new List<INFRA.ForecastDetail.PartDetail>();
                    forecastDetailList1.clear();
                    
                    //List<AggregateResult> oppforecastlist1=[SELECT Fiscal_Month__c,Fiscal_Year__c,sum(Amount__c) amt FROM Opportunity_Forecast__c WHERE Opportunity__r.Relevant_for_S_OP__c = true AND Opportunity__r.accountid =: objaccount.id AND Fiscal_Year__c in: Setyrs AND Part_Confidence__c in: SetPartConfidence AND Part__r.GPL_Name__c=:gplname group by Fiscal_Month__c,Fiscal_Year__c];
                    List<AggregateResult> oppforecastlist=scopeoppforecastfdlist.get(String.valueof(objaccount.Id)+'_'+String.valueof(oppforecastgpl.get('GPL__c')));
                                                                                 
                    
                  if (oppforecastlist != null)
                  {                    
                    // Traverse through opportuntiy Forecast
                    for(AggregateResult oppforecast :oppforecastlist)
                    {
                                                      
                        Integer oppfmonth =Integer.valueOf((String)oppforecast.get('Fiscal_Month__c'));
                        //system.debug('Fiscal_Month__c--'+(String)oppforecast.get('Fiscal_Month__c')+Integer.valueOf((String)oppforecast.get('Fiscal_Month__c')));
                        String oppfyear   =(String)oppforecast.get('Fiscal_Year__c');
                        
                       if((oppfyear == currentYear && oppfmonth >= currentMonth) || (oppfyear == nextYear))
                       {
                            INFRA.ForecastDetail.PartDetail forecastDetail1; 
                            forecastDetail1 = null;
                            forecastDetail1 =new INFRA.ForecastDetail.PartDetail();
                            
                            String periods=(String)oppforecast.get('Fiscal_Month__c');
                                                        
                            if(oppforecast.get('amt') != null)
                            forecastDetail1.amount = ((Decimal)oppforecast.get('amt')).setScale(2);
                            else
                            forecastDetail1.amount = 0.00;
                            forecastDetail1.period = oppfyear+periods;
                            forecastDetail1.periodIndicator = INFRA.ForecastUtil.ForecastPeriodIndicator.Monthly;
                            forecastDetail1.ATTRIB_NM_1 = '3';
                            
                            //Add the foreecast detail to the list
                            forecastDetailList1.Add(forecastDetail1);
                       } 
                      }                              
                    }
                                    
                   forecastHeader1.forecastDetail = forecastDetailList1;                   
                   system.debug('forecastHeader1----'+forecastHeader1);                                                                         
                    
                    if(forecastHeader1 != null)
                    {
                        forecastList.Add(forecastHeader1);
                    } 
         }
        } 
       }
           system.debug('forecastList----'+forecastList);
           //Create the 'ForecastPublishManagerClass' class object by passing the BU Name in the constructor
            INFRA.ForecastPublishManagerClass clsObj = new INFRA.ForecastPublishManagerClass('AER');
            
            //invoke the Account publish function and pass the forecast list
            if(!Test.isRunningTest()){
            clsObj.publishPartForecast(forecastList); }
    
    }
    catch(Exception e){
                System.debug('errMessage' + ': ' + e.getMessage());
                ErrorLogging.Log(e, 'ADMJDAOppForecast_Batch', 'execute',logrdid);
                //return null;    
    }
    
}


global void finish(Database.BatchableContext BC){
    INFRA_JDA_Settings__c adm1Config = INFRA_JDA_Settings__c.getValues('ADM1');
    INFRA_JDA_Settings__c adm2Config = INFRA_JDA_Settings__c.getValues('ADM2');

    Integer countd1=7;
    if(adm1Config != null)
    countd1=Integer.valueOf(adm1Config.N_th_Day_of_Fiscal_Month__c);

    Integer countd2=14;
    if(adm2Config != null)
    countd2=Integer.valueOf(adm2Config.N_th_Day_of_Fiscal_Month__c);

    //Date sysDate = todayDate;                            
    //system.debug('currentPeriod--'+currentPeriod);

    Date firstfridayDate,firstsatDate,secondFridayDate,secondSatDate, NextMonthFridayDate, NextMonthSatDate;

    firstFridayDate =currentPeriod.StartDate.addDays(countd1-1);
    firstSatDate =currentPeriod.StartDate.addDays(countd1);
    secondFridayDate =currentPeriod.StartDate.addDays(countd2-1);
    secondSatDate =currentPeriod.StartDate.addDays(countd2);
    NextMonthFridayDate =currentPeriod.EndDate.addDays(countd1);

    ADMJDABookingForecast_Schedule m = new ADMJDABookingForecast_Schedule();
    //First 7th day
    if(todayDate == firstFridayDate || todayDate == firstSatDate)
    {
        String sch = '0 0 2 '+secondFridayDate.Day()+' '+secondFridayDate.Month()+' ? '+secondFridayDate.Year();
        //THE CRON STATEMENT FORMED HERE IS IN FORMAT SEC/MIN/HH/DAY_OF_MONTH/MONTH/DAY_OF_WEEK/YEAR
        //0 0 0 XX XX ? XXXX
     
        if(!Test.isRunningTest())
           system.schedule('ADM JDA Booking FORECAST  1st '+System.NOW(), sch, m);                              
    }

    //First 14th day
    if(todayDate == secondFridayDate || todayDate == secondSatDate)
    {
       String sch1 = '0 0 2 '+ NextMonthFridayDate.Day()+' '+ NextMonthFridayDate.Month()+' ? '+ NextMonthFridayDate.Year();
              
       if(!Test.isRunningTest())
         system.schedule('ADM JDA Booking FORECAST 2nd '+System.NOW(), sch1, m);                                
    }       
} 

}