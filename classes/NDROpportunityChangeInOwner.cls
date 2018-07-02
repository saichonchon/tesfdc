/**********************************************************************************************************************************************
*******
Name: NDROpportunityChangeInOwner
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This class is called by OpportunityBIU_NDROpportunity_Routing trigger on Opportunity object.
This class change the DMM email address.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE       DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Abhijeet Manepatil   07/02/2013    Class 
 1.1   Mrunal Parate        19/11/2015    Code Commented for NDR Phase II Enhancement project to avoid calling DMM Response interface from trigger
 1.2   Mrunal Parate        25/10/2016    For CCR Project:Make NDR Code generic for CCR. Move NDR record type reference from Apex_Helper_Settings__c to 'Opportunity Record type group' custom setting and create new record for CCR record type  in 'Opportunity record type group' custom setting
***********************************************************************************************************************************************
*****/
public class NDROpportunityChangeInOwner{
/*------------------ D1 Collaection variable declaration --------------------*/
    public List<Opportunity> vLstNDROppty;
    //public List<Opportunity> vLstOpptySFDCtoSAP;// Commented by Mrunal for NDR Phase II Enhancement project
    //public List<Opportunity> vLstOpptyNotshiftedtoSFDCtoSAP;// Commented by Mrunal for NDR Phase II Enhancement project
    public Set<Id> vSetNDROppty;
    public Map<Id,User> vMapUser;
    public Map<String,User> vMapUserEmailtoUser;
    public Set<Id> rt_id;// Added for CCR Project
    
/*------------------ D2 Object iable declaration ----------------------------*/    
    //public Apex_Helper_Settings__c vNDROppRT;//comment for CCR Project
    public Integer vCallout = 0;
/*------------------ M1 Constructor method ----------------------------------*/ 
    public NDROpportunityChangeInOwner(){
/*------------------ I1 Collection Variable Initialisation ------------------*/    
        vMapUserEmailtoUser = new Map<String,User>();
        vLstNDROppty =new List<Opportunity>();
        //vLstOpptySFDCtoSAP = new List<Opportunity>();// Commented by Mrunal for NDR Phase II Enhancement project
        //vLstOpptyNotshiftedtoSFDCtoSAP = new List<Opportunity>();// Commented by Mrunal for NDR Phase II Enhancement project
        vSetNDROppty = new Set<ID>();
        //Change start for CCR Project
        
        rt_id = new Set<Id>();
        for (Opportunity_Record_Type_Groups__c rt : Opportunity_Record_Type_Groups__c.getall().values()){
            if(rt.Active__c && rt.Group__c == 'RFQ 2.0 Quotes' && rt.RecordTypeID__c!= null)
                rt_id.add(rt.RecordTypeID__c);
        }
        // Change end for CCR Project
/*------------------ I2 Object Variable Initialisation ----------------------*/    
        //vNDROppRT = Apex_Helper_Settings__c.getInstance('NDR Opportunity');//comment for CCR Project
     }// End of constructor
    
/*------------------ M2 UpdateDMMEmailAddress method----------------------*/
/**
**Parameter name : pLstOppty
**Parameter Type : List of opportunity
**/
    public void UpdateDMMEmailAddress(List<Opportunity> pLstOppty,Map<Id,Opportunity> pOldOpptyMap,Map<Id,Opportunity> pNewOpptyMap){
        try{
                for(Opportunity vOppty : pLstOppty){
                    //Create a list of NDR opportunities only.
                    //if(vOppty.recordTypeId == vNDROppRT.Value__c){//Comment for CCR Project
                    if(rt_id.contains(vOppty.recordTypeId)){//Added for CCR Project
                        vLstNDROppty.add(vOppty);    
                    }
                 }
                if(vLstNDROppty.size() > 0){
                    vMapUser = new Map<Id,User>([Select id,name,email,IsActive from User where IsActive =: true]);
                    for(Opportunity vNDROppty : vLstNDROppty){
                        if(pOldOpptyMap.get(vNDROppty.id).ownerid != pNewOpptyMap.get(vNDROppty.id).ownerid ){
                            vNDROppty.NDR_DMM_Email_Address__c= vMapUser.get(pNewOpptyMap.get(vNDROppty.id).ownerid).email;
                            vNDROppty.NDR_DMM_Name__c = vMapUser.get(pNewOpptyMap.get(vNDROppty.id).ownerid).name;       
                        }
                        // Code Commented by Mrunal for NDR Phase II Enhancement project to avoid calling DMM Response interface from trigger
                        /*if(vNDROppty.NDR_Initiate_SFDC_SAP_Integration__c == 'Y'){
                            if(vNDROppty.NDR_Quote_Header_Status__c == null || vNDROppty.NDR_Quote_Header_Status__c == '9'  ){
                                vLstOpptySFDCtoSAP.add(vNDROppty);
                            }
                        }*/
                    }
                  
                }
                // Code Commented by Mrunal for NDR Phase II Enhancement project to avoid calling DMM Response interface from trigger
                /*if(vLstOpptySFDCtoSAP.size() > 0){
                    vCallout =0;
                    for(Opportunity vOpp : vLstOpptySFDCtoSAP){
                        if(vCallout < 10){
                            NDRInitiateSFDC2SAP.InitiateOrch(vOpp.id);
                            vCallout++;
                        }
                        else{
                            vLstOpptyNotshiftedtoSFDCtoSAP.add(vOpp);
                        }
                    }
                    if(vLstOpptyNotshiftedtoSFDCtoSAP.size() > 0){
                        NDRCalloutlimit.sendEmail(vLstOpptyNotshiftedtoSFDCtoSAP,'swathi.gaddam@te.com');
                    }
               } */
       }//End of try 
       catch(Exception vEx){
           System.debug('**************Exception In DMM Routing'+vEx);
       } 
    }//End of UpdateDMMEmailAddress() method
}