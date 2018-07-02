/*****************************************************************************************************************************************
Name: ACP_TestDataFactory
Copyright © 2017 TE Connectivity
==========================================================================================================================================
Requirement:
Test Data Factory to create test Data for all Account Plan Test classes, and can be used for future reference.
==========================================================================================================================================
Purpose:
Allows developers to use this DataFactory to create test data in their respective test classes
==========================================================================================================================================
History
-------
VERSION     AUTHOR                       DATE                              DETAIL
1.0        Hariharan Viswanathan        4/30/2017        Created this ACP_TestDataFactory test class to create test data for all Account Plan test classes
2.0        Anushka Bansal               --------         Written following methods createUser(String ProfileName, String GIBU), createUser(), createGAMAccount(),createAccount() 
                                                         createOpportunity(), createContact(), createAccountPlan(), createPart(), createProduct(), createMonthBB(Integer numberOfMonthBB),
                                                         createMarketCompetition(Integer numberOfRecords, string RecordTypeName), createMarketCompetition(Integer numberOfRecords, string RecordTypeName),
                                                         createsupplierRatings(Integer numberOfratings), createsupplierEvaluation(Integer numberOfeval),createTask(String Category, Id acpId, Integer numberOfRec, String status),
                                                         createTask2(String Category, Id acpId, Integer numberOfRec, String status),createAttachment(), createStakeholderRelationship(Integer num, String relation, Id acpid),
                                                         createCustomerOver(Id acpid, String recordtype),createProduct2(),createMonthlyBBB(String fiscalyr, Integer fiscalMonth, String accId), createYearlyBBB(String cbcValue, String actType, Id accId)
3.0        Rithika Pahwa                ---------        Written createStrategy(Integer numberOfStrategy), createCustomerOver(Id acpid, String recordtype),
                                                         createACPRevenueGrowthPerfBooking(), createACPRevenueGrowthPerfBilling() methods to create test data
4.0        Haripriya Maturi             8/16/2017        Written createOppTamRevenue(Id acpid, String CBCValue), createOppTamReport(Report report) methods to create test data
5.0        Esther Ethelbert             11/2/2007        Written createPlatCont() method to create test data

List of Methods defined in this TestDataFactory
-----------------------------------------------

*******************************************************************************************************************************************
Method Name                                                                 
*******************************************************************************************************************************************

1. createUser(String ProfileName, String GIBU)

2. createUser()

3. createGAMAccount()

4. createAccount()

5. createOpportunity()

6. createContact()

7. createAccountPlan()

8. createPart()

9. createProduct()

10. createMonthBB(Integer numberOfMonthBB)

11. createMarketCompetition(Integer numberOfRecords, string RecordTypeName)

12. createsupplierRatings(Integer numberOfratings)

13. createsupplierEvaluation(Integer numberOfeval)

14. createTask(String Category, Id acpId, Integer numberOfRec, String status)

15. createACPRevenueGrowthPerfBilling()

16. createACPRevenueGrowthPerfBooking()

17. createTask2(String Category, Id acpId, Integer numberOfRec, String status)

18. createAttachment()

19. createStrategy(Integer numberOfStrategy)

20. createStakeholderRelationship(Integer num, String relation, Id acpid)

21. createCustomerOver(Id acpid, String recordtype)

22. createProduct2()

23. createOppTamRevenue(Id acpid, String CBCValue)

24. createOppTamReport(Report report)

25. createMonthlyBBB(String fiscalyr, Integer fiscalMonth, String accId)

26. createYearlyBBB(String cbcValue, String actType, Id accId)

27. createPlatCont()

*******************************************************************************************************************************************/



@isTest
public class ACP_TestDataFactory {

 public static User createUser(String ProfileName, String GIBU) {
  try {
   Profile p = [Select Id, Name From Profile
    where Name = : ProfileName limit 1
   ];

   User acpUser = new User();
   acpUser.FirstName = 'FirstName';
   acpUser.LastName = 'TesterName';
   acpUser.Email = 'testme@acpmail.com';
   acpUser.username = 'testme@acpmail.com';
   acpUser.Alias = 'SFTest';
   acpUser.ProfileId = p.Id;
   acpUser.IsActive = true;
   acpUser.TimeZoneSidKey = 'America/Chicago';
   acpUser.LocaleSidKey = 'en_US';
   acpUser.EmailEncodingKey = 'UTF-8';
   acpUser.LanguageLocaleKey = 'en_US';
   acpUser.GIBU__c = GIBU;
   insert acpUser;
   return acpUser;
  }
  Catch(Exception e) {
   System.debug('Exception occured:' + e.getMessage());
   return null;
  }
 }
 public static User createUser() {
  User u = ClsTestHelp.createTestUsers();
  insert u;
  ClsTestCustomSettingHelper.getApex_Helper_Settings();
  ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
  return u;
 }


