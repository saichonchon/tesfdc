/**********************************************************************************************************************************************
*******
Name: AssignEntitlementtoCase
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This class is called by BIU_CCP_AssignEntitlement trigger on Case.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE       DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Abhijeet Manepatil   09/25/2013    Class                       
***********************************************************************************************************************************************
*****/
public class AssignEntitlementtoCase{
    public Set<Id> vAcctIds;
    public Set<Id> conIds;
    public List<Case> conCaseLst;
    public Map<Id,Entitlement> vMapAccIdtoEntment;
    public Apex_Helper_Settings__c vCaseRT;
    public Apex_Helper_Settings__c vCaseRT_Close;
    public List<Case> caseLst;
    public List<Case> vCsLsttoAssignEntl;
    //public List<Case> vCsLsttoAssignInternalContact;
    
    
    public AssignEntitlementtoCase(){
        vAcctIds = new Set<Id>();
        conIds = new Set<Id>();
        conCaseLst = new List<case>();
        caseLst = new List<case>();
        vCsLsttoAssignEntl = new List<Case>();
        vMapAccIdtoEntment = new Map<Id,Entitlement>();
        //vCsLsttoAssignInternalContact=new List<Case>(); 
        vCaseRT = Apex_Helper_Settings__c.getInstance('Customer Care Cloud');
        vCaseRT_Close = Apex_Helper_Settings__c.getInstance('Customer Care Cloud -Case Close');
    }
    public void AssignEntlmnttmailtoupdateCase(map<id,Case> newMap,map<id,Case> oldMap)
    {
        try
        {
            for(Case c:newMap.values())
            {                     
                if((c.accountId != oldMap.get(c.id).accountId) && (c.recordtypeid != null && (c.recordtypeid == vCaseRT.Value__c ||c.recordtypeid == vCaseRT_Close.value__c)))
                caseLst.add(c);
                if(c.contactId!=null && c.accountId==null && c.recordtypeid != null && (c.recordtypeid == vCaseRT.Value__c ||c.recordtypeid == vCaseRT_Close.value__c))
                {
                    conCaseLst.add(c);
                    conIds.add(c.contactId);
                }
            }
            //system.debug('connotnull'+conCaseLst);
            //when account was null and if we give the contact value on case then along with account entitlement should be populated
            if(conIds.size() > 0) AssignEntlmnttmailtoConCase(conIds,conCaseLst);
            
            if(caseLst.size() > 0){
              for (Case c: caseLst){
                  if (c.AccountId != null){
                      vAcctIds.add(c.AccountId);
                  }
              }
              if(vAcctIds.size() > 0)  AssignEntlmnttmailtoCase(vAcctIds,caseLst);
              
           }
       }
       catch(Exception e){
      System.debug('Exception in AssignEntlmnttmailtoupdateCase method'+e);
      }
    }
    public void AssignEntltoCaseonInsert(List<Case> pCsLst){
        try
        {
            System.debug('STEp 00001');
            System.debug('pCsLst ==> '+ pCsLst);
            for (Case c: pCsLst){
              System.debug('c.EntitlementId  ==> ' + c.EntitlementId + '--------- '+ c.recordtypeid + '----------' + vCaseRT.Value__c);
              if (c.EntitlementId == null && (c.recordtypeid != null && c.recordtypeid == vCaseRT.Value__c)){
                 System.debug('c.AccountId ==> '+c.AccountId);
                 vAcctIds.add(c.AccountId);
              }
              /*if (c.EntitlementId == null && c.AccountId == null && c.contactid==null 
                  && c.recordtypeid == vCaseRT.Value__c && c.Internal_Contact__c!=null)
              {
                  vCsLsttoAssignInternalContact.add(c);
              }*/
               if(c.contactId!=null && c.accountId==null && (c.recordtypeid != null && c.recordtypeid == vCaseRT.Value__c))
                {
                    
                    conIds.add(c.contactId);
                }
              
              
              if(c.EntitlementId == null) vCsLsttoAssignEntl.add(c);
          }
           if(vAcctIds.size()>0)     AssignEntlmnttmailtoCase(vAcctIds,vCsLsttoAssignEntl);
           if(conIds.size() > 0) AssignEntlmnttmailtoConCase(conIds,vCsLsttoAssignEntl); 
           //if(!vCsLsttoAssignInternalContact.isEmpty())AssignInternalEntlmnttmailtoCase(vCsLsttoAssignInternalContact);
       }
       catch(Exception e){
      System.debug('Exception in AssignEntltoCaseonInsert method'+e);
      }
                  System.debug('STEp 00002');
    }
    public void AssignEntlmnttmailtoCase(Set<Id> pAcctIds,List<Case> pCsLst){
      /*for (Case c: pCsLst){
          if (c.EntitlementId == null && (c.recordtypeid != null && c.recordtypeid == vCaseRT.Value__c)){
             vConIds.add(c.ContactId);
          }
      }
       //Create a map with ContactID as a key and Contact as a value
       Map<Id,Contact> vMapCon = new Map<Id,Contact>([Select id,Accountid from Contact where id in:vConIds]);
       for(Contact cnt : vMapCon.values()){
           //Create set of a account id
           vAcctLst.add(cnt.accountid);
       }*/
       try
       {
            System.debug('List <Entitlement> vlistEntl '+pAcctIds);
           if(pAcctIds.size()>0){
              List <Entitlement> vlistEntl = [Select e.StartDate, e.Id, e.Status, e.EndDate, e.AccountId
                                             From Entitlement e
                                             Where e.AccountId in: pAcctIds AND e.Status = 'Active'];
              
               if(vlistEntl.size() > 0){
                   for(Entitlement e : vlistEntl ){
                       if(e.AccountId != null)
                       vMapAccIdtoEntment.put(e.AccountId,e);
                   }
               } 
               
               if(vlistEntl.size() > 0){
                    for(Case c: pCsLst){
                       //if(c.EntitlementId == null){
                           //Assign Entitlement to case if it is not assigned bydeafult
                           if(vMapAccIdtoEntment.get(c.AccountId) != null){
                               c.EntitlementId = vMapAccIdtoEntment.get(c.AccountId).Id;
                           }
                       //}
                    } 
                 }
           }
       }
       catch(Exception e){
      System.debug('Exception in AssignEntlmnttmailtoCase method'+e);
      } 
    }
    //Assign contact,account and entitlement if internal contact have value
   /* public void AssignInternalEntlmnttmailtoCase(List<case> cases)
    {
         Map<String,Apex_Helper_Settings__c> vMapNametoApexHlprSetting = Apex_Helper_Settings__c.getAll();
         try
         {
             for(case c:cases)
             {
                 c.AccountId = vMapNametoApexHlprSetting.get('Customer Care Account').Value__c;
                 c.ContactId = vMapNametoApexHlprSetting.get('Customer Care Contact').Value__c;
                 c.EntitlementId = vMapNametoApexHlprSetting.get('Internal Contact Entitlement').Value__c;  
              }
          }
          catch(Exception e){
      System.debug('Exception in AssignInternalEntlmnttmailtoCase method'+e);
      }   
    }*/
               
