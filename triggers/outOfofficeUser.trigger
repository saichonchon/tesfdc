/**********************************************************************************************************************************************
*******
Name: outOfofficeUser 
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose:This trigger for when user record changed to out of office then case assignment will be change
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE          DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Narasimha Narra    26/12/2013       Trigger  
 2.0   Poonam Hedaoo      04/09/2017       Track Out Of Office
***********************************************************************************************************************************************
*****/
trigger outOfofficeUser on User (after update)
{
    //CaseAssignmentUsers.outOfofficeUpdate(trigger.newMap,trigger.oldMap);
   /*
   Below code will insert track out of office record, when user checks 'Out of office' option on the User record
   */
    List<Track_out_of_office__c> lstTrack_out_of_office_Insert =new List<Track_out_of_office__c>();
    List<Track_out_of_office__c> lstTrack_out_of_office_Update =new List<Track_out_of_office__c>();
    List<Id> userId= new List<Id>();
    Map<Id,Id> mapUserAndTrackId=new Map<Id,Id>();
    for(User user: Trigger.new){
     userId.add(user.Id);
    }
    List<Track_out_of_office__c> existingTracOrderRecords =[select Id,User__c,Out_of_office_Disabled_On__c,Out_of_office_Enabled_On__c 
                                                            from Track_out_of_office__c where User__c in : userId and 
                                                            Out_of_office_Disabled_On__c = null ];
    for(Track_out_of_office__c track:existingTracOrderRecords){
      mapUserAndTrackId.put(track.User__c,track.Id);
    }
    for (User user: Trigger.new) {
            Track_out_of_office__c trackOOO= new Track_out_of_office__c();
            User oldUser = Trigger.oldMap.get(user.ID);
            if (user.Out_Of_Office__c != oldUser.Out_Of_Office__c) {
                if(user.Out_Of_Office__c) {
                    trackOOO.User__c= user.Id;
                    trackOOO.Out_of_office_Enabled_On__c =system.Now();
                    lstTrack_out_of_office_Insert.add(trackOOO);
                }else{
                   if(mapUserAndTrackId.get(user.id) != null){
                        trackOOO= new Track_out_of_office__c(id = mapUserAndTrackId.get(user.id));
                        trackOOO.Out_of_office_Disabled_On__c=system.Now();
                        lstTrack_out_of_office_Update.add(trackOOO);
                    }
                }
                
            }
        }
        try{
        
        if(!lstTrack_out_of_office_Insert.isEmpty()){
         insert lstTrack_out_of_office_Insert;//Insert Track out of Office record
         }
         if(!lstTrack_out_of_office_Update.isEmpty()){
         update lstTrack_out_of_office_Update;//Update Track out of Office record
         }
        }catch(Exception ex){
        }
}