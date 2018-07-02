global class CtrlOppyPartDateLookupPage {
    public Opportunity_Part__c part {get; set;}
    public String partId {get; set;}
    public String status {get; set;}    
    public String field {get;Set;}
    public string orderDate {get; set;}
    public string billingDate {get; set;}
    public CtrlOppyPartDateLookupPage(){
        partId = ApexPages.currentPage().getParameters().get('partId');
        status = ApexPages.currentPage().getParameters().get('status');
        field = ApexPages.currentPage().getParameters().get('fieldId');           
       
        try
        {
            part = [Select Id, Initial_Order_Date__c, Initial_Billing_Date__c, Status__c from Opportunity_Part__c where Id = :partId];           
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Opportunity part does not exist.'));
        }                    
    }        
}