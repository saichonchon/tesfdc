/**
*   This test class is for ContactRoleMQLController.
*
@author Satyabrat Mohapatra
@created 2017-02-08
@version 1.0

* - Test coverage - 87%
*/
@isTest(SeeAllData = true)
private class ContactRoleMQLController_test {
   
    static testMethod void testMethod1(){
      //Test.startTest();
       /*ClsTestCustomSettingHelper.getApex_Helper_Settings();
       ClsTestCustomSettingHelper.getOpportunity_Approvers();       
       ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
       ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();     
       ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
       ClsTestCustomSettingHelper.getTE_Connection();
       ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings(); 
        PMV_Sales_Process_Settings__c ssps1 = ClsTestHelp.createTestSSPS1();*/
        //PMV_Sales_Process_Settings__c ssps2 = ClsTestHelp.createTestSSPS1();
      // ClsTestCustomSettingHelper.getADMTerritoryCode(); 
     /*  Consumer_Device_Opportunity_Record_Types__c opp5=new Consumer_Device_Opportunity_Record_Types__c();
        opp5.Name='Engineering Opportunity-CSD';
        opp5.Record_Type_Id__c='012E0000000JOQLIA4';   
        insert opp5;
         
        Consumer_Device_Opportunity_Record_Types__c opp=new Consumer_Device_Opportunity_Record_Types__c();
        opp.Name='OEM';
        opp.Record_Type_Id__c='012E0000000JOQLIA4';   
        insert opp;
        
        Consumer_Device_Opportunity_Record_Types__c opp4=new Consumer_Device_Opportunity_Record_Types__c();
        opp4.Name='Sales Opportunity-CSD';
        opp4.Record_Type_Id__c='012E0000000JOQLIA4';   
        insert opp4;
        Apex_Helper_Settings__c Apexsett4 = new Apex_Helper_Settings__c();
        Apexsett4.Name = 'GAM Record Type Id';
        Apexsett4.Value__c = '012E0000000J6k0IAC';
        Apexsett4.Active__c = true;
        insert Apexsett4;
        
        Apex_Helper_Settings__c ah = new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
		insert ah;*/
        // User Record
        Profile p = [SELECT Id FROM Profile WHERE Name='DND Engineering User w/Cost']; 
        
        User u = [Select Id,UserName from User Where Id !=:UserInfo.getUserId() and IsActive = true and Profile.Name='DND Engineering User w/Cost' LIMIT 1];

        System.runAs(u) {
        }
        User u1 = new User();
        u1.GIBU__c='Industrial'; 
        u1.Sub_Vertical__c = 'A&C,IB,Industrial,Rail';
        //u1.PMV_Type_Initialization__c = 'Standard';
        u1.Alias = 'standt'; 
        u1.Email='tst@testorg.com'; 
        u1.EmailEncodingKey='UTF-8'; 
        u1.LastName='Tst'; 
        u1.LanguageLocaleKey='en_US'; 
        u1.LocaleSidKey='en_US'; 
        u1.ProfileId = p.Id; 
        u1.TimeZoneSidKey='America/Los_Angeles'; 
        u1.UserName='tst02611@test.com'; 
        u1.CSD_Region__c='Taiwan';
        
        User u2 = new User();
        u2.GIBU__c='Industrial'; 
        u2.Sub_Vertical__c = 'A&C,IB,Industrial,Rail'; 
        //u2.PMV_Type_Initialization__c = 'Standard';
        u2.Alias = 'standt'; 
        u2.Email='tt@testorg.com'; 
        u2.EmailEncodingKey='UTF-8'; 
        u2.LastName='Tt'; 
        u2.LanguageLocaleKey='en_US'; 
        u2.LocaleSidKey='en_US'; 
        u2.ProfileId = p.Id; 
        u2.TimeZoneSidKey='America/Los_Angeles'; 
        u2.UserName='tst0311@test.com'; 
        u2.CSD_Region__c='Taiwan';
        
        //insert new List<User> {u1,u2}; 
        Test.startTest();

        try {
            //insert new List<User> {u1,u2};
        } catch (Exception e) {
           System.debug('An error occurred');
        }
        Test.stopTest(); 
       
        Account a = new Account();
        a.RecordTypeId = '012E0000000JMUk';
        a.Name = 'Test Co.';
        a.Type = 'Prospect';
        a.Business_Unit_Level_2__c = 'Appliances';
        a.BillingStreet = '298 S. Ringo Street';
        a.BillingCity = 'Little Rock';
        a.BillingState = 'AR';
        a.BillingPostalCode = '72201';
        a.BillingCountry = 'USA';
        a.Phone = '501-555-5555';
        a.Website = 'www.testco.com';
        //insert a;
        try {
            insert a;
        } catch (Exception e) {
           System.debug('An error occurred');
        }
        System.debug('created account');
        
        Contact c = new Contact();
        c.FirstName = 'Paul13';
        c.LastName = 'Test13';
        c.AccountId = a.id;
        c.MailingStreet = '298 S. Ringo Street';
        c.MailingCity = 'Little Rock';
        c.MailingState = 'AR';
        c.MailingPostalCode = '72201';
        insert c;
        System.debug('created primary contact');
        
        Contact ci = new Contact();
        ci.FirstName = 'Bob12';
        ci.LastName = 'Test12';
        ci.AccountId = a.id;
        ci.MailingStreet = '298 S. Ringo Street';
        ci.MailingCity = 'Little Rock';
        ci.MailingState = 'AR';
        ci.MailingPostalCode = '72201';
        insert ci;
        
        OppotunityContactRole__c ocr1=new OppotunityContactRole__c();
        ocr1.Name=userinfo.getUserId();
        ocr1.PrimaryId__c=ci.id;
        ocr1.SlectedContacts__c=ci.id;
        upsert ocr1 Name;
        
        System.debug('created primary contact');
        //Opportunity op= ClsTestHelp.createTestOpportunity();
        Opportunity o = new Opportunity();
        PMV_Sales_Process_Settings__c ps = new PMV_Sales_Process_Settings__c();
        ps.GIBU__c = 'Industrial';
        ps.PMV_Type__c = 'IND Standard Sales opp';
        ps.Subvertical_BU__c = 'A&C,IB,Industrial,Rail';
        ps.PMV_Type_Initialization__c = 'Standard'; 
        ps.Name = 'nrFIASIND Standard Sales opp1';
        insert ps;
        
        o.RecordType = [SELECT Id, Name, DeveloperName FROM RecordType WHERE Name = 'DND Opportunity' LIMIT 1];
        o.Name = 'New Record';
        o.AccountId = a.Id;
        o.StageName = 'Posted';
        o.CloseDate = Date.today();
        o.Manufacturing_Start_Date__c = Date.today(); 
        o.Currency_Confirm__c = TRUE;
        o.Type__c = 'New Business';
        o.Description = 'Test Record';
        //o.Phase_del__c = 'New Opportunity';
        o.Opportunity_Step__c = 'Reviewing With PM';
        o.TE_Market_Share_Potential__c = 100.00;
        o.DND_Application__c = 'Routers';
        //o.OpportunityContactRole_Contacts_Primary__c = string.valueOf(c.Id);
        //o.OpportunityContactRole_Contacts__c = string.valueOf(c.Id);
        o.OwnerId = [select id from user where profile.name ='DND Engineering User w/Cost' and isactive=true limit 1].id;
        insert o;
             
        System.debug('created opportunity');
        OpportunityContactRole ocr = new OpportunityContactRole();
        ocr.ContactId = c.Id;
        //ocr.Contact.Level__c = o.Id;
        ocr.OpportunityId = o.Id;
        ocr.IsPrimary = TRUE;
        ocr.Role = 'Decision Maker';
        insert ocr;
        System.debug('created opportunity contact role for primary');

        TEMarketing__MQLRecord__c mq = new TEMarketing__MQLRecord__c();
        mq.TEMarketing__MQL_Date__c = system.now().addmonths(-12);
        mq.CurrencyIsoCode = 'RON';
        mq.TEMarketing__Contact__c = c.id;
        insert mq;
        PageReference pageRef = Page.Opp_Contact_Roles;
        Test.setCurrentPage(pageRef);
        System.CurrentPageReference().getParameters().put('oppid',o.id);//Pass Id to page
        System.currentPageReference().getParameters().put('contact',ci.Id);
        System.currentPageReference().getParameters().put('TEMarketing__MQLRecord__c',mq.Id);
        TEMarketing__MQLRecord__c tem = new TEMarketing__MQLRecord__c();
        ApexPages.StandardController sc = new ApexPages.standardController(o);
        ContactRoleMQLController mql1= new ContactRoleMQLController(sc);
        mql1.contactValue();
        mql1.SaveOppCon();
        //mql1.deMethod();
        PageReference result = mql1.CancelOppCon();
        PageReference result1 = mql1.SaveOppCon();
        PageReference result2 = mql1.MqlNav();
        System.currentPageReference().getParameters().put('contact',Null);
        System.CurrentPageReference().getParameters().put('oppid',Null);//Pass Id to page
        ApexPages.StandardController sc2 = new ApexPages.standardController(o);
        ContactRoleMQLController mql2= new ContactRoleMQLController(sc2);
        System.currentPageReference().getParameters().put('TEMarketing__MQLRecord__c',Null);
        TEMarketing__MQLRecord__c tem1 = new TEMarketing__MQLRecord__c();
        mql2.SaveOppCon();
    }
    
}