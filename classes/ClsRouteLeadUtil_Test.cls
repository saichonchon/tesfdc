/**
*   This test class is for ClsRouteLeadUtil.
*
@author Di Chen
@created 2013-01-21 
@version 1.0
@since 20.0
*
@changelog
* 2013-01-21 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 91%
* - Lead_BI_executeRoute Test coverage 100%
* 2016-11-04 Di Chen <rajendra.shahane@zensar.com>
* - Modified
* - Test coverage 91%
* 2016-12-08 Mahesh Babu <mahesh.babu@te.com> and Pavan T <pavan.temididepati@te.com>
* - Modified to improve Test coverage
*/
@isTest
private class ClsRouteLeadUtil_Test {
    
    static Profile p = [Select Id, Name From Profile where Name ='System Administrator' or Name ='Systemadministrator' limit 1];
	static profile proTest=[select id, name from profile where name='Service Account'];
			
/***************************************
* Test method for routeLead_new method  
* *************************************/
        
    static testMethod void testrouteLead_new() {
                                        
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
// Creating Test data   

// Custom Setting  
            insert new Lead_Routing_Settings__c(Name = 'CC Business Analyst', 
                                                Exclude_Network_ID_Assignment__c = true, 
                                                Profile_Id__c = '00eE0000000afMM');
// user            
            User u1 = ClsTestHelp.createTestUsers();        
            u1.Email = 'testCLR1@testCompany1233423.com';
            u1.Username = u1.Email;
            u1.Alias = 'testclr1';
            u1.CommunityNickname = 'tclr1';
            u1.ProfileId = p.Id;
            U1.Te_Network_Id__c = 'XXNTWKID1';
            u1.IsActive = true;
            //insert u1; 
            User u2 = ClsTestHelp.createTestUsers();        
            u2.Email = 'ninid@testCompany1233423.com';
            u2.Username = u2.Email;
            u2.Alias = 'meizi';
            u2.CommunityNickname = 'nime';
            u2.ProfileId = p.Id;
            u2.IsActive = true;
            
            User u3 = ClsTestHelp.createTestUsers();
            u3.Email = 'nimeide@testCompany1233423.com';
            u3.Alias = 'nimeid';
            u3.CommunityNickname = 'emdi';
            u3.ProfileId = p.Id;
            u3.IsActive = true;
            u3.Te_Network_Id__c = u2.Id;
            u3.Username = 'nimeia@ti.com';
            User u4 = new user();
			u4.Alias = 'standt';
			u4.Email='standarduser@testorg.com';
			u4.EmailEncodingKey='UTF-8';
			u4.LastName='Eloqua Integration User';
			u4.LanguageLocaleKey='en_US'; 
			u4.LocaleSidKey='en_US';
			u4.ProfileId = proTest.Id; 
			u4.TimeZoneSidKey='America/Los_Angeles';
			u4.UserName='EloquaIntegrationUser@testorg.com';
			
			insert new list<User>{u1,u2,u3,u4};
             
//Sales Hierarchy 
            Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
            sh.Level_7_Assigned_User_Network_Ids__c = 'XXCCRR';
            sh.Level_7_Default_Owner__c = u2.Id;
            sh.Level_7_Territory_Code__c = 'ABCDEFG';
            Sales_Hierarchy__c sh1 = new Sales_Hierarchy__c();
            sh1.Level_7_Assigned_User_Network_Ids__c = 'XXCCRRxx';
            sh1.Level_7_Default_Owner__c = u3.Id;
            sh1.Level_7_Territory_Code__c = 'ABCDEFGH';
            insert new list<Sales_Hierarchy__c>{sh,sh1};
			
//  Accounts
            Account acc1 = ClsTestHelp.createTestAccounts();
            acc1.FE_Hierarchy__c = sh.Id;
            //insert acc1;
			Account acc2 = ClsTestHelp.createTestAccounts();
			acc2.Account_Manager__c = u3.Id;
			acc2.FE_Hierarchy__c = sh1.Id;
			insert new List<Account>{acc1,acc2};
            
//  Contacts
// Start:  Modified by Mahesh Babu for CLR req-02 to improve code coverage
            Contact con1 = ClsTestHelp.createTestContacts();
            con1.AccountId = acc2.Id;
            con1.Email = 'test2.test@ymail.com';
            // insert con1;
            Contact con2 = ClsTestHelp.createTestContacts();
            con2.AccountId = acc1.Id;
            con2.Email = 'test3.test@ymail.com';
            // insert con2; 
            Contact con3 = ClsTestHelp.createTestContacts();
            con3.AccountId = acc1.Id;
            con3.Email = 'test4.test@ymail.com';
			insert new List<Contact>{con1, con2, con3}; 
       
// End:  Modified by Mahesh Babu for CLR req-02 to improve code coverage

// Leads      
            list<lead> lstLed = new list<lead>(); 
        
            Lead led = new Lead();
            led.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('C2S Lead').getRecordTypeId();
            led.LastName= 'Test Lead 1';
            led.FirstName = 'Test Lead 1 First';
            led.Assignee_Network_ID__c = 'XXNTWKID1';
            led.Lead_Recipient__c = 'channel';
            led.Company = 'Test Company 1';
            led.Status ='Passed to Distributor';
            led.Communities_Distributor__c ='Future Electronics';
            led.Phone= '23456';
            led.FirstName ='Test 1';
            led.Email = 'test1.test@ymail.com';
            led.OwnerId = userinfo.getUserId();
            led.title ='Mr';
            led.ROLE__c='Other';
            led.MobilePhone = '123456789';
            led.Distributor_Response__c = 'Dead';
            led.Street = 'graham st';
            led.City = 'toronto';
            led.State = 'NF';
            led.PostalCode = 'A';
            led.Country = 'canada';
            led.website = 'ww.te.com';
            led.Distributor_Comments__c = 'test';
            led.ACTIVITY_NOTES__c = 'test' ;
            led.Description = 'test';
            led.SUGGESTED_SE__c = 'test';
            led.Owner_Assigned__c = 1;
            lstLed.add(led);
            led = new lead();
            led.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('C2S Lead').getRecordTypeId();
            led.LastName= 'Test Lead 2';
            led.FirstName = 'Test Lead 2 First';
            led.Assignee_Network_ID__c = 'XXNTWKID2';
            led.Lead_Recipient__c = 'channel';
            led.Company = 'Test Company 2';
            led.Status ='Passed to Distributor';
            led.Communities_Distributor__c ='Future Electronics';
            led.Phone= '23456';
            led.FirstName ='Test 2';
            led.Email = 'test2.test@ymail.com';
            led.OwnerId = userinfo.getUserId();
            led.title ='Mr';
            led.ROLE__c='Other';
            led.MobilePhone = '123456789';
            led.Distributor_Response__c = 'Dead';
            led.Street = 'graham st';
            led.City = 'toronto';
            led.State = 'NH';
            led.PostalCode = 'A';
            led.Country = 'canada';
            led.website = 'ww.te.com';
            led.Distributor_Comments__c = 'test';
            led.ACTIVITY_NOTES__c = 'test' ;
            led.Description = 'test';
            led.SUGGESTED_SE__c = 'test';
            lstLed.add(led);
        
            led = new Lead();
            led.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('C2S Lead').getRecordTypeId();
            led.LastName= 'Test Lead 3';
            led.FirstName = 'Test Lead 3 First';
            led.Company = 'Test Company 3';
            led.Status ='Passed to Distributor';
            led.Communities_Distributor__c ='Future Electronics';
            led.Phone= '23456';
            led.FirstName ='Test 3';
            led.Email = 'test3.test@ymail.com';
            led.OwnerId = userinfo.getUserId();
            led.title ='Mr';
            led.ROLE__c='Other';
            led.MobilePhone = '123456789';
            led.Distributor_Response__c = 'Dead';
            led.Street = 'graham st';
            led.City = 'toronto';
            led.State = 'NF';
            led.PostalCode = 'A';
            led.Country = 'canada';
            led.website = 'ww.te.com';
            led.Distributor_Comments__c = 'test';
            led.ACTIVITY_NOTES__c = 'test' ;
            led.Description = 'test';
            led.SUGGESTED_SE__c = 'test';
            lstLed.add(led);

            led = new Lead();
            led.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('C2S Lead').getRecordTypeId();
            led.LastName= 'Test Lead 4';
            led.FirstName = 'Test Lead 4 First';
            led.Assignee_Network_ID__c = 'XXNTWKID2';
            led.Company = 'Test Company 4';
            led.Status ='Passed to Distributor';
            led.Communities_Distributor__c ='Future Electronics';
            led.Phone= '23456';
            led.FirstName ='Test 4';
            led.OwnerId = userinfo.getUserId();
            led.title ='Mr';
            led.ROLE__c='Other';
            led.MobilePhone = '123456789';
            led.Distributor_Response__c = 'Dead';
            led.Street = 'graham st';
            led.City = 'toronto';
            led.State = 'NF';
            led.PostalCode = 'A';
            led.Country = 'canada';
            led.website = 'ww.te.com';
            led.Distributor_Comments__c = 'test';
            led.ACTIVITY_NOTES__c = 'test' ;
            led.Description = 'test';
            led.SUGGESTED_SE__c = 'test';
            led.Owner_Assigned__c = 1;
            lstLed.add(led);
            
// Start:  Modified by Mahesh Babu for CLR req-02 to improve code coverage
            led = new Lead();
            led.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('C2S Lead').getRecordTypeId();
            led.LastName= 'Test Lead 5';
            led.Email = 'test4.test@ymail.com';
            led.FirstName = 'Test Lead 5 First';
            // led.Assignee_Network_ID__c = 'XXNTWKID3';
            led.Company = 'Test Company 5';
            led.Status ='Passed to Distributor';
            led.Communities_Distributor__c ='Future Electronics';
            led.Phone= '23456';
            led.FirstName ='Test 5';
            led.OwnerId = userinfo.getUserId();
            led.title ='Mr';
            led.ROLE__c='Other';
            led.MobilePhone = '123456789';
            led.Distributor_Response__c = 'Dead';
            led.Street = 'graham st';
            led.City = 'toronto';
            led.State = 'NF';
            led.PostalCode = 'A';
            led.Country = 'canada';
            led.website = 'ww.te.com';
            led.Distributor_Comments__c = 'test';
            led.ACTIVITY_NOTES__c = 'test' ;
            led.Description = 'test';
            led.SUGGESTED_SE__c = 'test';
            led.Owner_Assigned__c = 1;
            lstLed.add(led);
            
            led = new Lead();
            led.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('C2S Lead').getRecordTypeId();
            led.LastName= 'Test Lead 6';
            led.Email = 'nimeide@testCompany1233423.com';
            led.FirstName = 'Test Lead 6 First';
            // led.Assignee_Network_ID__c = 'XXNTWKID4';
            led.Company = 'Test Company 6';
            led.Status ='Passed to Distributor';
            led.Communities_Distributor__c ='Future Electronics';
            led.Phone= '23456';
            led.FirstName ='Test 6';
            led.OwnerId = userinfo.getUserId();
            led.title ='Mr';
            led.ROLE__c='Other';
            led.MobilePhone = '123456789';
            led.Distributor_Response__c = 'Dead';
            led.Street = 'graham st';
            led.City = 'toronto';
            led.State = 'NF';
            led.PostalCode = 'A';
            led.Country = 'canada';
            led.website = 'ww.te.com';
            led.Distributor_Comments__c = 'test';
            led.ACTIVITY_NOTES__c = 'test' ;
            led.Description = 'test';
            led.SUGGESTED_SE__c = 'test';
            led.Owner_Assigned__c = 1;
            lstLed.add(led);
// End:  Modified by Mahesh Babu for CLR req-02 to improve code coverage            
			system.debug('profile from anonumours'+proTest+u4.profile.name);
			Test.startTest();
			System.runAs(u4) {
			 // The following code runs as user 'u' 
			 System.debug('Current User: ' + UserInfo.getUserName());
			 System.debug('Current Profile: ' + UserInfo.getProfileId()); 
				ClsRouteLeadUtil.routeLead_new(lstLed); 
				// system.assert(true); // commented by Pavan for case 901181
			}
			Test.stopTest();
    }    
    static testMethod void testCL() {
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        insert new Lead_Routing_Settings__c(Name = 'CC Business Analyst', Exclude_Network_ID_Assignment__c = true, Profile_Id__c = '00eE0000000afMM');
        insert new Live_Agent_Country_List__c(Name='test1234',Country_Code_2_Digit__c='CA',English__c='Canada');        
        
        User u2 = ClsTestHelp.createTestUsers();        
        u2.Email = 'ninid@testCompany1233423.com';
        u2.Username = u2.Email;
        u2.Alias = 'meizi';
        u2.CommunityNickname = 'nime';
        u2.ProfileId = p.Id;
        u2.Te_Network_Id__c = 'XXCCRR';
        u2.Territory_Code__c  = 'ABCDEFG';
        u2.IsActive = true;
        insert u2;
        //insert new Sales_Hierarchy__c(Name='test1234',Level_7_Territory_Code__c='ABCDEFG',Level_7_Default_Owner__c=u2.Id);
        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
        //sh.Level_2_Territory_Code__c = 'ABCDEFG';
        sh.Level_7_Assigned_User_Network_Ids__c = 'XXCCRR';
        //sh.Level_7_Default_Owner__c = u2.Id;
        insert sh;
        insert new ZSD_DMM_SAP__c(Region__c=NULL,Country_Key__c='CA',Postal_Code__c=NULL,District_Marketing_Manager__c=sh.Level_7_Territory_Code__c);
         Lead led = new Lead();
         led.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('C2S Lead').getRecordTypeId();
         led.LastName= 'Test Lead';
         led.Company = 'Test Company';
         led.Status ='Passed to Distributor';
         led.Communities_Distributor__c ='Future Electronics';
         led.Phone= '23456';
         led.FirstName ='Test';
         led.Email = 'test.test@ymail.com';
         led.OwnerId = userinfo.getUserId();
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
        
         Lead l = new Lead();
         l.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('C2S Lead').getRecordTypeId();
         l.LastName= 'Test Lead';
         l.Company = 'Test Company';
         l.Status ='Passed to Distributor';
         l.Communities_Distributor__c ='Future Electronics';
         l.Phone= '23456';
         l.FirstName ='Test';
         l.Email = 'test.test@ymail.com';
         l.OwnerId = userinfo.getUserId();
         l.title ='Mr';
         l.ROLE__c='Other';
         l.MobilePhone = '123456789';
         l.Distributor_Response__c = 'Dead';
         l.Street = 'Acd';
         l.City = 'asd';
         l.PostalCode = 'A';
         l.Country = 'Canada';
         l.website = 'ww.te.com';
         l.Distributor_Comments__c = 'test';
         l.ACTIVITY_NOTES__c = 'test' ;
         l.Description = 'test';
         l.SUGGESTED_SE__c = 'test';
         l.Lead_Recipient__c = 'Channel';
        
         Lead l1 = new Lead();
         l1.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('C2S Lead').getRecordTypeId();
         l1.LastName= 'Test Lead';
         l1.Company = 'Test Company';
         l1.Status ='Passed to Distributor';
         l1.Communities_Distributor__c ='Future Electronics';
         l1.Phone= '23456';
         l1.FirstName ='Test';
         l1.Email = 'test.test@ymail.com';
         l1.OwnerId = userinfo.getUserId();
         l1.title ='Mr';
         l1.ROLE__c='Other';
         l1.MobilePhone = '123456789';
         l1.Distributor_Response__c = 'Dead';
         l1.Street = 'Acd';
         l1.City = 'asd';
         l1.State = 'NF';
         l.Country = 'Canada';
         l1.website = 'ww.te.com';
         l1.Distributor_Comments__c = 'test';
         l1.ACTIVITY_NOTES__c = 'test' ;
         l1.Description = 'test';
         l1.SUGGESTED_SE__c = 'test';
         l1.Lead_Recipient__c = 'Channel';
         Lead l2 = new Lead();
         l2.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('C2S Lead').getRecordTypeId();
         l2.LastName= 'Test Lead';
         l2.Company = 'Test Company';
         l2.Status ='Passed to Distributor';
         l2.Communities_Distributor__c ='Future Electronics';
         l2.Phone= '23456';
         l2.FirstName ='Test';
         l2.Email = 'test.test@ymail.com';
         l2.OwnerId = userinfo.getUserId();
         l2.title ='Mr';
         l2.ROLE__c='Other';
         l2.MobilePhone = '123456789';
         l2.Distributor_Response__c = 'Dead';
         l2.Street = 'Acd';
         l2.City = 'asd';
         l2.Country = 'Canada';
         l2.website = 'ww.te.com';
         l2.Distributor_Comments__c = 'test';
         l2.ACTIVITY_NOTES__c = 'test' ;
         l2.Description = 'test';
         l2.SUGGESTED_SE__c = 'test';
         l2.Lead_Recipient__c = 'Channel';
        
         insert new list<lead>{led,l,l1,l2};
        
		 list<Lead> list_lead2Route = new list<Lead>();
         list_lead2Route.add(led);
        
        Test.startTest();
        	ClsRouteLeadUtil.routeLead(list_lead2Route);
			// system.assert(true); // commented by Pavan for case 901181
        Test.stopTest();
    }
    
