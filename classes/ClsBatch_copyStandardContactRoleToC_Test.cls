/**
*  This test class used to test class ClsBatch_copyStandardContactRoleToCustom.
*
@author Jinbo Shan
@created 2014-06-25
@version 1.0   
@since 29.0
*
@changelog
* coverage  76%
* 
* 
2014-06-25 Jinbo Shan <jinbo.shan@itbconsult.com>
* - Created
*/
@isTest(seealldata=true)
private class ClsBatch_copyStandardContactRoleToC_Test {
	
	

    static testMethod void myUnitTest() {
    	
    	User u = [select Id, Name, Sub_Vertical__c, GIBU__c from User where Id = :UserInfo.getUserId() limit 1];
        u.GIBU__c = 'Industrial';
        u.Sub_Vertical__c = 'A&C';
        u.Country = 'Germany';
        update u;
        system.runAs(u){
        	
        	String oppyRT;
            for(RecordType rt : [SELECT Name, Id FROM RecordType where IsActive = true and BusinessProcessId != null and SobjectType = 'Opportunity' and developerName like 'IND%' limit 1]){
                oppyRT = rt.Id;
            }
            
            Account acc = ClsTestHelp.createTestAccounts();
            insert acc;
            
            Contact contact = ClsTestHelp.createTestContacts();
            contact.FirstName = 'haobo';
            insert contact;
            
            Contact contact1 = ClsTestHelp.createTestContacts();
            contact1.FirstName = 'sdftest';
            insert contact1;
            
            Opportunity opp = new Opportunity();
            opp.AccountId = acc.Id;
            opp.Name = 'test';
            opp.CurrencyIsoCode = 'EUR';
            opp.Type = 'New Business';
            opp.Description = 'test';
            opp.Distributor__c = 'Dachs';
            opp.StageName = 'Initiating';
            opp.Manufacturing_Start_Date__c = date.today();
            opp.CloseDate = date.today().addMonths(1);
            opp.RecordTypeId = oppyRT;
            opp.currency_confirm__c = true;
            insert opp;
            
            OpportunityContactRole ocr = new OpportunityContactRole();
            ocr.OpportunityId = opp.Id;
            ocr.ContactId = contact.Id;
            ocr.Role = 'Business User';
            insert ocr;
            
            OpportunityContactRole ocr1 = new OpportunityContactRole();
            ocr1.OpportunityId = opp.Id;
            ocr1.ContactId = contact1.Id;
            ocr1.Role = 'Business User';
            insert ocr1;
            
            Key_Player__c kp = new Key_Player__c();
            kp.Opportunity__c = opp.Id;
            kp.Contact__c = contact.Id;
            kp.Contact_Role_Id__c = ocr.Id;
            insert kp;
        	
	    	Test.startTest();
		    ClsBatch_copyStandardContactRoleToCustom cls = new ClsBatch_copyStandardContactRoleToCustom();
		    cls.filter = ' and OpportunityId = \'' + opp.Id + '\'';
		    database.executeBatch(cls);
		    Test.stopTest();
        }
    }
}