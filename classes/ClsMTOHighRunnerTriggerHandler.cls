/*------------------------------------------------------------
Author:        Buwen Guo <buwen.guo@capgemini.com>
Description:   Handler class for trigger: MTOHighRunner.trigger
			   The user story number is W-00152.
Inputs:        
Test Class:    ClsMTOHighRunnerTriggerHandlerTest
History
2017-07-28 	   Buwen Guo <buwen.guo@capgemini.com> Created
------------------------------------------------------------*/
public class ClsMTOHighRunnerTriggerHandler extends ClsTriggerVirtual {
	
    public static boolean isInUserSync = false;
    
    
    /*------------------------------------------------------------
	Author:        Buwen Guo <buwen.guo@capgemini.com>
	Description:   beforeTrigger method
	Inputs:        trgCtx
	Returns:       
	History
	2017-07-28 	   Buwen Guo <buwen.guo@capgemini.com> created
	------------------------------------------------------------*/
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
    	system.debug('MTO::beforeTrigger::');
        if(trgCtx.isAfter) return;
		if(trgCtx.isInsert) {
            //populateOwnerFromOwnertextField((list<MTO_High_Runner__c>)trgCtx.newList);
        	//populateAccountFromWWAccNum((list<MTO_High_Runner__c>)trgCtx.newList, null);
        	populateOwnerFromSalesHierarchy(trgCtx);
        }
        
