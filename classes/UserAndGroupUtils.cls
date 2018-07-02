public without sharing class UserAndGroupUtils 
{
  public static Map<String, Id> GetGroupsByNameMap()
  { 
    Map<string, Id> groupMap = new Map<string, Id>();
    for (Group g : [Select Id, Name from Group where Type='Regular'])
    {
      groupMap.put(g.Name, g.Id);
    }
    
    return groupMap;
  }
  
  public static List<GroupMember> GetGroupMembersForUsers(Set<Id> userIdSet)
  {
    List<GroupMember> tmpMembers = new List<GroupMember> ([Select Id, GroupId, UserOrGroupId From GroupMember where UserOrGroupId in :userIdSet]);
    return tmpMembers;  	
  }
}