/***********************************************************************************************************************
Name: clsSchedule_Del_DbbbOnMonthChange
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S
========================================================================================================================
Purpose: Schedule the (ClsBatch_Del_DbbbOnMonthChange) batch class                                                  
========================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR                DATE       DETAIL                                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------
1.0    Toshi            12/11/2013     Initial Development                                         
1.1    Harsh			30/01/2015	   Commented date calculation						   Case - 792581
***********************************************************************************************************************/

global class clsSchedule_Del_DbbbOnMonthChange implements Schedulable
{
    global Date today;
  /*_____________________________________________________________________________________________________________________
    | Purpose : Execute                                                                                                   |
    |_____________________________________________________________________________________________________________________|
    | Input Parameter  : Batch class (ClsBatch_Del_DbbbOnMonthChange)Object.                                                                                              |
    |_____________________________________________________________________________________________________________________|
    |  I1. Name        : Schedulable Context                                                                                | 
    |      Data Type   : Database.SchedulableContext                                                                        | 
    |      Description :                                                                                                  |
    |_____________________________________________________________________________________________________________________| 
    | Output Parameter : List of DailyBBB records returned by Query                                                                                              
     ______________________________________________________________________________________________________________________*/    
    global void execute(SchedulableContext sc){
        try{
        	ClsBatch_Del_DbbbOnMonthChange objBatchClass = new ClsBatch_Del_DbbbOnMonthChange();
            database.executebatch(objBatchClass);
        }
        catch(Exception ex){        	
        }
        
        /*
        try{
            today = system.today()-2;
            if(Test.isRunningTest()){
                today = date.newInstance(2010, 5, 29);
            }
            Period p = [SELECT EndDate, StartDate, Type FROM Period where Type='Month' and StartDate=:today limit 1];
            if(P.StartDate== today){
                        ClsBatch_Del_DbbbOnMonthChange objBatchClass = new ClsBatch_Del_DbbbOnMonthChange();
                        database.executebatch(objBatchClass);
            }
        } catch(exception e){}*/
    }    
}