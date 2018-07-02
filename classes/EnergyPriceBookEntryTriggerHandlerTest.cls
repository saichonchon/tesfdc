/**
 * Test class for EnergyPriceBookEntryTriggerHandler.
 * 
 * @author      Tangyong Li
 * @created     2017-10-25
 * @since       38.0 (Force.com ApiVersion)
 * @version     1.0
 * 
 * @changelog
 * 2017-10-25   Tangyong Li <tangyong.li@capgemini.com>
 * - Created
 */
@isTest
public class EnergyPriceBookEntryTriggerHandlerTest {
    
    static testMethod void mtUnitTest() {
        User u = ClsTestHelp.createTestUsers();
        insert u;
        System.runAs(u) {
        	Product_Hierarchy__c p = new Product_Hierarchy__c();
        	insert p;
        	
        	Part__c part = new Part__c();
        	part.Name = 'test';
        	part.Product_Hierarchy__c = p.Id;
        	insert part;
        	
        	Test.startTest();
        	Energy_Price_Book_Entry__c epbe = new Energy_Price_Book_Entry__c();
        	epbe.Name = 'test';
        	insert epbe;
        	
        	epbe = [SELECT Id, Part__c FROM Energy_Price_Book_Entry__c WHERE Id =: epbe.Id limit 1];
        	Test.stopTest();
        }
    }
    
}