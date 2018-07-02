/**
 *  Entity class for Controller components
 *
 @author    Lei Tang
 @created   2015-05-07
 @version   1.0
 @since     33.0 (Force.com ApiVersion)
 *
 @changelog
 * 2015-05-07 Lei Tang <lei.tang@itbconsult.com>
 * - Created
 */
public without sharing class APL_ClsEntityType {
      
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
    
    public virtual class BaseObj {
        public String id {get; set;}
        public String name {get;set;}
        public String accnumber {get;set;}
        public String region {get;set;}
        public String type {get;set;}
        public String managerId {get;set;}
    }
    
    
    public class AccountValueobj {
        public decimal forecast {get; set;}
        public decimal price {get; set;}
        public decimal quantity {get; set;}
        public decimal restPNFC {get; set;}
    }
    
    public class OEMAccountObj extends BaseObj implements Comparable {
        public String snumber {get;set;}
        public String oemId {get;set;}
        public String gplcode {get;set;}
        public String gplfamily {get;set;}
        public String eolcomment {get;set;}
        public String rank {get;set;}
        public String accmanager {get;set;}
        public map<String, decimal> csFC {get; set;}
        public map<String, decimal> restPNFC {get; set;}
        public map<String, decimal> dcFC {get; set;}
        public map<String, decimal> pmFC {get; set;}
        public String json_csFC {get; set;}
        public String json_dcFC {get; set;}
        public String json_pmFC {get; set;}
        
        public Integer compareTo(Object compareTo) {
            OEMAccountObj compareToAcct = (OEMAccountObj) compareTo;

            /*if(this.rank == '' && compareToAcct.rank != '') {
                return 1;
            }
            
            if(this.rank != '' && compareToAcct.rank == '') {
                return -1;
            }*/
            Integer thisrank = 100;
            Integer comprank = 100;
            if(this.rank != '') {
                if(this.rank == 'N/A') {
                    thisrank = 99;
                }else {
                    thisrank = Integer.valueOf(this.rank);
                }
            }
            if(compareToAcct.rank != '') {
                if(compareToAcct.rank == 'N/A') {
                    comprank = 99;
                }else {
                    comprank = Integer.valueOf(compareToAcct.rank);
                }
            }

            if (thisrank == comprank && this.name == compareToAcct.name) {
                return 0;
            }
            if(thisrank == comprank && this.name < compareToAcct.name) {
                return -1;
            }
            if(thisrank < comprank) {
                return -1;
            }
            return 1;        
        }
    }
    
    public class AccountObj extends BaseObj implements Comparable {
        public String snumber {get;set;}
        public String oemId {get;set;}
        public String gplcode {get;set;}
        public String gplfamily {get;set;}
        public String eolcomment {get;set;}
        public String rank {get;set;}
        public String accmanager {get;set;}
        public map<String, decimal> csFC {get; set;}
        public map<String, decimal> restPNFC {get; set;}
        public map<String, decimal> dcFC {get; set;}
        public map<String, decimal> pmFC {get; set;}
        public String json_csFC {get; set;}
        public String json_dcFC {get; set;}
        public String json_pmFC {get; set;}
        
        public Integer compareTo(Object compareTo) {
            AccountObj compareToAcct = (AccountObj) compareTo;
            //if (this.name == 'NON OEM') return -1;
            if (this.name == compareToAcct.name) return 0;
            if (this.name < compareToAcct.name) return -1;
            return 1;        
        }
    }
    
    
    public class RSMAccountObj extends BaseObj implements Comparable {
        public String snumber {get;set;}
        public decimal price {get;set;}
        public boolean isHighLighted {get; set;}
        public map<String, map<String, decimal>> map_type_FC {get; set;}
        public String json_FCData {get; set;}

        public Integer compareTo(Object compareTo) {
            RSMAccountObj compareToAcct = (RSMAccountObj) compareTo;
            //if (this.name == 'NON OEM') return -1;
            if (this.name == compareToAcct.name) return 0;
            if (this.name < compareToAcct.name) return -1;
            return 1;        
        }
    }
     
    public class RSMPartObj extends BaseObj implements Comparable {
        public String snumber {get;set;}
        public decimal price {get;set;}
        public boolean isHighLighted {get; set;}
        public decimal precent {get; set;}
        public map<String, map<String, decimal>> map_type_FC {get; set;}
        public String json_FCData {get; set;}
		
		
        public Integer compareTo(Object compareTo) {
            RSMPartObj compareToAcct = (RSMPartObj) compareTo;
            //if (this.name == 'NON OEM') return -1;
            if (this.precent == compareToAcct.precent) return 0;
            if (this.precent > compareToAcct.precent) return -1;
            return 1;        
        }
    }
    
    
    public class AccountObjForComparison extends BaseObj implements Comparable{
        
        public map<String, decimal> csFC {get; set;}
        public map<String, decimal> dcFC {get; set;}
        public map<String, decimal> pmFC {get; set;}
        public String json_csFC {get; set;}
        public String json_dcFC {get; set;}
        public String json_pmFC {get; set;}
        public decimal csFCamount{get; set;}
        
        public Integer compareTo(Object compareTo) {
            AccountObjForComparison compareToAcct = (AccountObjForComparison) compareTo;
            if (this.csFCamount == compareToAcct.csFCamount) return 0;
            if (this.csFCamount > compareToAcct.csFCamount) return -1;
            return 1;
        }
    }
    
    
    
    public class PartObj extends BaseObj  implements Comparable{
        public String snumber {get;set;}
        public String gplcode {get;set;}
        public String gplfamily {get;set;}
        public map<String, AccountValueobj> csFC {get; set;}
        public map<String, decimal> dcFC {get; set;}
        public map<String, decimal> pmFC {get; set;}
        public Boolean hasCFTFC {get; set;}
        
        public Integer compareTo(Object compareTo) {
            PartObj compareToAcct = (PartObj) compareTo;
            if (this.name == compareToAcct.name) return 0;
            if (this.name > compareToAcct.name) return -1;
            return 1;        
        }
    }
    
    public class ComparisonObj extends BaseObj implements Comparable{
        
        public map<String, decimal> csFCmonth {get; set;}
        public map<String, decimal> dcFCmonth {get; set;}
        
        public decimal csFCamount{get; set;}
        
        public Integer compareTo(Object compareTo) {
            ComparisonObj compareToAcct = (ComparisonObj) compareTo;
            if (this.csFCamount == compareToAcct.csFCamount) return 0;
            if (this.csFCamount < compareToAcct.csFCamount) return -1;
            return 1;
        }
    }
    
    
    public class APLForecastValueObj {
    	public String grouping {get; set;}
    	public String cbc2Code {get; set;}
    	public String productcode {get; set;}
    	public String productname {get; set;}
        public String accnumber {get; set;}
        public String partId {get; set;}
        public String gplId {get; set;}
        public String territoryCode {get;set;}
        public String managerId {get;set;}
        public decimal price {get;set;}
        public String currencyIso {get;set;}
        public map<String, set<String>> map_year_quartersFuture {get; set;}
        public map<String, decimal> map_datekey_csFC {get; set;}
        
        
    }
    
    
    public class APLReferenceData {
        public decimal billing {get; set;}
        public decimal booking {get; set;}
        public decimal backlog {get; set;}
    }
    
    
    public class APLRefObj extends BaseObj {
        
        public map<String, decimal> map_backlogrefdata {get; set;}
        public map<String, decimal> map_billingrefdata {get; set;}
        public map<String, decimal> map_bookingrefdata {get; set;}
        public map<String, decimal> map_statisticalrefdata {get; set;}
    }
    
    public class APLRelayRefObj extends BaseObj {
        
        public map<String, decimal> map_backlogrefdata {get; set;}
        public map<String, decimal> map_backlogrefdataQty {get; set;}
        public map<String, decimal> map_billingrefdata {get; set;}
        public map<String, decimal> map_billingrefdataQty {get; set;}
        public map<String, decimal> map_bookingrefdata {get; set;}
        public map<String, decimal> map_bookingrefdataQty {get; set;}
        //public map<String, decimal> map_statisticalrefdata {get; set;}
    }
    
    
    
    public class UserObj {
        public String key {get;set;}    //ID
        public String title {get;set;}  //Name;
        public Boolean lazy {get;set;}  //Is lazy set default true
        public String photoUrl {get;set;}   //the user smail photo img
        public String id {get; set;}
        public String name {get; set;}
        public String rsmType {get; set;}
        public Boolean isSamsung {get;set;}
        public String password {get;set;}  //link password
        public String url {get;set;}
        public list<UserObj> list_users {get;set;}
        public map<String, APL_ClsEntityType.RSMType> map_rsmType {get; set;}
        
        public UserObj(){
            
        }
        public UserObj(String key, list<UserObj> list_users){
            this.key = key;
            this.list_users = list_users;
        }

        
    }
    
    
    public class CFTDataObj {
        public String dateKey {get;set;}    
        public decimal quantity {get;set;}
        public Boolean hasvalue {get;set;}
    }
    
    
    
    /**
     *  Inner class for APLColumn
     *
     @author    Lei Tang
     @created   2014-05-30
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-05-30 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     */
    public class APLColumn {
        public String name {get;set;}
        public String fieldName {get;set;}
        public String cls {get;set;}
        public String matchName {get; set;}
        public Boolean isInput {get; set;}
        public list<APLColumn> list_ChildColumn {get;set;}
        public String id {get;set;}
        public String json_ForecastData {get;set;}
        
        
        public APLColumn() {}
        
        public APLColumn(String name, String fieldName, String cls, String matchName, boolean isInput) {
            this.name = name;
            this.fieldName = fieldName;
            this.cls = cls;
            this.matchName = matchName;
            this.isInput = isInput;
            this.list_ChildColumn = new list<APLColumn>();
            this.json_ForecastData = '';
        }
        
        public APLColumn(String Id, String name, String fieldName, String cls, String matchName, boolean isInput) {
        	this.id = Id;
            this.name = name;
            this.fieldName = fieldName;
            this.cls = cls;
            this.matchName = matchName;
            this.isInput = isInput;
            this.list_ChildColumn = new list<APLColumn>();
            this.json_ForecastData = '';
        }
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
        public String cls {get; set;}
        public String total {get; set;}
        public String type {get; set;}
        public String type1 {get; set;}
        public String type2 {get; set;}
        public String type3 {get; set;}
        public Boolean isInput {get; set;}
        public String fYear {get; set;}
        public Integer fMonth {get; set;}
        public Decimal workingDays {get; set;}
        public String qtotalCls {get; set;}
        public String monthCls {get; set;}
        public String qLabel {get; set;}
        public String mLabel {get; set;}
        public String qMonths {get; set;}
        public Boolean isFutrue {get; set;}
        
        public DateItem(String name) {
            itemName = name;
            this.cls = '';
            this.total = '';
            this.type = '';
            this.type1 = '';
            this.type2 = '';
            this.type3 = '';
            this.isInput = false;
            this.fYear = '';
            this.fMonth = 0;
            this.workingDays = 0;   
            this.qtotalCls = ''; 
            this.monthCls = ''; 
            this.qLabel = '';
            this.mLabel = '';
            this.qMonths = '';
            this.isFutrue = false;
        }
    }
    
    
    
    /**
     *  Inner class for PageConfig
     *
     @author    Lei Tang
     @created   2014-05-30
     @version   1.0
     @since     29.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-05-30 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     */
    public class PageConfig {
        public boolean isSetupDone {get; set;}
        public map<String, set<Integer>> map_financialMonth {get; set;}
        public map<String, Decimal> map_workingDays {get; set;}
        public String str_financialMonthMap {get; set;}
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
        public boolean isStop {get; set;}
        public boolean isRender {get; set;}
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
        public String samsungId {get; set;}
        public String viewMode {get; set;}
        public map<String, String> map_quarter_months {get; set;}
        public String json_map_quarter_months {get; set;}
        public set<String> set_regions {get; set;}
        public String territoryCode {get; set;}
        
        public PageConfig() {
            this.isSetupDone = false;
            this.managerId = '';
            this.currentMonthIndex = 0;
            str_financialMonthMap = '';
            this.str_futureQuarterMap = '';
            this.map_financialMonth = new map<String, set<Integer>>();
            this.currentYear = '';
            this.currentMonth = 0;
            this.isRelay = false;
            this.isStop = false;
            this.isRender = true;
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
            this.samsungId = '';
            this.viewMode = '';
            this.map_quarter_months = new map<String, String>();
            this.json_map_quarter_months = '';
            this.set_regions = new set<String>();
            this.territoryCode = '';
        }
    }
    
    /**
     *  Inner class for LocaleConfig
     *
     @author    Lei Tang
     @created   2014-09-25
     @version   1.0
     @since     30.0 (Force.com ApiVersion)
     *
     @changelog
     * 2014-09-25 Lei Tang <lei.tang@itbconsult.com>
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
     *  Inner class for search object
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
    public virtual class SearchObj {
        public String searchKey {get; set;}
        public String soldtoId {get; set;}
        public String accnumber {get; set;}
        public String oemId {get; set;}
        public String partId {get; set;}
        public String region {get; set;}
        public String gplfamily {get; set;}
        public String gplId {get; set;}
        public String rsmgrouping {get; set;}
        public String grouping {get; set;}
        public String cbc2Code {get; set;}
        public String relayCode {get; set;}
        public String territoryCode {get; set;}
        public set<String> set_selectedId {get; set;}
        public map<String, set<Integer>> map_year_monthsFuture {get; set;}
        public map<String, set<String>> map_year_quartersFuture {get; set;}
        public String startDate {get; set;}
        public String endDate {get; set;}
        public Boolean isOtherMethod {get; set;}
        public set<String> set_fiscalMonth {get; set;}
        public Boolean isExpansionSoldto {get; set;}
        public Boolean hasGPLCode {get; set;}
        public String viewMode {get; set;}
        public String userId {get; set;}
        public String managerId {get; set;}
        public String type {get;set;}
        public String currencyIso {get;set;}
        public set<String> set_deletedId {get; set;}
        public map<String, String> map_quarter_months {get; set;}
        public map<String, String> map_acctId_currencyIso {get; set;}
        public set<String> set_gamCodes {get; set;}
    }
     
    public class SearchObjExpand extends SearchObj {
        
        public set<String> set_selectedPartIds {get; set;}
        public set<String> set_deletedPartIds {get; set;}
        public set<String> set_selectdsoldtonumbers {get; set;}
        public set<String> set_deletedsoldtonumbers {get; set;}
        public set<String> set_deletedgplcodes {get; set;}
            
    }
    
    
    public class RSMParentAcctObj implements Comparable {
    	public String acctId {get; set;}
    	public String name {get; set;}
    	public String accnumber {get; set;}
    	public boolean expanded {get; set;}
    	public boolean folder {get; set;}
    	public String parentId {get; set;}
    	public String displayName {get; set;}
    	public String level {get; set;}
    	public String olddisName {get; set;}
    	public String territoryName {get; set;}
    	public list<RSMParentAcctObj> list_childAccts {get; set;}
    	
    	public RSMParentAcctObj() {
    		this.acctId = '';
    		this.name = '';
    		this.accnumber = '';
    		this.expanded = false;
    		this.folder = true;
    		this.displayName = '';
    		this.level = '';
    		this.parentId = '';
    		this.olddisName = '';
    		this.territoryName = '';
    		this.list_childAccts = new list<RSMParentAcctObj>();
    	}
    	
    	public RSMParentAcctObj(String acctId, String name, String accnumber, String displayName, String parentId, String level, String olddisplayName) {
			this.acctId = acctId;
    		this.name = name;
    		this.accnumber = accnumber;
    		this.expanded = false;
    		this.folder = true;
    		this.displayName = (displayName == null ? '' : displayName);
    		this.level = level;
    		this.parentId = parentId;
    		this.olddisName = (olddisplayName == null ? '' : olddisplayName);
    		this.territoryName = '';
    		this.list_childAccts = new list<RSMParentAcctObj>();
    	}
    	
    	public RSMParentAcctObj(String acctId, String name, String accnumber, String displayName, String parentId, String level, String olddisplayName, String terrcode) {
			this.acctId = acctId;
    		this.name = name;
    		this.accnumber = accnumber;
    		this.expanded = false;
    		this.folder = true;
    		this.displayName = (displayName == null ? '' : displayName);
    		this.level = level;
    		this.parentId = parentId;
    		this.olddisName = (olddisplayName == null ? '' : olddisplayName);
    		this.territoryName = terrcode;
    		this.list_childAccts = new list<RSMParentAcctObj>();
    	}
    	
    	
        public Integer compareTo(Object compareTo) {
            RSMParentAcctObj compareToAcct = (RSMParentAcctObj) compareTo;
            if (this.accnumber == compareToAcct.accnumber) return 0;
            if (this.accnumber > compareToAcct.accnumber) return 1;
            return -1;        
        }
    
    }
	
	
	public class RSMType {
		public map<String, String> map_level_name {get; set;}
		
		public RSMType() {
			this.map_level_name = new map<String, String>();
		}
	}
	
	public class RSMRelayOverRallInfo {
        public String managerId {get; set;}
        public map<String, map<String, decimal>> map_name_map_dateKey_fc {get; set;}
        public set<String> set_displayNames {get; set;}  
        public set<String> set_rsmIds {get; set;}  
        public map<String, set<String>> map_year_quartersFuture {get; set;}  
	}
}