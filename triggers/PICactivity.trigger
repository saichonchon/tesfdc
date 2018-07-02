/***********************************************************************************************************************
 Name: PICactivity 
 Org : C2S
 Copyright : © 2015 TE Connectivity 
========================================================================================================================
 Summary : Apex
 -----------------------------------------------------------------------------------------------------------------------
 VERSION  AUTHOR              DATE           DETAIL                              
 -----------------------------------------------------------------------------------------------------------------------
   1.0   Sanghita Das    09/15/2015     PICactivity 
***********************************************************************************************************************/ 


trigger PICactivity on Case (after insert) {
    try{
        List<Task> tasks = new List<Task>();
        for (case cs:trigger.new){
                if(cs.recordtypeid==label.PIC_Record_Type && cs.status=='New'){
                tasks.add(new task( WhatId=cs.id,Priority=cs.Priority,subject ='PIC-ChatEmailPhone',OwnerId=cs.OwnerId,status='Completed',whoID=cs.ContactId,RecordTypeId=label.PIC_Task ));
                system.debug('tasksinsidePICactivity'+tasks);
         }
        }    
        //Insert tasks if a new case is created 
        insert tasks;  
        system.debug('tasksoutsideafter insertPICactivity'+tasks);
    }catch(Exception e){
        system.debug('Error###### :'+ e);
    }
}