trigger CFTMemberUpdated on Customer_Focus_Team_Member__c (before insert, before update) {
	
	public Set<String> NetworkIds = new Set<String>();
	
	//Get set of Network Ids (EmployeeNumbers) from updated CFT members
	for(Customer_Focus_Team_Member__c CFTMember : trigger.new)
	{
		if(!SalesforceUtils.isNullOrEmpty(CFTMember.TE_Network_User_Id__c))
		{
			NetworkIds.add(CFTMember.TE_Network_User_Id__c);
		}		
	}

    //Get the sales force user data for each network id
    public List<User> SFUsers = SharingUtils.GetSFUserIdNameByNetworkId(NetworkIds);
    public Map<String, User> SFUserIds = SharingUtils.GetSFUserByNetworkIdMap(SFUsers);
    
    //Auto fill Salesforce User Name if blank and a TE Network Id was entered
  	for(Customer_Focus_Team_Member__c AddSFUser : trigger.new)
	{
		//If no SF user identified for CFT member
		if(AddSFUser.Salesforce_User_Name__c == null)
		{
			if(SfUserIds.containsKey(AddSFUser.TE_Network_User_Id__c))
			{
				//Use TE Network ID on CFT Member record to get reference to SF user if one exists
				AddSFUser.Salesforce_User_Name__c = SFUserIds.get(AddSFUser.TE_Network_User_Id__c).Id;
				//AddSFUser.Name = SFUserIds.get(AddSFUser.TE_Network_User_Id__c).Name;
			}
		}
		//Unfortunately this doesn't work.  You have to re-query user object to obtain Employee Id field
		//else if (SalesforceUtils.isNullOrEmpty(AddSFUser.TE_Network_User_Id__c))
		//{
		//	AddSFUser.TE_Network_User_Id__c = AddSFUser.Salesforce_User_Name__r.EmployeeNumber;
		//}	
	}  
}