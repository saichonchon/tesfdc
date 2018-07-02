/****************************************************

Author          : Esther Ethelbert
Created Date    : 08/23/17
Project         : Account Plan
Description     : Test class for DeleteOppTAM 

*****************************************************/
@isTest(seeAllData=false)
public class triggerClassDeleteOppTAMTest
{

@testSetup static void setup() {
  User u = ClsTestHelp.createtestUsers();
  insert u;
  ClsTestCustomSettingHelper.getTrigger_Configuration();
  ClsTestCustomSettingHelper.getProfitBUCenterMapping();
  ClsTestCustomSettingHelper.getApex_Helper_Settings();
 ClsTestCustomSettingHelper.getADMTerritoryCode();
  Account acct = ClsTestHelp.createtestAccounts();
  acct.WWCORPACCT__c ='W0007';
  acct.GAMCD__c = 'G0007';
  acct.IND_KAM_Code__c = 'K0007';
  insert acct;
  
  ACP_Account_Plan__c newAccPlan = new ACP_Account_Plan__c(
   Name = 'TestAccountPlan3564',
   ACP_Account_Name__c = acct.Id,
   Account_Plan_Type__c = 'Gam Account',
   ACP_Customer_Strategy_Summary__c = 'TestAccountPlan3564');
  insert newAccPlan;

    //insert Market and Competition
      List < ACP_Market_and_Competition__c> Mark = ACP_TestDataFactory.createMarketCompetition(1, 'General Market and Competition');
    for(ACP_Market_and_Competition__c obj : mark)
    {
    obj.ACP_Account_Plan__c = newAccPlan.id;
    
    }
    insert mark;
         
   
    test.stopTest();
    }
    }