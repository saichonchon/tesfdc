/***  This test class is for ClsBatch_DeleteObsoleteMonthlySales.
*/
@isTest(SeeAllData = True)
public class ClsBatch_DeleteObsoleteMonthlySales_Test {

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
                         
 
         
        BBB_Month_Bill_Book_Cust__c bbb = new BBB_Month_Bill_Book_Cust__c();
        bbb.Customer__c = acc.Id;
        bbb.Obsolete__c=true;

        insert bbb;     
         
        list<BBB_Month_Bill_Book_Cust__c > list_BBB= new list<BBB_Month_Bill_Book_Cust__c >();
        list_BBB.add(bbb);
                        
        Test.startTest();
                        
            ClsBatch_DeleteObsoleteMonthlySales b = new ClsBatch_DeleteObsoleteMonthlySales();
            Database.executeBatch(b, 50);
        
        Test.stoptest();
        }
}