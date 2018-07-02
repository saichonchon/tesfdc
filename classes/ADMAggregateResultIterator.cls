/**********************************************************************
Name: ADMAggregateResultIterator
Copyright © 2017
==========================================================================================================
==========================================================================================================
Purpose: ADMAggregateResultIterator is implements Iterator                                                        
======================================================
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR               DATE             DETAIL Description
0.1          Vaibhav  M           11/20/2017       INITIAL DEVELOPMENT
***********************************************************************/
global class ADMAggregateResultIterator implements Iterator<AggregateResult>{ 
   List<AggregateResult> results {get; set;} 
   Integer i {get; set;}
    
   public ADMAggregateResultIterator(){
        /*fetch forecast detail for disty using Iterable*/

        Id ForecastRecordTypeId = Schema.SObjectType.Forecast__c.getRecordTypeInfosByName().get('ADM').getRecordTypeId(); 
        String stringForecastRecordTypeId ='\''+ForecastRecordTypeId+'\'';        
        String distyForecastLevel = 'CBC3 Level';                
        ADM_Custom_Setting__c distySetting = ADM_Custom_Setting__c.getValues('ADM_DISTYForecastLevel');
        if(distySetting != null){
        distyForecastLevel = distySetting.Value__c;
        }
         
        String  query = 'SELECT Worldwide_Account_Number__c,CBC3__c,Region__c FROM Forecast__c where RecordTypeId='+ stringForecastRecordTypeId +' and Forecast_Level__c = \''+distyForecastLevel+'\' and type__C in (\'Portfolio\',\'Non-Portfolio\') Group by Worldwide_Account_Number__c,CBC3__c,Region__c';
        system.debug('query-'+query);
        results = Database.query(query);
        i = 0; 
   }   
   global boolean hasNext(){ 
       if(i >= results.size()) 
           return false; 
       else 
           return true; 
   }    
   global AggregateResult next(){       
       i=i+1; 
       return results[i-1]; 
   } 
}