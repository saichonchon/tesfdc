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
global class ClsScheduled_fetchSIPReportResult implements Schedulable{
	global map<SIP__c, list<ClsSIPUitl.ReportMap>> map_sip_reportMapping;
	global list<ClsSIPUitl.SIPCustomExcMSG> list_exceptions;
    global void execute(SchedulableContext sc) {   
    	system.debug('sc :: ' + sc);
	    ClsBatch_fetchSIPReportResult batchJob = new ClsBatch_fetchSIPReportResult();
	    //String sessionId = UserInfo.getSessionId();
	    //system.debug('session id :: ' + sessionId);
	    system.debug('Test run :: ' + test.isRunningTest());
	    //batchJob.sessionId = sessionId;
	    if(!test.isRunningTest()) {
	    	system.debug('Test run ?');
	    	Database.executeBatch(batchJob, 10); 
		}
		
    }

}