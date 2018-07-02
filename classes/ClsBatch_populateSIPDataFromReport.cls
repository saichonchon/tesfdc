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
global class ClsBatch_populateSIPDataFromReport implements Database.Batchable<sObject>, Database.stateful, Database.AllowsCallouts{
    global String query;
    public String filter;
    global String sessionId;
    global Integer callOutLimits = 10;
    global Integer queryLimit = 150;
    global Integer previousRunningNumb = 0;
    global list<ClsSIPUitl.SIPCustomExcMSG> list_exceptions = new list<ClsSIPUitl.SIPCustomExcMSG>();
    global map<String, ClsSIPUitl.SIPCustomExcMSG> map_sipId_exception = new map<String, ClsSIPUitl.SIPCustomExcMSG>();
    global set<String> set_successSIPIds = new set<String>();
    global String currentYear = ClsSIPUitl.getCurrentFiscalYear();
    global boolean isBatchFinished = true;
    
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        sessionId = ClsSIPUitl.getSessionId();
        if(SIP_Sharing_Setting__c.getInstance('SIP Run Report Query Limit') != null) {
            SIP_Sharing_Setting__c setting = SIP_Sharing_Setting__c.getInstance('SIP Run Report Query Limit');
            queryLimit = (setting.value__c == null ? queryLimit : Integer.valueOf(setting.value__c));
        }
        if(SIP_Sharing_Setting__c.getInstance('Callout limit') != null) {
            SIP_Sharing_Setting__c setting = SIP_Sharing_Setting__c.getInstance('Callout limit');
            callOutLimits = (setting.value__c == null ? callOutLimits : Integer.valueOf(setting.value__c));
        }
        previousRunningNumb = (previousRunningNumb == null ? 0 : previousRunningNumb);
        Integer currentRunningNumb = callOutLimits + previousRunningNumb;
        system.debug('currentRunningNumb :: ' + currentRunningNumb);
        system.debug('previousRunningNumb :: ' + previousRunningNumb);
        if(query == null || query == ''){            
            query = 'Select Id, SIP_Mapping__c '
                  + ' From SIP__c '
                  + ' where Exclude_From_Automatic_Update__c = false and SIP_Mapping__c != null '
                  + ' And Running_Number__c != null ';
        }
        if(filter != null) query += filter;
        query += ' limit ' + queryLimit;
        system.debug(' query ::: ' + query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, list<SIP__c> list_sips){ 
        isBatchFinished = false;
        
        system.debug('sessionId: ' + sessionId);  
        system.debug('list_sips.size() :: ' + list_sips.size()); 
        system.debug('isBatchFinished :: ' + isBatchFinished);
        try {
            ClsSIPUitl.ISAFTERUPDATE = true;
            map<String, list<ClsSIPUitl.ReportMap>> map_sipMappingId_list_reportMap = new map<String, list<ClsSIPUitl.ReportMap>>();
            map<String, SIP__c> map_sipId_sip = new map<String, SIP__c>();
            for(SIP__c sip : list_sips) {
                map_sipId_sip.put(sip.Id, sip);
                if(!map_sipMappingId_list_reportMap.containsKey(sip.SIP_Mapping__c)) {
                    map_sipMappingId_list_reportMap.put(sip.SIP_Mapping__c, new list<ClsSIPUitl.ReportMap>());
                }
                
                //ClsSIPUitl.populatDataFromReport(sip);
                //ClsSIPUitl.populatDataFromReportAsyn(sip, map_sip_list_sipMappings, sessionId);
                //set_successSIPIds.add(sip.Id);
            }
            system.debug('sessionId: ' + sessionId); 
            ClsSIPUitl.populatDataFromReportAsyn(map_sipId_sip, map_sipId_exception, map_sipMappingId_list_reportMap, sessionId);
            ClsSIPUitl.ISAFTERUPDATE = false;
        }
        catch(Exception ex) {
            //Error handling
            if(list_sips.isEmpty()) {
                return;
            }
            if(!map_sipId_exception.containsKey(list_sips[0].Id)) {
                map_sipId_exception.put(list_sips[0].Id, new ClsSIPUitl.SIPCustomExcMSG());
            }
            ClsSIPUitl.SIPCustomExcMSG msg = map_sipId_exception.get(list_sips[0].Id);
            msg.sipId = list_sips[0].Id;
            msg.errorMsg += ex.getMessage() + '\n';
        }
    }      
    
    global void finish(Database.BatchableContext BC){
        system.debug('list_exceptions :: ' + list_exceptions);
        isBatchFinished = true;
        for(SIP__c sip : database.query(query)) {
            isBatchFinished = false;
            break;
        }
        if(!Test.isRunningTest()) {
        	ClsSIPUitl.reScheduleJobToRunReport(isBatchFinished, previousRunningNumb, sessionId, map_sipId_exception.values()); 
        }
    }
}