/**********************************************************************************************************************************************
*******
Name: Get_Email_DetailsonCase
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This class stores the Email details on case.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE          DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Abhijeet Manepatil   15/01/2014    Class                       
***********************************************************************************************************************************************
*****/
public class Get_Email_DetailsonCase{
    public Set<Id> Csid = new set<id>();
    //public List<Case> vCsUpLst = new List<Case>();
    Map<Id,Case> updateCaseMap = new Map<Id,Case>();
    //public Map<String,Customer_Care_Bounced_Emails__c> vOOFSubMap = Customer_Care_Bounced_Emails__c.getAll();
       
    public Map<Id,Case> EmailDetails(List<EmailMessage> pEMLst,Map<Id,Case> vMapCs ,Set<String> vUserEmailSet,Map<String, Customer_Care_SharedEmailBox__c> vCustCareEmailBoxMap){
        try{   
        for(EmailMessage em : pEMLst){
            if(em.Incoming == true){
                if(em.subject!=null)
                vMapCs.get(em.parentId).Email_Subject__c = em.subject.replaceAll('&',' ');
                //vMapCs.get(em.parentId).Email_Body__c = '----Original Message-----'+em.textbody;
                if(vUserEmailSet.contains(em.FromAddress) || vCustCareEmailBoxMap.containsKey(em.FromAddress.toLowerCase())){
                    vMapCs.get(em.parentId).Email_ToAddress__c = em.ToAddress+';';
                    if(em.FromAddress!=null)
                    vMapCs.get(em.parentId).Email_FromAddress__c = em.FromAddress.replaceAll(';\n',';');
                }else{
                    vMapCs.get(em.parentId).Email_ToAddress__c = em.FromAddress+';';
                    if(em.ToAddress!=null)
                    vMapCs.get(em.parentId).Email_FromAddress__c = em.ToAddress.replaceAll(';\n',';');
                
                }
                if(em.CCAddress != null){
                vMapCs.get(em.parentId).Email_CCAddress__c = em.CCAddress+';';
                }
                else{
                vMapCs.get(em.parentId).Email_CCAddress__c = '';
                }
                vMapCs.get(em.parentId).Email_SentDate__c=em.messageDate;
                updateCaseMap.put(em.parentId,vMapCs.get(em.parentId));
                //vCsUpLst.add(vMapCs.get(em.parentId));
            }
            
        }
        //if(! vCsUpLst.isEmpty()) update vCsUpLst;
       // if(!updateCaseMap.isEmpty()) update updateCaseMap.values(); commented 26-11
       return updateCaseMap;
        }catch(Exception e){
            CCP_Exception_Util.CCP_Exception_Mail(e);
            return null;
        }
    }
}