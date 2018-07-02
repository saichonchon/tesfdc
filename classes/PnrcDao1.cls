/***********************************************************************************************************************
      Name : PnrcDao1
       Org : C2S
Copyright : © 2013 TE Connectivity
========================================================================================================================
   Summary : This class contains all the database queries specific to the PartnerNetworkRecordConnection which can 
             be reused in future. 
------------------------------------------------------------------------------------------------------------------------
Utilized in(Called in):
-----------------------
                                           
========================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                        
------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR        DATE       DETAIL                                     Mercury Request #
------------------------------------------------------------------------------------------------------------------------
     1.0 Umasankar     01/28/2013 Collaborate Activity Record       
     1.1 Ankit         05/10/2013 Added C.Status in the Query                      
***********************************************************************************************************************/
public class PnrcDao1 
{
/*______________________________________________________________________________________________________________________
   Concise Summary : Fetch list of PNRC rows by Partner Record Id s                                    
________________________________________________________________________________________________________________________
  Input Parameter  :                                                                                                  
________________________________________________________________________________________________________________________
   I1. Name        : pSetPartnerRecId                                                                                         
       Data Type   : Set<Id>                                                                                          
       Description : Set of 'Partner Record Id' s 
   I1. Name        : pConnectionId                                                                                         
       Data Type   : Id                                                                                          
       Description : Id of PNC (SF2SF Connection Id)                             
________________________________________________________________________________________________________________________ 
  Output Parameter :                                                                                                  
________________________________________________________________________________________________________________________
   O1. Name        : vLstPnrc                                                                                     
       Data Type   : List<PartnerNetworkRecordConnection>                                                                               
       Description : List of PNRC rows                                                                         
______________________________________________________________________________________________________________________*/
public static List<PartnerNetworkRecordConnection> getPnrcByPartnerRecId(Set<Id> pSetPartnerRecId, Id pConnectionId)
{
/* _____________________________ D1. COLLECTION VARIABLE DECLARATION ____________________________*/
List<PartnerNetworkRecordConnection> vLstPNRC;
 
if (pSetPartnerRecId != null)
{
  if (pSetPartnerRecId.size() > 0 )
  {
  system.debug('***pSetPartnerRecId***'+pSetPartnerRecId);   
   vLstPNRC = 
    [
     SELECT C.Id           , 
            C.LocalRecordId,
            C.PartnerRecordId,
            C.Status   
       FROM PartnerNetworkRecordConnection C 
      WHERE C.PartnerRecordId in :pSetPartnerRecId
        AND C.ConnectionId = :pConnectionId      
    ]; 
  } // if (pSetPartnerRecId.size() > 0 )
} // if (pSetPartnerRecId != null)
return vLstPNRC;
} // public static List<PartnerNetworkRecordConnection> getPNRC()
 
/* ___________________________________________________________________________________________________________________*/
 
} // public class PnrcDao1