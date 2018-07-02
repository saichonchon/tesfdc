({
	helperMethod : function() {
		
	},
    
    event_popupClose_click: function(comp, event) {
        var popupOptions=comp.get('v.popupOptions'), popupEvent=comp.getEvent("popupEvent"), 
            sJson={'pid':popupOptions['partId'], 'value': '', 'billingDate': comp.get('v.billingDate'), 'orderDate': comp.get('v.orderDate')};
        
        popupOptions['isDateOpen'] = false;
        popupOptions['partId'] = '';
        popupOptions['value'] = '';
        popupOptions['billingDate'] = '';
        popupOptions['orderDate'] = '';
        comp.set('v.popupOptions', popupOptions);
        
        popupEvent.setParams({'sJson': JSON.stringify({'type': 'aplPartDateChange', 'value': JSON.stringify(sJson)}) });
        popupEvent.fire();	// Fire the event
	},
    
    event_save_click: function(comp, event) {
        var popupOptions=comp.get('v.popupOptions'), popupEvent=comp.getEvent("popupEvent"), billingDate=comp.get('v.billingDate'), orderDate=comp.get('v.orderDate'),
            sJson={'pid':popupOptions['partId'], 'value': popupOptions['value'], 'billingDate': billingDate, 'orderDate': orderDate};
        
        console.log(sJson);
        
        if(billingDate == ''){
            comp.find('billingDate').getElement().querySelector('input[type="text"]').focus();
            return;
        }        
        if(orderDate == ''){
            comp.find('orderDate').getElement().querySelector('input[type="text"]').focus();
            return;
        }
        
        popupOptions['isDateOpen'] = false;
        popupOptions['partId'] = '';
        popupOptions['value'] = '';
        comp.set('v.popupOptions', popupOptions);
        
        popupEvent.setParams({'sJson': JSON.stringify({'type': 'aplPartDateChange', 'value': JSON.stringify(sJson)}) });
        popupEvent.fire();	// Fire the event
	},
    
    renderDate:function(comp, event) {
        var popupOptions=comp.get('v.popupOptions');

        if(!popupOptions.hasOwnProperty('isRender')){
        	if(popupOptions['billingDate']){
        		var d=$A.localizationService.formatDateTime( new Date(popupOptions['billingDate']), $A.get("$Locale.dateFormat") );
        		comp.set('v.formatBillingDate', d);
        		comp.set('v.billingDate', popupOptions['billingDate']);
        	}
        	if(popupOptions['orderDate']){
        		var d=$A.localizationService.formatDateTime( new Date(popupOptions['orderDate']), $A.get("$Locale.dateFormat") );
        		comp.set('v.formatOrderDate', d);
        		comp.set('v.orderDate', popupOptions['orderDate']);
        	}
        }
	},
    
    handleDateChangeEvt: function(comp, event) {

        var value=event.getParam('value'), id=event.getParam('sid'), popupOptions=comp.get('v.popupOptions');

        switch(id){
        	case 'billingDate': comp.set('v.billingDate', value); break;
            case 'orderDate': comp.set('v.orderDate', value); break;
        }
        popupOptions['isRender'] = true;
        comp.set('v.popupOptions', popupOptions);
	},
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
})