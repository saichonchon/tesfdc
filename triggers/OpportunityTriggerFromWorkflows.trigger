/*------------------------------------------------------------
Author:        Yiming Shen <yiming.shen@capgemini.com>
Description:   Transfer these workflows to trigger due to workflow limits on Opportunity
			   From Workflow:Med Opp Stat CM updates Phase,
			   				 Relay AE Start Date,
			   				 Remove Relay AE Start Date,
			   				 Set Stage Entry Date,
			   				 MED Unset MED Win/Loss Date,
			   				 MED set MED Win/Loss Date 
Inputs:        
Returns:       
History
2017-12-11  Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
trigger OpportunityTriggerFromWorkflows on Opportunity (before insert, before update) {
    system.debug('***OpportunityTriggerFromWorkflows start getCpuTime()***' + Limits.getCpuTime());
	 
    /*ClsWrappers.TriggerContext trgCtx = new ClsWrappers.TriggerContext(Trigger.isBefore, Trigger.isAfter, Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.isUndelete, Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
    OpportunityTrgHandler.updateStageByMedOppStatus(trgCtx);
    OpportunityTrgHandler.updateRelayAEStartDate(trgCtx);
    OpportunityTrgHandler.setStageEntryDate(trgCtx);
    OpportunityTrgHandler.setMEDWinLossDate(trgCtx); */
	Set<String> set_MEDOppStatusValues4Set = new Set<String>{'WN - Win','CN - Lost (Canceled)','LS - Lost','AC - Active Project'};
	Set<String> set_MEDOppStatusValues4Clear = new Set<String>{'P0 - Pre-Opportunity','P3 - In Quoting Opportunity','QR - Quote Released'};
    if(trigger.isBefore){
    	if(trigger.isInsert){
    		system.debug('***Insert start getCpuTime()***' + Limits.getCpuTime());
    		for(Opportunity oppy : trigger.new){
    			//2.Relay AE Start Date & Remove Relay AE Start Date
    			if(oppy.Relay_Application_Support_requested__c == true){
            		oppy.Relay_AE_Start_Date__c = Date.today();
            	}else{
            		oppy.Relay_AE_Start_Date__c = null;
            	}
            	//3.Set Stage Entry Date
            	oppy.Date_when_stage_entered__c = Date.today();
            	//4.MED Unset MED Win/Loss Date & MED set MED Win/Loss Date 
            	if(set_MEDOppStatusValues4Set.contains(oppy.MED_Opp_Status__c)){
        			oppy.MED_Quote_Approval_Date__c = Date.today();
            	}else if(oppy.MED_Quote_Approval_Date__c != null
            	&& set_MEDOppStatusValues4Clear.contains(oppy.MED_Opp_Status__c)){
            		oppy.MED_Quote_Approval_Date__c = null;
            	}
	    	}
	    	system.debug('***Insert finish getCpuTime()***' + Limits.getCpuTime());
    	}else if(trigger.isUpdate){
    		system.debug('***Update start getCpuTime()***' + Limits.getCpuTime());
    		for(Opportunity oppy : trigger.new){
	    		Opportunity oldOppy = (Opportunity)trigger.oldMap.get(oppy.Id);
	    		//1.Med Opp Stat CM updates Phase
	    		if(oppy.MED_Opp_Status__c == 'CM - Complete'){
	    			oppy.StageName = 'Won - Closed';
	    		}
	    		//2.Relay AE Start Date & Remove Relay AE Start Date
            	if(oldOppy.Relay_Application_Support_requested__c == false
            	&& oppy.Relay_Application_Support_requested__c == true){
            		oppy.Relay_AE_Start_Date__c = Date.today();
            	}else if(oldOppy.Relay_Application_Support_requested__c == true
            	&& oppy.Relay_Application_Support_requested__c == false){
            		oppy.Relay_AE_Start_Date__c = null;
            	}
            	//3.Set Stage Entry Date
            	if(oldOppy.StageName != oppy.StageName){
            		oppy.Date_when_stage_entered__c = Date.today();
            	}
            	//4.MED Unset MED Win/Loss Date & MED set MED Win/Loss Date 
            	if(!set_MEDOppStatusValues4Set.contains(oldOppy.MED_Opp_Status__c)
            	&& set_MEDOppStatusValues4Set.contains(oppy.MED_Opp_Status__c)){
            		oppy.MED_Quote_Approval_Date__c = Date.today();
            	}else if(oppy.MED_Quote_Approval_Date__c != null
            	&& !set_MEDOppStatusValues4Clear.contains(oldOppy.MED_Opp_Status__c)
            	&& set_MEDOppStatusValues4Clear.contains(oppy.MED_Opp_Status__c)){
            		oppy.MED_Quote_Approval_Date__c = null;
            	}
	    	}
	    	system.debug('***Update start getCpuTime()***' + Limits.getCpuTime());
    	}
    }
   	
    /*public static void updateStageByMedOppStatus(ClsWrappers.TriggerContext trgCtx) {
    	if(trgCtx.isInsert || trgCtx.isUpdate){
    		for(Sobject sobj : trgCtx.newList){
            	Opportunity oppy = (Opportunity)sobj;
            	if(oppy.MED_Opp_Status__c == 'CM - Complete'){
            		oppy.StageName = 'Won - Closed';
            	}
    		}
    	}
    }
    
    
    public static void updateRelayAEStartDate(ClsWrappers.TriggerContext trgCtx) {
    	if(trgCtx.isInsert){
    		for(Sobject sobj : trgCtx.newList){
            	Opportunity oppy = (Opportunity)sobj;
            	if(oppy.Relay_Application_Support_requested__c == true){
            		oppy.Relay_AE_Start_Date__c = Date.today();
            	}else{
            		oppy.Relay_AE_Start_Date__c = null;
            	}
    		}
    	}else if(trgCtx.isUpdate){
    		for(Sobject sobj : trgCtx.newList){
            	Opportunity oppy = (Opportunity)sobj;
            	Opportunity oldOppy = (Opportunity)trgCtx.oldMap.get(oppy.Id);
            	if(oldOppy.Relay_Application_Support_requested__c == false
            	&& oppy.Relay_Application_Support_requested__c == true){
            		oppy.Relay_AE_Start_Date__c = Date.today();
            	}else if(oldOppy.Relay_Application_Support_requested__c == true
            	&& oppy.Relay_Application_Support_requested__c == false){
            		oppy.Relay_AE_Start_Date__c = null;
            	}
    		}
    	}
    }
    
    
    public static void setStageEntryDate(ClsWrappers.TriggerContext trgCtx) {
    	if(trgCtx.isInsert){
    		for(Sobject sobj : trgCtx.newList){
            	Opportunity oppy = (Opportunity)sobj;
        		oppy.Date_when_stage_entered__c = Date.today();
    		}
    	}else if(trgCtx.isUpdate){
    		for(Sobject sobj : trgCtx.newList){
            	Opportunity oppy = (Opportunity)sobj;
            	Opportunity oldOppy = (Opportunity)trgCtx.oldMap.get(oppy.Id);
            	if(oldOppy.StageName != oppy.StageName){
            		oppy.Date_when_stage_entered__c = Date.today();
            	}
    		}
    	}
    }
    
    public static void setMEDWinLossDate(ClsWrappers.TriggerContext trgCtx) {
    	Set<String> set_MEDOppStatusValues4Set = new Set<String>{'WN - Win','CN - Lost (Canceled)','LS - Lost','AC - Active Project'};
    	Set<String> set_MEDOppStatusValues4Clear = new Set<String>{'P0 - Pre-Opportunity','P3 - In Quoting Opportunity','QR - Quote Released'};
    	if(trgCtx.isInsert){
    		for(Sobject sobj : trgCtx.newList){
            	Opportunity oppy = (Opportunity)sobj;
            	if(set_MEDOppStatusValues4Set.contains(oppy.MED_Opp_Status__c)){
        			oppy.MED_Quote_Approval_Date__c = Date.today();
            	}else if(oppy.MED_Quote_Approval_Date__c != null
            	&& set_MEDOppStatusValues4Clear.contains(oppy.MED_Opp_Status__c)){
            		oppy.MED_Quote_Approval_Date__c = null;
            	}
    		}
    	}else if(trgCtx.isUpdate){
    		for(Sobject sobj : trgCtx.newList){
            	Opportunity oppy = (Opportunity)sobj;
            	Opportunity oldOppy = (Opportunity)trgCtx.oldMap.get(oppy.Id);
            	if(!set_MEDOppStatusValues4Set.contains(oldOppy.MED_Opp_Status__c)
            	&& set_MEDOppStatusValues4Set.contains(oppy.MED_Opp_Status__c)){
            		oppy.MED_Quote_Approval_Date__c = Date.today();
            	}else if(oppy.MED_Quote_Approval_Date__c != null
            	&& !set_MEDOppStatusValues4Clear.contains(oldOppy.MED_Opp_Status__c)
            	&& set_MEDOppStatusValues4Clear.contains(oppy.MED_Opp_Status__c)){
            		oppy.MED_Quote_Approval_Date__c = null;
            	}
    		}
    	}
    }*/
}