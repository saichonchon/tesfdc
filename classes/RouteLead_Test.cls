/*
 * Rajendra Shahane 03/29/2016  Modified for case - 900703
 */
@isTest(SeeAllData=false)
private class RouteLead_Test
{
    static testmethod void RouteLead_TM()
    {
         //Start: Rajendra Shahane Modified for case - 900703
        ClsTestCustomSettingHelper.getCCPTriggerSettings();
        //End: Rajendra Shahane Modified for case - 900703
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        ClsTestCustomSettingHelper.getTE_Connection();
        Account testaccount = new Account(Name = 'Test TE Account', AnnualRevenue = 123456.01, Legally_Restricted__c = false, BillingCity = 'Middletown', BillingCountry = 'US', BillingState = 'PA', BillingStreet = '2800 Fulling Mill Road', BillingPostalCode = '17057');    
        insert testaccount;
    
        Contact testcontact = new Contact(AccountId = testaccount.Id, FirstName = 'Jasmine', LastName = 'Ver', Legally_Restricted__c = false, Email = 'jasmine.ver@test.com');
        insert testcontact;
        
        Id leadId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Central Lead').getRecordTypeId();//[select Id From RecordType Where SobjectType ='Lead' And DeveloperName = 'Central_Lead'].Id;

        Lead testlead1 = new lead(RecordTypeId = leadId,industry = 'testind', lastname='Tester', firstName='Unit', company ='TEIS', Status = 'Assigned Unaccepted', Rating = 'Hot', country='United States', email= testcontact.Email, description='unit test ignore', Type_of_company__c='testrecord', CUSTOMER_CONTACTED__C=False, LEADSOURCE='LDAP', phone='+1 1231231234', STATE='PA');
        Lead testlead2 = new lead( RecordTypeId = leadId,lastname='Tester', firstName='Unit', company ='TEIS', Status = 'Assigned Unaccepted', Rating = 'Hot', country='United States', email= testcontact.Email, description='unit test ignore', Type_of_company__c='testrecord', CUSTOMER_CONTACTED__C=False, LEADSOURCE='LDAP', phone='+1 1231231234', STATE='PA');
        Lead testlead3 = new lead( RecordTypeId = leadId,lastname='Tester', firstName='Unit', company ='TEIS', Status = 'Assigned Unaccepted', Rating = 'Hot', country='United States', email= testcontact.Email, description='unit test ignore', Type_of_company__c='Distributor', CUSTOMER_CONTACTED__C=False, LEADSOURCE='LDAP', phone='+1 1231231234', STATE='PA');

        insert new list<lead>{testlead1, testlead2, testlead3};

        insert new Lead_Routing_key__c(name = 'test', Keyword__c = 'testind', Queue_Name__c = 'AMER Arrow Team', Active__c = True);
        test.starttest();

            RouteLead cls = new RouteLead() ;
            RouteLead.Leadrouter(new List<string>{testlead1.Id, testlead2.id, testlead3.id});
        test.stoptest();
       
    }
}