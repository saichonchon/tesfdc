/**
 *  This batch class is used to set account sales hierarchy
 * 
 * @author Xia Tong
 * @created 2013-03-26
 * @version 1.0
 * @since 27.0
 * 
 * return
 *
 * @changelog
 * 2013-03-26 Xia Tong <xia.tong@itbconsult.com>
 * - Created   
 *
 */

global class ClsBatch_setAccountSalesHierarchy implements Database.Batchable<SObject>{
	public String query;
	public String filter;
	public Id rt_cis_gam;
	public Id rt_cis_account;
	public set<String> set_code;
	
	global ClsBatch_setAccountSalesHierarchy(){
		rt_cis_gam = ClsSharingUtil.gamCustomSetting();
		rt_cis_account = ClsSharingUtil.accountCustomSetting();
	}
	global Database.QueryLocator start(Database.BatchableContext BC){ 
		if (query == '' || query == null){
			query = 'Select Id, Sales_Hierarchy_GAM__c,Sales_Hierarchy_MM__c, RecordTypeId, IND_KAM_Code__c,GAMCD__c,MKTMGRCDE__c,Type,Public_Group_Id__c, Account_Manager__c from Account'; //where (RecordTypeId =\'' + rt_cis_gam + '\' or RecordTypeId =\'' + rt_cis_account + '\') and (GAMCD__c != null or MKTMGRCDE__c != null)' 		}
        }
        if(filter != null) query += filter;
	    return Database.getQueryLocator(query);       
	}
	global void execute(Database.BatchableContext BC, List<Account> list_accounts){
		
		map<String, list<Account>> map_code_accounts = new map<String, list<Account>>();
		for(Account a: list_accounts){
			a.Sales_Hierarchy_GAM__c = null;
			a.Sales_Hierarchy_MM__c = null;
			if(a.RecordTypeId == rt_cis_gam){  
				
				if(a.Type == 'Global Account' && a.GAMCD__c != null){
					if(!map_code_accounts.containsKey(a.GAMCD__c)){
						map_code_accounts.put(a.GAMCD__c,new list<Account>());
					}
					map_code_accounts.get(a.GAMCD__c).add(a);

				}else if(a.Type == 'Grouped B' && a.IND_KAM_Code__c != null){
					if(!map_code_accounts.containsKey(a.IND_KAM_Code__c)){
						map_code_accounts.put(a.IND_KAM_Code__c,new list<Account>());
					}
					map_code_accounts.get(a.IND_KAM_Code__c).add(a);
				}
			}else if(a.RecordTypeId == rt_cis_account){
				if(a.GAMCD__c != null){
					if(!map_code_accounts.containsKey(a.GAMCD__c)){
						map_code_accounts.put(a.GAMCD__c,new list<Account>());
					}
					map_code_accounts.get(a.GAMCD__c).add(a);
				}
				
				if(a.IND_KAM_Code__c != null){
					if(!map_code_accounts.containsKey(a.IND_KAM_Code__c)){
						map_code_accounts.put(a.IND_KAM_Code__c,new list<Account>());
					}
					map_code_accounts.get(a.IND_KAM_Code__c).add(a);
				}
			}	
		}
	 
		if(!map_code_accounts.isEmpty()) ClsSharingUtil.setAccountSalesHierarchy(map_code_accounts);
		ClsSharingUtil.TriggerRecursionDefense = true;
		update list_accounts;
			
	}
	global void finish(Database.BatchableContext BC){
		ClsBatch_AccountSharingInit batchCls = new ClsBatch_AccountSharingInit();
		batchCls.query = query;
		batchCls.set_code = set_code;
		database.executeBatch(batchCls); 
	}
}