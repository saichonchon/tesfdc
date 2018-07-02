public class displayrelatedcontact{
    public String selectedAccount { get; set; }
    public opportunity oppRecord {get;set;}
    public Account accRecord {get;set;}
    public Contact conRec {get;set;}
    public String contactId { get; set; }
    public String contactId1 { get; set; }
    public String accountId { get; set; }  
    public String selAccountId{ get; set; }  
    public Id selectedAccId{get;set;} 
    public Boolean isChange = false;
    public Id conId { get; set; }
    public List<Contact> conlist {get;set;}
    public String accountName {get;set;}
    public List<ContactWrapper> listContactWrp {get;set;}
    public list<Contact> selectedConList {get;set;}
    public String primaryCon {get;set;}
    public String contactRole {get;set;}
    public String primaryConSelectedOnPage {get;set;}
    public List<contact>conList1{get;set;}    
    public String recordTypeId;
    public List<ContactWrapper> selectedContactWrapper {get; set;}
    public displayrelatedcontact() {
        
        listContactWrp = new List<ContactWrapper>();
        selectedContactWrapper = new list<ContactWrapper>();
        conList1=new List<Contact> ();
        selectedConList = new List<contact>();
        contactId = ApexPages.CurrentPage().getParameters().get('conid');
        accountId = ApexPages.CurrentPage().getParameters().get('accid');  
       /* Opportunity__c opRecordType = Opportunity__c.getInstance(userinfo.getUserId());
        
      system.debug('===opRecordType===>'+opRecordType);
        if(opRecordType.SelRecordType__c != null){
          recordTypeId=opRecordType.SelRecordType__c;
        }
        else{
        recordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('DND Opportunity').getRecordTypeId(); 
        }
         system.debug('====recordtypename ====>'+recordTypeId); */
        listContactWrp.clear();      
      //  opRecordType.Clear();
        
        if (contactId != null && contactId !='') {
            conId = contactId ;           
            String accountId = [Select AccountId from Contact where Id =:contactId].AccountId;
            accRecord = [Select Id from Account where Id =: accountId ];
            conRec = [Select Name,MQL_Flag_Contact__c,AccountId,MQL_age__c,Account.Name from Contact where Id =:contactId];
            System.debug('Con====>'+conRec);
            selectedConList.add(conRec);
            if(conRec<>null){                
                for (Contact con:[Select Id,AccountId,Name,MQL_age__c,Phone,Email,MQL_Flag_Contact__c,Account.Name from Contact where AccountId =:conRec.AccountId ]) {
                    listContactWrp.add(new ContactWrapper(con));
                    
                }
            }
            for(ContactWrapper wrapObj : listContactWrp) {
                if(wrapObj.con.Id == Id.valueOf(contactId)) {
                    System.debug('*****wrapper ');
                    wrapobj.con.Id = Id.valueOf(contactId);
                    wrapObj.selected = true;
                }
            }
            if (conRec != null)
            accountName = conRec.Account.Name;
            primaryCon = contactId ;            
        }
        
        if (accountId != null && contactId==null){
            system.debug('con::'+accountId);
            //oppRecord = [Select Id ,AccountId from Opportunity LIMIT 1];
            //String accountId = [Select AccountId from Contact where Id =:contactId].AccountId;
            //accRecord = [Select Id from Account where Id =: accountId ];
            system.debug('conRec1::'+conRec);
            accRecord = [Select Id,Name,(Select AccountId,Account.Name from Contacts)from Account where Id =: accountId ];
            //conRec = [Select AccountId,Account.Name from Contact where AccountId =:accountId];
            conList1=new List<contact>();
            conList1.addAll(accRecord.Contacts);
            // if Account is set but the Contact is not, then show an error 
            if(conList1.isEmpty()){
                ApexPages.Message errMsg= new ApexPages.Message(ApexPages.severity.INFO, 'Selected Account does not have any contact, A contact needs to be associated in order to create an opportunity !!');  
                ApexPages.addMessage(errMsg);
                
                //return null;       
            }
            system.debug('conRec::'+conRec);
            for (Contact con:[Select Id,AccountId,Name,Phone,Email,MQL_age__c,MQL_Flag_Contact__c,Account.Name from Contact where AccountId =:accountId]) {
                conRec=con;
                listContactWrp.add(new ContactWrapper(con));
                
            }
           if (conRec != null && conRec.AccountId != null)
                accountName = conRec.Account.Name;
        }
         getDefaultSelectedWrapper(); // calling for showing records defaulty .
        //getSelectedWrapper();
        
       }
    
    public PageReference showContacts(){
        if (listContactWrp != null)
            listContactWrp = new list<ContactWrapper>();
        system.debug('AccId::'+conRec);
        if(conRec != Null && conRec.AccountId != null) {
             conlist=[select Id,Name,Phone,Email,MQL_Flag_Contact__c,MQL_age__c,Account.Name from Contact where AccountId =: conRec.AccountId];
            }
         else if(accountId != Null){
            conlist=[select Id,Name,Phone,Email,MQL_Flag_Contact__c,MQL_age__c ,Account.Name from Contact where AccountId =:accountId];
        }
        
        if(conlist != null){
        for (Contact con:conlist) {
            listContactWrp.add(new ContactWrapper(con));
            
        }
        system.debug('listContactWrp'+listContactWrp);
        }
        //System.debug('***conlist '+conlist + '  '+conlist.size());
        if (conlist != null && conlist.size() > 0){
            accountName = conlist[0].Account.Name;
        }
       
        getSelectedWrapper();
        return null;   
    }
    public PageReference Cancel(){
        
        contactId = ApexPages.CurrentPage().getParameters().get('conid');
        accountId = ApexPages.CurrentPage().getParameters().get('accid');
        if(contactId != null && contactId !='')
        {
            PageReference Pg = new PageReference('/'+contactId);
            Pg.setRedirect(true);
            return Pg;
        }
        else if(accountId != null && accountId !='')
        {
            PageReference Pg1 = new PageReference('/'+accountId);
            Pg1.setRedirect(true);
            return Pg1;
        }
       else 
        {
            PageReference Pg2 = new PageReference('/006/o');
            Pg2.setRedirect(true);
            return Pg2;
        }
        
           // return null;
    }
    
    public PageReference gotoOpportunity(){
        System.debug('***primaryCon '+primaryCon );
        selectedConList = new list<Contact>();
       
        for(ContactWrapper wrapObj :selectedContactWrapper){//listContactWrp) {
            if(wrapObj.selected == true) {
                selectedConList.add(wrapObj.con);
            }
        }
        System.debug('***selectedConList '+selectedConList);
        String listSelectConIds= '';
        // if (selectedConList.size() == 1) listSelectConIds = con.Id;
        //else {
        for (Contact con: selectedConList) {
            listSelectConIds = listSelectConIds+';'+con.Id;
        }
        // }
        //system.debug('=contactId1=='+contactId1);
        //system.debug('=primaryCon=='+primaryCon);
        if(contactId!=contactId1 && contactId1<>''){
            primaryCon=contactId1;
        }
        else{
            primaryCon=contactId;
        }
        string AcntId =ApexPages.currentPage().getParameters().get('accid');
        system.debug('Lst>>'+AcntId);
       
        if(selAccountId==''){ 
            ApexPages.Message Msg= new ApexPages.Message(ApexPages.severity.INFO, 'Please select an Account to proceed');  
            ApexPages.addMessage(Msg);
            return null;
        }
        
         //---here create custom settings to pass primary and selected contacts in to trigger---
        system.debug('Lst>>'+listSelectConIds);
        //string AcntId =ApexPages.currentPage().getParameters().get('accid');
        if((AcntId != null && AcntId !='') || (listSelectConIds != null && listSelectConIds != '')){
        OppotunityContactRoletemp__c ocr= new OppotunityContactRoletemp__c();
                
        ocr.UserId__c=userinfo.getUserId();
        ocr.PrimaryId__c=primaryCon;
        ocr.SlectedContacts__c=listSelectConIds;
        ocr.Role__c='Opportunity Contact';
        upsert ocr UserId__c;
        }
        
        else 
        {
            //Error Msg
            ApexPages.Message Msg= new ApexPages.Message(ApexPages.severity.INFO, 'Please select one or more contacts.  Please note: One contact must be designated as Primary for the opportunity to be created successfully');  
            ApexPages.addMessage(Msg);
            return null;
        } 
        
        system.debug('primaryCon>>>'+primaryCon); 
        if(primaryCon == Null || primaryCon == ''){
            
            ApexPages.Message Msg= new ApexPages.Message(ApexPages.severity.WARNING, 'Please designate one of your contacts to be the primary contact');  
            ApexPages.addMessage(Msg);
            return null;
        }
        if( selectedConList == null && AcntId != null) 
        {
            ApexPages.Message Msg= new ApexPages.Message(ApexPages.severity.WARNING, 'Please select one or more contacts.  Please note: One contact must be designated as Primary for the opportunity to be created successfully');  
            ApexPages.addMessage(Msg);
            return null;
        }
       
        //===this is for getting field id to pass in to url==
      /*  Field_Id__c fldval= Field_Id__c.getInstance('PrimaryContact'); 
        Field_Id__c fldval1= Field_Id__c.getInstance('OtherContacts');
        string urlFildId;string urlFildId1;
        if(fldval != null) urlFildId=fldval.Field_id_value__c;
        if(fldval1 != null) urlFildId1=fldval1.Field_id_value__c;
        system.debug('Primary=='+primaryCon); */
        
        //PageReference p = new PageReference('/006/e?opp4='+accountName+'&'+urlFildId1+'='+listSelectConIds+'&'+urlFildId+'='+primaryCon ); 
        //PageReference p = new PageReference('/006/e?opp4='+accountName+'&00Ng0000002NelH='+listSelectConIds+'&00Ng0000002NemP='+primaryCon ); 
       
         // ====== Here create custom settings to pass RecordType =======
         /* SelectedRecordType__c  opRecordType = SelectedRecordType__c.getInstance(userinfo.getUserId());
         system.debug('===opRecordType===>'+opRecordType); */
        //if(opRecordType != null){
          //recordTypeId=opRecordType.SelRecordType__c;
        //}
        recordTypeId=ApexPages.currentPage().getParameters().get('RecordType');
        if(recordTypeId == null){
          recordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('DND Opportunity').getRecordTypeId(); 
        }
        //opRecordType.clear();
         system.debug('====recordtypename ====>'+recordTypeId); 
        
        system.debug('====recordtypename ====>'+recordTypeId);
        String accountI1;
        if(contactId != null){
            accountI1 = [Select AccountId from Contact where Id =:contactId].AccountId;
        }else
        {
                        accountI1 = accountId;

        }
        PageReference p = new PageReference('/006/e?opp4_lkid='+accountI1+'&RecordType='+recordTypeId);
        p.getParameters().put('nooverride','1');
        return p;
        
    } 
    
    // New CR- SelectedConList
     public PageReference getSelected()
    {
        
        selectedConList = new list<Contact>();
        selectedConList.clear();
        for(ContactWrapper conwrapper : listContactWrp)
        if(conwrapper.selected == true)
        selectedConList.add(conwrapper.con);
        system.debug('selectedConList===>'+selectedConList);
        return null;
    }
    
    public void setError(){
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select another primary contact !!'));
         getSelectedWrapper();
    }
    // New CR- SelectedConList
     public PageReference getSelectedWrapper(){   
        selectedContactWrapper = new list<ContactWrapper>();
        selectedContactWrapper.clear();
        string pricontactId = ApexPages.CurrentPage().getParameters().get('conid');
        for(ContactWrapper conwrapper : listContactWrp){            
            if(primaryConSelectedOnPage!=null && primaryConSelectedOnPage !=''  && id.valueof(primaryConSelectedOnPage) == conwrapper.con.id){  
               conwrapper.primarycon1 = true;  
              
            }else{
                conwrapper.primarycon1 = false;
            }      
            if(conwrapper.selected == true ||conwrapper.primarycon1==true)  {
               //conwrapper.primarycon1 = true;  
               selectedContactWrapper.add(conwrapper);
            }
           
        }
        return null;
    }
     public PageReference getDefaultSelectedWrapper(){   
        selectedContactWrapper = new list<ContactWrapper>();
        selectedContactWrapper.clear();
        for(ContactWrapper conwrapper : listContactWrp){                
            if(conwrapper.selected == true)  {
                 conwrapper.primarycon1 = true;  
                 primaryConSelectedOnPage = conwrapper.con.id;
                selectedContactWrapper.add(conwrapper);
            }
           
        }
        return null;
    } 
    public List<Contact> GetselectedConList()
    {
        system.debug('selectedConList11===>'+selectedConList);
        if(selectedConList.size()>0) 
        return selectedConList;         
        else
        return null;
    }    
    // Wrapper class
    public class ContactWrapper {
        public Boolean selected {get;set;}
        public Boolean primarycon1{get;set;}
        public Contact con {get;set;}
        public ContactWrapper(Contact con) {
            this.con = con;
            selected = false;
            primarycon1 = false;            
        }        
    }    
}