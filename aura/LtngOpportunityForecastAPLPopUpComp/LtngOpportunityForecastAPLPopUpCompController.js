({
	myAction : function(component, event, helper) {
		
	},
	
	doInit: function(component, event, helper) {
        helper.doInit(component, event);
	},
    
    event_confidence_change: function(component, event, helper) {
        helper.event_confidence_change(component, event);
	},
    
    event_save_click: function(component, event, helper) {
        helper.event_save_click(component, event);
	},
    
    event_popupClose_click: function(component, event, helper) {
        component.set("v.billingDate", ''); 
        component.set("v.orderDate", ''); 
        component.set("v.searchString", '');
        var popupOptions=component.get('v.popupOptions');
        popupOptions['isAPLOpen'] = false;
        popupOptions['isRequired'] = false;
        popupOptions['list_Confidence'] = [];
		component.set('v.popupOptions', popupOptions);
	},
    
    event_competitorSearch_keyup: function(component, event, helper) {
		helper.event_competitorSearch_keyup(component, event);
	},
    event_competitorClear_click: function(component, event, helper) {
		helper.event_competitorClear_click(component, event);
	},
    event_competitorSelect_click: function(component, event, helper) {
		helper.event_competitorSelect_click(component, event);
	},
    event_processStatus_change: function(component, event, helper) {
		helper.event_processStatus_change(component, event);
	},
	
	event_lostReasons_change: function(component, event, helper) {
		helper.event_lostReasons_change(component, event);
	},

	handlerisMassChange: function(component, event, helper) {
		helper.handlerisMassChange(component, event);
	},
    
    handleDateChangeEvt: function(component, event, helper) {
		helper.handleDateChangeEvt(component, event);
	},
    
})