/***********************************************************************************************************************
Name: DistributorLeadListController
Copyright © 2014 TE Connectivity | Salesforce Instance : C2S
========================================================================================================================
Purpose: Controller for List view on community                                                 
========================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR            DATE               DETAIL                                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------
1.0    Toshi            01/24/2013     Initial Development 
2.0    Anil Kumar       06/26/2014     Enhancements                           
***********************************************************************************************************************/   
public class DistributorLeadListController{

    Transient Public List<Lead> LeadList{get; set;}
    public String show{get; set;}
    Public Set<Id> leadIdSet;
    // Sort fields..
    public String sortField {get; set;}
    public String previousSortField {get; set;} 
    public String up{get; set;}
    private String sortDirection = 'ASC';
    private String sortExp = 'name';
    public string strStatus{get;set;}
    public string strDateRange{get;set;}
    // <!-- @@@@@@@@ Addded By Anil in the part of Enhancements @@@@@@@@ -->
    public Boolean Excel { get; set; }    
    public String Rating{get;set;}
    public String DistributorResponse{get;set;}
            
        public List<SelectOption> getOptions () {
            
           Schema.DescribeFieldResult RatingFieldDescription = lead.Rating.getDescribe();
           List<SelectOption> Options=new List<SelectOption>();
           Options.add(new SelectOption('--All--','--All--'));
          for (Schema.Picklistentry picklistEntry : RatingFieldDescription .getPicklistValues())
           {
             Options.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
           }
           return options;
           }
            
           public List<SelectOption> getDOptions () {
            
           Schema.DescribeFieldResult DRFieldDescription = lead.Distributor_Response__c.getDescribe();
           List<SelectOption> DOptions=new List<SelectOption>();
           DOptions.add(new SelectOption('--All--','--All--'));
          for (Schema.Picklistentry picklistEntry : DRFieldDescription .getPicklistValues())
           {
             DOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
           }
           
           return Doptions;
           } 
          
    Public DistributorLeadListController(){
        
       /* LeadList = new List<Lead>();
        leadIdSet = new Set<Id>();
        List<Leadshare> leadShareList =[Select id, UserOrGroupId, LeadId from Leadshare where UserOrGroupId =:UserInfo.getUserId()];
        for(LeadShare leads: leadShareList){
            if(leads.LeadId!= null){
                leadIdSet.add(leads.LeadId);
            }
        }
        LeadList =[Select id, Name, LeadSource, Status, FirstName, LastName, Company, Phone, OwnerId, Owner.Name, Distributor_Response__c, Email, Rating from Lead where id IN:leadIdSet];*/
        leadListMain();
    }
    /*
        private list<SelectOption> getPicklistValues(SObject obj, String fld){
          list<SelectOption> options = new list<SelectOption>();
          Schema.sObjectType objType = obj.getSObjectType(); 
          Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
          map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
          list<Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
          for (Schema.PicklistEntry a : values){ 
             options.add(new SelectOption(a.getLabel(), a.getValue())); 
          }
          return options;
       }
       public List<selectOption> getStatus(){
            List<selectOption> options = new List<selectOption>();
            
            List<Lead> accts= [SELECT Id, Name, Distributor_Response__c FROM Lead limit 1];
            if(accts!= null && accts.size() > 0){
                    options = getPicklistValues(accts[0], 'Distributor_Response__c');
            }
            options.add(new selectOption('All', '- All -'));
            return (options);
        }
        
        public List<SelectOption> getDateRange(){
            List<SelectOption> options = new List<SelectOption>();
            options.add(new selectOption('All', 'All'));
            options.add(new selectOption('This Month', 'This Month'));
            options.add(new selectOption('Older Than This Month', 'Older Than This Month'));
            return options;
        }
        
    */
     
    Public PageReference leadListMain(){
        LeadList = new List<Lead>();
        leadIdSet = new Set<Id>();
        List<Leadshare> leadShareList =[Select id, UserOrGroupId, LeadId from Leadshare where UserOrGroupId =:UserInfo.getUserId()];
        for(LeadShare leads: leadShareList){
            if(leads.LeadId!= null){
                leadIdSet.add(leads.LeadId);
            }
        }
        LeadList =[Select id, Name, LeadSource, Status, FirstName, LastName, CreatedDate, Lead_Number__c, ACTIVITY_NOTES__c, Description, Company, Phone, OwnerId, Owner.Name, Distributor_Response__c, age_in_days__c, Email, Rating from Lead where id IN:leadIdSet];
        
        if(LeadList.size()>0 && LeadList != null){
           Excel=true;
        }
        return null;
    }
    
