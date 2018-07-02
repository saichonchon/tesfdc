/*------------------------------------------------------------
Author:        Yuan Yao <yuan.yao@capgemini.com>
Description:   Handler class for Energy_Quote__c trigger.
			   The user story number is W-00454,W-00457.
Inputs:        
Test Class:    EnergyQuoteTrgHandler_Test
History
2017-08-24 	   Yuan Yao <yuan.yao@capgemini.com> Created
------------------------------------------------------------*/
public with sharing class EnergyQuoteTrgHandler extends ClsTriggerVirtual{
    
    public static Boolean isSkipUpdate = false;
    //public static Boolean isSkipRejectOtherQuotes = false;
    public static Boolean isFromQuoteRecreateParts = false;
    
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
        if(trgCtx.isAfter) return;
        checkOppQuoteNum(trgCtx);
        assignQuoteType(trgCtx);
        assignValidityExpirationDate(trgCtx);
    }
    
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
        if(trgCtx.isBefore) return;
        if(trgCtx.isInsert) {
            if(ExtCreateQuoteForOppy.isFromCreateButtonPage == false){
                Set<Id> set_Ids = trgCtx.newMap.keySet();
            	saveQuotePdfAsAttachment(set_Ids);  // added by yuan yao 2017-10-25    When quote is created,save quote pdf as attachment. 
            }
        }
        /*if(!isSkipRejectOtherQuotes) {
            rejectOtherQuotes(trgCtx);
        }
        if(!isSkipUpdate) {
            syncEnergyQuoteSAPQuoteNum(trgCtx);
        }*/
        if(!isSkipUpdate) {
        	executeHandler(trgCtx);
        }
        copyApprovedLineItemsToOppyParts(trgCtx);
        //syncOppyStage(trgCtx);
    }
    
	/*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Quote Type should be pulled in from opportunity when the Energy Quote record is created.
	Inputs:        trgCtx - ClsWrappers.TriggerContext.
	Returns:       
	History
	2017-11-15 	   Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
    private static void assignQuoteType(ClsWrappers.TriggerContext trgCtx){
        map<id, list<Energy_Quote__c>> map_OppyId_ListEnergyQuotes = new map<id, list<Energy_Quote__c>>();
        map<id, Opportunity> map_OppyId_Oppy = new map<id, Opportunity>();
        if(trgCtx.isInsert || trgCtx.isUndelete){
        	for(Sobject sobj : trgCtx.newList) {
                Energy_Quote__c quote = (Energy_Quote__c)sobj;
                if(trgCtx.isInsert) {
                	quote.Approval_Status__c = 'Pending';
                }
                if(!map_OppyId_ListEnergyQuotes.containsKey(quote.Opportunity_Name__c)){
                    map_OppyId_ListEnergyQuotes.put(quote.Opportunity_Name__c, new list<Energy_Quote__c>());
                }
                map_OppyId_ListEnergyQuotes.get(quote.Opportunity_Name__c).add(quote);
            }
            
            if(map_OppyId_ListEnergyQuotes.keySet().size() > 0){
                for(Opportunity oppy : [SELECT Id, Quote_Type__c FROM Opportunity 
                					WHERE Id IN: map_OppyId_ListEnergyQuotes.keySet()]){
                	map_OppyId_Oppy.put(oppy.Id, oppy);
                }
                
                for(Id oppyId : map_OppyId_ListEnergyQuotes.keySet()){
                	for(Energy_Quote__c quote : map_OppyId_ListEnergyQuotes.get(oppyId)){
                		quote.Quote_Type__c = map_OppyId_Oppy.get(oppyId).Quote_Type__c;
                	}
                }
            }
        }
    }
    
    /*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   the validity expiration date is the Valid From date + valid for number.  
				   So if valid From is 11/17/2017 and valid for is 3,
				   then Validity Expiration Date should say 11/20/2017.
	Inputs:        trgCtx - ClsWrappers.TriggerContext.
	Returns:       
	History
	2017-11-15 	   Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
    private static void assignValidityExpirationDate(ClsWrappers.TriggerContext trgCtx){
        if(trgCtx.isInsert || trgCtx.isUndelete){
        	for(Sobject sobj : trgCtx.newList) {
                Energy_Quote__c quote = (Energy_Quote__c)sobj;
                if(quote.Valid_From__c != null){
                	if(String.isNotBlank(quote.Valid_Days__c)){
                		quote.Expiration_Date__c = quote.Valid_From__c.addDays(Integer.valueOf(quote.Valid_Days__c));
                	}else{
                		quote.Expiration_Date__c = quote.Valid_From__c;
                	}
                }
            }
        }else if(trgCtx.isUpdate){
        	for(Sobject sobj : trgCtx.newList) {
                Energy_Quote__c quote = (Energy_Quote__c)sobj;
                Energy_Quote__c oldQuote = (Energy_Quote__c)trgCtx.oldMap.get(quote.Id);
                if(quote.Valid_From__c != oldQuote.Valid_From__c){
                	quote.Expiration_Date__c = quote.Valid_From__c;
                }
                if(quote.Valid_Days__c != oldQuote.Valid_Days__c && quote.Valid_From__c != null){
                	quote.Expiration_Date__c = quote.Valid_From__c.addDays(Integer.valueOf(quote.Valid_Days__c));
            	}
            }
        }
    }
    
    /*------------------------------------------------------------
	Author:        Yuan Yao <yuan.yao@capgemini.com>
	Description:   When an Energy Quote record is created, save quote pdf as attachment.
	Inputs:        set_quoteIds - set of quote Ids.
	Returns:       
	History
	2017-10-25 	   Yuan Yao <yuan.yao@capgemini.com> created
	------------------------------------------------------------*/
    @Future(callout=true)
    public static void saveQuotePdfAsAttachment(Set<Id> set_quoteIds){
        try{
        List<Attachment> list_pdf = new List<Attachment>();
        for(Energy_Quote__c energyQuote : [Select Id,name,Opportunity_Name__r.Type__c, Opportunity_Name__r.ERP_for_Pricing__c, 
                                           Opportunity_Name__r.TE_Reference_Number__c, RecordType.Name,
                                           Opportunity_Name__r.Account.Source_System__c,Opportunity_Name__r.account.recordtype.name
                                           from Energy_Quote__c where ID in: set_quoteIds]){
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
        Attachment obj = new Attachment();
        if (Test.IsRunningTest()){
            obj.Body = Blob.valueOf('UNIT.TEST');
        }else{
            obj.Body = pageRef.getContent();
        }
            //obj.Name= 'TE' +' '+energyQuote.Opportunity_Name__r.Oppty_Type__c+' '+energyQuote.Opportunity_Name__r.TE_Reference_Number__c+'.'+'pdf';
            obj.Name= energyQuote.name + '.pdf';
            obj.ParentId = energyQuote.Id;
            //obj.ContentType ='pdf';
            obj.IsPrivate = false;
            list_pdf.add(obj);                                  
        }
        if(list_pdf.size() > 0) {
            insert list_pdf;
        }
        }catch(exception ex) {
            //ErrorLogging.Log(ex);
            String vStrError = 'Error Type = ' + ex.getTypeName() + ' Error Line = ' + ex.getLineNumber() + ' Error Stack = ' + ex.getStackTraceString() + ' Error Message = ' + ex.getMessage();
        	SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc, SalesforceConstant.strError, '', '', '', '5','','','Exception', ex.getLineNumber() + '',ex.getStackTraceString());
            System.debug('--- Error ----------'+ ex);
        }
    }
    
	/*------------------------------------------------------------
	Author:        Tangyong Li <tangyong.li@capgemini.com>
	Description:   When an Energy Quote record is marked as won, you should automatically update the opportunity to Won.
	Inputs:        trgCtx - ClsWrappers.TriggerContext
	Returns:       
	History
	2017-09-19 	   Tangyong Li <tangyong.li@capgemini.com> created
	------------------------------------------------------------*/
	/*
    private static void syncOppyStage(ClsWrappers.TriggerContext trgCtx) {
        if(trgCtx.isDelete) return;
        set<String> set_oppyIds = new set<String>();
        list<Opportunity> list_updateOppys = new list<Opportunity>();
        map<Id, Energy_Quote__c> map_oppyId_quote = new map<Id, Energy_Quote__c>();
        try{
	        for(Sobject sobj : trgCtx.newList) {
	            Energy_Quote__c quote = (Energy_Quote__c)sobj;
	            if(quote.Approval_Status__c == 'Won') {
	            	system.debug('update to won:::: ');
	                set_oppyIds.add(quote.Opportunity_Name__c);
	                map_oppyId_quote.put(quote.Opportunity_Name__c, quote);
	            }
	        }
	        for(Opportunity oppy : [SELECT Id, StageName, Reason_of_Win__c, Account.RecordType.Name FROM Opportunity WHERE Id IN: set_oppyIds]) {
	            system.debug('oppy reason won::: ' + map_oppyId_quote);
	            system.debug('oppy reason won::: ' + map_oppyId_quote.get(oppy.Id).Reason_of_Win__c);
	            system.debug('oppy reason won::: ' + oppy.Reason_of_Win__c);
	            oppy.Reason_of_Win__c = map_oppyId_quote.get(oppy.Id).Reason_of_Win__c;
	            if(oppy.Account.RecordType.Name == 'Prospect') {
	                if(oppy.StageName != 'Won - Prospect') {
	                    oppy.StageName = 'Won - Prospect';
	                }
	            } else if(oppy.StageName != 'Won') {
	            	system.debug('oppy stageName :::: ' + oppy.StageName);
	                oppy.StageName = 'Won';
	            }
                list_updateOppys.add(oppy);
	        }
	        if(list_updateOppys.size() > 0) {
	        	system.debug('list_updateOppys::::   ' + list_updateOppys);
	            update list_updateOppys;
	        }
        }catch(exception ex) {
            ErrorLogging.Log(ex);
            String vStrError = 'Error Type = ' + ex.getTypeName() + ' Error Line = ' + ex.getLineNumber() + ' Error Stack = ' + ex.getStackTraceString() + ' Error Message = ' + ex.getMessage();
        	SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc, SalesforceConstant.strError, '', '', '', '5','','','Exception', ex.getLineNumber() + '',ex.getStackTraceString());
            System.debug('--- Error ----------'+ ex);
        }
    }
    */
    
    /*------------------------------------------------------------
	Author:        Tangyong Li <tangyong.li@capgemini.com>
	Description:   Method to make sure that only one quote on an opportunity can have a non-null SAP_Quote_Number__c value.
				   Reject other quote when the quote is won.
	Inputs:        trgCtx - ClsWrappers.TriggerContext
	Returns:       
	History
	2017-12-27 	   Tangyong Li <tangyong.li@capgemini.com> created
	------------------------------------------------------------*/
	private static void executeHandler(ClsWrappers.TriggerContext trgCtx) {
		//START - syncEnergyQuoteSAPQuoteNum
		set<String> set_sapQuoteNumQuoteId = new set<String>();
        set<String> set_oppyIds = new set<String>();
        list<Energy_Quote__c> list_updateQuotes = new list<Energy_Quote__c>();
        
        try{
	        if(trgCtx.isInsert) {
	            for(Sobject sobj : trgCtx.newList) {
	                Energy_Quote__c quote = (Energy_Quote__c)sobj;
	                if(quote.SAP_Quote_Number__c != null) {
	                    set_sapQuoteNumQuoteId.add(quote.Id);
	                    set_oppyIds.add(quote.Opportunity_Name__c);
	                }
	            }
	        } else if(trgCtx.isUpdate){
	            for(Sobject sobj : trgCtx.newList) {
	                Energy_Quote__c quote = (Energy_Quote__c)sobj;
	                Energy_Quote__c oldQuote = (Energy_Quote__c)trgCtx.oldMap.get(quote.Id);
	                if(quote.SAP_Quote_Number__c != null && oldQuote.SAP_Quote_Number__c == null) {
	                    set_sapQuoteNumQuoteId.add(quote.Id);
	                    set_oppyIds.add(quote.Opportunity_Name__c);
	                }
	            }
	        }
	        for(Energy_Quote__c quote : [SELECT Id, SAP_Quote_Number__c, Opportunity_Name__c
	                                     FROM Energy_Quote__c
	                                     WHERE Opportunity_Name__c IN: set_oppyIds 
	                                     AND Id NOT IN: set_sapQuoteNumQuoteId 
	                                     AND SAP_Quote_Number__c != null]) {
	                                         quote.SAP_Quote_Number__c = null;
	                                         list_updateQuotes.add(quote);
         	}
	       
	    //END - syncEnergyQuoteSAPQuoteNum
	    //START - rejectOtherQuotes
		    Set<Id> set_OppIds = new Set<Id>();
	        Set<Id> set_ApprovedQuoteIds = new Set<Id>();
	        map<Id, Energy_Quote__c> map_id_quote = new map<Id, Energy_Quote__c>();
	        if(trgCtx.isUpdate) {
	            for(Sobject sobj : trgCtx.newList) {
	                Energy_Quote__c quote = (Energy_Quote__c)sobj;
	                Energy_Quote__c oldQuote = (Energy_Quote__c)trgCtx.oldMap.get(quote.Id);
	                //edited by Buwen Guo 2017-10-11  change Approved to won
	                //if(quote.Approval_Status__c == 'Approved' && 
	                system.debug('in method2::quote.Approval_Status__c:'+quote.Approval_Status__c);
	                system.debug('in method2::oldQuote.Approval_Status__c:'+oldQuote.Approval_Status__c);
	                if(quote.Approval_Status__c == 'Won' && 
	                   quote.Approval_Status__c != oldQuote.Approval_Status__c){
	                       set_ApprovedQuoteIds.add(quote.Id);
	                       set_OppIds.add(quote.Opportunity_Name__c);
	                   }
	            }
	        }
	        system.debug('in method2::set_OppIds:'+set_OppIds);
	        if(set_OppIds.size() > 0) {
	            for(Energy_Quote__c quoteItem : [Select Id, Approval_Status__c, Opportunity_Name__c From Energy_Quote__c 
	                                             Where Opportunity_Name__c in: set_OppIds]) {
	                                                 map_id_quote.put(quoteItem.Id, quoteItem);							 
	                                             }
	            if(map_id_quote.size() > 0) {
	                for(Id quoteId :set_ApprovedQuoteIds){
	                    map_id_quote.remove(quoteId);
	                }
	            }
	            if(map_id_quote.size() > 0){
	                for(Id quoteId : map_id_quote.keySet()) {
	                	//modified by Tangyong Li 2017-12-07
	                    //Edited by Buwen Guo 2017-10-11 change rejected to lost.
	                    map_id_quote.get(quoteId).Approval_Status__c = 'Superceded';
	                }
	                system.debug('in method2::map_id_quote.values()::'+map_id_quote.values());
	            }
	        }
	    //END - rejectOtherQuotes
	    //Update
		    list_updateQuotes.addAll(map_id_quote.values());
		    if(list_updateQuotes.size() > 0) {
	            isSkipUpdate = true;
	            update list_updateQuotes;
	        }
        }catch(exception ex) {
            //ErrorLogging.Log(ex);
            String vStrError = 'Error Type = ' + ex.getTypeName() + ' Error Line = ' + ex.getLineNumber() + ' Error Stack = ' + ex.getStackTraceString() + ' Error Message = ' + ex.getMessage();
        	SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc, SalesforceConstant.strError, '', '', '', '5','','','Exception', ex.getLineNumber() + '',ex.getStackTraceString());
            System.debug('--- Error ----------'+ ex);
        }
	}
	/*------------------------------------------------------------
	Author:        Tangyong Li <tangyong.li@capgemini.com>
	Description:   Method to make sure that only one quote on an opportunity can have a non-null SAP_Quote_Number__c value.
	Inputs:        trgCtx - ClsWrappers.TriggerContext
	Returns:       
	History
	2017-09-11 	   Tangyong Li <tangyong.li@capgemini.com> created
	------------------------------------------------------------*/
    /*private static void syncEnergyQuoteSAPQuoteNum(ClsWrappers.TriggerContext trgCtx) {
        set<String> set_sapQuoteNumQuoteId = new set<String>();
        set<String> set_oppyIds = new set<String>();
        list<Energy_Quote__c> list_updateQuotes = new list<Energy_Quote__c>();
        try{
	        if(trgCtx.isInsert) {
	            for(Sobject sobj : trgCtx.newList) {
	                Energy_Quote__c quote = (Energy_Quote__c)sobj;
	                if(quote.SAP_Quote_Number__c != null) {
	                    set_sapQuoteNumQuoteId.add(quote.Id);
	                    set_oppyIds.add(quote.Opportunity_Name__c);
	                }
	            }
	        } else if(trgCtx.isUpdate){
	            for(Sobject sobj : trgCtx.newList) {
	                Energy_Quote__c quote = (Energy_Quote__c)sobj;
	                Energy_Quote__c oldQuote = (Energy_Quote__c)trgCtx.oldMap.get(quote.Id);
	                if(quote.SAP_Quote_Number__c != null && oldQuote.SAP_Quote_Number__c == null) {
	                    set_sapQuoteNumQuoteId.add(quote.Id);
	                    set_oppyIds.add(quote.Opportunity_Name__c);
	                }
	            }
	        }
	        for(Energy_Quote__c quote : [SELECT Id, SAP_Quote_Number__c, Opportunity_Name__c
	                                     FROM Energy_Quote__c
	                                     WHERE Opportunity_Name__c IN: set_oppyIds 
	                                     AND Id NOT IN: set_sapQuoteNumQuoteId 
	                                     AND SAP_Quote_Number__c != null]) {
	                                         quote.SAP_Quote_Number__c = null;
	                                         list_updateQuotes.add(quote);
	                                     }
	        if(list_updateQuotes.size() > 0) {
	            isSkipUpdate = true;
	            update list_updateQuotes;
	        }
        }catch(exception ex) {
            ErrorLogging.Log(ex);
            String vStrError = 'Error Type = ' + ex.getTypeName() + ' Error Line = ' + ex.getLineNumber() + ' Error Stack = ' + ex.getStackTraceString() + ' Error Message = ' + ex.getMessage();
        	SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc, SalesforceConstant.strError, '', '', '', '5','','','Exception', ex.getLineNumber() + '',ex.getStackTraceString());
            System.debug('--- Error ----------'+ ex);
        }
    }*/
    
    /*------------------------------------------------------------
	Author:        Yuan Yao <yuan.yao@capgemini.com>
	Description:   Copy the quote line items of won energy quote to the Opportunity.
	Inputs:        trgCtx - ClsWrappers.TriggerContext.
	Returns:       
	History
	2017-10-25 	   Yuan Yao <yuan.yao@capgemini.com> created
	------------------------------------------------------------*/
    private static void copyApprovedLineItemsToOppyParts(ClsWrappers.TriggerContext trgCtx) {
        //system.debug('in method1');
        ExtOppyPartDiscounting.isEnergyPartManagementSave = true;
        Set<Id> set_ApprovedQuoteIds = new Set<Id>();
        set<Id> set_oppIds = new set<Id>();
        list<Opportunity_Part__c> list_partsNeedToDel = new list<Opportunity_Part__c>();
        list<Opportunity_Part__c> list_newParsToInsert = new list<Opportunity_Part__c>();
        list<Opportunity> list_needUpdateOpp = new list<Opportunity>();
        map<Id, Energy_Quote__c> map_oppid_quote = new map<Id, Energy_Quote__c>();
        map<Id, String> map_oppId_oppIsoCode = new map<Id, String>();
        map<Id, List<Energy_Quote_Line_Item__c>> map_oppId_listItems = new map<Id, List<Energy_Quote_Line_Item__c>>();
        
        //added by Tangyong Li 2018-01-09  (When an Energy Quote record is marked as won, you should automatically update the opportunity to Won.)
        map<Id, Energy_Quote__c> map_syncOppyId_quote = new map<Id, Energy_Quote__c>();
        
        try{
        	//added by Tangyong Li 2018-01-09  (When an Energy Quote record is marked as won, you should automatically update the opportunity to Won.)
        	if(trgCtx.isInsert) {
        		for(Sobject sobj : trgCtx.newList) {
	                Energy_Quote__c quote = (Energy_Quote__c)sobj;
	        		if(quote.Approval_Status__c == 'Won') {
		                map_syncOppyId_quote.put(quote.Opportunity_Name__c, quote);
		            }
        		}
        	}//end
        	else if(trgCtx.isUpdate) {
	            //system.debug('in update');
	            for(Sobject sobj : trgCtx.newList) {
	                Energy_Quote__c quote = (Energy_Quote__c)sobj;
	                Energy_Quote__c oldQuote = (Energy_Quote__c)trgCtx.oldMap.get(quote.Id);
	                //edited by Buwen Guo 2017-10-11  change Approved to won
	                //if(quote.Approval_Status__c == 'Approved' && 
	                if(quote.Approval_Status__c == 'Won' && 
	                   quote.Approval_Status__c != oldQuote.Approval_Status__c){
	                       set_ApprovedQuoteIds.add(quote.Id);
	                       //set_oppIds.add(quote.Opportunity_Name__c);
	                       if(quote.Opportunity_Name__c != null){
	                           map_oppid_quote.put(quote.Opportunity_Name__c, quote);
	                           
	                           //added by Tangyong Li 2018-01-09  (When an Energy Quote record is marked as won, you should automatically update the opportunity to Won.)
	                           map_syncOppyId_quote.put(quote.Opportunity_Name__c, quote);
	                       }
	                   }
	            } 
	            //system.debug('map_oppid_quote::'+map_oppid_quote);
	            if(map_syncOppyId_quote.keySet().size() > 0) {
	            	isFromQuoteRecreateParts = true;
	                for(Opportunity oppy : [Select Id, AccountId, Account.RecordType.Name, StageName, End_Customer__c,CurrencyIsoCode,Valid_From__c,Days_prices_valid__c,
	                								Contract_start_date__c,Contract_Finish_Date__c,Quote_Type__c, Reason_of_Win__c, Pricing_price_comment__c
	                							 	//From Opportunity Where Id in: map_oppid_quote.keySet()]) {
	                							 	From Opportunity Where Id in: map_syncOppyId_quote.keySet()]) { //modified by Tangyong Li 2018-01-09  merge method syncOppyStage
	                    
	                    //added by Tangyong Li 2018-01-09  (When an Energy Quote record is marked as won, you should automatically update the opportunity to Won.)
	                    oppy.Reason_of_Win__c = map_syncOppyId_quote.get(oppy.Id).Reason_of_Win__c;
			            if(oppy.Account.RecordType.Name == 'Prospect') {
			                if(oppy.StageName != 'Won - Prospect') {
			                    oppy.StageName = 'Won - Prospect';
			                }
			            } else if(oppy.StageName != 'Won') {
			            	//system.debug('oppy stageName :::: ' + oppy.StageName);
			                oppy.StageName = 'Won';
			            }
		                //end
			            oppy.Approval_Status__c = 'Approved';
	                    
	                    if(map_oppid_quote.containsKey(oppy.Id)) { //added by Tangyong Li 2018-01-09  (When an Energy Quote record is marked as won, you should automatically update the opportunity to Won.)
		                    map_oppId_oppIsoCode.put(oppy.Id, oppy.CurrencyIsoCode);
		                    if(oppy.AccountId != map_oppid_quote.get(oppy.Id).Account_Name__c ||
		                       oppy.End_Customer__c != map_oppid_quote.get(oppy.Id).End_Customer__c||
		                       oppy.Valid_From__c != map_oppid_quote.get(oppy.Id).Valid_From__c||
		                       oppy.Days_prices_valid__c != map_oppid_quote.get(oppy.Id).Days_prices_valid__c||
		                       oppy.Contract_start_date__c != map_oppid_quote.get(oppy.Id).Contract_start_date__c||
		                       oppy.Contract_Finish_Date__c != map_oppid_quote.get(oppy.Id).Contract_Finish_Date__c||
		                       oppy.Quote_Type__c != map_oppid_quote.get(oppy.Id).Quote_Type__c){
		                           oppy.AccountId = map_oppid_quote.get(oppy.Id).Account_Name__c;
		                           oppy.End_Customer__c = map_oppid_quote.get(oppy.Id).End_Customer__c;
		                           
		                           //Modified By Buwen Guo 2017-12-05 from email:12/3 Issues point 9
		                           oppy.Valid_From__c = map_oppid_quote.get(oppy.Id).Valid_From__c;
		                           oppy.Days_prices_valid__c = map_oppid_quote.get(oppy.Id).Days_prices_valid__c;
		                           oppy.Contract_start_date__c = map_oppid_quote.get(oppy.Id).Contract_start_date__c;
		                           oppy.Contract_Finish_Date__c = map_oppid_quote.get(oppy.Id).Contract_Finish_Date__c;
		                           oppy.Quote_Type__c = map_oppid_quote.get(oppy.Id).Quote_Type__c;
		                           oppy.Pricing_price_comment__c = map_oppid_quote.get(oppy.Id).Comments__c;
							}
						}
						list_needUpdateOpp.add(oppy);    
	                }
	            }
	            //system.debug('list_needUpdateOpp::'+list_needUpdateOpp);
	            if(list_needUpdateOpp.size() > 0) {
	            	system.debug('oppyStage:::::   ' + list_needUpdateOpp[0].StageName);
	                update list_needUpdateOpp;
	            }
	            for(Opportunity_Part__c partItem : [Select Id, Opportunity__c From Opportunity_Part__c 
	                                                Where Opportunity__c in : map_oppid_quote.keySet() and Status__c != 'No Bid']){//Modified by Buwen Guo 2017-12-15 from email:12/14 fixes... let's discuss point 4
                    list_partsNeedToDel.add(partItem);							
                }
	            if(list_partsNeedToDel.size() > 0) {
	                delete list_partsNeedToDel;
	            }
	            system.enqueueJob(new ClsCopyLineItemsToOppyPartsQueue(set_ApprovedQuoteIds,map_oppId_oppIsoCode));
	        }
        }catch(exception ex) {
            //ErrorLogging.Log(ex);
            String vStrError = 'Error Type = ' + ex.getTypeName() + ' Error Line = ' + ex.getLineNumber() + ' Error Stack = ' + ex.getStackTraceString() + ' Error Message = ' + ex.getMessage();
        	SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc, SalesforceConstant.strError, '', '', '', '5','','','Exception', ex.getLineNumber() + '',ex.getStackTraceString());
            System.debug('--- Error ----------'+ ex);
        }
    }
    
    @Future(callout=true)
    public static void insertNewOppPart(String str_listInsertParts){
    	isFromQuoteRecreateParts = true;
    	list<Opportunity_Part__c> list_insertParts = (list<Opportunity_Part__c>)JSON.deserialize(str_listInsertParts, list<Opportunity_Part__c>.class);
    	insert list_insertParts;
    }
    
    /*------------------------------------------------------------
	Author:        Yuan Yao <yuan.yao@capgemini.com>
	Description:   Insert new Opportunity_Part__c.
	Inputs:        set_ApprovedQuoteIds - approved quote ids, map_oppId_oppIsoCode
	Returns:       
	History
	2017-10-25 	   Yuan Yao <yuan.yao@capgemini.com> created
	------------------------------------------------------------*/
	/*
    @Future(callout=true) 
    public static void insertNewOppPart(Set<Id> set_ApprovedQuoteIds,map<Id,String> map_oppId_oppIsoCode){
        map<Id, List<Energy_Quote_Line_Item__c>> map_oppId_listItems = new map<Id, List<Energy_Quote_Line_Item__c>>();
        list<Opportunity_Part__c> list_newParsToInsert = new list<Opportunity_Part__c>();
		map<String,String> map_part_gpl = new map<String,String>();
        try{
        String str_rectypeId = Schema.SObjectType.Opportunity_Part__c.getRecordTypeInfosByName().get('Energy Parts').getRecordTypeId();
        isFromQuoteRecreateParts = true;
        if(set_ApprovedQuoteIds.size() > 0) {
        	set<String> set_partIds = new set<String>();
            for(Energy_Quote_Line_Item__c item: [Select Id, Energy_Quote_Name__c , Quantity__c,
                                                 Part_Number__c, UnitPrice__c, Price_List__c, Product_Hierarchy__c,Part__c,	 
                                                 Energy_Quote_Name__r.Opportunity_Name__c,Competitor__c,Competitor_Part__c,Primary_Pack_Quantity__c,
                                                 Customer_Part_Number1__c,Customer_Part_Number__c,Seq_No__c,Max_Qty_in_Standard_lead_time__c,
                                                 Lead_Time__c, LineNumber__c, Past_RSQ__c, Unit_of_measure__c,NDR_Unit_Package_Type__c,NDR_Minimum_Order_Quantity__c,
                                                 Comment__c,NDR_Customer_Comments__c
                                                 From Energy_Quote_Line_Item__c 
                                                 Where Energy_Quote_Name__c in: set_ApprovedQuoteIds]){
                                                     if(!map_oppId_listItems.containsKey(item.Energy_Quote_Name__r.Opportunity_Name__c)){
                                                         map_oppId_listItems.put(item.Energy_Quote_Name__r.Opportunity_Name__c, new List<Energy_Quote_Line_Item__c>());
                                                     }
                                                     map_oppId_listItems.get(item.Energy_Quote_Name__r.Opportunity_Name__c).add(item);
                                                     set_partIds.add(item.Part__c);
                                                 }
			for(part__c p : [select id,Product_Hierarchy__c from part__c where id IN :set_partIds]){
            	map_part_gpl.put(p.Id,p.Product_Hierarchy__c);
            }
        }
        if(map_oppId_listItems.size() > 0){
            for(Id oppId : map_oppId_listItems.keySet()){
                if(map_oppId_listItems.get(oppId).size() > 0) {
                    for(Energy_Quote_Line_Item__c lineItem : map_oppId_listItems.get(oppId)) {
                        Opportunity_Part__c newPart = new Opportunity_Part__c();
                        newPart.Opportunity__c = oppId;
                        newPart.RecordTypeId = str_rectypeId;
                        newPart.CurrencyIsoCode = map_oppId_oppIsoCode.get(oppId);
                        newPart.Quantity__c = lineItem.Quantity__c;
                        newPart.Part__c = lineItem.Part__c;
                        //newPart.Name = quote.Part_Number__c;
                        newPart.Sales_Price__c = lineItem.Price_List__c;
                        newPart.Offered_Price__c = lineItem.UnitPrice__c;
                        newPart.GPL__c = lineItem.Product_Hierarchy__c;
                        if(lineItem.Product_Hierarchy__c == null && lineItem.Part__c != null && map_part_gpl.containsKey(lineItem.Part__c)){
                        	newPart.GPL__c = map_part_gpl.get(lineItem.Part__c);
                        }
                        //added by yuan yao 2017-10-31 
                        newPart.Seq_No__c = lineItem.Seq_No__c;
                        newPart.Max_Qty_in_Standard_lead_time__c = lineItem.Max_Qty_in_Standard_lead_time__c;
                        newPart.Lead_Time__c = lineItem.Lead_Time__c;
                        newPart.NDR_Item_Number__c = lineItem.LineNumber__c;
                        newPart.Energy_Quote_Line_Item__c = lineItem.Past_RSQ__c;
                        newPart.Code_for_unit_of_measurement__c = lineItem.Unit_of_measure__c;
                        newPart.NDR_Competitor_Name__c = lineItem.Competitor__c;
                        newPart.NDR_Competitor_Part_Number__c = lineItem.Competitor_Part__c;
                        newPart.Customer_Part_Number1__c = lineItem.Customer_Part_Number1__c;
                        newPart.Customer_Part_Number__c = lineItem.Customer_Part_Number__c;
                        newPart.NDR_Minimum_Order_Quantity__c = lineItem.NDR_Minimum_Order_Quantity__c;
                        newPart.NDR_Unit_Package_Type__c = lineItem.NDR_Unit_Package_Type__c;
                        newPart.Primary_Pack_Quantity__c = lineItem.Primary_Pack_Quantity__c;     //added by yuan yao 2017-11-07
                        newPart.Status__c = 'Won';                                                //Added by Buwen Guo 2017-12-15 requirement from email:12/14 fixes... let's discuss point 6
                        newPart.Comments__c = lineItem.Comment__c;   
                        newPart.NDR_Customer_Comments__c = lineItem.NDR_Customer_Comments__c;     //Added by Buwen Guo 2018-02-26 requirement from email:External Comments Implementation
                        list_newParsToInsert.add(newPart);
                    }
                }
                
            }
        }
        if(list_newParsToInsert.size() > 0) {
            System.debug('list_newParsToInsert+++' + list_newParsToInsert);
            insert list_newParsToInsert;
        }
        }catch(exception ex) {
            //ErrorLogging.Log(ex);
            String vStrError = 'Error Type = ' + ex.getTypeName() + ' Error Line = ' + ex.getLineNumber() + ' Error Stack = ' + ex.getStackTraceString() + ' Error Message = ' + ex.getMessage();
        	SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc, SalesforceConstant.strError, '', '', '', '5','','','Exception', ex.getLineNumber() + '',ex.getStackTraceString());
            System.debug('--- Error ----------'+ ex);
        }
    }*/
    
    /*------------------------------------------------------------
	Author:        Yuan Yao <yuan.yao@capgemini.com>
	Description:   Reject other quote when the quote is won.
	Inputs:        trgCtx - ClsWrappers.TriggerContext.
	Returns:       
	History
	2017-10-25 	   Yuan Yao <yuan.yao@capgemini.com> created
	------------------------------------------------------------*/
	//START - Modifed by Tangyong Li <tangyong.li@capgemini.com> at 2017-12-27
    /*private static void rejectOtherQuotes(ClsWrappers.TriggerContext trgCtx){
        Set<Id> set_OppIds = new Set<Id>();
        Set<Id> set_ApprovedQuoteIds = new Set<Id>();
        map<Id, Energy_Quote__c> map_id_quote = new map<Id, Energy_Quote__c>();
        
        system.debug('in method2');
        try{
        if(trgCtx.isUpdate) {
            for(Sobject sobj : trgCtx.newList) {
                Energy_Quote__c quote = (Energy_Quote__c)sobj;
                Energy_Quote__c oldQuote = (Energy_Quote__c)trgCtx.oldMap.get(quote.Id);
                //edited by Buwen Guo 2017-10-11  change Approved to won
                //if(quote.Approval_Status__c == 'Approved' && 
                system.debug('in method2::quote.Approval_Status__c:'+quote.Approval_Status__c);
                system.debug('in method2::oldQuote.Approval_Status__c:'+oldQuote.Approval_Status__c);
                if(quote.Approval_Status__c == 'Won' && 
                   quote.Approval_Status__c != oldQuote.Approval_Status__c){
                       set_ApprovedQuoteIds.add(quote.Id);
                       set_OppIds.add(quote.Opportunity_Name__c);
                   }
            }
        }
        system.debug('in method2::set_OppIds:'+set_OppIds);
        if(set_OppIds.size() > 0) {
            for(Energy_Quote__c quoteItem : [Select Id, Approval_Status__c, Opportunity_Name__c From Energy_Quote__c 
                                             Where Opportunity_Name__c in: set_OppIds]) {
                                                 map_id_quote.put(quoteItem.Id, quoteItem);							 
                                             }
            if(map_id_quote.size() > 0) {
                for(Id quoteId :set_ApprovedQuoteIds){
                    map_id_quote.remove(quoteId);
                }
            }
            if(map_id_quote.size() > 0){
                for(Id quoteId : map_id_quote.keySet()) {
                	//modified by Tangyong Li 2017-12-07
                    //Edited by Buwen Guo 2017-10-11 change rejected to lost.
                    //map_id_quote.get(quoteId).Approval_Status__c = 'Rejected';*/
                    /*
                    if(map_id_quote.get(quoteId).Approval_Status__c == 'Won') {
                        map_id_quote.get(quoteId).Approval_Status__c = 'Superceded';
                    }else if(map_id_quote.get(quoteId).Approval_Status__c == 'Pending'|| map_id_quote.get(quoteId).Approval_Status__c == '' || map_id_quote.get(quoteId).Approval_Status__c == null) {
                        map_id_quote.get(quoteId).Approval_Status__c = 'Lost';
                    }*/
                    /*map_id_quote.get(quoteId).Approval_Status__c = 'Superceded';
                }
                system.debug('in method2::map_id_quote.values()::'+map_id_quote.values());
                isSkipRejectOtherQuotes = true;
                update map_id_quote.values();
            }
            
        }
        }catch(exception ex) {
            ErrorLogging.Log(ex);
            String vStrError = 'Error Type = ' + ex.getTypeName() + ' Error Line = ' + ex.getLineNumber() + ' Error Stack = ' + ex.getStackTraceString() + ' Error Message = ' + ex.getMessage();
        	SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc, SalesforceConstant.strError, '', '', '', '5','','','Exception', ex.getLineNumber() + '',ex.getStackTraceString());
            System.debug('--- Error ----------'+ ex);
        }
    }*/
    //END - Modifed by Tangyong Li <tangyong.li@capgemini.com> at 2017-12-27
    /*------------------------------------------------------------
	Author:        Yuan Yao <yuan.yao@capgemini.com>
	Description:   Method to assign number to quote RevisionNum based on related opportunity quote number.
	Inputs:        trgCtx - ClsWrappers.TriggerContext.
	Returns:       
	History
	2017-09-21 	   Yuan Yao <yuan.yao@capgemini.com> created
	------------------------------------------------------------*/
    public static void checkOppQuoteNum(ClsWrappers.TriggerContext trgCtx){
        if(trgCtx.isInsert){
            map<id, list<Energy_Quote__c>> map_oppId_listQuotes = new map<id, list<Energy_Quote__c>>();
            map<id, Integer> map_oppid_quoteNum = new map<id, Integer>();
            for(Sobject sobj : trgCtx.newList) {
                Energy_Quote__c quote = (Energy_Quote__c)sobj;
                if(!map_oppId_listQuotes.containsKey(quote.Opportunity_Name__c)){
                    map_oppId_listQuotes.put(quote.Opportunity_Name__c, new list<Energy_Quote__c>());
                }
                map_oppId_listQuotes.get(quote.Opportunity_Name__c).add(quote);
            }
            if(map_oppId_listQuotes.keySet().size() > 0){
                for(AggregateResult result : [Select count(Id) quoteNum, Opportunity_Name__c 
                                              From Energy_Quote__c 
                                              Where Opportunity_Name__c in: map_oppId_listQuotes.keySet() 
                                              group by Opportunity_Name__c]){
                                                  map_oppid_quoteNum.put((Id)result.get('Opportunity_Name__c'),(Integer)result.get('quoteNum'));
                                              }
            }
            if(map_oppid_quoteNum.size() > 0){
                for(Id oppId : map_oppid_quoteNum.keySet()){
                    Integer i = 1;
                    for(Energy_Quote__c quoteItem : map_oppId_listQuotes.get(oppId)){
                        quoteItem.RevisionNum__c = map_oppid_quoteNum.get(oppId)+ i;
                        i++;
                    }
                }
                
                //Added by Buwen Guo 2017-11-30 from email:Issues 11/29 point 6
                //get the latest created Quote's Quote_Number__c for every opportunity.
                map<id, Energy_Quote__c> map_oppId_latestQuote = new map<id, Energy_Quote__c>();
                for(Energy_Quote__c eq : [Select id, Opportunity_Name__c,Quote_Number__c,LegacyQuoteNumber__c,
                									Quote_number_Without_revision_number__c
                                              From Energy_Quote__c 
                                              Where Opportunity_Name__c in: map_oppId_listQuotes.keySet() 
                                              order by createdDate asc]){
                	map_oppId_latestQuote.put(eq.Opportunity_Name__c,eq);
                }
                
                //if the system creates a second quote on the same opportunity then set the LegacyQuoteNumber__c to be the value of the existing quote's quote_number__c field
                for(Sobject sobj : trgCtx.newList) {
                	Energy_Quote__c quote = (Energy_Quote__c)sobj;
                	if(map_oppId_latestQuote.containsKey(quote.Opportunity_Name__c)){
                		//Modified by Buwen Guo 2017-12-14 from email:12/13 Issues point 4
                		//quote.LegacyQuoteNumber__c = map_oppId_latestQuote.get(quote.Opportunity_Name__c).Quote_Number__c;
                		quote.LegacyQuoteNumber__c = map_oppId_latestQuote.get(quote.Opportunity_Name__c).Quote_number_Without_revision_number__c;
                	}
	            }
            }else{
                if(map_oppId_listQuotes.size() > 0){
                    for(Id oppId : map_oppId_listQuotes.keySet()){
                        Integer i = 1;
                        for(Energy_Quote__c quoteItem : map_oppId_listQuotes.get(oppId)){
                            quoteItem.RevisionNum__c = i;
                            i++;
                        }
                    }
                }
            }
        
        	
        }
    }
    
    
    
    
}