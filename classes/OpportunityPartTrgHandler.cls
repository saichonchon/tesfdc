/*------------------------------------------------------------
Author:        Yiming Shen <yiming.shen@capgemini.com>
Description:   A handler class for Opportunity_Part__c triggers.
               The user story number is W-00018, W-00459.
Inputs:        
Test Class:    OpportunityPartTrgHandler_Test.cls
History
2017-08-09  Yiming Shen <yiming.shen@capgemini.com> Created
------------------------------------------------------------*/
public class OpportunityPartTrgHandler extends ClsTriggerVirtual{
    public static boolean isInUpdateOppyPartFraction = false;
    public static boolean isInUpdatePrice = false;
    public static boolean isInUpdateOppyMargin = false;    //added by yuan yao 2017-10-26
    public static boolean isInCheckIfUpdatedPastQuote = false;   //added by yuan yao 2017-10-26
    public static boolean isInUpdateOppyPartForecast = false;
    public static boolean isUpdatePartStatus = false;
    public static boolean isUpdateNotNeededPart = false;
    public static boolean isHasCalOppyStatus = false;
    public static map<Id, list<Opportunity_Part__c>> map_oppyId_partOfApprovedOppy = new map<Id, list<Opportunity_Part__c>>();
    
    public static boolean isMultipleBeforeInsert = false; //added by Tangyong Li 2017-12-28
    public static boolean isMultipleBeforeUpdate = false; //added by Tangyong Li 2017-12-28
    public static boolean isMultipleBeforeDelete = false; //added by Tangyong Li 2017-12-28
    public static boolean isMultipleAfterInsert = false; //added by Tangyong Li 2017-12-28
    public static boolean isMultipleAfterUpdate = false; //added by Tangyong Li 2017-12-28
    public static boolean isMultipleAfterDelete = false; //added by Tangyong Li 2017-12-28
    
    public static final map<String, Integer> map_MonthAbbr_MonthNumber = new map<String, Integer>{
        'Jan' => 4,
        'Feb' => 5,
        'Mar' => 6,
        'Apr' => 7,
        'May' => 8,
        'Jun' => 9,
        'Jul' => 10,
        'Aug' => 11,
        'Sep' => 12,
        'Oct' => 1,
        'Nov' => 2,
        'Dec' => 3
    };
    
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
    	System.debug('----partbeforeTriggerHandler----start.getCpuTime--------'+Limits.getCpuTime());
    	//added by Tangyong Li 2018-12-28
    	if(avoidOppyPartMultipleRunning(trgCtx)) return;
    	//end
    	
    	//added by Tangyong Li 2018-01-10
    	map<Id, Opportunity> map_oppyId_allOppys = new map<Id, Opportunity>();
    	map<Id, Opportunity_Part__c> map_oppyPartId_allOppyParts = new map<Id, Opportunity_Part__c>();
    	map_oppyId_allOppys.putAll(getOpportunitiesBaseupId(trgCtx));
    	map_oppyPartId_allOppyParts.putAll(getOpportunityPartsBaseupId(map_oppyId_allOppys));
        //system.debug('changePartNumberHasValueAction::beforeTrigger');

        /*
        List<Opportunity_part__c> oppParts = (List<Opportunity_part__c>)trgCtx.newList;
        for (Opportunity_part__c oppPart : oppParts) {
            System.debug('OPPPART.NDR_Item_Price_Currency__c ' + oppPart.NDR_Item_Price_Currency__c);
        }

*/
		//Added by Buwen Guo 2018-01-18
		//setGplForOppyParts(trgCtx);
		
		//Added by Tangyong Li 2018-05-04
		setOppyPartLostReason(trgCtx);
		
		//Added by Buwen Guo 2018-03-21
		syncQuantityToMOQ(trgCtx, map_oppyId_allOppys);
		
        //Added by Buwen Guo 2017-12-15
        updateStandardCost(trgCtx, map_oppyId_allOppys);
        
        //Added by Buwen Guo 2017-11-28 from email: Issues to fix 11/21 point 4
        resetTargetPrice(trgCtx);
        
        //Added by Buwen Guo 2017-12-14 from email: 12/13 Issues point 7
        updateQuantityToMOQ(trgCtx);

        //Added by Buwen Guo 2017-11-21 from email: Tweaks to the SAP integration on the Salesforce side point 2,3
        transCurrencyValueForOppyPart(trgCtx, map_oppyId_allOppys);

        
        assignLineItemMargin(trgCtx);
        setOppyPartTotalCostAndPrice(trgCtx);
        orderNewOppyPartItemNumber(trgCtx, map_oppyPartId_allOppyParts);
        //syncCustomPartNum(trgCtx);
        syncOppyPart(trgCtx, map_oppyId_allOppys);
        populateCustomerPartNumber(trgCtx, map_oppyId_allOppys);
        
        //Added by Buwen Guo 2017-10-20 from email: Change to Fixes Needed (#1) point 2
        //system.debug('changePartNumberHasValueAction::');
        
        changePartNumberHasValueAction(trgCtx);
        

        //Added by Tangyong Li 2017-12-03
        setOppyPartApprovalStatus(trgCtx, map_oppyPartId_allOppyParts);
        
        //Added by Buwen Guo 2017-12-08 from email: A lower priority item for now: SAP Quote Revision point 3
        //setChangedSinceQuoteIntegration(trgCtx);
        
