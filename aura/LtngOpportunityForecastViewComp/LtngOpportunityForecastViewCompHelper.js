({
	helperMethod : function() {
		
	},

	doInit: function(comp, event, ltngUtil) {
        var that=this, action=comp.get('c.getPartList');

        ltngUtil.ltngAction(action, comp, event, {'oppyId': comp.get('v.originalId')}, 
                        function(values){
                            comp.set('v.list_parts', values['list_Parts']);
                            values['list_Parts'] = [];
                            comp.set('v.target', values);
                        }, function(message){
                            alert('Error '+message);
                        }, function(){
                            $A.util.addClass(comp.find('spinner_left'), 'custom-spinner_hide');
                            
                            var list_ids=[], vTarget=comp.get('v.target');

                            for(var i=0, list_part=comp.get('v.list_parts'), part; part=list_part[i]; i++){
                                list_ids.push(part.part.Id);
                            }

                            if(list_ids.length > 0){
                                $A.util.removeClass(document.getElementById('viewFcBody'), 'hide');
                                $A.util.removeClass(comp.find('spinner_right'), 'custom-spinner_hide');
                                that.set_forecast(comp, event, list_ids, vTarget, ltngUtil);
                                
                                if(comp.get('v.target')['notifyMessage']){
                                	$A.util.addClass(comp.find('editBtn'), 'slds-hide');
                                	comp.find('notifyMessage').elements[0].innerHTML = comp.get('v.target')['notifyMessage'];
                                	$A.util.removeClass(comp.find('notifyAlert'), 'slds-hide');
                                }
                                
                            }else{
                                $A.util.removeClass(comp.find('notifyAlert'), 'slds-hide');
                            }
                            
                        });
        
	},
    
    set_forecast: function(comp, event, list_ids, vTarget, ltngUtil){
        var that=this, action=comp.get('c.getForecastList'),
            param={'oppyId': vTarget['opportunity']['Id'], 'list_PartIds': list_ids, 'list_Years': vTarget['list_Years'], 'level': vTarget['opportunity']['Level__c']};
        ltngUtil.ltngAction(action, comp, event, param, 
                        function(values){
							var list_forecastYear=[], map_totalFc={}, map_forecast=values['map_partId_year_oppyForecast'];
                            
                            if(values['message']){
                                comp.set('v.message', values['message']);
                                return;
                            }
                            
							for(var key in map_forecast){
								var map_value=map_forecast[key];
								for(var year in map_value){
									list_forecastYear.push(year);
								}
								break;
							}
							list_forecastYear.sort();
                            
							if(vTarget['opportunity'].Level__c == 'Yearly'){
								map_forecast = get_yearlyForecast(map_forecast);
							}
                            
							for(var i=0, list_part=comp.get('v.list_parts'), part; part=list_part[i]; i++){
                                if(map_forecast.hasOwnProperty(part.part.Id)){
                                    map_totalFc = JSON.parse( JSON.stringify(map_forecast[part.part.Id]) );
                                    for(var year in map_totalFc){
                                        for(var j=0, list_fc=map_totalFc[year], fc; fc=list_fc[j]; j++){
                                            fc.Quantity__c = (part.part.Quantity__c == 0 ? 0 : (fc.Quantity__c / part.part.Quantity__c) );
                                        }
                                    }
                                    break;
                                }
							}
                            
							comp.set('v.map_totalForecast', map_totalFc);
							comp.set('v.map_forecast', map_forecast);
							comp.set('v.list_forecastYear', list_forecastYear);
                            
                        }, function(message){
                            alert('Error '+message);
                        }, function(){
                        	$A.util.addClass(comp.find('spinner_right'), 'custom-spinner_hide');
                        });
						
		function get_yearlyForecast(map_forecast){
			var map_part={};
			for(var key in map_forecast){
				if( !map_part.hasOwnProperty(key) ){
					map_part[key] = {};
				}
				
				var map_fc={}, map_value=map_forecast[key];
				for(var mapV in map_value){
					var map_v = {'Sales_Price__c': 0, 'Amount__c': 0, 'Quantity__c': 0};
					if( !map_fc.hasOwnProperty(mapV) ){
						map_fc[mapV] = [map_v];
					}
					
					for(var i=0, list_fc=map_value[mapV], fc; fc=list_fc[i]; i++){
						map_v['Sales_Price__c'] = fc['Sales_Price__c'];
						map_v['Amount__c'] += fc['Amount__c'];
						map_v['Quantity__c'] += fc['Quantity__c'];
					}
					map_part[key] = map_fc;
				}
			}
			
			return map_part;
		}
	
	},
    
    
	    
    
    
    
    

})