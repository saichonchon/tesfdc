/**
 *  Contains a set of static methods used GSM Forecast VF pages
 *
 @author Bin Yuan
 @created 2013-11-25
 @version 1.0
 @since 28.0 (Force.com ApiVersion)
 *
 @changelog
 * 2013-11-25 Bin Yuan <bin.yuan@itbconsult.com>
 * - Created
 */
public class CtrlPMVCustomSettings {
   
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    public map<string,LanguageConfig> mapLCs {get;set;}
    public list<LanguageConfig> listLCs {get;set;}
    public map<string,string> map_LanguageValue_label {get;set;}
    public LanguageConfig entryLanguageConfig {get;set;}

    public map<string,string> map_RecordTypeId_Name {get;set;}
    public map<string,string> map_stageid_name {get;set;}
    
    public map<string,TeamView> mapTVs {get;set;}
    public list<TeamView> listTVs {get;set;}
    public map<string,string> map_roleid_name {get;set;}
    public TeamView entryTeamView {get;set;}
    
    
    public list<ClsPMVCustomSettingUtil.PMVRecordType> listRTs {get;set;}
    //this parameter is sales process id
    public String salesProcessId {get;set;}
    public String recordTypeId{get;set;}
    
    public List<ClsPMVCustomSettingUtil.PMVType> list_delPMVType;
    public Integer PMVTypeindex{get;set;}
    
    public string selectPMVType {get;set;}
    public Integer PMVTypeSize {get;set;}
    public string samerecordtype {get;set;}
    
    public string selectRecordType {get;set;}
    public Integer selectRecordTypeSize {get;set;}
    public list<SelectOption> allRecordType {get;set;}
    public list<SelectOption> recordtypelist {get;set;}
    
