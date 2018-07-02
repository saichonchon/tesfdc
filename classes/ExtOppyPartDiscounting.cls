/*------------------------------------------------------------
    Author:        Bin Yuan <bin.yuan@capgemini.com> 
    Description:   This class used for managing Opportunity_Part__c and Part__c
    Inputs:        
    Test Class:    ExtOppyPartDiscountingTest
    History
    2017-07-10     Bin Yuan <bin.yuan@capgemini.com> Created
    ------------------------------------------------------------*/
global without sharing class ExtOppyPartDiscounting {
    public list<OppyPartDiscountItem> list_oppyPartItems {get; set;}
    public String str_oppyPartJson {get; set;}
    public String str_priceBreakJson {get; set;}
    public Opportunity oppy {get; set;}
    public boolean displayPopup {get; set;}
    public boolean displayUploadPopup {get; set;}
    public String searchText {get; set;}
    public String str_partListJson {get; set;}
    public String str_partNumb {get; set;}
    public String str_partDescription {get; set;}
    public transient list<Part__c> list_parts {get; set;}
    public String str_partIds2AddJson {get; set;}
    public String str_partIds2AddJsonWithNum {get; set;}
    public String str_oppyPartJson2Save {get; set;}
    public set<String> set_partId {get; set;}
    public set<String> set_partId2 {get; set;}     //added by yuan yao  2017-10-05
    public Integer oppylist_index {get; set;}
    public String str_oppIdPartNumberJson {get; set;}
    public list<OppyPartDiscountItem> list_uploadFailedData {get; set;}
    //public list<String> list_partId2Add {get; set;}
    public transient list<Price_Break__c> list_priceBreakForPage   { get; set; }
    private final ApexPages.standardController stdCtrl; 
    
    public static decimal dec_defaultQuantity = 100;
    public String str_thousandSep {get; set;}
    public String str_decimalSep {get; set;}
    
    public boolean displayPartSearchError {get; set;}
    public boolean displayPartSearchNoResult {get; set;}
    public integer int_searchNoResultCounter {get; set;}
    
    public boolean displayAmpicsButton {get; set;}
    public boolean isSearchSetByComma {get; set;}
    public static boolean isSaveHasError {get; set;}
    
    public boolean displayEditAndAddButton {get; set;} 
    public boolean displayNoEditMessage {get; set;} 
    
    public boolean hasTerritory {get; set;}  
    public boolean hasERPforPricing {get; set;} 
    
    //these 3 params used for the page's ERPforPricing save functionality.
    public String str_ERPforPricingValue {get; set;}
    public String str_ERPforPricingResult {get; set;}
    public Set<String> set_ERPforPricingPicklistOptions {get;set;}
    
    //these 4 params used for the page's currency transform.
    public String str_currencyFromValue {get; set;}
    public String str_currencyToValue {get; set;}
    public String str_currencyFromCode {get; set;}
    public String str_currencyToCode {get; set;}
    
    
    public static boolean isEnergyPartManagementSave = false;
    public static Integer cost_DefaultQuantity = 1;
    public set<Id> set_oppyPartIDs {get; set;}
    public String str_deleteOppyPartIds {get; set;}
    
    public Decimal dec_currMaxSeqNumber {get; set;}
    public Decimal dec_oppyTotalAmount {get; set;}
    public Decimal dec_oppyTotalAmountUSD {get; set;}
    
    public String str_searchTerritoryName {get; set;}
    public transient list<Sales_Hierarchy__c> list_territorySearchResult {get; set;}
    public String str_listTerritory {get; set;}
    public String str_selectTerritoryId {get; set;}
    public String str_SaveTerritoryResult {get; set;}
    
    public Decimal dec_exchangeRate {get; set;}
    
    public String str_errorMessage {get; set;}
    
    public transient set<String> set_partNotINSearchResult {get; set;}
    public String addPartsNewActionResult {get; set;}
    
    public static boolean bool_isInEditERPForPricing = false;
        /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////



    /*------------------------------------------------------------
    Author:        Bin Yuan <bin.yuan@capgemini.com>
    Description:   The contsructor
    Inputs:        
    Returns:       
    History
    2017-07-10     Bin Yuan <bin.yuan@capgemini.com> created
    ------------------------------------------------------------*/      
    public ExtOppyPartDiscounting(ApexPages.standardController stdCtrl) {
        this.stdCtrl = stdCtrl;    
        oppy = (Opportunity) stdCtrl.getRecord();
        for(Opportunity op :[select Id,Account.Source_System__c,Account_Number__c,currencyIsoCode,AccountId,ERP_For_Pricing__c,Territory__c,
                                Account.Sales_Hierarchy__c,
                                Primary_Product_Hierarchy__c,Approval_Status__c,Account.recordtype.name,recordtype.developername,stagename from Opportunity where id=:oppy.Id]){
            oppy = op;
        }
        
        
        //init();
    }
    
    /*------------------------------------------------------------
    Author:        Bin Yuan <bin.yuan@capgemini.com>
    Description:   init method
    Inputs:        
    Returns:       
    History
    2017-07-10     Bin Yuan <bin.yuan@capgemini.com> created
    ------------------------------------------------------------*/  
    public void init() {
        /*
        if(oppy.Territory__c == null || oppy.ERP_for_Pricing__c == null ){
            boolean bool_isNeedUpdateOppy = false;
            
            if(oppy.Territory__c == null && oppy.Account != null && oppy.Account.Sales_Hierarchy__c != null){
                oppy.Territory__c = oppy.Account.Sales_Hierarchy__c;
                bool_isNeedUpdateOppy = true;
            }
            if((oppy.ERP_for_Pricing__c == null || oppy.ERP_for_Pricing__c == '') && oppy.Account != null && oppy.Account.Source_System__c != null){
                if(oppy.Account.Source_System__c == 1) {
                    oppy.ERP_for_Pricing__c = 'SAP';
                } else if(oppy.Account.Source_System__c == 42) {
                    oppy.ERP_for_Pricing__c = 'Ampics';
                } else if(oppy.Account.Source_System__c == 51) {
                    oppy.ERP_for_Pricing__c = 'MFGPRO';
                } else {
                    oppy.ERP_for_Pricing__c = 'No ERP';
                }
                bool_isNeedUpdateOppy = true;
            }
            
            if(bool_isNeedUpdateOppy){
                update oppy;
            }
        }
        */
        
        for(Opportunity op :[select Id,Account.Source_System__c,Account_Number__c,currencyIsoCode,AccountId,ERP_For_Pricing__c,Territory__c,
                                Account.Sales_Hierarchy__c,
                                Primary_Product_Hierarchy__c,Approval_Status__c,Account.recordtype.name,recordtype.developername,stagename  from Opportunity where id=:oppy.Id]){
            oppy = op;
        }

        if(oppy.Territory__c == null || oppy.ERP_for_Pricing__c == null ){
            if(oppy.Territory__c == null && oppy.Account != null && oppy.Account.Sales_Hierarchy__c != null){
                oppy.Territory__c = oppy.Account.Sales_Hierarchy__c;
            }
            //Modified By Buwen Guo 2017-12-11
            //This logic has been moved into opportunity trigger so remove it.
            /*
            if((oppy.ERP_for_Pricing__c == null || oppy.ERP_for_Pricing__c == '') && oppy.Account != null && oppy.Account.Source_System__c != null){
                if(oppy.Account.Source_System__c == 1) {
                    oppy.ERP_for_Pricing__c = 'SAP';
                } else if(oppy.Account.Source_System__c == 42) {
                    oppy.ERP_for_Pricing__c = 'Ampics';
                } else if(oppy.Account.Source_System__c == 51) {
                    oppy.ERP_for_Pricing__c = 'MFGPRO';
                } else {
                    oppy.ERP_for_Pricing__c = 'No ERP';
                }
            }
            */
        }
        
        //this.list_partId2Add = new list<String>();
        this.str_partIds2AddJson = '';
        this.str_oppyPartJson2Save = '';
        this.str_errorMessage = '';
        this.str_partNumb = '';
        this.str_partDescription = '';
        this.displayPartSearchError = false;
        this.displayPartSearchNoResult = false;
        this.int_searchNoResultCounter = 0;
        this.isSearchSetByComma = false;
        isSaveHasError = false;
        initCurrencyTransformParams();
        this.dec_oppyTotalAmount = 0;
        this.dec_oppyTotalAmountUSD = 0;
        
        str_oppyPartJson = Json.serialize(list_oppyPartItems);
        setAmpicsButtonState();
        setThousandAndDecimalSep();
        getOppyParts();
        getPriceBreak();
        this.displayEditAndAddButton = true;
        this.displayNoEditMessage = true;
        
        //Add by requirement from email:Adding parts and changing prices on the Opportunity
        String str_stageName = oppy.stagename;
        if(str_stageName != null && str_stageName != ''){
            //Added by Buwen Guo 2017-10-03:add closed condition.
            if(oppy.recordtype.developername == 'Energy_Sales' && (str_stageName.toLowerCase().contains('won') || str_stageName.toLowerCase().contains('closed') )){
                this.displayEditAndAddButton = false;
            }
        }
        
        //Add by requirement from email:Bugs and requests for Today (point 7)
        //7.If the Approval Status is "Approval Required", "Awaiting Approval" or "Rejected" then you should hide "Add parts" and hide the Edit button and the "Upload .csv" button 
        //Modified by requirement from email:Must Fix Bugs #3
        //3.You should NOT prevent partMgmt when the Approval Status is "Approval Required". 
        //if(oppy.Approval_Status__c == 'Awaiting Approval' || oppy.Approval_Status__c == 'Rejected'){
        
        //Modified by Buwen Guo 2018-04-09 Approvers can edit the opportunity part when Opportunity is in the approval process.
        set<String> set_approverIds = new set<String>();
        //for(ProcessInstanceStep pis : [select id, OriginalActorId from ProcessInstanceStep where ProcessInstance.TargetObjectId = :oppy.Id]){
        for(ProcessInstanceWorkitem pis : [SELECT Id, OriginalActorId FROM ProcessInstanceWorkitem where ProcessInstance.TargetObjectId = :oppy.Id]){
            set_approverIds.add(pis.OriginalActorId);
        }
        system.debug('set_approverIds::'+set_approverIds);
        system.debug('getUserId::'+UserInfo.getUserId());
        
        //Modifyed by Tangyong Li 2017-10-09 by requirement: We should prevent editing parts only when the opportunity "Awaiting Approval"
        if(!set_approverIds.contains(UserInfo.getUserId()) && oppy.Approval_Status__c == 'Awaiting Approval'){
            this.displayEditAndAddButton = false;
            this.displayNoEditMessage = false;
            //Added by Buwen Guo 2018-03-22 requirement from email:Bugs to Fix... point 3
            this.str_errorMessage = 'This Opportunity is in the approval process and cannot be edited.';
            isSaveHasError = true;
            displayUploadPopup = false;
            displayPopup = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, str_errorMessage));
        }
        
        isEnergyPartManagementSave = false;
        this.str_searchTerritoryName = '';
        this.list_territorySearchResult = new list<Sales_Hierarchy__c>();
        this.str_selectTerritoryId = '';
        
        
        //modified by Tangyong Li 2018-01-22 
        /* 
        //Added by Buwen Guo 2017-12-11 from email:12/10 Issue to fix - part 1 point 2
        //init the USD exchange rate for opportunity part page.
        map<String, Decimal> map_isoCode_exchangeRate = new map<String, Decimal>();
        for(CurrencyType ct : [SELECT  IsActive, IsCorporate, CreatedById, CreatedDate, 
                                        IsoCode, Id, DecimalPlaces, LastModifiedById, LastModifiedDate, 
                                        SystemModstamp, ConversionRate  
                               from CurrencyType]){
            map_isoCode_exchangeRate.put(ct.IsoCode, ct.ConversionRate);
        }
        
        Decimal fromRate = 1; 
        Decimal toRate = 1; 
        String fromIsoCode = oppy.currencyIsoCode;
        String toIsoCode = 'USD';
        if(map_isoCode_exchangeRate.get(fromIsoCode) != null && String.ValueOf(map_isoCode_exchangeRate.get(fromIsoCode)) != ''){
            fromRate =  map_isoCode_exchangeRate.get(fromIsoCode);
        }else{ 
            fromRate = 1;
        }
        if(map_isoCode_exchangeRate.get(toIsoCode) != null && String.ValueOf(map_isoCode_exchangeRate.get(toIsoCode)) != ''){
            toRate =  map_isoCode_exchangeRate.get(toIsoCode);
        }else{
            toRate = 1;
        }
        
        this.dec_exchangeRate = ( toRate / fromRate );*/
        
        String fromIsoCode = oppy.currencyIsoCode;
        String toIsoCode = 'USD';
        this.dec_exchangeRate = ClsAPLForecastUtil.transformIsoCode(1,fromIsoCode,toIsoCode);
        system.debug('dec_exchangeRate::::  ' + this.dec_exchangeRate);
        //end
    }
    
    
    
    /*------------------------------------------------------------
    Author:        Bin Yuan <bin.yuan@capgemini.com>
    Description:   method to init Ampics records state
    Inputs:        
    Returns:       
    History
    2017-07-10     Bin Yuan <bin.yuan@capgemini.com> created
    ------------------------------------------------------------*/  
    public void setAmpicsButtonState(){
        this.displayAmpicsButton = false;
        set<Decimal> set_AmpicsNumber = new set<Decimal>{36,43,110,34,187,42,269,272};
        User currUser = [select id,MED_Region__c from user where id=:UserInfo.getUserId()];
        
        /*
        if(set_AmpicsNumber.contains(oppy.Account.Source_System__c)){
            this.displayAmpicsButton = true;
        }else if(oppy.Account.Source_System__c == 1 || oppy.Account.Source_System__c == 51){
            this.displayAmpicsButton = false;
        }else if(oppy.Account.recordtype.name == 'Prospect' && currUser.MED_Region__c == 'Aus / New Zlnd'){
            this.displayAmpicsButton = true;
        }
        */
        

        
        //Add with requirement from email:            It's a big change: No Account on the Opportunity! (point 5)
        if(oppy.ERP_For_Pricing__c == 'ANZPAC'){
            this.displayAmpicsButton = true;
        }else{
            this.displayAmpicsButton = false;
        }
        
        
        //Add with requirement from email:            Determining the Pricing ERP System to Use for Opportunities (SAP/MFGPRO/AMPICS) (point 1)
        //Modified with requirement from email :      More Work! Let's Discuss at 10am your time  (point 3)
        //Modified with requirement from email :      It's a big change: No Account on the Opportunity! (point 4)
        this.hasTerritory = true;
        system.debug('oppy.Territory__c'+oppy.Territory__c);
        if(oppy.Territory__c == null){
            system.debug('null???');
            this.hasTerritory = false;
        }
        
        
        //Add with requirement from email:            Determining the Pricing ERP System to Use for Opportunities (SAP/MFGPRO/AMPICS) (point 2)
        //Modified with requirement from email :      More Work! Let's Discuss at 10am your time  (point 3)
        //Modified with requirement from email :      Modified with requirement from email  (point 1)  We should only ask for the ERP if the sourceSystem on the Account doesn't have a number that we recognize. 
        //modified by yuan yao 2017-10-05
        //Modified with requirement from email :       It's a big change: No Account on the Opportunity! (point 4)
        this.hasERPforPricing = true;
        if(oppy.ERP_for_Pricing__c == null || oppy.ERP_for_Pricing__c == ''){
            this.hasERPforPricing = false;
        }
        
        //
        set_ERPforPricingPicklistOptions = new set<String>();
        set_ERPforPricingPicklistOptions.add('SAP (except ANZPAC)');
        set_ERPforPricingPicklistOptions.add('MFGPRO');
        set_ERPforPricingPicklistOptions.add('ANZPAC');
        set_ERPforPricingPicklistOptions.add('No ERP');
    }
    
    
    
    /*------------------------------------------------------------
    Author:        Bin Yuan <bin.yuan@capgemini.com>
    Description:   method to search Sales_Hierarchy__c
    Inputs:        
    Returns:       
    History
    2017-07-10     Bin Yuan <bin.yuan@capgemini.com> created
    ------------------------------------------------------------*/  
    public void searchSalesHierarchyByName(){
        system.debug('searchSalesHierarchyByName::'+str_searchTerritoryName);
        /*
        Set<String> set_userIds = new set<String>();
        String str_sql = 'select id,name from user where name like \'%'+str_searchTerritoryName + '%\' limit 1000';
        for(User u : database.query(str_sql)){
            set_userIds.add(u.Id);
        }*/
        
        this.list_territorySearchResult = new list<Sales_Hierarchy__c>();
        String str_sql = 'select id,name,Hierarchy_Type__c from Sales_Hierarchy__c where Level_7_Default_Owner__r.name like \'%'+str_searchTerritoryName + '%\' limit 1000';
        map<Id, String> map_shId_shType = new map<Id, String>();
        for(Sales_Hierarchy__c sh : database.query(str_sql)){
            list_territorySearchResult.add(sh);
            map_shId_shType.put(sh.Id, sh.Hierarchy_Type__c);
        }
        this.str_listTerritory = Json.serialize(map_shId_shType);
    }
    
    
    
    /*------------------------------------------------------------
    Author:        Bin Yuan <bin.yuan@capgemini.com>
    Description:   method to save Territory__c on opportunity
    Inputs:        
    Returns:       
    History
    2017-07-10     Bin Yuan <bin.yuan@capgemini.com> created
    ------------------------------------------------------------*/
    public void saveTerritoryToOppy(){
        try{
            system.debug('saveTerritoryToOppy::'+str_selectTerritoryId);
            str_SaveTerritoryResult = 'success';
            if(str_selectTerritoryId != null && str_selectTerritoryId != ''){
                oppy.Territory__c = str_selectTerritoryId;
                update oppy;
            }
            for(Opportunity op :[select Id,Account.Source_System__c,Account_Number__c,currencyIsoCode,AccountId,ERP_For_Pricing__c,Territory__c,
                                Account.Sales_Hierarchy__c,
                                Primary_Product_Hierarchy__c,Approval_Status__c,Account.recordtype.name,recordtype.developername,stagename  from Opportunity where id=:oppy.Id]){
                oppy = op;
            }
        }catch(Exception ex) {
            system.debug('Exception::'+ex.getMessage()+','+ex.getStackTraceString());
            
            ErrorLogging.Log(ex);
            String vStrError = '';
            vStrError += 'Error Type = ' + ex.getTypeName() + 
                ' Error Line = ' + ex.getLineNumber() + '' + 
                ' Error Stack = ' + ex.getStackTraceString() + 
                ' Error Message = ' + ex.getMessage();
            
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,                   
                                         SalesforceConstant.strError, '', '', '', '5','','','Exception', ex.getLineNumber() + '',ex.getStackTraceString());
            
            boolean isPassContactRoleCheck = checkContactRole(oppy.Id);
            if(isPassContactRoleCheck){
                str_SaveTerritoryResult = ex.getMessage();
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getMessage()));
            }else{
                str_SaveTerritoryResult =  'Error: You must create a contact role on this opportunity before you can perform this operation.';
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, str_SaveTerritoryResult));
            }
        }
    }
    
    
    
    /*------------------------------------------------------------
    Author:        Bin Yuan <bin.yuan@capgemini.com>
    Description:   method to save ERP_for_Pricing__c on opportunity
    Inputs:        
    Returns:       
    History
    2017-07-10     Bin Yuan <bin.yuan@capgemini.com> created
    ------------------------------------------------------------*/
    public void saveERPforPricing(){
        try{
        	str_ERPforPricingResult = 'success';
            /*
            if(oppy.AccountId == null){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error,'Please select a account for this opportunity.'));
                str_ERPforPricingResult = 'Please select a account for this opportunity.';
                return ;
            }
            Account endCustomer = [select id from account where id =: oppy.AccountId limit 1];
            */
            if(str_ERPforPricingValue != null && str_ERPforPricingValue != ''){
            	//Added by buwen guo  2018-04-27 IR-04400 Update- Please apply a check that if ERP was changed from blank to some valid value, then no pricing call should be triggered
            	bool_isInEditERPForPricing = true;
                oppy.ERP_for_Pricing__c = str_ERPforPricingValue;
                update oppy;
                this.hasERPforPricing = true;
            }else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error,'We can not find accountId for this opportunity.'));
                str_ERPforPricingResult = 'We can not find accountId for this opportunity.';
                return ;
            }
            for(Opportunity op :[select Id,Account.Source_System__c,Account_Number__c,currencyIsoCode,AccountId,ERP_For_Pricing__c,Territory__c,
                                Account.Sales_Hierarchy__c,
                                Primary_Product_Hierarchy__c,Approval_Status__c,Account.recordtype.name,recordtype.developername,stagename  from Opportunity where id=:oppy.Id]){
                oppy = op;
            }
        }catch(Exception ex) {
            system.debug('Exception::'+ex.getMessage()+','+ex.getStackTraceString());
            
            ErrorLogging.Log(ex);
            String vStrError = '';
            vStrError += 'Error Type = ' + ex.getTypeName() + 
                ' Error Line = ' + ex.getLineNumber() + '' + 
                ' Error Stack = ' + ex.getStackTraceString() + 
                ' Error Message = ' + ex.getMessage();
            
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,                   
                                         SalesforceConstant.strError, '', '', '', '5','','','Exception', ex.getLineNumber() + '',ex.getStackTraceString());
                                         
            boolean isPassContactRoleCheck = checkContactRole(oppy.Id);
            if(isPassContactRoleCheck){
                str_ERPforPricingResult = ex.getMessage();
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getMessage()));
            }else{
                str_ERPforPricingResult =  'Error: You must create a contact role on this opportunity before you can perform this operation.';
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, str_ERPforPricingResult));
            }
        }
    }
    
    
    
    /*------------------------------------------------------------
    Author:        Bin Yuan <bin.yuan@capgemini.com>
    Description:   method to format number field
    Inputs:        
    Returns:       
    History
    2017-07-10     Bin Yuan <bin.yuan@capgemini.com> created
    ------------------------------------------------------------*/
    public void setThousandAndDecimalSep(){
        Decimal value = 1000.10;
        String formattedValue = value.format();
        String thousandSep = formattedValue.substring(1,2);
        String decimalSep = formattedValue.substring(5,6);
        this.str_thousandSep = thousandSep;
        this.str_decimalSep = decimalSep;
    }
    
    

    /*------------------------------------------------------------
    Author:        Bin Yuan <bin.yuan@capgemini.com>
    Description:   Method to get opportunity part
    Inputs:        
    Returns:       
    History
    2017-07-10     Bin Yuan <bin.yuan@capgemini.com> created
    ------------------------------------------------------------*/
    public void getOppyParts() {
        list_oppyPartItems = new list<OppyPartDiscountItem>();
        set_partId = new set<String>();
        set_partId2 = new set<String>();
        this.set_oppyPartIDs = new Set<Id>();
        list<Opportunity_Part__c> list_oppyParts = new list<Opportunity_Part__c>();

        for(Opportunity_Part__c part : [Select Id, Part__r.RPN_Part__c,Part__r.RPN_Description__c,Code_for_unit_of_measurement__c, Lead_Time__c, Min_Order_Qty__c, Name, Quantity__c, List_Price__c, Offered_Price__c, Fraction_of_sale__c, Part__r.Description__c,Status__c,Standard_Cost__c,
                                               Part__c, Part__r.Name, Sales_Price__c, ADM_Product_CBC4_Description__c , Comments__c ,Cost_Price__c,NDR_Item_Price_UOM__c,Reason_Lost_Comments__c,
                                               Energy_Quote_Line_Item__c,Energy_Quote_Line_Item__r.Energy_Quote_Name__c,Energy_Quote_Line_Item__r.Energy_Quote_Name__r.Quote_Number__c,Margin_CS75__c,
                                               Part__r.Product_hierarchy__r.CBC4_Description__c,Part__r.Product_hierarchy__c,Part__r.BASE_UM_CDE__c,part__r.Proposal_Part__c,Seq_No__c,Total_Price__c,
                                               NDR_Competitor_Name__c,NDR_Competitor_Part_Number__c,Competitor_Price__c,Primary_Pack_Quantity__c,Max_Qty_in_Standard_lead_time__c,Error_Message__c,
                                               part__r.STANDARD_PACKAGING_QTY__c,Availability__c,Information_Message__c,Proposal_Part_Name_Override__c,NDR_Item_Price_Per__c,ERP_Pricing_Status__c
                                        From Opportunity_Part__c 
                                        Where Opportunity__c =: this.oppy.Id]) {
            
            
            set_partId.add(part.part__c);   
            list_oppyParts.add(part);
            set_oppyPartIDs.add(part.Id);
            
            dec_oppyTotalAmount = dec_oppyTotalAmount + part.Total_Price__c;               
        }
        //Added by Buwen Guo 2017-12-05 from email:Issues 12/5 point 3
        dec_oppyTotalAmountUSD = (dec_oppyTotalAmount == 0?0:ClsAPLForecastUtil.transformIsoCode(dec_oppyTotalAmount,oppy.currencyIsoCode,'USD'));
        dec_oppyTotalAmountUSD = dec_oppyTotalAmountUSD.setScale(2);
        
        //get related Energy_Quote_Line_Item__c
        map<String,list<Energy_Quote_Line_Item__c>> map_partId_quoteLineItems = new map<String,list<Energy_Quote_Line_Item__c>>();
        for(Energy_Quote_Line_Item__c qli : [select id,Energy_Quote_Name__r.Opportunity_Name__r.NDR_Sold_to_Account_Name__c,Quantity__c,Energy_Quote_Name__r.Opportunity_Name__r.Account.name,
                                                    UnitPrice__c,Part__c,Energy_Quote_Name__c,Energy_Quote_Name__r.Quote_Number__c,CurrencyIsoCode,
                                                    Energy_Quote_Name__r.Opportunity_Name__r.CloseDate,Energy_Quote_Name__r.Contract_start_date__c,Energy_Quote_Name__r.Contract_Finish_Date__c,
                                                    Energy_Quote_Name__r.Opportunity_Name__r.End_Customer__r.name
                                                from Energy_Quote_Line_Item__c 
                                                where Part__c IN :set_partId 
                                                and Energy_Quote_Name__r.Opportunity_Name__r.AccountId =: this.oppy.AccountId 
                                                //Added by Buwen Guo 2018-04-20 requirement from:IR-04341 POINT 4
                                                and Energy_Quote_Name__r.Opportunity_Name__c !=: this.oppy.Id 
                                                /*START - Added by Yiming Shen <yiming.shen@capgemini.com> at 2018/3/28*/
                                                AND Energy_Quote_Name__r.Quote_Type__c != 'Meet Competitor Price' 
                                                /*END - Added by Yiming Shen <yiming.shen@capgemini.com> at 2018/3/28*/
                                                and Energy_Quote_Name__r.Expiration_Date__c >= today]){
                                                //where Part__c IN :set_partId and Energy_Quote_Name__r.Opportunity_Name__r.AccountId =: this.oppy.AccountId and Energy_Quote_Name__r.Approval_Status__c = 'Won'
                                                //and Energy_Quote_Name__r.Contract_start_date__c <= today and Energy_Quote_Name__r.Contract_Finish_Date__c >= today]){
            
            //Added by Buwen Guo 2017-10-26 from email:Valid To and For and other issues point 2
            //if(qli.Energy_Quote_Name__r.Opportunity_Name__r.CloseDate >= qli.Energy_Quote_Name__r.Contract_start_date__c && qli.Energy_Quote_Name__r.Opportunity_Name__r.CloseDate == qli.Energy_Quote_Name__r.Contract_Finish_Date__c){
                if(!map_partId_quoteLineItems.containsKey(qli.Part__c)){
                    map_partId_quoteLineItems.put(qli.Part__c,new list<Energy_Quote_Line_Item__c>());
                }
                if(qli.UnitPrice__c != null) qli.UnitPrice__c = qli.UnitPrice__c.setScale(2);
                map_partId_quoteLineItems.get(qli.Part__c).add(qli);
            //}
        }
        
        //get related Inventory__c
        map<String,list<Inventory__c>> map_partId_Inventories = new map<String,list<Inventory__c>>();
        for(Inventory__c qli : [select id,PartNbr__c,Status__c,Location__c,QOH_Nettable__c 
                                        from Inventory__c 
                                        where PartNbr__c IN :set_partId ]){
            
            if(!map_partId_Inventories.containsKey(qli.PartNbr__c)){
                map_partId_Inventories.put(qli.PartNbr__c,new list<Inventory__c>());
            }
            map_partId_Inventories.get(qli.PartNbr__c).add(qli);
        }
        
        //get related Energy_Price_Book_Entry__c cost
        map<String,decimal> map_partId_pricebookCosts = new map<String,decimal>();
        
        for(Energy_Price_Book_Entry__c qli : [select id,UnitPrice__c,Part__c,StandardPrice__c
                                        from Energy_Price_Book_Entry__c 
                                        where Part__c IN :set_partId ]){
            
            if(!map_partId_pricebookCosts.containsKey(qli.Part__c)){
                //Edit by Buwen Guo 2017-10-30 from email:Things to fix 
                //Change UnitPrice__c to StandardPrice__c.
                //Modified by Buwen Guo 2017-12-01 from email:Issues 11/30 point 4
                map_partId_pricebookCosts.put(qli.Part__c,qli.UnitPrice__c);
                //map_partId_pricebookCosts.put(qli.Part__c,qli.StandardPrice__c);
            }
        }
        
        
        for(Opportunity_Part__c pa : list_oppyParts){
            list_oppyPartItems.add(generateOppyPartItem(pa,map_partId_quoteLineItems,map_partId_Inventories,map_partId_pricebookCosts));    
            list_oppyPartItems = oppyPartSort(list_oppyPartItems);
        }
        
        system.debug('map_partId_pricebookCosts::::::  ' + map_partId_pricebookCosts);
        system.debug('list_oppyPartItems::::::  ' + list_oppyPartItems);
        system.debug('112::this.oppy.cbc4::::::  ' + this.oppy.Primary_Product_Hierarchy__c);
    }
    

    
    /*------------------------------------------------------------
    Author:        Bin Yuan <bin.yuan@capgemini.com>
    Description:   Method to get Price_Break__c data
    Inputs:        
    Returns:       
    History
    2017-07-10     Bin Yuan <bin.yuan@capgemini.com> created
    ------------------------------------------------------------*/
    public void getPriceBreak() {
        this.str_priceBreakJson = '';
        this.list_priceBreakForPage = new list<Price_Break__c>();
        list<Price_Break__c> list_priceBreak = new list<Price_Break__c>();
        for(Price_Break__c priceBreak : [Select List_Price__c, Opportunity_Part__c, Quantity_high_end__c, Quantity_low_end__c, SOR_id__c, Updated_Date__c,currencyIsoCode
                                        From Price_Break__c
                                        Where Opportunity_Part__c in: set_oppyPartIDs order by Quantity_low_end__c asc NULLS LAST]) {
            //Added by Buwen Guo 2017-12-27 from email:Bugs 12/20 point 1
            priceBreak.List_Price__c = ClsAPLForecastUtil.transformIsoCode(priceBreak.List_Price__c,priceBreak.currencyIsoCode,oppy.currencyIsoCode);
            if(priceBreak.List_Price__c != null) priceBreak.List_Price__c = priceBreak.List_Price__c.setScale(2);
            list_priceBreak.add(priceBreak);                                
        }
        this.list_priceBreakForPage = list_priceBreak;
        this.str_priceBreakJson = Json.serialize(list_priceBreak);
    }



    /*------------------------------------------------------------
    Author:        Bin Yuan <bin.yuan@capgemini.com>
    Description:   Method to search part__c data
    Inputs:        
    Returns:       
    History
    2017-07-10     Bin Yuan <bin.yuan@capgemini.com> created
    ------------------------------------------------------------*/
    public void getParts() {
    	set<String> set_matchString = new set<String>();
    	list<Part__c> list_partsExactMatch = new list<Part__c>();
    	list<Part__c> list_partsNoExactMatch = new list<Part__c>();
        this.str_partListJson = '';
        this.displayPartSearchError = false;
        this.displayPartSearchNoResult = false;
        this.int_searchNoResultCounter = 0;
        
        list_parts = new list<Part__c>();
        this.set_partNotINSearchResult = new set<String>();
        PartSeracgSettings__c CSSearch = PartSeracgSettings__c.getInstance() ;// Check User If eligable for RPN Serach Code Added by TEIS CoE team
        
        
        system.debug('getParts:::str_partNumb::'+str_partNumb);
        system.debug('getParts:::str_partDescription::'+str_partDescription);
        
        Set<String> set_dummyPartNames = new Set<String>{'Transportation Costs', 'Installation Costs', 'Training Costs','Freight Costs','Commission Costs','Distribution Costs','Other Costs'};
        Boolean bool_isSearchSetByComma = false;
        
        String str_query = 'Select Id, Name, RPN_Part__c,RPN_Description__c,Description__c, GPL__r.Name, GPL_Description__c,  Product_Hierarchy__r.Name,UNIT_PACKAGING_QTY__c, '
                     + 'Product_Hierarchy__c, Product_Hierarchy__r.Hierarchy_Level_Type__c, Product_Hierarchy__r.Description__c,BASE_UM_CDE__c '
                     //+ 'From Part__c Where IsActive__c = true and Product_Hierarchy__r.CBC1__c = \'13005\' '
                     + 'From Part__c Where Product_Hierarchy__r.CBC1__c = \'13005\' and DISCONTINUANCE_STATUS_CDE__c != \'1\' ';
                     //+ ' and ( Id NOT IN: set_partId2 OR Name = null OR Name like \'%proposal%\' OR Name IN:set_dummyPartNames ) ';    modified by yuan yao  2017-10-05,delete by buwen guo 2018-04-19
        if(str_partNumb != null && str_partNumb != '') {
            str_partNumb = str_partNumb.trim();
            str_partNumb = str_partNumb.replaceAll('\n',',');
            if(str_partNumb.contains(',')){
                set<String> set_tempPartNumbers = new set<String>();
                for(String str_temp : str_partNumb.split(',')){
                	set_matchString.add(str_temp.trim());
                    set_tempPartNumbers.add(str_temp.trim());
                }
                //str_query += ' AND Name IN:set_tempPartNumbers ';
                str_query += (CSSearch.Enable_Rpn_Search__c) ? ' AND ((Name IN:set_tempPartNumbers) OR (RPN_Part__c IN:set_tempPartNumbers))' : ' AND ( Name IN:set_tempPartNumbers )';  // Code Modified by TEIS CoE (04-19-2018) to add RPN Condition 
                bool_isSearchSetByComma = true;
            }else{
                //str_query += ' AND Name = \'' + str_partNumb + '\' ';
                set_matchString.add(str_partNumb);
                str_query += (CSSearch.Enable_Rpn_Search__c) ? ' AND (Name = \'' + str_partNumb + '\'  OR RPN_Part__c  = \'' + str_partNumb + '\')' : ' AND ( Name = \'' + str_partNumb + '\' )'; // Code Modified by TEIS CoE (04-19-2018) to add RPN Condition 
            }
        }
        if(str_partDescription != null && str_partDescription != '') {
            str_partDescription = str_partDescription.trim();
            str_partDescription = str_partDescription.replaceAll('\n',',');
            if(str_partDescription.contains(',')){
                set<String> set_tempPartDescriptions = new set<String>();
                for(String str_temp : str_partDescription.split(',')){
                    set_tempPartDescriptions.add(str_temp.trim());
                    set_matchString.add(str_temp.trim());
                }
                //str_query += ' AND (Description__c IN:set_tempPartDescriptions OR GPL_Description__c IN:set_tempPartDescriptions OR Product_Hierarchy__r.Name IN:set_tempPartDescriptions  ';
                str_query += (CSSearch.Enable_Rpn_Search__c) ? ' AND (Description__c IN:set_tempPartDescriptions OR GPL_Description__c IN:set_tempPartDescriptions OR Product_Hierarchy__r.Name IN:set_tempPartDescriptions OR RPN_Description__c IN:set_tempPartDescriptions ' : ' AND (Description__c IN:set_tempPartDescriptions OR GPL_Description__c IN:set_tempPartDescriptions OR Product_Hierarchy__r.Name IN:set_tempPartDescriptions  ';
                for(String str_each : set_tempPartDescriptions){
                    //str_query += ' OR  Description__c = \'' + str_each + '\' ';
                    str_query += (CSSearch.Enable_Rpn_Search__c) ? ' OR  Description__c = \'' + str_each + '\' OR  RPN_Description__c  = \'' + str_each + '\' ' : ' OR  Description__c = \'' + str_each + '\' ';
                }
                bool_isSearchSetByComma = true;
                str_query += ' ) ';
            }else{
            	set_matchString.add(str_partDescription.trim());
                //str_query += ' AND (Description__c = \'' + str_partDescription + '\' OR GPL_Description__c = \'' + str_partDescription + '\' OR Product_Hierarchy__r.Name = \'' + str_partDescription + '\') ';
                if(CSSearch.Enable_Rpn_Search__c){
                    str_query += ' AND (Description__c = \'' + str_partDescription + '\' OR GPL_Description__c = \'' + str_partDescription + '\' OR Product_Hierarchy__r.Name = \'' + str_partDescription + '\' OR  RPN_Description__c = \'' + str_partDescription + '\') ';    
                }else{
                    str_query += ' AND (Description__c = \'' + str_partDescription + '\' OR GPL_Description__c = \'' + str_partDescription + '\' OR Product_Hierarchy__r.Name = \'' + str_partDescription + '\') ';
                }
            }
            //str_query += ' AND (Description__c like \'%' + str_partDescription + '%\' OR GPL_Description__c like \'%' + str_partDescription + '%\' OR Product_Hierarchy__r.Name like \'%' + str_partDescription + '%\') ';
        }
        str_query += ' order by Name NULLS FIRST limit 100';
        system.debug('str_query::'+str_query);
        set<String> set_actualGotParts = new set<String>();
        set<String> set_actualGotPartRPNs = new set<String>();
        for(Part__c part : DataBase.query(str_query)) {
            part.UNIT_PACKAGING_QTY__c = '';
            if(set_dummyPartNames.contains(part.Name)){
                //Added by requirement from mail:Last Full Day before the Power Users are in the system! point 2
                //Please have the GPL (and GPL Descrption) be blank for all the costs.
                //If the part is a Cost part,the page will hide the value by checking name is 'Costs'.
                part.Product_Hierarchy__r.Name = 'Costs';
                part.UNIT_PACKAGING_QTY__c = '1';
            }
            set_actualGotParts.add(part.Name);
            set_actualGotPartRPNs.add(part.RPN_Part__c);
            //list_parts.add(part);
            
            if(set_matchString.contains(part.Name) 
            	|| set_matchString.contains(part.RPN_Part__c)
            	|| set_matchString.contains(part.Description__c)
            	|| set_matchString.contains(part.RPN_Description__c)
            	|| set_matchString.contains(part.GPL_Description__c)
            	|| set_matchString.contains(part.Product_Hierarchy__r.Name) ) {
            
            	list_partsExactMatch.add(part);		
            } else {
            	list_partsNoExactMatch.add(part);		
            }
            
        }
        list_parts.addAll(list_partsExactMatch);
        list_parts.addAll(list_partsNoExactMatch);
        
        system.debug('set_matchString::'+set_matchString);
        
        system.debug('list_partsExactMatch::'+list_partsExactMatch);
        system.debug('list_partsNoExactMatch::'+list_partsNoExactMatch);
        
        if(str_partNumb != null && str_partNumb != '') {
            str_partNumb = str_partNumb.trim();
            str_partNumb = str_partNumb.replaceAll('\n',',');
            if(str_partNumb.contains(',')){
                set<String> set_tempPartNumbers = new set<String>();
                for(String str_temp : str_partNumb.split(',')){
                    str_temp = str_temp.trim();
                    if(!set_actualGotParts.contains(str_temp) && !set_actualGotPartRPNs.contains(str_temp)){
                        set_partNotINSearchResult.add(str_temp);
                    }
                }
                system.debug('set_partNotINSearchResult::'+set_partNotINSearchResult);
            }else{
                if(!set_actualGotParts.contains(str_partNumb) && !set_actualGotPartRPNs.contains(str_partNumb)){
                    set_partNotINSearchResult.add(str_partNumb);
                }
            }
        }
        this.int_searchNoResultCounter = set_partNotINSearchResult.size();
        this.isSearchSetByComma = bool_isSearchSetByComma;
        if(bool_isSearchSetByComma && list_parts.size() < 1){
            //this.displayPartSearchError = true;
            this.displayPartSearchError = false;
            if(list_parts.size() < 1){
                this.displayPartSearchNoResult = true;
            }else{
                this.displayPartSearchNoResult = false;
            }
        }else{
            this.displayPartSearchError = false;
            if(list_parts.size() < 1){
                this.displayPartSearchNoResult = true;
            }else{
                this.displayPartSearchNoResult = false;
            }
        }
        /*
        for(Part__c part : [Select Id, Name, Description__c, GPL__r.Name, GPL_Description__c,  Product_Hierarchy__r.Name, 
                                   Product_Hierarchy__c, Product_Hierarchy__r.Hierarchy_Level_Type__c, Product_Hierarchy__r.Description__c
                            From Part__c
                            Where Id NOT IN: set_partId AND Name like: '%' + str_partNumb + '%' AND Description__c like: '%' + str_partDescription + '%' 
                            order by Name 
                            limit 1000]) {
            list_parts.add(part);                           
        }*/
        system.debug('list_parts::::  ' + list_parts);
        system.debug('displayPopUp::::  ' + displayPopUp);
        system.debug('displayPartSearchError::::  ' + displayPartSearchError);
        system.debug('displayPartSearchNoResult::::  ' + displayPartSearchNoResult);
        system.debug('int_searchNoResultCounter::::  ' + int_searchNoResultCounter);
        displayPopUp = true;
        this.str_partListJson = Json.serialize(list_parts);
    }
    
    
    
    
    /*------------------------------------------------------------
    Author:        Bin Yuan <bin.yuan@capgemini.com>
    Description:   Method to search part__c data
    Inputs:        
    Returns:       
    History
    2017-07-10     Bin Yuan <bin.yuan@capgemini.com> created
    ------------------------------------------------------------*/
    public void getPartsUsingLike() {
    	set<String> set_matchString = new set<String>();
    	list<Part__c> list_partsExactMatch = new list<Part__c>();
    	list<Part__c> list_partsNoExactMatch = new list<Part__c>();
        this.str_partListJson = '';
        this.displayPartSearchError = false;
        this.displayPartSearchNoResult = false;
        this.int_searchNoResultCounter = 0;
        
        list_parts = new list<Part__c>();
        this.set_partNotINSearchResult = new set<String>();
        PartSeracgSettings__c CSSearch = PartSeracgSettings__c.getInstance() ;// Check User If eligable for RPN Serach Code Added by TEIS CoE team
          
        system.debug('getParts:::str_partNumb::'+str_partNumb);
        system.debug('getParts:::str_partDescription::'+str_partDescription);
        
        Set<String> set_dummyPartNames = new Set<String>{'Transportation Costs', 'Installation Costs', 'Training Costs','Freight Costs','Commission Costs','Distribution Costs','Other Costs'};
        Boolean bool_isSearchSetByComma = false;
        
        String str_query = 'Select Id, Name, RPN_Part__c,RPN_Description__c,Description__c, GPL__r.Name, GPL_Description__c,  Product_Hierarchy__r.Name,UNIT_PACKAGING_QTY__c, '
                     + 'Product_Hierarchy__c, Product_Hierarchy__r.Hierarchy_Level_Type__c, Product_Hierarchy__r.Description__c,BASE_UM_CDE__c '
                     //+ 'From Part__c Where IsActive__c = true and Product_Hierarchy__r.CBC1__c = \'13005\' '
                     + 'From Part__c Where Product_Hierarchy__r.CBC1__c = \'13005\' and DISCONTINUANCE_STATUS_CDE__c != \'1\' ';
                     //+ ' and ( Id NOT IN: set_partId2 OR Name = null OR Name like \'%proposal%\' OR Name IN:set_dummyPartNames ) ';    modified by yuan yao  2017-10-05,delete by buwen guo 2018-04-19
        if(str_partNumb != null && str_partNumb != '') {
            str_partNumb = str_partNumb.trim();
            str_partNumb = str_partNumb.replaceAll('\n',',');
            if(str_partNumb.contains(',')){
                set<String> set_tempPartNumbers = new set<String>();
                for(String str_temp : str_partNumb.split(',')){
                	set_matchString.add(str_temp.trim());
                    set_tempPartNumbers.add(str_temp.trim());
                }
                //str_query += ' AND Name IN:set_tempPartNumbers ';
                 str_query += (CSSearch.Enable_Rpn_Search__c) ? ' AND ((Name IN:set_tempPartNumbers) OR (RPN_Part__c IN:set_tempPartNumbers))' : ' AND ( Name IN:set_tempPartNumbers )';  // Code Modified by TEIS CoE (04-19-2018) to add RPN Condition 
                bool_isSearchSetByComma = true;
            }else{
                //str_query += ' AND Name like \'%' + str_partNumb + '%\' ';
                set_matchString.add(str_partNumb);
				str_query += (CSSearch.Enable_Rpn_Search__c) ? ' AND (Name like \'%' + str_partNumb + '%\'  OR RPN_Part__c  like \'%' + str_partNumb + '%\')' : ' AND ( Name like \'%' + str_partNumb + '%\' )'; // Code Modified by TEIS CoE (04-19-2018) to add RPN Condition 
            }
        }
        if(str_partDescription != null && str_partDescription != '') {
            str_partDescription = str_partDescription.trim();
            str_partDescription = str_partDescription.replaceAll('\n',',');
            if(str_partDescription.contains(',')){
                set<String> set_tempPartDescriptions = new set<String>();
                for(String str_temp : str_partDescription.split(',')){
                	set_matchString.add(str_temp.trim());
                    set_tempPartDescriptions.add(str_temp.trim());
                }
               // str_query += ' AND (Description__c IN:set_tempPartDescriptions OR GPL_Description__c IN:set_tempPartDescriptions OR Product_Hierarchy__r.Name IN:set_tempPartDescriptions  ';
                  str_query += (CSSearch.Enable_Rpn_Search__c) ? ' AND (Description__c IN:set_tempPartDescriptions OR GPL_Description__c IN:set_tempPartDescriptions OR Product_Hierarchy__r.Name IN:set_tempPartDescriptions OR RPN_Description__c IN:set_tempPartDescriptions ' : ' AND (Description__c IN:set_tempPartDescriptions OR GPL_Description__c IN:set_tempPartDescriptions OR Product_Hierarchy__r.Name IN:set_tempPartDescriptions  ';
                for(String str_each : set_tempPartDescriptions){
                  //  str_query += ' OR  Description__c like \'%' + str_each + '%\' ';
                      str_query += (CSSearch.Enable_Rpn_Search__c) ? ' OR  Description__c like \'%' + str_each + '%\' OR  RPN_Description__c  like \'%' + str_each + '%\' ' : ' OR  Description__c like \'%' + str_each + '%\' ';
                }
                bool_isSearchSetByComma = true;
                str_query += ' ) ';
            }else{
            	set_matchString.add(str_partDescription.trim());
				// str_query += ' AND (Description__c like \'%' + str_partDescription + '%\' OR GPL_Description__c like \'%' + str_partDescription + '%\' OR Product_Hierarchy__r.Name like \'%' + str_partDescription + '%\') ';
				if(CSSearch.Enable_Rpn_Search__c){
                    str_query += ' AND (Description__c like \'%' + str_partDescription + '%\' OR GPL_Description__c like \'%' + str_partDescription + '%\' OR Product_Hierarchy__r.Name like \'%' + str_partDescription + '%\' OR  RPN_Description__c like \'%' + str_partDescription + '%\') ';    
                }else{
                     str_query += ' AND (Description__c like \'%' + str_partDescription + '%\' OR GPL_Description__c like \'%' + str_partDescription + '%\' OR Product_Hierarchy__r.Name like \'%' + str_partDescription + '%\') '; 
                }
            }
            //str_query += ' AND (Description__c like \'%' + str_partDescription + '%\' OR GPL_Description__c like \'%' + str_partDescription + '%\' OR Product_Hierarchy__r.Name like \'%' + str_partDescription + '%\') ';
        }
        str_query += ' order by Name NULLS FIRST limit 100';
        system.debug('str_query::'+str_query);
        set<String> set_actualGotParts = new set<String>();
        set<String> set_actualGotPartRPNs = new set<String>();
        for(Part__c part : DataBase.query(str_query)) {
            part.UNIT_PACKAGING_QTY__c = '';
            if(set_dummyPartNames.contains(part.Name)){
                //Added by requirement from mail:Last Full Day before the Power Users are in the system! point 2
                //Please have the GPL (and GPL Descrption) be blank for all the costs.
                //If the part is a Cost part,the page will hide the value by checking name is 'Costs'.
                part.Product_Hierarchy__r.Name = 'Costs';
                part.UNIT_PACKAGING_QTY__c = '1';
            }
            set_actualGotParts.add(part.Name);
            set_actualGotPartRPNs.add(part.RPN_Part__c);
            //list_parts.add(part);
            
            
            if(set_matchString.contains(part.Name) 
            	|| set_matchString.contains(part.RPN_Part__c)
            	|| set_matchString.contains(part.Description__c)
            	|| set_matchString.contains(part.RPN_Description__c)
            	|| set_matchString.contains(part.GPL_Description__c)
            	|| set_matchString.contains(part.Product_Hierarchy__r.Name) ) {
            
            	list_partsExactMatch.add(part);		
            } else {
            	list_partsNoExactMatch.add(part);		
            }
        }
        
        list_parts.addAll(list_partsExactMatch);
        list_parts.addAll(list_partsNoExactMatch);
        
        system.debug('set_matchString::'+set_matchString);
        
        system.debug('list_partsExactMatch::'+list_partsExactMatch);
        system.debug('list_partsNoExactMatch::'+list_partsNoExactMatch);
        
        if(str_partNumb != null && str_partNumb != '') {
            str_partNumb = str_partNumb.trim();
            str_partNumb = str_partNumb.replaceAll('\n',',');
            if(str_partNumb.contains(',')){
                set<String> set_tempPartNumbers = new set<String>();
                for(String str_temp : str_partNumb.split(',')){
                    str_temp = str_temp.trim();
                    if(!set_actualGotParts.contains(str_temp) && !set_actualGotPartRPNs.contains(str_temp)){
                        set_partNotINSearchResult.add(str_temp);
                    }
                }
                system.debug('set_partNotINSearchResult::'+set_partNotINSearchResult);
            }else{
                if(!set_actualGotParts.contains(str_partNumb) && !set_actualGotPartRPNs.contains(str_partNumb)){
                    set_partNotINSearchResult.add(str_partNumb);
                }
            }
        }
        this.int_searchNoResultCounter = set_partNotINSearchResult.size();
        this.isSearchSetByComma = bool_isSearchSetByComma;
        if(bool_isSearchSetByComma && list_parts.size() < 1){
            //this.displayPartSearchError = true;
            this.displayPartSearchError = false;
            if(list_parts.size() < 1){
                this.displayPartSearchNoResult = true;
            }else{
                this.displayPartSearchNoResult = false;
            }
        }else{
            this.displayPartSearchError = false;
            if(list_parts.size() < 1){
                this.displayPartSearchNoResult = true;
            }else{
                this.displayPartSearchNoResult = false;
            }
        }
        /*
        for(Part__c part : [Select Id, Name, Description__c, GPL__r.Name, GPL_Description__c,  Product_Hierarchy__r.Name, 
                                   Product_Hierarchy__c, Product_Hierarchy__r.Hierarchy_Level_Type__c, Product_Hierarchy__r.Description__c
                            From Part__c
                            Where Id NOT IN: set_partId AND Name like: '%' + str_partNumb + '%' AND Description__c like: '%' + str_partDescription + '%' 
                            order by Name 
                            limit 1000]) {
            list_parts.add(part);                           
        }*/
        system.debug('list_parts::::  ' + list_parts);
        system.debug('displayPopUp::::  ' + displayPopUp);
        system.debug('displayPartSearchError::::  ' + displayPartSearchError);
        system.debug('displayPartSearchNoResult::::  ' + displayPartSearchNoResult);
        system.debug('int_searchNoResultCounter::::  ' + int_searchNoResultCounter);
        displayPopUp = true;
        this.str_partListJson = Json.serialize(list_parts);
    }



     
    /*------------------------------------------------------------
    Author:        Bin Yuan <bin.yuan@capgemini.com>
    Description:   method to delete opportunity parts
    Inputs:        
    Returns:       
    History
    2017-07-10     Bin Yuan <bin.yuan@capgemini.com> created
    ------------------------------------------------------------*/
    public void deleteOppyParts() {
        isSaveHasError = false;
        list<Opportunity_Part__c> list_oppyParts = new list<Opportunity_Part__c>();
        list<Opportunity_Part__c> list_delOppyParts = new list<Opportunity_Part__c>();
        set<String> set_delOppyPartIds = new set<String>();
        try {
            set_delOppyPartIds.addAll((list<String>)JSON.deserialize(str_deleteOppyPartIds, list<String>.class));
            for(OppyPartDiscountItem partItem : list_oppyPartItems) {
                if(set_delOppyPartIds.contains(partItem.str_oppyPartId)) {
                    list_delOppyParts.add(partItem.oppyPart);
                } else {
                    list_oppyParts.add(partItem.oppyPart);
                }
            }

            //calcOppyPartItemFraction(list_oppyParts);
            OpportunityTrgHandler.isEditingOpportunityPartState = true;
            isEnergyPartManagementSave = true;
            if(list_delOppyParts.size() > 0) {
                delete list_delOppyParts;
            }
            if(!list_oppyParts.isEmpty()) {
                upsert list_oppyParts;
            }
        } catch(Exception ex) {
            isSaveHasError = true;
            ErrorLogging.Log(ex);
            String vStrError = '';
            vStrError += 'Error Type = ' + ex.getTypeName() + 
                ' Error Line = ' + ex.getLineNumber() + '' + 
                ' Error Stack = ' + ex.getStackTraceString() + 
                ' Error Message = ' + ex.getMessage();
            
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,                   
                                         SalesforceConstant.strError, '', '', '', '5','','','Exception', ex.getLineNumber() + '',ex.getStackTraceString());
                                         
            boolean isPassContactRoleCheck = checkContactRole(this.oppy.Id);
            if(isPassContactRoleCheck){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getMessage()));
            }else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'You must create a contact role on this opportunity before you can perform this operation.'));
            }
        }
    }
    
    
    
    
    /*------------------------------------------------------------
    Author:        Bin Yuan <bin.yuan@capgemini.com>
    Description:   method to save opportunity parts
    Inputs:        
    Returns:       
    History
    2017-07-10     Bin Yuan <bin.yuan@capgemini.com> created
    ------------------------------------------------------------*/
    public void saveOppyParts() {
        isSaveHasError = false;
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'str_oppyPartJson2Save :: ' + str_oppyPartJson2Save));
        list<OppyPartDiscountItem> list_oppyPartItem = new list<OppyPartDiscountItem>();
        list<Opportunity_Part__c> list_oppyParts = new list<Opportunity_Part__c>();
        list<Opportunity_Part__c> list_delOppyParts = new list<Opportunity_Part__c>();
        try {
            list_oppyPartItem = (list<OppyPartDiscountItem>) JSON.deserialize(str_oppyPartJson2Save, list<OppyPartDiscountItem>.class);
            Integer counter_targetLowerThanSales = 0;
            String str_cbc4product = '';
            system.debug('savinglist_oppyPartItems::'+list_oppyPartItems);
            list<Integer> list_deleteIndex = new list<Integer>();
            Decimal oppyAmount = 0;
            
            for(OppyPartDiscountItem partItem : list_oppyPartItem) {
                //if(!partItem.isDelete){
                    //if(partItem.oppyPart.Id == null) {partItem.oppyPart.Opportunity__c = this.oppy.Id;}
                    partItem.oppyPart.CurrencyIsoCode = this.oppy.CurrencyIsoCode;
                    if(partItem.oppyPart.Status__c == null ||partItem.oppyPart.Status__c == '' ){partItem.oppyPart.Status__c = 'Pending';}
                    partItem.oppyPart.Lost_Reason__c = 'Other';
                    partItem.oppyPart.TotalPrice__c = partItem.oppyPart.Quantity__c * partItem.oppyPart.Offered_Price__c;
                    oppyAmount = oppyAmount + partItem.oppyPart.TotalPrice__c;
                    
                    if(partItem.oppyPart.Offered_Price__c < partItem.oppyPart.Sales_price__c){
                        counter_targetLowerThanSales = counter_targetLowerThanSales + 1;
                    }
                    
                    list_oppyParts.add(partItem.oppyPart);
                    if(partItem.isThisCBC4){
                        str_cbc4product = partItem.str_CBC4Product;
                    }
                    system.debug('oppyPartToSave:::'+partItem.oppyPart);
                //}else{
                    /*
                    Integer index = Integer.valueof(partItem.oppyPart.NDR_Item_Number__c) - 1;
                    system.debug('index::'+index);
                    list_deleteIndex.add(index);

                    set_partId.remove(partItem.oppyPart.Part__c);
                    if(partItem.oppyPart.Id != null) {
                        list_delOppyParts.add(partItem.oppyPart);
                    }
                    */
                //}
            }
            
            /*
            if(list_deleteIndex.size() > 0){
                list_deleteIndex = reverseIndex(list_deleteIndex);
                for(Integer int_index : list_deleteIndex){
                    OppyPartDiscountItem delItem = list_oppyPartItems.remove(int_index);
                }
            }*/
            
            //calcOppyPartItemFraction(list_oppyParts);
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'list_oppyParts :: ' + list_oppyParts));
            OpportunityTrgHandler.isEditingOpportunityPartState = true;
            isEnergyPartManagementSave = true;
            
            //if(list_delOppyParts.size() > 0) {
            //  delete list_delOppyParts;
            //}
            if(!list_oppyParts.isEmpty()) {
                upsert list_oppyParts;
            }
            
            system.debug('list_oppyParts::upsert::done');
            
            Opportunity op;
            for(Opportunity opp :[select id,Approval_Status__c,Primary_Product_Hierarchy__c,Account.Sales_Hierarchy__r.Level_2_Territory_Name__c from Opportunity where id=:oppy.Id]){
                op = opp;
            }
            if(op != null){
                if(counter_targetLowerThanSales > 0) {
                    //op.DOA_Required__c = true;
                    //op.Approval_Status__c = 'Approval Required';
                    system.debug('op.Approval_Status__c::::'+op.Approval_Status__c);
                }
                if(oppyAmount != null){
                    //op.Amount = oppyAmount;
                }
                if(str_cbc4product != null && str_cbc4product != ''){
                    op.Primary_Product_Hierarchy__c = str_cbc4product;
                    
                    String str_CBC4ToPmName = '';
                    for(Product_Hierarchy__c p : [select id,CBC2_Description__c,CBC4_Description__c from Product_Hierarchy__c where id =: str_cbc4product]){
                        op.Product_Line_Group__c = p.CBC2_Description__c;
                        system.debug('op.Product_Line_Group__c:'+op.Product_Line_Group__c);
                        str_CBC4ToPmName = p.CBC4_Description__c;
                    }
                    
                    if(str_CBC4ToPmName != null && str_CBC4ToPmName != ''){
                        String str_level2TerrName = op.Account.Sales_Hierarchy__r.Level_2_Territory_Name__c;
                        String str_ProdManagerId = '';
                        for(CBC4_to_PM__c pm: [select id,name,Level_2_Territory_Name__c,Product_Manager__c 
                                                from CBC4_to_PM__c 
                                                where name =: str_CBC4ToPmName 
                                                and (Level_2_Territory_Name__c =:str_level2TerrName or Level_2_Territory_Name__c = null)
                                                order by Level_2_Territory_Name__c asc NULLS LAST limit 1]){
                            str_ProdManagerId = pm.Product_Manager__c;
                            break;
                        }
                        if(str_ProdManagerId != null && str_ProdManagerId != ''){
                            op.Product_Manager__c = str_ProdManagerId;
                            system.debug('op.Product_Manager__c:'+op.Product_Manager__c);
                        }
                    }
                }
                update op;
            }
            //reload oppy field.
            for(Opportunity opp :[select Id,Account.Source_System__c,Account_Number__c,currencyIsoCode,AccountId,ERP_For_Pricing__c,Territory__c,
                                Account.Sales_Hierarchy__c,
                                Primary_Product_Hierarchy__c,Approval_Status__c,Account.recordtype.name,recordtype.developername,stagename  from Opportunity where id=:oppy.Id]){
                oppy = opp;
            }
            
            if(oppy.Territory__c == null || oppy.ERP_for_Pricing__c == null ){
                boolean bool_isNeedUpdateOppy = false;
                
                if(oppy.Territory__c == null && oppy.Account != null && oppy.Account.Sales_Hierarchy__c != null){
                    oppy.Territory__c = oppy.Account.Sales_Hierarchy__c;
                    bool_isNeedUpdateOppy = true;
                }
                //Modified By Buwen Guo 2017-12-11
                //This logic has been moved into opportunity trigger so remove it.
                /*
                if((oppy.ERP_for_Pricing__c == null || oppy.ERP_for_Pricing__c == '') && oppy.Account != null && oppy.Account.Source_System__c != null){
                    if(oppy.Account.Source_System__c == 1) {
                        oppy.ERP_for_Pricing__c = 'SAP';
                    } else if(oppy.Account.Source_System__c == 42) {
                        oppy.ERP_for_Pricing__c = 'Ampics';
                    } else if(oppy.Account.Source_System__c == 51) {
                        oppy.ERP_for_Pricing__c = 'MFGPRO';
                    } else {
                        oppy.ERP_for_Pricing__c = 'No ERP';
                    }
                    bool_isNeedUpdateOppy = true;
                }
                */
                
                if(bool_isNeedUpdateOppy){
                    update oppy;
                }
            }
            
            displayUploadPopup = false;
            displayPopup = false;
            setAmpicsButtonState();
            //isEnergyPartManagementSave = false;
        }
        catch(Exception ex) {
            system.debug('Exception::'+ex.getMessage()+','+ex.getStackTraceString());
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getStackTraceString()));
            isSaveHasError = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getMessage()));
            ErrorLogging.Log(ex);
            String vStrError = '';
            vStrError += 'Error Type = ' + ex.getTypeName() + 
                ' Error Line = ' + ex.getLineNumber() + '' + 
                ' Error Stack = ' + ex.getStackTraceString() + 
                ' Error Message = ' + ex.getMessage();
            
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,                   
                                         SalesforceConstant.strError, '', '', '', '5','','','Exception', ex.getLineNumber() + '',ex.getStackTraceString());
        }
    } 
    
    


    /*------------------------------------------------------------
    Author:        Bin Yuan <bin.yuan@capgemini.com>
    Description:   Method to reverse index into desc order.
    Inputs:        
    Returns:       
    History
    2017-07-10     Bin Yuan <bin.yuan@capgemini.com> created
    ------------------------------------------------------------*/
    public static List<Integer> reverseIndex(List<Integer> list_index){
        if(list_index == null){
            return new List<Integer>();
        }else{
            list_index.sort();
        }
        List<Integer> finalList = new List<Integer>();
        for(Integer i = list_index.size()-1; i>=0;i--){
            finalList.add(list_index.get(i));
        }
        system.debug('reverseIndex:'+finalList);
        return finalList;
    }
    
    

    /*------------------------------------------------------------
    Author:        Bin Yuan <bin.yuan@capgemini.com>
    Description:   Method to generate oppy part items
    Inputs:        
    Returns:       
    History
    2017-07-10     Bin Yuan <bin.yuan@capgemini.com> created
    ------------------------------------------------------------*/
    public OppyPartDiscountItem generateOppyPartItem(Opportunity_Part__c part,map<String,list<Energy_Quote_Line_Item__c>> map_partId_quoteLineItems,map<String,list<Inventory__c>> map_partId_Inventories,map<String,decimal> map_partId_pricebookCosts) {
        Set<String> set_dummyPartNames = new Set<String>{'Transportation Costs', 'Installation Costs', 'Training Costs','Freight Costs','Commission Costs','Distribution Costs','Other Costs'};
        
        OppyPartDiscountItem item = new OppyPartDiscountItem();
        item.str_oppyPartId = part.Id;
        item.oppyPart = part;
        item.str_partNumber = part.Name;
        item.str_partDescription = part.Part__r.Description__c;
        item.int_quality = Integer.ValueOf(part.Quantity__c);
        //item.partListPrice = part.List_Price__c;
        item.partSalesPrice = part.Sales_price__c;
        
        //modified by Tangyong Li 2017-12-17
        //item.partOfferedPrice = part.Offered_Price__c;
        item.partOfferedPrice = (part.Offered_Price__c != null?part.Offered_Price__c.setScale(2):part.Offered_Price__c);
        
        item.str_partName = part.Part__r.Name;
        item.isRequestedPriceLower = (part.Offered_Price__c <part.Sales_price__c);
        item.list_QuoteLineItems = (map_partId_quoteLineItems.containsKey(part.Part__c)?map_partId_quoteLineItems.get(part.Part__c):null);
        item.hasQuoteLineItems = map_partId_quoteLineItems.containsKey(part.Part__c)?(map_partId_quoteLineItems.get(part.Part__c).size()>0?true:false):false;
        item.str_RFQuoteNumber = part.Energy_Quote_Line_Item__r.Energy_Quote_Name__r.Quote_Number__c;
        item.str_RFQuoteId = part.Energy_Quote_Line_Item__r.Energy_Quote_Name__c;
        item.str_RFQuoteLineItemId = part.Energy_Quote_Line_Item__c;
        item.str_CBC4Description = ( set_dummyPartNames.contains(item.str_partName) ? '' : ( item.str_partName != null && item.str_partName.toLowerCase().contains('proposal') ?(part.Part__r.Product_hierarchy__c != null ? part.Part__r.Product_hierarchy__r.CBC4_Description__c:''):part.Part__r.Product_hierarchy__r.CBC4_Description__c ));
        item.str_CBC4Product = part.Part__r.Product_hierarchy__c;
        item.str_OpportunityCBC4 = this.oppy.Primary_Product_Hierarchy__c;
        item.isDOAAproved = (this.oppy.Approval_Status__c == 'Approved' )?true:false;
        item.list_inventories = (map_partId_Inventories.containsKey(part.Part__c)?map_partId_Inventories.get(part.Part__c):null);
        item.isDummyPart = set_dummyPartNames.contains(item.str_partName) ? true : (item.str_partName != null && item.str_partName.toLowerCase().contains('proposal') ? true : false );
        item.isCostPart = set_dummyPartNames.contains(item.str_partName) ? true : false;
        item.isProposalPart = item.str_partName != null && item.str_partName.toLowerCase().contains('proposal') ? true : false ;
        item.isDisplayComment = part.Part__r.Proposal_Part__c;
        
        if(displayAmpicsButton){
            item.dec_priceBookCost = (map_partId_pricebookCosts.containsKey(part.Part__c)?map_partId_pricebookCosts.get(part.Part__c):0);
            //Modified by Buwen Guo 2017-12-01 from email:Issues 11/30 point 4
            //item.oppyPart.Standard_Cost__c = (map_partId_pricebookCosts.containsKey(part.Part__c)?map_partId_pricebookCosts.get(part.Part__c):0);
            Decimal dec_custStdPrice = (map_partId_pricebookCosts.containsKey(part.Part__c)?map_partId_pricebookCosts.get(part.Part__c):0);
            //item.oppyPart.Sales_Price__c = dec_custStdPrice != 0 ? ClsAPLForecastUtil.transformIsoCode(dec_custStdPrice,'AUD',oppy.currencyIsoCode) :0;
        }else{
            item.dec_priceBookCost = part.Standard_Cost__c;
        }
        return item;
    }



    
    /*------------------------------------------------------------
    Author:        Bin Yuan <bin.yuan@capgemini.com>
    Description:   Method to caculate Fraction_of_sale__c on the oppy part items
    Inputs:        
    Returns:       
    History
    2017-07-10     Bin Yuan <bin.yuan@capgemini.com> created
    ------------------------------------------------------------*/
    public static void calcOppyPartItemFraction(list<Opportunity_Part__c> list_oppyParts) {
        decimal totalAmount = 0.0;
        decimal percentCounter = 0;
        list<Opportunity_Part__c> list_partWithAmount = new list<Opportunity_Part__c>();
        for(Opportunity_Part__c part : list_oppyParts) {
            //part.CurrencyIsoCode = this.oppy.CurrencyIsoCode;
            if(part.Quantity__c != null && part.Quantity__c != 0 && part.Offered_Price__c != null && part.Offered_Price__c != 0 && part.Status__c != 'Lost' && part.Status__c != 'No Bid') {
                decimal partAmount = part.Quantity__c * part.Offered_Price__c;
                totalAmount += partAmount;
                list_partWithAmount.add(part);
            }
        }
        if(totalAmount == 0) {
            return;
        }
        for(Integer i = 0; i < list_partWithAmount.size(); i ++ ) {
            Opportunity_Part__c part = list_partWithAmount[i];
            decimal percentage = 0;
            if(part.Quantity__c != null && part.Quantity__c != 0 && part.Offered_Price__c != null && part.Offered_Price__c != 0) {
                decimal partAmount = part.Quantity__c * part.Offered_Price__c;
                //Fraction_of_sale__c
                if(list_partWithAmount.size() == 1) {
                    part.Fraction_of_sale__c = 1;
                }
                else if(i == list_partWithAmount.size() - 1) {
                    part.Fraction_of_sale__c = 1 - percentCounter;
                }
                else {
                    percentage = partAmount.divide(totalAmount, 4) ;
                    percentCounter += percentage;
                    part.Fraction_of_sale__c = percentage;
                }
            }
        }
    }
    




    /*------------------------------------------------------------
    Author:        Bin Yuan <bin.yuan@capgemini.com>
    Description:   method to add opportunity part
    Inputs:        
    Returns:       
    History
    2017-07-10     Bin Yuan <bin.yuan@capgemini.com> created
    ------------------------------------------------------------*/
    public void addParts() {
        
        /*
        list<String> list_partId2Add = new list<String>();
        System.debug('*** 1');
        list_partId2Add = (list<String>) Json.deserialize(str_partIds2AddJson, list<String>.class);
        */
        Set<String> set_dummyPartNames = new Set<String>{'Transportation Costs', 'Installation Costs', 'Training Costs','Freight Costs','Commission Costs','Distribution Costs','Other Costs'};
        
        list<innerClassForAdd> list_partId2AddWithQuantity = new list<innerClassForAdd>();
        System.debug('*** 1'+str_partIds2AddJsonWithNum);
        list_partId2AddWithQuantity = (list<innerClassForAdd>) Json.deserialize(str_partIds2AddJsonWithNum, list<innerClassForAdd>.class);
        map<String,Integer> map_partId_quantity = new map<String,Integer>();
        list<String> list_partId2Add = new list<String>();
        
        for(innerClassForAdd innerObj : list_partId2AddWithQuantity){
            Integer int_quantity = 0;
            if(innerObj.quantity != null && innerObj.quantity.trim() != ''){
                int_quantity = Integer.valueOf(Decimal.valueOf(innerObj.quantity).round());
            }
            list_partId2Add.add(innerObj.partId);
            map_partId_quantity.put(innerObj.partId,int_quantity);
        }
        
        if(!list_partId2Add.isEmpty()) {
            System.debug('*** 2');
            map<String, String> map_partId_partName = new map<String, String>();
            map<String, String> map_partId_description = new map<String, String>();
            map<String, String> map_partId_cbc4description = new map<String, String>();
            map<String, String> map_partId_cbc4product = new map<String, String>();
            map<String, boolean> map_partId_isProposalPart = new map<String, boolean>();
            map<String, String> map_partId_baseUMcode = new map<String, String>();
            map<String,decimal> map_partId_standardCosts = new map<String,decimal>();
            map<String, String> map_partId_currencyIsoCode = new map<String, String>();
            
            //Added by Buwen Guo 2017-12-14 from email:12/13 Issues point 2,9
            map<String,decimal> map_partId_MOQ = new map<String,decimal>();
            map<String,decimal> map_partId_LTDays = new map<String,decimal>();
            map<String,decimal> map_partId_Availability = new map<String,decimal>();
            map<String,decimal> map_partId_PPQ = new map<String,decimal>();
            
            for(Part__c part : [Select Id, Name,Description__c,Product_hierarchy__r.CBC4_Description__c,
                                    Product_hierarchy__c,Proposal_Part__c,BASE_UM_CDE__c, UNIT_PACKAGING_TYPE_CDE__c,Curr_CS_75__c,CurrencyIsoCode,
                                    Min_Order_Qty__c,Primary_Pack_Qty__c,Lead_Time_Days__c 
                                From Part__c
                                Where id in : list_partId2Add]) {

                map_partId_partName.put(part.Id, part.Name);    
                map_partId_description.put(part.Id, part.Description__c);
                map_partId_cbc4description.put(part.Id, part.Product_hierarchy__r.CBC4_Description__c);
                map_partId_cbc4product.put(part.Id, part.Product_hierarchy__c);     
                map_partId_isProposalPart.put(part.Id, part.Proposal_Part__c);  
                //map_partId_baseUMcode.put(part.Id, part.BASE_UM_CDE__c);  
                map_partId_baseUMcode.put(part.Id, part.UNIT_PACKAGING_TYPE_CDE__c);    //modified by Tangyong Li 2017-11-08
                map_partId_standardCosts.put(part.Id, part.Curr_CS_75__c); //Added by Buwen Guo 2017-12-04 from email: Issues 12/1 point 10
                map_partId_currencyIsoCode.put(part.Id, part.CurrencyIsoCode); //Added by Buwen Guo 2017-12-04 from email: Issues 12/1 point 10
                
                //Added by Buwen Guo 2017-12-14 from email:12/13 Issues point 2
                map_partId_MOQ.put(part.Id, part.Min_Order_Qty__c);
                map_partId_LTDays.put(part.Id, part.Lead_Time_Days__c);
                //map_partId_Availability.put(part.Id, part.Primary_Pack_Qty__c);
                map_partId_PPQ.put(part.Id, part.Primary_Pack_Qty__c);
            }
            
            //get related Energy_Price_Book_Entry__c cost
            map<String,decimal> map_partId_pricebookCosts = new map<String,decimal>();
            
            for(Energy_Price_Book_Entry__c qli : [select id,UnitPrice__c,Part__c,StandardPrice__c 
                                            from Energy_Price_Book_Entry__c 
                                            where Part__c IN :list_partId2Add ]){
                                                
                if(!map_partId_pricebookCosts.containsKey(qli.Part__c)){
                    //Edit by Buwen Guo 2017-10-30 from email:Things to fix 
                    //Change UnitPrice__c to StandardPrice__c.
                    //Modified by Buwen Guo 2017-12-01 from email:Issues 11/30 point 4
                    map_partId_pricebookCosts.put(qli.Part__c,qli.UnitPrice__c);
                    //map_partId_pricebookCosts.put(qli.Part__c,qli.StandardPrice__c);
                }
            }
            
            
            if(!map_partId_partName.isEmpty()) {
                System.debug('*** 3');
                for(innerClassForAdd innerObj : list_partId2AddWithQuantity) {
                    String str_partId = innerObj.partId;
                    System.debug('*** 4');
                    OppyPartDiscountItem newItem = new OppyPartDiscountItem();
                    newItem.oppyPart =  new Opportunity_Part__c();
                    newItem.oppyPart.Part__c = str_partId;
                    newItem.oppyPart.Opportunity__c = this.oppy.Id;
                    newItem.oppyPart.Status__c = 'Pending';
                    newItem.oppyPart.Quantity__c = innerObj.quantity != null && innerObj.quantity.trim() != '' ? Integer.valueOf(Decimal.valueOf(innerObj.quantity).round()) : 0;
                    
                    newItem.oppyPart.CurrencyIsoCode = this.oppy.CurrencyIsoCode;
                    newItem.str_partName = map_partId_partName.get(str_partId);
                    newItem.str_partDescription = map_partId_description.get(str_partId);
                                        
                    if(set_dummyPartNames.contains(newItem.str_partName)){
                        newItem.oppyPart.Sales_price__c = 0;
                        newItem.oppyPart.Offered_Price__c = 0;
                    } else {
                        //Opportunity_Part__c tempPart = new Opportunity_Part__c();
                        //tempPart.Quantity__c = (map_partId_quantity.containsKey(str_partId))?map_partId_quantity.get(str_partId):0;
                        //tempPart.Part_Number__c = map_partId_partName.get(str_partId);
                        //system.debug('addParts:oppy::'+oppy);
                        //system.debug('addParts:tempPart::'+tempPart);
                        //newItem.oppyPart.Sales_price__c = InventoryAndPricing.getInventoryAndPrice(oppy,tempPart);
                        //newItem.oppyPart.Offered_Price__c = newItem.oppyPart.Sales_price__c;
                    }
                    
                    newItem.str_CBC4Product = (map_partId_cbc4product.containsKey(str_partId))?map_partId_cbc4product.get(str_partId):null;
                    newItem.str_CBC4Description = (map_partId_cbc4description.containsKey(str_partId))?map_partId_cbc4description.get(str_partId):null;
                    //if this part is dummy part,clear the CBC4Description field value.
                    newItem.str_CBC4Description = (set_dummyPartNames.contains(newItem.str_partName) ? '' : ( newItem.str_partName.toLowerCase().contains('proposal') ? (map_partId_cbc4product.containsKey(str_partId) && map_partId_cbc4product.get(str_partId) != null ? newItem.str_CBC4Description:''):newItem.str_CBC4Description ));
                    newItem.isDOAAproved = (this.oppy.Approval_Status__c == 'Approved')?true:false;
                    newItem.isDummyPart = set_dummyPartNames.contains(newItem.str_partName) ? true : newItem.str_partName.toLowerCase().contains('proposal') ? true : false;
                    newItem.isDisplayComment = map_partId_isProposalPart.containsKey(str_partId) ? map_partId_isProposalPart.get(str_partId) :false;
                    
                    if(!newItem.isDummyPart){
                        String str_umCode = map_partId_baseUMcode.get(str_partId);
                        if(str_umCode != null && str_umCode.length() >= 5){str_umCode = str_umCode.substring(0,4);}
                        //newItem.oppyPart.NDR_Item_Price_UOM__c = str_umCode;
                        newItem.oppyPart.Code_for_unit_of_measurement__c = str_umCode;
                    } else {
                        String str_umCode = map_partId_baseUMcode.get(str_partId);
                        if(str_umCode != null){
                            if(str_umCode.length() >= 5) {
                                str_umCode = str_umCode.substring(0,4);
                            }
                            newItem.oppyPart.Code_for_unit_of_measurement__c = str_umCode;
                        } else {
                            newItem.oppyPart.Code_for_unit_of_measurement__c = 'PC';
                        }
                    }
                    
                    if(displayAmpicsButton){
                        newItem.dec_priceBookCost =  map_partId_pricebookCosts.containsKey(str_partId) ? map_partId_pricebookCosts.get(str_partId) :0;
                        //Modified by Buwen Guo 2017-12-01 from email:Issues 11/30 point 4
                        //newItem.oppyPart.Standard_Cost__c =  map_partId_pricebookCosts.containsKey(str_partId) ? map_partId_pricebookCosts.get(str_partId) :0;
                        //Added by Buwen Guo 2017-12-04 from email: Issues 12/1 point 10
                        Decimal dec_standardCost = map_partId_standardCosts.containsKey(str_partId) ? map_partId_standardCosts.get(str_partId) :0;
                        String str_currency = map_partId_currencyIsoCode.containsKey(str_partId) ? map_partId_currencyIsoCode.get(str_partId) : 'USD';
                        newItem.oppyPart.Standard_Cost__c =  ClsAPLForecastUtil.transformIsoCode(dec_standardCost,str_currency,newItem.oppyPart.CurrencyIsoCode);
                        Decimal dec_custStdPrice = map_partId_pricebookCosts.containsKey(str_partId) ? map_partId_pricebookCosts.get(str_partId) :0;
                        newItem.oppyPart.Sales_Price__c =  dec_custStdPrice != 0 ? ClsAPLForecastUtil.transformIsoCode(dec_custStdPrice,'AUD',newItem.oppyPart.CurrencyIsoCode):0;
                        
                        //Added by Buwen Guo 2017-12-14 from email:12/13 Issues point 2
                        newItem.oppyPart.Min_Order_Qty__c =  map_partId_MOQ.containsKey(str_partId) ? map_partId_MOQ.get(str_partId) :0;
                        newItem.oppyPart.Lead_Time__c =  map_partId_LTDays.containsKey(str_partId) ? map_partId_LTDays.get(str_partId) :0;
                        //newItem.oppyPart.Availability__c =  map_partId_Availability.containsKey(str_partId) ? map_partId_Availability.get(str_partId) :0;
                        newItem.oppyPart.Primary_Pack_Quantity__c =  map_partId_PPQ.containsKey(str_partId) ? map_partId_PPQ.get(str_partId) :0;
                    }else{
                        //newItem.oppyPart.Standard_Cost__c = 0;
                        newItem.oppyPart.Sales_Price__c = 0;
                        newItem.dec_priceBookCost = 0;
                    }
                    
                    //Added By Buwen Guo 2017-12-21 from email:Bugs 12/20 point 3
                    if(oppy.ERP_for_Pricing__c == 'SAP (except ANZPAC)'){
                        newItem.oppyPart.Primary_Pack_Quantity__c =  map_partId_PPQ.containsKey(str_partId) ? map_partId_PPQ.get(str_partId) :0;
                    }
                    
                    /*
                     * delete initial value for picklist.
                     * edited by:buwen guo 2017-09-25   requirement from email:SFDC - MFGPRO field Mapping
                    if(newItem.isDummyPart){
                        newItem.oppyPart.Proposal_UOM__c = 'PC';
                    }else{
                        newItem.oppyPart.Proposal_UOM__c = null;
                    }
                    */
                    list_oppyPartItems.add(newItem);
                }
                list_oppyPartItems = oppyPartSort(list_oppyPartItems);
                set<String> set_addPartIds = map_partId_partName.keySet();
                set_partId.addAll(set_addPartIds);
                //list_parts.clear();
                /*
                for(Integer i=0; i<list_parts.size(); i++) {
                    if(set_addPartIds.contains(list_parts[i].Id)) {
                        list_parts.remove(i);
                        i--;
                    }
                }
                */
                //this.str_partListJson = Json.serialize(list_parts);
            }
        }
        displayUploadPopup = false;
        displayPopup = false;
    }
    
    
    /*------------------------------------------------------------
    Author:        Bin Yuan <bin.yuan@capgemini.com>
    Description:   method to add opportunity part
    Inputs:        
    Returns:       
    History
    2017-07-10     Bin Yuan <bin.yuan@capgemini.com> created
    ------------------------------------------------------------*/
    public void addPartsNewAction() {
        try{
            Set<String> set_dummyPartNames = new Set<String>{'Transportation Costs', 'Installation Costs', 'Training Costs','Freight Costs','Commission Costs','Distribution Costs','Other Costs'};
            list<OppyPartDiscountItem> list_oppyPartItems2Insert = new list<OppyPartDiscountItem>();
            list<innerClassForAdd> list_partId2AddWithQuantity = new list<innerClassForAdd>();
            System.debug('*** 1'+str_partIds2AddJsonWithNum);
            list_partId2AddWithQuantity = (list<innerClassForAdd>) Json.deserialize(str_partIds2AddJsonWithNum, list<innerClassForAdd>.class);
            map<String,Integer> map_partId_quantity = new map<String,Integer>();
            list<String> list_partId2Add = new list<String>();
            
            for(innerClassForAdd innerObj : list_partId2AddWithQuantity){
                Integer int_quantity = 0;
                if(innerObj.quantity != null && innerObj.quantity.trim() != ''){
                    int_quantity = Integer.valueOf(Decimal.valueOf(innerObj.quantity).round());
                }
                list_partId2Add.add(innerObj.partId);
                map_partId_quantity.put(innerObj.partId,int_quantity);
            }
            
            if(!list_partId2Add.isEmpty()) {
                System.debug('*** 2');
                map<String, String> map_partId_partName = new map<String, String>();
                map<String, String> map_partId_description = new map<String, String>();
                map<String, String> map_partId_cbc4description = new map<String, String>();
                map<String, String> map_partId_cbc4product = new map<String, String>();
                map<String, boolean> map_partId_isProposalPart = new map<String, boolean>();
                map<String, String> map_partId_baseUMcode = new map<String, String>();
                map<String,decimal> map_partId_standardCosts = new map<String,decimal>();
                map<String, String> map_partId_currencyIsoCode = new map<String, String>();
                
                
                for(Part__c part : [Select Id, Name,Description__c,Product_hierarchy__r.CBC4_Description__c,
                                        Product_hierarchy__c,Proposal_Part__c,BASE_UM_CDE__c, UNIT_PACKAGING_TYPE_CDE__c,Curr_CS_75__c,CurrencyIsoCode,
                                        Min_Order_Qty__c,Primary_Pack_Qty__c,Lead_Time_Days__c 
                                    From Part__c
                                    Where id in : list_partId2Add]) {
    
                    map_partId_partName.put(part.Id, part.Name);    
                    map_partId_description.put(part.Id, part.Description__c);
                    map_partId_cbc4description.put(part.Id, part.Product_hierarchy__r.CBC4_Description__c);
                    map_partId_cbc4product.put(part.Id, part.Product_hierarchy__c);     
                    map_partId_isProposalPart.put(part.Id, part.Proposal_Part__c);  
                    //map_partId_baseUMcode.put(part.Id, part.BASE_UM_CDE__c);  
                    map_partId_baseUMcode.put(part.Id, part.UNIT_PACKAGING_TYPE_CDE__c);    //modified by Tangyong Li 2017-11-08
                    map_partId_standardCosts.put(part.Id, part.Curr_CS_75__c); //Added by Buwen Guo 2017-12-04 from email: Issues 12/1 point 10
                    map_partId_currencyIsoCode.put(part.Id, part.CurrencyIsoCode); //Added by Buwen Guo 2017-12-04 from email: Issues 12/1 point 10
                }
    
                if(!map_partId_partName.isEmpty()) {
                    System.debug('*** 3');
                    for(String str_partId : map_partId_partName.keySet()) {
                        System.debug('*** 4');
                        OppyPartDiscountItem newItem = new OppyPartDiscountItem();
                        newItem.oppyPart =  new Opportunity_Part__c();
                        newItem.oppyPart.Part__c = str_partId;
                        newItem.oppyPart.Opportunity__c = this.oppy.Id;
                        newItem.oppyPart.Status__c = 'Pending';
                        newItem.oppyPart.Quantity__c = (map_partId_quantity.containsKey(str_partId))?map_partId_quantity.get(str_partId):0;
                        
                        newItem.oppyPart.CurrencyIsoCode = this.oppy.CurrencyIsoCode;
                        newItem.str_partName = map_partId_partName.get(str_partId);
                        newItem.str_partDescription = map_partId_description.get(str_partId);
                        newItem.str_CBC4Product = (map_partId_cbc4product.containsKey(str_partId))?map_partId_cbc4product.get(str_partId):null;
                        newItem.str_CBC4Description = (map_partId_cbc4description.containsKey(str_partId))?map_partId_cbc4description.get(str_partId):null;
                        //if this part is dummy part,clear the CBC4Description field value.
                        newItem.str_CBC4Description = (set_dummyPartNames.contains(newItem.str_partName) ? '' : ( newItem.str_partName.toLowerCase().contains('proposal') ? (map_partId_cbc4product.containsKey(str_partId) && map_partId_cbc4product.get(str_partId) != null ? newItem.str_CBC4Description:''):newItem.str_CBC4Description ));
                        newItem.isDOAAproved = (this.oppy.Approval_Status__c == 'Approved')?true:false;
                        newItem.isDummyPart = set_dummyPartNames.contains(newItem.str_partName) ? true : newItem.str_partName.toLowerCase().contains('proposal') ? true : false;
                        newItem.isDisplayComment = map_partId_isProposalPart.containsKey(str_partId) ? map_partId_isProposalPart.get(str_partId) :false;
                        
                        if(!newItem.isDummyPart){
                            String str_umCode = map_partId_baseUMcode.get(str_partId);
                            if(str_umCode != null && str_umCode.length() >= 5){str_umCode = str_umCode.substring(0,4);}
                            //newItem.oppyPart.NDR_Item_Price_UOM__c = str_umCode;
                            newItem.oppyPart.Code_for_unit_of_measurement__c = str_umCode;
                        } else {
                            String str_umCode = map_partId_baseUMcode.get(str_partId);
                            if(str_umCode != null){
                                if(str_umCode.length() >= 5) {
                                    str_umCode = str_umCode.substring(0,4);
                                }
                                newItem.oppyPart.Code_for_unit_of_measurement__c = str_umCode;
                            } else {
                                newItem.oppyPart.Code_for_unit_of_measurement__c = 'PC';
                            }
                        }
                        
                        list_oppyPartItems.add(newItem);
                        list_oppyPartItems2Insert.add(newItem);
                    }
                    list_oppyPartItems = oppyPartSort(list_oppyPartItems);
                    set<String> set_addPartIds = map_partId_partName.keySet();
                    set_partId.addAll(set_addPartIds);
                    
                }
            }
            displayUploadPopup = false;
            displayPopup = false;
            
            
            //Modified by Buwen Guo 2018-04-02 Add part for create save json.
            List<OppyPartDiscountItem> list_parts2Insert = new List<OppyPartDiscountItem>();
            for(OppyPartDiscountItem item : list_oppyPartItems2Insert){
                opportunity_part__c newPart = new Opportunity_Part__c();
                newPart.Opportunity__c = item.oppyPart.Opportunity__c;
                newPart.Status__c = item.oppyPart.Status__c;
                newPart.part__c = item.oppyPart.part__c;
                newPart.Part_number__c = item.str_partName;
                newPart.Proposal_Part_Name_Override__c = item.oppyPart.Proposal_Part_Name_Override__c == null || item.oppyPart.Proposal_Part_Name_Override__c == '' ? item.str_partDescription : item.oppyPart.Proposal_Part_Name_Override__c;
                newPart.Quantity__c = set_dummyPartNames.contains(item.str_partName) ? 1 : (item.oppyPart.Quantity__c == null ? 0 : item.oppyPart.Quantity__c);
                newPart.Code_for_unit_of_measurement__c = item.oppyPart.Code_for_unit_of_measurement__c == null || item.oppyPart.Code_for_unit_of_measurement__c =='' ? 'PC' :item.oppyPart.Code_for_unit_of_measurement__c;
                newPart.Standard_Cost__c = 0;
                newPart.NDR_Item_Price_Per__c = '1';
                newPart.Offered_Price__c = 0;
                newPart.Energy_Quote_Line_Item__c = null;
                newPart.Comments__c = '';
                OppyPartDiscountItem newItem = new OppyPartDiscountItem();
                newItem.oppyPart = newPart;
                list_parts2Insert.add(newItem);
            }
            String saveResult = 'success';
            if(list_parts2Insert.size() > 0){
                saveResult = saveOppyPartsRemoteAction(oppy.Id,Json.serialize(list_parts2Insert));
                system.debug('addPartsNewAction::'+saveResult);
                if(saveResult != null && saveResult.indexOf('Error:')> -1){
                    str_errorMessage = saveResult;
                    showErrorMessage();
                }
            }
            addPartsNewActionResult = saveResult;
            if(saveResult == 'success'){
                init();
            }
        }catch(Exception ex) {
            system.debug('Exception::'+ex.getMessage()+','+ex.getStackTraceString());

            isSaveHasError = true;

            ErrorLogging.Log(ex);
            String vStrError = '';
            vStrError += 'Error Type = ' + ex.getTypeName() + 
                ' Error Line = ' + ex.getLineNumber() + '' + 
                ' Error Stack = ' + ex.getStackTraceString() + 
                ' Error Message = ' + ex.getMessage();
            
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,                   
                                         SalesforceConstant.strError, '', '', '', '5','','','Exception', ex.getLineNumber() + '',ex.getStackTraceString());
            
            boolean isPassContactRoleCheck = checkContactRole(oppy.Id);
            if(isPassContactRoleCheck){
                addPartsNewActionResult = 'Error:'+ex.getMessage()+'. '+ex.getStackTraceString();
            }else{
                addPartsNewActionResult = 'Error: You must create a contact role on this opportunity before you can perform this operation.';
            }
            str_errorMessage = addPartsNewActionResult;
            showErrorMessage();
        }
    }
    
    
    
    /*------------------------------------------------------------
    Author:        Bin Yuan <bin.yuan@capgemini.com>
    Description:   method to sort opportunity part
    Inputs:        
    Returns:       
    History
    2017-07-10     Bin Yuan <bin.yuan@capgemini.com> created
    ------------------------------------------------------------*/
    public list<OppyPartDiscountItem> oppyPartSort(list<OppyPartDiscountItem> list_oppyPartItems) {
        list<OppyPartDiscountItemWrapper> listOppyPartWrapper = new list<OppyPartDiscountItemWrapper>();
        dec_currMaxSeqNumber = 0;
        
        list<OppyPartDiscountItem> listOppyPartWrapperForNew = new list<OppyPartDiscountItem>();
        list<OppyPartDiscountItem> listOppyPartWrapperForOld = new list<OppyPartDiscountItem>();
        Decimal dec_maxSeqNumber = 0;
        for(OppyPartDiscountItem opdiw : list_oppyPartItems){
            if(opdiw.oppyPart.Seq_No__c == null || opdiw.oppyPart.Seq_No__c == 0){
                listOppyPartWrapperForNew.add(opdiw);
            }else{
                dec_maxSeqNumber = opdiw.oppyPart.Seq_No__c;
                listOppyPartWrapperForOld.add(opdiw);
            }
        }
        Integer int_firstSeqNum = 0;
        if(dec_maxSeqNumber != 0){
            int_firstSeqNum = math.floor(dec_maxSeqNumber).intValue();
        }
        for(Integer i = 0;i<listOppyPartWrapperForNew.size();i++){
            listOppyPartWrapperForNew[i].oppyPart.Seq_No__c = int_firstSeqNum + i + 1;
            listOppyPartWrapperForNew[i].oppyPart.Seq_No__c = listOppyPartWrapperForNew[i].oppyPart.Seq_No__c.setScale(2);
            if(dec_currMaxSeqNumber <= listOppyPartWrapperForNew[i].oppyPart.Seq_No__c){
                dec_currMaxSeqNumber = listOppyPartWrapperForNew[i].oppyPart.Seq_No__c;
            }
        }
        
        for(Integer i = 0;i<listOppyPartWrapperForOld.size();i++){
            if(dec_currMaxSeqNumber <= listOppyPartWrapperForOld[i].oppyPart.Seq_No__c){
                dec_currMaxSeqNumber = listOppyPartWrapperForOld[i].oppyPart.Seq_No__c;
            }
        }
        
        for(OppyPartDiscountItem oppPart : listOppyPartWrapperForOld) {
            listOppyPartWrapper.add(new OppyPartDiscountItemWrapper(oppPart));
        }
        for(OppyPartDiscountItem oppPart : listOppyPartWrapperForNew) {
            listOppyPartWrapper.add(new OppyPartDiscountItemWrapper(oppPart));
        }
        listOppyPartWrapper.sort();
        
        
        list_oppyPartItems = new list<OppyPartDiscountItem>();
        for(OppyPartDiscountItemWrapper o : listOppyPartWrapper) {
            list_oppyPartItems.add(o.oppyPartItem);
        }
        return list_oppyPartItems;
    }
    
    
    
    
    
    /*------------------------------------------------------------
    Author:        Bin Yuan <bin.yuan@capgemini.com>
    Description:   method to delete existing opportunity part
    Inputs:        
    Returns:       
    History
    2017-07-10     Bin Yuan <bin.yuan@capgemini.com> created
    ------------------------------------------------------------*/
    public void deleteOppyPart() {
        list<Opportunity_Part__c> list_delOppyParts = new list<Opportunity_Part__c>();
        list<Opportunity_Part__c> list_oppyParts = new list<Opportunity_Part__c>();
        try {
            OppyPartDiscountItem delItem = list_oppyPartItems.remove(oppylist_index - 1);
            set_partId.remove(delItem.oppyPart.Part__c);
            if(delItem.oppyPart.Id != null) {
                list_delOppyParts.add(delItem.oppyPart);
            }
            OpportunityTrgHandler.isEditingOpportunityPartState = true;
            if(list_delOppyParts.size() > 0) {
                delete list_delOppyParts;
            }
            for(OppyPartDiscountItem partItem : list_oppyPartItems) {
                list_oppyParts.add(partItem.oppyPart);
            }
            System.debug('list_oppyParts:::'+list_oppyParts);
            //calcOppyPartItemFraction(list_oppyParts);
            if(!list_oppyParts.isEmpty()) {
                upsert list_oppyParts;
            }
        } catch(Exception ex) {
            
            ErrorLogging.Log(ex);
            String vStrError = '';
            vStrError += 'Error Type = ' + ex.getTypeName() + 
                ' Error Line = ' + ex.getLineNumber() + '' + 
                ' Error Stack = ' + ex.getStackTraceString() + 
                ' Error Message = ' + ex.getMessage();
            
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,                   
                                         SalesforceConstant.strError, '', '', '', '5','','','Exception', ex.getLineNumber() + '',ex.getStackTraceString());
            
            boolean isPassContactRoleCheck = checkContactRole(this.oppy.Id);
            if(isPassContactRoleCheck){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getStackTraceString()));
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getMessage()));
            }else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'You must create a contact role on this opportunity before you can perform this operation.'));
            }
        }
    }
    



    /*------------------------------------------------------------
    Author:        Bin Yuan <bin.yuan@capgemini.com>
    Description:   method to upload oppyortunity part from .csv file
    Inputs:        
    Returns:       
    History
    2017-07-10     Bin Yuan <bin.yuan@capgemini.com> created
    ------------------------------------------------------------*/
    public void upsertOppyPart() {
        system.debug('str_oppIdPartNumberJson::'+str_oppIdPartNumberJson);
        isSaveHasError = false;
        Set<String> set_dummyPartNames = new Set<String>{'Transportation Costs', 'Installation Costs', 'Training Costs','Freight Costs','Commission Costs','Distribution Costs','Other Costs'};
        
        list<OppyPartDiscountItem> list_oppyPartItem = new list<OppyPartDiscountItem>();
        list<Opportunity_Part__c> list_upsertOppyParts = new list<Opportunity_Part__c>();
        list_uploadFailedData = new list<OppyPartDiscountItem>();
        //set<String> set_partNum = new set<String>();
        //set<String> set_oppyId = new set<String>();
        set<String> set_partName = new set<String>();
        set<String> set_existId = new set<String>();
        map<String, Id> map_partName_partId = new map<String, Id>();
        map<String, String> map_partName_baseUMcode = new map<String, String>();
        
        //map<String, list<Opportunity_Part__c>> map_oppyId_oppyPart = new map<String, list<Opportunity_Part__c>>();
        try {
            list_oppyPartItem = (list<OppyPartDiscountItem>) JSON.deserialize(str_oppIdPartNumberJson, list<OppyPartDiscountItem>.class);
            for(OppyPartDiscountItem partItem : list_oppyPartItem) {
                //set_partNum.add(partItem.oppyPart.Part__c);
                //set_oppyId.add(partItem.oppyPart.Opportunity__c);
                if(partItem.str_partName != null && partItem.str_partName != '') {
                    set_partName.add(partItem.str_partName);
                }
            }
            
            set<String> set_partId2Add = new set<String>();
            map<String,decimal> map_partId_standardCosts = new map<String,decimal>();
            map<String, String> map_partId_currencyIsoCode = new map<String, String>();
            
            //Added by Buwen Guo 2017-12-14 from email:12/13 Issues point 2
            map<String,decimal> map_partId_MOQ = new map<String,decimal>();
            map<String,decimal> map_partId_LTDays = new map<String,decimal>();
            map<String,decimal> map_partId_Availability = new map<String,decimal>();
            map<String,decimal> map_partId_PPQ = new map<String,decimal>();
            
            for(Part__c p : [SELECT Id, Name,BASE_UM_CDE__c, UNIT_PACKAGING_TYPE_CDE__c,Curr_CS_75__c,CurrencyIsoCode,
                                    Min_Order_Qty__c,Lead_Time_Days__c,Primary_Pack_Qty__c
                                    //FROM Part__c WHERE IsActive__c = true and Product_Hierarchy__r.CBC1__c = '13005' and 
                                    FROM Part__c WHERE Product_Hierarchy__r.CBC1__c = '13005' and 
                                    Name IN: set_partName order by createdDate desc]) {
                if(!map_partName_partId.containsKey(p.Name)) {
                    map_partName_partId.put(p.Name, p.Id);
                }
                if(!map_partName_baseUMcode.containsKey(p.Name)) {
                    //map_partName_baseUMcode.put(p.Name, p.BASE_UM_CDE__c);
                    map_partName_baseUMcode.put(p.Name, p.UNIT_PACKAGING_TYPE_CDE__c); //modified by Tangyong Li 2017-11-08
                }
                set_partId2Add.add(p.Id);
                
                map_partId_standardCosts.put(p.Id, p.Curr_CS_75__c); //Added by Buwen Guo 2017-12-04 from email: Issues 12/1 point 10
                map_partId_currencyIsoCode.put(p.Id, p.CurrencyIsoCode); //Added by Buwen Guo 2017-12-04 from email: Issues 12/1 point 10
                
                //Added by Buwen Guo 2017-12-14 from email:12/13 Issues point 2,9
                map_partId_MOQ.put(p.Id, p.Min_Order_Qty__c);
                map_partId_LTDays.put(p.Id, p.Lead_Time_Days__c);
                //map_partId_Availability.put(p.Id, p.Primary_Pack_Qty__c);
                map_partId_PPQ.put(p.Id, p.Primary_Pack_Qty__c);
            }
            map<String, Opportunity_Part__c> map_partId_oppPart = new map<String, Opportunity_Part__c>();
            list<Opportunity_Part__c> list_oppyParts = new list<Opportunity_Part__c>();
            
            //get related Energy_Price_Book_Entry__c cost
            map<String,decimal> map_partId_pricebookCosts = new map<String,decimal>();
            
            for(Energy_Price_Book_Entry__c qli : [select id,UnitPrice__c,Part__c,StandardPrice__c 
                                            from Energy_Price_Book_Entry__c 
                                            where Part__c IN :set_partId2Add ]){
                                                
                if(!map_partId_pricebookCosts.containsKey(qli.Part__c)){
                    //Edit by Buwen Guo 2017-10-30 from email:Things to fix 
                    //Change UnitPrice__c to StandardPrice__c.
                    //Modified by Buwen Guo 2017-12-01 from email:Issues 11/30 point 4
                    map_partId_pricebookCosts.put(qli.Part__c,qli.UnitPrice__c);
                    //map_partId_pricebookCosts.put(qli.Part__c,qli.StandardPrice__c);
                }
            }
            
            //added by Tangyong Li 2017-12-03
            /*
            for(Opportunity_Part__c oppPart :[SELECT Id, Opportunity__c, Part__c, Part__r.Name, OppIdPartNumber__c, Status__c,
                                                               Quantity__c, Offered_Price__c,Seq_No__c  
                                                        FROM Opportunity_Part__c 
                                                        WHERE Opportunity__c =: oppy.Id
                                                        order by Seq_No__c asc]){
                list_oppyParts.add(oppPart);
                map_partId_oppPart.put(oppPart.Id,oppPart);
            }*/
            list<Opportunity_Part__c> list_delOppyParts = [SELECT Id, Opportunity__c, Part__c, Part__r.Name, OppIdPartNumber__c, Status__c,
                                                                  Quantity__c, Offered_Price__c,Seq_No__c  
                                                           FROM Opportunity_Part__c 
                                                           WHERE Opportunity__c =: oppy.Id];
            
            for(OppyPartDiscountItem partItem : list_oppyPartItem) {
                Opportunity_Part__c oppyPart = partItem.oppyPart;
                //oppyPart.OppIdPartNumber__c = (oppyPart.Opportunity__c + '' + oppyPart.Part__c);
                //Modified By Buwen Guo 2017-12-11 delete old logic.
                /*
                for(String str_existOppPartId : map_partId_oppPart.keySet()) {
                    Opportunity_Part__c existOppPart = map_partId_oppPart.get(str_existOppPartId);
                    if(existOppPart.Part__r.Name == partItem.str_partName) {
                        if(map_partName_partId.containsKey(partItem.str_partName)) {
                            map_partName_partId.remove(partItem.str_partName);
                        }
                        oppyPart.Id = existOppPart.Id;
                        oppyPart.Seq_No__c = existOppPart.Seq_No__c;
                        oppyPart.Part_number__c = partItem.str_partName;
                        oppyPart.Status__c = existOppPart.Status__c;
                        
                        if(set_dummyPartNames.contains(partItem.str_partName)){
                            oppyPart.Sales_price__c = 0;
                            oppyPart.Offered_Price__c = 0;
                        } else {
                            //Opportunity_Part__c tempPart = new Opportunity_Part__c();
                            //tempPart.Quantity__c = dec_defaultQuantity;
                            //tempPart.Part_Number__c = partItem.str_partName;
                            //oppyPart.Sales_price__c = InventoryAndPricing.getInventoryAndPrice(oppy,tempPart);
                            //oppyPart.Offered_Price__c = oppyPart.Sales_price__c;
                        }
                        
                        system.debug('oppyPart.Quantity__c::'+oppyPart.Quantity__c+'::oppyPart.Offered_Price__c::'+oppyPart.Offered_Price__c);
                        if(oppyPart.Offered_Price__c == null){oppyPart.Offered_Price__c = 0;}
                        oppyPart.TotalPrice__c = oppyPart.Quantity__c * oppyPart.Offered_Price__c;
                        oppyPart.CurrencyIsoCode = this.oppy.CurrencyIsoCode;
                        oppyPart.Lost_Reason__c = 'Other';
                        system.debug('existoppyPart.Sales_price__c::'+oppyPart.Sales_price__c);
                        list_upsertOppyParts.add(oppyPart);
                        set_existId.add(existOppPart.Id);
                        map_partId_oppPart.remove(str_existOppPartId);
                        break;
                    }
                    //if(existOppPart.Opportunity__c == oppyPart.Opportunity__c && existOppPart.Part__c == oppyPart.Part__c) {
                    //  oppyPart.Id = existOppPart.Id;
                    //  set_existId.add(existOppPart.Id);
                    //  break;
                    //}
                }
                
                //if(!map_oppyId_oppyPart.containsKey(oppyPart.Opportunity__c)) {
                //  map_oppyId_oppyPart.put(oppyPart.Opportunity__c, new list<Opportunity_Part__c>());
                //}
                //map_oppyId_oppyPart.get(oppyPart.Opportunity__c).add(oppyPart);
                system.debug('oppyPart.Id::'+oppyPart.Id);
                system.debug('oppyPart.name::'+partItem.str_partName);
                system.debug('oppyPart.Quantity__c::'+oppyPart.Quantity__c);
                system.debug('oppyPart.Sales_price__c::'+oppyPart.Sales_price__c);
                system.debug(map_partName_partId.containsKey(partItem.str_partName));
                */
                
                if(oppyPart.Id == null) {
                    if(map_partName_partId.containsKey(partItem.str_partName)) {
                        oppyPart.Part__c = map_partName_partId.get(partItem.str_partName);
                        oppyPart.Part_number__c = partItem.str_partName;
                        if(map_partName_baseUMcode.get(partItem.str_partName) != null) {
                            oppyPart.Code_for_unit_of_measurement__c = map_partName_baseUMcode.get(partItem.str_partName);
                        } else {
                            oppyPart.Code_for_unit_of_measurement__c = 'PC';
                        }
                        oppyPart.Status__c = 'Pending';
                        oppyPart.Lost_Reason__c = 'Other';
                        oppyPart.CurrencyIsoCode = this.oppy.CurrencyIsoCode;
                        
                        if(set_dummyPartNames.contains(partItem.str_partName)){
                            oppyPart.Sales_price__c = 0;
                            oppyPart.Offered_Price__c = 0;
                        } 
                        //else {
                            //Opportunity_Part__c tempPart = new Opportunity_Part__c();
                            //tempPart.Quantity__c = dec_defaultQuantity;
                            //tempPart.Part_Number__c = partItem.str_partName;
                            //oppyPart.Sales_price__c = InventoryAndPricing.getInventoryAndPrice(oppy,tempPart);
                            //oppyPart.Offered_Price__c = oppyPart.Sales_price__c;
                        //}
                        
                        if(displayAmpicsButton){
                            //Modified by Buwen Guo 2017-12-01 from email:Issues 11/30 point 4
                            //newItem.oppyPart.Standard_Cost__c =  map_partId_pricebookCosts.containsKey(str_partId) ? map_partId_pricebookCosts.get(str_partId) :0;
                            //Added by Buwen Guo 2017-12-04 from email: Issues 12/1 point 10
                            Decimal dec_standardCost = map_partId_standardCosts.containsKey(oppyPart.Part__c) ? map_partId_standardCosts.get(oppyPart.Part__c) :0;
                            String str_currency = map_partId_currencyIsoCode.containsKey(oppyPart.Part__c) ? map_partId_currencyIsoCode.get(oppyPart.Part__c) : 'USD';
                            oppyPart.Standard_Cost__c =  ClsAPLForecastUtil.transformIsoCode(dec_standardCost,str_currency,oppyPart.CurrencyIsoCode);
                            Decimal dec_custStdPrice = map_partId_pricebookCosts.containsKey(oppyPart.Part__c) ? map_partId_pricebookCosts.get(oppyPart.Part__c) :0;
                            oppyPart.Sales_Price__c =  dec_custStdPrice != 0 ? ClsAPLForecastUtil.transformIsoCode(dec_custStdPrice,'AUD',oppyPart.CurrencyIsoCode):0;
                            
                            //Added by Buwen Guo 2017-12-14 from email:12/13 Issues point 2
                            oppyPart.Min_Order_Qty__c =  map_partId_MOQ.containsKey(oppyPart.Part__c) ? map_partId_MOQ.get(oppyPart.Part__c) :0;
                            oppyPart.Lead_Time__c =  map_partId_LTDays.containsKey(oppyPart.Part__c) ? map_partId_LTDays.get(oppyPart.Part__c) :0;
                            //oppyPart.Availability__c =  map_partId_Availability.containsKey(oppyPart.Part__c) ? map_partId_Availability.get(oppyPart.Part__c) :0;
                            oppyPart.Primary_Pack_Quantity__c =  map_partId_PPQ.containsKey(oppyPart.Part__c) ? map_partId_PPQ.get(oppyPart.Part__c) :0;
                        }
                        
                        //Added By Buwen Guo 2017-12-21 from email:Bugs 12/20 point 3
                        if(oppy.ERP_for_Pricing__c == 'SAP (except ANZPAC)'){
                            oppyPart.Primary_Pack_Quantity__c =  map_partId_PPQ.containsKey(oppyPart.Part__c) ? map_partId_PPQ.get(oppyPart.Part__c) :0;
                        }
                        
                        if(oppyPart.Offered_Price__c == null){oppyPart.Offered_Price__c = 0;}
                        oppyPart.TotalPrice__c = oppyPart.Quantity__c * oppyPart.Offered_Price__c;
                        system.debug('NewoppyPart.Sales_price__c::'+oppyPart.Sales_price__c);
                        list_upsertOppyParts.add(oppyPart);
                    } else {
                        list_uploadFailedData.add(partItem);
                    }
                }
            }
            for(Opportunity_Part__c partItem : list_oppyParts) {
                if(!set_existId.contains(partItem.Id) && partItem.Quantity__c != null && partItem.Quantity__c != 0 && partItem.Offered_Price__c != null && partItem.Offered_Price__c != 0) {
                    list_upsertOppyParts.add(partItem);
            //      if(!map_oppyId_oppyPart.containsKey(partItem.Opportunity__c)) {
            //          map_oppyId_oppyPart.put(partItem.Opportunity__c, new list<Opportunity_Part__c>());
            //      }
            //      map_oppyId_oppyPart.get(partItem.Opportunity__c).add(partItem);
                }
            }
            //for(String oppyId : map_oppyId_oppyPart.keySet()) {
            //  calcOppyPartItemFraction(map_oppyId_oppyPart.get(oppyId));
            //  list_upsertOppyParts.addAll(map_oppyId_oppyPart.get(oppyId));
            //}
            system.debug('list_upsertOppyParts::'+list_upsertOppyParts);
            //calcOppyPartItemFraction(list_upsertOppyParts);
            
            OpportunityTrgHandler.isEditingOpportunityPartState = true;
            isEnergyPartManagementSave = true;
            if(!list_delOppyParts.isEmpty()) {
                delete list_delOppyParts;
            }
            if(!list_upsertOppyParts.isEmpty()) {
                upsert list_upsertOppyParts;
            }
            /*removed by Buwen Guo 2017-12-20 required from email:Preparing for another push to Integrate.  But this time - we'll be extra prepared!
            Integer counter_targetLowerThanSales = 0;
            Decimal dec_oppyAmount = 0;
            for(Opportunity_Part__c oppyPart : list_upsertOppyParts){
                dec_oppyAmount = dec_oppyAmount + oppyPart.TotalPrice__c;
                if(oppyPart.Offered_Price__c < oppyPart.Sales_price__c){
                    counter_targetLowerThanSales = counter_targetLowerThanSales + 1;
                }
            }
            if(counter_targetLowerThanSales > 0) {
                Opportunity op;
                for(Opportunity opp :[select id,Approval_Status__c from Opportunity where id=:oppy.Id]){
                    op = opp;
                }
                if(op != null){
                    //op.DOA_Required__c = true;
                    //op.Approval_Status__c = 'Approval Required';
                    if(dec_oppyAmount != null){
                        //op.Amount = dec_oppyAmount;
                    }
                    //update op;
                }
            }
            */
            
            //reload oppy field.
            for(Opportunity opp :[select Id,Account.Source_System__c,Account_Number__c,currencyIsoCode,AccountId,ERP_For_Pricing__c,Territory__c,
                                Account.Sales_Hierarchy__c,
                                Primary_Product_Hierarchy__c,Approval_Status__c,Account.recordtype.name,recordtype.developername,stagename  from Opportunity where id=:oppy.Id]){
                oppy = opp;
            }
            
            if(oppy.Territory__c == null || oppy.ERP_for_Pricing__c == null ){
                boolean bool_isNeedUpdateOppy = false;
                
                if(oppy.Territory__c == null && oppy.Account != null && oppy.Account.Sales_Hierarchy__c != null){
                    oppy.Territory__c = oppy.Account.Sales_Hierarchy__c;
                    bool_isNeedUpdateOppy = true;
                }
                //Modified By Buwen Guo 2017-12-11
                //This logic has been moved into opportunity trigger so remove it.
                /*
                if((oppy.ERP_for_Pricing__c == null || oppy.ERP_for_Pricing__c == '') && oppy.Account != null && oppy.Account.Source_System__c != null){
                    if(oppy.Account.Source_System__c == 1) {
                        oppy.ERP_for_Pricing__c = 'SAP';
                    } else if(oppy.Account.Source_System__c == 42) {
                        oppy.ERP_for_Pricing__c = 'Ampics';
                    } else if(oppy.Account.Source_System__c == 51) {
                        oppy.ERP_for_Pricing__c = 'MFGPRO';
                    } else {
                        oppy.ERP_for_Pricing__c = 'No ERP';
                    }
                    bool_isNeedUpdateOppy = true;
                }
                */
                
                if(bool_isNeedUpdateOppy){
                    update oppy;
                }
            }
            
            displayUploadPopup = false;
            displayPopup = false;
            //isEnergyPartManagementSave = false;
        } catch(Exception ex) {
            isSaveHasError = true;
            system.debug('Exception::'+ex.getStackTraceString()+ex.getMessage());
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getStackTraceString()));
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getMessage()));
            ErrorLogging.Log(ex);
            String vStrError = '';
            vStrError += 'Error Type = ' + ex.getTypeName() + 
                ' Error Line = ' + ex.getLineNumber() + '' + 
                ' Error Stack = ' + ex.getStackTraceString() + 
                ' Error Message = ' + ex.getMessage();
            
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,                   
                                         SalesforceConstant.strError, '', '', '', '5','','','Exception', ex.getLineNumber() + '',ex.getStackTraceString());
        }
    }
    
    
    /*------------------------------------------------------------
    Author:        Bin Yuan <bin.yuan@capgemini.com>
    Description:   method to close the upload popup window.
    Inputs:        
    Returns:       
    History
    2017-07-10     Bin Yuan <bin.yuan@capgemini.com> created
    ------------------------------------------------------------*/
    public void closeUploadPopup() {        
        displayUploadPopup = false;    
    }  
    
    
    /*------------------------------------------------------------
    Author:        Bin Yuan <bin.yuan@capgemini.com>
    Description:   method to display the upload popup window.
    Inputs:        
    Returns:       
    History
    2017-07-10     Bin Yuan <bin.yuan@capgemini.com> created
    ------------------------------------------------------------*/   
    public void showUploadPopup() {        
        displayUploadPopup = true;    
    }
    
    
    /*------------------------------------------------------------
    Author:        Bin Yuan <bin.yuan@capgemini.com>
    Description:   method to close the search part popup window.
    Inputs:        
    Returns:       
    History
    2017-07-10     Bin Yuan <bin.yuan@capgemini.com> created
    ------------------------------------------------------------*/
    public void closePopup() {
        if(list_parts != null) {
            list_parts.clear();
        }
        displayPopup = false; 
        displayPartSearchError = false;   
        displayPartSearchNoResult = false;
        int_searchNoResultCounter = 0;   
    }  
    
    
    /*------------------------------------------------------------
    Author:        Bin Yuan <bin.yuan@capgemini.com>
    Description:   method to display the search part popup window.
    Inputs:        
    Returns:       
    History
    2017-07-10     Bin Yuan <bin.yuan@capgemini.com> created
    ------------------------------------------------------------*/   
    public void showPopup() {   
        int_searchNoResultCounter = 0;     
        displayPopup = true;    
        displayPartSearchError = false;   
        displayPartSearchNoResult = false;
    }
    
    
    /*------------------------------------------------------------
    Author:        Bin Yuan <bin.yuan@capgemini.com>
    Description:   util method to transform the currency value.
    Inputs:        
    Returns:       
    History
    2017-07-10     Bin Yuan <bin.yuan@capgemini.com> created
    ------------------------------------------------------------*/
    public void transformIsoCode(){
        Decimal sourceValue = Decimal.valueOf(str_currencyFromValue);
        String fromIsoCode = str_currencyFromCode;
        String toIsoCode = str_currencyToCode;
        Decimal dec_result = ClsAPLForecastUtil.transformIsoCode(sourceValue,fromIsoCode,toIsoCode);
        str_currencyToValue = String.valueOf(dec_result);
    }
    
    
    
    /*------------------------------------------------------------
    Author:        Bin Yuan <bin.yuan@capgemini.com>
    Description:   method to init the currency transform functionality.
    Inputs:        
    Returns:       
    History
    2017-07-10     Bin Yuan <bin.yuan@capgemini.com> created
    ------------------------------------------------------------*/
    public void initCurrencyTransformParams(){
        str_currencyFromValue = '';
        str_currencyToValue = '';
        str_currencyFromCode = '';
        str_currencyToCode = '';
    }
    
    /*
    public void clearSearchText() {
        str_partNumb = '';
        str_partDescription = '';
    }
    */
    
    
    
    /*------------------------------------------------------------
    Author:        Bin Yuan <bin.yuan@capgemini.com>
    Description:   method to save opportunity parts
    Inputs:        
    Returns:       
    History
    2017-07-10     Bin Yuan <bin.yuan@capgemini.com> created
    ------------------------------------------------------------*/
    @RemoteAction
    global static string saveOppyPartsRemoteAction(String str_oppyId,String str_oppyPartJson) {
        isSaveHasError = false;
        Set<String> set_dummyPartNames = new Set<String>{'Transportation Costs', 'Installation Costs', 'Training Costs','Freight Costs','Commission Costs','Distribution Costs','Other Costs'};
        list<OppyPartDiscountItem> list_oppyPartItem = new list<OppyPartDiscountItem>();
        list<Opportunity_Part__c> list_oppyParts = new list<Opportunity_Part__c>();
        list<Opportunity_Part__c> list_delOppyParts = new list<Opportunity_Part__c>();
        set<String> set_existOppyPartsIds = new set<String>();
        set<String> set_needCalloutOppyPartsIds = new set<String>();
        system.debug('saveOppyPartsRemoteAction::'+str_oppyId);
        
        try {
            Opportunity op;
            for(Opportunity opp :[select id,Account.Sales_Hierarchy__r.Level_2_Territory_Name__c,
                                             Territory__c,ERP_for_Pricing__c,AccountId,Account.Sales_Hierarchy__c,
                                             CurrencyIsoCode
                                    from Opportunity 
                                    where id =: str_oppyId]){
                op = opp;
            }
            
            if(op != null){
                String str_rectypeId = Schema.SObjectType.Opportunity_Part__c.getRecordTypeInfosByName().get('Energy Parts').getRecordTypeId();
                list_oppyPartItem = (list<OppyPartDiscountItem>) JSON.deserialize(str_oppyPartJson, list<OppyPartDiscountItem>.class);
                system.debug('SaveOppyParts::'+list_oppyPartItem);
                String str_cbc4product = '';
                set<String> set_partIds = new set<String>();
                
                for(OppyPartDiscountItem partItem : list_oppyPartItem) {
                    partItem.oppyPart.CurrencyIsoCode = op.CurrencyIsoCode;
                    partItem.oppyPart.Lost_Reason__c = 'Other';
                    if(partItem.oppyPart.Quantity__c != null && partItem.oppyPart.Offered_Price__c != null ){ 
                        partItem.oppyPart.TotalPrice__c = partItem.oppyPart.Quantity__c * partItem.oppyPart.Offered_Price__c;
                    }
                    if(partItem.oppyPart.Id == null && (partItem.oppyPart.Status__c == null || partItem.oppyPart.Status__c == '') ){ partItem.oppyPart.Status__c = 'Pending';}
                    set_partIds.add(partItem.oppyPart.part__c);
                    if(partItem.oppyPart.Id != null){set_existOppyPartsIds.add(partItem.oppyPart.Id);}
                }
                
                for(Opportunity_Part__c opppart : [select id,Quantity__c,Part_Number_txt__c,Status__c,opportunity__r.Account.RecordTypeId,opportunity__r.ERP_for_Pricing__c 
                									from Opportunity_Part__c 
                                                    where id IN:set_existOppyPartsIds
                                                    And Part_Number_txt__c != null 
                                                    And isCloned__c = false]){
                                                    //And opportunity__r.Account.RecordTypeId != :Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId()]){
                    for(OppyPartDiscountItem partItem : list_oppyPartItem) {
                    	if(opppart.id == partItem.oppyPart.Id && partItem.oppyPart.Status__c != null && partItem.oppyPart.Status__c != ''){opppart.Status__c = partItem.oppyPart.Status__c;}
                        if(opppart.id == partItem.oppyPart.Id && opppart.Quantity__c != partItem.oppyPart.Quantity__c && (opppart.Status__c == 'Won' || opppart.Status__c == 'Pending' ) && !set_dummyPartNames.contains(opppart.Part_Number_txt__c) && !opppart.Part_Number_txt__c.toLowerCase().contains('proposal')){
                            if(!(opppart.opportunity__r.ERP_for_Pricing__c == 'SAP (except ANZPAC)' && opppart.opportunity__r.Account.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId())){
                            	set_needCalloutOppyPartsIds.add(opppart.Id);
                            }
                        }
                    }
                }
                
                system.debug('set_needCalloutOppyPartsIds::update::'+set_needCalloutOppyPartsIds);
                
                map<String,String> map_part_gpl = new map<String,String>();
                map<String, boolean> map_partId_isProposalPart = new map<String, boolean>();
                map<String, String> map_partId_currencyIsoCode = new map<String, String>();
                //Added by Buwen Guo 2017-12-14 from email:12/13 Issues point 2
                map<String,decimal> map_partId_MOQ = new map<String,decimal>();
                map<String,decimal> map_partId_LTDays = new map<String,decimal>();
                map<String,decimal> map_partId_PPQ = new map<String,decimal>();
                
                for(part__c p : [select id,Product_Hierarchy__c,Proposal_Part__c,CurrencyIsoCode,
                                        Min_Order_Qty__c,Lead_Time_Days__c,Primary_Pack_Qty__c 
                                    from part__c where id IN :set_partIds]){
                    map_part_gpl.put(p.Id,p.Product_Hierarchy__c);
                    map_partId_isProposalPart.put(p.Id,p.Proposal_Part__c);
                    map_partId_currencyIsoCode.put(p.Id,p.CurrencyIsoCode);
                    map_partId_MOQ.put(p.Id,p.Min_Order_Qty__c);
                    map_partId_LTDays.put(p.Id,p.Lead_Time_Days__c);
                    map_partId_PPQ.put(p.Id,p.Primary_Pack_Qty__c);
                }
                
                for(OppyPartDiscountItem partItem : list_oppyPartItem) {
                    partItem.oppyPart.RecordTypeId = (str_rectypeId == null ? null: str_rectypeId);
                    
                    if(partItem.oppyPart.part__c != null && map_part_gpl.containsKey(partItem.oppyPart.part__c)){
                        partItem.oppyPart.GPL__c = map_part_gpl.get(partItem.oppyPart.part__c);
                    }
                    
                    if(map_partId_isProposalPart.containsKey(partItem.oppyPart.part__c)){
                        partItem.oppyPart.Proposal_Part__c = map_partId_isProposalPart.get(partItem.oppyPart.part__c);
                    }
                    
                    //Added by Buwen Guo 2017-12-14 from email:12/13 Issues point 2
                    if(op.ERP_for_Pricing__c == 'ANZPAC'){
                        partItem.oppyPart.Min_Order_Qty__c          =  map_partId_MOQ.containsKey(partItem.oppyPart.Part__c)    ? map_partId_MOQ.get(partItem.oppyPart.Part__c)     :null;
                        partItem.oppyPart.Lead_Time__c              =  map_partId_LTDays.containsKey(partItem.oppyPart.Part__c) ? map_partId_LTDays.get(partItem.oppyPart.Part__c)  :null;
                        partItem.oppyPart.Primary_Pack_Quantity__c  =  map_partId_PPQ.containsKey(partItem.oppyPart.Part__c)    ? map_partId_PPQ.get(partItem.oppyPart.Part__c)     :null;
                    }
                    
                    //Added By Buwen Guo 2017-12-21 from email:Bugs 12/20 point 3
                    if(op.ERP_for_Pricing__c == 'SAP (except ANZPAC)'){
                        partItem.oppyPart.Primary_Pack_Quantity__c =  map_partId_PPQ.containsKey(partItem.oppyPart.Part__c) ? map_partId_PPQ.get(partItem.oppyPart.Part__c) :null;
                    }
                    list_oppyParts.add(partItem.oppyPart);
                    if(partItem.isThisCBC4 != null && partItem.isThisCBC4){
                        str_cbc4product = partItem.str_CBC4Product;
                    }
                    system.debug('isThisCBC4:::'+partItem.isThisCBC4);
                    system.debug('str_cbc4product:::'+partItem.str_CBC4Product);
                    system.debug('oppyPartToSave:::'+partItem.oppyPart);
                }
                
                //calcOppyPartItemFraction(list_oppyParts);
                OpportunityTrgHandler.isEditingOpportunityPartState = true;
                isEnergyPartManagementSave = true;
                
                if(!list_oppyParts.isEmpty()) {
                    upsert list_oppyParts;
                }
                
                system.debug('list_oppyParts::upsert::done');
                
                
                set<String> set_tempForCheckOppyPartsIds = new set<String>();
                
                for(Opportunity_Part__c opppart : list_oppyParts){
                    if(!set_existOppyPartsIds.contains(opppart.Id)){
                        set_tempForCheckOppyPartsIds.add(opppart.Id);
                    }
                }
                
                for(Opportunity_Part__c opppart : [select id,Part_Number_txt__c,Status__c,opportunity__r.Account.RecordTypeId,opportunity__r.ERP_for_Pricing__c  
                									from Opportunity_Part__c 
                                                    where id IN:set_tempForCheckOppyPartsIds
                                                    And Part_Number_txt__c != null 
                                                    And isCloned__c = false]){
                                                    //And opportunity__r.Account.RecordTypeId != :Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId()]){

                    if(!set_dummyPartNames.contains(opppart.Part_Number_txt__c) && !opppart.Part_Number_txt__c.toLowerCase().contains('proposal') && opppart.Status__c != 'Won'){
                        if(!(opppart.opportunity__r.ERP_for_Pricing__c == 'SAP (except ANZPAC)' && opppart.opportunity__r.Account.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId())){
                        	set_needCalloutOppyPartsIds.add(opppart.Id);
                        }
                    }   
                }
                
                system.debug('set_needCalloutOppyPartsIds::insert::'+set_needCalloutOppyPartsIds);
                
            
            
                if(str_cbc4product != null && str_cbc4product != ''){
                    op.Primary_Product_Hierarchy__c = str_cbc4product;
                    
                    String str_CBC4ToPmName = '';
                    for(Product_Hierarchy__c p : [select id,CBC2_Description__c,CBC4_Description__c from Product_Hierarchy__c where id =: str_cbc4product]){
                        op.Product_Line_Group__c = p.CBC2_Description__c;
                        system.debug('op.Product_Line_Group__c:'+op.Product_Line_Group__c);
                        str_CBC4ToPmName = p.CBC4_Description__c;
                    }
                    
                    if(str_CBC4ToPmName != null && str_CBC4ToPmName != ''){
                        String str_level2TerrName = op.Account.Sales_Hierarchy__r.Level_2_Territory_Name__c;
                        String str_ProdManagerId = '';
                        for(CBC4_to_PM__c pm: [select id,name,Level_2_Territory_Name__c,Product_Manager__c 
                                                from CBC4_to_PM__c 
                                                where name =: str_CBC4ToPmName 
                                                and (Level_2_Territory_Name__c =:str_level2TerrName or Level_2_Territory_Name__c = null)
                                                order by Level_2_Territory_Name__c asc NULLS LAST limit 1]){
                            str_ProdManagerId = pm.Product_Manager__c;
                            break;
                        }
                        if(str_ProdManagerId != null && str_ProdManagerId != ''){
                            op.Product_Manager__c = str_ProdManagerId;
                            system.debug('op.Product_Manager__c:'+op.Product_Manager__c);
                        }
                    }
                }
                if(op.Territory__c == null || op.ERP_for_Pricing__c == null ){
                    if(op.Territory__c == null && op.Account != null && op.Account.Sales_Hierarchy__c != null){
                        op.Territory__c = op.Account.Sales_Hierarchy__c;
                    }
                }
                update op;
                
                system.debug('op::update::done');
            }
            system.debug('limit::querys::'+Limits.getQueries());
            system.debug('limit::querys::'+Limits.getLimitQueries());
            system.debug('set_needCalloutOppyPartsIds::'+Json.serialize(set_needCalloutOppyPartsIds));
            return 'success:' + Json.serialize(set_needCalloutOppyPartsIds);
        }catch(Exception ex) {
            system.debug('Exception::'+ex.getMessage()+','+ex.getStackTraceString());

            isSaveHasError = true;

            ErrorLogging.Log(ex);
            String vStrError = '';
            vStrError += 'Error Type = ' + ex.getTypeName() + 
                ' Error Line = ' + ex.getLineNumber() + '' + 
                ' Error Stack = ' + ex.getStackTraceString() + 
                ' Error Message = ' + ex.getMessage();
            
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,                   
                                         SalesforceConstant.strError, '', '', '', '5','','','Exception', ex.getLineNumber() + '',ex.getStackTraceString());
            
            boolean isPassContactRoleCheck = checkContactRole(str_oppyId);
            if(isPassContactRoleCheck){
                return 'Error:'+ex.getMessage()+'. '+ex.getStackTraceString();
            }else{
                return 'Error: You must create a contact role on this opportunity before you can perform this operation.';
            }
        }
    } 
    
    
    
    /*------------------------------------------------------------
    Author:        Bin Yuan <bin.yuan@capgemini.com>
    Description:   method to upload oppyortunity part from .csv file
    Inputs:        
    Returns:       
    History
    2017-07-10     Bin Yuan <bin.yuan@capgemini.com> created
    ------------------------------------------------------------*/
    @RemoteAction
    global static string uploadOppyPartsRemoteAction(String str_oppyId,String str_oppyPartJson,boolean isNeedDeleteParts) {
        system.debug('uploadOppyPartsRemoteAction::'+str_oppyId);
        isSaveHasError = false;
        Set<String> set_dummyPartNames = new Set<String>{'Transportation Costs', 'Installation Costs', 'Training Costs','Freight Costs','Commission Costs','Distribution Costs','Other Costs'};
        set<String> set_needCalloutOppyPartsIds = new set<String>();
        
        list<OppyPartDiscountItem> list_oppyPartItem = new list<OppyPartDiscountItem>();
        list<Opportunity_Part__c> list_upsertOppyParts = new list<Opportunity_Part__c>();


        set<String> set_partName = new set<String>();

        map<String, Id> map_partName_partId = new map<String, Id>();
        map<String, String> map_partName_baseUMcode = new map<String, String>();
        

        try {
            System.debug('----upload----Limits.getCpuTime1--------'+Limits.getCpuTime());
            Opportunity op;
            for(Opportunity opp :[select id,Account.Sales_Hierarchy__r.Level_2_Territory_Name__c,
                                             Territory__c,ERP_for_Pricing__c,AccountId,Account.Sales_Hierarchy__c,
                                             CurrencyIsoCode
                                    from Opportunity 
                                    where id =: str_oppyId]){
                op = opp;
            }
            
            if(op != null){
                String str_rectypeId = Schema.SObjectType.Opportunity_Part__c.getRecordTypeInfosByName().get('Energy Parts').getRecordTypeId();
                list_oppyPartItem = (list<OppyPartDiscountItem>) JSON.deserialize(str_oppyPartJson, list<OppyPartDiscountItem>.class);
                for(OppyPartDiscountItem partItem : list_oppyPartItem) {
                    if(partItem.str_partName != null && partItem.str_partName != '') {
                        set_partName.add(partItem.str_partName);
                    }
                }
                
                set<String> set_partId2Add = new set<String>();
                map<String,decimal> map_partId_standardCosts = new map<String,decimal>();
                map<String, String> map_partId_currencyIsoCode = new map<String, String>();
                map<String, boolean> map_partId_isProposalPart = new map<String, boolean>();
                
                //Added by Buwen Guo 2017-12-14 from email:12/13 Issues point 2
                map<String,decimal> map_partId_MOQ = new map<String,decimal>();
                map<String,decimal> map_partId_LTDays = new map<String,decimal>();
                map<String,decimal> map_partId_Availability = new map<String,decimal>();
                map<String,decimal> map_partId_PPQ = new map<String,decimal>();
                map<String,String> map_part_gpl = new map<String,String>();
                
                for(Part__c p : [SELECT Id, Name,BASE_UM_CDE__c, UNIT_PACKAGING_TYPE_CDE__c,Curr_CS_75__c,CurrencyIsoCode,Proposal_Part__c,
                                        Min_Order_Qty__c,Lead_Time_Days__c,Primary_Pack_Qty__c,Product_Hierarchy__c
                                        //FROM Part__c WHERE IsActive__c = true and Product_Hierarchy__r.CBC1__c = '13005' and 
                                        FROM Part__c WHERE DISCONTINUANCE_STATUS_CDE__c != '1' and Product_Hierarchy__r.CBC1__c = '13005' and 
                                        Name IN: set_partName order by createdDate desc]) {
                    if(!map_partName_partId.containsKey(p.Name)) {
                        map_partName_partId.put(p.Name, p.Id);
                    }
                    if(!map_partName_baseUMcode.containsKey(p.Name)) {
                        map_partName_baseUMcode.put(p.Name, p.UNIT_PACKAGING_TYPE_CDE__c); //modified by Tangyong Li 2017-11-08
                    }
                    set_partId2Add.add(p.Id);
                    map_partId_standardCosts.put(p.Id, p.Curr_CS_75__c);        //Added by Buwen Guo 2017-12-04 from email: Issues 12/1 point 10
                    map_partId_currencyIsoCode.put(p.Id, p.CurrencyIsoCode);    //Added by Buwen Guo 2017-12-04 from email: Issues 12/1 point 10
                    map_partId_MOQ.put(p.Id, p.Min_Order_Qty__c);               //Added by Buwen Guo 2017-12-14 from email:12/13 Issues point 2,9
                    map_partId_LTDays.put(p.Id, p.Lead_Time_Days__c);
                    //map_partId_Availability.put(p.Id, p.Primary_Pack_Qty__c);
                    map_partId_PPQ.put(p.Id, p.Primary_Pack_Qty__c);
                    map_part_gpl.put(p.Id,p.Product_Hierarchy__c);
                    map_partId_isProposalPart.put(p.Id,p.Proposal_Part__c);
                }
                
                map<String, Opportunity_Part__c> map_partId_oppPart = new map<String, Opportunity_Part__c>();
                
                
                /*get related Energy_Price_Book_Entry__c cost*/
                map<String,decimal> map_partId_pricebookCosts = new map<String,decimal>();
                for(Energy_Price_Book_Entry__c qli : [select id,UnitPrice__c,Part__c,StandardPrice__c 
                                                from Energy_Price_Book_Entry__c 
                                                where Part__c IN :set_partId2Add ]){
                                                    
                    if(!map_partId_pricebookCosts.containsKey(qli.Part__c)){
                        //Modified by Buwen Guo 2017-12-01 from email:Issues 11/30 point 4
                        map_partId_pricebookCosts.put(qli.Part__c,qli.UnitPrice__c);
                    }
                }
                
                
                for(OppyPartDiscountItem partItem : list_oppyPartItem) {
                    Opportunity_Part__c oppyPart = partItem.oppyPart;
                    if(oppyPart.Id == null) {
                        if(map_partName_partId.containsKey(partItem.str_partName)) {
                            oppyPart.Part__c = map_partName_partId.get(partItem.str_partName);
                            oppyPart.Part_number__c = partItem.str_partName;
                            oppyPart.RecordTypeId = (str_rectypeId == null ? null : str_rectypeId );
                            if(map_partName_baseUMcode.get(partItem.str_partName) != null) {
                                oppyPart.Code_for_unit_of_measurement__c = map_partName_baseUMcode.get(partItem.str_partName);
                            } else {
                                oppyPart.Code_for_unit_of_measurement__c = 'PC';
                            }
                            oppyPart.Status__c = 'Pending';
                            oppyPart.Lost_Reason__c = 'Other';
                            oppyPart.CurrencyIsoCode = op.CurrencyIsoCode;
                            if(oppyPart.Part__c != null && map_part_gpl.containsKey(oppyPart.Part__c)){
                                oppyPart.GPL__c = map_part_gpl.get(oppyPart.Part__c);
                            }
                            
                            if(oppyPart.Part__c != null && map_partId_isProposalPart.containsKey(oppyPart.Part__c)){
                                oppyPart.Proposal_Part__c = map_partId_isProposalPart.get(oppyPart.Part__c);
                            }
                            
                            if(set_dummyPartNames.contains(partItem.str_partName)){
                                oppyPart.Sales_price__c = 0;
                                oppyPart.Offered_Price__c = 0;
                            } 
                            
                            
                            if(op.ERP_for_Pricing__c == 'ANZPAC'){
                                //Added by Buwen Guo 2017-12-04 from email: Issues 12/1 point 10
                                Decimal dec_standardCost = map_partId_standardCosts.containsKey(oppyPart.Part__c) ? map_partId_standardCosts.get(oppyPart.Part__c) :0;
                                String str_currency = map_partId_currencyIsoCode.containsKey(oppyPart.Part__c) ? map_partId_currencyIsoCode.get(oppyPart.Part__c) : 'USD';
                                oppyPart.Standard_Cost__c =  ClsAPLForecastUtil.transformIsoCode(dec_standardCost,str_currency,oppyPart.CurrencyIsoCode);
                                Decimal dec_custStdPrice = map_partId_pricebookCosts.containsKey(oppyPart.Part__c) ? map_partId_pricebookCosts.get(oppyPart.Part__c) :0;
                                oppyPart.Sales_Price__c =  dec_custStdPrice != 0 ? ClsAPLForecastUtil.transformIsoCode(dec_custStdPrice,'AUD',oppyPart.CurrencyIsoCode):0;
                                
                                //Added by Buwen Guo 2017-12-14 from email:12/13 Issues point 2
                                oppyPart.Min_Order_Qty__c =  map_partId_MOQ.containsKey(oppyPart.Part__c) ? map_partId_MOQ.get(oppyPart.Part__c) :null;
                                oppyPart.Lead_Time__c =  map_partId_LTDays.containsKey(oppyPart.Part__c) ? map_partId_LTDays.get(oppyPart.Part__c) :null;
                                //oppyPart.Availability__c =  map_partId_Availability.containsKey(oppyPart.Part__c) ? map_partId_Availability.get(oppyPart.Part__c) :0;
                                oppyPart.Primary_Pack_Quantity__c =  map_partId_PPQ.containsKey(oppyPart.Part__c) ? map_partId_PPQ.get(oppyPart.Part__c) :null;
                            }
                            
                            //Added By Buwen Guo 2017-12-21 from email:Bugs 12/20 point 3
                            if(op.ERP_for_Pricing__c == 'SAP (except ANZPAC)'){
                                oppyPart.Primary_Pack_Quantity__c =  map_partId_PPQ.containsKey(oppyPart.Part__c) ? map_partId_PPQ.get(oppyPart.Part__c) :null;
                            }
                            
                            if(oppyPart.Offered_Price__c == null){oppyPart.Offered_Price__c = 0;}
                            if(oppyPart.Quantity__c == null){oppyPart.Quantity__c = 0;}
                            oppyPart.NDR_Item_Price_Per__c = '1';
                            oppyPart.TotalPrice__c = oppyPart.Quantity__c * oppyPart.Offered_Price__c;
                            list_upsertOppyParts.add(oppyPart);
                        } 
                    }
                }
    
                system.debug('list_upsertOppyParts::'+list_upsertOppyParts);
                //calcOppyPartItemFraction(list_upsertOppyParts);
                
                OpportunityTrgHandler.isEditingOpportunityPartState = true;
                isEnergyPartManagementSave = true;
                System.debug('----upload----Limits.getCpuTime2--------'+Limits.getCpuTime());

                if(!list_upsertOppyParts.isEmpty()) {
                    upsert list_upsertOppyParts;
                }
                
                set<String> set_tempForCheckOppyPartsIds = new set<String>();
                
                for(Opportunity_Part__c opppart : list_upsertOppyParts){
                    set_tempForCheckOppyPartsIds.add(opppart.Id);
                }
                
                for(Opportunity_Part__c opppart : [select id,Part_Number_txt__c,Status__c,opportunity__r.Account.RecordTypeId,opportunity__r.ERP_for_Pricing__c 
                									from Opportunity_Part__c 
                                                    where id IN:set_tempForCheckOppyPartsIds
                                                    And Part_Number_txt__c != null 
                                                    And isCloned__c = false]){
                                                    //And opportunity__r.Account.RecordTypeId != :Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId()]){

                    if(!set_dummyPartNames.contains(opppart.Part_Number_txt__c) && !opppart.Part_Number_txt__c.toLowerCase().contains('proposal') && opppart.Status__c != 'Won' ){
                        if(!(opppart.opportunity__r.ERP_for_Pricing__c == 'SAP (except ANZPAC)' && opppart.opportunity__r.Account.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId())){
                        	set_needCalloutOppyPartsIds.add(opppart.Id);
                        }
                    }   
                }
                
                system.debug('set_needCalloutOppyPartsIds::upload::'+set_needCalloutOppyPartsIds);
    
                System.debug('----upload----Limits.getCpuTime3--------'+Limits.getCpuTime());
                if(op.Territory__c == null || op.ERP_for_Pricing__c == null ){
                    if(op.Territory__c == null && op.Account != null && op.Account.Sales_Hierarchy__c != null){
                        op.Territory__c = op.Account.Sales_Hierarchy__c;
                    }
                }
                update op;
                System.debug('----upload----Limits.getCpuTime4--------'+Limits.getCpuTime());
            
            }
            
            
            system.debug('set_needCalloutOppyPartsIds::'+Json.serialize(set_needCalloutOppyPartsIds));
            return 'success:' + Json.serialize(set_needCalloutOppyPartsIds);
        } catch(Exception ex) {
            isSaveHasError = true;
            system.debug('Exception::'+ex.getStackTraceString()+ex.getMessage());
            
            ErrorLogging.Log(ex);
            String vStrError = '';
            vStrError += 'Error Type = ' + ex.getTypeName() + 
                ' Error Line = ' + ex.getLineNumber() + '' + 
                ' Error Stack = ' + ex.getStackTraceString() + 
                ' Error Message = ' + ex.getMessage();
            
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,                   
                                         SalesforceConstant.strError, '', '', '', '5','','','Exception', ex.getLineNumber() + '',ex.getStackTraceString());
            
            boolean isPassContactRoleCheck = checkContactRole(str_oppyId);
            if(isPassContactRoleCheck){
                return 'Error:'+ex.getMessage()+'. '+ex.getStackTraceString();
            }else{
                return 'Error: You must create a contact role on this opportunity before you can perform this operation.';
            }
        }
    }
    
    @RemoteAction
    global static string deleteAllParts(String str_oppyId){
        system.debug('deleteAllParts::'+str_oppyId);
        try{
            list<Opportunity_Part__c> list_delOppyParts = [SELECT Id, Opportunity__c, Part__c, Part__r.Name, OppIdPartNumber__c, Status__c,
                                                                          Quantity__c, Offered_Price__c,Seq_No__c  
                                                                   FROM Opportunity_Part__c 
                                                                   WHERE Opportunity__c =: str_oppyId];
            if(!list_delOppyParts.isEmpty()) {
                delete list_delOppyParts;
            }
            return 'success';
        }catch(Exception ex) {
            isSaveHasError = true;
            system.debug('Exception::'+ex.getStackTraceString()+ex.getMessage());
            
            ErrorLogging.Log(ex);
            String vStrError = '';
            vStrError += 'Error Type = ' + ex.getTypeName() + 
                ' Error Line = ' + ex.getLineNumber() + '' + 
                ' Error Stack = ' + ex.getStackTraceString() + 
                ' Error Message = ' + ex.getMessage();
            
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,                   
                                         SalesforceConstant.strError, '', '', '', '5','','','Exception', ex.getLineNumber() + '',ex.getStackTraceString());
            
            boolean isPassContactRoleCheck = checkContactRole(str_oppyId);
            if(isPassContactRoleCheck){
                return 'Error:'+ex.getMessage()+'. '+ex.getStackTraceString();
            }else{
                return 'Error: You must create a contact role on this opportunity before you can perform this operation.';
            }
        }
    }
    
    
    public static boolean checkContactRole(String str_oppyId){
        Opportunity op;
        for(Opportunity opp :[select id,Probability from Opportunity where id =: str_oppyId]){
            op = opp;
        }
        if(op != null){
            list<OpportunityContactRole> list_ocr = new list<OpportunityContactRole>();
            for(OpportunityContactRole ocr : [select id,OpportunityId from OpportunityContactRole where OpportunityId =:str_oppyId]){
                list_ocr.add(ocr);
            }
            system.debug('checkContactRole::Probability::'+op.Probability+'::list_ocr::'+list_ocr.size());
            if(op.Probability >= 20 && list_ocr.size() < 1){
                return false;
            }else{
                return true;
            }
        }else{
            return true;
        }
    }
    
    /*------------------------------------------------------------
    Author:        Bin Yuan <bin.yuan@capgemini.com>
    Description:   method to upload oppyortunity part from .csv file
    Inputs:        
    Returns:       
    History
    2017-07-10     Bin Yuan <bin.yuan@capgemini.com> created
    ------------------------------------------------------------*/
    @RemoteAction
    global static string sendCallout(String str_oppyId,String str_oppyPartIdsJson) {
        system.debug('sendCallout::'+str_oppyId);
        system.debug('str_oppyPartIdsJson::'+str_oppyPartIdsJson);
        set<String> set_opartIds = (set<String>) JSON.deserialize(str_oppyPartIdsJson, set<String>.class);
        
        List<Opportunity_Part__c> list_oppyParts = new List<Opportunity_Part__c>();
        Opportunity temp = null;
        
        for(Opportunity tempoppy : [SELECT Id, Margin__c, ERP_For_Pricing__c, Approval_Status__c, Account.Source_System__c, 
                                        Account.RecordTypeId, Account.Recordtype.Name, AccountId, Account.Name, 
                                        Account.Distribution_Channel_Cde__c, Account_Number__c, Account.AccountNumber, 
                                        Account.Sales_Organization_ID__c, CurrencyIsoCode, Quote_Type__c, SAP_Quote_Type__c,
                                        createdDate 
                                    FROM Opportunity WHERE Id =: str_oppyId]) {
            temp = tempoppy;
        }
        
        for(Opportunity_Part__c oppyPart : [SELECT Id, Status__c, Opportunity__r.StageName, 
                                                Changed_Since_Quote_Integration__c, Offered_Price__c,
                                                Sales_Price__c, Standard_Cost__c, Energy_Quote_Line_Item__c, 
                                                Opportunity__c, Approval_Status__c, CurrencyISOCode,
                                                Part__r.Name, Quantity__c, NDR_Item_Number__c,
                                                Code_for_unit_of_measurement__c, part__r.Curr_CS_75__c, 
                                                part__r.CurrencyIsoCode, Seq_No__c, Name,
                                                List_Price__c, GPL__c,Part__c, Comments__c, Part__r.Proposal_Part__c,
                                                Max_Qty_in_Standard_lead_time__c, Lead_Time__c,
                                                NDR_Competitor_Name__c, NDR_Competitor_Part_Number__c, 
                                                Customer_Part_Number1__c, Customer_Part_Number__c,  
                                                NDR_Minimum_Order_Quantity__c, NDR_Unit_Package_Type__c,
                                                Part__r.Description__c, Primary_Pack_Quantity__c,
                                                Country_of_Origin__c, NDR_Delivery_Unit__c,
                                                NDR_Minimum_Delivery_Quantity__c,Opportunity__r.Approval_Status__c,
                                                Total_Price__c,Opportunity__r.RecordType.DeveloperName,
                                                Opportunity__r.ERP_For_Pricing__c,isCloned__c,Part_Number_txt__c,
                                                opportunity__r.createdDate 
                                                FROM Opportunity_Part__c
                                                WHERE Id IN: set_opartIds
                                                ]){
            list_oppyParts.add(oppyPart);
        }
        
        if(temp != null && list_oppyParts.size() > 0){
            InventoryAndPricing.getPrice(Json.serialize(temp),Json.serialize(list_oppyParts));
        }
        
        return 'success';
    }
    
    
    public void showErrorMessage(){
        isSaveHasError = true;
        displayUploadPopup = false;
        displayPopup = false;
        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, str_errorMessage));
    }
    
    public class OppIdPartNumber {
        public String oppyId {get; set;}
        public String partNum {get; set;}
        
        public OppIdPartNumber(){}
    }
    
    public class OppyPartDiscountItem {
        public String str_oppyPartId {get; set;}
        public String str_partNumber {get; set;}
        public String str_partName {get; set;}
        public String str_partDescription {get; set;}
        public Opportunity_Part__c oppyPart {get; set;}
        public Integer int_quality {get; set;}
        public decimal partListPrice {get; set;}
        public decimal partSalesPrice {get; set;}
        public decimal partOfferedPrice {get; set;}
        public Boolean isRequestedPriceLower {get; set;}
        public list<Energy_Quote_Line_Item__c> list_QuoteLineItems {get;set;}
        public Boolean hasQuoteLineItems {get; set;}
        public String str_RFQuoteNumber {get; set;}
        public String str_RFQuoteId {get; set;}
        public String str_RFQuoteLineItemId {get; set;}
        public String str_CBC4Description {get; set;}
        public String str_CBC4Product {get; set;}
        public String str_OpportunityCBC4 {get; set;}
        public Boolean isThisCBC4 {get; set;}
        public String str_itemNumber {get;set;}
        public Boolean isDOAAproved {get; set;}
        public list<Inventory__c> list_inventories {get;set;}
        public Boolean isDummyPart {get; set;}
        public Boolean isDisplayComment {get; set;}
        public decimal dec_priceBookCost {get; set;}
        public Boolean isDelete {get; set;}
        public Boolean isCostPart {get; set;}
        public Boolean isProposalPart {get; set;}
    }
    
    public class OppyPartDiscountItemWrapper implements Comparable {
        public OppyPartDiscountItem oppyPartItem;
        
        public OppyPartDiscountItemWrapper(OppyPartDiscountItem p) {
            oppyPartItem = p;
        }
        
        public Integer compareTo(Object compareTo) {
            OppyPartDiscountItemWrapper compareToOppy = (OppyPartDiscountItemWrapper)compareTo;
            
            Integer returnValue = 0;
            /*
            if (oppyPartItem.str_partName > compareToOppy.oppyPartItem.str_partName) {
                returnValue = 1;
            } else if (oppyPartItem.str_partName < compareToOppy.oppyPartItem.str_partName) {
                returnValue = -1;
            }
            */
            if (oppyPartItem.oppyPart.Seq_No__c > compareToOppy.oppyPartItem.oppyPart.Seq_No__c) {
                returnValue = 1;
            } else if (oppyPartItem.oppyPart.Seq_No__c < compareToOppy.oppyPartItem.oppyPart.Seq_No__c) {
                returnValue = -1;
            }
            return returnValue;       
        }
    }
    
    public class innerClassForAdd {
        public String partId {get; set;}
        public String quantity {get; set;}
        public String partName {get; set;}
        
        public innerClassForAdd (){}
    }
    
}