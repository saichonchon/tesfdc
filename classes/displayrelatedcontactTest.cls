/**
*   This test class is for OpportunityPopup.
*
@author Satyabrat Mohapatra
@created 2017-20-08
@version 1.0

* - Test coverage - 86%
*/
@isTest
public class displayrelatedcontactTest 
{
    static testmethod void testmethod1()
    {
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
         //User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        //System.runAs ( thisUser ){
        ID accRecid = [Select Id,Name from RecordType where Name = 'Prospect'].Id;
        ID oRTid = [Select Id,Name from RecordType where Name = 'Opportunity - Sales Project'].Id;
        Account a1 = ClsTestHelp.createTestAccounts(); 
        a1.recordTypeId = accRecid;
        insert a1;
       // Account a = new Account();
        /*a.Name = 'Test Co.';
        a.BillingStreet = '298 S. Ringo Street';
        a.BillingCity = 'Little Rock';
        a.BillingState = 'AR';
        a.BillingPostalCode = '72201';
        a.BillingCountry = 'USA';
        a.Phone = '501-555-5555';
        a.Website = 'www.testco.com';
        insert a; */
        System.debug('created account');
        
        Contact c = new Contact();
        c.FirstName = 'Paul';
        c.LastName = 'Test';
        c.AccountId = a1.id;
        c.MailingStreet = '298 S. Ringo Street';
        c.MailingCity = 'Little Rock';
        c.MailingState = 'AR';
        c.MailingPostalCode = '72201';
        insert c;
        opportunity o = new opportunity();
        o.RecordTypeId = oRTid;
        o.name='opportunity1';
        o.account=a1;
        o.AccountId=a1.id;
        o.type='New Business';
        o.Primary_Market_Type__c = 'Commercial Aerospace: Business Jets';
		o.CurrencyIsoCode = 'USD';
        o.Currency_Confirm__c = True;
        o.CloseDate = system.today();
        o.Amount = 1;
        o.opportunity_Health__c = 'Caution';
        o.Probability = 80.00;
        o.StageName = 'Approved/Active';
        insert o; 
     
        PageReference pageRef = Page.OpportunityPopup;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('accountId',a1.id);//Pass Id to page
        ApexPages.currentPage().getParameters().put('accid',a1.id);//Pass Id to page
        ApexPages.currentPage().getParameters().put('contactId',c.Id);
        ApexPages.currentPage().getParameters().put('contactId1',c.Id);
        ApexPages.currentPage().getParameters().put('conRec',c.Id);
        ApexPages.currentPage().getParameters().put('conid',c.Id);
        ApexPages.currentPage().getParameters().put('accRecord',a1.Id);
        ApexPages.currentPage().getParameters().put('conRec',a1.Id);
        ApexPages.currentPage().getParameters().put('selectedAccount',a1.Id);
        ApexPages.currentPage().getParameters().put('selectedAccId',a1.Id);
        //oRTid=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('DND Opportunity').getRecordTypeId(); 
        ApexPages.currentPage().getParameters().put('recordTypeId',oRTid);
        displayrelatedcontact ds = new displayrelatedcontact();
        ds.recordTypeId=oRTid;
        //ds.ContactWrapper wrap = new displayrelatedcontact.ContactWrapper();
        
        displayrelatedcontact.ContactWrapper wrap = new displayrelatedcontact.ContactWrapper(c);
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ){
        
		SelectedRecordType__c cs = new SelectedRecordType__c();
			cs.SelRecordType__c ='DND Opportunity';
			cs.SelRecordType__c = oRTid;
        	cs.Name = 'Test';
		insert cs;
        }
        ds.gotoOpportunity();
        ds.showContacts();
        ds.getSelected();
        ds.GetselectedConList(); 
 		ds.cancel();
        ds.setError();
		ApexPages.currentPage().getParameters().put('accountId',Null);//Pass Id to page
        ApexPages.currentPage().getParameters().put('accid',Null);//Pass Id to page
        ApexPages.currentPage().getParameters().put('contactId',Null);
        ApexPages.currentPage().getParameters().put('conid',Null);
        ApexPages.currentPage().getParameters().put('conRec',Null);
        ApexPages.currentPage().getParameters().put('selectedAccount',Null);
        ApexPages.currentPage().getParameters().put('selectedAccId',Null);
        displayrelatedcontact ds1 = new displayrelatedcontact();
        ds1.cancel(); 
          User thisUser1 = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser1 ){
        
		SelectedRecordType__c cs = new SelectedRecordType__c();
			cs.SelRecordType__c ='DND Opportunity';
			cs.SelRecordType__c = oRTid;
        	cs.Name = 'Test';
		insert cs;
        }                  
        ds1.gotoOpportunity();
        ds1.showContacts();
        ds1.getSelectedWrapper();
        ds1.getSelected();
         
        
    }
    
}