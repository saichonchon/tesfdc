/**
*  This test class is for ClsBatch_Accountupdate_saleshierarchy.
*
@author Anil Kumar Attelli (anil.attelli@zensar.in)
@created 2014-04-02
@version 1.0
@since 30.0 (Force.com ApiVersion)  
*
*/
/* changed the accounts name manually to control duplication
    2014-09-18 Harinath Chittala <harinath.chittala@te.com> */ 

//@isTest(seeAllData=True)
@isTest 
private class ClsBatch_Accountupdate_saleshierar_Test {


    static testMethod void testBatch() {
    
      Test.startTest();
      
      ID recordtype= [select Name from RecordType where SobjectType = 'Account' and DeveloperName = 'CIS_Account' limit 1].Id;
      
      System.debug('recordtype'+recordtype);      
      Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
      Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
      Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
      Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
      Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
      Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
      Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
      Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
      Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9(); 
      Apex_Helper_Settings__c ahs10 = ClsTestHelp.createTestName10();
      Apex_Helper_Settings__c ahs11 = ClsTestHelp.createTestName11();
      
      
      Consumer_Device_Opportunity_Record_Types__c csd1 = ClsTestHelp.createTestCSD1();
      Consumer_Device_Opportunity_Record_Types__c csd2 = ClsTestHelp.createTestCSD2();
      Consumer_Device_Opportunity_Record_Types__c csd3 = ClsTestHelp.createTestCSD3();
      Consumer_Device_Opportunity_Record_Types__c csd4 = ClsTestHelp.createTestCSD4();
      Consumer_Device_Opportunity_Record_Types__c csd5 = ClsTestHelp.createTestCSD5();
      Consumer_Device_Opportunity_Record_Types__c csd6 = ClsTestHelp.createTestCSD6();
      Consumer_Device_Opportunity_Record_Types__c csd7 = ClsTestHelp.createTestCSD7();     
                          
      Sales_Hierarchy__c sh1 = new Sales_Hierarchy__c();
      sh1.Level_7_Territory_Code__c = 'A003153';
      sh1.Level_7_Default_Owner__c = UserInfo.getuserId();
      sh1.Level_7_Assigned_User_Network_Ids__c = 'TE901311';
      sh1.Hierarchy_Type__c  = 'Account Manager Hierarchy (FE)';
      insert sh1;
      
      
       //* Added by Archana...code changes start
        List<Trigger_Configuration__c> lstTriggerConfig = new  List<Trigger_Configuration__c>();
       
        Trigger_Configuration__c tc = new Trigger_Configuration__c(); 
        tc.Name='Avoid Duplicate PLM Id';
        tc.isRun__c=true;
        lstTriggerConfig .add(tc);
               
        Trigger_Configuration__c tc2 = new Trigger_Configuration__c(); 
        tc2.Name='DND Lead Conversion Initialization';
        tc2.isRun__c=true;
        lstTriggerConfig .add(tc2);
        
        Trigger_Configuration__c tc3 = new Trigger_Configuration__c(); 
        tc3.Name='Identify Fiscal Year';
        tc3.isRun__c=true;
        lstTriggerConfig .add(tc3);
        
        Trigger_Configuration__c tc4 = new Trigger_Configuration__c(); 
        tc4.Name='Populate Opportunity Partner';
        tc4.isRun__c=true;
        lstTriggerConfig .add(tc4);
        
        Trigger_Configuration__c tc5 = new Trigger_Configuration__c(); 
        tc5.Name='updateAccountBusinessUnit';
        tc5.isRun__c=true;
        lstTriggerConfig .add(tc5);
        
        insert lstTriggerConfig ;
        
        ADMTerritoryCode__c admTerritoryCode= new ADMTerritoryCode__c();
        admTerritoryCode.Name='ADMTerritoryCode';
        admTerritoryCode.Territory_Code__c='101485';
        insert admTerritoryCode;
        
                //* Added by Archana...code changes end
       
      
        list<Account> list_accounts = new list<Account>();          
      
       //Account Records        
        Account acc = new Account();
        acc.Name = 'lha';
        acc.RecordTypeId =recordtype ;
        //acc.ownerId = UserInfo.getUserId();        
        //acc.Account_Manager__c = UserInfo.getUserId();        
        acc.BillingCountry = 'CN';
        acc.SALES_TERRITORY_CDE__c= '';
        acc.Sales_Hierarchy__c = sh1.id;
        acc.AccountNumber = '1082:00183217';
        //insert acc;
        list_accounts.add(acc);
        
        Account acc1 = new Account();
        acc1.Name = 'xyz';
        acc1.RecordtypeID=recordtype;
        //acc1.ownerId = UserInfo.getUserId(); 
        //acc1.Account_Manager__c = UserInfo.getUserId();
        acc1.BillingCountry = 'CN';
        //insert acc1;
        list_accounts.add(acc1);
        
        /*list<Account> list_accounts = new list<Account>();
        list_accounts.add(acc); 
       list_accounts.add(acc1); */
        
        insert list_accounts;
        
        Database.QueryLocator QL;
        Database.BatchableContext BC;
        
        
        ClsBatch_Accountupdate_saleshierarchy testBatch = new ClsBatch_Accountupdate_saleshierarchy();
        //ID batchprocessid = Database.executeBatch(testBatch,200);
        QL = testBatch.start(bc);
        testBatch.execute(BC, list_accounts);
        
        
        system.assert(true);
      Test.stopTest();
    }
    
