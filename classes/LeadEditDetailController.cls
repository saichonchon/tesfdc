/***********************************************************************************************************************
Name: LeadEditDetailController
Copyright © 2014 TE Connectivity | Salesforce Instance : C2S
========================================================================================================================
Purpose: Controller for Edit and Detail page on Community                                                 
========================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR            DATE               DETAIL                                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------
1.0    Toshi            01/24/2013     Initial Development
2.0    Anil             07/2/2014      PDF Functionality                      
***********************************************************************************************************************/   
Public class LeadEditDetailController{
    Public Id leaid = ApexPages.currentPage().getParameters().get('Id');
    public Id show{get; set;}
    public Lead leadrec {get; set;}
    
    public LeadEditDetailController(ApexPages.StandardController stdController) {
        this.leadrec = (Lead)stdController.getRecord();
        show = leadrec.id;
        
    }
    Public PageReference SaveEdit(){
        try{
            update leadrec;
        }
        Catch(Exception e){
            System.debug('*****'+e);
        }
        PageReference pageRef = new PageReference('/apex/DistributorLeadDetailView?id='+show);
        pageRef.setRedirect(true);
        return pageRef;
    }
    Public PageReference editTo(){
        PageReference pageRef = new PageReference('/apex/DistributorLeadEditView?id='+show);
        pageRef.setRedirect(true);
        return pageRef;
    }        
}