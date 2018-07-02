@isTest(SeeAllData=false)
/* -------------------------------------------------------------------------------------
 Test Class Written by Deepak Kumar 02/02/2016
 This class is used to cove the code coverage forthe Class IND_Coaching_PDF_Controller
 
* ------------------------------------------------------------------------------------- */
public class IND_Coaching_PDF_Controller_TestClass {

   Static testmethod Void IND_TestMethod()
    {
      
      Test.startTest(); 
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ChannelinsightData_test.Channelinsightdata_test(); 
       Account a = new account();
        a.Name= 'test account';
        a.RecordTypeId='012E0000000I9EG';
        a.STATDESC__c= 'Not Active';
        a.BillingCountry = 'US';
        insert a;
        
      
      Coaching__c coach= new Coaching__c(Coach__c=UserInfo.getUserId() ,Participant__c=UserInfo.getUserId() ,Coaching_Date_and_Time__c=system.today());
      
      insert coach;
      
      opportunity opp = new opportunity(name='test',Type='New Business',AccountID=a.id,Request_Type__c= 'sales only',Description__c='test',stagename = 'new',closedate = date.today()+5, Currency_Confirm__c = true);
      insert opp;
      
      Contact conta= new contact(lastname= 'test',AccountID=a.id,Salutation='Mr.',Firstname='test');
      insert conta;
      
      Coaching_Topics__c topic= new Coaching_Topics__c(opportunity__c=opp.id,Coaching_Record__c=coach.id,Account__c=a.id,Contact__c=conta.id,Coaching_Result__c='test',Follow_up_Activity__c='test',Topic_Detail__c='test',Topic__c='Performance - Net Promoter Score');
      //
      insert topic;
      
      PageReference ReportPage = Page.INDCoachingPDF;
      ReportPage.getParameters().put('id', String.valueOf(coach.Id));
      Test.setCurrentPage(ReportPage);
      
     
      ApexPages.StandardController str= new ApexPages.StandardController(coach);
       IND_Coaching_PDF_Controller PDFClass = new  IND_Coaching_PDF_Controller(str); 
      
          
      
      Test.stopTest();     
       
     }


}