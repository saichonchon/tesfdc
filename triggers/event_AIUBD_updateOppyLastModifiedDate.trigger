/**
* 
*   This After Insert/Update, Before Delete Trigger updates the custom opportunity "Last Modified Date" field.
*
*   Author              |Author-Email                       |Date        |Comment
*   --------------------|---------------------------------- |------------|-------------------------------------
*   Frederic Faisst     |frederic.faisst@itbconsult.com     |09.03.2012  |Initial Draft
*
*/

trigger event_AIUBD_updateOppyLastModifiedDate on Event (after insert, after update, before delete) 
{
/*Case - 00900368: Updated by Pankaj Raijade 2015-12-10 update field last modified by custom ---start*/
    set<id> setOppyID = new set<id>();
    if(Last_Modified_Field_Update_Permission__c.getInstance() != null && Last_Modified_Field_Update_Permission__c.getInstance().Allow_Update__c)
    {
            if(Trigger.isDelete)
            {
                for(Event e : Trigger.old)
                    if(e.WhatId != null && String.valueOf(e.WhatId).startsWith('006'))
                        setOppyID.add(e.WhatId);
            }
            else
            {
                for(Event e : Trigger.new)
                    if(e.WhatId != null && String.valueOf(e.WhatId).startsWith('006'))
                        setOppyID.add(e.WhatId);
            }
            
            if(!setOppyID.isEmpty())
                update [Select Id, Last_Modified_Date__c,Last_Modified_By_Custom__c From Opportunity Where Id in :setOppyID];
    }
    /*
    Map<Id, Datetime> map_oppyId_dateTimeNow = new Map<Id, Datetime>();
    List<Opportunity> list_oppies2update = new List<Opportunity>();
    Id castIronUserId = Apex_Helper_Settings__c.getInstance('Service Account Profile Id').Value__c;
    Id actualUserId = Userinfo.getUserId();
    
    //modified by xia 2013-01-29, add profile check,only triggered in case the actual users profile not equal to "BU Admin" and "System Administrator"
    Id buAdminId = Apex_Helper_Settings__c.getInstance('BU Admin Profile Id').Value__c;
    Id systemAdminId = Apex_Helper_Settings__c.getInstance('System Admin Profile Id').Value__c;
    Id profileId = UserInfo.getProfileId();
    
    String currentUser = UserInfo.getName();//added by xia 2013-04-03
    
    if(profileId != systemAdminId && profileId != buAdminId){
        if(castIronUserId != actualUserId){
            if(Trigger.isDelete){
                for(Event e : Trigger.old){
                    if(e.WhatId != null && String.valueOf(e.WhatId).startsWith('006')){
                        map_oppyId_dateTimeNow.put(e.WhatId, Datetime.now());
                    }
                }
            }
            else{
                for(Event e : Trigger.new){
                    if(e.WhatId != null && String.valueOf(e.WhatId).startsWith('006')){
                        map_oppyId_dateTimeNow.put(e.WhatId, Datetime.now());
                    }
                }   
            }
            
            for(Opportunity oppy : [Select Id, Last_Modified_Date__c,Last_Modified_By_Custom__c From Opportunity Where Id in :map_oppyId_dateTimeNow.keySet()]){
                oppy.Last_Modified_Date__c = map_oppyId_dateTimeNow.get(oppy.Id);
                oppy.Last_Modified_By_Custom__c = currentUser +'  ' + oppy.Last_Modified_Date__c.format();//added by xia 2013-04-03
                list_oppies2update.add(oppy);
            }
            
            if(!list_oppies2update.isEmpty()){
                update list_oppies2update;
            }
        }
    }
    */
    /*Case - 00900368: Updated by Pankaj Raijade 2015-12-10 update field last modified by custom ---End*/
}