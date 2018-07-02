({
	helperMethod : function() {
		
	},
    
    doInit: function(comp, event) {
        
        if(!comp.get('v.isBom')){
            return;
        }
        
        var year=comp.get('v.year'), map_totalForecast=comp.get('v.map_totalForecast'), totalQty=0;
        
        if(map_totalForecast.hasOwnProperty(year)){
            var list_fc=map_totalForecast[year], qty=0;
            for(var i=0, fc; fc=list_fc[i]; i++){
                totalQty += (fc['Quantity__c'] ? fc['Quantity__c'] : 0);
            }
        }
        
        totalQty = this.roundToKM(totalQty);
        comp.set('v.value', totalQty);

	},
    
    
    
})