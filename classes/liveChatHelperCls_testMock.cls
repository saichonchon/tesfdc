@isTest
global class liveChatHelperCls_testMock implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"subscribedFlag":false,"emailOptOutFlag":false,"customFields":[],"error":{"errorCode":404,"errorType":"","errorDescription":"No matching profile found for track id"}}');
        res.setStatusCode(200);
        return res;
    }
}