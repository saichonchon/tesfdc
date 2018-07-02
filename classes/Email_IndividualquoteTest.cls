/**
 * test class for class CtrlEnergyQuoteExpirationSetting
 *
 * @author     Tangyong Li
 * @created    2017-08-22
 * @version    1.0
 * @since      38.0 (Force.com ApiVersion)
 *
 * @changelog
 * 2017-08-22  Tangyong Li <tangyong.li@capgemini.com>
 * - Created
 */
@isTest
public class Email_IndividualquoteTest {
    
    static testMethod void myUnitTest() {
        User u = ClsTestHelp.createTestUsers();
        insert u;
        System.runAs(u) {
            ClsTestCustomSettingHelper.getApex_Helper_Settings();
            ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
            ClsTestCustomSettingHelper.getOpportunity_Approvers();
            ClsTestCustomSettingHelper.getTrigger_Configuration();
            ClsTestCustomSettingHelper.getProfitBUCenterMapping();
            ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
            ClsTestCustomSettingHelper.getQuoteValiditySetting();
            ClsTestCustomSettingHelper.getQuoteExpirationSetting();
            ClsTestCustomSettingHelper.getADMTerritoryCode();
            ClsTestHelp.createTestOrgWideSettings1();
            RecordType salesRT = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Opportunity' AND DeveloperName = 'Energy_Sales' limit 1];
            
            Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy1();
            sh.Level_4_Territory_Code__c = '4444';
            sh.Level_5_Territory_Code__c = '5555';
            sh.Level_7_Territory_Code__c = '7777';
            sh.Level_7_Assigned_Users__c = u.Id;
            insert sh;
            Account acct = ClsTestHelp.createTestAccounts();
            acct.Name = 'AMP Iron Foundries Inc';
            acct.AnnualRevenue = 2000000.11; 
            acct.Legally_Restricted__c = false;  
            acct.BillingCity = 'Shanghai';  
            acct.BillingCountry = 'China';
            acct.BillingState = '000000';
            acct.BillingStreet = 'Changning';
            acct.BillingPostalCode = '200051';
            acct.BU_Owner_Email__c = 'testMail@oinio.com';
            acct.SALES_TERRITORY_CDE__c = '121212';
            acct.Sales_Hierarchy__c = sh.Id;
            acct.Source_System__c = 1;
            insert acct;
            Contact cont = ClsTestHelp.createTestContacts();
            cont.Email = 'testtetset@oinio.com';
            cont.AccountId = acct.Id;
            insert cont;
            list<Opportunity> list_oppys = new list<Opportunity>();
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Name = 'testOppy2';
            oppy.AccountId = acct.Id;
            oppy.End_Customer__c = acct.Id;
            oppy.Type__c = 'Quote';
            oppy.Probability__c = '30';
            oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
            oppy.Customer_Contact_Name__c = cont.Id;
            Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Type__c = 'Tender';
            oppy2.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
            oppy2.AccountId = acct.Id;
            oppy2.Probability__c = '30';
            oppy2.End_Customer__c = acct.Id;
            oppy2.Customer_Contact_Name__c = cont.Id;
            Opportunity oppy3 = ClsTestHelp.createTestOpportunity();
            oppy3.Type__c = 'Contract';
            oppy3.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
            oppy3.AccountId = acct.Id;
            oppy3.End_Customer__c = acct.Id;
            oppy3.Probability__c = '30';
            oppy3.Customer_Contact_Name__c = cont.Id;
            Opportunity oppy4 = ClsTestHelp.createTestOpportunity();
            oppy4.AccountId = acct.Id;
            oppy4.Probability__c = '30';
            oppy4.End_Customer__c = acct.Id;
            oppy4.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
            list_oppys.add(oppy);
            list_oppys.add(oppy2);
            list_oppys.add(oppy3);
            list_oppys.add(oppy4);
            insert list_oppys; 
            Attachment attach = ClsTestHelp.createTestAttachments();
            attach.ParentId = oppy.Id;
            attach.Name = 'attach';
            attach.body = Blob.valueOf('body');
            insert attach;
            EmailTemplate e = ClsTestHelp.createTestEmailTemplates();
            e.Name = 'testAustraliaTemplate';
            e.DeveloperName = 'testTemplate';
            e.FolderId = UserInfo.getUserId();
            e.TemplateType = 'text';
            e.isActive = true;
            e.subject = 'subject';
            e.HtmlValue = 'body';
            insert e;
            Document d = ClsTestHelp.createTestDocuments();
            d.FolderId = UserInfo.getUserId();
            d.Name = 'Tyco';
            insert d;
            Territory_Email_Template__c tet = ClsTestHelp.createTestTerritoryEmailTemplate();
            tet.Email_Template_Name__c = 'testAustraliaTemplate';
            tet.Level_4_Territory_Code__c = '4444';
            tet.Level_5_Territory_Code__c = '5555';
            insert tet;
            Energy_Quote__c quote1 = ClsTestHelp.createTestEnergyQuote();
            quote1.Name = 'testQuote1';
            quote1.Opportunity_Name__c = oppy.Id;
            quote1.Account_Name__c = acct.Id;
            quote1.Selected_Email_Template__c = 'testTemplate';
            quote1.Contact__c = cont.Id;
            insert quote1;
            PageReference page = new PageReference('/apex/SAPQuotePdf'); 
            Test.setCurrentPageReference(page);
            ApexPages.currentPage().getParameters().put('id',oppy.Id); 
            ApexPages.currentPage().getParameters().put('quoteId',quote1.Id); 
            ApexPages.currentPage().getParameters().put('accid',acct.Id); 
            
            Test.startTest();
            Email_Individualquote eq = new Email_Individualquote();
            eq.contactInnerClassList.add(new Email_Individualquote.ContactInnerClass(new Contact(LastName='test', Email='aaa@aaa.com'),true,false));
            eq.orderAttachment.add(new Email_Individualquote.AttachmentSelection(true, attach));
            eq.prepareAttachment();
            eq.showAttachment();
            eq.gettemplates();
            //eq.getStandAcctsFromOppy(oppy);
            eq.tId = e.Id;
            eq.populatetemplate();
            eq.send_templates();
            //eq.getSignatureUrl();
            //eq.assignselectedcontact();
            Test.stopTest();
            System.assert(quote1.Id != null);
        }
    }
    
