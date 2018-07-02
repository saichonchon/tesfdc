({
	helperMethod : function() {
		
	},
    
    doInit: function(comp, event) {
        
        var year=comp.get('v.year'), isBom=comp.get('v.isBom'), totalQty=0;

        if(isBom){
            var map_totalForecast=comp.get('v.map_totalForecast');
        
            if(map_totalForecast.hasOwnProperty(year)){
                for(var i=0, list_fc=map_totalForecast[year], fc; fc=list_fc[i]; i++){
                    totalQty += fc.Quantity__c;
                }
            }
            totalQty = this.showFormat(totalQty);
            comp.set('v.value', totalQty);
            return;
        }
        
        this.manual_total_help(comp, event, 0, year);

	},
    
    event_totalQty_change: function(comp, event) {
        this.event_totalQty_changeHelp(comp, event.currentTarget);
	},
    
    
    
    
    
    
    
    
    
    
})