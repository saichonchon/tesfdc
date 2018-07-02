/*@ 2014-09-18 Harinath Chittala <harinath.chittala@te.com> changed the accounts name manually to control duplication 
@ 2014-02-10 Sanghita Das <sanghita.das@te.com> Changed phase name from 'Order Received or Mass Production' with 2 spaces between the words Received and or To "Order Received or Mass Production"  # Case 00900395 */


@isTest
(SeeAllData=false)
private class OpportunityStageValidation_Test{

	@testSetup static void createConfig(){
		ClsTestCustomSettingHelper.getADMTerritoryCode();
		ClsTestCustomSettingHelper.getCrossBUCheck();
	}
  
    public static testMethod void MytestTrigger() {
        // User Record
        ClsTestCustomSettingHelper.getAllSettings();
        ClsTestCustomSettingHelper.getPMV_Sales_Stage_Setting();
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getTrigger_Configuration();

        
        Profile p = [SELECT Id FROM Profile WHERE Name='DND Engineering User w/Cost']; 
        
        User u = new User(GIBU__c='Data & Devices', Alias = 'standt', Email='test432@testorg.com', EmailEncodingKey='UTF-8', LastName='Tes', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='test432@testorg.com', CSD_Region__c='Taiwan');
       
        //Account Record Type
        Schema.DescribeSObjectResult cfrSchema1 = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> AccountRecordTypeInfo = cfrSchema1.getRecordTypeInfosByName(); 
        Id CSDAccrtId = AccountRecordTypeInfo.get('OEM').getRecordTypeId();
        
        //Opportunity Record types
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> OpportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id CSDrtId = OpportunityRecordTypeInfo.get('Sales Opportunity-CSD').getRecordTypeId();
        Id EnggrtId = OpportunityRecordTypeInfo.get('Engineering Opportunity-CSD').getRecordTypeId();
        
        /*Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9(); 
        Apex_Helper_Settings__c ahs10 = ClsTestHelp.createTestName10();
        Apex_Helper_Settings__c ahs11 = ClsTestHelp.createTestName11();                   */
        
        //Account Records        
        Account acc = new Account();
        acc.Name = 'Test1';
        acc.ownerId = UserInfo.getUserId();        
        acc.Account_Manager__c = UserInfo.getUserId();
        acc.BillingCountry = 'CN';
        acc.AccountNumber = '1082:00183217';
        //insert acc;
                
        Account acc1 = new Account();
        acc1.RecordTypeId = CSDAccrtId;
        acc1.Active__c = true;
        acc1.Name = 'Test2';
        acc.ownerId = UserInfo.getUserId(); 
        acc1.Account_Manager__c = UserInfo.getUserId();
        acc1.BillingCountry = 'CN';
        insert new list<Account>{acc,acc1};
        
        //Opportunity List
        List<Opportunity> oppList =new List<Opportunity>();
        
           /*------------------------Sales Opportunity-CSD Record Type Validations-----------*/
        /*------------------------------All Field Values----------------------------------------*/
        Opportunity opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = CSDrtId, CloseDate = system.today() , StageName = 'New Opportunity', Probability = 10,Fulfillment_Region__c = userinfo.getuserid(), OEM_Name__c = acc1.id, Amount = 100, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = CSDrtId, CloseDate = system.today() , StageName = 'New Opportunity', Probability = 10, OEM_Name__c = acc1.id, Amount = 100, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = CSDrtId, CloseDate = system.today() , StageName = 'New Opportunity', Probability = 10,Fulfillment_Region__c = userinfo.getuserid(), Amount = 100, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = CSDrtId, CloseDate = system.today() , StageName = 'New Opportunity', Probability = 10,Fulfillment_Region__c = userinfo.getuserid(), OEM_Name__c = acc1.id, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = CSDrtId, CloseDate = system.today() , StageName = 'Quotation', Probability = 25, OEM_Name__c = acc1.id, Amount = 100, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = CSDrtId, CloseDate = system.today() , StageName = 'Quotation', Probability = 25, Fulfillment_Region__c = userinfo.getuserid(), Amount = 100, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = CSDrtId, CloseDate = system.today() , StageName = 'Quotation', Probability = 25, Fulfillment_Region__c = userinfo.getuserid(), OEM_Name__c = acc1.id, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = CSDrtId, CloseDate = system.today() , StageName = 'Sampling', Probability = 50, OEM_Name__c = acc1.id, Amount = 100, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = CSDrtId, CloseDate = system.today() , StageName = 'Sampling', Probability = 50, Fulfillment_Region__c = userinfo.getuserid(), Amount = 100, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = CSDrtId, CloseDate = system.today() , StageName = 'Sampling', Probability = 50, Fulfillment_Region__c = userinfo.getuserid(), OEM_Name__c = acc1.id, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = CSDrtId, CloseDate = system.today() , StageName = 'Won/Qualified', Probability = 75, OEM_Name__c = acc1.id, Amount = 100, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = CSDrtId, CloseDate = system.today() , StageName = 'Won/Qualified', Probability = 75, Fulfillment_Region__c = userinfo.getuserid(), Amount = 100, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = CSDrtId, CloseDate = system.today() , StageName = 'Won/Qualified', Probability = 75, Fulfillment_Region__c = userinfo.getuserid(), OEM_Name__c = acc1.id, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
         opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = CSDrtId, CloseDate = system.today() , StageName = 'Won/Qualified', Probability = 75, Fulfillment_Region__c = userinfo.getuserid(), OEM_Name__c = acc1.id, Amount = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = CSDrtId, CloseDate = system.today() , StageName = 'Won/Qualified', Probability = 75, Fulfillment_Region__c = userinfo.getuserid(), OEM_Name__c = acc1.id, Amount = 100, Two_Years_Revenue__c = 100, Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = CSDrtId, CloseDate = system.today() , StageName = 'Order Received or Mass Production', Probability = 100, OEM_Name__c = acc1.id, Amount = 100, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');//2016-02-10 - Sanghita change added Case 00900395
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = CSDrtId, CloseDate = system.today() , StageName = 'Order Received or Mass Production', Probability = 100, Fulfillment_Region__c = userinfo.getuserid(), Amount = 100, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');//2016-02-10 - Sanghita change added Case 00900395
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = CSDrtId, CloseDate = system.today() , StageName = 'Order Received or Mass Production', Probability = 100, Fulfillment_Region__c = userinfo.getuserid(), OEM_Name__c = acc1.id, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');//2016-02-10 - Sanghita change added Case 00900395
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
         opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = CSDrtId, CloseDate = system.today() , StageName = 'Order Received or Mass Production', Probability = 100, Fulfillment_Region__c = userinfo.getuserid(), OEM_Name__c = acc1.id, Amount = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');//2016-02-10 - Sanghita change added Case 00900395
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = CSDrtId, CloseDate = system.today() , StageName = 'Order Received or Mass Production', Probability = 100, Fulfillment_Region__c = userinfo.getuserid(), OEM_Name__c = acc1.id, Amount = 100, Two_Years_Revenue__c = 100, Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');//2016-02-10 - Sanghita change added Case 00900395
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = CSDrtId, CloseDate = system.today() , StageName = 'Lost/Dead - closed', Probability = 0,Fulfillment_Region__c = userinfo.getuserid(), OEM_Name__c = acc1.id, Amount = 100, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today());
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        
        /*------------------------Engineering Opportunity-CSD Record Type Validations-----------*/
        /*------------------------------All Field Values----------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = EnggrtId, CloseDate = system.today() , StageName = 'New Opportunity', Probability = 10,Fulfillment_Region__c = userinfo.getuserid(), OEM_Name__c = acc1.id, Amount = 100, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = EnggrtId, CloseDate = system.today() , StageName = 'New Opportunity', Probability = 10, OEM_Name__c = acc1.id, Amount = 100, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = EnggrtId, CloseDate = system.today() , StageName = 'New Opportunity', Probability = 10,Fulfillment_Region__c = userinfo.getuserid(), Amount = 100, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = EnggrtId, CloseDate = system.today() , StageName = 'New Opportunity', Probability = 10,Fulfillment_Region__c = userinfo.getuserid(), OEM_Name__c = acc1.id, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = EnggrtId, CloseDate = system.today() , StageName = 'Quotation', Probability = 25, OEM_Name__c = acc1.id, Amount = 100, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = EnggrtId, CloseDate = system.today() , StageName = 'Quotation', Probability = 25, Fulfillment_Region__c = userinfo.getuserid(), Amount = 100, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = EnggrtId, CloseDate = system.today() , StageName = 'Quotation', Probability = 25, Fulfillment_Region__c = userinfo.getuserid(), OEM_Name__c = acc1.id, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = EnggrtId, CloseDate = system.today() , StageName = 'Sampling', Probability = 50, OEM_Name__c = acc1.id, Amount = 100, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = EnggrtId, CloseDate = system.today() , StageName = 'Sampling', Probability = 50, Fulfillment_Region__c = userinfo.getuserid(), Amount = 100, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = EnggrtId, CloseDate = system.today() , StageName = 'Sampling', Probability = 50, Fulfillment_Region__c = userinfo.getuserid(), OEM_Name__c = acc1.id, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = EnggrtId, CloseDate = system.today() , StageName = 'Won/Qualified/G3 Approved', Probability = 75, OEM_Name__c = acc1.id, Amount = 100, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = EnggrtId, CloseDate = system.today() , StageName = 'Won/Qualified/G3 Approved', Probability = 75, Fulfillment_Region__c = userinfo.getuserid(), Amount = 100, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = EnggrtId, CloseDate = system.today() , StageName = 'Won/Qualified/G3 Approved', Probability = 75, Fulfillment_Region__c = userinfo.getuserid(), OEM_Name__c = acc1.id, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
         opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = EnggrtId, CloseDate = system.today() , StageName = 'Won/Qualified/G3 Approved', Probability = 75, Fulfillment_Region__c = userinfo.getuserid(), OEM_Name__c = acc1.id, Amount = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = EnggrtId, CloseDate = system.today() , StageName = 'Won/Qualified/G3 Approved', Probability = 75, Fulfillment_Region__c = userinfo.getuserid(), OEM_Name__c = acc1.id, Amount = 100, Two_Years_Revenue__c = 100, Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = EnggrtId, CloseDate = system.today() , StageName = 'Order Received or Mass Production', Probability = 100, OEM_Name__c = acc1.id, Amount = 100, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');  //2016-02-10 - Sanghita change added Case 00900395
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = EnggrtId, CloseDate = system.today() , StageName = 'Order Received or Mass Production', Probability = 100, Fulfillment_Region__c = userinfo.getuserid(), Amount = 100, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');//2016-02-10 - Sanghita change added Case 00900395
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = EnggrtId, CloseDate = system.today() , StageName = 'Order Received or Mass Production', Probability = 100, Fulfillment_Region__c = userinfo.getuserid(), OEM_Name__c = acc1.id, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');//2016-02-10 - Sanghita change added Case 00900395
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
         opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = EnggrtId, CloseDate = system.today() , StageName = 'Order Received or Mass Production', Probability = 100, Fulfillment_Region__c = userinfo.getuserid(), OEM_Name__c = acc1.id, Amount = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');//2016-02-10 - Sanghita change added Case 00900395
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = EnggrtId, CloseDate = system.today() , StageName = 'Order Received or Mass Production', Probability = 100, Fulfillment_Region__c = userinfo.getuserid(), OEM_Name__c = acc1.id, Amount = 100, Two_Years_Revenue__c = 100, Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');//2016-02-10 - Sanghita change added Case 00900395
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = EnggrtId, CloseDate = system.today() , StageName = 'Lost/Dead - closed', Probability = 0,Fulfillment_Region__c = userinfo.getuserid(), OEM_Name__c = acc1.id, Amount = 100, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today());
        oppList.add(opp);
        /*----------------------------------------------------------------------*/
        opp = new Opportunity(Currency_Confirm__c = true, Probability__c='30', isFromCode__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', RecordTypeId = Consumer_Device_Opportunity_Record_Types__c.getinstance('Engineering Opportunity-CSD').Record_Type_Id__c , CloseDate = system.today() , StageName = 'Rejected - Closed', Probability = 0,Fulfillment_Region__c = userinfo.getuserid(), OEM_Name__c = acc1.id, Amount = 100, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today());
        oppList.add(opp);
        /*----------------------------------------------------------------------*/   
        try{
        insert oppList;
        }
            
        catch(exception e){}
        
        
    }
    public static testMethod void MytestTrigger2() {
        // User Record
        ClsTestCustomSettingHelper.getAllSettings();
        ClsTestCustomSettingHelper.getPMV_Sales_Stage_Setting();
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getTrigger_Configuration();

        
        Profile p = [SELECT Id FROM Profile WHERE Name='DND Engineering User w/Cost']; 
        
        User u = new User(GIBU__c='Data & Devices', Alias = 'standt', Email='test432@testorg.com', EmailEncodingKey='UTF-8', LastName='Tes', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='test432@testorg.com', CSD_Region__c='Taiwan');
       
        //Account Record Type
        Schema.DescribeSObjectResult cfrSchema1 = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> AccountRecordTypeInfo = cfrSchema1.getRecordTypeInfosByName(); 
        Id CSDAccrtId = AccountRecordTypeInfo.get('OEM').getRecordTypeId();
        
        //Opportunity Record types
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> OpportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id CSDrtId = OpportunityRecordTypeInfo.get('Sales Opportunity-CSD').getRecordTypeId();
        Id EnggrtId = OpportunityRecordTypeInfo.get('Engineering Opportunity-CSD').getRecordTypeId();
        
            
        Account acc = new Account();
        acc.Name = 'Test12';
        acc.ownerId = UserInfo.getUserId();        
        acc.Account_Manager__c = UserInfo.getUserId();
        acc.BillingCountry = 'US';
        acc.AccountNumber = '1082:00183217';
        acc.Industry_Code_Description__c = 'Appliances';
        acc.LEVEL_1_INDUSTRY_CDE__c  = '0374';
        insert acc;
                   
        //Opportunity List
        List<Opportunity> oppList =new List<Opportunity>();
        Apex_Helper_Settings__c RTSalesOppyChaannel = Apex_Helper_Settings__c.getInstance('Sales Opportunity Channel');
        Opportunity opp2 = new Opportunity(Currency_Confirm__c = true, recordtypeid = RTSalesOppyChaannel.value__c, isFromCode__c = true, POS_Customer_is_same_as_Account__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', CloseDate = system.today() , StageName = 'Concept', Probability = 10,Fulfillment_Region__c = userinfo.getuserid(), Amount = 100, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');
        oppList.add(opp2);    
        Opportunity opp3 = new Opportunity(Currency_Confirm__c = true, recordtypeid = RTSalesOppyChaannel.value__c, isFromCode__c = true, POS_Customer_is_same_as_Account__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', CloseDate = system.today() , StageName = 'Concept', Probability = 10,Fulfillment_Region__c = userinfo.getuserid(), Amount = 100, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');
        oppList.add(opp3);    
        test.starttest();
        insert oppList;
        opp2.POS_Customer_is_same_as_Account__c = false;
        update opp2;
        
        Product_Hierarchy__c ph = ClsTestHelp.createTestProductHierarchy();
        ph.CBC2_Description__c = 'A&C products';
        insert ph;
        list<Opportunity_Part__c> list_oppyParts = new list<Opportunity_Part__c>();
        Opportunity_Part__c oppyPart = new Opportunity_Part__c();
        oppyPart.Opportunity__c = opp2.Id;
        oppyPart.NDRForecastCreated__c = false;
        oppyPart.NDR_Alternate_Part__c = false;
        oppyPart.NDR_Item_Status_Desc__c = 'Complete';
        oppyPart.GPL__c = ph.Id;
        oppyPart.recordtypeId = Apex_Helper_Settings__c.getInstance('NDR Opportunity Parts').Value__c;
        list_oppyParts.add(oppyPart);
        Opportunity_Part__c oppyPart2 = new Opportunity_Part__c();
        oppyPart2.Opportunity__c = opp2.Id;
        oppyPart2.NDRForecastCreated__c = false;
        oppyPart2.NDR_Alternate_Part__c = false;
        oppyPart2.NDR_Item_Status_Desc__c = 'Complete';
        oppyPart2.GPL__c = ph.Id;
        oppyPart2.recordtypeId = Apex_Helper_Settings__c.getInstance('Sales Parts RT Id').Value__c;
        list_oppyParts.add(oppyPart2);
        insert list_oppyParts;
        oppyPart.Product_Description__c = 'test Oppy part';
        oppyPart2.Product_Description__c = 'test Oppy part';
        ClsPMV_Util.runningTriggerName = '';
        update list_oppyParts;
        test.stoptest();
    }
    