 /* -------------------- create a GAM Account ------------------------------------------------*/
 public static Account createGAMAccount() {
  //User u = ACP_TestDataFactory.createUser(); 
  Consumer_Device_Opportunity_Record_Types__c CDORT = ClsTestHelp.createTestCSD7();

  Consumer_Device_Opportunity_Record_Types__c CDORT1 = ClsTestHelp.createTestCSD3();
  Consumer_Device_Opportunity_Record_Types__c CDORT2 = ClsTestHelp.createTestCSD1();
  ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
  ClsTestCustomSettingHelper.getApex_Helper_Settings();
  ClsTestCustomSettingHelper.getADMTerritoryCode();
  RecordType rt1 = ClsTestHelp.createTestRecordType();

  Account acc1 = ClsTestHelp.createTestAccounts();
  acc1.RecordTypeId = rt1.Id;
  //acc1.Account_Manager__c = u.Id;
  //acc1.OwnerId = u.Id;
  insert acc1;
  return acc1;

 }
 public static Account createAccount() {
  User u = ClsTestHelp.createTestUsers();
  insert u;
  Consumer_Device_Opportunity_Record_Types__c CDORT = ClsTestHelp.createTestCSD7();

  Consumer_Device_Opportunity_Record_Types__c CDORT1 = ClsTestHelp.createTestCSD3();
  Consumer_Device_Opportunity_Record_Types__c CDORT2 = ClsTestHelp.createTestCSD1();
  //ClsTestHelp.createTestOPTG1();
  ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
  ClsTestCustomSettingHelper.getADMTerritoryCode();
  ClsTestCustomSettingHelper.getApex_Helper_Settings();
  RecordType rt1 = ClsTestHelp.createTestRecordType();
  Account acc1 = ClsTestHelp.createTestAccounts();
  acc1.RecordTypeId = rt1.Id;
  acc1.Account_Manager__c = u.Id;
  acc1.OwnerId = u.Id;
  return acc1;

 }


 public static Opportunity createOpportunity() {

  User u = ClsTestHelp.createtestUsers();
  insert u;
  Consumer_Device_Opportunity_Record_Types__c CDORT = ClsTestHelp.createTestCSD7();

  Consumer_Device_Opportunity_Record_Types__c CDORT1 = ClsTestHelp.createTestCSD3();
  Consumer_Device_Opportunity_Record_Types__c CDORT2 = ClsTestHelp.createTestCSD1();
  ClsTestCustomSettingHelper.getTrigger_Configuration();
  ClsTestCustomSettingHelper.getProfitBUCenterMapping();
  ClsTestCustomSettingHelper.getApex_Helper_Settings();
  ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
  ClsTestCustomSettingHelper.getOpportunity_Approvers();
  ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();


  RecordType rt = Clstesthelp.createTestRecordType7();
  //createPMVTestRecordType3
  Opportunity oppy = ClsTestHelp.createTestOpportunity();
  oppy.Type = 'CM';
  oppy.RecordTypeId = rt.Id;
  oppy.Approval_Status_PMV__c = 'New';
  oppy.PMV_Type__c = 'IND Standard ENG opp';
  oppy.StageName = 'On Hold';
  oppy.OwnerId = u.Id;
  oppy.PMV_Migration_Setup__c = 'OnHold';
  oppy.Name = 'tnte';
  return oppy;

 }

 public static Contact createContact() {
  try {


   Contact contact = ClsTestHelp.createTestContacts();

   return contact;

  }
  Catch(Exception e) {
   System.debug('Exception occured:' + e.getMessage());
   return null;
  }
 }


 public static ACP_Account_Plan__c createAccountPlan() {

  ACP_Account_Plan__c newAccPlan = new ACP_Account_Plan__c(
   Name = 'TestAccountPlan357',
   // ACP_Account_Name__c = account.Id,
   // Account_Plan_Type__c = 'GAM Account',//added by Haripriya
   ACP_Customer_Strategy_Summary__c = 'TestAccountPlan3564');
  return (newAccPlan);

 }

