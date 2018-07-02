/**
 * Test class for trigger answer_AU
 * 
 * @author Yuanyuan Zhang
 * @created 2014-04-28
 * @version 1.0
 * @since 29.0
 * 
 * @changelog
 * 2014-04-28 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>
 * - Created
 * - coverate 100%
 */
@isTest(seealldata=true)
private class Trg_answer_AU_Test {
    static testmethod void test(){
        
        User u = ClsTestHelp.createTestUsers4PMV();
        u.Username = 'jinbo@itbsde.test23';
        insert u;
        system.runAs(u){
            test.startTest();
            RecordType rt = ClsTestHelp.createPMVTestRecordType1();
            
            OpportunityStage os = ClsTestHelp.createPMVTestOS4();
            
            OpportunityStage opStageWon = ClsTestHelp.createPMVTestOS7();
            
            Quality_Assessment_Question__c qaq = new Quality_Assessment_Question__c();
            //qaq.Name = 'test qaq';
            qaq.Question_Chinese__c = 'test';
            qaq.Question_English__c = 'test';
            qaq.Question_German__c = 'test';
            qaq.Question_Japanese__c = 'tset';
            qaq.Help_Comment_Chinese__c = 'tset';
            qaq.Help_Comment_English__c =  'test';
            qaq.Help_Comment_German__c = 'test';
            qaq.Help_Comment_Japanese__c =  'test';
            insert qaq;
            
            Quality_Assessment_Question__c qaq1 = new Quality_Assessment_Question__c();
            //qaq.Name = 'test qaq';
            qaq1.Question_Chinese__c = 'test';
            qaq1.Question_English__c = 'test';
            qaq1.Question_German__c = 'test';
            qaq1.Question_Japanese__c = 'tset';
            qaq1.Help_Comment_Chinese__c = 'tset';
            qaq1.Help_Comment_English__c =  'test';
            qaq1.Help_Comment_German__c = 'test';
            qaq1.Help_Comment_Japanese__c =  'test';
            insert qaq1;
            
            Sales_Process_Question_Assignment__c spqa = new Sales_Process_Question_Assignment__c();
            spqa.BusinessProcess__c = rt.BusinessProcessID;
            //spqa.Name = 'test';
            spqa.PMV_Type__c = 'IND Standard Sales opp';
            spqa.Rating__c =  4;
            spqa.Quality_Assessment_Question__c = qaq.Id;
            spqa.OpportunityStage__c = os.Id;
            insert spqa;
            
            Sales_Process_Question_Assignment__c spqa1 = new Sales_Process_Question_Assignment__c();
            spqa1.BusinessProcess__c = rt.BusinessProcessID;
            //spqa.Name = 'test';
            spqa1.PMV_Type__c = 'IND Standard Sales opp';
            spqa1.Rating__c =  4;
            spqa1.Quality_Assessment_Question__c = qaq1.Id;
            spqa1.OpportunityStage__c = opStageWon.Id;
            insert spqa1;
            
            String accRecordType;
            for(RecordType accrt : [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND IsActive = true limit 1]){
                accRecordType = accrt.Id;
            }
            
            Account acc = new Account();
            acc.RecordTypeId = accRecordType;
            acc.Name = 'test acc';
            acc.CurrencyIsoCode = 'EUR';
            acc.BillingCountry = 'US';
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
            insert opp;
            
            
            Quality_Assessment_Answer__c qaa = new Quality_Assessment_Answer__c();
            qaa.Active__c = true;
            qaa.Comment__c = 'test';
            qaa.Status__c = 'In Progress';
            qaa.Sales_Process_Question_Assignment__c = spqa.Id;
            //qaa.Name = 'test answer';
            qaa.Opportunity__c = opp.Id;
            insert qaa;
            
            test.stopTest();
        }
    }
}