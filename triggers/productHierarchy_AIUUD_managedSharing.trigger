/**
 * This trigger used to manage Sharing of Product_Hierarchy__c.
 *
 * @author      Yinfeng Guo
 * @created     2012-03-19
 * @since       23.0 (Force.com ApiVersion)      
 * @version     1.0 
 *
 * @changelog
 * 2012-03-19 Yinfeng Guo <yinfeng.guo@itbconsult.com>
 * 2014-06-10 Jinbo Shan <jinbo.shan@itbconsult.com>
 * Added fuction that update the field "DGI_Value__c" in Opportunity when the field "GDI_Classification__C" is changed.
 * - Created 
 * 2012-04-05 Yinfeng Guo <yinfeng.guo@itbconsult.com>
 * - Modified: Remove validate Record Type
 *  
 */

trigger productHierarchy_AIUUD_managedSharing on Product_Hierarchy__c (after insert, after undelete, after update) {
    
    String triggerName = 'Product_Hierarchy__c';
    //************************* BEGIN Pre-Processing **********************************************
    //System.debug('************************* ' + triggerName + ': BEGIN Pre-Processing ********');
    /*Id rt_GPL;
    if(Apex_Helper_Settings__c.getInstance('GPL Record Type Id') != null) rt_GPL = Apex_Helper_Settings__c.getInstance('GPL Record Type Id').Value__c;*/
    //************************* END Pre-Processing ************************************************
    //System.debug('************************* ' + triggerName + ': END Pre-Processing **********');
    
    
    //************************* BEGIN Before Trigger **********************************************
    if(Trigger.isBefore) {
        System.debug('************************* ' + triggerName + ': Before Trigger ************');
    }
    //************************* END Before Trigger ************************************************
    
    
    //************************* BEGIN After Trigger ***********************************************
    if(Trigger.isAfter) {
        System.debug('************************* ' + triggerName + ': After Trigger *************');

        //if(rt_GPL != null) {
            set<Id> set_ids2InsertShare = new set<Id>();
            set<Id> set_ids2DeleteShare = new set<Id>();
            String mode;
            if(trigger.isInsert || trigger.isUnDelete) {
                for (Product_Hierarchy__c ph : trigger.new) { 
                    //if(ph.RecordTypeId != null && ph.RecordTypeId == rt_GPL) set_ids2InsertShare.add(ph.Id);
                    set_ids2InsertShare.add(ph.Id);  
                }
                if(!set_ids2InsertShare.isEmpty()){
                    mode = ClsSharingUtil.MODE_INSERT;
                    ClsSharingUtil.ModifyProductHierarchySharing(mode,set_ids2InsertShare);
                }
            }
            else if(trigger.isUpdate){
                
                map<id, string> map_pId_cIdList = new map<id, string>();
                String uids; 
                for (Product_Hierarchy__c ph : trigger.new){
                    /*if old is record type , and new is not record type*/
                    //if(ph.RecordTypeId != rt_GPL && trigger.oldMap.get(ph.Id).RecordTypeId != null && trigger.oldMap.get(ph.Id).RecordTypeId == rt_GPL ){
                    //  set_ids2DeleteShare.add(ph.Id);
                    //}
                    /*if old is not record type , and new is record type*/
                    //else if(ph.RecordTypeId != null && ph.RecordTypeId == rt_GPL ){
                        
                        if(trigger.oldMap.get(ph.Id).Product_Manager__c != null && ph.Product_Manager__c != trigger.oldMap.get(ph.Id).Product_Manager__c){
                            if(!map_pId_cIdList.containsKey(ph.Id)) map_pId_cIdList.put(ph.Id, trigger.oldMap.get(ph.id).Product_Manager__c);
                            else {
                                uids = map_pId_cIdList.get(ph.Id);
                                map_pId_cIdList.put(ph.Id , uids + ',' + trigger.oldMap.get(ph.id).Product_Manager__c);
                            }
                        }
                        if(trigger.oldMap.get(ph.Id).Regional_PM_AP__c != null && ph.Regional_PM_AP__c != trigger.oldMap.get(ph.Id).Regional_PM_AP__c){
                            if(!map_pId_cIdList.containsKey(ph.Id)) map_pId_cIdList.put(ph.Id, trigger.oldMap.get(ph.id).Regional_PM_AP__c);
                            else {
                                uids = map_pId_cIdList.get(ph.Id);
                                map_pId_cIdList.put(ph.Id , uids + ',' + trigger.oldMap.get(ph.id).Regional_PM_AP__c);
                            }
                        }
                        if(trigger.oldMap.get(ph.Id).Regional_PM_EU__c != null && ph.Regional_PM_EU__c != trigger.oldMap.get(ph.Id).Regional_PM_EU__c){
                            if(!map_pId_cIdList.containsKey(ph.Id)) map_pId_cIdList.put(ph.Id, trigger.oldMap.get(ph.id).Regional_PM_EU__c);
                            else {
                                uids = map_pId_cIdList.get(ph.Id);
                                map_pId_cIdList.put(ph.Id , uids + ',' + trigger.oldMap.get(ph.id).Regional_PM_EU__c);
                            }
                        }
                        if(trigger.oldMap.get(ph.Id).Regional_PM_US__c != null && ph.Regional_PM_US__c != trigger.oldMap.get(ph.Id).Regional_PM_US__c){
                            if(!map_pId_cIdList.containsKey(ph.Id)) map_pId_cIdList.put(ph.Id, trigger.oldMap.get(ph.id).Regional_PM_US__c);
                            else {
                                uids = map_pId_cIdList.get(ph.Id);
                                map_pId_cIdList.put(ph.Id , uids + ',' + trigger.oldMap.get(ph.id).Regional_PM_US__c);
                            }
                        }
                        if(trigger.oldMap.get(ph.Id).Global_PM__c != null && ph.Global_PM__c != trigger.oldMap.get(ph.Id).Global_PM__c){
                            if(!map_pId_cIdList.containsKey(ph.Id)) map_pId_cIdList.put(ph.Id, trigger.oldMap.get(ph.id).Global_PM__c);
                            else {
                                uids = map_pId_cIdList.get(ph.Id);
                                map_pId_cIdList.put(ph.Id , uids + ',' + trigger.oldMap.get(ph.id).Global_PM__c);
                            }
                        }
                        if(trigger.oldMap.get(ph.Id).Approver_PM__c != null && ph.Approver_PM__c != trigger.oldMap.get(ph.Id).Approver_PM__c){
                            if(!map_pId_cIdList.containsKey(ph.Id)) map_pId_cIdList.put(ph.Id, trigger.oldMap.get(ph.id).Approver_PM__c);
                            else {
                                uids = map_pId_cIdList.get(ph.Id);
                                map_pId_cIdList.put(ph.Id , uids + ',' + trigger.oldMap.get(ph.id).Approver_PM__c);
                            }
                        }
                        set_ids2InsertShare.add(ph.Id);
                    //}
                }
                /*
                if(!set_ids2DeleteShare.isEmpty()){
                    mode = ClsSharingUtil.MODE_DELETE;
                    ClsSharingUtil.ModifyProductHierarchySharing(mode,set_ids2DeleteShare);
                }*/
                if(!set_ids2InsertShare.isEmpty()){
                    mode = ClsSharingUtil.MODE_INSERT;
                    ClsSharingUtil.ModifyProductHierarchySharing(mode,set_ids2InsertShare);
                }
                if(!map_pId_cIdList.isEmpty()){
                    ClsSharingUtil.DeleteProductHierarchySharing(map_pId_cIdList);
                }
                
                //Start: added by Jinbo Shan to update the field "DGI_Value__c" in Opportunity when the field "GDI_Classification__C" is changed
                List<Product_Hierarchy__c> list_proHierarchy = new List<Product_Hierarchy__c>();
                for (Product_Hierarchy__c ph : trigger.new) {
                	if(ph.GDI_Classification__c != trigger.oldMap.get(ph.Id).GDI_Classification__c){
                		list_proHierarchy.add(ph);
                	}
                }
                if(list_proHierarchy.size() > 0){
                	ClsPMV_Util.calculateGDIValue(list_proHierarchy);
                }
                //End
            }       
        }           
    //}
    //************************* END After Trigger *************************************************
    
}