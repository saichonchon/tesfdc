trigger SalesHierarchyUpdated on Sales_Hierarchy__c (before insert, before update) {
    
    public Set<String> NetworkIds = new Set<String>();
    public String AllUsers;
    
    for(Sales_Hierarchy__c SalesHierarchy : trigger.new)
    {   
        //for each editted Sales_Hierarchy__c, add all the network user ids on it into 1 big ; delimited string    
        AllUsers = SalesHierarchy.Level_7_Assigned_User_Network_Ids__c + ';' +
                SalesHierarchy.Level_6_Assigned_User_Network_Ids__c + ';' +
                SalesHierarchy.Level_5_Assigned_User_Network_Ids__c + ';' +
                SalesHierarchy.Level_4_Assigned_User_Network_Ids__c + ';' +
                SalesHierarchy.Level_3_Assigned_User_Network_Ids__c + ';' +
                SalesHierarchy.Level_2_Assigned_User_Network_Ids__c + ';' +
                SalesHierarchy.Level_1_Assigned_User_Network_Ids__c + ';';
                
        for (String SingleUser : AllUsers.split(';'))
        {
            if(!SalesforceUtils.isNullOrEmpty(SingleUser) && NetworkIds.contains(SingleUser) == false)
            {
                //Add all the users from the string into a list
                NetworkIds.add(SingleUser);
            }
        }
    }
    
    //Get the sales force user data for each network id
    public List<User> SFUsers = SharingUtils.GetSFUserIdNameByNetworkId(NetworkIds);
    public Map<String, User> SFUserIds = SharingUtils.GetSFUserByNetworkIdMap(SFUsers);
     
    for(Sales_Hierarchy__c TerritoryAssignment : trigger.new)
    {   
       //clear all SF user id and name lists on the Sales_Hierarchy__c
       TerritoryAssignment.Level_7_Assigned_Users__c = null;
       TerritoryAssignment.Level_7_Assigned_User_Names__c = null;
       TerritoryAssignment.Level_6_Assigned_Users__c = null;
       TerritoryAssignment.Level_6_Assigned_User_Names__c = null;
       TerritoryAssignment.Level_5_Assigned_Users__c = null;
       TerritoryAssignment.Level_5_Assigned_User_Names__c = null;
       TerritoryAssignment.Level_4_Assigned_Users__c = null;
       TerritoryAssignment.Level_4_Assigned_User_Names__c = null;
       TerritoryAssignment.Level_3_Assigned_Users__c = null;
       TerritoryAssignment.Level_3_Assigned_User_Names__c = null;                                   
       TerritoryAssignment.Level_2_Assigned_Users__c = null;
       TerritoryAssignment.Level_2_Assigned_User_Names__c = null;
       TerritoryAssignment.Level_1_Assigned_Users__c = null;
       TerritoryAssignment.Level_1_Assigned_User_Names__c = null;
       
       TerritoryAssignment.Level_7_Assigned_User_Network_Ids__c = SalesforceUtils.replaceNullStringWithEmpty(TerritoryAssignment.Level_7_Assigned_User_Network_Ids__c);             
       TerritoryAssignment.Level_6_Assigned_User_Network_Ids__c = SalesforceUtils.replaceNullStringWithEmpty(TerritoryAssignment.Level_6_Assigned_User_Network_Ids__c); 
       TerritoryAssignment.Level_5_Assigned_User_Network_Ids__c = SalesforceUtils.replaceNullStringWithEmpty(TerritoryAssignment.Level_5_Assigned_User_Network_Ids__c);  
       TerritoryAssignment.Level_4_Assigned_User_Network_Ids__c = SalesforceUtils.replaceNullStringWithEmpty(TerritoryAssignment.Level_4_Assigned_User_Network_Ids__c); 
       TerritoryAssignment.Level_3_Assigned_User_Network_Ids__c = SalesforceUtils.replaceNullStringWithEmpty(TerritoryAssignment.Level_3_Assigned_User_Network_Ids__c); 
       TerritoryAssignment.Level_2_Assigned_User_Network_Ids__c = SalesforceUtils.replaceNullStringWithEmpty(TerritoryAssignment.Level_2_Assigned_User_Network_Ids__c); 
       TerritoryAssignment.Level_1_Assigned_User_Network_Ids__c = SalesforceUtils.replaceNullStringWithEmpty(TerritoryAssignment.Level_1_Assigned_User_Network_Ids__c);                                   
        
        //Counter to check if Default Owner was already set in this pass
        Integer Counter = 0;
        
        //cycle through network id lists for each level in the hierarchy and set the SF user information for them 
        for(String lvl7Assignee : TerritoryAssignment.Level_7_Assigned_User_Network_Ids__c.split(';'))
        {           
            if(SfUserIds.containsKey(lvl7Assignee) == true)
            {
                //JNV - 8/3/2012 - business decision is that default owner should always be updated from Sales Hierarchy Integration
                //Remove condition to only update default owner if field is blank
                if(Counter == 0)
                {
                    //Use the first person you get from the id list to fill it 
                    TerritoryAssignment.Level_7_Default_Owner__c = SFUserIds.get(lvl7Assignee).Id;
                    Counter = 1;
                }
                TerritoryAssignment.Level_7_Assigned_Users__c = (SalesforceUtils.isNullOrEmpty(TerritoryAssignment.Level_7_Assigned_Users__c) ? String.valueOf(SFUserIds.get(lvl7Assignee).Id) : TerritoryAssignment.Level_7_Assigned_Users__c + (';' + String.valueOf(SFUserIds.get(lvl7Assignee).Id)));
                TerritoryAssignment.Level_7_Assigned_User_Names__c = (SalesforceUtils.isNullOrEmpty(TerritoryAssignment.Level_7_Assigned_User_Names__c) ? SFUserIds.get(lvl7Assignee).Name : TerritoryAssignment.Level_7_Assigned_User_Names__c + (';' + SFUserIds.get(lvl7Assignee).Name));                
            }
        }
        
        //Set Default Owner to null if no salesforce user was set above
        if(Counter == 0)
        {
            TerritoryAssignment.Level_7_Default_Owner__c = null;
        }
                
        for(String lvl6Assignee : TerritoryAssignment.Level_6_Assigned_User_Network_Ids__c.split(';'))
        {           
            if(SfUserIds.containsKey(lvl6Assignee) == true)
            {
                TerritoryAssignment.Level_6_Assigned_Users__c = (SalesforceUtils.isNullOrEmpty(TerritoryAssignment.Level_6_Assigned_Users__c) ? String.valueOf(SFUserIds.get(lvl6Assignee).Id) : TerritoryAssignment.Level_6_Assigned_Users__c + (';' + String.valueOf(SFUserIds.get(lvl6Assignee).Id)));
                TerritoryAssignment.Level_6_Assigned_User_Names__c = (SalesforceUtils.isNullOrEmpty(TerritoryAssignment.Level_6_Assigned_User_Names__c) ? SFUserIds.get(lvl6Assignee).Name : TerritoryAssignment.Level_6_Assigned_User_Names__c + (';' + SFUserIds.get(lvl6Assignee).Name));                          
            }
        }    
        for(String lvl5Assignee : TerritoryAssignment.Level_5_Assigned_User_Network_Ids__c.split(';'))
        {           
            if(SfUserIds.containsKey(lvl5Assignee) == true)
            {
                TerritoryAssignment.Level_5_Assigned_Users__c = (SalesforceUtils.isNullOrEmpty(TerritoryAssignment.Level_5_Assigned_Users__c) ? String.valueOf(SFUserIds.get(lvl5Assignee).Id) : TerritoryAssignment.Level_5_Assigned_Users__c + (';' + String.valueOf(SFUserIds.get(lvl5Assignee).Id)));
                TerritoryAssignment.Level_5_Assigned_User_Names__c = (SalesforceUtils.isNullOrEmpty(TerritoryAssignment.Level_5_Assigned_User_Names__c) ? SFUserIds.get(lvl5Assignee).Name : TerritoryAssignment.Level_5_Assigned_User_Names__c + (';' + SFUserIds.get(lvl5Assignee).Name));                          
            }
        }
        for(String lvl4Assignee : TerritoryAssignment.Level_4_Assigned_User_Network_Ids__c.split(';'))
        {           
            if(SfUserIds.containsKey(lvl4Assignee) == true)
            {
                TerritoryAssignment.Level_4_Assigned_Users__c = (SalesforceUtils.isNullOrEmpty(TerritoryAssignment.Level_4_Assigned_Users__c) ? String.valueOf(SFUserIds.get(lvl4Assignee).Id) : TerritoryAssignment.Level_4_Assigned_Users__c + (';' + String.valueOf(SFUserIds.get(lvl4Assignee).Id)));
                TerritoryAssignment.Level_4_Assigned_User_Names__c = (SalesforceUtils.isNullOrEmpty(TerritoryAssignment.Level_4_Assigned_User_Names__c) ? SFUserIds.get(lvl4Assignee).Name : TerritoryAssignment.Level_4_Assigned_User_Names__c + (';' + SFUserIds.get(lvl4Assignee).Name));                          
            }
        }
        for(String lvl3Assignee : TerritoryAssignment.Level_3_Assigned_User_Network_Ids__c.split(';'))
        {           
            if(SfUserIds.containsKey(lvl3Assignee) == true)
            {
                TerritoryAssignment.Level_3_Assigned_Users__c = (SalesforceUtils.isNullOrEmpty(TerritoryAssignment.Level_3_Assigned_Users__c) ? String.valueOf(SFUserIds.get(lvl3Assignee).Id) : TerritoryAssignment.Level_3_Assigned_Users__c + (';' + String.valueOf(SFUserIds.get(lvl3Assignee).Id)));
                TerritoryAssignment.Level_3_Assigned_User_Names__c = (SalesforceUtils.isNullOrEmpty(TerritoryAssignment.Level_3_Assigned_User_Names__c) ? SFUserIds.get(lvl3Assignee).Name : TerritoryAssignment.Level_3_Assigned_User_Names__c + (';' + SFUserIds.get(lvl3Assignee).Name));                          
            }
        }                     
        for(String lvl2Assignee : TerritoryAssignment.Level_2_Assigned_User_Network_Ids__c.split(';'))
        {           
            if(SfUserIds.containsKey(lvl2Assignee) == true)
            {
                TerritoryAssignment.Level_2_Assigned_Users__c = (SalesforceUtils.isNullOrEmpty(TerritoryAssignment.Level_2_Assigned_Users__c) ? String.valueOf(SFUserIds.get(lvl2Assignee).Id) : TerritoryAssignment.Level_2_Assigned_Users__c + (';' + String.valueOf(SFUserIds.get(lvl2Assignee).Id)));
                TerritoryAssignment.Level_2_Assigned_User_Names__c = (SalesforceUtils.isNullOrEmpty(TerritoryAssignment.Level_2_Assigned_User_Names__c) ? SFUserIds.get(lvl2Assignee).Name : TerritoryAssignment.Level_2_Assigned_User_Names__c + (';' + SFUserIds.get(lvl2Assignee).Name));                          
            }
        }
        for(String lvl1Assignee : TerritoryAssignment.Level_1_Assigned_User_Network_Ids__c.split(';'))
        {           
            if(SfUserIds.containsKey(lvl1Assignee) == true)
            {
                TerritoryAssignment.Level_1_Assigned_Users__c = (SalesforceUtils.isNullOrEmpty(TerritoryAssignment.Level_1_Assigned_Users__c) ? String.valueOf(SFUserIds.get(lvl1Assignee).Id) : TerritoryAssignment.Level_1_Assigned_Users__c + (';' + String.valueOf(SFUserIds.get(lvl1Assignee).Id)));
                TerritoryAssignment.Level_1_Assigned_User_Names__c = (SalesforceUtils.isNullOrEmpty(TerritoryAssignment.Level_1_Assigned_User_Names__c) ? SFUserIds.get(lvl1Assignee).Name : TerritoryAssignment.Level_1_Assigned_User_Names__c + (';' + SFUserIds.get(lvl1Assignee).Name));                          
            }
        }                                                             
    } 
}