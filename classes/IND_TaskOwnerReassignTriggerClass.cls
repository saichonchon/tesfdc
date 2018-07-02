/********************************************************...
/*********************************************************************************************************************** 
 Name: IND_TaskOwnerReassignTriggerClass
 Salesforce Instance : QA Sandbox
========================================================================================================================
 Purpose: This class will be called by the Task trigger                                                   
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
 VERSION AUTHOR                DATE         DETAIL                                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------
     1.0 Michael               5 August 2016   Initial Development                                         

*/
public class IND_TaskOwnerReassignTriggerClass {



 public static void UpdateTaskOwner(list<Task> lstTaskNew)
    {
    
      Map<ID,User> UsersActive = new Map<ID,User>([SELECT ID, DelegatedApproverId,IsActive from User]);  
      for(task t1:lstTaskNew)
      {
       
        if(UsersActive.get(t1.OwnerId).DelegatedApproverId!=null && UsersActive.get(UsersActive.get(t1.OwnerId).DelegatedApproverId).IsActive==true && t1.Record_type_developer_name__c=='NPS_Industrial_Functional_Follow_Up_Task')
        t1.OwnerId=UsersActive.get(t1.OwnerId).DelegatedApproverId;
      
      }
        
    }






}