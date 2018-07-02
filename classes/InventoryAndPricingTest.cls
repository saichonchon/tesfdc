/*------------------------------------------------------------
	Author:        Buwen Guo <buwen.guo@capgemini.com> 
	Description:   Unit test class for class InventoryAndPricing
	Inputs:        
	Test Class:    
	History
	2017-09-23     Buwen Guo <buwen.guo@capgemini.com> Created
	------------------------------------------------------------*/
@isTest
public with sharing class InventoryAndPricingTest {
    @testSetup static void createConfig(){
    	ClsTestCustomSettingHelper.getBestPriceWebspeedSetting();
    	ClsTestCustomSettingHelper.getOrgWideSettings();
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
    }
    
    public class MockHTTPResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {     
           HTTPResponse res = new HTTPResponse();
           res.setHeader('Content-Type', 'application/json');
           res.setStatusCode(200);          
           res.setBody('<result><customer>505528</customer><part>406490-000</part><qty>6</qty><bestlistprice>0</bestlistprice></result>');
           return res;
        }
    }
    
    public static testMethod void testHTTPResponse(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        String session=UserInfo.getSessionId();
        //req.requestURI = 'https://webspeed-qa.te.com/energy.wsc/sfwtest.p';  
        //req.requestURI = bestPriceMfg.URL__c;  
        req.addParameter('sessionid', session);
        req.addParameter('part','1234567');
        req.addParameter('qty', '5');
        req.addParameter('customer', '1wer2547');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res; 
        
        Energy_Control__c eq = new Energy_Control__c();
        eq.name='Energy Control';
        eq.Disable_Integrations__c = false;
        eq.Callout_Start_Date__c = system.today().addDays(-1);
        insert eq;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,new MockHTTPResponseGenerator());
        InventoryAndPricing.getMFGProPrice(UserInfo.getSessionId(),'406490-000',6,'505528');
        
        Account sapAcct = new Account();
        sapAcct.Source_System__c = 1;
        sapAcct.name = 'test sap';
        
        Account MFGPRO = new Account();
        MFGPRO.Source_System__c = 51;
        MFGPRO.name = 'test MFGPRO';
        
        Account AMPICS = new Account();
        AMPICS.Source_System__c = 32;
        AMPICS.name = 'test AMPICS';
        
        Opportunity oppy = new Opportunity();
        oppy.name='test oppy';
        oppy.Account = sapAcct;
        
        Opportunity_Part__c part = new Opportunity_Part__c();
        part.Part_Number__c = 'test num 1';
        part.Quantity__c = 10;
    
        list<Opportunity_Part__c> list_oppParts = new list<Opportunity_Part__c>();
        list_oppParts.add(part);
        
        
        InventoryAndPricing.getPricingSAP(oppy, list_oppParts);
        String strOpp = Json.serialize(oppy);
        String strListOppParts = Json.serialize(list_oppParts);
        InventoryAndPricing.getInventoryAndPriceSAP(strOpp, strListOppParts);
        InventoryAndPricing.getInventoryAndPriceMFGPRO(strOpp, strListOppParts);
        InventoryAndPricing.getInventoryAndPriceAMPICS(strListOppParts);
        InventoryAndPricing.getPrice(strOpp, strListOppParts);
        InventoryAndPricing.getPricingSAP(null, list_oppParts);
        Test.stopTest();
    }
    
    static testMethod void testMethod1(){
        Energy_Control__c eq = new Energy_Control__c();
        eq.name='Energy Control';
        eq.Disable_Integrations__c = false;
        eq.Callout_Start_Date__c = system.today().addDays(-1);
        insert eq;
        
        Account sapAcct = new Account();
        sapAcct.name = 'test sap';
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.name='test oppy';
        oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        //oppy.Account = sapAcct;
        insert oppy;
        
        Opportunity_Part__c part = new Opportunity_Part__c();
        part.Part_Number__c = 'test num 1';
        part.Quantity__c = 10;
        
        BestPriceWebspeed__c bestPriceMfg = new BestPriceWebspeed__c();
        bestPriceMfg.Name='aaa';
        bestPriceMfg.URL__c='https://webspeed-qa.te.com/energy.wsc/zxprcsfwsrq.p';
        insert bestPriceMfg;
        Test.setMock(HttpCalloutMock.class,new MockHTTPResponseGenerator());
        InventoryAndPricing.getMFGProPrice(UserInfo.getSessionId(),'406490-000',6,'505528');
        InventoryAndPricing.getMFGProPriceForList(UserInfo.getSessionId(),oppy.Id,system.today(),'123123',new list<Opportunity_Part__c>{part});
    }
    
    static testMethod void testMethod2(){
        Energy_Control__c eq = new Energy_Control__c();
        eq.name='Energy Control';
        eq.Disable_Integrations__c = false;
        eq.Callout_Start_Date__c = system.today().addDays(-1);
        insert eq;
        
        Account sapAcct = new Account();
        sapAcct.name = 'test sap';
        Opportunity oppy = new Opportunity();
        oppy.name='test oppy';
        oppy.Account = sapAcct;
        
        Opportunity_Part__c part = new Opportunity_Part__c();
        part.Part_Number__c = 'test num 1';
        part.Quantity__c = 10;
        
        BestPriceWebspeed__c bestPriceMfg = new BestPriceWebspeed__c();
        bestPriceMfg.Name='QAD-MFGProUrl';
        bestPriceMfg.URL__c='https://webspeed-qa.te.com/energy.wsc/zxprcsfwsrq.p';
        //insert bestPriceMfg;
        
        //InventoryAndPricing.getInventoryAndPrice(oppy,part);
        //oppy.Account = MFGPRO;
        //InventoryAndPricing.getInventoryAndPrice(oppy,part);
        
        //oppy.Account = AMPICS;
        //InventoryAndPricing.getInventoryAndPrice(oppy,part);
    }
    
    static testMethod void testMethod3(){
        Energy_Control__c eq = new Energy_Control__c();
        eq.name='Energy Control';
        eq.Disable_Integrations__c = false;
        eq.Callout_Start_Date__c = system.today().addDays(-1);
        insert eq;
        
        Account sapAcct = new Account();
        sapAcct.name = 'test sap';
        
        Opportunity oppy = new Opportunity();
        oppy.name='test oppy';
        oppy.Account = sapAcct;
        
        Opportunity_Part__c part = new Opportunity_Part__c();
        part.Part_Number__c = 'test num 1';
        part.Quantity__c = 10;
        
        BestPriceWebspeed__c bestPriceMfg = new BestPriceWebspeed__c();
        bestPriceMfg.Name='QAD-MFGProUrl';
        bestPriceMfg.URL__c='https://webspeed-qa.te.com/energy.wsc/zxprcsfwsrq.p';
        //insert bestPriceMfg;
        
        //InventoryAndPricing.getInventoryAndPrice(oppy,part);
        //oppy.Account = MFGPRO;
        //InventoryAndPricing.getInventoryAndPrice(oppy,part);
        
        //oppy.Account = AMPICS;
        //InventoryAndPricing.getInventoryAndPrice(oppy,part);
    }
}