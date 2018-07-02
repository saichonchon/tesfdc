/**********************************************************************************************************************************************
*******
Name: LiveagentCtrl
Copyright © 2016 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose:  It brings the countries, regions and chat buttons from various places, Custom Objects, Custom metadata types, custom setttings.
The intention is to finally bring up the button ids and publish to vf page picklist.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE          DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
1.0      Prabhanjan N       5/05/2016    Controller  
1.1      Raghu Rama Y       9/25/2016    Controller updated for Customer Care    
1.2      Onkar kumar        10/14/2017   EPD call - Line number - 135-147, 570-577
***********************************************************************************************************************************************
*****/


public class LiveagentCtrl {
    
    public list<Live_Agent_Country_List__c> CS {get;set;}
    public list<LA_Language_Settings__mdt> ChatButtRecs {get;set;}
    public string ChatButtonId_ZH {get;set;}
    public string ChatButtonId_DE {get;set;}
    public string ChatButtonId_EN {get;set;}
    public string ChatButtonId_ES {get;set;}
    public string VisitorRegion {get;set;}
    public string VisitorCountry {get;set;}
    public string VisitorCountryCode {get;set;}
    public string VisitorCountryCode_2_Digit {get;set;}
    public string VisitorPrefferedLang {get;set;}
    public string VisitorLocaleLang {get;set;} 
    public boolean chkNews_Evnts {get;set;}
    public boolean onload;
    public map<string,string> mapHTMLTranslations {get;set;}
    
    // New Variables
    public boolean chkPicChnBtnsFlg{get; set;}
    public boolean chkPicGmnBtnsFlg{get; set;}
    public boolean chkPicEngBtnsFlg{get; set;}
    public boolean chkPicSpnBtnsFlg{get; set;}     
    public string selectedCCorPIC {get; set;}
    public boolean accountExist {get; set;}
    public boolean showCcLong {get; set;}
    public string longName {get; set;}
    public string cclaEnglishButtonids{get; set;}
    public string cclaChineseButtonids{get; set;}
    public boolean chkCcEngBtnsFlg{get; set;}
    public boolean chkCcChnBtnsFlg{get; set;}
    public boolean showPicLong {get; set;}
    public string primarybuttonidsString{get; set;}
    public boolean chkCcPrmrBtnsFlg{get; set;}
    public string prmName {get; set;}
    public String piclonghtmlname { get; set; }
    public boolean deactivatePrechatCC {get; set;}
    public boolean deactivatePrechatPIC {get; set;} 
    public boolean deactivatePrechat {get; set;} 
    public String accnumfrmurl {get; set;}   
    
    private string additionalvalfromurlencd;
    private Blob additionalvaldecded;
    private string additionalinfostring;
    private string urlencodedaddinfo;
    private List<string> accorgids = new List<string>();
    private string ccroutingqry;
    private string CustRegionRecqry;
    private integer accExt; 
    private List<CC_Liveagent_Routing_Rules__c> CclaRoutingRules;
    private List<string> primarybuttonids;
    private List<CC_Liveagent_Language_Rules__c> cclaEnglishButtonrecs;
    private List<CC_Liveagent_Language_Rules__c> cclaChineseButtonrecs;
    String vStrError         = '';
    public string picChineseLanguageButtonResponse;
    public string picGermanLanguageButtonResponse;
    public string picEnglishLanguageButtonResponse;
    
    public string PrimaryButtonResponse;
    public string ChineseLanguageButtonResponse;
    public string EnglishLanguageButtonResponse;     
    public string picSpanishLanguageButtonResponse;
    public customerWrapper customerWrapperObject {get;set;}
    public LiveagentCtrl() {
        onload = true;
        accExt = 0;
        chkPicChnBtnsFlg = false;
        chkPicGmnBtnsFlg = false;
        chkPicEngBtnsFlg = false;
        chkPicSpnBtnsFlg = false;
        chkCcPrmrBtnsFlg = false;
        chkCcEngBtnsFlg = false;
        chkCcChnBtnsFlg = false;    
        deactivatePrechatPIC = false; 
        deactivatePrechatCC = false;  
        
        mapHTMLTranslations = new map < string, string > ();

    }
    
