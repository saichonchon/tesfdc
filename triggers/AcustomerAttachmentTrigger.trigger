trigger AcustomerAttachmentTrigger on Attachment (after insert, before delete) {
    Schema.DescribeSObjectResult KP = Schema.SObjectType.TEACstmrProfile__A_Customer_Profile__c;
           
    /*if(trigger.isinsert){
        if(trigger.new[0].ParentId != null){
        String PId = trigger.new[0].ParentId;        
        if(PId.substring(0,3) == KP.getKeyPrefix()){            
            if(trigger.isafter){
                if(trigger.new.size() > 1){
                    List<A_Customer_Profile_Attachment__c> LstACustomerAttachment = new List<A_Customer_Profile_Attachment__c>();
                    for(integer i=0; i<trigger.new.size(); i++){                
                        if(trigger.new[i].BodyLength > 3145728){
                            trigger.new[i].Name.addError('Attachment Size Cannot be more than 3mb');
                        }
                        else{
                            A_Customer_Profile_Attachment__c ACustomerAttachment = new A_Customer_Profile_Attachment__c();
                            ACustomerAttachment.Name = trigger.new[i].Name;
                            ACustomerAttachment.A_Customer_Profile__c = trigger.new[i].ParentId;
                            ACustomerAttachment.AttachmentId__c = trigger.new[i].Id;
                            ACustomerAttachment.Send_Attachment_to_Executive_Dashboard__c = False;
                            ACustomerAttachment.Type__c = 'Attachment';
                            LstACustomerAttachment.add(ACustomerAttachment);
                        }
                    }
                    insert LstACustomerAttachment;
                }
                else{       
                    for(integer i=0; i<trigger.new.size(); i++){
                        if(trigger.new[i].BodyLength > 3145728){
                            trigger.new[i].Name.addError('Attachment Size Cannot be more than 3mb');
                        }
                    }
                }
            }
             
        }
        }
    }*/
    
    if(trigger.isdelete){
        if(trigger.old[0].ParentId != null){
	        String PId = trigger.old[0].ParentId;
	        if(PId.substring(0,3) == KP.getKeyPrefix()){
	            Set<Id> set_attId =  new Set<Id>();
	            List<TEACstmrProfile__A_Customer_Profile_Attachment__c> LstAcustomerAttachment = new List<TEACstmrProfile__A_Customer_Profile_Attachment__c>();
	            for(Attachment att : trigger.old){
	                set_attId.add(att.Id);
	            }
	            
	            LstAcustomerAttachment = [Select Id From TEACstmrProfile__A_Customer_Profile_Attachment__c Where TEACstmrProfile__AttachmentId__c IN :set_attId];
	            if(!LstAcustomerAttachment.isEmpty()) delete LstAcustomerAttachment;
	         }
         }
    }
}