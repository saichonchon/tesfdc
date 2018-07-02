/**
 *  Virtual controll class for  CtrlAcctGrouping, CtrlGroupingAMForecast class
 *
 @author    Bin Yuan
 @created   2014-03-27
 @version   1.0
 @since     29.0 (Force.com ApiVersion)
 *
 @changelog
 * 2014-03-27 Bin Yuan <bin.yuan@itbconsult.com>
 * - Created
 */
global virtual without sharing class CtrlGroupingRemoteBase {
    
    /**
    * This method is used to load relay product code FC data
    *
    @author Lei Tang
    @created 2015-05-21
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-05-21 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */ 
    @RemoteAction
    public static String existAPLsObject(String clsName, String sData){
		APL_Interface.AAPLRemoteService remoteService =  newClsInstance(clsName);
		String result =  remoteService.getExistResult(sData);
		return result;
	}
    
    @RemoteAction
	public static String searchAPLsObject(String clsName, String sData){
		APL_Interface.AAPLRemoteService remoteService =  newClsInstance(clsName);
		String result =  remoteService.getSearchResult(sData);
		return result;
	}

	@RemoteAction
	public static String saveAPLsObject(String clsName, String sData){
		APL_Interface.AAPLRemoteService remoteService =  newClsInstance(clsName);
		String result =  remoteService.saveSObjectData(sData);
		return result;
	}
	
	
	@RemoteAction
	public static String delAPLsOjbect(String clsName, String sData){
		APL_Interface.AAPLRemoteService remoteService =  newClsInstance(clsName);
		String result =  remoteService.deleteAPLObject(sData);
		return result;
	}

	
	@RemoteAction
	public static String getAPLsRefData(String clsName, String sData){
		APL_Interface.AAPLRemoteService remoteService =  newClsInstance(clsName);
		String result =  remoteService.getRefData(sData);
		return result;
	}

	@RemoteAction
	public static String getBacklogRefData(String clsName, String sData){
		APL_Interface.AAPLRemoteService remoteService =  newClsInstance(clsName);
		String result =  remoteService.getBacklogRefData(sData);
		return result;
	}
    
    public static APL_Interface.AAPLRemoteService newClsInstance(String clsName){
        try{
            Type t = Type.forName(clsName);
            return (APL_Interface.AAPLRemoteService) t.newInstance();
        }catch(Exception e){
            throw new CustomNullException('Not found register class.');
        }
    }
	public class CustomNullException extends Exception {} 
    
    
    
    
   /**
    * This method is used to load AM CBC Forecast data 
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    @RemoteAction
    public static String searchCBC2Forecast(String pjson){
        CBC2Forecast cbc_fc = (CBC2Forecast)Json.deserialize(pjson, CBC2Forecast.class);
        system.debug('searchCBC2Forecast :: ' + cbc_fc);
        ClsGroupingAMForecastUtil.getCBC2FC(cbc_fc);
        return json.serialize(cbc_fc.map_cbcName);
    }
    
   /**
    * This method is used to load AM Account Forecast & Reference data 
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    @RemoteAction
    @ReadOnly
    public static String searchAMAcctFCReferenceData(String pjson){
    	AcctForecast acctFC = (AcctForecast)Json.deserialize(pjson, AcctForecast.class);
    	system.debug('acctFC :: ' + acctFC);
        return ClsGroupingAMForecastUtil.getAMAcctRefData(acctFC);
    }
    
   /**
    * This method is used to load AM CBC Forecast data 
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    @RemoteAction
    @ReadOnly
    public static String searchAMCBCRefDataQuarterly(String pjson){
        CBC2Forecast cbc_fc = (CBC2Forecast)Json.deserialize(pjson, CBC2Forecast.class);
        system.debug('searchAMCBCRefDataQuarterly :: ' + cbc_fc);
        //ClsGroupingAMForecastUtil.getCBC2FC(cbc_fc);
        return ClsGroupingAMForecastUtil.getAMCBCRefData(cbc_fc);
    }
    
    /**
    * This method is used to load Relay CBC Forecast data 
    *
    @author Lili Zhao
    @created 2014-06-24
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-24 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    @RemoteAction
    public static String searchCBC2ForecastForRelay(String pjson){

        CBC2Forecast cbc_fc = (CBC2Forecast)Json.deserialize(pjson, CBC2Forecast.class);
        system.debug('searchCBC2ForecastForRelay :: ' + cbc_fc);
        ClsGroupingRelayForecastUtil.getCBC2FCForRelay(cbc_fc);
        
        return json.serialize(cbc_fc.map_cbcName);
    }
    
   /**
    * This method is used to load AM GPL Forecast data 
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    @RemoteAction
    public static String searchGPL(String pjson){

        GPLInfo gpl = (GPLInfo)Json.deserialize(pjson, GPLInfo.class);
        system.debug('searchGPL :: ' + gpl);
        return ClsGroupingAMForecastUtil.getGPLFC(gpl.cbc2Name, gpl);
    }
    
   /**
    * This method is used to load AM GPL Forecast data 
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    @RemoteAction
    public static String searchAMGPLRefDataQuarterly(String pjson){

        GPLInfo gpl = (GPLInfo)Json.deserialize(pjson, GPLInfo.class);
        system.debug('searchAMGPLRefDataQuarterly :: ' + gpl);
        //return ClsGroupingAMForecastUtil.getGPLFC(gpl.cbc2Name, gpl);
        return ClsGroupingAMForecastUtil.getAMGPLRefData(gpl);
    }
    
   /**
    * This method is used to load AM Part Forecast data 
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    @RemoteAction
    public static String searchPartFC(String pjson){

        PartInfo part = (PartInfo)Json.deserialize(pjson, PartInfo.class);
        system.debug('searchPartFC :: ' + part);
        return ClsGroupingAMForecastUtil.getPartFC(part, false, false);
        
    }
    
    /**
    * This method is used to load Relay part Forecast data 
    *
    @author Lili Zhao
    @created 2014-06-24
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-24 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    @RemoteAction
    public static String searchPartFCForRelay(String pjson){

        PartInfo part = (PartInfo)Json.deserialize(pjson, PartInfo.class);
        system.debug('searchPartFCForRelay :: ' + part);
        return ClsGroupingRelayForecastUtil.getPartFC(part);
    }
      
   /**
    * This method is used to load AM Part Forecast data for Other CBC
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */ 
    @RemoteAction
    public static String searchOthersPartFC(String pjson){

        PartInfo part = (PartInfo)Json.deserialize(pjson, PartInfo.class);
        system.debug('searchOthersPartFC :: ' + part);
        return  ClsGroupingAMForecastUtil.getPartFC(part, false, true);
    }
    
   /**
    * This method is used to load AM GPL Forecast data for relay cbc 
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    @RemoteAction
    public static String searchRelayGPLFC(String pjson){

        GPLInfo gpl = (GPLInfo)Json.deserialize(pjson, GPLInfo.class);
        system.debug('searchRelayGPLFC :: ' + gpl);
        gpl.cbc2Name = 'Relay';
        //return ClsGroupingAMForecastUtil.getGPLFC('Relay', gpl);
        return ClsGroupingAMForecastUtil.getRelayCBC2FC(gpl);
    }
    
   /**
    * This method is used to load AM part Forecast data for relay cbc 
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    @RemoteAction
    public static String searchRelayPartFC(String pjson){
		system.debug('pjson :: ' + pjson);
        PartInfo part = (PartInfo)Json.deserialize(pjson, PartInfo.class);
        return ClsGroupingAMForecastUtil.getPartFC(part, true, false);
    }
    
   /**
    * This method is used to delete exception part for AM 
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    @RemoteAction
    public static String deletePart(String pjson){


        PartInfo part = (PartInfo)Json.deserialize(pjson, PartInfo.class);
        system.debug('deletePart :: ' + part);
        return json.serialize(ClsGroupingAMForecastUtil.deletePart(part.aid, part.territoryCode, part.isOther, part.cbc2Name, part.gplId, part.partId));
    }

   /**
    * This method is used to add  top 5 exception part for AM 
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    @RemoteAction
    public static String addedPart(String pjson){
        
        list<ClsGroupingAMForecastUtil.PartObj> list_parts = new list<ClsGroupingAMForecastUtil.PartObj>();
        GPLInfo part = (GPLInfo)Json.deserialize(pjson, GPLInfo.class);
        system.debug('addedPart :: ' + part);
        ClsGroupingAMForecastUtil.addPart(part.aid, part.cbc2Name, part.territoryCode, part.gplId, part.partName,
                                          part.quarterNumb, part.isTop, part.isOther, list_parts, part.map_year,
                                          part.json_partIds);
        system.debug('list_parts :: ' + list_parts);
        return json.serialize(list_parts);
    }
    
   /**
    * This method is used to add exception part for AM 
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    @RemoteAction
    public static String searchAllPart(String pjson){
        
        list<ClsGroupingAMForecastUtil.PartObj> list_parts = new list<ClsGroupingAMForecastUtil.PartObj>();
        system.debug('pjson :: ' + pjson);
        GPLInfo part = (GPLInfo)Json.deserialize(pjson, GPLInfo.class);
        system.debug('searchAllPart :: ' + part);
        ClsGroupingAMForecastUtil.addPart(part.aid, part.cbc2Name, part.territoryCode, part.gplId, part.partName,
                                          part.quarterNumb, part.isTop, part.isOther, list_parts, part.map_year, 
                                          part.json_partIds);
        return json.serialize(list_parts);
    }   
    
   /**
    * This method is used to load reference data for new added exception part for AM 
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
	@RemoteAction
    public static String getAddedPartRefData(String pjson){

        PartInfo part = (PartInfo)Json.deserialize(pjson, PartInfo.class);
        system.debug('load PartFC refdata for add :: ' + part);
        return  ClsGroupingAMForecastUtil.getPartRefDataForAdd(part);
    }
    
    /**
    * This method is used to add exception part for relay 
    *
    @author Lili Zhao
    @created 2014-06-24
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-24 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */    
    @RemoteAction
    public static String addedRelayPart(String pjson){

        list<ClsGroupingRelayForecastUtil.RelayPartObj> list_parts = new list<ClsGroupingRelayForecastUtil.RelayPartObj>();
        GPLInfo part = (GPLInfo)Json.deserialize(pjson, GPLInfo.class);      
        ClsGroupingRelayForecastUtil.addPart(part.aid, part.cbc2Name, part.territoryCode, part.partName, part.quarterNumb, part.isTop, list_parts, part.map_year, true, part.json_partIds);
        return json.serialize(list_parts);
    }   
    
    /**
    * This method is used to add exception part for relay 
    *
    @author Lili Zhao
    @created 2014-06-24
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-24 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */ 
    @RemoteAction
    public static String searchRelayPart(String pjson){
        list<ClsGroupingRelayForecastUtil.RelayPartObj> list_parts = new list<ClsGroupingRelayForecastUtil.RelayPartObj>();
        GPLInfo part = (GPLInfo)Json.deserialize(pjson, GPLInfo.class);      
        ClsGroupingRelayForecastUtil.addPart(part.aid, part.cbc2Name, part.territoryCode, part.partName, part.quarterNumb, part.isTop, list_parts, part.map_year, true, part.json_partIds);
        return json.serialize(list_parts);
    }
    /**
    * This method is used to load reference data for new added exception part for relay 
    *
    @author Lili Zhao
    @created 2014-06-24
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-24 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */ 
    @RemoteAction
    public static String getAddedRelayPartRefData(String pjson){

        PartInfo part = (PartInfo)Json.deserialize(pjson, PartInfo.class);
        system.debug('load PartFC refdata for relay add :: ' + part);
        return  ClsGroupingRelayForecastUtil.getPartRefDataForAdd(part);
    }
    
   /**
    * This method is used to save apl sales forecast for AM 
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    @RemoteAction
    public static String saveForecast(String pjson){
        try{
        	system.debug('pjson::: '+pjson);
            ClsAPLForecastObjects.ForecastSaveBaseObj fo = (ClsAPLForecastObjects.ForecastSaveBaseObj)Json.deserialize(pjson, ClsAPLForecastObjects.ForecastSaveBaseObj.class);
            system.debug('saveForecast :: ' + fo);
            list<APL_Sales_Forecast__c> list_fc = new list<APL_Sales_Forecast__c>();
            ClsAPLForecastObjects.IObject io =  ClsAPLForecastObjects.newClassInstance(fo.className);
            io.saveFC(fo.str_json, list_fc);
            return 'true';
        }catch(Exception e){
            throw e;
        }
    }
    /**
    * This method is used to delete part for AM 
    *
    @author Lili Zhao
    @created 2014-06-24
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-24 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    @RemoteAction
    public static String delPart(String pjson){
        PartInfo part = (PartInfo)Json.deserialize(pjson, PartInfo.class);
        system.debug('part :: ' + part);
        return json.serialize(ClsGroupingAMForecastUtil.deletePart(part.aid, part.territoryCode, part.isOther, part.cbc2Name, part.gplId, part.partId));
    }
    /**
    * This method is used to delete part for relay 
    *
    @author Lili Zhao
    @created 2014-06-24
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-24 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    @RemoteAction
    public static String delRelayPart(String pjson){
        PartInfo part = (PartInfo)Json.deserialize(pjson, PartInfo.class);
        system.debug('part :: ' + part);
        return json.serialize(ClsGroupingRelayForecastUtil.deletePart(part));
    }
    /**
    * This method is used to save APL Sales Forecast for relay
    *
    @author Lili Zhao
    @created 2014-06-24
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-24 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    @RemoteAction
    public static String saveRelayFC(String pjson){
        try{
            ClsAPLEntityTypes.MockObj mockObj = (ClsAPLEntityTypes.MockObj)Json.deserialize(pjson, ClsAPLEntityTypes.MockObj.class);
            ClsAPLInterface.IAPLFCService io =  ClsAPLForecastUtil.newClassInstance(mockObj.className);
            io.saveFC(mockObj.str_json);
            return 'true';
        }catch(Exception e){
            throw e;
        }
    }

   /**
    * This method is used to load reference data quarterly for GAM & RSM 
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    @RemoteAction
    @ReadOnly
    public static String getRefData(String pjson){
        try{
        	system.debug('pjson :: ' + pjson);
            ClsAPLEntityTypes.MockObj mockObj = (ClsAPLEntityTypes.MockObj)Json.deserialize(pjson, ClsAPLEntityTypes.MockObj.class);
            ClsAPLInterface.IAPLRefDataService io =  ClsAPLForecastUtil.newRefDataInstance(mockObj.className);
            system.debug('io :: ' + io);
            ClsAPLEntityTypes.AcctFCResults result = (ClsAPLEntityTypes.AcctFCResults) io.getRefData(mockObj.str_json);
            system.debug('getRefData :: ' + result);
            return result.json_result;
        }catch(Exception e){
            throw e;
        }
    }
    
   /**
    * This method is used to load APL Sales forecast data for GAM & RSM 
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    @RemoteAction
    @ReadOnly
    public static String getGAMFC(String pjson){
        try{
            ClsAPLEntityTypes.MockObj mockObj = (ClsAPLEntityTypes.MockObj)Json.deserialize(pjson, ClsAPLEntityTypes.MockObj.class);
            system.debug('mockObj :: ' + mockObj);
            ClsAPLInterface.IAPLFCService io =  ClsAPLForecastUtil.newClassInstance(mockObj.className);
            system.debug('io :: ' + io);
            ClsAPLEntityTypes.AcctFCResults result = (ClsAPLEntityTypes.AcctFCResults) io.getFC(mockObj.str_json);
            system.debug('getGAMFC :: ' + result);
            return result.json_result;
        }catch(Exception e){
            throw e;
        }
    }
    
   /**
    * This method is used to save apl sales forecast data for GAM & RSM 
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    @RemoteAction
    public static String saveGAMFC(String pjson){
        try{
            system.debug('pjson :: ' + pjson);
            ClsAPLEntityTypes.MockObj mockObj = (ClsAPLEntityTypes.MockObj)Json.deserialize(pjson, ClsAPLEntityTypes.MockObj.class);
            ClsAPLInterface.IAPLFCService io =  ClsAPLForecastUtil.newClassInstance(mockObj.className);
            io.saveFC(mockObj.str_json);
            return pjson;
        }catch(Exception e){
            throw e;
        }
    }
    
   /**
    * This method is used to save apl sales forecast data for GAM & RSM 
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    @RemoteAction
    public static String unfreezeAM(String pjson) {
        try{
            system.debug('pjson :: ' + pjson);
            ClsAPLEntityTypes.RSMTerritoryFCInfo rsmTerritory = (ClsAPLEntityTypes.RSMTerritoryFCInfo)Json.deserialize(pjson, ClsAPLEntityTypes.RSMTerritoryFCInfo.class);
            ClsAPLServiceRSM.unfreezeAM(rsmTerritory);
            
            return pjson;
        }catch(Exception e) {
            throw e;
        }
    }

   /**
    * This method is used to save apl sales forecast data for GAM & RSM 
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public void submitAM() {
        try{
       		String pjson = ApexPages.currentPage().getParameters().get('submitamhidd');
            ClsAPLEntityTypes.RSMTerritoryFCInfo rsmTerritory = (ClsAPLEntityTypes.RSMTerritoryFCInfo)Json.deserialize(pjson, ClsAPLEntityTypes.RSMTerritoryFCInfo.class);
       		system.debug('rsmTerritory :: ' + rsmTerritory);
       		ClsGroupingAMForecastUtil.submitAMFC(rsmTerritory);
       		ClsAPLForecastUtil.addFrozenMsg();
            //ClsAPLServiceRSM.unfreezeAM(rsmTerritory);
            
        }catch(Exception e) {
            throw e;
        }
    }
    
   /**
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Bin Yuan
    @created 2014-04-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-04-22 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public String getOtherAcctId() {
        return ClsAPLForecastUtil.OTHERACCTID;
    }
    
    public class AcctForecast extends Superclass{
    }
    
    public class CBC2Forecast extends Superclass{
        public map<String, String> map_cbcName {get;set;}
        public map<String, set<Integer>> map_year_monthsHistory {get; set;}
        public String cbcCode {get; set;}
    }
    
    public class GPLInfo extends Superclass{
    	public String cbcCode {get; set;}
        public String partName {get; set;}
        public String cbc2Name {get; set;}
        public String gplName {get; set;}
        public String gplId {get;set;}
        public Boolean isTop {get;set;}
        public Boolean isOther {get;set;}
        public String quarterNumb {get; set;}  
        public set<String> json_partIds {get; set;}
        public boolean isNeedBillPercentage {get; set;}
        
    }
    
    public class PartInfo extends Superclass{
        public String gplId {get; set;}
        public String partId {get;set;}
        public Boolean isOther {get;set;}
        public String cbc2Name {get; set;}
        public set<String> set_partIds {get; set;}
    }
    
    public virtual class Superclass{
        public String territoryCode {get; set;}
        public String aid {get;set;}
        public boolean isRelay {get; set;}
        public map<String, set<String>> map_year {get;set;}
        public map<String, set<Integer>> map_year_monthsHistory {get; set;}
        public map<String, set<Integer>> map_year_monthsFuture {get; set;}
        public String refStartDate {get; set;}
        public String refEndDate {get; set;}
		public String periodStartDate {get; set;}
		public String currentYear {get; set;}
		public Integer currentMonth {get; set;}
        public map<String, String> map_acctId_currencyIso {get; set;}
        public list<String> list_dateKey {get; set;}
    }
    
}