/**  
 * @Author: Subba Vanipenta
 * @Date :09/24/2015
 * @Description : To Schedule batch class Batch_FreezeUserNotificationToBUAdmins
 * @Version:1 - Initial Development
 */
global class Sched_FreezeUserNotificationToBUAdmins implements Schedulable{
	
	 global void execute(SchedulableContext sc){
        Batch_FreezeUserNotificationToBUAdmins vObjBatchClass = new Batch_FreezeUserNotificationToBUAdmins();
        database.executebatch(vObjBatchClass);
    }

}