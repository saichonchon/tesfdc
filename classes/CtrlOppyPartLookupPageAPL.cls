/**
*   extension for Opportunity forecast
*
@author Nelson Zheng
@created 2015-07-29
@version 1.0
@since 23.0
*
@changelog
* 2015-7-29 Nelson Zheng <yimin.zheng@te.com>
* - Created
*/

global class CtrlOppyPartLookupPageAPL {
    public Opportunity_Part__c part {get; set;}
    public String partId {get; set;}
    public String status {get; set;}    
    public String field {get;Set;}
    
    public CtrlOppyPartLookupPageAPL(){
        partId = ApexPages.currentPage().getParameters().get('partId');
        status = ApexPages.currentPage().getParameters().get('status');
        field = ApexPages.currentPage().getParameters().get('fieldId');
        try{
            part = [Select Id, Lost_Reason__c, Lost_Reason_Text__c, Competitor__c, Status__c from Opportunity_Part__c where Id = :partId];
            part.Status__c = status;
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Opportunity part does not exist.'));
        }
        part.Lost_Reason__c = ApexPages.currentPage().getParameters().get('reason');
        part.Lost_Reason_Text__c = ApexPages.currentPage().getParameters().get('reasonText');
        
        if(ApexPages.currentPage().getParameters().get('reasonCompetitor') != '000000000000000'){
            if(ApexPages.currentPage().getParameters().get('reasonCompetitor') == ''){
                part.Competitor__c = null;
            }
            else part.Competitor__c = (Id) ApexPages.currentPage().getParameters().get('reasonCompetitor');         
        }   
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