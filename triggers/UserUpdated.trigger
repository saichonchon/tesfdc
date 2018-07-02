trigger UserUpdated on User (after insert, after update) 
{
    // We need to create or delete GroupMember records
    
    List<GroupMember> newGroupMembers = new List<GroupMember>();
  List<GroupMember> deleteGroupMembers = new List<GroupMember>();
  Map<Id, string> newUserGroupAssignments = new Map<Id, string>();
  Map<Id, string> oldUserGroupAssignments = new Map<Id, string>();
  
  // Get all the GIBU's being changed
  for (User u : trigger.new)
  {
    if (u.UserType == 'Standard' && !SalesforceUtils.IsNullOrEmpty(u.GIBU__c) && (trigger.isInsert || (u.GIBU__c != trigger.oldMap.get(u.Id).GIBU__c)))
    {
      newUserGroupAssignments.put(u.id, u.GIBU__c); 
    }
    
    if (u.UserType == 'Standard' && trigger.isUpdate && u.GIBU__c != trigger.oldMap.get(u.Id).GIBU__c && trigger.oldMap.get(u.Id).GIBU__c != null)
    {
      oldUserGroupAssignments.put(u.id, trigger.oldMap.get(u.Id).GIBU__c); 
    }
  } 
  
  system.debug('**** new Assignments: ' + newUserGroupAssignments);
  if (oldUserGroupAssignments.size() > 0 || newUserGroupAssignments.size() > 0)
  {
    // Get all the public groups and put in a map by group name
    Map<string, Id> groupMap = UserAndGroupUtils.GetGroupsByNameMap();
    system.debug('*** Group map: '+ groupMap);
    
    // Get all the existing GroupMember records for the users who are being removed.
    //List<GroupMember> tmpMembers = new List<GroupMember> ([Select Id, GroupId, UserOrGroupId From GroupMember where UserOrGroupId in :oldUserGroupAssignments.keySet()]);
    List<GroupMember> tmpMembers = UserAndGroupUtils.GetGroupMembersForUsers(oldUserGroupAssignments.keySet());
    system.debug('**** tmpmembers = ' + tmpMembers);
    // double check the record before we delete
    for (Id tmpId : oldUserGroupAssignments.keySet())
    {
      Id groupId = groupMap.get(oldUserGroupAssignments.get(tmpId) + ' Users');
      system.debug ('*** looking to delete userid: ' + tmpId + ' and group id: ' + groupId);
      if (groupId != null)
      {
        for (GroupMember gm : tmpMembers)
        {
            if (gm.UserOrGroupId == tmpId && gm.GroupId == groupId)
            {
              deleteGroupMembers.add(gm);
              break;
            }
        }
      }
    }
    
    
    
    // Create new records
    for (Id tmpId : newUserGroupAssignments.keySet())
    {
        system.debug('*** looking for ' + newUserGroupAssignments.get(tmpId) + ' Users');
      Id groupId = groupMap.get(newUserGroupAssignments.get(tmpId) + ' Users');
        if (groupId != null)
        {
            GroupMember newGM = new GroupMember();
            newGM.UserOrGroupId = tmpId;
            newGM.GroupId = groupId;
            newGroupMembers.add(newGM);
        } 
    }
  }
  
  system.debug('**** Number of new group members: ' + newGroupMembers.size());
  system.debug('**** New group members: ' + newGroupMembers);
  
  if (newGroupMembers.size() > 0)
  {
    if(!Test.isRunningTest()){
    Database.insert(newGroupMembers);
    }
  }
  
  system.debug('**** Number of delete group members: ' + deleteGroupMembers.size());
  system.debug('**** Delete group members: ' + deleteGroupMembers);
  if (deleteGroupMembers.size() > 0)
  {
    Database.delete(deleteGroupMembers);
  }
  
  if(Trigger.isUpdate){
      Map<Id,String> userMap = new Map<Id,String>();
      
      for(User u : Trigger.new){
          User oldU = Trigger.OldMap.get(u.Id);
          
          if(u.gibu__c == 'Appliances' && oldU.ManagerId != u.ManagerId){
              userMap.put(u.Id,u.Manager_s_email__c);
          }
      }
      
      if(userMap.keySet().size() > 0){
          List<Opportunity> oppList = [select Id, owner_manager_email__c, OwnerId from Opportunity where OwnerId in: userMap.keySet()];
          System.debug(oppList);
          for(Opportunity opp : oppList){
              opp.owner_manager_email__c = userMap.get(opp.OwnerId);
          }
          
          if(oppList.size() > 0){
              update oppList;
          }
      }
  }
}