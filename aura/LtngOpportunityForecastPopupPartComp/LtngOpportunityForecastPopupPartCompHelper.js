({
	helperMethod : function() {
		
	},
    
    event_save_click: function(comp, event) {
        var lostReason=document.getElementById('lostReason'), competitor=document.getElementById('competitor'), 
            popupEvent=comp.getEvent("popupEvent"), isAPL=comp.get('v.isAPL');
            lostReasonText=document.getElementById('lostReasonText'), 
            lostReasonValue=lostReason.options[lostReason.selectedIndex].value, 
            competitorValue=competitor.getAttribute('data-id'), popupOptions=comp.get('v.popupOptions'),
            sJson={'value': popupOptions['value'], 'partId': popupOptions['partId']};
		
        if(lostReasonValue == 'Other' && lostReasonText.value == ''){
            document.getElementById('lostReasonText').focus();
            return;
        }
        
        if(popupOptions['value'] == 'Lost' && (competitor.value == '') && !isAPL){
            competitor.focus();
            return;
        }

        sJson['lostReasonText'] = lostReasonText.value;
        sJson['lostReason'] = lostReasonValue;
        if(comp.get('v.isDND')){
        	sJson['AvailableforTAM'] = document.getElementById('AvailableforTAMckBox').checked;
        }
        sJson['competitorId'] = (competitorValue == 'null' ? null : competitorValue);
        
        
        popupEvent.setParams({'sJson': JSON.stringify({'type': 'partChange', 'value': JSON.stringify(sJson)}) });
        popupEvent.fire();	// Fire the event
        
        comp.set('v.searchString', '');
        popupOptions['isPartOpen'] = false;
        comp.set('v.popupOptions', popupOptions);
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
        	document.getElementById('competitor').setAttribute('data-id', 'null');
        	
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
        
        var competitor=document.getElementById('competitor');
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
            competitor=document.getElementById('competitor');
        
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
    
    event_lostReason_change: function(comp, event) {
		var target=event.currentTarget, value=target.options[target.selectedIndex].value, reason=document.getElementById('lostReasonTextBox');
        $A.util.addClass(reason, 'slds-hide');
        if(value == 'Other'){
            $A.util.removeClass(reason, 'slds-hide');
        }
        
	},
	
	handlerPartLostReasonsChange: function(comp, event) {
        var value=event.getParam("value"), map_LostReasons=comp.get('v.map_LostReasons');

        if(!map_LostReasons.hasOwnProperty(value)){
            return;
        }
        comp.set('v.list_picklist', map_LostReasons[value]);
	},
    
    event_popupClose_click: function(comp, event) {
		var popupOptions=comp.get('v.popupOptions');
		
		popupOptions['isPartOpen'] = false;
        comp.set('v.searchString', '');
        comp.set('v.popupOptions', popupOptions);
	},

	resolveId : function(elmId) {
        var i = elmId.lastIndexOf('_');
        return elmId.substr(i+1);
    },
    
})