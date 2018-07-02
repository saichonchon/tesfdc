/**********************************************************************************************************************************************
*******
Name: AssignEntltoContact_CCP
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This class is used to create entitlement contact if contact's account has entitlement .
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE       DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Abhijeet Manepatil  11/14/2013    Class     
 1.1   Rajendra Shahane    01/13/2016    Modified class for case 900944
***********************************************************************************************************************************************
*****/

public Class AssignEntltoContact_CCP{
    public Set<Id> vAccIdSet;
    public Set<Id> vUaccIdSet;
    public Set<Id> vOldaccIdSet;
    public Set<Id> vConIdSet;
    public Map<Id,Account> vAccMap;
    public List<EntitlementContact> vECLst;
    public List<EntitlementContact> vECLsttoDelete;
    public List<Entitlement> vEntlLst;
    public List<Case> vConCsLst;
    public List<Case> vUpdatConCsLst;
    public Map<Id,Entitlement> vEntlMap_UsedinDelete;
    public Map<Id,Entitlement> vAccEntlMap;
    public AssignEntltoContact_CCP(){
    vAccIdSet = new Set<Id>();
    vUaccIdSet = new Set<Id>();
    vOldaccIdSet = new Set<Id>();
    vConIdSet = new Set<Id>();
    vECLst = new List<EntitlementContact>();
    vECLsttoDelete = new List<EntitlementContact>();
    vEntlLst = new List<Entitlement>();
    vConCsLst = new List<Case>();
    vUpdatConCsLst = new List<Case>();
    vAccEntlMap = new Map<Id,Entitlement>();
    }
    
    public void getDataonInsert(List<Contact> pConLst){
        for(Contact cn : pConLst){
            if(cn.AccountID != null)
            vAccIdSet.add(cn.AccountID);
        }
        if(vAccIdSet.size() > 0) CreateEntlContact(vAccIdSet,pConLst);
    } // End of getDataonInsert() method
    
    public void getDataonUpdate(Map<Id,Contact> pConOldMap, Map<Id,Contact> pConNewMap){
        for(Contact ucn : pConNewMap.Values()){
            if(ucn.accountId != null && ucn.accountId != pConOldMap.get(ucn.id).accountId){
                vUaccIdSet.add(ucn.accountId); // Conacts new accountid set
                vOldaccIdSet.add(pConOldMap.get(ucn.id).accountId); //Contact's old accountid set
                vConIdSet.add(ucn.id); //Contact ids set
            }
        }
        if(vOldaccIdSet.size() > 0) DeleteOldEntlContact(vOldaccIdSet,pConNewMap.keySet());
        if(vUaccIdSet.size() > 0) CreateEntlContact(vUaccIdSet,pConNewMap.values());
        if(vConIdSet.size() > 0) UpdateCasesonContact(vConIdSet,pConNewMap);
    }// End of getDataonUpdate() method.
    
    public void UpdateCasesonContact(Set<Id> pConIdSet,Map<Id,Contact> pConMap){
        // Get cases in which contacts from pConidSet are used
        try
        {
            vConCsLst =[Select id,contactid,accountid from Case where contactid in: pConIdSet];
            for(Case c : vConCSLst){
                // Update case's accounid with contacts new accountid
				if(c.accountId != pConMap.get(c.contactid).accountid)//Added by Rajendra for case 900944
				{//Added by Rajendra for case 900944
					c.accountId = pConMap.get(c.contactid).accountid;
					vUpdatConCsLst.add(c); 
				}//Added by Rajendra for case 900944
            }
			if(vUpdatConCsLst.size() > 0)//Added by Rajendra for case 900944
				update vUpdatConCsLst;
        }
        catch(Exception e){
              CCP_Exception_Util.CCP_Exception_Mail(e);
      }
      
    } //End of UpdateCasesonContact() method
    
    public void DeleteOldEntlContact(Set<Id> pDlEntlCon_AccIdSet,Set<Id> pDlEntlCon_ConSet){
        try
        {
            vEntlMap_UsedinDelete = new Map<Id,Entitlement>([Select id,accountid from Entitlement where accountId in: pDlEntlCon_AccIdSet]);
            vECLsttoDelete = [Select id,ContactId,EntitlementId from EntitlementContact where ContactId in: pDlEntlCon_ConSet AND EntitlementId in: vEntlMap_UsedinDelete.keySet()];
            // Delete EntitlementContacts from Contact's old account entitlement
            delete vECLsttoDelete;
        }
        catch(Exception e){
              CCP_Exception_Util.CCP_Exception_Mail(e);
      }
    } //End of DeleteOldEntlContact() method.
    
    public void CreateEntlContact(Set<Id> pAccIdSet,List<Contact> pCrEntlCon_ConLst){
        try
        {
            vAccMap = new Map<Id,Account>([Select id, Account_Has_Entitlement__c from Account where id in: pAccIdSet]);
            vEntlLst = [Select id,AccountId from Entitlement where Accountid in: pAccIdSet];
            
            for(Entitlement en : vEntlLst){
                if(vAccMap.get(en.AccountId).Account_Has_Entitlement__c == true){
                    vAccEntlMap.put(en.Accountid,en);
                }
            }
            
            for(Contact cn : pCrEntlCon_ConLst){
                if(cn.AccountId != null){
                    if(vAccEntlMap.containskey(cn.AccountId)){
                        EntitlementContact ec = new EntitlementContact();
                        ec.ContactId = cn.Id;
                        ec.EntitlementId = vAccEntlMap.get(cn.AccountId).id;
                        vECLst.add(ec);
                    }
                }
            }
            if(vECLst.size() > 0) insert vECLst;
        }
        catch(Exception e){
              CCP_Exception_Util.CCP_Exception_Mail(e);
      }
    } //End of CreateEntlContact() method   
}