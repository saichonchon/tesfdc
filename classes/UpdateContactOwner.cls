/**
Author              |Author-Email                       |Date        |Comment
*   ----------------|---------------------------------- |------------|-------------------------------------
*Prabhanjan Nandyala| Prabhanjan.nandyala@zensar.in     |10-04-2014  | 
*Pawan Kumar Nitin  | pavan.vasigala@zensar.com         |07-18-2016  |
*Vasigala

* Purpose: Class provides utility methods for updating the contact owner based on the owner change.
* Teamup case: 00789926, Based on the description by business, the contact owner has to change when its account owner changes.
*
* @Changelog
* TeamUp case : 895878
* Added Methods changeContactOwner_FE_GAM() & updateContactOnSalesHierarchyOwnerChange() to :
*    1) to bring upon Contact re-assignment of Account related Contacts when a FE or GAM is - Changed or removed
*    2) to bring upon Contact re-assignment of Account related Contacts when the person behind the GAM Code
*       Sales Hierarchy record changes.
* respectively.
**/
public class UpdateContactOwner {
    public static void ChangeContactOwner(map<id,account> mapOldAccounts, map<id,account> mapNewAccounts){
        set<Id> oldowners = new set<Id>();
        set<Id> changedAccIds = new set<Id>();
        map<Id,Id> mapAccToOldOwner = new map<Id,Id>();
        map<Id,Id> mapAccToNewOwner= new map<Id,Id>();
        map<string,Id> mapAccOldOwnerToNewOwner= new map<string,Id>();
        list<contact> ContactsForUpdate = new list<contact>();
        map<Id, set<Id>> accountTeamMap = new map<Id, set<Id>>();
        
        
//creating a combination of old owner name and new owner when the owner changes.
        
        for(account a:mapOldAccounts.values()){
            system.debug('old - '+ a.OwnerId+'-- new - '+mapNewAccounts.get(a.Id).OwnerId );
            if(mapNewAccounts.get(a.Id).OwnerId != a.OwnerId){
                oldowners.add(a.OwnerId);
                changedAccIds.add(a.Id); 
                mapAccOldOwnerToNewOwner.put(a.id+'-'+a.OwnerId,mapNewAccounts.get(a.Id).OwnerId);
            }
        }
        
// getting the accountteam ids for checking whether to change the contact owner or not.               
        for(Account_Team__c at:[select id,Account__c,Team_Member__c from Account_Team__c where Account__c IN :changedAccIds and Team_Member__c!='']){
             if(!accountTeamMap.containsKey(at.Account__c))         accountTeamMap.put(at.Account__c, new set<Id>());   
             
            accountTeamMap.get(at.Account__c).add(at.Team_Member__c);
        }
        
        list<contact> lstContacts = new list<contact>();
        boolean isContactEligible = true;
// updating the name by getting the value from the previous map.        
        for(contact c:[select id,ownerid,accountId,account.ownerId from contact where accountId IN :changedAccIds AND Ownerid IN :oldowners]){
            
            if(accountTeamMap.containsKey(c.accountId)){ 
                if(accountTeamMap.get(c.accountId).contains(c.ownerid)){
                    isContactEligible = false;
                } 
            }
 
            if(isContactEligible == true && mapAccOldOwnerToNewOwner.containsKey(c.accountId+'-'+c.OwnerId)){ 
                c.ownerId = mapAccOldOwnerToNewOwner.get(c.accountId+'-'+c.OwnerId);
                ContactsForUpdate.add(c);
                isContactEligible = true;
            }
        }
        
        if(!ContactsForUpdate.isEmpty()&& !Test.isRunningTest())    Update ContactsForUpdate;
        
        
    }
    
