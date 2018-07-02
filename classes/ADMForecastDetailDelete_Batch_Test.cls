/**********************************************************************
Name:  ADMForecastDetailDelete_Batch_Test
======================================================
======================================================
Purpose: Test Class for ADMForecastDetailDelete_Batch
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR                DATE             DETAIL               Description
  0.1        Vaibhav M          10/07/2017         INITIAL DEVELOPMENT
***********************************************************************/

@isTest

public class ADMForecastDetailDelete_Batch_Test{

     @TestSetup
    public static void testDataSetup() 
    {
    
        Forecast__c frCast = new Forecast__c();
       
        frCast= ADMTestDataFactory.createForecastObj('TestForecastExtid001','CON','BA','CAM','TestComments','Australia','Part Level',null,'Australiaregion','Portfolio'); 
        Id ForecastRecordTypeId = Schema.SObjectType.Forecast__c.getRecordTypeInfosByName().get('ADM').getRecordTypeId();
        if(frCast != null){
        frCast.RecordTypeId = ForecastRecordTypeId ;
        update frCast; }
        
        Forecast_Detail__c frcDetail = new Forecast_Detail__c();
        
        frcDetail = ADMTestDataFactory.createForecastDetailsForHistorical(frCast.id,'2014','Forecast');
    }
    

          static testMethod void testFDDeleteBatch(){
          ADM_Custom_Setting__c admConfig = new ADM_Custom_Setting__c();
          admConfig.Name = 'ADM_Delete_History';
          admConfig.Value__c = '3';
          insert admConfig;
    
          Test.startTest();
           ADMForecastDetailDelete_Batch deleteBatch= new  ADMForecastDetailDelete_Batch();
           Database.executeBatch(deleteBatch);
          Test.stopTest();
          }
}