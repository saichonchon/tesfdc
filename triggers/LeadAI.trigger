/**********************************************************************************************************************
Name: LeadAI 
Copyright © 2011 TE Connectivity | Salesforce Instance : BU Org
=======================================================================================================================
Purpose: This trigger shares the Lead from child org to central org                                                  
=======================================================================================================================
History:                                                        
-----------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR                DATE       DETAIL                                                       Mercury Request #
-----------------------------------------------------------------------------------------------------------------------
    1.0 Umasankar Subbaian    01/10/2012 Transer Lead to Central Org                                    1453487
**********************************************************************************************************************/
trigger LeadAI on Lead (after insert) 
{
 /*-- D1. Collection variable declaration --------------------------------------*/ 
 List<Lead> vLstLead;
 /*-- D2. Primitive variable declaration --------------------------------------*/ 
 String  vStrErrorCategory       = '';
 String  vStrLineNumber          = '';
 String  vStrStackTrace          = '';
 String  vStrOrgName           = ''; 
 String  vStrError               = '';
 String  vStrLog                 = ''; 
 String  vStrSfdcRecId           = ''; 
 try
 {
  /*-- 1. Create an entry in PNRC  --------------------------------------*/ 
  if (!ExecuteOnce.SF2SF_LEAD)
  {
   vLstLead = LeadUtil.getBULeads(Trigger.new);   
   LeadUtil.createLeadInPNRC(vLstLead);
   ExecuteOnce.SF2SF_LEAD = true;
  } // if (!ExecuteOnce.SF2SF_LEAD)
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
  ExecuteOnce.SF2SF_LEAD = true;
  System.debug(vStrLog);
  if (vStrError != null)
  {
   vStrOrgName = TE_Connection__c.getInstance('CentralOrg').Source_BU__c;
   vStrSfdcRecId = '';
   if (vLstLead != null)
   {
    if (vLstLead.size() > 0)
    {
     for (Lead vLead : vLstLead)
     {
      vStrSfdcRecId += vLead.Id + ' ^ ';   
     } // for (Lead vLead : vLstLead)
    } // if (vLstLead.size() > 0)
   } // if (vLstLead != null)
   SalesforceException.putError('LeadAI', '', vStrError, SalesforceConstant.strSfdc + ': ' + vStrOrgName, SalesforceConstant.strError,
   '', 'SF2SF', '', '5', vStrSfdcRecId, '',vStrErrorCategory, vStrLineNumber,vStrStackTrace);  
  } // if (vStrError != null)
 } // finally    
  
 /*----------------------------------------------------------------------------------------------------------------------------------------------*/ 
} // End of trigger LeadAI on Lead (after insert)