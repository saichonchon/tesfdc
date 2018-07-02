/**
 *  This one time batch is used to create/update Engineering MileStone records
 *  
 * @author Rajendra Shahane
 * @created 2016-02-18
 * @version 1.0
 * @since 23.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2016-02-18 Rajendra Shahane <rajendra.shahane@zensar.in>
 * - Created
 * - This batch is created for one time execution only for case 00900591 for the craetion/update of engineering milestones records where existing opportunity of
 * - Channel Engineering Opportunities,Platform Opportunities,TAM, Opportunity - Engineering Project, 
 * - Engineering Opportunity-CSD, IND - Engineering project and DND Opportunity recordtypes who are missing engineering milestones records or do not have External_Id__c field updated
 */
global class ClsBatch_CreateUpdateEngMilestone implements Database.Batchable<SObject>
{
    /**
    * the sql query statement that will select the data will be used in this batch class
    */  
    public String query;
   
    global Database.QueryLocator start(Database.BatchableContext BC)
    { 
        map<string,Opportunity_Record_Type_Groups__c> mapOpportunityRecordTypeGroups = Opportunity_Record_Type_Groups__c.getall();
        if (mapOpportunityRecordTypeGroups != null && mapOpportunityRecordTypeGroups.size() > 0 && (query == null || query == ''))
        {
            set<Id> setEligibleOppRecordTypeId = new set<Id>();
            for(Opportunity_Record_Type_Groups__c RecordTypeGroup: mapOpportunityRecordTypeGroups.values())
            {
                if(RecordTypeGroup.Active__c == true && RecordTypeGroup.Group__c == 'Engineering Milestones Opportunities')
                    setEligibleOppRecordTypeId.add((Id)RecordTypeGroup.RecordTypeID__c);
            }
            query = 'Select Id,RecordtypeId,PLM_Id__c from Opportunity where RecordTypeId in : setEligibleOppRecordTypeId' ;
            return Database.getQueryLocator(query);
        }
        return null;
    }

    global void execute(Database.BatchableContext BC, List<Opportunity> lstOpportunity)
    {
        Schema.DescribeFieldResult desResult = Engineering_Milestone__c.Gate__c.getDescribe();
    
        List<Engineering_Milestone__c> list_engMileStones2Insert = new List<Engineering_Milestone__c>();
        List<Engineering_Milestone__c> list_engMileStones2Update = new List<Engineering_Milestone__c>();
        map<Id,List<Engineering_Milestone__c>> mapOptyEngineeringMilestone = new map<Id,List<Engineering_Milestone__c>>();
        map<Id,Opportunity> mapEligibleOpportunity = new map<Id,Opportunity>();
        for(Opportunity oppy: lstOpportunity)
        {
            mapEligibleOpportunity.put(oppy.Id, oppy);
            mapOptyEngineeringMilestone.put(oppy.Id,new List<Engineering_Milestone__c>());
        }
        for(Engineering_Milestone__c engMileStone : [Select Id, External_Id__c, Gate__c, Opportunity__c From Engineering_Milestone__c Where Opportunity__c in :mapEligibleOpportunity.keySet()])
        {
            mapOptyEngineeringMilestone.get(engMileStone.Opportunity__c).add(engMileStone);
        }
        for(Id OptyId: mapEligibleOpportunity.keyset())
        {
            Opportunity CurrentOpportunity = mapEligibleOpportunity.get(OptyId);
            if(mapOptyEngineeringMilestone.get(OptyId).size() > 0 )
            {
                if(CurrentOpportunity.PLM_Id__c != null)
                {
                    for(Engineering_Milestone__c engMileStone1: mapOptyEngineeringMilestone.get(OptyId))
                    {   
                        if(engMileStone1.External_Id__c == null || !engMileStone1.External_Id__c.contains(CurrentOpportunity.PLM_Id__c)||!engMileStone1.External_Id__c.contains(CurrentOpportunity.Id))
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
    
    global void finish(Database.BatchableContext BC){   }
}