/**
 *  This After Insert/Update, Before Delete Trigger updates the custom opportunity "Last Modified Date" field.
 * 
 * @author Weihang Li
 * @created 2013-01-30
 * @version 1.0
 * @since 23.0
 * 
 * return
 *
 * @changelog
 * 2013-01-30 Weihang Li <Weihang.Li@itbconsult.com>
 * - Created   
 *
 */
trigger Attachment_AIUBD_updateOppyLastModifiedDate on Attachment (after insert, after update, before delete) {
    /*Case - 00900368: Updated by Pankaj Raijade 2015-12-10 update field last modified by custom ---start*/
    set<id> setOppyID = new set<id>();
    
    //Map<Id, Datetime> map_oppyId_dateTimeNow = new Map<Id, Datetime>();
    //List<Opportunity> list_oppies2update = new List<Opportunity>();
    //Id castIronUserId = Apex_Helper_Settings__c.getInstance('Service Account Profile Id').Value__c;
    //Id buAdminId = Apex_Helper_Settings__c.getInstance('BU Admin Profile Id').Value__c;
    //Id systemAdminId = Apex_Helper_Settings__c.getInstance('System Admin Profile Id').Value__c;
    //Id actualUserId = Userinfo.getUserId();
    //Id profileId = UserInfo.getProfileId();
    //String currentUser = UserInfo.getName();//added by xia 2013-04-03
    if(Last_Modified_Field_Update_Permission__c.getInstance() != null && Last_Modified_Field_Update_Permission__c.getInstance().Allow_Update__c)
    {
        if(Trigger.isDelete)
        {
            for(Attachment e : Trigger.old)
                if(e.ParentId != null && String.valueOf(e.ParentId).startsWith('006'))
                    setOppyID.add(e.ParentId);
        }
        else
        {
            for(Attachment e : Trigger.new)
                if(e.ParentId != null && String.valueOf(e.ParentId).startsWith('006'))
                    setOppyID.add(e.ParentId);
        }
        if(setOppyID.size() > 0)
            update [Select Id,Last_Modified_Date__c,Last_Modified_By_Custom__c From Opportunity Where Id in :setOppyID];
    }
    
    /*if(profileId != systemAdminId && profileId != buAdminId){
        if(castIronUserId != actualUserId){
            if(Trigger.isDelete){
                for(Attachment e : Trigger.old){
                    if(e.ParentId != null && String.valueOf(e.ParentId).startsWith('006')){
                        map_oppyId_dateTimeNow.put(e.ParentId, Datetime.now());
                    }
                }
            }
            else{
                for(Attachment e : Trigger.new){
                    if(e.ParentId != null && String.valueOf(e.ParentId).startsWith('006')){
                        map_oppyId_dateTimeNow.put(e.ParentId, Datetime.now());
                    }
                }   
            }
            
            for(Opportunity oppy : [Select Id,Last_Modified_Date__c,Last_Modified_By_Custom__c From Opportunity Where Id in :map_oppyId_dateTimeNow.keySet()]){
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