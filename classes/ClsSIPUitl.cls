/**
*   Contains a set of static methods used in invoice creation triggers
*
@author Lili Zhao
@created 2013-08-07
@version 1.0
@since 24.0 (Force.com ApiVersion)
*
@changelog
* 2013-08-07 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
* 2014-09-22 Bin Yuan <bin.yuan@itbconsult.com>
* - Modified to extend record types to fillin AM & FE terrritory code
*/   
   
public class ClsSIPUitl {         
   
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private static boolean isBillPopulated = false;
    private static boolean isOppyPopulated = false;
    private static map<String, String> map_RecordType = new map<String, String>();
    //added lili zhao 2015-08-27 due to avoid getPMAMOrFERTNames method to call many time
    private static set<String> set_AMRTDeveloperName = new set<String>();
    private static set<String> set_FERTDeveloperName = new set<String>();
    //end
    public static list<String> list_TemplateId = new list<String>();
    public static boolean isUpdate = true; 
    public static boolean ISAFTERUPDATE = false;
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////

    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
    public static String getSessionId(){
        String sessId;
        //run oAuth to get session ID by using refresh token
        //get the refresh code from custom settings
        if(SIP_Sharing_Setting__c.getInstance('SIP batch refresh token') != null && SIP_Sharing_Setting__c.getInstance('SIP batch refresh token').Value__c != null){
            String rtId, cId, sId;
            
            rtId = SIP_Sharing_Setting__c.getInstance('SIP batch refresh token').Value__c;
            if(SIP_Sharing_Setting__c.getInstance('SIP batch customer Id') != null && SIP_Sharing_Setting__c.getInstance('SIP batch customer Id').Value__c != null){
                cId = SIP_Sharing_Setting__c.getInstance('SIP batch customer Id').Value__c;
            }
            if(SIP_Sharing_Setting__c.getInstance('SIP batch secret Id') != null && SIP_Sharing_Setting__c.getInstance('SIP batch secret Id').Value__c != null){
                sId = SIP_Sharing_Setting__c.getInstance('SIP batch secret Id').Value__c;
            }       
            
            if(cId != null && sId != null){
                // get new token Id 
                system.debug('cId===>'+cId);
                String endPoint =  URL.getSalesforceBaseUrl().toExternalForm();//getCalloutEndPoint();
                Http httpProtocol = new Http();   
                HttpRequest request = new HttpRequest();                
                request.setHeader('Content-Type', 'application/x-www-form-urlencoded;');
                request.setHeader('Accept', 'application/json;');
                request.setEndpoint(endPoint + '/services/oauth2/token');
                request.setMethod('POST');
                String strbody = 'grant_type=refresh_token&client_id=' + cId + '&client_secret='+ sId+ '&refresh_token=' + rtId;
                request.setBody(strbody);
                request.setTimeout(120000);
                system.debug('request===>'+request.getBody());
                HttpResponse response = httpProtocol.send(request);
                String jsonInput = response.getBody();
                system.debug('jsonInput===>'+jsonInput);
                JSONParser parser = JSON.createParser(jsonInput);        
                
                while (parser.nextToken() != null && sessId == null) {            
                if (parser.getCurrentName() == 'access_token') {                
                    // Get the value.                               
                    sessId = parser.getText();            
                   }        
                    parser.nextToken();
                }      
                system.debug('sessId =' + sessId);                 
            }            
        }         
        return sessId;
    }
    
    public static void sipDataPopulation(list<SIP__c> list_sips) {
        list<SIP__c> list_sipPopulateTerritoryCode = new list<SIP__c>();
        list<SIP__c> list_sipPopulateLoadStatus = new list<SIP__c>();   
        list<SIP__c> list_sipPopulateBillings = new list<SIP__c>(); 
        list<SIP__c> list_sipPopulateOpportunityData = new list<SIP__c>(); 
        set<String> set_plPartTENetId = new set<String>();   
        set<String> set_AMCodes = new set<String>();  
        set<String> set_FECodes = new set<String>();  
        set<String> set_GAMCodes = new set<String>();
        map<Id,set<String>> map_AMSetLevel7TerritoryCode = new map<Id,set<String>>();
        map<Id,set<String>> map_FESetLevel7TerritoryCode = new map<Id,set<String>>();
        map<Id,set<String>> map_GAMCodes = new map<Id,set<String>>(); 
        map<String, set<String>> map_sipId_set_profitCtrs4GAM = new map<String, set<String>>(); 
        //added lili zhao 2015-08-20 due to set the record type name to custom setting
        //set<String> set_AMRTDeveloperName = getPMAMOrFERTNames('SIP AM RecordType DeveloperNames');
        //set<String> set_FERTDeveloperName = getPMAMOrFERTNames('SIP FE RecordType DeveloperNames');
        //added lili zhao 2015-08-27
        if(set_AMRTDeveloperName.isEmpty()) {
            set_AMRTDeveloperName = getPMAMOrFERTNames('SIP AM RecordType DeveloperNames');
        } 
        
        if(set_FERTDeveloperName.isEmpty()) {
            set_FERTDeveloperName = getPMAMOrFERTNames('SIP FE RecordType DeveloperNames');
        }    
        //end                                                                                
        if(map_RecordType.isEmpty()) {
            getRTMap();
        }
        system.debug('map_RecordType :: ' + map_RecordType);
        /*
        // Modified by lili zhao 2015-08-20 due to extend record types to used custom setting
        for(String recordName : list_AMRecordTypeId)  {
            if(map_RecordType.containsKey(recordName)) set_AMRecordTypeId.add(map_RecordType.get(recordName));
        }
        
        for(String recordName : list_FERecordTypeId)  {
            if(map_RecordType.containsKey(recordName)) set_FERecordTypeId.add(map_RecordType.get(recordName));
        }
        */
        //end
        for(SIP__c sip : list_sips){ 
            if(sip.Exclude_From_Automatic_Update__c == false){
                resetData(sip);
                system.debug('sip.RecordTypeId :: ' + sip.RecordTypeId);
                //Modified by bin yuan 2014-09-22 due to extend record types to fillin AM & FE terrritory code
                //if (sip.RecordTypeId == map_RecordType.get('AM_plan')){
                // Modified by lili zhao 2015-08-20 due to extend record types to used custom setting
                //if (sip.RecordTypeId == map_RecordType.get('AM_plan') || sip.RecordTypeId == map_RecordType.get('AM_Plan_FY15')){
                for(String amDevName : set_AMRTDeveloperName) {
                    system.debug('map_RecordType.get(amDevName) :: ' + map_RecordType.get(amDevName));
                    if(sip.RecordTypeId == map_RecordType.get(amDevName)) {
                        set_plPartTENetId.add(sip.Participants_TE_Network_ID__c);   
                        list_sipPopulateTerritoryCode.add(sip);
                    }
                }
                for(String feDevName : set_FERTDeveloperName) {
                    if(sip.RecordTypeId == map_RecordType.get(feDevName)) {
                        set_plPartTENetId.add(sip.Participants_TE_Network_ID__c);   
                        list_sipPopulateTerritoryCode.add(sip);
                    }
                }
                system.debug('set_plPartTENetId :: ' + set_plPartTENetId);
                if(sip.Load_Status_Monthly_Direct__c == null || sip.Load_Status_Record_Indirect__c == null){ 
                    list_sipPopulateLoadStatus.add(sip);
                }
                if(sip.Conversion_result__c == null &&  sip.Pipeline_Result__c == null && sip.Prev_Year_Pipeline_YTD_Result_Dollar__c == null && sip.Prev_Year_Conversion_YTD_Result_Dollar__c == null && isOppyPopulated == false && sip.RecordTypeId == map_RecordType.get('FE_Plan')) {
                    list_sipPopulateOpportunityData.add(sip);
                    isOppyPopulated = true;
                }  
                /*commented by bin yuan 2016-08-29 due to record type name correction
                if(isBillPopulated == false && (sip.RecordTypeId == map_RecordType.get('GAM_plan') || sip.RecordTypeId == map_RecordType.get('FE_Plan') || sip.RecordTypeId == map_RecordType.get('AM_plan'))) {
                    if(sip.RecordTypeId == map_RecordType.get('GAM_plan')) {
                */
                if(isBillPopulated == false && (sip.RecordTypeId == map_RecordType.get('GAM_Plan') || sip.RecordTypeId == map_RecordType.get('FE_Plan') || sip.RecordTypeId == map_RecordType.get('AM_Plan'))) {
                    if(sip.RecordTypeId == map_RecordType.get('GAM_Plan')) {
                        if(sip.GAM_codes__c != null) {                          
                            buildCodeMap(set_GAMCodes, map_GAMCodes, sip.GAM_codes__c,sip.Id);
                        }
                        //process GAM Profit centres
                        if(sip.Profit_Center_Codes__c != null) {
                            if(sip.Profit_Center_Codes__c.contains(';')) {
                                for(String profitCode : sip.Profit_Center_Codes__c.split(';')) {
                                    if(!map_sipId_set_profitCtrs4GAM.containsKey(sip.Id)) {
                                        map_sipId_set_profitCtrs4GAM.put(sip.Id, new set<String>());
                                    }
                                    map_sipId_set_profitCtrs4GAM.get(sip.Id).add(profitCode);
                                }
                            }
                            else {
                                if(!map_sipId_set_profitCtrs4GAM.containsKey(sip.Id)) {
                                    map_sipId_set_profitCtrs4GAM.put(sip.Id, new set<String>());
                                }
                                map_sipId_set_profitCtrs4GAM.get(sip.Id).add(sip.Profit_Center_Codes__c);
                            }
                        }
                    }
                    list_sipPopulateBillings.add(sip);
                    isBillPopulated = true;
                }        
            }    
        }   
        //populate terrirory code
        if(!list_sipPopulateTerritoryCode.isEmpty()) {
            system.debug('list_sipPopulateTerritoryCode :: ' + list_sipPopulateTerritoryCode);
            populateTerritoryCode(list_sipPopulateTerritoryCode,set_AMCodes,set_FECodes,map_AMSetLevel7TerritoryCode,map_FESetLevel7TerritoryCode,set_plPartTENetId);
        }       
        //populate load status
        if(!list_sipPopulateLoadStatus.isEmpty()) {
            ClsSIPUitl.populateLoadStatus(list_sipPopulateLoadStatus);  
        }       
        //populate billing & oppy data
        if(!list_sipPopulateBillings.isEmpty()) {
            populateBillings(list_sipPopulateBillings,set_AMCodes,set_FECodes,set_GAMCodes,map_AMSetLevel7TerritoryCode,map_FESetLevel7TerritoryCode,map_GAMCodes, map_sipId_set_profitCtrs4GAM);   
        }       
        if(!list_sipPopulateOpportunityData.isEmpty()) { 
            populateOpportunityData(list_sipPopulateOpportunityData[0]);
        }
    }

    public static void recalcBillingAndOppyData(list<SIP__c> list_sips,list<SIP__c> list_sipPopulateOpportunityData, list<SIP__c> list_sipPopulateBillings,set<String> set_AMCodes,set<String> set_FECodes,set<String> set_GAMCodes,map<Id,set<String>> map_sipId_set_amCode,map<Id,set<String>> map_sipId_set_feCode,map<Id,set<String>> map_sipId_set_gamCode,map<String, set<String>> map_sipId_set_profitCtrs4GAM) {
        boolean isReBillPopulated = false;
        for(SIP__c sip: list_sips) {
            if(isReBillPopulated == false) {
                //commented by bin yuan 2016-08-29 due to record type name correction
                //if(sip.RecordType.DeveloperName == 'AM_plan' && sip.AM_codes__c != '' && sip.AM_codes__c != null) {
                if(sip.RecordType.DeveloperName == 'AM_Plan' && sip.AM_codes__c != '' && sip.AM_codes__c != null) {
                    list_sipPopulateBillings.add(sip);
                    buildCodeMap(set_AMCodes, map_sipId_set_amCode, sip.AM_codes__c,sip.Id);
                }
                if(sip.RecordType.DeveloperName == 'FE_Plan') {
                    if(sip.FE_codes__c !=  '' && sip.FE_codes__c != null) {
                        buildCodeMap(set_FECodes, map_sipId_set_feCode, sip.FE_codes__c,sip.Id);
                        list_sipPopulateBillings.add(sip);
                    }
                    sip.Prev_Year_Pipeline_YTD_Result_Dollar__c = null;
                    sip.Prev_Year_Conversion_YTD_Result_Dollar__c = null;
                    sip.Conversion_result__c = null;
                    sip.Pipeline_Result__c = null;
                    list_sipPopulateOpportunityData.add(sip);
                }
                //commented by bin yuan 2016-08-29 due to record type name correction
                //if(sip.RecordType.DeveloperName == 'GAM_plan' && sip.GAM_codes__c != '' && sip.GAM_codes__c != null) {
                if(sip.RecordType.DeveloperName == 'GAM_Plan' && sip.GAM_codes__c != '' && sip.GAM_codes__c != null) {
                    list_sipPopulateBillings.add(sip);
                    buildCodeMap(set_GAMCodes, map_sipId_set_gamCode, sip.GAM_codes__c,sip.Id);
                    if(sip.Profit_Center_Codes__c != null) {
                        for(String profitCode : sip.Profit_Center_Codes__c.split(';')) {
                            if(!map_sipId_set_profitCtrs4GAM.containsKey(sip.Id)) {
                                map_sipId_set_profitCtrs4GAM.put(sip.Id, new set<String>());
                            }
                            map_sipId_set_profitCtrs4GAM.get(sip.Id).add(profitCode);
                        }
                    }
                }
            }
            isReBillPopulated = true;
        }
        if(!list_sipPopulateOpportunityData.isEmpty()) {   
            populateOpportunityData(list_sipPopulateOpportunityData[0]);
            update list_sipPopulateOpportunityData[0];
        }
        
        if(!list_sipPopulateBillings.isEmpty()) {
            populateBillings(list_sipPopulateBillings, set_AMCodes, set_FECodes, set_GAMCodes, map_sipId_set_amCode, map_sipId_set_feCode, map_sipId_set_gamCode, map_sipId_set_profitCtrs4GAM);            
        }
        if(!list_sipPopulateBillings.isEmpty()) {
            for(SIP__c sip : list_sipPopulateBillings) {    
                update sip;
            }     
        }                                           
    }
    /**
    * This method is used to assignment automatically for AM_codes__c or FE_codes__c of SIP__c.
    *
    @author Lili Zhao       
    @created 2013-08-07
    @version 1.0
    @since 24.0 (Force.com ApiVersion)
    *
    @changelog
    * 2013-08-07 Lili Zhao <lili.zhao@itbconsult.com>  
    * - Created  
    */
    public static void populateTerritoryCode(List<SIP__c> sips, set<String> set_AMCodes, set<String> set_FECodes, map<Id,set<String>> map_AMSetLevel7TerritoryCode, map<Id,set<String>> map_FESetLevel7TerritoryCode,set<String> set_plPartTENetId) {  
        map <Id,list<String>> map_AMLevel7TerritoryCode = new map <Id,list<String>>(); 
        map <Id,list<String>> map_FELevel7TerritoryCode = new map <Id,list<String>>();
      
        if(!sips.isEmpty()){      
            for(Sales_Hierarchy__c salesHierarchy : [select Id, Level_7_Territory_Code__c, Level_7_Assigned_User_Network_Ids__c, Hierarchy_Type__c 
                                                     from Sales_Hierarchy__c 
                                                     where (Hierarchy_Type__c  = 'Sales Hierarchy (AM)' or Hierarchy_Type__c  = 'Account Manager Hierarchy (FE)') and (Level_7_Assigned_User_Network_Ids__c IN:set_plPartTENetId  or Level_7_Assigned_User_Network_Ids__c like '%;%')]) {                                                
                system.debug('salesHierarchy :: ' + salesHierarchy);
                for(SIP__c sip :sips){
                    if(salesHierarchy.Level_7_Assigned_User_Network_Ids__c != null) {
                        if(salesHierarchy.Level_7_Assigned_User_Network_Ids__c.contains(';')){
                            for(String le7UesrNetworkId : salesHierarchy.Level_7_Assigned_User_Network_Ids__c.split(';')) {                         
                                getCodes(le7UesrNetworkId,salesHierarchy,sip,set_AMCodes,set_FECodes,map_AMSetLevel7TerritoryCode,map_FESetLevel7TerritoryCode);                            
                            } 
                        }else {
                            getCodes(salesHierarchy.Level_7_Assigned_User_Network_Ids__c,salesHierarchy,sip,set_AMCodes,set_FECodes,map_AMSetLevel7TerritoryCode,map_FESetLevel7TerritoryCode);
                        }
                    }                                                    
                }
            } 
        }
        
    }   

