({
	helperMethod : function() {
		
	},
    
    doInit: function(comp, event) {
        
        var uniqueId=comp.get('v.uniqueId'), year=comp.get('v.year'), map_forecast=comp.get('v.map_forecast'), 
            map_fc=map_forecast[uniqueId], price=0;
 		
        if( !$A.util.isUndefined( map_fc ) ){
            if(map_fc.hasOwnProperty(year)){
                price = map_fc[year][0].Sales_Price__c;
            }
        }

		price = this.shwoFormatDecimal(price, 5);
        comp.set('v.value', price);

	},
    
    event_price_change: function(comp, event) {
        var that=this, target=event.currentTarget, map_forecast=comp.get('v.map_forecast'),
            uniqueId=comp.get('v.uniqueId'), year=comp.get('v.year'), map_fc=map_forecast[uniqueId];
        var value = target.value;
        var ratio = 1;
        if(value.toLowerCase().indexOf('k') == (value.length -1) ){
            ratio = 1000;
            value = value.substr(0, value.length-1);
        }else if(value.toLowerCase().indexOf('m') == (value.length -1)){
            ratio = 1000000;
            value = value.substr(0,value.length-1);
        }
        var valueJson = that.numberResult(value);
        value = (valueJson['isNumber'] ? valueJson['value'] : 0);
        if(ratio > 1){
            value = value * ratio;
        }
        console.log("value4", value);
        if( !$A.util.isUndefined( map_fc ) ){
            if(map_fc.hasOwnProperty(year)){
                var list_fc=map_fc[year];
                for(var i=0, fc; fc=list_fc[i]; i++){
                    fc.Sales_Price__c = parseFloat(value);
                }
            }
            comp.set('v.map_forecast', map_forecast);
            that.anyChangRecord(comp, [uniqueId], year);
        }
        
	},
    
})