/**************************************************************************************************************************************************
Name:  RTS_CalloutTest
Copyright © 2013 TE Connectivity | Instance : C2S Org
===================================================================================================================================================
Purpose: This class contain Test Methods for RTS_Callout
---------------------------------------------------------------------------------------------------------------------------------------------------       
Related APEX Class : RTS_Callout
Related APEX Trigger: RTSRequestAI, RTSRequestAU                                                              
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
Version Developer          Date       Detail                                  Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Subba Reddy 02/27/2013 Initial Development                      
**************************************************************************************************************************************************/

@isTest(SeeAllData=true)
private class RTS_CalloutTest {
       
 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Create test data for User sObject                                                                                                     |
 |   Input : None                                                                                                                                  |  
 | Returns : None                                                                                                                                  |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
 public static void createUser()
 {
  /*-- 1.0 Object variable declaration ---------------------------------------------*/ 
  User vUser;
  vUser                      = new User();
  vUser.FirstName            = 'Dinesh';  
  vUser.LastName             = 'Umasankar';  
  vUser.email                = 'dinesh1.alpha@test.com';
  vUser.alias                = 'udinesh1';
  vUser.UserName             = vUser.email;
  vUser.CommunityNickname    = vUser.alias;
  vUser.ProfileId            = UserInfo.getProfileId();
  vUser.TimeZoneSidKey       = 'GMT';
  vUser.LocaleSidKey         = 'en_US';
  vUser.EmailEncodingKey     = 'UTF-8';
  vUser.LanguageLocaleKey    = 'en_US'; 
  Insert vUser;
  System.assert(vUser != null, 'Salesforce.com is not allowing us to insert user in the temporary memory'); 
 } // public static void createUser()

 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Test Data - Creating test Opportunity Request record                                                                                  |
 | Input : None                                                                                                                                    |  
 | Returns : None                                                                                                                                  |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
 public static void createOpp()
 {
  /*-- 1.1 Object variable declaration ------------------------------------------------*/
  User             vUser;
  Account          vAccount;
  Opportunity      vOpp;
  /*-- 1.2 Primitive variable declaration ---------------------------------------------*/   
  
  vUser = 
   [
    SELECT u.Id
      FROM user u
     WHERE u.email = 'dinesh1.alpha@test.com' 
   ];
  
  vAccount = ClsTestHelp.createTestAccounts();
  vAccount.ownerid = vUser.id;
  insert vAccount;

  vOpp = new Opportunity();
  vOpp.AccountId = vAccount.Id;
  vOpp.Name = 'Test Opportunity-RTS Request';
  vOpp.StageName = 'New';
  vOpp.currency_confirm__c = true;
  vOpp.CloseDate = Date.today() + 1;
  insert vOpp;  
  
  System.assert(vOpp.Id != NULL, 'Test Opportunity creation for checking XML creation was not successful');
 } // public static void createOpp()
 
 
 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Test Data - Creating test RTS Request record                                                                                          |
 | Input : None                                                                                                                                    |  
 | Returns : None                                                                                                                                  |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
 public static void createRTS(){
  
 /*-- 1.1 Object variable declaration ------------------------------------------------*/
  Opportunity      vOpp;
  RTS_Request__c   vRTS;
  
   vOpp = 
    [
    SELECT opp.Id
      FROM Opportunity opp
     WHERE opp.Name = 'Test Opportunity-RTS Request' 
   ];     
    
  vRTS = new RTS_Request__c();
  vRTS.Name = 'New Test Request';
  vRTS.Due_Date__c = (Date.today() + 7);
  vRTS.Request_Type__c = 'Development Project Request';
  vRTS.Pricing_Requirement__c = 'Estimate';
  vRTS.Product_Owning_GIBU__c = 'Solar';
  vRTS.Sales_Channel__c = 'Direct';
  vRTS.Request_Description__c = 'This is a test.';
  vRTS.Send_to_RTS__c = true;
  vRTS.OpportunityName__c = vOpp.id;
  Insert vRTS;
  System.assert(vRTS.Id != NULL, 'Test RTS creation for checking XML creation was not successful');
 } // public static void createRTS()
 
 
  
 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Test Data - Creating and updating test RTS Request record                                                                             |
 | Input : None                                                                                                                                    |  
 | Returns : None                                                                                                                                  |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
 public static void createAndUpdateRTS(){
  /*-- 1.1 Object variable declaration ------------------------------------------------*/
  Opportunity      vOpp;
  RTS_Request__c   vRTS;

   vOpp = 
    [
    SELECT opp.Id
      FROM Opportunity opp
     WHERE opp.Name = 'Test Opportunity-RTS Request' 
   ];     
     
  
  vRTS = new RTS_Request__c();
  vRTS.Name = 'New Test Request1';
  vRTS.Due_Date__c = (Date.today() + 7);
  vRTS.Request_Type__c = 'Development Project Request';
  vRTS.Pricing_Requirement__c = 'Estimate';
  vRTS.Product_Owning_GIBU__c = 'Solar';
  vRTS.Sales_Channel__c = 'Direct';
  vRTS.Request_Description__c = 'This is a test update description.';
  vRTS.Send_to_RTS__c = false;
  vRTS.OpportunityName__c = vOpp.id;
  Insert vRTS;
  System.assert(vRTS.Id != NULL, 'Test RTS creation for checking XML creation was not successful');
  
  vRTS.Send_to_RTS__c = true;
  update vRTS;
 } // public static void createAndUpdateRTS()
  
 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Test - callOrchestration                                                                                                              |
 |   Input : None                                                                                                                                  |  
 | Returns : None                                                                                                                                  |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/
 public static void callOrchestration()
 {
  /*-- D2. Object variable declaration ------------------------------------------*/
  RTS_Request__c   vRTS;
  
  vRTS = 
   [
    SELECT rts.Id
      FROM RTS_Request__c rts
      WHERE rts.Name = 'New Test Request' 
      LIMIT 1
   ];
  RTS_Callout.callOrchestration(vRTS.Id+'||TE900611');
  
 } // public static void ptBuildXmlElement()

 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Test - rtsRequestTestMethod1                                                                                                          |
 |   Input : None                                                                                                                                  |  
 | Returns : None                                                                                                                                  |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
 public static testMethod void rtsRequestTestMethod1()
 {
 
  test.StartTest();
   createUser();
   createOpp();
   createRTS();  
   createAndUpdateRTS();  
   callOrchestration();
  test.StopTest();
 } // public static testMethod void createXML()
}