    static testMethod void myUnitTest1() {
        User u = ClsTestHelp.createTestUsers();
        insert u;
        System.runAs(u) {
        	ClsTestCustomSettingHelper.getApex_Helper_Settings();
            ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
            ClsTestCustomSettingHelper.getOpportunity_Approvers();
            ClsTestCustomSettingHelper.getTrigger_Configuration();
            ClsTestCustomSettingHelper.getProfitBUCenterMapping();
            ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
            ClsTestCustomSettingHelper.getQuoteValiditySetting();
            ClsTestCustomSettingHelper.getQuoteExpirationSetting();
            ClsTestCustomSettingHelper.getADMTerritoryCode();
            ClsTestHelp.createTestOrgWideSettings1();
            RecordType salesRT = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Opportunity' AND DeveloperName = 'Energy_Sales' limit 1];
            
            Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy1();
            sh.Level_4_Territory_Code__c = '4444';
            sh.Level_5_Territory_Code__c = '5555';
            sh.Level_7_Territory_Code__c = '7777';
            sh.Level_7_Assigned_Users__c = u.Id;
            insert sh;
            Account acct = ClsTestHelp.createTestAccounts();
            acct.Name = 'AMP Iron Foundries Inc';
            acct.AnnualRevenue = 2000000.11; 
            acct.Legally_Restricted__c = false;  
            acct.BillingCity = 'Shanghai';  
            acct.BillingCountry = 'China';
            acct.BillingState = '000000';
            acct.BillingStreet = 'Changning';
            acct.BillingPostalCode = '200051';
            acct.BU_Owner_Email__c = 'testMail@oinio.com';
            acct.SALES_TERRITORY_CDE__c = '121212';
            acct.Sales_Hierarchy__c = sh.Id;
            acct.Source_System__c = 42;
            insert acct;
            Contact cont = ClsTestHelp.createTestContacts();
            cont.Email = 'testtetset@oinio.com';
            cont.AccountId = acct.Id;
            insert cont;
            list<Opportunity> list_oppys = new list<Opportunity>();
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Name = 'testOppy2';
            oppy.AccountId = acct.Id;
            oppy.Probability__c = '30';
            oppy.Type__c = 'Quote';
            oppy.RecordTypeId = salesRT.Id;
            oppy.Customer_Contact_Name__c = cont.Id;
            oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
            Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Type__c = 'Tender';
            oppy2.RecordTypeId = salesRT.Id;
            oppy2.Probability__c = '30';
            oppy2.AccountId = acct.Id;
            oppy2.Customer_Contact_Name__c = cont.Id;
            oppy2.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
            Opportunity oppy3 = ClsTestHelp.createTestOpportunity();
            oppy3.Type__c = 'Contract';
            oppy3.AccountId = acct.Id;
            oppy3.Probability__c = '30';
            oppy3.Customer_Contact_Name__c = cont.Id;
            oppy3.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
            Opportunity oppy4 = ClsTestHelp.createTestOpportunity();
            oppy4.AccountId = acct.Id;
            oppy4.Probability__c = '30';
            oppy4.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
            list_oppys.add(oppy);
            list_oppys.add(oppy2);
            list_oppys.add(oppy3);
            list_oppys.add(oppy4);
            insert list_oppys; 
            Attachment attach = ClsTestHelp.createTestAttachments();
            attach.ParentId = oppy.Id;
            attach.Name = 'attach';
            attach.body = Blob.valueOf('body');
            insert attach;
            EmailTemplate e = ClsTestHelp.createTestEmailTemplates();
            e.Name = 'testAustraliaTemplate';
            e.DeveloperName = 'testTemplate';
            e.FolderId = UserInfo.getUserId();
            e.TemplateType = 'text';
            e.isActive = true;
            e.subject = 'subject';
            e.HtmlValue = 'body';
            insert e;
            Document d = ClsTestHelp.createTestDocuments();
            d.FolderId = UserInfo.getUserId();
            d.Name = 'Tyco';
            insert d;
            Territory_Email_Template__c tet = ClsTestHelp.createTestTerritoryEmailTemplate();
            tet.Email_Template_Name__c = 'testAustraliaTemplate';
            tet.Level_4_Territory_Code__c = '4444';
            tet.Level_5_Territory_Code__c = '5555';
            insert tet;
            Energy_Quote__c quote1 = ClsTestHelp.createTestEnergyQuote();
            quote1.Name = 'testQuote1';
            quote1.Opportunity_Name__c = oppy.Id;
            quote1.Account_Name__c = acct.Id;
            quote1.Selected_Email_Template__c = 'testTemplate';
            quote1.Contact__c = cont.Id;
            insert quote1;
            PageReference page = new PageReference('/apex/SAPQuotePdf'); 
            Test.setCurrentPageReference(page);
            ApexPages.currentPage().getParameters().put('id',oppy.Id); 
            ApexPages.currentPage().getParameters().put('quoteId',quote1.Id); 
            ApexPages.currentPage().getParameters().put('accid',acct.Id); 
        	
        	Test.startTest();
        	ApexPages.currentPage().getParameters().put('id',oppy2.Id); 
            new Email_Individualquote().send_templates();
            ApexPages.currentPage().getParameters().put('id',oppy3.Id); 
            new Email_Individualquote().send_templates();
            ApexPages.currentPage().getParameters().put('id',oppy4.Id);
            new Email_Individualquote().send_templates();
            Test.stopTest();
            System.assert(quote1.Id != null);
        }
    }
    
