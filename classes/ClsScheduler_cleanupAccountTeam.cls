/**
 *  This class is used to set schedule for running batch class ClsBatch_cleanupAccountTeam 
 *  
 * @author Bin Yu
 * @created 2012-11-28
 * @version 1.0
 * @since 26.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2012-11-28 Bin Yu <bin.yu@itbconsult.com>
 * - Created   
 *
 */

global class ClsScheduler_cleanupAccountTeam implements Schedulable{
	global void execute(SchedulableContext sc) {
      	ClsBatch_cleanupAccountTeam batch = new ClsBatch_cleanupAccountTeam(); 
 	 	database.executebatch(batch);
   	}
}