 /* --------------------------------------------------Create Part---------------------------------- */
 public static Part__c createPart() {
   try {
    Product_Hierarchy__c newProduct = ACP_TestDataFactory.createProduct();
    Id productId = newProduct.Id;

    Part__c newPart = new Part__c(
     Name = 'Part123',
     Product_Hierarchy__c = productId
    );
    Insert(newPart);
    return (newPart);
   }
   Catch(Exception e) {
    System.debug('Exception occured: 10' + e.getMessage());
    return null;
   }
  }
  /*  -------------------------------- create product ----------------------------- */
 public static Product_Hierarchy__c createProduct() {
  try {
   Product_Hierarchy__c newProduct = new Product_Hierarchy__c(
    Name = 'T13',
    CBC1__c = '30007',
    CBC2__c = '30007',
    CBC3__c = '30007',
    CBC4__c = '30007',
    CBC5__c = '30007',
    CBC1_Description__c = 'Appliances',
    CBC2_Description__c = 'TUBING',
    CBC3_Description__c = 'Tubing Materials',
    CBC4_Description__c = 'Tubing Materials',
    CBC5_Description__c = 'Tubing Materials'
   );
   Insert(newProduct);
   return (newProduct);
  }
  Catch(Exception e) {
   System.debug('Exception occured: 9' + e.getMessage());
   return null;
  }
 }


 public static List < BBB_Month_Bill_Book_Cust_PN__c > createMonthBB(Integer numberOfMonthBB) {
  // Create Account
  try {

   Part__c newPart = ACP_TestDataFactory.createPart();
   Id partId = newPart.Id;

   List < BBB_Month_Bill_Book_Cust_PN__c > MonthBB = new List < BBB_Month_Bill_Book_Cust_PN__c > ();

   for (Integer i = 0; i < numberOfMonthBB; i++) {
    BBB_Month_Bill_Book_Cust_PN__c newMonthBB = new BBB_Month_Bill_Book_Cust_PN__c(

     Fiscal_Year__c = '2017',
     Bill_Amount_USD__c = 200,
     Part__c = partId
     //Customer__c =account.Id    
    );
    MonthBB.add(newMonthBB);
   }
   //Insert (MonthBB);
   return (MonthBB);
  }
  Catch(Exception e) {
   System.debug('Exception occured:  11' + e.getMessage());
   return null;
  }
 }

 public static List < ACP_Market_and_Competition__c > createMarketCompetition(Integer numberOfRecords, string RecordTypeName) {
  try {


   //Get Product Id
   Product_Hierarchy__c newProduct = ACP_TestDataFactory.createProduct();
   Id productId = newProduct.Id;

   RecordType rcdType = [Select Id, name from RecordType where Name = : RecordTypeName];
   Id recordId = rcdType.Id;



   List < ACP_Market_and_Competition__c > MarketCompetitions = new List < ACP_Market_and_Competition__c > ();

   if (RecordTypeName == 'General Market and Competition') {
    for (Integer i = 0; i < numberOfRecords; i++) {
     ACP_Market_and_Competition__c MarketCompetition = new ACP_Market_and_Competition__c(

      RecordTypeId = recordId,
      //ACP_Account_Plan__c = accPlanId,                 
      //   ACP_Main_Competitor__c = 'Test Account',
      ACP_Main_Competitor_Share__c = 14,
      ACP_Market_Share__c = 12,
      ACP_NY_Fcst__c = 20,
      ACP_PAM__c = 200,
      ACP_Product_CBC__c = productId,
      ACP_SAM__c = 200,
      ACP_TAM__c = 200,
      // ACP_Trending__c = 'Test',
      ACP_TE_Position__c = 'Flat',
      ACP_CBC__c = 'CBC1 - 30049 - Tubing Materials', //modified by Haripriya
      ACP_TAM_LY_Bill__c = 20.00,
      ACP_TAM_CYRR__c = 20.00,
      ACP_TAM_NY_Fcst__c = 20.00

     );


     MarketCompetitions.add(MarketCompetition);
    }

   }

   if (RecordTypeName == 'ADM Market and Competition') {
    for (Integer i = 0; i < numberOfRecords; i++) {
     ACP_Market_and_Competition__c MarketCompetition = new ACP_Market_and_Competition__c(

      RecordTypeId = recordId,
      //ACP_Account_Plan__c = accPlanId,

      ACP_Market_Share__c = 12,
      ACP_Product_CBC__c = productId,
      ACP_Product_Group__c = 'productgp',
      ACP_TAM__c = 200,
      ACP_Comments__c = 'Test',
      ACP_TE_Position__c = 'Flat',
      ACP_CBC__c = '13061 - COPPER'
     );


     MarketCompetitions.add(MarketCompetition);
    }

   }
   if (RecordTypeName == 'Appliance Breakdown') {
    for (Integer i = 0; i < numberOfRecords; i++) {
     ACP_Market_and_Competition__c MarketCompetition = new ACP_Market_and_Competition__c(

      RecordTypeId = recordId,
      //ACP_Account_Plan__c = accPlanId,
      ACP_CY_Bill_RR__c = 20,
      ACP_LY_Bill__c = 20,
      //   ACP_Main_Competitor__c = 'Test Account',
      ACP_Main_Competitor_Share__c = 14,
      ACP_Market_Share__c = 12,
      ACP_NY_Fcst__c = 20,
      ACP_PAM__c = 200,
      ACP_Product_CBC__c = productId,
      ACP_SAM__c = 200,
      ACP_TAM__c = 200,
      //  ACP_Trending__c = 'Test',
      ACP_TE_Position__c = 'Flat');


     MarketCompetitions.add(MarketCompetition);
    }
   }


   //insert(MarketCompetitions);
   return MarketCompetitions;
  }
  Catch(Exception e) {
   System.debug('Exception occured:' + e.getMessage());
   return null;
  }
 }

