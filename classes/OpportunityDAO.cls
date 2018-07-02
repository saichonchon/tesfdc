/**************************************************************************************************************************************************
Name: OpportunityDAO 
Copyright © 2011 TE Connectivity | Instance : BU Org (Eng)
===================================================================================================================================================
Purpose: This class contains all SOQL s and related reusable methods specific to the Opportunity sObject which can be reused in future. 
---------------------------------------------------------------------------------------------------------------------------------------------------
Related Class:                                          
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------                                                         
VERSION AUTHOR        DATE       DETAIL                          Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------   
    1.1 Umasankar     11/04/2011 Initial Development             1453487   
**************************************************************************************************************************************************/
public class OpportunityDAO
{
 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Get Opportunity records                                                                                                              |
 |   Input : List of Account Id s                                                                                                                 |  
 | Returns : List of Opportunities                                                                                                                |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/
 public static List<Opportunity> getOpportunitiesByAccountId(List<String> pLstAccountId)
 {
  /*-- 1.0 Collection variable declaration -----------------------------------------*/  
  List<Opportunity> vLstOppty;
  
  if (pLstAccountId != null)
  {
   if (pLstAccountId.size() > 0 )
   {
    vLstOppty = 
     [
      SELECT o.Id,
             o.Legally_Restricted__c
        FROM Opportunity o
       WHERE o.AccountId = :pLstAccountId       
     ];
   } // if (pLstAccountId.size() > 0 )
  } // if (pLstAccountId != null)
  return vLstOppty;
 } // public static List<Opportunity> getOpportunitiesByAccountId
 
 /*-----------------------------------------------------------------------------------------------------------------------------------------------*/ 
 
} // public class OpportunityDAO