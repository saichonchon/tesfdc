/****
************************************************************************************************************************
      Name : NDRPartsControllerTest
       Org : C2S-ChannelDev
 Copyright : © 2013 TE Connectivity
========================================================================================================================
   Summary : This class contain positive behavioral test methods and negative behavioral test methods for 
             'NDRPartsController'
________________________________________________________________________________________________________________________
 Apex class whose code is covered : NDRPartsController
========================================================================================================================
 Code Coverage History:                                                        
________________________________________________________________________________________________________________________
 VERSION DEVELOPER             DATE       DETAIL                                  
________________________________________________________________________________________________________________________
     1.0                     24/4/2013    Test Class
     1.0 Rajendra Shahane    14/04/2016   Modified to improve code coverage for case 00829354
***********************************************************************************************************************
****/

@isTest(seeAllData=false)
class NDRPartsControllerTest{
    static testMethod void TestNDRParts() {
    // Start : Rajendra Shahane 04/14/2016  Modified for case - 00829354
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        ClsTestCustomSettingHelper.getNDRRedflagreason();
        // End: Rajendra Shahane 04/14/2016  Modified for case - 00829354
        ClsTestCustomSettingHelper.getrealtime_Callout_Settings();
    /*------------- Varible declaration and initialisation --------------------*/    
    List<Opportunity> vLstOppty = new List<Opportunity>();
    Id vRTOppId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('NDR Opportunity').getRecordTypeId();//[select id from RecordType where sObjectType =: 'Opportunity' and name =: 'NDR Opportunity'];  
    Id vRTOppPartId = Schema.SObjectType.Opportunity_Part__c.getRecordTypeInfosByName().get('NDR Opportunity Parts').getRecordTypeId();//[select id from RecordType where sObjectType =: 'Opportunity_Part__c' and name =: 'NDR Opportunity Parts'];  
    Id vRTOppCcrId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('CCR Opportunity').getRecordTypeId();
     
    Profile p = [Select Id, Name From Profile 
    where Name = 'Channel Standard User' 
    or Name = 'Service Account' 
    or Name ='System Administrator' 
    or Name ='Systemadministrator' limit 1];
    /*------------------ User created for Test ------------------------------*/                        
    User u = ClsTestHelp.createTestUsers();
    u.Email = 'test@test.com';
    u.Alias = 'abc';
    u.CommunityNickname = 'TsMD';
    u.ProfileId = p.Id;
    insert u;
    system.runas(u){
        test.starttest();

    /*--------------------- Insert Opportunity -----------------------------*/
    Opportunity vOppty = ClsTestHelp.createTestOpportunity();
    vOppty.RecordTypeId = vRTOppId;
    vOppty.NDR_SAP_Region__c='AP';
    vOppty.NDR_GPMS_ID__c = '000';
    insert vOppty;       
    Opportunity vCcrOppty = ClsTestHelp.createTestOpportunity();
    vCcrOppty.RecordTypeId = vRTOppCcrId;
    vCcrOppty.NDR_SAP_Region__c='AP';
    vCcrOppty.NDR_GPMS_ID__c = '000';
    insert vCcrOppty;        
    Product_Hierarchy__c ph = new Product_Hierarchy__c();
    ph.name = 'Test Zensar';
    ph.Hierarchy_Level_Type__c = 'CBC1';
    ph.Description__c = 'Industrial';
    insert ph;
    Part__c part = new Part__c();
    part.name = 'Test Zensar';
    part.Description__c = 'Sniper';
    part.Product_Hierarchy__c = ph.Id;
    insert part;
    /*------------------ Insert Opportunity Part ---------------------------*/
    List<Opportunity_Part__c> testOppPartList = new List<Opportunity_Part__c>();
    Opportunity_Part__c vOpptypart1 = ClsTestHelp.createTestOpportunityPart();
    vOpptypart1.Opportunity__c = vOppty.Id;
    vOpptypart1.Part__c = part.Id;
    vOpptypart1.GPL__c = ph.Id;
    //vOpptypart1.Red_Flag_Reason__c='1,2';
    vOpptypart1.recordtypeid =vRTOppPartid;
    testOppPartList.add(vOpptypart1);
    /*Opportunity_Part__c vOpptypart2 = ClsTestHelp.createTestOpportunityPart();
    vOpptypart2.Opportunity__c = vOppty.Id;
    vOpptypart2.Part__c = part.Id;
    vOpptypart2.GPL__c = ph.Id;
    vOpptypart2.recordtypeid =vRTOppPartid;
    vOpptypart2.NDR_Rejection_Reason__c='Other';
    vOpptypart2.NDR_Rejection_Comments__c='Other';
    vOpptypart2.Red_Flag_Reason__c='1,2';
    testOppPartList.add(vOpptypart2);*/
    insert testOppPartList;

     /*------------ Set page reference to NDRParts page -------------------*/       
            PageReference ref = Page.NDRParts; 
            Test.setCurrentPageReference(ref);
            ApexPages.StandardController stdController = new ApexPages.StandardController( vOppty );             
            ApexPages.currentpage().getParameters().put('id',vOppty.id);
            NDRPartsController cmc = new NDRPartsController(stdController);
            cmc.vSelectedRecordId = vOpptypart1.id;
            cmc.vSelectedId = vOpptypart1.id;
            cmc.vSetParamId = vOpptypart1.id;
            
            cmc.rejectActionOnNDR();
            cmc.saveRejectComments();
            cmc.closeRejectPopup();
            cmc.ApproveActionOnNDR();
            cmc.ShowRejectPopup();
            cmc.ShowApprovePopup();
            cmc.saveApproveComments();
            cmc.closeApprovePopup();
       Test.stopTest(); 
        }
    }
    static testMethod void TestNDRParts1() {
        // Start : Rajendra Shahane 04/14/2016  Modified for case - 00829354
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        ClsTestCustomSettingHelper.getNDRRedflagreason();
        // End: Rajendra Shahane 04/14/2016  Modified for case - 00829354
    /*------------- Varible declaration and initialisation --------------------*/    
    List<Opportunity> vLstOppty = new List<Opportunity>();
    Id vRTOppId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('NDR Opportunity').getRecordTypeId();//[select id from RecordType where sObjectType =: 'Opportunity' and name =: 'NDR Opportunity'];  
    Id vRTOppPartId = Schema.SObjectType.Opportunity_Part__c.getRecordTypeInfosByName().get('NDR Opportunity Parts').getRecordTypeId();//[select id from RecordType where sObjectType =: 'Opportunity_Part__c' and name =: 'NDR Opportunity Parts'];  
    Id vRTOppCcrId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('CCR Opportunity').getRecordTypeId();
     
    Profile p = [Select Id, Name From Profile 
    where Name = 'Channel Standard User' 
    or Name = 'Service Account' 
    or Name ='System Administrator' 
    or Name ='Systemadministrator' limit 1];
    /*------------------ User created for Test ------------------------------*/                        
    User u = ClsTestHelp.createTestUsers();
    u.Email = 'test@test.com';
    u.Alias = 'abc';
    u.CommunityNickname = 'TsMD';
    u.ProfileId = p.Id;
    insert u;
    system.runas(u){
        test.starttest();

    /*--------------------- Insert Opportunity -----------------------------*/
    Opportunity vOppty = ClsTestHelp.createTestOpportunity();
    vOppty.RecordTypeId = vRTOppId;
    vOppty.NDR_SAP_Region__c='AP';
    vOppty.NDR_GPMS_ID__c = '000';
    insert vOppty;
    Opportunity vCcrOppty = ClsTestHelp.createTestOpportunity();
    vCcrOppty.RecordTypeId = vRTOppCcrId;
    vCcrOppty.NDR_SAP_Region__c='AP';
    vCcrOppty.NDR_GPMS_ID__c = '000';
    insert vCcrOppty;        
    Product_Hierarchy__c ph = new Product_Hierarchy__c();
    ph.name = 'Test Zensar';
    ph.Hierarchy_Level_Type__c = 'CBC1';
    ph.Description__c = 'Industrial';
    insert ph;
    Part__c part = new Part__c();
    part.name = 'Test Zensar';
    part.Description__c = 'Sniper';
    part.Product_Hierarchy__c = ph.Id;
    insert part;
    /*------------------ Insert Opportunity Part ---------------------------*/
    List<Opportunity_Part__c> testOppPartList = new List<Opportunity_Part__c>();
    Opportunity_Part__c vOpptypart1 = ClsTestHelp.createTestOpportunityPart();
    vOpptypart1.Opportunity__c = vOppty.Id;
    vOpptypart1.Part__c = part.Id;
    vOpptypart1.GPL__c = ph.Id;
    //vOpptypart1.Red_Flag_Reason__c='1,2';
    vOpptypart1.recordtypeid =vRTOppPartid;
    testOppPartList.add(vOpptypart1);
    Opportunity_Part__c vOpptypart2 = ClsTestHelp.createTestOpportunityPart();
    vOpptypart2.Opportunity__c = vOppty.Id;
    vOpptypart2.Part__c = part.Id;
    vOpptypart2.GPL__c = ph.Id;
    vOpptypart2.recordtypeid =vRTOppPartid;
    vOpptypart2.NDR_Rejection_Reason__c='Other';
    vOpptypart2.NDR_Rejection_Comments__c='Other';
    vOpptypart2.Red_Flag_Reason__c='1,2';
    testOppPartList.add(vOpptypart2);
    insert testOppPartList;

     /*------------ Set page reference to NDRParts page -------------------*/       
            PageReference ref = Page.NDRParts; 
            Test.setCurrentPageReference(ref);
            ApexPages.StandardController stdController = new ApexPages.StandardController( vOppty );             
            ApexPages.currentpage().getParameters().put('id',vOppty.id);
            NDRPartsController cmc = new NDRPartsController(stdController);
            cmc.vSelectedRecordId = vOpptypart1.id;           
            cmc.toggleSort();
            cmc.pageRefId();
            cmc.saveComment();
            cmc.vSelectedRecordId = vOpptypart2.id;
            cmc.vSelectedId = vOpptypart2.id;
            cmc.vSetParamId = vOpptypart2.id;
            cmc.rejectActionOnNDR();
            cmc.saveRejectComments();
            cmc.agreeActiononNDR();
            cmc.agreeNDR();
            cmc.closeAgreepopup();
            cmc.vSelectedRecordId = vOpptypart2.id;
            cmc.disagreeActiononNDR();
            cmc.disagreeNDR();
            
            cmc.closedisagreepopup();
            cmc.setvSelectedId('Test');
            String vSelectedId = cmc.getvSelectedId();
       Test.stopTest(); 
       }
    }
    static testMethod void TestNDRParts2() {
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        ClsTestCustomSettingHelper.getNDRRedflagreason();
        ClsTestCustomSettingHelper.getrealtime_Callout_Settings();
    /*------------- Varible declaration and initialisation --------------------*/    
    List<Opportunity> vLstOppty = new List<Opportunity>();
    Id vRTOppId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('NDR Opportunity').getRecordTypeId();//[select id from RecordType where sObjectType =: 'Opportunity' and name =: 'NDR Opportunity'];  
    Id vRTOppPartId = Schema.SObjectType.Opportunity_Part__c.getRecordTypeInfosByName().get('NDR Opportunity Parts').getRecordTypeId();//[select id from RecordType where sObjectType =: 'Opportunity_Part__c' and name =: 'NDR Opportunity Parts'];  
    Id vRTOppCcrId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('CCR Opportunity').getRecordTypeId();
     
    Profile p = [Select Id, Name From Profile 
    where Name = 'Channel Standard User' 
    or Name = 'Service Account' 
    or Name ='System Administrator' 
    or Name ='Systemadministrator' limit 1];
    /*------------------ User created for Test ------------------------------*/                        
    User u = ClsTestHelp.createTestUsers();
    u.Email = 'test@test.com';
    u.Alias = 'abc';
    u.CommunityNickname = 'TsMD';
    u.ProfileId = p.Id;
    insert u;
    system.runas(u){
        test.starttest();

    /*--------------------- Insert Opportunity -----------------------------*/
    Opportunity vOppty = ClsTestHelp.createTestOpportunity();
    vOppty.RecordTypeId = vRTOppId;
    vOppty.NDR_SAP_Region__c='AP';
    vOppty.NDR_GPMS_ID__c = '000';
    insert vOppty;
    Opportunity vCcrOppty = ClsTestHelp.createTestOpportunity();
    vCcrOppty.RecordTypeId = vRTOppCcrId;
    vCcrOppty.NDR_SAP_Region__c='AP';
    vCcrOppty.NDR_GPMS_ID__c = '000';
    insert vCcrOppty;        
    Product_Hierarchy__c ph = new Product_Hierarchy__c();
    ph.name = 'Test Zensar';
    ph.Hierarchy_Level_Type__c = 'CBC1';
    ph.Description__c = 'Industrial';
    insert ph;
    Part__c part = new Part__c();
    part.name = 'Test Zensar';
    part.Description__c = 'Sniper';
    part.Product_Hierarchy__c = ph.Id;
    insert part;
    /*------------------ Insert Opportunity Part ---------------------------*/
    Opportunity_Part__c vOpptypart2 = ClsTestHelp.createTestOpportunityPart();
    vOpptypart2.Opportunity__c = vOppty.Id;
    vOpptypart2.Part__c = part.Id;
    vOpptypart2.GPL__c = ph.Id;
    vOpptypart2.recordtypeid =vRTOppPartid;
    vOpptypart2.NDR_Rejection_Reason__c='Other';
    vOpptypart2.NDR_Rejection_Comments__c='Other';
    vOpptypart2.Red_Flag_Reason__c='1,2';
    insert vOpptypart2;

     /*------------ Set page reference to NDRParts page -------------------*/       
            PageReference ref = Page.NDRParts; 
            Test.setCurrentPageReference(ref);
            ApexPages.StandardController stdController = new ApexPages.StandardController( vOppty );             
            ApexPages.currentpage().getParameters().put('id',vOppty.id);
            NDRPartsController cmc = new NDRPartsController(stdController);
            cmc.vSelectedRecordId = vOpptypart2.id;
            cmc.vSelectedId = vOpptypart2.id;
            cmc.vSetParamId = vOpptypart2.id;
            cmc.rejectActionOnNDR();
            cmc.saveRejectComments();
            cmc.agreeActiononNDR();
            cmc.agreeNDR();
            cmc.closeAgreepopup();
       Test.stopTest(); 
       }
       }
}//End of testclass
/*------------------------------------------------------------------------------------------------
--------*/