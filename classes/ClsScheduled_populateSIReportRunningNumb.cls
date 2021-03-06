/**
 *  Call batch job ClsBatch_populateSIPDataFromReport
 *
 @  author Bin Yuan
 @  created 2014-09-28
 @  version 1.0
 @  since 30.0 (Force.com ApiVersion)
 *
 @  changelog
 *  2014-09-28 Bin Yuan <bin.yuan@itbconsult.com>
 *  - Created
 */
global class ClsScheduled_populateSIReportRunningNumb implements Schedulable{

    global void execute(SchedulableContext sc) {  
    	
	    String year = string.valueOf(system.today().year());
	    ClsBatch_populateSIPRunningNumbers batchJob = new ClsBatch_populateSIPRunningNumbers();

	    if(!test.isRunningTest()) {
	    	Database.executeBatch(batchJob);
		}
    }

}