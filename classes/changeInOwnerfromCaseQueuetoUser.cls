/**********************************************************************************************************************************************
*******
Name: changeInOwnerfromCaseQueuetoUser
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This class updates the case fields when owner Changed from queue to User
        This class is called by keepescalationastrue trigger on case object.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE          DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Narasimha Narra       03/12/2013    Class                       
***********************************************************************************************************************************************
 1.0   Ramakrishna Singara       13/03/2014    Class                       
***********************************************************************************************************************************************/
public class changeInOwnerfromCaseQueuetoUser
{
    public static void updateCaseRegion(map<id,case> newMapCs,map<id,case> oldMapCs)
    {
        try
        {
            Apex_Helper_Settings__c QueueType1 = Apex_Helper_Settings__c.getInstance('APAC Channel Team');
            Apex_Helper_Settings__c QueueType2 = Apex_Helper_Settings__c.getInstance('APAC Arrow Team');
            Apex_Helper_Settings__c QueueType3 = Apex_Helper_Settings__c.getInstance('APAC Avnet Team');
            Apex_Helper_Settings__c QueueType4 = Apex_Helper_Settings__c.getInstance('APAC Channel Korea Team');
            Apex_Helper_Settings__c QueueType5 = Apex_Helper_Settings__c.getInstance('APAC Serial Team');
            Apex_Helper_Settings__c QueueType6 = Apex_Helper_Settings__c.getInstance('APAC TTI Team');
            
            set<Id> ownerIds= new set<Id>();
            for(case c:newMapCs.values())
            {
                if((oldMapCs.get(c.id).OwnerId == QueueType1.value__c ||
                    oldMapCs.get(c.id).OwnerId == QueueType2.value__c ||
                    oldMapCs.get(c.id).OwnerId == QueueType3.value__c ||
                    oldMapCs.get(c.id).OwnerId == QueueType4.value__c ||
                    oldMapCs.get(c.id).OwnerId == QueueType5.value__c ||
                    oldMapCs.get(c.id).OwnerId == QueueType6.value__c)&& 
                    String.valueOf(c.OwnerId).startsWith('005'))
                {
                    ownerIds.add(c.OwnerId);
                }
            }
            map<id,user> getUserMap;
            if(!ownerIds.isEmpty())
            {
                getUserMap = new map<id,user>([SELECT Id,GIBU__c,APAC_Office__c,Region__c FROM USER WHERE Id in:ownerIds]);
                if(getUserMap.values().size()>0)
                {
                    for(case c:newMapCs.values())
                    {
                        if(getUserMap.containsKey(c.ownerId))
                        {
                             c.GIBU__c = getUserMap.get(c.ownerId).GIBU__c;
                             c.Office__c = getUserMap.get(c.ownerId).APAC_Office__c;
                             if(getUserMap.get(c.ownerId).Region__c=='China' || getUserMap.get(c.ownerId).Region__c=='Japan'
                                ||getUserMap.get(c.ownerId).Region__c=='Asia Pacific')
                             {
                                 c.Region__c = 'APAC';
                             }
                             else if(getUserMap.get(c.ownerId).Region__c=='EMEA'){
                                c.Region__c = 'EMEA';
                             }
                             else if(getUserMap.get(c.ownerId).Region__c=='Americas'){
                                c.Region__c = 'America';
                             }
                        }
                    }
                }
            }
        }
        catch(Exception e){
              CCP_Exception_Util.CCP_Exception_Mail(e);
        }
    }    
    
    // Enhanced by Ramakrishna Singara(13/03/2014)
    // CaseBeforeInsert method helps, if case owner is a user, then pulling GIBU, Region and APAC Office field info from user Object into Case Record
    public static void CaseBeforeInsert(list<Case> vCslist)
    {
        try{
            set<Id> ownerIds= new set<Id>();
            Apex_Helper_Settings__c CcRecTypeId = Apex_Helper_Settings__c.getInstance('Customer Care Cloud');
            Apex_Helper_Settings__c Ccuser = Apex_Helper_Settings__c.getInstance('TEIS Admin User Id');
            if(vCslist!= null && vCslist.size()>0){
                system.debug('******************'+vCslist.size());
                system.debug('********vCslist list**********'+vCslist);
                for(case vCs:vCslist)
                {
                    if(vCs.RecordTypeId == CcRecTypeId.value__c){
                        if(String.valueOf(vCs.OwnerId).startsWith('005') && vCs.ownerId!=Ccuser.Value__c){
                            ownerIds.add(vCs.OwnerId);
                        }
                    }
                }            
                map<id,user> getUserMap;
                if(!ownerIds.isEmpty())
                {
                    getUserMap = new map<id,user>([SELECT Id,GIBU__c,APAC_Office__c,Region__c FROM USER WHERE Id in:ownerIds]);            
                    for(case vCs:vCslist){
                        if(vCs.RecordTypeId == CcRecTypeId.value__c){
                            if(getUserMap.containsKey(vCs.ownerId)){    
                                if(vCs.GIBU__c==null)
                                    vCs.GIBU__c = getUserMap.get(vCs.ownerId).GIBU__c;                               
                                if(vCs.Office__c == null)
                                    vCs.Office__c = getUserMap.get(vCs.ownerId).APAC_Office__c;                       
                                if((getUserMap.get(vCs.ownerId).Region__c=='China' || getUserMap.get(vCs.ownerId).Region__c=='Japan'
                                ||getUserMap.get(vCs.ownerId).Region__c=='Asia Pacific') && vCs.Region__c==null)
                                {
                                    vCs.Region__c = 'APAC';  
                                } 
                                 else if(getUserMap.get(vCs.ownerId).Region__c=='EMEA' && vCs.Region__c==null)
                                 {                                    
                                    vCs.Region__c = 'EMEA';
                                 }
                                 else if(getUserMap.get(vCs.ownerId).Region__c=='Americas' && vCs.Region__c==null)
                                 {
                                    vCs.Region__c = 'America';
                                 }
                            }
                        }
                    }
                }
            }
        }     
        catch(Exception e){
            CCP_Exception_Util.CCP_Exception_Mail(e);
        }
        
    }
}