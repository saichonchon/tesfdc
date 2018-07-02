/**
 *  This class is used to extoppy_dicisioncriteria page.
 *  
 * @author Weihang Li
 * @created 2014-03-14
 * @version 1.0
 * @since 23.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2014-03-14 Weihang Li <weihang.li@itbconsult.com>
 * - Created   
 *
 */
public without sharing class ExtOppy_DecisionCriteria {
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	public String oppyId {get;set;}
	public List<Decision_Criteria__c> list_deCriterias {get;set;}
	//public List<Key_Player__c> list_keyPlaers {get;set;}
	public List<criteriaEntry> list_entrys {get;set;}
	public Decision_Criteria__c deCriteria {get;set;}
	public Integer countDecisionCriteria{get;set;}
	public Integer countPoliticalMaps{get;set;}
	public Integer counter {get;set;}
	public Opportunity opportunity	{get;set;}
	public integer questionNum	{get;set;}
	public integer answerNum	{get;set;}
	public boolean hasAccessEdit	{get;set;}
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	public ExtOppy_DecisionCriteria(ApexPages.standardController stdCtrl){
		hasAccessEdit = true;
		countPoliticalMaps = 0;
		oppyId = stdCtrl.getId();
		list_deCriterias = new List<Decision_Criteria__c>();
		//list_keyPlaers = new List<Key_Player__c>();
		list_entrys = new List<criteriaEntry>();
		deCriteria = new Decision_Criteria__c();
		this.countDecisionCriteria = 0;
		this.questionNum = 0;
		this.answerNum = 0;
	
		set<Id> set_osIds4show = new set<Id>();
		set<string> set_spqaIds = new set<string>();
		
		if(oppyId != null){
           	for(Opportunity oppy : [SELECT Id, PMV_Type__c, RecordType.BusinessProcessId, AccountId 
            				  FROM Opportunity 
            				  WHERE Id = :oppyId ]){
           		this.opportunity = oppy;
           	}
			if(opportunity != null){
				
				if(!ClsPMV_Util.checkEditAccessForSObject(UserInfo.getUserId(), opportunity.Id)){
            		hasAccessEdit = false;
            	}
				
	            this.countPoliticalMaps = ClsPMV_Util.calculateContactRoleNum(opportunity.Id);
	            
	            this.questionNum = ClsPMV_Util.calculateNumOfQuestion(opportunity);
            	
            	this.answerNum = ClsPMV_Util.calculateNumOfAnswer(opportunity);
				
				for(Decision_Criteria__c de : [select Id, Name, Active__c, Comment__c, Opportunity__c, 
												Position__c, Question_English__c, 
												Decision_Criteria_Template__c, 
												Decision_Criteria_Template__r.Explanation_English__c 
												from Decision_Criteria__c 
												where Opportunity__c =: oppyId order by Name]){
					if(de.Active__c){
						list_deCriterias.add(de);
						list_entrys.add(new criteriaEntry(de,true));
					}
					else {
						list_entrys.add(new criteriaEntry(de,false));
					}
					this.countDecisionCriteria++;
				}
				
			}
		}
		counter = list_deCriterias.size();
	}
	
	//********************************* -=BEGIN public methods=- **********************************
	/**
	 *  This class is used to get keyplayer and key player detail.
	 *  
	 * @author Weihang Li
	 * @created 2014-03-14
	 * @version 1.0
	 * @since 23.0 (Force.com ApiVersion)  
	 * 
	 *
	 * @changelog
	 * 2014-03-14 Weihang Li <weihang.li@itbconsult.com>
	 * - Created   
	 *
	 */
	public List<Key_Player__c> getKeyPlayersList(){
		List<Key_Player__c> list_keys = new List<Key_Player__c>();
		
		for(Key_Player__c kp : [select Id, Name, Custom_Opportunity_Contact_Role__r.Contact__r.Name, Opportunity__c, Custom_Opportunity_Contact_Role__r.Contact__r.Inactive__c, 
								Custom_Opportunity_Contact_Role__r.Focus_Point__c, 
								(select Id, Name, Decision_Criteria__c, Decision_Criteria__r.Question_English__c, 
								Key_Player__c, Priority__c 
								from Key_Player_Criteria__r where Decision_Criteria__r.Active__c=true order by Priority__c) 
								from Key_Player__c 
								where Opportunity__c =: oppyId]){
			if(kp.Custom_Opportunity_Contact_Role__r.Focus_Point__c != null && (kp.Custom_Opportunity_Contact_Role__r.Focus_Point__c.contains('Focus of Dissatisfaction (FOD)') || kp.Custom_Opportunity_Contact_Role__r.Focus_Point__c.contains('Focus of Power (FOP)')) && kp.Custom_Opportunity_Contact_Role__r.Contact__r.Inactive__c == false){
				list_keys.add(kp);
			}
		}
		
		return list_keys;
	}
	/**
	 *  This class is used to save decision criteria.
	 *  
	 * @author Weihang Li
	 * @created 2014-03-14
	 * @version 1.0
	 * @since 23.0 (Force.com ApiVersion)  
	 * 
	 *
	 * @changelog
	 * 2014-03-14 Weihang Li <weihang.li@itbconsult.com>
	 * - Created   
	 *
	 */
	 @RemoteAction  
	 public static String saveAnwser(String deId,String position){
	 	try{
	 		Decision_Criteria__c dc = [select Id,Name,Active__c,Opportunity__c,Position__c,Question_English__c from Decision_Criteria__c where Id =: deId];
	 		dc.Position__c = position;
	 		update dc;
	 		return 'success';
	 	}catch(exception e) {
    		 return e.getMessage();
    	}	
	 }
	 /**
	 *  This class is used to save comment.
	 *  
	 * @author Weihang Li
	 * @created 2014-03-14
	 * @version 1.0
	 * @since 23.0 (Force.com ApiVersion)  
	 * 
	 *
	 * @changelog
	 * 2014-03-14 Weihang Li <weihang.li@itbconsult.com>
	 * - Created   
	 *
	 */
	 @RemoteAction 
	 public static String saveComents(String dId,String comment){
	     try{
	     	Decision_Criteria__c dc = [select Id,Name,Active__c,Opportunity__c,Position__c,Question_English__c from Decision_Criteria__c where Id =: dId];
	     	dc.Comment__c = comment;
	     	update dc;
	     	return 'success';
		 }catch(exception e){
		 	return e.getMessage();
		 }
	 }
	 /**
	 *  This class is used to save key player.
	 *  
	 * @author Weihang Li
	 * @created 2014-03-14
	 * @version 1.0
	 * @since 23.0 (Force.com ApiVersion)  
	 * 
	 *
	 * @changelog
	 * 2014-03-14 Weihang Li <weihang.li@itbconsult.com>
	 * - Created   
	 *
	 */
	 @RemoteAction 
	 public static String saveKeyPlayer(String kId,String proirity){
	 	try{
	 		Key_Player_Criteria__c kp = [select Id,Name,Decision_Criteria__c,Key_Player__c,Priority__c from Key_Player_Criteria__c where Id =: kId];
	 		kp.Priority__c = proirity;
	 		update kp;
	 		return 'success';
	 	}catch(exception e){
	 		return e.getMessage();
	 	}
	 }
	 /**
	 *  This class is used to add new criteria to list.
	 *  
	 * @author Weihang Li
	 * @created 2014-03-14
	 * @version 1.0
	 * @since 23.0 (Force.com ApiVersion)  
	 * 
	 *
	 * @changelog
	 * 2014-03-14 Weihang Li <weihang.li@itbconsult.com>
	 * - Created   
	 *
	 */
	 public void addCriteria(){
	 	if(deCriteria.Question_English__c != ''){
		 	Decision_Criteria__c de = new Decision_Criteria__c();
		 	de.Question_English__c = deCriteria.Question_English__c;
		 	de.Active__c = false;
		 	de.Opportunity__c = oppyId;
		 	de.Position__c = '2';
		 	insert de;
		 	list_entrys.add(new criteriaEntry(de,true));
	 	}
	 }
	  /**
	 *  This class is used to add select criterion.
	 *  
	 * @author Weihang Li
	 * @created 2014-03-14
	 * @version 1.0
	 * @since 23.0 (Force.com ApiVersion)  
	 * 
	 *
	 * @changelog
	 * 2014-03-14 Weihang Li <weihang.li@itbconsult.com>
	 * - Created   
	 *
	 */
	 public void addSelectRecords(){
	 	 if(!list_entrys.isEmpty()){
	 	 	List<Decision_Criteria__c> list_updateList = new List<Decision_Criteria__c>();
	 	 	List<Decision_Criteria__c> list_newList = new List<Decision_Criteria__c>();
	 	 	List<criteriaEntry> list_noAddList = new List<criteriaEntry>();
	 	 	for(Integer i = 0; i< list_entrys.size(); i++){
	 	 		if(list_entrys[i].isChecked){
	 	 			list_entrys[i].dc.Active__c = true;
	 	 			list_updateList.add(list_entrys[i].dc);
	 	 			list_newList.add(list_entrys[i].dc);
	 	 		}else{
	 	 			list_entrys[i].dc.Active__c = false;
	 	 			list_updateList.add(list_entrys[i].dc);
	 	 			
	 	 		}
	 	 		list_noAddList.add(list_entrys[i]);
	 	 	}
	 	 	list_entrys.clear();
	 	 	list_entrys.addAll(list_noAddList);
	 	 	if(!list_updateList.isEmpty()){
	 	 		update list_updateList;
	 	 		list_deCriterias.clear();
	 	 		list_deCriterias.addAll(list_newList);
	 	 	}
	 	 	counter = list_deCriterias.size();
	 	 }
	 } 
	 
	  /**
	 *  This method is run immediately after page is loaded. It creates key players and key player criterias
	 *  
	 * @author Yuanyuan Zhang
	 * @created 2014-03-21
	 * @version 1.0
	 * @since 27.0 (Force.com ApiVersion)  
	 * 
	 *
	 * @changelog
	 * 2014-03-21 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>
	 * - Created   
	 *
	 */
	 public void checkKeyPlayer(){
	 	//oppyId = stdCtrl.getId();
	 	system.debug('###oppyId: ' + oppyId);
	 	if(oppyId != null) ClsPMV_Util.checkContactRoleAndGenerateKeyPlayer(oppyId);
	 	
	 }
	 
	//********************************* -=END public methods=- **********************************
	public class criteriaEntry{
		public Decision_Criteria__c dc{get;set;}
		public boolean isChecked{get;set;}
		public criteriaEntry(Decision_Criteria__c de,boolean ischk){
			this.dc = de;
			this.isChecked = ischk;
		}
	}
}