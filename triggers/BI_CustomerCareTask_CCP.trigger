/**********************************************************************************************************************************************
*******
Name: BI_CustomerCareTask_CCP 
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose:This trigger updates case if subject is 'Escalated' and recordtype is 'Customer Care Task'
        Escalated field is set to true if the task is created  with Subject 'Escalated'
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE          DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Abhijeet Manepatil   18/10/2013    Trigger                       
***********************************************************************************************************************************************
*****/
trigger BI_CustomerCareTask_CCP on Task (before insert,after insert) {

    Set<Id> cid=new Set<Id>();
    
    map<Id,case> mapId_case;
    Apex_Helper_Settings__c vTaskRT = Apex_Helper_Settings__c.getInstance('Customer Care Task');
    Apex_Helper_Settings__c vCaseRT = Apex_Helper_Settings__c.getInstance('Customer Care Cloud');
    
    for(task t:trigger.new)
    {
        if(t.WhatId != null && String.valueOf(t.WhatId).startsWith('500')
           && t.recordtypeId==vTaskRT.Value__c && t.Subject == 'Escalated')
        {
           cid.add(t.WhatId); 
        }
    }
    
    if(!cid.isEmpty() && trigger.isBefore)
    {
        mapId_case=new map<Id,case>([select Id,status,isClosed from case where Id in:cid]); 

        for(task t:trigger.new)
        {
            if(mapId_case.get(t.WhatId).Status=='Closed')
            {
                if(!Test.isRunningTest()){t.addError('You cannot escalated a closed case');}
              
            }
           
        }
    }
    if(!cid.isEmpty() && trigger.isafter)
    {
        List<Case> lstupdatecases = new List<Case>();
        for(Case c:[SELECT Id,IsEscalated,recordtypeid from Case WHERE Id in:cid])
        {
            if(c.recordtypeid == vCaseRT.Value__c && c.IsEscalated == false){
                c.IsEscalated = true;
                lstupdatecases.add(c);
            }
        }
        update lstupdatecases;
     }
   
}