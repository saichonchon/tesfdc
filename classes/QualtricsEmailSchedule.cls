/**
 * 
 * @purpose  REST API calls from C2S to Qualtrics to create reminders in Qualtrics
 * @author      Vigneshwar Kotha
 * @created     2017-05-04   
 * @version     1.0 
 * @Deployment numbers :1934,1955                                                               
 *   
 */ 
public class QualtricsEmailSchedule {
    public static Http objhttp;
    public static HttpRequest req ;
    public static HttpResponse res ;
    public void MakeRestCallout(String a1,String sheduledate1,String from_email,String from_name,String library_id,String Message_id,String Qualtrics_User,String subject1,String Survey_Id,String token)
        {
            Qualtrics_Endpoint__c endpt = Qualtrics_Endpoint__c.getInstance('endpoint');
            String epoint,endpoint;
            if(endpt.Url__c != NULL){
                   endpoint =endpt.url__c;
             }else{
                 endpoint='https://survey.qualtrics.com//WRAPI/ControlPanel/api.php?API_SELECT=ControlPanel&Version=2.5';
             }
            String encodedscheduledate1 = EncodingUtil.urlEncode(sheduledate1,'UTF-8');
            String fromemail =  EncodingUtil.urlEncode(from_email,'UTF-8');
            String fromname = EncodingUtil.urlEncode(from_name,'UTF-8');
            String Subject = EncodingUtil.urlEncode(subject1,'UTF-8');
           objhttp = new Http();
           req = new HttpRequest();
           res = new HttpResponse();
           req.setMethod('POST'); 
          //sendReminder Qualtrics Endpoint
          epoint =endpoint+'&Request=sendReminder&User='+Qualtrics_User+'&Token='+token+'&Format=JSON&ParentEmailDistributionID='+a1+'&SendDate='+encodedscheduledate1+'&FromEmail='+fromemail+'&FromName='+fromname+'&Subject='+subject+'&MessageID='+Message_id+'&LibraryID='+library_id;
         //String epoint =endpoint+'&Request=sendReminder&User=eric_wu%40te.com&Token=oLQFv0Ax84Pknb2u3CWXwadAlbpfUY7AM1e6kBsB&Format=JSON&ParentEmailDistributionID=EMD_38IOB1L8L4va7qZ&SendDate='+encodedscheduledate1+'&FromEmail=eric_wu@te.com&FromName=Qualtrics+Test+7&Subject=Qualtrics&MessageID=MS_8iyx6KMwGwEoJvf&LibraryID=UR_1H3ZfmWOU0bwm21';
           req.setEndpoint(epoint);
          // Set the necessary Headers
            req.setHeader('Accept','application/vnd.cpc.authreturn+xml');
            req.setHeader('Content-type','application/vnd.cpc.authreturn+xml; charset=UTF-8');
            req.setHeader('Accept-Language', 'en-CA');
            req.setTimeout(120000);
            String reqBody = '';
            req.setBody(reqBody);
                 try {
                     res = objhttp.send(req);
                    }
                catch(System.CalloutException e) {
                    System.debug('Callout error: '+ e);
                }
       }
}