        //Added by Buwen Guo 2018-03-27 from email: Cloning Opportunities: IR-03861 point 4
        resetIsClonedAfterCallout(trgCtx);
        System.debug('----partBeforeTriggerHandler----end.getCpuTime--------'+Limits.getCpuTime());
    }
    
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
    	System.debug('----partAfterTriggerHandler----start.getCpuTime--------'+Limits.getCpuTime());
    	//added by Tangyong Li 2018-12-28
    	if(avoidOppyPartMultipleRunning(trgCtx)) return;
    	//end
    	
    	//added by Tangyong Li 2018-01-10
    	map<Id, Opportunity> map_oppyId_allOppys = new map<Id, Opportunity>();
    	map<Id, Opportunity_Part__c> map_oppyPartId_allOppyParts = new map<Id, Opportunity_Part__c>();
    	map_oppyId_allOppys.putAll(getOpportunitiesBaseupId(trgCtx));
    	map_oppyPartId_allOppyParts.putAll(getOpportunityPartsBaseupId(map_oppyId_allOppys));
    	
        //system.debug('changePartNumberHasValueAction::afterTrigger');
        if(trgCtx.isBefore || isUpdateNotNeededPart) return;
        
        //Modified by Tangyong Li 2018-01-16
        //updateOppyMargin(trgCtx, map_oppyId_allOppys, map_oppyPartId_allOppyParts);
        map<Id, Opportunity> map_oppyId_oppys = updateOppyMargin(trgCtx, map_oppyId_allOppys, map_oppyPartId_allOppyParts);
        
        //Modified by Tangyong Li 2018-01-16
        //updateOppyPartFraction(trgCtx, map_oppyPartId_allOppyParts);
        System.debug('**** calling updateOppyPartFraction');
        //map<Id, Opportunity_Part__c> map_oppyPartId_oppyParts = updateOppyPartFraction(trgCtx, map_oppyPartId_allOppyParts);
        map<Id, Opportunity_Part__c> map_oppyPartId_oppyParts = new map<Id, Opportunity_Part__c>();
        updateOppyPartForecast(trgCtx, map_oppyPartId_allOppyParts);
        resetBookprice(trgCtx, map_oppyId_allOppys,map_oppyPartId_oppyParts);
        //checkIfUpdatedPastQuote(trgCtx);
        //Added by Buwen Guo 2017-10-19 Fixes Needed point 1
        //populatePartNameIfPartNumberChanged(trgCtx);
        
        //added by Tangyong Li 2017-12-15
        setNotNeededForOppyPartOfApprovedOppy(trgCtx, map_oppyPartId_oppyParts);
        //added by Tangyong Li 2017-12-03
        calcApprovalStatusForOppy(trgCtx, map_oppyId_allOppys, map_oppyPartId_allOppyParts, map_oppyId_oppys);
        System.debug('----partAfterTriggerHandler----end.getCpuTime--------'+Limits.getCpuTime());
    }
    
    /*------------------------------------------------------------
    Author:        Tangyong Li <tangyong.li@capgemini.com>
    Description:   Function to set oppy part Lost Reason.
    Returns:       
    History
    2018-05-04  Tangyong Li <tangyong.li@capgemini.com> created
    ------------------------------------------------------------*/
    public static void setOppyPartLostReason(ClsWrappers.TriggerContext trgCtx) {
    	set<Id> set_oppyIds = new set<Id>();
    	if(trgCtx.isInsert || trgCtx.isUpdate) {
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                if(oppyPart.Status__c == 'Lost' && oppyPart.Lost_Reason__c == null) {
                	oppyPart.Lost_Reason__c = 'Rejected Reason';
                }
            }
        }
    }
    
    /*------------------------------------------------------------
    Author:        Tangyong Li <tangyong.li@capgemini.com>
    Description:   Function to set oppy part ApprovalStatus.
    Inputs:        trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2017-12-03  Tangyong Li <tangyong.li@capgemini.com> created
    ------------------------------------------------------------*/
    public static void setOppyPartApprovalStatus(ClsWrappers.TriggerContext trgCtx, map<Id, Opportunity_Part__c> map_oppyPartId_allOppyParts) {
    	if(trgCtx.isAfter) return;
        set<Id> set_oppyIds = new set<Id>();
        if(trgCtx.isInsert|| trgCtx.isUpdate) {
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                set_oppyIds.add(oppyPart.Opportunity__c);
            }
        }
        map_oppyId_partOfApprovedOppy = new map<Id, list<Opportunity_Part__c>>();
        /*for(Opportunity_Part__c oppyPart : [SELECT Id, Opportunity__c, Approval_Status__c, 
        									Opportunity__r.Approval_Status__c 
        									FROM Opportunity_Part__c 
        									WHERE Opportunity__c IN: set_oppyIds 
        									AND Opportunity__r.Approval_Status__c = 'Approved']) {
            if(!map_oppyId_partOfApprovedOppy.containsKey(oppyPart.Opportunity__c)) {
                map_oppyId_partOfApprovedOppy.put(oppyPart.Opportunity__c, new list<Opportunity_Part__c>());
            }
            map_oppyId_partOfApprovedOppy.get(oppyPart.Opportunity__c).add(oppyPart);
        }*/
        for(Opportunity_Part__c oppyPart : map_oppyPartId_allOppyParts.values()) {
        	if(set_oppyIds.contains(oppyPart.Opportunity__c)
        	&& oppyPart.Opportunity__r.Approval_Status__c == 'Approved'){
	            if(!map_oppyId_partOfApprovedOppy.containsKey(oppyPart.Opportunity__c)) {
	                map_oppyId_partOfApprovedOppy.put(oppyPart.Opportunity__c, new list<Opportunity_Part__c>());
	            }
	            map_oppyId_partOfApprovedOppy.get(oppyPart.Opportunity__c).add(oppyPart);
        	}
        }
        //system.debug('oppyPart::::  ' + map_oppyId_partOfApprovedOppy.size());
        if(trgCtx.isInsert) {
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                /*if(map_oppyId_partOfApprovedOppy.containsKey(oppyPart.Opportunity__c) && oppyPart.Energy_Quote_Line_Item__c != null) {
                    oppyPart.Approval_Status__c = 'Not Needed';
                } else*/ if(oppyPart.Sales_Price__c == 0 || oppyPart.Sales_Price__c == null) {
                    oppyPart.Approval_Status__c = 'Needed';
                }
            }
        } else if(trgCtx.isUpdate && !isUpdatePartStatus) {
            for(Sobject sobj : trgCtx.newList) {
                isUpdatePartStatus = true;
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                Opportunity_Part__c oldOppyPart = (Opportunity_Part__c)trgCtx.oldMap.get(oppyPart.Id);
                decimal salesPrice;
                decimal oldSalesPrice;
                decimal offeredPrice;
                decimal oldOfferedPrice;
                decimal qty;
                decimal oldQty;
                if(oppyPart.Sales_Price__c != null) salesPrice = oppyPart.Sales_Price__c.setScale(2);
                if(oldOppyPart.Sales_Price__c != null) oldSalesPrice = oldOppyPart.Sales_Price__c.setScale(2);
                if(oppyPart.Offered_Price__c != null) offeredPrice = oppyPart.Offered_Price__c.setScale(2);
                if(oldOppyPart.Offered_Price__c != null) oldOfferedPrice = oldOppyPart.Offered_Price__c.setScale(2);
                if(oppyPart.Quantity__c != null) qty = oppyPart.Quantity__c.setScale(2);
                if(oldOppyPart.Quantity__c != null) oldQty = oldOppyPart.Quantity__c.setScale(2);
                
                if(salesPrice != oldSalesPrice || offeredPrice != oldOfferedPrice || 
                    qty != oldQty || oppyPart.Energy_Quote_Line_Item__c != oldOppyPart.Energy_Quote_Line_Item__c) {
                    if((salesPrice != 0.00 && salesPrice != null && salesPrice == offeredPrice) || oppyPart.Energy_Quote_Line_Item__c != null) {
                        oppyPart.Approval_Status__c = 'Not Needed';
                        
                    //modified by Tangyong Li 2017-12-18 Email: Fwd: Approval Status.  Fixes required.
                    //} else if((oppyPart.Approval_Status__c != 'Approved' && (salesPrice == 0.00 || salesPrice == null)) || 
                    //    (oppyPart.Approval_Status__c == 'Approved' && (salesPrice != oldSalesPrice || 
                    //    qty != oldQty || offeredPrice != oldOfferedPrice))) {
                    } else if((oppyPart.Approval_Status__c != 'Approved' && (salesPrice == 0.00 || salesPrice == null)) || 
                        (salesPrice != oldSalesPrice || qty != oldQty || offeredPrice != oldOfferedPrice)) {
                        oppyPart.Approval_Status__c = 'Needed';
                    } else {
                        oppyPart.Approval_Status__c = 'Approved';
                    }
                }
            }
        }
        
        //system.debug('setChangedSinceQuoteIntegration::');
        if(trgCtx.isInsert){
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                oppyPart.Changed_since_quote_integration__c = true;
            }
        }
        //IsInsert End.
        if(trgCtx.isUpdate){
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                Opportunity_Part__c oldOppyPart = (Opportunity_Part__c)trgCtx.oldMap.get(oppyPart.Id);
                if(oppyPart.Quantity__c != oldOppyPart.Quantity__c || oppyPart.Offered_Price__c != oldOppyPart.Offered_Price__c ){
                    oppyPart.Changed_since_quote_integration__c = true;
                    //system.debug('setChangedSinceQuoteIntegration::oppyPart.Changed_since_quote_integration__c'+oppyPart.Changed_since_quote_integration__c);
                }
            }
        }
        //IsUpdate End.
    }
    
    
    /*------------------------------------------------------------
    Author:        Buwen Guo <buwen.guo@capgemini.com> 
    Description:   if a part qty is requested that is less than the MOQ then the qty is raised up to the MOQ value
    Inputs:        trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2018-03-21     Buwen Guo <buwen.guo@capgemini.com> Created
    ------------------------------------------------------------*/
    public static void syncQuantityToMOQ(ClsWrappers.TriggerContext trgCtx,map<Id, Opportunity> map_oppyId_allOppys){
    	if(trgCtx.isUpdate || trgCtx.isInsert || trgCtx.isUndelete){
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                if(map_oppyId_allOppys.containsKey(oppyPart.opportunity__c) 
                	&& map_oppyId_allOppys.get(oppyPart.opportunity__c) != null 
                	&& map_oppyId_allOppys.get(oppyPart.opportunity__c).ERP_For_Pricing__c != 'SAP (except ANZPAC)'
                	&& oppyPart.Min_Order_Qty__c != null && oppyPart.Quantity__c != null && oppyPart.Quantity__c < oppyPart.Min_Order_Qty__c ){
                	oppyPart.Quantity__c = oppyPart.Min_Order_Qty__c;
                }
            }
        }
    }
    
    /*------------------------------------------------------------
    Author:        Yuan Yao <yuan.yao@capgemini.com>
    Description:   Function to check if updated past quote.
    Inputs:        trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2017-10-10  Yuan Yao <yuan.yao@capgemini.com> Created
    ------------------------------------------------------------*/
    public static void checkIfUpdatedPastQuote(ClsWrappers.TriggerContext trgCtx) {
        if(trgCtx.isDelete || trgCtx.isInsert || trgCtx.isUndelete){
            isInCheckIfUpdatedPastQuote = true;
        }else if(trgCtx.isUpdate){
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                Opportunity_Part__c oldOppyPart = (Opportunity_Part__c)trgCtx.oldMap.get(oppyPart.Id);
                if(oppyPart.Energy_Quote_Line_Item__c != null && oppyPart.Energy_Quote_Line_Item__c != oldOppyPart.Energy_Quote_Line_Item__c){
                    isInCheckIfUpdatedPastQuote = true;
                    break;
                }
            }
        }
        //System.debug('isInCheckIfUpdatedPastQuote+++' + isInCheckIfUpdatedPastQuote);
    }
    
    /*------------------------------------------------------------
    Author:        Tangyong Li <tangyong.li@capgemini.com>
    Description:   After this Opportunity was approved I added one extra part.  All the existing parts should say NOT NEEDED
    Inputs:        trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2017-12-15  Tangyong Li <tangyong.li@capgemini.com> created
    ------------------------------------------------------------*/
    public static void setNotNeededForOppyPartOfApprovedOppy(ClsWrappers.TriggerContext trgCtx, map<Id, Opportunity_Part__c> map_oppyPartId_oppyParts) {
        list<Opportunity_Part__c> list_updateParts = new list<Opportunity_Part__c>();
        set<Id> set_oppyIds = new set<Id>();
        if(map_oppyPartId_oppyParts == null) map_oppyPartId_oppyParts = new map<Id, Opportunity_Part__c>(); 
        if(trgCtx.isInsert) {
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                if(oppyPart.Energy_Quote_Line_Item__c != null && map_oppyId_partOfApprovedOppy.containsKey(oppyPart.Opportunity__c) && !set_oppyIds.contains(oppyPart.Opportunity__c)) {
                    set_oppyIds.add(oppyPart.Opportunity__c);
                }
            }
        }
        if(trgCtx.isDelete || trgCtx.isInsert || trgCtx.isUndelete){
            isInCheckIfUpdatedPastQuote = true;
        }else if(trgCtx.isUpdate){
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                Opportunity_Part__c oldOppyPart = (Opportunity_Part__c)trgCtx.oldMap.get(oppyPart.Id);
                if(oppyPart.Energy_Quote_Line_Item__c != null && oppyPart.Energy_Quote_Line_Item__c != oldOppyPart.Energy_Quote_Line_Item__c){
                    isInCheckIfUpdatedPastQuote = true;
                    break;
                }
            }
        }
        for(Id oppyId : set_oppyIds) {
            for(Opportunity_Part__c part : map_oppyId_partOfApprovedOppy.get(oppyId)) {
            	Opportunity_Part__c oppPart;
            	if(map_oppyPartId_oppyParts.containsKey(part.Id)) {
            		oppPart = map_oppyPartId_oppyParts.get(part.Id);
            	} else {
            		oppPart = part;
            		map_oppyPartId_oppyParts.put(oppPart.Id, oppPart);
            	}
                if(oppPart.Approval_Status__c != 'Not Needed') {
                    oppPart.Approval_Status__c = 'Not Needed';
                    list_updateParts.add(part);
                }
            }
        }
        //if(list_updateParts.size() > 0) {
        system.debug('map_oppyPartId_oppyParts::'+map_oppyPartId_oppyParts);
        if(!map_oppyPartId_oppyParts.isEmpty()) {
            isUpdateNotNeededPart = true;
            update map_oppyPartId_oppyParts.values();
            isUpdateNotNeededPart = false;
        }
    }
    
    /*------------------------------------------------------------
    Author:        Tangyong Li <tangyong.li@capgemini.com>
    Description:   Function to set oppy ApprovalStatus.
    Inputs:        trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2017-12-03  Tangyong Li <tangyong.li@capgemini.com> created
    ------------------------------------------------------------*/
    public static void calcApprovalStatusForOppy(ClsWrappers.TriggerContext trgCtx, map<Id, Opportunity> map_oppyId_allOppys, map<Id, Opportunity_Part__c> map_oppyPartId_allOppyParts, map<Id, Opportunity> map_oppyId_oppys) {
        Boolean isSkipCalApprovalStatus = (isHasCalOppyStatus || ExtCreateQuoteForOppy.isFromCreateQuote || isUpdateNotNeededPart || OpportunityTrgHandler.isUpdateOppyApprovalStatus || EnergyQuoteTrgHandler.isFromQuoteRecreateParts);
        //system.debug('isSkipCalApprovalStatus:::::  ' + isSkipCalApprovalStatus);
        if(isSkipCalApprovalStatus) {
        	//system.debug('map_oppyId_oppys:::   ' + map_oppyId_oppys);
        	if(!map_oppyId_oppys.isEmpty()) {
                isHasCalOppyStatus = true;
                update map_oppyId_oppys.values();
            }
            return;
        } 
        //system.debug('cal status::::22 ');
        set<Id> set_oppyIds = new set<Id>();
        set<Id> set_processOppyIds = new set<Id>();
        map<Id, Boolean> map_oppyId_requiredApproved = new map<Id, Boolean>();
        list<Opportunity> list_updateOppy = new list<Opportunity>();
        if(map_oppyId_oppys==null) map_oppyId_oppys = new map<Id, Opportunity>();
        if(trgCtx.isDelete) {
            for(Sobject sobj : trgCtx.oldList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                if(!OpportunityTrgHandler.map_oppyId_isSkipCalOppyApprovalStatus.containsKey(oppyPart.Opportunity__c)) {
	                set_oppyIds.add(oppyPart.Opportunity__c);
                }
            }
        } else {
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                if(!OpportunityTrgHandler.map_oppyId_isSkipCalOppyApprovalStatus.containsKey(oppyPart.Opportunity__c)) {
	                set_oppyIds.add(oppyPart.Opportunity__c);
                }
            }
        }
        for(Opportunity_Part__c oppyPart : map_oppyPartId_allOppyParts.values()) {
        	if(set_oppyIds.contains(oppyPart.Opportunity__c)){
	            if(!map_oppyId_requiredApproved.containsKey(oppyPart.Opportunity__c)) {
             	   map_oppyId_requiredApproved.put(oppyPart.Opportunity__c, false);
	            }
	            if(oppyPart.Approval_Status__c == 'Needed') {
	                map_oppyId_requiredApproved.put(oppyPart.Opportunity__c, true);
	            }
        	}
        }
        //system.debug('map_oppyId_requiredApproved ::::   ' + map_oppyId_requiredApproved);
        
        //modified by Tangyong Li 2018-01-10
        //for(Opportunity oppy : [SELECT Id, Approval_Status__c FROM Opportunity WHERE Id IN: map_oppyId_requiredApproved.keySet()]) {
        for(Opportunity oppy : map_oppyId_allOppys.values()) {
    		Opportunity oppyToUpdate;
    		if(map_oppyId_oppys.containsKey(oppy.Id)) {
    			oppyToUpdate = map_oppyId_oppys.get(oppy.Id);
    		} else {
    			oppyToUpdate = oppy;
    		}
        	if(map_oppyId_requiredApproved.containsKey(oppy.Id)){
        		//Modified by Tangyong Li 2018-03-23 for email DOA for SAP
        		//if(!(oppy.ERP_For_Pricing__c == 'SAP (except ANZPAC)' && oppy.SAP_Quote_Type__c == 'Small Quote')) {
		            //system.debug('oppy approval status:::  ' + map_oppyId_requiredApproved);
		            //system.debug('oppy approval status:::a  ' + oppy.Approval_Status__c);
		            if(map_oppyId_requiredApproved.get(oppyToUpdate.Id) == true) {
		                if(oppyToUpdate.Approval_Status__c != 'Approval Required') {
		                    oppyToUpdate.Approval_Status__c = 'Approval Required';
		                    list_updateOppy.add(oppyToUpdate);
		                    if(!map_oppyId_oppys.containsKey(oppyToUpdate.Id)) map_oppyId_oppys.put(oppyToUpdate.Id, oppyToUpdate);
		                }
		            } else if(oppyToUpdate.Approval_Status__c == 'Awaiting Approval' || oppyToUpdate.Approval_Status__c == 'Approval Required') {
		                //system.debug('oppy status null::::111  ');
		                oppyToUpdate.Approval_Status__c = 'Approval Not Needed';
		                list_updateOppy.add(oppyToUpdate);
		                set_processOppyIds.add(oppyToUpdate.Id);
		                if(!map_oppyId_oppys.containsKey(oppyToUpdate.Id)) map_oppyId_oppys.put(oppyToUpdate.Id, oppyToUpdate);
		            }
	        	//} else {
	        		//Opportunity oppyToUpdate;
	        		//if(map_oppyId_oppys.containsKey(oppy.Id)) {
	        		//	oppyToUpdate = map_oppyId_oppys.get(oppy.Id);
	        		//} else {
	        		//	oppyToUpdate = oppy;
	        		//}
	        		//Modified by Tangyong Li 2018-03-23 for email DOA for SAP
	        		//if(oppyToUpdate.Approval_Status__c != 'Approval Not Needed') {
	        		//	oppyToUpdate.Approval_Status__c = 'Approval Not Needed';
	                //    if(!map_oppyId_oppys.containsKey(oppyToUpdate.Id)) map_oppyId_oppys.put(oppyToUpdate.Id, oppyToUpdate);
	        		//}
	        	//}
        	} else if(!OpportunityTrgHandler.map_oppyId_isSkipCalOppyApprovalStatus.containsKey(oppyToUpdate.Id)){ //all the related oppyParts of the oppy hava been deletd
        		if(oppyToUpdate.Approval_Status__c != 'Approval Not Needed') {
                    oppyToUpdate.Approval_Status__c = 'Approval Not Needed';
                    list_updateOppy.add(oppyToUpdate);
                    if(!map_oppyId_oppys.containsKey(oppyToUpdate.Id)) map_oppyId_oppys.put(oppyToUpdate.Id, oppyToUpdate);
                }
        	}
        }
        try{
            if(set_processOppyIds.size() > 0) {
                Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest();
                for(ProcessInstanceWorkitem workItem : [SELECT Id FROM ProcessInstanceWorkitem 
                                                        WHERE ProcessInstance.TargetObjectId IN: set_processOppyIds 
                                                        AND ProcessInstance.Status = 'Pending']) {
                    pwr.setAction('Removed');
                    pwr.setWorkItemId(workItem.id);
                    Approval.ProcessResult result = Approval.process(pwr);
                }
            }
            //if(list_updateOppy.size() > 0) {
            if(!map_oppyId_oppys.isEmpty()) {
                isHasCalOppyStatus = true;
                //system.debug('map_oppyId_oppys::::  ' + map_oppyId_oppys);
                update map_oppyId_oppys.values();
            }
        }catch(Exception e){
            ErrorLogging.Log(e);
            String vStrError = 'Error Type = ' + e.getTypeName() + ' Error Line = ' + e.getLineNumber() + '' + ' Error Stack = ' + e.getStackTraceString() + ' Error Message = ' + e.getMessage();
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc, SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '', e.getStackTraceString());
        }
    }
    
    /*------------------------------------------------------------
    Author:        Tangyong Li<tangyong.li@capgemini.com>
    Description:   Function to set Total_Cost__c and Total_price__c on Opportunity_Part__c.
    Inputs:        trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2017-10-10   Tangyong Li<tangyong.li@capgemini.com> Created
    ------------------------------------------------------------*/
    public static void setOppyPartTotalCostAndPrice(ClsWrappers.TriggerContext trgCtx) {
        if(trgCtx.isDelete) return;
        //system.debug('setOppyPartTotalCostAndPrice::');
        for(Sobject sobj : trgCtx.newList) {
            Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
            
            if(oppyPart.Standard_Cost__c != null && oppyPart.Quantity__c != null) {
                oppyPart.Total_Cost__c = oppyPart.Standard_Cost__c * oppyPart.Quantity__c;
            }
            /*
            if(oppyPart.Offered_Price__c != null && oppyPart.Quantity__c != null) {
                oppyPart.Total_Price__c = oppyPart.Offered_Price__c * oppyPart.Quantity__c;
            }*/
            //system.debug('---oppyPart.Standard_Cost__c::'+oppyPart.Standard_Cost__c);
            //system.debug('---oppyPart.Quantity__c::'+oppyPart.Quantity__c);
            //system.debug('---oppyPart.Total_Cost__c::'+oppyPart.Total_Cost__c);
            //system.debug('---oppyPart.Offered_Price__c::'+oppyPart.Offered_Price__c);
            //system.debug('---oppyPart.Total_Price__c::'+oppyPart.Total_Price__c);
            //system.debug('---oppyPart.Sales_Price__c::'+oppyPart.Sales_Price__c);
        }
    }
    
    /*------------------------------------------------------------
    Author:        Yiming Shen <yiming.shen@capgemini.com>
    Description:   Function to everytime you add a part you should give it the next item number and add it to the list of existing OppParts..
    Inputs:        trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2017-10-10   Yiming Shen <yiming.shen@capgemini.com> Created
    ------------------------------------------------------------*/
    public static void orderNewOppyPartItemNumber(ClsWrappers.TriggerContext trgCtx, map<Id, Opportunity_Part__c> map_oppyPartId_allOppyParts){
        Map<Id,List<Opportunity_Part__c>> map_OppyId_NewOppyPartsList = new Map<Id,List<Opportunity_Part__c>>();
        Map<Id,List<Integer>> map_OppyId_ItemNumbersList = new Map<Id,List<Integer>>();
        Set<Id> set_OppyIds = new Set<Id>();
        if(trgCtx.isInsert){
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                if(oppyPart.Opportunity__c != null){
                    if(!map_OppyId_NewOppyPartsList.containsKey(oppyPart.Opportunity__c)){
                        map_OppyId_NewOppyPartsList.put(oppyPart.Opportunity__c, new List<Opportunity_Part__c>());
                    }
                    if(!map_OppyId_ItemNumbersList.containsKey(oppyPart.Opportunity__c)){
                        map_OppyId_ItemNumbersList.put(oppyPart.Opportunity__c, new List<Integer>());
                    }
                    map_OppyId_NewOppyPartsList.get(oppyPart.Opportunity__c).add(oppyPart);
                    set_OppyIds.add(oppyPart.Opportunity__c);
                }
            }
        }else if(trgCtx.isUpdate){
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                Opportunity_Part__c oldOppyPart = (Opportunity_Part__c)trgCtx.oldMap.get(oppyPart.Id);
                if(String.isNotBlank(oldOppyPart.NDR_Item_Number__c)
                && oldOppyPart.NDR_Item_Number__c != oppyPart.NDR_Item_Number__c){
                    oppyPart.addError('Item number must be set and must not change after it is set.');
                }
            }
        }
        
        if(map_OppyId_NewOppyPartsList.size() > 0){
            /*for(Opportunity_Part__c existingOppyPart : [SELECT NDR_Item_Number__c,Opportunity__c
                                                        FROM Opportunity_Part__c 
                                                        WHERE Opportunity__c IN: map_OppyId_ItemNumbersList.keySet()]){
                if(String.isNotBlank(existingOppyPart.NDR_Item_Number__c)){
                    map_OppyId_ItemNumbersList.get(existingOppyPart.Opportunity__c).add(Integer.valueOf(existingOppyPart.NDR_Item_Number__c));
                }
            }*/
            for(Opportunity_Part__c existingOppyPart : map_oppyPartId_allOppyParts.values()){
                if(map_OppyId_ItemNumbersList.keySet().contains(existingOppyPart.Opportunity__c)
                && String.isNotBlank(existingOppyPart.NDR_Item_Number__c)){
                    map_OppyId_ItemNumbersList.get(existingOppyPart.Opportunity__c).add(Integer.valueOf(existingOppyPart.NDR_Item_Number__c));
                }
            }
            for(Id oppyId : map_OppyId_NewOppyPartsList.keySet()){
                Integer currentMaxItemNumber = getMaxNumber(map_OppyId_ItemNumbersList.get(oppyId));
                if(currentMaxItemNumber == null){
                    currentMaxItemNumber = 0;
                }
                for(Opportunity_Part__c oppyPart : map_OppyId_NewOppyPartsList.get(oppyId)){
                    if(oppyPart.NDR_Item_Number__c == null) {
                        oppyPart.NDR_Item_Number__c = String.valueOf(++currentMaxItemNumber);
                        oppyPart.Seq_No__c = Decimal.valueOf(oppyPart.NDR_Item_Number__c);
                        //system.debug('NDR_Item_Number__c:::: ' + oppyPart.NDR_Item_Number__c);
                        //system.debug('Seq_No__c:::: ' + oppyPart.Seq_No__c);
                    }
                }
            }
        }
    }
    
    /*
    public static void syncCustomPartNum(ClsWrappers.TriggerContext trgCtx) {
        if(trgCtx.isDelete) return;
        try {
            list<String> partNum=new list<String>();
            list<String> AnzCustNums=new list<String>();
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                partNum.add(oppyPart.Part_Number__c);
                AnzCustNums.add(oppyPart.ANZ_Customer_Number__c);
            }
            list<Customer_Part_Number__c> cusPartNumber=[select id,Account__c,Part_Number__c,Customer_Number__c from Customer_Part_Number__c where (Customer_Number__c IN: AnzCustNums and Part_Number__c IN: partNum)];
            boolean flag=true;         
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                for(Customer_Part_Number__c cp : cusPartNumber) {
                    if(oppyPart.ANZ_Customer_Number__c !=null) {
                        if(oppyPart.Part_Number__c != NULL && oppyPart.ANZ_Customer_Number__c != NULL){
                            if(oppyPart.Part_Number__c.equalsignorecase(cp.Part_Number__c) && oppyPart.ANZ_Customer_Number__c.equalsignorecase(cp.Customer_Number__c  )) {
                                flag=false; 
                                oppyPart.Customer_Part_Number1__c = cp.id;
                            }
                        }
                    } 
                }
                if(flag==true) {
                    oppyPart.Customer_Part_Number1__c = null;
                }
            }
        } Catch (Exception e) {
            throw e;
            ErrorLogging.Log(e);
        }
    }*/
    
    /*------------------------------------------------------------
    Author:        Tangyong Li<tangyong.li@capgemini.com>
    Description:   Function to set synchronize fields of part to oppypart for ampics.
    Inputs:        trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2017-10-10   Tangyong Li<tangyong.li@capgemini.com> Created
    ------------------------------------------------------------*/
    public static void syncOppyPart(ClsWrappers.TriggerContext trgCtx, map<Id, Opportunity> map_oppyId_allOppys) {
        set<String> set_oppyIds = new set<String>();
        set<String> set_partIds = new set<String>();
        map<String, Opportunity> map_oppyId_oppy = new map<String, Opportunity>();
        map<String, Part__c> map_partId_part = new map<String, Part__c>();
        if(trgCtx.isInsert) {
            User currUser = [select Id, MED_Region__c from User where Id =: UserInfo.getUserId()];
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                set_oppyIds.add(oppyPart.Opportunity__c);
                set_partIds.add(oppyPart.Part__c);
            }
            
            //modified by Tangyong Li 2018-01-10
            //for(Opportunity oppy : [SELECT Id, Account.Source_System__c, Account.Recordtype.Name, ERP_For_Pricing__c FROM Opportunity WHERE Id IN: set_oppyIds]) {
            for(Opportunity oppy : map_oppyId_allOppys.values()) {
            	if(set_oppyIds.contains(oppy.Id)) {
	                map_oppyId_oppy.put(oppy.Id, oppy);
            	}
            }
            for(Part__c part : [SELECT Id, Part_Number__c, Cost_Set_75__c, Lead_Time_Days__c, Min_Order_Qty__c, Pieces_in_Pack__c, 
                                    Primary_Pack_Qty__c, Drawing_Number__c, Drawing_Revision_Number__c, Stock_UOM__c 
                                FROM Part__c WHERE Id IN: set_partIds]) {
                map_partId_part.put(part.Id, part);
            }
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                if(getAmpics(map_oppyId_oppy.get(oppyPart.Opportunity__c), currUser)
                && map_partId_part.get(oppyPart.Part__c) != null) {
                    //system.debug('before1111::::: ' + oppyPart);
                    oppyPart.Part_Number__c = map_partId_part.get(oppyPart.Part__c).Part_Number__c;
                    oppyPart.Cost_Set_75__c = map_partId_part.get(oppyPart.Part__c).Cost_Set_75__c;
                    //oppyPart.LT_Days__c = map_partId_part.get(oppyPart.Part__c).Lead_Time_Days__c;
                    oppyPart.Lead_Time__c = map_partId_part.get(oppyPart.Part__c).Lead_Time_Days__c;
                    oppyPart.Min_Order_Qty__c = map_partId_part.get(oppyPart.Part__c).Min_Order_Qty__c;
                    oppyPart.Pieces_in_Pack__c = map_partId_part.get(oppyPart.Part__c).Pieces_in_Pack__c;
                    oppyPart.Primary_Pack_Quantity__c = map_partId_part.get(oppyPart.Part__c).Primary_Pack_Qty__c;
                    oppyPart.Drawing_Number__c = map_partId_part.get(oppyPart.Part__c).Drawing_Number__c;
                    oppyPart.Drawing_Revision_Number__c = map_partId_part.get(oppyPart.Part__c).Drawing_Revision_Number__c;
                    oppyPart.Stock_UOM__c = map_partId_part.get(oppyPart.Part__c).Stock_UOM__c;
                    //system.debug('before2222::::: ' + oppyPart);
                }
            }
            //system.debug('before3333::::: ' + trgCtx.newList);
        }
    }
    
    /*------------------------------------------------------------
    Author:        Tangyong Li<tangyong.li@capgemini.com>
    Description:   Function to get ampics according ERP_for_Pricing__c on Opportunity.
    Inputs:        oppy - Opportunity, currUser - User
    Returns:       
    History
    2017-10-10   Tangyong Li<tangyong.li@capgemini.com> Created
    ------------------------------------------------------------*/
    public static Boolean getAmpics(Opportunity oppy, User currUser) {
        Boolean isAmpics = false;
        if(oppy.ERP_for_Pricing__c == 'ANZPAC' || (oppy.Account.Recordtype.Name == 'Prospect' && currUser.MED_Region__c == 'Aus / New Zlnd')) {
            isAmpics = true;
        }
        return isAmpics;
    }
    
    /*------------------------------------------------------------
    Author:        Yiming Shen <yiming.shen@capgemini.com>
    Description:   Function to get all Opportunity_Part__c for caculating margin__c on Opportunity_Part__c object.
    Inputs:        trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2017-10-13 Yiming Shen <yiming.shen@capgemini.com> Created
    ------------------------------------------------------------*/
    private static void assignLineItemMargin(ClsWrappers.TriggerContext trgCtx){
        if(trgCtx.isAfter) return;
        List<Opportunity_Part__c> list_OppyParts = new List<Opportunity_Part__c>();
        if(trgCtx.isInsert || trgCtx.isUndelete){
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                list_OppyParts.add(oppyPart);
            }
        }else if(trgCtx.isUpdate){
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                Opportunity_Part__c oldOppyPart = (Opportunity_Part__c)trgCtx.oldMap.get(oppyPart.Id);
                if(oppyPart.Standard_Cost__c != oldOppyPart.Standard_Cost__c
                || oppyPart.Offered_Price__c != oldOppyPart.Offered_Price__c
                || oppyPart.Quantity__c != oldOppyPart.Quantity__c){
                    list_OppyParts.add(oppyPart);
                }
            }
        }
        
        if(list_OppyParts.size() > 0){
            for(Opportunity_Part__c oppyPart : list_OppyParts){
                if(oppyPart.Standard_Cost__c != null && oppyPart.Offered_Price__c != null 
                && oppyPart.Quantity__c != null 
                && (oppyPart.Offered_Price__c * oppyPart.Quantity__c) != 0){
                    oppyPart.Line_Item_Margin__c = (((oppyPart.Offered_Price__c * oppyPart.Quantity__c) - (oppyPart.Standard_Cost__c * oppyPart.Quantity__c))/(oppyPart.Offered_Price__c * oppyPart.Quantity__c))*100;
                }
            }
        }
    }
    
    /*------------------------------------------------------------
    Author:        Yiming Shen <yiming.shen@capgemini.com>
    Description:   Function to get all Opportunity_Part__c for caculating margin__c on Opportunity object.
    Inputs:        trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2017-09-26  Yiming Shen <yiming.shen@capgemini.com> Created
    ------------------------------------------------------------*/
    private static map<Id, Opportunity> updateOppyMargin(ClsWrappers.TriggerContext trgCtx, map<Id, Opportunity> map_oppyId_allOppys, map<Id, Opportunity_Part__c> map_oppyPartId_allOppyParts){
        if(trgCtx.isBefore || isInUpdateOppyMargin) return null;
        //List<Opportunity> list_Opportunitys2Update = new List<Opportunity>();
        Map<Id,List<Opportunity_Part__c>> map_OppyId_ListOppyParts;
        Map<Id,Opportunity> map_OppyId_Oppy = new Map<Id,Opportunity>();
        Map<Id,decimal> map_OppyId_OppyMargin = new Map<Id,decimal>();
        Map<Id,decimal> map_OppyId_SumOfStandardCost = new Map<Id,decimal>();
        Map<Id,decimal> map_OppyId_SumOfTargetPrice = new Map<Id,decimal>();
        Set<Id> set_OppyIds = new Set<Id>();
        map<Id, Opportunity> map_oppyId_oppys = new map<Id, Opportunity>();//added by Tangyong Li 2019-01-16
        
        map<Id, decimal> map_oppId_totalValue = new map<Id, decimal>(); //update oppy total value, added by Tangyong Li 2017-10-11
        
        if(trgCtx.isInsert || trgCtx.isUndelete){
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                set_OppyIds.add(oppyPart.Opportunity__c);
            }
        }else if(trgCtx.isUpdate){
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                Opportunity_Part__c oldOppyPart = (Opportunity_Part__c)trgCtx.oldMap.get(oppyPart.Id);
                if(oppyPart.Standard_Cost__c != oldOppyPart.Standard_Cost__c
                || oppyPart.Offered_Price__c != oldOppyPart.Offered_Price__c
                || oppyPart.Quantity__c != oldOppyPart.Quantity__c){
                    set_OppyIds.add(oppyPart.Opportunity__c);
                }
            }
        }else if(trgCtx.isDelete){
            for(Sobject sobj : trgCtx.oldList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                set_OppyIds.add(oppyPart.Opportunity__c);
            }
        }
        
        if(set_OppyIds.size() > 0){
        	//modified by Tangyong Li 2018-01-10
            //for(Opportunity oppy : [SELECT Margin__c, ERP_For_Pricing__c FROM Opportunity WHERE Id IN: set_OppyIds]){
            for(Opportunity oppy : map_oppyId_allOppys.values()){
            	if(set_OppyIds.contains(oppy.Id)) {
	                //oppy.Margin__c = null;
	                map_OppyId_Oppy.put(oppy.Id, oppy);
            	}
            }
            
            /*for(Opportunity_Part__c oppyPart : [SELECT Opportunity__c, Standard_Cost__c, Offered_Price__c, Quantity__c, Total_Price__c  
                                                FROM Opportunity_Part__c 
                                                WHERE Opportunity__c IN: set_OppyIds]){*/
              for(Opportunity_Part__c oppyPart : map_oppyPartId_allOppyParts.values()){
              	if(!set_OppyIds.contains(oppyPart.Opportunity__c)) continue;
                decimal itemStandardCost = 0;
                decimal itemTargetPrice = 0;
                decimal itemTotalPrice = 0; //update oppy total value, added by Tangyong Li 2017-10-11
                
                if(!map_OppyId_SumOfStandardCost.containsKey(oppyPart.Opportunity__c)){
                    map_OppyId_SumOfStandardCost.put(oppyPart.Opportunity__c, 0);
                }
                if(!map_OppyId_SumOfTargetPrice.containsKey(oppyPart.Opportunity__c)){
                    map_OppyId_SumOfTargetPrice.put(oppyPart.Opportunity__c, 0);
                }
                
                //update oppy total value, added by Tangyong Li 2017-10-11
                if(!map_oppId_totalValue.containsKey(oppyPart.Opportunity__c)){
                    map_oppId_totalValue.put(oppyPart.Opportunity__c, 0);
                }
                if(oppyPart.Total_Price__c != null){
                    itemTotalPrice = map_oppId_totalValue.get(oppyPart.Opportunity__c) + oppyPart.Total_Price__c;
                    map_oppId_totalValue.put(oppyPart.Opportunity__c, itemTotalPrice);
                }
                //added end
                
                if(oppyPart.Standard_Cost__c != null){
                    itemStandardCost = map_OppyId_SumOfStandardCost.get(oppyPart.Opportunity__c) + oppyPart.Quantity__c * oppyPart.Standard_Cost__c;
                    map_OppyId_SumOfStandardCost.put(oppyPart.Opportunity__c, itemStandardCost);
                }
                
                if(oppyPart.Offered_Price__c != null && oppyPart.Quantity__c != null){
                    itemTargetPrice = map_OppyId_SumOfTargetPrice.get(oppyPart.Opportunity__c) + oppyPart.Quantity__c * oppyPart.Offered_Price__c;
                    map_OppyId_SumOfTargetPrice.put(oppyPart.Opportunity__c, itemTargetPrice);
                }
            }
            
            for(Id oppyId : map_OppyId_Oppy.keySet()){
                decimal lineItemsStandardCost;
                decimal lineItemsTargetPrice;
                decimal lineItemsTotalPrice;//update oppy total value, added by Tangyong Li 2017-10-11
                
                Opportunity oppy2Update = map_OppyId_Oppy.get(oppyId);
                if(map_OppyId_SumOfStandardCost.containsKey(oppyId)
                && map_OppyId_SumOfStandardCost.get(oppyId) != null){
                    lineItemsStandardCost = map_OppyId_SumOfStandardCost.get(oppyId);
                }
                if(map_OppyId_SumOfTargetPrice.containsKey(oppyId)
                && map_OppyId_SumOfTargetPrice.get(oppyId) != null){
                    lineItemsTargetPrice = map_OppyId_SumOfTargetPrice.get(oppyId);
                }
                
                //update oppy total value, added by Tangyong Li 2017-10-11  
                if(map_oppId_totalValue.containsKey(oppyId)
                && map_oppId_totalValue.get(oppyId) != null){
                    lineItemsTotalPrice = map_oppId_totalValue.get(oppyId);
                }
                if(lineItemsTotalPrice != null && lineItemsTotalPrice != 0) {
                    //Modified by Buwen Guo 2017-11-28 from email: Issues to fix 11/21 point 7
                    //oppy2Update.Amount = lineItemsTotalPrice;
                    //Added by Buwen Guo 2017-11-13,set total price for oppy.
                    //requirement from email:I know you're getting bored over there   
                    oppy2Update.Total_Opportunity_Value__c = lineItemsTotalPrice;
                    
                    //added by Tangyong Li 2018-01-22
                    if(oppy2Update.ERP_For_Pricing__c == 'SAP (except ANZPAC)'){
	                    //modified by Tangyong Li 2018-03-23: 'One Time Tender' -> 'Blanket/Tender'
	                    //if(oppy2Update.Quote_Type__c == 'One Time Tender'){
		                //    oppy2Update.SAP_Quote_Type__c = 'One Time Tender';
	                    if(oppy2Update.Quote_Type__c == 'Blanket/Tender'){
		                    oppy2Update.SAP_Quote_Type__c = 'Blanket/Tender';
		                }else if(oppy2Update.Total_Opportunity_Value__c > 10000){
		                    oppy2Update.SAP_Quote_Type__c = 'Big Quote';
		                }else{
		                    oppy2Update.SAP_Quote_Type__c = 'Small Quote';
		                }
                    }else{
		            	oppy2Update.SAP_Quote_Type__c = null;
		            }
	                //end
	                
                    //System.debug('---oppy2Update.Total_Opportunity_Value__c:::' + oppy2Update.Total_Opportunity_Value__c);
                }
                //added end
                
                //System.debug('---lineItemsTargetPrice:::' + lineItemsTargetPrice);
                //System.debug('---lineItemsStandardCost:::' + lineItemsStandardCost);
                // Opportunity.Margin__c=[sum(lineItemsTargetPrice)-sum(lineItemsStandardCost)]/sum(lineItemsTargetPrice)
                /*if(lineItemsTargetPrice != null && lineItemsTargetPrice != 0
                && oppy2Update.ERP_For_Pricing__c != 'SAP (except ANZPAC)'){
                    oppy2Update.Margin__c = ((lineItemsTargetPrice - lineItemsStandardCost) / lineItemsTargetPrice)*100; 
                    //System.debug('---oppy2Update.Margin__c:::' + oppy2Update.Margin__c);
                }else{
                	if(oppy2Update.Margin__c != null) oppy2Update.Margin__c = null;
                }*/
                if(oppy2Update.ERP_For_Pricing__c != 'SAP (except ANZPAC)'){
                	if(lineItemsTargetPrice != null && lineItemsTargetPrice != 0){
                    	Decimal dec_margin = ((lineItemsTargetPrice - lineItemsStandardCost) / lineItemsTargetPrice)*100; 
                    	oppy2Update.Margin__c = dec_margin.setScale(2);
                    	//System.debug('---oppy2Update.Margin__c:::' + oppy2Update.Margin__c);
	                	//map_oppyId_oppys.put(oppy2Update.Id, oppy2Update);
	                }else{
	                	if(oppy2Update.Margin__c != null) oppy2Update.Margin__c = null;
	                	//map_oppyId_oppys.put(oppy2Update.Id, oppy2Update);
	                }
                }
            	map_oppyId_oppys.put(oppy2Update.Id, oppy2Update);
                //list_Opportunitys2Update.add(oppy2Update);
            }
            
            /*
            if(list_Opportunitys2Update.size() > 0){
                isInUpdateOppyMargin = true;
                try{
                    update list_Opportunitys2Update;
                }catch(Exception e){
                    ErrorLogging.Log(e);
                    String vStrError = 'Error Type = ' + e.getTypeName() + ' Error Line = ' + e.getLineNumber() + '' + ' Error Stack = ' + e.getStackTraceString() + ' Error Message = ' + e.getMessage();
                    SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc, SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '', e.getStackTraceString());
                }
            }*/
        }
        return map_oppyId_oppys;
    }
    
    /*------------------------------------------------------------
    Author:        Buwen Guo <buwen.guo@oinio.com>
    Description:   Function to get all Opportunity_Part__c for caculating Fraction_of_sale__c
    Inputs:        trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2017-09-12 Buwen Guo <buwen.guo@oinio.com> Created
    ------------------------------------------------------------*/
    /*private static map<Id, Opportunity_Part__c> updateOppyPartFraction(ClsWrappers.TriggerContext trgCtx, Map<Id,Opportunity_Part__c> map_oppyPartId_allOppyParts){
        if(trgCtx.isBefore || isInUpdateOppyPartFraction) return null;
        //system.debug('updateOppyPartFraction:::');
        isInUpdateOppyPartFraction = true;
        Map<Id,List<Opportunity_Part__c>> map_OppyId_ListOppyParts;
        Set<String> set_oppyIds = new Set<String>();
        List<Opportunity_Part__c> list_oppyPartsNeededUpdate = new List<Opportunity_Part__c>();
        
        map<Id, Opportunity_Part__c> map_oppyPartId_oppyParts = new map<Id, Opportunity_Part__c>();
        
        if(trgCtx.isInsert || trgCtx.isUndelete){
            map_OppyId_ListOppyParts = new Map<Id,List<Opportunity_Part__c>>();
            
            for(Sobject sobj : trgCtx.newList) {
                //get all opportunities id.
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                String oppyId = oppyPart.Opportunity__c;
                set_oppyIds.add(oppyId);
            }
            
            //Add map data for oppy Id and it's exist oppy parts.
			for(Opportunity_Part__c oppPart : map_oppyPartId_allOppyParts.values()){
                if(set_oppyIds.contains(oppPart.Opportunity__c)
                && oppPart.Status__c != 'No Bid'
                && oppPart.Status__c != 'Lost'){
	                if(!map_OppyId_ListOppyParts.containsKey(oppPart.Opportunity__c)){
	                    map_OppyId_ListOppyParts.put(oppPart.Opportunity__c,new List<Opportunity_Part__c>());
	                }
	                map_OppyId_ListOppyParts.get(oppPart.Opportunity__c).add(oppPart);
                }
            }
            
            //caculate Fraction_of_sale__c on Opportunity_Part__c for every opportunity.
            for(Id oppyId : map_OppyId_ListOppyParts.keySet()){
                List<Opportunity_Part__c> list_oppyParts = map_OppyId_ListOppyParts.get(oppyId);
                //system.debug('isInsert::list_oppyParts::'+list_oppyParts);
                
                //modified by Tangyong Li 2018-01-16
                //list_oppyPartsNeededUpdate.addAll(calcOppyPartItemFraction(list_oppyParts));
                map_oppyPartId_oppyParts.putAll(calcOppyPartItemFraction(list_oppyParts));
            }
            
        }else if(trgCtx.isUpdate){
            map_OppyId_ListOppyParts = new Map<Id,List<Opportunity_Part__c>>();
            //Added by Yiming Shen <yiming.shen@capgemini.com> at 2017-12-07 due to unnecessary queries
            for(Sobject sobj : trgCtx.newList) {
                //Build map for oppy Id and it's updated oppy parts.
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                set_oppyIds.add(oppyPart.Opportunity__c);
            }
            //End
            for(Opportunity_Part__c oppPart : map_oppyPartId_allOppyParts.values()){
                if(set_oppyIds.contains(oppPart.Opportunity__c)
                && oppPart.Status__c != 'No Bid'
                && oppPart.Status__c != 'Lost'){                                        
	                if(!map_OppyId_ListOppyParts.containsKey(oppPart.Opportunity__c)){
	                    map_OppyId_ListOppyParts.put(oppPart.Opportunity__c,new List<Opportunity_Part__c>());
	                }
                map_OppyId_ListOppyParts.get(oppPart.Opportunity__c).add(oppPart);
            	}
            }
            System.debug('*** we have ' + map_OppyId_ListOppyParts.keyset().size() + ' opportunities represented');
            //caculate Fraction_of_sale__c on Opportunity_Part__c for every opportunity.
            for(Id oppyId : map_OppyId_ListOppyParts.keySet()){
                List<Opportunity_Part__c> list_oppyParts = map_OppyId_ListOppyParts.get(oppyId);
                System.debug('**** ' + oppyId + ' has ' + list_oppyParts.size() + ' parts in the list');
                //system.debug('isUpdate::list_oppyParts::'+list_oppyParts);
                
                //modified by Tangyong Li 2018-01-16
                //list_oppyPartsNeededUpdate.addAll(calcOppyPartItemFraction(list_oppyParts));
                map_oppyPartId_oppyParts.putAll(calcOppyPartItemFraction(list_oppyParts));
            }
            
            
        }else if(trgCtx.isDelete){
            map_OppyId_ListOppyParts = new Map<Id,List<Opportunity_Part__c>>();
            
            for(Sobject sobj : trgCtx.oldList) {
                //get all opportunities Id that needed recalculate
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                if(oppyPart.Status__c != 'No Bid' && oppyPart.Status__c != 'Lost' ){
                    String oppyId = oppyPart.Opportunity__c;
                    set_oppyIds.add(oppyId);
                }
            }
            
            //Add map data for oppy Id and it's exist oppy parts.
            for(Opportunity_Part__c oppPart : map_oppyPartId_allOppyParts.values()){
                if(set_oppyIds.contains(oppPart.Opportunity__c)
                && oppPart.Status__c != 'No Bid'
                && oppPart.Status__c != 'Lost'){    
                    if(!map_OppyId_ListOppyParts.containsKey(oppPart.Opportunity__c)){
                        map_OppyId_ListOppyParts.put(oppPart.Opportunity__c,new List<Opportunity_Part__c>());
                    }
                    map_OppyId_ListOppyParts.get(oppPart.Opportunity__c).add(oppPart);
            	}
            }
            //caculate Fraction_of_sale__c on Opportunity_Part__c for every opportunity.
            for(Id oppyId : map_OppyId_ListOppyParts.keySet()){
                List<Opportunity_Part__c> list_oppyParts = map_OppyId_ListOppyParts.get(oppyId);
                //system.debug('isDelete::list_oppyParts::'+list_oppyParts);
                
                //modified by Tangyong Li 2018-01-16
                //list_oppyPartsNeededUpdate.addAll(calcOppyPartItemFraction(list_oppyParts));
                map_oppyPartId_oppyParts.putAll(calcOppyPartItemFraction(list_oppyParts));
            }
            
        }
        
        return map_oppyPartId_oppyParts;
    }*/
    
    /*------------------------------------------------------------
    Author:        Yiming Shen <yiming.shen@capgemini.com>
    Description:   Function to update Opportunity_Part_Forecast__c records.
    Inputs:        trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2017-09-12  Yiming Shen <yiming.shen@capgemini.com> Created
    ------------------------------------------------------------*/
    private static void updateOppyPartForecast(ClsWrappers.TriggerContext trgCtx, Map<Id,Opportunity_Part__c> map_oppyPartId_allOppyParts){
        if(trgCtx.isBefore || isInUpdateOppyPartForecast) return;
        Map<Id,List<Opportunity_Part__c>> map_OppyId_ListOppyParts = new Map<Id,List<Opportunity_Part__c>>();
        Map<Id,List<Opportunity_Forecast__c>> map_OppyId_ListOppyForecasts = new Map<Id,List<Opportunity_Forecast__c>>();
        List<Opportunity_Part_Forecast__c> list_OppyPartForecasts2Delete = new List<Opportunity_Part_Forecast__c>();
        List<Opportunity_Part_Forecast__c> list_OppyPartForecasts2Insert = new List<Opportunity_Part_Forecast__c>();
        Set<String> set_OppyIds2UpdateOppyPartForecasts = new Set<String>();
        
        if(trgCtx.isInsert || trgCtx.isUndelete){           
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                if(oppyPart.Status__c != 'No Bid' && oppyPart.Status__c != 'Lost'){
                    set_OppyIds2UpdateOppyPartForecasts.add(oppyPart.Opportunity__c); 
                }
            }
        }else if(trgCtx.isUpdate){          
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                Opportunity_Part__c oldOppyPart = (Opportunity_Part__c)trgCtx.oldMap.get(oppyPart.Id);
                if(oppyPart.Opportunity__c != oldOppyPart.Opportunity__c){
                    set_OppyIds2UpdateOppyPartForecasts.add(oppyPart.Opportunity__c);
                    set_OppyIds2UpdateOppyPartForecasts.add(oldOppyPart.Opportunity__c);
                //}else if(oppyPart.Fraction_of_sale__c != oldOppyPart.Fraction_of_sale__c){
                }else if(oppyPart.Quantity__c != oldOppyPart.Quantity__c
                || oppyPart.Offered_Price__c != oldOppyPart.Offered_Price__c){
                    set_OppyIds2UpdateOppyPartForecasts.add(oppyPart.Opportunity__c);
                }else if(((oldOppyPart.Status__c == 'Lost' || oldOppyPart.Status__c == 'No Bid')
                && oppyPart.Status__c != 'Lost' && oppyPart.Status__c != 'No Bid')
                || (oldOppyPart.Status__c != 'Lost' && oldOppyPart.Status__c != 'No Bid' 
                && (oppyPart.Status__c == 'Lost' || oppyPart.Status__c == 'No Bid'))){
                    set_OppyIds2UpdateOppyPartForecasts.add(oppyPart.Opportunity__c);
                }
            }
        }else if(trgCtx.isDelete){
            for(Sobject sobj : trgCtx.oldList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                if(oppyPart.Status__c != 'No Bid' && oppyPart.Status__c != 'Lost'){
                    set_OppyIds2UpdateOppyPartForecasts.add(oppyPart.Opportunity__c);
                }
            }
        }
        //1.get the map of OppyId and its OppyParts
        if(set_OppyIds2UpdateOppyPartForecasts.size() > 0){
            isInUpdateOppyPartForecast = true;
            /*for(Opportunity_Part__c oppyPart : [SELECT Id, Opportunity__c, Fraction_of_sale__c,
                                                Opportunity__r.RecordType.DeveloperName
                                                FROM Opportunity_Part__c 
                                                WHERE Status__c != 'Lost'
                                                AND Opportunity__c IN: set_OppyIds2UpdateOppyPartForecasts
                                                AND Opportunity__r.RecordType.DeveloperName = 'Energy_Sales' 
                                                AND Status__c != 'No Bid']){*/
            for(Opportunity_Part__c oppyPart : map_oppyPartId_allOppyParts.values()){
            	if(oppyPart.Status__c != 'Lost' && oppyPart.Status__c != 'No Bid'
            	&& oppyPart.Opportunity__r.RecordType.DeveloperName == 'Energy_Sales' 
            	&& set_OppyIds2UpdateOppyPartForecasts.contains(oppyPart.Opportunity__c)){
	                if(!map_OppyId_ListOppyParts.containsKey(oppyPart.Opportunity__c)){
	                    map_OppyId_ListOppyParts.put(oppyPart.Opportunity__c, new List<Opportunity_Part__c>());
	                }
	                map_OppyId_ListOppyParts.get(oppyPart.Opportunity__c).add(oppyPart);
            	}
            }
            //2.get the map of OppyId and its OppyForecasts
            for(Opportunity_Forecast__c oppyForecast : [SELECT Id, Fiscal_Year__c, Fiscal_Quarter__c,
                                                        Fiscal_Month__c, Amount__c, Opportunity__c  
                                                        FROM Opportunity_Forecast__c 
                                                        WHERE Opportunity__c IN: set_OppyIds2UpdateOppyPartForecasts
                                                        AND Opportunity__r.RecordType.DeveloperName = 'Energy_Sales' 
                                                        ]){
                if(!map_OppyId_ListOppyForecasts.containsKey(oppyForecast.Opportunity__c)){
                    map_OppyId_ListOppyForecasts.put(oppyForecast.Opportunity__c, new List<Opportunity_Forecast__c>());
                }
                map_OppyId_ListOppyForecasts.get(oppyForecast.Opportunity__c).add(oppyForecast);
            }
            //3. delete all oppyPartForecasts of this opportunity
            for(Opportunity_Part_Forecast__c oppyPartForecast : [SELECT Month__c, Year__c, CustomOpportunityId__c
                                                                    FROM Opportunity_Part_Forecast__c
                                                                    WHERE Opportunity_Part__r.Opportunity__c IN: set_OppyIds2UpdateOppyPartForecasts]){
                list_OppyPartForecasts2Delete.add(oppyPartForecast);
            }
        }
        //4.generate new OppyPartForecasts
        for(Id oppyId : map_OppyId_ListOppyForecasts.keySet()){
            for(Opportunity_Forecast__c oppyForecast : map_OppyId_ListOppyForecasts.get(oppyId)){
                if(oppyForecast.Amount__c != null && oppyForecast.Amount__c != 0
                && map_OppyId_ListOppyParts.containsKey(oppyId)){
                    for(Opportunity_Part__c oppyPart : map_OppyId_ListOppyParts.get(oppyId)){
                        Opportunity_Part_Forecast__c oppyPartForecast2Insert = new Opportunity_Part_Forecast__c();
                        oppyPartForecast2Insert.Opportunity_Forecast__c = oppyForecast.Id;
                        oppyPartForecast2Insert.Opportunity_Part__c = oppyPart.Id;
                        oppyPartForecast2Insert.Year__c = oppyForecast.Fiscal_Year__c;
                        oppyPartForecast2Insert.CurrencyISOCode = 'USD';
                        oppyPartForecast2Insert.Quarter__c = oppyForecast.Fiscal_Quarter__c;
                        oppyPartForecast2Insert.Month__c = Decimal.valueOf(oppyForecast.Fiscal_Month__c);
                        list_OppyPartForecasts2Insert.add(oppyPartForecast2Insert);
                    }
                }
            }
        }
        if(Test.isRunningTest()){
            if(list_OppyPartForecasts2Delete.size() > 0) delete list_OppyPartForecasts2Delete;
            if(list_OppyPartForecasts2Insert.size() > 0) insert list_OppyPartForecasts2Insert;
        }else if(list_OppyPartForecasts2Delete.size() != 0 || list_OppyPartForecasts2Insert.size() != 0){
            System.enqueueJob(new ClsOppyPartForecastDeleteQueue(list_OppyPartForecasts2Delete,list_OppyPartForecasts2Insert));
        }
    }
    
    /*------------------------------------------------------------
    Author:        Buwen Guo <buwen.guo@oinio.com>
    Description:   Function to caculating Fraction_of_sale__c on Opportunity_Part__c.
    Inputs:        trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2017-09-12  Buwen Guo <buwen.guo@oinio.com> Created
    ------------------------------------------------------------*/
    /*public static list<Opportunity_Part__c> calcOppyPartItemFraction(list<Opportunity_Part__c> list_oppyParts) {
    	//system.debug('calcOppyPartItemFraction:::');
        decimal totalAmount = 0.0;
        decimal percentCounter = 0;
        list<Opportunity_Part__c> list_partWithAmount = new list<Opportunity_Part__c>();
        for(Opportunity_Part__c part : list_oppyParts) {
            if(part.Quantity__c != null && part.Quantity__c != 0 && part.Offered_Price__c != null && part.Offered_Price__c != 0 && part.Status__c != 'Lost' && part.Status__c != 'No Bid') {
                decimal partAmount = part.Quantity__c * part.Offered_Price__c;
                totalAmount += partAmount;
                list_partWithAmount.add(part);
            }
        }
        //system.debug('totalAmount::'+totalAmount);
        if(totalAmount == 0) {
            return new list<Opportunity_Part__c>();
        }
        for(Integer i = 0; i < list_partWithAmount.size(); i ++ ) {
            Opportunity_Part__c part = list_partWithAmount[i];
            decimal percentage = 0;
            if(part.Quantity__c != null && part.Quantity__c != 0 && part.Offered_Price__c != null && part.Offered_Price__c != 0) {
                decimal partAmount = part.Quantity__c * part.Offered_Price__c;
                //Fraction_of_sale__c
                if(list_partWithAmount.size() == 1) {
                    part.Fraction_of_sale__c = 1;
                }
                else if(i == list_partWithAmount.size() - 1) {
                    part.Fraction_of_sale__c = 1 - percentCounter;
                }
                else {
                    percentage = partAmount.divide(totalAmount, 4) ;
                    percentCounter += percentage;
                    part.Fraction_of_sale__c = percentage;
                }
                //system.debug('Fraction_of_sale__c::'+part.Fraction_of_sale__c);
            }
        }
        //system.debug('list_partWithAmount::'+list_partWithAmount);
        return list_partWithAmount;
    }*/
    
    /*------------------------------------------------------------
    Author:        Buwen Guo <buwen.guo@oinio.com>
    Description:   Function to if the user updates the quantity of an opportunityPart then you need to re-price that OppPart.Different Qty may mean a different book price.
    Inputs:        trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2017-09-23 Buwen Guo <buwen.guo@oinio.com>  Created
    2017-10-05 Yuan Yao <yuan.yao@oinio.com> Modified 
    - Don't send proposal parts in the pricing request to MFGPRO
    ------------------------------------------------------------*/
    public static void resetBookprice(ClsWrappers.TriggerContext trgCtx, map<Id, Opportunity> map_oppyId_allOppys,map<Id, Opportunity_Part__c> map_oppyPartId_oppyParts){
        Set<String> set_dummyPartNames = new Set<String>{'Transportation Costs', 'Installation Costs', 'Training Costs','Freight Costs','Commission Costs','Distribution Costs','Other Costs'};
        if(trgCtx.isBefore) return;
        //system.debug('resetBookprice:::');
        
        //if(isInUpdatePrice) return;
        //isInUpdatePrice = true;
        
        if(ClsCloneOppyPartQueue.bool_isInCloneOppyPartQueue || ExtOpportunityDeepClone.bool_isInOpportunityDeepClone || ExtOppyPartDiscounting.bool_isInEditERPForPricing || EnergyQuoteTrgHandler.isFromQuoteRecreateParts){
        	return;
        }
        
        if(trgCtx.isInsert || trgCtx.isUndelete){
            Map<Id,List<Opportunity_Part__c>> map_OppyId_ListOppyParts = new Map<Id,List<Opportunity_Part__c>>();
            set<String> set_oppyIds = new set<String>();
            Map<Id,opportunity> map_OppyId_Oppy = new Map<Id,opportunity>();
            list<opportunity_part__c> list_tempOppyParts = new list<opportunity_part__c>();
            //Added by Yiming Shen <yiming.shen@capgemini.com> at 2017-12-07 due to unnecessary queries
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                system.debug('oppyPart::isCloned__c::'+oppyPart.isCloned__c);
                if(!map_OppyId_ListOppyParts.containsKey(oppyPart.Opportunity__c)){
                    map_OppyId_ListOppyParts.put(oppyPart.Opportunity__c,new List<Opportunity_Part__c>());
                }
                if(oppyPart.Status__c != 'Won' && oppyPart.Part_Number_txt__c != null && !set_dummyPartNames.contains(oppyPart.Part_Number_txt__c) && !oppyPart.Part_Number_txt__c.toLowerCase().contains('proposal') && oppyPart.isCloned__c == false){    // modified by yuan yao
                    map_OppyId_ListOppyParts.get(oppyPart.Opportunity__c).add(oppyPart);
                    list_tempOppyParts.add(oppyPart);
                }                                    
                //map_OppyId_ListOppyParts.get(oppPart.Opportunity__c).add(oppPart);
                set_oppyIds.add(oppyPart.Opportunity__c);
            }
            //Added by Buwen Guo 2018-03-23 requirement from email:Bug in Awaiting Data
            Energy_Control__c isNotAllowRestCallout = Energy_Control__c.getInstance('Energy Control');
            Energy_Control__c isNotAllowCalloutUser = Energy_Control__c.getInstance('Limit User');
            
            
            for(opportunity_part__c oppyPart : list_tempOppyParts){
	            //Added by Buwen Guo 2018-03-22 requirement from email:Bugs to Fix... point 4
	            if( map_oppyId_allOppys.containsKey(oppyPart.Opportunity__c) && 
	            	map_oppyId_allOppys.get(oppyPart.Opportunity__c)!= null && 
	            	(	map_oppyId_allOppys.get(oppyPart.Opportunity__c).ERP_for_Pricing__c == 'SAP (except ANZPAC)' || 
	            		map_oppyId_allOppys.get(oppyPart.Opportunity__c).ERP_for_Pricing__c == 'MFGPRO')    ||(
	            		map_oppyId_allOppys.get(oppyPart.Opportunity__c).ERP_for_Pricing__c == 'ANZPAC')    ){
		            
		            opportunity_part__c updateOppyPart;
		        	if(map_oppyPartId_oppyParts.containsKey(oppyPart.Id)) {
		        		updateOppyPart = map_oppyPartId_oppyParts.get(oppyPart.Id);
		        	} else {
		        		updateOppyPart = new Opportunity_Part__c();
		        		updateOppyPart.Id = oppyPart.Id;
		        		map_oppyPartId_oppyParts.put(updateOppyPart.Id, updateOppyPart);
		        	}
		        	if(isNotAllowRestCallout != null && isNotAllowRestCallout.Disable_Integrations__c != true && map_oppyId_allOppys.get(oppyPart.Opportunity__c).createdDate >= isNotAllowRestCallout.Callout_Start_Date__c){
		        		if(isNotAllowCalloutUser != null && isNotAllowCalloutUser.Limit_User__c != null && isNotAllowCalloutUser.Limit_User__c != '' && isNotAllowCalloutUser.Disable_Integrations__c == true){
		        			List<String> list_userNames = isNotAllowCalloutUser.Limit_User__c.split(';');
		        			if(!list_userNames.contains(UserInfo.getName())){
		        				if(!(map_oppyId_allOppys.get(oppyPart.Opportunity__c).ERP_For_Pricing__c == 'SAP (except ANZPAC)' 
		        					&& map_oppyId_allOppys.get(oppyPart.Opportunity__c).Account != null 
		        					&& map_oppyId_allOppys.get(oppyPart.Opportunity__c).Account.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId())){
	            					system.debug('p1245:Awaiting::');
	            					updateOppyPart.ERP_Pricing_Status__c = 'Awaiting Data';
		        				}
		        			}
		        		}else{
		        			if(!(map_oppyId_allOppys.get(oppyPart.Opportunity__c).ERP_For_Pricing__c == 'SAP (except ANZPAC)' 
		        				&& map_oppyId_allOppys.get(oppyPart.Opportunity__c).Account != null 
		        				&& map_oppyId_allOppys.get(oppyPart.Opportunity__c).Account.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId())){
            					system.debug('p1253:Awaiting::');
            					updateOppyPart.ERP_Pricing_Status__c = 'Awaiting Data';
	        				}
		        		}
		        	}
	        	}
            }
            
            
            //Commented by Yiming Shen <yiming.shen@capgemini.com> at 2017-12-07 due to unnecessary queries
            /*for(Sobject sobj : trgCtx.newList) {
                //Build map for oppy Id and it's updated oppy parts.
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                set_oppPartIds.add(oppyPart.Id);
            }
            
            for(Opportunity_Part__c oppPart :[select id,Opportunity__c,Part__r.name,Quantity__c,NDR_Item_Number__c,Code_for_unit_of_measurement__c
                                                from Opportunity_Part__c where id IN:set_oppPartIds]){                  
                if(!map_OppyId_ListOppyParts.containsKey(oppPart.Opportunity__c)){
                    map_OppyId_ListOppyParts.put(oppPart.Opportunity__c,new List<Opportunity_Part__c>());
                }
                if(oppPart.Part__r.name != null && !oppPart.Part__r.name.toLowerCase().contains('proposal')){    // modified by yuan yao
                    map_OppyId_ListOppyParts.get(oppPart.Opportunity__c).add(oppPart);
                }                                    
                //map_OppyId_ListOppyParts.get(oppPart.Opportunity__c).add(oppPart);
                set_oppyIds.add(oppPart.Opportunity__c);
            }*/
            //End
            
            //modified by Tangyong Li 2018-01-10
            /*
            for(opportunity opp : [select id,AccountId,Account.Source_System__c,ERP_For_Pricing__c, Account.Distribution_Channel_Cde__c,Account.Name,
                                            Account.recordtype.name,Account_Number__c,Account.AccountNumber,Account.Sales_Organization_ID__c
                                            from opportunity where id IN:set_oppyIds]){
            */
            for(opportunity opp : map_oppyId_allOppys.values()){
            	if(set_oppyIds.contains(opp.Id)) {
	                map_OppyId_Oppy.put(opp.id,opp);
            	}
            }
            
            //caculate Fraction_of_sale__c on Opportunity_Part__c for every opportunity.
            for(Id oppyId : map_OppyId_ListOppyParts.keySet()){
                List<Opportunity_Part__c> list_oppyParts = map_OppyId_ListOppyParts.get(oppyId);
                Opportunity opp = map_OppyId_Oppy.get(oppyId);
                //system.debug('resetBookprice::Insert::');
                //Added by Buwen Guo 2018-01-26 requirement from email:SAP integration clarification
                if(list_oppyParts != null && list_oppyParts.size() > 0 && 
                	(opp.ERP_For_Pricing__c != 'SAP (except ANZPAC)' || (opp.ERP_For_Pricing__c == 'SAP (except ANZPAC)' && opp.Account.RecordTypeId != Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId()))){
	                
	                String str_oppy = Json.serialize(opp);
	                String str_listoppyparts = Json.serialize(list_oppyParts);
	                //getPriceForOpportunityParts(str_oppy,str_listoppyparts);
	                system.debug('P1295LineCallout::');
	                //InventoryAndPricing.getPrice(str_oppy,str_listoppyparts);
                }
            }
        }else if(trgCtx.isUpdate){
            Map<Id,List<Opportunity_Part__c>> map_OppyId_ListOppyParts = new Map<Id,List<Opportunity_Part__c>>();
            set<String> set_oppPartIds = new set<String>();
            
            set<String> set_oppyIds = new set<String>();
            Map<Id,opportunity> map_OppyId_Oppy = new Map<Id,opportunity>();
            
            list<opportunity_part__c> list_tempOppyParts = new list<opportunity_part__c>();
            
            for(Sobject sobj : trgCtx.newList) {
                //Build map for oppy Id and it's updated oppy parts.
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                system.debug('oppyPart::isCloned__c::'+oppyPart.isCloned__c);
                IF(trgCtx.oldMap == null || !trgCtx.oldMap.containsKey(oppyPart.Id)){
                    return ;
                }
                Opportunity_Part__c oppyPart_old = (Opportunity_Part__c)(trgCtx.oldMap.get(oppyPart.Id));
                if(oppyPart.Quantity__c != oppyPart_old.Quantity__c && (oppyPart.Status__c == 'Won' || oppyPart.Status__c == 'Pending' )){
                //Modified by Yiming Shen <yiming.shen@capgemini.com> at 2017-12-07 due to unnecessary queries
                    //set_oppPartIds.add(oppyPart.Id);
                    if(!map_OppyId_ListOppyParts.containsKey(oppyPart.Opportunity__c)){
                        map_OppyId_ListOppyParts.put(oppyPart.Opportunity__c,new List<Opportunity_Part__c>());
                    }
                    if(oppyPart.Part_Number_txt__c != null && !set_dummyPartNames.contains(oppyPart.Part_Number_txt__c) && !oppyPart.Part_Number_txt__c.toLowerCase().contains('proposal') && oppyPart.isCloned__c == false){    // modified by yuan yao
                        map_OppyId_ListOppyParts.get(oppyPart.Opportunity__c).add(oppyPart);
                        list_tempOppyParts.add(oppyPart);
                    }                                       
                    //map_OppyId_ListOppyParts.get(oppPart.Opportunity__c).add(oppPart);
                    set_oppyIds.add(oppyPart.Opportunity__c);
                //End
                }
            }
            
            //Added by Buwen Guo 2018-03-23 requirement from email:Bug in Awaiting Data
            Energy_Control__c isNotAllowRestCallout = Energy_Control__c.getInstance('Energy Control');
            Energy_Control__c isNotAllowCalloutUser = Energy_Control__c.getInstance('Limit User');
            
            for(opportunity_part__c oppyPart : list_tempOppyParts){
	            //Added by Buwen Guo 2018-03-22 requirement from email:Bugs to Fix... point 4
	            if( map_oppyId_allOppys.containsKey(oppyPart.Opportunity__c) && 
	            	map_oppyId_allOppys.get(oppyPart.Opportunity__c)!= null && 
	            	(	map_oppyId_allOppys.get(oppyPart.Opportunity__c).ERP_for_Pricing__c == 'SAP (except ANZPAC)' || 
	            		map_oppyId_allOppys.get(oppyPart.Opportunity__c).ERP_for_Pricing__c == 'MFGPRO')     ||(
	            		map_oppyId_allOppys.get(oppyPart.Opportunity__c).ERP_for_Pricing__c == 'ANZPAC')     ){
		            opportunity_part__c updateOppyPart;
		        	if(map_oppyPartId_oppyParts.containsKey(oppyPart.Id)) {
		        		updateOppyPart = map_oppyPartId_oppyParts.get(oppyPart.Id);
		        	} else {
		        		updateOppyPart = new Opportunity_Part__c();
		        		updateOppyPart.Id = oppyPart.Id;
		        		map_oppyPartId_oppyParts.put(updateOppyPart.Id, updateOppyPart);
		        	}
	            	if(isNotAllowRestCallout != null && isNotAllowRestCallout.Disable_Integrations__c != true  && map_oppyId_allOppys.get(oppyPart.Opportunity__c).createdDate >= isNotAllowRestCallout.Callout_Start_Date__c){
		        		if(isNotAllowCalloutUser != null && isNotAllowCalloutUser.Limit_User__c != null && isNotAllowCalloutUser.Limit_User__c != '' && isNotAllowCalloutUser.Disable_Integrations__c == true){
		        			List<String> list_userNames = isNotAllowCalloutUser.Limit_User__c.split(';');
		        			if(!list_userNames.contains(UserInfo.getName())){
	            				if(!(map_oppyId_allOppys.get(oppyPart.Opportunity__c).ERP_For_Pricing__c == 'SAP (except ANZPAC)' 
			        				&& map_oppyId_allOppys.get(oppyPart.Opportunity__c).Account != null 
			        				&& map_oppyId_allOppys.get(oppyPart.Opportunity__c).Account.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId())){
	            					system.debug('p1368:Awaiting::');
	            					updateOppyPart.ERP_Pricing_Status__c = 'Awaiting Data';
		        				}
		        			}
		        		}else{
		        			if(!(map_oppyId_allOppys.get(oppyPart.Opportunity__c).ERP_For_Pricing__c == 'SAP (except ANZPAC)' 
		        				&& map_oppyId_allOppys.get(oppyPart.Opportunity__c).Account != null 
		        				&& map_oppyId_allOppys.get(oppyPart.Opportunity__c).Account.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId())){
            					system.debug('p1376:Awaiting::');
            					updateOppyPart.ERP_Pricing_Status__c = 'Awaiting Data';
	        				}
		        		}
		        	}
	        	}
            }

            //Commented by Yiming Shen <yiming.shen@capgemini.com> at 2017-12-07 due to unnecessary queries
            /*for(Opportunity_Part__c oppPart :[select id,Opportunity__c,Part__r.name,Quantity__c,NDR_Item_Number__c,Code_for_unit_of_measurement__c
                                                from Opportunity_Part__c where id IN:set_oppPartIds]){                  
                if(!map_OppyId_ListOppyParts.containsKey(oppPart.Opportunity__c)){
                    map_OppyId_ListOppyParts.put(oppPart.Opportunity__c,new List<Opportunity_Part__c>());
                }
                if(oppPart.Part__r.name != null && !oppPart.Part__r.name.toLowerCase().contains('proposal')){    // modified by yuan yao
                    map_OppyId_ListOppyParts.get(oppPart.Opportunity__c).add(oppPart);
                }                                       
                //map_OppyId_ListOppyParts.get(oppPart.Opportunity__c).add(oppPart);
                set_oppyIds.add(oppPart.Opportunity__c);
            }*/
            //End
            
            //modified by Tangyong Li 2018-01-10
            /*
            for(opportunity opp : [select id,AccountId,Account.Source_System__c,account.name,ERP_For_Pricing__c,Account.Distribution_Channel_Cde__c,
                                            Account.recordtype.name,Account_Number__c,Account.AccountNumber,Account.Sales_Organization_ID__c,Account.RecordTypeId
                                            from opportunity where id IN:set_oppyIds]){
            */
            for(opportunity opp : map_oppyId_allOppys.values()){
            	if(set_oppyIds.contains(opp.Id)) {
	                map_OppyId_Oppy.put(opp.id,opp);
            	}
            }
            
            
            
            
            //caculate Fraction_of_sale__c on Opportunity_Part__c for every opportunity.
            for(Id oppyId : map_OppyId_ListOppyParts.keySet()){
                List<Opportunity_Part__c> list_oppyParts = map_OppyId_ListOppyParts.get(oppyId);
                Opportunity opp = map_OppyId_Oppy.get(oppyId);
                String str_accName = opp.Account.Name;
                //Modified by Buwen Guo 2017-12-01 from email:Issues 11/30 point 6
                //Added by Buwen Guo 2018-01-26 requirement from email:SAP integration clarification
                if(list_oppyParts != null && list_oppyParts.size()>0 && (!(opp.ERP_for_Pricing__c == 'SAP (except ANZPAC)' 
                    //&& str_accName != null 
                    //&& str_accName.toLowerCase().contains('prospect')
                    && opp.Account.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId()
                    //Modified by Yiming Shen at 2017-12-03 from email: Issues 12/01 point 6
                    ))
                ){
                    //system.debug('resetBookprice::update::');
                    //system.debug('resetBookprice::update::'+ list_oppyParts);
                    String str_oppy = Json.serialize(opp);
                    String str_listoppyparts = Json.serialize(list_oppyParts);
                    //getPriceForOpportunityParts(str_oppy,str_listoppyparts);
                    system.debug('P1418LineCallout::');
                    //InventoryAndPricing.getPrice(str_oppy,str_listoppyparts);
                }
            }
        }
    }
    
    
    /** 
    * Method to get book price on Opportunity_Part__c.
    * Point 1 : If the user updates the quantity of an opportunityPart then you need to re-price that OppPart.Different Qty may mean a different book price.
    *
    @ author    Buwen Guo
    @ created   2017-09-23
    @ since     38.0
    
    @ changelog
    * 2017-09-23 Buwen Guo <buwen.guo@oinio.com>
    * - Created
    
    @future(callout = true)
    public static void getPriceForOpportunityParts(String str_oppy,String str_listoppyparts){
        opportunity oppy = (opportunity) SYSTEM.JSON.deserialize(str_oppy, opportunity.class);  
        List<Opportunity_Part__c> list_oppyParts  = (List<Opportunity_Part__c>) SYSTEM.JSON.deserialize(str_listoppyparts, List<Opportunity_Part__c> .class);   
        system.debug('getPriceForOpportunityParts::oppy::'+oppy);
        system.debug('getPriceForOpportunityParts::list_oppyParts::'+list_oppyParts);
        decimal dec_sourceSystem = oppy.End_Customer__r.Source_System__c;
        User currUser = [select id,MED_Region__c from user where id=:UserInfo.getUserId()];
        
        //SAP: 1
        //MFGPRO: 51
        //AMPICS: 36,43,110,34,187,42,269,272
        
        If (dec_sourceSystem == 1){
            return ;
        }else If (dec_sourceSystem == 51){
            decimal dec = InventoryAndPricing.getMFGProPriceForList(UserInfo.getSessionId(),oppy.id,oppy.Account_Number__c,list_oppyParts);
        }else If (dec_sourceSystem == 36 || dec_sourceSystem == 43 || dec_sourceSystem == 110 || dec_sourceSystem ==34 || dec_sourceSystem ==187 || dec_sourceSystem ==42 || dec_sourceSystem ==269 || dec_sourceSystem == 272){
            return ;
        }else if (oppy.End_Customer__r.ERP_for_Pricing__c == 'SAP (except ANZPAC)'){
            return ;
        }else if (oppy.End_Customer__r.ERP_for_Pricing__c == 'MFGPRO'){
            decimal dec = InventoryAndPricing.getMFGProPriceForList(UserInfo.getSessionId(),oppy.id,oppy.Account_Number__c,list_oppyParts);
        }else if (oppy.End_Customer__r.ERP_for_Pricing__c == 'AMPICS - ANZPAC'){
            return ;
        }else if(oppy.End_Customer__r.recordtype.name == 'Prospect' && currUser.MED_Region__c == 'Aus / New Zlnd'){
            return ;
        }else{
            return ;
        }
    }
    */
    
    /*------------------------------------------------------------
    Author:        Yiming Shen <yiming.shen@capgemini.com>
    Description:   Function to get the max value from a list of Integer, if this list is empty, return null.
    Inputs:        list_Numbers - a list of Integer numbers
    Returns:       Integer - the max number from a list of Integer numbers
    History
    2017-10-10 Yiming Shen <yiming.shen@capgemini.com> Created
    ------------------------------------------------------------*/
    @TestVisible 
    private static Integer getMaxNumber(List<Integer> list_Numbers){
        Integer maxNumber;
        if(list_Numbers.size() > 0){
            maxNumber = list_Numbers.get(0);
            for(Integer num : list_Numbers){
                if(maxNumber < num){
                    maxNumber = num;
                }
            }
        }
        return maxNumber;
    }
    
    /*------------------------------------------------------------
    Author:        Buwen Guo <buwen.guo@oinio.com>
    Description:   Function to populate Customer_Part_Number__c/Customer_Part_Number1__c/Part_Number__c field on Opportunity_Part__c
                   Requirement from email:Some things to fix and improve point 1
    Inputs:        trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2017-10-17 Buwen Guo <buwen.guo@capgemini.com> Created
    ------------------------------------------------------------*/
    public static void populateCustomerPartNumber(ClsWrappers.TriggerContext trgCtx, map<Id, Opportunity> map_oppyId_allOppys){
        if(trgCtx.isAfter) return;
        //system.debug('populateCustomerPartNumber::');
        
        
        if(trgCtx.isInsert || trgCtx.isUndelete){
            set<String> set_oppyIds = new set<String>();
            set<String> set_partIds = new set<String>();
            //Added by Yiming Shen <yiming.shen@capgemini.com> at 2017-12-07 due to unnecessary queries
            set<String> set_partNames = new set<String>();
            map<string,string> map_partId_partName = new map<string,string>();
            
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                set_oppyIds.add(oppyPart.Opportunity__c);
                set_partIds.add(oppyPart.Part__c);
                map_partId_partName.put(oppyPart.Part__c,oppyPart.Part_Number_txt__c);
                set_partNames.add(oppyPart.Part_Number_txt__c);
            }
            //End
            //Commented by Yiming Shen <yiming.shen@capgemini.com> at 2017-12-07 due to unnecessary queries
            /*for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                set_oppyIds.add(oppyPart.Opportunity__c);
                set_partIds.add(oppyPart.Part__c);
            }
            
            set<String> set_partNames = new set<String>();
            map<string,string> map_partId_partName = new map<string,string>();
            for(Part__c part :[select id,name from Part__c where id in:set_partIds]){
                map_partId_partName.put(part.id,part.name);
                set_partNames.add(part.name);
            }*/
            //End
            set<String> set_acctIds = new set<String>();
            map<string,string> map_oppyId_accId = new map<string,string>();
            
            //modified by
            //for(opportunity oppy :[select id,AccountId from opportunity where id in:set_oppyIds]){
            for(opportunity oppy : map_oppyId_allOppys.values()){
            	if(set_oppyIds.contains(oppy.Id)) {
	                map_oppyId_accId.put(oppy.id,oppy.AccountId);
	                set_acctIds.add(oppy.AccountId);
            	}
            }
            
            for(Customer_Part_Number__c cpn :[select id,Name,Account__c,Customer_Number__c,Part_Number__c 
                                                        from Customer_Part_Number__c
                                                        where Account__c IN:set_acctIds 
                                                        and Part_Number__c IN:set_partNames]){
                for(Sobject sobj : trgCtx.newList) {
                    Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                    
                    String str_accId    = map_oppyId_accId.containsKey(oppyPart.Opportunity__c) ? map_oppyId_accId.get(oppyPart.Opportunity__c) : null ;
                    String str_partName = map_partId_partName.containsKey(oppyPart.Part__c)     ? map_partId_partName.get(oppyPart.Part__c)     : null ;
                    
                    if(str_accId != null && str_partName != null && str_accId == cpn.Account__c && str_partName == cpn.Part_Number__c){
                        oppyPart.Customer_Part_Number__c = cpn.Customer_Number__c;
                        oppyPart.Customer_Part_Number1__c = cpn.id;
                        oppyPart.Part_Number__c = cpn.Part_Number__c;
                        
                        //system.debug('oppyPart::populateCustomerPartNumber::'+oppyPart);
                    }
                }
                
            }
            
        }
        //trgCtx.isInsert end. 
        
        if(trgCtx.isUpdate){
            //Added by Yiming Shen <yiming.shen@capgemini.com> at 2017-12-07 due to unnecessary queries
            set<String> set_oppyIds = new set<String>();
            set<String> set_partIds = new set<String>();
            map<string,string> map_oppPartId_oppyId = new map<string,string>();
            map<string,string> map_oppPartId_partId = new map<string,string>();
            set<String> set_partNames = new set<String>();
            map<string,string> map_partId_partName = new map<string,string>();
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                set_oppyIds.add(oppyPart.Opportunity__c);
                set_partIds.add(oppyPart.Part__c);
                map_oppPartId_oppyId.put(oppyPart.id,oppyPart.Opportunity__c);
                map_oppPartId_partId.put(oppyPart.id,oppyPart.Part__c);
                map_partId_partName.put(oppyPart.Part__c,oppyPart.Part_Number_txt__c);
                set_partNames.add(oppyPart.Part_Number_txt__c);
            }
            //End
            //Commented by Yiming Shen <yiming.shen@capgemini.com> at 2017-12-07 due to unnecessary queries
            /*set<String> set_oppyPartIds = new set<String>();
            
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                set_oppyPartIds.add(oppyPart.Id);
            }
            
            set<String> set_oppyIds = new set<String>();
            set<String> set_partIds = new set<String>();
            map<string,string> map_oppPartId_oppyId = new map<string,string>();
            map<string,string> map_oppPartId_partId = new map<string,string>();
            
            for(Opportunity_Part__c oppPart : [select id,Opportunity__c,Part__c from Opportunity_Part__c where id IN : set_oppyPartIds]) {
                set_oppyIds.add(oppPart.Opportunity__c);
                set_partIds.add(oppPart.Part__c);
                map_oppPartId_oppyId.put(oppPart.id,oppPart.Opportunity__c);
                map_oppPartId_partId.put(oppPart.id,oppPart.Part__c);
            }
            
            set<String> set_partNames = new set<String>();
            map<string,string> map_partId_partName = new map<string,string>();
            for(Part__c part :[select id,name from Part__c where id in:set_partIds]){
                map_partId_partName.put(part.id,part.name);
                set_partNames.add(part.name);
            }*/
            //End
            set<String> set_acctIds = new set<String>();
            map<string,string> map_oppyId_accId = new map<string,string>();
            
            //modified by Tangyong Li 2018-01-10
            //for(opportunity oppy :[select id,AccountId from opportunity where id in:set_oppyIds]){
            for(opportunity oppy : map_oppyId_allOppys.values()){
            	if(set_oppyIds.contains(oppy.Id)) {
	                map_oppyId_accId.put(oppy.id,oppy.AccountId);
	                set_acctIds.add(oppy.AccountId);
            	}
            }
            
            for(Customer_Part_Number__c cpn :[select id,Name,Account__c,Customer_Number__c,Part_Number__c 
                                                        from Customer_Part_Number__c
                                                        where Account__c IN:set_acctIds 
                                                        and Part_Number__c IN:set_partNames]){
                for(Sobject sobj : trgCtx.newList) {
                    Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                    
                    String str_oppyId    = map_oppPartId_oppyId.containsKey(oppyPart.Id) ? map_oppPartId_oppyId.get(oppyPart.Id) : null ;
                    String str_partId    = map_oppPartId_partId.containsKey(oppyPart.Id) ? map_oppPartId_partId.get(oppyPart.Id) : null ;
                    
                    if(str_oppyId == null || str_partId== null){
                        continue;
                    }
                    
                    String str_accId    = map_oppyId_accId.containsKey(oppyPart.Opportunity__c) ? map_oppyId_accId.get(oppyPart.Opportunity__c) : null ;
                    String str_partName = map_partId_partName.containsKey(oppyPart.Part__c)     ? map_partId_partName.get(oppyPart.Part__c)     : null ;
                    
                    if(str_accId != null && str_partName != null && str_accId == cpn.Account__c && str_partName == cpn.Part_Number__c){
                        oppyPart.Customer_Part_Number__c = cpn.Customer_Number__c;
                        oppyPart.Customer_Part_Number1__c = cpn.id;
                        oppyPart.Part_Number__c = cpn.Part_Number__c;
                        
                        //system.debug('oppyPart::populateCustomerPartNumber::'+oppyPart);
                    }
                }
                
            }
            
        }
        //trgCtx.isUpdate end. 
        
        
    }
    

    /** 
    * Method to update the OppPart.part.name field to point to the part with the name matching the oppPart.part_number__c field 
    * if the Part_number__c field has changed and is no longer the same as OppPart.Part__c.name.
    * Requirement from email:Fixes Needed point 1
    *
    @ author    Buwen Guo
    @ created   2017-10-19
    @ since     38.0
    
    @ changelog
    * 2017-10-19 Buwen Guo <buwen.guo@capgemini.com>
    * - Created
    * 
    */
    /*
    public static void populatePartNameIfPartNumberChanged(ClsWrappers.TriggerContext trgCtx){
        if(trgCtx.isAfter) return;
        
        if(trgCtx.isUpdate){
            set<String> set_oppyPartIds = new set<String>();
            map<string,string> map_NewOppPartId_partNumber = new map<string,string>();
            map<string,string> map_NewOppPartId_partId = new map<string,string>();
            map<string,string> map_NewOppPartId_partName = new map<string,string>();
            map<string,string> map_partId_NewOppPartId = new map<string,string>();
            
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                
                IF(trgCtx.oldMap == null || !trgCtx.oldMap.containsKey(oppyPart.Id)){
                    return ;
                }
                Opportunity_Part__c oppyPart_old = (Opportunity_Part__c)(trgCtx.oldMap.get(oppyPart.Id));
                
                system.debug('oppyPart.Part_number__c::'+oppyPart.Part_number__c);
                system.debug('oppyPart_old.Part_number__c::'+oppyPart_old.Part_number__c);
                if(oppyPart.Part_number__c != null && oppyPart.Part_number__c != '' && oppyPart.Part_number__c != oppyPart_old.Part_number__c){
                    set_oppyPartIds.add(oppyPart.Id);
                    map_NewOppPartId_partNumber.put(oppyPart.Id,oppyPart.Part_number__c);
                }else{
                    return ;
                }
                
                if(oppyPart.Part__c != null && oppyPart_old.Part__c != null && oppyPart.Part__c != oppyPart_old.Part__c){
                    map_NewOppPartId_partId.put(oppyPart.Id,oppyPart.Part__c);
                    map_partId_NewOppPartId.put(oppyPart.Part__c,oppyPart.Id);
                }
            }
            
            if(set_oppyPartIds.size() > 0){
                set<String> set_partIds = new set<String>();
                map<string,string> map_oldOppPartId_partNumber = new map<string,string>();
                map<string,string> map_oldOppPartId_partId = new map<string,string>();
                map<string,string> map_oldOppPartId_partName = new map<string,string>();
                
                for(Opportunity_Part__c oppPart : [select id,Part_number__c,Part__c,part__r.name from Opportunity_Part__c where id IN : set_oppyPartIds]) {
                    set_partIds.add(oppPart.Part__c);
                    map_oldOppPartId_partNumber.put(oppPart.id,oppPart.Part_number__c);
                    map_oldOppPartId_partId.put(oppPart.id,oppPart.Part__c);
                    map_oldOppPartId_partName.put(oppPart.id,oppPart.part__r.name);
                }
                
                for(String str_oppyPartId : set_oppyPartIds){
                    if(map_NewOppPartId_partNumber.containsKey(str_oppyPartId)){
                        if(!map_NewOppPartId_partId.containsKey(str_oppyPartId) && map_oldOppPartId_partId.containsKey(str_oppyPartId)){
                            map_NewOppPartId_partId.put(str_oppyPartId,map_oldOppPartId_partId.get(str_oppyPartId));
                            map_partId_NewOppPartId.put(map_oldOppPartId_partId.get(str_oppyPartId),str_oppyPartId);
                        }
                    }
                }
                
                map<string,string> map_partId_partName = new map<string,string>();
                for(Part__c part :[select id,name from Part__c where id in:map_NewOppPartId_partId.values()]){
                    map_partId_partName.put(part.id,part.name);
                }
                
                for(String str_oppyPartId : set_oppyPartIds){
                    if(map_NewOppPartId_partId.containsKey(str_oppyPartId)){
                        String str_partId = map_NewOppPartId_partId.get(str_oppyPartId);
                        if(map_partId_partName.containsKey(str_partId)){
                            String str_partName = map_partId_partName.get(str_partId);
                            map_NewOppPartId_partName.put(str_oppyPartId,str_partName);
                        }
                    }
                }
                
                Set<String> set_partNameNeedUpdateIds = new set<String>();
                for(String str_oppyPartId : set_oppyPartIds){
                    String str_partNumber = map_NewOppPartId_partNumber.containsKey(str_oppyPartId)? map_NewOppPartId_partNumber.get(str_oppyPartId) : null;
                    String str_partName = map_NewOppPartId_partName.containsKey(str_oppyPartId)? map_NewOppPartId_partName.get(str_oppyPartId) : null;
                    if(str_partNumber != null && str_partName != null && str_partNumber != str_partName){
                        if(map_NewOppPartId_partId.containsKey(str_oppyPartId)){
                            set_partNameNeedUpdateIds.add(map_NewOppPartId_partId.get(str_oppyPartId));
                        }
                    }
                }
            
                if(set_partNameNeedUpdateIds.size() > 0){
                    List<Part__c> list_parts2Update = new List<Part__c>();
                    for(Part__c part :[select id,name from Part__c where id in:set_partNameNeedUpdateIds]){
                        if(map_partId_NewOppPartId.containsKey(part.id) && map_NewOppPartId_partNumber.containsKey(map_partId_NewOppPartId.get(part.id))){
                            part.name = map_NewOppPartId_partNumber.get(map_partId_NewOppPartId.get(part.id));
                            list_parts2Update.add(part);
                        }
                    }
                    if(list_parts2Update.size() > 0){
                        update list_parts2Update;
                    }
                }
            }
        
        }   
    }//populatePartNameIfPartNumberChanged end.
    */
    
    /*------------------------------------------------------------
    Author:        Buwen Guo <buwen.guo@oinio.com>
    Description:   Function to * If the Change_Part_Number__c value is set and is different from the Part__r.name value then
                    1.Update the part (lookup field) to point to the TE part named in the Change_Part_Number__c field 
                    2.Delete the value in the Change_Part_Number__c field
    
                    if change_part_number__c = part__r.name then just delete the change_part_number__c value. 
                    if you can't find the part that is named by Change_part_number__c then don't change the part__c lookup value but just delete the changePartNumber value.
    
                    Requirement from email:Change to Fixes Needed (#1) point 2
    Inputs:        trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2017-10-20  Buwen Guo <buwen.guo@capgemini.com> Created
    ------------------------------------------------------------*/
    public static void changePartNumberHasValueAction(ClsWrappers.TriggerContext trgCtx){
        //system.debug('changePartNumberHasValueAction::'+trgCtx);
        if(trgCtx.isAfter) return;
        
        if(trgCtx.isUpdate){
            set<String> set_oppyPartIds = new set<String>();
            set<String> set_partIds = new set<String>();
            //Added by Yiming Shen <yiming.shen@capgemini.com> at 2017-12-07 due to unnecessary queries
            map<string,string> map_partId_partName = new map<string,string>();
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                set_oppyPartIds.add(oppyPart.Id);
                set_partIds.add(oppyPart.Part__c);
                map_partId_partName.put(oppyPart.Part__c,oppyPart.Part_Number_txt__c);
            }
            //End
            //Commented by Yiming Shen <yiming.shen@capgemini.com> at 2017-12-07 due to unnecessary queries
            /*for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                set_oppyPartIds.add(oppyPart.Id);
                set_partIds.add(oppyPart.Part__c);
            }
            
            map<string,string> map_partId_partName = new map<string,string>();
            for(Part__c part :[select id,name from Part__c where id in:set_partIds]){
                map_partId_partName.put(part.id,part.name);
            }*/
            //End
            set<String> set_newChangePartNumbers = new set<String>();
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                
                if(oppyPart.Change_Part_Number__c != null && oppyPart.Change_Part_Number__c != ''){
                    //System.debug('---map_partId_partName:::' + map_partId_partName);
                    String str_partrName = map_partId_partName.containsKey(oppyPart.Part__c) ? map_partId_partName.get(oppyPart.Part__c) : null;
                    //System.debug('---map_partId_partName.get(oppyPart.Part__c):::' + map_partId_partName.get(oppyPart.Part__c));
                    if(str_partrName != null){
                        if(str_partrName == oppyPart.Change_Part_Number__c){
                            //system.debug('1225::');
                            oppyPart.Change_Part_Number__c = null;
                        }else{
                            //system.debug('1228::');
                            set_newChangePartNumbers.add(oppyPart.Change_Part_Number__c);
                        }
                    }else{
                        //system.debug('1232::');
                        oppyPart.Change_Part_Number__c = null;
                    }
                }else{
                    //system.debug('1236::');
                    return ;
                }
            }
            
            //system.debug('set_newChangePartNumbers::'+set_newChangePartNumbers);
            if(set_newChangePartNumbers.size() > 0){
                map<string,string> map_partName_partId = new map<string,string>();
                for(Part__c part :[select id,name from Part__c where name in:set_newChangePartNumbers]){
                    map_partName_partId.put(part.name,part.id);
                }
                for(Sobject sobj : trgCtx.newList){
                    Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                    if(oppyPart.Change_Part_Number__c != null && oppyPart.Change_Part_Number__c != '' ){
                        if(map_partName_partId.containsKey(oppyPart.Change_Part_Number__c)){
                            //system.debug('1251::');
                            oppyPart.part__c = map_partName_partId.get(oppyPart.Change_Part_Number__c);
                        }
                        //system.debug('1254::');
                        oppyPart.Change_Part_Number__c = null;
                    }
                }
            }
            
        }//if(trgCtx.isUpdate) end.
    }
    
    
    
    /*------------------------------------------------------------
    Author:        Buwen Guo <buwen.guo@oinio.com>
    Description:   Function to transform currency value to opportunity's currencyIsoCode on Opportunity_Part__c
                   Requirement from email:Tweaks to the SAP integration on the Salesforce side point 2
    Inputs:        trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2017-12-01 Buwen Guo <buwen.guo@capgemini.com> Created
    ------------------------------------------------------------*/
    public static void transCurrencyValueForOppyPart(ClsWrappers.TriggerContext trgCtx, map<Id, Opportunity> map_oppyId_allOppys){
        //system.debug('transCurrencyValueForOppyPart::'+trgCtx);
        if(trgCtx.isUpdate){
            set<String> set_oppyIds = new set<String>();
            map<String,String> map_oppyId_currIsoCode = new map<String,String>();
            
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                set_oppyIds.add(oppyPart.opportunity__c);
            }
            
            //modified by Tangyong Li 2018-01-10
            //for(Opportunity op : [select id,currencyIsoCode from opportunity where id IN:set_oppyIds]){
            for(Opportunity op : map_oppyId_allOppys.values()){
            	if(set_oppyIds.contains(op.Id)) {
	                map_oppyId_currIsoCode.put(op.Id,op.currencyIsoCode);
            	}
            }
            
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                
                String currencyIsoCode_oppyPart = oppyPart.currencyIsoCode;
                String currencyIsoCode_oppy     =map_oppyId_currIsoCode.containsKey(oppyPart.opportunity__c)?map_oppyId_currIsoCode.get(oppyPart.opportunity__c):'';
                //System.debug('NDR_Item_Price_Currency__c:: ' + oppyPart.NDR_Item_Price_Currency__c);
                //System.debug('currencyIsoCode_oppy:: ' + currencyIsoCode_oppy);

                if(currencyIsoCode_oppyPart != currencyIsoCode_oppy && currencyIsoCode_oppy != ''){
                    //system.debug('...1');
                    oppyPart.Sales_Price__c = ClsAPLForecastUtil.transformIsoCode(oppyPart.Sales_Price__c,currencyIsoCode_oppyPart,currencyIsoCode_oppy);
                    oppyPart.Offered_Price__c = ClsAPLForecastUtil.transformIsoCode(oppyPart.Offered_Price__c,currencyIsoCode_oppyPart,currencyIsoCode_oppy);
                    oppyPart.currencyIsoCode = currencyIsoCode_oppy;
                    //oppyPart.NDR_Item_Price_Currency__c = currencyIsoCode_oppy;
                    //oppyPart.Sales_Price__c = ClsAPLForecastUtil.transformIsoCode(oppyPart.Sales_Price__c,currencyIsoCode_oppyPart,currencyIsoCode_oppy);
                }
                
                //Modified by Buwen Guo 2017-12-01 
                //Requirement from email:Tweaks to the SAP integration on the Salesforce side point 3
                //Delete by Buwen Guo 2018-02-09 from email:Let's do some REAL coding again! point 3
                /*  
                Decimal dec_pricePer = 0;
                if(oppyPart.NDR_Item_Price_Per__c != null){
                    dec_pricePer = Decimal.valueOf(oppyPart.NDR_Item_Price_Per__c);
                }
                
                if(dec_pricePer != 0 && dec_pricePer != 1){
                    oppyPart.Sales_Price__c = oppyPart.Sales_Price__c / dec_pricePer;
                    oppyPart.NDR_Item_Price_Per__c = '1';
                }
                */
                
                //system.debug('transCurrencyValueForOppyPart::'+oppyPart.NDR_Item_Price_Per__c);
                //system.debug('oppyPart.Id::'+oppyPart.Id+'::Sales_Price__c::'+oppyPart.Sales_Price__c);
                //system.debug('oppyPart.Id::'+oppyPart.Id+'::Offered_Price__c::'+oppyPart.Offered_Price__c);
            }
            
        }
    }
    
    
    
    /*------------------------------------------------------------
    Author:        Buwen Guo <buwen.guo@oinio.com>
    Description:   The target Price (offered_price__c) on the Opportunity Part should be set to the default value of the new CustStdPrice (when the price comes back from the ERP),
                    IF (and only if) the targetPrice is currently zero.   
                    In other words, if the user has already set a targetPrice then we should respect that and not touch it.  
                    But if it's zero then we can initialize the TargetPrice to be the same as CustStdPrice value.
                   Requirement from email:Issues to fix 11/21 point 4
    Inputs:        trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2017-11-28 Buwen Guo <buwen.guo@capgemini.com> Created
    ------------------------------------------------------------*/
    public static void resetTargetPrice(ClsWrappers.TriggerContext trgCtx){
        if(trgCtx.isAfter) return;
        //system.debug('resetTargetPrice::'+trgCtx);
        if(!trgCtx.isDelete){
            
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                
                if(oppyPart.Offered_Price__c == null || oppyPart.Offered_Price__c == 0 ){
                    oppyPart.Offered_Price__c = oppyPart.Sales_Price__c;
                    //system.debug('resetTargetPrice::oppyPart.Offered_Price__c'+oppyPart.Offered_Price__c);
                }
                //system.debug('resetTargetPrice1::'+oppyPart.Offered_Price__c);
                //system.debug('resetTargetPrice2::'+oppyPart.Sales_Price__c);
                //system.debug('resetTargetPrice3::'+oppyPart);
            }

        }
    }
    
    
    /*------------------------------------------------------------
    Author:        Buwen Guo <buwen.guo@oinio.com>
    Description:   If the OppPart Quantity or Target Price (offered_price__c) is updated (or if a new OppPart is added) 
                    then you should set OppPart.Changed_since_quote_integration__c to TRUE).  
                   Requirement from email:A lower priority item for now: SAP Quote Revision point 3
    Inputs:        trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2017-12-08 Buwen Guo <buwen.guo@capgemini.com> Created
    ------------------------------------------------------------*/
    public static void setChangedSinceQuoteIntegration(ClsWrappers.TriggerContext trgCtx){
        if(trgCtx.isAfter) return;
        //system.debug('setChangedSinceQuoteIntegration::');
        
        if(trgCtx.isInsert){
            
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                oppyPart.Changed_since_quote_integration__c = true;
            }

        }
        //IsInsert End.
        
        if(trgCtx.isUpdate){
            
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                Opportunity_Part__c oldOppyPart = (Opportunity_Part__c)trgCtx.oldMap.get(oppyPart.Id);
                
                if(oppyPart.Quantity__c != oldOppyPart.Quantity__c || oppyPart.Offered_Price__c != oldOppyPart.Offered_Price__c ){
                    oppyPart.Changed_since_quote_integration__c = true;
                    //system.debug('setChangedSinceQuoteIntegration::oppyPart.Changed_since_quote_integration__c'+oppyPart.Changed_since_quote_integration__c);
                }
            }

        }
        //IsUpdate End.
    }
    
    
    
    /*------------------------------------------------------------
    Author:        Buwen Guo <buwen.guo@oinio.com>
    Description:   if a part qty is requested that is less than the MOQ then the qty is raised up to the MOQ value.
                   Requirement from email:12/13 Issues point 7
    Inputs:        trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2017-12-08 Buwen Guo <buwen.guo@capgemini.com> Created
    ------------------------------------------------------------*/
    public static void updateQuantityToMOQ(ClsWrappers.TriggerContext trgCtx){
        if(trgCtx.isAfter) return;
        //system.debug('updateQuantityToMOQ::');
        
        if(trgCtx.isInsert || trgCtx.isUnDelete || trgCtx.isUpdate){
            set<String> set_partIds = new set<String>();
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                set_partIds.add(oppyPart.part__c);
            }
            
            map<String,Part__c> map_partId_part = new map<String,Part__c>();
            
            for(Part__c p :[select id,Min_Order_Qty__c from Part__c where id IN :set_partIds]){
                map_partId_part.put(p.id,p);
            }
            
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                Part__c p = null;
                if(map_partId_part.containsKey(oppyPart.part__c)){
                    p = map_partId_part.get(oppyPart.part__c);
                }
                //system.debug('updateQuantityToMOQ:-:p::'+p);
                //system.debug('updateQuantityToMOQ:-:oppyPart.part__c::'+oppyPart.part__c);
                //system.debug('updateQuantityToMOQ:-:p.id::'+p.id);
                //system.debug('updateQuantityToMOQ:-:oppyPart.Quantity__c::'+oppyPart.Quantity__c);
                //system.debug('updateQuantityToMOQ:-:p.Min_Order_Qty__c::'+p.Min_Order_Qty__c);
                if(p != null && oppyPart.part__c == p.id && oppyPart.Quantity__c < p.Min_Order_Qty__c){
                    oppyPart.Quantity__c = p.Min_Order_Qty__c;
                    oppyPart.TotalPrice__c = oppyPart.Offered_Price__c == null? 0 : oppyPart.Quantity__c * oppyPart.Offered_Price__c;
                    //system.debug('updateQuantityToMOQ::oppyPart.Quantity__c'+oppyPart.Quantity__c);
                    //system.debug('updateQuantityToMOQ::oppyPart.TotalPrice__c'+oppyPart.TotalPrice__c);
                }
            }
            

        }
    }
    
    
    /*------------------------------------------------------------
    Author:        Buwen Guo <buwen.guo@oinio.com>
    Description:   set opportunity_part.standard_cost__c for AMPICS opportunity.
    Inputs:        trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2017-12-15     Buwen Guo <buwen.guo@capgemini.com> Created
    ------------------------------------------------------------*/
    public static void updateStandardCost(ClsWrappers.TriggerContext trgCtx, map<Id, Opportunity> map_oppyId_allOppys){
        if(trgCtx.isAfter) return;
        //system.debug('updateStandardCost::');
        if(trgCtx.isInsert || trgCtx.isUnDelete || trgCtx.isUpdate){
            set<String> set_partIds = new set<String>();
            set<String> set_oppyIds = new set<String>();
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                set_partIds.add(oppyPart.part__c);
                set_oppyIds.add(oppyPart.opportunity__c);
            }
            
            set<String> set_ampicsOppyIds = new set<String>();
            
            //modified by Tangyong Li 2018-01-10
            //for(Opportunity op :[select id,erp_for_pricing__c from Opportunity where id IN :set_oppyIds and erp_for_pricing__c = 'Ampics' ]){
            for(Opportunity op : map_oppyId_allOppys.values()){
            	if(set_oppyIds.contains(op.Id) && op.Erp_For_Pricing__c == 'ANZPAC') {
	                set_ampicsOppyIds.add(op.id);
            	}
            }
            
            map<String,Part__c> map_partId_part = new map<String,Part__c>();
            for(Part__c p :[select id,Curr_CS_75__c,CurrencyIsoCode from Part__c where id IN :set_partIds]){
                map_partId_part.put(p.id,p);
            }
            
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                String str_oppyId = oppyPart.opportunity__c;
                
                if(set_ampicsOppyIds.contains(str_oppyId)){
                    Part__c p = null;
                    if(map_partId_part.containsKey(oppyPart.part__c)){
                        p = map_partId_part.get(oppyPart.part__c);
                    }
                    if(p != null && oppyPart.part__c == p.id && (oppyPart.Standard_cost__c == null || oppyPart.Standard_cost__c == 0 )){
                        //oppyPart.Standard_cost__c = ClsAPLForecastUtil.transformIsoCode(p.Curr_CS_75__c,p.CurrencyIsoCode,oppyPart.CurrencyIsoCode);
                        //system.debug('updateStandardCost::oppyPart.Standard_cost__c::'+oppyPart.Standard_cost__c);
                    }
                }
            }
        }
    }
    
    
    /*------------------------------------------------------------
    Author:        Buwen Guo <buwen.guo@oinio.com>
    Description:   set GPL__c for oppy parts from part__r.Product_Hierarchy__c
    Inputs:        trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2017-01-18 Buwen Guo <buwen.guo@capgemini.com> Created
    ------------------------------------------------------------*/
    public static void setGplForOppyParts(ClsWrappers.TriggerContext trgCtx){
        if(trgCtx.isAfter) return;
        //system.debug('setGplForOppyParts::');
        
        if(trgCtx.isInsert){
            set<String> set_partIds = new set<String>();
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                if(oppyPart.part__c != null){
					set_partIds.add(oppyPart.part__c);
                }
            }
            
            map<String,String> map_part_gpl = new map<String,String>();
            for(part__c p : [select id,Product_Hierarchy__c from part__c where id IN :set_partIds]){
            	map_part_gpl.put(p.Id,p.Product_Hierarchy__c);
            }
            
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                if(oppyPart.part__c != null && map_part_gpl.containsKey(oppyPart.part__c)){
					oppyPart.GPL__c = map_part_gpl.get(oppyPart.part__c);
                }
            }

        }
        //IsInsert End.
    }
    
    
    /*------------------------------------------------------------
    Author:        Buwen Guo <buwen.guo@oinio.com>
    Description:   On the OppPart trigger, if the ERP_Pricing_status is CHANGED to DataReceived then you should set the isCloned flag to false 
    				(so future updates to the opp won't trigger a repricing call)
                   Requirement from email:Cloning Opportunities: IR-03861 point 4
    Inputs:        trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2018-03-27	Buwen Guo <buwen.guo@capgemini.com> Created
    ------------------------------------------------------------*/
    public static void resetIsClonedAfterCallout(ClsWrappers.TriggerContext trgCtx){
        if(trgCtx.isAfter) return;
        system.debug('resetIsClonedAfterCallout::');
        
        if(trgCtx.isUpdate){
            
            for(Sobject sobj : trgCtx.newList) {
                Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
                Opportunity_Part__c oldOppyPart = (Opportunity_Part__c)trgCtx.oldMap.get(oppyPart.Id);
                
                if(oppyPart.ERP_Pricing_Status__c != oldOppyPart.ERP_Pricing_Status__c && oppyPart.ERP_Pricing_Status__c == 'Data Received' ){
                    oppyPart.isCloned__c = false;
                    system.debug('resetIsClonedAfterCallout::oppyPart.isCloned__c'+oppyPart.isCloned__c);
                }
            }

        }
        //IsUpdate End.
    }
    
    /*------------------------------------------------------------
	Author:        Tangyong Li <tangyong.li@capgemini.com>
	Description:   get opportunity parts base up Opportunity_Part__c.Opportunity__c
	Returns:       map<Id, Opportunity_Part__c>
	History
	2018-01-15 	   Tangyong Li <tangyong.li@capgemini.com> created
	------------------------------------------------------------*/
    public static map<Id, Opportunity_Part__c> getOpportunityPartsBaseupId(Map<Id,Opportunity> map_OppyId_Oppy) {
    	Map<Id, Opportunity_Part__c> map_OppyPartId_OppyPart = new Map<Id, Opportunity_Part__c>();
    	Set<Id> set_OppyIds = map_OppyId_Oppy.keySet();
    	if(!set_OppyIds.isEmpty()) {
    		for(Opportunity_Part__c oppyPart : [SELECT Id, Opportunity__c, 
    											Opportunity__r.Approval_Status__c,
												Approval_Status__c, 
												NDR_Item_Number__c,
												Standard_Cost__c, 
												Offered_Price__c, 
												Total_Price__c,
												Quantity__c,
												//Fraction_of_sale__c, 
                                                Opportunity__r.StageName, 
                                                Opportunity__r.RecordType.DeveloperName,
                                                opportunity__r.createdDate,
												Status__c
    											FROM Opportunity_Part__c 
    											WHERE Opportunity__c IN: set_OppyIds]) {
    			//system.debug('oppyPart::::   ' + oppyPart.Approval_Status__c);
    			map_OppyPartId_OppyPart.put(oppyPart.Id, oppyPart);
    		}
    	}
    	return map_OppyPartId_OppyPart; 
    }
    
    /*------------------------------------------------------------
	Author:        Tangyong Li <tangyong.li@capgemini.com>
	Description:   get opportunities base up Opportunity_Part__c.Opportunity__c
	Returns:       map<Id, Opportunity>
	History
	2018-01-10 	   Tangyong Li <tangyong.li@capgemini.com> created
	------------------------------------------------------------*/
    public static map<Id, Opportunity> getOpportunitiesBaseupId(ClsWrappers.TriggerContext trgCtx) {
    	set<Id> set_oppyIds = new set<Id>();
    	map<Id, Opportunity> map_oppyId_allOppys = new map<Id, Opportunity>();
    	if(trgCtx.isDelete) {
	    	for(Sobject sobj : trgCtx.oldList) {
	            Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
	            set_oppyIds.add(oppyPart.opportunity__c);
	        }
    	} else {
	    	for(Sobject sobj : trgCtx.newList) {
	            Opportunity_Part__c oppyPart = (Opportunity_Part__c)sobj;
	            set_oppyIds.add(oppyPart.opportunity__c);
	        }
    	}
    	if(!set_oppyIds.isEmpty()) {
    		for(Opportunity oppy : [SELECT Id, Margin__c, ERP_For_Pricing__c, Approval_Status__c, Account.Source_System__c, 
    									Account.RecordTypeId, Account.Recordtype.Name, AccountId, Account.Name, 
    									Account.Distribution_Channel_Cde__c, Account_Number__c, Account.AccountNumber, 
    									Account.Sales_Organization_ID__c, CurrencyIsoCode, Quote_Type__c, SAP_Quote_Type__c,
    									createdDate
    								FROM Opportunity WHERE Id IN: set_oppyIds]) {
    			map_oppyId_allOppys.put(oppy.Id, oppy);
    		}
    	}
    	return map_oppyId_allOppys;
    }
    
    /*------------------------------------------------------------
	Author:        Tangyong Li <tangyong.li@capgemini.com>
	Description:   Trigger defense for OpportunityTrgHandler and OpportunityPartTrgHandler.
	Returns:       true - skip triggers
				   false - not skip       
	History
	2017-12-28 	   Tangyong Li <tangyong.li@capgemini.com> created
	------------------------------------------------------------*/
    public static Boolean avoidOppyPartMultipleRunning(ClsWrappers.TriggerContext trgCtx) {
    	Boolean isAvoidRunning = false;
    	if(trgCtx.isBefore) {
    		if(trgCtx.isInsert || trgCtx.isUndelete) {
    			if(isMultipleBeforeInsert) {
    				isAvoidRunning = true;
    			} else {
    				isMultipleBeforeInsert = true;
    			}
    		} else if(trgCtx.isUpdate) {
    			if(isMultipleBeforeUpdate) {
    				isAvoidRunning = true;
    			} else {
    				isMultipleBeforeUpdate = true;
    			}
    		} else if(trgCtx.isDelete) {
    			if(isMultipleBeforeDelete) {
    				isAvoidRunning = true;
    			} else {
    				isMultipleBeforeDelete = true;
    			}
    		}
    	} else if(trgCtx.isAfter) {
    		if(trgCtx.isInsert || trgCtx.isUndelete) {
    			if(isMultipleAfterInsert) {
    				isAvoidRunning = true;
    			} else {
    				isMultipleAfterInsert = true;
    			}
    		} else if(trgCtx.isUpdate) {
    			if(isMultipleAfterUpdate) {
    				isAvoidRunning = true;
    			} else {
    				isMultipleAfterUpdate = true;
    			}
    		} else if(trgCtx.isDelete) {
    			if(isMultipleAfterDelete) {
    				isAvoidRunning = true;
    			} else {
    				isMultipleAfterDelete = true;
    			}
    		}
    	}
    	return isAvoidRunning;
    }
    
}