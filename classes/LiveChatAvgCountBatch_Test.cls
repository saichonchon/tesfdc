/**
*  This test class used to test Batch class LiveChatAvgCountBatch.
*
@author Subramanian J
@created 2017-12-05
@version 1.0   
@since 41.0
*
@changelog
* coverage 100% 
* 
* 
* - Created
*/
@isTest
public Class LiveChatAvgCountBatch_Test 
{
    static testMethod void LiveChatAvgCountBatch_Test() 
    {
        LiveAgent_Average_Waiting_Time__c awt = new LiveAgent_Average_Waiting_Time__c();
        awt.Name = 'Avg Waiting Time';
        awt.AverageMinutes__c = 1;
        insert awt;
        
        LiveChatVisitor testVisitor = new LiveChatVisitor();        
        insert testVisitor;
         WebToCaseStrings__c wt = new WebToCaseStrings__c(name='Default',welcomeBack__c='Welcome back! Please fill out the rest of this form to submit your message',fillInContact__c='Please fill in additional contact to submit an incident' );
        insert wt;
        CaseFinalVariables__c cfv = new CaseFinalVariables__c (name='Default', CASE_STATUS_CLOSED_SPAM_STRING__c ='Closed (SPAM)', CASE_STATUS_NEW_STRING__c='New',TE_PIC_STANDART_CASE_RECORD_TYPE_STRING__c='TE_PIC_Standard_Case_Record_Type',CASE_PRIORITY_HIGHT_STRING__c='High',CASE_STATUS_IN_PROGRESS_CUSTOMER_STRING__c='Waiting for Response',TE_PIC_CONTACT_RECORD_TYPE_STRING__c='PIC_Contact');
        insert cfv;
        CaseFinalVariablesforCC__c cfcc = new CaseFinalVariablesforCC__c (name='Default', Customer_Care_Cloud_Record_Type_String__c ='Customer_Care_Cloud');
        insert cfcc; 
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        LiveChatTranscript lc1 = new LiveChatTranscript();
        lc1.Email_Address__c = 'test@test.com';
        lc1.Company__c = 'Test Company';
        lc1.EndTime = system.now()+2;
        lc1.StartTime = system.now();
        lc1.First_Name__c = 'Test Firstname';
        lc1.Last_Name__c = 'Test Lastname';
        lc1.Campaign__c = 'Test Campaign';
        lc1.RequestTime = system.now()-2;
        lc1.Registered_TE_com_Account__c = 'Test Account';
        lc1.LiveChatVisitorId = testVisitor.id;
        lc1.Chat_Type__c = 'CUSTOMER CARE';
        Insert Lc1;

        LiveChatTranscript lc2 = new LiveChatTranscript();
        lc2.Email_Address__c = 'test2@test.com';
        lc2.Company__c = 'Test Company2';
        lc2.EndTime = system.now()+2;
        lc2.StartTime = system.now();
        lc2.First_Name__c = 'Test Firstname2';
        lc2.Last_Name__c = 'Test Lastname2';
        lc2.Campaign__c = 'Test Campaign';
        lc2.RequestTime = system.now()-2;
        lc2.Registered_TE_com_Account__c = 'Test Account2';
        lc2.LiveChatVisitorId = testVisitor.id;
        lc2.Chat_Type__c = 'Product Information';
        Insert lc2;  
        
        
        Test.startTest();

            LiveChatAvgCountBatch obj = new LiveChatAvgCountBatch();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
}