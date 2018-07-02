public without sharing class ClsPMVCustomSettingUtil {
	
	
	
	public static String validateWholeCustomSetting(list<PMVRecordType> PMVRecordTypeList, String salesProcessId){
		string errormessage = '';
		
		Boolean isdef = false;
		
		for(ClsPMVCustomSettingUtil.PMVRecordType srt : PMVRecordTypeList){
			//if(srt.salesProcessId == salesProcessId){
				if(srt.PMVstageList.size() == 0){
					errormessage += ',This Stage can not be empty.';
				}
				
				//Boolean isdef = false;
				
				for(PMVRecordTypeMap rtmap : srt.recordTypeLists){
					system.debug('**@@isdef = ' + isdef);
					system.debug('**@@rtmap.LeadConversion = ' + rtmap.LeadConversion);
					if(!isdef && rtmap.LeadConversion){
						isdef = true;
						continue;
					}
					system.debug('**@@isdef = ' + isdef);
					system.debug('**@@rtmap.LeadConversion = ' + rtmap.LeadConversion);
					if(isdef && rtmap.LeadConversion){
						errormessage += ',Please only set one record type as the default record type for lead conversion.';
						break;
					}
					
				}
				system.debug('**@@isdef = ' + isdef);
				/*if(!isdef){
					errormessage += ',Please set a Lead Conversion value of one Record Type.';
				}*/
				

				set<string> listvalidate = new set<string>();
				if(srt.PMVTypeList.size() == 0){
					errormessage += ',Please add a PMV Type.';
				}
				
				
				for(ClsPMVCustomSettingUtil.PMVType st : srt.PMVTypeList){

					if(st.Deal_Size_Max < st.Deal_Size_Min){
						errormessage += ','+system.label.Deal_Size_Max_Bigger;
					}
					 
					if(st.GIBU.size() == 0){
						errormessage += ',This '+st.PMVTypeName+' GIBU can not be empty.';
					}
					
					if(st.PMV_Type_Initialization == ''){
						errormessage += ',This '+st.PMVTypeName+' PMV_Type_Initialization can not be empty.';
					}
					
					if(st.Subvertical_BU.size() == 0){
						errormessage += ',This '+st.PMVTypeName+' Subvertical_BU can not be empty.';
					}
					
					/*if(st.Approval_Status_for_Snapshots.size() == 0){
						errormessage += ',This '+st.PMVTypeName+' Approval_Status_for_Snapshots can not be empty.';
					}*/
					
					/*for(ClsPMVCustomSettingUtil.PMVSalesStageSetting ssstages : st.PMVSalesStageSettingList){
										
						if(ssstages.Sales_Stage != 'On Hold' || ssstages.Sales_Stage != 'Lost' || ssstages.Sales_Stage != 'Dead'){
							if(ssstages.Team_View_Column == ''){
								errormessage += ',This '+ssstages.salesStageName+' Team_View_Column can not be empty.';
							}
						}
						if(ssstages.Sales_Stage != 'Lost' || ssstages.Sales_Stage != 'Dead'){
							if(ssstages.Opportunity_Parts_Confidence == ''){
								errormessage += ',This '+ssstages.salesStageName+' Opportunity_Parts_Confidence can not be empty.';
							}
							
							if(ssstages.Opportunity_Parts_Process_Status == ''){
								errormessage += ',This '+ssstages.salesStageName+' Opportunity_Parts_Process_Status can not be empty.';
							}
						}
					}*/
					
					string ss = '';
					for(string s1 : st.GIBU){
						for(string s2 : st.Subvertical_BU){
							//for(string s3 : st.PMV_Type_Initialization){
							string s3 = st.PMV_Type_Initialization;
								ss = s1+','+s2+','+s3;
								if(listvalidate.contains(ss)){
									errormessage += ',This Stage GIBU, Initialization and Subvertical BU has the same combination('+ss+').';
								}else{
									listvalidate.add(ss);
								}
							//}
							
						}
					}
				}
		    //}
		}
		/*Start:added by Jinbo Shan 2015-04-21*/
		if(!isdef){
			errormessage += ',Please only set one record type as the default record type for lead conversion.';
		}
		/*End:added by Jinbo Shan 2015-04-21*/
		if(errormessage.length() > 0){
			errormessage = errormessage.substring(1,errormessage.length());
		}
		
		return errormessage;
	}
	
	
	public static void refershPMVRecordTypeList(list<PMVRecordType> PMVRecordTypeList, String salesProcessId,List<ClsPMVCustomSettingUtil.PMVType> list_del,Integer idx){
		
		//map<string, map<string, string>> map_RTId_SPIdName = getBusinessProcessMap();
		//list<Opportunity_Record_Type_Groups__c> listRTs = getRecordTypeList();
		//list<PMV_Sales_Process_Settings__c> listSPSs = getSalesProcessSettingsList();
		//list<PMV_Stage_Config__c> listSCs = getStageConfigList();
		list<PMV_Sales_Stage_Setting__c> listSSSs = getSalesStageSettingList();
		system.debug('@#salesProcessId:'+salesProcessId);
		for(PMVRecordType PMVRT : PMVRecordTypeList){
			system.debug('@#PMVRT.salesProcessId:'+PMVRT.salesProcessId);
			if(salesProcessId == PMVRT.salesProcessId){
				/*if(map_RTId_SPIdName.get(PMVRT.recordTypeId) != null && map_RTId_SPIdName.get(PMVRT.recordTypeId).size() > 0 ){
					for(string key : map_RTId_SPIdName.get(PMVRT.recordTypeId).keySet()){
						PMVRT.salesProcessId = key;
						PMVRT.salesProcessName = map_RTId_SPIdName.get(PMVRT.recordTypeId).get(key);
					}
				}*/
				list<PMVStage> newPMVStage = new list<PMVStage>();
				set<String> set_stageName = new set<String>();
				map<String, String> map_stageId_stageName = new map<String, String>();
				system.debug('@#PMVRT.selectstages:'+PMVRT.selectstages);
				if(PMVRT.selectstages != null) {
					List<String> list_stage = PMVRT.selectstages.split(',');
					for(String s: list_stage){
						if(!String.isEmpty(s) && s.length() > 0){
							
							list<String> list_re = s.split(':');
							if(list_re.size()>1){
								PMVStage stage = new PMVStage(PMVRT.salesProcessId);
								stage.stageId = list_re[0];
								stage.stageName = list_re[1];
								newPMVStage.add(stage);
								map_stageId_stageName.put(stage.stageId,stage.stageName);
								set_stageName.add(stage.stageName);
							}
						}
					}
				}
				system.debug('@#newPMVStage'+newPMVStage);
				PMVRT.PMVstageList = newPMVStage;
				if(map_stageId_stageName.isEmpty()){
					ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'It is not allowed to remove all stages!'));
					break;
				}
				else{
					List<PMVType> list_PMVTypeContains = new List<PMVType>();
					for(PMVType st : PMVRT.PMVTypeList){
						if(st.index != idx){ //not deleted
							List<PMVSalesStageSetting> list_ssssTemp = new List<PMVSalesStageSetting>();
							set<String> set_stageNew = new set<String>();
							set_stageNew.addAll(set_stageName);
							for(PMVSalesStageSetting ssss : st.PMVSalesStageSettingList){
								if(set_stageName.contains(ssss.Sales_Stage) ){
									list_ssssTemp.add(ssss);
									set_stageNew.remove(ssss.Sales_Stage);
								}
								
								if(ssss.Sales_Stage == 'Dead' || ssss.Sales_Stage == 'Lost' || ssss.Sales_Stage == 'On Hold'){
									list_ssssTemp.add(ssss);
								}
							}
							system.debug('@#set_stageNew'+set_stageNew);
							if(!set_stageNew.isEmpty()){
								for(String stage : set_stageNew){
									Boolean isFind = false;
									for(PMV_Sales_Stage_Setting__c ssss : listSSSs){
										if(ssss.Sales_Process_ID__c == PMVRT.salesProcessId && ssss.Sales_Stage__c == stage && ssss.PMV_Type__c == st.PMV_Type){
											PMVSalesStageSetting ssssetting = new PMVSalesStageSetting(ssss);
											list_ssssTemp.add(ssssetting);
											isFind = true;
										}
									}
									if(!isFind){
										PMVSalesStageSetting ssss = new PMVSalesStageSetting(PMVRT.salesProcessId,stage,st.PMV_Type);
										list_ssssTemp.add(ssss);
									}
									
								}
							}

							system.debug('@#list_ssssTemp'+list_ssssTemp);
							st.PMVSalesStageSettingList = list_ssssTemp;
							st.PMVSalesStageSettingList.sort();
							list_PMVTypeContains.add(st);
						}
						else{
							list_del.add(st);
						}
					}
					Integer idxParam = 0;
					for(PMVType st : list_PMVTypeContains){
						st.index = idxParam;
						idxParam++;
					}
					PMVRT.PMVTypeList = list_PMVTypeContains;
					PMVRT.getPMVType();
				}
				break;
			}
		}
	}
	
	public static string selectSameProcessIdByRecordType(list<PMVRecordType> PMVRecordTypeList, String recordTypeId){
		string salesprocessid = '';
		String rtlist = '';
		set<string> recordtypeids = new set<string>();

		for(PMVRecordType PMVrt : PMVRecordTypeList){
			for(PMVRecordTypeMap rt : PMVrt.recordTypeLists){
				recordtypeids.add(rt.recordTypeId);
			}
		}

		for(RecordType record : [SELECT BusinessProcessId,  Name, Id FROM RecordType Where Id = :recordTypeId ]) {
            salesprocessid = record.BusinessProcessId;
        }
        
        Integer recordnum = 0;
        for(RecordType record : [SELECT BusinessProcessId,  Name, Id FROM RecordType Where BusinessProcessId = :salesprocessid and Id not IN :recordtypeids]) {
			rtlist += ',' + record.Name;
			recordnum++;
        }
        if(recordnum > 2 ) {
	        if(rtlist.length() > 0){
	        	rtlist = rtlist.substring(1,rtlist.length());
	        }
        } else {
        	rtlist = '';
        }
        
        
        return rtlist;
	}
	
	
	public static string addNewRecordType(list<PMVRecordType> PMVRecordTypeList, String recordTypeId){
		list<SelectOption> listSelectRT = getAllRecordTypeList();
		string allstagesList = getAllStageList();
		
		string recordtypename = '';
		string salesprocessid = '';
		string salesprocessname = '';
		set<string> recordtypeids = new set<string>();

		for(PMVRecordType PMVrt : PMVRecordTypeList){
			for(PMVRecordTypeMap rt : PMVrt.recordTypeLists){
				recordtypeids.add(rt.recordTypeId);
			}
		}
		
		
		for(RecordType record : [SELECT BusinessProcessId,  Name, Id FROM RecordType Where Id = :recordTypeId]) {
			recordtypename = record.name;
            salesprocessid = record.BusinessProcessId;
        }
        
        list<RecordType> rtlist = new list<RecordType>();
        for(RecordType record : [SELECT BusinessProcessId,  Name, Id FROM RecordType Where BusinessProcessId = :salesprocessid and Id not IN :recordtypeids]) {
			rtlist.add(record);
        }
        
        
        for(BusinessProcess bp : [SELECT Id, Name FROM BusinessProcess where IsActive = true and Id = :salesprocessid]){
            salesprocessname = bp.Name;
        }
		
		
		Boolean isSameProcess = false;
		for(PMVRecordType PMVrt : PMVRecordTypeList){
			if(PMVrt.salesProcessId == salesprocessid){
				isSameProcess = true;
				for(RecordType record : rtlist){
					PMVRecordTypeMap rtmap = new PMVRecordTypeMap(record.Id,record.Name);
					PMVrt.recordTypeLists.add(rtmap);
				}
			}

		}
		
		if(!isSameProcess){
			PMVRecordType PMVRT = new PMVRecordType(allstagesList,listSelectRT);
			//PMVRT.recordTypeId = recordTypeId;
			//PMVRT.recordTypeName = recordtypename;
			PMVRT.salesProcessId = salesprocessid;
			PMVRT.salesProcessName = salesprocessname;
			for(RecordType record : rtlist){
				PMVRecordTypeMap rtmap = new PMVRecordTypeMap(record.ID,record.Name);
				PMVrt.recordTypeLists.add(rtmap);
			}
			PMVRecordTypeList.add(PMVRT);
		}
		
		return salesprocessid;
	}
	
	
	public static void addNewPMVType(list<PMVRecordType> PMVRecordTypeList, String salesProcessId, String selectPMVType){
		for(PMVRecordType PMVRT : PMVRecordTypeList){
			if(salesProcessId == PMVRT.salesProcessId){
				Integer idx = PMVRT.PMVTypeList.size() + 1;
				PMVType st = new PMVType(PMVRT.salesProcessId, idx, selectPMVType);
				
				list<PMVSalesStageSetting> newssssList = new list<PMVSalesStageSetting>();
				//add PMV Sales Stage Setting
				for(PMVStage PMVstage :  PMVRT.PMVstageList){
					PMVSalesStageSetting ssss = new PMVSalesStageSetting(PMVRT.salesProcessId, PMVstage.stageName, st.PMV_Type);
					newssssList.add(ssss);
				}
						
				PMVSalesStageSetting ssssDead = new PMVSalesStageSetting(PMVRT.salesProcessId, 'Dead', st.PMV_Type);
				PMVSalesStageSetting ssssLost = new PMVSalesStageSetting(PMVRT.salesProcessId, 'Lost', st.PMV_Type);
				PMVSalesStageSetting ssssOnHold = new PMVSalesStageSetting(PMVRT.salesProcessId, 'On Hold', st.PMV_Type);
						
				newssssList.add(ssssDead);
				newssssList.add(ssssLost);
				newssssList.add(ssssOnHold);

				st.PMVSalesStageSettingList = newssssList;
				st.PMVSalesStageSettingList.sort();

				PMVRT.PMVTypeList.add(st);
				PMVRT.getPMVType();
				break;
			}
		}
	}
	
	
	
	
	
	public static list<PMVRecordType> getPMVRecordTypeList(){
		list<PMVRecordType> PMVRecordTypeList = new list<PMVRecordType>();
		
		list<Opportunity_Record_Type_Groups__c> listRTs = getRecordTypeList();
		list<PMV_Sales_Process_Settings__c> listSPSs = getSalesProcessSettingsList();
		list<PMV_Stage_Config__c> listSCs = getStageConfigList();
		list<PMV_Sales_Stage_Setting__c> listSSSs = getSalesStageSettingList();
		map<string, map<string, string>> map_RTId_SPIdName = getBusinessProcessMap();
		list<SelectOption> listSelectRT = getAllRecordTypeList();
		
		string allstagesList = getAllStageList();
		
		system.debug('@#map_RTId_SPIdName : '+map_RTId_SPIdName);
		for(Opportunity_Record_Type_Groups__c rt :listRTs){
			boolean isSameRT = false;
			
			if(map_RTId_SPIdName.get(rt.RecordTypeID__c) != null ){
				for(PMVRecordType srt : PMVRecordTypeList){
					if(map_RTId_SPIdName.get(rt.RecordTypeID__c).containsKey(srt.salesProcessId)){
						isSameRT = true;
						
						PMVRecordTypeMap PMVrecordtypemap = new PMVRecordTypeMap(rt);
						srt.recordTypeLists.add(PMVrecordtypemap);
						
					}
				}
			}
			if(!isSameRT){
				PMVRecordType PMVRT = new PMVRecordType(rt,listSPSs,listSCs,listSSSs,map_RTId_SPIdName,allstagesList,listSelectRT);
				PMVRecordTypeList.add(PMVRT);
			}
		}

		return PMVRecordTypeList;
	}
	
	
	
	public static list<Opportunity_Record_Type_Groups__c> getRecordTypeList(){
        list<Opportunity_Record_Type_Groups__c> listtemp = new list<Opportunity_Record_Type_Groups__c>();
        for(Opportunity_Record_Type_Groups__c rt : [SELECT Active__c, Migration_Record_Type__c, Default_Record_Type_Lead_Conversion__c, Is_Sales_Only__c, Name, Id, RecordTypeID__c 
        											FROM Opportunity_Record_Type_Groups__c
        											where Group__c = 'PMV'
        											order by CreatedDate asc]){
            
            listtemp.add(rt);
        }
        return listtemp;
    }
    
    
    public static map<string,string> getPicklistValues(Schema.DescribeFieldResult dfr){        
        
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
    
	
	private static list<PMV_Sales_Process_Settings__c> getSalesProcessSettingsList(){
        list<PMV_Sales_Process_Settings__c> maptemp = new list<PMV_Sales_Process_Settings__c>();
        for(PMV_Sales_Process_Settings__c sps : [SELECT Approval_Status_for_Snapshots__c, Category__c,  Deal_Size_Max__c, Deal_Size_Min__c, IsDeleted, GIBU__c
                                                    , Name, ProjectedToClose_Threshold__c, Id, PMV_Type__c, PMV_Type_Initialization__c, Sales_Process_ID__c
                                                    , Subvertical_BU__c 
                                                  FROM PMV_Sales_Process_Settings__c 
                                                  order by CreatedDate asc]){
            
            maptemp.add(sps);
        }
        return maptemp;
    }
    
    private static list<PMV_Stage_Config__c> getStageConfigList(){
        list<PMV_Stage_Config__c> maptemp = new list<PMV_Stage_Config__c>();
        for(PMV_Stage_Config__c ssc : [SELECT Business_ProcessID__c, Name, Id, Stage_Id__c, Stage_Name__c FROM PMV_Stage_Config__c
                                                order by CreatedDate asc]){

            maptemp.add(ssc);
        }
        return maptemp;
    }
    
    private static list<PMV_Sales_Stage_Setting__c> getSalesStageSettingList(){
        list<PMV_Sales_Stage_Setting__c> maptemp = new list<PMV_Sales_Stage_Setting__c>();
        for(PMV_Sales_Stage_Setting__c ssss : [SELECT Active__c, Average_Duration__c, Buyer_Cycle__c, Completion_Threshold__c,    Dead_Lost_Stage__c
                                                    , SetupOwnerId, Name, On_Hold_Stage__c, Opportunity_Parts_Confidence__c
                                                    , Opportunity_Parts_Process_Status__c, Priority_Stage__c, Production_Stage__c, Id, PMV_Type__c
                                                    , Sales_Process_ID__c, Sales_Stage__c,  Team_View_Column__c, Won_Stage__c 
                                                  FROM PMV_Sales_Stage_Setting__c  
                                                  order by CreatedDate asc]){
            
            maptemp.add(ssss);
        }
        
        return maptemp;
    }

    private static map<string,  map<string,string>> getBusinessProcessMap(){
    
    	set<Id> set_bpId = new set<Id>();
		
		map<string, map<string,string>> map_RTID_SPIdName = new map<string, map<string,string>>();


    	for(RecordType record : [SELECT BusinessProcessId,  Name, Id FROM RecordType Where IsActive = true  and BusinessProcessId != null and SobjectType = 'Opportunity']) {
            set_bpId.add(record.BusinessProcessId);
            map<string, string> map_SPID_Name = new map<string, string>();
            map_SPID_Name.put(record.BusinessProcessId,'');
            map_RTID_SPIdName.put(record.Id,map_SPID_Name);
        }
        
        for(BusinessProcess bp : [SELECT Id, Name FROM BusinessProcess where Id IN :set_bpId]){
        	for(map<string, string> maptemp : map_RTID_SPIdName.values()){
        		if(maptemp.containsKey(bp.Id)){
        			maptemp.put(bp.Id,bp.Name);
        		}
        	}  
        }
        return map_RTID_SPIdName;
    }
   
    
    
    /*
	* This method is get all RVL user list 
	* 
	*
	@author Lei Tang
	@created 2014-04-01
	@version 1.0
	@since 27.0 (Force.com ApiVersion)
	*
	@return 				String
	*
	@changelog
	* 2014-04-01 Lei Tang <lei.tang@itbconsult.com>
	* - Created
	*
	*/
	private static list<SelectOption> getAllRecordTypeList(){

		list<SelectOption> list_picklistValues = new list<SelectOption>();
        for(RecordType temprt : [SELECT Name, Id FROM RecordType where IsActive = true and BusinessProcessId != null and SobjectType = 'Opportunity' and developerName like 'IND%']){
            list_picklistValues.add(new Selectoption(temprt.Id, temprt.Name));
        }

        return list_picklistValues;
	}
    
    
	/*
	* This method is get Stag list 
	* 
	*
	@author Lei Tang
	@created 2014-04-01
	@version 1.0
	@since 27.0 (Force.com ApiVersion)
	*
	@return 				String
	*
	@changelog
	* 2014-04-01 Lei Tang <lei.tang@itbconsult.com>
	* - Created
	*
	*/
	private static String getAllStageList(){
		
		String selectre = '';

		for(OpportunityStage qs : [SELECT MasterLabel, Id FROM OpportunityStage where isActive=true and MasterLabel not IN ('Dead','Lost','On Hold')  order by SortOrder asc]){
			selectre += ','+qs.Id+':'
					+ qs.MasterLabel ;
		}
		if(selectre.length()>0){
			selectre= selectre.substring(1,selectre.length());
		}
		return selectre;
	}
	
	
	//********************************* -=BEGIN inner classes=- ***********************************
	
	public class PMVRecordType{
		//public string Id {get;set;}
		//public String recordTypeId {get;set;}
		public String recordTypeName {
			get{
				if(recordTypeLists.size()==0){
					return '';
				}else{
					string temp = '';
					for(PMVRecordTypeMap rtmap : recordTypeLists){
						temp += ', '+rtmap.recordTypeName;
					}
					if(temp.length() > 0 ) temp = temp.substring(1,temp.length());
					return temp;
				}
				
			}
			
		}
		
		public list<PMVRecordTypeMap> recordTypeLists {get;set;} 
		
		
		public String salesProcessId {get;set;}		//auto
		public String salesProcessName {get;set;}	//auto
		public Boolean Active {get;set;}
		public Boolean LeadConversion {get;set;}
		public Boolean IsSalesOnly {get;set;}
		
		public string[] MigrationRecordType	{get;set;}
		
		public string selectstages {get;set;}
		public list<SelectOption> selectStagelist {get;set;}
		public list<SelectOption> unSelectStagelist {get;set;}
		public list<SelectOption> listSelectRT {get;set;}
		
		public list<SelectOption> selectPMVTpye {get;set;}
		public Integer selectPMVTpyeSize {get{if(selectPMVTpye!=null){return selectPMVTpye.size();}else{return 0;}}}
		
		public list<PMVStage> PMVstageList {get;set;}
		public list<PMVType> PMVTypeList {get;set;}
		
		public PMVRecordType(string allstagesList,list<SelectOption> listSelectRTs){
			//Id = '';
			//recordTypeId = '';
			//recordTypeName = '';
			salesProcessId = '';
			salesProcessName = '';
			Active = false;
			LeadConversion = false;
			IsSalesOnly = false;
			selectstages = '';
			recordTypeLists = new list<PMVRecordTypeMap>();
			MigrationRecordType = new string[]{};
			
			PMVstageList = new list<PMVStage>();
			PMVTypeList = new list<PMVType>();
			selectStagelist = new list<SelectOption>();
			unSelectStagelist = getUnselectedStage(allstagesList);
			listSelectRT = listSelectRTs;
			
			this.getPMVType();
		}
		
		public PMVRecordType(Opportunity_Record_Type_Groups__c rt,list<PMV_Sales_Process_Settings__c> listSPSs ,list<PMV_Stage_Config__c> listSCs 
								,list<PMV_Sales_Stage_Setting__c> listSSSs ,map<string, map<string, string>> map_RTId_SPIdName,string allstagesList
								,list<SelectOption> listSelectRTs){
			//Id = rt.Id;			
			//recordTypeId = rt.RecordTypeID__c;
			//recordTypeName = rt.Name;
			
			recordTypeLists = new list<PMVRecordTypeMap>();
			PMVRecordTypeMap rtmap = new PMVRecordTypeMap(rt);
			recordTypeLists.add(rtmap);
			
			if(map_RTId_SPIdName.get(rt.RecordTypeID__c) != null && map_RTId_SPIdName.get(rt.RecordTypeID__c).size() > 0 ){
				for(string key : map_RTId_SPIdName.get(rt.RecordTypeID__c).keySet()){
					salesProcessId = key;
					salesProcessName = map_RTId_SPIdName.get(rt.RecordTypeID__c).get(key);
				}
			}
			Active = rt.Active__c;
			LeadConversion = rt.Default_Record_Type_Lead_Conversion__c;
			IsSalesOnly = rt.Is_Sales_Only__c;
			
			MigrationRecordType = new string[]{};
			if(rt.Migration_Record_Type__c != null && rt.Migration_Record_Type__c.length() > 0){
                MigrationRecordType = rt.Migration_Record_Type__c.split(',');
            }
			
			selectstages = '';
			PMVstageList = new list<PMVStage>();
			for(PMV_Stage_Config__c stage : listSCs){
				if(stage.Business_ProcessID__c == salesProcessId){
					PMVStage PMVStage = new PMVStage(stage);
					if(PMVStage.stageName != 'Dead' &&  PMVStage.stageName != 'Lost' && PMVStage.stageName != 'On Hold'){
						selectstages += ','+ PMVStage.stageId +':'+PMVStage.stageName;
						PMVstageList.add(PMVStage);
					}
				}
			}
			
			if(selectstages.length() > 0){
				selectstages= selectstages.substring(1,selectstages.length());
			}
			selectStagelist = getSelectedStage();
			unSelectStagelist = getUnselectedStage(allstagesList);
			listSelectRT = listSelectRTs;
			
			PMVTypeList = new list<PMVType>();
			Integer idx = 0;
			for(PMV_Sales_Process_Settings__c sps : listSPSs){
				if(sps.Sales_Process_ID__c == salesProcessId){
					
					PMVType PMVType = new PMVType(sps,listSSSs,idx);
					PMVTypeList.add(PMVType);
					idx++;
				}
			}
			
			this.getPMVType();
		}
		
		
		/**
		@author Lei Tang
		@created 2013-10-08
		@version 1.0
		@since 28.0 (Force.com ApiVersion)
		*
		@return	Pagereference
		*
		@changelog
		* 2013-10-15 Lei Tang <lei.tang@itbconsult.com> 
		* - Created
		*/
	    public List<SelectOption> getSelectedStage() {
			List<SelectOption> options = new List<Selectoption>();		
			if(this.selectstages != null) {
				List<String> list_stage = this.selectstages.split(',');
				list_stage.sort();
				for(String s: list_stage){
					if(!String.isEmpty(s) && s.length() > 0){
						list<String> list_re = s.split(':');
						if(list_re.size()>1)
							options.add(new Selectoption(s,list_re[1]));
					}
				}
			}
			return options;
		}
		
		public List<SelectOption> getUnselectedStage(string allstagesList) {
			List<SelectOption> options = new List<Selectoption>();
			String allstages = allstagesList;
			if(allstages != null && allstages.trim().length() > 0) {
				List<String> list_stage = allstages.split(',');
				list_stage.sort();
					
				Set<String> selected = new Set<String>();	
				if(selectstages != null) 
					selected.addAll(this.selectstages.split(','));
						
				for(String s: list_stage) {
					if( !String.isEmpty(s) && s.length() > 0 && !selected.contains(s) ) {
						list<String> list_re = s.split(':');
						if(list_re.size()>1)
							options.add(new Selectoption(s,list_re[1]));
					}
				} 
			}
	
			return options;	
		}
		
		
		public void getPMVType(){
        
	        map<string,string> map_Value_label = ClsPMVCustomSettingUtil.getPicklistValues(Opportunity.PMV_Type__c.getDescribe());
	        list<SelectOption> list_picklistValues = new list<SelectOption>();
	        set<string> set_selectedPMVtype = new set<string>();
	        
	        for(ClsPMVCustomSettingUtil.PMVType PMVtype : this.PMVTypeList){
	        	set_selectedPMVtype.add(PMVtype.PMV_Type);
	        }

	        system.debug('@#set_selectedPMVtype:'+set_selectedPMVtype);
	        for(string value : map_Value_label.keySet()){
	        	if(!set_selectedPMVtype.contains(value)){
	        		list_picklistValues.add(new Selectoption(value, map_Value_label.get(value)));
	        	}
	
	        }
	        this.selectPMVTpye = list_picklistValues;
	        
	        //return list_picklistValues;
	    }
		
	}
	
	public class PMVRecordTypeMap{
		public String recordTypeId {get;set;}
		public String recordTypeName {get;set;}
		public string recordTypeGroupId {get;set;}
		
		public Boolean Active {get;set;}
		public Boolean LeadConversion {get;set;}
		public Boolean IsSalesOnly {get;set;}
		
		public string[] MigrationRecordType	{get;set;}
		
		public PMVRecordTypeMap(string rTId,string rTName){
			this.recordTypeId = rTId;
			this.recordTypeName = rTName;
			this.recordTypeGroupId = '';
			
			this.Active = false;
			this.LeadConversion = false;
			this.IsSalesOnly = false;
			this.MigrationRecordType = new String[]{};
		} 
		
		
		public PMVRecordTypeMap(Opportunity_Record_Type_Groups__c rt){
			this.recordTypeId = rt.RecordTypeID__c;
			this.recordTypeName = rt.Name;
			this.recordTypeGroupId = rt.Id;
			
			this.Active = rt.Active__c;
			this.LeadConversion = rt.Default_Record_Type_Lead_Conversion__c;
			this.IsSalesOnly = rt.Is_Sales_Only__c;
			
			MigrationRecordType = new string[]{};
			if(rt.Migration_Record_Type__c != null && rt.Migration_Record_Type__c.length() > 0){
                MigrationRecordType = rt.Migration_Record_Type__c.split(',');
            }
		}
	}
	
	
	
	public class PMVStage{
		public String stageId {get;set;}
		public String stageName {get;set;}
		public string Business_ProcessID {get;set;}
		
		public PMVStage(string bpid){
			stageId = '';
			stageName = '';
			Business_ProcessID = bpid;
			
		} 
		
		
		public PMVStage(PMV_Stage_Config__c sc){
			this.Business_ProcessID = sc.Business_ProcessID__c;
            this.stageId = sc.Stage_Id__c;
            this.stageName = sc.Stage_Name__c;
		}
		
	}
	
	public class PMVType{
		public String PMVTypeId {get;set;}	//auto
		public String PMVTypeName {get;set;}//auto
		public string Sales_Process_ID {get;set;}
		public string PMV_Type {get;set;}
		
		public string[] Approval_Status_for_Snapshots {get;set;}
		public string[] GIBU {get;set;}
		//public string[] PMV_Type_Initialization {get;set;}
		public string PMV_Type_Initialization {get;set;}
		public string[] Subvertical_BU {get;set;}

        //public string Approval_Status_for_Snapshots_showtext {get;set;}
        //public string GIBU_showtext {get;set;}
        //public string Subvertical_BU_showtext {get;set;}
        //public string PMV_Type_Initialization_showtext {get;set;}
        
        public double Deal_Size_Max {get;set;}
        public double Deal_Size_Min {get;set;}
        public double ProjectedToClose_Threshold {get;set;}
        
        public Integer index{get;set;}
        
		public list<PMVSalesStageSetting> PMVSalesStageSettingList {get;set;}
		
		public PMVType(string spid, Integer indexParam, String selectPMVType){
			Sales_Process_ID = spid;
			this.PMVTypeId = '';
            this.PMVTypeName = '';
            this.PMV_Type = selectPMVType;
            this.Deal_Size_Max = 0;
            this.Deal_Size_Min = 0;
            this.ProjectedToClose_Threshold = 0;
            this.PMV_Type_Initialization = '';
            this.Subvertical_BU = new string[]{};
            this.GIBU  = new string[]{};
            this.Approval_Status_for_Snapshots = new string[]{};
            this.index = indexParam;
            
            PMVSalesStageSettingList = new list<PMVSalesStageSetting>();
		}
		
		public PMVType(PMV_Sales_Process_Settings__c ssps,list<PMV_Sales_Stage_Setting__c> listSSSs, Integer indexParam ){
			this.Sales_Process_ID = ssps.Sales_Process_ID__c;
            this.PMVTypeId = ssps.Id;
            this.PMVTypeName = ssps.Name;
			this.PMV_Type = ssps.PMV_Type__c;
            this.Deal_Size_Max = ssps.Deal_Size_Max__c;
            this.Deal_Size_Min = ssps.Deal_Size_Min__c;
            this.ProjectedToClose_Threshold = ssps.ProjectedToClose_Threshold__c;
            
            string[] SubverticalBUs = new string[]{};
            if(ssps.Subvertical_BU__c != null && ssps.Subvertical_BU__c.length() > 0){
                SubverticalBUs = ssps.Subvertical_BU__c.split(',');
            }
            this.Subvertical_BU = SubverticalBUs;
            
            
            this.PMV_Type_Initialization = ssps.PMV_Type_Initialization__c;
            
            string[] GIBUs = new string[]{};
            if(ssps.GIBU__c != null && ssps.GIBU__c.length() > 0){
                GIBUs = ssps.GIBU__c.split(',');
            }
            this.GIBU  = GIBUs;
            
            string[] ApprovalStatusforSnapshots = new string[]{};
            if(ssps.Approval_Status_for_Snapshots__c != null && ssps.Approval_Status_for_Snapshots__c.length() > 0){
                ApprovalStatusforSnapshots = ssps.Approval_Status_for_Snapshots__c.split(',');
            }
            this.Approval_Status_for_Snapshots = ApprovalStatusforSnapshots;
            
            PMVSalesStageSettingList = new list<PMVSalesStageSetting>();
            for(PMV_Sales_Stage_Setting__c sss : listSSSs){
            	if(sss.Sales_Process_ID__c == Sales_Process_ID && sss.PMV_Type__c == PMV_Type){
            		PMVSalesStageSetting PMVSalesStageSetting = new PMVSalesStageSetting(sss);
            		PMVSalesStageSettingList.add(PMVSalesStageSetting);
            	}
            }
            PMVSalesStageSettingList.sort();
            
            this.Index = indexParam;
            
        }
		
	}
	
	public class PMVSalesStageSetting implements Comparable{
		public string salesStageId {get;set;}	//auto
		public string salesStageName {get;set;} //auto
		public string PMV_Type {get;set;}
        public string Sales_Process_ID {get;set;}
        public string Sales_Stage {get;set;}
		
        public double Average_Duration {get;set;}
        public string Buyer_Cycle {get;set;}
        public double Completion_Threshold {get;set;}
        public string Opportunity_Parts_Confidence {get;set;}
        public string Opportunity_Parts_Process_Status {get;set;}
        public string Team_View_Column {get;set;}
        
        public Boolean Priority_Stage {get;set;}
        public Boolean Production_Stage {get;set;}
        public Boolean Active {get;set;}
        public Boolean On_Hold_Stage {get;set;}
        public Boolean Dead_Lost_Stage {get;set;}
        public Boolean Won_Stage {get;set;}
        
        public PMVSalesStageSetting(string spid,string salesStage,string PMVType){
        	this.salesStageId = '';
        	this.salesStageName = '';
        	
        	this.PMV_Type = PMVType;
            this.Sales_Process_ID = spid;
            this.Sales_Stage = salesStage;
        	
        	this.Completion_Threshold = 0;
            this.Average_Duration = 0;
            this.Buyer_Cycle = '';
            if(salesStage == 'Dead'){
            	this.Opportunity_Parts_Confidence = 'Dead';
            }else if(salesStage == 'Lost'){
            	this.Opportunity_Parts_Confidence = 'Lost';
            }else if(salesStage == 'On Hold'){
            	this.Opportunity_Parts_Confidence = 'On Hold';
            }else{
            	this.Opportunity_Parts_Confidence = '';
            }
            this.Opportunity_Parts_Process_Status = '';
            this.Team_View_Column = '';
            if(salesStage == 'Dead' || salesStage == 'Lost'){
            	this.Dead_Lost_Stage = true;
            }else{
            	this.Dead_Lost_Stage = false;
            }
            this.Active = true;
            if(salesStage == 'On Hold'){
            	this.On_Hold_Stage = true;
            }else{
            	this.On_Hold_Stage = false;
            }
            
            this.Priority_Stage = false;
            this.Production_Stage = false;
            this.Won_Stage = false;
        }
        
        public PMVSalesStageSetting(PMV_Sales_Stage_Setting__c ssss){
        	this.salesStageId = ssss.Id;
        	this.salesStageName = ssss.Name;
        	this.Active = ssss.Active__c;
            this.Average_Duration = ssss.Average_Duration__c;
            this.Buyer_Cycle = ssss.Buyer_Cycle__c;
            this.Completion_Threshold = ssss.Completion_Threshold__c;
            this.Dead_Lost_Stage = ssss.Dead_Lost_Stage__c;
            this.On_Hold_Stage = ssss.On_Hold_Stage__c;
            this.Opportunity_Parts_Confidence = ssss.Opportunity_Parts_Confidence__c;
            this.Opportunity_Parts_Process_Status = ssss.Opportunity_Parts_Process_Status__c;
            this.Priority_Stage = ssss.Priority_Stage__c;
            this.Production_Stage = ssss.Production_Stage__c;
            this.PMV_Type = ssss.PMV_Type__c;
            this.Sales_Process_ID = ssss.Sales_Process_ID__c;
            this.Sales_Stage = ssss.Sales_Stage__c;
            this.Team_View_Column = ssss.Team_View_Column__c;
            this.Won_Stage = ssss.Won_Stage__c;
        }
        
        // Implement the compareTo() method
	    public Integer compareTo(Object compareTo) {
	        PMVSalesStageSetting compareToEmp = (PMVSalesStageSetting)compareTo;
	        if (Sales_Stage == compareToEmp.Sales_Stage) return 0;
	        if (Sales_Stage > compareToEmp.Sales_Stage) return 1;
	        return -1;        
	    }
        
	}
	
	
	//********************************* -=END inner classes=- *************************************
}