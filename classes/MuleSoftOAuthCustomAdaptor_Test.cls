/**********************************************************************
Name:  MuleSoftOAuthCustomAdaptor_Test 
Copyright © 2017
======================================================
======================================================
Purpose: Test Class for MuleSoftOAuthCustomAdaptor
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR                DATE             DETAIL               Description
 0.1        Supriya A          10/20/2017         INITIAL DEVELOPMENT  Test Class for MuleSoftOAuthCustomAdaptor

***********************************************************************/


@IsTest
public class MuleSoftOAuthCustomAdaptor_Test {

    private static final String OAUTH_TOKEN = 'testToken';
    private static final String STATE = 'mocktestState';
    private static final String REFRESH_TOKEN = 'refreshToken';
    private static final String LOGIN_ID = 'testLoginId';
    private static final String USERNAME = 'testUsername';
    private static final String FIRST_NAME = 'testFirstName';
    private static final String LAST_NAME = 'testLastName';
    private static final String EMAIL_ADDRESS = 'testEmailAddress';
    private static final String LOCALE_NAME = 'testLocalName';
    private static final String FULL_NAME = FIRST_NAME + ' ' + LAST_NAME;
    private static final String PROVIDER = 'MuleSoft';
    private static final String REDIRECT_URL = 'https://test.salesforce.com/services/authcallback/00Dg0000001qO6gEAE/MuleSoftOauthProvider';
    private static final String KEY = 'testKey';
    private static final String SECRET = 'testSecret';
    private static final String STATE_TO_PROPOGATE  = 'testState';
    private static final String ACCESS_TOKEN_URL = 'https://mulesoft-qa.connect.te.com/access_token';
    private static final String API_USER_VERSION_URL = 'http://www.dummyhost.com/user/20/1';
    private static final String AUTH_URL = 'https://mulesoft-qa.connect.te.com/authorize';

    @TestSetup
    public static void testDataSetup() 
    {
             String muleSoftClientCertificateName;
           for(MuleSoftOauth__mdt mdt:[SELECT Id, Access_Token_Url__c, API_User_Url__c, Auth_Url__c, CertificateName__c, Key__c, 
                    
                                                redirectUrl__c,Secret__c FROM MuleSoftOauth__mdt])
              {
                 system.debug('&&&&&&&&&&&&&' +mdt.CertificateName__c);
                 muleSoftClientCertificateName=mdt.CertificateName__c;
              }
                                                
                                                
           system.debug('$$$$$$$$' +muleSoftClientCertificateName);
           
           ADM_Custom_Setting__c admConfig = new ADM_Custom_Setting__c();
           admConfig.Name = 'ADM_MuleSoftClientCertificateName';
           admConfig.Value__c = muleSoftClientCertificateName;
           insert admConfig;   
    }
    
    // in the real world scenario , the key and value would be read from the (custom fields in) custom metadata type record
    private static Map<String,String> setupAuthProviderConfig () {
            Map<String,String> authProviderConfiguration = new Map<String,String>();
           authProviderConfiguration.put('Key__c', KEY);
           authProviderConfiguration.put('Auth_Url__c', AUTH_URL);
           authProviderConfiguration.put('Secret__c', SECRET);
           authProviderConfiguration.put('Access_Token_Url__c', ACCESS_TOKEN_URL);
           authProviderConfiguration.put('redirectUrl__c',REDIRECT_URL);
           return authProviderConfiguration;
          
    }

    static testMethod void testInitiateMethod() {
           String stateToPropogate = 'mocktestState';
           Map<String,String> authProviderConfiguration = setupAuthProviderConfig();
           MuleSoftOAuthCustomAdaptor MuleSoftOAuthCustomAdaptorCls = new MuleSoftOAuthCustomAdaptor();
           MuleSoftOAuthCustomAdaptorCls.getCustomMetadataType();
           MuleSoftOAuthCustomAdaptorCls.redirectUrl = authProviderConfiguration.get('Redirect_Url__c');
           MuleSoftOAuthCustomAdaptorCls.getCustomMetadataType();
           PageReference expectedUrl =  new PageReference(authProviderConfiguration.get('Auth_Url__c') + '?client_id='+ 
                                               authProviderConfiguration.get('Key__c') +'&scope=USER,EXPRPT,LIST&redirect_uri='+ 
                                               authProviderConfiguration.get('Redirect_Url__c') + '&state=' + 
                                               STATE_TO_PROPOGATE);
            PageReference actualUrl = MuleSoftOAuthCustomAdaptorCls.initiate(authProviderConfiguration, STATE_TO_PROPOGATE);
           
       }
    
