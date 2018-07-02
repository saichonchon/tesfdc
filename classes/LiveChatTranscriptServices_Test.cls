@isTest
public class LiveChatTranscriptServices_Test {
  private static final Integer NUMBER_CASES_TO_CREATE = 5;
  
    public static testmethod void testCreateCasesFromLiveChatTranscripts() {
    ClsTestCustomSettingHelper.getCaseFinalVariables();
    ClsTestCustomSettingHelper.getWebToCaseStrings();
    ClsTestCustomSettingHelper.getApex_Helper_Settings();
    String email = 'test@test.com';
    String name = 'Test';
    
    LiveChatVisitor testLiveChatVisitor = TestingUtils.createLiveChatVisitors( 1, true )[0];
    List<LiveChatTranscript> testLiveChatTranscript = TestingUtils.createLiveChatTranscripts( NUMBER_CASES_TO_CREATE, testLiveChatVisitor.Id, false );
    
    for( LiveChatTranscript item : testLiveChatTranscript ){
      item.Email_Address__c = email;
      item.First_Name__c = name;
      item.Last_Name__c = name;
    }
    
    Test.startTest();    
      insert testLiveChatTranscript;    
    Test.stopTest();
  }
}