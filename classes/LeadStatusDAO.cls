/**********************************************************************************************************************
 Name: LeadStatusDAO 
 Copyright © 2012 TE Connectivity | Salesforce Instance : BU Org
=======================================================================================================================
 Purpose: This class contains all the database queries (SOQL) specific to the LeadStatus sObject which can be reused 
           in future. 
-----------------------------------------------------------------------------------------------------------------------
 Related Class:                                          
=======================================================================================================================
 Requirement Information & Development Information:                                                       
-----------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR        DATE       DETAIL                                     Mercury Request #
-----------------------------------------------------------------------------------------------------------------------
    1.0 Umasankar     03/06/2012 Initial Develeopment                       SMO (1453487)  
**********************************************************************************************************************/
public class LeadStatusDAO
{
 /*____________________________________________________________________________________________________________________
 | Purpose : To get the list of values for the Staus field (Picklist entries) which are checked for                   |
 |           "Converted"                                                                                              |
 |____________________________________________________________________________________________________________________|
 | Input Parameter : None                                                                                             |
 |____________________________________________________________________________________________________________________|
 | Output Parameter :                                                                                                 |
 |____________________________________________________________________________________________________________________|
 |   1. Name        : List of LeadStatus                                                                              |
 |      Data Type   : List<LeadStatus>                                                                                |
 |      Description : Picklist entries of Lead Status marked eligible for "Converted"                                 |
 |___________________________________________________________________________________________________________________*/
 public static List<LeadStatus> getValuesMarkedForConverted()
 {
  /*-- D1. Collection variable declaration --------------------------------------*/
  List<LeadStatus> vLstLeadStatus;

  vLstLeadStatus = 
   [
    SELECT l.MasterLabel 
      FROM LeadStatus l
     WHERE l.IsConverted = true
   ];
   
  return vLstLeadStatus;
 } // public static List<LeadStatus> getValuesMarkedForConverted()
 
 /*__________________________________________________________________________________________________________________*/ 
 
} // public class LeadStatusDAO