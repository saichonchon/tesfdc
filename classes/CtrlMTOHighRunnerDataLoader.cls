/*------------------------------------------------------------
Author:        Bin Yuan <bin.yuan@capgemini.com>
Description:   Controller class to load MTO High Runner records in CtrlMTOHighRunnerManagement.page 
			   and import and export the csv file of MTO High Runner in CtrlMTOHighRunnerDataLoader.page.
			   The user story number is W-00152.
Inputs:        
Test Class:    CtrlMTOHighRunnerDataLoader_Test
History
2017-07-20 	   Bin Yuan <bin.yuan@capgemini.com> Created
------------------------------------------------------------*/
public with sharing class CtrlMTOHighRunnerDataLoader {
    public String str_mtoRunnerRecordsJson {get; set;}
    public String str_mtoImportFieldsMappingJson {get; set;}
    public list<MTO_High_Runner_Field_Mapping__c> list_fieldMappings {get; set;}
    public list<String> list_fileNames {get; set;}
    public list<String> list_fileNamesAfterFilter {get; set;}
    public String str_fileNamesJson {get; set;}
    public String str_mtoExportReocrdsJson {get; set;}
    public String str_lastRecordId {get; set;}
    public String str_selectedFileName {get; set;}
    public String str_newSaveFileName {get; set;}
    public String str_importResponseJson {get; set;}
    public list<MTO_High_Runner__c> list_runnerRecords {get; set;}
    public String str_tempRunnerRecordsJson {get; set;}
    private set<String> set_exportFieldsAPI = new set<String>();
    //private set<Id> set_accountIds = new set<Id>();
    private set<String> set_level7TerritoryCodes = new set<String>();
    public String currentProfile {get; set;} //added by Tangyong Li 2018-01-25
    
   /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    /*------------------------------------------------------------
	Author:        Bin Yuan <bin.yuan@capgemini.com>
	Description:   The contsructor
	Inputs:        
	Returns:       
	History
	2017-07-20 	   Bin Yuan <bin.yuan@capgemini.com> created
	------------------------------------------------------------*/
    public CtrlMTOHighRunnerDataLoader() {
		init();
    }
    
    /*------------------------------------------------------------
	Author:        Bin yuan <tangyong.li@capgemini.com>
	Description:   init Method
	Inputs:        
	Returns:       
	History
	2017-07-20 	   Bin Yuan <bin.yuan@capgemini.com> created
	------------------------------------------------------------*/
    public void init() {
    	this.str_newSaveFileName = '';
    	this.str_tempRunnerRecordsJson = '';
    	this.list_runnerRecords = new list<MTO_High_Runner__c>();
        getFieldsMapping();
        getFileNames();
        filterAccountBasedOnUser();
        filterFileNamesWithAcc();
        getCurrentProfile();
    }
    
    /*------------------------------------------------------------
	Author:        Bin yuan <tangyong.li@capgemini.com>
	Description:   Method to filter MTO High Runner based on Sales Hierarchy
	Inputs:        
	Returns:       
	History
	2017-07-20 	   Bin Yuan <bin.yuan@capgemini.com> created
	------------------------------------------------------------*/
    public void getCurrentProfile(){
    	currentProfile = '';
    	for(Profile p : [SELECT Id, Name FROM Profile WHERE Id =: UserInfo.getProfileId() limit 1]) {
    		currentProfile = p.Name;
    	}
    }
    
    /*------------------------------------------------------------
	Author:        Bin yuan <tangyong.li@capgemini.com>
	Description:   Method to filter MTO High Runner based on Sales Hierarchy
	Inputs:        
	Returns:       
	History
	2017-07-20 	   Bin Yuan <bin.yuan@capgemini.com> created
	------------------------------------------------------------*/
    public void filterAccountBasedOnUser(){
    	/*system.debug('filterAccountBasedOnUser:::');
        set<Id> set_hierarchyIds = new set<Id>();
        for(Sales_Hierarchy__c saleHrc : [Select Id, Level_7_Assigned_Users__c From Sales_Hierarchy__c]){
        	system.debug('line51:::'+saleHrc.Level_7_Assigned_Users__c);
            Set<String> set_userIds =  new Set<String>();
            if(saleHrc.Level_7_Assigned_Users__c != null && saleHrc.Level_7_Assigned_Users__c != ''){
            	system.debug('line53:::'+saleHrc.Level_7_Assigned_Users__c);
                List<String> list_userIds = saleHrc.Level_7_Assigned_Users__c.split(',');
                if(list_userIds.size() > 0) {
                    for(String userId : list_userIds){set_userIds.add(userId.trim().substring(0, 15));}
                    
                }
    
            }
            if(set_userIds.size() > 0 && set_userIds.contains(((String)UserInfo.getUserId()).substring(0, 15))) {
                set_hierarchyIds.add(saleHrc.Id);
            }
        }
        system.debug('set_hierarchyIds::::   ' + set_hierarchyIds);
        if(set_hierarchyIds.size() > 0) {
            System.debug('set_hierarchyIds' + set_hierarchyIds);
            for(Account acct : [Select Id, Sales_Hierarchy__c From Account Where Sales_Hierarchy__c in: set_hierarchyIds]){
                set_accountIds.add(acct.Id);
            }
        }
        Id currentUserId = UserInfo.getUserId();
        for(Account acct : [Select Id, OwnerId, Sales_Hierarchy__c From Account Where OwnerId =: currentUserId And Sales_Hierarchy__c = null]){
            set_accountIds.add(acct.Id);                    
        }*/
        Id currentUserId = UserInfo.getUserId();
        /*
        String likeCurrentUserId = '%' + currentUserId + '%';
        for(Account acct : [Select Id, OwnerId, Sales_Hierarchy__c From Account 
        					Where Sales_hierarchy__r.Level_7_Assigned_Users__c like: likeCurrentUserId
        					OR (OwnerId =: currentUserId AND Sales_Hierarchy__c = null)]){
           set_accountIds.add(acct.Id);
        }
        */
        
        for(Sales_Hierarchy__c sh:[select id, Level_7_Default_Owner__c,Level_7_Territory_Code__c
											from Sales_Hierarchy__c 
											where Level_7_Default_Owner__c =:currentUserId or Level_7_Assigned_Users__c =: currentUserId]){
        	set_level7TerritoryCodes.add(sh.Level_7_Territory_Code__c);
        }
    }
    
    /*------------------------------------------------------------
	Author:        Bin yuan <tangyong.li@capgemini.com>
	Description:   Method to get file names
	Inputs:        
	Returns:       
	History
	2017-07-20 	   Bin Yuan <bin.yuan@capgemini.com> created
	------------------------------------------------------------*/
    public void saveUploadFileName() {
    	try {
	    	MTO_High_Runner_File__c file = new MTO_High_Runner_File__c();
	    	file.Filename__c = this.str_newSaveFileName;
	    	insert file;
	    	if(Test.isRunningTest()){
				String str_test = (String)  Json.deserializeStrict('test class exception', list<MTO_High_Runner__c>.class);
			}
    	}catch(Exception ex) {
    		ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getStackTraceString()));
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getMessage()));
    		//ErrorLogging.Log(ex);
    		String vStrError = '';
			vStrError += 'Error Type = ' + ex.getTypeName() + 
            ' Error Line = ' + ex.getLineNumber() + '' + 
            ' Error Stack = ' + ex.getStackTraceString() + 
            ' Error Message = ' + ex.getMessage();
        	SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,                   
            	SalesforceConstant.strError, '', '', '', '5','','','Exception', ex.getLineNumber() + '',ex.getStackTraceString());
    	}
    }
    
    /*------------------------------------------------------------
	Author:        Bin yuan <tangyong.li@capgemini.com>
	Description:   Method to get file names
	Inputs:        
	Returns:       
	History
	2017-07-20 	   Bin Yuan <bin.yuan@capgemini.com> created
	------------------------------------------------------------*/
	public void getFileNames() {
		this.list_fileNames = new list<String>();
		this.str_fileNamesJson = '';
		for(MTO_High_Runner_File__c file : [Select Filename__c
										From MTO_High_Runner_File__c
										Where CreatedDate = LAST_90_DAYS 
                                        order by Createddate desc]) {
		
			if(file.Filename__c != null && file.Filename__c.trim() != '') {
				list_fileNames.add(file.Filename__c);
			}								
		}
		this.str_fileNamesJson = Json.serialize(list_fileNames);
	}
    
    /*------------------------------------------------------------
	Author:        Bin yuan <tangyong.li@capgemini.com>
	Description:   Method to get file names after filter accounts to use on management page 
	Inputs:        
	Returns:       
	History
	2017-07-20 	   Bin Yuan <bin.yuan@capgemini.com> created
	------------------------------------------------------------*/
    public void filterFileNamesWithAcc() {
        if(list_fileNames.size() >0 && set_level7TerritoryCodes.size()>0){
            list_fileNamesAfterFilter = new list<String>();
            set<String> set_filenames = new set<String>();
            set_filenames.addAll(list_fileNames);
            map<String, set<String>> map_filename_setAccIds = new map<String, set<String>>();
            
            //modified by Tangyong Li 2018-01-26
            /*for(AggregateResult result : [Select count(account__c), filename__c 
                                          From MTO_High_Runner__c 
                                          Where account__c in: set_accountIds 
                                          and filename__c in: set_filenames and CreatedDate = LAST_90_DAYS 
                                          group by filename__c]){
            	list_fileNamesAfterFilter.add(String.valueOf(result.get('filename__c')));
        	}*/
        	set<String> set_fNames = new set<String>();
            for(MTO_High_Runner__c mhr : [Select account__c, filename__c, CreatedDate 
                                          From MTO_High_Runner__c 
                                          Where (Level_7_Territory_Code__c in: set_level7TerritoryCodes or ownerId =:UserInfo.getUserId())
                                          and filename__c in: set_filenames and CreatedDate = LAST_90_DAYS 
                                          order by CreatedDate desc]){
            	if(!set_fNames.contains(mhr.filename__c)) {
            		set_fNames.add(mhr.filename__c);
	            	list_fileNamesAfterFilter.add(mhr.filename__c);
            	}
        	}
        	//end
        }
    }

    /*------------------------------------------------------------
	Author:        Bin yuan <tangyong.li@capgemini.com>
	Description:   Method to custom setting fields mapping
	Inputs:        
	Returns:       
	History
	2017-07-20 	   Bin Yuan <bin.yuan@capgemini.com> created
	------------------------------------------------------------*/
    public void getFieldsMapping() {
        this.str_mtoImportFieldsMappingJson = '';
        list_fieldMappings = new list<MTO_High_Runner_Field_Mapping__c>();
        for(MTO_High_Runner_Field_Mapping__c mapping : [Select Id, Name, API_Name__c, IsEditable__c
                                                        From MTO_High_Runner_Field_Mapping__c
                                                        Where Active__c = true
                                                        order by Column_Sequence__c asc]) {
            set_exportFieldsAPI.add(mapping.API_Name__c);
			list_fieldMappings.add(mapping);
            
        }
        this.str_mtoImportFieldsMappingJson = Json.serialize(list_fieldMappings);
        
    }
	
	/*------------------------------------------------------------
	Author:        Bin yuan <tangyong.li@capgemini.com>
	Description:   Method to import records
	Inputs:        
	Returns:       
	History
	2017-07-20 	   Bin Yuan <bin.yuan@capgemini.com> created
	------------------------------------------------------------*/
    public void importRecords() {
        try {
            Integer successCounter = 0;
            Integer errorCounter = 0;
            system.debug('str_mtoRunnerRecordsJson :: ' + str_mtoRunnerRecordsJson);
			MTOImportResult importResult = new MTOImportResult();    
			this.str_importResponseJson = '';        
            list<MTO_High_Runner__c> list_mtoRunner = new list<MTO_High_Runner__c>();
            list_mtoRunner = (list<MTO_High_Runner__c>) Json.deserializeStrict(str_mtoRunnerRecordsJson, list<MTO_High_Runner__c>.class);
            system.debug('list_mtoRunner :: ' + list_mtoRunner);
            if(!list_mtoRunner.isEmpty()) {
                //insert list_mtoRunner;
                Database.UpsertResult[] srList = Database.upsert(list_mtoRunner, MTO_High_Runner__c.Fields.External_Id__c, false);
				for (Integer counter = 0; counter < srList.size(); counter ++) {
					Database.UpsertResult sr = srList[counter];
                    if (sr.isSuccess()) {
                        successCounter ++;
                        System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                    }else {
                        for(Database.Error err : sr.getErrors()) {
                        	MTOImportError error = new MTOImportError();
                        	error.str_errorMsg = 'Line ' + (counter + 1) + ' has error code: ' + err.getStatusCode() + ': ' + err.getMessage();
							System.debug(error.str_errorMsg);
							errorCounter ++;
							importResult.list_error.add(error);
                        }
                    }
                }
                importResult.int_errorCounter = errorCounter;
                importResult.int_successCounter = successCounter;
                this.str_importResponseJson = Json.serialize(importResult);
            }
        }catch(Exception ex) {
        	system.debug('errorMessage :: ' + ex.getMessage()+ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getStackTraceString()));
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getMessage()));
        	//ErrorLogging.Log(ex);
        	String vStrError = '';
			vStrError += 'Error Type = ' + ex.getTypeName() + 
            ' Error Line = ' + ex.getLineNumber() + '' + 
            ' Error Stack = ' + ex.getStackTraceString() + 
            ' Error Message = ' + ex.getMessage();
        	SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,                   
            	SalesforceConstant.strError, '', '', '', '5','','','Exception', ex.getLineNumber() + '',ex.getStackTraceString());
        }
    }
	
	/*------------------------------------------------------------
	Author:        Yuan Yao<yuan.yao@capgemini.com>
	Description:   Method to export records for Data Loader Page
	Inputs:        
	Returns:       
	History
	2017-08-31 	   Yuan Yao<yuan.yao@capgemini.com> created
	------------------------------------------------------------*/
    public void exportRecordsForDataLoader() {
        try {
        	list<MTO_High_Runner__c> list_records = new list<MTO_High_Runner__c>();
			String str_query = ' Select ' + buildQueryString()
			 				 + ' From MTO_High_Runner__c '
			 				 + ' Where Filename__c = \'' + str_selectedFileName +'\''
			 				 + (str_lastRecordId != null && str_lastRecordId.trim() != '' ? ' And Id > \'' + str_lastRecordId + '\'' : '')
			 				 + ' order by Id asc limit 200';  			

			system.debug('str_query :: ' + str_query);
			str_lastRecordId = '';
            
 			for(MTO_High_Runner__c runner : database.query(str_query)) {
				list_records.add(runner);
				str_lastRecordId = runner.Id;
 			}
 			str_mtoExportReocrdsJson = Json.serialize(list_records);
 			if(Test.isRunningTest()){
				String str_test = (String)  Json.deserializeStrict('test class exception', list<MTO_High_Runner__c>.class);
			}
        }catch(Exception ex) {
        	system.debug('errorMessage :: ' + ex.getMessage()+ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getStackTraceString()));
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getMessage()));
        	//ErrorLogging.Log(ex);
        	String vStrError = '';
			vStrError += 'Error Type = ' + ex.getTypeName() + 
            ' Error Line = ' + ex.getLineNumber() + '' + 
            ' Error Stack = ' + ex.getStackTraceString() + 
            ' Error Message = ' + ex.getMessage();
        	SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,                   
            	SalesforceConstant.strError, '', '', '', '5','','','Exception', ex.getLineNumber() + '',ex.getStackTraceString());
        }
    }

	/*------------------------------------------------------------
	Author:        Yuan Yao<yuan.yao@capgemini.com>
	Description:   Method to export records
	Inputs:        
	Returns:       
	History
	2017-08-31 	   Yuan Yao<yuan.yao@capgemini.com> created
	------------------------------------------------------------*/
    public void exportRecords() {
		System.debug('set_level7TerritoryCodes+++' + set_level7TerritoryCodes);
        try {
        	list<MTO_High_Runner__c> list_records = new list<MTO_High_Runner__c>();
			String str_query = ' Select ' + buildQueryString()
			 				 + ' From MTO_High_Runner__c '
			 				 + ' Where Filename__c = \'' + str_selectedFileName +'\''
			 				 + (str_lastRecordId != null && str_lastRecordId.trim() != '' ? ' And Id > \'' + str_lastRecordId + '\'' : '')
			 				 + ' And (Level_7_Territory_Code__c in: set_level7TerritoryCodes or ownerId = \'' + UserInfo.getUserId() + '\') order by Id asc limit 200';  			//added by yuan yao 2017-08-25

			system.debug('str_query :: ' + str_query);
			str_lastRecordId = '';
            
 			for(MTO_High_Runner__c runner : database.query(str_query)) {
				list_records.add(runner);
				str_lastRecordId = runner.Id;
 			}
 			str_mtoExportReocrdsJson = Json.serialize(list_records);
 			if(Test.isRunningTest()){
				String str_test = (String)  Json.deserializeStrict('test class exception', list<MTO_High_Runner__c>.class);
			}
        }catch(Exception ex) {
        	system.debug('errorMessage :: ' + ex.getMessage()+ex.getStackTraceString());
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getStackTraceString()));
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getMessage()));
        	//ErrorLogging.Log(ex);
        	String vStrError = '';
			vStrError += 'Error Type = ' + ex.getTypeName() + 
            ' Error Line = ' + ex.getLineNumber() + '' + 
            ' Error Stack = ' + ex.getStackTraceString() + 
            ' Error Message = ' + ex.getMessage();
        	SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,                   
            	SalesforceConstant.strError, '', '', '', '5','','','Exception', ex.getLineNumber() + '',ex.getStackTraceString());
        }
    }
    
	/*------------------------------------------------------------
	Author:        Bin yuan <tangyong.li@capgemini.com>
	Description:   Method to import records
	Inputs:        list_mtoRunner, importResult
	Returns:       
	History
	2017-07-20 	   Bin Yuan <bin.yuan@capgemini.com> created
	------------------------------------------------------------*/
    /*public void validateMTORunnerRecords(list<MTO_High_Runner__c> list_mtoRunner, MTOImportResult importResult) {
        
        
    }*/
    
    /*------------------------------------------------------------
	Author:        Bin yuan <tangyong.li@capgemini.com>
	Description:   Method to rerender page
	Inputs:        
	Returns:       
	History
	2017-07-20 	   Bin Yuan <bin.yuan@capgemini.com> created
	------------------------------------------------------------*/
    public void reRenderPage() {
    	if(this.str_tempRunnerRecordsJson != null && this.str_tempRunnerRecordsJson.trim() != ''){
    		this.list_runnerRecords = (list<MTO_High_Runner__c>)SYSTEM.JSON.deserialize(this.str_tempRunnerRecordsJson, list<MTO_High_Runner__c>.class);
    	}else{
    		this.list_runnerRecords = new list<MTO_High_Runner__c>();
    	}
    }
    
    /*------------------------------------------------------------
	Author:        Bin yuan <tangyong.li@capgemini.com>
	Description:   Method to bulid query string
	Inputs:        
	Returns:       
	History
	2017-07-20 	   Bin Yuan <bin.yuan@capgemini.com> created
	------------------------------------------------------------*/
    public String buildQueryString() {
    	String str_queryFields = '';
    	set_exportFieldsAPI.add('Id');
    	set_exportFieldsAPI.add('Name');
    	set_exportFieldsAPI.add('External_Id__c');
        //added by yuan yao 2017-08-25
        set_exportFieldsAPI.add('Account__c');
    	
    	for(String str_api : set_exportFieldsAPI) {
    		str_queryFields += (str_api + ', ');
    	}
    	str_queryFields = str_queryFields.removeEnd(', ');
    	return str_queryFields;
    }
    
    public class MTOImportResult {
        public list<MTOImportError> list_error {get; set;}
        public Integer int_errorCounter {get; set;}
        public Integer int_successCounter {get; set;}
        
        public MTOImportResult() {
            this.list_error = new list<MTOImportError>();
            this.int_errorCounter = 0; 
            this.int_successCounter = 0; 
        }
    }
    
    public class MTOImportError {
        public String str_errorMsg {get; set;}
        
        public MTOImportError() {
            this.str_errorMsg = '';
            
        }
    }
    
}