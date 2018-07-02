/**
*  This test class used to test trigger PlayerCriteria_AU_abilityToWinFactScore.
*
@author Jinbo Shan
@created 2014-07-03
@version 1.0
@since 30.0
*
@changelog
* 2014-07-03 Jinbo Shan <jinbo.shan@itbconsult.com>
* - Created
* - Test coverage 100%
*/
@isTest(seealldata=true)
private class TrgKeyPlayerCriteria_AU_abilityToWinF {

    static testMethod void myUnitTest() {
        User u = [select Id, Name, Sub_Vertical__c, GIBU__c from User where Id = :UserInfo.getUserId() limit 1];
        u.GIBU__c = 'Industrial';
        u.Sub_Vertical__c = 'A&C';
        update u;
        system.runAs(u){
            test.startTest();
            String oppyRT;
            for(RecordType rt : [SELECT Name, Id FROM RecordType where IsActive = true and BusinessProcessId != null and SobjectType = 'Opportunity' and developerName like 'IND%' limit 1]){
                oppyRT = rt.Id;
            }
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            acc.BillingCountry = 'US';
            insert acc;
            
            Contact contact = ClsTestHelp.createTestContacts();
            contact.FirstName = 'haobo';
            insert contact;
            
            Opportunity opp = new Opportunity();
            opp.AccountId = acc.Id;
            opp.Name = 'test';
            opp.CurrencyIsoCode = 'EUR';
            opp.currency_confirm__c = true;
            opp.Type = 'New Business';
            opp.Description = 'test';
            opp.Distributor__c = 'Dachs';
            opp.StageName = 'Initiating';
            opp.Manufacturing_Start_Date__c = date.today();
            opp.CloseDate = date.today().addMonths(1);
            opp.RecordTypeId = oppyRT;
            insert opp;
            
            Decision_Criteria_Template__c dct = new Decision_Criteria_Template__c();
            dct.Question_English__c = 'test';
            insert dct;
            
            Decision_Criteria__c dc = new Decision_Criteria__c();
            dc.Active__c = true;
            dc.Decision_Criteria_Template__c = dct.Id;
            dc.Opportunity__c = opp.Id;
            dc.Question_English__c = 'test';
            dc.Position__c = '1';
            insert dc;
            
            Key_Player__c kp = new Key_Player__c();
            kp.Opportunity__c = opp.Id;
            kp.Contact__c = contact.Id;
            insert kp;
            
            Key_Player_Criteria__c kpc = new Key_Player_Criteria__c();
            kpc.Key_Player__c = kp.Id;
            kpc.Decision_Criteria__c = dc.Id;
            kpc.Priority__c = '3';
            insert kpc;
            
            kpc.Priority__c = '2';
            update kpc;
            test.stopTest();
        }
    }
}