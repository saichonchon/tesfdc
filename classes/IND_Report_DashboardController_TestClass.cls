@isTest  
public class IND_Report_DashboardController_TestClass {

   Static testmethod Void IND_TestMethod11()
    {
      PageReference ReportPage = Page.IND_TEDashboardAndReports;
      
      Test.setCurrentPage(ReportPage);
      
     // Report Newreport = new Report();
       
       List<IND_Report_and_Dashboard__c> ListRepDashtest = new List<IND_Report_and_Dashboard__c>();
       IND_Report_and_Dashboard__c RepDashtest = new IND_Report_and_Dashboard__c();
            
       
       RepDashtest.Name= 'testreport';
       RepDashtest.Add_in_Systems_Sub_Section__c=true;
       RepDashtest.Add_in_AM_Section__c=true;
       RepDashtest.Add_in_Executive_Section__c=true;
       RepDashtest.Is_Dashboard_Link__c=true;
       RepDashtest.Add_in_RSM_Section__c=true;
       RepDashtest.Add_in_Other_Section__c=true;
       RepDashtest.Add_in_Industrial_Sub_Section__c=true;
       RepDashtest.Add_in_Devices_Sub_Section__c=true;
       RepDashtest.Add_in_GSM_Section__c=true;
       RepDashtest.Add_in_FE_Section__c=true;
       RepDashtest.Add_in_GAM_Section__c=true;
       RepDashtest.ID_of_Report_or_Dashboard__c='01pc00000076tuO';
       RepDashtest.Short_Description__c='test report1 and dashboard';
       insert RepDashtest;
    
    Test.startTest();
      
       ListRepDashtest.add(RepDashtest);
      
      
             
     // ApexPages.StandardController StandReport = new ApexPages.standardController(Newreport); 
      
      Industrial_Report_DashboardController IND_Controller = new Industrial_Report_DashboardController();
    
     
      // String returnpage = IND_Controller.pageReferenceMethod().getUrl();
      //System.assertEquals('RSM,GSM', IND_Controller.UserReportingRole);
      ApexPages.currentPage().getParameters().put('Userinfo.getuserId()', '005E0000000XlE9');
      IND_Controller.ListRepDash=ListRepDashtest;
      IND_Controller.reportfuction();
      IND_Controller.sortreportfunction();
      Test.stopTest();
    }
      
      
      Static testmethod Void IND_TestMethod22()
    {
      PageReference ReportPage = Page.IND_TEDashboardAndReports;
      
      Test.setCurrentPage(ReportPage);
      
     // Report Newreport = new Report();
       
       List<IND_Report_and_Dashboard__c> ListRepDashtest = new List<IND_Report_and_Dashboard__c>();
       IND_Report_and_Dashboard__c RepDashtest = new IND_Report_and_Dashboard__c();
       
       
       
       RepDashtest.Name= 'testreport123';
       RepDashtest.Add_in_Systems_Sub_Section__c=true;
       RepDashtest.Add_in_AM_Section__c=true;
       RepDashtest.Add_in_Executive_Section__c=true;
       RepDashtest.Is_Dashboard_Link__c=false;
       RepDashtest.Add_in_RSM_Section__c=true;
       RepDashtest.Add_in_Other_Section__c=true;
       RepDashtest.Add_in_Industrial_Sub_Section__c=true;
       RepDashtest.Add_in_Devices_Sub_Section__c=true;
       RepDashtest.Add_in_GSM_Section__c=true;
       RepDashtest.Add_in_FE_Section__c=true;
       RepDashtest.Add_in_GAM_Section__c=true;
       RepDashtest.ID_of_Report_or_Dashboard__c='01pc00000076tuO';
       RepDashtest.Short_Description__c='test report1 and dashboard';
       insert RepDashtest;
       
      Test.startTest();
      
       ListRepDashtest.add(RepDashtest);
    
      
             
     // ApexPages.StandardController StandReport = new ApexPages.standardController(Newreport); 
      
      Industrial_Report_DashboardController IND_Controller = new Industrial_Report_DashboardController();
    
     
      // String returnpage = IND_Controller.pageReferenceMethod().getUrl();
      //System.assertEquals('RSM,GSM', IND_Controller.UserReportingRole);
      ApexPages.currentPage().getParameters().put('Userinfo.getuserId()', '005E0000000XlE9');
      IND_Controller.ListRepDash=ListRepDashtest;
      IND_Controller.reportfuction();
      IND_Controller.sortreportfunction();
      
       Test.stopTest();
    }
  
}