/**
*   This class contains all utility methods for trigger OpportunitySpanningRelationship
*   Case 00900679.
*
@  author Rajendra Shahane
@  created 2016-01-28
*
*/
public class OpportunitytriggerUtils
{
    public static void SetOppSpaningRealationFields(list<Opportunity> lstOppNew,list<Opportunity> lstOppOld,Map<Id,Opportunity> mapOppOld, Map<Id,Opportunity> mapOppNew,boolean IsUpdateTrigger)
    {
        Map<Id,User> mapUser = new Map<Id,User>();
        set<Id> setUserId = new set<Id>();
         Id EngCSDRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Engineering Opportunity-CSD').getRecordTypeId();
        Id NDROppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('NDR Opportunity').getRecordTypeId();
      list<Opportunity> lstOppNewOne= new list<Opportunity>(); //Archana: added to storespecific opportunities ment for transaction purpose
        
        for(Opportunity Oppty: lstOppNew)
        {
       
            if(Oppty.CCAO_Manager__c != null && !setUserId.contains(Oppty.CCAO_Manager__c)){
                setUserId.add(Oppty.CCAO_Manager__c);
                lstOppNewOne.add(oppty);
                }
            if(Oppty.CreatedBy_ProfileId__c == null || Oppty.CreatedBy_ProfileId__c == '')
              {  setUserId.add(Oppty.CreatedById);
                lstOppNewOne.add(oppty);
                }
            if(Oppty.Global_Product_Manager__c!= null && !setUserId.contains(Oppty.Global_Product_Manager__c))
               { setUserId.add(Oppty.Global_Product_Manager__c);
                 lstOppNewOne.add(oppty);
                 
                 }
            if(Oppty.OwnerId != null && !setUserId.contains(Oppty.OwnerId))
              {  setUserId.add(Oppty.OwnerId);
                lstOppNewOne.add(oppty);
                }
                
        }
        //JNV 1/28/2016 - added since createdbyid is null before insert
        setUserId.remove(null);
        
        If(setUserId.size() > 0)
        {
            mapUser = new Map<Id,User>([select Id,Alias,GIBU__c,profileid,FirstName,LastName,Email,ManagerId,Manager.Email from user where Id in:setUserId]);
        //} JNV 1/28/2016 - none of the code below should be executed if setUserId size is 0
        /** commented below two lines and moved in first for loop for creating set only for specific opportunities and avoid for unnecessary   */
       // Id EngCSDRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Engineering Opportunity-CSD').getRecordTypeId();
       // Id NDROppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('NDR Opportunity').getRecordTypeId();
        // for(Opportunity Oppty: lstOppNew)
        for(Opportunity Oppty: lstOppNewOne)
                {
            if(IsUpdateTrigger)
            {
                if(Oppty.CCAO_Manager__c != null && mapuser.containsKey(Oppty.CCAO_Manager__c) && (Oppty.CCAO_Manager_Alias__c == null || Oppty.CCAO_Manager__c != mapOppOld.get(Oppty.id).CCAO_Manager__c ))
                    Oppty.CCAO_Manager_Alias__c = mapuser.get(Oppty.CCAO_Manager__c).Alias;

                if(mapuser.containsKey(Oppty.createdbyId) && Oppty.CreatedBy_ProfileId__c == null)
                    Oppty.CreatedBy_ProfileId__c = mapuser.get(Oppty.createdbyId).ProfileId;
                
                if(mapuser.containsKey(Oppty.ownerID) && Oppty.Owner_Manager_Email__c == null)
                {
                    User OpptyUser = mapuser.get(Oppty.ownerID);
                    if(OpptyUser.ManagerId != null)
                        Oppty.Owner_Manager_Email__c= OpptyUser.Manager.Email;
                    else
                        Oppty.Owner_Manager_Email__c= OpptyUser.Email;
                }
                if(Oppty.recordtypeId == EngCSDRecordTypeId && Oppty.Global_Product_Manager__c != null && mapuser.containsKey(Oppty.Global_Product_Manager__c) 
                    && (Oppty.Opportunity_Champion__c == null
                        || Oppty.Global_Product_Manager__c != mapOppOld.get(Oppty.id).Global_Product_Manager__c ) )
                {
                    User OpptyUser1 = mapuser.get(Oppty.Global_Product_Manager__c);
                    if(OpptyUser1.FirstName != null)
                        Oppty.Opportunity_Champion__c = OpptyUser1.FirstName + ' ' + OpptyUser1.LastName;
                    else
                        Oppty.Opportunity_Champion__c = OpptyUser1.LastName;
                }
                if(mapuser.containsKey(Oppty.ownerID) && Oppty.recordtypeId == NDROppRecordTypeId && Oppty.NDR_Owner_Manager_Email_Address__c == null)
                {
                    User OpptyUser2 = mapuser.get(Oppty.ownerID);
                    if(OpptyUser2.ManagerId != null)
                        Oppty.NDR_Owner_Manager_Email_Address__c = OpptyUser2.Manager.Email;
                    else
                        Oppty.NDR_Owner_Manager_Email_Address__c = OpptyUser2.Email;
                }
            }
            else
            {
                if(mapuser.containsKey(Oppty.CCAO_Manager__c) && Oppty.CCAO_Manager__c != null)
                    Oppty.CCAO_Manager_Alias__c = mapuser.get(Oppty.CCAO_Manager__c).Alias;
                Oppty.CreatedBy_ProfileId__c = Userinfo.getProfileId();
                User OpptyUser = mapuser.get(Oppty.ownerID);
                if(OpptyUser != null)
                {
                    if(OpptyUser.ManagerId != null)
                        Oppty.Owner_Manager_Email__c= OpptyUser.Manager.Email;
                    else
                        Oppty.Owner_Manager_Email__c= OpptyUser.Email;
                }
                if(Oppty.recordtypeId == EngCSDRecordTypeId && Oppty.Opportunity_Champion__c == null &&
                    Oppty.Global_Product_Manager__c != null && mapuser.containsKey(Oppty.Global_Product_Manager__c))
                {
                    User OpptyUser1 = mapuser.get(Oppty.Global_Product_Manager__c);
                    if(OpptyUser1.FirstName != null)
                        Oppty.Opportunity_Champion__c = OpptyUser1.FirstName + ' ' + OpptyUser1.LastName;
                    else
                        Oppty.Opportunity_Champion__c = OpptyUser1.LastName;
                }
                if(Oppty.recordtypeId == NDROppRecordTypeId && mapuser.containsKey(Oppty.ownerID))
                {
                    User OpptyUser2 = mapuser.get(Oppty.ownerID);
                    if(OpptyUser2.ManagerId != null)
                        Oppty.NDR_Owner_Manager_Email_Address__c = OpptyUser2.Manager.Email;
                    else
                        Oppty.NDR_Owner_Manager_Email_Address__c = OpptyUser2.Email;
                }
            }
        }
    }
    } //JNV 1/28/2016 - adding extra bracket to close if statement from line 21
}