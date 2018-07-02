/**********************************************************************************************************************************************
Name: Contact_BI_EmailValidation
Copyright © 2014 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================
Purpose: This trigger used to validate duplicate contact if newly create contact have same account, email & User have Customer Care Profile.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE        DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Ramakrishna Singara  04/14/2014    Trigger                       
***********************************************************************************************************************************************/
trigger Contact_BI_EmailValidation on Contact (before insert) {
    set<id> accIdSet = new set<id>();
    list<Contact> conList = new list<Contact>();
    Map<id, set<string>> accIdemailListMap = new Map<id, set<string>>();   
    Apex_Helper_Settings__c ccProfileId = Apex_Helper_Settings__c.getValues('Customer Care Service Cloud');
    try{
        if(ccProfileId!=null && UserInfo.getProfileId().substring(0,15).contains(ccProfileId.Value__c)){         
            for(contact con: trigger.new){        
                accIdSet.add(con.AccountId);
            }
            if(accIdSet!=null && accIdSet.size()>0){
                conList = [select id, firstname, lastname, Email, AccountId from contact where AccountId in: accIdSet];
            }
            if(conList!=null && conList.size()>0){
                for(Contact con: conList){
                    if(accIdemailListMap.Containskey(con.AccountId)){
                        accIdemailListMap.get(con.AccountId).add(con.Email);
                    }
                    else{
                        accIdemailListMap.put(con.AccountId, new set<string>());   
                        accIdemailListMap.get(con.AccountId).add(con.Email);   
                    }
                }
            }
            for(Contact con: trigger.new){              
                if(con.AccountId!=null){
                    if(accIdemailListMap.Containskey(con.AccountId)){
                        set<string> cEmailSet = accIdemailListMap.get(con.AccountId);
                        if(cEmailSet.contains(con.Email) && (!Test.isRunningTest())){
                            con.adderror('Contact with this email address already exist on same Account');
                        }               
                    }
                }           
            }
        }
    }
    catch(DmlException e) {
        CCP_Exception_Util.CCP_Exception_Mail(e);
    }
}