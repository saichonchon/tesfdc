/**********************************************************************************************************************
Name: SF2SFUtil   
Copyright © 2012 TE Connectivity | Salesforce Instance : BU Org
=======================================================================================================================
Purpose: Salesforce to Salesforce Utility class is prvoiding methods to instantiate PNRC. Instantiated records will be
         shared with central Org, when inserted.    
=======================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                      
-----------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR        DATE       DETAIL                            Mercury Request #
-----------------------------------------------------------------------------------------------------------------------
    1.0 Rahul Gharat  01/10/2011 Initial Development               SMO (1453487)    
**********************************************************************************************************************/
public with sharing class SF2SFUtil 
{
 //Function to Instantiate the PNRC records  
 public static PartnerNetworkRecordConnection newPNRC(Id connId, Id recId, String relatedObjects ) 
 {
  PartnerNetworkRecordConnection pnrc = new PartnerNetworkRecordConnection();
      
  pnrc.ConnectionId = connId;
  pnrc.LocalRecordId = recId;
  pnrc.RelatedRecords= relatedObjects;    
  pnrc.SendClosedTasks = true;
  pnrc.SendOpenTasks = true;        
  return pnrc;
 }
    
 Public static PartnerNetworkRecordConnection newPNRC(Id connId, Id recId, Id parentId)
 {
  System.debug('connection id ==='+connId + 'Local recordid =='+recId +'parent id =='+ parentId);
     
  PartnerNetworkRecordConnection pnrc = new PartnerNetworkRecordConnection();
  pnrc.ConnectionId    = connId;
  pnrc.LocalRecordId   = recId;
  pnrc.ParentRecordId  = parentId;
  return pnrc;
 }    
 /*____________________________________________________________________________________________________________________
 | Purpose : Share any sObject with open tasks and closed tasks                                                       |
 |____________________________________________________________________________________________________________________|
 | Input Parameter  :                                                                                                 |
 |____________________________________________________________________________________________________________________|
 |  I1. Name        : Connection Id                                                                                   | 
 |      Data Type   : Id                                                                                              | 
 |      Description : SFDC record identifier for connection definition                                                |  
 |  I2. Name        : Local Record Id                                                                                 | 
 |      Data Type   : Id                                                                                              | 
 |      Description : SFDC record identifier for the record to be shared to the Central Org from BU Org               |  
 |____________________________________________________________________________________________________________________|
 | Output Parameter :                                                                                                 |
 |____________________________________________________________________________________________________________________|
 |  O1. Name        : Partner Network Record Connection                                                               | 
 |      Data Type   : PartnerNetworkRecordConnection                                                                  | 
 |      Description : Instance of PartnerNetworkRecordConnection record                                               |  
 |___________________________________________________________________________________________________________________*/
 Public static PartnerNetworkRecordConnection newPNRC(Id pConnId, Id pRecId)
 {
  PartnerNetworkRecordConnection vPnrc = new PartnerNetworkRecordConnection();
  vPnrc.ConnectionId    = pConnId;
  vPnrc.LocalRecordId   = pRecId; 
  vPnrc.SendClosedTasks = true;
  vPnrc.SendOpenTasks   = true;  
  return vPnrc;
 } // Public static PartnerNetworkRecordConnection newPNRC

 /*__________________________________________________________________________________________________________________*/ 
  
} // public with sharing class SF2SFUtil