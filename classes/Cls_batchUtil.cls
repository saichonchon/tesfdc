/**
 *  Util class for Batch class
 *
 @author    Bin Yuan
 @created   2014-11-28
 @version   1.0
 @since     30.0 (Force.com ApiVersion)
 *
 @changelog
 * 2014-11-28 Bin Yuan <bin.yuan@itbconsult.com>
 * - Created
 */
public class Cls_batchUtil {
   /**
    * The method is used to report error info for batch classes
    *
    @author Bin Yuan
    @created 2014-11-28
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-11-28 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void errorReportForBatch(list<String> list_errorInfos, String subject) {
    	
    	Batch_Job_Log__c log = new Batch_Job_Log__c();
    	log.Running_User__c = UserInfo.getUserId();
    	log.Subject__c = subject;
    	Sobject sobj = (Sobject) log;
    	Integer fieldIndex = 1;
    	String fieldApi = 'Result_' + fieldIndex + '__c';
    	if(list_errorInfos.isEmpty()) {
    		sobj.put(fieldApi, 'Batch job finished without any errors!');
    	}
		for(String exc : list_errorInfos) {
			String errorLog = (sobj.get(fieldApi) == null ? '' : String.valueOf(sobj.get(fieldApi)));
			if((errorLog.length() + exc.length()) > 130000) {
				fieldIndex ++;
				fieldApi = 'Result_' + fieldIndex + '__c';
			}
			if(fieldIndex > 10) {
				break;
			}
			errorLog = (sobj.get(fieldApi) == null ? '' : String.valueOf(sobj.get(fieldApi)));
			errorLog += exc;
			sobj.put(fieldApi, errorLog);
		}
    	log = (Batch_Job_Log__c) sobj;
    	insert log;
    }
}