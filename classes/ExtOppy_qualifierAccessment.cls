/**
*   Contains a set of static methods used in VF pages
*
@author Jinbo Shan
@created 2014-02-10
@version 1.0
@since 23.0 (Force.com ApiVersion)
*
@changelog
* 2014-02-10 Jinbo Shan <jinbo.shan@itbconsult.com>
* - Created
*/
public without sharing class ExtOppy_qualifierAccessment {
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public string jsonString                    {get;set;}
    public static string LANGUAGE='en_US';
    public static string SUCCESS = 'SUCCESS';
    public string oppyjson                      {get;set;}
    public string buyingCyclePickList           {get;set;}
    public LocaleConfig lc                      {get;set;}
    public Integer countDecisionCriteria        {get;set;}
    public Integer countPoliticalMaps           {get;set;}
    public boolean hasAccessEdit                {get;set;}
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private Opportunity oppy;
    private ApexPages.standardController stdCtrl;
    private map<Id, Sales_Process_Question_Assignment__c> map_id_spqa;
    private map<string, ClsAnswer> map_spqaId_qaa;  
    private list<ClsSaveStatus> list_clsss;
    private set<string> set_profileNames = new set<string>{'Service Account', 'Systemadministrator', 'System Administrator', 'BU Admin'};
    private boolean isAdmin;
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    /**
     * the constructor
     */
    public ExtOppy_qualifierAccessment(ApexPages.StandardController stdCtrl) {
        lc = new LocaleConfig();
        isAdmin = false;
        hasAccessEdit = true;
        for(Profile profile : [select Name from Profile where Id = :Userinfo.getProfileId()]){
            if(set_profileNames.contains(profile.Name)){
                isAdmin = true;
            }
        }
        
        map<Id, decimal> map_oppystage_thre = new map<Id,decimal>();
        map<Id, boolean> map_oppystage_priorityStage = new map<Id,boolean>();
        
        this.stdCtrl = stdCtrl;
        Opportunity oppyTemp = (Opportunity)stdCtrl.getRecord();
        if(oppyTemp != null){
            this.oppy = [SELECT Id, RecordType.BusinessProcessId, PMV_Type__c, AccountId FROM Opportunity WHERE Id=:oppyTemp.Id];
            
            Opportunity temp = [SELECT Id,Buying_Cycle__c,Buying_Cycle_Comment__c FROM Opportunity WHERE Id=:oppyTemp.Id];
            oppyjson = JSON.serialize(temp);
        }
        
        //start get all Opportunity Stage for this Opportunity and put values for map_osId_list_spqas and map_spqaId_qaa
        string currentUserLanguage =  UserInfo.getLanguage();
        PMV_Language_Config__c slc = PMV_Language_Config__c.getInstance(currentUserLanguage);
        if(slc==null){
            slc = PMV_Language_Config__c.getInstance(LANGUAGE);
        }
        string quesFieldName = slc.Question_text_field__c;
        string helpCFieldName=slc.Help_text_field__c;
        
        list_clsss = new list<ClsSaveStatus>();
        set<Id> set_oppyStages = new set<Id>();
        
        set<Id> set_oppyStages4show = new set<Id>();
        
        map_id_spqa = new map<Id, Sales_Process_Question_Assignment__c>();
        
        map_spqaId_qaa = new map<string, ClsAnswer>();
        
        map<string, list<ClsDocuments>> map_spqa_list_qcds = new map<string, list<ClsDocuments>>();
        map<string, set<string>> map_spqaId_set_qcdIds = new map<string, set<string>>();
        set<string> set_cdis = new set<string>();
        set<string> set_qaqIds = new set<string>();
        map<string, Quality_Assessment_Question__c> map_id_qaq = new map<string, Quality_Assessment_Question__c>();
        map<string, Id> map_oppyStage_oppyStageId = new map<string, Id>();
        
        this.countDecisionCriteria = 0;
        this.countPoliticalMaps = 0;
        if(oppy!=null){
            
            if(!ClsPMV_Util.checkEditAccessForSObject(UserInfo.getUserId(), oppy.Id)){
                hasAccessEdit = false;
            }
            
            this.countPoliticalMaps = ClsPMV_Util.calculateContactRoleNum(oppy.Id);
            
            this.countDecisionCriteria = ClsPMV_Util.calculateDecisionCriteriaNum(oppy.Id);
            
            for(PMV_Stage_Config__c ssc : PMV_Stage_Config__c.getAll().values()){
                if(ssc.Business_ProcessID__c == oppy.RecordType.BusinessProcessId){
                    set_oppyStages4show.add((Id)ssc.Stage_Id__c);
                }
            }
            
            for(OpportunityStage oppyStage : [SELECT Id, MasterLabel FROM OpportunityStage WHERE Id IN :set_oppyStages4show AND IsActive=true order by SortOrder]){
                map_oppyStage_oppyStageId.put(oppyStage.MasterLabel, oppyStage.Id);
            }
            
            //get all custom setting PMV_Stage_Thresholds__c
            for(PMV_Sales_Stage_Setting__c sst : ClsPMV_Util.getPMVSalesStageSetting()){
                if((Id)sst.Sales_Process_ID__c == oppy.RecordType.BusinessProcessId && sst.PMV_Type__c == oppy.PMV_Type__c && sst.Active__c){
                    if(map_oppyStage_oppyStageId.containsKey(sst.Sales_Stage__c)){
                        map_oppystage_thre.put(map_oppyStage_oppyStageId.get(sst.Sales_Stage__c), sst.Completion_Threshold__c);
                        map_oppystage_priorityStage.put(map_oppyStage_oppyStageId.get(sst.Sales_Stage__c), sst.Priority_Stage__c);
                    }
                }
            }
            
            for(Sales_Process_Question_Assignment__c spqa : [SELECT Id, Rating__c, Not_Resettable__c, OpportunityStage__c, 
                                                             Quality_Assessment_Question__c, PMV_Type__c, Sequence__c 
                                                             FROM Sales_Process_Question_Assignment__c 
                                                             WHERE BusinessProcess__c = :oppy.RecordType.BusinessProcessId 
                                                             AND IsDeleted=false AND PMV_Type__c!=null 
                                                             AND OpportunityStage__c IN :set_oppyStages4show]){
                if(spqa.PMV_Type__c.contains(oppy.PMV_Type__c)){
                    set_oppyStages.add((Id)spqa.OpportunityStage__c);
                    map_id_spqa.put(spqa.Id, spqa);
                    set_qaqIds.add(spqa.Quality_Assessment_Question__c);
                }
            }
            
            for(Quality_Assessment_Question__c qaq : [SELECT Id, Help_Comment_Chinese__c, Help_Comment_English__c, Help_Comment_German__c, Help_Comment_Japanese__c, Question_Chinese__c, Question_English__c, Question_German__c, Question_Japanese__c FROM Quality_Assessment_Question__c WHERE Id IN :set_qaqIds]){
                map_id_qaq.put(qaq.Id, qaq);
            }
            
            for(Question_Content_Documents__c qcd : [SELECT Id, Name, Sales_Process_Question_Assignment__c, Content_Document_ID__c FROM Question_Content_Documents__c WHERE Sales_Process_Question_Assignment__c IN :map_id_spqa.keySet()]){
                if(!map_spqaId_set_qcdIds.containsKey(qcd.Sales_Process_Question_Assignment__c)) map_spqaId_set_qcdIds.put(qcd.Sales_Process_Question_Assignment__c, new set<string>());
                if(qcd.Content_Document_ID__c != null) {
                    map_spqaId_set_qcdIds.get(qcd.Sales_Process_Question_Assignment__c).add(qcd.Content_Document_ID__c.subString(0,15));
                    set_cdis.add(qcd.Content_Document_ID__c);
                }
            }
            
            for(ContentDocument cd : [SELECT Id, Title FROM ContentDocument WHERE Id IN :set_cdis]){
                string cdId = cd.Id;
                for(string spquestionId :  map_spqaId_set_qcdIds.keySet()){
                    if(map_spqaId_set_qcdIds.get(spquestionId).contains(cdId.subString(0,15))){
                        ClsDocuments cls = new ClsDocuments();
                        cls.docName=cd.Title;
                        cls.url='/' + cd.Id;
                        if(!map_spqa_list_qcds.containsKey(spquestionId)) map_spqa_list_qcds.put(spquestionId, new list<ClsDocuments>());
                        map_spqa_list_qcds.get(spquestionId).add(cls);
                    }
                }
            }
            
            for(Quality_Assessment_Answer__c qaa : [SELECT Id, Status__c, LastModifiedDate, Comment_Long__c, Sales_Process_Question_Assignment__c, Sales_Process_Question_Assignment__r.Rating__c, Sales_Process_Question_Assignment__r.OpportunityStage__c 
                                                    FROM Quality_Assessment_Answer__c 
                                                    WHERE Sales_Process_Question_Assignment__c IN :map_id_spqa.keySet() 
                                                    AND Opportunity__c=:oppy.Id AND IsDeleted=false AND Active__c = true]){
                
                ClsAnswer clsAns = new ClsAnswer();
                clsAns.questionId = qaa.Sales_Process_Question_Assignment__c;
                clsAns.comment = qaa.Comment_Long__c;
                clsAns.status = qaa.Status__c;
                clsAns.lastModifyDate = qaa.LastModifiedDate.date().format();
                if(!map_spqaId_qaa.containsKey(qaa.Sales_Process_Question_Assignment__c)) map_spqaId_qaa.put(qaa.Sales_Process_Question_Assignment__c, clsAns);
                
            }
            
            //order Opportunity Stage to structure list of ClsSaveStatus
            for(OpportunityStage oppyStage : [SELECT Id, MasterLabel FROM OpportunityStage WHERE Id IN :set_oppyStages4show AND IsActive=true order by SortOrder]){
                ClsSaveStatus cls = new ClsSaveStatus();
                if(map_oppystage_thre.containsKey(oppyStage.Id)){
                    cls.threshold = map_oppystage_thre.get(oppyStage.Id);
                }
                if(map_oppystage_priorityStage.containsKey(oppyStage.Id)){
                    cls.priorityStage = map_oppystage_priorityStage.get(oppyStage.Id);
                }
                cls.os=oppyStage;
                if(set_oppyStages.contains(oppyStage.Id)){
                    for(string spqaId : map_id_spqa.keySet()){
                        if(map_id_spqa.get(spqaId).OpportunityStage__c==oppyStage.Id){
                            ClsQuestion clsques = new ClsQuestion();
                            clsques.id = spqaId;
                            clsques.rating = map_id_spqa.get(spqaId).Rating__c;
                            clsques.sequence = (map_id_spqa.get(spqaId).Sequence__c == null ? 0 : map_id_spqa.get(spqaId).Sequence__c);
                            if(!isAdmin){
                                clsques.notReset = map_id_spqa.get(spqaId).Not_Resettable__c;
                            }
                            if(map_id_qaq.get(map_id_spqa.get(spqaId).Quality_Assessment_Question__c).get(quesFieldName) != null) {
                                clsques.question = string.valueOf(map_id_qaq.get(map_id_spqa.get(spqaId).Quality_Assessment_Question__c).get(quesFieldName));
                            }else {
                                clsques.question = map_id_qaq.get(map_id_spqa.get(spqaId).Quality_Assessment_Question__c).Question_English__c;
                            }
                            if(map_id_qaq.get(map_id_spqa.get(spqaId).Quality_Assessment_Question__c).get(helpCFieldName) != null) {
                                clsques.helpComment = string.valueOf(map_id_qaq.get(map_id_spqa.get(spqaId).Quality_Assessment_Question__c).get(helpCFieldName));
                            }else {
                                clsques.helpComment = map_id_qaq.get(map_id_spqa.get(spqaId).Quality_Assessment_Question__c).Help_Comment_English__c;
                            }
                            
                            cls.list_questions.add(clsques);
                            if(map_spqa_list_qcds.containsKey(spqaId)){
                                if(!cls.map_spqaId_list_qdocs.containsKey(spqaId)) cls.map_spqaId_list_qdocs.put(spqaId, new list<ClsDocuments>());
                                cls.map_spqaId_list_qdocs.get(spqaId).addAll(map_spqa_list_qcds.get(spqaId));
                            }
                            if(map_spqaId_qaa.containsKey(spqaId)){
                                cls.list_answers.add(map_spqaId_qaa.get(spqaId));
                            }
                        }
                    }
                }
                cls.list_questions.sort();
                list_clsss.add(cls);
            }
        }
        
        buyingCyclePickList = getBuyingCyclePickList();
        jsonString = JSON.serialize(list_clsss);
        system.debug(list_clsss);
        //end
    }
    
    /**
    * Remote Action is used to upsert list Quality_Assessment_Answer__c
    *
    @author Jinbo Shan
    @created 2014-02-12
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param              list of ClsAnswer
    *
    @return             string
    *
    @changelog
    * 2014-02-12 Jinbo Shan <jinbo.shan@itbconsult.com>  
    * - Created  
    */ 
    @RemoteAction 
    public static String saveAnswers(string oppId, string answerJSON){
        list<ClsAnswer> list_answers = (list<ClsAnswer>)JSON.deserialize(answerJSON, list<ClsAnswer>.class);
        map<string, ClsAnswer> map_ques_answer = new map<string, ClsAnswer>();
        list<Quality_Assessment_Answer__c> list_qaas = new list<Quality_Assessment_Answer__c>();
        list<Quality_Assessment_Answer__c> list_qaas4insert = new list<Quality_Assessment_Answer__c>();
        set<string> set_questionIds = new set<string>();
        
        list<ClsAnswer> list_answers4return = new list<ClsAnswer>();
        
        for(ClsAnswer clsanswer : list_answers){
            clsanswer.lastModifyDate = system.today().format();
            map_ques_answer.put(clsanswer.questionId, clsanswer);
        }
        Savepoint sp = Database.setSavepoint();
        try {
            for(Quality_Assessment_Answer__c qaa : [SELECT Comment_Long__c, Status__c, LastModifiedDate, Sales_Process_Question_Assignment__c, Opportunity__c 
                                                            FROM Quality_Assessment_Answer__c 
                                                            WHERE Sales_Process_Question_Assignment__c IN :map_ques_answer.keySet() 
                                                            AND Opportunity__c=:oppId AND IsDeleted=false AND Active__c = true]){
                
                if(!set_questionIds.contains(qaa.Sales_Process_Question_Assignment__c)){
                    set_questionIds.add(qaa.Sales_Process_Question_Assignment__c);
                    //if(map_ques_answer.get(qaa.Sales_Process_Question_Assignment__c).comment!=null && map_ques_answer.get(qaa.Sales_Process_Question_Assignment__c).comment!=''){
                    if(map_ques_answer.get(qaa.Sales_Process_Question_Assignment__c).comment!='**@@**') {
	                    qaa.Comment_Long__c = map_ques_answer.get(qaa.Sales_Process_Question_Assignment__c).comment;
                    }
                    //}
                    if(map_ques_answer.get(qaa.Sales_Process_Question_Assignment__c).status!=null && map_ques_answer.get(qaa.Sales_Process_Question_Assignment__c).status!=''){
                        qaa.Status__c = map_ques_answer.get(qaa.Sales_Process_Question_Assignment__c).status;
                    }
                    map_ques_answer.remove(qaa.Sales_Process_Question_Assignment__c);
                }else{
                    qaa.Active__c = false;
                }
                
                list_qaas.add(qaa);
            }
            
            if(list_qaas.size()>0){
                update list_qaas;
            }
            
            if(set_questionIds.size()>0){
                for(string questionId : set_questionIds){
                    if(map_ques_answer.containsKey(questionId)){
                        map_ques_answer.remove(questionId);
                    }
                }
            }
            if(map_ques_answer.size()>0){
                for(string questionId : map_ques_answer.keySet()){
                    set_questionIds.add(questionId);
                    Quality_Assessment_Answer__c qaa = new Quality_Assessment_Answer__c();
                    qaa.Sales_Process_Question_Assignment__c = questionId;
                    qaa.Opportunity__c = oppId;
                    if(map_ques_answer.get(questionId).status!=null && map_ques_answer.get(questionId).status!=''){
                        qaa.Status__c = map_ques_answer.get(questionId).status;
                    }
                    //if(map_ques_answer.get(questionId).comment!=null && map_ques_answer.get(questionId).comment!=''){
                    if(map_ques_answer.get(qaa.Sales_Process_Question_Assignment__c).comment!='**@@**') {
                    	qaa.Comment_Long__c = map_ques_answer.get(questionId).comment;
                    }
                    //}
                    qaa.Active__c=true;
                    list_qaas4insert.add(qaa);
                }
            }
            if(list_qaas4insert.size()>0){
                insert list_qaas4insert;
            }
            for(Quality_Assessment_Answer__c qaa : [select LastModifiedDate, Sales_Process_Question_Assignment__c, Status__c, Comment_Long__c 
                                                    from Quality_Assessment_Answer__c 
                                                    where Opportunity__c=:oppId 
                                                    and Sales_Process_Question_Assignment__c IN :set_questionIds AND IsDeleted=false AND Active__c = true]){
                ClsAnswer answer = new ClsAnswer();
                answer.lastModifyDate = qaa.LastModifiedDate.date().format();
                answer.questionId = qaa.Sales_Process_Question_Assignment__c;
                answer.status = qaa.Status__c;
                answer.comment = qaa.Comment_Long__c;
                list_answers4return.add(answer);
            }
        } catch(DmlException e) {
            Database.rollback(sp); 
            return e.getMessage();
        }
       return JSON.serialize(list_answers4return);
    }
    
    /**
    * Remote Action is used to update Buying Cycle and Buying Cycle Comment of Opportunity
    *
    @author Lei Tang 
    @created 2014-03-12
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param   oppId      string      updated Opportunity Id
    @param   buyingCyclevalue       string      updated Buying Cycle value
    @param   buyingCycleomment      string      updated buying Cycle Comment
    *
    @return  string     success : success  ,fail : exception message
    *
    @changelog
    * 2014-03-12 Lei Tang <lei.Tang@itbconsult.com>   
    * - Created  
    */ 
    @RemoteAction 
    public static string updateOppBCandBCC(string oppId, string buyingCyclevalue, string buyingCycleComment){
        try{
            Opportunity opp = [SELECT Id,Buying_Cycle__c,Buying_Cycle_Comment__c FROM Opportunity WHERE Id=:oppId];
            opp.Buying_Cycle__c = buyingCyclevalue;
            opp.Buying_Cycle_Comment__c = buyingCycleComment;
                    
            update opp;
            return 'success';
        }catch(exception e) {
             return e.getMessage();
        }   
        
        
    }
    
    
    
    /**
    * this function is get Buying_Cycle__c of Opportunity PickList options
    *
    @author Lei Tang
    @created 2014-03-12
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @return             string        json of PickList options 
    *
    @changelog
    * 2014-03-12 Lei Tang <lei.Tang@itbconsult.com>  
    * - Created  
    */ 
    private string getBuyingCyclePickList(){
        list<string> options = new list<string>();
        Schema.sObjectType objType = Opportunity.getSObjectType(); 
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
        list<Schema.PicklistEntry> values = fieldMap.get('Buying_Cycle__c').getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : values)
        { 
            options.add(a.getValue()); 
        }
        return JSON.serialize(options);
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
    
    public class ClsSaveStatus{
        OpportunityStage os                                             {get;set;}
        list<ClsQuestion> list_questions                                {get;set;}
        map<string, list<ClsDocuments>> map_spqaId_list_qdocs           {get;set;}
        list<ClsAnswer> list_answers                                    {get;set;}
        decimal threshold                                               {get;set;}
        boolean priorityStage                                           {get;set;}
        
        public ClsSaveStatus(){
            threshold = 0;
            list_questions = new list<ClsQuestion>();
            list_answers = new list<ClsAnswer>();
            map_spqaId_list_qdocs = new map<string, list<ClsDocuments>>();
            priorityStage = false;
        }
    }
    
    public class ClsQuestion implements Comparable{
        string id           {get;set;}
        decimal rating      {get;set;}
        string question     {get;set;}
        string helpComment  {get;set;}
        boolean notReset    {get;set;}
        decimal sequence {get; set;}
        public ClsQuestion(){
            notReset = false;
            this.sequence = 0;
        }
        public Integer compareTo(Object compareTo) {
            ClsQuestion compareToQuestion = (ClsQuestion) compareTo;
            if (this.sequence == compareToQuestion.sequence) return 0;
            if (this.sequence > compareToQuestion.sequence) return 1;
            return -1;        
        }
    }
    
    public class ClsAnswer{
        public string questionId           {get;set;}
        public string status               {get;set;}
        public string comment              {get;set;}
        public string lastModifyDate       {get;set;}
    }
    
    public class ClsDocuments{
        string docName  {get;set;}
        string url      {get;set;}
    }
   
}