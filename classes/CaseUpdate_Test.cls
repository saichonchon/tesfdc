/**
*   This test class covers 
    Classes: CaseUpdate(87%) 
*   Case 00900721.
*
@  author Rajendra Shahane
@  created 2016-03-29
*
*/
@istest(seeAllData=false)
public class CaseUpdate_Test
{
    public static testmethod void CaseUpdate_UT()
    {
        ClsTestCustomSettingHelper.getAllSettings();
        CaseUpdate o = new CaseUpdate();
        CaseUtil_CCP.Countoncaseboolean = true;
        test.startTest();
        Case vCs = new Case();
        vCs.recordtypeid = Apex_Helper_Settings__c.getInstance('Customer Care Cloud').Value__c ;
        vCs.Origin = 'Email';
        vCs.Inquiry_Type__c = 'Cancellation';
        vCs.Status= 'In Progress';
        vCs.Description = 'Test Description';
        vCs.ownerId = userinfo.getuserid();
        vCs.Count_Incoming_Emails__c = 0;
        vCs.Quick_Email__c = false;
        
        Case vCs1 = new Case();
        vCs1.recordtypeid = Apex_Helper_Settings__c.getInstance('Customer Care Cloud').Value__c ;
        vCs1.Origin = 'Email';
        vCs1.Inquiry_Type__c = 'Cancellation';
        vCs1.Status= 'In Progress';
        vCs1.Description = 'Test Description';
        vCs1.ownerId = userinfo.getuserid();
        vCs1.Quick_Email__c = false;
        vCs1.Count_Incoming_Emails__c = 4;
        
        insert new List<Case>{vCs1,vCs};
        
        
        EmailMessage vEMS = new EmailMessage(parentid= vCs.id,ToAddress='test.test2@test2.com',FromAddress= 'test.test2@test.com',FromName= 'test.test@test.com',incoming= true,messagedate= System.today()+1,textbody = 'Test',headers = 'testX-SFDC-Original-RCPT:-abb@1nqbq7qvkw538lo9twysbht1uhy4gzfi7l7bqkddeqgb2tqy21.e-hkvemac.na9.case.salesforce.comtesttest');
        EmailMessage vEMS1 = new EmailMessage(parentid= vCs1.id,ToAddress='testa.test2@test2.com',FromAddress= 'test.test2@test1.com',FromName= 'test.test@test1.com',incoming= false,messagedate= System.today()+1,textbody = 'Test1',headers = 'testX-SFDC-Original-RCPT:-abb@1nqbq7qvkw538lo9twysbht1uhy4gzfi7l7bqkddeqgb2tqy21.e-hkvemac.na9.case.salesforce.comtesttest');
        

        List<EmailMessage> pEMessageLst = new List<EmailMessage>{vEMS,vEMS1};
        CaseUtil_CCP.Countoncaseboolean=false;
        o.CaseUpdateMethod(pEMessageLst);
        
        CaseUtil_CCP.Countoncaseboolean=true;
        test.stopTest();
    }
     public static testmethod void CaseUpdate_UT2()
    {
        ClsTestCustomSettingHelper.getAllSettings();
        CaseUpdate o = new CaseUpdate();
        CaseUtil_CCP.Countoncaseboolean = true;
        insert new Customer_Care_SharedEmailBox__c(Name='test.test2@test1.com');
        test.startTest();
        Case vCs2 = new Case();
        vCs2.recordtypeid = Apex_Helper_Settings__c.getInstance('Customer Care Cloud').Value__c ;
        vCs2.Origin = 'Email';
        vCs2.Inquiry_Type__c = 'Cancellation';
        vCs2.Status= 'In Progress';
        vCs2.Description = 'Test Description';
        vCs2.ownerId = userinfo.getuserid();
        vCs2.Quick_Email__c = true;
        vCs2.Count_Incoming_Emails__c = 1;
       
        
        insert new List<Case>{vCs2};
        
        EmailMessage vEMS2 = new EmailMessage(parentid= vCs2.id,ToAddress='test.test2@test2.com;test.test3@test2.com', FromAddress= 'test.test2@test1.com',FromName= 'test.test@test1.com',incoming= false,messagedate= System.today()+1,textbody = 'Test1',headers = 'testX-SFDC-Original-RCPT:-abb@1nqbq7qvkw538lo9twysbht1uhy4gzfi7l7bqkddeqgb2tqy21.e-hkvemac.na9.case.salesforce.comtesttest');        
        EmailMessage vEMS1 = new EmailMessage(parentid= vCs2.id,ToAddress='test1.test2@test2.com;test.test3@test2.com', FromAddress= 'test.test2@test1.com',FromName= 'test.test@test1.com',incoming= false,messagedate= System.today()+1,textbody = 'Test1',headers = 'testX-SFDC-Original-RCPT:-abb@1nqbq7qvkw538lo9twysbht1uhy4gzfi7l7bqkddeqgb2tqy21.e-hkvemac.na9.case.salesforce.comtesttest');        
        CaseUtil_CCP.Countoncaseboolean=false;
        o.CaseUpdateMethod(new List<EmailMessage>{vEMS2,vEMS1 });
        CaseUtil_CCP.Countoncaseboolean=true;
        test.stopTest();
    }
}