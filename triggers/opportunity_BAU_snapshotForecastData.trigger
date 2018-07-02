/**
* 
*   In case the Opportunity Stage is changed to "In Approval" or "Mass-prod", this trigger creates
*   a forecasting snapshot and stores it in Forecast Snapshot object. In addition the Oppy Owner is changed to the Account Manager.
*
*   Author              |Author-Email                       |Date        |Comment
*   --------------------|---------------------------------- |------------|-------------------------------------
*   Frederic Faisst     |frederic.faisst@itbconsult.com     |14.03.2012  |Initial Draft
*   Peng Zhu            |peng.zhu@itbconsult.com            |28.08.2012  |Modified the if statement to forecast only in case of "In Approval" and comment out the Oppy Owner update 
@changelog
* 2013-02-18 Bin Yu <bin.yu@itbconsult.com>
* - added the date fields "Date", "Fiscal Year", "Fiscal Quarter" and type
* 2014-05-08 Bin Yu <bin.yu@itbconsult.com>
* - added trigger-defense
* 2015-06-09 Padmaja Dadi <padmaja.dadi@zensar.in>
* - Added DND Opportunity for DND Merge project
* 2016-02-17 Rajendra Shahane <rajendra.shahane@zensar.in>
* - Added check for Opportunity_Product_Platform, Channel_Engineering_Opportunity and Channel_Sales_Opportunity recordtype opportunities for creation of "Forecast_Snapshot__c" record
*   For case 00900678
*/
trigger opportunity_BAU_snapshotForecastData on Opportunity (after update) {
    
    /*
    *   Collections & Variables
    */
    //added by BYU 2014-05-08 
    //if(ClsPMV_Util.runningTriggerName.indexOf('opportunity_BAU_snapshotForecastData') == -1){
        //ClsPMV_Util.runningTriggerName += 'opportunity_BAU_snapshotForecastData';
        if(Apex_Helper_Settings__c.getInstance('oppy_BAU_snapshotForecastData_invalid') == null || !Apex_Helper_Settings__c.getInstance('oppy_BAU_snapshotForecastData_invalid').Active__c){
            Map<id, String> RTMap = new Map<Id, String>();
            Map<String, Consumer_Device_Opportunity_Record_Types__c> ConsumerMap = Consumer_Device_Opportunity_Record_Types__c.getall();
            Map<String, Opportunity_Record_Type_Groups__c> OppRtMap = Opportunity_Record_Type_Groups__c.getall(); //DND
            Map<Id, String> map_oppyId_oppyStage = new Map<Id, String>();
            Map<Id, String> map_oppyId_oppyStage4approval = new Map<Id, String>();
            Set<Id> set_oppyIds = new Set<Id>();
            RTMap.put(ConsumerMap.get('Engineering Opportunity-CSD').Record_Type_Id__c, ConsumerMap.get('Engineering Opportunity-CSD').Name);
            RTMap.put(ConsumerMap.get('Sales Opportunity-CSD').Record_Type_Id__c, ConsumerMap.get('Sales Opportunity-CSD').Name);
            if(OppRtMap.get('DND Opportunity')!=null)RTMap.put(OppRtMap.get('DND Opportunity').RecordTypeID__c,OppRtMap.get('DND Opportunity').Name); //DND
            List<Forecast_Snapshot__c> list_fcSnaps2Delete = new List<Forecast_Snapshot__c>();
            List<Forecast_Snapshot__c> list_fcSnaps2Insert = new List<Forecast_Snapshot__c>();
            
            Id fcSnapPartRecordTypeId = Apex_Helper_Settings__c.getInstance('Forecast Snapshot Part RT Id').Value__c;
            Id fcSnapOppyRecordTypeId = Apex_Helper_Settings__c.getInstance('Forecast Snapshot Oppy RT Id').Value__c;
            
            
            //added by Jinbo Shan at 2014-11-06
            string opportunityStage;
            string approvalStage;
            string finalStage;
            //Start:added by Rajendra 2016-02-06
            Map<id, Forecast_Snapshot_Setup__c> mapRecordTypeIdForecastSnapSetting = new Map<Id, Forecast_Snapshot_Setup__c>();
            Map<string, Forecast_Snapshot_Setup__c> mapForecastSnapSetting = Forecast_Snapshot_Setup__c.getall();
            if(mapForecastSnapSetting != null && mapForecastSnapSetting.size() > 0)
            {
                for(Forecast_Snapshot_Setup__c SnapshotSetting: mapForecastSnapSetting.values())
                {
                    if(SnapshotSetting.Opportunity_RecordTypeId__c != null)
                        mapRecordTypeIdForecastSnapSetting.put((Id)SnapshotSetting.Opportunity_RecordTypeId__c, SnapshotSetting);
                }
                Forecast_Snapshot_Setup__c SnapSettingapprovalStage = mapForecastSnapSetting.get('Approval Stage');
                if(SnapSettingapprovalStage != null)
                {
                    approvalStage = SnapSettingapprovalStage.Value__c;
                }                
            }
            //End:added by Rajendra 2016-02-17
            /*Start Commented by Rajendra 2016-02-06
            if(Forecast_Snapshot_Setup__c.getInstance('Opportunity Stage') != null) {
                opportunityStage = Forecast_Snapshot_Setup__c.getInstance('Opportunity Stage').Value__c;
                finalStage = Forecast_Snapshot_Setup__c.getInstance('Opportunity Stage').Final_Stage__c;
            }
            if(Forecast_Snapshot_Setup__c.getInstance('Approval Stage') != null) {
                approvalStage = Forecast_Snapshot_Setup__c.getInstance('Approval Stage').Value__c;
            }
            End Commented by Rajendra 2016-02-06*/
            
            //All Oppies in Trigger Loop
            if(Trigger.isAfter){
                //for(Opportunity oppy : [SELECT Id, StageName, RecordTypeId, RecordType.BusinessProcessId, Approval_Status_PMV__c, PMV_Type__c FROM Opportunity WHERE Id IN : Trigger.newMap.keyset()]){
                //modified and comment out by padmaja at 2014-04-04
                /*comment out by Jinbo Shan at 2014-11-06
                    if(Trigger.oldMap.get(oppy.Id).StageName != oppy.StageName && (oppy.StageName == 'In Approval' ) && (RTMap.get(oppy.RecordTypeId) != 'Sales Opportunity-CSD') && (RTMap.get(oppy.RecordTypeId) != 'Engineering Opportunity-CSD')){ //  || oppy.StageName == 'Mass-prod'   modified and comment out by Peng Zhu at 2012-08-28
                        map_oppyId_oppyStage.put(oppy.Id, oppy.StageName);
                    }
                    if(Trigger.oldMap.get(oppy.Id).Approval_Status_PMV__c != oppy.Approval_Status_PMV__c && oppy.Approval_Status_PMV__c != null){
                        for(PMV_Sales_Process_Settings__c ssps : PMV_Sales_Process_Settings__c.getAll().values()){
                            if((Id)ssps.Sales_Process_ID__c == oppy.RecordType.BusinessProcessId && oppy.PMV_Type__c == ssps.PMV_Type__c && ssps.Approval_Status_for_Snapshots__c != null){
                                for(string ass : ssps.Approval_Status_for_Snapshots__c.split(',')){
                                    if(ass == oppy.Approval_Status_PMV__c){
                                        map_oppyId_oppyStage.put(oppy.Id, oppy.Approval_Status_PMV__c);
                                        break;
                                    }
                                }
                            }
                        }
                    }*/
                //added by Jinbo Shan at 2014-11-06 to insert snapshot, when the Approval_Status_PMV__c is changed to approvalStage or the StageName is changed to opportunityStage that is in the custom setting.
                boolean shouldQuerySnapshots = false;
                for(Opportunity oppy : trigger.new) {
                //Added DND Opportunity record type for DND merge project by Padmaja Dadi 06/09/2015
                    if((RTMap.get(oppy.RecordTypeId) != 'Sales Opportunity-CSD') && (RTMap.get(oppy.RecordTypeId) != 'Engineering Opportunity-CSD') && (RTMap.get(oppy.RecordTypeId) != 'DND Opportunity')){
                        //Start : added by Rajendra at 2016-02-17 to get values of opportunityStage and finalStage based on opportunity recordtype
                        if(mapRecordTypeIdForecastSnapSetting.containskey(oppy.recordtypeId))
                        {
                            opportunityStage = mapRecordTypeIdForecastSnapSetting.get(oppy.recordtypeId).Value__c;
                            finalStage = mapRecordTypeIdForecastSnapSetting.get(oppy.recordtypeId).Final_Stage__c;
                        }
                        else
                        {
                            Forecast_Snapshot_Setup__c SnapSettingapprovalStage1 = mapForecastSnapSetting.get('Opportunity Stage');
                            if(SnapSettingapprovalStage1 != null)
                            {
                                opportunityStage = SnapSettingapprovalStage1.Value__c;
                                finalStage = SnapSettingapprovalStage1.Final_Stage__c;
                            }
                        }
                        // End : added by Rajendra at 2016-02-06
                        if(opportunityStage != null) {
                            if(!opportunityStage.contains(oppy.StageName) && Trigger.oldMap.get(oppy.Id).StageName != oppy.StageName && opportunityStage.contains(Trigger.oldMap.get(oppy.Id).StageName) && finalStage != null && finalStage.contains(oppy.StageName)) {
                                shouldQuerySnapshots = true;
                            }
                        }
                        
                    }
                }
                if(shouldQuerySnapshots) {
                    for(AggregateResult oppyFs : [SELECT count(Id) idNum, Opportunity__c oppy 
                                                  FROM Forecast_Snapshot__c 
                                                  Where Opportunity__c in :trigger.newMap.keySet() 
                                                  and Snapshot_Type__c = 'Won' 
                                                  Group By Opportunity__c]) {
                        set_oppyIds.add((Id)(string.valueOf(oppyFs.get('oppy'))));
                    }
                }
                
                for(Opportunity oppy : trigger.new) {
                //Added DND Opportunity record type for DND merge project by Padmaja Dadi 06/09/2015
                    if((RTMap.get(oppy.RecordTypeId) != 'Sales Opportunity-CSD') && (RTMap.get(oppy.RecordTypeId) != 'Engineering Opportunity-CSD') && (RTMap.get(oppy.RecordTypeId) != 'DND Opportunity')){
                    
                        if(Trigger.oldMap.get(oppy.Id).Approval_Status_PMV__c != oppy.Approval_Status_PMV__c && approvalStage != null && approvalStage.contains(oppy.Approval_Status_PMV__c)){ //  || oppy.StageName == 'Mass-prod'   modified and comment out by Peng Zhu at 2012-08-28
                            map_oppyId_oppyStage4approval.put(oppy.Id, oppy.StageName);
                        }
                        //Start : added by Rajendra at 2016-02-17 to get values of opportunityStage and finalStage based on opportunity recordtype
                        if(mapRecordTypeIdForecastSnapSetting.containskey(oppy.recordtypeId))
                        {
                            opportunityStage = mapRecordTypeIdForecastSnapSetting.get(oppy.recordtypeId).Value__c;
                            finalStage = mapRecordTypeIdForecastSnapSetting.get(oppy.recordtypeId).Final_Stage__c;
                        }
                        else
                        {
                            Forecast_Snapshot_Setup__c SnapSettingapprovalStage2 = mapForecastSnapSetting.get('Opportunity Stage');
                            if(SnapSettingapprovalStage2 != null)
                            {
                                opportunityStage = SnapSettingapprovalStage2.Value__c;
                                finalStage = SnapSettingapprovalStage2.Final_Stage__c;
                            }
                        }
                        // End : added by Rajendra at 2016-02-06
                        if(opportunityStage != null) {
                            if(Trigger.oldMap.get(oppy.Id).StageName != oppy.StageName && opportunityStage.contains(oppy.StageName)) {
                                map_oppyId_oppyStage.put(oppy.Id, oppy.StageName);
                            }else if(Trigger.oldMap.get(oppy.Id).StageName != oppy.StageName && (!set_oppyIds.contains(oppy.Id) || !opportunityStage.contains(Trigger.oldMap.get(oppy.Id).StageName)) && finalStage != null && finalStage.contains(oppy.StageName)) {
                                map_oppyId_oppyStage.put(oppy.Id, oppy.StageName);
                            }
                        }
                        
                    }
                }
                system.debug('**@@@@map_oppyId_oppyStage = ' + map_oppyId_oppyStage);
                //If record are in Trigger Loop
                if(!map_oppyId_oppyStage.isEmpty()){
                    //Check if "In Approval" or "Mass-prod" forecast snapshot records already exists for the given Opportunity
                    for(Forecast_Snapshot__c fcSnap : [Select Id, Opportunity_Stage__c, Opportunity__c From Forecast_Snapshot__c Where Snapshot_Type__c = 'Won' and Opportunity__c in :map_oppyId_oppyStage.keySet()]){
                        //if(fcSnap.Opportunity_Stage__c == map_oppyId_oppyStage.get(fcSnap.Opportunity__c)){
                        //If yes add record to delete list
                        list_fcSnaps2Delete.add(fcSnap);
                        //}
                    }
        
                    for(Opportunity_Forecast__c oppyFC : [SELECT Id, Counts_for_IND_Pipeline__c, Counts_for_IND_Conversion__c, CurrencyIsoCode, Date__c, Fiscal_Quarter__c, Fiscal_Year__c, CreatedDate, CreatedById, Sales_Price__c, Quantity__c, Amount__c, Opportunity__c, Part__c, Won_Date__c, Process_Status__c, Part_Confidence__c,Opportunity__r.Days_since_last_user_update__c FROM Opportunity_Forecast__c Where Opportunity__c in :map_oppyId_oppyStage.keySet()]){
                        
                        //Define Forecast Snapshot record for each Oppy Forecast record
                        Forecast_Snapshot__c fcSnapCreate = new Forecast_Snapshot__c();
                        if(oppyFC.Opportunity__c != null && oppyFC.Part__c != null){
                            fcSnapCreate.RecordTypeId = fcSnapPartRecordTypeId;
                            fcSnapCreate.Part__c = oppyFC.Part__c;
                        }
                        else{
                            fcSnapCreate.RecordTypeId = fcSnapOppyRecordTypeId;
                        }
                        fcSnapCreate.Quantity__c = oppyFC.Quantity__c;
                        fcSnapCreate.CurrencyIsoCode = oppyFC.CurrencyIsoCode;
                        fcSnapCreate.Sales_Price__c = oppyFC.Sales_Price__c;
                        fcSnapCreate.Amount__c = oppyFC.Amount__c;
                        fcSnapCreate.Opportunity__c = oppyFC.Opportunity__c;
                        fcSnapCreate.Forecast_Owner__c = oppyFC.CreatedById;
                        fcSnapCreate.Timestamp__c = oppyFC.CreatedDate;
                        fcSnapCreate.Opportunity_Stage__c = map_oppyId_oppyStage.get(oppyFC.Opportunity__c);
                        fcSnapCreate.Fiscal_Quarter__c = oppyFC.Fiscal_Quarter__c;
                        fcSnapCreate.Fiscal_Year__c = oppyFC.Fiscal_Year__c;
                        fcSnapCreate.Won_Date__c = oppyFC.Won_Date__c;
                        fcSnapCreate.Process_Status__c = oppyFC.Process_Status__c;
                        fcSnapCreate.Part_Confidence__c  = oppyFC.Part_Confidence__c;
                        fcSnapCreate.Count_Pipeline__c = oppyFC.Counts_for_IND_Pipeline__c;
                        fcSnapCreate.Count_Conversion__c = oppyFC.Counts_for_IND_Conversion__c;
                        fcSnapCreate.Snapshot_Type__c = 'Won';
                        
                        //added by BYU 2013-02-18:START
                        fcSnapCreate.Days_since_last_user_update__c = oppyFC.Opportunity__r.Days_since_last_user_update__c;                
                        fcSnapCreate.Date__c = oppyFC.Date__c;
                        fcSnapCreate.Fiscal_Year__c = oppyFC.Fiscal_Year__c;
                        fcSnapCreate.Fiscal_Quarter__c = oppyFC.Fiscal_Quarter__c;
                        //added by BYU 2013-02-18:END                
                        //Add defined records to insert list
                        list_fcSnaps2Insert.add(fcSnapCreate);
                    }
                    
                    system.debug('**@@list_fcSnaps2Insert = ' + list_fcSnaps2Insert);
                }
                
                if(!map_oppyId_oppyStage4approval.isEmpty()){
                    //Check if "In Approval" or "Mass-prod" forecast snapshot records already exists for the given Opportunity
                    for(Forecast_Snapshot__c fcSnap : [Select Id, Opportunity_Stage__c, Opportunity__c From Forecast_Snapshot__c Where Snapshot_Type__c = 'Approval' and  Opportunity__c in :map_oppyId_oppyStage4approval.keySet()]){
                        //if(fcSnap.Opportunity_Stage__c == map_oppyId_oppyStage4approval.get(fcSnap.Opportunity__c)){
                            //If yes add record to delete list
                            list_fcSnaps2Delete.add(fcSnap);
                        //}
                    }
                    
                    for(Opportunity_Forecast__c oppyFC : [SELECT Id, Counts_for_IND_Pipeline__c, Counts_for_IND_Conversion__c, CurrencyIsoCode, Date__c, Fiscal_Quarter__c, Fiscal_Year__c, CreatedDate, CreatedById, Sales_Price__c, Quantity__c, Amount__c, Opportunity__c, Part__c, Won_Date__c, Process_Status__c, Part_Confidence__c,Opportunity__r.Days_since_last_user_update__c FROM Opportunity_Forecast__c Where Opportunity__c in :map_oppyId_oppyStage4approval.keySet()]){
                        
                        //Define Forecast Snapshot record for each Oppy Forecast record
                        Forecast_Snapshot__c fcSnapCreate = new Forecast_Snapshot__c();
                        if(oppyFC.Opportunity__c != null && oppyFC.Part__c != null){
                            fcSnapCreate.RecordTypeId = fcSnapPartRecordTypeId;
                            fcSnapCreate.Part__c = oppyFC.Part__c;
                        }
                        else{
                            fcSnapCreate.RecordTypeId = fcSnapOppyRecordTypeId;
                        }
                        fcSnapCreate.Quantity__c = oppyFC.Quantity__c;
                        fcSnapCreate.CurrencyIsoCode = oppyFC.CurrencyIsoCode;
                        fcSnapCreate.Sales_Price__c = oppyFC.Sales_Price__c;
                        fcSnapCreate.Amount__c = oppyFC.Amount__c;
                        fcSnapCreate.Opportunity__c = oppyFC.Opportunity__c;
                        fcSnapCreate.Forecast_Owner__c = oppyFC.CreatedById;
                        fcSnapCreate.Timestamp__c = oppyFC.CreatedDate;
                        fcSnapCreate.Opportunity_Stage__c = map_oppyId_oppyStage4approval.get(oppyFC.Opportunity__c);
                        fcSnapCreate.Fiscal_Quarter__c = oppyFC.Fiscal_Quarter__c;
                        fcSnapCreate.Fiscal_Year__c = oppyFC.Fiscal_Year__c;
                        fcSnapCreate.Won_Date__c = oppyFC.Won_Date__c;
                        fcSnapCreate.Process_Status__c = oppyFC.Process_Status__c;
                        fcSnapCreate.Part_Confidence__c  = oppyFC.Part_Confidence__c;
                        fcSnapCreate.Count_Pipeline__c = oppyFC.Counts_for_IND_Pipeline__c;
                        fcSnapCreate.Count_Conversion__c = oppyFC.Counts_for_IND_Conversion__c;
                        fcSnapCreate.Snapshot_Type__c = 'Approval';
                        
                        //added by BYU 2013-02-18:START
                        fcSnapCreate.Days_since_last_user_update__c = oppyFC.Opportunity__r.Days_since_last_user_update__c;                
                        fcSnapCreate.Date__c = oppyFC.Date__c;
                        fcSnapCreate.Fiscal_Year__c = oppyFC.Fiscal_Year__c;
                        fcSnapCreate.Fiscal_Quarter__c = oppyFC.Fiscal_Quarter__c;
                        //added by BYU 2013-02-18:END                
                        //Add defined records to insert list
                        list_fcSnaps2Insert.add(fcSnapCreate);
                    }
                    
                    system.debug('**@@list_fcSnaps2Insert = ' + list_fcSnaps2Insert);
                }
                
                //If delete list contains data --> Delete these records
                if(!list_fcSnaps2Delete.isEmpty()){
                    delete list_fcSnaps2Delete;
                }
                
                //If insert list contains data --> Insert Forecast Snapshot records
                if(!list_fcSnaps2Insert.isEmpty()){
                    insert list_fcSnaps2Insert;
                }
                
            }
        } 
    //}
}