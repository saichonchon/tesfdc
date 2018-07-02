/**
 *  Trigger to generate account plan attachment, wenn a attachment of account plan is inserted.
 * 
 * @author Yuanyuan Zhang
 * @created 2012-05-24
 * @version 1.0
 * @since 23.0
 * 
 * return
 *
 * @changelog
 * 2012-05-24 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>
 * - Created   
 *
 */



trigger Attachment_AID_generateAccoutPlanAttachment on Attachment (after delete, after insert) {
	
	//************************* BEGIN Pre-Processing **********************************************
	//************************* END Pre-Processing ************************************************
	//************************* BEGIN Before Trigger **********************************************
	
	//************************* END Before Trigger ************************************************
	
	//************************* BEGIN After Trigger ***********************************************
	Schema.DescribeSObjectResult KP = Schema.SObjectType.Account_Plan__c;
           
    if(trigger.isinsert){
        if(trigger.new[0].ParentId != null){
	        String pId = trigger.new[0].ParentId;        
	        if(pId.substring(0,3) == KP.getKeyPrefix()){            
	            if(trigger.isafter){
	            	if(trigger.new.size() > 1){
	            		List<Account_Plan_Attachment__c> list_accPlanAttachment = new List<Account_Plan_Attachment__c>();
		                for(integer i=0; i<trigger.new.size(); i++){                
		                    if(trigger.new[i].BodyLength > 3145728){
		                        trigger.new[i].addError(system.Label.file_size_cannot_be_greater_than_3_MB);
		                    }
		                    else if(trigger.new[i].Name != 'VoiceOverview.wav' && !trigger.new[i].Name.startsWith('Picture')){
		                        Account_Plan_Attachment__c accPlanAttachment = new Account_Plan_Attachment__c();
		                        accPlanAttachment.Name = trigger.new[i].Name;
		                        accPlanAttachment.Account_Plan__c = trigger.new[i].ParentId;
		                        accPlanAttachment.AttachmentId__c = trigger.new[i].Id;
		                        accPlanAttachment.Send_Attachment_to_Executive_Dashboard__c = False;
		                        accPlanAttachment.Type__c = 'Attachment';
		                        accPlanAttachment.Content_Type__c = trigger.new[i].ContentType;
		                        list_accPlanAttachment.add(accPlanAttachment);
		                    }
		                }
		                if(list_accPlanAttachment.size() != 0){
		                	insert list_accPlanAttachment;
		                }
	            	}
	                else{
	                	if(trigger.new[0].BodyLength > 3145728){
	                        trigger.new[0].addError(system.Label.file_size_cannot_be_greater_than_3_MB);
	                    }
	                }
	            }
	             
	        }
        }
    }
    
    if(trigger.isdelete){
        if(trigger.old[0].ParentId != null){
	        String pId = trigger.old[0].ParentId;
	        if(pId.substring(0,3) == KP.getKeyPrefix()){
	            List<String> list_attId =  new List<String>();
	            List<Account_Plan_Attachment__c> list_accPlanAttachment = new List<Account_Plan_Attachment__c>();
	            for(Attachment att : trigger.old){
	                list_attId.add(att.Id);
	            }
	            list_accPlanAttachment = [Select Id From Account_Plan_Attachment__c Where AttachmentId__c IN :list_attId];
	            if(list_accPlanAttachment.size() != 0){
	            	delete list_accPlanAttachment;
	            }
	            
	         }
         }
    }
	//************************* END After Trigger *************************************************

}