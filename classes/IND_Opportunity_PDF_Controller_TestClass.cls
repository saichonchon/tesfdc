@isTest(SeeAllData=false)
/* -------------------------------------------------------------------------------------
 Test Class Written by Deepak Kumar 08/08/2015
Rajendra Shahane 03/29/2016  Modified for case - 900703
* ------------------------------------------------------------------------------------- */
public class IND_Opportunity_PDF_Controller_TestClass {

   Static testmethod Void IND_TestMethod()
    {
      
      Test.startTest(); 
        //Start: Rajendra Shahane Modified for case - 900703
        ClsTestCustomSettingHelper.getCCPTriggerSettings();
        ChannelinsightData_test.Channelinsightdata_test();
        //End: Rajendra Shahane Modified for case - 900703
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
       Account a = new account();
        a.Name= 'test account';
        a.RecordTypeId='012E0000000I9EG';
        a.STATDESC__c= 'Not Active';
        a.BillingCountry = 'US';
        insert a;
        
      opportunity opp = new opportunity(name='test',Type='New Business',AccountID=a.id,Request_Type__c= 'sales only',Description__c='test',stagename = 'new',closedate = date.today()+5, Currency_Confirm__c = true);
      insert opp;
      
      Contact conta= new contact(lastname= 'test',AccountID=a.id);
      insert conta;
      
      Contact repcon= new contact(lastname= 'test',AccountID=a.id,ReportsToId=conta.id);
      insert repcon;
      
      Custom_Opportunity_Contact_Role__c Crole= new Custom_Opportunity_Contact_Role__c(Contact__c=repcon.id,Opportunity__c=opp.id);
      insert Crole;
      
      Need__c need= new Need__c(Contact_Role__c=Crole.id,Need__c='test');
      insert need;
      
      Decision_Criteria__c DC=new Decision_Criteria__c(Opportunity__c=opp.id,Question_English__c='test',Active__c=true);
      insert DC;
      
      Key_Player__c KP=new Key_Player__c(Contact__c=conta.id,Opportunity__c=opp.id);
      insert KP;
      
      Key_Player_Criteria__c KPC=new Key_Player_Criteria__c(Decision_Criteria__c=DC.id,Priority__c='2',Key_Player__c=KP.id);
      insert KPC;
      
      PageReference ReportPage = Page.IND_Opportunity_PDF_Page;
      ReportPage.getParameters().put('id', String.valueOf(opp.Id));
      Test.setCurrentPage(ReportPage);
      
     
      ApexPages.StandardController str= new ApexPages.StandardController(opp);
      IND_Opportunity_PDF_Controller PDFClass = new IND_Opportunity_PDF_Controller(str); 
      
      
      PDFClass.ContinfoMethod();
      PDFClass.DecisioncreteriainfoMethod(); 
      PDFClass.OppCompetitorMethod();
      PDFClass.HighlowMethod();
      PDFClass.FullForecastMethod();
      
      
      Test.stopTest();     
       
     }


}