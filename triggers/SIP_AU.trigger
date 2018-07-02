/**
 *  This trigger is used to sharing records to the plan participant, participants manager and plan approvers.
 *
 @	author Bin Yuan
 @	created 2013-09-09
 @	version 1.0
 @	since 28.0 (Force.com ApiVersion)
 *
 @	changelog
 * 	2012-09-09 Bin Yuan <bin.yuan@itbconsult.com>
 * 	- Created
 *  2014-09-25 Bin Yuan <bin.yuan@itbconsult.com>
 *  - Added PM type GPL fill logic
 *  2014-10-08 Bin Yuan <bin.yuan@itbconsult.com>
 *  - Added trigger denfence
 *  2014-10-10 Bin Yuan <bin.yuan@itbconsult.com>
 *  - Added Report link fill logic
 *  2015-08-19 Bin Yuan <bin.yuan@oinio.com>
 *  - Remove old participant manager sharing and extends PM record type ids
 */   
trigger SIP_AU on SIP__c (after update) {     
	String triggerName = 'SIP_AU';
	//************************* BEGIN Pre-Processing **********************************************
	//System.debug('************************* ' + triggerName + ': BEGIN Pre-Processing ********');
	map<String,map<String, String>> map_sipId_map_userIds_access = new map<String,map<String, String>>();
	map<String,map<String, String>> map_sipId_map_userIds_access4Delete = new map<String,map<String, String>>();
	set<String> set_oldUserIds = new set<String>();
	map<String, set<String>> map_participantId_set_sipIds = new map<String, set<String>>();
	//String rowCause = 'Participant_And_Manager__c';
	map<String,String> map_access = new map<String,String>();
	//Added by Bin Yuan 2015-08-19 due to Remove old participant manager sharing
	map<String, String> map_oldParticipantId_managerId = new map<String, String>();
	/*
	list<SIP__c> list_sips = new list<SIP__c>();
	list<SIP__c> list_sipPopulateBillings = new list<SIP__c>(); 
	list<SIP__c> list_sipPopulateOpportunityData = new list<SIP__c>(); 
    set<String> set_AMCodes = new set<String>();
    set<String> set_FECodes = new set<String>();
    set<String> set_GAMCodes = new set<String>();
    map<Id,set<String>> map_sipId_set_amCode = new map<Id,set<String>>();
    map<Id,set<String>> map_sipId_set_feCode = new map<Id,set<String>>();   
    map<Id,set<String>> map_sipId_set_gamCode = new map<Id,set<String>>();
    map<String, set<String>> map_sipId_set_profitCtrs4GAM = new map<String, set<String>>();
    */ 
	map_access = ClsSIPUitl.getAccess();
	String access;
	//Added by Bin Yuan due to extends PM record type ids
	//Id pmRecordTypeId = ClsSIPUitl.getPMRTId();
	set<Id> set_pmRecordTypeIds = new set<Id>();
	set_pmRecordTypeIds = ClsSIPUitl.getPMRTId();
	
    map<String, set<SIP__c>> map_user_set_sips = new map<String, set<SIP__c>>();
    list<SIP__c> list_sips2Update = new list<SIP__c>();
    map<String, SIP_Mapping__c> map_sipMappingId_sipMapping = new map<String, SIP_Mapping__c>();
    set<String> set_sipIds = new set<String>();
	//************************* END Pre-Processing ************************************************
	//System.debug('************************* ' + triggerName + ': END Pre-Processing **********');

	//************************* BEGIN After Trigger ***********************************************
	if(Trigger.isAfter && !ClsSIPUitl.ISAFTERUPDATE) {
		System.debug('************************* ' + triggerName + ': After Trigger *************');
		for(SIP__c sip : [Select RecordTypeId, RecordType.DeveloperName, Current_Year_POS_Bill_YTD__c, Current_Year_Direct_Bill_YTD__c, 
							Prev_Year_YTD_POS__c, Prev_Year_YTD_Direct_billings__c, Prev_Year_1_POS_Result__c, 
							Exclude_From_Automatic_Update__c, Prev_Year_1__c, Plan_Year__c, GAM_codes__c, AM_codes__c, 
							FE_codes__c, Prev_Year_Pipeline_YTD_Result_Dollar__c, Prev_Year_Conversion_YTD_Result_Dollar__c,
							Id, Approver__c, Plan_Participant__r.ManagerId, Plan_Participant__c,Load_Status_Monthly_Direct__c,
							Load_Status_Record_Indirect__c, GPLs__c, SIP_Mapping__c, Report_Links__c, Status__c,
							Approver__r.isActive, Plan_Participant__r.isActive, Plan_Participant__r.Manager.isActive 
						  From SIP__c 
						  Where Id IN : trigger.newMap.keySet()]) {
			//===========================================================================================
			// 2013.11.11  lili begin
			// *********  this use for recalculation BillsAndOppyData once Load_Status_Record_Indirect__c or Load_Status_Record_Indirect__c changed  *********
			//===========================================================================================
			/*
			if(sip.Load_Status_Record_Indirect__c != trigger.oldMap.get(sip.Id).Load_Status_Record_Indirect__c || sip.Load_Status_Monthly_Direct__c != trigger.oldMap.get(sip.Id).Load_Status_Monthly_Direct__c) {				
				list_sips.add(sip);				
			}
			*/			   
			//===========================================================================================
			// 2013.11.11  lili end
			//===========================================================================================
			
			
			//===========================================================================================
			// *********  this for sharing  ********
			// *********  begin  ********
			//===========================================================================================
			if(sip.Approver__c != null || trigger.oldMap.get(sip.Id).Approver__c != null){
				access = map_access.get('Approver');
				if(sip.Approver__c != null && trigger.oldMap.get(sip.Id).Approver__c != null) {					
					if(sip.Approver__c != trigger.oldMap.get(sip.Id).Approver__c) {	
						if(sip.Approver__r.isActive) {
							ClsSIPUitl.buildSharingMap(map_sipId_map_userIds_access, sip, access, sip.Approver__c);
						}				

						ClsSIPUitl.buildSharingMap(map_sipId_map_userIds_access4Delete, sip, access, trigger.oldMap.get(sip.Id).Approver__c);

						set_oldUserIds.add(trigger.oldMap.get(sip.Id).Approver__c);
						if(trigger.oldMap.get(sip.Id).Approver__c == sip.Plan_Participant__c && sip.Plan_Participant__r.isActive){
							access = map_access.get('Participant');
							ClsSIPUitl.buildSharingMap(map_sipId_map_userIds_access, sip, access, sip.Plan_Participant__c);
						}
						if(trigger.oldMap.get(sip.Id).Approver__c == sip.Plan_Participant__r.ManagerId && sip.Plan_Participant__r.Manager.isActive){
							access = map_access.get('Participant Manager');
							ClsSIPUitl.buildSharingMap(map_sipId_map_userIds_access, sip, access, sip.Plan_Participant__r.ManagerId);
						}
					}
					  
				}
				else if(trigger.oldMap.get(sip.Id).Approver__c != null) {
					if(trigger.oldMap.get(sip.Id).Approver__c == sip.Plan_Participant__c && sip.Plan_Participant__r.isActive){
						access = map_access.get('Participant');
						ClsSIPUitl.buildSharingMap(map_sipId_map_userIds_access, sip, access, sip.Plan_Participant__c);
					}
					if(trigger.oldMap.get(sip.Id).Approver__c == sip.Plan_Participant__r.ManagerId && sip.Plan_Participant__r.Manager.isActive){
						access = map_access.get('Participant Manager');
						ClsSIPUitl.buildSharingMap(map_sipId_map_userIds_access, sip, access, sip.Plan_Participant__r.ManagerId);
					}					
					ClsSIPUitl.buildSharingMap(map_sipId_map_userIds_access4Delete, sip, access, trigger.oldMap.get(sip.Id).Approver__c);
					set_oldUserIds.add(trigger.oldMap.get(sip.Id).Approver__c);
				} 
				else if(sip.Approver__c != null && sip.Approver__r.isActive) {  
					ClsSIPUitl.buildSharingMap(map_sipId_map_userIds_access, sip, access, sip.Approver__c);
				}  
			}
			if(sip.Plan_Participant__c != null || trigger.oldMap.get(sip.Id).Plan_Participant__c != null) {
				if(sip.Plan_Participant__c == sip.Approver__c) {
					access = map_access.get('Approver');
				}else {								
					access = map_access.get('Participant');
				}
				if(sip.Plan_Participant__c != null && trigger.oldMap.get(sip.Id).Plan_Participant__c != null) {					
					if(sip.Plan_Participant__c != trigger.oldMap.get(sip.Id).Plan_Participant__c) {
						//added lili zhao 2015-08-28 due to add the if 
						if(sip.Plan_Participant__c != null 
				    		&& sip.Status__c != trigger.oldMap.get(sip.Id).Status__c 
				    		&& sip.Status__c != 'Not Submitted'
				    		&& sip.Status__c != 'In Approval for Target'
				    		&& sip.Status__c != 'Rejected for Target'
				    		&& sip.Plan_Participant__r.isActive 
				    		)
						ClsSIPUitl.buildSharingMap(map_sipId_map_userIds_access, sip, access, sip.Plan_Participant__c);
						if(sip.Plan_Participant__r.ManagerId != null && sip.Plan_Participant__r.Manager.isActive) {
							access = map_access.get('Participant Manager');
							ClsSIPUitl.buildSharingMap(map_sipId_map_userIds_access, sip, access, sip.Plan_Participant__r.ManagerId);
						}					
						ClsSIPUitl.buildSharingMap(map_sipId_map_userIds_access4Delete, sip, access, trigger.oldMap.get(sip.Id).Plan_Participant__c);

						set_oldUserIds.add(trigger.oldMap.get(sip.Id).Plan_Participant__c);        

						if(!map_participantId_set_sipIds.containsKey(trigger.oldMap.get(sip.Id).Plan_Participant__c)) {
							map_participantId_set_sipIds.put(trigger.oldMap.get(sip.Id).Plan_Participant__c, new set<String>());
						}
						map_participantId_set_sipIds.get(trigger.oldMap.get(sip.Id).Plan_Participant__c).add(sip.Id);
						if(trigger.oldMap.get(sip.Id).Plan_Participant__c == sip.Approver__c && sip.Approver__r.isActive){
							access = map_access.get('Approver');
							ClsSIPUitl.buildSharingMap(map_sipId_map_userIds_access, sip, access, trigger.oldMap.get(sip.Id).Approver__c);
						}
					}
				}
				else if(sip.Plan_Participant__c == null && trigger.oldMap.get(sip.Id).Plan_Participant__c != null) {
				    ClsSIPUitl.buildSharingMap(map_sipId_map_userIds_access4Delete, sip, access, trigger.oldMap.get(sip.Id).Plan_Participant__c);
					set_oldUserIds.add(trigger.oldMap.get(sip.Id).Plan_Participant__c);
					if(!map_participantId_set_sipIds.containsKey(trigger.oldMap.get(sip.Id).Plan_Participant__c)) {
						map_participantId_set_sipIds.put(trigger.oldMap.get(sip.Id).Plan_Participant__c, new set<String>());
					}
					map_participantId_set_sipIds.get(trigger.oldMap.get(sip.Id).Plan_Participant__c).add(sip.Id);
				} 
				else if(sip.Plan_Participant__c != null && trigger.oldMap.get(sip.Id).Plan_Participant__c == null) {
					//added lili zhao 2015-08-28 due to add the if 
					if(sip.Plan_Participant__c != null 
			    		&& sip.Status__c != trigger.oldMap.get(sip.Id).Status__c 
			    		&& sip.Status__c != 'Not Submitted'
			    		&& sip.Status__c != 'In Approval for Target'
			    		&& sip.Status__c != 'Rejected for Target' 
			    		&& sip.Plan_Participant__r.isActive
			    		)
					ClsSIPUitl.buildSharingMap(map_sipId_map_userIds_access, sip, access, sip.Plan_Participant__c);
					if(sip.Plan_Participant__r.ManagerId != null && sip.Plan_Participant__r.Manager.isActive) {
						access = map_access.get('Participant Manager');
						ClsSIPUitl.buildSharingMap(map_sipId_map_userIds_access, sip, access, sip.Plan_Participant__r.ManagerId);
					}
				}
			}
			//Added PM type GPL fill logic
        	//Added by Bin Yuan 2015-08-19 due to extends PM record type ids
        	//if(sip.RecordTypeId == pmRecordTypeId && sip.Plan_Participant__c != trigger.oldMap.get(sip.Id).Plan_Participant__c) {
        	if(set_pmRecordTypeIds.contains(sip.RecordTypeId)&& sip.Plan_Participant__c != trigger.oldMap.get(sip.Id).Plan_Participant__c) {
        		sip.GPLs__c = '';
        		if(sip.Plan_Participant__c == null) {
        			list_sips2Update.add(sip);
        		}
        		else {
        			if(!map_user_set_sips.containsKey(sip.Plan_Participant__c)) {
	        			map_user_set_sips.put(sip.Plan_Participant__c, new set<SIP__c>());
	        		}
	        		map_user_set_sips.get(sip.Plan_Participant__c).add(sip);
        		}
        	}
        	
        	//Started by Bin Yuan 2014-10-10 due to add Report link fill logic
        	//only process records with sip mapping and Report_Links__c is not updated in this transaction
        	if((sip.SIP_Mapping__c != null || trigger.oldMap.get(sip.Id).SIP_Mapping__c != null)) {
        		
        		//if current sip mapping is empty remove previous report links
        		if(sip.SIP_Mapping__c == null) {
        			sip.Report_Links__c = '';
        			list_sips2Update.add(sip);
        		}
        		else {
	        		map_sipMappingId_sipMapping.put(sip.SIP_Mapping__c, null);
	        		set_sipIds.add(sip.Id);
        		}
        	}
		}
		if(!map_participantId_set_sipIds.isEmpty()) {  
			access = map_access.get('Participant Manager');
			for(User u : [Select Id, ManagerId From User Where Id IN : map_participantId_set_sipIds.keySet()]) {
				if(u.ManagerId != null) {
					for(String sipId : map_participantId_set_sipIds.get(u.Id)) {
						SIP__c sip = trigger.newMap.get(sipId);
						ClsSIPUitl.buildSharingMap(map_sipId_map_userIds_access4Delete, sip, access, u.ManagerId);
						set_oldUserIds.add(u.ManagerId);
					}
				}    
			}
		}
		if(!map_sipId_map_userIds_access4Delete.isEmpty()) {
			ClsSIPUitl.removeSIPSharing(map_sipId_map_userIds_access4Delete, set_oldUserIds);
		}
		if(!map_sipId_map_userIds_access.isEmpty()) {
			ClsSIPUitl.sharingToParticipant(map_sipId_map_userIds_access);
		}
		/* 
		if(!list_sips.isEmpty()) {
			ClsSIPuitl.recalcBillingAndOppyData(list_sips, list_sipPopulateOpportunityData, list_sipPopulateBillings, set_AMCodes, set_FECodes, set_GAMCodes, map_sipId_set_amCode, map_sipId_set_feCode, map_sipId_set_gamCode, map_sipId_set_profitCtrs4GAM);			
		}
		*/
		ClsSIPUitl.ISAFTERUPDATE = true;
		if(!list_sips2Update.isEmpty()) {
			update list_sips2Update;
		}
		if(!map_user_set_sips.isEmpty()) {
        	ClsSIPUitl.fillGPLCodesForPMSIP(map_user_set_sips);
        }
        if(!map_sipMappingId_sipMapping.isEmpty()) {
        	
        	ClsSIPUitl.getSIPMappingRecords(map_sipMappingId_sipMapping);
			ClsSIPUitl.populateSIPReportLink(map_sipMappingId_sipMapping, set_sipIds);
        }
		ClsSIPUitl.ISAFTERUPDATE = false;
		//===========================================================================================
		// **********************       END      *************************
		//===========================================================================================
	}
	
	//Added by Bin Yuan due to change the sharing logic
    if(Trigger.isAfter && trigger.isUpdate) {
    	//set<String> set_sipId = new set<String>();//modified by lili zhao 2015-08-27 due to change the set_sipId to trigger.newmap.keyset()
    	set<String> set_sipUpId = new set<String>();
    	map<String, SIP__c> map_sipId_sip = new map<String, SIP__c>();
    	for(SIP__c sip : trigger.new) {
    		//set_sipId.add(sip.Id);//modified by lili zhao 2015-08-27 due to change the set_sipId to trigger.newmap.keyset()
    		/*
	    	if(sip.Plan_Participant__c != null 
	    		&& sip.Status__c != trigger.oldMap.get(sip.Id).Status__c 
	    		&& sip.Status__c != 'Not Submitted'
	    		&& sip.Status__c != 'In Approval for Target'
	    		&& sip.Status__c != 'Rejected for Target' 
	    		) {
	    		
	    		if(!map_sipId_map_userIds_access.containsKey(sip.Id)) {
                    map_sipId_map_userIds_access.put(sip.Id, new map<String, String>());
                }
                if(sip.Plan_Participant__c != sip.Approver__c) {
                    map_sipId_map_userIds_access.get(sip.Id).put(sip.Plan_Participant__c,map_access.get('Participant'));
                }
	    	}
	    	*/
	    	if(sip.Plan_Participant__c != null || sip.Approver__c != null || sip.Plan_Participant__r.ManagerId != null) {
	    		set_sipUpId.add(sip.Id);
	    		
	    	}
    	}
    	
    	if(set_sipUpId.size() > 0) {
    		for(SIP__c sip : [Select Id, Plan_Participant__c, Status__c , Plan_Participant__r.ManagerId, Approver__c, Approver__r.isActive,
    								 Plan_Participant__r.isActive, Plan_Participant__r.Manager.isActive 
    						  From SIP__c 
    						  Where Id IN : set_sipUpId]) {
    			if(!map_sipId_map_userIds_access.containsKey(sip.Id)) {
                    map_sipId_map_userIds_access.put(sip.Id, new map<String, String>());
                }
                
                if(sip.Approver__c != null && sip.Approver__r.isActive) {
                    map_sipId_map_userIds_access.get(sip.Id).put(sip.Approver__c,map_access.get('Approver'));
                }
                //added lili zhao 2015-08-28 due to add these requirement
                if(sip.Plan_Participant__c != sip.Approver__c
                	&& sip.Plan_Participant__r.isActive 
                	//&& sip.Status__c != trigger.oldMap.get(sip.Id).Status__c 
		    		&& sip.Status__c != 'Not Submitted'
		    		&& sip.Status__c != 'In Approval for Target'
		    		&& sip.Status__c != 'Rejected for Target' ) {
                    map_sipId_map_userIds_access.get(sip.Id).put(sip.Plan_Participant__c,map_access.get('Participant'));
                }
                
                if(sip.Plan_Participant__r.ManagerId != null 
                	&& sip.Plan_Participant__r.Manager.isActive 
                	&& sip.Plan_Participant__r.ManagerId != sip.Approver__c 
                	&& sip.Plan_Participant__r.ManagerId != sip.Plan_Participant__c) {
                    map_sipId_map_userIds_access.get(sip.Id).put(sip.Plan_Participant__r.ManagerId,map_access.get('Participant Manager'));
                }
                map_sipId_sip.put(sip.Id, sip);
    		}
    	}
		if(!map_sipId_map_userIds_access.isEmpty()) {
            ClsSIPUitl.createSharingToParticipant(map_sipId_map_userIds_access, map_sipId_sip);
        }else {
        	if(trigger.newmap.keyset().size() > 0) {//modified by lili zhao 2015-08-27 due to change the set_sipId to trigger.newmap.keyset()
        		ClsSIPUitl.deleteSharingToParticipant(trigger.newmap.keyset());//modified by lili zhao 2015-08-27 due to change the set_sipId to trigger.newmap.keyset()
        	}
        }   
    }
	//************************* END After Trigger *************************************************
}