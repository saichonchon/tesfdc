//Generated by wsdl2apex
// modified by Chris Roberts Ph.D to support uppercase app names and custom settings
public class OrchestrationHandler {
    public class OrchestrationHandlerSoap {
        //JNV 10/5/2012 comment out assignment if getting endpoint from config setting
        public String endpoint_x; //= 'http://sfdc-rt-coord-qa.us.tycoelectronics.com:8090/OrchestrationHandler.asmx';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://tempuri.org/', 'OrchestrationHandler'};
        
        public String ProcessOrchestration(String sfdcOrg,String sfdcUsername,String endPointApp,String sfdcData) {
            system.debug('3***** - ' + sfdcOrg + ' ' + endPointApp + ' ' + sfdcData);
            OrchestrationHandler.ProcessOrchestration_element request_x = new OrchestrationHandler.ProcessOrchestration_element();
            OrchestrationHandler.ProcessOrchestrationResponse_element response_x;
            //JNV 10/5/2012 uncomment line below
            request_x.sfdcOrg = sfdcOrg;
            request_x.sfdcUsername = sfdcUsername;
            request_x.endPointApp = endPointApp.toUpperCase();
            request_x.sfdcData = sfdcData;
            //JNV 10/5/2012 uncomment lines below
            //endpoint_x = endPointApp.toUpperCase();              
            Map<String, OrchestrationHandler.ProcessOrchestrationResponse_element> response_map_x = new Map<String, OrchestrationHandler.ProcessOrchestrationResponse_element>();
            response_map_x.put('response_x', response_x);
            //JNV 10/5/2012 comment out real time settings here, when setting in real_time_call
            /*for(realtime_Callout_Settings__c rcs : realtime_Callout_Settings__c.getAll().values()) {
                if(rcs.Active__c == true ) {
                    if(rcs.Name == 'Prod PLM Project Push' || rcs.Name == 'QA PLM Project Push'){
                        endpoint_x = rcs.endpoint_url__c;
                        clientCertName_x = rcs.Certificate_name__c;
                        request_x.sfdcOrg = rcs.Traffic_Cop_Org_Name__c;  
                    }
                }
             }*/
             //*
           
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://tempuri.org/ProcessOrchestration',
              'http://tempuri.org/',
              'ProcessOrchestration',
              'http://tempuri.org/',
              'ProcessOrchestrationResponse',
              'OrchestrationHandler.ProcessOrchestrationResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            //Added by Prashant for Deploy-1420 -To fix the null Pointer Exceptions which causing test class Failures
            if(response_x != null)
                return response_x.ProcessOrchestrationResult;
            else
                return '';
        }
    }
    public class ProcessOrchestration_element {
        public String sfdcOrg;
        public String sfdcUsername;
        public String endPointApp;
        public String sfdcData;
        private String[] sfdcOrg_type_info = new String[]{'sfdcOrg','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] sfdcUsername_type_info = new String[]{'sfdcUsername','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] endPointApp_type_info = new String[]{'endPointApp','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] sfdcData_type_info = new String[]{'sfdcData','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'sfdcOrg','sfdcUsername','endPointApp','sfdcData'};
    }
    public class ProcessOrchestrationResponse_element {
        public String ProcessOrchestrationResult;
        private String[] ProcessOrchestrationResult_type_info = new String[]{'ProcessOrchestrationResult','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'ProcessOrchestrationResult'};
    }
}