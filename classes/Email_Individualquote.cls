/*------------------------------------------------------------
Author:        Yiming Shen <yiming.shen@capgemini.com>
Description:   This class is used to send email to 'contact' of 'Quotation'
			   The user story number is W-00130.
Inputs:        
Test Class:    Email_IndividualquoteTest
History
2017-08-16 	   Yiming Shen <yiming.shen@capgemini.com> Created
------------------------------------------------------------*/
public class Email_Individualquote{
    id Oppid;
    public ID quoteid {get;set;}
    public String tId {get;set;}
    public String ContactName; 
    public string emailBody {get; set;}
    public string emailSubject {get; set;}
    Opportunity opp;
    User u;
    String accId;
    Public string toemailid{set;get;}
    Public string ccemailid{set;get;}
    public List<Opportunitycontactrole> oppContactRole{get;set;}
    public List<AttachmentSelection> orderAttachment{get;set;}
    public List<Attachment> orderAllAttachment{get;set;}
    public Map<ID, Attachment> attchMap = new Map<ID, Attachment>();
    //public Opportunity ord{set;get;}
    public Boolean showList{get;set;}
    public Boolean firstblock{get;set;}
    public Boolean secondblock{get;set;}
    public Boolean thirdblock{get;set;}
    public String toEmails{get;set;}
    public String sendAsValue {get;set;}
    public boolean okbuttonpanel{set;get;}
    Public string ccemails{set;get;}    
    public boolean isPrimaryContactFound{set;get;}  
    //Public opportunity opportunitycontact{set;get;}
    //Public opportunity opportunitycontact1{set;get;}
    public boolean emailSelected{get;set;}
    public boolean emailNotSelected{get;set;}
    public List<ContactInnerClass> contactInnerClassList{get;set;}
    public list<SelectOption> list_contactOptions {get;set;}
    public String selectedContId {get;set;}
    public Contact selectedCont {get;set;}
    public Energy_Quote__c quote {get;set;}
    public Boolean isClosePop {get;set;}
    
    public class ContactInnerClass{
        public Contact cont{get;set;}
        public String name{get;set;}
        public String email{get;set;}
        public boolean selected{get;set;}
        ID contactID;
        public Boolean isPrimary{get;set;}
        public ContactInnerClass(Contact oc,Boolean sel,Boolean isPrimary){
            this.cont = oc;
            this.name = oc.Name;
            this.email = oc.email;
            this.contactID = oc.id;
            this.selected = sel;
            this.isPrimary = isPrimary;
        }
    }
    
