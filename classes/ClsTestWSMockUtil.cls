/**
*   Mock class for webservice test classes
*
@author Bin Yuan
@created 2016-05-12
@version 1.0
@since 33.0 (Force.com ApiVersion)
*
@changelog
* 2016-05-12 Bin Yuan <bin.yuan@oinio.com>
* - Created
*/ 
@isTest
global class ClsTestWSMockUtil {
	/*
	*	mock class for get refresh token web service
	*/
	global class TokenMockHttpResponseGenerator implements HttpCalloutMock {
	    // Implement this interface method
	    global HTTPResponse respond(HTTPRequest req) {
	        // Optionally, only send a mock response for a specific endpoint
	        // and method.
	        // Create a fake response
	        HttpResponse res = new HttpResponse();
	        res.setHeader('Content-Type', 'application/json');
	        res.setBody('{"access_token":"xxxxxxxxxxx"}');
	        res.setStatusCode(200);
	        return res;
	    }
	}    
	        
	/*
	*	mock class for get refresh token web service
	*/
	global class RunReportMockHttpResponseGenerator implements HttpCalloutMock {
	    // Implement this interface method
	    global HTTPResponse respond(HTTPRequest req) {
	        // Optionally, only send a mock response for a specific endpoint
	        // and method.
	        // Create a fake response
	        HttpResponse res = new HttpResponse();
	        res.setHeader('Content-Type', 'application/json');
	        res.setBody('{"id":"xxxxxxxxxxx"}');
	        res.setStatusCode(200);
	        return res;
	    }
	}            
	/*
	*	mock class for get refresh token web service
	*/
	global class ReportResultMockHttpResponseGenerator implements HttpCalloutMock {
	    // Implement this interface method
	    global HTTPResponse respond(HTTPRequest req) {
	        // Optionally, only send a mock response for a specific endpoint
	        // and method.
	        //create a fake result
	        ClsSIPUitl.ReportResultAttribute att = new ClsSIPUitl.ReportResultAttribute();
	        att.id = 'xxxxxId';
	        att.status = 'xxxxxId';
	        att.ownerId = 'xxxxxownerId';
	        att.completionDate = system.now();
	        att.requestDate = system.now().addHours(-6);
	        att.type = 'type';
	        att.reportId = 'xxxxxreportId';
	        att.reportName = 'xxxxxreportName';
	        ClsSIPUitl.ResultFactAggregate fact1 = new ClsSIPUitl.ResultFactAggregate();
	        fact1.label = '$16,000.01';
	        fact1.value = 16000.010000;
	        
	        ClsSIPUitl.ResultFactValue factValue = new ClsSIPUitl.ResultFactValue();
	        factValue.aggregates = new list<ClsSIPUitl.ResultFactAggregate>{fact1};
	        factValue.rows = new list<ClsSIPUitl.ResultFactAggregate>{fact1};
	        
	        
	        
	        ClsSIPUitl.SIPReportResult result = new ClsSIPUitl.SIPReportResult();
	        result.hasDetailRows = true;
	        result.attributes = att;
	        result.allData = true;
	        result.factMap = new map<String, ClsSIPUitl.ResultFactValue>{'T!0_1' => factValue};
	        
	        
	        result.attributes = att;
	        // Create a fake response
	        HttpResponse res = new HttpResponse();
	        res.setHeader('Content-Type', 'application/json');
	        res.setBody(Json.serialize(result));
	        res.setStatusCode(200);
	        return res;
	    }
	}            
}