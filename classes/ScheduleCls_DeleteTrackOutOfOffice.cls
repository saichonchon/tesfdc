/**
 * 
 * Purpose of this schedule class is to delete "Track Out Of Office" records which are created 1 year ago.
 *
 * @author      Poonam Hedaoo
 * @created     2017-09-04
 * @since       40.0     
 * @version     1.0                                                                
 *    
 */
global class ScheduleCls_DeleteTrackOutOfOffice implements Schedulable{
    global void execute(SchedulableContext sc){
        String query = 'select id from Track_Out_Of_office__c where CreatedDate != LAST_N_DAYS:365 and Out_of_office_Disabled_On__c != NULL';
        BatchCls_DeleteTrackOutOfOffice delBatch = new BatchCls_DeleteTrackOutOfOffice(query);
        Id BatchProcessId = Database.ExecuteBatch(delBatch);
    }
}