/**
 *  Virtual controll class for CtrlAcctGrouping, CtrlGroupingAMForecast class
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
public with sharing class ClsAPLForecastObjects {
    
    
    public static IObject newClassInstance(String className){
        try{
            Type t = Type.forName(className);
            return (IObject) t.newInstance();
        }catch(Exception e){
            throw e;
        }
    }
    
    public interface IObject {
        void saveFC(String str_json, list<APL_Sales_Forecast__c> list_fc);
    }
    
    public virtual class ForecastSaveBaseObj {
        public String className {get; set;}
        public String str_json {get;set;}
        
    }
    public virtual class FCBaseObj {
        public String parentId {get; set;}
        public String territoryCode {get; set;}
        public boolean isRelay {get; set;}
        public String quarterNumb {get; set;}
        public String currencyIso {get; set;}
        public map<String, decimal> map_dateKey_fc {get; set;}
        public String json_setAcctIds {get; set;}
        public map<String, set<String>> map_year_quartersFuture {get; set;}
        public map<String, String> map_acctId_currencyIso {get; set;}
    }
    
    public class AccountObject extends FCBaseObj implements IObject{
        
        public void saveFC(String str_json, list<APL_Sales_Forecast__c> list_fc){
            AccountObject ao = (AccountObject) json.deserialize(str_json, AccountObject.class);
            ClsGroupingAMForecastUtil.saveAcctFC(ao);
        }
        
    }
    
    public class CbcObject extends FCBaseObj implements IObject{
        
        public String cbc2Code {get;set;}
        public map<String, decimal> map_dateKey_fc {get; set;}
        
        public void saveFC(String str_json, list<APL_Sales_Forecast__c> list_fc){
            CbcObject ao = (CbcObject)json.deserialize(str_json, CbcObject.class);
            
            
        }
    }
    
    public class GplObject extends FCBaseObj implements IObject{
        public String cbc2Code {get; set;}
        public String gplId {get;set;}
        public list<PartObject> list_partFC {get; set;}
        public void saveFC(String str_json, list<APL_Sales_Forecast__c> list_fc){
            GplObject go = (GplObject)json.deserialize(str_json, GplObject.class);
            ClsGroupingAMForecastUtil.saveGPLAndPartFC(go);
        }
    }
    public class OtherCBCObject extends FCBaseObj implements IObject{
        public list<PartObject> list_partFC {get; set;}
        public void saveFC(String str_json, list<APL_Sales_Forecast__c> list_fc){
            OtherCBCObject ao = (OtherCBCObject)json.deserialize(str_json, OtherCBCObject.class);
            ClsGroupingAMForecastUtil.saveOtherCBCPartFC(ao);
            
        }
    }
    
    
     public class PartObject extends FCBaseObj implements IObject {
         public String gplId {get; set;}
        public String partId {get;set;}
        public void saveFC(String str_json, list<APL_Sales_Forecast__c> list_fc){
            PartObject ao = (PartObject)json.deserialize(str_json, PartObject.class);
            
        }
    }
}