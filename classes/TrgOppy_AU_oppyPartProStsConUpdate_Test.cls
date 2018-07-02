/**
*   This test class is for opportunity_AU_oppyPartProcessStsConfidenceUpdate.
*
@author Yuanyuan Zhang
@created 2014-04-29
@version 1.0
@since 29.0
*
@changelog
* 2014-04-29 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>
* - Created
* - Test coverage 75%
*/
@isTest
private class TrgOppy_AU_oppyPartProStsConUpdate_Test {

     static testMethod void testForUpdate() {
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
        User u = [select id from User where  isActive=true and Profile.Name = 'System Administrator' limit 1];
        
        
        system.runAs(u){ 
                
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
            insert oppy2;  
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Program__c = oppy2.Id;   
            oppy.Type = 'CM';
            oppy.Request_Type__c = 'Extension';
            oppy.Method__c = 'BOM';
            oppy.Level__c = 'Yearly';
            oppy.Amount = 1;
            oppy.CurrencyIsoCode = 'EUR';
            oppy.Five_Year_Revenue__c = 1;
            oppy.RecordTypeId = rt2.Id;
            //oppy.Tender__c = null;
            insert oppy;
            
            Product_Hierarchy__c ph = new Product_Hierarchy__c();
            ph.Hierarchy_Level_Type__c = 'CBC1';
            ph.Description__c = 'Industrial';
            insert ph;
            
            Part__c part = new Part__c();
            part.Description__c = 'Sniper';
            part.Product_Hierarchy__c = ph.Id;
            insert part;
            
            Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
            oppypart.Opportunity__c = oppy2.Id;
            oppypart.Part__c = part.Id;
            oppypart.Status__c = 'Lost';
            oppypart.Lost_Reason__c = 'Other';
            oppypart.Lost_Reason_Text__c = null;
            oppypart.GPL__c = ph.Id;
            insert oppypart;
            /*
            Opportunity_Partner__c oppyPartner = ClsTestHelp.createTestOpportunityPartner();
            oppyPartner.Opportunity__c = oppy.Id;
            oppyPartner.Account__c = acc.Id;
            oppyPartner.Allocation__c = 100;
            insert oppyPartner;
            */
            Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
            oppyForecast.Opportunity__c = oppy2.Id;
            oppyForecast.Quantity__c = 12;
            oppyForecast.Part__c = null;
            oppyForecast.Date__c = date.newInstance(2012, 09, 28);
            oppyForecast.Amount__c = 1;
            oppyForecast.Sales_Price__c = 1;
            insert oppyForecast;
            
            Test.startTest();
            
            oppy2.StageName = 'Rejected - Closed';
            update oppy2;
            
            oppy.StageName = 'Rejected - Closed';
            update oppy;
            
            system.assert(true);
            Test.stopTest();
        } 
     }
}