/***  This test class is for ClsBatch_DeleteDailyBBBBacklogRecords.
*@author Toshi @created 2013-07-18@version 1.0
*@changelog
* 2013-07-18 Toshi <toshi.darode@zensar.in>* - Created
* - Test coverage 92%
*/
@isTest(SeeAllData = True)
public class ClsBatch_DeleteDailyBBB_Test {

    static testMethod void testBatch() {
        
       // Id systemAdminProfileId = Apex_Helper_Settings__c.getInstance('Service Account Profile Id').Value__c;
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
        bbb.Customer_Request_Date__c = date.today();
        bbb.Current_Schedule_Date__c = date.today();
        bbb.Transaction_Date__c = date.today()-600;
        bbb.Backlog_Amount_USD__c = 100;
        insert bbb;     
         
        list<BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c> list_bbbDailyBookingBillingBacklog = new list<BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c>();
        list_bbbDailyBookingBillingBacklog.add(bbb);
                        
        Test.startTest();
                        
            ClsBatch_DeleteDailyBBBBacklogRecords b = new ClsBatch_DeleteDailyBBBBacklogRecords();
            Database.executeBatch(b, 50);
        
        Test.stoptest();
        }
}