/**
*   util class for implement PMV Opportunity initialization.
*
@author Xiaona Liu
@created 2014-01-23
@version 1.0
@since 27.0 (Force.com ApiVersion)
*
@changelog
* 2014-01-23 Xiaona Liu <xiaona.liu@itbconsult.com>
* - Created
*
* 2014-02-11 Lili Zhao <lili.zhao@itbconsult.com>
* - Created the method of calculateOverallProgressPercent
*/
public  class ClsPMV_Util {
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
    public static boolean hasUpdate = false;
    public static boolean dontChangeStage = false;
    public static boolean isRunningMigration = false;
    public static String runningTriggerName = '';
    public static boolean isRunningBatch = false;
    
    //added by weihang 2014-06-04
    //public static boolean setScore = false;
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////

    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
    
    public static list<PMV_Sales_Stage_Setting__c> getPMVSalesStageSetting(){
        list<PMV_Sales_Stage_Setting__c> list_ssdcs = PMV_Sales_Stage_Setting__c.getall().values();
        return list_ssdcs;
    }
    
/**
    * This method is used to 
    *
    @author Xiaona Liu 
    @created 
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    *
    @param              list of Opportunity
    *
    @return             map,oppyId is key and Percentage is value
    *
    @changelog
    * 2014-01-23 Xiaona Liu <xiaona.liu@itbconsult.com>  
    * - Created   
    *
    * 2014-02-11 Lili Zhao <lili.zhao@itbconsult.com>  
    * - modified   
    */
    public static void initQualifierQuestionForOpp(Map<Id,Opportunity> map_Id_Opps){
        list<Quality_Assessment_Answer__c> list_qaas = new List<Quality_Assessment_Answer__c>();
        // added lili 2014.02.12 begin 
        map<Id, String> map_oppId_buPro = new map<Id, String>();
        set<String> set_oppyStageId = new set<String>();
        map<Id,set<Id>> map_oppId_list_salesProQueAssIds = new Map<Id,set<Id>>();
        // added lili 2014.02.12 end 
        map<Id,Id> map_oppId_salesProQueAssId = new Map<Id,Id>();
        map<string, set<string>> map_PMVType_set_oppyIds = new map<string, set<string>>();
        map<Id, set<string>> map_bpId_set_oppyIds = new map<Id, set<string>>();
        map<Id, set<Id>> map_bpId_set_oppyStageIds = new map<Id, set<Id>>();
        
        for(Opportunity opp:[select Id,RecordType.BusinessProcessId, PMV_Type__c from Opportunity where Id != null and RecordType.BusinessProcessId != null and Id in:map_Id_Opps.keySet() and PMV_Type__c != null]){
            map_oppId_buPro.put(opp.Id, opp.RecordType.BusinessProcessId);// added lili 2014.2.12*/
            if(!map_PMVType_set_oppyIds.containsKey(opp.PMV_Type__c)) map_PMVType_set_oppyIds.put(opp.PMV_Type__c, new set<string>());
            map_PMVType_set_oppyIds.get(opp.PMV_Type__c).add(opp.Id);
            
            if(!map_bpId_set_oppyIds.containsKey(opp.RecordType.BusinessProcessID)) map_bpId_set_oppyIds.put(opp.RecordType.BusinessProcessID, new set<string>());
            map_bpId_set_oppyIds.get(opp.RecordType.BusinessProcessID).add(opp.Id);
            
        }
        
        for(PMV_Stage_Config__c ssc : PMV_Stage_Config__c.getAll().values()){
            if(!map_bpId_set_oppyStageIds.containsKey(ssc.Business_ProcessID__c)) map_bpId_set_oppyStageIds.put(ssc.Business_ProcessID__c, new set<Id>());
            map_bpId_set_oppyStageIds.get(ssc.Business_ProcessID__c).add(ssc.Stage_Id__c);
        }
        
       for(Sales_Process_Question_Assignment__c spqa:[select Id ,BusinessProcess__c, OpportunityStage__c, PMV_Type__c 
                                                       from Sales_Process_Question_Assignment__c 
                                                       where BusinessProcess__c IN :map_bpId_set_oppyIds.keySet() AND PMV_Type__c!=null]){             
            // modified by lili 2014.2.12 end
            if(map_bpId_set_oppyStageIds.containsKey((Id)spqa.BusinessProcess__c) && map_bpId_set_oppyStageIds.get((Id)spqa.BusinessProcess__c).contains(spqa.OpportunityStage__c)){
                for(string oppyId : map_bpId_set_oppyIds.get((Id)spqa.BusinessProcess__c)){
                    for(string PMVType : map_PMVType_set_oppyIds.keySet()){
                        if(spqa.PMV_Type__c != null && spqa.PMV_Type__c.contains(PMVType) && map_PMVType_set_oppyIds.get(PMVType).contains(oppyId)){
                            if(!map_oppId_list_salesProQueAssIds.containsKey((Id)oppyId)) map_oppId_list_salesProQueAssIds.put((Id)oppyId, new set<Id>());
                            map_oppId_list_salesProQueAssIds.get((Id)oppyId).add(spqa.Id);
                        }
                    }
                }
            }
        }
        if(!map_oppId_list_salesProQueAssIds.isEmpty()){
            for(Id oppId:map_oppId_list_salesProQueAssIds.keySet()){
                for(Id salesProQueAssId : map_oppId_list_salesProQueAssIds.get(oppId)) {
                    Quality_Assessment_Answer__c qaa = new Quality_Assessment_Answer__c();
                    qaa.Opportunity__c = oppId;
                    //qaa.Sales_Process_Question_Assignment__c = map_oppId_salesProQueAssId.get(oppId);
                    qaa.Sales_Process_Question_Assignment__c = salesProQueAssId;
                    qaa.Active__c = true;
                    qaa.Comment_Long__c = null;
                    qaa.Status__c = 'No';
                    list_qaas.add(qaa);
                }
                               
            }
        }
        if(!list_qaas.isEmpty()) insert list_qaas;
    }
    
     /**
    * This method is used to get all recordType Id for PMV
    *
    @author Jinbo Shan
    @created 2014-03-03
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @return              set<Id>
    *
    @changelog
    * 2014-03-03 Jinbo Shan <jinbo.shan@itbconsult.com>  
    * - Created  
    */  
    public static set<Id> getAllPMVRecordtypes(){
        set<Id> set_rts = new set<Id>();
        
        for(Opportunity_Record_Type_Groups__c setting : Opportunity_Record_Type_Groups__c.getAll().values()) {
            if(setting.Active__c == true && setting.RecordTypeID__c != null && setting.Group__c == 'PMV') {
                set_rts.add((Id)setting.RecordTypeID__c);
            }
        }
        
        return set_rts;
    }
    
