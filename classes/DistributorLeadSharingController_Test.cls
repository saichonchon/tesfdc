@IsTest(SeeAllData=true)
Public class DistributorLeadSharingController_Test{
Public static Lead led;
public static LeadShare lshare;
//Public Static String labelProfile;
Public Static User pu;
Public Static User testUser1;
enum PortalType { CSPLiteUser, PowerPartner, PowerCustomerSuccess, CustomerSuccess }
         
static testmethod void usertest() {
 //labelProfile = Label.Distributor;
User adminUser = [Select id, name, Profile.Name, IsActive from User where Profile.Name='System Administrator' And IsActive =true Limit 1];
pu = getPortalUser(PortalType.PowerPartner, null, true);

System.RunAs(adminUser) {

 led = new Lead();
        led.LastName= 'Test Lead';
        led.Company = 'Test Company';
        led.Status ='Passed to Distributor';
         led.Communities_Distributor__c ='Future Electronics';
         led.Phone= '23456';
         led.FirstName ='Test';
         led.Email = 'test.test@ymail.com';
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
        
        
        lshare = new LeadShare();
        lshare.LeadId = led.id;
        lshare.UserOrGroupId = pu.id;
        lshare.LeadAccessLevel = 'Edit';
        insert lshare;
        
        }
        
            System.RunAs(adminUser) {
        
            PageReference ref = Page.DistributorLeadSharing; 
           Test.setCurrentPageReference(ref);
           ApexPages.StandardController stdController = new ApexPages.StandardController(led);             
           ApexPages.currentpage().getParameters().put('id',led.id); // set record(lead) id to vf page
           DistributorLeadSharingController cmc = new DistributorLeadSharingController(stdController);
           
         //  ApexPages.currentPage().getParameters().put('leadststus','r');
         //  ApexPages.currentPage().getParameters().put('userProfileId','labelProfile');
         //  cmc.userProfileId = Label.Distributor;
          
           cmc.getselectedId();
           cmc.UserName = 'T';
           cmc.selectedId = pu.id; 
           cmc.searchUser();
           cmc.onProceed();
           }
        }
       public static User getPortalUser(PortalType portalType, User userWithRole, Boolean doInsert) {
         
            /* Make sure the running user has a role otherwise an exception
               will be thrown. */
            if(userWithRole == null) {  
                 
                if(UserInfo.getUserRoleId() == null) {
     
                    UserRole r = new UserRole(name = 'TEST ROLE');
                    Database.insert(r);
                     
                    userWithRole = new User(alias = 'hasrole', email='userwithrole@roletest1.com', userroleid = r.id,
                                        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                        localesidkey='en_US', profileid = UserInfo.getProfileId(),
                                        timezonesidkey='America/Los_Angeles', username='userwithrole@testorg.com');
                } else {
                    userWithRole = new User(Id = UserInfo.getUserId(), UserRoleId = UserInfo.getUserRoleId());
                }
                 
                System.assert(userWithRole.userRoleId != null,
                              'This test requires the target org to have at least one UserRole created. Please create a user role in this organization and try again.');
            }
     
            Account a;
            Contact c;
            System.runAs(userWithRole) {
     
                a = new Account(name = 'TEST ACCOUNT',BillingCountry = 'US',CurrencyIsoCode='USD',Industry_Code_Description__c ='Other');
                Database.insert(a);
                 
                c = new Contact(AccountId = a.id, lastname = 'lastname');
                Database.insert(c);
     
            }
             
            /* Get any profile for the given type.*/
            Community_Config__c portalProfileIds = Community_Config__c.getInstance('Distributor Profile Id');
            List<String> pSet = portalProfileIds.Value__c.Split(',');
           
             
            String testemail = 'puser000@amamama.com';
            User pur = new User(profileId = pSet[0], username = testemail, email = testemail,
                               emailencodingkey = 'UTF-8', localesidkey = 'en_US',Firstname ='Temp',
                               languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                               alias='cspu', lastname='Tastname', contactId = c.id);
             
            if(doInsert) {
                Database.insert(pur);
            }
            return pur;
        }
    }