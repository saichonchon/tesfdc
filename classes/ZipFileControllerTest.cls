/****
************************************************************************************************************************
      Name : ZipFileControllerTest
       Org : C2S-ChannelDev
 Copyright : © 2013 TE Connectivity
========================================================================================================================
   Summary : This class contain positive behavioral test methods and negative behavioral test methods for 
             'ZipFileControllerTest'
________________________________________________________________________________________________________________________
 Apex class whose code is covered : NDRPartsController
========================================================================================================================
 Code Coverage History:                                                        
________________________________________________________________________________________________________________________
 VERSION DEVELOPER  AUTHOR           DATE       DETAIL                                  
________________________________________________________________________________________________________________________
     1.0             Abhijeet        18/10/2013    Test Class
***********************************************************************************************************************
****/

@isTest(seeAllData=true)
class ZipFileControllerTest{
    static testMethod void ZipFileControllerTestMethod() {
    test.startTest();
        Case vCs = new Case();
        vCs.Origin = 'Email-cip1';
        vCs.Inquiry_Type__c = 'Cancellation';
        vCs.Status= 'In Progress';
        vCs.Description = 'Test Description';
        vCs.SAP_Document_Number__c = 'SAP123';
        insert vCs;
        PDFController.PDFRelatedList(vCs.id);
        Attachment vAttach  = new Attachment();
        Blob bodyBlob    = Blob.valueOf('Test Attachment Body');
        vAttach.ParentId    = vCs.id;
        vAttach.OwnerId     = userinfo.getuserid();
        vAttach.Name        = 'Test Zensar Attachment';
        vAttach.Description = 'Test Zensar Attachment';
        vAttach.isPrivate   = false;
        vAttach.Body        = bodyBlob;
        insert vAttach;
        EmailMessage vEMS          = new EmailMessage();
        vEMS.BccAddress            = '';
        vEMS.parentid              = vCs.id;
        vEMS.CcAddress             = '';
        vEMS.FromAddress           = 'test@zensar.in';
        vEMS.FromName              = 'Test Zensar';
        vEMS.Headers               = '';
        vEMS.Htmlbody              = '';
        vEMS.incoming              = true;
        date mydate = Date.newinstance(2013, 12, 27);
        vEMS.messagedate           = mydate ;
        vEMS.subject               = 'Test';
        vEMS.textbody              = 'Test';
        vEMS.toaddress             = 'test@zensar.in';
        insert vEMS;
        Attachment vAttach1  = new Attachment();
        Blob bodyBlob1    = Blob.valueOf('Test Attachment Body');
        vAttach1.ParentId    = vEMS.id;
        vAttach1.OwnerId     = userinfo.getuserid();
        vAttach1.Name        = 'Test Zensar Attachment';
        vAttach1.Description = 'Test Zensar Attachment';
        vAttach1.isPrivate   = false;
        vAttach1.Body        = bodyBlob1;
        insert vAttach1;
        Attachment vAttach2  = new Attachment();
        Blob bodyBlob2    = Blob.valueOf('Test Attachment Body');
        vAttach2.ParentId    = vCs.id;
        vAttach2.OwnerId     = userinfo.getuserid();
        vAttach2.Name        = 'Test Zensar Attachment.zip';
        vAttach2.Description = 'Test Zensar Attachment';
        vAttach2.isPrivate   = false;
        vAttach2.Body        = bodyBlob2;
        insert vAttach2;
        String vAttIds = vAttach.id;
         PageReference ref = Page.CreateZipFile; 
            Test.setCurrentPageReference(ref);
            ApexPages.StandardController stdController = new ApexPages.StandardController( vCs );             
            ApexPages.currentpage().getParameters().put('id',vCs.id);
            ZipFileController cmc = new ZipFileController(stdController);
            cmc.zipcontent = 'ABC';
            cmc.runQuery();
            cmc.show();
            ZipFileController.getAttachment(vAttIds);
            cmc.uploadZip();
            cmc.DeleteDetailFile();
            System.debug('cmc.runQuery()');
        test.StopTest();
    }
}