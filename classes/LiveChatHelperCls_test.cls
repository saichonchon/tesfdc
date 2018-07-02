@isTest
private class LiveChatHelperCls_test {
     @isTest static void testCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new liveChatHelperCls_testMock());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        
        liveChatHelperCls obj = new liveChatHelperCls(Live_Agent_Org_Settings__c.getInstance().epdURl__c+'2a065f7b-f54f-4cc0-8d12-20fefd444594');
     }
}