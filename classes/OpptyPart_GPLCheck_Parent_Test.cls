/**************************************************************************************************************************************************
Name:  Globla_Product_ManageNameByGPLCode_Test
Copyright © 2013 TE Connectivity
===================================================================================================================================================
Purpose: This class contain Test Methods for Globla_Product_ManageNameByGPLCode
---------------------------------------------------------------------------------------------------------------------------------------------------       
Related APEX Trigger : Globla_Product_ManageNameByGPLCode
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
Version Developer          Date       Detail                                  Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Ramakrishna Singara 6/30/2013 Initial Development            
    2.0 Ramakrishna Singara 12/30/2013 Enhancement                                            
**************************************************************************************************************************************************/
@isTest
(seeAllData = true)
private class OpptyPart_GPLCheck_Parent_Test{

     public static testMethod void MytestTrigger() {
        
        Test.startTest();
        // User Record
        Profile p = [SELECT Id FROM Profile WHERE Name='DND Engineering User w/Cost']; 
        
        User u = new User(GIBU__c='Data & Devices', Alias = 'standt', Email='test432@testorg.com', EmailEncodingKey='UTF-8', LastName='Tes', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='test432@testorg.com', CSD_Region__c='Taiwan');
        System.runAs(u) {
        // The following code runs as user 'u' 
        //System.debug('Current User: ' + UserInfo.getUserName());
        //System.debug('Current Profile: ' + UserInfo.getProfileId()); 
        
        
        //Account Record Type
        Schema.DescribeSObjectResult cfrSchema1 = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> AccountRecordTypeInfo = cfrSchema1.getRecordTypeInfosByName(); 
        Id CSDAccrtId = AccountRecordTypeInfo.get('OEM').getRecordTypeId();
        Id CSDAccountrtId = AccountRecordTypeInfo.get('Account').getRecordTypeId();
        list<Account> iAccts = new list<Account>();
        list<Opportunity> iOppy = new list<Opportunity>();
        list<Product_Hierarchy__c> iPH = new list<Product_Hierarchy__c>();
        list<Part__c> iParts = new list<Part__c>();
        list<Opportunity_Part__c> iOppyParts = new list<Opportunity_Part__c>();
               
        //Account Records        
        Account acc = new Account();
        acc.Name = 'Test';
        acc.ownerId = UserInfo.getUserId();        
        acc.Account_Manager__c = UserInfo.getUserId();
        acc.BillingCountry = 'CN';
        acc.RecordTypeId = CSDAccountrtId;
        //insert acc;
        iAccts.add(acc);
                
        Account acc1 = new Account();
        acc1.RecordTypeId = CSDAccrtId;
        acc1.Active__c = true;
        acc1.Name = 'Test';
        acc.ownerId = UserInfo.getUserId(); 
        acc1.Account_Manager__c = UserInfo.getUserId();
        acc1.BillingCountry = 'CN';
        //insert acc1;
        iAccts.add(acc1);

        insert iAccts;

       // GPL or Product Hierarchy Record
        Product_Hierarchy__c prodH = new Product_Hierarchy__c();
        prodH.Name = 'K88';
        prodH.CBC1__c = '30002';
        prodH.Global_PM__c = UserInfo.getUserId();
        prodH.CSD_EGM__c = u.id;
        prodH.Product_Manager__c = u.id;
        //prodH.Product_Manager__c = UserInfo.getUserId();
        //insert prodH;
        system.debug('********************'+prodH);
        iPH.add(prodH);
        
        // GPL1 or Product Hierarchy Record
        Product_Hierarchy__c prodH1 = new Product_Hierarchy__c();
        prodH1.Name = '519';
        prodH1.CBC1__c = '30002';
        prodH1.Global_PM__c = UserInfo.getUserId();
        prodH1.CSD_EGM__c = u.id;
        prodH1.Product_Manager__c = u.id;
        //prodH1.Product_Manager__c = UserInfo.getUserId();
        //insert prodH1;
        system.debug('********************'+prodH1);
        iPH.add(prodH1);        
        
        insert iPH;
        
        // Part Record
        Part__c part = new Part__c();
        part.Name = '1-1705765-6';
        part.Product_Hierarchy__c = prodH.id;
        //insert part;  
        iParts.add(part);
        
        
        // Part Record
        Part__c part1 = new Part__c();
        part1.Name = '787590-1';
        part1.Product_Hierarchy__c = prodH1.id;
        //insert part1;
        iParts.add(part1);
        
        insert iParts;          
                
        //Opportunity Record types
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> OpportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id CSDrtId = OpportunityRecordTypeInfo.get('Sales Opportunity-CSD').getRecordTypeId();
        Id DNDId = OpportunityRecordTypeInfo.get('DND Opportunity').getRecordTypeId();
         
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = DNDId;
        opp.Name = 'Test';
        opp.AccountId = acc.id;
        opp.Type = 'New Business';
        opp.Description = 'Test';
        opp.StageName = 'New Opportunity';
        opp.CloseDate = system.today();
        opp.Probability = 0;
        opp.OEM_Name__c = acc1.id;
        opp.Amount = 100;
        opp.isFromCode__c = true;
        opp.Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response';
        opp.Explanation_of_Change__c = 'Test';
        opp.Currency_Confirm__c=true;
        //insert opp;     
        system.debug('********************'+opp);
        iOppy.add(opp);
        
        Opportunity opp1 = new Opportunity();
        opp1.RecordTypeId = DNDId;
        opp1.Name = 'Test';
        opp1.AccountId = acc.id;
        opp1.Type = 'New Business';
        opp1.Description = 'Test';
        opp1.StageName = 'New Opportunity';
        opp1.CloseDate = system.today();
        opp1.Probability = 0;
        opp1.OEM_Name__c = acc1.id;
        opp1.Amount = 100;
        opp1.isFromCode__c = true;
        opp1.Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response';
        opp1.Explanation_of_Change__c = 'Test';
        opp1.Currency_Confirm__c=true;
        //insert opp1;     
        system.debug('********************'+opp1);
        iOppy.add(opp1);
        
        insert iOppy;        
        
        try{        
        // Opportunity Part Record
        //Opportunity_Part__c oppPart = ClsTestHelp.createTestOpportunityPart();        
        Schema.DescribeSObjectResult oppPartSchema = Schema.SObjectType.Opportunity_Part__c; 
        Map<String,Schema.RecordTypeInfo> oppPartRecordTypeInfo = oppPartSchema.getRecordTypeInfosByName(); 
        Id CSDOppPartrtId = oppPartRecordTypeInfo.get('Sales Parts').getRecordTypeId();
        Id CSDOppPart1rtId = oppPartRecordTypeInfo.get('New Development').getRecordTypeId();
                
        Opportunity_Part__c oppPart = new Opportunity_Part__c();
        oppPart.Opportunity__c = opp.Id;
        oppPart.Part__c = part.Id;
        oppPart.Status__c = 'Lost';
        oppPart.Lost_Reason__c = 'Other';
        oppPart.Lost_Reason_Text__c = null;
        oppPart.Similar_TE_Part_Number__c = part.Id;
        oppPart.GPL__c = prodH.Id;
        oppPart.Cable_Assembly_Type__c = 'Fiber Optic';
        oppPart.RecordTypeId = CSDOppPartrtId;
        //insert oppPart;
        iOppyParts.add(oppPart);   
        
        Opportunity_Part__c oppPart1 = new Opportunity_Part__c();
        oppPart1.Opportunity__c = opp.Id;
        oppPart1.Part__c = part.Id;
        oppPart1.Status__c = 'Lost';
        oppPart1.Lost_Reason__c = 'Other';
        oppPart1.Lost_Reason_Text__c = null;
        oppPart1.Similar_TE_Part_Number__c = part.Id;
        oppPart1.GPL__c = prodH.Id;
        oppPart1.Cable_Assembly_Type__c = 'Fiber Optic';
        oppPart1.RecordTypeId = CSDOppPartrtId;
        //insert oppPart1;                  
        iOppyParts.add(oppPart1);

        //try{
            Opportunity_Part__c oppPart2 = new Opportunity_Part__c();
            oppPart2.Opportunity__c = opp1.Id;
            oppPart2.Part__c = part1.Id;
            oppPart2.Status__c = 'Lost';
            oppPart2.Lost_Reason__c = 'Other';
            oppPart2.Lost_Reason_Text__c = null;
            oppPart2.Similar_TE_Part_Number__c = part1.Id;
            oppPart2.GPL__c = prodH1.Id;
            oppPart2.Cable_Assembly_Type__c = 'Fiber Optic';
            oppPart2.RecordTypeId = CSDOppPartrtId;
            //insert oppPart2;  
            iOppyParts.add(oppPart2);
    
            Opportunity_Part__c oppPart3 = new Opportunity_Part__c();
            oppPart3.Opportunity__c = opp1.Id;
            oppPart3.Part__c = part1.Id;
            oppPart3.Status__c = 'Lost';
            oppPart3.Lost_Reason__c = 'Other';
            oppPart3.Lost_Reason_Text__c = null;
            oppPart3.Similar_TE_Part_Number__c = part1.Id;
            oppPart3.GPL__c = prodH.Id;
            oppPart3.Cable_Assembly_Type__c = 'Fiber Optic';
            oppPart3.RecordTypeId = CSDOppPartrtId;
            //insert oppPart3;
            iOppyParts.add(oppPart3);
        
            insert iOppyParts;
        }
        catch(exception e){
            
        }
       }
        Test.stopTest();
    
     }
       
 }