    /**
    * This method is used to calculate OpptunityStage
    *
    @author Jinbo Shan
    @created 2014-02-11
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param              list of Quality_Assessment_Answer__c
    *
    @return             OpportunityStage
    *
    @changelog
    * 2014-02-11 Jinbo Shan <jinbo.shan@itbconsult.com>  
    * - Created  
    */ 
    public static map<string, string> calculateOppyStage(set<Id> set_qaaIds){
        list<PMV_Sales_Stage_Setting__c> list_sc = getPMVSalesStageSetting();
        
        map<string, set<string>> map_PMVType_set_oppyIds = new map<string, set<string>>();
        map<Id, set<string>> map_bpId_set_oppyIds = new map<Id, set<string>>();
        map<Id, string> map_oppyId_PMVType = new map<Id, string>();
        map<Id, Id> map_oppyId_bpId = new map<Id, Id>();
        set<string> set_spqaIds = new set<string>();
        set<string> set_oppyIds = new set<string>();
        map<string, string> map_oppyId_stage = new map<string, string>();
        
        map<string, map<string, set<Quality_Assessment_Answer__c>>> map_oppy_oppyStage_list_qaas = new map<string, map<string, set<Quality_Assessment_Answer__c>>>();
        map<string, set<Id>> map_oppy_list_oppyStage = new map<string, set<Id>>();
        map<string, list<OpportunityStage>> map_oppy_list_oppyStageTemp = new map<string, list<OpportunityStage>>();
        //calculate question rating
        map<string, map<Id, decimal>> map_oppId_osId_allRatingOfStage = new map<string, map<Id, decimal>>();
        
        map<string, map<Id, decimal>> map_oppId_osId_yesRatingPercent = new map<string, map<Id, decimal>>();
        
        for(Quality_Assessment_Answer__c qaa : [SELECT Id, Opportunity__c, Opportunity__r.PMV_Type__c, Opportunity__r.RecordType.BusinessProcessId FROM Quality_Assessment_Answer__c WHERE Id IN:set_qaaIds AND IsDeleted=false AND Active__c = true]){
            
            if(!map_PMVType_set_oppyIds.containsKey(qaa.Opportunity__r.PMV_Type__c)) map_PMVType_set_oppyIds.put(qaa.Opportunity__r.PMV_Type__c, new set<string>());
            map_PMVType_set_oppyIds.get(qaa.Opportunity__r.PMV_Type__c).add(qaa.Opportunity__c);
            
            if(!map_bpId_set_oppyIds.containsKey(qaa.Opportunity__r.RecordType.BusinessProcessId)) map_bpId_set_oppyIds.put(qaa.Opportunity__r.RecordType.BusinessProcessId, new set<string>());
            map_bpId_set_oppyIds.get(qaa.Opportunity__r.RecordType.BusinessProcessId).add(qaa.Opportunity__c);
            
            map_oppyId_PMVType.put(qaa.Opportunity__c, qaa.Opportunity__r.PMV_Type__c);
            
            map_oppyId_bpId.put(qaa.Opportunity__c, qaa.Opportunity__r.RecordType.BusinessProcessId);
            
            set_oppyIds.add(qaa.Opportunity__c);
            
            for(PMV_Stage_Config__c ssc : PMV_Stage_Config__c.getAll().values()){
                if((Id)ssc.Business_ProcessID__c == (Id)qaa.Opportunity__r.RecordType.BusinessProcessId){
                    if(!map_oppy_list_oppyStage.containsKey(qaa.Opportunity__c)) map_oppy_list_oppyStage.put(qaa.Opportunity__c, new set<Id>());
                    map_oppy_list_oppyStage.get(qaa.Opportunity__c).add((Id)ssc.Stage_Id__c);
                }
            }
            
        }
        
        for(Sales_Process_Question_Assignment__c spqa : [SELECT Id, OpportunityStage__c, Rating__c, PMV_Type__c, BusinessProcess__c 
                                                         FROM Sales_Process_Question_Assignment__c 
                                                         WHERE BusinessProcess__c IN :map_bpId_set_oppyIds.keySet() 
                                                         AND IsDeleted=false]){
            decimal rating;
            if(spqa.Rating__c == null){
                rating=0;
            }else{
                rating=spqa.Rating__c;
            }
            set_spqaIds.add(spqa.Id);
            for(string oppyId : map_bpId_set_oppyIds.get(spqa.BusinessProcess__c)){
                for(string PMVType : map_PMVType_set_oppyIds.keySet()){
                    if(spqa.PMV_Type__c != null && spqa.PMV_Type__c.contains(PMVType) && map_PMVType_set_oppyIds.get(PMVType).contains(oppyId)){
                        
                        if(!map_oppId_osId_allRatingOfStage.containsKey(oppyId)) map_oppId_osId_allRatingOfStage.put(oppyId,  new map<Id, decimal>());
                        if(!map_oppId_osId_allRatingOfStage.get(oppyId).containsKey(spqa.OpportunityStage__c)){
                            map_oppId_osId_allRatingOfStage.get(oppyId).put(spqa.OpportunityStage__c, rating);
                        }else{
                            decimal ratingTemp = map_oppId_osId_allRatingOfStage.get(oppyId).get(spqa.OpportunityStage__c);
                            ratingTemp += rating;
                            map_oppId_osId_allRatingOfStage.get(oppyId).put(spqa.OpportunityStage__c, ratingTemp);
                        }
                        
                    }
                }
            }
        }
        
        for(Quality_Assessment_Answer__c qaa : [SELECT Id, Opportunity__c, Status__c, Sales_Process_Question_Assignment__r.OpportunityStage__c, Sales_Process_Question_Assignment__r.Rating__c FROM Quality_Assessment_Answer__c WHERE Sales_Process_Question_Assignment__c IN :set_spqaIds AND Opportunity__c IN :set_oppyIds AND IsDeleted=false AND Active__c = true]){
            if(!map_oppy_oppyStage_list_qaas.containsKey(qaa.Opportunity__c)) map_oppy_oppyStage_list_qaas.put(qaa.Opportunity__c, new map<string, set<Quality_Assessment_Answer__c>>());
            if(!map_oppy_oppyStage_list_qaas.get(qaa.Opportunity__c).containsKey(qaa.Sales_Process_Question_Assignment__r.OpportunityStage__c)) map_oppy_oppyStage_list_qaas.get(qaa.Opportunity__c).put(qaa.Sales_Process_Question_Assignment__r.OpportunityStage__c, new set<Quality_Assessment_Answer__c>());
            map_oppy_oppyStage_list_qaas.get(qaa.Opportunity__c).get(qaa.Sales_Process_Question_Assignment__r.OpportunityStage__c).add(qaa);
        }
        //get all active OpportunityStage
        for(OpportunityStage os : [SELECT Id, MasterLabel FROM OpportunityStage where IsActive=true order by SortOrder]){
            for(string oppId : map_oppy_list_oppyStage.keySet()){
                if(map_oppy_list_oppyStage.get(oppId).contains(os.Id)){
                    if(!map_oppy_list_oppyStageTemp.containsKey(oppId)) map_oppy_list_oppyStageTemp.put(oppId, new list<OpportunityStage>());
                    map_oppy_list_oppyStageTemp.get(oppId).add(os);
                }
            }
        }
        //calculate Opptunity Stage Name
        list<OpportunityStage> list_oss;
        for(string oppyIdTemp : map_oppy_list_oppyStageTemp.keySet()){ 
            list_oss = map_oppy_list_oppyStageTemp.get(oppyIdTemp);
            if(list_oss.size() > 0){
                for(integer i=0; i<list_oss.size(); i++){
                    /*Start Added by Jinbo Shan 2015-05-22 when there is no answer*/
                    if (!map_oppy_oppyStage_list_qaas.containsKey(oppyIdTemp)) {
                        if(!map_oppId_osId_yesRatingPercent.containsKey(oppyIdTemp)) map_oppId_osId_yesRatingPercent.put(oppyIdTemp, new map<Id, decimal>());
                        if(!map_oppId_osId_yesRatingPercent.get(oppyIdTemp).containsKey(list_oss.get(i).Id)) map_oppId_osId_yesRatingPercent.get(oppyIdTemp).put(list_oss.get(i).Id, 0);
                    } else {
                    /*End Added by Jinbo Shan 2015-05-22 when there is no answer*/
                        if(!map_oppy_oppyStage_list_qaas.get(oppyIdTemp).containsKey(list_oss.get(i).Id)){
                            if(!map_oppId_osId_yesRatingPercent.containsKey(oppyIdTemp)) map_oppId_osId_yesRatingPercent.put(oppyIdTemp, new map<Id, decimal>());
                            if(!map_oppId_osId_yesRatingPercent.get(oppyIdTemp).containsKey(list_oss.get(i).Id)) map_oppId_osId_yesRatingPercent.get(oppyIdTemp).put(list_oss.get(i).Id, 0);
                        }else{
                            decimal statusIsYes=0;
                            
                            for(Quality_Assessment_Answer__c qaaTemp : map_oppy_oppyStage_list_qaas.get(oppyIdTemp).get(list_oss.get(i).Id)){
                                decimal rating;
                                if(qaaTemp.Sales_Process_Question_Assignment__r.Rating__c == null){
                                    rating=0;
                                }else{
                                    rating=qaaTemp.Sales_Process_Question_Assignment__r.Rating__c;
                                }
                                if(qaaTemp.Status__c=='Yes'){
                                    statusIsYes+=rating;
                                }
                            }
                            
                            if (map_oppId_osId_allRatingOfStage.containsKey(oppyIdTemp) && map_oppId_osId_allRatingOfStage.get(oppyIdTemp).containsKey(list_oss.get(i).Id)) {//Added by Jinbo Shan 2015-05-22 when there is no answer
                            
                                if(map_oppId_osId_allRatingOfStage.get(oppyIdTemp).get(list_oss.get(i).Id)!=0 && map_oppId_osId_allRatingOfStage.get(oppyIdTemp).get(list_oss.get(i).Id)!=null){
                                    if(!map_oppId_osId_yesRatingPercent.containsKey(oppyIdTemp)) map_oppId_osId_yesRatingPercent.put(oppyIdTemp, new map<Id, decimal>());
                                    if(!map_oppId_osId_yesRatingPercent.get(oppyIdTemp).containsKey(list_oss.get(i).Id)) map_oppId_osId_yesRatingPercent.get(oppyIdTemp).put(list_oss.get(i).Id, statusIsYes/map_oppId_osId_allRatingOfStage.get(oppyIdTemp).get(list_oss.get(i).Id)*100);
                                }else{
                                    if(!map_oppId_osId_yesRatingPercent.containsKey(oppyIdTemp)) map_oppId_osId_yesRatingPercent.put(oppyIdTemp, new map<Id, decimal>());
                                    if(!map_oppId_osId_yesRatingPercent.get(oppyIdTemp).containsKey(list_oss.get(i).Id)) map_oppId_osId_yesRatingPercent.get(oppyIdTemp).put(list_oss.get(i).Id, 100);
                                }
                                
                            } 
                            /*Start Added by Jinbo Shan 2015-05-22 when there is no answer*/
                            else {
                                if(!map_oppId_osId_yesRatingPercent.containsKey(oppyIdTemp)) map_oppId_osId_yesRatingPercent.put(oppyIdTemp, new map<Id, decimal>());
                                if(!map_oppId_osId_yesRatingPercent.get(oppyIdTemp).containsKey(list_oss.get(i).Id)) map_oppId_osId_yesRatingPercent.get(oppyIdTemp).put(list_oss.get(i).Id, 0);
                            }
                            /*End Added by Jinbo Shan 2015-05-22 when there is no answer*/
                        }
                    }
                }
            }
        }
        
        boolean hasChanged = false;
        for(string oppyIdTemp : map_oppy_list_oppyStageTemp.keySet()){
            list_oss = map_oppy_list_oppyStageTemp.get(oppyIdTemp);
            
            for(integer i=0; i<list_oss.size(); i++){
                for(PMV_Sales_Stage_Setting__c sst : list_sc){
                    if(sst.PMV_Type__c == map_oppyId_PMVType.get(oppyIdTemp) && map_oppyId_bpId.get(oppyIdTemp) == (Id)sst.Sales_Process_ID__c && sst.Sales_Stage__c == list_oss.get(i).MasterLabel){
                        if(map_oppId_osId_yesRatingPercent.get(oppyIdTemp).get(list_oss.get(i).Id) < sst.Completion_Threshold__c){
                            if(!map_oppyId_stage.containsKey(oppyIdTemp) || hasChanged){
                                map_oppyId_stage.put(oppyIdTemp, list_oss.get(i).MasterLabel);
                                hasChanged = false;
                            }
                        }else if(sst.Priority_Stage__c && map_oppyId_stage.containsKey(oppyIdTemp)){
                            if(i==list_oss.size()-1){
                                map_oppyId_stage.put(oppyIdTemp, list_oss.get(i).MasterLabel);
                            }else{
                                map_oppyId_stage.put(oppyIdTemp, list_oss.get(i+1).MasterLabel);
                            }
                            hasChanged = true;
                        }else if(i==list_oss.size()-1){
                            if(!map_oppyId_stage.containsKey(oppyIdTemp)){
                                map_oppyId_stage.put(oppyIdTemp, list_oss.get(i).MasterLabel);
                            }
                        }
                    }
                }
                
            }
        }
        
        for(string oppyIdTemp : map_oppy_list_oppyStageTemp.keySet()) {
            if (!map_oppyId_stage.containsKey(oppyIdTemp)) {
                map_oppyId_stage.put(oppyIdTemp, list_oss.get(0).MasterLabel);
            }
        }
        
        return map_oppyId_stage;
    }
    
    /**
    * This method is used to get deal size by custom setting 
    *
    @author Jinbo Shan
    @created 2014-02-18
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param              amount
    *
    @return             string color
    *
    @changelog
    * 2014-02-18 Jinbo Shan <jinbo.shan@itbconsult.com>  
    * - Created  
    */ 
    public static string getDealSizeColor(decimal amount, string PMVType, string bpId){
        string color;
        for(PMV_Sales_Process_Settings__c ssps : PMV_Sales_Process_Settings__c.getAll().values()){
            if(ssps.PMV_Type__c == PMVType && (Id)ssps.Sales_Process_ID__c == bpId){
                if(amount <= ssps.Deal_Size_Min__c){
                    color = 'size-1';
                }else if(amount > ssps.Deal_Size_Max__c){
                    color = 'size-3';
                }else{
                    color = 'size-2';
                }
            }
        }
        
        return color;
    }
    
    /**
    * This method is used to get ProjectClosedDate for Opportunity
    *
    @author Jinbo Shan
    @created 2014-02-18
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param              amount
    *
    @return             string color
    *
    @changelog
    * 2014-02-18 Jinbo Shan <jinbo.shan@itbconsult.com>  
    * - Created  
    */ 
    public static void getProjectClosedDateForOppy(set<Opportunity> set_oppy){
 
        date currentDate=system.today();
        
        set<string> set_oppyStages = new set<string>();
        map<string, set<Id>> map_oppyId_set_osIds = new map<string, set<Id>>();
        map<Opportunity, list<OpportunityStage>> map_oppy_list_oss = new map<Opportunity, list<OpportunityStage>>();
        map<string, Opportunity> map_oppyId_oppy = new map<string, Opportunity>();
        
        map<string, string> map_oppyId_stageName = new map<string, string>();
        map<string, integer> map_oppId_stageLevel = new map<string, integer>();
        
        map<Id, Id> map_rtId_bpId = new map<Id, Id>();
        
        for(RecordType rt : [SELECT Id, BusinessProcessId FROM RecordType WHERE Id IN :getAllPMVRecordtypes()]){
            map_rtId_bpId.put(rt.Id, rt.BusinessProcessId);
        }
        
        for(Opportunity oppy : set_oppy){
            map_oppyId_oppy.put(oppy.Id, oppy);
            map_oppyId_stageName.put(oppy.Id, oppy.StageName);
            for(PMV_Stage_Config__c ssc : PMV_Stage_Config__c.getAll().values()){
                if((Id)ssc.Business_ProcessID__c == map_rtId_bpId.get(oppy.RecordTypeId)){
                    if(!map_oppyId_set_osIds.containsKey(oppy.Id)) map_oppyId_set_osIds.put(oppy.Id, new set<Id>());
                    map_oppyId_set_osIds.get(oppy.Id).add((Id)ssc.Stage_Id__c);
                    set_oppyStages.add(ssc.Stage_Id__c);
                }
            }
        } 
      
        for(OpportunityStage os : [select Id, MasterLabel, SortOrder 
                                   from OpportunityStage 
                                   where IsActive=true 
                                   and MasterLabel IN:map_oppyId_stageName.values() 
                                   order by SortOrder]){
            for(string oppyId : map_oppyId_stageName.keySet()){
                
                if(map_oppyId_stageName.get(oppyId) == os.MasterLabel){
                    if(os.SortOrder != null){
                        map_oppId_stageLevel.put(oppyId, os.SortOrder);
                    }else{
                        map_oppId_stageLevel.put(oppyId, 0);
                    }
                }
                
            }
        }
        
        for(OpportunityStage os : [select Id, SortOrder, MasterLabel 
                                   from OpportunityStage 
                                   where IsActive=true 
                                   and Id IN:set_oppyStages 
                                   order by SortOrder]){
            for(string oppyId : map_oppyId_set_osIds.keySet()){
                
                if(map_oppyId_set_osIds.get(oppyId).contains(os.Id) && os.SortOrder>=map_oppId_stageLevel.get(oppyId)){
                    if(!map_oppy_list_oss.containsKey(map_oppyId_oppy.get(oppyId))) map_oppy_list_oss.put(map_oppyId_oppy.get(oppyId), new list<OpportunityStage>());
                    map_oppy_list_oss.get(map_oppyId_oppy.get(oppyId)).add(os);
                }
                
            }
        }
        for(Opportunity oppTemp : map_oppy_list_oss.keySet()){
            decimal nextPhases=0;
            decimal currentPhase=0;
            for(OpportunityStage osTemp : map_oppy_list_oss.get(oppTemp)){
                for(PMV_Sales_Stage_Setting__c ssdc : getPMVSalesStageSetting()){
                    if(map_oppId_stageLevel.get(oppTemp.Id) == osTemp.SortOrder){
                        if(ssdc.PMV_Type__c == oppTemp.PMV_Type__c && ssdc.Sales_Stage__c==osTemp.MasterLabel && (Id)ssdc.Sales_Process_ID__c == map_rtId_bpId.get(oppTemp.RecordTypeId) && ssdc.Active__c){
                            if(ssdc.Average_Duration__c != null){
                                currentPhase = ssdc.Average_Duration__c;
                            }
                        }
                    }else{
                        if(ssdc.PMV_Type__c == oppTemp.PMV_Type__c && ssdc.Sales_Stage__c==osTemp.MasterLabel && (Id)ssdc.Sales_Process_ID__c == map_rtId_bpId.get(oppTemp.RecordTypeId) && ssdc.Active__c){
                            if(ssdc.Average_Duration__c != null){
                                nextPhases += ssdc.Average_Duration__c;
                            }
                        }
                    }
                }
            }
            decimal temp = currentPhase;
            decimal holdDays = 0;
            if(oppTemp.On_Hold_Days__c != null){
                holdDays = oppTemp.On_Hold_Days__c;
            }
            if(temp>=0){
                //2014-03-03 commented out by yuanyuan zhang
                //oppTemp.Projected_Close_Date__c = currentDate+(nextPhases+temp).intValue();
                //2014-03-03 added by yuanyuan zhang for on hold
                //oppTemp.Projected_Close_Date__c = currentDate+(nextPhases+temp).intValue() + Integer.valueOf(holdDays);
                oppTemp.Projected_Close_Date__c = currentDate+(nextPhases+temp).intValue() + Integer.valueOf(holdDays);
                oppTemp.Stage_Entered__c = currentDate;
            }else{
                //2014-03-03 commented out by yuanyuan zhang
                //oppTemp.Projected_Close_Date__c = currentDate+(nextPhases).intValue();
                //2014-03-03 added by yuanyuan zhang for on hold
                //oppTemp.Projected_Close_Date__c = currentDate+(nextPhases).intValue() + Integer.valueOf(holdDays);
                oppTemp.Projected_Close_Date__c = currentDate+(nextPhases).intValue() + Integer.valueOf(holdDays);
                oppTemp.Stage_Entered__c = currentDate;
            }
        }
    }
    