    public static void changeContactOwner_FE_GAM(Map<Id,Account> oldAccMap,Map<Id,Account> newAccMap){
        
        Account oldAcc,newAcc;
        
        Map<Id,UpdateContactOwner.accChangeHelper> accChangeMap = new Map<Id,UpdateContactOwner.accChangeHelper>();
        Set<Id> hierarchySet = new Set<Id>();
        Map<Id,Id> hierarchyMap = new Map<Id,Id>();
        
        for(Id eachAccId : oldAccMap.keySet()){
            
            oldAcc = oldAccMap.get(eachAccId);
            newAcc = newAccMap.get(eachAccId);
            
            UpdateContactOwner.accChangeHelper helperInst;
            
            if( !accChangeMap.containsKey(eachAccId)) {
                accChangeMap.put(eachAccId,new accChangeHelper());
            }
            
            // FE or GAM Removed from Service
            if((oldAcc.FE_Hierarchy__c != null && newAcc.FE_Hierarchy__c == null)){
                
                helperInst = accChangeMap.get(eachAccId);
                
                helperInst.FERemoval = true;
                helperInst.FeOldId = oldAcc.FE_Hierarchy__c;
                accChangeMap.put(eachAccId,helperInst);
                        
                hierarchySet.add(oldAcc.FE_Hierarchy__c);
            }
            if((oldAcc.Sales_Hierarchy_GAM__c != null && newAcc.Sales_Hierarchy_GAM__c == null)){
                
                helperInst = accChangeMap.get(eachAccId);
                
                helperInst.GAMRemoval = true;
                helperInst.GAMOldId = oldAcc.Sales_Hierarchy_GAM__c;
                accChangeMap.put(eachAccId,helperInst);
                        
                hierarchySet.add(oldAcc.Sales_Hierarchy_GAM__c);
                
            }
            ////////////////////////////////////////////
            
            // FE or GAM Replaced
            if((oldAcc.FE_Hierarchy__c != null && newAcc.FE_Hierarchy__c != null 
                && oldAcc.FE_Hierarchy__c != newAcc.FE_Hierarchy__c)){
                
                helperInst = accChangeMap.get(eachAccId);
                
                helperInst.FEChange = true;
                helperInst.FeOldId = oldAcc.FE_Hierarchy__c;
                helperInst.FeNewId = newAcc.FE_Hierarchy__c;
                accChangeMap.put(eachAccId,helperInst);
                        
                hierarchySet.add(oldAcc.FE_Hierarchy__c);
                hierarchySet.add(newAcc.FE_Hierarchy__c);
            }
            
            if((oldAcc.Sales_Hierarchy_GAM__c != null && newAcc.Sales_Hierarchy_GAM__c != null 
                && oldAcc.Sales_Hierarchy_GAM__c != newAcc.Sales_Hierarchy_GAM__c)){
                
                helperInst = accChangeMap.get(eachAccId);
                
                helperInst.GAMChange = true;
                helperInst.GAMOldId = oldAcc.Sales_Hierarchy_GAM__c;
                helperInst.GAMNewId = newAcc.Sales_Hierarchy_GAM__c;
                accChangeMap.put(eachAccId,helperInst);
                        
                hierarchySet.add(oldAcc.Sales_Hierarchy_GAM__c);
                hierarchySet.add(newAcc.Sales_Hierarchy_GAM__c);
            }
            ///////////////////////////////////////////////////
           
        }
        
        if( hierarchySet.size() > 0 ){
            
            for( Sales_Hierarchy__c eachHierarchy : [Select Id,Name,Level_7_Default_Owner__c from Sales_Hierarchy__c Where Id IN : hierarchySet]){
                
                hierarchyMap.put(eachHierarchy.Id,eachHierarchy.Level_7_Default_Owner__c);
                
            }
        }
        
        UpdateContactOwner.accChangeHelper helper;
        List<Contact> contactsToUpdate = new List<Contact>();
        
        if( accChangeMap.size() > 0){
            
            for(Account eachAcc : [Select Id,Name,Account_Manager__c,
                                            (Select Id,FirstName,LastName,OwnerId from Contacts) FROM Account Where Id IN : accChangeMap.keySet()]){
                
                if( accChangeMap.containsKey(eachAcc.Id)){
                    
                    helper = accChangeMap.get(eachAcc.Id);
                    
                    if( helper.FERemoval || helper.GAMRemoval) {
                        
                        for(Contact eachCon : eachAcc.Contacts){
                            
                            if( eachCon.ownerId == hierarchyMap.get(helper.FeOldId)){
                                eachCon.ownerId = eachAcc.Account_Manager__c;
                                contactsToUpdate.add(eachCon);
                            }
                            
                            if( eachCon.ownerId == hierarchyMap.get(helper.GAMOldId)){
                                eachCon.ownerId = eachAcc.Account_Manager__c;
                                contactsToUpdate.add(eachCon);
                            }
                        }
                        
                    }
                    
                    if( helper.FEChange || helper.GAMChange){
                        
                            
                        for(Contact eachCon : eachAcc.Contacts){
                            
                            if( eachCon.ownerId == hierarchyMap.get(helper.FeOldId)){
                                eachCon.ownerId = hierarchyMap.get(helper.FeNewId);
                                contactsToUpdate.add(eachCon);
                            }
                            
                            if( eachCon.ownerId == hierarchyMap.get(helper.GAMOldId)){
                                eachCon.ownerId = hierarchyMap.get(helper.GAMNewId);
                                contactsToUpdate.add(eachCon);
                            }
                        }
                        
                    }
                }
            }
        }
        
        update contactsToUpdate;
    }
    
