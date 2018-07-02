/** 
 *  Class to upload a Sensitive Attachment and save correspond value to Sensitive_Attachment__c,
 *  by use this Class to make only the specific user can access the uploaded Atttachment 
 *  
 * @author Yinfeng Guo
 * @created 2012-02-20
 * @version 1.0
 * @since 23.0
 * 
 *
 * @changelog
 * 2012-02-20 Yinfeng Guo <yinfeng.guo@itbconsult.com>
 * - Created   
 *
 */
public class  ExtUploadSensitiveAttachment {
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    /**
     * the sensitive attachment will be created or updated
     * if new sensitive attachment this variable will be a new one, or else if edit sensitive attachment it derived from database
     */     
    public Sensitive_Attachment__c sensitiveAttachment { set; get; }
    
    /**
     * the attachment will be created or updated
     * if new attachment this variable will be a new one, or else if edit attachment it derived from database
     */     
    public Attachment attachment { set; get; }
    
    /**
     * object Account variable 
     */ 
    public Account account { set; get; }
    
    /**
     * object Opportunity variable 
     */ 
    public Opportunity opportunity { set; get; }
    
    /**
     * the user list that contains the user related to the opportunity or account, not contains the user that added manual. 
     * This user list used when new a sensitive attachment
     */ 
    public list<ShowUser> list_user2Show { set; get; }
    
    /**
     * the user list that contains the user related to the opportunity or account, at the same time, contains the user that added manual. 
     * This user list used when edit a sensitive attachment
     */ 
    public list<ShowUser> list_user2Edit { set; get; }
    
    /**
     * the user list that contains the user related to the sensitive attachment, that's to say the user have access to the sensitive attachment
     * This user list used when view  a sensitive attachment
     */ 
    public list<ShowUser> list_user2View { set; get; }
    
    /**
     * this variable to tell us whether have uploaded attachment
     */
    public Boolean isUpload { set; get; }
    
    /**
     * this variable to tell us whether is update
     * if the standardAttachment already exist, then this variable is true
     */
    public Boolean isUpdate { set; get; }
    
    /**
     * this variable have three kind of value
     * 1: for new or edit mode, at this mode, the user can upload new attachment and can change field value for Standard_Attachment__c
     * 2: for view mode
     * 3: for only upload attachment, can not change field value in Standard_Attachment__c
     */
    public String showMode { set; get; }
    
    /**
     * the variable is opportunity's name or account's name
     */ 
    public String name { set; get; }  
    
    /**
     * this variable to tell us upload attachment for account or opportunity
     */ 
    public String mode { set; get; } 
     
    /**
     * the intermediate variable
     */ 
    public Contact contact{get;set;}
    
    /**
     * upload sensitive attachment is available on both Account and Opportunity
     * so the code need to validate whether is Account or Opportunity
     * this variable indicate the object is Account
     * Account Attachment will have a lookup to account
     */ 
    public static final String MODE_A = 'Account';
    
    /**
     * upload sensitive attachment is available on both Account and Opportunity
     * so the code need to validate whether is Account or Opportunity
     * this variable indicate the object is Opportunity
     * Opportunity Attachment will have a lookup to opportunity
     */ 
    public static final String MODE_O = 'Opportunity'; 
  
    /**
     * the user that have been selected in the related user list
     */ 
    public set<Id> set_selUserIds ;
             
    /**
     * the account id
     */ 
    public Id accountId;
    
    /**
     * the opportunity id
     */ 
    public Id opportunityId;
    
    /**
     * the table column title, this column is show whether the user is share user
     * this string have two kind values : "Opportunity Share User" or "Account Share User"
     * use this column to different the added user and the share user
     */
    public String isSharedUserColumnTitle{get;set;}
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    /**
     * the standard controller variable
     */          
    private final ApexPages.standardController controller;  

    /**
     * the id will redirect the page after click save, idRedirect may be account's id or opportunity's id
     */ 
    private Id idRedirect;   
    
