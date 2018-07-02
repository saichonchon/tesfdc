public without sharing class ExtOppyCheckList {
	
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=Start public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public String str_oppyId {get; set;}
    public String str_saveAnswersJson {get; set;}
    public String str_formCompleted {get; set;}
    public list<ChecklistCategory> list_checklistCategory {get; set;}
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=Start private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private final ApexPages.standardController stdCtrl;    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    public ExtOppyCheckList(ApexPages.standardController stdCtrl){
    	this.stdCtrl = stdCtrl;
    	this.str_oppyId = this.stdCtrl.getRecord().Id;
    	this.list_checklistCategory = new list<ChecklistCategory>();
    	this.str_saveAnswersJson = '';
    	init();
    }
    
    public void init() {
    	getQuestions();
    }
    
    public void getQuestions() {
    	map<String, ChecklistCategory> map_category_checklistCategory = new map<String, ChecklistCategory>();
    	map<String, Opportunity_CheckList_Answer__c> map_questionId_answer = new map<String, Opportunity_CheckList_Answer__c>();
    	
    	for(Opportunity_CheckList__c question : [SELECT Id, Category__c, CategoryNo__c, Help_Message__c, Question__c, QuestionNo__c,
    													Comment_Yes__c, Comment_No__c
    											  FROM Opportunity_CheckList__c 
    											  order by CategoryNo__c, QuestionNo__c]) {
    		system.debug(question.Category__c);
    		if(!map_category_checklistCategory.containsKey(question.Category__c)) {
    			ChecklistCategory categoryItem = new ChecklistCategory();
    			categoryItem.str_categoryText = question.Category__c;
    			categoryItem.str_categoryNumber = question.CategoryNo__c;
    			map_category_checklistCategory.put(question.Category__c, categoryItem);
    		}
    		ChecklistCategory categoryItem = map_category_checklistCategory.get(question.Category__c);
    		ChecklistItem item = new ChecklistItem();	
    		item.str_questionId = question.Id;
    		item.str_questionText = question.Question__c;
    		item.str_categoryNumber = question.CategoryNo__c;
    		item.str_questionNumber = question.QuestionNo__c;
    		item.str_questionHelpText = question.Help_Message__c;
    		item.str_commentYesText = question.Comment_Yes__c;
    		item.str_commentNoText = question.Comment_No__c;
    		item.str_questionAnswer = '';
    		categoryItem.list_questions.add(item);	
    		  
    	}
    	list<ChecklistCategory> list_ChecklistCategory = map_category_checklistCategory.values();
    	list_ChecklistCategory.sort();
    	this.list_checklistCategory.addAll(list_ChecklistCategory);
    	
    	//get answers
    	for(Opportunity_CheckList_Answer__c answer : [Select Id, Answer__c, Comment__c, Opportunity_CheckList_Id__c, Opportunity_Id__c
    												  From Opportunity_CheckList_Answer__c
    												  Where Opportunity_Id__c =: this.str_oppyId]) {
    	
    		map_questionId_answer.put(answer.Opportunity_CheckList_Id__c, answer);												  
    	}
    	
    	for(ChecklistCategory questionCategory : this.list_checklistCategory) {
    		for(ChecklistItem question : questionCategory.list_questions) {
    			if(map_questionId_answer.containsKey(question.str_questionId)) {
    				Opportunity_CheckList_Answer__c answer = map_questionId_answer.get(question.str_questionId);
    				question.str_questionAnswerId = answer.Id;
    				question.str_questionAnswer = answer.Answer__c;
    				question.str_questionComment = answer.Comment__c;
    			}
    		}
    	}
    	system.debug('list_checklistCategory::'+list_checklistCategory);
    }
    
    public void saveAnswers() {
    	// json --> list<AnswerObj>
    	try {
    	System.debug('str_saveAnswersJson:::'+str_saveAnswersJson);
    	// convert json string to list objs
    	List<AnswerObj> list_answerObjs = (List<AnswerObj>)JSON.deserialize(str_saveAnswersJson, List<AnswerObj>.class);
		if(!list_answerObjs.isEmpty()){
			Set<String> set_oppCheckListIds = new Set<String>();
			Map<String, Opportunity_CheckList_Answer__c> map_str_oppCheckListId_oppCheckListAnswer = new Map<String, Opportunity_CheckList_Answer__c>();			
			for(AnswerObj ao : list_answerObjs){
				if(String.isNotBlank(ao.str_questionId)){
					set_oppCheckListIds.add(ao.str_questionId);
				}
			}
			//check if already existing
			if(!set_oppCheckListIds.isEmpty()){
				for(Opportunity_CheckList_Answer__c oca : [select Id, Answer__c, Comment__c, Opportunity_CheckList_Id__c
													       from Opportunity_CheckList_Answer__c
													       where Opportunity_CheckList_Id__c in : set_oppCheckListIds 
													       and Opportunity_Id__c =: this.str_oppyId]){
						map_str_oppCheckListId_oppCheckListAnswer.put(oca.Opportunity_CheckList_Id__c, oca);							       	
					}											       
			}
			System.debug('map_oppCheckListAnswer:::'+map_str_oppCheckListId_oppCheckListAnswer);
			for(AnswerObj ao : list_answerObjs){
				if(map_str_oppCheckListId_oppCheckListAnswer.containsKey(ao.str_questionId) &&
				   (map_str_oppCheckListId_oppCheckListAnswer.get(ao.str_questionId).Answer__c != ao.str_questionAnswer ||
				   	map_str_oppCheckListId_oppCheckListAnswer.get(ao.str_questionId).Comment__c != ao.str_questionComment
				   )
				){
					map_str_oppCheckListId_oppCheckListAnswer.get(ao.str_questionId).Answer__c = ao.str_questionAnswer;
					map_str_oppCheckListId_oppCheckListAnswer.get(ao.str_questionId).Comment__c = ao.str_questionComment;
				}
				else if(!map_str_oppCheckListId_oppCheckListAnswer.containsKey(ao.str_questionId)){
					Opportunity_CheckList_Answer__c newOppCheckListAnswer = new Opportunity_CheckList_Answer__c();
					newOppCheckListAnswer.Opportunity_CheckList_Id__c = ao.str_questionId;
					newOppCheckListAnswer.Answer__c = ao.str_questionAnswer;
					newOppCheckListAnswer.Comment__c = ao.str_questionComment;
					newOppCheckListAnswer.Opportunity_Id__c = this.str_oppyId;
					map_str_oppCheckListId_oppCheckListAnswer.put(ao.str_questionId, newOppCheckListAnswer);
				}					
			}
			System.debug('map_str_oppCheckListId_oppCheckListAnswer:::'+map_str_oppCheckListId_oppCheckListAnswer);
			//upsert Opportunity_CheckList_Answer__c
			if(! map_str_oppCheckListId_oppCheckListAnswer.isEmpty()){
				System.debug('map_str_oppCheckListId_oppCheckListAnswer.values():::'+map_str_oppCheckListId_oppCheckListAnswer.values());
				upsert map_str_oppCheckListId_oppCheckListAnswer.values();
			}	
			
			Opportunity opp = new Opportunity();
			for(Opportunity temp :[select id,Opportunity_Checklist_Completed__c from opportunity where id=:this.str_oppyId]){
				opp = temp;
			}
			if(opp != null && opp.id != null){
				if(this.str_formCompleted == 'true'){
					opp.Opportunity_Checklist_Completed__c = true;
					update opp;
				}
				if(this.str_formCompleted == 'false'){
					opp.Opportunity_Checklist_Completed__c = false;
					update opp;
				}
			}					
		}
		ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'Saved Successfully'));
      }catch(Exception ex) {
      		System.debug('---ex.getMessage():::'+ex.getMessage());
    		ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getStackTraceString()));
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getMessage()));
    		ErrorLogging.Log(ex);
    	}
    }
    
    public class AnswerObj {
    	public String str_questionId {get; set;}
    	public String str_questionAnswer {get; set;}
    	public String str_questionComment {get; set;}
    	
    	public AnswerObj() {
    		this.str_questionId = '';
    		this.str_questionAnswer = '';
    		this.str_questionComment = '';
    		
    	}
    }
    
    
    public class ChecklistCategory implements Comparable { //implements Comparable
    	public String str_categoryText {get; set;}
    	public decimal str_categoryNumber {get; set;}
    	public list<ChecklistItem> list_questions {get; set;}
    	
    	public ChecklistCategory() {
    		this.str_categoryNumber = 0;
    		this.str_categoryText = '';
    		this.list_questions = new list<ChecklistItem>();
    	}
    	
        public Integer compareTo(Object compareTo) {
			ChecklistCategory compare = (ChecklistCategory) compareTo;

            if (compare.str_categoryNumber == this.str_categoryNumber) {
                return 0;
            }
            if(compare.str_categoryNumber < this.str_categoryNumber) {
                return 1;
            }
            return -1;        
        }
        
    }
    public class ChecklistItem  {
    	public String str_questionId {get; set;}
    	public String str_questionText {get; set;}
    	public decimal str_categoryNumber {get; set;}
    	public decimal str_questionNumber {get; set;}
    	public String str_questionHelpText {get; set;}
    	public String str_commentYesText {get; set;}
    	public String str_commentNoText {get; set;}
    	public String str_questionAnswer {get; set;}
    	public String str_questionComment {get; set;}
    	public String str_questionAnswerId {get; set;}
    	
    	public ChecklistItem() {
    		this.str_questionId = '';
    		this.str_questionText = '';
    		this.str_categoryNumber = 0;
    		this.str_questionNumber = 0;
    		this.str_questionHelpText = '';
    		this.str_questionAnswer = '';
    		this.str_commentYesText = '';
    		this.str_commentNoText = '';
    		this.str_questionComment = '';
    		this.str_questionAnswerId = '';
    	}
    	/*
    	public ChecklistItem(Opportuntiy_CheckList__c item) {
    		this.str_questionText = item.Question__c;
    		this.str_categoryNumber = item.CategoryNo__c;
    		this.str_questionNumber = item.QuestionNo__c;
    		this.str_questionHelpText = item.Help_Message__c;
    		this.str_questionAnswer = '';
    	}
    	public ChecklistItem(Opportuntiy_CheckList__c question) {
    		//this.str_questionText = question.Question__c;
    	}*/
    }
}