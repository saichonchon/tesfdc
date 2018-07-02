public with sharing class exOpportunity_contact_roles {
    public string oppId{get;set;}
    public string redirectUrl{get;set;}
    private ApexPages.StandardController controller; 
    public ID PracticeImpactID{get;set;}
    
    public exOpportunity_contact_roles(ApexPages.StandardController controller) {
        this.controller = controller;
        PracticeImpactId=controller.getId();
        System.debug(LoggingLevel.INFO, PracticeImpactId);
    }
    
    public exOpportunity_contact_roles() {
        
    }
    public Pagereference editOpp()
    {
        String oppid= ApexPages.currentPage().getParameters().get('oppid');      
        
        // return new PageReference('/apex/ContactRolesPage?oppid='+oppid+'&retURL=/006/');
        return new PageReference('/apex/Opp_Contact_Roles?oppid='+oppid);
    }
    public Pagereference deleteOpp()
    {
        
        try {
            //string cRID = Apexpages.currentPage().getParameters().get('cRID');
            /*String oppid= ApexPages.currentPage().getParameters().get('oppid'); 
system.debug('==oppid==>'+oppid);
Opportunitycontactrole opcn= [Select id from OpportunityContactRole where OpportunityId =:oppid limit 1];
DELETE opcn;
system.debug('==opcn==>'+opcn);*/
            
            String oppid= ApexPages.currentPage().getParameters().get('oppid'); 
            system.debug('==oppid==>'+oppid);
            Opportunitycontactrole opp = [Select id from OpportunityContactRole where Id=:oppid limit 1];
            if(opp !=null && opp.id !=null){
                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error Message.'));
                delete opp;
                System.debug('Record Delete>>>');
            }
     
    } catch (Exception e) {
        ApexPages.addMessages(e);
    }
    return null;//new PageReference('/'+PracticeImpactId);
    
}

}