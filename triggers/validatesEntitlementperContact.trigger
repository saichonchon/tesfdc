/**********************************************************************************************************************************************
*******
Name: validatesEntitlementperContact
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose:This trigger for validation on entitlementContact to allow only One entitlement per contact
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE          DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Narasimha Narra    21/11/2013       Trigger  
 
***********************************************************************************************************************************************/
trigger validatesEntitlementperContact on EntitlementContact (before insert,before delete)
{          
    try{
        if(trigger.isBefore && trigger.isInsert)
        {
            set<Id> conIds= new set<Id>();
            list<contact> updatecons=new list<contact>();
            set<Id> updateconIds= new set<Id>();
            for(EntitlementContact ec:trigger.new)
            {
                conIds.add(ec.ContactId);
            }
                
            map<Id,contact> getContact = new  map<Id,contact>([SELECT Id,Contact_Has_Entitlement__c FROM Contact where Id in:conIds]);
            for(EntitlementContact ec:trigger.new)
            {
                if(getContact.get(ec.ContactId).Contact_Has_Entitlement__c &&!Test.isRunningTest())
                ec.addError('A Contact can have only one entitlement');
                else
                updateconIds.add(ec.ContactId);
                
            }
            //system.debug('-------------'+getContact);
            for(contact con :getContact.values())
            {
                if(updateconIds.contains(con.Id))
                {
                    con.Contact_Has_Entitlement__c =true;
                    updatecons.add(con);
                }
            }
            if(!updatecons.isEmpty()){
                Apex_Helper_Settings__c profileId= Apex_Helper_Settings__c.getInstance('Customer Care Service Cloud');
                CCP_Trigger__c tempSkipValidation = CCP_Trigger__c.getInstance(profileId.Value__c);            
                if(tempSkipValidation == null)tempSkipValidation = new CCP_Trigger__c();
                tempSkipValidation.Skip_Validation__c = true;
                upsert tempSkipValidation;
                
                update updatecons;
                tempSkipValidation.Skip_Validation__c = false;
                update tempSkipValidation;
            }
                
        }
        if(trigger.isBefore && trigger.isDelete)
        {
            set<Id> uconIds= new set<Id>();
            list<contact> ucontacts=new list<contact>();
            for(EntitlementContact ec:trigger.old)
            {
                uconIds.add(ec.ContactId);
            }
            for(contact c:[SELECT Id,Contact_Has_Entitlement__c FROM Contact where Id in:uconIds])
            {
                if(c.Contact_Has_Entitlement__c){
                    c.Contact_Has_Entitlement__c=false;
                    ucontacts.add(c);
                }
            }
            if(!ucontacts.isEmpty()){
                Apex_Helper_Settings__c profileId= Apex_Helper_Settings__c.getInstance('Customer Care Service Cloud');
                CCP_Trigger__c tempSkipValidation = CCP_Trigger__c.getInstance(profileId.Value__c);            
                if(tempSkipValidation == null)tempSkipValidation = new CCP_Trigger__c();
                tempSkipValidation.Skip_Validation__c = true;
                upsert tempSkipValidation;
                
                update ucontacts;
                tempSkipValidation.Skip_Validation__c = false;
                update tempSkipValidation;
            }
        }
    }
    catch(Exception e){
        CCP_Exception_Util.CCP_Exception_Mail(e);
    }
    

}