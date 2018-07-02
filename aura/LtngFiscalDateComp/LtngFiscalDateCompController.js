( {
	doInit: function(component, event, helper) {
		helper.doInit(component, event);
	},
	
    handlerFiscalDateChange: function(component, event, helper) {
		helper.handlerFiscalDateChange(component, event);
	},
    
	event_input_focus: function(component, event) {
		component.set("v._gridOver", true);
		var grid = component.find("grid");
		if (grid) {
			$A.util.removeClass(grid, 'slds-hide');
		}

	},


	event_year_change: function(component, event, helper) {
		helper.event_year_change(component, event);
	},
	
    event_selectDate_click: function(component, event, helper) {
		helper.event_selectDate_click(component, event);
	},
    
	handleClick: function(component, event, helper) {
	//	console.log('Date picker controller click' + event);
		helper.selectDate(component, event);

	},


	event_clearDate_click: function(component, event, helper) {
		helper.event_clearDate_click(component, event);
	},

	onMouseLeaveInput: function(component, event, helper) {

		component.set("v._gridOver", false);
		window.setTimeout(
            $A.getCallback(function() {
                if (component.isValid()) {
                    if (component.get("v._gridOver")) {
                        return;
                    }
                    var grid = component.find("grid");
                    $A.util.addClass(grid, 'slds-hide');
                }
            }), 200
		);
	},

	onMouseLeaveGrid: function(component, event, helper) {
		component.set("v._gridOver", false);
		var grid = component.find("grid");
		$A.util.addClass(grid, 'slds-hide');
	},

	onMouseEnterGrid: function(component, event, helper) {
		component.set("v._gridOver", true);
	},
	
    event_popupClose_click: function(component, event, helper) {
		var movePopup=component.find('movePopup');
		$A.util.addClass(movePopup, 'slds-hide');
	},
    
    event_moveForecast_click: function(component, event, helper) {
		helper.event_moveForecast_click(component, event);
	},
    
    
    
    
    
    
    
    
    
    
    
    
    
});