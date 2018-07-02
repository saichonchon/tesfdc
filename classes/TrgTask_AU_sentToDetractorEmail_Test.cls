/**
*  This test class used to test class ExtRecalculateBudget.
*
@author Lili Zhao
@created 2014-10-10
@version 1.0   
@since 28.0
*
@changelog
* coverage 86% 
* 
* 
2014-10-10 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest(seeAllData = true) 
private class TrgTask_AU_sentToDetractorEmail_Test {

    static testMethod void myUnitTest() {
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Industry_Code_Description__c = 'A&C';
        acc.LEVEL_1_INDUSTRY_CDE__c = '0108';
        acc.Account_Manager__c = UserInfo.getUserId();
        insert acc;
        
		Contact con = new Contact();
		/*
        for(Contact con1 : [select Campaign_Type__c, NPS_Result_Report__c, Id,AccountId,NPS_Language__c,Email,LastName,OwnerId,MailingCity,NPS_Score__c,MailingStreet,MailingCountry,MailingPostalCode ,Salutation ,Phone from Contact where  NPS_Score__c >= 5 and NPS_Score__c <= 6 limit 1]){
        	con = con1;
        }
        */
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
        	//con.NPS_Result_Report__c = 'test';
	        insert con;
	    } 
	    
	    Task task = new Task();
        task.Description = 'testwwww';
        task.WhoId = con.Id;
        task.OwnerId = UserInfo.getUserId();
        task.Subject = 'test';
        task.Detraction_Reason__c = 'Pricing';
        insert task;
        
        Test.startTest();
        task.Detraction_Reason__c = 'Pricing;Quality';
        update task;
        Test.stopTest();
    }
}