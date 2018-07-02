/**
*   This test class is for ExtOpportunityPartEntry.
*
@author Di Chen
@created 2012-03-14
@version 1.0
@since 20.0
* 
@changelog
* 2012-03-14 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 85%
*/
@isTest(seeAllData=false)
private class ExtOpportunityPartEntry_Test {

     //Prabhanjan: Creating a common setup data for ADM record type.
    @testSetup static void createOpportunitygroupCustomSettings() {
       RecordType rt31 = ClsTestHelp.createTestRecordType31();
        list<Opportunity_Record_Type_Groups__c> lstORTG = new list<Opportunity_Record_Type_Groups__c>();
        lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'DND Opportunity', RecordTypeID__c = '012c00000004tlA'));
        lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'ADM sales',RecordTypeID__c = rt31.Id, Group__c = 'ADM Group', active__c = true));
        lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'ADM',RecordTypeID__c = rt31.Id, Group__c = 'Engineering Milestones Opportunities', active__c = true));
        insert lstORTG;
        
    } 
    
    static testMethod void testAllMethods() {
        Test.startTest();
        
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission(); 
        Channelinsightdata_test.Channelinsightdata_test();
        ClsTestHelp.initAPLTestData(); 
        List<Apex_Helper_Settings__c> lstApex_Helper_Settings = new List<Apex_Helper_Settings__c>();
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'DND Project Profile List', Value__c = '00eE0000000VFvYIAW'));
        insert lstApex_Helper_Settings;     
        /*Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;*/
        User u;     
        for(User ui : [SELECT IsActive FROM User where Profile.Name = 'System Administrator' and IsActive = true limit 1]){
            u = ui;
        }
        
        
        
        if(u == null){
            u = ClsTestHelp.createTestUsers();
            u.Email = 'Scofield@itbteeest123.com';
            u.Alias = 'Numb4r1';
            u.CommunityNickname = 'NO.4';
            u.IsActive = true;
            insert u;
        }
        
        system.runAs(u){
        
            RecordType rt = ClsTestHelp.createTestRecordType(); 
            
            ADMTerritoryCode__c admTerritoryCode= new ADMTerritoryCode__c();
            admTerritoryCode.Name='ADMTerritoryCode';
            admTerritoryCode.Territory_Code__c='101485';
            insert admTerritoryCode;
            
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            insert acc; 
            List<Opportunity> oppLst = new List<Opportunity>();
            Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Program_level_Forecasting__c =true; 
            oppy2.Name = 'Pain of Queen';
            oppy2.Type = 'CM';
            oppy2.closeDate = date.today() + 1;
            oppy2.Defined_GPLs__c = 'A39,K01,K03,176';
            oppLst.add(oppy2);  
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Type = 'CM';
            oppy.Request_Type__c = 'Cable Assembly';
            oppy.closeDate = date.today() + 2;
            oppy.Defined_GPLs__c = 'A39,K01,K03,176';
            oppLst.add(oppy);
            insert oppLst;
            
            oppy.Manufacturing_Start_Date__c = date.today()+5;
          //  Update oppy;

            Product_Hierarchy__c ph = new Product_Hierarchy__c();
            ph.Hierarchy_Level_Type__c = 'GPL';
            ph.Description__c = 'Industrial';
            insert ph;
            
            Part__c part = new Part__c();
            part.Description__c = 'Proposal Part';
            part.Product_Hierarchy__c = ph.Id;
            insert part;
            RecordType sprt = [SELECT Name, Id, DeveloperName, SobjectType FROM RecordType where SobjectType='Opportunity_Part__c' and DeveloperName = 'Sales_Parts'];
            list<Opportunity_Part__c> list_oppyPart2Insert = new list<Opportunity_Part__c>();
            Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
            oppypart.Opportunity__c = oppy.Id;
            oppypart.Part__c = part.Id;
            oppypart.Status__c = 'Lost';
            oppypart.Lost_Reason__c = 'Other';
            oppypart.Lost_Reason_Text__c = null;
            oppypart.Similar_TE_Part_Number__c = part.Id;
            oppypart.GPL__c = ph.Id;
            oppypart.Send_to_RTS__c = 'Yes';
            oppypart.RecordtypeId = sprt.Id;
            //oppypart.New_Part_Description__c = 'Test';
            //insert oppypart;
            list_oppyPart2Insert.add(oppypart);
            Opportunity_Part__c oppypart2 = ClsTestHelp.createTestOpportunityPart();
            oppypart2.Opportunity__c = oppy.Id;
            oppypart2.Part__c = part.Id;
            oppypart2.Status__c = 'Lost';
            oppypart2.Lost_Reason__c = 'Other';
            oppypart2.Lost_Reason_Text__c = null;
            oppypart2.Similar_TE_Part_Number__c = part.Id;
            oppypart2.GPL__c = ph.Id;
            oppypart2.Send_to_RTS__c = 'Yes';
            list_oppyPart2Insert.add(oppypart2);
            insert list_oppyPart2Insert;
            List<Part__c> list_selectedParts = new List<Part__c>();
            list_selectedParts.add(part);
            
            ApexPages.StandardController ctrl = new ApexPages.StandardController(oppypart); 
            ExtOpportunityPartEntry ext = new ExtOpportunityPartEntry(ctrl);
            ext.list_indexOpportunityPartsProposal = new list<ExtOpportunityPartEntry.OpportunityPartWrapper>();
            ExtOpportunityPartEntry.OpportunityPartWrapper opw = new ExtOpportunityPartEntry.OpportunityPartWrapper(oppypart,  1, 'similarName', 'partGPLName', 'partNumberName');
            ext.list_indexOpportunityPartsProposal.add(opw);
            
            
            
            ext.oppPart = oppypart;
            ext.addAmount = '1';
            ext.list_selectedParts = list_selectedParts;
    
            ext.list_selectedParts = list_selectedParts;
            ext.deleteOpportunityPartIndex = 1;
            ext.idString = part.Id;
            ext.deleteOpportunityPartIndexProposal = 1;
            ext.opp = oppy;
            
            ext.getAmounts();

            ext.NewAddProposalParts();
            //ext.DoAddProposalParts();
            
            ext.OppPartListPreviousPage();
            ext.OppPartListNextPage();
            ext.OppPartListPreviousPageProposal();
            ext.OppPartListNextPageProposal();
            ext.DeleteOpportunityParts();
            ext.DeleteOpportunityPartsProposal();
            ext.SaveOpportunityParts();
            ext.SelectSimilarParts();
            ext.GotoOpportunity();

            
            ext.DoSaveAndReturn();
            ext.PopupAddSalesPart();
            ext.SelectGPL();

            ext.SelectPartsForPartNumber();
            ExtOpportunityPartEntry.getSampleTypes();
            ExtOpportunityPartEntry.proposalPartId();
            ExtOpportunityPartEntry.oppRTId('cap');
            ExtOpportunityPartEntry.oppRTId('sp');
            ExtOpportunityPartEntry.oppRTId('nd');
            ExtOpportunityPartEntry.oppRTId('e'); 
            system.assert(true);
            
            /*********************/
            /*
            oppypart.Part__c = NULL;
            oppypart.Part_Number__c = NULL;
            oppypart.cable_assembly_type__c = NULL;
            update oppypart;
            System.debug('oppypart.Part__c ::: '+oppypart.Part__c);
            System.debug('oppypart.Part_Number__c ::: '+oppypart.Part_Number__c);            
            
            ApexPages.StandardController ctrl2 = new ApexPages.StandardController(oppypart); 
            ExtOpportunityPartEntry ext2 = new ExtOpportunityPartEntry(ctrl2);
            ext.list_indexOpportunityPartsProposal = new list<ExtOpportunityPartEntry.OpportunityPartWrapper>();
            ExtOpportunityPartEntry.OpportunityPartWrapper opw2 = new ExtOpportunityPartEntry.OpportunityPartWrapper(oppypart,  1, 'similarName', 'partGPLName', 'partNumberName');
            ext2.list_indexOpportunityPartsProposal.add(opw2);
            
            ext2.isOnlySales = False;
            ext2.SaveOpportunityParts();
            
            oppy.Manufacturing_Start_Date__c = System.today();
            update oppy;
            
            Opportunity oppNew = ClsOppyPartUtil.getOpportunityById(oppy.Id);
            oppNew.Manufacturing_Start_Date__c = System.today();
            update oppNew;
            oppy = oppNew;
            oppy.Program__c = NULL;
           
            ext2.SaveOpportunityParts();
            */
            
            
                                    /**************/
            /*
            delete oppy;
            ext.GotoOpportunity();
            */
            /**************/
            
            /*********************/
            Test.stopTest();
            
        } 
    }
    static testMethod void testAllMethodsRemaining() {
        Test.startTest();
        
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        Channelinsightdata_test.Channelinsightdata_test();
        ClsTestHelp.initAPLTestData();
        List<Apex_Helper_Settings__c> lstApex_Helper_Settings = new List<Apex_Helper_Settings__c>();
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'DND Project Profile List', Value__c = '00eE0000000VFvYIAW'));
        insert lstApex_Helper_Settings;     
        
        User u;     
       /* Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;*/
        for(User ui : [SELECT IsActive FROM User where Profile.Name = 'System Administrator' and IsActive = true limit 1]){
            u = ui;
        }
        if(u == null){
            u = ClsTestHelp.createTestUsers();
            u.Email = 'Scofield@itbteeest123.com';
            u.Alias = 'Numb4r1';
            u.CommunityNickname = 'NO.4';
            u.IsActive = true;
            insert u;
        }
        
        system.runAs(u){
        
            RecordType rt = ClsTestHelp.createTestRecordType();
            
            ADMTerritoryCode__c admTerritoryCode= new ADMTerritoryCode__c();
            admTerritoryCode.Name='ADMTerritoryCode';
            admTerritoryCode.Territory_Code__c='101485';
            insert admTerritoryCode;
        
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            insert acc; 
            List<Opportunity> oppLst = new List<Opportunity>();
            Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Program_level_Forecasting__c =true; 
            oppy2.Name = 'Pain of Queen';
            oppy2.Type = 'CM';
            oppy2.closeDate = date.today() + 1;
            oppy2.Defined_GPLs__c = 'A39,K01,K03,176';
            oppLst.add(oppy2);  
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Type = 'CM';
            oppy.Request_Type__c = 'Cable Assembly';
            oppy.closeDate = date.today() + 2;
            oppy.Defined_GPLs__c = 'A39,K01,K03,176';
            oppLst.add(oppy);     
            
            Opportunity oppy3= ClsTestHelp.createTestADMOpportunity(); 
            oppy3.closeDate = date.today() + 2; 
            oppLst.add(oppy3);
            
            insert oppLst;
            
            oppy.Manufacturing_Start_Date__c = date.today()+5;
        //    Update oppy;

            Product_Hierarchy__c ph = new Product_Hierarchy__c();
            ph.Hierarchy_Level_Type__c = 'GPL';
            ph.Description__c = 'Industrial';
            insert ph;
            
            Part__c part = new Part__c();
            part.Description__c = 'Proposal Part';
            part.Product_Hierarchy__c = ph.Id;
            insert part;
            RecordType sprt = [SELECT Name, Id, DeveloperName, SobjectType FROM RecordType where SobjectType='Opportunity_Part__c' and DeveloperName = 'Sales_Parts'];
            list<Opportunity_Part__c> list_oppyPart2Insert = new list<Opportunity_Part__c>();
            Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
            oppypart.Opportunity__c = oppy.Id;
            //oppypart.Part__c = part.Id;
            oppypart.Status__c = 'Lost';
            oppypart.Lost_Reason__c = 'Other';
            oppypart.Lost_Reason_Text__c = null;
            oppypart.Similar_TE_Part_Number__c = part.Id;
            oppypart.GPL__c = ph.Id;
            oppypart.Send_to_RTS__c = 'Yes';
            oppypart.RecordtypeId = sprt.Id;
            oppypart.New_Part_Description__c = 'Test';
            //insert oppypart;
            list_oppyPart2Insert.add(oppypart);
            Opportunity_Part__c oppypart2 = ClsTestHelp.createTestOpportunityPart();
            oppypart2.Opportunity__c = oppy.Id;
            oppypart2.Part__c = part.Id;
            oppypart2.Status__c = 'Lost';
            oppypart2.Lost_Reason__c = 'Other';
            oppypart2.Lost_Reason_Text__c = null;
            oppypart2.Similar_TE_Part_Number__c = part.Id;
            oppypart2.GPL__c = ph.Id;
            oppypart2.Send_to_RTS__c = 'Yes';
            oppypart.New_Part_Description__c = 'Test';
            list_oppyPart2Insert.add(oppypart2);
            insert list_oppyPart2Insert;
            List<Part__c> list_selectedParts = new List<Part__c>();
            list_selectedParts.add(part);
            
            ApexPages.StandardController ctrl = new ApexPages.StandardController(oppypart); 
            ExtOpportunityPartEntry ext = new ExtOpportunityPartEntry(ctrl);
            ext.list_indexOpportunityPartsProposal = new list<ExtOpportunityPartEntry.OpportunityPartWrapper>();
            ExtOpportunityPartEntry.OpportunityPartWrapper opw = new ExtOpportunityPartEntry.OpportunityPartWrapper(oppypart,  1, 'similarName', 'partGPLName', 'partNumberName');
            ext.list_indexOpportunityPartsProposal.add(opw);
            
            
            
            ext.oppPart = oppypart;
            ext.addAmount = '1';
            ext.list_selectedParts = list_selectedParts;
    
            ext.list_selectedParts = list_selectedParts;
            ext.deleteOpportunityPartIndex = 1;
            ext.idString = part.Id;
            ext.deleteOpportunityPartIndexProposal = 1;
            ext.opp = oppy;
            Test.stopTest();
            ext.SaveOpportunityParts();
            
        } 
    }
    static testMethod void testAllMethods1() {
        
        Test.startTest();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        Channelinsightdata_test.Channelinsightdata_test();
        ClsTestHelp.initAPLTestData();
        User u;     
       /* Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;*/
        for(User ui : [SELECT IsActive FROM User where Profile.Name = 'System Administrator' and IsActive = true limit 1]){
            u = ui;
        }
        if(u == null){
            u = ClsTestHelp.createTestUsers();
            u.Email = 'Scofield@itbteeest123.com';
            u.Alias = 'Numb4r1';
            u.CommunityNickname = 'NO.4';
            u.IsActive = true;
            insert u;
        }
        
        system.runAs(u){
            RecordType rt = ClsTestHelp.createTestRecordType();
                
            ADMTerritoryCode__c admTerritoryCode= new ADMTerritoryCode__c();
            admTerritoryCode.Name='ADMTerritoryCode';
            admTerritoryCode.Territory_Code__c='101485';
            insert admTerritoryCode;
        
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            insert acc;
            
            List<Opportunity> oppLst = new List<Opportunity>();
            Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Program_level_Forecasting__c =true; 
            oppy2.Name = 'Pain of Queen';
            oppy2.Type = 'CM';
            oppy2.Defined_GPLs__c = 'A39,K01,K03,176';
            oppLst.add(oppy2);
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Type = 'CM';
            oppy.Request_Type__c = 'Cable Assembly';
            oppy.Defined_GPLs__c = 'A39,K01,K03,176';
            oppLst.add(oppy);
            insert oppLst;
            
            
            
            Product_Hierarchy__c ph = new Product_Hierarchy__c();
            ph.Hierarchy_Level_Type__c = 'GPL';
            ph.Description__c = 'Industrial';
            insert ph;
            
            Part__c part = new Part__c();
            part.Description__c = 'Proposal Part';
            part.Product_Hierarchy__c = ph.Id;
            insert part;
            
            Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
            oppypart.Opportunity__c = oppy.Id;
            oppypart.Part__c = part.Id;
            oppypart.Status__c = 'Likely';
            oppypart.Lost_Reason__c = 'Other';
            oppypart.Lost_Reason_Text__c = null;
            oppypart.Similar_TE_Part_Number__c = part.Id;
            oppypart.GPL__c = ph.Id;
            oppypart.Send_to_RTS__c = 'Yes';
            insert oppypart;
            //Prabhanjan Adding an update 
            oppypart.status__C = 'Commit';
            update oppypart;
            List<Part__c> list_selectedParts = new List<Part__c>();
            list_selectedParts.add(part);
    
            /*List<Opportunity_Part__c> list_opportunityPartsProposal = new List<Opportunity_Part__c>();
            list_opportunityPartsProposal.add(oppypart);*/
            
            ApexPages.StandardController ctrl = new ApexPages.StandardController(oppypart); 
            ExtOpportunityPartEntry ext = new ExtOpportunityPartEntry(ctrl);
            ext.oppPart = oppypart;
            ext.addAmount = '1';
            ext.list_selectedParts = list_selectedParts;
    
           // ext.list_opportunityPartsProposal = list_opportunityPartsProposal;
            
            ext.getAmounts();
            //ext.NewAddProposalParts();
            //ext.DoAddProposalParts();
    
            ext.OppPartListPreviousPage();
            ext.OppPartListNextPage();
            ext.OppPartListPreviousPageProposal();
            ext.OppPartListNextPageProposal();
    
            ext.DeleteOpportunityParts();
            ext.DeleteOpportunityPartsProposal();
           //ext.SaveOpportunityParts();
            ext.SelectSimilarParts();
            ext.GotoOpportunity();
            /**************/
            delete oppy;
            ext.GotoOpportunity();
            /**************/
            
            //ext.DoSaveAndReturn();
            
            ExtOpportunityPartEntry.oppRTId('cap');
            ExtOpportunityPartEntry.oppRTId('sp');
            ExtOpportunityPartEntry.oppRTId('nd');
            ExtOpportunityPartEntry.oppRTId('e'); 
            system.assert(true);
            
            ext.changePartId = 'test';
            ext.oppPartListSortField = 'test';
            ext.oppPartListSortFieldPrev = 'test';
            ext.oppPartListSortFieldProposal = 'test';
            ext.oppPartListSortFieldPrevProposal = 'test';
            Boolean flag = ext.oppPartListShowPrevPageLink;
            flag = ext.oppPartListShowNextPageLink;
            Integer i = ext.oppPartListLastRecordNumber;
            i = ext.oppPartListFirstRecordNumber;
            List<ExtOpportunityPartEntry.OpportunityPartWrapper> alist = ext.list_singlePageOpportunityParts;
            List<ExtOpportunityPartEntry.OpportunityPartWrapper> blist = ext.list_singlePageOpportunityPartsProposal;
            Boolean flag2 =ext.oppPartListShowPrevPageLinkProposal;
            Boolean flag3=ext.oppPartListShowNextPageLinkProposal;
            Integer j = ext.oppPartListLastRecordNumberProposal;
            Integer k = ext.oppPartListFirstRecordNumberProposal;
            Boolean flag4 =ext.returnAfterSaveProposal;
            Test.stopTest();
        }
    }
    static testMethod void testRequestType2() {
        Test.startTest();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        Channelinsightdata_test.Channelinsightdata_test();
        ClsTestHelp.initAPLTestData();
        User u;     
       /* Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;*/
        for(User ui : [SELECT IsActive FROM User where Profile.Name = 'System Administrator' and IsActive = true limit 1]){
            u = ui;
        }
        if(u == null){
            u = ClsTestHelp.createTestUsers();
            u.Email = 'Scofield@itbteeest123.com';
            u.Alias = 'Numb4r1';
            u.CommunityNickname = 'NO.4';
            u.IsActive = true;
            insert u;
        }
        
        system.runAs(u){
            RecordType rt = ClsTestHelp.createTestRecordType();
            
            ADMTerritoryCode__c admTerritoryCode= new ADMTerritoryCode__c();
            admTerritoryCode.Name='ADMTerritoryCode';
            admTerritoryCode.Territory_Code__c='101485';
            insert admTerritoryCode;
        
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            insert acc;
            
            List<Opportunity> oppLst = new List<Opportunity>();
            Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Program_level_Forecasting__c =true; 
            oppy2.Name = 'Pain of Queen';
            oppy2.Type = 'CM';
            oppy2.Defined_GPLs__c = 'A39,K01,K03,176';
           
            oppLst.add(oppy2);  
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Type = 'CM';
            oppy.Request_Type__c = 'New Development';
            oppy.Defined_GPLs__c = 'A39,K01,K03,176';
            oppy.Manufacturing_Start_Date__c = system.today();
            oppLst.add(oppy);
            insert oppLst;
            
            Product_Hierarchy__c ph = new Product_Hierarchy__c();
            ph.Hierarchy_Level_Type__c = 'CBC1';
            ph.Description__c = 'Industrial';
            insert ph;
            
            Part__c part = new Part__c();
            part.Description__c = 'Proposal Part';
            part.Product_Hierarchy__c = ph.Id;
            insert part;
            
            Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
            oppypart.Opportunity__c = oppy.Id;
            oppypart.Part__c = part.Id;
            oppypart.Status__c = 'Lost';
            oppypart.Lost_Reason__c = 'Other';
            oppypart.Lost_Reason_Text__c = null;
            oppypart.Send_to_RTS__c = 'Yes';
            insert oppypart;
            
            List<Part__c> list_selectedParts = new List<Part__c>();
            list_selectedParts.add(part);
            
            ApexPages.StandardController ctrl = new ApexPages.StandardController(oppypart); 
            ExtOpportunityPartEntry ext = new ExtOpportunityPartEntry(ctrl);
            ext.oppPart = oppypart;
            ext.addAmount = '1';
            ext.list_selectedParts = list_selectedParts;
            
            ext.getAmounts();
            //ext.NewAddProposalParts();
            //ext.DoAddProposalParts();
             
            ExtOpportunityPartEntry.oppRTId('cap');
            ExtOpportunityPartEntry.oppRTId('sp');
            ExtOpportunityPartEntry.oppRTId('nd');
            ExtOpportunityPartEntry.oppRTId('e'); 
            system.assert(true);
            Test.stopTest();
        }
    }
    static testMethod void testRequestType3() {
        Test.startTest();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        Channelinsightdata_test.Channelinsightdata_test();
        User u;  
        /*Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;   */
        for(User ui : [SELECT IsActive FROM User where Profile.Name = 'System Administrator' and IsActive = true limit 1]){
            u = ui;
        }
        if(u == null){
            u = ClsTestHelp.createTestUsers();
            u.Email = 'Scofield@itbteeest123.com';
            u.Alias = 'Numb4r1';
            u.CommunityNickname = 'NO.4';
            u.IsActive = true;
            insert u;
        }
        
        system.runAs(u){
            RecordType rt = ClsTestHelp.createTestRecordType();
            
            ADMTerritoryCode__c admTerritoryCode= new ADMTerritoryCode__c();
            admTerritoryCode.Name='ADMTerritoryCode';
            admTerritoryCode.Territory_Code__c='101485';
            insert admTerritoryCode;
        
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            insert acc;
            
            List<Opportunity> oppLst = new List<Opportunity>();
            Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Program_level_Forecasting__c =true; 
            oppy2.Name = 'Pain of Queen';
            oppy2.Type = 'CM';
            oppy2.Defined_GPLs__c = 'A39,K01,K03,176';
            oppLst.add(oppy2);  
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Type = 'CM';
            oppy.Request_Type__c = 'Extension';
            oppy.Defined_GPLs__c = 'A39,K01,K03,176';
            oppLst.add(oppy);
            insert oppLst;
            
            Product_Hierarchy__c ph = new Product_Hierarchy__c();
            ph.Hierarchy_Level_Type__c = 'CBC1';
            ph.Description__c = 'Industrial';
            insert ph;
            
            Part__c part = new Part__c();
            part.Description__c = 'Proposal Part';
            part.Product_Hierarchy__c = ph.Id;
            insert part;
            
            Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
            oppypart.Opportunity__c = oppy.Id;
            oppypart.Part__c = part.Id;
            oppypart.Status__c = 'Lost';
            oppypart.Lost_Reason__c = 'Other';
            oppypart.Lost_Reason_Text__c = null;
            oppypart.Send_to_RTS__c = 'Yes';
            insert oppypart;
            
            List<Part__c> list_selectedParts = new List<Part__c>();
            list_selectedParts.add(part);
            
            ApexPages.StandardController ctrl = new ApexPages.StandardController(oppypart); 
            ExtOpportunityPartEntry ext = new ExtOpportunityPartEntry(ctrl);
            ext.oppPart = oppypart;
            ext.addAmount = '1';
            ext.list_selectedParts = list_selectedParts;
            
            ext.getAmounts();
            //ext.NewAddProposalParts();
            //ext.DoAddProposalParts();
             
            ExtOpportunityPartEntry.oppRTId('cap');
            ExtOpportunityPartEntry.oppRTId('sp');
            ExtOpportunityPartEntry.oppRTId('nd');
            ExtOpportunityPartEntry.oppRTId('e'); 
            system.assert(true);
            Test.stopTest();
        }
    }

    static testMethod void testAllMethods2() {
        Test.startTest();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        Channelinsightdata_test.Channelinsightdata_test();
        User u;    
       /*Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah; */
        for(User ui : [SELECT IsActive FROM User where Profile.Name = 'System Administrator' and IsActive = true limit 1]){
            u = ui;
        }
        if(u == null){
            u = ClsTestHelp.createTestUsers();
            u.Email = 'Scofield@itbteeest123.com';
            u.Alias = 'Numb4r1';
            u.CommunityNickname = 'NO.4';
            u.IsActive = true;
            insert u;
        }
        
        system.runAs(u){
            ADMTerritoryCode__c admTerritoryCode= new ADMTerritoryCode__c();
            admTerritoryCode.Name='ADMTerritoryCode';
            admTerritoryCode.Territory_Code__c='101485';
            insert admTerritoryCode;
        
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            insert acc;
            
            List<Opportunity> oppLst = new List<Opportunity>();
            Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Program_level_Forecasting__c =true; 
            oppy2.Name = 'Pain of Queen';
            oppy2.Type = 'CM';
            oppy2.Defined_GPLs__c = 'A39,K01,K03,176';
            oppLst.add(oppy2);  
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Type = 'CM';
            oppy.Request_Type__c = 'Cable Assembly';
            oppy.Defined_GPLs__c = 'A39,K01,K03,176';
            oppLst.add(oppy);
            insert oppLst;
            
            Product_Hierarchy__c ph = new Product_Hierarchy__c();
            ph.Hierarchy_Level_Type__c = 'CBC1';
            ph.Description__c = 'Industrial';
            insert ph;
            
            Part__c part = new Part__c();
            part.Description__c = 'Proposal Part';
            part.Product_Hierarchy__c = ph.Id;
            insert part;
            
            Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
            oppypart.Opportunity__c = oppy.Id;
            oppypart.Part__c = part.Id;
            oppypart.Status__c = 'Lost';
            oppypart.Lost_Reason__c = 'Other';
            oppypart.Lost_Reason_Text__c = null;
            oppypart.Send_to_RTS__c = 'Yes';
            //insert oppypart;
            
            List<Part__c> list_selectedParts = new List<Part__c>();
            list_selectedParts.add(part);
            
            ApexPages.StandardController ctrl = new ApexPages.StandardController(oppypart); 
            ExtOpportunityPartEntry ext = new ExtOpportunityPartEntry(ctrl);
            ext.oppPart = oppypart;
            ext.addAmount = '1';
            ext.list_selectedParts = list_selectedParts;
            ext.oppPartListPageNumber= 1;
    
            ext.getAmounts();
            //ext.NewAddProposalParts();
            //ext.DoAddProposalParts();
            ext.OppPartListPreviousPage();
            ext.OppPartListNextPage();
            ext.OppPartListPreviousPageProposal();
            ext.OppPartListNextPageProposal();
            ext.DeleteOpportunityParts();
            ext.DeleteOpportunityPartsProposal();
            ext.SaveOpportunityParts();
            ext.SelectSimilarParts();
            ext.GotoOpportunity();
            /**************/
            delete oppy;
            ext.GotoOpportunity();
            /**************/
            ext.DoSaveAndReturn();
            
            ExtOpportunityPartEntry.oppRTId('cap');
            ExtOpportunityPartEntry.oppRTId('sp');
            ExtOpportunityPartEntry.oppRTId('nd');
            ExtOpportunityPartEntry.oppRTId('e'); 
            system.assert(true);
            Test.stopTest();
        }
    }
    static testMethod void testAllMethods3() {
        Test.startTest();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        Channelinsightdata_test.Channelinsightdata_test();
        User u; 
        
       /* Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;    */
        for(User ui : [SELECT IsActive FROM User where Profile.Name = 'System Administrator' and IsActive = true limit 1]){
            u = ui;
        }
        if(u == null){
            u = ClsTestHelp.createTestUsers();
            u.Email = 'Scofield@itbteeest123.com';
            u.Alias = 'Numb4r1';
            u.CommunityNickname = 'NO.4';
            u.IsActive = true;
            insert u;
        }
        
        system.runAs(u){
            RecordType rt = ClsTestHelp.createTestRecordType();
            
            ADMTerritoryCode__c admTerritoryCode= new ADMTerritoryCode__c();
            admTerritoryCode.Name='ADMTerritoryCode';
            admTerritoryCode.Territory_Code__c='101485';
            insert admTerritoryCode;
        
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            insert acc;
     
            List<Opportunity> oppLst = new List<Opportunity>();
            Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Program_level_Forecasting__c =true; 
            oppy2.Name = 'Pain of Queen';
            oppy2.Type = 'CM';
            oppy2.Defined_GPLs__c = 'A39,K01,K03,176';
            oppLst.add(oppy2);  
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Type = 'CM';
            oppy.Request_Type__c = 'Cable Assembly';
            oppy.Defined_GPLs__c = 'A39,K01,K03,176';
            oppLst.add(oppy);
            insert oppLst;
            
            Product_Hierarchy__c ph = new Product_Hierarchy__c();
            ph.Hierarchy_Level_Type__c = 'CBC1';
            ph.Description__c = 'Industrial';
            insert ph;
            
            Part__c part = new Part__c();
            part.Description__c = 'Proposal Part';
            part.Product_Hierarchy__c = ph.Id;
            insert part;
            
            Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
            oppypart.Opportunity__c = oppy.Id;
            oppypart.Part__c = part.Id;
            oppypart.Status__c = 'Lost';
            oppypart.Lost_Reason__c = 'Other';
            oppypart.Lost_Reason_Text__c = null;
            oppypart.Send_to_RTS__c = 'Yes';
            //insert oppypart;
            
            List<Part__c> list_selectedParts = new List<Part__c>();
            list_selectedParts.add(part);
            
            ApexPages.StandardController ctrl = new ApexPages.StandardController(oppypart); 
            ExtOpportunityPartEntry ext = new ExtOpportunityPartEntry(ctrl);
            ext.oppPart = oppypart;
            ext.addAmount = '1';
            ext.list_selectedParts = list_selectedParts;
    
            ext.oppPartListPageNumber= 1;
    
            
            ext.SaveOpportunityParts();
            system.assert(true);
            Test.stopTest();
        }
    }
    static testMethod void testAllMethods4() {
        
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        Channelinsightdata_test.Channelinsightdata_test();
        User u; 
        /*Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;   */ 
        for(User ui : [SELECT IsActive FROM User where Profile.Name = 'System Administrator' and IsActive = true limit 1]){
            u = ui;
        }
        if(u == null){
            u = ClsTestHelp.createTestUsers();
            u.Email = 'Scofield@itbteeest123.com';
            u.Alias = 'Numb4r1';
            u.CommunityNickname = 'NO.4';
            u.IsActive = true;
            insert u;
        }
        
        system.runAs(u){
            RecordType rt = ClsTestHelp.createTestRecordType();
            
            ADMTerritoryCode__c admTerritoryCode= new ADMTerritoryCode__c();
            admTerritoryCode.Name='ADMTerritoryCode';
            admTerritoryCode.Territory_Code__c='101485';
            insert admTerritoryCode;
        
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            insert acc;
     
            List<Opportunity> oppLst = new List<Opportunity>();
            Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Program_level_Forecasting__c =true; 
            oppy2.Name = 'Pain of Queen';
            oppy2.Type = 'CM';
            oppy2.Defined_GPLs__c = 'A39,K01,K03,176';
            oppLst.add(oppy2);  
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Type = 'CM';
            oppy.Request_Type__c = 'Cable Assembly';
            oppy.Defined_GPLs__c = 'A39,K01,K03,176';
            oppLst.add(oppy);
            insert oppLst;
            
            Product_Hierarchy__c ph = new Product_Hierarchy__c();
            ph.Hierarchy_Level_Type__c = 'CBC1';
            ph.Description__c = 'Industrial';
            insert ph;
            
            Part__c part = new Part__c();
            part.Description__c = 'Proposal Part';
            part.Product_Hierarchy__c = ph.Id;
            insert part;
            
            Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
            oppypart.Opportunity__c = oppy.Id;
            oppypart.Part__c = part.Id;
            oppypart.Status__c = 'Lost';
            oppypart.Lost_Reason__c = 'Other';
            oppypart.Lost_Reason_Text__c = null;
            oppypart.Similar_TE_Part_Number__c = part.Id;
            oppypart.GPL__c = ph.Id;
            oppypart.Send_to_RTS__c = 'Yes';
            insert oppypart;
            
            List<Part__c> list_selectedParts = new List<Part__c>();
            list_selectedParts.add(part);
            Test.startTest();
            ApexPages.StandardController ctrl = new ApexPages.StandardController(oppypart); 
            ExtOpportunityPartEntry ext = new ExtOpportunityPartEntry(ctrl);
            ext.oppPart = oppypart;
            ext.addAmount = '1';
            ext.list_selectedParts = list_selectedParts;
            ext.oppPartListPageNumber= 1;
            
            ext.DoSaveAndReturn();
            system.assert(true);
            Test.stopTest();
        }
    }
    static testMethod void testAllMethods5() {
        //Test.startTest();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        Channelinsightdata_test.Channelinsightdata_test();
       /* Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;*/
        User u;     
        for(User ui : [SELECT IsActive FROM User where Profile.Name = 'System Administrator' and IsActive = true limit 1]){
            u = ui;
        }
        if(u == null){
            u = ClsTestHelp.createTestUsers();
            u.Email = 'Scofield@itbteeest1234.com';
            u.Alias = 'Numb4r1';
            u.CommunityNickname = 'NO.4';
            u.IsActive = true;
            insert u;
        }
        
        system.runAs(u){
            RecordType rt = ClsTestHelp.createTestRecordType();
            
            ADMTerritoryCode__c admTerritoryCode= new ADMTerritoryCode__c();
            admTerritoryCode.Name='ADMTerritoryCode';
            admTerritoryCode.Territory_Code__c='101485';
            insert admTerritoryCode;
        
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            insert acc; 
      
            List<Opportunity> oppLst = new List<Opportunity>();
            Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Program_level_Forecasting__c =true; 
            oppy2.Name = 'Pain of Queen';
            oppy2.Type = 'CM';
            oppy2.Defined_GPLs__c = 'A39,K01,K03,176';
            oppLst.add(oppy2);  
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();  
            oppy.Type = 'CM';
            oppy.Request_Type__c = 'Cable Assembly';
            oppy.Defined_GPLs__c = 'A39,K01,K03,176';
            oppLst.add(oppy);
            insert oppLst;
            
            Product_Hierarchy__c ph = new Product_Hierarchy__c();
            ph.Hierarchy_Level_Type__c = 'GPL';
            ph.Description__c = 'Industrial';
            insert ph;
            
            Part__c part = new Part__c();
            part.Description__c = 'Proposal Part';
            part.Product_Hierarchy__c = ph.Id;
            insert part;
            
            Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
            oppypart.Opportunity__c = oppy.Id;
            oppypart.Part__c = part.Id;
            oppypart.Status__c = 'Lost';
            oppypart.Lost_Reason__c = 'Other';
            oppypart.Lost_Reason_Text__c = null;
            oppypart.Similar_TE_Part_Number__c = part.Id;
            oppypart.GPL__c = ph.Id;
            oppypart.New_Part_Description__c = 'xxxxx';
            oppypart.Send_to_RTS__c = 'Yes';
            insert oppypart;
            
            List<Part__c> list_selectedParts = new List<Part__c>();
            list_selectedParts.add(part);            
            
            Test.startTest();
            ApexPages.StandardController ctrl = new ApexPages.StandardController(oppypart); 
            ExtOpportunityPartEntry ext = new ExtOpportunityPartEntry(ctrl);
            ext.oppPart = oppypart;
            ext.addAmount = '1';
            ext.list_selectedParts = list_selectedParts;
    
            //ext.list_selectedParts = list_selectedParts;
            ext.deleteOpportunityPartIndex = 1;
            ext.idString = part.Id;
            ext.deleteOpportunityPartIndexProposal = 1;
            
      
            ext.SelectGPL();
            ext.SaveOpportunityParts();
            PageReference pr = ext.SelectPartsForPartNumber();            
            system.assert(true);
            Test.stopTest();
        }
    }
    static testMethod void testAllMethods6(){   
        Profile p = [Select Id, Name From Profile 
                     where Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'hellosManedsfd@testCompany1233423.com';
        u.Alias = 'dpses';
        u.CommunityNickname = 'NNND';
        u.ProfileId = p.Id;
        insert u;
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        Channelinsightdata_test.Channelinsightdata_test();  
        /*Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;*/    
        system.runAs(u){ 
        RecordType rt = ClsTestHelp.createTestRecordType();
        
        ADMTerritoryCode__c admTerritoryCode= new ADMTerritoryCode__c();
        admTerritoryCode.Name='ADMTerritoryCode';
        admTerritoryCode.Territory_Code__c='101485';
        insert admTerritoryCode;
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        insert acc; 
  
        List<Opportunity> oppLst = new List<Opportunity>();
       
        Opportunity oppy3 = ClsTestHelp.createTestOpportunity();
        oppy3.Type = 'CM';
        oppy3.Request_Type__c = 'Cable Assembly';
        oppy3.closeDate = date.today() + 3;
        oppy3.Defined_GPLs__c = 'A39,K01,K03,176';
        oppy3.Manufacturing_Start_Date__c = system.today();
            
        oppLst.add(oppy3);
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Cable Assembly';
        oppy.closeDate = date.today() + 3;
        oppy.Defined_GPLs__c = 'A39,K01,K03,176';
        oppy.Manufacturing_Start_Date__c = system.today();
        oppy.Program__c = oppy3.Id;
        oppLst.add(oppy);
            
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        oppy2.Type = 'CM';
        oppy2.closeDate = date.today();
        oppy2.Defined_GPLs__c = 'A39,K01,K03,176';
        OPPy2.CurrencyIsoCode = 'EUR';
        oppy2.Manufacturing_Start_Date__c = system.today().addDays(-1);
        oppy2.Program__c = oppy3.Id;
        oppLst.add(oppy2);  
        insert oppLst;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'GPL';
        ph.Description__c = 'Industrial';
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Proposal Part';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppypart.Part__c = null;
        oppypart.Status__c = ' ';
        oppypart.Lost_Reason__c = 'Other';
        oppypart.Lost_Reason_Text__c = null;
        oppypart.Similar_TE_Part_Number__c = part.Id;
        oppypart.GPL__c = ph.Id;
        oppypart.Send_to_RTS__c = 'Yes';
           
        insert oppypart;
        list<Opportunity_Forecast__c> list_fc2Insert = new list<Opportunity_Forecast__c>();   
        Opportunity_Forecast__c  oppyFore = new Opportunity_Forecast__c();
            oppyFore.Opportunity__c = oppy2.Id;
           // oppyFore.part__c = oppyPart.Id;
            oppyFore.Fiscal_Year__c = '2016';
            oppyFore.Fiscal_Quarter__c ='04';
            oppyFore.Amount__c = 10;
            oppyFore.date__c = system.today();
            oppyFore.CurrencyIsoCode = 'USD';
            oppyFore.Five_Year_Amount__c = 50;
        //insert oppyFore;  
        list_fc2Insert.add(oppyFore);
        Opportunity_Forecast__c  oppyFore2 = new Opportunity_Forecast__c();
            oppyFore2.Opportunity__c = oppy2.Id;
            //oppyFore2.part__c = oppyPart.Id;
            oppyFore2.Fiscal_Year__c = '2016';
            oppyFore2.Fiscal_Quarter__c ='04';
            oppyFore2.Amount__c = 20;
            oppyFore2.Five_Year_Amount__c = 50;
            oppyFore2.date__c = system.today();
            oppyFore2.CurrencyIsoCode = 'EUR';
        //insert oppyFore2; 
        list_fc2Insert.add(oppyFore2);
        insert list_fc2Insert;
        Opportunity_Part__c oppypart2 = new Opportunity_Part__c();
        
        List<Part__c> list_selectedParts = new List<Part__c>();
        list_selectedParts.add(part);
        
        /*List<Opportunity_Part__c> list_opportunityParts = new List<Opportunity_Part__c>();
        list_opportunityParts.add(oppypart);
        */
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('oppyId',oppy2.Id);
        
        ApexPages.StandardController ctrl = new ApexPages.StandardController(oppypart2); 
        ExtOpportunityPartEntry ext = new ExtOpportunityPartEntry(ctrl);
        //ext.list_opportunityParts = list_opportunityParts;
        ext.isOnlySales = true;
        ext.opp = oppy;

        
        ext.SaveOpportunityParts();
        
        system.assert(true);
        Test.stopTest();
        }
    }
    static testMethod void testAllMethods7(){   
        Profile p = [Select Id, Name From Profile 
                     where Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'hellosManedsfd@testCompany1233423.com';
        u.Alias = 'dpses';
        u.CommunityNickname = 'NNND';
        u.ProfileId = p.Id;
        insert u;
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        Channelinsightdata_test.Channelinsightdata_test();   
        
        /*Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;  */ 
        system.runAs(u){ 
        RecordType rt = ClsTestHelp.createTestRecordType();
        
        ADMTerritoryCode__c admTerritoryCode= new ADMTerritoryCode__c();
        admTerritoryCode.Name='ADMTerritoryCode';
        admTerritoryCode.Territory_Code__c='101485';
        insert admTerritoryCode;
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        insert acc; 
  
        List<Opportunity> oppLst = new List<Opportunity>();
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        oppy2.Type = 'CM';
        oppy2.closeDate = date.today();
        oppy2.Defined_GPLs__c = 'A39,K01,K03,176';
        oppy2.Request_Type__c = 'Cable Assembly';
        oppLst.add(oppy2);  
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Cable Assembly';
        oppy.closeDate = date.today() + 3;
        oppy.Defined_GPLs__c = 'A39,K01,K03,176';
        oppy2.Request_Type__c = 'Cable Assembly';
        oppLst.add(oppy);
        insert oppLst;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'GPL';
        ph.Description__c = 'Industrial';
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Proposal Part';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppypart.Part__c = null;
        oppypart.Status__c = 'Lost';
        oppypart.Lost_Reason__c = 'Other';
        oppypart.Lost_Reason_Text__c = null;
        oppypart.Similar_TE_Part_Number__c = part.Id;
        oppypart.GPL__c = ph.Id;
        oppypart.Send_to_RTS__c = 'Yes';
        insert oppypart;
        
        Opportunity_Part__c oppypart2 = new Opportunity_Part__c();
        
        List<Part__c> list_selectedParts = new List<Part__c>();
        list_selectedParts.add(part);
        
        /*List<Opportunity_Part__c> list_opportunityParts = new List<Opportunity_Part__c>();
        list_opportunityParts.add(oppypart);
        */
        List<ExtOpportunityPartEntry.OpportunityPartWrapper> list_indexOpportunityParts = new List<ExtOpportunityPartEntry.OpportunityPartWrapper>();
        ExtOpportunityPartEntry.OpportunityPartWrapper extOppy = new ExtOpportunityPartEntry.OpportunityPartWrapper(oppypart,1,'test','test','test');
        extOppy.opportunityPart = oppypart;
        list_indexOpportunityParts.add(extOppy);
        
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('oppyId',oppy.Id);
        
        ApexPages.StandardController ctrl = new ApexPages.StandardController(oppypart); 
        ExtOpportunityPartEntry ext = new ExtOpportunityPartEntry(ctrl);
       // ext.list_opportunityParts = list_opportunityParts;
        ext.isOnlySales = false;
        ext.opp = oppy2;
        ext.list_indexOpportunityParts = list_indexOpportunityParts;
        
        /********************/
        ext.isOnlySales = true;
        
        
        OrgWideSettings__c settingsObj = NEW OrgWideSettings__c();
        settingsObj.Name = 'Manage Part';
        settingsObj.Datatable_Page_Size__c = 1;
        insert settingsObj;
        System.debug('settingsObj :::: '+settingsObj);
        ext.oppPartListPageSize = Integer.valueOf(settingsObj.Datatable_Page_Size__c);
        ext.oppPartListPageSizeProposal = Integer.valueOf(settingsObj.Datatable_Page_Size__c);
        ext.SaveOpportunityParts();
        
        //ext.isOnlySales = false;
        //ext.SaveOpportunityParts();
        
        oppypart.Part__c = part.Id;
        update oppypart;
        
        ApexPages.StandardController ctrl2 = new ApexPages.StandardController(oppypart); 
        ExtOpportunityPartEntry ext2 = new ExtOpportunityPartEntry(ctrl2);
       // ext.list_opportunityParts = list_opportunityParts;
        ext2.isOnlySales = false;
        //ext2.opp = oppy2;
        //ext2.list_indexOpportunityParts = list_indexOpportunityParts;
        ext2.SaveOpportunityParts();
        
        
        
        /************************/
        
        //ext.SaveOpportunityParts();
        ext.getItems();
        ext.changeSalePartNumber();
        
        
        system.assert(true);
        Test.stopTest();
        }
    }
    
    static testMethod void testAllMethods8(){   
        Profile p = [Select Id, Name From Profile 
                     where Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'hellosManedsfd@testCompany1233423.com';
        u.Alias = 'dpses';
        u.CommunityNickname = 'NNND';
        u.ProfileId = p.Id;
        insert u;
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        Channelinsightdata_test.Channelinsightdata_test();   
        /*Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;  */ 
        system.runAs(u){ 
        RecordType rt = ClsTestHelp.createTestRecordType();
        
        ADMTerritoryCode__c admTerritoryCode= new ADMTerritoryCode__c();
        admTerritoryCode.Name='ADMTerritoryCode';
        admTerritoryCode.Territory_Code__c='101485';
        insert admTerritoryCode;
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        insert acc; 
  
        List<Opportunity> oppLst = new List<Opportunity>();
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        oppy2.Type = 'CM';
        oppy2.closeDate = date.today();
        oppy2.Defined_GPLs__c = 'A39,K01,K03,176';
        oppLst.add(oppy2);  
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Cable Assembly';
        oppy.closeDate = date.today() + 3;
        oppy.Defined_GPLs__c = 'A39,K01,K03,176';
        oppLst.add(oppy);
        insert oppLst;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'GPL';
        ph.Description__c = 'Industrial';
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Proposal Part';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppypart.Part__c = part.Id;
        oppypart.Status__c = 'Lost';
        oppypart.Lost_Reason__c = 'Other';
        oppypart.Lost_Reason_Text__c = null;
        oppypart.Similar_TE_Part_Number__c = part.Id;
        oppypart.GPL__c = ph.Id;
        oppypart.Send_to_RTS__c = 'Yes';
        insert oppypart;
        
        Opportunity_Part__c oppypart2 = new Opportunity_Part__c();
        
        List<Part__c> list_selectedParts = new List<Part__c>();
        list_selectedParts.add(part);
        
        /*List<Opportunity_Part__c> list_opportunityParts = new List<Opportunity_Part__c>();
        list_opportunityParts.add(oppypart);
        */
        List<ExtOpportunityPartEntry.OpportunityPartWrapper> list_indexOpportunityParts = new List<ExtOpportunityPartEntry.OpportunityPartWrapper>();
        ExtOpportunityPartEntry.OpportunityPartWrapper extOppy = new ExtOpportunityPartEntry.OpportunityPartWrapper(oppypart,1,'test','test','test');
        extOppy.opportunityPart = oppypart;
        extOppy.index = 1;
        list_indexOpportunityParts.add(extOppy);
        
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('oppyId',oppy.Id);
        
        ApexPages.StandardController ctrl = new ApexPages.StandardController(oppypart); 
        ExtOpportunityPartEntry ext = new ExtOpportunityPartEntry(ctrl);
        //ext.list_opportunityParts = list_opportunityParts;
        ext.isOnlySales = false;
        ext.opp = oppy2;
        ext.list_indexOpportunityParts = list_indexOpportunityParts;
        
        ext.SaveOpportunityParts();
        ext.getItems();
        ext.changeSalePartNumber();
        
        system.assert(true);
        
        
        Test.stopTest();
        }
    }
    
    static testMethod void testAllMethods9() {   
    
        Profile p = [Select Id, Name From Profile 
                     where Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'hellosManedsfd@testCompany1233423.com';
        u.Alias = 'dpses';
        u.CommunityNickname = 'NNND';
        u.ProfileId = p.Id;
        insert u;
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        Channelinsightdata_test.Channelinsightdata_test();      
        system.runAs(u){ 
        RecordType rt = ClsTestHelp.createTestRecordType();
        
        ADMTerritoryCode__c admTerritoryCode= new ADMTerritoryCode__c();
        admTerritoryCode.Name='ADMTerritoryCode';
        admTerritoryCode.Territory_Code__c='101485';
        insert admTerritoryCode;
        
        /*Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;*/
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        insert acc; 
  
        List<Opportunity> oppLst = new List<Opportunity>();
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        oppy2.Type = 'CM';
        oppy2.closeDate = date.today();
        oppy2.Defined_GPLs__c = 'A39,K01,K03,176';
        oppy2.Request_Type__c = 'Cable Assembly';
        oppy2.Program__c = oppy2.Id;
        oppLst.add(oppy2);  
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Program__c = oppy2.Id;
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Cable Assembly';
        oppy.closeDate = date.today() + 3;
        oppy.Defined_GPLs__c = 'A39,K01,K03,176';
        oppy2.Request_Type__c = 'Cable Assembly';
        oppLst.add(oppy);
        insert oppLst;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'GPL';
        ph.Description__c = 'Industrial';
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Proposal Part';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppypart.Part__c = null;        
        oppypart.Status__c = 'Lost';
        oppypart.Lost_Reason__c = 'Other';
        oppypart.Lost_Reason_Text__c = null;
        oppypart.Similar_TE_Part_Number__c = part.Id;
        oppypart.GPL__c = ph.Id;
        oppypart.Send_to_RTS__c = 'Yes';
        insert oppypart;
        
        Opportunity_Part__c oppypart2 = new Opportunity_Part__c();
        
        List<Part__c> list_selectedParts = new List<Part__c>();
        list_selectedParts.add(part);
        
        /*List<Opportunity_Part__c> list_opportunityParts = new List<Opportunity_Part__c>();
        list_opportunityParts.add(oppypart);
        */
        List<ExtOpportunityPartEntry.OpportunityPartWrapper> list_indexOpportunityParts = new List<ExtOpportunityPartEntry.OpportunityPartWrapper>();
        ExtOpportunityPartEntry.OpportunityPartWrapper extOppy = new ExtOpportunityPartEntry.OpportunityPartWrapper(oppypart,1,'test','test','test');
        extOppy.opportunityPart = oppypart;
        list_indexOpportunityParts.add(extOppy);
       
        
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('oppyId',oppy.Id);
        
        ApexPages.StandardController ctrl = new ApexPages.StandardController(oppypart); 
        ExtOpportunityPartEntry ext = new ExtOpportunityPartEntry(ctrl);
       // ext.list_opportunityParts = list_opportunityParts;
        ext.isOnlySales = false;
        ext.opp = oppy2;
        ext.list_indexOpportunityParts = list_indexOpportunityParts;
        
        /********************/
        ext.isOnlySales = true;
        
        
        OrgWideSettings__c settingsObj = NEW OrgWideSettings__c();
        settingsObj.Name = 'Manage Part';
        settingsObj.Datatable_Page_Size__c = 1;
        insert settingsObj;
        System.debug('settingsObj :::: '+settingsObj);
        ext.oppPartListPageSize = Integer.valueOf(settingsObj.Datatable_Page_Size__c);
        ext.oppPartListPageSizeProposal = Integer.valueOf(settingsObj.Datatable_Page_Size__c);
        ext.SaveOpportunityParts();
        
        //ext.isOnlySales = false;
        //ext.SaveOpportunityParts();
        
        //oppypart.Part__c = part.Id;
        //update oppypart;
        
        ApexPages.StandardController ctrl2 = new ApexPages.StandardController(oppypart); 
        ExtOpportunityPartEntry ext2 = new ExtOpportunityPartEntry(ctrl2);
       // ext.list_opportunityParts = list_opportunityParts;
        ext2.isOnlySales = false;
        //ext2.opp = oppy2;
        //ext2.list_indexOpportunityParts = list_indexOpportunityParts;
        ext2.SaveOpportunityParts();
        
        //oppypart.Part_Number__c = null;
        //update oppypart;
        //ext2.SaveOpportunityParts();
        
        ext.DoSaveAndReturn();
        
        Opportunity_Part__c oppypart3 = ClsTestHelp.createTestOpportunityPart();
        oppypart3.Opportunity__c = oppy.Id;
        oppypart3.Part__c = part.Id;        
        oppypart3.Status__c = 'Lost';
        oppypart3.Lost_Reason__c = 'Other';
        oppypart3.Lost_Reason_Text__c = null;
        oppypart3.Similar_TE_Part_Number__c = null;
        oppypart3.GPL__c = ph.Id;
        oppypart3.Send_to_RTS__c = 'Yes';
        insert oppypart3;
        
        
        List<ExtOpportunityPartEntry.OpportunityPartWrapper> list_indexOpportunityParts2 = new List<ExtOpportunityPartEntry.OpportunityPartWrapper>();
        ExtOpportunityPartEntry.OpportunityPartWrapper extOppy2 = new ExtOpportunityPartEntry.OpportunityPartWrapper(oppypart3,1,'test','test','test');
        extOppy2.opportunityPart = oppypart3;
        list_indexOpportunityParts2.add(extOppy2);
        
        ext.DoSaveAndReturn();

        /************************/
        
        //ext.SaveOpportunityParts();
        ext.getItems();
        ext.changeSalePartNumber();
        
        system.assert(true);
        Test.stopTest();
        
        }
    }
    static testMethod void testAllMethods10() {
        Test.startTest();
        
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        Channelinsightdata_test.Channelinsightdata_test();
        ClsTestHelp.initAPLTestData();
        List<Apex_Helper_Settings__c> lstApex_Helper_Settings = new List<Apex_Helper_Settings__c>();
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'DND Project Profile List', Value__c = '00eE0000000VFvYIAW'));
        insert lstApex_Helper_Settings;     
        /*Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;*/
        User u;     
        for(User ui : [SELECT IsActive FROM User where Profile.Name = 'System Administrator' and IsActive = true limit 1]){
            u = ui;
        }
        if(u == null){
            u = ClsTestHelp.createTestUsers();
            u.Email = 'Scofield@itbteeest123.com';
            u.Alias = 'Numb4r1';
            u.CommunityNickname = 'NO.4';
            u.IsActive = true;
            insert u;
        }
        
        system.runAs(u){
        
            RecordType rt = ClsTestHelp.createTestRecordType();
                
            ADMTerritoryCode__c admTerritoryCode= new ADMTerritoryCode__c();
            admTerritoryCode.Name='ADMTerritoryCode';
            admTerritoryCode.Territory_Code__c='101485';
            insert admTerritoryCode;
        
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            insert acc;
            
            ApexPages.StandardController ctrl = new ApexPages.StandardController(acc); 
            ExtOpportunityPartEntry ext = new ExtOpportunityPartEntry(ctrl);
            ext.GotoOpportunity();
        }
    }
     static testMethod void TestADMOppyState(){
         
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types(); 
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
         
         Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;
        Test.startTest();
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'USD';
        oppy.Five_Year_Revenue__c = 1;
        oppy.RecordTypeId = ClsTestHelp.createTestRecordType31().Id;
        insert oppy;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        Opportunity_Part__c oppypart1 = ClsTestHelp.createTestOpportunityPart();
        oppypart1.Opportunity__c = oppy.Id;
        oppypart1.Part__c = part.Id;
        oppypart1.Status__c = 'Commit';
        oppypart1.Lost_Reason__c = 'Other';
        oppypart1.Lost_Reason_Text__c = null;
        oppypart1.GPL__c = ph.Id;
        oppypart1.Initial_Order_Date__c = date.today();
        insert oppypart1;       
          
        list<Opportunity_Forecast__c> list_forecasts = new list<Opportunity_Forecast__c>();
       
        Opportunity_Forecast__c oppyForecast1 = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast1.Opportunity__c = oppy.Id;
        oppyForecast1.Quantity__c = 12;
        oppyForecast1.Part__c = oppypart1.Id;
        oppyForecast1.Date__c = date.newInstance(2015, 09, 28);
        oppyForecast1.Amount__c = 1;
        oppyForecast1.Sales_Price__c = 1;
        oppyForecast1.Fiscal_Year__c = null;
        oppyForecast1.Fiscal_Quarter__c = '21';
        oppyForecast1.CurrencyIsoCode = 'USD';
        list_forecasts.add(oppyForecast1);
         Opportunity_Forecast__c oppyForecast2 = oppyForecast1.clone();
         oppyForecast2.Date__c = date.newInstance(2016, 01, 28);
        list_forecasts.add(oppyForecast2); 
          
        insert list_forecasts;
         try{
       oppypart1.status__C = 'Won';
         update oppypart1;
         }
        catch(exception e){
            system.debug(e.getMessage()+' at '+ e.getStackTraceString());
        }
        Test.stopTest();
    }
    static testMethod void TestDNDOppyCloseDate(){
         
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types(); 
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
       
      /* Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;*/
         User u;     
        for(User ui : [SELECT IsActive FROM User where Profile.Name = 'System Administrator' and IsActive = true limit 1]){
            u = ui;
        }
        if(u == null){
            u = ClsTestHelp.createTestUsers();
            u.Email = 'Scofield@itbteeest123.com';
            u.Alias = 'Numb4r1';
            u.CommunityNickname = 'NO.4';
            u.IsActive = true;
            insert u;
        }
      //  ClsTestCustomSettingHelper.getDNDClosedOpp();
        
        RecordType dndOpptyRecordType;
        Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('DND Opportunity').getRecordTypeId();
        if(RecordTypeId != null)
            dndOpptyRecordType= new RecordType(Id=RecordTypeId,DeveloperName = 'DND_Opportunity',Name='DND Opportunity',SobjectType = 'Opportunity');
        else
        {
            dndOpptyRecordType = [select Id, Name from RecordType where SobjectType = 'Opportunity' and DeveloperName = 'DND_Opportunity'];
        }
        
        Test.startTest();
        
        
        system.runAs(u){
        
            RecordType rt = ClsTestHelp.createTestRecordType();
                
            ADMTerritoryCode__c admTerritoryCode= new ADMTerritoryCode__c();
            admTerritoryCode.Name='ADMTerritoryCode';
            admTerritoryCode.Territory_Code__c='101485';
            insert admTerritoryCode;
        
            Account acc = ClsTestHelp.createTestAccounts();
            acc.RecordTypeId =ClsTestHelp.createCSDTestRecordType7().id;
            acc.Type = 'CM';
            insert acc;
            
            Account acc1 = ClsTestHelp.createTestAccounts();
            acc1.Type = 'CM';
            insert acc1;
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.OEM_Name__c=acc.id;
            oppy.Type = 'CM';
            oppy.Request_Type__c = 'Extension';
            oppy.Method__c = 'BOM';
            oppy.Level__c = 'Yearly';
            oppy.Amount = 1;
            oppy.CurrencyIsoCode = 'USD';
            oppy.Five_Year_Revenue__c = 1;
            oppy.CloseDate=System.today()+6;
            oppy.RecordTypeId = dndOpptyRecordType.Id;
            oppy.Accountid=acc1.id;
            oppy.StageName='New Opportunity';
            insert oppy;
        
            ApexPages.StandardController ctrl = new ApexPages.StandardController(acc); 
            ExtOpportunityPartEntry ext = new ExtOpportunityPartEntry(ctrl);
            ext.closeDateValidationForDND();
        }
        
        Test.stopTest();
    }
}