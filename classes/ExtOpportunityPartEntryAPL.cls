/**
 *  This class used for managing Opportunity_Part__c and Part__c for APL
 *
 @author Padmaja Dadi.
 @created 2014-12-24
 @version 1.0.
 @since 33.0 (Force.com ApiVersion)
 *
 @changelog
 
 * 2014-12-24 Padmaja Dadi <padmaja.dadi@te.com>
 * - Created
 * 2018-01-03 RaviPrakash Soda 
 *-  Modified: line 217 - added one more profile name Appliance Inside Sales Playbook User. (|| profileName == 'Appliance Inside Sales Playbook User')
 */
public with sharing class ExtOpportunityPartEntryAPL {

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
            
    /**
     * the mode to tell us whether new or edit
     */ 
    public String mode { set; get; }
    
    /**
     * the object Opportunity_Part__c variable
     */ 
    public Opportunity_Part__c oppPart { set; get; }
           
    /**
     * this variable to tell us whether have saved
     */ 
    public Boolean isSaved { set; get;}
    
    public Boolean isValidEnter {set; get;}

    
    /**
     * opportunity can limit to only can be added sales part
     * if isOnlySales is true, then we can not add proposal part
     */ 
    public Boolean isOnlySales{ set; get; }
    
    /**
     * this variable to tell us whether have saved completed
     */ 
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
       
    public Integer deleteOpportunityPartIndexProposal {get; set;} 
    //sorting for part list
    public String oppPartListSortFieldProposal {get; set;}  
    public String oppPartListSortFieldPrevProposal {get; set;}    
    
    public List<OpportunityPartWrapper> list_indexOpportunityParts {get; set;}
    public List<OpportunityPartWrapper> list_indexOpportunityPartsProposal {get; set;}
    public boolean isAdmin {get;private set;}
      
    public boolean isChina{get;private set;}
    //private static final string CHINA_REGION = 'China / HK / Taiwan';
    public boolean isAPPL {get; set;}
      
       
    //12-29-2014 Nelson Zheng
    public String lostOpportunityAppliance{get;set;}
    
    //06/18/2015 Nelson Zheng
    public Boolean contactRoleValidPass{get;set;}
    public boolean isCSD = false;//added by Jinbo Shan 2014-11-17
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
   
    */      
    public ExtOpportunityPartEntryAPL(ApexPages.standardController stdCtrl) {
        this.stdCtrl = stdCtrl;    
        contactRoleValidPass = true;//Nelson Zheng 06/18/2015
        opp=new Opportunity();
        isValidEnter = true;
        idString = '';
        isSaved = true;
        isOnlySales = false;
        isSaveComplete = false;
        messageOnResult = false;
        validOpportunity = true;        
        this.isIncompleteNDROppty = false;        
        mode = '';
        addAmount = '1';
        oppyCurrencyIsoCode = 'USD';
        
        list_indexOpportunityParts = new List<OpportunityPartWrapper>();
        list_indexOpportunityPartsProposal = new List<OpportunityPartWrapper>();
        map_urlParams = ApexPages.currentPage().getParameters();
        
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

            opp = ClsOppyPartUtilAPL.getOpportunityById(opportunityId);
            //Added by Nelson Zheng 06/18/2015 for case 00832171
            List<OPportunity> validateList = new List<Opportunity>();
            validateList.add(opp);
            TEMarketing.OpportunityTriggerHandler handler = new TEMarketing.OpportunityTriggerHandler();
            Map<Id, String> err = handler.validateOpportunityContactRolesWithErrors(validateList);
            if(err.size() > 0){
                contactRoleValidPass = false;
            }
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
                if(opp.Competitor_Count__c == 0 && (profileName == 'Appliance Engineering User w/Cost' || profileName == 'Appliance Standard User'|| profileName == 'Appliance Inside Sales Playbook User' || profileName == 'Appliance User w/ Cost')){
                    validOpportunity = false;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Oppy_Appliance_Check));
                }
            }
            
            isChina = false;
            if(ClsOppyPartUtilAPL.set_chinaIndustry.contains(opp.Account.Customer_Industry__c) &&  opp.Account.Customer_Region__c == ClsOppyPartUtilAPL.CHINA_REGION){
                isChina = true; 
            }
            system.debug('tongxia isChina:' + isChina);
            
            
            getOpportunityParts();
            nbrProposalParts = 1;
            if(opportunityId != null){
                requestType = [SELECT Id, RecordTypeId, Request_Type__c FROM Opportunity where Id =: opportunityId].Request_Type__c;
                for(Opportunity o : [SELECT Id, RecordTypeId, RecordType.DeveloperName, Request_Type__c, CurrencyIsoCode FROM Opportunity where Id =: opportunityId]){//add CurrencyIsoCode
                     requestType = o.Request_Type__c;
                     oppyCurrencyIsoCode = o.CurrencyIsoCode;
                     
                     if(SalesOnlyRecordTypeId().contains(o.RecordTypeId)){
                        isOnlySales = true;
                        //12-29-2014 Nelson Zheng
                        if(Apex_Helper_Settings__c.getInstance('Lost Business - Appliances').Value__c == o.RecordTypeId){
                            lostOpportunityAppliance = 'Lost Opportunity-Appliances';
                        }else{
                            lostOpportunityAppliance = 'not Lost Opportunity-Appliances';
                        }
             }
                     //  According to custom setting show Propesol Part Button or not
                     if(Opportunity_Record_Type_Groups__c.getInstance(o.RecordType.DeveloperName) != null && Opportunity_Record_Type_Groups__c.getInstance(o.RecordType.DeveloperName).Is_Sales_Only__c){
                        isOnlySales = true;
                     }
                }
            }
            
           
                        
            //set table page sizes and result limit
            OrgWideSettings__c settingsObj;
            settingsObj = OrgWideSettings__c.getValues('Manage Part');
            
            if(settingsObj != null){  
                oppPartListPageSize = Integer.valueOf(settingsObj.Datatable_Page_Size__c);
                                
                oppPartListPageSizeProposal = Integer.valueOf(settingsObj.Datatable_Page_Size__c);
            }
            else{
                oppPartListPageSize = 6;
                oppPartListPageSizeProposal = 6;
            }
            
            oppPartListJumpToPage = oppPartListPageNumber;
            oppPartListJumpToPageProposal = oppPartListPageNumberProposal;
                        
            returnAfterSave = false;
            
            /** For NDR opportunity
            1. If the opportunity is of type NDR and is not complete
            2. Add page message to the page.                          
            **/ 
            if(opp.RecordTypeId == NDROpptyRecordTypeId() && !OpptyNDRForecastUtil.isOpportunityComplete(opp.NDR_Quote_Status_Description__c)){
                this.isIncompleteNDROppty = true;               
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.label.NDROpptyInCompleteError));
            }         
             isSPIN = false;
             isCSD = false;
         set<Id> set_csdIds = ClsOppyPartUtilAPL.getAllCSDOppyRecordType();
         if(set_csdIds.contains(opp.RecordTypeId)) {
             isCSD = true;
         }
            
        }
        catch (Exception e){
            if(opportunityId == null) ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Enter_Page_Wrong  ));  
            else ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Error_Loading_Page + e.getMessage()));  
            validOpportunity = false;  
        }       
    }
    
    /** Returns record type id for NDR opportunity **/
    public static Id NDROpptyRecordTypeId(){
        Id rt_id;
        if(Apex_Helper_Settings__c.getInstance('NDR Opportunity') != null) rt_id = Apex_Helper_Settings__c.getInstance('NDR Opportunity').Value__c;
        return rt_id;
    }    
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
   
    public static set<Id> SalesOnlyRecordTypeId(){
        Set<Id> rt_id = new Set<Id>();
        if(Apex_Helper_Settings__c.getInstance('Sales Parts Only') != null)           
            rt_id.add(Apex_Helper_Settings__c.getInstance('Sales Parts Only').Value__c); 
        if( Apex_Helper_Settings__c.getInstance('Sales Opportunity CSD') != null)
            rt_id.add(Apex_Helper_Settings__c.getInstance('Sales Opportunity CSD').Value__c);                       
        
        //26-12-2014 Nelson Zheng: update for case 00778426
        if( Apex_Helper_Settings__c.getInstance('Lost Business - Appliances') != null){
            rt_id.add(Apex_Helper_Settings__c.getInstance('Lost Business - Appliances').Value__c);
        }
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
        System.debug('-------------------entered-----------------------');
        
        Savepoint sp = Database.setSavepoint();       
        //START: Added by Jinbo Shan 2014-11-17 for CSD Opportunity
        if(isCSD){
            list<Opportunity_Part__c> list_oppyParts = new list<Opportunity_Part__c>();
            list<OpportunityPartWrapper> list_allOppyParts = new list<OpportunityPartWrapper>();
            list_allOppyParts.addAll(list_indexOpportunityParts);
            list_allOppyParts.addAll(list_indexOpportunityPartsProposal);
            for(OpportunityPartWrapper opw : list_allOppyParts) {
                list_oppyParts.add(opw.opportunityPart);
            }
            String stageName = getOppyPhase(opp,list_oppyParts);
            opp.StageName = (stageName == '' ? opp.StageName : stageName);
        }
        //END
            
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
           // if(opp.RecordTypeId != Apex_Helper_Settings__c.getInstance('Engineering Opportunity CSD Id').Value__c){        
            if(isAPPL && op.Send_to_RTS__c == 'Yes' && op.Customer_End_Product__c == null ) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  system.Label.Customer_End_Product_Required)); 
                return null;
            } //}
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
            System.debug('-----------list_indexOpportunityPartsProposal.isEmpty()----------'+list_indexOpportunityPartsProposal.isEmpty());
            if(!list_indexOpportunityPartsProposal.isEmpty()){                
                map<Id, list<Opportunity_Part__c>> map_oppyId_parts = new map<Id, list<Opportunity_Part__c>>();
                map_oppyId_parts.put(opportunityId,list_oppProposalParts2Upsert);
                map<Id,boolean> map_oppyId_isError = new map<Id,boolean>();
                system.debug('tongxia page call');
                if(opp.Request_Type__c == 'Extension'){
                    map_oppyId_isError = ClsOppyPartUtilAPL.validatePartManager(map_oppyId_parts,set_deletePartId);
                    System.debug('--------------map_oppyId_isError---------------'+map_oppyId_isError);
                    System.debug('--------------map_oppyId_isError.get(opportunityId)-----------------'+map_oppyId_isError.get(opportunityId));
                }
                if(map_oppyId_isError.containsKey(opportunityId) && map_oppyId_isError.get(opportunityId)){
                    ApexPages.Message msg;
                    
                    if(isChina){
                        msg = new ApexPages.Message(ApexPages.Severity.ERROR,  system.Label.Not_Same_Regional_PM);
                    }else{
                        msg = new ApexPages.Message(ApexPages.Severity.ERROR,  system.Label.Not_same_Approver_PM);
                    }
                    ApexPages.addMessage(msg);
                    return null;
                }else{
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
        Opportunity oppNew = ClsOppyPartUtilAPL.getOpportunityById(opportunityId);            
        if(oppNew.Manufacturing_Start_Date__c != opp.Manufacturing_Start_Date__c){
            opp = oppNew;
            Map<Date, Map<String, Map<Integer, Integer>>> map_date_startEndQuarter = ClsOppyUtilAPL.getFiveYearsInternal(new set<Date>{opp.Manufacturing_Start_Date__c});
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
                            year5Revenue += ClsOppyUtilAPL.transformIsoCode(ofc.Amount__c, ofc.CurrencyIsoCode, opp.CurrencyIsoCode);
                            year5Revenue_Cust += ClsOppyUtilAPL.transformIsoCode(ofc.Five_Year_Amount__c, ofc.CurrencyIsoCode, opp.CurrencyIsoCode);
                        }else{
                            year5Revenue += ofc.Amount__c;
                            year5Revenue_cust += ofc.Five_Year_Amount__c;
                        }
                    }                    
                }              
                if(ofc.Fiscal_Year__c != null && ofc.Fiscal_Quarter__c != null && ofc.Part__r.Status__c  !='Dead' && ofc.Part__r.Status__c  !='Lost' && ofc.Amount__c !=null){    
                    if(ofc.CurrencyIsoCode != opp.CurrencyIsoCode){
                        totalRevenue += ClsOppyUtilAPL.transformIsoCode(ofc.Amount__c, ofc.CurrencyIsoCode, opp.CurrencyIsoCode);
                        totalRevenue_Cust += ClsOppyUtilAPL.transformIsoCode(ofc.Five_Year_Amount__c, ofc.CurrencyIsoCode, opp.CurrencyIsoCode);
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
            update opp;
                
            if(opp.Program__c != null){
                List<Opportunity> list_opp = new  List<Opportunity>();
                Opportunity Program = new Opportunity();
                Program = [select Id, Amount,Five_Year_Revenue__c,Total_Opportunity_Value__c,Five_Year_Value__c,CloseDate,Manufacturing_Start_Date__c from Opportunity where id = : opp.Program__c];
                list_opp = [select Id,Amount,Total_Opportunity_Value__c,Five_Year_Value__c,Five_Year_Revenue__c from Opportunity where Program__c = : opp.Program__c];
                set<Opportunity> set_opp = new  set<Opportunity>();
                if(list_opp.size() > 0){           
                    set_opp.addAll(list_opp);
                    ClsOppyUtilAPL.updateProgramTotalFiveYearsAmount(Program,set_opp);                     
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
    public static String getOppyPhase(Opportunity oppy, list<Opportunity_Part__c> list_oppyParts) {
        String phase = '';
        list<String> list_confindences = new list<String>();
        for(Opportunity_Part__c part : list_oppyParts) {
            list_confindences.add(part.Status__c);
        }
        if(list_confindences.isEmpty()) {
            return phase;
        }
        list_confindences.sort();
        Integer maxIndex = list_confindences.size() - 1;
        //New               ==> all 10%
        if(list_confindences[0] == list_confindences[maxIndex] && list_confindences[0] == '10%') {
            phase = 'New';
            return phase;
        } 
        //Rejected – Closed ==> For engineering opportunity, Confidence of all parts =0%
        //Lost/Dead-Closed  ==> For sale opportunity, Confidence of all parts =0%
        if(list_confindences[0] == list_confindences[maxIndex] && list_confindences[0] == '0%') {
            phase = (oppy.RecordType.DeveloperName == 'Engineering_Opportunity_CSD' ? 'Rejected – Closed' : 'Lost/Dead-Closed');
            return phase;
        } 

        //Won/Closed        ==> All parts confidence = 75%  or At least one part confidence =75% and others  = 0%
        boolean isWon = true;
        for(String confindence : list_confindences) {
            isWon = ((confindence == '75%' || confindence == '0%') ? true : false);
        }
        phase = (isWon ? 'Won/Closed' : phase);
        return phase;
        //Won/Open          ==> At least one part confidence =75% and at least one other part is between 10% and 50% (inclusive).
        boolean isConfidence_75 = false, isConfidence_10_50 = false;
        for(String confindence : list_confindences) {
            isConfidence_75 = (confindence == '75%' ? true : false);
            isConfidence_10_50 = ((confindence >= '10%' && confindence <= '50%') ? true : false);
        }
        phase = ((isConfidence_75 && isConfidence_10_50) ? 'Won/Open' : phase);
        //Rejected-Open     ==> For engineering opportunity only, at least one P/N rejected, and others between 10% and 50% (inclusive).
        boolean isRejectOpen = true;
        for(String confindence : list_confindences) {
            isRejectOpen = ((confindence >= '10%' && confindence <= '50%') ? true : false);
        }
        phase = (isRejectOpen ? 'Rejected-Open' : phase);
        return phase;
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
        Set<String> set_totall = new Set<String>{'Id', 'Part__c', 'New_Part_Description__c', 'Comments__c','Initial_Order_Date__c', 'Product_Manager__c', 'Part__r.Name', 'Similar_TE_Part_Number__r.Name', 'GPL__r.Name', 'GPL__c', 'Opportunity__r.Manufacturing_Start_Date__c', 'Regional_PM_AP__c', 'Status_Reason__c'};
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
              if(oppPart.Initial_Order_Date__c == null && oppPart.Opportunity__r.Manufacturing_Start_Date__c !=null){
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
                if(oppPart.Initial_Order_Date__c == null && oppPart.Opportunity__r.Manufacturing_Start_Date__c !=null){
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
            //by Nelson Zheng 2015-01-09 make competitor of sales part the same as the opportunity competitor
            List<Opportunity_Competitor__c> oppCompetitorList = [select Id,Competitor__c from Opportunity_Competitor__c where Opportunity__c =: opportunityId limit 1];
            Opportunity_Competitor__c oppCompetitor = new Opportunity_Competitor__c();
            if(oppCompetitorList.size() > 0){
                oppCompetitor = oppCompetitorList[0];
            }
            
            //Added by Bin Yuan 2014-05-08 due to assign Confidence and process status for new added parts
            map<String, String> map_fieldKey_status = ClsOppyPartUtilAPL.getOppyPartDefaultConfidenceAndProcessStatus(opportunityId);  
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
                
                //26-12-2014 Nelson Zheng: update for case 00778426
                if(lostOpportunityAppliance == 'Lost Opportunity-Appliances'){
                    newPart.Status__c = 'Lost';
                    newPart.Process_Status__c = 'EOL';
                    newPart.Lost_Reason__c = 'Other';
                     //add by Nelson Zheng 2015-01-09 
                    newPart.Competitor__c = oppCompetitor.Competitor__c;      
                    
                }else{ 
                    //edit by Nelson Zheng 01/11/2016 for case 00900616 change default opportunity part confidence value to "weak"
                    //newPart.Status__c = ((isSPIN && map_fieldKey_status.containsKey('Confidence')) ? map_fieldKey_status.get('Confidence') : '50/50');
                    //newPart.Status__c = (isCSD ? '10%' :  newPart.Status__c);
                    newPart.Status__c = 'weak';
                    newPart.Process_Status__c = ((isSPIN && map_fieldKey_status.containsKey('ProcessStatus')) ? map_fieldKey_status.get('ProcessStatus') : 'Concept');       
                    newPart.Process_Status__c = (isCSD ? 'New Opportunity' :  newPart.Process_Status__c);
                }
                
                newPart.Sales_Price__c = 0; 
                newPart.CurrencyIsoCode = oppyCurrencyIsoCode; 
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
            map<String, String> map_fieldKey_status = ClsOppyPartUtilAPL.getOppyPartDefaultConfidenceAndProcessStatus(opportunityId);    
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
                    }
                    else if(requestType.contains(REQUESTTYPE_E)){
                        newPart.RecordTypeId = oppRTId('e');
                    }
                    
                    //setting defaults to avoid validation error
                    newPart.Quantity__c = 1;
                    newPart.Sales_Price__c = 0;
                     
                    //edit by Nelson Zheng 01/11/2016 for case 00900616 change default opportunity part confidence value to "weak"
                    //newPart.Status__c = ((isSPIN && map_fieldKey_status.containsKey('Confidence')) ? map_fieldKey_status.get('Confidence') : '50/50');
                    //newPart.Status__c = (isCSD ? '10%' :  newPart.Status__c);
                    newPart.Status__c = 'weak';
                    
                    newPart.CurrencyIsoCode = oppyCurrencyIsoCode;
                    newPart.Temporary_Part_Name__c = TempPart.Description__c;
                    newPart.Process_Status__c = ((isSPIN && map_fieldKey_status.containsKey('ProcessStatus')) ? map_fieldKey_status.get('ProcessStatus') : 'Concept');   
                    newPart.Process_Status__c = (isCSD ? 'New Opportunity' :  newPart.Process_Status__c);
                    newPart.Initial_Order_Date__c = opp.Manufacturing_Start_Date__c;  
                    //by nelson zheng 2014-12-30 change 'no' to 'yes'
                    newPart.Send_to_RTS__c = 'Yes';
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
        try{
            //get index of clicked row passed in from vf page and remove from list
            if(deleteOpportunityPartIndexProposal != null){
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
}