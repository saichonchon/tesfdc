/**
*   util class for opptunity forecast
*
@author Lei Tang
@created 2017-02-22
@version 1.0
@since 35.0 (Force.com ApiVersion)
*
@changelog   
* 2017-02-22 Lei Tang <lei.tang@capgemini.com>
* - Created
*/
public with sharing class LtngOpportunityForecastCtrl {
    
    public static final map<String, String> MAP_MONTHLABELNUMBER = new map<String, String>{
        'Jan' => '04', 'Feb' => '05', 'Mar' => '06', 'Apr' => '07', 'May' => '08', 'Jun' => '09',
        'Jul' => '10', 'Aug' => '11', 'Sep' => '12', 'Oct' => '01', 'Nov' => '02', 'Dec' => '03'
    };
    
    public static final map<String, String> MAP_MONTHNUMBERLABEL = new map<String, String>{
        '01' => 'Oct', '02' => 'Nov', '03' => 'Dec', '04' => 'Jan', '05' => 'Feb', '06' => 'Mar',
        '07' => 'Apr', '08' => 'May', '09' => 'Jun', '10' => 'Jul', '11' => 'Aug', '12' => 'Sep'
    };
    
    public static final map<String, String> MAP_MONTHFORQUARTER = new map<String, String>{
        '01' => '01', '02' => '04', '03' => '07', '04' => '10'
    };
    
    public static final map<String, String> MAP_QUARTERFORMONTH = new map<String, String>{
        '01' => '01', '02' => '01', '03' => '01', '04' => '02', '05' => '02', '06' => '02',
        '07' => '03', '08' => '03', '09' => '03', '10' => '04', '11' => '04', '12' => '04'
    };
    
    public static final map<String, String> MAP_LEVELLABEL = new map<String, String>{
        'Quarter'=>'Quarterly','Month'=>'Monthly','Year'=>'Yearly'};
        
    /**
    * added by simon @2017-11-17
    * The method is the get reactive ConfidenceAndProcessStatus of Opportunity Parts by custom setting
    *
    @author Lili Zhao
    @created 2014-03-17
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param  oppyId      string          Opportunity id
    *
    @return         string        custom setting maps (Template: {"ProcessStatus":"Production","Confidence":"Won"} )
    *
    @changelog
    * 2014-03-17 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static map<string,string> getOppyPartDefaultConfidenceAndProcessStatus(string oppyId){
        map<string,string> map_status = new map<string,string>();
        Opportunity tempoppy = null;
            
        for(Opportunity opp : [Select Id,PMV_Type__c,StageName,RecordType.BusinessProcessId  from Opportunity where Id=:oppyId]){
            tempoppy = opp;
        }

        Map<String, PMV_Sales_Stage_Setting__c> allstates = PMV_Sales_Stage_Setting__c.getAll();
        for(PMV_Sales_Stage_Setting__c state : allstates.values()) {
            if(state.Active__c == true
              && state.Sales_Process_ID__c == tempoppy.RecordType.BusinessProcessId
              && state.PMV_Type__c == tempoppy.PMV_Type__c
              && state.Sales_Stage__c == tempoppy.StageName){         
                if(state.Opportunity_Parts_Confidence__c != null){
                    map_status.put('Confidence',state.Opportunity_Parts_Confidence__c);
                }else{
                    map_status.put('Confidence','');
                }
                if(state.Opportunity_Parts_Process_Status__c != null){
                    map_status.put('ProcessStatus', state.Opportunity_Parts_Process_Status__c);
                }else{
                    map_status.put('ProcessStatus', '');
                }
            }
        }
        return map_status;
    }
    
    
    @AuraEnabled 
    public static CustomObject getPartList(String param) {
        CustomParams cp = (CustomParams)JSON.deserialize(param, CustomParams.class);
        
        CustomObject co = new CustomObject();
        
        co.list_Parts = new list<CustomPart>();
        
        co.profile = LtngOpportunityForecastUtil.getUserProfile(UserInfo.getProfileId());
        co.opportunity = LtngOpportunityForecastUtil.getOpportunityById(cp.oppyId);
        
        /* added by simon @2017-11-17 start*/
        map<string,string> map_status = LtngOpportunityForecastCtrl.getOppyPartDefaultConfidenceAndProcessStatus(co.opportunity.Id);
        if(!map_status.isEmpty()) {
            if(map_status.containsKey('Confidence')) co.defaultConfidence = map_status.get('Confidence');
            if(map_status.containsKey('ProcessStatus')) co.defaultProcessStatus = map_status.get('ProcessStatus');
        }
        /* added by simon @2017-11-17 end*/
        
        co.notifyMessage = LtngOpportunityForecastUtil.checkOpportunityCompetitor(co.profile, co.opportunity);
        co.notifyContactRoleMessage = LtngOpportunityForecastUtil.checkOpportunityContactRole(co.profile, co.opportunity);
        
        co.isAPL = (co.opportunity.RecordType.DeveloperName == 'Opportunity_Engineering_Project' || co.opportunity.RecordType.DeveloperName == 'Opportunity_Sales_Parts_Only' || co.opportunity.RecordType.DeveloperName == 'Opportunity_Product_Platform' || co.opportunity.RecordType.DeveloperName == 'TAM' ? true : false);
        
     //   co.isAPL = (co.profile.Name == 'Appliance Engineering User w/Cost' || co.profile.Name == 'Appliance Standard User' || co.profile.Name == 'Appliance User w/ Cost' ? true : false);
        
        co.isIND = (co.opportunity.RecordType.DeveloperName == 'IND_Engineering_project' || co.opportunity.RecordType.DeveloperName == 'IND_Sales_Project' ? true : false); //LtngOpportunityForecastUtil.checkIND(co.profile, co.opportunity);
        co.isDND = (co.opportunity.RecordType.DeveloperName == 'DND_Opportunity' ? true : false);
        co.isADM = (co.opportunity.RecordType.DeveloperName == 'ADM' ? true : false); 
        co.isMED = (co.opportunity.RecordType.DeveloperName == 'Opportunity_Engineering_Project' || co.opportunity.RecordType.DeveloperName == 'Opportunity_Sales_Parts_Only' ? true : false);
        
        co.isMED = (co.profile.Name == 'Medical Standard User' || co.profile.Name == 'Medical User w/Cost' ? true : false);
        
        
        
        
        for(Opportunity_Part__c oppypart : [select initial_order_date__c, initial_billing_date__c, CurrencyIsoCode,
                                            AverageSellPrice__c, Id, Part_Name__c, Opportunity__c, Opportunity__r.Name, 
                                            Opportunity__r.StageName, Quantity__c, Status__c, Process_Status__c, Won_Date__c, 
                                            Lost_Reason__c, Lost_Reason_Text__c, Competitor__c, Similar_TE_Part_Number__r.Name, 
                                            GPL__c, Part__r.Name, New_Part_Description__c, RecordType.Name 
                                            from Opportunity_Part__c where Opportunity__c = :cp.oppyId ]){
            CustomPart part = new CustomPart(oppypart);
            co.list_Parts.add(part);
        }
        
        co.isView = false;
        co.opportunity.Level__c = (co.opportunity.Level__c == null ? 'Quarterly' : co.opportunity.Level__c);
        co.opportunity.Method__c = (co.opportunity.Method__c == null ? 'Manual' : co.opportunity.Method__c);
        co.isBom = (co.opportunity.Method__c == 'BOM' ? true : false);
        
        
        Boolean hasParts = false, isProgramLevel = false, validOpportunity = true, showMassUpdate = false;
        
    //    set<Id> applianceOppRTId = LtngOpportunityForecastUtil.applianceOpptyRecordTypeId();

    //    co.isAPL = (co.opportunity.Industry_Code__c == 'Appliances' && co.opportunity.Owner.GIBU__c == 'Appliances' && applianceOppRTId.contains(co.opportunity.RecordTypeId) ? true : false);
        //Set<String> set_periodYears = ClsOppyForecastUtilAPL.getAllPeriodYears();

        Period p = [select FiscalYearSettingsId, FiscalYearSettings.Name, PeriodLabel, Number, StartDate, EndDate from Period 
                    where type = 'Year' and FiscalYearSettings.IsStandardYear = false 
                    and StartDate <= :system.today() and EndDate >= :system.today()
                    order by FiscalYearSettings.Name limit 1];
        co.fiscalYear = p.FiscalYearSettings.Name;
        for(Integer i = 0; i < 10; i++) {
            co.list_Years.add(String.valueOf(Integer.valueOf(co.fiscalYear)+i));
        }
        
        if(co.fiscalFiveYearStartDate != null) {
            
            Period startMSD = [select FiscalYearSettings.Name, PeriodLabel, Number, StartDate, EndDate from Period 
                               where type = 'Quarter' and StartDate <= :co.opportunity.Manufacturing_Start_Date__c and EndDate >= :co.opportunity.Manufacturing_Start_Date__c limit 1];
            
            co.fiscalFiveYearStartDate = startMSD.FiscalYearSettings.Name + '-' + '0' + String.valueOf(startMSD.Number);
            
            Date fiveYearEndDate = co.opportunity.Manufacturing_Start_Date__c.addYears(5).addMonths(-1);
            Period endMSD = [select FiscalYearSettings.Name, PeriodLabel, Number, StartDate, EndDate from Period 
                             where type = 'Quarter' and StartDate <= :fiveYearEndDate and EndDate >= :fiveYearEndDate limit 1];
            
            if(endMSD.Number == 1) {
                Integer y = Integer.valueOf(endMSD.FiscalYearSettings.Name)-1;
                co.fiscalFiveYearEndDate = String.valueOf(y) + '-' + '04';
            }else {
                co.fiscalFiveYearEndDate = endMSD.FiscalYearSettings.Name + '-' + '0' + String.valueOf(endMSD.Number);
            }
            
        }
        
        co.map_FiscalDates = getFiscalDate(co.list_Years);
        
        for(Schema.PicklistEntry method : Opportunity.Method__c.getDescribe().getPicklistValues()) {
            co.list_Method.add(method.getValue());
        }
        
        
        for(Schema.PicklistEntry level : Opportunity.Level__c.getDescribe().getPicklistValues()) {
            if(co.profile.Name != 'BU Admin' && co.profile.Name != 'BU Analyst' && co.profile.Name != 'Developer' && 
                co.profile.Name != 'Production Support' && co.profile.Name != 'System Administrator'){
                if(!co.isADM && co.isAPL && level.getValue() == 'Yearly') {
                    continue;
                }
            }
            co.list_Level.add(level.getValue());
        }
        
        co.list_Confidence.addAll(LtngOpportunityForecastUtil.list_allConfidence);
        co.map_ProcessStatus = LtngOpportunityForecastUtil.map_allProcessStatus;
        co.map_LostReasons = getDependentOptions('Opportunity_Part__c','Status__c','Lost_Reason__c'); 
        
        for(Schema.PicklistEntry pe : Opportunity_Part__c.Won_Reason__c.getDescribe().getPicklistValues()) {
            co.list_WonReasons.add(pe.getValue());
        }
        
        //---------------------------------------- Start ----------------------------------------------
        //update by STEVEN QIAO<rui.qiao@capgemini.com>
        //2017-4-18        
        //check if system admin;
        /*
        boolean isAdmin = false;
        if(Apex_Helper_Settings__c.getInstance('System Administrator') != null && Apex_Helper_Settings__c.getInstance('System Administrator').Active__c 
           && Apex_Helper_Settings__c.getInstance('System Administrator').value__c != null)
        {
            String adminIds = Apex_Helper_Settings__c.getInstance('System Administrator').value__c;
            for(Id adminId :adminIds.split(',')){
                if(adminId == UserInfo.getProfileId()){
                    isAdmin = true;
                    break;
                }
            }
        }
        co.isAdmin = isAdmin;
        boolean isDND = false;
        boolean admrecordtypeid = false;
        boolean isSPIN = false;
        if(co.isAPL) {
            setAPLPickList(co, co.isAPL);
        }else{ //non-APL
            set<string> Gconfidence1 = new set<string>(new string[]{'On Hold','Weak','50/50','Likely','Commit','Dead','Lost','TAM'});
            set<string> Gconfidence2 = new set<string>(new string[]{'Won'});
            set<string> Gstatus1 = new set<string>(new string[]{'Concept','Demo','Designed','Prototyped/Sampled','Quoted'});
            set<string> Gstatus2 = new set<string>(new string[]{'Concept','Demo','Designed','Prototyped/Sampled','Quoted','Pre-prod','Production','Ramp-down','EOL'});
            set<string> Gstatus3 = new set<string>(new string[]{'Concept','Designed'});
            set<string> Gstatus4 = new set<string>(new string[]{'Concept','Designed','Pre-prod','Production','Ramp-down','EOL'});
            set<string> Gstatus5 = new set<string>(new string[]{'Concept','Quoted','Designed','On Customer AVL'});
            set<string> Gstatus6 = new set<string>(new string[]{'Concept','Quoted','Designed','On Customer AVL','Pre-prod','Production'});
            set<string> GstatusFinal = new set<string>(new string[]{'Production'});
            set<string> status1 = Gstatus1.clone();
            set<string> status2 = Gstatus2.clone();
            
            
            
            set<Id> set_rtIds = new set<Id>();
            set<Id> dndRecType = new set<Id>();
            set<Id> ADMRecType = new set<Id>();
            
            for(Opportunity_Record_Type_Groups__c rt : Opportunity_Record_Type_Groups__c.getall().values()){
                if(rt.Active__c == true && rt.RecordTypeID__c != null && rt.Group__c == 'Process Status Display' )
                    dndRecType.add((Id)rt.RecordTypeID__c);
                
                if(rt.Active__c && rt.Group__c == 'ADM Group' && rt.RecordTypeID__c!= null)//Added by Prabhanjan ADM Mifration
                    ADMRecType.add(rt.RecordTypeID__c);
            }
            
            isDND = (dndRecType.contains(co.opportunity.RecordTypeId) ? true : false);
            admrecordtypeid = (ADMRecType.contains(co.opportunity.RecordTypeId) ? true : false);

            set_rtIds = getAllPMVRecordtypes();
            
            isSPIN = (set_rtIds.contains(co.opportunity.RecordTypeId) ? true : false);

            co.isSPIN = isSPIN;
            
            if(isSPIN) {
                //DDL 1
                //according to : ExtOppyForecastEntryPage.cls  getConfidenceItem(){}
                co.list_Confidence.clear();
                co.list_Confidence.add('50/50');
                co.list_Confidence.add('Dead');
                co.list_Confidence.add('Lost');
                
                
                //DDL 2
                //according to : ExtOppyForecastEntryPage.page   <apex:outputPanel rendered="{!!isSPIN}"> 
                co.map_ProcessStatus.clear();
            } else {    //isSPIN = false
                //DDL 1
                string stageName = '';
                if(co.opportunity != null && !string.isEmpty(co.opportunity.StageName))
                    stageName = co.opportunity.StageName.toLowerCase();
                for(Schema.PicklistEntry confidence : Opportunity_Part__c.Status__c.getDescribe().getPicklistValues()) {
                    // phase is new and user is non-admin, won will NOT be displayed
                    if(confidence.isActive() && (stageName != 'new' || isAdmin || confidence.getValue() != 'Won' )) {
                        co.list_Confidence.add(confidence.getValue());//DDL 1
                        co.map_ProcessStatus.put(confidence.getValue(), new list<string>());  //DDL 2                      
                    }
                }
                
                //DDL 2
                set<string> set_processStatusValue = new set<string>();
                if(isDND){
                    setDNDPickList(status1, status2, Gstatus5, Gstatus6, set_processStatusValue, isAdmin, co);
                }else{ // !DND
                    for(Schema.PicklistEntry Process : Opportunity_Part__c.Process_Status__c.getDescribe().getPicklistValues()) {
                        if(Process.isActive()) {
                            set_processStatusValue.add(Process.getValue());
                        }
                    }
                    for(string keystr : co.map_ProcessStatus.keyset()){
                        set<string> set_temp =  new set<string>(set_processStatusValue);
                        if(keystr == 'Won'){
                            if(!isAdmin){
                                for(string tempvalue: set_temp){
                                    if(status1.contains(tempvalue)) {
                                        set_temp.remove(tempvalue);
                                    }
                                }
                            }
                        }else{
                            for(string tempvalue: set_temp){
                                if(!status1.contains(tempvalue) && status2.contains(tempvalue)){
                                    set_temp.remove(tempvalue);
                                }
                            }
                        }
                        set_temp.remove('Lost');
                        set_temp.remove('Dead');
                        co.map_ProcessStatus.put(keystr, new list<string>(set_temp));
                    }
                }
            }
        }
        system.debug('isAdmin::::::' + isAdmin);
        system.debug('isAPL::::::' + co.isAPL);
        system.debug('isDND::::::' + isDND);
        system.debug('isSPIN::::::' + isSPIN);
        system.debug('co.map_ProcessStatus::::::' + co.map_ProcessStatus);
        
        */
        
        
        //---------------------------------------- END ----------------------------------------------

        showMassUpdate = (Apex_Helper_Settings__c.getInstance('Appliance Show Mass Update') != null && Apex_Helper_Settings__c.getInstance('Appliance Show Mass Update').Active__c && Apex_Helper_Settings__c.getInstance('Appliance Show Mass Update').value__c != null ?
                            (Apex_Helper_Settings__c.getInstance('Appliance Show Mass Update').value__c == 'true' ? true : false) : false);
                            
        hasParts = (co.list_Parts.size() > 0 ? true : false);
        isProgramLevel = (co.opportunity.Program__c != null && co.opportunity.Program__r.Program_level_Forecasting__c ? true : false);
        validOpportunity = (co.opportunity.StageName == 'In Approval' || co.opportunity.StageName == 'Rejected - Closed' ? false : true);
        co.isShowMussUpdate = (hasParts && !isProgramLevel && validOpportunity && showMassUpdate ? true : false);

        system.debug('!@# co.map_change:' + co.map_change);
        
        
        return co;
    }
 
    
    @AuraEnabled 
    public static CustomObject getForecastList(String param) {
        CustomParams cp = (CustomParams)JSON.deserialize(param, CustomParams.class);
        CustomObject co = new CustomObject();
        system.debug('!@# cp:'+cp);
        //try{
        
            for(String partid : cp.list_PartIds) {
                if(partid != null && partid != '' && !co.map_partId_year_oppyForecast.containsKey(partid)){
                    co.map_partId_year_oppyForecast.put(partid, new map<String, list<Opportunity_Forecast__c>>());
                }
            }
            
            set<String> set_year = new set<String>();
            
            
            map<String, Decimal> map_isoCode_exchangeRate = new map<String, Decimal>();
            getExchangeRate(map_isoCode_exchangeRate);
            
            for(Opportunity_Forecast__c ofc : [select Id, Name, RecordTypeId, Date__c, Fiscal_Year__c, Sales_Price__c, 
                                                    Fiscal_Quarter__c, Fiscal_Month__c, Quantity__c, Opportunity__c, Opportunity__r.CurrencyIsoCode,
                                                    Part__c, Part__r.Name, Forecasting_Start_Date__c , CurrencyIsoCode
                                                from Opportunity_Forecast__c 
                                                where Opportunity__c = :cp.oppyId and Part__c != null 
                                                    and Date__c != null 
                                                    //and Fiscal_Year__c IN :cp.list_Years 
                                                    order by Part__r.Name, Date__c]){
            
                if(!co.map_partId_year_oppyForecast.containsKey(ofc.Part__c)){
                    co.map_partId_year_oppyForecast.put(ofc.Part__c, new map<String, list<Opportunity_Forecast__c>>());
                }

                String year = ofc.Fiscal_Year__c;
                if(year == null){
                    year = String.valueOf(ofc.Date__c.Year());
                }
                if(!set_year.contains(year)) {
                    set_year.add(year);
                }
                ofc.Sales_Price__c = transformIsoCode(ofc.Sales_Price__c, ofc.CurrencyIsoCode, ofc.Opportunity__r.CurrencyIsoCode, map_isoCode_exchangeRate); 
                if(!co.map_partId_year_oppyForecast.get(ofc.Part__c).containsKey(year)){
                    co.map_partId_year_oppyForecast.get(ofc.Part__c).put(year, new list<Opportunity_Forecast__c>());
                }
   
                co.map_partId_year_oppyForecast.get(ofc.Part__c).get(year).add(ofc);
            }
            
            system.debug('!@# set_year:'+set_year);
            map<String, Decimal> map_partId_price = new map<String, Decimal>();
            String oppyEngineeringRecordTypeId = '', oppySalesRecordTypeId = '';
            for (RecordType t : [Select Id, DeveloperName, SobjectType from RecordType where SobjectType = 'Opportunity']) {
                if(t.DeveloperName == 'Opportunity_Engineering_Project' && t.SobjectType == 'Opportunity') {
                    oppyEngineeringRecordTypeId = t.Id; 
                } 
                if(t.DeveloperName == 'Opportunity_Sales_Parts_Only' && t.SobjectType == 'Opportunity') {
                    oppySalesRecordTypeId = t.Id;
                }
            } 
            for(Opportunity_Part__c part : [select CurrencyIsoCode, AverageSellPrice__c, Id, Part_Name__c, Opportunity__c, Opportunity__r.CurrencyIsoCode,
                                                    Opportunity__r.StageName, Opportunity__r.RecordTypeId
                                                    from Opportunity_Part__c where Opportunity__c = :cp.oppyId 
                                                    order by Opportunity__r.Name, Name]){
                if(part.Opportunity__r.RecordTypeId == oppySalesRecordTypeId || part.Opportunity__r.RecordTypeId == oppyEngineeringRecordTypeId) {
                    Decimal price;
                    if(part.CurrencyIsoCode != null) {
                        
                        price = transformIsoCode(part.AverageSellPrice__c, part.CurrencyIsoCode, part.Opportunity__r.CurrencyIsoCode, map_isoCode_exchangeRate); 
                    }else {
                        price = part.AverageSellPrice__c == null ? 0 : part.AverageSellPrice__c;
                    }                   
                    map_partId_price.put(part.Id, price); 
                }else {
                    map_partId_price.put(part.Id, 0);
                }
            } 
            
            for(String partid : co.map_partId_year_oppyForecast.keySet()) {
                if(set_year.size() == 0) {
                    Period p = [select FiscalYearSettingsId, FiscalYearSettings.Name, PeriodLabel, Number, StartDate, EndDate from Period 
                                where type = 'Year' and FiscalYearSettings.IsStandardYear = false 
                                    and StartDate <= :system.today() and EndDate >= :system.today()
                                order by FiscalYearSettings.Name limit 1];
                    set_year.add(p.FiscalYearSettings.Name);
                    co.message = 'No forecast entered';
                    co.map_change.put('isChange', true);
                }
                
                
                for(String year : set_year) {
                    if(!co.map_partId_year_oppyForecast.get(partid).containsKey(year)) {
                        setOppyForecast(partid, year, map_partId_price, cp, co);
                    }
                    system.debug('!@# map_partId_year_oppyForecast.partid.year : '+ co.map_partId_year_oppyForecast.get(partid).get(year));
                }
                
            }
            
        system.debug('!@# co.map_change:' + co.map_change);
        //}catch(Exception e){
        //    co.error = e.getMessage();
        //}
        
        return co;
    }
    
    @AuraEnabled
    public static SaveReturn saveOpportunity(String param) {
        SaveData sd = (SaveData)JSON.deserialize(param, SaveData.class);
        System.debug('xxxx sd.list_Parts 1111' + sd.list_Parts);
        SaveReturn co = new SaveReturn ();
        Savepoint sp = Database.setSavepoint();
        try{
            
            map<String, Decimal> map_isoCode_exchangeRate = new map<String, Decimal>();
            getExchangeRate(map_isoCode_exchangeRate);
            
            
            
            //sd.opportunity.Amount = transformIsoCode(sd.opportunity.Amount, 'USD', sd.opportunity.CurrencyIsoCode, map_isoCode_exchangeRate);
            //sd.opportunity.Five_Year_Revenue__c = transformIsoCode(sd.opportunity.Five_Year_Revenue__c, 'USD', sd.opportunity.CurrencyIsoCode, map_isoCode_exchangeRate);
            //sd.opportunity.Total_Opportunity_Value__c = transformIsoCode(sd.opportunity.Total_Opportunity_Value__c, 'USD', sd.opportunity.CurrencyIsoCode, map_isoCode_exchangeRate);
            //sd.opportunity.Five_Year_Value__c = transformIsoCode(sd.opportunity.Five_Year_Value__c, 'USD', sd.opportunity.CurrencyIsoCode, map_isoCode_exchangeRate);
            
            Opportunity oldoppy = [Select Id, Amount, Five_Year_Revenue__c, Total_Opportunity_Value__c, Five_Year_Value__c, Level__c, Method__c, CurrencyIsoCode
                                   from Opportunity where Id = :sd.opportunity.Id]; 
            
            if(oldoppy.Amount != sd.opportunity.Amount || oldoppy.Five_Year_Revenue__c != sd.opportunity.Five_Year_Revenue__c ||
               oldoppy.Total_Opportunity_Value__c != sd.opportunity.Total_Opportunity_Value__c || oldoppy.Five_Year_Value__c != sd.opportunity.Five_Year_Value__c ||
               oldoppy.Level__c != sd.opportunity.Level__c || oldoppy.Method__c != sd.opportunity.Method__c) {
                   
                   set<Id> set_fbIds = new set<Id>();
                   if(sd.opportunity.AccountId != null) {
                       string keyLike = string.valueOf(sd.opportunity.AccountId).subString(0, 15) + '_' + string.valueOf(sd.opportunity.Id).subString(0, 15) + '%';
                       for(Forecast_Billing__c fb : [select Id from Forecast_Billing__c where acc_opp_part__c like :keyLike limit 1]) {
                           set_fbIds.add(fb.Id);
                       }
                   }
                   if(set_fbIds.size() > 0) {
                       sd.opportunity.Opportunity_Forecast_Recalculation__c = true;
                   }
                   
                   update sd.opportunity;
                   co.isUpdateOppy = true;
               }
            
            for(Opportunity_Part__c part : sd.list_Parts) {
                //2018-06-07 change part all currency to USD
                string NowCurrency = oldoppy.CurrencyIsoCode;
                string partCurrency = 'USD'; 
                
                for(Integer i=1; i<=10; i++) {
                    if(part.get('FC_FY'+String.valueOf(i)+'_PRICE__c') != null) {
                        part.put('FC_FY'+String.valueOf(i)+'_PRICE__c', transformIsoCode(((Decimal)part.get('FC_FY'+String.valueOf(i)+'_PRICE__c')), NowCurrency, partCurrency, map_isoCode_exchangeRate));
                        part.put('FCSTYR'+String.valueOf(i)+'AMT__c', transformIsoCode(((Decimal)part.get('FCSTYR'+String.valueOf(i)+'AMT__c')),  NowCurrency, partCurrency, map_isoCode_exchangeRate));
                    }
                }
                
                for(integer i=-2; i<= 7; i++){
                    if(i == -2) {
                        part.Current_Year_minus_2__c = transformIsoCode(part.Current_Year_minus_2__c,  NowCurrency, partCurrency, map_isoCode_exchangeRate);
                        part.Current_Year_minus_2_PRICE__c = transformIsoCode(part.Current_Year_minus_2_PRICE__c,  NowCurrency, partCurrency, map_isoCode_exchangeRate);
                    }else if(i == -1) {
                        part.Current_Year_minus_1__c = transformIsoCode(part.Current_Year_minus_1__c,  NowCurrency, partCurrency, map_isoCode_exchangeRate);
                        part.Current_Year_minus_1_PRICE__c = transformIsoCode(part.Current_Year_minus_1_PRICE__c,  NowCurrency, partCurrency, map_isoCode_exchangeRate);
                    }else if(i == 0) {
                        part.Current_Year__c = transformIsoCode(part.Current_Year__c,  NowCurrency, partCurrency, map_isoCode_exchangeRate);
                        part.Current_Year_PRICE__c = transformIsoCode(part.Current_Year_PRICE__c,  NowCurrency, partCurrency, map_isoCode_exchangeRate);
                    }else if(i > 0){
                        part.put('Current_Year_add_'+String.valueOf(i)+'__c', transformIsoCode(((Decimal)part.get('Current_Year_add_'+String.valueOf(i)+'__c')),  NowCurrency, partCurrency, map_isoCode_exchangeRate));
                        part.put('Current_Year_add_'+String.valueOf(i)+'_PRICE__c', transformIsoCode(((Decimal)part.get('Current_Year_add_'+String.valueOf(i)+'_PRICE__c')),  NowCurrency, partCurrency, map_isoCode_exchangeRate));
                    }
                }
            }
            
            System.debug('xxxx sd.list_Parts 2222' + sd.list_Parts);
            update sd.list_Parts;
            
            co.canContinue = true;
        }catch(Exception e){
            co.error = e.getMessage();
            co.canContinue = false;
            Database.rollback(sp);
            throw e;
        }
        
        return co;
    }
    
    
    @AuraEnabled
    public static SaveReturn saveParts(String param) {
        SaveData sd = (SaveData)JSON.deserialize(param, SaveData.class);
        SaveReturn co = new SaveReturn ();
        Savepoint sp = Database.setSavepoint();
        try{

            update sd.list_Parts;
            System.debug('xxxx sd.list_Parts=' + sd.list_Parts);
            co.canContinue = true;
        }catch(Exception e){
            co.error = e.getMessage();
            co.canContinue = false;
            Database.rollback(sp);
            throw e;
        }

        return co;
    }
    
    
    
    @AuraEnabled
    public static SaveReturn saveForecastList(String param) {
        system.debug('!@# param:'+param);
        SaveReturn co = new SaveReturn ();
        try{
            SaveData sd = (SaveData)JSON.deserialize(param, SaveData.class);
            
        
            system.debug('!@# sd:'+sd);
        
            set<Id> set_delId = new set<Id>();
            list<Opportunity_Forecast__c> list_delForecast = new list<Opportunity_Forecast__c>();
            String oppyId = '';
            for(Opportunity_Forecast__c forecast : sd.list_oppyForecast) {
                set_delId.add(forecast.Part__c);
                oppyId = forecast.Opportunity__c;
            }
            
            
            String oppyCurrencyIsoCode = 'USD';
            for(Opportunity oppy : [select Id, CurrencyIsoCode from Opportunity where Id = :oppyId]) {
                oppyCurrencyIsoCode = oppy.CurrencyIsoCode;
            }
            
            for(Opportunity_Forecast__c ofc : [select Id, Name, RecordTypeId, Date__c, Fiscal_Year__c, Sales_Price__c, Fiscal_Quarter__c, Fiscal_Month__c,
                                                    Quantity__c, Opportunity__c, Part__c, Part__r.Name, Forecasting_Start_Date__c
                                                from Opportunity_Forecast__c 
                                                where Opportunity__c = :sd.oppyId 
                                                    and Fiscal_Year__c IN :sd.list_fiscalYear and Part__c in: set_delId]){
                list_delForecast.add(ofc);
            }
            
            system.debug('!@# oppyCurrencyIsoCode:'+oppyCurrencyIsoCode);
            map<String, map<String, Date>> map_year_month_startdate = new map<String, map<String, Date>>();
            for(Period p: [select FiscalYearSettingsId, FiscalYearSettings.Name, Number, StartDate, PeriodLabel from Period where FiscalYearSettings.Name IN :sd.list_fiscalYear and type = 'Month' order by StartDate]){
                if(!map_year_month_startdate.containsKey(p.FiscalYearSettings.Name)) {
                    map_year_month_startdate.put(p.FiscalYearSettings.Name, new map<String, Date>());
                }
                
                if(!map_year_month_startdate.get(p.FiscalYearSettings.Name).containsKey(MAP_MONTHLABELNUMBER.get(p.PeriodLabel))) {
                    map_year_month_startdate.get(p.FiscalYearSettings.Name).put(MAP_MONTHLABELNUMBER.get(p.PeriodLabel), p.StartDate);
                }
            }
            
            map<String, Decimal> map_isoCode_exchangeRate = new map<String, Decimal>();
            getExchangeRate(map_isoCode_exchangeRate);
            Decimal fromRate = 1; 
            
            if(map_isoCode_exchangeRate.get(oppyCurrencyIsoCode) != null && String.ValueOf(map_isoCode_exchangeRate.get(oppyCurrencyIsoCode)) != '') {
                fromRate =  map_isoCode_exchangeRate.get(oppyCurrencyIsoCode);
            }

            list<Opportunity_Forecast__c> list_newForecast = new list<Opportunity_Forecast__c>();
            String forecastOppyRecordTypeId = '';
            for (RecordType t : [Select Id, DeveloperName, SobjectType from RecordType where SobjectType = 'Opportunity_Forecast__c' and DeveloperName = 'Opportunity']) {
                forecastOppyRecordTypeId = t.Id;
            }
            
            //system.debug('map_year_month_startdate@@@@');
            //system.debug(map_year_month_startdate);
            //system.debug(sd.list_oppyForecast);
            //system.debug('map_year_month_startdate@@@@');
            
            for(Opportunity_Forecast__c forecast : sd.list_oppyForecast) {
                
                /*if(sd.level == 'Year') {
                    forecast.Fiscal_Quarter__c = '01'; 
                    forecast.Fiscal_Month__c = '01';
                }else if(sd.level == 'Quarter') {
                    forecast.Fiscal_Month__c = MAP_MONTHFORQUARTER.get(forecast.Fiscal_Quarter__c);
                }else {
                    forecast.Fiscal_Quarter__c = MAP_QUARTERFORMONTH.get(forecast.Fiscal_Month__c);
                }*/
                Decimal toRate = 1;
                if(map_isoCode_exchangeRate.get(forecast.CurrencyIsoCode) != null && String.ValueOf(map_isoCode_exchangeRate.get(forecast.CurrencyIsoCode)) != '') {
                    toRate =  map_isoCode_exchangeRate.get(forecast.CurrencyIsoCode);
                }
                Decimal isoRate = toRate / fromRate;
                system.debug('!@# toRate: '+toRate);
                system.debug('!@# fromRate: '+fromRate);
                system.debug('!@# forecast.Sales_Price__c: '+forecast.Sales_Price__c);
                forecast.Date__c = map_year_month_startdate.get(forecast.Fiscal_Year__c).get(forecast.Fiscal_Month__c);
                forecast.Sales_Price__c = forecast.Sales_Price__c * isoRate;
                forecast.Amount__c = forecast.Sales_Price__c * forecast.Quantity__c;
                forecast.RecordTypeId = forecastOppyRecordTypeId;
                system.debug('!@# forecast: '+forecast);
                list_newForecast.add(forecast);
                
            }

            if(!list_delForecast.isEmpty()) {
                delete list_delForecast;
            }
            system.debug('!@# list_newForecast: '+list_newForecast);
            system.debug('!@# list_newForecast: '+list_newForecast.size());
            if(!list_newForecast.isEmpty()) {
                insert list_newForecast;
                // Added by Qiang Liu on 2017.11.22
                ClsBatch_recalculateNPSForAPL bat_apl = new ClsBatch_recalculateNPSForAPL(list_newForecast);
                //Database.executeBatch(bat_apl);
                System.scheduleBatch(bat_apl, 'ClsBatch_recalculateNPSForAPL' + String.valueOf(math.random()), 5);
            }
            
            co.canContinue = true;
        }catch(Exception e){
            co.error = e.getMessage();
            throw e;
        }
        
        return co;
    }
    
    @AuraEnabled
    public static SaveReturn updateForecastHitory(String param) {
        SaveData sd = (SaveData)JSON.deserialize(param, SaveData.class);
        SaveReturn co = new SaveReturn();
        Savepoint sp = Database.setSavepoint();
        try{
            Opportunity oppy = [Select PLM_Id__c ,Email_Send__c,PLM_Created_By_Id__c, Industry_Code__c, CloseDate, IsClosed, AccountId, 
                              Manufacturing_Start_Date__c, Id, Name, stageName, RecordTypeId, Program__c, IsWon, Opportunity_Forecast_Recalculation__c, 
                              Program__r.Program_level_Forecasting__c, Amount, Five_Year_Revenue__c, Method__c, lost_start_date__c, second_fiscal_year_lost__c,
                              CurrencyIsoCode, Level__c, Competitor_Count__c, NDR_Quote_Status_Description__c, Approval_Status_PMV__c 
                       From Opportunity 
                       Where Id = :sd.oppyId];
            
            if(oppy.lost_start_date__c != null){
                oppy.first_fiscal_year_lost__c = 0;
                oppy.second_fiscal_year_lost__c = 0;
                
                //get the fiscal year of lost start date
                Period MonthlyBatchPeriod = [SELECT PeriodLabel, FiscalYearSettings.Name FROM Period where type = 'Month' and startdate <=: oppy.lost_start_date__c and enddate >=: oppy.lost_start_date__c];
                Integer fYear = Integer.valueOf(MonthlyBatchPeriod.FiscalYearSettings.Name);
                
                for(Opportunity_Forecast__c oppF : [select Id, Fiscal_Year__c , Amount__c, CurrencyIsoCode from Opportunity_Forecast__c where Opportunity__c = :oppy.Id]){
                    if(oppF.Amount__c != null){
                        if(fYear == Integer.valueOf(oppF.Fiscal_Year__c)){
                            oppy.first_fiscal_year_lost__c += LtngOpportunityForecastUtil.transformIsoCode(oppF.Amount__c, oppF.CurrencyIsoCode, oppy.CurrencyIsoCode);
                        }else if(fYear+1 == Integer.valueOf(oppF.Fiscal_Year__c)){
                            oppy.second_fiscal_year_lost__c += LtngOpportunityForecastUtil.transformIsoCode(oppF.Amount__c, oppF.CurrencyIsoCode, oppy.CurrencyIsoCode);
                        }
                    }
                }
                oppy.Need_Send_Lost_Mail__c = true;
                update oppy;
            }
            co.isUpdateOppy = true;
            /*
            if(sd.isAPL) {
            }
            */
            
            String BU = LtngOpportunityForecastUtil.getBU(oppy);  
            Boolean isAppOrIndBu = LtngOpportunityForecastUtil.isAppOrIndBu(BU);
            String str_mapPartId_listForecastHistoryStructure = LtngOpportunityForecastUtil.getOppyForecastHistory(oppy.Id);
            String selectedReason = '';
            if(isAppOrIndBu && str_mapPartId_listForecastHistoryStructure != '' ) {
                //system.debug('--==str_mapPartId_listForecastHistoryStructure==--'+str_mapPartId_listForecastHistoryStructure);
                LtngOpportunityForecastUtil.saveOppForecastHitory(str_mapPartId_listForecastHistoryStructure, oppy, selectedReason);
                str_mapPartId_listForecastHistoryStructure = '';
            }
            co.canContinue = true;
        }catch(Exception e) {
            co.error = e.getMessage();
            co.canContinue = false;
            Database.rollback(sp);
        }
        return co;
    }
    
    @AuraEnabled
    public static SaveReturn deleteForecast(String param) {
        
        SaveData sd = (SaveData)JSON.deserialize(param, SaveData.class);
        SaveReturn co = new SaveReturn ();
        
        system.debug('!@# sd:'+sd);
        
        try {
        
            list<Opportunity_Forecast__c> list_delForecast = new list<Opportunity_Forecast__c>();
            for(Opportunity_Forecast__c ofc : [select Id, Name, RecordTypeId, Date__c, Fiscal_Year__c, Sales_Price__c, Fiscal_Quarter__c, Fiscal_Month__c,
                                                    Quantity__c, Opportunity__c, Part__c, Part__r.Name, Forecasting_Start_Date__c 
                                                from Opportunity_Forecast__c 
                                                where Opportunity__c = :sd.oppyId 
                                                    and Fiscal_Year__c IN :sd.list_fiscalYear ]){
                list_delForecast.add(ofc);
            }
            
            if(!list_delForecast.isEmpty()) {
                delete list_delForecast;
            }

            co.canContinue = true;
        }catch(Exception e){
            co.error = e.getMessage();
        }
        
        return co;
    }
    
    
    @AuraEnabled
    public static CustomObject searchCompetitor(String param) {
        CustomParams cp = (CustomParams)JSON.deserialize(param, CustomParams.class);
        CustomObject co = new CustomObject();
        
        try {
            String serachName = '%'+cp.competitorName+'%';
            co.list_Competitors = [select Id, Name from Account where Name like :serachName and RecordType.DeveloperName='Competitor' ];
            
        }catch(Exception e){
            co.error = e.getMessage();
        }
        return co;
    }
    
    /*
    public static void setAPLPickList(CustomObject co, Boolean isAPL){
        for(Schema.PicklistEntry confidence : Opportunity_Part__c.Status__c.getDescribe().getPicklistValues()) {
            if(confidence.isActive()) {
                co.list_Confidence.add(confidence.getValue());//DDL 1
            }
        }
        co.map_ProcessStatus = getProcessStatusItems(co.list_Confidence, isAPL); //DDL 2
    }
    
    public static void setDNDPickList(set<string> status1, set<string> status2, set<string> Gstatus5, set<string> Gstatus6, set<string> set_processStatusValue, Boolean isAdmin, CustomObject co){
        status1 = Gstatus5.clone();
        status2 = Gstatus6.clone();
        
        //according to : ExtOppyForecastEntryPage.cls  getProcessStatusItems(){}
        if(Apex_Helper_Settings__c.getInstance('DND Oppty Part Process Status Value') != null && 
           Apex_Helper_Settings__c.getInstance('DND Oppty Part Process Status Value').Active__c && 
           Apex_Helper_Settings__c.getInstance('DND Oppty Part Process Status Value').value__c != null) {
            String[] processStatusValue = Apex_Helper_Settings__c.getInstance('DND Oppty Part Process Status Value').value__c.split(';');
            for(Integer i=0; i< processStatusValue.size(); i++) {
                set_processStatusValue.add(processStatusValue[i]);
            }
        }
        for(string keystr : co.map_ProcessStatus.keyset()){
            set<string> set_temp =  new set<string>(set_processStatusValue);
            if(keystr == 'Won'){
                if(!isAdmin){
                    for(string tempvalue: set_temp){
                        if(status1.contains(tempvalue))
                        {
                            set_temp.remove(tempvalue);
                        }
                    }
                }
            }else{
                for(string tempvalue: set_temp){
                    if(!status1.contains(tempvalue) && status2.contains(tempvalue)){
                        set_temp.remove(tempvalue);
                    }
                }
            }
            set_temp.remove('Lost');
            set_temp.remove('Dead');
            co.map_ProcessStatus.put(keystr, new list<string>(set_temp));
        }
    }
    
    
        
    public static map<String,list<String>> getProcessStatusItems(list<String> list_Confidence, Boolean isAPL){
        map<String,list<String>> map_Conf_ProcessStatus = new map<String,list<String>>();

        for(String confidence : list_Confidence) {
            if(confidence != 'Won') {
                if(isAPL) {
                    list<String> list_ProcessStatus = new list<String>();
                    list_ProcessStatus.add('Concept');
                    list_ProcessStatus.add('Designed');      
                    map_Conf_ProcessStatus.put(confidence, list_ProcessStatus);
                }
                else {
                    map_Conf_ProcessStatus.put(confidence, new list<String>{'Concept','Demo','Designed','Prototyped/Sampled','Quoted'});
                }
            }else { 
                if(isAPL) {
                    list<String> lst_ProcessStatus = new list<String>();
                    lst_ProcessStatus.add('Pre-prod');
                    lst_ProcessStatus.add('Production');
                    lst_ProcessStatus.add('Ramp-down');
                    lst_ProcessStatus.add('EOL');
                    map_Conf_ProcessStatus.put(confidence, lst_ProcessStatus);
                }else {
                    map_Conf_ProcessStatus.put(confidence, new list<String>{'Concept','Demo','Designed','Prototyped/Sampled','Quoted','Pre-prod','Production','Ramp-down','EOL'});
                }
            }
        }
        return map_Conf_ProcessStatus;
    }
    */
    
    
    /**
    *   Util function for getPicklistValues by SObject name and picklist field name
    *
    @author Steven Qiao
    @created 2017-04-11
    @version 1.0
    @since 35.0 (Force.com ApiVersion)
    *
    @changelog   
    * 2017-04-11 Steven Qiao<rui.qiao@capgemini.com>
    * - Created
    
    public static list<string> getPicklistValues(String pObjName, String pControllingFieldName){
        list<string> lst_values = new list<string>();
        Map<String,Schema.SObjectType> objGlobalMap = Schema.getGlobalDescribe();
        if (objGlobalMap.containsKey(pObjName)){
            Schema.SObjectType pType = objGlobalMap.get(pObjName);
            Map<String, Schema.SObjectField> objFieldMap = pType.getDescribe().fields.getMap();
            List<Schema.PicklistEntry> ctrl_ple = objFieldMap.get(pControllingFieldName).getDescribe().getPicklistValues();
            for(Schema.PicklistEntry PE: ctrl_ple)
            {
                if(PE.isActive()){
                    lst_values.add(PE.getValue());
                }
            }
        }
        return lst_values;
    }
    */
       
    /**
    * This method is used to get all recordType Id for PMV
    *
    @author Jinbo Shan
    @created 2014-03-03
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @return              set<Id>
    *
    @changelog
    * 2017-4-18 Steven Qiao<rui.qiao@capgemini.com>  
    * - Created  
    
    public static set<Id> getAllPMVRecordtypes(){
        set<Id> set_rts = new set<Id>();
        
        for(Opportunity_Record_Type_Groups__c setting : Opportunity_Record_Type_Groups__c.getAll().values()) {
            if(setting.Active__c == true && setting.RecordTypeID__c != null && setting.Group__c == 'PMV') { //when (IND_Engineering_project or IND_Sales_Project) then isSPIN = true;
                set_rts.add((Id)setting.RecordTypeID__c);
            }
        }
        
        return set_rts;
    }
    */  
    
    
    
    public static map<String, map<String, list<CustomFiscalDate>>> getFiscalDate(list<String> list_years) {
        map<String, map<String, list<CustomFiscalDate>>> map_fiscaldates = new map<String, map<String, list<CustomFiscalDate>>>();
        for(Period per : [select FiscalYearSettings.Name, PeriodLabel, Number, StartDate, EndDate, type 
                            from Period where EndDate > TODAY and Type IN ('Quarter','Month','Year') and FiscalYearSettings.Name IN :list_years
                            order by Type, StartDate]) {
            if(!map_fiscaldates.containsKey(MAP_LEVELLABEL.get(per.type))) {
                map_fiscaldates.put(MAP_LEVELLABEL.get(per.type), new map<String, list<CustomFiscalDate>>());
            }
            
            if(!map_fiscaldates.get(MAP_LEVELLABEL.get(per.type)).containsKey(per.FiscalYearSettings.Name) ) {
                map_fiscaldates.get(MAP_LEVELLABEL.get(per.type)).put(per.FiscalYearSettings.Name, new list<CustomFiscalDate>());
            }
            /*
            String sd_ed = String.valueOf(per.StartDate.year())+'-'+String.valueOf(per.StartDate.month())+'-'+String.valueOf(per.StartDate.day())
                            +'_'
                            +String.valueOf(per.EndDate.year())+'-'+String.valueOf(per.EndDate.month())+'-'+String.valueOf(per.EndDate.day());
            */
            CustomFiscalDate cfd = new CustomFiscalDate();
            cfd.fiscalYear = per.FiscalYearSettings.Name;
            cfd.fiscalQuarter = 'Q'+String.valueOf(per.Number);
            cfd.fiscalMonth = MAP_MONTHLABELNUMBER.get(per.PeriodLabel);
            cfd.startDate = String.valueOf(per.StartDate.year())+'-'+String.valueOf(per.StartDate.month())+'-'+String.valueOf(per.StartDate.day());
            cfd.endDate = String.valueOf(per.EndDate.year())+'-'+String.valueOf(per.EndDate.month())+'-'+String.valueOf(per.EndDate.day());  
            
            map_fiscaldates.get(MAP_LEVELLABEL.get(per.type)).get(per.FiscalYearSettings.Name).add(cfd);

        }
        return map_fiscaldates;
    }
    

    
    public static void setOppyForecast(String partid, String year, map<String, Decimal> map_partId_price, CustomParams cp, CustomObject co){
        co.message = 'No forecast entered';
        co.map_change.put('isChange', true);
        co.map_partId_year_oppyForecast.get(partid).put(year, new list<Opportunity_Forecast__c>());
        if(cp.level == 'Yearly') {
            Opportunity_Forecast__c ofc = new Opportunity_Forecast__c(Fiscal_Year__c=year,Part__c=partid,
                                Fiscal_Quarter__c='01',Fiscal_Month__c='01',Quantity__c=0,Sales_Price__c=map_partId_price.get(partid));
            co.map_partId_year_oppyForecast.get(partid).get(year).add(ofc);
        }else if(cp.level == 'Quarterly') {
            for(Integer i = 1; i <= 4; i++) {
                String quarterName = '0'+String.valueOf(i);
                Opportunity_Forecast__c ofc = new Opportunity_Forecast__c(Fiscal_Year__c=year,Part__c=partid,
                                Fiscal_Quarter__c=quarterName,Fiscal_Month__c=MAP_MONTHFORQUARTER.get(quarterName),
                                Quantity__c=0,Sales_Price__c=map_partId_price.get(partid));
                co.map_partId_year_oppyForecast.get(partid).get(year).add(ofc);
            }
        }else if(cp.level == 'Monthly') {
            for(Integer i = 1; i <= 12; i++) {
                String monthName =  (i < 10 ? '0'+String.valueOf(i) : String.valueOf(i));
                Opportunity_Forecast__c ofc = new Opportunity_Forecast__c(Fiscal_Year__c=year,Part__c=partid,
                                Fiscal_Quarter__c=MAP_QUARTERFORMONTH.get(monthName),Fiscal_Month__c=monthName,
                                Quantity__c=0,Sales_Price__c=map_partId_price.get(partid));
                co.map_partId_year_oppyForecast.get(partid).get(year).add(ofc);
            }
        }
    }
    
    
    public static Map<String,List<String>> getDependentOptions(String pObjName, String pControllingFieldName, String pDependentFieldName){
        Map<String,List<String>> objResults = new Map<String,List<String>>();
        //get the string to sobject global map
        Map<String,Schema.SObjectType> objGlobalMap = Schema.getGlobalDescribe();
        if (!objGlobalMap.containsKey(pObjName))
            return objResults;
        //get the type being dealt with
        Schema.SObjectType pType = objGlobalMap.get(pObjName);
        Map<String, Schema.SObjectField> objFieldMap = pType.getDescribe().fields.getMap();
        //verify field names
        if (!objFieldMap.containsKey(pControllingFieldName) || !objFieldMap.containsKey(pDependentFieldName))
            return objResults;     
        //get the control values   
        List<Schema.PicklistEntry> ctrl_ple = objFieldMap.get(pControllingFieldName).getDescribe().getPicklistValues();
        //get the dependent values
        List<Schema.PicklistEntry> dep_ple = objFieldMap.get(pDependentFieldName).getDescribe().getPicklistValues();
        //iterate through the values and get the ones valid for the controlling field name
        Bitset objBitSet = new Bitset();
        //set up the results
        for(Integer pControllingIndex=0; pControllingIndex<ctrl_ple.size(); pControllingIndex++){           
            //get the pointer to the entry
            Schema.PicklistEntry ctrl_entry = ctrl_ple[pControllingIndex];
            //get the label
            String pControllingLabel = ctrl_entry.getLabel();
            //create the entry with the label
            objResults.put(pControllingLabel,new List<String>());
        }
        //check the dependent values
        for(Integer pDependentIndex=0; pDependentIndex<dep_ple.size(); pDependentIndex++){          
            //get the pointer to the dependent index
            Schema.PicklistEntry dep_entry = dep_ple[pDependentIndex];
            //get the valid for
            String pEntryStructure = JSON.serialize(dep_entry);                
            TPicklistEntry objDepPLE = (TPicklistEntry)JSON.deserialize(pEntryStructure, TPicklistEntry.class);
            //if valid for is empty, skip
            if (objDepPLE.validFor==null || objDepPLE.validFor==''){
                continue;
            }
            //iterate through the controlling values
            for(Integer pControllingIndex=0; pControllingIndex<ctrl_ple.size(); pControllingIndex++){    
                if (objBitSet.testBit(objDepPLE.validFor,pControllingIndex)){                   
                    //get the label
                    String pControllingLabel = ctrl_ple[pControllingIndex].getLabel();
                    objResults.get(pControllingLabel).add(objDepPLE.label);
                }
            }
        } 
        return objResults;
    }
    
    public class Bitset{
        public Map<String,Integer> AlphaNumCharCodes {get;set;}
        public Map<String, Integer> Base64CharCodes { get; set; }
        public Bitset(){
            LoadCharCodes();
        }
        //Method loads the char codes
        private void LoadCharCodes(){
            AlphaNumCharCodes = new Map<String,Integer>{
                'A'=>65,'B'=>66,'C'=>67,'D'=>68,'E'=>69,'F'=>70,'G'=>71,'H'=>72,'I'=>73,'J'=>74,
                'K'=>75,'L'=>76,'M'=>77,'N'=>78,'O'=>79,'P'=>80,'Q'=>81,'R'=>82,'S'=>83,'T'=>84,
                'U'=>85,'V'=> 86,'W'=>87,'X'=>88,'Y'=>89,'Z'=>90    
            };
            Base64CharCodes = new Map<String, Integer>();
            //lower case
            Set<String> pUpperCase = AlphaNumCharCodes.keySet();
            for(String pKey : pUpperCase){
                //the difference between upper case and lower case is 32
                AlphaNumCharCodes.put(pKey.toLowerCase(),AlphaNumCharCodes.get(pKey)+32);
                //Base 64 alpha starts from 0 (The ascii charcodes started from 65)
                Base64CharCodes.put(pKey,AlphaNumCharCodes.get(pKey) - 65);
                Base64CharCodes.put(pKey.toLowerCase(),AlphaNumCharCodes.get(pKey) - (65) + 26);
            }
            //numerics
            for (Integer i=0; i<=9; i++){
                AlphaNumCharCodes.put(string.valueOf(i),i+48);
                //base 64 numeric starts from 52
                Base64CharCodes.put(string.valueOf(i), i + 52);
            }
        }
        public Boolean testBit(String pValidFor,Integer n){
            //the list of bytes
            List<Integer> pBytes = new List<Integer>();
            //multiply by 6 since base 64 uses 6 bits
            Integer bytesBeingUsed = (pValidFor.length() * 6)/8;
            //will be used to hold the full decimal value
            Integer pFullValue = 0;
            //must be more than 1 byte
            if (bytesBeingUsed <= 1)
                return false;
            //calculate the target bit for comparison
            Integer bit = 7 - (Math.mod(n,8)); 
            //calculate the octet that has in the target bit
            Integer targetOctet = (bytesBeingUsed - 1) - (n >> bytesBeingUsed); 
            //the number of bits to shift by until we find the bit to compare for true or false
            Integer shiftBits = (targetOctet * 8) + bit;
            //get the base64bytes
            for(Integer i=0;i<pValidFor.length();i++){
                //get current character value
                pBytes.Add((Base64CharCodes.get((pValidFor.Substring(i, i+1)))));
            }
            //calculate the full decimal value
            for (Integer i = 0; i < pBytes.size(); i++)
            {
                Integer pShiftAmount = (pBytes.size()-(i+1))*6;//used to shift by a factor 6 bits to get the value
                pFullValue = pFullValue + (pBytes[i] << (pShiftAmount));
            }
            //& is to set the same set of bits for testing
            //shift to the bit which will dictate true or false
            Integer tBitVal = ((Integer)(Math.Pow(2, shiftBits)) & pFullValue) >> shiftBits;
            return  tBitVal == 1;
        }
    }


    /**
    * The method is used to get the currency IsoCode, currency Rate
    *
    @author Bin yu
    @created 2012-03-23
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return            map<String, >   key is IsoCode, value is Rate.
    *
    @changelog
    * 2012-03-23 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    private static void getExchangeRate(map<String, Decimal> map_isoCode_exchangeRate){
        for(CurrencyType ct : [SELECT  IsActive, IsCorporate, CreatedById, CreatedDate, IsoCode, Id, DecimalPlaces, LastModifiedById, LastModifiedDate, SystemModstamp, ConversionRate  
                               from CurrencyType]){
            map_isoCode_exchangeRate.put(ct.IsoCode, ct.ConversionRate);
        }
    }
    
    
    /**
    * The method is used to exchange the value between different IsoCode
    *
    @author Bin yu
    @created 2012-03-23
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return            map<String, >   key is IsoCode, value is Rate.
    *
    @changelog
    * 2012-03-23 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    private static Decimal transformIsoCode(Decimal sourceValue, String fromIsoCode, String toIsoCode, map<String, Decimal> map_isoCode_exchangeRate){
        Decimal result = 0;
        if(sourceValue != null){
            Decimal fromRate = 1; 
            Decimal toRate = 1; 
            if(map_isoCode_exchangeRate.get(fromIsoCode) != null && String.ValueOf(map_isoCode_exchangeRate.get(fromIsoCode)) != '') {
                fromRate =  map_isoCode_exchangeRate.get(fromIsoCode);
            }
            else fromRate = 1;
            if(map_isoCode_exchangeRate.get(toIsoCode) != null && String.ValueOf(map_isoCode_exchangeRate.get(toIsoCode)) != '') {
                toRate =  map_isoCode_exchangeRate.get(toIsoCode);
            }
            else toRate = 1;
            
            result = sourceValue * ( toRate / fromRate );
        }           
        return result;
    }

    public class TPicklistEntry{
        @AuraEnabled public string active {get;set;}
        @AuraEnabled public string defaultValue {get;set;}
        @AuraEnabled public string label {get;set;}
        @AuraEnabled public string value {get;set;}
        @AuraEnabled public string validFor {get;set;}
        public TPicklistEntry(){
            
        }
    }
    
    
    public class CustomParams {
        @AuraEnabled public String oppyId {get;set;}
        @AuraEnabled public list<String> list_PartIds {get;set;}
        @AuraEnabled public list<String> list_Years {get;set;}
        @AuraEnabled public String competitorName {get;set;}
        @AuraEnabled public String level {get;set;}
        
        public CustomParams() {
            this.oppyId = '';
            this.list_PartIds = new list<String>();
            this.list_Years = new list<String>();
            this.competitorName = '';
            this.level = '';
        }
    }

    public class CustomObject {
        @AuraEnabled public Boolean isExp {get;set;}
        @AuraEnabled public list<CustomPart> list_Parts {get;set;}
        @AuraEnabled public Opportunity opportunity {get;set;}
        @AuraEnabled public Boolean isView {get;set;}
        @AuraEnabled public Boolean isBom {get;set;}
        @AuraEnabled public map<String, map<String, list<Opportunity_Forecast__c>>> map_partId_year_oppyForecast {get;set;}
        @AuraEnabled public String error {get;set;}
        @AuraEnabled public String fiscalYear {get;set;}
        @AuraEnabled public list<String> list_Method {get;set;}
        @AuraEnabled public list<String> list_Level {get;set;}
        @AuraEnabled public list<String> list_Confidence {get;set;}
        @AuraEnabled public list<String> list_ProcessStatus {get;set;}
        @AuraEnabled public map<String,list<String>> map_ProcessStatus {get;set;}
        @AuraEnabled public list<String> list_Years {get;set;}
        @AuraEnabled public map<String,list<String>> map_LostReasons {get;set;}
        @AuraEnabled public list<String> list_WonReasons {get;set;}
        @AuraEnabled public list<Account> list_Competitors {get;set;}
        @AuraEnabled public map<String, map<String, list<CustomFiscalDate>>> map_FiscalDates {get;set;}
        @AuraEnabled public String fiscalFiveYearEndDate {get;set;}
        @AuraEnabled public String fiscalFiveYearStartDate {get;set;}
        @AuraEnabled public Boolean canContinue {get;set;}
        @AuraEnabled public String message {get;set;}
        @AuraEnabled public String notifyMessage {get;set;}
        @AuraEnabled public String notifyContactRoleMessage {get;set;}
        @AuraEnabled public map<String, Boolean> map_change {get;set;}
        @AuraEnabled public Boolean isShowMussUpdate {get;set;}
        @AuraEnabled public Boolean isAPL {get;set;}
        @AuraEnabled public Boolean isADM {get;set;}
        @AuraEnabled public Boolean isIND {get;set;}
        @AuraEnabled public Boolean isDND {get;set;}
        @AuraEnabled public Boolean isMED {get;set;}
        @AuraEnabled public Profile profile {get;set;}
        @AuraEnabled public String classname {get;set;}
        /**
         * This attribute is used for identification the oppty is SPIN
         * when record type =(IND_Engineering_project or IND_Sales_Project) then isSPIN = true;
         * 2017-4-18 <rui.qiao@capgemini.com>
         */
        @AuraEnabled public boolean isSPIN {get;set;}
        /**
         * This attribute is used for identification the current user is an Admin or not
         * 2017-4-18 <rui.qiao@capgemini.com>
         */
        @AuraEnabled public boolean isAdmin {get;set;}
        /**
         * This attribute is used for get default confidence status
         * 2017-11-17 <shengpeng.xiao@capgemini.com>
         */
        @AuraEnabled public String defaultConfidence {get;set;}
        /**
         * This attribute is used for get default process status
         * 2017-11-17 <shengpeng.xiao@capgemini.com>
         */
        @AuraEnabled public String defaultProcessStatus {get;set;}
        
        
        public CustomObject() {
            /* added by simon @2017-11-17 start*/
            this.defaultConfidence = '';
            this.defaultProcessStatus = '';
            /* added by simon @2017-11-17 end*/
            
            this.profile = new Profile();
            this.isExp = false;
            this.isView = false;
            this.isBom = false;
            this.canContinue = false;
            this.error = '';
            this.fiscalYear = String.valueOf(Date.today().year());
            this.opportunity = new Opportunity(); 
            this.list_Parts = new list<CustomPart>();
            this.map_partId_year_oppyForecast = new map<String, map<String, list<Opportunity_Forecast__c>>>();
            this.list_Method = new list<String>();
            this.list_Level = new list<String>();
            this.list_Confidence = new list<String>();
            this.list_ProcessStatus = new list<String>();
            this.map_ProcessStatus = new map<String, list<String>>();
            this.list_Years = new list<String>();
            this.map_LostReasons = new map<String,list<String>>();
            this.list_WonReasons = new list<String>();
            this.list_Competitors = new list<Account>();
            this.map_FiscalDates = new map<String, map<String, list<CustomFiscalDate>>>();
            this.fiscalFiveYearEndDate = '';
            this.fiscalFiveYearStartDate = '';
            this.message = '';
            this.notifyMessage = '';
            this.notifyContactRoleMessage = '';
            this.map_change = new map<String, Boolean>();
            this.map_change.put('isChange', false);
            this.isShowMussUpdate = false;
            this.classname = 'LtngOpportunityForecastCtrl';
            this.isAPL = false;
            this.isADM = false;
            this.isIND = false;
            this.isSPIN = false;
            this.isAdmin = false;
            this.isDND = false;
            this.isMED = false;
        }
        
    }
    
    public class CustomPart {
        @AuraEnabled public Boolean isView {get;set;}
        @AuraEnabled public String quantity {get;set;}
        @AuraEnabled public String status {get;set;}
        @AuraEnabled public Opportunity_Part__c part {get;set;}
        @AuraEnabled public Boolean isChecked {get;set;}
        @AuraEnabled public Boolean isChangeConfidence {get;set;}
        public CustomPart(Opportunity_Part__c oppypart) {
            this.part = oppypart;
            this.status = oppypart.Status__c;
            this.isView = false;
            this.quantity = (oppypart.Quantity__c != null ? oppypart.Quantity__c.format() : '');
            this.isChecked = false;
            this.isChangeConfidence = false;
        }
    }
    
    
    public class CustomFiscalDate {
        @AuraEnabled public String fiscalYear {get;set;}
        @AuraEnabled public String fiscalQuarter {get;set;}
        @AuraEnabled public String fiscalMonth {get;set;}
        @AuraEnabled public String startDate {get;set;}
        @AuraEnabled public String endDate {get;set;}

        
        public CustomFiscalDate() {
            this.fiscalYear = '';
            this.fiscalQuarter = '';
            this.fiscalMonth = '';  
            this.startDate = '';
            this.endDate = '';  
        }
        
    }
    
    
    public class SaveData {
        
        @AuraEnabled public Opportunity opportunity {get;set;}
        @AuraEnabled public list<Opportunity_Part__c> list_Parts {get;set;}
        @AuraEnabled public String isocode {get;set;}
        @AuraEnabled public String method {get;set;}
        @AuraEnabled public String level {get;set;}
        @AuraEnabled public list<String> list_DelYears {get;set;}
        
        @AuraEnabled public String oppyId {get;set;}
        @AuraEnabled public list<String> list_fiscalYear {get;set;}
        @AuraEnabled public list<Opportunity_Forecast__c> list_oppyForecast {get;set;}
        
        @AuraEnabled public Boolean isAPL {get;set;}
        
        public SaveData() {
            this.opportunity = new opportunity();
            this.method = '';
            this.level = '';
            this.isocode = 'USD';
            this.oppyId = '';
            this.list_Parts = new list<Opportunity_Part__c>();
            this.list_oppyForecast = new list<Opportunity_Forecast__c>();
            this.list_DelYears = new list<String>();
            this.list_fiscalYear = new list<String>();
            this.isAPL = false;
            
        }
    }
    
    public class SaveReturn {
        @AuraEnabled public Boolean canContinue {get;set;}
        @AuraEnabled public String error {get;set;}
        @AuraEnabled public Boolean isUpdateOppy {get;set;}

        public SaveReturn () {
            this.canContinue = false;
            this.error = '';
            this.isUpdateOppy = false;
        }
    }
    
}