trigger AcustomerNoteTrigger on Note (after insert, after delete) {
    Schema.DescribeSObjectResult KP = Schema.SObjectType.A_Customer_Profile__c;
    if(trigger.isafter && trigger.isinsert){
        if(trigger.new[0].ParentId != null){
        String PId = trigger.new[0].ParentId;
        system.debug(KP.getKeyPrefix() + ' ' + PId.substring(0,3));
        if(PId.substring(0,3) == KP.getKeyPrefix()){
            List<A_Customer_Profile_Attachment__c> LstACustomerAttachment = new List<A_Customer_Profile_Attachment__c>();
            for(integer i=0; i<trigger.new.size(); i++){
                A_Customer_Profile_Attachment__c ACustomerAttachment = new A_Customer_Profile_Attachment__c();
                ACustomerAttachment.Name = trigger.new[i].Title;
                ACustomerAttachment.A_Customer_Profile__c = trigger.new[i].ParentId;
                ACustomerAttachment.AttachmentId__c = trigger.new[i].Id;
                ACustomerAttachment.Send_Attachment_to_Executive_Dashboard__c = False;
                ACustomerAttachment.Type__c = 'Note';
                LstACustomerAttachment.add(ACustomerAttachment);
            }
            insert LstACustomerAttachment;
        }
        }
    }
    
    if(trigger.isafter && trigger.isdelete){
        if(trigger.old[0].ParentId != null){
        String PId = trigger.old[0].ParentId;
        if(PId.substring(0,3) == KP.getKeyPrefix()){
            List<String> LstDeleteId = new List<String>();
            for(integer i=0; i<trigger.old.size(); i++){
                LstDeleteId.add(trigger.old[i].Id);
            }
            if(LstDeleteId != null){
                if(LstDeleteId.size()>0){
                    A_Customer_Profile_Attachment__c[] LstDeleteAttachment;
                    try{
                        LstDeleteAttachment = [select Id From A_Customer_Profile_Attachment__c Where AttachmentId__c In :LstDeleteId];
                    }
                    catch(Exception e){}
                    delete LstDeleteAttachment;
                }
            }
        }
        }
    }
}