    public static testMethod void testMostMethods() {
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
      //  Profile p = [Select Id, Name From Profile  where Name ='System Administrator'  or Name ='Systemadministrator' limit 1];
                     
        User u2 = ClsTestHelp.createTestUsers();        
        u2.Email = 'ninid@testCompany1233423.com';
        u2.Username = u2.Email;
        u2.Alias = 'meizi';
        u2.CommunityNickname = 'nime';
        u2.ProfileId = p.Id;
        u2.IsActive = true;
        //insert u2;
        
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'nimeide@testCompany1233423.com';
        u.Alias = 'nimeid';
        u.CommunityNickname = 'emdi';
        u.ProfileId = p.Id;
        u.IsActive = true;
        u.Te_Network_Id__c = u2.Id;
        u.Username = 'nimeia@ti.com';
        insert new list<User>{u,u2};
                
        Lead lead = new Lead();
        lead.LastName = 'wei';
        lead.Email = 'wei@sdlfks.com';
        lead.Company = 'wei';
        lead.Street = 'Acd';
         lead.City = 'asd';
         lead.State = 'aww';
         lead.PostalCode = '2322';
         lead.Country = 'acdd';
        lead.FirstName ='Test';
        lead.Assignee_Network_ID__c = u2.Id;
        insert lead;
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Account_Manager__c = u.Id;
        insert acc;
        
        Contact con = ClsTestHelp.createTestContacts();
        con.AccountId = acc.Id;
        con.Email = 'wei@sdlfks.com';
        insert con;
        
        list<Lead> list_lead2Route = new list<Lead>();
        list_lead2Route.add(lead);
        
        Test.startTest();       
        ClsRouteLeadUtil.routeLead(list_lead2Route);       
       // system.assert(true); // commented by Pavan for case 901181
        Test.stopTest();
        }
        
