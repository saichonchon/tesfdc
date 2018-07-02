@isTest(seeAllData=true)
class CheckMassCloseCase_Test{
    static testMethod void CheckCaseTestMethod() {
    test.startTest();
        Case Cs1 = new Case();
        Cs1.Origin = 'Email-cip1';
        Cs1.Inquiry_Type__c = 'Other';
        Cs1.Other_Inquiry_Type__c = 'test inquiry type';
        Cs1.Close_Date_Comments__c='test';
        Cs1.Status= 'In Progress';
        Cs1.Reason='New problem';
        Cs1.Description = 'Test Description';
        insert Cs1;
        Case Cs2 = new Case();
        Cs2.Origin = 'Email-cip1';
        Cs2.Inquiry_Type__c = 'Cancellation';
        Cs2.Other_Inquiry_Type__c = 'test';
        Cs2.Status= 'In Progress';
        Cs2.Description = 'Test Description';
        Cs2.Reason='New problem';
        insert Cs2;
        string s=cs1.id+','+cs2.id;
        ApexPages.StandardController stdController = new ApexPages.StandardController(Cs1);             
        ApexPages.currentpage().getParameters().put('ids',s);
        CheckCaseRTController chkcs=new CheckCaseRTController(stdController);
        chkcs.CheckRT();
        MassCloseCaseVFController massctl=new MassCloseCaseVFController();
        massctl.c1=cs1;
        massctl.Savefields();
        massctl.Canclefields();
        MassCloseCase_CCPController massccpcon = new MassCloseCase_CCPController();
        massccpcon.c1=cs1;
        
        massccpcon.Savefields();
        massccpcon.Canclefields();
        Test.stopTest();
        
    }
}