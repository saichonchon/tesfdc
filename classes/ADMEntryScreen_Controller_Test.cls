/**********************************************************************
Name: ADMEntrySreen_Controller_Test
Copyright © 2017
======================================================
======================================================
Purpose: Test Class for ADMEntrySreen_Controller
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR                DATE             Description
1.0        Suresh A          10/12/2017         INITIAL DEVELOPMENT
***********************************************************************/
@isTest
public class ADMEntryScreen_Controller_Test {
    
    static List<Account> accList;
    static ADMEntryScreen_Controller ADMEntry;
    static List<Forecast_Detail__c> frDetailList; 
    ADMTestDataFactory fact = new ADMTestDataFactory();      
    
    @TestSetup
    public static void testDataSetup() {          
        
        Forecast__c frCastOEM = new Forecast__c();
        Forecast__c frCastDISTY = new Forecast__c();
        List<Product_Hierarchy__c> ProdList = new List<Product_Hierarchy__c>();  
        
        Test.StartTest(); 
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();        
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();        
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();        
        ClsTestCustomSettingHelper.getApex_Helper_Settings();  
        ADMTestDataFactory.getADM_CustomSetting();     
        ADMTestDataFactory.getADM_CustomSetting1();      
        
        List<account> acc = ADMTestDataFactory.accountDetails('TestAccount', 'SoldToCustomerNum', 'Musterstadt','CN', 'OEM','072','77777' );
        System.Debug('acc :'+acc);
        List<account> accDisty = ADMTestDataFactory.accountDetails('TestAccountDisy', 'SoldToCustomerNum', 'Musterstadt','CN', 'Distributor','072','071' );                
        System.Debug('accDisty :'+accDisty);          
        ProdList = ADMTestDataFactory.productHierarchyDetails('GPL', 'CBC2', 'CBC3', 'CBC4', 'GPLDec');
        insert ProdList;               
        
        frCastOEM= ADMTestDataFactory.createForecastObj2('TestForecastExtid001','CON','BA','CAM','TestComments','Australia','GPL Level',null,'Australiaregion','Portfolio',acc[0].id); 
        frCastDISTY= ADMTestDataFactory.createForecastObj2('TestForecastExtid8090','CON','BA','CAM','TestComments','Australia','CBC3 Level',null,'Australiaregion','Portfolio',acc[0].id); 
        List<Forecast_Detail__c> frcDetailsList = new List<Forecast_Detail__c>();          
        frcDetailsList=ADMTestDataFactory.createForCastDetails(frCastOEM.id,'Forecast');    
        
        Test.StopTest();
    }    
    Public static testmethod void ADMEntryTestSalesEngineer()  {    
        
        Profile p = [SELECT Id FROM Profile WHERE Name='ADM Standard User']; 
        User u = new User( ADM_User_Type__c= 'Sales Engineer',Alias = 'stest', Email='test.test@te.com', 
                          UserName='test.test@te.com.admdev',EmailEncodingKey='UTF-8', LastName='Testing', 
                          LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles');  
        
        insert u;
        List<account> acc = [SELECT Id FROM Account WHERE Name='TestAccount' LIMIT 1];
        acc[0].Account_Manager__c = u.id;
        update acc;
        Forecast__c frCast= [ select Id,Name, External_ID__c,Sold_To_Customer__c,Worldwide_Customer_Name__c from Forecast__c where External_ID__c=: 'TestForecastExtid001' ];   
        System.Debug('frCast11 : '+frCast);                   
        
        System.runAs(u) {            
            ADMEntryScreenHelper.getforecastrec('OEM',null,null,null,null,null,null,null,null,u.id,null,null,100,50,null);
            ADMEntry = new ADMEntryScreen_Controller();          
            PageReference pageRef = Page.ADMEntryScreen;
            Test.setCurrentPage(pageRef); 
            
            Test.startTest();
            
            ADMEntry.currentuser = u;
            ADMEntry.toggleEnabled();
            System.assertEquals(ADMEntry.forecast.Sold_To_Customer__c, null);
            ADMEntry.forecast.Sold_To_Customer__c=frCast.Sold_To_Customer__c;
            ADMEntry.forecast.Worldwide_Customer_Name__c= frCast.Worldwide_Customer_Name__c;
            ADMEntry.Searchvalues();
            
            ADMEntry.getProfitCenterValues();
            ADMEntry.getCBC3Values();
            ADMEntry.getRegionValues();
            ADMEntry.getDistrictValues();
            ADMEntry.DISTYCode = 'disty';
            ADMEntry.getPaginationDropDown();
            
            Test.stopTest();    
        }
    }    
    Public static testmethod void admEntryTestDistributionManager(){ 
        
        ADM_User_Region__c UserRegion =new ADM_User_Region__c();
        Profile p = [SELECT Id FROM Profile WHERE Name='ADM Standard User']; 
        User u = new User(ADM_User_Type__c= 'Distribution Manager',Alias = 'stest', Email='test.test@te.com', 
                          UserName='test.test@te.com.admdev',EmailEncodingKey='UTF-8', LastName='Testing', 
                          LanguageLocaleKey='en_US', LocaleSidKey='en_US',Region__c='EMEA', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles');
        
        List<account> acc = [SELECT Id FROM Account WHERE Name='TestAccountDisy' LIMIT 1];
        
        System.runAs(u) {           
            
            ADMEntry = new ADMEntryScreen_Controller();
            PageReference pageRef = Page.ADMEntryScreen;
            Test.setCurrentPage(pageRef); 
            
            Test.startTest();
            ADMEntry.currentuser = u;
            ADMEntry.toggleEnabled();
            System.assertEquals(ADMEntry.forecast.Sold_To_Customer__c, null);
            ADMEntry.forecast.Sold_To_Customer__c=acc[0].id;
            ADMEntry.forecast.Worldwide_Account_Name__c= 'Test';
            ADMEntry.Searchvalues();
            
            ADMEntry.getProfitCenterValues();
            ADMEntry.getCBC3Values();
            ADMEntry.getRegionValues();
            ADMEntry.getDistrictValues();
            ADMEntry.DISTYCode = 'disty';
            Test.stopTest();        
        }
    }
    Public static testmethod void ADMEntryTestSalesEngineerManager() {     
        
        List<account> acc2 = [SELECT Id FROM Account WHERE Name='TestAccount' LIMIT 1];        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='ADM Standard User']; 
        User u = new User(ADM_User_Type__c= 'Sales Engineer Manager',Alias = 'stest', Email='test.test@te.com', 
                          UserName='test.test@te.com.admdev',EmailEncodingKey='UTF-8', LastName='Testing', 
                          LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles');
        
        System.runAs(u) {        
            
            ADMEntry = new ADMEntryScreen_Controller();
            PageReference pageRef = Page.ADMEntryScreen;
            Test.setCurrentPage(pageRef);           
            ADMEntry.currentuser = u;
            Record_Rendering_Limit__c recRender = new Record_Rendering_Limit__c();
            recRender.Name = 'RecordRenderingLimit';
            recRender.Subordinates_Limit__c = 10;
            recRender.Managers_Limit__c = -1;
            insert recRender;
            ADMEntry.Searchvalues();    
        }     
    }
    Public static testmethod void ADMEntryTestAPRegion() {     
        
        List<account> acc2 = [SELECT Id FROM Account WHERE Name='TestAccount' LIMIT 1];        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='ADM Standard User']; 
        User u = new User(ADM_User_Type__c='Distribution Manager',Alias = 'stest', Email='test.test@te.com', 
                          UserName='test.test@te.com.admdev',EmailEncodingKey='UTF-8',Region__c='India', LastName='Testing', 
                          LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles');
        System.runAs(u) {            
            ADMEntry = new ADMEntryScreen_Controller();
            PageReference pageRef = Page.ADMEntryScreen;
            Test.setCurrentPage(pageRef);           
            ADMEntry.currentuser = u;   
            ADMEntry.getRegionValues();  
            u.Region__c ='North America';
            ADMEntry.getRegionValues();
            u.Region__c ='South America';
            ADMEntry.getRegionValues();                            
            u.Region__c ='ANZ';
            ADMEntry.getRegionValues(); 
            Record_Rendering_Limit__c recRender = new Record_Rendering_Limit__c();
            recRender.Name = 'RecordRenderingLimit';
            recRender.Subordinates_Limit__c = -1;
            recRender.Managers_Limit__c = 10;
            insert recRender;
            ADMEntry.Searchvalues();    
            ADMEntry.getPaginationDropDown();                                                             
        }     
    }  
    Public static testmethod void ADMEntryNullTest() {      
        
        Profile p = [SELECT Id FROM Profile WHERE Name='ADM Customer Service Profile']; 
        User u = new User(Alias = 'stest', Email='test.test@te.com', 
                          UserName='test.test@te.com.admdev',EmailEncodingKey='UTF-8', LastName='Testing', 
                          LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles');  
        try {          
            System.runAs(u) {            
                ADMEntry = new ADMEntryScreen_Controller();
                ADMEntry.currentuser = u;
                ADMEntry.Searchvalues();
            }          
        }
        Catch(Exception e) {
            System.Debug('test');
        }                     
    }        
}