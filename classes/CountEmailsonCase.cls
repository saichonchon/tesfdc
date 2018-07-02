/**********************************************************************************************************************************************
*******
Name: CountEmailsonCase
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This class counts Incming and outgoing mails on a case.
        This class is called by AI_UpdateCaseMilestone_CCP trigger on EmailMessage object.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE          DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Abhijeet Manepatil   18/10/2013    Class
 1.1   Narasimha Narra       9/5/2014              
***********************************************************************************************************************************************
*****/
public class CountEmailsonCase{
    public List<Case> vCsLst;
    public Map<Id,Contact> vMapCon;
    //public List<Case> vCsUpdatedSet;
    Map<Id,Case> updateCaseMap;
    public Set<Id> vSetCsId;
    public Set<String> vSetEmToAddrs;
    public Map<String,Case> vMapConEmailtoCase;
    public Map<Id,Case> vMapCs;
    map<Id,List<string>> mapcid_email = new map<Id,List<string>>();
    Apex_Helper_Settings__c vCaseRT = Apex_Helper_Settings__c.getInstance('Customer Care Cloud');
    Apex_Helper_Settings__c vAutoRsp = Apex_Helper_Settings__c.getInstance('Customer Support');
    // public Map<String,Customer_Care_Bounced_Emails__c> vOOFSubMap = Customer_Care_Bounced_Emails__c.getAll();
    
    public CountEmailsonCase(){
        vCsLst = new List<Case>();
        //vCsUpdatedSet = new List<Case>();
        updateCaseMap = new Map<Id,Case>();
        vSetCsId= new Set<Id>();
        vSetEmToAddrs = new Set<String>();
        vMapConEmailtocase = new Map<String,Case>();
        }//End of controller
        
