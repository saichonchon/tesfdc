/**********************************************************************************************************************************************
*******
Name: NDRInitiateSFDC2SAP
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This class is called by OpportunityBIU_NDROpportunity_Routing trigger on Opportunity object.
This class initiates the SFDC-SAP castiron orch.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE       DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Abhijeet Manepatil   07/02/2013    Class                       
***********************************************************************************************************************************************
*****/
public class NDRInitiateSFDC2SAP{
@future(callout=true)
    public static void InitiateOrch(String pOppyID){
        callOrchestration(pOppyId);
    }
    /* _____________________________________________________________________________________________________________________   
 Concise Summary : Invoke the method to send the Opportunity.Id to Cast Iron orchestration in real time 
________________________________________________________________________________________________________________________  
 Input Parameter :                                                                                                   
________________________________________________________________________________________________________________________
   I1. Name        : pOppyId                                                                                
       Data Type   : String                                                                                
       Description : NDR Opportunity Id     
________________________________________________________________________________________________________________________   
  Output Parameter : None  
______________________________________________________________________________________________________________________*/
  public static void callOrchestration(String pSfdcData){
    
            /* ______________________________ D3. PRIMITIVE VARIABLE DECLARATION ____________________________*/           
            string vPrjPushConfigName;
            string vRTcallResult; 
            String vStrError = '';// Added by Mrunal
            // get config name here and pass to real_time_class
            for(realtime_Callout_Settings__c rcs : realtime_Callout_Settings__c.getAll().values()) {
                if(rcs.Active__c == true ) {
                    if(rcs.Name == 'Prod NDR DMM response Push' || rcs.Name == 'QA NDR DMM responses Push'){
                        vPrjPushConfigName = rcs.Name;  
                    }
                }    
            }
            
            system.debug('sfdc data ********:'+pSfdcData + 'configName:'+vPrjPushConfigName);
          
          try{
            vRTcallResult = real_time_call.callOrchestrationRealTime('NDRDMMRESPONSE', pSfdcData, vPrjPushConfigName);
            System.debug('*****vRTcallResult *******'+vRTcallResult );
          }catch(Exception e){
            //Change start by Mrunal for CCR Project to log exception
            vStrError +='Error Type = '+e.getTypeName()+' Error Line = '+e.getLineNumber()+''+' Error Stack = '+e.getStackTraceString()+' Error Message = '+e.getMessage();
            SalesforceException.putError('NDRInitiateSFDCtoSAP Exception **', '',vStrError,SalesforceConstant.strSfdc,SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '',e.getStackTraceString());
            //Change start by Mrunal for CCR Project
            System.debug('NDRInitiateSFDCtoSAP Exception *****'+e);
          }   
     }
}