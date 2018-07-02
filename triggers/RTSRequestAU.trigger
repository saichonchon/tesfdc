/**************************************************************************************************************************************************
Name: RTSRequestAI 
Copyright © 2011 TE Connectivity | Salesforce Instance : C2S Org
===================================================================================================================================================
Purpose: This trigger creates new RTS record in RTS system when  RTS request record updated  with sent to RTS is checked and RTS requestId is null in C2S Org                                                   
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR                DATE       DETAIL                                                         Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Subba Reddy           02/18/2013 Initial Development                                      
**************************************************************************************************************************************************/


trigger RTSRequestAU on RTS_Request__c (after update) {
    
    /* ______________________________ D3. PRIMITIVE VARIABLE DECLARATION ____________________________*/
    String vSfdcData;
    
    for(RTS_Request__c request : Trigger.new){
        if( (request.Send_to_RTS__c != Trigger.oldMap.get(request.id).Send_to_RTS__c) && (request.Send_to_RTS__c == True) && (request.RTS_Request_Id__c == null) ) {
            vSfdcData = request.id + '||' + string.valueOf(request.Creator_Network_Id__c);
            RTS_Callout.doCallout(vSfdcData);
        } // end if
    } // end for

} // end Trigger