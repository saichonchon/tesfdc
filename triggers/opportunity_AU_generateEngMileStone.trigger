/**
*   The trigger is used to create/update Engineering MileStone records
*
@author Min Liu
@created 2012-05-02
@version 1.0
@since       23.0 (Force.com ApiVersion) 
*
@changelog
* 2013-03-04 Jinbo Shan <jinbo.shan@itbconsult.com>
* modify for PMV record type. 
*
* 2012-05-02 Min Liu <min.liu@itbconsult.com>
* - Created
* 2014-05-08 Bin Yu <bin.yu@itbconsult.com>
* - added trigger-defense
* - Modidied
* 2016-02-17 Rajendra Shahane <rajendra.shahane@zensar.in>
* - Modified trigger for case 00900591 for craetion of engineering milestones when opportunity of
* - Channel Engineering Opportunities,Platform Opportunities,TAM, Opportunity - Engineering Project, 
* - Engineering Opportunity-CSD, IND - Engineering project and DND Opportunity recordtypes are inserted/updated
*  2017-03-20 Mrunal Parate <Mrunal.parate@te.com>
* - Updated External Id value by adding Opptyid at the end of it for case 901189.
*/

trigger opportunity_AU_generateEngMileStone on Opportunity (after update, after insert) {

    //added by BYU 2014-05-08 
    //if(ClsPMV_Util.runningTriggerName.indexOf('opportunity_AU_generateEngMileStone') == -1){
        //ClsPMV_Util.runningTriggerName += 'opportunity_AU_generateEngMileStone';    
        //************************* BEGIN Pre-Processing **********************************************
        // start: commented by Rajendra 2016-02-17
        /*
        Map<id, String> map_rid_rname = new Map<id, String>();
        Map<Id, String> map_oppyId_plmId = new Map<Id, String>();
        Set<Id> set_oppyIds = new Set<Id>();
        */
        // End: commented by Rajendra 2016-02-17
        //************************* END Pre-Processing ************************************************
        
        //************************* BEGIN Before Trigger **********************************************
        //************************* END Before Trigger ************************************************
        
        //************************* BEGIN After Trigger ***********************************************
        
    system.debug('@opportunity_AU_generateEngMileStone');
        List<Engineering_Milestone__c> list_engMileStones2Insert = new List<Engineering_Milestone__c>();
        List<Engineering_Milestone__c> list_engMileStones2Update = new List<Engineering_Milestone__c>();
        Schema.DescribeFieldResult desResult = Engineering_Milestone__c.Gate__c.getDescribe();
        
        //Start: added by Rajendra 2016-02-17
        set<Id> setEligibleOppRecordTypeId = new set<Id>();
        map<string,Opportunity_Record_Type_Groups__c> mapOpportunityRecordTypeGroups = Opportunity_Record_Type_Groups__c.getall();
        map<Id,Opportunity> mapEligibleOpportunity = new map<Id,Opportunity>();
        
        if(mapOpportunityRecordTypeGroups != null && mapOpportunityRecordTypeGroups.size() > 0)
        {
            system.debug('@opportunity_AU_generateEngMileStone111');
            //creating set of Channel Engineering Opportunities,Platform Opportunities,TAM, Opportunity - Engineering Project, Engineering Opportunity-CSD, IND - Engineering project and DND Opportunity recordtypeIds
            for(Opportunity_Record_Type_Groups__c RecordTypeGroup: mapOpportunityRecordTypeGroups.values())
            {
                if(RecordTypeGroup.Active__c == true && RecordTypeGroup.Group__c == 'Engineering Milestones Opportunities')
                    setEligibleOppRecordTypeId.add((Id)RecordTypeGroup.RecordTypeID__c);
                
            }
            system.debug('@opportunity_AU_generateEngMileStone111set : ' +setEligibleOppRecordTypeId );
            //creating opportunity map of Channel Engineering Opportunities,Platform Opportunities,TAM, Opportunity - Engineering Project, Engineering Opportunity-CSD, IND - Engineering project and DND Opportunity recordtypeIds
            map<Id,List<Engineering_Milestone__c>> mapOptyEngineeringMilestone = new map<Id,List<Engineering_Milestone__c>>();
            if(setEligibleOppRecordTypeId.size() > 0)
            {
                system.debug('@opportunity_AU_generateEngMileStone222');
                for(Opportunity oppy: Trigger.New)
                {
                    if(setEligibleOppRecordTypeId.contains(oppy.RecordtypeId))
                    {                      
                        mapEligibleOpportunity.put(oppy.Id, oppy);
                        mapOptyEngineeringMilestone.put(oppy.Id,new List<Engineering_Milestone__c>());
                        
                    }
                }
            }
            //serching for existing Engineering_Milestone__c records, if Engineering_Milestone__c records are present then update Engineering_Milestone__c.External_Id__c 
            // on basis of Opportunity.PLM_Id__c field
            if(mapEligibleOpportunity.size() > 0)
            {
                system.debug('@opportunity_AU_generateEngMileStone333');
                for(Engineering_Milestone__c engMileStone : [Select Id, External_Id__c, Gate__c, Opportunity__c From Engineering_Milestone__c Where Opportunity__c in :mapEligibleOpportunity.keySet()])
                {
                    mapOptyEngineeringMilestone.get(engMileStone.Opportunity__c).add(engMileStone);
                }
                for(Id OptyId: mapEligibleOpportunity.keyset())
                {
                    Opportunity CurrentOpportunity = mapEligibleOpportunity.get(OptyId);
                    if(mapOptyEngineeringMilestone.get(OptyId).size() > 0 )
                    {
                        if(trigger.isupdate && CurrentOpportunity.PLM_Id__c != null 
                        && trigger.oldmap.get(OptyId).PLM_Id__c != CurrentOpportunity.PLM_Id__c)
                        {
                            for(Engineering_Milestone__c engMileStone1: mapOptyEngineeringMilestone.get(OptyId))
                            {   
                                //Change start by Mrunal to Update External Id value by adding Opptyid at the end for case 901189.
                                if(engMileStone1.Gate__c == 'Project Start')
                                    engMileStone1.External_Id__c = CurrentOpportunity.PLM_Id__c + '|' + 'PROJECT_START' + '|' + CurrentOpportunity.Id;
                                else if(engMileStone1.Gate__c == 'Definition Completion (G1)')
                                    engMileStone1.External_Id__c = CurrentOpportunity.PLM_Id__c + '|' + 'DEFINITION_CPLT' + '|' + CurrentOpportunity.Id;
                                else if(engMileStone1.Gate__c == 'Concept Completion (G2)')
                                    engMileStone1.External_Id__c = CurrentOpportunity.PLM_Id__c + '|' + 'CONCEPT_COMPLETION' + '|' + CurrentOpportunity.Id;
                                else if(engMileStone1.Gate__c == 'Design Completion (G3)')
                                    engMileStone1.External_Id__c = CurrentOpportunity.PLM_Id__c + '|' + 'DESIGN_COMPLETION' + '|' + CurrentOpportunity.Id;
                                else if(engMileStone1.Gate__c == 'Validation Completion (G4)')
                                    engMileStone1.External_Id__c = CurrentOpportunity.PLM_Id__c + '|' + 'TOOL_COMPLETION' + '|' + CurrentOpportunity.Id;
                                else if(engMileStone1.Gate__c == 'Industrialize Completion (G5)')
                                    engMileStone1.External_Id__c = CurrentOpportunity.PLM_Id__c + '|' + 'INDUSTRIALIZE_CPLT' + '|' + CurrentOpportunity.Id;
                                else if(engMileStone1.Gate__c == 'Production Completion (G6)')
                                    engMileStone1.External_Id__c = CurrentOpportunity.PLM_Id__c + '|' + 'PROJECT_COMPLETION_6' + '|' + CurrentOpportunity.Id;
                                else if(engMileStone1.Gate__c == 'Launch Date')
                                    engMileStone1.External_Id__c = CurrentOpportunity.PLM_Id__c + '|' + 'LAUNCH' + '|' + CurrentOpportunity.Id;
                                else
                                    engMileStone1.External_Id__c = CurrentOpportunity.PLM_Id__c + '|' + 'PROJECT_COMPLETION_8' + '|' + CurrentOpportunity.Id;
                                // Change end by Mrunal for Case 901189
                                list_engMileStones2Update.add(engMileStone1);
                            }
                        }
                    }
                    else
                    {   
                        for(Schema.PicklistEntry gateVal : desResult.getPicklistValues())
                        {
                            Engineering_Milestone__c engMileStone = new Engineering_Milestone__c();
                            engMileStone.Gate__c = gateVal.getValue();                          
                            engMileStone.Opportunity__c = OptyId;
                            if(CurrentOpportunity.PLM_Id__c != null)
                            {
                                //Change start by Mrunal to Update External Id value by adding Opptyid at the end for case 901189.
                                if(engMileStone.Gate__c == 'Project Start')
                                    engMileStone.External_Id__c = CurrentOpportunity.PLM_Id__c + '|' + 'PROJECT_START' + '|' + CurrentOpportunity.Id;
                                else if(engMileStone.Gate__c == 'Definition Completion (G1)')
                                    engMileStone.External_Id__c = CurrentOpportunity.PLM_Id__c + '|' + 'DEFINITION_CPLT' + '|' + CurrentOpportunity.Id;
                                else if(engMileStone.Gate__c == 'Concept Completion (G2)')
                                    engMileStone.External_Id__c = CurrentOpportunity.PLM_Id__c + '|' + 'CONCEPT_COMPLETION' + '|' + CurrentOpportunity.Id;
                                else if(engMileStone.Gate__c == 'Design Completion (G3)')
                                    engMileStone.External_Id__c = CurrentOpportunity.PLM_Id__c + '|' + 'DESIGN_COMPLETION' + '|' + CurrentOpportunity.Id;
                                else if(engMileStone.Gate__c == 'Validation Completion (G4)')
                                    engMileStone.External_Id__c = CurrentOpportunity.PLM_Id__c + '|' + 'TOOL_COMPLETION' + '|' + CurrentOpportunity.Id;
                                else if(engMileStone.Gate__c == 'Industrialize Completion (G5)')
                                    engMileStone.External_Id__c = CurrentOpportunity.PLM_Id__c + '|' + 'INDUSTRIALIZE_CPLT' + '|' + CurrentOpportunity.Id;
                                else if(engMileStone.Gate__c == 'Production Completion (G6)')
                                    engMileStone.External_Id__c = CurrentOpportunity.PLM_Id__c + '|' + 'PROJECT_COMPLETION_6' + '|' + CurrentOpportunity.Id;
                                else if(engMileStone.Gate__c == 'Launch Date')
                                    engMileStone.External_Id__c = CurrentOpportunity.PLM_Id__c + '|' + 'LAUNCH' + '|' + CurrentOpportunity.Id;
                                else
                                    engMileStone.External_Id__c = CurrentOpportunity.PLM_Id__c + '|' + 'PROJECT_COMPLETION_8' + '|' + CurrentOpportunity.Id;
                                 // Change end by Mrunal for Case 901189
                            }
                            list_engMileStones2Insert.add(engMileStone);
                        }
                    }
                }
                
                if(!list_engMileStones2Insert.isEmpty())
                    insert list_engMileStones2Insert;
                
                if(!list_engMileStones2Update.isEmpty())
                    update list_engMileStones2Update;
            }
        }
        
        
        //End : added by Rajendra 2016-02-17
        //Start Commented by Rajendra 2016-02-17
        /*if(Trigger.isInsert){
            for(RecordType rt: [SELECT Name, Id, DeveloperName, SobjectType FROM RecordType where SobjectType='Opportunity']){
                map_rid_rname.put(rt.id, rt.DeveloperName);
            }
            for(Opportunity oppy: Trigger.New){
               //modified by padmaja for Engineering CSD record Type    
                 if(map_rid_rname.get(oppy.recordTypeId) == 'TAM' || map_rid_rname.get(oppy.recordTypeId) == 'Opportunity_Engineering_Project' || map_rid_rname.get(oppy.recordTypeId) == 'Engineering_Opportunity_CSD' || map_rid_rname.get(oppy.recordTypeId) == 'IND_Engineering_project'){//modfiy by Jinbo Shan for PMV record types IND_Engineering_project only
                    for(Schema.PicklistEntry gateVal : desResult.getPicklistValues()){
                        Engineering_Milestone__c engMileStone = new Engineering_Milestone__c();
                        engMileStone.Gate__c = gateVal.getValue();
                        
                        engMileStone.Opportunity__c = oppy.id;
                        list_engMileStones2Insert.add(engMileStone);
                    }
                }       
            }
            
            if(!list_engMileStones2Insert.isEmpty()){
                insert list_engMileStones2Insert;
            }
        }
        
        if(Trigger.isUpdate){
            //added by weihang 2014-03-10  begin
            List<RecordType> list_rdTypes = new List<RecordType>();
            list_rdTypes = [SELECT Name, Id, DeveloperName, SobjectType FROM RecordType where SobjectType='Opportunity'];
            //added by weihang 2014-03-10 end 
            for(Opportunity oppy: Trigger.New){
                if(Trigger.oldMap.get(oppy.Id).PLM_Id__c != oppy.PLM_Id__c && oppy.PLM_Id__c != null){
                    if(map_rid_rname.isEmpty()){
                        /*comment out by weihang 2014-03-10
                        for(RecordType rt: [SELECT Name, Id, DeveloperName, SobjectType FROM RecordType where SobjectType='Opportunity']){
                            map_rid_rname.put(rt.id, rt.DeveloperName);
                        }comment out by weihang 2014-03-10
                        for(RecordType rt:list_rdTypes){
                            map_rid_rname.put(rt.id, rt.DeveloperName);
                        }
                    }
                   //modified by padmaja for Engineering CSD record Type   
                if(map_rid_rname.get(oppy.recordTypeId) == 'TAM' || map_rid_rname.get(oppy.recordTypeId) == 'Opportunity_Engineering_Project' || map_rid_rname.get(oppy.recordTypeId) == 'Engineering_Opportunity_CSD' || map_rid_rname.get(oppy.recordTypeId) == 'IND_Engineering_project') map_oppyId_plmId.put(oppy.Id, oppy.PLM_Id__c);//modfiy by Jinbo Shan for PMV record types IND_Engineering_project only
                }
            }
        }
        
        if(map_oppyId_plmId.size() > 0){    
            for(Engineering_Milestone__c engMileStone : [Select Id, External_Id__c, Gate__c, Opportunity__c From Engineering_Milestone__c Where Opportunity__c in :map_oppyId_plmId.keySet()]){
                
                if(engMileStone.Gate__c == 'Project Start'){
                    engMileStone.External_Id__c = map_oppyId_plmId.get(engMileStone.Opportunity__c) + '|' + 'PROJECT_START';
                }
                else if(engMileStone.Gate__c == 'Definition Completion (G1)'){
                    engMileStone.External_Id__c = map_oppyId_plmId.get(engMileStone.Opportunity__c) + '|' + 'DEFINITION_CPLT';
                }
                else if(engMileStone.Gate__c == 'Concept Completion (G2)'){
                    engMileStone.External_Id__c = map_oppyId_plmId.get(engMileStone.Opportunity__c) + '|' + 'CONCEPT_COMPLETION';
                }
                else if(engMileStone.Gate__c == 'Design Completion (G3)'){
                    engMileStone.External_Id__c = map_oppyId_plmId.get(engMileStone.Opportunity__c) + '|' + 'DESIGN_COMPLETION';
                }
                else if(engMileStone.Gate__c == 'Validation Completion (G4)'){
                    engMileStone.External_Id__c = map_oppyId_plmId.get(engMileStone.Opportunity__c) + '|' + 'EVALUATION_CPLT';
                }
                else if(engMileStone.Gate__c == 'Industrialize Completion (G5)'){
                    engMileStone.External_Id__c = map_oppyId_plmId.get(engMileStone.Opportunity__c) + '|' + 'INDUSTRIALIZE_CPLT';
                }
                else if(engMileStone.Gate__c == 'Production Completion (G6)'){
                    engMileStone.External_Id__c = map_oppyId_plmId.get(engMileStone.Opportunity__c) + '|' + 'TOOL_COMPLETION';
                }
                else if(engMileStone.Gate__c == 'Launch Date'){
                    engMileStone.External_Id__c = map_oppyId_plmId.get(engMileStone.Opportunity__c) + '|' + 'LAUNCH';
                }
                else{
                    engMileStone.External_Id__c = map_oppyId_plmId.get(engMileStone.Opportunity__c) + '|' + 'PROJECT_COMPLETION';
                }
                
                list_engMileStones2Update.add(engMileStone);
            }
            
            if(!list_engMileStones2Update.isEmpty()){
                update list_engMileStones2Update;
            }
        }*/
        // End: commented by Rajendra 2016-02-17
        
        //************************* END After Trigger *************************************************
    //}
}