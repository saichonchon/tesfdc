/*------------------------------------------------------------
Author:        Buwen Guo <buwen.guo@capgemini.com>
Description:   Util class for getting opportunity part's price info. 
Inputs:        
Test Class:    InventoryAndPricingTest
History
2017-09-23     Buwen Guo <buwen.guo@capgemini.com> Created
------------------------------------------------------------*/
public with sharing class InventoryAndPricing {
    public static BestPriceWebspeed__c bestPriceMfg = new BestPriceWebspeed__c();
    public static SAP_Instance__c SAPInstanceVal = new SAP_Instance__c();
    public static Energy_Control__c isNotAllowRestCallout = null;
    public static Energy_Control__c isNotAllowCalloutUser = null;
    //public static User currUser = null;
    
    
    /*------------------------------------------------------------
    Author:        Buwen Guo <buwen.guo@capgemini.com>
    Description:   Function to call webservice for oppy part.
    Inputs:        
    Returns:       
    History
    2017-09-23     Buwen Guo <buwen.guo@capgemini.com> created
    ------------------------------------------------------------*/
    public static void getPrice(String str_oppy,String str_listoppyparts){
        //if(EnergyQuoteTrgHandler.isFromQuoteRecreateParts){
        if(EnergyQuoteTrgHandler.isFromQuoteRecreateParts){ //modified by Tangyong li 2017-11-06
            return ;
        }
        opportunity oppy = (opportunity) SYSTEM.JSON.deserialize(str_oppy, opportunity.class);  
        List<Opportunity_Part__c> list_oppyParts  = (List<Opportunity_Part__c>) SYSTEM.JSON.deserialize(str_listoppyparts, List<Opportunity_Part__c> .class);   
        system.debug('getPrice::oppy::'+oppy);
        system.debug('getPrice::list_oppyParts::'+list_oppyParts);
        system.debug('getPrice::list_oppyParts::SIZE::'+list_oppyParts.size());

        //if(currUser == null){
        //    currUser = [select id,MED_Region__c from user where id=:UserInfo.getUserId()];
        //}
        
        //Added by Buwen Guo 2017-12-14 from email:12/13 Issues point 1
        if(isNotAllowRestCallout == null){
            /*for(Energy_Control__c eq :[select id,Disable_Integrations__c from Energy_Control__c where name = 'Energy Control' limit 1]){
                isNotAllowRestCallout = eq;
            }*/
            if(Energy_Control__c.getInstance('Energy Control') != null){
                isNotAllowRestCallout = Energy_Control__c.getInstance('Energy Control');
            }
            system.debug('isNotAllowRestCallout::'+isNotAllowRestCallout);
            if(isNotAllowRestCallout == null){
                return;
            }
        }
        if(isNotAllowRestCallout.Disable_Integrations__c == true || (oppy.createdDate < isNotAllowRestCallout.Callout_Start_Date__c)){
        	system.debug('isNotAllowRestCallout::ORG disable callout.');
            return;
        }
        
        if(isNotAllowCalloutUser == null){
            if(Energy_Control__c.getInstance('Limit User') != null){
                isNotAllowCalloutUser = Energy_Control__c.getInstance('Limit User');
            }
            system.debug('isNotAllowCalloutUser::'+isNotAllowCalloutUser);
        }
        
        system.debug('CurrentUserName::'+UserInfo.getName());
        if(isNotAllowCalloutUser != null && isNotAllowCalloutUser.Limit_User__c != null && isNotAllowCalloutUser.Limit_User__c != '' && isNotAllowCalloutUser.Disable_Integrations__c == true){
        	List<String> list_userNames = isNotAllowCalloutUser.Limit_User__c.split(';');
        	if(list_userNames.contains(UserInfo.getName())){
	            system.debug('UserDisableCall::'+UserInfo.getName());
	            return ;
        	}
        }
        

        System.debug('***ERP for pricing is ' + oppy.ERP_For_Pricing__c);
        if (oppy.ERP_For_Pricing__c == 'SAP (except ANZPAC)' || oppy.ERP_for_Pricing__c == 'ANZPAC'){
            //SAP
            getInventoryAndPriceSAP(str_oppy,str_listoppyparts);
        }else if (oppy.ERP_for_Pricing__c == 'MFGPRO'){
            //MFGPRO
            getInventoryAndPriceMFGPRO(str_oppy,str_listoppyparts);
        }
        /*else if (oppy.ERP_for_Pricing__c == 'Ampics'){
            //AMPICS
            //getInventoryAndPriceAMPICS(str_oppy,str_listoppyparts);
        }else if(oppy.Account.recordtype.name == 'Prospect' && currUser.MED_Region__c == 'Aus / New Zlnd') {
            //AMPICS
            //getInventoryAndPriceAMPICS(str_oppy,str_listoppyparts);
        }*/
        else{
            return ;
        }

        //Level 1 judgement:
        //SAP: 1
        //MFGPRO: 51
        //AMPICS: 36,43,110,34,187,42,269,272
        
        //Level 2 judgement:
        
        //Level 3 judgement:
        //when previous two level condition can not be judged
        //AMPICS : oppy.Account.recordtype.name == 'Prospect' && currUser.MED_Region__c == 'Aus / New Zlnd'

    }
    
    
    /*------------------------------------------------------------
    Author:        Buwen Guo <buwen.guo@capgemini.com>
    Description:   Function to call webservice for SAP oppy part.
    Inputs:        
    Returns:       
    History
    2017-09-23     Buwen Guo <buwen.guo@capgemini.com> created
    ------------------------------------------------------------*/
    @future(callout = true)
    public static void getInventoryAndPriceSAP(String str_oppy,String str_listoppyparts) {
        opportunity oppy = (opportunity) SYSTEM.JSON.deserialize(str_oppy, opportunity.class);  
        List<Opportunity_Part__c> list_oppyParts  = (List<Opportunity_Part__c>) SYSTEM.JSON.deserialize(str_listoppyparts, List<Opportunity_Part__c> .class);   
        system.debug('getPrice:::SAP::oppy::'+oppy);
        system.debug('getPrice:::SAP::list_oppyParts::'+list_oppyParts);
        system.debug('getPrice:::SAP::list_oppyParts::SIZE::'+list_oppyParts.size());
        
        if(oppy.Account != null){
            InventoryAndPricing.getPricingSAP(oppy,list_oppyParts);
        }
    }
    
    
    
    /*------------------------------------------------------------
    Author:        Buwen Guo <buwen.guo@capgemini.com>
    Description:   Function to call webservice for MFGPRO oppy part.
    Inputs:        
    Returns:       
    History
    2017-09-23     Buwen Guo <buwen.guo@capgemini.com> created
    ------------------------------------------------------------*/
    @future(callout = true)
    public static void getInventoryAndPriceMFGPRO(String str_oppy,String str_listoppyparts) {
        opportunity oppy = (opportunity) SYSTEM.JSON.deserialize(str_oppy, opportunity.class);  
        List<Opportunity_Part__c> list_oppyParts  = (List<Opportunity_Part__c>) SYSTEM.JSON.deserialize(str_listoppyparts, List<Opportunity_Part__c> .class);   
        system.debug('getPrice:::MFGPRO::oppy::'+oppy);
        system.debug('getPrice:::MFGPRO::list_oppyParts::'+list_oppyParts);
        system.debug('getPrice:::MFGPRO::list_oppyParts::SIZE::'+list_oppyParts.size());
        
        
        if(oppy != null && list_oppyParts != null){
            //Added by Buwen Guo 2017-11-29 from email: Issues 11/28 point 1
            String str_last6digitAcctNumber = '';
            str_last6digitAcctNumber = oppy.Account_Number__c;
            if(oppy.Account_Number__c != null && oppy.Account_Number__c.length() > 5){
                str_last6digitAcctNumber = oppy.Account_Number__c.right(6);
            }
            Date d1 = oppy.createdDate == null ? null : oppy.createdDate.date();
            decimal dec = InventoryAndPricing.getMFGProPriceForList(UserInfo.getSessionId(),oppy.id,d1,str_last6digitAcctNumber,list_oppyParts);
        }
    }
    
    
    /*------------------------------------------------------------
    Author:        Buwen Guo <buwen.guo@capgemini.com>
    Description:   Function to call webservice for AMPICS oppy part.
    Inputs:        
    Returns:       
    History
    2017-09-23     Buwen Guo <buwen.guo@capgemini.com> created
    ------------------------------------------------------------*/
    public static void getInventoryAndPriceAMPICS(String str_jsonOppyParts) {
        list<opportunity_part__c> list_oppyparts = (list<opportunity_part__c>) SYSTEM.JSON.deserialize(str_jsonOppyParts, list<opportunity_part__c>.class);  
        
        list<opportunity_part__c> list_opp2Update = new list<opportunity_part__c>();
        for(opportunity_part__c opp : list_oppyparts){
            if(opp.part__r.Curr_CS_75__c != null){
                opp.Standard_Cost__c = ClsAPLForecastUtil.transformIsoCode(opp.part__r.Curr_CS_75__c,opp.part__r.CurrencyIsoCode,opp.CurrencyIsoCode);
                list_opp2Update.add(opp);
            }
        }
        
        if(list_opp2Update.size() > 0){
            update list_opp2Update;
        }
        
        /*set<String> set_partId = new set<String>();
        for(opportunity_part__c op : list_oppyparts){
            set_partId.add(op.part__c); 
        }
        
        map<String,decimal> map_partId_pricebookCosts = new map<String,decimal>();
        for(Energy_Price_Book_Entry__c qli : [select id,UnitPrice__c,Part__c,StandardPrice__c
                                        from Energy_Price_Book_Entry__c 
                                        where Part__c IN :set_partId ]){
            
            if(!map_partId_pricebookCosts.containsKey(qli.Part__c)){
                map_partId_pricebookCosts.put(qli.Part__c,qli.StandardPrice__c);
            }
        }
        
        list<opportunity_part__c> list_opp2Update = new list<opportunity_part__c>();
        for(opportunity_part__c opp : list_oppyparts){
            if(map_partId_pricebookCosts.containsKey(opp.Part__c)){
                opp.Standard_Cost__c = map_partId_pricebookCosts.get(opp.Part__c);
                list_opp2Update.add(opp);
            }
        }
        
        if(list_opp2Update.size() > 0){
            update list_opp2Update;
        }
        */
    }


    
    /*------------------------------------------------------------
    Author:        Buwen Guo <buwen.guo@capgemini.com>
    Description:   Util method to build the message body info.
    Inputs:        
    Returns:       
    History
    2017-09-23     Buwen Guo <buwen.guo@capgemini.com> created
    ------------------------------------------------------------*/       
    private static String getMessageBody(String sessionId,
                                  id opportunityId,
                                  String customerNumber,
                                  List<Opportunity_Part__c> lineItems) {
        String result = '<?xml version="1.0"?><pricingRequest><sessionId>';
        result += sessionId;
        result += '</sessionId><oppId>';
        result += opportunityId;
        result += '</oppId><custNumber>';
        result += customerNumber;
        result += '</custNumber><oppLineItems>';
        for (Opportunity_Part__c oppPart : lineItems) {
            result += '<oppLineItem><oppLineItemID>';
            result += oppPart.id;
            result += '</oppLineItemID><partNumber>';
            //result += oppPart.Part__r.name;
            result += oppPart.Part_Number_txt__c;
            result += '</partNumber><qty>';
            result += oppPart.Quantity__c;
            result += '</qty></oppLineItem>';
        }
        result += '</oppLineItems></pricingRequest>';
        return result;
    }
    
    
    
    
    /*------------------------------------------------------------
    Author:        Buwen Guo <buwen.guo@capgemini.com>
    Description:   Function to call webservice for MFGPro oppy part.
    Inputs:        
    Returns:       
    History
    2017-09-23     Buwen Guo <buwen.guo@capgemini.com> created
    ------------------------------------------------------------*/
    public static decimal getMFGProPrice(String str_sessionId, String str_partNumber, Decimal quantity,String cNumber) {
        try{            
            decimal bestPrice;
            DateTime firstTime = System.now();
            system.debug('**** HI');
    
            if(bestPriceMfg == null || bestPriceMfg.Name == null){
                bestPriceMfg = [select Name,URL__c from BestPriceWebspeed__c where name='QAD-MFGProUrl' LIMIT 1];
            }
            system.debug('URL::'+bestPriceMfg.URL__c);
    
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint(bestPriceMfg.URL__c);
            req.setHeader('content-type', 'application/xml');
            System.debug('content-type is set correctly');
            System.debug('***url is ' + bestPriceMfg.URL__c);
            String messageBody = 'sessionid='+str_sessionId+'&part='+str_partNumber+'&qty='+quantity+'&customer='+cNumber;
            //String messageBody = 'sessionid='+str_sessionId+'&part=016640-000&qty=1&customer=208740';
            req.setHeader('Content-length', String.valueOf(messageBody.length()));
            req.setBody(messageBody);
            req.setTimeout(60*1000);
    
            Http h = new Http();
            String resp;
            HttpResponse res = h.send(req);
            resp = res.getBody();
            System.debug('MessageBody::'+messageBody);
            
            System.debug('Response::'+resp);
              
            Dom.Document xmlDOC = new Dom.Document();
            xmlDOC.load(resp);
            
            DOM.XMLNode rootElement = xmlDOC.getRootElement();
            String outxmlstring=String.valueof(xmlDOC.getRootElement().getName());
            System.debug('RootElement::'+outxmlstring);
            for(DOM.XMLNode child:xmlDOC.getRootElement().getChildElements()){   
                system.debug('child::'+child);
               
                if(child.getName() == 'bestlistprice'){
                    
                    System.debug('BEST PRICE::' + child.getText().trim());
                    String str_bestPrice = child.getText().trim();
                    if(str_bestPrice == null || str_bestPrice == ''){
                        return null;
                    }
                    bestPrice = Decimal.valueOf(str_bestPrice);
                    
                    Decimal timeDiff = System.now().getTime() - firstTime.getTime();
                    system.debug('Deffrence Time Taken::'+timeDiff);
                    
                }else if(child.getName() == 'error'){
                    System.debug('ERROR::' + child.getText().trim()); 
                    return null;
                }
            }
            return bestPrice;
        } catch(Exception ex) {
            System.debug('MFGPRO Callout error: '+ ex);
            //ErrorLogging.Log(ex);
            String vStrError = '';
            vStrError += 'Error Type = ' + ex.getTypeName() + 
                ' Error Line = ' + ex.getLineNumber() + '' + 
                ' Error Stack = ' + ex.getStackTraceString() + 
                ' Error Message = ' + ex.getMessage();
            
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,                   
                                         SalesforceConstant.strError, '', '', '', '5','','','Exception', ex.getLineNumber() + '',ex.getStackTraceString());
            return null;
        }
    }
    
    
    
    
    
    /*------------------------------------------------------------
    Author:        Buwen Guo <buwen.guo@capgemini.com>
    Description:   Function to call webservice for MFGPro oppy part list.
    Inputs:        
    Returns:       
    History
    2017-09-23     Buwen Guo <buwen.guo@capgemini.com> created
    ------------------------------------------------------------*/
    public static decimal getMFGProPriceForList(String sessionId,
                                  id opportunityId,
                                  Date oppycreatedDate,
                                  String customerNumber,
                                  List<Opportunity_Part__c> lineItems) {
        try{
            decimal bestPrice;
            DateTime firstTime = System.now(); 
            system.debug('**** HI');
            
            //Added by Buwen Guo 2017-12-14 from email:12/13 Issues point 1
            if(isNotAllowRestCallout == null){
                /*for(Energy_Control__c eq :[select id,Disable_Integrations__c from Energy_Control__c where name = 'Energy Control' limit 1]){
                    isNotAllowRestCallout = eq;
                }*/
                if(Energy_Control__c.getInstance('Energy Control') != null){
                    isNotAllowRestCallout = Energy_Control__c.getInstance('Energy Control');
                }
                system.debug('isNotAllowRestCallout::'+isNotAllowRestCallout);
                if(isNotAllowRestCallout == null){
                    return null;
                }
            }
            if(isNotAllowRestCallout.Disable_Integrations__c == true || oppycreatedDate == null || oppycreatedDate < isNotAllowRestCallout.Callout_Start_Date__c){
                return null;
            }
            
            if(isNotAllowCalloutUser == null){
                if(Energy_Control__c.getInstance('Limit User') != null){
                    isNotAllowCalloutUser = Energy_Control__c.getInstance('Limit User');
                }
                system.debug('isNotAllowCalloutUser::'+isNotAllowCalloutUser);
            }
            
            system.debug('CurrentUserName::'+UserInfo.getName());
            /*Added by Buwen Guo 2018-03-15 to enable multiple user disable callout.
            if(isNotAllowCalloutUser != null && isNotAllowCalloutUser.Limit_User__c == UserInfo.getName() && isNotAllowCalloutUser.Disable_Integrations__c == true){
                system.debug('UserDisableCall::'+UserInfo.getName());
                return null;
            }*/
            
            if(isNotAllowCalloutUser != null && isNotAllowCalloutUser.Limit_User__c != null && isNotAllowCalloutUser.Limit_User__c != '' && isNotAllowCalloutUser.Disable_Integrations__c == true){
	        	List<String> list_userNames = isNotAllowCalloutUser.Limit_User__c.split(';');
	        	if(list_userNames.contains(UserInfo.getName())){
		            system.debug('UserDisableCall::'+UserInfo.getName());
		            return null;
	        	}
	        }
    
            if(bestPriceMfg == null || bestPriceMfg.Name == null){
                bestPriceMfg = [select Name,URL__c from BestPriceWebspeed__c where name='QAD-MFGProUrl' LIMIT 1];
            }
            system.debug('URL::'+bestPriceMfg.URL__c);
    
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint(bestPriceMfg.URL__c);
            System.debug('***URL ' + bestPriceMfg.URL__c);
            req.setHeader('content-type', 'application/xml');
            System.debug('Content type is set here too!');
            String messageBody = getMessageBody(sessionId,opportunityId,customerNumber,lineItems);
            //String messageBody = 'sessionid='+str_sessionId+'&part=016640-000&qty=1&customer=208740';
            req.setHeader('Content-length', String.valueOf(messageBody.length()));
            req.setBody(messageBody);
            req.setTimeout(60*1000);
    
            Http h = new Http();
            String resp;
            HttpResponse res = h.send(req);
            resp = res.getBody();
            System.debug('MessageBody::'+messageBody);
            
            System.debug('Response::'+resp);
              
            Dom.Document xmlDOC = new Dom.Document();
            xmlDOC.load(resp);
            
            DOM.XMLNode rootElement = xmlDOC.getRootElement();
            String outxmlstring=String.valueof(xmlDOC.getRootElement().getName());
            System.debug('RootElement::'+outxmlstring);
            for(DOM.XMLNode child:xmlDOC.getRootElement().getChildElements()){   
                system.debug('child::'+child);
               
                if(child.getName() == 'bestlistprice'){
                    
                    System.debug('BEST PRICE::' + child.getText().trim());
                    String str_bestPrice = child.getText().trim();
                    if(str_bestPrice == null || str_bestPrice == ''){
                        return null;
                    }
                    bestPrice = Decimal.valueOf(str_bestPrice);
                    
                    Decimal timeDiff = System.now().getTime() - firstTime.getTime();
                    system.debug('Deffrence Time Taken::'+timeDiff);
                    
                }else if(child.getName() == 'error'){
                    System.debug('ERROR::' + child.getText().trim()); 
                    return null;
                }
            }
            return bestPrice;
        } catch(Exception ex) {
            System.debug('MFGPRO Callout error: '+ ex);
            //ErrorLogging.Log(ex);
            String vStrError = '';
            vStrError += 'Error Type = ' + ex.getTypeName() + 
                ' Error Line = ' + ex.getLineNumber() + '' + 
                ' Error Stack = ' + ex.getStackTraceString() + 
                ' Error Message = ' + ex.getMessage();
            
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,                   
                                         SalesforceConstant.strError, '', '', '', '5','','','Exception', ex.getLineNumber() + '',ex.getStackTraceString());
            return null;
        }
    }
    
    private static String nvl(String input) {
        if (input == null)
            return '';
        return input;
    }
    
    
    /*------------------------------------------------------------
    Author:        Yuan Yao <yuan.yao@capgemini.com>
    Description:   Function to call webservice for SAP oppy part.
    Inputs:        
    Returns:       
    History
    2017-10-10     Yuan Yao <yuan.yao@capgemini.com> created
    ------------------------------------------------------------*/
    public static void getPricingSAP(Opportunity oppy, List<Opportunity_Part__c> list_oppyParts){
        try {
        	//Modified by Buwen Guo 2018-03-15 to enable multiple user disable callout.
        	//Added by Buwen Guo 2017-12-14 from email:12/13 Issues point 1
            if(isNotAllowRestCallout == null){
                if(Energy_Control__c.getInstance('Energy Control') != null){
                    isNotAllowRestCallout = Energy_Control__c.getInstance('Energy Control');
                }
                system.debug('isNotAllowRestCallout::'+isNotAllowRestCallout);
                if(isNotAllowRestCallout == null){return ;}
            }
            
            if(isNotAllowRestCallout.Disable_Integrations__c == true || oppy.createdDate < isNotAllowRestCallout.Callout_Start_Date__c){return ;}
            
            if(isNotAllowCalloutUser == null){
                if(Energy_Control__c.getInstance('Limit User') != null){
                    isNotAllowCalloutUser = Energy_Control__c.getInstance('Limit User');
                }
                system.debug('isNotAllowCalloutUser::'+isNotAllowCalloutUser);
            }
            
            if(isNotAllowCalloutUser != null && isNotAllowCalloutUser.Limit_User__c != null && isNotAllowCalloutUser.Limit_User__c != '' && isNotAllowCalloutUser.Disable_Integrations__c == true){
	        	List<String> list_userNames = isNotAllowCalloutUser.Limit_User__c.split(';');
	        	if(list_userNames.contains(UserInfo.getName())){
		            system.debug('UserDisableCall::'+UserInfo.getName());
		            return ;
	        	}
	        }
	        
            WrapperHeader pricingRequest = new WrapperHeader();
            List<WrapperOppyParts> list_wrapOppyParts = new List<WrapperOppyParts>();
            //Modified by Buwen Guo 2017-11-29 from email:Issues 11/28 point 1
            //pricingRequest.accountNumber = oppy.Account.AccountNumber;
            pricingRequest.accountNumber =  nvl(oppy.Account.AccountNumber);
            if(oppy.Account.AccountNumber != null && oppy.Account.AccountNumber.length() > 9){
                pricingRequest.accountNumber = oppy.Account.AccountNumber.right(10);
                if (pricingRequest.accountNumber.contains(':') && pricingRequest.accountNumber.indexOf(':') < pricingRequest.accountNumber.length()-1)
                    pricingRequest.accountNumber = pricingRequest.accountNumber.substring(pricingRequest.accountNumber.indexOf(':')+1);
            }
            System.debug('%%%% Pricing AccountNumber is ' + pricingRequest.accountNumber);
            pricingRequest.sfdcOpportunityId = nvl(oppy.id);
            pricingRequest.distributionChannelCode =  nvl('' + oppy.Account.Distribution_Channel_Cde__c);
           // pricingRequest.partCount = '' + list_oppyParts.size();
            //Added by Buwen Guo 2017-10-24 from email:SAP Call for Pricing
            pricingRequest.salesOrg =  nvl(oppy.Account.Sales_Organization_ID__c);
            pricingRequest.sapInstance = '';
            if(SAPInstanceVal == null || SAPInstanceVal.Name == null){
                for(SAP_Instance__c SapIns : [select Id,Name from SAP_Instance__c LIMIT 1]){
                    SAPInstanceVal = SapIns;
                }
            }
            pricingRequest.sapInstance =  nvl('' + SAPInstanceVal.Name);
            for(Opportunity_Part__c oppyPart : list_oppyParts){
                WrapperOppyParts part = new WrapperOppyParts();
                part.sfdcPartId =  nvl('' + oppyPart.id);
                part.itemNumber =  nvl(oppyPart.NDR_Item_Number__c);
                //part.itemNumber = '1';
                part.partNumber =  nvl(oppyPart.Part_Number_txt__c);
                //part.partNumber =  nvl(oppyPart.Part__r.Name);
                part.requestQty = '' +  nvl('' +oppyPart.Quantity__c);
                //part.uom = oppyPart.Code_for_unit_of_measurement__c;
                part.uom = 'PC';
                list_wrapOppyParts.add(part);
            }
            WrapperOppyInfo oppyInfo = new WrapperOppyInfo(pricingRequest, list_wrapOppyParts);
            HttpRequest req = new HttpRequest();
             
            HttpResponse res = new HttpResponse();
            Http http = new Http();
            if(bestPriceMfg == null || bestPriceMfg.Name == null){
                //bestPriceMfg = [select Name,URL__c from BestPriceWebspeed__c where name='SAP Pricing' LIMIT 1];
                bestPriceMfg = BestPriceWebspeed__c.getInstance('SAP Pricing');
            }
            Energy_Inventory_And_Pricing__c pricingSetting = Energy_Inventory_And_Pricing__c.getInstance('SAP Pricing'); 
            req.setMethod('POST');
            req.setHeader('grant_type','CLIENT_CREDENTIALS');
            //req.setHeader('client_id','396dabc178084bbeb4d35e0d00c329e2' );
            //req.setHeader('client_secret','8647B35320eb4a829d5170ec4052815c');
            if(pricingSetting != null){
                req.setHeader('client_id', pricingSetting.Client_Id__c);
                req.setHeader('client_secret', pricingSetting.Client_Secret__c);
                //Modified by Buwen Guo 2018-05-05 requirement from email:Open Items for Jasmine/Onkar required for the deployment
                req.setClientCertificateName(pricingSetting.Client_Certificate__c);
            }
            //req.setClientCertificateName('sfdcmulesoftpoc');
            req.setHeader('scope','READ WRITE');
            req.setEndpoint(bestPriceMfg.URL__c);
            req.setHeader('Content-Type' ,'application/json;charset=UTF-8');
            req.setTimeout(60*1000);
            system.debug('oppyInfo'+JSON.serialize(oppyInfo));
            req.setBody(JSON.serialize(oppyInfo));
            //req.setCompressed(true); // otherwise we hit a limit of 32000
            System.debug('Request::::' + req);
            res = http.send(req);
        } catch(Exception ex) {
            System.debug('SAP Callout error: '+ ex);
            //ErrorLogging.Log(ex);
            String vStrError = '';
            vStrError += 'Error Type = ' + ex.getTypeName() + 
                ' Error Line = ' + ex.getLineNumber() + '' + 
                ' Error Stack = ' + ex.getStackTraceString() + 
                ' Error Message = ' + ex.getMessage();
            
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,                   
                                         SalesforceConstant.strError, '', '', '', '5','','','Exception', ex.getLineNumber() + '',ex.getStackTraceString());
        }

    }
    public class WrapperOppyInfo{
        public wrapperHeader pricingRequest;
        public List<WrapperOppyParts> Parts;        
        public WrapperOppyInfo(WrapperHeader pricingRequest, List<WrapperOppyParts> list_parts){
            this.pricingRequest = pricingRequest;
            this.Parts = list_parts;
        }
    }
    public class WrapperHeader{
        public String sfdcOpportunityId;
        public String accountNumber;
        public String distributionChannelCode;
        //public String partCount;
        public String salesOrg;
        public String sapInstance;
    }
    
    public class WrapperOppyParts{
        public String sfdcPartId;
        public String itemNumber;
        public String partNumber;
        public String requestQty;
        public String uom;
    }
}