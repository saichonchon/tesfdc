({
	helperMethod : function() {
		
	},
    
    doInit: function(comp, event) {
        
        var uniqueId=comp.get('v.uniqueId'), year=comp.get('v.year'), map_forecast=comp.get('v.map_forecast'), 
            map_fc=map_forecast[uniqueId], total=0;
 		
        if( !$A.util.isUndefined( map_fc ) ){
            if(map_fc.hasOwnProperty(year)){
            	for(var i=0, list_fc=map_fc[year], fc; fc=list_fc[i]; i++){
                    total += fc.Quantity__c;
                }
        	}
        }
        total = this.showFormat(total);
        comp.set('v.value', total);
	},
    
})