    static testMethod void myUnitTest2() {
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'helloSand0728@testCompany1407281004.com';
        u.FirstName ='Test0728';
        u.LastName = 'User0728';
        u.Alias = 'dpse0728';
        u.CommunityNickname = 'TMD0728';
        u.Te_Network_Id__c = '0529';
        u.GIBU__c = 'Appliances';
        u.Username = 'helloSand0728@testCompany1407281004.com';
        insert u;
        System.runAs(u) {
            ClsTestCustomSettingHelper.getApex_Helper_Settings();
            ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
            ClsTestCustomSettingHelper.getOpportunity_Approvers();
            ClsTestCustomSettingHelper.getTrigger_Configuration();
            ClsTestCustomSettingHelper.getProfitBUCenterMapping();
            ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
            ClsTestCustomSettingHelper.getQuoteValiditySetting();
            ClsTestCustomSettingHelper.getQuoteExpirationSetting();
            ClsTestCustomSettingHelper.getADMTerritoryCode();
            ClsTestHelp.createTestOrgWideSettings1();
            Territory_Email_Template__c tet = ClsTestHelp.createTestTerritoryEmailTemplate();
            tet.Email_Template_Name__c = 'testAustraliaTemplate';
            tet.Level_4_Territory_Code__c = '4444';
            tet.Level_5_Territory_Code__c = '5555';
            insert tet;
            Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
            sh.Level_4_Territory_Code__c = '4444';
            sh.Level_5_Territory_Code__c = '5555';
            sh.Level_7_Territory_Code__c = '103007';
	    	sh.Level_7_Default_Owner__c = u.Id;
	        sh.Level_7_Territory_Name__c = 'test aa7';
	        sh.Level_7_Assigned_User_Network_Ids__c = u.Te_Network_Id__c;
	        sh.Level_7_Assigned_Users__c = u.Id;
	        sh.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
            insert sh;
            Account acct = ClsTestHelp.createTestAccounts();
            acct.Name = 'AMP Iron Foundries Inc';
            acct.BU_Owner_Email__c = 'testMail@oinio.com';
            acct.SALES_TERRITORY_CDE__c = '121212';
            //acct.RecordTypeId = ClsTestHelp.createTestRecordType27().Id;
            acct.Sales_Hierarchy__c = sh.Id;
            acct.OwnerId = u.Id;
            acct.Source_System__c = 51;
            insert acct;
            system.debug('acct owner :::: 11' + [select Level_7_Assigned_Users__c from Sales_Hierarchy__c where id =: sh.Id].Level_7_Assigned_Users__c);
            system.debug('acct owner :::: 22' + [select ownerid from account where id =: acct.id].OwnerId);
            Contact cont = ClsTestHelp.createTestContacts();
            cont.Email = 'testtetset@oinio.com';
            cont.AccountId = acct.Id;
            insert cont;
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
        	oppy.Name = 'testOppy2';
        	oppy.AccountId = acct.Id;
        	oppy.End_Customer__c = acct.Id;
        	oppy.Probability__c = '30';
        	oppy.Check_Unit_Price__c = true;
        	oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        	insert oppy; 
        	Energy_Quote__c quote1 = ClsTestHelp.createTestEnergyQuote();
            quote1.Name = 'testQuote1';
            quote1.Opportunity_Name__c = oppy.Id;
            quote1.Account_Name__c = acct.Id;
            quote1.Selected_Email_Template__c = 'testAustraliaTemplate';
            quote1.Contact__c = cont.Id;
            insert quote1;
        	PageReference page = new PageReference('/apex/SAPQuotePdf'); 
            Test.setCurrentPageReference(page);
            ApexPages.currentPage().getParameters().put('id',oppy.Id); 
            ApexPages.currentPage().getParameters().put('quoteId',quote1.Id); 
            ApexPages.currentPage().getParameters().put('accid',acct.Id); 
            
            Test.startTest();
            Email_Individualquote eq = new Email_Individualquote();
            eq.gettemplates();
            Test.stopTest();
            System.assert(quote1.Id != null);
        }
    }
    
