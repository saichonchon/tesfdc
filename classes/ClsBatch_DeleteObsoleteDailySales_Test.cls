/***  This test class is for ClsBatch_DeleteObsoleteDailySales.
*/
@isTest(SeeAllData = True)
public class ClsBatch_DeleteObsoleteDailySales_Test {

    static testMethod void testBatch() {
        
        Account acc = new Account();
        acc.Name = 'AMP Foundries Inc';
        acc.AnnualRevenue = 2000000.11; 
        acc.Legally_Restricted__c = false;  
        acc.BillingCity = 'Musterstadt';
        acc.BillingStreet = 'Teststr. 1';
        acc.BillingCountry = 'German';
        acc.Type = 'Distributor';
        acc.BillingPostalCode = '77777';
        acc.AccountNumber = '';  
        acc.Industry_Code_Description__c = 'Appliances';
        insert acc;
                 
        Product_Hierarchy__c ph = new Product_Hierarchy__c(); 
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        insert ph;
                
        Part__c part = new Part__c();
        part.Description__c = 'Sniper'; 
        part.Product_Hierarchy__c = ph.Id;  
        insert part;   
         
        BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c bbb = new BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c();
        bbb.Customer__c = acc.Id;
        bbb.Part__c = part.Id;
        bbb.Obsolete__c=true;

        insert bbb;     
         
        list<BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c> list_BBB= new list<BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c>();
        list_BBB.add(bbb);
                        
        Test.startTest();
                        
            ClsBatch_DeleteObsoleteDailySales b = new ClsBatch_DeleteObsoleteDailySales();
            Database.executeBatch(b, 50);
        
        Test.stoptest();
        }
}