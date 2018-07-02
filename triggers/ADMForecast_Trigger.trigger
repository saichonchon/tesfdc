/**********************************************************************
Name:  Forecast_Trigger
Copyright © 2017
======================================================
======================================================
Purpose: Trigger for deleting Forecast detail record
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR                DATE             DETAIL               Description
0.1          Kartik  G             10/04/2017       INITIAL DEVELOPMENT
***********************************************************************/

trigger  ADMForecast_Trigger on Forecast__c (before insert,before update,before delete,after insert,after update,after delete,after undelete)  { 
  ClsTriggerFactory.createHandler(Forecast__c.sObjectType);
  system.debug('trigger');
}