    /**
     * this variable get the Id of actual user : Userinfo.getUserId();
     */ 
    private Id actualUserId;     
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////  
   /**
    * The contsructor
    *
    @author Yinfeng Guo
    @created 2012-02-20
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @changelog
    * 2012-02-20 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */  
    public ExtUploadSensitiveAttachment (ApexPages.StandardController ctrl) {  
        
        this.controller = ctrl;
        actualUserId = Userinfo.getUserId();
        attachment = new Attachment();
        list_user2Show = new list<ShowUser>();
        list_user2Edit = new list<ShowUser>();
        list_user2View = new list<ShowUser>();
        isUpload = false;
        isUpdate = false;
        sensitiveAttachment = (Sensitive_Attachment__c)controller.getRecord();
        set_selUserIds = new set<Id>();
        mode = '';
        showMode = '';
        contact = new Contact();


        if(sensitiveAttachment.Id != null){
            sensitiveAttachment = [Select Id, Send_to_PLM__c, Attachment_Name__c, Account__c, Opportunity__c, Attachment_Id__c, OwnerId, CreatedById, LastModifiedById, Last_PLM_Integration_Date__c  from Sensitive_Attachment__c where Id =: sensitiveAttachment.Id];           
            attachment = [Select Id, Body, Name, ContentType, ParentId From Attachment Where Id = :this.sensitiveAttachment.Attachment_Id__c];
            attachment.Body = null;
            
            if(sensitiveAttachment.Account__c != null){
                account = [Select Id, Name, OwnerId From Account Where Id =: sensitiveAttachment.Account__c];
                name = account.Name;
                idRedirect = sensitiveAttachment.Account__c;
                this.mode = MODE_A;
                isSharedUserColumnTitle = system.Label.Account_Share_User;
            }
            else if(sensitiveAttachment.Opportunity__c != null){
                opportunity = [Select Id, OwnerId, Name from Opportunity where Id =: sensitiveAttachment.Opportunity__c];
                name = opportunity.Name;
                idRedirect = sensitiveAttachment.Opportunity__c;
                this.mode = MODE_O;
                isSharedUserColumnTitle = system.Label.Opportunity_Share_User;
            }           
            if(ApexPages.currentPage().getParameters().get('upload') != null){
                showMode = 'uploadnew';
            }
            else if(ApexPages.currentPage().getParameters().get('retURL') == null){
                showMode = 'view';
                this.isUpdate = true;
            }
            else{
                showMode = 'edit';
                this.isUpdate = true;               
            }
        }
        else{
            showMode = 'new';
            if(sensitiveAttachment.Account__c != null){
                this.accountId = sensitiveAttachment.Account__c;
                this.mode = MODE_A;
                isSharedUserColumnTitle = system.Label.Account_Share_User;
            }
            else if(sensitiveAttachment.Opportunity__c != null){
                this.opportunityId = sensitiveAttachment.Opportunity__c;
                this.mode = MODE_O;
                isSharedUserColumnTitle = system.Label.Opportunity_Share_User;
            }       
        }
          
        if(this.mode == MODE_A && this.accountId != null){
            showAccountRelatedUser(accountId);
        }
        else if(this.mode == MODE_O && this.opportunityId != null){
            showOpportunityRelatedUser(opportunityId);
        }
        else if(this.isUpdate){
            showEditData();
        }
        system.debug('test:list_user2Edit:'+list_user2Edit);
    }  
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN private methods=- ********************************* 
    /**
     * This method is used when edit Sensitive Attachment,
     * this method to show a list of user can be granted access later
     *
     @author Yinfeng Guo
     @created 2012-02-21
     @version 1.0
     @since 23.0
     *
     @param sensAttId           the Sensitive Attachment id
     *
     @return                void            
     *
     @changelog
     * 2012-02-21 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    private void showEditData(){
        if(sensitiveAttachment.Account__c != null){
            list_user2Edit = showAccountRelatedUser(sensitiveAttachment.Account__c);
            idRedirect = sensitiveAttachment.Account__c;
        }
        else if(sensitiveAttachment.Opportunity__c != null){
            list_user2Edit = showOpportunityRelatedUser(sensitiveAttachment.Opportunity__c);
            idRedirect = sensitiveAttachment.Opportunity__c;
        }

        for(Sensitive_Attachment__Share sas : [Select UserOrGroupId,ParentId,AccessLevel from Sensitive_Attachment__Share where ParentId =: sensitiveAttachment.Id]){
            set_selUserIds.add(sas.UserOrGroupId);
        }
        
        for(ShowUser su : list_user2Edit){
            if(set_selUserIds.contains(su.user.Id)){
                su.isSelected = true ;
                list_user2View.add(su);
            }
        }
    }

    /**
     * This method is used when upload new Sensitive Attachment to Account,
     * this method to show a list of user can be granted access later
     *
     @author Yinfeng Guo
     @created 2012-02-20
     @version 1.0
     @since 23.0
     *
     @param accountId           the Account id will upload attachment to
     *
     @return                a list of user can be granted access later          
     *
     @changelog
     * 2012-02-20 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    private list<ShowUser> showAccountRelatedUser(Id accountId){
        
        set<Id> set_uorgIds = new set<Id>();
        set<Id> set_addedUserIds = new set<Id>();
        set<Id> set_shareUserIds = new set<Id>();
        
        set<Id> set_groupIds = new set<Id>();
        
        map<Id,String> map_id_role = new map<Id,String>();

        account = [Select Id, Name, OwnerId From Account Where Id =: accountId];
        name = account.Name;
                
        if(account.OwnerId != null){
            set_shareUserIds.add(account.OwnerId);
        }
        
        for(AccountShare accShr : [Select Id, UserOrGroupId from AccountShare where AccountId =: accountId]){
            set_uorgIds.add(accShr.UserOrGroupId);
        }
        for(Id ugId : set_uorgIds){
            String temp = String.valueOf(ugId).substring(0, 3);
            if(temp == '005'){
                set_shareUserIds.add(ugId);
            }
            else if(temp == '00G'){
                set_groupIds.add(ugId);
            }
        }
        
        if(!set_groupIds.isEmpty()){
            for(GroupMember gp : [SELECT GroupId, Id, SystemModstamp, UserOrGroupId FROM GroupMember where GroupId in: set_groupIds]){
                set_shareUserIds.add(gp.UserOrGroupId);
            }
        }
        
        if(sensitiveAttachment.Id != null){
            for(Sensitive_Attachment__Share sas : [Select UserOrGroupId,ParentId from Sensitive_Attachment__Share where ParentId =: sensitiveAttachment.Id and RowCause != 'Owner']){
                if(!set_shareUserIds.contains(sas.UserOrGroupId)) set_addedUserIds.add(sas.UserOrGroupId);
            }
        }
        
        ShowUser showUser ;
        if(!set_shareUserIds.isEmpty() || !set_addedUserIds.isEmpty()){
            for(Account_Team__c accT : [Select Id, Role__c, Team_Member__c,Account__c from Account_Team__c where Team_Member__c in: set_shareUserIds and Account__c =: accountId]){
                map_id_role.put(accT.Team_Member__c, accT.Role__c);
            }
            for(Customer_Focus_Team_Member__c cusT : [Select Id, Role__c, Salesforce_User_Name__c, Global_Account_Lkp__c from Customer_Focus_Team_Member__c where Global_Account_Lkp__c =: accountId and Salesforce_User_Name__c in: set_shareUserIds]){
                map_id_role.put(cusT.Salesforce_User_Name__c, cusT.Role__c);
            }
            for(User u : [Select Id, FirstName, LastName, Email, Country, CompanyName, Department, GIBU__c from User where Id in: set_shareUserIds ]){
                showUser = new showUser();
                showUser.user = u;
                showUser.isShareUser = true;
                if(map_id_role.containsKey(u.Id)){
                    showUser.role = map_id_role.get(u.Id);
                }
                list_user2Show.add(showUser);
            }
            for(User u : [Select Id, FirstName, LastName, Email, Country, CompanyName, Department, GIBU__c from User where Id in: set_addedUserIds ]){
                showUser = new showUser();
                showUser.user = u;
                showUser.isShareUser = false;
                if(map_id_role.containsKey(u.Id)){
                    showUser.role = map_id_role.get(u.Id);
                }
                list_user2Show.add(showUser);
            }
        }   
        return  list_user2Show;
    }

    /**
     * This method is used when upload new Sensitive Attachment to Opportunity,
     * this method to show a list of user can be granted access later
     *
     @author Yinfeng Guo
     @created 2012-02-20
     @version 1.0
     @since 23.0
     *
     @param accountId           the Opportunity id will upload attachment to
     @return                    a list of user can be granted access later          
     *
     @changelog
     * 2012-02-20 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */ 
    private list<ShowUser> showOpportunityRelatedUser(Id opportunityId){
        set<Id> set_uorgIds = new set<Id>();
        set<Id> set_addedUserIds = new set<Id>();
        set<Id> set_shareUserIds = new set<Id>();
        set<Id> set_groupIds = new set<Id>();
        map<Id,String> map_id_role = new map<Id,String>();
        
        opportunity = [Select Id, OwnerId, Name from Opportunity where Id =: opportunityId];
        name = opportunity.Name;

        /*Owner*/
        if(opportunity.OwnerId != null){
            set_shareUserIds.add(opportunity.OwnerId);
        }
        
        for(OpportunityShare oppShr : [Select Id, UserOrGroupId from OpportunityShare where OpportunityId =: opportunityId]){
            set_uorgIds.add(oppShr.UserOrGroupId);
        }
        
        for(Id ugId : set_uorgIds){
            String temp = String.valueOf(ugId).substring(0, 3);
            if(temp == '005'){
                set_shareUserIds.add(ugId);
            }
            else if(temp == '00G'){
                set_groupIds.add(ugId);
            }
        }
        
        if(!set_groupIds.isEmpty()){
            for(GroupMember gp : [SELECT GroupId, Id, SystemModstamp, UserOrGroupId FROM GroupMember where GroupId in: set_groupIds]){
                set_shareUserIds.add(gp.UserOrGroupId);
            }
        }
        
        if(sensitiveAttachment.Id != null){
            for(Sensitive_Attachment__Share sas : [Select UserOrGroupId,ParentId from Sensitive_Attachment__Share where ParentId =: sensitiveAttachment.Id and RowCause != 'Owner']){
                if(!set_shareUserIds.contains(sas.UserOrGroupId)) set_addedUserIds.add(sas.UserOrGroupId);
            }
        }
        
        ShowUser showUser ;
        if(!set_shareUserIds.isEmpty() || !set_addedUserIds.isEmpty()){
            for(OpportunityTeamMember oppTeam : [Select Id, TeamMemberRole, UserId from OpportunityTeamMember where UserId in: set_shareUserIds and OpportunityId=:opportunityId ]){
                map_id_role.put(oppTeam.UserId, oppTeam.TeamMemberRole);
            }
            
            for(User u : [Select Id, FirstName, LastName, Email, Country, CompanyName, Department, GIBU__c from User where Id in: set_shareUserIds ]){
                showUser = new showUser();
                showUser.user = u;
                showUser.isShareUser = true;
                if(map_id_role.containsKey(u.Id)){
                    showUser.role = map_id_role.get(u.Id);
                }
                list_user2Show.add(showUser);
            }
            for(User u : [Select Id, FirstName, LastName, Email, Country, CompanyName, Department, GIBU__c from User where Id in: set_addedUserIds ]){
                showUser = new showUser();
                showUser.user = u;
                showUser.isShareUser = false;
                if(map_id_role.containsKey(u.Id)){
                    showUser.role = map_id_role.get(u.Id);
                }
                list_user2Show.add(showUser);
            }
        }
        return  list_user2Show;
    }
        
