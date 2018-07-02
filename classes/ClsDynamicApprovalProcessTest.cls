/**
 * test class for class ClsDynamicApprovalProcess
 *
 * @author     Tangyong Li
 * @created    2017-10-17
 * @version    1.0
 * @since      38.0 (Force.com ApiVersion)
 *
 * @changelog
 * 2017-10-17  Tangyong Li <tangyong.li@capgemini.com>
 * - Created
 */
@isTest
public class ClsDynamicApprovalProcessTest {
    @testSetup static void createConfig(){
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
        ClsTestHelp.createTestOPTG4(); 
    }
    
    static testMethod void myUnitTest1() {
        User u = ClsTestHelp.createTestUsers();
        insert u;
        System.runAs(u) {
			Account vAccount = ClsTestHelp.createTestAccounts();
			vAccount.Name = 'AMP Iron Foundries Inc';
			vAccount.AnnualRevenue = 2000000.11; 
			vAccount.Legally_Restricted__c = false;  
			vAccount.BillingCity = 'Shanghai';	
			vAccount.BillingCountry	= 'China';
			vAccount.BillingState = '000000';
			vAccount.BillingStreet = 'Changning';
			vAccount.BillingPostalCode = '200051';
        	vAccount.BU_Owner_Email__c = 'testMail@oinio.com';
        	insert vAccount;
        	
        	RecordType rt = ClsTestHelp.createTestRecordType32();
            
        	Opportunity oppy = ClsTestHelp.createTestOpportunity();
        	oppy.Name = 'testOppy2';
        	oppy.AccountId = vAccount.Id;
            oppy.RecordTypeId = rt.id;
            oppy.Quote_Type__c = 'Meet Competitor Price';
        	insert oppy;
        	system.debug('query :::oppy  ' + limits.getQueries());
        	Product_Hierarchy__c p = new Product_Hierarchy__c();
        	insert p;
        	Part__c part = new Part__c();
        	part.Product_Hierarchy__c = p.Id;
        	part.Name = 'test';
        	insert part;
        	Opportunity_Part__c oppyPart = ClsTestHelp.createTestEnergyOpportunityPart();
        	oppyPart.Opportunity__c = oppy.Id;
        	oppyPart.Part__c = part.Id;
        	Opportunity_Part__c oppyPart2 = ClsTestHelp.createTestEnergyOpportunityPart();
        	oppyPart2.Opportunity__c = oppy.Id;
        	oppyPart2.Part__c = part.Id;
        	Test.startTest();
        	insert new List<Opportunity_Part__c>{oppyPart,oppyPart2}; 
        	system.debug('query :::oppyPart  ' + limits.getQueries());
        	String result1 = ClsDynamicApprovalProcess.checkOppyReadyForApproval(oppy.Id);
        	system.assert(result1 != '');
        	system.debug('query :::result  ' + limits.getQueries());
        	Test.stopTest();
        }
    }
    
    static testMethod void myUnitTest2() {
        User u = ClsTestHelp.createTestUsers();
        u.Te_Network_Id__c = '0529';
        insert u;
        System.runAs(u) {
        	Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
            sh.Level_4_Territory_Code__c = '100380';
            sh.Level_7_Default_Owner__c = u.Id;
            sh.Level_4_Territory_Name__c = 'A00734';
            sh.Level_4_Assigned_Users__c = u.Id;
            sh.Level_7_Territory_Code__c = 'A007357';
            sh.Level_4_Assigned_User_Network_Ids__c = u.Te_Network_Id__c;
            sh.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
        	insert sh;
			Account vAccount = ClsTestHelp.createTestAccounts();
			vAccount.Name = 'AMP Iron Foundries Inc';
			vAccount.AnnualRevenue = 2000000.11; 
			vAccount.Legally_Restricted__c = false;  
			vAccount.BillingCity = 'Shanghai';	
			vAccount.BillingCountry	= 'China';
			vAccount.BillingState = '000000';
			vAccount.BillingStreet = 'Changning';
			vAccount.BillingPostalCode = '200051';
        	vAccount.BU_Owner_Email__c = 'testMail@oinio.com';
        	vAccount.Sales_Hierarchy__c = sh.Id;
        	insert vAccount;
        	
        	RecordType rt = ClsTestHelp.createTestRecordType32();
            
            OpportunityTrgHandler.isMultipleBeforeInsert = true;
            OpportunityTrgHandler.isMultipleBeforeUpdate = true;
            OpportunityTrgHandler.isMultipleBeforeDelete = true;
            OpportunityTrgHandler.isMultipleAfterInsert = true;
            OpportunityTrgHandler.isMultipleAfterUpdate = true;
            OpportunityTrgHandler.isMultipleAfterDelete = true;
        	Opportunity oppy = ClsTestHelp.createTestOpportunity();
        	oppy.Name = 'testOppy2';
        	oppy.AccountId = vAccount.Id;
            oppy.RecordTypeId = rt.id;
            oppy.Quote_Type__c = 'Meet Competitor Price';
            oppy.Amount = null;
            oppy.Margin__c = null;
            oppy.Account_Owner__c = null;
        	insert oppy;
        	Product_Hierarchy__c p = new Product_Hierarchy__c();
        	insert p;
        	Part__c part = new Part__c();
        	part.Product_Hierarchy__c = p.Id;
        	part.Name = 'test';
        	insert part;
        	Opportunity_Part__c oppyPart = ClsTestHelp.createTestEnergyOpportunityPart();
        	oppyPart.Opportunity__c = oppy.Id;
        	oppyPart.Part__c = part.Id;
        	Test.startTest();
        	insert oppyPart;
        	String result2 = ClsDynamicApprovalProcess.dynamicApprovalProcess(oppy.Id);
        	system.assert(result2 != '');
        	Test.stopTest();
        }
    }
}