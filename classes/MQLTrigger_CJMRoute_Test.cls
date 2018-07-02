@isTest
public class MQLTrigger_CJMRoute_Test {
  
    /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Lead MQL CJMUser assignment logic Test                                                                        |
 |   Input : Lead or MQLRecord Records
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/  
      public static testMethod void RoundRobinCJMRoute(){
         
         Id adminProfileId = [select Id  from Profile where Name = 'System Administrator'][0].Id;
         List<User> userList = new List<User>();
         User user1 = new User(  Alias = 'TE123456', Email='user1@testte.com', 
                              EmailEncodingKey='ISO-8859-1', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = adminProfileId, 
                              TimeZoneSidKey='America/New_York', UserName='TE1234567@te.com',
                              Te_Network_Id__c='TE123456');
         userList.add(user1);
         User user2 = new User(  Alias = 'TE654321', Email='user1@testte.com', 
                              EmailEncodingKey='ISO-8859-1', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = adminProfileId, 
                              TimeZoneSidKey='America/New_York', UserName='TE7654321@te.com',
                              Te_Network_Id__c='TE654321');
         userList.add(user2);
         
         User user3 = new User(  Alias = 'EB123444', Email='user1@testte.com', 
                              EmailEncodingKey='ISO-8859-1', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = adminProfileId, 
                              TimeZoneSidKey='America/New_York', UserName='EB123444@te.com',
                              Te_Network_Id__c='EB123444');
         userList.add(user3);
         
         insert userList;
         Test.startTest();
         ClsTestHelp.createTestName();
         ClsTestHelp.createTestName2();
         ClsTestHelp.createTestName3();
         ClsTestHelp.createTestName4();
         ClsTestHelp.createTestCSD7();
         ClsTestHelp.createTestCSD3();
         ClsTestHelp.createTestCSD1();
         
         ClsTestCustomSettingHelper.getTrigger_Configuration();
         
         ClsTestCustomSettingHelper.getZSD_DMM_SAP();
         
         ClsTestCustomSettingHelper.getLiveAgentCountry();
         
         ClsTestCustomSettingHelper.getMQLConstantVariables();
         
         Assignment_Group_Name__c AGN = new Assignment_Group_Name__c();
         AGN.Name = 'Appliances Inside Sales - Americas';
         AGN.Type__c = 'Case';
         insert AGN;
         
         Assignment_Group_Queues__c AGQ = new Assignment_Group_Queues__c();
         AGQ.Name = 'Appliances Inside Sales - Americas';
         AGQ.Assignment_Group_Name__c = AGN.Id;
         insert AGQ;
         
         Assignment_Groups__c AG = new Assignment_Groups__c();
         AG.Group_Name__c = AGN.Id;
         AG.User__c = user3.id; 
         insert AG;
         
         TEMarketing__me_settings__c me = new TEMarketing__me_settings__c();
         me.SetupOwnerId=UserInfo.getOrganizationId();
         me.TEMarketing__Time_to_include_campaign_responses__c = 24;
         insert me;
         
         RecordType rt = ClsTestHelp.createTestRecordType8();

         Account accountObj = ClsTestHelp.createtestAccounts();
         accountObj.Industry_Code_Description__c = 'Appliances';
         accountObj.RecordTypeid = rt.Id;
         insert accountObj;
         
         List<Contact> contactlist = new List<Contact>();
         Contact contactObj = ClsTestHelp.createTestContacts(); 
         contactObj.MailingState = 'EU';
         contactObj.accountid = accountObj.Id;
         contactObj.ownerid = user3.Id;
         contactObj.Assigned_Distributor__c = 'Avnet';
         contactlist.add(contactObj);
         
         Contact contactObj2 = ClsTestHelp.createTestContacts(); 
         contactObj2.MailingState = 'EU';
         contactObj2.accountid = accountObj.Id;
         contactObj2.ownerid = user2.Id;
         contactObj2.Assigned_Distributor__c = 'Avnet';
         contactlist.add(contactObj2);
         insert contactlist;
         Test.stopTest();
         
         List<Sales_Hierarchy__c> SalesHierarchyList = new List<Sales_Hierarchy__c>();
         Sales_Hierarchy__c sales_Hierarchy = ClsTestHelp.createTestSalesHierarchy();
         sales_Hierarchy.Level_7_Territory_Code__c = 'A010018';
         sales_Hierarchy.Level_7_Assigned_User_Network_Ids__c = 'TE123456';
         SalesHierarchyList.add(sales_Hierarchy);
         Sales_Hierarchy__c sales_Hierarchy2 = ClsTestHelp.createTestSalesHierarchy();
         sales_Hierarchy2.Level_7_Territory_Code__c = 'A010019';
         sales_Hierarchy2.Level_7_Assigned_User_Network_Ids__c = 'TE123456';
         SalesHierarchyList.add(sales_Hierarchy2);
         Sales_Hierarchy__c sales_Hierarchy3 = ClsTestHelp.createTestSalesHierarchy();
         sales_Hierarchy3.Level_7_Territory_Code__c = 'A010020';
         sales_Hierarchy3.Level_7_Assigned_User_Network_Ids__c = 'TE654321';
         SalesHierarchyList.add(sales_Hierarchy3);
         Sales_Hierarchy__c sales_Hierarchy4 = ClsTestHelp.createTestSalesHierarchy();
         sales_Hierarchy4.Level_7_Territory_Code__c = 'A010021';
         sales_Hierarchy4.Level_7_Assigned_User_Network_Ids__c = 'TE654321';
         SalesHierarchyList.add(sales_Hierarchy4); 
         
         Database.insert(SalesHierarchyList);
         
         RecordType centralLead = ClsTestHelp2.createTestRecordType1();
         Apex_Helper_Settings__c AHS = new Apex_Helper_Settings__c (name = 'Lead Central RT Id', Value__c = centralLead.Id, Active__c=true);
         insert AHS;
         
         List<TEMarketing__MQLRecord__c> MQLRecordList = new List<TEMarketing__MQLRecord__c>();
         
         TEMarketing__MQLRecord__c MQLRecord = ClsTestHelp2.getMQLRecord();
         MQLRecord.Key_Customer_Cde__c = 'S';   
         MQLRecord.TEMarketing__Contact__c = contactObj.Id;     
         MQLRecordList.add(MQLRecord);
         
         TEMarketing__MQLRecord__c MQLRecord2 = ClsTestHelp2.getMQLRecord();
         MQLRecord2.Key_Customer_Cde__c = 'X04';           
         MQLRecord2.TEMarketing__Contact__c = contactObj.Id;
         MQLRecordList.add(MQLRecord2);
         
         TEMarketing__MQLRecord__c MQLRecord3 = ClsTestHelp2.getMQLRecord();
         MQLRecord3.Key_Customer_Cde__c = 'S';           
         MQLRecord3.TEMarketing__Contact__c = contactObj2.Id;
         MQLRecordList.add(MQLRecord3);  
         
         TEMarketing__MQLRecord__c MQLRecord4 = ClsTestHelp2.getMQLRecord();
         MQLRecord4.Key_Customer_Cde__c = 'S';           
         MQLRecord4.TEMarketing__Contact__c = contactObj.Id;
         MQLRecordList.add(MQLRecord4); 
          
         database.insert(MQLRecordList);
         
         TEMarketing__MQLRecord__c MQLRecord5 = ClsTestHelp2.getMQLRecord();
         MQLRecord5.Key_Customer_Cde__c = 'FAI';  
         MQLRecord5.TEMarketing__Contact__c = contactObj2.Id;
         insert MQLRecord5;
         
         List<Lead> leadlist = new List<Lead>();
         
         Lead vLead = ClsTestHelp2.getLead();         
         vLead.Country                   = 'United States';
         vLead.City                      = 'SS';
         vLead.Street                    = 'CA';
         vLead.City                      = 'SS';
         vLead.State                     = 'CA';
         vLead.Key_Customer_Cde__c      = 'S';
         vLead.RecordTypeId              = centralLead.Id;

         leadlist.add(vLead);
        
         Lead vLead2 = ClsTestHelp2.getLead(); 
         vLead2.FirstName                 = 'xyzc';    
         vLead2.LastName                  = 'abcd';
         vLead2.Email                     = vLead2.FirstName + '.' + vLead2.LastName + '@sampledomain.com';    
         vLead2.Company                   = 'Company 1';
         vLead2.Status                    = 'Assigned Unaccepted';
         vLead2.Country                    = 'Germany';
         vLead2.Street                     = 'CA';
         vLead2.City                       = 'SS1';
         vLead2.State                      = 'EU';
         vLead2.Key_Customer_Cde__c      = 'X04';
         vLead2.RecordTypeId              = centralLead.Id;
         
         leadList.add(vLead2);
         
         Lead vlead3 = ClsTestHelp2.getLead(); 

         vlead3.Country                   = 'United States';
         vlead3.City                      = 'SS';
         vlead3.Street                    = 'CA';
         vlead3.City                      = 'SS';
         vlead3.State                     = 'DC';
         vlead3.Key_Customer_Cde__c      = 'S';
         vLead3.RecordTypeId              = centralLead.Id;
         leadlist.add(vlead3);
        
         Lead vlead4 = ClsTestHelp2.getLead();
         vlead4.Country                    = 'India';
         vlead4.Street                     = 'CA';
         vlead4.City                       = 'SS1';
         vlead4.State                      = 'EU';
         vlead4.Key_Customer_Cde__c      = 'S';
         vLead4.RecordTypeId              = centralLead.Id;
         leadList.add(vlead4);
         
         Lead vlead5 = ClsTestHelp2.getLead(); 
         vlead5.Country                    = 'Germany';
         vlead5.Street                     = 'CA';
         vlead5.City                       = 'SS1';
         vlead5.State                      = 'EU';
         vlead5.Assignee_Network_Id__c     = 'TE156515';
         vLead5.RecordTypeId              = centralLead.Id;
         leadList.add(vlead5);
         
         Lead vlead6 = ClsTestHelp2.getLead(); 
         vlead6.Country                    = 'Italy';
         vlead6.Street                     = 'CA';
         vlead6.City                       = 'SS1';
         vlead6.State                      = 'EU';
         vlead6.Key_Customer_Cde__c      = 'S';
         vLead6.RecordTypeId              = centralLead.Id;
         leadList.add(vlead6);
         
         Lead vlead7 = ClsTestHelp2.getLead(); 
         vlead7.Country                    = '';
         vlead7.Street                     = 'CA';
         vlead7.City                       = 'SS1';
         vlead7.State                      = 'EU';
         vlead7.Key_Customer_Cde__c      = 'S';
         vLead7.RecordTypeId              = centralLead.Id;
         leadList.add(vlead7);
         
         Lead vlead8 = ClsTestHelp2.getLead(); 
         vlead8.Country                    = 'Germany';
         vlead8.Street                     = 'CA';
         vlead8.City                       = 'SS1';
         vlead8.State                      = 'EU';
         vlead8.Assignee_Network_Id__c     = 'TE123456';
         vLead8.RecordTypeId              = centralLead.Id;
         leadList.add(vlead8);
         
         Database.insert(leadList);
         
         TEMarketing__MQLRecord__c MQLRecord6 = ClsTestHelp2.getMQLRecord();
         MQLRecord6.Key_Customer_Cde__c = 'S';   
         MQLRecord6.TEMarketing__Lead__c =  leadList[0].id;     
         insert MQLRecord6; 
         
        /* Lead vlead9 = ClsTestHelp2.getLead(); 
         vlead9.Country                    = 'Germany';
         vlead9.Street                     = 'CA';
         vlead9.City                       = 'SS1';
         vlead9.State                      = 'EU';
         vlead9.Assignee_Network_Id__c     = 'Fail';
         vLead9.RecordTypeId              = centralLead.Id;
         insert vlead9;*/

     }
     
}