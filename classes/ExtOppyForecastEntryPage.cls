/**
*   extension for Opportunity forecast
*
@author bin yu
@created 2012-03-03
@version 1.0
@since 23.0
*
@changelog
* 2016-10-26 Prabhanjan N
* Adding ADM Recordtype variables for ADM Migration
* 2015-08-12 Mrunal Parate
* - Modified by Mrunal for Change channel opportunity at Header level project to make Process status field Read only for Channel
* 
* 2015-06-05 Nelson Zheng
* - Add some System.debug() to do some investigation.
*
* 2015-06-09 Prabhanjan
* - Adding modal window attributes, displayPopup , closePopup(), showPopup().
*
* 2015-02-25 Mrunal Parate
* - Modified by Mrunal for Case 00796862 to show standard price of part while creating forecast for two 
*    more Record Types i.e. IND - Engineering project and IND - Sales Project
* 2014-06-09 Michael Cui
* - Updated for Case 00677873: APL Oppty Part process status consolidation.
* 2014-04-25 bin yuan <bin.yuan@itbconsult.com>
* - Modified by bin yuan 2014-04-25 due to check current user if has the access to edit this opportunity 
    and add SPIN opportunity approval status check
* 2012-03-03 bin yu <bin.yu@itbconsult.com>
* - Created
* 2016-10-26 Mrunal Parate 
*-  Modified: For CCR Project:Make NDR Code generic for CCR. Move NDR record type reference from Apex_Helper_Settings__c to 'Opportunity Record type group' custom setting and create new record for CCR record type  in 'Opportunity record type group' custom setting
*-2017-11-07 Poonam Hedaoo
*-Modified editOppy method to check closed date is in current Fiscal Year or not if not the show error message, it will work only for DND Opportunities
*/

