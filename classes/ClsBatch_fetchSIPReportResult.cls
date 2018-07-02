/** 
 *    batch class for populate SIP data from report
 *
 @author Bin Yuan
 @created 2014-09-23 
 @version 1.0
 @since 30.0 (Force.com ApiVersion)
 *
 @changelog
 * 2014-09-23 Bin Yuan<bin.yuan@itbconsult.com>
 * - Created
 */
global class ClsBatch_fetchSIPReportResult implements Database.Batchable<sObject>, Database.stateful, Database.AllowsCallouts{
    public String query;
    global String filter;
    global String sessionId; // = ClsSIPUitl.getScheduledJobSession();
    global Integer callOutLimits;
    global Integer previousRunningNumb = 0;
    global Integer totalNumbers = 0;
    global boolean isRecalc = false;
    global list<ClsSIPUitl.SIPCustomExcMSG> list_exceptions = new list<ClsSIPUitl.SIPCustomExcMSG>();
    global map<String, ClsSIPUitl.SIPCustomExcMSG> map_sipId_exception = new map<String, ClsSIPUitl.SIPCustomExcMSG>();
    global set<String> set_successSIPIds = new set<String>();
    global String currentYear = ClsSIPUitl.getCurrentFiscalYear();
    global boolean isBatchFinished = true;
    global list<SIP__c> list_sips2Update = new list<SIP__c>();      
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        
        if(SIP_Sharing_Setting__c.getInstance('Callout limit') != null) {
            SIP_Sharing_Setting__c setting = SIP_Sharing_Setting__c.getInstance('Callout limit');
            callOutLimits = (setting.value__c == null ? 10 : Integer.valueOf(setting.value__c));
        }
        sessionId = ClsSIPUitl.getSessionId();
        if(query == null || query == ''){            
            query = 'Select Id, Running_Number__c, SIP_Mapping__c,SIP_Report_Instance__c '
                  + ' From SIP__c '
                  + ' where Exclude_From_Automatic_Update__c = false and SIP_Mapping__c != null '
                  + ' And Is_Report_Finished__c = false ';
        }
        if(filter != null) query += filter;
        system.debug(' query ::: '+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, list<SIP__c> list_sips){ 
        
        isBatchFinished = false;
        Integer counter = 0;
        
        set<String> set_queryFields = new set<String>();
        map<String, SIP__c> map_sipId_sip = new map<String, SIP__c>();
        
        system.debug('sessionId :: ' + sessionId);
        system.debug('callOutLimits :: ' + callOutLimits);
        ClsSIPUitl.ISAFTERUPDATE = true;
        for(SIP__c sip : list_sips) {
            if(sip.SIP_Report_Instance__c != null){
                //added by bin yuan 2017-07-27 due to debug instance info
                system.debug('sip.SIP_Report_Instance__c :: ' + sip.SIP_Report_Instance__c);
                //End
                
                for(String reportInstance : sip.SIP_Report_Instance__c.split(';')) {
                    if(counter < callOutLimits) {
                        if(!map_sipId_sip.containsKey(sip.Id)) {
                            map_sipId_sip.put(sip.Id, sip);
                        }
                        String target = reportInstance.split(',')[1];
                        set_queryFields.add(target);
                    } 
                    else {
                        if(map_sipId_sip.containsKey(sip.Id)) {
                            /*
                            ClsSIPUitl.SIPCustomExcMSG msg = new ClsSIPUitl.SIPCustomExcMSG();
                            msg.sipId = sip.Id;
                            msg.errorMsg = 'Too many callouts for execute method. ' + '\n';
                            map_sipId_exception.put(sip.Id, msg);
                            */
                            map_sipId_sip.remove(sip.Id);
                        }
                    }
                    counter ++;
                }
            }
        }
        system.debug('counter :: ' + counter);
        ClsSIPUitl.fetchDataFromReportAsyn(map_sipId_sip, map_sipId_exception, sessionId, set_queryFields);
        ClsSIPUitl.ISAFTERUPDATE = false;
    }      
    
    global void finish(Database.BatchableContext BC){
        ClsSIPUitl.ISAFTERUPDATE = true;
        if(!list_sips2Update.isEmpty()) {
            update list_sips2Update;
        }
        ClsSIPUitl.ISAFTERUPDATE = false;
        ClsSIPUitl.reScheduleJobToFetchReportData(isBatchFinished, filter, map_sipId_exception, isRecalc);
    }
}