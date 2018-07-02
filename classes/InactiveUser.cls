/***********************************************************************************************************************
Name: InactiveUser
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S
========================================================================================================================
Purpose: Inactive the user                                                   
========================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR                DATE       DETAIL                                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------
1.0    Ravi                 06/20/2013     Initial Development                                         
***********************************************************************************************************************/


public class  InactiveUser
{
       
   
    public  InactiveUser()
    {
        List<user> inactiveUsers = new List<user>(); 
        for(user u : [select Id,IsActive,Expiration_date__c from user where isactive = true AND  Expiration_date__c <=:system.today()])
        {
            u.isactive = false;
            inactiveUsers.add(u);
        }
        if(inactiveUsers != null && inactiveUsers.size()>0){
            update inactiveUsers;
        }
   }
}