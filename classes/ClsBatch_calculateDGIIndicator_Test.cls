/**
*  This test class used to test class ClsBatch_calculateDGIIndicator.
*
@author Jinbo Shan
@created 2014-06-25
@version 1.0   
@since 29.0
*
@changelog
* coverage  86%
* 
* 
2014-06-25 Jinbo Shan <weihang.li@itbconsult.com>
* - Created
*/
@isTest(SeeAllData = true)
private class ClsBatch_calculateDGIIndicator_Test {

    static testMethod void myUnitTest() {
        Profile p = [Select Id, Name From Profile 
                     where Name ='System Administrator' 
                     or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'hellosManedsfd@testCompany1233423.com';
        u.Alias = 'dpses';
        u.UserName = 'test@dsfds.con.tested';
        u.CommunityNickname = 'NNND';
        u.ProfileId = p.Id;
        insert u;
              
        system.runAs(u){ 
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Request_Type__c = 'Cable Assembly';
            insert oppy;
            
            Product_Hierarchy__c ph = new Product_Hierarchy__c();
            ph.Hierarchy_Level_Type__c = 'CBC1';
            ph.Description__c = 'Industrial';
            insert ph;
            Product_Hierarchy__c ph1 =[select Id,Hierarchy_Level_Type__c,Description__c, GDI_Classification__c from Product_Hierarchy__c where Id = : ph.Id];
            Part__c part = new Part__c();
            part.Description__c = 'Proposal Part';
            part.Product_Hierarchy__c = ph1.Id;
            insert part;
            
            Opportunity_Part__c oppPart = new Opportunity_Part__c();
            oppPart.GPL__c = ph.Id;
            oppPart.Part__c = part.Id;
            oppPart.Opportunity__c = oppy.Id;
            insert oppPart;
        
            ClsBatch_calculateDGIIndicator cls = new ClsBatch_calculateDGIIndicator();
            cls.filter = ' where Id = \'' + oppy.Id + '\'';
            database.executeBatch(cls);
            
            ph1.GDI_Classification__c = 'Invest';
            update ph1;
            
            ClsBatch_calculateDGIIndicator cls1 = new ClsBatch_calculateDGIIndicator();
            cls1.filter = ' where Id = \'' + oppy.Id + '\'';
            database.executeBatch(cls1);
            
            ph1.GDI_Classification__c = 'Grow';
            update ph1;
            
            ClsBatch_calculateDGIIndicator cls2 = new ClsBatch_calculateDGIIndicator();
            cls2.filter = ' where Id = \'' + oppy.Id + '\'';
            database.executeBatch(cls2);
        }
    }
}