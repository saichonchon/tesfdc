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
trigger SensitiveAttachments_AIUBD_updateOppyLastModifiedDate on Sensitive_Attachment__c (after insert, after update, before delete) 
{
    /*Case - 00900368: Updated by Pankaj Raijade 2015-12-10 update field last modified by custom ---start*/
    set<id> setOppyID = new set<id>();
    if(Last_Modified_Field_Update_Permission__c.getInstance() != null && Last_Modified_Field_Update_Permission__c.getInstance().Allow_Update__c)
    {
            if(Trigger.isDelete)
            {
                for(Sensitive_Attachment__c e : Trigger.old)
                        setOppyID.add(e.Opportunity__c);
            }
            else
            {
                for(Sensitive_Attachment__c e : Trigger.new)
                        setOppyID.add(e.Opportunity__c);
            }
            if(!setOppyID.isEmpty())
                update [Select Id, Last_Modified_Date__c,Last_Modified_By_Custom__c From Opportunity Where Id in :setOppyID];
    }   
    /*Map<Id, Datetime> map_oppyId_dateTimeNow = new Map<Id, Datetime>();
    List<Opportunity> list_oppies2update = new List<Opportunity>();
    Id castIronUserId = Apex_Helper_Settings__c.getInstance('Service Account Profile Id').Value__c;
    Id buAdminId = Apex_Helper_Settings__c.getInstance('BU Admin Profile Id').Value__c;
    Id systemAdminId = Apex_Helper_Settings__c.getInstance('System Admin Profile Id').Value__c;
    Id actualUserId = Userinfo.getUserId();
    Id profileId = UserInfo.getProfileId();
    String currentUser = UserInfo.getName();//added by xia 2013-04-03
    
    if(profileId != systemAdminId && profileId != buAdminId){
        if(castIronUserId != actualUserId){
            if(Trigger.isDelete){
                for(Sensitive_Attachment__c e : Trigger.old){
                    if(e.Opportunity__c != null && String.valueOf(e.Opportunity__c).startsWith('006')){
                        map_oppyId_dateTimeNow.put(e.Opportunity__c, Datetime.now());
                    }
                }
            }
            else{
                for(Sensitive_Attachment__c e : Trigger.new){
                    if(e.Opportunity__c != null && String.valueOf(e.Opportunity__c).startsWith('006')){
                        map_oppyId_dateTimeNow.put(e.Opportunity__c, Datetime.now());
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
    }*/
    /*Case - 00900368: Updated by Pankaj Raijade 2015-12-10 update field last modified by custom ---End*/
}