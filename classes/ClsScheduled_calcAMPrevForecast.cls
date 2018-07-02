/**
 *  This class is used to schedule batch job ClsBatch_recalculateAccountForecast
 *  
 * @author Bin Yuan
 * @created 2014-03-03
 * @version 1.0
 * @since 28.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2014-03-03 Bin Yuan <bin.yuan@itbconsult.com>
 * - Created   
 *
 */

global class ClsScheduled_calcAMPrevForecast implements Schedulable{
	global void execute(SchedulableContext sc) {
		ClsBatch_recalculateAccountForecast cls= new ClsBatch_recalculateAccountForecast();
		ID batchprocessid = Database.executeBatch(cls);
	}
}