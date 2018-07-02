/*
Copyright © 2016 TE Connectivity | Salesforce Instance : C2S Org

Name                : UpdateCaseOwner
Related Test Class  :
Created Date        : 06 12 2017
Created by          : Subramanian Jairam
Description         : This is used to update Case Owner based on live chat Transcript.

***********************************************************************************************************
Audit               
***********************************************************************************************************
Last Modified by    :
Last Modified Date  :
TeampUpCase$        :
JiraCase#           :
***********************************************************************************************************
*/
trigger UpdateCaseOwner on LiveChatTranscriptEvent (after insert) {
    
    
    id transcriptid;
    for(LiveChatTranscriptEvent l: trigger.new){
        if(l.Type == 'LeaveVisitor')
        transcriptid = l.LiveChatTranscriptId;
    }
    
   if(transcriptid != NULL){
        Id caseId;
        set<Id> userids = new set<Id>();
        id chatOwner;
        Boolean isConference = FALSE;
        List<LiveChatTranscriptEvent> LCTE = [select id, AgentId, Type, LiveChatTranscript.caseid from LiveChatTranscriptEvent where LiveChatTranscriptId=:transcriptid];
   
        for(LiveChatTranscriptEvent l: LCTE){
            caseId = l.LiveChatTranscript.caseid;
            if(l.AgentId != NULL){
                userids.add(l.AgentId);
            }
            if(l.Type == 'OperatorLeftConference'){
                userids.remove(l.AgentId);
            }   
            if(l.Type.contains('Conference')){
                isConference = TRUE;

            }          
           
        }
        for(id i: userids){      
            if(isConference){         
                chatOwner = i;
                break;                
            }
        }        
    try{
        if(transcriptid != NULL && caseId != NULL && chatOwner != NULL){
            case cs = new case();
            cs.id = caseId;
            cs.ownerid = chatOwner;
            upsert cs Id; 
            
            LiveChatTranscript lct = new LiveChatTranscript();
            lct.id = transcriptid;
            lct.ownerid = chatOwner;
            upsert lct Id;
        }       
        }catch(exception e){
            system.debug('Exception ###' + e);
            
            String vStrError = '';
            vStrError += 'Error Type = ' + e.getTypeName() + 
                ' Error Line = ' + e.getLineNumber() + '' + 
                ' Error Stack = ' + e.getStackTraceString() + 
                ' Error Message = ' + e.getMessage();
            
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,                   
                                         SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '',e.getStackTraceString()); 
        }
    }
}