/******************************************************************************************************************
Name: ACP_View_Customer_Page_ctrl
Copyright @ 2017 TE Connectivity
=============================================================================
Requirement:
 ACP_Attachments_Page_Ctrl for ACP_Attachments_Page 
=============================================================================
Purpose:
 Controller for customer page component
Test class:
ACP_View_Customer_Page_ctrl_Test
=============================================================================
History
-------
VERSION   AUTHOR      DATE         DETAIL
1.0 -    Alka Kumari  04/25/17     INITIAL DEVELOPMENT
2.0      Nagaraju     11/02/17     Added header commentas and added errorlogs in to catch block 
2.0      Nagaraju     11/21/17   updated imageMaps at line number 131 and 136 
********************************************************************************************************************/
public  with sharing class ACP_View_Customer_Page_ctrl {

   public String acpId {
      get;
      set;
   }
   public String userBU {
      get;
      set;
   }
   ACP_Setting__c buSetting = new ACP_Setting__c();
   public String tableType {
      get;
      set;
   }
   public Boolean readonlyMode {
      get;
      set;
   }
   public Boolean editMode {
      get;
      set;
   }

   transient public List < ACP_Account_Plan_Attachment__c > acAtt {
      get;
      set;
   }
  
   public String accntId {
      get;
      set;
   }
   public List < ACP_Account_Plan__c > accDet {
      get;
      set;
   }
   transient public string nameFile {
      get;
      set;
   }
   
   public Map < string, id > evenRowImages {
      get;
      set;
   }
   public Map < string, id > oddRowImages {
      get;
      set;
   }
   
   List < Attachment > evenRowAttachment = new List < Attachment > ();
   List < Attachment > oddRowAttachment = new List < Attachment > ();
  
   //=======new fields created by Raju====
   public List < Schema.FieldSetMember > headerAcctPlanFields {
      get;
      set;
   }
   public ACP_Account_Plan__c accountPlantHeaderRec {
      get;
      set;
   }
   public Map < string, id > accountPlanEvenRowImagesProd {
      get;
      set;
   }
   public Map < string, id > accountPlanOddRowImagesProd {
      get;
      set;
   }
   public String accountPlancompanyLogoId {
      get;
      set;
   }
   public String accountPlanmanagerImgId {
      get;
      set;
   }
   public ACP_Account_Plan__c accountPlanDet {
      get;
      set;
   }

   public ACP_View_Customer_Page_ctrl(ApexPages.StandardController controller) {
      /***************************************************customer overview  constructor start*********************************/
     

      revenueRecordTypeId = Schema.SObjectType.ACP_Customer_Overview__c.getRecordTypeInfosByName().get('Revenue and Growth').getRecordTypeId();
      endMarketRecordTypeId = Schema.SObjectType.ACP_Customer_Overview__c.getRecordTypeInfosByName().get('End Markets').getRecordTypeId();
      acpId = ApexPages.currentPage().getParameters().get('acpId');
      setCategoryWiseTask();
      readonly = true;
      editmode = false;

      acctPlan = (ACP_Account_Plan__c) controller.getRecord();
      custOverviewList = [Select id, ACP_Market__c, ACP_Account_Plan__r.name, ACP_Market_Percent__c, ACP_Market_Trend__c, ACP_Region__c, ACP_Region_Percent__c, ACP_Regions_Trend__c, ACP_Manufacturing__c, ACP_Purchasing__c, ACP_Location__c, ACP_Location_Focus__c, RecordTypeId, ACP_Year__c, ACP_Revenue__c, ACP_Growth__c, ACP_Account_Plan__c, ACP_Vendor__c, ACP_Type__c, ACP_Vendor_Focus__c from ACP_Customer_Overview__c where ACP_Account_Plan__r.id =: acpId order by createdDate desc];
      record = [select Account_Plan_Type__c, ACP_Customer_Strategy_Summary__c, ACP_Account_Name__r.id,ACP_Customer_Major_Growth_Areas__c, ACP_Customer_Challenges_and_Threats__c, TE_Business_Performance_Comment__c from ACP_Account_Plan__c where id =: acpId];
      accntId = record.ACP_Account_Name__r.id;
       
      AcAtt = new List < ACP_Account_Plan_Attachment__c > ();
      AcpAtt = new List < Attachment > ();
      AcAtt = [SELECT Id, Name, ACP_Type__c, (SELECT Id, Name FROM Attachments order by CreatedDate desc )
         FROM ACP_Account_Plan_Attachment__c where ACP_Account_Plan__r.id =: acpId and ACP_Type__c = 'Competitor' order by CreatedDate desc LIMIT 5];

      evenRowImages = new Map < string, id > ();
      oddRowImages = new Map < string, id > ();
      for (ACP_Account_Plan_Attachment__c acp: AcAtt) {
         if (acp.Attachments.size() > 0 && acp.ACP_Type__c == 'Competitor') {
            for (Integer i = 0; i < acp.Attachments.size(); i = i + 2) {
                //oddRowAttachment.add(acp.Attachments[i]);
                string nameFile = acp.Attachments[i].Name.substringBefore('.'); 
                oddRowImages.put(nameFile, acp.Attachments[i].id);
                if (i < acp.Attachments.size() - 1){
                 // evenRowAttachment.add(acp.Attachments[i + 1]);
                  string evenNameFile = acp.Attachments[i + 1].Name.substringBefore('.'); 
                  evenRowImages.put(evenNameFile, acp.Attachments[i + 1].id);
                }
            }
         }
      }

    /*  for (Attachment atts: evenRowAttachment) {
         String nameField = atts.Name;
         if (nameField.Contains('.')) {
            nameFile = nameField.substringBefore('.');
            evenRowImages.put(nameFile, atts.id);
         }
      }
      for (Attachment atts: oddRowAttachment) {
         String nameField = atts.Name;
         if (nameField.Contains('.')) {
            nameFile = nameField.substringBefore('.');
            oddRowImages.put(nameFile, atts.id);
         }
      }*/
     

      /********************************************customer overview constructor end*************************************************************************/
      acpId = ApexPages.currentPage().getParameters().get('acpId');
      userBU = [Select GIBU__c From User Where Id =: UserInfo.getUserId()][0].GIBU__c;
      buSetting = ACP_AccountPlan_Helper.getACPSettingsRecord(userBU, record.Account_Plan_Type__c);
     
      if (buSetting == null)
         buSetting = ACP_AccountPlan_Helper.getACPSettingsRecord('', '');

      getCustOverviewList();
     

      //==to get account plan header informaton (account plan fieds,summmary ,Products)from helper class =Raju===
      headerAcctPlanFields = ACP_AccountPlan_Helper.getAcctPlanFields(buSetting, 'Account Plan Header');
      
      accountPlantHeaderRec = ACP_AccountPlan_Helper.acctPlanHeaderRec(acpId);
      accountPlanEvenRowImagesProd = ACP_AccountPlan_Helper.evenRowImagesProd;
      accountPlanOddRowImagesProd = ACP_AccountPlan_Helper.oddRowImagesProd;
      accountPlancompanyLogoId = ACP_AccountPlan_Helper.companyLogoId;
      accountPlanmanagerImgId = ACP_AccountPlan_Helper.managerImgId;
      
      //accountPlanDet = ACP_AccountPlan_Helper.getAccPlan(accplanrec.ACP_Field_Set_Name__c, acpId);
      try {
   accountPlanDet = ACP_AccountPlan_Helper.getAccPlan(accplanrec.ACP_Field_Set_Name__c, acpId);
  } catch (Exception e) {
      ErrorLogging.Log(e, 'ACP_Performance_Analytics_ctrl', 'ACP_Performance_Analytics_ctrl', acpId);
      ApexPages.addMessages(e);
  }
      //=====end== 

      /*******Added for Stakeholder & Relationship - Start */
      relation = ApexPages.currentPage().getParameters().get('relationType');
      setACPRelationList();
      getEvaluationList();
      getRatingList();
      /*******Added for Stakeholder & Relationship - End */
      setCategoryWiseTask();


     
      /*******************************************Get Account Details and Account Summary*********************************************/
     // try {

         //AccDet = [select id, ACP_Account_Name__r.id, ACP_Account_Manager__c, ACP_Account_Summary__c, ACP_Account_Name__r.name, ACP_Account_Name__r.AccountNumber, ACP_Account_Name__r.Description, ACP_Account_Name__r.Website
            //from ACP_Account_Plan__c where id =: acpId
        // ];
         //accntId = AccDet[0].ACP_Account_Name__r.id;

         
     /* } catch (DMLException e) {
         ErrorLogging.Log(e, 'ACP_View_Customer_Page_ctrl', 'ACP_View_Customer_Page_ctrl', acpId);
         ApexPages.addMessages(e);
      }*/
   }

   /****************************************************Customer Overview Start**************************************************************************************/

   public ACP_Account_Plan__c Record {
      get;
      set;
   }
   public String SelectType {
      get;
      set;
   }
   public List < ACP_Customer_Overview__c > customerOverviewSource {
      get;
      set;
   }
   ACP_Customer_Overview__c revenue = new ACP_Customer_Overview__c();
   ACP_Customer_Overview__c endmarkets = new ACP_Customer_Overview__c();
   ACP_Customer_Overview__c region = new ACP_Customer_Overview__c();

   ACP_Customer_Overview__c key = new ACP_Customer_Overview__c();
   ACP_Customer_Overview__c location = new ACP_Customer_Overview__c();
   ACP_Customer_Overview__c vendor = new ACP_Customer_Overview__c();
   public ID revenueRecordTypeId {
      get;
      set;
   }
   public Id endMarketRecordTypeId {
      get;
      set;
   }
   public Boolean readonly {
      get;
      set;
   }

   Id regionsRecordTypeId = Schema.SObjectType.ACP_Customer_Overview__c.getRecordTypeInfosByName().get('Regions').getRecordTypeId();
   Id keyRecordTypeId = Schema.SObjectType.ACP_Customer_Overview__c.getRecordTypeInfosByName().get('Key Manufacturing /Purchasing Locations').getRecordTypeId();
   Id locRecordTypeId = Schema.SObjectType.ACP_Customer_Overview__c.getRecordTypeInfosByName().get('Key Engineering /Design locations').getRecordTypeId();
   Id vendRecordTypeId = Schema.SObjectType.ACP_Customer_Overview__c.getRecordTypeInfosByName().get('Key Vendors in Supply Chain').getRecordTypeId();


   public List < ACP_Customer_Overview__c > custOverviewList {
      get;
      set;
   }
   public String currentRecordId {
      get;
      set;
   }

   private final ACP_Account_Plan__c acctPlan {
      get;
      set;
   }
 
   public List < Attachment > AcpAtt {
      get;
      set;
   }
  
   public Map < string, id > ImgName {
      get;
      set;
   }
  



  
   /*****************************************************For record type selection page***********************************************************************/

   public List < SelectOption > getRecordTypes() {
      List < SelectOption > RecordOptions = new List < SelectOption > ();
      RecordOptions.add(new SelectOption('Revenue and Growth', 'Revenue and Growth'));
      RecordOptions.add(new SelectOption('End Markets', 'End Markets'));
      RecordOptions.add(new SelectOption('Regions', 'Regions'));
      RecordOptions.add(new SelectOption('Key Manufacturing/Purchasing Locations', 'Key Manufacturing/Purchasing Locations'));
      RecordOptions.add(new SelectOption('Key Engineering/Design Locations', 'Key Engineering/Design Locations'));
      RecordOptions.add(new SelectOption('Key Vendors in Supply Chain', 'Key Vendors in Supply Chain'));

      return RecordOptions;
   }

   public pagereference save() {
     
     
      return page.ACP_Customer_Overview_Add;
   }

   public pagereference cancel() {
      return pageRedirectWithDivId('customer');
      
   }

   Public ACP_Customer_Overview__c getrevenue() {
      return revenue;
   }

   Public ACP_Customer_Overview__c getendmarkets() {
      return endmarkets;
   }

   Public ACP_Customer_Overview__c getregion() {
      return region;
   }

   Public ACP_Customer_Overview__c getkey() {
      return key;
   }

   Public ACP_Customer_Overview__c getlocation() {

      return location;
   }

   Public ACP_Customer_Overview__c getvendor() {
      return vendor;
   }

  
   /*-----------------------------Revenue----------------------*/
   public void saveRevenueCommon() {
      try {
         revenue.RecordTypeId = revenueRecordTypeId;
         revenue.ACP_Account_Plan__c = acpid;
         insert revenue;
      } catch (DMLException e) {
         ErrorLogging.Log(e, 'ACP_View_Customer_Page_ctrl', 'saveRevenueCommon', acpId);
         ApexPages.addMessages(e);
      }
   }

   public pageReference AddRevenue() {
      saveRevenueCommon();
      //return masterPageRedirection();
    return pageRedirectWithDivId('customer');
   }

   public pageReference saveAndNewRevenue() {
      saveRevenueCommon();
      return RecordTypeSelection();
   }
   /*-------------------------------End------------------*/
   public void saveEndCommon() {
      try {
         endmarkets.RecordTypeId = endMarketRecordTypeId;
         endmarkets.ACP_Account_Plan__c = acpid;
         insert endmarkets;
      } catch (DMLException e) {
         ErrorLogging.Log(e, 'ACP_View_Customer_Page_ctrl', 'saveEndCommon', acpId);
         ApexPages.addMessages(e);
      }
   }
   public pageReference AddEnd() {
      saveEndCommon();
    return pageRedirectWithDivId('customer');

   }
   public pageReference saveAndNewEnd() {
      saveEndCommon();
      return RecordTypeSelection();
   }
   /*---------------------Region---------------------*/
   public void saveRegionCommon() {
      try {
         region.RecordTypeId = regionsRecordTypeId;
         region.ACP_Account_Plan__c = acpid;
         insert region;
      } catch (DMLException e) {
         ErrorLogging.Log(e, 'ACP_View_Customer_Page_ctrl', 'saveRegionCommon', acpId);
         ApexPages.addMessages(e);
      }
   }
   public pageReference AddRegion() {
      saveRegionCommon();
    return pageRedirectWithDivId('customer');

   }
   public pageReference saveAndNewRegion() {
      saveRegionCommon();
      return RecordTypeSelection();
   }
   /*----------------------Key-------------------*/
   public void saveKeyCommon() {
      try {
         key.RecordTypeId = keyRecordTypeId;
         key.ACP_Account_Plan__c = acpid;
         insert key;
      } catch (DMLException e) {
         ErrorLogging.Log(e, 'ACP_View_Customer_Page_ctrl', 'saveKeyCommon', acpId);
         ApexPages.addMessages(e);
      }
   }
   public pageReference AddKey() {
      saveKeyCommon();
return pageRedirectWithDivId('customer');
   }
   public pageReference saveAndNewKey() {
      saveKeyCommon();
      return RecordTypeSelection();
   }
   /*----------------------------Location-------------*/
   public void saveLocationCommon() {
      try {
         location.RecordTypeId = locRecordTypeId;
         location.ACP_Account_Plan__c = acpid;
         insert location;
      } catch (DMLException e) {
         ErrorLogging.Log(e, 'ACP_View_Customer_Page_ctrl', 'saveLocationCommon', acpId);
         ApexPages.addMessages(e);
      }
   }
   public pageReference AddLocation() {
      saveLocationCommon();
      
return pageRedirectWithDivId('customer');
   }
   public pageReference saveAndNewLocation() {
      saveLocationCommon();
      return RecordTypeSelection();
   }
   /*----------------------Vendor-----------------------*/
   public void saveVendorCommon() {
      try {
         vendor.RecordTypeId = vendRecordTypeId;
         vendor.ACP_Account_Plan__c = acpid;
         insert vendor;
      } catch (DMLException e) {
         ErrorLogging.Log(e, 'ACP_View_Customer_Page_ctrl', 'saveVendorCommon', acpId);
         ApexPages.addMessages(e);
      }
   }
   public pageReference AddVendor() {
      saveVendorCommon();
      //return masterPageRedirection();
    return pageRedirectWithDivId('customer');
   }
   public pageReference saveAndNewVendor() {
      saveVendorCommon();
      return RecordTypeSelection();
   }


   public PageReference RecordTypeSelection() {
      PageReference redirect = new PageReference('/apex/ACP_Customer_Overview_Record_Types');
      redirect.getParameters().put('acpId', acpId);
      redirect.setRedirect(true);
      return redirect;
   }

   /**************************************************For edit *************************************************************************/
   public PageReference editCompetitors() {
      PageReference pageref = new PageReference('/apex/ACP_Account_Plan_Edit?retURL=/apex/ACP_View_Customer_Page?acpid=' + acpid);
      pageref.getParameters().put('Id', acpId);
      pageref.setRedirect(true);
      return pageref;
   }
   public void inlineedit() {
      readonly = false;
      editmode = true;
   }
   public PageReference saveSummary() {
      try {
         update record;
         readonly = true;
         editmode = false;
      } catch (DMLException e) {
         ErrorLogging.Log(e, 'ACP_View_Customer_Page_ctrl', 'saveSummary', acpId);
         ApexPages.addMessages(e);
         return null;
      }
      return null;
   }
   public PageReference cancelSummary() {
      readonly = true;
      editmode = false;
      return null;
   }
   /***********************************************Display tables ****************************************************/
   Id customerRecTypeId = Schema.SObjectType.ACP_Section_Detail__c.getRecordTypeInfosByName().get('Customer Overview').getRecordTypeId();
   public ACP_Section_Detail__c custrec {
      get {
         
         custrec = ACP_AccountPlan_Helper.getACPSectionRec(buSetting, 'Customer Overview');
         
         return custrec;
      }
      set;
   }
   public String recordtypenm {
      get;
      set;
   }
   public List < ACP_Customer_Overview__c > acpRevGrowthList {
      get;
      set;
   }
   public List < ACP_Customer_Overview__c > acpEndMarketList {
      get;
      set;
   }
   public List < ACP_Customer_Overview__c > acpRegionsList {
      get;
      set;
   }
   public List < ACP_Customer_Overview__c > acpKeyManufList {
      get;
      set;
   }
   public List < ACP_Customer_Overview__c > acpKeyEngList {
      get;
      set;
   }
   public List < ACP_Customer_Overview__c > acpVendList {
      get;
      set;
   }
   public List < ACP_Customer_Overview__c > acpCustomerOverviewList = new List < ACP_Customer_Overview__c > ();
   public void getCustOverviewList() {
      acpRevGrowthList = new List < ACP_Customer_Overview__c > ();
      acpEndMarketList = new List < ACP_Customer_Overview__c > ();
      acpRegionsList = new List < ACP_Customer_Overview__c > ();
      acpKeyManufList = new List < ACP_Customer_Overview__c > ();
      acpKeyEngList = new List < ACP_Customer_Overview__c > ();
      acpVendList = new List < ACP_Customer_Overview__c > ();

      acpCustomerOverviewList = getCustomerOverviewList();
      if (acpCustomerOverviewList.size() > 0) {
         for (ACP_Customer_Overview__c acpCustO: acpCustomerOverviewList) {
            if (acpCustO.RecordTypeId == revenueRecordTypeId && acpRevGrowthList.size() < 5)
               acpRevGrowthList.add(acpCustO);
               
               
            if (acpCustO.RecordTypeId == endMarketRecordTypeId && acpEndMarketList.size() < 5)
               acpEndMarketList.add(acpCustO);

            if (acpCustO.RecordTypeId == regionsRecordTypeId && acpRegionsList.size() < 5)
               acpRegionsList.add(acpCustO);

            if (acpCustO.RecordTypeId == keyRecordTypeId && acpKeyManufList.size() < 5)
               acpKeyManufList.add(acpCustO);

            if (acpCustO.RecordTypeId == locRecordTypeId && acpKeyEngList.size() < 5)
               acpKeyEngList.add(acpCustO);

            if (acpCustO.RecordTypeId == vendRecordTypeId && acpVendList.size() < 5)
               acpVendList.add(acpCustO);


         }
      }
   }
   public List < ACP_Customer_Overview__c > getCustomerOverviewList() {
      String query = 'SELECT ';

      for (Schema.FieldSetMember rngFields: this.getRevenueGrowthFields()) {
         query += rngFields.getFieldPath() + ',';
      }


      for (Schema.FieldSetMember emFields: this.getEndMarketFields()) {
         query += emFields.getFieldPath() + ',';
      }


      for (Schema.FieldSetMember regionFields: this.getRegionsFields()) {
         query += regionFields.getFieldPath() + ',';
      }


      for (Schema.FieldSetMember keyFields: this.getKeyFields()) {
         query += keyFields.getFieldPath() + ',';
      }


      for (Schema.FieldSetMember locFields: this.getLocationFields()) {
         query += locFields.getFieldPath() + ',';
      }


      for (Schema.FieldSetMember vendFields: this.getVendorFields()) {
         query += vendFields.getFieldPath() + ',';
      }
      List < Id > myIdList = new List < Id > ();
      myIdList.add(revenueRecordTypeId);
      myIdList.add(endMarketRecordTypeId);
      myIdList.add(regionsRecordTypeId);
      myIdList.add(keyRecordTypeId);
      myIdList.add(locRecordTypeId);
      myIdList.add(vendRecordTypeId);
    try{
      query += 'Id,ACP_Account_Plan__c,RecordTypeId,recordtype.name FROM ACP_Customer_Overview__c where ACP_Account_Plan__c =';
      query += ':acpId and RecordTypeId in :myIdList';
      if (custrec != null && custrec.Default_Sort_Order__c != null)
         query += ' order by ' + custrec.Default_Sort_Order__c;
      return Database.query(query);
      }catch (Exception e)
        {
            ErrorLogging.Log(e, 'ACP_Performance_Analytics_ctrl', 'getADMData', acpid);
            ApexPages.addMessages(e);
            return null;
        }
              
   }
   public List < Schema.FieldSetMember > getRevenueGrowthFields() {
      return SObjectType.ACP_Customer_Overview__c.FieldSets.ACP_Rev_Growth_Fieldset.getFields();
   }
   public List < Schema.FieldSetMember > getEndMarketFields() {
      return SObjectType.ACP_Customer_Overview__c.FieldSets.ACP_End_Markets_Fieldset.getFields();
   }
   public List < Schema.FieldSetMember > getRegionsFields() {
      return SObjectType.ACP_Customer_Overview__c.FieldSets.ACP_Regions_Fieldset.getFields();
   }
   public List < Schema.FieldSetMember > getKeyFields() {
      return SObjectType.ACP_Customer_Overview__c.FieldSets.ACP_Key_Fieldset.getFields();
   }
   public List < Schema.FieldSetMember > getLocationFields() {
      return SObjectType.ACP_Customer_Overview__c.FieldSets.ACP_Location_Fieldset.getFields();
   }
   public List < Schema.FieldSetMember > getVendorFields() {
      return SObjectType.ACP_Customer_Overview__c.FieldSets.ACP_Vendors_Fieldset.getFields();
   }

   /*******************************************************Customer Overview Ends**************************************************************************************/
   /*********************************Common Methods for Cancel and Save Buttons for all new record creation pages *************/

   public pagereference cancelAddPage() {
      String div = ApexPages.currentPage().getParameters().get('div');
      
      PageReference savePageRef = new PageReference('/apex/ACP_View_Customer_Page?acpId=' + acpId + '#' + div);
      savePageRef.setRedirect(true);
      return savePageRef;
      
   }

   

   //-----------------------------------------------------------------------------------------------


   /************************************************Stakeholder & Relationship - Start */
   public String relation {
      get;
      set;
   }
   public List < ACP_Relationship__c > acpEngineeringRelationList {
      get;
      set;
   }
   public List < ACP_Relationship__c > acpPurchasingRelationList {
      get;
      set;
   }
   public List < ACP_Relationship__c > acpExecutiveRelationList {
      get;
      set;
   }
   transient List < ACP_Relationship__c > acpRelationList {
      get;
      set;
   }
   public ACP_Relationship__c acp_relationObj {
      get {
         if (acp_relationObj == null)
            acp_relationObj = new ACP_Relationship__c();
         return acp_relationObj;
      }
      set;
   }
   public ACP_Section_Detail__c relrec {
      get {
         relrec = ACP_AccountPlan_Helper.getACPSectionRec(buSetting, 'Stakeholder and Relationship');
         return relrec;
      }
      set;
   }
   public void setACPRelationList() {
      acpEngineeringRelationList = new List < ACP_Relationship__c > ();
      acpPurchasingRelationList = new List < ACP_Relationship__c > ();
      acpExecutiveRelationList = new List < ACP_Relationship__c > ();
      if (relrec != null) {
         acpRelationList = ACP_AccountPlan_Helper.getacpRelList(relrec.ACP_Field_Set_Name__c, relrec.Default_Sort_Order__c, acpId);
         if (acpRelationList.size() > 0) {
            for (ACP_Relationship__c acpRel: acpRelationList) {
               if (acpRel.Relationship__c == 'Engineering' && acpEngineeringRelationList.size() < relrec.ACP_Num_Rerds_Eng_Rel__c)
                  acpEngineeringRelationList.add(acpRel);
               if (acpRel.Relationship__c == 'Purchasing' && acpPurchasingRelationList.size() < relrec.ACP_Num_of_Rcds_Pur_Rel__c)
                  acpPurchasingRelationList.add(acpRel);
               if (acpRel.Relationship__c == 'Executive' && acpExecutiveRelationList.size() < relrec.ACP_No_Reds_Exe_Rel__c)
                  acpExecutiveRelationList.add(acpRel);
            }
         }
      } else {
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, System.Label.ACP_BU_Setting_Error));
      }
   }
   public List < Schema.FieldSetMember > getStakeholderFields() {
      if (relrec != null && relrec.ACP_Field_Set_Name__c != null)
         return ACP_AccountPlan_Helper.getFieldSetFields(relrec.ACP_Field_Set_Name__c, 'ACP_Relationship__c');
      else return SObjectType.ACP_Relationship__c.FieldSets.ACP_Relationship_Fieldset.getFields();
   }
   public void saveCommon() {
      if (acpId != null) {
         acp_relationObj.ACP_Account_Plan__c = acpId;
          acp_relationObj.Relationship__c = relation;
         insert acp_relationObj;
      }
   }
   public PageReference saveRelation() {
      try {
         saveCommon();
         return pageRedirectWithDivId('relationship');
      } catch (Exception e) {
         ErrorLogging.Log(e, 'ACP_View_Customer_Page_ctrl', 'saveRelation', acpId);
         ApexPages.addMessages(e);
      }
      return null;
   }
   public PageReference saveAndNew() {
      try {
         saveCommon();
         setACPRelationList();
         PageReference pagerefSN = new PageReference('/apex/ACP_AddNewRelationship?saveURL=/apex/ACP_Account_Plan_Master?acpId=' + acpId);
         pagerefSN.getParameters().put('relationType', relation);
         pagerefSN.getParameters().put('acpId', acpId);
         if (relation == 'Engineering' && acpEngineeringRelationList.size() == (relrec.ACP_Num_Rerds_Eng_Rel__c - 1))
            pagerefSN.getParameters().put('enableSaveNew', 'true');
         if (relation == 'Purchasing' && acpPurchasingRelationList.size() == (relrec.ACP_Num_of_Rcds_Pur_Rel__c - 1))
            pagerefSN.getParameters().put('enableSaveNew', 'true');
         if (relation == 'Executive' && acpExecutiveRelationList.size() == (relrec.ACP_No_Reds_Exe_Rel__c - 1))
            pagerefSN.getParameters().put('enableSaveNew', 'true');
         pagerefSN.setRedirect(true);
         return pagerefSN;
      } catch (Exception e) {
         ErrorLogging.Log(e, 'ACP_View_Customer_Page_ctrl', 'saveAndNew', acpId);
         ApexPages.addMessages(e);
      }
      return null;
   }

   /************************************************Stakeholder & Relationship - End */
   /************************************************Supplier Evaluation - Start */
   ACP_TE_Supplier_Evaluation__c newSupplierEval = new ACP_TE_Supplier_Evaluation__c();
   Public ACP_TE_Supplier_Evaluation__c getNewSupplierEval() {

      return newSupplierEval;
   }
   public ACP_TE_Suppliers_Rating__c newSuppliersRating = new ACP_TE_Suppliers_Rating__c();
   Public ACP_TE_Suppliers_Rating__c getNewSuppliersRating() {

      return newSuppliersRating;
   }
   public List < ACP_TE_Supplier_Evaluation__c > supplierEvaluationList {
      get;
      set;
   }
   public List < ACP_TE_Supplier_Evaluation__c > evaluationList = new List < ACP_TE_Supplier_Evaluation__c > ();
   public List < ACP_TE_Suppliers_Rating__c > suppliersRatingList {
      get;
      set;
   }
   public List < ACP_TE_Suppliers_Rating__c > ratingList = new List < ACP_TE_Suppliers_Rating__c > ();

   public ACP_Section_Detail__c evalrec {
      get {
         evalrec = ACP_AccountPlan_Helper.getACPSectionRec(buSetting, 'TE Supplier Evaluation');
         return evalrec;
      }
      set;
   }
   public void getEvaluationList() {
      supplierEvaluationList = new List < ACP_TE_Supplier_Evaluation__c > ();
        if(evalrec != null)
      evaluationList = getSupplierEvaluationList(evalrec.Default_Sort_Order__c, acpId, evalrec.ACP_No_Of_Records__c);

      if (evaluationList.size() > 0) {
         for (ACP_TE_Supplier_Evaluation__c eval: evaluationList) {
            supplierEvaluationList.add(eval);

         }
      }
   }
   public List < Schema.FieldSetMember > getEvaluationFields() {

      Map < String, Schema.Fieldset > fieldsetsEvalMap = Schema.SObjectType.ACP_TE_Supplier_Evaluation__c.fieldSets.getMap();
      if (evalrec != null && evalrec.ACP_Field_Set_Name__c != null) {
         return fieldsetsEvalMap.get(evalrec.ACP_Field_Set_Name__c).getFields();
      } else
         return SObjectType.ACP_TE_Supplier_Evaluation__c.FieldSets.ACP_Suppl_Evaluation_Fieldset.getFields();
   }


   public void getRatingList() {
      suppliersRatingList = new List < ACP_TE_Suppliers_Rating__c > ();
      if(evalrec != null)
      ratingList = getSuppliersRatingList(evalrec.Default_Sort_Order__c, acpId, evalrec.ACP_No_Of_Records__c);
      
      if (ratingList.size() > 0) {
         for (ACP_TE_Suppliers_Rating__c rating: ratingList) {
            suppliersRatingList.add(rating);

         }
      }
   }

   public List < Schema.FieldSetMember > getRatingFields() {
      Map < String, Schema.Fieldset > fieldsetsRatingMap = Schema.SObjectType.ACP_TE_Suppliers_Rating__c.fieldSets.getMap();
      if (evalrec != null) {
         return fieldsetsRatingMap.get(evalrec.ACP_Field_Set_1__c).getFields();
      } else return SObjectType.ACP_TE_Suppliers_Rating__c.FieldSets.ACP_Suppl_Rating_Fieldset.getFields();
   }

   public List < ACP_TE_Suppliers_Rating__c > getSuppliersRatingList(String sortOrder, String acpId, Decimal noOfRecords) {
      transient String query = 'SELECT ';

      for (Schema.FieldSetMember f: getRatingFields()) {
         query += f.getFieldPath() + ',';
      }
      query += 'ACP_Account_Plan__c FROM ACP_TE_Suppliers_Rating__c where ACP_Account_Plan__c = \'' + acpId + '\'';
      if (sortOrder != null)
         query += ' order by ' + sortOrder;
      if (noOfRecords != null)
         query += ' limit ' + noOfRecords;
      else
         query += ' limit 5';

      return Database.query(query);

   }

   public List < ACP_TE_Supplier_Evaluation__c > getSupplierEvaluationList(String sortOrder, String acpId, Decimal noOfRecords) {
      transient String query = 'SELECT ';

      for (Schema.FieldSetMember f: getEvaluationFields()) {
         query += f.getFieldPath() + ',';
      }
      query += 'Id,ACP_Account_Plan__c FROM ACP_TE_Supplier_Evaluation__c where ACP_Account_Plan__c = \'' + acpId + '\'';
      if (sortOrder != null)
         query += ' order by ' + sortOrder;
      if (noOfRecords != null)
         query += ' limit ' + noOfRecords;
      else
         query += ' limit 5';
      return Database.query(query);

   }
   public pageReference saveSupplierEval() {
      try {
         newSupplierEval.ACP_Account_Plan__c = acpId;
         insert newSupplierEval;
         return pageRedirectWithDivId('rating');
      } catch (Exception e) {
         ErrorLogging.Log(e, 'ACP_View_Customer_Page_ctrl', 'saveSupplierEval', acpId);
         ApexPages.addMessages(e);

      }
      return null;
   }



   public pageReference saveNewSupplierEval() {
      try {
         newSupplierEval.ACP_Account_Plan__c = acpId;
         insert newSupplierEval;

         PageReference pageref = new PageReference('/apex/ACP_new_supplier_evaluation');
         pageref.getParameters().put('acpId', acpId);
         pageref.setRedirect(true);
         return pageref;


      } catch (DMLException e) {
         ErrorLogging.Log(e, 'ACP_View_Customer_Page_ctrl', 'saveNewSupplierEval', acpId);
         ApexPages.addMessages(e);

      }
      return null;

   }
   public pageReference saveSuppliersRating() {

      try {
         newSuppliersRating.ACP_Account_Plan__c = acpId;
         insert newSuppliersRating;
         return pageRedirectWithDivId('rating');

      } catch (DMLException e) {
         ErrorLogging.Log(e, 'ACP_View_Customer_Page_ctrl', 'saveSuppliersRating', acpId);
         ApexPages.addMessages(e);
         return null;
      }
      return null;
   }
   public pageReference saveNewSuppliersRating() {

      try {
         newSuppliersRating.ACP_Account_Plan__c = acpId;
         insert newSuppliersRating;
         PageReference pageref = new PageReference('/apex/ACP_new_suppliers_rating');
         pageref.getParameters().put('acpId', acpId);
         pageref.setRedirect(true);
         return pageref;

      } catch (DMLException e) {
         ErrorLogging.Log(e, 'ACP_View_Customer_Page_ctrl', 'saveNewSuppliersRating', acpId);
         ApexPages.addMessages(e);

      }

      return null;
   }


   /************************************************Supplier Evaluation - End */
   /************************************************Code for Actions scetion - Start */
   public List < Task > taskList {
      get;
      set;
   }
  
   public void setCategoryWiseTask() {   
      taskList = ACP_AccountPlan_Helper.getAllTasks(acpId);
   }
   /************************************************Code for Actions scetion - End */

   /*******************************************Call the Page to Edit Account Plan*************************************/
   public PageReference editAccountPlan() {
      PageReference pageref = new PageReference('/apex/ACP_Account_Plan_Edit?retURL=/apex/ACP_View_Customer_Page?acpid=' + acpid);
      pageref.getParameters().put('Id', acpId);
      //PageReference pageref = new PageReference('/apex/ACP_Account_Plan_Edit?id='+ acpid);
      pageref.setRedirect(true);
      return pageref;
   }

   
   Id accPlanRecTypeId = Schema.SObjectType.ACP_Section_Detail__c.getRecordTypeInfosByName().get('Account Plan Header').getRecordTypeId();
   public ACP_Section_Detail__c accPlanrec {
      get {
         accPlanrec = ACP_AccountPlan_Helper.getACPSectionRec(buSetting, 'Account Plan Header');
         return accPlanrec;
      }
      set;

   }


   /***********************************************Tab start************************************************/
   /*This method is used for redirect to other pages from onclicking of main tabs */
   public string Tabpagetoset {
      get;
      set;
   }
   Public Pagereference redirectTabpage() {
     
      pagereference pr;
      Tabpagetoset = apexpages.currentpage().getparameters().get('tabpage');
     
      if (Tabpagetoset != null && Tabpagetoset != '') {
       
         pr = new pagereference('/apex/' + Tabpagetoset + '?acpId=' + acpId);
         pr.setredirect(true);
         return pr;
      }
      return pr;
   }

   public pagereference pageRedirectWithDivId(String divId) {
      PageReference savePageRef = new PageReference('/apex/ACP_View_Customer_Page?acpId=' + acpId + '#' + divId);
      savePageRef.setRedirect(true);
      return savePageRef;
   }
   
    public pagereference viewTab() {
      PageReference savePageRef = new PageReference('/apex/ACP_View_Customer_Page?acpId=' + acpId);
      savePageRef.getParameters().put('acpId', acpId);
      savePageRef.setRedirect(true);
      return savePageRef;
   }
   
     public pagereference performanceTab() {
      PageReference savePageRef = new PageReference('/apex/ACP_Performance_Analytics_Page?acpId=' + acpId);
      savePageRef.getParameters().put('acpId', acpId);
      savePageRef.setRedirect(true);
      return savePageRef;
   }
   
    public pagereference summaryTab() {
      PageReference savePageRef = new PageReference('/apex/ACP_Account_Plan_Summary_Page?acpId=' + acpId);
      savePageRef.getParameters().put('acpId', acpId);
      savePageRef.setRedirect(true);
      return savePageRef;
   }


 
}