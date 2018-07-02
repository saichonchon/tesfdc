/**
*   This trigger is used to route the lead
*
@author min liu
@created 2012-11-05
@version 1.0
@since 23.0
*
@changelog
* 2012-11-05 min liu <min.liu@itbconsult.com>
* - Created
* 2014-08-22 Phil Hiemstra <phil.hiemstra@te.com>
* - Added logic to exclude certain lead record types
* 00888305 - 2015-9-4 Updated by Pankaj Raijade
* - Excuding new record type 'Event Lead' from lead routing.
* Channel Lead Routing Phase II https://tecentral.my.salesforce.com/a0R1600000b4l34 - 2016-11-4
* - Modified by Rajendra for Req 2 to assign lead owner
*/
trigger Lead_BI_executeRoute on Lead (before insert, before update) {
        
    if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isBefore){ 
        //if(currentUserName == 'Eloqua Integration User'){
            LeadTriggerHandler.OwnerAssignment(Trigger.New, Trigger.OldMap);
        //}        
    }
}