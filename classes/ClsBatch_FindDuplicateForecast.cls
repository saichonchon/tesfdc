/** 
*    Batch class to Find Duplicate Forecast record and storing into Staging Object
*
*    Description: Batch to fetch all duplicate Forecast record at Opportunity and Part level and checking which one holding
*                 oldest modified date. Oldest modified date record will be marked as delete and storing into a staging Object.
*
*    @author Subramanian Jayaram
*    @created 2015-03-16 
*    @version 1.0
**/

global class ClsBatch_FindDuplicateForecast implements Database.Batchable<sObject>, Database.stateful, Database.AllowsCallouts{
  
   // global Map<Id, Opportunity_Forecast_Staging__c> insertOppForecastStaging = NULL;
    
    global opportunity_forecast__c previousOppForecast = NULL;
    
    global Boolean isDuplicate = FALSE;
    
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        
        //Query to get all Forecast Record
        String query = 'Select id, Name, opportunity__c, opportunity__r.Opportunity_Number__c, opportunity__r.Amount, opportunity__r.Ownerid, opportunity__r.Region_Design__c, part__c, Part__r.Name, recordtypeid, date__c, Quantity__c, Amount__c,';
         
        query += ' Createddate, LastModifiedDate, LastModifiedBy.Id, CreatedBy.Id from opportunity_forecast__c'; 
        
        query += ' Where Date__c != NULL';
        
        query += ' order by opportunity__c, part__c, recordtypeid, date__c, lastmodifieddate';
        
        if(Test.isrunningtest()){
            query += ' LIMIT 2000';
        }
        
        system.debug(' query ::: ' + query);
        
        return Database.getQueryLocator(query);         
    }
    
    global void execute(Database.BatchableContext BC, list<Opportunity_Forecast__c> OppForecast){           
        
        Map<Id, Opportunity_Forecast_Staging__c> insertOppForecastStaging = new Map<Id, Opportunity_Forecast_Staging__c>();
        
        // Looping Forecast record
        for( Opportunity_Forecast__c OppF : OppForecast )  
        {    
            system.debug('OppForecast =>' + OppForecast);
             // Checking previous Forecast record not empty
             if( previousOppForecast != NULL )
             {
                 // Checking Previous and current Forecast Record are under same Opportunity and Opportunity Part
                if( previousOppForecast.Opportunity__c == OppF.Opportunity__c && previousOppForecast.Part__c == OppF.Part__c && previousOppForecast.Date__c == OppF.Date__c)
                {
                    // Adding Forecast Record containing oldest modified date to a list to insert into Staging Object and mark as to delete 
                    if(previousOppForecast.lastmodifieddate <= OppF.lastmodifieddate)
                    {                    
                        insertOppForecastStaging.put( previousOppForecast.Id, FieldMapping( previousOppForecast, TRUE ) );
                        previousOppForecast = OppF;
                    }else{
                        insertOppForecastStaging.put( OppF.Id, FieldMapping( OppF, TRUE ) );
                    }
                    
                    // Flag to indicate duplicate record for this Oportunit, Part & Date combination 
                    isDuplicate = TRUE;
                }else{
                    
                    // If the duplicate record found for particular Opportunity Part, then latest modified duplicate record need not mark as delete
                    if( isDuplicate )
                    {
                        insertOppForecastStaging.put( previousOppForecast.Id, FieldMapping( previousOppForecast, FALSE ) );
                    }
                    
                    // Storing current record in a variable, to compare for next loop
                    previousOppForecast = OppF;                    
                    isDuplicate = FALSE;
                }
            }else{
                // Storing current record in a variable, to compare for next loop
                previousOppForecast = OppF;
            }
        }
        
        // Inserting Opportunity Forecast record into Staging Object
        insert insertOppForecastStaging.Values();
        
    }      
    
    // Mapping Forecast fields with Staging fields
    global Opportunity_Forecast_Staging__c FieldMapping(opportunity_forecast__c OppForcast, Boolean isDeleted){
        
        Opportunity_Forecast_Staging__c staging  =     new Opportunity_Forecast_Staging__c();
        
        staging.Opportunity_Id__c                =     OppForcast.Opportunity__c;
        staging.Opportunity_Number__c            =     OppForcast.Opportunity__r.Opportunity_Number__c;
        staging.Opportunity_Owner__c             =     OppForcast.opportunity__r.Ownerid;
        staging.Opportunity_Region__c            =     OppForcast.opportunity__r.Region_Design__c;
        staging.Opportunity_Amount__c            =     OppForcast.opportunity__r.Amount;
        staging.Opportunity_Part_Id__c           =     OppForcast.Part__c;
        staging.Opportunity_Part_Name__c         =     OppForcast.Part__r.Name;
        staging.Opportunity_Forecast_Id__c       =     OppForcast.Id;
        staging.Opportunity_Forecast_Name__c     =     OppForcast.Name;
        staging.Date__c                          =     String.ValueOf(OppForcast.Date__c);
        staging.Quantity__c                      =     String.ValueOf(OppForcast.Quantity__c);
        staging.Amount__c                        =     String.ValueOf(OppForcast.Amount__c);        
        staging.Last_Modified_by__c              =     OppForcast.LastModifiedBy.Id;
        staging.Created_by__c                    =     OppForcast.CreatedBy.Id;
        staging.Created_Date__c                  =     String.ValueOf(OppForcast.Createddate);
        staging.Last_Modified_Date__c            =     String.ValueOf(OppForcast.Lastmodifieddate);
        staging.Marked_As_Deleted__c             =     isDeleted;
        
        return staging;
    }    
    
    global void finish(Database.BatchableContext BC){
      /* Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       String[] toAddresses = new String[] {'subramanian.jairam@te.com'};
       mail.setToAddresses(toAddresses);
       mail.setSubject('Record Clean Up Status: ');
       mail.setPlainTextBody(''+insertOppForecastStaging.KeySet());
       Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        */        
    }
}