/**************************************************************************************************************************
Name: Trigger_AU 
Copyright © 2013 TE Connectivity
===========================================================================================================================
Purpose: This trigger Schedules the Batch Class to Activate Flag on Parts                                                 
===========================================================================================================================                                                     
---------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR        DATE       DETAIL                User Story #
---------------------------------------------------------------------------------------------------------------------------
    1.0 Shantinath    06/18/2013 Initial Development   1177  
**************************************************************************************************************************/
trigger Trigger_BIAU on Part_Activation_Configuration__c (before insert, after update) {
    if(Trigger.isBefore && Trigger.isInsert){
        Integer i = [SELECT COUNT() FROM Part_Activation_Configuration__c LIMIT 2];
        if(i>=1){
            for(Part_Activation_Configuration__c vTemp : Trigger.new){ vTemp.addError('You can have only one record at any given time! Please do not insert it manually!!');    
            }
        }
    }
    if(Trigger.isAfter && Trigger.isUpdate){
        //MAKE SURE THAT THERE IS ONLY ONE RECORD IN THIS CUSTOM OBJECT
        Integer i = [SELECT COUNT() FROM Part_Activation_Configuration__c LIMIT 2];
        if(i==1){
            if(Cls_RefreshPartConfig.vConfigRefresh){
                if((Trigger.new[0].Execute_Trigger_Upon_Update__c) || (Trigger.old[0].Current_Object_Number__c != Trigger.new[0].Current_Object_Number__c)){
                    Part_Activation_Configuration__c vTempConfig = Trigger.new[0];
                    String vCron = vTempConfig.Cron_Statement__c;
                    Integer vExeNum = (Integer)vTempConfig.Current_Object_Number__c;
                    Integer vMaxNum = (Integer)vTempConfig.Max_Number_of_Objects__c;
                    if(((Integer)Trigger.old[0].Current_Object_Number__c == vMaxNum) && vExeNum == 1){ 
                        //THIS WILL CHECK IF THE NEXT SCHEDULE IS ALREADY DONE OR NOT
                        if(Trigger.new[0].Next_Schedule_Run_Date__c != Trigger.old[0].Next_Schedule_Run_Date__c){
                            if(Trigger.new[0].Cascade_Schedule__c){
                                Cls_SchedularPartFlagActivation m = new Cls_SchedularPartFlagActivation();
                                String sch = vCron;
                                system.schedule('Part Activation Job for Next Week '+System.NOW(), sch, m);
                                if(vTempConfig.Schedule_Deactivation_Batch__c){
                                    Cls_BatchPartFlagDeactivation vBatchParts = new Cls_BatchPartFlagDeactivation();
                                    Id batchInstanceId = Database.executeBatch(vBatchParts, 2000);
                                }
                            }
                        }
                    }else{
                        if(Trigger.new[0].Cascade_Schedule__c){
                            Cls_BatchPartFlagActivation vBatch = new Cls_BatchPartFlagActivation();
                            Id batchInstanceId = Database.executeBatch(vBatch, 2000); 
                        }   
                    }
                }
            }
        }else{
            for(Part_Activation_Configuration__c vTempConfig : Trigger.new){ vTempConfig.addError('You can have only one record at any given time! Please do not insert it manually!!');    
            }
        }
    }
}