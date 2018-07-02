/**
 *  This class is used to schedule batch job ClsBatch_setLastASMFrozenDate
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
global class ClsScheduled_recalcLastAMFrozenDate implements Schedulable{
	global void execute(SchedulableContext sc) {
		ClsBatch_setLastASMFrozenDate cls= new ClsBatch_setLastASMFrozenDate();
		ID batchprocessid = Database.executeBatch(cls);
	}
}