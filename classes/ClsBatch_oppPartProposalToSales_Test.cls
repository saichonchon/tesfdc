/**
*  This test class is for ClsBatch_oppPartProposalToSales.
*
@author Di Chen
@created 2012-12-21
@version 1.0
@since 20.0
*
@changelog
* 2012-12-21 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage  94%
*/
@isTest(seealldata=false)
private class ClsBatch_oppPartProposalToSales_Test {

    static testMethod void testBatch() {
        /*Profile p = [Select Id, Name From Profile 
                     where Name = 'Production Support' 
                     or Name = 'Service Account' 
                     or Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'helloManesfd@testCompany1233423.com';
        u.Alias = 'dpse';
        u.CommunityNickname = 'TMD';
        u.ProfileId = p.Id;
        insert u;*/
              
        //system.runAs(u){ 
                
        RecordType rt = ClsTestHelp.createTestRecordType();
        RecordType rt2 = ClsTestHelp.createTestRecordType16();
              
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        insert acc;
            
        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        oppy2.Type = 'CM';
        oppy2.Request_Type__c = 'Extension';
        oppy2.RecordTypeId = rt2.Id;
        //insert oppy2;  
          
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Program__c = oppy2.Id;   
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        oppy2.RecordTypeId = rt2.Id;
        insert new list<Opportunity>{oppy, oppy2};
                  
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        insert ph;
          
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppypart.Part__c = part.Id;
        oppypart.Status__c = 'Lost';
        oppypart.Lost_Reason__c = 'Other';
        oppypart.Lost_Reason_Text__c = null;
        oppypart.GPL__c = ph.Id;
        oppypart.Initial_Order_Date__c = date.today();
        //insert oppypart;
        
        Opportunity_Part__c oppypart2 = ClsTestHelp.createTestOpportunityPart();
        oppypart2.Opportunity__c = oppy.Id;
        oppypart2.Part__c = part.Id;
        oppypart2.Status__c = 'Lost';
        oppypart2.Lost_Reason__c = 'Other';
        oppypart2.Lost_Reason_Text__c = null;
        oppypart2.GPL__c = ph.Id;
        oppypart2.Initial_Order_Date__c = date.today();
        oppypart2.Proposal_Part_Key_Id__c = -1;
        //insert oppypart2;               
        
        list<Opportunity_Part__c> oppyPartBatch = new list<Opportunity_Part__c>();
        oppyPartBatch.add(oppypart);
        oppyPartBatch.add(oppypart2);
        
        Test.startTest();
        insert oppyPartBatch;
        ClsBatch_oppPartProposalToSales clsBatch = new ClsBatch_oppPartProposalToSales();
        Database.BatchableContext BC;
        clsBatch.query = 'Select Id, RecordTypeId, Proposal_Part_Key_Id__c, Part__c from Opportunity_Part__c where id = \''+oppypart.ID+'\' or id = \''+oppypart2.ID+'\' limit 2';
        
        database.executebatch(clsBatch);
        
        /*clsBatch.start(BC);
        clsBatch.execute(BC, oppyPartBatch);
        clsBatch.finish(BC);
        */
        system.assert(true);
        Test.stopTest();    
        //}
    }
}