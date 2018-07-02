/**
 *  Schedule class to ClsBatch_recalculateOppyRevenue
 *
 @author    Bin Yuan
 @created   2014-08-07
 @version   1.0
 @since     30.0 (Force.com ApiVersion)
 *
 @changelog
 * 2014-08-07 Bin Yuan <bin.yuan@itbconsult.com>
 * 2015-08-12 Subramanian Jairam <subramanian.jairam@te.com>
 * - Created
 */
global class ClsSchedule_recalculateOppyRevenue implements Schedulable {
    global void execute(SchedulableContext sc) {
        ClsBatch_recalculatePartRevenue cls = new ClsBatch_recalculatePartRevenue(); 
        Database.executebatch(cls, 50); // Set batch size for Case #00829282 
        
        /**ClsBatch_recalculateOppyRevenue OppyBatch = new ClsBatch_recalculateOppyRevenue();
        Database.executeBatch(OppyBatch, 50);**/
    }
}