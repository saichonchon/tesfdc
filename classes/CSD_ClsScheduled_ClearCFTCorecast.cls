/**
 *  This class is used to schedule batch job CSD_ClsBatch_clearCFTForecast
 *  
 * @author Lei Tang
 * @created 2015-01-28
 * @version 1.0
 * @since 30.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2015-01-28 Lei Tang <lei.tang@itbconsult.com>
 * - Created   
 */
global class CSD_ClsScheduled_ClearCFTCorecast implements Schedulable{
	global void execute(SchedulableContext sc) {
    	
		CSD_ClsBatch_clearCFTForecast cls= new CSD_ClsBatch_clearCFTForecast();
		ID batchprocessid = Database.executeBatch(cls);
		
	}
}