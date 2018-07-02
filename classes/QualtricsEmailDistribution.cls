/**
 * 
 * @purpose  REST API calls from C2S to Qualtrics to create reminders in Qualtrics.
 * @author      Vigneshwar Kotha
 * @created     2017-05-04   
 * @version     1.0 
 * @Deployment numbers :1934,1955                                                               
 *   
 */ 
Public class QualtricsEmailDistribution {
    public static Http objhttp;
    public static HttpRequest req ;
    public static HttpResponse res;
    @InvocableMethod
    /* getting campaign id from Process builder when update the field in Campaign Member*/
    /*Process builder name: Qualtrics Email Distribution API */
    Public Static Void getCampaignid(List<Id> campid){
     MakeRestCalloutEmail(campid);
    }
    @future(callout=true)
    Public static void MakeRestCalloutEmail(List<Id> campid)
        {
            String sheduledate1,sheduledate2;
            String vStrError = '';
            /*fetching campaigns for run the survey with schedule and reminder names */
            Map<id,campaign> camp = new map<id,campaign>([select id,Qualtrics_Schedule_Date__c,Qualtrics_Schedule_Reminder1__c,Qualtrics_Schedule_Reminder2__c,Campaign_Type__c,Qualtrics_Project__c,Qualtrics_Project__r.From_Email__c,Qualtrics_Project__r.From_Name__c,Qualtrics_Project__r.Library_ID__c,Qualtrics_Project__r.Message_Id__c,Qualtrics_Project__r.Qualtrics_User_Id__c,Qualtrics_Project__r.Subject__c, Qualtrics_Project__r.Survey_ID__c,Qualtrics_Project__r.Token__c from Campaign where id IN :campid ]);
           //Custom Setting for End point
           Qualtrics_Endpoint__c endpt = Qualtrics_Endpoint__c.getInstance('endpoint');
             String epoint,endpoint;
             if(endpt.Url__c != NULL){
                   endpoint =endpt.url__c;
             }else{
                 endpoint='https://survey.qualtrics.com//WRAPI/ControlPanel/api.php?API_SELECT=ControlPanel&Version=2.5';
             }
            for(campaign c : camp.values()){
                   objhttp = new Http();
                   req = new HttpRequest();
                   res = new HttpResponse();
                   req.setMethod('GET');
                   req.setHeader('Content-Type', 'application/json;charset=UTF-8');
                   req.setTimeout(60000);
                 sheduledate1 = EncodingUtil.urlEncode(String.valueOf(c.Qualtrics_Schedule_Date__c.addHours(-2)), 'UTF-8');
                 sheduledate2 = EncodingUtil.urlEncode(String.valueOf(c.Qualtrics_Schedule_Date__c.addHours(1)), 'UTF-8');
                 epoint=endpoint+'&Request=getDistributions&User='+c.Qualtrics_Project__r.Qualtrics_User_Id__c+'&Token='+c.Qualtrics_Project__r.Token__c+'&Format=JSON&LibraryID='+c.Qualtrics_Project__r.Library_ID__c+'&SurveyID='+c.Qualtrics_Project__r.Survey_ID__c+'&SendStartDate='+sheduledate1+'&SendEndDate='+sheduledate2+'&Limit=20&DistributionRequestType=SFTrigger';  
                 req.setEndpoint(epoint);
                   // Set the necessary Headers
                   String reqBody = '';
                   req.setBody(reqBody);
                    try {
                         res = objhttp.send(req);
                         System.debug('res data'+res.getBody());
                         }
                      catch(exception e) {
                        vStrError += 'Error Type = ' + e.getTypeName() +  ' Error Line = ' + e.getLineNumber() + '' +  ' Error Stack = ' + e.getStackTraceString() + ' Error Message = ' + e.getMessage();
                        SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '',e.getStackTraceString()); 
                        system.debug('Callout Exception ::' + vStrError);
                     }
              if (res.getStatusCode() == 200 ) {
                 Map<String, Object> results = new  Map<String, Object>();
                     try{
                    results = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
                        }
                     catch(Exception e) {
                           System.debug('Data Exception: '+ e);
                     }
                 Map<String, Object> resultdata = new  Map<String, Object>();
                 resultdata = (Map<String, Object>) results.get('Result');
                 List<Object> disdata = (List<Object>) resultdata.get('Distributions');
                    for(object o: disdata){
                        Map<String, Object> emaildistributions = (Map<String, Object>)JSON.deserializeUntyped(JSON.Serialize(o)); 
                        String a1=String.valueof(emaildistributions.get('EmailDistributionID'));
                        String a2 = String.valueof(emaildistributions.get('CreatedDate'));
                       QualtricsEmailSchedule QES = new QualtricsEmailSchedule();
                       QES.MakeRestCallout(a1,String.valueOf(c.Qualtrics_Schedule_Reminder1__c),c.Qualtrics_Project__r.From_Email__c,c.Qualtrics_Project__r.From_Name__c,c.Qualtrics_Project__r.Library_ID__c,c.Qualtrics_Project__r.Message_Id__c,c.Qualtrics_Project__r.Qualtrics_User_Id__c,c.Qualtrics_Project__r.Subject__c,c.Qualtrics_Project__r.Survey_ID__c,c.Qualtrics_Project__r.Token__c);
                       QES.MakeRestCallout(a1,String.valueOf(c.Qualtrics_Schedule_Reminder2__c),c.Qualtrics_Project__r.From_Email__c,c.Qualtrics_Project__r.From_Name__c,c.Qualtrics_Project__r.Library_ID__c,c.Qualtrics_Project__r.Message_Id__c,c.Qualtrics_Project__r.Qualtrics_User_Id__c,c.Qualtrics_Project__r.Subject__c,c.Qualtrics_Project__r.Survey_ID__c,c.Qualtrics_Project__r.Token__c);
                    }
              }
            
         }    
    }
}