    public static testMethod void testForDefenseTrigger2() {
    	ClsTestCustomSettingHelper.getAllSettings();
        ClsTestCustomSettingHelper.getPMV_Sales_Stage_Setting();
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
    	
    	Schema.DescribeSObjectResult cfrSchema1 = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> AccountRecordTypeInfo = cfrSchema1.getRecordTypeInfosByName(); 
        Id CSDAccrtId = AccountRecordTypeInfo.get('OEM').getRecordTypeId();
		Account acc = new Account();
        acc.Name = 'Test12';
        acc.ownerId = UserInfo.getUserId();        
        acc.Account_Manager__c = UserInfo.getUserId();
        acc.BillingCountry = 'US';
        acc.AccountNumber = '1082:00183217';
        Account acc1 = new Account();
        acc1.RecordTypeId = CSDAccrtId;
        acc1.Active__c = true;
        acc1.Name = 'Test2';
        acc1.Account_Manager__c = UserInfo.getUserId();
        acc1.BillingCountry = 'CN';
        insert new list<Account>{acc,acc1};
    	Opportunity oppy = new Opportunity(Currency_Confirm__c = true, recordtypeid = ClsTestHelp.createCSDTestRecordType1().Id, isFromCode__c = true, POS_Customer_is_same_as_Account__c = true, Mass_prod_Status__c=true, Description = 'Test', Type = 'New Business', AccountId = acc.id, Name = 'Test', CloseDate = system.today() , StageName = 'Concept', Probability = 10,Fulfillment_Region__c = userinfo.getuserid(), Amount = 100, Two_Years_Revenue__c = 100, Provide_to_customer_Quotation_Date__c = system.today(), Lost_Rejected_Dead_On_Hold_Reason__c = 'Awaiting customer response');
    	insert oppy;
    	test.starttest();
        Opportunity_Part__c oppyPart = new Opportunity_Part__c();
        oppyPart.Opportunity__c = oppy.Id;
        oppyPart.Initial_Order_Date__c = system.today();
        oppyPart.recordtypeId = Apex_Helper_Settings__c.getInstance('Sales Parts RT Id').Value__c;
        insert oppyPart;
        Forecast_Billing__c fb = new Forecast_Billing__c();
        fb.Opportunity_Part__c = oppyPart.Id;
        fb.Date__c = system.today();
        insert fb;
        delete oppyPart;
    	test.stoptest();
    	delete oppy;
    }
    
    public static testMethod void testForTriggerCoverage() {
    	 ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
        ClsTestCustomSettingHelper.getPMV_Sales_Stage_Setting();
        ClsTestCustomSettingHelper.getPMV_Stage_Config();
        ClsTestCustomSettingHelper.getADMTerritoryCode();
        Channelinsightdata_test.Channelinsightdata_test();
		
		Opportunity oppy = ClsTestHelp.createTestOpportunity();
		oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
		oppy.Name = 'test';
		insert oppy;
    	update oppy;
    	Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial'; 
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
    	test.starttest();
        Opportunity_Part__c oppypart = ClsTestHelp.createTestEnergyOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppyPart.Part__c = part.Id;
        insert oppyPart;
        delete oppyPart;
		Test.stopTest();
    }
    
}