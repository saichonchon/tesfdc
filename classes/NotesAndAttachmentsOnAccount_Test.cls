/**
 * 
 *   This is the test class for the class - NotesAndAttachmentsOnAccount
 *
 * @author      Srinath Thallapally/ Prabhanjan Nandyala
 * @created     2016-07-07
 * @since      37.0     
 * @version     1.0                                                                
 * 
 * @changelog
 * 2016-07-07 Prabhanjan Nandyala <prabhanjan.nandyala@te.com>
 * - Created
 * - test coverage - 100%
 */
@isTest
public class NotesAndAttachmentsOnAccount_Test {
    static testMethod void testnoteattachment(){
                
        test.startTest();
        
        ClsTestCustomSettingHelper.getApex_Helper_Settings(); 
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ChannelinsightData_test.ChannelinsightData_test();
        
        //insert account
        Account a =  ClsTestHelp.createTestAccounts();
        insert a;
        ApexPages.currentPage().getParameters().put('Id',a.id);
        ApexPages.StandardController actid = new ApexPages.StandardController(a);
        NotesAndAttachmentsOnAccount cntrolrclsinstance = new NotesAndAttachmentsOnAccount(actid);
        
        //PageReference pageRef1 = Page.Account_RelatedList_Sri1;
        //system.Test.setCurrentPage(pageReference pageRef1);
        
        //below line is working
        //system.Test.setCurrentPage(Page.Account_RelatedList_Sri1);
        
        Attachment attach=new Attachment();    
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=a.id;
        attach.Description = 'Test';
        insert attach;
        Attachment insertedattachment = [SELECT Body,BodyLength,ContentType,CreatedById,CreatedBy.Name,CreatedDate,Description,Id,IsDeleted,IsPrivate,LastModifiedById,LastModifiedDate,Name,OwnerId,ParentId, Parent.Name FROM Attachment where Id=:attach.Id ];
         
        Note nt = new Note();
        nt.Body = 'Note test Body';
        nt.ParentId = a.id;
        nt.Title = 'Note Test Title';
        insert nt;
        
        Note insertedNote = [SELECT Body,CreatedById,CreatedBy.Name,CreatedDate,Id,IsDeleted,IsPrivate,LastModifiedById,LastModifiedDate,OwnerId,ParentId,Parent.Name, Title FROM Note where id =:nt.Id ];
        
        
        NotesAndAttachmentsOnAccount.attnotewrapper wrpprinstnce = new NotesAndAttachmentsOnAccount.attnotewrapper(insertedattachment);
        NotesAndAttachmentsOnAccount.attnotewrapper wrpprinstnce1 = new NotesAndAttachmentsOnAccount.attnotewrapper(insertedNote);
        
        cntrolrclsinstance.Selectednttattid = attach.id;
        cntrolrclsinstance.DeleteNoteattachment();
           
        cntrolrclsinstance.Selectednttattid = nt.id;
        cntrolrclsinstance.DeleteNoteattachment();
    test.stopTest();
    }
}