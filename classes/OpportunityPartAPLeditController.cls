/**********************************************************************************************************************************************
*******
Name: OpportunityPartAPLeditController  
Copyright © 2014 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This controller checks the Opportunity Part is of type APL OpportunityPart or not.If Yes then it will
         show the APL Opportunity Part detail page else it will redirect to 'ExtOpportunityPartEntry' page
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE          DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Padmaja Dadi          12/22/2014    Controller
 1.1   Nelson zheng          01/28/2015    change the criteria                       
***********************************************************************************************************************************************
*****/

public class OpportunityPartAPLeditController {
/*------------------ D1 Variable Declaration ---------------------------*/
 public String vOpptyId{get;set;}
 public Opportunity_Part__c vOpptyPart{get;set;}
 public User currentUser{get;set;}
  
    public OpportunityPartAPLeditController(ApexPages.StandardController controller) {
        
        vOpptyId = controller.getId(); 
        /* by nelson zheng 01/28/2015
        vOpptyPart = [select recordtypeid,Opportunity__c,Opportunity_Record_Type__c,Opportunity__r.recordtypeid,Opportunity__r.Industry_Code__c from Opportunity_Part__c where id =: vOpptyId ];        
        */  
        
        currentUser = [select Id, GIBU__c from User where Id =: UserInfo.getUserId()];
        System.debug('------------currentUser-----------'+currentUser);
    }
/*------------------- Redirect() method -------------------------------*/ 
    public PageReference Redir() {
    	/* by nelson zheng 01/28/2015
        Apex_Helper_Settings__c vAPLOppRT  = Apex_Helper_Settings__c.getInstance('Opportunity_Engineering_Project');  
        Apex_Helper_Settings__c vAPLOppRT1  = Apex_Helper_Settings__c.getInstance('Sales Parts Only');    
        Apex_Helper_Settings__c vAPLOppRT2  = Apex_Helper_Settings__c.getInstance('Opportunity - Product Platform');
        if((vOpptyPart.Opportunity__r.recordtypeid == vAPLOppRT.Value__c 
        || vOpptyPart.Opportunity__r.recordtypeid == vAPLOppRT1.Value__c 
        || vOpptyPart.Opportunity__r.recordtypeid == vAPLOppRT2.Value__c) 
        && (vOpptyPart.recordtypeid != null)
        && (vOpptyPart.Opportunity__r.Industry_Code__c == 'Appliances')){*/
        Apex_Helper_Settings__c vAPLOppRT  = Apex_Helper_Settings__c.getInstance('GIBU of Applience');  
        System.debug('-----------vAPLOppRT-----------'+vAPLOppRT);
        if(vAPLOppRT.value__c.indexOf(currentUser.GIBU__c) > -1){
            Pagereference newpage = new Pagereference('/apex/ExtOpportunityPartEntryAPL?Id='+ vOpptyId);
            return newpage; 
         }
        else
            {
            Pagereference newpage1 =new Pagereference('/apex/ExtOpportunityPartEntry?Id='+ vOpptyId);
            return newpage1;
        } 
 } 
 // End of Redirect() method
}// End of class
/*--------------------------------------------------------------------------*/