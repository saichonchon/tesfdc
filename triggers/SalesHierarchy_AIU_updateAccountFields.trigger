/**
 *  This trigger is used for dynamic altering account's field Sales_Hierarchy_GAM__c and Sales_Hierarchy_MM__c 
 when after update Sales_Hierarchy__c's field  Hierarchy_Type__c.
 * 
 * @author Leijun Miao
 * @created 2013-03-26
 * @version 1.0
 * @since 27.0
 * 
 * return
 *
 * @changelog
 * 2013-03-26 Leijun Miao <leijun.miao@itbconsult.com>
 * - Created   
 *
 * @Changelog
* TeamUp case : 895878
* Added Methods updateContactOnSalesHierarchyOwnerChange() to :
*    1) to bring upon Contact re-assignment of Account related Contacts when a Person behind a GAM Hierarchy changes.
* @changgelog
Team up case 901319
*11-14-2017 Ramya Maragapury 
*Added Conditions for GAM &MM Field updates:  The batch should only fire if GAM code or MM code are changed. 
**/

 
trigger SalesHierarchy_AIU_updateAccountFields on Sales_Hierarchy__c (after insert,after update) { 
    if(!ClsSharingUtil.TriggerRecursion4SalesHierarchy){
        set<string> set_code = new set<string>();
        string query = '';
        Id rt_cis_gam = ClsSharingUtil.gamCustomSetting();
        Id rt_cis_account = ClsSharingUtil.accountCustomSetting();
        
        if(trigger.isInsert){
          for(Sales_Hierarchy__c sh:trigger.new){
          system.debug('===='+sh.Hierarchy_Type__c);
            if(sh.Level_7_Territory_Code__c != null && (sh.Hierarchy_Type__c=='Global Account Manager Hierarchy (GAM)' ||  sh.Hierarchy_Type__c=='Market Manager Hierarchy (MM)') ){ 
              set_code.add(sh.Level_7_Territory_Code__c);
            }
          }  
        }else{
          for(Sales_Hierarchy__c sh:trigger.new){
            if(sh.Level_7_Territory_Code__c != trigger.oldMap.get(sh.Id).Level_7_Territory_Code__c){
              if(sh.Level_7_Territory_Code__c != null && (sh.Hierarchy_Type__c=='Global Account Manager Hierarchy (GAM)' || sh.Hierarchy_Type__c=='Market Manager Hierarchy (MM)') ){ 
                set_code.add(sh.Level_7_Territory_Code__c);
              }
              if(trigger.oldMap.get(sh.Id).Level_7_Territory_Code__c != null && (sh.Hierarchy_Type__c=='Global Account Manager Hirarchy (GAM)' || sh.Hierarchy_Type__c=='Market Manager Hierarchy (MM)' ) ){ 
                set_code.add(trigger.oldMap.get(sh.Id).Level_7_Territory_Code__c);
              }
            }
          }
        }
        
        
        if(set_code.Size()>0){
          query = 'Select Id, Sales_Hierarchy_GAM__c,Sales_Hierarchy_MM__c, RecordTypeId, GAMCD__c, IND_KAM_Code__c, MKTMGRCDE__c,Type,Public_Group_Id__c, Account_Manager__c from Account where  (RecordTypeId =\'' + rt_cis_gam + '\' or RecordTypeId =\'' + rt_cis_account + '\') and (GAMCD__c in:set_code or IND_KAM_Code__c in:set_code)';
          ClsBatch_setAccountSalesHierarchy batch = new ClsBatch_setAccountSalesHierarchy();
          batch.query = query;
          batch.set_code = set_code;
          if(!test.isRunningTest()) {
            Database.executeBatch(batch);
          }
        }    
        
        // Added line to reflect Contact reassignment when person beind a Sales Hierarchy changes.
        if( Trigger.isAfter && Trigger.isUpdate){
            UpdateContactOwner.updateContactOnSalesHierarchyOwnerChange(Trigger.oldMap,Trigger.newMap);
        }
    }
}