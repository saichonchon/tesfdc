/**
*   This class will collect all functions about routing lead
*
* @author      min liu 
* @created     2012-11-05
* @since       23.0    
* @version     1.0                                                                 
* 
* @changelog
* 2016-12-08: Mahesh Babu <mahesh.babu@te.com>
* - Added Lead routing logic for CLR Req-02
* 2015-06-04: Phil Hiemstra <phil.hiemstra@te.com>
* - Updated Network ID comparisons to be done in lower case
* - Updated code to exclude certain user profiles based on settings
* 2015-04-08: Phil Hiemstra <phil.hiemstra@te.com>
* - modified logic to clear the sendTo array for every lead and to send 2nd notification only when the lead is assigned
* 2015-04-01: Phil Hiemstra <phil.hiemstra@te.com>
* - added logic for Assignee Network ID.  If it contains an active user, the lead will be assigned to them
* 2014-06-19 Lili Zhao <lili.zhao@itbconsult.com>
* - modify the set the lead the owner as the default User of FE_Hiearchy__c if it is not null
* 2012-11-05 min liu <min.liu@itbconsult.com>
* - Created
*    
*/ 
global class ClsRouteLeadUtil {
    
    /**
*   This method is used to route leads
*
* @author      juillet yuan 
* @created     2015-02-04
* @since       31.0   
* @version     1.0                                                                 
* 
* @changelog
* 2012-11-05 juillet yuan <juillet.yuan@itbconsult.com>
* - Created
*    
*/
    public static void routeLead_new(List<Lead> list_lead){
        // Capture the lead routing settings
        Set<Id> set_excludedProfilesNetworkID = new Set<Id>();
        Set<Id> set_excludedProfilesExistingEmail = new Set<Id>();
        List<Lead_Routing_Settings__c> leadRoutingSettings = Lead_Routing_Settings__c.getAll().values();
        
        for (Lead_Routing_Settings__c lrs: leadRoutingSettings){
            try{
                if (lrs.Exclude_Network_ID_Assignment__c) { set_excludedProfilesNetworkID.add(lrs.Profile_Id__c);}
                if (lrs.Exclude_Existing_Email_Assignment__c) { set_excludedProfilesExistingEmail.add(lrs.Profile_Id__c);}
            }catch (Exception e) // Catch any Record Type ID errors
            {
                System.debug('Lead Routing Settings error: ' + e.getMessage());
            }
        }
        //Start : Added by Mahesh for Lead Routing project phase 2 Req 2 - https://tecentral.my.salesforce.com/a0R1600000b4l34 
        List<Lead> list_lead3Route = new List<Lead>();
        //END : Added by Mahesh for Lead Routing project phase 2 Req 2 - https://tecentral.my.salesforce.com/a0R1600000b4l34 
        List<Lead> list_lead2Route = new List<Lead>();
        Set<String> set_teNetworkId = new Set<String>();
        Map<String, List<Lead>> map_teNetworkId_leads = new Map<String, List<Lead>>();
        list<Lead> list_leadwithoutNetwork = new list<Lead>();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        
        //Id EloquaIntegrationUserId = '005E0000006AaBUIA0'; //TODO Make this a label/setting
        String currentUserName = UserInfo.getName() != null ? UserInfo.getName() : '';
       
        // get all the network ids of leads
        for(Lead l :list_lead){
            if(l.Assignee_Network_ID__c != null && currentUserName == 'Eloqua Integration User'){ // modified by Mahesh for CLR req-02
                String lowerNetworkId = l.Assignee_Network_ID__c.toLowerCase(); // 2015-06-04 Phil: Added to resolve case sensitivity issue
                set_teNetworkId.add(lowerNetworkId);
                if(!map_teNetworkId_leads.containsKey(lowerNetworkId)) map_teNetworkId_leads.put(lowerNetworkId, new List<Lead>());
                map_teNetworkId_leads.get(lowerNetworkId).add(l);
            }else{
                list_leadwithoutNetwork.add(l);
                system.debug('line 78 - ' + list_leadwithoutNetwork.size());
            }
        }
        
        // check if the network ids exist an active user
        for(User u :[select id, Te_Network_Id__c, email from User where IsActive = true and ProfileId NOT IN :set_excludedProfilesNetworkID and Te_Network_Id__c IN :set_teNetworkId]){ 
            String lowerUserNetworkId = u.Te_Network_Id__c.toLowerCase(); // 2015-06-04 Phil: Added to resolve case sensitivity issue
            if(map_teNetworkId_leads.containsKey(lowerUserNetworkId)){
                for(Lead l :map_teNetworkId_leads.get(lowerUserNetworkId)){
                    l.OwnerId = u.id; 
                    l.Onwer_Assigned__c = true;
                    l.Status = 'Assigned - Unaccepted';
                    sendTo.clear();
                    sendTo.add(u.email);
                    if(l.Owner_Assigned__c == 1 && l.TEMarketing__MQL_Date__c == null){ // Only sent the email the 2nd time through the trigger
                        
                        mail = new Messaging.SingleEmailMessage(); 
                        mail.setSubject('A new marketing qualified lead has been assigned to you: ' + l.FirstName + ' ' + l.LastName);
                        String leadURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + l.Id;
                        String body = 'Hello, <br/> <br/>';
                        body += 'A new marketing qualified lead has been assigned to you.<br/><br/>';
                        body += 'Company: ' + l.Company + '<br/>';       
                        body += 'Lead Name: ' + l.FirstName + ' ' + l.LastName + '<br/>';
                        body += 'Phone: ' + l.Phone + '<br/><br/>';
                        body += '*Click on the link to access the lead in Salesforce and retrieve contact information: ' + leadURL;
                        mail.setHtmlBody(body);                                       
                        mail.setToAddresses(sendTo);
                        
                        mails.add(mail); 
                        System.debug('***mails***'+mails); 
                    }
                }
                map_teNetworkId_leads.remove(lowerUserNetworkId);
            }
        }
        
        // get lead to route
        for(String teNetworkId :map_teNetworkId_leads.keySet()){
            for(Lead l :map_teNetworkId_leads.get(teNetworkId)){
                list_lead2Route.add(l);
            }
        }
        list_lead2Route.addAll(list_leadwithoutNetwork);
        system.debug('end of network Id');
        system.debug(list_lead2Route);
        
        //
        Map<String, List<Contact>> map_email_contacts = new Map<String, List<Contact>>();
        Set<Id> set_user = new Set<Id>();
        Map<Id, User> map_usId_user = new Map<Id, User>();
        
        
        // check contact by email address
        for(Lead l :list_lead2Route){
            if(l.email == null) l.Queue_Reason__c = system.label.Queue_Reason_No_Contact;
            else if(l.email != null && !map_email_contacts.containsKey(l.email)) map_email_contacts.put(l.email, new List<Contact>());
        }              
        
        if(!map_email_contacts.isEmpty()){
            for(Contact c :[select email, AccountId, Account.Account_Manager__c, Account.FE_Hierarchy__c, Account.FE_Hierarchy__r.Level_7_Default_Owner__c, ownerId, Account.Account_Manager__r.Email, Account.FE_Hierarchy__r.Level_7_Default_Owner__r.Email, owner.Email from Contact where email IN :map_email_contacts.keySet()]){                
                if(map_email_contacts.containsKey(c.email)) map_email_contacts.get(c.email).add(c);
                // add lili zhao 2014-06-19 due to modify the set the lead the owner as the default User of FE_Hiearchy__c 
                if(c.Account.FE_Hierarchy__c != null && c.Account.FE_Hierarchy__r.Level_7_Default_Owner__c != null) {
                    set_user.add(c.Account.FE_Hierarchy__r.Level_7_Default_Owner__c);
                }else {
                    // end
                    if(c.AccountId != null && c.Account.Account_Manager__c != null) set_user.add(c.Account.Account_Manager__c);
                }
                set_user.add(c.ownerId);
            }
        }       
        // get contact owner and account manager
        if(!set_user.isEmpty()){
            for(User u :[select id, name, email, Te_Network_Id__c, isActive from User where id IN :set_user and ProfileId NOT IN :set_excludedProfilesExistingEmail and isActive = true]){
                map_usId_user.put(u.id, u);
            }
        }
        
        // route lead
        for(Lead l :list_lead2Route){ 
           
            if(l.email != null && map_email_contacts.containsKey(l.email) && currentUserName == 'Eloqua Integration User'){ 
                system.debug(map_email_contacts.get(l.email).size()+'---'+map_email_contacts+'email not null has contact -->leadroutenew'+l.email+map_email_contacts.containsKey(l.email));
                sendTo.clear();  // 2015-04-08 Phil: Moved this out of the 'else' statement to be sure that the sendTo is cleared for every lead
                // start: modified by Mahesh for CLR Req-02
                //if(map_email_contacts.get(l.email).size() != 1) l.Queue_Reason__c = map_email_contacts.get(l.email).size() < 1 ? system.label.Queue_Reason_No_Contact : system.label.Queue_Reason_Du_Contact;
                if(map_email_contacts.get(l.email).size() != 1) {
                         list_lead3Route.add(l);    
                // end: modified by Mahesh for CLR Req-02      
                } else{ 
                    Contact c = map_email_contacts.get(l.email).get(0);
                    Boolean isProc = false; 
                    //l.Queue_Reason__c = null; 
                   system.debug('######map_usId_user'+map_usId_user+' c.Account.FE_Hierarchy__r.Level_7_Default_Owner__c '+c.Account.FE_Hierarchy__r.Level_7_Default_Owner__c);
                    if(map_usId_user.containsKey(c.Account.FE_Hierarchy__r.Level_7_Default_Owner__c)) {
                        User u = map_usId_user.get(c.Account.FE_Hierarchy__r.Level_7_Default_Owner__c);
                        l.OwnerId = c.Account.FE_Hierarchy__r.Level_7_Default_Owner__c;
                        l.Status = 'Assigned - Unaccepted';
                        isProc = true;
                        l.Onwer_Assigned__c = true;
                        sendTo.add(u.Email);
                        system.debug('hierarchy!');                        
                    }else if(map_usId_user.containsKey(c.Account.Account_Manager__c)){
                        User u = map_usId_user.get(c.Account.Account_Manager__c);
                        l.OwnerId = c.Account.Account_Manager__c;
                        l.Status = 'Assigned - Unaccepted';
                        isProc = true;
                        l.Onwer_Assigned__c = true;
                        sendTo.add(u.Email);
                        system.debug('Manager!');                        
                    } 
                    if(!isProc && map_usId_user.containsKey(c.ownerId)){
                        User u = map_usId_user.get(c.ownerId);
                        l.OwnerId = c.ownerId;
                        l.Status = 'Assigned - Unaccepted';
                        isProc = true;
                        l.Onwer_Assigned__c = true;
                        sendTo.add(u.Email);
                        system.debug('owner!');                              
                    }    
// Start modified by Mahesh for Lead Routing project phase 2 Req 2 - https://tecentral.my.salesforce.com/a0R1600000b4l34                    
                   // if(!isProc) l.Queue_Reason__c = system.label.Queue_Reason_Not_User;  
                   if(!isProc){
                        isProc = true;
                        list_lead3Route.add(l); 
                    }
// End modified by Mahesh for Lead Routing project phase 2 Req 2 - https://tecentral.my.salesforce.com/a0R1600000b4l34                  
                }  
                // 2014-10-22 Nooreen <nooreen.i@zensar.in> email notification to lead owners assigned as per specified condition     
                if(l.Owner_Assigned__c == 1 && l.TEMarketing__MQL_Date__c == null){ // 2015-04-08 Phil: Modified from l.Id != null because it was sending notifications for everything
                    
                    mail = new Messaging.SingleEmailMessage(); 
                    mail.setSubject('NEW LEAD ASSIGNED');
                    String leadURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + l.Id;
                    String body = 'Hi, <br/> <br/>';
                    body += 'A new lead has been assigned to you <b>' + l.FirstName + ' ' + l.LastName + '</b> from ' + l.Company + ' .<br/>';
                    body += 'Click on the link to access the same - '+ leadURL + '<br/> <br/>';       
                    body += 'Thanks' ;
                    mail.setHtmlBody(body);                                       
                    mail.setToAddresses(sendTo);
                    
                    mails.add(mail); 
                    System.debug('***mails***'+mails); 
                } 
// Start modified by Mahesh for Lead Routing project phase 2 Req 2 - https://tecentral.my.salesforce.com/a0R1600000b4l34                                    
            } else if(l.email != null){
                system.debug('email not null has no contact -->leadroutenew');
                    list_lead3Route.add(l);
            }
        } 
        if(!list_lead3Route.isEmpty()){ 
            channelLeadOwnerAssignment(list_lead3Route);
        }    
// End modified by Mahesh for Lead Routing project phase 2 Req 2 - https://tecentral.my.salesforce.com/a0R1600000b4l34                              
        //sendEmail(mails);             
        try{
            Messaging.sendEmail(mails);                  
        }catch(System.EmailException ex){
            System.debug('***mail error***'+ex);
        }  
        //end email notification functionality
    }
    
    /**
*   This method is used to route leads
*
* @author      min liu 
* @created     2012-11-05
* @since       23.0    
* @version     1.0                                                                 
* 
* @changelog
* 2014-06-19 Lili Zhao <lili.zhao@itbconsult.com>
* - modify the set the lead the owner as the default User of FE_Hiearchy__c 
* 2012-11-05 min liu <min.liu@itbconsult.com>
* - Created
*    
*/
    /*
public static Messaging.SingleEmailMessage generateMail(String templateId, Id ownerId, Id leadId) {
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

mail.setTemplateId(templateId);
// Phil: Doesn't work because What Id can't be set when sending to a user
// This is limiting because none of the lead field merges work properly
mail.setWhatId(leadId);
mail.setTargetObjectId(ownerId);
mail.setSaveAsActivity(false);
return mail;
}*/
    /**
*   This method is used to route leads
*
* @author      min liu 
* @created     2012-11-05
* @since       23.0    
* @version     1.0                                                                 
* 
* @changelog
* 2014-06-19 Lili Zhao <lili.zhao@itbconsult.com>
* - modify the set the lead the owner as the default User of FE_Hiearchy__c 
* 2012-11-05 min liu <min.liu@itbconsult.com>
* - Created
*    
*/
    public static void routeLead(List<Lead> list_lead2Route){
        Map<String, List<Contact>> map_email_contacts = new Map<String, List<Contact>>();
        Set<Id> set_user = new Set<Id>();
        Map<Id, User> map_usId_user = new Map<Id, User>();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        
        // check contact by email address
        for(Lead l :list_lead2Route){
            if(l.email == null) l.Queue_Reason__c = system.label.Queue_Reason_No_Contact;
            else if(l.email != null && !map_email_contacts.containsKey(l.email)) map_email_contacts.put(l.email, new List<Contact>());
        }              
        
        if(!map_email_contacts.isEmpty()){
            for(Contact c :[select email, AccountId, Account.Account_Manager__c, Account.FE_Hierarchy__c, Account.FE_Hierarchy__r.Level_7_Default_Owner__c, ownerId, Account.Account_Manager__r.Email, Account.FE_Hierarchy__r.Level_7_Default_Owner__r.Email, owner.Email from Contact where email IN :map_email_contacts.keySet()]){                
                if(map_email_contacts.containsKey(c.email)) map_email_contacts.get(c.email).add(c);
                // add lili zhao 2014-06-19 due to modify the set the lead the owner as the default User of FE_Hiearchy__c 
                if(c.Account.FE_Hierarchy__c != null && c.Account.FE_Hierarchy__r.Level_7_Default_Owner__c != null) {
                    set_user.add(c.Account.FE_Hierarchy__r.Level_7_Default_Owner__c);
                }else {
                    // end
                    if(c.AccountId != null && c.Account.Account_Manager__c != null) set_user.add(c.Account.Account_Manager__c);
                }
                set_user.add(c.ownerId);
            }
        }       
        // get contact owner and account manager
        if(!set_user.isEmpty()){
            for(User u :[select id, name, email, Te_Network_Id__c, isActive from User where id IN :set_user and isActive = true]){
                map_usId_user.put(u.id, u);
            }
        }
        
        // route lead
        for(Lead l :list_lead2Route){ 
            if(l.email != null && map_email_contacts.containsKey(l.email)){
                if(map_email_contacts.get(l.email).size() != 1) l.Queue_Reason__c = map_email_contacts.get(l.email).size() < 1 ? system.label.Queue_Reason_No_Contact : system.label.Queue_Reason_Du_Contact;
                else{                   
                    Contact c = map_email_contacts.get(l.email).get(0);
                    Boolean isProc = false; 
                    //l.Queue_Reason__c = null; 
                    system.debug('### check for assertion'+c+c.Account+c.Account.FE_Hierarchy__r.Level_7_Default_Owner__c+'map_usId_user'+map_usId_user);
                    if(map_usId_user.containsKey(c.Account.FE_Hierarchy__r.Level_7_Default_Owner__c)) {
                        User u = map_usId_user.get(c.Account.FE_Hierarchy__r.Level_7_Default_Owner__c);
                        l.OwnerId = c.Account.FE_Hierarchy__r.Level_7_Default_Owner__c;
                        l.Status = 'Assigned - Unaccepted';
                        isProc = true;
                        l.Onwer_Assigned__c = true;
                        sendTo.add(u.Email);                       
                    }else if(map_usId_user.containsKey(c.Account.Account_Manager__c)){
                        User u = map_usId_user.get(c.Account.Account_Manager__c);
                        l.OwnerId = c.Account.Account_Manager__c;
                        l.Status = 'Assigned - Unaccepted';
                        isProc = true;
                        l.Onwer_Assigned__c = true;
                        sendTo.add(u.Email);                        
                    }
                    if(!isProc && map_usId_user.containsKey(c.ownerId)){
                        User u = map_usId_user.get(c.ownerId);
                        l.OwnerId = c.ownerId;
                        l.Status = 'Assigned - Unaccepted';
                        isProc = true;
                        l.Onwer_Assigned__c = true;
                        sendTo.add(u.Email);                        
                    }                                 
                    if(!isProc) l.Queue_Reason__c = system.label.Queue_Reason_Not_User;                  
                }  
                // 2014-10-22 Nooreen <nooreen.i@zensar.in> email notification to lead owners assigned as per specified condition               
                if(l.Id != null){
                    mail.setSubject('NEW LEAD ASSIGNED');
                    String leadURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + l.Id;
                    String body = 'Hi, <br/> <br/>';
                    body += 'A new lead has been assigned to you <b>' + l.FirstName + ' ' + l.LastName + '</b> from ' + l.Company + ' .<br/>';
                    body += 'Click on the link to access the same - '+ leadURL + '<br/> <br/>';       
                    body += 'Thanks' ;
                    mail.setHtmlBody(body);                                       
                    mail.setToAddresses(sendTo);
                    mails.add(mail); 
                    System.debug('***mails***'+mails); 
                }                     
            }
        }
        
        //sendEmail(mails);             
        try{
            Messaging.sendEmail(mails);                  
        }catch(System.EmailException ex){
            System.debug('***mail error***'+ex);
        }  
        //end email notification functionality              
    }
    
    /**
*   This method is used to check if owners of leads exist in SF
*
* @author      min liu 
* @created     2012-11-05
* @since       23.0    
* @version     1.0                                                                 
* 
* @changelog
* 2012-11-05 min liu <min.liu@itbconsult.com>
* - Created
*    
*/
    public static List<Lead> checkLeadOwner(List<Lead> list_lead){
        List<Lead> list_lead2Route = new List<Lead>();
        Set<String> set_teNetworkId = new Set<String>();
        Map<String, List<Lead>> map_teNetworkId_leads = new Map<String, List<Lead>>();
        
        // get all the network ids of leads
        for(Lead l :list_lead){
            if(l.Assignee_Network_ID__c != null){ 
                set_teNetworkId.add(l.Assignee_Network_ID__c);
            }
            if(!map_teNetworkId_leads.containsKey(l.Assignee_Network_ID__c)) map_teNetworkId_leads.put(l.Assignee_Network_ID__c, new List<Lead>());
            map_teNetworkId_leads.get(l.Assignee_Network_ID__c).add(l);
        }
        
        // check if the network ids exist an active user
        for(User u :[select id, Te_Network_Id__c from User where IsActive = true and Te_Network_Id__c IN :set_teNetworkId]){
            if(map_teNetworkId_leads.containsKey(u.Te_Network_Id__c)){
                for(Lead l :map_teNetworkId_leads.get(u.Te_Network_Id__c)){
                    l.OwnerId = u.id; // Phil Suggests Adding -  l.Status = 'Assigned - Unaccepted'; l.Onwer_Assigned__c = true;
                }
                map_teNetworkId_leads.remove(u.Te_Network_Id__c);
            }
        }
        
        // get lead to route
        for(String teNetworkId :map_teNetworkId_leads.keySet()){
            for(Lead l :map_teNetworkId_leads.get(teNetworkId)){
                list_lead2Route.add(l);
            }
        }
        
        return list_lead2Route;
    }  
     
    //Start : Added by Rajendra for Lead Routing project phase 2 Req 2 - https://tecentral.my.salesforce.com/a0R1600000b4l34 
    public static void channelLeadOwnerAssignment(List<Lead> list_lead){ 
        Boolean postalFound = false;
        set<id> set_ChannelGrpIds = new set<id>(); 
        Map<String,Id> mapConPostal = new Map<String,Id>();
        Map<String,Id> mapConRegion = new Map<String,Id>();
        Map<String,Id> mapCountry = new Map<String,Id>();
        map<string,Id> mapTerritoryCodeLevel7DefaultOwner = new map<string,Id>();
        map<string,string> mapCountyCodeCountryName = new map<string,string>();
        map<Id,User> mapActiveUsers = new map<Id,User>([Select Id,isActive,Territory_Code__c from User where isActive = True]);
        set_ChannelGrpIds = channelFilterLeads(); 
        for(Sales_Hierarchy__c SalesHierarchy: [select Id,Level_7_Territory_Code__c,Level_7_Default_Owner__c from Sales_Hierarchy__c])
        {
            if(!mapTerritoryCodeLevel7DefaultOwner.containsKey(SalesHierarchy.Level_7_Territory_Code__c))
                mapTerritoryCodeLevel7DefaultOwner.put(SalesHierarchy.Level_7_Territory_Code__c,SalesHierarchy.Level_7_Default_Owner__c);
        }
        for(Live_Agent_Country_List__c LiveAgentCountry : [select Id,Country_Code_2_Digit__c,English__c from Live_Agent_Country_List__c])
        {
            if(!mapCountyCodeCountryName.containsKey(LiveAgentCountry.Country_Code_2_Digit__c))
                mapCountyCodeCountryName.put(LiveAgentCountry.Country_Code_2_Digit__c,LiveAgentCountry.English__c);
        }
        for(ZSD_DMM_SAP__c zsd : [select Id,Country_Key__c,Postal_Code__c,Region__c,District_Marketing_Manager__c from ZSD_DMM_SAP__c])
        {
            string CountryName = ''; 
            CountryName = mapCountyCodeCountryName.get(zsd.Country_Key__c);
           
            if(mapActiveUsers.containskey(mapTerritoryCodeLevel7DefaultOwner.get(zsd.District_Marketing_Manager__c)) && zsd.District_Marketing_Manager__c != null && CountryName != '')
            {
                 
                Id Level7DefaultOwnerId = mapTerritoryCodeLevel7DefaultOwner.get(zsd.District_Marketing_Manager__c);
                
               
                if(zsd.Postal_Code__c != null ){
                    mapConPostal.put(CountryName+zsd.Postal_Code__c,Level7DefaultOwnerId);
                } 
                if(zsd.Region__c!= null){ 
                    mapConRegion.put(CountryName+zsd.Region__c,Level7DefaultOwnerId);
                } else {
                   
                    mapCountry.put(CountryName,Level7DefaultOwnerId);
                    
                }
            }
        }
        for(lead l: list_lead){ 
            system.debug(set_ChannelGrpIds+'before channel check -->'+l.ownerid);
           
            postalFound = false;
            if(!set_ChannelGrpIds.isEmpty() && l.ownerid != null && set_ChannelGrpIds.contains(l.ownerid)){ 
                system.debug('inside channel check -->');     
                l.Initial_Description__c = l.Description;            
                Database.DMLOptions dmo1=new Database.DMLOptions();  
                dmo1.assignmentRuleHeader.UseDefaultRule=false;  
                system.debug('l.country check -->'+l.country+l.PostalCode);
                 for(string s:mapConPostal.keyset()){
                        system.debug(s+'id '+mapConPostal.get(s));
                 } 
                 for(string s:mapConRegion.keyset()){ 
                        system.debug(s+'id '+mapConRegion.get(s)); 
                 }    
                 if(l.Country != null && l.PostalCode != null){
                    for(integer i=l.postalcode.length();i>0 && !postalFound;i--)  
                    {
                        if(mapConPostal.containskey(l.Country + l.PostalCode.substring(0,i-1)))
                        { 
                            postalFound = true;
                            system.debug('country postal match -->'+mapConPostal.get(l.Country + l.PostalCode.substring(0,i-1)));
                            l.OwnerId = mapConPostal.get(l.Country + l.PostalCode.substring(0,i-1));
                            l.Status = 'Assigned - Unaccepted'; 
                            l.Onwer_Assigned__c = true;
                            //l.setOptions(dmo1); 
                        } 
                    }
                } 
                if(postalFound == false && l.Country != null && l.State != null && mapConRegion.containskey(l.Country + l.State))
                { 
                    system.debug('country state match -->'); 
                    l.OwnerId = mapConRegion.get(l.Country + l.State);
                    l.Status = 'Assigned - Unaccepted';
                    l.Onwer_Assigned__c = true;
                    //l.setOptions(dmo1); 
                }  
                else if(postalFound == false && l.Country != null && mapCountry.containskey(l.Country))
                { 
                    system.debug(mapCountry.get(l.Country)+'country match -->'+mapCountry);
                    l.OwnerId = mapCountry.get(l.Country);
                    l.Status = 'Assigned - Unaccepted'; 
                    l.Onwer_Assigned__c = true;
                   //l.setOptions(dmo1); 
                } else if(postalFound == false){ 
                     system.debug('no country match -->');  
                     l.Queue_Reason__c = system.label.Queue_Reason_ZSD_DMM;
                }
            } else { 
                 system.debug('filter queue not match -->'); 
                 l.Queue_Reason__c = system.label.Queue_Reason_No_Contact; 
            }  
        } 
    }  
    //End : Added by Rajendra for Lead Routing project phase 2 Req 2 - https://tecentral.my.salesforce.com/a0R1600000b4l34 
    //Start : Added by Mahesh for Lead Routing project phase 2 Req 2 - https://tecentral.my.salesforce.com/a0R1600000b4l34 
    public static set<id> channelFilterLeads(){ 
        set<id> set_GrpId = new set<id>(); 
        for(group lstGrp : [select id,name from group where name like '%Filter Agent%']){
            if(!lstGrp.name.contains('Sales Dev')){
                set_GrpId.add(lstGrp.id);
            }
        } 
        return set_GrpId;
    }    
    //End : Added by Mahesh for Lead Routing project phase 2 Req 2 - https://tecentral.my.salesforce.com/a0R1600000b4l34 
}