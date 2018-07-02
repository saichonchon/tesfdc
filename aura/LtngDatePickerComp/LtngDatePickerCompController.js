( {
	doInit: function(component, event, helper) {

		for (var i = 0; i < 41; i++) {
			var cellCmp = component.find(i);
			if (cellCmp) {
				cellCmp.addHandler("dateCellClick", component, "c.handleClick");
			}
		}

		var format = component.get("v.formatSpecifier"), datestr = component.get("v.value"), 
			langLocale = $A.get("$Locale.langLocale"), timezone = $A.get("$Locale.timezone"),
            momentDate = $A.localizationService.parseDateTime(datestr, langLocale), currentDate;

	//	console.log('datestr: ' + datestr);
	//	console.log('momentDate: ' + momentDate);
		
        if (momentDate != null && momentDate.isValid()) {
            currentDate = momentDate.toDate();
        } else {
            $A.localizationService.getToday(timezone,function(today) {
                currentDate =  $A.localizationService.parseDateTime(today, 'yyyy-MM-dd');
            });
        }

		helper.setDateValues(component, currentDate, currentDate.getDate());

		// Set the first day of week
		helper.updateNameOfWeekDays(component);
		helper.generateYearOptions(component, currentDate);

		var setFocus = component.get("v.setFocus");
		if (!setFocus) {
			component.set("v._setFocus", false);
		}
		helper.renderGrid(component);

		//addition caspar 2016-12-14
		component.set("v.date", currentDate.getDate());
        /*
		if ( !$A.util.isEmpty(datestr)) {
			$A.util.removeClass(component.find('clear-button'), 'slds-hide');
		}
        */
        var initValue=component.get('v.initValue');
        if(initValue){
            component.set("v.value", initValue);
        }
	},
	
    handlerInitValueChange: function(component, event) {
        var initValue=component.get('v.initValue');
        if(initValue){
            component.set("v.value", initValue);
        }
    },
    
	handleInputFocus: function(component, event) {
		
        window.setTimeout(
            $A.getCallback(function() {
                component.set("v._gridOver", true);
                var grid = component.find("grid");
                if (grid) {
                    $A.util.removeClass(grid, 'slds-hide');
                }
            }), 120
		);
        
	},


	handleYearChange: function(component, event, helper) {

		var newYear = component.find("yearSelect").get("v.value");
		var date = component.get("v.date");
		helper.changeYear(component, newYear, date);
	},

	handleClick: function(component, event, helper) {
	//	console.log('Date picker controller click' + event);
		helper.selectDate(component, event);

	},


	handleClearDate: function(component, event, helper) {

		helper.clearDate(component);
        $A.util.removeClass(component.find('date-button'), 'slds-hide');
		$A.util.addClass(component.find('clear-button'), 'slds-hide');
	},

	goToToday: function(component, event, helper) {
		event.stopPropagation();
		helper.goToToday(component, event);
		return false;
	},

	goToPreviousMonth: function(component, event, helper) {
		event.stopPropagation();
		helper.changeMonth(component, -1);
		return false;
	},

	goToNextMonth: function(component, event, helper) {
		event.stopPropagation();
		helper.changeMonth(component, 1);
		return false;
	},

	onMouseLeaveInput: function(component, event, helper) {
		component.set("v._gridOver", false);
		window.setTimeout(
            $A.getCallback(function() {
                if (component.isValid()) {
                    if (component.get("v._gridOver")) {//if dropdown over, user has hovered over the dropdown, so don't close.
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
		var grid = component.find("grid"), invalidDialog=component.find('invalidDialog');
		$A.util.addClass(grid, 'slds-hide');
		$A.util.addClass(invalidDialog, 'slds-hide');
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