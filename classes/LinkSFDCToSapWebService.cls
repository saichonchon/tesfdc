Global without sharing class LinkSFDCToSapWebService{

/***********************************************************************************************************************
      Name : LinkSFDCToSapWebService
       Org : C2S
 Copyright : © 2015 TE Connectivity
========================================================================================================================
   Summary : This call will make callout to Traffic Cob.Traffica will forward requrest to CI Service. CI Service will 
             Send request to Sap and Sap will send back the response to SFDC as a XML String.             
             This class will process the response XML string and update the case with SAP Document URL.
________________________________________________________________________________________________________________________   
Custom Button on Case utilize this class :   Link to Sap 
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR        DATE       DETAIL                                                      Link SFDC Case with Sap
________________________________________________________________________________________________________________________
    1.0 Subba Reddy   06/19/2015   Initial Development                                                            
***********************************************************************************************************************/
   
   /* ______________________________ D3. PRIMITIVE VARIABLE DECLARATION ____________________________*/           
    static string vLinkSapPushConfigName;
    static string vLinkSapcallResult;
    static string vLinkSapCertificate; 
    static String vResponse;
    static String vSfdcData;
    static String vSapUrl;
    static String vSapMessage;
    
    WebService static String castIronSapWSCallot(String pCaseId){
        if(String.isNotBlank(pCaseId)){
            try{
                 Case vCase = [Select Id,CaseNumber,SAP_Document_Number__c, createdDate,
                              Account.AccountNumber,Account.Sales_Organization_ID__c, Account.Company_Organization_ID__c, Account.Distribution_Channel_Cde__c, Account.Source_System__c
                              from Case 
                              Where Id =: pCaseId];                  
                  string accountNumber = vCase.Account.AccountNumber.substringAfter(':');
                  string companyOrgId  = vCase.Account.AccountNumber.substringBefore(':');                                             
                  vSfdcData = '<?xml version="1.0" encoding="UTF-8"?> '+
                             '<LINKS_IN>' +
                                 '<LINK>' +
                                     '<ACCOUNT_NUM>' + accountNumber  + '</ACCOUNT_NUM>' +
                                     '<ORG_ID>' + companyOrgId + '</ORG_ID>' +
                                     '<SALES_ORG>' + vCase.Account.Sales_Organization_ID__c + '</SALES_ORG>' +
                                     '<DIST_CHANNEL>' + vCase.Account.Distribution_Channel_Cde__c + '</DIST_CHANNEL>' +
                                     '<DOC_ITEM>' + vCase.SAP_Document_Number__c + '</DOC_ITEM>' +
                                     '<CASE_NUM>' + vCase.CaseNumber + '</CASE_NUM>' +
                                     '<CASE_ID>' + vCase.Id+ '</CASE_ID>' +
                                     '<DATE_TIME>' + vCase.createdDate+ '</DATE_TIME>' +
                                 '</LINK>'+
                             '</LINKS_IN>'; 
                  system.debug('********** vSfdcdata'+vSfdcData);                
                // get config name here and pass to real_time_class
                 for(realtime_Callout_Settings__c rcs : realtime_Callout_Settings__c.getAll().values()) {
                    if(rcs.Active__c == true ) {
                        if(rcs.Name == 'Prod Link Sap' || rcs.Name == 'QA Link Sap'){
                            vLinkSapPushConfigName= rcs.Name;
                            vLinkSapCertificate= rcs.Certificate_name__c;  
                        }
                    }       
                 }
                
                vResponse = real_time_call.callWSRealTime('LINKSAP', vSfdcData , vLinkSapPushConfigName);
                system.debug('*********** vResponse'+ vResponse);
           
                String vParsedText = parseXMLString(vResponse);
                system.debug('****** vParsedText '+vParsedText);
                
                if(vSapUrl != ''){
                    vCase.SAP_Document_URL__c = vSapUrl;                    
                    update vCase;
                }
                
                return 'OKK '+vSapMessage ;
            }catch(QueryException e){ return String.valueOf('ERROR :' + e.getMessage()) ;} catch(CalloutException e){return String.valueOf('ERROR :' + e.getMessage()) ;}catch(DmlException e){return String.valueOf('ERROR :' + e.getMessage()) ;} catch(Exception e){return String.valueOf('ERROR :' + e.getMessage()) ;}  }else { return 'ERROR: '+vSapMessage; }
    }
    
    
    // Just checking that it's actually XML
    private static String parseXMLString(String toParse) {
      DOM.Document doc = new DOM.Document();
      
      try {
        doc.load(toParse);    
        system.debug('******** doc '+doc);
        DOM.XMLNode root = doc.getRootElement();
        
        system.debug('******** root '+root);
        return walkThrough(root);
        
      } catch (System.XMLException e) { return e.getMessage(); }
    }

    // Recursively walk through the XML
    private static String walkThrough(DOM.XMLNode node) {
      Boolean isElementUrl;
      String result = '\n';
      system.debug('*********** node.getNodeType() '+node.getNodeType());
      system.debug('************  DOM.XMLNodeType.COMMENT '+ DOM.XMLNodeType.COMMENT);
      system.debug('************* DOM.XMLNodeType.TEXT '+DOM.XMLNodeType.TEXT);
      system.debug('************* DOM.XMLNodeType.ELEMENT '+DOM.XMLNodeType.ELEMENT);
      if (node.getNodeType() == DOM.XMLNodeType.COMMENT) {
        return 'Comment (' +  node.getText() + ')';
      }
      if (node.getNodeType() == DOM.XMLNodeType.TEXT) {
        return 'Text (' + node.getText() + ')';
      }
      if (node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
        result += 'Element: ' + node.getName();
        
        if (node.getText().trim() != '') {
            if(node.getName() == 'URL'){
                vSapUrl = node.getText().trim();
            }
            if(node.getName() == 'RETURN_MESSAGE'){
                vSapMessage = node.getText().trim();
            }
            system.debug('**********  trim');
          result += ', text=' + node.getText().trim();
          system.debug('************* Result '+result);
        }
        if (node.getAttributeCount() > 0) { 
                        system.debug('********* getAttributeCount');
          for (Integer i = 0; i< node.getAttributeCount(); i++ ) {
            result += ', attribute #' + i + ':' + node.getAttributeKeyAt(i) + '=' + node.getAttributeValue(node.getAttributeKeyAt(i), node.getAttributeKeyNsAt(i));
          }  
        }
        for (Dom.XMLNode child: node.getChildElements()) {
            system.debug('********* child ');
          result += walkThrough(child);
        }
        return result;
      }
      return '';  //should never reach here
      
    }
}