    /**
    * This method is used to upadte Oppy Part's Confidence and Process Status for Oppy StageName being Won
    *
    @author Jinbo Shan
    @created 2014-03-03
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    @param              set oppyId
    *
    *
    @changelog
    * 2014-03-03 Jinbo Shan <jinbo.shan@itbconsult.com>  
    * - Created  
    */ 
    
    public static void updateOppyStageForStage(set<Id> set_oppyId){
        hasUpdate = true;
        list<Opportunity_Part__c> list_op4update = new list<Opportunity_Part__c>();
        
        for(Opportunity_Part__c oppyPart : [SELECT Id, Status__c, Process_Status__c, Opportunity__r.StageName, 
                                            Opportunity__r.RecordType.BusinessProcessId, Opportunity__r.PMV_Type__c 
                                            FROM Opportunity_Part__c 
                                            WHERE Opportunity__c IN :set_oppyId 
                                            AND (Status__c = 'Weak' 
                                            OR Status__c = '50/50' 
                                            OR Status__c = 'Likely' 
                                            OR Status__c = 'Commit' 
                                            OR Status__c = 'Won'
                                            OR Status__c = 'On Hold')]){
            for(PMV_Sales_Stage_Setting__c ssdc : getPMVSalesStageSetting()){
                if(ssdc.Sales_Stage__c == oppyPart.Opportunity__r.StageName && ssdc.Active__c && (Id)ssdc.Sales_Process_ID__c == oppyPart.Opportunity__r.RecordType.BusinessProcessId && ssdc.PMV_Type__c == oppyPart.Opportunity__r.PMV_Type__c){
                    oppyPart.Status__c = ssdc.Opportunity_Parts_Confidence__c;
                    oppyPart.Process_Status__c = ssdc.Opportunity_Parts_Process_Status__c;
                    list_op4update.add(oppyPart);
                }
                
            }
        }
        
        if(list_op4update.size()>0){
            update list_op4update;
        }
    }
    
    public static void setSalesProcessName(set<Opportunity> set_oppIds4salesName){
        map<Id, string> map_bpId_bpName = new map<Id, string>();
        map<Id, string> map_rtId_bpName = new map<Id, string>();
        for(BusinessProcess bp : [SELECT Id, Name FROM BusinessProcess WHERE IsActive = true]){
            map_bpId_bpName.put(bp.id, bp.Name);
        }
        
        //-- Changed by Rahul(28 Nov 2017)--optimize code--comment if condition and moved to SOQL where clause--Start--//
        for(RecordType rt : [SELECT Id, BusinessProcessId FROM RecordType WHERE Id IN :getAllPMVRecordtypes() And BusinessProcessId in: map_bpId_bpName.keySet()]){
            map_rtId_bpName.put(rt.id, map_bpId_bpName.get(rt.BusinessProcessId));
        }
        //-- Changed by Rahul(28 Nov 2017)--optimize code--comment if condition and moved to SOQL where clause--End--//
        for(Opportunity oppy : set_oppIds4salesName){
            if(map_rtId_bpName.containsKey(oppy.RecordTypeId)){
                oppy.Sales_Processes_Name__c = map_rtId_bpName.get(oppy.RecordTypeId);
            }
        }
    }
    
    public static map<Id, Opportunity> calculateOppyWhenAnswerChanged(set<Id> set_oppyId){
        map<Id, Opportunity> map_oppyId_oppy = new map<Id, Opportunity>();
        map<Id, Opportunity> map_oppyId_oppyTemp = new map<Id, Opportunity>();
        map<Id, set<Id>> map_oppyId_set_osIds = new map<Id, set<Id>>();
        map<Id, map<Id, decimal>> map_oppyId_osId_thres = new map<Id, map<Id, decimal>>();
        map<Id, map<Id, decimal>> map_oppyId_osId_yesRating = new map<Id, map<Id, decimal>>();
        map<Id, map<Id, decimal>> map_oppyId_osId_allRating = new map<Id, map<Id, decimal>>();
        map<Id, map<Id, decimal>> map_oppyId_osId_progress = new map<Id, map<Id, decimal>>();
        map<string, Id> map_oppyStage_oppyStageId = new map<string, Id>();
        set<Opportunity> set_oppys = new set<Opportunity>();
        list<Id> list_stages = new list<Id>();
        map<Id, decimal> map_oppyId_overallProgress = new map<Id, decimal>();
        map<Id, string> map_oppyId_allStageColor = new map<Id, string>();
        
        for(Opportunity opportunity : [SELECT Id, RecordType.BusinessProcessId, PMV_Type__c FROM Opportunity WHERE Id IN :set_oppyId]){
            set_oppys.add(opportunity);
            map_oppyId_oppyTemp.put(opportunity.Id, opportunity);
        }
        
        for(OpportunityStage oppyStage : [SELECT Id, MasterLabel FROM OpportunityStage WHERE IsActive=true order by SortOrder]){
            map_oppyStage_oppyStageId.put(oppyStage.MasterLabel, oppyStage.Id);
            list_stages.add(oppyStage.Id);
        }
        
        for(Opportunity opportunity : set_oppys){
            for(PMV_Stage_Config__c ssc : PMV_Stage_Config__c.getAll().values()){
                if((Id)ssc.Business_ProcessID__c == opportunity.RecordType.BusinessProcessId && ssc.Stage_Id__c != null){
                    if(!map_oppyId_set_osIds.containsKey(opportunity.Id)) map_oppyId_set_osIds.put(opportunity.Id, new set<Id>());
                    map_oppyId_set_osIds.get(opportunity.Id).add((Id)ssc.Stage_Id__c);
                }
            }
            for(PMV_Sales_Stage_Setting__c ssdc : getPMVSalesStageSetting()){
                if(ssdc.PMV_Type__c == opportunity.PMV_Type__c && (Id)ssdc.Sales_Process_ID__c == opportunity.RecordType.BusinessProcessId && ssdc.Active__c && map_oppyStage_oppyStageId.containsKey(ssdc.Sales_Stage__c)){
                    if(!map_oppyId_osId_thres.containsKey(opportunity.Id)) map_oppyId_osId_thres.put(opportunity.Id, new map<Id, decimal>());
                    if(!map_oppyId_osId_thres.get(opportunity.Id).containsKey(map_oppyStage_oppyStageId.get(ssdc.Sales_Stage__c))){
                        if(ssdc.Completion_Threshold__c != null){
                            map_oppyId_osId_thres.get(opportunity.Id).put(map_oppyStage_oppyStageId.get(ssdc.Sales_Stage__c), ssdc.Completion_Threshold__c);
                        }else{
                            map_oppyId_osId_thres.get(opportunity.Id).put(map_oppyStage_oppyStageId.get(ssdc.Sales_Stage__c), 0);
                        }
                    }
                }
            }
        }
        
        for(Sales_Process_Question_Assignment__c spqa : [SELECT Id, PMV_Type__c, BusinessProcess__c, OpportunityStage__c, Rating__c 
                                                    FROM Sales_Process_Question_Assignment__c 
                                                    where IsDeleted=false]){
            decimal rating = 0;                     
            if(spqa.Rating__c != null){
                rating = spqa.Rating__c;
            }                                           
            
            for(string oppyId : map_oppyId_set_osIds.keySet()){
                if(map_oppyId_set_osIds.get(oppyId).contains(spqa.OpportunityStage__c) && map_oppyId_oppyTemp.get(oppyId).RecordType.BusinessProcessId == spqa.BusinessProcess__c && spqa.PMV_Type__c != null && spqa.PMV_Type__c.contains(map_oppyId_oppyTemp.get(oppyId).PMV_Type__c)){
                    if(!map_oppyId_osId_allRating.containsKey(oppyId)) map_oppyId_osId_allRating.put(oppyId, new map<Id, decimal>());
                    if(!map_oppyId_osId_allRating.get(oppyId).containsKey(spqa.OpportunityStage__c)) map_oppyId_osId_allRating.get(oppyId).put(spqa.OpportunityStage__c, 0);
                    decimal allTemp = map_oppyId_osId_allRating.get(oppyId).get(spqa.OpportunityStage__c);
                    map_oppyId_osId_allRating.get(oppyId).put(spqa.OpportunityStage__c, allTemp + rating);
                }
            }
        }
        
        for(Quality_Assessment_Answer__c answer : [SELECT Id, Status__c, 
                                                   Sales_Process_Question_Assignment__r.PMV_Type__c, 
                                                   Sales_Process_Question_Assignment__r.Rating__c, 
                                                   Sales_Process_Question_Assignment__r.BusinessProcess__c, 
                                                   Sales_Process_Question_Assignment__r.OpportunityStage__c, 
                                                   Opportunity__r.PMV_Type__c, 
                                                   Opportunity__r.RecordType.BusinessProcessId,
                                                   Opportunity__c  
                                                   FROM Quality_Assessment_Answer__c 
                                                   WHERE Opportunity__c IN : set_oppyId AND IsDeleted=false AND Active__c = true AND Sales_Process_Question_Assignment__r.IsDeleted=false]){
            decimal rating = 0;                     
            if(answer.Sales_Process_Question_Assignment__r.Rating__c != null){
                rating = answer.Sales_Process_Question_Assignment__r.Rating__c;
            }
            if(answer.Opportunity__r.PMV_Type__c != null && answer.Sales_Process_Question_Assignment__r.PMV_Type__c.contains(answer.Opportunity__r.PMV_Type__c) &&
                    answer.Opportunity__r.RecordType.BusinessProcessId == answer.Sales_Process_Question_Assignment__r.BusinessProcess__c && 
                    map_oppyId_set_osIds.containsKey(answer.Opportunity__c) && 
                    map_oppyId_set_osIds.get(answer.Opportunity__c).contains(answer.Sales_Process_Question_Assignment__r.OpportunityStage__c)){
                
                if(answer.Status__c == 'Yes') {
                    if(!map_oppyId_osId_yesRating.containsKey(answer.Opportunity__c)) map_oppyId_osId_yesRating.put(answer.Opportunity__c, new map<Id, decimal>());
                    if(!map_oppyId_osId_yesRating.get(answer.Opportunity__c).containsKey(answer.Sales_Process_Question_Assignment__r.OpportunityStage__c)) map_oppyId_osId_yesRating.get(answer.Opportunity__c).put(answer.Sales_Process_Question_Assignment__r.OpportunityStage__c, 0);
                    decimal yesTemp = map_oppyId_osId_yesRating.get(answer.Opportunity__c).get(answer.Sales_Process_Question_Assignment__r.OpportunityStage__c);
                    map_oppyId_osId_yesRating.get(answer.Opportunity__c).put(answer.Sales_Process_Question_Assignment__r.OpportunityStage__c, yesTemp + rating);
                }
            }
        }
        
        for(Id oppyId : map_oppyId_osId_allRating.keySet()){
            if(!map_oppyId_osId_progress.containsKey(oppyId)) map_oppyId_osId_progress.put(oppyId, new map<Id, decimal>());
            decimal yesTemp = 0;
            decimal allTemp = 0;
            for(Id osId : map_oppyId_osId_allRating.get(oppyId).keySet()){
                if(map_oppyId_osId_allRating.get(oppyId).get(osId) != 0){
                    if(map_oppyId_osId_yesRating.containsKey(oppyId) && map_oppyId_osId_yesRating.get(oppyId).containsKey(osId)){
                        yesTemp += map_oppyId_osId_yesRating.get(oppyId).get(osId);
                        map_oppyId_osId_progress.get(oppyId).put(osId, map_oppyId_osId_yesRating.get(oppyId).get(osId)/map_oppyId_osId_allRating.get(oppyId).get(osId)*100);
                    }else{
                        map_oppyId_osId_progress.get(oppyId).put(osId, 0);
                    }
                }else{
                    map_oppyId_osId_progress.get(oppyId).put(osId, 100);
                }
                allTemp += map_oppyId_osId_allRating.get(oppyId).get(osId);
            }
            if(allTemp != 0) {
                map_oppyId_overallProgress.put(oppyId, yesTemp/allTemp * 100);
            }else {
                map_oppyId_overallProgress.put(oppyId, 100);
            }
        }
        
        for(Id oppyId : map_oppyId_set_osIds.keySet()){
            string color = '';
            for(Id stageId : list_stages){
                if(map_oppyId_set_osIds.get(oppyId).contains(stageId)){
                    if(map_oppyId_osId_progress.containsKey(oppyId) && map_oppyId_osId_progress.get(oppyId).containsKey(stageId)){
                        if(map_oppyId_osId_progress.get(oppyId).get(stageId) == 100){
                            color += 'G_';
                        }else{
                            if(map_oppyId_osId_thres.containsKey(oppyId) && map_oppyId_osId_thres.get(oppyId).containsKey(stageId)) {
                                if(map_oppyId_osId_progress.get(oppyId).get(stageId) >= map_oppyId_osId_thres.get(oppyId).get(stageId)){
                                    color += 'Y_';
                                }else{
                                    color += 'R_';
                                }
                            }else {
                                color += 'G_';
                            }
                        }
                    }else{
                        color += 'G_';
                    }
                }
            }
            if(color != '' && color.contains('_')){
                color = color.subString(0, color.length()-1);
                map_oppyId_allStageColor.put(oppyId, color);
            }
        }
        
        boolean hasChange = false;
        for(Opportunity opportunity : [SELECT Id, Overall_Process__c, All_Stage_Color__c FROM Opportunity WHERE Id IN :set_oppyId]){
            if(map_oppyId_allStageColor.containsKey(opportunity.Id)){
                hasChange = true;
                opportunity.All_Stage_Color__c = map_oppyId_allStageColor.get(opportunity.Id);
            }
            if(map_oppyId_overallProgress.containsKey(opportunity.Id)){
                hasChange = true;
                opportunity.Overall_Process__c = map_oppyId_overallProgress.get(opportunity.Id);
            }
            if(hasChange){
                map_oppyId_oppy.put(opportunity.Id, opportunity);
            }
        }
        
        return map_oppyId_oppy;
    }
    
