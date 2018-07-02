@istest
public class NDRInitiateSFDC2SAPForQuoteURL_test
{
    static testmethod void NDRInitiateSFDC2SAPForQuoteURL_test()
    {
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        ClsTestCustomSettingHelper.getrealtime_Callout_Settings();
        test.starttest();
        NDRInitiateSFDC2SAPForQuoteURL.InitiateOrch('');
        NDRInitiateSFDC2SAPForQuoteURL.getPricingSignal('');
        test.stoptest();
        
    }
     static testmethod void NDRInitiateSFDC2SAPForQuoteURL_test1()
    {
        ClsTestCustomSettingHelper.getrealtime_Callout_Settings();
        test.starttest();
        NDRInitiateSFDC2SAPForQuoteURL.InitiateOrch('');
        NDRInitiateSFDC2SAPForQuoteURL.getPricingSignal('');
        test.stoptest();
        
    }
}