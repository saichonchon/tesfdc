/**********************************************************************************************************************************************
*******
Name: NDRInitiateSFDC2SAPForQuoteURL
Copyright © 2015 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This class is called on Button 'Refrest Quote URL' click on Document related list.
This class initiates the SFDC-SAP castiron orch.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE       DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Mrunal Parate   16/10/2015    Class                       
***********************************************************************************************************************************************
*****/
Global class NDRInitiateSFDC2SAPForQuoteURL{
@future(callout=true)
    Webservice static void InitiateOrch(String pOppyID){
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
  Webservice static void callOrchestration(String pSfdcData){
    
            /* ______________________________ D3. PRIMITIVE VARIABLE DECLARATION ____________________________*/           
            string vPrjPushConfigName;
            string vRTcallResult; 
            String vStrError = '';// Added by Mrunal
            // get config name here and pass to real_time_class
            for(realtime_Callout_Settings__c rcs : realtime_Callout_Settings__c.getAll().values()) {
                if(rcs.Active__c == true ) {
                    if(rcs.Name == 'Prod NDR Quote Link' || rcs.Name == 'QA NDR Quote Link'){
                        vPrjPushConfigName = rcs.Name;  
                    }
                }    
            }
            
            system.debug('>>>>> sfdc data:'+pSfdcData + 'configName:'+vPrjPushConfigName);
          
          try{
            vRTcallResult = real_time_call.callOrchestrationRealTime('NDRGETDOCUMENTURL', pSfdcData, vPrjPushConfigName);
            System.debug('>>>>>> vRTcallResult '+vRTcallResult );
          }catch(Exception e){
            //Change start by Mrunal for CCR Project to log exception
            vStrError +='Error Type = '+e.getTypeName()+' Error Line = '+e.getLineNumber()+''+' Error Stack = '+e.getStackTraceString()+' Error Message = '+e.getMessage();
            SalesforceException.putError('NDRInitiateSFDCtoSAPForQuoteURL Exception **', '',vStrError,SalesforceConstant.strSfdc,SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '',e.getStackTraceString());
            //Change start by Mrunal for CCR Project
            System.debug('>>>>>>>>>> NDRInitiateSFDCtoSAPForQuoteURL Exception '+e);
          }   
     }
    webservice static string getPricingSignal(string pSfdcData)
    {
    
        /* ______________________________ D3. PRIMITIVE VARIABLE DECLARATION ____________________________*/           
        string vPrjPushConfigName;
        string vRTcallResult; 
        // get config name here and pass to real_time_class
        realtime_Callout_Settings__c oQASetting = realtime_Callout_Settings__c.getinstance('QA C2S_NDRRetryGPMSInitialReview');
        realtime_Callout_Settings__c oProdSetting = realtime_Callout_Settings__c.getinstance('Prod C2S_NDRRetryGPMSInitialReview');
        if(oQASetting != null && oQASetting.Active__c)
            vPrjPushConfigName = oQASetting.Name;
        if(oProdSetting != null && oProdSetting.Active__c)
            vPrjPushConfigName = oProdSetting.Name;
            
        system.debug('sfdc data ********:'+pSfdcData + 'configName:'+vPrjPushConfigName);
        try
        {
            vRTcallResult = real_time_call.callOrchestrationRealTime('NDRRETRYGPMSREVIEW', pSfdcData, vPrjPushConfigName);//vPrjPushConfigName);
            System.debug('*****vRTcallResult *******'+vRTcallResult );
        }
        catch(Exception e)
        {
            System.debug('NDRInitiateSFDC2GPMS Exception *****'+e);
            return 'ERROR' + e;
        
        }   
        
        return 'OK';
    }
}