    static testMethod void else_testBatch() {
    
      ID recordtype= [select Name from RecordType where SobjectType = 'Account' and DeveloperName = 'CIS_Account' limit 1].Id;
            
      Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
      Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
      Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
      Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
      Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
      Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
      Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
      Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
      Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9(); 
      Apex_Helper_Settings__c ahs10 = ClsTestHelp.createTestName10();
      Apex_Helper_Settings__c ahs11 = ClsTestHelp.createTestName11();
      
      
      Consumer_Device_Opportunity_Record_Types__c csd1 = ClsTestHelp.createTestCSD1();
      Consumer_Device_Opportunity_Record_Types__c csd2 = ClsTestHelp.createTestCSD2();
      Consumer_Device_Opportunity_Record_Types__c csd3 = ClsTestHelp.createTestCSD3();
      Consumer_Device_Opportunity_Record_Types__c csd4 = ClsTestHelp.createTestCSD4();
      Consumer_Device_Opportunity_Record_Types__c csd5 = ClsTestHelp.createTestCSD5();
      Consumer_Device_Opportunity_Record_Types__c csd6 = ClsTestHelp.createTestCSD6();
      Consumer_Device_Opportunity_Record_Types__c csd7 = ClsTestHelp.createTestCSD7();     
                          
      Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
      sh.Level_7_Territory_Code__c = 'A003153';
      sh.Level_7_Assigned_User_Network_Ids__c = 'TE901228';
      sh.Hierarchy_Type__c  = 'Sales Hierarchy (AM)';
      insert sh;
      
    Sales_Hierarchy__c sh1 = new Sales_Hierarchy__c();
      sh1.Level_7_Territory_Code__c = 'A003153';
      sh1.Level_7_Default_Owner__c = UserInfo.getuserId();
      sh1.Level_7_Assigned_User_Network_Ids__c = 'TE901311';
      sh1.Hierarchy_Type__c  = 'Account Manager Hierarchy (FE)';
      insert sh1;
      
      /*Sales_Hierarchy__c sh2 = new Sales_Hierarchy__c();
      sh2.Level_7_Territory_Code__c = 'A003154';
      sh2.Level_7_Default_Owner__c = UserInfo.getuserId();
      sh2.Level_7_Assigned_User_Network_Ids__c = 'TE901311';
      insert sh2;
      
      Sales_Hierarchy__c sh3 = new Sales_Hierarchy__c();
      sh3.Level_7_Territory_Code__c = 'A003155';
      sh3.Level_7_Default_Owner__c = UserInfo.getuserId();
      sh3.Level_7_Assigned_User_Network_Ids__c = 'TE901311';
      insert sh3;*/            
      
    list<Account> list_accounts = new list<Account>();
    
       //Account Records        
        Account acc = new Account();
        acc.Name = 'mtr';
        acc.RecordTypeId = [select Name from RecordType where SobjectType = 'Account' and DeveloperName = 'CIS_Global_Account' limit 1].Id;
        acc.ownerId = UserInfo.getUserId();        
        acc.Account_Manager__c = UserInfo.getUserId();
        acc.BillingCountry = 'CN';
        acc.GAMCD__c='12345';
        acc.SALES_TERRITORY_CDE__c= 'A003152';
        acc.Sales_Hierarchy__c = sh.id; 
        acc.AccountNumber = '1082:00183217';
        //insert acc;
        list_accounts.add(acc);
                
        Account acc1 = new Account();
        acc1.Name = 'lne';
        acc1.parentId = acc.id;
        acc1.RecordtypeID=recordtype;
        acc1.GAMCD__c = '54321';
        acc1.ownerId = UserInfo.getUserId(); 
        acc1.Account_Manager__c = UserInfo.getUserId();
        acc1.BillingCountry = 'CN';
        acc1.Relay_Specialist_Territory_Code__c ='TE4578';
        acc1.ACCTMGRCD__c ='TE4578';
        acc1.FE_Hierarchy__c = sh1.id;
        acc1.Relay_Hierarchy__c = sh.id;
        //insert acc1;
        list_accounts.add(acc1);
        
        Account acc2 = new Account();
        acc2.Name = 'Test1';
        acc2.RecordtypeID=recordtype;
        acc2.ownerId = UserInfo.getUserId(); 
        acc2.Account_Manager__c = UserInfo.getUserId();
        acc2.BillingCountry = 'CN';
        acc2.ACCTMGRCD__c ='TE45781';
        acc2.FE_Hierarchy__c = sh1.id;
        //insert acc2;
        list_accounts.add(acc2);
        
        /*list<Account> list_accounts = new list<Account>();
        list_accounts.add(acc); 
        list_accounts.add(acc1);
        list_accounts.add(acc2);*/
       
        Database.QueryLocator QL;
        Database.BatchableContext BC;
    
      Test.startTest();
        
        ClsBatch_Accountupdate_saleshierarchy testBatch = new ClsBatch_Accountupdate_saleshierarchy();
        //ID batchprocessid = Database.executeBatch(testBatch,200);
        QL = testBatch.start(bc);
        testBatch.execute(BC, list_accounts);
        
        
        system.assert(true);
      Test.stopTest();
    }
    
