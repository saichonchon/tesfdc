/***********************************************************************************************************************
      Name : CastIron_Apex_RTSXML_WS
       Org : C2S
 Copyright : © 2013 TE Connectivity
========================================================================================================================
   Summary : This Web Service  class contains business process methods and technical process methods to generate XML for
             RTS and Items Records and send back the response as XML String to cast iron .                        
________________________________________________________________________________________________________________________   
 Apex Trigger utilize this class :     
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR        DATE       DETAIL                                                               MERCURY REQUEST #
________________________________________________________________________________________________________________________
    1.0 Subba Reddy   02/20/2013   Initial Development                                                            
***********************************************************************************************************************/

global class CastIron_Apex_RTSXML_WS {
	
/* _____________________________________________________________________________________________________________________   
 Concise Summary : Invoke the method to send the RTS_Request__c.Id||Te network Id from Cast Iron orchestration  
________________________________________________________________________________________________________________________  
 Input Parameter :                                                                                                   
________________________________________________________________________________________________________________________
   I1. Name        : pReqNetwrkStr                                                                                
       Data Type   : String                                                                                
       Description : combination of Request Id || TE Network User String.     
________________________________________________________________________________________________________________________   
  Output Parameter :   
________________________________________________________________________________________________________________________
   O1. Name        : vRTSItemXMLStr                                                                                
       Data Type   : String                                                                                
       Description : returns the RTS and Item XML as String .
______________________________________________________________________________________________________________________*/	
    webservice static String generateRTSXML(String pReqNetwrkStr ){
        
        /* ______________________________ D3. PRIMITIVE VARIABLE DECLARATION ____________________________*/
        String vRTSItemXMLStr;        
        String vRequestId;        
        Integer vPipeIndex = pReqNetwrkStr.indexOf('||');        
        vRequestId = pReqNetwrkStr.substring(0, vPipeIndex);
        
        system.debug('vRequestId *************:'+vRequestId);
        
        vRTSItemXMLStr = createRTSXML.generateXML(vRequestId); 
        
        return vRTSItemXMLStr;
    }
}