/**
* 
*   This after update Trigger copies in case of an Account Owner Change, the Account Owner in Account Owner Lookup on related Oppies.
*
*   Author              |Author-Email                       |Date        |Comment
*   --------------------|---------------------------------- |------------|-------------------------------------
*   Frederic Faisst     |frederic.faisst@itbconsult.com     |14.03.2012  |Initial Draft
*   Prabhanjan Nandyala | Prabhanjan.nandyala@zensar.in    |10-04-2014 | Modified the trigger to use the class: UpdateContactOwner, commenting out the other code based on the comments in the case:00789926 
*   Pawan Kumar Nitin   |Pavan.vasigala@zensar.com          |07-18-2016  |Modified the trigger to use the class: UpdateContactOwner, to include lines for Contact Re-Assignment.
*   Vasigala                                                                
* 
* @Changelog
* TeamUp case : 895878
* Added Method changeContactOwner_FE_GAM() calling to :
*    1) to bring upon Contact re-assignment of Account related Contacts when a FE or GAM is - Changed or removed
**/



trigger account_AU_copyAccOwnerToOppies on Account (before update, after update) {
    
    /*
    *   Collections 
    */    
    Map<Id, Id> map_accId_accOwnerId = new Map<Id, Id>();
    List<Opportunity> list_oppies2Update = new List<Opportunity>();
    List<Contact> list_contact2Update = new List<Contact>();
    Set<Id> AccIdSet = new Set<Id>();
    Set<Id> RTIdSet = new Set<Id>();
    //Set<String> ApexHelperset = new Set<String>();    //--code optimized-case 901452--//
    map<id, id> usercontactmap = new map<id, id>();
    
    //ApexHelperset = changecontactowner.returnapexhelpmep();    //--code optimized-case 901452--//
    //TEIS Admin lastmodified check
    Map<Id, User> activeusrmap = new Map<Id, User>();
    //activeusrmap.putall([Select name, id, isactive, GIBU__c from User]);
            
    //For each account in trigger loop
    for(Account acc : Trigger.new){
        //If Owner is changed
        if(Trigger.oldMap.get(acc.Id).OwnerId != acc.OwnerId){
            map_accId_accOwnerId.put(acc.Id, acc.OwnerId);
            if(Apex_Helper_Settings__c.getInstance('TEIS_Admin').Value__c == userinfo.getName()){
                AccIdSet.add(acc.Id);
            }
        }
    }
    
    Map<String, Consumer_Device_Opportunity_Record_Types__c> ConsumerMap = Consumer_Device_Opportunity_Record_Types__c.getall();
    if(ConsumerMap.ContainsKey('Engineering Opportunity-CSD')){
        RTIdSet.add(ConsumerMap.get('Engineering Opportunity-CSD').Record_Type_Id__c);
    }
    if(ConsumerMap.ContainsKey('Sales Opportunity-CSD')){
        RTIdSet.add(ConsumerMap.get('Sales Opportunity-CSD').Record_Type_Id__c);
    }
    
    if(!map_accId_accOwnerId.IsEmpty()){
        if(trigger.isafter){
            //For each opportunity of accounts those owners was changed
            for(Opportunity oppy : [Select Id, Account_Owner__c, AccountId, StageName From Opportunity Where AccountId in :map_accId_accOwnerId.keySet() and RecordTypeId NOT IN :RTIdSet And StageName != 'Rejected' And StageName != 'On Hold' And StageName != 'Lost' And StageName != 'Dead']){
                //Account Owner is only replicated to related opportunities if those phase not equal to "Rejected", "On Hold", "Lost" and "Dead"
                //--code optimized-case-901542--added is to soql where--//
                //if(oppy.StageName != 'Rejected' && oppy.StageName != 'On Hold' && oppy.StageName != 'Lost' && oppy.StageName != 'Dead'){
                    oppy.Account_Owner__c = map_accId_accOwnerId.get(oppy.AccountId);
                    list_oppies2Update.add(oppy);
                //}
            }
            // Prabhanjan [05-May-2015]
            UpdateContactOwner.ChangeContactOwner(trigger.OldMap , trigger.NewMap);
        }
        /*
         * Prabhanjan [08-Apr-2015]:commenting out the the following code based on the comments in the case:00789926 
         *
       if(trigger.isbefore){ 
            //---------Local Collection Declarations----------
            Map<String, Account_Team__c> mapAcidUsrstring_UserId = new Map<String, Account_Team__c>();
            Map<Id, Id> mapConId_UserId = new Map<Id, Id>();
            
            //retrieve Custom Account Team for Team User Role(D-1302 Req)
            for(Account_Team__c atm: [Select id, Account__c, Role__c, Team_Member__c from Account_Team__c where Account__c IN: AccIdSet]){
                mapAcidUsrstring_UserId.put(atm.Account__c+'-'+atm.Team_Member__c, atm);
            }
            
            //retrieve contact history for reversing functionality(D-1302 Req)
            map<id, String> chmap = new map<id, String>();
            List<ContactHistory> conhistlist = new List<ContactHistory>();
            if(Test.isRunningTest()){                
                List<Contact> ConlistRecs=[Select id, accountid from Contact where AccountId IN :trigger.new];
                if(ConlistRecs.size()>0){
                    conhistlist.add(new ContactHistory(ContactId=ConlistRecs[0].id, Field='Owner'));
                    //conhistlist.add(new ContactHistory(ContactId=ConlistRecs[1].id, Field='Owner'));
                    chmap.put(ConlistRecs[0].id, trigger.oldmap.get(ConlistRecs[0].AccountId).OwnerId);
                    //chmap.put(ConlistRecs[1].id, trigger.oldmap.get(ConlistRecs[1].AccountId).OwnerId);
                    
                }
            }
            else{
                conhistlist=[Select id, ContactId, Contact.Name, CreatedDate, Contact.OwnerId, NewValue, OldValue, CreatedBy.Name, Field from ContactHistory where Contact.AccountId IN :AccIdSet and Field='Owner' Order By CreatedDate DESC];
            }
            
            if(conhistlist.size()>0){
                for(ContactHistory conhist:conhistlist){
                    //added to test the codecoverage for past history
                    String OldValue;
                    String CreatedName;
                    if(chmap.Containskey(conhist.ContactId)){
                        OldValue=chmap.get(conhist.ContactId);
                        CreatedName='TEIS Admin';
                        System.debug('11111111111111111111111111111');
                    }
                    else{
                        OldValue=String.ValueOf(conhist.NewValue);
                        CreatedName=conhist.CreatedBy.Name;
                    }
                    
                    if(!mapConId_UserId.Containskey(conhist.ContactId)){
                        if(OldValue.StartsWith('005')){
                            if(CreatedName=='TEIS Admin'){
                                mapConId_UserId.put(conhist.ContactId ,OldValue);
                            }
                        }
                    }
                }
            }
            system.debug('mapConId_UserId ==>' + mapConId_UserId);
            activeusrmap.putall([Select name, id, isactive, GIBU__c from User where Id IN :mapConId_UserId.values() Limit 50000]);
            
            Id ConOwnerId;
            for(Contact conrec:[Select Id, name, OwnerId,Owner.name,AccountId from Contact where AccountId IN :trigger.new]){
                if(Apex_Helper_Settings__c.getInstance('TEIS_Admin').Value__c==userinfo.getName()){
                    system.debug('Entered 1');
                    if(mapConId_UserId.Containskey(conrec.id)){
                        system.debug('Entered 2');
                        if(activeusrmap.get(mapConId_UserId.get(conrec.id)).isactive==true){
                            system.debug('mapAcidUsrstring_UserId' + mapAcidUsrstring_UserId);
                            system.debug('mapConId_UserId ===>' + mapConId_UserId.get(conrec.id));
                            if(mapAcidUsrstring_UserId.Containskey(conrec.Accountid+'-'+mapConId_UserId.get(conrec.id))){
                                system.debug('****' + mapAcidUsrstring_UserId.get(conrec.Accountid+'-'+mapConId_UserId.get(conrec.id)).Role__c);
                                if(ApexHelperset.contains(mapAcidUsrstring_UserId.get(conrec.Accountid+'-'+mapConId_UserId.get(conrec.id)).Role__c)){
                                    conrec.OwnerId=mapConId_UserId.get(conrec.id);
                                    System.debug('11111111111111111111111111111');
                                    list_contact2Update.add(conrec);
                                    System.debug('222222222222222222222222222222');
                                }                                                                
                            }
                        }
                        else{
                        System.debug('3333333333333333333333333333333');
                            conrec.OwnerId=trigger.newmap.get(conrec.AccountId).OwnerId;
                            list_contact2Update.add(conrec);
                            System.debug('44444444444444444444444444444444');
                        }
                    }
                    else{
                        if(trigger.oldmap.get(conrec.AccountId).OwnerId == conrec.OwnerId){
                            conrec.OwnerId=trigger.newmap.get(conrec.AccountId).OwnerId;
                            
                            list_contact2Update.add(conrec);
                        }
                    }
                   //list_contact2Update.add(conrec);                    
                }
                else{
                    if(trigger.oldmap.get(conrec.AccountId).OwnerId == conrec.OwnerId){
                        Id OwnerId=conrec.OwnerId;
                        conrec.OwnerId=OwnerId;
                        list_contact2Update.add(conrec);
                        System.debug('55555555555555555555555555555555555'+list_contact2Update);
                    }
                }
                usercontactmap.put(conrec.id, conrec.OwnerId);
            }
        }
        */
    }
    try{
    //If list contains values
    if(!list_oppies2Update.isEmpty() && !Test.isRunningtest()){
        update list_oppies2Update;
    }
    
    /*
         * Pawan [18-Jul-2016]: Adding Lines To bring in Contact Re-Assignment upon FE or GAM - Change or Removal from Account
         *                      case:895878 
         *
    */
    if( trigger.isAfter && Trigger.isUpdate){
            UpdateContactOwner.changeContactOwner_FE_GAM(trigger.OldMap , trigger.NewMap);
    }

        /*
         * Prabhanjan [08-Apr-2015]:commenting out the the following code based on the comments in the case:00789926 
         *
    //added by xia 2012-12-04 update according contact owner
    if(!list_contact2Update.isEmpty()){
        changecontactowner.conmap.putall(list_contact2Update);
        changecontactowner.ConList=list_contact2Update;
        update list_contact2Update;        
    }
    if(trigger.isafter){
        List<contact> cls = new List<Contact>();
        for(Contact conrec:changecontactowner.ConList){            
            if(changecontactowner.conmap.Containskey(conrec.id)){
                conrec.ownerid=changecontactowner.conmap.get(conrec.id).ownerid;             
                cls.add(conrec);
            }
        }
        if(Apex_Helper_Settings__c.getInstance('TEIS_Admin').Value__c != userinfo.getName()){
            update cls;
        }
        return;
    }
        */
    }
    catch(exception e){
        trigger.new[0].adderror(e.getdmlmessage(0));
    }
    //if(trigger.isafter){
   // ContactOwnerChange.changeConactact(trigger.old,trigger.newMap,trigger.oldMap);
    //}
}