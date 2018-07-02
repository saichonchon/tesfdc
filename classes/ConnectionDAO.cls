/**********************************************************************************************************************
 Name: ConnectionDAO 
 Copyright © 2012 TE Connectivity | Salesforce Instance : BU Org
=======================================================================================================================
 Purpose: This class contains all the database queries (SOQL) specific to the PartnerNetworkConnection and 
          PartnerNetworkRecordConnection objects which can be reused in future. 
-----------------------------------------------------------------------------------------------------------------------
 Related Class: TaskUtil                                         
=======================================================================================================================
 Requirement Information & Development Information:                                                       
-----------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR        DATE       DETAIL                                     Mercury Request #
-----------------------------------------------------------------------------------------------------------------------
    1.0 Umasankar     02/14/2012 Initial Develeopment                       SMO (1453487)  
**********************************************************************************************************************/
public class ConnectionDAO
{
 /*____________________________________________________________________________________________________________________
 | Purpose : To get the list of PartnerNetworkRecordConnection with the status not in 'Inactive', 'Deleted' or        |
 |           'Converted'                                                                                              |
 |____________________________________________________________________________________________________________________|
 | Input Parameter :                                                                                                  |
 |____________________________________________________________________________________________________________________|
 |   1. Name        : List of "Local Record Id" to be collaborated with other salesforce instance                     |
 |      Data Type   : List<String>                                                                                    |
 |      Description : List of SFDC record id s (may be from one sObject type or more)                                 | 
 |____________________________________________________________________________________________________________________|
 | Output Parameter :                                                                                                 |
 |____________________________________________________________________________________________________________________|
 |   1. Name        : List of Partner Network Record Connections                                                      |
 |      Data Type   : List<PartnerNetworkRecordConnection>                                                            |
 |      Description : List of Partner Network Record Connections. It is null if list of local record id s is null     |
 |___________________________________________________________________________________________________________________*/
 public static List<PartnerNetworkRecordConnection> getPnrcByLocalRecId(List<String> pLstId)
 {
  /*-- D1. Collection variable declaration --------------------------------------*/
  List<PartnerNetworkRecordConnection> vLstPnrc;
   if (pLstId != null)
   {
    if (pLstId.size() > 0 )
    {
     vLstPnrc = 
     [
      SELECT c.Id, 
             c.LocalRecordId 
        FROM PartnerNetworkRecordConnection c 
       WHERE c.LocalRecordId in :pLstId 
         AND c.Status not in ('Inactive', 'Deleted', 'Converted')
     ];
    } // if (pLstId.size() > 0 )
   } // if (pLstId != null)

  return vLstPnrc;
 } // public static List<PartnerNetworkRecordConnection> getPnrcByLocalRecId()
 
 /*__________________________________________________________________________________________________________________*/ 
 
} // public class ConnectionDAO