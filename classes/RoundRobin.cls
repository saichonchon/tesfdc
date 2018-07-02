/**************************************************************************************************************************************************
Name:  RoundRobin
Copyright © 2011 TE Connectivity
===================================================================================================================================================
Purpose: This class used to 
---------------------------------------------------------------------------------------------------------------------------------------------------       
APEX Triggers utilize this class: Lead_BI_executeRoute and MQLTrigger_CJMRoute
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
Version Developer          Date             Detail                               Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
1.0 Subramanian       02/12/2018      Initial Development                      Select growth long term project

**************************************************************************************************************************************************/
Public class RoundRobin{   
    Public Static Void UserAssignment(List<SObject> SObjectList){
        try {
            //Check if assignment owner has changed
            //
            Map<Id,Id> queueIds = new Map<Id,Id>();   //Trigger index --> Queue ID
            set<Id> queues = new set<Id>();
            List<SObject> QueueOwnersList = new List<SObject>();
            for (SObject SObj : SObjectList)
            {
                Id ownerId = (String)SObj.get('OwnerId');
                
                if(ownerId.getSObjectType() == Group.sObjectType ){
                    queues.add(ownerId);
                    QueueOwnersList.add(SObj);
                }
            }
        
            //
            //Find active Assignment Group for Queue
            //
            Map<Integer,Id> asgnGroupNameIds = new Map<Integer,Id>();   //Trigger index --> Assignment_Group_Name ID
            Map<Id,Assignment_Group_Queues__c> asgnGroupQueues = new Map<Id,Assignment_Group_Queues__c>(); //Queue ID --> Assignment Group Queues
            
            for(Assignment_Group_Queues__c[] agq : [SELECT Assignment_Group_Name__c, QueueId__c
                                                  FROM Assignment_Group_Queues__c 
                                                  WHERE QueueId__c in :queues
                                                  AND Active__c = 'True'])
            {
                for (Assignment_Group_Queues__c a: agq) {
                    queueIds.put(a.QueueId__c, a.Assignment_Group_Name__c);
                }                                           
            }
            
            if (queueIds.isEmpty()) return;
            //
            //Determine next valid user in Queue/Assignment Group for round robin
            //User with earliest last assignment date wins.
            //
            Map<Id,List<Assignment_Groups__c>> asgnGroups = new Map<Id,List<Assignment_Groups__c>>(); // Assignment Group Name ID --> User ID
            for(Assignment_Groups__c ags : [SELECT Group_Name__c, User__c, Last_Assignment__c, Millisecond__c 
                                           FROM Assignment_Groups__c 
                                           WHERE Group_Name__c in :queueIds.values() 
                                           AND Active__c = 'True' AND User_Active__c = 'True'
                                           ORDER BY Last_Assignment__c, Millisecond__c])
            {        
                if(!asgnGroups.containsKey(ags.Group_Name__c)){   
                    asgnGroups.put(ags.Group_Name__c, new List<Assignment_Groups__c>());            
                }
                asgnGroups.get(ags.Group_Name__c).add(ags);        
            }
        
            if (asgnGroups.isEmpty()) return;
        
            Map<Id,Assignment_Groups__c> updateAssignmentGroups = new Map<Id,Assignment_Groups__c>();
            Map<Id, datetime> latestAGDateTime = new Map<Id,datetime>();
            integer idx = 0;    
            for (SObject SObj : QueueOwnersList)
            {
                List<Assignment_Groups__c> ags = new List<Assignment_Groups__c>();
                
                ags = asgnGroups.get(queueIds.get((String)SObj.get('OwnerId')));
                
                if (ags!=null && ags.size()>0)
                {   
                    //Choose next user in line if user ID has already been used but not committed in this trigger batch 
                    Assignment_Groups__c ag = ags[math.mod(idx, ags.size())];
                        
                    //Assign User to Case as the new owner
                    SObj.put('OwnerId', ag.User__c);
                    try{
                        sObj.put('Status', 'Assigned - Unaccepted');
                    }catch(exception e){}
                    
                    //Set last assignment datetime
                    datetime now = datetime.now();
                    ag.Last_Assignment__c = now;
                    ag.Millisecond__c = now.millisecondGMT();
                    
                    //update only latest Assignment Groups per ID
                    if (latestAGDateTime.containsKey(ag.id)) {
                        if(latestAGDateTime.get(ag.id) < now) {
                            updateAssignmentGroups.put(ag.id, ag);
                            latestAGDateTime.put(ag.id, now);
                        }
                    } else {
                        updateAssignmentGroups.put(ag.id, ag);
                        latestAGDateTime.put(ag.id,now);
                    }
                    
                    idx++;
                }
            }
            //Map --> List/Array for DML update
            List<Assignment_Groups__c> updateAG = new List<Assignment_Groups__c>();
            for (Id agId : updateAssignmentGroups.keySet()) {
                updateAG.add(updateAssignmentGroups.get(agId));
            }
        
            System.debug('>>>>>Update Assignment Groups: '+updateAG);   
            
            //
            //Update last assignment for Assignment Group in batch
            //
            if (updateAG.size()>0) {                
              update updateAG;                
            }
        } catch (Exception e){
            String vStrError = 'Error Type = ' + e.getTypeName() + 
                                ' Error Line = ' + e.getLineNumber() + '' + 
                                ' Error Stack = ' + e.getStackTraceString() + 
                                ' Error Message = ' + e.getMessage();
                            
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,                   
                                     SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '',e.getStackTraceString());
        }
    }
}