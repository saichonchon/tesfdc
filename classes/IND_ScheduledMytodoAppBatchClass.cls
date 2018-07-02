/*********************************************************************************************************************** 
 Name: IND_ScheduledMytodoAppBatchClass
 Salesforce Instance : QA Sandbox
========================================================================================================================
 Purpose: This class is Used to schedule the sending mail class for my to do app on weekly basis:
  1. 
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
 VERSION AUTHOR                DATE         DETAIL                                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------
     1.0 Deepak                6 August 2016   Initial Development                                         



***********************************************************************************************************************/


global class IND_ScheduledMytodoAppBatchClass implements Schedulable {

      // This test runs a scheduled job at midnight Sept. 3rd. 2022
        public static String CRON_EXP = '0 0 0 3 9 ? 2022';
     
       global void execute(SchedulableContext sc) {
       
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime,CreatedbyId
                    FROM CronTrigger WHERE Id = :sc.getTriggerId()];
 
        Database.executeBatch(new INDBatch_MytoDoEmailClassCall(),25);

       }

    }