    public pageConfig pageConf{get;set;}
    transient public LocaleConfig lc {get; set;}
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- ///////////////////////////////////// 
    public CtrlPMVCustomSettings(){

    	this.PMVTypeindex = 0;
    	this.list_delPMVType = new List<ClsPMVCustomSettingUtil.PMVType>();
        this.pageConf = new pageConfig();
        this.pageConf.pageTab = 'PMV Language Config';
        selectPMVType = '';
        selectRecordType = '';
        salesProcessId = '';
        samerecordtype = '';
		PMVTypeSize = 0;
		selectRecordTypeSize = 0;
		allRecordType = getAllRecordTypeList();
        getUserRoleMap();
		
        mapLCs = new map<string,LanguageConfig>();
        listLCs = new list<LanguageConfig>();
        map_LanguageValue_label = new map<string,string>();

        map_RecordTypeId_Name = new map<string,string>();
        map_stageid_name = new map<string,string>();
        
        
        mapTVs = new map<string,TeamView>();
        listTVs = new list<TeamView>();
        
        listRTs = new list<ClsPMVCustomSettingUtil.PMVRecordType>();
        
        this.mapLCs = getLanguageConfigList();
        this.lc = new LocaleConfig();
        system.debug('###this.mapLCs : ' + this.mapLCs);
    }
    
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
    /*
     * This method is used to create a new PMV Type on Record type
     * 
     *
     @author Lei Tang
     @created 2014-04-15
     @version 1.0
     @since 27.0 (Force.com ApiVersion)
     *
     *
     @changelog
     * 2014-04-15 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public void addNewPMVType(){
    	ClsPMVCustomSettingUtil.addNewPMVType(listRTs,this.salesProcessId, this.selectPMVType);
    	selectPMVType = '';
    }
    
    
    /*
     * This method is used to select same Business Process id of Record Type
     * 
     *
     @author Lei Tang
     @created 2014-04-15
     @version 1.0
     @since 27.0 (Force.com ApiVersion)
     *
     *
     @changelog
     * 2014-04-15 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public void selectSameProcessIdByRecordType(){ 
    	samerecordtype = ClsPMVCustomSettingUtil.selectSameProcessIdByRecordType(listRTs, this.selectRecordType);
    }
    
    /*
     * This method is used to create a new Record type
     * 
     *
     @author Lei Tang
     @created 2014-04-15
     @version 1.0
     @since 27.0 (Force.com ApiVersion)
     *
     *
     @changelog
     * 2014-04-15 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public void addNewRecordType(){
    	salesProcessId = ClsPMVCustomSettingUtil.addNewRecordType(listRTs,this.selectRecordType);
    	selectRecordType = '';
    	recordtypelist = getRecordTypeList();
        selectRecordTypeSize = recordtypelist.size();
    	
    }
    
    /*
     * This method is used to get controller class for component
     * 
     *
     @author Lei Tang
     @created 2014-04-15
     @version 1.0
     @since 27.0 (Force.com ApiVersion)
     *
     *
     @changelog
     * 2014-04-15 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public CtrlPMVCustomSettings getThis(){
        return this;
    }
    
    /*
     * This method is refersh page
     * 
     *
     @author Lei Tang
     @created 2014-04-15
     @version 1.0
     @since 27.0 (Force.com ApiVersion)
     *
     *
     @changelog
     * 2014-04-15 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public void refershPage(){
        system.debug('@#this.pageConf.pageTab'+this.pageConf.pageTab);
        this.clearAllListandMap();
        if(this.pageConf.pageTab == 'PMV Language Config'){
            this.mapLCs = this.getLanguageConfigList();
        }else if(this.pageConf.pageTab == 'PMV Sales Stage'){
            //this.mapSSSs = this.getSalesStageSettingList();
            this.listRTs = ClsPMVCustomSettingUtil.getPMVRecordTypeList();
            if(listRTs != null && listRTs.size() > 0){
            	//recordTypeId = listRTs.get(0).recordTypeId;
            	salesProcessId = listRTs.get(0).salesProcessId;
            }
            
            recordtypelist = getRecordTypeList();
            system.debug('@#recordtypelist:'+recordtypelist);
            selectRecordTypeSize = recordtypelist.size();
        }else if(this.pageConf.pageTab == 'PMV Team View'){
        	this.mapTVs = this.getTeamViewList();
        }
        	
        	/*
        }else if(this.pageConf.pageTab == 'PMV Sales Process Settings'){
            this.mapSPSs = this.getSalesProcessSettingsList();
        }
        else if(this.pageConf.pageTab == 'PMV Stage Config'){
            this.mapSCs = this.getStageConfigList();
        */
    }
    
    
    public void reloadSalesStage(){
    	this.listRTs = ClsPMVCustomSettingUtil.getPMVRecordTypeList();
            if(listRTs != null && listRTs.size() > 0){
            	salesProcessId = listRTs.get(0).salesProcessId;
            }
            recordtypelist = getRecordTypeList();
            selectRecordTypeSize = recordtypelist.size();
    }
    
    public void refershRecordType(){
    	ClsPMVCustomSettingUtil.refershPMVRecordTypeList(listRTs, salesProcessId, list_delPMVType, PMVTypeindex);
    	PMVTypeindex = -1;
    }
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /*
     * This method is used to save a LanguageConfig
     * 
     *
     @author Lei Tang
     @created 2014-04-15
     @version 1.0
     @since 27.0 (Force.com ApiVersion)
     *
     *
     @changelog
     * 2014-04-15 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public void saveLanguageConfig(){

        list<PMV_Language_Config__c> list_slcs = new list<PMV_Language_Config__c>();
        PMV_Language_Config__c slc = new PMV_Language_Config__c();
        if(entryLanguageConfig.Id != ''){
            slc.Id = entryLanguageConfig.Id;
        }
        
        slc.Help_text_field__c = entryLanguageConfig.Help_text_field;
        slc.Name = entryLanguageConfig.Name;
        slc.Language__c = map_LanguageValue_label.get(entryLanguageConfig.Name);
        slc.Question_text_field__c = entryLanguageConfig.Question_text_field;
        slc.Active__c = entryLanguageConfig.Active;
        
        
        //if(slc.Id == null){
            if(!validateLanguageConfig(slc)){
            	pageConf.isError = true;
                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.CS_Same_Date_Error));
                return;
            }
        //}
        
        list_slcs.add(slc); 
        try{
        	upsert list_slcs;
        	this.mapLCs = getLanguageConfigList();
        	pageConf.isError = false;
        }catch(Exception ex){
        	pageConf.isError = true;
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
        
        
    }
    
    
    
    /*
     * This method is used to save a TeamView
     * 
     *
     @author Lei Tang
     @created 2014-04-15
     @version 1.0
     @since 27.0 (Force.com ApiVersion)
     *
     *
     @changelog
     * 2014-04-15 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public void saveTeamView(){

        list<PMV_Team_View__c> list_update = new list<PMV_Team_View__c>();
        PMV_Team_View__c temp = new PMV_Team_View__c();
        if(entryTeamView.Id != ''){
            temp.Id = entryTeamView.Id;
        }
        
        temp.Name = entryTeamView.User_Role_Id;
            
        
        temp.AvgAmountOpportunityRelationship__c = entryTeamView.AvgAmountOpportunityRelationship;
        temp.BigOpportunityAmountThreshold__c = entryTeamView.BigOpportunityAmountThreshold;
        temp.BigOpportunityCountThreshold__c = entryTeamView.BigOpportunityCountThreshold;
        temp.User_Role_Id__c = entryTeamView.User_Role_Id;
        
        
        list_update.add(temp); 
        try{ 
	        upsert list_update;
	        this.mapTVs = getTeamViewList();
        	pageConf.isError = false;
        }catch(Exception ex){
        	pageConf.isError = true;
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
    }
    
    public void saveWholeCustomSetting(){
    	//if(this.recordTypeId != '' && this.recordTypeId != null){
	    	Savepoint sp = Database.setSavepoint();
	    	try{
	    		string errormessages = '';
	    		errormessages = ClsPMVCustomSettingUtil.validateWholeCustomSetting(listRTs,this.salesProcessId);
	    		if(errormessages.length() > 0){
	    			pageConf.isError = true;
	    			integer num = 1;
	    			for(string message : errormessages.split(',')){
	    				num++;
	    				ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, message));
	    				if(num > 4){
	    					break;
	    				}
	    			}
	    			return;
	    		}
	    		//save only one section, don't delete all custom setting, delete all records with the sales process id
	    		
				
				List<Sobject> list_so = new List<Sobject>();
				
				
				map<string,string> map_RTID_SPId = new map<string, string>();
				
				//for(RecordType record : [SELECT BusinessProcessId,Id FROM RecordType Where Id = :this.recordTypeId]) {
				for(RecordType record : [SELECT BusinessProcessId,Id FROM RecordType Where IsActive = true  and BusinessProcessId != null and SobjectType = 'Opportunity' ]) {
		            map_RTID_SPId.put(record.Id,record.BusinessProcessId);
		        }
		        
		        set<string> set_rtids = new set<string>();
		        set<string> set_bpids = new set<string>();
		        for(ClsPMVCustomSettingUtil.PMVRecordType srt : listRTs){
		        	for(ClsPMVCustomSettingUtil.PMVRecordTypeMap rt : srt.recordTypeLists){
		        		set_rtids.add(rt.recordTypeId);
		        	}
		        	set_bpids.add(srt.salesProcessId);
		        }
		        
		        
		        
				for(Opportunity_Record_Type_Groups__c rt : [SELECT Id 
		        											FROM Opportunity_Record_Type_Groups__c
		        											where RecordTypeID__c IN :set_rtids]){
        			list_so.add(rt);									
        		}
        		for(PMV_Sales_Process_Settings__c sps : [SELECT Id 
		                                                  FROM PMV_Sales_Process_Settings__c 
		                                                  WHERE Sales_Process_ID__c IN :set_bpids]){
		            
		            list_so.add(sps);
		        }
		        for(PMV_Stage_Config__c ssc : [SELECT Id FROM PMV_Stage_Config__c
                                                WHERE Business_ProcessID__c IN :set_bpids]){

		            list_so.add(ssc);
		        }
				for(PMV_Sales_Stage_Setting__c ssss : [SELECT Id
		                                                  FROM PMV_Sales_Stage_Setting__c  
		                                                  WHERE Sales_Process_ID__c IN :set_bpids]){
            
		            list_so.add(ssss);
		        }
		        if(list_so.size() > 0) delete list_so;
		        list_so.clear();
		        //added by Jinbo Shan 2014-06-26 because the System.TypeException: Cannot have more than 10 chunks in a single operation. 
		        list<Opportunity_Record_Type_Groups__c> list_ortgs = new list<Opportunity_Record_Type_Groups__c>();
		        list<PMV_Stage_Config__c> list_pscs = new list<PMV_Stage_Config__c>();
		        list<PMV_Sales_Process_Settings__c> list_psps = new list<PMV_Sales_Process_Settings__c>();
		        list<PMV_Sales_Stage_Setting__c> list_psss = new list<PMV_Sales_Stage_Setting__c>();
		        
		        for(ClsPMVCustomSettingUtil.PMVRecordType srt : listRTs){
		        	//if(srt.recordTypeId == this.recordTypeId){
		        	for(ClsPMVCustomSettingUtil.PMVRecordTypeMap rt : srt.recordTypeLists){
		        		Opportunity_Record_Type_Groups__c ortg = new Opportunity_Record_Type_Groups__c();
						ortg.RecordTypeID__c = rt.recordTypeId;
						ortg.Active__c = rt.Active;
						ortg.Default_Record_Type_Lead_Conversion__c = rt.LeadConversion;
						ortg.Group__c = 'PMV';
						ortg.Is_Sales_Only__c = rt.IsSalesOnly;
						ortg.Migration_Record_Type__c = String.join(rt.MigrationRecordType,',');
						ortg.Name = rt.recordTypeName;
						list_ortgs.add(ortg);
		        	}	
		        	
					for(ClsPMVCustomSettingUtil.PMVStage stage : srt.PMVstageList){
						PMV_Stage_Config__c ssc = new PMV_Stage_Config__c();
						ssc.Business_ProcessID__c = stage.Business_ProcessID;
						ssc.Name = stage.stageId + stage.Business_ProcessID;
						ssc.Stage_Id__c = stage.stageId;
						ssc.Stage_Name__c = stage.stageName;
						list_pscs.add(ssc);
					}
						
					for(ClsPMVCustomSettingUtil.PMVType st : srt.PMVTypeList){
						PMV_Sales_Process_Settings__c ssps = new PMV_Sales_Process_Settings__c();
						ssps.Approval_Status_for_Snapshots__c = String.join(st.Approval_Status_for_Snapshots,',');
						ssps.Sales_Process_ID__c = st.Sales_Process_ID;
						ssps.Deal_Size_Max__c = st.Deal_Size_Max;
						ssps.Deal_Size_Min__c = st.Deal_Size_Min;
						ssps.GIBU__c = String.join(st.GIBU,',');
						ssps.Name = st.Sales_Process_ID.subString(12,18) + st.PMV_Type;
						ssps.PMV_Type__c = st.PMV_Type;
						ssps.PMV_Type_Initialization__c = st.PMV_Type_Initialization; 
						ssps.Subvertical_BU__c = String.join(st.Subvertical_BU,',');
						ssps.ProjectedToClose_Threshold__c = st.ProjectedToClose_Threshold;
						list_psps.add(ssps);
						
							for(ClsPMVCustomSettingUtil.PMVSalesStageSetting ssstages : st.PMVSalesStageSettingList){
								PMV_Sales_Stage_Setting__c ssss = new PMV_Sales_Stage_Setting__c();
								ssss.Active__c = true;
								ssss.Average_Duration__c = ssstages.Average_Duration;
								ssss.Buyer_Cycle__c = ssstages.Buyer_Cycle;
								ssss.Completion_Threshold__c = ssstages.Completion_Threshold;
								ssss.Dead_Lost_Stage__c = ssstages.Dead_Lost_Stage;
								ssss.Name = ssstages.Sales_Process_ID.subString(10,18) + ssstages.Sales_Stage.substring(0,3) + ssstages.PMV_Type.substring(0,3) + String.valueOf(Math.random()*100000).substring(0,5);
								ssss.On_Hold_Stage__c = ssstages.On_Hold_Stage;
								ssss.Opportunity_Parts_Confidence__c = ssstages.Opportunity_Parts_Confidence;
								ssss.Opportunity_Parts_Process_Status__c = ssstages.Opportunity_Parts_Process_Status;
								ssss.Priority_Stage__c = ssstages.Priority_Stage;
								ssss.Production_Stage__c = ssstages.Production_Stage;
								ssss.Sales_Process_ID__c = ssstages.Sales_Process_ID;
								ssss.Sales_Stage__c = ssstages.Sales_Stage;
								ssss.PMV_Type__c = ssstages.PMV_Type;
								ssss.Team_View_Column__c = ssstages.Team_View_Column;
								ssss.Won_Stage__c = ssstages.Won_Stage;
								list_psss.add(ssss);
							}
						}
						
						
						//break;
		        	//}
					
				}
				if(list_ortgs.size() > 0) {
					insert list_ortgs;
				}
				if(list_pscs.size() > 0) {
					insert list_pscs;
				}
				if(list_psps.size() > 0) {
					insert list_psps;
				}
				if(list_psss.size() > 0) {
					insert list_psss;
				}
	    	}
	    	catch(Exception ex){
	    		ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
	    		Database.rollback(sp);
	    	}
    	//}
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /*
     * This method is used to delete a LanguageConfig
     * 
     *
     @author Lei Tang
     @created 2014-04-15
     @version 1.0
     @since 27.0 (Force.com ApiVersion)
     *
     *
     @changelog
     * 2014-04-15 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public void deleteLanguageConfig(){
        try{
            list<PMV_Language_Config__c> list_slcsdel = new list<PMV_Language_Config__c>();
            for(PMV_Language_Config__c temp : [SELECT Id 
                                                FROM PMV_Language_Config__c 
                                                Where Id = :pageConf.recordId]){
                list_slcsdel.add(temp);
            }
            if(list_slcsdel.size() > 0) delete list_slcsdel;
            this.mapLCs = getLanguageConfigList();
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
    }

    /*
     * This method is used to delete a TeamView
     * 
     *
     @author Lei Tang
     @created 2014-04-15
     @version 1.0
     @since 27.0 (Force.com ApiVersion)
     *
     *
     @changelog
     * 2014-04-15 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public void deleteTeamView(){
        try{
            list<PMV_Team_View__c> list_del = new list<PMV_Team_View__c>();
            for(PMV_Team_View__c temp : [SELECT Id 
                                                FROM PMV_Team_View__c 
                                                Where Id = :pageConf.recordId]){
                list_del.add(temp);
            }
            if(list_del.size() > 0) delete list_del;
            this.mapTVs = getTeamViewList();
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
    }
    
    /*
     * This method is used to delete a Record Type Group
     * 
     *
     @author Lei Tang
     @created 2014-04-15
     @version 1.0
     @since 27.0 (Force.com ApiVersion)
     *
     *
     @changelog
     * 2014-04-15 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public void deleteRecordType(){
    	try{
            if(this.recordTypeId != '' && this.recordTypeId != null){
		    	Savepoint sp = Database.setSavepoint();
		    	try{
		    		string deleteid = '';
		    		String salesProcessId = '';
		    		List<Sobject> list_so = new List<Sobject>();
		    		for(ClsPMVCustomSettingUtil.PMVRecordType PMVrt : listRTs){
						list<ClsPMVCustomSettingUtil.PMVRecordTypeMap> relist = new list<ClsPMVCustomSettingUtil.PMVRecordTypeMap>();
		    			for(ClsPMVCustomSettingUtil.PMVRecordTypeMap rt : PMVrt.recordTypeLists){
			    			if(rt.recordTypeId == this.recordTypeId){
			    				deleteid = rt.recordTypeGroupId;
			    				
			    			}else{
			    				relist.add(rt);
			    			}
		    			}
		    			
		    			PMVrt.recordTypeLists = relist;
		    			
		    			if(PMVrt.recordTypeLists.size() == 0){
							for(PMV_Sales_Process_Settings__c sps : [SELECT Id 
					                                                  FROM PMV_Sales_Process_Settings__c 
					                                                  WHERE Sales_Process_ID__c = :PMVrt.salesProcessId]){
					            list_so.add(sps);
					        }
					        for(PMV_Stage_Config__c ssc : [SELECT Id FROM PMV_Stage_Config__c
			                                                WHERE Business_ProcessID__c = :PMVrt.salesProcessId]){
					            list_so.add(ssc);
					        }
							for(PMV_Sales_Stage_Setting__c ssss : [SELECT Id
					                                                  FROM PMV_Sales_Stage_Setting__c  
					                                                  WHERE Sales_Process_ID__c = :PMVrt.salesProcessId]){
					            list_so.add(ssss);
					        }
				        }
		    		}

					if(deleteid != ''){
						for(Opportunity_Record_Type_Groups__c rt : [SELECT Id 
				        											FROM Opportunity_Record_Type_Groups__c
				        											where Id = :deleteid]){
		        			list_so.add(rt);									
		        		}
			        }
					
					if(list_so.size() > 0) delete list_so;
				        list_so.clear();
				        
				    refershPage();
			        
		    	}
		    	catch(Exception ex){
		    		ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
		    		Database.rollback(sp);
		    	}
	    	}
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }

    }
    
    
    public void deletePMVType(){
    	try{
            if(this.salesProcessId != '' && this.salesProcessId != null && PMVTypeindex !=null && PMVTypeindex >= -1){
		    	
		    	ClsPMVCustomSettingUtil.refershPMVRecordTypeList(listRTs,salesProcessId,list_delPMVType,PMVTypeindex );
		    	PMVTypeindex = -1;
	    	}
            
            
            
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
    	
    }
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public list<SelectOption> getRecordTypeList(){
    	list<SelectOption> list_picklistValues = new list<SelectOption>();
    	
    	set<string> set_selectedPMVRT = new set<string>();
        
        for(ClsPMVCustomSettingUtil.PMVRecordType PMVrt : listRTs){
        	for(ClsPMVCustomSettingUtil.PMVRecordTypeMap rtmap : PMVrt.recordTypeLists){
        		set_selectedPMVRT.add(rtmap.recordTypeId);
        	}
        }

    	for(SelectOption record : allRecordType) {
    		if(!set_selectedPMVRT.contains(record.getValue())){
    			list_picklistValues.add(record);
    		}
            
        }
        return list_picklistValues;
    }
    
    public list<SelectOption> getAllRecordTypeList(){
    	list<SelectOption> list_picklistValues = new list<SelectOption>();
    	
    	for(RecordType record : [SELECT  Name, Id FROM RecordType where IsActive = true  and BusinessProcessId != null and SobjectType = 'Opportunity'  order by CreatedDate asc]) {
    		list_picklistValues.add(new Selectoption(record.Id, record.Name));
        }
        return list_picklistValues;
    }
    
    /*
     * This method is used to get User LanguageLocaleKey picklist
     * Table 1 -- Name
     *
     @author Lei Tang
     @created 2014-04-15
     @version 1.0
     @since 27.0 (Force.com ApiVersion)
     *
     *
     @changelog
     * 2014-04-15 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public list<SelectOption> getLanguageConfigName(){
        
        map_LanguageValue_label = getPicklistValues(User.LanguageLocaleKey.getDescribe());
        list<SelectOption> list_picklistValues = new list<SelectOption>();
        list_picklistValues.add(new Selectoption('', '--None--'));
        for(string value : map_LanguageValue_label.keySet()){
            list_picklistValues.add(new Selectoption(value, map_LanguageValue_label.get(value)));
        }
        
        return list_picklistValues;
    }
    
    /*
     * This method is used to get Quality_Assessment_Question__c field list 
     * Table 1 -- Question text field
     *
     @author Lei Tang
     @created 2014-04-15
     @version 1.0
     @since 27.0 (Force.com ApiVersion)
     *
     *
     @changelog
     * 2014-04-15 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public list<SelectOption> getQuestiontextfield(){
        
        list<SelectOption> list_picklistValues = new list<SelectOption>();
        map<string,string> map_value_label = getsObjectFieldList(Quality_Assessment_Question__c.sObjectType.getDescribe(),'Question_');
        //list_picklistValues.add(new Selectoption('', '--None--'));
        for (string value : map_value_label.keySet()){
            list_picklistValues.add(new Selectoption(value, value));
        }        
        return list_picklistValues;

    }
    
    /*
     * This method is used to get Quality_Assessment_Question__c field list 
     * Table 1 -- Help text field
     *
     @author Lei Tang
     @created 2014-04-15
     @version 1.0
     @since 27.0 (Force.com ApiVersion)
     *
     *
     @changelog
     * 2014-04-15 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public list<SelectOption> getHelptextfield(){
        
        list<SelectOption> list_picklistValues = new list<SelectOption>();
        map<string,string> map_value_label = getsObjectFieldList(Quality_Assessment_Question__c.sObjectType.getDescribe(),'Help_Comment_');
        //list_picklistValues.add(new Selectoption('', '--None--'));
        for (string value : map_value_label.keySet()){
            list_picklistValues.add(new Selectoption(value, value));
        }        
        return list_picklistValues;

    }
    
    /*
     * This method is used to get Opportunity field Approval_Status_PMV__c picklist
     * Table 2 -- Approval_Status_PMV__c  -- multiple selection
     *
     @author Lei Tang
     @created 2014-04-15
     @version 1.0
     @since 27.0 (Force.com ApiVersion)
     *
     *
     @changelog
     * 2014-04-15 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public list<SelectOption> getApprovalStatusPMV(){
        
        map_LanguageValue_label = getPicklistValues(Opportunity.Approval_Status_PMV__c.getDescribe());
        list<SelectOption> list_picklistValues = new list<SelectOption>();
        //list_picklistValues.add(new Selectoption('', '--None--'));
        for(string value : map_LanguageValue_label.keySet()){
            list_picklistValues.add(new Selectoption(value, map_LanguageValue_label.get(value)));
        }
        
        return list_picklistValues;
    }
    
    /*
     * This method is used to get Opportunity field PMV_Type__c picklist
     * Table 2 -- PMV Type 
     *
     @author Lei Tang
     @created 2014-04-15
     @version 1.0
     @since 27.0 (Force.com ApiVersion)
     *
     *
     @changelog
     * 2014-04-15 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public list<SelectOption> getPMVType(){
        
        map_LanguageValue_label = getPicklistValues(Opportunity.PMV_Type__c.getDescribe());
        list<SelectOption> list_picklistValues = new list<SelectOption>();
        set<string> set_selectedPMVtype = new set<string>();
        
        for(ClsPMVCustomSettingUtil.PMVRecordType PMVrt : listRTs){
        	if(PMVrt.salesProcessId == this.salesProcessId){
        		for(ClsPMVCustomSettingUtil.PMVType PMVtype : PMVrt.PMVTypeList){
        			set_selectedPMVtype.add(PMVtype.PMV_Type);
        		}
        	}
        }
        system.debug('@#set_selectedPMVtype:'+set_selectedPMVtype);
        for(string value : map_LanguageValue_label.keySet()){
        	if(!set_selectedPMVtype.contains(value)){
        		list_picklistValues.add(new Selectoption(value, map_LanguageValue_label.get(value)));
        	}

        }
        
        PMVTypeSize = list_picklistValues.size();
        return list_picklistValues;
    }
    
    /*
     * This method is used to get User field GIBU__c picklist
     * Table 2 -- GIBU  -- multiple selection
     *
     @author Lei Tang
     @created 2014-04-15
     @version 1.0
     @since 27.0 (Force.com ApiVersion)
     *
     *
     @changelog
     * 2014-04-15 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public list<SelectOption> getGIBU(){
        
        map_LanguageValue_label = getPicklistValues(User.GIBU__c.getDescribe());
        list<SelectOption> list_picklistValues = new list<SelectOption>();
        //list_picklistValues.add(new Selectoption('', '--None--'));
        for(string value : map_LanguageValue_label.keySet()){
            list_picklistValues.add(new Selectoption(value, map_LanguageValue_label.get(value)));
        }
        
        return list_picklistValues;
    }
    
    /*
     * This method is used to get User field Sub_Vertical__c picklist
     * Table 2 -- Sub Vertical BU  -- multiple selection
     *
     @author Lei Tang
     @created 2014-04-15
     @version 1.0
     @since 27.0 (Force.com ApiVersion)
     *
     *
     @changelog
     * 2014-04-15 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public list<SelectOption> getSubVerticalBU(){
        
        map_LanguageValue_label = getPicklistValues(User.Sub_Vertical__c.getDescribe());
        list<SelectOption> list_picklistValues = new list<SelectOption>();
        //list_picklistValues.add(new Selectoption('', '--None--'));
        for(string value : map_LanguageValue_label.keySet()){
            list_picklistValues.add(new Selectoption(value, map_LanguageValue_label.get(value)));
        }
        
        return list_picklistValues;
    }
    
    /*
     * This method is used to get User field PMV_Type_Initialization__c picklist
     * Table 2 -- PMV Type Initialization -- multiple selection
     *
     @author Lei Tang
     @created 2014-04-15
     @version 1.0
     @since 27.0 (Force.com ApiVersion)
     *
     *
     @changelog
     * 2014-04-15 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public list<SelectOption> getPMVTypeInitialization(){
        
        list<SelectOption> list_picklistValues = new list<SelectOption>();
        //list_picklistValues.add(new Selectoption('', '--None--'));
        list_picklistValues.add(new Selectoption('Standard', 'Standard'));
        list_picklistValues.add(new Selectoption('China', 'China'));

        return list_picklistValues;
    }
    
    /*
     * This method is used to get Sales Process Id list
     * Table 2 -- Sales Process ID
     *
     @author Lei Tang
     @created 2014-04-15
     @version 1.0
     @since 27.0 (Force.com ApiVersion)
     *
     *
     @changelog
     * 2014-04-15 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public list<SelectOption> getSalesProcessID(){
        set<Id> set_RecordtypeId = ClsPMV_Util.getAllPMVRecordtypes();
        set<Id> set_bpId = new set<Id>();
        list<SelectOption> list_picklistValues = new list<SelectOption>();
        
        list_picklistValues.add(new Selectoption('', '--None--'));
        for(RecordType record : [SELECT BusinessProcessId,  Name, Id FROM RecordType Where Id IN :set_RecordtypeId]) {
            set_bpId.add(record.BusinessProcessId);
        }
        
        for(BusinessProcess bp : [SELECT Id, Name FROM BusinessProcess where IsActive = true and Id IN :set_bpId]){
            list_picklistValues.add(new Selectoption(bp.Id, bp.Name));
        }
        
        return list_picklistValues;
    }
    
    /*
     * This method is used to get User Role list
     * Table 2 -- User Role id
     *
     @author Lei Tang
     @created 2014-04-15
     @version 1.0
     @since 27.0 (Force.com ApiVersion)
     *
     *
     @changelog
     * 2014-04-15 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public list<SelectOption> getUserRoleid(){
        list<SelectOption> list_picklistValues = new list<SelectOption>();
        list_picklistValues.add(new Selectoption('', '--None--'));
        for(string roleid : map_roleid_name.keySet()) {
            list_picklistValues.add(new Selectoption(roleid, map_roleid_name.get(roleid)));
        }

        return list_picklistValues;
    }
    
    /*
     * This method is used to get Team View Column list
     * Table 3 -- Team View Column
     *
     @author Lei Tang
     @created 2014-04-15
     @version 1.0
     @since 27.0 (Force.com ApiVersion)
     *
     *
     @changelog
     * 2014-04-15 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public list<SelectOption> getTeamViewColumn(){
        list<SelectOption> list_picklistValues = new list<SelectOption>();
        list_picklistValues.add(new Selectoption('', '--None--'));
        
        list_picklistValues.add(new Selectoption('Converted', 'Converted'));
        list_picklistValues.add(new Selectoption('Won', 'Won'));
        list_picklistValues.add(new Selectoption('Pending', 'Pending'));
        list_picklistValues.add(new Selectoption('On Hold', 'On Hold'));

        return list_picklistValues;
    }
    
    
    /*
     * This method is used to get Opportunity_Part__c field Status__c picklist
     * Table 3 -- Opportunity Parts Confidence
     *
     @author Lei Tang
     @created 2014-04-15
     @version 1.0
     @since 27.0 (Force.com ApiVersion)
     *
     *
     @changelog
     * 2014-04-15 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public list<SelectOption> getOpportunityPartsConfidence(){
        
        map_LanguageValue_label = getPicklistValues(Opportunity_Part__c.Status__c.getDescribe());
        list<SelectOption> list_picklistValues = new list<SelectOption>();
        list_picklistValues.add(new Selectoption('', '--None--'));
        for(string value : map_LanguageValue_label.keySet()){
            list_picklistValues.add(new Selectoption(value, map_LanguageValue_label.get(value)));
        }
        
        return list_picklistValues;
    }
    
    
    /*
     * This method is used to get Opportunity_Part__c field Process_Status__c picklist
     * Table 3 -- Opportunity Parts Process Status
     *
     @author Lei Tang
     @created 2014-04-15
     @version 1.0
     @since 27.0 (Force.com ApiVersion)
     *
     *
     @changelog
     * 2014-04-15 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public list<SelectOption> getOpportunityPartsProcessStatus(){
        
        map_LanguageValue_label = getPicklistValues(Opportunity_Part__c.Process_Status__c.getDescribe());
        list<SelectOption> list_picklistValues = new list<SelectOption>();
        list_picklistValues.add(new Selectoption('', '--None--'));
        for(string value : map_LanguageValue_label.keySet()){
            list_picklistValues.add(new Selectoption(value, map_LanguageValue_label.get(value)));
        }
        
        return list_picklistValues;
    }
    
    
    /*
     * This method is used to get Opportunity field Buying_Cycle__c picklist
     * Table 3 -- Buyer Cycle
     *
     @author Lei Tang
     @created 2014-04-15
     @version 1.0
     @since 27.0 (Force.com ApiVersion)
     *
     *
     @changelog
     * 2014-04-15 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public list<SelectOption> getBuyerCycle(){
        
        map_LanguageValue_label = getPicklistValues(Opportunity.Buying_Cycle__c.getDescribe());
        list<SelectOption> list_picklistValues = new list<SelectOption>();
        list_picklistValues.add(new Selectoption('', '--None--'));
        for(string value : map_LanguageValue_label.keySet()){
            list_picklistValues.add(new Selectoption(value, map_LanguageValue_label.get(value)));
        }
        
        return list_picklistValues;
    }
    
    /*
     * This method is used to get User field Stage_Id__c picklist
     * Table 3 -- Sales Stage
     *
     @author Lei Tang
     @created 2014-04-15
     @version 1.0
     @since 27.0 (Force.com ApiVersion)
     *
     *
     @changelog
     * 2014-04-15 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public list<SelectOption> getSalesStage(){
        
        //map_stageid_name = new map<string,string>();
        list<SelectOption> list_picklistValues = new list<SelectOption>();
        list_picklistValues.add(new Selectoption('', '--None--'));
        for(OpportunityStage qs : [SELECT MasterLabel, Id FROM OpportunityStage where isActive=true and MasterLabel Not IN ('Dead','Lost','On Hold') order by SortOrder asc]){
            list_picklistValues.add(new Selectoption(qs.MasterLabel, qs.MasterLabel));
            //map_stageid_name.put(qs.Id, qs.MasterLabel);
        }

        return list_picklistValues;
    }
    
    
    /*
     * This method is used to get User field Stage_Id__c picklist
     * Table 4 -- Stage_Name 
     *
     @author Lei Tang
     @created 2014-04-15
     @version 1.0
     @since 27.0 (Force.com ApiVersion)
     *
     *
     @changelog
     * 2014-04-15 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public list<SelectOption> getStageName(){
        
        map_stageid_name = new map<string,string>();
        list<SelectOption> list_picklistValues = new list<SelectOption>();
        list_picklistValues.add(new Selectoption('', '--None--'));
        for(OpportunityStage qs : [SELECT MasterLabel, Id FROM OpportunityStage where isActive=true order by SortOrder asc]){
            list_picklistValues.add(new Selectoption(qs.Id, qs.MasterLabel));
            map_stageid_name.put(qs.Id, qs.MasterLabel);
        }

        return list_picklistValues;
    }
    
    
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    /*
     * This method is used to edit and new button
     * 
     *
     @author Lei Tang
     @created 2014-04-15
     @version 1.0
     @since 27.0 (Force.com ApiVersion)
     *
     *
     @changelog
     * 2014-04-15 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    public void initialRecord(){
        
        Boolean isEdit = false;
        if(this.pageConf.recordId != '') isEdit = true;
        if(isEdit){
            if(this.pageConf.pageTab == 'PMV Language Config'){
                editLanguageConfig(this.pageConf.recordId);
            }
            else if(this.pageConf.pageTab == 'PMV Team View'){
            	editTeamView(this.pageConf.recordId);
            }
            /*	
            }else if(this.pageConf.pageTab == 'PMV Sales Process Settings'){
                editSalesProcessSettings(this.pageConf.recordId);
            }else if(this.pageConf.pageTab == 'PMV Sales Stage Setting'){
                editSalesStageSetting(this.pageConf.recordId);
            }else if(this.pageConf.pageTab == 'PMV Stage Config'){
                editStageConfig(this.pageConf.recordId);
           */
        }else{
            if(this.pageConf.pageTab == 'PMV Language Config'){
                newLanguageConfig();
            }else if(this.pageConf.pageTab == 'PMV Team View'){
            	newTeamView();
            }
            /*
            }else if(this.pageConf.pageTab == 'PMV Sales Process Settings'){
                newSalesProcessSettings();
            }else if(this.pageConf.pageTab == 'PMV Sales Stage Setting'){
                newSalesStageSetting();
            }else if(this.pageConf.pageTab == 'PMV Stage Config'){
                newStageConfig();
            */
        }
    }
    
    //********************************* -=END public methods=- **************************************
    
    
    //********************************* -=BEGIN private methods=- ***********************************   

    private map<string,LanguageConfig> getLanguageConfigList(){
        map<string,LanguageConfig> maptemp = new map<string,LanguageConfig>();
        for(PMV_Language_Config__c slc : [SELECT Active__c, Help_text_field__c, Language__c, Name, Question_text_field__c, Id FROM PMV_Language_Config__c order by CreatedDate asc]){
            LanguageConfig lc = new LanguageConfig(slc);
            maptemp.put(slc.Id,lc);
        }
        listLCs = maptemp.values();
        return maptemp;
    }
    
    
    
    private map<string,TeamView> getTeamViewList(){
        map<string,TeamView> maptemp = new map<string,TeamView>();
        for(PMV_Team_View__c ssc : [SELECT AvgAmountOpportunityRelationship__c, BigOpportunityAmountThreshold__c, BigOpportunityCountThreshold__c
        								  , Name, Id, User_Role_Id__c 
        								FROM PMV_Team_View__c
                                        order by CreatedDate asc]){
            TeamView sc = new TeamView(ssc, map_roleid_name);
            maptemp.put(ssc.Id,sc);
        }
        listTVs = maptemp.values();
        return maptemp;
    }
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /*
     * This method is used to edit LanguageConfig
     * 
     *
     @author Lei Tang
     @created 2014-04-15
     @version 1.0
     @since 27.0 (Force.com ApiVersion)
     *
     *
     @changelog
     * 2014-04-15 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    private void editLanguageConfig(String id){
        if(id != null && id != ''){
            entryLanguageConfig = mapLCs.get(id);
        }
    }
    
    /*
     * This method is used to create a LanguageConfig
     * 
     *
     @author Lei Tang
     @created 2014-04-15
     @version 1.0
     @since 27.0 (Force.com ApiVersion)
     *
     *
     @changelog
     * 2014-04-15 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    private void newLanguageConfig(){
        entryLanguageConfig = new LanguageConfig();
    }
    
    
    
    /*
     * This method is used to edit TeamView
     * 
     *
     @author Lei Tang
     @created 2014-04-15
     @version 1.0
     @since 27.0 (Force.com ApiVersion)
     *
     *
     @changelog
     * 2014-04-15 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    private void editTeamView(String id){
        if(id != null && id != ''){
            entryTeamView = mapTVs.get(id);
        }
    }
    
    /*
     * This method is used to create a TeamView
     * 
     *
     @author Lei Tang
     @created 2014-04-15
     @version 1.0
     @since 27.0 (Force.com ApiVersion)
     *
     *
     @changelog
     * 2014-04-15 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    private void newTeamView(){
        entryTeamView = new TeamView();
    }
    

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    /*
     * This method is used to validate PMV_Language_Config__c Can not be repeated
     * 
     *
     @author Lei Tang
     @created 2014-04-15
     @version 1.0
     @since 27.0 (Force.com ApiVersion)
     *
     *
     @changelog
     * 2014-04-15 Lei Tang <lei.tang@itbconsult.com>
     * - Created
     *
    */
    private Boolean validateLanguageConfig(PMV_Language_Config__c slc){
        
        Boolean isSuccess = true;
        if(slc.Id != null && slc.Id != ''){
	        for(PMV_Language_Config__c temp : [SELECT Id FROM PMV_Language_Config__c Where Name = :slc.Name and Id != :slc.Id]){
		        isSuccess = false;
		    }
        }else{
	        for(PMV_Language_Config__c temp : [SELECT Id FROM PMV_Language_Config__c Where Name = :slc.Name]){
		        isSuccess = false;
		    }
        }
        
        return isSuccess;
    }
    
    
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    private map<string,string> getPicklistValues(Schema.DescribeFieldResult dfr){        
        
        list<Schema.PicklistEntry> list_values = dfr.getPicklistValues();
        map<string,string> map_value_label = new map<string,string>();
        for (Schema.PicklistEntry pe : list_values){
            if(pe.getLabel() == null)
                map_value_label.put(pe.getValue(), pe.getValue());
            else
                map_value_label.put(pe.getValue(), pe.getLabel()); 
        }        
        return map_value_label;
    }
    
    
    private map<string,string> getsObjectFieldList(Schema.DescribeSObjectResult dsr,String hardstring){        
        
        map<string,string> map_value_label = new map<string,string>();
        map<String, Schema.SObjectField> map_allFieldsOnVisit = new map<String, Schema.SObjectField>();
        map_allFieldsOnVisit = dsr.fields.getMap();

        for (Schema.SObjectField sof : map_allFieldsOnVisit.values()){
            if(sof.getDescribe().getName().indexOf(hardstring) == 0){
                map_value_label.put(sof.getDescribe().getName(), sof.getDescribe().getName());
            }
        }        
        return map_value_label;
    }
    
    private void getUserRoleMap(){
    	map_roleid_name = new map<string,string>();
        
        for(UserRole role : [SELECT  Id, Name FROM UserRole order by Id asc]) {
        	map_roleid_name.put(role.Id, role.Name);
            
        }
        
    }
    
    
    
    private void clearAllListandMap(){
        this.mapLCs.clear();
        this.listLCs.clear();
        
        this.mapTVs.clear();
        this.listTVs.clear();
    }
    
    
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN inner classes=- ***********************************
    
    public class pageConfig{
        public String recordId {get;set;}
        public String pageTab {get;set;}
        public Boolean isError {get;set;}
        
        public pageConfig(){
            this.recordId = '';
            this.pageTab = '';
            this.isError = false;
        }
    }
    
    
    /*
    * Correspond PMV_Language_Config__c 
    */
    public class LanguageConfig{
        public String Id {get;set;}
        public String Name {get;set;}
        public Boolean Active {get;set;}
        public String Help_text_field {get;set;}
        public String Language {get;set;}
        public String Question_text_field {get;set;}
        
        public LanguageConfig(){
            this.Id = '';
            this.Name = '';
            this.Active = false;
            this.Help_text_field = '';
            this.Language = '';
            this.Question_text_field = '';
        }
        
        public LanguageConfig(PMV_Language_Config__c slc){
            this.Id = slc.Id;
            this.Name = slc.Name;
            this.Active = slc.Active__c;
            this.Help_text_field = slc.Help_text_field__c;
            this.Language = slc.Language__c;
            this.Question_text_field = slc.Question_text_field__c;

        }
        
    }

    
    /*
    * Correspond PMV_Team_View__c 
    */
    public class TeamView{
    	public string Id {get;set;}
    	public double AvgAmountOpportunityRelationship {get;set;}
    	public double BigOpportunityAmountThreshold {get;set;}
    	public double BigOpportunityCountThreshold {get;set;}
    	public string User_Role_Id {get;set;}
    	public string UserRoleName {get;set;}
    	public string Name {get;set;}
    	
    	public TeamView(){
    		this.AvgAmountOpportunityRelationship = 0;
            this.BigOpportunityAmountThreshold = 0;
            this.BigOpportunityCountThreshold = 0;
           	this.User_Role_Id = '';
           	this.UserRoleName = '';
            this.Id = '';
            this.Name = '';
    	}
    	
    	public TeamView(PMV_Team_View__c tv,map<string,string> map_role_name){
    		this.AvgAmountOpportunityRelationship = tv.AvgAmountOpportunityRelationship__c;
            this.BigOpportunityAmountThreshold = tv.BigOpportunityAmountThreshold__c;
            this.BigOpportunityCountThreshold = tv.BigOpportunityCountThreshold__c;
           	this.User_Role_Id = tv.User_Role_Id__c;
           	this.UserRoleName = map_role_name.get(tv.User_Role_Id__c);
            this.Id = tv.Id;
            this.Name = tv.Name;
    	}
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
    //
    //
    
    //********************************* -=END inner classes=- *************************************
}