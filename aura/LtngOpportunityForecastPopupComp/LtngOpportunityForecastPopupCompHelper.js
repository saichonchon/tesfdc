({
	helperMethod : function() {
		
	},
    
    event_deleteYear_click: function(comp, event) {
        var forecastPopup=document.getElementById('forecastPopup'), popupEvent=comp.getEvent("popupEvent");
		
        $A.util.addClass(forecastPopup, 'slds-hide');
        setTimeout(function(){
             popupEvent.setParams({'sJson': JSON.stringify({'type': forecastPopup.getAttribute('data-type'), 'value': forecastPopup.getAttribute('data-value')}) });
        	 popupEvent.fire();	// Fire the event
        }, 120);
	},
    
    event_popupClose_click: function(comp, event) {
		var forecastPopup=document.getElementById('forecastPopup');
        $A.util.addClass(forecastPopup, 'slds-hide');
	},
    
})