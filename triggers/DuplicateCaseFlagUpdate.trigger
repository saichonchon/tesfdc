trigger DuplicateCaseFlagUpdate on Case (before insert) {
    List <String> subjectList=new List<String>();
    Map<string, id> cMap= new Map<string, id>();
        //List of case subject satisfying the criteria 
        for (case c :trigger.new ){   
            if ( c.SuppliedEmail<>null && c.SuppliedEmail<>'' && c.Status=='New' && c.Origin=='Email' && c.Subject<>null && c.Subject.contains('ref:_') && c.Count_Outgoing_Emails__c==0  )
                {
                     String Sub=c.subject;         
                     String [] cd=sub.split('ref:');
                     String finalThread='ref:'+string.valueof(cd[cd.size()-1]);         
                     subjectList.add(finalThread);              
                }
        }
        
        for (case c:[select id,PIC_Central_Thread_ID__c from case where PIC_Central_Thread_ID__c in :subjectList]){
         if(c.PIC_Central_Thread_ID__c != null)
           cMap.put(c.PIC_Central_Thread_ID__c , c.id );  }
           
               system.debug('outsideaftercasequery'+cMap);
      // Update isCentralOldCase__c if it is a existing case
        for (case c :trigger.new ){
        if ( c.SuppliedEmail<>null && c.SuppliedEmail<>'' && c.Status=='New' && c.Origin=='Email' && c.Subject<>null && c.Subject.contains('ref:_') && c.Count_Outgoing_Emails__c==0  )
        {
             system.debug('insideDuplicatesecondif'+trigger.new);
             String Sub=c.subject;         
             String [] cd=sub.split('ref:');
             String finalString='ref:'+string.valueof(cd[cd.size()-1]);
             if (cMap.containskey(finalString))
             {
                system.debug('insideDuplicatethirdif'+finalString);
                c.isCentralOldCase__c=true;  
             }
         }
      }
    
}