    /*------------------------------------------------------------
	Author:        Tangyong Li <tangyong.li@capgemini.com>
	Description:   The contsructor
	Inputs:        
	Returns:       
	History
	2017-08-16 	   Tangyong Li <tangyong.li@capgemini.com> created
	------------------------------------------------------------*/  
    public Email_Individualquote(){
        isClosePop = true;
        list_contactOptions = new list<SelectOption>();
        orderAttachment = new List<AttachmentSelection>();  
        Oppid= apexpages.currentpage().getparameters().get('id');
        quote = [SELECT Name,Id, Contact__c, valid_days__c, Email__c, Selected_Email_Template__c, 
                        Opportunity_Name__r.Customer_Contact_Name__c, Opportunity_Name__r.Customer_Contact_Name__r.Email 
                 FROM Energy_Quote__c 
                 WHERE Id =: apexpages.currentpage().getparameters().get('quoteId')];
        opp = [SELECT Id, Name, Customer_Contact_Name__c, TE_Reference_Number__c, Customer_Reference_Number__c, Type__c, 
        			  End_Customer__c, ERP_for_Pricing__c, Account.Sales_Hierarchy__c, Account.Sales_Hierarchy__r.Level_7_Default_Owner__c, 
        			  Account.Owner.Email, Customer_Contact_Name__r.Id, Customer_Contact_Name__r.Email, Customer_Contact_Name__r.Name, 
        			  Customer_Contact_Name__r.FirstName, Recordtype.DeveloperName, Account.Sales_Hierarchy__r.Level_7_Default_Owner__r.Email, 
        			  Customer_Contact_Name__r.LastName, CreatedById, CreatedBy.Name, OwnerId, Owner.Email, Account.Source_System__c, 
        			  Account.RecordType.Name, Date_Quoted__c   
               FROM Opportunity 
               WHERE Id =: oppId];
        map<string, user> usermap=new map<string,user>();
        for(user user : [select Id, Name, MED_Region__c from user]){
            usermap.put(user.id, user); 
            if(user.Id == userInfo.getUserId()) {
		        u = user;
            }
        }
        //opportunitycontact = [select id,name,Customer_Contact_Name__c,TE_Reference_Number__c,Customer_Reference_Number__c,Type__c,
        //					  		 Customer_Contact_Name__r.id,Customer_Contact_Name__r.email,Customer_Contact_Name__r.Name, 
        //					  		 Customer_Contact_Name__r.firstname,Customer_Contact_Name__r.lastname,createdbyid,createdby.name,ownerid,owner.email 
        //					  from Opportunity 
        //					  where (id=:Oppid)];
        //system.debug('===>'+ Opp.Customer_Contact_Name__r.email);
        if(opp!= null && opp.Customer_Contact_Name__c != null && opp.Customer_Contact_Name__r.email != null){
            toemailid = opp.Customer_Contact_Name__r.email;
        }       
        orderAttachment = new List<AttachmentSelection>();        
        toEmails = '';
        showList = true;
        emailNotSelected = true;
        emailSelected = false;
        okbuttonpanel = true;
        isPrimaryContactFound = false;
        List<Contact> contactList;
        accID = ApexPages.currentPage().getParameters().get('accid');
        //map<string,user> usermap=new map<string,user>();
        //for(user u : [select id,name from user]){
        //    usermap.put(u.id,u); 
        //}
        //if(opp!= null && opp.ownerid != null && opp.owner.email != null )
        //    system.debug('===cc'+ccemailid);
        //ccemailid = opp.owner.email;
        
        if(opp != null && opp.ownerid != null && opp.owner.email != null)
            ccemails = opp.owner.email;
            
        if(opp.Account.Sales_Hierarchy__c != null && Opp.Account.Sales_Hierarchy__r.Level_7_Default_Owner__c != u.Id) {
        	if(Opp.Account.Owner.Email != null) {
        		if(ccemails != null) {
        			if(ccemails.indexOf(Opp.Account.Owner.Email) == -1) {
            			ccemails += ','+Opp.Account.Owner.Email;
        			}
        		} else {
        			ccemails = Opp.Account.Owner.Email;
        		}
        	}
        	if(Opp.Account.Sales_Hierarchy__r.Level_7_Default_Owner__r.Email != null) {
        		if(ccemails != null) {
        			if(ccemails.indexOf(Opp.Account.Sales_Hierarchy__r.Level_7_Default_Owner__r.Email) == -1) {
            			ccemails += ','+Opp.Account.Sales_Hierarchy__r.Level_7_Default_Owner__r.Email;
        			}
        		} else {
        			ccemails = Opp.Account.Sales_Hierarchy__r.Level_7_Default_Owner__r.Email;
        		}
        	}
        }
            
        if(opp != null && opp.ownerid != null && usermap.get(opp.ownerid) != null)
            sendAsValue = usermap.get(opp.ownerid).name.touppercase();
        system.debug(sendAsValue +'se==');  
        
        selectedContId = opp.Customer_Contact_Name__c;
        if(selectedContId != null && selectedContId != '') {
            selectedCont = [SELECT Id, Name, Email FROM Contact WHERE Id =: selectedContId];
        }
        
        if(accid != null && accid.trim().length() > 0){
            //contactList = [SELECT id,name,Email FROM Contact WHERE (AccountId =: accid AND Email != null And Email != '' AND owner.profileID=:userinfo.getProfileId())];
            contactList = new list<Contact>();
            for(Contact cont : [SELECT id,name,Email FROM Contact WHERE AccountId =: accid]){
                contactList.add(cont);
            }
        }
        
        
            
        contactInnerClassList = new List<ContactInnerClass>();
        ContactInnerClass contactInnrClass;
        Set<String> uniqueContact = new Set<String>();
        Boolean eamilPresent = false;
        Boolean contactPresent = false;
        
        if(contactList != null && contactList.size() > 0){
            contactPresent = true;
            for(Contact cont : contactList){
                if(cont.Email != null && cont.Email != '')
                {   
                    eamilPresent = true;
                    if(uniqueContact.add(cont.id))     
                        contactInnerClassList.add(new ContactInnerClass(cont,false,false));
                }
                
            }
            if(selectedContId != null && selectedContId != '' && uniqueContact.add(selectedContId)) {
                contactInnerClassList.add(new ContactInnerClass(selectedCont,true,false));
            }
        }
        if(selectedContId != null && selectedContId != '' && uniqueContact.add(selectedContId)) {
            contactPresent = true;
            contactInnerClassList.add(new ContactInnerClass(selectedCont,true,false));
            if(quote.Opportunity_Name__r.Customer_Contact_Name__r.Email != null && quote.Opportunity_Name__r.Customer_Contact_Name__r.Email != '') {
                eamilPresent = true;
            }
        }
        // Get the Attachment Related to this Order
        orderAttachment.add(new AttachmentSelection(true,generateDefaulteAttach()));
        system.debug('oppyId::::::::: ' + oppId);
        system.debug('accID::::::::: ' + accID);
        list<Attachment> orderAllAttachment = [SELECT ContentType,Description,Name,ParentId,BodyLength,Body FROM Attachment WHERE ParentId=:oppID];
        //for(Attachment att1 : orderAllAttachment){   
        //    system.debug('===at'+att1.name);  
        //    attchMap.put(att1.id,att1);
        //}
        for(Attachment att : orderAllAttachment){ 
            system.debug('===at2nd'+att.name);      
            attchMap.put(att.id,att);
            att.Body = null;
            orderAttachment.add(new AttachmentSelection(false,att));
        }          
    }
    
