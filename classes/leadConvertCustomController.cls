public without sharing class leadConvertCustomController {
    public  Lead leadToConvert {get; set;}
    public Boolean doNotCreateOppty {get; set;}
    private final string EXISTING = 'Attach to existing: ';
    public Opportunity opportunityID {get; set;}
    public boolean sendOwnerEmail {get; set;}
    public List<SelectOption> accounts {get; set;}
    public List<SelectOption> contacts {get; set;}
    public string selectedAccount {get; set;}
    public string selectedContact{get;set;}
    public Task taskID {get; set;}
    public String reminderTime {get; set;}
    public Boolean reminder {get; set;}
    public id currentLeadId{get;set;}
    public leadConvertTaskRemindComponentController remCon {get; set;}
    private transient List<Schema.PicklistEntry> taskStatuses = Task.Status.getDescribe().getPicklistValues();
    private transient List<Schema.PicklistEntry> taskPriorities = Task.Priority.getDescribe().getPicklistValues();
    
    public Contact contactID{
        get {
            system.debug('=leadId==>'+contactId);
            if (contactId == null) {
                contactID=new Contact(ownerId=leadToConvert.ownerId);
                //contactID=[SELECT Id,name FROM Contact where id=:leadToConvert.OwnerId];
            }
            return contactId;
        }
        set;
    }
    public Lead leadConvert{
        get; 
        set {
            //the first time this is set, the select list of Accounts will be populated 
            if (accounts == null) {
                system.debug('leadConvert set to===>'+ value);
                leadConvert = value;
                populateAccounts(); 
            }
        }
    }
    public leadConvertCustomController(ApexPages.StandardController stdController) {
        accounts = new List<selectOption>();  
        Id leadId = stdController.getId();
        contacts=new List<SelectOption>(); 
        currentLeadId=leadId;
        system.debug('=leadId==>'+leadId);
        // create a new Opportunity which will hold the Opportuniy name set by the user
        opportunityId = new Opportunity();
        
        leadToConvert = [SELECT Id, Status, OwnerId, Name, Company,email FROM Lead WHERE Id =:leadId ];//'00Q90000012ww9N'];//''];
        system.debug('=leadToConvert==>'+leadToConvert);
        selectedAccount = 'NONE';
        populateAccounts();
        //===task====
        taskId = new Task();
        taskId.IsReminderSet = true;
        taskId.Subject='';
        reminder = true;
        taskId.Status = TaskDefaulValue(taskStatuses);
        taskId.Priority = TaskDefaulValue(taskPriorities);
        taskId.ReminderDateTime = datetime.now();
        remCon = new leadConvertTaskRemindComponentController();
    }
    // leadConvert.setLeadId(leadToConvert.Id);   
    //populate the list of Accounts in the dropdown
    @testVisible
    private void populateAccounts() {
        if (leadToConvert != null) {
            string company = leadToConvert.Company;
            string emailid= leadToConvert.Email;
            system.debug('company==>'+company);
            // find any accounts that match the SOSL query in the findCompany() method  
            Account [] accountsFound = findCompany(company + '*');
            system.debug('accountsFound==>'+accountsFound);
            if (accountsFound != null && accountsFound.size() > 0) {
                accounts.add(new SelectOption('NONE', '-None-'));
                //accounts.add(new SelectOption('NEW', 'Create New Account: ' + company ));
                for (Account a : accountsFound) {
                    accounts.add(new SelectOption(a.Id, EXISTING + a.Name));
                }
            }
            else {
                accounts.add(new SelectOption('NEW', 'Create New Account: ' + company ));
                system.debug('no account matches on company ===>' + company);
            }
            // find any contacts that match the SOSL query in the findcontactc() method  
            Contact[] contactsFound = findContacts(emailid);
            system.debug('contactsFound==>'+contactsFound);
            if (contactsFound != null && contactsFound.size() > 0) {
                contacts.add(new SelectOption('NONE', '-None-'));
                for (Contact c: contactsFound) {
                    contacts.add(new SelectOption(c.Id, EXISTING + c.Name));
                    system.debug('no contact matches on email ===>' + contacts);
                }
            }
            else {
                contacts.add(new SelectOption('NEW','Create New Contact:'));
                system.debug('no account matches on company ===>' + contacts);
            }
            opportunityId.Name = company + '-';
        }
        else system.debug('leadConvert = null');
    }
    
    // when the selected account in the select list of accounts changes this method is called 
    public PageReference accountChanged() {
        
        /*if (selectedAccount == 'NEW' || selectedAccount == 'NONE') {
            //opportunityId.Name = leadConvert.Company  + '-';
            
        }
        else {*/
            // otherwise find the account's Id and Name that was selected and set the Opportuity name to that Account
            Account [] a = [SELECT Id, Name  FROM Account WHERE Id = :selectedAccount];
            if (a.size() > 0) {
                opportunityId.Name = a[0].Name + '-';
            }
        //}
        return null;
    }
    // when the selected contact in the select list of contact changes this method is called 
    public PageReference contactChanged() {
        system.debug('==selectedContact==>'+selectedContact);
        Contact[] con= [SELECT Id, Name  FROM Contact WHERE Id = :selectedContact];
        system.debug('==con==>'+con);
        //
        Map<String, String> locale_map = new Map<String, String>(); 
        locale_map.put('ar', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_AE', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_BH', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_JO', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_KW', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_LB', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_SA', 'dd/MM/yyyy hh:mm a');
        locale_map.put('bg_BG', 'yyyy-M-d H:mm');
        locale_map.put('ca', 'dd/MM/yyyy HH:mm');
        //Map<String, String> locale_map = new Map<String, String>(); 
        locale_map.put('ar', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_AE', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_BH', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_JO', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_KW', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_LB', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_SA', 'dd/MM/yyyy hh:mm a');
        locale_map.put('bg_BG', 'yyyy-M-d H:mm');
        locale_map.put('ca', 'dd/MM/yyyy HH:mm');
        //
        return null;
    }
    //this gets called when an existing accout gets looked up via the lookup magnifying glass
    public PageReference accountLookedUp() {
        system.debug('!!! Account looked up --> ' + contactId.AccountId );       
        Account [] a = [SELECT Id, Name FROM Account WHERE Id = :contactId.AccountId];
        system.debug('!!! Account looked up --> '+a);
        system.debug('!!! Account looked up --> '+EXISTING);
        if (a.size() > 0) {
            accounts.add(new SelectOption(a[0].Id, EXISTING + a[0].Name));
            selectedAccount = a[0].Id;
            opportunityId.Name = a[0].Name + '-';
            
            system.debug('accounts --> ' + accounts);
        }
        
        
        return null;
    }
    // Find an Account using SOSL based on the given company name
    private Account [] findCompany (string companyName) {
        
        List<List<SObject>> searchList = [FIND :companyName IN NAME FIELDS RETURNING  Account(Id,Name)];   
        List <Account> accountsFound = new List<Account>();
        system.debug('==searchList==>'+searchList);
        for (List <sobject> sObjs : searchList) {
            for (sObject s : sObjs) {
                accountsFound.add((Account) s);
            }   
        }
        return accountsFound;
    }
    // Find an Contacts using SOSL based on the given emailid
    @testVisible
    private Contact[] findContacts(string emailid) {
        system.debug('==emailid==>'+emailid);
        List<List<SObject>> searchList = [FIND :emailid IN ALL FIELDS RETURNING Contact(Id,Name)];   
        List <Contact>contactsFound = new List<Contact>();
        system.debug('==searchList==>'+searchList);
        for (List <sobject> sObjs : searchList) {
            for (sObject s : sObjs) {
                contactsFound.add((Contact) s);
            }   
        }
        system.debug('==contactsFound==>'+contactsFound);
        return contactsFound;
    }
    // set up the Lead Status pick list
    public List<SelectOption> LeadStatusOption {
        get {
            if(LeadStatusOption == null) {
                LeadStatusOption = new List<SelectOption>();
                
                LeadStatus [] ls = [select MasterLabel from LeadStatus where IsConverted=true order by SortOrder];
                
                if (ls.size() > 1) {
                    LeadStatusOption.add(new SelectOption('NONE', '--None--'));
                }
                for (LeadStatus convertStatus : ls){
                    if(convertStatus.MasterLabel=='Converted' || convertStatus.MasterLabel=='Converted-order taken' )
                        LeadStatusOption.add(new SelectOption(convertStatus.MasterLabel, convertStatus.MasterLabel));
                } 
            }
            return LeadStatusOption;
        }
        set;
    }
    //set the default value based on the picklist sent to the method
    @testVisible
    private String TaskDefaulValue(List<Schema.PicklistEntry> pickList){
        String defaultValue = '';
        for(Schema.PicklistEntry entry : pickList){
            if(entry.isDefaultValue()){
                defaultValue = entry.getLabel();
                break;
            }
        }
        return defaultValue;
    }
    //this method will get the Task's Statuses
    public List<SelectOption> TaskStatusOption {
        get {
            if(TaskStatusOption == null){
                TaskStatusOption = new List<SelectOption>();
                for (Schema.PicklistEntry status : taskStatuses){
                    TaskStatusOption.add(new SelectOption(status.getLabel(), status.getLabel()));
                } 
            }
            return TaskStatusOption;
        }
        set;
    }
    public PageReference DueDateChanged(){
        remCon.taskId.ActivityDate = taskId.ActivityDate;
        return null;
    }
    //this method will get the Task's Priorities
    public List<SelectOption> TaskPriorityOption {
        get {
            if(TaskPriorityOption == null) {
                TaskPriorityOption = new List<SelectOption>();
                for (Schema.PicklistEntry priority : taskPriorities){
                    TaskPriorityOption.add(new SelectOption(priority.getLabel(), priority.getLabel()));
                } 
            }
            return TaskPriorityOption;
        }
        set;
    }
    // This method is called when the user clicks the Convert button on the VF Page
    public PageReference convertLead() {
        try{
            // This is the lead convert object that will convert the lead 
            Database.LeadConvert leadConvert = new database.LeadConvert();
            
            // if a due date is set but the subject is not, then show an error 
           if (string.isBlank(taskID.Subject) && taskId.ActivityDate !=null){
                PrintError('You must enter a Subject if a Due Date is set..');
                return null;
            } 
            
            // set Contact if already exist
            system.debug('===selectedContact==>'+selectedContact);
            List<Contact>con=new List<Contact>();
            if (selectedContact == 'NONE'){
                PrintError('Please select a Contact.');
                return null;
                
            }
            
            if(selectedContact!=null)
                con=  [select Id,Email,AccountId from Contact where Id=:selectedContact];
            //else
            //con =  [select Id,Email,AccountId from Contact where email =: leadToConvert.Email];
            
            system.debug('===con==>'+con);        
            //set lead ID
            leadConvert.setLeadId(leadToConvert.Id);    
            
            if (selectedAccount == 'NONE'){
                PrintError('Please select an Account.');
                return null;
                
            }
            
            // otherwise set the account id
            else if (selectedAccount != 'NEW') {
                leadConvert.setAccountId(selectedAccount);
            }
            //set the lead convert status
            leadConvert.setConvertedStatus(leadToConvert.Status);
            //set contactId if email exist
            if(con.size() > 0 ){
                leadConvert.setContactId(con[0].Id);
                leadConvert.setAccountId(con[0].AccountId);
            }
            
            //set the variable to create or not create an opportunity
            leadConvert.setDoNotCreateOpportunity(doNotCreateOppty);
            //set the Opportunity name
            leadConvert.setOpportunityName(((doNotCreateOppty)? null : opportunityID.Name));
            leadConvert.setOwnerId(contactId.ownerID);
            leadConvert.setSendNotificationEmail(sendOwnerEmail);
            system.debug('leadConvert --> ' + leadConvert);
            //convert the lead
            
            Database.LeadConvertResult leadConvertResult = Database.convertLead(leadConvert);
            
            if (leadConvertResult.success){
                // make sure that the task information component is being used and check to see if the user has filled out the Subject field 
                if(taskID.subject != null){
                    //create a new task
                    Task taskToCreate = new Task();
                    //set whether there is a reminder
                    taskToCreate.IsReminderSet= remCon.taskID.IsReminderSet;
                    
                    //if the reminder is set, and the reminder's date is set
                    if (taskToCreate.IsReminderSet && taskID.ActivityDate != null) {
                        //The date and time in the reminder class is converted into a datetime by the convertToDatetime() method
                        taskToCreate.ReminderDateTime = convertToDatetime(remCon.taskID.ActivityDate,remCon.reminderTime);
                        system.debug('taskToCreate.ReminderDateTime --> ' + taskToCreate.ReminderDateTime);
                        
                    }            
                    taskToCreate.WhatId = leadConvertResult.getOpportunityId();
                    taskToCreate.WhoId = leadConvertResult.getContactId();
                    taskToCreate.Subject = taskID.Subject;
                    taskToCreate.Status=taskID.Status;
                    taskToCreate.ActivityDate=taskID.ActivityDate;
                    taskToCreate.Priority =taskID.Priority;
                    //set the custom field Primary Resource (this is a custom field on the Task showing an example of adding custom fields to the page)
                    // taskToCreate.Primary_Resource__c =taskID.Primary_Resource__c;
                    
                    //set the Description field which comes from the leadConvertTaskDescComponent
                    taskToCreate.Description = taskID.Description;
                    
                    //if the sendNotificationEmail variable in the leadConvertTaskDescComponent class is set then send an email
                    /* if (sendNotificationEmail){
//create a new DMLOptions class instance
Database.DMLOptions dmlo = new Database.DMLOptions();
//set the trigger user email flag to true
dmlo.EmailHeader.triggerUserEmail = true;
//insert the task
database.insert(taskToCreate, dmlo);
}
else{*/
                    //if the sendNotificationEmail field was not checked by the user then simply insert the task
                    insert taskToCreate;
                    // }
                }
                
                // redirect the user to the newly created Account
                PageReference pageRef = new PageReference('/' + leadConvertResult.getAccountId());
                pageRef.setRedirect(true);
                return pageRef; 
            }
            else{
                //if converting was unsucessful, print the errors to the pageMessages and return null
                System.Debug(leadConvertResult.errors);
                PrintErrors(leadConvertResult.errors);
                return null;
            }
        }Catch (DMLException e) {
            ApexPages.addMessages(e);
        }
        return null;
    }
    //this method will take database errors and print them to teh PageMessages 
    public void PrintErrors(Database.Error[] errors){
        for(Database.Error error : errors){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, error.message);
            ApexPages.addMessage(msg);
        }
    }
    
    //This method will put an error into the PageMessages on the page
    public void PrintError(string error) {
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, error);
        ApexPages.addMessage(msg);
    } 
    // given a date and time, where time is a string this method will return a DateTime
    @testVisible
    private DateTime convertToDatetime(Date d, string t) {
        //String timeFormat = DateTimeUtility.LocaleToTimeFormatMap().get(UserInfo.getLocale());
        String timeFormat = LocaleToTimeFormatMap().get(UserInfo.getLocale());
        if (timeFormat != null && timeFormat.endsWith('a')) {
            string [] reminderTime = t.split(' ');
            string hour = reminderTime[0].split(':')[0];
            string min = reminderTime[0].split(':')[1];
            string AM_PM = reminderTime[1];
            integer hr = Integer.valueOf(hour);
            if (AM_PM.equalsIgnoreCase('PM')) hr += 12;
            return (DateTime.newInstance(d,Time.newInstance(hr,Integer.valueOf(min),0,0))); 
        }
        //If the user's local does not use AM/PM and uses 24 hour time
        else {
            string hour = t.split(':')[0];
            string min = t.split(':')[1];
            integer hr = Integer.valueOf(hour);
            return (DateTime.newInstance( d,Time.newInstance(hr,Integer.valueOf(min),0,0))); 
        }
    }
    public PageReference redirectLeadDetailPage(){           
        PageReference send = new PageReference('/'+currentLeadId);
        send.setRedirect(true);
        return send;   
    }
    public static Map<String, String> LocaleToTimeFormatMap() { 
        Map<String, String> locale_map = new Map<String, String>(); 
        locale_map.put('ar', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_AE', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_BH', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_JO', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_KW', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_LB', 'dd/MM/yyyy hh:mm a');
        locale_map.put('ar_SA', 'dd/MM/yyyy hh:mm a');
        locale_map.put('bg_BG', 'yyyy-M-d H:mm');
        locale_map.put('ca', 'dd/MM/yyyy HH:mm');
        locale_map.put('ca_ES', 'dd/MM/yyyy HH:mm');
        locale_map.put('ca_ES_EURO', 'dd/MM/yyyy HH:mm');
        locale_map.put('cs', 'd.M.yyyy H:mm');
        locale_map.put('cs_CZ', 'd.M.yyyy H:mm');
        locale_map.put('da', 'dd-MM-yyyy HH:mm');
        locale_map.put('da_DK', 'dd-MM-yyyy HH:mm');
        locale_map.put('de', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_AT', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_AT_EURO', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_CH', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_DE', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_DE_EURO', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_LU', 'dd.MM.yyyy HH:mm');
        locale_map.put('de_LU_EURO', 'dd.MM.yyyy HH:mm');
        locale_map.put('el_GR', 'd/M/yyyy h:mm a');
        locale_map.put('en_AU', 'd/MM/yyyy HH:mm');
        locale_map.put('en_B', 'M/d/yyyy h:mm a');
        locale_map.put('en_BM', 'M/d/yyyy h:mm a');
        locale_map.put('en_CA', 'dd/MM/yyyy h:mm a');
        locale_map.put('en_GB', 'dd/MM/yyyy HH:mm');
        locale_map.put('en_GH', 'M/d/yyyy h:mm a');
        locale_map.put('en_ID', 'M/d/yyyy h:mm a');
        locale_map.put('en_IE', 'dd/MM/yyyy HH:mm');
        locale_map.put('en_IE_EURO', 'dd/MM/yyyy HH:mm');
        locale_map.put('en_NZ', 'd/MM/yyyy HH:mm');
        locale_map.put('en_SG', 'M/d/yyyy h:mm a');
        locale_map.put('en_US', 'M/d/yyyy h:mm a');
        locale_map.put('en_ZA', 'yyyy/MM/dd hh:mm a');
        locale_map.put('es', 'd/MM/yyyy H:mm');
        locale_map.put('es_AR', 'dd/MM/yyyy HH:mm');
        locale_map.put('es_BO', 'dd-MM-yyyy hh:mm a');
        locale_map.put('es_CL', 'dd-MM-yyyy hh:mm a');
        locale_map.put('es_CO', 'd/MM/yyyy hh:mm a');
        locale_map.put('es_CR', 'dd/MM/yyyy hh:mm a');
        locale_map.put('es_EC', 'dd/MM/yyyy hh:mm a');
        locale_map.put('es_ES', 'd/MM/yyyy H:mm');
        locale_map.put('es_ES_EURO', 'd/MM/yyyy H:mm');
        locale_map.put('es_GT', 'd/MM/yyyy hh:mm a');
        locale_map.put('es_HN', 'MM-dd-yyyy hh:mm a');
        locale_map.put('es_MX', 'd/MM/yyyy hh:mm a');
        locale_map.put('es_PE', 'dd/MM/yyyy hh:mm a');
        locale_map.put('es_PR', 'MM-dd-yyyy hh:mm a');
        locale_map.put('es_PY', 'dd/MM/yyyy hh:mm a');
        locale_map.put('es_SV', 'MM-dd-yyyy hh:mm a');
        locale_map.put('es_UY', 'dd/MM/yyyy hh:mm a');
        locale_map.put('es_VE', 'dd/MM/yyyy hh:mm a');
        locale_map.put('et_EE', 'd.MM.yyyy H:mm');
        locale_map.put('fi', 'd.M.yyyy H:mm');
        locale_map.put('fi_FI', 'd.M.yyyy H:mm');
        locale_map.put('fi_FI_EURO', 'd.M.yyyy H:mm');
        locale_map.put('fr', 'dd/MM/yyyy HH:mm');
        locale_map.put('fr_BE', 'd/MM/yyyy H:mm');
        locale_map.put('fr_CA', 'yyyy-MM-dd HH:mm');
        locale_map.put('fr_CH', 'dd.MM.yyyy HH:mm');
        locale_map.put('fr_FR', 'dd/MM/yyyy HH:mm');
        locale_map.put('fr_FR_EURO', 'dd/MM/yyyy HH:mm');
        locale_map.put('fr_LU', 'dd/MM/yyyy HH:mm');
        locale_map.put('fr_MC', 'dd/MM/yyyy HH:mm');
        locale_map.put('hr_HR', 'yyyy.MM.dd HH:mm');
        locale_map.put('hu', 'yyyy.MM.dd. H:mm');
        locale_map.put('hy_AM', 'M/d/yyyy h:mm a');
        locale_map.put('is_IS', 'd.M.yyyy HH:mm');
        locale_map.put('it', 'dd/MM/yyyy H.mm');
        locale_map.put('it_CH', 'dd.MM.yyyy HH:mm');
        locale_map.put('it_IT', 'dd/MM/yyyy H.mm');
        locale_map.put('iw', 'HH:mm dd/MM/yyyy');
        locale_map.put('iw_IL', 'HH:mm dd/MM/yyyy');
        locale_map.put('ja', 'yyyy/MM/dd H:mm');
        locale_map.put('ja_JP', 'yyyy/MM/dd H:mm');
        locale_map.put('kk_KZ', 'M/d/yyyy h:mm a');
        locale_map.put('km_KH', 'M/d/yyyy h:mm a');
        locale_map.put('ko', 'yyyy. M. d a h:mm');
        locale_map.put('ko_KR', 'yyyy. M. d a h:mm');
        locale_map.put('lt_LT', 'yyyy.M.d HH.mm');
        locale_map.put('lv_LV', 'yyyy.d.M HH:mm');
        locale_map.put('ms_MY', 'dd/MM/yyyy h:mm a');
        locale_map.put('nl', 'd-M-yyyy H:mm');
        locale_map.put('nl_BE', 'd/MM/yyyy H:mm');
        locale_map.put('nl_NL', 'd-M-yyyy H:mm');
        locale_map.put('nl_SR', 'd-M-yyyy H:mm');
        locale_map.put('no', 'dd.MM.yyyy HH:mm');
        locale_map.put('no_NO', 'dd.MM.yyyy HH:mm');
        locale_map.put('pl', 'yyyy-MM-dd HH:mm');
        locale_map.put('pt', 'dd-MM-yyyy H:mm');
        locale_map.put('pt_AO', 'dd-MM-yyyy H:mm');
        locale_map.put('pt_BR', 'dd/MM/yyyy HH:mm');
        locale_map.put('pt_PT', 'dd-MM-yyyy H:mm');
        locale_map.put('ro_RO', 'dd.MM.yyyy HH:mm');
        locale_map.put('ru', 'dd.MM.yyyy H:mm');
        locale_map.put('sk_SK', 'd.M.yyyy H:mm');
        locale_map.put('sl_SI', 'd.M.y H:mm');
        locale_map.put('sv', 'yyyy-MM-dd HH:mm');
        locale_map.put('sv_SE', 'yyyy-MM-dd HH:mm');
        locale_map.put('th', 'M/d/yyyy h:mm a');
        locale_map.put('th_TH', 'd/M/yyyy, H:mm ?.');
        locale_map.put('tr', 'dd.MM.yyyy HH:mm');
        locale_map.put('ur_PK', 'M/d/yyyy h:mm a');
        locale_map.put('vi_VN', 'HH:mm dd/MM/yyyy');
        locale_map.put('zh', 'yyyy-M-d ah:mm');
        locale_map.put('zh_CN', 'yyyy-M-d ah:mm');
        locale_map.put('zh_HK', 'yyyy-M-d ah:mm');
        locale_map.put('zh_TW', 'yyyy/M/d a h:mm');
        return locale_map; 
    }
}