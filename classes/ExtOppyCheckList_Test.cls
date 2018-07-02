/**
* Unit test class for class ExtOppyCheckList
*
* @author     Wenxuan Qin
* @created    2017-08-10
* @version    1.0
* @since      38.0 (Force.com ApiVersion)
*
* @changelog
* 2017-08-10  Wenxuan Qin <wenxuan.qin@oinio.com>
* - Created
*/
@isTest
private class ExtOppyCheckList_Test {
    
    static testMethod void unitTest() {
        /** get all need custom setting */
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
        ClsTestCustomSettingHelper.getADMTerritoryCode();
        ClsTestHelp.createTestOPTG4(); 
        /** create test opp */
        Opportunity opp =  ClsTestHelp.createTestOpportunity();
        //opp.Probability__c = '30';
        insert opp;
        
        /***create two opportunityChecklists***/
        Opportunity_CheckList__c oppchecklist1 = new Opportunity_CheckList__c();
        oppchecklist1.Category__c = 'COMPANY DETAIL';
        oppchecklist1.Help_Message__c = 'a hint';
        oppchecklist1.CategoryNo__c = 1;
        oppchecklist1.QuestionNo__c = 1;
        oppchecklist1.Comment_Yes__c = 'Provide details to Legal';
        oppchecklist1.Comment_No__c = 'aa';
        oppchecklist1.Question__c = 'ss';
        
        Opportunity_CheckList__c oppchecklist2 = new Opportunity_CheckList__c();
        oppchecklist2.Category__c = 'AAAA';
        oppchecklist2.Help_Message__c = 'a hint';
        oppchecklist2.CategoryNo__c = 2;
        oppchecklist2.QuestionNo__c = 2;
        oppchecklist2.Comment_Yes__c = 'Provide details to Legal ==';
        oppchecklist2.Comment_No__c = 'aabb';
        oppchecklist2.Question__c = 'ssbb';
        list<Opportunity_CheckList__c> list_oppChecklists = new list<Opportunity_CheckList__c>{oppchecklist1, oppchecklist2};
            insert list_oppChecklists;
        
        /***create two Opportunities checklist answers****/
        Opportunity_CheckList_Answer__c oppcheck1 = new Opportunity_CheckList_Answer__c();
        oppcheck1.Answer__c = 'True';
        oppcheck1.Comment__c = 'test comment 1';
        oppcheck1.Opportunity_CheckList_Id__c = list_oppChecklists[0].Id;
        oppcheck1.Opportunity_Id__c = opp.Id;    
        
        Opportunity_CheckList_Answer__c oppcheck2 = new Opportunity_CheckList_Answer__c();
        oppcheck2.Answer__c = 'False';
        oppcheck2.Comment__c = 'test comment 2';
        oppcheck2.Opportunity_CheckList_Id__c = oppCheckList2.Id;
        oppcheck2.Opportunity_Id__c = opp.Id;
        
        list<Opportunity_CheckList_Answer__c> list_OpportunityCheckListAnswer  = new list<Opportunity_CheckList_Answer__c>{oppcheck1,oppcheck2};
            insert list_OpportunityCheckListAnswer;
        
        //new inner class for json string 
        ExtOppyCheckList.AnswerObj answer1 = new ExtOppyCheckList.AnswerObj();
        answer1.str_questionId = list_oppChecklists[0].Id;
        answer1.str_questionAnswer = 'True';
        answer1.str_questionComment = 'test comment 1';
        
        ExtOppyCheckList.AnswerObj answer2 = new ExtOppyCheckList.AnswerObj();
        answer2.str_questionId = list_oppChecklists[1].Id;
        answer2.str_questionAnswer = 'True';
        answer2.str_questionComment = 'update comment 2';
        
        /*ExtOppyCheckList.AnswerObj answer3 = new ExtOppyCheckList.AnswerObj();
        answer3.str_questionId = oppchecklist2.Id;
        answer3.str_questionAnswer = 'new insert answer';
        answer3.str_questionComment = 'new insert comment';*/
        List<ExtOppyCheckList.AnswerObj> list_answers = new List<ExtOppyCheckList.AnswerObj>{answer1,answer2};
            
        //call out saveAnswers()
        /*PageReference pageRef = Page.ExtOppyCheckList;
        ApexPages.currentPage().getParameters().put('id',opp.Id);
        Test.setCurrentPage(pageRef);*/
        ExtOppyCheckList  extOppChecklist = new ExtOppyCheckList(new ApexPages.StandardController(opp));
        extOppChecklist.str_saveAnswersJson = JSON.serialize(list_answers);
        extOppChecklist.saveAnswers();
        

        Opportunity_CheckList_Answer__c lnewOppCheckAnswer1 = [select Answer__c,Comment__c,Opportunity_CheckList_Id__c from
                                                               Opportunity_CheckList_Answer__c where Id = :list_OpportunityCheckListAnswer[0].Id];
        System.assert(lnewOppCheckAnswer1.Answer__c == 'True');
        System.assert(lnewOppCheckAnswer1.Comment__c == 'test comment 1');
        
    }
    
}