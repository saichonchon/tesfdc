/**
* 
* This Schedule class is used to automated monthly cleanup process on Interest tag object.
* 
* @author      Nagaraju Gorli
* @created     2017-07-25                                                          
*     
*/
global with sharing class InterestTagMonthlyCleanupSch implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        
        InterestTagMonthlyCleanupBatch interesttagBatch= new InterestTagMonthlyCleanupBatch();
        database.executebatch(interesttagBatch);         
    }
}