/***********************************************************************************************************************
      Name : ActivityRecordUtil1Test1
       Org : C2S
 Copyright : © 2013 TE Connectivity
========================================================================================================================
   Summary : This class contain positive behavioral test methods for classes mentioned below
________________________________________________________________________________________________________________________
 Apex class(es) whose code is covered : ActivityRecordUtil1, PnrcDao1, ActivityRecordSchedule1, ActivityRecordBatch1, 
                                        ActivityRecordConstant1    
========================================================================================================================
 Code Coverage History:                                                        
________________________________________________________________________________________________________________________
 VERSION DEVELOPER             DATE       DETAIL                                  MERCURY REQUEST #
________________________________________________________________________________________________________________________
     1.0 Mohd Afraz Siddiqui   01/30/2012 Initial Development   
     1.1 Ankit Sharma          05/30/2013 Code coverage   
     
***********************************************************************************************************************/
@isTest(SeeAllData = true)
public class ActivityRecordUtil1Test1 {
 /*
 _______________________________________________________________________________________________________________________
  Method Covered : parentActivityRecord                                                                                                           
 _______________________________________________________________________________________________________________________
       Test Type : Positive behavioral Test.                                                                            
 _______________________________________________________________________________________________________________________
 */ 
 public static List<Activity_Record__c> updateActivity(){
   /*________________________________________D1. COLLECTION VARIABLE DECLARATION______________________________________*/    
   List<Activity_Record__c> vListAr;
   List<PartnerNetworkRecordConnection> vLstPnrc;
   
   /*__________________________________________D2. OBJECT VARIABLE DECLARATION________________________________________*/ 
   Lead vLead;
   PartnerNetworkRecordConnection vPnrc;
   Activity_Record__c vActivityRecord;
   TE_Connection__c vCon;
    
   /*________________________________________D3. PRIMITIVE VARIABLE DECLARATION_______________________________________*/
   String vConnId;
   
   /*________________________________________________I1. INITIALISATION_______________________________________________*/
   vLead = new Lead();
   vActivityRecord = new Activity_Record__c();
   vListAr = new List<Activity_Record__c>();
   vLstPnrc = new List<PartnerNetworkRecordConnection>();
     
   //1. CREATEING A LEAD  
   vLead.FirstName   = 'xyzc';    
   vLead.LastName    = 'abcd';
   vLead.Email       = vLead.FirstName + '.' + vLead.LastName + '@sampledomain.com';    
   vLead.Company     = 'Company 1';
   vLead.Phone       = '+1 8015551212';  
   vLead.Description = 'Description 1';
   vLead.Industry    = 'Industrial';      
   vLead.LeadSource  = 'Preliminary Talk';  
   vLead.Status      = 'Assigned Unaccepted';
   vLead.Rating      = 'Hot';  
   Insert vLead;
   System.debug('New Lead##'+vLead);
   System.debug('New Lead Id##'+vLead.Id);
   
   //2. RETRIEVING CURRENT PNRC RECORD
   //vCon= TE_Connection__c.getValues('CentralOrg');      
   //vConnId = vCon.Id_value__c;
   //System.assertNotEquals(vConnId, '');
   for(PartnerNetworkRecordConnection vTmpPNRC : [SELECT Id, ConnectionId, PartnerRecordId, Status
                                                  FROM PartnerNetworkRecordConnection 
                                                  WHERE ConnectionId =: vConnId 
                                                  AND PartnerRecordId <> NULL 
                                                  AND Status <> 'Inactive' AND Status <> 'Inactive (converted)' ORDER BY ID DESC Limit 5000
                                                 ]){
       String vCheckId = vTmpPNRC.PartnerRecordId;
       if(vCheckId.substring(0,3).equalsIgnoreCase('00Q')){
           vPnrc = vTmpPNRC;
           break; 
       }
   }  
   //System.assertNotEquals(vPnrc.PartnerRecordId, null);

   //3. CREATING AN ACTIVITY
   vActivityRecord.Associated_Email__c      = 'test@email.com';
   vActivityRecord.Lead__c                  = vLead.Id;
   vActivityRecord.Related_Part_Number_s__c = 'Sample part';
   vActivityRecord.Date_Needed__c           = Date.today() + 2;
   vActivityRecord.Activity_Notes__c        = vlead.Description;
   vActivityRecord.ActivityDateTime__c      = DateTime.now();
   vActivityRecord.Activity_Date__c         = Date.Today();
   vActivityRecord.Activity_Source__c       = 'IBM';
   vActivityRecord.Activity_Type__c         = 'Hot';
   //vActivityRecord.CO_Lead_Id__c            = vPnrc.PartnerRecordId; //IMPLIES THAT THIS RECORD CAME FROM SF2SF CONNECTION
   Insert vActivityRecord;
      
   vListAr.add(vActivityRecord);
   
   //4. CALL THE METHOD IN CLASS ActivityRecordUtil1
   ActivityRecordUtil1.parentActivityRecord(vListAr);  
   return vListAr;
 }//static void updateActivity

 
 /*
 _______________________________________________________________________________________________________________________
  Classes Covered : ActivityRecordSchedule1, ActivityRecordBatch1, ActivityRecordConstant1                                                                                                           
 _______________________________________________________________________________________________________________________
        Test Type : Positive behavioral Test.                                                                            
 _______________________________________________________________________________________________________________________
 */ 
 public static void coverActivityRecordSch(List<Activity_Record__c> pListAr){
   /*__________________________________________D2. OBJECT VARIABLE DECLARATION________________________________________*/
   SchedulableContext vSchedulableContext;
   Database.BatchableContext BC;
   
   //CREATE AN INSTANCE OF ActivityRecordSchedule1 AND CALL EXECUTE
   ActivityRecordSchedule1 vArSch = new ActivityRecordSchedule1();
   vArSch.execute(vSchedulableContext);  
   
   //CREATE AN INSTANCE OF ActivityRecordBatch1 AND CALL EXECUTE
   ActivityRecordBatch1 vArBatch = new ActivityRecordBatch1();  
   vArBatch.execute(BC, pListAr);  
       
 }//static void coverActivityRecordSch
 
 /*
 _______________________________________________________________________________________________________________________
  Method    :  coreTestMethod                                                                                                                                                                     
 _______________________________________________________________________________________________________________________
 */ 
   
 static testMethod void coreTestMethod(){
   Test.startTest();  
     List<Activity_Record__c> vListAr = updateActivity();
     coverActivityRecordSch(vListAr);
   Test.stopTest();
 }//testMethod void coreTestMethod
 
 static testMethod void coreTestMethod2(){
   Test.startTest();  
     LeadMgmtConfig__c vLeadMgmtDelayObj = LeadMgmtConfig__c.getValues('Default');
     vLeadMgmtDelayObj.ActivityRecordBatch1_ShareDelay__c = 0;
     update vLeadMgmtDelayObj;
     List<Activity_Record__c> vListAr = updateActivity();
     coverActivityRecordSch(vListAr);
   Test.stopTest();
 }//testMethod void coreTestMethod2
   
}//public class ActivityRecordUtil1Test1