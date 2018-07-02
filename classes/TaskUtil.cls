/**********************************************************************************************************************
Name: TaskUtil   
Copyright © 2012 TE Connectivity | Salesforce Instance : BU Org
=======================================================================================================================
Purpose: Task Utility class is to 1. compute BU Owner info and source BU. 2. Create an entry in PNRC for sharing task  
         with central Org   
=======================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                      
-----------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR        DATE       DETAIL                            Mercury Request #
-----------------------------------------------------------------------------------------------------------------------
    1.0 Umasankar     02/13/2012   Initial Development               SMO (1453487)  
    1.1 Sandeep Yadav 07/24/2013   Source BU change related to 
                                   Case # 00438548
**********************************************************************************************************************/
public class TaskUtil
{
 /*____________________________________________________________________________________________________________________
 | Purpose : Find BU info - Source BU, Task Owned by, Task Owner Email and Task Owner Name                            |
 |____________________________________________________________________________________________________________________|
 | Input Parameter  :                                                                                                 |
 |____________________________________________________________________________________________________________________|
 |  I1. Name        : List of Task                                                                                    | 
 |      Data Type   : List<Task>                                                                                      | 
 |      Description :                                                                                                 |  
 |____________________________________________________________________________________________________________________|
 | Output Parameter : None                                                                                            |
 |___________________________________________________________________________________________________________________*/
 public static void assignBUInfo(List<Task> pLstTask)
 {
  /*-- D1. Collection variable declaration --------------------------------------*/
  Set<Id>      vSetUserId;
  Map<ID,User> vMapUserIdUser;
  /*-- D2. Object variable declaration ------------------------------------------*/
  User vUser;
  /*-- D3. Primitive variable declaration ---------------------------------------*/
  String vStrSourceBu;
  
  if (pLstTask != null)
  {
   if (pLstTask.size() > 0)
   {
    //vStrSourceBu = TE_Connection__c.getInstance('CentralOrg').Source_BU__c; 
    vSetUserId = new Set<Id>();
    
    for (Task vTask :pLstTask)
    { 
     vSetUserId.add(vTask.OwnerId);
    } // for (Task vTask :pLstTask)   

    if (vSetUserId != null)
    {   
     if (vSetUserId.size() > 0)
     {
      vMapUserIdUser = UserDAO.mapUserIdUser(vSetUserId);
      if (vMapUserIdUser != null)
      {
       if (vMapUserIdUser.size() > 0)
       {
        for (Task vTask1 :pLstTask)
        {
         vUser = vMapUserIdUser.get(vTask1.OwnerId);
         if (vUser != null)
         {
          vTask1.BU_Owner_Email__c = vUser.Email;                    
          vTask1.BU_Owner_Name__c  = vUser.Name;
          vTask1.BU_Owner_Phone__c = vUser.Phone ;
          //Task Source BU been retrieved from Owner’s user record [Case # 00438548]
          vTask1.Source_BU__c      = vUser.GIBU__c;
          //vTask1.Source_BU__c      = vStrSourceBu;
         } // if (vUser != null)
        } // for (Task vTask1 :pLstTask)
       } // if (vMapUserIdUser.size() > 0)
      } // if (vMapUserIdUser != null)
     } // if (vSetUserId.size() > 0) 
    } // if (vSetUserId != null)        
   } // if (pLstTask.size() > 0)
  } // if (pLstTask != null)
        
 } // public static void assignBUInfo