        static testMethod void testMostMethods1() {
            ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
            User u = ClsTestHelp.createTestUsers();
            u.Email = 'nimeide@testCompany12345453423.com';
            u.Alias = 'neid';
            u.CommunityNickname = 'ei';
            u.ProfileId = p.Id;
            u.IsActive = true;          
            u.Username = 'nimeia@ti.com';
            insert u;
        
            Lead lead = new Lead();
            lead.LastName = 'wei';
            lead.Email = 'wei@sdlfks.com';
            lead.Company = 'wei';
            lead.Street = 'Acd';
         lead.City = 'asd';
         lead.State = 'aww';
         lead.PostalCode = '2322';
         lead.Country = 'acdd';
            lead.FirstName ='Test';
            //insert lead;
            //--
            Lead lead1 = new Lead();
            lead1.LastName = 'Rick';
            lead1.Company = 'weiRick';
            lead1.Street = 'Acd';
            lead1.City = 'asd';
            lead1.State = 'aww';
            lead1.PostalCode = '2322';
            lead1.Country = 'acdd';
            lead1.FirstName ='Test rick';
            //insert lead1;
            
            Lead lead2 = new Lead();
            lead2.LastName = 'Jimmy';
            lead2.Email = 'jimmy@sdlfks.com';
            lead2.Company = 'wei jimmy';
            lead2.Street = 'Acd';
             lead2.City = 'asd';
             lead2.State = 'aww';
             lead2.PostalCode = '2322';
             lead2.Country = 'canada';
            lead2.FirstName ='Test jimmy';
            insert new list<lead>{lead,lead1,lead2};
            
            Account acc = ClsTestHelp.createTestAccounts();           
            insert acc;
            
            Contact con = ClsTestHelp.createTestContacts();
            con.AccountId = acc.Id;
            con.Email = 'wei@sdlfks.com';
            con.OwnerId = u.Id;
            insert con;
            
            list<Lead> list_lead2Route = new list<Lead>();
            list_lead2Route.add(lead);
            //----
            list_lead2route.add(lead1);
            list_lead2route.add(lead2);
            //---
            Test.startTest();       
            ClsRouteLeadUtil.routeLead(list_lead2Route);       
            Test.stopTest();
        }
        