    //********************************* -=END private methods=- ***********************************
    
        
    //********************************* -=BEGIN public methods=- **********************************
    /**
     * This method is used when click 'upload' on vf page,
     * this method to show the  Sensitive_Attachment'  Attachment_Name__c prepopulated by file name
     *   
     @author Yinfeng Guo
     @created 2012-02-20
     @version 1.0
     @since 23.0
     *
     @return         null
     *
     @changelog
     * 2012-02-20 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */ 
    public PageReference uploadSensitiveAttachment(){

        if(this.attachment.Name == null){
            ApexPages.Message msgErrorMessage = new ApexPages.Message(ApexPages.Severity.WARNING, system.Label.Not_Choose_File); 
            ApexPages.addMessage(msgErrorMessage);
        }/*
        else if(sensitiveAttachment.Attachment_Name__c == null){
            
            sensitiveAttachment.Attachment_Name__c = this.attachment.Name;
            
            if(this.mode == 'Account' && this.accountId != null){
                sensitiveAttachment.Account__c = this.accountId;
                insert sensitiveAttachment;
            }
            else if(this.mode == 'Opportunity' && this.opportunityId != null){
                sensitiveAttachment.Opportunity__c = this.opportunityId;
                insert sensitiveAttachment;
            }
            
            if (sensitiveAttachment.Attachment_Name__c != null) {
                this.attachment.Name = sensitiveAttachment.Attachment_Name__c;
            }
            if(!this.isUpdate && this.showMode != 'uploadnew'){
                sensitiveAttachment.Attachment_Name__c = this.attachment.Name;              
                this.attachment.ParentId = this.sensitiveAttachment.Id;
            }
            Attachment a = new Attachment();
            a = attachment.clone(false);
            upsert a;
            if(attachment.Id != null){
                delete attachment;
            }           
            sensitiveAttachment.Attachment_Id__c = String.valueOf(a.Id);
            system.debug('yinfeng:test:sensitiveAttachment:UPLOAD:'+sensitiveAttachment);
            update sensitiveAttachment; 
            
            attachment.Body = null;
            isUpload = true;
        }*/
        else{
            
            String employeeNumber = '';
            
            for(User u : [SELECT Id, TE_Network_Id__c from User WHERE Id =: actualUserId]){
                employeeNumber = u.TE_Network_Id__c;
            }
            
            //In the new requirement, the user can not define the attachment name
            //if(sensitiveAttachment.Attachment_Name__c == null){
            sensitiveAttachment.Attachment_Name__c = this.attachment.Name;
            //}
            
            if(this.mode == 'Account' && this.accountId != null){
                sensitiveAttachment.Account__c = this.accountId;
                sensitiveAttachment.TE_Network_Id__c = employeeNumber;
                insert sensitiveAttachment;
            }
            else if(this.mode == 'Opportunity' && this.opportunityId != null){
                sensitiveAttachment.Opportunity__c = this.opportunityId;
                sensitiveAttachment.TE_Network_Id__c = employeeNumber;
                insert sensitiveAttachment;
                
              /*  //JNV 10/18 - uncomment
                //plm attachment system
                for(Opportunity o : [SELECT Id, PLM_Id__c from Opportunity WHERE Id = :this.opportunityId]){
                    plmId = o.PLM_Id__c;
                }
                
                system.debug('*****12345 ' + this.opportunityId + ' ' + plmId + ' ' + sensitiveAttachment.Send_to_PLM__c + ' ' + sensitiveAttachment.Last_PLM_Integration_Date__c);
                //call to plm attach file call out
                if(plmId != null && sensitiveAttachment.Send_to_PLM__c == true && sensitiveAttachment.Last_PLM_Integration_Date__c == null) 
                {
                    //JNV 10/18 - get config name here and pass to real_time_class            
                    string plmAttachConfigName;
                    for(realtime_Callout_Settings__c rcs : realtime_Callout_Settings__c.getAll().values()) {
                        if(rcs.Active__c == true ) {
                            if(rcs.Name == 'Prod PLM Attachment Push' || rcs.Name == 'QA PLM Attachment Push'){
                                plmAttachConfigName = rcs.Name;  
                            }
                        }       
                    }
                    result = real_time_call.callOrchestrationRealTime('PUSHFILETOPLM',sensitiveAttachment.ID,plmAttachConfigName);
                    system.debug('*****12345 ' + result);
                } */
            }
            
            //do not need to assgine user defined name to standard attachment, commented by yinfeng.guo
            //In the new requirement, the user can not define the attachment name
            /*if (sensitiveAttachment.Attachment_Name__c != null) {
                this.attachment.Name = sensitiveAttachment.Attachment_Name__c;
            }*/
            
            
            if(!this.isUpdate && this.showMode != 'uploadnew'){
                sensitiveAttachment.Attachment_Name__c = this.attachment.Name;              
                this.attachment.ParentId = this.sensitiveAttachment.Id;
            }
            Attachment a = new Attachment();
            a = attachment.clone(false);
            upsert a;
            if(attachment.Id != null){
                delete attachment;
            }           
            sensitiveAttachment.Attachment_Id__c = String.valueOf(a.Id);
            system.debug('yinfeng:test:sensitiveAttachment:UPLOAD:'+sensitiveAttachment);
            update sensitiveAttachment; 
            
            attachment.Body = null;     
                
            isUpload = true;
        }
        return null;
    }

