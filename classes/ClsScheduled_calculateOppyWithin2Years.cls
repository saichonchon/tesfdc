/**
 *  This class is used to schedule batch job ClsBatch_calculateOppyWithin2Years
 *  
 * @author Jinbo Shan
 * @created 2014-06-24
 * @version 1.0
 * @since 29.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2014-06-24 Jinbo Shan <jinbo.shan@itbconsult.com>
 * - Created   
 *
 */
global class ClsScheduled_calculateOppyWithin2Years implements Schedulable{
	global void execute(SchedulableContext sc) {
		ClsBatch_calculateOppyWithin2Years cls= new ClsBatch_calculateOppyWithin2Years();
		ID batchprocessid = Database.executeBatch(cls);
	}
}