/**
 *  Trigger to generate attachment for account plan, wenn a note is inserted or deleted
 * 
 * @author Yuanyuan Zhang
 * @created 2012-05-18
 * @version 1.0
 * @since 23.0
 * 
 * return
 *
 * @changelog
 * 2012-05-18 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>
 * - Created   
 *
 */



trigger Note_AID_generateAccountPlanNote on Note (after delete, after insert) {
	
	//************************* BEGIN Pre-Processing **********************************************
	//************************* END Pre-Processing ************************************************
	//************************* BEGIN Before Trigger **********************************************
	
	//************************* END Before Trigger ************************************************
	
	//************************* BEGIN After Trigger ***********************************************
	Schema.DescribeSObjectResult KP = Schema.SObjectType.Account_Plan__c;
    if(trigger.isafter && trigger.isinsert){
        if(trigger.new[0].ParentId != null){
	        String pId = trigger.new[0].ParentId;
	        system.debug(KP.getKeyPrefix() + ' ' + pId.substring(0,3));
	        if(pId.substring(0,3) == KP.getKeyPrefix()){
	            List<Account_Plan_Attachment__c> list_accPlanAttachment = new List<Account_Plan_Attachment__c>();
	            for(integer i=0; i<trigger.new.size(); i++){
	                Account_Plan_Attachment__c accPlanAttachment = new Account_Plan_Attachment__c();
	                accPlanAttachment.Name = trigger.new[i].Title;
	                accPlanAttachment.Account_Plan__c = trigger.new[i].ParentId;
	                accPlanAttachment.AttachmentId__c = trigger.new[i].Id;
	                accPlanAttachment.Send_Attachment_to_Executive_Dashboard__c = False;
	                accPlanAttachment.Type__c = 'Note';
	                list_accPlanAttachment.add(accPlanAttachment);
	            }
	            if(list_accPlanAttachment.size() != 0){
	            	insert list_accPlanAttachment;
	            }
	        }
        }
    }
    
    if(trigger.isafter && trigger.isdelete){
        if(trigger.old[0].ParentId != null){
	        String pId = trigger.old[0].ParentId;
	        if(pId.substring(0,3) == KP.getKeyPrefix()){
	            List<String> list_noteId = new List<String>();
	            for(integer i=0; i<trigger.old.size(); i++){
	                list_noteId.add(trigger.old[i].Id);
	            }
	            if(list_noteId != null){
	                if(list_noteId.size()>0){
	                    list<Account_Plan_Attachment__c> list_accPlanAttchment2Del = new list<Account_Plan_Attachment__c>();
	                    list_accPlanAttchment2Del = [select Id From Account_Plan_Attachment__c Where AttachmentId__c IN :list_noteId];
	                    
	                    if(list_accPlanAttchment2Del.size() != 0){
	                    	delete list_accPlanAttchment2Del;
	                    }
	                }
	            }
	        }
        }
    }
	//************************* END After Trigger *************************************************

}