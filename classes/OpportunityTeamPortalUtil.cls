/**************************************************************************************************************************************************
Name:  OpportunityTeamPortalUtil
Copyright © 2015 TE Connectivity
===================================================================================================================================================
Purpose: This class contain an invocable method that can be used by a Process to create an opportunity team after lead conversion
         The @future annotation is critical to this process
---------------------------------------------------------------------------------------------------------------------------------------------------       
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
Version Developer          Date       Detail                                  Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Phil Hiemstra     10/2/2015 Initial Development            
**************************************************************************************************************************************************/

public class OpportunityTeamPortalUtil {

    @InvocableMethod(label='Create Portal Opportunity Team' description='Inserts the opportunity team records for a opportunity created by the portal.')
    public static void createPortalOppTeam(List<Id> opportunityIds){
        createOppTeamMember(opportunityIds);
    }
    
    @future
    public static void createOppTeamMember(List<Id> oppIds){
        
        List<OpportunityTeamMember> lstOppTeams = new List<OpportunityTeamMember>();
		List<OpportunityShare> lstOppShares = new List<OpportunityShare>();
        
        for (Opportunity opp : [select Id, Portal_Converting_User__c, Portal_Channel_User__c from Opportunity where Id in :oppIds]){
            
            OpportunityTeamMember otmDAE = new OpportunityTeamMember();
            otmDAE.OpportunityId = opp.Id;
            otmDAE.TeamMemberRole = 'Distribution Application Engineer (DAE)';
            otmDAE.UserId = opp.Portal_Channel_User__c;
            lstOppTeams.Add(otmDAE);
            
            OpportunityTeamMember otmPartner = new OpportunityTeamMember();
            otmPartner.OpportunityId = opp.Id;
            otmPartner.TeamMemberRole = 'Partner SE';
            otmPartner.UserId = opp.Portal_Converting_User__c;
            lstOppTeams.Add(otmPartner);
            
            OpportunityShare osPartner = new OpportunityShare();
            osPartner.OpportunityId = opp.Id;
            osPartner.UserOrGroupId = opp.Portal_Converting_User__c;
            osPartner.OpportunityAccessLevel = 'Edit';
            lstOppShares.add(osPartner);
            
        }
        
        if (!lstOppTeams.isEmpty()) {
            
            if(Test.isRunningTest()){
                System.runAs(new User(Id = Userinfo.getUserId())){
                    insert lstOppTeams;        
            		insert lstOppShares;
                }
            } else {
            	insert lstOppTeams;        
            	insert lstOppShares;    
            }
            
            
            
        }
    }
}