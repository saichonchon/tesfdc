/**
 *	Contains a set of static methods used in invoice creation triggers and VF pages
 *
 @author Bin Yuan
 @created 2013-01-05
 @version 1.0
 @since 25.0 (Force.com ApiVersion)
 *
 @changelog
 * 2013-01-05 Bin Yuan <bin.yuan@itbconsult.com>
 * - Created
 * 2014-09-24 Bin Yuan <bin.yuan@itbconsult.com>
 * - Modified recalc logic into if play year bigger than 2014 will get data from report
 */
public class Ext_SIP_RecalcBillingAndOppyData {
   
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	public String batchId {get;set;}
	public String batchStatus {get;set;}
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    /**
	 * map to store global describtion due to limit on describe methodes.
	 */
	private map<String, String> map_urlParams;
	private ApexPages.standardController stdCtrl;
	private SIP__c sip;
	private map<String, set<String>> map_sipId_set_profitCtrs4GAM = new map<String, set<String>>(); 
	private map<String, list<ClsSIPUitl.ReportMap>> map_sipMappingId_list_reportMap = new map<String, list<ClsSIPUitl.ReportMap>>();
	private map<String, SIP__c> map_sipId_sip = new map<String, SIP__c>();
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	/////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
   /**
	* The contsructor
	*
	@author Bin Yuan
	@created 2013-01-05
	@version 1.0
	@since 25.0 (Force.com ApiVersion)
	*
	@changelog
	* 2013-01-05 Bin Yuan <bin.yuan@itbconsult.com>
	* - Created
	*/
    public Ext_SIP_RecalcBillingAndOppyData(ApexPages.standardController stdCtrl) {
    	map_urlParams = ApexPages.currentPage().getParameters();
    	this.stdCtrl = stdCtrl;
    	this.sip = (SIP__c) this.stdCtrl.getRecord();
    	init();
    }
	/////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
   /**
	* This method is used to 
	*
	@author Bin Yuan
	@created 2013-01-05
	@version 1.0
	@since 25.0 (Force.com ApiVersion)
	*
	@param year			year string
	@param ownerId		owner id string
	*
	@return 			the visit capacity
	*
	@changelog
	* 2013-01-05 Bin Yuan <bin.yuan@itbconsult.com>
	* - Created
	*/
    public void recalcBillsAndOppyData() {
    	list<SIP__c> list_sipPopulateBillings = new list<SIP__c>(); 
	    set<String> set_AMCodes = new set<String>();
	    set<String> set_FECodes = new set<String>();
	    set<String> set_GAMCodes = new set<String>();
	    map<Id,set<String>> map_sipId_set_amCode = new map<Id,set<String>>();
	    map<Id,set<String>> map_sipId_set_feCode = new map<Id,set<String>>();
	    map<Id,set<String>> map_sipId_set_gamCode = new map<Id,set<String>>();
	    batchStatus = 'Started';
	    try {
	    	if(sip.Exclude_From_Automatic_Update__c == false){
	    		if(Integer.valueOf(sip.Plan_Year__c) <= 2014) {
	    		
		    		if(sip.RecordType.DeveloperName == 'Sales_Manager_Plan') {
						ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Sorry,re-calculate is not responsible for sale manager plan!'));
					}
					resetData();
					if(sip.RecordType.DeveloperName == 'AM_plan' && sip.AM_codes__c != '' && sip.AM_codes__c != null) {
						list_sipPopulateBillings.add(sip);
						buildCodeMap(set_AMCodes, map_sipId_set_amCode, sip.AM_codes__c);
					}
					if(sip.RecordType.DeveloperName == 'FE_Plan') {
						if(sip.FE_codes__c !=  '' && sip.FE_codes__c != null) {
							buildCodeMap(set_FECodes, map_sipId_set_feCode, sip.FE_codes__c);
							list_sipPopulateBillings.add(sip);
						}
						sip.Prev_Year_Pipeline_YTD_Result_Dollar__c = null;
						sip.Prev_Year_Conversion_YTD_Result_Dollar__c = null;
						ClsSIPUitl.populateOpportunityData(sip);
					}
					if(sip.RecordType.DeveloperName == 'GAM_plan' && sip.GAM_codes__c != '' && sip.GAM_codes__c != null) {
						list_sipPopulateBillings.add(sip);
						buildCodeMap(set_GAMCodes, map_sipId_set_gamCode, sip.GAM_codes__c);
						if(sip.Profit_Center_Codes__c != null) {
							if(sip.Profit_Center_Codes__c.contains(';')) {
								for(String profitCode : sip.Profit_Center_Codes__c.split(';')) {
									ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'profitCode 1 :: ' + profitCode));
									if(!map_sipId_set_profitCtrs4GAM.containsKey(sip.Id)) {
										map_sipId_set_profitCtrs4GAM.put(sip.Id, new set<String>());
									}
									map_sipId_set_profitCtrs4GAM.get(sip.Id).add(profitCode);
								}
							}
							else {
								if(!map_sipId_set_profitCtrs4GAM.containsKey(sip.Id)) {
									map_sipId_set_profitCtrs4GAM.put(sip.Id, new set<String>());
								}
								map_sipId_set_profitCtrs4GAM.get(sip.Id).add(sip.Profit_Center_Codes__c);
							}
						}
					}
					if(!list_sipPopulateBillings.isEmpty()) {
						ClsSIPUitl.populateBillings(list_sipPopulateBillings, set_AMCodes, set_FECodes, set_GAMCodes, map_sipId_set_amCode, map_sipId_set_feCode, map_sipId_set_gamCode, map_sipId_set_profitCtrs4GAM);
						//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'list_sipPopulateBillings 2 :: ' + list_sipPopulateBillings));	
					}
					//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'sip :: ' + sip));
					update sip;
					batchStatus = 'Completed';
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, system.label.SIP_Batch_Job_Success_Msg));
	    		}
	    		else {
	    			ClsSIPUitl.ISAFTERUPDATE = true;
	    			map<String, ClsSIPUitl.SIPCustomExcMSG> map_sipId_exception = new map<String, ClsSIPUitl.SIPCustomExcMSG>{sip.Id => new ClsSIPUitl.SIPCustomExcMSG()};
	    			ClsSIPUitl.populatDataFromReportAsyn(map_sipId_sip, map_sipId_exception, map_sipMappingId_list_reportMap, UserInfo.getSessionId());
	    			/*
	    			ClsBatch_fetchSIPReportResult cls = new ClsBatch_fetchSIPReportResult();
	    			cls.filter = ' And Id = \'' + this.sip.Id + '\'';
	    			cls.isRecalc = true;
	    			Database.executeBatch(cls);
	    			*/
	    			batchStatus = 'Submitted';
	    			ClsSIPUitl.ISAFTERUPDATE = false;
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, system.label.SIP_Recalc_Submitted_Msg));
	    		}
	    	} else {
	    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Sorry,the plan cannot refresh any data!'));
	    	}		
	    }
	    catch(Exception ex) {
	    	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage()));
	    	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getStackTraceString()));
	    }
    }
  	public void refreshRecalcStatus() {
  		ClsSIPUitl.ISAFTERUPDATE = true;
  		map<String, ClsSIPUitl.SIPCustomExcMSG> map_sipId_exception = new map<String, ClsSIPUitl.SIPCustomExcMSG>{sip.Id => new ClsSIPUitl.SIPCustomExcMSG()};
  		ClsSIPUitl.fetchDataFromReportAsyn(map_sipId_sip, map_sipId_exception, UserInfo.getSessionId(), new set<String>());
  		
  		for(SIP__c sipStatus : [Select Id, Is_Report_Finished__c, SIP_Report_Instance__c
  						  From SIP__c 
  						  Where Id =: this.sip.Id]) {
  			
  			if(sipStatus.Is_Report_Finished__c) {
  				batchStatus = 'Completed';
  				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, system.label.SIP_Batch_Job_Success_Msg));
  			}
  			else {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, system.label.SIP_Recalc_In_Progress_Msg));
  			}
  		}
  		ClsSIPUitl.ISAFTERUPDATE = false;
  	}
  	
  	public PageReference goBack() {
  		pagereference p = new pagereference('/' + sip.Id);
  		return p;
  	}
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    private void init() {
    	try {
    		sip = [Select Id, AM_codes__c, FE_codes__c,Exclude_From_Automatic_Update__c, GAM_codes__c, Prev_Year_1__c, Prev_Year_1_POS_Result__c, Plan_Year__c, 
    					   Prev_Year_YTD_Direct_billings__c, Prev_Year_YTD_POS__c, Current_Year_Direct_Bill_YTD__c, Plan_Participant__c, 
    					   Current_Year_POS_Bill_YTD__c, Prev_Year_Pipeline_YTD_Result_Dollar__c, Prev_Year_Conversion_YTD_Result_Dollar__c,
    					   RecordType.DeveloperName, Profit_Center_Codes__c, SIP_Mapping__c, Recalculate__c
    			   From SIP__c
    			   Where Id =: sip.Id];
    			   
			map_sipMappingId_list_reportMap.put(sip.SIP_Mapping__c, new list<ClsSIPUitl.ReportMap>());	   
			map_sipId_sip.put(sip.Id, sip);
			
    	}
    	catch(Exception ex) {
    		
    	}
    }
    private void resetData() {
    	sip.Prev_Year_1__c = null;
    	sip.Prev_Year_1_POS_Result__c = null;
    	sip.Prev_Year_YTD_Direct_billings__c = null;
    	sip.Prev_Year_YTD_POS__c = null;
    	sip.Current_Year_Direct_Bill_YTD__c = null;
    	sip.Current_Year_POS_Bill_YTD__c = null;
    }
    private void buildCodeMap(set<String> set_codes, map<Id, set<String>> map_sipId_set_codes, String str_code) {
		if(str_code.contains(',')) {
			for(String code : str_code.split(',')) {
				set_codes.add(code);
				if(!map_sipId_set_codes.containsKey(sip.Id)) {
					map_sipId_set_codes.put(sip.Id, new set<String>());
				}
				map_sipId_set_codes.get(sip.Id).add(code);
			}
		}
		else {
			set_codes.add(str_code);
			if(!map_sipId_set_codes.containsKey(sip.Id)) {
				map_sipId_set_codes.put(sip.Id, new set<String>());
			}
			map_sipId_set_codes.get(sip.Id).add(str_code);						
		}    	
    }
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>WrapperClass*/
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
}