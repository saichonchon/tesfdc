/**
 *  This class is used to set schedule for running batch class ClsBatch_Accountupdate_saleshierarchy
 *  
 * @author Anil Kumar Attelli
 * @created 04/7/2014
 * @version 1.0
 * @since 30.0 (Force.com ApiVersion)   
 *
 */

global class ClsScheduler_Accountupdate_saleshierar implements Schedulable{
  global void execute(SchedulableContext sc) {
        ClsBatch_Accountupdate_saleshierarchy schdbatch = new ClsBatch_Accountupdate_saleshierarchy(); 
      database.executebatch(schdbatch);
     }
}