    public PageReference runSearch() {
     //build the full sort expression
        string sortFullExp = sortExpression  + ' ' + sortDirection;
        String csstatus = Apexpages.currentPage().getParameters().get('leadstatus');
        leadIdSet = new Set<Id>();
        List<Leadshare> leadShareList =[Select id, UserOrGroupId, LeadId from Leadshare where UserOrGroupId =:UserInfo.getUserId()];
        for(LeadShare leads: leadShareList){
            if(leads.LeadId!= null){
                leadIdSet.add(leads.LeadId);
            }
        }
        //  String soql = 'Select id, Name, LeadSource, Status, FirstName, LastName, Company, Phone, OwnerId, Email, Distributor_Response__c from Lead where id IN:leadIdSet AND '+'  name LIKE \''+String.escapeSingleQuotes(csstatus )+'%\'';
        String soql = 'Select id, Name, LeadSource, Status, FirstName, LastName, CreatedDate, Lead_Number__c, ACTIVITY_NOTES__c, Description, Company, Phone, OwnerId, Owner.Name, Distributor_Response__c, age_in_days__c, Email, Rating from Lead where id IN:leadIdSet ';
        
        soql = soql + 'Order by '+ sortFullExp+'';
        LeadList = Database.query(soql);
        
        if(LeadList.size()>0 && LeadList != null){
           Excel=true;
        }
        
        return null;
    } 
   
    public PageReference editPage(){
        PageReference pageRef = new PageReference('/apex/DistributorLeadEditView?id='+show+'&retURL=/apex/{!$CurrentPage.Name}');
        pageRef.setRedirect(true);
        return pageRef;
    } 
    // add sorting direction logic
     public String sortExpression{ 
         get{return sortExp;}    
         set
         {
              //if the column is clicked on then switch between Ascending and Descending modes
              if (value == sortExp)
                 sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
              else
                 sortDirection = 'ASC';
              sortExp = value;
         }
    }

    public String getSortDirection(){
        //if not column is selected 
        if (sortExpression == null || sortExpression == '')
          return 'ASC';
        else
         return sortDirection;
    }
    public void setSortDirection(String value)
    {  
        sortDirection = value;
    } 
    // <!-- @@@@@@@@ Addded By Anil in the part of Enhancements @@@@@@@@ -->
    public void filterSearch() {
            
        LeadList = new List<Lead>();
        leadIdSet = new Set<Id>();
        List<Leadshare> leadShareList =[Select id, UserOrGroupId, LeadId from Leadshare where UserOrGroupId =:UserInfo.getUserId()];
        for(LeadShare leads: leadShareList){
            if(leads.LeadId!= null){
                leadIdSet.add(leads.LeadId);
            }
        }
        
        String filtersoql = 'Select id, Name, LeadSource, Status, FirstName, LastName, CreatedDate, Lead_Number__c, ACTIVITY_NOTES__c, Description, Company, Phone, OwnerId, Owner.Name, Distributor_Response__c, age_in_days__c, Email, Rating from Lead where id IN:leadIdSet ';

        if(Rating != '--All--' && DistributorResponse == '--All--'){
           filtersoql=filtersoql + 'AND '+ 'Rating = '+ '\'' + Rating+ '\'' ;
           System.debug('@@@@@@@@@@@@@ filtersoql'+filtersoql);
        }
        else if(Rating != '--All--' && DistributorResponse != '--All--' ){
           filtersoql=filtersoql + 'AND '+ ' (Rating = '+ '\'' + Rating+ '\'' + ' AND '+ 'Distributor_Response__c = '+ '\'' + DistributorResponse+ '\')' ;
           System.debug('@@@@@@@@@@@@@ filtersoql'+filtersoql);
        }
        else if(Rating == '--All--' && DistributorResponse != '--All--'){
           filtersoql=filtersoql + 'AND '+ 'Distributor_Response__c = '+ '\'' + DistributorResponse+ '\'' ;
           System.debug('@@@@@@@@@@@@@ filtersoql'+filtersoql);
        }
        LeadList = Database.query(filtersoql);
        System.debug('size of the list'+LeadList.size());
        System.debug('size of the list'+LeadList);
        if(LeadList.size()>0 && LeadList != null){
           Excel=true;
        }
        else{
            Excel=false;
        }
    }
}