    /**
     * This method is used when click 'Save' on vf page,
     * this method to upload attachment to standard Attachment object,
     * and save respond value to Sensitive_Attachment__Share,
     * and grant attachment access to selected user on vf page 
     *   
     @author Yinfeng Guo
     @created 2012-02-20
     @version 1.0
     @since 23.0
     *
     @return         Account or Opportunity page according to the Account or Opportunity id
     *
     @changelog
     * 2012-02-20 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */ 
    public PageReference save(){
        try{
            if(showMode != 'new'){
                if(attachment.Body != null){
                    //In the new requirement, the user can not define the attachment name
                   
                    Attachment a = new Attachment();
                    a = attachment.clone(false);
                    insert a;
                    if(attachment.Id != null){
                        delete attachment;
                    }
                    sensitiveAttachment.Attachment_Id__c = String.valueOf(a.Id);     
                    sensitiveAttachment.Attachment_Name__c = a.Name;//after upload new attachment, the Attachment_Name__c should change as well                    
                }
            }
            update this.sensitiveAttachment;
            system.debug('*****12345 ' + sensitiveAttachment.Opportunity__c);
            list<Sensitive_Attachment__Share> list_sAttShr2Insert = new list<Sensitive_Attachment__Share>();
            list<Sensitive_Attachment__Share> list_sAttShr2Delete = new list<Sensitive_Attachment__Share>();
            
            set<Id> set_uids = new set<Id>();
            set<Id> set_uidsInsert = new set<Id>();
            Sensitive_Attachment__Share attShr;
            
            for(Sensitive_Attachment__Share sas : [Select UserOrGroupId,ParentId from Sensitive_Attachment__Share where RowCause = 'Owner' and ParentId =: sensitiveAttachment.Id]){
                set_uids.add(sas.UserOrGroupId);
            }
            for(ShowUser sUser : list_user2Show){
                if(sUser.isSelected == true && !set_uids.contains(sUser.user.Id)){
                    attShr = new Sensitive_Attachment__Share();
                    attShr.UserOrGroupId = sUser.user.Id;
                    attShr.AccessLevel = 'Read';
                    attShr.ParentId = sensitiveAttachment.Id;
                    set_uidsInsert.add(sUser.user.Id);
                    list_sAttShr2Insert.add(attShr);
                }
            }

            if(!set_selUserIds.isEmpty()){
                for(Id id : set_selUserIds){
                    if(set_uidsInsert.contains(id)){
                        set_selUserIds.remove(id);
                    }
                }   
            }
            if(!set_selUserIds.isEmpty()){
                list_sAttShr2Delete = [Select UserOrGroupId, Id, ParentId from Sensitive_Attachment__Share where UserOrGroupId in: set_selUserIds and ParentId =: sensitiveAttachment.Id and RowCause = 'Manual'];
            }
            
            system.debug('test:list_sAttShr2Insert:'+list_sAttShr2Insert);
            
            if(!list_sAttShr2Insert.isEmpty()){
                insert list_sAttShr2Insert;
            }
            if(!list_sAttShr2Delete.isEmpty()){
                delete list_sAttShr2Delete;
            }

            if(sensitiveAttachment.Opportunity__c != null){
                String result = '';
                String plmId = '';              
                
                for(Opportunity o : [SELECT Id, PLM_Id__c from Opportunity WHERE Id = :sensitiveAttachment.Opportunity__c ]){
                    plmId = o.PLM_Id__c;
                }
                
                system.debug('*****12345 ' + sensitiveAttachment.Opportunity__c  + ' ' + plmId + ' ' + sensitiveAttachment.Send_to_PLM__c + ' ' + sensitiveAttachment.Last_PLM_Integration_Date__c);
                //call to plm attach file call out
                if(plmId != null && sensitiveAttachment.Send_to_PLM__c == true && sensitiveAttachment.Last_PLM_Integration_Date__c == null) 
                {
                    sendFileToPLM((string)sensitiveAttachment.Id);
                }
            }            
            
        }
        catch( Exception e ){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
        }           
        return cancel();
    }
    
