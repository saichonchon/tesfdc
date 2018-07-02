/**
*   Contains a set of static methods used in VF pages
*
@author Jinbo Shan
@created 2014-02-14
@version 1.0
@since 23.0 (Force.com ApiVersion)
*
@changelog
* 2014-02-14 Jinbo Shan <jinbo.shan@itbconsult.com>
* - Created
@changelog
* 2017-02-22 Chen Chen <chen.chen@oinio.com>
* - add method renderDescription
* - update api version to 3
*/
public with sharing class ExtOppy_qualifierOverview {
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public string jsonString        {get;set;}
    public Opportunity opportunity  {get;set;}
    public String returnValue       {get;set;}
    public LocaleConfig lc          {get;set;}
    public string stageTemp         {get;set;}
    public Opportunity_Part__c oppyPart4lost {get;set;}
    public Opportunity_Part__c oppyPart4dead {get;set;}
    public ClsOpportunity clsOppy;
    
    public boolean hasAccessEdit     {get;set;}
    //add by chenchen on 2017-02-22
    public boolean description2Render {get;set;}
    public boolean isOtherforDeadReason {get;set;}
    //end
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private ApexPages.standardController stdCtrl;
    
    private decimal oppyAllStageRating = 0;
    private decimal oppyAllStageIsYesRating = 0;
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    /**
     * the constructor
     */
     public ExtOppy_qualifierOverview(ApexPages.StandardController stdCtrl){
     	description2Render = false;
        isOtherforDeadReason = false;
        lc = new LocaleConfig();
        hasAccessEdit  = true;
        oppyPart4lost = new Opportunity_Part__c();
        oppyPart4lost.Status__c = 'Lost';
        oppyPart4lost.RecordTypeId = Apex_Helper_Settings__c.getInstance('Sales Parts RT Id').Value__c;
        oppyPart4dead = new Opportunity_Part__c();
        oppyPart4dead.Status__c = 'Dead';
        oppyPart4dead.RecordTypeId = Apex_Helper_Settings__c.getInstance('Sales Parts RT Id').Value__c;
        
        set<Id> set_rts = ClsPMV_Util.getAllPMVRecordtypes();
        this.clsOppy = new ClsOpportunity();
        
        this.stdCtrl = stdCtrl;
        this.returnValue = '';
        Opportunity oppyTemp = (Opportunity)stdCtrl.getRecord();
        if(oppyTemp != null){
            for(Opportunity oppy : [SELECT Id, PMV_Type__c, Buying_Cycle__c, Lost_Rejected_Dead_On_Hold_Reason__c, RecordTypeId, 
                                      Pause_Reactivation_Date__c,Competitor__c, Probability, StageName, Other_Description__c, 
                                      Concept_Start_Date__c, CloseDate, RecordType.BusinessProcessId, Projected_Close_Date__c, 
                                      Amount, Overall_Health_Status__c, Overall_Health_Comment__c, Buying_Cycle_Comment__c, 
                                      Stage_Change_Error_Message__c, Five_Year_Revenue__c, AccountId, Approval_Status_PMV__c, Manufacturing_Start_Date__c 
                                      FROM Opportunity 
                                      WHERE Id = :oppyTemp.Id]){
                this.opportunity = oppy;
            }
            if(opportunity != null){
                
                if(!ClsPMV_Util.checkEditAccessForSObject(UserInfo.getUserId(), opportunity.Id)){
                    hasAccessEdit = false;
                }
                
                if(set_rts.contains(opportunity.RecordTypeId) && opportunity.PMV_Type__c != null){
                    getAllOppyStageAndProgress();
                }else{
                    clsOppy.isPMVOppy = false;
                }
            }
        }
        system.debug('**@@clsOppy = ' + clsOppy);
        jsonString = JSON.serialize(clsOppy);
     }
     
     /**
    * This method is used to calculate OpptunityStage and its Progress.
    *
    @author Jinbo Shan
    @created 2014-02-14
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    *
    @return             OpportunityStage
    *
    @changelog
    * 2014-02-14 Jinbo Shan <jinbo.shan@itbconsult.com>  
    * - Created  
    */  
    private void getAllOppyStageAndProgress(){
        
        map<Id, decimal> map_osId_thres = new map<Id, decimal>();
        map<Id, boolean> map_osId_priorityStage = new map<Id, boolean>();
        
        set<Id> set_osIds = new set<Id>();
        set<Id> set_osIds4show = new set<Id>();
        set<string> set_spqaIds = new set<string>();
        list<OpportunityStage> list_oss = new list<OpportunityStage>();
        map<string, decimal> map_osId_allRating = new map<string, decimal>();
        map<string, decimal> map_osId_ratingIsYes = new map<string, decimal>();
        map<string, Id> map_oppyStage_oppyStageId = new map<string, Id>();
        map<string, boolean> map_osId_isBuyerC = new map<string, boolean>();
        map<string, decimal> map_osName_order = new map<string, decimal>();
        decimal minWonStageOrder = 1000;
        decimal currentStageOrder = 0;
        
        if(opportunity!=null){
            
            for(PMV_Stage_Config__c ssc : PMV_Stage_Config__c.getAll().values()){
                if(ssc.Business_ProcessID__c == opportunity.RecordType.BusinessProcessId && ssc.Stage_Id__c != null){
                    set_osIds4show.add((Id)ssc.Stage_Id__c);
                }
            }
            
            for(OpportunityStage oppyStage : [SELECT Id, MasterLabel, SortOrder FROM OpportunityStage WHERE Id IN :set_osIds4show AND IsActive=true order by SortOrder]){
                map_oppyStage_oppyStageId.put(oppyStage.MasterLabel, oppyStage.Id);
                map_osName_order.put(oppyStage.MasterLabel, oppyStage.SortOrder);
            }
            
            /*if(opportunity.StageName == 'Lost' || opportunity.StageName == 'Dead' || opportunity.StageName == 'On Hold'){
                clsOppy.reactivate = true;
            }*/
            
            for(PMV_Sales_Stage_Setting__c ssdc : ClsPMV_Util.getPMVSalesStageSetting()){
                if(ssdc.PMV_Type__c == opportunity.PMV_Type__c && (Id)ssdc.Sales_Process_ID__c == opportunity.RecordType.BusinessProcessId && ssdc.Active__c){
                    if(ssdc.Production_Stage__c && ssdc.Sales_Stage__c != null && map_osName_order.containsKey(ssdc.Sales_Stage__c) && map_osName_order.get(ssdc.Sales_Stage__c) < minWonStageOrder) {
                        minWonStageOrder = map_osName_order.get(ssdc.Sales_Stage__c);
                    }
                }
            }
            
            if(map_osName_order.containsKey(opportunity.StageName)){
                currentStageOrder = map_osName_order.get(opportunity.StageName);
            }
            
            if(currentStageOrder >= minWonStageOrder || opportunity.Approval_Status_PMV__c == 'G0 In Approval' || opportunity.Approval_Status_PMV__c == 'Conversion In Approval'){
                clsOppy.inActiveAllBtn = true;
            }
            
            if(opportunity.StageName == 'Dead') {//D-288: dead opportunity shows projected to close
            	clsOppy.projectedToCloseCls = 'projected-Dead';
            }
            
            for(PMV_Sales_Stage_Setting__c ssdc : ClsPMV_Util.getPMVSalesStageSetting()){
                if(ssdc.PMV_Type__c == opportunity.PMV_Type__c && (Id)ssdc.Sales_Process_ID__c == opportunity.RecordType.BusinessProcessId && ssdc.Active__c){
                    if(ssdc.Sales_Stage__c == opportunity.StageName){
                        if(ssdc.Won_Stage__c) {
                            clsOppy.projectedToCloseCls = 'projected-Won';
                        }else if(ssdc.Production_Stage__c) {
                            clsOppy.projectedToCloseCls = 'projected-Production';
                        }else if(ssdc.On_Hold_Stage__c){
                            clsOppy.projectedToCloseCls = 'projected-onHold';
                        }
                        if(ssdc.On_Hold_Stage__c || ssdc.Dead_Lost_Stage__c){
                            clsOppy.reactivate = true;
                        }
                        if(ssdc.On_Hold_Stage__c){
                            clsOppy.isOnHold = true;
                        }
                    }
                    if(map_oppyStage_oppyStageId.containsKey(ssdc.Sales_Stage__c)){
                        if(ssdc.Completion_Threshold__c != null){
                            map_osId_thres.put(map_oppyStage_oppyStageId.get(ssdc.Sales_Stage__c), ssdc.Completion_Threshold__c);
                        }else{
                            map_osId_thres.put(map_oppyStage_oppyStageId.get(ssdc.Sales_Stage__c), 0);
                        }
                        map_osId_priorityStage.put(map_oppyStage_oppyStageId.get(ssdc.Sales_Stage__c), ssdc.Priority_Stage__c);
                        if(opportunity.Buying_Cycle__c != null && ssdc.Buyer_Cycle__c == opportunity.Buying_Cycle__c){
                            map_osId_isBuyerC.put(ssdc.Sales_Stage__c, true);
                        }
                    }
                }
            }
            
            clsOppy.startDateString = opportunity.Concept_Start_Date__c.format();
            clsOppy.closeDateString = opportunity.CloseDate.format();
            clsOppy.startDate = opportunity.Concept_Start_Date__c;
            clsOppy.closeDate = opportunity.CloseDate;
            clsOppy.color = getDealSizeUrl(opportunity);
            clsOppy.currentStageName = opportunity.StageName;
            clsOppy.buyingCycle = opportunity.Buying_Cycle__c;
            clsOppy.overallHealthStatus = opportunity.Overall_Health_Status__c;
            clsOppy.overallHealthComment = opportunity.Overall_Health_Comment__c;
            clsOppy.buyingCycleComment = opportunity.Buying_Cycle_Comment__c;
            clsOppy.errorMsg = opportunity.Stage_Change_Error_Message__c;
            if(opportunity.Projected_Close_Date__c!=null){
                clsOppy.projectCloseDateString = opportunity.Projected_Close_Date__c.format();
                clsOppy.projectCloseDate = opportunity.Projected_Close_Date__c;
            }
            
            for(Sales_Process_Question_Assignment__c spqa : [SELECT Id, Rating__c, OpportunityStage__c, Quality_Assessment_Question__c, PMV_Type__c 
                                                             FROM Sales_Process_Question_Assignment__c 
                                                             WHERE BusinessProcess__c = :opportunity.RecordType.BusinessProcessId 
                                                             AND IsDeleted=false AND PMV_Type__c != null 
                                                             AND OpportunityStage__c IN :set_osIds4show]){
                if(spqa.PMV_Type__c.contains(opportunity.PMV_Type__c)){
                    decimal ratingTemp;
                    if(spqa.Rating__c == null){
                        ratingTemp=0;
                    }else{
                        ratingTemp=spqa.Rating__c;
                    }
                    set_osIds.add(spqa.OpportunityStage__c);
                    set_spqaIds.add(spqa.Id);
                    if(!map_osId_allRating.containsKey(spqa.OpportunityStage__c)){
                        map_osId_allRating.put(spqa.OpportunityStage__c, ratingTemp);
                    }else{
                        decimal allRatingTemp = map_osId_allRating.get(spqa.OpportunityStage__c);
                        allRatingTemp += ratingTemp;
                        map_osId_allRating.put(spqa.OpportunityStage__c, allRatingTemp);
                    }
                    oppyAllStageRating += ratingTemp;
                    clsOppy.questionNum += 1;
                }
                
            }
            for(OpportunityStage os : [SELECT Id, MasterLabel FROM OpportunityStage WHERE Id IN :set_osIds4show AND IsActive=true order by SortOrder]){
                list_oss.add(os);
            }
            
            for(Quality_Assessment_Answer__c qaa : [SELECT Id, Status__c, Sales_Process_Question_Assignment__c, Sales_Process_Question_Assignment__r.Rating__c, Sales_Process_Question_Assignment__r.OpportunityStage__c FROM Quality_Assessment_Answer__c WHERE Sales_Process_Question_Assignment__c IN :set_spqaIds AND Opportunity__c=:opportunity.Id AND IsDeleted=false AND Active__c = true]){
                decimal ratingTemp;
                if(qaa.Sales_Process_Question_Assignment__r.Rating__c == null){
                    ratingTemp=0;
                }else{
                    ratingTemp=qaa.Sales_Process_Question_Assignment__r.Rating__c;
                }
                if(qaa.Status__c == 'Yes'){
                    if(!map_osId_ratingIsYes.containsKey(qaa.Sales_Process_Question_Assignment__r.OpportunityStage__c)){
                        map_osId_ratingIsYes.put(qaa.Sales_Process_Question_Assignment__r.OpportunityStage__c, ratingTemp);
                    }else{
                        decimal ratingIsYesTmep = map_osId_ratingIsYes.get(qaa.Sales_Process_Question_Assignment__r.OpportunityStage__c);
                        map_osId_ratingIsYes.put(qaa.Sales_Process_Question_Assignment__r.OpportunityStage__c, ratingIsYesTmep + ratingTemp);
                    }
                    oppyAllStageIsYesRating += ratingTemp;
                    clsOppy.answerNum+=1;
                }
            }
            
            if(oppyAllStageRating!=0){
                system.debug('###oppyAllStageIsYesRating: ' + oppyAllStageIsYesRating);
                system.debug('###oppyAllStageRating: ' + oppyAllStageRating*100);
                clsOppy.oppyProgress = (oppyAllStageIsYesRating/oppyAllStageRating*100).round();
            }else{
                clsOppy.oppyProgress=100;
            }
            
            for(PMV_Sales_Process_Settings__c ssps : PMV_Sales_Process_Settings__c.getAll().values()){
                if((Id)ssps.Sales_Process_ID__c == opportunity.RecordType.BusinessProcessId && ssps.PMV_Type__c == opportunity.PMV_Type__c){
                    if(clsOppy.projectedToCloseCls == null){
                        if(clsOppy.oppyProgress < ssps.ProjectedToClose_Threshold__c){
                            clsOppy.projectedToCloseCls = 'projected-Below';
                        }else{
                            clsOppy.projectedToCloseCls = 'projected-Good';
                        }
                    }
                }
            }
            
            boolean isFirstNotComplete = false;
            boolean nextStageIsCurrentStage = false;
            boolean containsStage = false;
            for(integer i=0; i < list_oss.size(); i++) {
                OpportunityStage osTemp = list_oss.get(i);
                ClsStage clsStage = new ClsStage();
                clsStage.stageName = osTemp.MasterLabel;
                if(map_osId_isBuyerC.containsKey(osTemp.MasterLabel)){
                    clsStage.isBuyerCycle = true;
                }
                if(set_osIds.contains(list_oss.get(i).Id)) {
                    if(map_osId_allRating.get(osTemp.Id) != 0){
                        if(map_osId_ratingIsYes.containsKey(osTemp.Id)){
                            clsStage.prograss = (map_osId_ratingIsYes.get(osTemp.Id)/map_osId_allRating.get(osTemp.Id) * 100).round();
                        }else{
                            clsStage.prograss = 0;
                        }
                    }else{
                        clsStage.prograss = 100;
                    }
                    
                }else {
                    clsStage.prograss = 100;
                }
                
                if(map_osId_thres.containsKey(osTemp.Id) && clsStage.prograss < map_osId_thres.get(osTemp.Id)){
                    if(!containsStage || nextStageIsCurrentStage){
                        clsStage.isCurrentStage = true;
                        containsStage = true;
                        nextStageIsCurrentStage = false;
                    }
                }else{
                    if(map_osId_priorityStage.containsKey(osTemp.Id) && map_osId_priorityStage.get(osTemp.Id) && containsStage){
                        nextStageIsCurrentStage = true;
                        containsStage = true;
                        clsStage.isNextStage = true;
                    }
                }
                if(map_osId_thres.containsKey(osTemp.Id)){
                    clsStage.threshold = map_osId_thres.get(osTemp.Id);
                }
                
                clsOppy.list_clsStages.add(clsStage);
            }
            boolean haveCurrentStage = false;
            for(integer i=clsOppy.list_clsStages.size()-1; i>=0; i--){
                if(haveCurrentStage){
                    clsOppy.list_clsStages.get(i).isCurrentStage = false;
                }else{
                    if(clsOppy.list_clsStages.get(i).isNextStage){
                        if(i == clsOppy.list_clsStages.size()-1){
                            clsOppy.list_clsStages.get(i).isCurrentStage = true;
                        }else{
                            clsOppy.list_clsStages.get(i+1).isCurrentStage = true;
                        }
                        haveCurrentStage = true;
                    }
                    if(clsOppy.list_clsStages.get(i).isCurrentStage){
                        haveCurrentStage = true;
                    }
                }
                if(!containsStage){
                    clsOppy.list_clsStages.get(i).isCurrentStage = true;
                    haveCurrentStage = true;
                    containsStage = true;
                }
            }
            
            Integer k = 0;
            
            clsOppy.countPoliticalMaps = ClsPMV_Util.calculateContactRoleNum(opportunity.Id);
			
			clsOppy.countCriteria = ClsPMV_Util.calculateDecisionCriteriaNum(opportunity.Id);
        }
    }
    
    public void closeDeadBtn(){
        try{
            this.returnValue = 'success';
            opportunity.StageName = 'Dead';
            opportunity.Pause_Reactivation_Date__c = null;
            //Added by Bin Yuan 2016-07-01 due to copy close/lost reason to opportunity
            opportunity.Lost_Rejected_Dead_On_Hold_Reason__c = oppyPart4dead.Lost_Reason__c;
            opportunity.Other_Description__c = oppyPart4dead.Lost_Reason_Text__c;
            //End
            update opportunity;
            List<Opportunity_Part__c> list_ops = new List<Opportunity_Part__c>();
            for(Opportunity_Part__c op : [select Opportunity__c, Status__c, Lost_Reason_Text__c, Lost_Reason__c  
                                            from Opportunity_Part__c 
                                            where Opportunity__c = :opportunity.Id]){
                op.Status__c = oppyPart4dead.Status__c;
                op.Lost_Reason__c = oppyPart4dead.Lost_Reason__c;
                op.Lost_Reason_Text__c = oppyPart4dead.Lost_Reason_Text__c;
                list_ops.add(op);
            }
            if(list_ops.size() > 0) update list_ops;

        }
        catch(Exception ex){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getStackTraceString()));
            this.returnValue = ex.getMessage();
        }
    }
    
    public void closeLostBtn(){
        try{
            this.returnValue = 'success';
            opportunity.StageName = 'Lost';
            opportunity.Pause_Reactivation_Date__c = null;
            //Added by Bin Yuan 2016-07-01 due to copy close/lost reason to opportunity
            opportunity.Lost_Rejected_Dead_On_Hold_Reason__c = oppyPart4lost.Lost_Reason__c;
            opportunity.Other_Description__c = oppyPart4lost.Lost_Reason_Text__c;
            //End
            update opportunity;
            List<Opportunity_Part__c> list_ops = new List<Opportunity_Part__c>();
            for(Opportunity_Part__c op : [select Opportunity__c, Status__c, Lost_Reason__c, Lost_Reason_Text__c, Competitor__c 
                                            from Opportunity_Part__c 
                                            where Opportunity__c = :opportunity.Id]){
                op.Status__c = oppyPart4lost.Status__c;
                op.Lost_Reason__c = oppyPart4lost.Lost_Reason__c;
                op.Lost_Reason_Text__c = oppyPart4lost.Lost_Reason_Text__c;
                op.Competitor__c = oppyPart4lost.Competitor__c;
                list_ops.add(op);
            }
            system.debug('**@@list_ops = ' + list_ops);
            if(list_ops.size() > 0) update list_ops;
        }
        catch(Exception ex){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getStackTraceString()));
            this.returnValue = ex.getMessage();
        }
    }
    
    public void onHoldBtn(){
        try{
            this.returnValue = 'success';
            opportunity.StageName = 'On Hold';
            Date currentDate = system.today();
            Integer onHoldDays = currentDate.daysBetween(this.opportunity.Pause_Reactivation_Date__c) > 0? currentDate.daysBetween(this.opportunity.Pause_Reactivation_Date__c):0;
            this.opportunity.Projected_Close_Date__c = this.opportunity.Projected_Close_Date__c.addDays(onHoldDays);
            
            update opportunity;
            /*List<Opportunity_Part__c> list_ops = new List<Opportunity_Part__c>();
            for(Opportunity_Part__c op : [select Opportunity__c, Status__c 
                                          from Opportunity_Part__c 
                                          where Opportunity__c = :opportunity.Id
                                          AND (Status__c = 'Weak' 
                                          OR Status__c = '50/50' 
                                          OR Status__c = 'Likely'
                                          OR Status__c = 'Commit')]){
                op.Status__c = 'On Hold';
                list_ops.add(op);
            }
            if(list_ops.size() > 0) update list_ops;*/
        }
        catch(Exception ex){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getStackTraceString()));
            this.returnValue = ex.getMessage();
        }
    }
    /**
    * This method is used to update reactivate current Opportunity
    *
    @author Jinbo Shan
    @created 2014-03-03
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    *
    @return             OpportunityStage
    *
    @changelog
    * 2014-03-03 Jinbo Shan <jinbo.shan@itbconsult.com>  
    * - Created  
    */  
    public void reactivateBtn(){
        try{
            this.returnValue = 'SUCCESSED';
            /*if(this.opportunity.StageName == 'Rejected - Closed'){
                ClsPMV_Util.reactivateOppyPart = false;
            }*/
            for(ClsStage clsStage : clsOppy.list_clsStages){
                if(clsStage.isCurrentStage == true){
                    this.opportunity.StageName = clsStage.stageName;
                }
            }
            this.opportunity.Approval_Status_PMV__c = 'New';
            this.opportunity.Lost_Rejected_Dead_On_Hold_Reason__c = null;
            this.opportunity.Other_Description__c = null;
            this.opportunity.Competitor__c = null;
            this.opportunity.Pause_Reactivation_Date__c = null;
            //recalcAmountAndRevenue(this.opportunity);
            update opportunity;
        } catch(Exception ex){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getStackTraceString()));
            this.returnValue = ex.getMessage();
        }
    }
    
    private string getDealSizeUrl(Opportunity oppyTemp){
        decimal amount = 0;
        if(oppyTemp.Amount!=null){
            amount=oppyTemp.Amount;
        }
        string color = ClsPMV_Util.getDealSizeColor(amount, oppyTemp.PMV_Type__c, oppyTemp.RecordType.BusinessProcessId);
        return color;
    }
    
    public class LocaleConfig{
        public String locale {get;set;}
        public String jsPath {get;set;}
        
        public LocaleConfig(){
            try{
                this.locale= userInfo.getLocale();
                list<String> list_s = this.locale.split('_');
                this.locale = list_s[0]+'-'+list_s[1];
            }catch(Exception e){
                this.locale = 'de-DE';
            }   
            this.jsPath = '/glob-cultures/cultures/globalize.culture.'+this.locale+'.js';
        }
    }
	/**
    *   recalc opportunity amount and five year renvenue
    *
    @author Bin Yuan
    @created 2014-05-14
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-04-25 Bin Yuan <bin.yuan@itbconsult.com>  
    * - Created  
    */ 
    @TestVisible
    public static void recalcAmountAndRevenue(Opportunity oppy){
		Map<Date, Map<String, Map<Integer, Integer>>> map_date_startEndQuarter = ClsOppyUtil.getFiveYearsInternal(new set<Date>{oppy.Manufacturing_Start_Date__c});
		Decimal totalRevenue = 0;
		Decimal year5Revenue = 0;
		Integer startYear, startQuarter, endYear, endQuarter;
        for(Integer theYear :map_date_startEndQuarter.get(oppy.Manufacturing_Start_Date__c).get('Start').keySet()){
            startYear = theYear;
        }
        for(Integer theYear :map_date_startEndQuarter.get(oppy.Manufacturing_Start_Date__c).get('End').keySet()){
            endYear = theYear;
        }
        startQuarter = map_date_startEndQuarter.get(oppy.Manufacturing_Start_Date__c).get('Start').get(startYear);   
        endQuarter = map_date_startEndQuarter.get(oppy.Manufacturing_Start_Date__c).get('End').get(endYear);     

        List<Opportunity_Forecast__c> list_oppFoc=new List<Opportunity_Forecast__c>();
        // 04-23-2014 Michael Cui: add Five_Year_Amount__c on SOQL to fix case 00672671
        list_oppFoc=[select id, Name, Quantity__c, Five_Year_Amount__c, CurrencyIsoCode, Amount__c, Opportunity__c, Opportunity__r.CloseDate,Opportunity__r.Manufacturing_Start_Date__c, Part__c, Sales_Price__c, Date__c,Fiscal_Year__c, Fiscal_Quarter__c,Part__r.Status__c from Opportunity_Forecast__c where Opportunity__c =:oppy.Id and Part__c = null and Date__c != null order by Opportunity__c, Date__c];

        for(Opportunity_Forecast__c  ofc: list_oppFoc){
            if(ofc.Fiscal_Year__c != null && ofc.Fiscal_Quarter__c != null && ofc.Date__c != null && ofc.Opportunity__r.Manufacturing_Start_Date__c != null && ofc.Part__r.Status__c  !='Dead' && ofc.Part__r.Status__c  !='Lost' && ofc.Amount__c !=null){
                // calculate the five year revenue
                Integer y = Integer.valueOf(ofc.Fiscal_Year__c);
                Integer q = Integer.valueOf(ofc.Fiscal_Quarter__c);
                if((y > startYear && y < endYear) || (y == startYear && q >= startQuarter) || (y == endYear && q <= endQuarter)){
                    if(ofc.CurrencyIsoCode != oppy.CurrencyIsoCode){
                        year5Revenue += ClsOppyUtil.transformIsoCode(ofc.Amount__c, ofc.CurrencyIsoCode, oppy.CurrencyIsoCode);
                    }else{
                        year5Revenue += ofc.Amount__c;
                    }
                }                    
            }              
            if(ofc.Fiscal_Year__c != null && ofc.Fiscal_Quarter__c != null && ofc.Part__r.Status__c  !='Dead' && ofc.Part__r.Status__c  !='Lost' && ofc.Amount__c !=null){    
                if(ofc.CurrencyIsoCode != oppy.CurrencyIsoCode){
                    totalRevenue += ClsOppyUtil.transformIsoCode(ofc.Amount__c, ofc.CurrencyIsoCode, oppy.CurrencyIsoCode);
                }else{
                    totalRevenue += ofc.Amount__c;
                }
            }
        }
                             
        oppy.Amount = totalRevenue;
        oppy.Five_Year_Revenue__c = year5Revenue; 
    }
    
    /**
    *   render Description
    *
    @author Chen Chen
    @created 2017-02-21
    @version 1.0
    @since 37.0 (Force.com ApiVersion)
    */ 
    public void renderDescription(){
        //description2Render = true;
    }
    
     public class ClsOpportunity{
        boolean isPMVOppy                      {get;set;}
        string currentDateString                {get;set;} 
        string projectCloseDateString           {get;set;}
        date currentDate                        {get;set;}
        date projectCloseDate                   {get;set;}
        long oppyProgress                       {get;set;}
        string startDateString                  {get;set;}
        string closeDateString                  {get;set;}
        date startDate                          {get;set;}
        date closeDate                          {get;set;}
        list<ClsStage> list_clsStages           {get;set;}
        string color                            {get;set;}
        decimal questionNum                     {get;set;}
        decimal answerNum                       {get;set;}
        boolean reactivate                      {get;set;}
        boolean inActiveAllBtn                  {get;set;}
        string buyingCycle                      {get;set;}
        string projectedToCloseCls              {get;set;}
        string overallHealthComment             {get;set;}
        string overallHealthStatus              {get;set;}
        string buyingCycleComment               {get;set;}
        string currentStageName                 {get;set;}
        string errorMsg                         {get;set;}
        integer countCriteria                   {get;set;}
        integer countPoliticalMaps				{get;set;}
        boolean isOnHold                        {get;set;}
        
        public ClsOpportunity(){
            list_clsStages = new list<ClsStage>();
            currentDateString = system.today().format();
            currentDate = system.today();
            questionNum=0;
            answerNum=0;
            reactivate = false;
            inActiveAllBtn = false;
            overallHealthStatus = '';
            overallHealthComment = '';
            buyingCycleComment = '';
            currentStageName = '';
            errorMsg = '';
            isPMVOppy = true;
            countPoliticalMaps = 0;
            countCriteria = 0;
            isOnHold = false;                       
        }
     }
     
     public class ClsStage{
        boolean isCurrentStage  {get;set;}
        string stageName        {get;set;}
        long prograss           {get;set;}
        decimal threshold       {get;set;}
        boolean isNextStage     {get;set;}
        boolean isBuyerCycle    {get;set;}
        public ClsStage(){
            isCurrentStage = false;
            isNextStage = false;
            threshold = 0;
            isBuyerCycle = false;
        }
     }
}