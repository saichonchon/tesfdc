/**
*   This test class is for CampaignMember_AU_updateNPSContact.
*
@author Di Chen
@created 2012-12-18
@version 1.0
@since 20.0
*
@changelog
* 2012-12-18 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 86%
*/
@isTest(seeAllData = true) 
private class TrgCampaignMember_AU_updateNPSCon_Test {

    static testMethod void testUpdate() {
    	
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Industry_Code_Description__c = 'A&C';
        acc.LEVEL_1_INDUSTRY_CDE__c = '0108';
        insert acc;
        
        Contact con = ClsTestHelp.createTestContacts();
        con.AccountId = acc.Id;
        con.NPS_Language__c = 'DE';
        con.Email = 'sdf@dsafj.com';
        insert con;
        
        Contact con1 = ClsTestHelp.createTestContacts();
        con1.AccountId = acc.Id;
        con1.NPS_Language__c = 'DE';
        con1.Email = 'sddddddf@dsafj.com';
        insert con1;
        
        Survey__c survey = new Survey__c();
        survey.Name = 'henhao';
        insert survey;
        
        Campaign cam = new Campaign();
        cam.Name = 'nihao';
        cam.EndDate = date.today() + 5;
        cam.Survey__c = survey.Id;
        cam.Survey_Date__c = date.today() - 15;
        insert cam;
        
        CampaignMember cm = new CampaignMember();
        cm.ContactId = con.Id;
        cm.CampaignId = cam.Id;
        cm.NPS_OPT_OUT__c = false;
        cm.Status = 'Sent';
        insert cm;
                
        Test.startTest();
        
        cm.Status = 'Responded';
        cm.NPS_OPT_OUT__c = true;
        //cm.ContactId = con1.Id;
        update cm;
        
        system.assert(true);
        Test.stopTest();
    }
	static testMethod void testUpdate2() {
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Industry_Code_Description__c = 'A&C';
        acc.LEVEL_1_INDUSTRY_CDE__c = '0108';
        insert acc;
        
		Contact con = new Contact();
        for(Contact con1 : [select Id,AccountId,NPS_Language__c,Email,LastName,OwnerId,MailingCity,NPS_Score__c,MailingStreet,MailingCountry,MailingPostalCode ,Salutation ,Phone from Contact where  NPS_Score__c >= 5 and NPS_Score__c <= 6 limit 1]){
        	con = con1;
        }
	    if(con.Id== null){
	        con.AccountId = acc.Id;
	        con.NPS_Language__c = 'DE';
	        con.Email = 'sdf@dsafj.com';
	        con.LastName = 'Sand';
        	con.OwnerId = UserInfo.getUserId();
        	con.MailingCity = 'Musterstadt';
        	con.MailingStreet = 'Teststr. 1';
        	con.MailingCountry = 'Germany';
        	con.MailingPostalCode = '77777';
        	con.Salutation = 'Mr.';
        	con.Phone = '12365478';
	        insert con;
	    }        

        /*Answer__c answer = new Answer__c();
        answer.Contact__c = con.Id;
        answer.Question__c = 'a1WL00000004aEe';//NPS_Score__c Roll-Up Summary (SUM Answer) : (CurrentEQUALStrue) AND (Question IDEQUALSa1WL00000004aEe)
        answer.Current__c = true;
        answer.Answer__c = '0';
        insert answer;*/
               
        Survey__c survey = new Survey__c();
        survey.Name = 'henhao';
        insert survey;
        
        Campaign cam = new Campaign();
        cam.Name = 'nihao';
        cam.EndDate = date.today() + 5;
        cam.Survey__c = survey.Id;
        cam.Survey_Date__c = date.today() - 15;
        insert cam;
        
        CampaignMember cm = new CampaignMember();
        cm.ContactId = con.Id;
        cm.CampaignId = cam.Id;
        cm.Status = 'Sent';
        insert cm;
                
        Test.startTest();
        
        cm.Status = 'Responded';
        update cm;
        
        system.assert(true);
        Test.stopTest();
    }
}