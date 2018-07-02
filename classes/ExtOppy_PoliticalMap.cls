/**
 *  This class is used to ExtOppy_PoliticalMap page.
 *  
 * @author Jinbo Shan
 * @created 2014-04-21
 * @version 1.0
 * @since 29.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2014-04-21 Jinbo Shan <jinbo.shan@itbconsult.com>
 * - Created   
 *
 */
public with sharing class ExtOppy_PoliticalMap {
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	public Opportunity opportunity  							{get;set;}
	public Account acc											{get;set;}
	public boolean isPMVOppy 									{get;set;}
	public list<Influencer__c> list_infs; 						
	public String list_infsToString 							{get;set;}
	
	public String list_consToString								{get;set;}
	public string list_keyPlayersToString						{get;set;}
	public Integer countPoliticalMaps							{get;set;}
	public boolean hasAccessEdit								{get;set;}
	public integer questionNum									{get;set;}
	public integer answerNum									{get;set;}
	public Integer countDecisionCriteria        				{get;set;}
	public Contact cont											{get;set;}
	public string contactString									{get;set;}
	public string list_accsString									{get;set;}
	//public list<ContactCls> list_cons							{get;set;}
	//public list<KeyPlayerCls> list_keyPlayers					{get;set;}
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private ApexPages.standardController stdCtrl;
    private map<Id, Custom_Opportunity_Contact_Role__c> map_conId_cocr;
	private list<ContactCls> list_cons;		
	private list<KeyPlayerCls> list_keyPlayers;			
	private set<Id> set_accIds;			
	private list<Account> list_accs;
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
	public ExtOppy_PoliticalMap(ApexPages.StandardController stdCtrl) {
		this.cont = new Contact();
		this.questionNum = 0;
		this.countDecisionCriteria = 0;
		this.answerNum = 0;
		this.stdCtrl = stdCtrl;
		this.isPMVOppy = true;
		this.hasAccessEdit = true;
		this.countPoliticalMaps = 0;
		this.set_accIds = new set<Id>();
		this.list_accs = new list<Account>();
        Opportunity oppyTemp = (Opportunity)stdCtrl.getRecord();
        set<Id> set_rts = ClsPMV_Util.getAllPMVRecordtypes();
        list_infs = new list<Influencer__c>();
        map_conId_cocr = new map<Id, Custom_Opportunity_Contact_Role__c>();
        list_cons = new list<ContactCls>();
        list_keyPlayers = new list<KeyPlayerCls>();
        
        if(oppyTemp != null){
            for(Opportunity oppy : [SELECT Id, Name, PMV_Type__c, Buying_Cycle__c, Lost_Rejected_Dead_On_Hold_Reason__c, RecordTypeId, 
	                              Pause_Reactivation_Date__c,Competitor__c, Probability, StageName, Other_Description__c, 
	                              Concept_Start_Date__c, CloseDate, RecordType.BusinessProcessId, Projected_Close_Date__c, 
	                              Amount, Overall_Health_Status__c, Overall_Health_Comment__c, Buying_Cycle_Comment__c, 
	                              Stage_Change_Error_Message__c, Five_Year_Revenue__c, AccountId 
	                              FROM Opportunity 
	                              WHERE Id = :oppyTemp.Id]){
            	this.opportunity = oppy;	
            }
            
            if(opportunity != null ){
            	if(!ClsPMV_Util.checkEditAccessForSObject(UserInfo.getUserId(), opportunity.Id)){
            		hasAccessEdit = false;
            	}
            	
            	this.countDecisionCriteria = ClsPMV_Util.calculateDecisionCriteriaNum(opportunity.Id);
            	
            	this.questionNum = ClsPMV_Util.calculateNumOfQuestion(opportunity);
            	
            	this.answerNum = ClsPMV_Util.calculateNumOfAnswer(opportunity);
            	
            	if(set_rts.contains(opportunity.RecordTypeId) && opportunity.PMV_Type__c != null){
	                init();
	            }else{
	                isPMVOppy = false;
	            }
            }
        }
	}
	
	//init data
	public void init(){
		
		for(Account accTemp : [select Id, Name, Account_Combined_Data__c from Account where Id = : opportunity.AccountId]){
			acc = accTemp;
		}
		
		for(Influencer__c inf : [SELECT Contact_Influencing__c, Contact_influenced__c, 
								Opportunity__c, Id 
								FROM Influencer__c 
								WHERE Opportunity__c = : opportunity.Id 
								And IsDeleted = false 
								AND Contact_Influencing__c != null 
								AND Contact_influenced__c != null]){
			list_infs.add(inf);
		}
		
		list_infsToString = JSON.serialize(list_infs);
						
		for(Custom_Opportunity_Contact_Role__c cocr : [SELECT Contact__c, Opportunity__c, 
														Primary__c, Id, Role__c, Focus_Point__c 
					 								  	FROM Custom_Opportunity_Contact_Role__c 
					 								  	WHERE Opportunity__c = : opportunity.Id 
					 								  	And IsDeleted = false 
					 								  	AND Contact__c != null]){
			map_conId_cocr.put(cocr.Contact__c, cocr);	 
		}
			
		for(Contact con : [SELECT Id, ReportsToId, Name, FirstName, LastName, Salutation, AccountId, 
							Position_Type__c, Department_Type__c, NPS_Status__c // Opinion__c, Coverage_Indicator__c, Political_Status__c, Adaptability__c
						  	FROM Contact where AccountId != null and Id IN : map_conId_cocr.keySet() and Inactive__c = false]){ //AccountId = : opportunity.AccountId
			set_accIds.add(con.AccountId);
		} 
		
		if(!set_accIds.contains(acc.Id)){
			set_accIds.add(acc.Id);
		}
		
		for(Contact con : [SELECT Id, ReportsToId, ReportsTo.Name, ReportsTo.AccountId, Name, FirstName, LastName, Salutation, AccountId, 
							Position_Type__c, Department_Type__c, NPS_Status__c // Opinion__c, Coverage_Indicator__c, Political_Status__c, Adaptability__c
						  	FROM Contact where AccountId IN : set_accIds and Inactive__c = false]) {
		 	ContactCls conCls = new ContactCls();
			conCls.accId = con.AccountId;
			if(map_conId_cocr.containsKey(con.Id)){
				conCls.isOppyRole = true;
				conCls.focusPoint = map_conId_cocr.get(con.Id).Focus_Point__c;
				conCls.customOppyContactRoleId = map_conId_cocr.get(con.Id).Id;
				this.countPoliticalMaps += 1;
			}
			
			conCls.NPSStatus = con.NPS_Status__c;
			conCls.conId = con.Id;
			conCls.salutation = con.Salutation;
			conCls.firstName = con.FirstName;
			conCls.lastName = con.LastName;
			conCls.positionType = con.Position_Type__c;
			conCls.departmentType = con.Department_Type__c;
			if(con.ReportsTo.AccountId == con.AccountId) {
				conCls.reportsToId = con.ReportsToId;
			}else {
				conCls.reportToName = con.ReportsTo.Name;
			}
			list_cons.add(conCls);	
		}
		
		
		for(Account accTemp : [select Id, Name, Account_Combined_Data__c from Account where Id IN : set_accIds order by Account_Combined_Data__c]) {
			list_accs.add(accTemp);
		}
		
		for(Key_Player_Criteria__c kpc : [select Id, Priority__c, Key_Player__c, Key_Player__r.Custom_Opportunity_Contact_Role__r.Contact__c, Decision_Criteria__r.Question_English__c from Key_Player_Criteria__c where Key_Player__r.Opportunity__c = :opportunity.Id and Decision_Criteria__r.Active__c = true order by Decision_Criteria__r.Name]){
			KeyPlayerCls cls = new KeyPlayerCls();
			cls.conId = kpc.Key_Player__r.Custom_Opportunity_Contact_Role__r.Contact__c;
			cls.decisionCriteriaName = kpc.Decision_Criteria__r.Question_English__c;
			cls.priority = kpc.Priority__c;
			list_keyPlayers.add(cls);
		}
		list_keyPlayersToString = JSON.serialize(list_keyPlayers);
		list_accsString = JSON.serialize(list_accs);
		list_consToString = JSON.serialize(list_cons);
	}
	
	public ExtOppy_PoliticalMap getThis(){
    	return this;
    }
	
	//This is used to delete Influencer__c
	@RemoteAction 
	public static string deleteInf(Id oppyId, Id influencedConId, Id influencingConId){
		list<Influencer__c> list_infs = new list<Influencer__c>();
		
		for(Influencer__c inf : [select Id from Influencer__c where Opportunity__c = : oppyId and Contact_influenced__c = : influencedConId and Contact_Influencing__c = : influencingConId ]){
			list_infs.add(inf);
		}
		
		try {
			if(list_infs.size() > 0){
				delete list_infs;
			}
		} catch (exception e){
			return e.getMessage();
		}
		return 'success';
		
	}
	
	@RemoteAction 
	public static string createInf(Id oppyId, Id influencedConId, Id influencingConId){
		
		Influencer__c inf = new Influencer__c();
		inf.Opportunity__c = oppyId;
		inf.Contact_influenced__c = influencedConId;
		inf.Contact_Influencing__c = influencingConId;
		
		try {
			insert inf;
		} catch (exception e){
			return e.getMessage();
		}
		return 'success';
	}
	
	@RemoteAction 
	public static string deleteContactReportTo(Id reportedConId, Id reportingConId){
		list<Contact> list_cons = new list<Contact>();
		
		for(Contact con : [SELECT Id, ReportsToId FROM Contact WHERE Id = : reportingConId]){
			if(con.ReportsToId == reportedConId){
				con.ReportsToId = null;
				list_cons.add(con);
			}
		}
		
		try {
			if(list_cons.size() > 0){
				update list_cons;
			}
		} catch (exception e){
			return e.getMessage();
		}
		return 'success';
		
	}
	
	@RemoteAction 
	public static string createContactReportTo(Id reportedConId, Id reportingConId){
		list<Contact> list_cons = new list<Contact>();
		
		for(Contact con : [SELECT Id, ReportsToId FROM Contact WHERE Id = : reportingConId]){
			con.ReportsToId = reportedConId;
			list_cons.add(con);
		}
		
		try {
			if(list_cons.size() > 0){
				update list_cons;
			}
		} catch (exception e){
			return e.getMessage();
		}
		return 'success';
	}
	
	@RemoteAction 
	public static string deleteContactRole(Id oppyId, Id conId){
		list<Custom_Opportunity_Contact_Role__c> list_conRoles = new list<Custom_Opportunity_Contact_Role__c>();
		
		for(Custom_Opportunity_Contact_Role__c conRole : [select Id, Opportunity__c, Contact__c 
														 from Custom_Opportunity_Contact_Role__c 
														 where Contact__c = : conId 
														 and Opportunity__c = : oppyId]){
			list_conRoles.add(conRole);
		}
		
		try {
			if(list_conRoles.size() > 0){
				delete list_conRoles;
			}
		} catch (exception e){
			return e.getMessage();
		}
		return 'success';
	}
	
	@RemoteAction 
	public static string createContactRole(Id oppyId, Id conId, string focusPoint){
		list<Custom_Opportunity_Contact_Role__c> list_cocrs4update = new list<Custom_Opportunity_Contact_Role__c>();
		
		string conName;
		for(Contact con : [select Id, Full_Name__c from Contact where Id = :conId]) {
			conName = con.Full_Name__c;
		}
		
		boolean hasRecord = false;
		try {
			for(Custom_Opportunity_Contact_Role__c cocr : [select Id, Focus_Point__c 
															from Custom_Opportunity_Contact_Role__c 
															where Opportunity__c = : oppyId 
															AND Contact__c = :conId]){			
				hasRecord = true;
				cocr.Focus_Point__c = focusPoint;
				list_cocrs4update.add(cocr);
			}
			if(list_cocrs4update.size() > 0){
				update list_cocrs4update;
			}
			if(!hasRecord){
				Custom_Opportunity_Contact_Role__c conRole = new Custom_Opportunity_Contact_Role__c();
				/*if(conName != null) {
					conRole.Name = conName;
				}*/
				conRole.Opportunity__c = oppyId;
				conRole.Contact__c = conId;
				conRole.Focus_Point__c = focusPoint;
				insert conRole;
			}
		} catch (exception e){
			return e.getMessage();
		}
		return 'success';
	}
	
	public void createContact(){
		try {
			Contact cont4insert = new Contact();
			cont4insert.AccountId = acc.Id;
			cont4insert.Salutation = cont.Salutation;
			cont4insert.FirstName = cont.FirstName;
			cont4insert.LastName = cont.LastName;
			cont4insert.Department_Type__c = cont.Department_Type__c;
			cont4insert.Position_Type__c = cont.Position_Type__c;
			insert cont4insert;
			ContactCls conCls = new ContactCls();
			conCls.NPSStatus = cont4insert.NPS_Status__c;
			conCls.conId = cont4insert.Id;
			conCls.salutation = cont4insert.Salutation;
			conCls.firstName = cont4insert.FirstName;
			conCls.lastName = cont4insert.LastName;
			conCls.positionType = cont4insert.Position_Type__c;
			conCls.departmentType = cont4insert.Department_Type__c;
			conCls.isOppyRole = false;
			contactString = JSON.serialize(conCls);
			list_cons.add(conCls);
			list_consToString = JSON.serialize(list_cons);
			cont = new Contact();
			
		} catch (exception e){
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, e+''));
        	ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, e.getStackTraceString()));
		}
	}
	
	public class ContactCls{
		public Id accId	{get;set;}
		public Id customOppyContactRoleId	{get;set;}
		public Id conId	{get;set;}
		public boolean isOppyRole	{get;set;}
		public string focusPoint	{get;set;}
		public string salutation	{get;set;}
		public string firstName	{get;set;}
		public string lastName	{get;set;}
		public string positionType	{get;set;}
		public string departmentType	{get;set;}
		public string reportsToId	{get;set;}
		public string NPSStatus	{get;set;}
		public string reportToName	{get;set;}
		
		public ContactCls(){
			isOppyRole = false;
		}
	}
	
	public class KeyPlayerCls {
		public Id conId	{get;set;}
		public string priority	{get;set;}
		public string decisionCriteriaName	{get;set;}
	}
	
}