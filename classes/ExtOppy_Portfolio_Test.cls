/**
*  This test class used to test class ExtOppy_Portfolio.
*
@author Jinbo Shan
@created 2014-06-26
@version 1.0   
@since 29.0
*
@changelog
* coverage  91%
* 
* 
2014-06-26 Jinbo Shan <jinbo.shan@itbconsult.com>
* - Created
*/
@isTest(seealldata=true) 
private class ExtOppy_Portfolio_Test {
	
	Opportunity_Record_Type_Groups__c  org1 = ClsTestHelp.createTestOPTG1();
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
    PMV_Stage_Config__c ssc7 = ClsTestHelp.createTestSSC7();

    static testMethod void myUnitTest() {
    	
    	list<Pipeline_Management_Portfolio__c> list_pmps = new list<Pipeline_Management_Portfolio__c>();
    	Pipeline_Management_Portfolio__c pmp1 = new Pipeline_Management_Portfolio__c();
    	for(Pipeline_Management_Portfolio__c pmp : [select Name, Category__c, LabelName__c, 
    												Description1__c, Description2__c 
    												from Pipeline_Management_Portfolio__c 
    												where Name = 'DGA_value__c' 
    												and Category__c = 'Attractivenes']) {
    		pmp1 = pmp;
    	}
    	if(pmp1.Name == null) {
    		pmp1.Category__c = 'Attractivenes';
	        pmp1.LabelName__c = 'test1';
	        pmp1.Name = 'DGA_value__c';
	        pmp1.Description1__c = 'test DGA';
	        list_pmps.add(pmp1);
    	}
        
        Pipeline_Management_Portfolio__c pmp2 = new Pipeline_Management_Portfolio__c();
        
        for(Pipeline_Management_Portfolio__c pmp : [select Name, Category__c, LabelName__c, 
    												Description1__c, Description2__c 
    												from Pipeline_Management_Portfolio__c 
    												where Name = 'NPS_Score__c' 
    												and Category__c = 'Ability']) {
    		pmp2 = pmp;
    	}
    	
    	if(pmp2.Name == null) {
	        pmp2.Category__c = 'Ability';
	        pmp2.LabelName__c = 'test2';
	        pmp2.Name = 'NPS_Score__c';
	        pmp2.Description1__c = 'test NPS';
	        list_pmps.add(pmp2);
    	}
        
        if(list_pmps.size() > 0) {
        	insert list_pmps;
        }
        
        RecordType rt = ClsTestHelp.createPMVTestRecordType1();
        
        User u = ClsTestHelp.createTestUsers4PMV();
        u.Username = u.Email + '.test1';
        insert u;
        
        system.runAs(u){
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            insert acc;
            
            list<Contact> list_cons = new list<Contact>();
            
            Contact con1 = new Contact();
            con1.AccountId = acc.Id;
            con1.FirstName = 'test1';
            con1.LastName = 'test1';
            list_cons.add(con1);
            Contact con2 = new Contact();
            con2.AccountId = acc.Id;
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
            opp.currency_confirm__c = true;
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
            
            ApexPages.Standardcontroller stdCtrl = new ApexPages.Standardcontroller(opp);
            ExtOppy_Portfolio ext = new ExtOppy_Portfolio(stdCtrl);
        }
        
    }
}