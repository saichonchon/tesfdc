/**********************************************************************
Name: ADMForecastDetailDelete_Batch
Copyright © 2017
==========================================================================================================
==========================================================================================================
Purpose: ADMForecastDetailDelete_Batch is used for Deletion detail of all types/record types less than
 year from current fiscal year mentioned in ADM_Delete_History label (currently it is set as 3)                                                          
======================================================
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR               DATE             DETAIL Description
0.1          Vaibhav  M           09/11/2017       INITIAL DEVELOPMENT
***********************************************************************/

global class ADMForecastDetailDelete_Batch implements Database.Batchable<sObject> {
//Calculate current year
String Queryqd ='SELECT Id, QuarterLabel, StartDate, EndDate, Type, FiscalYearSettingsId ,Number FROM Period WHERE StartDate <= TODAY and EndDate>= TODAY and Type=\'Year\' ' ;
List<Period> Qrtrlist = Database.query(Queryqd);
Date EndDate = Qrtrlist[0].EndDate;
Integer currentyear=EndDate.year();
ADM_Custom_Setting__c delSetting = ADM_Custom_Setting__c.getValues('ADM_Delete_History');


global Database.QueryLocator start(Database.BatchableContext BC){
Id ForecastRecordTypeId = Schema.SObjectType.Forecast__c.getRecordTypeInfosByName().get('ADM').getRecordTypeId();
String stringForecastRecordTypeId ='\''+ForecastRecordTypeId+'\'';
String delHistory = '3'; 
if(delSetting != null){
   delHistory = delSetting.Value__c;
}
Integer periodm=Integer.valueof(delHistory);
String Pastthirdyr='\''+String.valueOf(currentyear-periodm)+'\'';

//Fetch forecast detail recors of all types less than year mentioned in ADM_Delete_History of ADM Custom Setting
String query = 'select id from Forecast_Detail__c where Parent_Forecast__r.RecordTypeId='+stringForecastRecordTypeId+' and Period__c <='+Pastthirdyr;
system.debug('query --'+query);

return Database.getQueryLocator(query);
}


global void execute(Database.BatchableContext BC, List<Forecast_Detail__c> scope){

 try{   
        List<Forecast_Detail__c> deletefdlist = scope;
        //Delete list of forecast detail records    
        Database.DeleteResult[] DR_Dels = Database.delete(deletefdlist, false);
        
        //Hard Delete Records from Recycle Bin
        List<Id> delRecId = new  List<Id>();
        for(Database.DeleteResult dr : DR_Dels){
           if (dr.isSuccess()){
           delRecId.add(dr.getId());         
           }
         }
         if(delRecId.size() > 0){
        Database.emptyRecycleBin(delRecId);}
        
        //Call helper for exception handling   
        ADMForecastBatch_Helper.deletedForecastDetail(scope, DR_Dels);        
    }
    catch(Exception e){
                System.debug('errMessage' + ': ' + e.getMessage()); 
                ErrorLogging.Log(e, 'ADMForecastDetailDelete_Batch', 'execute','');                
    }
}

global void finish(Database.BatchableContext BC){
        // Retriving the current job information from "AsyncApexJob" Object. 
        AsyncApexJob Apexjob = [SELECT Id,Status,MethodName,NumberOfErrors,JobItemsProcessed,TotalJobItems,CreatedBy.Email FROM AsyncApexJob WHERE Id =: BC.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSaveAsActivity(false);
        mail.setTargetObjectId(Userinfo.getuserId());
        mail.setSubject('ADM Historical forecast delete ' + Apexjob.Status);
        mail.setPlainTextBody('"ADMForecastDetailDelete_Batch "  Apex job processed '+Apexjob.TotalJobItems+' batches with '+Apexjob.NumberOfErrors+' Errors.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
} 

}