    @future (callout=true)
    private static void sendFileToPLM(string sensitiveAttachmentId)
    {
        String result = '';             
        //JNV 10/18 - get config name here and pass to real_time_class            
        string plmAttachConfigName;
        for(realtime_Callout_Settings__c rcs : realtime_Callout_Settings__c.getAll().values()) {
            if(rcs.Active__c == true ) {
                if(rcs.Name == 'Prod PLM Attachment Push' || rcs.Name == 'QA PLM Attachment Push'){
                    plmAttachConfigName = rcs.Name;  
                }
            }       
        }
        result = real_time_call.callOrchestrationRealTime('PUSHFILETOPLM',sensitiveAttachmentId,plmAttachConfigName);
        system.debug('*****12345 ' + result);   
    }

    /**
     * This method is used when click 'Cancel' on vf page,
     * this method to redirect to Account or Opportunity page
     *   
     @author Yinfeng Guo
     @created 2012-02-20
     @version 1.0
     @since 23.0
     *
     @return         Account or Opportunity page according to the Account or Opportunity id
     *
     @changelog
     * 2012-02-20 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */         
    public PageReference cancel(){
        if(this.mode == MODE_A && this.accountId != null){
            idRedirect = this.accountId;
        }
        else if(this.mode == MODE_O && this.opportunityId != null){
            idRedirect = this.opportunityId;
        }
        PageReference pageRef = new PageReference('/'+ idRedirect);
        pageRef.setRedirect( true );
        return pageRef;
    }