 public static List < ACP_TE_Suppliers_Rating__c > createsupplierRatings(Integer numberOfratings) {
  List < ACP_TE_Suppliers_Rating__c > supplierRatings = new List < ACP_TE_Suppliers_Rating__c > ();
  for (Integer i = 0; i < numberOfratings; i++) {

   ACP_TE_Suppliers_Rating__c newSuppRating = new ACP_TE_Suppliers_Rating__c(
    //ACP_Account_Plan__c = newAccPlan.id, 
    ACP_Relationship_Rating__c = 'Problem Solver',
    ACP_Year__c = '2017');
   supplierRatings.add(newSuppRating);

  }
  return supplierRatings;
 }

 public static List < ACP_TE_Supplier_Evaluation__c > createsupplierEvaluation(Integer numberOfeval) {
   List < ACP_TE_Supplier_Evaluation__c > supplierEvaluation = new List < ACP_TE_Supplier_Evaluation__c > ();
   for (Integer i = 0; i < numberOfeval; i++) {

    ACP_TE_Supplier_Evaluation__c newSuppEval = new ACP_TE_Supplier_Evaluation__c(
     //ACP_Account_Plan__c = newAccPlan.id, 
     ACP_Comments__c = 'Test Evaluation',
     ACP_Criteria__c = 'Logistics');
    supplierEvaluation.add(newSuppEval);

   }
   return supplierEvaluation;
  }
  /**************************************************Task Start***************************************************************/
 public static List < Task > createTask(String Category, Id acpId, Integer numberOfRec, String status) {
  system.debug('createTask method');
  try {
   Contact acpCon = ACP_TestDataFactory.createContact();
   insert acpCon;
   Id tskRecordType = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Account Plan').getRecordTypeId();
   List < Task > tskList = new List < Task > ();
   for (Integer i = 0; i < numberOfRec; i++) {
    Task acpTask = new Task(recordtypeid = tskRecordType, Subject = 'New Task Assigned' + i, whatid = acpId, Escalation_Reason__c = 'ACP New Task', ACP_Category__c = Category, whoId = acpCon.id, status = status);
    tskList.add(acpTask);
   }

   system.debug('task created ' + tskList);
   return tskList;
  }
  Catch(Exception e) {
   System.debug('Exception occured:' + e.getMessage());
   return null;
  }
 }