    /**
    * This method is used to assignment automatically for Load_Status_Monthly_Direct__c and Load_Status_Record_Indirect__c of SIP__c.
    *
    @author Lili Zhao       
    @created 2013-08-07
    @version 1.0
    @since 24.0 (Force.com ApiVersion)
    *
    @changelog
    * 2013-08-07 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created  
    */  
    public static void populateLoadStatus(List<SIP__c> sips){
        map<String,Id>  map_loadStatus = new Map<String,Id>();
        for(Load_Status__c loadStatus : [Select Name ,Id From Load_Status__c where (Name='BBB_Month_Bill_Book_Cust__c Indirect' or Name ='BBB_Month_Bill_Book_Cust__c Direct')]) {
            map_loadStatus.put(loadStatus.Name,loadStatus.Id);
        }
        for(SIP__c sip : sips) {
            sip.Load_Status_Monthly_Direct__c = map_loadStatus.get('BBB_Month_Bill_Book_Cust__c Direct');
            sip.Load_Status_Record_Indirect__c = map_loadStatus.get('BBB_Month_Bill_Book_Cust__c Indirect');
        }
    }
    
    /**
    * This method is used to assignment automatically for for Prev_Year_1__c,Id,Prev_Year_1_POS_Result__c,Prev_Year_YTD_Direct_billings__c,Prev_Year_YTD_POS__c,Current_Year_Direct_Bill_YTD__c and Current_Year_POS_Bill_YTD__c of SIP__c
    *
    @author Lili Zhao       
    @created 2013-08-07
    @version 1.0
    @since 24.0 (Force.com ApiVersion)
    *
    @changelog
    * 2013-08-07 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created  
    */
    public static void populateBillings(List<SIP__c> sips, set<String> set_AMCodes, set<String> set_FECodes, set<String> set_GAMCodes, map<Id,set<String>> map_AMSetLevel7TerritoryCode, map<Id,set<String>> map_FESetLevel7TerritoryCode, map<Id,set<String>> map_GAMCodes, map<String, set<String>> map_sipId_set_profitCtrs4GAM) {
        if(map_RecordType.isEmpty()) {
            getRTMap();
        } 
        reSetSipBillings(sips); 
   
        //===========================================================================================
        // START:The RecordType is AM_plan,then assignment automatically for some fields of SIP__c
        //===========================================================================================
        if(!set_AMCodes.isEmpty()){         
            for(AggregateResult  bMonBilBoCu :[Select sum(Bill_Amount_USD__c) sum_billAmoutUSD,Customer__r.SALES_TERRITORY_CDE__c salesTerritoryCde, Bill_Type__c billType, Fiscal_Year__c fiscalYear  
                                              From BBB_Month_Bill_Book_Cust__c   
                                              where Customer__r.Sales_Hierarchy__c != null  and (Bill_Type__c = 'POS'  or Bill_Type__c = 'Direct') and (Customer__r.SALES_TERRITORY_CDE__c IN:set_AMCodes )
                                              group by  Fiscal_Year__c, Bill_Type__c,Customer__r.SALES_TERRITORY_CDE__c ]) {
                for(SIP__c sip : sips){    
                    //commented by bin yuan 2016-08-29 due to record type name correction         
                    //if(map_AMSetLevel7TerritoryCode.get(sip.Id).size() > 0 && map_AMSetLevel7TerritoryCode.get(sip.Id).contains( (String)bMonBilBoCu.get('salesTerritoryCde') ) && sip.RecordTypeId == map_RecordType.get('AM_plan')) {             
                    if(map_AMSetLevel7TerritoryCode.get(sip.Id).size() > 0 && map_AMSetLevel7TerritoryCode.get(sip.Id).contains( (String)bMonBilBoCu.get('salesTerritoryCde') ) && sip.RecordTypeId == map_RecordType.get('AM_Plan')) {             
                        getSipBilling(sip,bMonBilBoCu);                                             
                    }
                }
            }   
        }    
        //===========================================================================================
        // END         
        //===========================================================================================
        
        //===========================================================================================
        // START:The RecordType is FE_plan,then assignment automatically for some fields of SIP__c
        //===========================================================================================
        if(!set_FECodes.isEmpty()){
            for(AggregateResult  bMonBilBoCu :[Select sum(Bill_Amount_USD__c) sum_billAmoutUSD,Customer__r.ACCTMGRCD__c acctmgrcd, Bill_Type__c billType, Fiscal_Year__c fiscalYear  
                                               From BBB_Month_Bill_Book_Cust__c  
                                               where Customer__r.FE_Hierarchy__c != null and (Customer__r.ACCTMGRCD__c IN : set_FECodes and Customer__c != null) and (Bill_Type__c = 'POS'  or Bill_Type__c = 'Direct')
                                               group by  Fiscal_Year__c, Bill_Type__c,Customer__r.ACCTMGRCD__c ]) {
                for(SIP__c sip : sips){             
                    if(map_FESetLevel7TerritoryCode.get(sip.Id).size() > 0 && map_FESetLevel7TerritoryCode.get(sip.Id).contains( (String)bMonBilBoCu.get('acctmgrcd') ) && sip.RecordTypeId == map_RecordType.get('FE_Plan')){              
                        getSipBilling(sip,bMonBilBoCu);                                             
                    }
                }
            } 
        }
        //===========================================================================================
        // END         
        //===========================================================================================
        
        //===========================================================================================
        // START:The RecordType is GAM_plan,then assignment automatically for some fields of SIP__c
        //===========================================================================================
        if(!set_GAMCodes.isEmpty()){
            for(AggregateResult  bMonBilBoCu :[Select sum(Bill_Amount_USD__c) sum_billAmoutUSD, Customer__r.GAMCD__c gamcd, Bill_Type__c billType, Fiscal_Year__c fiscalYear, SAP_Profit_Center_Short_Description__c profitCode  
                                               From BBB_Month_Bill_Book_Cust__c   
                                               where (Bill_Type__c = 'POS'  or Bill_Type__c = 'Direct') and (Customer__r.GAMCD__c != null and Customer__r.GAMCD__c IN:set_GAMCodes)
                                               group by  Fiscal_Year__c, Bill_Type__c,Customer__r.GAMCD__c, SAP_Profit_Center_Short_Description__c ]) {
                for(SIP__c sip : sips){     
                    //commented by bin yuan 2016-08-29 due to record type name correction  
                    //if( map_GAMCodes.get(sip.Id).contains( (String)bMonBilBoCu.get('gamcd') ) && sip.RecordTypeId == map_RecordType.get('GAM_plan')){   
                    if( map_GAMCodes.get(sip.Id).contains( (String)bMonBilBoCu.get('gamcd') ) && sip.RecordTypeId == map_RecordType.get('GAM_Plan')){   
                        //if(!map_sipId_set_profitCtrs4GAM.containsKey(sip.Id) || (map_sipId_set_profitCtrs4GAM.containsKey(sip.Id) && bMonBilBoCu.get('profitCode') != null && map_sipId_set_profitCtrs4GAM.get(sip.Id).contains(String.valueOf(bMonBilBoCu.get('profitCode'))))) { // add lili 2013.11.25
                        if(map_sipId_set_profitCtrs4GAM.containsKey(sip.Id) && map_sipId_set_profitCtrs4GAM.get(sip.Id).size() > 0 && bMonBilBoCu.get('profitCode') != null && map_sipId_set_profitCtrs4GAM.get(sip.Id).contains(String.valueOf(bMonBilBoCu.get('profitCode')))) {  //add lili 2013.11.25                                                
                            getSipBilling(sip,bMonBilBoCu);                                         
                        }           
                    }
                }
            }
        }
        //===========================================================================================
        // END         
        //===========================================================================================       
    }


    
    public static void populateOpportunityData(SIP__c sip) {
        Date currentFYStart;
        Date currentFYEnd;
        Date nextFYStart;
        Date nextFYEnd;
        Date next2FYStart;
        Date next2FYEnd;
        Date lastFYStart;
        Date lastFYEnd;
        Date last2FYStart;
        Date last2FYEnd;
        Date last3FYStart;
        Date last3FYEnd;
        String currentYear;
        String nextYear;
        String next2Year;
        String lastYear;
        String last2Year;
        String last3Year;
        set<String> set_profitCtr = new set<String>();
        set<String> set_billReg = new set<String>();

        currentYear = String.valueOf(Integer.valueOf(sip.Plan_Year__c));
        nextYear = String.valueOf(Integer.valueOf(currentYear) + 1);
        next2Year = String.valueOf(Integer.valueOf(currentYear) + 2);
        lastYear = String.valueOf(Integer.valueOf(currentYear) - 1);
        last2Year = String.valueOf(Integer.valueOf(currentYear) - 2);
        last3Year = String.valueOf(Integer.valueOf(currentYear) - 3);
        /* add lili 2013.11.11
        currentYear = String.valueOf(Integer.valueOf(sip.Plan_Year__c) - 1);
        nextYear = String.valueOf(Integer.valueOf(currentYear) + 1);
        next2Year = String.valueOf(Integer.valueOf(currentYear) + 2);
        lastYear = String.valueOf(Integer.valueOf(currentYear) - 1);
        last2Year = String.valueOf(Integer.valueOf(currentYear) - 2);
        last3Year = String.valueOf(Integer.valueOf(currentYear) - 3);
        */
        if(map_RecordType.isEmpty()) {
            getRTMap();
        }
        set<String> set_FESIPOppyRecordTypeId = new set<String>();
        String FESIPOppyRecordTypeId = '';
        
        if(SIP_Sharing_Setting__c.getInstance('FE SIP Oppy RecordTypeId') != null && SIP_Sharing_Setting__c.getInstance('FE SIP Oppy RecordTypeId').Is_Active__c && SIP_Sharing_Setting__c.getInstance('FE SIP Oppy RecordTypeId').Value__c != null ) {
            FESIPOppyRecordTypeId = (String) SIP_Sharing_Setting__c.getInstance('FE SIP Oppy RecordTypeId').Value__c;
        }
        if(FESIPOppyRecordTypeId != '') {
            if(FESIPOppyRecordTypeId.contains(',')) {
                for(String RecordTypeId : FESIPOppyRecordTypeId.split(',')) {
                    set_FESIPOppyRecordTypeId.add(RecordTypeId);
                }       
            }else{
                set_FESIPOppyRecordTypeId.add(FESIPOppyRecordTypeId);
            }
        } 
        system.debug('set_FESIPOppyRecordTypeId---'+set_FESIPOppyRecordTypeId);          
               
        for(FiscalYearSettings fs : [SELECT Id, StartDate, EndDate, Name FROM FiscalYearSettings where Name =: currentYear OR Name =: nextYear OR Name =: lastYear OR Name =: last2Year OR Name =: next2Year]) {
            if(fs.Name == currentYear) {
                currentFYStart = fs.StartDate;              
                currentFYEnd = fs.EndDate;
            }
            if(fs.Name == nextYear) {
                nextFYStart = fs.StartDate;             
                nextFYEnd = fs.EndDate;
            }
            if(fs.Name == next2Year) {
                next2FYStart = fs.StartDate;                
                next2FYEnd = fs.EndDate;
            }
            if(fs.Name == lastYear) {
                lastFYStart = fs.StartDate;             
                lastFYEnd = fs.EndDate;
            }
            if(fs.Name == last2Year) {
                last2FYStart = fs.StartDate;                
                last2FYEnd = fs.EndDate;
            }
        }

            //===========================================================================================
            // for FE Opportunity populate
            //===========================================================================================   
                 
            //===========================================================================================
            // for FE PIPLINE populate
            //===========================================================================================
        for(AggregateResult  aggResult : [Select sum(Amount__c) amount
                                        From Opportunity_Forecast__c
                                        where Opportunity__r.OwnerId  =: sip.Plan_Participant__c
                                        And Fiscal_Year__c =: currentYear //9
                                        And Amount__c > 0 // 8 add lili 2013.11.22
                                        And Opportunity__r.Owner.GIBU__c = 'Industrial' //7 add lili 2013.11.22
                                        // modify by lili zhao 2014.5.23 ,due to add the new IND opp record types. begin
                                        //And (Opportunity__r.RecordType.DeveloperName = 'Opportunity_Engineering_Project' or Opportunity__r.RecordType.DeveloperName = 'Opportunity_Sales_Parts_Only')  //1                                                                
                                        And Opportunity__r.RecordTypeId IN : set_FESIPOppyRecordTypeId  //1 
                                        // end                                       
                                        And (Opportunity__r.Type != 'Transfer existing business' And Opportunity__r.Type != 'Defend Existing Business')  //2
                                        And (
                                            (
                                                (
                                                    (Part__r.Status__c IN ('Weak', '50/50', 'Likely', 'Commit'))//3
                                                    or
                                                    (
                                                        Part__r.Status__c = 'Won'//4
                                                        And 
                                                        Process_Status__c = 'Pre-Prod'//5
                                                    )
                                                )
                                                and
                                                Opportunity__r.Days_since_last_user_update__c <= 60//6
                                            )
                                            or
                                            (
                                                Part__r.Status__c = 'Won'//4                                                
                                                and 
                                                Part__r.Won_Fiscal_Year__c =: lastYear // add lili 2013.11.22
                                                //Part__r.Won_Date__c >=: lastFYStart add lili 2013.11.22
                                                //and 
                                                //Part__r.Won_Date__c <=: lastFYEnd
                                            )
                                        )
                                        ]) {
            sip.Prev_Year_Pipeline_YTD_Result_Dollar__c = (decimal) aggResult.get('amount');
        }       

        for(AggregateResult  aggResult : [Select sum(Amount__c) amount
                                        From Opportunity_Forecast__c
                                        where Opportunity__r.OwnerId  =: sip.Plan_Participant__c //11
                                        And Fiscal_Year__c =: nextYear  //9  2012
                                        And Amount__c > 0 // 8
                                        And Opportunity__r.Owner.GIBU__c = 'Industrial' //7
                                        // modify by lili zhao 2014.5.23 ,due to add the new IND opp record types.  begin
                                        //And (Opportunity__r.RecordType.DeveloperName = 'Opportunity_Engineering_Project' or Opportunity__r.RecordType.DeveloperName = 'Opportunity_Sales_Parts_Only')  //1 
                                        And Opportunity__r.RecordTypeId IN : set_FESIPOppyRecordTypeId  //1
                                        // end
                                        And (Opportunity__r.Type != 'Transfer existing business' And Opportunity__r.Type != 'Defend Existing Business') //2
                                        And (
                                            (
                                                (
                                                    (Part__r.Status__c IN ('Weak', '50/50', 'Likely', 'Commit'))  //3
                                                    or
                                                    (
                                                        Part__r.Status__c = 'Won'  //4
                                                        And 
                                                        Process_Status__c = 'Pre-Prod'  //5
                                                    )
                                                )
                                                and
                                                Opportunity__r.Days_since_last_user_update__c <= 60  //6
                                            )
                                            or
                                            (
                                                Part__r.Status__c = 'Won'  //4
                                                and 
                                                Part__r.Won_Fiscal_Year__c =: currentYear  //10                                         
                                            )
                                        )
                                        ]) {
            sip.Pipeline_Result__c = (decimal) aggResult.get('amount');
        }                   
            //===========================================================================================
            // for FE Opportunity conversion populate
            //===========================================================================================
            
        for(AggregateResult  aggResult : [Select sum(Amount__c) amount
                                        From Opportunity_Forecast__c
                                        where Opportunity__r.OwnerId  =: sip.Plan_Participant__c
                                        //modify by lili zhao 2014.5.23 ,due to add the new IND opp record types. begin
                                        //And (Opportunity__r.RecordType.DeveloperName = 'Opportunity_Engineering_Project' or Opportunity__r.RecordType.DeveloperName = 'Opportunity_Sales_Parts_Only') 
                                        And Opportunity__r.RecordTypeId IN : set_FESIPOppyRecordTypeId  
                                        // end
                                        And Part_Confidence__c = 'Won'
                                        //And Part__r.Process_Status__c IN ('Production', 'Ramp-down') //add lili 2013.11.29
                                        And Part__r.Process_Status__c IN ('Production', 'Ramp-down', 'EOL') // add lili 2013.11.29
                                        And (Opportunity__r.Type != 'Transfer existing business' And Opportunity__r.Type != 'Defend Existing Business')
                                        and Date__c >=: lastFYStart
                                        and Date__c <=: lastFYEnd
                                        And (
                                            (
                                                //Part__r.Won_Date__c >=: last2FYStart // add lili 2013.11.22
                                                //and  // add lili 2013.11.22
                                                //Won_Date__c <=: last2FYEnd // add lili 2013.11.22
                                                Part__r.Won_Fiscal_Year__c =: last2Year  // add lili 2013.11.22
                                                and 
                                                (
                                                    (
                                                        Part__r.Won_Fiscal_Quarter__c IN ('2', '02')
                                                        AND
                                                        Fiscal_Quarter__c IN ('1', '01')
                                                    )
                                                    or
                                                    (
                                                        Part__r.Won_Fiscal_Quarter__c IN ('3', '03')
                                                        AND
                                                        Fiscal_Quarter__c IN ('1', '01', '2', '02')                                                 
                                                    )
                                                    or
                                                    (
                                                        Part__r.Won_Fiscal_Quarter__c IN ('4', '04')
                                                        AND
                                                        Fiscal_Quarter__c IN ('1', '01', '2', '02', '3', '03')                                                  
                                                    )
                                                )
                                            )
                                            OR
                                            (
                                                //Part__r.Won_Date__c >=: lastFYStart   // add lili 2013.11.22
                                                //and    // add lili 2013.11.22
                                                //Part__r.Won_Date__c <=: lastFYEnd   // add lili 2013.11.22
                                                Part__r.Won_Fiscal_Year__c =: lastYear   // add lili 2013.11.22
                                                and 
                                                Fiscal_Year__c =: lastYear
                                                //Date__c >=: lastFYStart   // add lili 2013.11.22
                                                //and     // add lili 2013.11.22
                                                //Date__c <=: lastFYEnd   // add lili 2013.11.22
                                            )
                                        )
                                        
                                        ]) {
            sip.Prev_Year_Conversion_YTD_Result_Dollar__c = (decimal) aggResult.get('amount');
            
        }  
        
        for(AggregateResult  aggResult : [Select sum(Amount__c) amount
                                From Opportunity_Forecast__c
                                where Opportunity__r.OwnerId  =: sip.Plan_Participant__c //14
                                // modify by lili zhao 2014.5.23 ,due to add the new IND opp record types. begin
                                //And (Opportunity__r.RecordType.DeveloperName = 'Opportunity_Engineering_Project' or Opportunity__r.RecordType.DeveloperName = 'Opportunity_Sales_Parts_Only')  //1 
                                And Opportunity__r.RecordTypeId IN : set_FESIPOppyRecordTypeId  //1 
                                // end
                                And Part_Confidence__c = 'Won'  //2
                                //And Part__r.Process_Status__c IN ('Production', 'Ramp-down') //add lili 2013.11.29
                                And Part__r.Process_Status__c IN ('Production', 'Ramp-down', 'EOL') // add lili 2013.11.29
                                And (Opportunity__r.Type != 'Transfer existing business' And Opportunity__r.Type != 'Defend Existing Business')  //4
                                And Fiscal_Year__c =: currentYear  //13
                                And (
                                        Part__r.Won_Fiscal_Year__c =: currentYear // 12
                                        or Part__r.Won_Fiscal_Year__c =: lastYear  // 11
                                    ) 
                                And (
                                    (
                                        Part__r.Won_Fiscal_Year__c =: lastYear  // 11
                                        and 
                                        (
                                            (
                                                Part__r.Won_Fiscal_Quarter__c IN ('2', '02')  // 5
                                                AND
                                                Fiscal_Quarter__c IN ('1', '01')  // 6
                                            )
                                            or
                                            (
                                                Part__r.Won_Fiscal_Quarter__c IN ('3', '03')  // 7
                                                AND
                                                Fiscal_Quarter__c IN ('1', '01', '2', '02')  // 8                                           
                                            )
                                            or
                                            (
                                                Part__r.Won_Fiscal_Quarter__c IN ('4', '04')  // 9
                                                AND
                                                Fiscal_Quarter__c IN ('1', '01', '2', '02', '3', '03')   // 10                                              
                                            )
                                        )
                                    )
                                    OR
                                    (
                                        Part__r.Won_Fiscal_Year__c =: currentYear //12
                                        and
                                        Fiscal_Year__c =: currentYear  // 13
                                    )
                                )
                                
                                ]) {
           
            sip.Conversion_result__c = (decimal) aggResult.get('amount');   
        }                  
    }

