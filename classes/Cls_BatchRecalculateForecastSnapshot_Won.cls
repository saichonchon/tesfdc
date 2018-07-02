/**
 *  A batch job for creating opportunity forecast snapshots when an opportunity receives G0 approval and also when an opportunity reaches won or production status.
 *  
 * @author Jinbo Shan
 * @created 2015-01-29
 * @version 1.0
 * @since 30.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 *
 * 2015-01-29 Jinbo Shan <jinbo.shan@itbconsult.com>
 * - Created 
 *
 * 2015-06-02 Mrunal Parate  
 * - modified - Changed logic by replacing hardcoded Record types with Custom setting containing same record type along with new record type 'Channel_Opportunity_Sales_Project' and 'Channel_Opportunity_Engineering_Project'
 *   for MINI SPIN Project
 */
global class Cls_BatchRecalculateForecastSnapshot_Won implements Database.Batchable<SObject>,Database.Stateful {
    
    public string query;
    public string filter;
    // Change start By Mrunal for MINI SPIN project, Commented hard coded record type values and Used Custom setting 'Opportunity Record type Group' for the same.
    /*public set<string> set_salesRTs = new set<string>{'IND_Sales_Project', 
                                                'NDR_Opportunity', 
                                                'Opportunity_Sales_Parts_Only', 
                                                'Sales_Opportunity_CSD};
                                         
    public set<string> set_engineerRTs = new set<string>{'Engineering_Opportunity_CSD', 
                                                'IND_Engineering_project', 
                                                'Opportunity_Engineering_Project'};*/
                                                
    public set<string> set_salesRTs = new set<string>();
    public set<string> set_engineerRTs = new set<string>();
    global Cls_BatchRecalculateForecastSnapshot_Won(){
        
        List<Opportunity_Record_Type_Groups__c> cusSet = Opportunity_Record_Type_Groups__c.getall().values();
            for (Opportunity_Record_Type_Groups__c rt : cusSet){
                if(rt.Active__c && rt.Group__c == 'Forecast Snapshot Creation' && rt.API_Name__c!= null){
                    if (rt.Is_Sales_Only__c)
                        set_salesRTs.add(rt.API_Name__c);
                    else
                        set_engineerRTs.add(rt.API_Name__c);
                }      
            }
    }
    // Change End By Mrunal for MINI SPIN project
    global Database.QueryLocator start(Database.BatchableContext BC) {
        query = 'Select Id, RecordType.DeveloperName from Opportunity where (RecordType.DeveloperName IN :set_engineerRTs or RecordType.DeveloperName IN :set_salesRTs) and ID in (select OpportunityId from OpportunityHistory where  (StageName = \'Won\' or StageName = \'Production\' or StageName=\'Won - Closed\'))';// where (((RecordType.DeveloperName IN:set_salesRTs or RecordType.DeveloperName IN:set_engineerRTs) and IsWon = true and IsClosed = true) or (Approval_Status_PMV__c=\'G0 Approved\' and RecordType.DeveloperName IN:set_engineerRTs))
        if(filter != null) {
            query += filter;
        }
        system.debug('**@@query = ' + query);
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, list<Opportunity> list_oppys) {
        
        set<Id> set_oppyIds = new set<Id>();
        map<Id, set<string>> map_oppyId_set_snapshotTypes = new map<Id, set<string>>();
        list<Forecast_Snapshot__c> list_fss4insert = new list<Forecast_Snapshot__c>();
        system.debug('**@@set_engineerRTs = ' + set_engineerRTs);
        system.debug('**@@set_salesRTs = ' + set_salesRTs);
        for(Opportunity oppy : list_oppys) {
            map_oppyId_set_snapshotTypes.put(oppy.Id, new set<string>{'Won'});
        }
        
        //remove the oppyid that the opportunities have won or Approval snapshot from map_oppyId_set_snapshotTypes.
        for(AggregateResult fs : [SELECT count(Id) num, Snapshot_Type__c st, Opportunity__c oppy 
                                    FROM Forecast_Snapshot__c 
                                    WHERE Opportunity__c IN :map_oppyId_set_snapshotTypes.keySet() 
                                    and Part__c != null 
                                    and (Snapshot_Type__c = 'Won' or Snapshot_Type__c = 'Approval') 
                                    group by Opportunity__c, Snapshot_Type__c]) {
            if(Integer.valueOf(String.valueOf(fs.get('num'))) > 0 && map_oppyId_set_snapshotTypes.get((Id)string.valueOf(fs.get('oppy'))).contains(String.valueOf(fs.get('st')))) {
                map_oppyId_set_snapshotTypes.get((Id)string.valueOf(fs.get('oppy'))).remove(String.valueOf(fs.get('st')));
                system.debug('**@@dsdsss' + map_oppyId_set_snapshotTypes.get((Id)string.valueOf(fs.get('oppy'))).size());
                if(map_oppyId_set_snapshotTypes.get((Id)string.valueOf(fs.get('oppy'))).size() <= 0) {
                    map_oppyId_set_snapshotTypes.remove((Id)string.valueOf(fs.get('oppy')));
                }
            }
        }
        
        system.debug('**@@system.debug(map_oppyId_set_snapshotTypes); = ' + map_oppyId_set_snapshotTypes);
        
        set<Id> set_oppyId4Wonsnapshot =  new set<Id>();
        set<Id> set_oppyId4Approvalsnapshot = new set<Id>();
        for(Id oppyId : map_oppyId_set_snapshotTypes.keySet()) {
            for(string snapshotType : map_oppyId_set_snapshotTypes.get(oppyId)) {
                if(snapshotType == 'Won') {
                    set_oppyId4Wonsnapshot.add(oppyId);
                }else if(snapshotType == 'Approval') {
                    set_oppyId4Approvalsnapshot.add(oppyId);
                }
                
            }
        }
        system.debug('**@@set_oppyId4Wonsnapshot = ' + set_oppyId4Wonsnapshot);
        system.debug('**@@set_oppyId4Approvalsnapshot = ' + set_oppyId4Approvalsnapshot);
        if(set_oppyId4Wonsnapshot.size() > 0) {

            map<Id, DateTime> map_oppyId_wonDate = new map<Id, DateTime>();
            set<Id> set_partIds = new set<Id>();
            DateTime minDate;
        
            for(OpportunityHistory oppyHis : [select OpportunityId, StageName, CreatedDate 
                                                from OpportunityHistory 
                                                where OpportunityId IN : set_oppyId4Wonsnapshot 
                                                and (StageName = 'Won' or StageName = 'Production' or StageName='Won - Closed')
                                                order by OpportunityId, CreatedDate desc]) {
                if(!map_oppyId_wonDate.containsKey(oppyHis.OpportunityId)) {
                    map_oppyId_wonDate.put(oppyHis.OpportunityId, oppyHis.CreatedDate);
                    if(minDate == null || minDate > oppyHis.CreatedDate) {
                        minDate = oppyHis.CreatedDate;
                    }
                }
                
            }
            
            if(map_oppyId_wonDate.size() > 0) {
                cloneMonthlySnapshot(list_fss4insert, map_oppyId_wonDate, minDate, 'Won', set_partIds);
            }
            
        }
        
        if(list_fss4insert.size() > 0) {
            system.debug('**@@list_fss4insert = ' + list_fss4insert);
            insert list_fss4insert;
        }
                
    }
    global void finish(Database.BatchableContext BC) {
        
    }
    
    public static void cloneMonthlySnapshot(list<Forecast_Snapshot__c> list_fss4insert, map<Id, DateTime> map_oppyId_wonDate, DateTime minDate, string status, set<Id> set_partIds) {
        
        map<Id, set<date>> map_partId_set_forecastdates = new map<Id, set<date>>();
        for(Forecast_Snapshot__c fsTemp : [select Amount__c, ConnectionReceivedId, ConnectionSentId, 
                                        Conversion_Age__c, Converted_Value__c, Count_Conversion__c, 
                                        Count_Pipeline__c, CreatedById, CreatedDate, CurrencyIsoCode, 
                                        Date__c, Days_since_last_user_update__c, Direct_Amount__c, 
                                        Fiscal_Quarter__c, Fiscal_Year__c, Fiscal_Year_Quarter__c, 
                                        Forecast_Date__c, Forecast_Owner__c, FY13_BR_value__c, Id, 
                                        IsDeleted, LastModifiedById, LastModifiedDate, LastReferencedDate, 
                                        LastViewedDate, Name, Open_Value__c, Oportunity_age_days__c, 
                                        Opportunity__c, Opportunity_Owner_Id__c, Opportunity_Stage__c, 
                                        Part__c, Part_Confidence__c, Part_Won_Fiscal_Quarter__c, 
                                        Part_Won_Fiscal_Year__c, Pipeline_Indicator__c, Pipeline_Value__c, 
                                        POS_Amount__c, Process_Status__c, Quantity__c, RecordTypeId, 
                                        Sales_Price__c, Snapshot_Type__c, SystemModstamp, Timestamp__c, 
                                        Won_Date__c  
                                        from Forecast_Snapshot__c 
                                        where Opportunity__c IN :map_oppyId_wonDate.keySet() 
                                        and Snapshot_Type__c = 'Monthly' 
                                        and Part__c != null 
                                        and CreatedDate >= :minDate 
                                        order by CreatedDate]) {
            if(fsTemp.CreatedDate >= map_oppyId_wonDate.get(fsTemp.Opportunity__c) && fsTemp.CreatedDate <= map_oppyId_wonDate.get(fsTemp.Opportunity__c).addDays(7)) {
                if(!map_partId_set_forecastdates.containsKey(fsTemp.Part__c)) {
                    map_partId_set_forecastdates.put(fsTemp.Part__c, new set<date>());
                }
                if(!map_partId_set_forecastdates.get(fsTemp.Part__c).contains(fsTemp.Forecast_Date__c)) {
                    map_partId_set_forecastdates.get(fsTemp.Part__c).add(fsTemp.Forecast_Date__c);
                    Forecast_Snapshot__c fs = fsTemp.clone(false, true, false, true);
                    fs.Snapshot_Type__c = status;
                    list_fss4insert.add(fs);
                }
            }
            
        }
    }
}