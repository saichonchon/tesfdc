public with sharing class OpenRTSPageController 
{
    private string rtsUrl = '';
    public string getRtsUrl()
    {
        return rtsUrl;
    }
    
    private string returnUrl = '';
    public string getReturnUrl()
    {
        return returnUrl;
    }   
    
    private string listUrl = '';
    public string getListUrl()
    {
        return listUrl;
    }   
    
  public OpenRTSPageController()
  {
    string requestId;
    requestId = ApexPages.currentPage().getParameters().get('id');
    RTS_Request__c tmpRequest;
    
    OrgWideSettings__c settingsObj;
    settingsObj = OrgWideSettings__c.getValues('Default');
            
    if(settingsObj != null)
    {   
        rtsUrl = settingsObj.rtsUrl__c;
        listUrl = '/' + settingsObj.rtsInterfaceObjectPrefix__c;
    }
    else
    {
        rtsUrl = 'http://requesttrackingtest.us.tycoelectronics.com';
        listUrl = '/a1L';
    }    
    
    tmpRequest = [Select Id, name, RTS_Link__c, RTS_Request_Id__c  from RTS_Request__c where Id = :requestId];
    
    returnUrl = '/' + requestId;
    
    if (tmpRequest == null)
    {
        // some error
    }
    else  
    {
        if (tmpRequest.RTS_Link__c != null && tmpRequest.RTS_Link__c.length() > 0)
          rtsUrl = tmpRequest.RTS_Link__c;
        else if (tmpRequest.RTS_Request_Id__c != null && tmpRequest.RTS_Request_Id__c > 0)
        rtsUrl = rtsUrl + '/ProgramFrameset.aspx?ProgramRevId=' + tmpRequest.RTS_Request_Id__c;
      else
        rtsUrl = '';
        
      // for testing....
     //   rtsUrl = 'http://requesttrackingtest.us.tycoelectronics.com/ProgramFrameset.aspx?ProgramRevId=522265';
    }
    
  }
}