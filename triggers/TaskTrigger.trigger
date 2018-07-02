/**
*  This used To call Task trigger handler method
*
@author Pankaj Raijade
@created 1/2/2016
@Test Class : taskTrigger_Test
@ coverage  100%
@changelog
@Changes by Michael 11/08/2016: added statement for before insert

*/
trigger TaskTrigger on Task (before insert, after insert, before update, after update, before delete, after delete, after undelete)
{
    TaskTriggerHandler oTaskTriggerHandler = new TaskTriggerHandler();
    if(Trigger.isUpdate && Trigger.isafter)
    {
        oTaskTriggerHandler.onAfterUpdate(Trigger.Old, Trigger.New, Trigger.OldMap, Trigger.NewMap, Trigger.size);
    }
    if(Trigger.isAfter && Trigger.isInsert)
    {
        oTaskTriggerHandler.onAfterInsert(Trigger.New, Trigger.NewMap);
    }
    if(Trigger.isInsert && Trigger.isBefore)
    {        
       oTaskTriggerHandler.onBeforeInsert(Trigger.New,null);
       //Added for Account Plan - Start
      // ACP_TaskUtil.updateACPContactEmail(Trigger.New,null); 180917 Esther - Commented
       //Added for Account Plan - End
    }
    //Added for Account Plan - Start
    if(Trigger.isUpdate && Trigger.isBefore)
    {        
      // ACP_TaskUtil.updateACPContactEmail(Trigger.New,Trigger.OldMap); 180917 Esther - Commented
       oTaskTriggerHandler.onBeforeUpdate(Trigger.New,Trigger.OldMap); // 180917 Esther - Added for Account Plan
    }
     //Added for Account Plan - End
}