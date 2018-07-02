/**
 *  This class is used to set schedule for running batch class BatchCls_PMVRecordTypeMigration 
 *  
 * @author Jinbo Shan
 * @created 2014-04-28
 * @version 1.0
 * @since 29.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2014-04-28 Jinbo Shan <jinbo.shan@itbconsult.com>
 * - Created   
 *
 */
global class ClsSchedule_PMVRecordTypeMigration implements Schedulable{
	global void execute(SchedulableContext sc) {
		BatchCls_PMVRecordTypeMigration cls = new BatchCls_PMVRecordTypeMigration();
		ID batchprocessid = Database.executeBatch(cls, 25);
	}
}