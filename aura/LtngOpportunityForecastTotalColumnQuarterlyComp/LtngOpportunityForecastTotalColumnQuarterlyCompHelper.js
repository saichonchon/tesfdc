({
	helperMethod : function() {
		
	},
    
    doInit: function(comp, event) {
        
        var year=comp.get('v.year'), number=comp.get('v.number'), isBom=comp.get('v.isBom'), totalQty=0;
        if(isBom){
            var map_totalForecast=comp.get('v.map_totalForecast');
        
            if(map_totalForecast.hasOwnProperty(year)){
                var list_fc=map_totalForecast[year], fc=list_fc[number];
                totalQty = (fc === undefined ? 0 : fc['Quantity__c']);
            }
            totalQty = this.showFormat(totalQty);
            comp.set('v.value', totalQty);
            return;
        }
        this.manual_total_help(comp, event, number, year);
	},
    
    event_totalQty_change: function(comp, event) {
		this.event_totalQty_changeHelp(comp, event.currentTarget);
	},
    
})