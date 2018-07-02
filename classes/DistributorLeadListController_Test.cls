/***********************************************************************************************************************
Name: DistributorLeadListController
Copyright © 2014 TE Connectivity | Salesforce Instance : C2S
========================================================================================================================
Purpose: Controller for List view on community                                                 
========================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR            DATE               DETAIL                                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------

2.0    Anil Kumar       06/26/2014     Enhancements                           
***********************************************************************************************************************/  

@isTest(SeeAllData=true)
Public class DistributorLeadListController_Test{
static Lead led;
Static User testUser;

 static testMethod void testData() {
 
  Profile p = [select id from profile where name='System Administrator'];
         testUser = new User(alias = 'u1', email='u1@testorg.com', emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
         localesidkey='en_US', profileid = p.Id, country='United States',timezonesidkey='America/Los_Angeles', username= '1234567890ewewerex@gmail.com');
         insert testUser;        

led = new Lead();
        led.LastName= 'Test Lead';
        led.Company = 'Test Company';
        led.Status ='Passed to Distributor';
         led.Communities_Distributor__c ='Future Electronics';
         led.Phone= '23456';
         led.FirstName ='Test';
         led.Email = 'test.test@ymail.com';
         led.OwnerId = testUser.id;
        insert led;
        }
        
        static testMethod void UnitTestMethod() {
        testData();
        
        test.startTest();
        
        DistributorLeadListController obj = new DistributorLeadListController();
        obj.runSearch();
        obj.editPage();
        obj.getSortDirection();
        obj.setSortDirection('ASC');
        obj.filterSearch();
        obj.getOptions();
        obj.getDOptions();
        
        test.stopTest();
    }
    
        static testMethod void UnitTestMethod2() {
        testData();
        
        test.startTest();
        
        DistributorLeadListController obj = new DistributorLeadListController();
        obj.Rating='Hot';
        obj.DistributorResponse = 'Dead';
        obj.runSearch();
        obj.editPage();
        obj.getSortDirection();
        obj.setSortDirection('ASC');
        obj.filterSearch();
        obj.getOptions();
        obj.getDOptions();
        
        test.stopTest();
    }
        static testMethod void UnitTestMethod3() {
        testData();
        
        test.startTest();
        
        DistributorLeadListController obj = new DistributorLeadListController();
        obj.Rating='--All--';
        obj.DistributorResponse = 'Dead';
        obj.runSearch();
        obj.editPage();
        obj.getSortDirection();
        obj.setSortDirection('ASC');
        obj.filterSearch();
        obj.getOptions();
        obj.getDOptions();
        
        test.stopTest();
    }


}