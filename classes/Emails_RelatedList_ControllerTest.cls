/****
************************************************************************************************************************
      Name : Emails_RelatedList_ControllerTest
       Org : C2S-ChannelDev
 Copyright : © 2013 TE Connectivity
========================================================================================================================
   Summary : This class contain positive behavioral test methods EmailsRelatedList_Controller
________________________________________________________________________________________________________________________
 Apex class whose code is covered : Emails_RelatedList_Controller
========================================================================================================================
 Code Coverage History:                                                        
________________________________________________________________________________________________________________________
 VERSION DEVELOPER  AUTHOR           DATE       DETAIL                                  
________________________________________________________________________________________________________________________
     1.0             Abhijeet        24/01/2014    Test Class
***********************************************************************************************************************
****/

@isTest(seeAllData=true)
class Emails_RelatedList_ControllerTest{
    static testMethod void Emails_RelatedList_ControllerTestMethod() {
    test.startTest();
        Case vCs = new Case();
        vCs.Origin = 'Email-cip1';
        vCs.Inquiry_Type__c = 'Cancellation';
        vCs.Status= 'In Progress';
        vCs.Description = 'Test Description';
        insert vCs;
        EmailMessage vEMS          = new EmailMessage();
        vEMS.BccAddress            = '';
        vEMS.parentid              = vCs.id;
        vEMS.CcAddress             = '';
        vEMS.FromAddress           = 'test@zensar.in';
        vEMS.FromName              = 'Test Zensar';
        vEMS.Headers               = '';
        vEMS.Htmlbody              = '';
        vEMS.incoming              = true;
        date mydate = System.today();
        vEMS.messagedate           = mydate ;
        vEMS.subject               = 'Test';
        vEMS.status = '0';
        vEMS.textbody              = 'Test';
        vEMS.toaddress             = 'test@zensar.in';
        insert vEMS;
       EmailMessage vEMS1          = new EmailMessage();
        vEMS1.parentid              = vCs.id;
        vEMS1.FromAddress           = 'test@zensar.in';
        vEMS1.incoming              = true;
       vEMS1.subject               = 'Test';
        vEMS1.status = '1';
        vEMS1.textbody              = 'Test';
        vEMS1.toaddress             = 'test@zensar.in';
        vEMS1.messageDate = System.today();
        insert vEMS1;
        EmailMessage vEMS4          = new EmailMessage();
        vEMS4.parentid              = vCs.id;
        vEMS4.FromAddress           = 'test@zensar.in';
        vEMS4.incoming              = true;
       vEMS4.subject               = 'Test';
        vEMS4.status = '4';
        vEMS4.textbody              = 'Test';
        vEMS4.toaddress             = 'test@zensar.in';
        vEMS4.messageDate = System.today();
        insert vEMS4;
        EmailMessage vEMS2          = new EmailMessage();
        vEMS2.parentid              = vCs.id;
        vEMS2.FromAddress           = 'test@zensar.in';
        vEMS2.incoming              = true;
       vEMS2.subject               = 'Test';
        vEMS2.status = '2';
        vEMS2.textbody              = 'Test';
        vEMS2.toaddress             = 'test@zensar.in';
        vEMS2.messageDate = System.today();
        insert vEMS2;
        EmailMessage vEMS3          = new EmailMessage();
        vEMS3.parentid              = vCs.id;
        vEMS3.FromAddress           = 'test@zensar.in';
        vEMS3.incoming              = true;
       vEMS3.subject               = 'Test';
        vEMS3.status = '3';
        vEMS3.textbody              = 'Test';
        vEMS3.toaddress             = 'test@zensar.in';
        vEMS3.messageDate = System.today();
        insert vEMS3;
        
         PageReference ref = Page.Emails_RelatedList; 
            Test.setCurrentPageReference(ref);
            ApexPages.StandardController stdController = new ApexPages.StandardController( vCs );             
            ApexPages.currentpage().getParameters().put('id',vCs.id);
            Emails_RelatedList_Controller cmc = new Emails_RelatedList_Controller(stdController);
            cmc.togglesort();
            
            
        test.StopTest();
    }
}