    public void prepareAttachment(){
        showList = true; 
        okbuttonpanel = false;
    }
    public void showAttachment(){
        showList = true;
        okbuttonpanel =true;
    } 
    //<!----- Select Mail -->
    
    public list<Account> getEndCustomerAcctsFromOppy(Opportunity oppy) {
    	return [SELECT Id, Sales_Hierarchy__c, Sales_Hierarchy__r.Level_4_Territory_Code__c, 
                       Sales_Hierarchy__r.Level_5_Territory_Code__c, RecordType.Name, OwnerId 
                FROM Account WHERE Id =: oppy.End_Customer__c limit 1];
    }
    
    /*
    public list<Account> getStandAcctsFromOppy(Opportunity oppy) {
    	return [SELECT Id, Sales_Hierarchy__c, Sales_Hierarchy__r.Level_4_Territory_Code__c, 
                       Sales_Hierarchy__r.Level_5_Territory_Code__c, RecordType.Name, OwnerId 
                FROM Account WHERE Id =: oppy.AccountId limit 1];
    }
    */
    
    /*------------------------------------------------------------
	Author:        Tangyong Li <tangyong.li@capgemini.com>
	Description:   Method to get email templates.
	Inputs:        
	Returns:       list<SelectOption> - the list of SelectOption objects
	History
	2017-08-16 	   Tangyong Li <tangyong.li@capgemini.com> created
	------------------------------------------------------------*/ 
    public list<SelectOption> gettemplates() {
        list<SelectOption> templates = new list<SelectOption>();
        set<String> set_templateNames = new set<String>();
        String level4TerritoryCode = '';
        String level5TerritoryCode = '';
        String acctOwnerId = '';
        Boolean isProspectAcct = false;
        for(Account acct : getEndCustomerAcctsFromOppy(Opp)) {  
            if(acct.RecordType.Name == 'Prospect') {
                acctOwnerId = acct.OwnerId;
                isProspectAcct = true;
            } else {
                if(acct.Sales_Hierarchy__r.Level_4_Territory_Code__c != null) {
                    level4TerritoryCode = acct.Sales_Hierarchy__r.Level_4_Territory_Code__c;
                }
                if(acct.Sales_Hierarchy__r.Level_5_Territory_Code__c != null) {
                    level5TerritoryCode = acct.Sales_Hierarchy__r.Level_5_Territory_Code__c;
                }
            }
        }
        if(isProspectAcct) { 
            list<Territory_Email_Template__c> list_level5Temps = [SELECT Id, Email_Template_Name__c, Level_4_Territory_Code__c, Level_5_Territory_Code__c 
                                                                  FROM Territory_Email_Template__c];
            //START - Modifed by Tangyong Li <tangyong.li@capgemini.com> at 2017-12-27
            /*list<Territory_Email_Template__c> list_level4Temps = [SELECT Id, Email_Template_Name__c, Level_4_Territory_Code__c, Level_5_Territory_Code__c 
                                                                  FROM Territory_Email_Template__c];*/
            //END - Modifed by Tangyong Li <tangyong.li@capgemini.com> at 2017-12-27
            for(Sales_Hierarchy__c sh : [SELECT Id, Level_7_Assigned_Users__c, Level_4_Territory_Code__c, Level_5_Territory_Code__c 
                                         FROM Sales_Hierarchy__c 
                                         WHERE Level_7_Assigned_Users__c =: acctOwnerId]) {
                Boolean flag = false;
                if(sh.Level_5_Territory_Code__c != null) {
                    for(Territory_Email_Template__c t : list_level5Temps) {
                        if(t.Level_5_Territory_Code__c == sh.Level_5_Territory_Code__c) {
                            set_templateNames.add(t.Email_Template_Name__c);
                            flag = true;
                            break;
                        }
                    }
                }
                if(!flag && sh.Level_4_Territory_Code__c != null) {
                    for(Territory_Email_Template__c t : list_level5Temps) {
                        if(t.Level_4_Territory_Code__c == sh.Level_4_Territory_Code__c) {
                            set_templateNames.add(t.Email_Template_Name__c);
                            break;
                        }
                    }
                }
            }
        } else {
            if(level5TerritoryCode != '') {
                for(Territory_Email_Template__c terrEmail : [SELECT Id, Email_Template_Name__c, Level_4_Territory_Code__c, Level_5_Territory_Code__c 
                                                             FROM Territory_Email_Template__c 
                                                             WHERE Level_5_Territory_Code__c =: level5TerritoryCode]) {
                    set_templateNames.add(terrEmail.Email_Template_Name__c);
                }
            } 
            if(set_templateNames.size() ==0 && level4TerritoryCode != '') {
                for(Territory_Email_Template__c terrEmail : [SELECT Id, Email_Template_Name__c, Level_4_Territory_Code__c, Level_5_Territory_Code__c 
                                                             FROM Territory_Email_Template__c 
                                                             WHERE Level_4_Territory_Code__c =: level4TerritoryCode]) {
                    set_templateNames.add(terrEmail.Email_Template_Name__c);
                }
            }
        }
        system.debug('set_templateNames222::: ' + set_templateNames);
        templates.add(new SelectOption('-None-','-None-'));
       	//START - Modifed by Tangyong Li <tangyong.li@capgemini.com> at 2017-12-27
        /*for(EmailTemplate e : [SELECT Id, Name, Subject, Body, CreatedDate FROM EmailTemplate WHERE Name IN: set_templateNames order by name]) {
            if(e.Id != null && e.Name != null) {
                templates.add(new SelectOption(e.Id, e.Name));
            }
        }
        for(EmailTemplate e : [SELECT Id, Name, DeveloperName, Subject, Body, CreatedDate FROM EmailTemplate WHERE DeveloperName = 'Energy_Quote_Default_Template' limit 1]) {
            templates.add(new SelectOption(e.Id, e.Name));
        }*/
        EmailTemplate lastTemplate = null; 
        for(EmailTemplate e : [SELECT Id, Name, Subject, Body, CreatedDate, DeveloperName FROM EmailTemplate 
        						WHERE Name IN: set_templateNames 
        						OR DeveloperName = 'Energy_Quote_Default_Template'
        						order by name]) {
            if(e.DeveloperName == 'Energy_Quote_Default_Template'){
            	lastTemplate = e;
            	continue;
            }
            if(e.Id != null && e.Name != null) {
                templates.add(new SelectOption(e.Id, e.Name));
            }
        }
        templates.add(new SelectOption(lastTemplate.Id, lastTemplate.Name));
        //END - Modifed by Tangyong Li <tangyong.li@capgemini.com> at 2017-12-27
        return templates;
    } 
    