    /**
    * Recalculate oppy answer and questions, set all answers inactive.
    *
    @author Yuanyuan Zhang
    @created 2014-03-11
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param set_oppyId    set<Id>    opportunity id
    *
    *
    @changelog
    * 2014-03-11 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>  
    * - Created  
    */ 
    public static void oppyRTPMV2NonePMV(set<Id> set_oppyId){
        List<Quality_Assessment_Answer__c> list2update = new List<Quality_Assessment_Answer__c>();
        for(Quality_Assessment_Answer__c qaa : [SELECT Id, Active__c FROM Quality_Assessment_Answer__c WHERE opportunity__c IN :set_oppyId AND Active__c = true]){
            qaa.Active__c = false;
            list2update.add(qaa);
        }
        if(list2update.size() > 0) update list2update;
    }
    /**
    * Recalculate oppy answer and questions, if there is no answers related to oppy, then create answers for each question.
      If there are answers related to oppy, estimate wether these answers are reuseable, if yes ,set it active and reparent.
    *
    @author Yuanyuan Zhang
    @created 2014-03-11
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param set_oppyId    set<Id>    opportunity id
    *
    *
    @changelog
    * 2014-03-11 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>  
    * - Created  
    */ 
    public static void oppyRTPMV2PMV(set<Id> set_oppyId){// map<Id, Opportunity> map_oppyId_oldOppy
        oppyRTNonePMV2PMV(set_oppyId);
    }
    
    /**
    * Recalculate oppy answer and questions, if there is no answers related to oppy, then create answers for each question.
      If there are answers related to oppy, estimate wether these answers are reuseable, if yes ,set it active and reparent.
    *
    @author Yuanyuan Zhang
    @created 2014-03-11
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param set_oppyId    set<Id>    opportunity id
    *
    *
    @changelog
    * 2014-03-11 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>  
    * - Created  
    */ 
    public static void oppyRTNonePMV2PMV(set<Id> set_oppyId){
        map<Id, Id> map_newOppyId_businessProcessId = new map<Id, Id>();
        map<Id, map<Id,Sales_Process_Question_Assignment__c>> map_busniessProcessId_map_assigmentId_spqAssignment = new map<Id, map<Id,Sales_Process_Question_Assignment__c>>();
        map<Id, List<Quality_Assessment_Answer__c>> map_oppyId_List_answers = new map<Id, List<Quality_Assessment_Answer__c>>();
  
        List<Quality_Assessment_Answer__c> list_answer2inactive = new List<Quality_Assessment_Answer__c>();
        List<Quality_Assessment_Answer__c> list_answer2reparent = new List<Quality_Assessment_Answer__c>();
        List<Quality_Assessment_Answer__c> list_answer2create = new List<Quality_Assessment_Answer__c>();
        
        map<Id, String> map_oppyId_PMVType = new map<Id, String>();
        
        for(Opportunity oppy : [SELECT Id, RecordType.BusinessProcessId, PMV_Type__c FROM Opportunity WHERE Id IN:set_oppyId]){//get business process for related oppies
            map_newOppyId_businessProcessId.put(oppy.Id, oppy.RecordType.BusinessProcessId);
            map_oppyId_PMVType.put(oppy.Id, oppy.PMV_Type__c);
        }
        
        for(Quality_Assessment_Answer__c qaa : [select Id, Opportunity__c, Sales_Process_Question_Assignment__c, Active__c ,Sales_Process_Question_Assignment__r.Quality_Assessment_Question__c, Status__c
                                                from Quality_Assessment_Answer__c
                                                WHERE Opportunity__c IN:set_oppyId order by Lastmodifieddate]){//get answer for oppies
            
            if(!map_oppyId_List_answers.containsKey(qaa.Opportunity__c)){
                map_oppyId_List_answers.put(qaa.Opportunity__c, new List<Quality_Assessment_Answer__c>());
            }
            map_oppyId_List_answers.get(qaa.Opportunity__c).add(qaa);
        }
        
        for(Sales_Process_Question_Assignment__c apqa : [select Id, Quality_Assessment_Question__c,  BusinessProcess__c, OpportunityStage__c,PMV_Type__c 
                                                           from Sales_Process_Question_Assignment__c
                                                           where BusinessProcess__c IN: map_newOppyId_businessProcessId.values() AND PMV_Type__c!=null
                                                           ]){//get questions for oppies with new recordtype
            if(!map_busniessProcessId_map_assigmentId_spqAssignment.containsKey(apqa.BusinessProcess__c)){
                map_busniessProcessId_map_assigmentId_spqAssignment.put(apqa.BusinessProcess__c, new map<Id,Sales_Process_Question_Assignment__c>());
            }
            map_busniessProcessId_map_assigmentId_spqAssignment.get(apqa.BusinessProcess__c).put(apqa.Id, apqa);
        }
        map<Id, map<Id, Sales_Process_Question_Assignment__c>> map_oppyId_map_assignmentId_assigment = new map<Id, map<Id, Sales_Process_Question_Assignment__c>>();
        for(Id oppyId : map_newOppyId_businessProcessId.keySet()){
            
            Id businessProcessId = map_newOppyId_businessProcessId.get(oppyId);
            String PMVType = map_oppyId_PMVType.get(oppyId);
            if(map_busniessProcessId_map_assigmentId_spqAssignment.containsKey(businessProcessId)){
                map<Id,Sales_Process_Question_Assignment__c> map_assigmentId_assignment = map_busniessProcessId_map_assigmentId_spqAssignment.get(businessProcessId);
                for(Sales_Process_Question_Assignment__c spqa : map_assigmentId_assignment.values()){
                    String assignmentPMVType = spqa.PMV_Type__c;
                    if(assignmentPMVType.contains(PMVType)){
                        if(!map_oppyId_map_assignmentId_assigment.containsKey(oppyId)){
                            map_oppyId_map_assignmentId_assigment.put(oppyId, new map<Id,Sales_Process_Question_Assignment__c>());
                        }
                        map_oppyId_map_assignmentId_assigment.get(oppyId).put(spqa.Id, spqa);
                    }
                }
            }
        }
        
        if(!map_oppyId_map_assignmentId_assigment.isEmpty()){
            for(Id oppyId : map_oppyId_map_assignmentId_assigment.keySet()){
                map<Id, Sales_Process_Question_Assignment__c> map_newAssignmentId_assignemnt = map_oppyId_map_assignmentId_assigment.get(oppyId);
                if(map_oppyId_List_answers.containsKey(oppyId)){
                    List<Quality_Assessment_Answer__c> list_answers = map_oppyId_List_answers.get(oppyId);
                    for(Sales_Process_Question_Assignment__c spqa : map_newAssignmentId_assignemnt.values()){
                        Boolean questionHasAnswer = false;
                        for(Integer i = 0; i< list_answers.size() ;i++ ){
                            if(list_answers.get(i).Sales_Process_Question_Assignment__r.Quality_Assessment_Question__c == spqa.Quality_Assessment_Question__c){
                                questionHasAnswer = true;
                                if(list_answers.get(i).Status__c == 'In Progress'){
                                    list_answers.get(i).Status__c = 'No';
                                }
                                list_answers.get(i).Active__c = true;
                                list_answers.get(i).Sales_Process_Question_Assignment__c = spqa.Id;
                                list_answer2reparent.add(list_answers.get(i));
                                list_answers.remove(i);
                                break;
                            }
                        }
                        if(!questionHasAnswer){//if question has no answer to use, then create one
                            createQualityAssessmentAnswer(oppyId, spqa.Id, list_answer2create);
                        }
                    }
                    if(list_answers.size() > 0){//if answer is remained, then set it all inactive.
                        for(Quality_Assessment_Answer__c answer : list_answers){
                            answer.Active__c = false;
                            list_answer2inactive.add(answer);
                        }
                    } 
                    
                }
                else{//if don't contains means opportunity has no answer beforce, create answer for all question
                    for(Sales_Process_Question_Assignment__c spqa : map_newAssignmentId_assignemnt.values()){
                        createQualityAssessmentAnswer(oppyId, spqa.Id, list_answer2create);
                    }
                }
                
            }
            
            dontChangeStage = true;
            //set static variable 
            if(list_answer2inactive.size() > 0) update list_answer2inactive;
            if(list_answer2reparent.size() > 0) update list_answer2reparent;
            if(list_answer2create.size() > 0) insert list_answer2create;
            //calculateOppyStage
            dontChangeStage = false;
            recalculateOppyStage(set_oppyId);
        }
        
        
    }
    
