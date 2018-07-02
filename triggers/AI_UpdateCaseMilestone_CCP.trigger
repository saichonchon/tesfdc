/**********************************************************************************************************************************************
*******
Name: AI_UpdateCaseMilestone_CCP 
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This trigger updates the CaseMilestone as completed when User sends mail from SFDC
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE          DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Abhijeet Manepatil   15/10/2013    Trigger                       
***********************************************************************************************************************************************
*****/
trigger AI_UpdateCaseMilestone_CCP on EmailMessage (after insert) {
/***************  Variable declaration ***************/
    public Map<String, Customer_Care_SharedEmailBox__c> vCustCareEmailBoxMapAll = Customer_Care_SharedEmailBox__c.getAll();
    public Map<String, Customer_Care_SharedEmailBox__c> vCustCareEmailBoxMap = new  Map<String, Customer_Care_SharedEmailBox__c>();
    public List<EmailMessage> pEMLst = new List<EmailMessage>();
    public Map<Id,Case> vMapCs;
    public Set<Id> vSetCsId = new Set<Id>();
    public Set<Id> vSetCsOwnerId = new Set<Id>();
    public Set<String> vUserEmailSet = new Set<String>();
    
    //CustCareClass_TE cuscare = new CustCareClass_TE ();
    //cuscare.custcaremethod();
    
    //Create a map of Customer_Care_SharedEmailBox__c 
    for(Customer_Care_SharedEmailBox__c ccs : vCustCareEmailBoxMapAll.values()){
     vCustCareEmailBoxMap.put(ccs.Name.toLowerCase(),ccs);
    }
    //Create list of emails excluding auto response
    for(EmailMessage em : trigger.new){
        if(em.FromAddress != 'customersupport@te.com'){
            vSetCsID.add(em.parentID);
            pEMLst.add(em);
        }
    }
    if(vSetCsID.size() > 0){
        //Create a map of case
        vMapCs = new Map<Id,Case>([Select id,Subject,Case_Re_Open_Reason__c ,Email_Subject__c,Email_CCAddress__c ,Email_ToAddress__c,businesshoursid,createddate,OwnerID,SuppliedEmail,isClosed,status,recordtypeid,contactid,
        Count_Incoming_Emails__c,Count_Outgoing_Emails__c,First_Response_is_Final_Response__c,Email_SentDate__c,Email_FromAddress__c,Quick_Email__c from Case where id in: vSetCsId]); 
        //Create set of case ownerids if Owner is user not queue
        for(Case cs : vMapCs.values()){
            String tOwner = cs.OwnerID;
            if(tOwner.startsWith('005'))
            vSetCsOwnerId.add(cs.ownerId);
        }
        //Create set of user email ids
        for(User u : [Select id,email from User where id in: vSetCsOwnerId]){
            vUserEmailSet.add(u.email); 
        }
    }
   
     if(CaseUtil_CCP.UpdateCasewithEmailDatails == false){
           CaseUtil_CCP.UpdateCasewithEmailDatails = true;
           Get_Email_DetailsonCase vGEDC = new Get_Email_DetailsonCase(); //This method updates the address fields on Case
           vGEDC.EmailDetails(pEMLst,vMapCs,vUserEmailSet,vCustCareEmailBoxMap);
       }
     
     if(CaseUtil_CCP.Countoncaseboolean==false){
         CaseUtil_CCP.Countoncaseboolean=true;
        CountEmailsonCase vCEC = new CountEmailsonCase(); //This method checks if email is inbound or sent through outlook and if contact with entitlement exist or not, if yes then update case with contact and respective account
        vCEC.CountEmailsMethod(pEMLst,vMapCs,vUserEmailSet,vCustCareEmailBoxMap);
        //Call this method to check if contact with entitlement exist or not.
        //CountEmailsonCase vCEC1 = new CountEmailsonCase();
        //vCEC1.Check_ContactHasEntitlement(pEMLst,vMapCs,vUserEmailSet,vCustCareEmailBoxMap);
    
    }
    if(trigger.isafter&& CaseUtil_CCP.EmailMsgboolean == false)
        {
        CaseUtil_CCP.EmailMsgboolean = true;
        CompleteMilestone_CCP vCMCCP = new CompleteMilestone_CCP(); //This method updates the Case Milestone as completed
        vCMCCP.MarkMilestoneasCompleted(pEMLst,vMapCs,vUserEmailSet,vCustCareEmailBoxMap);
        }
}