    /**
     * This method is used when user want to add user dynamic by search on page use look up
     *   
     @author Yinfeng Guo
     @created 2012-02-20
     @version 1.0
     @since 23.0
     *
     @return         null
     *
     @changelog
     * 2012-02-20 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */      
    public PageReference userAdded() {
        ShowUser showUser = new ShowUser();
        set<Id> set_nuids = new set<Id>();
        if(contact.OwnerId != null){
            showUser.user = [Select Id, FirstName, LastName, Email, Country, CompanyName, Department, GIBU__c from User where Id =: contact.OwnerId];
            showUser.isSelected = true;
            showUser.isShareUser = false;
            if(this.isUpdate){
                for(ShowUser s : list_user2Edit){
                    set_nuids.add(s.user.Id);
                }
                if(!set_nuids.contains(showUser.user.Id)){
                    list_user2Edit.add(showUser);
                }/*
                else{
                    ApexPages.Message msgErrorMessage = new ApexPages.Message(ApexPages.Severity.INFO, system.Label.User_Exist); 
                    ApexPages.addMessage(msgErrorMessage);
                }*/
                
            }
            else{
                for(ShowUser s : list_user2Show){
                    set_nuids.add(s.user.Id);
                }
                if(!set_nuids.contains(showUser.user.Id)){
                    list_user2Show.add(showUser);
                }
                /*
                else{
                    ApexPages.Message msgErrorMessage = new ApexPages.Message(ApexPages.Severity.INFO, system.Label.User_Exist); 
                    ApexPages.addMessage(msgErrorMessage);
                }*/
                
            }
        }/*
        else{
            ApexPages.Message msgErrorMessage = new ApexPages.Message(ApexPages.Severity.INFO, system.Label.Not_Input_User); 
            ApexPages.addMessage(msgErrorMessage);
        }*/
        contact.OwnerId = null;
        return null;
    }

    /**
     * This method is a get Method for Object ExtUploadSensitiveAttachment
     *
     @author Yinfeng Guo
     @created 2012-02-14
     @version 1.0
     @since 23.0
     *
     @return         ExtUploadSensitiveAttachment object    
     *
     @changelog
     * 2012-02-14 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    public ExtUploadSensitiveAttachment getExtUploadSensitiveAttachment() {
        return this;
    }
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>InnerClass*/
    /**
     * This is a Inner Class.
     * Class field contains : 1.Standard object User 2.The role of the user 3.Whether show this user's checkbox selected on page 4.This user's access attchement's level.
     * Class method contains : 1. Get Permissions's SelectOption for This user's access attchement's level
     *
     @author Yinfeng Guo
     @created 2012-02-14
     @version 1.0
     @since 23.0
     *
     @changelog
     * 2012-02-14 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */ 
    public class ShowUser
    {
        public User user { set; get; }
        public String role{ set; get; }
        public Boolean isSelected{ set; get; }
        public Boolean isShareUser{get;set;}
        
    }
    ///*<<<InnerClass*/
    //********************************* -=END inner classes=- *************************************    
}