        static testMethod void testMostMethods2() {
            ClsTestCustomSettingHelper.getApex_Helper_Settings();
            ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
            ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
            User u = ClsTestHelp.createTestUsers();
            u.Email = 'nimeide@testCompany15278723.com';          
            u.ProfileId = p.Id;
            u.IsActive = true;          
            u.Username = 'nimeia@ti.com';
            u.Te_Network_Id__c = 'te99976';
            insert u;
        
            Lead lead = new Lead();
            lead.LastName = 'wei';
            lead.Email = 'wei@sdlfks.com';
            lead.Company = 'wei'; 
            lead.Street = 'Acd';
            lead.City = 'asd';
            lead.State = 'aww';
            lead.PostalCode = '2322';
            lead.Country = 'acdd';
            lead.FirstName ='Test';
            insert lead;
           
            Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
            sh.Level_7_Assigned_User_Network_Ids__c = 'te99976';
            //sh.Level_7_Default_Owner__c = u.Id;
            
            Account acc = ClsTestHelp.createTestAccounts();
            acc.FE_Hierarchy__c = sh.Id;
            insert acc;
            
            Contact con = ClsTestHelp.createTestContacts();
            con.AccountId = acc.Id;
            con.Email = 'wei@sdlfks.com';           
            insert con;
            
            list<Lead> list_lead2Route = new list<Lead>();
            list_lead2Route.add(lead);
            
            Test.startTest();       
            ClsRouteLeadUtil.routeLead(list_lead2Route);       
          //  system.assert(true); // commented by Pavan for case 901181
            Test.stopTest();
        }   

    
/***************************************
* Test method for checkLeadOwner 
* *************************************/
        
