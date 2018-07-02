/**********************************************************************************************************************************************
*******
Name: ViewNDROpportunityPartController  
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This controller checks the Opportunity Part is of type NDR OpportunityPart or not.If Yes then it will
         show the NDR Opportunity Part detail page else it will redirect to 'ExtOpportunityPartEntry' page
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE          DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Abhijeet Manepstil   05/16/2013    Controller                       
***********************************************************************************************************************************************
*****/

public class ViewNDROpportunityPartController {
/*------------------ D1 Variable Declaration ---------------------------*/
    public String vOpptyId{get;set;}
    public Opportunity_Part__c vOpptyPart{get;set;}
    public Apex_Helper_Settings__c vNDROppRT;
    public boolean vNDROppPart{get;set;}
    
    public ViewNDROpportunityPartController(ApexPages.StandardController controller) {
        vOpptyId = controller.getId(); 
        vOpptyPart = [select recordtypeid,Opportunity__c from Opportunity_Part__c where id =: vOpptyId ];  
         vNDROppRT  = Apex_Helper_Settings__c.getInstance('NDR Opportunity Parts');
    }
/*------------------- Redirect() method -------------------------------*/    
    public PageReference Redirect() {
        if((vOpptyPart.recordtypeid == vNDROppRT.Value__c  ) && (vOpptyPart.recordtypeid != null )){
            vNDROppPart = true;
            return null;

        }
        else{
            PageReference pgrf = new PageReference('/apex/ExtOpportunityPartEntry?Id='+vOpptyId);
            return pgrf;
        }
    }// End of Redirect() method
}// End of class
/*--------------------------------------------------------------------------*/