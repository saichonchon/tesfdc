/**
 * test class for class ProductHierarchyTrgHandler
 *
 * @author     Tangyong Li
 * @created    2017-08-23
 * @version    1.0
 * @since      38.0 (Force.com ApiVersion)
 *
 * @changelog
 * 2017-08-23  Tangyong Li <tangyong.li@capgemini.com>
 * - Created
 */
@isTest
public class ProductHierarchyTrgHandlerTest {
    
    static testMethod void myUnitTest() {
        User u = ClsTestHelp.createTestUsers();
        insert u;
        System.runAs(u) {
        	Test.startTest();
        	Product_Hierarchy__c ph1 = new Product_Hierarchy__c();
        	ph1.Name = 'Test1 Name';
        	ph1.CBC1_Description__c = 'ENERGY';
        	insert ph1;
        	Product_Hierarchy__c ph2 = new Product_Hierarchy__c();
        	ph2.Name = 'Test2 Name';
        	ph2.CBC1_Description__c = 'ENERGY';
        	insert ph2;
        	list<Part__c> list_parts1 = [SELECT Id, Product_Hierarchy__c FROM Part__c WHERE Product_Hierarchy__c =: ph1.Id];
        	system.assert(list_parts1.size() == 1);
        	ph1.Name = 'Test11 Name';
        	update ph1;
        	Part__c part = [SELECT Id, Product_Hierarchy__c FROM Part__c WHERE Product_Hierarchy__c =: ph2.Id];
        	delete part;
        	ph1.Name = 'Test22 Name';
        	update ph2;
        	list<Part__c> list_parts2 = [SELECT Id, Product_Hierarchy__c FROM Part__c WHERE Product_Hierarchy__c =: ph2.Id];
        	system.assert(list_parts2.size() == 1);
        	Test.stopTest();
        }
    }
    
}