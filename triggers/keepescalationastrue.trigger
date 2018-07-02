/**********************************************************************************************************************************************
*******
Name: keepescalationastrue
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose:This trigger updates case if status is changed then IsEscalated dont turn off
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE          DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Narasimha Narra    8/10/2013       Trigger                       
***********************************************************************************************************************************************
 2.0   Ramakrishna Singara   13/03/2014       Trigger                       
***********************************************************************************************************************************************/

trigger keepescalationastrue on Case (before insert, before update,after update) 
{
    List<Case> caselist = new List<Case>();
    if(trigger.isBefore){
        if(trigger.isupdate){
            if(CaseUtil_CCP.KeepEscationtrueboolean == false){
                CaseUtil_CCP.KeepEscationtrueboolean =true;
                changeInOwnerfromCaseQueuetoUser.updateCaseRegion(trigger.newMap,trigger.oldmap);
            }
            for(Case c : trigger.new){               
                if(c.isEscalated == false && trigger.oldmap.get(c.Id).isEscalated == true){
                    c.isEscalated = true;                   
                }                              
            } 
             customerSurvey.updateSurveyContact(trigger.newMap,trigger.oldmap);           
        }
        if(Trigger.isInsert && CaseUtil_CCP.KeepEscationBeforeInsert == false){
            CaseUtil_CCP.KeepEscationBeforeInsert =true;
            changeInOwnerfromCaseQueuetoUser.CaseBeforeInsert(trigger.new);
        }       
    } 
    if(trigger.isAfter)
    {
        //CaseUtil_CCP.KeepEscationAfterUpdate=true;
        UpdateCaseMilestone.closeMilestone(trigger.newMap,trigger.oldmap);
        //customerSurvey.updateSurveyContact(trigger.newMap,trigger.oldmap);
        //KeepEscalationAsTrueOnCase.setEscalationofCase(trigger.newMap,trigger.oldmap);
        CaseAssignmentUsers.updateCaseOwner(trigger.newMap,trigger.oldMap);
    }
    
    //Enhanced by Ramakrishna Singara (13/03/2014)
    /*if(trigger.isBefore && Trigger.isInsert && CaseUtil_CCP.KeepEscationBeforeInsert == false){        
                   
            CaseUtil_CCP.KeepEscationBeforeInsert =true;
            changeInOwnerfromCaseQueuetoUser.CaseBeforeInsert(trigger.new);                     
       
    }*/
    
}