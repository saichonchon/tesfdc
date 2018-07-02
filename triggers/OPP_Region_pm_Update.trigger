/***********************************************************************************************************************
      Name : Cls_Update_opp_Regional_PM_test
       Org : C2S
 Copyright : © 2013 TE Connectivity 
========================================================================================================================
   Summary : Trigger using for Updating Opportunity 'Regional_PM' value.
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR       DATE        DETAIL               User Story #                  
________________________________________________________________________________________________________________________
     1.0 Ravi    11/11/2013  Initial Development         R-1316
***********************************************************************************************************************/

trigger OPP_Region_pm_Update on Opportunity_Part__c (after insert,after update,after delete) {

    list<Opportunity_Part__c> PartList= new List <Opportunity_Part__c >();
    list<Opportunity_Part__c> PartList_del = new list<Opportunity_Part__c>();
    
    if(!ClsPMV_Util.isRunningMigration){//added by Jinbo Shan for that does not function when migration oppy is running
        If(trigger.isinsert || trigger.isupdate)
        {
            PartList=trigger.new;
            Cls_Update_opp_Regional_PM.Update_Regional_pm(PartList);
        }
        
        Else if(Trigger.isdelete)
        {
            PartList_del=trigger.old;
            Cls_Update_opp_Regional_PM.Update_Regional_pm_del(PartList_del);
        }
    }

}