        public Map<Id,Case> CountEmailsMethod(List<EmailMessage> pEMLst,Map<Id,Case> vMapCs ,Set<String> vUserEmailSet,Map<String, Customer_Care_SharedEmailBox__c> vCustCareEmailBoxMap){
        Set<String> vEMFromAddSet = new Set<String>();
        Map<String,Contact> vConMap = new Map<String,Contact>();
        Apex_Helper_Settings__c CustomerCarecon = Apex_Helper_Settings__c.getInstance('Customer Care Contact');
        try{
            //Create a map of case ids to email ToAddress
            for(EmailMessage em:pEMLst)
            {
                vEMFromAddSet.add(em.fromaddress);
                if(!mapcid_email.containsKey(em.parentId)){
                mapcid_email.put(em.parentId,new List<string>{em.toAddress});
                }
                else
                {
                mapcid_email.get(em.parentId).add(em.toAddress);
                }
            }
            
            if(!vEMFromAddSet.isEmpty()){
                for(Contact cn : [Select id,Contact_Has_Entitlement__c,email from Contact cn where cn.email in: vEMFromAddSet and cn.Contact_Has_Entitlement__c =: true]){
                    vConMap.put(cn.email,cn);
                }
            
            }
            for(EmailMessage em : pEMLst){
                if(em.Incoming == true && em.Status != 'Sent'){
                System.debug('***inside Count Emails, IF ***');
                    if(mapcid_email.containskey(em.parentId)&& (vMapCs.get(em.parentId).Count_Incoming_Emails__c <= 0)){
                    System.debug('***inside Count Emails, IF 2 ***');
                        if(vMapCs.get(em.parentId).isClosed == false ){
                             System.debug('***inside Count Emails, IF 3 ***');
                            if(vMapCs.get(em.parentId).SuppliedEmail != null ){
                            vMapCs.get(em.parentId).Status ='In Progress';
                        
                            }
                        else if(vMapCs.get(em.parentId).SuppliedEmail == null && (!(vUserEmailSet.contains(em.FromAddress) || vCustCareEmailBoxMap.containsKey(em.FromAddress.toLowerCase())))){
                        vMapCs.get(em.parentId).Status ='New Response Received';
                        }
                        else{
                        //  vMapCs.get(em.parentId).Status ='New Response Received';
                        }
                        /*   if(vOOFSubMap.size() > 0  && (vMapCs.get(em.parentId).Status != 'Closed (No Action)')){
                        for(String oof : vOOFSubMap.keyset()){
                        if(vMapCs.get(em.parentId).subject!= null && (vMapCs.get(em.parentId).subject).toLowerCase().contains(oof.toLowerCase())){
                        if(vMapCs.get(em.parentId).suppliedemail != null) {
                        vMapCs.get(em.parentId).Bounced_Emails__c = true;
                        vMapCs.get(em.parentId).Status = 'Closed (No Action)';
                        }
                        }    
                        
                        }
                        }*/
                        }
                        if(vUserEmailSet.contains(em.FromAddress)|| vCustCareEmailBoxMap.containsKey(em.FromAddress.toLowerCase())){
                            System.debug('***inside Count Emails, IF 4 ***');
                            vMapCs.get(em.parentId).Count_Outgoing_Emails__c= vMapCs.get(em.parentId).Count_Outgoing_Emails__c + 1;
                            //vCsUpdatedSet.add(vMapCs.get(em.parentId));
                            updateCaseMap.put(em.parentId,vMapCs.get(em.parentId));
                        }else{
                        System.debug('***inside Count Emails, IF 5 ***');
                        vMapCs.get(em.parentId).Count_Incoming_Emails__c=1;
                        //vCsUpdatedSet.add(vMapCs.get(em.parentId));
                        updateCaseMap.put(em.parentId,vMapCs.get(em.parentId));
                        }
                        
                    }
                    else{
                        //Check if email is sent by CCP through outlook.
                            if(vUserEmailSet.contains(em.FromAddress) || vCustCareEmailBoxMap.containsKey(em.FromAddress.toLowerCase())){
                                if(vMapCs.get(em.parentId).Count_Outgoing_Emails__c == 1){
                                    vMapCs.get(em.parentId).First_Response_is_Final_Response__c = false;
                                }   
                            vMapCs.get(em.parentId).Count_Outgoing_Emails__c= vMapCs.get(em.parentId).Count_Outgoing_Emails__c + 1;
                        }else{
                        if(vMapCs.get(em.parentId).isClosed == false){
                        vMapCs.get(em.parentId).Status ='New Response Received';
                        }
                        vMapCs.get(em.parentId).Count_Incoming_Emails__c=vMapCs.get(em.parentId).Count_Incoming_Emails__c+1;
                        }
                        //vCsUpdatedSet.add(vMapCs.get(em.parentId));
                        
                        updateCaseMap.put(em.parentId,vMapCs.get(em.parentId));
                        
                    }
                }else{
                 System.debug('***inside Count Emails, ELSE ***');
                    if(em.FromAddress != vAutoRsp.Value__c ){
                     System.debug('***inside Count Emails , From address condition ***');
                        if(vMapCs.get(em.parentId).Count_Outgoing_Emails__c == 1){
                         System.debug('***inside Count Emails 1 ***');
                            vMapCs.get(em.parentId).First_Response_is_Final_Response__c = false;
                            vMapCs.get(em.parentId).Count_Outgoing_Emails__c= vMapCs.get(em.parentId).Count_Outgoing_Emails__c+ 1;
                            //vCsUpdatedSet.add(vMapCs.get(em.parentId));
                            updateCaseMap.put(em.parentId,vMapCs.get(em.parentId));
                            System.debug('***inside Count Emails updateCaseMap ***'+updateCaseMap);
                        }
                        else{
                             System.debug('***inside Count Emails 2 ***');
                            vMapCs.get(em.parentId).Count_Outgoing_Emails__c= vMapCs.get(em.parentId).Count_Outgoing_Emails__c + 1;
                            //vCsUpdatedSet.add(vMapCs.get(em.parentId));
                            updateCaseMap.put(em.parentId,vMapCs.get(em.parentId));
                              System.debug('***inside Count Emails updateCaseMap ***'+updateCaseMap);
                        }
                    }
                }
                //Check if email message is inbound and first email or not and if contact with entitlement exist or not
                if(em.Incoming == true && (vMapCs.get(em.parentId).Count_Incoming_Emails__c <= 1) && vMapCs.get(em.parentId).contactid==null && vConMap.containsKey(em.fromaddress)&&(!(vUserEmailSet.contains(em.FromAddress)|| vCustCareEmailBoxMap.containsKey(em.FromAddress.toLowerCase())))){
                    system.debug('---------enter3'+vMapCs.get(em.parentId).Count_Incoming_Emails__c);
                    System.debug('*** inside Count Email, else if ***');
                    vMapCs.get(em.parentId).contactid = vConMap.get(em.FromAddress).id;
                    //vCsConLst.add(vMapCs.get(em.parentId));
                    updateCaseMap.put(em.parentId,vMapCs.get(em.parentId));
                }else if(em.Incoming == true && vMapCs.get(em.parentId).contactid != CustomerCarecon.value__c && (!(vConMap.containsKey(em.fromaddress))) && (vMapCs.get(em.parentId).Count_Incoming_Emails__c <= 1) && (!(vUserEmailSet.contains(em.FromAddress) || vCustCareEmailBoxMap.containsKey(em.FromAddress.toLowerCase())))){
                //Else set account and contact to null.
                    System.debug('*** inside Count Email, else if ***');
                    vMapCs.get(em.parentId).contactid = null;
                    vMapCs.get(em.parentId).accountid = null;
                    //vCsConLst.add(vMapCs.get(em.parentId));
                    updateCaseMap.put(em.parentId,vMapCs.get(em.parentId));
                }else{
                }
            }
            
            //if(! vCsUpdatedSet.isEmpty())  update vCsUpdatedSet;
            // if(!updateCaseMap.isEmpty()) Update updateCaseMap.values(); Commented on 27-11-14
            return updateCaseMap;                     
        }
        catch(Exception e){
            CCP_Exception_Util.CCP_Exception_Mail(e);
           return null;
        }  
    }// End of CountEmailsMethod method.
    
}