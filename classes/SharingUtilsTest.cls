@isTest
private class SharingUtilsTest {

    static testMethod void myUnitTest1 () {
    
            Test.startTest();
            
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
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
        

         

        
        Opportunity_Record_Type_Groups__c a = new Opportunity_Record_Type_Groups__c();
        a.name= 'DND Opportunity';
        a.Active__c = true;
        a.RecordTypeID__c = '012c00000008oxY';
        insert a;
        RecordType rt8 = ClsTestHelp.createTestRecordType8();
        
       Profile p = [Select Id, Name From Profile 
                                    where Name = 'Production Support'
                                    or Name ='System Administrator' limit 1];
        Opportunity_Team_Default_Permission__c per = new Opportunity_Team_Default_Permission__c();
        per.Name = 'ProfileNotSendEmail';
        per.permission__c = 'Channel insight app;';
        insert per;
        
        List<User> uList = new List<User>();
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'helloSand0728@testCompany1407281004.com';
        u.FirstName ='Test0728';
        u.LastName = 'User0728';
        u.Alias = 'dpse0728';
        u.CommunityNickname = 'TMD0711';
        u.ProfileId = p.Id;
        u.GIBU__c = 'Appliances';
        u.Username = 'helloSand0728@testCompany1407281004.com';
        uList.add(u);
        
        User u1 = ClsTestHelp.createTestUsers();
        u1.Email = 'helloSand0728@testCompany1407281004.com';
        u1.FirstName ='Test0728';
        u1.LastName = 'User0728';
        u1.Alias = 'dpse012';
        u1.CommunityNickname = 'TMD071';
        u1.ProfileId = p.Id;
        u1.GIBU__c = 'Appliances';
        u1.Te_Network_Id__c = 'TE111111';
        u1.Username = 'helloSand01111@testCompany1407281004.com';
        uList.add(u1);
        
        User u2 = ClsTestHelp.createTestUsers();
        u2.Email = 'helloSand0728@testCompany1407281004.com';
        u2.FirstName ='Test07281';
        u2.LastName = 'User07281';
        u2.Alias = 'dpse44';
        u2.CommunityNickname = 'TMD04';
        u2.ProfileId = p.Id;
        u2.GIBU__c = 'Appliances';
        u2.Te_Network_Id__c = 'TE222222';
        u2.Username = 'helloSand02222@testCompany1407281004.com';
        uList.add(u2);
        insert uList;
        
        RecordType rt2 = ClsTestHelp.createTestRecordType10();
        RecordType rt = ClsTestHelp.createTestRecordType14();
        
        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
        sh.Level_2_Territory_Code__c = '103004';
        sh.Level_7_Default_Owner__c = u1.Id;
        sh.Level_7_Territory_Code__c = '123456';
        insert sh;
        
        List<Account> accList = new List<Account>();
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt.Id;
        acc.Type = 'Global Account';
        acc.Industry_Code_Description__c = 'Appliances';
        acc.LEVEL_1_INDUSTRY_CDE__c = '0283';
        acc.owner = u;
        acc.Account_Manager__c = u.Id;
        accList.add(acc); 
        
        Account acc1 = ClsTestHelp.createTestAccounts();
        acc1.RecordTypeId = rt.Id;
        acc1.Type = 'Global Account';
        acc1.Industry_Code_Description__c = 'Appliances';
        acc1.LEVEL_1_INDUSTRY_CDE__c = '0283';
        acc1.owner = u1;
        acc1.Account_Manager__c = u1.Id;
        accList.add(acc1); 
        
        insert accList;
       //
        SharingUtils.CreateAccountTeamMember(acc1.Id,u.Id,'Test');
        Set<String> teNetworkIdSet = new Set<String>();
        teNetworkIdSet.add('TE111111');
        teNetworkIdSet.add('TE222222');
        
        Set<Id> accSet = new Set<Id>();
        accSet.add(acc1.Id);
        
        List<User> userList = SharingUtils.GetSFUserIdNameByNetworkId(teNetworkIdSet);
        SharingUtils.GetSFUserByNetworkIdMap(userList);
        SharingUtils.CreateAccountShare(acc1.Id,u.Id);
        SharingUtils.CreateGlobalAccountShare(acc1.Id,u.Id);
        SharingUtils.CreateMarketShare(acc1.Id,u.Id);
        SharingUtils.GetSalesHierarchy('123456');
        SharingUtils.GetCFTMembersMap(accSet);
        SharingUtils.GetMarketTeamMembersMap(accSet);
        SharingUtils.GetAcctTeamMembersMap(accSet);
        
             
        Test.stopTest();
    }
    
        
        static testMethod void myUnitTest2 () {
    
            Test.startTest();
            
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
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
        
        Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;        
         

        
        Opportunity_Record_Type_Groups__c a = new Opportunity_Record_Type_Groups__c();
        a.name= 'DND Opportunity';
        a.Active__c = true;
        a.RecordTypeID__c = '012c00000008oxY';
        insert a;
        RecordType rt8 = ClsTestHelp.createTestRecordType8();
        
       Profile p = [Select Id, Name From Profile 
                                    where Name = 'Production Support'
                                    or Name ='System Administrator' limit 1];
        Opportunity_Team_Default_Permission__c per = new Opportunity_Team_Default_Permission__c();
        per.Name = 'ProfileNotSendEmail';
        per.permission__c = 'Channel insight app;';
        insert per;
        
        List<User> uList = new List<User>();
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'helloSand0728@testCompany1407281004.com';
        u.FirstName ='Test0728';
        u.LastName = 'User0728';
        u.Alias = 'dpse0728';
        u.CommunityNickname = 'TMD0711';
        u.ProfileId = p.Id;
        u.GIBU__c = 'Appliances';
        u.Username = 'helloSand0728@testCompany1407281004.com';
        uList.add(u);
        
        User u1 = ClsTestHelp.createTestUsers();
        u1.Email = 'helloSand0728@testCompany1407281004.com';
        u1.FirstName ='Test0728';
        u1.LastName = 'User0728';
        u1.Alias = 'dpse012';
        u1.CommunityNickname = 'TMD071';
        u1.ProfileId = p.Id;
        u1.GIBU__c = 'Appliances';
        u1.Te_Network_Id__c = 'TE111111';
        u1.Username = 'helloSand01111@testCompany1407281004.com';
        uList.add(u1);
        
        User u2 = ClsTestHelp.createTestUsers();
        u2.Email = 'helloSand0728@testCompany1407281004.com';
        u2.FirstName ='Test07281';
        u2.LastName = 'User07281';
        u2.Alias = 'dpse44';
        u2.CommunityNickname = 'TMD04';
        u2.ProfileId = p.Id;
        u2.GIBU__c = 'Appliances';
        u2.Te_Network_Id__c = 'TE222222';
        u2.Username = 'helloSand02222@testCompany1407281004.com';
        uList.add(u2);
        insert uList;
        
        RecordType rt2 = ClsTestHelp.createTestRecordType10();
        RecordType rt = ClsTestHelp.createTestRecordType14();
        
        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
        sh.Level_2_Territory_Code__c = '103004';
        sh.Level_7_Default_Owner__c = u1.Id;
        sh.Level_7_Territory_Code__c = '123456';
        insert sh;
        
        List<Account> accList = new List<Account>();
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt.Id;
        acc.Type = 'Global Account';
        acc.Industry_Code_Description__c = 'Appliances';
        acc.LEVEL_1_INDUSTRY_CDE__c = '0283';
        acc.owner = u;
        acc.Account_Manager__c = u.Id;
        accList.add(acc); 
      
        insert accList;
       /*
        SharingUtils.CreateAccountTeamMember(acc1.Id,u.Id,'Test');
        Set<String> teNetworkIdSet = new Set<String>();
        teNetworkIdSet.add('TE111111');
        teNetworkIdSet.add('TE222222');
        */
       
      
        
        Opportunity oppy = new Opportunity();
        oppy.StageName = 'New';
        oppy.AccountId = acc.Id;
        oppy.Account = acc;
        oppy.Name = 'SandKing';
        oppy.CloseDate = date.today();
        oppy.Manufacturing_Start_Date__c = date.today().addMonths(1);
        oppy.RecordTypeId = rt2.Id;            
        oppy.currency_confirm__c = true;
        oppy.Mass_prod_Status__c = true;
        oppy.owner = u; 
        insert oppy;
        
        
        
        SharingUtils.CreateOpptyTeamMember(oppy.Id,u.Id,'Partner SE');
        
        
           Test.stopTest();
    }
        static testMethod void myUnitTest3 () {
    
            Test.startTest();
            
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
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
        
        Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;        
         

        
        Opportunity_Record_Type_Groups__c a = new Opportunity_Record_Type_Groups__c();
        a.name= 'DND Opportunity';
        a.Active__c = true;
        a.RecordTypeID__c = '012c00000008oxY';
        insert a;
        RecordType rt8 = ClsTestHelp.createTestRecordType8();
        
       Profile p = [Select Id, Name From Profile 
                                    where Name = 'Production Support'
                                    or Name ='System Administrator' limit 1];
        Opportunity_Team_Default_Permission__c per = new Opportunity_Team_Default_Permission__c();
        per.Name = 'ProfileNotSendEmail';
        per.permission__c = 'Channel insight app;';
        insert per;
        
        List<User> uList = new List<User>();
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'helloSand0728@testCompany1407281004.com';
        u.FirstName ='Test0728';
        u.LastName = 'User0728';
        u.Alias = 'dpse0728';
        u.CommunityNickname = 'TMD0711';
        u.ProfileId = p.Id;
        u.GIBU__c = 'Appliances';
        u.Username = 'helloSand0728@testCompany1407281004.com';
        uList.add(u);
        
        User u1 = ClsTestHelp.createTestUsers();
        u1.Email = 'helloSand0728@testCompany1407281004.com';
        u1.FirstName ='Test0728';
        u1.LastName = 'User0728';
        u1.Alias = 'dpse012';
        u1.CommunityNickname = 'TMD071';
        u1.ProfileId = p.Id;
        u1.GIBU__c = 'Appliances';
        u1.Te_Network_Id__c = 'TE111111';
        u1.Username = 'helloSand01111@testCompany1407281004.com';
        uList.add(u1);
        
        User u2 = ClsTestHelp.createTestUsers();
        u2.Email = 'helloSand0728@testCompany1407281004.com';
        u2.FirstName ='Test07281';
        u2.LastName = 'User07281';
        u2.Alias = 'dpse44';
        u2.CommunityNickname = 'TMD04';
        u2.ProfileId = p.Id;
        u2.GIBU__c = 'Appliances';
        u2.Te_Network_Id__c = 'TE222222';
        u2.Username = 'helloSand02222@testCompany1407281004.com';
        uList.add(u2);
        insert uList;
        
        RecordType rt2 = ClsTestHelp.createTestRecordType10();
        RecordType rt = ClsTestHelp.createTestRecordType14();
        
        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
        sh.Level_2_Territory_Code__c = '103004';
        sh.Level_7_Default_Owner__c = u1.Id;
        sh.Level_7_Territory_Code__c = '123456';
        insert sh;
        
        List<Account> accList = new List<Account>();
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt.Id;
        acc.Type = 'Global Account';
        acc.Industry_Code_Description__c = 'Appliances';
        acc.LEVEL_1_INDUSTRY_CDE__c = '0283';
        acc.owner = u;
        acc.Account_Manager__c = u.Id;
        accList.add(acc); 
      
        insert accList;
       /*
        SharingUtils.CreateAccountTeamMember(acc1.Id,u.Id,'Test');
        Set<String> teNetworkIdSet = new Set<String>();
        teNetworkIdSet.add('TE111111');
        teNetworkIdSet.add('TE222222');
        
        Set<Id> accSet = new Set<Id>();
        accSet.add(acc1.Id);
        
      */
        
        Opportunity oppy = new Opportunity();
        oppy.StageName = 'New';
        oppy.AccountId = acc.Id;
        oppy.Account = acc;
        oppy.Name = 'SandKing';
        oppy.CloseDate = date.today();
        oppy.Manufacturing_Start_Date__c = date.today().addMonths(1);
        oppy.RecordTypeId = rt2.Id;            
        oppy.currency_confirm__c = true;
        oppy.Mass_prod_Status__c = true;
        oppy.owner = u; 
        insert oppy;
        
        
        
        SharingUtils.CreateOpportunityShare(oppy.Id,u.Id);
        
        
        Test.stopTest();
    }
        