    /**
     *  This trigger is used to sharing records to the plan participant, participants manager and plan approvers.
     *
     @  author Bin Yuan
     @  created 2013-09-09
     @  version 1.0  
     @  since 28.0 (Force.com ApiVersion)
     *
     @  changelog
     *  2012-09-09 Bin Yuan <bin.yuan@itbconsult.com>
     *  - Created
     */   
     public static void createSharingToParticipant(map<String,map<String, String>> map_sipId_map_userIds_access, map<String, SIP__c> map_sipId_sip) {
        
        list<SIP__Share> list_sipShare2Upsert = new list<SIP__Share>();
        map<String, SIP__Share> map_Id_sipShare2Delete = new map<String, SIP__Share>();
        map<String, map<String, SIP__Share>> map_sipId_userId_share = new map<String, map<String, SIP__Share>>();
        for(SIP__Share share : [Select Id, UserOrGroupId, ParentId, AccessLevel   
                                From SIP__Share 
                                Where ParentId IN : map_sipId_map_userIds_access.keySet() 
                                And RowCause =: 'Participant_And_Manager__c']) {
            if(!map_sipId_userId_share.containsKey(share.ParentId)) {
                map_sipId_userId_share.put(share.ParentId, new map<String, SIP__Share>());
            }
            map_sipId_userId_share.get(share.ParentId).put(share.UserOrGroupId, share);
        }
        system.debug('map_sipId_map_userIds_access:::: '+map_sipId_map_userIds_access);
        for(String sipId : map_sipId_map_userIds_access.keySet()) {
            for(String uId : map_sipId_map_userIds_access.get(sipId).keySet()) {
                if(map_sipId_userId_share.containsKey(sipId)) {
                    if(map_sipId_userId_share.get(sipId).containsKey(uId)){
                        if(map_sipId_userId_share.get(sipId).get(uId).AccessLevel != map_sipId_map_userIds_access.get(sipId).get(uId)) {
                            map_sipId_userId_share.get(sipId).get(uId).AccessLevel = (map_sipId_map_userIds_access.get(sipId).get(uId) == null ? 'Read' : map_sipId_map_userIds_access.get(sipId).get(uId));
                            list_sipShare2Upsert.add(map_sipId_userId_share.get(sipId).get(uId));
                        }
                        
                        //delete old users
                        for(String useId : map_sipId_userId_share.get(sipId).keySet()) {
                            if(!map_sipId_map_userIds_access.get(sipId).containsKey(useId) 
                                && map_sipId_sip.containsKey(sipId) 
                                && (map_sipId_sip.get(sipId).Plan_Participant__c != useId 
                                    || (!map_sipId_sip.get(sipId).Plan_Participant__r.isActive && map_sipId_sip.get(sipId).Plan_Participant__c == useId)) 
                                ) 
                            map_Id_sipShare2Delete.put(map_sipId_userId_share.get(sipId).get(useId).Id, map_sipId_userId_share.get(sipId).get(useId));
                        }
                    }else {
                        // insert share for new user
                        SIP__Share sipShare = new SIP__Share();
                        sipShare.ParentId = sipId;
                        sipShare.UserOrGroupId = uId;
                        sipShare.AccessLevel = (map_sipId_map_userIds_access.get(sipId).get(uId) == null ? 'Read' : map_sipId_map_userIds_access.get(sipId).get(uId));
                        sipShare.RowCause = 'Participant_And_Manager__c';
                        list_sipShare2Upsert.add(sipShare);
                        
                        //delete old users
                        for(String useId : map_sipId_userId_share.get(sipId).keySet()) {
                            if(!map_sipId_map_userIds_access.get(sipId).containsKey(useId) 
                                && map_sipId_sip.containsKey(sipId) 
                                && (map_sipId_sip.get(sipId).Plan_Participant__c != useId 
                                    || (!map_sipId_sip.get(sipId).Plan_Participant__r.isActive && map_sipId_sip.get(sipId).Plan_Participant__c == useId)) 
                                ) 
                            map_Id_sipShare2Delete.put(map_sipId_userId_share.get(sipId).get(useId).Id, map_sipId_userId_share.get(sipId).get(useId));
                        }
                    }
                }else {
                    // insert share for new user
                    SIP__Share sipShare = new SIP__Share();
                    sipShare.ParentId = sipId;
                    sipShare.UserOrGroupId = uId;   
                    sipShare.AccessLevel = (map_sipId_map_userIds_access.get(sipId).get(uId) == null ? 'Read' : map_sipId_map_userIds_access.get(sipId).get(uId));
                    sipShare.RowCause = 'Participant_And_Manager__c';
                    list_sipShare2Upsert.add(sipShare);
                        
                    //delete old users
                    //added lili zhao 2015-09-14 due to fix the bug of deleting all sharings
                    /*
                    for(String strSipId : map_sipId_userId_share.keySet()) {
                        for(string share : map_sipId_userId_share.get(strSipId).keySet()) {
                            map_Id_sipShare2Delete.put(map_sipId_userId_share.get(strSipId).get(share).Id, map_sipId_userId_share.get(strSipId).get(share));
                        }
                    }
                    */
                    //end
                }
            }
        }
        /*    
        for(String sipId : map_sipId_map_userIds_access.keySet()) {
            for(String uId : map_sipId_map_userIds_access.get(sipId).keySet()) {
                SIP__Share sipShare = new SIP__Share();
                sipShare.ParentId = sipId;
                sipShare.UserOrGroupId = uId;
                sipShare.AccessLevel = (map_sipId_map_userIds_access.get(sipId).get(uId) == null ? 'Read' : map_sipId_map_userIds_access.get(sipId).get(uId));
                sipShare.RowCause = 'Participant_And_Manager__c';
                list_sipShare2Insert.add(sipShare);
            }
        }
        
        if(!list_sipShare2Insert.isEmpty()) {
            insert list_sipShare2Insert;
        } 
        */
        system.debug('list_sipShare2Upsert:::: '+list_sipShare2Upsert);
        if(!list_sipShare2Upsert.isEmpty()) {
            upsert list_sipShare2Upsert;
        } 
        
        system.debug('map_Id_sipShare2Delete:::: '+map_Id_sipShare2Delete);
        if(!map_Id_sipShare2Delete.isEmpty()) {
            delete map_Id_sipShare2Delete.values();
        }       
     }
     
      /**
     *  This trigger is used to sharing records to the plan participant, participants manager and plan approvers.
     *
     @  author Bin Yuan
     @  created 2013-09-09
     @  version 1.0  
     @  since 28.0 (Force.com ApiVersion)
     *
     @  changelog
     *  2012-09-09 Bin Yuan <bin.yuan@itbconsult.com>
     *  - Created
     */   
     public static void sharingToParticipant(map<String,map<String, String>> map_sipId_map_userIds_access) {
        
        list<SIP__Share> list_sipShare2Insert = new list<SIP__Share>();
        for(String sipId : map_sipId_map_userIds_access.keySet()) {
            for(String uId : map_sipId_map_userIds_access.get(sipId).keySet()) {
                SIP__Share sipShare = new SIP__Share();
                sipShare.ParentId = sipId;
                sipShare.UserOrGroupId = uId;
                sipShare.AccessLevel = (map_sipId_map_userIds_access.get(sipId).get(uId) == null ? 'Read' : map_sipId_map_userIds_access.get(sipId).get(uId));
                sipShare.RowCause = 'Participant_And_Manager__c';
                list_sipShare2Insert.add(sipShare);
            }
        }
        if(!list_sipShare2Insert.isEmpty()) {
            insert list_sipShare2Insert;
        }       
     }
     
     /**
     *  This trigger is used to sharing records to the plan participant, participants manager and plan approvers.
     *
     @  author Bin Yuan
     @  created 2013-09-09
     @  version 1.0  
     @  since 28.0 (Force.com ApiVersion)
     *
     @  changelog
     *  2012-09-09 Bin Yuan <bin.yuan@itbconsult.com>
     *  - Created
     */   
     public static void deleteSharingToParticipant(set<Id> set_sipId) {
        
        map<String, SIP__Share> map_Id_sipShare2Delete = new map<String, SIP__Share>();
        set<Id> set_tempSipId = new set<Id>();
        set_tempSipId.addAll(set_sipId);
        
        for(SIP__Share share : [Select UserOrGroupId, ParentId, AccessLevel   
                                From SIP__Share 
                                Where ParentId IN : set_tempSipId  
                                And RowCause =: 'Participant_And_Manager__c']) {
            map_Id_sipShare2Delete.put(share.Id, share);
        }
        
        if(!map_Id_sipShare2Delete.isEmpty()) {
            delete map_Id_sipShare2Delete.values();
        }
     }
    /**
     *  This trigger is used to sharing records to the plan participant, participants manager and plan approvers.
     *
     @  author Bin Yuan
     @  created 2013-09-09
     @  version 1.0
     @  since 28.0 (Force.com ApiVersion)
     *
     @  changelog
     *  2012-09-09 Bin Yuan <bin.yuan@itbconsult.com>
     *  - Created
     */
     public static void removeSIPSharing(map<String,map<String, String>> map_sipId_map_userIds_access, set<String> set_userIds) {               
        list<SIP__Share> list_sipShare2Delete = new list<SIP__Share>();
        for(SIP__Share sipShare : [Select Id, ParentId, UserOrGroupId, AccessLevel, RowCause 
                                   From SIP__Share 
                                   Where ParentId IN : map_sipId_map_userIds_access.keySet() And UserOrGroupId IN : set_userIds and RowCause = 'Participant_And_Manager__c']) { 
            if(map_sipId_map_userIds_access.get(sipShare.ParentId).containsKey(sipShare.UserOrGroupId)) {               
                list_sipShare2Delete.add(sipShare);   
            }                          
        }
        if(!list_sipShare2Delete.isEmpty()) {
            delete list_sipShare2Delete;
        }       
     }   
    /**
     *  This trigger is used to sharing records to the plan participant, participants manager and plan approvers.
     *
     @  author Bin Yuan
     @  created 2013-09-09
     @  version 1.0
     @  since 28.0 (Force.com ApiVersion)
     *
     @  changelog
     *  2012-09-09 Bin Yuan <bin.yuan@itbconsult.com>
     *  - Created
     */
     public static void buildSharingMap(map<String, map<String, String>> map_sipId_map_userIds_access, SIP__c sip,String access, String userId) {
        if(!map_sipId_map_userIds_access.containsKey(sip.Id)) {
            map_sipId_map_userIds_access.put(sip.Id, new map<String, String>());
        }
        map_sipId_map_userIds_access.get(sip.Id).put(userId,access);
     }
     /**
     *  This trigger is used to get access from custom setting to the plan participant, participants manager and plan approvers.
     *
     @  author Lili Zhao
     @  created 2013-09-11
     @  version 1.0  
     @  since 28.0 (Force.com ApiVersion)
     *
     @  changelog
     *  2012-09-11 Lili Zhao <lili.zhao@itbconsult.com>
     *  - Created
     */
     public static map<String,String> getAccess() { 
        map<String,String> map_access = new map<String,String>();   
        if(SIP_Sharing_Setting__c.getInstance('Approver') != null && SIP_Sharing_Setting__c.getInstance('Approver').Value__c != null) {
            map_access.put('Approver',(String) SIP_Sharing_Setting__c.getInstance('Approver').Value__c);
       }
       if(SIP_Sharing_Setting__c.getInstance('Participant') != null && SIP_Sharing_Setting__c.getInstance('Participant').Value__c != null) {
            map_access.put('Participant',(String) SIP_Sharing_Setting__c.getInstance('Participant').Value__c);
       }
        if(SIP_Sharing_Setting__c.getInstance('Participant Manager') != null && SIP_Sharing_Setting__c.getInstance('Participant Manager').Value__c != null) {
            map_access.put('Participant Manager',(String) SIP_Sharing_Setting__c.getInstance('Participant Manager').Value__c);
       }        
       return map_access;      
    }
    
