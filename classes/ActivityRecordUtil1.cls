/***********************************************************************************************************************
      Name : ActivityRecordUtil1
       Org : C2S
Copyright : © 2013 TE Connectivity
========================================================================================================================
   Summary : This utility class contains business process methods and technical process methods for Activity Records 
________________________________________________________________________________________________________________________   
Apex Trigger utilize this class :     
========================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                           
________________________________________________________________________________________________________________________
VERSION AUTHOR       DATE       DETAIL                                                               MERCURY REQUEST #
________________________________________________________________________________________________________________________
     1.0 Umasankar    01/28/2013 Initial Development
     1.1 Shantinath   03/18/2013 Updated for deletion of Orphan Activity Records      
     1.2 Ankit        05/10/2013 Modified for BU Org.                                                        
***********************************************************************************************************************/
public class ActivityRecordUtil1 
{
/* _____________________________________________________________________________________________________________________   
Concise Summary : Parent 'Activity Record' with Lead
________________________________________________________________________________________________________________________  
Input Parameter :                                                                                                   
________________________________________________________________________________________________________________________
   I1. Name        : pLstAr                                                                                
       Data Type   : List<Activity_Record__c>                                                                                
       Description : List of Activity Records.     
________________________________________________________________________________________________________________________   
  Output Parameter : None  
______________________________________________________________________________________________________________________*/
public static void parentActivityRecord(List<Activity_Record__c> pLstAr)
{ // Method # : 1
/* _____________________________ D1. COLLECTION VARIABLE DECLARATION ____________________________*/
Set<Id>                              vSetCoLeadId; 
List<PartnerNetworkRecordConnection> vLstPnrcLead;
Map<Id, Id>                          vMapCoLeadIdBuLeadId; 
List<Activity_Record__c>             vLstAr; 
List<Activity_Record__c>             vLstArToDelete; 
/* _______________________________ D2. OBJECT VARIABLE DECLARATION ______________________________*/
TE_Connection__c vCon;
    
if (pLstAr != null)
{
  if (pLstAr.size() > 0)
  {
   vSetCoLeadId = new set<Id>();
   for (Activity_Record__c vAr : pLstAr)
   {
    vSetCoLeadId.add(vAr.CO_Lead_Id__c);
   } // for (Activity_Record__c vAr : pLstAr)   
  } // if (pLstAr.size() > 0)   
} // if (pLstAr != null)
  
if (vSetCoLeadId != null)
{
  if (vSetCoLeadId.size() > 0)
  {
   vLstPnrcLead = new List<PartnerNetworkRecordConnection>();
   //vCon = TE_Connection__c.getValues('CentralOrg');    
   //vLstPnrcLead = PnrcDao1.getPnrcByPartnerRecId(vSetCoLeadId, vCon.Id_value__c);       
  } // if (vSetCoLeadId.size() > 0)     
} // if (vSetCoLeadId != null)
 
if (vLstPnrcLead != null)
{
  vMapCoLeadIdBuLeadId = new Map<Id, Id>();
  List<PartnerNetworkRecordConnection> vLstPnrcTemp = new List<PartnerNetworkRecordConnection>();
  system.debug('####vLstPnrcLead'+vLstPnrcLead);
  for(integer i =0;  i < vLstPnrcLead.size() ; i++){
        if(vLstPnrcLead[i].LocalRecordId != null && vLstPnrcLead[i].Status != 'Inactive'){
            if(string.valueof(vLstPnrcLead[i].LocalRecordId).startsWith('00Q')){
              vLstPnrcTemp.add(vLstPnrcLead[i]);
           }
       }
  }

  if(vLstPnrcTemp.size() > 0 && vLstPnrcTemp != null){
      vLstPnrcLead = vLstPnrcTemp;
  }

  for (PartnerNetworkRecordConnection vPnrc : vLstPnrcLead)
  {
   vMapCoLeadIdBuLeadId.put(vPnrc.PartnerRecordId, vPnrc.LocalRecordId);   
  } // for (PartnerNetworkRecordConnection vPnrc : vLstPnrcLead)   
} // if (vLstPnrcLead != null)
 
if (vMapCoLeadIdBuLeadId != null)
{
  vLstAr = new List<Activity_Record__c>(); 
  vLstArToDelete = new List<Activity_Record__c>();     
  for (Activity_Record__c vAr2 : pLstAr)
  {
   if (vMapCoLeadIdBuLeadId.get(vAr2.CO_Lead_Id__c) != null)
   {
    vAr2.Lead__c          = vMapCoLeadIdBuLeadId.get(vAr2.CO_Lead_Id__c);
    vAr2.Linked2Parent__c = true;
    vLstAr.add(vAr2);  
   } // if (vMapCoLeadIdBuLeadId.get(vAr2.CO_Lead_Id__c) != null) 
   else
   {
    if(vAr2.Linked2Parent__c) 
    {
     if(vAr2.Lead__c == NULL)
     {
      if(vAr2.CO_Lead_Id__c != NULL)
      {
       vLstArToDelete.add(vAr2);
      } // if(vAr2.CO_Lead_Id__c != NULL)
     } // if(vAr2.Lead__c == NULL)
    } // if(vAr2.Linked2Parent__c)
    else
    {
     if(vAr2.Create_Date__c < System.Today().addDays((-1)*30) && vAr2.Lead__c == NULL && vAr2.CO_Lead_Id__c != NULL)
     {
      vLstArToDelete.add(vAr2);
     } // if()
    } // else..if(vAr2.Linked2Parent__c) 
   } // else..if(vMapCoLeadIdBuLeadId.get(vAr2.CO_Lead_Id__c) != null) 
  } // for (Activity_Record__c vAr2 : pLstAr)
} // if (vMapCoLeadIdBuLeadId != null)     
 
if (vLstAr != null)
{
  if (vLstAr.size() > 0)
  {
   system.debug('#####vLstAr###'+vLstAr);
   Update vLstAr;   
  } // if (vLstAr.size() > 0)
} // if (vLstAr != null)
 
if (vLstArToDelete != null)
{
  if (vLstArToDelete.size() > 0)
  {
   Delete vLstArToDelete;   
  } // if (vLstAr.size() > 0)
} // if (vLstAr != null)
} // Method # : 1 parentActivityRecord
  
//____________________________________________________________________________________________________________________*/
 
} // public class ActivityRecordUtil1