    public static void createQualityAssessmentAnswer(Id oppyId, Id assignmentId, List<Quality_Assessment_Answer__c> list_answer2create){
        Quality_Assessment_Answer__c qaa = new Quality_Assessment_Answer__c();
        qaa.Opportunity__c = oppyId;
        qaa.Sales_Process_Question_Assignment__c = assignmentId;
        qaa.Active__c = true;
        qaa.Status__c = 'No';
        list_answer2create.add(qaa);
    }
    /**
    * Recalculate oppy stage with corresponding answers
    *
    @author Yuanyuan Zhang
    @created 2014-03-11
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param set_oppyId    set<Id>    opportunity id
    *
    *
    @changelog
    * 2014-03-11 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>  
    * - Created  
    */ 
    public static void recalculateOppyStage(set<Id> set_oppyId){
        set<Id> set_qaaId = new set<Id>();
        for(Quality_Assessment_Answer__c qaa : [select Id, Opportunity__c, Sales_Process_Question_Assignment__c, Active__c ,Sales_Process_Question_Assignment__r.Quality_Assessment_Question__c
                                                from Quality_Assessment_Answer__c
                                                WHERE Opportunity__c IN:set_oppyId]){
            set_qaaId.add(qaa.Id);
        }
        map<String,String> map_oppyId_stageName = calculateOppyStage(set_qaaId);
        map<Id, Opportunity> map_oppyId_oppy = calculateOppyWhenAnswerChanged(set_oppyId);
        if((map_oppyId_stageName!= null && !map_oppyId_stageName.isEmpty()) || (map_oppyId_oppy != null && map_oppyId_oppy.size()>0)){
            List<Opportunity> list_oppy2update = new List<Opportunity>();
            for(Opportunity oppy : [SELECT Id, StageName, Overall_Process__c, All_Stage_Color__c FROM Opportunity WHERE Id IN:map_oppyId_stageName.keySet() OR Id IN : map_oppyId_oppy.keySet()]){
                boolean shouldUpdate = false;
                if(map_oppyId_stageName != null && map_oppyId_stageName.containsKey(oppy.Id) && oppy.StageName != map_oppyId_stageName.get(oppy.Id)) {
                    oppy.StageName = map_oppyId_stageName.get(oppy.Id);
                    shouldUpdate = true;
                }
                //Overall_Process__c All_Stage_Color__c
                
                if(map_oppyId_oppy != null && map_oppyId_oppy.containsKey(oppy.Id)){
                    if(map_oppyId_oppy.get(oppy.Id).Overall_Process__c != oppy.Overall_Process__c || oppy.All_Stage_Color__c != map_oppyId_oppy.get(oppy.Id).All_Stage_Color__c) {
                        oppy.Overall_Process__c = map_oppyId_oppy.get(oppy.Id).Overall_Process__c;
                        oppy.All_Stage_Color__c = map_oppyId_oppy.get(oppy.Id).All_Stage_Color__c;
                        shouldUpdate = true;
                    }
                }
                //oppy.Last_Modified_Date__c = system.now();
                if(shouldUpdate) {
                    list_oppy2update.add(oppy);
                }
            }
            if(list_oppy2update.size() > 0 ) Database.update(list_oppy2update, false);
        }
    }
    
    
    /**
    * It checks the opportunity owner and set PMV type
    *
    @author Yuanyuan Zhang
    @created 2014-03-11
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param list_newOppy    list<Opportunity>    opportunity from trigger.new
    @param set_ownerId4PMVType     set<Id>     oppy's owner id
    @param set_rts      set<Id>       record type id of PMV oppy
    *
    *
    *
    @return map_ownerId_PMVType   map<Id, string>
    *
    @changelog
    * 2014-03-11 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>  
    * - Created  
    */ 
    public static map<Id, string> setPMVType(list<Opportunity> list_newOppy, set<Id> set_ownerId4PMVType, set<Id> set_rts){
        list<PMV_Sales_Process_Settings__c> list_ssps = PMV_Sales_Process_Settings__c.getAll().values();
        system.debug(list_ssps);
        map<Id, String> map_ownerId_PMVType = new map<Id, String>();
        map<Id, User> map_uId_user = new map<Id, User>();
        map<Id, Id> map_rtId_bpId = new map<Id, Id>();
        if(!set_ownerId4PMVType.isEmpty()){
            for(User u : [select Id, GIBU__c,  Sub_Vertical__c, PMV_Type_Initialization__c from User WHERE Sub_Vertical__c != null AND GIBU__c != null AND Id IN :set_ownerId4PMVType AND PMV_Type_Initialization__c != null]){
                map_uId_user.put(u.Id, u);
            }
            
            for(RecordType rt : [SELECT Id, BusinessProcessId FROM RecordType WHERE Id IN : set_rts]){
                map_rtId_bpId.put(rt.Id, rt.BusinessProcessId);
            }
            
            for(Opportunity oppy : list_newOppy){
                if(map_uId_user.containsKey(oppy.OwnerId)){
                    for(PMV_Sales_Process_Settings__c ssps : list_ssps){
                        if((Id)ssps.Sales_Process_ID__c == map_rtId_bpId.get(oppy.RecordTypeId) && ssps.GIBU__c != null && ssps.GIBU__c.contains(map_uId_user.get(oppy.OwnerId).GIBU__c) && ssps.Subvertical_BU__c != null && ssps.Subvertical_BU__c.contains(map_uId_user.get(oppy.OwnerId).Sub_Vertical__c) && ssps.PMV_Type_Initialization__c != null && ssps.PMV_Type_Initialization__c.contains(map_uId_user.get(oppy.OwnerId).PMV_Type_Initialization__c)){
                            map_ownerId_PMVType.put(oppy.Id, ssps.PMV_Type__c);
                        }
                    }
                }
                
            }
        }
        return map_ownerId_PMVType;
    }
    
    /**
    * This method is used to Opportunity is converted into a Record Type of a PMV Opportunity for the first 
    * time (i.e. it has not been a PMV Opportunity before), then the structures for Decision Criteria have to be 
    * created the same way like when a new PMV Opportunity is created. 
    * Consequently, the Decision Criteria Template Questions have to be created as Decision Criteria questions 
    * and the Answers have to be set to Standard Values (Position: Same).
    *
    @author Lei Tang
    @created 2014-03-11
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param list_opp    list<Opportunity>    need to be add Decision Criteria of the Opportunity
    *
    *
    @changelog
    * 2014-03-11 Lei Tang <lei.tang@itbconsult.com>  
    * - Created  
    */ 
    public static void oppyRTNonPMV2PMVAddDecisionCriteria(list<Opportunity> list_opp){
        
        list<Decision_Criteria__c> list_dcs = new list<Decision_Criteria__c>();
        list<Decision_Criteria_Template__c> list_dcts = new list<Decision_Criteria_Template__c>();
        
        for(Decision_Criteria_Template__c dct : [Select Id,Question_English__c,CurrencyIsoCode from Decision_Criteria_Template__c]){
            list_dcts.add(dct);
        }

        for(Opportunity opp  : list_opp){
            for(Decision_Criteria_Template__c dct : list_dcts){
                Decision_Criteria__c dc = new Decision_Criteria__c();
                dc.Opportunity__c = opp.Id;
                dc.Active__c = false;
                dc.Position__c = '2';
                dc.Question_English__c = dct.Question_English__c;
                dc.CurrencyIsoCode = dct.CurrencyIsoCode;
                dc.Decision_Criteria_Template__c = dct.Id;
                list_dcs.add(dc);
            }
        }
        
        if(list_dcs.size() > 0){
            insert list_dcs;
        }
        
    }
    
    /**
    * it has to be checked if Opportunity Contact Roles have related Key Player Records. 
    * For each Opportunity Contact Role, there should be exactly one entry as Key Player and 
    * each Key Player record should have a Junction Object to Decision Criteria (Key Player Criteria) 
    * with the Priority set to "Unknown".
    *
    @author Lei Tang
    @created 2014-03-11
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param list_opp    list<Opportunity>    need to be add Key Player Criteria of the Opportunity
    *
    *
    @changelog
    * 2014-03-11 Lei Tang <lei.tang@itbconsult.com>  
    * - Created  
    */ 
    public static void oppyRTNonPMV2PMVAddKeyPlayerCriteria(list<Opportunity> list_opp){
        list<Key_Player_Criteria__c>  list_kpcs = new list<Key_Player_Criteria__c>();
        map<string,list<Decision_Criteria__c>> map_oppyId_dcs = new map<string,list<Decision_Criteria__c>>();
        map<string,list<Key_Player__c>> map_oppyId_kps = new map<string,list<Key_Player__c>>();
        set<Id> set_oppyId = new set<Id>();
        
        for(Opportunity oppy : list_opp){
            set_oppyId.add(oppy.Id);
        }
        
        if(set_oppyId.size() > 0){
            for(Key_Player__c kp : [select Id,Opportunity__c,CurrencyIsoCode from Key_Player__c Where Opportunity__c IN :set_oppyId]){
                if(map_oppyId_kps.containsKey(kp.Opportunity__c) ){
                    list<Key_Player__c> temp_list_kp = map_oppyId_kps.get(kp.Opportunity__c);
                    temp_list_kp.add(kp);
                    map_oppyId_kps.put(kp.Opportunity__c,temp_list_kp);
                }else{
                    list<Key_Player__c> list_kps = new list<Key_Player__c>();
                    list_kps.add(kp);
                    map_oppyId_kps.put(kp.Opportunity__c,list_kps);
                }
            }
        }
        
        if(set_oppyId.size() > 0){
            for(Decision_Criteria__c dc : [Select Id,Opportunity__c from Decision_Criteria__c where Opportunity__c IN :set_oppyId]){
                if(map_oppyId_dcs.containsKey(dc.Opportunity__c) ){
                    list<Decision_Criteria__c> temp_list_dc = map_oppyId_dcs.get(dc.Opportunity__c);
                    temp_list_dc.add(dc);
                    map_oppyId_dcs.put(dc.Opportunity__c,temp_list_dc);
                }else{
                    list<Decision_Criteria__c> list_dcs = new list<Decision_Criteria__c>();
                    list_dcs.add(dc);
                    map_oppyId_dcs.put(dc.Opportunity__c,list_dcs);
                }
            }
        }
        
        if(map_oppyId_kps.size() > 0 && map_oppyId_dcs.size() > 0){
            for(Opportunity oppy : list_opp){
                if(map_oppyId_kps.containsKey(oppy.Id) && map_oppyId_dcs.containsKey(oppy.Id)){
                    for(Key_Player__c kp : map_oppyId_kps.get(oppy.Id) ){
                        for(Decision_Criteria__c dc : map_oppyId_dcs.get(oppy.Id)){
                            Key_Player_Criteria__c kpc = new Key_Player_Criteria__c();
                            kpc.Key_Player__c = kp.Id;
                            kpc.Decision_Criteria__c = dc.Id;
                            kpc.Priority__c = '1';
                            kpc.CurrencyIsoCode = kp.CurrencyIsoCode;
                            list_kpcs.add(kpc);
                        }
                    }
                }
            }
        }
        
        if(list_kpcs.size() > 0){
            insert list_kpcs;
        }
    }
    
    /**
    * It checks the opportunity stage. If stage is changed to approvaled/active,then call the method to recalculate the opportunity stage,
    * after the stage is recalculated, update opportunity and opportunity part. If some error is occurred, save the error message in opportunity
    * field Stage_Change_Error_Message__c and create a 
    
     under the opportunity owner.
    *
    @author Yuanyuan Zhang
    @created 2014-03-11
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param set_oppyId    set<Id>    opportunity id
    *
    *
    @changelog
    * 2014-03-11 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>  
    * - Created  
    */ 
    //@future
    public static void recalculateOppyStageFuture(set<Id> set_oppyId){
        set<Id> set_qaaId = new set<Id>();
        for(Quality_Assessment_Answer__c qaa : [select Id, Opportunity__c, Sales_Process_Question_Assignment__c, Active__c ,Sales_Process_Question_Assignment__r.Quality_Assessment_Question__c
                                                from Quality_Assessment_Answer__c
                                                WHERE Opportunity__c IN:set_oppyId]){
            set_qaaId.add(qaa.Id);
        }
        if(!set_qaaId.isEmpty()){
            map<String,String> map_oppyId_stageName = calculateOppyStage(set_qaaId);
            if(map_oppyId_stageName!= null && !map_oppyId_stageName.isEmpty()){
                List<Opportunity> list_oppy2update = new List<Opportunity>();
                for(Opportunity oppy : [SELECT Id, StageName FROM Opportunity WHERE Id IN:map_oppyId_stageName.keySet()]){
                    oppy.StageName = map_oppyId_stageName.containsKey(oppy.Id) ? map_oppyId_stageName.get(oppy.Id) : oppy.StageName;
                    list_oppy2update.add(oppy);
                }
                try{
                    hasUpdate = true;
                    if(list_oppy2update.size() > 0 ) update list_oppy2update;
                    
                    updateOppyStageForStage(set_oppyId);
                    hasUpdate = false;
                }
                catch(Exception ex){
                    //set<Id> set_ownerId = new set<Id>();
                    String message = ex.getMessage();
                    createErrorMessageAndTask(map_oppyId_stageName.keySet(), message);
                }
            }
        }
    }
    
    @future
    public static void createErrorMessageAndTask(set<String> set_oppyId, String message){
        List<Task> list_tasks2insert = new List<Task>(); 
        List<Opportunity> list_oppy2update = new List<Opportunity>();
        for(Opportunity oppy : [SELECT Id, StageName, OwnerId,Name FROM Opportunity WHERE Id IN:set_oppyId]){
            oppy.Stage_Change_Error_Message__c = 'Please have a look at Opportunity ' + oppy.Name + '.\r\n A severe issue was raised.\r\n' +  message;
            list_oppy2update.add(oppy);
            //set_ownerId.add(oppy.OwnerId);
        }
        update list_oppy2update;
        
        
        
        Id taskRecordType;
        for(RecordType rt : [SELECT Id FROM RecordType WHERE SobjectType = 'Task' AND DeveloperName = 'Notification_Task' AND IsActive = true]){
            taskRecordType = rt.Id;
        }
        for(Opportunity oppy : list_oppy2update){
            Task t = new Task();
            t.OwnerId = oppy.OwnerId;
            t.Subject = 'Opportunity mismatch';
            t.Description = System.Label.Description_For_Task;
            t.RecordTypeId = taskRecordType;
            t.Status = 'Not started';
            t.Priority = 'Normal';
            t.WhatId = oppy.Id;
            t.CurrencyIsoCode = 'USD';
            list_tasks2insert.add(t);
        }
        if(list_tasks2insert.size() > 0) insert list_tasks2insert;
    }
    
    
    