    public pagereference init(){
        try {
            customerWrapperObject = new customerWrapper();
            //VisitorCountryCode = apexpages.currentpage().getparameters().get('Country');
            
            VisitorPrefferedLang = apexpages.currentpage().getparameters().get('Language');
            
            additionalvalfromurlencd = ApexPages.currentPage().getParameters().get('additionalInfo');
            system.debug('additionalvalfromurlencd ' + additionalvalfromurlencd);
            
            //start:Prabhanjan May-08: Adding Additionalinfo parameter to avoid errors if doesnt exist    
            if(additionalvalfromurlencd==null||additionalvalfromurlencd=='')   {
                additionalvalfromurlencd = Live_Agent_Org_Settings__c.getInstance().AdditionalInfo__c;
            }
            
            additionalvaldecded = EncodingUtil.base64Decode(additionalvalfromurlencd);
            additionalinfostring = additionalvaldecded.toString();
            urlencodedaddinfo = EncodingUtil.urlDecode(additionalinfostring, 'UTF-8');
            system.debug('urlencodedaddinfo' + urlencodedaddinfo);
            
            List < string > additionalinfoparams = urlencodedaddinfo.split('&');
            system.debug('additionalinfoparams: '+additionalinfoparams);
            list < string > vars = new list < string > ();
            Map < string, string > varsMap = new map < string,string > (); // Code Added by Onkar.. for store key value pair for URL value
            
            
            for (string str: additionalinfoparams) {
                if (str.split('=').size() == 2) {
                    string s = str.split('=')[1];
                    vars.add(s);
                    varsMap.put(str.split('=')[0].toLowerCase(), str.split('=')[1]);
                }
                if (str.split('=').size() == 1) {
                    string s = null;
                    vars.add(s);
                }
                
            }
            system.debug('vars'+varsMap);
            
            /*// STRAT EPD CALL=================================================*/
            
            String TECewt7 = vars[2];
            // liveChatHealperCls EPDObject =  new liveChatHealperCls('c89b551c-21f1-4c6b-9bea-8586373fc476');
            liveChatHelperCls EPDObject =  new liveChatHelperCls(TECewt7);
            System.debug('>>'+EPDObject.getis404Error());
            customerWrapperObject.fName = EPDObject.fieldMap.get('firstName');
            customerWrapperObject.lName = EPDObject.fieldMap.get('lastName');
            customerWrapperObject.email = EPDObject.fieldMap.get('emailAddress');
            customerWrapperObject.subscribedFlag = EPDObject.fieldMap.get('subscribedFlag');
            customerWrapperObject.countryCode = EPDObject.fieldMap.get('countryCode');
            customerWrapperObject.country = EPDObject.fieldMap.get('country');
            
            System.debug('>>>'+varsMap);
            if(varsMap.get('tecewt7') != null || varsMap.containsKey('tecewt7')){
                customerWrapperObject.TECewt7 = varsMap.get('tecewt7');    
            }
            if(varsMap.get('country') != null || varsMap.containsKey('country')){
                VisitorCountryCode = varsMap.get('country');    
            }
            if(varsMap.get('language') != null || varsMap.containsKey('language' )){
                VisitorPrefferedLang = varsMap.get('language');    
            }
            
            if(varsMap.get('cust_accts') != null || varsMap.containsKey('cust_accts' )){
                accnumfrmurl = varsMap.get('cust_accts');    
            }else{
                accountExist = false;
                accnumfrmurl = null;
            }
            
            
            // END EPD CALL=================================================
            //
            /* Replace this with Map Key value 
                if (vars[0] == null || vars[0] == '') VisitorCountryCode = 'USA';
                if (vars[0] != null && vars[0] != '') VisitorCountryCode = vars[0];
                system.debug('VisitorCountryCode1:'+VisitorCountryCode);
                
                VisitorPrefferedLang = vars[1];
                system.debug('VisitorPrefferedLang: '+VisitorPrefferedLang);
                if (urlencodedaddinfo.contains('Cust_Accts')) {
                accnumfrmurl = vars[7];
                } else {
                accountExist = false;
                accnumfrmurl = null;
                }
            */
            system.debug('VisitorPrefferedLang: '+VisitorPrefferedLang);
            
            if (VisitorPrefferedLang == 'zh') VisitorLocaleLang = 'CHINESE';
            else if (VisitorPrefferedLang == 'de') VisitorLocaleLang = 'DEUTSCH';
            else if (VisitorPrefferedLang == 'es') VisitorLocaleLang = 'ESPAÑOL';
            else if (VisitorPrefferedLang == 'ja') VisitorLocaleLang = 'JAPANESE';
            else VisitorLocaleLang = 'ENGLISH';
            
            
            
            
            if (accnumfrmurl != null && accnumfrmurl != '') {
                accorgids = accnumfrmurl.split(',');       
                accExt = [select count() from CC_Liveagent_Routing_Rules__c where CustomerOrgAccNum__c IN: accorgids];
            }
            system.debug('Account Exist: '+accExt);
            if (accExt > 0 && accnumfrmurl != null) accountExist = true;
            
            if (accExt == 0) accountExist = false;
            
            
            
            CS = new list < Live_Agent_Country_List__c > ([SELECT Id, Name, Chinese_Label__c, Country_Code_2_Digit__c, Country_Code_3_Digit__c, English__c, German__c, Japanese__c, REGION_CODE__c
                                                           FROM Live_Agent_Country_List__c ORDER BY English__c ASC Limit 10000 ]);
            
            ChatButtRecs = new list < LA_Language_Settings__mdt > ([SELECT Visitor_Region__c, Chat_Buttons__c, Visitor_Preferred_Language__c FROM LA_Language_Settings__mdt]);
            system.debug('ChatButtRecs: '+ChatButtRecs); 
            for (Live_Agent_Country_List__c l: CS) {
                
                if (l.Country_Code_3_Digit__c == VisitorCountryCode) {
                    VisitorCountryCode_2_Digit = l.Country_Code_2_Digit__c;
                    VisitorRegion = l.REGION_CODE__c;
                    if (VisitorLocaleLang == 'CHINESE') VisitorCountry = l.Chinese_Label__c;
                    if (VisitorLocaleLang == 'ENGLISH') VisitorCountry = l.English__c;
                    if (VisitorLocaleLang == 'DEUTSCH') VisitorCountry = l.German__c;
                    if (VisitorLocaleLang == 'JAPANESE') VisitorCountry = l.Japanese__c;
                }
            }
            system.debug('VisitorCountryCode2'+VisitorCountryCode);
            system.debug('VisitorCountryCode_2_Digit'+VisitorCountryCode_2_Digit);     
            listChatButtons();
            HTMLTranslations();
            System.debug(mapHTMLTranslations.get('livechat'));
            if (accountExist == false || accnumfrmurl == null || accExt == 0) {
                checkPICAgentAvailability();
            }     
            return null;
        } catch (exception e) {
            vStrError += 'Error Type = ' + e.getTypeName() + 
                ' Error Line = ' + e.getLineNumber() + '' + 
                ' Error Stack = ' + e.getStackTraceString() + 
                ' Error Message = ' + e.getMessage();
            
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,                   
                                         SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '',e.getStackTraceString()); 
            
            system.debug('failed at contructors ::' + vStrError);
            return null;
        }
    }
    
    public void listChatButtons() {
        string newCountry;
        
        if (!onload) {
            newCountry = apexpages.currentpage().getparameters().get('newCountry');
            system.debug('newcountry'+newCountry);            
            if (newCountry != null && newCountry!='' && VisitorCountryCode_2_Digit != newCountry) VisitorCountryCode_2_Digit = newCountry;
            system.debug('VisitorCountryCode_2_Digit  -->' + VisitorCountryCode_2_Digit);
            for (Live_Agent_Country_List__c l: CS) {
                if (l.Country_Code_2_Digit__c == VisitorCountryCode_2_Digit) VisitorRegion = l.REGION_CODE__c;
            }
        }
        for (LA_Language_Settings__mdt lals: ChatButtRecs) {
            
            if (lals.Visitor_Preferred_Language__c == 'CHINESE' && VisitorRegion == lals.Visitor_Region__c) ChatButtonId_ZH = lals.Chat_Buttons__c;
            if (lals.Visitor_Preferred_Language__c == 'ENGLISH' && VisitorRegion == lals.Visitor_Region__c) ChatButtonId_EN = lals.Chat_Buttons__c;
            if (lals.Visitor_Preferred_Language__c == 'DEUTSCH' && VisitorRegion == lals.Visitor_Region__c) ChatButtonId_DE = lals.Chat_Buttons__c;
            if (lals.Visitor_Preferred_Language__c == 'ESPAÑOL' && VisitorRegion == lals.Visitor_Region__c) ChatButtonId_ES = lals.Chat_Buttons__c;
            
        }
        onload = false;
        system.debug('PIC Chinese Button Ids'+ChatButtonId_ZH);
        system.debug('PIC English Button Ids'+ChatButtonId_EN);
        system.debug('PIC Deutsch Button Ids'+ChatButtonId_DE);
        system.debug('PIC Spanish Button Ids'+ChatButtonId_ES);       
    }
    
    public void HTMLTranslations() {
        for (LA_Metadata_Translations__mdt LAMT: [SELECT Id, Chinese__c, English__c, German__c, HTML_Id__c, Japanese__c, German_ext__c FROM LA_Metadata_Translations__mdt ]) {
            
            if (VisitorLocaleLang == 'CHINESE') mapHTMLTranslations.put(LAMT.HTML_Id__c, LAMT.Chinese__c);
            if (VisitorLocaleLang == 'ENGLISH') mapHTMLTranslations.put(LAMT.HTML_Id__c, LAMT.English__c);
            if (VisitorLocaleLang == 'DEUTSCH') {
                string extraGerman = '';
                if (LAMT.German_ext__c != null) extraGerman = LAMT.German_ext__c;
                mapHTMLTranslations.put(LAMT.HTML_Id__c, LAMT.German__c + ' ' + extraGerman);
            }
            if (VisitorLocaleLang == 'JAPANESE') mapHTMLTranslations.put(LAMT.HTML_Id__c, LAMT.Japanese__c);
        }
    }
    
    public PageReference availableAgentButtonIds() {
        try{
            system.debug('selectedCCorPIC' + selectedCCorPIC);
            if(selectedCCorPIC == 'SELECT'){
                showCcLong = false;
                showPicLong = false;    
            }    
            if (selectedCCorPIC == 'ProductInformationPortal') {
                listChatButtons();
                checkPICAgentAvailability();
            }
            if (selectedCCorPIC == 'CustomerCarePortal') {
                checkCCAgentAvailability();
            }
        } catch (exception e) {
            vStrError += 'Error Type = ' + e.getTypeName() + 
                ' Error Line = ' + e.getLineNumber() + '' + 
                ' Error Stack = ' + e.getStackTraceString() + 
                ' Error Message = ' + e.getMessage();
            
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,                   
                                         SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '',e.getStackTraceString()); 
            
            system.debug('failed at HTMLTranslations() ::' +vStrError);
        }      
        return null;
    }
    
    public void checkCCAgentAvailability() {
        String CustomerDefaultRegion = 'AMER';
        if (accExt > 0) {
            
            
            
            ccroutingqry = 'Select id, Name, Customer_Name__c, Customer_Number__c, Primary_Button_Ids__c, Queue_Name__c, Region__c, Sales_Org_Id__c from CC_Liveagent_Routing_Rules__c WHERE';
            //CustRegionRecqry = 'select id, Region__c from CC_Liveagent_Routing_Rules__c where' + ' (CustomerOrgAccNum__c =\'' + accorgids[0] + '\')' + 'Limit 1';
            for (string st: accorgids) {
                ccroutingqry = ccroutingqry + ' (CustomerOrgAccNum__c =\'' + st + '\') ' + ' OR';
            }
            system.debug('Generated Query String: ' + ccroutingqry);
        }
        ccroutingqry = ccroutingqry.removeEnd('OR');
        CclaRoutingRules = database.query(ccroutingqry);
        
        if (!CclaRoutingRules.isEmpty()) {
            primarybuttonids = new List < string > ();
            for (CC_Liveagent_Routing_Rules__c rec: CclaRoutingRules) {
                CustomerDefaultRegion = rec.Region__c;
                //Sandeep - Why to check comma, if there can be id without comma
                if (rec.Primary_Button_Ids__c.contains(',')) {
                    for (string ss: rec.Primary_Button_Ids__c.split(',')) {
                        primarybuttonids.add(ss);
                    }
                } else {
                    primarybuttonids.add(rec.Primary_Button_Ids__c);
                }
            }
            
            //CC_Liveagent_Routing_Rules__c CustRegionRec = database.query(CustRegionRecqry);
            
            if (!string.isBlank(CustomerDefaultRegion)) {
                cclaEnglishButtonrecs = [select id, Button_Ids__c, Language__c, Region__c from CC_Liveagent_Language_Rules__c where Language__c = 'English' and Region__c = : CustomerDefaultRegion limit 1];                        
                cclaChineseButtonrecs = [select id, Button_Ids__c, Language__c, Region__c from CC_Liveagent_Language_Rules__c where Language__c = : 'Chinese' and Region__c = : CustomerDefaultRegion limit 1]; 
                
                cclaEnglishButtonids = cclaEnglishButtonrecs[0].Button_Ids__c;
                cclaChineseButtonids = cclaChineseButtonrecs[0].Button_Ids__c;
                
                system.debug('cclaEnglishButtonids @@.......' + cclaEnglishButtonids);
                system.debug('cclaChineseButtonids @@.......' + cclaChineseButtonids);
            }
            
            // Primary Button Ids String
            string primarybuttonidsStr;       
            for (string slpit: primarybuttonids) {
                if (slpit != null && slpit != '')
                    primarybuttonidsStr = primarybuttonidsStr + ',' + slpit;
            }
            primarybuttonidsStr = primarybuttonidsStr.replace('null,', '');
            
            primarybuttonidsString = primarybuttonidsStr;
            
            Live_Agent_Org_Settings__c orgSets = [select Live_Agent_API_Endpoint__c from Live_Agent_Org_Settings__c LIMIT 1];
            string endPointUrl = orgSets.Live_Agent_API_Endpoint__c;
            
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            //      Primary button availability
            req = new HttpRequest();           
            req.setEndpoint(endPointUrl + primarybuttonidsString);
            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('X-LIVEAGENT-API-VERSION', '34');
            
            
            if (!Test.isRunningTest()){
                HttpResponse primaryRes = h.send(req);
                system.debug('Primary Resp agents' + primaryRes.getBody());
                PrimaryButtonResponse = primaryRes.getBody();
            }
            if (PrimaryButtonResponse.contains('"isAvailable":true')) {
                chkCcPrmrBtnsFlg = true;
            } else {
                chkCcPrmrBtnsFlg = false;
            }
            
            //      English CC button availability
            if (!Test.isRunningTest()){
                cclaEnglishButtonids = cclaEnglishButtonids.deleteWhitespace();
            }
            
            req = new HttpRequest();
            req.setEndpoint(endPointUrl + cclaEnglishButtonids);
            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('X-LIVEAGENT-API-VERSION', '34');
            
            if (!Test.isRunningTest()){
                HttpResponse engRes = h.send(req);
                system.debug('English agents response ' + engRes.getBody());
                EnglishLanguageButtonResponse = engRes.getBody();
            }
            
            if (EnglishLanguageButtonResponse.contains('"isAvailable":true')) {
                chkCcEngBtnsFlg = true;
            } else {
                chkCcEngBtnsFlg = false;
            }
            
            //      Chinese CC button availability
            
            
            req = new HttpRequest();        
            req.setEndpoint(endPointUrl+cclaChineseButtonids);
            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('X-LIVEAGENT-API-VERSION', '34');
            if (!Test.isRunningTest()){
                HttpResponse chineseRes = h.send(req);
                system.debug('chineseRes agents' + chineseRes.getBody());
                
                ChineseLanguageButtonResponse = chineseRes.getBody();
            }
            if (ChineseLanguageButtonResponse.contains('"isAvailable":true')) {
                chkCcChnBtnsFlg = true;
            } else {
                chkCcChnBtnsFlg = false;
            }
            
            if(chkCcPrmrBtnsFlg == false && chkCcEngBtnsFlg == false && chkCcChnBtnsFlg == false) {
                deactivatePrechat = true;
                deactivatePrechatCC = true;
                deactivatePrechatPIC = false;        
                longName = 'liveagent_No.prechat_No.buttons_No'; 
                piclonghtmlname = 'liveagent_No.prechat_No.buttons_No'; 
                prmName = 'liveagent_No.prechat_No.buttons_No';
                system.debug('NO CC AGENTS ARE AVAILABLE');
            }
            
            if(chkCcPrmrBtnsFlg == true){
                showCcLong = false;
                showPicLong = false;
                longName = 'liveagent_No.prechat_No.buttons_No'; 
                piclonghtmlname = 'liveagent_No.prechat_No.buttons_No'; 
                prmName = 'liveagent.prechat.buttons';            
            }  
            
            system.debug('Primary Name format: '+prmName);
            if((chkCcPrmrBtnsFlg == false) && (chkCcEngBtnsFlg == true || chkCcChnBtnsFlg ==true)){
                showCcLong = true;
                showPicLong = false;
                longName = 'liveagent.prechat.buttons'; 
                piclonghtmlname = 'liveagent_No.prechat_No.buttons_No'; 
                prmName = 'liveagent_No.prechat_No.buttons_No';            
            }          
            
            ChatButtonId_ZH = null;
            ChatButtonId_EN = null;
            ChatButtonId_DE = null;
            ChatButtonId_ES = null;
            
            system.debug('CC Primary Agents Availability: ' + chkCcPrmrBtnsFlg);
            system.debug('CC English Agents Availability: ' + chkCcEngBtnsFlg);
            system.debug('CC Chinese Agents Availability: ' + chkCcChnBtnsFlg);
            
            system.debug('CC Primary Button Ids' + primarybuttonidsStr);
            system.debug('CC English Button Ids' + cclaEnglishButtonids);
            system.debug('CC Chinese Button Ids' + cclaChineseButtonids);
            
            system.debug('deactivatePrechatPIC'+deactivatePrechatPIC);
            system.debug('deactivatePrechatCC'+deactivatePrechatCC);
            
            system.debug('CC Chat Buttons: '+longName);
            system.debug('PIC Chat Buttons: '+piclonghtmlname);
            system.debug('Primary Chat Buttons: '+prmName);
            
        }
    }
    
    public void checkPICAgentAvailability() {
        listChatButtons();
        Live_Agent_Org_Settings__c orgSets = [select Live_Agent_API_Endpoint__c from Live_Agent_Org_Settings__c LIMIT 1];
        string endPointUrl = orgSets.Live_Agent_API_Endpoint__c;
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        
        req = new HttpRequest();   
        req.setEndpoint(endPointUrl + ChatButtonId_ZH);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('X-LIVEAGENT-API-VERSION', '34');
        
        if (!Test.isRunningTest()){        
            HttpResponse picChineseRes = h.send(req);
            system.debug('PIC Chinese Agents availability' + picChineseRes.getBody());
            picChineseLanguageButtonResponse = picChineseRes.getBody();
        }
        
        if (picChineseLanguageButtonResponse.contains('"isAvailable":true')) {
            chkPicChnBtnsFlg = true;
        }
        
        req = new HttpRequest();   
        req.setEndpoint(endPointUrl + ChatButtonId_DE);
        req.setMethod('GET');
         req.setTimeout(6000); 
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('X-LIVEAGENT-API-VERSION', '34');
        
        if (!Test.isRunningTest()){        
            HttpResponse picGermanRes = h.send(req);
            system.debug('PIC German Agents availability' + picGermanRes.getBody());
            picGermanLanguageButtonResponse = picGermanRes.getBody();
        }
        
        if (picGermanLanguageButtonResponse.contains('"isAvailable":true')) {
            chkPicGmnBtnsFlg = true;
        }
        
        req = new HttpRequest();   
        req.setEndpoint(endPointUrl + ChatButtonId_EN);
        req.setMethod('GET');
         req.setTimeout(6000); 
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('X-LIVEAGENT-API-VERSION', '34');
        System.debug('>>>'+endPointUrl);        
        if (!Test.isRunningTest()){        
            HttpResponse picEnglishRes = h.send(req);
            system.debug('PIC English Agents availability' + picEnglishRes.getBody());
            picEnglishLanguageButtonResponse = picEnglishRes.getBody();
        }
        
        if (picEnglishLanguageButtonResponse.contains('"isAvailable":true')) {
            chkPicEngBtnsFlg = true;
        }
        
        req = new HttpRequest();
        req.setEndpoint(endPointUrl + ChatButtonId_ES);
        req.setMethod('GET');
         req.setTimeout(6000); 
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('X-LIVEAGENT-API-VERSION', '34');
        
        if (!Test.isRunningTest()){        
            HttpResponse picSpanishRes = h.send(req);
            picSpanishLanguageButtonResponse = picSpanishRes.getBody();
        }
        
        if (picSpanishLanguageButtonResponse.contains('"isAvailable":true')) {
            chkPicSpnBtnsFlg = true;
        }
        
        system.debug('YESS');
        if (chkPicChnBtnsFlg == false && chkPicGmnBtnsFlg == false && chkPicEngBtnsFlg == false && chkPicSpnBtnsFlg == false) {            
            deactivatePrechat = true;
            deactivatePrechatPIC = true;
            deactivatePrechatCC = false;
            system.debug('NO PIC AGENTS ARE AVAILABLE');
            
        }
        
        if (chkPicChnBtnsFlg == true || chkPicGmnBtnsFlg == true || chkPicEngBtnsFlg == true || chkPicSpnBtnsFlg == true) {
            longName = 'liveagent_No.prechat_No.buttons_No';
            piclonghtmlname = 'liveagent.prechat.buttons';
            prmName = 'liveagent_No.prechat_No.buttons_No';
            showPicLong = true;
            showCcLong = false;
            accountExist = false;
        }
        
        primarybuttonidsString = null;
        cclaEnglishButtonids = null;
        cclaChineseButtonids = null;
        
        system.debug('PIC Chinese Agents availability: ' + chkPicChnBtnsFlg);
        system.debug('PIC German Agents availability: ' + chkPicGmnBtnsFlg);
        system.debug('PIC English Agents availability: ' + chkPicEngBtnsFlg);
        system.debug('PIC Spanish Agents availability: ' + chkPicSpnBtnsFlg);
        
        system.debug('PIC Chinese Button Ids' + ChatButtonId_ZH);
        system.debug('PIC English Button Ids' + ChatButtonId_EN);
        system.debug('PIC Deutsch Button Ids' + ChatButtonId_DE);
        system.debug('PIC Spanish Button Ids' + ChatButtonId_ES);
        
        system.debug('deactivatePrechatPIC '+deactivatePrechatPIC);
        system.debug('deactivatePrechatCC '+deactivatePrechatCC);
        
        system.debug('CC Chat Buttons: '+longName);
        system.debug('PIC Chat Buttons: '+piclonghtmlname);
        system.debug('Primary Chat Buttons: '+prmName);
        
    }
    
    public class customerWrapper{
        
   public string fName {get;set;}
        public string subject {get;set;} // Added for Live chat phase - 2 
        public string lName {get;set;}
        public string email {get;set;}
        public string eContactId {get;set;}
        public string TECewt7 {get;set;}
        public string subscribedFlag {get;set;} 
        public string emailOptOutFlag {get;set;}
        public string countryCode {get;set;}
        public string country {get;set;}  
    }  
}