 /*____________________________________________________________________________________________________________________
 | Purpose : Find the tasks that are eligible for sharing with central org{Are parent record(Lead record) shared      |
 |           before creating the task?}                                                                               |
 |____________________________________________________________________________________________________________________|
 | Input Parameter  :                                                                                                 |
 |____________________________________________________________________________________________________________________|
 |  I1. Name        : List of Task                                                                                    | 
 |      Data Type   : List<Task>                                                                                      | 
 |      Description : Trigger.New of After Insert trigger as on 02/14/2012 [WhoId is polymorphic - Lead Id or         |
 |                    Contact Id]                                                                                     |  
 |____________________________________________________________________________________________________________________|
 | Output Parameter : None                                                                                            |
 |____________________________________________________________________________________________________________________|
 |  O1. Name        : List of Task                                                                                    | 
 |      Data Type   : List<Task>                                                                                      | 
 |      Description : List of task identified as good for eligible Leads                                              |  
 |___________________________________________________________________________________________________________________*/
 public static List<Task> getTasksOfLead(List<Task> pLstTask)
 {
  /*-- D1. Collection variable declaration --------------------------------------*/
  List<Task>                           vLstTask; 
  List<String>                         vLstLeadId;   
  List<PartnerNetworkRecordConnection> vLstPnrc;
  
  if (pLstTask != null)
  {
   if (pLstTask.size() > 0)
   {
    vLstLeadId = new List<String>();
    
    for (Task vTask1 :pLstTask)
    {
     if (vTask1.WhoId != null)
     {
      if (String.valueOf(vTask1.WhoId).substring(0,3) == '00Q' && vTask1.IsRecurrence == false )
      {
       vLstLeadId.add(vTask1.WhoId);
      } // if (String.valueOf(vTask1.WhoId).substring(0,3) == '00Q' && vTask1.IsRecurrence == false) 
     } // if (vTask1.WhoId != null) 
    } // for (Task vTask1 :pLstTask)
    
    if (vLstLeadId != null)
    {
     if (vLstLeadId.size() > 0)
     {
      vLstPnrc = ConnectionDAO.getPnrcByLocalRecId(vLstLeadId);
      if (vLstPnrc != null)
      {
       if (vLstPnrc.size() > 0)
       {
        vLstTask = new List<Task>();
        for (Task vTask2 :pLstTask)
        {
         for (PartnerNetworkRecordConnection vPnrc : vLstPnrc)
         {
          if (vPnrc.LocalRecordId == vTask2.WhoId)
          {
           vLstTask.add(vTask2);
           break;
          } // if (vPnrc.LocalRecordId == vTask2.WhoId)       
         } // for (PartnerNetworkRecordConnection vPnrc : vLstPnrc) 
        } // for (Task vTask2 :pLstTask)
       } // if (vLstPnrc.size() > 0)    
      } // if (vLstPnrc != null)
     } // if (vLstLeadId.size() > 0)     
    } // if (vLstLeadId != null)
    
   } // if (pLstTask.size() > 0)    
  } // if (pLstTask != null) 
  return vLstTask;
 } // public static List<String> getTasksOfLead

 /*____________________________________________________________________________________________________________________
 | Purpose : Share Task of Lead with central org by creating rows in PNRC                                             |
 |____________________________________________________________________________________________________________________|
 | Input Parameter  :                                                                                                 |
 |____________________________________________________________________________________________________________________|
 |  I1. Name        : List of Task                                                                                    | 
 |      Data Type   : List<Task>                                                                                      | 
 |      Description : Trigger.New of After Insert trigger                                                             | 
 |____________________________________________________________________________________________________________________|
 | Output Parameter : None                                                                                            |
 |___________________________________________________________________________________________________________________*/
 public static void shareTasksOfLead(List<Task> pLstTask)
 {
  /*-- D1. Collection variable declaration --------------------------------------*/
  List<String>                         vLstTaskId; 
  List<Task>                           vLstTask; 
  List<PartnerNetworkRecordConnection> vLstPnrc;
  /*-- D3. Primitive variable declaration ---------------------------------------*/
  String vConId;
  
  if (pLstTask != null)
  {
   if (pLstTask.size() > 0)
   {    
    vLstTask = getTasksOfLead(pLstTask);
    if (vLstTask != null)
    {
     if (vLstTask.size() > 0)
     {
      vConId = TE_Connection__c.getInstance('CentralOrg').Id_value__c;
      vLstPnrc = new List<PartnerNetworkRecordConnection>();
      for (Task vTask1: vLstTask)
      {
       vLstPnrc.add(SF2SFUtil.newPNRC(vConId, vTask1.Id, vTask1.WhoId));
      } // for (Task vTask1: vLstTask)
      
      if (vLstPnrc != null)
      {
       if (vLstPnrc.size() > 0)
       {
        Insert vLstPnrc; 
       } // if (vLstPnrc.size() > 0)
      } // if (vLstPnrc != null)
     } // if (vLstTask.size() > 0)
    } // if (vLstTask != null)
   } // if (pLstTask.size() > 0)    
  } // if (pLstTask != null)
  
 } // public static void shareTasksOfLead
 
 /*__________________________________________________________________________________________________________________*/ 
 
} // public class TaskUtil