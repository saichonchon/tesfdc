/**************************************************************************************************************************************************
Name:  WebServiceMockImpl
Copyright © 2014 TE Connectivity | Instance : C2S Org
===================================================================================================================================================
Purpose: This class contain Test Methods for PLM_Callout_Test,CreatePLMProjectCls_Test
---------------------------------------------------------------------------------------------------------------------------------------------------       
Related Test Class : PLM_Callout_Test,CreatePLMProjectCls_Test
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
Version Developer              Date       Detail                                  Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Padmaja Dadi    03/07/2014 Initial Development                      
**************************************************************************************************************************************************/
@isTest
global class WebServiceMockImpl implements WebServiceMock {
   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
          /* 
           TrafficCopWS.ProcessHandlerSoap mySoap = new TrafficCopWS.ProcessHandlerSoap();
           mySoap.timeout_x = 60000;
           TrafficCopWS.ProcessRequestResponse_element e ;
           e.ProcessRequestResult= '<ProjectTemplateList></ProjectTemplateList><RDGList></RDGList>'; 

          response.put('response_x', mySoap); */
           
                   
          }
           
           
         }