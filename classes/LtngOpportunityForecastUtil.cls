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
global class LtngOpportunityForecastUtil {
	
	
	public static list<String> list_allConfidence = new list<String>{
		'On Hold','Weak', '50/50', 'Likely', 'Commit', 'Won', 'Dead', 'Lost'
	};
	public static map<String, list<String>> map_allProcessStatus = new map<String, list<String>>{
		'On Hold' => new list<String>{'Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted', 'On Customer AVL'},
		'Weak' => new list<String>{'Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted', 'On Customer AVL'}, 
		'50/50' => new list<String>{'Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted', 'On Customer AVL', 'Prototyped', 'Sampled'}, 
		'Likely' => new list<String>{'Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted', 'On Customer AVL'}, 
		'Commit' => new list<String>{'Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted', 'On Customer AVL', 'Pre-prod'}, 
		'Won' => new list<String>{'Pre-prod', 'Production', 'Ramp Down', 'EOL'}, 
		'Dead' => new list<String>{'Concept', 'Designed', 'Dead', 'Demo', 'Prototyped/Sampled', 'Quoted', 'On Customer AVL'}, 
		'Lost' => new list<String>{'Concept', 'Designed', 'Dead', 'Demo', 'Prototyped/Sampled', 'Quoted', 'On Customer AVL'}
	};
	
	public static map<String, Decimal> map_isoCode_exchangeRate; 
	public static map<String, Decimal> map_convertionRate = new Map<String, Decimal>();
	
    private static final Map<String, String> map_BU_IND = new Map<String, String>{
        'Rail' => 'IND',
        'A&C' => 'IND',
        'IB' => 'IND',
        'Solar' => 'IND'
    };
    
    private static final Map<String, String> map_BU_Appliances = new Map<String, String>{
        'Appliances' => 'Appliances',
        'EMS' => 'Appliances'
    };
    
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
    public static Decimal transformIsoCode(Decimal sourceValue, String fromIsoCode, String toIsoCode){
        Decimal result = 0;
        if(sourceValue != null){
            String k = fromIsoCode + toIsoCode;
            if(map_convertionRate.containsKey(k)){
                return sourceValue * map_convertionRate.get(k);
            }
            
            
            if(map_isoCode_exchangeRate == null){
	            map_isoCode_exchangeRate = new map<String, Decimal>();
	            for(CurrencyType ct : [SELECT  IsActive, IsCorporate, CreatedById, CreatedDate, IsoCode, Id, DecimalPlaces, LastModifiedById, LastModifiedDate, SystemModstamp, ConversionRate  from CurrencyType]){
	                map_isoCode_exchangeRate.put(ct.IsoCode, ct.ConversionRate);
	            }
            }
            
            Decimal fromRate = ((map_isoCode_exchangeRate.get(fromIsoCode) != null && String.ValueOf(map_isoCode_exchangeRate.get(fromIsoCode)) != '') ? map_isoCode_exchangeRate.get(fromIsoCode) : 1); 
            Decimal toRate = ((map_isoCode_exchangeRate.get(toIsoCode) != null && String.ValueOf(map_isoCode_exchangeRate.get(toIsoCode)) != '') ? map_isoCode_exchangeRate.get(toIsoCode) : 1); 
            /*
            if(map_isoCode_exchangeRate.get(fromIsoCode) != null && String.ValueOf(map_isoCode_exchangeRate.get(fromIsoCode)) != '') fromRate =  map_isoCode_exchangeRate.get(fromIsoCode);
            else fromRate = 1;
            if(map_isoCode_exchangeRate.get(toIsoCode) != null && String.ValueOf(map_isoCode_exchangeRate.get(toIsoCode)) != '') toRate =  map_isoCode_exchangeRate.get(toIsoCode);
            else toRate = 1;
            */
            system.debug('******************************'+toRate);  
            system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'+fromRate);  
            result = sourceValue * ( toRate / fromRate );
            system.debug('##############################'+result);   
            map_convertionRate.put(k, toRate / fromRate);
        }        
        
        return result;
    }
    
    //06-12-2014 Michael Cui: added for Case 00677873: APL Oppty Part process status consolidation.
    public static set<Id> applianceOpptyRecordTypeId(){
        Set<Id> rt_id = new Set<Id>();
        if(Apex_Helper_Settings__c.getInstance('Appliance Opportunity Record Type Id') != null && Apex_Helper_Settings__c.getInstance('Appliance Opportunity Record Type Id').Active__c && Apex_Helper_Settings__c.getInstance('Appliance Opportunity Record Type Id').value__c != null)
        {
            string temp = Apex_Helper_Settings__c.getInstance('Appliance Opportunity Record Type Id').value__c;
            for(Id appId :temp.split(',')){
                rt_id.add(appId);
            }
        }
        
        return rt_id;
    }
    
    /**
    * The method is used to check the bu is IND , Appliances or other
    *
    @author lili zhao
    @created 2013-10-15
    @version 1.0  
    @since 27.0 (Force.com ApiVersion)
    *
    @param    
    *
    @return  boolean          
    *
    @changelog
    * 2013-10-15 lili zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static Boolean isAppOrIndBu(String BU) {
        Boolean isAppOrIndBu = (BU == 'Appliances' ? true : false);
        /*
        // modify by lili zhao 2014.04.10 begin due to approve only for applian BU
        //if(BU == 'IND' || BU == 'Appliances') {
        if(BU == 'Appliances') {
        // modify by lili zhao 2014.04.10 end due to approve only for applian BU
            isAppOrIndBu = true;
        }else{
            isAppOrIndBu = false;
        }
        */
        return isAppOrIndBu;
    }
    public static String checkOpportunityCompetitor(Profile p, Opportunity o){
    	String message = '';
    	
    	if(p.Name == 'Appliance User w/ Cost' || p.Name == 'Appliance Standard User' || p.Name == 'Appliance Engineering User w/Cost'){
    		
    		if(o.RecordType.DeveloperName == 'Opportunity_Engineering_Project' || o.RecordType.DeveloperName == 'Opportunity_Sales_Parts_Only' || 
    			o.RecordType.DeveloperName == 'Opportunity_Product_Platform' || o.RecordType.DeveloperName == 'TAM'){
    				
    			message = 'You are not allowed to edit the opportunity information as there\'s no assigned competitor!';
    			
    			for(Opportunity_Competitor__c oc : [Select Id From Opportunity_Competitor__c Where Opportunity__c =: o.Id limit 1]){
		    		message = '';
		    		break;
		    	}
    		}
    		
    	}
    	
    	return message;    	
    }
    
    public static Boolean checkIND(Profile p, Opportunity o){
    	Boolean flg = false;
    	
    	if(p.Name == 'Industrial Engineering User w/Cost' || p.Name == 'Industrial Standard User' || p.Name == 'Industrial User w/ Cost'){
    		if(o.RecordType.DeveloperName == 'IND_Engineering_project' || o.RecordType.DeveloperName == 'IND_Sales_Project' || 
    			o.RecordType.DeveloperName == 'Opportunity_Product_Platform' || o.RecordType.DeveloperName == 'TAM'){
    			flg = true;
    		}
    	}
    	
    	return flg;    	
    }
    
    public static String checkOpportunityContactRole(Profile p, Opportunity o){
    	String message = '';
    	if(p.Name == 'Appliance User w/ Cost' || p.Name == 'Appliance Standard User' || p.Name == 'Appliance Engineering User w/Cost'){
    		
    		if(o.RecordType.DeveloperName == 'Opportunity_Engineering_Project' || o.RecordType.DeveloperName == 'Opportunity_Sales_Parts_Only' || 
    			o.RecordType.DeveloperName == 'Opportunity_Product_Platform' || o.RecordType.DeveloperName == 'TAM'){
    				
    			message = 'Opportunities that have 25 or greater probability require at least 1 Contact Role to be associated with the Opportunity. To correct this, add a contact role by going to the contact role section. Please ensure that you also associate any additional roles that are relevant.';
    			
    			for(OpportunityContactRole oc : [Select Id From OpportunityContactRole Where OpportunityId =: o.Id limit 1]){
		    		message = '';
		    		break;
		    	}
    		}
    		
    	}else if(p.Name == 'Medical Standard User' || p.Name == 'Medical User w/Cost'){
    		if(o.RecordType.DeveloperName == 'Opportunity_Engineering_Project' || o.RecordType.DeveloperName == 'IND_Sales_Project'){
    				
    			message = 'Opportunities that have 25 or greater probability require at least 1 Contact Role to be associated with the Opportunity. To correct this, add a contact role by going to the contact role section. Please ensure that you also associate any additional roles that are relevant.';
    			
    			for(OpportunityContactRole oc : [Select Id From OpportunityContactRole Where OpportunityId =: o.Id limit 1]){
		    		message = '';
		    		break;
		    	}
    		}
    	}else if(p.Name == 'DND Engineering User w/Cost' || p.Name == 'DND FAE User' || p.Name == 'DND Insidesales Power-Dailer' || p.Name == 'DND Partner Community' || p.Name == 'DND Standard User'){
    		if(o.RecordType.DeveloperName == 'DND_Opportunity'){
    				
    			message = 'Opportunities that have 25 or greater probability require at least 1 Contact Role to be associated with the Opportunity. To correct this, add a contact role by going to the contact role section. Please ensure that you also associate any additional roles that are relevant.';
    			
    			for(OpportunityContactRole oc : [Select Id From OpportunityContactRole Where OpportunityId =: o.Id limit 1]){
		    		message = '';
		    		break;
		    	}
    		}
    	}else if(p.Name == 'ADM Standard User' || p.Name == 'ADM User w/ cost'){
    		if(o.RecordType.DeveloperName == 'ADM'){
    				
    			message = 'Opportunities that have 25 or greater probability require at least 1 Contact Role to be associated with the Opportunity. To correct this, add a contact role by going to the contact role section. Please ensure that you also associate any additional roles that are relevant.';
    			
    			for(OpportunityContactRole oc : [Select Id From OpportunityContactRole Where OpportunityId =: o.Id limit 1]){
		    		message = '';
		    		break;
		    	}
    		}
    	}else if(p.Name == 'Channel Distributor Portal Manager' || p.Name == 'Channel Distributor Portal User' || p.Name == 'Channel Inside Sales' || p.Name == 'Channel Insidesales Power - Dialer' || p.Name == 'Channel Standard User'){
    		if(o.RecordType.DeveloperName == 'Channel_Engineering_Opportunity' || o.RecordType.DeveloperName == 'Channel_Sales_Opportunity' || o.RecordType.DeveloperName == 'CCR_Opportunity' || o.RecordType.DeveloperName == 'NDR_Opportunity'){
    				
    			message = 'Opportunities that have 25 or greater probability require at least 1 Contact Role to be associated with the Opportunity. To correct this, add a contact role by going to the contact role section. Please ensure that you also associate any additional roles that are relevant.';
    			
    			for(OpportunityContactRole oc : [Select Id From OpportunityContactRole Where OpportunityId =: o.Id limit 1]){
		    		message = '';
		    		break;
		    	}
    		}
    	}
    	return message;    	
    }
    
    public static Boolean checkADM(Boolean isAPL, Profile p, Opportunity o){
    	Boolean flg = isAPL;
    	if(p.Name == 'ADM Standard User' || p.Name == 'ADM User w/ cost'){
    		if(o.RecordType.DeveloperName == 'ADM'){
    			flg = true;
    		}
    	}
    	return flg;
    }
    
    public static Profile getUserProfile(String id){
    	Profile profile = new Profile();
    	for(Profile p : [Select Name, Id From Profile Where Id =: id]){
    		profile = p;
    	}
    	return profile;
    }
    
    public static Opportunity getOpportunityById(Id oppyId){
        Opportunity opportunity = new Opportunity();
        opportunity = [Select PLM_Id__c ,Email_Send__c,PLM_Created_By_Id__c, Industry_Code__c, CloseDate, IsClosed, AccountId, 
                              Manufacturing_Start_Date__c, Id, Name, stageName, RecordTypeId, Program__c, IsWon, Opportunity_Forecast_Recalculation__c, 
                              Program__r.Program_level_Forecasting__c, Amount, Five_Year_Revenue__c, Method__c, RecordType.DeveloperName, 
                              CurrencyIsoCode, Level__c, Competitor_Count__c, NDR_Quote_Status_Description__c, Approval_Status_PMV__c ,
                              Owner.GIBU__c
                       From Opportunity 
                       Where Id = :oppyId]; 
        return opportunity;  
    }
    
    /**
    * The method is used to save the changed value,as the opportunityForecastHistory
    *
    @author lili zhao
    @created 2013-10-15
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param    
    *
    @return            
    *
    @changelog
    * 2013-10-15 lili zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static String getOppyForecastHistory(String oppId) {
        map<String,list<LtngOpportunityForecastUtil.ForecastHistoryStructure>> map_partId_list_ForecastHistoryStructure = new map<String,list<LtngOpportunityForecastUtil.ForecastHistoryStructure>>();
        for(Forecast_History__c forecastHistory : [select Id, Part__r.Name, Part__r.Part_Number__c, Part__c, Fiscal_Year__c,Old_Value__c, New_Value__c, Opportunity__c  
                                                   From Forecast_History__c 
                                                   where ((Opportunity__c = : oppId)
                                                        Or
                                                        (Opportunity__r.Program__c = :oppId)) and Part__c != null 
                                                   order by Fiscal_Year__c ASC]) {     
            if(!map_partId_list_ForecastHistoryStructure.containsKey(forecastHistory.Part__c)){
                map_partId_list_ForecastHistoryStructure.put(forecastHistory.Part__c,new list<LtngOpportunityForecastUtil.ForecastHistoryStructure>());                
            } 
            LtngOpportunityForecastUtil.ForecastHistoryStructure  forhisStr = new  LtngOpportunityForecastUtil.ForecastHistoryStructure(forecastHistory.Fiscal_Year__c,forecastHistory.New_Value__c,forecastHistory.Old_Value__c);                         
            map_partId_list_ForecastHistoryStructure.get(forecastHistory.Part__c).add(forhisStr);        
        }
        return JSON.serialize(map_partId_list_ForecastHistoryStructure);                
    }
    
    /**
    * The method is used to save the changed value,as the opportunityForecastHistory
    *
    @author lili zhao
    @created 2013-10-15
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param    
    *
    @return            
    *
    @changelog
    * 2013-10-15 lili zhao <lili.zhao@itbconsult.com>
    * - Created
    */ 
    public static void saveOppForecastHitory(String str_mapPartId_listForecastHistoryStructure, Opportunity opp, String selectedReason){
        map<String,map<String,LtngOpportunityForecastUtil.ForecastHistoryStructure>> map_partId_map_fiscalYear_historyNew = new map<String,map<String,LtngOpportunityForecastUtil.ForecastHistoryStructure>>();
        map<String,list<LtngOpportunityForecastUtil.ForecastHistoryStructure>> map_partId_list_ForecastHistoryStructure = new map<String,list<LtngOpportunityForecastUtil.ForecastHistoryStructure>>();
        
        map_partId_list_ForecastHistoryStructure = (map<String,list<LtngOpportunityForecastUtil.ForecastHistoryStructure>>) JSON.deserializeStrict(str_mapPartId_listForecastHistoryStructure, map<String,list<LtngOpportunityForecastUtil.ForecastHistoryStructure>>.class);
        String bu = (getBU(opp) == 'Appliances' ? 'Appliances' : '');
        /*
        String buType = getBU(opp);
        if(buType == 'Appliances') {
            bu = 'Appliances';
        }
        */
        if(bu != '') {
        	checkUpdateForecastHistory(map_partId_list_ForecastHistoryStructure, map_partId_map_fiscalYear_historyNew, opp, selectedReason, bu);
        }
        /*
        try{
        }catch(exception ex){
            ApexPages.addMessages(ex);
        }
        */
    }
    
    public static void checkUpdateForecastHistory(map<String,list<LtngOpportunityForecastUtil.ForecastHistoryStructure>> map_partId_list_ForecastHistoryStructure, map<String,map<String,LtngOpportunityForecastUtil.ForecastHistoryStructure>> map_partId_map_fiscalYear_historyNew, Opportunity opp, String selectedReason, String bu){
    	decimal threshold;
    	for(String partId : map_partId_list_ForecastHistoryStructure.keyset()) {
            if(map_partId_list_ForecastHistoryStructure.get(partId).size() > 0) {
                if(!map_partId_map_fiscalYear_historyNew.containsKey(partId)) {
                    map_partId_map_fiscalYear_historyNew.put(partId,new map<String,LtngOpportunityForecastUtil.ForecastHistoryStructure>());
                }                      
                for(LtngOpportunityForecastUtil.ForecastHistoryStructure forHisStr : map_partId_list_ForecastHistoryStructure.get(partId)) {                    
                    map_partId_map_fiscalYear_historyNew.get(partId).put(forHisStr.fiscalYear,forHisStr);
                }
            }
        }
        if(!map_partId_map_fiscalYear_historyNew.isEmpty()) {  
            updateForecastHistory(map_partId_map_fiscalYear_historyNew, opp, bu, threshold, selectedReason);
        }
    }
    
    public static void updateForecastHistory(map<String,map<String, LtngOpportunityForecastUtil.ForecastHistoryStructure>> map_partId_map_fiscalYear_historyNew, Opportunity oppy, String bu, decimal threshold, String selectedReason) {
        //get all history
        map<String,map<String, Forecast_History__c>> map_partId_map_fiscalYear_historyExisting = new map<String,map<String, Forecast_History__c>>();
        list<Forecast_History__c> list_forecast2Upsert = new list<Forecast_History__c>(),
                                  list_forecast2Delete = new list<Forecast_History__c>(),
                                  list_forecast2Notify = new list<Forecast_History__c>();
        map<String, String> map_partId_partNumber = new map<String, String>();
        map<String, String> map_partId_partDescription = new map<String, String>();

        map<String, map<String, list<Opportunity_Forecast__c>>> map_partId_mapYearOppForecastDel = new map<String, map<String, list<Opportunity_Forecast__c>>>();
        map<String, map<String, list<Opportunity_Forecast__c>>> map_partId_mapYearOppForecastUpdate = new map<String, map<String, list<Opportunity_Forecast__c>>>();
        list<Opportunity_Forecast__c> list_updateOppForecast = new list<Opportunity_Forecast__c>();
        list<Forecast_History__c> list_AllOppForecastHis = new list<Forecast_History__c>();
        set<String> set_updateYears = new set<String>();
        set<String> set_delYears = new set<String>();
        set<String> set_updatePartIds = new set<String>();
        set<String> set_delPartIds = new set<String>();
        
        map_partId_map_fiscalYear_historyExisting = getPartForecastHistory(oppy.Id);  
        decimal changePercentage = 0;     
        //threshold = getThresholdFromSetting(bu);
        threshold = 0;
        
        for(String partId : map_partId_map_fiscalYear_historyNew.keySet()) {
            //if no history, create a new history data 
            if(!map_partId_map_fiscalYear_historyExisting.containsKey(partId)) {
                for(String fiscalYear : map_partId_map_fiscalYear_historyNew.get(partId).keySet()) {
                    LtngOpportunityForecastUtil.ForecastHistoryStructure forecastClsObj = map_partId_map_fiscalYear_historyNew.get(partId).get(fiscalYear);
                    if(forecastClsObj.newValue != forecastClsObj.oldValue) {
                        Forecast_History__c history = new Forecast_History__c();
                        copyHistoryData(forecastClsObj, history, partId, oppy.Id, list_forecast2Upsert, list_forecast2Notify, map_partId_partNumber, threshold,set_updateYears,set_updatePartIds);                   
                    }                   
                }    
            } else {  
                for(String fiscalYear : map_partId_map_fiscalYear_historyNew.get(partId).keySet()) {
                    //if no history, create a new history data
                    if(!map_partId_map_fiscalYear_historyExisting.get(partId).containsKey(fiscalYear)) {
                        LtngOpportunityForecastUtil.ForecastHistoryStructure forecastClsObj = map_partId_map_fiscalYear_historyNew.get(partId).get(fiscalYear);
                            if(forecastClsObj.newValue != forecastClsObj.oldValue) {
                                Forecast_History__c history = new Forecast_History__c();
                                copyHistoryData(forecastClsObj, history, partId, oppy.Id, list_forecast2Upsert, list_forecast2Notify, map_partId_partNumber, threshold,set_updateYears,set_updatePartIds);
                            }
                     } else {       
                        LtngOpportunityForecastUtil.ForecastHistoryStructure forecastClsObj = map_partId_map_fiscalYear_historyNew.get(partId).get(fiscalYear) ;
                        Forecast_History__c history = map_partId_map_fiscalYear_historyExisting.get(partId).get(fiscalYear);
                        //if old == new value delete existing history
                        if(forecastClsObj.newValue == forecastClsObj.oldValue) {
                            list_forecast2Delete.add(history);
                            list_forecast2Notify.add(history); 
                            set_delYears.add(fiscalYear);
                            set_delPartIds.add(partId);
                        } else {
                        	/*
                            // add lili begin 
                            if(forecastClsObj.oldValue != 0 && forecastClsObj.newValue != 0) {
                                decimal changeage = Math.abs(forecastClsObj.oldValue - forecastClsObj.newValue);
                                changePercentage = changeage/forecastClsObj.oldValue;
                            }else {
                                changePercentage = 1;
                            }
                            */
                            changePercentage = ((forecastClsObj.oldValue != 0 && forecastClsObj.newValue != 0) ? Math.abs(forecastClsObj.oldValue - forecastClsObj.newValue)/forecastClsObj.oldValue : 1);
                            
                            if(changePercentage != 0 && changePercentage < threshold){
                                list_forecast2Delete.add(history);
                                list_forecast2Notify.add(history);
                                set_delYears.add(fiscalYear);
                                set_delPartIds.add(partId);
                            }
                            if (changePercentage != 0 && changePercentage >= threshold) {
                                //if(history.New_Value__c != forecastClsObj.newValue) {
                                    history.New_Value__c = forecastClsObj.newValue;
                            // add lili end
                                    list_forecast2Upsert.add(history); 
                                    list_forecast2Notify.add(history);
                                    map_partId_partNumber.put(history.Part__c, null); 
                                    set_updateYears.add(fiscalYear);
                                    set_updatePartIds.add(partId);
                                //}
                            }                           
                            //always reset isReject to false
                            //history.Is_Reject__c = false;                                                     
                        }                        
                    }
                }
            }
        }
        if(!map_partId_partNumber.isEmpty()) {
            for(Opportunity_Part__c part : [select Id, part_number__c,Item_Description__c from Opportunity_Part__c where Id IN : map_partId_partNumber.keySet()]) {
                map_partId_partNumber.put(part.Id, part.part_number__c);
                map_partId_partDescription.put(part.Id,part.Item_Description__c);
            }
        }
        //get users who receive notification mail and history data
        //UPSERT DATA BASE
        // add lili 2013.10.16 begin 
        // if the Forecast_History__c of  Opportunity_Forecast__c was deleted,the value of IsLocked__c will change to true
        if(!list_forecast2Delete.isEmpty()) {          
            map_partId_mapYearOppForecastDel = getMapOppForecast(set_delYears,set_delPartIds);
            //system.debug('map_partId_mapYearOppForecastDel:::'+map_partId_mapYearOppForecastDel );
            //system.debug('list_forecast2Delete:::'+list_forecast2Delete);
            for(Forecast_History__c forecastHistory:  list_forecast2Delete) {                                                           
                if(map_partId_mapYearOppForecastDel.containsKey(forecastHistory.Part__c) && map_partId_mapYearOppForecastDel.get(forecastHistory.Part__c).containsKey(forecastHistory.Fiscal_Year__c) && map_partId_mapYearOppForecastDel.get(forecastHistory.Part__c).get(forecastHistory.Fiscal_Year__c).size() > 0) {                                
                    for(Opportunity_Forecast__c oppForecast:map_partId_mapYearOppForecastDel.get(forecastHistory.Part__c).get(forecastHistory.Fiscal_Year__c)) {
                        oppForecast.IsLocked__c = false;
                        list_updateOppForecast.add(oppForecast);   
                    }               
                }
            }                                                                                      
			try{
            	delete list_forecast2Delete;
            } catch(Exception ex){
                ApexPages.addMessages(ex);          
            }
            // begin change the oppy Email_Send__c  field to false if have no Forecast_History__c
            for(Forecast_History__c forecastHistory : [select Id, Part__r.Name, Part__r.Part_Number__c, Part__c, Fiscal_Year__c,Old_Value__c, New_Value__c, Opportunity__c   From Forecast_History__c  Where ((Opportunity__c = : oppy.Id) Or (Opportunity__r.Program__c = :oppy.Id)) and Part__c != null ]) {
                list_AllOppForecastHis.add(forecastHistory);
                       
            }
            if(list_AllOppForecastHis.size() == 0) {
                list<FeedItem> list_posts = new list<FeedItem>();
                for(FeedItem post : [select id,ParentId from FeedItem  where ParentId =: oppy.Id]) {
                    list_posts.add(post);
                }
                Opportunity opp = ClsOppyForecastUtil.getOpportunityById(oppy.Id);
                opp.Email_Send__c = false;
                try{
                     if(list_posts.size() > 0) delete list_posts;               
                     update opp;
                }   
                catch(Exception ex){
                    ApexPages.addMessages(ex);          
                }
               
            }
        // end change the oppy Email_Send__c  field to false if have no Forecast_History__c    
        }
        // if the Opportunity_Forecast__c have Forecast_History__c,the value of IsLocked__c will change to fasle
        if(!list_forecast2Upsert.isEmpty()) {
        	try{
	            upsert list_forecast2Upsert;
	            map_partId_mapYearOppForecastUpdate = getMapOppForecast(set_updateYears,set_updatePartIds);    
	            for(Forecast_History__c forecastHistory:  list_forecast2Upsert) {                                                           
	                if(map_partId_mapYearOppForecastUpdate.containsKey(forecastHistory.Part__c) && map_partId_mapYearOppForecastUpdate.get(forecastHistory.Part__c).containsKey(forecastHistory.Fiscal_Year__c) && map_partId_mapYearOppForecastUpdate.get(forecastHistory.Part__c).get(forecastHistory.Fiscal_Year__c).size() > 0) {                               
	                    for(Opportunity_Forecast__c oppForecast:map_partId_mapYearOppForecastUpdate.get(forecastHistory.Part__c).get(forecastHistory.Fiscal_Year__c)) {
	                        oppForecast.IsLocked__c = true;
	                        list_updateOppForecast.add(oppForecast);   
	                    }               
	                }
	            }         
        	}catch(Exception ex){
        		ApexPages.addMessages(ex);         
        	}
        }       
        // update the changed  Opportunity_Forecast__c
        if(!list_updateOppForecast.isEmpty()) {      
           try{
                 Database.update(list_updateOppForecast, false);         
            } catch(Exception ex){
                ApexPages.addMessages(ex);          
            }   
        }
        
        if(!list_forecast2Notify.isEmpty() && !oppy.Email_Send__c) {
            sentForecastApprovalNotification(list_forecast2Upsert,oppy,list_forecast2Delete,map_partId_partNumber,map_partId_partDescription, selectedReason);
        }
        // add lili 2013.10.16 end 
    }
    
    /**
    * The method is used to get the Forecast_History__c as the oppyId
    *
    @author Lili Zhao
    @created 2013-10-17
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param             level
    *
    @return 
    *
    @changelog
    * 2013-10-17 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static  map<String,map<String, Forecast_History__c>> getPartForecastHistory(String oppId) {
        map<String,map <String, Forecast_History__c>> map_partId_map_fiscalYear_forecastHistory = new map<String,map <String, Forecast_History__c>>(); 
        for(Forecast_History__c forecastHistory: [Select Fiscal_Year__c, Part__c, New_Value__c, Old_Value__c, Part__r.Part__r.Name, Opportunity__c 
                                                  From Forecast_History__c  
                                                  where ((Opportunity__c = : oppId)
                                                        Or
                                                        (Opportunity__r.Program__c = :oppId)) and Part__c != null]) {
            if(!map_partId_map_fiscalYear_forecastHistory.containsKey(forecastHistory.Part__c)) {
                map_partId_map_fiscalYear_forecastHistory.put(forecastHistory.Part__c, new map<String, Forecast_History__c>());
            }
            map_partId_map_fiscalYear_forecastHistory.get(forecastHistory.Part__c).put(forecastHistory.Fiscal_Year__c,forecastHistory);                  
        }      
        return  map_partId_map_fiscalYear_forecastHistory;          
    }
    
    public static void copyHistoryData(LtngOpportunityForecastUtil.ForecastHistoryStructure forecastClsObj, Forecast_History__c forecastHistory, String partId, String oppyId, list<Forecast_History__c> list_forecast2Upsert, list<Forecast_History__c> list_forecast2Notify, map<String, String> map_partId_partNumber, decimal threshold,set<String> set_years,set<String> set_partIds) {
        
        decimal changePercentage = (forecastClsObj.oldValue != 0 ? Math.abs(forecastClsObj.oldValue - forecastClsObj.newValue)/forecastClsObj.oldValue : 1 );
        
        /*
        if(forecastClsObj.oldValue != 0) {
            decimal changeage = Math.abs(forecastClsObj.oldValue - forecastClsObj.newValue);
            changePercentage = changeage/forecastClsObj.oldValue;
        }else {
            changePercentage = 1;
        }
        */
        changePercentage = changePercentage.setScale(3);
        if(changePercentage != 0 && changePercentage >= threshold) {
            //forecastHistory.Opportunity__c = forecastClsObj.oppyId; //add lili 2013.10.17
            forecastHistory.Opportunity__c = oppyId;
            forecastHistory.Part__c = partId;
            forecastHistory.Fiscal_Year__c = forecastClsObj.fiscalYear;
            forecastHistory.New_Value__c = forecastClsObj.newValue;
            forecastHistory.Old_Value__c = forecastClsObj.oldValue;
            //forecastHistory.Part__c = forecastClsObj.oppyPartId; //add lili 2013.10.17
            // add lili 2013.10.15 end
            list_forecast2Notify.add(forecastHistory);
            map_partId_partNumber.put(forecastHistory.Part__c, null);
            list_forecast2Upsert.add(forecastHistory);
            set_years.add(forecastClsObj.fiscalYear);
            set_partIds.add(partId);
        }
    }
    
    /**
    * The method is used to send the emails
    *
    @author lili zhao
    @created 2013-10-15
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param    
    *
    @return            
    *
    @changelog
    * 2013-10-15 lili zhao <lili.zhao@itbconsult.com>
    * - Created
    */ 
    public static void sentForecastApprovalNotification(list<Forecast_History__c> list_forecast2Upsert,Opportunity oppy, list<Forecast_History__c> list_forecast2Delete, map<String, String> map_partId_partNumber,map<String, String> map_partId_partDescription,String selectedReason) {
        // add lili 2013.10.17
        list<String> list_userEmails = new list<String>();
        list_userEmails = getSendUserEmail(oppy.Id);
        // add lili 2013.10.17
        if(list_userEmails.isEmpty()) {
            return;
        }
        
        generateUpsertHistoryTable(list_userEmails, list_forecast2Upsert, oppy, list_forecast2Delete, map_partId_partNumber, map_partId_partDescription, selectedReason);	//Generate upsert history table
    }
    
    public static void generateUpsertHistoryTable(list<String> list_userEmails, list<Forecast_History__c> list_forecast2Upsert,Opportunity oppy, list<Forecast_History__c> list_forecast2Delete, map<String, String> map_partId_partNumber,map<String, String> map_partId_partDescription,String selectedReason){
    	
    	String emailBody = '';
        String deleteEmailBody = '';
        
        list<forecastHistoryInfos> list_forecastHistoryInfos = new list<forecastHistoryInfos>();
        list<String> list_years = new list<String>();    
        set<String> set_years = new set<String>();
        
    	map<String,map<String,String>> map_partId_mapOldNewValue = new map<String,map<String,String>>();
        map<String,String> map_partNumber_partDescription = new map<String,String>();
        
    	if(!list_forecast2Upsert.isEmpty()) {
            emailBody = '<br><div>Your Forecast of Opportunity \'' + oppy.Name + '\' has been changged!</div><br><div> The updated forecast will not be sent to Program Central until you have confirmed this change.</div><br>';
            emailBody += '<div><table border=\'1\'><tr><th>&nbsp;&nbsp;Part Number&nbsp;&nbsp;</th><th width=\'200px\'>&nbsp;&nbsp;Description&nbsp;&nbsp;</th>';   
            for(Forecast_History__c fcHistory : list_forecast2Upsert) {
                set_years.add(fcHistory.Fiscal_Year__c);
                String partNumber = ((map_partId_partNumber.containsKey(fcHistory.Part__c) && map_partId_partNumber.get(fcHistory.Part__c) != null) ? map_partId_partNumber.get(fcHistory.Part__c) : 'Part Id : ' + fcHistory.Part__c);
                if(!map_partId_mapOldNewValue.containsKey(partNumber)){
                    map_partId_mapOldNewValue.put(partNumber, new map<String, String>());                
                }                       
                String value =  fcHistory.New_Value__c + ' / ' + fcHistory.Old_Value__c;            
                map_partId_mapOldNewValue.get(partNumber).put(fcHistory.Fiscal_Year__c, value); 
                if(map_partId_partDescription.get(fcHistory.Part__c) != null) {
                    map_partNumber_partDescription.put(partNumber,map_partId_partDescription.get(fcHistory.Part__c)); 
                } else {
                    map_partNumber_partDescription.put(partNumber,' ');
                }     
            }
            list_years.addAll(set_years);
            list_years.sort();  
            for(String year : list_years) {    
                for(String oppPart : map_partId_mapOldNewValue.keySet()) {
                    if(!map_partId_mapOldNewValue.get(oppPart).containsKey(year)) {
                        //Forecast_History__c forecastHistoryNew = new Forecast_History__c();
                        //forecastHistoryNew.Old_Value__c = 0;
                        //forecastHistoryNew.New_Value__c = 0;
                        map_partId_mapOldNewValue.get(oppPart).put(year, '0 / 0');
                    }
                }
            }
            for(String str:list_years) {
                emailBody += '<th>&nbsp;&nbsp;' + str + '&nbsp;&nbsp;</th>';
            }
            emailBody += '</tr><tr>';
            for(String strPartNum : map_partId_mapOldNewValue.keySet()) { 
                emailBody += '<td>&nbsp;&nbsp;' + strPartNum + '&nbsp;&nbsp;</td>';  
                emailBody += '<td>&nbsp;&nbsp;' + map_partNumber_partDescription.get(strPartNum) + '&nbsp;&nbsp;</td>';    
                for(String strYear:list_years) {
                    if(map_partId_mapOldNewValue.get(strPartNum).containsKey(strYear)) {
                        emailBody += '<td>&nbsp;&nbsp;' + map_partId_mapOldNewValue.get(strPartNum).get(strYear) + '&nbsp;&nbsp;</td>';
                    }
                } 
                emailBody += '</tr>';
            }
            emailBody += '</table></div><br><div>*(New Value/Old Value)</div><br>'; 
            emailBody += 'Click here to view/confirm the change: <a href=' + URL.getSalesforceBaseUrl().toExternalForm() +'/apex/ExtOpportunityForecastHistory?id=' + Oppy.Id + '>' +  ' View' +'</a>' + '<br><br>Best regards,<br>System Administrator';    
        } else if(!list_forecast2Delete.isEmpty()) {	//if upsert table is null then generate change back message
            emailBody = '<br><div>Your Forecast of Opportunity \'' + oppy.Name + '\' has change to old value,please notice!<br><br>Best regards,<br>System Administrator';  
        }
        
        if(emailBody != '') {
        	try{
		        //send email Begin   
		        Messaging.SingleEmailMessage  mail = new Messaging.SingleEmailMessage ();
		        String emailSubject = 'Your value of Opportunity \"' + oppy.Name + '\" was changed';                           
		        mail.setToAddresses(list_userEmails);       
		        //mail.setHtmlBody('Dear ' + user.Name + ',<br>' + emailBody);
		        mail.setHtmlBody('Dear,<br>' + emailBody);
		        mail.setSubject(emailSubject);
		        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		                  
		        //send email End 
		                    
		        //add chatter post Begin   
		        FeedItem post = new FeedItem();
		        post.ParentId = Oppy.Id; 
		        if(selectedReason != null || selectedReason != '') {
		            post.body = 'Forecast change reason : ' + selectedReason;   
		        }    
		        post.Title = 'Here to view the change';      
		        post.LinkUrl = URL.getSalesforceBaseUrl().toExternalForm() +'/apex/ExtOpportunityForecastHistory?id=' + Oppy.Id;      
		        insert post;                                
		        // add chatter post END  
		        // set the Email_Send__c to true  begin
		        oppy.Email_Send__c = true;
		        update oppy;
		        // set the Email_Send__c to true  end
        		
        	}catch(Exception ex){
        		ApexPages.addMessages(ex);       
        	}
        }
    }
    
    /**
    * The method is used to get the users to send emails
    *
    @author Lili Zhao
    @created 2013-10-17
    @version 1.0
    @since 27.0 (Force.com ApiVersion)   
    *
    @param             
    *
    @return list_userEmails  
    *
    @changelog
    * 2013-10-17 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static list<String> getSendUserEmail(String oppId) {
        list<String> list_userEmails = new list<String>();
        Opportunity opp = (Opportunity) [Select PLM_Created_By_Id__c, id, Opportunity_Champion__c from Opportunity where id =: oppId];
        for(User user :[Select Te_Network_Id__c, Name,DelegatedApproverId,Email from User where (Te_Network_Id__c =: opp.PLM_Created_By_Id__c and Te_Network_Id__c != null) or (Te_Network_Id__c =: opp.Opportunity_Champion__c and Te_Network_Id__c != null) or (DelegatedApproverId =: opp.PLM_Created_By_Id__c and DelegatedApproverId != null) or (DelegatedApproverId =: opp.Opportunity_Champion__c and DelegatedApproverId != null)]) {
            list_userEmails.add(user.Email);
        }
        return list_userEmails;
    }
    
    /**
    * The method is used to get the Opportunity_Forecast__c
    *
    @author lili zhao
    @created 2013-10-28
    @version 1.0  
    @since 27.0 (Force.com ApiVersion)
    *
    @param    
    *
    @return  boolean              
    * 
    @changelog
    * 2013-10-28 lili zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static map<String,map<String,list<Opportunity_Forecast__c>>> getMapOppForecast(set<String> set_years, set<String> set_partIds) {
        map<String,map<String,list<Opportunity_Forecast__c>>> map_partId_mapYearOppForecast = new map<String,map<String,list<Opportunity_Forecast__c>>>();
        //map<String,Opportunity_Forecast__c> map_Id_OppForecast = new map<String,Opportunity_Forecast__c>();
        for(Opportunity_Forecast__c oppForecast : [SELECT Opportunity__c, Id, Fiscal_Year__c, Part__c, IsLocked__c FROM Opportunity_Forecast__c where Part__c IN : set_partIds and Fiscal_Year__c IN : set_years ]){                                         
            //map_Id_OppForecast.put(oppForecast.Id, oppForecast); 
            if(!map_partId_mapYearOppForecast.containsKey(oppForecast.Part__c)){
                map_partId_mapYearOppForecast.put(oppForecast.Part__c, new map<String, list<Opportunity_Forecast__c>>());                
            }
            if(!map_partId_mapYearOppForecast.get(oppForecast.Part__c).containsKey(oppForecast.Fiscal_Year__c)) {
                map_partId_mapYearOppForecast.get(oppForecast.Part__c).put(oppForecast.Fiscal_Year__c,new list<Opportunity_Forecast__c>()); 
            }
            map_partId_mapYearOppForecast.get(oppForecast.Part__c).get(oppForecast.Fiscal_Year__c).add(oppForecast);
        }
        return map_partId_mapYearOppForecast;
    }
    
    /**
    * The method is used to get the BU type
    *
    @author Lili Zhao
    @created 2013-10-17
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param             
    *
    @return BU
    *
    @changelog
    * 2013-10-17 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static String getBU(Opportunity opp) {
        String BU;
        if(map_BU_IND.containsKey(opp.Industry_Code__c)) {
            BU = 'IND'; 
        }else if(map_BU_Appliances.containsKey(opp.Industry_Code__c)) {
            BU = 'Appliances';
        }else{
            BU = 'other';
        }
        return BU;
    }
    
    
    //********************************* -=BEGIN inner classes=- ***********************************
	///*>>>WrapperClass*/
	public class ForecastHistoryStructure{
        public String fiscalYear {get; set;} 
        public decimal newValue {get; set;}
        public decimal oldValue {get; set;} 
        
        public ForecastHistoryStructure(String fYear,decimal newValue, decimal oldValue) {
            this.fiscalYear = fYear;
            this.newValue = newValue;   
            this.oldValue = oldValue;
        }
    }
	
	public class forecastHistoryInfos{
        public String partNumber{get;set;}   
        public map<String, String> map_year_oldNewValue{get;set;}
        public forecastHistoryInfos(String num, map<String, String> map_Value) {
            this.partNumber = num;
            this.map_year_oldNewValue = map_Value;          
        }
    }
    ///*<<<WrapperClass*/   
    //********************************* -=END inner classes=- *************************************
}