    /*------------------------------------------------------------
	Author:        Tangyong Li <tangyong.li@capgemini.com>
	Description:   Method to populate emaol template in the page.
	Inputs:        
	Returns:       
	History
	2017-08-16 	   Tangyong Li <tangyong.li@capgemini.com> created
	------------------------------------------------------------*/ 
    public void populatetemplate() {
        firstblock=false;
        secondblock=true;
        thirdblock=false;
        if(tid != null && tid != '-None-'){ 
            list<EmailTemplate> list_templates = [SELECT ID,name, DeveloperName, body,HtmlValue, Subject 
                                                  FROM EmailTemplate WHERE id= :tid];
            EmailTemplate template;
            if(list_templates.size() > 0) {
                template = list_templates[0];
            }
            if(template != null){
                quote.Selected_Email_Template__c = template.Name;
                emailSubject = template.subject;  
                emailBody = template.HtmlValue;
                emailSubject = (String.isNotBlank(Opp.name))? emailSubject.replaceall('\\{!Opportunity\\.Name\\}', ' '+ Opp.name +' ') : emailSubject.replaceall('\\{!Opportunity\\.Name\\}', ' ');
                emailSubject = (String.isNotBlank(Opp.Customer_Reference_Number__c))? emailSubject.replaceall('\\{!Opportunity\\.Customer_Reference_Number__c\\}', ' '+ Opp.Customer_Reference_Number__c + ' '):emailSubject.replaceall('\\{!Opportunity\\.Customer_Reference_Number__c\\}', ' ');      
                
                if(selectedCont != null) {
                    emailBody = (String.isNotBlank(selectedCont.Name)) ? emailBody.replaceAll('\\{!Opportunity\\.Customer_Contact_Name__c\\}',  ' '+ selectedCont.Name +' '):emailBody.replaceAll('\\{!Opportunity\\.Customer_Contact_Name__c\\}', ' ');
                } else if(contactInnerClassList.size() > 0) {
                    string ContactName;
                    for(integer i=0;i<contactInnerClassList.size();i++){
                        if(contactInnerClassList[i].selected){
                            ContactName = contactInnerClassList[i].name;
                        }
                    }
                    system.debug('ContactName:::::::  ' + ContactName);
                    emailBody = (String.isNotBlank(ContactName)) ? emailBody.replaceAll('\\{!Opportunity\\.Customer_Contact_Name__c\\}',  ' '+ ContactName +' '):emailBody.replaceAll('\\{!Opportunity\\.Customer_Contact_Name__c\\}', ' ');
                }
                
                for(User use : [select id,name,Region__c,MobilePhone,phone,title,email,Street,City,State,PostalCode,Country 
                                from user where id =: userinfo.getuserid()]){
                                    if(use != null)
                                        u= use;
                                }
                System.debug('---u:::'+u);
                system.debug(tid+'ttt==');
                if(u != null){ 
                    emailBody = (String.isNotBlank(u.name))? emailBody.replaceAll('\\{!User\\.Name\\}', '<b><font color="#0489B1" size="2">'+u.name +'</font></b> '  ): emailBody.replaceAll('\\{!User\\.Name\\}', ' ');    
                    emailBody = emailBody.replaceall('Dear  \\{!Contact\\.Name\\} ,', ' ' );//Dear {!Contact.Name} 
                    emailBody = (String.isNotBlank(u.MobilePhone))? emailBody.replaceAll('\\{!User\\.MobilePhone \\}',  ' '+ U.MobilePhone +' '): emailBody.replaceAll('\\{!User\\.MobilePhone\\}', ' ');
                    emailBody = (String.isNotBlank(Opp.TE_Reference_Number__c))? emailBody.replaceAll('\\{!Opportunity\\.TE_Reference_Number__c\\}',  ' '+ Opp.TE_Reference_Number__c +' '): emailBody.replaceAll('\\{!Opportunity\\.TE_Reference_Number__c\\}', ' ');
                    emailBody = (String.isNotBlank(u.Title))? emailBody.replaceAll('\\{!User\\.Title\\}',  ' '+ U.Title +' '): emailBody.replaceAll('\\{!User\\.Title\\}', ' ');
                    emailBody = (String.isNotBlank(u.Region__c))? emailBody.replaceAll('\\{!User\\.Region__c\\}',  ' '+ U.Region__c +' '): emailBody.replaceAll('\\{!User\\.Region__c\\}', ' ');
                    emailBody = (String.isNotBlank(u.Phone))? emailBody.replaceAll('\\{!User\\.Phone\\}',  ' '+ U.Phone +' '): emailBody.replaceAll('\\{!User\\.Phone\\}', ' ');
                    emailBody = (String.isNotBlank(u.Email))? emailBody.replaceAll('\\{!User\\.Email\\}',  ' '+ U.Email +' '): emailBody.replaceAll('\\{!User\\.Email\\}', ' ');
                    String userAddress = ' ';
                    if(String.isNotBlank(U.Street)) userAddress+= U.Street + ' ';
                    if(String.isNotBlank(U.City)) userAddress+= U.City + ' ';
                    if(String.isNotBlank(U.State)) userAddress+= U.State + ' ';
                    if(String.isNotBlank(U.PostalCode)) userAddress+= U.PostalCode + ' ';
                    if(String.isNotBlank(U.Country)) userAddress+= U.Country + ' ';
                    emailBody = emailBody.replaceAll('\\{!User\\.Address\\}',  userAddress);
                }
            }
        }
    }
    
