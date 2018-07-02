/**************************************************************************************************************************************************
Name: OpportunityAPL_routing
Copyright Ã‚Â© 2011 TE Connectivity.
===================================================================================================================================================
Purpose: This trigger will fire when 'Opportunity - Engineering Project' or 'Opportunity - Product Platform' type 
         Opportunity is submitted for approval and at the stage of regional Pm Approve  APL_ENG_routing_Process__c must be have some vales
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR                DATE       DETAIL                                            Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Shreyas M            06/01/2013  Initial Development.                                 
**************************************************************************************************************************************************/


trigger OpportunityAPL_routing  on Opportunity (after update) {

    // Trigger will only fire when Opportunity is updated by approval process.
    
    if(trigger.new.size() == 1 && trigger.isafter && trigger.isUpdate ) {
        
        map<id,Opportunity> oldMapOpportunity = trigger.oldMap;
        map<id,Opportunity> newMapOpportunity = trigger.newMap;
        List<Opportunity> lstOpportunity = new List<Opportunity>();
        set<Id> setOppId = new set<Id>();
        Map<id, String> APLMap = new Map<Id, String>();
        Map<String, AplRoutingProcess__c> AplRoutingProcessMap = new Map<String, AplRoutingProcess__c>();
        AplRoutingProcessMap = AplRoutingProcess__c.getall();
        
        if(AplRoutingProcessMap != null && AplRoutingProcessMap.get('Opportunity - Engineering Project')!= null ){
        Id RTID = AplRoutingProcessMap.get('Opportunity - Engineering Project').Record_type_Id__c; 
        String RTName = AplRoutingProcessMap.get('Opportunity - Engineering Project').Name;
        
        APLMap.put(RTID, RTName);
        }
        if(AplRoutingProcessMap != null && AplRoutingProcessMap.get('Opportunity - Product Platform')!= null ){
          Id  RTID = AplRoutingProcessMap.get('Opportunity - Product Platform').Record_type_Id__c;
          String RTName = AplRoutingProcessMap.get('Opportunity - Product Platform').Name;
            APLMap.put(RTID, RTName);
        }
        map<id,ID> mapOpptyIdProcess = new map<id,ID> ();
        map<id,ID> mapOpptyIdProcessInsta = new map<id,ID>();
        map<id,user> mapOpptyIdProcessInstaUserId = new map<id,user>();
        string oppId ;
        for (Opportunity objOpportunity : newMapOpportunity.Values() ){
            if(objOpportunity.Is_approved_Regional_Sales_Director__c != oldMapOpportunity.get(objOpportunity.Id).Is_approved_Regional_Sales_Director__c 
                && (objOpportunity.APL_ENG_routing_Process__c == null || objOpportunity.APL_ENG_routing_Process__c == '--None--')
                && (APLMap != null && ((APLMap.get(objOpportunity.RecordTypeId) == 'Opportunity - Engineering Project') || (APLMap.get(objOpportunity.RecordTypeId) == 'Opportunity - Product Platform')))
                && objOpportunity.Industry_Code__c == 'Appliances'){
                    oppId = objOpportunity.Id;
            }
        }     
        User objUser;
        if(oppId != null && oppId != ''){
            list<ProcessInstance> lstProcessInstance = [SELECT Id,TargetObjectId,Status FROM ProcessInstance where Status= 'Pending' AND TargetObjectId  =: oppId];
            if(lstProcessInstance != null && lstProcessInstance.size()> 0){
                ProcessInstanceWorkitem objWork = [SELECT Id, ActorId, ProcessInstanceId FROM ProcessInstanceWorkitem where ProcessInstanceId =:lstProcessInstance[0].Id limit 1 ];
                if(objWork !=null && objWork.ActorId != null ) {
                    objUser = [select Id,ProfileId,Profile.Name,name from User where Id =:objWork.ActorId];
                    }
            }
        }
        for (Opportunity objOpportunity : newMapOpportunity.Values() ){
            if( objOpportunity.Is_approved_Regional_Sales_Director__c != oldMapOpportunity.get(objOpportunity.Id).Is_approved_Regional_Sales_Director__c && (objOpportunity.APL_ENG_routing_Process__c == null || objOpportunity.APL_ENG_routing_Process__c == '--None--') && ( APLMap != null &&((APLMap.get(objOpportunity.RecordTypeId) == 'Opportunity - Engineering Project') || (APLMap.get(objOpportunity.RecordTypeId) == 'Opportunity - Product Platform'))) && objOpportunity.Industry_Code__c == 'Appliances' && objUser != null 
               && ( objUser.Profile.Name == 'Appliance Engineering User w/Cost' || objUser.Profile.Name== 'Appliance Standard User' || objUser.Profile.Name== 'Appliance Inside Sales Playbook User' || objUser.Profile.Name== 'Appliance User w/ Cost')){
                    objOpportunity.adderror(system.label.APL_ENG_routing_Process_Error_Message);
            }
        }     
        
    }
}