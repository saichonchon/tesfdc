({
	helperMethod : function() {
		
	},
    
    event_save_click: function(comp, event) {
        var wonReason=document.getElementById('wonReason'), competitor=document.getElementById('competitor'), 
            teShipsetPercenttageInput=document.getElementById('teShipsetPercenttageInput'),
            popupOptions=comp.get('v.popupOptions'), popupEvent=comp.getEvent("popupEvent"), 
            sJson={'competitorId': competitor.getAttribute('data-id'), 'partId': popupOptions['partId'], 'teShipsetPercenttage': parseFloat(teShipsetPercenttageInput.value),
                   'wonReason': wonReason.options[wonReason.selectedIndex].value
                  };
        
        sJson['competitorId'] = (sJson['competitorId'] ? sJson['competitorId'] : '');
        
        if(sJson['competitorId'] == ''){
            competitor.focus();
            return;
        }
		
        if(sJson['teShipsetPercenttage'] !== +sJson['teShipsetPercenttage']){
            teShipsetPercenttageInput.focus();
            return;
        }
        
        popupEvent.setParams({'sJson': JSON.stringify({'type': 'wonChange', 'value': JSON.stringify(sJson)}) });
        popupEvent.fire();	// Fire the event
        
        comp.set('v.searchString', '');
        popupOptions['isWonOpen'] = false;
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
        
        competitor.focus();
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
    
    event_wonReason_change: function(comp, event) {
		
	},
    
    event_popupClose_click: function(comp, event) {
		var popupOptions=comp.get('v.popupOptions'), popupEvent=comp.getEvent("popupEvent"), o=JSON.stringify({'value': popupOptions['value'], 'partId': popupOptions['partId']});
		
        popupEvent.setParams({'sJson': JSON.stringify({'type': 'wonChangeCancel', 'value': o}) });
        popupEvent.fire();	// Fire the event
        
        popupOptions['isWonOpen'] = false;
        popupOptions['value'] = '';
        comp.set('v.searchString', '');
        comp.set('v.popupOptions', popupOptions);
        
        
	},

	resolveId : function(elmId) {
        var i = elmId.lastIndexOf('_');
        return elmId.substr(i+1);
    },
    
})