    static testMethod void testcheckLeadOwner() {
     
// Creating Test data 

//Test user            
            User u2 = ClsTestHelp.createTestUsers();        
            u2.Email = 'testCLR@testCompany1233423.com';
            u2.Username = u2.Email;
            u2.Alias = 'testclr';
            u2.CommunityNickname = 'tclr';
            u2.ProfileId = p.Id;
            U2.Te_Network_Id__c = 'XXNTWKID1';
            u2.Territory_Code__c  = 'ABCDEFG';
            u2.IsActive = true;
            insert u2; 
// Leads      
            list<lead> lstLed = new list<lead>(); 
            Lead led = new Lead();
             
            led.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('C2S Lead').getRecordTypeId();
            led.LastName= 'Test Lead 1';
            led.Assignee_Network_ID__c = 'XXNTWKID1';
            led.Lead_Recipient__c = 'channel';
            led.Company = 'Test Company 1';
            led.Status ='Passed to Distributor';
            led.Communities_Distributor__c ='Future Electronics';
            led.Phone= '23456';
            led.FirstName ='Test 1';
            led.Email = 'test1.test@ymail.com';
            led.OwnerId = userinfo.getUserId();
            led.title ='Mr';
            led.ROLE__c='Other';
            led.MobilePhone = '123456789';
            led.Distributor_Response__c = 'Dead';
            led.Street = 'graham st';
            led.City = 'toronto';
            led.State = 'NF';
            led.PostalCode = 'A';
            led.Country = 'canada';
            led.website = 'ww.te.com';
            led.Distributor_Comments__c = 'test';
            led.ACTIVITY_NOTES__c = 'test' ;
            led.Description = 'test';
            led.SUGGESTED_SE__c = 'test';
            lstLed.add(led);
            
            led = new lead();
            led.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('C2S Lead').getRecordTypeId();
            led.LastName= 'Test Lead 2';
            led.Assignee_Network_ID__c = 'XXNTWKID2';
            led.Lead_Recipient__c = 'channel';
            led.Company = 'Test Company 2';
            led.Status ='Passed to Distributor';
            led.Communities_Distributor__c ='Future Electronics';
            led.Phone= '23456';
            led.FirstName ='Test 2';
            led.Email = 'test2.test@ymail.com';
            led.OwnerId = userinfo.getUserId();
            led.title ='Mr';
            led.ROLE__c='Other';
            led.MobilePhone = '123456789';
            led.Distributor_Response__c = 'Dead';
            led.Street = 'graham st';
            led.City = 'toronto';
            led.State = 'NH';
            led.PostalCode = 'A';
            led.Country = 'canada';
            led.website = 'ww.te.com';
            led.Distributor_Comments__c = 'test';
            led.ACTIVITY_NOTES__c = 'test' ;
            led.Description = 'test';
            led.SUGGESTED_SE__c = 'test';
            lstLed.add(led);
            
            Test.startTest();
            List<Lead> lstLead2Route =  ClsRouteLeadUtil.checkLeadOwner(lstLed); 
                // insert lstLed;
              //  system.assert(true); // commented by Pavan for case 901181
            Test.stopTest();
        
    }           
/***************************************
* Test method for Channel Lead routing 
* *************************************/
        
