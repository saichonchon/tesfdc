/**********************************************************************************************************************************************
*******
Name: Task_AU_TaskCompleteEmail_CCP
Copyright © 2014 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This trigger send Emails to case owner, when the task has been completed with status 'Completed' for the case.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE          DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Ramakrishna Singara   04/25/2014    Trigger                       
***********************************************************************************************************************************************
*****/
trigger Task_AU_TaskCompleteEmail_CCP on Task (After Update) {

    Set<Id> ownerIdSet = new Set<Id>();
    map<Id,case> caseIdRecMap;
    Map<Id, User> userIdRecMap;
    Map<Id, Task> caseIdTaskRecMap = new Map<Id, Task>();
    list<Messaging.SingleEmailMessage> mailList = new list<Messaging.SingleEmailMessage>();
    Apex_Helper_Settings__c vTaskRT = Apex_Helper_Settings__c.getInstance('Customer Care Task');    
    String orgUrl = System.URL.getSalesforceBaseUrl().getHost();    
    for(task t:trigger.new)
    {
        if(t.WhatId != null && String.valueOf(t.WhatId).startsWith('500') && t.recordtypeId==vTaskRT.Value__c && t.Status == 'Completed')
        {
           caseIdTaskRecMap.put(t.WhatId, t);
           ownerIdSet.add(t.ownerId); 
        }
    }
    if(caseIdTaskRecMap.keySet()!=null && caseIdTaskRecMap.keySet().size()>0){
        caseIdRecMap = new map<Id,case>([select id,CaseNumber,status,Subject,OwnerId,Owner.Name,IsEscalated,isClosed from case where id in:caseIdTaskRecMap.keySet()]); 
    }
    if(ownerIdSet!=null && ownerIdSet.size()>0){
        userIdRecMap = new Map<Id, User>([select Name, Email from User where Id in :ownerIdSet]);
    }
    
    for(Task tsk : caseIdTaskRecMap.values()){  
        if(userIdRecMap.containsKey(tsk.ownerId)){                         
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            case cs = caseIdRecMap.get(tsk.WhatId);             
            mail.setSubject('case number: '+ cs.CaseNumber  +  '  Case subject: '+ cs.Subject);
            mail.setTargetObjectId(cs.ownerId);                               
            mail.setSaveAsActivity(false);                             
            mail.setHtmlBody('Dear  ' + cs.Owner.Name +','+ '<br/><br/>The task you assigned to '+ userIdRecMap.get(tsk.ownerId).Name + ' on case' + ' #' + cs.CaseNumber + ' is completed.' + '<br/> To view your case <a href=https://'+orgUrl+'/'+tsk.Id+'>click here.</a>');
            mailList.add(mail);                
        }   
    }
    try{
        if(mailList!=null && mailList.size()>0)
            Messaging.SendEmail(mailList);
    }
    catch(exception e){
        CCP_Exception_Util.CCP_Exception_Mail(e);
    }
}