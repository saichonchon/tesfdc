/*------------------------------------------------------------
Author:        Buwen Guo <buwen.guo@capgemini.com>
Description:   test class for handle class: ClsMTOHighRunnerTriggerHandler.
			   The user story number is W-00152.
Inputs:        
History
2017-07-28 	Buwen Guo <buwen.guo@capgemini.com> created
------------------------------------------------------------*/
@isTest
public with sharing class ClsMTOHighRunnerTriggerHandlerTest {
    
    static testMethod void testMethod1() {
        User u = ClsTestHelp.createTestUsers();
        u.Te_Network_Id__c = '0529';
        insert u;
        System.runAs(u) {
            Sales_Hierarchy__c sh7 = ClsTestHelp.createTestSalesHierarchy();
            sh7.Level_7_Territory_Code__c = 'A007357';
            sh7.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
            sh7.Level_7_Default_Owner__c = u.Id;
            sh7.Level_7_Assigned_Users__c = u.Id;
            sh7.Level_7_Assigned_User_Network_Ids__c = u.Te_Network_Id__c;
            insert sh7;
            
            Test.startTest();
    		MTO_High_Runner__c mto = ClsTestHelp.createTestMTOHighRunner();
            mto.Level_7_Territory_Code__c = 'A007357';
			insert mto;
            
            list<MTO_High_Runner__c> list_mto = new list<MTO_High_Runner__c>();
            ClsWrappers.TriggerContext trgCtx = new ClsWrappers.TriggerContext();
            trgCtx.isBefore = true;
            trgCtx.isInsert = true;
            trgCtx.newList = new List<MTO_High_Runner__c>{mto};
    
            
            ClsMTOHighRunnerTriggerHandler.populateOwnerFromSalesHierarchy(trgCtx);
    
            Test.stopTest();  
        }
    }
}