    /*------------------------------------------------------------
	Author:        Tangyong Li <tangyong.li@capgemini.com>
	Description:   Method to generate default attachment for the email.
	Inputs:        
	Returns:       a - Attachment
	History
	2017-08-16 	   Tangyong Li <tangyong.li@capgemini.com> created
	------------------------------------------------------------*/ 
    public Attachment generateDefaulteAttach() {
        PageReference pageRef;
        blob body;
        
        //Modified by yuan yao 2017-10-25  use existed pdf as email attachment
        Attachment a = new Attachment();
        for(Attachment atta : [SELECT ContentType,Description,Name,ParentId,BodyLength,Body FROM Attachment WHERE ParentId =:quote.Id order by createdDate desc limit 1]){
            a = atta;
        }
        if(a != null&& a.Body != null){
            return a;
        }else{
            if(Opp.ERP_for_Pricing__c == 'SAP (except ANZPAC)'){
                pageRef = new PageReference('/apex/SAPQuotePdf?id='+quote.Id);
            }else if(Opp.ERP_for_Pricing__c == 'MFGPRO'){
                pageRef = new PageReference('/apex/MFGPROQuotePdf?id='+quote.Id );
            }else if(Opp.ERP_for_Pricing__c == 'ANZPAC'|| (Opp.account.recordtype.name == 'Prospect'&& u.MED_Region__c == 'Aus / New Zlnd')){
                pageRef = new PageReference('/apex/AMPICSQuotePdf?id='+quote.Id );             
            }else{
                pageRef = new PageReference('/apex/SAPQuotePdf?id='+quote.Id);
            }
            
            a.ContentType = 'application/pdf';
            a.Name = quote.Name + '.pdf';
            if(!Test.isRunningTest()) {
                a.body = pageRef.getContentAsPDF();
            }
            a.Description = 'Quote PDF';
            return a;
        }
    }
    