    /**
    * Get TeamView Subordinate User list 
    *
    @author Lei Tang
    @created 2014-03-12
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param teamviewid    string     TeamView Team  id
    *
    @return list<User>   TeamView Subordinate User list 
    *
    @changelog
    * 2014-03-12 Lei Tang <lei.tang@itbconsult.com>  
    * - Created  
    */ 
    public static void getUserListbyTeamViewId(string teamviewid, list<CtrlPMVTeamView.TeamViewObject> list_teamMembs, set<String> set_teamMembIds){
        TeamView_Team__c tvobj = null;
        for(TeamView_Team__c tv : [Select Id,Name,Team_Member_User_IDs__c from TeamView_Team__c where Id = :teamviewid]){
            tvobj = tv;
        }
        
        if(tvobj != null && tvobj.Team_Member_User_IDs__c != null){
            set<string> set_userids = new set<string>(); 
            string[] userids = tvobj.Team_Member_User_IDs__c.split(',');
            for(string userid : userids){
                set_userids.add(userid);
            }
            
            if(set_userids.size() > 0){
                for(User user : [Select Id, Name, UserRoleId  from User Where Id IN :set_userids ]){
                    String userRoleId = (user.UserRoleId == null ? 'null': String.valueOf(user.UserRoleId).subString(0, 15));
                    list_teamMembs.add(new CtrlPMVTeamView.TeamViewObject(user.Id+'', userRoleId, user.Name, '','','','','','','',''));
                    set_teamMembIds.add(user.Id);
                }
                
            }
        }
    }
    
    
    /**
    * Get industry user
    *
    @author Yuanyuan Zhang
    @created 2014-03-13
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param set_ownerId    set<Id>   opportunity owner id
    *
    *
    @changelog
    * 2014-03-13 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>  
    * - Created  
    */ 
    
    public static set<Id> getIndustryUser(set<Id> set_ownerId){
        set<Id> set_industryUserId = new set<Id>();
        for(User u : [SELECT Id FROM USER WHERE Id IN :set_ownerId 
                                          AND (Profile.Name = 'Industrial Standard User'
                                          OR Profile.Name = 'Industrial Engineering User w/Cost'
                                          OR Profile.Name = 'Industrial User w/ Cost')]){
            set_industryUserId.add(u.Id);
        }
        return set_industryUserId;
    } 
    
    /**
    * Get PMV record type for lead conversion oppy
    *
    @author Yuanyuan Zhang
    @created 2014-03-13
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param set_ownerId    set<Id>   opportunity owner id
    *
    *
    @changelog
    * 2014-03-13 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>  
    * - Created  
    */ 
    
    public static Id getPMVRecordTypeForLeadOppy(){
        Id PMVRecordType;
        for(Opportunity_Record_Type_Groups__c prtg : Opportunity_Record_Type_Groups__c.getAll().values() ){
                        if(prtg.active__c == null  &&  prtg.recordTypeID__c != null && prtg.Group__c=='PMV' && prtg.Default_Record_Type_Lead_Conversion__c == true  )
            PMVRecordType = prtg.RecordTypeID__c;
        }
        return PMVRecordType;
    }
    
    
    /**
    * Estimate wether an oppy has decision criteria or not.
    *
    @author Yuanyuan Zhang
    @created 2014-03-14
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param list_oppy    List<Opportunity>   opportunity 
    *
    @return             boolean
    *
    @changelog
    * 2014-03-14 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>  
    * - Created  
    */ 
    public static Boolean hasDecisionCriteria(List<Opportunity> list_oppy){
        Boolean hasDC = false;
        for(Decision_Criteria__c dc : [SELECT Id FROM Decision_Criteria__c WHERE Opportunity__c IN :list_oppy limit 1]){
            hasDC = true;
            break;
        }
        return hasDC;
    }
    
    /**
    * Estimate wether an oppy has key player criteria or not.
    *
    @author Yuanyuan Zhang
    @created 2014-03-14
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param list_oppy    List<Opportunity>   opportunity 
    *
    @return             boolean
    *
    @changelog
    * 2014-03-14 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>  
    * - Created  
    */ 
    public static boolean hasKeyPlayerCriteria(List<Opportunity> list_oppy){
        Boolean hasKPC = false;
        for(Key_Player_Criteria__c kpc : [SELECT Id FROM Key_Player_Criteria__c WHERE Decision_Criteria__r.Opportunity__c IN :list_oppy limit 1]){
            hasKPC = true;
        }
        
        return hasKPC;
    }
    
    /**
    *   Estimate wether there is new contact role is added, if yes create corresponding key player and key player criteria.
    *
    @author Yuanyuan Zhang
    @created 2014-03-17
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param list_oppy    List<Opportunity>   opportunity 
    *
    @return             boolean
    *
    @changelog
    * 2014-03-17 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>  
    * - Created  
    */ 
    public static void checkContactRoleAndGenerateKeyPlayer(Id oppyId){
        List<Key_Player__c> list_keyPlayer2insert = new List<Key_Player__c>();
        List<Key_Player__c> list_keyPlayer2del =  new List<Key_Player__c>();
        List<Key_Player__c> list_keyPlayer2update =  new List<Key_Player__c>();
        
        map<String, Custom_Opportunity_Contact_Role__c> map_contactRoleId_oppyContactRole = new map<String, Custom_Opportunity_Contact_Role__c>();//store oppycontactrole
        for(Custom_Opportunity_Contact_Role__c ocr : [select Contact__c, Opportunity__c, Primary__c, Id, Role__c from Custom_Opportunity_Contact_Role__c WHERE Opportunity__c = :oppyId]){
            map_contactRoleId_oppyContactRole.put(ocr.Id, ocr);
        }
        
        for(Key_Player__c kp : [select Id, Name, Opportunity__c, Contact__c, Custom_Opportunity_Contact_Role__c from Key_Player__c WHERE Opportunity__c = :oppyId]){
            if(map_contactRoleId_oppyContactRole.containsKey(kp.Custom_Opportunity_Contact_Role__c)){
                Custom_Opportunity_Contact_Role__c ocr = map_contactRoleId_oppyContactRole.get(kp.Custom_Opportunity_Contact_Role__c);
                if(kp.Opportunity__c != ocr.Opportunity__c || kp.Contact__c != ocr.Contact__c){
                    kp.Opportunity__c = ocr.Opportunity__c;
                    kp.Contact__c = ocr.Contact__c;
                    list_keyPlayer2update.add(kp);
                }
                map_contactRoleId_oppyContactRole.remove(kp.Custom_Opportunity_Contact_Role__c);
            }
            else{
                list_keyPlayer2del.add(kp);//contactrole is already deleted.
            }
        }
        
        if(!map_contactRoleId_oppyContactRole.isEmpty()){//new oppy contact role exist
            for(String contactRoleId : map_contactRoleId_oppyContactRole.keySet()){
                Custom_Opportunity_Contact_Role__c ocr = map_contactRoleId_oppyContactRole.get(contactRoleId);
                Key_Player__c kp = new Key_Player__c();
                kp.Opportunity__c = ocr.Opportunity__c;
                kp.Contact__c = ocr.Contact__c;
                kp.Custom_Opportunity_Contact_Role__c = ocr.Id;
                list_keyPlayer2insert.add(kp);
            }
        }
        
        if(list_keyPlayer2del.size() > 0) delete list_keyPlayer2del;
        
        if(list_keyPlayer2insert.size() > 0) insert list_keyPlayer2insert;
        if(list_keyPlayer2update.size() > 0) update list_keyPlayer2update;
        
    }
    
    /**
    *   generate key player criteria records with given key player records
    *
    @author Yuanyuan Zhang
    @created 2014-03-17
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-17 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>  
    * - Created  
    */ 
    public static void createKeyPlayerCriterias(List<Key_Player__c> list_kp){
        List<Key_Player_Criteria__c> list_kpc2insert = new List<Key_Player_Criteria__c>();
        set<Id> set_oppyId = new set<Id>();
        
        for(Key_Player__c kp : list_kp){
            set_oppyId.add(kp.Opportunity__c);
        }
        
        for(Decision_Criteria__c dc : [select Id, Name, Opportunity__c, Position__c, Comment__c, Question_English__c, Active__c 
                                        from Decision_Criteria__c
                                        WHERE Opportunity__c IN :set_oppyId
                                        AND Active__c = true]){
            for(Key_Player__c kp : list_kp){
                Key_Player_Criteria__c kpc = new Key_Player_Criteria__c();
                kpc.Decision_Criteria__c = dc.Id;
                kpc.Key_Player__c = kp.Id;
                kpc.Priority__c = '1';
                list_kpc2insert.add(kpc);
            }
        }
        if(list_kpc2insert.size() > 0) insert list_kpc2insert;
    }
    
    /**
    *   generate key player criteria records with given decision criteria records
    *
    @author Yuanyuan Zhang
    @created 2014-03-17
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-17 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>  
    * - Created  
    */ 
    public static void createKeyPlayerCriteriasWithDecision(List<Decision_Criteria__c> list_dc){
        List<Key_Player_Criteria__c> list_kpc2insert = new List<Key_Player_Criteria__c>();
        set<Id> set_oppyId = new set<Id>();
        
        for(Decision_Criteria__c dc : list_dc){
            set_oppyId.add(dc.Opportunity__c);
        }
        
        for(Key_Player__c kp : [select Id, Name, Opportunity__c, Contact__c from Key_Player__c WHERE Opportunity__c IN :set_oppyId]){
            for(Decision_Criteria__c dc : list_dc){
                Key_Player_Criteria__c kpc = new Key_Player_Criteria__c();
                kpc.Decision_Criteria__c = dc.Id;
                kpc.Key_Player__c = kp.Id;
                kpc.Priority__c = '1';
                list_kpc2insert.add(kpc);
            }
        }
        
        if(list_kpc2insert.size() > 0) insert list_kpc2insert;
    }
    
    /**
    *   generate key player criteria records with given decision criteria records
    *
    @author Yuanyuan Zhang
    @created 2014-03-19
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-17 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>  
    * - Created  
    */ 
    public static void createKeyPlayerCriteriasWithDecisionForUpdate(List<Decision_Criteria__c> list_dc){
        set<Id> set_oppyId = new set<Id>();
        for(Decision_Criteria__c dc : list_dc){
            set_oppyId.add(dc.Opportunity__c);
        }
        
        List<Key_Player__c> list_keyPlayer = new List<Key_Player__c>();
        for(Key_Player__c kp : [select Id, Name, Opportunity__c, Contact__c from Key_Player__c WHERE Opportunity__c IN :set_oppyId]){
            list_keyPlayer.add(kp);
        }
        
        List<Key_Player_Criteria__c> list_keyPlayerCriterias = new List<Key_Player_Criteria__c>();
        for(Key_Player_Criteria__c kpc : [select Id, Name, Key_Player__c, Decision_Criteria__c, Priority__c 
                                            from Key_Player_Criteria__c
                                            WHERE Decision_Criteria__c IN :list_dc]){
            list_keyPlayerCriterias.add(kpc);
        }
        
        List<Key_Player_Criteria__c> list_kpc2insert = new List<Key_Player_Criteria__c>();
        
        for(Decision_Criteria__c dc : list_dc){
            for(Key_Player__c kp : list_keyPlayer){
                Boolean hasFound = false;
                for(Integer i = 0; i < list_keyPlayerCriterias.size(); i++){
                    Key_Player_Criteria__c kpc = list_keyPlayerCriterias.get(i);
                    if(kpc.Decision_Criteria__c == dc.Id && kpc.Key_Player__c == kp.Id){
                        hasFound = true;
                        list_keyPlayerCriterias.remove(i);
                        break;
                    }
                }
                if(!hasFound){
                    Key_Player_Criteria__c kpc = new Key_Player_Criteria__c();
                    kpc.Decision_Criteria__c = dc.Id;
                    kpc.Key_Player__c = kp.Id;
                    kpc.Priority__c = '1';
                    list_kpc2insert.add(kpc);
                }
            }
        }
        
        if(list_kpc2insert.size() > 0) insert list_kpc2insert;
    }
    
    
/**
    *   check current user have edit access to a SObject
    *
    @author Jinbo Shan
    @created 2014-04-25
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-04-25 Jinbo Shan <jinbo.shan@itbconsult.com>  
    * - Created  
    */ 
    public static boolean checkEditAccessForSObject(Id userId, Id recordId){
        for(UserRecordAccess recordAccess : [select HasAllAccess, HasDeleteAccess, HasEditAccess, HasReadAccess, HasTransferAccess, MaxAccessLevel, RecordId from UserRecordAccess where UserId =:userId AND RecordId = : recordId]){
            if(recordAccess.HasEditAccess){
                return true;
            }
        }   
        return false;
    }
    
    
    
    /**
     *  This method is used to change contact Nps score and update connection opportunity nps score from conact.
     *R-346: Ability to Win Factor NPS Score
     *  
     * @author Weihang Li
     * @created 2014-06-03
     * @version 1.0
     * @since 27.0 (Force.com ApiVersion)  
     * 
     *
     * @changelog
     * 2014-06-03 Weihang Li <weihang.li@itbconsult.com>
     * - Created   
     *
     */
    public static void updateOpportunityNPSScoreWhenContactChanged(set<Id> set_conIds, set<Id> set_conIdsDeleted){
        set<Id> set_oppyIds = new set<Id>();
        system.debug('**@@set_conIds = ' + set_conIds);
        for(Custom_Opportunity_Contact_Role__c role : [Select Opportunity__c, Id, Contact__c, Contact__r.NPS_Score__c From Custom_Opportunity_Contact_Role__c where Contact__c in: set_conIds]){
            set_oppyIds.add(role.Opportunity__c);
        }
        if(set_oppyIds.size() > 0) {
            updateOpportunityNPSScore(set_oppyIds, set_conIdsDeleted);
        }
        
    }
    
