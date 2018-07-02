@isTest 
public class LiveagentCtrl_1_test_1 {
/**********************************************************************************************************************************************
*******
Name: LiveagentCtrl_1_test
Copyright © 2016 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose:  provide test coverage for LiveagentCtrl_1 class.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE          DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0      Prabhanjan N       5/05/2016    Controller                
***********************************************************************************************************************************************
*****/
//@isTest
    @isTest
    public static void LiveagentCtrl_1Method(){
        PageReference pageRef = Page.liveagentintro;
        Test.setCurrentPage(pageRef);
        Test.startTest();
         ApexPages.currentPage().getParameters().put('additionalInfo','RW1haWw9Sm9obkB0ZXN0Z21haWwuY29tJkZpcnN0X05hbWU9Sm9obiZMYXN0X05hbWU9VGVzdGluZyZDb3VudHJ5PVVTQSZMYW5ndWFnZT1lbiZTdWJzY3JpYmVkPU5PJlRFQ2V3dDc9YWMwOGIzODAtMGZlNi00ZTMyLTgxNWQtOTUyNjk5YjQ0Y2I2JkN1c3RfQWNjdHM9MDAyOTowMTMxOTg4OCwwMDY3OjAyODc2OTE5');
        Live_Agent_Country_List__c lac = new Live_Agent_Country_List__c( Chinese_Label__c = '美国',
                                                                         Country_Code_2_Digit__c = 'US',
                                                                        Country_Code_3_Digit__c = 'USA',
                                                                        English__c = 'United States' , 
                                                                        German__c = 'Vereinigte Staaten', 
                                                                        Japanese__c='米国' , 
                                                                        REGION_CODE__c='0002' );
        insert lac;
        
        
         
        CC_Liveagent_Routing_Rules__c  ccLARules = new CC_Liveagent_Routing_Rules__c();
        ccLARules.Name = 'Test Button';
        ccLARules.CustomerOrgAccNum__c ='0029:01319888';
        ccLARules.Primary_Button_Ids__c = '573220000004CCA,573220000004CC2,573220000004CBj';
        //ccLARules.Region__c = 'AMER';
        insert ccLARules;
      Live_Agent_Org_Settings__c LAOrgset = new Live_Agent_Org_Settings__c();
      LAOrgset.Live_Agent_API_Endpoint__c ='https://d.la3-c1cs-chi.salesforceliveagent.com/chat/rest/Visitor/Availability?org_id=00D220000008g6o&deployment_id=572E0000000blJJ&Availability.ids=';  
      LAOrgset.AdditionalInfo__c='RW1haWw9JkZpcnN0X05hbWU9Jkxhc3RfTmFtZT0mQ291bnRyeT1VU0EmTGFuZ3VhZ2U9ZW4mU3Vic2NyaWJlZD0mVEVDZXd0Nz05NzAxMjBkYy0zMGE0LTQ4M2MtYmI2Mi0wODQzOTQ2OGIxOWQ';
        LAOrgset.SetupOwnerId=UserInfo.getOrganizationId();
      insert LAOrgset;
        
        CC_Liveagent_Language_Rules__c cclalangrls = new CC_Liveagent_Language_Rules__c();
        cclalangrls.Button_Ids__c = '573220000004CBq';
        cclalangrls.Name = 'test1';
        cclalangrls.Language__c = 'Chinese';
        cclalangrls.Region__c = 'AMER';        
        insert cclalangrls;
        
        CC_Liveagent_Language_Rules__c cclalangrls2 = new CC_Liveagent_Language_Rules__c();
        cclalangrls2.Button_Ids__c = '573220000004CBr,573220000004CCW';
        cclalangrls2.Name = 'test2';
        cclalangrls2.Language__c = 'English';
        cclalangrls2.Region__c = 'APAC';       
        insert cclalangrls2;
        
       
        
        LiveagentCtrl_1 l = new LiveagentCtrl_1();
        ApexPages.currentPage().getParameters().put('Country','USA');
        ApexPages.currentPage().getParameters().put('Language','en');
        l.longName='';
        l.cclaEnglishButtonids='';
        l.cclaChineseButtonids='';
        l.primarybuttonidsString='';
        l.prmName='';
        l.piclonghtmlname='';
        l.deactivatePrechat=false;
        
        l.init();
        
        l.ChatButtonId_DE='573E0000000blJJ';
        l.ChatButtonId_EN ='573E0000000blJJ';
        l.ChatButtonId_ES='573E0000000blJJ';
        l.ChatButtonId_ZH='573E0000000blJJ';
        l.VisitorCountry = 'USA';
        l.VisitorCountryCode_2_Digit = 'US';
        l.chkNews_Evnts = false;
        
        l.onload=false;
        
        
        l.listChatButtons();
        
        l.VisitorLocaleLang = 'DEUTSCH';
        l.HTMLTranslations();
        
        LiveAgentChatByBooksCTRL labb = new LiveAgentChatByBooksCTRL ();
                
        labb.VisitorLocaleLang = 'DEUTSCH';
        labb.HTMLTranslations();                           
        LiveagentCtrl_1 l2 = new LiveagentCtrl_1();
        l2.init();
        l2.picChineseLanguageButtonResponse = 'test "isAvailable":true';
        l2.picGermanLanguageButtonResponse = 'test "isAvailable":true';
        l2.picEnglishLanguageButtonResponse = 'test "isAvailable":true';
        l2.PrimaryButtonResponse = 'test "isAvailable":true';
        l2.ChineseLanguageButtonResponse = 'test "isAvailable":true';
        l2.EnglishLanguageButtonResponse = 'test "isAvailable":true';
        l2.picSpanishLanguageButtonResponse = 'test "isAvailable":true';                                

        l2.availableAgentButtonIds();        
        l2.selectedCCorPIC = 'SELECT';
        l2.availableAgentButtonIds();
        
        l2.selectedCCorPIC = 'ProductInformationPortal';    
        l2.availableAgentButtonIds();
        
        l2.selectedCCorPIC = 'CustomerCarePortal';
        l2.availableAgentButtonIds();                
        Test.stopTest();
    } 

