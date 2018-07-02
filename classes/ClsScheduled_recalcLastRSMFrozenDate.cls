/**
 *  This class is used to set schedule for running batch class ClsBatch_setLastRSMFrozenDate 
 *  
 * @author Bin Yuan
 * @created 2014-03-03
 * @version 1.0
 * @since 28.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2014-03-03 Bin Yu <bin.yuan@itbconsult.com>
 * - Created   
 *
 */
global class ClsScheduled_recalcLastRSMFrozenDate implements Schedulable{
	global void execute(SchedulableContext sc) {
      	ClsBatch_setLastRSMFrozenDate batch = new ClsBatch_setLastRSMFrozenDate(); 
 	 	database.executebatch(batch);
   	}
}