    /**
     *  This method is used to update connection opportunity nps score from conact.
     *R-346: Ability to Win Factor NPS Score
     *  
     * @author Weihang Li
     * @created 2014-06-03
     * @version 1.0
     * @since 27.0 (Force.com ApiVersion)  
     * 
     *
     * @changelog
     * 2014-06-03 Weihang Li <weihang.li@itbconsult.com>
     * - Created   
     *
     */
    public static void updateOpportunityNPSScore(set<Id> set_oppyIds, set<Id> set_deletedIds){
        
        map<Id, list<decimal>> map_oppyId_list_conScores = new map<Id, list<decimal>>();
        
        for(Custom_Opportunity_Contact_Role__c role : [select Opportunity__c, Id, Contact__c, 
                                                        Contact__r.NPS_Score__c 
                                                        from Custom_Opportunity_Contact_Role__c 
                                                        where Id NOT IN :set_deletedIds 
                                                        and Contact__c NOT IN :set_deletedIds 
                                                        and Opportunity__c IN :set_oppyIds]){
            decimal scoreTemp;
            if(role.Contact__r.NPS_Score__c != null) {
                scoreTemp = role.Contact__r.NPS_Score__c;
            }else {
                scoreTemp = 5;
            }
            if(!map_oppyId_list_conScores.containsKey(role.Opportunity__c)) {
                map_oppyId_list_conScores.put(role.Opportunity__c, new list<decimal>());
            }
            set_oppyIds.remove(role.Opportunity__c);
            map_oppyId_list_conScores.get(role.Opportunity__c).add(scoreTemp);
        }
        decimal sum = 0;
        decimal result = 0;
        if(!map_oppyId_list_conScores.isEmpty()){
            map<Id,decimal> map_oppId_newScore = new map<Id,decimal>();
            for(Id opId: map_oppyId_list_conScores.keySet()){
                sum = 0;
                result = 0;
                for(decimal num : map_oppyId_list_conScores.get(opId)){
                    sum += num;
                }
                result = (sum/(map_oppyId_list_conScores.get(opId).size())).setScale(2);
                map_oppId_newScore.put(opId,result);
            }
            if(!map_oppId_newScore.isEmpty()){
                List<Opportunity> list_oppys = new List<Opportunity>();
                for(Opportunity op : [select Id, Name, Average__c 
                                        from Opportunity 
                                        where Id IN : map_oppId_newScore.keySet()]){
                    op.Average__c = map_oppId_newScore.get(op.Id);
                    list_oppys.add(op);
                }
                update list_oppys;
            }
        }
        
        if(set_oppyIds.size() > 0) {
            List<Opportunity> list_oppys = new List<Opportunity>();
            for(Opportunity op : [select Id, Name, Average__c 
                                    from Opportunity 
                                    where Id IN : set_oppyIds]){
                op.Average__c = null;
                list_oppys.add(op);
            }
            if(list_oppys.size() > 0) {
                update list_oppys;
            }
        }
    }
    /**
     *  This method is used to set value to socre.
     *  R-345: Ability To Win Factor Sales Cycle - Buying Cycle
     *
     * @author Weihang Li
     * @created 2014-06-03
     * @version 1.0
     * @since 27.0 (Force.com ApiVersion)  
     * 
     *
     * @changelog
     * 2014-06-03 Weihang Li <weihang.li@itbconsult.com>
     * - Created   
     *
     */
    public static void setScoreValue(List<Opportunity> list_oppys){
        map<Id,String> map_setting_opId_stageName = new map<Id,String>();
        
        map<Id, Id> map_rtId_bpId = new map<Id, Id>();
        
        for(RecordType rt : [select Id, BusinessProcessId from RecordType where isActive = true]) {
            map_rtId_bpId.put(rt.Id, rt.BusinessProcessId);
        }
        
        for(Opportunity opp:list_oppys){
            for(PMV_Sales_Stage_Setting__c st:PMV_Sales_Stage_Setting__c.getAll().values()){
                if(opp.PMV_Type__c == st.PMV_Type__c && map_rtId_bpId.get(opp.RecordTypeId) == st.Sales_Process_ID__c && opp.Buying_Cycle__c == st.Buyer_Cycle__c){
                    map_setting_opId_stageName.put(opp.Id,st.Sales_Stage__c);
                }
            }
        }
        
        map<String,Integer> map_stageName_sortOrder = new map<String,Integer>();
        for(OpportunityStage os:[Select SortOrder, MasterLabel From OpportunityStage where isActive = true]){
            map_stageName_sortOrder.put(os.MasterLabel, os.SortOrder);
        }
        
        for(Opportunity opp: list_oppys){
            if(!map_setting_opId_stageName.isEmpty() && map_setting_opId_stageName.containsKey(opp.Id)){
                if(map_stageName_sortOrder.get(opp.StageName) >= map_stageName_sortOrder.get(map_setting_opId_stageName.get(opp.Id))){
                    opp.Score__c = 3;
                }else if((map_stageName_sortOrder.get(opp.StageName)) + 1 == map_stageName_sortOrder.get(map_setting_opId_stageName.get(opp.Id))){
                    opp.Score__c = 2;
                }else{
                    opp.Score__c = 1;
                }
            } else {
                opp.Score__c = 1;
            }
        }
    }
    
    /**
     *  This method is used to Ability to Win calculation is the Decision Criteria Position from Decision criteria. 
     *  R-350: Ability to Win factor: Decision Criteria Position
     *
     * @author Weihang Li
     * @created 2014-06-03
     * @version 1.0
     * @since 27.0 (Force.com ApiVersion)  
     * 
     *
     * @changelog
     * 2014-06-03 Weihang Li <weihang.li@itbconsult.com>
     * - Created   
     *
     */
    /*public static void reCalculateNPSScoreFromDecisionCriteria(List<Decision_Criteria__c> list_criterias,map<Id,Decision_Criteria__c> map_dId_criteria){
        set<Id> set_dcIds = new set<Id>();
        for(Decision_Criteria__c dc:list_criterias){
            if(dc.Position__c != map_dId_criteria.get(dc.Id).Position__c){
                set_dcIds.add(dc.Id);
            }
        }
        abilityToWinCalculationForCriteria(set_dcIds);
    }*/
    /**
     *  This method is used to Ability to Win calculation is the Decision Criteria Position from key player criteria. 
     *  R-350: Ability to Win factor: Decision Criteria Position
     *
     * @author Weihang Li
     * @created 2014-06-03
     * @version 1.0
     * @since 27.0 (Force.com ApiVersion)  
     * 
     *
     * @changelog
     * 2014-06-03 Weihang Li <weihang.li@itbconsult.com>
     * - Created   
     *
     */
    /*public static void reCalculateNPSScoreFromKeyPlayer(List<Key_Player_Criteria__c> list_kpCriterias, map<Id,Key_Player_Criteria__c> map_kpId_criteria){
        set<Id> set_kpIds = new set<Id>();
        for(Key_Player_Criteria__c kp:list_kpCriterias){
            if(kp.Priority__c != map_kpId_criteria.get(kp.Id).Priority__c){
                set_kpIds.add(kp.Decision_Criteria__c);
            }
        }
        abilityToWinCalculationForCriteria(set_kpIds);
    }*/
    /**
     *  This method is used to Ability to Win calculation is the Decision Criteria Position. 
     *  R-350: Ability to Win factor: Decision Criteria Position
     *
     * @author Weihang Li
     * @created 2014-06-03
     * @version 1.0
     * @since 27.0 (Force.com ApiVersion)  
     * 
     *
     * @changelog
     * 2014-06-03 Weihang Li <weihang.li@itbconsult.com>
     * - Created   
     *
     */
    public static void abilityToWinCalculationForCriteria(set<Id> set_oppyIds){
        if(!set_oppyIds.isEmpty()){
            map<Id,Integer> map_dcId_Priority = new map<Id,Integer>();
            map<Id, set<Id>> map_opId_criteriaIds = new map<Id, set<Id>>();
            
            map<Id,Integer> map_dId_position = new map<Id,Integer>();
            for(Key_Player_Criteria__c kp : [select Id, Name, Decision_Criteria__c, Decision_Criteria__r.Position__c, 
                                            Decision_Criteria__r.Opportunity__c, Priority__c 
                                            from Key_Player_Criteria__c 
                                            where Decision_Criteria__r.Opportunity__c in:set_oppyIds 
                                            and Decision_Criteria__r.Active__c = true]){
                Integer num = 0;
                if(kp.Priority__c != null && kp.Priority__c != ''){
                    num = Integer.valueOf(kp.Priority__c);
                }
                if(!map_dcId_Priority.containsKey(kp.Decision_Criteria__c)){
                    map_dcId_Priority.put(kp.Decision_Criteria__c, 0);
                }
                map_dcId_Priority.put(kp.Decision_Criteria__c, map_dcId_Priority.get(kp.Decision_Criteria__c) + num);
                
                if(!map_opId_criteriaIds.containsKey(kp.Decision_Criteria__r.Opportunity__c)){
                    map_opId_criteriaIds.put(kp.Decision_Criteria__r.Opportunity__c, new set<Id>());
                }
                map_opId_criteriaIds.get(kp.Decision_Criteria__r.Opportunity__c).add(kp.Decision_Criteria__c);
                
                if(kp.Decision_Criteria__r.Position__c == null || kp.Decision_Criteria__r.Position__c == ''){
                    kp.Decision_Criteria__r.Position__c = '0';
                }
                map_dId_position.put(kp.Decision_Criteria__c,Integer.valueOf(kp.Decision_Criteria__r.Position__c));
            }
            if(!map_opId_criteriaIds.isEmpty()){
                map<Id,list<Id>> map_opId_filterCriteriaIds = new map<Id,list<Id>>();
                
                map_opId_filterCriteriaIds = getTopThreeItem(map_dcId_Priority, map_opId_criteriaIds);
                system.debug('**@@ map_opId_filterCriteriaIds = ' + map_opId_filterCriteriaIds);
                if(!map_opId_filterCriteriaIds.isEmpty()){
                    map<Id,decimal> map_oId_averagePriority = new map<Id,decimal>();
                    for(Id oId:map_opId_filterCriteriaIds.keySet()){
                        decimal average = 0;
                        decimal sum = 0;
                        List<Id> list_Ids = new List<Id>();
                        list_Ids = map_opId_filterCriteriaIds.get(oId);
                        for(Integer i = 0; i < list_Ids.size();i++){
                            Integer position = 0;
                            if(i == 0){
                                position = 3;
                            }else if(i == 1){
                                position = 2;
                            }else if(i == 2){
                                position = 1;
                            }
                            sum += position * map_dId_position.get(list_Ids.get(i));
                        }
                        system.debug('**@@ sum = ' + sum);
                        average = (sum/(list_Ids.size())).setScale(2);
                        map_oId_averagePriority.put(oId,average);
                    }
                    system.debug('**@@ map_oId_averagePriority = ' + map_oId_averagePriority);
                    if(!map_oId_averagePriority.isEmpty()){
                        List<Opportunity> list_oppys = new List<Opportunity>();
                        for(Opportunity opp:[select Id,Win_Factor_Average__c from Opportunity where Id in:map_oId_averagePriority.keySet()]){
                            opp.Win_Factor_Average__c = map_oId_averagePriority.get(opp.Id);
                            list_oppys.add(opp);
                        }
                        update list_oppys;
                    }
                }
                
            }
            
        }
     }
     /**
     *  This method is used to get top three decision criterias for opportunity
     *  R-350: Ability to Win factor: Decision Criteria Position
     *
     * @author Jinbo Shan
     * @created 2014-06-11
     * @version 1.0
     * @since 29.0 (Force.com ApiVersion)  
     * 
     *
     * @changelog
     * 2014-06-03 Jinbo Shan <jinbo.shan@itbconsult.com>
     * - Created   
     *
     */
     private static map<Id,list<Id>> getTopThreeItem(map<Id,Integer> map_dcId_Priority, map<Id,set<Id>> map_opId_criteriaIds) {
        
        system.debug('**@@ map_dcId_Priority = ' + map_dcId_Priority);
        system.debug('**@@ map_opId_criteriaIds = ' + map_opId_criteriaIds);
        
        map<Integer, set<Id>> map_priority_set_dcIds = new map<Integer, set<Id>>();
        set<Integer> set_priorities = new set<Integer>();
        list<Integer> list_prioritiesDesc = new list<Integer>();//store set_priorities desc
        map<Integer, list<Id>> map_priority_list_dcIdsDesc = new map<Integer, list<Id>>();//store sorted decision criteria Ids desc
        map<Id,list<Id>> map_opId_sortCriteriaIds = new map<Id, list<Id>>();//for return
        
        for(Id dcId : map_dcId_Priority.keySet()){
            if(!map_priority_set_dcIds.containsKey(map_dcId_Priority.get(dcId))) {
                map_priority_set_dcIds.put(map_dcId_Priority.get(dcId), new set<Id>());
            }
            map_priority_set_dcIds.get(map_dcId_Priority.get(dcId)).add(dcId);
            set_priorities.add(map_dcId_Priority.get(dcId));
        }
        
        list_prioritiesDesc = sortIntegersDesc(set_priorities);
        
        list<Id> listDcIdsDesc = new list<Id>();
        for(Integer priority : map_priority_set_dcIds.keySet()) {
            listDcIdsDesc = sortIdsDesc(map_priority_set_dcIds.get(priority));
            map_priority_list_dcIdsDesc.put(priority, listDcIdsDesc);
        }
        
        for(string oppyId : map_opId_criteriaIds.keySet()) {
            for(Integer priority : list_prioritiesDesc) {
                for(Id ciriteriaId : map_priority_list_dcIdsDesc.get(priority)) {
                    if(map_opId_criteriaIds.get(oppyId).contains(ciriteriaId)){
                        if(!map_opId_sortCriteriaIds.containsKey(oppyId)) {
                            map_opId_sortCriteriaIds.put(oppyId, new list<Id>());
                        }
                        if(map_opId_sortCriteriaIds.get(oppyId).size() < 3) {
                            map_opId_sortCriteriaIds.get(oppyId).add(ciriteriaId);
                        }else {
                            break;
                        }
                    }
                }
            }
        }
        
        return map_opId_sortCriteriaIds;
        
     }
     /**
     *  This method is used to sort list ids desc
     *  R-350: Ability to Win factor: Decision Criteria Position
     *
     * @author Jinbo Shan
     * @created 2014-06-11
     * @version 1.0
     * @since 29.0 (Force.com ApiVersion)  
     * 
     *
     * @changelog
     * 2014-06-03 Jinbo Shan <jinbo.shan@itbconsult.com>
     * - Created   
     *
     */
     private static list<Id> sortIdsDesc(set<Id> set_Ids) {
        list<Id> list_IdsTemp = new list<Id>();
        for(Id j : set_Ids) {
            list_IdsTemp.add(j);
        }
        list_IdsTemp.sort();
        list<Id> list_IdsDesc = new list<Id>();
        for(integer i = list_IdsTemp.size() - 1; i >= 0; i--) {
            list_IdsDesc.add(list_IdsTemp.get(i));
        }
        return list_IdsDesc;
     }
     
