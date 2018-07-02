public with sharing class real_time_call{
 // Env settings for qa or prod
 //JNV 10/18 - comment out, add defaults to configSettings
  private final String serviceEndpoint =                'https://sfdcgateway-qa.te.com/ProcessHandler.asmx'; // PROD  'https://sfdcgateway.te.com/ProcessHandler.asmx';
  private final String OrchestrationHandlerEndpoint =   'https://sfdcgateway-qa.te.com/OrchestrationHandler.asmx';// PROD 'https://sfdcgateway.te.com/OrchestrationHandler.asmx'
  private final String certName =                       'C2S_QA_RT_Cert';//cert name in SFDC
  private final String orgName =                        'C2S'; //'CIS'

   // getters and setters  
  
  //JNV 10/5/2012 comment these out if pass in as parameters - change in test class
  public String endPointApp;
  public String sfdcData    {get;set;}
  //*
  
  public String WSResponse  {get;set;}
  //public String Response {get;set;}

  //Constructor
  public real_time_call(ApexPages.StandardController controller) {
                            
  }
  
  // helper method to get custom configuration values 
 
  public static realtime_Callout_Settings__c configSettings(string theName) {
      List<realtime_Callout_Settings__c> ret_val = [SELECT active__c, Certificate_name__c, endpoint_url__c, Traffic_Cop_Org_Name__c, Name FROM realtime_Callout_Settings__c WHERE active__c= True AND Name =: theName Limit 1 ];
      /*JNV 10/5/2012 
      JNV 10/18 */      
      if(ret_val.size() == 0)
      {
        realtime_Callout_Settings__c rcs = new realtime_Callout_Settings__c();
        rcs.endpoint_url__c = 'https://sfdcgateway-qa.te.com:8090/ProcessHandler.asmx';
        rcs.Certificate_name__c = 'C2S_QA_RT_Cert';
        rcs.Traffic_Cop_Org_Name__c = 'C2S';
        ret_val.add(rcs);
      }
      return ret_val.get(0);
  }
  /* this method calls cast iron in an async manner
     this method uses :
     endPointApp (name of the CI Orchestration to be called)
     sfdcData  (prams to send the Cast Iron Orchestration)   
     //JNV 10/5/2012 configName (name of configuration setting to use for endpoint)
  */
 //JNV 10/17 public static String callOrchestrationTrafficCop(string endPointApp, string sfdcData) {
  //JNV 10/5/2012 
  public static String callOrchestrationRealTime(string endPointApp, string sfdcData, string configName) {      
     String Response;   
     system.debug('2***** - ' + endPointApp + ' ' + sfdcData);
     OrchestrationHandler.OrchestrationHandlerSoap mySoap = new OrchestrationHandler.OrchestrationHandlerSoap();
     //JNV 10/17 realtime_Callout_Settings__c Settings = configSettings('QA PLM Project Push');
     //JNV 10/5/2012 
     realtime_Callout_Settings__c Settings = configSettings(configName);     
     mySoap.endpoint_x = Settings.endpoint_url__c;
     mySoap.clientCertName_x = Settings.Certificate_name__c; 
     String certName = Settings.Certificate_name__c;//cert name in SFDC
     String orgName = Settings.Traffic_Cop_Org_Name__c; //'CIS'
     
     Response = mySoap.ProcessOrchestration(orgName, UserInfo.getUserName(), endPointApp , sfdcData); 
     //Added by Prashant for Deploy-1420 -To fix the null Pointer Exceptions which causing test class Failures
     if(Response != null)
         return Response;
     else
         return '';
  }
  
  //this is the attach plm file an async call out
  //JNV 10/17
  //public static string attachPLMFile( String Objid){
  //JNV 10/18 - comment out entire method, use generic orchestration call instead
  /*public static string attachPLMFile( String Objid, String configName){   
       //set up vars
       String sfdcData=''+Objid+'';
       String Response;
       ApexPages.StandardController con = new ApexPages.StandardController(new Account());
       /* JNV 10/17              
       real_time_call inst = new real_time_call(con);

       realtime_Callout_Settings__c Settings = configSettings('QA PLM Attachment Push');       
       String OrchestrationHandlerEndpoint =  Settings.endpoint_url__c;
       String certName = Settings.Certificate_name__c;//cert name in SFDC
       String orgName =  Settings.Traffic_Cop_Org_Name__c; //'CIS' */
        
       /*String endPointApp  = 'CISpushFileToPLM';
       // 'CISpushFileToPLM'  requires a command string "RecordID"
       //JNV 10/17
       //Response = callOrchestrationTrafficCop(endPointApp,sfdcData);
       Response = callOrchestrationRealTime(endPointApp,sfdcData, configName);
       return Response;
  }*/
  
  
 /* this method calls a web service in sync
     this method uses :
     serviceEndpoint
     certName 
     orgName
     endPointApp (name of the web service to call)
     sfdcData  (prams to send the Web service at the endpoint) 
     example call for pick lists:
     endPointApp "PLMLIST"
     sfdcData (TE Network ID “||” BU/ProfitCenter e.g. “US0T2151||IND”) 
     endPointApp "MASTERDATALIST"
     sfdcData (BU/ProfitCenter e.g. “IND”)  
  */ 
  //JNV 10/17 public String callRealTime() {
  //JNV 10/5/2012 
  public static string callWSRealTime(string endPointApp, string sfdcData, string configName) {     
     String Response;     
     TrafficCopWS.ProcessHandlerSoap mySoap = new TrafficCopWS.ProcessHandlerSoap();
     //JNV 10/5/2012 
     realtime_Callout_Settings__c Settings = configSettings(configName); 
     system.debug('*****callWSRealTime ' + endPointApp + ' ' + sfdcData + ' ' + configName);    
     mySoap.endpoint_x = Settings.endpoint_url__c;
     //JNV 10/17 uncomment
     mySoap.clientCertName_x = Settings.Certificate_name__c; 
     String certName = Settings.Certificate_name__c;//cert name in SFDC
     String orgName = Settings.Traffic_Cop_Org_Name__c; //'CIS'  
     //JNV 10/17 comment out  
     //mySoap.endpoint_x =           serviceEndpoint;
     //mySoap.clientCertName_x =     certName;
     mySoap.timeout_x = 60000;      
     Response = mySoap.ProcessRequest(orgName, UserInfo.getUserName(), endPointApp, sfdcData);  
     //Added by Prashant for Deploy-1420 -To fix the null Pointer Exceptions which causing test class Failures  
     if(Response != null)     
         return Response;
     else
         return '';
  }
  
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //Test methods
  @isTest(seealldata=true)
  static void real_time_call_1() {
       //start test
      test.starttest();
      Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        //JNV 10/18 comment out, fix test later
        //create controller object instance to test against
        //ApexPages.StandardController con = new ApexPages.StandardController(new Account());               
        //real_time_call Ctlr = new real_time_call(con);
        //point the test instance to a page 
        //PageReference pageRef1 = new PageReference('/apex/pagename?prams');
        //Test.setCurrentPage(pageRef1);
        
        // methods to test and vars to set
                
         //Ctlr.endPointApp = 'PLMLIST';
         //Ctlr.sfdcData =  'US075379||IND';
         //string result = Ctlr.callRealTime();
         real_time_call.callWSRealTime('PLM', 'US075379||IND', 'QA PLM Picklist');
         // end the test     
     test.stoptest();
   } 
   
   
   @isTest(seealldata=true) 
  static  void real_time_call_2() {
      //start test
      test.starttest();
      Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
      //JNV 10/18 comment out, fix test later      
        //create controller object instance to test against
        //ApexPages.StandardController con = new ApexPages.StandardController(new Account());               
        //real_time_call Ctlr = new real_time_call(con);
        //point the test instance to a page 
        //PageReference pageRef1 = new PageReference('/apex/pagename?prams');
        //Test.setCurrentPage(pageRef1);
        
        // methods to test and vars to set
         //Ctlr.endPointApp = 'PLMLIST'; 
         //Ctlr.sfdcData ='US0T2151||IND'; 
         //string result = callOrchestrationTrafficCop('test','test');
         real_time_call.callOrchestrationRealTime('PLM', 'US075379||IND', 'QA PLM Picklist');             
        // end the test     
     test.stoptest();
   } 
    @isTest(seealldata=true)
    static  void real_time_call_3() {
    //JNV 10/18 comment out, fix test later 
      //start test
      string configName;
      
      for(realtime_Callout_Settings__c rcs : realtime_Callout_Settings__c.getAll().values()) {
        if(rcs.Active__c == true ) {
            if(rcs.Name == 'Prod PLM Picklist' || rcs.Name == 'QA PLM Picklist'){
                configName = rcs.Name;  
            }
        }
      }      
      
      test.starttest();
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        //create controller object instance to test against
        ApexPages.StandardController con = new ApexPages.StandardController(new Account());               
        real_time_call Ctlr = new real_time_call(con);
        //point the test instance to a page 
        PageReference pageRef1 = new PageReference('/apex/pagename?prams');
        Test.setCurrentPage(pageRef1);
        
        // methods to test and vars to set
        //JNV 10/17 comment out, fix test later
        //string result = attachPLMFile('testobj');
         real_time_call.callWSRealTime('PLM', 'US075379||IND', 'QA PLM Picklist');        
                 // end the test     
     test.stoptest();
   } 
   @isTest(seealldata=true) 
  static  void real_time_call_4() {
      //start test
      test.starttest();
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
      //JNV 10/18 comment out, fix test later      
        //create controller object instance to test against
        //ApexPages.StandardController con = new ApexPages.StandardController(new Account());               
        //real_time_call Ctlr = new real_time_call(con);
        //point the test instance to a page 
        //PageReference pageRef1 = new PageReference('/apex/pagename?prams');
        //Test.setCurrentPage(pageRef1);
        
        // methods to test and vars to set
         //Ctlr.endPointApp = 'PLMLIST'; 
         //Ctlr.sfdcData ='US0T2151||IND'; 
         //string result = callOrchestrationTrafficCop('test','test');
         real_time_call.callOrchestrationRealTime('PLM', 'US075379||IND', 'NotARealCustomSettingName');             
        // end the test     
     test.stoptest();
   } 
}