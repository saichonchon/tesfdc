/**
 *  This class used for managing Opportunity_Part__c and Part__c
 *
 @author Yinfeng Guo
 @created 2012-02-29
 @version 1.0
 @since 27.0 (Force.com ApiVersion)
 *
 @changelog
 * 2013-05-08 Bin Yuan <bin.yuan@itbconsult.com>
 * - assign Confidence and process status for new added parts
 * 2013-04-17 Bin Yu <bin.yu@itbconsult.com>
 * - rewrite the logic to get rid of the issue about meet the viewstate-limit 
 * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
 * - Created
 * 2012-03-28 Yinfeng Guo <yinfeng.guo@itbconsult.com>
 * - Modified : don't have to retrieve product Owning GIBU in the controller class, comment it out
 * 2012-04-11 Yinfeng Guo <yinfeng.guo@itbconsult.com>
 * - Modified : Remove Methods and Variables to static resources "Rubbish_or_Garbage", these code are that used befoe, not use now, may be need in the future
 * 2014-03-24 Michael Cui 
 * - Modified: hidden Proposal Parts when CSD create sales oppty.
 * 2015-05-25 Padmaja Dadi 
 * - Modified: hidden Sales parts fields when DND creates DND oppty.
 * 2015-06-22 Mrunal Parate 
 *-  Modified: Added Channel Sales Opportunity record type For MINI SPIN project
 * 2016-10-26 Mrunal Parate 
 *-  Modified: For CCR Project:Make NDR Code generic for CCR. Move NDR record type reference from Apex_Helper_Settings__c to 'Opportunity Record type group' custom setting and create new record for CCR record type  in 'Opportunity record type group' custom setting
 *-2017-11-07 Poonam Hedaoo
*-Modified: To check closed date is in current Fiscal Year or not if not the show error message, it will work only for DND Opportunities
*/
 
