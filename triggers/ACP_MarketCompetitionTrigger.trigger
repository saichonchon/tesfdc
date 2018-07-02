/************************************************
Author          : Esther Ethelbert
Created Date    : 09/13/17
Project         : Account Plan
Description     : Trigger for Market and Competition
***********************************************/
trigger ACP_MarketCompetitionTrigger on ACP_Market_and_Competition__c (before insert,before update,before delete,after insert,after update,after delete,after undelete)  { 
  ClsTriggerFactory.createHandler(ACP_Market_and_Competition__c.sObjectType);
  system.debug('trigger');
}