@isTest(seealldata=true)
private class TrgDecisionCriteria_AIU_generateKPC_Test{
    static testmethod void test(){
        User u = [select Id, Name, Sub_Vertical__c, GIBU__c from User where Id = :UserInfo.getUserId() limit 1];
        u.GIBU__c = 'Industrial';
        u.Sub_Vertical__c = 'A&C';
        update u;
        system.runAs(u){
            test.starttest();
            Decision_Criteria_Template__c dct = new Decision_Criteria_Template__c();
            dct.Question_English__c = 'test';
            insert dct;
            
            String oppyRT;
            for(RecordType rt : [SELECT Name, Id FROM RecordType where IsActive = true and BusinessProcessId != null and SobjectType = 'Opportunity' and developerName like 'IND%' limit 1]){
                oppyRT = rt.Id;
            }
            
            Account acc = [SELECT Id FROM Account limit 1];
            
            
            Opportunity opp = new Opportunity();
            opp.AccountId = acc.Id;
            opp.Name = 'test';
            opp.CurrencyIsoCode = 'EUR';
            opp.Type = 'New Business';
            opp.Description = 'test';
            opp.currency_confirm__c = true;
            opp.Distributor__c = 'Dachs';
            opp.StageName = 'Initiating';
            opp.Manufacturing_Start_Date__c = date.today();
            opp.CloseDate = date.today().addMonths(1);
            opp.RecordTypeId = oppyRT;
            insert opp;
            
            Decision_Criteria__c dc = new Decision_Criteria__c();
            dc.Active__c = true;
            dc.Decision_Criteria_Template__c = dct.Id;
            dc.Opportunity__c = opp.Id;
            dc.Question_English__c = 'test';
            dc.Position__c = '1';
            insert dc;
            dc.Active__c = false;
            update dc;
            dc.Active__c = true;
            update dc;
            
            test.stopTest();
        }
    }
}