public with sharing class ExtOpportunityPartEntry {

    //==============================================================================================================================================
    //=================================/*   -=BEGIN  Code Block for Common use                            */========================================
    //=================================/*   This Block contains variables and methods used for Common use */========================================
    //==============================================================================================================================================

    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    /** true if NDR opportunity is incomplete, false otherwise**/
    public Boolean isIncompleteNDROppty {get;set;}      
    
    /**
     * the amount of the proposal part will be added
     */     
    public String addAmount{ set; get; }
    
    //public String targetPartId { set; get; }
    
    /**
     * the mode to tell us whether new or edit
     */ 
    public String mode { set; get; }
    
    /**
     * the object Opportunity_Part__c variable
     */ 
    public Opportunity_Part__c oppPart { set; get; }
    
    //public Id detailPartId { set; get; } 
    
    /**
     * this variable to tell us whether have saved
     */ 
    public Boolean isSaved { set; get;}
    
    public Boolean isValidEnter {set; get;}
    
    public Boolean delPermission{get;set;}

    //public Boolean isSales{ set; get; }
    
    /**
     * opportunity can limit to only can be added sales part
     * if isOnlySales is true, then we can not add proposal part
     */ 
    public Boolean isOnlySales{ set; get; }
    /**
     * this variable to tell us whether have saved
     */
    public boolean isDND {get;private set;}
    /**
     * this variable to tell us sales parts related fields hidden or nor for DND profiles
     */ 
     
     //Variable to check if ADM Opportunities are used.
     public boolean isADM {get;private set;}
     //Variable to check if ADM Opportunities are used.
     
    public Boolean isSaveComplete{ set; get; }
    
    /**
     * this variable to tell us whether the message on the result blocksection should display
     * if messageOnResult is false, then the message on result blocksection will not show
     */ 
    public Boolean messageOnResult{ set; get; }
     
    /**
     * this id string contains the part id that will be added to the sales part list
     */ 
    public String changePartId{set;get;}
    public String idString{set;get;} 
    public Integer selectedIndex {set;get;} 
    public Boolean validOpportunity {get; set;}
    //Variable mean : the index will delete Opportunity_Part__c
    public Integer deleteOpportunityPartIndex {get; set;} 
    //sorting for part list
    public String oppPartListSortField {get; set;}  
    public String oppPartListSortFieldPrev {get; set;}   
    
    //Variable mean : the total data select from the database
    //public List<Opportunity_Part__c> list_opportunityParts {get; set;}  
    //public List<Opportunity_Part__c> list_savedOppParts {get; set;}
    
    //Variable mean : the index will delete Opportunity_Part__c
    public Integer deleteOpportunityPartIndexProposal {get; set;} 
    //sorting for part list
    public String oppPartListSortFieldProposal {get; set;}  
    public String oppPartListSortFieldPrevProposal {get; set;}    

    //Variable mean : the total data select from the database
    //public List<Opportunity_Part__c> list_opportunityPartsProposal {get; set;}  
    //public List<Opportunity_Part__c> list_savedOppPartsProposal {get; set;}
    //Variable mean : transfer common opportunity part list to list have specific index
    public List<OpportunityPartWrapper> list_indexOpportunityParts {get; set;}
    public List<OpportunityPartWrapper> list_indexOpportunityPartsProposal {get; set;}
    public boolean isAdmin {get;private set;}
    
    //added by xia 2013-04-09 China process -- start
    public boolean isChina{get;private set;}
    //private static final string CHINA_REGION = 'China / HK / Taiwan';
    //added by xia 2013-04-09 China process -- end
    //Start by bin yuan due to add display fields
    public boolean isAPPL {get; set;}
       //end bin yuan
    public set<Id> set_oppyRecordTypeId = new set<Id>();// Added by Mrunal for case 00900348
    public boolean isChnl {get;set;} // Added by Mrunal for case 00900348
    public boolean noCloseDateError {get;set;} // Added by Poonam for case 00901402
    public Boolean showCloseDateError ;// Added by Poonam for case 00901402
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private map<Id,String> map_partId_similartPartName;
    private map<Id,String> map_partId_partName;
    private map<Id,String> map_partId_gplName;
    private map<Id,String> map_gplId_gplName;
    private boolean isSPIN = false;
    private set<Id> set_rtIds = new set<Id>();
    /**
     * the opportunity id
     */ 
    private id opportunityId; 
    public Opportunity opp{get;set;}
    set<Id> ADMRecType;
    /**
     * this variable have the value for field Request_Type__c
     */   
    private String requestType;
    
    /**
     * the currency iso code of opportunity
     */
    private String oppyCurrencyIsoCode;//add CurrencyIsoCode
    private static final String REQUESTTYPE_CA = 'Cable Assembly';
    private static final String REQUESTTYPE_ND = 'New Development';
    public static final String REQUESTTYPE_E = 'Extension';
    private static final String REQUESTTYPE_SO = 'Sales Only';
    private final ApexPages.standardController stdCtrl;     
    private map<String, String> map_urlParams;
    //Start by bin yuan due to apply bu check
    private map<String, String> map_BU_Appliances = new Map<String, String>{
        'Appliances' => 'Appliances',
        'EMS' => 'Appliances','Consumer Devices' => 'Consumer Devices'
    };
    //End
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
   /**
    * The contsructor
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @changelog
    * 2012-02-29 YinFeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */      
    public ExtOpportunityPartEntry(ApexPages.standardController stdCtrl) {
        this.stdCtrl = stdCtrl;    
        opp=new Opportunity();
        isValidEnter = true;
        idString = '';
        isSaved = true;
        isOnlySales = false;
        isSaveComplete = false;
        messageOnResult = false;
        validOpportunity = true;  
        noCloseDateError= true;  
        showCloseDateError =false;      
        this.isIncompleteNDROppty = false;        
        mode = '';
        addAmount = '1';
        oppyCurrencyIsoCode = 'USD';
        //list_opportunityParts = new List<Opportunity_Part__c>();    
        //list_opportunityPartsProposal = new List<Opportunity_Part__c>();
        list_indexOpportunityParts = new List<OpportunityPartWrapper>();
        list_indexOpportunityPartsProposal = new List<OpportunityPartWrapper>();
        map_urlParams = ApexPages.currentPage().getParameters();
        ADMRecType = new set<Id>();
        //check if system admin;
        isAdmin = false;
        if(Apex_Helper_Settings__c.getInstance('System Administrator') != null && Apex_Helper_Settings__c.getInstance('System Administrator').Active__c && Apex_Helper_Settings__c.getInstance('System Administrator').value__c != null){
            String adminIds = Apex_Helper_Settings__c.getInstance('System Administrator').value__c;
            for(Id adminId :adminIds.split(',')){
                if(adminId == UserInfo.getProfileId()){
                    isAdmin = true;
                    break;
                }
            }
        }
        
        if(map_urlParams.containsKey('oppyId')) {
            opportunityId = map_urlParams.get('oppyId');
        }   
        try{
            oppPart = (Opportunity_Part__c)stdCtrl.getRecord();
            if(oppPart.Id != null){
                mode = 'edit';
                opportunityId = [Select Id, Opportunity__c from Opportunity_Part__c where Id =: oppPart.Id].Opportunity__c;
            }
            else if(oppPart.Opportunity__c != null){
                mode = 'new';
                opportunityId = oppPart.Opportunity__c;
            }

            opp = ClsOppyPartUtil.getOpportunityById(opportunityId);
            
            //Case 901168 changes starts here
            
                       
             delPermission=[SELECT  PermissionsDelete FROM ObjectPermissions WHERE SobjectType = 'opportunity_part__c' and parentid in (select id from permissionset where PermissionSet.Profile.id= :Userinfo.getProfileId())].PermissionsDelete;                                  
             system.debug('######delPermission'+delPermission);
         
            //case 901168 changes ends here.

            // Start by bin yuan due to apply bu check
            isAPPL = false;
          if(map_BU_Appliances.containsKey(opp.Industry_Code__c) && (opp.Owner.GIBU__c == 'Appliances' || opp.Owner.GIBU__c == 'Consumer Devices'))
             isAPPL = true;
             //End
            if(opp.StageName == 'In Approval') {
                validOpportunity = false;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Oppy_InApproval_Check));
            }
            else if(opp.StageName == 'Rejected - Closed'){
                validOpportunity = false;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Oppy_RejectedClosed_Check));
            }
            else{
                // when user is an appliance user and the opportunity has no assigned competitor
                String profileName;
                for(Profile p :[select name from Profile where id = :UserInfo.getProfileId()]){
                    profileName = p.name;
                }
                if(opp.Competitor_Count__c == 0 && (profileName == 'Appliance Engineering User w/Cost' || profileName == 'Appliance Standard User' || profileName == 'Appliance User w/ Cost' || profileName == 'Appliance Inside Sales Playbook User' )){
                    validOpportunity = false;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Oppy_Appliance_Check));
                }   
                
            }
            // Added by Padmaja Dadi for DND Manageparts  5/25/2015
            Id actualUserProfileId = UserInfo.getProfileId();
            Apex_Helper_Settings__c DNDProfiles = Apex_Helper_Settings__c.getInstance('DND Project Profile List');
            //set<ID> DNDProfileset = new set<ID>();
            isDND = false;
            isADM = false;
            for (string strProfielID :DNDProfiles.value__c.split(','))
            {
                try
                {
                    if(actualUserProfileId == (id)strProfielID)
                    {
                        isDND = true;
                        break;
                    }
                }catch(exception ex){}
            }
           
            // Added by Prabhanjan ADM Migration
      for(Opportunity_Record_Type_Groups__c rt : Opportunity_Record_Type_Groups__c.getall().values()){
               if(rt.Active__c && rt.Group__c == 'ADM Group' && rt.RecordTypeID__c!= null)
                            ADMRecType.add(rt.RecordTypeID__c);
              }    
          if(ADMRecType.contains(opp.RecordType.Id)){ isADM = true; }
              
           
            //added by Rahul goyal for ADM opportunities...
            //added by xia 2013-04-09 China process -- start
            isChina = false;
            if(ClsOppyPartUtil.set_chinaIndustry.contains(opp.Account.Customer_Industry__c) &&  opp.Account.Customer_Region__c == ClsOppyPartUtil.CHINA_REGION){
                isChina = true; 
            }
            system.debug('tongxia isChina:' + isChina);
            
            //added by xia 2013-04-09 China process -- end
            getOpportunityParts();
            nbrProposalParts = 1;
            if(opportunityId != null){
                requestType = [SELECT Id, RecordTypeId, Request_Type__c FROM Opportunity where Id =: opportunityId].Request_Type__c;
                for(Opportunity o : [SELECT Id, RecordTypeId, RecordType.DeveloperName, Request_Type__c, CurrencyIsoCode FROM Opportunity where Id =: opportunityId]){//add CurrencyIsoCode
                     requestType = o.Request_Type__c;
                     oppyCurrencyIsoCode = o.CurrencyIsoCode;
                     //03-24-2014 Michael Cui: Updated for Case 00658796  
                     //if( o.RecordTypeId == SalesOnlyRecordTypeId()) isOnlySales = true;
                     if(SalesOnlyRecordTypeId().contains(o.RecordTypeId)) isOnlySales = true;
                     // added by Jinbo Shan at 2014-04-14  According to custom setting show Propesol Part Button or not
                     if(Opportunity_Record_Type_Groups__c.getInstance(o.RecordType.DeveloperName) != null && Opportunity_Record_Type_Groups__c.getInstance(o.RecordType.DeveloperName).Is_Sales_Only__c) isOnlySales = true;
                }
            }
            
            //set saved list of opp parts to list retrieved from db on load
            //list_savedOppParts = new List<Opportunity_Part__c>(list_opportunityParts);
            //list_savedOppPartsProposal = new List<Opportunity_Part__c>(list_opportunityPartsProposal);
                        
            //set table page sizes and result limit
            OrgWideSettings__c settingsObj;
            settingsObj = OrgWideSettings__c.getValues('Manage Part');
            
            if(settingsObj != null){  
                oppPartListPageSize = Integer.valueOf(settingsObj.Datatable_Page_Size__c);
                //searchResultsPageSize = Integer.valueOf(settingsObj.Datatable_Page_Size__c);
                //resultLimit = Integer.valueOf(settingsObj.Search_Result_Limit__c);
                
                oppPartListPageSizeProposal = Integer.valueOf(settingsObj.Datatable_Page_Size__c);
            }
            else{
                oppPartListPageSize = 6;
                //searchResultsPageSize = 6;
                //resultLimit = 1000;
                oppPartListPageSizeProposal = 6;
            }
            
            oppPartListJumpToPage = oppPartListPageNumber;
            //searchResultsJumpToPage = searchResultsPageNumber;
            oppPartListJumpToPageProposal = oppPartListPageNumberProposal;
                        
            returnAfterSave = false;
            
            /** For NDR opportunity
            1. If the opportunity is of type NDR and is not complete
            2. Add page message to the page.                          
            **/ 
            //Change Start by Mrunal for CCR Project
            //if(opp.RecordTypeId == NDROpptyRecordTypeId() && !OpptyNDRForecastUtil.isOpportunityComplete(opp.NDR_Quote_Status_Description__c)){
            Set<Id> rt_id = NDROpptyRecordTypeId();
            if(rt_id.contains(opp.RecordTypeId) && !OpptyNDRForecastUtil.isOpportunityComplete(opp.NDR_Quote_Status_Description__c)){
            //Change End by Mrunal for CCR Project
                this.isIncompleteNDROppty = true;               
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.label.NDROpptyInCompleteError));
            }         
            //Added by bin yuan to check if a spin oppy
            isSPIN = false;
            set_rtIds = ClsPMV_Util.getAllPMVRecordtypes(); 
            if(set_rtIds.contains(opp.RecordTypeId)) {
                isSPIN = true;
            }
            // Change Start: Added by Mrunal for case 00900348
            isChnl = false; 
            List<Opportunity_Record_Type_Groups__c> cusSet = Opportunity_Record_Type_Groups__c.getall().values();
                for (Opportunity_Record_Type_Groups__c rt : cusSet){
                    if(rt.Active__c && rt.Group__c == 'Set Default Part Confidence' && rt.RecordTypeID__c!= null)
                        set_oppyRecordTypeId.add(rt.RecordTypeID__c);
                        }
            if(set_oppyRecordTypeId.contains(opp.RecordTypeId)) isChnl = true; 
            // Change End: For case 00900348
            
        }
        catch (Exception e){
            if(opportunityId == null) ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Enter_Page_Wrong  ));  
            else ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Error_Loading_Page + e.getMessage()));  
            validOpportunity = false;  
        }       
    }
    
    /** Returns record type id for NDR opportunity **/
    public static set<Id> NDROpptyRecordTypeId(){
        //Chnage start by Mrunal for CCR Project
        //Id rt_id;
        //if(Apex_Helper_Settings__c.getInstance('NDR Opportunity') != null) rt_id = Apex_Helper_Settings__c.getInstance('NDR Opportunity').Value__c;
        Set<Id> rt_id = new Set<Id>();

        for (Opportunity_Record_Type_Groups__c rt : Opportunity_Record_Type_Groups__c.getall().values()){
            if(rt.Active__c && rt.Group__c == 'RFQ 2.0 Quotes' && rt.RecordTypeID__c!= null)
                rt_id.add(rt.RecordTypeID__c);
        }
        return rt_id;
        //Chnage End by Mrunal for CCR Project
    }    
    //added by bin yuan
    public static list<SelectOption> getSampleTypes(){
        list<SelectOption> list_sampleTypeOption = new list<SelectOption>();
        list_sampleTypeOption.add(new SelectOption('', '--None--'));
        Schema.DescribeFieldResult F = Opportunity_Part__c.Sample_Type__c.getDescribe();
        for(Schema.PicklistEntry value : F.getPicklistValues()) {
            if(value.isActive()) {
                SelectOption option = new SelectOption(value.getValue(), value.getLabel());
                list_sampleTypeOption.add(option);
            }
        }
        return list_sampleTypeOption;
    }
    
    
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////

    //********************************* -=BEGIN public methods=- **********************************
    /**
     * This method is used to get select list for the amount the user want to add proposal part
     *
     @author Yin Feng
     @created 2012-03-13
     @version 1.0
     @since 23.0
     *
     @return            the return Amounts option list
     *
     @changelog
     * 2012-01-31 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */ 
    public List<SelectOption> getAmounts() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1', '1'));
        options.add(new SelectOption('2', '2'));
        options.add(new SelectOption('3', '3'));
        options.add(new SelectOption('4', '4'));
        options.add(new SelectOption('5', '5'));
        options.add(new SelectOption('6', '6'));
        options.add(new SelectOption('7', '7'));
        options.add(new SelectOption('8', '8'));
        options.add(new SelectOption('9', '9'));
        options.add(new SelectOption('10', '10'));
        return options;
    }

   /**
    * This method is used to get the sales part id from custom setting
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return             proposal part id
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */ 
   /* public static Id SalesOnlyRecordTypeId(){
        Id rt_id;
        if(Apex_Helper_Settings__c.getInstance('Sales Parts Only') != null) rt_id = Apex_Helper_Settings__c.getInstance('Sales Parts Only').Value__c;
        return rt_id;
    }*/
    //03-24-2014 Michael Cui: Updated for Case 00658796
    public static set<Id> SalesOnlyRecordTypeId(){
        Set<Id> rt_id = new Set<Id>();
        if(Apex_Helper_Settings__c.getInstance('Sales Parts Only') != null)           
            rt_id.add(Apex_Helper_Settings__c.getInstance('Sales Parts Only').Value__c); 
        if( Apex_Helper_Settings__c.getInstance('Sales Opportunity CSD') != null)
            rt_id.add(Apex_Helper_Settings__c.getInstance('Sales Opportunity CSD').Value__c);
        if( Apex_Helper_Settings__c.getInstance('Sales Opportunity Channel') != null)// Added by Mrunal For MINI SPIN project
            rt_id.add(Apex_Helper_Settings__c.getInstance('Sales Opportunity Channel').Value__c);// Added by Mrunal For MINI SPIN project
            
        return rt_id;
    }

    
   /**
    * This method is used to get the proposal part id from custom setting
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return             proposal part id
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */ 
    public static Id proposalPartId(){
        Id rt_id;
        if(Apex_Helper_Settings__c.getInstance('Proposal Part Template Id') != null) rt_id = Apex_Helper_Settings__c.getInstance('Proposal Part Template Id').Value__c;
        return rt_id;
    }

   /**
    * This method is used to get the opportunity part record type id from custom setting
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param mode         the string to decide which record type id to get from custom setting
    @return             opportunity record type id
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */  
    public static Id oppRTId(String mode){
        Id oppId;
        if(mode == 'cap'){
            if(Apex_Helper_Settings__c.getInstance('Cable Asssembly Part RT Id') != null) oppId = Apex_Helper_Settings__c.getInstance('Cable Asssembly Part RT Id').Value__c;
        }
        else if(mode == 'sp'){
            if(Apex_Helper_Settings__c.getInstance('Sales Parts RT Id') != null) oppId = Apex_Helper_Settings__c.getInstance('Sales Parts RT Id').Value__c;
        }
        else if(mode == 'nd'){
            if(Apex_Helper_Settings__c.getInstance('New Development RT Id') != null) oppId = Apex_Helper_Settings__c.getInstance('New Development RT Id').Value__c;
        }
        else if(mode == 'e'){
            if(Apex_Helper_Settings__c.getInstance('Extension RT Id') != null) oppId = Apex_Helper_Settings__c.getInstance('Extension RT Id').Value__c;
        }
        return oppId;
    }   

    /**
     * This method is used to save Opportunity Parts on the page
     *   
     @author Yinfeng Guo
     @created 2012-02-29
     @version 1.0
     @since 23.0
     *
     @return         null
     *
     @changelog
     * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    public PageReference SaveOpportunityParts() {
        Savepoint sp = Database.setSavepoint();           
        List<Opportunity_Part__c> list_oppParts2Delete = new List<Opportunity_Part__c>();
        list<Opportunity_Part__c> list_oppSalesParts2Upsert = new list<Opportunity_Part__c>();
        list<Opportunity_Part__c> list_oppProposalParts2Upsert = new list<Opportunity_Part__c>();
        system.debug('list_indexOpportunityPartsProposal : ' + list_indexOpportunityPartsProposal);
        Map<Id, Opportunity_Part__c> map_id_oppParts = new Map<Id, Opportunity_Part__c>();  
        String srId = oppRTId('sp');  
        set<Date> set_closeDate=new set<Date>();
        map<Id, Id> map_partId_gplId = new map<Id, Id>();//added by yinfeng.guo 2012-08-20  
        set<Id> set_partId = new set<Id>();//added by yinfeng.guo 2012-08-20  
        for(OpportunityPartWrapper opw : list_indexOpportunityParts){
            Opportunity_Part__c op = opw.opportunityPart;        
            if(op.Id != null){
                map_id_oppParts.put(op.Id, op);         
                set_partId.add(op.Part__c); //added by yinfeng.guo 2012-08-20       
            }
            list_oppSalesParts2Upsert.add(op);
        }
        //Begin : added by yinfeng.guo 2012-08-20  
        for(Part__c op : [SELECT Product_Hierarchy__c, Id FROM Part__c where Id in: set_partId]){
            map_partId_gplId.put(op.Id, op.Product_Hierarchy__c);
        }

        for(OpportunityPartWrapper opw : list_indexOpportunityParts){
            Opportunity_Part__c op = opw.opportunityPart;        
            if(op.Part__c == null){
                // Part__c can't be null in sales project added by min
                if(isOnlySales){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  system.Label.Part_Number_Required)); 
                    return null;
                }                   
                op.Part_Number__c = null;
                if(op.cable_assembly_type__c == null) op.cable_assembly_type__c = 'Fiber Optic';
                if(requestType.startsWith(REQUESTTYPE_CA)){
                    op.RecordTypeId = oppRTId('cap');
                }
                else if(requestType.contains(REQUESTTYPE_ND) || requestType == null){
                    op.RecordTypeId = oppRTId('nd');
                }
                else if(requestType.contains(REQUESTTYPE_E)){
                    op.RecordTypeId = oppRTId('e');
                }
            }
            else if(map_partId_gplId.containsKey(op.Part__c)) op.GPL__c = map_partId_gplId.get(op.Part__c);             
            set_closeDate.add(op.Initial_Order_Date__c);
        }
        //End : added by yinfeng.guo 2012-08-20  
        
        //check if saved list of parts contains any id's not on current list of opportunity parts            
        for(Opportunity_Part__c savedPart : [Select Id from Opportunity_Part__c where Id not in :map_id_oppParts.keySet() and Opportunity__c = :opportunityId and RecordTypeId = :srId and Part__c != null]){
            list_oppParts2Delete.add(savedPart);
        }

        map<Id, Id> map_id_gplid = new map<Id, Id>();
        map<Id, Id> map_id_partid = new map<Id, Id>();
        set<Id> set_oppyIds = new set<Id>();
        
        for(OpportunityPartWrapper opw : list_indexOpportunityPartsProposal){
            Opportunity_Part__c op = opw.opportunityPart; 
            list_oppProposalParts2Upsert.add(op);
            op.New_Development_Part__c = false;//added by xia 2013-01-24
            // validation
            if(op.New_Part_Description__c == null || op.New_Part_Description__c == ''){
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  system.Label.New_Part_Description_Required)); 
                 return null;
            }
            // added lili zhao 2014-07-17 due to add the message of the requied filed is null 
            if(isAPPL && op.Send_to_RTS__c == 'Yes' && op.Code_for_unit_of_measurement__c == null ) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  system.Label.Code_For_Unit_Of_Measurement_Required)); 
                return null;
            }   
            if(isAPPL && op.Send_to_RTS__c == 'Yes' && op.Initial_Order_Date__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  system.Label.Initial_Order_Date_Required)); 
                return null;
            }
            if(isAPPL && op.Send_to_RTS__c == 'Yes' && op.Product_Type__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  system.Label.Product_Type_Required)); 
                return null;
            }
            if(isAPPL && op.Send_to_RTS__c == 'Yes' && op.Customer_End_Product__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  system.Label.Customer_End_Product_Required)); 
                return null;
            }
            // end

            if(op.Id == null && op.RecordTypeId != oppRTId('sp') && (op.Similar_TE_Part_Number__c == null || String.valueOf(op.Similar_TE_Part_Number__c) == '')   && (op.GPL__c == null || String.valueOf(op.GPL__c) == '')){
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  system.Label.Both_Similar_Part_Number_GPL_NULL)); 
                 return null;
            }
            if(op.Id != null) set_oppyIds.add(op.Id);
                
            if(op.Part__c != null && String.ValueOf(op.Part__c) != ''){
                op.Similar_TE_Part_Number__c = null;
                op.New_Development_Part__c = true; //added by xia 2013-01-24
                //op.RecordTypeId = oppRTId('sp'); // commented by xia 2013-01-24
            }
            else{                   
                if(op.RecordTypeId == oppRTId('sp')) {
                    op.Part_Number__c = null;
                    if(op.cable_assembly_type__c == null) op.cable_assembly_type__c = 'Fiber Optic';
                    if(requestType.startsWith(REQUESTTYPE_CA)){
                        op.RecordTypeId = oppRTId('cap');
                    }
                    else if(requestType.contains(REQUESTTYPE_ND) || requestType == null){
                        op.RecordTypeId = oppRTId('nd');
                    }
                    else if(requestType.contains(REQUESTTYPE_E)){
                        op.RecordTypeId = oppRTId('e');
                    }
                }
            }
            set_closeDate.add(op.Initial_Order_Date__c);
        }                      
            
        if(map_gplId_gplName == null) map_gplId_gplName = new map<Id, String>();
        for(Opportunity_Part__c op : [SELECT Id, GPL__c, GPL__r.Name, Part__c from Opportunity_Part__c where Id in: set_oppyIds]){
            map_id_gplid.put(op.Id, op.GPL__c);
            map_id_partid.put(op.Id, op.Part__c);
            map_gplId_gplName.put(op.GPL__c, op.GPL__r.Name);
        }
        List<Opportunity_Part__c> list_oppParts2DeleteProposal = new List<Opportunity_Part__c>();
        Map<Id, Opportunity_Part__c> map_id_oppPartsProposal = new Map<Id, Opportunity_Part__c>();  
        
        for(OpportunityPartWrapper opw : list_indexOpportunityPartsProposal){
            Opportunity_Part__c op = opw.opportunityPart;        
            if(op.Id != null){
                map_id_oppPartsProposal.put(op.Id, op);                 
            }
        }
               
        for(Opportunity_Part__c savedPart : [Select Id from Opportunity_Part__c where Id not in :map_id_oppPartsProposal.keySet() and Opportunity__c = :opportunityId and (RecordTypeId != :srId or Part__c = null)]){
            list_oppParts2DeleteProposal.add(savedPart);
        }

        try{            
            set<Id> set_deletePartId = new set<Id>();
            for(Opportunity_Part__c op:list_oppParts2Delete){
                if(op.Id != null) set_deletePartId.add(op.Id);
            }
            for(Opportunity_Part__c op:list_oppParts2DeleteProposal){
                if(op.Id != null) set_deletePartId.add(op.Id);
            }
            
            if(!list_indexOpportunityPartsProposal.isEmpty()){                
                map<Id, list<Opportunity_Part__c>> map_oppyId_parts = new map<Id, list<Opportunity_Part__c>>();
                map_oppyId_parts.put(opportunityId,list_oppProposalParts2Upsert);
                map<Id,boolean> map_oppyId_isError = new map<Id,boolean>();
                system.debug('tongxia page call');
                map_oppyId_isError = ClsOppyPartUtil.validatePartManager(map_oppyId_parts,set_deletePartId);
                system.debug('-----oppo record type-->'+opp.RecordType.DeveloperName);
                if(map_oppyId_isError.containsKey(opportunityId) && map_oppyId_isError.get(opportunityId) &&  opp.RecordType.DeveloperName != 'DND_Opportunity'){
                    
                   
                        ApexPages.Message msg;
                        if(isChina){
                            msg = new ApexPages.Message(ApexPages.Severity.ERROR,  system.Label.Not_Same_Regional_PM);
                        }else{
                            msg = new ApexPages.Message(ApexPages.Severity.ERROR,  system.Label.Not_same_Approver_PM);
                        }
                        ApexPages.addMessage(msg);                    
                        return null;
                       }else{
                system.debug('inside else');
                    ClsOppyPartUtil.isRunTrigger = false;
                    if(!list_oppProposalParts2Upsert.isEmpty()) {
                        system.debug('SaveOpportunityParts : ' + list_oppProposalParts2Upsert);
                        upsert list_oppProposalParts2Upsert;
                    }
                    else system.debug(' Else SaveOpportunityParts : ' + list_oppProposalParts2Upsert);
                }
                
            }
            if(!list_oppSalesParts2Upsert.isEmpty()) {
                ClsOppyPartUtil.isRunTrigger = false;
                upsert list_oppSalesParts2Upsert;
            }
            if(!list_oppParts2Delete.isEmpty()) delete list_oppParts2Delete;
            if(!list_oppParts2DeleteProposal.isEmpty()) delete list_oppParts2DeleteProposal;
        }
        catch(Exception ex){
            ApexPages.addMessages(ex);
            Database.rollback(sp);
            return null;
        }        
                        
        // opportunity has been update as the part is upserted, so we get the new opportunity
        Opportunity oppNew = ClsOppyPartUtil.getOpportunityById(opportunityId);            
        if(oppNew.Manufacturing_Start_Date__c != opp.Manufacturing_Start_Date__c){
            opp = oppNew;
            Map<Date, Map<String, Map<Integer, Integer>>> map_date_startEndQuarter = ClsOppyUtil.getFiveYearsInternal(new set<Date>{opp.Manufacturing_Start_Date__c});
            Decimal totalRevenue = 0;
            Decimal year5Revenue = 0;
            Decimal totalRevenue_Cust = 0;
            Decimal year5Revenue_Cust = 0;                            
            Integer startYear, startQuarter, endYear, endQuarter;
            for(Integer theYear :map_date_startEndQuarter.get(opp.Manufacturing_Start_Date__c).get('Start').keySet()){
                startYear = theYear;
            }
            for(Integer theYear :map_date_startEndQuarter.get(opp.Manufacturing_Start_Date__c).get('End').keySet()){
                endYear = theYear;
            }
            startQuarter = map_date_startEndQuarter.get(opp.Manufacturing_Start_Date__c).get('Start').get(startYear);   
            endQuarter = map_date_startEndQuarter.get(opp.Manufacturing_Start_Date__c).get('End').get(endYear);     

            List<Opportunity_Forecast__c> list_oppFoc=new List<Opportunity_Forecast__c>();
            // 04-23-2014 Michael Cui: add Five_Year_Amount__c on SOQL to fix case 00672671
            list_oppFoc=[select id, Name, Quantity__c, Five_Year_Amount__c, CurrencyIsoCode, Amount__c, Opportunity__c, Opportunity__r.CloseDate,Opportunity__r.Manufacturing_Start_Date__c, Part__c, Sales_Price__c, Date__c,Fiscal_Year__c, Fiscal_Quarter__c,Part__r.Status__c from Opportunity_Forecast__c where Opportunity__c =:opp.Id and Part__c = null and Date__c != null order by Opportunity__c, Date__c];

            for(Opportunity_Forecast__c  ofc: list_oppFoc){
                if(ofc.Fiscal_Year__c != null && ofc.Fiscal_Quarter__c != null && ofc.Date__c != null && ofc.Opportunity__r.Manufacturing_Start_Date__c != null && ofc.Part__r.Status__c  !='Dead' && ofc.Part__r.Status__c  !='Lost' && ofc.Amount__c !=null){
                    // calculate the five year revenue
                    Integer y = Integer.valueOf(ofc.Fiscal_Year__c);
                    Integer q = Integer.valueOf(ofc.Fiscal_Quarter__c);
                    if((y > startYear && y < endYear) || (y == startYear && q >= startQuarter) || (y == endYear && q <= endQuarter)){
                        if(ofc.CurrencyIsoCode != opp.CurrencyIsoCode){
                            year5Revenue += ClsOppyUtil.transformIsoCode(ofc.Amount__c, ofc.CurrencyIsoCode, opp.CurrencyIsoCode);
                            year5Revenue_Cust += ClsOppyUtil.transformIsoCode(ofc.Five_Year_Amount__c, ofc.CurrencyIsoCode, opp.CurrencyIsoCode);
                        }else{
                            year5Revenue += ofc.Amount__c;
                            year5Revenue_cust += ofc.Five_Year_Amount__c;
                        }
                    }                    
                }              
                if(ofc.Fiscal_Year__c != null && ofc.Fiscal_Quarter__c != null && ofc.Part__r.Status__c  !='Dead' && ofc.Part__r.Status__c  !='Lost' && ofc.Amount__c !=null){    
                    if(ofc.CurrencyIsoCode != opp.CurrencyIsoCode){
                        totalRevenue += ClsOppyUtil.transformIsoCode(ofc.Amount__c, ofc.CurrencyIsoCode, opp.CurrencyIsoCode);
                        totalRevenue_Cust += ClsOppyUtil.transformIsoCode(ofc.Five_Year_Amount__c, ofc.CurrencyIsoCode, opp.CurrencyIsoCode);
                    }else{
                        totalRevenue += ofc.Amount__c;
                        totalRevenue_cust += ofc.Five_Year_Amount__c;   
                    }
                }
            }
                             
            opp.Amount = totalRevenue;
            opp.Five_Year_Revenue__c = year5Revenue; 
                // ######### Added Five Year Value,Total Opportunity value functionality BY RAVI <ravikumar.vasimalla@zensar.in>##########        
           
            opp.Total_Opportunity_Value__c= totalRevenue_Cust;
            opp.Five_Year_Value__c= year5Revenue_Cust;  
            
   //************************************************* Code  addd by deepak kumar**********************************************************************          
           Map<id,opportunity> mapoppty =new Map<id,opportunity>();
           Map<id,opportunity> mapopptytoupdate =new Map<id,opportunity>();
           mapoppty.put(oppNew.id, opp);   
             IND_RecalOneCurr_RevenueClass reclaOnECurr = new IND_RecalOneCurr_RevenueClass();
         
            mapopptytoupdate = reclaOnECurr.onAfterinsertUpdate(mapoppty); // Code added by Deepak Kumar on 15th sep 2016 for TeamUp case number  00901050             
            update mapopptytoupdate.values();
           // update opp; Commented by deepak on 19th sep to add one year revenue fuctionality;
 //************************************************* Code  addd by deepak kumar**********************************************************************          
                   
            if(opp.Program__c != null){
                List<Opportunity> list_opp = new  List<Opportunity>();
                Opportunity Program = new Opportunity();
                Program = [select Id, Amount,Five_Year_Revenue__c,Total_Opportunity_Value__c,Five_Year_Value__c,CloseDate,Manufacturing_Start_Date__c from Opportunity where id = : opp.Program__c];
                list_opp = [select Id,Amount,Total_Opportunity_Value__c,Five_Year_Value__c,Five_Year_Revenue__c from Opportunity where Program__c = : opp.Program__c];
                set<Opportunity> set_opp = new  set<Opportunity>();
                if(list_opp.size() > 0){           
                    set_opp.addAll(list_opp);
                    ClsOppyUtil.updateProgramTotalFiveYearsAmount(Program,set_opp);                     
                    update Program;
                }
            }
                              
        }            
             
        getOpportunityParts();
        
        isSaved = false;
        isSaveComplete = true;  
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, system.Label.Save_Completed));                
        
        return null;
       }



    
    /**
     * This method is used when click 'Return' button on vf page,
     * this method to redirect to Opportunity page
     *   
     @author Yinfeng Guo
     @created 2012-02-29
     @version 1.0
     @since 23.0
     *
     @return         Opportunity page according to Opportunity id
     *
     @changelog
     * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */      
    public PageReference GotoOpportunity(){
        if(opportunityId != null){
            return new PageReference('/' + opportunityId);
        }
        else{
            return new PageReference('/006/o');
        }
    }

    /**
     * This method is used when click 'Save' on vf page,
     * this method to save Opportunity Part first, then redirect to Opportunity page
     *   
     @author Yinfeng Guo
     @created 2012-02-29
     @version 1.0
     @since 23.0
     *
     @return         Opportunity page according to Opportunity id
     *
     @changelog
     * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */      
    public pageReference DoSaveAndReturn(){
   
        returnAfterSave = true;
 system.debug('boolean check ####'+delPermission);
        try{
            for(OpportunityPartWrapper opw : list_indexOpportunityPartsProposal){
                Opportunity_Part__c op = opw.opportunityPart;
                if((op.Similar_TE_Part_Number__c == null || String.valueOf(op.Similar_TE_Part_Number__c) == '')   && (op.GPL__c == null || String.valueOf(op.GPL__c) == '')){
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  system.Label.Both_Similar_Part_Number_GPL_NULL)); 
                     return null;
                }
            }
            SaveOpportunityParts();
            if(isSaveComplete) return GotoOpportunity();  
            else return null;
                     
        }
        catch (Exception e){
            returnAfterSave = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Error_Saving + e.getMessage()));    
            return null;            
        }   
       
    }

    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    /**
     * This method is used to get the Opportunity Parts according to the Opportunity Id
     *
     @author Yinfeng Guo
     @created 2012-02-29
     @version 1.0
     @since 23.0
     *
     @return                void            
     *
     @changelog
     * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */      
     
    private void getOpportunityParts(){
        // select * method
        String objectName = 'Opportunity_Part__c';
        Map<String, Schema.SObjectField> allFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        String queryString = 'select ';
        Set<String> set_queryFieldsSP = new set<String>();
        Set<String> set_queryFieldsPP = new set<String>();
        Set<String> set_totall = new Set<String>{'Id', 'Part__c','ADM_Product_Annualized_Amt__c','ADM_Average_Sales_Price__c','ADM_Competitor_Shipset_Amt__c','ADM_Full_Rate_Product_Annual_Quantity__c','ADM_Product_Annualized_Amt__c','ADM_Shipset_Quantity__c','ADM_TE_Oppty_SS_Amt__c','ADM_TE_Shipset_Amt__c','ADM_TE_Shipset_Percentage__c','ADM_Total_Product_SS_Amt__c', 'New_Part_Description__c', 'Comments__c','Initial_Order_Date__c', 'Product_Manager__c', 'Part__r.Name', 'Similar_TE_Part_Number__r.Name', 'GPL__r.Name', 'GPL__c', 'Opportunity__r.Manufacturing_Start_Date__c', 'Regional_PM_AP__c', 'Status_Reason__c', 'DNDCompetitor__c','Opportunity__r.recordType.name' };//Added by padmaja DNDCompetitor__c for DND merge project   
        //Added by Rahul goyal: - Added ADM Related fields in the query for ADM merge project
        set_queryFieldsSP.addAll(set_totall);
        set_queryFieldsPP.addAll(set_totall);

        for(Schema.FieldSetMember f : SObjectType.Opportunity_Part__c.FieldSets.OppPartProposalDetailFieldSet.getFields()) {
           set_queryFieldsPP.add(f.getFieldPath());
        }
        for(Schema.FieldSetMember f : SObjectType.Opportunity_Part__c.FieldSets.OppPartProposalFieldSet.getFields()) {
           set_queryFieldsPP.add(f.getFieldPath());
        }        
        for(Schema.FieldSetMember f : SObjectType.Opportunity_Part__c.FieldSets.OppPartSalesDetailFieldSet.getFields()) { 
           set_queryFieldsSP.add(f.getFieldPath());
        }     
        for(Schema.FieldSetMember f : SObjectType.Opportunity_Part__c.FieldSets.OppPartSalesFieldSet.getFields()) { 
           set_queryFieldsSP.add(f.getFieldPath());
        }           
        for(Schema.FieldSetMember f : SObjectType.Opportunity_Part__c.FieldSets.OppPartRTSRelatedFieldSet.getFields()) { 
           set_queryFieldsSP.add(f.getFieldPath());
           set_queryFieldsPP.add(f.getFieldPath());
        }            
                    
        String queryStringSales = 'Select ';
        String queryStringProposal = 'Select ';
        
        for(String s : set_queryFieldsSP){
            queryStringSales += s + ',';
        }
        
        for(String s : set_queryFieldsPP){
            queryStringProposal += s + ',';
        }    

        String endQueryString = ' from ' + objectName + ' where Opportunity__c = \''+ opportunityId + '\'';
        queryStringSales = queryStringSales.subString(0, queryStringSales.length() -1) + endQueryString + 'and RecordTypeId = \''+ oppRTId('sp') +'\' and Part__c != null';
        queryStringProposal = queryStringProposal.subString(0, queryStringProposal.length() -1) + endQueryString  + 'and (RecordTypeId != \''+oppRTId('sp')+'\' or Part__c = null)';
        
        try {
            //list_opportunityParts = database.query(queryStringSales);
            
            Integer counter = 0;
            String similarName='';
            String partGPLName='';       
            String partName = '';
            list_indexOpportunityParts.clear(); 
            for(Opportunity_Part__c oppPart : database.query(queryStringSales)){
                
              //op.Temporary_Part_Name__c = op.Part_Name__c;
              if(oppPart.Initial_Order_Date__c == null && oppPart.Opportunity__r.Manufacturing_Start_Date__c !=null && !(oppPart.Opportunity__r.recordType.name.contains('DND') )){          
                    oppPart.Initial_Order_Date__c = oppPart.Opportunity__r.Manufacturing_Start_Date__c;
              }   
              
              // added by min 2012-10-19 START             
              if(oppPart.GPL__r.Name != null){
                    partGPLName = oppPart.GPL__r.Name ;
                }
                else if(oppPart.Part__c != null && String.valueOf(oppPart.Part__c) != '' && map_partId_gplName != null && !map_partId_gplName.isEmpty()) 
                    partGPLName = map_partId_gplName.get(oppPart.Part__c);
                    
                list_indexOpportunityParts.add(new OpportunityPartWrapper(oppPart, counter, similarName, partGPLName, partName));
                counter++;
                system.debug('list_indexOpportunityParts: ' + list_indexOpportunityParts);
              // added by min 2012-10-19 END
            }
        } 
        catch (QueryException e){}
        
        
        try {
            //list_opportunityPartsProposal = database.query(queryStringProposal);           
            Integer counter = 0;
            list_indexOpportunityPartsProposal.clear();  
            system.debug('leijun_queryStringProposal: ' + queryStringProposal);
            for(Opportunity_Part__c oppPart : database.query(queryStringProposal)){
                oppPart.Temporary_Part_Name__c = oppPart.Part_Name__c;
              if(oppPart.Initial_Order_Date__c == null && oppPart.Opportunity__r.Manufacturing_Start_Date__c !=null && !(oppPart.Opportunity__r.recordType.name.contains('DND') )){          
                    oppPart.Initial_Order_Date__c = oppPart.Opportunity__r.Manufacturing_Start_Date__c;
                }
                // added by min 2012-10-19 START
                String similarName;
                String partName;
                String partGPLName;
                if(oppPart.Similar_TE_Part_Number__c != null && String.valueOf(oppPart.Similar_TE_Part_Number__c) != '' && map_partId_similartPartName != null && !map_partId_similartPartName.isEmpty()) 
                    similarName = map_partId_similartPartName.get(oppPart.Similar_TE_Part_Number__c);
                else if(oppPart.Similar_TE_Part_Number__r.Name != null){
                    similarName = oppPart.Similar_TE_Part_Number__r.Name ;
                }
                
                if(oppPart.Part__c != null && String.valueOf(oppPart.Part__c) != '' && map_partId_partName != null && !map_partId_partName.isEmpty()) 
                    partName = map_partId_partName.get(oppPart.Part__c);
                else if(oppPart.Part__r.Name != null){
                    partName = oppPart.Part__r.Name ;
                }
                               
                if(oppPart.Similar_TE_Part_Number__c != null && String.valueOf(oppPart.Similar_TE_Part_Number__c) != '' && map_partId_gplName != null && !map_partId_gplName.isEmpty()) 
                    partGPLName = map_partId_gplName.get(oppPart.Similar_TE_Part_Number__c);
                else if(oppPart.Part__c != null && String.valueOf(oppPart.Part__c) != '' && map_partId_gplName != null && !map_partId_gplName.isEmpty()) 
                    partGPLName = map_partId_gplName.get(oppPart.Part__c);
                else if(oppPart.GPL__c != null && String.valueOf(oppPart.GPL__c) != '' && map_gplId_gplName != null && !map_gplId_gplName.isEmpty()) 
                    partGPLName = map_gplId_gplName.get(oppPart.GPL__c);    
                else if(oppPart.GPL__r.Name != null){
                    partGPLName = oppPart.GPL__r.Name ;
                }
                
                if(oppPart.Similar_TE_Part_Number__c == null){
                    similarName = null;
                }
                // added by min 2012-10-19 END
                list_indexOpportunityPartsProposal.add(new OpportunityPartWrapper(oppPart, counter, similarName, partGPLName, partName));
                //system.debug('tongxia list_indexOpportunityPartsProposal2:' + list_indexOpportunityPartsProposal);
                counter++;               
            }            
        }       
        catch (QueryException e){}
    }  

    
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>WrapperClass*/
   /**
    * Inner class to warp Opportunity Part 
    * This is a Inner Class : wrapper for search results to make selectable via checkbox
    * Class field contains : 1.Custom object Opportunity_Part__c 2.The index of opportunityPart list
    * Class method contains : Constructor of this class.
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */      
    public class OpportunityPartWrapper{
        public Opportunity_Part__c opportunityPart{get; set; }
        public Integer index{get; set; }
        public String OppyPartSimilarName{get; set; }
        public String OppyPartNumberName{get; set; }
        public String GPLName{get; set; }
        public String productManager {get;set;}
        public String regionalPM {get;set;}
        public OpportunityPartWrapper(Opportunity_Part__c op, Integer i, String similarName, String partGPLName, String partNumberName){
            opportunityPart = op;
            OppyPartSimilarName = '';
            GPLName = '';
            index = i;
            if(similarName != null && similarName != '') OppyPartSimilarName = similarName;
            if(partGPLName != null && partGPLName != '') GPLName = partGPLName;
            if(partNumberName != null && partNumberName != '') OppyPartNumberName = partNumberName;
            productManager = op.Product_Manager__c;
            regionalPM = op.Regional_PM_AP__c;
        }
    }    
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
    
            
    //==============================================================================================================================================
    //=================================/*   -=END  Code Block for Common use                              */========================================
    //=================================/*   This Block contains variables and methods used for Common use */========================================
    //==============================================================================================================================================
    
    //==============================================================================================================================================
    //==============================================================================================================================================
    //=================================/*   -=BEGIN  Code Block for Sales part                            */========================================
    //=================================/*   This Block contains variables and methods used for sales part */========================================
    //==============================================================================================================================================
    //============================================================================================================================================== 
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    /**
     * Decide that whether to show the previous page link for opportunity part list.
     */
    public boolean oppPartListShowPrevPageLink{ get { return (oppPartListPageNumber > 1); } }
    /**
     * Decide that whether to show the next page link for opportunity part list.
     */
    public boolean oppPartListShowNextPageLink{ get { return (oppPartListPageNumber < oppPartListTotalRecordCount / (oppPartListPageSize * 1.0)); } }  
    /**
     * The amount of parts to show on a single page.
     */
    public Integer oppPartListPageSize = 1;//alter by leijun
    /**
     * Recently present page or the page will to show.
     */
    public Integer oppPartListPageNumber {
        get { 
            if (oppPartListPageNumber == null || oppPartListPageNumber == 0) oppPartListPageNumber = 1; 
            return oppPartListPageNumber; 
        } 
        set;
    }
    /**
     * The number of last page for opportunity part list.
     */
    public Integer oppPartListLastPage {
        get{
            Integer lastPageNumber = system.math.abs(oppPartListTotalRecordCount / oppPartListPageSize);
            if(system.math.mod(oppPartListTotalRecordCount, oppPartListPageSize) > 0){
                lastPageNumber += 1;
            }
            return lastPageNumber;
        } 
        set;
    }
    /**
     * The number of page number will jump to.
     */
    public Integer oppPartListJumpToPage {get; set;}    
    
    //enable checkboxes to select search results
    public List<Part__c> list_selectedParts = new List<Part__c>();
    //Variable mean : the last record number on the recently page
    public Integer oppPartListLastRecordNumber{
        get {
            return Math.min(oppPartListTotalRecordCount, oppPartListFirstRecordNumber + oppPartListPageSize - 1) ; 
        }
    }
    
    //Variable mean : the total record number
    public Integer oppPartListTotalRecordCount{
        get { 
            if (list_indexOpportunityParts == null || list_indexOpportunityParts == null) return 0; //modified by xia 2013-01-28; add list == null 
            else return list_indexOpportunityParts.size(); 
        }      
    }    
    

    //Variable mean : the first record number on the recently page  
    public Integer oppPartListFirstRecordNumber{
        get {
            return (oppPartListPageNumber - 1) * oppPartListPageSize + 1; 
        }
    }  

    //==================================================Regard to Opportunity_Part__c Sales list PageBlock====================================
    //==================================================Regard to Opportunity_Part__c Sales list PageBlock====================================
    //Variable mean : opportunity parts list to show only single page
    public List<OpportunityPartWrapper> list_singlePageOpportunityParts{
        get{
            List<OpportunityPartWrapper> list_pagedParts = new List<OpportunityPartWrapper>();
            
            if (list_indexOpportunityParts != null && !list_indexOpportunityParts.isEmpty()){
                if(oppPartListPageNumber == null) oppPartListPageNumber = 1;
                Integer startIdx = (oppPartListPageNumber - 1) * oppPartListPageSize;
                Integer endIdx = startIdx + oppPartListPageSize-1;
                //Integer endIdx = startIdx + 50;
                for (Integer idx = startIdx; idx <= endIdx && list_indexOpportunityParts.size() > idx; idx++)
                  list_pagedParts.add(list_indexOpportunityParts[idx]);
            }
            return list_pagedParts;
        } 
        set;
    }

    
    public Boolean returnAfterSave {get; set;}              
    //==================================================Regard to Opportunity_Part__c Sales list PageBlock====================================
    //==================================================Regard to Opportunity_Part__c Sales list PageBlock====================================      
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //********************************* -=BEGIN public methods=- **********************************

   /**
    * This method is used to add sales opportunity part to the sales opportunity parts list from popup search part page
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return             void
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */  
    public void PopupAddSalesPart(){
        set<id> set_ids = new set<id>();
        for(string uid: idString.split(',')) {
            if(uid.trim() != ''){
                set_ids.add(uid.trim());
            }
        }
        map_partId_gplName = new map<Id, String>();
        map<Id, String> map_partId_gplManager = new map<Id, String>();
        list_selectedParts.clear();
        for(Part__c p : [Select Id, Name, Description__c, GPL__r.Name, GPL_Description__c,  Product_Hierarchy__c, Product_Hierarchy__r.Name, Product_Hierarchy__r.Hierarchy_Level_Type__c, Product_Hierarchy__r.Description__c,Product_Hierarchy__r.Product_Manager__r.name from Part__c where Id in: set_ids]){
            list_selectedParts.add(p);
            map_partId_gplName.put(p.Id, p.Product_Hierarchy__r.Name);
            map_partId_gplManager.put(p.Id,p.Product_Hierarchy__r.Product_Manager__r.name);
        }
        
        try{
            
            //Added by Bin Yuan 2014-05-08 due to assign Confidence and process status for new added parts
            map<String, String> map_fieldKey_status = ClsOppyPartUtil.getOppyPartDefaultConfidenceAndProcessStatus(opportunityId);  
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info, 'map_fieldKey_status :: ' + map_fieldKey_status));  
            //End        
            for(Part__c selected : list_selectedParts){               
                Opportunity_Part__c newPart = new Opportunity_Part__c();
                
                newPart.Opportunity__c = opportunityId;
                newPart.RecordTypeId = oppRTId('sp');        

                //add part desc as line item description
                if(SalesforceUtils.replaceNullStringWithEmpty(selected.Description__c).length() > 255){
                    newPart.New_Part_Description__c = selected.Description__c.subString(0, 255);
                }
                else{
                    newPart.New_Part_Description__c = selected.Description__c;              
                }
                //newPart.Temporary_Part_Name__c = selected.Name + ' - ' + selected.Description__c;
                newPart.Temporary_Part_Name__c = selected.Description__c;
                newPart.Part__c = selected.Id;
                //setting defaults to avoid validation error
                newPart.Quantity__c = 1;
                newPart.GPL__c = selected.Product_Hierarchy__c;
                newPart.Status__c = ((isSPIN && map_fieldKey_status.containsKey('Confidence')) ? map_fieldKey_status.get('Confidence') : (isChnl ? 'Weak' : '50/50'));// isChnl condition Added by Mrunal for case 00900348
                newPart.Sales_Price__c = 0; 
                newPart.CurrencyIsoCode = oppyCurrencyIsoCode; 
                newPart.Process_Status__c = ((isSPIN && map_fieldKey_status.containsKey('ProcessStatus')) ? map_fieldKey_status.get('ProcessStatus') : 'Concept');       
                  if(opp.RecordType.DeveloperName != null &&  ! (opp.RecordType.DeveloperName.equals('DND_Opportunity')))  
        newPart.Initial_Order_Date__c = opp.Manufacturing_Start_Date__c;  
                newPart.Send_to_RTS__c = 'No';         
                //list_opportunityParts.add(newPart);
                
                // added by min 2012-10-19 START
                String similarName='';
                String partGPLName='';
                String partName = '';  
                String managerName = '';                           
                if(newPart.GPL__r.Name != null){
                    partGPLName = newPart.GPL__r.Name ;
                }
                else if(newPart.Part__c != null && String.valueOf(newPart.Part__c) != '' && map_partId_gplName != null && !map_partId_gplName.isEmpty()) {
                    partGPLName = map_partId_gplName.get(newPart.Part__c);
                    managerName = map_partId_gplManager.get(newPart.Part__c);
                }
                OpportunityPartWrapper opwrapper = new OpportunityPartWrapper(newPart, list_indexOpportunityParts.size(), similarName, partGPLName, partName);
                opwrapper.productManager = managerName;
                list_indexOpportunityParts.add(opwrapper);
                // added by min 2012-10-19 END                         
            }
            
            oppPartListPageNumber = oppPartListLastPage;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, list_selectedParts.size() +  system.Label.Parts_Added)); //
        }
        catch (Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Add_Part_Error + e.getMessage()));   //         
            //ErrorLogging.Log(e);  
        }
        messageOnResult = false;        
    }

    
        
   /**
    * This method is used to delete Opportunity Parts for Sales Parts list
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return             null
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */  
    public PageReference DeleteOpportunityParts() {
        //Added by Poonam for case 901402- End
        closeDateValidationForDND();
        if(showCloseDateError){
           return null;
        }
        //Added by Poonam for case 901402- End
        else{
            try{
                //get index of clicked row passed in from vf page and remove from list
                if(deleteOpportunityPartIndex != null){
                    list_indexOpportunityParts.remove(deleteOpportunityPartIndex);
                    // addede by min 2012-10-19 START
                    for(Integer i = 0; i < list_indexOpportunityParts.size(); i++){
                         list_indexOpportunityParts.get(i).index = i;
                    }
                    // addede by min 2012-10-19 END                                
                }
                //if on last page and last page number changed, then go to new last page    
                if(oppPartListPageNumber > oppPartListLastPage){
                    oppPartListPageNumber = oppPartListLastPage;
                }
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, system.Label.Delete_After_Save));
            }
            catch (Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Delete_Error   + e.getMessage()));     
            }
            return null;
        }
    }

   /**
    * This method is used to go to previous page for sales Parts list
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return             null
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */          
    public pageReference OppPartListPreviousPage(){
        oppPartListPageNumber--;
        return null;
    }

   /**
    * This method is used to go to next page for Sales Parts list
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return             null
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */    
    public pageReference OppPartListNextPage(){
        oppPartListPageNumber++;
        return null;
    }
                   

    
    //==============================================================================================================================================
    //==============================================================================================================================================
    //=================================/*   -=END  Code Block for Sales part                              */========================================
    //=================================/*   This Block contains variables and methods used for sales part */========================================
    //==============================================================================================================================================
    //============================================================================================================================================== 


    //==============================================================================================================================================
    //==============================================================================================================================================
    //=================================/*   -=BEGIN  Code Block for Proposal part                            */=====================================
    //=================================/*   This Block contains variables and methods used for proposal part */=====================================
    //==============================================================================================================================================
    //============================================================================================================================================== 
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //Variable mean : whether to show the previous page link for opportunity part list
    public boolean oppPartListShowPrevPageLinkProposal{
        get { 
            return (oppPartListPageNumberProposal > 1); 
        }
    }
    //Variable mean : whether to show the next page link for opportunity part list
    public boolean oppPartListShowNextPageLinkProposal{
        get {
            return (oppPartListPageNumberProposal < oppPartListTotalRecordCountProposal / (oppPartListPageSizeProposal * 1.0)); 
        }
    }    

    //Variable mean : number of total page    
    public Integer oppPartListPageSizeProposal = 1;//alter by leijun
    
    //Variable mean : recently present page or the page will to show
    public Integer oppPartListPageNumberProposal {
        get { 
            if (oppPartListPageNumberProposal == null || oppPartListPageNumberProposal == 0) oppPartListPageNumberProposal = 1; 
            return oppPartListPageNumberProposal; 
        } 
        set;
    }
    //Variable mean : the last page number for opportunity part list
    public Integer oppPartListLastPageProposal {
        get{
            Integer lastPageNumberProposal = system.math.abs(oppPartListTotalRecordCountProposal / oppPartListPageSizeProposal);
            if(system.math.mod(oppPartListTotalRecordCountProposal, oppPartListPageSizeProposal) > 0){
                lastPageNumberProposal += 1;
            }
            return lastPageNumberProposal;
        } 
        set;
    }
    //Variable mean : the page number will jump to
    public Integer oppPartListJumpToPageProposal {get; set;}  

    //Variable mean : the last record number on the recently page
    public Integer oppPartListLastRecordNumberProposal{
        get {
            return Math.min(oppPartListTotalRecordCountProposal, oppPartListFirstRecordNumberProposal + oppPartListPageSizeProposal - 1) ; 
        }
    }
    
    //Variable mean : the total record number
    public Integer oppPartListTotalRecordCountProposal{
        get { 
            if (list_indexOpportunityPartsProposal == null) return 0; 
            else return list_indexOpportunityPartsProposal.size(); 
        }      
    } 

    //Variable mean : the first record number on the recently page  
    public Integer oppPartListFirstRecordNumberProposal{
        get {
            return (oppPartListPageNumberProposal - 1) * oppPartListPageSizeProposal + 1; 
        }
    }  
    
        //proposal part fields
    public Integer nbrProposalParts {get; set;}     
    
    //==================================================Regard to Opportunity_Part__c Proposal list PageBlock====================================
    //==================================================Regard to Opportunity_Part__c Proposal list PageBlock====================================
    //Variable mean : opportunity parts list to show only single page
    public List<OpportunityPartWrapper> list_singlePageOpportunityPartsProposal{
        get{            
            List<OpportunityPartWrapper> list_pagedPartsProposal = new List<OpportunityPartWrapper>();
            if (list_indexOpportunityPartsProposal != null && !list_indexOpportunityPartsProposal.isEmpty()){
                if(oppPartListPageNumberProposal == null) oppPartListPageNumberProposal = 1;
                Integer startIdxProposal = (oppPartListPageNumberProposal - 1) * oppPartListPageSizeProposal;
                Integer endIdxProposal = startIdxProposal + oppPartListPageSizeProposal-1;
                for (Integer idx = startIdxProposal; idx <= endIdxProposal && list_indexOpportunityPartsProposal.size() > idx; idx++){
                    list_pagedPartsProposal.add(list_indexOpportunityPartsProposal[idx]);
                }
            }
            //system.debug('tongxia list_pagedPartsProposal:' + list_pagedPartsProposal);
            return list_pagedPartsProposal;
        } 
        set;
    }            
    
    public Boolean returnAfterSaveProposal {get; set;}              
    //==================================================Regard to Opportunity_Part__c Proposal list PageBlock====================================
    //==================================================Regard to Opportunity_Part__c Proposal list PageBlock====================================    

    /**
     * This method used after user click Similar TE Part lookup icon , search part, add part.
     * This method is used to add Similar TE Part.
     *   
     @author Yinfeng Guo
     @created 2012-02-29
     @version 1.0
     @since 23.0
     *
     @return         null
     *
     @changelog
     * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    public PageReference SelectSimilarParts() {   
        set<Id> set_partIds = new set<Id>();
        map<Id, String> map_partId_oppyPartName = new map<Id, String>();
        map<Id, Id> map_partId_gpl = new map<Id, Id>();
        map<Id, String> map_partId_gplManager = new map<Id, String>();
        map<Id, String> map_partId_regionalPM = new map<Id, String>();
        map_partId_similartPartName = new map<Id, String>();
        map_partId_gplName = new map<Id, String>();
        for(OpportunityPartWrapper op : list_indexOpportunityPartsProposal){
            if(op.opportunityPart.Similar_TE_Part_Number__c != null &&  String.valueOf(op.opportunityPart.Similar_TE_Part_Number__c) != ''){
                set_partIds.add(op.opportunityPart.Similar_TE_Part_Number__c);
            }
        }
        for(Part__c p : [Select Id, Name, Description__c, GPL__c, Product_Hierarchy__r.Name,Product_Hierarchy__r.Product_Manager__r.name, Product_Hierarchy__r.Regional_PM_AP__r.name,Product_Hierarchy__c from Part__c where Id in: set_partIds]){
            //map_partId_oppyPartName.put(p.Id, p.Description__c);
            map_partId_gpl.put(p.Id, p.Product_Hierarchy__c);
            map_partId_similartPartName.put(p.Id, p.Name);
            map_partId_gplName.put(p.Id, p.Product_Hierarchy__r.Name);
            //added by xia 2013-04-09 -- start
            if(isChina){
                map_partId_regionalPM.put(p.Id,p.Product_Hierarchy__r.Regional_PM_AP__r.name);
            }else{
                map_partId_regionalPM.put(p.Id,'');
            }
            //added by xia 2013-04-09 -- end
            map_partId_gplManager.put(p.Id,p.Product_Hierarchy__r.Product_Manager__r.name);
            
        }
        for(OpportunityPartWrapper op : list_indexOpportunityPartsProposal){
            if(op.opportunityPart.Similar_TE_Part_Number__c != null &&  String.valueOf(op.opportunityPart.Similar_TE_Part_Number__c) != ''){
                op.regionalPM = map_partId_regionalPM.get(op.opportunityPart.Similar_TE_Part_Number__c);
                op.productManager = map_partId_gplManager.get(op.opportunityPart.Similar_TE_Part_Number__c);
                op.GPLName = map_partId_gplName.get(op.opportunityPart.Similar_TE_Part_Number__c);
                op.opportunityPart.GPL__c = map_partId_gpl.get(op.opportunityPart.Similar_TE_Part_Number__c);
                op.OppyPartSimilarName = map_partId_similartPartName.get(op.opportunityPart.Similar_TE_Part_Number__c);
                //op.opportunityPart.Temporary_Part_Name__c = map_partId_oppyPartName.get(op.opportunityPart.Similar_TE_Part_Number__c);          
                if(op.opportunityPart.Similar_TE_Part_Number__r.Name != null && op.opportunityPart.Similar_TE_Part_Number__r.Name != map_partId_similartPartName.get(op.opportunityPart.Similar_TE_Part_Number__c))
                    op.opportunityPart.Similar_TE_Part_Number__r.Name = map_partId_similartPartName.get(op.opportunityPart.Similar_TE_Part_Number__c);
            }
        }
        messageOnResult = false;
        return null;    
    }

    /**
     * This method used after user click Part Number lookup icon , search part, add part.
     * This method is used to add Sales Part Number.
     *   
     @author Yinfeng Guo
     @created 2012-04-26
     @version 1.0
     @since 23.0
     *
     @return         null
     *
     @changelog
     * 2012-04-26 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    public PageReference SelectPartsForPartNumber() {   
        set<Id> set_partIds = new set<Id>();
        map<Id, String> map_partId_oppyPartName = new map<Id, String>();
        map<Id, Id> map_partId_gpl = new map<Id, Id>();
        map_partId_partName = new map<Id, String>();
        map_partId_gplName = new map<Id, String>();
        map<Id, String> map_partId_gplManager = new map<Id, String>();
        map<Id, String> map_partId_regionalPM = new map<Id, String>();
        for(OpportunityPartWrapper op : list_indexOpportunityPartsProposal){
            if(op.opportunityPart.Part__c != null &&  String.valueOf(op.opportunityPart.Part__c) != ''){
                set_partIds.add(op.opportunityPart.Part__c);
                op.opportunityPart.Similar_TE_Part_Number__c = null;
            }
        }
        for(Part__c p : [Select Id, Name, Description__c, GPL__c, Product_Hierarchy__r.Name, Product_Hierarchy__c,Product_Hierarchy__r.Product_Manager__r.name,Product_Hierarchy__r.Regional_PM_AP__r.name from Part__c where Id in: set_partIds]){
            //map_partId_oppyPartName.put(p.Id, p.Name + ' - ' + p.Description__c);
            map_partId_oppyPartName.put(p.Id, p.Description__c);
            map_partId_gpl.put(p.Id, p.Product_Hierarchy__c);
            map_partId_partName.put(p.Id, p.Name);
            map_partId_gplName.put(p.Id, p.Product_Hierarchy__r.Name);
            //added by xia 2013-04-09 -- start
            if(isChina){
                map_partId_regionalPM.put(p.Id,p.Product_Hierarchy__r.Regional_PM_AP__r.name);
                
            }else{
                map_partId_regionalPM.put(p.Id,'');
            }
            //added by xia 2013-04-09 -- end
            map_partId_gplManager.put(p.Id,p.Product_Hierarchy__r.Product_Manager__r.name);
        }
        for(OpportunityPartWrapper op : list_indexOpportunityPartsProposal){
            if(op.opportunityPart.Part__c != null &&  String.valueOf(op.opportunityPart.Part__c) != ''){
                //op.opportunityPart.GPL__r.Name = map_partId_gplName.get(op.opportunityPart.Similar_TE_Part_Number__c);
                op.regionalPM = map_partId_regionalPM.get(op.opportunityPart.Part__c);//added by xia 2013-04-09
                op.opportunityPart.GPL__c = map_partId_gpl.get(op.opportunityPart.Part__c);
                op.productManager = map_partId_gplManager.get(op.opportunityPart.Part__c);//added by xia 2013-01-28
                op.GPLName = map_partId_gplName.get(op.opportunityPart.Part__c);//added by xia 2013-01-28
                op.opportunityPart.Temporary_Part_Name__c = map_partId_oppyPartName.get(op.opportunityPart.Part__c);
                if(op.opportunityPart.Part__r.Name != null && op.opportunityPart.Part__r.Name != map_partId_partName.get(op.opportunityPart.Part__c))
                    op.opportunityPart.Part__r.Name = map_partId_partName.get(op.opportunityPart.Part__c);  
            }
        }
        messageOnResult = false;
        SaveOpportunityParts();
        return null;    
    }
    /**
     * This method used after user click GPL lookup icon , search GPL, add GPL.
     * This method is used to add GPL.
     *   
     @author Yinfeng Guo
     @created 2012-04-13
     @version 1.0
     @since 23.0
     *
     @return         null
     *
     @changelog
     * 2012-04-13 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    public PageReference SelectGPL() {   
        system.debug('tongxia SelectGPL');
        set<Id> set_gplIds = new set<Id>();
        map<Id, String> map_gplId_gplDescription = new map<Id, String>();
        map<Id, String> map_gplId_managerName = new map<Id, String>();
        map<Id, String> map_gplId_regionalPM = new map<Id, String>();
        map_gplId_gplName = new map<Id, String>();

        for(OpportunityPartWrapper op : list_indexOpportunityPartsProposal){
            system.debug('op.productmanager:'+op.productmanager);
            if(op.opportunityPart.GPL__c != null &&  String.valueOf(op.opportunityPart.GPL__c) != ''){
                set_gplIds.add(op.opportunityPart.GPL__c);
                if(op.index == selectedIndex){
                    op.opportunityPart.Similar_TE_Part_Number__c = null;
                    op.OppyPartSimilarName = null;
                    break;
                }             
            }
        }

        for(Product_Hierarchy__c ph : [Select Id, Name, Product_Manager__r.name , GPL_Description__c,Regional_PM_AP__r.name from Product_Hierarchy__c where Id in: set_gplIds]){
            map_gplId_gplDescription.put(ph.Id, ph.GPL_Description__c);
            map_gplId_gplName.put(ph.Id, ph.Name);
            //added by xia 2013-04-09 -- start
            if(isChina){
                map_gplId_regionalPM.put(ph.Id, ph.Regional_PM_AP__r.name);
            }else{
                map_gplId_regionalPM.put(ph.Id, '');
            }
            //added by xia 2013-04-09 -- end
            map_gplId_managerName.put(ph.Id, ph.Product_Manager__r.name);
        }
        for(OpportunityPartWrapper op : list_indexOpportunityPartsProposal){
            if(op.opportunityPart.GPL__c != null &&  String.valueOf(op.opportunityPart.GPL__c) != ''){
                if(op.index == selectedIndex && map_gplId_gplName.containsKey(op.opportunityPart.GPL__c)){
                    //system.debug('tongxia :'+map_gplId_gplName.get(op.opportunityPart.GPL__c));
                    op.regionalPM = map_gplId_regionalPM.get(op.opportunityPart.GPL__c);
                    op.GPLName = map_gplId_gplName.get(op.opportunityPart.GPL__c);
                    op.productManager = map_gplId_managerName.get(op.opportunityPart.GPL__c);
                    break;
                }               
            }
        }
        messageOnResult = false;
        return null;    
    }
   /**
    * This method is used to add specific number Proposal parts to the proposal part list
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return             void
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */   
    public void NewAddProposalParts() {
   
       isSaved = true;
        messageOnResult = false;
        nbrProposalParts = Integer.valueOf(addAmount);
        DoAddProposalParts();
        
    } 

   /**
    * This method is used to add proposal parts to the proposal part list.
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return             void
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */      
    public void DoAddProposalParts() {
        try{
            //Proposal part needs to exist for this to work
            Part__c TempPart = new Part__c();
            //Product_Hierarchy__c comment
            //Added by Bin Yuan 2014-05-08 due to assign Confidence and process status for new added parts
            map<String, String> map_fieldKey_status = ClsOppyPartUtil.getOppyPartDefaultConfidenceAndProcessStatus(opportunityId);    
            //End  
            for(Part__c p : [select Id, Name, Description__c,  Product_Hierarchy__c, Product_Hierarchy__r.Hierarchy_Level_Type__c, Product_Hierarchy__r.Description__c from Part__c where Description__c = 'Proposal Part' limit 1]){
                TempPart = p;
            }
            if(TempPart.Id != null){
                for(Integer i = 0; i < nbrProposalParts; i++){
                    Opportunity_Part__c newPart = new Opportunity_Part__c();
                    newPart.Opportunity__c = opportunityId;
                    
                    if(requestType == null || requestType.contains(REQUESTTYPE_ND)){
                        newPart.RecordTypeId = oppRTId('nd');
                    }
                    else if(requestType.startsWith(REQUESTTYPE_CA)){
                        newPart.RecordTypeId = oppRTId('cap');
                        //added by Bin Yuan due to set Cable Asssembly type default value
                        newPart.Cable_Assembly_Type__c = 'Non-Fiber Optic';
                        //end
                    }
                    else if(requestType.contains(REQUESTTYPE_E)){
                        newPart.RecordTypeId = oppRTId('e');
                    }
                    
                    //setting defaults to avoid validation error
                    newPart.Quantity__c = 1;
                    newPart.Sales_Price__c = 0; 
                    newPart.Status__c = ((isSPIN && map_fieldKey_status.containsKey('Confidence')) ? map_fieldKey_status.get('Confidence') : (isChnl ? 'Weak' : '50/50')); // isChnl condition Added by Mrunal for case 00900348
                    newPart.CurrencyIsoCode = oppyCurrencyIsoCode;
                    newPart.Temporary_Part_Name__c = TempPart.Description__c;
                    newPart.Process_Status__c = ((isSPIN && map_fieldKey_status.containsKey('ProcessStatus')) ? map_fieldKey_status.get('ProcessStatus') : 'Concept');   
                     if(opp.RecordType.DeveloperName!= null  && !( opp.RecordType.DeveloperName.equals('DND_Opportunity')))                     
           newPart.Initial_Order_Date__c = opp.Manufacturing_Start_Date__c;  
                    newPart.Send_to_RTS__c = 'No';
                    //Start by Bin Yuan 2013-11-13 due to change Send_to_RTS__c default to 'Yes'
                    //newPart.Send_to_RTS__c = 'No';
                    newPart.Send_to_RTS__c = (isAPPL ? 'Yes' : 'No');
                    
                        
                    //End by bin yuan
                    //list_opportunityPartsProposal.add(newPart);
                    
                    // added by min 2012-10-19 START
                    list_indexOpportunityPartsProposal.add(new OpportunityPartWrapper(newPart, list_indexOpportunityPartsProposal.size(), '', '', ''));
                    // added by min 2012-10-19 END                                            
                }
                oppPartListPageNumberProposal = oppPartListLastPageProposal;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, nbrProposalParts +  system.Label.Parts_Added));              
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  system.Label.No_proposal_part_template));
            }
        }
        catch (QueryException e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Error_Adding_Proposal_Parts  + e.getMessage()));   
        }           
    }
    public List<SelectOption> getItems() {
       List<SelectOption> options = new List<SelectOption>();
       Schema.DescribeFieldResult fieldResult = Opportunity_Part__c.Process_Status__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
       for( Schema.PicklistEntry f : ple)
       {
          options.add(new SelectOption(f.getLabel(), f.getValue()));
       }      
       return options;
    }
    /**
     * This method is used to delete Opportunity Parts for Proposal Parts list
     *   
     @author Yinfeng Guo
     @created 2012-02-29
     @version 1.0
     @since 23.0
     *
     @return         null
     *
     @changelog
     * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    public PageReference DeleteOpportunityPartsProposal() {
        //Added by Poonam for case 901402- End
        closeDateValidationForDND();
        if(showCloseDateError){
           return null;
        }
        //Added by Poonam for case 901402- End
        else{
        try{
            //get index of clicked row passed in from vf page and remove from list
            if(deleteOpportunityPartIndexProposal != null){
                //list_opportunityPartsProposal.remove(deleteOpportunityPartIndexProposal);
                list_indexOpportunityPartsProposal.remove(deleteOpportunityPartIndexProposal);        
                // added by min 2012-10-19 START
                for(Integer i = 0; i < list_indexOpportunityPartsProposal.size(); i++){                  
                    list_indexOpportunityPartsProposal.get(i).index = i;
                }
                // added by min 2012-10-19 END
            }
            //if on last page and last page number changed, then go to new last page    
            if(oppPartListPageNumberProposal > oppPartListLastPageProposal){
                oppPartListPageNumberProposal = oppPartListLastPageProposal;
            }
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, system.Label.Delete_After_Save));
        }
        catch (Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Delete_Error   + e.getMessage()));    
        }
        return null;
        }
    }

   /**
    * This method is used to go to previous page for Proposal Parts list
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return             null
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */    
    public pageReference OppPartListPreviousPageProposal(){
        oppPartListPageNumberProposal--;
        return null;
    }

   
   /**
    * This method is used to go to next page for Proposal Parts list
    *
    @author Yinfeng Guo
    @created 2012-02-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return             null
    *
    @changelog
    * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */    
    public pageReference OppPartListNextPageProposal(){
        oppPartListPageNumberProposal++;
        return null;
    }  
    
    public  pageReference changeSalePartNumber(){
   
        set<Id> set_partIds = new set<Id>();
        map<Id, String> map_partId_oppyPartName = new map<Id, String>();
        map<Id, Id> map_partId_gpl = new map<Id, Id>();
        map<Id, String> map_partId_gplManager = new map<Id, String>();
        map<Id, String> map_partId_description = new map<Id, String>();
        map_partId_gplName = new map<Id, String>();
        for(OpportunityPartWrapper op : list_indexOpportunityParts){
            if(op.opportunityPart.Part__c != null &&  String.valueOf(op.opportunityPart.Part__c) != ''){
                set_partIds.add(op.opportunityPart.Part__c);
            }
        }
        for(Part__c p : [Select Id, Name, Description__c, GPL__c, Product_Hierarchy__r.Name,Product_Hierarchy__r.Product_Manager__r.name, Product_Hierarchy__c from Part__c where Id in: set_partIds]){
            //map_partId_oppyPartName.put(p.Id, p.Description__c);
            map_partId_gpl.put(p.Id, p.Product_Hierarchy__c);
            map_partId_gplName.put(p.Id, p.Product_Hierarchy__r.Name);
            map_partId_gplManager.put(p.Id,p.Product_Hierarchy__r.Product_Manager__r.name);
            map_partId_description.put(p.Id,p.Description__c);
        }
        for(OpportunityPartWrapper op : list_indexOpportunityParts){
            if(op.opportunityPart.Part__c != null &&  String.valueOf(op.opportunityPart.Part__c) != ''){
                op.productManager = map_partId_gplManager.get(op.opportunityPart.Part__c);
                op.GPLName = map_partId_gplName.get(op.opportunityPart.Part__c);
                op.opportunityPart.GPL__c = map_partId_gpl.get(op.opportunityPart.Part__c);
                op.opportunityPart.Temporary_Part_Name__c = map_partId_description.get(op.opportunityPart.Part__c);
            }
        }
        messageOnResult = false;
        return null;    
    
    }  
    /**
    * This method is used check for DND opportunities if closed date is in current Fiscal year or not :case 901402
    *
    @author Poonam Hedaoo
    @created 2017-11-07
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    @return             null
    *
    @changelog
    * 2017-11-07 Poonam Hedaoo <poonam.hedaoo@te.com>
    * - Created
    */ 
     public void closeDateValidationForDND(){
        showCloseDateError= false;
        if(opp.CloseDate < DND_CLOSED_OPP_ALLOW_TO_CHANGE__c.getInstance().START_DATE_WHEN_DND_CLOSED_OPP_ALLOW_TO__c && opp.RecordTypeID ==       Opportunity_Record_Type_Groups__c.getInstance('DND Opportunity').RecordTypeID__c){
             noCloseDateError=false;
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,DND_CLOSED_OPP_ALLOW_TO_CHANGE__c.getInstance().Error_Message__c));
             showCloseDateError=true;
        }
     }
    
}