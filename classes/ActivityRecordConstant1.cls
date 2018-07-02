/***********************************************************************************************************************
      Name : ActivityRecordConstant1
       Org : C2S 
Copyright : © 2013 TE Connectivity
========================================================================================================================
   Summary : Holds all constants required for Activity Record Batch 1
========================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                           
________________________________________________________________________________________________________________________
VERSION AUTHOR        DATE       DETAIL                                                               MERCURY REQUEST #
________________________________________________________________________________________________________________________
    1.0 Umasankar   01/25/2013   Parent "Activity Record" with appropriate Lead Id 
    1.1 Shantinath  03/18/2013   Updated for deleting Orphan Activity Records
    1.2 Ankit  06/06/2013   SMO 2.0 Phase 1 development
***********************************************************************************************************************/
global class ActivityRecordConstant1 
{
/* __________________ D0. GLOBAL VARIABLE/CONSTANT COMMON FOR ALL ENVIRONMENTS __________________*/
public static String AR2PARENT = ''; // Activity Records to be parented
/*______________________________________________________________________________________________________________________
  Concise Summary : Static initialization code block                                                                          
______________________________________________________________________________________________________________________*/ 
static
{  
AR2PARENT  = 'SELECT a.CO_Lead_Id__c          ,';
AR2PARENT += '       a.Lead__c                ,'; 
AR2PARENT += '       a.Linked2Parent__c       ,'; 
AR2PARENT += '       a.Create_Date__c          '; 
AR2PARENT += '  FROM Activity_Record__c a      ';
AR2PARENT += ' WHERE a.CO_Lead_Id__c   != null ';
AR2PARENT += '   AND a.Lead__c          = null ';
if(Test.isrunningtest()){
    AR2PARENT += ' limit 1 ';
}
} // static
 
/*____________________________________________________________________________________________________________________*/
 
} // global class ActivityRecordConstant1