global without sharing class ExtOppyForecastEntryPage {
  
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    public Opportunity opportunity {get; set;}      
    public Boolean editMode {get; set;}
    public Boolean hasParts {get; set;}
    public Boolean hasForecasts {get; set;}
    public Integer newYears {get; set;}
    public String oneYear {get; set;}
    public Integer currentYear {get; set;}
    public String year2Delete {get; set;}
    public String format {get; set;}
    public Boolean isProgramLevel {get; set;}
    public Boolean validOpportunity {get; set;}
    public Opportunity_Forecast__c startDateForecast {get; set;}
    public List<SelectOption> list_otherYears {get; set;}
    public List<String> list_years;
    public List<ClsOppForecastStructure> list_forecastStructures; 
    public string debug_string{get;set;}
    public string saveString{get;set;}
    public boolean isDifferentMethod {get;set;}
    public boolean isError {get;set;}
    public List<PartStructure> Parts {get;set;}
    public boolean isAdmin {get;private set;}
    public boolean showEdit {get; set;}// Added by Mrunal for Case 901127
    
    // add lili 2014.03.18 begin 
    public string partIdPrice{get; set;}
    public map<Id, Decimal> map_partId_price;
    // add lili 2014.03.18 end 
    
    // add lili 2014.04.08 begin due to oppy Forecast approval 
    public boolean isAppOrIndBu{get;set;}
    public String str_mapPartId_listForecastHistoryStructure{get;set;}
    public decimal changePercentage {get;set;}
    public String BU;
    public String str_allChangeReasons {get; set;}
    public list<String> list_changeReasons {get; set;}
    public String selectedReason {get; set;}
    // add lili 2014.04.08 end
    
    //added by weihang 2014-03-11 begin
    public boolean isSPIN {get;set;}
    public boolean isDeadOrLost {get;set;}
    //added by weihang 2014-03-11 end
    
    //2014-06-09 Michael Cui
    public boolean isAPL {get;set;}
    //added by lei tang 2014-03-14 begin
    public string defaultConfidence {get;set;}
    public string defaultProcessStatus {get;set;}
    //added by lei tang 2014-03-14 end
    
    
    
    public Decimal d {get; set;} //added by Bhavya for teamup case 901348
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private final ApexPages.standardController stdCtrl;
    private transient Id programRecordTypeId;
    private transient Id oppyEngineeringRecordTypeId;
    // added lili 2014.03.20 begin
    //private transient Id oppySalesRecordTypeId; // Commented by Mrunal for Case 00796862 and created record in custom setting for same record types.
    private transient Id oppyProductPlatformId;
    // added lili 2014.03.20 end
    private Id forecastOppyRecordTypeId;
    private Id forecastPartRecordTypeId;  
    private transient String oldLevel;  
    private List<Opportunity_Part__c> list_parts;
    private Map<String, List<Opportunity_Forecast__c>> map_year_oppyForecast;
    private Map<String, Map<Id, List<Opportunity_Forecast__c>>> map_year_map_partId_oppyForecast;
    private map<String, Date> map_yearCounter_date = new map<String, Date>();
    private map<Id, String> map_oppyPartId_isoCode = new map<Id, String>();
    private List<Id> list_partIds;
    private Map<Id, Id> map_partId_oppyId = new Map<Id, Id>();
    public list<String> list_s {get;set;}
    private map<String, String> map_urlParams;//get URL params
    private Map<Id, Opportunity> map_id_opportunity;
    private set<String> set_fYears;
    private boolean isConflict;
    //added by weihang 2014-03-11
    private set<Id> set_rtIds = new set<Id>();
    private boolean hasEditAccess = true;
    private set<Id> recTypeIds = new set<Id>(); //Created by Mrunal for Case 00796862.
    public set<string> set_oppyRecordTypeId = new set<string>(); //Added by Mrunal for Change Channel Opportunities at header level Project
    public set<Id> dndRecType = new set<Id>(); //added by Nooreen for DND
    public boolean isDND {get;set;} //added by Nooreen for DND
    public boolean admrecordtypeid {get;set;} //ADM Migration 2016-10-26 Prabhanjan N
    public set<Id> ADMRecType = new set<Id>();// All ADM record types
    public boolean isHLC {get;set;} // Added by Mrunal to make Process status field Read only for Change Channel Opportunities at header level Project
     public boolean isDNDError{get;set;}//Added by Poonam to remove all the buttons when Error is shown for 901402
    
      public boolean isContactRoleMsg {get;set;}//Added  by Archana for team up case 901174

      
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- ///////////////////////////////////// 
    public ExtOppyForecastEntryPage(ApexPages.standardController stdCtrl) {
        try {
            admrecordtypeid = false;
            isConflict = false;
            isError = false;
             isDNDError =false;
             isContactRoleMsg =false;
            set_fYears = new set<String>();
            list_s = new List<String>();
            this.stdCtrl = stdCtrl;
            newYears = 1;
            oneYear = '';
            editMode = false; // by Fuqi 2012-10-29
            isDifferentMethod = false;
            hasParts = true;
            hasForecasts = true;
            validOpportunity = true;
            currentYear = system.today().year();
            list_otherYears = new List<SelectOption>();
            list_forecastStructures = new list<ClsOppForecastStructure>();
            Parts = new List<PartStructure>();
            isAPL = false;
            showEdit = false;// Added by Mrunal for Case 901127
           
            // add lili 2014.03.18 begin 
            partIdPrice = '';
            map_partId_price = new map<Id, Decimal>();
            // add lili 2014.03.18 end 
            
            // add lili 2014.04.08 begin due to oppy Forecast approval 
            this.isAppOrIndBu = false;
            this.str_mapPartId_listForecastHistoryStructure = '';
            this.changePercentage = 0;
            this.BU = '';
            this.str_allChangeReasons = '';
            this.list_changeReasons = new list<String>();
            this.selectedReason = '';
            // add lili 2014.04.08 end
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
            
            //Get Record types for which standard price should be displayed while creating forecast; added by Mrunal for Case 00796862.
            List<Opportunity_Record_Type_Groups__c> cusSet = Opportunity_Record_Type_Groups__c.getall().values();
                for (Opportunity_Record_Type_Groups__c rt : cusSet){
                    if(rt.Active__c && rt.Group__c == 'Part Std Price Display on Forecast' && rt.RecordTypeID__c != null)
                        recTypeIds.add(rt.RecordTypeID__c);
                    if(rt.Active__c && rt.Group__c == 'Change Channel Opportunities at header level' && rt.RecordTypeID__c!= null)//Added by Mrunal for Change Channel Opportunities at header level Project
                        set_oppyRecordTypeId.add(rt.RecordTypeID__c);
                        }
            system.debug('>>>@@@set_oppyRecordTypeId'+set_oppyRecordTypeId);
            // Change end by Mrunal for case 00796862
            
            if(map_urlParams.containsKey('mode')){
                editMode = map_urlParams.get('mode') == 'edit' ? true : false;
                
              
            }  
            
              //Archana: change for 901174 start
               if(map_urlParams.containsKey('isContactRoleMsg')){
                               
                               editMode = false; // by Fuqi 2012-10-29
                
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Opportunities that have 25% or greater probability require at least 1 Contact Role to be associated with the Opportunity.  To correct this, add a contact role by going to the contact role section.  Please ensure that you also associate any additional roles that are relevant.'));
                  //Archana: change for 901174 end
                           }
                     
            
            for (RecordType t : [Select Id, DeveloperName, SobjectType from RecordType where SobjectType = 'Opportunity_Forecast__c' or SobjectType = 'Opportunity']) {
                if(t.DeveloperName == 'Opportunity' && t.SobjectType == 'Opportunity_Forecast__c') forecastOppyRecordTypeId = t.Id;
                if(t.DeveloperName == 'Part') forecastPartRecordTypeId = t.Id;
                if(t.DeveloperName == 'Program' && t.SobjectType == 'Opportunity') programRecordTypeId = t.Id;
                if(t.DeveloperName == 'Opportunity_Engineering_Project' && t.SobjectType == 'Opportunity') oppyEngineeringRecordTypeId = t.Id; 
                // added lili 2014.03.20 begin due to  set default value only for oppyEngineeringRecordTypeId and oppySalesRecordTypeId 
                //if(t.DeveloperName == 'Opportunity_Sales_Parts_Only' && t.SobjectType == 'Opportunity') oppySalesRecordTypeId = t.Id; // Commented by Mrunal for Case 00796862 and created record in custom setting for same record types.
                // added lili 2014.03.20 end
                // added lili 2014.04.10 begin due to  approve only for oppyEngineeringRecordTypeId and oppyProductPlatformId 
                if(t.DeveloperName == 'Opportunity_Product_Platform' && t.SobjectType == 'Opportunity') oppyProductPlatformId = t.Id;
                // added lili 2014.04.10 end
                //system.debug('>>>>RecordType>>>>>'+t);
            }       
    
            list_years = new List<String>();
            if(UserInfo.getLocale().indexOf('de') != -1){
                format = 'de';
            }
            else{
                format = 'other';
            } 
            map_id_opportunity = new Map<Id, Opportunity>();        
    
            list_parts = new List<Opportunity_Part__c>();
            list_partIds = new List<Id>();
            
            startDateForecast = new Opportunity_Forecast__c();
            opportunity = (Opportunity) stdCtrl.getRecord(); 
            opportunity = ClsOppyForecastUtil.getOpportunityById(opportunity.Id);
            d= opportunity.Active_Opportunity_Parts__c; //added by Bhavya for 901348
            //added by Nooreen for DND on 08-06-15 begin
            isDND = false;
            isHLC = false; // Added by Mrunal to make Process status field Read only for Change Channel Opportunities at header level Project
            for(Opportunity_Record_Type_Groups__c rt : Opportunity_Record_Type_Groups__c.getall().values()){
                    if(rt.Active__c == true && rt.RecordTypeID__c != null && rt.Group__c == 'Process Status Display' )
                        dndRecType.add((Id)rt.RecordTypeID__c);
                    if(rt.Active__c && rt.Group__c == 'ADM Group' && rt.RecordTypeID__c!= null)//Added by Prabhanjan ADM Mifration
                            ADMRecType.add(rt.RecordTypeID__c);
            }             
            //added by Nooreen for DND on 08-06-15 end
            //added by weihang 2014-03-11 begin
            isSPIN = false;
            set_rtIds = ClsPMV_Util.getAllPMVRecordtypes();
            //2014-06-09 Michael Cui: updated for case 00677873
            set<Id> applianceOppRTId = ClsOppyForecastUtil.applianceOpptyRecordTypeId();
            // Added by Mrunal for Case 901127
            if(set_oppyRecordTypeId.contains(opportunity.RecordTypeId)){
                for(OpportunityFieldHistory ofh:[select id, createddate, createdbyId from OpportunityFieldHistory where OpportunityId=: opportunity.Id and field = 'Manufacturing_Start_Date__c' and createdDate> :Datetime.now().addSeconds(-10)]){
                    if(ofh.createdbyId ==UserInfo.getUserId()) showedit= true;
                }
            }
        // Change End by Mrunal for Case 901127
            //for(Opportunity o:[select Id,Name,RecordTypeId from Opportunity where Id=: opportunity.Id]){ 
            for(Opportunity o:[select Id,Name,RecordTypeId,Industry_Code__c,Owner.GIBU__c from Opportunity where Id=: opportunity.Id]){          
                if(set_rtIds.contains(o.RecordTypeId)) isSPIN = true;
                if(o.Industry_Code__c == 'Appliances' && o.Owner.GIBU__c == 'Appliances' && applianceOppRTId.contains(o.RecordTypeId)) isAPL = true;                
                if(dndRecType.contains(o.RecordTypeId)) isDND = true;
                if(set_oppyRecordTypeId.contains(o.RecordTypeId)) isHLC = true;// Added by Mrunal to make Process status field Read only for Change Channel Opportunities at header level Project
                if(ADMRecType.contains(o.RecordTypeId))   { admrecordtypeid=true; }
            }            
            //added by weihang 2014-03-11 end
            //added by bin yuan 2014-04-25 due to check current user if has the access to edit this opportunity
            for(UserRecordAccess access : [select HasEditAccess, RecordId from UserRecordAccess where RecordId =: opportunity.Id and UserId =: UserInfo.getUserId()]) {
                hasEditAccess = access.HasEditAccess;
            }
            //End
            // add lili 2014.04.08 begin due to oppy Forecast approval   
            BU = ClsOppyForecastUtil.getBU(opportunity);  
            isAppOrIndBu = ClsOppyForecastUtil.isAppOrIndBu(BU);

            if(isAppOrIndBu && (opportunity.RecordTypeId == oppyProductPlatformId || opportunity.RecordTypeId == oppyEngineeringRecordTypeId ) && opportunity.PLM_Id__c != null) {
                isAppOrIndBu = true;
            }else {
                isAppOrIndBu = false;
            }
            isAppOrIndBu = false;
            changePercentage = ClsOppyForecastUtil.getChangePercentage(BU);

            str_mapPartId_listForecastHistoryStructure = ClsOppyForecastUtil.getOppyForecastHistory(opportunity.Id);

            ClsOppyForecastUtil.getChangeReasons(list_changeReasons);
            str_allChangeReasons = Json.serialize(list_changeReasons);
            // add lili 2014.04.08 end 
    
            oldLevel = opportunity.Level__c;
            if(opportunity.Method__c == null) opportunity.Method__c = 'Manual';
            if(opportunity.Level__c == null) opportunity.Level__c = ClsOppyForecastUtil.QUARTERLY;
            
            if(opportunity.RecordTypeId == programRecordTypeId){
                map_id_opportunity = ClsOppyForecastUtil.getOpportunitysByProgramId(opportunity.Id);
                if(map_id_opportunity.isEmpty()){   
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,system.label.No_Opportunites));
                }   
                else{
                    isDifferentMethod = ClsOppyUtil.checkProgramOppyMethod(opportunity.Method__c, map_id_opportunity.values());
                    list_parts = ClsOppyForecastUtil.getAllPartsByProgramId(opportunity.Id);            
                }   
            }  
            else{
                map_id_opportunity.put(opportunity.id, opportunity);           
                if(opportunity.Program__c != null && opportunity.Program__r.Program_level_Forecasting__c){
                    isProgramLevel = true;
                }           
                list_parts = ClsOppyForecastUtil.getPartsByOppyId(new Set<Id>{opportunity.Id}); 
            }
              
            if(list_parts.isEmpty()){
                hasParts = false;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,system.label.No_Parts));             
            }
            else{   
                // add lili zhao 2014.03.18 begin
                map<Id, Opportunity_Part__c> map_partId_part = new map<Id, Opportunity_Part__c>();   
                // add lili zhao 2014.03.18 end  
                for(Opportunity_Part__c part: list_parts){
                    list_partIds.add(part.Id);
                    // add lili zhao 2014.03.18 begin
                    //if(opportunity.RecordTypeId == oppySalesRecordTypeId || opportunity.RecordTypeId == oppyEngineeringRecordTypeId) {// Commented by Mrunal for Case 00796862.
                    if (recTypeIds.contains(opportunity.RecordTypeId)){ // Added by Mrunal for Case 00796862.
                        Decimal price;
                        if(part.CurrencyIsoCode != null && opportunity.CurrencyIsoCode != null) {
                            price = ClsOppyForecastUtil.transformIsoCode(part.AverageSellPrice__c, part.CurrencyIsoCode, opportunity.CurrencyIsoCode); 
                        }else {
                            price = part.AverageSellPrice__c;
                        }                   
                        map_partId_price.put(part.Id, price); 
                    }else {
                         map_partId_price.put(part.Id, 0); 
                    }                
                    map_partId_part.put(part.Id, part);
                    // add lili zhao 2014.03.18 end
                    map_partId_oppyId.put(part.Id, part.Opportunity__c);
                    PartStructure ps = new PartStructure(part);
                    Parts.add(ps);              
                }  
                map_year_oppyForecast = ClsOppyForecastUtil.buildOppyForeCastMap(opportunity.Id);
                if(opportunity.RecordTypeId == programRecordTypeId){
                    map_year_map_partId_oppyForecast = ClsOppyForecastUtil.buildProgramAllPartForeCastMap(opportunity.Id);
                    if(map_year_map_partId_oppyForecast.isEmpty()){
                        //hasForecasts = false;                   
                        // create 5 year opportunity structure                      
                        newYears = 5;
                        // add lili zhao 2014.03.18 begin
                        //ClsOppyForecastUtil.addOppyYears(list_years, newYears, list_forecastStructures, opportunity, list_partIds); 
                        ClsOppyForecastUtil.addOppyYears(list_years, newYears, list_forecastStructures, opportunity, list_partIds, map_partId_price);    
                        // add lili zhao 2014.03.18 end   
                        list_otherYears = ClsOppyForecastUtil.getOtherYears(list_years);
                        hasForecasts = true;
                        newYears = 1;                                
                    }
                }
                else{
                    // when opportunity is engineering and stage is not new, edit button is not displayed
                    if(opportunity.StageName == 'In Approval') {
                        validOpportunity = false;
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Oppy_InApproval_Check));
                    }
                    //Added by Bin Yuan 2014-04-25 due to add if spin opportunity in approval status, edit button is not displayed
                    else if(isSPIN && opportunity.Approval_Status_PMV__c != null && opportunity.Approval_Status_PMV__c.contains('In Approval')) {
                        validOpportunity = false;
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Oppy_InApproval_Check));
                    }
                    //if current user has no access to edit this opporunity, edit button is not displayed
                    else if(!hasEditAccess) {
                        validOpportunity = false;
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, system.label.PMV_OppyForecast_No_Edit_Access));
                    }
                    //End
                    // when opportunity stage is Rejected - Closed, edit button is not displayed until set to New
                    else if(opportunity.StageName == 'Rejected - Closed'){
                        validOpportunity = false;    
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Oppy_RejectedClosed_Check));
                    }
                    else{
                        // when user is an appliance user and the opportunity has no assigned competitor
                        String profileName;
                        for(Profile p :[select name from Profile where id = :UserInfo.getProfileId()]){
                            profileName = p.name;
                        }
                        if(opportunity.Competitor_Count__c == 0 && (profileName == 'Appliance Engineering User w/Cost' || profileName == 'Appliance Standard User' || profileName == 'Appliance User w/ Cost'  || profileName == 'Appliance Inside Sales Playbook User' )){
                            validOpportunity = false;
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Oppy_Appliance_Check));
                        }
                    }               
                    map_year_map_partId_oppyForecast = ClsOppyForecastUtil.buildAllPartForeCastMap(opportunity.Id);                
                    if(map_year_oppyForecast.isEmpty()){
                        if(!editMode){
                            hasForecasts = false;
                            if(validOpportunity) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,system.label.No_Forecasts)); 
                        }
                        else{
                            // create 5 year opportunity structure                      
                            newYears = 5;
                            // add lili zhao 2014.03.18 begin
                            //ClsOppyForecastUtil.addOppyYears(list_years, newYears, list_forecastStructures, opportunity, list_partIds);  
                            ClsOppyForecastUtil.addOppyYears(list_years, newYears, list_forecastStructures, opportunity, list_partIds, map_partId_price); 
                            // add lili zhao 2014.03.18 end     
                            list_otherYears = ClsOppyForecastUtil.getOtherYears(list_years);
                            hasForecasts = true;
                            newYears = 1;
                        }
                    }
                }
                
                //list_forecastStructures = new List<ClsOppForecastStructure>();
                if(map_year_map_partId_oppyForecast.size() > 0){
                    list_years = ClsOppyForecastUtil.getYearList(map_year_map_partId_oppyForecast.keySet(), false, 0);
                    list_otherYears = ClsOppyForecastUtil.getOtherYears(list_years);
                }
                if(list_otherYears.size() > 0){
                    oneYear = list_otherYears[0].getValue();
                }
                /*if(!map_id_opportunity.isEmpty() && !map_partId_oppyId.isEmpty()){
                    //map_oppyPartId_isoCode
                    for(Id id : map_partId_oppyId.keySet()){
                        if(map_id_opportunity.get( map_partId_oppyId.get(id) ).CurrencyIsoCode != null)
                            map_oppyPartId_isoCode.put(id, map_id_opportunity.get( map_partId_oppyId.get(id) ).CurrencyIsoCode );
                    }
                }*/ //Modified by Jinbo Shan using following code replace that.
                //Start:
                if(!map_partId_part.isEmpty() && !map_partId_oppyId.isEmpty()) {
                  for(Id id : map_partId_oppyId.keySet()) {
                    if(map_partId_part.containsKey(id) && map_partId_part.get(id).CurrencyIsoCode != null) {
                      map_oppyPartId_isoCode.put(id, map_partId_part.get(id).CurrencyIsoCode);
                    }
                  }
                }
                //End:
                
                if(opportunity.RecordTypeId == programRecordTypeId && !hasForecasts) editOppy();
                if(!map_year_oppyForecast.isEmpty() || !map_year_map_partId_oppyForecast.isEmpty()){
                    buildStructures(map_year_oppyForecast, map_year_map_partId_oppyForecast, map_partId_oppyId, map_oppyPartId_isoCode, opportunity, list_years, list_partIds, map_partId_price); 
                    map_year_oppyForecast.clear();
                    map_year_map_partId_oppyForecast.clear();
                } 
                   
            }
            // added lili 2014.03.18 begin
            if(!map_partId_price.isEmpty()) {
                for(Id partId : map_partId_price.keySet()) {
                    partIdPrice += '[' + partId + ',' + map_partId_price.get(partId) + '];';
                }
                partIdPrice = partIdPrice.subString(0,partIdPrice.length()-1);
            }
            // added lili 2014.03.18 end
            System.debug('isConflict: ' + isConflict);
            if(isConflict && editMode && opportunity.Method__c == 'BOM') ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,system.label.RecalForcastDataConfict));
            else if((isConflict || isDifferentMethod) && opportunity.Method__c == 'BOM'){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,system.label.ForcastDataConfict));  
            } 
            
            /** For NDR opportunity
            1. If the opportunity is of type NDR and is not complete
            2. Add page message to the page.
            3. Set button controlling properties to false.              
            **/
            //Change Start by Mrunal for CCR Project
            //if(opportunity.RecordTypeId == NDROpptyRecordTypeId() && !OpptyNDRForecastUtil.isOpportunityComplete(opportunity.NDR_Quote_Status_Description__c)){
            Set<Id> rt_id = NDROpptyRecordTypeId();
            if(rt_id.contains(opportunity.RecordTypeId) && !OpptyNDRForecastUtil.isOpportunityComplete(opportunity.NDR_Quote_Status_Description__c)){
            //Change End by Mrunal for CCR Project
                this.validOpportunity = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.label.NDROpptyInCompleteError));
            }                  
            /** For NDR opportunity **/ 
            isDeadOrLost =((opportunity.StageName == 'Dead' || opportunity.StageName == 'Lost' || opportunity.StageName == 'On Hold') ? true : false);
      
            
        }
        catch(Exception ex) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, ex.getStackTraceString()));  
        }                            
    }
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////    
    
    //********************************* -=BEGIN public methods=- **********************************
   /**
    * The method is used to get confidence items.
    *
    @author Weihang Li
    @created 2014-03-11
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              
    *
    @changelog
    * 2014-03-13 Lei Tang <lei.tang@itbconsult.com>
    * - Modify 
    * 2014-03-11 Weihang Li <weihang.li@itbconsult.com>
    * - Created
    */
    public List<SelectOption> getConfidenceItem(){
        //List<SelectOption> list_options = new List<SelectOption>();
        //list_options.add(new SelectOption('--None--','--None--'));
        //list_options.add(new SelectOption('Dead','Dead'));
        //list_options.add(new SelectOption('Lost','Lost'));
        //return list_options;
        
        List<SelectOption> list_options = new List<SelectOption>();
        list_options.add(new SelectOption('--None--','--None--',true));
        Schema.DescribeFieldResult fieldResult = Opportunity_Part__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){
            if(f.getValue() == 'Dead' || f.getValue() == 'Lost'){
                list_options.add(new SelectOption(f.getLabel(), f.getValue()));
            }else{
                list_options.add(new SelectOption(f.getLabel(), f.getValue(),true));
            }
        }      
        return list_options;
        
    }
    /**
    * The method is used to get Process Status items.
    *
    @author Weihang Li
    @created 2014-03-11
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              
    *
    @changelog
    * 2014-03-11 Weihang Li <weihang.li@itbconsult.com>
    * - Created
    */
    public List<SelectOption> getProcessStatusItems(){
        List<SelectOption> list_options = new List<SelectOption>();
        //list_options.add(new SelectOption('--None--','--None--'));
        Schema.DescribeFieldResult fieldResult = Opportunity_Part__c.Process_Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        //2014-06-09 Michael Cui 
        if(isAPL)
        {
          if(Apex_Helper_Settings__c.getInstance('APL Oppty Part Process Status Value') != null && Apex_Helper_Settings__c.getInstance('APL Oppty Part Process Status Value').Active__c && Apex_Helper_Settings__c.getInstance('APL Oppty Part Process Status Value').value__c != null)
          {
              String[] processStatusValue = Apex_Helper_Settings__c.getInstance('APL Oppty Part Process Status Value').value__c.split(';');
            for(Integer i=0; i< processStatusValue.size(); i++)
            {
              list_options.add(new SelectOption(processStatusValue[i],processStatusValue[i]));
            }
          }
          //list_options.add(new SelectOption('Concept','Concept'));
          //list_options.add(new SelectOption('Designed','Designed'));
          //list_options.add(new SelectOption('Pre-prod','Pre-prod'));
          //list_options.add(new SelectOption('Production','Production'));
          //list_options.add(new SelectOption('Ramp-down','Ramp-down'));
          //list_options.add(new SelectOption('EOL','EOL'));
          
          // Change: Pankaj Raijade: Case: 00900799: 21-4-2015: Start
        } else if(isDND) {

          system.debug('>>>>>>>>>>>Enter DND from here>>>>>>>');
          System.debug('>>>>>>>>>>>Apex_Helper_Settings__c.getOrgDefaults()>>>>>>>' + Apex_Helper_Settings__c.getInstance('DND Oppty Part Process Status Value').value__c );
          // Updated Raul 2016.04.18 Begin
          if(Apex_Helper_Settings__c.getInstance('DND Oppty Part Process Status Value') != null && Apex_Helper_Settings__c.getInstance('DND Oppty Part Process Status Value').Active__c && Apex_Helper_Settings__c.getInstance('DND Oppty Part Process Status Value').value__c != null)
          {
              system.debug('>>>>>>>>>>>DND Oppty Part Process Status Value>>>>>>>'+ Apex_Helper_Settings__c.getInstance('DND Oppty Part Process Status Value').value__c);
              String[] processStatusValue = Apex_Helper_Settings__c.getInstance('DND Oppty Part Process Status Value').value__c.split(';');
              for(Integer i=0; i< processStatusValue.size(); i++)
              {
                  list_options.add(new SelectOption(processStatusValue[i],processStatusValue[i]));
              }
          }



          // Change: Pankaj Raijade: Case: 00900799: 21-4-2015: End
        }
        else
        {
          list_options.add(new SelectOption('--None--','--None--'));       
          for( Schema.PicklistEntry f : ple){
            list_options.add(new SelectOption(f.getLabel(), f.getValue()));
          } 
        } 
        return list_options;
    }
    /**
    * The method is used to reactive forecast.
    *
    @author Weihang Li
    @created 2014-03-11
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              
    *
    @changelog
    * 2014-03-11 Weihang Li <weihang.li@itbconsult.com>
    * - Created
    */
    public void reActiveForecast(){
        
    }
    
    /** Returns record type id for NDR opportunity **/
    public static set<Id> NDROpptyRecordTypeId(){
        //Chnage start by Mrunal for CCR Project
        /*Id rt_id;
        if(Apex_Helper_Settings__c.getInstance('NDR Opportunity') != null){
            rt_id = Apex_Helper_Settings__c.getInstance('NDR Opportunity').Value__c;
        }*/
        Set<Id> rt_id = new Set<Id>();

        for (Opportunity_Record_Type_Groups__c rt : Opportunity_Record_Type_Groups__c.getall().values()){
            if(rt.Active__c && rt.Group__c == 'RFQ 2.0 Quotes' && rt.RecordTypeID__c!= null)
                rt_id.add(rt.RecordTypeID__c);
        }
        // Change End by Mrunal for CCR Project
        return rt_id;
    }  
    
    public static Map<String, List<Opportunity_Forecast__c>> buildOppyForeCastMap(Id oppyId){
        Map<String, List<Opportunity_Forecast__c>> map_oppyForeCasts = new Map<String, List<Opportunity_Forecast__c>>();
        for(Opportunity_Forecast__c ofc : [select Id, RecordTypeId, Fiscal_Year__c, Date__c, Sales_Price__c, Quantity__c, Five_Year_Amount__c, Amount__c, Opportunity__c, Part__c,Part__r.Status__c, Forecasting_Start_Date__c from Opportunity_Forecast__c where Opportunity__c = :oppyId and Part__c = null and Date__c != null order by Date__c ]){
            String year = ofc.Fiscal_Year__c;
            if(year == null){
                year = String.valueOf(ofc.Date__c.Year());
            }
            
            if(!map_oppyForeCasts.containsKey(year)){
                map_oppyForeCasts.put(year, new List<Opportunity_Forecast__c>{});
            }
            map_oppyForeCasts.get(year).add(ofc);
        }
        return map_oppyForeCasts;
    }
    
    /**
    * The method is used to get forecast structures
    *
    @author Bin yu
    @created 2012-03-03
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              
    *
    @return             list of forecast structures
    *
    @changelog
    * 2012-03-03 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public list<ClsOppForecastStructure> buildStructures(Map<String, List<Opportunity_Forecast__c>> map_oppyForeCasts, Map<String, Map<Id, List<Opportunity_Forecast__c>>> map_year_map_partId_oppyForecast, Map<Id, Id> map_partId_oppyId, map<Id, String> map_oppyPartId_isoCode, Opportunity oppy, List<String> list_years, List<Id> list_partIds, map<Id, Decimal> map_partId_price){
        list_forecastStructures.clear();      
        Map<String, Decimal> map_currency_rate = new Map<String, Decimal>();  
        map<String, Decimal> map_isoCode_exchangeRate = new map<String, Decimal>(); 
        for(CurrencyType ct : [SELECT IsoCode, ConversionRate from CurrencyType where IsActive = true]){
            map_isoCode_exchangeRate.put(ct.IsoCode, ct.ConversionRate);
        }        
        for(String year: list_years){
            ClsOppForecastStructure OppyForecastStructure = new ClsOppForecastStructure(year);
            list_forecastStructures.add(OppyForecastStructure);
            ClsOppForecastStructure.ForecastStructure fcs  = new ClsOppForecastStructure.ForecastStructure();
            OppyForecastStructure.forecastStructure = fcs ;
            List<Opportunity_Forecast__c> oppyForecasts = new List<Opportunity_Forecast__c>();
            if(map_oppyForeCasts.containsKey(year)) oppyForecasts = map_oppyForeCasts.get(year);
            
            ClsOppyForecastUtil.buildStrucureItems(oppy,oppyForecasts, fcs.editForecasts);
            integer i = 0;
            for(Id pid :list_partIds){
                ClsOppForecastStructure.PartForecastStructure fc = new ClsOppForecastStructure.PartForecastStructure(); 
                OppyForecastStructure.partForecasts.add(fc);
                //price currency transfer(only one time)     
                    
                if(map_year_map_partId_oppyForecast.containsKey(year) && map_year_map_partId_oppyForecast.get(year).containsKey(pid)){
                    fc.salesPrice = map_year_map_partId_oppyForecast.get(year).get(pid).get(0).Sales_Price__c;
                    String partCurrencyIsoCode = map_oppyPartId_isoCode.get(pid);
                    if(partCurrencyIsoCode != oppy.CurrencyIsoCode){
                        //Decimal rate = getRate(partCurrencyIsoCode, oppy.CurrencyIsoCode, map_currency_rate);
                        //fc.salesPrice = fc.salesPrice * rate;
                        fc.salesPrice = ClsOppyForecastUtil.transformIsoCode(fc.salesPrice, partCurrencyIsoCode, oppy.CurrencyIsoCode);                     
                    }
                    if(fc.salesPrice != null) fc.salesPrice = fc.salesPrice.setScale(5);        
                    //OppyForecastStructure.partForecasts.add(fc);
                    //generate past forecast structure include transfer to other level
                    ClsOppyForecastUtil.buildPartStrucureItems(oppy,map_year_map_partId_oppyForecast.get(year).get(pid),fc.quantitys);
                    //conflict handling
                    //system.debug('>>>>>>>>>>>'+list_parts.size());
                    if(!isConflict){
                    
                        if(i < list_parts.size()){
                            isConflict = ClsOppyForecastUtil.checkConflict(list_parts.get(i).Quantity__c,fc.quantitys,fcs.editForecasts);
                        }
                        
                        
                    }
                                    
                }
                else{
                    if(map_partId_price.containsKey(pid)) {
                        fc.salesPrice = map_partId_price.get(pid);
                    }else{
                        fc.salesPrice = 0;
                    }
                    ClsOppyForecastUtil.buildPartStrucureItems(oppy, new List<Opportunity_Forecast__c>(), fc.quantitys);    
                }
                i++;            
            } 
        }
        return list_forecastStructures;             
    }   
    public PageReference saveOppy(){
    
     
     
    if(checkRecursive.runOnce()){
        isConflict = false;
        
        system.debug('111111111111111111 - '+saveString);
        system.debug('222222222222222222- '+parts);
        system.debug('333333333333333333- '+list_parts);
        
        Savepoint sp = Database.setSavepoint();
        
        
        if(isAPL)
        {
          for(Opportunity_Part__c op: list_parts)
          {
            for(PartStructure p : parts)
            {
              if(p.part.Id == op.Id && p.part.Process_Status__c == 'Production')
              {
                if(p.billingDate != '')
                {
                  if(p.billingDate.contains('/'))
                    op.initial_billing_date__c = Date.parse(p.billingDate);
                  else if(p.billingDate.contains('-'))
                    op.initial_billing_date__c = Date.valueOf(p.billingDate);
                }
                if(p.orderDate != '')
                {
                  if(p.orderDate.contains('/'))
                    op.initial_order_date__c   = Date.parse(p.orderDate);
                  else if(p.orderDate.contains('-'))
                    op.initial_order_date__c   = Date.valueOf(p.orderDate);
                }
                break;
              }
            }
          }
        }
        
        system.debug('prabha111111111111111111 - '+saveString);
        system.debug('prabha222222222222222222 - '+parts);
        system.debug('prabha333333333333333333 - '+list_parts);
        
        ClsOppyForecastUtil.saveProgram(saveString, list_forecastStructures, list_parts, list_partIds, opportunity, forecastOppyRecordTypeId, forecastPartRecordTypeId, map_oppyPartId_isoCode, map_partId_oppyId,set_fYears);
        
       
        system.debug('prabha000000000000000000 - '+saveString);
        system.debug('prabha20000000000000000 - '+parts);
        system.debug('prabha30000000000000000 - '+list_parts);
        
         //system.debug('.....Test 1--'+ApexPages.hasMessages());
        if(ApexPages.hasMessages()){
            isError = true;
            Database.rollback(sp);            
            return null;           
        }
        
        // re-get the opportunity stageName as stage is changed
         //Added By Bhavya for team up case 901348
         Opportunity opp = ClsOppyForecastUtil.getOpportunityById(opportunity.Id); 
         opportunity.stageName = opp.stageName; 
         if(opp.Active_Opportunity_Parts__c == 0 && opp.Record_Type_Name__c == 
         'DND_Opportunity' && d != 0){ 
         opportunity.CloseDate = Date.today(); 
         }
         //End code
        map_id_opportunity.clear();
        
        map_id_opportunity.put(opportunity.Id, opportunity);
        //calculate opportunity amounts
        
        ClsOppyForecastUtil.updateOpportunityAmounts(map_id_opportunity, opportunity.Method__c, opportunity.Level__c, opportunity);
        
        if(ApexPages.hasMessages()){
            isError = true;
            Database.rollback(sp);
            return null;
        }
        // add lili 2014.04.08 begin due to oppy Forecast approval 
         system.debug('str_mapPartId_listForecastHistoryStructure :::'+str_mapPartId_listForecastHistoryStructure );
        if(isAppOrIndBu && str_mapPartId_listForecastHistoryStructure != '' ) {
            ClsOppyForecastUtil.saveOppForecastHitory(str_mapPartId_listForecastHistoryStructure,opportunity, this.selectedReason);
            str_mapPartId_listForecastHistoryStructure = '';
        }
        // add lili 2014.04.08
        if(saveString == 'Completed'){
            //2012-12-06 by Fuqi Tan -- let page js do refresh,otherwise oncomplete can not work
            //PageReference pf = new PageReference('/apex/ExtOppyForecastEntryPage?Id=' + opportunity.Id + '&mode=view');         
            //pf.setRedirect(true);        
            //return pf;
            return null;
        }
    } 
        return null;
   } 
    public PageReference saveProgram(){
    if(checkRecursive.runOnce()){
    
    
        system.debug('prabha - '+saveString);
        system.debug('prabha2 - '+parts);
        system.debug('prabha3 - '+list_parts);
        
    
        isConflict = false;
        Savepoint sp = Database.setSavepoint();
        ClsOppyForecastUtil.saveProgram(saveString, list_forecastStructures, list_parts, list_partIds, opportunity, forecastOppyRecordTypeId, forecastPartRecordTypeId, map_oppyPartId_isoCode, map_partId_oppyId,set_fYears);
        if(ApexPages.hasMessages()){
            isError = true;
            Database.rollback(sp);
            return null;           
        }   
        
        // re-get the opportunity stageName as stage is changed
        opportunity.stageName = ClsOppyForecastUtil.getOpportunityById(opportunity.Id).stageName;
        ClsOppyForecastUtil.updateOpportunityFromForecast(opportunity.Id, forecastOppyRecordTypeId);
        if(ApexPages.hasMessages()){
            isError = true;
            Database.rollback(sp);
            return null;
            //calculate opportunity amounts
            map_id_opportunity.put(opportunity.Id, opportunity); 
            ClsOppyUtil.updateOpportunityAmounts(map_id_opportunity, 'BOM', opportunity.Level__c, opportunity);
            if(ApexPages.hasMessages()){
                isError = true;
                Database.rollback(sp);
                return null;
            }
        }
        
        //calculate opportunity amounts
        map_id_opportunity.put(opportunity.Id, opportunity); 
        ClsOppyForecastUtil.updateOpportunityAmounts(map_id_opportunity, 'BOM', opportunity.Level__c, opportunity);
        if(ApexPages.hasMessages()){
            isError = true;
            Database.rollback(sp);
            return null;
        }
        // add lili 2014.04.08 begin due to oppy Forecast approval 
         system.debug('str_mapPartId_listForecastHistoryStructure :::'+str_mapPartId_listForecastHistoryStructure );
        if(isAppOrIndBu && str_mapPartId_listForecastHistoryStructure != '' ) {
            //system.debug('--==str_mapPartId_listForecastHistoryStructure==--'+str_mapPartId_listForecastHistoryStructure);
            ClsOppyForecastUtil.saveOppForecastHitory(str_mapPartId_listForecastHistoryStructure,opportunity, this.selectedReason);
            str_mapPartId_listForecastHistoryStructure = '';
        }
        // add lili 2014.04.08 end
        if(saveString == 'Completed'){
            //PageReference pf = new PageReference('/apex/ExtProgramOppyForecast?Id=' + opportunity.Id);//2012-12-06 by Fuqi Tan  
            //-- let page js do refresh,otherwise oncomplete can not work        
            //pf.setRedirect(true);        
            //return pf;
            return null;
        }
    }
        return null;
    }
    //********************************* -=BEGIN public methods=- **********************************
    /**
    * The method is used to get forecast structures
    *
    @author Bin yu
    @created 2012-03-03
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              
    *
    @return             list of forecast structures
    *
    @changelog
    * 2012-03-03 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */

    public List<ClsOppForecastStructure> getForecastStructures(){
        //system.debug('tongixa ForecastStructures：' + list_forecastStructures);
        return list_forecastStructures;
    }    
    /**
    * The method is used to get every parts
    *
    @author Bin yu
    @created 2012-03-03
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              
    *
    @return             list of every parts
    *
    @changelog
    * 2012-03-03 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    /*
    public List<PartStructure> getParts() {
        List<PartStructure> strcutures = new List<PartStructure>();  
        for(Opportunity_Part__c Part:list_parts){
            PartStructure ps = new PartStructure(part);
            strcutures.add(ps);
        }
        return strcutures;
    }   
    */
    /**
    * The method is used to get the labels of levels
    *
    @author Bin yu
    @created 2012-03-03
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              
    *
    @return             the labels of levels
    *
    @changelog
    * 2012-03-03 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public List<String> getLevelLabel(){
        return ClsOppyForecastUtil.getLevelLabel(opportunity.Level__c ); 
    }
    /**
    * The method is used to get status select options
    *
    @author Bin yu
    @created 2012-03-03
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              
    *
    @return             status select options
    *
    @changelog
    * 2012-03-03 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public List<SelectOption> getStatusItems(){
        return ClsOppyForecastUtil.getStatusItems();
    }
    /**
    * The method is used to get the forecast levels(yearly, quarterly or monthly)
    *
    @author Bin yu
    @created 2012-03-03
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              
    *
    @return             the forecast levels(yearly, quarterly or monthly)
    *
    @changelog
    * 2012-03-03 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */          
    public List<SelectOption> getForecastLevel(){
        if(isAPL)
            return ClsOppyUtil.getForecastLevelNoYear();
        else
            return ClsOppyUtil.getForecastLevel();
    }
     /**
    * The method is used to get the forecast methods
    *
    @author Bin yu
    @created 2012-03-03
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              
    *
    @return             the forecast methods(bom or manual)
    *
    @changelog
    * 2012-03-03 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public List<SelectOption> getForecastMethod(){
        List<SelectOption> list_forecastMethod = new List<SelectOption>();
        
        list_forecastMethod.add(new SelectOption('BOM', 'BOM'));
        list_forecastMethod.add(new SelectOption('Manual', 'Manual'));
        
        return list_forecastMethod;
    } 
     /**
    * The method is the cancel method(back to opportunity level)
    *
    @author Bin yu
    @created 2012-03-03
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param    
    *
    @return            
    *
    @changelog
    * 2012-03-03 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public PageReference cancelToOppy(){
        PageReference pageRef = new PageReference('/apex/ExtOppyForecastEntryPage?id=' + opportunity.Id);           
        pageRef.setRedirect(true);
        editMode = false;
        return pageRef;
    }
    
    
     /**
    * The method is the cancel method(back to program)
    *
    @author Bin yu
    @created 2012-03-03
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param    
    *
    @return            
    *
    @changelog
    * 2012-03-03 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public PageReference cancelToProgram(){
        PageReference pageRef = new PageReference('/apex/ExtProgramOppyForecast?id=' + opportunity.Id);           
        pageRef.setRedirect(true);
        editMode = false;
        return pageRef;
    }
     /**
    * The method is the edit method
    *
    @author Bin yu
    @created 2012-03-03
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param    
    *
    @return            
    *
    @changelog
    * 2012-03-03 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */  
    public PageReference editOppy(){
         
          PageReference pr = new PageReference('/apex/ExtOppyForecastEntryPage?Id='+ opportunity.Id+ '&mode=edit');
        // Added by Archana for TeamUp case- 00901174-- change start
          List<OPportunity> validateList = new List<Opportunity>();
        validateList.add(opportunity);
        TEMarketing.OpportunityTriggerHandler handler = new TEMarketing.OpportunityTriggerHandler();
        Map<Id, String> err = handler.validateOpportunityContactRolesWithErrors(validateList);
       
        if(err.size() > 0){
               isError = true;
     
          PageReference pageRef = new PageReference('/apex/ExtOppyForecastEntryPage?id=' + opportunity.Id+ '&isContactRoleMsg=true');           
        pageRef.setRedirect(true);
        editMode = false;
        return pageRef;
    }
             
                    
            
       // Added by Archana for TeamUp case- 00901174-- change end
            
   
   
    //Added by Poonam for TeamUp case- 00901402-- change start
        if(opportunity.CloseDate < DND_CLOSED_OPP_ALLOW_TO_CHANGE__c.getInstance().START_DATE_WHEN_DND_CLOSED_OPP_ALLOW_TO__c && opportunity.RecordTypeID ==  Opportunity_Record_Type_Groups__c.getInstance('DND Opportunity').RecordTypeID__c){
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,DND_CLOSED_OPP_ALLOW_TO_CHANGE__c.getInstance().Error_Message__c));
            editMode = true;
            hasParts=false;
            isDNDError =true;
            pr =null;
        }
        //Added by Poonam for TeamUp case- 00901402-- change end
        else{
                pr.setRedirect(true);
        }
    
                   return pr;
    } 
     /**
    * The method is the edit method
    *
    @author Bin yu
    @created 2012-03-03
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param    
    *
    @return            
    *
    @changelog
    * 2012-03-03 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */  
    public PageReference editPrograms(){
        PageReference pr = new PageReference('/apex/ExtProgramOppyForecastEntry?Id='+ opportunity.Id+ '&mode=edit');
        pr.setRedirect(true);
        return pr;
    }
    /**
    * The method is the get reactive ConfidenceAndProcessStatus of Opportunity Parts by custom setting
    *
    @author Lei Tang
    @created 2012-03-13
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param  oppyId          string              Opportunity id
    *
    @return                 string              json custom setting maps (Template: {"ProcessStatus":"Production","Confidence":"Won"} )
    *
    @changelog
    * 2012-03-13 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
    public void getOppyPartDefaultConfidenceAndProcessStatus(){
        /*
        Opportunity tempoppy = null;
        for(Opportunity opp : [Select Id,PMV_Type__c,StageName,RecordType.BusinessProcessId  from Opportunity where Id=:opportunity.Id]){
            tempoppy = opp;
        }

        Map<String, PMV_Sales_Stage_Setting__c> allstates = PMV_Sales_Stage_Setting__c.getAll();
        for(PMV_Sales_Stage_Setting__c state : allstates.values()) {
            if(state.Active__c == true
                && state.Sales_Process_ID__c == tempoppy.RecordType.BusinessProcessId
                && state.PMV_Type__c == tempoppy.PMV_Type__c
                && state.Sales_Stage__c == tempoppy.StageName){
                
                if(state.Opportunity_Parts_Confidence__c != null){
                    defaultConfidence = state.Opportunity_Parts_Confidence__c;
                }else{
                    defaultConfidence = '';
                }
                if(state.Opportunity_Parts_Process_Status__c != null){
                    defaultProcessStatus = state.Opportunity_Parts_Process_Status__c;
                }else{
                    defaultProcessStatus = '';
                }
            }
        }
        */


        // Pankaj Raijade: Update: 21-4-2016: Case: 00900799: Start: Commenting unnecessary code
        map<string,string> map_status = new map<string,string>();
        map_status = ClsOppyPartUtil.getOppyPartDefaultConfidenceAndProcessStatus(opportunity.Id);
        if(!map_status.isEmpty()) {
            if(map_status.containsKey('Confidence')) defaultConfidence = map_status.get('Confidence');
            if(map_status.containsKey('ProcessStatus')) defaultProcessStatus = map_status.get('ProcessStatus');
        }
