/******************************************************************************************************************
Name: ACP_AccountPlan_Helper_Test
Copyright @ 2017 TE Connectivity
=============================================================================
Requirement:
Test class for ACP_AccountPlan_Helper
=============================================================================
Purpose:
Helper class for Account Plan controllers

=============================================================================
History
-------
VERSION   AUTHOR        DATE         DETAIL
1.0 -    Suresh Aepoor  07/05/17     INITIAL DEVELOPMENT
2.0 -    Anushka Bansal 11/02/17     Added comments 
********************************************************************************************************************/
@isTest
Private Class ACP_AccountPlan_Helper_Test{
  static ACP_Setting__c acpsetting = createACPSetting('Industrial'); 
    static ACP_Section_Detail__c Rec = createSectionSettings('Strategy Settings','','Strategy','createdDate desc','ACP_Status_Fieldset','Strategy');
    static ACP_Section_Detail__c accHeader  = createSectionSettings('Account Plan Header','','Account Plan Header','createdDate desc','ACP_Account_Plan_Fieldset','Account Plan Header');
     static ACP_Section_Detail__c acpsection = createSectionSettings('Customer Overview Settings','','Customer Overview','LastModifiedDate desc','','Customer Overview');
     
     
     @testSetup static void setup()
    {
    User u = ClsTestHelp.createtestUsers();
      insert u;
      ClsTestCustomSettingHelper.getTrigger_Configuration();
       ClsTestCustomSettingHelper.getProfitBUCenterMapping();
      ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();     
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        ClsTestCustomSettingHelper.getADMTerritoryCode();
         RecordType rt = Clstesthelp.createTestRecordType7();
        Account acct = ClsTestHelp.createtestAccounts();
        acct.WWCORPACCT__c ='W0007';
        acct.GAMCD__c = 'G0007';
         acct.IND_KAM_Code__c = 'K0007';           
            insert acct;
    
       ACP_Account_Plan__c newAccPlan = new ACP_Account_Plan__c(
         Name = 'TestAccountPlan3564',
         ACP_Account_Name__c = acct.Id,       
         Account_Plan_Type__c = 'Gam Account',        
         ACP_Customer_Strategy_Summary__c = 'TestAccountPlan3564');
      insert newAccPlan;
    
    
    Contact con = ClsTestHelp.createTestContacts();
     con.accountId = acct.id;
      Insert con ; 
    }
    
        
   public static ACP_Setting__c createACPSetting(String BusinessUnit) {
  // ACP_Account_Plan__c  accplan = [select id, Account_Plan_Type__c  from ACP_Account_Plan__c limit 1];
        
   system.debug('business unit ' + BusinessUnit);
        ACP_Setting__c acpSetting = new ACP_Setting__c();
        acpSetting.Business_Unit__c = BusinessUnit;
        acpSetting.ACP_Is_Active__c = true;
        try{
            insert acpSetting;
            system.debug('ACPSetting Record summary ctrl'+acpSetting);
            return acpSetting;
        }Catch(Exception e){
            System.debug('Exception occured inside ACP_TestDataFactory:'+e.getMessage());
            return null;
        }
    }
      
      public static ACP_Section_Detail__c createSectionSettings(String name,String GIBU,String headerLabel,String sortOrder, String fieldSetNm, String recTypeName) {
        Id recordtypeid = Schema.SObjectType.ACP_Section_Detail__c.getRecordTypeInfosByName().get(recTypeName).getRecordTypeId();
        system.debug('recordtypeid ======>'+recordtypeid);
        system.debug('recTypeName======>'+recTypeName);
        
        //ACP_Setting__c acpSetting = createACPSetting(GIBU);
        ACP_Section_Detail__c sectionSetting = new ACP_Section_Detail__c();
        sectionSetting.Name = name;
        sectionSetting.ACP_Setting__r = acpSetting;
        sectionSetting.ACP_Header_Label__c = headerLabel;
        sectionSetting.Default_Sort_Order__c = sortOrder;
        sectionSetting.ACP_Field_Set_Name__c = fieldSetNm;
        sectionSetting.ACP_Header_BG_Color__c = 'orange';
        sectionSetting.ACP_Header_Font_Color__c = 'white';
        sectionSetting.ACP_Setting__c = acpSetting.id;
        sectionSetting.RecordTypeId = recordtypeid;
        
        if(recTypeName == 'Strategy'){
        
        sectionSetting.ACP_No_Of_Records__c  =5;
        }
       try{
            insert sectionSetting;
            system.debug('sectionSetting======>'+sectionSetting);
            system.debug('full record  ------ ' + acpsetting.ACP_Section_Details__r);
            return sectionSetting;
        }Catch(Exception e){
            System.debug('Exception occured inside ACP_TestDataFactory:'+e.getMessage());
            return null;
        }
    }
    

    static testMethod void ACP_AccountPlanSectionDetailTest()
    {       
        Test.StartTest();
       /* ACP_Setting__c acpsetting = ACP_TestDataFactory.createACPSetting('Industrial');        
              
        ACP_Section_Detail__c acpsection = ACP_TestDataFactory.createSectionSettings('Customer Overview Settings','Industrial','Customer Overview','createdDate desc','ACP_Relationship_Fieldset_BUAdmin','Customer Overview');
        Test.StopTest();
       */     
       ACP_Account_Plan__c  accplan = [select id, Account_Plan_Type__c  from ACP_Account_Plan__c limit 1];
         acpSetting.Account_Plan_Type__c = accplan.Account_Plan_Type__c  ;
        update acpSetting;
       String UserBU= acpsetting.Business_Unit__c;  
        String AcpSectionDetail='ACP_Section_Detail__c';
        String fieldSetName = 'ACP_Relationship_Fieldset_BUAdmin';        
        String ObjectName = 'ACP_Relationship__c';
        String sortOrder = 'createdDate desc';
        ACP_AccountPlan_Helper.getFieldSetFields(fieldSetName, ObjectName); 
        system.debug('type  ' +  accplan.Account_Plan_Type__c + 'setting -----' + acpsetting.Business_Unit__c);
       ACP_AccountPlan_Helper.getACPSettingsRecord(UserBU,'Gam Account'); 
        ACP_AccountPlan_Helper.getACPSectionRec(acpsetting, 'Customer Overview');
         ACP_AccountPlan_Helper.getAcctPlanFields(acpsetting, 'Customer Overview');
        
         //ACP_AccountPlan_Helper.getACPSettingsRecord('','');       
        
           
        Test.stopTest();    
    }
    static testMethod void AcpAccountPlanTest()
    {       
        String fieldSetName = 'ACP_Relationship_Fieldset_BUAdmin';
        String fieldSetName1 = 'ACP_Revenue_Growth_Fieldset';
        String sortOrder = 'createdDate desc';        
                    
        Test.StartTest();
        
       ACP_Account_Plan__c  accplan = [select id from ACP_Account_Plan__c limit 1];
       List < ACP_Relationship__c > accrelations = ACP_TestDataFactory.createStakeholderRelationship(3, 'Purchasing', accplan.id);
        String acpId = accrelations[0].id;        
        ACP_AccountPlan_Helper.getacpRelList(fieldSetName, sortOrder, acpId);      
        ACP_AccountPlan_Helper.getAllTasks(accplan.id);   
         
          ACP_account_Plan_attachment__c AccPlanAtt =new ACP_account_Plan_attachment__c();
            AccPlanAtt.ACP_Account_Plan__c = accplan.Id;
            AccPlanAtt.ACP_Type__c = 'Company Logo';
            insert(AccPlanAtt);
            
            Attachment attach=new Attachment();     
            attach.Name='Unit.Test.Attachment';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach.body=bodyBlob;
            attach.parentId=AccPlanAtt.id;
            insert(attach);    
     
        //ACP_Revenue_Growth_Perf__c acprev = ACP_TestDataFactory.createACPRevenueGrowthPerf();
        Test.StopTest();        
        
        ACP_AccountPlan_Helper.acctPlanHeaderRec(accplan.id);
        ACP_AccountPlan_Helper.getAccPlan('ACP_Account_Plan_Fieldset', accplan.id);
         
        ACP_AccountPlan_Helper.accountPlanHeaderImages(AccPlanAtt.ACP_Account_Plan__c);

        String BU = 'Billing';        
        String revenueType = 'Direct';        
        String acpId1 = accplan.id;        
        
        ACP_AccountPlan_Helper.getPerfList(BU,revenueType,sortOrder,fieldSetName1,acpId1); 
      
    } 
    static testMethod void ACP_AccountPlanacpattachmenttest()
    {        
        Test.StartTest();
        ACP_Account_Plan__c  accplan = [Select id from ACP_Account_Plan__c  limit 1];
       // ACP_account_Plan_attachment__c AccPlanAtt1 = ACP_TestDataFactory.createACPaccountPlan_attachment1();
        //ACP_account_Plan_attachment__c AccPlanAtt2 = ACP_TestDataFactory.createACPaccountPlan_attachment2();    
        
        ACP_account_Plan_attachment__c AccPlanAtt1 =new ACP_account_Plan_attachment__c();
            AccPlanAtt1.ACP_Account_Plan__c = accplan.Id;
            AccPlanAtt1.ACP_Type__c = 'Account Manager';
            insert(AccPlanAtt1);
            
            Attachment attach=new Attachment();     
            attach.Name='Unit.Test.Attachment';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach.body=bodyBlob;
            attach.parentId=AccPlanAtt1.id;
            insert(attach); 
            
             ACP_account_Plan_attachment__c AccPlanAtt2 =new ACP_account_Plan_attachment__c();
            AccPlanAtt2.ACP_Account_Plan__c = accplan.Id;
            AccPlanAtt2.ACP_Type__c = 'Product';
            insert(AccPlanAtt2);
            
            Attachment attach2=new Attachment();     
            attach2.Name='Unit.Test.Attachment';
            Blob bodyBlob2 =Blob.valueOf('Unit Test Attachment Body');
            attach2.body=bodyBlob2;
            attach2.parentId=AccPlanAtt2.id;
            insert(attach2);  
            
             Attachment attach3=new Attachment();     
            attach3.Name='Unit.Test.Attachment';
            Blob bodyBlob3 =Blob.valueOf('Unit Test Attachment Body');
            attach3.body=bodyBlob3;
            attach3.parentId=AccPlanAtt2.id;
            insert(attach3);  
            
             Attachment attach4=new Attachment();     
            attach4.Name='Unit.Test.Attachment';
            Blob bodyBlob4 =Blob.valueOf('Unit Test Attachment Body');
            attach4.body=bodyBlob4;
            attach4.parentId=AccPlanAtt2.id;
            insert(attach4);  
               
        Test.StopTest();        
        
        ACP_AccountPlan_Helper.accountPlanHeaderImages(AccPlanAtt1.ACP_Account_Plan__c);  
                               
    } 
}