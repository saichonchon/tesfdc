({
	helperMethod : function() {
		
	},
    
    doInit: function(comp, event) {
        
        var uniqueId=comp.get('v.uniqueId'), year=comp.get('v.year'), map_forecast=comp.get('v.map_forecast'), 
            map_fc=map_forecast[uniqueId], qty=0;

        if( !$A.util.isUndefined( map_fc ) ){
            if(map_fc.hasOwnProperty(year)){
                qty = map_fc[year][0].Quantity__c;
            }
        }
        qty = this.showFormat(qty);
        comp.set('v.value', qty);

	},
    
    event_qty_change: function(comp, event) {
		this.event_qty_changeHelp(comp, event.currentTarget);
	},
    
    
    
    
})