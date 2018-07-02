/**************************************************************************************************************************************************
Name: LeadAU 
Copyright © 2012 TE Connectivity | Salesforce Instance : BU Org
===================================================================================================================================================
Purpose: This trigger copies the following Leads from BU Org to Central Org via SF2SF for bi-directional transaction.
            1. All old lead dated before SF2SF implementation (Implementation Start Date: 01/26/2012)                                                 
            2. Deleted leads at central org which was originated at BU Org. Sharing again 
===================================================================================================================================================
Requirement Information:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR                DATE       DETAIL                                                   Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 RAHUL GHARAT          01/06/2012 Initial Development - SF2SF                              1453487         
    2.0 UMASANKAR SUBBAIAN    01/12/2012 Create entry in PNRC for old data/sharing again          1453487         
**************************************************************************************************************************************************/
trigger LeadAU on Lead (after update) 
{
 /*-- 1 Collection variable declaration -------------------------------------*/        
 List<Lead> vLstNewBULead;
 List<Lead> vLstNewLead;
 List<Lead> vLstConvLead= new List<Lead> (); 
 /*-- 2. Primitive variable declaration --------------------------------------*/ 
 String  vStrErrorCategory       = ''; 
 String  vStrLineNumber          = '';
 String  vStrStackTrace          = '';
 String  vStrError               = '';
 String  vStrLog                 = '';
 String  vStrSfdcRecId           = ''; 
 String  vStrOrgName             = ''; 
 try
 {
  if (!ExecuteOnce.SF2SF_LEAD)
  {  
   vLstNewLead   = Trigger.new;
   vLstNewBULead = LeadUtil.getBULeads(vLstNewLead,Trigger.old);
   LeadUtil.createLeadInPNRC(LeadUtil.getTobeEnteredLeadsInPnrc(vLstNewBULead));
   
   // For Lead conversion process
   for (Lead con_lead:vLstNewLead)    
   {
    if (con_lead.isConverted == true)
    {
     vLstConvLead.add(con_lead);
    } // if (con_lead.isConverted == true)
   } // for (Lead con_lead:vLstNewLead)
           
   LeadConversionUtil.buildLeadConversionMap(vLstConvLead);
   
  } // if (!ExecuteOnce.SF2SF_LEAD)      
 }//end of try
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
   if (vLstNewLead != null)
   {
    for (Lead vLead : vLstNewLead)
    {
     vStrSfdcRecId += vLead.Id + ' ^ ';   
    } // for (Lead vLead : vLstLead)
   } // if (vLstNewLead != null)
      
   SalesforceException.putError('LeadAU', '', vStrError, SalesforceConstant.strSfdc + ': ' + vStrOrgName, SalesforceConstant.strError,
   '', 'SF2SF', '', '5', vStrSfdcRecId, '',vStrErrorCategory, vStrLineNumber,vStrStackTrace);  
  } // if (vStrError != null)
 } // finally         
} // End of trigger LeadAU on Lead (after update)