    /*------------------------------------------------------------
	Author:        Tangyong Li <tangyong.li@capgemini.com>
	Description:   Method to send the email.
	Inputs:        
	Returns:       
	History
	2017-08-16 	   Tangyong Li <tangyong.li@capgemini.com> created
	------------------------------------------------------------*/ 
    public void send_templates(){
        blob body;
        if(Opp!= null ){
            OpportunityContactRole oppyContRole;
            selectedContId = quote.Opportunity_Name__r.Customer_Contact_Name__c;
            if(selectedContId != null && selectedContId != '') {
                selectedCont = [SELECT Id, Name, Email FROM Contact WHERE Id =: selectedContId];
                if(selectedCont.Email != null) {
                    isClosePop = true;
                    quote.Contact__c = selectedContId;
                    toemails = selectedCont.Email;
                    quote.Email__c = selectedCont.Email;
                } else {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.info,'The selected contact does not have a valid email address. Please update the contact\'s email and re-send this email.'));
                    isClosePop = false;
                    return;
                }
                if(selectedContId != Opp.Customer_Contact_Name__c) {
                    set<String> set_ContIds = new set<String>();
                    for(OpportunityContactRole contRole : [SELECT ContactId, Id, CreatedById, CreatedDate, IsDeleted, LastModifiedById, LastModifiedDate, 
                                                                  OpportunityId, IsPrimary, Role, SystemModstamp 
                                                           FROM OpportunityContactRole
                                                           WHERE OpportunityId =: Oppid]) {
                        set_ContIds.add(contRole.ContactId);
                    }
                    if(!set_ContIds.contains(selectedContId)) {
                        oppyContRole = new OpportunityContactRole();
                        oppyContRole.OpportunityId = Oppid;
                        oppyContRole.ContactId = selectedContId;
                        oppyContRole.Role = 'Decision Maker';
                    }
                }
            } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.info,'Please select a contact for the email address.'));
                isClosePop = false;
                return;
            }
            
            PageReference pdf;
            Task taskNew = new Task();
            taskNew.whatID = apexpages.currentpage().getparameters().get('id');
            if(Opp.Type__c == 'Quote'){
                taskNew.Subject = 'Sent Quote to customer';
            }
            else if(Opp.Type__c == 'Tender'){
                taskNew.Subject = 'Sent Tender to customer';
            }
            else if(Opp.Type__c == 'Contract'){
                taskNew.Subject = 'Sent Contract to customer';
            }else{
                taskNew.Subject = 'Sent to customer';
            }
            
            taskNew.Status = 'Completed';
            taskNew.Priority = 'Medium';
            if(!Test.isRunningTest()) {
                insert taskNew;
            }
            
            //List<Contact> contList = [SELECT id,name,Email FROM Contact where (owner.profileID=:userinfo.getProfileId()) limit 100];
            
            List<Messaging.EmailFileAttachment> allAttachment = new List<Messaging.EmailFileAttachment>();
            for(AttachmentSelection ast : orderAttachment){
                if(ast.selected == true){
                    Messaging.EmailFileAttachment tempAttach = new Messaging.EmailFileAttachment();
                    tempAttach.setContentType(ast.attach.ContentType);
                    tempAttach.setFileName(ast.attach.Name);
                    tempAttach.setInline(false);
                    tempAttach.Body = Blob.valueOf('Some Text');
                    if(ast.attach.id != null) {
                        tempAttach.Body = [select body from Attachment where id =:ast.attach.id].body;
                    } else {
                        tempAttach.Body = ast.attach.body;
                    }
                    allAttachment.add(tempAttach);
                }
                
            }
            
            //Integer i = 0;
            String tempEmailBody;
            string plainbody;
            list<task> Tasklist = new list<task>();
            tempEmailBody = emailBody;
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] ccAddresses;
            String[] toAddresses;
            if(ccemails != null && ccemails != '') {
                ccAddresses = ccemails.split(',');
            }
            if(toemails != null && toemails != ''){
                toAddresses =toemails.split(',');
            }else{
                if(toemailid!=null){
                    toAddresses =toemailid.split(',');
                }
            }
            mail.setToAddresses( toAddresses );
            if(ccAddresses != null)
                mail.setCcAddresses(ccAddresses );
            mail.setWhatId(oppID);
            mail.setUseSignature(true);
            mail.setSubject(emailSubject);
            mail.setFileAttachments(allAttachment);
            mail.setplaintextBody(plainbody);
            mail.setHtmlBody(tempEmailBody );
            system.debug('mail::::  ' + mail); 
            Messaging.SendEmailResult [] r;
            try{
                r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
                
                if (r[0].success){
                    update quote;
                    //BatchClsEnergyQuoteValidityExpiration batch = new BatchClsEnergyQuoteValidityExpiration();
                    //Database.executeBatch(batch);
                    if(oppyContRole != null) {
                        insert oppyContRole;
                    }
                    system.debug('====em'+r[0].success);
                    //i++; 
                }   
            }catch(Exception e){
            	System.debug('---e:::' + e.getMessage());
            	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, e.getMessage()));
				//ErrorLogging.Log(e);
				String vStrError = '';
				vStrError += 'Error Type = ' + e.getTypeName() + 
                ' Error Line = ' + e.getLineNumber() + '' + 
                ' Error Stack = ' + e.getStackTraceString() + 
                ' Error Message = ' + e.getMessage();
            	SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,                   
                	SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '',e.getStackTraceString());
        	}                   
        }
    }
    // <!----- Templates End ----->
    //Rossi      
    public class AttachmentSelection{
        public Boolean selected {get;set;}
        public Attachment attach {get;set;}
        public String cssAttribute {get;set;}
        public AttachmentSelection(Boolean checked,Attachment att){
            this.selected = checked;
            this.attach = att;
            if(att.ContentType == 'application/pdf') this.cssAttribute = 'sprite-doctype_pdf_16';
            else if(att.ContentType == 'image/jpeg') this.cssAttribute = 'sprite-doctype_image_16';
            else if(att.ContentType == 'application/vnd.openxmlformats-officedocument.wordprocessingml.document') this.cssAttribute = 'sprite-doctype_gdoc_16';
            else if(att.ContentType == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') this.cssAttribute = 'sprite-doctype_excel_16';
            else if(att.ContentType == 'application/vnd.ms-excel') this.cssAttribute = 'sprite-doctype_csv_16';
            else if(att.ContentType == 'application/vnd.openxmlformats-officedocument.presentationml.presentation') this.cssAttribute = 'sprite-doctype_ppt_16';
            else if(att.ContentType == 'text/plain') this.cssAttribute = 'sprite-doctype_txt_16';
        }
    }     
    //Rossi end
    
    //commented by Tangyong Li 2018-01-19
    /*
    public String getSignatureUrl(){
        String path = '';
        Document dcm;
        
        for(Document dcm1 : [SELECT id,url,FolderId,name,DeveloperName FROM Document WHERE name=:'Tyco' AND Folder.name = 'Tyco' LIMIT 1])
        {
            if(dcm1 != null)
                dcm=dcm1;
        }
        if(dcm != null )
            path = URL.getSalesforceBaseUrl().toExternalForm().replace('visual.force.com','content.force.com/servlet/servlet.ImageServer?id='+dcm.id+'&oid='+UserInfo.getOrganizationId());
        
        return path.trim();
    }*/
    /*
    ID selectedcontactid;
    public void assignselectedcontact()
    {
        system.debug(opportunitycontact.Customer_Contact_Name__c +'con==');
        selectedcontactid = opportunitycontact.Customer_Contact_Name__c;
        opportunitycontact.Customer_Contact_Name__c = selectedcontactid ;
        
    }*/
}