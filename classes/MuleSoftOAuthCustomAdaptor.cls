/**********************************************************************
Name:  MuleSoftOAuthCustomAdaptor
Copyright © 2017
======================================================
======================================================

Purpose:  This Class is used for Custom Adopter for OData Authentication.
======================================================
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR                DATE             DETAIL Description
0.1          Supriya A           10/10/2017         INITIAL DEVELOPMENT

***********************************************************************/

global class MuleSoftOAuthCustomAdaptor extends Auth.AuthProviderPluginClass {
    
    
    public String  redirectUrl; // use this URL for the endpoint that the authentication provider calls back to for configuration
    private String key;
    private String secret;
    private String authUrl;    // auth URL for authentication and authorization of MuleSoft
    private String accessTokenUrl; // uri to get the new access token
    private String customMetadataTypeApiName ;// api name for the custom metadata type created for this auth provider
  
    
    global String getCustomMetadataType() {
        return 'MuleSoftOauth__mdt';  // get the metadata
    }
    
    global PageReference initiate(Map<string,string> authProviderConfiguration, String stateToPropagate) {
        
        String url;
        try
        {
            authUrl   = authProviderConfiguration.get('Auth_Url__c');
            key       = authProviderConfiguration.get('Key__c');
            redirectUrl = authProviderConfiguration.get('redirectUrl__c');
            secret     = authProviderConfiguration.get('Secret__c');
            url   = authUrl + '?client_id='+ key +'&client_secret='+ secret +'&scope=READ WRITE&response_type=code&grant_type=authorization_code&redirect_uri='+ redirectUrl + '&state=' + stateToPropagate;
            //system.debug('>>>>'+url);
        }
        catch(Exception e){
                System.debug('errMessage' + ': ' + e.getMessage());
                ErrorLogging.Log(e, 'MuleSoftOAuthCustomAdaptor', 'initiate','');        
        }
        
        return new PageReference(url);
    
    
}    
    
    global Auth.AuthProviderTokenResponse handleCallback(Map<string,string> authProviderConfiguration, Auth.AuthProviderCallbackState state ) {
         
      String code;
      String sfdcState;
      String token;
      String refresh_token;
      String muleSoftClientCertificateName;
      
      try{
        key              = authProviderConfiguration.get('Key__c');
        secret           = authProviderConfiguration.get('Secret__c');
        accessTokenUrl   = authProviderConfiguration.get('Access_Token_Url__c');
        redirectUrl      = authProviderConfiguration.get('redirectUrl__c');        
                       
        ADM_Custom_Setting__c muleSoftSetting = ADM_Custom_Setting__c.getValues('ADM_MuleSoftClientCertificateName');
        if(muleSoftSetting != null){
            muleSoftClientCertificateName = muleSoftSetting.Value__c;
        }
        
        Map<String,String> queryParams = state.queryParameters;
        code = queryParams.get('code');
        sfdcState = queryParams.get('state');
        
        System.debug('>>>'+code+ '>>>'+sfdcState+ '>>>' +accessTokenUrl);
     
        HttpRequest req = new HttpRequest();
  
        String url = accessTokenUrl;
        req.setEndpoint(url);
        req.setMethod('GET');
        req.setHeader('grant_type','authorization_code');
        req.setHeader('client_id',key);
        req.setHeader('client_secret',secret);
        req.setHeader('redirect_uri',redirectUrl);
        req.setHeader('scope','READ WRITE');  
        req.setHeader('code',code);  
       // req.setClientCertificateName('sfdcmulesoftpoc');
        req.setClientCertificateName(muleSoftClientCertificateName);
       
        req.setHeader('Content-Type','application/json');
        req.setTimeout(120000);
        Http http = new Http();
        System.debug('>>>>'+req);
        HTTPResponse res = http.send(req);
        String responseBody = res.getBody();
        System.debug('>>>>'+responseBody);
        token = getTokenValueFromResponse(responseBody, 'access_token', null);
        refresh_token = getTokenValueFromResponse(responseBody, 'refresh_token', null);
      //return new Auth.AuthProviderTokenResponse('MuleSoftOAuthCustomAdaptor', token, refresh_token , sfdcState);
        }
        
        catch(Exception e){
            System.debug('errMessage' + ': ' + e.getMessage());
             ErrorLogging.Log(e, 'MuleSoftOAuthCustomAdaptor', 'handleCallback','');        
                   
    }
    
        return new Auth.AuthProviderTokenResponse('MuleSoftOAuthCustomAdaptor', token, refresh_token , sfdcState);
    }
    
    global override Auth.OAuthRefreshResult refresh(Map<string,string> authProviderConfiguration,String refreshToken){
        HttpRequest req = new HttpRequest();
        String accessToken = null;
        String refresh_token = null;
        String error  = null;
        String muleSoftClientCertificateName;
        
        try {
            
            key       = authProviderConfiguration.get('Key__c');
            secret       = authProviderConfiguration.get('Secret__c');
            accessTokenUrl   = authProviderConfiguration.get('Access_Token_Url__c');
                            
            ADM_Custom_Setting__c muleSoftSetting = ADM_Custom_Setting__c.getValues('ADM_MuleSoftClientCertificateName');
            if(muleSoftSetting != null){
                muleSoftClientCertificateName = muleSoftSetting.Value__c;
            }
            
            String url = accessTokenUrl + '?refresh_token=' + refreshToken + '&client_id=' + key +'&grant_type=refresh_token&client_secret=' + secret;    

            
            req.setEndpoint(url);
            req.setHeader('Content-Type','application/xml');
            req.setMethod('GET');
            req.setHeader('scope','READ WRITE');  
                   
           // req.setClientCertificateName('sfdcmulesoftpoc');
           req.setClientCertificateName(muleSoftClientCertificateName);
            
            Http http = new Http();
            
            HTTPResponse res = http.send(req);
            String responseBody = res.getBody();
            system.debug('responseBody --'+responseBody);
            accessToken = getTokenValueFromResponse(responseBody, 'access_token', null);
            refresh_token = getTokenValueFromResponse(responseBody, 'refresh_token', null);
            
        } catch (System.CalloutException e) {
            error = e.getMessage();
        }
        catch(Exception e) {
            error = e.getMessage();
            //throw new Auth.AuthProviderPluginException('My custom error');
            System.debug('errMessage' + ': ' +error );
            ErrorLogging.Log(e, 'MuleSoftOAuthCustomAdaptor', 'refresh','');        
      
        }
        
        return new Auth.OAuthRefreshResult(accessToken,refresh_token, error);                
    }
    
  global Auth.UserData  getUserInfo(Map<string,string> authProviderConfiguration, Auth.AuthProviderTokenResponse response) { 
       
       //Here the developer is responsible for constructing an Auth.UserData objec
       /*   String token = response.oauthToken;
        HttpRequest req = new HttpRequest();
        userAPIUrl = authProviderConfiguration.get('API_User_Url__c');
        userAPIVersionUrl = authProviderConfiguration.get('API_User_Version_Url__c');
        req.setHeader('Authorization', 'OAuth ' + token);
        req.setEndpoint(userAPIUrl);
        req.setHeader('Content-Type','application/xml');
        req.setMethod('GET');
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        String responseBody = res.getBody();
        String id = getTokenValueFromResponse(responseBody, 'LoginId',userAPIVersionUrl);
        String fname = getTokenValueFromResponse(responseBody, 'FirstName', userAPIVersionUrl);
        String lname = getTokenValueFromResponse(responseBody, 'LastName', userAPIVersionUrl);
        String flname = fname + ' ' + lname;
        String uname = getTokenValueFromResponse(responseBody, 'EmailAddress', userAPIVersionUrl);
        String locale = getTokenValueFromResponse(responseBody, 'LocaleName', userAPIVersionUrl);
        Map<String,String> provMap = new Map<String,String>();
        provMap.put('what1', 'noidea1');
        provMap.put('what2', 'noidea2');*/
        //return new Auth.UserData(id, fname, lname, flname, uname,'what', locale, null, 'Concur', null, provMap);
        return new Auth.UserData(null, 'fname', 'lname', 'flname', 'uname','what', 'locale', null, 'Concur', null, null);
    }
       
    

    private String getTokenValueFromResponse(String response,String token, String ns) 
    { 
      System.debug('**************' +response);
       try
       {
        
       JSONParser parser = JSON.createParser(response);
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == token)){
                parser.nextToken();    
                return    parser.getText();
            }
        }
       }
        catch(Exception e) {
          system.debug('errMessage' + ': ' +e.getMessage());
          ErrorLogging.Log(e, 'MuleSoftOAuthCustomAdaptor', 'refresh','');        
      
        }
        return null;
    }
}