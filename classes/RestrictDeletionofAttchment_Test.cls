@isTest(seealldata=true)
    public class RestrictDeletionofAttchment_Test{
        public static testMethod void TestAttachment(){
            test.startTest();
            Apex_Helper_Settings__c vCaseRT = Apex_Helper_Settings__c.getInstance('Customer Care Cloud');
            Case c = new Case();
            C.Status='New';
            C.Origin='Web';
            C.Reason='User attend training';
            C.Priority='High';
            C.Subject='Auto';
            C.Type='Question';   
            C.Case_Group__c = null;
            C.recordtypeid = vCaseRT.value__c;
            insert c;
            EmailMessage vEMS          = new EmailMessage();
            vEMS.parentid              = c.id;
            vEMS.FromAddress           = 'testem@test.com';
            vEMS.FromName              = 'Test Zensar';
            vEMS.incoming              = true;
            vEMS.subject               = 'Test';
            vEMS.textbody              = 'Test';
            vEMS.toaddress             = 'test@zensar.in';
            insert vEMS;
            Attachment aNew  = new Attachment();
         Blob bodyBlob    = Blob.valueOf('Test Attachment Body');
         aNew.ParentId    = vEMS.id;
         //aNew.OwnerId     = userinfo.getuserid();
         aNew.Name        = 'Test Zensar Attachment';
         aNew.Description = 'Test Zensar Attachment';
         aNew.isPrivate   = false;
         aNew.Body        = bodyBlob;
         insert aNew;
            try{
            delete aNew;
            }catch(Exception e){
            }
            test.stopTest();
            
            
        }    
    
    }