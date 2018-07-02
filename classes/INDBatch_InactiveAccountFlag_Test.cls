/**
*  This test class used to test class INDBatch_InactiveAccountFlag.
*
@author Deepak Kumar
@created 20th Jan 2015
@version 1.0
@since 30.0
*
@changelog
* coverage 85% 
* 
* 
2014-09-28  Deepak Kumar (deepak.kumar89@te.com)
* - Created
2015-02-05  Mrunal Parate
  - Modified to fix the failure of test class and increased coverage to 89%
*/
@isTest(SeeAllData=true)
private class INDBatch_InactiveAccountFlag_Test {
  static testMethod void myUnitTest() {
    Test.startTest();  
    List<Account> alist = new List<account>();       
    Account ablank = new account();
    Account a = new account();
    a.Name= 'test account';
    a.RecordTypeId='012E0000000I9EG';
    a.STATDESC__c= 'Not Active';
    a.BillingCountry = 'US';
   // a.Customer_Industry__c= 'IB';
   // insert a;
    Account a2 = new account(Name= 'atest account',RecordTypeId='012E0000000I9EG',STATDESC__c= 'Not Active',BillingCountry = 'US');
    Account a3 = new account(Name= 'stest account',RecordTypeId='012E0000000I9EG',STATDESC__c= 'Not Active',BillingCountry = 'US');
    Account a4 = new account(Name= 'dtest account',RecordTypeId='012E0000000I9EG',STATDESC__c= 'Not Active',BillingCountry = 'US');
    Account a5 = new account(Name= 'ftest account',RecordTypeId='012E0000000I9EG',STATDESC__c= 'Not Active',BillingCountry = 'US');
    Account a6 = new account(Name= 'gtest account',RecordTypeId='012E0000000I9EG',STATDESC__c= 'Not Active',BillingCountry = 'US');
    Account a7 = new account(Name= 'htest account',RecordTypeId='012E0000000I9EG',STATDESC__c= 'Not Active',BillingCountry = 'US');
    Account a8 = new account(Name= 'jtest account',RecordTypeId='012E0000000I9EG',STATDESC__c= 'Not Active',BillingCountry = 'US');
    Account a9 = new account(Name= 'ktest account',RecordTypeId='012E0000000I9EG',STATDESC__c= 'Not Active',BillingCountry = 'US');
    Account a10 = new account(Name= 'ltest account',RecordTypeId='012E0000000I9EG',STATDESC__c= 'Not Active',BillingCountry = 'US');
    Account a11 = new account(Name= 'mtest account',RecordTypeId='012E0000000I9EG',STATDESC__c= 'Not Active',BillingCountry = 'US');
    Account a12 = new account(Name= 'ntest account',RecordTypeId='012E0000000I9EG',STATDESC__c= 'Not Active',BillingCountry = 'US');
    Account a13 = new account(Name= 'btest account',RecordTypeId='012E0000000I9EG',STATDESC__c= 'Not Active',BillingCountry = 'US');
    alist.add(a);
    alist.add(a2);
    alist.add(a3);
    alist.add(a4);
    alist.add(a5);
    alist.add(a6);
    alist.add(a7);
    alist.add(a8);
    alist.add(a9);
    alist.add(a10);
    alist.add(a11);
    alist.add(a12);
    alist.add(a13);
    
    insert alist;
    //########################################################################################################## 
    opportunity opp = new opportunity(name='test',AccountID=a.id,Type='New Business', Request_Type__c= 'sales only',Description__c='test',stagename = 'new',closedate = date.today()+5, Currency_Confirm__c = true);
    insert opp;
    Contact conta= new contact(lastname= 'test',AccountID=a9.id);
    insert conta;
    OEM_Details__c oem = new OEM_Details__c(OEM__c=a2.id,Billing__c=33,Cutoff_Date__c='12',Fiscal_Year__c='2015');
    insert oem;
    
    Quote__c qq =new Quote__c(name='test',Account__c=a3.id);
    insert qq;
    Entitlement ee= new Entitlement(name='test',AccountID=a4.id);
    insert ee;
    AccountContactRole contarole= new AccountContactRole(AccountId=a12.id,ContactId=conta.id);
    insert contarole;
    case ccc = new case(AccountId=a11.id);
    insert ccc;
    
    Product_Hierarchy__c gpl = new Product_Hierarchy__c(name='test gpl');
    insert gpl;
    Part__c pp = new Part__c(name='test part',Product_Hierarchy__c=gpl.id);
    insert pp;
    Scheduled_Agreements__c SchA = new Scheduled_Agreements__c(Sold_To_Customer__c=a10.id,Part__c=pp.id);
    insert SchA;
    BBB_Year_Bill_Book_Cust_PN__c yearly = new BBB_Year_Bill_Book_Cust_PN__c(Part__c=pp.id,Customer__c=a5.id);
    insert yearly;
    BBB_Month_Bill_Book_Cust__c monthly = new BBB_Month_Bill_Book_Cust__c(Customer__c=a6.id);
    insert monthly;
    BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c daily = new BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c(Part__c=pp.id,Customer__c=a7.id);
    insert daily;
    BBB_Month_Bill_Book_Cust_PN__c monpp = new BBB_Month_Bill_Book_Cust_PN__c(Part__c=pp.id,Customer__c=a8.id);
    insert monpp;
    Delivery_Performance__c delper= new Delivery_Performance__c(name='test',Account__c=a13.id,Part__c=pp.id);
    insert delper;
    
  //****************************************************************************************************************  
    ablank.name= 'test account blank';
    ablank.RecordTypeId='012E0000000I9EG';
    ablank.STATDESC__c= 'Not Active';
   // ablank.Customer_Industry__c= 'IB';
    insert ablank;
    
    Set<id> passid = new Set<id>();
    passid.add(ablank.id);
    passid.add(a.id);
    
        
    INDBatch_InactiveAccountFlag vBatch= new INDBatch_InactiveAccountFlag();
    Id batchInstanceId = Database.executeBatch(vBatch, 100);
    
    //INDBatch_InactiveAccountFlag4Cases vBatchMonthly= new INDBatch_InactiveAccountFlag4Cases(alist);
    //Id batchInstanceId2 = Database.executeBatch(vBatchMonthly, 100);
    
   // INDBatch_InactiveAccountFlag4Yearly vBatchYerly= new INDBatch_InactiveAccountFlag4Yearly(passid);
   // Id batchInstanceId3 = Database.executeBatch(vBatchYerly, 100);
    
    
    Test.stopTest();   
    }
  }