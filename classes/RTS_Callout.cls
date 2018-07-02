/***********************************************************************************************************************
      Name : RTS_Callout
       Org : C2S
 Copyright : © 2013 TE Connectivity
========================================================================================================================
   Summary : This utility class contains business process methods and technical process methods for RTS Web Service call
             via Cast Iron Middleware tool.             
________________________________________________________________________________________________________________________   
 Apex Trigger utilize this class : RTSRequestAI,RTSRequestAU    
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR        DATE       DETAIL                                                               MERCURY REQUEST #
________________________________________________________________________________________________________________________
    1.0 Subba Reddy   02/19/2013   Initial Development                                                            
***********************************************************************************************************************/

public class RTS_Callout {
	
	@future(callout = true)
	public static  void doCallout(String pSfdcData){
		
		callOrchestration(pSfdcData);
	}
	
/* _____________________________________________________________________________________________________________________   
 Concise Summary : Invoke the method to send the RTS_Request__c.Id to Cast Iron orchestration in real time 
________________________________________________________________________________________________________________________  
 Input Parameter :                                                                                                   
________________________________________________________________________________________________________________________
   I1. Name        : pSfdcData                                                                                
       Data Type   : String                                                                                
       Description : combination of Request Id || TE Network User String.     
________________________________________________________________________________________________________________________   
  Output Parameter : None  
______________________________________________________________________________________________________________________*/
	public static void callOrchestration(String pSfdcData){
		
            /* ______________________________ D3. PRIMITIVE VARIABLE DECLARATION ____________________________*/           
            string vPrjPushConfigName;
            string vRTcallResult; 
            
            // get config name here and pass to real_time_class
            for(realtime_Callout_Settings__c rcs : realtime_Callout_Settings__c.getAll().values()) {
                if(rcs.Active__c == true ) {
                    if(rcs.Name == 'Prod RTS Request Creation' || rcs.Name == 'QA RTS Request Creation'){
                        vPrjPushConfigName = rcs.Name;  
                    }
                }		
            }
            
            system.debug('sfdc data ********:'+pSfdcData + 'configName:'+vPrjPushConfigName);
	        
	        // call the realtime and raise errors as required 		     
	        try{
	        	vRTcallResult = real_time_call.callOrchestrationRealTime('CreateRTSRequests', pSfdcData, vPrjPushConfigName);
	        }catch(Exception e){
	        	
	        }   
	                  
	        system.debug('1***** - ' + vRTcallResult);
        
		        
    }

}