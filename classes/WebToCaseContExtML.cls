/***********************************************************************************************************************
 Name: WebToCaseContExtML
 Org : Central QA
 Copyright : © 2015 TE Connectivity 
========================================================================================================================
 Summary : Logic for WebTocaseML site page in TE.site  
 -----------------------------------------------------------------------------------------------------------------------
 VERSION  AUTHOR              DATE           DETAIL                                 MERCURY REQUEST #
 -----------------------------------------------------------------------------------------------------------------------
   1.0                                                                               4043673
***********************************************************************************************************************/ 
 public class WebToCaseContExtML
 {
        private ApexPages.StandardController stdController;
        public PageReference successfulPage = ApexPages.currentPage();
        public String successfulString = ApexPages.currentPage().getParameters().get( 'successful' );
        public String vEmail      {get;set;}
        public String vfirstName  {get;set;}
        public String vLastname   {get;set;}
        public String vStreet     {get;set;}
        public String vCity       {get;set;}
        public string vZip        {get;set;}
        public String vState      {get;set;}
        public String vAddress {get;set;}
        public String vcountryid {get;set;}
        public string vphone {get;set;}
        public String  vCompany  {get;set;}
        public String  vLg {get;set;}
        public string vPartNum {get;set;}
        public string vCmpPartNum  {get;set;}
        public String  vCmpname {get;set;}
        public String vProduct {get;set;} 
        public string paramURL{get;set;}
        public Boolean canSubmit = false;
        public boolean vOutputType{get;set;}
        public boolean vInputType{get;set;}
        public Case caseInstance {get;set;}
        private Map<String, Schema.Sobjectfield> caseFieldsMap = Case.getsObjectType().getDescribe().fields.getMap();
        private Map<String, Schema.Sobjectfield> contactFieldsMap = Contact.getsObjectType().getDescribe().fields.getMap();
        public Transient Blob fileBody {get; set;}
        public PICMLanguage vPICLan1 {get;set;}
        public static map<string,string> mapParams {get;set;}
        public boolean emailCheck {get;set;}
        public string errormessage {get;set;}
        
 //This method Used for getting Url parameter values and building parameters map       
 public void getPageparameters()
 { 
        mapParams = new map<string,string>();
        //if(!Test.isRunningTest())
        paramURL = URL.getCurrentRequestUrl().getQuery();
        
        list<string> paramset = new list<string>();
        list<string> lstMap = new list<string>();
        system.debug('paramURL&&&&&'+paramURL);
        if(paramURL!='' && paramURL !=null)
        {
            string Decode = EncodingUtil.urlDecode(paramURL,'UTF-8');
            if(Decode!=null && Decode.endsWith('%3D%3D'))
            Decode = Decode.substring(0,Decode.length()-6);
            if(Decode!=null && Decode.endsWith('%3D'))
            Decode = Decode.substring(0,Decode.length()-3);
            
            Blob Url2  = EncodingUtil.base64Decode(Decode);
            Decode   = Url2.toString();
            paramset  = Decode!=null && Decode.contains('&')? Decode.split('&'):new list<string>{Decode};
            system.debug('paramset&&&&&'+paramset  );
            for(string str : paramset )
            {
                if(str.endsWith('='))
                {
                    str = str+' ';
                }
                system.debug('str&&&&&'+str);
                lstMap  = str.split('=');
                mapParams.put(lstMap[0],EncodingUtil.urlDecode(lstMap[1],'UTF-8'));
            }
         }
        
        if(!mapParams.isEmpty() && mapParams.keySet().size()>0)
        {
             vEmail = mapParams.get('p_email.addr');
             vfirstName = mapParams.get('p_name.first');
             vLastname = mapParams.get('p_name.last');
             vStreet = mapParams.get('p_addr.street');
             vCity = mapParams.get('p_addr.city');
             vZip = mapParams.get('p_addr.postal_code')!=null && mapParams.get('p_addr.postal_code')!='' ?mapParams.get('p_addr.postal_code'):'';
             vState = mapParams.get('p_addr.state');
             vcountryid = mapParams.get('p_addr.country_id ');
             vphone = mapParams.get('p_ph_office')!=null ?mapParams.get('p_ph_office'):'';
             vCompany = mapParams.get('p_company_name');
             vLg = mapParams.get('p_lg');
             vPartNum = mapParams.get('p_part_no')!=null?mapParams.get('p_part_no'):'';
             vCmpPartNum = mapParams.get('p_competitor_part_no')!=null?mapParams.get('p_competitor_part_no'):'';
             vCmpname = mapParams.get('p_competitor_name');
             vProduct = mapParams.get('p_product')!=null ? mapParams.get('p_product'):'';
        }
        if(Vemail!=null && Vemail!='')
        {
             vInputType = false;
             vOutputType = true;
        } 
        else{
            vInputType = true;
            vOutputType = false;
        } 
 }   
 
 // Attachment Instantiation  
 public Attachment attachment 
 {
        get {
            if (attachment == null) attachment = new Attachment();
            return attachment;
        }
        set;
 }
 
 //This methos is used to get Category Picklist values  
 public List<selectOption> categoryOptions
 {
        get{
             system.debug('sanghita@@@ category'+vPICLan1.vLstCategorySO); return vPICLan1.vLstCategorySO ;
        }
 }
 
 //This methos is used to get country picklist values  
 public List<selectOption> countryOptions   
 {
        get{
             return vPICLan1.vLstCountrySO;
        }
 }
 
 //This methos is used to get typeOfCustomer Picklist values   
 public List<selectOption> typeOfCustomerOptions{
        get{
              return vPICLan1.vLstTypeOfCustSO;
        }
 }
 
 //Contact object variable Instantiation  
 public Contact contactInstance {
       get{
            if( contactInstance != null ){
                  return contactInstance ;
            } else {
                contactInstance = new Contact();
                return contactInstance ;
            }
       } 
       set;
 }

 //This method is used for show or hide to contact found block section
 public Boolean renderContactFoundBlockSection {
        get{
            if( renderContactFoundBlockSection != null ){
                return renderContactFoundBlockSection;
            } else {
                return false;
            }
        } 
        set;
 }
 
 //This method is used for show or hide to contact fill in block section
 public Boolean renderContactFillInBlockSection {
        get{
            if( renderContactFillInBlockSection != null ){
                return renderContactFillInBlockSection;
            } else {
                return false;
            }
        } 
        set;
 }
 
 //This method is used for show or hide the section
 public Boolean renderEnterBlock{
        get{
            if( renderEnterBlock!= null ){
                return renderEnterBlock;
            } else {
                return true;
            }
        } 
        set;
 }
 
 //This method is used for applying style to component
 public Boolean renderStyleBlock{
        get{
            if( renderStyleBlock!= null ){
                return renderStyleBlock;
            } else {
                return false;
            }
        } 
        set;
 }
 
 //This method is used for rendering outputpanel
 public Boolean renderSubmittedBlock{
        get{
            if( renderSubmittedBlock != null ){
                return renderSubmittedBlock;
            } else {
                return false;
            }
        } 
        set;
 }
 
 //This method is used for refreshing the entire main block
 public Boolean renderMain{
        get{
            if( renderMain != null ){
                return renderMain;
            } else {
                return true;
            }
        } 
        set;
 }
 
 //This method is used for field to make read only or not
 public Boolean required{
        get{
            if( required!= null ){
                return required;
            } else {
                return false;
            }
        } 
        set;
 }
 
 public WebToCaseStrings__c webToCaseStrings {
        get{
            if( webToCaseStrings != null ){
                return webToCaseStrings ;
            } else {
                return WebToCaseStrings__c.getInstance('Default');
            }
        }
 }
 
 //construcor for geting record from page and also from Pic Language object
 public WebToCaseContExtML( ApexPages.StandardController stdController ) {
 
        emailCheck = false;
        errormessage  = system.label.Error_message;
        this.stdController = stdController;
        if( caseInstance == null )
        {
            caseInstance = new Case();
        }
        caseInstance = ( Case ) stdController.getRecord();
        getPageparameters();
        PIC_Language__c vPICLanObj = new PIC_Language__c();
        ApexPages.Standardcontroller vController = new Apexpages.Standardcontroller(vPICLanObj);
        vPICLan1 = new PICMLanguage(vController);
        // dp
        caseInstance.Campaign__c = ApexPages.currentPage().getParameters().get('Campaign');
        //caseInstance.Region__c = vcountryid ;
        caseInstance.Language__c = vLg;
        caseInstance.SuppliedEmail = vEmail ;
        caseInstance.Address__c = vStreet ;
        caseInstance.Web_Supplied_First_Name__c = vfirstName ;
        caseInstance.Web_Supplied_Last_Name__c = vLastname ;
        caseInstance.SuppliedCompany = vCompany ;
        caseInstance.City__c = vCity ;
        caseInstance.State__c = vState ;
        caseInstance.Zip_Code__c = vZip ;
        caseInstance.Phone__c = vphone ;
        caseInstance.Country__c = vcountryid ;
        caseInstance.Competitor_Part__c =  vCmpPartNum;
        caseInstance.Competitor_Name__c = vCmpname ;
        caseInstance.Part_Number__c = vPartNum ;
        //dp
        caseInstance.Product_from_web__c = vProduct; 
        //system.debug('caseInstance&&&&'+caseInstance); 
        //Santhosh : added If condition for preventing Soql Query execution when no Params passed in Url
        system.debug('paramURL*****'+paramURL);
        
        system.debug('@@Values of SeletctList : '+ vPICLan1.vLstTypeOfCustSO); //sfdc debug statement
        system.debug('@@Type_of_Customer__c : ' + caseInstance.Type_of_Customer__c); //sfdc debug statement

        if(paramURL!=null && paramURL!=''){
            checkEmail();//@dp
        }
 }
 public void init(){
        if( successfulString != null && successfulString == 'true' ){
            renderSubmittedBlock = true;
            renderEnterBlock = false;
        }
 }
 
 //This method is used for saving record from web page to case object.
 public PageReference saveCase(){
        if( !canSubmit ){
            if( caseInstance.SuppliedEmail != null && caseInstance.SuppliedEmail != '' ) checkEmail();
            
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, vPICLan1.vPICLan.E_Pl_Enter_Subject__c) );
            
            return null;
        }
        //Santhosh.s modified to prevent validation messages from page.
        if(renderContactFillInBlockSection)
        {
        
            if(caseInstance.Web_Supplied_First_Name__c == null || caseInstance.Web_Supplied_First_Name__c == '')
            {
                caseInstance.Web_Supplied_First_Name__c.addError(errormessage) ;
                return null;
    
            }
            if(caseInstance.Web_Supplied_Last_Name__c == null || caseInstance.Web_Supplied_Last_Name__c == '')
            {
                caseInstance.Web_Supplied_Last_Name__c.addError(errormessage);
                return null;
    
            }
            if(caseInstance.SuppliedCompany == null || caseInstance.SuppliedCompany == '')
            {
                caseInstance.SuppliedCompany.addError(errormessage);
                return null;
    
            }
            if(caseInstance.Address__c == null || caseInstance.Address__c == '')
            {
                caseInstance.Address__c.addError(errormessage);
                return null;
    
            }
            if(caseInstance.City__c == null || caseInstance.City__c == '')
            {
                caseInstance.City__c.addError(errormessage);
                return null;
    
            }
            if(caseInstance.State__c == null || caseInstance.State__c == '')
            {
                caseInstance.State__c.addError(errormessage);
                return null;
    
            }
            if(caseInstance.Zip_Code__c == null || caseInstance.Zip_Code__c == '')
            {
                caseInstance.Zip_Code__c.addError(errormessage);
                return null;
    
            }
            if(caseInstance.Phone__c == null || caseInstance.Phone__c == '')
            {
                caseInstance.Phone__c.addError(errormessage);
                return null;
    
            }
            if(caseInstance.Country__c == null || caseInstance.Country__c == '')
            {
                caseInstance.Country__c.addError(vPICLan1.vPICLan.E_Country_Error_msg__c);
                return null;

            }
         }
         if(caseInstance.Subject == null || caseInstance.Subject == '')
         {
                caseInstance.Subject.addError(vPICLan1.vPICLan.E_Pl_Enter_Subject__c);
                return null;

         }
         if(caseInstance.Description == null || caseInstance.Description == '')
         {
                caseInstance.Description.addError(errormessage);
                return null;

         }
        //Santhosh.s: End
        
        if( fileBody != null && fileBody.size() > 5000000 ){
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, vPICLan1.vPICLan.E_File_Size_Cannot_be_more__c) );

            return null;
        }
        
        if( contactInstance.Id != null ) caseInstance.ContactId = contactInstance.Id;
            
        try{
            caseInstance.Origin = 'Web';
            caseInstance.setOptions( AssignmentRuleServices.createAssignmentRule() );
            
            insert caseInstance;
            
            renderMain = false;
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.CONFIRM, vPICLan1.vPICLan.E_Your_Question_Submitted__c) );
            upload();
            renderSubmittedBlock = true;
            return null;
         } 
         catch ( DMLException dmlEx ){
            
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, dmlEx.getDmlMessage( 0 ) ) );
            return null;
         }

 }
 
 //This method is used for verifying the contact information.
 public PageReference checkEmail()
 {   
        This.contactInstance = new Contact();
       // system.debug('caseInstance.SuppliedEmail*****'+caseInstance.SuppliedEmail);system.debug('CaseServices.CONTACT_TE_PIC_CONTACT_RECORD_TYPE_IDvalue sanghita*****'+CaseServices.CONTACT_TE_PIC_CONTACT_RECORD_TYPE_ID);
        if(caseInstance.SuppliedEmail!=null && caseInstance.SuppliedEmail!=''){
            emailCheck = true;
            for( Contact contactItem : [SELECT Id, FirstName, LastName, Email, RecordTypeId
                                            FROM Contact
                                            WHERE Email =: caseInstance.SuppliedEmail                                                
                                            LIMIT 1] ){
                    contactInstance = contactItem;
                }
         }
        //system.debug('contactInstance &&&&'+caseInstance.SuppliedEmail+contactInstance );
        system.debug('into else____'+emailCheck +contactInstance.Id);
        if(contactInstance.Id != null ){
            renderContactFoundBlockSection = true;
            renderContactFillInBlockSection = false;
            required = true;
            // @dp start 
            vInputType = false;
            vOutputType = true;
            //@dp end 
        } else if((emailCheck && contactInstance.Id == null)) {
            
            renderContactFoundBlockSection = false;
            renderContactFillInBlockSection = true;
            required = true;
             // @dp start 
            vInputType = true;
            vOutputType = false;
            //@dp end 
           
                            
        }
        canSubmit = true;
        return null;
 }
 
 //This method is used for uploading attchments to the case record
 public void upload() 
 {
    if( fileBody != null && attachment.name != null ){

            attachment.ParentId = caseInstance.Id;
            attachment.IsPrivate = false;
            attachment.body = fileBody;

            try {
                upsert attachment;
                attachment.body = null;
            } catch (DMLException ex) {
                
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, vPICLan1.vPICLan.E_Error_Uploading_Att__c));
            }
            
        }
 }
 
 
     
}