/**********************************************************************************************************************************************
*******
Name: UpdateNDROpportunityDateFields
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This class is called by OpportunityBIU_NDROpportunity_Routing trigger on Opportunity object.
This class sets date field to null values.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE       DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Abhijeet Manepatil   04/22/2013    Class 
 1.1   Mrunal Parate        25/10/2016    For CCR Project:Make NDR Code generic for CCR. Move NDR record type reference from Apex_Helper_Settings__c to 'Opportunity Record type group' custom setting and create new record for CCR record type  in 'Opportunity record type group' custom setting 
***********************************************************************************************************************************************
*****/
public class UpdateNDROpportunityDateFields{
/*------------------ D1 Collaection variable declaration --------------------*/
    public List<Opportunity> vLstNDROppty;
/*------------------ D2 Object iable declaration ----------------------------*/    
    //public Apex_Helper_Settings__c vNDROppRT;//comment for CCR Project
    public Date DefDate; 
    public Set<Id> rt_id;// added for CCR Project
    
    public UpdateNDROpportunityDateFields(){
/*------------------ I1 Collection Variable Initialisation ------------------*/    
        vLstNDROppty =new List<Opportunity>();
/*------------------ I2 Object Variable Initialisation ----------------------*/    
        //vNDROppRT = Apex_Helper_Settings__c.getInstance('NDR Opportunity');//comment for CCR Project
        DefDate = date.newInstance(1900,1,1);
        //Change start for CCR Project
        rt_id = new Set<Id>();
        for (Opportunity_Record_Type_Groups__c rt : Opportunity_Record_Type_Groups__c.getall().values()){
            if(rt.Active__c && rt.Group__c == 'RFQ 2.0 Quotes' && rt.RecordTypeID__c!= null)
                rt_id.add(rt.RecordTypeID__c);
        }
        // Change end for CCR Project
    }// End of constructor
    
    public void Update_date_fields(List<Opportunity> pLstOppty){
    try{
        for(Opportunity vOppty : pLstOppty){
        //Create a list of NDR opportunities only.
                //if(vOppty.recordTypeId == vNDROppRT.Value__c){//Comment for CCR Project
                if(rt_id.contains(vOppty.recordTypeId)){//Added for CCR Project
                    vLstNDROppty.add(vOppty);    
                }
                 
        }
        
        if(vLstNDROppty.size() > 0){
            for(Opportunity vNDROppty : vLstNDROppty){
            
                if(vNDROppty.NDR_Quote_Effective_Date__c == DefDate)
                {
                vNDROppty .NDR_Quote_Effective_Date__c = NULL;
                }
                if(vNDROppty.NDR_Quote_Requested_date__c ==DefDate)
                {
                vNDROppty.NDR_Quote_Requested_date__c = NULL;
                }
                if(vNDROppty .NDR_Quote_Expiration_Date__c == DefDate)
                {
                vNDROppty.NDR_Quote_Expiration_Date__c= NULL;
                }
                if(vNDROppty.Initial_Order_Date__c == DefDate)
                {
                vNDROppty.Initial_Order_Date__c = NULL;
                }
                if(vNDROppty .Prototype_Date__c ==DefDate)
                {
                vNDROppty .Prototype_Date__c = NULL;
                }
            }
        }  
      }
      catch(Exception e){
          System.debug('Exception -----'+e);
      }    
    }
}