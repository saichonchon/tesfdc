({
	helperMethod : function() {
		
	},
    
    doInit: function(comp, event) {
        
	},

    handlerisMassChange: function(comp, event) {
    	var popupOptions=comp.get('v.popupOptions');
        
        if(!comp.get('v.isMass')){
            return;
        }
		
        $A.util.addClass(comp.find('dndatm'), 'slds-hide');
        $A.util.addClass(comp.find('dndadm'), 'slds-hide');
        $A.util.addClass(comp.find('wonDateBox'), 'slds-hide');
        $A.util.addClass(comp.find('lostReasonTextBox'), 'slds-hide');
        $A.util.addClass(comp.find('reasonBox'), 'slds-hide');
        $A.util.addClass(comp.find('competitorBox'), 'slds-hide');
        
        var that=this, list_Confidence=popupOptions['list_Confidence'], opp=comp.get('v.opportunity'), profile=comp.get('v.profile'),
        	list_tmpConfidence=comp.get('v.list_Confidence'), list_ProcessStatus=comp.get('v.list_ProcessStatus'), map_confidence=popupOptions['map_confidence'];
        
        
        list_Confidence = that.checkOptions(profile, opp, list_Confidence, map_confidence);

        if(list_tmpConfidence.join('=') != list_Confidence.join('=')){
        	comp.set('v.list_Confidence', list_Confidence);
        }

        var map_ps=that.getProcessStatus(opp['RecordType']['DeveloperName'], profile['Name'], {}),
            list_processStatus=that.getListProcessStatus(opp['RecordType']['DeveloperName'], profile['Name'], map_ps[list_Confidence[0]], map_confidence);

        if(list_ProcessStatus.join('=') != list_processStatus.join('=')){
        	comp.set('v.list_ProcessStatus', list_processStatus);
        }
        
        if(opp['RecordType']['DeveloperName'] == 'DND_Opportunity' || opp['RecordType']['DeveloperName'] == 'ADM'){
            if(list_Confidence[0] == 'Won'){
                $A.util.removeClass(comp.find('dndadm'), 'slds-hide'); 
                $A.util.removeClass(comp.find('competitorBox'), 'slds-hide'); 
            }
        }
        
	},

    handleDateChangeEvt: function(comp, event) {
		var value=event.getParam('value'), id=event.getParam('sid');

        switch(id){
        	case 'billingDate': comp.set('v.billingDate', value); break;
            case 'orderDate': comp.set('v.orderDate', value); break;
        }
	},
    
    event_confidence_change: function(comp, event) {
		
        $A.util.addClass(comp.find('dndatm'), 'slds-hide');
        $A.util.addClass(comp.find('dndadm'), 'slds-hide');
        $A.util.addClass(comp.find('wonDateBox'), 'slds-hide');
        $A.util.addClass(comp.find('lostReasonTextBox'), 'slds-hide');
        $A.util.addClass(comp.find('reasonBox'), 'slds-hide');
        $A.util.addClass(comp.find('competitorBox'), 'slds-hide');
        
        var that=this, target=event.currentTarget, value=target.options[target.selectedIndex].value, opp=comp.get('v.opportunity'), 
            popupOptions=comp.get('v.popupOptions'), profile=comp.get('v.profile')['Name'], map_LostReasons=comp.get('v.map_LostReasons'),
            map_ProcessStatus=that.getProcessStatus(opp['RecordType']['DeveloperName'], profile, {}), map_confidence={},
            select=document.querySelector('#ProcessStatus'), status=select.options[select.selectedIndex].value;

        map_confidence[value] = {'confidence': value, 'status': status};
		
        console.log('map_confidence', map_confidence);
        
        var list_options=that.getListProcessStatus(opp['RecordType']['DeveloperName'], profile, map_ProcessStatus[value], map_confidence);
                                 
        comp.set('v.searchString', '');
        comp.set('v.billingDate', '');
        comp.set('v.orderDate', '');
        comp.set('v.list_ProcessStatus', list_options);
        
        if(opp['RecordType']['DeveloperName'] == 'DND_Opportunity'){
            if(value == 'Dead' || value == 'Lost'){
                $A.util.removeClass(comp.find('dndatm'), 'slds-hide');
            }
        }
        
        if(opp['RecordType']['DeveloperName'] == 'DND_Opportunity' || opp['RecordType']['DeveloperName'] == 'ADM'){
            if(value == 'Won'){
                $A.util.removeClass(comp.find('dndadm'), 'slds-hide'); 
                $A.util.removeClass(comp.find('competitorBox'), 'slds-hide'); 
            }
        }
        
        if(value == 'Lost'){
            $A.util.removeClass(comp.find('competitorBox'), 'slds-hide');
        }
        
        if(value == 'Dead' || value == 'Lost'){
            comp.set('v.list_LostReasons', map_LostReasons[value]);
            $A.util.removeClass(comp.find('reasonBox'), 'slds-hide');
        }else{
            comp.set('v.list_LostReasons', []);
        }
        
        comp.find('removeValueBtn').getElement().click();
		  
        setTimeout(function(){
        	$(comp.find('lostReason').getElement()).find('option:eq(0)').prop('selected', true);
        }, 600);
        
        
	},
    event_processStatus_change: function(comp, event) {
		var target=event.currentTarget, value=target.options[target.selectedIndex].value, wonDateBox=comp.find('wonDateBox'), 
			opp=comp.get('v.opportunity'), rtName=opp['RecordType']['DeveloperName'];
			
        $A.util.addClass(wonDateBox, 'slds-hide');
        
        if(value == 'Production'){
            
            if(rtName == 'DND_Opportunity' || rtName == 'ADM'){
                return;
            }
            
            $A.util.removeClass(wonDateBox, 'slds-hide');
        }
	},
	
	event_lostReasons_change: function(comp, event) {
		var target=event.currentTarget, value=target.options[target.selectedIndex].value, compLostReason=comp.find('lostReasonTextBox');
		
		$A.util.addClass(compLostReason, 'slds-hide');
		
        if(value == 'Other'){
            $A.util.removeClass(compLostReason, 'slds-hide');
        }
	},
	
    event_save_click: function(comp, event) {

        var hasWon=$A.util.hasClass(comp.find('wonDateBox'), 'slds-hide'),
        	hasCompetitor=$A.util.hasClass(comp.find('competitorBox'), 'slds-hide'),
        	hasLostReasonText=$A.util.hasClass(comp.find('lostReasonTextBox'), 'slds-hide'),
        	hasDndadm=$A.util.hasClass(comp.find('dndadm'), 'slds-hide');
        	
        var orderDate=comp.get('v.orderDate'), billingDate=comp.get('v.billingDate'), 
        	competitor=comp.find('competitor').getElement(),
        	massLostReasonText=comp.find('massLostReasonText').getElement(),
        	teShipsetPercenttageInput=comp.find('teShipsetPercenttageInput').getElement(),
        	teShipsetPercenttageInputValue=parseFloat(teShipsetPercenttageInput.value);
        	
        var o={}, popupOptions=comp.get('v.popupOptions');
    	
        if(checkFocus(hasWon, billingDate, 'Initial_Billing_Date__c')){
        	comp.find('billingDate').getElement().querySelector('input[type="text"]').focus();
        	return;
        }
        
        if(checkFocus(hasWon, orderDate, 'Initial_Order_Date__c')){
        	comp.find('orderDate').getElement().querySelector('input[type="text"]').focus();
        	return;
        }
        
        if(checkFocusDouble(hasDndadm, teShipsetPercenttageInputValue, 'ADM_TE_Shipset_Percentage__c')){
        	teShipsetPercenttageInput.focus();
        	return;
        }
        
        var competitorValue=competitor.getAttribute('data-id');
        if(checkFocus(hasCompetitor, competitorValue, 'Competitor__c')){
        	competitor.focus();
        	return;
        }

        if(checkFocus(hasLostReasonText, massLostReasonText.value, 'Lost_Reason_Text__c')){
        	massLostReasonText.focus();
        	return;
        }
        
        if(!hasDndadm){
        	var wonReason=comp.find('wonReason').getElement();
        	o['Won_Reason__c'] = wonReason.options[wonReason.selectedIndex].value;
        }
        
        
        if(!$A.util.hasClass(comp.find('reasonBox'), 'slds-hide')){
        	var reasonBox=comp.find('lostReason').getElement();
        	o['Lost_Reason__c'] = reasonBox.options[reasonBox.selectedIndex].value;
        }
        
        if(!$A.util.hasClass(comp.find('dndatm'), 'slds-hide')){
        	var tamCheckbox=comp.find('massAvailableforTAMckBox').getElement();
        	o['Available_for_TAM__c'] = tamCheckbox.checked;
        }
        
        var confidence=comp.find('confidence').getElement(), processStatus=comp.find('processStatus').getElement(),
        	popupEvent=comp.getEvent("popupEvent");
        
        o['confidence'] = confidence.options[confidence.selectedIndex].value;
        o['processStatus'] = processStatus.options[processStatus.selectedIndex].value
        o['competitorId'] = (competitorValue == 'null' ? null : competitorValue);
        
        
        console.log('o', o);
		
        popupEvent.setParams({'sJson': JSON.stringify({'type': 'massupdateChange', 'value': JSON.stringify(o)}) });	//aplPartChange
        popupEvent.fire();	// Fire the event
        
        popupOptions['isAPLOpen'] = false;
        popupOptions['isRequired'] = false;
        popupOptions['list_Confidence'] = [];
		comp.set('v.popupOptions', popupOptions);
		
		
		
		
		;function checkFocusDouble(check, v, field){
			
			if(check){
				return false;
			}
			
			if(v !== +v){
				return true;
			}
			o[field] = v;
			
			return false;
		}
		
		;function checkFocus(check, v, field){
			if(field == 'Competitor__c' && !popupOptions['isRequired']){
				o[field] = null;
				return false;
			}
			if(check){
				return false;
			}
			
			if(v == null || v == ''){
				return true;
			}
			o[field] = (v == 'null' ? null : v);
			
			return false;
		}
		
		
		
		
	},
        
    event_competitorSearch_keyup: function(comp, event) {
        comp.set('v.searchString', event.currentTarget.value);
        var auraSpinner=comp.find('spinnerStatus'), lookupList=comp.find('lookuplist'), searchString=comp.get('v.searchString');
        
        $A.util.removeClass(auraSpinner, 'slds-hide'); 
        if (typeof searchString === 'undefined' || searchString.length < 2) {
            $A.util.removeClass(lookupList, 'slds-show');
            return;
        }
        
        if(searchString == 'null'){
        	comp.set("v.searchString", 'null');
        	
        	comp.find('competitor').getElement().setAttribute('data-id', 'null');
        	
	        $A.util.removeClass(comp.find("lookuplist"), 'slds-show');
	        $A.util.addClass(comp.find('lookup'), 'slds-hide');
	        $A.util.removeClass(comp.find("lookup-pill"), 'slds-hide');
	        $A.util.addClass(comp.find('lookup-div'), 'slds-has-selection');
        	return;
        }
        
        $A.util.addClass(lookupList, 'slds-show');
        var action=comp.get('c.searchCompetitor');
        
        action.setAbortable();
        action.setParams({ "param" : JSON.stringify({'competitorName': event.currentTarget.value}) });	

        action.setCallback(this, function(response) { 
            var state = response.getState();
            $A.util.addClass(auraSpinner, 'slds-hide');
            if (comp.isValid() && state === "SUCCESS") { 
                var matches = response.getReturnValue(); 
                if (matches.list_Competitors.length == 0) { 
                    comp.set('v.list_result', null);
                    return;
                }
                comp.set('v.list_result', matches.list_Competitors); 
            } else if (state === "ERROR") { 
                var errors = response.getError(), message='Unknown error.';
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        message=errors[0].message;
                    }
                }
                console.log('LtngOpportunityForecastCtrl searchCompetitor->', message);
            }
        });
        
        $A.enqueueAction(action);// Enqueue the action
        
	},
    
    event_competitorClear_click: function(comp, event) {
        
        var competitor=comp.find('competitor').getElement(); //document.getElementById('competitor');
        competitor.setAttribute('data-id', '');
		comp.set("v.searchString", ''); 

        var lookupPill = comp.find("lookup-pill"); 
        $A.util.addClass(lookupPill, 'slds-hide');

        var inputElement = comp.find('lookup'); 
        $A.util.removeClass(inputElement, 'slds-hide');

        var inputElement = comp.find('lookup-div'); 
        $A.util.removeClass(inputElement, 'slds-has-selection');
	},
    
    event_competitorSelect_click: function(comp, event) {
		var objectId=this.resolveId(event.currentTarget.id), objectLabel=event.currentTarget.innerText,
            competitor=comp.find('competitor').getElement(); //document.getElementById('competitor');
        
        comp.set("v.searchString", objectLabel);
        competitor.setAttribute('data-id', objectId);
        
        var lookupList = comp.find("lookuplist");
        $A.util.removeClass(lookupList, 'slds-show');

        var inputElement = comp.find('lookup');
        $A.util.addClass(inputElement, 'slds-hide');

        var lookupPill = comp.find("lookup-pill");
        $A.util.removeClass(lookupPill, 'slds-hide');

        var inputDiv = comp.find('lookup-div');
        $A.util.addClass(inputDiv, 'slds-has-selection');
	},
    
    resolveId : function(elmId) {
        var i = elmId.lastIndexOf('_');
        return elmId.substr(i+1);
    },
    
    getListProcessStatus: function(rtName, profile, list_options, map_confidence){
    	
    	list_options = (list_options ? list_options : []);
    	
        switch (true) {
			
			case (rtName == 'Opportunity_Engineering_Project' || rtName == 'Opportunity_Sales_Parts_Only' || 
				  rtName == 'Opportunity_Product_Platform' || rtName == 'TAM') : 
					  if(profile == 'Appliance User w/ Cost' || profile == 'Appliance Standard User' || profileName == 'Appliance Inside Sales Playbook User' || profile == 'Appliance Engineering User w/Cost'){
                          if(map_confidence.hasOwnProperty('Won') && map_confidence['Won']['status'] == 'Production'){
                              list_options = list_options.join('___').replace('Pre-prod___', '').split('___');
                          }
					  }else if( (rtName == 'Opportunity_Engineering_Project' || rtName == 'Opportunity_Sales_Parts_Only') && (profile == 'Medical Standard User' || profile == 'Medical User w/Cost')) {
                          if(map_confidence.hasOwnProperty('Won') && map_confidence['Won']['status'] == 'Production'){
                              list_options = list_options.join('___').replace('Pre-prod___', '').split('___');
                          }
                      }
				
				break;
			case (rtName == 'DND_Opportunity' ) : 
                if(map_confidence.hasOwnProperty('Won') && map_confidence['Won']['status'] == 'Production'){
                    list_options = list_options.join('___').replace('Pre-prod___', '').split('___');
                }
				break;
			case (rtName == 'Channel_Engineering_Opportunity' || rtName == 'Channel_Sales_Opportunity' || 
				  rtName == 'CCR_Opportunity' || rtName == 'NDR_Opportunity') :
	    				
		    		if(profile == 'Channel Distributor Portal Manager' || profile == 'Channel Distributor Portal User' || 
						profile == 'Channel Inside Sales' || profile == 'Channel Insidesales Power - Dialer' || profile == 'Channel Standard User'){
						
                        console.log('map_confidence', map_confidence);
                        
                        for(var key in map_confidence){
                            switch(key){
                                case 'Weak' : list_options = ['Concept']; break;
                                case '50/50' : list_options = ['Prototyped/Sampled']; break;
                                case 'Likely' : list_options = ['Quoted']; break;
                                case 'Commit' : list_options = ['Pre-prod']; break;
                                case 'Won' : list_options = ['Production']; break;
                                case 'Dead' : list_options = ['Dead']; break;
                                case 'Lost' : list_options = ['Lost']; break;
                            }
                            break;
                        }
					}
	    		
	    		break;
			case (rtName == 'IND_Engineering_project' || rtName == 'IND_Sales_Project') :
			
	    			list_Confidence = ['50/50', 'Won', 'Dead', 'Lost'];
	    			
	    		break;
			case (rtName == 'ADM') :
	    			if(profile == 'ADM Standard User' || profile == 'ADM User w/ cost'){
	    				if(map_confidence.hasOwnProperty('Won') && map_confidence['Won']['status'] == 'Production'){
		    				list_options = list_options.join('___').replace('Pre-prod___', '').split('___');
		    			}
                    }
	    		break;
			
			default:
				break;
			
		}
		
        return list_options;
    },
    
    getProcessStatus: function(rtName, profile, map_ps){

    	if(profile == 'BU Admin' || profile == 'BU Analyst' || profile == 'Developer' || profile == 'Production Support' || profile == 'System Administrator'){
    		map_ps = {
				'On Hold' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted', 'On Customer AVL'],
				'Weak' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted', 'On Customer AVL'],
				'50/50' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted', 'On Customer AVL', 'Prototyped', 'Sampled'],
				'Likely' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted', 'On Customer AVL'],
				'Commit' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted', 'On Customer AVL', 'Pre-prod'],
				'Won' : ['Pre-prod', 'Production', 'Ramp Down', 'EOL'],
				'Dead' : ['Concept', 'Designed', 'Dead', 'Demo', 'Prototyped/Sampled', 'Quoted', 'On Customer AVL'],
				'Lost' : ['Concept', 'Designed', 'Lost', 'Demo', 'Prototyped/Sampled', 'Quoted', 'On Customer AVL']
			};
    		return map_ps;
    	}
    	
    	switch(true){
    		case (rtName == 'Opportunity_Engineering_Project' || rtName == 'Opportunity_Sales_Parts_Only' || rtName == 'Opportunity_Product_Platform' || rtName == 'TAM') :
	    		if(profile == 'Appliance User w/ Cost' || profile == 'Appliance Standard User' || profileName == 'Appliance Inside Sales Playbook User' || profile == 'Appliance Engineering User w/Cost'){
                    map_ps = {
	    				'On Hold' : ['Concept', 'Designed'],
	    				'Weak' : ['Concept', 'Designed'],
	    				'50/50' : ['Concept', 'Designed'],
	    				'Likely' : ['Concept', 'Designed'],
	    				'Commit' : ['Concept', 'Designed'],
	    				'Won' : ['Pre-prod', 'Production', 'Ramp Down', 'EOL'],
	    				'Dead' : ['Concept', 'Designed'],
	    				'Lost' : ['Concept', 'Designed']
	    			};
                }else if( (rtName == 'Opportunity_Engineering_Project' || rtName == 'Opportunity_Sales_Parts_Only') && (profile == 'Medical Standard User' || profile == 'Medical User w/Cost')) {
					map_ps = {
	    				'On Hold' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted'],
	    				'Weak' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted'],
	    				'50/50' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted'],
	    				'Likely' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted'],
	    				'Commit' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted'],
	    				'Won' : ['Pre-prod', 'Production', 'Ramp Down', 'EOL'],
	    				'Dead' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted'],
	    				'Lost' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted']
	    			};
                }
                	
    			break;
    			
    		case (rtName == 'Channel_Engineering_Opportunity' || rtName == 'Channel_Sales_Opportunity' || rtName == 'CCR_Opportunity' || rtName == 'NDR_Opportunity') :
	    			map_ps = {
	    				'On Hold' : [],
	    				'Weak' : ['Concept'],
	    				'50/50' : ['Prototyped/Sampled'],
	    				'Likely' : ['Quoted'],
	    				'Commit' : ['Pre-prod'],
	    				'Won' : ['Production'],
	    				'Dead' : ['Dead'],
	    				'Lost' : ['Lost']
	    			};
    			break;
    			
    		case (rtName == 'ADM') :
	    			map_ps = {
	    				'On Hold' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted'],
	    				'Weak' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted'],
	    				'50/50' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted'],
	    				'Likely' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted'],
	    				'Commit' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted'],
	    				'Won' : ['Pre-prod', 'Production'],
	    				'Dead' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted'],
	    				'Lost' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted']
	    			};
    			break;
    			
    		case (rtName == 'Opportunity_Engineering_Project' || rtName == 'Opportunity_Sales_Parts_Only') :
	    			map_ps = {
	    				'On Hold' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted'],
	    				'Weak' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted'],
	    				'50/50' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted'],
	    				'Likely' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted'],
	    				'Commit' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted'],
	    				'Won' : ['Pre-prod', 'Production', 'Ramp Down', 'EOL'],
	    				'Dead' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted'],
	    				'Lost' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted']
	    			};
    			break;
    			
    		case (rtName == 'DND_Opportunity') :
                    map_ps = {
                        'On Hold' : ['Concept', 'Designed', 'On Customer AVL'],
                        'Weak' : ['Concept', 'Designed', 'On Customer AVL'],
                        '50/50' : ['Concept', 'Designed', 'On Customer AVL'],
                        'Likely' : ['Concept', 'Designed', 'On Customer AVL'],
                        'Commit' : ['Concept', 'Designed', 'On Customer AVL'],
                        'Won' : ['Pre-prod', 'Production'],
                        'Dead' : ['Concept', 'Designed', 'On Customer AVL'],
                        'Lost' : ['Concept', 'Designed', 'On Customer AVL']
                    };
    			break;

    		case (rtName == 'IND_Engineering_project' || rtName == 'IND_Sales_Project') :
    			map_ps = {
    				'50/50' : ['Concept', 'Demo'],
    				'Likely' : ['Quoted'],
    				'Won' : ['Pre-prod', 'Production'],
    				'Dead' : [],
    				'Lost' : []
    			};
    			break;
    			
			default :
				break;
    	}
    	
    	return map_ps;
    },
    
    
    checkOptions: function(profile, opp, list_Confidence, map_confidence){
        var proName=profile['Name'], rtName=opp['RecordType']['DeveloperName'];
    
        switch (true) {
            case (rtName == 'Opportunity_Engineering_Project' || rtName == 'Opportunity_Sales_Parts_Only' || 
                  rtName == 'Opportunity_Product_Platform' || rtName == 'TAM') : 
                	
                    if(proName == 'Appliance User w/ Cost' || proName == 'Appliance Standard User' || profileName == 'Appliance Inside Sales Playbook User' || proName == 'Appliance Engineering User w/Cost'){
                        if(map_confidence.hasOwnProperty('Won')){
                            list_Confidence = ['Won'];
                        }
                    }else if( (rtName == 'Opportunity_Engineering_Project' || rtName == 'Opportunity_Sales_Parts_Only') && (proName == 'Medical Standard User' || proName == 'Medical User w/Cost')) {
                        if(map_confidence.hasOwnProperty('Won')){
                            list_Confidence = ['Won'];
                        }
                    }
                
                break;
            case (rtName == 'DND_Opportunity' ) : 
                if(map_confidence.hasOwnProperty('Won')){
                    list_Confidence = ['Won'];
                }
                break;
            case (rtName == 'Channel_Engineering_Opportunity' || rtName == 'Channel_Sales_Opportunity' || 
                  rtName == 'CCR_Opportunity' || rtName == 'NDR_Opportunity') :
                        
                    if(proName == 'Channel Distributor Portal Manager' || proName == 'Channel Distributor Portal User' || 
                        proName == 'Channel Inside Sales' || proName == 'Channel Insidesales Power - Dialer' || proName == 'Channel Standard User'){
                        
                        if(map_confidence.hasOwnProperty('Won')){
                            list_Confidence = ['Won'];
                        }else{
                            list_Confidence = ['Weak', '50/50', 'Likely', 'Commit', 'Won', 'Dead', 'Lost'];
                        }
                        
                    }
                
                break;
            case (rtName == 'IND_Engineering_project' || rtName == 'IND_Sales_Project') :
            
                    list_Confidence = ['50/50', 'Won', 'Dead', 'Lost'];
                    
                break;
            case (rtName == 'ADM') :
                
                break;
            
            default:
                break;
        }
        
        return list_Confidence;
    },
    
    
    
    
    
    
    
})