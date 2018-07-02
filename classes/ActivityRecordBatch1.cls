/***********************************************************************************************************************
      Name : ActivityRecordBatch1
       Org : C2S
Copyright : © 2013 TE Connectivity 
========================================================================================================================
   Summary : Parent 'Activity Record' with Lead        
________________________________________________________________________________________________________________________
  
Utilized in(Called in):
-----------------------                                              
========================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
VERSION AUTHOR             DATE       DETAIL                          MERCURY REQUEST #                  
________________________________________________________________________________________________________________________
     1.0 Umasankar       01/28/2013 Initial Development     
     1.1 Ankit  06/06/2013   SMO 2.0 Phase 1 development                  
***********************************************************************************************************************/
global class ActivityRecordBatch1 implements Database.Batchable<sObject>  
{
/* ______________________________ D3. PRIMITIVE VARIABLE DECLARATION ____________________________*/    
global string SOQL;
global boolean vBln = FALSE;
global string vStrStackTrace;
 
/*______________________________________________________________________________________________________________________
   Concise Summary : Constructor                                                                                               
________________________________________________________________________________________________________________________
  Input Parameter  : None                                                                                             
________________________________________________________________________________________________________________________
  Output Parameter : None                                                                                             
______________________________________________________________________________________________________________________*/
global ActivityRecordBatch1()
{ // Method #: 1
if (SOQL == null)
{  
  SOQL = ActivityRecordConstant1.AR2PARENT;
} // if (SOQL == null)  
} // Method #: 1 ActivityRecordBatch1
 
/*______________________________________________________________________________________________________________________
   Concise Summary : Start                                                                                            
________________________________________________________________________________________________________________________
  Input Parameter  :                                                                                                  
________________________________________________________________________________________________________________________
   I1. Name        : BC                                                                                                
       Data Type   : Database.BatchableContext                                                                         
       Description : Batchable Context                                                                                
________________________________________________________________________________________________________________________ 
  Output Parameter :                                                                                                  
________________________________________________________________________________________________________________________
   O1. Name        :                                                                                                   
       Data Type   : Database.Querylocator                                                                             
       Description : Query Locator                                                                                    
______________________________________________________________________________________________________________________*/ 
global Database.QueryLocator start(Database.BatchableContext BC)
{ // Method #: 2
return Database.getQueryLocator(SOQL);
} // Method #: 2 start 
 
/*______________________________________________________________________________________________________________________
  Purpose : Execute                                                                                                   
________________________________________________________________________________________________________________________
  Input Parameter  :                                                                                                  
________________________________________________________________________________________________________________________
   I1. Name        : BC                                                                                                
       Data Type   : Database.BatchableContext                                                                         
       Description : Batchable Context                                                                                
   I2. Name        : pLstAr [scope]                                                                        
       Data Type   : List<Activity_Record__c>                                                                          
       Description : List of "Activity Record"                                                                       
________________________________________________________________________________________________________________________ 
  Output Parameter : None                                                                                             
______________________________________________________________________________________________________________________*/ 
global void execute(Database.BatchableContext BC, List<Activity_Record__c> pLstAr)
{ // Method #: 3
system.debug('***pLstAr***'+pLstAr);
try
{
  ActivityRecordUtil1.parentActivityRecord(pLstAr); 
  vStrStackTrace = ''; 
  vBln = FALSE; 
}
catch(Exception vExc)
{
  vStrStackTrace += vExc; 
  vBln = TRUE;
}
} // Method #: 3 execute
 
/*______________________________________________________________________________________________________________________
  Purpose : Finish                                                                                                    
________________________________________________________________________________________________________________________
  Input Parameter  :                                                                                                  
________________________________________________________________________________________________________________________
   I1. Name        : BC                                                                                                
       Data Type   : Database.BatchableContext                                                                         
       Description : Batchable Context                                                                                
________________________________________________________________________________________________________________________ 
  Output Parameter : None                                                                                             
______________________________________________________________________________________________________________________*/  
global void finish(Database.BatchableContext BC)
{ // Method #: 4  
    //Decler delay variable
    Integer vdelyaSec = 0;
    //Get the values form Custom Setting Name: LeadMgmtConfig__c
    LeadMgmtConfig__c vLeadMgmtDelayObj = LeadMgmtConfig__c.getValues('Default');
    List <String> vErrorRepLst = new List <String>();
    try{
        vdelyaSec = Integer.valueOf(vLeadMgmtDelayObj.ActivityRecordBatch1_ShareDelay__c);
        if(vdelyaSec == null || vdelyaSec == 0){
            vdelyaSec = 900;
        }
        String schDueDate = UtilityActivityRecordBatch1.returnScheduleString(vdelyaSec);
        ActivityRecordSchedule1 vActivityRecObj = new ActivityRecordSchedule1();

        system.schedule('ActivityMappingScheduler @'+schDueDate  , schDueDate , vActivityRecObj );      
    }
    catch(Exception ex){
        vBln = true;
        vErrorRepLst = UtilEmailError.generateEmailLst(vLeadMgmtDelayObj.Error_Recipients__c);
        UtilEmailError.sendErroremail(vErrorRepLst ,string.valueof(ex),'ActivityRecordBatch1'); 
    }
    if(vBln) {
      // Send an email notifying of job exception.
      vErrorRepLst = UtilEmailError.generateEmailLst(vLeadMgmtDelayObj.Error_Recipients__c);
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      mail.setToAddresses(vErrorRepLst); 
      mail.setSubject('Apex Batch Job Status - ActivityRecordBatch1 - EXCEPTION');
      mail.setHtmlBody
      ('The batch Apex job processed with Errors!<br/> Following is the full stack trace of the exception -'+
       + '<hr/>'+vStrStackTrace);
      if(!test.isRunningTest()) {   
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
      } 
    } // if(vBln)
} // Method #: 4 finish
 
/*____________________________________________________________________________________________________________________*/
       
} // global class ActivityRecordBatch1