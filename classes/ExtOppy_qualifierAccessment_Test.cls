/**
*  This test class used to test class ExtOppy_qualifierAccessment.
*
@author Weihang Li
@created 2014-04-28
@version 1.0   
@since 28.0
*
@changelog
* coverage  83%
* 
* 
2014-04-28 Weihang Li <weihang.li@itbconsult.com>
* - Created
*/
@isTest(seealldata=true)
private class ExtOppy_qualifierAccessment_Test {
	
    static testMethod void myUnitTest() {
        RecordType rt = ClsTestHelp.createPMVTestRecordType1();
        User u = ClsTestHelp.createTestUsers4PMV();
        u.Username = 'jinbo@sdfasssdf.csddgrw2e3';
        insert u;
        system.runAs(u){
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            insert acc;
            
            Opportunity opp = new Opportunity();
            opp.AccountId = acc.Id;
            opp.Name = 'test';
            opp.CurrencyIsoCode = 'EUR';
            opp.Type = 'New Business';
            opp.currency_confirm__c = true;
            opp.Description = 'test';
            opp.Distributor__c = 'Dachs';
            opp.StageName = 'Initiating';
            opp.Manufacturing_Start_Date__c = date.today();
            opp.CloseDate = date.today().addMonths(1);
            opp.RecordTypeId = rt.Id;
            opp.Lead_ID__c = '01x000000000fgh';
            opp.PMV_Type__c = 'IND Standard Sales opp';
            insert opp;
            
            Quality_Assessment_Question__c qa = new Quality_Assessment_Question__c();
            qa.Help_Comment_Chinese__c = 'test';
            insert qa;
            
            OpportunityStage opStage = ClsTestHelp.createPMVTestOS4();
            
            Sales_Process_Question_Assignment__c sp = new Sales_Process_Question_Assignment__c();
            sp.BusinessProcess__c = rt.BusinessProcessId;
            sp.PMV_Type__c = 'IND Standard Sales opp';
            sp.OpportunityStage__c = opStage.Id;
            sp.Quality_Assessment_Question__c = qa.Id;
            insert sp;
            
            test.startTest();
            ApexPages.Standardcontroller stdCtrl = new ApexPages.Standardcontroller(opp);
            ExtOppy_qualifierAccessment ext = new ExtOppy_qualifierAccessment(stdCtrl);
            
            list<ExtOppy_qualifierAccessment.ClsAnswer> list_ans = new list<ExtOppy_qualifierAccessment.ClsAnswer>();
            
            ExtOppy_qualifierAccessment.ClsAnswer answerObj = new ExtOppy_qualifierAccessment.ClsAnswer();
            answerObj.status = 'Yes';
            answerObj.questionId = sp.Id;
            answerObj.comment = 'test';
            answerObj.lastModifyDate = string.valueOf(system.today());   
            list_ans.add(answerObj);   
            string jsonAnswer = JSON.serialize(list_ans);        
            string ret = ExtOppy_qualifierAccessment.saveAnswers(opp.Id + '', jsonAnswer);
            ret = ExtOppy_qualifierAccessment.updateOppBCandBCC(opp.Id, '', '');
            
            test.stopTest();
            
        }
    }
}