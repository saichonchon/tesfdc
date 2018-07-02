/**
 * test class for class InventoryTrgHandler
 *
 * @author    Tangyong Li
 * @created   2017-09-20
 * @version   1.0
 * @since     38.0 (Force.com ApiVersion)
 *
 * @changelog
 * 2017-09-20 Tangyong Li <tangyong.li@capgemini.com>
 * - Created
 */
@isTest
public class InventoryTrgHandlerTest {
    
    static testMethod void mtUnitTest() {
        User u = ClsTestHelp.createTestUsers();
        insert u;
        System.runAs(u) {
        	Product_Hierarchy__c ph = new Product_Hierarchy__c();
        	insert ph;
        	 
        	Part__c part = new Part__c();
        	part.Name = 'test';
        	part.Product_Hierarchy__c = ph.Id;
        	insert part;
        	
        	Inventory__c inven = new Inventory__c();
        	inven.Part_Number__c = part.Name;
        	insert inven;
        	inven = [SELECT PartNbr__c FROM Inventory__c WHERE Id =: inven.Id limit 1];
        	system.assert(inven.PartNbr__c == part.Id);
        }
    }
    
}