 public static ACP_Revenue_Growth_Perf__c createACPRevenueGrowthPerfBilling() {
  try {

   ACP_Revenue_Growth_Perf__c acprev = new ACP_Revenue_Growth_Perf__c();
   acprev.ACP_Past_year_Revenue__c = 58217;
   acprev.ACP_Past_Year_1_Revenue__c = 58889;
   acprev.ACP_Current_Year_to_Date__c = 23705;
   acprev.ACP_Current_Year_Run_Rate__c = 26251;
   //acprev.ACP_Account_Plan__c = accPlan.id;
   acprev.ACP_Sales_Mode__c = 'Direct';
   acprev.ACP_Refresh_Based_on__c = 'Billing';
   acprev.ACP_Project_1__c = 20;
   acprev.ACP_Project_2__c = 10;
   acprev.ACP_Project_3__c = 30;
   acprev.ACP_Project_4__c = 40;
   acprev.ACP_Project_5__c = 25;
   acprev.ACP_LY_Market_Growth__c = 25;
   acprev.ACP_LY_Price_Erosion__c = 25;
   acprev.ACP_Current_FY_Close__c = 25;
   acprev.ACP_Current_Year_1_Plan__c = 25;
   acprev.ACP_Current_Year_3_Plan__c = 25;
   acprev.ACP_Current_Year_5_Plan__c = 25;
   acprev.ACP_Current_FY_Base__c = 25;
   return acprev;

  }
  Catch(Exception e) {
   System.debug('Exception occured inside ACP_TestDataFactory:' + e.getMessage());
   return null;
  }
 }
 public static ACP_Revenue_Growth_Perf__c createACPRevenueGrowthPerfBooking() {
  try {

   ACP_Revenue_Growth_Perf__c acprev1 = new ACP_Revenue_Growth_Perf__c();
   acprev1.ACP_Past_year_Revenue__c = 0;
   acprev1.ACP_Past_Year_1_Revenue__c = 0;
   acprev1.ACP_Current_Year_to_Date__c = 0;
   acprev1.ACP_Current_Year_Run_Rate__c = 0;
   // acprev1.ACP_Account_Plan__c = accPlan.id;
   acprev1.ACP_Sales_Mode__c = 'Direct';
   acprev1.ACP_Refresh_Based_on__c = 'Booking';
   acprev1.ACP_Project_1__c = 0;
   acprev1.ACP_Project_2__c = 0;
   acprev1.ACP_Project_3__c = 0;
   acprev1.ACP_Project_4__c = 0;
   acprev1.ACP_Project_5__c = 0;
   acprev1.ACP_LY_Market_Growth__c = 0;
   acprev1.ACP_LY_Price_Erosion__c = 0;
   acprev1.ACP_Current_FY_Close__c = 0;
   acprev1.ACP_Current_Year_1_Plan__c = 0;
   acprev1.ACP_Current_Year_3_Plan__c = 0;
   acprev1.ACP_Current_Year_5_Plan__c = 0;
   acprev1.ACP_Current_FY_Base__c = 0;
   return acprev1;
  }
  Catch(Exception e) {
   System.debug('Exception occured inside ACP_TestDataFactory:' + e.getMessage());
   return null;
  }
 }

 public static List < Task > createTask2(String Category, Id acpId, Integer numberOfRec, String status) {
  system.debug('createTask method');
  try {
   // Contact acpCon = ACP_TestDataFactory.createContact();
   Id tskRecordType = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Account Plan').getRecordTypeId();
   List < Task > tskList = new List < Task > ();
   for (Integer i = 0; i < numberOfRec; i++) {
    Task acpTask = new Task(recordtypeid = tskRecordType, Subject = 'New Task Assigned' + i, whatid = acpId, Escalation_Reason__c = 'ACP New Task', ACP_Category__c = Category, status = status);
    tskList.add(acpTask);
   }
   system.debug('task created ' + tskList);
   return tskList;
  }
  Catch(Exception e) {
   System.debug('Exception occured:' + e.getMessage());
   return null;
  }
 }
 public static Attachment createAttachment() {
  try {

   Attachment attach = new Attachment();
   attach.Name = 'Unit.Test.Attachment';
   Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
   attach.body = bodyBlob;
   //attach.parentId=AccPlanAtt.id;   
   //insert(attach);
   return attach;
  }
  Catch(Exception e) {
   System.debug('Exception occured inside ACP_TestDataFactory:' + e.getMessage());
   return null;
  }
 }

 public static List < ACP_Strategy__c > createStrategy(Integer numberOfStrategy) {

  try {
   List < ACP_Strategy__c > strategies = new List < ACP_Strategy__c > ();
   for (Integer i = 0; i < numberOfStrategy; i++) {
    ACP_Strategy__c strategy = new ACP_Strategy__c(
     //ACP_Account_Plan__c = accPlanId,
     ACP_Customer_Strategy__c = 'Strategy For Customer',
     ACP_TE_Strategy__c = 'Strategy For te',
     ACP_Execution_Plan__c = 'ACP Execution Plan',
     //  ACP_Target_Date__c= 5/2/2017,
     ACP_Project_Status__c = 'Green',
     ACP_Status_Comments__c = 'comments');
    strategies.add(strategy);
   }

   return strategies;
  }
  Catch(Exception e) {
   System.debug('Exception occured inside ACP_TestDataFactory:' + e.getMessage());
   return null;
  }
 }

 public static List < ACP_Relationship__c > createStakeholderRelationship(Integer num, String relation, Id acpid) {

  try {
   Contact con = ACP_TestDataFactory.createContact();
   insert con;

   List < ACP_Relationship__c > Relationship = new List < ACP_Relationship__c > ();

   for (Integer i = 0; i < num; i++) {
    ACP_Relationship__c rel = new ACP_Relationship__c(
     ACP_Account_Plan__c = acpid,
     ACP_Comments__c = 'New Relationship',
     ACP_Location__c = 'Texas',
     ACP_Name__c = con.id,

     Relationship__c = relation);
    Relationship.add(rel);
   }
   insert relationship;

   return relationship;
  }
  Catch(Exception e) {
   System.debug('Exception occured inside ACP_TestDataFactory:' + e.getMessage());
   return null;
  }
 }

