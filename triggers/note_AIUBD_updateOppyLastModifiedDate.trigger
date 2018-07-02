/**
* 
*   This After Insert/Update, Before Delete Trigger updates the custom opportunity "Last Modified Date" field.
*
*   Author              |Author-Email                       |Date        |Comment
*   --------------------|---------------------------------- |------------|-------------------------------------
*   Frederic Faisst     |frederic.faisst@itbconsult.com     |16.03.2012  |Initial Draft
*   Phil Hiemstra       |phil.hiemstra@te.com               |16.12.2014  |Exception handling for opportunity update
*/

trigger note_AIUBD_updateOppyLastModifiedDate on Note (after insert, after update, before delete) {
    set<Id> setOppyID = new set<Id>();
    /*Map<Id, Datetime> map_oppyId_dateTimeNow = new Map<Id, Datetime>();
    List<Opportunity> list_oppies2update = new List<Opportunity>();
    Id castIronUserId = Apex_Helper_Settings__c.getInstance('Service Account Profile Id').Value__c;
    Id actualUserId = Userinfo.getUserId();
    //modified by xia 2013-01-29, add profile check,only triggered in case the actual users profile not equal to "BU Admin" and "System Administrator"
    Id buAdminId = Apex_Helper_Settings__c.getInstance('BU Admin Profile Id').Value__c;
    Id systemAdminId = Apex_Helper_Settings__c.getInstance('System Admin Profile Id').Value__c;
    Id profileId = UserInfo.getProfileId();
    String currentUser = UserInfo.getName();//added by xia 2013-04-03
    */
    if(Last_Modified_Field_Update_Permission__c.getInstance() != null && Last_Modified_Field_Update_Permission__c.getInstance().Allow_Update__c)
    {
        if(Trigger.isDelete)
        {
            for(Note n : Trigger.old)
                if(n.ParentId != null && String.valueOf(n.ParentId).startsWith('006'))
                    setOppyID.add(n.ParentId);
        }
        else{
            for(Note n : Trigger.new)
                if(n.ParentId != null && String.valueOf(n.ParentId).startsWith('006'))
                    setOppyID.add(n.ParentId);
        }
        if(!setOppyID.isEmpty())
        {
            try 
            {
                update [Select Id, Last_Modified_Date__c, Last_Modified_By_Custom__c From Opportunity Where Id in :setOppyID];
            } 
            catch (DMLException e) 
            {
                // 2014-12-16 Phil Hiemstra - Added DML Exception handling, mostly to catch Funnel OCR related validation errors.
                /*Map<Id, String> errorMessages = new Map<Id, String>();
                for (Integer i = 0; i < e.getNumDml(); i++) 
                    errorMessages.put(Id.valueOf(e.getDmlId(i)), e.getDmlMessage(i));
                
                if(Trigger.isDelete)
                {
                    for(Note n : Trigger.old)
                        if (errorMessages.containsKey(n.ParentId))
                            n.addError(errorMessages.get(n.ParentId));
                }
                else
                {
                    for(Note n : Trigger.new)
                        if (errorMessages.containsKey(n.ParentId))
                            n.addError(errorMessages.get(n.ParentId));
                }*/
                notetriggerHelper.NoteTriggerExceptionhandler(e, Trigger.old, Trigger.new, Trigger.isDelete);
            }
        }
    }
}