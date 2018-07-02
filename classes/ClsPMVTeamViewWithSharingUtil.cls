/**
 *  With Sharing Util class for page CtrlPMVTeamView
 *
 @author    Bin Yuan
 @created   2014-03-11
 @version   1.0
 @since     29.0 (Force.com ApiVersion)
 *
 @changelog
 * 2013-09-18 Bin Yuan <bin.yuan@itbconsult.com>
 * - Created
 */
public with sharing class ClsPMVTeamViewWithSharingUtil {
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
   
    
    //********************************* -=BEGIN public methods=- **********************************
   /**
    * This method is used to get opportunitys for selected member
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void getOppysForMemb(list<CtrlPMVTeamView.OppyViewObj> list_oppysForMemb, CtrlPMVTeamView.PageConfig pageConf) {

		try {
			CtrlPMVTeamView.DatePicker dateInfo = (CtrlPMVTeamView.DatePicker) Json.deserializeStrict(pageConf.dateInfoJson, CtrlPMVTeamView.DatePicker.class);
			if(dateInfo.selectedMembId == null || dateInfo.selectedMembId == '') {
				return;
			}
            if((dateInfo.oppick == 'Custom' || dateInfo.oppick == null) && dateInfo.opstart == null && dateInfo.opend == null) {
             dateInfo.oppick = 'THIS_FISCAL_YEAR';
            }
            if((dateInfo.fcpick == 'Custom' || dateInfo.fcpick == null) && dateInfo.fcstart == null && dateInfo.fcend == null) {
             dateInfo.fcpick = 'THIS_FISCAL_YEAR';
            }
			map<Id, String> map_businessProcessId_name = new map<Id, String>();
			list<Opportunity> list_oppys = new list<Opportunity>();			
			
	    	String str_query = ' Select Id, Name, Account.Id, Account.Name, Five_Year_Revenue__c, StageName, RecordType.BusinessProcessId, Projected_Close_Date__c, PMV_Type__c'
	    					 + '         , All_Stage_Color__c, Overall_Process__c, Overall_Health_Status__c, Sales_Processes_Name__c, Overall_Health_Comment__c '
                             + ' From Opportunity ';

	    	String str_where = ' Where ';
	    	String str_filter = ' OwnerId = \'' + dateInfo.selectedMembId + '\'';
            str_filter += (pageConf.lastQueryId == '' ? '' : 'And Id >= \'' + pageConf.lastQueryId + '\'');
            str_filter += (dateInfo.oppick != 'Custom' ? ' And Projected_Close_Date__c = ' + dateInfo.oppick : '');
            str_filter += (dateInfo.opstart != null ? ' And Projected_Close_Date__c >= ' + dateInfo.opstart : '');
            str_filter += (dateInfo.opend != null ? ' And Projected_Close_Date__c <= ' + dateInfo.opend : '');

	        str_filter +=  ' And Id IN ( Select Opportunity__c From Opportunity_Forecast__c where id != null ';
            str_filter += (dateInfo.fcpick != 'Custom' ? ' And Date__c = ' + dateInfo.fcpick : '');
            str_filter += (dateInfo.fcstart != null ? ' And Date__c >= ' + dateInfo.fcstart : '');
            str_filter += (dateInfo.fcend != null ? ' And Date__c <= ' + dateInfo.fcend : '');
            str_filter += ' ) ';
            str_filter += ' order by id asc ';
	    	str_query += (str_where + str_filter );
	    	str_query = str_query.replaceAll('00:00:00', '');
	    	//ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'str_query :: ' + str_query));
            for(Opportunity oppy : database.query(str_query)) {
                list_oppys.add(oppy);
                pageConf.lastQueryId = oppy.Id;
            }
	    	ClsPMVTeamViewUtil.generateOppyViewObjs(list_oppys, list_oppysForMemb, dateInfo);
	    	
            pageConf.isLastPage = (list_oppysForMemb.size() == 1000 ? false : true);
            pageConf.lastQueryId = (pageConf.isLastPage ? '' : pageConf.lastQueryId);
		}
		catch(Exception ex) {
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getMessage()));
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getStackTraceString()));
		}

    }
    
   /**
    * This method is used to get opportunitys for selected member
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void getTeamViewTeams(list<TeamView_Team__c> list_teams) {
		for(TeamView_Team__c team : [Select Id, Team_Name__c, Description__c
                                     From TeamView_Team__c]) {

            list_teams.add(team);
        }
    }
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************

    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*<<<WrapperClass*/
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
    //********************************* -=END public methods=- ************************************
    
    //********************************* -=BEGIN private methods=- *********************************
}