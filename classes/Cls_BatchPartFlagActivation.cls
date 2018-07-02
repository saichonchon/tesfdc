/***********************************************************************************************************************
      Name : Cls_BatchPartFlagActivation
       Org : C2S
 Copyright : © 2013 TE Connectivity 
========================================================================================================================
   Summary : A generic batch class which updates the Part__c if it is referenced in any of the related objects. A 
             checkbox on Part__c is checked if it's having a reference.
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR       DATE       DETAIL               User Story #                  
________________________________________________________________________________________________________________________
     1.0 Shantinath   06/18/2013 Initial Development  1177                      
***********************************************************************************************************************/
global class Cls_BatchPartFlagActivation implements Database.Batchable<sObject>, Database.Stateful{
    /* _______________________________________ GLOBAL VARIABLE DECLARATION ___________________________________________*/    
    global final String vObj_API_Name;
    global final String vObj_Field_API_Name;
    global String vQuery;
    global String vErrorsDetails;
    
    global final Integer vCurrent_Exe_Number;
    global final Integer vTotal_Exe_Number;
    
    global Part_Activation_Configuration__c vPartActiveObj;
    
    global Cls_BatchPartFlagActivation(){
        vPartActiveObj = [SELECT Id, 
                                 Current_Object_Number__c,
                                 Max_Number_of_Objects__c,
                                 Object_API_Name__c,
                                 Object_Field_API_Name__c,
                                 Cron_Statement__c
                            FROM Part_Activation_Configuration__c
                           LIMIT 1];
        if(vPartActiveObj != NULL) {
            this.vObj_API_Name       = vPartActiveObj.Object_API_Name__c;
            this.vObj_Field_API_Name = vPartActiveObj.Object_Field_API_Name__c;
            this.vCurrent_Exe_Number = (Integer)vPartActiveObj.Current_Object_Number__c;
            this.vTotal_Exe_Number   = (Integer)vPartActiveObj.Max_Number_of_Objects__c;
            Parts_Activation_Settings__c vConfig = Parts_Activation_Settings__c.getValues(String.ValueOf(vCurrent_Exe_Number));
            vQuery = 'SELECT Id, '+
                            +vObj_Field_API_Name+
                     +' FROM '+vObj_API_Name+
                    +' WHERE '+vObj_Field_API_Name+' <> NULL '+
                    +' AND '+vConfig.Conditional_Query__c;
            if(Test.isRunningTest()) 
                vQuery += ' LIMIT 1'; 
            vErrorsDetails  = '';
        }
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        if(vQuery != null){
            return Database.getQueryLocator(vQuery);
        }
        return null;
    }

    global void execute(Database.BatchableContext BC, List<sObject> vsObjectList){
        if(!vsObjectList.isEmpty()){
            Set<Id> vSetId = new Set<Id>();
            
            for(sObject s : vsObjectList){
                vSetId.add((Id)s.get(vObj_Field_API_Name)); 
            }
            
            if(!vSetId.isEmpty()){
                List<Part__c> vPartList = new List<Part__c>();
                for(Part__c vTemp : [SELECT Id, 
                                            IsActive__c, 
                                            Date_of_Activation__c 
                                       FROM Part__c WHERE Id in: vSetId
                                        AND (Date_of_Activation__c <> TODAY
                                         OR Date_of_Activation__c = NULL)]){
                    vTemp.IsActive__c = True;
                    vTemp.Date_of_Activation__c = Date.Today();
                    vPartList.add(vTemp);
                }  
                if(!vPartList.isEmpty()){
                    try {
                        update vPartList;
                    }catch(Exception e) {
                        vErrorsDetails += 'Exception in Generic Batch class Execute Method -->'+e+' \n ';
                    }
                }
            }        
        } 
    }

    global void finish(Database.BatchableContext BC) {
        if(vPartActiveObj!=null){
            Id vConfigId = vPartActiveObj.Id;
            if(vCurrent_Exe_Number == vTotal_Exe_Number){
                //LOAD THE CUSTOM OBJECT WITH FIRST RECORD IN CUSTOM SETTING
                Parts_Activation_Settings__c vConfig    = Parts_Activation_Settings__c.getValues('1');
                //SET IT FOR RUN IN NEXT WEEKEND
                date myDate = date.today();
                date weekStart = myDate.toStartofWeek()+7;
                String sch = '0 0 0 '+weekStart.Day()+' '+weekStart.Month()+' ? '+weekStart.Year();
                //THE CRON STATEMENT FORMED HERE IS IN FORMAT SEC/MIN/HH/DAY_OF_MONTH/MONTH/DAY_OF_WEEK/YEAR
                //0 0 0 XX XX ? XXXX
                vPartActiveObj.Current_Object_Number__c  = Decimal.ValueOf('1');
                vPartActiveObj.Object_API_Name__c        = vConfig.Object_API_Name__c;
                vPartActiveObj.Object_Field_API_Name__c  = vConfig.Object_Field_API_Name__c;
                vPartActiveObj.Conditional_Query__c      = vConfig.Conditional_Query__c;
                vPartActiveObj.Cron_Statement__c         = sch;
                vPartActiveObj.Next_Schedule_Run_Date__c = weekStart;//THIS WILL MAKE SURE THAT THERE WILL BE 
                                                                     //ONLY ONE SCHEDULE PER WEEK
                try {
                    update vPartActiveObj;
                }catch(Exception e) {
                    vErrorsDetails += 'Exception in Updating PartConfig For Next Week '+e+' \n ';
                }
            } else {
                //LOAD THE CUSTOM OBJECT WITH NEXT RECORD IN CUSTOM SETTING
                Parts_Activation_Settings__c vConfig    = Parts_Activation_Settings__c.getValues(String.ValueOf(vCurrent_Exe_Number+1));
                vPartActiveObj.Current_Object_Number__c = Decimal.ValueOf(vConfig.Name);
                vPartActiveObj.Object_API_Name__c       = vConfig.Object_API_Name__c;
                vPartActiveObj.Conditional_Query__c     = vConfig.Conditional_Query__c;
                vPartActiveObj.Object_Field_API_Name__c = vConfig.Object_Field_API_Name__c;
                try{
                    update vPartActiveObj;
                }catch(Exception e){
                    vErrorsDetails += 'Exception in Updating PartConfig In Chain '+e+' \n ';
                }
            }
            if(vErrorsDetails != '') Cls_PartActivationExceptions.UpdateNoteWithStatus(vErrorsDetails, vObj_API_Name, vConfigId);
        }
    }
}