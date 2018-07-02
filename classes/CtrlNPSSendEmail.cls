/** 
*    Controller for CtrlTakeSurvey page
*
@author Xia Tong
@created 2012-12-11 
@version 1.0
@since 23.0 (Force.com ApiVersion)
*
@changelog
* 2012-12-11 Xia Tong <xia.tong@itbconsult.com>
* - Created
*/
public with sharing class CtrlNPSSendEmail {
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public list<id> list_recipients{get;set;}
    public boolean isError{get;set;}
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private map<string,string> map_parameters;
    private Id campaignId;
    private set<Id> set_resipent;
    private Campaign cam;
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    /** 
    *    Constructor
    *
    @author Xia Tong
    @created 2012-12-11 
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @changelog
    * 2012-12-11 Xia Tong <xia.tong@itbconsult.com>
    * - Created
    */
    public CtrlNPSSendEmail(){
        list_recipients = new list<Id>();
        map_parameters = new map<string,string>();
        map_parameters = Apexpages.currentPage().getParameters();
        isError = false;
        
        if(map_parameters.containsKey('Id')){
            campaignId= (id)map_parameters.get('Id');
            cam = [select id,Notification_Sent__c,Survey__c, Campaign_Members_Report_Link__c,Campaign_Members_Report_Link_txt_c__c from Campaign where id =: campaignId];
            if(cam.Notification_Sent__c){
                isError = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, system.label.NPS_Notification_Sent));
               
            }
        }

        
    }
    public pageReference send(){
        String Pre_Url_Org = URL.getSalesforceBaseUrl().toExternalForm();
        if(Pre_Url_Org.contains('-api')){
            Pre_Url_Org = Pre_Url_Org.replace('-api',''); 
        }
        //User u = [select id,Email from user where id =: userInfo.getUserId()];
        list<Messaging.SingleEmailMessage> mails = new list<Messaging.SingleEmailMessage>();
        set<Id> set_amId = new set<Id>();
        if(!isError){
           for(CampaignMember cm: [SELECT id,ContactId,Contact.Account.Account_Manager__c,Contact.Account.Account_Manager__r.Name,Contact.Account.owner.Email FROM CampaignMember where campaignId=: campaignId]){
               if(cm.Contact.Account.Account_Manager__c != null && !set_amId.contains(cm.Contact.Account.Account_Manager__c)){
                    set_amId.add(cm.Contact.Account.Account_Manager__c); 
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setTargetObjectId(cm.Contact.Account.Account_Manager__c);
                    mail.setToAddresses(new String[]{'xia.tong@itbconsult.com'});//for test
                    mail.setSubject(system.label.NPS_Account_Manager_Notification_Subject);
                    mail.setHtmlBody('<p>'+system.label.NPS_Account_Manager_Notification_Solutation +' ' + cm.Contact.Account.Account_Manager__r.Name + ',' + '</p>'
                                   + '<p>'+ system.label.NPS_Account_Manager_Notification_Body+': '
                                   + '<a href=\"' + Pre_Url_Org +'/'+ cam.Campaign_Members_Report_Link_txt_c__c +'\">Report Link</a></p>');
                    mail.setReplyTo(cm.Contact.Account.owner.Email);
                    
                    mail.setSaveAsActivity(false);
                    mails.add(mail);    
               }
           }
           
           if(!test.isRunningTest()){
           	Messaging.sendEmail(mails);
           }
           cam.Notification_sent__c = true;
           update cam;
        
           pageReference  page = new pageReference('/' + campaignId);
           page.setRedirect(true);
           return page;
           
        
        }    
        return null;
       
    }
    

    
    public pageReference cancel(){
        
        pageReference  page = new pageReference('/' + campaignId);
        page.setRedirect(true);
        return page;
    
    }
   
     
    
}