    public static void updateContactOnSalesHierarchyOwnerChange( Map<Id,Sales_Hierarchy__c> oldMap,Map<Id,Sales_Hierarchy__c> newMap){
        
        Sales_Hierarchy__c oldSH,newSH;
        
        Map<Id,Id> mapOldToNew = new Map<Id,Id>();
        Set<String> territoryCodes = new Set<String>();
        List<Contact> contactsToUpdate = new List<Contact>();
        
        for(Id eachSHId : oldMap.keySet()){
            
            oldSH = oldMap.get(eachSHId);
            newSH = newMap.get(eachSHId);
            
            if( oldSH.Level_7_Default_Owner__c != newSH.Level_7_Default_Owner__c && oldSH.Level_7_Default_Owner__c !=null) {
                territoryCodes.add(newSH.Level_7_Territory_Code__c);
                mapOldToNew.put(oldSH.Level_7_Default_Owner__c,newSH.Level_7_Default_Owner__c);
            }
        }
        
        Map<Id,Account> dbAccWithContacts = new Map<Id,Account>([Select Id,(Select Id,ownerId from Contacts) from Account Where GAMCD__c IN :territoryCodes]);
        
        for(Account eachAcc : dbAccWithContacts.values()){
            
            for(Contact eachCon : eachAcc.Contacts){
                
                if(mapOldToNew.containsKey(eachCon.ownerId)){
                    eachCon.ownerId = mapOldToNew.get(eachCon.ownerId);
                    contactsToUpdate.add(eachCon);
                }
            }    
        }
        
        update contactsToUpdate;
    }
    
    public class accChangeHelper{
    
        public Id FeOldId{get;set;}
        public Id FeNewId{get;set;}
        public Id GAMOldId{get;set;}
        public Id GAMNewId{get;set;}
        public Boolean FEChange{get;set;}
        public Boolean FERemoval{get;set;}
        public Boolean GAMChange{get;set;}
        public Boolean GAMRemoval{get;set;}
        
        private accChangeHelper(){
            this.FeOldId = null;
            this.FeNewId = null;
            this.GAMOldId = null;
            this.GAMNewId = null;
            this.FEChange = false;
            this.FERemoval = false;
            this.GAMChange = false;
            this.GAMRemoval = false;
        }
    
    }
    
}