/**
*   This trigger is used to get the oppy program close date
*
@author min liu
@created 2012-09-11
@version 1.0
@since 24.0
*
@changelog
* 2012-09-11 min liu <min.liu@itbconsult.com>
* - Created
*/
trigger opportunityPart_AIUDUD_getOppyProgramCloseDate on Opportunity_Part__c (after delete, after insert, after undelete, 
after update) {
    Map<Id, List<Date>> map_oppyId_oppyPartInitDates = new Map<Id, List<Date>>();
    Map<Id, List<Date>> map_programId_oppyPartInitDates = new Map<Id, List<Date>>();
    List<Opportunity> list_oppyProgram2Update = new List<Opportunity>();
    Set<Id> set_oppyIds = new Set<Id>();
    
    // get the opportunity ids for update
    if(trigger.isInsert || trigger.isUnDelete){
        for(Opportunity_Part__c part :trigger.new){          
             set_oppyIds.add(part.Opportunity__c);  
        }
    }
    else if(trigger.isUpdate){
        for(Opportunity_Part__c part :trigger.new){          
             if(part.Initial_Order_Date__c != trigger.oldMap.get(part.id).Initial_Order_Date__c){
                set_oppyIds.add(part.Opportunity__c);
             }          
        }
    }
    else if(trigger.isDelete){
        for(Opportunity_Part__c part :trigger.old){
            set_oppyIds.add(part.Opportunity__c);   
        }
    }
    
    // get initial dates of opportunity parts
    if(set_oppyIds.size() > 0){
        for(Opportunity_Part__c part :[select id, Opportunity__c, Initial_Order_Date__c, Opportunity__r.Program__c from Opportunity_Part__c where Opportunity__c IN :set_oppyIds]){
            if(part.Initial_Order_Date__c != null){                                 
                if(!map_oppyId_oppyPartInitDates.containsKey(part.Opportunity__c)){
                    map_oppyId_oppyPartInitDates.put(part.Opportunity__c, new List<Date>());
                }
                map_oppyId_oppyPartInitDates.get(part.Opportunity__c).add(part.Initial_Order_Date__c);                      
            }
        }
    
        // put the min initial order date into opportunities
        for(Opportunity oppy :[select id, closeDate,Manufacturing_Start_Date__c, Program__c from Opportunity where id IN :map_oppyId_oppyPartInitDates.keySet()]){
            if(!map_oppyId_oppyPartInitDates.get(oppy.id).isEmpty()){
                map_oppyId_oppyPartInitDates.get(oppy.id).sort();
                oppy.Manufacturing_Start_Date__c = map_oppyId_oppyPartInitDates.get(oppy.id).get(0);
                list_oppyProgram2Update.add(oppy);
            }
            if(oppy.Program__c != null){
                if(!map_programId_oppyPartInitDates.containsKey(oppy.Program__c)){
                    map_programId_oppyPartInitDates.put(oppy.Program__c, new List<Date>());
                }
            }                               
        }
        if(!list_oppyProgram2Update.isEmpty()) update list_oppyProgram2Update;
        
        list_oppyProgram2Update.clear();
        // put the min initial order date into programs
        for(Opportunity oppy :[select id, closeDate,Manufacturing_Start_Date__c, Program__c from Opportunity where Program__c != null and Program__c IN :map_programId_oppyPartInitDates.keySet()]){
            if(oppy.Manufacturing_Start_Date__c != null) map_programId_oppyPartInitDates.get(oppy.Program__c).add(oppy.Manufacturing_Start_Date__c);        
        }
        for(Opportunity oppy :[select id, closeDate,Manufacturing_Start_Date__c from Opportunity where id IN :map_programId_oppyPartInitDates.keySet()]){
            if(!map_programId_oppyPartInitDates.get(oppy.id).isEmpty()){
                map_programId_oppyPartInitDates.get(oppy.id).sort();
                oppy.Manufacturing_Start_Date__c = map_programId_oppyPartInitDates.get(oppy.id).get(0);
                list_oppyProgram2Update.add(oppy);
            }
        }
        if(!list_oppyProgram2Update.isEmpty()) update list_oppyProgram2Update;
    }   
}