 public static ACP_Customer_Overview__c createCustomerOver(Id acpid, String recordtype) {

  try {
   system.debug('test data factory anushka');
   ACP_Customer_Overview__c custOverview = new ACP_Customer_Overview__c();
   if (recordtype == 'End Markets') {
    system.debug('entered markets');
    Id recordTypeId = Schema.SObjectType.ACP_Customer_Overview__c.getRecordTypeInfosByName().get('End Markets').getRecordTypeId();
    custOverview.ACP_Account_Plan__c = acpid;
    custOverview.ACP_Market__c = 'Industry';
    custOverview.ACP_Market_Percent__c = 36;
    custOverview.ACP_Market_Trend__c = 'Flat';
    custOverview.recordTypeId = recordTypeId;
   } else if (recordtype == 'Regions') {
    system.debug('entered markets 2');
    Id recordTypeId = Schema.SObjectType.ACP_Customer_Overview__c.getRecordTypeInfosByName().get('Regions').getRecordTypeId();
    custOverview.ACP_Account_Plan__c = acpid;
    custOverview.ACP_Region__c = 'North';
    custOverview.ACP_Region_Percent__c = 3;
    custOverview.ACP_Regions_Trend__c = 'Up';
    custOverview.recordTypeId = recordTypeId;
   } else if (recordtype == 'Key Manufacturing /Purchasing Locations') {
    system.debug('entered markets 3');
    Id recordTypeId = Schema.SObjectType.ACP_Customer_Overview__c.getRecordTypeInfosByName().get('Key Manufacturing /Purchasing Locations').getRecordTypeId();
    custOverview.ACP_Account_Plan__c = acpid;
    custOverview.ACP_Manufacturing__c = 'Amberg';
    custOverview.ACP_Purchasing__c = 'Erlangen';
    custOverview.recordTypeId = recordTypeId;
   } else if (recordtype == 'Key Engineering /Design locations') {
    system.debug('entered markets 4');
    Id recordTypeId = Schema.SObjectType.ACP_Customer_Overview__c.getRecordTypeInfosByName().get('Key Engineering /Design locations').getRecordTypeId();
    custOverview.ACP_Account_Plan__c = acpid;
    custOverview.ACP_Location__c = 'Amberg';
    custOverview.ACP_Location_Focus__c = 'Motion Control';
    custOverview.recordTypeId = recordTypeId;
   } else if (recordtype == 'Key Vendors in Supply Chain') {
    system.debug('entered markets 5');
    Id recordTypeId = Schema.SObjectType.ACP_Customer_Overview__c.getRecordTypeInfosByName().get('Key Vendors in Supply Chain').getRecordTypeId();
    custOverview.ACP_Account_Plan__c = acpid;
    custOverview.ACP_Vendor__c = 'CIS';
    custOverview.ACP_Type__c = 'EMS';
    custOverview.ACP_Vendor_Focus__c = 'Motion Control';
    custOverview.recordTypeId = recordTypeId;
   } else if (recordtype == 'Revenue and Growth') {
    system.debug('entered markets 6');
    Id recordTypeId = Schema.SObjectType.ACP_Customer_Overview__c.getRecordTypeInfosByName().get('Revenue and Growth').getRecordTypeId();
    custOverview.ACP_Account_Plan__c = acpid;
    custOverview.ACP_Year__c = '2020';
    custOverview.ACP_Revenue__c = 3;
    custOverview.recordTypeId = recordTypeId;
   }

   insert custOverview;
   system.debug('inserted overview ' + custOverview);
   return custOverview;

  }
  Catch(Exception e) {
   System.debug('Exception occured inside ACP_TestDataFactory:' + e.getMessage());
   return null;
  }
 }

public static Product_Hierarchy__c createProduct2() {
  try {
   Product_Hierarchy__c newProduct = new Product_Hierarchy__c(
    Name = 'T13',
    CBC1__c = '30007',
    CBC2__c = '30007',
    CBC3__c = '30007',
    CBC4__c = '30007',
    CBC5__c = '30007',
    CBC1_Description__c = 'Appliances',
    CBC2_Description__c = 'TUBING',
    CBC3_Description__c = 'Tubing Materials',
    CBC4_Description__c = 'Tubing Materials',
    CBC5_Description__c = 'Tubing Materials'
   );
   Insert(newProduct);
   return (newProduct);
  }
  Catch(Exception e) {
   System.debug('Exception occured: 9' + e.getMessage());
   return null;
  }
 }


