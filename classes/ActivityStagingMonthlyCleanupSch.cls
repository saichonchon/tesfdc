/**
* 
* This Schedule class is used to automated monthly cleanup process on Key Activity Staging object.
* 
* @author      Nagaraju Gorli
* @created     2017-07-25                                                          
*     
*/
global with sharing class ActivityStagingMonthlyCleanupSch implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        
        ActivityStagingMonthlyCleanupBatch activityBatch= new ActivityStagingMonthlyCleanupBatch();
        database.executebatch(activityBatch);         
    }
}