/**
 *  Contains a set of static methods used in invoice creation triggers and VF pages
 *
 @  author Bin Yuan
 @  created 2012-10-30
 @  version 1.0
 @  since 25.0 (Force.com ApiVersion)
 *
 @  changelog
 *  2012-07-03 Bin Yuan <bin.yuan@itbconsult.com>
 *  - Migrated from old system
 *  - Added ...
 *
 *  2012-07-03 Bin Yuan <bin.yuan@itbconsult.com>
 *  - Created
 */
global class ClsScheduled_reCalcFESIPs implements Schedulable{

    global void execute(SchedulableContext sc) {   
    	
	    String year = string.valueOf(system.today().year());
	    ClsBatch_populateSIPDate batchJob = new ClsBatch_populateSIPDate();
	    batchJob.filter = ' And RecordType.DeveloperName = \'FE_Plan\' And Plan_Year__c > \'' + year + '\'';
	    if(!test.isRunningTest()) {
	    	Database.executeBatch(batchJob, 1);  
		}
    }

}