        if(trgCtx.isUpdate) {
            //syncOwnerText(trgCtx.newMap, trgCtx.oldMap);
        	//populateAccountFromWWAccNum((list<MTO_High_Runner__c>)trgCtx.newList, (map<Id, MTO_High_Runner__c>)trgCtx.oldMap);
        }
    }
    
    
    
    /*------------------------------------------------------------
	Author:        Buwen Guo <buwen.guo@capgemini.com>
	Description:   method to populate ownerId field from Level_7_Territory_Code__c
	Inputs:        list_new - trigger.new, map_new - trigger.newMap
	Returns:       
	History
	2018-01-26 	   Buwen Guo <buwen.guo@capgemini.com> created
	------------------------------------------------------------*/
	public static void populateOwnerFromSalesHierarchy(ClsWrappers.TriggerContext trgCtx) {
		system.debug('IN::populateOwnerFromSalesHierarchy::');
		
        if(trgCtx.isInsert || trgCtx.isUndelete){
            set<String> set_L7Codes = new set<String>();
            
            for(Sobject sobj : trgCtx.newList) {
                MTO_High_Runner__c mto = (MTO_High_Runner__c)sobj;
                if(mto.Level_7_Territory_Code__c != null && mto.Level_7_Territory_Code__c != ''){
                	set_L7Codes.add(mto.Level_7_Territory_Code__c);
                }
            }
            
            if(set_L7Codes.size()>0){
            	map<String,String> map_L7Code_OwnerId = new map<String,String>();
				for(Sales_Hierarchy__c sh:[select id, Level_7_Default_Owner__c,Level_7_Territory_Code__c
											from Sales_Hierarchy__c 
											where Level_7_Territory_Code__c IN:set_L7Codes AND Level_7_Default_Owner__c != null]){
					map_L7Code_OwnerId.put(sh.Level_7_Territory_Code__c,sh.Level_7_Default_Owner__c);
				}
				system.debug('map_L7Code_OwnerId::'+map_L7Code_OwnerId);
				
				 for(Sobject sobj : trgCtx.newList) {
	                MTO_High_Runner__c mto = (MTO_High_Runner__c)sobj;
	                if(mto.Level_7_Territory_Code__c != null && mto.Level_7_Territory_Code__c != '' && map_L7Code_OwnerId.containsKey(mto.Level_7_Territory_Code__c)){
	                	mto.ownerId = map_L7Code_OwnerId.get(mto.Level_7_Territory_Code__c);
	                }
	            }
            }
        }
	}
    
    
    
    
	/*------------------------------------------------------------
	Author:        Buwen Guo <buwen.guo@capgemini.com>
	Description:   beforeInsert method
	Inputs:        list_new - trigger.new, map_new - trigger.newMap
	Returns:       
	History
	2017-07-28 	   Buwen Guo <buwen.guo@capgemini.com> created
	------------------------------------------------------------
    public static void beforeInsert(list<MTO_High_Runner__c> list_new, map<Id, MTO_High_Runner__c> map_new){
		populateOwnerFromOwnertextField(list_new);
        populateAccountFromWWAccNum(list_new, null);
    }
    */
    
	/*------------------------------------------------------------
	Author:        Buwen Guo <buwen.guo@capgemini.com>
	Description:   beforeUpdate method
	Inputs:        map_new - trigger.newMap, map_old - trigger.OldMap
	Returns:       
	History
	2017-07-28 	   Buwen Guo <buwen.guo@capgemini.com> created
	------------------------------------------------------------
    public static void beforeUpdate(map<Id, MTO_High_Runner__c> map_new, map<Id, MTO_High_Runner__c> map_old){
		syncOwnerText(map_new, map_old);
        populateAccountFromWWAccNum(map_new.values(), map_old);
    }
    */
    
    
	/*------------------------------------------------------------
	Author:        Buwen Guo <buwen.guo@capgemini.com>
	Description:   method to sync owner with OwnerText__c.
	Inputs:        list_new - trigger.new, map_new - trigger.newMap
	Returns:       
	History
	2017-07-28 	   Buwen Guo <buwen.guo@capgemini.com> created
	------------------------------------------------------------
	public static void syncOwnerText(Map<Id, SObject> map_new, Map<Id, SObject> map_old) {
		system.debug('IN::syncOwnerText::');
		if(isInUserSync) {
			return;
		}
		isInUserSync = true;
		
		list<MTO_High_Runner__c> list_runnerUpdateOwner = new list<MTO_High_Runner__c>();
		list<MTO_High_Runner__c> list_runnerUpdateOwnerText = new list<MTO_High_Runner__c>();
		for(Id runnerId : map_new.keySet()) {
			MTO_High_Runner__c runnerNew = (MTO_High_Runner__c)map_new.get(runnerId);
			MTO_High_Runner__c runnerOld = (MTO_High_Runner__c)map_old.get(runnerId);
			if(runnerNew.ownerId != runnerOld.OwnerId) {
				list_runnerUpdateOwnerText.add(runnerNew);
			}
			else if(runnerNew.OwnerText__c != runnerOld.OwnerText__c) {
				list_runnerUpdateOwner.add(runnerNew);
			}
		}
		if(!list_runnerUpdateOwner.isEmpty()) {
			populateOwnerFromOwnertextField(list_runnerUpdateOwner);
		}
		if(!list_runnerUpdateOwnerText.isEmpty()) {
			populateOwnerTextFromOwnerIdField(list_runnerUpdateOwnerText);
		}
	}
	*/
	
	/*------------------------------------------------------------
	Author:        Buwen Guo <buwen.guo@capgemini.com>
	Description:   method to populate standard ownerId field value from user name in OwnerText__c.
	Inputs:        list_new - trigger.new
	Returns:       
	History
	2017-07-28 	   Buwen Guo <buwen.guo@capgemini.com> created
	------------------------------------------------------------
    public static void populateOwnerFromOwnertextField(List<MTO_High_Runner__c> list_new){
    	system.debug('IN::populateOwnerFromOwnertextField::');
    	isInUserSync = true;
    	set<String> set_ownerNames = new set<String>();
    	for(MTO_High_Runner__c obj_temp : list_new){
    		if(obj_temp.OwnerText__c != null && String.isNotBlank(obj_temp.OwnerText__c)){
    			set_ownerNames.add(obj_temp.OwnerText__c);
    		}
    	}
    	
    	map<String,String> map_userName_userId = new map<String,String>();
    	for(User temp_user :[select Id,Name from user where IsActive = true and name IN:set_ownerNames]){
    		map_userName_userId.put(temp_user.name,temp_user.Id);
    	}
    	
    	for(MTO_High_Runner__c obj_temp : list_new){
    		if(obj_temp.OwnerText__c != null && String.isNotBlank(obj_temp.OwnerText__c)){
    			if(map_userName_userId.containsKey(obj_temp.OwnerText__c)){
    				obj_temp.ownerId = map_userName_userId.get(obj_temp.OwnerText__c);
    			}
    			else {
    				obj_temp.OwnerText__c = UserInfo.getName();
    			}
    		}else {
    				obj_temp.OwnerText__c = UserInfo.getName();
			}
    	}
    }
    */
    
	/*------------------------------------------------------------
	Author:        Buwen Guo <buwen.guo@capgemini.com>
	Description:   method to populate standard ownerText field value from user Id.
	Inputs:        list_new - trigger.new
	Returns:       
	History
	2017-07-28 	   Buwen Guo <buwen.guo@capgemini.com> created
	------------------------------------------------------------
    public static void populateOwnerTextFromOwnerIdField(List<MTO_High_Runner__c> list_new){
    	system.debug('IN::populateOwnerTextFromOwnerIdField::');
    	isInUserSync = true;
    	set<String> set_ownerIds = new set<String>();
    	for(MTO_High_Runner__c obj_temp : list_new){
			set_ownerIds.add(obj_temp.OwnerId);
    	}
    	
    	map<String,String> map_userId_userName = new map<String,String>();
    	for(User temp_user :[select Id,Name from user where IsActive = true and Id IN:set_ownerIds]){
    		map_userId_userName.put(temp_user.Id, temp_user.Name);
    	}
    	
    	for(MTO_High_Runner__c obj_temp : list_new){
			if(map_userId_userName.containsKey(obj_temp.OwnerId)){
				obj_temp.OwnerText__c = map_userId_userName.get(obj_temp.OwnerId);
			}
    	}
    }
    */
	
	/*------------------------------------------------------------
	Author:        Yuan Yao <yuan.yao@capgemini.com>
	Description:   method to populate account__c field value from WorldWideAccountNum.
	Inputs:        list_new - trigger.new, map_old - trigger.oldMap
	Returns:       
	History
	2017-08-28 	   Yuan Yao <yuan.yao@capgemini.com> created
	------------------------------------------------------------
    public static void populateAccountFromWWAccNum(List<MTO_High_Runner__c> list_new, map<Id, MTO_High_Runner__c> map_old) {
    	system.debug('IN::populateAccountFromWWAccNum::');
        set<String> set_wwAccNum = new set<String>();
        map<String, Id> map_wwAccNUm_accId = new map<String, Id>();
        if(map_old == null) {
            for(MTO_High_Runner__c runner : list_new) {
                set_wwAccNum.add(runner.WWCORPACCT__c);
            }
        }else if(map_old != null && list_new.size() > 0) {
            for(MTO_High_Runner__c runner : list_new) {
                if(runner.WWCORPACCT__c != null && runner.WWCORPACCT__c != ((MTO_High_Runner__c)map_old.get(runner.Id)).WWCORPACCT__c){
                    set_wwAccNum.add(runner.WWCORPACCT__c);
                }
            }
        }
        if(set_wwAccNum.size() > 0 ) {
            for(Account acc :[Select Id, WWCORPACCT__c From Account Where WWCORPACCT__c in : set_wwAccNum]) {
                map_wwAccNUm_accId.put(acc.WWCORPACCT__c, acc.Id);
            }
        }
        if(map_wwAccNUm_accId.size() > 0) {
            for(MTO_High_Runner__c runner : list_new) {runner.account__c = map_wwAccNUm_accId.get(runner.WWCORPACCT__c);
            }
        }
    }
    */
}