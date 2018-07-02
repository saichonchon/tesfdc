/**
 *  This class is used to schedule batch job ClsScheduled_recalcBBBMCurrency
 *  
 * @author Lili Zhao
 * @created 2014-03-07
 * @version 1.0
 * @since 28.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2014-03-07 Lili Zhao <lili.zhao@itbconsult.com>
 * - Created   
 *
 */
global class ClsScheduled_recalcBBBMCurrency implements Schedulable{
  global void execute(SchedulableContext sc) {
    ClsBatch_calculateBBBMCurrency cls= new ClsBatch_calculateBBBMCurrency();
    ID batchprocessid = Database.executeBatch(cls);
  }
}