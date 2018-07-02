/**
*  This test class used to test class ClsPMVTeamViewWithSharingUtil.
*
@author Weihang Li
@created 2014-04-28
@version 1.0   
@since 28.0
*
@changelog
* coverage 84%
* 
* 
2014-04-28 Weihang Li <weihang.li@itbconsult.com>
* - Created
*/
@isTest(seealldata=true)
private class ClsPMVTeamViewWithSharingUtil_Test{
    static testMethod void myUnitTest() {
        TeamView_Team__c tt = new TeamView_Team__c ();
        tt.Team_Name__c = 'test';
        tt.Description__c = 'test desc';
        insert tt;
        
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
        
        list<Opportunity> list_oppys = new list<Opportunity>();
        
        CtrlPMVTeamView.PageConfig pageConf = new CtrlPMVTeamView.PageConfig();
        pageConf.teamViewId = tt.Id;
        pageConf.dateInfoJson = Json.serialize(dateInfo) ;
        
        CtrlPMVTeamView.OppyViewObj obj = new CtrlPMVTeamView.OppyViewObj();
        list<TeamView_Team__c> list_teams = new list<TeamView_Team__c>();
        list<CtrlPMVTeamView.OppyViewObj> list_oppysForMemb = new list<CtrlPMVTeamView.OppyViewObj>();
        ClsPMVTeamViewUtil.generateOppyViewObjs(list_oppys, list_oppysForMemb, dateInfo);
        ClsPMVTeamViewWithSharingUtil.getOppysForMemb(list_oppysForMemb, pageConf);
        ClsPMVTeamViewWithSharingUtil.getTeamViewTeams(list_teams);
    }
    
}