     /**
     *  This method was used to get PM recordtype developer names.
     *
     @  author Lili Zhao
     @  created 2013-09-11
     @  version 1.0  
     @  since 28.0 (Force.com ApiVersion)
     *
     @  changelog
     *  2012-09-11 Lili Zhao <lili.zhao@itbconsult.com>
     *  - Created
     */
     /*
    public static set<String> getPMRTNames() { 
        set<String> set_pmRTDeveloperNames = new set<String>();
        String str_rtNames = '';
        if(SIP_Sharing_Setting__c.getInstance('SIP PM RecordType DeveloperNames') != null && SIP_Sharing_Setting__c.getInstance('SIP PM RecordType DeveloperNames').Value__c != null) {
            str_rtNames = (String) SIP_Sharing_Setting__c.getInstance('SIP PM RecordType DeveloperNames').Value__c;
        }
        for(String name : str_rtNames.split(',')) {
            if(name != null && name.trim() != '') {
                set_pmRTDeveloperNames.add(name);
            }
        }
        return set_pmRTDeveloperNames;      
    }
    */
    /**
     *  This method was used to get PM recordtype developer names.
     *
     @  author Lili Zhao
     @  created 2015-08-20
     @  version 1.0  
     @  since 28.0 (Force.com ApiVersion)
     *
     @  changelog
     *  2015-08-20 Lili Zhao <lili.zhao@itbconsult.com>
     *  - Created
     */
    public static set<String> getPMAMOrFERTNames(String settingName) { 
        set<String> set_RTDeveloperNames = new set<String>();
        String str_rtNames = '';
        if(SIP_Sharing_Setting__c.getInstance(settingName) != null && SIP_Sharing_Setting__c.getInstance(settingName).Value__c != null) {
            str_rtNames = (String) SIP_Sharing_Setting__c.getInstance(settingName).Value__c;
        }
        for(String name : str_rtNames.split(',')) {
            if(name != null && name.trim() != '') {
                set_RTDeveloperNames.add(name);
            }
        }
        return set_RTDeveloperNames;      
    }
    
    public static void buildCodeMap(set<String> set_codes, map<Id, set<String>> map_sipId_set_codes, String str_code, String SipId) {
        if(str_code.contains(',')) {
            for(String code : str_code.split(',')) {
                set_codes.add(code);
                if(!map_sipId_set_codes.containsKey(SipId)) {
                    map_sipId_set_codes.put(SipId, new set<String>());
                }
                map_sipId_set_codes.get(SipId).add(code);
            }
        }
        else {
            set_codes.add(str_code);
            if(!map_sipId_set_codes.containsKey(SipId)) {
                map_sipId_set_codes.put(SipId, new set<String>());
            }
            map_sipId_set_codes.get(SipId).add(str_code);                       
        }       
    }

    /**
     *  This method is used to populat data for fields by using sip mapping & report.
     *
     @  author Bin Yuan
     @  created 2014-09-22
     @  version 1.0
     @  since 30.0 (Force.com ApiVersion)
     *
     @  changelog
     *  2014-09-22 Bin Yuan <bin.yuan@itbconsult.com>
     *  - Created
     */
     public static void populatReportLinkForSIP(SIP__c sip) {
        SIP_Mapping__c sipMapping;
        list<ReportMap> list_reportMaps = new list<ReportMap>();
        //Get related sip mapping obj
        for(SIP_Mapping__c mapping : [Select Report_Field_1__c, Report_Field_2__c, Report_Field_3__c, Report_Field_4__c, 
                                             Report_Field_5__c, Report_Field_6__c, Report_Field_7__c, Report_Field_8__c, 
                                             Report_Field_9__c, Report_Field_10__c, Report_Field_11__c, Report_Field_12__c, 
                                             Report_Field_13__c, Report_Field_14__c, Report_Field_15__c, 
                                             
                                             Report_ID_1__c, Report_ID_2__c, Report_ID_3__c, Report_ID_4__c, Report_ID_5__c, 
                                             Report_ID_6__c, Report_ID_7__c, Report_ID_8__c, Report_ID_9__c, Report_ID_10__c, 
                                             Report_ID_11__c, Report_ID_12__c, Report_ID_13__c, Report_ID_14__c, Report_ID_15__c, 
                                             
                                             Report_Parameters_1__c, Report_Parameters_2__c, Report_Parameters_3__c,
                                             Report_Parameters_4__c, Report_Parameters_5__c, Report_Parameters_6__c, 
                                             Report_Parameters_7__c, Report_Parameters_8__c, Report_Parameters_9__c, 
                                             Report_Parameters_10__c, Report_Parameters_11__c, Report_Parameters_12__c, 
                                             Report_Parameters_13__c, Report_Parameters_14__c, Report_Parameters_15__c, 
                                             
                                             Target_Field_1__c, Target_Field_2__c, Target_Field_3__c, Target_Field_4__c, 
                                             Target_Field_5__c, Target_Field_6__c, Target_Field_7__c, Target_Field_8__c, 
                                             Target_Field_9__c, Target_Field_10__c, Target_Field_11__c, Target_Field_12__c, 
                                             Target_Field_13__c, Target_Field_14__c, Target_Field_15__c,

                                             Target_Field_Name_1__c, Target_Field_Name_2__c, Target_Field_Name_3__c, Target_Field_Name_4__c,
                                             Target_Field_Name_5__c, Target_Field_Name_6__c, Target_Field_Name_7__c, Target_Field_Name_8__c, 
                                             Target_Field_Name_9__c, Target_Field_Name_10__c, Target_Field_Name_11__c, Target_Field_Name_12__c,
                                             Target_Field_Name_13__c, Target_Field_Name_14__c, Target_Field_Name_15__c
                                      From SIP_Mapping__c
                                      Where Id =: sip.SIP_Mapping__c]) {
            sipMapping = mapping;                             
        }
        
        //build report map
        buildReportMap(list_reportMaps, sipMapping, new set<String>());
        if(list_reportMaps.isEmpty()) {
            return;
        }
        //generate report links for each sip
        generateReportLinks(sip, list_reportMaps);
        system.debug('update sip :: ' + sip);
     }

    /**
     *  This method is used to populat data for fields by using sip mapping & report.
     *
     @  author Bin Yuan
     @  created 2014-09-22
     @  version 1.0
     @  since 30.0 (Force.com ApiVersion)
     *
     @  changelog
     *  2014-09-22 Bin Yuan <bin.yuan@itbconsult.com>
     *  - Created
     */
     /* commented by bin yuan 2016-05-12 due to remove unnecessary code
     
     public static void populatDataFromReport(SIP__c sip) {
        SIP_Mapping__c sipMapping;
        list<ReportMap> list_reportMaps = new list<ReportMap>();
        set<String> set_queryFields = new set<String>();
        //Get related sip mapping obj
        for(SIP_Mapping__c mapping : [Select Report_Field_1__c, Report_Field_2__c, Report_Field_3__c, Report_Field_4__c, 
                                             Report_Field_5__c, Report_Field_6__c, Report_Field_7__c, Report_Field_8__c, 
                                             Report_Field_9__c, Report_Field_10__c, Report_Field_11__c, Report_Field_12__c, 
                                             Report_Field_13__c, Report_Field_14__c, Report_Field_15__c, 
                                             
                                             Report_ID_1__c, Report_ID_2__c, Report_ID_3__c, Report_ID_4__c, Report_ID_5__c, 
                                             Report_ID_6__c, Report_ID_7__c, Report_ID_8__c, Report_ID_9__c, Report_ID_10__c, 
                                             Report_ID_11__c, Report_ID_12__c, Report_ID_13__c, Report_ID_14__c, Report_ID_15__c, 
                                             
                                             Report_Parameters_1__c, Report_Parameters_2__c, Report_Parameters_3__c,
                                             Report_Parameters_4__c, Report_Parameters_5__c, Report_Parameters_6__c, 
                                             Report_Parameters_7__c, Report_Parameters_8__c, Report_Parameters_9__c, 
                                             Report_Parameters_10__c, Report_Parameters_11__c, Report_Parameters_12__c, 
                                             Report_Parameters_13__c, Report_Parameters_14__c, Report_Parameters_15__c, 
                                             
                                             Target_Field_1__c, Target_Field_2__c, Target_Field_3__c, Target_Field_4__c, 
                                             Target_Field_5__c, Target_Field_6__c, Target_Field_7__c, Target_Field_8__c, 
                                             Target_Field_9__c, Target_Field_10__c, Target_Field_11__c, Target_Field_12__c, 
                                             Target_Field_13__c, Target_Field_14__c, Target_Field_15__c,

                                             Target_Field_Name_1__c, Target_Field_Name_2__c, Target_Field_Name_3__c, Target_Field_Name_4__c,
                                             Target_Field_Name_5__c, Target_Field_Name_6__c, Target_Field_Name_7__c, Target_Field_Name_8__c, 
                                             Target_Field_Name_9__c, Target_Field_Name_10__c, Target_Field_Name_11__c, Target_Field_Name_12__c,
                                             Target_Field_Name_13__c, Target_Field_Name_14__c, Target_Field_Name_15__c
                                      From SIP_Mapping__c
                                      Where Id =: sip.SIP_Mapping__c]) {
            sipMapping = mapping;                             
        }
        //build report map
        buildReportMap(list_reportMaps, sipMapping, set_queryFields);
        if(list_reportMaps.isEmpty()) {
            return;
        }
        //update sip record for required fields
        if(sip.Id != null) {
            String query = 'Select Id ' + getQueryString(set_queryFields) + ' From SIP__c Where Id =\'' + sip.Id + '\' ';
            sip = (SIP__c) database.query(query);
        }
        system.debug('list_reportMaps :: ' + list_reportMaps);
        //fill values for each different report
        for(ReportMap reportMap : list_reportMaps) {
            sip = (SIP__c) getReportData(reportMap, sip);
        }
        //generate report links for each sip
        generateReportLinks(sip, list_reportMaps);
        if(sip.Id != null) {
            update sip;
        }
        system.debug('update sip :: ' + sip);
     }
     */
    /**
     *  This method is used to populat data for fields by using sip mapping & report.
     *
     @  author Bin Yuan
     @  created 2014-09-22
     @  version 1.0
     @  since 30.0 (Force.com ApiVersion)
     *
     @  changelog
     *  2014-09-22 Bin Yuan <bin.yuan@itbconsult.com>
     *  - Created
     */
     public static Integer populatDataFromReportAsyn(map<String, SIP__c> map_sipId_sip, map<String, ClsSIPUitl.SIPCustomExcMSG> map_sipId_exception, 
                                                    map<String, list<ReportMap>> map_sipMappingId_list_reportMap, String sessionId) {
        Integer runningNumb = 0;
        set<String> set_tempSIPIds = new set<String>();
        set<String> set_queryFields = new set<String>();
        list<SIP__c> list_sips2Update = new list<SIP__c>();
        //build report mapping for the related sip mapping records
        generateReprotMappings(map_sipMappingId_list_reportMap, set_queryFields);
        system.debug('map_sipMappingId_list_reportMap :: ' + map_sipMappingId_list_reportMap);
        //query sip record for required fields
        set_tempSIPIds.addAll(map_sipId_sip.keySet());
        String query = 'Select Id, Is_Report_Finished__c, SIP_Report_Instance__c, Running_Number__c, SIP_Mapping__c, Recalculate__c ' 
                     + getQueryString(set_queryFields) 
                     + ' From SIP__c Where Id IN : set_tempSIPIds order by Running_Number__c';
        for(SIP__c sip : database.query(query)) {
            try {
                sip.Running_Number__c = null;
                if(!map_sipMappingId_list_reportMap.containsKey(sip.SIP_Mapping__c) 
                    || map_sipMappingId_list_reportMap.get(sip.SIP_Mapping__c).size() == 0) {
                    
                    continue;   
                }
                list<ReportMap> list_reportMaps = map_sipMappingId_list_reportMap.get(sip.SIP_Mapping__c);
                system.debug('list_reportMaps :: ' + list_reportMaps);
                //fill values for each different report
                sip.SIP_Report_Instance__c = '';
                sip.Is_Report_Finished__c = false;
                //sort report maps to combine callouts
                //list_reportMaps.sort();
                for(ReportMap reportMap : list_reportMaps) {
                    sip = (SIP__c) getReportDataAsyn(reportMap, sip, sessionId);
                }
                //generate report links for each sip
                generateReportLinks(sip, list_reportMaps);
                sip.Recalculate__c = (sip.Recalculate__c == false ? true : false);
                list_sips2Update.add(sip);
                runningNumb = Integer.valueOf(sip.Running_Number__c);
            }
            catch(Exception ex) {
                //Error handling
                if(!map_sipId_exception.containsKey(sip.Id)) {
                    map_sipId_exception.put(sip.Id, new SIPCustomExcMSG());
                }
                SIPCustomExcMSG msg = map_sipId_exception.get(sip.Id);
                msg.sipId = sip.Id;
                msg.errorMsg += ex.getMessage() + '\n';
            }
        }
        if(!list_sips2Update.isEmpty()) {
//            update list_sips2Update;
            Database.update(list_sips2Update,false); 
        }
        return runningNumb;
     }
     
    /**
     *  This method is used to generate ReprotMappings.
     *
     @  author Bin Yuan
     @  created 2014-09-22
     @  version 1.0
     @  since 30.0 (Force.com ApiVersion)
     *
     @  changelog
     *  2014-09-22 Bin Yuan <bin.yuan@itbconsult.com>
     *  - Created
     */
     public static void generateReprotMappings(map<String, list<ReportMap>> map_sipMappingId_list_reportMap, set<String> set_queryFields) {
        map<String, SIP_Mapping__c> map_sipMappingId_sipMapping = new map<String, SIP_Mapping__c>();
        //get sip mapping records for gaven sip mapping ids
        for(String sipMappingId : map_sipMappingId_list_reportMap.keySet()) {
            map_sipMappingId_sipMapping.put(sipMappingId, null);
        }
        getSIPMappingRecords(map_sipMappingId_sipMapping);
        //build report maps for sip mapping records
        for(SIP_Mapping__c sipMapping : map_sipMappingId_sipMapping.values()) {
            list<ReportMap> list_reportMaps = new list<ReportMap>();
            //build report map
            buildReportMap(list_reportMaps, sipMapping, set_queryFields);
            map_sipMappingId_list_reportMap.put(sipMapping.Id, list_reportMaps);
        }
     }
     
