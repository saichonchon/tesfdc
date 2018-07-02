/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class CPMTestFactory 
{
    // Test the Global Account Trigger
  private static id CreateGlobalAccount() 
  {
    // create a new global account
    Global_Account__c ga;
    ga = new Global_Account__c();
    ga.Description__c = 'Test Description';
    ga.Name = 'Test GA';
    ga.GAM_Name__c = 'GAM Name';
    insert ga;
    return ga.id;
  }
  
  private static id CreateMarket() 
  {
    // create a new global account
    Market__c mkt = new Market__c();
    mkt.Name = 'Test Market';
    mkt.Region__c = 'Mexico';
    insert mkt;
    return mkt.id;
  }  
  
  static testMethod void TestUserUpdate()
  {
    CreateTestUser();
  }
  
  private static User u;
  private static User CreateTestUser()
  {
    if (u != null)
      return u;
     
    u = new User();
    u.FirstName = 'John';
    u.LastName = 'Doe';
    u.Email = 'John.Doe@te.com';
    u.GIBU__c = 'Industrial';
    u.Username = 'john.doe@te.com.cis';
    u.Alias = 'JDAlias';
    u.CommunityNickname = 'JohnDoe';
    u.EmailEncodingKey='ISO-8859-1';
    u.TimeZoneSidKey = 'America/New_York';
    u.LanguageLocaleKey='en_US';
    u.ProfileId=GetStandardUserProfileId();
    u.LocaleSidKey='en_US';
    u.EmployeeNumber = 'US099999'; 
    u.TE_Network_Id__c = 'US099999';       
    insert u;
    return u;
  }
   
  private static id GetStandardUserProfileId()
  {
    List<Profile> pl = new List<Profile>([select id, name from profile where name='Channel Standard User']);
    if (pl.size() > 0)
     return pl[0].id;
    else
     return null;
  }
  private static Id CreateAccount(Id GlobalAcctId)
  {
    Account a;
    a = ClsTestHelp.createTestAccounts();
    a.Name = 'Test Account';
    a.AnnualRevenue         = 2000000.11; 
  a.Legally_Restricted__c = false;  
  
  a.BillingCity          = 'Shanghai';  
  a.BillingCountry       = 'China';
  a.BillingState         = '000000';
  a.BillingStreet        = 'Changning';
  a.BillingPostalCode    = '200051';
    a.Global_Account__c = GlobalAcctId;
    insert a;
    return a.id;
  }
  
  static testMethod void TestAccountUpdate()
  {
    
  // First create a Global Account
    Id gaId = CreateGlobalAccount();
    //CreateAccount(gaId);
  }
  
  private static Opportunity CreateTestOppty(Id acctId)
  {
    RecordType rt2 = ClsTestHelp.createTestRecordType9();
    Opportunity opp = new Opportunity();
    opp.Name = 'Test Oppty';
    opp.AccountId = acctId;
    opp.currency_confirm__c= true;
    opp.CloseDate = Date.today() + 365;
    opp.StageName = 'Approved/Active';
    opp.RecordTypeId = rt2.Id;
    
    insert opp;
    return opp;
  }
  
  static testMethod void TestOpptyUpdate()
  {
    //CreateTestOppty(CreateAccount(CreateGlobalAccount()));
   // CreateTestOppty(CreateAccount(null)); added by di chen 2012/6/4
  }
  
  static testMethod void TestContactUpdate()
  {
    Id acctId = CreateAccount(CreateGlobalAccount());
    Contact c;
    c = new Contact();
    c.FirstName = 'Test';
    c.LastName = 'Contact';
    c.AccountId = acctId;
    insert c;   

        /*List<Global_Account__c> gams = new List<Global_Account__c>();  

        for(integer i = 0; i<1000; i++)
        {  
            gams.add(new Global_Account__c(Name = 'test gam ' + i));  
        } 
        
        insert gams;

        List<Account> accts = new List<Account>(); 
    
        for(integer j = 0; j<1000; j++)
        {  
            accts.add(new Account(Name = 'test account ' + j, Global_Account__c = gams.get(j).Id));  
        }
        
        insert accts;  

        List<Contact> contacts = new List<Contact>();
        
        Test.startTest();
        
        for(integer x = 0; x<1000; x++)
        {
            contacts.add(new Contact(FirstName = 'Test', LastName = 'Contact ' + x, AccountId = accts.get(x).Id));              
        }
    
        insert contacts;
        
        Test.stopTest(); */
  }
  
  static testMethod void TestPartnerRoleUpdate()
  {
    Id OpptyID = CreateTestOppty(CreateAccount(CreateGlobalAccount())).id;
    Id AcctId;
    
    Account a;
    a = ClsTestHelp.createTestAccounts();
    User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    System.runAs ( thisUser ) 
    {
    
        a.Name = 'Second Test Account';
        a.OwnerId = CreateTestUser().Id;
        a.BillingCity            = 'Shanghai';  
        a.BillingCountry         = 'China';
        a.BillingState           = '000000';
        a.BillingStreet          = 'Changning';
        a.BillingPostalCode      = '200051';
        insert a;
        
        Partner_Role__c pr = new Partner_Role__c();
        pr.Account__c = a.id;
        pr.Opportunity__c = OpptyId;
        system.debug('**** inserting pr');
        insert pr;
    }
  }
  
  static testMethod void TestSalesHierarchyUpdate()
  { 
    CreateTestUser();
    System.runAs ( u ) 
    {
        Sales_Hierarchy__c sh;
        sh = new Sales_Hierarchy__c();
        sh.Level_7_Territory_Code__c = 'Test';
        sh.Level_7_Assigned_User_Network_Ids__c = 'US099999';
        sh.Level_6_Assigned_User_Network_Ids__c = 'US099999';
        sh.Level_5_Assigned_User_Network_Ids__c = 'US099999';
        sh.Level_4_Assigned_User_Network_Ids__c = 'US099999';
        sh.Level_3_Assigned_User_Network_Ids__c = 'US099999';
        sh.Level_2_Assigned_User_Network_Ids__c = 'US099999';
        sh.Level_1_Assigned_User_Network_Ids__c = 'US099999';
        insert sh;
    }
  }
/*  
  static testMethod void TestCFTMemberUpdate()
  {
    CreateTestUser();
    User thisUser = [ select Id, EmployeeNumber from User where Id = :UserInfo.getUserId() ];   
    System.runAs ( u ) 
    {           
        Account a = new Account();
        a.Name = 'Test Account';
        a.Global_Account__c = CreateGlobalAccount();
        a.AnnualRevenue         = 2000000.11; 
        a.Legally_Restricted__c = false;   
        a.BillingCity            = 'Shanghai';  
        a.BillingCountry         = 'China';
        a.BillingState           = '000000';
        a.BillingStreet          = 'Changning';
        a.BillingPostalCode  = '200051';
        a.OwnerId = u.Id;
        insert a;

        Customer_Focus_Team_Member__c newMember;
        newMember = new Customer_Focus_Team_Member__c();
        //newMember.Name = 'John Doe';
       // newMember.Global_Account__c = a.Global_Account__c;
        //newMember.TE_Network_User_Id__c = u.EmployeeNumber;
       // insert newMember;
        
        newMember.Salesforce_User_Name__c = thisUser.Id;
        update newMember;
        newMember.Role__c = 'Quality';
        update newMember;
        
        //test cft member transfer on switching global account on account (account trigger)
        Customer_Focus_Team_Member__c anotherMember = new Customer_Focus_Team_Member__c();
        anotherMember.Global_Account__c = CreateGlobalAccount();
        anotherMember.TE_Network_User_Id__c = u.EmployeeNumber;
        insert anotherMember;
        
        a.Global_Account__c = anotherMember.Global_Account__c;
        update a;
        
        delete newMember;       
    }
  }
  */
  static testMethod void TestSalesTeamUpdate()
  {
    CreateTestUser();
    //User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];  
        Profile p = [Select Id, Name From Profile 
                                    where Name ='System Administrator' 
                                    or Name ='Systemadministrator' limit 1];
        User u2 = ClsTestHelp.createTestUsers();
        u2.Email = 'Liodfen@testCompany999.com';
        u2.Alias = 'SsF';
        u2.ProfileId = p.Id;
        u2.CommunityNickname = 'QPS15';
        u2.IsActive = true;
        insert u2;     
    System.runAs ( u2 ) 
    {           
        Account a = ClsTestHelp.createTestAccounts();
        a.Name = 'Test Account';
        a.Channel_Market__c = CreateMarket();
        a.OwnerId = u2.Id;
        insert a;
        system.debug('***** - ' + a);

        Sales_Team__c newMember;
        newMember = new Sales_Team__c();
        //newMember.Name = 'John Doe';
        newMember.Market__c = a.Channel_Market__c;
        newMember.Team_Member__c = u2.Id;
        insert newMember;
        
        newMember.Team_Member__c = u2.Id;
        update newMember;
        newMember.Team_Role__c = 'Distribution Market Manager (DMM)';
        update newMember;
        
        //test sales team member transfer on markets on account on account (account trigger)
        Sales_Team__c anotherMember = new Sales_Team__c();
        anotherMember.Market__c = CreateMarket();
        anotherMember.Team_Member__c = u2.Id;
        insert anotherMember;
        
        a.Channel_Market__c = anotherMember.Market__c;
        update a;
        
        delete newMember;       
    }
  }  
  
  static testMethod void TestEmailSend()
  {
    List<string> pToAddresses = new List<string>();
    pToAddresses.add('rob.dress@te.com');
    List<string> pCcAddresses = new List<string>();
    pCcAddresses.add('rob.dress@te.com');
    List<string> pBccAddresses = new List<string>();
    pBccAddresses.add('rob.dress@te.com');
    //SalesforceUtils.SendEmail(pToAddresses, pCcAddresses, pBccAddresses, 'TEst Subject', 'Test SenderName', 'testReplyTo@te.com', 'This is a test email.');
    //SalesforceUtils.SendEmail('rob.dress@te.com', 'testsubject', 'testbody');   
  }
  
  static testMethod void TestMisc()
  {
    OrgWideSettings__c cfgObj= SalesforceUtils.OrgSettings;
  }
 
   private static id GetChannelOppRecTypeId()
  {
    List<RecordType> rt = new List<RecordType>([select id, name from recordtype where name='Channel_Opportunity']);
    if (rt.size() > 0)
     return rt[0].id;
    else
     return null;
  }   
}