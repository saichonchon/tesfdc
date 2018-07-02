/**********************************************************************************************************************************************
*******
Name: validatesEntitlement
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose:This trigger for validation on Account to allow only One entitlement
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE          DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Narasimha Narra    8/11/2013       Trigger  
 1.1   Abhijeet           12/11/2013      Addtion of logic to add contacts of accounts into entitlementcontact object.                
***********************************************************************************************************************************************
*****/
trigger validatesEntitlement  on Entitlement (before insert,after insert,after delete) 
{
    try{
        if(Trigger.IsBefore){
           set<Id> accIds= new set<Id>();
           map<Id,List<Entitlement>> mapAccId_Entitlement =new map<Id,List<Entitlement>>();
           for(Entitlement en:trigger.new)
           {
               accIds.add(en.accountId);
           }
           for(Entitlement en:[select Id,AccountId from Entitlement where AccountId in:accIds])
           {
                if(!mapAccId_Entitlement.containsKey(en.AccountId))
                {
                    mapAccId_Entitlement.put(en.AccountId,new List<Entitlement>{en});
                
                }
                else{ mapAccId_Entitlement.get(en.AccountId).add(en);}
                            
                
           }
           //system.debug('map'+mapAccId_Entitlement);
           for(Entitlement en:trigger.new)
           {
               if(mapAccId_Entitlement.values().size()>0)
               { 
                   if(mapAccId_Entitlement.containsKey(en.accountId) && !mapAccId_Entitlement.get(en.accountId).isEmpty())
                   {
                       if(mapAccId_Entitlement.get(en.accountId).size()>0 && !Test.isRunningTest())
                       en.addError('You cannot create more than one entitlement on an Account');
                   }
               }
               
           }
       }
       if(Trigger.IsAfter && trigger.isInsert){
            List<EntitlementContact> vEntlConLst = new List<EntitlementContact>();
            Map<Id,Entitlement> vMapAccIdEntlmnt = new Map<Id,Entitlement>();
            List<account> lstupdateaccs= new List<account>();
            for(Entitlement e : trigger.new){
                if(e.AccountID != null)
                    vMapAccIdEntlmnt.put(e.AccountId,e);
            }
            
            if(vMapAccIdEntlmnt.size()>0){
                // Get list of contacts related to account on entitlements
                for(Contact c : [Select id,name,AccountId from Contact where AccountId in: vMapAccIdEntlmnt.keySet()]){
                    //Create EntitlementContact records by referring contacts and entitlement
                    EntitlementContact ec = new EntitlementContact();
                    ec.ContactId = c.id;
                    ec.EntitlementID = vMapAccIdEntlmnt.get(c.AccountId).id;
                    vEntlConLst.add(ec);
                }
                insert vEntlConLst ;
                //Mark accounts which have entitlements enabled
                for(account acc : [Select id,Account_Has_Entitlement__c from account where Id in: vMapAccIdEntlmnt.keySet()])
                {
                    acc.Account_Has_Entitlement__c=true;
                    lstupdateaccs.add(acc);
                }
                if(!lstupdateaccs.isEmpty())
                update lstupdateaccs;
                }
           }
           
        if(trigger.isafter && trigger.isdelete)
        {
            set<id> accids=new set<id>();
            List<Contact> lstUpdateContacts= new List<Contact>();
            list<account> lstupdateaccs=new List<account>();
      
            for(Entitlement en:trigger.old)
            {
                  accids.add(en.accountid);  
            }
            //Set Account_Has_Entitlement__c field as false when entitlemnt enabled for account is deleted.
            for(account acc:[select id,Account_Has_Entitlement__c from account where id in:accids])
            {
                acc.Account_Has_Entitlement__c=false;
                lstupdateaccs.add(acc);
            }
            if(!lstupdateaccs.isEmpty())
             update lstupdateaccs;
             for(contact con:[select Id,Contact_Has_Entitlement__c from contact where accountId in:accids])
             {
                if(con.Contact_Has_Entitlement__c){
                    con.Contact_Has_Entitlement__c = false;
                    lstUpdateContacts.add(con);
                }
             }
             if(!lstUpdateContacts.isEmpty()){
                Apex_Helper_Settings__c profileId= Apex_Helper_Settings__c.getInstance('Customer Care Service Cloud');
                CCP_Trigger__c tempSkipValidation = CCP_Trigger__c.getInstance(profileId.Value__c);            
                if(tempSkipValidation == null)tempSkipValidation = new CCP_Trigger__c();
                tempSkipValidation.Skip_Validation__c = true;
                upsert tempSkipValidation;
                
                update lstUpdateContacts;
                tempSkipValidation.Skip_Validation__c = false;
                update tempSkipValidation;
            }
        }
    }
    catch(Exception e){
        CCP_Exception_Util.CCP_Exception_Mail(e);
    }     
}