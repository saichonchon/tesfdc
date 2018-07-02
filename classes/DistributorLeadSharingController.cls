/***********************************************************************************************************************
Name: DistributorLeadSharingController  
Copyright © 2014 TE Connectivity | Salesforce Instance : C2S
========================================================================================================================
Purpose: Controller for sharing the leads with distributor User                                                 
========================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR            DATE               DETAIL                                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------
1.0    Toshi            01/24/2013     Initial Development                                         
***********************************************************************************************************************/   
public with sharing class DistributorLeadSharingController {
    public Id Lead_id{get;set;}
    public List<wrapperUser> wrapconlist{get;set;}
    public String UserName{get; set;}
    Public Boolean pgShow{get; set;}
    Public List<User> selectedUser{get; set;}
    Public String userProfileId{get; set;}
    public String selectedId = '';
    public Lead leadrec {get; set;} 
    public List<LeadShare> leadshareList = new List<LeadShare>();
    
   
    public DistributorLeadSharingController(ApexPages.StandardController controller) {
        Lead_id= Apexpages.currentPage().getParameters().get('id');
        this.leadrec = (Lead)controller.getRecord();
        pgShow= false;

        GetPartnerAccountPartnerUsers();
        
    }
    
    public String getselectedId() {
        return selectedId;
    }
    public void setselectedId(String slcsid) {  selectedId = slcsid; }
    // This method is used to search for the distributor user
    Public Pagereference searchUser(){
        pgShow = True;
        Community_Config__c portalProfileIds = Community_Config__c.getInstance('Distributor Profile Id');
        List<String> pSet = portalProfileIds.Value__c.Split(',');
        
        String lstatus = Apexpages.currentPage().getParameters().get('leadststus');
        String soql = 'select id, name, FirstName, LastName, email , ProfileId from User where ProfileId IN:pSet AND ('+' Firstname LIKE \''+String.escapeSingleQuotes(UserName)+'%\' OR '+' LastName LIKE \''+String.escapeSingleQuotes(UserName)+'%\') ';
        List<User> listUser = Database.query(soql);
        wrapconlist = new List<wrapperUser>();
        for(User u : listUser){
            wrapconlist.add(new wrapperUser(u, false)); 
        }
       return null;
    }
    
    // This method is used to get all distributor user
    Public void GetPartnerAccountPartnerUsers(){
        pgShow = True;
        Community_Config__c portalProfileIds = Community_Config__c.getInstance('Distributor Profile Id');
        String distributorAccountId = Community_Config__c.getInstance('Distributor Partner Account Id').Value__c;
        List<String> pSet = portalProfileIds.Value__c.Split(',');
        
        String lstatus = Apexpages.currentPage().getParameters().get('leadststus');
        String soql = 'select id, name, FirstName, LastName, email , ProfileId from User where AccountId =: distributorAccountId and ProfileId IN:pSet';
            //AND ('+' Firstname LIKE \''+String.escapeSingleQuotes(UserName)+'%\' OR '+' LastName LIKE \''+String.escapeSingleQuotes(UserName)+'%\') ';
        List<User> listUser = Database.query(soql);
        wrapconlist = new List<wrapperUser>();
        for(User u : listUser){
            wrapconlist.add(new wrapperUser(u, false)); 
        }
       //return null;
    }
    
    // this method is used to share the lead record with DU and to send the email to DU.
    Public PageReference onProceed(){
        pgShow = true;
       /* map<String,Community_Config__c> commMap = Community_Config__c.getall();
         String commntyUrl = commMap.get('Community Url').Value__c;
         System.debug('******commntyUrl ******'+commntyUrl);*/
        Community_Config__c comUrl = Community_Config__c.getInstance('Community Url');
                 System.debug('******comUrl ******'+comUrl);

        Community_Config__c comDLTabId = Community_Config__c.getInstance('Distributor Lead Tab Id');
                 System.debug('******comDLTabId ******'+comDLTabId );

        Community_Config__c fromAdress = Community_Config__c.getInstance('From Address');
                 System.debug('******fromAdress ******'+fromAdress);

      /*  Community_Config__c templateId= Community_Config__c.getInstance('TemplateId');
        EmailTemplate et = [SELECT id,HtmlValue,Subject  FROM EmailTemplate WHERE Id =:templateId.Value__c];*/


        list<Messaging.SingleEmailMessage> lstmail = new list<Messaging.SingleEmailMessage>();
        Messaging.Email[] allEmails = new List<Messaging.Email>(); 
        if(wrapconlist!=null && wrapconlist.size()>0){
            selectedUser = new List<User>();
            String fromaddress = 'teAdmin@te.com';
            String SubjectString = 'TE Connectivity Lead for Actioning: A lead from contact '+ leadrec.name +' has been referred to you';
            
            for(wrapperUser wUser: wrapconlist){
                if(wUser.userObj.id == selectedId){
                    selectedUser.add(wUser.userObj);
                    // Insert Lead share Object for selected User.
                    LeadShare lshare = new LeadShare();
                    lshare.LeadId = Lead_id;
                    lshare.UserOrGroupId = wUser.userObj.id; 
                    lshare.LeadAccessLevel ='Edit';
                    leadshareList.add(lshare);
                        
                   // Send Email to Selected User
                  /*  Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setSenderDisplayName(fromAdress.Value__c );
                    mail.setTargetObjectId(wUser.userObj.id);
                    mail.setSaveAsActivity(false);
                    mail.setSubject(SubjectString);
                    mail.setUseSignature(false);
                   // mail.setTemplateId(et.id);
                    String serverName = comUrl.Value__c + '/apex/DistributorLeadDetailView?ID=' + Lead_id;
                    String msgBody;
                    msgBody = + '<html> A Lead from ' + leadrec.name +' of company '+ leadrec.company + 'has been referred to you from TE. Please follow up on the Lead and advice on your TE SFDC link whether Lead can be converted to an opportunity or is dead. The following are the details about lead –' +'<br/><br/>'+' Contact Name - '+ leadrec.name + '<br/> '+' Contact Company - '+ leadrec.company + '<br/>' +' Contact Email - '+ leadrec.Email + '<br/>' +'Contact Phone - '+ leadrec.phone + '<br/>' +'Contact City - '+ leadrec.city+ '<br/>' +'Contact Country - '+ leadrec.country + '<br/>' +'Contact Zip code/Postcode - '+ leadrec.PostalCode + '<br/> <br/>' +' TE SFDC Link – <a href='+serverName +'>Link to Lead Record</a>.</p><br/>Regards,<br/>System Administrator</html>';                                           
                    //msgBody = + '<html> Dear ' + wUser.userObj.name + '<br/><br/><p> New Lead ' + leadrec.name + ' has been assigned to you for review. Please review the Lead and update the Distributor Response. Please login to Salesforce.com to update Lead <a href='+serverName +'>Link to Lead Record</a>.</p><br/>Regards,<br/>System Administrator</html>';  
                    mail.setHtmlBody(msgBody);
                    lstmail.add(mail); */
                    
                }
            }
           
           
        }
       /* if(!lstmail.isEmpty()){
            if(!Test.isRunningTest()){
                Messaging.SendEmail(lstmail);
           }
        } */
        
        if(leadshareList!=null && leadshareList.Size()>0){
            //if(!Test.isRunningTest()){ 
            //try{
            
                //if the "‘Distributor Response’" is None default it to "No feedback received". Existing leads will have None.
                
                if (this.leadrec.Distributor_Response__c == '')
                {
                    this.leadrec.Distributor_Response__c = 'No feedback received';
                    Update this.leadrec;
                }
                
                insert leadshareList;
                
                
                
            //    }
           //     Catch(Exception e){
            //    System.debug('*****'+e);
            //   }
           //}
        }
        PageReference pageRef = new PageReference('/'+Lead_id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    Public PageReference onLinkClick(){
    PageReference pageRef = new PageReference('/'+Lead_id);
        pageRef.setRedirect(true);
        return pageRef;
    
    }
    // Wrapper class is used to bind the value of each radio button with User record
    public class wrapperUser{
        public User userObj{get;set;}
        public Boolean selected{get;set;} 
        public wrapperUser(User u, Boolean b){
            this.userObj = u;
            this.selected = b;
        } 
    }
}