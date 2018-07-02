@isTest(SeeAllData=true)
Public class LeadEditDetailController_Test{
static Lead led;
Static User testUser;

 static testMethod void testData_forEdit() {
 
  Profile p = [select id from profile where name='System Administrator'];
         testUser = new User(alias = 'u1', email='u1@testorg.com', emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
         localesidkey='en_US', profileid = p.Id, country='United States',timezonesidkey='America/Los_Angeles', username='wewew23232323232drex@gmail.com');
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
         led.title ='Mr';
         led.ROLE__c='Other';
         led.MobilePhone = '123456789';
         led.Distributor_Response__c = 'Dead';
         led.Street = 'Acd';
         led.City = 'asd';
         led.State = 'aww';
         led.PostalCode = '2322';
         led.Country = 'acdd';
         led.website = 'ww.te.com';
         led.Distributor_Comments__c = 'test';
         led.ACTIVITY_NOTES__c = 'test' ;
         led.Description = 'test';
         led.SUGGESTED_SE__c = 'test';
         
         
        insert led;
        }
        
        static testMethod void UnitTestMethod() {
        testData_forEdit();
        PageReference ref = Page.DistributorLeadEditView; 
           Test.setCurrentPageReference(ref);
           ApexPages.StandardController stdController = new ApexPages.StandardController( led );             
           ApexPages.currentpage().getParameters().put('id',led.id); // set record(lead) id to vf page
           
           // Added by Anil inorder to cover Pdf Functionality
           ApexPages.currentpage().getParameters().put('pdf','true');
           ApexPages.currentpage().getParameters().put('force_download','true');
           ApexPages.currentpage().getParameters().put('filename','MyLeadDetail');
           
           LeadEditDetailController  cmc = new LeadEditDetailController (stdController);
                      
           cmc.SaveEdit();  
           cmc.editTo();
        
       
    }



}