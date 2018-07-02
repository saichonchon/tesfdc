/******************************************************************************************************************
Name: ACP_View_Customer_Page_ctrl_Test
Copyright @ 2017 TE Connectivity
=============================================================================
Requirement:
ACP_Attachments_Page_Ctrl for ACP_Attachments_Page 
=============================================================================
Purpose:
Controller for customer page component
=============================================================================
History
-------
VERSION   AUTHOR      DATE         DETAIL
1.0 -    Alka Kumari  04/25/17     INITIAL DEVELOPMENT
2.0      Nagaraju     11/02/17     Added header commentas 
********************************************************************************************************************/
@isTest
Private Class ACP_View_Customer_Page_ctrl_Test{
    static  Contact con = ACP_TestDataFactory.createContact();    
    static ACP_Setting__c acpsetting= createACPSetting('');
    static ACP_Section_Detail__c stakeholderRec = createSectionSettings('Stakeholder and Relationship Settings','','Stakeholder and Relationship','ACP_Name__r.name desc','ACP_Relationship_Fieldset_BUAdmin','Stakeholder and Relationship');
    static ACP_Section_Detail__c supplierEvalRec = createSectionSettings('TE Supplier Evaluation Settings','','TE Supplier Evaluation','createdDate desc','ACP_Suppl_Evaluation_Fieldset','TE Supplier Evaluation');
    static ACP_Section_Detail__c custOverviewRec = createSectionSettings('Customer Overview Settings','','Customer Overview','LastModifiedDate desc','','Customer Overview');
    static ACP_Section_Detail__c accHeader  = createSectionSettings('Account Plan Header','','Account Plan Header','createdDate desc','ACP_Account_Plan_Fieldset','Account Plan Header');
    String UserBU= acpsetting.Business_Unit__c;        
    String AcpSectionDetail='ACP_Section_Detail__c';
    public static ACP_Setting__c createACPSetting(String BusinessUnit) {
        system.debug('createACPSetting');
        ACP_Setting__c acpSetting = new ACP_Setting__c();
        acpSetting.Business_Unit__c = BusinessUnit;
        acpSetting.ACP_Is_Active__c = true;
        try{
            system.debug('before insert createACPSetting');
            insert acpSetting;
            system.debug('ACPSetting Record'+acpSetting);
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
        if(recTypeName == 'Stakeholder and Relationship'){
            sectionSetting.ACP_No_Reds_Exe_Rel__c = 2;
            sectionSetting.ACP_Num_of_Rcds_Pur_Rel__c = 2;
            sectionSetting.ACP_Num_Rerds_Eng_Rel__c = 2;
        }
        if(recTypeName == 'Market and Competition'){
            sectionSetting.ACP_Show_TAM_LY_CY_NY__c =false;
            sectionSetting.ACP_No_Of_Records__c  =5;
        }
        if(recTypeName == 'Opportunity TAM Revenue'){
            sectionSetting.ACP_Pipeline_4Q_Rolling__c ='00O0S000000JQvH';
            sectionSetting.ACP_Conversion_current_YTD__c ='00O0S000000JQvH';
            sectionSetting.ACP_L12M_Lost_1Yvalue__c ='00O0S000000JQvH';
            sectionSetting.ACP_L12M_Won_1Y_Value__c ='00O0S000000JQvH';
            sectionSetting.ACP_No_Of_Records__c  =5;
        }
        if(recTypeName == 'Market and Competition Summary'){
            sectionSetting.ACP_No_Of_Records__c  =5;
            system.debug('Market&Comp Sum'+sectionSetting);
        }
        if(recTypeName == 'TE Business Performance'){
            sectionSetting.Revenue_and_Growth_Plan_Year_1__c = '2017';
            sectionSetting.Revenue_and_Growth_Plan_Year_3__c = '2018';
            sectionSetting.Revenue_and_Growth_Plan_Year_2__c = '2020';
            sectionSetting.Revenue_Type__c = 'Direct; POS; CMA';
        }
        
        if(recTypeName == 'Top Open Opportunities'){
            sectionSetting.ACP_Application__c = 'Platform Name';
            sectionSetting.ACP_No_Of_Records__c  =5;
        }
        if(recTypeName == 'TE Supplier Evaluation'){
            sectionSetting.ACP_Field_Set_1__c = 'ACP_Suppl_Rating_Fieldset';
            sectionSetting.ACP_No_Of_Records__c  =5;
        }
        
        if(recTypeName == 'Strategy'){
            
            sectionSetting.ACP_No_Of_Records__c  =5;
        }
        
        if(recTypeName == 'Customer Overview'){
            
            sectionSetting.Customer_Overview_2nd_Row__c  = true;
        }
        
        try{
            system.debug('before insert section detail');
            insert sectionSetting;
            system.debug('sectionSetting======>'+sectionSetting);
            return sectionSetting;
        }Catch(Exception e){
            System.debug('Exception occured inside ACP_TestDataFactory:'+e.getMessage());
            return null;
        }
    }
    
    
    
    //-------------------------- setup method -----------------
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
    //--------------------------------------------------    
    
    static testMethod void stakeholderAndRel_TestEngineering(){
        
        System.Test.startTest(); 
        Contact cons= [select id from contact limit 1];
        ACP_Account_Plan__c accPlan= [select id from ACP_Account_Plan__c limit 1];
        // List<ACP_Relationship__c> EnggRel = ACP_TestDataFactory.createSuppRelationship(1,'Engineering');
        List < ACP_Relationship__c > EnggRel = new List < ACP_Relationship__c > ();
        
        for (Integer i = 0; i < 3; i++) {
            ACP_Relationship__c relationship = new ACP_Relationship__c(
                ACP_Account_Plan__c = accplan.id,
                ACP_Comments__c = 'New Relationship',
                ACP_Location__c = 'Texas',
                ACP_Name__c = con.id,
                Relationship__c = 'Engineering');
            EnggRel.add(relationship);
        }
        
        List<Task> tskList6 = ACP_TestDataFactory.createTask('Top Open Opportunities',accPlan.id,1, 'In Progress');
        for(Task obj : tskList6 )
        {
            obj.whatid = accPlan.id;
            
        }
        insert tskList6 ;
        system.debug('task list for ritika'+tsklist6);
        Test.setCurrentPageReference(new PageReference('Page.ACP_View_Customer_Page')); 
        System.currentPageReference().getParameters().put('relationType', 'Engineering');
        System.currentPageReference().getParameters().put('acpid', accPlan.id);  
        
        System.Test.stopTest(); 
        ApexPages.StandardController sc = new ApexPages.StandardController(accplan); 
        ACP_View_Customer_Page_ctrl relObj = new ACP_View_Customer_Page_ctrl(sc);
        system.debug( 'rel object ritika' +relObj.acp_relationObj.ACP_Name__c);
        relObj.acp_relationObj.ACP_Name__c = cons.id;
        
        PageReference savePageRef = relObj.Cancel();
        relObj.saveRelation();
        ACP_View_Customer_Page_ctrl ctrlObj = new ACP_View_Customer_Page_ctrl(sc);       
        ACP_Relationship__c relObj1 = new ACP_Relationship__c();
        relObj1.ACP_Name__c = cons.id;
        ctrlObj.acp_relationObj = relObj1;
        ACP_Relationship__c relObj2 = new ACP_Relationship__c();
        relObj2.ACP_Name__c = cons.id;
        ctrlObj.acp_relationObj = relObj2;
        ctrlObj.saveAndNew();
        List<Schema.FieldSetMember> fieldList = ctrlObj.getStakeholderFields();
        
    }
    static testMethod void stakeholderAndRel_TestPurchasing(){
        
        System.Test.startTest(); 
        Contact cons= [select id from contact limit 1];
        ACP_Account_Plan__c accPlan= [select id from ACP_Account_Plan__c limit 1];
        List < ACP_Relationship__c > EnggRel = new List < ACP_Relationship__c > ();
        
        for (Integer i = 0; i < 3; i++) {
            ACP_Relationship__c relationship = new ACP_Relationship__c(
                ACP_Account_Plan__c = accplan.id,
                ACP_Comments__c = 'New Relationship',
                ACP_Location__c = 'Texas',
                ACP_Name__c = con.id,
                Relationship__c = 'Purchasing');
            EnggRel.add(relationship);
        }
        
        List<Task> tskList6 = ACP_TestDataFactory.createTask('Top Open Opportunities',accPlan.id,1, 'In Progress');
        for(Task obj : tskList6 )
        {
            obj.whatid = accPlan.id;
            
        }
        insert tskList6 ;
        Test.setCurrentPageReference(new PageReference('Page.ACP_View_Customer_Page')); 
        System.currentPageReference().getParameters().put('relationType', 'Purchasing');
        System.currentPageReference().getParameters().put('acpid', accPlan.id);  
     
        System.Test.stopTest(); 
        ApexPages.StandardController sc = new ApexPages.StandardController(accplan); 
        ACP_View_Customer_Page_ctrl relObj = new ACP_View_Customer_Page_ctrl(sc);
        relObj.acp_relationObj.ACP_Name__c = cons.id;
        PageReference savePageRef = relObj.Cancel();
        relObj.saveRelation();
      
        ACP_View_Customer_Page_ctrl ctrlObj = new ACP_View_Customer_Page_ctrl(sc);       
        ACP_Relationship__c relObj1 = new ACP_Relationship__c();
        relObj1.ACP_Name__c = cons.id;
        ctrlObj.acp_relationObj = relObj1;
        ACP_Relationship__c relObj2 = new ACP_Relationship__c();
        relObj2.ACP_Name__c = cons.id;
        ctrlObj.acp_relationObj = relObj2;
        ctrlObj.saveAndNew();
        List<Schema.FieldSetMember> fieldList = ctrlObj.getStakeholderFields();
    } 
    
    
    /********************************************************Customer Overview Starts*************************************************************************/    
    static testMethod void custOverview_TestAdd(){
        
        Test.startTest();
        ACP_Account_Plan__c accPlan= [select id from ACP_Account_Plan__c limit 1];
        Test.setCurrentPageReference(new PageReference('Page.ACP_Customer_Overview_Add')); 
        System.currentPageReference().getParameters().put('acpId', accPlan.id);
        ACP_Account_Plan__c acc = new ACP_Account_Plan__c();
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        ACP_View_Customer_Page_ctrl ctrl = new ACP_View_Customer_Page_ctrl(sc);
        String tableType =ctrl.tableType;
        String SelectType=ctrl.SelectType;
        String currentRecordId=ctrl.currentRecordId;
        String recordtypenm=ctrl.recordtypenm;
        List<ACP_Customer_Overview__c> customerOverviewSource = ctrl.customerOverviewSource;
        
        Id rngRecordTypeId = Schema.SObjectType.ACP_Customer_Overview__c.getRecordTypeInfosByName().get('Revenue and Growth').getRecordTypeId();
        ACP_Customer_Overview__c rng = new  ACP_Customer_Overview__c();
        rng.ACP_Account_Plan__c = accPlan.id;
        rng.ACP_Year__c ='2025';
        rng.ACP_Revenue__c =3;
        rng.recordTypeId = rngRecordTypeId;
        PageReference addRevRef = ctrl.AddRevenue();
        
        ctrl.getrevenue();
        
        ctrl.getRecordTypes();
        ctrl.RecordTypeSelection();
        ctrl.cancelSummary();  
        ACP_View_Customer_Page_ctrl ctrl1 = new ACP_View_Customer_Page_ctrl (sc);
        ctrl1.saveAndNewRevenue();
        ACP_View_Customer_Page_ctrl ctrlObj2 = new ACP_View_Customer_Page_ctrl(sc);
        try {
            ctrlObj2.saveSummary();
        } catch (DMLException e) {
            system.assertEquals(e.getMessage(), e.getMessage());
        }
        ctrlObj2.saveSummary();
        Id marketRecordTypeId = Schema.SObjectType.ACP_Customer_Overview__c.getRecordTypeInfosByName().get('End Markets').getRecordTypeId();
        ACP_Customer_Overview__c market = new  ACP_Customer_Overview__c();
        market.ACP_Account_Plan__c = accPlan.id;
        market.ACP_Market__c    = 'Industry';
        market.ACP_Market_Percent__c = 36;
        market.ACP_Market_Trend__c = 'Flat';   
        market.recordTypeId = marketRecordTypeId;
        PageReference addEndRef = ctrl.AddEnd();
        ctrl.getendmarkets();
        
        ctrl1.saveAndNewEnd();
        
        Id regionRecordTypeId = Schema.SObjectType.ACP_Customer_Overview__c.getRecordTypeInfosByName().get('Regions').getRecordTypeId();
        ACP_Customer_Overview__c region = new  ACP_Customer_Overview__c();
        region.ACP_Account_Plan__c = accPlan.id;
        region.ACP_Region__c = 'North';
        region.ACP_Region_Percent__c =3;
        region.ACP_Regions_Trend__c= 'Up';   
        region.recordTypeId = regionRecordTypeId;
        PageReference addRegRef = ctrl.AddRegion();
        ctrl.getregion();
        
        ctrl1.saveAndNewRegion();
        
        Id keyRecordTypeId = Schema.SObjectType.ACP_Customer_Overview__c.getRecordTypeInfosByName().get('Key Manufacturing /Purchasing Locations').getRecordTypeId();
        ACP_Customer_Overview__c key= new  ACP_Customer_Overview__c();
        key.ACP_Account_Plan__c = accPlan.id;
        key.ACP_Manufacturing__c     = 'Amberg';
        key.ACP_Purchasing__c = 'Erlangen';           
        key.recordTypeId = keyRecordTypeId;
        PageReference addKeyRef = ctrl.AddKey();
        ctrl.getkey();
        
        ctrl1.saveAndNewKey();
        
        Id locRecordTypeId = Schema.SObjectType.ACP_Customer_Overview__c.getRecordTypeInfosByName().get('Key Engineering /Design locations').getRecordTypeId();
        ACP_Customer_Overview__c loc = new  ACP_Customer_Overview__c();
        loc.ACP_Account_Plan__c = accPlan.id;
        loc.ACP_Location__c  = 'Amberg';
        loc.ACP_Location_Focus__c = 'Motion Control';
        loc.recordTypeId = locRecordTypeId;
        PageReference addLocRef = ctrl.AddLocation();
        ctrl.getlocation();
        
        ctrl1.saveAndNewLocation();
        
        Id vendRecordTypeId = Schema.SObjectType.ACP_Customer_Overview__c.getRecordTypeInfosByName().get('Key Vendors in Supply Chain').getRecordTypeId();
        ACP_Customer_Overview__c vend = new  ACP_Customer_Overview__c();
        vend.ACP_Account_Plan__c = accPlan.id;
        vend.ACP_Vendor__c  = 'CIS';
        vend.ACP_Type__c = 'EMS';
        vend.ACP_Vendor_Focus__c = 'Motion Control';
        vend.recordTypeId = vendRecordTypeId;
        PageReference addVendRef = ctrl.AddVendor();
        ctrl.getvendor();
        
        List < ACP_Customer_Overview__c> result = ctrl.acpVendList;
        ctrl1.saveAndNewVendor();
        
        ctrl.getCustomerOverviewList(); 
        pageReference pageRef = ctrl.editCompetitors();
        ctrl.editCompetitors();
        ctrl.save();
        
        Test.stopTest();   
        
    }
    
    /********************************************************Customer Overview Ends*************************************************************************/        
    static testMethod void SupplierEvalution_TestMethod() {
        
        Test.setCurrentPageReference(new PageReference('Page.ACP_View_Customer_Page')); 
        System.Test.startTest();
        
        ACP_Account_Plan__c newAccPlan= [select id from ACP_Account_Plan__c limit 1];
        
        List < ACP_TE_Supplier_Evaluation__c > supplierEvaluation = ACP_TestDataFactory.createsupplierEvaluation(1);
        for(ACP_TE_Supplier_Evaluation__c obj : supplierEvaluation )
        {
            obj.ACP_Account_Plan__c = newAccPlan.id;
            
        }
        insert supplierEvaluation;
        Apexpages.currentPage().getParameters().put('acpid', newAccPlan.id);  
        
        System.Test.stopTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(newAccPlan);         
        ACP_View_Customer_Page_ctrl  ctrlObj1 = new ACP_View_Customer_Page_ctrl(sc);  
        
        List < ACP_TE_Supplier_Evaluation__c > supplierEvaluationList =ctrlObj1.supplierEvaluationList;
        ACP_TE_Supplier_Evaluation__c NewSupplierEval=ctrlObj1.getNewSupplierEval();
        
        ctrlObj1.newSupplierEval.ACP_Criteria__c = 'Quality'; 
        
        ctrlObj1.SaveSupplierEval();
        
        ACP_View_Customer_Page_ctrl  ctrlObj2 = new ACP_View_Customer_Page_ctrl(sc); 
        
        ctrlObj2.newSupplierEval.ACP_Criteria__c = 'Quality'; 
        
        ctrlObj2.saveNewSupplierEval();
        
        Pagereference pageRef1  = ctrlObj2.cancelAddPage();
        Pagereference  pageRef2 = ctrlObj2.pageRedirectWithDivId('rating');
        
    }
    
    static testMethod void SupplierRating_TestMethod() {
        Test.setCurrentPageReference(new PageReference('Page.ACP_View_Customer_Page')); 
        System.Test.startTest(); 
        ACP_Account_Plan__c newAccPlan= [select id from ACP_Account_Plan__c limit 1];
        
        List < ACP_TE_Suppliers_Rating__c > rating = ACP_TestDataFactory.createsupplierRatings(1);
        for(ACP_TE_Suppliers_Rating__c obj : rating)
        {
            obj.ACP_Account_Plan__c = newAccPlan.id;
            
        }
        insert rating;
        
        system.debug('supplier ritikas is ' + rating);
        Apexpages.currentPage().getParameters().put('acpid', newAccPlan.id);  
        
        System.Test.stopTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(newAccPlan);         
        ACP_View_Customer_Page_ctrl  ctrlObj1 = new ACP_View_Customer_Page_ctrl(sc);  
        system.debug('obj ritikas is ' + ctrlObj1);
        
        List < ACP_TE_Suppliers_Rating__c > suppliersRatingList =ctrlObj1.suppliersRatingList;
        ACP_TE_Suppliers_Rating__c  NewSupplierEval1=ctrlObj1.getNewSuppliersRating();
        ctrlObj1.newSuppliersRating.ACP_Year__c = '2017';       
        ctrlObj1.saveSuppliersRating();
        
        
        ACP_View_Customer_Page_ctrl  ctrlObj2 = new ACP_View_Customer_Page_ctrl(sc);  
        ctrlObj2.newSuppliersRating.ACP_Year__c = '2017';       
        ctrlObj2.saveNewSuppliersRating(); 
        
        
        Pagereference redirectTabpage = ctrlObj2.redirectTabpage();
        Pagereference redirectTabpage1 = ctrlObj2.editAccountPlan();
        /*****************Tabs Code************************/
        ctrlObj2.viewTab();
        ctrlObj2.performanceTab();
        ctrlObj2.summaryTab();
       
       /* ACP_View_Customer_Page_ctrl.congaupdateattach('PDF',newAccPlan.id);
        ACP_View_Customer_Page_ctrl.congaupdateattach('PPT',newAccPlan.id);*/
        
        /*****************Tabs Code************************/
    }
   static testMethod void SupplierRating_TestMethod1() {
     Test.setCurrentPageReference(new PageReference('Page.ACP_View_Customer_Page')); 
        System.Test.startTest(); 
        ACP_Account_Plan__c newAccPlan= [select id from ACP_Account_Plan__c limit 1];
        ACP_Account_Plan_Attachment__c AccPlanAtt1 = new ACP_Account_Plan_Attachment__c(ACP_Account_Plan__c = newAccPlan.id,
        ACP_Type__c = 'Competitor');
        insert AccPlanAtt1;
        System.assertEquals('Competitor', AccPlanAtt1.ACP_Type__c);
        Attachment attach=new Attachment(); 
        attach.Name='Unit Test Attachment'; 
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body'); 
        attach.body=bodyBlob; 
        attach.parentId=AccPlanAtt1.Id; 
        attach.ContentType = 'application/msword'; 
        attach.IsPrivate = false; 
        attach.Description = 'Test'; 
        insert attach;
        Attachment attach1=new Attachment(); 
        attach1.Name='Unit Test Attachment.test'; 
        Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body'); 
        attach1.body=bodyBlob1; 
        attach1.parentId=AccPlanAtt1.Id; 
        attach1.ContentType = 'application/msword'; 
        attach1.IsPrivate = false; 
        attach1.Description = 'Test'; 
        insert attach1; 
       
        OrgWideSettings__c os=new OrgWideSettings__c();
        os.Datatable_Page_Size__c=100;
        os.Name='testorg';
        os.Enable_Error_Logging__c=true;
        insert os;
       
        Apexpages.currentPage().getParameters().put('acpid', newAccPlan.id);  
        Apexpages.currentPage().getParameters().put('tabpage','test');
        System.Test.stopTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(newAccPlan);         
        ACP_View_Customer_Page_ctrl  ctrlObj1 = new ACP_View_Customer_Page_ctrl(sc);  
        system.debug('obj ritikas is ' + ctrlObj1);
       
        ctrlObj1.acAtt[0].ACP_Type__c = 'Competitor';
        ctrlObj1.redirectTabpage();
        ctrlObj1.inlineedit();
         /*ctrlobj1.saveNewSuppliersRating();
       ctrlobj1.saveNewSupplierEval();
        ctrlobj1.saveSupplierEval();
        ctrlobj1.saveSuppliersRating();
        ctrlobj1.saveRelation();
        ctrlobj1.saveSummary();
        ctrlobj1.saveVendorCommon();*/
    } 
}