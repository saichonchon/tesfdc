/**
 * Controller class for page APL_CtrlcalcAPLNextQuarterForecast
 *
 @author    Lei Tang
 @created   2016-07-05
 @version   1.0
 @since     35.0 (Force.com ApiVersion)
 *
 @changelog
 * 2016-07-05 Lei Tang <Lei Tang@oinio.com>
 * - Created
 */
public without sharing class APL_CtrlcalcAPLNextQuarterForecast {

	public APL_CtrlcalcAPLNextQuarterForecast() {
		
	}
	
	
	public void executeCalcAPLNextQuarterForecastBatch(){

		//try {
			ClsBatch_calcAPLNextQuarterForecast cls = new ClsBatch_calcAPLNextQuarterForecast();
            Id batchId = database.executeBatch(cls);
		//}catch(Exception ex) {
			
		//}

	}
	
	
	
   
}