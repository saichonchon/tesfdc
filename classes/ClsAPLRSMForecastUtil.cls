public class ClsAPLRSMForecastUtil {
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
    
    /**
    * This method is used to get account info for rsm
    *
    @author Bin Yuan
    @created 2014-06-02
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *@param userId
    *@return the key of map is region of account
    *
    @changelog
    * 2014-06-02 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static map<String, ClsAPLEntityTypes.AcctFCValueObj> getAMAcctGroup(ClsAPLEntityTypes.RSMAcctFCInfo rsmAcct) {
        list<String> list_sql = new list<String>();
        map<String, ClsAPLEntityTypes.AcctFCValueObj> map_groupId_acctFC = 
            new map<String, ClsAPLEntityTypes.AcctFCValueObj>();
        //get account grouping
        list_sql.add(' APL_AM_forecast_Plan_Account__c ParentAcctId, APL_AM_Display_Name__c DisplayName ');
        list_sql.add(' Account ');
        list_sql.add(' WHERE SALES_TERRITORY_CDE__c = \'' + rsmAcct.territoryCode + '\' '
        		   + ' And STATDESC__c = \'Active\' '
                   + ' Group by APL_AM_forecast_Plan_Account__c, APL_AM_Display_Name__c ');
        for(AggregateResult result : Database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String parentId = (String) (result.get('ParentAcctId') == null ? ClsAPLForecastUtil.OTHERACCTID : result.get('ParentAcctId'));
            String acctName = (String) (result.get('DisplayName') == null ? '' : result.get('DisplayName'));
            acctName = (parentId == ClsAPLForecastUtil.OTHERACCTID ? ClsAPLForecastUtil.OTHER : acctName);
            String cls = (result.get('ParentAcctId') == null ? (rsmAcct.territoryCode + 'other_cls') : parentId);
            ClsAPLEntityTypes.AcctFCValueObj acctFC = new ClsAPLEntityTypes.AcctFCValueObj();
            
            acctFC.acctId = parentId;
            acctFC.fieldName = acctName;
            acctFC.cls = cls;
            
            map_groupId_acctFC.put(parentId, acctFC);
        }
        return map_groupId_acctFC;
    }
    /**
    * This method is used to get account info for rsm
    *
    @author Bin Yuan
    @created 2014-06-02
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *@param userId
    *@return the key of map is region of account
    *
    @changelog
    * 2014-06-02 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static map<String, ClsAPLEntityTypes.AcctFCValueObj> getRSMRelayAcctGroup(ClsAPLEntityTypes.RSMRelayAcctFCInfo rsmAcct) {
        list<String> list_sql = new list<String>();
        map<String, ClsAPLEntityTypes.AcctFCValueObj> map_groupId_acctFC = 
            new map<String, ClsAPLEntityTypes.AcctFCValueObj>();
        //get account grouping
        list_sql.add(' APL_Relay_forecast_Plan_Account__c ParentAcctId, APL_Relay_Display_Name__c DisplayName, APL_Relay_Currency__c CurrencyCode ');
        list_sql.add(' Account ');
        list_sql.add(' WHERE Relay_Specialist_Territory_Code__c = \'' + rsmAcct.territoryCode + '\' And APL_Relay_forecast_Plan_Account__c != null '
         		   + ' And STATDESC__c = \'Active\' '
                   + ' Group by APL_Relay_forecast_Plan_Account__c, APL_Relay_Display_Name__c, APL_Relay_Currency__c ');
        system.debug('list_sql:::: '+list_sql);
        for(AggregateResult result : Database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
            String parentId = (String) (result.get('ParentAcctId') == null ? ClsAPLForecastUtil.OTHER : result.get('ParentAcctId'));
            String acctName = (String) (result.get('DisplayName') == null ? '' : result.get('DisplayName'));
            String cls = (parentId == ClsAPLForecastUtil.OTHER ? (rsmAcct.territoryCode + 'other_cls') : parentId);
            String currencyIsoCode = (String) result.get('CurrencyCode');
            decimal currencyRate = (decimal) ClsAPLForecastUtil.transformIsoCode(1, 'USD', currencyIsoCode);            
            currencyRate = currencyRate.setScale(2);
            ClsAPLEntityTypes.AcctFCValueObj acctFC = new ClsAPLEntityTypes.AcctFCValueObj();
            
            acctFC.acctId = parentId;
            acctFC.fieldName = acctName;
            acctFC.cls = cls;
            acctFC.currencyIso = currencyIsoCode;
            
            map_groupId_acctFC.put(parentId, acctFC);
        }
        system.debug('map_groupId_acctFC::: '+map_groupId_acctFC);
        return map_groupId_acctFC;
    }
   /**
    * This method is used to create a new interface instance
    *
    @author Bin Yuan
    @created 2014-06-02
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-02 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static ClsAPLEntityTypes.RSMAcctInfo getTerritoryInfo(ClsAPLEntityTypes.PageConfig pageConf) {
        
        ClsAPLEntityTypes.RSMAcctInfo rsmInfo = new ClsAPLEntityTypes.RSMAcctInfo();
        set<String> set_territoryCodes = new set<String>();
        set<String> set_rsmId = new set<String>();
        map<String, String> map_territoryCode_territoryName = new map<String, String>();
        //map<String, String> map_amType_rsmId = new map<String, String>();
        //map<String, set<String>> map_relayType_set_rsmId = new map<String, set<String>>();
        //String rsmQueryFields = ' A6_Code__c territoryCode, RecordType.DeveloperName rtName, RSM__r.APL_RSM__r.Display_Name__c displayName, RSM_Freeze__c isFrozen';
        String rsmQueryFields = ' A6_Code__c territoryCode, RecordType.DeveloperName rtName, RSM__r.Display_Name__c displayName, RSM__r.Type__c rsmType, RSM__c rsmId, RSM_Freeze__c isFrozen';
        
        String rsmQueryObj = ' APL_Forecast_Management__c ';
        String rsmQueryFilter = ' Where RSM__r.Manager__c = \'' + pageConf.managerId + '\' And  A6_Code__c != null and RecordTypeId != null group by A6_Code__c, RSM__r.Display_Name__c, RSM__c, RSM__r.Type__c, RecordType.DeveloperName, RSM_Freeze__c ';
        String rsmQuery = ClsAPLForecastUtil.getQueryString(new list<String>{rsmQueryFields, rsmQueryObj, rsmQueryFilter});
        //get territory related name and Relay Hierarchy
        String territoryQueryFields = ' Level_7_Territory_Name__c, Level_7_Territory_Code__c ';
        String territoryQueryObj = ' Sales_Hierarchy__c ';
        String territoryQueryFilter = ' Where Level_7_Territory_Code__c In : set_territoryCodes ';
        String territoryQuery = ClsAPLForecastUtil.getQueryString(new list<String>{territoryQueryFields, territoryQueryObj, territoryQueryFilter});
        
        //get all territory codes for current rsm
        system.debug('rsmQuery::: '+rsmQuery);
        for(AggregateResult result : database.query(rsmQuery)) {
            String territoryCode = (String) result.get('territoryCode');
            String rsmType = (String) result.get('rtName');
            String displayName = (String) result.get('displayName');
            String rsmId = (String) result.get('rsmId');
            String typeName = (String) result.get('rsmType');
            //String territoryName = territoryCode + (map_territoryCode_territoryName.containsKey(territoryCode) ? map_territoryCode_territoryName.get(territoryCode) : '');
            boolean isFrozen = (boolean) result.get('isFrozen');
            if(!rsmInfo.map_type_instanceName.containsKey(rsmType)) {
                rsmInfo.map_type_instanceName.put(rsmType, ClsAPLForecastUtil.map_RSMTYPE_INSTANCENAME.get(rsmType));
            }
            if(!rsmInfo.map_type_territoryCodes.containsKey(rsmType)) {
                rsmInfo.map_type_territoryCodes.put(rsmType, new set<ClsAPLEntityTypes.RSMTerritoryInfo>());
            }
            rsmInfo.map_type_territoryCodes.get(rsmType).add(new ClsAPLEntityTypes.RSMTerritoryInfo(territoryCode, territoryCode + '_cls', isFrozen));
            if(rsmType == 'AM') {
            	pageConf.set_rsmAMTerritoryCodes.add(territoryCode);
            	//pageConf.rsmAMDisplayName = displayName;
            	if(typeName == 'AM') {
            		pageConf.rsmAMDisplayName = displayName;
            	}
            }   
            else if(rsmType == 'Relay') {
            	pageConf.set_rsmRelayTerritoryCodes.add(territoryCode);
            	/*
            	if(displayName != null && displayName != '') {
            		pageConf.set_rsmRelayDisplayNames.add(displayName);
            	}
            	*/
            	if(typeName == 'Relay' || typeName == 'Both') {
	            	set_rsmId.add(rsmId);
            	}
            }
            set_territoryCodes.add(territoryCode);
        }
        for(Sales_Hierarchy__c sh : database.query(territoryQuery)) {
        	map_territoryCode_territoryName.put(sh.Level_7_Territory_Code__c, sh.Level_7_Territory_Name__c);
        }
        for(String rsmType : rsmInfo.map_type_territoryCodes.keySet()) {
        	for(ClsAPLEntityTypes.RSMTerritoryInfo territoryInfo : rsmInfo.map_type_territoryCodes.get(rsmType)) {
        		territoryInfo.displayName = (map_territoryCode_territoryName.containsKey(territoryInfo.name) ? map_territoryCode_territoryName.get(territoryInfo.name) : '');
        	}
        }
        
        
        
        list<String> list_sql = new list<String>();
        list_sql.add(' Id, Display_Name__c, APL_RSM__r.Type__c ');
		list_sql.add(' APL_RSM__c ');
		list_sql.add(' Where APL_RSM__c IN : set_rsmId'
					+ ' And APL_RSM__r.Type__c != \'AM\''
				   );
		for(APL_RSM__c rsm : database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
			if(rsm.Id != null) {
        		pageConf.set_rsmRelayDisplayNames.add(rsm.Display_Name__c);
        		pageConf.set_rsmRelayIds.add(rsm.Id);
        	}
		}
        
        pageConf.json_rsmAMTerritoryCodes = Json.serialize(pageConf.set_rsmAMTerritoryCodes);
        pageConf.json_rsmRelayTerritoryCodes = Json.serialize(pageConf.set_rsmRelayTerritoryCodes);
        pageConf.json_rsmRelayDisplayNames = Json.serialize(pageConf.set_rsmRelayDisplayNames);
        pageConf.json_rsmRelayIds = Json.serialize(pageConf.set_rsmRelayIds);
        
        system.debug('pageConf::: '+pageConf.rsmAMDisplayName);
        system.debug('pageConf.json_rsmRelayDisplayNames::: '+pageConf.json_rsmRelayDisplayNames);
        return rsmInfo;
    }
    
    //added by nelson zheng 2015-9-16
    public static APL_RSM__c getRelayManager(ClsAPLEntityTypes.PageConfig pageConf) {
    	
    	List<APL_RSM__c> aplRsmList = [select Id,Display_Name__c,Manual_Enter_Forecast__c from APL_RSM__c where Manager__c =: pageConf.managerId];
    	if(aplRsmList.size() > 0){
    		return aplRsmList[0];
    	}
    	
    	return null;
    }
    
   /**
    * This method is used to get RSM AM overall freeze date
    *
    @author Bin Yuan
    @created 2014-06-02
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-02 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static boolean getIsRSMAMOverallFrozen() {
    	boolean isFrozen = true;
    	Integer rsmUnfreezeDay = 22,
    			rsmRelayUnfreezeDay = 26, 
    			allFreezeDay = 28,
    			dayCounter = 0;
    			
    	if(APL_Forecast_Settings__c.getInstance('RSM Unfreeze Setting') != null
    		&& APL_Forecast_Settings__c.getInstance('RSM Unfreeze Setting').Value__c != null) {
    			
    		rsmUnfreezeDay = Integer.valueOf(APL_Forecast_Settings__c.getInstance('RSM Unfreeze Setting').Value__c);
    	} 
    	if(APL_Forecast_Settings__c.getInstance('Relay RSM Unfreeze Setting') != null
    		&& APL_Forecast_Settings__c.getInstance('Relay RSM Unfreeze Setting').Value__c != null) {
    			
    		rsmRelayUnfreezeDay = Integer.valueOf(APL_Forecast_Settings__c.getInstance('Relay RSM Unfreeze Setting').Value__c);
    	} 
    	if(APL_Forecast_Settings__c.getInstance('Freeze All') != null
    		&& APL_Forecast_Settings__c.getInstance('Freeze All').Value__c != null) {
    			
    		allFreezeDay = Integer.valueOf(APL_Forecast_Settings__c.getInstance('Freeze All').Value__c);
    	}
    	//Started by bin yuan 2014-09-23 due to fix get day counter error
    	//dayCounter = date.today().daysBetween(date.today().toStartOfMonth()) + 1;
    	dayCounter = date.today().toStartOfMonth().daysBetween(date.today()) + 1;
    	if(dayCounter >= rsmUnfreezeDay && dayCounter < rsmRelayUnfreezeDay) {
    		isFrozen = false;
    	}
    	return isFrozen;
    }
   /**
    * This method is used to get RSM AM overall freeze date
    *
    @author Bin Yuan
    @created 2014-06-02
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-02 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static boolean getIsRSMRelayOverallFrozen() {
    	boolean isFrozen = true;
    	Integer rsmUnfreezeDay = 22,
    			rsmRelayUnfreezeDay = 26, 
    			allFreezeDay = 28,
    			dayCounter = 0;
    			
    	if(APL_Forecast_Settings__c.getInstance('RSM Unfreeze Setting') != null
    		&& APL_Forecast_Settings__c.getInstance('RSM Unfreeze Setting').Value__c != null) {
    			
    		rsmUnfreezeDay = Integer.valueOf(APL_Forecast_Settings__c.getInstance('RSM Unfreeze Setting').Value__c);
    	} 
    	if(APL_Forecast_Settings__c.getInstance('Relay RSM Unfreeze Setting') != null
    		&& APL_Forecast_Settings__c.getInstance('Relay RSM Unfreeze Setting').Value__c != null) {
    			
    		rsmRelayUnfreezeDay = Integer.valueOf(APL_Forecast_Settings__c.getInstance('Relay RSM Unfreeze Setting').Value__c);
    	} 
    	if(APL_Forecast_Settings__c.getInstance('Freeze All') != null
    		&& APL_Forecast_Settings__c.getInstance('Freeze All').Value__c != null) {
    			
    		allFreezeDay = Integer.valueOf(APL_Forecast_Settings__c.getInstance('Freeze All').Value__c);
    	}
    	dayCounter = date.today().daysBetween(date.today().toStartOfMonth()) + 1;
    	if(dayCounter >= rsmRelayUnfreezeDay && dayCounter < allFreezeDay) {
    		isFrozen = false;
    	}
    	return isFrozen;
    }
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>InnerClass*/
    
    ///*<<<InnerClass*/
    //********************************* -=END inner classes=- *************************************
}