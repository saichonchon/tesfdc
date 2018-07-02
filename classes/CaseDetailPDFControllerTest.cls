/****
************************************************************************************************************************
      Name : CaseDetailPDFControllerTest
       Org : C2S
 Copyright : © 2013 TE Connectivity
========================================================================================================================
   Summary : This class contain positive behavioral test methods and negative behavioral test methods for 
             'CaseDetailPDFController'
________________________________________________________________________________________________________________________
 Apex class whose code is covered : CaseDetailPDFController
========================================================================================================================
 Code Coverage History:                                                        
________________________________________________________________________________________________________________________
 VERSION DEVELOPER   AUTHOR          DATE       DETAIL                                  
________________________________________________________________________________________________________________________
     1.0            Abhijeet         22/10/2013    Test Class
***********************************************************************************************************************
****/

@isTest(seeAllData=true)
class CaseDetailPDFControllerTest{
    static testMethod void CaseDetailPDFControllerTestMethod() {
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
        vEMS.messagedate           = System.today()+1;
        vEMS.subject               = 'Test';
        vEMS.textbody              = 'Test';
        vEMS.toaddress             = 'test@zensar.in';
        insert vEMS;
        
         PageReference ref = Page.CaseDetailPDF; 
            Test.setCurrentPageReference(ref);
            ApexPages.StandardController stdController = new ApexPages.StandardController( vCs );             
            ApexPages.currentpage().getParameters().put('id',vCs.id);
            CaseDetailPDFController cmc = new CaseDetailPDFController(stdController);
           
        test.StopTest();
    }
}