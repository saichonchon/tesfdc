/*****************************************************************************************************************************************
Name: TaskTriggerHandler
Copyright © 2017 TE Connectivity
==========================================================================================================================================
Requirement:
To inform Contact by sending an email about the Task assigned with Task detail
==========================================================================================================================================
Purpose:
To update ACP_Contact_Email__c field of Task object with Contact's whoid
==========================================================================================================================================
History
-------
VERSION     AUTHOR                       DATE                              DETAIL
1.0        Pankaj Raijade        2/1/2016                   Initial development
2.0        Michael               11/08/2016                 Added method for before insert and called class for IND Task Owner Reassign
3.0        Esther Ethelbert       9/18/2017                  Calling updateACPContactEmail(lstTaskNew,mapTaskOld) in "onBeforeInsert" and
                                                            "onBeforeUpdate" methods
4.0        Haripriya Maturi      11/2/2017                  updated Header comments in TE format
5.0        Haripriya Maturi      11/3/2017                  updated Header comments
6.0        Rahulkumar            4/16/2018                  added UpdateActivityOnMQLRecord method to update first activity date on MQLRecord for case 901528
*****************************************************************************************************************************************/

public class TaskTriggerHandler
{
    public void onAfterUpdate(list<Task> lstTaskOld, list<Task> lstTaskNew, Map<Id,Task> mapTaskOld, Map<Id,Task> mapTaskNew, Integer iTriggerSize)
    {
        TasktriggerUtils.CreateFunctionalFollowUpTask(mapTaskold, mapTaskNew);
        TasktriggerUtilsforChannel.UpdateDetractorAssignmentStatus(mapTaskNew);
    }
    
    public void onAfterInsert(list<Task> lstTaskNew, Map<Id,Task> mapTaskNew)
    {
  
      TasktriggerUtilsforChannel.UpdateDetractorAssignmentStatus(mapTaskNew);
      TasktriggerUtils.updateActivityOnMQLRecord(lstTaskNew);    //--case 901528 Rahul(16 Apr 2018)--//
    }
    
    public void onBeforeInsert(list<Task> lstTaskNew,Map<Id,Task> mapTaskOld)
    {
        IND_TaskOwnerReassignTriggerClass.UpdateTaskOwner(lstTaskNew);
        ACP_TaskUtil.updateACPContactEmail(lstTaskNew,mapTaskOld);   //180917 Esther - Added for Account Plan
    }
    
    public void onBeforeUpdate(list<Task> lstTaskNew, Map<Id,Task> mapTaskOld)
    {
        ACP_TaskUtil.updateACPContactEmail(lstTaskNew,mapTaskOld); //180917 Esther - Added for Account Plan
    }
}