    static testMethod void testHandleCallback() {
          /* ADM_Custom_Setting__c admConfig = new ADM_Custom_Setting__c();
           admConfig.Name = 'ADM_MuleSoftClientCertificateName';
           admConfig.Value__c = 'sfdcmulesoftpoc';
           insert admConfig;*/
           Test.startTest();

           Map<String,String> authProviderConfiguration = setupAuthProviderConfig();
           MuleSoftOAuthCustomAdaptor MuleSoftOAuthCustomAdaptorCls = new MuleSoftOAuthCustomAdaptor();
           MuleSoftOAuthCustomAdaptorCls.redirectUrl = authProviderConfiguration.get('Redirect_Url__c');
           
           Test.setMock(HttpCalloutMock.class, new MuleSoftMockHttpResponseGenerator());

           Map<String,String> queryParams = new Map<String,String>();
           queryParams.put('code','code');
           queryParams.put('state',authProviderConfiguration.get('State_c'));
           queryParams.put('redirect_uri',authProviderConfiguration.get('redirectUrl__c'));
           Auth.AuthProviderCallbackState cbState = new Auth.AuthProviderCallbackState(null,null,queryParams);
           Auth.AuthProviderTokenResponse actualAuthProvResponse = MuleSoftOAuthCustomAdaptorCls.handleCallback(authProviderConfiguration, cbState);
           Auth.AuthProviderTokenResponse expectedAuthProvResponse = new Auth.AuthProviderTokenResponse('MuleSoftOAuthCustomAdaptor', OAUTH_TOKEN, REFRESH_TOKEN, null);
           


           System.assertEquals(expectedAuthProvResponse.provider, actualAuthProvResponse.provider);
           System.assertEquals(expectedAuthProvResponse.state, actualAuthProvResponse.state);
           Test.stopTest();
    }
   
   
    static testMethod void testrefreshToken() {
          /* ADM_Custom_Setting__c admConfig = new ADM_Custom_Setting__c();
           admConfig.Name = 'ADM_MuleSoftClientCertificateName';
           admConfig.Value__c = 'sfdcmulesoftpoc';
           insert admConfig;*/
           
           Test.startTest();
           Map<String,String> authProviderConfiguration = setupAuthProviderConfig();
           MuleSoftOAuthCustomAdaptor MuleSoftOAuthCustomAdaptorCls = new MuleSoftOAuthCustomAdaptor();
                      
           Test.setMock(HttpCalloutMock.class, new MuleSoftMockHttpResponseGenerator());

           Auth.OAuthRefreshResult refreshresult= new Auth.OAuthRefreshResult(OAUTH_TOKEN ,REFRESH_TOKEN);
            Auth.OAuthRefreshResult actualrefreshresult = MuleSoftOAuthCustomAdaptorCls.refresh(authProviderConfiguration, REFRESH_TOKEN) ;
          Test.stopTest();
       
   }
   
    
    
    static testMethod void testGetUserInfo() {
           Map<String,String> authProviderConfiguration = setupAuthProviderConfig();
           MuleSoftOAuthCustomAdaptor MuleSoftOAuthCustomAdaptorCls = new MuleSoftOAuthCustomAdaptor();
                      
           Test.setMock(HttpCalloutMock.class, new MuleSoftMockHttpResponseGenerator());

           Auth.AuthProviderTokenResponse response = new Auth.AuthProviderTokenResponse(PROVIDER, OAUTH_TOKEN ,'sampleOauthSecret', STATE);
           Auth.UserData actualUserData = MuleSoftOAuthCustomAdaptorCls.getUserInfo(authProviderConfiguration, response) ;
           
           Map<String,String> provMap = new Map<String,String>();
           provMap.put('key1', 'value1');
           provMap.put('key2', 'value2');
                     
           Auth.UserData expectedUserData = new Auth.UserData(LOGIN_ID, FIRST_NAME, LAST_NAME, FULL_NAME, EMAIL_ADDRESS,
                          null, LOCALE_NAME, null, PROVIDER, null, provMap);
          
           System.assertNotEquals(expectedUserData,null);
              }
    
    
   // implementing a mock http response generator for Mulesoft 
   public  class MuleSoftMockHttpResponseGenerator implements HttpCalloutMock {
     public HTTPResponse respond(HTTPRequest req) {
       // Create a fake response
      
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-type', 'application/json');
         res.setBody('{"OAUTH_TOKEN":"testToken"}');
         res.setBody('{"key":"Key"}');
        res.setStatusCode(200);

        return res;
    }
   
  }
}