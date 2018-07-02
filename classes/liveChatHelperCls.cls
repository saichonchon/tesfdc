/*
Copyright © 2016 TE Connectivity | Salesforce Instance : C2S Org

Name                : liveChatHealperCls
Related Test Class  :
Created Date        : 14 Oct 2017
Created by          : Onkar Kumar (TEIS)
Description         : This is used for as helper for LiveAgent implementaion for EPD call for TE.com Cookies information.

***********************************************************************************************************
Audit               
***********************************************************************************************************
Last Modified by    :
Last Modified Date  :
TeampUpCase$        :
JiraCase#           :
***********************************************************************************************************
*/

public class liveChatHelperCls {
    
    private string TECewt7;
    private boolean  isError404 = false;
    public Map<String,String> fieldMap = new Map<String,string>();
    
    // STRAT Constructor 
    public  liveChatHelperCls(string TECewt7){ 
        
       // string url = 'https://www-qa.te.com/commerce/epd/service/marketingprofile/'+TECewt7;
       string url =  Live_Agent_Org_Settings__c.getInstance().epdURl__c+TECewt7;
       System.debug('>>URL'+url);
       // 
        Set<String> fields = new Set<String>();
        
        for(Live_Agent_EPD_Fields__c fldObjet : Live_Agent_EPD_Fields__c.getall().values()){
            fields.add(fldObjet.name);
        }
        
        try{ // Try Block START
            
            
            JSONParser parser = JSON.createParser(httpCallout(url,TECewt7));
            Double grandTotal = 0.0;
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'error')) {
                    while (parser.nextToken() != null) {
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'errorCode')) {
                            parser.nextToken();
                            If(parser.getText() == '404'){
                                isError404 = true;
                                break;
                            }
                        }
                    }
                }
                for(string strName : fields){
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == strName)) {
                        parser.nextToken();
                        system.debug('>>>>'+parser.getText());
                        fieldMap.put(strName, parser.getText());
                    }  
                }
            }            
        }// Try block END
        catch(exception e){ // CATCH block START
             String vStrError         = '';
             vStrError += 'Error Type = ' + e.getTypeName() + 
                ' Error Line = ' + e.getLineNumber() + '' + 
                ' Error Stack = ' + e.getStackTraceString() + 
                ' Error Message = ' + e.getMessage();
            
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,                   
                                         SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '',e.getStackTraceString()); 
        } // CATCH BLOCK END
    } // END Constructor
    
    public boolean getis404Error(){
        return  this.isError404;
    }  
    
    public string httpCallout(string url,string TECewt7){
          Http h = new Http();
            // Instantiate a new HTTP  request, specify the method (GET) as well as the endpoint
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod('GET');
            System.debug('>>>'+TECewt7);
            req.setHeader('Cookie','TECewt7='+TECewt7); 
            // Send the request, and return a response
            HttpResponse res = h.send(req);
            System.debug('>>>>>'+res.getBody());
          return res.getBody();
    }
}