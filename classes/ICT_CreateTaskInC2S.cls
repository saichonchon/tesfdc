global class ICT_CreateTaskInC2S implements Database.Batchable<sObject>{ 
    
    global ICT_CreateTaskInC2S(){ 
        
    } 
    List<Opportunity> oplist = new List<Opportunity>();
    List<Task> tsklist = new List<Task>();
    List<string> opliststr = new List<string>();
    List<integer> tsklistintr = new List<integer>();
    List<string> opliststr1 = new List<string>();
    List<integer> tsklistintr2 = new List<integer>();
    List<string> opliststr3 = new List<string>();
    List<integer> tsklistintr4 = new List<integer>();
    List<string> opliststr5 = new List<string>();
    List<integer> tsklistintr6 = new List<integer>();
    List<string> opliststr7 = new List<string>();
    List<integer> tsklistintr8 = new List<integer>();
    List<string> opliststr9 = new List<string>();
    List<integer> tsklistintr10 = new List<integer>();
    
    
    
    
    global Iterable<SObject> start(Database.BatchableContext BC){ 
        
        return Database.getQueryLocator('select id,TS_TaskId__c, StageName,Amount from Opportunity where TS_TaskId__c!=null'); 
    } 
    
    
    global void execute(Database.BatchableContext BC, List<Opportunity> scope) { 
        List<Task__x> tslist =new List<Task__x>();
        
        tslist = [select OpportunityID_of_C2S_c__c,Opportunity_c__c, Opportunity_Value_c__c,Opportunity_Stage_c__c,Opportunity__c from Task__x where OpportunityID_of_C2S_c__c <> '' and Lastmodifieddate__c=today];
        
        
        for(Opportunity t: scope)
        {
            system.debug('t.id...'+t.Id);
            for(Task__x ts : tslist){
            
                
               // if((String.valueOf(t.Id).substring(0, 15)).equals(ts.OpportunityID_of_C2S_c__c)){
                if(t.Id.equals(ts.OpportunityID_of_C2S_c__c))
                   {
                        if(ts.Opportunity_c__c!=null)
                        {
                        
                       
                       t.Amount = ts.Opportunity_c__c;
                       }
                      
                      if(ts.Opportunity_Stage_c__c !=null)
                      {
                        t.StageName = ts.Opportunity_Stage_c__c; 
                        
                      }
                     oplist.add(t);
                    
                    
                    
                  
                }
            }     
        }
        
        try
        {
            update oplist; 
            
        }
        catch(Exception e) 
        {
            system.debug('An Error has Occured. Error:' +e); 
            
        } 
    }
    
    global void finish(Database.BatchableContext BC){ 
    
       
        
    }  
}