    static testMethod void myUnitTest3() {
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'helloSand0728@testCompany1407281004.com';
        u.FirstName ='Test0728';
        u.LastName = 'User0728';
        u.Alias = 'dpse0728';
        u.CommunityNickname = 'TMD0728';
        u.Te_Network_Id__c = '0529';
        u.GIBU__c = 'Appliances';
        u.Username = 'helloSand0728@testCompany1407281004.com';
        insert u;
        System.runAs(u) {
            ClsTestCustomSettingHelper.getApex_Helper_Settings();
            ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
            ClsTestCustomSettingHelper.getOpportunity_Approvers();
            ClsTestCustomSettingHelper.getTrigger_Configuration();
            ClsTestCustomSettingHelper.getProfitBUCenterMapping();
            ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
            ClsTestCustomSettingHelper.getQuoteValiditySetting();
            ClsTestCustomSettingHelper.getQuoteExpirationSetting();
            ClsTestCustomSettingHelper.getADMTerritoryCode();
            ClsTestHelp.createTestOrgWideSettings1();
            Territory_Email_Template__c tet = ClsTestHelp.createTestTerritoryEmailTemplate();
            tet.Email_Template_Name__c = 'testAustraliaTemplate';
            tet.Level_4_Territory_Code__c = '4444';
            tet.Level_5_Territory_Code__c = '5555';
            insert tet;
            Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
            sh.Level_4_Territory_Code__c = '4444';
            sh.Level_5_Territory_Code__c = '5555';
            sh.Level_7_Territory_Code__c = '103007';
	    	sh.Level_7_Default_Owner__c = u.Id;
	        sh.Level_7_Territory_Name__c = 'test aa7';
	        sh.Level_7_Assigned_User_Network_Ids__c = u.Te_Network_Id__c;
	        sh.Level_7_Assigned_Users__c = u.Id;
	        sh.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
            insert sh;
            Account acct = ClsTestHelp.createTestAccounts();
            acct.Name = 'AMP Iron Foundries Inc';
            acct.BU_Owner_Email__c = 'testMail@oinio.com';
            acct.SALES_TERRITORY_CDE__c = '121212';
            acct.RecordTypeId = ClsTestHelp.createTestRecordType21().Id;
            acct.Sales_Hierarchy__c = sh.Id;
            acct.OwnerId = u.Id;
            acct.Source_System__c = 2;
            insert acct;
            Contact cont = ClsTestHelp.createTestContacts();
            cont.Email = 'testtetset@oinio.com';
            cont.AccountId = acct.Id;
            insert cont;
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
        	oppy.Name = 'testOppy2';
        	oppy.AccountId = acct.Id;
        	oppy.End_Customer__c = acct.Id;
        	oppy.Probability__c = '30';
        	oppy.Check_Unit_Price__c = true;
        	oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        	insert oppy; 
        	Energy_Quote__c quote1 = ClsTestHelp.createTestEnergyQuote();
            quote1.Name = 'testQuote1';
            quote1.Opportunity_Name__c = oppy.Id;
            quote1.Account_Name__c = acct.Id;
            quote1.Selected_Email_Template__c = 'testAustraliaTemplate';
            quote1.Contact__c = cont.Id;
            insert quote1;
        	PageReference page = new PageReference('/apex/SAPQuotePdf'); 
            Test.setCurrentPageReference(page);
            ApexPages.currentPage().getParameters().put('id',oppy.Id); 
            ApexPages.currentPage().getParameters().put('quoteId',quote1.Id); 
            ApexPages.currentPage().getParameters().put('accid',acct.Id); 
            
            Test.startTest();
            Email_Individualquote eq = new Email_Individualquote();
            eq.gettemplates();
            Test.stopTest();
            System.assert(quote1.Id != null);
        }
    }
    
}