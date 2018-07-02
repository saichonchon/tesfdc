public class ErrorLogging 
{
    
  public static void Log(Exception ex, string ClassName, string MethodName, string RecordId)
  {
    if (SalesforceUtils.OrgSettings.Enable_Error_Logging__c)
    {  
        ErrorLog__c newErrorObj = CreateLogObj(ex);
        newErrorObj.Class__c          = ClassName;
        newErrorObj.Method_Name__c    = MethodName;
        newErrorObj.SFDC_Record_Id__c = RecordId;
        newErrorObj.Error_Code__c     = '';
        newErrorObj.Error_Source__c   = '';
        newErrorObj.Service_Name__c   = '';
        newErrorObj.Severity__c       = '';
        newErrorObj.Transaction_Id__c = '';
      
        LogError(newErrorObj);
    } 
  }
 
  public static void Log(Exception ex)
  {
    if (SalesforceUtils.OrgSettings.Enable_Error_Logging__c)
      LogError(CreateLogObj(ex));   
  }
  
  /*************  Private Methods *********************************/
  private static ErrorLog__c CreateLogObj(Exception ex)
  {
    ErrorLog__c newErrorObj = new ErrorLog__c();
    newErrorObj.Error_Message__c = ex.getMessage();
    if (newErrorObj.Error_Message__c.length() > 32000)
      newErrorObj.Error_Message__c = newErrorObj.Error_Message__c.substring(0, 32000);
    newErrorObj.Error_Type__c = ex.getTypeName();
    newErrorObj.Log_Time__c = Datetime.now();
    newErrorObj.SF_Org_Info__c = UserInfo.getOrganizationId() + ' - ' + UserInfo.getOrganizationName();
    newErrorObj.User_Name__c = UserInfo.getUserName();
    newErrorObj.Error_Category__c = ex.getTypeName();
    newErrorObj.Line_Number__c = ex.getLineNumber() + '';
    newErrorObj.Stack_Trace__c = ex.getStackTraceString();
    
    return newErrorObj;
  }
  
  private static void LogError(ErrorLog__c newErrorLog)
  {
    Database.insert(newErrorLog);
    
    if (SalesforceUtils.OrgSettings.Send_Exception_Email__c)
    {
        // Now send the email
        string emailContent = '';
        emailContent += '<HTML><HEAD><TITLE>Salesforce Exception</TITLE><style>BODY,TD {font-family: Verdana;font-size:smaller;}</style></HEAD><BODY><TABLE border = "1" rules="rows" cellspacing = "0" cellpadding = "2">';
        
        emailContent += '<TR><TD><B>Salesforce Instance:</B></TD><TD>' + newErrorLog.SF_Org_Info__c + '</TD></TR>';
        emailContent += '<TR><TD><B>Date/Time:</B></TD><TD>' + newErrorLog.Log_Time__c + '</TD></TR>';
        emailContent += '<TR><TD><B>Severity:</B></TD><TD>' + SalesforceUtils.replaceNullStringWithEmpty(newErrorLog.Severity__c) + '</TD></TR>';
        emailContent += '<TR><TD><B>Type:</B></TD><TD>' + newErrorLog.Error_Type__c + '</TD></TR>';
        emailContent += '<TR><TD><B>Category:</B></TD><TD>' + newErrorLog.Error_Category__c + '</TD></TR>';
        emailContent += '<TR><TD><B>Apex Class:</B></TD><TD>' + newErrorLog.Class__c + '</TD></TR>';
        emailContent += '<TR><TD><B>Method:</B></TD><TD>' + newErrorLog.Method_Name__c + '</TD></TR>';
        emailContent += '<TR><TD><B>Line Number:</B></TD><TD>' + newErrorLog.Line_Number__c + '</TD></TR>';
        emailContent += '<TR><TD><B>Message:</B></TD><TD>' + newErrorLog.Error_Message__c + '</TD></TR>';
        emailContent += '<TR><TD><B>Source:</B></TD><TD>' + SalesforceUtils.replaceNullStringWithEmpty(newErrorLog.Error_Source__c) + '</TD></TR>';
        emailContent += '<TR><TD><B>Code:</B></TD><TD>' + SalesforceUtils.replaceNullStringWithEmpty(newErrorLog.Error_Code__c) + '</TD></TR>';
        emailContent += '<TR><TD><B>Service:</B></TD><TD>' + SalesforceUtils.replaceNullStringWithEmpty(newErrorLog.Service_Name__c) + '</TD></TR>';
        emailContent += '<TR><TD><B>Record Id:</B></TD><TD>' + SalesforceUtils.replaceNullStringWithEmpty(newErrorLog.SFDC_Record_Id__c) + '</TD></TR>';
        emailContent += '<TR><TD><B>Transaction Id:</B></TD><TD>' + SalesforceUtils.replaceNullStringWithEmpty(newErrorLog.Transaction_Id__c) + '</TD></TR>';
        emailContent += '<TR><TD><B>User:</B></TD><TD>' + newErrorLog.User_Name__c + '</TD></TR>';
        emailContent += '<TR><TD><B>Stack Trace:</B></TD><TD>' + newErrorLog.Stack_Trace__c + '</TD></TR>';
        
        emailContent += '</TABLE></BODY></HTML>';
        System.debug(emailContent);
        
        //SalesforceUtils.SendEmail(SalesforceUtils.OrgSettings.Error_Email_Recipients__c, 'Salesforce Exception', emailContent);
    } 
  }
}