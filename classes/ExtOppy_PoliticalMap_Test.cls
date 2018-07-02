/**
*  This test class used to test class ExtOppy_PoliticalMap.
*
@author Jinbo Shan
@created 2014-06-26
@version 1.0   
@since 29.0
*
@changelog
* coverage  82%
* 
* 
2014-06-26 Jinbo Shan <jinbo.shan@itbconsult.com>
* - Created
*/
@isTest(seealldata=false) 
private class ExtOppy_PoliticalMap_Test {
    
    /*Opportunity_Record_Type_Groups__c  org1 = ClsTestHelp.createTestOPTG1();
    Opportunity_Record_Type_Groups__c  org2 = ClsTestHelp.createTestOPTG2();
    PMV_Language_Config__c slc1 = ClsTestHelp.createTestSLC1();
    PMV_Language_Config__c slc2 = ClsTestHelp.createTestSLC2();
    PMV_Language_Config__c slc3 = ClsTestHelp.createTestSLC3();
    PMV_Sales_Process_Settings__c ssps1 = ClsTestHelp.createTestSSPS1();
    PMV_Sales_Process_Settings__c ssps2 = ClsTestHelp.createTestSSPS1();
    PMV_Sales_Stage_Setting__c ssss1 = ClsTestHelp.createTestSSSS1();
    PMV_Sales_Stage_Setting__c ssss2 = ClsTestHelp.createTestSSSS2();
    PMV_Sales_Stage_Setting__c ssss3 = ClsTestHelp.createTestSSSS3();
    PMV_Sales_Stage_Setting__c ssss4 = ClsTestHelp.createTestSSSS4();
    PMV_Sales_Stage_Setting__c ssss5 = ClsTestHelp.createTestSSSS5();
    PMV_Sales_Stage_Setting__c ssss6 = ClsTestHelp.createTestSSSS6();
    PMV_Sales_Stage_Setting__c ssss7 = ClsTestHelp.createTestSSSS7();
    PMV_Sales_Stage_Setting__c ssss8 = ClsTestHelp.createTestSSSS8();
    PMV_Sales_Stage_Setting__c ssss9 = ClsTestHelp.createTestSSSS9();
    PMV_Sales_Stage_Setting__c ssss10 = ClsTestHelp.createTestSSSS10();
    PMV_Stage_Config__c ssc1 = ClsTestHelp.createTestSSC1();
    PMV_Stage_Config__c ssc2 = ClsTestHelp.createTestSSC2();
    PMV_Stage_Config__c ssc3 = ClsTestHelp.createTestSSC3();
    PMV_Stage_Config__c ssc4 = ClsTestHelp.createTestSSC4();
    PMV_Stage_Config__c ssc5 = ClsTestHelp.createTestSSC5();
    PMV_Stage_Config__c ssc6 = ClsTestHelp.createTestSSC6();
    PMV_Stage_Config__c ssc7 = ClsTestHelp.createTestSSC7();*/
    
    static testMethod void myUnitTest() {
        
        User user = [select id from user where GIBU__c = 'Industrial' and  Sub_Vertical__c = 'A&C' and isactive = true limit 1];
        system.runAs(user){
        
            ClsTestCustomSettingHelper.getApex_Helper_Settings();
            ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
            ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
            ClsTestCustomSettingHelper.getOpportunity_Approvers();
        	ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
        	ClsTestCustomSettingHelper.getPMV_Sales_Stage_Setting();
        	ClsTestCustomSettingHelper.getPMV_Stage_Config();
            RecordType rt = ClsTestHelp.createPMVTestRecordType1();
            list<Contact> list_cons = new list<Contact>();
            
            Contact con2 = new Contact();
            Contact con1 = new Contact();
            Account acc = ClsTestHelp.createTestAccounts();
            acc.AccountNumber = '1149test';     
            acc.Type='CM';
            insert acc;
                
            //for(Contact con : [Select Id, AccountId, ReportsToId from Contact where Account.Type='CM' And ReportsToId != null and AccountId != null limit 1]) {
                //con2 = con;
            //}
            //if(con2.Id == null) {
                
                /*for(Account account : [Select Id from Account where Id =: acc.Id limit 1]) {
                    acc = account;
                }
                if(acc.Id == null) {
                    acc = ClsTestHelp.createTestAccounts();
                    acc.Type = 'CM';
                    insert acc;
                }*/
                con1.AccountId = acc.Id;
            	con1.Salutation = 'Mr.';
                con1.FirstName = 'test1';
                con1.LastName = 'test1';
                list_cons.add(con1);
                con2.AccountId = acc.Id;
            	con2.Salutation = 'Mr.';
                con2.FirstName = 'test2';
                con2.LastName = 'test2';
                con2.ReportsToId = con1.Id;
                list_cons.add(con2);
                insert list_cons;
            

            Opportunity opp = new Opportunity();
            opp.AccountId = acc.Id;
            opp.Name = 'test';
            opp.CurrencyIsoCode = 'EUR';
            opp.Type = 'New Business';
            opp.currency_confirm__c= true;
            opp.Description = 'test';
            opp.Distributor__c = 'Dachs';
            opp.StageName = 'Initiating';
            opp.Manufacturing_Start_Date__c = date.today();
            opp.CloseDate = date.today().addMonths(1);
            opp.RecordTypeId = rt.Id;
            opp.PMV_Type__c = 'IND Standard Sales opp';
            insert opp;
            
            Influencer__c inf = new Influencer__c();
            inf.Contact_Influencing__c = con1.Id;
            inf.Contact_influenced__c = con2.Id;
            inf.Opportunity__c = opp.Id;
            insert inf;
            
            list<Custom_Opportunity_Contact_Role__c> list_cocr = new list<Custom_Opportunity_Contact_Role__c>();
            Custom_Opportunity_Contact_Role__c cocr1 = new Custom_Opportunity_Contact_Role__c();
            cocr1.Contact__c = con1.Id;
            cocr1.Opportunity__c = opp.Id;
            cocr1.Role__c = 'Business User';
            list_cocr.add(cocr1);
            
            Custom_Opportunity_Contact_Role__c cocr2 = new Custom_Opportunity_Contact_Role__c();
            cocr2.Contact__c = con2.Id;
            cocr2.Opportunity__c = opp.Id;
            cocr2.Role__c = 'Business User';
            list_cocr.add(cocr2);
            insert list_cocr;
            Test.startTest();
            string s1 = ExtOppy_PoliticalMap.deleteInf(opp.Id, con2.Id, con1.Id);
            string s2 = ExtOppy_PoliticalMap.createInf(opp.Id, con2.Id, con1.Id);
            string s3 = ExtOppy_PoliticalMap.deleteContactReportTo(con1.Id, con2.Id);
            string s4 = ExtOppy_PoliticalMap.createContactReportTo(con1.Id, con2.Id);
            string s5 = ExtOppy_PoliticalMap.deleteContactRole(opp.Id, con1.Id);
            string s6 = ExtOppy_PoliticalMap.createContactRole(opp.Id, con1.Id, '');
            
            ApexPages.Standardcontroller stdCtrl = new ApexPages.Standardcontroller(opp);
            ExtOppy_PoliticalMap ext = new ExtOppy_PoliticalMap(stdCtrl);
            ext.cont.FirstName = 'test';
            ext.cont.LastName = 'test';
            ext.createContact();
            ext.init();
            
            Test.stopTest();
    	}   
    }
}