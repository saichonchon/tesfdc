/**************************************************************************************************************************************************
Name:  LinkSFDCToSapWebServiceTest
Copyright © 2015 TE Connectivity | Instance : C2S Org
===================================================================================================================================================
Purpose: This class contain Test Methods for LinkSFDCToSapWebService
---------------------------------------------------------------------------------------------------------------------------------------------------       
Related APEX Class : LinkSFDCToSapWebService                                                            
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
Version Developer          Date       Detail                                  Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Subba Reddy 07/08/2015 Initial Development                      
**************************************************************************************************************************************************/
@isTest()
public class LinkSFDCToSapWebServiceTest {
    //Create Test data fore User
    public static User createTestUser(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];   
        User vUsr = new User(GIBU__c='Data & Devices', Alias = 'linkst', Email='linktest432@testorg.com', EmailEncodingKey='UTF-8', LastName='Test432', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='linktest432@testorg.com', CSD_Region__c='Taiwan');
        return vUsr;
    }
    //Create test data for realtime_Callout_Settings__c 
    public static realtime_Callout_Settings__c realTimeCalloutSettings(){
        realtime_Callout_Settings__c rcs = new realtime_Callout_Settings__c();
        rcs.Name ='QA Link Sap';
        rcs.endpoint_url__c = 'https://sfdcgateway-qa.te.com:8090/ProcessHandler.asmx';
        rcs.Certificate_name__c = 'TE_RT_Cert4';
        rcs.Traffic_Cop_Org_Name__c = 'C2S';
        rcs.active__c = True;        
        return rcs;
        
    }
    // Create Test data for Account
    public static Account createTestAccount(){              
        Account vAccount = clsTestHelp.createTestAccounts();
        vAccount.AccountNumber = '0451:01319551';
        vAccount.Distribution_Channel_Cde__c='02';
        vAccount.Company_Organization_ID__c ='0451';
        vAccount.Sales_Organization_ID__c ='1234';
        vAccount.Source_System__c = 1;
        return vAccount;
        
    }
    //Create Test data for Case
    public static Case createTestCase(){
        Case vCase = new Case();        
        vCase.Origin = 'SAP';
        vCase.Inquiry_Type__c = 'SAP Block';
        vCase.Status= 'In Progress';
        vCase.Description = 'Test Description';             
        vCase.SAP_Document_Number__c = '1234567'; 
        return vCase;
    }
    //Create Link to Sap Test data
    public static testmethod void createLinktoSapTest(){  
        User vUsr = createTestUser();
        insert vUsr;
        System.runAs(vUsr) {    
            //ClsTestCustomSettingHelper.getApex_Helper_Settings();        
            ClsTestCustomSettingHelper.getAllSettings();
            realtime_Callout_Settings__c vRealTimeCalloutSettings = realTimeCalloutSettings();
            insert vRealTimeCalloutSettings;
            
            Account vAccount = createTestAccount();
            vAccount.name = 'testaccountLinkSFDCToSapWebServiceTest';
            vAccount.ownerId = UserInfo.getUserId(); 
            vAccount.Account_Manager__c = UserInfo.getUserId();
            insert vAccount;
        
            Case vCase = createTestCase();
            vCase.AccountId = vAccount.id;  
            insert vCase;
            
            system.assertEquals(vCase.Origin,'SAP');
            
            // This causes a fake response to be generated
            test.startTest();
            Test.setMock(WebServiceMock.class, new LinkSFDCToSapWebServiceMockImpl());
            LinkSFDCToSapWebService.castIronSapWSCallot(vCase.id);
            test.stopTest();
        }
    }

}