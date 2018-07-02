/**
 *  Contains a set of static methods used PMV Teav View pages
 *
 @author Bin Yuan
 @created 2014-03-10
 @version 1.0
 @since 29.0 (Force.com ApiVersion)
 *
 @changelog
 * 2014-03-10 Bin Yuan <bin.yuan@itbconsult.com>
 * - Created
 * 2015-01-21 Bin Yuan <bin.yuan@itbconsult.com>
 * - Modified by bin yuan  2015-01-21 due to SPIN Selling Story#: D-441 to exclude lost and dead opportunities from the team view display
 */
public without sharing class CtrlPMVTeamView {
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    transient public LocaleConfig lc {get; set;}
    /**
     * map to store date range.
     */
    transient public list<ClsPMVTeamViewUtil.DateRangeType> list_dateRangeType {get; set;}
    transient public list<TeamViewObject> list_teamMembs {get; set;}
    transient public list<User> list_userForSearch				{get;set;}
    
    //transient public String str_stageMappingJson {get; set;}
    //transient public map<String, String> map_stage_teamViewColumn {get; set;}
    public static String DEFAULTDATE {get {return 'Next_N_Fiscal_Quarters:4';} set;}
    public static String OPDEFAULTDATE {get {return 'AllTime';} set;}
    public PageConfig pageConf {get; set;}
	public list<OppyViewObj> list_oppysForMemb {get; set;}
	public transient String set_teamMembIds {get; set;}
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private set<Id> set_rts = new set<Id>();
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
	public CtrlPMVTeamView(){
		try{
			this.lc = new LocaleConfig();
            this.pageConf = new PageConfig();
            this.list_dateRangeType = new list<ClsPMVTeamViewUtil.DateRangeType>();
            this.list_oppysForMemb = new list<OppyViewObj>();
            //this.str_stageMappingJson = '';
            //this.map_stage_teamViewColumn = new map<String, String>();
            init();
			set_rts = ClsPMV_Util.getAllPMVRecordtypes();
		}catch(Exception e){
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, e+''));
        }
		
	}
	/////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
   /**
    * This method is used to get page controller
    *
    @author Bin Yuan
    @created 2014-03-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public void init() {
    	
    	ClsPMVTeamViewUtil.generateDateRange(list_dateRangeType);
        //get stage mapping from custom setting
        //map<String, String> map_stage_teamViewColumn = new map<String, String>();
        //ClsPMVTeamViewUtil.getStageMapping(map_stage_teamViewColumn);
        //this.str_stageMappingJson = Json.serialize(map_stage_teamViewColumn);
        ClsPMVTeamViewUtil.getBigOppyAmountFromCustomsetting(pageConf);
    //    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'pageConf.bigOppyDataJson :: ' + pageConf.bigOppyDataJson));
    }
   /**
    * This method is used to get page controller
    *
    @author Bin Yuan
    @created 2014-03-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public CtrlPMVTeamView getThis(){
    	return this;
    }

   /**
    * This method is used to get Team member table header
    *
    @author Bin Yuan
    @created 2014-03-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public list<TeamColumns> getTeamColumns(){
        map<String, String> map_stage_teamViewColumn = new map<String, String>();
        ClsPMVTeamViewUtil.getStageMapping(map_stage_teamViewColumn);
    	list<TeamColumns> list_teamField = new list<TeamColumns>{
    		new TeamColumns(system.label.PMV_team_table_name, 'name', 'w1 tl', ''), 
    		new TeamColumns(system.label.PMV_team_table_converted, 'converted', 'w2 team_bl converted tr', map_stage_teamViewColumn.get('Converted')), 
    		new TeamColumns(system.label.PMV_team_table_won, 'won', 'w3 team_bl won tr', map_stage_teamViewColumn.get('Won')), 
    		new TeamColumns(system.label.PMV_team_table_convertedwon, 'cwon', 'w4 team_bl cwon tr', ''), 
    		new TeamColumns(system.label.PMV_team_table_pipeline, 'pending', 'w5 team_bl pipeline tr', map_stage_teamViewColumn.get('Pending')), 
    		new TeamColumns(system.label.PMV_team_table_total, 'total', 'w6 team_bl total tr', ''), 
    		new TeamColumns(system.label.PMV_team_onhold, 'hold', 'w7 team_bl hold tr', map_stage_teamViewColumn.get('On Hold')),
    		new TeamColumns(system.label.PMV_team_table_mix, 'mix', 'w8 team_bl tc miximg', ''), 
    		new TeamColumns(system.label.PMV_team_count, 'count', 'w9 team_bl tc countcls', '')
    	};
    	return list_teamField;
    }

   /**
    * This method is used to get Team member opportunity table header
    *
    @author Bin Yuan
    @created 2014-03-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    * 
    *
    @changelog
    * 2014-03-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public list<OppyColumns> getOppyColumns(){
    	list<OppyColumns> list_oppyField = new list<OppyColumns>{
    		new OppyColumns(system.label.PMV_team_opp_table_Account, 'o1 tl', 'acctname', 'Account.Name', true), 
    		new OppyColumns(system.label.PMV_team_opp_table_name, 'o2 team_bl tl', 'oppyname', 'Name', true), 
    		new OppyColumns(system.label.PMV_team_opp_table_process, 'o3 team_bl tl', 'process', '', true), 
    		new OppyColumns(system.label.PMV_team_opp_table_stage, 'o4 team_bl tl', 'stage', 'StageName', true), 
    		new OppyColumns(system.label.PMV_team_opp_table_progress, 'o5 team_bl tc', 'progress', '', false), 
    		new OppyColumns(system.label.PMV_team_opp_table_enddate, 'o6 team_bl tl', 'enddate', 'Projected_Close_Date__c', true), 
    		new OppyColumns(system.label.PMV_team_opp_table_percentage, 'o7 team_bl tr', 'precntage', '', true),
    		new OppyColumns(system.label.PMV_team_opp_table_amount, 'o8 team_bl tr', 'amount', 'Amount', true), 
    		new OppyColumns(system.label.PMV_team_opp_table_total_amount, 'o8 team_bl tr', 'totalAmount', '', true), 
    		new OppyColumns(system.label.PMV_team_opp_table_size, 'o9 team_bl tc', 'size', '', true),
    		new OppyColumns(system.label.PMV_team_opp_table_health, 'o10 team_bl tc', 'health', '', true),
    		new OppyColumns(system.label.PMV_team_opp_table_projected, 'o11 team_bl tc', 'projected', '', true)
    	};
    	return list_oppyField;
    }

   /**
    * This method is used to get Team for current user
    *
    @author Bin Yuan
    @created 2014-03-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public list<TeamView_Team__c> getListTeams(){
        list<TeamView_Team__c> list_teams = new list<TeamView_Team__c>();
        ClsPMVTeamViewWithSharingUtil.getTeamViewTeams(list_teams);
        return list_teams;
    }

   /**
    * This method is used to get Team members for selected team
    *
    @author Bin Yuan
    @created 2014-03-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public void getTeamMembs() {
        //list<User> list_user = new list<User>();
        try{
        	//String str_teamMembIdFilter = ClsPMVTeamViewUtil.generateStringForSet(set_rts);
	        set_teamMembIds = '';
	        set<String> set_membIds = new set<String>();
	        this.list_teamMembs = new list<TeamViewObject>();
	        map<String, String> map_queryKey_query = new map<String, String>();
	        ClsPMV_Util.getUserListbyTeamViewId(pageConf.selectedTeamId, this.list_teamMembs, set_membIds);
	        //ClsPMVTeamViewUtil.getQueryForTeamMembs(set_membIds, pageConf, map_queryKey_query);
	        //pageConf.teamMembQueryJson = (map_queryKey_query.isEmpty() ? '' : Json.serialize(map_queryKey_query));
	        set_teamMembIds = json.serialize(set_membIds);
			//ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'set_teamMembIds :: ' + set_teamMembIds));
        	
        }catch(Exception e){
	        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, e+''));
        	ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, e.getStackTraceString()));
        	
        }
    }
    
   /**
    * This method is used to get Team members for selected team
    *
    @author Bin Yuan
    @created 2014-03-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    @ReadOnly
    @RemoteAction
    public static String getForecastRecords(String str_memberIdsJson, String str_queryObj) {
        //list<User> list_user = new list<User>();
    	set<String> set_membIds = (set<String>) Json.deserialize(str_memberIdsJson, set<String>.class);
    	DatePicker dateInfo = (DatePicker) Json.deserializeStrict(str_queryObj, DatePicker.class);
    	return ClsPMVTeamViewUtil.getForecastRecords(set_membIds, dateInfo);
    }
    
    @ReadOnly 
    @RemoteAction 
    public static string getAllOpportunityForTeam(String str_memberIdsJson, String str_queryObj){
    	set<String> set_membIds = (set<String>) Json.deserialize(str_memberIdsJson, set<String>.class);
    	DatePicker dateInfo = (DatePicker) Json.deserializeStrict(str_queryObj, DatePicker.class);
    	return ClsPMVTeamViewUtil.getOppysForMemb(set_membIds, dateInfo);
    }
    
   /**
    * This method is used to get Team members for selected team
    *
    @author Bin Yuan
    @created 2014-03-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    @ReadOnly
    @RemoteAction
    public static String getForecastMixRecords(String str_memberIdsJson, String str_queryObj) {
    	set<String> set_membIds = (set<String>) Json.deserialize(str_memberIdsJson, set<String>.class);
    	DatePicker dateInfo = (DatePicker) Json.deserializeStrict(str_queryObj, DatePicker.class);
    	return ClsPMVTeamViewUtil.getForecastMixRecords(set_membIds, dateInfo);
    }
    
   /**
    * This method is used to get opportunitys for selected Team members and selected date
    *
    @author Bin Yuan
    @created 2014-03-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    //@readOnly
    public void searchOppysForMemb() {
    	try{
	   //     ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'pageConf.dateInfoJson :: ' + pageConf.dateInfoJson)); 
	        this.list_oppysForMemb.clear();
	        //ClsPMVTeamViewWithSharingUtil.getOppysForMemb(this.list_oppysForMemb, pageConf);
	        //Move from util class to ctrl class due to use with sharing
			DatePicker dateInfo = (DatePicker) Json.deserializeStrict(pageConf.dateInfoJson, DatePicker.class);
			//system.debug('dateInfo:::'+dateInfo);
			if(dateInfo.selectedMembId == null || dateInfo.selectedMembId == '') {
				return;
			}
            if((dateInfo.oppick == 'Custom' || dateInfo.oppick == null) && dateInfo.opstart == null && dateInfo.opend == null) {
             //dateInfo.oppick = 'THIS_FISCAL_YEAR'; Comment by bin yuan 2014-04-14 due to 
             dateInfo.oppick = 'AllTime';
            }
            if((dateInfo.fcpick == 'Custom' || dateInfo.fcpick == null) && dateInfo.fcstart == null && dateInfo.fcend == null) {
             dateInfo.fcpick = 'Next_N_Fiscal_Quarters:4';
            }
			map<Id, String> map_businessProcessId_name = new map<Id, String>();
			list<Opportunity> list_oppys = new list<Opportunity>();			
			
	    	String str_query = ' Select Id, CurrencyIsoCode, Name, Account.Id, Account.Name, Five_Year_Revenue__c, StageName, RecordType.BusinessProcessId, Projected_Close_Date__c, PMV_Type__c, '
	    					 + 'Amount, All_Stage_Color__c, Overall_Process__c, Overall_Health_Status__c, Sales_Processes_Name__c, Overall_Health_Comment__c, Summary_Ability__c, Summary_Attractiveness__c '
                             + ' From Opportunity ';

	    	String str_where = ' Where ';
	    	String str_filter = ' OwnerId = \'' + dateInfo.selectedMembId + '\'';
            str_filter += (pageConf.lastQueryId == '' ? '' : 'And Id >= \'' + pageConf.lastQueryId + '\'');
            str_filter += ((dateInfo.oppick != 'Custom' && dateInfo.oppick != 'AllTime')? ' And Projected_Close_Date__c = ' + dateInfo.oppick : '');
            str_filter += (dateInfo.opstart != null ? ' And Projected_Close_Date__c >= ' + dateInfo.opstart : '');
            str_filter += (dateInfo.opend != null ? ' And Projected_Close_Date__c <= ' + dateInfo.opend : '');

			str_filter += ClsPMVTeamViewUtil.multitpleEntries('GAM_Code__c', dateInfo.gamcode);
            str_filter += ClsPMVTeamViewUtil.multitpleEntries('KAM_Code__c', dateInfo.kamcode);
            str_filter += ClsPMVTeamViewUtil.multitpleEntries('AM_Code__c', dateInfo.amcode);
			
	        /*str_filter +=  ' And Id IN ( Select Opportunity__c From Opportunity_Forecast__c where id != null ';
            str_filter += ((dateInfo.fcpick != 'Custom' && dateInfo.fcpick != 'AllTime') ? ' And Date__c = ' + dateInfo.fcpick : '');

            str_filter += (dateInfo.fcstart != null ? ' And Date__c >= ' + dateInfo.fcstart : '');
            str_filter += (dateInfo.fcend != null ? ' And Date__c <= ' + dateInfo.fcend : '');
			str_filter += ' And Part__r.Status__c != \'Lost\' And Part__r.Status__c != \'Dead\' ';
			str_filter += ' And Opportunity__r.StageName != \'Lost\' And Opportunity__r.StageName != \'Dead\' ';
			str_filter += ' And RecordType.DeveloperName = \'Part\' ';
            str_filter += ' ) ';*/ //Remove forecast filter for seaching Opportunity by Jinbo Shan at 2014-06-03
            str_filter += ' And RecordTypeId in : set_rts and PMV_Type__c != null ';
            //added by bin yuan  2015-01-21 due to SPIN Selling Story#: D-441 to exclude lost and dead opportunities from the team view display
			str_filter += ' And StageName != \'Lost\' And StageName != \'Dead\' ';
			//End
            str_filter += ' order by id asc ';
	    	str_query += (str_where + str_filter );
	    	str_query = str_query.replaceAll('00:00:00', '');
	    	//ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'set_rts :: ' + set_rts));
	    	//ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'str_query :: ' + str_query));
            for(Opportunity oppy : database.query(str_query)) {
                list_oppys.add(oppy);
                pageConf.lastQueryId = oppy.Id;
            }
	    	ClsPMVTeamViewUtil.generateOppyViewObjs(list_oppys, list_oppysForMemb, dateInfo);
	    	
            pageConf.isLastPage = (this.list_oppysForMemb.size() == 1000 ? false : true);
            pageConf.lastQueryId = (pageConf.isLastPage ? '' : pageConf.lastQueryId);
    		
    	}catch(Exception e){
    		pageConf.isLastPage=true;
	        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, e+''));
        }
    }
    
    /**
    * This method is used to show edit or new popup
    *
    @author Jinbo Shan
    @created 2014-03-20
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-20 Jinbo Shan <jinbo.shan@itbconsult.com>
    * - Created
    */
    public void showTeamMembers() {
    	this.list_userForSearch = new list<User>();
    	set<Id> set_userids = new set<Id>();
    	for(TeamView_Team__c tvt : [SELECT Id, Team_Member_User_IDs__c FROM TeamView_Team__c 
								   WHERE Id = : pageConf.teamViewId limit 1]){
			if(tvt.Team_Member_User_IDs__c != null && tvt.Team_Member_User_IDs__c !=''){
				set_userids = (splitString(tvt.Team_Member_User_IDs__c, ','));
			}
		}
		
		if(!set_userids.isEmpty()){
			for(User user : [SELECT Id, Name FROM User WHERE Id IN :set_userIds AND IsActive = true]){
	 			list_userForSearch.add(user);
	 		}
		}
    }
    
    
	/**
    * This method is used to save one TeamView
    *
    @author Jinbo Shan
    @created 2014-03-20
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-20 Jinbo Shan <jinbo.shan@itbconsult.com>
    * - Created
    */
	@RemoteAction
    public static String saveTeamAndMembers(String teamAttr, String teamDescription) {
    	TeamObject to = (TeamObject)Json.deserialize(teamAttr, CtrlPMVTeamView.TeamObject.class);
    	
    	TeamView_Team__c tvt = new TeamView_Team__c();
    	
    	if(to.id != ''){
	    	for(TeamView_Team__c t : [SELECT Id, Team_Name__c, Description__c, Team_Member_User_IDs__c 
	    							  FROM TeamView_Team__c Where Id =: to.id limit 1]){
	    		tvt=t;
	    	}
    	}
    	tvt.Team_Name__c=to.name;
    	tvt.Description__c=teamDescription;
    	tvt.Team_Member_User_IDs__c=to.struserids;

		upsert tvt;
    	to.id = tvt.Id;
    	
        return Json.serialize(to);
    }
    
	@RemoteAction
    public static String searchUsers(String username) {
    	list<User> list_users = new list<User>();
    	username=('%' + username + '%');
    	for(User u : [SELECT Id, Name FROM User  WHERE Name like :username AND IsActive = true]){
    		list_users.add(u);
    	}
    	
        return Json.serialize(list_users);
    }
    /**
    * This method is used to get all ownerIds of Opportunities for GAM_Code__c
    *
    @author Jinbo Shan
    @created 2014-03-20
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-20 Jinbo Shan <jinbo.shan@itbconsult.com>
    * - Created
    */
    @RemoteAction 
    public static String getOwnersForGAMCode(string GAMCode) {
    	list<User> list_users = new list<User>();
    	set<Id> set_userIds = new set<Id>();
    	GAMCode = ('%' + GAMCode + '%');
    	for(Opportunity oppy : [SELECT Id, OwnerId FROM Opportunity WHERE GAM_Code__c like : GAMCode]) {
    		set_userIds.add(oppy.OwnerId);
    	}
    	
    	for(User u : [SELECT Id, Name FROM User  WHERE Id IN : set_userIds AND IsActive = true]) {
    		list_users.add(u);
    	}
    	return Json.serialize(list_users);
    }
    
	
    /**
    * This method is used to search User by FirstName and LastName
    *
    @author Jinbo Shan
    @created 2014-03-20
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-20 Jinbo Shan <jinbo.shan@itbconsult.com>
    * - Created
    */
    public void searchUserByFNameAndLName(){
    	this.list_userForSearch = new list<User>();
		string fName, lName;
		
		if(pageConf.firstName == null){
			fName = '%%';
		}else {
			fName = '%' + pageConf.firstName + '%';
		}
		
		if(pageConf.lastName == null){
			lName = '%%';
		}else {
			lName = '%' + pageConf.lastName + '%';
		}
		
		for(User user : [SELECT Id, FirstName, LastName, Name, Profile.Name, UserRole.Name FROM User 
						 WHERE FirstName like :fName 
						 AND LastName like :lName AND IsActive = true order by FirstName, LastName]){
			this.list_userForSearch.add(user);
		}
	}
	
    /**
    * This method is used to delete TeamView record
    *
    @author Jinbo Shan
    @created 2014-03-20
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-20 Jinbo Shan <jinbo.shan@itbconsult.com>
    * - Created
    */
    @RemoteAction
    public static String delTeamView(String teamId){
    	Boolean issuccess=false;
    	String errstatuscode='', errmsg='';
    	
    	Database.DeleteResult dResult = Database.delete(teamId, false);
    	
    	if(dResult.isSuccess()){
    		issuccess=true;
    	}else{
    		for(Database.Error err : dResult.getErrors()) {	 // Operation failed, so get all errors  
	        	errstatuscode = err.getStatusCode()+'';
	        	errmsg = err.getMessage();
	        }
    	}
    	
    	return ('{"id":"'+teamId+'", "issuccess":'+issuccess+', "errstatuscode": "'+errstatuscode+'", "errmsg":"'+errmsg+'"}');
    }
    
	//********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
	/**
    * This method is used to split string by delimiter
    *
    @author Jinbo Shan
    @created 2014-03-20
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-20 Jinbo Shan <jinbo.shan@itbconsult.com>
    * - Created
    */
    private set<Id> splitString(string beforeString, string delimiter){
		set<Id> set_after = new set<Id>();
		if(beforeString != null && delimiter != null){
			if(beforeString.contains(delimiter)){
				for(string afterString : beforeString.split(delimiter)){
					set_after.add((Id)afterString.trim());
				}
			}else{
				set_after.add((Id)beforeString.trim());
			}
		}
		return set_after;
	}
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
	//********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>WrapperClass*/
    public class PageConfig {
        public String selectedTeamId {get; set;}
        public String dateInfoJson {get; set;}
        public String dateInfoJsonForSearch {get; set;}
        public String teamMembQueryJson {get; set;}
        public String bigOppyDataJson {get; set;}
        public double avgAmount {get; set;}
        public double bigOppyAmountThreshold {get; set;}
        public double bigOppyCountThreshold {get; set;}
        public boolean isLastPage {get; set;}
        public String lastQueryId {get; set;}
        //added by Jinbo Shan for edit and new function

    	public string teamViewId	{get;set;}
    	public string firstName								{get;set;}
		public string lastName								{get;set;}
    	
    	
        public PageConfig() {
            this.selectedTeamId = '';
            this.dateInfoJson = Json.serialize(new DatePicker()) ;
            this.teamMembQueryJson = '';
            this.bigOppyDataJson = '';
            this.avgAmount = 0;
            this.bigOppyAmountThreshold = 0;
            this.bigOppyCountThreshold = 0;
            this.isLastPage = false;
            this.lastQueryId = '';
            this.dateInfoJsonForSearch = '';
            this.teamViewId = '';
            this.firstName = '';
        }

    }
    public class DatePicker {
    	public String selectedMembId {get; set;}
        public String oppick {get; set;}
        public String fcpick {get; set;}
        public Date opstart {get; set;}
        public Date opend {get; set;}
        public Date fcstart {get; set;}
        public Date fcend {get; set;}
        public string gamcode	{get;set;}//added new filters by Jinbo Shan at 2014-06-04
        public string kamcode	{get;set;}//added new filters by Jinbo Shan at 2014-06-04
        public string amcode	{get;set;}//added new filters by Jinbo Shan at 2014-06-04
        
        public String orderField {get; set;}
        public String orderASC {get; set;}
    }
    public class LocaleConfig{
        public String locale {get;set;}
        public String jsPath {get;set;}
        
        public LocaleConfig(){
            try{
                this.locale= userInfo.getLocale();
                list<String> list_s = this.locale.split('_');
                this.locale = list_s[0]+'-'+list_s[1];
            }catch(Exception e){
                this.locale = 'de-DE';
            }   
            this.jsPath = '/glob-cultures/cultures/globalize.culture.'+this.locale+'.js';
        }
    }
    
    
    public class OppyColumns{
    	public String name {get;set;}
    	public String cls {get;set;}
    	public String fieldName {get; set;} 
    	public String apiName {get; set;}
    	public Boolean isOrderBy{get;set;}
    	public OppyColumns(String name, String cls, String fieldName, String apiName, Boolean isOrderBy){
    		this.name=name;
    		this.cls=cls;
    		this.fieldName = fieldName;
    		this.apiName = apiName;
    		this.isOrderBy = isOrderBy;
    	}
    }
    
    public class TeamColumns{
    	public String name {get;set;}
    	public String fieldName {get;set;}
    	public String cls {get;set;}
        public String matchName {get; set;}
    	public TeamColumns(String name, String fieldName, String cls, String matchName){
    		this.name=name;
    		this.fieldName=fieldName;
    		this.cls=cls;
            this.matchName = matchName;
    	}
    	
    }

    public class TeamViewObject{
    	public String id {get;set;}
        public String roleid {get; set;}
    	public String name {get;set;}
    	public String converted {get;set;}
    	public String won {get;set;}
    	public String cwon {get;set;}
    	public String pending {get;set;}
    	public String total {get;set;}
    	public String hold {get;set;}
    	public String mix {get;set;}
    	public String count {get;set;}
    	public TeamViewObject(String id, String roleid, String name, String converted, String won, String cwon, String pending, 
    						  String total, String hold, String mix, String count){
    		this.id = id;
            this.roleid = roleid;
    		this.name = name;
    		this.converted = converted;
    		this.won = won;
    		this.cwon = cwon;
    		this.pending = pending;
    		this.total = total;
    		this.hold = hold;
    		this.mix = mix;
    		this.count = count;
    	}
    }
	public class OppyViewObj {
		public String id {get; set;}
		public String acctid {get; set;}
		public String acctname {get; set;}
		public String oppyname {get; set;}
		public String process {get; set;}
		public String stage {get; set;}
		public String progress {get; set;}
		public Date enddate {get; set;}
		public String precntage {get; set;}
		public decimal amount {get; set;}
		public decimal totalAmount {get; set;}
		public decimal originalAmount;
		public String size {get; set;}
		public String health {get; set;}
		public String projected {get; set;}
		public String healthComt {get; set;}
		public decimal SumAtt	{get;set;}
		public decimal SumAbility	{get;set;}
		public OppyViewObj() {
			this.id = '';					
			this.acctid = '';					
			this.acctname = '';					
			this.oppyname = '';					
			this.process = '';					
			this.stage = '';					
			this.progress = '';					
			this.enddate = null;					
			this.precntage = '';					
			this.amount = 0;	
			this.totalAmount = 0;	
			this.originalAmount = 0;			
			this.size = '';					
			this.health = '';					
			this.projected = '';
            this.healthComt = '';	
            this.SumAtt = 0;
            this.SumAbility = 0;	
		}
	}
	
    public class CustomOppy {
    	public Opportunity oppy {get; set;}
    }
    
    
    public class TeamObject{
    	public String id {get;set;}
    	public String name {get;set;}
    	public String description {get;set;}
    	public String struserids{get;set;}
    }
    
	///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
}