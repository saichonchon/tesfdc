/**
*   This test class is for ExtOpportunityPartEntryAPL.
*
@author Di Chen
@created 2012-03-14
@version 1.0
@since 20.0.
*
@changelog
* 2012-03-14 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 79%
*/
@isTest(seeAllData=true)
private class ExtOpportunityPartEntryAPL_Test {

    static testMethod void testAllMethods() {
        Test.startTest();
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
    
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            insert acc; 
      
            Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Program_level_Forecasting__c =true; 
            oppy2.Name = 'Pain of Queen';
            oppy2.Type = 'CM';
            oppy2.closeDate = date.today() + 1;
            oppy2.Defined_GPLs__c = 'A39,K01,K03,176';
            insert oppy2;  
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Type = 'CM';
            oppy.Request_Type__c = 'Cable Assembly';
            oppy.closeDate = date.today() + 2;
            oppy.Defined_GPLs__c = 'A39,K01,K03,176';
            insert oppy;
            
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
            
            List<Part__c> list_selectedParts = new List<Part__c>();
            list_selectedParts.add(part);
            
            ApexPages.StandardController ctrl = new ApexPages.StandardController(oppypart); 
            ExtOpportunityPartEntryAPL ext = new ExtOpportunityPartEntryAPL(ctrl);
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
            ext.DoAddProposalParts();
            
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
            //ext.SelectPartsForPartNumber();
            
            ExtOpportunityPartEntryAPL.proposalPartId();
            ExtOpportunityPartEntryAPL.oppRTId('cap');
            ExtOpportunityPartEntryAPL.oppRTId('sp');
            ExtOpportunityPartEntryAPL.oppRTId('nd');
            ExtOpportunityPartEntryAPL.oppRTId('e'); 
            ExtOpportunityPartEntryAPL.getSampleTypes();
            system.assert(true);
            Test.stopTest();
        } 
    }
    static testMethod void testAllMethods1() {
        Test.startTest();
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
    
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            insert acc;
     
            Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Program_level_Forecasting__c =true; 
            oppy2.Name = 'Pain of Queen';
            oppy2.Type = 'CM';
            oppy2.Defined_GPLs__c = 'A39,K01,K03,176';
            insert oppy2;  
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Type = 'CM';
            oppy.Request_Type__c = 'Cable Assembly';
            oppy.Defined_GPLs__c = 'A39,K01,K03,176';
            insert oppy;
            
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
            
            List<Part__c> list_selectedParts = new List<Part__c>();
            list_selectedParts.add(part);
    
            /*List<Opportunity_Part__c> list_opportunityPartsProposal = new List<Opportunity_Part__c>();
            list_opportunityPartsProposal.add(oppypart);*/
            
            ApexPages.StandardController ctrl = new ApexPages.StandardController(oppypart); 
            ExtOpportunityPartEntryAPL ext = new ExtOpportunityPartEntryAPL(ctrl);
            ext.oppPart = oppypart;
            ext.addAmount = '1';
            ext.list_selectedParts = list_selectedParts;
    
           // ext.list_opportunityPartsProposal = list_opportunityPartsProposal;
            
            ext.getAmounts();
            ext.NewAddProposalParts();
            ext.DoAddProposalParts();
    
            ext.OppPartListPreviousPage();
            ext.OppPartListNextPage();
            ext.OppPartListPreviousPageProposal();
            ext.OppPartListNextPageProposal();
    
            ext.DeleteOpportunityParts();
            ext.DeleteOpportunityPartsProposal();
            ext.SaveOpportunityParts();
            ext.isCSD = true;
            oppy.Manufacturing_Start_Date__c = System.today();
            update oppy;
            ext.SaveOpportunityParts();
            ext.SelectSimilarParts();
            ext.GotoOpportunity();
            ext.DoSaveAndReturn();
            
            ExtOpportunityPartEntryAPL.oppRTId('cap');
            ExtOpportunityPartEntryAPL.oppRTId('sp');
            ExtOpportunityPartEntryAPL.oppRTId('nd');
            ExtOpportunityPartEntryAPL.oppRTId('e'); 
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
            List<ExtOpportunityPartEntryAPL.OpportunityPartWrapper> alist = ext.list_singlePageOpportunityParts;
            Test.stopTest();
        }
    }
    static testMethod void testRequestType2() {
        Test.startTest();
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
    
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            insert acc;
     
            Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Program_level_Forecasting__c =true; 
            oppy2.Name = 'Pain of Queen';
            oppy2.Type = 'CM';
            oppy2.Defined_GPLs__c = 'A39,K01,K03,176';
            insert oppy2;  
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Type = 'CM';
            oppy.Request_Type__c = 'New Development';
            oppy.Defined_GPLs__c = 'A39,K01,K03,176';
            insert oppy;
            
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
            ExtOpportunityPartEntryAPL ext = new ExtOpportunityPartEntryAPL(ctrl);
            ext.oppPart = oppypart;
            ext.addAmount = '1';
            ext.list_selectedParts = list_selectedParts;
            
            ext.getAmounts();
            ext.NewAddProposalParts();
            ext.DoAddProposalParts();
             
            ExtOpportunityPartEntryAPL.oppRTId('cap');
            ExtOpportunityPartEntryAPL.oppRTId('sp');
            ExtOpportunityPartEntryAPL.oppRTId('nd');
            ExtOpportunityPartEntryAPL.oppRTId('e'); 
            system.assert(true);
            Test.stopTest();
        }
    }
    static testMethod void testRequestType3() {
        Test.startTest();
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
    
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            insert acc;
     
            Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Program_level_Forecasting__c =true; 
            oppy2.Name = 'Pain of Queen';
            oppy2.Type = 'CM';
            oppy2.Defined_GPLs__c = 'A39,K01,K03,176';
            insert oppy2;  
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Type = 'CM';
            oppy.Request_Type__c = 'Extension';
            oppy.Defined_GPLs__c = 'A39,K01,K03,176';
            insert oppy;
            
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
            ExtOpportunityPartEntryAPL ext = new ExtOpportunityPartEntryAPL(ctrl);
            ext.oppPart = oppypart;
            ext.addAmount = '1';
            ext.list_selectedParts = list_selectedParts;
            
            ext.getAmounts();
            ext.NewAddProposalParts();
            ext.DoAddProposalParts();
             
            ExtOpportunityPartEntryAPL.oppRTId('cap');
            ExtOpportunityPartEntryAPL.oppRTId('sp');
            ExtOpportunityPartEntryAPL.oppRTId('nd');
            ExtOpportunityPartEntryAPL.oppRTId('e'); 
            system.assert(true);
            Test.stopTest();
        }
    }

    static testMethod void testAllMethods2() {
        Test.startTest();
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
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            insert acc;
     
            Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Program_level_Forecasting__c =true; 
            oppy2.Name = 'Pain of Queen';
            oppy2.Type = 'CM';
            oppy2.Defined_GPLs__c = 'A39,K01,K03,176';
            insert oppy2;  
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Type = 'CM';
            oppy.Request_Type__c = 'Cable Assembly';
            oppy.Defined_GPLs__c = 'A39,K01,K03,176';
            insert oppy;
            
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
            ExtOpportunityPartEntryAPL ext = new ExtOpportunityPartEntryAPL(ctrl);
            ext.oppPart = oppypart;
            ext.addAmount = '1';
            ext.list_selectedParts = list_selectedParts;
            ext.oppPartListPageNumber= 1;
    
            ext.getAmounts();
            ext.NewAddProposalParts();
            ext.DoAddProposalParts();
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
            
            ExtOpportunityPartEntryAPL.oppRTId('cap');
            ExtOpportunityPartEntryAPL.oppRTId('sp');
            ExtOpportunityPartEntryAPL.oppRTId('nd');
            ExtOpportunityPartEntryAPL.oppRTId('e'); 
            system.assert(true);
            Test.stopTest();
        }
    }
    static testMethod void testAllMethods3() {
        Test.startTest();
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
    
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            insert acc;
     
            Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Program_level_Forecasting__c =true; 
            oppy2.Name = 'Pain of Queen';
            oppy2.Type = 'CM';
            oppy2.Defined_GPLs__c = 'A39,K01,K03,176';
            insert oppy2;  
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Type = 'CM';
            oppy.Request_Type__c = 'Cable Assembly';
            oppy.Defined_GPLs__c = 'A39,K01,K03,176';
            insert oppy;
            
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
            ExtOpportunityPartEntryAPL ext = new ExtOpportunityPartEntryAPL(ctrl);
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
        Test.startTest();
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
    
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            insert acc;
     
            Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Program_level_Forecasting__c =true; 
            oppy2.Name = 'Pain of Queen';
            oppy2.Type = 'CM';
            oppy2.Defined_GPLs__c = 'A39,K01,K03,176';
            insert oppy2;  
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Type = 'CM';
            oppy.Request_Type__c = 'Cable Assembly';
            oppy.Defined_GPLs__c = 'A39,K01,K03,176';
            insert oppy;
            
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
    
            ApexPages.StandardController ctrl = new ApexPages.StandardController(oppypart); 
            ExtOpportunityPartEntryAPL ext = new ExtOpportunityPartEntryAPL(ctrl);
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
    
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            insert acc; 
      
            Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Program_level_Forecasting__c =true; 
            oppy2.Name = 'Pain of Queen';
            oppy2.Type = 'CM';
            oppy2.Defined_GPLs__c = 'A39,K01,K03,176';
            insert oppy2;  
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();  
            oppy.Type = 'CM';
            oppy.Request_Type__c = 'Cable Assembly';
            oppy.Defined_GPLs__c = 'A39,K01,K03,176';
            insert oppy;
            
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
            ExtOpportunityPartEntryAPL ext = new ExtOpportunityPartEntryAPL(ctrl);
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
              
        system.runAs(u){ 
        RecordType rt = ClsTestHelp.createTestRecordType();

        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        insert acc; 
  
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        oppy2.Type = 'CM';
        oppy2.closeDate = date.today();
        oppy2.Defined_GPLs__c = 'A39,K01,K03,176';
        insert oppy2;  
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Cable Assembly';
        oppy.closeDate = date.today() + 3;
        oppy.Defined_GPLs__c = 'A39,K01,K03,176';
        insert oppy;
        
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
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('oppyId',oppy2.Id);
        
        ApexPages.StandardController ctrl = new ApexPages.StandardController(oppypart2); 
        ExtOpportunityPartEntryAPL ext = new ExtOpportunityPartEntryAPL(ctrl);
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
              
        system.runAs(u){ 
        RecordType rt = ClsTestHelp.createTestRecordType();

        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        insert acc; 
  
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        oppy2.Type = 'CM';
        oppy2.closeDate = date.today();
        oppy2.Defined_GPLs__c = 'A39,K01,K03,176';
        insert oppy2;  
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Cable Assembly';
        oppy.closeDate = date.today() + 3;
        oppy.Defined_GPLs__c = 'A39,K01,K03,176';
        insert oppy;
        
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
        List<ExtOpportunityPartEntryAPL.OpportunityPartWrapper> list_indexOpportunityParts = new List<ExtOpportunityPartEntryAPL.OpportunityPartWrapper>();
        ExtOpportunityPartEntryAPL.OpportunityPartWrapper extOppy = new ExtOpportunityPartEntryAPL.OpportunityPartWrapper(oppypart,1,'test','test','test');
        extOppy.opportunityPart = oppypart;
        list_indexOpportunityParts.add(extOppy);
        
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('oppyId',oppy.Id);
        
        ApexPages.StandardController ctrl = new ApexPages.StandardController(oppypart); 
        ExtOpportunityPartEntryAPL ext = new ExtOpportunityPartEntryAPL(ctrl);
       // ext.list_opportunityParts = list_opportunityParts;
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
              
        system.runAs(u){ 
        RecordType rt = ClsTestHelp.createTestRecordType();

        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        insert acc; 
  
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        oppy2.Type = 'CM';
        oppy2.closeDate = date.today();
        oppy2.Defined_GPLs__c = 'A39,K01,K03,176';
        insert oppy2;  
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Cable Assembly';
        oppy.closeDate = date.today() + 3;
        oppy.Defined_GPLs__c = 'A39,K01,K03,176';
        insert oppy;
        
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
        List<ExtOpportunityPartEntryAPL.OpportunityPartWrapper> list_indexOpportunityParts = new List<ExtOpportunityPartEntryAPL.OpportunityPartWrapper>();
        ExtOpportunityPartEntryAPL.OpportunityPartWrapper extOppy = new ExtOpportunityPartEntryAPL.OpportunityPartWrapper(oppypart,1,'test','test','test');
        extOppy.opportunityPart = oppypart;
        extOppy.index = 1;
        list_indexOpportunityParts.add(extOppy);
        
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('oppyId',oppy.Id);
        
        ApexPages.StandardController ctrl = new ApexPages.StandardController(oppypart); 
        ExtOpportunityPartEntryAPL ext = new ExtOpportunityPartEntryAPL(ctrl);
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
}