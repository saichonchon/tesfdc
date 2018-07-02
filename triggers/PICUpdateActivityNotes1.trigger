trigger PICUpdateActivityNotes1 on Case (before update,before insert) {
         List<ID> CaseIds = New List<ID>();
         List <ID> Anote =new List<ID>(); 
         Public string origin;
         Public string Description;
         Public string Lead_Notes;
         Public string Subject;
                     
             for(case c : Trigger.new){ 
                if(c.Hot_Lead__c  == true && c.recordtypeid ==label.PIC_Record_Type){  
                        CaseIds.add(c.id);                                         
                }
             }
         // get the latest live chat transcript value for the case 
        MAp<id,LiveChatTranscript> lstLVchat=new map<id,LiveChatTranscript>();  
        if(CaseIds.size()>0){   
            for(LiveChatTranscript l:[select id,CaseId,body from LiveChatTranscript  where CaseId in :CaseIds order by LastModifiedDate DESC ]){
                if (!lstLVchat.containskey(l.caseid))
                lstLVchat.put(l.caseid,l);  
            }
        }
        
        system.debug('@@lstLVchat'+lstLVchat);
        
        for(case c : Trigger.new){
        string  LVbody='';
        LiveChatTranscript l= new LiveChatTranscript();
        system.debug('outsidebodygetvalue'+c.id);
            if ((lstLVchat.containskey(c.id))){            
                  l=lstLVchat.get(c.id);    
                  system.debug('insidebodygetvalue'+l);
                  if(l.body <>null && l.body <>'' && l.body !='')LVbody=l.body.replaceAll('<[^>]+>','\n ');
                  else LVbody='';         
                  system.debug('insidebody'+LVbody);
            }
            
            system.debug('body'+LVbody);
            
            if(c.Hot_Lead__c  == true && c.recordtypeid ==label.PIC_Record_Type)
            {
                if (c.Origin==null) origin='';else origin='Case Origin:'+c.Origin+'\n';
                if (c.Description==null) Description='';else Description= 'Case Description :'+c.Description+'\n'+'\n';
                if (c.Lead_Notes__c==null) Lead_Notes='';else Lead_Notes='Lead Notes :'+c.Lead_Notes__c +'\n';
                if (c.Subject==null) Subject='';else Subject='Case Subject:'+c.Subject+'\n'+'\n';
                //Update activity note field of case id criteria match    
                c.Activity_Notes__c =origin+subject+Description+Lead_Notes+LVbody;
           }   
    }
}