       static testMethod void myUnitTest4 () {
    
            Test.startTest();
            
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
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
        
        
         

        
        Opportunity_Record_Type_Groups__c a = new Opportunity_Record_Type_Groups__c();
        a.name= 'DND Opportunity';
        a.Active__c = true;
        a.RecordTypeID__c = '012c00000008oxY';
        insert a;
        RecordType rt8 = ClsTestHelp.createTestRecordType8();
        
       Profile p = [Select Id, Name From Profile 
                                    where Name = 'Production Support'
                                    or Name ='System Administrator' limit 1];
        Opportunity_Team_Default_Permission__c per = new Opportunity_Team_Default_Permission__c();
        per.Name = 'ProfileNotSendEmail';
        per.permission__c = 'Channel insight app;';
        insert per;
        
        List<User> uList = new List<User>();
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'helloSand0728@testCompany1407281004.com';
        u.FirstName ='Test0728';
        u.LastName = 'User0728';
        u.Alias = 'dpse0728';
        u.CommunityNickname = 'TMD0711';
        u.ProfileId = p.Id;
        u.GIBU__c = 'Appliances';
        u.Username = 'helloSand0728@testCompany1407281004.com';
        uList.add(u);
        
        User u1 = ClsTestHelp.createTestUsers();
        u1.Email = 'helloSand0728@testCompany1407281004.com';
        u1.FirstName ='Test0728';
        u1.LastName = 'User0728';
        u1.Alias = 'dpse012';
        u1.CommunityNickname = 'TMD071';
        u1.ProfileId = p.Id;
        u1.GIBU__c = 'Appliances';
        u1.Te_Network_Id__c = 'TE111111';
        u1.Username = 'helloSand01111@testCompany1407281004.com';
        uList.add(u1);
        
        User u2 = ClsTestHelp.createTestUsers();
        u2.Email = 'helloSand0728@testCompany1407281004.com';
        u2.FirstName ='Test07281';
        u2.LastName = 'User07281';
        u2.Alias = 'dpse44';
        u2.CommunityNickname = 'TMD04';
        u2.ProfileId = p.Id;
        u2.GIBU__c = 'Appliances';
        u2.Te_Network_Id__c = 'TE222222';
        u2.Username = 'helloSand02222@testCompany1407281004.com';
        uList.add(u2);
        insert uList;
        
        RecordType rt2 = ClsTestHelp.createTestRecordType10();
        RecordType rt = ClsTestHelp.createTestRecordType14();
      /*  
        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
        sh.Level_2_Territory_Code__c = '103004';
        sh.Level_7_Default_Owner__c = u1.Id;
        sh.Level_7_Territory_Code__c = '123456';
        insert sh;
        */
        List<Account> accList = new List<Account>();
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt.Id;
        acc.Type = 'Global Account';
        acc.Industry_Code_Description__c = 'Appliances';
        acc.LEVEL_1_INDUSTRY_CDE__c = '0283';
        acc.owner = u;
        acc.Account_Manager__c = u.Id;
        accList.add(acc); 
      
        insert accList;
       /*
        
        Opportunity oppy = new Opportunity();
        oppy.StageName = 'New';
        oppy.AccountId = acc.Id;
        oppy.Account = acc;
        oppy.Name = 'SandKing';
        oppy.CloseDate = date.today();
        oppy.Manufacturing_Start_Date__c = date.today().addMonths(1);
        oppy.RecordTypeId = rt2.Id;            
        oppy.currency_confirm__c = true;
        oppy.Mass_prod_Status__c = true;
        oppy.owner = u; 
        insert oppy;
        
        
        Opportunity_Partner__c oppPartner = new Opportunity_Partner__c();
        oppPartner.Opportunity__c = oppy.Id;
        oppPartner.Account__c = acc.Id;
        oppPartner.Allocation__c = 0;
        oppPartner.Partner_Role__c = 'Distributor';
        insert oppPartner;
        
       
        Opportunity_Partner__c oppPartner1 = new Opportunity_Partner__c();
        oppPartner1.Opportunity__c = oppy.Id;
        oppPartner1.Account__c = acc.Id;
        oppPartner1.Allocation__c = 0;
        oppPartner1.Partner_Role__c = 'Distributor';
        insert oppPartner1;
        */
        acc.Account_Manager__c = u2.Id;
        update acc;
        Map<Id,Id> newMap = new Map<Id,Id>();
        newMap .put(acc.Id,u1.id);
        Map<Id,Id> oldMap = new Map<Id,Id>();
        newMap .put(acc.Id,u.id);
        SharingUtils.updateOppyTeamWhenAccountAMChanged(newMap ,oldMap );
       // delete oppPartner1;
       
        
        
        Test.stopTest();
    }
        static testMethod void myUnitTest5 () {
    
            Test.startTest();
            
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
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
        
        Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;        
         

        
        Opportunity_Record_Type_Groups__c a = new Opportunity_Record_Type_Groups__c();
        a.name= 'DND Opportunity';
        a.Active__c = true;
        a.RecordTypeID__c = '012c00000008oxY';
        insert a;
        RecordType rt8 = ClsTestHelp.createTestRecordType8();
        
       Profile p = [Select Id, Name From Profile 
                                    where Name = 'Production Support'
                                    or Name ='System Administrator' limit 1];
        Opportunity_Team_Default_Permission__c per = new Opportunity_Team_Default_Permission__c();
        per.Name = 'ProfileNotSendEmail';
        per.permission__c = 'Channel insight app;';
        insert per;
        
        List<User> uList = new List<User>();
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'helloSand0728@testCompany1407281004.com';
        u.FirstName ='Test0728';
        u.LastName = 'User0728';
        u.Alias = 'dpse0728';
        u.CommunityNickname = 'TMD0711';
        u.ProfileId = p.Id;
        u.GIBU__c = 'Appliances';
        u.Username = 'helloSand0728@testCompany1407281004.com';
        uList.add(u);
        
        User u1 = ClsTestHelp.createTestUsers();
        u1.Email = 'helloSand0728@testCompany1407281004.com';
        u1.FirstName ='Test0728';
        u1.LastName = 'User0728';
        u1.Alias = 'dpse012';
        u1.CommunityNickname = 'TMD071';
        u1.ProfileId = p.Id;
        u1.GIBU__c = 'Appliances';
        u1.Te_Network_Id__c = 'TE111111';
        u1.Username = 'helloSand01111@testCompany1407281004.com';
        uList.add(u1);
        
        User u2 = ClsTestHelp.createTestUsers();
        u2.Email = 'helloSand0728@testCompany1407281004.com';
        u2.FirstName ='Test07281';
        u2.LastName = 'User07281';
        u2.Alias = 'dpse44';
        u2.CommunityNickname = 'TMD04';
        u2.ProfileId = p.Id;
        u2.GIBU__c = 'Appliances';
        u2.Te_Network_Id__c = 'TE222222';
        u2.Username = 'helloSand02222@testCompany1407281004.com';
        uList.add(u2);
        insert uList;
        
        RecordType rt2 = ClsTestHelp.createTestRecordType10();
        RecordType rt = ClsTestHelp.createTestRecordType14();
      /*  
        Sales_Hierarchy__c sh = ClsTestHelp.createTestSalesHierarchy();
        sh.Level_2_Territory_Code__c = '103004';
        sh.Level_7_Default_Owner__c = u1.Id;
        sh.Level_7_Territory_Code__c = '123456';
        insert sh;
        */
        List<Account> accList = new List<Account>();
        Account acc = ClsTestHelp.createTestAccounts();
        acc.RecordTypeId = rt.Id;
        acc.Type = 'Global Account';
        acc.Industry_Code_Description__c = 'Appliances';
        acc.LEVEL_1_INDUSTRY_CDE__c = '0283';
        acc.owner = u;
        acc.Account_Manager__c = u.Id;
        accList.add(acc); 
      
        insert accList;
       
        
        Opportunity oppy = new Opportunity();
        oppy.StageName = 'New';
        oppy.AccountId = acc.Id;
        oppy.Account = acc;
        oppy.Name = 'SandKing';
        oppy.CloseDate = date.today();
        oppy.Manufacturing_Start_Date__c = date.today().addMonths(1);
        oppy.RecordTypeId = rt2.Id;            
        oppy.currency_confirm__c = true;
        oppy.Mass_prod_Status__c = true;
        oppy.owner = u; 
        insert oppy;
        
        
        Opportunity_Partner__c oppPartner = new Opportunity_Partner__c();
        oppPartner.Opportunity__c = oppy.Id;
        oppPartner.Account__c = acc.Id;
        oppPartner.Allocation__c = 0;
        oppPartner.Partner_Role__c = 'Distributor';
        insert oppPartner;
        
       
        Opportunity_Partner__c oppPartner1 = new Opportunity_Partner__c();
        oppPartner1.Opportunity__c = oppy.Id;
        oppPartner1.Account__c = acc.Id;
        oppPartner1.Allocation__c = 0;
        oppPartner1.Partner_Role__c = 'Distributor';
        insert oppPartner1;
        
       delete oppPartner1;
       
        
        
        Test.stopTest();
    }
        
 
 
}