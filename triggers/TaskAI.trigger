/**********************************************************************************************************************
Name: TaskAI 
Copyright © 2011 TE Connectivity | Salesforce Instance : BU Org
=======================================================================================================================
Purpose: This trigger share the tasks of lead with central org from BU Org via Salesforce to Salesforce                                                 
=======================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                      
-----------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR        DATE       DETAIL                            Mercury Request #
-----------------------------------------------------------------------------------------------------------------------
    1.0 Umasankar   02/14/2012   Initial Development               SMO (1453487)      
**********************************************************************************************************************/
trigger TaskAI on Task (after insert) 
{
 /*-- D1. Collection variable declaration --------------------------------------*/
 List<Task> vLstTask;
 /*-- D2. Primitive variable declaration --------------------------------------*/ 
 String  vStrErrorCategory       = '';
 String  vStrLineNumber          = '';
 String  vStrStackTrace          = '';
 String  vStrError               = '';
 String  vStrLog                 = ''; 
 String  vStrSfdcRecId           = ''; 
 try
 {  
  if (!ExecuteOnce.SF2SF_TASK)
  {
   vLstTask = Trigger.New;
   TaskUtil.shareTasksOfLead(vLstTask);
  } // if (!ExecuteOnce.SF2SF_TASK)
 } // try
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
   System.debug(vStrLog);
   if (vStrError != null)
   {
    if (vLstTask != null)
    {
     if (vLstTask.size() > 0)
     {
      vStrSfdcRecId = '';
      for (Task vTask : vLstTask)
      {
       vStrSfdcRecId += vTask.Id + ' ^ ';   
      } // for (Task vTask : vLstTask)
     } // if (vLstTask.size() > 0)
    } // if (vLstTask != null)   
    SalesforceException.putError('TaskAI', '', vStrError, SalesforceConstant.strSfdc, SalesforceConstant.strError,
    '', 'SF2SF', '', '5', vStrSfdcRecId, '',vStrErrorCategory, vStrLineNumber,vStrStackTrace);  
   } // if (vStrError != null)
  } // finally 
} // trigger TaskAI on Task (after insert)