    /**
     *  This method is used to populat data for fields by using sip mapping & report.
     *
     @  author Bin Yuan
     @  created 2014-09-22
     @  version 1.0
     @  since 30.0 (Force.com ApiVersion)
     *
     @  changelog
     *  2014-09-22 Bin Yuan <bin.yuan@itbconsult.com>
     *  - Created
     */
     public static Integer fetchDataFromReportAsyn(map<String, SIP__c> map_sipId_sip, map<String, ClsSIPUitl.SIPCustomExcMSG> map_sipId_exception, String sessionId, set<String> set_queryFields) {
        list<SIP__c> list_sips2Update = new list<SIP__c>();
        set<String> set_tempSIPIds = new set<String>();
        Integer counter = 0;
        String query = 'Select Id, Is_Report_Finished__c, SIP_Report_Instance__c, Running_Number__c, SIP_Mapping__c, Recalculate__c ' 
                     + getQueryString(set_queryFields) 
                     + ' From SIP__c Where Id IN : set_tempSIPIds order by Running_Number__c';
        set_tempSIPIds.addAll(map_sipId_sip.keySet());
        
        for(SIP__c sip : database.query(query)) {
            counter = Integer.valueOf((sip.Running_Number__c > counter ? sip.Running_Number__c : counter));
            if(sip.SIP_Report_Instance__c == null || sip.SIP_Report_Instance__c.trim() == '') {
                sip.Is_Report_Finished__c = true;
                //added by bin yuan 2016-05-10 due to avoid validation rule when sip was locked
                sip.Recalculate__c = (sip.Recalculate__c == false ? true : false);
                //end
                list_sips2Update.add(sip);
                continue;
            }
            //added by bin yuan 2017-07-27 due to debug instance info
            system.debug('sip.SIP_Report_Instance__c :: ' + sip.SIP_Report_Instance__c);
            //End
            for(String reportInstance : sip.SIP_Report_Instance__c.split(';')) {
                Sobject sobj = (Sobject) sip;
                String sipReportInstance = (String) sobj.get('SIP_Report_Instance__c');
                String source = reportInstance.split(',')[0];
                String target = reportInstance.split(',')[1];
                String reportId = reportInstance.split(',')[2];
                String reportInstanceId = reportInstance.split(',')[3];
                try {
                    String sourceField = source.subStringBeforeLast('-').trim();
                    //Get report instance
                    String httpRes = postRESTAPIGetResultCallout(reportInstanceId, reportId, sessionId);
                    //added by bin yuan 2017-07-27 due to debug instance info
                    system.debug('httpRes ' + httpRes);
                    //End
                    SIPReportResult instance = new SIPReportResult();
                    try {
                        instance = parseReportJson(httpRes, sourceField);
                    }
                    catch(Exception ex) {
                        sipReportInstance = sipReportInstance.replace(reportInstance + ';', '');
                        sobj.put('SIP_Report_Instance__c', sipReportInstance);
                        sobj.put(target, null);
                        if(!map_sipId_exception.containsKey(sip.Id)) {
                            map_sipId_exception.put(sip.Id, new SIPCustomExcMSG());
                        }
                        SIPCustomExcMSG msg = map_sipId_exception.get(sip.Id);
                        msg.sipId = sip.Id;
                        msg.errorMsg += ex.getMessage() + '\n';
                        msg.errorMsg += httpRes + '\n';
                        system.debug('map_sipId_exception :: ' + map_sipId_exception);
                    }
                    
                    system.debug('instance :: ' + instance);
                    String status = instance.attributes.status;
                    if(status == 'New' || status == 'Running') {
                        continue;
                    }
                    if(status == 'Error') {
                        //Error handling
                        if(!map_sipId_exception.containsKey(sip.Id)) {
                            map_sipId_exception.put(sip.Id, new SIPCustomExcMSG());
                        }
                        SIPCustomExcMSG msg = map_sipId_exception.get(sip.Id);
                        msg.sipId = sip.Id;
                        msg.errorMsg += 'Report run error for report : ' + reportId + ' Instance: ' + reportInstanceId + '\n';
                    }
                    sipReportInstance = sipReportInstance.replace(reportInstance + ';', '');
                    sobj.put('SIP_Report_Instance__c', sipReportInstance);
                    if(status == 'Success') {
                        //fetch & fill report data into sip records
                        //Get report results
                        map<String, ResultFactValue> factMap = instance.factMap;
                        
                        system.debug('sourceField :: ' + sourceField);
                        system.debug('containmap :: ' + factMap.containsKey(sourceField));
                        if(!factMap.containsKey(sourceField.trim())) {
                            //Error handling
                            if(!map_sipId_exception.containsKey(sip.Id)) {
                                map_sipId_exception.put(sip.Id, new SIPCustomExcMSG());
                            }
                            SIPCustomExcMSG msg = map_sipId_exception.get(sip.Id);
                            msg.sipId = sip.Id;
                            msg.errorMsg += 'No such column: ' + sourceField.trim() + ' for report : ' + reportId + ' Instance: ' + reportInstanceId + '\n';
                            continue;
                        }
                        list<ResultFactAggregate> aggregates = factMap.get(sourceField).aggregates;
                        Integer sourceIndex = ((source.subStringAfterLast('-') == null || source.subStringAfterLast('-') == '') ? 0 : Integer.valueOf(source.subStringAfterLast('-').trim()));
                        if(aggregates == null || (aggregates.size() - 1 < sourceIndex)) {
                            //Error handling
                            if(!map_sipId_exception.containsKey(sip.Id)) {
                                map_sipId_exception.put(sip.Id, new SIPCustomExcMSG());
                            }
                            SIPCustomExcMSG msg = map_sipId_exception.get(sip.Id);
                            msg.sipId = sip.Id;
                            msg.errorMsg += 'Invaild target index for : ' + sourceField + ' for report : ' + reportId + ' Instance: ' + reportInstanceId + '\n';
                            continue;
                        }
                        system.debug('sourceIndex :: ' + sourceIndex);
                        if(aggregates == null || aggregates[sourceIndex].value == null) {
                            //Error handling
                            if(!map_sipId_exception.containsKey(sip.Id)) {
                                map_sipId_exception.put(sip.Id, new SIPCustomExcMSG());
                            }
                            SIPCustomExcMSG msg = map_sipId_exception.get(sip.Id);
                            msg.sipId = sip.Id;
                            msg.errorMsg += 'Invaild target index for : ' + sourceField + ' for report : ' + reportId + ' Instance: ' + reportInstanceId + '\n';
                            continue;
                        }
                        decimal value = (decimal) aggregates[sourceIndex].value ;
                        sobj.put(target, value);
                    }
                }
                catch(Exception ex) {
                    sipReportInstance = sipReportInstance.replace(reportInstance + ';', '');
                    sobj.put('SIP_Report_Instance__c', sipReportInstance);
                    sobj.put(target, null);
                    if(!map_sipId_exception.containsKey(sip.Id)) {
                        map_sipId_exception.put(sip.Id, new SIPCustomExcMSG());
                    }
                    SIPCustomExcMSG msg = map_sipId_exception.get(sip.Id);
                    msg.sipId = sip.Id;
                    msg.errorMsg += ex.getMessage() + '\n';
                    system.debug('map_sipId_exception :: ' + map_sipId_exception);
                }
                sip = (SIP__c) sobj;
            }
            sip.Recalculate__c = (sip.Recalculate__c == false ? true : false);
            sip.Running_Number__c = (sip.SIP_Report_Instance__c.trim() == '' ? null : (sip.Running_Number__c == null ? null : sip.Running_Number__c));
            sip.Is_Report_Finished__c = (sip.SIP_Report_Instance__c.trim() == '' ? true : false);
            list_sips2Update.add(sip);
        }
        
        if(!list_sips2Update.isEmpty()) {
//            update list_sips2Update;
        Database.update(list_sips2Update,false); 
        }
        return counter;
     }
    
    /**
     *  This method is used to build custom class ReportMap.
     *
     @  author Bin Yuan
     @  created 2014-09-22
     @  version 1.0
     @  since 30.0 (Force.com ApiVersion)
     *
     @  changelog
     *  2014-09-22 Bin Yuan <bin.yuan@itbconsult.com>
     *  - Created
     */
     public static void reScheduleJobToRunReport(boolean isBatchFinished, Integer previousRunningNumb, String sessionId, 
                                                    list<ClsSIPUitl.SIPCustomExcMSG> list_exceptions) {
        DateTime currTime = DateTime.now();
        currTime = (isBatchFinished ? currTime.addMinutes(2) : currTime.addHours(1));
        Integer min = currTime.minute();
        Integer hour = currTime.hour();
        Integer day = currTime.day();
        Integer month = currTime.month();
        String dayOfWeek= currTime.format('EEEE').subString(0, 3);
        Integer year = currTime.year();
        abortRunReportScheduledJob();
        //if batch is not finished run following batch job
        if(!isBatchFinished) {
            system.debug('batch not finished :::::: ');
            //Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
            //ClsSIPUitl.setScheduledJobSession(UserInfo.getSessionId());
            //String sch = '0 ' + '0' + ' ' + (hour + 1) + ' ' + day + ' ' + month + ' ? ' + year;
            String sch = '0 ' + 0 + ' ' + hour + ' ' + day + ' ' + month + ' ? ' + year;
            ClsScheduled_populateSIPDataFromReport cls = new ClsScheduled_populateSIPDataFromReport();
            String jobId = '';
            if(!Test.isRunningTest()) {
                jobId = system.schedule('ClsScheduled_populateSIPDataFromReport for ' + sch, sch, cls);
            }
            if(SIP_Sharing_Setting__c.getInstance('SIP Running Scheduled') != null) {
                SIP_Sharing_Setting__c setting = SIP_Sharing_Setting__c.getInstance('SIP Running Scheduled');
                setting.value__c = jobId;
                update setting;
            }
        }
        //if batch is finished run scheduled job to fetch report data
        else {
            system.debug('batch finished :::::: ');
            //Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
            //ClsSIPUitl.setScheduledJobSession(UserInfo.getSessionId());
            String sch = '0 ' + min + ' ' + hour + ' ' + day + ' ' + month + ' ? ' + year;
            ClsScheduled_fetchSIPReportResult cls = new ClsScheduled_fetchSIPReportResult();
            String jobId = '';
            if(!Test.isRunningTest()) {
                jobId = system.schedule('ClsScheduled_fetchSIPReportResult for ' + sch, sch, cls);
            }
            
            if(SIP_Sharing_Setting__c.getInstance('SIP Run Report Scheduled Job Id') != null) {
                SIP_Sharing_Setting__c setting = SIP_Sharing_Setting__c.getInstance('SIP Run Report Scheduled Job Id');
                setting.value__c = jobId;
                update setting;
            }
            // reset batch job start time
            SIP_Sharing_Setting__c setting;
            if(SIP_Sharing_Setting__c.getInstance('Fetch Job Start Time') != null) {
                setting = SIP_Sharing_Setting__c.getInstance('Fetch Job Start Time');
                setting.Job_Start_Time__c = system.now().addHours(1);
                update setting;
            }
            reportBatchStatus(list_exceptions, new set<String>(), true);
        }
     }
    /**
     *  This method is used to build custom class ReportMap.
     *
     @  author Bin Yuan
     @  created 2014-09-22
     @  version 1.0
     @  since 30.0 (Force.com ApiVersion)
     *
     @  changelog
     *  2014-09-22 Bin Yuan <bin.yuan@itbconsult.com>
     *  - Created
     */
     public static void reScheduleJobToFetchReportData(boolean isBatchFinished, String filter, map<String, ClsSIPUitl.SIPCustomExcMSG> map_sipId_exception, boolean isRecalc) {
        DateTime currTime = DateTime.now();
        currTime = currTime.addMinutes(2);
        Integer min = currTime.minute();
        Integer hour = currTime.hour();
        Integer day = currTime.day();
        Integer month = currTime.month();
        String dayOfWeek= currTime.format('EEEE').subString(0, 3);
        Integer year = currTime.year();
        //abort previous job
        abortPreviousScheduledJob();
        //if batch is not finished run following batch job
        if(!isBatchFinished) {
            boolean isNeedToKill = ClsSIPUitl.isKillFetchJob();
            //add batch job running time check
            if(isNeedToKill) {
                list<SIP__c> list_sips2Update = new list<SIP__c>();
                String currentYear = ClsSIPUitl.getCurrentFiscalYear();
                for(SIP__c sip : [Select Id, Running_Number__c, SIP_Mapping__c,SIP_Report_Instance__c
                                  From SIP__c
                                  where Exclude_From_Automatic_Update__c = false and SIP_Mapping__c != null 
                                  And Is_Report_Finished__c = false ]) {
                    
                    sip.SIP_Report_Instance__c = '';
                    sip.Is_Report_Finished__c = true;
                    ClsSIPUitl.SIPCustomExcMSG msg = new ClsSIPUitl.SIPCustomExcMSG();
                    msg.sipId = sip.Id;
                    msg.errorMsg = 'This batch has exceed the max running time. ' + '\n';
                    map_sipId_exception.put(sip.Id, msg);
                    list_sips2Update.add(sip);
                }
                if(!list_sips2Update.isEmpty()) {
//                    update list_sips2Update;
                Database.update(list_sips2Update,false);
                }
                // reset batch job start time
                SIP_Sharing_Setting__c setting;
                if(SIP_Sharing_Setting__c.getInstance('Fetch Job Start Time') != null) {
                    setting = SIP_Sharing_Setting__c.getInstance('Fetch Job Start Time');
                    setting.Job_Start_Time__c = null;
                    update setting;
                }
                reportBatchStatus(map_sipId_exception.values(), new set<String>(), false);
            }
            else {
                ClsBatch_fetchSIPReportResult batchJob = new ClsBatch_fetchSIPReportResult();
                batchJob.isRecalc = isRecalc;
                batchJob.filter = (filter == '' ? '' : filter);
                batchJob.map_sipId_exception = map_sipId_exception;
                Database.executeBatch(batchJob, 10);
            }
        }
        else if(!isRecalc && isBatchFinished) {
            reportBatchStatus(map_sipId_exception.values(), new set<String>(), false);
        }
        /*
        else{
            if(totalNumber == 0) 
            system.debug('batch finished :::::: ');
            
            //Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
            String sch = '0 ' + min + ' ' + hour + ' ' + day + ' ' + month + ' ? ' + year;
            ClsScheduled_fetchSIPReportResult cls = new ClsScheduled_fetchSIPReportResult();
            String jobId = system.schedule('ClsScheduled_fetchSIPReportResult for ' + sch, sch, cls);
            
            if(SIP_Sharing_Setting__c.getInstance('SIP Run Report Scheduled Job Id') != null) {
                SIP_Sharing_Setting__c setting = SIP_Sharing_Setting__c.getInstance('SIP Run Report Scheduled Job Id');
                setting.value__c = jobId;
                update setting;
            }
        }
        */
     }
     
    /**
     *  This method is used to build custom class ReportMap.
     *
     @  author Bin Yuan
     @  created 2014-09-22
     @  version 1.0
     @  since 30.0 (Force.com ApiVersion)
     *
     @  changelog
     *  2014-09-22 Bin Yuan <bin.yuan@itbconsult.com>
     *  - Created
     */
     public static void abortPreviousScheduledJob() {
        if(SIP_Sharing_Setting__c.getInstance('SIP Run Report Scheduled Job Id') != null) {
            SIP_Sharing_Setting__c setting = SIP_Sharing_Setting__c.getInstance('SIP Run Report Scheduled Job Id');
            if(setting.value__c != null && String.valueOf(setting.value__c).trim() != '') {
                if(!Test.isRunningTest()) {
                    system.abortJob(setting.value__c);
                }
                setting.value__c = '';
                update setting;
            }
        }
     }
     
    /**
     *  This method is used to build custom class ReportMap.
     *
     @  author Bin Yuan
     @  created 2014-09-22
     @  version 1.0
     @  since 30.0 (Force.com ApiVersion)
     *
     @  changelog
     *  2014-09-22 Bin Yuan <bin.yuan@itbconsult.com>
     *  - Created
     */
     public static void abortRunReportScheduledJob() {
        if(SIP_Sharing_Setting__c.getInstance('SIP Running Scheduled') != null) {
            SIP_Sharing_Setting__c setting = SIP_Sharing_Setting__c.getInstance('SIP Running Scheduled');
            if(setting.value__c != null && String.valueOf(setting.value__c).trim() != '') {
                if(!Test.isRunningTest()) {
                    system.abortJob(setting.value__c);
                }
                setting.value__c = '';
                update setting;
            }
        }
     }
     
