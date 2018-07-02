public class Send_an_Email_Controller {
 public Id Case_id{get;set;}
    public Case cs{get;set;}
    public string msgDate{get;set;}
    public Apex_Helper_Settings__c vBCCAddr{get;set;}
    public Send_an_Email_Controller(ApexPages.StandardController controller) {
       vBCCAddr = Apex_Helper_Settings__c.getInstance('BCC Address for Outlook Email');  
       Case_id = Apexpages.currentPage().getParameters().get('id'); 
       cs = [Select id,ownerid,casenumber,isclosed,Email_FromAddress__c,Email_SentDate__c,Email_ToAddress__c,Case_Thread_Id__c,Email_Subject__c,Email_CCAddress__c from Case where id =: case_id];  
       if(cs.Email_SentDate__c!=null)
       msgDate=cs.Email_SentDate__c.format();
    }
 public PageReference send(){
 return null;
    
 }
}