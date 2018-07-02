@isTest(SeeAllData=TRUE)
public class SMA_OppContactHandler_Test {
    static testMethod void testOppContactRole(){
   	  /* ClsTestCustomSettingHelper.getApex_Helper_Settings();
       ClsTestCustomSettingHelper.getOpportunity_Approvers();       
       ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
       ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();     
       ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
       ClsTestCustomSettingHelper.getTE_Connection();
       ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings(); 
       ClsTestCustomSettingHelper.getADMTerritoryCode(); 
       ClsTestCustomSettingHelper.getADMTerritoryCode();*/
        
      //  Apex_Helper_Settings__c ah = new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
		//insert ah; 
        User u = [Select Id,UserName from User Where Id !=:UserInfo.getUserId() and IsActive = true and Profile.Name='DND Engineering User w/Cost' LIMIT 1];

        System.runAs(u) {
        
        
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
        c.Email = 'abc12@test.com';
        c.Phone = '32145656';
        c.MailingPostalCode = '72201';
        insert c;
        OppotunityContactRoletemp__c opcon = new OppotunityContactRoletemp__c(UserId__c = u.Id ,PrimaryId__c = c.Id ,Role__c = 'Opportunity Contact' ,SlectedContacts__c = c.Id );
        insert opcon;
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
     	/*OppotunityContactRoletemp__c ocr1 = new OppotunityContactRoletemp__c();
       // ocr1.Name=userinfo.getUserId();
        ocr1.UserId__c= u.Id;
        ocr1.PrimaryId__c=c.id;
        ocr1.SlectedContacts__c=c.id;
        ocr1.Role__c='Opportunity Contact';
        insert ocr1; */
         
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
        } 
                
    }           
    }