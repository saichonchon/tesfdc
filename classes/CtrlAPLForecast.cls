/**
 *  Controll class for page CtrlAcctGrouping
 *
 @author    Jason Zang
 @created   2017-11-15
 @version   1.0
 @since     39.0 (Force.com ApiVersion)
 *
 @changelog
 * 2017-11-15 Jason Zang <jason.zang@capgemini.com>
 * - Created
 */
public class CtrlAPLForecast {
    public boolean isAMAdditional {get;set;}
    public CtrlAPLForecast() {
        
        //try{
            map<string, APL_Forecast_Management__c> forecastMgrMap = new map<string, APL_Forecast_Management__c>();
            for(APL_Forecast_Management__c forecastManager : [Select Id, A6_Code__c, Manager__c, AM_Freeze__c, RecordType.DeveloperName
                                                              From APL_Forecast_Management__c
                                                              Where Manager__c = : UserInfo.getUserId() 
                                                              And A6_Code__c != null
                                                              And RecordTypeId != null]) {
                forecastMgrMap.put(forecastManager.RecordType.DeveloperName, forecastManager); 
            }
            if (forecastMgrMap.containsKey('AM')) {
                isAMAdditional = true;
            } else {
                isAMAdditional = false;
            }
                    
       /* } catch(Exception e){
            isAMAdditional = false;
            throw e;
        }*/
    }

}