    static testMethod void test_Catchblocktest_Handler(){
       String test;
       Catchblocktest_Handler.sendemail('test');
    
    }
    
    static testMethod void test_ClsScheduler_Accountupdate_saleshierar(){
    
    
      Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
      Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
      Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
      Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
      Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
      Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
      Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
      Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
      Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9(); 
      Apex_Helper_Settings__c ahs10 = ClsTestHelp.createTestName10();
      Apex_Helper_Settings__c ahs11 = ClsTestHelp.createTestName11();
      
      
      Consumer_Device_Opportunity_Record_Types__c csd1 = ClsTestHelp.createTestCSD1();
      Consumer_Device_Opportunity_Record_Types__c csd2 = ClsTestHelp.createTestCSD2();
      Consumer_Device_Opportunity_Record_Types__c csd3 = ClsTestHelp.createTestCSD3();
      Consumer_Device_Opportunity_Record_Types__c csd4 = ClsTestHelp.createTestCSD4();
      Consumer_Device_Opportunity_Record_Types__c csd5 = ClsTestHelp.createTestCSD5();
      Consumer_Device_Opportunity_Record_Types__c csd6 = ClsTestHelp.createTestCSD6();
      Consumer_Device_Opportunity_Record_Types__c csd7 = ClsTestHelp.createTestCSD7();
        
        DateTime currTime = DateTime.now();
        Integer min = currTime.minute();
        Integer hour = currTime.hour();
        String sch;
        
        if(min <= 58)
            sch = '0 '+ (min + 1) + ' ' + hour + ' * * ? '+ currTime.year();
        else          
            sch = '0 0 '+ (hour + 1) + ' * * ? '+ currTime.year();
        
        Test.startTest();
        
        ClsScheduler_Accountupdate_saleshierar obj = new ClsScheduler_Accountupdate_saleshierar();                
        String jobId = system.schedule('test', sch, obj); 
        
        system.assert(true);
        Test.stopTest(); 
    }
    
}