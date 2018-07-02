/*********************************************************************************************************************************************
      Name : BI_Email_BulkEmailCustomer_Test
       Org : C2S-Customer Care
 Copyright : © 2014 TE Connectivity
==============================================================================================================================================
   Summary : This class contain positive behavioral test methods BI_Email_BulkEmailCustomer Trigger and BI_Email_BulkEmailCustomerClass Class
______________________________________________________________________________________________________________________________________________
 Apex Trigger & class whose code is covered : BI_Email_BulkEmailCustomer Trigger & BI_Email_BulkEmailCustomerClass Class
==============================================================================================================================================
 Code Coverage History:                                                        
______________________________________________________________________________________________________________________________________________
 VERSION DEVELOPER  AUTHOR           DATE       DETAIL                                  
______________________________________________________________________________________________________________________________________________
     1.0             Ramakrishna Singara        03/04/2014    Test Class
**********************************************************************************************************************************************/

@isTest(seealldata=false)

Public class BI_Email_BulkEmailCustomer_Test
{
    public static testMethod void TestBulkEmailCustomer(){
        BulkEmailCustomer__c oBulkEmailCustomer = new BulkEmailCustomer__c(name = 'as400.scheduler2@goodmanmfg.com', To__c = 'cip1@tycoelectronics.com', subject__c = 'GOODMAN PO ACKNOWLEDGEMENT');
        insert oBulkEmailCustomer;
        
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        
        Case vCs = new Case();
        vCs.Origin = 'Email-cip1';
        vCs.Inquiry_Type__c = 'Cancellation';
        vCs.Status= 'In Progress';
        vCs.Description = 'Test Description';
        insert vCs;
        test.startTest(); 
        list<EmailMessage> lstEmailMessage = new list<EmailMessage>();

        EmailMessage vEMS = new EmailMessage(parentid = vCs.id, toaddress = 'ramakrishna.singara@zensar.in', subject = 'tetsing dev bulk', status = '0', messagedate = System.now(), CcAddress = '', BccAddress = '', FromAddress = 'narasimha.narra@te.com', FromName = 'Test Zensar', textbody = 'Test', Headers = '', Htmlbody = '', incoming = true);        
        lstEmailMessage.add(vEMS);
        CaseUtil_CCP.BI_Email_BulkEmailCustomer=false;
        EmailMessage vEMS1 = new EmailMessage(parentid = vCs.id, toaddress = 'cip1@tycoelectronics.com', subject = 'GOODMAN PO ACKNOWLEDGEMENT', status = '0', messagedate = System.now(), CcAddress = '', BccAddress = '', FromAddress = 'as400.scheduler2@goodmanmfg.com', FromName = 'Test Zensar', textbody = 'Test', Headers = '', Htmlbody = '', incoming = true);
        lstEmailMessage.add(vEMS1);
        CaseUtil_CCP.BI_Email_BulkEmailCustomer=false;
        EmailMessage vEMS2 = new EmailMessage(parentid = vCs.id, toaddress = 'cip1@tycoelectronics.com', subject = 'GOODMAN PO ACKNOWLEDGEMENT', status = '0', messagedate = System.now(), CcAddress = '', BccAddress = '', FromAddress = 'as400.scheduler2@goodmanmfg.com', FromName = 'Test Zensar', textbody = 'Test', Headers = '', Htmlbody = '', incoming = true);
        lstEmailMessage.add(vEMS2);
        CaseUtil_CCP.BI_Email_BulkEmailCustomer=false;
        EmailMessage vEMS3 = new EmailMessage(parentid = vCs.id, toaddress = 'cip1@tycoelectronics.com', subject = 'GOODMAN PO ACKNOWLEDGEMENT(@1)', status = '0', messagedate = System.now(), CcAddress = '', BccAddress = '', FromAddress = 'as400.scheduler2@goodmanmfg.com', FromName = 'Test Zensar', textbody = 'Test1', Headers = '', Htmlbody = '', incoming = true);
        lstEmailMessage.add(vEMS3);
        CaseUtil_CCP.BI_Email_BulkEmailCustomer=false;
        EmailMessage vEMS4 = new EmailMessage(parentid = vCs.id, toaddress = 'cip1@tycoelectronics.com', subject = 'GOODMAN PO ACKNOWLEDGEMENT(@2)', status = '0', messagedate = System.now(), CcAddress = '', BccAddress = '', FromAddress = 'as400.scheduler2@goodmanmfg.com', FromName = 'Test Zensar', textbody = 'Test2', Headers = '', Htmlbody = '', incoming = true);
        lstEmailMessage.add(vEMS4);

        BI_Email_BulkEmailCustomerClass.controlingDuplicateEmails(new list<EmailMessage>{new EmailMessage(FromAddress = 'as400.scheduler2@goodmanmfg.com', subject = 'GOODMAN PO ACKNOWLEDGEMENT', toaddress = 'cip1@tycoelectronics.com')});        
        insert lstEmailMessage;
      
        CaseUtil_CCP.BI_Email_BulkEmailCustomer=false;
        BI_Email_BulkEmailCustomerClass.controlingDuplicateEmails(lstEmailMessage);
        
        test.stopTest();
    }
}