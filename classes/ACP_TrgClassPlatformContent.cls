/******************************************************************************************************************
Name: ACP_TrgClassPlatformContent
Copyright @ 2017 TE Connectivity
=============================================================================
Requirement:
ACP_TrgClassPlatformContent for Task Trigger
=============================================================================
Purpose:
Handler class for trigger on Platform Content object
Updates the comments field on ACP_Application_Breakdown__c with the corresponding 
comments field of Platform_Content__c object.
Test class:
ACP_TrgClassPlatformContent_Test
=============================================================================
History
-------
VERSION   AUTHOR        DATE         DETAIL
1.0 -    Anushka Bansal 08/04/17     INITIAL DEVELOPMENT
2.0 -    Anushka Bansal 11/02/17     Added comments 
3.0 -    Esther         23/11/17     Changed the parameter to sObject from Platform Content
********************************************************************************************************************/
public class ACP_TrgClassPlatformContent {
    
    //Method to update comments field on Application Breakdown whenever the comments field on Platform Content is updated.
    public static void updateComments(Map < Id, sObject > oldPCMap, Map < Id, sObject > newPCMap) {
        
        set < Id > pfcIds = new set < Id > ();
        map < Id,Platform_Content__c> mapPlatformContent = new map < Id,Platform_Content__c> ();
        map < Id,Platform_Content__c>oldPcContent = new map < Id,Platform_Content__c> ();
        list < ACP_Application_Breakdown__c > listAppBreakdown = new list < ACP_Application_Breakdown__c > ();
        List<Platform_Content__c>newPcList=new List<Platform_Content__c>();
               
        for(SObject record : newPCMap.values()) {
            newPcList.add((Platform_Content__c) record);
        }
        for(SObject record : oldPCMap.values()) {
            oldPcContent.put(record.id,(Platform_Content__c) record);
        }
       
        for (Platform_Content__c pf:newPcList) {
          
            if(oldPcContent.get(pf.Id).Comments__c != pf.Comments__c){
                pfcIds.add(pf.Id);
                mapPlatformContent.put(pf.Id, pf);
            }
        }
        
        listAppBreakdown = [SELECT id, Platform_Content__c FROM ACP_Application_Breakdown__c WHERE Platform_Content__c IN: pfcIds];
        
        if (listAppBreakdown.size() > 0) {
            for (ACP_Application_Breakdown__c app: listAppBreakdown) {
                //updating the comments field of Application breakdown with the comments field on platform content
                app.ACP_Comments__c = mapPlatformContent.get(app.Platform_Content__c).Comments__c;
                
            }
        }
        try { update listAppBreakdown;  }Catch(Exception e) { ErrorLogging.Log(e, 'ACP_TrgClassPlatformContent', 'updateComments', '');}
        
    }
}