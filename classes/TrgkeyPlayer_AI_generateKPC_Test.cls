@isTest(seealldata=true)
private class TrgkeyPlayer_AI_generateKPC_Test{
    static testmethod void test(){
        User u = [select Id, Name, Sub_Vertical__c, GIBU__c from User where Id = :UserInfo.getUserId() limit 1];
        u.GIBU__c = 'Industrial';
        u.Sub_Vertical__c = 'A&C';
        update u;
        system.runAs(u){
            test.startTest();
            /*
            String accRecordType;
            for(RecordType rt : [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND IsActive = true AND DeveloperName = 'CIS_Account' limit 1]){
                accRecordType = rt.Id;
            }
            */
            String oppyRT;
            for(RecordType rt : [SELECT Name, Id FROM RecordType where IsActive = true and BusinessProcessId != null and SobjectType = 'Opportunity' and developerName like 'IND%' limit 1]){
                oppyRT = rt.Id;
            }
            /*
            Account acc = new Account();
            acc.RecordTypeId = accRecordType;
            acc.Name = 'test acc';
            acc.CurrencyIsoCode = 'EUR';
            insert acc;
            */
            Account acc = [SELECT Id FROM Account limit 1];
            
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
            
            Key_Player__c kp = new Key_Player__c();
            kp.Opportunity__c = opp.Id;
            kp.Contact__c = contact.Id;
            insert kp;
            
            test.stopTest();
        }
    }

}