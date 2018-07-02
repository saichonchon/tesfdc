/***********************************************************************************************************************
      Name : Cls_BatchPartFlagDeactivation
       Org : C2S
 Copyright : © 2013 TE Connectivity 
========================================================================================================================
   Summary : Deactivate the flag on Part if it is no longer Active.
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR       DATE       DETAIL               User Story #                  
________________________________________________________________________________________________________________________
     1.0 Shantinath   06/19/2013 Initial Development  1177                      
***********************************************************************************************************************/
global class Cls_BatchPartFlagDeactivation implements Database.Batchable<sObject>, Database.Stateful {
    global string vErrorString;
    global Database.QueryLocator start(Database.BatchableContext BC){
        String vQuery = 'SELECT Id, '+
                              +'IsActive__c, '+ 
                              +'Date_of_Activation__c '+ 
                         +'FROM Part__c '+
                         +'WHERE Date_of_Activation__c < LAST_N_DAYS:5 '+
                           +'AND IsActive__c = TRUE';
        if(Test.isRunningTest()) vQuery += ' LIMIT 4';
        vErrorString = '';
        return Database.getQueryLocator(vQuery);
    }
    global void execute(Database.BatchableContext BC, List<Part__c> vPartList){
        if(!vPartList.isEmpty()){
            List<Part__c> vPartListToUpdate = new List<Part__c>();
            for(Part__c vTempPart : vPartList){               
                vTempPart.IsActive__c = FALSE;
                vPartListToUpdate.add(vTempPart);
            }
            if(!vPartListToUpdate.isEmpty()){
                try{
                    update vPartListToUpdate;
                }catch(Exception e){ vErrorString += 'Exception in Part Deactivation --> '+e;              
                }
            }
        }
    }
    global void finish(Database.BatchableContext BC){
        Part_Activation_Configuration__c vPartActiveObj = [SELECT Id
                                                             FROM Part_Activation_Configuration__c
                                                            LIMIT 1];
        if(vErrorString!= '' && vPartActiveObj != null) Cls_PartActivationExceptions.UpdateNoteWithStatus(vErrorString, 'Part__c', vPartActiveObj.Id);
    }
}