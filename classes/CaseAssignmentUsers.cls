/**********************************************************************************************************************************************
*******Name: CaseAssignmentUsers
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose:This calling from keepescalationastrue on Case trigger to change case ownership
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE          DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Narasimha Narra      26/12/2013       Class 
 
***********************************************************************************************************************************************/
public class CaseAssignmentUsers
{
    /*public static void outOfofficeUpdate(map<id,user> newMap,map<id,user> oldMap)
    {
        set<Id> userIds=new set<Id>();
        map<Id,Id> mapnewuser=new map<Id,Id>();
        for(user u:newMap.values())
        {
            if(u.Out_Of_Office__c && !oldMap.get(u.Id).Out_Of_Office__c )
            {
                userIds.add(u.Id);
                mapnewuser.put(u.Id,u.Alternate_User__c);
            }
        }
        if(!userIds.isEmpty())
        updateCaseAssignment([select Id,OwnerId,status from case where ownerId in:userIds],mapnewuser);
        
    }*/
    public static void updateCaseOwner(map<id,case> newMapCs,map<id,case> oldMapCs)
    {
        set<Id> ownerIds= new set<Id>();
        set<Id> caseIds=new set<Id>();
        set<Id> outuserIds= new set<Id>();
        map<Id,Id> mapnewuser=new map<Id,Id>();
        for(case c:newMapCs.values())
        {
            if(c.ownerId !=oldMapCs.get(c.id).OwnerId  && String.valueOf(c.OwnerId).startsWith('005'))
            {
                ownerIds.add(c.OwnerId);
                caseIds.add(c.Id);
            }
           
            
        }
        for(user u:[select id,Out_Of_Office__c,Alternate_User1__c from user where Id in:ownerIds])
        {
           if(u.Out_Of_Office__c && u.Alternate_User1__c!=null)
           mapnewuser.put(u.Id,u.Alternate_User1__c);
        }
        if(!mapnewuser.isEmpty())
        updateCaseAssignment([select Id,OwnerId,status from case where Id in:caseIds AND ownerId in: mapnewuser.keySet()],mapnewuser);
    }
    public static void updateCaseAssignment(list<case> lstCases,map<Id,Id> getNewUser)
    {
        List<case> updateCases = new List<Case>();
        try
        {
            if(!lstCases.isEmpty())
            {
                for(case c:lstCases)
                {
                    if(getNewUser.containsKey(c.ownerId) && getNewUser.get(c.ownerId)!=null)
                    {
                        c.ownerId=getNewUser.get(c.ownerId);
                        updateCases.add(c);
                    }
                    
                }
                if(!updateCases.isEmpty())
                   update updateCases;
               }
       }
       catch(Exception e){
          CCP_Exception_Util.CCP_Exception_Mail(e);
        }
        
        
    }

}