// Pankaj Raijade: Update: 21-4-2016: Case: 00900799: end: Commenting unnecessary code


    }
    //********************************* -=BEGIN inner classes=- ***********************************           
    ///*>>>WrapperClass*/  
    public Class PartStructure{
        public String oldStatus {get; set;}
        public String billingDate {get; set;}
        public String orderDate {get; set;}
        public Opportunity_Part__c part {get; set;}
        // Part Description
        public transient String partName {get; set;}
        // Part Number
        public transient String partNumber {get; set;}
        //public String oppyName {get; set;}
        
          public PartStructure(ExtOppyForecastEntryPage ext)
        {
       
        }
        public PartStructure(Opportunity_Part__c part){
            this.part = part;
            oldStatus = part.Status__c;
            partNumber = part.Part__r.Name;//added by xia 2013-01-28
            //added by Michael Cui 2014-08-04
            if(part.initial_billing_date__c == null)
              billingDate = '';
            else 
              billingDate = String.valueOf(part.initial_billing_date__c);
            orderDate = String.valueOf(part.initial_order_date__c);
            //oppyName = part.Opportunity__r.Name;
            // Sales Parts
           //Added by Archana for team up case 726046 
           if(part.RecordType.Name == 'Sales Parts' || part.RecordType.Name == 'NDR Opportunity Parts' ){ 
                // Part Number
                partNumber = part.Part__r.Name;
                // part Description
                partName = part.Part_Name__c;
            }
            // Proposal Parts
            else{
                // Part Number
                if(part.GPL__c == null){
                    if(part.Similar_TE_Part_Number__r.Name != null){
                        partNumber = part.Similar_TE_Part_Number__r.Name;
                    }else{
                        partNumber = part.part__r.Name;
                    }
                }
                // part Description
                partName = part.New_Part_Description__c;
            }
        }
    }
    
    //prabhanjan , a simple method
    public string tam(){
        return null;
    }
    
    public class ForecastHistoryStructure{
        public String fiscalYear {get; set;}
        //public String oppyPartId {get; set;}
        //public String oppyId {get; set;}   
        public decimal newValue {get; set;}
        public decimal oldValue {get; set;} 
        //public decimal changePercentage {get; set;}
        
        public ForecastHistoryStructure(String fYear,decimal newValue, decimal oldValue) {
            this.fiscalYear = fYear;
            //this.oppyPartId = partId;
            //this.oppyId = oppyId;
            this.newValue = newValue;   
            this.oldValue = oldValue;
            //this.changePercentage = percent;   
        }
    }
      
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
}