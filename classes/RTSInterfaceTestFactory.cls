/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class RTSInterfaceTestFactory {

    static testMethod void testOpenRTSPageController() {
        //create test data
        Opportunity_Approvers__c oa = ClsTestHelp.createTestOpportunityApprovers();        
        Opportunity_Approvers__c oa2 = ClsTestHelp.createTestOpportunityApprovers2();        
        Opportunity_Approvers__c oa3 = ClsTestHelp.createTestOpportunityApprovers3();
        Opportunity_Approvers__c oa4 = ClsTestHelp.createTestOpportunityApprovers4();
                	
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();   
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9(); 	          
        User u = new User();
        u = CreateTestUser();                       
		RecordType rt2 = ClsTestHelp.createTestRecordType8();
        system.runAs(u)
        {                                            
            Account testAccount = ClsTestHelp.createTestAccounts();
            testAccount.RecordTypeId = rt2.Id;
            insert testAccount;

            Opportunity testOpp = new Opportunity();
            
            testOpp.AccountId = testAccount.Id;
            testOpp.Name = 'Test Opportunity';
            testOpp.currency_confirm__c = true;
            testOpp.StageName = 'Prospecting';
            testOpp.CloseDate = Date.today() + 1;
            //testOpp.Copied_from_Request__c = testRTS.Id;
            
            insert testOpp;
            
            RTS_Request__c testRTS = new RTS_Request__c();
            
            testRTS.Name = 'New Test Request';
            //testRTS.AccountName__c = testAccount.Id;
            testRTS.Due_Date__c = (Date.today() + 7);
            testRTS.Request_Type__c = 'Development Project Request';
            testRTS.Request_Description__c = 'This is a test.';
            testRTS.RTS_Request_Id__c = 415997;  //sitescope monitoring request on prod
            testRTS.OpportunityName__c = testOpp.id;
            
            insert testRTS;
            
            //set page opp id
            PageReference pageRef = Page.OpenRTSPage;
            pageRef.getParameters().put('Id', testRTS.Id);
            Test.setCurrentPage(pageRef); 
            
            OpenRTSPageController controller = new OpenRTSPageController();
            
            controller.getRTSUrl();
            controller.getReturnUrl();
            controller.getListUrl();                     
            
            testRTS = [Select Id, OpportunityName__c from RTS_Request__c where Id =: testRTS.Id];
            
            system.debug('*****12345 ' + testRTS.OpportunityName__c + ' ' + testOpp.Id);
            system.assertEquals(testRTS.OpportunityName__c, testOpp.Id);            
        }
    }
    
  private static User u;  
  private static User CreateTestUser()
  {
    if (u != null)
      return u;
     
    u = new User();
    u.FirstName = 'John';
    u.LastName = 'Doe';
    u.Email = 'John.Doe@te.com';
    u.Username = 'john.doe@te.com.cis';
    u.Alias = 'JDAlias';
    u.CommunityNickname = 'JohnDoe';
    u.EmailEncodingKey='ISO-8859-1';
    u.TimeZoneSidKey = 'America/New_York';
    u.LanguageLocaleKey='en_US';
    u.ProfileId=GetStandardUserProfileId();
    u.LocaleSidKey='en_US';
    u.EmployeeNumber = 'US075379'; //need a valid TE network ID here   
    insert u;
    return u;
  }
   
  private static id GetStandardUserProfileId()
  {
    List<Profile> pl = new List<Profile>([select id, name from profile where name='Standard User']);
    if (pl.size() > 0)
     return pl[0].id;
    else
     return null;
  }    
    
}