     /**
     *  This method is used to sort list integers desc
     *  R-350: Ability to Win factor: Decision Criteria Position
     *
     * @author Jinbo Shan
     * @created 2014-06-11
     * @version 1.0
     * @since 29.0 (Force.com ApiVersion)  
     * 
     *
     * @changelog
     * 2014-06-03 Jinbo Shan <jinbo.shan@itbconsult.com>
     * - Created   
     *
     */
     private static list<Integer> sortIntegersDesc(set<Integer> set_ints) {
        list<Integer> list_intTemp = new list<Integer>();
        for(integer j : set_ints) {
            list_intTemp.add(j);
        }
        list_intTemp.sort();
        list<Integer> list_intsDesc = new list<Integer>();
        for(integer i = list_intTemp.size() - 1; i >= 0; i--) {
            list_intsDesc.add(list_intTemp.get(i));
        }
        return list_intsDesc;
     }
     
     /**
     *  This method is used to calculation of DGI_indicator__c
     *  R-363: Create Trigger for Calculation of DGI_indicator__c
     *
     * @author Weihang Li
     * @created 2014-06-09
     * @version 1.0
     * @since 27.0 (Force.com ApiVersion)  
     * 
     *
     * @changelog
     * 2014-06-09 Weihang Li <weihang.li@itbconsult.com>
     * - Created   
     *
     */
    public static void calculateDGIIndicator(set<Id> set_oppyIds){
        map<Id, set<string>> map_oppyId_set_GDIs = new map<Id, set<string>>();
        List<Opportunity> list_oppys = new List<Opportunity>();
        set<Id> set_rtIds = getAllPMVRecordtypes();
        
        for(Opportunity_Part__c op : [select Id, Name, GPL__c, GPL__r.GDI_Classification__c, 
                                        Opportunity__c 
                                        from Opportunity_Part__c 
                                        where Opportunity__c IN : set_oppyIds]) {
            if(op.GPL__c != null) {
                if(!map_oppyId_set_GDIs.containsKey(op.Opportunity__c)) {
                    map_oppyId_set_GDIs.put(op.Opportunity__c, new set<string>());
                }
                map_oppyId_set_GDIs.get(op.Opportunity__c).add(op.GPL__r.GDI_Classification__c);
            }
        }
        
        for(Opportunity opp : [select Id, DGI_Value__c from Opportunity where Id IN: set_oppyIds]) {
            if(map_oppyId_set_GDIs.containsKey(opp.Id)) {
                if(map_oppyId_set_GDIs.get(opp.Id).contains('Invest')) {
                    opp.DGI_Value__c = 'Invest';
                } else if(map_oppyId_set_GDIs.get(opp.Id).contains('Grow')) {
                    opp.DGI_Value__c = 'Grow';
                } else {
                    opp.DGI_Value__c = 'None';
                }
            }else {
                opp.DGI_Value__c = 'None';
            }
            list_oppys.add(opp);
        }
        if(!list_oppys.isEmpty()){
            update list_oppys;
        }
    }
    
    /**
     *  This method is used to calculation of DGI_indicator__c from product Hierarchy
     *  R-363: Create Trigger for Calculation of DGI_indicator__c
     *
     * @author Weihang Li
     * @created 2014-06-09
     * @version 1.0
     * @since 27.0 (Force.com ApiVersion)  
     * 
     *
     * @changelog
     * 2014-06-09 Weihang Li <weihang.li@itbconsult.com>
     * - Created   
     *
     */
    public static void calculateGDIValue(List<Product_Hierarchy__c> list_proHierarchy){
        
        set<Id> set_phIds = new set<Id>();
        set<Id> set_oppyIds = new set<Id>();
        
        for(Product_Hierarchy__c ph:list_proHierarchy){
            set_phIds.add(ph.Id);
        }
        map<Id,String> map_oppyId_GDIValue = new map<Id,String>();
        for(Opportunity_Part__c op : [select Id, Opportunity__c, GPL__c, GPL__r.GDI_Classification__c 
                                     from Opportunity_Part__c 
                                     where GPL__c IN: set_phIds]){
            set_oppyIds.add(op.Opportunity__c);
        }
        if(!set_oppyIds.isEmpty()){
            calculateDGIIndicator(set_oppyIds);
        }
    }
    
    /**
     *  This method is used to calculation of the number of custom contact roles for 1 Opportunity
     *  
     *
     * @author Jinbo Shan
     * @created 2014-08-19
     * @version 1.0
     * @since 30.0 (Force.com ApiVersion)  
     * 
     *
     * @changelog
     * 2014-08-19 Jinbo Shan <jinbo.shan@itbconsult.com>
     * - Created   
     *
     */
    public static integer calculateContactRoleNum(Id oppyId) {
        integer countPoliticalMaps = 0;
        for(Custom_Opportunity_Contact_Role__c conRole : [select Contact__c, Id 
                                                         from Custom_Opportunity_Contact_Role__c 
                                                         where Opportunity__c = :oppyId 
                                                         and IsDeleted = false 
                                                         and Contact__r.Inactive__c = false 
                                                         and Contact__r.AccountId != null]){
            countPoliticalMaps += 1;
        }
        return countPoliticalMaps;
    }
    
    /**
     *  This method is used to calculation of the number of decision criteria for an Opportunity
     *  
     *
     * @author Jinbo Shan
     * @created 2014-08-19
     * @version 1.0
     * @since 30.0 (Force.com ApiVersion)  
     * 
     *
     * @changelog
     * 2014-08-19 Jinbo Shan <jinbo.shan@itbconsult.com>
     * - Created   
     *
     */
    public static integer calculateDecisionCriteriaNum(Id oppyId) {
        integer countDecisionCriteria = 0;
        for(Decision_Criteria__c de:[select Id from Decision_Criteria__c where Opportunity__c = : oppyId AND Active__c = true]){
            countDecisionCriteria++;
        }
        return countDecisionCriteria;
    }
    
     /**
     *  This method is used to calculation of the number of Question for an Opportunity
     *  
     *
     * @author Jinbo Shan
     * @created 2014-08-19
     * @version 1.0
     * @since 30.0 (Force.com ApiVersion)  
     * 
     *
     * @changelog
     * 2014-08-19 Jinbo Shan <jinbo.shan@itbconsult.com>
     * - Created   
     *
     */
    public static integer calculateNumOfQuestion(Opportunity opportunity) {
        
        integer questionNum = 0;
        set<Id> set_osIds4show = new set<Id>();
        
        for(PMV_Stage_Config__c ssc : PMV_Stage_Config__c.getAll().values()){
            if(ssc.Business_ProcessID__c == opportunity.RecordType.BusinessProcessId && ssc.Stage_Id__c != null){
                set_osIds4show.add((Id)ssc.Stage_Id__c);
            }
        }
        
        for(Sales_Process_Question_Assignment__c spqa : [SELECT Id, PMV_Type__c 
                                                         FROM Sales_Process_Question_Assignment__c 
                                                         WHERE BusinessProcess__c = :opportunity.RecordType.BusinessProcessId 
                                                         AND IsDeleted=false AND PMV_Type__c != null 
                                                         AND OpportunityStage__c IN :set_osIds4show]){
            if(opportunity.PMV_Type__c != null && spqa.PMV_Type__c.contains(opportunity.PMV_Type__c)){
                questionNum +=1;
            }                                           
        }
        return questionNum;
    }
    
    /**
     *  This method is used to calculation of the number of Answer for an Opportunity
     *  
     *
     * @author Jinbo Shan
     * @created 2014-08-19
     * @version 1.0
     * @since 30.0 (Force.com ApiVersion)  
     * 
     *
     * @changelog
     * 2014-08-19 Jinbo Shan <jinbo.shan@itbconsult.com>
     * - Created   
     *
     */
    public static integer calculateNumOfAnswer(Opportunity opportunity) {
        
        integer answerNum = 0;
        set<Id> set_osIds4show = new set<Id>();
        set<Id> set_spqaIds = new set<Id>();
        
        for(PMV_Stage_Config__c ssc : PMV_Stage_Config__c.getAll().values()){
            if(ssc.Business_ProcessID__c == opportunity.RecordType.BusinessProcessId && ssc.Stage_Id__c != null){
                set_osIds4show.add((Id)ssc.Stage_Id__c);
            }
        }
        
        for(Sales_Process_Question_Assignment__c spqa : [SELECT Id, PMV_Type__c 
                                                         FROM Sales_Process_Question_Assignment__c 
                                                         WHERE BusinessProcess__c = :opportunity.RecordType.BusinessProcessId 
                                                         AND IsDeleted=false AND PMV_Type__c != null 
                                                         AND OpportunityStage__c IN :set_osIds4show]){
            if(opportunity.PMV_Type__c != null && spqa.PMV_Type__c.contains(opportunity.PMV_Type__c)){
                set_spqaIds.add(spqa.Id);
            }                                           
        }
        
        for(Quality_Assessment_Answer__c qaa : [SELECT Status__c 
                                                FROM Quality_Assessment_Answer__c 
                                                WHERE Sales_Process_Question_Assignment__c IN :set_spqaIds 
                                                AND Opportunity__c=:opportunity.Id AND IsDeleted=false AND Active__c = true]){
            if(qaa.Status__c == 'Yes'){
                answerNum += 1;
            }
        }
        
        return answerNum;
        
    }
    
    /**
     *  This method is used to create a Custom Opportunity Contact Role for current Opprotunity
     *  
     *
     * @author Jinbo Shan
     * @created 2014-08-19
     * @version 1.0
     * @since 30.0 (Force.com ApiVersion)  
     * 
     *
     * @changelog
     * 2014-08-19 Jinbo Shan <jinbo.shan@itbconsult.com>
     * - Created   
     *
     */
     @future 
     public static void createContactRoleForLeadOpportunity(set<Id> set_oppyId){
        
        list<Custom_Opportunity_Contact_Role__c> list_cocrs = new list<Custom_Opportunity_Contact_Role__c>();
        system.debug('**@@@set_oppyId = ' + set_oppyId);
        for(OpportunityContactRole ocr : [select Id, ContactId, OpportunityId, IsPrimary, Role from OpportunityContactRole where OpportunityId IN : set_oppyId]) {
            Custom_Opportunity_Contact_Role__c cocr = new Custom_Opportunity_Contact_Role__c();
            cocr.Contact__c = ocr.ContactId;
            cocr.Opportunity__c = ocr.OpportunityId;
            cocr.Role__c = ocr.Role;
            cocr.Primary__c = ocr.IsPrimary;
            list_cocrs.add(cocr);
        }
        system.debug('**@@@list_cocrs = ' + list_cocrs);
        if(list_cocrs.size() > 0){
            insert list_cocrs;
        }
     }
    
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>WrapperClass*/
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
}