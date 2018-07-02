/**
*  This test class used to test class ExtRecalculateBudget.
*
@author Lili Zhao
@created 2014-03-25
@version 1.0   
@since 28.0
*
@changelog
* coverage 82% 
* 
* 
2014-03-25 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest
private class CtrlPMVTeamView_Test {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Test.startTest();
        Profile p = [Select Id, Name From Profile 
     								where Name = 'Production Support' 
     								or Name = 'Service Account' 
     								or Name ='System Administrator' 
     								or Name ='Systemadministrator' limit 1];
     	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'Lion@testCompany999.com';
    	u.Alias = 'SF';
    	u.ProfileId = p.Id;
    	u.CommunityNickname = 'QPS';
    	u.IsActive = true;
    	u.Username = 'Lion@testCompany93399.com.dsddddf';
		insert u;
        TeamView_Team__c team = new TeamView_Team__c();
        team.Team_Name__c = 'test Name';
        team.Team_Member_User_IDs__c = u.Id;
        insert team;
        String teamDescription = 'test';
        String username = 'Tester';
        CtrlPMVTeamView ctrl = new CtrlPMVTeamView();
        CtrlPMVTeamView.TeamViewObject  TeamViewObject = new CtrlPMVTeamView.TeamViewObject('test1', 'test2', 'test3', 'test4', 'test5', 'test6', 'test7', 
    						  'test8', 'test9', 'test10', 'test11');
        CtrlPMVTeamView.TeamObject teamObj = new CtrlPMVTeamView.TeamObject();
        teamObj.description ='test';
        teamObj.id = team.Id;
        teamObj.name = 'testName';
        teamObj.struserids = 'teststruserids';
        String teamAttr = Json.serialize(teamObj) ;
        ClsPMVTeamViewUtil clsTeamView = new ClsPMVTeamViewUtil();
        ClsPMVTeamViewUtil.DateRange  dateRange = new ClsPMVTeamViewUtil.DateRange('test1', 'test2');
        list<ClsPMVTeamViewUtil.DateRange> list_dateRange = new list<ClsPMVTeamViewUtil.DateRange>();
        list_dateRange.add(dateRange );
        list<ClsPMVTeamViewUtil.DateRangeType> list_dateRangeType = New list<ClsPMVTeamViewUtil.DateRangeType>();
    	set<String> set_membIds = new set<String>();
    	set<String> set_membIds1 = new set<String>();
        set_membIds.add('test1');
        set_membIds.add('test2');
        CtrlPMVTeamView.DatePicker dateInfo = new CtrlPMVTeamView.DatePicker();
        dateInfo.selectedMembId = 'testId';
        dateInfo.oppick = 'Custom';
        dateInfo.fcpick = 'Custom';
        dateInfo.opstart = null;
        dateInfo.opend = null;
        dateInfo.fcstart = null;
        dateInfo.fcend = null;        
        dateInfo.orderField = 'test3';
        dateInfo.orderASC = 'test4';
        
        CtrlPMVTeamView.PageConfig pageConf = new CtrlPMVTeamView.PageConfig();
        pageConf.teamViewId = team.Id;
        pageConf.dateInfoJson = Json.serialize(dateInfo) ;
        
        ctrl.pageConf = pageConf;
        //list<ClsPMVTeamViewUtil.DateRange> list_dateRange = new list<ClsPMVTeamViewUtil.DateRange>();
        list_dateRange.add(dateRange );
        //list<ClsPMVTeamViewUtil.DateRangeType> list_dateRangeType = New list<ClsPMVTeamViewUtil.DateRangeType>();
        CtrlPMVTeamView.TeamColumns TeamColumns = new CtrlPMVTeamView.TeamColumns('test1', 'test2', 'test3', 'test4');
    	
    	ctrl.getTeamColumns();
    	ctrl.getOppyColumns();
    	ctrl.getListTeams();
    	ctrl.getTeamMembs();
    	ctrl.getThis();
    	ctrl.searchOppysForMemb();
    	ctrl.showTeamMembers();
    	CtrlPMVTeamView.saveTeamAndMembers(teamAttr,teamDescription);
    	CtrlPMVTeamView.searchUsers(username);
    	ctrl.searchUserByFNameAndLName();
    	CtrlPMVTeamView.delTeamView(team.Id);
    	Test.stopTest();   
    }
}