    /**
     *  This method is used to build custom class ReportMap.
     *
     @  author Bin Yuan
     @  created 2014-09-22
     @  version 1.0
     @  since 30.0 (Force.com ApiVersion)
     *
     @  changelog
     *  2014-09-22 Bin Yuan <bin.yuan@itbconsult.com>
     *  - Created
     */
     /*Comment by Bin Yuan due to remove unnecessary code
     
     
     public static String getScheduledJobSession() {
        String sessionId = '';
        if(SIP_Sharing_Setting__c.getInstance('SIP Run Report Session Id') != null) {
            SIP_Sharing_Setting__c setting = SIP_Sharing_Setting__c.getInstance('SIP Run Report Session Id');
            if(setting != null && String.valueOf(setting.value__c).trim() != '') {
                sessionId = setting.value__c.trim();
            }
        }
        return sessionId;
     }
     */
    /**
     *  This method is used to build custom class ReportMap.
     *
     @  author Bin Yuan
     @  created 2014-09-22
     @  version 1.0
     @  since 30.0 (Force.com ApiVersion)
     *
     @  changelog
     *  2014-09-22 Bin Yuan <bin.yuan@itbconsult.com>
     *  - Created
     */
     /*Comment by Bin Yuan due to remove unnecessary code
     
     public static void setScheduledJobSession(String sessionId) {
        if(SIP_Sharing_Setting__c.getInstance('SIP Run Report Session Id') != null) {
            SIP_Sharing_Setting__c setting = SIP_Sharing_Setting__c.getInstance('SIP Run Report Session Id');
            if(setting != null) {
                setting.value__c = sessionId;
                update setting;
            }
        }
     }
     */
    /**
     *  This method is used to build custom class ReportMap.
     *
     @  author Bin Yuan
     @  created 2014-09-22
     @  version 1.0
     @  since 30.0 (Force.com ApiVersion)
     *
     @  changelog
     *  2014-09-22 Bin Yuan <bin.yuan@itbconsult.com>
     *  - Created
     */
     public static void buildReportMap(list<ReportMap> list_reportMaps, SIP_Mapping__c sipMapping, set<String> set_queryFields) {
        if(sipMapping == null) {
            return;
        }
        Sobject sobj = (Sobject) sipMapping;
        map<String, ReportMap> map_reportKey_reportMap = new map<String, ReportMap>();
        list<String> list_reportKeys = new list<String>();
        for(Integer i = 1; i <= 15; i++) {
            system.debug('sip mapping sobj :: ' + sobj);
            String sourceField = 'Report_Field_' + i + '__c';
            String reportIdField = 'Report_ID_' + i + '__c';
            String reportParamField = 'Report_Parameters_' + i + '__c';
            String targetField = 'Target_Field_' + i + '__c';
            String targetNameField = 'Target_Field_Name_' + i + '__c';
            system.debug('sourceField :: ' + sourceField);
            system.debug('reportIdField :: ' + reportIdField);
            system.debug('reportParamField :: ' + reportParamField);
            system.debug('targetField :: ' + targetField);
            String reportId = (String) sobj.get(reportIdField);
            String source = (String) sobj.get(sourceField);
            String target = (String) sobj.get(targetField);
            String targetName = (String) (sobj.get(targetNameField) == null ? '' : sobj.get(targetNameField));
            String str_reportFilter = (sobj.get(reportParamField) == null ? '' : String.valueOf(sobj.get(reportParamField)));
            if(reportId == null || reportId.trim() == '') {
                continue;
            }
            String reportKey = reportId + '_' + str_reportFilter;
            if(!map_reportKey_reportMap.containsKey(reportKey)) {
                map_reportKey_reportMap.put(reportKey, new ReportMap());
                list_reportKeys.add(reportKey);
            }
            ReportMap reportMap = map_reportKey_reportMap.get(reportKey);
            reportMap.reportId = reportId;
            //build report filters
            if(str_reportFilter.trim() != '') {
                for(String filterValue : str_reportFilter.split(';')) {
                    String filterNumb = filterValue.split(',')[1];
                    String value = filterValue.split(',')[0];
                    reportMap.map_filterNumb_filterValue.put(Integer.valueOf(filterNumb), value.trim());
                    set_queryFields.add(value.trim().toLowerCase());
                }
            }
            //reportMap.targetFieldName = targetName;
            if(targetName.trim() != '') {
                reportMap.list_targetFieldNames.add(targetName);
            }
            //build source & target fields
            if(source != null && source.trim() != '' && target != null && target.trim() != '') {
                reportMap.map_sourceField_targetField.put(source.trim(), target.trim());
                set_queryFields.add(target.trim().toLowerCase());
            }           
        } 
        for(String reportKey : list_reportKeys) {
            list_reportMaps.add(map_reportKey_reportMap.get(reportKey));
        }
     }
    /**
     *  This method is used to build custom class ReportMap.
     *
     @  author Bin Yuan
     @  created 2014-09-22
     @  version 1.0
     @  since 30.0 (Force.com ApiVersion)
     *
     @  changelog
     *  2014-09-22 Bin Yuan <bin.yuan@itbconsult.com>
     *  - Created
     */
     public static void buildReportMap(list<ReportMap> list_reportMaps, SIP_Mapping__c sipMapping, set<String> set_queryFields, SIP__c sip) {
        if(sipMapping == null) {
            return;
        }
        Sobject sobj = (Sobject) sipMapping;
        for(Integer i = 1; i <= 15; i++) {
            system.debug('sip mapping sobj :: ' + sobj);
            String sourceField = 'Report_Field_' + i + '__c';
            String reportIdField = 'Report_ID_' + i + '__c';
            String reportParamField = 'Report_Parameters_' + i + '__c';
            String targetField = 'Target_Field_' + i + '__c';
            String targetNameField = 'Target_Field_Name_' + i + '__c';
            system.debug('sourceField :: ' + sourceField);
            system.debug('reportIdField :: ' + reportIdField);
            system.debug('reportParamField :: ' + reportParamField);
            system.debug('targetField :: ' + targetField);
            String reportId = (String) sobj.get(reportIdField);
            String source = (String) sobj.get(sourceField);
            String target = (String) sobj.get(targetField);
            String targetName = (String) (sobj.get(targetNameField) == null ? '' : sobj.get(targetNameField));
            if(reportId == null || reportId.trim() == '') {
                continue;
            }
            ReportMap reportMap = new ReportMap();
            reportMap.reportId = reportId;
            //build report filters
            if(sobj.get(reportParamField) != null && String.valueOf(sobj.get(reportParamField)).trim() != '') {
                for(String filterValue : String.valueOf(sobj.get(reportParamField)).split(';')) {
                    String filterNumb = filterValue.split(',')[1];
                    String value = filterValue.split(',')[0];
                    reportMap.map_filterNumb_filterValue.put(Integer.valueOf(filterNumb), value.trim());
                    set_queryFields.add(value);
                }
            }
            //reportMap.targetFieldName = targetName;
            if(targetName.trim() != '') {
                reportMap.list_targetFieldNames.add(targetName);
            }
            //build source & target fields
            if(source != null && source.trim() != '' && target != null && target.trim() != '') {
                reportMap.map_sourceField_targetField.put(source.trim(), target.trim());
                set_queryFields.add(target);
            }           
            list_reportMaps.add(reportMap);
        } 
     }
    
    /**
     *  This method is used to get values from report.
     *
     @  author Bin Yuan
     @  created 2014-09-22
     @  version 1.0
     @  since 30.0 (Force.com ApiVersion)
     *
     @  changelog
     *  2014-09-22 Bin Yuan <bin.yuan@itbconsult.com>
     *  - Created
     */
     /*commented by Bin Yuan due to remove unnecessary code
     public static Sobject getReportData(ReportMap reportMap, SIP__c sip) {
        Sobject sobj = (Sobject) sip;
        // Get the report metadata
        Reports.ReportDescribeResult describe = Reports.ReportManager.describeReport(reportMap.reportId);
        Reports.ReportMetadata reportMd = describe.getReportMetadata();
        // get filter 
        list<Reports.ReportFilter> list_filters = reportMd.getReportFilters();
        // Override filter and run report
        for(Integer counter = 0; counter < list_filters.size(); counter ++){
            if(reportMap.map_filterNumb_filterValue.containsKey(counter + 1) && sobj.get(reportMap.map_filterNumb_filterValue.get(counter + 1)) != null) {
                
                Reports.ReportFilter filter = list_filters[counter];
                filter.setValue(String.valueOf(sobj.get(reportMap.map_filterNumb_filterValue.get(counter + 1))).replaceAll(';', ','));
            }
        }
        //Get report results
        Reports.ReportResults results = Reports.ReportManager.runReport(reportMap.reportId, reportMd);
        for(String source : reportMap.map_sourceField_targetField.keySet()) {
            String sourceField = source.subStringBeforeLast('-');
            Integer sourceIndex = ((source.subStringAfterLast('-') == null || source.subStringAfterLast('-') == '') ? 0 : Integer.valueOf(source.subStringAfterLast('-').trim()));
            Reports.ReportFactWithSummaries factSum = (Reports.ReportFactWithSummaries) results.getFactMap().get(sourceField.trim());
            if(factSum == null || factSum.getAggregates()[sourceIndex].getValue() == null) {
                continue;
            }
            decimal value = (decimal) factSum.getAggregates()[sourceIndex].getValue() ; 
            sobj.put(reportMap.map_sourceField_targetField.get(source), value);
        }
        return sobj;
     }
     */
    /**
     *  This method is used to get values from report.
     *
     @  author Bin Yuan
     @  created 2014-09-22
     @  version 1.0
     @  since 30.0 (Force.com ApiVersion)
     *
     @  changelog
     *  2014-09-22 Bin Yuan <bin.yuan@itbconsult.com>
     *  - Created
     */
     public static Sobject getReportDataAsyn(ReportMap reportMap, SIP__c sip, String sessionId) {
        Sobject sobj = (Sobject) sip;
        // Get the report metadata
        Reports.ReportDescribeResult describe = Reports.ReportManager.describeReport(reportMap.reportId);
        Reports.ReportMetadata reportMd = describe.getReportMetadata();
        Reports.ReportExtendedMetadata extendedReportMd = describe.getReportExtendedMetadata();
        Reports.ReportTypeMetadata reportTypeMd = describe.getReportTypeMetadata();
        
        // get filter 
        list<Reports.ReportFilter> list_filters = reportMd.getReportFilters();
        system.debug('list_filters :: ' + list_filters);
        // Override filter and run report
        for(Integer counter = 0; counter < list_filters.size(); counter ++){
            if(reportMap.map_filterNumb_filterValue.containsKey(counter + 1) && sobj.get(reportMap.map_filterNumb_filterValue.get(counter + 1)) != null) {
                
                Reports.ReportFilter filter = list_filters[counter];
                /*
                //Added by Bin Yuan 2016-0-03 due to fix api __c issue
                String str_filterAPI = filter.getColumn();
                String str_filterAPILowCase = str_filterAPI.toLowerCase();
                system.debug('str_filterAPI :: ' + str_filterAPI);
                if(str_filterAPILowCase.contains('__c.')) {
                    str_filterAPILowCase = str_filterAPILowCase.replace('__c.', '__r.');
                    system.debug('str_filterAPI :: ' + str_filterAPI);
                    filter.setColumn(str_filterAPILowCase);
                }
                //end
                */
                filter.setValue(String.valueOf(sobj.get(reportMap.map_filterNumb_filterValue.get(counter + 1))).replaceAll(';', ','));
            }
        }
        // Run the Report Asynchronously
        Reports.ReportInstance instance = (Reports.ReportInstance) Json.deserialize(postRESTAPIRunCallout(describe, reportMap.reportId, sessionId), Reports.ReportInstance.class);
        
        reportMap.reportInstanceId = instance.getId();
        sobj.put('Is_Report_Finished__c', false);
        for(String source : reportMap.map_sourceField_targetField.keySet()) {
            //sample : source(with index),targetField,reportId,reportInstanceId
            String temp = (String) (sobj.get('SIP_Report_Instance__c') == null ? '' : sobj.get('SIP_Report_Instance__c'));
            temp += source + ',' + reportMap.map_sourceField_targetField.get(source) + ',' + reportMap.reportId + ',' + reportMap.reportInstanceId + ';';
            sobj.put('SIP_Report_Instance__c', temp);
        }
        return sobj;
     }
     

   /**
    *  This method is used to populat report link for related sip records.
    *
    @  author Bin Yuan
    @  created 2014-09-24
    @  version 1.0
    @  since 30.0 (Force.com ApiVersion)
    *
    @  changelog
    *  2014-09-24 Bin Yuan <bin.yuan@itbconsult.com>
    *  - Created
    */
    public static String postRESTAPIRunCallout(Reports.ReportDescribeResult describe, String reportId, String sessionId) {
        String endPoint = getCalloutEndPoint();//URL.getSalesforceBaseUrl().toExternalForm();
        Http http = new Http();
        HttpRequest httpReq = new HttpRequest();
        HttpResponse httpRes = new HttpResponse();
        //httpRes.setHeader('Content-Type', 'application/x-www-form-urlencoded;');
        //httpRes.setHeader('Accept', 'application/json;');
        httpReq.setMethod('POST');
        httpReq.setHeader('Authorization', 'Bearer ' + sessionId);
        httpReq.setHeader('Content-Type', 'application/json');
        //system.debug('reportMd :: ' + reportMd);
        //set filter
        ReportRequestBody customBody = new ReportRequestBody();
        
        ReportRequestMetadata customMeata = new ReportRequestMetadata();
        customMeata.name = describe.getReportMetadata().getName();
        customMeata.id = describe.getReportMetadata().getId();
        //customMeata.STRCURRENCY = describe.getReportMetadata().getCurrencyCode();
        //customMeata.reportFormat = describe.getReportMetadata().getReportFormat();
        //customMeata.developerName = describe.getReportMetadata().getDeveloperName();
        //customMeata.reportType = describe.getReportMetadata().getReportType();
        //customMeata.aggregates = describe.getReportMetadata().getAggregates();
        //customMeata.groupingsDown = describe.getReportMetadata().getGroupingsDown();
        //customMeata.groupingsAcross = describe.getReportMetadata().getGroupingsAcross();
        customMeata.reportBooleanFilter = describe.getReportMetadata().getReportBooleanFilter();
        customMeata.reportFilters = describe.getReportMetadata().getReportFilters();
        system.debug('customMeata.reportFilters :: ' + customMeata.reportFilters);
        //customMeata.detailColumns = describe.getReportMetadata().getDetailColumns();
        customMeata.historicalSnapshotDates = describe.getReportMetadata().getHistoricalSnapshotDates();
        customBody.reportMetadata = customMeata;
        httpReq.setBody(Json.serialize(customBody).replace('STRCURRENCY', 'currency'));
        //httpReq.setBody('{\'reportExtendedMetadata\':' + Json.serialize(extendedReportMd));
        //httpReq.setBody('{\'reportTypeMetadata\':' + Json.serialize(reportTypeMd));
        httpReq.setEndpoint(endPoint + '/services/data/v30.0/analytics/reports/' + reportId + '/instances?includeDetails=true');

        httpReq.setTimeout(120000);
        httpRes = http.send(httpReq);
        system.debug('response :: ' + httpRes.getBody());
        return httpRes.getBody();
    }
    
   /**
    *  This method is used to populat report link for related sip records.
    *
    @  author Bin Yuan
    @  created 2014-09-24
    @  version 1.0
    @  since 30.0 (Force.com ApiVersion)
    *
    @  changelog
    *  2014-09-24 Bin Yuan <bin.yuan@itbconsult.com>
    *  - Created
    */
    public static String postRESTAPIGetResultCallout(String instanceId, String reportId, String sessionId) {
        String endPoint = getCalloutEndPoint();//URL.getSalesforceBaseUrl().toExternalForm(); 
        Http http = new Http();
        HttpRequest httpReq = new HttpRequest();
        HttpResponse httpRes = new HttpResponse();
       
        httpReq.setMethod('GET');
        httpReq.setHeader('Authorization', 'Bearer ' + sessionId);
        httpReq.setEndpoint(endPoint + '/services/data/v30.0/analytics/reports/' + reportId + '/instances/' + instanceId);
        httpReq.setTimeout(120000);
        httpRes = http.send(httpReq);

        return httpRes.getBody();
    }
   /**
    *  This method is used to populat report link for related sip records.
    *
    @  author Bin Yuan
    @  created 2014-09-24
    @  version 1.0
    @  since 30.0 (Force.com ApiVersion)
    *
    @  changelog
    *  2014-09-24 Bin Yuan <bin.yuan@itbconsult.com>
    *  - Created
    */
    public static void getSIPMappingRecords(map<String, SIP_Mapping__c> map_sipMappingId_sipMapping) {
        set<String> set_sipMappingIds = new set<String>();
        
        set_sipMappingIds.addAll(map_sipMappingId_sipMapping.keySet());
        
        for(SIP_Mapping__c sipMapping : [Select Report_Field_1__c, Report_Field_2__c, Report_Field_3__c, Report_Field_4__c, 
                                             Report_Field_5__c, Report_Field_6__c, Report_Field_7__c, Report_Field_8__c, 
                                             Report_Field_9__c, Report_Field_10__c, Report_Field_11__c, Report_Field_12__c, 
                                             Report_Field_13__c, Report_Field_14__c, Report_Field_15__c, 
                                             
                                             Report_ID_1__c, Report_ID_2__c, Report_ID_3__c, Report_ID_4__c, Report_ID_5__c, 
                                             Report_ID_6__c, Report_ID_7__c, Report_ID_8__c, Report_ID_9__c, Report_ID_10__c, 
                                             Report_ID_11__c, Report_ID_12__c, Report_ID_13__c, Report_ID_14__c, Report_ID_15__c, 
                                             
                                             Report_Parameters_1__c, Report_Parameters_2__c, Report_Parameters_3__c,
                                             Report_Parameters_4__c, Report_Parameters_5__c, Report_Parameters_6__c, 
                                             Report_Parameters_7__c, Report_Parameters_8__c, Report_Parameters_9__c, 
                                             Report_Parameters_10__c, Report_Parameters_11__c, Report_Parameters_12__c, 
                                             Report_Parameters_13__c, Report_Parameters_14__c, Report_Parameters_15__c, 
                                             
                                             Target_Field_1__c, Target_Field_2__c, Target_Field_3__c, Target_Field_4__c, 
                                             Target_Field_5__c, Target_Field_6__c, Target_Field_7__c, Target_Field_8__c, 
                                             Target_Field_9__c, Target_Field_10__c, Target_Field_11__c, Target_Field_12__c, 
                                             Target_Field_13__c, Target_Field_14__c, Target_Field_15__c,
                                             
                                             Target_Field_Name_1__c, Target_Field_Name_2__c, Target_Field_Name_3__c, Target_Field_Name_4__c,
                                             Target_Field_Name_5__c, Target_Field_Name_6__c, Target_Field_Name_7__c, Target_Field_Name_8__c, 
                                             Target_Field_Name_9__c, Target_Field_Name_10__c, Target_Field_Name_11__c, Target_Field_Name_12__c,
                                             Target_Field_Name_13__c, Target_Field_Name_14__c, Target_Field_Name_15__c
                                             
                                      From SIP_Mapping__c
                                      Where Id IN : set_sipMappingIds]) {
        map_sipMappingId_sipMapping.put(sipMapping.Id, sipMapping);                               
    }
    }
   /**
    *  This method is used to populat report link for related sip records.
    *
    @  author Bin Yuan
    @  created 2014-09-24
    @  version 1.0
    @  since 30.0 (Force.com ApiVersion)
    *
    @  changelog
    *  2014-09-24 Bin Yuan <bin.yuan@itbconsult.com>
    *  - Created
    */
    public static void populateSIPReportLink(map<String, SIP_Mapping__c> map_sipMappingId_sipMapping, set<String> set_sipIds) {
        set<String> set_tempSIPIds = new set<String>();
        set<String> set_sipMapingIds = map_sipMappingId_sipMapping.keySet();
        set<String> set_queryFields = new set<String>();
        String str_sipQuery = '';
        
        map<String, list<ReportMap>> map_sipMappingId_list_reportMaps
            = new map<String, list<ReportMap>>();
        list<SIP__c> list_sips2Updata = new list<SIP__c>();
        
        set_tempSIPIds.addAll(set_sipIds);
        //get sip mapping
        for(String sipMappingId : map_sipMappingId_sipMapping.keySet()) {
            SIP_Mapping__c sipMapping = map_sipMappingId_sipMapping.get(sipMappingId);
            list<ReportMap> list_reportMaps = new list<ReportMap>();
            //build report map
            buildReportMap(list_reportMaps, sipMapping, set_queryFields);
            map_sipMappingId_list_reportMaps.put(sipMappingId, list_reportMaps);
        }
        //get related sip records
        str_sipQuery = 'Select Id, SIP_Mapping__c, Report_Links__c ' + getQueryString(set_queryFields) + ' From SIP__c Where SIP_Mapping__c IN : set_sipMapingIds ';
        str_sipQuery += (set_tempSIPIds.isEmpty() ? '' : ' And Id IN : set_tempSIPIds ');
        for(SIP__c sip : database.query(str_sipQuery)) {
            //generate report links for each sip
            generateReportLinks(sip, map_sipMappingId_list_reportMaps.get(sip.SIP_Mapping__c));
            sip.Recalculate__c = (sip.Recalculate__c == false ? true : false);
            list_sips2Updata.add(sip);
        }
        update list_sips2Updata;
    }
    
