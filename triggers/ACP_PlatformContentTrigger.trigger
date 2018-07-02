/************************************************
Author          : Esther Ethelbert
Created Date    : 09/15/17
Project         : Account Plan
Description     : Trigger for Platform Content
***********************************************/
trigger ACP_PlatformContentTrigger on Platform_Content__c (before insert,before update,before delete,after insert,after update,after delete,after undelete)  { 
  ClsTriggerFactory.createHandler(Platform_Content__c.sObjectType);
  system.debug('trigger');
}