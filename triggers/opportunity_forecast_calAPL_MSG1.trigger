/**************************************************************************************************************************************************
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
Version     Developer                   Date             Detail                                               Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
  1.0    Nelson Zheng                 10/16/2015        Created
**************************************************************************************************************************************************/
trigger opportunity_forecast_calAPL_MSG1 on Opportunity_Forecast__c (before insert,before update) {
    
    for(Opportunity_Forecast__c forecast : trigger.new){
        Decimal tmpAmount = forecast.CurrencyIsoCode != 'USD'? ClsOppyForecastUtil.transformIsoCode(forecast.Amount__c, forecast.CurrencyIsoCode, 'USD'):forecast.Amount__c;
        if(forecast.is_APL_relay__c){
            forecast.msg1__c = 0;
        }else{
            if(forecast.NPS1__c != null){
                forecast.msg1__c = tmpAmount - forecast.NPS1__c;
            }else{
                forecast.msg1__c = tmpAmount;
            }
        }
    }
}