   /**
    *  This method is used to populat report link for related sip records.
    *
    @  author Bin Yuan
    @  created 2014-09-24
    @  version 1.0
    @  since 30.0 (Force.com ApiVersion)
    *
    @  changelog
    *  2014-09-24 Bin Yuan <bin.yuan@itbconsult.com>
    *  - Created
    */
    public static void generateReportLinks(SIP__c sip, list<ReportMap> list_reportMaps) {
        //clear sip report link field
        sip.Report_Links__c = '';
        for(ReportMap reportMap : list_reportMaps) {
            for(String targetName : reportMap.list_targetFieldNames) {
                Sobject sobj = (Sobject) sip;
                system.debug('sobj :: ' + sobj);
                if(targetName == '') {
                    continue;
                }
                String link = '<a href="REPORTURL" target="_blank">' + targetName + '<br></a>';
                String reportUrl = '/' + reportMap.reportId + '?';
                for(Integer parmNumb : reportMap.map_filterNumb_filterValue.keySet()) {
                    if(sobj.get(reportMap.map_filterNumb_filterValue.get(parmNumb)) == null) {
                        continue;
                    }
                    String parm = String.valueOf(sobj.get(reportMap.map_filterNumb_filterValue.get(parmNumb))).replaceAll(';', ',');
                    //replace & with %26
                    parm = parm.replaceAll('&', '%26');
                    reportUrl += 'pv' + (parmNumb - 1) + '=' + parm + '&';
                }
                reportUrl = reportUrl.subStringBeforeLast('&');
                link = link.replace('REPORTURL', reportUrl);
                sip.Report_Links__c += link;
            }
        }
    }

   /**
    *  This method is used to get PM sip record type id.
    *
    @  author Bin Yuan
    @  created 2014-09-24
    @  version 1.0
    @  since 30.0 (Force.com ApiVersion)
    *
    @  changelog
    *  2014-09-24 Bin Yuan <bin.yuan@itbconsult.com>
    *  - Created
    */
    public static set<Id> getPMRTId() {
        set<Id> set_pmRTIds = new set<Id>();
        set<String> pmRTDeveloperName = getPMAMOrFERTNames('SIP PM RecordType DeveloperNames');// modify by lili zhao 2015-08-20 

        //for(RecordType rt : [Select Id From RecordType Where SobjectType = 'SIP__c' and DeveloperName = 'PM_Plan_FY15']) {
        for(RecordType rt : [Select Id From RecordType Where SobjectType = 'SIP__c' and DeveloperName IN : pmRTDeveloperName]) {
            set_pmRTIds.add(rt.Id);
        }
        return set_pmRTIds;
    }

   /**
    *  This method is used to full gpl codes for sip records.
    *
    @  author Bin Yuan
    @  created 2014-09-24
    @  version 1.0
    @  since 30.0 (Force.com ApiVersion)
    *
    @  changelog
    *  2014-09-24 Bin Yuan <bin.yuan@itbconsult.com>
    *  - Created
    */
    public static void fillGPLCodesForPMSIP(map<String, set<SIP__c>> map_user_set_sips) {
        set<String> set_pmUsers = map_user_set_sips.keySet();
        list<SIP__c> list_sips2Update = new list<SIP__c>();
        //get related product hierarchy for sip planners
        for(Product_Hierarchy__c prodHierarchy : [Select Name, Global_PM__c, Regional_PM_EU__c, Regional_PM_US__c,
                                                         Regional_PM_AP__c, Regional_PM_Japan__c, Regional_PM_China__c,
                                                         Regional_PM_India__c
                                                  From Product_Hierarchy__c
                                                  Where Global_PM__c in: set_pmUsers
                                                    or  Regional_PM_EU__c in: set_pmUsers
                                                    or  Regional_PM_US__c in: set_pmUsers
                                                    or  Regional_PM_AP__c in: set_pmUsers
                                                    or  Regional_PM_Japan__c in: set_pmUsers
                                                    or  Regional_PM_China__c in: set_pmUsers
                                                    or  Regional_PM_India__c in: set_pmUsers ]) {
                                                        
            if(map_user_set_sips.containsKey(prodHierarchy.Global_PM__c)) {
                generateSIPGPLCodes(prodHierarchy.Name, map_user_set_sips.get(prodHierarchy.Global_PM__c));
            }
            if(map_user_set_sips.containsKey(prodHierarchy.Regional_PM_EU__c)) {
                generateSIPGPLCodes(prodHierarchy.Name, map_user_set_sips.get(prodHierarchy.Regional_PM_EU__c));
            }
            if(map_user_set_sips.containsKey(prodHierarchy.Regional_PM_US__c)) {
                generateSIPGPLCodes(prodHierarchy.Name, map_user_set_sips.get(prodHierarchy.Regional_PM_US__c));
            }
            if(map_user_set_sips.containsKey(prodHierarchy.Regional_PM_AP__c)) {
                generateSIPGPLCodes(prodHierarchy.Name, map_user_set_sips.get(prodHierarchy.Regional_PM_AP__c));
            }
            if(map_user_set_sips.containsKey(prodHierarchy.Regional_PM_Japan__c)) {
                generateSIPGPLCodes(prodHierarchy.Name, map_user_set_sips.get(prodHierarchy.Regional_PM_Japan__c));
            }
            if(map_user_set_sips.containsKey(prodHierarchy.Regional_PM_China__c)) {
                generateSIPGPLCodes(prodHierarchy.Name, map_user_set_sips.get(prodHierarchy.Regional_PM_China__c));
            }
            if(map_user_set_sips.containsKey(prodHierarchy.Regional_PM_India__c)) {
                generateSIPGPLCodes(prodHierarchy.Name, map_user_set_sips.get(prodHierarchy.Regional_PM_India__c));
            }
        }
        //update sip records
        for(String userId : map_user_set_sips.keySet()) {
            for(SIP__c sip : map_user_set_sips.get(userId)) {
                sip.Recalculate__c = (sip.Recalculate__c == false ? true : false);
                list_sips2Update.add(sip);
            }
        }
        if(!list_sips2Update.isEmpty()) {
            update list_sips2Update;
        }
    }
    
   /**
    *  This method is used to full gpl codes for sip records.
    *
    @  author Bin Yuan
    @  created 2014-09-24
    @  version 1.0
    @  since 30.0 (Force.com ApiVersion)
    *
    @  changelog
    *  2014-09-24 Bin Yuan <bin.yuan@itbconsult.com>
    *  - Created
    */
    public static void generateSIPGPLCodes(String gplCode, set<SIP__c> set_sips) {
        for(SIP__c sip : set_sips) {
            if(sip.GPLs__c == null || !sip.GPLs__c.contains(gplCode)) {
                sip.GPLs__c += ((sip.GPLs__c == null || sip.GPLs__c == '') ? gplCode : ',' + gplCode);
            }
        }
    }
    
   /**
    *  This method is used to send batch status to running user and system administrator.
    *
    @  author Bin Yuan
    @  created 2014-09-24
    @  version 1.0
    @  since 30.0 (Force.com ApiVersion)
    *
    @  changelog
    *  2014-09-24 Bin Yuan <bin.yuan@itbconsult.com>
    *  - Created
    */
    public static void reportBatchStatus(list<SIPCustomExcMSG> list_exceptions, set<String> set_successIds, boolean isSubmit) {
        String subject = (isSubmit ? 'SIP Batch job submited succeed!' : 'SIP Batch job finished succeed!');
        list<String> list_errorInfos = new list<String>();
        //set email body
        if(list_exceptions.isEmpty()) {
            list_errorInfos.add(subject);
        }
        else {
            list_errorInfos.add('Following SIP records have failed to re-calculate: \n');
            for(SIPCustomExcMSG exc : list_exceptions) {
                String emailBody = '';
                emailBody += 'SIP Id : ' + exc.sipId + '\n';
                emailBody += 'Detailed Info : ' + '\n';
                emailBody += exc.errorMsg +'\n\n';
                list_errorInfos.add(emailBody);
            }
        }
        Cls_batchUtil.errorReportForBatch(list_errorInfos, subject);
    }
    
    /**
    *  This method is used to send batch status to running user and system administrator.
    *
    @  author Bin Yuan
    @  created 2014-09-24
    @  version 1.0
    @  since 30.0 (Force.com ApiVersion)
    *
    @  changelog
    *  2014-09-24 Bin Yuan <bin.yuan@itbconsult.com>
    *  - Created
    */
    public static String getCurrentFiscalYear() {
        String currentYear = '';
        for(FiscalYearSettings fs : [SELECT Id, StartDate, EndDate, Name 
                                     FROM FiscalYearSettings 
                                     Where StartDate <= today
                                     And EndDate >= today]) {
            currentYear = fs.Name;
        }
        return currentYear;
    }
    
    /**
    *  This method is used to parse report result json into custom class.
    *
    @  author Bin Yuan
    @  created 2014-09-24
    @  version 1.0
    @  since 30.0 (Force.com ApiVersion)
    *
    @  changelog
    *  2014-09-24 Bin Yuan <bin.yuan@itbconsult.com>
    *  - Created
    */
    public static SIPReportResult parseReportJson(String str_result, String factKey) {
        SIPReportResult reportResult = new SIPReportResult();
        //get full map
        map<String, Object> resultMap= (map<String, Object>) Json.deserializeUntyped(str_result);
        //set attribute result
        reportResult.attributes = (ReportResultAttribute)Json.deserialize(json.serialize(resultMap.get('attributes')), ReportResultAttribute.class);
        reportResult.factMap = new map<String, ResultFactValue>();
        //set fact map
        if(resultMap.get('factMap') == null) {
            return reportResult;
        }
        map<String, Object> factMap = (map<String, Object>) resultMap.get('factMap');
        if(factMap.containsKey(factKey)) {
            ResultFactValue resultFactValue = new ResultFactValue();
            resultFactValue.aggregates = new list<ResultFactAggregate>();
            Object factValue = factMap.get(factKey);
            map<String, Object> map_type_result = (map<String, Object>) factValue;
            Object aggregateResult = map_type_result.get('aggregates');
            list<Object> list_values = (list<Object>) aggregateResult;
            for(Object value : list_values) {
                if(value != null) {
                    ResultFactAggregate aggregate = (ResultFactAggregate) Json.deserialize(json.serialize(value), ResultFactAggregate.class);
                    resultFactValue.aggregates.add(aggregate);
                }
            }
            reportResult.factMap.put(factKey, resultFactValue);
        }
        return reportResult;
    }
    
    /**
    * This method is used to check if the fetch batch job is running too long.
    *
    @author Bin Yuan       
    @created 2014-09-24
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @changelog
    * 2014-09-24 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created  
    */
    public static boolean isKillFetchJob() {
        boolean isNeedToKill = false;
        //get fetch job start time from custom setting
        DateTime startTime;
        Integer maxRunHrs = 3;
        SIP_Sharing_Setting__c setting;
        if(SIP_Sharing_Setting__c.getInstance('Fetch Job Start Time') != null) {
            setting = SIP_Sharing_Setting__c.getInstance('Fetch Job Start Time');
            startTime = (setting.Job_Start_Time__c == null ? null : DateTime.valueOf(setting.Job_Start_Time__c));
        }
        if(SIP_Sharing_Setting__c.getInstance('Max Run Hours') != null) {
            SIP_Sharing_Setting__c maxSetting = SIP_Sharing_Setting__c.getInstance('Max Run Hours');
            maxRunHrs = (maxSetting.value__c == null ? 3 : Integer.valueOf(maxSetting.value__c));
        }
        if(startTime == null && setting != null) {
            //set start time as current
            setting.Job_Start_Time__c = system.now();
            update setting;
        }
        else {
            if(startTime.addHours(maxRunHrs) < system.now()) {
                isNeedToKill = true;
            } 
        }
        return isNeedToKill;
    }

