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
global class ClsBatch_populateSIPRunningNumbers implements Database.Batchable<sObject>, Database.stateful, Database.AllowsCallouts{
    public String query;
    public String filter;
    global set<Id> set_loadStatus;
    public map<String, list<SIP__c>> map_sipMappingId_list_sips = new map<String, list<SIP__c>>();
    global String currentYear = ClsSIPUitl.getCurrentFiscalYear();
    global Integer runningNumb = 0;
    global String sessionId;
    
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        //Added by Bin Yuan 2015-09-18 due to Remove custom setting before batch run
        ClsSIPUitl.removeSettingBeforeBatchRun();
        
        if(query == null || query == ''){            
            query = 'Select Id, SIP_Mapping__c, Running_Number__c, Recalculate__c, SIP_Report_Instance__c '
                  + ' From SIP__c '
                  + ' where Exclude_From_Automatic_Update__c = false and SIP_Mapping__c != null ';
        }
        if(set_loadStatus != null && !set_loadStatus.isEmpty()) {
            query += ' And ( Load_Status_Monthly_Direct__c IN : set_loadStatus OR Load_Status_Record_Indirect__c IN : set_loadStatus) ';
        }
        if(filter != null) query += filter;
        system.debug(' query ::: '+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, list<SIP__c> list_sips){ 
        /*
        for(SIP__c sip : list_sips) {
            sip.Running_Number__c = 0;
            if(!map_sipMappingId_list_sips.containsKey(sip.SIP_Mapping__c)) {
                map_sipMappingId_list_sips.put(sip.SIP_Mapping__c, new list<SIP__c>());
            }
            map_sipMappingId_list_sips.get(sip.SIP_Mapping__c).add(sip);
        }   
        ClsSIPUitl.ISAFTERUPDATE = true;
        runningNumb = ClsSIPUitl.populateSIPRunningNumbers(runningNumb, map_sipMappingId_list_sips);
        ClsSIPUitl.ISAFTERUPDATE = false;
        */
        for(SIP__c sip : list_sips) {
            sip.Running_Number__c = 100;
            sip.SIP_Report_Instance__c = '';
            sip.Recalculate__c = (sip.Recalculate__c == false ? true : false);
        }   
        ClsSIPUitl.ISAFTERUPDATE = true;
        update list_sips;
        ClsSIPUitl.ISAFTERUPDATE = false;       
    }      
    
    global void finish(Database.BatchableContext BC){
        ClsBatch_populateSIPDataFromReport cls = new ClsBatch_populateSIPDataFromReport();
        //cls.filter = ' and Running_Number__c != null limit 150 ';
        //cls.sessionId = sessionId;
        Database.executeBatch(cls, 10);
    }
}