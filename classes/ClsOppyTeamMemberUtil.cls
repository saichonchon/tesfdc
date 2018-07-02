/**
 * This apex class use to update Opportunity_Sales_Team__c on Opportunity.
 *
 * @author      Chen Chen
 * @created     2017-02-06
 * @since       37.0 (Force.com ApiVersion)      
 * @version     1.0 
 *
 * @changelog
 * 2017-02-06 Chen Chen <chen.b.chen@capgemini.com>
 * - Created 
 */
public class ClsOppyTeamMemberUtil {
	public static map<String,String> map_oppyId_oppySaleTeam = new map<String,String>();
    
    public static set<String> getOppyIds(list<OpportunityTeamMember> list_oppyTeam) {
    	set<String> set_oppyIds = new set<String>();
        set<String> set_oppyIds2Fliter = new set<String>();
        set<String> set_recordTypeIds = new set<String>();
        list<Opportunity_Record_Type_Groups__c> list_oppyRecordType = new list<Opportunity_Record_Type_Groups__c>();
       	
        list_oppyRecordType = Opportunity_Record_Type_Groups__c.getall().values();
        for(Opportunity_Record_Type_Groups__c oppyRT : list_oppyRecordType) {
            if(oppyRT.RecordTypeID__c != null && oppyRT.RecordTypeID__c != '' && oppyRT.Active__c == true 
               && oppyRT.Group__c == 'GAM Code/Team Member Record Type') {
                set_recordTypeIds.add(oppyRT.RecordTypeID__c);                            
            }
        }
		
    	if(list_oppyTeam != null){
	    	for(OpportunityTeamMember oppyTeam : list_oppyTeam) {
                set_oppyIds.add(oppyTeam.OpportunityId);
	    	}
    	}
    	
		map_oppyId_oppySaleTeam = new map<String,String>();
    	for(Opportunity oppy : [select Id, Opportunity_Sales_Team__c, RecordTypeId 
                                From Opportunity 
                                Where Id IN: set_oppyIds and RecordTypeId IN: set_recordTypeIds]) {
			map_oppyId_oppySaleTeam.put(oppy.Id, oppy.Opportunity_Sales_Team__c);
            set_oppyIds2Fliter.add(oppy.Id);
        }
    	
    	return set_oppyIds2Fliter;
    }
    
    public static list<Opportunity> updateOppySalesTeam(set<String> set_oppyIds) {
    	set<String> set_oppyRoles = new set<String>();
      	map<String, String> map_oppyId_oppTeamName = new map<String, String>();
      	list<Opportunity> list_oppys = new list<Opportunity>();
      	list<OpportunityTeamTriggerRole__c> list_oppyTriggerRole = OpportunityTeamTriggerRole__c.getall().values();//get custom setting
      	
      	if(list_oppyTriggerRole != null){
      		for(OpportunityTeamTriggerRole__c oppyRole : list_oppyTriggerRole) {
	    		set_oppyRoles.addAll(oppyRole.Opp_Team_Role__c.split(';'));
	    	}
      	}
      	
  		
  		for(String oppId : set_oppyIds) {
  			if(!map_oppyId_oppTeamName.containsKey(oppId)) {
  				map_oppyId_oppTeamName.put(oppId, '');
  			} 
  		}
  		
  		for(OpportunityTeamMember oppTeam : [select Id, OpportunityId, User.Name, TeamMemberRole 
                         					 From OpportunityTeamMember 
                        					 Where OpportunityId IN :set_oppyIds 
                                             /*order by User.Name*/]) {
  			
  			String oppTeamNames = map_oppyId_oppTeamName.get(oppTeam.OpportunityId);
  			if (!oppTeamNames.contains(oppTeam.User.Name  + ';') && set_oppyRoles.contains(oppTeam.TeamMemberRole)) {
  				oppTeamNames = oppTeamNames + oppTeam.User.Name + ';';
  			}
  			map_oppyId_oppTeamName.put(oppTeam.OpportunityId, oppTeamNames);
  		}	
  		
        for(String oppyId : map_oppyId_oppTeamName.keySet()) {
            Opportunity oppy = new Opportunity();
            oppy.Id = oppyId;
            oppy.Opportunity_Sales_Team__c = map_oppyId_oppTeamName.get(oppyId);
            list_oppys.add(oppy);
        }
  		
  		return list_oppys;
    }
    
    public static list<Opportunity> updateOppySalesTeambyTriggerData(set<String> set_oppyIds, list<OpportunityTeamMember> list_newOppyTeamMember) {
    	set<String> set_oppyRoles = new set<String>();
      	map<String, String> map_oppyId_oppTeamName = new map<String, String>();
      	list<Opportunity> list_oppys = new list<Opportunity>();
      	list<OpportunityTeamTriggerRole__c> list_oppyTriggerRole = OpportunityTeamTriggerRole__c.getall().values();//get custom setting
      	
      	if(list_oppyTriggerRole != null){
      		for(OpportunityTeamTriggerRole__c oppyRole : list_oppyTriggerRole) {
	    		set_oppyRoles.addAll(oppyRole.Opp_Team_Role__c.split(';'));
	    	}
      	}
      	
  		
  		for(String oppId : set_oppyIds) {
  			if(!map_oppyId_oppTeamName.containsKey(oppId)) {
                if(map_oppyId_oppySaleTeam.get(oppId) == null || map_oppyId_oppySaleTeam.get(oppId) =='') {
                    map_oppyId_oppTeamName.put(oppId, '');
                }else {
                    map_oppyId_oppTeamName.put(oppId, map_oppyId_oppySaleTeam.get(oppId));
                }
  			}
  		}
  		
        for(OpportunityTeamMember oppTeam : list_newOppyTeamMember) {
			
            String oppTeamNames = map_oppyId_oppTeamName.get(oppTeam.OpportunityId);
			if ((oppTeamNames == '' || oppTeamNames == null || !oppTeamNames.contains(oppTeam.User_Name__c + ';'))
                && set_oppyRoles.contains(oppTeam.TeamMemberRole)) {
  				oppTeamNames = oppTeamNames + oppTeam.User_Name__c + '; ';
  			}
  			map_oppyId_oppTeamName.put(oppTeam.OpportunityId, oppTeamNames);
        }
  		
        for(String oppyId : map_oppyId_oppTeamName.keySet()) {
            Opportunity oppy = new Opportunity();
            oppy.Id = oppyId;
            if(String.valueOf(map_oppyId_oppTeamName.get(oppyId)).length() >= 255) {
                oppy.Opportunity_Sales_Team__c = String.valueOf(map_oppyId_oppTeamName.get(oppyId)).substring(0,255);
            }else {
                oppy.Opportunity_Sales_Team__c = map_oppyId_oppTeamName.get(oppyId);
            }
            list_oppys.add(oppy);
        }
  		
  		return list_oppys;
    }
}