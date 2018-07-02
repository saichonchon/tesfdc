public without sharing class PartnerRoleAccountSearch {
    //remove "with sharing" to get all accounts

    private final Partner_Role__c partner;
            
    public String query {get; set;}
    public List<Account> accounts {get; set;}
    public Partner_Role__c partnerRole {get; set;}  
    public String acctName {get; set;}
    
    public PartnerRoleAccountSearch(ApexPages.StandardController stdController) {
        if(!SalesforceUtils.IsNullOrEmpty(ApexPages.currentPage().getParameters().get('opp')))
        {
            Partner_Role__c tempPRole = (Partner_Role__c)stdController.getRecord();
            tempPRole.Opportunity__c = ApexPages.currentPage().getParameters().get('opp');
            this.partner = tempPRole;
        }
        else
        {
            this.partner = (Partner_Role__c)stdController.getRecord();
        }
        Partner_Role__c partnerRole = new Partner_Role__c();        
        acctName = SalesforceUtils.ReplaceNullStringWithEmpty(getAccountName());            
    } 
    
    public String getAccountName()
    {
        //requery for account name if user does not have read permissions on saved account
        if(!SalesforceUtils.IsNullOrEmpty(partner.id) && SalesforceUtils.IsNullOrEmpty(partner.Account__r.name))
        {
            partnerRole  = [select id, account__c, account__r.name, opportunity__c, role__c, allocation_percent__c from partner_role__c where id =: partner.id];
            
            return partnerRole.account__r.name;
        }
        else
        {
            return partner.Account__r.Name;
        }               
    }       
    
    public PageReference runQuery()
    {
        if(SalesforceUtils.ReplaceNullStringWithEmpty(query).length() > 1)
        {
            query = query + '*';
        
            List<List<Account>> searchResults=[FIND :query IN ALL FIELDS RETURNING Account (id, name, billingstreet, billingcity, billingpostalcode)];
            accounts=searchResults[0];
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Search Text must be longer than 1 character'));         
        }
        
        return null;
    }
    
    public PageReference gotoOpportunity(){
        return new PageReference('/' + partner.Opportunity__c);
    }   
    
    //custom save method allows user to save partner role even if they don't have permissions to selected account
    public PageReference savePartner()
    {
        database.upsert(partner);
        return gotoOpportunity();
    }
    
    public PageReference SaveAndNew()
    {
        database.upsert(partner); 
        //save opportunity id so reference field can be prepopulated on new partner role edit screen
        PageReference pageRef =  new PageReference(Page.PartnerRoleEdit.getUrl() + '?opp=' + partner.Opportunity__c);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    //sorting for part list
    public String accountListSortField {get; set;}  
    public String accountListPrevSortField {get; set;}  
    
    public void doAccountListSort()
    {  
        try
        {
            String order = 'asc';  
    
            /*This checks to see if the same header was click two times in a row, if so   
            it switches the order.*/ 
    
            if(accountListPrevSortField == accountListSortField)
            {  
                order = 'desc';  
                accountListPrevSortField = null;  
            }
            else
            {  
                accountListPrevSortField = accountListSortField;  
            }           
            
            TableSortSupport.sortList(accounts,accountListSortField,order);
        }
        catch (ListException e)
        {
            if(accounts.size() > 0)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error Sorting: ' + e.getMessage()));            
                ErrorLogging.Log(e);                
            }
            else
            {
                accountListSortField = null;
                accountListPrevSortField = null;
            }
        }
        catch (Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error Sorting: ' + e.getMessage()));            
            ErrorLogging.Log(e);    
        }       
                  
    }           

}