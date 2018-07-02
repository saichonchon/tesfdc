/**
 * This trigger used to calculate opportunity allocation. For Appliance Opportunity we will create billing records accordingly.
 *
 * @author      Min Liu
 * @created     2012-11-14
 * @since       23.0 (Force.com ApiVersion)      
 * @version     1.0 
 *
 * @changelog
 * 2012-11-14 Min Liu <min.liu@itbconsult.com>
 * - Created 
 * 
 * nelson zheng 2015-10-8
 * updated for case 00900377
 
 * nelson zheng 2016-1-28
 * updated for case 00900669
 
   @changelog
 * 2016-04-07 Mingxing Qiu  <mingxing.qiu@oinio.com>
 * Update the create APL_bill object filter when insert  opportunity pratner 
 * - Created 
 */
trigger opportunityPartner_AIUDUD_calOppyAllocation on Opportunity_Partner__c (after delete, after insert, after undelete, 
after update,before delete) {
    Map<Id, List<Opportunity_Partner__c>> map_oppyId_oppyPartner = new Map<Id, List<Opportunity_Partner__c>>();

    List<Opportunity_Partner__c> needToInsert = new List<Opportunity_Partner__c>();
    List<Opportunity_Partner__c> needToDelete = new List<Opportunity_Partner__c>();
    
    Set<Id> oppIdSet = new Set<Id>();//added by nelson zheng 2016-1-29 for case 00900669
    Set<Id> accIdSet = new Set<Id>();//added by nelson zheng 2016-1-29 for case 00900669
    //the key is accout Id and the value is the list of Opportunity Id
    Map<Id,Set<Id>> accWithOppIdMap = new Map<Id,Set<Id>>();//added by nelson zheng 2016-1-29 for case 00900669
    //the key is opportunity Id and the value is the list of part Id
    Map<Id,Set<Id>> oppWithOppPartIdMap = new Map<Id,Set<Id>>();//added by nelson zheng 2016-1-29 for case 00900669
    
    Map<Id,Opportunity_Partner__c> newOPCMap = new Map<Id,Opportunity_Partner__c>();
    Map<Id,Opportunity_Partner__c> oldOPCMap = new Map<Id,Opportunity_Partner__c>();
    set<id> setOppyID = new set<id>();/*Case - 00900368: Updated by Pankaj Raijade 2015-12-10 update field last modified by custom */
    Set<Id> partIdSet = new Set<Id>();
    boolean isLastmodifieddatefieldsupdateallowed = (Last_Modified_Field_Update_Permission__c.getInstance() != null ? Last_Modified_Field_Update_Permission__c.getInstance().Allow_Update__c : false);/*Case - 00900368: Updated by Pankaj Raijade 2015-12-10 update field last modified by custom */
    // insert or undelete opportuntity partner
    if(trigger.isInsert || trigger.isUnDelete){
        for(Opportunity_Partner__c opc :trigger.new){
            if(!map_oppyId_oppyPartner.containsKey(opc.Opportunity__c)) {
            	map_oppyId_oppyPartner.put(opc.Opportunity__c, new List<Opportunity_Partner__c>());
            }
            map_oppyId_oppyPartner.get(opc.Opportunity__c).add(opc);
            
            if(opc.Partner_Account_Manager__c != opc.Opportunity_Owner__c) {
                needToInsert.add(opc);
            }
            if(isLastmodifieddatefieldsupdateallowed) {/*Case - 00900368: Updated by Pankaj Raijade 2015-12-10 update field last modified by custom */
                setOppyID.add(opc.Opportunity__c);/*Case - 00900368: Updated by Pankaj Raijade 2015-12-10 update field last modified by custom */
            }
            //Prevent other BU to enter 
            if(opc.isAPLOpp__c){
                oppIdSet.add(opc.Opportunity__c);
                accIdSet.add(opc.Account__c);
                if(accWithOppIdMap.get(opc.Account__c) == null){
                    Set<Id> oppIdList = new Set<Id>();
                    oppIdList.add(opc.Opportunity__c);
                    accWithOppIdMap.put(opc.Account__c,oppIdList);
                }else{
                    accWithOppIdMap.get(opc.Account__c).add(opc.Opportunity__c);
                }
            }
        }
       
        //added by nelson zheng 2016-1-29 for case 00900669
        if(oppIdSet.size() > 0){
        	
        	
        	system.debug('oppIdSet::'+ oppIdSet);
        	//Modified by Mingxing Qiu on 2016-04-07 to remove the ??APL need to capture billing?? filter in the where condition
        	List<opportunity_part__c> oppPartList = [select Id,opportunity__c,Part__c from Opportunity_Part__c where opportunity__c in: oppIdSet and Process_Status__c = 'Production' and APL_need_to_capture_billing__c = false]; // APL_need_to_capture_billing__c = false
		    system.debug('oppPartList::'+ oppPartList);
		    //Store opportunity corresponding relationship with Part and find matching partId 
		    for(opportunity_part__c oppPart : oppPartList){
		        partIdSet.add(oppPart.Part__c);
		        if(oppWithOppPartIdMap.get(oppPart.opportunity__c) == null){
		            Set<Id> oppPartIdList = new Set<Id>();
		            oppPartIdList.add(oppPart.Part__c);
		            oppWithOppPartIdMap.put(oppPart.opportunity__c,oppPartIdList);
		        }else{
		            oppWithOppPartIdMap.get(oppPart.opportunity__c).add(oppPart.Part__c);
		        }
		    }
       
        }
       
       if(accIdSet.size() > 0 && partIdSet.size() > 0){
	        //List<BBB_Year_Bill_Book_Cust_PN__c> yearlyBBList = [select Id,Customer__c,Part__c from BBB_Year_Bill_Book_Cust_PN__c where Customer__c in: accIdSet and Part__c in: partIdSet];
		    /*if(yearlyBBList.size() > 0 ){
		        for(BBB_Year_Bill_Book_Cust_PN__c yearlyBB : yearlyBBList){
		            Set<Id> oppIdList = accWithOppIdMap.get(yearlyBB.Customer__c);
		            if(oppIdList != null){
		                for(Id oppId : oppIdList){
		                    Set<Id> oppPartIdList = oppWithOppPartIdMap.get(oppId);
		                    if(oppPartIdList != null && oppPartIdList.contains(yearlyBB.Part__c)){
		                        APL_Billing_Result_of_Covnerted_Opp__c APL_billing = new APL_Billing_Result_of_Covnerted_Opp__c();
		                        APL_billing.opportunity__c = oppId;
		                        APL_billing.Opportunity_Partner__c = yearlyBB.Customer__c;
		                        APL_billing.part__c = yearlyBB.Part__c;
		                        APL_billing.Yearly_Booking_Billings_By_Part__c =yearlyBB.Id;
		                        convertList.add(APL_billing);
		                    }
		                }
		            }
		        }
		    }else{*/
		    //Update by Mingxing Qiu time is 2016-04-18
		    //query the yearly bb by part and acct
		    List<APL_Billing_Result_of_Covnerted_Opp__c> convertList = new List<APL_Billing_Result_of_Covnerted_Opp__c>();
		    map<String,list<ID>> map_accIdPartId_yearlyBBId = new map<String,list<String>>();
           system.debug('!@# trigger accIdSet:'+accIdSet);
           system.debug('!@# trigger accIdSet:'+partIdSet);
		    for( BBB_Year_Bill_Book_Cust_PN__c yearlyBBB : [select Id,Customer__c,Part__c from BBB_Year_Bill_Book_Cust_PN__c 
		    												where Customer__c in: accIdSet and Part__c in: partIdSet
		    													and APL_need_to_capture_billing__c = false]) {
		    	if(!map_accIdPartId_yearlyBBId.containsKey(yearlyBBB.Customer__c + ';' + yearlyBBB.Part__c )) {
		    		map_accIdPartId_yearlyBBId.put(yearlyBBB.Customer__c + ';' + yearlyBBB.Part__c, new list<String>());
		    	}
		    	map_accIdPartId_yearlyBBId.get(yearlyBBB.Customer__c + ';' + yearlyBBB.Part__c).add(yearlyBBB.Id);
		    }
		    
		    system.debug('map_accIdPartId_yearlyBBId :: ' + map_accIdPartId_yearlyBBId );
		    system.debug('accIdSet :: ' + accIdSet );
		    system.debug('oppIdSet :: ' + oppIdSet );
		    system.debug('partIdSet :: ' + partIdSet );
      		//Create the APL billing 
		    for(Id  acctId : accIdSet){
	    		for(Id oppyId : oppIdSet){
	    			for(Id partId : partIdSet){
	    				if(map_accIdPartId_yearlyBBId.containsKey(acctId + ';' + partId)){   //found year bill book
	    					for(ID str_yearlyId : map_accIdPartId_yearlyBBId.get(acctId + ';' + partId)){
	    						APL_Billing_Result_of_Covnerted_Opp__c APL_billing = new APL_Billing_Result_of_Covnerted_Opp__c();
		                        APL_billing.opportunity__c = oppyId;
		                        APL_billing.Opportunity_Partner__c = acctId; 
		                        APL_billing.part__c = partId;
		                        APL_billing.Yearly_Booking_Billings_By_Part__c = str_yearlyId;
		                        convertList.add(APL_billing);
	    					}
	    				}else{   //Not found year bill book
	    					APL_Billing_Result_of_Covnerted_Opp__c APL_billing = new APL_Billing_Result_of_Covnerted_Opp__c();
	                        APL_billing.opportunity__c = oppyId;
	                        APL_billing.Opportunity_Partner__c = acctId; 
	                        APL_billing.part__c = partId;
	                        convertList.add(APL_billing);
	    				}	
	    			}
	    		}		    	
		    }
		        
	        if(convertList.size() > 0){
	        	insert convertList;
	        }
	   }
    }
        
    // update opportunity partner
    else if(trigger.isUpdate){
        for(Opportunity_Partner__c opc :trigger.new){
            if(!ClsOppyPartUtil.needCriteria){
                if(!map_oppyId_oppyPartner.containsKey(opc.Opportunity__c)) {
	                map_oppyId_oppyPartner.put(opc.Opportunity__c, new List<Opportunity_Partner__c>());
	            }
	            map_oppyId_oppyPartner.get(opc.Opportunity__c).add(opc);
              
            }
            else if(opc.Allocation__c != trigger.oldMap.get(opc.id).Allocation__c){             
                if(!map_oppyId_oppyPartner.containsKey(opc.Opportunity__c)) {            
                	map_oppyId_oppyPartner.put(opc.Opportunity__c, new List<Opportunity_Partner__c>());
                }
                map_oppyId_oppyPartner.get(opc.Opportunity__c).add(opc);
            }
            
            //added by nelson zheng 2015-10-8
            if(opc.Account__c != trigger.oldMap.get(opc.id).Account__c){
                if(opc.Partner_Account_Manager__c != opc.Opportunity_Owner__c){
                    needToInsert.add(opc);
                }
                needToDelete.add(trigger.oldMap.get(opc.id));
                
            }
            if(isLastmodifieddatefieldsupdateallowed)/*Case - 00900368: Updated by Pankaj Raijade 2015-12-10 update field last modified by custom */
                setOppyID.add(opc.Opportunity__c);/*Case - 00900368: Updated by Pankaj Raijade 2015-12-10 update field last modified by custom */
        }
    }
    //edited by Nelson Zheng add " && APL_Utils_Class.calAllocation" 07/22/2015
    else if(trigger.isDelete && APL_Utils_Class.calAllocation && Trigger.isAfter){
        for(Opportunity_Partner__c opc :trigger.old){
            if(!map_oppyId_oppyPartner.containsKey(opc.Opportunity__c)) {
            	map_oppyId_oppyPartner.put(opc.Opportunity__c, new List<Opportunity_Partner__c>());
            }
            map_oppyId_oppyPartner.get(opc.Opportunity__c).add(opc);
            
        }
    }
    
    //added by nelson zheng 2015-10-8
    if(trigger.isDelete && Trigger.isAfter){
        for(Opportunity_Partner__c opc :trigger.old){
            needToDelete.add(opc);
            if(isLastmodifieddatefieldsupdateallowed)/*Case - 00900368: Updated by Pankaj Raijade 2015-12-10 update field last modified by custom */
                setOppyID.add(opc.Opportunity__c);/*Case - 00900368: Updated by Pankaj Raijade 2015-12-10 update field last modified by custom */
           
        }
    }
    if(needToDelete.size() > 0){
        SharingUtils.removeOpportunityPartnerAMFromOppTeam(needToDelete);
    }
    if(needToInsert.size() > 0){
        SharingUtils.addOpportunityPartnerAMToOppTeam(needToInsert);
    }
    
    //added by nelson zheng 2016-1-29 for case 00900669
    if(Trigger.isBefore && Trigger.isDelete){
        for(Opportunity_Partner__c opc :trigger.old){
            if(opc.isAPLOpp__c){
                oppIdSet.add(opc.Opportunity__c);
                accIdSet.add(opc.Account__c);
            }
        }
        if(accIdSet.size() > 0 && oppIdSet.size() > 0){
        	 List<APL_Billing_Result_of_Covnerted_Opp__c> convertList = [select Id from APL_Billing_Result_of_Covnerted_Opp__c where Opportunity_Partner__c in: accIdSet and opportunity__c in: oppIdSet];
        	 delete convertList;
        }
       
        
    }
    
   
    /*Case - 00900368: Updated by Pankaj Raijade 2015-12-10 update field last modified by custom-Start*/
    if(!setOppyID.isEmpty()) {
    	update [select id, Last_Modified_By_Custom__c, Last_Modified_Date__c  from opportunity where id in :setOppyID];
    }
        
    /*Case - 00900368: Updated by Pankaj Raijade 2015-12-10 update field last modified by custom-End*/
    //added by nelson zheng for case 2015-11-04 for case 00897724 end
    
    
    if(!map_oppyId_oppyPartner.isEmpty()){ 
        try {
            ClsOppyPartUtil.calOppyAllocation(map_oppyId_oppyPartner);
        } catch (DMLException e) {
            /*// 2015-03-27 Phil Hiemstra - Added DML Exception handling, mostly to catch Funnel OCR related validation errors.
            Map<Id, String> errorMessages = new Map<Id, String>();
            
            for (Integer i = 0; i < e.getNumDml(); i++) {
                errorMessages.put(Id.valueOf(e.getDmlId(i)), e.getDmlMessage(i));
            }
            
            if(Trigger.isDelete){
                for(Opportunity_Partner__c op : Trigger.old){
                    if (errorMessages.containsKey(op.Opportunity__c)){
                        op.addError(errorMessages.get(op.Opportunity__c));
                    }
                }
            }
            else{
                for(Opportunity_Partner__c op : Trigger.new){
                    if (errorMessages.containsKey(op.Opportunity__c)){
                        op.addError(errorMessages.get(op.Opportunity__c));
                    }
                }   
            }*/
            opportunityPartnertriggerHelper.opportunityPartnerTriggerExceptionhandler(e, Trigger.old, Trigger.new, Trigger.isDelete);
        }
    }
}