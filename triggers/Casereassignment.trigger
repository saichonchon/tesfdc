/**********************************************************************************************************************************************
*******
Name: Casereassignment
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose:This trigger updates case record types from PIC to CC/CC to PIC if Case owner reassigned to CC user, queue/PIC User, queue
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE          DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
1.0   Padmaja Dadi    08/08/2015       Trigger 
1.1   Sandeep Y       10/14/2015       Enhancement to include logic when cases get assigned from/to Queue
      RaviPrakash      01/12/2018        Commented Customer care record type
     

***********************************************************************************************************************************************/

trigger Casereassignment on Case (before update) {
    
    Set<ID> OldandNewOwners=new Set<ID>();
    
    for(case csNew:Trigger.new ){
        Case oldcs = Trigger.oldMap.get(csNew.Id);
        if(csNew.OwnerId != oldcs.OwnerID){
            OldandNewOwners.add(csNew.OwnerID);
            OldandNewOwners.add(Trigger.oldMap.get(csNew.ID).OwnerID);
        }
    }
    
    Map<ID, User> OldandNewUserMap=new Map<ID, User>([Select id, profileID from User where ID In :OldandNewOwners]);
    Map<ID, Group> CaseQueueMap=new Map<ID, Group>([Select id, name from Group where ID In :OldandNewOwners]);
    system.debug('****OldandNewUserMap*******'+OldandNewUserMap);
    system.debug('****CaseQueueMap*******'+CaseQueueMap);
    system.debug('****OldandNewOwners*******'+OldandNewOwners);
    
    String picrecordtype = Apex_Helper_Settings__c.getInstance('PIC Service Cloud').Value__c;     
    String customercarerecordtype = Apex_Helper_Settings__c.getInstance('Customer Care Cloud').Value__c;
    Id actualUserProfileId = UserInfo.getProfileId();
    
    Apex_Helper_Settings__c PICProfiles = Apex_Helper_Settings__c.getInstance('PIC Project Profile List');
    system.debug('****PICProfiles***'+PICProfiles);
    List<String> PICProfileList = PICProfiles.value__c.split(',');
    Apex_Helper_Settings__c CCProfiles = Apex_Helper_Settings__c.getInstance('Customer profile list');
    system.debug('****CCProfiles***'+CCProfiles);
    List<String> CCProfileList = CCProfiles.value__c.split(',');
    
    set<Id> set_PICprofileIds = new set<Id>();
    set<Id> set_CCprofileIds = new set<Id>();
    for(Profile p : [SELECT Name, Id FROM Profile where Name in: PICProfileList]){
        set_PICprofileIds.add(p.Id);
    } 
    
    for(Profile p : [SELECT Name, Id FROM Profile where Name in: CCProfileList]){
        set_CCprofileIds.add(p.Id);
    }
    
    BusinessHours defaultHours = [select Id from BusinessHours where IsDefault=true]; 
    
    boolean AssignToPIC = false;
    boolean AssignToCC = false;
    boolean OldOwnerIsPICQueue = false;
    boolean NewOwnerIsPICQueue = false;
    boolean OldOwnerIsCCQueue = false;
    boolean NewOwnerIsCCQueue = false;
    boolean OldOwnerIsPICUser = false;
    boolean NewOwnerIsPICUser = false;
    boolean OldOwnerIsCCUser = false;
    boolean NewOwnerIsCCUser = false;
    
    string OldOwnerQueueName = '';
    string OwnerQueueName = '';
    
    
    for (Case c : Trigger.new) {
        // Access the "old" record by its ID in Trigger.oldMap
        Case oldc = Trigger.oldMap.get(c.Id);
        AssignToPIC = false;      
        AssignToCC = false;
        OldOwnerIsPICQueue = false;
        NewOwnerIsPICQueue = false;
        OldOwnerIsCCQueue = false;
        NewOwnerIsCCQueue = false;
        OldOwnerIsPICUser = false;
        NewOwnerIsPICUser = false;
        OldOwnerIsCCUser = false;
        NewOwnerIsCCUser = false;
        
        system.debug('New Owner ID- ' + c.OwnerId);
        system.debug('Old Owner ID- ' + oldc.OwnerID);
        
        system.debug('New Owner Name- ' + c.Owner);
        system.debug('Old Owner Name - ' + oldc.Owner);
        
        system.debug('New Recordtype - ' + c.RecordType);
        system.debug('Old Recordtype - ' + oldc.RecordType);
        
        if(c.OwnerId != oldc.OwnerID)
        {      
            
            system.debug(' IN - if(c.OwnerId != oldc.OwnerID)');
            
            if( (OldandNewUserMap!=null && !OldandNewUserMap.isEmpty()) ||
                (CaseQueueMap!=null && !CaseQueueMap.isEmpty()))
            {
                system.debug(' IN - if(OldandNewUserMap!=null && !OldandNewUserMap.isEmpty())');
                //condition where both new and old owner's are users and their profile does not match
                if (OldandNewUserMap.get(c.OwnerId) != null && OldandNewUserMap.get(oldc.OwnerId) != null &&
                    OldandNewUserMap.get(c.OwnerId).ProfileID!=OldandNewUserMap.get(oldc.OwnerId).ProfileID)
                {
                    
                    //check if new owner profile exists in CC profiles collection and old owner profile exists in PIC profiles collection
                    if(set_CCprofileIds.contains(OldandNewUserMap.get(c.OwnerId).ProfileID) && set_PICprofileIds.contains(OldandNewUserMap.get(oldc.OwnerId).ProfileID)) 
                    {
                        //if new Owner is CC and Old Owner is PIC
                        AssignToCC = true;
                    }
                    //check if new owner profile exists in PIC profiles collection and old owner profile exists in CC profiles collection
                    else if(set_PICprofileIds.contains(OldandNewUserMap.get(c.OwnerId).ProfileID) && set_CCprofileIds.contains(OldandNewUserMap.get(oldc.OwnerId).ProfileID))
                    {
                        //if new Owner is PIC and Old Owner is CC
                        AssignToPIC = true;
                    }
                    system.debug('Inside 1 ....');
                }
                else
                {
                    system.debug('Inside 2......');
                    //check if New Owner is Queue
                    if (CaseQueueMap.get(c.OwnerId) != null)
                    {
                        system.debug('Inside 3......');
                        system.debug('New Owner Queue Name = ' + CaseQueueMap.get(c.OwnerId).Name + ' -- ');
                        if (CaseQueueMap.get(c.OwnerId).Name.startsWithIgnoreCase('PIC ')) // if queue name starts with text "PIC " then it is PIC queue 
                        {
                            NewOwnerIsPICQueue = true;
                        }
                        else // the queue is CC Queue
                        {
                            NewOwnerIsCCQueue = true;
                        }
                    }
                    
                    //check if Old Owner is Queue
                    if (CaseQueueMap.get(oldc.OwnerId) != null)
                    {
                        system.debug('Inside 4......');
                        system.debug('Old Owner Queue Name  = ' + CaseQueueMap.get(oldc.OwnerId).Name + ' -- ');
                        if (CaseQueueMap.get(oldc.OwnerId).Name.startsWithIgnoreCase('PIC ')) // if queue name starts with text "PIC " then it is PIC queue 
                        {
                            OldOwnerIsPICQueue = true;
                        }
                        else // the queue is CC Queue
                        {
                            OldOwnerIsCCQueue = true;
                        }
                    }
                    
                    //check if new owner is User
                    if (OldandNewUserMap.get(c.OwnerId) != null)
                    {
                        system.debug('Inside 5......');
                        //if new owner is PIC user
                        NewOwnerIsPICUser = set_PICprofileIds.contains(OldandNewUserMap.get(c.OwnerId).ProfileID);
                        //if new owner is CC user
                        NewOwnerIsCCUser = set_CCprofileIds.contains(OldandNewUserMap.get(c.OwnerId).ProfileID);
                    }
                    
                    //check if old owner is User
                    if (OldandNewUserMap.get(oldc.OwnerId) != null)
                    {
                        system.debug('Inside 6......');
                        //if old owner is PIC user
                        OldOwnerIsPICUser = set_PICprofileIds.contains(OldandNewUserMap.get(oldc.OwnerId).ProfileID);
                        //if old owner is CC user
                        OldOwnerIsCCUser = set_CCprofileIds.contains(OldandNewUserMap.get(oldc.OwnerId).ProfileID);
                    }
                    
                    //check if case is transfered from CC to PIC
                    if ((NewOwnerIsPICQueue || NewOwnerIsPICUser) && (OldOwnerIsCCQueue || OldOwnerIsCCUser))
                    {
                        system.debug('Inside 7......');
                        //if new Owner is PIC and Old Owner is CC
                        AssignToPIC = true;
                    }
                    //check if case is transfered from PIC to CC
                    else if ((NewOwnerIsCCQueue || NewOwnerIsCCUser) && (OldOwnerIsPICQueue || OldOwnerIsPICUser))
                    {
                        system.debug('Inside 8......');
                        //if new Owner is CC and Old Owner is PIC
                        AssignToCC = true;
                    }
                    
                    
                }
                
            }
            
            system.debug('Inside 2.1 - NewOwnerIsCCQueue = ' + NewOwnerIsCCQueue + ' -- ');
            system.debug('Inside 2.1 - NewOwnerIsCCUser= ' + NewOwnerIsCCUser+ ' -- ');
            system.debug('Inside 2.1 - OldOwnerIsPICQueue = ' + OldOwnerIsPICQueue + ' -- ');
            system.debug('Inside 2.1 - OldOwnerIsPICUser= ' + OldOwnerIsPICUser+ ' -- ');
            system.debug('Inside 2.1 - NewOwnerIsPICQueue = ' + NewOwnerIsPICQueue + ' -- ');
            system.debug('Inside 2.1 - NewOwnerIsPICUser= ' + NewOwnerIsPICUser+ ' -- ');
            system.debug('Inside 2.1 - OldOwnerIsCCQueue = ' + OldOwnerIsCCQueue + ' -- ');
            system.debug('Inside 2.1 - OldOwnerIsCCUser= ' + OldOwnerIsCCUser+ ' -- ');
            system.debug('Inside 2.1 - AssignToCC= ' + AssignToCC+ ' -- ');
            system.debug('Inside 2.1 - AssignToPIC= ' + AssignToPIC+ ' -- ');
            
            if (AssignToCC)
            {
                system.debug('Inside 9......');
                //c.RecordTypeId = customercarerecordtype;
                c.Inquiry_Type__c = 'Other';
                c.Status_Comments__c = 'In Progress';
                c.Other_Inquiry_Type__c='Other';
                c.BusinessHoursId = defaultHours.Id;
                c.Status='Case Re-assigned by PIC';
            }
            else if (AssignToPIC)
            {
                system.debug('Inside 10......');
                c.RecordTypeId = picrecordtype;
                c.Inquiry_Type__c = 'Other';
                c.Status_Comments__c = 'In Progress';
                c.Other_Inquiry_Type__c='Other';
                c.BusinessHoursId = defaultHours.Id;
                c.Status='Case Re-assigned by CC';
            }
            
        } //if(c.OwnerId != oldc.OwnerID)
    } //for (Case c : Trigger.new)
}