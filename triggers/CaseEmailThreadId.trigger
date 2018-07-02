/* change Log 
*  3/4/2016 -Sanghita change added to correct " Ending position out of bounds: -1" Error 
*  Case 00900697
*/


trigger CaseEmailThreadId on EmailMessage (before insert) {

List <emailMessage> EMessage= new List<emailMessage>();
String Threadid;
List <String> subjectList=new List<String>();
Map<string, id> cs= new Map<string, id>();
        //Map of email Message that satisfy the criteria
         for (EmailMessage e:trigger.new ) {
              system.debug('****value of trigger.new'+trigger.new); 
              try{// 2016-02-15 - Sanghita change added Case 00900697- start
              if ((e.Subject<>'') &&(e.ToAddress ==label.PIC_Email_Address) && (e.Subject.contains('ref:_')) && e.incoming==true 
                  && e.MessageDate > date.valueOf('2015-09-26')) // added by Sandeep to avoid this process to run when data is migrated
              {
                   system.debug('***inside first if '+e.ToAddress);
                   Threadid=e.subject;
                   string [] split=Threadid.split('ref:');
                   String finalThread='ref:'+string.valueof(split[split.size()-1]);
                   if(finalThread.indexOf( ':ref' )>0)   
                      finalThread= finalThread.substring( 0, finalThread.indexOf( ':ref' ) ) + ':ref';
                   else {
                   if((split.size())>1  && string.valueof(split[split.size()-2]).contains(':ref')) {
                   finalThread='ref:'+string.valueof(split[split.size()-2]);
                   if(finalThread.indexOf( ':ref' )>0)   
                      finalThread= finalThread.substring( 0, finalThread.indexOf( ':ref' ) ) + ':ref';
                   }}   
                   subjectList.add(finalThread);        
              } }
              catch (Exception ex){system.debug('****Exception '+ex);}
         }// 2016-02-15 - Sanghita change added Case 00900697- end
         
        system.debug('****value of subjectList'+subjectList);
        system.debug('****value of subjectListsize'+subjectList.size());
        
        for (case c:[select id,PIC_Central_Thread_ID__c from case where PIC_Central_Thread_ID__c in :subjectList]){
            if(c.PIC_Central_Thread_ID__c != null)
                cs.put(c.PIC_Central_Thread_ID__c, c.id );
          }

        //Reparent to the original case
        for (EmailMessage e:trigger.new ) {
            try{// 2016-02-15 - Sanghita change added Case 00900697- start
            if ((e.Subject<>'') && (e.ToAddress ==label.PIC_Email_Address) && (e.Subject.contains('ref:_')) && e.incoming==true 
                 && e.MessageDate > date.valueOf('2015-09-26'))  // added by Sandeep to avoid this process to run when data is migrated
            { 
                   Threadid=e.subject;
                   string [] split=Threadid.split('ref:');
                   String finalT='ref:'+string.valueof(split[split.size()-1]);
                   if(finalT.indexOf( ':ref' )>0) 
                   finalT= finalT.substring( 0, finalT.indexOf( ':ref' ) ) + ':ref';
                   else{
                   if((split.size())>1  && string.valueof(split[split.size()-2]).contains(':ref')) {
                   finalT='ref:'+string.valueof(split[split.size()-2]);
                   if(finalT.indexOf( ':ref' )>0) 
                   finalT= finalT.substring( 0, finalT.indexOf( ':ref' ) ) + ':ref';
                   }}                   
                   if(cs.containsKey(finalT))
                   {                      
                     e.parentid=cs.get(finalT);
                   }
             } } 
             catch (Exception ex){system.debug('****Exception '+ex);}   
         }// 2016-02-15 - Sanghita change added Case 00900697- end
 
 }