/**************************************************************************************************************************************************
Name:  DTCRequestPageExt_Test
Copyright © 2011 TE Connectivity
===================================================================================================================================================
Purpose: This class contain Test Methods for DTCRequestPageExt
---------------------------------------------------------------------------------------------------------------------------------------------------       
Related Apex class: DTCRequestPageExt
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
Version Developer          Date       Detail                                  Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Mrunal Parate     09/1/2014   Initial Development                      R-1455                                   
**************************************************************************************************************************************************/
@isTest(seeAllData=false)
private Class DTCRequestPageExt_Test
{    
    static testmethod void DTCpageTest1()
    {
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getCaseRecordTypes();
        test.starttest();
        
        Case Cs = new Case();
        cs.Requesting_for__c=userinfo.getUserId();
        Cs.DTC_Account_Manager_s_Supervisor_Manager__c= userinfo.getUserId();
        Cs.DTC_Request_Type__c = 'Sales hierarchy';
        Cs.Status= 'New';
        Cs.User_Region__c= 'EMEA';
        Cs.DTC_Change_Effective_Date__c= Date.today();
        cs.Subject='Test';
        
        Case Cs1 = new Case();
        cs1.recordtypeid = DTC_Request_page_access__c.getinstance('RecordType').Id__c;
        cs1.Requesting_for__c=userinfo.getUserId();
        Cs1.DTC_Account_Manager_s_Supervisor_Manager__c= userinfo.getUserId();
        Cs1.DTC_Request_Type__c = 'Sales hierarchy';
        Cs1.Status= 'New';
        Cs1.User_Region__c= 'EMEA';
        Cs1.DTC_Change_Effective_Date__c= Date.today();
        cs1.Subject='Test';
        insert new List<Case>{ cs1};
        
        ApexPAges.StandardController sc = new ApexPages.StandardController(cs);
        DTCRequestPageExt DTCReq = new DTCRequestPageExt(sc);
        DTCReq.redirectToPage();
        
        ApexPages.currentPage().getParameters().put('RecordType',DTC_Request_page_access__c.getinstance('RecordType').Id__c);
        ApexPAges.StandardController sc1 = new ApexPages.StandardController(cs);
        DTCRequestPageExt DTCReq1 = new DTCRequestPageExt(sc1);
        DTCReq1.redirectToPage();
        
        ApexPages.currentPage().getParameters().put('RecordType',DTC_Request_page_access__c.getinstance('RecordType').Id__c);
        DTCRequestPageExt DTCReq2 = new DTCRequestPageExt(new ApexPages.StandardController(cs1));
        DTCReq2.redirectToPage();
        
        Test.stoptest();
     }
}