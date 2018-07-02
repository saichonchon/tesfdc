/**********************************************************************
Name:  ADMForecastBatch_Helper
Copyright © 2017
======================================================
======================================================
Purpose: ADMForecastBatch_Helper is helper class used for deleting/insterting/updating Forecast Detail of different record types/types.
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR                DATE             DETAIL Description
0.1          Vaibhav M           09/05/2017         INITIAL DEVELOPMENT
***********************************************************************/


public class ADMForecastBatch_Helper{

    public static void deletedForecastDetail(List<Sobject> scope, Database.DeleteResult[] DR_Dels){
    
    LIST<ErrorLog__c> newErrorlist = new LIST<ErrorLog__c>();
    Integer cnt=0;
        for(Database.DeleteResult dr : DR_Dels){
           if (!dr.isSuccess()){
                ErrorLog__c newErrorObj = new ErrorLog__c();
                newErrorObj.Class__c          = 'ADM_ForecastDetailDelete_Batch';
                newErrorObj.Method_Name__c    = 'execute';
                String RecordId=(String)scope[cnt].get('Id');
                newErrorObj.SFDC_Record_Id__c = RecordId;
                newErrorObj.Error_Message__c = '';
                for(Database.Error err : dr.getErrors()){            
                newErrorObj.Error_Message__c = newErrorObj.Error_Message__c + err.getMessage();
                }
                newErrorlist.add(newErrorObj);
                system.debug('newErrorObj-->'+newErrorObj);    
     }
      cnt++;
    }
    insert newErrorlist;
    }
 /******
 
    
 /******
  Method is used to update the ForecastDetail Records
   
 */
 
      public static void updatedForecastDetail(List<Sobject> scope, Database.SaveResult[] DR_Updates){
      
      LIST<ErrorLog__c> newErrorlist = new LIST<ErrorLog__c>();
      Integer cnt=0;
       for(Database.SaveResult sr: DR_Updates)
        {
        if(!sr.isSuccess()){
                ErrorLog__c newErrorObj = new ErrorLog__c();
                newErrorObj.Class__c          = 'ADM_ForecastDetailDelete_Batch ';
                newErrorObj.Method_Name__c    = 'execute';
                String RecordId=(String)scope[cnt].get('Parent_Forecast__c');
                newErrorObj.SFDC_Record_Id__c = RecordId;
                newErrorObj.Error_Message__c = '';
                for(Database.Error err : sr.getErrors()){            
                newErrorObj.Error_Message__c = newErrorObj.Error_Message__c + err.getMessage();
                }
                newErrorlist.add(newErrorObj);
                }
                cnt++;
        }
        insert newErrorlist;
    
    }
    
 /****** 
    Method is used to upsert the ForecastDetail Records
   
 *****/
 
    
      public static void upsertedForecastDetail(List<Sobject> scope, Database.UpsertResult[] DR_Upserts){
        
        LIST<ErrorLog__c> newErrorlist = new LIST<ErrorLog__c>();
        Integer cnt=0;
        for(Database.UpsertResult sr : DR_Upserts){
            if (!sr.isSuccess()){
                //Creating ErrorLog Record
                ErrorLog__c newErrorObj = new ErrorLog__c();
                newErrorObj.Class__c          = 'ADMGuidanceForecastDetails_Batch';
                newErrorObj.Method_Name__c    = 'execute';
                String RecordId=(String)scope[cnt].get('Parent_Forecast__c');
                newErrorObj.SFDC_Record_Id__c = RecordId;
                newErrorObj.Error_Message__c = '';
                for(Database.Error err : sr.getErrors()){            
                    newErrorObj.Error_Message__c = newErrorObj.Error_Message__c + err.getMessage();
                }
                //Adding errorLog Record in List
                newErrorlist.add(newErrorObj);
                system.debug('newErrorObj-->'+newErrorObj);    
            }
            cnt++;
        }
        insert newErrorlist;
    }
    
    
}