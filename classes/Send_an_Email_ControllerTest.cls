/****
************************************************************************************************************************
      Name : Send_an_Email_ControllerTest
       Org : C2S-ChannelDev
 Copyright : © 2013 TE Connectivity
========================================================================================================================
   Summary : This class contain positive behavioral test methods Send_an_Email_Controller 
________________________________________________________________________________________________________________________
 Apex class whose code is covered : Send_an_Email_Controller 
========================================================================================================================
 Code Coverage History:                                                        
________________________________________________________________________________________________________________________
 VERSION DEVELOPER  AUTHOR           DATE       DETAIL                                  
________________________________________________________________________________________________________________________
     1.0             Abhijeet        21/01/2014    Test Class
***********************************************************************************************************************
****/

@isTest(seeAllData=true)
class Send_an_Email_ControllerTest{
    static testMethod void Send_an_Email_ControllerTestMethod() {
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
        vEMS.textbody              = 'Test';
        vEMS.toaddress             = 'test@zensar.in';
        insert vEMS;
       
            PageReference ref = Page.Send_via_Outlook; 
            Test.setCurrentPageReference(ref);
            ApexPages.StandardController stdController = new ApexPages.StandardController( vCs );             
            ApexPages.currentpage().getParameters().put('id',vCs.id);
            Send_an_Email_Controller cmc = new Send_an_Email_Controller(stdController);
            cmc.send();
            
        test.StopTest();
    }
}