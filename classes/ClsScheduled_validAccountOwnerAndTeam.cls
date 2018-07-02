/**
 *  This class is used to set schedule for running batch class ClsBatch_validAccountOwnerAndTeam 
 *  
 * @author Yuanyuan Zhang
 * @created 2012-06-25
 * @version 1.0
 * @since 23.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2012-06-25 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>
 * - Created   
 *
 */

global class ClsScheduled_validAccountOwnerAndTeam implements Schedulable{
	global void execute(SchedulableContext sc) {
      	ClsBatch_validAccountOwnerAndTeam batch = new ClsBatch_validAccountOwnerAndTeam(); 
 	 	//database.executebatch(batch);
 	 	database.executebatch(batch,1000);
   	}
}