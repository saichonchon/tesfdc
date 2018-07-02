({
	helperMethod : function() {
		
	},
    
    doInit: function(comp, event) {
        var v=0, uniqueId=comp.get('v.uniqueId'), year=comp.get('v.year'), map_forecast=comp.get('v.map_forecast'), list_part=comp.get('v.list_part');
		
    	for(var i=0, part; part=list_part[i]; i++){
            var pId=part.part.Id, status=part.part.Status__c, map_fc=map_forecast[pId];
            if(status == 'Dead' || status == 'Lost'){
                continue;
            }
            if(map_fc.hasOwnProperty(year)){
                var list_fc=map_fc[year], price=0, qty=0;
                for(var j=0, fc; fc=list_fc[j]; j++){
                	price = fc.Sales_Price__c;
                    qty += fc.Quantity__c;
                }
                v += ( price * qty );
            }           
        }

        v = Math.round(v * Math.pow(10, 2)) / Math.pow(10, 2);
        v = this.roundToKM(v);
        comp.set('v.value',  v);

	},
    
})