    @isTest
    public static void LiveagentCtrl_1Method02(){
        PageReference pageRef = Page.liveagentintro;
        Test.setCurrentPage(pageRef);
        Test.startTest();
         ApexPages.currentPage().getParameters().put('additionalInfo','RW1haWw9Sm9obkB0ZXN0Z21haWwuY29tJkZpcnN0X05hbWU9Sm9obiZMYXN0X05hbWU9VGVzdGluZyZDb3VudHJ5PUlORCZMYW5ndWFnZT1lbiZTdWJzY3JpYmVkPU5PJlRFQ2V3dDc9YWMwOGIzODAtMGZlNi00ZTMyLTgxNWQtOTUyNjk5YjQ0Y2I2JkN1c3RfQWNjdHM9MDAyOTowMTMxOTg4OCwwMDY3OjAyODc2OTE5');
        Live_Agent_Country_List__c lac = new Live_Agent_Country_List__c( Chinese_Label__c = '美国',
                                                                         Country_Code_2_Digit__c = 'US',
                                                                        Country_Code_3_Digit__c = 'USA',
                                                                        English__c = 'United States' , 
                                                                        German__c = 'Vereinigte Staaten', 
                                                                        Japanese__c='米国' , 
                                                                        REGION_CODE__c='0002' );
        insert lac;
        
        CC_Liveagent_Routing_Rules__c  ccLARules = new CC_Liveagent_Routing_Rules__c();
        ccLARules.Name = 'Test Button';
        ccLARules.CustomerOrgAccNum__c ='0029:01319888';
        ccLARules.Primary_Button_Ids__c = '573220000004CCA,573220000004CC2,573220000004CBj';
        //ccLARules.Region__c = 'AMER';
        insert ccLARules;
      Live_Agent_Org_Settings__c LAOrgset = new Live_Agent_Org_Settings__c();
      LAOrgset.Live_Agent_API_Endpoint__c ='https://d.la3-c1cs-chi.salesforceliveagent.com/chat/rest/Visitor/Availability?org_id=00D220000008g6o&deployment_id=572E0000000blJJ&Availability.ids=';  
      LAOrgset.AdditionalInfo__c='RW1haWw9JkZpcnN0X05hbWU9Jkxhc3RfTmFtZT0mQ291bnRyeT1VU0EmTGFuZ3VhZ2U9ZW4mU3Vic2NyaWJlZD0mVEVDZXd0Nz05NzAxMjBkYy0zMGE0LTQ4M2MtYmI2Mi0wODQzOTQ2OGIxOWQ';
        LAOrgset.SetupOwnerId=UserInfo.getOrganizationId();
      insert LAOrgset;
        
        CC_Liveagent_Language_Rules__c cclalangrls = new CC_Liveagent_Language_Rules__c();
        cclalangrls.Button_Ids__c = '573220000004CBq';
        cclalangrls.Name = 'test1';
        cclalangrls.Language__c = 'Chinese';
        cclalangrls.Region__c = 'AMER';        
        insert cclalangrls;
        
        CC_Liveagent_Language_Rules__c cclalangrls2 = new CC_Liveagent_Language_Rules__c();
        cclalangrls2.Button_Ids__c = '573220000004CBr,573220000004CCW';
        cclalangrls2.Name = 'test2';
        cclalangrls2.Language__c = 'English';
        cclalangrls2.Region__c = 'APAC';       
        insert cclalangrls2;
        
       
        
        LiveagentCtrl_1 l = new LiveagentCtrl_1();
        ApexPages.currentPage().getParameters().put('Country','USA');
        ApexPages.currentPage().getParameters().put('Language','en');
        l.longName='';
        l.cclaEnglishButtonids='';
        l.cclaChineseButtonids='';
        l.primarybuttonidsString='';
        l.prmName='';
        l.piclonghtmlname='';
        l.deactivatePrechat=false;
        
        l.init();
        
        l.ChatButtonId_DE='573E0000000blJJ';
        l.ChatButtonId_EN ='573E0000000blJJ';
        l.ChatButtonId_ES='573E0000000blJJ';
        l.ChatButtonId_ZH='573E0000000blJJ';
        l.VisitorCountry = 'USA';
        l.VisitorCountryCode_2_Digit = 'US';
        l.chkNews_Evnts = false;
        
        l.onload=false;
        
        
        l.listChatButtons();
        
        l.VisitorLocaleLang = 'DEUTSCH';
        l.HTMLTranslations();
        
        LiveAgentChatByBooksCTRL labb = new LiveAgentChatByBooksCTRL ();
                
        labb.VisitorLocaleLang = 'DEUTSCH';
        labb.HTMLTranslations();                           
        LiveagentCtrl_1 l2 = new LiveagentCtrl_1();
        l2.picChineseLanguageButtonResponse = 'test "isAvailable":true';
        l2.picGermanLanguageButtonResponse = 'test "isAvailable":true';
        l2.picEnglishLanguageButtonResponse = 'test "isAvailable":true';
        l2.PrimaryButtonResponse = 'test "isAvailable":true';
        l2.ChineseLanguageButtonResponse = 'test "isAvailable":true';
        l2.EnglishLanguageButtonResponse = 'test "isAvailable":true';
        l2.picSpanishLanguageButtonResponse = 'test "isAvailable":true';                                

        l2.availableAgentButtonIds();        
        l2.selectedCCorPIC = 'SELECT';
        l2.availableAgentButtonIds();
        
        l2.selectedCCorPIC = 'ProductInformationPortal';    
        l2.availableAgentButtonIds();
        
        l2.selectedCCorPIC = 'CustomerCarePortal';
        l2.availableAgentButtonIds();                
        Test.stopTest();
    } 

