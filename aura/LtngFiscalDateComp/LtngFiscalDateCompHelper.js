({
	helperMethod : function() {
		
	},
    doInit: function(comp, event) {
		
    },
    
    handlerFiscalDateChange: function(comp, event) {
		var list_year=[], level=comp.get('v.level'), map_fiscalDate=comp.get('v.map_fiscalDate'), map_fiscal=map_fiscalDate[level];
		
        if(!level){
            alert('Forecast level empty.');
            return;
        }
        
        for(var year in map_fiscal){
            list_year.push( {"class": "optionClass", label: year, value: year} );
        }
        list_year[0].selected = true;
        
        var list_date=[], list_fiscal=map_fiscal[list_year[0].value];
        
        this.set_listDate(list_date, list_fiscal, level);
        
        comp.set('v.list_date', list_date);
        comp.find("yearSelect").set("v.options", list_year);
        comp.set("v.value", '');
        comp.set("v.selectedDate", {});
	},
    
    event_year_change: function(comp, event) {
		var newYear=comp.find("yearSelect").get("v.value"), level=comp.get('v.level'), 
            map_fiscalDate=comp.get('v.map_fiscalDate'), map_fiscal=map_fiscalDate[level],
            list_date=[], list_fiscal=map_fiscal[newYear];

        this.set_listDate(list_date, list_fiscal, level);
        
        comp.set('v.list_date', list_date);   
        
	},
    
    event_selectDate_click: function(comp, event) {
        var target=event.currentTarget, index=parseInt(target.getAttribute('data-index')), level=comp.get('v.level'), 
            list_date=comp.get('v.list_date'), sYear=comp.find("yearSelect").get("v.value"), select_date=list_date[index],
            message='The start date will be ';

        switch(level){
        	case 'Yearly':
                	message += sYear;
                break;
            case 'Quarterly':
                	message += select_date['label'] + ' of ' + sYear;                 
                break;
            case 'Monthly':
                	var map_label=['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'], month=parseInt(select_date['month']);
                	message += select_date['label'] + ' ' + map_label[month] + ' of ' + sYear;    
                break;
        }
		
        comp.set('v.message', message);
        comp.set("v.selectedDate", select_date);
		$A.util.removeClass(comp.find('movePopup'), 'slds-hide');
        comp.set("v._gridOver", false);
        $A.util.addClass(comp.find('grid'), 'slds-hide');
	},
    
    event_clearDate_click: function(comp, event) {
        comp.set("v.value", '');
        comp.set("v.selectedDate", {});
        $A.util.removeClass(comp.find('date-button'), 'slds-hide');
		$A.util.addClass(comp.find('clear-button'), 'slds-hide');
        
	},
    
    event_moveForecast_click: function(comp, event) {
                
		var sd=comp.get("v.selectedDate"), fiscalDateChangeEvent=comp.getEvent("fiscalDateChangeEvent"), 
            sDate=sd['year']+'-'+sd['month'];
        
        console.log( sd );

		fiscalDateChangeEvent.setParams( {"value" : sDate});
		fiscalDateChangeEvent.fire();

        comp.set("v.value", sd['label']+' '+sd['date'] );
        $A.util.addClass(comp.find('movePopup'), 'slds-hide');
        
        var grid = comp.find('grid');
		if (grid) {
			$A.util.addClass(grid, "slds-hide");
		}

		if ( !$A.util.isEmpty(comp.get("v.value"))) {
            $A.util.addClass(comp.find('date-button'), 'slds-hide');
			$A.util.removeClass(comp.find('clear-button'), 'slds-hide');
        }else{
            $A.util.removeClass(comp.find('date-button'), 'slds-hide');
        }
        
	},
    
    
    set_listDate: function(list_date, list_fiscal, level){
        for(var i=0, d; d=list_fiscal[i]; i++){
            var o={'label': '', 'date': (d['startDate']+'～'+d['endDate']), 'month': '01', 'year': d['fiscalYear']};
            switch(level){
                case 'Yearly': break;
                case 'Quarterly':
                    o['label'] = d['fiscalQuarter'];
                    switch(d['fiscalQuarter']){
                        case 'Q2' : o['month'] = '02'; break;
                        case 'Q3' : o['month'] = '05'; break;
                        case 'Q4' : o['month'] = '08'; break;
                        default: o['month'] = '10'; break;
                    }
                    break;
                case 'Monthly':
                    o['label'] = 'FM'+d['fiscalMonth'];
                    o['month'] = (new Date(d['startDate']).getMonth()+1);
                    break;
            }
            list_date.push(o);
        }
    },
    
    
    
    
})