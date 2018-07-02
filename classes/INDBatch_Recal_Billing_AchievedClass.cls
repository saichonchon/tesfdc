/** 
*  Batch class for Sending the mail to MytoDo App Users
*
@author Deepak Kumar (deepak.kumar89@te.com)
@created 5th Jan 2017 
@version 1.0
@since 37.0 (Force.com ApiVersion)
*
 To execute the batch:--- Id batjobId = Database.executeBatch(new INDBatch_Recal_Billing_AchievedClass(),50);


select Id, NextFireTime,CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType from CronTrigger where CronJobDetail.JobType ='7'

*/

global class INDBatch_Recal_Billing_AchievedClass implements Database.Batchable<sObject>, Database.stateful{
  public String query;
   

 public map<id,Opportunity> UpdateMapOpp= new map<id,Opportunity>();
 List<Opportunity_Record_Type_Groups__c> cusTemp = Opportunity_Record_Type_Groups__c.getall().values(); 
 String recordtypefilter;
   

 public map<string,double> Convertedrate;
 Public Integer CurrentFY=0;
 Public Integer CurrentQ=0;
 Public integer failurecountfinal=0;
 
//******************************************************************** Start of Constrctor ****************************************************************************          
  
      Public INDBatch_Recal_Billing_AchievedClass()
       {
                
           //********************************* -=BEGIN public methods=- **********************************
         
               
          Period p=[select FiscalYearSettingsId, FiscalYearSettings.Name, Number, PeriodLabel, StartDate, EndDate from Period where type = 'Quarter' and (startdate <= TODAY and enddate >= TODAY)];
          CurrentFY=Integer.valueOf(p.FiscalYearSettings.Name);
          CurrentQ=p.number;    
        
         // System.debug('**********************'+CurrentFY+'*******************'+CurrentQ);   
            
        if(Convertedrate == null){
           Convertedrate= new  map<string,double>();
            for(currencytype cr:[SELECT conversionrate,isocode FROM currencytype]){
                Convertedrate.put(cr.isocode,cr.conversionrate);
              } 
          }
         
                
        for(Opportunity_Record_Type_Groups__c mn:cusTemp)
         {
           
           if(String.isBlank(recordtypefilter)==true && mn.Group__c=='Forecast Attainment Percentage Calculation')
            {
              recordtypefilter= ' RecordType.DeveloperName=\'' + mn.API_Name__c+ '\'';
            } 
           
            else if(String.isBlank(recordtypefilter)==false && mn.Group__c=='Forecast Attainment Percentage Calculation')
            {
              recordtypefilter+= ' OR RecordType.DeveloperName=\'' + mn.API_Name__c+ '\'';
            } 
         
         }
         
       }


//******************************************************************** End of Constrctor ****************************************************************************          
  


//******************************************************************** Start of Batch job code ****************************************************************************          
  
    
    
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        
       
        if(query == null || query == ''){            
            query = 'select id,Forecast_Attainment_Automated_Mapping__c from opportunity ';
                
                //query +=' LIMIT 20 ';
              if(!Test.isRunningTest())
          
                  query +=  'where ((ForecastCategoryName=\'Closed\') AND (Won_Date__c=THIS_FISCAL_YEAR or Won_Date__c=LAST_FISCAL_YEAR) AND ('+ recordtypefilter+ '))  ';//RecordType.DeveloperName=\'IND_Engineering_project\' OR  RecordType.DeveloperName=\'IND_Sales_Project\'))   
              else
                  query += 'limit 5';   
               
        }
      
            
      //AND LastLoginDate <NEXT_N_DAYS:14 LIMIT 10';
    
        return Database.getQueryLocator(query);
            
    }
    
    global void execute(Database.BatchableContext BC, list<opportunity> list_opp){ 
    
     integer failurecount=0;
     try{ 
          IND_Recal_Billing_Achieved RecBRev= new IND_Recal_Billing_Achieved(CurrentQ,CurrentFY,Convertedrate);
          
          failurecount=RecBRev.UpdateBillingOpp(list_opp);
          failurecountfinal+=failurecount;
        }
       
       catch(Exception Ex){
        system.debug(Ex);
        }  
    
        
    
    }      
 //******************************************************************** End of Batch job code ****************************************************************************          
  
    global void finish(Database.BatchableContext BC){
    
    Batch_Email_message_Users__c oBatchEmailmessageUsers = Batch_Email_message_Users__c.getValues('INDBatch_Recal_Billing_AchievedClass');
    List<String> Toaddress= oBatchEmailmessageUsers.Email_ID__c.split(';');
    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
    string [] toaddres=Toaddress;
    //String[] ccAddresses=new String[]{'jasmine.ver@te.com'};
    email.setSubject('Forecast Attainment% Batch Job Result');
    email.setHtmlBody('Dear Sir /Madam,<br/><br/>Below is the failure result:<br/><br/>Number of opportunity failed to update after the batch job completed: '+ failurecountfinal+'.<br><br>Sincerely,<br>Industrial Admin<br/><br/>');
    email.setToAddresses(toaddress);
    //email.setCcAddresses(ccAddresses);
    Messaging.sendEmail(New Messaging.SingleEmailMessage[]{email});
      
    }
    

    
}