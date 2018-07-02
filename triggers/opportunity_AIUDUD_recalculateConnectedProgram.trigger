/**
*   This trigger is used to recalculate the fields of connected programs like phase, close date
*
@author min liu
@created 2012-09-17
@version 1.0
@since 24.0
*
@changelog
* 2012-09-17 min liu <min.liu@itbconsult.com>
* - Created
* - Changed by Rahul(22 Nov 2017) Case-00901347-exclude dead forecasst revenue from program opportunity.
* ---- Used 'ExecuteOnce.SF2SF_OPPORTUNITY' to prevent recursive trigger call, and true after program opportunity will update.
* ---- Prepared 'list_program2Minus' list by checking program opprtunity recordtype is in program and checking current opportunity stage as dead or dead closed
*/
trigger opportunity_AIUDUD_recalculateConnectedProgram on Opportunity (after delete, after insert, after undelete, 
after update) {
    if(!ExecuteOnce.SF2SF_OPPORTUNITY){        
        List<Opportunity> list_program2Update = new List<Opportunity>();
                  
        // when insert or undelete
        if(trigger.isInsert || trigger.isUnDelete){
            ClsOppyUtil.recalculateConnectedProgram(trigger.new, null, 'Insert', list_program2Update);        
        }
        
        // update
        else if(trigger.isUpdate){
            List<Opportunity> list_program2Minus = new List<Opportunity>();
            List<Opportunity> list_program2Plus = new List<Opportunity>();
            // when only phase is changed
            Set<Id> set_programId4Phase = new Set<Id>();
            
            //--Changed for Case-00901347--Start--//
            Set<String> set_excludeOppyPhase = new Set<String>();
            if(Apex_Helper_Settings__c.getValues('Exclude Oppy Revenue Phase') != null && Apex_Helper_Settings__c.getValues('Exclude Oppy Revenue Phase').Value__c != null){
                set_excludeOppyPhase.addAll(Apex_Helper_Settings__c.getValues('Exclude Oppy Revenue Phase').Value__c.Split(','));
            }
            //--Changed for Case-00901347--End--//
            
            for(Opportunity oppy :trigger.new){
                // if program is changed
                if(oppy.Program__c != trigger.oldMap.get(oppy.id).Program__c){
                    if(oppy.Program__c == null) list_program2Minus.add(trigger.oldMap.get(oppy.id));
                    else{
                        if(trigger.oldMap.get(oppy.id).Program__c == null) list_program2Plus.add(oppy);
                        else{
                            list_program2Minus.add(trigger.oldMap.get(oppy.id));
                            list_program2Plus.add(oppy);
                        }
                    }
                }
                // if phase is changed           
                else{                
                    if(oppy.stageName != trigger.oldMap.get(oppy.id).stageName || (oppy.Approval_Status_PMV__c == 'G0 Rejected' && oppy.Approval_Status_PMV__c != trigger.oldMap.get(oppy.id).Approval_Status_PMV__c)){//added by Jinbo Shan for PMV, the program's stage should changed when oppy.Approval_Status_PMV__c changed
                        if(oppy.Program__c != null) {
                            set_programId4Phase.add(oppy.Program__c);
                            //--Changed for Case-00901347--Start--//
                            if(set_excludeOppyPhase.contains(oppy.stageName)){
                                list_program2Minus.add(trigger.oldMap.get(oppy.id));
                            }
                            //--Changed for Case-00901347--End--//
                        }
                    }
                }
            }
            if(!list_program2Minus.isEmpty() || !set_programId4Phase.isEmpty()) ClsOppyUtil.recalculateConnectedProgram(list_program2Minus, set_programId4Phase, 'Delete', list_program2Update);
            if(!list_program2Plus.isEmpty()) ClsOppyUtil.recalculateConnectedProgram(list_program2Plus, null, 'Insert', list_program2Update);
        }
        
        // delete
        else if(trigger.isDelete){
            ClsOppyUtil.recalculateConnectedProgram(trigger.old, null, 'Delete', list_program2Update);            
        }
        
        // update program
        //--Changed for Case-00901347--Start--//       
        //if(!list_program2Update.isEmpty()) update list_program2Update;
        if(!list_program2Update.isEmpty()){
            update list_program2Update;
            ExecuteOnce.SF2SF_OPPORTUNITY = true;
        }
        //--Changed for Case-00901347--End--//
        
        /** Create forecast records on NDR opportunity **/
       /** Apex_Helper_Settings__c config = Apex_Helper_Settings__c.getInstance('NDR Opportunity');
        Id ndrRecordType = config.Value__c;
        
        if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
            List<Opportunity> lstOppties = new List<Opportunity>();
            //Set<Id> setOpptyIds = new Set<Id>();
            for(Opportunity oppty : Trigger.new){
                system.debug('oppty.NDR_Quote_Status_Description__c:::' + oppty.NDR_Quote_Status_Description__c + 'oppty.Opportunity_Already_Exist__c::::' + oppty.Opportunity_Already_Exist__c + 'oppty.Renew_Existing_NDR__c::::'+ oppty.Renew_Existing_NDR__c + 'oppty.RecordTypeId::::' + oppty.RecordTypeId);
                if(OpptyNDRForecastUtil.isOpportunityComplete(oppty.NDR_Quote_Status_Description__c) 
                   && oppty.Opportunity_Already_Exist__c != true 
                   && oppty.Renew_Existing_NDR__c != true 
                   && oppty.RecordTypeId == ndrRecordType){
                    
                    if(trigger.isInsert){
                        lstOppties.add(oppty); 
                        //setOpptyIds.add(oppty.Id);
                    }
                    if(Trigger.isUpdate && oppty.NDR_Quote_Status_Description__c != Trigger.oldMap.get(oppty.Id).NDR_Quote_Status_Description__c){
                        lstOppties.add(oppty);
                        //setOpptyIds.add(oppty.Id);
                    }               
                }           
            }
            system.debug('lstOppties:::'+lstOppties);       
            if(lstOppties.size() > 0){
                OpptyNDRForecastUtil.addPartsToOpptyForecast(lstOppties);
            }**/
            /**
            if(setOpptyIds.size() > 0){
                OpptyNDRForecastUtil.addPartsToOpptyForecast(setOpptyIds);
            }               
        } **/   
        /** Create forecast records on NDR opportunity **/
    }
}