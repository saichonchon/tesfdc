@istest
public class liveAgentDirectEXTN_Test {
    
    public static testmethod void liveAgentDirectEXTN(){
       
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getCCPTriggerSettings();       
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getCaseFinalVariables();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        
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
        u.Username ='Fpic' + u.Email;
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
        con.firstName='Testfcon';
        con.phone='99987777777';
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
        vCs.CurrencyIsoCode='EUR';
        vCs.RecordTypeid = VCaseRT;         
        vCsLst.add(vCs);               
        insert vCsLst;
       Live_Agent_Org_Settings__c LAOrgset = new Live_Agent_Org_Settings__c();
        LAOrgset.Direct_Chat_URL__c ='http://te338853-tyco.cs90.force.com/livechat/apex/livechatbybooks?language=en#deployment_id='; 
        LAOrgset.Direct_Chat_Button__c ='6788999999';
        LAOrgset.DeploymentURL__c='https://c.la4-c2cs-dfw.salesforceliveagent.com/content/g/js/42.0/deployment.js';
        LAOrgset.initURL__c='https://d.la4-c2cs-dfw.salesforceliveagent.com/chat';
        LAOrgset.DeploymentID__c='572E0000000blJJ';            
         LAOrgset.OrgID__c='00D1F0000000dD6';
        insert LAOrgset;
       test.startTest();
         PageReference pageRef = Page.LiveAgentDirectToAgent;
         Test.setCurrentPage(pageRef);
         pageRef.getParameters().put('caseid', vCsLst[0].Id);
         apexpages.StandardController sc =new apexpages.StandardController(vCs);
         liveAgentDirectEXTN objCls=new liveAgentDirectEXTN(sc); 
        
        
        test.stopTest();
	    
  }
     public static testMethod void TestMethod2(){
          ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getCCPTriggerSettings();       
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getCaseFinalVariables();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        
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
        u.Username ='Fpic' + u.Email;
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
        con.firstName='Testfcon';
        con.phone='99987777777';
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
        vCs.CurrencyIsoCode='EUR';
        vCs.RecordTypeid = VCaseRT;         
        vCsLst.add(vCs);               
        insert vCsLst;
       Live_Agent_Org_Settings__c LAOrgset = new Live_Agent_Org_Settings__c();
        LAOrgset.Direct_Chat_URL__c ='http://te338853-tyco.cs90.force.com/livechat/apex/livechatbybooks?language=en#deployment_id='; 
        LAOrgset.Direct_Chat_Button__c ='6788999999';
        LAOrgset.DeploymentURL__c='https://c.la4-c2cs-dfw.salesforceliveagent.com/content/g/js/42.0/deployment.js';
        LAOrgset.initURL__c='https://d.la4-c2cs-dfw.salesforceliveagent.com/chat';
        LAOrgset.DeploymentID__c='572E0000000blJJ';            
         LAOrgset.OrgID__c='00D1F0000000dD6';
        insert LAOrgset;
         
    
        test.startTest ();
       
         PageReference pageRef = Page.ContactLiveAgentDirectToAgent;
        Test.setCurrentPage(pageRef);
         pageRef.getParameters().put('contactid', con.Id);
        apexpages.StandardController sc =new apexpages.StandardController(con);
         liveAgentDirectEXTN objCls=new liveAgentDirectEXTN(sc); 
          
        test.stopTest();
    }

}