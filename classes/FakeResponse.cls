/**
 * 
 * @purpose  REST API calls from C2S to Qualtrics to create reminders in Qualtrics.
 * @author      Vigneshwar Kotha
 * @created     2017-05-04   
 * @version     1.0 
 * @Deployment numbers :1934,1955                                                               
 *   
 */ 
@isTest
global class FakeResponse implements HttpCalloutMock{
 public HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"Result":{"Distributions":[{"SendStartDate":"2017-04-19 19:18:00","SendEndDate":"2017-04-25 01:12:22","SurveyID":"SV_6A9xOonWBLM94qh","EmailDistributionID":"EMD_eD3MSl14lWZRPmZ","ParentEmailDistributionID":"null","CreatedDate":"2017-04-28 06:08:57"}]}}');
        // response.setBody('"Distributions":{"SendStartDate":"2017-04-19 19:18:00","SendEndDate":"2017-04-25 01:12:22","SurveyID":"SV_6A9xOonWBLM94qh","EmailDistributionID":"EMD_eD3MSl14lWZRPmZ","ParentEmailDistributionID":"null"}');
       // response.setBody('"Result","Distributions"');
        response.setStatusCode(200);
        return response; 
    }
      
    
}