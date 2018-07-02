/**
 *  Schedule class to Freeze/Unfreeze APL Sales forecast 
 *
 @author    Bin Yuan
 @created   2014-08-07
 @version   1.0
 @since     30.0 (Force.com ApiVersion)
 *
 @changelog
 * 2014-08-07 Bin Yuan <bin.yuan@itbconsult.com>
 * - Created
 */
global class ClsSchedule_aplFCFreeze implements Schedulable {
    global void execute(SchedulableContext sc) {
        Integer dayCount = system.today().toStartOfMonth().daysBetween(system.today()) + 1;
        
        Integer amUnfreezeDay = 15, 
                gamUnfreezeDay = 19, 
                rsmUnfreezeDay = 22, 
                rsmRelayUnfreezeDay = 26, 
                allUnfreezeDay = 28,
                calcPrevDay = 8;
        boolean isAMFreeze = false, 
                isGAMFreeze = false, 
                isRSMFreeze = false,
                isRSMRelayFreeze = false,
                isCalcPrevDay = false;
        
        if(APL_Forecast_Settings__c.getInstance('AM Unfreeze Setting') != null
            && APL_Forecast_Settings__c.getInstance('AM Unfreeze Setting').Value__c != null) {
            
            amUnfreezeDay = Integer.valueOf(APL_Forecast_Settings__c.getInstance('AM Unfreeze Setting').Value__c);
        } 
        if(APL_Forecast_Settings__c.getInstance('GAM Unfreeze Setting') != null
            && APL_Forecast_Settings__c.getInstance('GAM Unfreeze Setting').Value__c != null) {
                
            gamUnfreezeDay = Integer.valueOf(APL_Forecast_Settings__c.getInstance('GAM Unfreeze Setting').Value__c);
        } 
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
                
            allUnfreezeDay = Integer.valueOf(APL_Forecast_Settings__c.getInstance('Freeze All').Value__c);
        } 
        if(APL_Forecast_Settings__c.getInstance('Calc Previous FC') != null
            && APL_Forecast_Settings__c.getInstance('Calc Previous FC').Value__c != null) {
                
            calcPrevDay = Integer.valueOf(APL_Forecast_Settings__c.getInstance('Calc Previous FC').Value__c);
        } 
        
        isAMFreeze = (dayCount == amUnfreezeDay ? false : true);
        isGAMFreeze = (dayCount == gamUnfreezeDay ? false : true);
        isRSMFreeze = (dayCount == rsmUnfreezeDay ? false : true);
        isRSMRelayFreeze = (dayCount == rsmRelayUnfreezeDay ? false : true);
        isCalcPrevDay = (dayCount != calcPrevDay ? false : true);

        if(dayCount == allUnfreezeDay) {
            isAMFreeze = true;
            isGAMFreeze = true;
            isRSMFreeze = true;
            isRSMRelayFreeze = true;
        }
        system.debug('dayCount :: ' + dayCount);
        system.debug('amUnfreezeDay :: ' + amUnfreezeDay);
        system.debug('gamUnfreezeDay :: ' + gamUnfreezeDay);
        system.debug('rsmUnfreezeDay :: ' + rsmUnfreezeDay);
        system.debug('rsmRelayUnfreezeDay :: ' + rsmRelayUnfreezeDay);
        system.debug('allUnfreezeDay :: ' + allUnfreezeDay);
        system.debug('isAMFreeze :: ' + isAMFreeze);
        system.debug('isGAMFreeze :: ' + isGAMFreeze);
        system.debug('isRSMFreeze :: ' + isRSMFreeze);
        system.debug('isRSMRelayFreeze :: ' + isRSMRelayFreeze);
        if(dayCount == amUnfreezeDay || dayCount == gamUnfreezeDay || dayCount == rsmUnfreezeDay
            || dayCount == rsmRelayUnfreezeDay || dayCount == allUnfreezeDay) {
        
            ClsBatch_aplSalesForecastFrozen cls = new ClsBatch_aplSalesForecastFrozen();
            cls.isFreezeAM = isAMFreeze;
            cls.isFreezeGAM = isGAMFreeze;
            cls.isFreezeRSM = isRSMFreeze;
            cls.isFreezeRSMRelay = isRSMRelayFreeze;
            Id batchId = database.executeBatch(cls);
        }
        if(isCalcPrevDay) {
            ClsBatch_calcAPLPreviousForecast cls = new ClsBatch_calcAPLPreviousForecast();
            Id batchId = database.executeBatch(cls);
        }
    }
}