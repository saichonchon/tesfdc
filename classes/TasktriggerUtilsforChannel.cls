/**
*  This class is used to update Detractor assignment status field on Account when task Subject is Detractor Assignment  
*
@author Padmaja Dadi
@created 1/2/2016
@Test Class : taskTrigger_Test
@ coverage  100%
@changelog

*/
Public class TasktriggerUtilsforChannel
{
    public static void UpdateDetractorAssignmentStatus(Map<Id,Task> mapTasknew)
    {
             Set<ID> setwhatIDs = new Set<ID>();
             list<account> acct = new list<account>();
             
             for(Task oTaskNew :mapTaskNew.values())
             {
               
                setwhatIDs.add(oTaskNew.WhatID);
               
              } 
              acct = [SELECT Id,Detractor_Assignment_Status__c FROM Account WHERE Id =: setwhatIDs];
             Map<ID, Task> taskMap = new Map<ID, Task>();
             for (Task t : mapTaskNew.values()){
            
                if (t.Subject.equals('Detractor Assignment')) {
                   taskMap.put(t.whatID, t);
              }
           
           }
            for (Account a : acct) {
        if (taskMap.containsKey(a.Id)) {
            a.Detractor_Assignment_Status__c = taskMap.get(a.Id).Status;
            
        }
    }
    update acct;
  }           
   
     
}