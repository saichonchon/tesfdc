/** 
 *  This class is Extension Controller for ExtCreatePLMProject.page
 *  this class used to create PLM Project by calling out external webservice method
 *
 @author Yinfeng Guo
 @created 2012-03-20
 @version 1.0
 @since 23.0 (Force.com ApiVersion)
 *
 @changelog
 * 2012-03-20 Yinfeng Guo <yinfeng.guo@itbconsult.com>
 * - Created
 * 2012-04-04 Frederic Faisst <frederic.faisst@itbconsult.com>
 * - Parameter to send to cast iron by outbound call --> "CIS||{!Opportunity.Id}"
 * - 9 Industry Code --> Please define custom setting and retrieve the values out of there.
 * - 6 Master data parameter --> Please define custom setting and retrieve the values out of there.
 * - It seems that there are many hardcoded values in the code. This must be customized with custom settings
 * 2012-04-06 Yinfeng Guo <yinfeng.guo@itbconsult.com>
 * - Remove Hard Code
 * 2013-04-11 Bin Yu <bin.yu@itbconsult.com>
 * - remove the check of "In Approval" for Product Platform
 * 2013-06-13 Subba Reddy
 * - To bypass process and validation rules for Engineering_Opportunity_CSD RT Opportunities.
 */

public with sharing class ExtCreatePLMProject {
 
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //public String mode{get;set;}

    /**
     * the value for PLM_Project_Template__c
     */ 
    public String projectTemplate{get;set;}

    /**
     * the value for PLM_Responsible_Design_Group__c
     */     
    public String responsibleDesignGroup{get;set;}
    
    /**
     * the value for PLM_Project_Leverage__c
     */     
    public String leverage{get;set;}
    
    /**
     * the value for PLM_Project_Category__c
     */     
    public String projectCategory{get;set;}
    
    /**
     * the value for PLM_Project_Complexity__c
     */     
    public String projectComplexity{get;set;}
    
    /**
     * the value for PLM_Project_Approval_Committee__c
     */     
    public String projectApprovalCommittee{get;set;}
    
    /**
     * the value for Sales_Part_Forecast_Send_to_PLM__c
     */ 
    public Boolean SalesPartForecastSendtoPLM{get;set;}

    /**
     * the value to tell us whether have value for Project Template selectlist
     */ 
    public Boolean projectTemplateRendered{get;set;}

    /**
     * the value to tell us whether have value for Responsible Design Group selectlist
     */ 
    public Boolean responsibleDesignGroupRendered{get;set;}
    
    /**
     * the value to tell us whether have value for Leverage selectlist
     */ 
    public Boolean leverageRendered{get;set;}
    
    /**
     * the value to tell us whether have value for Project Category selectlist
     */ 
    public Boolean projectCategoryRendered{get;set;}
    
    /**
     * the value to tell us whether have value for project Complexity selectlist
     */ 
    public Boolean projectComplexityRendered{get;set;}
    
    /**
     * the value to tell us whether have value for Project Approval Committee selectlist
     */ 
    public Boolean projectApprovalCommitteeRendered{get;set;}
    
    /**
     * this map contains the selectlist value
     */     
    public map<string, list<selectOption>> map_name_picklist {get; private set;}
    
    /**
     * this list contains the field name will be showed
     */     
    public list<string> list_fieldName  {get; private set;}
    
    /**
     * the opportunity name
     */ 
    public String OppyName {get;private set;}
    
    /**
     * the opportunity
     */ 
    public Opportunity opportunity {get;set;}
    
    /**
     * the variable to tell us whether is plm user
     */ 
    public Boolean isPLMUser{get;set;}

    /**
     * the variable to tell us whether have saved picklist values to Opportunity
     */ 
    public Boolean saved2Opportunity{get;set;}
        
    /**
     * the actual user
     */
    public User actualUser;

    /**
     * the TE Network id
     */
    public String teNetworkId = '';
        
    /**
     * the project Template selectlist Label
     */
    public String projectTemplateLabel{get;set;}
    
    /**
     * the responsible Design Group selectlist Label
     */
    public String responsibleDesignGroupLabel{get;set;}
    
    /**
     * the leverage selectlist Label
     */
    public String leverageLabel{get;set;}
    
    /**
     * the project Category selectlist Label
     */
    public String projectCategoryLabel{get;set;}
    
    /**
     * the project Complexity selectlist Label
     */
    public String projectComplexityLabel{get;set;}
    
    /**
     * the project ApprovalCommittee selectlist Label
     */
    public String projectApprovalCommitteeLabel{get;set;}
    
    /**
     * the project ApprovalCommittee selectlist Label
     */ 
    public String SalesPartForecastSendtoPLMLabel{get;set;}
    
    //JNV 10/5/2012 - all we should need to know here is config name, 
    //and data to pass to traffic cop like endpoint names
    //let realtime class do all the work setting up the traffic cop services
    public string configName{get;set;}    
    public string serviceEndpoint{get;set;}
    public string certName{get;set;}
    public string orgName{get;set;}
    //*
    public string sfdcUsername{get;set;}        
    public string endPointAppPlm{get;set;}
    public string endPointAppMasterData{get;set;}
    //public string sfdcData;
    public string WSResponsePLM{get;set;}
    public string WSResponseMASTERDATA{get;set;}
    public string plm{get;set;}
    public string masterData{get;set;} 
    //public Boolean isApplianceCostUser {get; set;} 
        
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //get URL params
    private map<String, String> map_urlParams;
    private final ApexPages.standardController stdCtrl;
    
    //9 Industry Code
    private String ACCOUNTINDUSTRYCODE_Appliances ;
    private String ACCOUNTINDUSTRYCODE_Rail;
    private String ACCOUNTINDUSTRYCODE_MEFA ;
    private String ACCOUNTINDUSTRYCODE_CBT ;
    private String ACCOUNTINDUSTRYCODE_Solar ;
    private String ACCOUNTINDUSTRYCODE_DataComm ;
    private String ACCOUNTINDUSTRYCODE_Other;
    private String ACCOUNTINDUSTRYCODE_ConsumerDevices;
    private String ACCOUNTINDUSTRYCODE_Channel;
        
    //6 Master data parameter
    private String MASTERDATA_APL;
    private String MASTERDATA_CSD;
    private String MASTERDATA_DTC;
    private String MASTERDATA_IND;
    private String MASTERDATA_CBU;
    private String MASTERDATA_OTH;
    
    
    private String accountIndustry;
    private Boolean responseError;
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
   /**
    * The contsructor
    *
    @author Yinfeng Guo
    @created 2012-03-20
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @changelog
    * 2012-03-20 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */
    public ExtCreatePLMProject(ApexPages.standardController stdCtrl) {
        try{
            this.stdCtrl = stdCtrl;
            isPLMUser = false;
            saved2Opportunity = false;
            responseError = false;  //changed initial value from false to true, because isStartElement check not working
            //isApplianceCostUser = false;
            /////////////=======================Step 1 : Validate the user : to check if the actual users "PLM_User__c" checkbox is checked and if the "EmployeeNumber" is defined. 
            for(User u : [Select PLM_User__c, EmployeeNumber, TE_Network_Id__c,GIBU__c from User Where Id =: UserInfo.getUserId()]){
                actualUser = u;
                teNetworkId = u.Te_Network_Id__c;
            }

            Id actualUserProfileId = UserInfo.getProfileId();
            //set<Id> applianceProfileId = new set<Id>();
            
            Apex_Helper_Settings__c PLMProfiles = Apex_Helper_Settings__c.getInstance('PLM Project Profile List');
            List<String> PLMProfileList = PLMProfiles.value__c.split(',');
            
            set<Id> set_profileIds = new set<Id>();

            for(Profile p : [SELECT Name, Id FROM Profile where Name in: PLMProfileList]){
                set_profileIds.add(p.Id);
                //if (p.Name == 'Appliance User w/ Cost')
                //    applianceProfileId.add(p.Id);
            }
  
             
            //if(applianceProfileId.contains(actualUserProfileId))
            //    isApplianceCostUser = true;
            
            //It should be only possible to click on the "Create PLM Project" button on opportunity level, if the actual user has one of these profiles "Industrial Engineering User w/Cost", "Appliance Engineering User w/Cost" and the "PLM_User__c" checkbox is ticked on his user record.
            if(actualUser != null && actualUser.PLM_User__c == true && set_profileIds.contains(actualUserProfileId)){
                if( actualUser.TE_Network_ID__c == null || actualUser.TE_Network_ID__c == ''){  
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, system.label.Your_TE_Network_ID_is_Empty_or_Null));// 'Your TE Network ID is Empty or Null.' added by di chen 2012/11/21
                    return;
                }  
                else isPLMUser = true;
            }
            else{//If another user clicks on this button an error message should occur: You've not the level of permission to create a PLM project"   
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, system.label.You_do_not_have_the_correct_permissions_to_create_a_PLM_project ));  //'You do not have the correct permissions to create a PLM project.'added by di chen 2012/11/21
                return;
            }
            
            
            
            /////////////=======================Step 2: Initialize some common value
            //JNV 10/18 - comment out hard coded profit center derivation from industry
            //IndustryCode();
            //MasterDataParameter();
            projectTemplateLabel = 'Project Template';
            responsibleDesignGroupLabel = 'Responsible Design Group';
            leverageLabel = 'Project Leverage';
            projectCategoryLabel = 'Project Category';
            projectComplexityLabel = 'Project Complexity';
            projectApprovalCommitteeLabel = 'Product Approval Committee';
            
            //JNV 10/5/2012 - here just query for the correct rcs config name, based on which is active
            for(realtime_Callout_Settings__c rcs : realtime_Callout_Settings__c.getAll().values()) {
                if(rcs.Active__c == true ) {
                    if(rcs.Name == 'Prod PLM Picklist' || rcs.Name == 'QA PLM Picklist'){
                        configName = rcs.Name;  
                    }
                }
            }
            
            sfdcUsername = actualUser.TE_Network_ID__c;
            OppyName = '';

            map_urlParams = ApexPages.currentPage().getParameters();
            opportunity = (Opportunity)stdCtrl.getRecord();
            if(opportunity.Id != null){
                for(Opportunity o : [Select  Account.Profit_ctr_code__c, Account.Name, Amount, PLM_Id__c, PLM_Project_Approval_Committee__c, PLM_Project_Category__c, PLM_Project_Complexity__c, PLM_Project_Leverage__c, PLM_Project_Template__c, PLM_Responsible_Design_Group__c, Id, Industry_Code__c, Name, Do_you_know_the_Product_Market_Size__c,Product_Market_Size__c, RecordTypeId, RecordType.DeveloperName from Opportunity where Id =: opportunity.Id]){
                    OppyName =  o.Name;
                    masterData = o.Account.Profit_ctr_code__c;
                    opportunity = o;
                }
            }
            if(masterData == null || masterData == ''){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, system.label.The_opportunity_account_s_field_Profit_ctr_code_c_is_null_or_empty));  //'The opportunity account\'s field \'Profit_ctr_code__c\' is null or empty!' added by di chen 2012/11/21
                return;
            }
            
            
            GetFieldName();
            
            /////////////=======================Step 3 : Get the MASTERDATA according to the value defined in Opportunity "Account_Industry__c" field  
            //JNV 10/18 comment this out as masterdata was set above
            //GetMasterData();        

            /////////////=======================Step 4 : Get the PLM from the "EmployeeNumber" of User. 
            GetPLM();
            /////////////=======================Step 5 : call to the traffic cop for the PLM
            callPLMRealTime(); 
            /////////////=======================Step 6 : call to the traffic cop for the MaterData
            callMASTERDATARealTime();
                       
            map_name_picklist = new map<string, list<selectOption>>();
            /////////////=======================Step 7 : Extract Plm
            ExtractPLMResponse();
            /////////////=======================Step 8 : Extract MaterData
            ExtractMasterDataResponse();

            if(responseError == false){
                if( map_name_picklist.get(projectApprovalCommitteeLabel).size() == 0) projectApprovalCommitteeRendered = false; else projectApprovalCommitteeRendered = true;
                if( map_name_picklist.get(projectComplexityLabel).size() == 0) projectComplexityRendered = false; else projectComplexityRendered = true;
                if( map_name_picklist.get(projectCategoryLabel).size() == 0) projectCategoryRendered = false; else projectCategoryRendered = true;
                if( map_name_picklist.get(leverageLabel).size() == 0) leverageRendered = false; else leverageRendered = true;
                if( map_name_picklist.get(responsibleDesignGroupLabel).size() == 0) responsibleDesignGroupRendered = false; else responsibleDesignGroupRendered = true;
                if( map_name_picklist.get(projectTemplateLabel).size() == 0) projectTemplateRendered = false; else projectTemplateRendered = true;
            }
            else{
                isPLMUser = false;
            }
            
        }
        catch (Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));  
        }
        

    }
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************

    /**
     * This method is used to assign values from PLM Project to Opportunity when click button 'Create PLM Project' on the page
     *
     @author Yin Feng
     @created 2012-03-20
     @version 1.0
     @since 23.0
     *
     @return            void
     *
     @changelog
     * 2012-01-20 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */ 
     
    public void Save2Opportunity(){//CreatePLMProject 
        if(opportunity != null){    
            
            if(opportunity.Do_you_know_the_Product_Market_Size__c == 'Yes' && opportunity.Product_Market_Size__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, system.label.You_need_to_enter_a_Product_Market_Size));//'You need to enter a Product Market Size.' added by di chen 2012/11/21
                return;
            }
            
            if(projectApprovalCommittee == null || projectCategory == null || projectComplexity == null || leverage == null || projectTemplate == null || responsibleDesignGroup == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, system.label.You_can_not_save_the_current_values_to_the_Opportunity_because_some_required_fi ));//'You can not save the current values to the Opportunity, because some required fields are not filled.' added by di chen 2012/11/21
                return;
            }
            
            //JNV 10/18 check for approved status
            List<ProcessInstance> ApprovalResults = [Select Status from ProcessInstance where TargetObjectId =: opportunity.Id order by lastmodifieddate desc limit 1];
            
            String reqStage = 'In Approval';
            if(Apex_Helper_Settings__c.getInstance('PLM Required Stage') != null && Apex_Helper_Settings__c.getInstance('PLM Required Stage').Value__c != null) reqStage = Apex_Helper_Settings__c.getInstance('PLM Required Stage').Value__c;
            
            //FFA 11/19 Added debug statements to check wh it is not possible to create a PLM Project
            //Status out of ProcessInstance Object is not "In Approval", the value is called "Pending" --> Double check with Bin
            
            //************************************************************************************************************
            //added by BYU 2013-04-11 to remove the check of "In Approval" for Product Platform START:
            //added by Toshi, the same logic for IND_Engineering_project and Opportunity_Engineering_Project record type.(ammend on 2014-05-16 for 'Opportunity_Engineering_Project')
            //************************************************************************************************************                     
            if(opportunity.RecordType.DeveloperName != 'Opportunity_Product_Platform' && opportunity.RecordType.DeveloperName != 'Engineering_Opportunity_CSD' && opportunity.RecordType.DeveloperName != 'IND_Engineering_project' && opportunity.RecordType.DeveloperName != 'Opportunity_Engineering_Project'){                                        
                if(ApprovalResults.Size() == 0 ||  ApprovalResults.get(0).Status != 'Pending'){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, system.label.Can_not_save_Project_Creation_Values_Opportunity_must_be  + reqStage + system.label.to_send_to_PLM));//'Can not save Project Creation Values.  Opportunity must be "' '" to send to PLM.' added by di chen 2012/11/21
                    return;             
                }            
            }
            //************************************************************************************************************
            //added by Toshi 2014-04-25 to add the check if PLM Id exist for 'IND Engineering opportunity' record type(ammend on 2014-05-16 for 'Opportunity_Engineering_Project')
            //************************************************************************************************************
            if((opportunity.RecordType.DeveloperName == 'IND_Engineering_project' || opportunity.RecordType.DeveloperName == 'Opportunity_Engineering_Project') && opportunity.PLM_Id__c != null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, system.label.PLM_project_already_exists_for_this_opportunity));//'Can not create PLM project for second time for "IND Engineering opportunity" record type.' added by Toshi(Zensar team) 25/04/2014
                    return;     
            }
            //************************************************************************************************************
            //added by Michael Cui 2014-03-31 to add the check of "In Approval" for Appliances(Case 00663410)
            //************************************************************************************************************ 
            //if(opportunity.RecordType.DeveloperName == 'Opportunity_Product_Platform' && isApplianceCostUser == true){
            if(opportunity.RecordType.DeveloperName == 'Opportunity_Product_Platform' && actualUser.GIBU__c == 'Appliances'){    
                if(ApprovalResults.Size() == 0 ||  ApprovalResults.get(0).Status != 'Pending'){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, system.label.Can_not_save_Project_Creation_Values_Opportunity_must_be  + reqStage + system.label.to_send_to_PLM));//'Can not save Project Creation Values.  Opportunity must be "' '" to send to PLM.' added by di chen 2012/11/21
                    return;             
                }            
            }
            //************************************************************************************************************
            //added by BYU 2013-04-11 to remove the check of "In Approval" for Product Platform END
            //************************************************************************************************************  
            
            //PLM_Project_Approval_Committee__c, PLM_Project_Category__c, PLM_Project_Complexity__c, PLM_Project_Leverage__c, PLM_Project_Template__c, PLM_Responsible_Design_Group__c
            opportunity.PLM_Project_Approval_Committee__c = projectApprovalCommittee;
            opportunity.PLM_Project_Category__c = projectCategory;
            opportunity.PLM_Project_Complexity__c = projectComplexity;
            opportunity.PLM_Project_Leverage__c = leverage;
            opportunity.PLM_Project_Template__c = projectTemplate;
            opportunity.PLM_Responsible_Design_Group__c = responsibleDesignGroup;
            opportunity.PLM_Created_By_Id__c = teNetworkId;
            //opportunity.Sales_Part_Forecast_Send_to_PLM__c = SalesPartForecastSendtoPLM;
        }
        try{
            upsert  opportunity;
            saved2Opportunity = true;
        }catch (Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, system.Label.Error_Saving + e.getMessage()));  
        }
    }
    
    //this is the call plm call out routine     
    public  void doCallout(){
        // call the realtime and raise errors as required 
        //JNV 10/17 - get config name here and pass to real_time_class            
            string prjPushConfigName;
            for(realtime_Callout_Settings__c rcs : realtime_Callout_Settings__c.getAll().values()) {
                if(rcs.Active__c == true ) {
                    if(rcs.Name == 'Prod PLM Project Push' || rcs.Name == 'QA PLM Project Push'){
                        prjPushConfigName = rcs.Name;  
                    }
                }       
            }
        string Oppid=opportunity.id;     
        string RTcallResult = real_time_call.callOrchestrationRealTime('PushOpptyToPLM', Oppid, prjPushConfigName);           
        //JNV 10/17 string RTcallResult = real_time_call.callOrchestrationTrafficCop('PushOpptyToPLM', Oppid);
        
        opportunity.Sent_to_PLM_Date__c = System.today();        
        
        //errors 
        if(RTcallResult == 'SFDC Org and End Point App has not been registered' || RTcallResult =='SFDC Org and End Point App has not been registered (sfdcOrg=C2S, endPointApp=PUSHOPPTYTOPLM)'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.ERROR_The_Project_was_NOT_sent_to_Program_Central_Due_to_a_TE_real_time_config )); //'ERROR: The Project was NOT sent to Program Central. Due to a TE real-time configuration Error' added by di chen 2012/11/21
        }
        if(RTcallResult == 'OK'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, system.label.SUCCESS_The_Project_WAS_sent_to_Program_Central)); //'SUCCESS: The Project WAS sent to Program Central.' added by di chen 2012/11/21
        }
        if(RTcallResult == 'Not Found'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.ERROR_The_Project_was_NOT_sent_to_Program_Central_Due_to_a_Cast_Iron_Dispatche )); //'ERROR: The Project was NOT sent to Program Central. Due to a Cast-Iron Dispatcher Error' added by di chen 2012/11/21
        }
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'DEBUG: return value = "'+RTcallResult+'"' )); //DEBUG
        upsert  opportunity;
    }
    
    
    
    /**
     * This method is used when click 'Cancel' on vf page,
     * this method to redirect to Opportunity page
     *   
     @author Yinfeng Guo
     @created 2012-04-05
     @version 1.0
     @since 23.0
     *
     @return         Opportunity page according to the  Opportunity id
     *
     @changelog
     * 2012-04-05 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */         
    public PageReference Cancel(){
        PageReference pageRef = new PageReference('/'+ opportunity.Id);
        pageRef.setRedirect( true );
        return pageRef;
    }   
    //********************************* -=END public methods=- ************************************
 

    //********************************* -=BEGIN private methods=- *********************************
    /**
     * This method is used to get 6 MaterData parameter from custom settings
     *   
     @author Yinfeng Guo
     @created 2012-04-06
     @version 1.0
     @since 23.0
     *
     @return         void
     *
     @changelog
     * 2012-04-06 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */ 
     //JNV 10/18 - comment out hard coded profit center derivation from industry
    /*private void MasterDataParameter(){
        if(Apex_Helper_Settings__c.getInstance('MasterData Parameter APL') != null) MASTERDATA_APL = Apex_Helper_Settings__c.getInstance('MasterData Parameter APL').Value__c;
        if(Apex_Helper_Settings__c.getInstance('MasterData Parameter CSD') != null) MASTERDATA_CSD = Apex_Helper_Settings__c.getInstance('MasterData Parameter CSD').Value__c;
        if(Apex_Helper_Settings__c.getInstance('MasterData Parameter DTC') != null) MASTERDATA_DTC = Apex_Helper_Settings__c.getInstance('MasterData Parameter DTC').Value__c;
        if(Apex_Helper_Settings__c.getInstance('MasterData Parameter IND') != null) MASTERDATA_IND = Apex_Helper_Settings__c.getInstance('MasterData Parameter IND').Value__c;
        if(Apex_Helper_Settings__c.getInstance('MasterData Parameter CBU') != null) MASTERDATA_CBU = Apex_Helper_Settings__c.getInstance('MasterData Parameter CBU').Value__c;
        if(Apex_Helper_Settings__c.getInstance('MasterData Parameter OTH') != null) MASTERDATA_OTH = Apex_Helper_Settings__c.getInstance('MasterData Parameter OTH').Value__c;
    }*/
    
    /**
     * This method is used to get 9 Industry Code from custom setting
     *   
     @author Yinfeng Guo
     @created 2012-04-06
     @version 1.0
     @since 23.0
     *
     @return         void
     *
     @changelog
     * 2012-04-06 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */
     //JNV 10/18 - comment out hard coded profit center derivation from industry     
    /*private void IndustryCode(){
        if(Apex_Helper_Settings__c.getInstance('Industry Code Appliances') != null) ACCOUNTINDUSTRYCODE_Appliances = Apex_Helper_Settings__c.getInstance('Industry Code Appliances').Value__c;
        if(Apex_Helper_Settings__c.getInstance('Industry Code Rail') != null) ACCOUNTINDUSTRYCODE_Rail = Apex_Helper_Settings__c.getInstance('Industry Code Rail').Value__c;
        if(Apex_Helper_Settings__c.getInstance('Industry Code MEFA') != null) ACCOUNTINDUSTRYCODE_MEFA = Apex_Helper_Settings__c.getInstance('Industry Code MEFA').Value__c;
        if(Apex_Helper_Settings__c.getInstance('Industry Code CBT') != null) ACCOUNTINDUSTRYCODE_CBT = Apex_Helper_Settings__c.getInstance('Industry Code CBT').Value__c;
        if(Apex_Helper_Settings__c.getInstance('Industry Code Solar') != null) ACCOUNTINDUSTRYCODE_Solar = Apex_Helper_Settings__c.getInstance('Industry Code Solar').Value__c;
        if(Apex_Helper_Settings__c.getInstance('Industry Code DataComm') != null) ACCOUNTINDUSTRYCODE_DataComm = Apex_Helper_Settings__c.getInstance('Industry Code DataComm').Value__c;
        if(Apex_Helper_Settings__c.getInstance('Industry Code Other') != null) ACCOUNTINDUSTRYCODE_Other = Apex_Helper_Settings__c.getInstance('Industry Code Other').Value__c;
        if(Apex_Helper_Settings__c.getInstance('Industry Code Consumer Devices') != null) ACCOUNTINDUSTRYCODE_ConsumerDevices = Apex_Helper_Settings__c.getInstance('Industry Code Consumer Devices').Value__c;
        if(Apex_Helper_Settings__c.getInstance('Industry Code Channel') != null) ACCOUNTINDUSTRYCODE_Channel = Apex_Helper_Settings__c.getInstance('Industry Code Channel').Value__c;
    }*/
    
        
    /**
     * This method is used to Get the PLM from the "EmployeeNumber" of User.   
     *
     @author Yinfeng Guo
     @created 2012-03-29
     @version 1.0
     @since 23.0
     *
     @return         void
     *
     @changelog
     * 2012-03-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */ 
    private void GetPLM(){
        plm = actualUser.TE_Network_Id__c + '||' + masterData;
    } 

    /**
     * This method is used to Get the MASTERDATA according to the value defined in Opportunity "Account_Industry__c" field.  
     *
     @author Yinfeng Guo
     @created 2012-03-29
     @version 1.0
     @since 23.0
     *
     @return         void
     *
     @changelog
     * 2012-03-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */ 
     
     //JNV 10/18 comment out after setting masterdata in constructor        
    /*private void GetMasterData(){
        
        if(accountIndustry == ACCOUNTINDUSTRYCODE_Rail || accountIndustry == ACCOUNTINDUSTRYCODE_MEFA || accountIndustry == ACCOUNTINDUSTRYCODE_CBT 
        || accountIndustry == ACCOUNTINDUSTRYCODE_Solar)                    masterData = MASTERDATA_IND; 
        else if(accountIndustry == ACCOUNTINDUSTRYCODE_Appliances)          masterData = MASTERDATA_APL;
        else if(accountIndustry == ACCOUNTINDUSTRYCODE_ConsumerDevices)     masterData = MASTERDATA_CSD;
        else if(accountIndustry == ACCOUNTINDUSTRYCODE_DataComm)            masterData = MASTERDATA_DTC;
        else if(accountIndustry == ACCOUNTINDUSTRYCODE_Other)               masterData = MASTERDATA_OTH;
        //else masterData = MASTERDATA_OTH;                                                                                                                                 
    } */


    /**
     * This method is used to call webservice for plm.   
     *
     @author Yinfeng Guo
     @created 2012-03-29
     @version 1.0
     @since 23.0
     *
     @return         void
     *
     @changelog
     * 2012-03-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    private void callPLMRealTime() { 
        try{ 
            endPointAppPlm = 'PLM';
            //JNV 10/5/2012 call realtime class here instead
            WSResponsePLM = real_time_call.callWSRealTime(endPointAppPlm, plm, configName) ;
            /* JNV 10/17
            TrafficCopWS.ProcessHandlerSoap mySoap = new TrafficCopWS.ProcessHandlerSoap();
            mySoap.endpoint_x =       serviceEndpoint;
            mySoap.clientCertName_x = certName;      
            WSResponsePLM =              mySoap.ProcessRequest(orgName, sfdcUsername, endPointAppPlm, plm);   */
        }
        catch(exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, system.label.Call_web_service_error));  //'Call web service error!' added by di chen 2012/11/21
            WSResponsePLM = e.getMessage();
        } 
    }
    /**
     * This method is used to call webservice for masterdata.   
     *
     @author Yinfeng Guo
     @created 2012-03-29
     @version 1.0
     @since 23.0
     *
     @return         void
     *
     @changelog
     * 2012-03-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    private void callMASTERDATARealTime() { 
        try{   
            endPointAppMasterData = 'MASTERDATA';
            //JNV 10/5/2012 call realtime class here instead
            WSResponseMASTERDATA = real_time_call.callWSRealTime(endPointAppMasterData, masterData, configName);
        }
        catch(exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, system.label.Call_web_service_error)); //'Call web service error!'added by di chen 2012/11/21
            WSResponseMASTERDATA = e.getMessage();
        } 
    }   
    

    /**
     * This method is used to extract the result of  call PLM webservice   
     *
     @author Yinfeng Guo
     @created 2012-03-29
     @version 1.0
     @since 23.0
     *
     @return         void
     *
     @changelog
     * 2012-03-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */ 
    private void ExtractPLMResponse() { 
        //WSResponsePLM;
        try{
            XmlStreamReader reader = new XmlStreamReader(WSResponsePLM);       
            parsePLMResponse(reader);        
        }
        catch (Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, system.label.The_PLM_values_return_from_web_service_are_invalid_Web_Service_PLM_Response_Val  + WSResponsePLM));//'The PLM values return from web service are invalid. Web Service PLM Response Value: ' added by di chen 2012/11/21
            responseError = true;
            return; 
        }
    }
    /**
     * This method is used to extract the result of  call MasterData webservice
     *
     @author Yinfeng Guo
     @created 2012-03-29
     @version 1.0
     @since 23.0
     *
     @return         void
     *
     @changelog
     * 2012-03-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    private void ExtractMasterDataResponse() { 
        //WSResponseMASTERDATA;
        try {
            XmlStreamReader reader = new XmlStreamReader(WSResponseMASTERDATA);
            parseMasterDataResponse(reader);
            /*if(reader.isStartElement()) {
                parseMasterDataResponse(reader);
                responseError = false;
            } */
        }
        catch (Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, system.label.The_Master_value_return_from_web_service_are_invalid_Web_Service_MASTERDATA_Res + WSResponseMASTERDATA));//'The Master value return from web service are invalid. Web Service MASTERDATA Response Value: ' added by di chen 2012/11/21
            responseError = true;
            return; 
        }
    }

    /**
     * This method is used to parse element for single specific tag   
     *
     @author Yinfeng Guo
     @created 2012-03-29
     @version 1.0
     @since 23.0
     *
     @param reader                  a xml single tag
     *
     @return         void
     *
     @changelog
     * 2012-03-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */ 
    private SelectOption parseSingleTag(XmlStreamReader reader) {
       return null;//added by di chen
    }   

    private SelectOption parseSingleTagWithId(XmlStreamReader reader) {
        String label;
        String value;
        label = reader.getAttributeValue(null, 'displayvalue');
        
        if(label.contains('-') && label.split('-').size() > 1)        
        {            
            label = label.split('-')[1];         
        }        
        
        value = reader.getAttributeValue(null, 'id');   
        SelectOption option = new SelectOption(value,label);
        return option;
    }
    
    private SelectOption parseSingleTagWithName(XmlStreamReader reader) {
        String label;
        String value;
        label = reader.getAttributeValue(null, 'displayvalue');
        value = reader.getAttributeValue(null, 'name'); 
        SelectOption option = new SelectOption(value,label);
        return option;
    }
    
    private SelectOption parseSingleTagWithShortName(XmlStreamReader reader) {
        String label;
        String value;
        label = reader.getAttributeValue(null, 'displayvalue');
        value = reader.getAttributeValue(null, 'shortname');    
        SelectOption option = new SelectOption(value,label);
        return option;
    }       
    /**
     * This method is used to parse plm webservice response xml   
     *
     @author Yinfeng Guo
     @created 2012-03-29
     @version 1.0
     @since 23.0
     *
     @param reader                  a whole xml from the  WSResponsePLM
     *
     @return         void
     *
     @changelog
     * 2012-03-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */         
    //<ProjectTemplateList>,<RDGList>
    private void parsePLMResponse(XmlStreamReader reader) {
        List<SelectOption> optionTemplate = new List<SelectOption>();
        List<SelectOption> optionRDG = new List<SelectOption>();
        //System.debug('<--VREADER IS--->' + reader);
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.START_ELEMENT) {            
                if ('ProjectTemplateElement' == reader.getLocalName()) {//ProjectTemplateElement: displayvalue, name, id, complexity
                    optionTemplate.add( parseSingleTagWithId(reader) );
                }
                else if ('RDGElement' == reader.getLocalName()) {//RDGElement: displayvalue, name, description, id
                    optionRDG.add( parseSingleTagWithId(reader) );
                }
                
            }
            reader.next();          
        }
        map_name_picklist.put(list_fieldName[0], optionTemplate); 
        map_name_picklist.put(list_fieldName[1], optionRDG);    
    }

    
    /**
     * This method is used to parse masterdata webservice response xml   
     *
     @author Yinfeng Guo
     @created 2012-03-29
     @version 1.0
     @since 23.0
     *
     @param reader                  a whole xml from the  WSResponseMASTERDATA
     *
     @return         void
     *
     @changelog
     * 2012-03-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */             
    //<ProjectCategoriesList>,<LeveragesList>,<ProjectComplexitiesList>,<PACList>
    private void parseMasterDataResponse(XmlStreamReader reader) {
        List<SelectOption> optionLeverage = new List<SelectOption>(); 
        List<SelectOption> optionCategory = new List<SelectOption>();
        List<SelectOption> optionComplexity = new List<SelectOption>();
        List<SelectOption> optionPAC = new List<SelectOption>();
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                if ('ProjectCategoryElement' == reader.getLocalName()) {//ProjectCategoryElement: displayvalue, code, name
                    optionCategory.add( parseSingleTagWithName(reader) );
                }
                else if('LeverageElement' == reader.getLocalName()){//LeverageElement: displayvalue, code, name
                    optionLeverage.add( parseSingleTagWithName(reader) );
                }
                else if('ProjectComplexityElement' == reader.getLocalName()){//ProjectComplexityElement: displayvalue, code, name
                    optionComplexity.add( parseSingleTagWithName(reader) );
                }
                else if('PACElement' == reader.getLocalName()){//PACElement: displayvalue,shortname
                    optionPAC.add( parseSingleTagWithShortName(reader) );
                }
            }
            reader.next();          
        }
        map_name_picklist.put(list_fieldName[2], optionLeverage);
        map_name_picklist.put(list_fieldName[3], optionCategory);
        map_name_picklist.put(list_fieldName[4], optionComplexity); 
        map_name_picklist.put(list_fieldName[5], optionPAC);     
    }

    
      
    /**
     * This method is used to get Fiels's Name
     *
     @author Yinfeng Guo
     @created 2012-03-20
     @version 1.0
     @since 23.0
     *
     @return         void
     *
     @changelog
     * 2012-03-20 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    private void GetFieldName(){
        list_fieldName = new list<String>();

        list_fieldName.add(projectTemplateLabel);
        list_fieldName.add(responsibleDesignGroupLabel);
        list_fieldName.add(leverageLabel);
        list_fieldName.add(projectCategoryLabel);
        list_fieldName.add(projectComplexityLabel);
        list_fieldName.add(projectApprovalCommitteeLabel);
    }





            
    /**
     * This method is used to invoke external webservice method
     *
     @author Yinfeng Guo
     @created 2012-03-20
     @version 1.0
     @since 23.0
     *
     @return         void
     *
     @changelog
     * 2012-03-20 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
   // private void GetPicklistValuesByWebservice(){
        //map_name_picklist = new map<string, list<selectOption>>();
        /*
        List<SelectOption> optionTemplate = new List<SelectOption>();
        optionTemplate.add(new SelectOption('GES Asia TEST', 'GES Asia TEST'));
        optionTemplate.add(new SelectOption('GES Asia TESTJapan', 'GES Asia TESTJapan'));
        optionTemplate.add(new SelectOption('GES EMEA TEST', 'GES EMEA TEST'));
        optionTemplate.add(new SelectOption('GES LEANPD NPD Template', 'GES LEANPD NPD Template'));
        optionTemplate.add(new SelectOption('GES Software Release', 'GES Software Release'));
        optionTemplate.add(new SelectOption('Test Template_SZ', 'Test Template_SZ'));
        optionTemplate.add(new SelectOption('Test Template', 'Test Template'));
        optionTemplate.add(new SelectOption('PC_Clone Of GES Asia TESTJapan', 'PC_Clone Of GES Asia TESTJapan'));
        optionTemplate.add(new SelectOption('TE LEANPD NPD Template', 'TE LEANPD NPD Template'));
        optionTemplate.add(new SelectOption('Practice Template DO NOT use', 'Practice Template DO NOT use'));
        optionTemplate.add(new SelectOption('ProjectTemplate-Owner Test Change', 'ProjectTemplate-Owner Test Change'));
        optionTemplate.add(new SelectOption('Touch Solutions LEANPD Template', 'Touch Solutions LEANPD Template'));
        optionTemplate.add(new SelectOption('TOSP LEANPD NPD Template', 'TOSP LEANPD NPD Template'));
        
        map_name_picklist.put(list_fieldName[0], optionTemplate);
        */
        /*
        List<SelectOption> optionRDG = new List<SelectOption>();
        optionRDG.add(new SelectOption('046', '046-Outside Plant/Telecom'));
        optionRDG.add(new SelectOption('110', '110-TOSP NA'));
        optionRDG.add(new SelectOption('111', '111-TOSP EMEA'));
        optionRDG.add(new SelectOption('112', '112-TOSP Shanghai'));
        optionRDG.add(new SelectOption('122', '122-TENW TOSP'));
        optionRDG.add(new SelectOption('113', '113-ELOTOUCH'));
        optionRDG.add(new SelectOption('114', '114-Elo Custom Systems'));
        optionRDG.add(new SelectOption('115', '115-Elo Japan'));
        optionRDG.add(new SelectOption('116', '116-Elo CT'));
        optionRDG.add(new SelectOption('117', '117-Elo Argentina'));
        optionRDG.add(new SelectOption('118', '118-Elo Europe'));
        optionRDG.add(new SelectOption('121', '121-Elo Core Systems'));
        optionRDG.add(new SelectOption('162', '162-Global Engineering Systems'));
        optionRDG.add(new SelectOption('211', '211-GES Americas'));
        optionRDG.add(new SelectOption('212', '212-GES EMEA'));
        optionRDG.add(new SelectOption('213', '213-GES A/P'));
        optionRDG.add(new SelectOption('214', '214-Elo Technologies'));
        
        map_name_picklist.put(list_fieldName[1], optionRDG);
        */
        /*
        List<SelectOption> optionLeverage = new List<SelectOption>();
        optionLeverage.add(new SelectOption('0', '0-Platform'));
        optionLeverage.add(new SelectOption('1', '1-Derivative'));
        optionLeverage.add(new SelectOption('2', '2-Customer Special'));
        
        map_name_picklist.put(list_fieldName[2], optionLeverage);
        
        */
        /*
        List<SelectOption> optionCategory = new List<SelectOption>();
        optionCategory.add(new SelectOption('0', '0-New Product Development'));
        optionCategory.add(new SelectOption('1', '1-Sustaining'));
                
        map_name_picklist.put(list_fieldName[3], optionCategory);
        */
        /*
        List<SelectOption> optionComplexity = new List<SelectOption>();
        optionComplexity.add(new SelectOption('0', '0-Type 0'));
        optionComplexity.add(new SelectOption('1', '1-Type I'));
        optionComplexity.add(new SelectOption('2', '2-Type II'));
        
        map_name_picklist.put(list_fieldName[4], optionComplexity);
        */
        /*
        List<SelectOption> optionPAC = new List<SelectOption>();
        optionPAC.add(new SelectOption('CIS COMMBLDG', 'CIS COMMBLDG'));
        optionPAC.add(new SelectOption('CIS MEFA', 'CIS MEFA'));
        optionPAC.add(new SelectOption('CIS RAIL', 'CIS RAIL'));
        optionPAC.add(new SelectOption('CIS ADV IND', 'CIS ADV IND'));
        
        map_name_picklist.put(list_fieldName[5], optionPAC);
        */
        
        /*
        namespace.GetPicklistvalue selects = new namespace.GetPicklistvalue();
        selects.LicenseInfo = new strikeiron.LicenseInfo();
        selects.LicenseInfo.RegisteredUser = new strikeiron.RegisteredUser();
        selects.LicenseInfo.RegisteredUser.UserID = 'you@company.com';
        selects.LicenseInfo.RegisteredUser.Password = 'your-password';
        namespace.GetPicklistvalue result = selects.GetValue('Pick list field value'); 
        */
    //}
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>WrapperClass*/
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
    
}