    static testMethod void testchannelLeadOwnerAssignment() {
// Creating Test data 

//Test user            
            User u2 = ClsTestHelp.createTestUsers();        
            u2.Email = 'testCLR@testCompany1233423.com';
            u2.Username = u2.Email;
            u2.Alias = 'testclr';
            u2.CommunityNickname = 'tclr';
            u2.ProfileId = p.Id;
            U2.Te_Network_Id__c = 'XXCCRR';
            u2.Territory_Code__c  = 'ABCDEFG';
            u2.IsActive = true;
            insert u2;

// Sales hierarchy 
            Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
            sh.Level_7_Assigned_User_Network_Ids__c = 'XXCCRR';
            sh.Level_7_Default_Owner__c = u2.id;
            sh.Level_7_Territory_Code__c = 'ABCDEFG';
            insert sh;

// Live Agen country 
            insert new Live_Agent_Country_List__c(Name='test1234',Country_Code_2_Digit__c='CA',English__c='Canada');                    

// District marketing Manager
            insert new ZSD_DMM_SAP__c(Region__c='NF',Country_Key__c='CA',Postal_Code__c='A',District_Marketing_Manager__c=sh.Level_7_Territory_Code__c);

// Leads      
            list<lead> lstLed = new list<lead>(); 
            Lead led = new Lead();
             
            led.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('C2S Lead').getRecordTypeId();
            led.LastName= 'Test Lead 1';
            led.Lead_Recipient__c = 'channel';
            led.Company = 'Test Company 1';
            led.Status ='Passed to Distributor';
            led.Communities_Distributor__c ='Future Electronics';
            led.Phone= '23456';
            led.FirstName ='Test 1';
            led.Email = 'test1.test@ymail.com';
            led.OwnerId = userinfo.getUserId();
            led.title ='Mr';
            led.ROLE__c='Other';
            led.MobilePhone = '123456789';
            led.Distributor_Response__c = 'Dead';
            led.Street = 'graham st';
            led.City = 'toronto';
            led.State = 'NF';
            led.PostalCode = 'A';
            led.Country = 'canada';
            led.website = 'ww.te.com';
            led.Distributor_Comments__c = 'test';
            led.ACTIVITY_NOTES__c = 'test' ;
            led.Description = 'test';
            led.SUGGESTED_SE__c = 'test';
            lstLed.add(led);
            
            led = new lead();
            led.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('C2S Lead').getRecordTypeId();
            led.LastName= 'Test Lead 2';
            led.Lead_Recipient__c = 'channel';
            led.Company = 'Test Company 2';
            led.Status ='Passed to Distributor';
            led.Communities_Distributor__c ='Future Electronics';
            led.Phone= '23456';
            led.FirstName ='Test 2';
            led.Email = 'test2.test@ymail.com';
            led.OwnerId = userinfo.getUserId();
            led.title ='Mr';
            led.ROLE__c='Other';
            led.MobilePhone = '123456789';
            led.Distributor_Response__c = 'Dead';
            led.Street = 'graham st';
            led.City = 'toronto';
            led.State = 'NH';
            led.PostalCode = 'A';
            led.Country = 'canada';
            led.website = 'ww.te.com';
            led.Distributor_Comments__c = 'test';
            led.ACTIVITY_NOTES__c = 'test' ;
            led.Description = 'test';
            led.SUGGESTED_SE__c = 'test';
            lstLed.add(led);
        
            led = new lead();
            led.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('C2S Lead').getRecordTypeId();
            led.LastName= 'Test Lead 3';
            led.Company = 'Test Company 3';
            led.Lead_Recipient__c = 'channel';
            led.Status ='Passed to Distributor';
            led.Communities_Distributor__c ='Future Electronics';
            led.Phone= '23456';
            led.FirstName ='Test 3';
            led.Email = 'test3.test@ymail.com';
            led.OwnerId = userinfo.getUserId();
            led.title ='Mr';
            led.ROLE__c='Other';
            led.MobilePhone = '123456789';
            led.Distributor_Response__c = 'Dead';
            led.Street = 'graham st';
            led.City = 'toronto';
            led.State = 'NF';
            led.PostalCode = 'B';
            led.Country = 'canada';
            led.website = 'ww.te.com';
            led.Distributor_Comments__c = 'test';
            led.ACTIVITY_NOTES__c = 'test' ;
            led.Description = 'test';
            led.SUGGESTED_SE__c = 'test';
            lstLed.add(led);
         
            led = new lead();
            led.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('C2S Lead').getRecordTypeId();
            led.LastName= 'Test Lead 4';
            led.Company = 'Test Company 4';
            led.Lead_Recipient__c = 'channel';
            led.Status ='Passed to Distributor';
            led.Communities_Distributor__c ='Future Electronics';
            led.Phone= '23456';
            led.FirstName ='Test 4';
            led.Email = 'test4.test@ymail.com';
            led.OwnerId = userinfo.getUserId();
            led.title ='Mr';
            led.ROLE__c='Other';
            led.MobilePhone = '123456789';
            led.Distributor_Response__c = 'Dead';
            led.Street = 'graham st';
            led.City = 'toronto';
            led.State = 'NH';
            led.PostalCode = 'B';
            led.Country = 'canada';
            led.website = 'ww.te.com';
            led.Distributor_Comments__c = 'test';
            led.ACTIVITY_NOTES__c = 'test' ;
            led.Description = 'test';
            led.SUGGESTED_SE__c = 'test';
            lstLed.add(led);
           
        
            led = new lead();
            led.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('C2S Lead').getRecordTypeId();
            led.LastName= 'Test Lead 5';
            led.Company = 'Test Company 4';
            led.Lead_Recipient__c = 'channel';
            led.Status ='Passed to Distributor';
            led.Communities_Distributor__c ='Future Electronics';
            led.Phone= '23456';
            led.FirstName ='Test 5';
            led.Email = 'test5.test@ymail.com';
            led.OwnerId = '00GE0000001tgoqMAA';
            led.title ='Mr';
            led.ROLE__c='Other';
            led.MobilePhone = '1234567890';
            led.Distributor_Response__c = 'Dead';
            led.Street = 'graham st';
            led.City = 'toronto';
            led.State = 'NF';
            led.PostalCode = 'ABC';
            led.Country = 'Canada';
            led.website = 'ww.te.com';
            led.Distributor_Comments__c = 'test';
            led.ACTIVITY_NOTES__c = 'test' ;
            led.Description = 'test';
            led.SUGGESTED_SE__c = 'test';
            lstLed.add(led);
            
        
         led = new lead();
            led.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('C2S Lead').getRecordTypeId();
            led.LastName= 'Test Lead 78';
            led.Company = 'Test Company 45';
            led.Lead_Recipient__c = 'channel';
            led.Status ='Passed to Distributor';
            led.Communities_Distributor__c ='Future Electronics';
            led.Phone= '234567';
            led.FirstName ='Test 5';
            led.Email = 'test65.test@ymail.com';
            led.OwnerId = '00GE0000001tgoqMAA';
            led.title ='Mr';
            led.ROLE__c='Other';
            led.MobilePhone = '1234567890';
            led.Distributor_Response__c = 'Dead';
            led.Street = 'graham st';
            led.City = 'toronto';
            led.State = 'NF'; //changed by sai
            led.PostalCode = 'A';
            led.Country = 'Canada';
            led.website = 'ww.te.com';
            led.Distributor_Comments__c = 'test';
            led.ACTIVITY_NOTES__c = 'test' ;
            led.Description = 'test';
            led.SUGGESTED_SE__c = 'test';
            lstLed.add(led);
       	    led = new lead();
            led.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('C2S Lead').getRecordTypeId();
            led.LastName= 'Test Lead 789';
            led.Company = 'Test Company 456';
            led.Lead_Recipient__c = 'channel';
            led.Status ='Passed to Distributor';
            led.Communities_Distributor__c ='Future Electronics';
            led.Phone= '2345678';
            led.FirstName ='Test 57';
            led.Email = 'test657.test@ymail.com';
            led.OwnerId = '00GE0000001tgoqMAA';
            led.title ='Mr';
            led.ROLE__c='Other';
            led.MobilePhone = '123456890';
            led.Distributor_Response__c = 'Dead';
            led.Street = 'graham st';
            led.City = 'toronto';
            //led.State = 'NF'; 
            led.PostalCode = 'A';
            led.Country = 'Canada';
            led.website = 'ww.te.com';
            led.Distributor_Comments__c = 'test';
            led.ACTIVITY_NOTES__c = 'test' ;
            led.Description = 'test';
            led.SUGGESTED_SE__c = 'test';
            lstLed.add(led);
        
            Group grp=new Group(
            name='Filter Agent new'
            ); 
            insert grp;
             Test.startTest();
                insert lstLed;
                ClsRouteLeadUtil.channelLeadOwnerAssignment(lstLed);
            Test.stopTest();

        }
}