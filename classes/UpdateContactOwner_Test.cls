/**
 *  This test class is for UpdateContactOwner.
 * 
 @author Pawan Kumar Nitin Vasigala
 @created 07-19-2016
 @version 1.0
 * 
 @changelog
 * 07-19-2016 Pawan Kumar Nitin Vasigala <pavan.vasigala@zensar.com>
 * - Created
 * - Test coverage 92%
 */

@isTest(seeAllData=false)
public with sharing class UpdateContactOwner_Test{

   @testSetup 
    static void createTestData(){
            User alternateAdmin = [Select Id,UserName from User Where Id !=:UserInfo.getUserId() and IsActive = true and Profile.Name='DND FAE User' LIMIT 1];


       
            createUsers();
       
         system.runAs(alternateAdmin){
        ClsTestCustomSettingHelper.getAllSettings();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
        
        ADMTerritoryCode__c admTerritory= new ADMTerritoryCode__c();
        admTerritory.Name='ADMTerritoryCode';
        admTerritory.Territory_Code__c='101485';
        
        insert admTerritory;
        createSalesHierarchy();
        createAccount();
        
         }
    }
    
    @isTest
    static void testContactReassignmentOnFeChange(){
        
        Account dbAccount = [Select Id,GAMCD__c,FE_Hierarchy__c from Account];
        
        List<Sales_Hierarchy__c> slist = [Select Id,Level_7_Default_OWner__c,Level_7_territory_Code__c from Sales_Hierarchy__c Where 
                                        Level_7_territory_Code__c IN ('SH001','SH002')];
     User alternateAdmin = [Select Id,UserName from User Where Id !=:UserInfo.getUserId() and IsActive = true and Profile.Name='System Administrator' LIMIT 1];

        dbAccount.FE_Hierarchy__c = slist[0].Id;
        dbAccount.ACCTMGRCD__c = 'FE001';
        system.runAs(alternateAdmin){
        update dbAccount;
        }
        Contact con1 = createContact('Davidson',dbAccount);
        con1.ownerId = slist[0].Level_7_Default_OWner__c;
        
        Contact con2 = createcontact('Maddinson',dbAccount); 
        con2.ownerId = slist[0].Level_7_Default_OWner__c;
        
        insert new List<Contact>{con1,con2};
        
        Test.startTest();
            
            dbAccount.FE_Hierarchy__c = slist[1].Id;
            dbAccount.ACCTMGRCD__c = 'FE002';
            update dbAccount;
        
        Test.stopTest();
        
        List<Contact> dbContacts = [Select Id,LastName,OwnerId from Contact where Id In : new List<Id>{con1.Id,con2.Id}];
        
        System.assertEquals(dbContacts[0].ownerId,slist[1].Level_7_Default_Owner__c,'Verifying the Successful Contact ownership transfer to the new FE');
        System.assertEquals(dbContacts[1].ownerId,slist[1].Level_7_Default_Owner__c,'Verifying the Successful Contact ownership transfer to the new FE');
    }

    @isTest
    static void testContactReassignmentOnGAMChange(){
        
        Account dbAccount = [Select Id,GAMCD__c from Account];
        
        List<Sales_Hierarchy__c> slist = [Select Id,Level_7_Default_OWner__c,Level_7_territory_Code__c from Sales_Hierarchy__c Where 
                                        Level_7_territory_Code__c IN ('SH003','SH004')];
        
        dbAccount.GAMCD__c = slist[0].Level_7_territory_Code__c;
        update dbAccount;
        
        Contact con1 = createContact('Davidson',dbAccount);
        con1.ownerId = slist[0].Level_7_Default_OWner__c;
        
        Contact con2 = createcontact('Maddinson',dbAccount); 
        con2.ownerId = slist[0].Level_7_Default_OWner__c;
        
        insert new List<Contact>{con1,con2};
        
        Test.startTest();
            
            dbAccount.GAMCD__c = slist[1].Level_7_territory_Code__c;
            update dbAccount;
        
        Test.stopTest();
        
        List<Contact> dbContacts = [Select Id,LastName,OwnerId from Contact where Id In : new List<Id>{con1.Id,con2.Id}];
        
        System.assertEquals(dbContacts[0].ownerId,slist[1].Level_7_Default_Owner__c,'Verifying the Successful Contact ownership transfer to the new GAM');
        System.assertEquals(dbContacts[1].ownerId,slist[1].Level_7_Default_Owner__c,'Verifying the Successful Contact ownership transfer to the new GAM');
    }
    
    @isTest
    static void testContactReassignmentOnFeAndGamChange(){
        
        Account dbAccount = [Select Id,GAMCD__c,FE_Hierarchy__c from Account];
        
        List<Sales_Hierarchy__c> slist = [Select Id,Level_7_Default_OWner__c,Level_7_territory_Code__c from Sales_Hierarchy__c Where 
                                        Level_7_territory_Code__c IN ('SH001','SH002','SH003','SH004')];
        
        dbAccount.FE_Hierarchy__c = slist[0].Id;
        dbAccount.ACCTMGRCD__c = 'FE001';
        dbAccount.GAMCD__c = slist[1].Level_7_territory_Code__c;
        update dbAccount;
        
        Contact con1 = createContact('Davidson',dbAccount);
        con1.ownerId = slist[0].Level_7_Default_OWner__c;
        
        Contact con2 = createcontact('Maddinson',dbAccount); 
        con2.ownerId = slist[0].Level_7_Default_OWner__c;
        
        Contact con3 = createContact('Richardson',dbAccount);
        con3.ownerId = slist[1].Level_7_Default_OWner__c;
        
        Contact con4 = createcontact('Lawson',dbAccount); 
        con4.ownerId = slist[1].Level_7_Default_OWner__c;
        
        insert new List<Contact>{con1,con2,con3,con4};
        
        Test.startTest();
            
            dbAccount.FE_Hierarchy__c = slist[2].Id;
            dbAccount.ACCTMGRCD__c = 'FE002';
            dbAccount.GAMCD__c = slist[3].Level_7_territory_Code__c;
            update dbAccount;
        
        Test.stopTest();
        
        List<Contact> dbContacts = [Select Id,LastName,OwnerId from Contact where Id In : new List<Id>{con1.Id,con2.Id,con3.Id,con4.Id}];
        
        System.assertEquals(dbContacts[0].ownerId,slist[2].Level_7_Default_Owner__c,'Verifying the Successful Contact ownership transfer to the new FE');
        System.assertEquals(dbContacts[1].ownerId,slist[2].Level_7_Default_Owner__c,'Verifying the Successful Contact ownership transfer to the new FE');
        System.assertEquals(dbContacts[2].ownerId,slist[3].Level_7_Default_Owner__c,'Verifying the Successful Contact ownership transfer to the new GAM');
        System.assertEquals(dbContacts[3].ownerId,slist[3].Level_7_Default_Owner__c,'Verifying the Successful Contact ownership transfer to the new GAM');
    }
    
    @isTest
    static void testContactReassignmentOnFE_Gam_Removal(){
        
        Account dbAccount = [Select Id,GAMCD__c,FE_Hierarchy__c from Account];
        
        List<Sales_Hierarchy__c> slist = [Select Id,Level_7_Default_OWner__c,Level_7_territory_Code__c from Sales_Hierarchy__c Where 
                                        Level_7_territory_Code__c IN ('SH001','SH002','SH003')];
        
        dbAccount.FE_Hierarchy__c = slist[0].Id;
        dbAccount.Account_Manager__c = slist[2].Level_7_Default_OWner__c;
        dbAccount.ACCTMGRCD__c = 'FE001';
        dbAccount.GAMCD__c = slist[1].Level_7_territory_Code__c;
        update dbAccount;
        
        Contact con1 = createContact('Davidson',dbAccount);
        con1.ownerId = slist[0].Level_7_Default_OWner__c;
        
        Contact con2 = createcontact('Maddinson',dbAccount); 
        con2.ownerId = slist[0].Level_7_Default_OWner__c;
        
        Contact con3 = createContact('Richardson',dbAccount);
        con3.ownerId = slist[1].Level_7_Default_OWner__c;
        
        Contact con4 = createcontact('Lawson',dbAccount); 
        con4.ownerId = slist[1].Level_7_Default_OWner__c;
        
        insert new List<Contact>{con1,con2,con3,con4};
        
        Test.startTest();
            
            dbAccount.FE_Hierarchy__c = null;
            dbAccount.ACCTMGRCD__c = null;
            dbAccount.GAMCD__c = null;
            update dbAccount;
        
        Test.stopTest();
        
        List<Contact> dbContacts = [Select Id,LastName,OwnerId from Contact where Id In : new List<Id>{con1.Id,con2.Id,con3.Id,con4.Id}];
        
        System.assertEquals(dbContacts[0].ownerId,slist[2].Level_7_Default_Owner__c,'Verifying the Successful Contact ownership transfer to the Account Manager');
        System.assertEquals(dbContacts[1].ownerId,slist[2].Level_7_Default_Owner__c,'Verifying the Successful Contact ownership transfer to the Account Manager');
        System.assertEquals(dbContacts[2].ownerId,slist[2].Level_7_Default_Owner__c,'Verifying the Successful Contact ownership transfer to the Account Manager');
        System.assertEquals(dbContacts[3].ownerId,slist[2].Level_7_Default_Owner__c,'Verifying the Successful Contact ownership transfer to the Account Manager');
    }
    
    @isTest
    static void testContactReassignmentOnHierarchyOwnerChange(){
        
        Account dbAccount = [Select Id,GAMCD__c from Account];
        
        List<Sales_Hierarchy__c> slist = [Select Id,Level_7_Default_OWner__c,Level_7_territory_Code__c,Level_7_Assigned_User_Network_Ids__c from Sales_Hierarchy__c Where 
                                        Level_7_territory_Code__c IN ('SH001','SH002')];
        
        dbAccount.GAMCD__c = slist[0].Level_7_territory_Code__c;
        update dbAccount;
        
        Contact con1 = createContact('Davidson',dbAccount);
        con1.ownerId = slist[0].Level_7_Default_OWner__c;
        
        Contact con2 = createcontact('Maddinson',dbAccount); 
        con2.ownerId = slist[0].Level_7_Default_OWner__c;
        
        insert new List<Contact>{con1,con2};
        
        Test.startTest();
        
            slist[0].Level_7_Assigned_User_Network_Ids__c = slist[1].Level_7_Assigned_User_Network_Ids__c; 
            update slist[0];
        
        Test.stopTest();
        
        List<Contact> dbContacts = [Select Id,LastName,ownerId from Contact Where Id IN : new List<Id>{con1.Id,con2.Id}];
        
        System.assertEquals(dbContacts[0].ownerId,slist[1].Level_7_Default_Owner__c,'Verifying the Successful Contact ownership transfer to the new GAM who came to the hierarchy');
        System.assertEquals(dbContacts[1].ownerId,slist[1].Level_7_Default_Owner__c,'Verifying the Successful Contact ownership transfer to the new GAM who came to the hierarchy');
    }
    
    static void createUsers(){
        
       Profile p = [SELECT Id FROM Profile WHERE  id='00eE0000000afKa']; //Name='DND Engineering User w/Cost or
        
        System.debug('profiel id::'+p.id);
        
        
        User u = new User();
        u.FirstName ='First';
        u.LastName = 'Tester';
        u.Alias = 'mtst';
        u.Email = 'mtester@ItbTestcompany.com';
        u.Username =getUserNamePrefix()+ u.Email;// Modified by Mrunal to get Unique UserName for each user.
        u.CommunityNickname = u.Alias;
        u.ProfileId =p.Id;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        
     //   insert u;
       
        User u1 = new User(  Alias = 'user1', Email='user1@testte.com', 
                              EmailEncodingKey='ISO-8859-1', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id, 
                              TimeZoneSidKey='America/New_York', UserName='user1@testte.com',
                              Te_Network_Id__c='TE9044730');
       // insert u1;
    
        User u2 = new User(  Alias = 'user1', Email='user2@testte.com', 
                              EmailEncodingKey='ISO-8859-1', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US',ProfileId = p.Id,
                              TimeZoneSidKey='America/New_York', UserName='user2@testte.com',
                              Te_Network_Id__c='TE9044731' );
                              
        User u3 = new User(  Alias = 'user1', Email='user3@testte.com', 
                              EmailEncodingKey='ISO-8859-1', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p.Id,
                              TimeZoneSidKey='America/New_York', UserName='user3@testte.com',
                              Te_Network_Id__c='TE9044732' );
                              
        User u4 = new User(  Alias = 'user1', Email='user4@testte.com', 
                              EmailEncodingKey='ISO-8859-1', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id, 
                              TimeZoneSidKey='America/New_York', UserName='user4@testte.com',
                              Te_Network_Id__c='TE9044733');                                                
                          
        insert new List<User>{u1,u2,u3,u4};
      
    }
    public static String getUserNamePrefix(){

        return UserInfo.getOrganizationId() + System.now().millisecond();

    }
    static void createSalesHierarchy(){
        
        List<User> userList = [Select Id,FirstName,LastName,Te_Network_Id__c from User Where UserName IN ('user1@testte.com',
                                                                                         'user2@testte.com',
                                                                                         'user3@testte.com',
                                                                                         'user4@testte.com')];
                                                                                         
        
        Sales_Hierarchy__c hierar1 = ClsTestHelp.createTestSalesHierarchy();
        Sales_Hierarchy__c hierar2 = ClsTestHelp.createTestSalesHierarchy();
        Sales_Hierarchy__c hierar3 = ClsTestHelp.createTestSalesHierarchy();
        Sales_Hierarchy__c hierar4 = ClsTestHelp.createTestSalesHierarchy();
        
        hierar1.Level_7_Territory_Code__c = 'SH001';
        hierar1.Level_7_Assigned_User_Network_Ids__c = 'TE9044730';
        hierar1.Level_7_Default_Owner__c=userList [0].Id;
        
        hierar2.Level_7_Territory_Code__c = 'SH002';
        hierar2.Level_7_Assigned_User_Network_Ids__c = 'TE9044731';
          hierar2.Level_7_Default_Owner__c=userList [1].Id;
        
        hierar3.Level_7_Territory_Code__c = 'SH003';
        hierar3.Level_7_Assigned_User_Network_Ids__c = 'TE9044732';
          hierar3.Level_7_Default_Owner__c=userList [2].Id;
          
        hierar4.Level_7_Territory_Code__c = 'SH004';
        hierar4.Level_7_Assigned_User_Network_Ids__c = 'TE9044733';
          hierar4.Level_7_Default_Owner__c=userList [3].Id;
        
        insert new List<Sales_Hierarchy__c>{hierar1,hierar2,hierar3,hierar4};
        
    }
    static void createAccount(){
        
        Schema.DescribeSObjectResult d = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName =  rtMapByName.get('Account');
        
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rtByName.getRecordTypeId();
        insert acc;
        
    }
    static Contact createContact(String pLastName,Account acc){
        return new Contact(lastName=pLastName,AccountId=acc.Id,Salutation='Mr');
    }
}