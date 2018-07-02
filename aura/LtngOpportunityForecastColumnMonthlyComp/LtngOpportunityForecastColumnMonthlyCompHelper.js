({
	helperMethod : function() {
		
	},
    
    doInit: function(comp, event) {
        
        var uniqueId=comp.get('v.uniqueId'), year=comp.get('v.year'), number=comp.get('v.number'),
            map_forecast=comp.get('v.map_forecast'), map_fc=map_forecast[uniqueId], qty=0;

        if( !$A.util.isUndefined( map_fc ) ){
            if(map_fc.hasOwnProperty(year)){
                if(map_fc[year][number]){
                    var t=map_fc[year][number];
                    qty = (t ? (t['Quantity__c'] ? t['Quantity__c'] : qty) : qty);
                }
            }
        }
        
        qty = this.showFormat(qty);     
        comp.set('v.value', qty);
	},
    
    event_qty_change: function(comp, event) {
		this.event_qty_changeHelp(comp, event.currentTarget);
	},
    
    
    
})