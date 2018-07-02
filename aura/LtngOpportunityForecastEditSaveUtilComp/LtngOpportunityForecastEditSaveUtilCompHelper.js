({
	helperMethod : function() {
		//	$A.util.removeClass(comp.find('spinner_mask'), 'slds-hide');
		//	vTarget['opportunity']['attributes'] = {type : 'Opportunity'};
		
	},
    
    oppySaveHelper: function(comp, event, target){
        var o={'opportunity': {}, 'list_Parts': [], 'isAPL': false, 'isUpdateOppy': false}, map_yearForecast={}, that=this, 
        	action=comp.get('c.saveOpportunity'), map_change=comp.get('v.map_change'), list_change=Object.keys(map_change),
			vTarget=comp.get('v.target'), options=that.getFiscalOptions(vTarget);
        
        o['isAPL'] = vTarget['isAPL'];
        o['isMED'] = vTarget['isMED'];
		comp.find('saveLen').getElement().innerHTML = '';
		
        console.log( comp.get('v.map_forecast') );

		if(!map_change['isChange'] && list_change.length == 1){
			that.saveChangePart(comp, event, vTarget);
			return;
		}
		
		console.log('map_change', map_change);
		
		that.spinnerInit(comp);
		if(!map_change['isChange'] && list_change.length > 1){
			that.setChangePartForecast_Opportunity(comp, vTarget, options, o, map_yearForecast, map_change);
		}else{
			that.setPartForecast_Opportunity(comp, vTarget, options, o, map_yearForecast);
		}
        
        console.log(o);
        
		that.compAction(action, comp, event, o, 
                        function(values){
							console.log( 'values', values );
							
							o['isUpdateOppy'] = values['isUpdateOppy'];
							
							if(!values['canContinue']){
								that.spinnerErrorMessage(comp, comp.find('saveOpLi'), comp.find('saveOpSpinner'), values['error']);
								return;
							}
							
							var allLen=0, list_forecastGroup=[], list_keys=Object.keys(map_yearForecast), 
								dividedLen=(o['opportunity']['Level__c'] == 'Monthly' ? 12 : 4),
								batchLen=Math.round(5000/dividedLen/o['list_Parts'].length);
							
							for(var i=0, max=list_keys.length; i<max; i+=batchLen){
								var group={ 'oppyId': o['opportunity']['Id'], 'list_fiscalYear': list_keys.slice(i, i+batchLen), 'list_oppyForecast': [] };
								for(var j=0, jMax=group['list_fiscalYear'].length; j<jMax; j++){
									var year=group['list_fiscalYear'][j];
									group['list_oppyForecast'] = group['list_oppyForecast'].concat(map_yearForecast[year]);
								}
								allLen += group['list_oppyForecast'].length;
								list_forecastGroup.push( group );
							}
							
							comp.find('saveLen').getElement().innerHTML = '( '+allLen+' ) ';
							that.spinnerSaveForecast(comp);
							that.forecastSaveHelper(comp, event, o, list_forecastGroup);
							
                        }, function(message){
							that.spinnerErrorMessage(comp, comp.find('saveOpLi'), comp.find('saveOpSpinner'), message);
                        }, function(){
							
                        });
		
    },
    
	forecastSaveHelper: function(comp, event, o, list_forecastGroup){
		var that=this, o_forecast=list_forecastGroup.pop(), action=comp.get('c.saveForecastList');
		
		console.log('o_forecast', o_forecast);
		console.log('o', o);
		that.compAction(action, comp, event, o_forecast, 
                        function(values){

							if(!values['canContinue']){
								that.spinnerErrorMessage(comp, comp.find('saveFcLi'), comp.find('saveFcSpinner'), values['error']);
								return;
							}
							
							if(values['canContinue'] && list_forecastGroup.length > 0){
								that.forecastSaveHelper(comp, event, o, list_forecastGroup);
								return;
							}
							
							var list_yearGroup=[], dividedLen=(o['opportunity']['Level__c'] == 'Monthly' ? 12 : 4),
                                batchLen=Math.round(5000 /12/o['list_Parts'].length), list_year=comp.get('v.list_year');
                            
                            if(list_year.length == 0){
                                that.spinnerDeleteForecast(comp);
                                that.spinnerDeleteForecastComplete(comp);
                                comp.set('v.map_change', {isChange: false});
                                
                                if(o['isAPL'] && !o['isMED']){
                                    $A.util.removeClass(comp.find('aplFcLi'), 'slds-is-incomplete');
                                    $A.util.removeClass(comp.find('aplFcSpinner'), 'slds-hide');
                                    $A.util.addClass(comp.find('aplFcLi'), 'slds-is-current');
                                    
                                    that.updateForecastHitory(comp, event, o);
                                    return;
                                }
                                that.reloadWindow(comp, o);
                                return;
                            }
                            
                            for(var i=0, max=list_year.length; i<max; i+=batchLen){
                                var group={ 'oppyId': o['opportunity']['Id'], 'list_fiscalYear': list_year.slice(i, i+batchLen) };
                                list_yearGroup.push( group );
                            }
                            
                            that.spinnerDeleteForecast(comp);
                            that.forecastDeleteHelper(comp, event, o, list_yearGroup);
							
                        }, function(message){
							that.spinnerErrorMessage(comp, comp.find('saveFcLi'), comp.find('saveFcSpinner'), message);
                        }, function(){
							
                        });
	},

	forecastDeleteHelper: function(comp, event, o, list_yearGroup){

		var that=this, o_year=list_yearGroup.pop(), action=comp.get('c.deleteForecast');
        console.log('o_year', o_year);
		o_year = (o_year ? o_year : {});
		that.compAction(action, comp, event, o_year, 
                        function(values){

							if(!values['canContinue']){
								that.spinnerErrorMessage(comp, comp.find('delFcLi'), comp.find('delFcSpinner'), values['error']);
								return;
							}
							
                            
                            
							if(values['canContinue'] && list_yearGroup.length > 0){
								that.forecastDeleteHelper(comp, event, o, list_yearGroup);
								return;
							}
							
							that.spinnerDeleteForecastComplete(comp);
							comp.set('v.map_change', {isChange: false});
							
							if(o['isAPL']){
								$A.util.removeClass(comp.find('aplFcLi'), 'slds-is-incomplete');
								$A.util.removeClass(comp.find('aplFcSpinner'), 'slds-hide');
								$A.util.addClass(comp.find('aplFcLi'), 'slds-is-current');
								
								that.updateForecastHitory(comp, event, o);
								return;
							}
							
							that.reloadWindow(comp, o);
							
                        }, function(message){
							that.spinnerErrorMessage(comp, comp.find('saveFcLi'), comp.find('saveFcSpinner'), message);
                        }, function(){
							
                        });
		
	},
	
		
	saveChangePart: function(comp, event, vTarget){
		var that=this, o={'list_Parts': []}, action=comp.get('c.saveParts');
		for(var i=0, list_part=comp.get('v.list_part'), part; part=list_part[i]; i++){
			var p={'Id': part.part['Id'], 'sobjectType': 'Opportunity_Part__c', 'Status__c': part.part['Status__c'], 
					'Process_Status__c': part.part['Process_Status__c'], 'Opportunity__c': vTarget['opportunity']['Id'] };

			o['list_Parts'].push(p);
		}
		that.spinnerPartInit(comp);
		that.compAction(action, comp, event, o, 
                        function(values){
							console.log(values);
							if(!values['canContinue']){
								that.spinnerErrorMessage(comp, comp.find('saveOpLi'), comp.find('saveOpSpinner'), values['error']);
								return;
							}
							
							if(vTarget['isAPL']){
								$A.util.removeClass(comp.find('saveOpLi'), 'slds-is-current');
								$A.util.addClass(comp.find('saveOpSpinner'), 'slds-hide');
								$A.util.addClass(comp.find('saveOpLi'), 'slds-is-complete');
								
								$A.util.removeClass(comp.find('aplFcLi'), 'slds-is-incomplete');
								$A.util.removeClass(comp.find('aplFcSpinner'), 'slds-hide');
								$A.util.addClass(comp.find('aplFcLi'), 'slds-is-current');
								that.updateForecastHitory(comp, event, vTarget);
								return;
							}
							
							$A.util.removeClass(comp.find('saveOpLi'), 'slds-is-current');
							$A.util.addClass(comp.find('saveOpSpinner'), 'slds-hide');
							$A.util.addClass(comp.find('saveOpLi'), 'slds-is-complete');
							
							$A.util.removeClass(comp.find('closeSaveStatus'), 'slds-hide');
							
                        }, function(message){
							that.spinnerErrorMessage(comp, comp.find('saveOpLi'), comp.find('saveOpSpinner'), message);
                            console.log(message);            
                        }, function(){
							
                        });
		
	},
	
	updateForecastHitory: function(comp, event, vTarget){
		
		var that=this, o={'oppyId': vTarget['opportunity']['Id']}, action=comp.get('c.updateForecastHitory');
		
		that.compAction(action, comp, event, o, 
                        function(values){
							console.log(values);
							if(!values['canContinue']){
								that.spinnerErrorMessage(comp, comp.find('aplFcLi'), comp.find('aplFcSpinner'), values['error']);
								return;
							}
							
							$A.util.removeClass(comp.find('aplFcLi'), 'slds-is-current');
							$A.util.addClass(comp.find('aplFcSpinner'), 'slds-hide');
							$A.util.addClass(comp.find('aplFcLi'), 'slds-is-complete');
							$A.util.removeClass(comp.find('closeSaveStatus'), 'slds-hide');
							
							that.reloadWindow(comp, values);
							
                        }, function(message){
							that.spinnerErrorMessage(comp, comp.find('aplFcLi'), comp.find('aplFcSpinner'), message);
                            console.log(message);            
                        }, function(){
							
                        });
	},
	
	setChangePartForecast_Opportunity: function(comp, vTarget, options, o, map_yearForecast, map_change){
		
		var that=this, map_f=that.getYearlyForecast(comp, vTarget);
		
		console.log('map_f', map_f);
        console.log('map_change', map_change);
		that.setOpportunity(o, vTarget);
		
		for(var i=0, list_part=comp.get('v.list_part'), part; part=list_part[i]; i++){
			var map_fc=map_f[part.part['Id']],
				p={'Id': part.part['Id'], 'sobjectType': 'Opportunity_Part__c', 'Status__c': part.part['Status__c'], 'Quantity__c': part.part['Quantity__c'], 
					'Process_Status__c': part.part['Process_Status__c'], 'Opportunity__c': vTarget['opportunity']['Id'], 'CurrencyIsoCode': part.part['CurrencyIsoCode']};
			
			if(part.hasOwnProperty('Initial_Billing_Date__c')){
				p['Initial_Billing_Date__c'] = part['Initial_Billing_Date__c'];
			}
			if(part.hasOwnProperty('Initial_Order_Date__c')){
				p['Initial_Order_Date__c'] = part['Initial_Order_Date__c'];
			}
			
			if(part.hasOwnProperty('Lost_Reason__c')){
				p['Lost_Reason__c'] = part['Lost_Reason__c'];
			}
			if(part.hasOwnProperty('Lost_Reason_Text__c')){
				p['Lost_Reason_Text__c'] = part['Lost_Reason_Text__c'];
			}
			if(part.hasOwnProperty('Competitor__c')){
				p['Competitor__c'] = part['Competitor__c'];
			}
			if(part.hasOwnProperty('Available_for_TAM__c')){
                p['Available_for_TAM__c'] = part['Available_for_TAM__c'];
            }
            
            if(part.hasOwnProperty('ADM_TE_Shipset_Percentage__c')){
                p['ADM_TE_Shipset_Percentage__c'] = part['ADM_TE_Shipset_Percentage__c'];
            }
            
            if(part.hasOwnProperty('Won_Reason__c')){
                p['Won_Reason__c'] = part['Won_Reason__c'];
            }
            
			this.setCurrentYearField(options, p, map_fc);
			this.setFiscalYearField(options, p, map_fc, o['opportunity']['Level__c']);

			for(var year in map_fc){
				var qty=0, price=0, list_fc=map_fc[year];
				
				if(map_change.hasOwnProperty(p['Id'])){
					var map_year=map_change[p['Id']];
					if(map_year.hasOwnProperty(year)){
						if(!map_yearForecast.hasOwnProperty(year)){
							map_yearForecast[year] = [];
						}
					}
				}
				
				for(var j=0, fc; fc=list_fc[j]; j++){
					var quarter=(j+1), month=(j+1);
					if(o['opportunity']['Level__c'] != 'Monthly'){
						month = j*3;
						month = (j == 0 ? 1 : (month+1) );
						month = (month == 10 ? month+'' : '0'+month);
					}
					
					qty += fc['Quantity__c'];
					price = fc['Sales_Price__c'];
					if(map_change.hasOwnProperty(p['Id'])){
						if(map_yearForecast.hasOwnProperty(year)){
							map_yearForecast[year].push({
								'Quantity__c': fc['Quantity__c'], 'Sales_Price__c': fc['Sales_Price__c'], 'Amount__c': (fc['Sales_Price__c'] * fc['Quantity__c']),
								'Opportunity__c': o['opportunity']['Id'], 'Part__c': p['Id'], 'Fiscal_Year__c': year, 'Fiscal_Quarter__c': ((quarter+'').length == 2 ? quarter : '0'+quarter), 
								'Fiscal_Month__c': ( (month+'').length == 2 ? month : '0'+month ), 'CurrencyIsoCode': p['CurrencyIsoCode']
							});
						}
					}
				}
				
				o['opportunity']['Total_Opportunity_Value__c'] += (qty * price);
				o['opportunity']['Amount'] += (p['Status__c'] != 'Dead' && p['Status__c'] != 'Lost' ? (qty * price) : 0);
			}
			
			var fiveQty=( p['Quantity__c'] == 0 ? 0 : that.getFiveQty(map_fc, o, p['Quantity__c'], options, vTarget['isBom']) );
			
			o['opportunity']['Five_Year_Value__c'] += fiveQty;
			o['opportunity']['Five_Year_Revenue__c'] += (p['Status__c'] != 'Dead' && p['Status__c'] != 'Lost' ? fiveQty : 0);

			
			o['list_Parts'].push(p);
		}
		
	},
	
	setPartForecast_Opportunity: function(comp, vTarget, options, o, map_yearForecast){
		
		var that=this, map_f=that.getYearlyForecast(comp, vTarget);
		
		that.setOpportunity(o, vTarget);
		
		for(var i=0, list_part=comp.get('v.list_part'), part; part=list_part[i]; i++){
			var map_fc=map_f[part.part['Id']],
				p={'Id': part.part['Id'], 'sobjectType': 'Opportunity_Part__c', 'Status__c': part.part['Status__c'], 'Quantity__c': part.part['Quantity__c'], 
					'Process_Status__c': part.part['Process_Status__c'], 'Opportunity__c': vTarget['opportunity']['Id'], 'CurrencyIsoCode': part.part['CurrencyIsoCode']};

			if(part.hasOwnProperty('Initial_Billing_Date__c')){
				p['Initial_Billing_Date__c'] = part['Initial_Billing_Date__c'];
			}
			if(part.hasOwnProperty('Initial_Order_Date__c')){
				p['Initial_Order_Date__c'] = part['Initial_Order_Date__c'];
			}
			if(part.hasOwnProperty('Lost_Reason__c')){
				p['Lost_Reason__c'] = part['Lost_Reason__c'];
			}
			if(part.hasOwnProperty('Lost_Reason_Text__c')){
				p['Lost_Reason_Text__c'] = part['Lost_Reason_Text__c'];
			}
			if(part.hasOwnProperty('Competitor__c')){
				p['Competitor__c'] = part['Competitor__c'];
			}
            if(part.hasOwnProperty('Available_for_TAM__c')){
                p['Available_for_TAM__c'] = part['Available_for_TAM__c'];
            }
            
            if(part.hasOwnProperty('ADM_TE_Shipset_Percentage__c')){
                p['ADM_TE_Shipset_Percentage__c'] = part['ADM_TE_Shipset_Percentage__c'];
            }
            
            if(part.hasOwnProperty('Won_Reason__c')){
                p['Won_Reason__c'] = part['Won_Reason__c'];
            }
            
			this.setCurrentYearField(options, p, map_fc);
			this.setFiscalYearField(options, p, map_fc, o['opportunity']['Level__c']);

			for(var year in map_fc){
				var qty=0, price=0, list_fc=map_fc[year];
				if(!map_yearForecast.hasOwnProperty(year)){
					map_yearForecast[year] = [];
				}
				for(var j=0, fc; fc=list_fc[j]; j++){
					var quarter=(j+1), month=(j+1);
					if(o['opportunity']['Level__c'] != 'Monthly'){
						month = j*3;
						month = (j == 0 ? 1 : (month+1) );
						month = (month == 10 ? month+'' : '0'+month);
					}

					qty += fc['Quantity__c'];
					price = fc['Sales_Price__c'];
					
					map_yearForecast[year].push({
						'Quantity__c': fc['Quantity__c'], 'Sales_Price__c': fc['Sales_Price__c'], 'Amount__c': (fc['Sales_Price__c'] * fc['Quantity__c']),
						'Opportunity__c': o['opportunity']['Id'], 'Part__c': p['Id'], 'Fiscal_Year__c': year, 'Fiscal_Quarter__c': ((quarter+'').length == 2 ? quarter : '0'+quarter), 
						'Fiscal_Month__c': ( (month+'').length == 2 ? month : '0'+month ), 'CurrencyIsoCode': p['CurrencyIsoCode']
					});
				}
				
				o['opportunity']['Total_Opportunity_Value__c'] += (qty * price);
				o['opportunity']['Amount'] += (p['Status__c'] != 'Dead' && p['Status__c'] != 'Lost' ? (qty * price) : 0);
			}
			
			var fiveQty=( p['Quantity__c'] == 0 ? 0 : that.getFiveQty(map_fc, o, p['Quantity__c'], options, vTarget['isBom']) );
			
			o['opportunity']['Five_Year_Value__c'] += fiveQty;
			o['opportunity']['Five_Year_Revenue__c'] += (p['Status__c'] != 'Dead' && p['Status__c'] != 'Lost' ? fiveQty : 0);

			
			o['list_Parts'].push(p);
		}
		
	},
	
	getYearlyForecast: function (comp, vTarget){
			
		var map_forecast=JSON.parse( JSON.stringify(comp.get('v.map_forecast')) );
		
		if(vTarget['opportunity']['Level__c'] != 'Yearly'){
			return map_forecast;
		}
		
		if(vTarget['isBom']){
			
			var map_totalForecast=JSON.parse( JSON.stringify(comp.get('v.map_totalForecast')) ); 
			
			for(var year in map_totalForecast){
				var list_quarterly=[], fc=map_totalForecast[year][0], mod=fc['Quantity__c']%4, qty=Math.floor( (fc['Quantity__c']/4) );
				fc['Quantity__c'] = qty;
				fc = JSON.stringify(fc);
				list_quarterly.push( JSON.parse(fc), JSON.parse(fc), JSON.parse(fc), JSON.parse(fc) );
				for(var i=0; i<mod; i++){
					list_quarterly[i]['Quantity__c']++;
				}
				map_totalForecast[year] = list_quarterly;
			}
			
			for(var i=0, list_part=comp.get('v.list_part'), part; part=list_part[i]; i++){
				var partQty=part.part.Quantity__c, partId=part.part.Id; 

				if(map_forecast.hasOwnProperty(partId)){
					var map_fc=map_forecast[partId];
					for(var year in map_fc){
						var list_quarterly=[], fc=JSON.stringify(map_fc[year][0]);
						
						for(var j=0, list_totalFc=map_totalForecast[year], totalFc; totalFc=list_totalFc[j]; j++){
							var o=JSON.parse(fc);
							o['Quantity__c'] = totalFc['Quantity__c']*partQty;
							list_quarterly.push(o);
						}
						map_forecast[partId][year] = list_quarterly;
					}
				}
			}
			
		}else{
			
			for(var key in map_forecast){
				var map_fc=map_forecast[key];

				for(var year in map_fc){
					var list_quarterly=[], fc=map_fc[year][0], mod=fc['Quantity__c']%4, qty=Math.floor( (fc['Quantity__c']/4) );
					
					fc['Quantity__c'] = qty;
					fc = JSON.stringify(fc);
					list_quarterly.push( JSON.parse(fc), JSON.parse(fc), JSON.parse(fc), JSON.parse(fc) );
					
					for(var i=0; i<mod; i++){
						list_quarterly[i]['Quantity__c']++;
					}
					map_forecast[key][year] = list_quarterly;
				}
			}
			
		}
		return map_forecast;
	},
	
	getFiveQty: function(map_fc, o, partQty, options, isBom){

		var map_newFc=JSON.parse( JSON.stringify(map_fc) );
		
		if(o['opportunity']['Level__c'] == 'Monthly'){
			var qty=0, price=0, mod=qty%4;
			if(isBom){
				for(var year in map_newFc){
					var qty=0, price=0, mod=qty%4, list_quarterly=[], list_fc=map_newFc[year];
					for(var i=0, fc; fc=list_fc[i]; i++){
						price = fc.Sales_Price__c;
						qty += fc.Quantity__c;
					}
					qty = Math.floor(qty/partQty);
					mod = qty%4;
					qty = Math.floor( (qty/4) );
					
					list_quarterly.push({'Sales_Price__c': price, 'Quantity__c': qty}, {'Sales_Price__c': price, 'Quantity__c': qty}, {'Sales_Price__c': price, 'Quantity__c': qty}, {'Sales_Price__c': price, 'Quantity__c': qty});
					for(var i=0; i<mod; i++){
						list_quarterly[i]['Quantity__c']++;
					}
					for(var i=0, fc; fc=list_quarterly[i]; i++){
						fc.Quantity__c = (fc.Quantity__c * partQty);
					}
					map_newFc[year] = list_quarterly;
				}
			}else{
				for(var year in map_newFc){
					var list_quarterly=[], list_fc=map_newFc[year];
					for(var i=0, max=list_fc.length; i<max; i+=3){
						var price=0, qty=0, list_group=list_fc.slice(i, i+3);
						for(var j=0, fc; fc=list_group[j]; j++){
							price = fc.Sales_Price__c;
							qty += fc.Quantity__c;
						}
						list_quarterly.push({'Sales_Price__c': price, 'Quantity__c': qty});
					}
					map_newFc[year] = list_quarterly;
				}
			}
			
		}
		
		if(!map_newFc.hasOwnProperty(options['sYear'])){
			var list_tmp=[];
			for(var year in map_newFc){
				list_tmp=JSON.parse( JSON.stringify(map_newFc[year]) );
				for(var i=0, fc; fc=list_tmp[i]; i++){
					fc.Sales_Price__c = 0;
					fc.Quantity__c = 0;
				}
				for(var i=options['sYear']; i<year; i++){
					map_newFc[i] = list_tmp;
				}
				break;
			}
			
		}

		var fiveQty=0;
		for(var year in map_newFc){
			if(year >= options['sYear'] && year <= options['year']){
				var qty=0, price=0, list_fc=map_newFc[year];

				if(year == options['sYear']){
					list_fc = ( options['sYear'] == 0 ? list_fc : list_fc.splice(options['sPoint'], list_fc.length) );
				}else if(year == options['year']){
					list_fc = list_fc.splice(0, options['sPoint']);
				}
				
				for(var i=0, fc; fc=list_fc[i]; i++){
					price = fc.Sales_Price__c;
					qty += fc.Quantity__c;
				}
				fiveQty += (price * qty);
			}
		}
		return fiveQty;
	},
	
	setOpportunity: function(o, vTarget){
		o['opportunity']['sobjectType'] = 'Opportunity';
		o['opportunity']['Id'] = vTarget['opportunity']['Id'];
		o['opportunity']['Method__c'] = vTarget['opportunity']['Method__c'];
		o['opportunity']['Level__c'] = vTarget['opportunity']['Level__c'];
		o['opportunity']['CurrencyIsoCode'] = vTarget['opportunity']['CurrencyIsoCode'];
		o['opportunity']['Amount'] = 0;
		o['opportunity']['Total_Opportunity_Value__c'] = 0;	//not dead lost part revenue.
		o['opportunity']['Five_Year_Revenue__c'] = 0;
		o['opportunity']['Five_Year_Value__c'] = 0;	//not dead lost part revenue.			
	},
	
	setFiscalYearField: function(options, p, map_fc, level){

		for(var k=1; k<=10; k++){
			var sYear=(options['sYear']+k-1), qty=0, price=0,
				yearField='YRLYFCSTYR'+k+'__c', qtyField='FCSTYR'+k+'QTY__c', priceField='FC_FY'+k+'_PRICE__c', amtField='FCSTYR'+k+'AMT__c';

			if(map_fc.hasOwnProperty(sYear)){
				for(var i=0, list_fc=map_fc[sYear], fc; fc=list_fc[i]; i++){
					qty += fc.Quantity__c;
					price = fc.Sales_Price__c;
				}
			}
			p[yearField] = sYear;
			p[qtyField] = qty;
			p[priceField] = price;
			p[amtField] = (price * qty);
		}
	},
		
	setCurrentYearField: function(options, p, map_fc){
		for(var k=-2; k<=7; k++){
			var amountField='Current_Year_add_'+k+'__c', qtyField='Current_Year_add_'+k+'QTY__c', 
				priceField='Current_Year_add_'+k+'_PRICE__c', year=options['fiscalYear']+k, qty=0, price=0;
			switch(k){
				case -2 : 
					amountField = 'Current_Year_minus_2__c'; 
					qtyField = 'Current_Year_minus_2_QTY__c';
					priceField = 'Current_Year_minus_2_PRICE__c';
					break;
				case -1 : 
					amountField = 'Current_Year_minus_1__c'; 
					qtyField = 'Current_Year_minus_1_QTY__c';
					priceField = 'Current_Year_minus_1_PRICE__c';
					break;
				case 0 : 
					amountField = 'Current_Year__c'; 
					qtyField = 'Current_Year_QTY__c';
					priceField = 'Current_Year_PRICE__c';
					break;
			}

			if(map_fc.hasOwnProperty(year)){
				var qty=0, price=0;
				for(var y=0, list_fc=map_fc[year], fc; fc=list_fc[y]; y++){
					price = fc.Sales_Price__c;
					qty += fc.Quantity__c;
				}
			}
			p[amountField] = price * qty;
			p[qtyField] = qty;
			p[priceField] = price;
		}
	},
	
	getFiscalOptions: function(vTarget){
		var fiveDate=new Date(vTarget['fiscalFiveYearEndDate']), fiveStartDate=new Date(vTarget['fiscalFiveYearStartDate']),
			op={'year': fiveDate.getFullYear(), 'month': (fiveDate.getMonth()+1), 'point': 0, 'fiscalYear': parseInt(vTarget['fiscalYear']),
				'sYear': fiveStartDate.getFullYear(), 'sMonth': (fiveStartDate.getMonth()+1), 'sPoint': 0 };
		switch(vTarget.opportunity.Level__c){
			case 'Quarterly':
			case 'Monthly':
			/*
					op['point'] = op['month']-9;
					if(op['month'] < 9){
						op['point'] = op['month']+3;
					}
					op['sPoint'] = op['sMonth']-9;
					if(op['sMonth'] < 9){
						op['sPoint'] = op['sMonth']+3;
					}
			*/		
					if(op['month'] < 3){
						op['point'] += 1;
					}else if(op['month'] < 6){
						op['point'] += 2;
					}else if(op['month'] < 9){
						op['point'] += 3;
					}
					
					if(op['sMonth'] < 3){
						op['sPoint'] += 1;
					}else if(op['sMonth'] < 6){
						op['sPoint'] += 2;
					}else if(op['sMonth'] < 9){
						op['sPoint'] += 3;
					}
				break;
		}
		
		return op;
	},
	
	spinnerPartInit: function(comp){
		
		var saveOpLi=comp.find('saveOpLi'), saveFcLi=comp.find('saveFcLi'), delFcLi=comp.find('delFcLi');
		
		$A.util.addClass(comp.find('closeSaveStatus'), 'slds-hide');
		
		$A.util.removeClass(saveOpLi, 'slds-is-complete');
		$A.util.removeClass(saveOpLi, 'slds-is-lost');
		$A.util.removeClass(saveOpLi, 'slds-is-incomplete');
		$A.util.addClass(saveOpLi, 'slds-is-current');
		$A.util.removeClass(comp.find('saveOpSpinner'), 'slds-hide');
		
		$A.util.removeClass(saveFcLi, 'slds-is-incomplete');
		$A.util.removeClass(saveFcLi, 'slds-is-complete');
		$A.util.removeClass(saveFcLi, 'slds-is-lost');
		$A.util.addClass(saveFcLi, 'slds-is-complete');
		$A.util.addClass(comp.find('saveFcSpinner'), 'slds-hide');
		
		$A.util.removeClass(delFcLi, 'slds-is-incomplete');
		$A.util.removeClass(delFcLi, 'slds-is-complete');
		$A.util.removeClass(delFcLi, 'slds-is-lost');
		$A.util.addClass(delFcLi, 'slds-is-complete');
		$A.util.addClass(comp.find('delFcSpinner'), 'slds-hide');
		
		comp.find('errorMessage').getElement().innerHTML = '';
		
		$A.util.addClass(comp.find('errorMessage'), 'slds-hide');
		$A.util.removeClass(comp.find('saveStatus'), 'slds-hide');
		
	},
	
	spinnerInit: function(comp){
		
		var saveOpLi=comp.find('saveOpLi'), saveFcLi=comp.find('saveFcLi'), delFcLi=comp.find('delFcLi'), aplFcLi=comp.find('aplFcLi');
		
		$A.util.addClass(comp.find('closeSaveStatus'), 'slds-hide');
		
		$A.util.removeClass(saveOpLi, 'slds-is-complete');
		$A.util.removeClass(saveOpLi, 'slds-is-lost');
		$A.util.removeClass(saveOpLi, 'slds-is-incomplete');
		$A.util.addClass(saveOpLi, 'slds-is-current');
		$A.util.removeClass(comp.find('saveOpSpinner'), 'slds-hide');
		
		$A.util.removeClass(saveFcLi, 'slds-is-complete');
		$A.util.removeClass(saveFcLi, 'slds-is-incomplete');
		$A.util.removeClass(saveFcLi, 'slds-is-lost');
		$A.util.addClass(saveFcLi, 'slds-is-incomplete');
		$A.util.addClass(comp.find('saveFcSpinner'), 'slds-hide');
		
		$A.util.removeClass(delFcLi, 'slds-is-complete');
		$A.util.removeClass(delFcLi, 'slds-is-incomplete');
		$A.util.removeClass(delFcLi, 'slds-is-lost');
		$A.util.addClass(delFcLi, 'slds-is-incomplete');
		$A.util.addClass(comp.find('delFcSpinner'), 'slds-hide');
		
		$A.util.removeClass(aplFcLi, 'slds-is-complete');
		$A.util.removeClass(aplFcLi, 'slds-is-incomplete');
		$A.util.removeClass(aplFcLi, 'slds-is-lost');
		$A.util.addClass(aplFcLi, 'slds-is-incomplete');
		$A.util.addClass(comp.find('aplFcSpinner'), 'slds-hide');
		
		comp.find('errorMessage').getElement().innerHTML = '';
		
		$A.util.addClass(comp.find('errorMessage'), 'slds-hide');
		$A.util.removeClass(comp.find('saveStatus'), 'slds-hide');
		
	},
	
	spinnerSaveForecast: function(comp){
		$A.util.addClass(comp.find('saveOpSpinner'), 'slds-hide');
		$A.util.removeClass(comp.find('saveOpLi'), 'slds-is-current');
		$A.util.addClass(comp.find('saveOpLi'), 'slds-is-complete');
		
		$A.util.removeClass(comp.find('saveFcLi'), 'slds-is-incomplete');
		$A.util.removeClass(comp.find('saveFcSpinner'), 'slds-hide');
		$A.util.addClass(comp.find('saveFcLi'), 'slds-is-current');
		
	},
	
	spinnerDeleteForecast: function(comp){
		$A.util.addClass(comp.find('saveFcSpinner'), 'slds-hide');
		$A.util.removeClass(comp.find('saveFcLi'), 'slds-is-current');
		$A.util.addClass(comp.find('saveFcLi'), 'slds-is-complete');
		
		$A.util.removeClass(comp.find('delFcLi'), 'slds-is-incomplete');
		$A.util.removeClass(comp.find('delFcSpinner'), 'slds-hide');
		$A.util.addClass(comp.find('delFcLi'), 'slds-is-current');
		
		$A.util.removeClass(comp.find('closeSaveStatus'), 'slds-hide');
	},
	
	spinnerDeleteForecastComplete: function(comp){
		$A.util.removeClass(comp.find('delFcLi'), 'slds-is-current');
		$A.util.addClass(comp.find('delFcSpinner'), 'slds-hide');
		$A.util.addClass(comp.find('delFcLi'), 'slds-is-complete');
	},
	
	spinnerErrorMessage: function(comp, auraTarget, auraSpinner, message){
		
		comp.find('errorMessage').getElement().innerHTML = message;
		
		$A.util.removeClass(comp.find('errorMessage'), 'slds-hide');
		
		$A.util.removeClass(auraTarget, 'slds-is-current');
		$A.util.addClass(auraSpinner, 'slds-hide');
		$A.util.addClass(auraTarget, 'slds-is-lost');
		
		$A.util.removeClass(comp.find('closeSaveStatus'), 'slds-hide');
	},
	
	anyChange: function(comp){
        comp.set('v.map_change', {isChange: true});
    },
	
	reloadWindow: function(comp, o){
        console.log('isUpdateOppy', o['isUpdateOppy']);
		if(!o['isUpdateOppy']){
			return;
		}

        $A.get("e.c:LtngOpportunityForecastVfPageEvt").fire();	// Fire the event
		
	},
	
	
	compAction: function(action, comp, event, param, callResult, callError, finallyCall){
        action.setParams({ "param" : JSON.stringify(param) });
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (comp.isValid() && state === "SUCCESS") {  
                var values=response.getReturnValue();
				callResult(values);
            } else if (state === "ERROR") { 
                var errors = response.getError(), message='Unknown error.';

                if (errors) {
                    if(errors[0]['message']){
                        message = errors[0]['message'];
                    }else if(errors[0]['pageErrors'].length != 0){
                        message = errors[0]['pageErrors'][0]['message'];
                    }else if(errors[0]['fieldErrors']){
                        for(var field in errors[0]['fieldErrors']){
                            message += field+' in '+errors[0]['fieldErrors'][field][0]['message'];
                        }                    		
                    }
                }
                callError(message);
                console.log('LtngOpportunityForecastCtrl ->', message);
            }
            finallyCall();
        });
        $A.enqueueAction(action);// Enqueue the action
        
    },
	
    showFormat: function(value){
        var newvalue = $A.localizationService.getDefaultNumberFormat().format(value);
        //console.log("newvalue", newvalue);
        return newvalue;
    },
	
})