 public static List<ACP_Opportunity_TAM_Revenue__c> createOppTamRevenue(Id acpid, String CBCValue) {
  try {
  Product_Hierarchy__c newProduct = ACP_TestDataFactory.createProduct2();
     
      List < ACP_Opportunity_TAM_Revenue__c > OppTAM = new List < ACP_Opportunity_TAM_Revenue__c > ();
         for (Integer i = 0; i < 3; i++) {
            ACP_Opportunity_TAM_Revenue__c newOppTAM = new ACP_Opportunity_TAM_Revenue__c(ACP_Account_Plan__c = acpid, 
            ACP_Product__c= newProduct.id, 
            ACP_TAM__c = 200,
            //ACP_Pipeline_4Q_rolling__c = 'Rolling',
            //ACP_NY_Pipeline__c =70,
            ACP_LY_Bill__c =30,
            ACP_L12M_Won_1Y_Value__c ='Won',
            ACP_L12M_Lost_1Yvalue__c ='Lost',
            //ACP_CY_Pipeline__c =30,
            ACP_Conversion_current_YTD__c ='YTD',
            //ACP_X5Y_Pipeline__c =70,
            ACP_CBC__c= cbcValue // modified by Haripriya
            );
            OppTAM.add(newOppTAM);
         }
       //insert OppTAM ;
      return oppTAM;
 }
  Catch(Exception e) {
   System.debug('Exception occured inside ACP_TestDataFactory:' + e.getMessage());
   return null;
  }
 }


public static List<ACP_Oppty_TAM_Report__c> createOppTamReport(Report report)
{
system.debug('report name ' + report);
  try {
  List<ACP_Oppty_TAM_Report__c> oppTAMRepList = new List<ACP_Oppty_TAM_Report__c>(); 
   ACP_Oppty_TAM_Report__c oppTAMReport = new ACP_Oppty_TAM_Report__c(
       ACP_CBC1__c = '30013',
       ACP_CBC3__c = '30033',
        ACP_CBC2__c = '30023',
       ACP_WW__c = 'W0007',
       ACP_GAM__c = 'G0007',
       ACP_KAM__c = 'K0007',
       ACP_Conversion__c = (String)report.Id,
       ACP_L12_Lost__c = (String)report.Id,
       ACP_L12_Won__c = (String)report.Id
       //ACP_Pipeline__c = (String)report.Id
   );
   
   oppTAMRepList.add(oppTAMReport);
   
   Insert oppTAMRepList;
   system.debug('inserted ' + oppTAMRepList + ' 1st id : ' + opptamreplist[0].id);
   return oppTAMRepList;
  
 }
  Catch(Exception e) {
   System.debug('Exception occured inside ACP_TestDataFactory:' + e.getMessage());
   return null;
   }
   }



public static List<BBB_Month_Bill_Book_Cust__c> createMonthlyBBB(String fiscalyr, Integer fiscalMonth, String accId)
{
Integer yr = Integer.valueOf(fiscalyr);
yr = yr-1;
List<BBB_Month_Bill_Book_Cust__c> bbbList = new List<BBB_Month_Bill_Book_Cust__c>();

  BBB_Month_Bill_Book_Cust__c bbb = new BBB_Month_Bill_Book_Cust__c(
  Bill_Type__c = 'cma',
  Book_Amount_USD__c = 100,
  Bill_Amount_USD__c =100,
  Fiscal_Year__c = fiscalyr,
  Fiscal_Month__c = fiscalMonth
  );
  
 bbbList.add(bbb);
  bbb = new BBB_Month_Bill_Book_Cust__c(
 Bill_Type__c = 'direct',
  Book_Amount_USD__c = 100,
  Bill_Amount_USD__c =100,
  Fiscal_Year__c = fiscalyr,
  Fiscal_Month__c = fiscalMonth
  );
  
  bbbList.add(bbb);
  bbb = new BBB_Month_Bill_Book_Cust__c(
  Bill_Type__c = 'POS',
  Book_Amount_USD__c = 100,
  Bill_Amount_USD__c =100,
  Fiscal_Year__c = fiscalyr,
  Fiscal_Month__c = fiscalMonth
  );

  bbbList.add(bbb);
 // ------------------------------------------ past yr ----------------------------// 
  bbb = new BBB_Month_Bill_Book_Cust__c(
  Bill_Type__c = 'cma',
  Book_Amount_USD__c = 100,
  Bill_Amount_USD__c =100,
  Fiscal_Year__c = String.valueOf(yr),
  Fiscal_Month__c = fiscalMonth
  );
  
 bbbList.add(bbb);
  bbb = new BBB_Month_Bill_Book_Cust__c(
  Bill_Type__c = 'direct',
  Book_Amount_USD__c = 100,
  Bill_Amount_USD__c =100,
  Fiscal_Year__c = String.valueOf(yr),
  Fiscal_Month__c = fiscalMonth
  );
  
  bbbList.add(bbb);
  bbb = new BBB_Month_Bill_Book_Cust__c(
 Bill_Type__c = 'POS',
  Book_Amount_USD__c = 100,
  Bill_Amount_USD__c =100,
  Fiscal_Year__c = String.valueOf(yr),
  Fiscal_Month__c = fiscalMonth
  );

  bbbList.add(bbb);
  yr =yr-1;
  
  bbb = new BBB_Month_Bill_Book_Cust__c(
  Bill_Type__c = 'cma',
  Book_Amount_USD__c = 100,
  Bill_Amount_USD__c =100,
  Fiscal_Year__c = String.valueOf(yr),
  Fiscal_Month__c = fiscalMonth
  );
  
 bbbList.add(bbb);
  bbb = new BBB_Month_Bill_Book_Cust__c(
  Bill_Type__c = 'direct',
  Book_Amount_USD__c = 100,
  Bill_Amount_USD__c =100,
  Fiscal_Year__c = String.valueOf(yr),
  Fiscal_Month__c = fiscalMonth
  );
  
  bbbList.add(bbb);
  bbb = new BBB_Month_Bill_Book_Cust__c(
 Bill_Type__c = 'POS',
  Book_Amount_USD__c = 100,
  Bill_Amount_USD__c =100,
  Fiscal_Year__c = String.valueOf(yr),
  Fiscal_Month__c = fiscalMonth
  );

  bbbList.add(bbb);
 return bbbList ;
 }
  
public static List<BBB_Year_Bill_Book_Cust_PN__c> createYearlyBBB(String cbcValue, String actType, Id accId)
    {
    Product_Hierarchy__c prodHier = new Product_Hierarchy__c(
    Name = 'Test',
    CBC1__c = '13333',
    CBC2__c = '13332',
    CBC3__c = '13331');
    insert(prodHier);
    
    Part__c part = new Part__c(
    Name = 'Test',
    Product_Hierarchy__c = prodHier.id);
    insert(part);
    
    List<BBB_Year_Bill_Book_Cust_PN__c> YbbList = new List<BBB_Year_Bill_Book_Cust_PN__c>();
    
      BBB_Year_Bill_Book_Cust_PN__c ybb = new BBB_Year_Bill_Book_Cust_PN__c(
    Bill_Prior_Year_Amount_USD__c = 200,
    Bill_Year_to_Date_Amount_USD__c =300,
    Bill_Prior_Year_to_Date_Amount_USD__c = 400,
    //Customer__c = account.id,
    Part__c = part.id);
  
  
 YbbList.add(ybb);
  ybb = new BBB_Year_Bill_Book_Cust_PN__c(
    Bill_Prior_Year_Amount_USD__c = 201,
    Bill_Year_to_Date_Amount_USD__c =301,
    Bill_Prior_Year_to_Date_Amount_USD__c = 401,
   // Customer__c = account.id,
    Part__c = part.id);
 
  
  YbbList.add(ybb);
  ybb = new BBB_Year_Bill_Book_Cust_PN__c(
    Bill_Prior_Year_Amount_USD__c = 202,
    Bill_Year_to_Date_Amount_USD__c =302,
    Bill_Prior_Year_to_Date_Amount_USD__c = 402,
    //Customer__c = account.id,
    Part__c = part.id);

  YbbList.add(ybb);
   return YbbList ; 
    }

public static List<Platform_Content__c> createPlatCont()
    {
      
    List<Platform_Content__c> platCont = new List<Platform_Content__c>();
    
      Platform_Content__c plat = new Platform_Content__c(
      CBC1__c = 'Industrial',
    Comments__c = 'abc', 
    ACP_Name__c = 'CBC 1 - 30004 - Industrial');
    
  
  
 platCont.add(plat);
  plat = new Platform_Content__c(
     CBC2__c = 'IB products', 
    CBC3__c = 'Switches', 
    Comments__c = 'sample', 
    ACP_Name__c = 'CBC 3 - 30022 - Switches');
 
  
  platCont.add(plat);
  plat = new Platform_Content__c(
     CBC1__c = 'Industrial', 
    CBC2__c = 'IB products', 
    Comments__c = 'sample', 
    ACP_Name__c = 'CBC 2 - 30008 - IB products');

  platCont.add(plat);
   return platCont ; 
    }
    
}