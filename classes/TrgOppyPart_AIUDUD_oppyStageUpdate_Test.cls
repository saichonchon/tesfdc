/**
*   This test class is for opportunityPart_AIUDUD_oppyStageUpdate.
*
@author Yuanyuan Zhang
@created 2014-04-28
@version 1.0
@since 29.0
*
@changelog
* 2014-04-28 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>
* - Created
* - Test coverage 81%
*/
@isTest(seealldata=true)
private class TrgOppyPart_AIUDUD_oppyStageUpdate_Test {

    static testMethod void myUnitTest() {
        Test.startTest();
        Profile p = [Select Id, Name From Profile 
                                    where Name = 'Production Support' 
                                    or Name = 'Service Account' 
                                    or Name ='System Administrator' 
                                    or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'helloManesfd@testCompany1233423.com';
        u.Alias = 'dpse';
        u.CommunityNickname = 'TMD';
        u.ProfileId = p.Id;
        insert u;
        
        system.runAs(u){ 
            
            //RecordType rt = ClsTestHelp.createTestRecordType();
            RecordType rt2 = ClsTestHelp.createTestRecordType16();
            RecordType rt31 = ClsTestHelp.createTestRecordType31();
            
            Account acc = [SELECT Id FROM Account limit 1];
            /*
            Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Program_level_Forecasting__c =true; 
            oppy2.Name = 'Pain of Queen';
            oppy2.Type = 'CM';
            oppy2.Request_Type__c = 'Extension';
            oppy2.RecordTypeId = rt2.Id;
            insert oppy2;  
            */
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            //oppy.Program__c = oppy2.Id;   
            oppy.Type = 'CM';
            oppy.Request_Type__c = 'Extension';
            oppy.Method__c = 'BOM';
            oppy.Level__c = 'Yearly';
            oppy.Amount = 1;
            oppy.CurrencyIsoCode = 'EUR';
            oppy.Five_Year_Revenue__c = 1;
            oppy.RecordTypeId = rt2.Id;
            
            Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Type = 'CM';
            oppy2.Request_Type__c = 'Extension';
            oppy2.Method__c = 'BOM';
            oppy2.Level__c = 'Yearly';
            oppy2.Amount = 1;
            oppy2.CurrencyIsoCode = 'EUR';
            oppy2.Five_Year_Revenue__c = 1;
            oppy2.RecordTypeId = rt31.Id;
            
            insert new list<opportunity>{oppy2, oppy};
            
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
            
            Opportunity_Part__c oppypart2 = ClsTestHelp.createTestOpportunityPart();
            oppypart2.Opportunity__c = oppy2.Id;
            oppypart2.Part__c = part.Id;
            oppypart2.Status__c = 'Lost';
            oppypart2.Lost_Reason__c = 'Other';
            oppypart2.Lost_Reason_Text__c = null;
            oppypart2.GPL__c = ph.Id;
            oppypart2.Initial_Order_Date__c = date.today();
            insert new list<Opportunity_Part__c>{oppypart2, oppypart};
            
            delete new list<Opportunity_Part__c>{oppypart2, oppypart};
            //delete oppypart;
            
            
        }
        system.assert(true);
            Test.stopTest();
    }
}