        public static testmethod void LiveagentCtrl_1Method01(){
        PageReference pageRef = Page.liveagentintro;
        Test.setCurrentPage(pageRef);
        Test.startTest();
         ApexPages.currentPage().getParameters().put('additionalInfo','RW1haWw9Sm9obkB0ZXN0Z21haWwuY29tJkZpcnN0X05hbWU9Sm9obiZMYXN0X05hbWU9VGVzdGluZyZDb3VudHJ5PUlORCZMYW5ndWFnZT1lbiZTdWJzY3JpYmVkPU5PJlRFQ2V3dDc9YWMwOGIzODAtMGZlNi00ZTMyLTgxNWQtOTUyNjk5YjQ0Y2I2JkN1c3RfQWNjdHM9MDAyOTowMTMxOTg4OCwwMDY3OjAyODc2OTE5');
        ApexPages.currentPage().getParameters().put('test','Test_URL');
        Live_Agent_Country_List__c lac = new Live_Agent_Country_List__c( Chinese_Label__c = '美国',
                                                                         Country_Code_2_Digit__c = 'US',
                                                                        Country_Code_3_Digit__c = 'USA',
                                                                        English__c = 'United States' , 
                                                                        German__c = 'Vereinigte Staaten', 
                                                                        Japanese__c='米国' , 
                                                                        REGION_CODE__c='0002' );
        insert lac;
       
        
        CC_Liveagent_Routing_Rules__c  ccLARules = new CC_Liveagent_Routing_Rules__c();
        ccLARules.Name = 'Test Button';
        ccLARules.CustomerOrgAccNum__c ='0029:01319888';
        ccLARules.Primary_Button_Ids__c = '573220000004CCA,573220000004CC2,573220000004CBj';
        //ccLARules.Region__c = 'AMER';
        insert ccLARules;
      Live_Agent_Org_Settings__c LAOrgset = new Live_Agent_Org_Settings__c();
      LAOrgset.Live_Agent_API_Endpoint__c ='https://d.la3-c1cs-chi.salesforceliveagent.com/chat/rest/Visitor/Availability?org_id=00D220000008g6o&deployment_id=572E0000000blJJ&Availability.ids=';  
      LAOrgset.AdditionalInfo__c='RW1haWw9JkZpcnN0X05hbWU9Jkxhc3RfTmFtZT0mQ291bnRyeT1VU0EmTGFuZ3VhZ2U9ZW4mU3Vic2NyaWJlZD0mVEVDZXd0Nz05NzAxMjBkYy0zMGE0LTQ4M2MtYmI2Mi0wODQzOTQ2OGIxOWQ';
        LAOrgset.SetupOwnerId=UserInfo.getOrganizationId();
      insert LAOrgset;
        
        CC_Liveagent_Language_Rules__c cclalangrls = new CC_Liveagent_Language_Rules__c();
        cclalangrls.Button_Ids__c = '573220000004CBq';
        cclalangrls.Name = 'test1';
        cclalangrls.Language__c = 'Chinese';
        cclalangrls.Region__c = 'AMER';        
        insert cclalangrls;
        
        CC_Liveagent_Language_Rules__c cclalangrls2 = new CC_Liveagent_Language_Rules__c();
        cclalangrls2.Button_Ids__c = '573220000004CBr,573220000004CCW';
        cclalangrls2.Name = 'test2';
        cclalangrls2.Language__c = 'English';
        cclalangrls2.Region__c = 'APAC';       
        insert cclalangrls2;
        
       
            
        LiveagentCtrl_1 l2 = new LiveagentCtrl_1();                                      
        l2.availableAgentButtonIds();
             l2.init();
        l2.selectedCCorPIC = 'ProductInformationPortal';    
        l2.availableAgentButtonIds();
        
        l2.selectedCCorPIC = 'CustomerCarePortal';
        l2.availableAgentButtonIds();                
        Test.stopTest();            
        }
            public static testmethod void CaseServicesMethod() {    
        WebToCaseStrings__c wt = new WebToCaseStrings__c(name='Default',welcomeBack__c='Welcome back! Please fill out the rest of this form to submit your message',fillInContact__c='Please fill in additional contact to submit an incident' );
        insert wt;
        CaseFinalVariables__c cfv = new CaseFinalVariables__c (name='Default', CASE_STATUS_CLOSED_SPAM_STRING__c ='Closed (SPAM)', CASE_STATUS_NEW_STRING__c='New',TE_PIC_STANDART_CASE_RECORD_TYPE_STRING__c='TE_PIC_Standard_Case_Record_Type',CASE_PRIORITY_HIGHT_STRING__c='High',CASE_STATUS_IN_PROGRESS_CUSTOMER_STRING__c='Waiting for Response',TE_PIC_CONTACT_RECORD_TYPE_STRING__c='PIC_Contact');
        insert cfv;
        CaseFinalVariablesforCC__c cfcc = new CaseFinalVariablesforCC__c (name='Default', Customer_Care_Cloud_Record_Type_String__c ='Customer_Care_Cloud');
        insert cfcc;

    LiveChatVisitor testVisitor = new LiveChatVisitor();
        insert testVisitor;
    ClsTestCustomSettingHelper.getApex_Helper_Settings();
        LiveChatTranscript lc1 = new LiveChatTranscript();
        lc1.Email_Address__c = 'test@test.com';
        lc1.Company__c = 'Test Company';
        lc1.EndTime = system.now()+2;
        lc1.StartTime = system.now();
        lc1.First_Name__c = 'Test Firstname';
        lc1.Last_Name__c = 'Test Lastname';
        lc1.Campaign__c = 'Test Campaign';
        lc1.RequestTime = system.now()-2;
        lc1.Registered_TE_com_Account__c = 'Test Account';
        lc1.LiveChatVisitorId = testVisitor.id;
        lc1.Chat_Type__c = 'CUSTOMER CARE';
        Insert Lc1;

        LiveChatTranscript lc2 = new LiveChatTranscript();
        lc2.Email_Address__c = 'test2@test.com';
        lc2.Company__c = 'Test Company2';
        lc2.EndTime = system.now()+2;
        lc2.StartTime = system.now();
        lc2.First_Name__c = 'Test Firstname2';
        lc2.Last_Name__c = 'Test Lastname2';
        lc2.Campaign__c = 'Test Campaign';
        lc2.RequestTime = system.now()-2;
        lc2.Registered_TE_com_Account__c = 'Test Account2';
        lc2.LiveChatVisitorId = testVisitor.id;
        lc2.Chat_Type__c = 'Product Information';
        Insert lc2;  
} 
}