    /**
    * Added by Bin Yuan 2015-09-18 due to Remove custom setting before batch run
    *
    @author Bin Yuan       
    @created 2015-09-18
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @changelog
    * 22015-09-18 Bin Yuan <bin.yuan@oinio.com>
    * - Created  
    */
    public static void removeSettingBeforeBatchRun() {
        if(SIP_Sharing_Setting__c.getInstance('SIP Running Scheduled') != null) {
            SIP_Sharing_Setting__c setting = SIP_Sharing_Setting__c.getInstance('SIP Running Scheduled');
            setting.value__c = '';
            update setting;
        }
        if(SIP_Sharing_Setting__c.getInstance('Fetch Job Start Time') != null) {
            SIP_Sharing_Setting__c setting = SIP_Sharing_Setting__c.getInstance('Fetch Job Start Time');
            setting.Job_Start_Time__c = null;
            update setting;
        }
    }
    /**
    * This method is used to get callout end point from custom setting.
    *
    @author Bin Yuan       
    @created 2015-09-11
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @changelog
    * 2015-09-11 Bin Yuan <bin.yuan@oinio.com>
    * - Created  
    */
    public static String getCalloutEndPoint() {
        String str_endPoint = URL.getSalesforceBaseUrl().toExternalForm();
        if(SIP_Sharing_Setting__c.getInstance('Callout End Point') != null 
            && SIP_Sharing_Setting__c.getInstance('Callout End Point').value__c != null) {
            
            str_endPoint = (String) SIP_Sharing_Setting__c.getInstance('Callout End Point').value__c;
        }
        return str_endPoint;
    }
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    /**
    * This method is used in method of populateTerritoryCode,to assignment automatically for AM_codes__c or FE_codes__c of SIP__c.
    *
    @author Lili Zhao       
    @created 2013-08-21
    @version 1.0
    @since 24.0 (Force.com ApiVersion)
    *
    @changelog
    * 2013-08-07 Lili Zhao <lili.zhao@itbconsult.com>  
    * - Created  
    */   
    private static void  getCodes(String le7UesrNetworkId,Sales_Hierarchy__c salesHierarchy, SIP__c sip, set<String> set_AMCodes, set<String> set_FECodes, map<Id,set<String>> map_AMSetLevel7TerritoryCode, map<Id,set<String>> map_FESetLevel7TerritoryCode) {
        //added lili zhao 2015-08-20 due to set the record type name to custom setting
        //set<String> set_AMRTDeveloperName = getPMAMOrFERTNames('SIP AM RecordType DeveloperNames');
        //set<String> set_FERTDeveloperName = getPMAMOrFERTNames('SIP FE RecordType DeveloperNames');
        //added lili zhao 2015-08-27
        if(set_AMRTDeveloperName.isEmpty()) {
            set_AMRTDeveloperName = getPMAMOrFERTNames('SIP AM RecordType DeveloperNames');
        } 
        
        if(set_FERTDeveloperName.isEmpty()) {
            set_FERTDeveloperName = getPMAMOrFERTNames('SIP FE RecordType DeveloperNames');
        }    
        //end  
        if(map_RecordType.isEmpty()) {
            getRTMap();
        }
        system.debug('map_RecordType :: ' + map_RecordType);
        for(String amDevName : set_AMRTDeveloperName) {
            system.debug('sip.RecordTypeId :: ' + sip.RecordTypeId);
            system.debug('map_RecordType.get(amDevName) :: ' + map_RecordType.get(amDevName));
            
            if(sip.RecordTypeId == map_RecordType.get(amDevName) && le7UesrNetworkId == sip.Participants_TE_Network_ID__c && salesHierarchy.Hierarchy_Type__c == 'Sales Hierarchy (AM)') {
                if(!map_AMSetLevel7TerritoryCode.containsKey(sip.Id)){
                    map_AMSetLevel7TerritoryCode.put(sip.Id,new set<String>());
                } 
                map_AMSetLevel7TerritoryCode.get(sip.Id).add(salesHierarchy.Level_7_Territory_Code__c);
                if(salesHierarchy.Level_7_Territory_Code__c != null) {
                    set_AMCodes.add(salesHierarchy.Level_7_Territory_Code__c);
                    sip.AM_codes__c = (sip.AM_codes__c == null ? salesHierarchy.Level_7_Territory_Code__c : sip.AM_codes__c + ',' + salesHierarchy.Level_7_Territory_Code__c);
                }
            }
        }
        
        for(String feDevName : set_FERTDeveloperName) {
            system.debug('sip.RecordTypeId :: ' + sip.RecordTypeId);
            system.debug('map_RecordType.get(feDevName) :: ' + map_RecordType.get(feDevName));
            if(sip.RecordTypeId == map_RecordType.get(feDevName) && le7UesrNetworkId == sip.Participants_TE_Network_ID__c && salesHierarchy.Hierarchy_Type__c == 'Account Manager Hierarchy (FE)') {
                if(!map_FESetLevel7TerritoryCode.containsKey(sip.Id)){
                    map_FESetLevel7TerritoryCode.put(sip.Id,new set<String>());     
                }                                       
                map_FESetLevel7TerritoryCode.get(sip.Id).add(salesHierarchy.Level_7_Territory_Code__c); 
                if( salesHierarchy.Level_7_Territory_Code__c != null) {
                    set_FECodes.add(salesHierarchy.Level_7_Territory_Code__c);
                    sip.FE_codes__c = (sip.FE_codes__c == null ? salesHierarchy.Level_7_Territory_Code__c : sip.FE_codes__c + ',' + salesHierarchy.Level_7_Territory_Code__c);
                }   
            }
        }
        /*
        if((sip.RecordTypeId == map_RecordType.get('AM_plan') || sip.RecordTypeId == map_RecordType.get('AM_Plan_FY15')) && le7UesrNetworkId == sip.Participants_TE_Network_ID__c && salesHierarchy.Hierarchy_Type__c == 'Sales Hierarchy (AM)'){                                                                                                                                                                           
            if(sip.RecordTypeId == map_RecordType.get('AM_plan')) {
                if(!map_AMSetLevel7TerritoryCode.containsKey(sip.Id)){
                    map_AMSetLevel7TerritoryCode.put(sip.Id,new set<String>());
                } 
                map_AMSetLevel7TerritoryCode.get(sip.Id).add(salesHierarchy.Level_7_Territory_Code__c); 
            }
            if(salesHierarchy.Level_7_Territory_Code__c != null) {
                if(sip.RecordTypeId == map_RecordType.get('AM_plan')) {
                    set_AMCodes.add(salesHierarchy.Level_7_Territory_Code__c);
                }
                sip.AM_codes__c = (sip.AM_codes__c == null ? salesHierarchy.Level_7_Territory_Code__c : sip.AM_codes__c + ',' + salesHierarchy.Level_7_Territory_Code__c);
            }                                                                           
        } else if((sip.RecordTypeId == map_RecordType.get('FE_Plan') || sip.RecordTypeId == map_RecordType.get('FE_Plan_FY15')) && le7UesrNetworkId == sip.Participants_TE_Network_ID__c && salesHierarchy.Hierarchy_Type__c == 'Account Manager Hierarchy (FE)'){                                      
            if(sip.RecordTypeId == map_RecordType.get('FE_Plan')) {
                if(!map_FESetLevel7TerritoryCode.containsKey(sip.Id)){
                    map_FESetLevel7TerritoryCode.put(sip.Id,new set<String>());     
                }                                       
                map_FESetLevel7TerritoryCode.get(sip.Id).add(salesHierarchy.Level_7_Territory_Code__c); 
            }
            if( salesHierarchy.Level_7_Territory_Code__c != null) {
                if(sip.RecordTypeId == map_RecordType.get('FE_Plan')) {
                    set_FECodes.add(salesHierarchy.Level_7_Territory_Code__c);
                }
                sip.FE_codes__c = (sip.FE_codes__c == null ? salesHierarchy.Level_7_Territory_Code__c : sip.FE_codes__c + ',' + salesHierarchy.Level_7_Territory_Code__c);
            }                                   
        }   
        */                                                        
    } 
       
    /**
    * This method is used in method of populateBillings,to assignment automatically for some fields of SIP__c.
    *
    @author Lili Zhao       
    @created 2013-08-21
    @version 1.0
    @since 24.0 (Force.com ApiVersion)
    *
    @changelog
    * 2013-08-21 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created  
    */   
    @TestVisible private static void getSipBilling(SIP__c sip, AggregateResult bMonBilBoCu) {
        Integer sipPlanYear = Integer.valueOf(sip.Plan_Year__c);
        decimal sum_billAmoutUSD = (decimal) bMonBilBoCu.get('sum_billAmoutUSD');
        if(sum_billAmoutUSD == null){
            sum_billAmoutUSD = 0;
        }
        if(bMonBilBoCu.get('fiscalYear') == String.valueOf(sipPlanYear-2) && bMonBilBoCu.get('billType') == 'Direct') {
            sip.Prev_Year_1__c = (sip.Prev_Year_1__c == null ? sum_billAmoutUSD : sip.Prev_Year_1__c + sum_billAmoutUSD);                               
        }
        //system.debug('==sip.Prev_Year_1__c=='+sip.Prev_Year_1__c);
        
        if(bMonBilBoCu.get('fiscalYear') == String.valueOf(sipPlanYear-2) && bMonBilBoCu.get('billType') == 'POS') {
            sip.Prev_Year_1_POS_Result__c = (sip.Prev_Year_1_POS_Result__c == null ? sum_billAmoutUSD : sip.Prev_Year_1_POS_Result__c + sum_billAmoutUSD);     
        }
        //system.debug('==sip.Prev_Year_1_POS_Result__c=='+sip.Prev_Year_1_POS_Result__c);
        
        if (bMonBilBoCu.get('fiscalYear') == String.valueOf(sipPlanYear-1) && bMonBilBoCu.get('billType') == 'Direct') {
            sip.Prev_Year_YTD_Direct_billings__c = (sip.Prev_Year_YTD_Direct_billings__c == null ? sum_billAmoutUSD : sip.Prev_Year_YTD_Direct_billings__c + sum_billAmoutUSD); 
        }
        //system.debug('==sip.Prev_Year_YTD_Direct_billings__c=='+sip.Prev_Year_YTD_Direct_billings__c);
        
        if(bMonBilBoCu.get('fiscalYear') == String.valueOf(sipPlanYear-1) && bMonBilBoCu.get('billType') == 'POS') {
            sip.Prev_Year_YTD_POS__c = (sip.Prev_Year_YTD_POS__c == null ? sum_billAmoutUSD : sip.Prev_Year_YTD_POS__c + sum_billAmoutUSD); 
        }
        //system.debug('==sip.Prev_Year_YTD_POS__c=='+sip.Prev_Year_YTD_POS__c);
        
        if (bMonBilBoCu.get('fiscalYear') == String.valueOf(sipPlanYear) && bMonBilBoCu.get('billType') == 'Direct') {
            sip.Current_Year_Direct_Bill_YTD__c = (sip.Current_Year_Direct_Bill_YTD__c == null ? sum_billAmoutUSD : sip.Current_Year_Direct_Bill_YTD__c + sum_billAmoutUSD);    
        }
        //system.debug('==sip.Current_Year_Direct_Bill_YTD__c=='+sip.Current_Year_Direct_Bill_YTD__c);
        
        if(bMonBilBoCu.get('fiscalYear') == String.valueOf(sipPlanYear) && bMonBilBoCu.get('billType') == 'POS') {
            sip.Current_Year_POS_Bill_YTD__c = (sip.Current_Year_POS_Bill_YTD__c == null ? sum_billAmoutUSD : sip.Current_Year_POS_Bill_YTD__c + sum_billAmoutUSD); 
        }   
        //system.debug('==sip.Current_Year_POS_Bill_YTD__c=='+sip.Current_Year_POS_Bill_YTD__c);    
    }
    
    /**
    * This method is used to get the RecordType of SIP
    *
    @author Lili Zhao
    @created 2013-8-13
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2013-08-13 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    private static void getRTMap() {
        //Start by Bin Yuan 2014-09-22 due to extend record types to fillin am & fe territory code
        //for (RecordType t : [select Id, Name, DeveloperName from RecordType where SobjectType = 'SIP__c' and IsActive = true and (DeveloperName = 'AM_plan' or DeveloperName = 'FE_Plan' or DeveloperName = 'GAM_plan' or DeveloperName = 'Sales_Manager_Plan')]) {
        // added lili zhao 2015-08-20 due to setting developeName to custom setting
        //set<String> AMRTDeveloperName = getPMAMOrFERTNames('SIP AM RecordType DeveloperNames');
        //set<String> FERTDeveloperName = getPMAMOrFERTNames('SIP FE RecordType DeveloperNames');
        //added lili zhao 2015-08-27
        if(set_AMRTDeveloperName.isEmpty()) {
            set_AMRTDeveloperName = getPMAMOrFERTNames('SIP AM RecordType DeveloperNames');
        } 
        
        if(set_FERTDeveloperName.isEmpty()) {
            set_FERTDeveloperName = getPMAMOrFERTNames('SIP FE RecordType DeveloperNames');
        }    
        //end
        for (RecordType t : [select Id, Name, DeveloperName 
                             from RecordType 
                             where SobjectType = 'SIP__c' 
                                and IsActive = true 
                                and (
                                    //DeveloperName = 'AM_plan' 
                                    //or DeveloperName = 'FE_Plan' 
                                    //or DeveloperName = 'AM_Plan_FY15'     //Added by bin yuan 2014-09-22
                                    //or DeveloperName = 'FE_Plan_FY15'     //Added by bin yuan 2014-09-22
                                    DeveloperName IN : set_AMRTDeveloperName//added lili zhao 2015-08-20
                                    or DeveloperName IN : set_FERTDeveloperName//added lili zhao 2015-08-20
                                    //or DeveloperName = 'GAM_plan'     commented by bin yuan 2016-08-29 due to record type name correction
                                    or DeveloperName = 'GAM_Plan' 
                                    or DeveloperName = 'Sales_Manager_Plan')]) {
            system.debug('t :: ' + t);
            /*                          
            if(t.DeveloperName == 'AM_plan'){
                map_RecordType.put('AM_plan',t.Id);
            } else if(t.DeveloperName == 'FE_Plan') {
                map_RecordType.put('FE_Plan',t.Id);
            }else if (t.DeveloperName == 'GAM_plan') {
                map_RecordType.put('GAM_plan',t.Id);
            }else if(t.DeveloperName == 'Sales_Manager_Plan') {
                map_RecordType.put('Sales_Manager_Plan',t.Id);
            //Added by bin yuan 2014-09-22
            }else if(t.DeveloperName == 'AM_Plan_FY15') {
                map_RecordType.put('AM_Plan_FY15',t.Id);
            }else if(t.DeveloperName == 'FE_Plan_FY15') {
                map_RecordType.put('FE_Plan_FY15',t.Id);
            }
            */
             map_RecordType.put(t.DeveloperName,t.Id);
             //added lili Zhao 2015-08-20
        }   
    }
    
    private static void reSetSipBillings(List<SIP__c> sips) {
        for(SIP__c sip : sips) {
            sip.Prev_Year_1__c = 0;
            sip.Prev_Year_1_POS_Result__c = 0;
            sip.Prev_Year_YTD_Direct_billings__c = 0;
            sip.Prev_Year_YTD_POS__c = 0;
            sip.Current_Year_Direct_Bill_YTD__c = 0;
            sip.Current_Year_POS_Bill_YTD__c = 0;
        }
    }
    private static void resetData(SIP__c sip) {     
        sip.AM_codes__c = null;
        sip.FE_codes__c = null;
        sip.Conversion_result__c = null; 
        sip.Pipeline_Result__c = null; 
        sip.Prev_Year_Pipeline_YTD_Result_Dollar__c = null;
        sip.Prev_Year_Conversion_YTD_Result_Dollar__c = null;
    }

    /**
    * This method is used to get query string from query fields set.
    *
    @author Bin Yuan       
    @created 2014-09-24
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @changelog
    * 2014-09-24 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created  
    */ 
    private static String getQueryString(set<String> set_queryFields) {
        String str_query = ' , ';
        for(String field : set_queryFields) {
            str_query = str_query + field + ', ';
        }
        str_query = str_query.substringBeforeLast(',');
        return str_query;
    }

    
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>WrapperClass*/
    public class ReportMap implements Comparable {
        public String reportId {get; set;}
        public String reportInstanceId {get; set;}
        public String targetFieldName {get; set;}
        public list<String> list_targetFieldNames {get; set;}
        public list<String> list_filterValues {get; set;}
        public map<Integer, String> map_filterNumb_filterValue {get; set;}
        public set<String> set_queryFields {get; set;}
        public map<String, String> map_sourceField_targetField {get; set;}
        
        public ReportMap() {
            this.reportId = '';
            this.targetFieldName = '';
            this.list_filterValues = new list<String>();
            this.set_queryFields = new set<String>();
            this.list_targetFieldNames = new list<String>();
            this.map_filterNumb_filterValue = new map<Integer, String>();
            this.map_sourceField_targetField = new map<String, String>();
        }
        public Integer compareTo(Object compareTo) {
            ReportMap compareToMap = (ReportMap)compareTo;
            if (reportId == compareToMap.reportId) return 0;
            if (reportId > compareToMap.reportId) return 1;
            return -1;        
        }
    }
    
    public class SIPCustomExcMSG {
        public String sipId {get; set;}
        public String errorMsg {get; set;}
        
        public SIPCustomExcMSG() {
            this.sipId = '';
            this.errorMsg = '';
        }
    }
    public class SIPReportResult {
        public boolean hasDetailRows {get; set;}
        public boolean allData {get; set;}
        //public Reports.ReportMetadata reportMetadata {get; set;}
        public map<String, ResultFactValue> factMap {get; set;}
        
        public ReportResultAttribute attributes {get; set;}
    }
    
    public class ReportResultAttribute {
        public String id {get; set;}
        public String status {get; set;}
        public String ownerId {get; set;}
        public DateTime completionDate {get; set;}
        public DateTime requestDate {get; set;}
        public String type {get; set;}
        public String reportId {get; set;}
        public String reportName {get; set;}
    }
    
    public class ResultFactValue {
        public list<ResultFactAggregate> aggregates {get; set;}
        public list<ResultFactAggregate> rows {get; set;}
    }
    public class ResultFactAggregate {
        public String label {get; set;}
        public double value {get; set;}
    }
    
    public class ReportRequestBody {
        public ReportRequestMetadata reportMetadata {get; set;}
    }
    
    public class ReportRequestMetadata {
        public String name {get; set;}
        public String id {get; set;}
        public String STRCURRENCY {get; set;}
        //public Reports.ReportFormat reportFormat {get; set;}
        public String developerName {get; set;}
        public Reports.ReportType reportType {get; set;}
        public list<String> aggregates {get; set;}
        public list<Reports.GroupingInfo> groupingsDown {get; set;}
        public list<Reports.GroupingInfo> groupingsAcross {get; set;}
        public String reportBooleanFilter {get; set;}
        public list<Reports.ReportFilter> reportFilters {get; set;}
        public list<String> detailColumns {get; set;}
        public list<String> historicalSnapshotDates {get; set;}
        
    }
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
}