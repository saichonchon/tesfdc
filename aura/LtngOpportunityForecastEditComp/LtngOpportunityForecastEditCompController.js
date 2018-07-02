({
	myAction : function(component, event, helper) {
		
	},
	
    jsLoaded: function(component, event, helper) {

		var that=this, o={'that': that, 'comp': component, 'event': event};

        that.ltngUtil.event_document_resize(o);
		that.ltngUtil.event_fixedHeight_layout(o);        

        helper.doInit(component, event, that.ltngUtil);
        
	},
    
	doInit: function(component, event, helper) {
	//	helper.doInit(component, event);
	},
	
    event_displayfc_click: function(component, event, helper) {
		var that=this, o={'that': that, 'comp': component, 'event': event};
        that.ltngUtil.event_displayfc_click(o);
	},
    
    event_level_change: function(component, event, helper) {
		helper.event_level_change(component, event);
	},
    event_method_change: function(component, event, helper) {
		helper.event_method_change(component, event);
	},
    
    event_addyear_click: function(component, event, helper) {
		helper.event_addyear_click(component, event);
	},
    
    event_edit_click: function(component, event, helper) {
		helper.event_edit_click(component, event);
	},
	
    event_confidence_change: function(component, event, helper) {
		helper.event_confidence_change(component, event);
	},
	
	event_confidence_focus: function(component, event, helper) {
		
		if($A.util.hasClass(event.currentTarget, 'slds-is-disabled')){
			event.currentTarget.setAttribute('disabled', 'disabled');
		} else {
			event.currentTarget.removeAttribute('disabled');
		}
	},
	
	event_confidenceStatus_click: function(component, event, helper) {
		var target= event.currentTarget, pid = target.getAttribute('data-pid'), statusSelect = target.parentNode.parentNode.querySelector('select');
		
		var parts = component.get('v.list_part') || [];
		for (var i = 0; i < parts.length; i ++) {
			if (parts[i].part.Id === pid) {
				parts[i].part.Status__c = component.get('v.defaultConfidence');
				parts[i].part.Process_Status__c = component.get('v.defaultProcessStatus');
			}
		}
		
		component.set('v.list_part', parts);
		
		window.setTimeout(function() {
			if(document.createEvent) {
		        var evObj = document.createEvent('HTMLEvents');
		        evObj.initEvent('change', true, false);
		        statusSelect.dispatchEvent(evObj);
			} else if(document.createEventObject) {
				statusSelect.fireEvent('onchange');
			}
		}, 100);
	},
	
    event_deleteYearPopup_click: function(component, event, helper) {
		helper.event_deleteYearPopup_click(component, event);
	},
    
    event_cancel_click: function(component, event, helper) {
		helper.event_cancel_click(component, event);
	},
    
    event_mouse_over: function(component, event, helper) {
		var that=this, o={'that': that, 'comp': component, 'event': event};
        that.ltngUtil.event_mouse_over(o);
	},
    event_mouse_out: function(component, event, helper) {
		var that=this, o={'that': that, 'comp': component, 'event': event};
        that.ltngUtil.event_mouse_out(o);
	},
    
	event_partQty_change: function(component, event, helper) {
		helper.event_partQty_change(component, event);
	},
    
    event_save_click: function(component, event, helper) {
		helper.event_save_click(component, event);
	},
    
    event_closeSaveStatus_click: function(component, event, helper) {
		$A.util.addClass(component.find('saveStatus'), 'slds-hide');
		
		helper.event_cancel_click(component, event);

	},
    
    event_massupdate_click: function(component, event, helper) {
		helper.event_massupdate_click(component, event);
	},
    
    event_fullscreen_click: function(component, event, helper) {
        var that=this, o={'that': that, 'comp': component, 'event': event};
        that.ltngUtil.event_fullscreen_click(o);
	},
    
    handleDateChangeEvt: function(component, event, helper) {
		helper.handleDateChangeEvt(component, event);
	},
 
    handlepopupEvt: function(component, event, helper) {
		helper.handlepopupEvt(component, event);
	},
	
    handldpChangeEvt: function(component, event, helper) {
		helper.handldpChangeEvt(component, event);
	},
    
    handleAPLCheckedEvent: function(component, event, helper) {
		helper.handleAPLCheckedEvent(component, event);
	},
    
    
    
    
    
    
    
    
    
    
    
})