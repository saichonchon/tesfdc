/**********************************************************************************************************************************************
Name: CaseServicesTest
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================
Details : Nooreen Shaikh  24/09/2015    Test Class                      
Rajendra Shahane 03/29/2016  Modified for case - 900703
***********************************************************************************************************************************************/
@isTest
public class CaseServicesTest{
     public static testmethod void TestMethod1(){           
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
         //Start: Rajendra Shahane Modified for case - 900703
        ClsTestCustomSettingHelper.getCCPTriggerSettings();
        //End: Rajendra Shahane Modified for case - 900703
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getCaseFinalVariables();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getADMTerritoryCode();
         
        /*List<CaseFinalVariablesforCC__c> lstCaseCCFV = new List<CaseFinalVariablesforCC__c>();
        lstCaseCCFV.add(new CaseFinalVariablesforCC__c (name='Default', Customer_Care_Cloud_Record_Type_String__c ='Customer_Care_Cloud') ) ;
        insert lstCaseCCFV; */
        //Id vCaseCCRT = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Care Cloud').getRecordTypeId();
         
        ClsTestCustomSettingHelper.getWebToCaseStrings();
        Id vCaseRT = Schema.SObjectType.Case.getRecordTypeInfosByName().get('TE PIC Standard Case Record Type').getRecordTypeId();//[SELECT Id FROM RecordType WHERE DeveloperName = 'TE_PIC_Standard_Case_Record_Type'].Id;
        List<Case> vCsLst = new List<Case>();
        List<Case> vCsLstUpdate = new List<Case>();
        Map<Id,Case> vCsMap = new Map<Id,Case>();        
        User u = new User();
        u.FirstName ='Fpic';
        u.LastName = 'Tester';
        u.Alias = 'mfptst';
        u.Email = 'mfptester@zencoTestcompany.com';
        u.Username = getUserNamePrefix()+ u.Email;
        u.CommunityNickname = u.Alias;
        u.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.Primary_Business_Hours__c = 'PIC - US';
        insert u;
       
        Account vAccount;
        vAccount = new Account();
        //================================ code Added for Add Business Unit value with Account
        vAccount.Industry_Code_Description__c = 'Industrial';
         vAccount.Business_Unit_Level_2__c = 'Rail';
        //================================
        vAccount.Name = 'Test Pic acc2';
        vAccount.Legally_Restricted__c = true; 
        vAccount.BillingCity = 'Beijing';  
        vAccount.BillingCountry = 'Ch';
        vAccount.BillingState = '000001';
        vAccount.BillingStreet = 'Tiananmen';
        vAccount.BillingPostalCode = '200000';
        vAccount.ownerId = u.Id;
        insert vAccount;
        
        contact con = new Contact();
        con.email='testpiic@org.com';
        con.lastName='TestCon';
        con.accountid=vAccount.id;
        insert con;
        
        Case vCs = new Case();
        vCs.subject ='testing';
        vCs.Origin = 'PIC US Email';    
        vCs.Status= 'New';
        vCs.Description = 'Test Description';
        vCs.AccountId = vAccount.id;
        vCs.contactId=con.id;
        vCs.ownerId = u.id;   
        vCs.RecordTypeid = VCaseRT;         
        vCsLst.add(vCs);               
        insert vCsLst;
         
        for(Case vCaseUpdate: vCsLst){
            vCaseUpdate.Description = 'Test Description 123';
            // vCs.BusinessHoursId = u.Primary_Business_Hours__c; 
            vCaseUpdate.Owner_Lookup__c = vCs.OwnerId; 
            vCaseUpdate.Business_Hous_Are_Set__c = true;
            vCsLstUpdate.add(vCaseUpdate); 
         }        
        update vCsLstUpdate;
        vCsMap.put(vCs.Id,vCs);    
        CaseServices.fillinBusinessHoursLookup(vCsLst);
        CaseServices.fillinOwnerLookup(vCsLst,vCsMap);      
        List<LiveChatTranscript> listLiveChatTranscript = new List<LiveChatTranscript>();
        LiveChatTranscript vLiveChat = new LiveChatTranscript();
        vLiveChat = new LiveChatTranscript();         
        vLiveChat.Body              = 'Hi How are you I am testing here';
        vLiveChat.CaseId            = vCsLst[0].id;
        vLiveChat.LiveChatVisitorId = u.id;
        listLiveChatTranscript.add(vLiveChat);
        //insert listLiveChatTranscript;  
       CaseServices.createCaseFromLiveChatTranscript(listLiveChatTranscript);

     }     
      public static String getUserNamePrefix(){
        return UserInfo.getOrganizationId() + System.now().millisecond();
      }
      
   public static testmethod void ICTBusinessHourstest(){
    Apex_Helper_Settings__c ahs = new Apex_Helper_Settings__c();
    ahs.Active__c = TRUE;
    ahs.Description__c = 'TEST';
    ahs.Value__c = '001E000001HL83N';
    ahs.name = 'PIC Universal Customer Account';
    insert ahs;
    
    Apex_Helper_Settings__c ahs1 = new Apex_Helper_Settings__c();
    ahs1.Active__c = TRUE;
    ahs1.Description__c = 'TEST';
    ahs1.Value__c = '001E000001HL83N';
    ahs1.name = 'Internal Account';
    insert ahs1;
    
    Case cas = new Case(TE_Enquiry_Flag__c=true,Origin='Web',Priority = 'Medium',Status='Assigned');
    insert cas;

    }
    
}