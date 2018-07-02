/** 
*    Controller for CtrlTakeSurvey page
*
@author Xia Tong
@created 2012-12-11 
@version 1.0
@since 23.0 (Force.com ApiVersion)
*
@changelog
* 2012-12-11 Xia Tong <xia.tong@itbconsult.com>
* - Created
*/
global without sharing class CtrlTakeSurvey {
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    global list<SurveyItem> list_operations {get;set;}
    global list<SurveyItem> list_technology {get;set;}
    global list<SurveyItem> list_commercial {get;set;}
    global list<SurveyItem> list_overall {get;set;}
    global list<SurveyItem> list_others {get;set;}
    global list<SurveyItem> list_first {get;set;}
    global Question__c question{get;set;}
    
    global String categoryOverall{get;private set;}
    global String categoryCommercial{get;private set;}
    global String categoryTechnology{get;private set;}
    global String categoryOperations{get;private set;}
    global String mode {get; private set;}
    
    global Contact con {get;set;}
    global SurveyItem firstSurveyItem{get;set;}
    global String firstStyle{get;set;}
    
    global Integer spanOverall{get;private set;}
    global Integer spanCommercial{get;private set;}
    global Integer spanTechnology{get;private set;}
    global Integer spanOperations{get;private set;}
    global Integer spanOthers{get;private set;}
    global String introduction{get;private set;}
    
    global List<Integer> list_radioItem{get;private set;}
    global Map<Integer, String> map_order_disError{get;private set;}
    
    global String introduceLabel {get;private set;}
    global String introduceBody {get;private set;}
    global String nextBtn {get;private set;}
    global String backBtn {get;private set;}
    global String submitBtn {get;private set;}
    global String npsRequireLabel {get;private set;}
    global String valueRequireLabel {get;private set;}
    global String languageSelectLabel {get;private set;}
    global String extremelySatisfiedLabel {get;private set;}
    global String notSatisfiedLabel {get;private set;}
    global String thanksLabel {get;private set;}
    global String errorLabel {get;private set;}
    global String notAppLabel {get;private set;}
    global String recommended {get;private set;}
    global String notRecommended {get;private set;}
    global String salutation {get;private set;}
    
    global list<SelectOption> languages {get;set;}
    
    global Boolean isError {get;set;}
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private map<string,string> map_parameters;
    private set<Id> set_qIds;
    private Id cmId;
    
    private CampaignMember cm; 
    private String qfield;
    private String csfield;
    
    private Integer spanOverall_backup;
    private Integer spanCommercial_backup;
    private Integer spanTechnology_backup;
    private Integer spanOperations_backup;
    private Integer spanOthers_backup;
    private map<string,SurveyLabelConfig__c> map_name_customsetting;
    private static final string DEFAULT_CUSTOM_SETTING_FIELD ='EN_Value_c__c';
    /*private static final map<string,string> map_languageValue_csfield = new map<string,string>{
    	'CN_SIMPL' => 'CN_SIMPL_Value__c',
    	'CN_SIMPL' => 'CN_SIMPL_Value__c',
    	
    	
    };*/
    
    
    //private boolean isFirstQuestion;
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    /** 
    *    Constructor
    *
    @author Xia Tong
    @created 2012-12-11 
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @changelog
    * 2012-12-11 Xia Tong <xia.tong@itbconsult.com>
    * - Created
    */
    global CtrlTakeSurvey(){
        mode = 'LAN';       
        IE9FixUtil.fixIt();        
    	   
        map_parameters = new map<string,string>();
        map_parameters = Apexpages.currentPage().getParameters();
        map_name_customsetting = new map<string,SurveyLabelConfig__c>();
	    map_name_customsetting = SurveyLabelConfig__c.getAll();
	    csfield = DEFAULT_CUSTOM_SETTING_FIELD;
	    
	    
        if(map_parameters.containsKey('Id')){
    		try{
    			cmId = (id)map_parameters.get('Id');
    		}
        	catch(Exception e){
        		mode = 'Error';
        		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, getMessage('NPS_Invalid_ID')));
        		return;
        	} 	       	
            String cmIdStr = (String)cmId;
            
            if(cmIdStr.length() < 15 || cmIdStr.subString(0,3) != CampaignMember.SObjectType.getDescribe().getKeyPrefix()){
                mode = 'Error';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, getMessage('NPS_Invalid_ID')));
                return;
            }           
        	for(CampaignMember cam:[SELECT CampaignId, Id, Contact.Name,Contact.ITBsalutations__Letter_Salutation__c,ContactId,Campaign.EndDate ,Status,Campaign.Survey__c,contact.NPS_Language__c  FROM CampaignMember where id=: cmId]){
                cm = cam;
                
                //introduction = cm.Contact.ITBsalutations__Letter_Salutation__c == null?'':cm.Contact.ITBsalutations__Letter_Salutation__c + ',';
                break;
            }
            
            if(cm == null){
                mode = 'Error';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, getMessage('NPS_Invalid_ID')));
                return;
            }else{
            	if(cm.Contact.NPS_Language__c == null){
	                cm.Contact.NPS_Language__c = 'EN';
	            }
	            csfield = cm.Contact.NPS_Language__c + '_Value_c__c';
	            
	            if(cm.Campaign.EndDate < system.today()){
	                mode = 'Error';
	                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, getMessage('NPS_Closed_Campaign')));
	                return;
	            }
	            if(cm.Status == 'Responded'){
	                mode = 'Error';
	                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, getMessage('NPS_Responsed')));
	                return;
	            }
	            if(cm.Campaign.Survey__c == null){
	                mode = 'Error';
	                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, getMessage('NPS_Survey_Required')));
	                return;
	            }
            	getCustomLabels();
            	languages = getLanguageSelectOptions();
            }      
            
            //con = [select id,Survey_Attended_Date__c,NPS_Contact__c,NPS_Language__c from contact where id=: cm.ContactId];
            list_radioItem = new List<Integer>{10,9,8,7,6,5,4,3,2,1,0};
            list_operations = new list<SurveyItem>();
	    	list_technology = new list<SurveyItem>();
	    	list_commercial = new list<SurveyItem>();
	    	list_overall = new list<SurveyItem>();
	    	list_others = new list<SurveyItem>();
	    	list_first = new list<SurveyItem>();
	    	set_qIds = new Set<Id>();
	    	spanOverall = 0;
	        spanCommercial = 0;
	        spanTechnology = 0;
	        spanOperations = 0;
	        spanOthers = 0;
            map_order_disError = new Map<Integer, String>();

            con = new Contact();
            if(cm.Contact.NPS_Language__c == null){
                cm.Contact.NPS_Language__c = 'EN';
            }
            if(cm.Contact.NPS_Language__c != null && cm.Campaign.Survey__c != null){
                //get first question
                con.NPS_Language__c  = cm.Contact.NPS_Language__c;                
                qfield = con.NPS_Language__c +'_Question__c';                
                mode = 'FIRST';
                getFirstSurveyItem();
                              
            }            
            getCategories();
        }
        else mode = 'Error';
    }
    
    
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
   
    
    /** 
    *    submit
    *
    @author Xia Tong
    @created 2012-12-12 
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @changelog
    * 2012-12-12 Xia Tong <xia.tong@itbconsult.com>
    * - Created
    */
    global void submit(){
    	// avoid cache of browser
    	cm = [SELECT CampaignId, Id, Contact.Name,Contact.ITBsalutations__Letter_Salutation__c,ContactId,Campaign.EndDate ,Status,Campaign.Survey__c,contact.NPS_Language__c  FROM CampaignMember where id=: cmId];       
        isError = false;
		if(cm.Status == 'Responded'){
	    	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, getMessage('NPS_Responsed')));
	        isError=true;
	        return;
		}
        
        spanOverall = spanOverall_backup;
        spanCommercial = spanCommercial_backup;
        spanTechnology = spanTechnology_backup;
        spanOperations = spanOperations_backup;
        spanOthers = spanOthers_backup;
        for(Integer i :map_order_disError.keySet()){
        	map_order_disError.put(i, 'none');
        }
        list<Answer__c> list_answer2upsert = new list<Answer__c>();                
        
        firstSurveyItem.answer.Contact__c = cm.ContactId;
        firstSurveyItem.answer.Campaign__c = cm.CampaignId;
        firstSurveyItem.answer.Answer__c = firstSurveyItem.theAnswer;
        list_answer2upsert.add(firstSurveyItem.answer);
            
        for(SurveyItem si: list_overall){
            si.answer.Contact__c = cm.ContactId;
            si.answer.Campaign__c = cm.CampaignId;
            si.answer.Answer__c = si.theAnswer;
            list_answer2upsert.add(si.answer);
            if(!si.answer.Not_Applicable__c){            	
                if(si.question.Question_Type__c == '0...10' && (si.answer.Answer__c == null || si.answer.Answer__c.trim() == '')){
                    si.answer.Answer__c.addError(npsRequireLabel);
                    map_order_disError.put(si.sortOrder, '');
                    isError = true;
                    spanOverall++;
                }
            }
        }
        
        for(SurveyItem si: list_technology){
            si.answer.Contact__c = cm.ContactId;
            si.answer.Campaign__c = cm.CampaignId;
            si.answer.Answer__c = si.theAnswer;
            list_answer2upsert.add(si.answer);
            if(!si.answer.Not_Applicable__c){
                if(si.question.Question_Type__c == '0...10' && (si.answer.Answer__c == null || si.answer.Answer__c.trim() == '')){
                    si.answer.Answer__c.addError(npsRequireLabel);
                    map_order_disError.put(si.sortOrder, '');
                    isError = true;
                    spanTechnology++;
                }
            }
        } 
        
        for(SurveyItem si: list_commercial){
            si.answer.Contact__c = cm.ContactId;
            si.answer.Campaign__c = cm.CampaignId;
            si.answer.Answer__c = si.theAnswer;
            list_answer2upsert.add(si.answer);
            if(!si.answer.Not_Applicable__c){
                if(si.question.Question_Type__c == '0...10' && (si.answer.Answer__c == null || si.answer.Answer__c.trim() == '')){
                    si.answer.Answer__c.addError(npsRequireLabel);
                    map_order_disError.put(si.sortOrder, '');
                    isError = true;
                    spanCommercial++;
                }
            }
        }           
        for(SurveyItem si: list_operations){
            si.answer.Contact__c = cm.ContactId;
            si.answer.Campaign__c = cm.CampaignId;
            si.answer.Answer__c = si.theAnswer;
            list_answer2upsert.add(si.answer);
            if(!si.answer.Not_Applicable__c){
                if(si.question.Question_Type__c == '0...10' && (si.answer.Answer__c == null || si.answer.Answer__c.trim() == '')){                   
                    si.answer.Answer__c.addError(npsRequireLabel);
                    map_order_disError.put(si.sortOrder, '');
                    isError = true;
                    spanOperations++;
                }
            }
        }
    
        for(SurveyItem si: list_others){
            si.answer.Contact__c = cm.ContactId;
            si.answer.Campaign__c = cm.CampaignId;
            si.answer.Answer__c = si.theAnswer;
            list_answer2upsert.add(si.answer);
            if(!si.answer.Not_Applicable__c){
                if(si.question.Question_Type__c == '0...10' && (si.answer.Answer__c == null || si.answer.Answer__c.trim() == '')){
                    si.answer.Answer__c.addError(npsRequireLabel);
                    map_order_disError.put(si.sortOrder, '');
                    isError = true;
                    spanOthers++;
                }
            }
        }
        if(isError) return;
        
        cm.Status = 'Responded';
        cm.NPS_Language__c = con.NPS_Language__c ;
        set_qIds.add(firstSurveyItem.question.Id);
        for(Answer__c a: [SELECT Campaign__c, Contact__c,  Question__c, Id,Current__c,Previous_Survey__c FROM Answer__c where Question__c in:set_qIds and Contact__c =: cm.ContactId and (Current__c = true or Previous_Survey__c = true)]){
            if(a.Previous_Survey__c){
            	a.Previous_Survey__c = false;
            }
            if(a.Current__c){
            	a.Current__c = false;
            	a.Previous_Survey__c = true;	
            }
            
            
            list_answer2upsert.add(a);
        }       
        
        try{
        	upsert list_answer2upsert;
        	update cm;
        	//update con2update;       
        }catch(Exception ex){
        	ApexPages.addMessages(ex);
        	return;
        }
        
        mode='THANKS';
    }
    
        /** 
    *    enter
    *
    @author Xia Tong
    @created 2012-12-12 
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @changelog
    * 2012-12-12 Xia Tong <xia.tong@itbconsult.com>
    * - Created
    */
    global void enter(){
        if(firstSurveyItem.question.Question_Type__c == '0...10' && (firstSurveyItem.theAnswer == null || firstSurveyItem.theAnswer.trim() == '')){
            map_order_disError.put(1, '');
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, npsRequireLabel));
            return;
        }       
        mode = 'SECOND';
        generateSurveyItems();
    }
    
    global void changeLanguage(){
    	list_operations.clear();
    	list_technology.clear();
    	list_commercial.clear();
    	list_overall.clear();
    	list_others.clear();
    	list_first.clear();   	
    	map_order_disError.clear();
    	set_qIds.clear();
        spanOverall = 0;
        spanCommercial = 0;
        spanTechnology = 0;
        spanOperations = 0;
        spanOthers = 0;
        if(con.NPS_Language__c == 'None' || con.NPS_Language__c == null){
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, getMessage('language_reqired')));
        	return;	
        }
        
        if(con.NPS_Language__c != null && con.NPS_Language__c != 'None'){
            qfield = con.NPS_Language__c +'_Question__c';
            csfield = con.NPS_Language__c +'_Value_c__c';
            getCustomLabels();
            mode = 'FIRST';
            getFirstSurveyItem();
        }else{
            mode = 'LAN';
        }
    }
    
    global void next(){
        if(con.NPS_Language__c == 'None' || con.NPS_Language__c == null){
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, getMessage('language_reqired')));
        	return;	
        }
        qfield = con.NPS_Language__c +'_Question__c';
        csfield = con.NPS_Language__c +'_Value_c__c';
        enter();     
    }
    
    global void back(){
    	for(Integer i :map_order_disError.keySet()){
    		if(map_order_disError.get(i) == '')
        	map_order_disError.put(i, 'none');
        }
        spanOverall = spanOverall_backup;
        spanCommercial = spanCommercial_backup;
        spanTechnology = spanTechnology_backup;
        spanOperations = spanOperations_backup;
        spanOthers = spanOthers_backup;
    	mode = 'FIRST';
    }
 
        /** 
    *    get labels of question Categories
    *
    @author Xia Tong
    @created 2012-12-11 
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @changelog
    * 2012-12-11 Xia Tong <xia.tong@itbconsult.com>
    * - Created
    */
    global void getCategories(){
        Schema.DescribeFieldResult fieldResult = Question__c.Category__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();  
        for( Schema.PicklistEntry f : ple){
            if(f.getValue() == 'Overall'){
                categoryOverall = f.getLabel();
            }
            if(f.getValue() == 'Operations'){
                categoryOperations = f.getLabel();
            }
            if(f.getValue() == 'Commercial'){
                categoryCommercial = f.getLabel();
            }
            if(f.getValue() == 'Technology'){
                categoryTechnology = f.getLabel();
            }
        }  
    
    }
    //********************************* -=END public methods=- ************************************   
    
    //********************************* -=BEGIN private methods=- *********************************
    private void getFirstSurveyItem(){    	
    	        
        String query = 'select id, Category__c,Active__c,Sortorder__c,Question_Type__c,' + qfield +' from Question__c where Survey__c =\'' + cm.Campaign.Survey__c +'\' and Active__c = true and Sortorder__c = 1 limit 1';
        for(Question__c q: database.query(query)){
            Sobject sq = (Sobject)q;
            firstSurveyItem = new SurveyItem(q,1,(String)sq.get(qfield));
            if(q.Category__c == 'Overall'){
                firstStyle = 'grey';
            }else if(q.Category__c == 'Operations'){
                firstStyle = 'green';
            }else if(q.Category__c == 'Commercial'){
                firstStyle = 'orange';
            }else if(q.Category__c == 'Technology'){
                firstStyle = 'blue';
            }
            list_first.add(firstSurveyItem);
          	map_order_disError.put(1, 'none');
        } 
        if(list_first.isEmpty())  mode = 'LAN'; 
    
    }
    
    private String getMessage(String name){
	    String msg = '';
	    if(map_name_customsetting.containsKey(name)){
	    	Sobject cs = (Sobject)map_name_customsetting.get(name);
	    	try{
	    		msg = (String)cs.get(csfield);
	    	}catch(Exception ex){
	    		
	    	}
	    	if(msg == null || msg == ''){
		    	msg = (String)cs.get(DEFAULT_CUSTOM_SETTING_FIELD);
		    }
	    }
	    
	    return msg;
    }
    
    private void getCustomLabels(){
    	introduceLabel = getMessage('NPS_Introduce_Label');
    	introduceBody = getMessage('NPS_Introduction_Body1') + getMessage('NPS_Introduction_Body2') + getMessage('NPS_Introduction_Body3') + getMessage('NPS_Introduction_Body4') + getMessage('NPS_Introduction_Body5') + getMessage('NPS_Introduction_Body6');
    	
	    //if(introduction != null) introduction = introduction.replace('##valued customer##',cm.Contact.Name);
    	nextBtn = getMessage('Next');
    	submitBtn = getMessage('Submit');
    	npsRequireLabel = getMessage('NPS_Required');
    	valueRequireLabel = getMessage('You_must_enter_a_value');
    	languageSelectLabel = getMessage('Select_Language');
    	extremelySatisfiedLabel = getMessage('NPS_Extremely_satisfied');
    	notSatisfiedLabel = getMessage('NPS_NOT_at_all_Satisfied');
    	thanksLabel = getMessage('NPS_Thanks1') +' ' + getMessage('NPS_Thanks2');
    	errorLabel = getMessage('Error');
    	notAppLabel = getMessage('Not_Applicable');
    	backBtn = getMessage('Back');
    	recommended = getMessage('NPS_Definitely_would_recommend');
    	notRecommended = getMessage('NPS_Definitely_would_NOT_recommend');
    	//introduction = getMessage('NPS_Salutation') + ',';
    }
   

    
        /** 
    *    generate list of survey items.
    *
    @author Xia Tong
    @created 2012-12-11 
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @changelog
    * 2012-12-11 Xia Tong <xia.tong@itbconsult.com>
    * - Created
    */
    private void generateSurveyItems(){
    	Boolean hasEnter = !list_operations.isEmpty() || !list_technology.isEmpty() || !list_commercial.isEmpty() || !list_overall.isEmpty() || !list_others.isEmpty();
    	        
        if(!hasEnter){
        	spanOverall = 0;
	        spanCommercial = 0;
	        spanTechnology = 0;
	        spanOperations = 0;
	        spanOthers = 0;
        	String query = 'select id, Category__c,Active__c,Sortorder__c,Question_Type__c,' + qfield +' from Question__c where Survey__c =\'' + cm.Campaign.Survey__c +'\' and Active__c = true and Sortorder__c!=1 order by Sortorder__c asc';
	        for(Question__c q:database.query(query)){	           
	            Sobject sq = (Sobject)q;
	            set_qIds.add(q.Id);
	            if(q.Category__c == 'Overall'){
	                spanOverall += q.Question_Type__c!='Comment'?3:2;
	                list_overall.add(new SurveyItem(q,Integer.valueOf(q.Sortorder__c),(String)sq.get(qfield)));
	            }
	            else if(q.Category__c == 'Operations'){
	                spanOperations += q.Question_Type__c!='Comment'?3:2;
	                list_operations.add(new SurveyItem(q,Integer.valueOf(q.Sortorder__c),(String)sq.get(qfield)));
	            }
	            else if(q.Category__c == 'Technology'){
	                spanTechnology += q.Question_Type__c!='Comment'?3:2;
	                list_technology.add(new SurveyItem(q,Integer.valueOf(q.Sortorder__c),(String)sq.get(qfield)));
	            }
	            else if(q.Category__c == 'Commercial'){
	                spanCommercial += q.Question_Type__c!='Comment'?3:2;
	                list_commercial.add(new SurveyItem(q,Integer.valueOf(q.Sortorder__c),(String)sq.get(qfield)));
	            }
	            else{
	                spanOthers += q.Question_Type__c!='Comment'?3:2;
	                list_others.add(new SurveyItem(q,Integer.valueOf(q.Sortorder__c),(String)sq.get(qfield)));
	            }
	            map_order_disError.put(Integer.valueOf(q.Sortorder__c), 'none');
	        }
	        if(set_qIds.isEmpty()){
	            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, getMessage('NPS_Language_Inavailable')));
	            mode = 'LAN';
	            return;
	        
	        }
	        if(!list_overall.isEmpty()){
	            list_overall.get(0).isFirst = true;
	        }
	        if(!list_operations.isEmpty()){
	            list_operations.get(0).isFirst = true;
	        }
	        if(!list_technology.isEmpty()){
	            list_technology.get(0).isFirst = true;
	        }
	        if(!list_commercial.isEmpty()){
	            list_commercial.get(0).isFirst = true;
	        }
	        if(!list_others.isEmpty()){
	            list_others.get(0).isFirst = true;
	        }	        
	        spanOverall_backup = spanOverall;
	        spanCommercial_backup = spanCommercial;
	        spanTechnology_backup = spanTechnology;
	        spanOperations_backup = spanOperations;
	        spanOthers_backup = spanOthers;
        }      
    } 
    
    
    /*global list<SelectOption> getLanguages(){
    	list<SelectOption> languages = new list<SelectOption>();
    	languages.add(new SelectOption('None','--None--'));
		Schema.DescribeFieldResult fieldResult = Contact.NPS_Language__c.getDescribe();
 		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    	for( Schema.PicklistEntry f : ple){
 			languages.add(new SelectOption(f.getValue(),getMessage(f.getValue())));	
 		}
    	return languages;
    
    } commented by xia 2013-03-15*/ 
    
    //added by xia 2013-03-15
    private list<SelectOption> getLanguageSelectOptions(){
    	list<SelectOption> result = new list<SelectOption>();
    	Sobject cs = (Sobject)map_name_customsetting.get('NPS_Language_Selection');
    	result.add(new SelectOption('None','--None--'));
		Schema.DescribeFieldResult fieldResult = Contact.NPS_Language__c.getDescribe();
 		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    	for( Schema.PicklistEntry f : ple){
 			result.add(new SelectOption(f.getValue(),(string)cs.get(f.getValue() + '_Value_c__c')));	
 		}
    	return result;
    	
    		
    
    }
    //********************************* -=END private methods=- ***********************************
        
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    global class SurveyItem{
        public Question__c question {get;set;}
        public Answer__c answer {get;set;}
        public integer sortOrder{get;set;}
        public boolean isFirst{get;set;}
        public String qString {get;set;}
        public String theAnswer {get;set;}
        public SurveyItem(Question__c q,integer i,String s){
            isFirst = false;
            question = q;
            sortOrder = i;
            qString = s;
            answer = new Answer__c();
            answer.Current__c = true;
            answer.Question__c = q.Id;
            answer.Answer_Date__c = system.today();
            //answer.Campaign__c = q.Survey__r.Campaign__c;
        }    
    }
    
    //********************************* -=END inner classes=- ***********************************  
}