    public void AssignEntlmnttmailtoConCase(set<Id> conIds,List<case> cases)
    {
        map<Id,Id> map_conId_accId = new map<Id,Id>();
        set<Id> acIds=new set<Id>();
        try
        {
            for(contact c:[select Id,accountId from contact where Id in:conIds]){
                map_conId_accId.put(c.Id,c.accountId);
                acIds.add(c.accountId);
              
            }
            system.debug('------------------'+acIds);
             if(acIds.size()>0){
             System.debug('List <Entitlement> vlistEntl '+acIds);
              List <Entitlement> vlistEntl = [Select e.StartDate, e.Id, e.Status, e.EndDate, e.AccountId
                                             From Entitlement e
                                             Where e.AccountId in: acIds AND e.Status ='Active'];
              
               if(vlistEntl.size() > 0){
                   for(Entitlement e : vlistEntl ){
                       if(e.AccountId != null)
                       vMapAccIdtoEntment.put(e.AccountId,e);
                   }
               } 
               
               if(vlistEntl.size() > 0){
                    for(Case c: cases){
                           //Assign Entitlement to case if it is not assigned bydeafult
                           if(vMapAccIdtoEntment.get(map_conId_accId.get(c.contactId)) != null){
                               c.EntitlementId = vMapAccIdtoEntment.get(map_conId_accId.get(c.contactId)).Id;
                           }
                       
                    } 
                 }
             }
        }
       catch(Exception e){
      CCP_Exception_Util.CCP_Exception_Mail(e);
      }
   }
}