/*------------------------------------------------------------
Author:        Yuan Yao <yuan.yao@capgemini.com>
Description:   This  class is for custom button 'Create Quote' of Opportunity.
			   The user story number is W-00129.
Inputs:        
Test Class:    CreateQuoteBasedOnOpp_Test
History
2017-08-16 	   Yuan Yao <yuan.yao@capgemini.com> Created
------------------------------------------------------------*/
global class CreateQuoteBasedOnOpp {
	
	/*------------------------------------------------------------
	Author:        Yuan Yao <yuan.yao@capgemini.com>
	Description:   Create quote and quote line item according opportunity id.
	Inputs:        oppId - Opportunity Id
	Returns:       retRes - Id
	History
	2017-08-16 	   Yuan Yao <yuan.yao@capgemini.com> created
	------------------------------------------------------------*/
    webService static String createQuote(string oppId) {
        string retRes = '';
        
        //modified by Tangyong Li 2018-02-08 by email Let's do some REAL coding again! 1)d)
        //Opportunity currentOpp = [select Id, Name,Override_Payment_Terms_Description__c,Override_Incoterms_Details__c,ERP_For_Pricing__c, 
        Opportunity currentOpp = [select Id, Name,Override_Incoterms_Details__c,ERP_For_Pricing__c, 
                                  Account_Payment_Terms_Desc__c, Account_Incoterms_Details__c, ContractId, CurrencyIsoCode,Customer_Contact_Name__c, 
                                  AccountId, recordtype.DeveloperName, End_Customer__c ,Valid_From__c,Days_prices_valid__c,Customer_Ref_Number__c,
                                  Contract_start_date__c,Contract_Finish_Date__c,Language_of_Quote__c,Header_Level_Comments__c,Customer_Contact_Name__r.Phone, 
                                  Customer_Contact_Name__r.Email, Pricing_price_comment__c,
                                  //added by Tangyong Li 2018-02-08
                                  Override_Incoterms_Code__c,Override_Payment_Terms_Code__c  
                                  From Opportunity Where Id =: oppId];
        Energy_Quote__c newQuote = new Energy_Quote__c();
        if(currentOpp.recordtype.DeveloperName == 'Energy_Sales'){
            Id salesQuoteId = getSalesQuoteRecTypeId();
            if(salesQuoteId != null) {
                newQuote.RecordTypeId = salesQuoteId;
            }
        }
        /*else if(currentOpp.recordtype.DeveloperName == 'Energy_Tender'){
            Id lmaQuoteId = getLmaQuoteId();
            if(lmaQuoteId != null){
                newQuote.RecordTypeId = lmaQuoteId;
            }
        }*/
        newQuote.Contact__c = currentOpp.Customer_Contact_Name__c;
        newQuote.Phone__c = currentOpp.Customer_Contact_Name__r.Phone; //added by Tangyong Li 2018-01-26
        newQuote.Email__c = currentOpp.Customer_Contact_Name__r.Email; //added by Tangyong Li 2018-01-29
        newQuote.Name = currentOpp.Name + String.valueOf(Date.today()).substring(0, 10);
        newQuote.Contract__c = currentOpp.ContractId;
        newQuote.Account_Name__c = currentOpp.AccountId;
        newQuote.End_Customer__c = currentOpp.End_Customer__c;
        newQuote.Opportunity_Name__c = currentOpp.Id;
        //Added by Buwen Guo 2017-10-20 by email:When Creating a Quote from an Opportunity
        newQuote.CurrencyIsoCode = currentOpp.CurrencyIsoCode;
        //Added by Buwen Guo 2018-05-03 requirement from email:Lots of new issues that need fixing point 9
        newQuote.Comments__c = currentOpp.Pricing_price_comment__c;
        
        //modified by Tangyong Li 2018-02-08 by email Let's do some REAL coding again! 1)
        //newQuote.Override_Incoterms_Details__c = (currentOpp.Override_Incoterms_Details__c == null)?currentOpp.Account_Incoterms_Details__c:currentOpp.Override_Incoterms_Details__c;
        map<String, IncoPayment_Terms__c> map_incoPaymentName_IncoPaymentTerm = IncoPayment_Terms__c.getAll();
        if(currentOpp.ERP_for_Pricing__c == 'MFGPRO') {
        	if(newQuote.Override_Incoterms_Code__c != null) {
	        	if(!map_incoPaymentName_IncoPaymentTerm.containsKey(newQuote.Override_Incoterms_Code__c)) {
	        		newQuote.Override_Incoterms_Details__c = map_incoPaymentName_IncoPaymentTerm.get(newQuote.Override_Incoterms_Code__c).Description__c;
	        	}
    		} else {
    			newQuote.Override_Incoterms_Details__c = currentOpp.Account_Incoterms_Details__c;
    		}
        } else {
        	newQuote.Override_Incoterms_Details__c = (currentOpp.Override_Incoterms_Details__c == null)?currentOpp.Account_Incoterms_Details__c:currentOpp.Override_Incoterms_Details__c;
        }
        
        //added by Tangyong Li 2018-02-08
        newQuote.Override_Incoterms_Code__c = currentOpp.Override_Incoterms_Code__c;
		newQuote.Override_Payment_Terms_Code__c = currentOpp.Override_Payment_Terms_Code__c;
        
        //commented by Tangyong Li 2018-02-08 by email Let's do some REAL coding again! 1)d)
        //newQuote.Override_Payment_Terms_Description__c = (currentOpp.Override_Payment_Terms_Description__c == null)?currentOpp.Account_Payment_Terms_Desc__c:currentOpp.Override_Payment_Terms_Description__c;
        
        //Added by Buwen Guo 2017-10-12 by email:Create Quote Button on Opportunity
        newQuote.Valid_From__c = currentOpp.Valid_From__c;
        newQuote.Days_prices_valid__c = currentOpp.Days_prices_valid__c;
        newQuote.Customer_Ref_Number__c = currentOpp.Customer_Ref_Number__c;          // added by yuan yao 2017-10-13
        newQuote.Contract_start_date__c = currentOpp.Contract_start_date__c;          // added by yuan yao 2017-11-07
        newQuote.Contract_Finish_Date__c = currentOpp.Contract_Finish_Date__c;
        newQuote.Language__c = currentOpp.Language_of_Quote__c;                       //Added by Buwen Guo 2017-11-28 from email:Issues to fix 11/21 point 8
        newQuote.Header_Level_Comments__c = currentOpp.Header_Level_Comments__c;      //Added by Tangyong Li 2018-01-18
        
        try{
            insert newQuote;
            List<Opportunity_Part__c> list_oppParts = new List<Opportunity_Part__c>();
            for(Opportunity_Part__c oppPart:[Select Id ,Seq_No__c, Name,Quantity__c,Sales_Price__c, List_Price__c, Offered_Price__c, 
                                             GPL__c,Part__c,Comments__c,Part__r.Proposal_Part__c,Max_Qty_in_Standard_lead_time__c,Lead_Time__c,
                                             NDR_Item_Number__c,Energy_Quote_Line_Item__c,Code_for_unit_of_measurement__c,
                                             NDR_Competitor_Name__c,NDR_Competitor_Part_Number__c,Customer_Part_Number1__c,Customer_Part_Number__c,   //added by yuan yao 2017-10-31
                                             NDR_Minimum_Order_Quantity__c,NDR_Unit_Package_Type__c,Part__r.Description__c,Primary_Pack_Quantity__c, Reason_Lost_Comments__c, 
                                             Country_of_Origin__c,NDR_Delivery_Unit__c,NDR_Minimum_Delivery_Quantity__c,Proposal_Part_Name_Override__c, //added by Tangyong Li 2017-11-16
                                             ANZ_Item_Id__c, //Added by Buwen Guo 2017-12-13 from email:Today's issues: 12/11 point 19
                                             NDR_Customer_Comments__c   //Added by Buwen Guo 2018-02-26 from email:External Comments Implementation
                                             From Opportunity_Part__c Where Opportunity__c =: oppId and Status__c != 'No Bid']){ //Modified by Buwen Guo 2017-12-15 from email:12/14 fixes... let's discuss point 3
                                                 list_oppParts.add(oppPart);   
                                             }
            if(list_oppParts.size() > 0){
                System.debug('list_oppPartssize+++');
                list<Energy_Quote_Line_Item__c> list_quoteLine = new list<Energy_Quote_Line_Item__c>();
                for(Opportunity_Part__c oppPart : list_oppParts){
                    Energy_Quote_Line_Item__c item = new Energy_Quote_Line_Item__c();
                    item.Energy_Quote_Name__c = newQuote.Id;
                    item.CurrencyIsoCode = newQuote.CurrencyIsoCode;
                    item.Quantity__c = oppPart.Quantity__c;
                    
                    //modified by Tangyong Li 2018-01-16
                    //String str_comments = (oppPart.Comments__c == null || oppPart.Comments__c == '')?oppPart.Name:(oppPart.Comments__c.length()>255)?oppPart.Comments__c.substring(0,254):oppPart.Comments__c;
                    String str_comments = (oppPart.Proposal_Part_Name_Override__c == null || oppPart.Proposal_Part_Name_Override__c == '')?oppPart.Name:(oppPart.Proposal_Part_Name_Override__c.length()>255)?oppPart.Proposal_Part_Name_Override__c.substring(0,254):oppPart.Proposal_Part_Name_Override__c;
                    
                    System.debug('in list_oppPartssize+++');
                    item.Part_Number__c = (oppPart.Part__r.Proposal_Part__c)?str_comments:oppPart.Name;
                    item.Part__c = oppPart.Part__c;
                    item.Seq_No__c = oppPart.Seq_No__c;
                    item.Opportunity_Part__c = oppPart.Id;
                    item.UnitPrice__c = (oppPart.Offered_Price__c==null?0:oppPart.Offered_Price__c);
                    item.Price_List__c = oppPart.Sales_Price__c;
                    item.Product_Hierarchy__c = oppPart.GPL__c;
                    item.TotalPrice__c = (item.UnitPrice__c == null?0:item.UnitPrice__c) * (item.Quantity__c == null?0:item.Quantity__c);
                    item.Max_Qty_in_Standard_lead_time__c = oppPart.Max_Qty_in_Standard_lead_time__c;   // added by yuan yao 2017-10-13
                    item.Lead_Time__c = oppPart.Lead_Time__c;   // added by yuan yao 2017-10-13
                    item.LineNumber__c = oppPart.NDR_Item_Number__c;
                    item.Past_RSQ__c = oppPart.Energy_Quote_Line_Item__c; //Added by Buwen Guo 2017-10-16 from email:Some things to fix and improve point 3
                    item.Unit_of_measure__c = oppPart.Code_for_unit_of_measurement__c; //Added by Buwen Guo 2017-10-20 by email:When Creating a Quote from an Opportunity
                    item.Competitor__c = oppPart.NDR_Competitor_Name__c;    //added by yuan yao 2017-10-31
                    item.Competitor_Part__c = oppPart.NDR_Competitor_Part_Number__c;
                    item.Customer_Part_Number1__c = oppPart.Customer_Part_Number1__c;
                    item.Customer_Part_Number__c = oppPart.Customer_Part_Number__c;
                    item.NDR_Minimum_Order_Quantity__c = oppPart.NDR_Minimum_Order_Quantity__c;
                    item.NDR_Unit_Package_Type__c = oppPart.NDR_Unit_Package_Type__c;     //added by yuan yao 2017-11-07
                    item.Primary_Pack_Quantity__c = oppPart.Primary_Pack_Quantity__c ;
                    item.Description__c = oppPart.Part__r.Description__c;
                    item.Comment__c = oppPart.Comments__c;
                    item.NDR_Customer_Comments__c = oppPart.NDR_Customer_Comments__c;     //Added by Buwen Guo 2018-02-26 from email:External Comments Implementation
                    
                    //added by Tangyong Li 2017-11-16
                    if(currentOpp.ERP_For_Pricing__c == 'SAP (except ANZPAC)') {
                    	item.Country_of_Origin__c = oppPart.Country_of_Origin__c;
                    	item.NDR_Delivery_Unit__c = oppPart.NDR_Delivery_Unit__c;
                    	item.NDR_Minimum_Delivery_Quantity__c = oppPart.NDR_Minimum_Delivery_Quantity__c;
                    }
                    
                    //Added by Buwen Guo 2017-12-13 from email:Today's issues: 12/11 point 19
                    if(currentOpp.ERP_For_Pricing__c == 'ANZPAC') {
                    	item.ANZ_Item_Id__c = oppPart.ANZ_Item_Id__c;
                    }
                    
                    list_quoteLine.add(item);
                }
                if(list_quoteLine.size() > 0){
                    System.debug('list_quoteLine++++');
                    insert list_quoteLine;
                }
            }
            
            retRes= newQuote.Id;
            return retRes;
        }catch(exception e)
        {
            //ErrorLogging.Log(e);
            System.debug('--- Error ----------'+ e);
            retRes= 'Error'+ e.getMessage();
            String vStrError = 'Error Type = ' + e.getTypeName() + ' Error Line = ' + e.getLineNumber() + ' Error Stack = ' + e.getStackTraceString() + ' Error Message = ' + e.getMessage();
        	SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc, SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '',e.getStackTraceString());
            return retRes;
        }
    }
    
    /*------------------------------------------------------------
	Author:        Yuan Yao <yuan.yao@capgemini.com>
	Description:   Save pdf as a attachment.
	Inputs:        quoteId - Quote Id
	Returns:       retRes - the result message
	History
	2017-08-16 	   Yuan Yao <yuan.yao@capgemini.com> created
	------------------------------------------------------------*/
    webService static String savePdf(String quoteId){
        string retRes = '';
        try
        {
            Energy_Quote__c energyQuote = [Select Id,name,Opportunity_Name__r.Type__c, Opportunity_Name__r.ERP_for_Pricing__c, 
                                           Opportunity_Name__r.TE_Reference_Number__c, RecordType.Name,
                                           Opportunity_Name__r.Account.Source_System__c,Opportunity_Name__r.account.recordtype.name
                                           from Energy_Quote__c where ID = : quoteId];
            User u = new User();
            u=[SELECT Id, MED_Region__c FROM User where id =: userInfo.getUserId()]; 
            PageReference pageRef;   
            String erpPricing = energyQuote.Opportunity_Name__r.ERP_for_Pricing__c;
            if(erpPricing == 'SAP (except ANZPAC)'){
                pageRef = new PageReference('/apex/SAPQuotePdf?id='+energyQuote.Id);
            }else if(erpPricing == 'MFGPRO'){
                pageRef = new PageReference('/apex/MFGPROQuotePdf?id='+energyQuote.Id );
            }else if(erpPricing == 'ANZPAC'|| (energyQuote.Opportunity_Name__r.account.recordtype.name == 'Prospect'&& u.MED_Region__c == 'Aus / New Zlnd')){
                pageRef = new PageReference('/apex/AMPICSQuotePdf?id='+energyQuote.Id );             
            }else{
                pageRef = new PageReference('/apex/SAPQuotePdf?id='+energyQuote.Id);
            }
            pageRef.setRedirect(true); 
            Attachment obj = new Attachment();
            if (Test.IsRunningTest()){
            	obj.Body = Blob.valueOf('UNIT.TEST');
            }else{
                obj.Body = pageRef.getContent();
            }
            obj.Name= energyQuote.name + '.pdf';
            obj.ParentId = energyQuote.Id;
            obj.IsPrivate = false;
            insert obj;
            retRes='SUCCESS';
            return retRes;
        }catch(exception e)
        {	
            system.debug('Exception::'+e.getMessage()+','+e.getStackTraceString());
            //ErrorLogging.Log(e);
            retRes= e.getMessage();
            String vStrError = 'Error Type = ' + e.getTypeName() + ' Error Line = ' + e.getLineNumber() + ' Error Stack = ' + e.getStackTraceString() + ' Error Message = ' + e.getMessage();
        	SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc, SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '',e.getStackTraceString());
            return retRes;
        }
    }
    
    /*------------------------------------------------------------
	Author:        Yuan Yao <yuan.yao@capgemini.com>
	Description:   Method to get Sales Quote Id.
	Inputs:        
	Returns:       sales quote Id
	History
	2017-08-16 	   Yuan Yao <yuan.yao@capgemini.com> created
	------------------------------------------------------------*/
    public static Id getSalesQuoteRecTypeId(){
        Id recordTypeId = Schema.SObjectType.Energy_Quote__c.getRecordTypeInfosByName().get('Sales Quote').getRecordTypeId();
        if(recordTypeId != null){
            return recordTypeId;
        }
        return null;
    }
    
    /*------------------------------------------------------------
	Author:        Yuan Yao <yuan.yao@capgemini.com>
	Description:   Method to get LMA Approval Quote Id.
	Inputs:        
	Returns:       LMA Approval Quote Id
	History
	2017-08-16 	   Yuan Yao <yuan.yao@capgemini.com> created
	------------------------------------------------------------
    public static Id getLmaQuoteId(){
        Id recordTypeId = Schema.SObjectType.Energy_Quote__c.getRecordTypeInfosByName().get('LMA Approval Quote').getRecordTypeId();
        if(recordTypeId != null){
            return recordTypeId;
        }
        return null;
    }
    */
}