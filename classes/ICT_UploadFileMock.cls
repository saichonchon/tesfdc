global with sharing class ICT_UploadFileMock implements HTTPCalloutMock{
    global HTTPResponse respond(HTTPRequest req){
        HttpResponse res = new HTTPResponse();
        res.setHeader('Content-Type', 'application/JSON');
        //System.assertEquals('https://tetransportation--qa.cs54.my.salesforce.com/services/data/v32.0/sobjects/Task', req.getEndpoint());
        res.setBody('{"OpportunityID_of_C2S__c":"1234","Status" : "In Progress","Priority" : "Normal","Subject" : "C2S_TestRecord","ActivityDate" :"system.today","Opportunity__c" : "10","Description" :"testing..."}');
        res.setStatusCode(200);
        System.assertEquals('POST', req.getMethod());

        return res;
    }
    
    /*global HTTPResponse respond1(HTTPRequest req1){
        HttpResponse res1 = new HTTPResponse();
        res1.setHeader('Content-Type', 'application/JSON');
        System.assertEquals('https://tetransportation--qa.cs54.my.salesforce.com/services/data/v32.0/sobjects/Task', req1.getEndpoint());
        res1.setBody('{"OpportunityID_of_C2S__c":"1234","Status" : "In Progress","Priority" : "Normal","Subject" : "C2S_TestRecord","ActivityDate" :"system.today","Opportunity__c" : "10","Description" :"testing..."}');
        res1.setStatusCode(200);
        System.assertEquals('POST', req1.getMethod());

        return res1;
    }*/
}