/**
*   This test class is for exOpportunity_Contact_roles.
*
@author Satyabrat Mohapatra
@created 2017-02-08
@version 1.0
*
* - Test coverage - 100%
**/
@isTest
private class exOpportunity_contact_roles_Test {
    
    static testMethod void testMethod1(){
      /* ClsTestCustomSettingHelper.getApex_Helper_Settings();
       ClsTestCustomSettingHelper.getOpportunity_Approvers();       
       ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
       ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();     
       ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
       ClsTestCustomSettingHelper.getTE_Connection();
       ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings(); 
       ClsTestCustomSettingHelper.getADMTerritoryCode(); */
       
        Opportunity oppy = new Opportunity();
           PageReference pageRef = Page.OpportunityContactRoles;
           pageRef.getParameters().put('id',oppy.Id);
           Test.setCurrentPage(pageRef); 
        ApexPages.currentPage().getParameters().put('id', 'Test');
        exOpportunity_contact_roles roles= new exOpportunity_contact_roles();
           ApexPages.currentPage().getParameters().put('oppid',oppy.id);
        roles.editOpp();
        roles.deleteOpp();
                
 } 
 static testMethod void testMethod2(){
    // User u = [select id from User where username = 'satyabrat.mohapatra@te.com.c2s.sma.dev' limit 1];
       ClsTestCustomSettingHelper.getApex_Helper_Settings();
       ClsTestCustomSettingHelper.getOpportunity_Approvers();       
       ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
       ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();     
       ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getTE_Connection();
        ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings(); 
       ClsTestCustomSettingHelper.getADMTerritoryCode(); 
       ClsTestCustomSettingHelper.getTrigger_Configuration();
        Apex_Helper_Settings__c ah = new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
		insert ah; 
     
        ID accRecid = [Select Id,Name from RecordType where Name = 'Prospect'].Id;
        ID oRTid = [Select Id,Name from RecordType where Name = 'Opportunity - Sales Project'].Id;
        
        Account a1 = ClsTestHelp.createTestAccounts(); 
        a1.recordTypeId = accRecid;
        insert a1;
        
        Contact c = new Contact();
        c.FirstName = 'Paul';
        c.LastName = 'Test';
        c.AccountId = a1.id;
        c.MailingStreet = '298 S. Ringo Street';
        c.MailingCity = 'Little Rock';
        c.MailingState = 'AR';
        c.MailingPostalCode = '72201';
        insert c;
        
        Contact ci = new Contact();
        ci.FirstName = 'Bob';
        ci.LastName = 'Test';
        ci.AccountId = a1.id;
        ci.MailingStreet = '298 S. Ringo Street';
        ci.MailingCity = 'Little Rock';
        ci.MailingState = 'AR';
        ci.MailingPostalCode = '72201';
        insert ci;
        
        Opportunity o = ClsTestHelp.createTestOpportunity();  
        o.AccountId = a1.id;
        o.OEM__c = a1.id;
        o.RecordTypeId = oRTid;
        o.StageName = 'Approved/Active'; 
        insert o;
         
        OpportunityContactRole ocr = new OpportunityContactRole();
        ocr.ContactId = c.Id;
        ocr.OpportunityId = o.Id;
        ocr.IsPrimary = TRUE;
        ocr.Role = 'Decision Maker';
        insert ocr;
        System.debug('created opportunity contact role for primary');
        
        OpportunityContactRole ocr1 = new OpportunityContactRole();
        ocr1.ContactId = ci.Id;
        ocr1.OpportunityId = o.Id;
        ocr1.IsPrimary = FALSE;
        ocr1.Role = 'Decision Maker';
        insert ocr1;
        System.debug('created opportunity contact role for non-primary contact');
        Update o;
       
        exOpportunity_contact_roles roles1= new exOpportunity_contact_roles(new ApexPages.StandardController(o));
        PageReference pageRef = Page.OpportunityContactRoles;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppid',o.id);//Pass Id to page
        Test.startTest();
            roles1.deleteOpp();
     		roles1.editOpp();
            System.debug('Record Delete');
        Test.stopTest(); 
        
    }
     
  }