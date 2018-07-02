/**************************************************************************************************************************************************
Name: OpportunityAI 
Copyright © 2011 TE Connectivity
===================================================================================================================================================
Purpose: This trigger shares the Opportunity from child org to central org                                                  
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR                DATE       DETAIL                                            Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 rgharat/Umasankar     10/25/2011 Initial Development - SF2SF                       1453487  
    1.1 Umasankar Subbaian    12/06/2011 Make opportunity can be created with account      1453487  
**************************************************************************************************************************************************/
trigger OpportunityAI on Opportunity (after insert) 
{
 /*-- 1 Collection variable declaration -------------------------------------*/        
 List<Opportunity> ParentedUnrestrictedOpportunities;
 List<Opportunity> ParentedrestrictedOpportunities;
 List<Opportunity> vLstOppty;
 
 /*-- 2. Primitive variable declaration --------------------------------------*/ 
 String  vStrErrorCategory       = '';
 String  vStrLineNumber          = '';
 String  vStrStackTrace          = '';
 String  vStrError               = '';
 String  vStrLog                 = '';
 String  vStrSfdcRecId           = ''; 
 
 try
 { 
  if (!ExecuteOnce.SF2SF_OPPORTUNITY)
  {
   vLstOppty                         = Trigger.new; // Use this variable for future coding  
   ParentedUnrestrictedOpportunities = new List<Opportunity>();
   ParentedrestrictedOpportunities   = new List<Opportunity>(); 
   // Get list of Parented cum Unrestricted Opportunities 
   ParentedUnrestrictedOpportunities = OpptyUtil.getParentedUnrestrictedOpportunities(vLstOppty);
          
   // Get list of Opportunities where the corresponding parent is not restricted 
   ParentedrestrictedOpportunities = OpptyUtil.IsParentRestricted(ParentedUnrestrictedOpportunities, false );      
   ExecuteOnce.SF2SF_OPPORTUNITY = True;
   OpptyUtil.Insert_PNRC(ParentedrestrictedOpportunities);
  } // if (!ExecuteOnce.SF2SF_OPPORTUNITY)
 } // try
 catch(DmlException vDmlException) 
  {
   vStrErrorCategory = vDmlException.getTypeName();
   vStrLineNumber    = vDmlException.getLineNumber() + '';
   vStrStackTrace    = vDmlException.getStackTraceString();  
   for (Integer j = 0; j < vDmlException.getNumDml(); j++) 
    {
     System.debug(vDmlException.getDmlMessage(j)); 
     vStrError += vDmlException.getDmlMessage(j);   
    } // for (Integer j = 0; j < vDmlException.getNumDml(); j++)  
  } // catch(DmlException vDmlException) 
  catch(Exception vException)
  {
   vStrErrorCategory = vException.getTypeName();
   vStrLineNumber    = vException.getLineNumber() + '';
   vStrStackTrace    = vException.getStackTraceString();  
   vStrError        += vException.getMessage();
  } // catch(Exception vException)
  finally
  {
   System.debug(vStrLog);
   if (vStrError != null)
   {
    if (ParentedrestrictedOpportunities != null)
    {
     if (ParentedrestrictedOpportunities.size() > 0)
     {
      vStrSfdcRecId = '';
      for (Opportunity vOppty : ParentedrestrictedOpportunities)
      {
       vStrSfdcRecId += vOppty.Id + ' ^ ';   
      } // for (Opportunity vOppty : ParentedrestrictedOpportunities)
     } // if (ParentedrestrictedOpportunities.size() > 0)
    } // if (ParentedrestrictedOpportunities != null)    
    SalesforceException.putError('OpportunityAI', '', vStrError, SalesforceConstant.strSfdc, SalesforceConstant.strError,
    '', 'SF2SF', '', '5', vStrSfdcRecId, '',vStrErrorCategory, vStrLineNumber,vStrStackTrace);  
   } // if (vStrError != null)
  } // finally    
 
 /*----------------------------------------------------------------------------------------------------------------------------------------------*/
 
} // trigger OpportunityAI on Opportunity (after insert)