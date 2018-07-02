/**************************************************************************************************************************************************
Name: OpportunityAU 
Copyright © 2011 TE Connectivity | Salesforce Instance : BU Org 
===================================================================================================================================================
Purpose: This trigger shares the changes in opportunity records from child org to central org                                                  
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR                DATE       DETAIL                                            Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Umasankar Subbaian    11/02/2011 Exception Handling                                1453487
    1.1 Umasankar Subbaian    12/06/2011 Make opportunity creatable with account           1453487 
**************************************************************************************************************************************************/
trigger OpportunityAU on Opportunity(after update){
     /*-- 1 Collection variable declaration --------------------------------------*/
     List<Opportunity> notinPNRC;
     List<Opportunity> ParentedUnrestrictedOpportunities;
     /*-- 2. Primitive variable declaration --------------------------------------*/ 
     String  vStrErrorCategory       = '';
     String  vStrLineNumber          = '';
     String  vStrStackTrace          = '';
     String  vStrError               = '';
     String  vStrLog                 = ''; 
     String  vStrSfdcRecId           = ''; 
 
    try{ 
        system.debug('ExecuteOnce.SF2SF_OPPORTUNITY: ' + ExecuteOnce.SF2SF_OPPORTUNITY );
        if (!ExecuteOnce.SF2SF_OPPORTUNITY){  
            ExecuteOnce.SF2SF_OPPORTUNITY = true;  
            // Processing Not in PNRC... 
            notinPNRC = new List<Opportunity>();
            ParentedUnrestrictedOpportunities = new List<Opportunity>();
        
            // Get list of Opportunity which are not in central org by calling inPNRC method
    
            notinPNRC = OpptyUtil.inPNRC(Trigger.newmap.keySet(),trigger.new,false);
            system.debug('Not in PNRC size' + notinPNRC);
            
            // Get the Opportunitys where parent id not null and Legally Restricted is false
        
            ParentedUnrestrictedOpportunities =OpptyUtil.getParentedUnrestrictedOpportunities(notinPNRC);
            system.debug('ParentedUnrestrictedOpportunitys  size' + ParentedUnrestrictedOpportunities );
    
            // Insert PNRC for unrestricted Opportunitys
            if (ParentedUnrestrictedOpportunities != null){
                OpptyUtil.Insert_PNRC(ParentedUnrestrictedOpportunities );
            } // if (ParentedUnrestrictedOpportunities != null)
    
            
        } // if (!ExecuteOnce.SF2SF_OPPORTUNITY)
    } // try
    catch(DmlException vDmlException) {
        vStrErrorCategory = vDmlException.getTypeName();
        vStrLineNumber    = vDmlException.getLineNumber() + '';
        vStrStackTrace    = vDmlException.getStackTraceString();  
        for (Integer j = 0; j < vDmlException.getNumDml(); j++) {
            System.debug(vDmlException.getDmlMessage(j)); 
            vStrError += vDmlException.getDmlMessage(j);   
        } // for (Integer j = 0; j < vDmlException.getNumDml(); j++)  
    } // catch(DmlException vDmlException) 
    catch(Exception vException){
        vStrErrorCategory = vException.getTypeName();
        vStrLineNumber    = vException.getLineNumber() + '';
        vStrStackTrace    = vException.getStackTraceString();  
        vStrError        += vException.getMessage();
    } // catch(Exception vException)
    finally{
        System.debug(vStrLog);
        if (vStrError != null){
            if (ParentedUnrestrictedOpportunities != null){
                if (ParentedUnrestrictedOpportunities.size() > 0){
                    vStrSfdcRecId = '';
                    for (Opportunity vOppty : ParentedUnrestrictedOpportunities){
                        vStrSfdcRecId += vOppty.Id + ' ^ ';   
                    } // for (Opportunity vOppty : ParentedUnrestrictedOpportunities)
                } // if (ParentedUnrestrictedOpportunities.size() > 0)
            } // if (ParentedUnrestrictedOpportunities != null)     
            SalesforceException.putError('OpportunityAU', '', vStrError, SalesforceConstant.strSfdc, SalesforceConstant.strError,'', 'SF2SF', '', '5', vStrSfdcRecId, '',vStrErrorCategory, vStrLineNumber,vStrStackTrace);  
        } // if (vStrError != null)
    } // finally 
 
 /*----------------------------------------------------------------------------------------------------------------------------------------------*/ 
 
} // End of trigger OpportunityAU