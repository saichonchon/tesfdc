public with sharing class Emails_RelatedList_Controller {
    public Id Case_ID{get;set;}
    public String Owner_Id{get;set;}
    public String Owner_EmailId{get;set;}
    public User vCsOwner{get;set;}    
    public List<EmailMessage> vEMLst{get;set;}
    public List<Email_Wrapper> vEMWrapperLst{get;set;}
    public Map<String, Customer_Care_SharedEmailBox__c> vCustCareEmailBoxMapAll = Customer_Care_SharedEmailBox__c.getAll();
    public Map<String, Customer_Care_SharedEmailBox__c> vCustCareEmailBoxMap = new  Map<String, Customer_Care_SharedEmailBox__c>();
      /*********Pagination***************/
    public boolean vdisplayEmails{get;set;}
    public Integer noOfRecordPerPage {get;set;}
    public Integer selectedPage {get;set;}
    public Map<Integer, List<Email_Wrapper>> mapCases{get;set;}
    public List<selectoption> pagesOptions {get;set;}
    /*************************************/
    
    public Emails_RelatedList_Controller(ApexPages.StandardController controller) {
       Case_ID= System.currentPageReference().getParameters().get( 'id' );
       for(Customer_Care_SharedEmailBox__c ccs : vCustCareEmailBoxMapAll.values()){
           vCustCareEmailBoxMap.put(ccs.Name.toLowerCase(),ccs);
       }
       //Email_Wrapper ew = new Email_Wrapper(vCustCareEmailBoxMap);
        Owner_Id = [Select id,ownerid from Case where id =: Case_Id].ownerId;
        if(Owner_Id.startsWith('005')){
            vCsOwner= [Select id,email from User where id =: Owner_Id];
        }
        if(vCsOwner != null)
        Owner_EmailId = vCsOwner.email;
        runQuery();
    }
    
   
    public PageReference runQuery(){
        vEMLst = new List<EmailMessage>();
        vEMWrapperLst = new List<Email_Wrapper>();
        /***************************************/
        mapCases =new Map<Integer, List<Email_Wrapper>> ();
        //Nooreen-changed noOfRecordPerPage from 10 to 20 for case 900651 on 21-02-16
        noOfRecordPerPage = 20;  
        selectedPage = 1;
        /****************************************/
        String query = 'Select id,parentId,subject,status,HasAttachment,Incoming,ToAddress,FromAddress,MessageDate,TextBody from EmailMessage where parentId =: Case_Id';  
                
        vEMLst = Database.query(query+ ' order by ' + sortField + ' ' + sortDir );        
        for(EmailMessage e : vEMLst){
            if(vCsOwner != null){
                vEMWrapperLst.add(new Email_Wrapper(e,Owner_EmailId,vCustCareEmailBoxMap));
            }
            else{
                vEMWrapperLst.add(new Email_Wrapper(e,'',vCustCareEmailBoxMap));
            }
        }
        vEMLst = new List<EmailMessage>();
        if(vEMWrapperLst.size()>0){
            vdisplayEmails = true;
            pagesOptions = new List<SelectOption>();
            integer total_no_of_pages = vEMWrapperLst.size()/noOfRecordPerPage;                 
            if(math.mod(vEMWrapperLst.size(),noOfRecordPerPage) > 0){
               total_no_of_pages = total_no_of_pages +1;
            }
            integer pageStartValue = 0;
            integer pageEndValue = noOfRecordPerPage;
          for(integer i = 0; i<total_no_of_pages ; i++){
                integer counter = i+1;
                pagesOptions.add(new SelectOption(counter+'',counter +''));
                List<Email_Wrapper> CaseList = new List<Email_Wrapper>();
               for(integer j = pageStartValue ; j< pageEndValue; j++){
                        try{
                            vEMWrapperLst[j].wEM.TextBody = '';
                            CaseList.add(vEMWrapperLst[j]);
                        }
                        catch(Exception e) {
                        }
                }
                pageStartValue = pageEndValue;
                pageEndValue = noOfRecordPerPage*(i+2);
            mapCases.put(counter,CaseList);
           }
           vEMWrapperLst = new List<Email_Wrapper>();
        /***************************************/
        return null;
        }
        
    return null;
    }
    
    
       
/*----------------- Getter-Setter to get Sorting Direction ----------------*/    
    public String sortDir {
        get  { if (sortDir == null) {  sortDir = 'desc'; } return sortDir;  }
        set;
    }
/*----------------- Getter-Setter to get Sorting Field -------------------*/  
    public String sortField {
       get  { if (sortField == null) {sortField = 'MessageDate'; } return sortField;  }
       set;
    }
/*----------------- Method to Sort the records ---------------------------*/   
    public void toggleSort() {
        sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
        runQuery();
    } //End of 'toggleSort()' method.
    /*********************/
 public void nextPage(){
       }
      
    //Wrapper class
    public class Email_Wrapper{
        public EmailMessage wEM{get;set;}
        public String wStatus{get;set;}
        public String wMessageDate{get;set;}
        public String wOwner_EmailId;   
        public String txtBody{get;set;}    
        public Map<String, Customer_Care_SharedEmailBox__c> wCustCareEmailBoxMap = new  Map<String, Customer_Care_SharedEmailBox__c>();
     
   
                 
        public Email_Wrapper(EmailMessage e,String pEmailid,Map<String, Customer_Care_SharedEmailBox__c> wCustCareEmailBoxMap){
            wEM = e;
            if(e.MessageDate!=null)
            wMessageDate=e.MessageDate.format();
            wOwner_EmailId = pEmailid;
            
            if((e.TextBody!=null) && (e.TextBody.length()>78)){     
                txtBody =  ((e.TextBody.substring(0, 77))+'...'); 
            }
            else{
                txtBody =  e.TextBody;
            }
                
            System.debug('wCustCareEmailBoxMap.size()'+wCustCareEmailBoxMap.size());
            //Narasimha-added e.FromAddress!=null in condition for null exception on 12/9/2014
            if(e.FromAddress!=null && (wCustCareEmailBoxMap.containsKey(e.FromAddress.toLowerCase())) && e.Incoming == true){
            wStatus = 'Sent via Outlook';
            }else{
                if(wEm.Status == '0'){
                   wStatus = 'New'; 
                }else if(wEm.Status == '1'){
                   wStatus = 'Read'; 
                }
                else if(wEm.Status == '2'){
                   wStatus = 'Replied'; 
                }else if(wEm.Status == '3'){
                   wStatus = 'Sent'; 
                }else if(wEm.Status == '4'){
                   wStatus = 'Forwarded'; 
                }else{
                    wStatus = '';
                }
            
            }
        }
    }    
}