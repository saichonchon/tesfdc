/**
 *  A popup page controller to show confidence and process. used for Mass Update button on Appliance oppty forecast creation page. 
 *  Case 00721692
 * @author Michael Cui
 * @created 2014-09-05
 * @version 1.0
 * 
 *
 * @changelog
 * 
 */
global class CtrlOppyPartMassUpdatePage {
    public Opportunity_Part__c part {get; set;}
    public String partId {get; set;}
    public String status {get; set;}       
    public String selectId {get;set;}
    
    public CtrlOppyPartMassUpdatePage(){
        partId = ApexPages.currentPage().getParameters().get('partId');        
        selectId = ApexPages.currentPage().getParameters().get('selectChk');
        try{
            part = [Select Id, Process_Status__c, Initial_Order_Date__c, Initial_Billing_Date__c, Lost_Reason__c, Lost_Reason_Text__c, Competitor__c, Status__c from Opportunity_Part__c where Id = :partId];            
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Opportunity part does not exist.'));
        }  
    }
    
    public List<SelectOption> getProcessStatusItems(){
        List<SelectOption> list_options = new List<SelectOption>();
                
        if(Apex_Helper_Settings__c.getInstance('APL Oppty Part Process Status Value') != null && Apex_Helper_Settings__c.getInstance('APL Oppty Part Process Status Value').Active__c && Apex_Helper_Settings__c.getInstance('APL Oppty Part Process Status Value').value__c != null)
        {
            String[] processStatusValue = Apex_Helper_Settings__c.getInstance('APL Oppty Part Process Status Value').value__c.split(';');
            for(Integer i=0; i< processStatusValue.size(); i++)
            {
              list_options.add(new SelectOption(processStatusValue[i],processStatusValue[i]));
            }
        }          
        
        return list_options;
    }
    
    webService static String competitorValid(String competitor){
        String competitorId = '';
        List<Account> list_accounts = new List<Account>();
        list_accounts = [Select id from Account where Name = :competitor and type = 'Competitor'];
        if(list_accounts.size() == 1){          
            competitorId = String.valueOf(list_accounts[0].id);
        }
        else if(list_accounts.size() > 1){
            competitorId = 'Duplicate';
        }
        return competitorId;
    }
}