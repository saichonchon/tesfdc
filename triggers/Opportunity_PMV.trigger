/**
 * This trigger used for PMV
 *
 * @author      Jinbo Shan
 * @created     2014-02-18
 * @since       28.0 (Force.com ApiVersion)      
 * @version     1.0 
 *
 * @changelog
 *  2014-02-18 Jinbo Shan <jinbo.shan@itbconsult.com>
 * - Created 
 * 
 */
trigger Opportunity_PMV on Opportunity (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
    //************************* BEGIN Pre-Processing **********************************************
    map<Id, String> map_oId_PMVType = new map<Id, String>();//used to store owner id and its corresponding PMV type
    map<Id, Opportunity> map_oppyId_oppys = new map<Id, Opportunity>();

    set<Opportunity> set_oppIds4projectedClosedDate = new set<Opportunity>();
    set<Opportunity> set_oppIds4salesName = new set<Opportunity>();   
    set<Id> set_oppyId4oppyStage = new set<Id>();
    set<Id> set_rts = ClsPMV_Util.getAllPMVRecordtypes();
    set<Id> set_ownerId = new set<Id>();//used to collect owner id of oppy 
    set<Id> set_industryUserId = new set<Id>();
    set<Id> set_ownerId4PMVType = new set<Id>(); //used to collect owner id of oppy for PMV type setting

    list<Opportunity> list_oppys4setScore = new list<Opportunity>();  
    
    if(trigger.isBefore){
        if(trigger.isInsert){
            
            //Start : added by yuanyuan zhang used to set PMV record type for lead conversion
            for(Opportunity oppy : trigger.new){
                //if(set_rts.contains(oppy.RecordTypeId)){
                if(oppy.Lead_ID__c != null){
                    set_ownerId.add(oppy.OwnerId);
                }
                //}
            }
            
            if(!set_ownerId.isEmpty()){
                set_industryUserId = ClsPMV_Util.getIndustryUser(set_ownerId);
                for(Opportunity oppy : trigger.new){
                    if(oppy.Lead_ID__c != null && set_industryUserId.contains(oppy.OwnerId)){
                        oppy.RecordTypeId = ClsPMV_Util.getPMVRecordTypeForLeadOppy();
                    }
                }
            }
            //END
            
            for(Opportunity oppy : trigger.new){
                if(set_rts.contains(oppy.RecordTypeId)){
                    oppy.Stage_Entered__c = system.today();
                    set_ownerId4PMVType.add(oppy.OwnerId);//
                    set_oppIds4salesName.add(oppy);
                    set_oppIds4projectedClosedDate.add(oppy);
                    list_oppys4setScore.add(oppy);
                }
            }
            
        }else if (trigger.isUpdate){
            //set amout to 0 when Opportunity StageName = 'Lost' or 'Dead'
            for(Opportunity oppy : trigger.new) {
                //added by Jinbo Shan Task: R-365: If Opp is G0 Rejected, opp has to be lost
                if(set_rts.contains(oppy.RecordTypeId) && oppy.Approval_Status_PMV__c != trigger.oldMap.get(oppy.Id).Approval_Status_PMV__c && oppy.Approval_Status_PMV__c == 'G0 Rejected') {
                    oppy.StageName = 'Lost';
                }
                
                if(set_rts.contains(oppy.RecordTypeId) && oppy.StageName != trigger.oldMap.get(oppy.Id).StageName && (oppy.StageName == 'Dead' || oppy.StageName == 'Lost')) {
                    oppy.Amount = 0;
                    oppy.Five_Year_Revenue__c = 0;
                }
                
            }
            
            //-- Changed by Rahul(10 Nov 2017)--optimize code--using single loop--original code is commented--Start--//
            for(Opportunity oppy : trigger.new){
                if(set_rts.contains(oppy.RecordTypeId)){
                    //Add OwnerId value to field Opp_Owner_at_time_of_conversion__c, when stage is changing to production.
                    if(oppy.StageName != trigger.oldMap.get(oppy.Id).StageName && oppy.StageName == 'Production') {
                        oppy.Opp_Owner_at_time_of_conversion__c = oppy.OwnerId;
                    }
                    
                    //before update should update its projectedClosedDate
                    if(oppy.StageName != trigger.oldMap.get(oppy.Id).StageName){
                        set_oppIds4projectedClosedDate.add(oppy);
                    }
                    
                    if(oppy.RecordTypeId != trigger.oldMap.get(oppy.Id).RecordTypeId){
                        set_oppIds4salesName.add(oppy);
                        set_ownerId4PMVType.add(oppy.OwnerId);      //PMV type setting  
                    }
                    
                    //START:delete error message field after oppy stage is successful updated
                    if(oppy.StageName != trigger.oldmap.get(oppy.Id).StageName && oppy.Stage_Change_Error_Message__c != null){
                        oppy.Stage_Change_Error_Message__c = null;
                    }
                    //End:
                    
                    //start: set Score for Opportunity when stageName or buying_cycle changed. Jinbo Shan at 2014-06-06 
                    if((oppy.StageName != trigger.oldMap.get(oppy.Id).StageName || oppy.Buying_Cycle__c != trigger.oldMap.get(oppy.Id).Buying_Cycle__c)) {
                        list_oppys4setScore.add(oppy);
                    }
                    //End:
                }
                
                //START: PMV type setting
                if(!set_rts.contains(oppy.RecordTypeId) && oppy.PMV_Type__c != null){
                    oppy.PMV_Type__c = null;
                }
                //End:
            }            
            //-- Changed by Rahul(10 Nov 2017)--optimize code--using single loop--original code is commented--End--//
        }
        
        if(set_oppIds4salesName.size()>0){
            ClsPMV_Util.setSalesProcessName(set_oppIds4salesName);
        }
        
        //START: PMV type setting
        if(!set_ownerId4PMVType.isEmpty()){
            map_oId_PMVType = ClsPMV_Util.setPMVType(trigger.new,set_ownerId4PMVType, set_rts);
            system.debug('###map_oId_PMVType: ' + map_oId_PMVType);
            for(Opportunity oppy : trigger.new){
                if(set_rts.contains(oppy.RecordTypeId)){
                    if(map_oId_PMVType.containsKey(oppy.Id)){
                        if(map_oId_PMVType.get(oppy.Id) == null){
                            oppy.addError(system.Label.PMV_Type_Is_Null);
                        }
                        else oppy.PMV_Type__c = map_oId_PMVType.get(oppy.Id);
                    }
                    else{
                        oppy.addError(system.Label.PMV_Type_Is_Null);
                    }
                }
            }
        }
        //END
        
        if(set_oppIds4projectedClosedDate.size()>0){
            ClsPMV_Util.getProjectClosedDateForOppy(set_oppIds4projectedClosedDate);
        }
        
        if(list_oppys4setScore.size() > 0) {
            ClsPMV_Util.setScoreValue(list_oppys4setScore);
        }
        
    }
    
    if(trigger.isAfter){
        if(trigger.isUpdate){
            if(!ClsPMV_Util.hasUpdate){
                //START: added for trigger after approval
                set<Id> set_oppyAfterApproval = new set<Id>();
                //END

                //-- Changed by Rahul(10 Nov 2017)--optimize code--inside single loop-orginal code is commented--Start--//
                for(Opportunity oppy : trigger.new) {
                    if(set_rts.contains(oppy.RecordTypeId) && oppy.PMV_Type__c != null){
                        //START:Update Oppy Part status for current oppy Stage
                        if(oppy.StageName != trigger.oldMap.get(oppy.Id).StageName){// && oppy.StageName != 'Lost' && oppy.StageName != 'Dead'
                            set_oppyId4oppyStage.add(oppy.Id);
                        }
                        //End:
                        //START: added by yuanyuan zhang if oppy is exit from approval process, then update oppy stage and its oppy parts
                        if(oppy.Approval_Status_PMV__c != 'G0 In Approval' && oppy.Approval_Status_PMV__c != 'Conversion In Approval' && oppy.Approval_Status_PMV__c != trigger.oldMap.get(oppy.Id).Approval_Status_PMV__c && oppy.StageName != 'Lost' && oppy.StageName != 'Dead'){
                            set_oppyAfterApproval.add(oppy.Id);
                        }
                        //END:
                    }
                }
                if(set_oppyId4oppyStage.size()>0){
                    ClsPMV_Util.updateOppyStageForStage(set_oppyId4oppyStage);
                }
                //-- Changed by Rahul(10 Nov 2017)--optimize code--inside single loop--End--//
                
                //Start : update oppy recordtype
                set<Id> set_PMV2NonePMV = new set<Id>();
                set<Id> set_PMV2PMV = new set<Id>();
                set<Id> set_nonePMV2PMV = new set<Id>();
                
                for(Opportunity oppy : trigger.new){
                    if((oppy.RecordTypeId != trigger.oldMap.get(oppy.Id).RecordTypeId) || (oppy.PMV_Type__c != trigger.oldMap.get(oppy.Id).PMV_Type__c)){
                        if(set_rts.contains(oppy.RecordTypeId) && oppy.PMV_Type__c != null){
                            if(set_rts.contains(trigger.oldMap.get(oppy.Id).RecordTypeId) && trigger.oldMap.get(oppy.Id).PMV_Type__c != null){
                                set_PMV2PMV.add(oppy.Id);
                            }
                            else set_nonePMV2PMV.add(oppy.Id);
                        }
                        else if(set_rts.contains(trigger.oldMap.get(oppy.Id).RecordTypeId) && trigger.oldMap.get(oppy.Id).PMV_Type__c != null){
                            set_PMV2NonePMV.add(oppy.Id);
                        }
                    }
                }
                
                if(!set_PMV2NonePMV.isEmpty()) ClsPMV_Util.oppyRTPMV2NonePMV(set_PMV2NonePMV);
                if(!set_PMV2PMV.isEmpty()) ClsPMV_Util.oppyRTPMV2PMV(set_PMV2PMV);
                if(!set_nonePMV2PMV.isEmpty()) ClsPMV_Util.oppyRTNonePMV2PMV(set_nonePMV2PMV);
                //END
                
                //START: recalculate stage after approval
                if(!set_oppyAfterApproval.isEmpty()){
                    ClsPMV_Util.recalculateOppyStageFuture(set_oppyAfterApproval);
                }
                //END
                
                //START: added by yuanyuan zhang check wether decision criterias should be created and if oppy has corresponding key player, then create key player criteria
                List<Opportunity> list_oppyUpdate2decisionCriteria = new List<Opportunity>();
                for(Opportunity oppy : trigger.new){
                    if(set_rts.contains(oppy.RecordTypeId) && oppy.PMV_Type__c != null){
                        if(oppy.RecordTypeId != trigger.oldMap.get(oppy.Id).RecordTypeId){// && set_rts.contains(trigger.oldMap.get(oppy.Id).RecordTypeId)
                            list_oppyUpdate2decisionCriteria.add(oppy);
                        }
                    }
                }
                
                if(list_oppyUpdate2decisionCriteria.size() > 0){
                    Boolean hasDecisionCriteria = ClsPMV_Util.hasDecisionCriteria(list_oppyUpdate2decisionCriteria);
                    if(!hasDecisionCriteria){
                        ClsPMV_Util.oppyRTNonPMV2PMVAddDecisionCriteria(list_oppyUpdate2decisionCriteria);
                    }
                    Boolean hasKeyPlayerCriteria = ClsPMV_Util.hasKeyPlayerCriteria(list_oppyUpdate2decisionCriteria);
                    if(!hasKeyPlayerCriteria){
                        ClsPMV_Util.oppyRTNonPMV2PMVAddKeyPlayerCriteria(list_oppyUpdate2decisionCriteria);
                    }
                }
                
                //END
            }
            
        }
        else if(trigger.isInsert){
            //On lead conversion, we should create a Custom Opportunity Contact Role for current Opprotunity
            //-- Changed by Rahul(10 Nov 2017)--optimize code--using single loop--original code is commented--Start--//
            set<Id> set_oppyId = new set<Id>();
            for(Opportunity oppy : trigger.new){
                if(oppy.Lead_ID__c != null ){
                    set_oppyId.add(oppy.Id);
                }
                
                if(set_rts.contains(oppy.RecordTypeId) && oppy.PMV_Type__c != null) {
                    //start : add answers for Opportunity's questions. added by yuanyuan zhang create Decision Criteria
                    map_oppyId_oppys.put(oppy.Id, oppy);
                    //end
                }
            }
            if(set_oppyId.size() > 0){
                ClsPMV_Util.createContactRoleForLeadOpportunity(set_oppyId);
            }
            if(map_oppyId_oppys.size() > 0) {
                ClsPMV_Util.initQualifierQuestionForOpp(map_oppyId_oppys);
                ClsPMV_Util.oppyRTNonPMV2PMVAddDecisionCriteria(map_oppyId_oppys.values());
            }
            //-- Changed by Rahul(10 Nov 2017)--optimize code--using single loop--original code is commented--End--//
            
        }
    } 
    
}