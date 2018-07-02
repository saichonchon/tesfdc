/** 
* Extension class for page: ExtCreateQuoteForOppy
*
@ author    Buwen Guo
@ created   2017-10-11
@ since     38.0

@ changelog
* 2017-10-11 Buwen Guo <buwen.guo@capgemini.com>
* - Created
*/
public without sharing class ExtCreateQuoteForOppy {
    private final ApexPages.standardController stdCtrl; 
    public boolean isAllowCreateQuote               {get; set;}
    public boolean isHasError                       {get; set;}
    public boolean isValidateSuccess                {get; set;}
    public set<String> set_validateFailPartNames    {get; set;}
    public String str_createResult                  {get; set;}
    public Opportunity oppy                         {get; set;}
    public Opportunity tempOppyForPage              {get; set;}
    public Static boolean isFromCreateButtonPage = false;
    public Static boolean isFromCreateQuote = false;
    public static Energy_Control__c isNotAllowRestCallout = null;
    
    
    
    public ExtCreateQuoteForOppy(ApexPages.standardController stdCtrl) {
        this.stdCtrl = stdCtrl;
        this.isAllowCreateQuote = true;    
        this.isHasError = false;
        oppy = (Opportunity) stdCtrl.getRecord();
        for(Opportunity op :[select Id,Customer_Contact_Name__c,End_Customer__c,Quote_Type__c,Approval_Status__c,
                                    Language_of_Quote__c,Days_prices_valid__c,Valid_From__c,Contract_start_date__c,
                                    Contract_Finish_Date__c,ERP_For_Pricing__c,SAP_Quote_Type__c,StageName,NDR_Quote_document_number__c,AccountId 
                            from Opportunity where id=:oppy.Id]){
            oppy = op;
        }
        
        init();
    }
    
    /** 
    * method to init the page.
    *
    @ author    Buwen Guo
    @ created   2017-10-11
    @ since     38.0
    
    @ changelog
    * 2017-10-11 Buwen Guo <buwen.guo@capgemini.com>
    * - Created
    */
    public void init() {
        try{
        	//Added by Buwen Guo 2018-03-13 requirement from email:Github changes to take Quote Create Out
        	if(oppy.ERP_For_Pricing__c == 'SAP (except ANZPAC)') {
                isAllowCreateQuote = false;
                //Message:SAP integration for passing Quote information to SAP is not yet available.  Quote information must be manually entered in SAP.
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, system.label.CreateQuote_SapMessage));
                return;
            }
            if(oppy.NDR_Quote_document_number__c != null && oppy.ERP_For_Pricing__c == 'SAP (except ANZPAC)') {
                isAllowCreateQuote = false;
                //Message:This opportunity already has a quote.Quote Revision in Salesforce isn\'t currently supported.
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, system.label.CreateQuote_SapMessage2));
                return;
            }
            Integer totalPartsCounter = 0;
            Integer hasQuoteLineItemPartsCounter = 0;
            for(Opportunity_Part__c part :[select id,Energy_Quote_Line_Item__c,opportunity__c from Opportunity_Part__c where opportunity__c =: oppy.Id]){
                totalPartsCounter = totalPartsCounter + 1;
                if(part.Energy_Quote_Line_Item__c != null){
                    hasQuoteLineItemPartsCounter = hasQuoteLineItemPartsCounter + 1;
                }
            }
            system.debug('totalPartsCounter::'+totalPartsCounter);
            system.debug('hasQuoteLineItemPartsCounter::'+hasQuoteLineItemPartsCounter);
            if(totalPartsCounter == 0 || hasQuoteLineItemPartsCounter != totalPartsCounter){
                //if((oppy.Approval_Status__c != 'Approval Required' || oppy.SAP_Quote_Type__c != 'Small Quote') && oppy.Approval_Status__c != 'Approved' && oppy.Approval_Status__c != null && oppy.Approval_Status__c != '' && oppy.Approval_Status__c != 'Approval Not Needed'){
                if(!(oppy.ERP_For_Pricing__c == 'SAP (except ANZPAC)' && oppy.Approval_Status__c == 'Approval Required' && oppy.SAP_Quote_Type__c == 'Small Quote') && oppy.Approval_Status__c != 'Approved' && oppy.Approval_Status__c != null && oppy.Approval_Status__c != '' && oppy.Approval_Status__c != 'Approval Not Needed'){
                    this.isAllowCreateQuote = false;  
                    //Message:Unapproved opportunity is not allowed to create quote.
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, system.label.CreateQuote_UnapprovedMessage));
                }
            }
            
            //init opportunity fields value in page.
            this.tempOppyForPage = new Opportunity();
            /*
            String str_recTypeId = '';
            for(RecordType rt : [select Id,developerName from recordtype where SobjectType = 'Opportunity' and developerName = 'Energy_Sales']){
                str_recTypeId = rt.Id;
                this.tempOppyForPage.recordtypeId = str_recTypeId;
            }*/
            Id str_recTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Energy - Sales').getRecordTypeId();
            this.tempOppyForPage.recordtypeId = str_recTypeId;
            
            this.tempOppyForPage.AccountId = oppy.AccountId;
            this.tempOppyForPage.Customer_Contact_Name__c = oppy.Customer_Contact_Name__c;
            this.tempOppyForPage.End_Customer__c = oppy.End_Customer__c;
            this.tempOppyForPage.Quote_Type__c = oppy.Quote_Type__c;
            this.tempOppyForPage.Valid_From__c = oppy.Valid_From__c;
            this.tempOppyForPage.Days_prices_valid__c = oppy.Days_prices_valid__c;
            this.tempOppyForPage.Contract_start_date__c = oppy.Contract_start_date__c;
            this.tempOppyForPage.Contract_Finish_Date__c = oppy.Contract_Finish_Date__c;
            
            //Set Language Of Quote field init value.
            if(oppy.Language_of_Quote__c != null && oppy.Language_of_Quote__c != ''){
                this.tempOppyForPage.Language_of_Quote__c = oppy.Language_of_Quote__c;
            }else{
                User currUser = [select id,Quote_Language__c from user where id=: UserInfo.getUserId()];
                if(currUser.Quote_Language__c != null && currUser.Quote_Language__c != ''){
                    this.tempOppyForPage.Language_of_Quote__c = currUser.Quote_Language__c;
                    oppy.Language_of_Quote__c = currUser.Quote_Language__c;
                }
            }
            
            
            
        } catch (Exception e) {
            system.debug('Exception::init::'+e.getMessage()+','+e.getStackTraceString());
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, e.getMessage()));
            ErrorLogging.Log(e);
        }
    }
    
    /** 
    * method to validate whether create quote.
    *
    @ author    Buwen Guo
    @ created   2017-10-17
    @ since     38.0
    
    @ changelog
    * 2017-10-17 Buwen Guo <buwen.guo@capgemini.com>
    * - Created
    */
    public void validator() {
        system.debug('validator::begin::');
        system.debug('oppy.Quote_Type__c::'+oppy.Quote_Type__c);
        set_validateFailPartNames = new set<String>();
        
        if(oppy.Quote_Type__c == 'Meet Competitor Price'){
            Integer totalPartsCounter = 0;
            Integer hasCompetitorNameCounter = 0;
            Integer hasCompetitorPriceCounter = 0;
            Integer hasCompetitorPartNumberCounter = 0;  //added by yuan yao 2017-11-1
            for(Opportunity_Part__c part :[select id,part__r.name,NDR_Competitor_Name__c,Competitor_Price__c,NDR_Competitor_Part_Number__c from Opportunity_Part__c where opportunity__c =: oppy.Id]){
                totalPartsCounter = totalPartsCounter + 1;
                
                //NDR_Competitor_Name__c check
                if(part.NDR_Competitor_Name__c != null && part.NDR_Competitor_Name__c != ''){
                    hasCompetitorNameCounter = hasCompetitorNameCounter + 1;
                }else{
                    if(set_validateFailPartNames.size() < 1){
                        set_validateFailPartNames.add(part.part__r.name);
                    }
                }
                
                //Competitor_Price__c check
                if(part.Competitor_Price__c != null){
                    hasCompetitorPriceCounter = hasCompetitorPriceCounter + 1;
                }else{
                    if(set_validateFailPartNames.size() < 1){
                        set_validateFailPartNames.add(part.part__r.name);
                    }
                }
                //added by yuan yao 2017-11-1
                //NDR_Competitor_Part_Number__c check
                if(part.NDR_Competitor_Part_Number__c != null){
                    hasCompetitorPartNumberCounter = hasCompetitorPartNumberCounter + 1;
                }else{
                    if(set_validateFailPartNames.size() < 1){
                        set_validateFailPartNames.add(part.part__r.name);
                    }
                }
            }
            system.debug('totalPartsCounter::'+totalPartsCounter);
            system.debug('hasCompetitorNameCounter::'+hasCompetitorNameCounter);
            system.debug('hasCompetitorPriceCounter::'+hasCompetitorPriceCounter);
            system.debug('hasCompetitorPartNumberCounter::'+hasCompetitorPartNumberCounter);
            
            if(totalPartsCounter == 0){
                this.isValidateSuccess = true;
                createQuote();
            }else if(totalPartsCounter == hasCompetitorNameCounter && totalPartsCounter == hasCompetitorPriceCounter 
                     && totalPartsCounter == hasCompetitorPartNumberCounter){
                this.isValidateSuccess = true;
                createQuote();
            }else{
                this.isValidateSuccess = false;
            }
            
        }else{
            this.isValidateSuccess = true;
            createQuote();
        }
    }
    /** 
    * method to create quote pdf.
    *
    @ author    Yuan Yao
    @ created   2017-11-03
    @ since     38.0
    
    @ changelog
    * 2017-11-03 Yuan Yao <yuan.yao@capgemini.com>
    * - Created
    */
    public void saveQuotePdf(){
        if(this.str_createResult != null && this.str_createResult.indexOf('error') == -1){
            CreateQuoteBasedOnOpp.savePdf(this.str_createResult);
        } 
    }
    /** 
    * method to create quote.
    *
    @ author    Buwen Guo
    @ created   2017-10-11
    @ since     38.0
    
    @ changelog
    * 2017-10-11 Buwen Guo <buwen.guo@capgemini.com>
    * - Created
    */
    public void createQuote() {
        try{
            system.debug('createQuote::begin::');
            system.debug('Language_of_Quote__c::'+oppy.Language_of_Quote__c);
            system.debug('Valid_From__c::'+oppy.Valid_From__c);
            system.debug('Days_prices_valid__c::'+oppy.Days_prices_valid__c);
            
            isFromCreateQuote = true;
            /*
            this.oppy.Customer_Contact_Name__c = this.tempOppyForPage.Customer_Contact_Name__c;
            this.oppy.End_Customer__c = this.tempOppyForPage.End_Customer__c;
            this.oppy.Quote_Type__c = this.tempOppyForPage.Quote_Type__c;
            this.oppy.Language_of_Quote__c = this.tempOppyForPage.Language_of_Quote__c;
            this.oppy.Valid_From__c = this.tempOppyForPage.Valid_From__c;
            this.oppy.Days_prices_valid__c = this.tempOppyForPage.Days_prices_valid__c;
            this.oppy.Contract_start_date__c = this.tempOppyForPage.Contract_start_date__c;
            this.oppy.Contract_Finish_Date__c = this.tempOppyForPage.Contract_Finish_Date__c;
            */
            
            //Added by Buwen Guo 2017-12-01  from email:Issues 11/30 point 13
            if(oppy.StageName == 'Initiation' || oppy.StageName == 'Technical Review'){
                oppy.StageName = 'Quotation';
            }
            
            //Added by Buwen Guo 2017-12-08  from email:A lower priority item for now: SAP Quote Revision point 1
            this.oppy.Quote_Created_Time__c = datetime.now();
            //added by Tangyong Li 2018-03-28
            if(oppy.Valid_From__c != null){
            	if(String.isNotBlank(oppy.Days_prices_valid__c)){
            		Integer validDays;
            		if(oppy.Days_prices_valid__c == '30 Days') {
            			validDays = 30;
            		} else if(oppy.Days_prices_valid__c == '60 Days') {
            			validDays = 60;
            		} else if(oppy.Days_prices_valid__c == '90 Days') {
            			validDays = 90;
            		} else if(oppy.Days_prices_valid__c == '120 Days') {
            			validDays = 120;
            		} else if(oppy.Days_prices_valid__c == '180 Days') {
            			validDays = 180;
            		} else if(oppy.Days_prices_valid__c == '1 year') {
            			validDays = 365;
            		} else if(oppy.Days_prices_valid__c == '2 years') {
            			validDays = 730;
            		} else if(oppy.Days_prices_valid__c == '3 years') {
            			validDays = 1096;
            		} else if(oppy.Days_prices_valid__c == '4 years') {
            			validDays = 1461;
            		} else if(oppy.Days_prices_valid__c == '5 years') {
            			validDays = 1826;
            		} else {
            			validDays = 0;
            		}
            		oppy.NDR_Quote_Expiration_Date__c = oppy.Valid_From__c.addDays(validDays);
            	}else{
            		oppy.NDR_Quote_Expiration_Date__c = oppy.Valid_From__c;
            	}
            }//end
            update oppy;
            
            User currUser = [select id,Quote_Language__c from user where id=: UserInfo.getUserId()];
            //Modified by Yiming Shen at 2018-02-23 
            //currUser.Quote_Language__c = this.tempOppyForPage.Language_of_Quote__c;
            if(currUser.Quote_Language__c != this.oppy.Language_of_Quote__c){
	            currUser.Quote_Language__c = this.oppy.Language_of_Quote__c;
	            update currUser;
            }
            
            //modified by Tangyong Li 2018-03-23: 'One Time Tender' -> 'Blanket/Tender'
            //Added by Buwen Guo 2017-11-13,requirement from email:I know you're getting bored over there (point 3)
            //if(oppy.ERP_For_Pricing__c == 'SAP (except ANZPAC)' && (oppy.SAP_Quote_Type__c == 'Small Quote' || oppy.SAP_Quote_Type__c == 'One Time Tender')){
            if(oppy.ERP_For_Pricing__c == 'SAP (except ANZPAC)' && (oppy.SAP_Quote_Type__c == 'Small Quote' || oppy.SAP_Quote_Type__c == 'Blanket/Tender')){
                String str_result = 'success';
                //Added by Buwen Guo 2018-03-13 requirement from email:Github changes to take Quote Create Out
                //callSAPtoCreateQuote(oppy.Id);
                this.isHasError = false;
                this.str_createResult = ''+oppy.Id;
                /*if(str_result != null && str_result.indexOf('error') == -1){
                    this.isHasError = false;
                    this.str_createResult = ''+oppy.Id;
                }else{
                    this.isHasError = true;
                    this.str_createResult = ''+oppy.Id;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, str_result));
                }*/
            }else{
                isFromCreateButtonPage = true;
                String str_result = CreateQuoteBasedOnOpp.createQuote(oppy.Id);
                system.debug('createQuote::str_result::'+str_result);
                
                if(str_result != null && str_result.indexOf('error') == -1){
                    this.isHasError = false;
                    this.str_createResult = str_result;
                }else{
                    this.isHasError = true;
                    this.str_createResult = str_result;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, str_result));
                }   
            }
            
        } catch (Exception e) {
            system.debug('Exception::createQuote::'+e.getMessage()+','+e.getStackTraceString());
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, e.getMessage()));
            ErrorLogging.Log(e);
        }
    }

    public static String handleNull(String s) {
        return s == null ? '' : s;
    }
    
    public static String handleNull(String s, integer maxChars) {
        if (s == null) s = '';
        return (s.length() < maxChars) ? s : s.subString(maxChars);
    }

    public static string getDateAs8CharString(Date d) {
        if (d == null)
            return '';
        String result = '' + d.year();

        if (d.month() < 10) {
            result += '0';
        }
        result += d.month();

        if (d.day() < 10) {
            result += '0';
        }

        return result + d.day();
    }
    
    public static string getAccountNumber(String input) {
        //Added by Buwen Guo 2018-02-08 to Avoid NullPointerException from input.indexof
        if(input == null){
            return '';
        }
        if (input.contains(':') && input.indexOf(':') < input.length()-1)
            input = input.substring(input.indexOf(':')+1);
        return handleNull(input, 10);
    }
    
    public static Date getValidToDate(Date startDate,String str_validFor) {
        if(startDate == null || str_validFor == null || str_validFor == ''){
            return null;
        }
        if(str_validFor == '30 Days'){
        	return startDate.addDays(30);
        }else if(str_validFor == '60 Days'){
        	return startDate.addDays(60);
        }else if(str_validFor == '90 Days'){
        	return startDate.addDays(90);
        }else if(str_validFor == '120 Days'){
        	return startDate.addDays(120);
        }else if(str_validFor == '180 Days'){
        	return startDate.addDays(180);
        }else if(str_validFor == '1 year'){
        	return startDate.addYears(1);
        }else if(str_validFor == '2 years'){
        	return startDate.addYears(2);
        }else if(str_validFor == '3 years'){
        	return startDate.addYears(3);
        }else if(str_validFor == '4 years'){
        	return startDate.addYears(4);
        }else if(str_validFor == '5 years'){
        	return startDate.addYears(5);
        }else{
        	return null;
        }
    }
    
    /*------------------------------------------------------------
    Author:        Buwen Guo <buwen.guo@capgemini.com>
    Description:   Function to call webservice to create quote for SAP.
    Inputs:        
    Returns:       
    History
    2017-11-13     Buwen Guo <buwen.guo@capgemini.com> created
    ------------------------------------------------------------*/
    @future(callout = true)
    public static void callSAPtoCreateQuote(String str_oppyId){
        try {
            system.debug('callSAPtoCreateQuote::str_oppyId::'+str_oppyId);
            
            //Added by Buwen Guo 2017-12-14 from email:12/13 Issues point 1
            if(isNotAllowRestCallout == null){
                isNotAllowRestCallout = [select id,Disable_Integrations__c from Energy_Control__c where name = 'Energy Control' limit 1];
                system.debug('isNotAllowRestCallout::'+isNotAllowRestCallout);
                if(isNotAllowRestCallout == null){
                    return;
                }
            }
            if(isNotAllowRestCallout.Disable_Integrations__c == true){
                return;
            }
        
            WrapperHeader quoteCreateRequest = new WrapperHeader();
            List<WrapperItemsIn> list_parts = new List<WrapperItemsIn>();
            List<WrapperPricingIn> list_pricing = new List<WrapperPricingIn>();
            List<WrapperPartnersIn> list_partners = new List<WrapperPartnersIn>();
            
            Opportunity curr_oppy = new Opportunity();
            List<Opportunity_Part__c> list_oppParts = new List<Opportunity_Part__c>();
            
            set<Id> set_acctIds = new set<Id>();
            
            for(Opportunity op : [select id,Account_Incoterms_Details__c,Account.AccountNumber,Account.Distribution_Channel_Cde__c,
                                                Contract_start_date__c,Contract_finish_date__c,Customer_Reference_Number__c,
                                                name,CurrencyIsoCode,Customer_Contact_Name__r.name,Customer_Contact_Name__r.email,
                                                Customer_Contact_Name__r.phone,Customer_Contact_Name__r.fax,NDR_Customer_Comments__c,
                                                owner.email,owner.name,owner.phone,SAP_Quote_Type__c,Quote_Type__c,Account.Sales_Organization_ID__c,
                                                //Add the sold to account Infomation
                                                Account.name,Account.billingStreet,Account.billingCity,Account.billingCountry,Account.billingPostalCode,
                                                //Add the end customer account Infomation
                                                End_Customer__r.AccountNumber,End_Customer__r.name,End_Customer__r.billingStreet,
                                                End_Customer__r.billingCity,End_Customer__r.billingCountry,End_Customer__r.billingPostalCode,
                                                //added by Tangyong Li 2018-02-08
                                                Override_Incoterms_Code__c,Override_Payment_Terms_Code__c,Override_Incoterms_Details__c,
                                                account.Incoterms_CDE__c, account.Payment_terms_CDE__c, NDR_Ship_to_Acct_No__c,
                                                Days_prices_valid__c,Valid_From__c
                                                from opportunity where id = :str_oppyId]){
                curr_oppy = op; 
                set_acctIds.add(op.End_Customer__c);                            
            }
            
            for(Opportunity_Part__c oppPart : [select id,NDR_Item_Number__c,part__r.name,Quantity__c,Code_for_unit_of_measurement__c,
                                                        NDR_Competitor_Part_Number__c,NDR_Competitor_Name__c,Offered_price__c,Competitor_Price__c,
                                                        Opportunity__r.CurrencyIsoCode,Sales_Price__c,NDR_Item_Price_Per__c, comments__c
                                                    from Opportunity_Part__c where opportunity__c = :str_oppyId and Status__c != 'No Bid' ]){//Modified by Buwen Guo 2017-12-15 from email:12/14 fixes... let's discuss point 3
                
                
                //Added by Buwen Guo 2017-12-07 from email:12/6 Part Mgmt Issues point 11
                oppPart.Quantity__c         = (oppPart.Quantity__c          == null)? 0 : oppPart.Quantity__c;
                oppPart.Offered_price__c    = (oppPart.Offered_price__c     == null)? 0 : oppPart.Offered_price__c;
                oppPart.Competitor_Price__c = (oppPart.Competitor_Price__c  == null)? 0 : oppPart.Competitor_Price__c;
                oppPart.Sales_Price__c      = (oppPart.Sales_Price__c       == null)? 0 : oppPart.Sales_Price__c;
                
                list_oppParts.add(oppPart);
            }
            
            //Added by Tangyong Li 2018-02-09
            map<String, Opportunity_Partner__c> map_partnerRole_oppyPartner = new map<String, Opportunity_Partner__c>();
	        for(Opportunity_Partner__c partner : [SELECT Id, Opportunity__c, Partner_Role__c, Account__c, Account__r.Name, 
	        											 Account__r.BillingStreet, Account__r.BillingCity, Account__r.BillingCountry, 
	        											 Account__r.BillingPostalCode, Account__r.AccountNumber 
	        									  FROM Opportunity_Partner__c 
	        									  WHERE Opportunity__c =: str_oppyId]) {
	            if(partner.Partner_Role__c == 'POS' && !map_partnerRole_oppyPartner.containsKey('POS')) {
	                map_partnerRole_oppyPartner.put('POS', partner);
	                set_acctIds.add(partner.Account__c);
	            } else if(partner.Partner_Role__c == 'Ship To' && !map_partnerRole_oppyPartner.containsKey('Ship To')) {
	                map_partnerRole_oppyPartner.put('Ship To', partner);
	                set_acctIds.add(partner.Account__c);
	            }
	        }
	        
	        map<Id, Account> map_acctId_accts = new map<Id, Account>([SELECT Id, Name, BillingStreet, BillingCity, BillingCountry, BillingPostalCode, AccountNumber FROM Account WHERE Id IN: set_acctIds]);
            
            if(curr_oppy != null && curr_oppy.id != null){
                quoteCreateRequest.sfdcOpportunityId      = curr_oppy.id;

                quoteCreateRequest.soldToAccountNumber      = getAccountNumber(curr_oppy.account.accountNumber);
                
                //modified by Tangyong Li 2018-02-08
                //quoteCreateRequest.shipToAccountNumber      = getAccountNumber(curr_oppy.account.accountNumber);
                if(map_partnerRole_oppyPartner.containsKey('Ship To')) {
                    quoteCreateRequest.shipToAccountNumber = getAccountNumber(curr_oppy.NDR_Ship_to_Acct_No__c);
                } else {
                    quoteCreateRequest.shipToAccountNumber      = getAccountNumber(curr_oppy.account.accountNumber);
                }
                
                quoteCreateRequest.distributionChannelCode      = handleNull(curr_oppy.Account.Distribution_Channel_Cde__c);
                
                //Modified by Buwen Guo 2018-02-22 requirement from email:Let's change what we're sending to the Create Quote webservice
                //quoteCreateRequest.validFromDate       = getDateAs8CharString(curr_oppy.Contract_start_date__c);
				//quoteCreateRequest.validToDate         = getDateAs8CharString(curr_oppy.Contract_finish_date__c);
                Date date_endDate = getValidToDate(curr_oppy.Valid_From__c,curr_oppy.Days_prices_valid__c);
                quoteCreateRequest.validFromDate       = getDateAs8CharString(curr_oppy.Valid_From__c);
				quoteCreateRequest.validToDate         = getDateAs8CharString(date_endDate);
                
                quoteCreateRequest.customerReferenceNumber      = handleNull(curr_oppy.Customer_Reference_Number__c);
                quoteCreateRequest.project          = handleNull(curr_oppy.name);
                quoteCreateRequest.requestCurrency   = curr_oppy.CurrencyIsoCode;
                quoteCreateRequest.contactName     = handleNull(curr_oppy.Customer_Contact_Name__r.name);
                quoteCreateRequest.contactEmail    = handleNull(curr_oppy.Customer_Contact_Name__r.email);
                quoteCreateRequest.contactPhone    = handleNull(curr_oppy.Customer_Contact_Name__r.phone);
                quoteCreateRequest.contactFax      = handleNull(curr_oppy.Customer_Contact_Name__r.fax);
                quoteCreateRequest.customerComments    = handleNull(curr_oppy.NDR_Customer_Comments__c);
                quoteCreateRequest.creatorEmail    = handleNull(curr_oppy.owner.email);
                quoteCreateRequest.creatorName     = handleNull(curr_oppy.owner.name);
                quoteCreateRequest.creatorPhone    = handleNull(curr_oppy.owner.phone);
                quoteCreateRequest.salesOrg        = handleNull(curr_oppy.account.Sales_Organization_ID__c);

                SAP_Instance__c SapInstance = [select Id,Name from SAP_Instance__c LIMIT 1];

                quoteCreateRequest.sapInstance = SapInstance.Name;
                //quoteCreateRequest.itemin_cnt = 0;
                //quoteCreateRequest.pricingin_cnt = 0;
                //quoteCreateRequest.partnersin_cnt = 0;
                
                //added by Tangyong Li 2018-02-08
                quoteCreateRequest.incoTermsCode = curr_Oppy.Override_Incoterms_Code__c != null ? curr_oppy.Override_Incoterms_Code__c
                                                                                              : handleNull(curr_Oppy.account.Incoterms_CDE__c);
                quoteCreateRequest.paymentTermsCode = curr_oppy.Override_Payment_Terms_Code__c != null ? curr_oppy.Override_Payment_Terms_Code__c
                                                                                                : handleNull(curr_Oppy.account.Payment_terms_CDE__c);
                quoteCreateRequest.incoTermsDetails = curr_Oppy.Override_Incoterms_Details__c  != null ? curr_oppy.Override_Incoterms_Details__c
                                                                          : handleNull(curr_oppy.Account_Incoterms_Details__c);
                
                /*
                //Add Partners In(sold to acct)
                WrapperPartnersIn partner_soldToAcct = new WrapperPartnersIn();
                partner_soldToAcct.partnerAccountNumber  = handleNull(curr_oppy.Account.AccountNumber, 10);
                partner_soldToAcct.partnerType = 'AG';
                partner_soldToAcct.partnername        = handleNull(curr_oppy.Account.name);
                partner_soldToAcct.street       = handleNull(curr_oppy.Account.billingStreet, 35);
                partner_soldToAcct.city         = handleNull(curr_oppy.Account.billingCity);
                partner_soldToAcct.country      = handleNull(curr_oppy.Account.billingCountry);
                partner_soldToAcct.postalCode   = handleNull(curr_oppy.Account.billingPostalCode);
                partner_soldToAcct.salesEngineerName      = '';
                partner_soldToAcct.salesEngineerEmail     = '';
                list_partners.add(partner_soldToAcct);
                */
                
                //modified by Tangyong Li 2018-02-08
                /*
                //Add Partners In(end customer acct)
                WrapperPartnersIn partner_endCustomerAcct = new WrapperPartnersIn();
                
                partner_endCustomerAcct.partnerAccountNumber  = getAccountNumber(curr_oppy.End_Customer__r.AccountNumber);
                partner_endCustomerAcct.partnerType  = 'ZU';
                partner_endCustomerAcct.partnername  = handleNull(curr_oppy.End_Customer__r.name);
                partner_endCustomerAcct.street       = handleNull(curr_oppy.End_Customer__r.billingStreet);
                if(partner_endCustomerAcct.street.length() > 34){
                    partner_endCustomerAcct.street   = handleNull(partner_endCustomerAcct.street, 35);
                }
                partner_endCustomerAcct.city         = handleNull(curr_oppy.End_Customer__r.billingCity);
                partner_endCustomerAcct.country      = handleNull(curr_oppy.End_Customer__r.billingCountry);
                partner_endCustomerAcct.postalCode   = handleNull(curr_oppy.End_Customer__r.billingPostalCode);
                
                partner_endCustomerAcct.salesEngineerName      = '';
                partner_endCustomerAcct.salesEngineerEmail     = '';
                */
                WrapperPartnersIn partner_acct;
                if(map_partnerRole_oppyPartner.containsKey('POS')) { //'POS' partner.account
                	partner_acct = generateWrapperPartnersIn(map_partnerRole_oppyPartner.get('POS'), map_acctId_accts.get(map_partnerRole_oppyPartner.get('POS').Account__c));
                } else { //end customer acct
                	partner_acct = generateWrapperPartnersIn(null, map_acctId_accts.get(curr_oppy.End_Customer__c));
                }
                list_partners.add(partner_acct);
            }
            
            
            for(Opportunity_Part__c oppyPart : list_oppParts){
                
                //Do not add lineItem prices if the currStdPrice is the same as the TargetPrice
                //Added by Buwen Guo 2017-11-30 from email: Issues 11/29
                    
                    //Add Items In 
                    WrapperItemsIn part = new WrapperItemsIn();
                    //part.SFDC_Id       = oppyPart.id;
                    part.lineItemNumber        = handleNull(oppyPart.NDR_Item_Number__c ,6);
                    part.partNumber        = handleNull(oppyPart.part__r.name);
                    part.customerPartNumber     = '';
                    part.requestQty         = '' + oppyPart.Quantity__c;
                    part.uom             = handleNull(oppyPart.Code_for_unit_of_measurement__c);
                    part.internalComments   = handleNull(oppyPart.comments__c);
                    part.competitorPartNumber   = handleNull(oppyPart.NDR_Competitor_Part_Number__c);
                    part.competitorName = handleNull(oppyPart.NDR_Competitor_Name__c);
                    list_parts.add(part);
                    
                 if(oppyPart.Sales_Price__c != oppyPart.Offered_price__c){
                     System.debug('*** sales price is ' + oppyPart.sales_price__c);
                     System.debug('*** target price is ' + oppyPart.Offered_price__c);

                     //Add Pricing In(target price)
                    WrapperPricingIn pricing = new WrapperPricingIn();
                    pricing.lineItemNumber = oppyPart.NDR_Item_Number__c;
                    if(curr_oppy != null && curr_oppy.SAP_Quote_Type__c == 'Small Quote'){
                        if(oppyPart.part__r.name.toLowerCase().contains('proposal') || oppyPart.part__r.name.toLowerCase().contains('cost') ){
                            pricing.priceCondition = 'PN00';
                        }else{
                            pricing.priceCondition = 'ZCRP';
                        }
                    //modified by Tangyong Li 2018-03-23: 'One Time Tender' -> 'Blanket/Tender'
                    //}else if(curr_oppy != null && curr_oppy.SAP_Quote_Type__c == 'One Time Tender'){
                    }else if(curr_oppy != null && curr_oppy.SAP_Quote_Type__c == 'Blanket/Tender'){
                        pricing.priceCondition = 'PN00';
                    }else{
                        if(oppyPart.part__r.name.toLowerCase().contains('proposal') || oppyPart.part__r.name.toLowerCase().contains('cost') ){
                            pricing.priceCondition = 'PN00';
                        }else{
                            pricing.priceCondition = 'ZCRP';
                        }
                    }
                    pricing.price = ''+ oppyPart.Offered_price__c;
                    
                    //modified by Buwen Guo 2018-02-08
                    //pricing.pricePer = '1';
                    pricing.pricePer = (oppyPart.NDR_Item_Price_Per__c==null?'1':oppyPart.NDR_Item_Price_Per__c);
                    
                    pricing.priceUom = handleNull(oppyPart.Code_for_unit_of_measurement__c);
                    pricing.priceCurrency = handleNull(oppyPart.opportunity__r.CurrencyIsoCode);
                    list_pricing.add(pricing);
                    
                    //Add Pricing In(competitor price)
                    if(curr_oppy != null && curr_oppy.Quote_Type__c == 'Meet Competitor Price'){
                        WrapperPricingIn pricing2 = new WrapperPricingIn();
                        pricing2.lineItemNumber = handleNull(oppyPart.NDR_Item_Number__c,6);
                        pricing2.priceCondition = 'ZCPP';
                        pricing2.price = ''+ oppyPart.Competitor_Price__c;
                        pricing2.pricePer = (oppyPart.NDR_Item_Price_Per__c==null?'1':oppyPart.NDR_Item_Price_Per__c);
                        pricing2.priceUom = handleNull(oppyPart.Code_for_unit_of_measurement__c);
                        pricing2.priceCurrency = handleNull(oppyPart.opportunity__r.CurrencyIsoCode);
                        list_pricing.add(pricing2);
                    }
                }
            }
            
            //Add request type and counter info into header
            if(curr_oppy != null && curr_oppy.id != null){
                
                //Check the first part. If the Competitor Name is null then send req_type 'QTE'. If it is NOT null then send 'MCP'
                for(Opportunity_Part__c oppyPart : list_oppParts){
                    if(oppyPart.NDR_Competitor_Name__c == null || oppyPart.NDR_Competitor_Name__c == ''){
                        quoteCreateRequest.requestType = 'QTE';
                    }else{
                        quoteCreateRequest.requestType = 'MCP';
                    }
                    break;
                }
                
                //caculate counter info into header
                //quoteCreateRequest.itemin_cnt = '' + list_parts.size();
                //quoteCreateRequest.pricingin_cnt = '' + list_pricing.size();
                //quoteCreateRequest.partnersin_cnt = '' + list_partners.size();
                
                system.debug('OppPart_Items_Size::'+list_parts.size());
            }
            

            WrapperCreateQuoteInfo createQuoteInfo = new WrapperCreateQuoteInfo(quoteCreateRequest, list_parts, list_pricing, list_partners);
            

            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http http = new Http();
            
            //BestPriceWebspeed__c bestPriceMfg = [select Name,URL__c from BestPriceWebspeed__c where name='SAP Create Quote' LIMIT 1];
            BestPriceWebspeed__c bestPriceMfg = BestPriceWebspeed__c.getInstance('SAP Create Quote');
            Energy_Inventory_And_Pricing__c pricingSetting = Energy_Inventory_And_Pricing__c.getInstance('SAP Pricing'); 
            req.setMethod('POST');
            req.setEndpoint(bestPriceMfg.URL__c);
            req.setHeader('Content-Type' ,'application/json;charset=UTF-8');
            req.setTimeout(60*1000);
            req.setHeader('grant_type','CLIENT_CREDENTIALS');
            //req.setHeader('client_id','396dabc178084bbeb4d35e0d00c329e2' );
            //req.setHeader('client_secret','8647B35320eb4a829d5170ec4052815c');
            if(pricingSetting != null){
                req.setHeader('client_id', pricingSetting.Client_Id__c);
                req.setHeader('client_secret', pricingSetting.Client_Secret__c);
            }
            req.setClientCertificateName('sfdcmulesoftpoc');
            req.setHeader('scope','READ WRITE');

            String str_quoteCallJSON = JSON.serialize(createQuoteInfo);
            //str_quoteCallJSON = str_quoteCallJSON.replaceAll('currencyCodeForReplace', 'currency');
            system.debug('quoteSAPcall body:::'+str_quoteCallJSON);
            req.setBody(JSON.serialize(createQuoteInfo));
            //req.setCompressed(true); // otherwise we hit a limit of 32000
            System.debug('Request::::' + req);
            res = http.send(req);
            System.debug('Response::'+res);
            //return 'success'+res;
        } catch(Exception ex) {
            System.debug('Create Quote SAP Callout error: '+ ex);
            System.debug('error at line ' + ex.getLineNumber());
            //ErrorLogging.Log(ex);
            String vStrError = '';
            vStrError += 'Error Type = ' + ex.getTypeName() + 
                ' Error Line = ' + ex.getLineNumber() + '' + 
                ' Error Stack = ' + ex.getStackTraceString() + 
                ' Error Message = ' + ex.getMessage();
            
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,                   
                                         SalesforceConstant.strError, '', '', '', '5','','','Exception', ex.getLineNumber() + '',ex.getStackTraceString());
            //return 'error: '+ ex;
        }
    }
    
    /*------------------------------------------------------------
    Author:        Tangyong Li <tangyong.li@capgemini.com>
    Description:   generate WrapperPartnersIn
    Inputs:        
    Returns:       
    History
    2018-02-09     Tangyong Li <tangyong.li@capgemini.com> created
    ------------------------------------------------------------*/
    public static WrapperPartnersIn generateWrapperPartnersIn(Opportunity_Partner__c oppyPartner, Account acct) {
    	WrapperPartnersIn partner_acct = new WrapperPartnersIn();
    	partner_acct.partnerAccountNumber  = getAccountNumber(acct.AccountNumber);
    	if(oppyPartner != null && oppyPartner.Partner_Role__c == 'POS') {
	        partner_acct.partnerType	   = 'YU';
    	} else {
    		partner_acct.partnerType	   = 'ZU';
    	}
        partner_acct.partnername  		   = handleNull(acct.name);
        partner_acct.street       		   = handleNull(acct.billingStreet);
        if(partner_acct.street.length() > 34){
            partner_acct.street   		   = handleNull(partner_acct.street, 35);
        }
        partner_acct.city         		   = handleNull(acct.billingCity);
        partner_acct.country      		   = handleNull(acct.billingCountry);
        partner_acct.postalCode   		   = handleNull(acct.billingPostalCode);
        partner_acct.salesEngineerName      = '';
        partner_acct.salesEngineerEmail     = '';
    	return partner_acct;
    }
    
    public class WrapperCreateQuoteInfo{
        public wrapperHeader quoteCreateRequest;
        public List<WrapperItemsIn> parts;   
        public List<WrapperPricingIn> pricing; 
        public List<WrapperPartnersIn> partners;      
        public WrapperCreateQuoteInfo(WrapperHeader quoteCreateRequest, List<WrapperItemsIn> list_parts, List<WrapperPricingIn> list_pricing, List<WrapperPartnersIn> list_partners){
            this.quoteCreateRequest = quoteCreateRequest;
            this.parts = list_parts;
            this.pricing = list_pricing;
            this.partners = list_partners;
        }
    }
    public class WrapperHeader{
        public String sfdcOpportunityId;
        public String soldToAccountNumber;
        public String shipToAccountNumber;
        public String distributionChannelCode;
        public String requestType;
        public String validFromDate;
        public String validToDate;
        public String customerReferenceNumber;
        public String project;
        public String requestCurrency;
        public String contactName;
        public String contactEmail;
        public String contactPhone;
        public String contactFax;
        public String customerComments;
        public String creatorEmail;
        public String creatorName;
        public String creatorPhone;
        //public String itemin_cnt;
        //public String pricingin_cnt;
        //public String partnersin_cnt;
        public String salesOrg;
        public String sapInstance;
        
        //added by Tangyong Li 2018-02-08
        public String incoTermsCode;
        public String paymentTermsCode;
        public String incoTermsDetails;
    }
    
    public class WrapperItemsIn{
        //public String SFDC_Id;
        public String lineItemNumber;
        public String partNumber;
        public String customerPartNumber;
        public String requestQty;
        public String uom;
        public String internalComments;
        public String competitorPartNumber;
        public String competitorName;
    }
    
    public class WrapperPricingIn{
        public String lineItemNumber;
        public String priceCondition;
        public String price;
        public String pricePer;
        public String priceUom;
        public String priceCurrency;
    }
    
    public class WrapperPartnersIn{
        public String partnerAccountNumber;
        public String partnerType;
        public String partnername;
        public String street;
        public String city;
        public String country;
        public String postalCode;
        public String salesEngineerName;
        public String salesEngineerEmail;
    }
}