/**
 *  Entity class for Controller components
 *
 @author    Bin Yuan
 @created   2014-05-30
 @version   1.0
 @since     29.0 (Force.com ApiVersion)
 *
 @changelog
 * 2014-05-30 Bin Yuan <bin.yuan@itbconsult.com>
 * - Created
 */
public without sharing class ClsAPLEntityTypes {

    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>InnerClass*/
    /**
     *  Inner class for LocaleConfig
     *
     @author    Bin Yuan
     @created   2014-05-30
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-05-30 Bin Yuan <bin.yuan@itbconsult.com>
     * - Created
     */
    public virtual class MockObj {
        public String className {get; set;}
        public String str_json {get;set;}
        
    }
    
    /**
     *  Inner class for LocaleConfig
     *
     @author    Bin Yuan
     @created   2014-05-30
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-05-30 Bin Yuan <bin.yuan@itbconsult.com>
     * - Created
     */
    public class LocaleConfig {
        public String locale {get;set;}
        public String jsPath {get;set;}
        
        public LocaleConfig() {}
        
        public LocaleConfig(String locale, String jsPath) {
            this.locale = locale;
            this.jsPath = jsPath;
        }
    }
    
    /**
     *  Inner class for AcctColumns
     *
     @author    Bin Yuan
     @created   2014-05-30
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-05-30 Bin Yuan <bin.yuan@itbconsult.com>
     * - Created
     */
    public class AcctColumns {
        public String name {get;set;}
        public String fieldName {get;set;}
        public String cls {get;set;}
        public String matchName {get; set;}
        public Boolean isInput {get; set;}
        
        public AcctColumns() {}
        
        public AcctColumns(String name, String fieldName, String cls, String matchName, boolean isInput) {
            this.name = name;
            this.fieldName = fieldName;
            this.cls = cls;
            this.matchName = matchName;
            this.isInput = isInput;
        }
    }


    /**
     *  Inner class for AcctGroupingTerritroy
     *
     @author    Bin Yuan
     @created   2014-05-30
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-05-30 Bin Yuan <bin.yuan@itbconsult.com>
     * - Created
     */
	public class AcctGroupingTerritroy {
     	public String territoryCode {get; set;}
     	public boolean isFrozen {get; set;}
     	
     	public AcctGroupingTerritroy() {
     		this.territoryCode = '';
     		this.isFrozen = false;
     	}
     	
     	public AcctGroupingTerritroy(String territoryCode, boolean isFrozen) {
     		this.territoryCode = territoryCode;
     		this.isFrozen = isFrozen;
     	}
     	
	}

    /**
     *  Inner class for DateItem
     *
     @author    Bin Yuan
     @created   2014-05-30
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-05-30 Bin Yuan <bin.yuan@itbconsult.com>
     * - Created
     */
    public class DateItem {
        public String itemName {get; set;}
        public String type {get; set;}
        public String cls {get; set;}
        public String total {get; set;}
        public String visiable {get; set;}
        public Boolean isInput {get; set;}
        public String type1 {get; set;}
        public String type2 {get; set;}
        public String type3 {get; set;}
        public String qtotalCls {get; set;}
        public String monthCls {get; set;}
        public String fYear {get; set;}
        public Integer fMonth {get; set;}
        public Decimal workingDays {get; set;}
        public String qLabel {get; set;}
        public String mLabel {get; set;}
        public String qMonths {get; set;}
        
        public DateItem(String name) {
            itemName = name;
            cls = '';
            total = '';
            type = '';
            type1 = '';
            type2 = '';
            type3 = '';
            visiable = 'true';
            isInput = false;
            fYear = '';
            fMonth = 0;
            workingDays = 0;   
            this.qtotalCls = ''; 
            this.monthCls = ''; 
            this.qLabel = '';
            this.mLabel = '';
            this.qMonths = '';
        }
    }

    /**
     *  Inner class for PageConfig
     *
     @author    Bin Yuan
     @created   2014-05-30
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-05-30 Bin Yuan <bin.yuan@itbconsult.com>
     * - Created
     */
    public class PageConfig {
    	public boolean isSetupDone {get; set;}
        public map<String, set<Integer>> map_financialMonth {get; set;}
        public map<String, Decimal> map_workingDays {get; set;}
        public String str_futureQuarterMap {get; set;}
        public String str_historyMonthMap {get; set;}
        public String str_futureMonthMap {get; set;}
        public String managerId {get; set;}
        public list<String> list_yearMonth {get; set;}
        public set<String> set_dateKey {get; set;}
        public String currentYear {get; set;}
        public Integer currentMonth {get; set;}
        public Integer currentMonthIndex {get; set;}
        public String quarterNumb {get; set;}
        public boolean isRelay {get; set;}
        public transient String str_tableHead {get; set;}
        public String currentTerritoryCode {get; set;}
        public map<String, set<String>> map_year_quartersFuture {get; set;}
        public map<String, set<Integer>> map_year_monthsFuture {get; set;}
        public map<String, set<Integer>> map_year_monthsHistory {get; set;}
        public set<String> set_parentIds = new set<String>();
        public String refStartDate {get; set;}
        public String refEndDate {get; set;}
        public String periodStartDate {get; set;}
        public map<String, String> map_acctId_currencyIso {get; set;}
        public String json_acctCurrency {get; set;}
        public String pricePlaces {get; set;}
        public String currencyPlaces {get; set;}
        public set<String> set_gamCodes {get; set;}
        public String json_setGAMCodes {get; set;}
        public set<String> set_territoryCodes {get; set;}
        public set<String> set_rsmAMTerritoryCodes {get; set;}
        public String json_rsmAMTerritoryCodes {get; set;}
        public set<String> set_rsmRelayTerritoryCodes {get; set;}
        public String rsmAMDisplayName {get; set;}
        public String rsmAMId {get; set;}
        public set<String> set_rsmRelayDisplayNames {get; set;}
        public set<String> set_rsmRelayIds {get; set;}
        public String json_rsmRelayTerritoryCodes {get; set;}
        public String json_rsmRelayDisplayNames {get; set;}
        public String json_rsmRelayIds {get; set;}
        public boolean isFrozen {get; set;}
        public boolean isOverallFrozen {get; set;}
        
        public PageConfig() {
        	this.isSetupDone = false;
            this.managerId = '';
            this.currentMonthIndex = 0;
            this.str_futureQuarterMap = '';
            this.map_financialMonth = new map<String, set<Integer>>();
            this.currentYear = '';
            this.currentMonth = 0;
            this.isRelay = false;
            this.set_dateKey = new set<String>();
            this.map_workingDays = new map<String, decimal>();
            this.list_yearMonth = new List<String>();
            this.map_workingDays = new Map<String, Decimal>();
            this.str_tableHead = '';
            this.currentTerritoryCode = '';
            this.map_year_quartersFuture = new map<String, set<String>>();
            this.map_year_monthsFuture = new map<String, set<Integer>>();
            this.map_year_monthsHistory = new map<String, set<Integer>>();
            this.set_parentIds = new set<String>();
            this.quarterNumb = '';
            this.str_futureMonthMap = '';
            this.refStartDate = '';
            this.refEndDate = '';
            this.periodStartDate = '';
            this.map_acctId_currencyIso = new map<String, String>();
            this.json_acctCurrency = '';
            this.pricePlaces = '';
            this.currencyPlaces = '';
            this.set_gamCodes = new set<String>();
            this.json_setGAMCodes = '';
            this.set_rsmAMTerritoryCodes = new set<String>();
            this.set_rsmRelayTerritoryCodes = new set<String>();
            this.rsmAMDisplayName = '';
            this.rsmAMId = '';
            this.set_rsmRelayDisplayNames = new set<String>();
            this.set_rsmRelayIds = new set<String>();
            this.json_rsmAMTerritoryCodes = '';
            this.json_rsmRelayTerritoryCodes = '';
            this.json_rsmRelayDisplayNames = '';
            this.json_rsmRelayIds = '';
            this.isFrozen = false;
            this.isOverallFrozen = false;
        }
    }

    
    /**
     *  Inner class for Account Info
     *
     @author    Bin Yuan
     @created   2014-05-30
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-05-30 Bin Yuan <bin.yuan@itbconsult.com>
     * - Created
     */
    public virtual class AcctInfo {
        
    }
    
    /**
     *  Inner class for GAMAcctInfo Info
     *
     @author    Bin Yuan
     @created   2014-05-30
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-05-30 Bin Yuan <bin.yuan@itbconsult.com>
     * - Created
     */
    public class GAMAcctInfo extends AcctInfo {
        public transient list<GAMRegionInfo> list_region {get;set;}
        public transient map<String, list<RegionAccountInfo>> map_region_acct {get;set;}
        public GAMAcctInfo() {
            this.list_region = new list<GAMRegionInfo>();
            this.map_region_acct = new map<String, list<RegionAccountInfo>>();
        }
    }
    
    /**
     *  Inner class for GAM Region info
     *
     @author    Bin Yuan
     @created   2014-05-30
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-05-30 Bin Yuan <bin.yuan@itbconsult.com>
     * - Created
     */
    public class GAMRegionInfo{
        public String regionName {get;set;}
        public String regionUniqCls {get;set;}
        public String gamTypeName {get; set;}
        public String gamRegionTypeName {get; set;}
        public String level2TerritoryCode {get; set;}
        
        public GAMRegionInfo(){
            this.regionName = '';
            this.regionUniqCls = '';
            this.gamTypeName = 'ClsAPLEntityTypes.GAMAcctFCInfo';
            this.gamRegionTypeName = 'ClsAPLEntityTypes.GAMRegionFCInfo';
        }
        public GAMRegionInfo(String regionName, String regionUniqCls){
            this.regionName = regionName;
            this.regionUniqCls = regionUniqCls;
            this.gamTypeName = 'ClsAPLEntityTypes.GAMAcctFCInfo';
            this.gamRegionTypeName = 'ClsAPLEntityTypes.GAMRegionFCInfo';
        }
        public GAMRegionInfo(String regionName, String regionUniqCls, String level2TerritoryCode){
            this.regionName = regionName;
            this.regionUniqCls = regionUniqCls;
            this.level2TerritoryCode = level2TerritoryCode;
            this.gamTypeName = 'ClsAPLEntityTypes.GAMAcctFCInfo';
            this.gamRegionTypeName = 'ClsAPLEntityTypes.GAMRegionFCInfo';
        }
    }
    /**
     *  Inner class for GAM Region Account info
     *
     @author    Bin Yuan
     @created   2014-05-30
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-05-30 Bin Yuan <bin.yuan@itbconsult.com>
     * - Created
     */
    public class RegionAccountInfo implements Comparable {
        public String aId {get;set;}
        public String aName {get;set;}
        public decimal csFCamount {get;set;}
        public RegionAccountInfo(){
            this.aId = '';
            this.aName = '';
            this.csFCamount = 0;
        }
        public RegionAccountInfo(String aId, String aName){
            this.aId = aId;
            this.aName = aName;
            this.csFCamount = 0;
        }
        
         public RegionAccountInfo(String aId, String aName, decimal amount){
            this.aId = aId;
            this.aName = aName;
            this.csFCamount = amount;
        }
        
        public Integer compareTo(Object compareTo) {
            RegionAccountInfo compareToAcct = (RegionAccountInfo) compareTo;
            if (this.csFCamount == compareToAcct.csFCamount) return 0;
            if (this.csFCamount > compareToAcct.csFCamount) return -1;
            return 1;        
        }
    }
    
    /**
     *  Inner class for GAM Region info
     *
     @author    Bin Yuan
     @created   2014-05-30
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-05-30 Bin Yuan <bin.yuan@itbconsult.com>
     * - Created
     */
    public class RSMTerritoryInfo implements Comparable {
        public String name {get;set;}
        public String displayName {get;set;}
        public String uniqCls {get;set;}
        public String amTypeName {get; set;}
        public String relayTypeName {get; set;}
        public boolean isFrozen {get; set;}
        
        public RSMTerritoryInfo() {
            this.name = '';
            this.uniqCls = '';
            this.amTypeName = 'ClsAPLEntityTypes.RSMAcctFCInfo';
            this.relayTypeName = 'ClsAPLEntityTypes.RSMRelayAcctFCInfo';
            this.isFrozen = false;
        }
        public RSMTerritoryInfo(String name, String uniqCls) {
            this.name = name;
            this.uniqCls = uniqCls;
            this.amTypeName = 'ClsAPLEntityTypes.RSMAcctFCInfo';
            this.relayTypeName = 'ClsAPLEntityTypes.RSMRelayAcctFCInfo';
            this.isFrozen = false;
        }
        public RSMTerritoryInfo(String name, String uniqCls, boolean isFrozen) {
            this.name = name;
            this.uniqCls = uniqCls;
            this.amTypeName = 'ClsAPLEntityTypes.RSMAcctFCInfo';
            this.relayTypeName = 'ClsAPLEntityTypes.RSMRelayAcctFCInfo';
            this.isFrozen = isFrozen;
        }
        public RSMTerritoryInfo(String name, String displayName, String uniqCls, boolean isFrozen) {
            this.name = name;
            this.displayName = displayName;
            this.uniqCls = uniqCls;
            this.amTypeName = 'ClsAPLEntityTypes.RSMAcctFCInfo';
            this.relayTypeName = 'ClsAPLEntityTypes.RSMRelayAcctFCInfo';
            this.isFrozen = isFrozen;
        }
        public Integer compareTo(Object compareTo) {
            RSMTerritoryInfo compareToGPL = (RSMTerritoryInfo) compareTo;
            if (this.name == compareToGPL.name) return 0;
            if (this.name > compareToGPL.name) return 1;
            return -1;        
        }
    }
    /**
     *  Inner class for Account Info
     *
     @author    Bin Yuan
     @created   2014-05-30
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-05-30 Bin Yuan <bin.yuan@itbconsult.com>
     * - Created
     */
    public class RSMAcctInfo extends AcctInfo {
        public map<String, String> map_type_instanceName {get; set;}
        public map<String, set<RSMTerritoryInfo>> map_type_territoryCodes {get; set;}
        public RSMAcctInfo() {
            this.map_type_instanceName = new map<String, String>();
            this.map_type_territoryCodes = new map<String, set<RSMTerritoryInfo>>();
        }
    }
    
    /**
     *  Inner class for query conditions for forecast
     *
     @author    Lei Tang
     @created   2014-06-03
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-06-03 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     */
    public virtual class FCInfo {
        public String parentId {get; set;}
        public String territoryCode {get; set;}
        public String quarterNumb {get; set;}
        public String currencyIso {get; set;}
        public map<String, decimal> map_dateKey_fc {get; set;}
        public map<String, set<String>> map_year_quartersFuture {get; set;}
        public map<String, set<Integer>> map_year_monthsHistory {get; set;}
        public map<String, set<Integer>> map_year_monthsFuture {get; set;}
        public String refStartDate {get; set;}
        public String refEndDate {get; set;}
        public String periodStartDate {get; set;}
		public String currentYear {get; set;}
		public Integer currentMonth {get; set;}
        public list<String> list_dateKey {get; set;}
    }
    
    /**
     *  Inner class for query conditions for forecast from Account
     *
     @author    Lei Tang
     @created   2014-06-03
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-06-03 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     */
    public class RSMTotalFCInfo extends FCInfo implements ClsAPLInterface.IAPLRefDataService {
        public set<String> set_terrtoryCodes {get; set;}
        public boolean isTCProd {get; set;}
         
        public AcctFCResults getRefData(String str_json) {
 			RSMTotalFCInfo totalInfo = (RSMTotalFCInfo) json.deserialize(str_json, RSMTotalFCInfo.class);
            //todo get forecast
            system.debug('totalInfo :: ' + totalInfo);
            return ClsAPLServiceRSM.getRSMTotalRefData(totalInfo);
        }
    }

	/**
     *  Inner class for query conditions for forecast from Account
     *
     @author    Lei Tang
     @created   2014-06-03
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-06-03 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     */
    public class RSMRelayTotalFCInfo extends FCInfo implements ClsAPLInterface.IAPLRefDataService {
        public set<String> set_terrtoryCodes {get; set;}
         
        public AcctFCResults getRefData(String str_json) {
 			RSMRelayTotalFCInfo totalInfo = (RSMRelayTotalFCInfo) json.deserialize(str_json, RSMRelayTotalFCInfo.class);
            //todo get refData
            return ClsAPLServiceRSMRelay.getRSMTotalRefData(totalInfo);
            //return new AcctFCResults();
        }
    }


    /**
     *  Inner class for query conditions for forecast from Account
     *
     @author    Lei Tang
     @created   2014-06-03
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-06-03 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     */
    public class RSMTerritoryFCInfo extends FCInfo implements ClsAPLInterface.IAPLFCService, ClsAPLInterface.IAPLRefDataService {
        public String acctId {get; set;}
        public String territoryCode {get; set;}
        public String managerId {get; set;}
        public void saveFC(String str_json) {
            //todo save forecast
        }
        public AcctFCResults getFC(String str_json) {
             RSMTerritoryFCInfo territoryInfo = (RSMTerritoryFCInfo) json.deserialize(str_json, RSMTerritoryFCInfo.class);
            //todo get forecast
            return ClsAPLServiceRSM.getRSMTerritoryFC(territoryInfo);
        }
        
        public AcctFCResults getRefData(String str_json) {
 			RSMTerritoryFCInfo territoryInfo = (RSMTerritoryFCInfo) json.deserialize(str_json, RSMTerritoryFCInfo.class);
            //todo get forecast
            return ClsAPLServiceRSM.getRSMTerritoryRefData(territoryInfo);
        }
        
    }
    
     /**
     *  Inner class for query conditions for forecast from Account
     *
     @author    Lei Tang
     @created   2014-06-03
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-06-03 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     */
    public class RSMRelayTerritoryFCInfo extends FCInfo implements ClsAPLInterface.IAPLFCService, ClsAPLInterface.IAPLRefDataService {
        public String acctId {get; set;}
        public String territoryCode {get; set;}
        public void saveFC(String str_json) {
            //todo save forecast
        }
        public AcctFCResults getFC(String str_json) {
             RSMRelayTerritoryFCInfo territoryInfo = (RSMRelayTerritoryFCInfo) json.deserialize(str_json, RSMRelayTerritoryFCInfo.class);
            //todo get forecast
            return ClsAPLServiceRSMRelay.getRSMTerritoryFC(territoryInfo);
            //return new AcctFCResults();
        }
        
        public AcctFCResults getRefData(String str_json) {
 			RSMRelayTerritoryFCInfo territoryInfo = (RSMRelayTerritoryFCInfo) json.deserialize(str_json, RSMRelayTerritoryFCInfo.class);
            //todo get forecast
            return ClsAPLServiceRSMRelay.getRSMTerritoryRefData(territoryInfo);
            //return new AcctFCResults();
        }
    }

    /**
     *  Inner class for query conditions for forecast from Account
     *
     @author    Lei Tang
     @created   2014-06-03
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-06-03 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     */
    public class RSMAcctFCInfo extends FCInfo implements ClsAPLInterface.IAPLFCService, ClsAPLInterface.IAPLRefDataService {
        public String acctId {get; set;}
        
        public void saveFC(String str_json) {
            RSMAcctFCInfo acctInfo = (RSMAcctFCInfo) json.deserialize(str_json, RSMAcctFCInfo.class);
            
            //todo save forecast
        }
        public AcctFCResults getFC(String str_json) {
             RSMAcctFCInfo acctInfo = (RSMAcctFCInfo) json.deserialize(str_json, RSMAcctFCInfo.class);
            //todo get forecast
            return ClsAPLServiceRSM.getRSMAcctFC(acctInfo);
        }
        
        public AcctFCResults getRefData(String str_json) {
 			RSMAcctFCInfo acctInfo = (RSMAcctFCInfo) json.deserialize(str_json, RSMAcctFCInfo.class);
            //todo get forecast
            return ClsAPLServiceRSM.getRSMAcctRefData(acctInfo);
        }
    }
    
    /**
     *  Inner class for query conditions for forecast from Account
     *
     @author    Lei Tang
     @created   2014-06-03
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-06-03 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     */
    public class RSMAMOverRallInfo extends FCInfo implements ClsAPLInterface.IAPLFCService {
        public String managerId {get; set;}
        public map<String, decimal> map_dateKey_fc {get; set;}
        public String displayName {get; set;}
        public String rsmId {get; set;}
        public void saveFC(String str_json) {
            RSMAMOverRallInfo overRallInfo = (RSMAMOverRallInfo) json.deserialize(str_json, RSMAMOverRallInfo.class);
            system.debug('overRallInfo :: ' + overRallInfo);
            ClsAPLServiceRSM.saveOverRallFC(overRallInfo);
        }
        public AcctFCResults getFC(String str_json) {
             RSMAMOverRallInfo overRallInfo = (RSMAMOverRallInfo) json.deserialize(str_json, RSMAMOverRallInfo.class);
            //todo get forecast
            return ClsAPLServiceRSM.getRSMAMOverRallFC(overRallInfo);
        }
    }
    
    /**
     *  Inner class for query conditions for forecast from Account
     *
     @author    Lei Tang
     @created   2014-06-03
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-06-03 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     */
    public class RSMRelayOverRallInfo extends FCInfo implements ClsAPLInterface.IAPLFCService {
        public String managerId {get; set;}
        public map<String, map<String, decimal>> map_name_map_dateKey_fc {get; set;}
        public set<String> set_displayNames {get; set;}  
        public set<String> set_rsmIds {get; set;}       
        public void saveFC(String str_json) {
            RSMRelayOverRallInfo overRallInfo = (RSMRelayOverRallInfo) json.deserialize(str_json, RSMRelayOverRallInfo.class);
            ClsAPLServiceRSMRelay.saveOverRallFC(overRallInfo);
            //todo save forecast
        }
        public AcctFCResults getFC(String str_json) {
             RSMRelayOverRallInfo overRallInfo = (RSMRelayOverRallInfo) json.deserialize(str_json, RSMRelayOverRallInfo.class);
            //todo get forecast
            return ClsAPLServiceRSMRelay.getRSMRelayOverRallFC(overRallInfo);
        }
    }
    
    /**
     *  Inner class for query conditions for forecast from Account
     *
     @author    Lei Tang
     @created   2014-06-03
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-06-03 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     */
    public class RSMRelayAcctFCInfo extends FCInfo implements ClsAPLInterface.IAPLFCService, ClsAPLInterface.IAPLRefDataService{
        public map<String, RelayFC> map_dateKey_relayFC {get; set;}
        public String acctId {get; set;}
        public RSMRelayAcctFCInfo() {
            this.parentId = '';
            this.map_year_quartersFuture = new map<String, set<String>>();
        }
        public void saveFC(String str_json) {
            ClsAPLEntityTypes.RelayAcctFCInfo acctInfo = (ClsAPLEntityTypes.RelayAcctFCInfo) json.deserialize(str_json, ClsAPLEntityTypes.RelayAcctFCInfo.class);
            //todo save forecast
            //ClsAPLServiceRSMRelay.saveAcctFC(acctInfo);
        }
        public AcctFCResults getFC(String str_json) {
        	/*
            AcctFCResults result = new AcctFCResults();
            //todo get forecast
            return result;  
            */  
            // add lili 
            RSMRelayAcctFCInfo relayAccFCInfo = (RSMRelayAcctFCInfo) json.deserialize(str_json, RSMRelayAcctFCInfo.class);
            return ClsAPLServiceRSMRelay.getRelayAcctFC(relayAccFCInfo);
        }
        
         public AcctFCResults getRefData(String str_json) {
 			RSMRelayAcctFCInfo acctInfo = (RSMRelayAcctFCInfo) json.deserialize(str_json, RSMRelayAcctFCInfo.class);
            //todo get forecast
            return ClsAPLServiceRSMRelay.getRSMRelayAcctRefData(acctInfo);
        }
    }
    
    /**
     *  Inner class for query conditions for forecast from Account
     *
     @author    Lei Tang
     @created   2014-06-03
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-06-03 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     */
    public class RelayAcctFCInfo extends FCInfo implements ClsAPLInterface.IAPLFCService{
        
        public map<String, RelayFC> map_dateKey_relayFC {get; set;}
        
        public void saveFC(String str_json) {
            RelayAcctFCInfo acctInfo = (RelayAcctFCInfo) json.deserialize(str_json, RelayAcctFCInfo.class);
            //ClsGroupingRelayForecastUtil.saveAcctFC(acctInfo);
        }
        public AcctFCResults getFC(String str_json) {
            AcctFCResults result = new AcctFCResults();
            //todo get forecast
            return result;
        }
    }
    
    /**
     *  Inner class for query conditions for forecast from Account
     *
     @author    Lei Tang
     @created   2014-06-03
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-06-03 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     */
    public class RelayFC {
        public decimal price {get; set;}
        public decimal amount {get; set;}
        public decimal total {get; set;}
    }
    
    /**
     *  Inner class for query conditions for forecast from Account
     *
     @author    Lei Tang
     @created   2014-06-03
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-06-03 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     */
    public class GAMAcctFCInfo extends FCInfo implements ClsAPLInterface.IAPLFCService, ClsAPLInterface.IAPLRefDataService {
        public set<String> set_acctIds {get; set;}
        public string acctId {get; set;}
        public String quartNumb {get; set;}
        public map<string, decimal> map_dateKey_cmaFC {get; set;}
        public map<string, decimal> map_dateKey_posFC {get; set;}
        
        public void saveFC(String str_json) {
            GAMAcctFCInfo acctInfo = (GAMAcctFCInfo) json.deserialize(str_json, GAMAcctFCInfo.class);
            //todo save forecast
            //ClsAPLServiceGAM.saveGAMAcctFC(acctInfo);
        }
        public AcctFCResults getFC(String str_json) {
            system.debug('GAMAcctFCInfo str_json :: ' + str_json);
            GAMAcctFCInfo gamAcct = (GAMAcctFCInfo) json.deserialize(str_json, GAMAcctFCInfo.class);
            //ClsAPLServiceGAM.getGAMAcctFC(gamAcct);
            return ClsAPLServiceGAM.getGAMAcctFC(gamAcct);
        }
        public AcctFCResults getRefData(String str_json) {
 			GAMAcctFCInfo acctInfo = (GAMAcctFCInfo) json.deserialize(str_json, GAMAcctFCInfo.class);
            //todo get forecast
            return ClsAPLServiceGAM.getGAMAcctRefData(acctInfo);
        }
    
    }
    /**
     *  Inner class for query conditions for forecast from Account
     *
     @author    Lei Tang
     @created   2014-06-03
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-06-03 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     */
    public class GAMRegionFCInfo extends FCInfo implements ClsAPLInterface.IAPLFCService, ClsAPLInterface.IAPLRefDataService {
        public string level2TerritoryCode {get; set;}
        public String quartNumb {get; set;}
        public map<string, decimal> map_dateKey_cmaFC {get; set;}
        public map<string, decimal> map_dateKey_posFC {get; set;}
        public set<String> set_gamCodes {get; set;}
        
        public void saveFC(String str_json) {
            //to do save forecast
        }
        public AcctFCResults getFC(String str_json) {
            system.debug('GAMAcctFCInfo str_json :: ' + str_json);
            GAMRegionFCInfo gamRegion = (GAMRegionFCInfo) json.deserialize(str_json, GAMRegionFCInfo.class);
            //ClsAPLServiceGAM.getGAMRegionFC(gamAcct);
            return ClsAPLServiceGAM.getGAMRegionFC(gamRegion);
        }
        
        public AcctFCResults getRefData(String str_json) {
 			GAMRegionFCInfo gamRegion = (GAMRegionFCInfo) json.deserialize(str_json, GAMRegionFCInfo.class);
            //todo get forecast
            return ClsAPLServiceGAM.getGAMRegionRefData(gamRegion);
        }
    }
    
    /**
     *  Inner class for query conditions for forecast from Account
     *
     @author    Lei Tang
     @created   2014-06-03
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-06-03 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     */
    public class RSMCBCFCInfo extends FCInfo implements ClsAPLInterface.IAPLFCService, ClsAPLInterface.IAPLRefDataService {
        public String acctId {get; set;}
        public String cbcCode {get; set;}
        public list<String> list_dateKey {get; set;}
        public map<String, String> map_cbcRowKey_cbcName {get; set;}

        public void saveFC(String str_json) {
            RSMCBCFCInfo acctInfo = (RSMCBCFCInfo) json.deserialize(str_json, RSMCBCFCInfo.class);
            //todo save forecast
        }
        public AcctFCResults getFC(String str_json) {
 			RSMCBCFCInfo cbcInfo = (RSMCBCFCInfo) json.deserialize(str_json, RSMCBCFCInfo.class);
            //todo get forecast
            return ClsAPLServiceRSM.getRSMCBCFC(cbcInfo);
        }
        public AcctFCResults getRefData(String str_json) {
 			RSMCBCFCInfo cbcInfo = (RSMCBCFCInfo) json.deserialize(str_json, RSMCBCFCInfo.class);
            //todo get forecast
            return ClsAPLServiceRSM.getRSMCBCRefData(cbcInfo);
        }
    
    }
    
    /**
     *  Inner class for query conditions for forecast from Account
     *
     @author    Lei Tang
     @created   2014-06-03
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-06-03 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     */
    public class RSMRelayCBCFCInfo extends FCInfo implements ClsAPLInterface.IAPLFCService, ClsAPLInterface.IAPLRefDataService{
        public String cbc2Code {get; set;}
        public String acctId {get; set;}
        public map<String, String> map_cbcRowKey_cbcName {get; set;}
        public list<RelayPartFCInfo> list_partFC{get; set;}

        public void saveFC(String str_json) {
            RSMRelayCBCFCInfo relayCBCInfo = (RSMRelayCBCFCInfo) json.deserialize(str_json, RSMRelayCBCFCInfo.class);
            //todo save forecast
            ClsAPLServiceRSMRelay.savePartFC(relayCBCInfo);
        }
        public AcctFCResults getFC(String str_json) {
        	/*
            AcctFCResults result = new AcctFCResults();
            //todo get forecast
            return result;
            */
            // add lili
            RSMRelayCBCFCInfo relayCBCFCInfo = (RSMRelayCBCFCInfo) json.deserialize(str_json, RSMRelayCBCFCInfo.class);
            return ClsAPLServiceRSMRelay.getRelayCBCFC(relayCBCFCInfo);
        }
        
        public AcctFCResults getRefData(String str_json) {
 			RSMRelayCBCFCInfo cbcInfo = (RSMRelayCBCFCInfo) json.deserialize(str_json, RSMRelayCBCFCInfo.class);
            //todo get forecast
            return ClsAPLServiceRSMRelay.getRSMRelayCBCRefData(cbcInfo);
        }
    
    }
    
    /**
     *  Inner class for query conditions for forecast from Account
     *
     @author    Lei Tang
     @created   2014-06-03
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-06-03 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     */
    public class GAMCBCFCInfo extends FCInfo implements ClsAPLInterface.IAPLFCService, ClsAPLInterface.IAPLRefDataService {
        public String acctId {get; set;}
        public map<String, String> map_cbcRowKey_cbcName {get; set;}
        public String cbcCode {get; set;}
        public void saveFC(String str_json) {
            GAMCBCFCInfo acctInfo = (GAMCBCFCInfo) json.deserialize(str_json, GAMCBCFCInfo.class);
            //todo save forecast
        }
        public AcctFCResults getFC(String str_json) {
            //AcctFCResults result = new AcctFCResults();
            //todo get forecast
            GAMCBCFCInfo gamCBC = (GAMCBCFCInfo) json.deserialize(str_json, GAMCBCFCInfo.class);
            return ClsAPLServiceGAM.getGAMCBCFC(gamCBC);
        }
        
        public AcctFCResults getRefData(String str_json) {
 			GAMCBCFCInfo cbcInfo = (GAMCBCFCInfo) json.deserialize(str_json, GAMCBCFCInfo.class);
            //todo get forecast
            return ClsAPLServiceGAM.getGAMCBCRefData(cbcInfo);
        }
    }
    
    /**
     *  Inner class for query conditions for forecast from Account
     *
     @author    Lei Tang
     @created   2014-06-03
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-06-03 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     */
    public class RelayCBCFCInfo extends FCInfo implements ClsAPLInterface.IAPLFCService{
        public String cbc2Code {get; set;}
        public list<RelayPartFCInfo> list_partFC{get; set;}
        
        public void saveFC(String str_json) {
            RelayCBCFCInfo acctInfo = (RelayCBCFCInfo) json.deserialize(str_json, RelayCBCFCInfo.class);
            ClsGroupingRelayForecastUtil.savePartFC(acctInfo);
        }
        public AcctFCResults getFC(String str_json) {
            AcctFCResults result = new AcctFCResults();
            //todo get forecast
            return result;
        }
    
    }
    
    /**
     *  Inner class for query conditions for forecast from Account
     *
     @author    Lei Tang
     @created   2014-06-03
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-06-03 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     */
    public class RSMGPLFCInfo extends FCInfo implements ClsAPLInterface.IAPLFCService, ClsAPLInterface.IAPLRefDataService {
        public String cbc2Code {get; set;}
        public String cbcCode {get; set;}
        public String acctId {get; set;}
        public String gplId {get; set;}
        public list<RSMPartFCInfo> list_parts {get; set;}
        public list<String> list_dateKey {get; set;}
        
        public void saveFC(String str_json) {
            RSMGPLFCInfo gplInfo = (RSMGPLFCInfo) json.deserialize(str_json, RSMGPLFCInfo.class);
            system.debug('gplInfo :: ' + gplInfo);
            //todo save forecast
            ClsAPLServiceRSM.saveRSMGPLFC(gplInfo);
        }
        public AcctFCResults getFC(String str_json) {
        	
 			RSMGPLFCInfo gplInfo = (RSMGPLFCInfo) json.deserialize(str_json, RSMGPLFCInfo.class);
            //todo get forecast
            if(gplInfo.cbc2Code == ClsAPLForecastUtil.RELAYFCTYPE) {
            	return ClsAPLServiceRSM.getRSMRelayCBCFC(gplInfo);
            }
            return ClsAPLServiceRSM.getRSMGPLFC(gplInfo);
        }
        public AcctFCResults getRefData(String str_json) {
 			RSMGPLFCInfo gplInfo = (RSMGPLFCInfo) json.deserialize(str_json, RSMGPLFCInfo.class);
             //todo get forecast
            return ClsAPLServiceRSM.getRSMGPLRefData(gplInfo);
        }
    }
    /**
     *  Inner class for query conditions for forecast from Account
     *
     @author    Lei Tang
     @created   2014-06-03
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-06-03 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     */
    public class RSMRelayGPLFCInfo extends FCInfo implements ClsAPLInterface.IAPLFCService{
        public String cbc2Code {get; set;}
        public String acctId {get; set;}
        public String gplId {get; set;}

        public void saveFC(String str_json) {
            RSMGPLFCInfo acctInfo = (RSMGPLFCInfo) json.deserialize(str_json, RSMGPLFCInfo.class);
            //todo save forecast
        }
        public AcctFCResults getFC(String str_json) {
        	
            RSMRelayGPLFCInfo relayInfo = (RSMRelayGPLFCInfo) json.deserialize(str_json, RSMRelayGPLFCInfo.class);
            system.debug('relayInfo::: '+relayInfo);
            return ClsAPLServiceRSMRelay.getPartFC(relayInfo);
            
        }
    }
    
    /**
     *  Inner class for query conditions for forecast from Account
     *
     @author    Lei Tang
     @created   2014-06-03
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-06-03 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     */
    public class GAMGPLFCInfo extends FCInfo implements ClsAPLInterface.IAPLFCService, ClsAPLInterface.IAPLRefDataService {
        public String cbc2Code {get; set;}
        public String cbcCode {get; set;}
        public String acctId {get; set;}
        public String gplId {get; set;}
        public list<String> list_partId {get; set;}
        public list<GAMPartFCInfo> list_parts {get; set;}
        public map<string, decimal> map_dateKey_cmaFC {get; set;}
        public map<string, decimal> map_dateKey_posFC {get; set;}       

        public void saveFC(String str_json) {
            GAMGPLFCInfo acctInfo = (GAMGPLFCInfo) json.deserialize(str_json, GAMGPLFCInfo.class);
            //todo save forecast
            ClsAPLServiceGAM.saveGAMGPLFC(acctInfo);
        }
        public AcctFCResults getFC(String str_json) {
            AcctFCResults result = new AcctFCResults();
            system.debug('str_json :: ' + str_json);
            GAMGPLFCInfo gamGPL = (GAMGPLFCInfo) json.deserialize(str_json, GAMGPLFCInfo.class);
            system.debug('gamGPL :: ' + gamGPL);
            //todo get forecast
            if(gamGPL.cbc2Code == ClsAPLForecastUtil.RELAYFCTYPE) {
            	return ClsAPLServiceGAM.getGAMRelayCBCFC(gamGPL);
            }
            return ClsAPLServiceGAM.getGAMGPLFC(gamGPL);
        }
        
        public AcctFCResults getRefData(String str_json) {
 			GAMGPLFCInfo gamGPL = (GAMGPLFCInfo) json.deserialize(str_json, GAMGPLFCInfo.class);
            //todo get forecast
            return ClsAPLServiceGAM.getGAMGPLRefData(gamGPL);
        }
    }
    
    /**
     *  Inner class for query conditions for forecast from Account
     *
     @author    Lei Tang
     @created   2014-06-03
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-06-03 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     */
    public class RSMPartFCInfo extends FCInfo implements ClsAPLInterface.IAPLFCService{
        public String cbc2Code {get; set;}
        public String acctId {get; set;}
        public String gplId {get; set;}
        public String partId {get; set;}

        public void saveFC(String str_json) {
            RSMPartFCInfo acctInfo = (RSMPartFCInfo) json.deserialize(str_json, RSMPartFCInfo.class);
            //todo save forecast
        }
        public AcctFCResults getFC(String str_json) {
 			RSMPartFCInfo partInfo = (RSMPartFCInfo) json.deserialize(str_json, RSMPartFCInfo.class);
            //todo get forecast
            return ClsAPLServiceRSM.getRSMPartFC(partInfo);
        }
    }
    /**
     *  Inner class for query conditions for forecast from Account
     *
     @author    Lei Tang
     @created   2014-06-03
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-06-03 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     */
    public class RSMRelayPartFCInfo extends FCInfo implements ClsAPLInterface.IAPLFCService{
        public String cbc2Code {get; set;}
        public boolean isRelay {get; set;}
        public boolean isOther {get; set;}
        public String gplId {get; set;}
        public String partId {get; set;}
        // add lili 
        public String partName {get; set;}
        //public set<String> set_partId {get; set;}
        

        public void saveFC(String str_json) {
            RSMRelayCBCFCInfo relayCBCInfo = (RSMRelayCBCFCInfo) json.deserialize(str_json, RSMRelayCBCFCInfo.class);
            //todo save forecast
            //ClsAPLServiceRSMRelay.savePartFC(relayCBCInfo);
        }  
        public AcctFCResults getFC(String str_json) {
        	
            AcctFCResults result = new AcctFCResults();
            return result;
            /* 
            // add lili
            RSMRelayPartFCInfo relayInfo = (RSMRelayPartFCInfo) json.deserialize(str_json, RSMRelayPartFCInfo.class);
            return ClsAPLServiceRSMRelay.getPartFC(relayInfo);
            */
        }
        /*
        public AcctFCResults searchRelayPart(String str_json) {
        	
        	RSMRelayPartFCInfo relayPartInfo = (RSMRelayPartFCInfo) json.deserialize(str_json, RSMRelayPartFCInfo.class);
            return ClsAPLServiceRSMRelay.addPart(relayPartInfo);
        }
        
        public AcctFCResults deletePart(String str_json) {
        	
        	RSMRelayPartFCInfo relayPartInfo = (RSMRelayPartFCInfo) json.deserialize(str_json, RSMRelayPartFCInfo.class);
            return ClsAPLServiceRSMRelay.deletePart(relayPartInfo);
        }
        */
    }
    
    /**
     *  Inner class for query conditions for forecast from Account
     *
     @author    Lei Tang
     @created   2014-06-03
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-06-03 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     */
    public class GAMPartFCInfo extends FCInfo implements ClsAPLInterface.IAPLFCService{
        public String cbc2Code {get; set;}
        public String gplId {get; set;}
        public String partId {get; set;}
        public String acctId {get; set;}
        public map<string, decimal> map_dateKey_cmaFC {get; set;}
        public map<string, decimal> map_dateKey_posFC {get; set;}

        public void saveFC(String str_json) {
            GAMPartFCInfo acctInfo = (GAMPartFCInfo) json.deserialize(str_json, GAMPartFCInfo.class);
            //todo save forecast
        }
        public AcctFCResults getFC(String str_json) {
            AcctFCResults result = new AcctFCResults();
            GAMPartFCInfo gamPart = (GAMPartFCInfo) json.deserialize(str_json, GAMPartFCInfo.class);
            //todo get forecast

            return ClsAPLServiceGAM.getGAMPartFC(gamPart);
        }
    }
    
    /**
     *  Inner class for query conditions for forecast from Account
     *
     @author    Lei Tang
     @created   2014-06-03
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-06-03 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     */
    public class RelayPartFCInfo extends FCInfo{
        public String cbc2Code {get; set;}
        public String partId {get; set;}
        public String gplId {get; set;}
        public map<String, RelayFC> map_dateKey_relayFC {get; set;}
        
    }
    
    /**
     *  Inner class for 
     *
     @author    Lei Tang
     @created   2014-06-03
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-06-03 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     */
    public class RelayPartObj {
        public String partId {get; set;}
        public String partName {get; set;}
        public String Description {get; set;}
        public decimal precent {get; set;}
        
        public RelayPartObj() {
            this.partId = '';
            this.partName = '';
            this.Description = '';
            this.precent = 0;
        }
    }
       
    /**
     *  Inner class for return result 
     *
     @author    Lei Tang
     @created   2014-06-03
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-06-03 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     */
    public virtual class FCResults {
        public String json_result {get; set;}
    }
    
    
    /**
     *  Inner class for return APL_Sales_Forecast__c list
     *
     @author    Lei Tang
     @created   2014-06-03
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-06-03 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     */
    public class AcctFCResults extends FCResults {
        
    
    }
    
    public class AcctFCValueObj extends FCValueObj implements Comparable{
        public String acctId {get; set;}
        public map<String, decimal> posFC {get; set;}
        public map<String, decimal> cmaFC {get; set;}
        public map<String, decimal> totalBilling {get; set;}
        public map<String, decimal> totalBooking {get; set;}
        public map<String, decimal> totalBacklog {get; set;}
        public map<String, decimal> totalSA {get; set;}
        public map<String, decimal> fc2MAccuracy {get; set;}
        public map<String, decimal> fc3MAccuracy {get; set;}
        public map<String, decimal> fc6MAccuracy {get; set;}

        public AcctFCValueObj() {
            this.fieldName = '';
            this.currentFC = new map<String, decimal>();
            this.previousFC = new map<String, decimal>();
            this.amFC = new map<String, decimal>();
            this.posFC = new map<String, decimal>();
            this.cmaFC = new map<String, decimal>();
            this.totalBilling = new map<String, decimal>();
            this.totalBooking = new map<String, decimal>();
            this.totalBacklog = new map<String, decimal>();
            this.totalSA = new map<String, decimal>();
            this.fc2MAccuracy = new map<String, decimal>();
            this.fc3MAccuracy = new map<String, decimal>();
            this.fc6MAccuracy = new map<String, decimal>();
            this.gamTypeName = 'ClsAPLEntityTypes.GAMCBCFCInfo';
            this.rsmTypeName = 'ClsAPLEntityTypes.RSMCBCFCInfo';
            this.rsmRelayTypeName = 'ClsAPLEntityTypes.RSMRelayCBCFCInfo';
        }
        
        public override Object assignFCValues(FCValueObj superObj, AggregateResult result, String dateKey) {
            AcctFCValueObj obj = (AcctFCValueObj) superObj;
            decimal fc = (decimal) ((result == null || result.get('fc') == null ) ? 0 : result.get('fc'));
            decimal posFC = 0; //(decimal) ((result == null || result.get('posFC') == null ) ? 0 : result.get('posFC'));
            decimal cmaFC = 0; //(decimal) ((result == null || result.get('cmaFC') == null ) ? 0 : result.get('cmaFC'));
            decimal prevFC = (decimal) ((result == null || result.get('prevFC') == null ) ? 0 : result.get('prevFC'));
            decimal amFC = (decimal) ((result == null || result.get('amFC') == null ) ? 0 : result.get('amFC'));
            
            obj.currentFC.put(dateKey, fc);
            obj.previousFC.put(dateKey, prevFC);
            obj.posFC.put(dateKey, posFC);
            obj.cmaFC.put(dateKey, cmaFC);
            obj.amFC.put(dateKey, amFC);
            
            //empty values for follow maps
            obj.totalBilling.put(dateKey, 0);
            obj.totalBooking.put(dateKey, 0);
            obj.totalBacklog.put(dateKey, 0);
            obj.totalSA.put(dateKey, 0);
            obj.fc2MAccuracy.put(dateKey, 0);
            obj.fc3MAccuracy.put(dateKey, 0);
            obj.fc6MAccuracy.put(dateKey, 0);
            return obj;
        }
        
        public AcctFCValueObj assignRefData(AcctFCValueObj acctObj, AggregateResult result, String dateKey, boolean isMonthly) {
            
            decimal totalBilling = (decimal) ((result == null || result.get('billing') == null) ? 0 : result.get('billing'));
            decimal totalBooking = (decimal) ((result == null || result.get('booking') == null) ? 0 : result.get('booking'));
            decimal totalBacklog = (decimal) ((isMonthly || result == null || result.get('backlog') == null) ? 0 : result.get('backlog'));
            
            totalBilling += (acctObj.totalBilling.containsKey(dateKey) ? acctObj.totalBilling.get(dateKey) : 0);
            totalBooking += (acctObj.totalBooking.containsKey(dateKey) ? acctObj.totalBooking.get(dateKey) : 0);
            totalBacklog += (acctObj.totalBacklog.containsKey(dateKey) ? acctObj.totalBacklog.get(dateKey) : 0);
            acctObj.totalBilling.put(dateKey, totalBilling);
            acctObj.totalBooking.put(dateKey, totalBooking);
            acctObj.totalBacklog.put(dateKey, totalBacklog);
            
            return acctObj;
        }
        
        public AcctFCValueObj assignHisBacklogRefData(AcctFCValueObj acctObj, AggregateResult result, String dateKey) {
            
            decimal totalBacklog = (decimal) ((result == null || result.get('backlog') == null) ? 0 : result.get('backlog'));
            
            
            totalBacklog += (decimal) (acctObj.totalBacklog.containsKey(dateKey) ? acctObj.totalBacklog.get(dateKey) : 0);
            acctObj.totalBacklog.put(dateKey, totalBacklog);
            
            return acctObj;
        }
        
        public Integer compareTo(Object compareTo) {
            AcctFCValueObj compareToAcct = (AcctFCValueObj) compareTo;
            if (this.fieldName == compareToAcct.fieldName) return 0;
            if (this.fieldName > compareToAcct.fieldName) return -1;
            return 1;        
        }
    }
    
    public class CBCFCValueObj extends FCValueObj {
        public String prodHichyId {get; set;}
        public String gplCode {get; set;}
        public decimal precent {get; set;}
        public boolean isHighLighted {get; set;}
        public map<String, decimal> billing {get; set;}
        public map<String, decimal> booking {get; set;}
        public map<String, decimal> backlog {get; set;}
        
        public CBCFCValueObj() {
            this.prodHichyId = ''; 
            this.gplCode = '';
            this.precent = 0;
            this.isHighLighted = false;
            this.currentFC = new map<String, decimal>();
            this.previousFC = new map<String, decimal>();
            this.amFC = new map<String, decimal>();
            this.billing = new map<String, decimal>();
            this.booking = new map<String, decimal>();
            this.backlog = new map<String, decimal>();
            this.gamTypeName = 'ClsAPLEntityTypes.GAMGPLFCInfo';
            this.rsmTypeName = 'ClsAPLEntityTypes.RSMGPLFCInfo';
            this.rsmRelayTypeName = 'ClsAPLEntityTypes.RSMRelayGPLFCInfo';
        }
        
        public override Object assignFCValues(FCValueObj superObj, AggregateResult result, String dateKey) {
            
            CBCFCValueObj obj = (CBCFCValueObj) superObj;
            
            decimal fc = (decimal) ((result == null || result.get('fc') == null ) ? 0 : result.get('fc'));
            decimal prevFC = (decimal) ((result == null || result.get('prevFC') == null ) ? 0 : result.get('prevFC'));
            decimal amFC = (decimal) ((result == null || result.get('amFC') == null ) ? 0 : result.get('amFC'));
            
            fc += (obj.currentFC.containsKey(dateKey) ? obj.currentFC.get(dateKey) : 0);
            prevFC += (obj.previousFC.containsKey(dateKey) ? obj.previousFC.get(dateKey) : 0);
            amFC += (obj.amFC.containsKey(dateKey) ? obj.amFC.get(dateKey) : 0);
            
            obj.currentFC.put(dateKey, fc);
            obj.previousFC.put(dateKey, prevFC);
            obj.amFC.put(dateKey, amFC);
            
            return obj;
        }
        
        
        public CBCFCValueObj assignRefData(CBCFCValueObj cbcObj, AggregateResult result, String dateKey, boolean isMonthly) {
            
            decimal billing = (decimal) ((result == null || result.get('billing') == null) ? 0 : result.get('billing'));
            decimal booking = (decimal) ((result == null || result.get('booking') == null) ? 0 : result.get('booking'));
            decimal backlog = (decimal) ((isMonthly || result == null || result.get('backlog') == null) ? 0 : result.get('backlog'));
            
            billing += (cbcObj.billing.containsKey(dateKey) ? cbcObj.billing.get(dateKey) : 0);
            booking += (cbcObj.booking.containsKey(dateKey) ? cbcObj.booking.get(dateKey) : 0);
            backlog += (cbcObj.backlog.containsKey(dateKey) ? cbcObj.backlog.get(dateKey) : 0);
            cbcObj.billing.put(dateKey, billing);
            cbcObj.booking.put(dateKey, booking);
            cbcObj.backlog.put(dateKey, backlog);
            
            return cbcObj;
        }
        
        public CBCFCValueObj assignHisBacklogRefData(CBCFCValueObj cbcObj, AggregateResult result, String dateKey) {
            
            decimal backlog = (decimal) ((result == null || result.get('backlog') == null) ? 0 : result.get('backlog'));
            
            
            backlog += (decimal) (cbcObj.backlog.containsKey(dateKey) ? cbcObj.backlog.get(dateKey) : 0);
            cbcObj.backlog.put(dateKey, backlog);
            
            return cbcObj;
        }
    }   
    
    public class GPLFCValueObj extends FCValueObj {
        public String prodHichyId {get; set;}
        public String gplCode {get; set;}
        public decimal precent {get; set;}
        public boolean isHighLighted {get; set;}
        public map<String, decimal> billing {get; set;}
        public map<String, decimal> booking {get; set;}
        public map<String, decimal> backlog {get; set;}
        
        public GPLFCValueObj() {
            this.prodHichyId = ''; 
            this.gplCode = '';
            this.precent = 0;
            this.isHighLighted = false;
            this.currentFC = new map<String, decimal>();
            this.previousFC = new map<String, decimal>();
            this.amFC = new map<String, decimal>();
            this.billing = new map<String, decimal>();
            this.booking = new map<String, decimal>();
            this.backlog = new map<String, decimal>();
            this.gamTypeName = 'ClsAPLEntityTypes.GAMPartFCInfo';
            this.rsmTypeName = 'ClsAPLEntityTypes.RSMPartFCInfo';
            this.rsmRelayTypeName = 'ClsAPLEntityTypes.RSMRelayPartFCInfo';
        }
        
        public override Object assignFCValues(FCValueObj superObj, AggregateResult result, String dateKey) {
            
            GPLFCValueObj obj = (GPLFCValueObj) superObj;
            
            decimal fc = (decimal) ((result == null || result.get('fc') == null ) ? 0 : result.get('fc'));
            decimal prevFC = (decimal) ((result == null || result.get('prevFC') == null ) ? 0 : result.get('prevFC'));
            decimal amFC = (decimal) ((result == null || result.get('amFC') == null ) ? 0 : result.get('amFC'));
            
            fc += (obj.currentFC.containsKey(dateKey) ? obj.currentFC.get(dateKey) : 0);
            prevFC += (obj.previousFC.containsKey(dateKey) ? obj.previousFC.get(dateKey) : 0);
            amFC += (obj.amFC.containsKey(dateKey) ? obj.amFC.get(dateKey) : 0);
            obj.currentFC.put(dateKey, fc);
            obj.previousFC.put(dateKey, prevFC);
            obj.amFC.put(dateKey, amFC);
            
            return obj;
        }
        
        public GPLFCValueObj assignRefData(GPLFCValueObj gplObj, AggregateResult result, String dateKey, boolean isMonthly) {
            
            decimal billing = (decimal) ((result == null || result.get('billing') == null) ? 0 : result.get('billing'));
            decimal booking = (decimal) ((result == null || result.get('booking') == null) ? 0 : result.get('booking'));
            decimal backlog = (decimal) ((isMonthly || result == null || result.get('backlog') == null) ? 0 : result.get('backlog'));
            
            billing += (gplObj.billing.containsKey(dateKey) ? gplObj.billing.get(dateKey) : 0);
            booking += (gplObj.booking.containsKey(dateKey) ? gplObj.booking.get(dateKey) : 0);
            backlog += (gplObj.backlog.containsKey(dateKey) ? gplObj.backlog.get(dateKey) : 0);
            gplObj.billing.put(dateKey, billing);
            gplObj.booking.put(dateKey, booking);
            gplObj.backlog.put(dateKey, backlog);
            
            return gplObj;
        }
        
        public GPLFCValueObj assignHisBacklogRefData(GPLFCValueObj gplObj, AggregateResult result, String dateKey) {
            
            decimal backlog = (decimal) ((result == null || result.get('backlog') == null) ? 0 : result.get('backlog'));
            
            
            backlog += (decimal) (gplObj.backlog.containsKey(dateKey) ? gplObj.backlog.get(dateKey) : 0);
            gplObj.backlog.put(dateKey, backlog);
            
            return gplObj;
        }
    }
    
    public class PartFCValueObj extends FCValueObj{
        public String partId {get; set;}
        public String partDesc {get; set;}
        public map<String, decimal> billing {get; set;}
        public map<String, decimal> booking {get; set;}
        public map<String, decimal> backlog {get; set;}
        
        public PartFCValueObj() {
            this.partId = ''; 
            this.partDesc = ''; 
            this.currentFC = new map<String, decimal>();
            this.previousFC = new map<String, decimal>();
            this.amFC = new map<String, decimal>();
            this.billing = new map<String, decimal>();
            this.booking = new map<String, decimal>();
            this.backlog = new map<String, decimal>();
        }
        
        public override Object assignFCValues(FCValueObj superObj, AggregateResult result, String dateKey) {
            
            PartFCValueObj obj = (PartFCValueObj) superObj;
            
            decimal fc = (decimal) ((result == null || result.get('fc') == null ) ? 0 : result.get('fc'));
            decimal prevFC = (decimal) ((result == null || result.get('prevFC') == null ) ? 0 : result.get('prevFC'));
            decimal amFC = (decimal) ((result == null || result.get('amFC') == null ) ? 0 : result.get('amFC'));
            String partDesc = (String) ((result == null || result.get('partDesc') == null ) ? '' : result.get('partDesc'));
            obj.partDesc = (obj.partDesc == '' ? partDesc : obj.partDesc);
            obj.currentFC.put(dateKey, fc);
            obj.previousFC.put(dateKey, prevFC);
            obj.amFC.put(dateKey, amFC);
            
            return obj;
        }
        
        public PartFCValueObj assignRefData(PartFCValueObj partObj, AggregateResult result, String dateKey, boolean isMonthly) {
            
            decimal billing = (decimal) ((result == null || result.get('billing') == null) ? 0 : result.get('billing'));
            decimal booking = (decimal) ((result == null || result.get('booking') == null) ? 0 : result.get('booking'));
            decimal backlog = (decimal) ((isMonthly || result == null || result.get('backlog') == null) ? 0 : result.get('backlog'));
            
            billing += (partObj.billing.containsKey(dateKey) ? partObj.billing.get(dateKey) : 0);
            booking += (partObj.booking.containsKey(dateKey) ? partObj.booking.get(dateKey) : 0);
            backlog += (partObj.backlog.containsKey(dateKey) ? partObj.backlog.get(dateKey) : 0);
            partObj.billing.put(dateKey, billing);
            partObj.booking.put(dateKey, booking);
            partObj.backlog.put(dateKey, backlog);
            
            return partObj;
        }
        
        public PartFCValueObj assignHisBacklogRefData(PartFCValueObj partObj, AggregateResult result, String dateKey) {
            
            decimal backlog = (decimal) ((result == null || result.get('backlog') == null) ? 0 : result.get('backlog'));
            
            
            backlog += (decimal) (partObj.backlog.containsKey(dateKey) ? partObj.backlog.get(dateKey) : 0);
            partObj.backlog.put(dateKey, backlog);
            
            return partObj;
        }
    }
        
    public abstract class FCValueObj{
        public String fieldName {get; set;}
        public String cls {get; set;}
        public String currencyIso {get; set;}
        public map<String, decimal> currentFC {get; set;}
        public map<String, decimal> previousFC {get; set;}
        public map<String, decimal> amFC {get; set;}
        public String gamTypeName {get; set;}
        public String rsmTypeName {get; set;}
        public String rsmRelayTypeName {get; set;}
        
        public abstract Object assignFCValues(FCValueObj obj, AggregateResult result, String dateKey);
    }

    public class Cbc2Object{
        public String name{get;set;}
        public String code {get;set;}
        public String fieldName {get;set;}
        public String clsName {get;set;}
        public Cbc2Object(String name, String code, String fieldName, String clsName){
            this.name = name;
            this.code = code;
            this.fieldName = fieldName;
            this.clsName = clsName;
        }
        
    }
    
    public class RelayPartObject{
    	public String name{get;set;}
    	public String gplId{get;set;}
    }
    
    public class RelayPartFCValueObj{
        public String partId {get; set;}
        public String fieldName {get; set;}
        public String gplId {get; set;}
        public boolean isHighLighted {get; set;}
        public decimal price {get; set;}
        public map<String, String> currentFC {get; set;} 
        public map<String, String> previousFC {get; set;}
        public map<String, decimal> billing {get; set;}
        public map<String, decimal> booking {get; set;}
        public map<String, decimal> backlog {get; set;}
        public map<String, decimal> amFC {get; set;}
        public RelayPartFCValueObj() {
            this.partId = ''; 
            this.gplId = '';
            this.fieldName = '';
            this.price = 0;
            this.currentFC = new map<String, String>();
            this.previousFC = new map<String, String>();
            this.isHighLighted = false;
            this.amFC = new map<String, decimal>();
            this.billing = new map<String, decimal>();
            this.booking = new map<String, decimal>();
            this.backlog = new map<String, decimal>();
        } 
        
        public Object assignFCPartRelayValues(RelayPartFCValueObj superObj, AggregateResult result, String dateKey, String pricePlaces) {
            
            RelayPartFCValueObj obj = (RelayPartFCValueObj) superObj;
            
            RelayFCObj relayFCObj = new RelayFCObj();
            relayFCObj.price = (decimal) ((result == null || result.get('price') == null) ? 0 : result.get('price'));
            relayFCObj.price = relayFCObj.price.setScale((pricePlaces == '' ? 3 : Integer.valueOf(pricePlaces)));
            relayFCObj.quantity = (decimal) ((result == null || result.get('quantity') == null) ? 0 : result.get('quantity')); 
              
            RelayFCObj preRelayFCObj = new RelayFCObj();
            preRelayFCObj.price = (decimal) ((result == null || result.get('prePrice') == null) ? 0 : result.get('prePrice'));
            preRelayFCObj.price = preRelayFCObj.price.setScale((pricePlaces == '' ? 3 : Integer.valueOf(pricePlaces)));
            preRelayFCObj.quantity = (decimal) ((result == null || result.get('preQuantity') == null) ? 0 : result.get('preQuantity'));   
            
            decimal amFC = (decimal) ((result == null || result.get('amFC') == null ) ? 0 : result.get('amFC'));
			amFC += (obj.amFC.containsKey(dateKey) ? obj.amFC.get(dateKey) : 0);
			
            obj.currentFC.put(dateKey, JSON.serialize(relayFCObj));
            obj.previousFC.put(dateKey, JSON.serialize(preRelayFCObj));
            obj.amFC.put(dateKey, amFC);
            
            return obj;
        }
        
        public RelayPartFCValueObj assignRefData(RelayPartFCValueObj partObj, AggregateResult result, String dateKey, boolean isMonthly) {
            
            decimal billing = (decimal) ((result == null || result.get('billing') == null) ? 0 : result.get('billing'));
            decimal booking = (decimal) ((result == null || result.get('booking') == null) ? 0 : result.get('booking'));
            decimal backlog = (decimal) ((isMonthly || result == null || result.get('backlog') == null) ? 0 : result.get('backlog'));
            /*
            billing = currencyRate * billing; 
            booking = currencyRate * booking; 
            backlog = currencyRate * backlog; 
            */
            billing += (partObj.billing.containsKey(dateKey) ? partObj.billing.get(dateKey) : 0);
            booking += (partObj.booking.containsKey(dateKey) ? partObj.booking.get(dateKey) : 0);
            backlog += (partObj.backlog.containsKey(dateKey) ? partObj.backlog.get(dateKey) : 0);
            
            partObj.billing.put(dateKey, billing);
            partObj.booking.put(dateKey, booking);
            partObj.backlog.put(dateKey, backlog);
            
            return partObj;
        }
        
        public RelayPartFCValueObj assignHisBacklogRefData(RelayPartFCValueObj partObj, AggregateResult result, String dateKey) {
            
            decimal backlog = (decimal) ((result == null || result.get('backlog') == null) ? 0 : result.get('backlog'));
                       
            backlog += (decimal) (partObj.backlog.containsKey(dateKey) ? partObj.backlog.get(dateKey) : 0);
            partObj.backlog.put(dateKey, backlog);
            
            return partObj;
        }
        

    }
    public class RelayFCObj {
        public decimal price {get; set;}
        public decimal quantity {get; set;}
        public RelayFCObj() {
            this.price = 0;
            this.quantity = 0;
        }
    }
    
    public class TotalFCViewFields {
		public map<String, decimal> map_currentFC {get; set;}
		public String fieldName {get; set;}
		public String clsName {get;set;}
		public String currentFC {get; set;}
		public String disName {get; set;}
		public String name {get; set;}
		public list<AcctColumns> list_referenceRows {get; set;}
		
		public TotalFCViewFields() {
			this.map_currentFC = new map<String, decimal>();
			this.fieldName = '';
			this.clsName = '';
			this.currentFC = '';
			this.disName = '';
			this.name = '';
			this.list_referenceRows = new list<AcctColumns>();
		}
		
		public TotalFCViewFields(String clsName) {
			this.map_currentFC = new map<String, decimal>();
			this.fieldName = '';
			this.clsName = clsName;
			this.currentFC = '';
			this.list_referenceRows = new list<AcctColumns>();
		}
		
        public TotalFCViewFields assignFCValues(TotalFCViewFields superObj, AggregateResult result, String dateKey) {
            TotalFCViewFields obj = (TotalFCViewFields) superObj;
            decimal fc = (decimal) ((result == null || result.get('fc') == null ) ? 0 : result.get('fc'));
            obj.map_currentFC.put(dateKey, fc);
            return obj;
        }
	}
	
	public class OverRallFCObj {
		public map<String, decimal> map_dateKey_fc {get; set;}
		public String disName {get;set;}
		public String name {get; set;}
		public String fieldName {get; set;}
		public String clsName = '';
		
		public OverRallFCObj() {
			this.map_dateKey_fc = new map<String, decimal>();
			this.disName = '';
			this.fieldName = '';
			this.clsName = '';
			this.name = '';
		}
		
        public OverRallFCObj assignFCValues(OverRallFCObj obj, AggregateResult result, String dateKey) {
        	
            decimal fc = (decimal) ((result == null || result.get('fc') == null ) ? 0 : result.get('fc'));
            fc += (obj.map_dateKey_fc.containsKey(dateKey) ? obj.map_dateKey_fc.get(dateKey) : 0);
            obj.map_dateKey_fc.put(dateKey, fc);
            return obj;
        }
	}
    ///*<<<InnerClass*/
    //********************************* -=END inner classes=- *************************************
}