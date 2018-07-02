/**************************************************************************************************************************************************
Name: NPSLanguagePopulate 
Copyright © 2011 TE Connectivity | Instance : Industrial
===================================================================================================================================================
Purpose: The Trigger is to update the NPS Templates for Different Languages based on the NPS Language Picklist Selection 
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR                DATE         DETAIL                                            Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Rossi Heigruajm       04/15/2014   NPS Survey Template Population                        
**************************************************************************************************************************************************/

Trigger NPSLanguagePopulate on Contact (Before insert, Before update) {
    Map<string,NPS_Templates_All_Languages__c> LangUpdate = new Map<string,NPS_Templates_All_Languages__c>();      
    list<NPS_Templates_All_Languages__c> lang  = new list<NPS_Templates_All_Languages__c>();
    
    if(!Test.isRunningTest())  lang =[select id,Language__c,NPS_Invitation_1__c,NPS_Invitation_2__c,NPS_Invitation_3__c,
    NPS_Invitation_3_2__c,NPS_Invitation_4__c,NPS_Invitation_5__c,NPS_Invitation_6__c,NPS_Invitation_7__c,NPS_Invitation_8__c,
    NPS_Salutation__c,NPS_Salutation_2__c,NPS_Subjects__c from NPS_Templates_All_Languages__c] ;
    for(NPS_Templates_All_Languages__c storeinMap:lang)
    
     {
        LangUpdate.put(storeinMap.Language__c,storeinMap);
    } 
    system.debug('LangUpdate:::: '+LangUpdate);
    for(Contact conObj:Trigger.new)
    {system.debug('conObj:::: '+conObj);
      if(LangUpdate.containskey(conObj.NPS_Language__c))
      {
          conObj.NPS_Invitation_1_4__c = LangUpdate.get(conObj.NPS_Language__c).NPS_Invitation_1__c +'<p> </p>'+ '<BR/>' +'<p> </p>'+ LangUpdate.get(conObj.NPS_Language__c).NPS_Invitation_2__c +'<p> </p>'+ '<BR/>' +'<p> </p>'+
          LangUpdate.get(conObj.NPS_Language__c).NPS_Invitation_3__c +' '+ LangUpdate.get(conObj.NPS_Language__c).NPS_Invitation_3_2__c +'<p> </p>'+ '<BR/>' +'<p> </p>'+ LangUpdate.get(conObj.NPS_Language__c ).NPS_Invitation_4__c;
          conObj.NPS_Invitation_5_7__c=LangUpdate.get(conObj.NPS_Language__c).NPS_Invitation_5__c +'<p> </p>'+ '<BR/>' +'<p> </p>'+ LangUpdate.get(conObj.NPS_Language__c).NPS_Invitation_6__c +'<p> </p>'+ '<BR/>' +'<p> </p>'+
          LangUpdate.get(conObj.NPS_Language__c).NPS_Invitation_7__c;
          conObj.NPS_Invitation_8__c=LangUpdate.get(conObj.NPS_Language__c).NPS_Invitation_8__c;
          conObj.NPS_Salutation__c=LangUpdate.get(conObj.NPS_Language__c).NPS_Salutation__c;
          conObj.NPS_Subjects__c = LangUpdate.get(conObj.NPS_Language__c).NPS_Subjects__c;
          conObj.NPS_Salutation_2__c=LangUpdate.get(conObj.NPS_Language__c).NPS_Salutation_2__c;


                
      }      
    }
}