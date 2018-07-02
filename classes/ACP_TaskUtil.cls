/******************************************************************************************************************
Name: ACP_TaskUtil
Copyright @ 2017 TE Connectivity
=============================================================================
Requirement:
Task utility class informs Contact about the Task assigned with Task detail.
=============================================================================
Purpose:
To assign Contact whoid in ACP_Contact_Email__c  of Task object
Test class:
ACP_TaskUtil_Test
=============================================================================
History
-------
VERSION   AUTHOR        DATE         DETAIL
1.0 -    Alka Kumari    05/16/17     INITIAL DEVELOPMENT
2.0 -    Anushka Bansal 11/02/17     Added comments 
********************************************************************************************************************/
public class ACP_TaskUtil {
 public static void updateACPContactEmail(list < Task > lstTaskNew, Map < Id, Task > oldMap) {
  List < Id > contactIdList = new List < Id > ();
  List < Contact > contactList = new List < Contact > ();
  Id acpRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Account Plan').getRecordTypeId();
  for (task t1: lstTaskNew) {
   if (oldMap == null) {
    if (t1.WhoId != null && t1.RecordTypeId == acpRecordTypeId) {
     contactIdList.add(t1.WhoId);
    }
   } else {
    if (t1.whoId != null && t1.RecordTypeId == acpRecordTypeId && t1.whoId != oldMap.get(t1.id).whoId)
     contactIdList.add(t1.WhoId);
   }
  }
  if (contactIdList.size() > 0) {
   try {
    contactList = [select id, Email from contact where id in : contactIdList];

    Map < Id, String > contactMap = new Map < Id, String > ();
    for (Contact con: contactList) {
     contactMap.put(con.id, con.Email);
    }

    for (Task tsk: lstTaskNew) {
     tsk.ACP_Contact_Email__c = contactMap.get(tsk.WhoId);
    }
   }
   Catch(Exception e) {
    ErrorLogging.Log(e, 'ACP_TaskUtil', 'updateACPContactEmail', '');
   }

  }
 }
}