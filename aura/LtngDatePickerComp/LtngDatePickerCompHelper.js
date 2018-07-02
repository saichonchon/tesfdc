( {

	changeYear: function(component, newYear, date) {

		var currentMonth = component.get("v.month");
		var currentYear = component.get("v.year");

		if (!currentYear) {
			currentYear = this.date.current.year();
		}

		var currentDate = new Date(currentYear, currentMonth, date);
		var targetDate = new Date( newYear,currentDate.getMonth(), 1);

		var daysInMonth = this.numDays(currentMonth, currentYear);

		if (daysInMonth < date) { // The target month doesn't have the current date. Just set it to the last date.
			date = daysInMonth;
		}
		this.setDateValues(component, targetDate, date);
	},

	changeMonth: function(component, monthChange) {

		var currentYear = component.get("v.year");
		var currentMonth = component.get("v.month");
		var currentDay = component.get("v.date");

		var currentDate = new Date(currentYear, currentMonth, currentDay);
		var targetDate = new Date(currentDate.getFullYear() , currentDate.getMonth() + monthChange, 1);

		var daysInMonth = this.numDays(currentMonth, currentYear);

		if (daysInMonth < currentDay) { // The target month doesn't have the current date. Just set it to the last date.
			currentDay = daysInMonth;
		}
		this.setDateValues(component, targetDate, currentDay);
	},


	goToToday: function(component, event) {
		var currentYear = this.date.current.year();
		var currentMonth = this.date.current.month.integer();
		var currentDay = this.date.current.day();

		var newYear = component.find("yearSelect").set("v.value",currentYear);

		var targetDate = new Date(currentYear,currentMonth, currentDay);
		this.setDateValues(component, targetDate, currentDay);
	},

	dateCompare: function(date1, date2) {
		if (date1.getFullYear() !== date2.getFullYear()) {
			return date1.getFullYear() - date2.getFullYear();
		} else {
			if (date1.getMonth() !== date2.getMonth()) {
				return date1.getMonth() - date2.getMonth();
			} else {
				return date1.getDate() - date2.getDate();
			}
		}
	},

	/**
	 * Java style date comparisons. Compares by day, month, and year only.
	 */
	dateEquals: function(date1, date2) {
		return date1 && date2 && this.dateCompare(date1, date2) === 0;
	},

	/**
	 * Find the cell component for a specific date in a month.
	 * @date - Date object
	 */
	findDateComponent: function(component, date) {
		var firstDate = new Date(date.getTime());
		firstDate.setDate(1);
		var initialPos = firstDate.getDay(), pos = initialPos + date.getDate() - 1;

		return component.find(pos);
	},

	/**
	 * generates the days for the current selected month.
	 */
	generateMonth: function(component) {
		var dayOfMonth = component.get("v.date"), month = component.get("v.month");
		var year = component.get("v.year"), date = new Date(year, month, dayOfMonth),
            selectedDate = new Date(year, month, dayOfMonth);

		var today = new Date(), d = new Date();
        
		d.setDate(1);
		d.setFullYear(year);
		d.setMonth(month);
		// java days are indexed from 1-7, javascript 0-6
		// The startPoint will indicate the first date displayed at the top-left
		// corner of the calendar. Negative dates in JS will subtract days from
		// the 1st of the given month
		var firstDayOfWeek = $A.get("$Locale.firstDayOfWeek") - 1; // In Java, week day is 1 - 7
		var startDay = d.getDay();
		var firstFocusableDate;
		while (startDay !== firstDayOfWeek) {
			d.setDate(d.getDate() - 1);
			startDay = d.getDay();
		}
		for (var i = 0; i < 41; i++) {
			var cellCmp = component.find(i);
			if (cellCmp) {
				var dayOfWeek = d.getDay();
				var tdClass = '';

				if (d.getMonth() === month - 1 || d.getFullYear() === year - 1) {
					cellCmp.set("v.ariaDisabled", "true");
					tdClass = 'slds-disabled-text';
				} else if (d.getMonth() === month + 1 || d.getFullYear() === year + 1) {
					cellCmp.set("v.ariaDisabled", "true");
					tdClass = 'slds-disabled-text';
				}

				if (d.getMonth() === month && d.getDate() === 1) {
					firstFocusableDate = cellCmp;
				}

				if (this.dateEquals(d, today)) {
					tdClass += ' slds-is-today';
				}
				if (this.dateEquals(d, selectedDate)) {
					cellCmp.set("v.ariaSelected", "true");
					tdClass += ' slds-is-selected';
					firstFocusableDate = cellCmp;
				}

				cellCmp.set("v.tabIndex", -1);
				cellCmp.set("v.label", d.getDate());
				cellCmp.set("v.tdClass", tdClass)

				var dateStr = d.getFullYear() + "-" +
				('0' + (d.getMonth() + 1)).slice(-2) + "-" +
				('0' + d.getDate()).slice(-2);
				cellCmp.set("v.value", dateStr);

			}
			d.setDate(d.getDate() + 1);
		}
		if (firstFocusableDate) {
			firstFocusableDate.set("v.tabIndex", 0);
		}
		component.set("v._setFocus", true);
	},

	getEventTarget: function(e) {
		return (window.event) ? e.srcElement : e.target;
	},

	goToFirstOfMonth: function(component) {
		var date = new Date(component.get("v.year"), component.get("v.month"), 1);
		var targetId = date.getDay();
		var targetCellCmp = component.find(targetId);
		targetCellCmp.getElement().focus();
		component.set("v.date", 1);
	},

	goToLastOfMonth: function(component) {
		var date = new Date(component.get("v.year"), component.get("v.month") + 1, 0);
		var targetCellCmp = this.findDateComponent(component, date);
		if (targetCellCmp) {
			targetCellCmp.getElement().focus();
			component.set("v.date", targetCellCmp.get("v.label"));
		}
	},


	renderGrid: function(component) {
		this.generateMonth(component);
	},


	clearDate: function(component) {

		// component.set("v.year", '');
		// component.set("v.month", '');
		// component.set("v.monthName", '');
		// component.set("v.date", '');
		component.set("v.selectedDate", '');
		component.set("v.value", '');


		//finally fire the event to tell parent components we have changed the date:
		/*
        var dateChangeEvent = component.getEvent("dateChangeEvent");
		dateChangeEvent.setParams( {"value" : '' });
		dateChangeEvent.fire();
        */
	},

	selectDate: function(component, event) {
		var source = event.getSource();

		var firstDate = new Date(component.get("v.year"), component.get("v.month"), 1), firstDateId = parseInt(firstDate.getDay(), 10);

		// need to account for start of week differences when comparing indices
		var firstDayOfWeek = $A.get("$Locale.firstDayOfWeek") - 1; // The week days in Java is 1 - 7
		var offset = 0;
		if (firstDayOfWeek !== 0) {
			if (firstDateId >= firstDayOfWeek) {
				offset -= firstDayOfWeek;
			} else {
				offset += (7 - firstDayOfWeek);
			}
		}

		firstDateId += offset;
		var lastDate = new Date(component.get("v.year"), component.get("v.month") + 1, 0), 
			lastDateCellCmp = this.findDateComponent(component, lastDate), 
			lastDateId = parseInt(lastDateCellCmp.getLocalId(), 10);
			
		lastDateId += offset;

		var currentId = parseInt(source.getLocalId(), 10), currentDate = source.get("v.label"), targetDate;
        
		if (currentId < firstDateId) { // previous month
			targetDate = new Date(component.get("v.year"), component.get("v.month") - 1, currentDate);
			this.setDateValues(component, targetDate, targetDate.getDate());

		} else if (currentId > lastDateId) { // next month
			targetDate = new Date(component.get("v.year"), component.get("v.month") + 1, currentDate);
			this.setDateValues(component, targetDate, targetDate.getDate());

		} else {
			component.set("v.date", currentDate);
		}
        
        var vDate = component.get("v.date")+"";
        var rDate = (vDate.length == 1 ? "0"+vDate:vDate);
        var d=component.get("v.year") + "-" + (component.get("v.month") + 1) + "-" + rDate;
        
		/*	        
        var grid = component.find('grid');
		if (grid) {
			$A.util.addClass(grid, "slds-hide");
		}

		//show the clear button
		if ( !$A.util.isEmpty(component.get("v.value"))) {
            $A.util.addClass(component.find('date-button'), 'slds-hide');
			$A.util.removeClass(component.find('clear-button'), 'slds-hide');
        }else{
            $A.util.removeClass(component.find('date-button'), 'slds-hide');
        }
        */

		component.set("v.selectedDate", d);
		var grid=component.find('grid'), dateChangeEvent=component.getEvent("dateChangeEvent"),
            dateString=$A.localizationService.formatDateTime( d, $A.get("$Locale.dateFormat") );
        component.set("v.value", dateString);
        
        dateChangeEvent.setParams( {"value" : d, 'sid': component.get('v.sid')});
		dateChangeEvent.fire();
		
		if (grid) {
			$A.util.addClass(grid, "slds-hide");
		}
		
	},
	
    selectedDateCheck: function(comp, selectedDate){
        var today=new Date(), sDate=new Date(selectedDate), invalidDialog=comp.find('invalidDialog');
		today = new Date(today.getFullYear(), today.getMonth(), today.getDate()); 
        
        if(today > sDate){
            $A.util.removeClass(invalidDialog, 'slds-hide');
            return;
        }
        $A.util.addClass(invalidDialog, 'slds-hide');

        var level=comp.get('v.level'), sYear=sDate.getFullYear(), sMonth=sDate.getMonth(), message='The start date will be ';
        
        switch(level){
        	case 'Yearly':
                	message += ( sMonth < 9 ? sYear : (sYear+1) );
                break;
            case 'Quarterly':
					if(sMonth < 3){
                        message +=  'FQ2 Qty of ' + sYear;
                    }else if(sMonth < 6){
                        message +=  'FQ3 Qty of ' + sYear;
                    }else if(sMonth < 9){
                        message +=  'FQ4 Qty of ' + sYear;
                    }else{
                        message +=  'FQ1 Qty of ' + (year+1);
                    }                
                break;
            case 'Monthly':
                	var map_label=['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
                    if(sMonth < 6){
                        message += 'FM0' + (sMonth+4) + ' ' + map_label[sMonth] + ' of ' + sYear;
                    }else if(sMonth < 9){
                        message += 'FM' + (sMonth+4) + ' ' + map_label[sMonth] + ' of ' + sYear;
                    }else{
                        message += 'FM0' + (sMonth-8) + ' ' + map_label[sMonth] + ' of ' + (sYear+1);
                    }
                break;
        }
		
        comp.set('v.message', message);
        comp.set("v.selectedDate", selectedDate);
		$A.util.removeClass(comp.find('movePopup'), 'slds-hide');
        
    },
    
    event_moveForecast_click: function(comp, event) {
                
		var sDate=comp.get("v.selectedDate"), dateChangeEvent=comp.getEvent("dateChangeEvent"),
            dateString=$A.localizationService.formatDateTime( new Date(sDate), $A.get("$Locale.dateFormat") );

		dateChangeEvent.setParams( {"value" : sDate});
		dateChangeEvent.fire();
        
        comp.set("v.value", dateString);
        $A.util.addClass(comp.find('movePopup'), 'slds-hide');
        
        
        var grid = comp.find('grid');
		if (grid) {
			$A.util.addClass(grid, "slds-hide");
		}

		//show the clear button
		if ( !$A.util.isEmpty(comp.get("v.value"))) {
            $A.util.addClass(comp.find('date-button'), 'slds-hide');
			$A.util.removeClass(comp.find('clear-button'), 'slds-hide');
        }else{
            $A.util.removeClass(comp.find('date-button'), 'slds-hide');
        }
        
	},
    
	setFocus: function(component) {
		var date = component.get("v.date");
		if (!date) {
			date = 1;
		}
		var year = component.get("v.year");
		var month = component.get("v.month");
		var cellCmp = this.findDateComponent(component, new Date(year, month, date));
		if (cellCmp) {
			cellCmp.getElement().focus();
		}
	},

	updateNameOfWeekDays: function(component) {
		var firstDayOfWeek = $A.get("$Locale.firstDayOfWeek") - 1; // The week days in Java is 1 - 7
		var namesOfWeekDays = $A.get("$Locale.nameOfWeekdays");
		var days = [];
		if (this.isNumber(firstDayOfWeek) && $A.util.isArray(namesOfWeekDays)) {
			for (var i = firstDayOfWeek; i < namesOfWeekDays.length; i++) {
				days.push(namesOfWeekDays[i]);
			}
			for (var j = 0; j < firstDayOfWeek; j++) {
				days.push(namesOfWeekDays[j]);
			}
			component.set("v._namesOfWeekdays", days);
		} else {
			component.set("v._namesOfWeekdays", namesOfWeekDays);
		}
	},

	isNumber: function(obj) {
		return !isNaN(parseFloat(obj))
	},

	numDays: function(currentMonth, currentYear) {
		// checks to see if february is a leap year otherwise return the respective # of days
		return currentMonth === 1 && (((currentYear % 4 === 0) && (currentYear % 100 !== 0)) || (currentYear % 400 === 0)) ? 29 : this.l10n.daysInMonth[currentMonth];

	},

	setDateValues: function(component, fullDate, dateNum) {

		component.set("v.year", fullDate.getFullYear());
		component.set("v.month", fullDate.getMonth());
		component.set("v.monthName", this.l10n.months.longhand[fullDate.getMonth()]);
		component.set("v.date", dateNum);
		component.set("v.selectedDate", fullDate);
	},

	generateYearOptions : function(component,fullDate) {

		var years = [];
		var year = fullDate.getFullYear()-2;

		for (var i = year; i < year + 12; i++) {
			years.push( { "class": "optionClass", label: i, value: i });
		}
		years[2].selected = true;
		component.find("yearSelect").set("v.options", years);
	},


    l10n: {
        weekdays: {
            shorthand: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
            longhand: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
		},
        months: {
            shorthand: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
            longhand: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
		},
    	daysInMonth: [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31],
		firstDayOfWeek: 0
	},

	date: {
        current: {
        	year: function() {
                    return new Date().getFullYear();
        	},
        	month: {
            	integer: function() {
                	return new Date().getMonth();
            	},
            	string: function(shorthand) {
                	var month = new Date().getMonth();
                	return monthToStr(month, shorthand);
            	}
			},
            day: function() {
            	return new Date().getDate();
            }
		}
	}

})