public class SalesforceUtils 
{
  public static Boolean IsNullOrEmpty(String strInput)
  {
    return ((strInput == null) || (strInput.trim().length() == 0)); 
  }  
  public static String ReplaceNullStringWithEmpty(String strInput)
  {
    return (strInput == null ? '' : strInput);
  }
  
  private static OrgWideSettings__c cfgObj;
  public static OrgWideSettings__c OrgSettings 
  {
    get 
    { 
      if (cfgObj == null)
        cfgObj = OrgWideSettings__c.getValues('Default');
      return cfgObj;
    }
  }
  
  public static Messaging.SendEmailResult[] SendEmail (string ToAddresses, string Subject, string Body)
  {
    Messaging.SendEmailResult[] results; 
    if (!SalesforceUtils.isNullOrEmpty(ToAddresses) && !SalesforceUtils.isNullOrEmpty(Body))
    { 
      List<string> toAddressList = toAddresses.split(';');
      
      Messaging.SingleEmailMessage EmailObj = new Messaging.SingleEmailMessage();   
      EmailObj.setToAddresses(toAddressList);
      EmailObj.setSubject(Subject);    
      EmailObj.setUseSignature(false);
      EmailObj.setHtmlBody(Body);  
      //EmailObj.setReplyTo('robdress@gmail.com');
      //EmailObj.setSenderDisplayName('Robbo');  
      
      results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { EmailObj });
    }
     
    return results;    
  } 

  public static Messaging.SendEmailResult[] SendEmail(String[] pToAddresses, String[] pCcAddresses, String[] pBccAddresses, 
                                                      String pSubject, String pSenderDisplayName, 
                                                      String pReplyTo, String pBody)
  {
    Messaging.SingleEmailMessage vEmail = new Messaging.SingleEmailMessage();
    Messaging.SendEmailResult[] results; 

    try
    {
     if ((pToAddresses != null) && (pToAddresses.size() > 0) && (pSubject != null) && (pBody != null))
     {
       vEmail.setToAddresses(pToAddresses);
       vEmail = new Messaging.SingleEmailMessage();   
       if (pBccAddresses != null &&  pBccAddresses.size() > 0)
       {
         vEmail.setBccSender(true);     
         vEmail.SetBccAddresses(pBccAddresses);
       } 

       if (pCcAddresses != null && pCcAddresses.size() > 0)
         vEmail.setCcAddresses(pCcAddresses);
       
       if (!SalesforceUtils.isNullOrEmpty(pReplyTo))
         vEmail.setReplyTo(pReplyTo); 
           
       if (!SalesforceUtils.isNullOrEmpty(pSenderDisplayName))
         vEmail.setSenderDisplayName(pSenderDisplayName);

       vEmail.setSubject(pSubject);    
       vEmail.setUseSignature(false);
       vEmail.setHtmlBody(pBody);  
       results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { vEmail });    
       System.debug('Email Utility is sending email');
     } // if ((pToAddresses != null) && (pSubject != null) && (pBody != null))
    } // try
    catch(Exception vException)
    {
     System.debug('Exception in "SalesforceUtil.sendEmail" : ' + vException.getMessage());
    } // catch(Exception vException)
    
    return results; 
  }
}