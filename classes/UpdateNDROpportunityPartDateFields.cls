/**********************************************************************************************************************************************
*******
Name: UpdateNDROpportunityPartDateFields
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This class is called by OpportunityPart_BIU_NDROpportunity trigger on Opportunity part object.
This class sets date field to null values.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE       DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Abhijeet Manepatil   04/22/2013    Class 
 1.1   Mrunal Parate        08/11/2016    Class                      
***********************************************************************************************************************************************
*****/
public class UpdateNDROpportunityPartDateFields{
/*------------------ D1 Collaection variable declaration --------------------*/
    public List<Opportunity_Part__c> vLstNDROpptyPart;
/*------------------ D2 Object iable declaration ----------------------------*/    
    public Apex_Helper_Settings__c vNDROppPartRT;
    public Date DefDate; 
    public Map<Id,Opportunity> vMapOppyIdtoOppy; // Added by Mrunal
    public Set<Id> vSetOppyId;// Added by Mrunal
    
    public UpdateNDROpportunityPartDateFields(){
/*------------------ I1 Collection Variable Initialisation ------------------*/    
        vLstNDROpptyPart =new List<Opportunity_Part__c>();
/*------------------ I2 Object Variable Initialisation ----------------------*/    
        vNDROppPartRT = Apex_Helper_Settings__c.getInstance('NDR Opportunity Parts');
        DefDate = date.newInstance(1900,1,1);
        vMapOppyIdtoOppy= new Map<Id,Opportunity>();//Added by Mrunal for case 901007
        vSetOppyId = new set<Id>();//Added by Mrunal for case 901007
    }// End of constructor
    public void Update_date_fields(List<Opportunity_Part__c> pLstOpptyPart){
        for(Opportunity_Part__c vOpptyPart : pLstOpptyPart){
        //Create a list of NDR opportunity parts only.
            if(vOpptyPart.recordTypeId == vNDROppPartRT.Value__c){
                vLstNDROpptyPart.add(vOpptyPart);    
                vSetOppyId.add(vOpptyPart.Opportunity__c);//Added by Mrunal for case 901007
            }
        }
        //Change start by Mrunal for case 901007
        if(vSetOppyId.size()>0)
                    vMapOppyIdtoOppy = new map<id, Opportunity>( [select id, currencyIsoCode from Opportunity where id in:vSetOppyId]);
                // Change End by Mrunal
                
        if(vLstNDROpptyPart.size() > 0){
            for(Opportunity_Part__c vNDROpptyPart : vLstNDROpptyPart){
        //Change start by Mrunal for case 901007
            if(vMapOppyIdtoOppy.containsKey(vNDROpptyPart.Opportunity__c) && vMapOppyIdtoOppy.get(vNDROpptyPart.Opportunity__c).currencyIsoCode!= null){ 
                       vNDROpptyPart.currencyIsoCode = vMapOppyIdtoOppy.get(vNDROpptyPart.Opportunity__c).currencyIsoCode;
                    }
             system.debug('>>>>partcurrency'+vNDROpptyPart.currencyIsoCode);
             // Change End by Mrunal for case 901007       
            if(vNDROpptyPart .NDR_Price_Expiration_Date__c== DefDate)
                {
                vNDROpptyPart .NDR_Price_Expiration_Date__c= NULL;
                }
                if(vNDROpptyPart .NDR_Price_Effective_Date__c==DefDate)
                {
                vNDROpptyPart .NDR_Price_Effective_Date__c= NULL;
                }
                if(vNDROpptyPart .NDR_final_approver_Name__c=='0'|| vNDROpptyPart .NDR_final_approver_Name__c=='1')
                {
                vNDROpptyPart .NDR_final_approver_Name__c= NULL;
                }
            }    
        }
    }
}