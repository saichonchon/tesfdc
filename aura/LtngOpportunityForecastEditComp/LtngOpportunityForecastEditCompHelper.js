({
	helperMethod : function() {
		
	},

	doInit: function(comp, event, ltngUtil) {
        var that=this, action=comp.get('c.getPartList');
		
        ltngUtil.ltngAction(action, comp, event, {'oppyId': comp.get('v.originalId')}, 
                        function(values){
							var list_part = JSON.parse( JSON.stringify(values['list_Parts']) );
							values['list_Parts'] = [];	//clear 
							console.log('values', values);
							comp.set('v.target', values);
							comp.set('v.list_part', list_part);
							comp.set('v.defaultConfidence', values.defaultConfidence);
							comp.set('v.defaultProcessStatus', values.defaultProcessStatus);
                        }, function(message){
                            alert('Error '+message);
                        }, function(){
                            $A.util.addClass(comp.find('spinner_left'), 'custom-spinner_hide');
                            var list_ids=[], list_part=comp.get('v.list_part');
                            for(var i=0, part; part=list_part[i]; i++){
                                list_ids.push(part.part.Id);
                            }
                            
                            if(list_ids.length > 0){
                                $A.util.removeClass(comp.find('spinner_right'), 'custom-spinner_hide');
                                that.set_forecast(comp, event, list_ids, ltngUtil);
                            }
                            
                        });
        
        
	},
    
    set_forecast: function(comp, event, list_ids, ltngUtil){
        var that=this, vTarget=comp.get('v.target'), action=comp.get('c.getForecastList'),
			param={'oppyId': vTarget['opportunity']['Id'], 'list_PartIds': list_ids, 'list_Years': vTarget['list_Years'], 'level': vTarget['opportunity']['Level__c']};
        
        ltngUtil.ltngAction(action, comp, event, param, 
                        function(values){
                            
                            var list_year=[], list_forecastYear=[], map_forecastYear={}, map_forecast=values['map_partId_year_oppyForecast'];
							console.log('map_forecast', map_forecast);
                            for(var key in map_forecast){
                                var map_value=map_forecast[key];
                                for(var mapV in map_value){
									map_forecastYear[mapV] = '';
                                }
                                break;
                            }
							
                            list_forecastYear = Object.keys(map_forecastYear).sort();
							
                            for(var i=0, list_y=vTarget['list_Years'], y; y=list_y[i]; i++){
								y = parseInt(y);
								if(!map_forecastYear.hasOwnProperty(y)){
									list_year.push(y);
								}
                            }
                            
                            comp.set('v.list_year', list_year);

							if(vTarget['opportunity'].Level__c == 'Yearly'){
								map_forecast = get_yearlyForecast(map_forecast);
							}
							
							var map_totalFc={};
							
							for(var i=0, list_part=comp.get('v.list_part'), part; part=list_part[i]; i++){
								if(part.part.Quantity__c != 0){
									if(map_forecast.hasOwnProperty(part.part.Id)){
										map_totalFc = JSON.parse( JSON.stringify(map_forecast[part.part.Id]) );
										for(var year in map_totalFc){
											for(var i=0, list_fc=map_totalFc[year], fc; fc=list_fc[i]; i++){
												fc.Quantity__c = (fc.Quantity__c / part.part.Quantity__c);
											}
										}
									}
									break;
								}else{
									map_totalFc = JSON.parse( JSON.stringify(map_forecast[part.part.Id]) );
									for(var year in map_totalFc){
										for(var i=0, list_fc=map_totalFc[year], fc; fc=list_fc[i]; i++){
											fc.Quantity__c = (fc.Quantity__c / part.part.Quantity__c);
										}
									}
                                    break;
								}
							}
							
							comp.set('v.map_totalForecast', map_totalFc);
							comp.set('v.map_forecast', map_forecast);
							comp.set('v.list_forecastYear', list_forecastYear);
							comp.set('v.map_change', values['map_change']);
							
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
    
	
	change_yearlyForecast: function(comp, vTarget, map_forecast){

		var map_totalForecast=comp.get('v.map_totalForecast');
		
		setTotalMonthlyForecast(map_totalForecast);
		
		if(vTarget.isBom){
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
					var list_fc=map_fc[year], o=JSON.parse(JSON.stringify(list_fc[0]));
					o['Quantity__c'] = 0;
					for(var i=0, fc; fc=list_fc[i]; i++){
						o['Quantity__c'] += fc['Quantity__c'];
					}
					map_forecast[key][year] = [o];
				}
			}
		}
		
		comp.set('v.map_totalForecast', map_totalForecast);
        comp.set('v.map_forecast', map_forecast);

		function setTotalMonthlyForecast(map_totalForecast){
			for(var year in map_totalForecast){
				var list_fc=map_totalForecast[year], o=JSON.parse(JSON.stringify(list_fc[0]));
				o['Quantity__c'] = 0;
				for(var i=0, fc; fc=list_fc[i]; i++){
					o['Quantity__c'] += fc['Quantity__c'];
				}
				map_totalForecast[year] = [o];
			}
		}
		
	},
	
	change_quarterlyForecast: function(comp, vTarget, map_forecast){
		
		var map_totalForecast=comp.get('v.map_totalForecast');
		
		setTotalMonthlyForecast(map_totalForecast);
		
		if(vTarget.isBom){
			setBomMonthlyForecast(comp, vTarget, map_forecast, map_totalForecast);
		}else{
			setMonthlyForecast(map_forecast);
		}

		comp.set('v.map_totalForecast', map_totalForecast);
        comp.set('v.map_forecast', map_forecast);

		function setTotalMonthlyForecast(map_totalForecast){
			for(var year in map_totalForecast){
				var list_quarterly=[], list_fc=map_totalForecast[year];
				
				if(list_fc.length == 1){
					var fc=list_fc[0], mod=fc['Quantity__c']%4, qty=Math.floor( (fc['Quantity__c']/4) );
					
					fc['Quantity__c'] = qty;
					fc = JSON.stringify(fc);
					list_quarterly.push( JSON.parse(fc), JSON.parse(fc), JSON.parse(fc), JSON.parse(fc) );
					
					for(var i=0; i<mod; i++){
						list_quarterly[i]['Quantity__c']++;
					}
				}else{
					var list_group=[];
					for(var i=0, max=list_fc.length; i<max; i+=3){
						list_group.push( list_fc.slice(i,i+3) );
					}
					
					for(var i=0, list_tmp; list_tmp=list_group[i]; i++){
						var o=JSON.parse( JSON.stringify(list_tmp[0]) );
						o['Quantity__c'] = 0;
						for(var j=0, tmp; tmp=list_tmp[j]; j++){
							o['Quantity__c'] += tmp['Quantity__c'];
						}
						list_quarterly.push(o);
					}
				}
				map_totalForecast[year] = list_quarterly;
			}
		}
		
		function setBomMonthlyForecast(comp, vTarget, map_forecast, map_totalForecast){
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
			
		}
		
		function setMonthlyForecast(map_forecast){
			for(var key in map_forecast){
				var map_fc=map_forecast[key];
				for(var year in map_fc){
					var list_quarterly=[], list_fc=map_fc[year];
					if(list_fc.length == 1){
						var fc=list_fc[0], mod=fc['Quantity__c']%4, qty=Math.floor( (fc['Quantity__c']/4) );
					
						fc['Quantity__c'] = qty;
						fc = JSON.stringify(fc);
						list_quarterly.push( JSON.parse(fc), JSON.parse(fc), JSON.parse(fc), JSON.parse(fc) );
						
						for(var i=0; i<mod; i++){
							list_quarterly[i]['Quantity__c']++;
						}
						
					}else{
						var list_group=[];
						for(var i=0, max=list_fc.length; i<max; i+=3){
							list_group.push( list_fc.slice(i,i+3) );
						}
						
						for(var i=0, list_tmp; list_tmp=list_group[i]; i++){
							var o=JSON.parse( JSON.stringify(list_tmp[0]) );
							o['Quantity__c'] = 0;
							for(var j=0, tmp; tmp=list_tmp[j]; j++){
								o['Quantity__c'] += tmp['Quantity__c'];
							}
							list_quarterly.push(o);
						}
					}
					map_forecast[key][year] = list_quarterly;
				}
			}
		}
		
	},
	
	change_monthlyForecast: function(comp, vTarget, map_forecast){

		var map_totalForecast=comp.get('v.map_totalForecast');
		
		setTotalMonthlyForecast(map_totalForecast)
		
		if(vTarget.isBom){
			setBomMonthlyForecast(comp, vTarget, map_forecast, map_totalForecast);
		}else{
			setMonthlyForecast(map_forecast);
		}

		comp.set('v.map_totalForecast', map_totalForecast);
        comp.set('v.map_forecast', map_forecast);

		function setTotalMonthlyForecast(map_totalForecast){
			for(var year in map_totalForecast){
				var list_quarterly=[], list_fc=map_totalForecast[year], list_tmp=[];
				if(list_fc.length == 1){
					var fc=list_fc[0], mod=fc['Quantity__c']%4, qty=Math.floor( (fc['Quantity__c']/4) );
					
					fc['Quantity__c'] = qty;
					fc = JSON.stringify(fc);
					list_quarterly.push( JSON.parse(fc), JSON.parse(fc), JSON.parse(fc), JSON.parse(fc) );
					
					for(var i=0; i<mod; i++){ list_quarterly[i]['Quantity__c']++; }
					list_fc = list_quarterly;
				}
				for(var i=0, q; q=list_fc[i]; i++){
					var n1=JSON.parse(JSON.stringify(q)), n2=JSON.parse(JSON.stringify(q)), n3=JSON.parse(JSON.stringify(q)),
						qty=q['Quantity__c'], q1=Math.round(qty*4/13), q2=(qty-2*q1), q3=q1;
					
					n1['Quantity__c'] = q1;
					n2['Quantity__c'] = q2;
					n3['Quantity__c'] = q3;
					
					list_tmp.push(n1, n2, n3);
				}
				map_totalForecast[year] = list_tmp;
			}
		}
		
		function setBomMonthlyForecast(comp, vTarget, map_forecast, map_totalForecast){
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
			
		}
		
		function setMonthlyForecast(map_forecast){
			for(var key in map_forecast){
				var map_fc=map_forecast[key];
				for(var year in map_fc){
					var list_quarterly=[], list_fc=map_fc[year], list_tmp=[];
					if(list_fc.length == 1){
						var fc=list_fc[0], mod=fc['Quantity__c']%4, qty=Math.floor( (fc['Quantity__c']/4) );
						
						fc['Quantity__c'] = qty;
						fc = JSON.stringify(fc);
						list_quarterly.push( JSON.parse(fc), JSON.parse(fc), JSON.parse(fc), JSON.parse(fc) );
						
						for(var i=0; i<mod; i++){ list_quarterly[i]['Quantity__c']++; }
						list_fc = list_quarterly;
					}
					for(var i=0, q; q=list_fc[i]; i++){
						var n1=JSON.parse(JSON.stringify(q)), n2=JSON.parse(JSON.stringify(q)), n3=JSON.parse(JSON.stringify(q)),
							qty=q['Quantity__c'], q1=Math.round(qty*4/13), q2=(qty-2*q1), q3=q1;
						
						n1['Quantity__c'] = q1;
						n2['Quantity__c'] = q2;
						n3['Quantity__c'] = q3;
						
						list_tmp.push(n1, n2, n3);
					}
					map_forecast[key][year] = list_tmp;
				}
			}
		}
		
	},
	
	
		
	del_forecastYear: function(comp, sJson) {
		
		console.log('sJson', sJson);
		
		var map_newFc={}, map_newTotalFc={}, yearV=parseInt( sJson['value'] ), list_year=comp.get('v.list_year'), 
			list_forecastYear=comp.get('v.list_forecastYear'), forecastYearPoint=list_forecastYear.indexOf(yearV+''),
			map_forecast=comp.get('v.map_forecast'), map_totalForecast=comp.get('v.map_totalForecast');

		list_forecastYear.splice(forecastYearPoint, 1);
		list_year.push(yearV);
		list_year.sort();

		for(var key in map_forecast){
			var map_fc=map_forecast[key];
			map_newFc[key] = {};
			for(var year in map_fc){
				if(year != yearV){
					map_newFc[key][year] = map_fc[year];
				}
			}
		}
		map_forecast = {};		//clear
		
		for(var fYear in map_totalForecast){
			if(yearV != fYear){
				map_newTotalFc[fYear] = map_totalForecast[fYear];
			}
		}
		
		this.anyChange(comp);
		comp.set('v.map_totalForecast', map_newTotalFc);
		comp.set('v.map_forecast', map_newFc);
		
		comp.set('v.list_year', list_year);
		comp.set('v.list_forecastYear', list_forecastYear);
	},
    
    set_forecastLevel: function(comp, sJson) {
		
        var that=this, vTarget=comp.get('v.target'), list_forecastYear=comp.get('v.list_forecastYear'), map_forecast=comp.get('v.map_forecast');
        vTarget.opportunity.Level__c = sJson['value'];
		that.anyChange(comp);
		comp.set('v.target', vTarget);
		
        for(var i=0, list_el=document.querySelectorAll('#editFcBody tr.tr-price'), el; el=list_el[i]; i++){
            $A.util.addClass(el, 'custom-display-none');
        }
        for(var i=0, list_el=document.querySelectorAll('#editFcBody input[type="checkbox"]:checked'), el; el=list_el[i]; i++){
            el.checked = false;
        }
		switch(sJson['value']){
			case 'Yearly' : that.change_yearlyForecast(comp, vTarget, map_forecast); break;
			case 'Quarterly' : that.change_quarterlyForecast(comp, vTarget, map_forecast); break;
			case 'Monthly' : that.change_monthlyForecast(comp, vTarget, map_forecast); break;
		}
	},
	
    set_forecastMethod: function(comp, sJson) {
		
        var vTarget=comp.get('v.target');
        vTarget.opportunity.Method__c = sJson['value'];
        vTarget.isBom = (sJson['value'] == 'BOM' ? true : false);
		
		this.anyChange(comp);
		comp.set('v.target', vTarget);
		
		if(!vTarget.isBom){
			return;
		}
		var map_newFc={}, map_changeFc={}, map_totalForecast=comp.get('v.map_totalForecast'), 
			map_forecast=comp.get('v.map_forecast'), list_part=comp.get('v.list_part');
			
		for(var i=0, part; part=list_part[i]; i++){
			var partQty=part.part.Quantity__c, partId=part.part.Id;
			if(map_forecast.hasOwnProperty(partId)){
				var map_fc=map_forecast[partId], map_tmp={};
				for(var year in map_fc){
					map_tmp[year] = [];
					if(!map_changeFc.hasOwnProperty(year)){
						map_changeFc[year] = 0;
					}
					for(var j=0, list_fc=map_fc[year], fc; fc=list_fc[j]; j++){
						map_changeFc[year] += fc['Quantity__c'];
						var o=JSON.parse( JSON.stringify(fc) );
						if(partQty != 0){
							o['Quantity__c'] = o['Quantity__c']/partQty;
						}
						map_tmp[year].push( o );
					}
				}
				map_newFc[partId] = map_tmp;
			}
		}
		
		var flg=false;
		for(var key in map_newFc){
			var map_fc=map_newFc[key];
			for(var year in map_fc){
				var list_totalFc=map_totalForecast[year];
				for(var i=0, list_fc=map_fc[year], fc; fc=list_fc[i]; i++){
					if(fc.Quantity__c != list_totalFc[i].Quantity__c){
						flg = true;
						break;
					}
				}
				if(flg){ break; }
			}
			if(flg){ break; }
		}
		console.log('flg', flg);
		
		map_newFc = {};	//clear
		
		if(!flg){
			return;
		}
		
		var map_partQty={};
		
		for(var i=0, part; part=list_part[i]; i++){
			var partQty=part.part.Quantity__c, partId=part.part.Id;
			map_partQty[partId] = partQty;
		}
		
		for(var key in map_forecast){
			var map_fc=map_forecast[key];
			for(var year in map_fc){
				var list_fc=map_fc[year], list_totalFc=map_totalForecast[year], yearQty=map_changeFc[year], partQty=map_partQty[key];
				switch(vTarget.opportunity.Level__c){
					case 'Yearly' : 
						for(var i=0, fc; fc=list_fc[i]; i++){
							fc.Quantity__c = yearQty * partQty;
							list_totalFc[i].Quantity__c = yearQty;
						}
						break;
					case 'Quarterly' :
						var mod=(yearQty)%4, qty=Math.floor( (yearQty/4) );
						for(var i=0, fc; fc=list_fc[i]; i++){
							fc.Quantity__c = qty * partQty;
							list_totalFc[i].Quantity__c = qty;
						}
						for(var i=0; i<mod; i++){
							list_fc[i]['Quantity__c']++;
							list_totalFc[i].Quantity__c++;
						}
						break;
					case 'Monthly' : 
					
						list_fc = getMonthlyQty(list_fc, yearQty);
						list_totalFc = getMonthlyQty(list_totalFc, yearQty);

						break;
				}
				map_totalForecast[year] = list_totalFc;
				map_forecast[key][year] = list_fc;
			}
		}
		comp.set('v.map_totalForecast', map_totalForecast);
		comp.set('v.map_forecast', map_forecast);
		
		function getMonthlyQty(list_f, yearQty){
			var list_q=[], list_tmp=[], mod=(yearQty)%4, qty=Math.floor( (yearQty/4) ), o=list_f[0];
			
			for(var i=0; i<4; i++){
				var tmp = JSON.parse( JSON.stringify(o) );
				tmp['Quantity__c'] = qty;
				list_q.push( tmp );
			}
			
			for(var i=0; i<mod; i++){
				list_q[i]['Quantity__c']++;
			}
			
			for(var i=0, q; q=list_q[i]; i++){
				var qt=q.Quantity__c, q1=Math.round(qt*4/13), q2=(qt-2*q1), q3=q1;
				list_tmp.push( (q1*partQty), (q2*partQty), (q1*partQty) );
			}
			
			for(var i=0, fc; fc=list_f[i]; i++){
				fc['Quantity__c'] = list_tmp[i];
			}
			return list_f;
		}
		
	},
    
    set_forecastWonChangeChange: function(comp, sJson){
        var sValue=JSON.parse(sJson['value']), list_part=comp.get('v.list_part'), map_ProcessStatus=comp.get('v.target')['map_ProcessStatus'];
		
        console.log('map_ProcessStatus', map_ProcessStatus);
        
		for(var i=0, part; part=list_part[i]; i++){
			if(sValue['partId'] == part.part['Id']){
                part['Competitor__c'] = sValue['competitorId'];
                part.part['Competitor__c'] = sValue['competitorId'];
                part['ADM_TE_Shipset_Percentage__c'] = sValue['teShipsetPercenttage'];
                part['Won_Reason__c'] = sValue['wonReason'];
                part.part['Status__c'] = 'Won';
                part.part['Process_Status__c'] = map_ProcessStatus['Won'][0];
				break;
			}
		}
		
		this.anyChange(comp);
		comp.set('v.list_part', list_part);
    },
	
    set_forecastWonChangeCancelChange: function(comp, sJson){
        var sValue=JSON.parse(sJson['value']), list_part=comp.get('v.list_part'), map_ProcessStatus=comp.get('v.target')['map_ProcessStatus'];

		for(var i=0, part; part=list_part[i]; i++){
			if(sValue['partId'] == part.part['Id']){
                part.part['Status__c'] = sValue['value'];
                part.part['Process_Status__c'] = map_ProcessStatus[sValue['value']][0];
				break;
			}
		}
		
		this.anyChange(comp);
		comp.set('v.list_part', list_part);
    },
    
    
	set_forecastPart: function(comp, sJson) {
        
        var popupOptions=comp.get('v.popupOptions'), sValue=JSON.parse(sJson['value']);
        
        popupOptions['isAPLOpen'] = false;
        popupOptions['isPartOpen'] = true;
        popupOptions['value'] = sValue['value'];
        popupOptions['partId'] = sValue['partId'];
        
        comp.set('v.partLostReasons', sValue['value']);
        comp.set('v.popupOptions', popupOptions);

        console.log('sValue', sValue);

	},
	
	set_forecastPartChange: function(comp, sJson) {
		var sValue=JSON.parse(sJson['value']), list_part=comp.get('v.list_part'), map_ProcessStatus=comp.get('v.target')['map_ProcessStatus'];
		
		console.log(sValue);
		
		for(var i=0, part; part=list_part[i]; i++){
			if(sValue['partId'] == part.part['Id']){
				delete part['Competitor__c'];
                delete part.part['Competitor__c'];
				delete part['Lost_Reason_Text__c'];
				delete part['Initial_Billing_Date__c'];
				delete part['Initial_Order_Date__c'];
				delete part['Available_for_TAM__c'];
				
				part['Available_for_TAM__c'] = sValue['AvailableforTAM'];
                part.part['Status__c'] = sValue['value'];
				part['Lost_Reason__c'] = sValue['lostReason'];
				
                if(map_ProcessStatus.hasOwnProperty(sValue['value'])){
					part.part['Process_Status__c'] = map_ProcessStatus[sValue['value']][0];
				}
				if(sValue['value'] == 'Lost'){
                    part['Competitor__c'] = sValue['competitorId'];
					part.part['Competitor__c'] = sValue['competitorId'];
				}
				break;
			}
		}
		
		this.anyChange(comp);
		comp.set('v.list_part', list_part);

	},
    
    set_massupdatePartChange: function(comp, sJson) {
		var sValue=JSON.parse(sJson['value']), list_part=comp.get('v.list_part'), map_ProcessStatus=comp.get('v.target')['map_ProcessStatus'];
		
        console.log('sValue::::::'+sJson['value']);

		for(var i=0, part; part=list_part[i]; i++){
            if(part['isChecked']){
                delete part['Competitor__c'];
                delete part['Lost_Reason__c'];
                delete part['Initial_Billing_Date__c'];
				delete part['Initial_Order_Date__c'];
				delete part['Lost_Reason_Text__c'];
				
				delete part['Available_for_TAM__c'];
                delete part['ADM_TE_Shipset_Percentage__c'];
                delete part['Won_Reason__c'];
                part['Competitor__c'] = sValue['competitorId'];
				part.part['Competitor__c'] = sValue['competitorId'];
                part.part['Status__c'] = sValue['confidence'];
            	part.part['Process_Status__c'] = sValue['processStatus'];
                
                //delete sValue['confidence'];
                //delete sValue['processStatus'];
                
                for(var key in sValue){
                    if (key == 'confidence' || key == 'processStatus' || key == 'competitorId' || key == 'Competitor__c')
                        continue;

                    part[key] = sValue[key];
                }
                
                console.log('part', part);
                
            }
		}
        
		this.anyChange(comp);
		comp.set('v.list_part', list_part);

	},
    
	set_forecastAplPartDateChange: function(comp, sJson) {
		var sValue=JSON.parse(sJson['value']), list_part=comp.get('v.list_part');
		
		console.log(sValue);
		
		if(sValue['value'] == ''){
			for(var i=0, part; part=list_part[i]; i++){
				if(part.part['Id'] == sValue['pid']){
					delete part['Initial_Billing_Date__c'];
					delete part['Initial_Order_Date__c'];
					break;
				}
			}
			comp.set('v.list_part', list_part);
			return;
		}
		
		for(var i=0, part; part=list_part[i]; i++){
			if(part.part['Id'] == sValue['pid']){
				part.part['Process_Status__c'] = sValue['value'];
				part['Initial_Billing_Date__c'] = sValue['billingDate'];
				part['Initial_Order_Date__c'] = sValue['orderDate'];
				break;
			}
		}
        
		this.anyChange(comp);
		comp.set('v.list_part', list_part);

	},
	
    event_massupdate_click: function(comp, event) {
        var map_confidence={}, list_checked=comp.find('leftTbody').getElement().querySelectorAll('input[type="checkbox"].msupd:checked');
        if(list_checked.length == 0){
            alert('Please select opportunity part first!');
            return;
        }
        
        if(checkMassUpDate(comp, list_checked, map_confidence)){
        	alert('You cannot select Won and un-Won confidence opportunity part to mass update!');
        	return;
        }
        
        var popupOptions=comp.get('v.popupOptions');
        popupOptions['isAPLOpen'] = true;
        popupOptions['map_confidence'] = map_confidence;
        popupOptions['list_Confidence'] = comp.get('v.target')['list_Confidence'];
        
        if(comp.get('v.target')['isAPL']){
        	popupOptions['isRequired'] = false;
        }
        
        console.log('popupOptions', popupOptions);
        
        comp.set('v.popupOptions', popupOptions);
        
        
        
        ;function checkMassUpDate(comp, list_checked, map_confidence){
  
        	var vTarget=comp.get('v.target'), profile=vTarget['profile'], opp=vTarget['opportunity'], rtName=opp['RecordType']['DeveloperName'], flg=false;
            
            if(profile != 'BU Admin' && profile != 'BU Analyst' && profile != 'Developer' && profile != 'Production Support' && profile != 'System Administrator'){
            	var o={};
                for(var i=0, checkbox; checkbox=list_checked[i]; i++){
                    var parentNode=checkbox.parentNode.parentNode, select=parentNode.querySelector('select.slds-confidence'), confidence=select.options[select.selectedIndex].value,
                        selectStatus=parentNode.querySelector('select.custom-process-status'), status=selectStatus.options[selectStatus.selectedIndex].value;
                    
                    if(!o.hasOwnProperty(confidence) ){
                        o[confidence] = confidence;
                    }
                    if(!map_confidence.hasOwnProperty(confidence) ){
                        map_confidence[confidence] = {'confidence': confidence, 'status': status};
                    }
                    
                }
                if(Object.keys(o).length > 1 && o.hasOwnProperty('Won')){
                    flg = true;
                }
            }
	    	return flg;
        }
        
        
        
	},
    
    event_deleteYearPopup_click: function(comp, event) {
        
        if(comp.get('v.list_forecastYear').length == 1){
            alert('You can not delete all forecast.');
            return;
        }
        
        var target=event.currentTarget, forecastPopup=document.getElementById('forecastPopup');
        document.getElementById('fcpopupbox').style.width = '20%';
        forecastPopup.setAttribute('data-value', target.getAttribute('data-year'));
        forecastPopup.setAttribute('data-type', 'delete');
        
		this.anyChange(comp);
		comp.set('v.popupTitle', 'delete forecast');
        comp.set('v.popupMessage', 'Are you sure to delete selected year forecast?');
        
        $A.util.removeClass(forecastPopup, 'slds-hide');
	},
    
    event_level_change: function(comp, event) {

        var target=event.currentTarget, value=target.options[target.selectedIndex].value, 
            old=target.getAttribute('data-old'), forecastPopup=document.getElementById('forecastPopup');
        
        document.getElementById('fcpopupbox').style.width = '50%';
        forecastPopup.setAttribute('data-value', value);
        forecastPopup.setAttribute('data-type', 'level');
        
		comp.set('v.popupTitle', 'forecasting level');
        comp.set('v.popupMessage', 'if you proceed your quarterly/monthly seasonality gets lost! Are you sure?');

        $A.util.removeClass(forecastPopup, 'slds-hide');
        
        for(var i=0, max=target.options.length; i<max; i++){
            if(target.options[i].value == old){
                target.options[i].selected = true;
                break;
            }
        }
	},
	
    event_method_change: function(comp, event) {

		var target=event.currentTarget, value=target.options[target.selectedIndex].value, 
            old=target.getAttribute('data-old'), forecastPopup=document.getElementById('forecastPopup');
        
        document.getElementById('fcpopupbox').style.width = '60%';
        forecastPopup.setAttribute('data-value', value);
        forecastPopup.setAttribute('data-type', 'method');
        
        comp.set('v.popupTitle', 'forecasting method');
        comp.set('v.popupMessage', 'if you procceed your current forecasting data gets lost! Are you sure?');
        
        $A.util.removeClass(forecastPopup, 'slds-hide');
        
        for(var i=0, max=target.options.length; i<max; i++){
            if(target.options[i].value == old){
                target.options[i].selected = true;
                break;
            }
        }
	},
    
    event_confidence_change: function(comp, event) {
		var target=event.currentTarget, value=target.options[target.selectedIndex].value, partId=target.getAttribute('data-pid'),
			old=target.getAttribute('data-old'), forecastPopup=document.getElementById('forecastPopup'), oTarget=comp.get('v.target');

        if( (oTarget['isADM'] || oTarget['isDND']) && value == 'Won'){
            var popupOptions=comp.get('v.popupOptions');
            popupOptions['isWonOpen'] = true;
            popupOptions['partId'] = partId;
            popupOptions['value'] = old;
            comp.set('v.popupOptions', popupOptions);
            return;
        }
        
		if(value == 'Dead' || value == 'Lost'){
			forecastPopup.setAttribute('data-value', JSON.stringify({'value': value, 'partId': partId}));
			forecastPopup.setAttribute('data-type', 'part');
			document.getElementById('fcpopupbox').style.width = '50%';
			comp.set('v.popupTitle', 'part message');
			comp.set('v.popupMessage', 'The forecasts in part with Lost or Dead confidence status will not be calculated into total revenue. Are you sure?');
			$A.util.removeClass(forecastPopup, 'slds-hide');

			for(var i=0, max=target.options.length; i<max; i++){
				if(target.options[i].value == old){
					target.options[i].selected = true;
					break;
				}
			}
			
			return;
		}
		var list_part=comp.get('v.list_part'), map_ProcessStatus=comp.get('v.target')['map_ProcessStatus'];
		for(var i=0, part; part=list_part[i]; i++){
			if(part.part.Id == partId){
				delete part['Competitor__c'];
                delete part.part['Competitor__c'];
				delete part['Lost_Reason__c'];
				delete part['Lost_Reason_Text__c'];
				delete part['Initial_Billing_Date__c'];
				delete part['Initial_Order_Date__c'];
				
                delete part['ADM_TE_Shipset_Percentage__c'];
                delete part['Won_Reason__c'];
                
				part.part.Status__c = value;
				if(map_ProcessStatus.hasOwnProperty(value)){
					part.part.Process_Status__c = map_ProcessStatus[value][0];
				}
				break;
			}
		}
		if(old == 'Dead' || old == 'Lost'){
			this.anyChange(comp);
		}
		
		comp.set('v.list_part', list_part);

	},

	handldpChangeEvt: function(comp, event) {
		var sJson=JSON.parse(event.getParam('sJson')), list_part=comp.get('v.list_part'), oTarget=comp.get('v.target');
		var profile=oTarget['profile'].Name, opp=oTarget['opportunity'], rtName=opp['RecordType']['DeveloperName'];
        if(!oTarget['isAPL'] && sJson['value'] == 'Production'){	//oTarget['isADM'] || oTarget['isMED'] ||  oTarget['isDND']
            for(var i=0, part; part=list_part[i]; i++){
                if(part.part['Id'] == sJson['pid']){
                    part.part['Process_Status__c'] = sJson['value'];
                    break;
                }
            }
            comp.set('v.list_part', list_part);
            return;
        }
        
		if(sJson['value'] == 'Production'){
			var popupOptions=comp.get('v.popupOptions');
			
			popupOptions['billingDate'] = '';
			popupOptions['orderDate'] = '';
            if (oTarget['isAPL'] && (profile == 'Appliance Engineering User w/Cost' || profile == 'Appliance Standard User' || profileName == 'Appliance Inside Sales Playbook User' || profile == 'Appliance User w/ Cost') 
                && (rtName == 'Opportunity_Engineering_Project' || rtName == 'Opportunity_Sales_Parts_Only' || rtName == 'Opportunity_Product_Platform')) {
                popupOptions['isDateOpen'] = true;
            } else {
                popupOptions['isDateOpen'] = false;
            }
            
            if (profile == 'BU Admin' || profile == 'BU Analyst' || profile == 'Developer' || profile == 'Production Support' || profile == 'System Administrator') {
                popupOptions['isDateOpen'] = true;
            }
			
			popupOptions['value'] = sJson['value'];
			popupOptions['partId'] = sJson['pid'];
			
			for(var i=0, part; part=list_part[i]; i++){
				if(part.part['Id'] == sJson['pid']){
					popupOptions['billingDate'] = (part.part['Initial_Billing_Date__c'] ? part.part['Initial_Billing_Date__c'] : '');
					popupOptions['orderDate'] = (part.part['Initial_Order_Date__c'] ? part.part['Initial_Order_Date__c'] : '');
					break;
				}
			}
			console.log('popupOptions', popupOptions);
			comp.set('v.popupOptions', popupOptions);
			return;
		}
		
		for(var i=0, part; part=list_part[i]; i++){
			if(part.part['Id'] == sJson['pid']){
				delete part['Initial_Billing_Date__c'];
				delete part['Initial_Order_Date__c'];
				
				part.part['Process_Status__c'] = sJson['value'];
				break;
			}
		}
		comp.set('v.list_part', list_part);
	},
	
	event_addyear_click: function(comp, event) {
		var select=document.getElementById('addFc'), value=select.options[select.selectedIndex].value;
		if(value == 'none'){
			return;
		}
		
		value = parseInt(value);
		
		var that=this, list_new=[], list_year=comp.get('v.list_year'), len=list_year.length, list_forecastYear=comp.get('v.list_forecastYear');
		
		
		list_year.splice(list_year.indexOf(value), 1);
		list_forecastYear.push(value+'');
		list_year.sort();
		list_forecastYear.sort();
        /*
		while(len--){
			var y=list_year[len];
			if(y <= value){
				list_new.push(y+'');
				list_year.splice(len, 1);
			}
		}
		
		list_forecastYear = list_forecastYear.concat(list_new);
		list_forecastYear.sort();
		*/
		comp.set('v.list_year', list_year);
		comp.set('v.list_forecastYear', list_forecastYear);
		
		createForecast(that, list_forecastYear, value);
		
		that.anyChange(comp);
		
		
		function createForecast(that, list_forecastYear, cuurentYear){
			var list_fc=[], list_part=comp.get('v.list_part'), map_forecast=comp.get('v.map_forecast'), map_totalForecast=comp.get('v.map_totalForecast');
            console.log('list_forecastYear:::::'+ list_forecastYear);
			for(var key in map_forecast){
				var map_fc=map_forecast[key];
				for(var year in map_fc){
					list_fc = JSON.parse( JSON.stringify(map_fc[year]) );
					break;
				}
				break;
			}
			for(var i=0, fc; fc=list_fc[i]; i++){
				fc['Quantity__c'] = 0;
				fc['Sales_Price__c'] = 0;
			}
			
			for(var i=0, max=list_forecastYear.length; i<max; i++){
				var year=list_forecastYear[i];
				for(var key in map_forecast){
					var map_fc=map_forecast[key];
					if(!map_fc.hasOwnProperty(year)){
						map_fc[year] = JSON.parse( JSON.stringify(list_fc.slice(0)) );
					}
				}
				if(!map_totalForecast.hasOwnProperty(year)){
					map_totalForecast[year] = JSON.parse( JSON.stringify(list_fc.slice(0)) );
				}
			}
			
			map_totalForecast = that.getSortKeyMap(map_totalForecast);
			
			for(var i=0, part; part=list_part[i]; i++){
				var partId=part.part.Id, price=part.part.AverageSellPrice__c;
				if(map_forecast.hasOwnProperty(partId)){
					var map_fc=map_forecast[partId], map_new=that.getSortKeyMap(map_fc);
                    //console.log( 'map_new:::::', JSON.stringify(map_new));
                    console.log('partId::::' + partId);
                    console.log('price::::' + price);
					for(var year in map_new){
                        if (cuurentYear != year)
                            continue;
						for(var j=0, list_fc=map_new[year], fc; fc=list_fc[j]; j++){
							fc['Sales_Price__c'] = price;
						}
					}
					map_forecast[partId] = map_new;
				}
			}
			comp.set('v.map_totalForecast', map_totalForecast);
			comp.set('v.map_forecast', map_forecast);
			
		}
	},
    
    event_partQty_change: function(comp, event) {
        var that=this, target=event.currentTarget, pid=target.getAttribute('data-pid'),
			list_part=comp.get('v.list_part'), map_forecast=comp.get('v.map_forecast'), map_totalForecast=comp.get('v.map_totalForecast');
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
		value = Math.round( value );
		for(var i=0, part; part=list_part[i]; i++){
			if(pid == part.part.Id){
				part.quantity = that.showFormat( value );
				part.part.Quantity__c = value;
				break;
			}
		}
		
		if(!map_forecast.hasOwnProperty(pid)){
			alert('ERROR');
			return;
		}
		
		var map_fc=map_forecast[pid];
		for(var year in map_fc){
			var list_qty=map_totalForecast[year];
			for(var i=0, list_fc=map_fc[year], fc; fc=list_fc[i]; i++){
				fc.Quantity__c = list_qty[i].Quantity__c * value;
			}
		}
		comp.set('v.list_part', list_part);
		comp.set('v.map_forecast', map_forecast);
		
		var map_change=comp.get('v.map_change');
		if(map_change['isChange']){
			return;
		}
		
		if(!map_change.hasOwnProperty(pid)){
			map_change[pid] = {};
		}
		var map_year = map_change[pid];
		for(var year in map_totalForecast){
			if(!map_year.hasOwnProperty(year)){
				map_year[year] = year;
			}
		}
		
		
		map_change[pid] = map_year;

		comp.set('v.map_change', map_change);
		
	},

    event_save_click: function(comp, event) {
		var that=this;
		that.oppySaveHelper(comp, event, that);
	},

    event_edit_click: function(comp, event) {
        var vTarget=comp.get('v.target');
        vTarget.isView = false;
        comp.set('v.target', vTarget);
	},
    
    event_cancel_click: function(comp, event) {
        var modeEvent=comp.getEvent("modeEvent"), isAPL=comp.get('v.target').isAPL;
        
        modeEvent.setParams({'isView': true, 'isAPL': isAPL });
        modeEvent.fire();	// Fire the event
	},
	
    handleAPLCheckedEvent: function(comp, event) {
        
        var pId=event.getParam('id'), checked=event.getParam('checked'), list_part=comp.get('v.list_part');

        if(pId == 'allck'){
            for(var i=0, part; part=list_part[i]; i++){
                part['isChecked'] = checked;
            }
            comp.set('v.list_part', list_part);
            for(var i=0, list_checkbox=comp.find('leftTbody').getElement().querySelectorAll('input[type="checkbox"].msupd'), ckbox; ckbox=list_checkbox[i]; i++){
                ckbox.checked = checked;
            }
            return;
        }
        var count=0;
        for(var i=0, part; part=list_part[i]; i++){
            if(part.part['Id'] == pId){
                part['isChecked'] = checked;
                break;
            }
        }
        
		comp.set('v.list_part', list_part);
        
        var checkedLen=comp.find('leftTbody').getElement().querySelectorAll('input[type="checkbox"].msupd:checked').length;
        
        if(checkedLen == list_part.length){
            document.getElementById('allck_ck').checked = true;
        }else{
            document.getElementById('allck_ck').checked = false;
        }
        
	},
	
	handlepopupEvt: function(comp, event) {
		var sJson=JSON.parse( event.getParam("sJson") ), that=this;
		
		switch(sJson['type']){
			case 'delete' :				that.del_forecastYear(comp, sJson); break;
			case 'level'  :				that.set_forecastLevel(comp, sJson);  break;
			case 'method' :				that.set_forecastMethod(comp, sJson); break;
            case 'wonChange' :			that.set_forecastWonChangeChange(comp, sJson); break; 
            case 'wonChangeCancel' :	that.set_forecastWonChangeCancelChange(comp, sJson); break;	//wonChangeCancel
			case 'part' :				that.set_forecastPart(comp, sJson); break;
			case 'partChange' :			that.set_forecastPartChange(comp, sJson); break;
            case 'massupdateChange' :	that.set_massupdatePartChange(comp, sJson); break;
			case 'aplPartDateChange' :	that.set_forecastAplPartDateChange(comp, sJson); break;
			default: break;
		}
	},
    
    
    handleDateChangeEvt: function(comp, event) {
		var that=this, map_newForecast={}, map_newTotalForecast={}, vTarget=comp.get('v.target'), map_forecast=comp.get('v.map_forecast'), 
			map_totalForecast=comp.get('v.map_totalForecast'), options=getOptions();
			
		console.log( 'options', options );

		for(var key in map_forecast){
			if(!map_newForecast.hasOwnProperty(key)){
				map_newForecast[key] = {};
			}			
			var map_newFc=JSON.parse( JSON.stringify(options['map_fc']) ), map_fc=map_forecast[key], 
				list_group=getQuarterlyOrMonthlyGroupList(map_fc);
			for(var year in map_newFc){
				var list_fcMove=list_group.pop();
				if(list_fcMove){
					var fcMove=list_fcMove[options['point']];
					for(var i=0, fc; fc=list_fcMove[i]; i++){
						fc.Sales_Price__c = fcMove.Sales_Price__c;
					}
					map_newFc[year] = list_fcMove;
				}
			}
			
			map_newForecast[key] = map_newFc;
		}
				
		for(var i=0, list_part=comp.get('v.list_part'), part; part=list_part[i]; i++){
			if(part.part.Quantity__c != 0){
				if(map_newForecast.hasOwnProperty(part.part.Id)){
					map_newTotalForecast = JSON.parse( JSON.stringify(map_newForecast[part.part.Id]) );
					for(var year in map_newTotalForecast){
						for(var i=0, list_fc=map_newTotalForecast[year], fc; fc=list_fc[i]; i++){
							fc.Quantity__c = (fc.Quantity__c / part.part.Quantity__c);
						}
					}
				}
				break;
			}else{
				map_newTotalForecast = JSON.parse( JSON.stringify(map_newForecast[part.part.Id]) );
				for(var year in map_newTotalForecast){
					for(var i=0, list_fc=map_newTotalForecast[year], fc; fc=list_fc[i]; i++){
						fc.Quantity__c = (fc.Quantity__c / part.part.Quantity__c);
					}
				}
			}
		}
		
		var list_year=comp.get('v.list_year'), list_forecastYear=Object.keys(map_newTotalForecast).sort();

		for(var i=0, max=list_forecastYear.length; i<max; i++){
			var indexOf=list_year.indexOf( parseInt(list_forecastYear[i]) );
			if(indexOf != -1){
				list_year.splice(indexOf, 1);	//remove add year options
			}
		}
		list_year.sort();
		console.log('list_year', list_year);
		console.log('map_newForecast', map_newForecast);
		
		comp.set('v.list_year', list_year);
		comp.set('v.list_forecastYear', list_forecastYear);
		comp.set('v.map_totalForecast', map_newTotalForecast);
		comp.set('v.map_forecast', map_newForecast);
		
		this.anyChange(comp);
		
		function getQuarterlyOrMonthlyGroupList(map_o){
			var list_group=[], list_tmp=[], notEmptyStartYear=0, notEmptyIndex=0;
			for(var year in map_o){
				if(notEmptyStartYear != 0){
					break;
				}
				for(var i=0, list_fc=map_o[year], fc; fc=list_fc[i]; i++){
					if(fc.Quantity__c != 0){
						notEmptyIndex = i;
						notEmptyStartYear = year;
						break;
					}
				}
			}
			if(notEmptyStartYear == 0){
				return list_group; 
			}
			
			for(var year=notEmptyStartYear; ;year++){
				var list_fc=map_o[year];
				if(!list_fc){
					break;
				}
				if(notEmptyStartYear == year){
					var emptyFc=JSON.parse( JSON.stringify(list_fc[list_fc.length-1]) ), list_start=JSON.parse( JSON.stringify(list_fc.slice(notEmptyIndex, list_fc.length)) );
					emptyFc.Quantity__c = 0;
					emptyFc = JSON.stringify(emptyFc);
					
					for(var i=0; i<options['point']; i++){
						list_start.splice(0, 0, JSON.parse(emptyFc));
					}
					
					for(var i=0, max=options['selectYear']-options['startYear']; i<max; i++){
						for(var j=0; j<options['groupLen']; j++){
							list_start.splice(0, 0, JSON.parse(emptyFc));
						}
					}
					
					list_fc = list_start;
				}
				list_fc.reverse();
				combineInto(list_fc, list_tmp);
			}
			
			list_tmp.reverse();

			for(var i=0, max=list_tmp.length; i<max; i+=options['groupLen']){
				list_group.push( list_tmp.slice(i,i+options['groupLen']) );
			}
			
			list_group.reverse();
			
			if(list_group.length > 0){
				var list_lastFc=list_group[0];
				if(list_lastFc.length != options['groupLen']){
					var addLen=options['groupLen']-list_lastFc.length, fcMoveTmp=JSON.parse( JSON.stringify(list_lastFc[list_lastFc.length-1]) );
					fcMoveTmp.Quantity__c = 0;
					for(var i=0; i<addLen; i++){
						list_lastFc.push(fcMoveTmp);
					}
					list_group[0] = list_lastFc;
				}
			}
			
			return list_group;
			
		}
		
		function getYearlyGroupList(map_o){
			var list_tmp=[];
			for(var year in map_o){
				if(year < options['startYear']){
					continue;
				}
				list_tmp.push(map_o[year]);
			}
			list_tmp.reverse();
			return list_tmp;
		}
		
		function getOptions(){
			
			var list_fcTemplet=[], value=event.getParam('value'), dDate=new Date(value), selectedYear=dDate.getFullYear(), month=dDate.getMonth()+1, 
				moveYear=getMoveYear( parseInt(vTarget['fiscalYear']) ),
				options={'startYear': parseInt(vTarget['fiscalYear']), 'endYear': selectedYear, 'map_fc': {}, 'point': 0,
						 'selectYear': selectedYear, 'groupLen': (vTarget.opportunity.Level__c == 'Quarterly' ? 4 : 12)
						}, remainYear=selectedYear-moveYear['start'],
				moveMaxYear=parseInt( Math.max.apply( Math, vTarget['list_Years'] ) );

			switch(vTarget.opportunity.Level__c){
				case 'Quarterly':
						if(month < 3){
							options['point'] += 1;
						}else if(month < 6){
							options['point'] += 2;
						}else if(month < 9){
							options['point'] += 3;
						}
					break;
				case 'Monthly':
						if(month < 9){
							options['point'] = month+3;
						}else{
							options['point'] = month-9;
						}
					break;
			}
			options['endYear'] = moveYear['end'] + remainYear;
			options['endYear'] = (options['endYear'] < selectedYear ? selectedYear : options['endYear']);
			options['endYear'] = (options['point'] == 0 ? options['endYear'] : options['endYear']+1);
			options['endYear'] = (options['endYear'] > moveMaxYear ? moveMaxYear : options['endYear']);
			
			for(var year in map_totalForecast){
				list_fcTemplet = JSON.parse( JSON.stringify(map_totalForecast[year]) );
				for(var i=0, fc; fc=list_fcTemplet[i]; i++){
					fc.Quantity__c = 0;
					fc.Sales_Price__c = 0;
				}
				break;
			}
			
			for(var i=options['startYear']; i<=options['endYear']; i++){	//create empty forecast in end select year
				options['map_fc'][i] = JSON.parse( JSON.stringify(list_fcTemplet) );
			}
			
			return options;
		}
		
		function getMoveYear(sYear){
			var o={'start': sYear, 'end': sYear}, list_descYear=Object.keys(map_totalForecast), flg=false;
			for(var i=0, max=list_descYear.length; i<max; i++){
				var year=list_descYear[i];
				for(var key in map_forecast){
					var map_fc=map_forecast[key];
					for(var j=0, list_fc=map_fc[year], fc; fc=list_fc[j]; j++){
						if(fc.Quantity__c != 0){
							o['start'] = parseInt(year);
							flg = true;
							break;
						}
					}
					if(flg){ break; }
				}
				if(flg){ break; }
			}
			flg=false;
			list_descYear.reverse();
			for(var i=0, max=list_descYear.length; i<max; i++){
				var year=list_descYear[i];
				for(var key in map_forecast){
					var map_fc=map_forecast[key];
					for(var j=0, list_fc=map_fc[year], fc; fc=list_fc[j]; j++){
						if(fc.Quantity__c != 0){
							o['end'] = parseInt(year);
							flg = true;
							break;
						}
					}
					if(flg){ break; }
				}
				if(flg){ break; }
			}
			console.log('moveYear', o);
			return o;
		}
		
		function combineInto(list_put, list_unput) {
			var len=list_put.length;
			for (var i=0; i<len; i=i+5000) {	//batch 5000 data.
				list_unput.unshift.apply( list_unput, list_put.slice( i, i+5000 ) );
			}
		}
	},
    

	getSortKeyMap: function(map_value){
		var map_new={}, list_keys=Object.keys(map_value).sort();
		for(var i=0, max=list_keys.length; i<max; i++){
			var year=list_keys[i];
			map_new[year] = map_value[year];
		}
		return JSON.parse( JSON.stringify(map_new) );
	},
	
    numberResult: function(value){
        var userLocaleLang = $A.get("$Locale.userLocaleLang"),  v='';
        var userdecimal = $A.get("$Locale.decimal");
        console.log("userdecimal", userdecimal);
        var list_value = value.split(userdecimal);
        /*
        var list_value = value.split('.'),
        if(userLocaleLang == 'de'){
            list_value = value.split(',');
        }*/
        
        list_value[0] = list_value[0].replace(/[\,\.]/g,'');

        if(list_value.length == 2){
            v = list_value[0]+'.'+list_value[1];
        }else if(list_value.length > 2){
            var last = list_value[list_value.length-1];
            list_value = list_value.slice(0, list_value.length-1);
            for(var i=0, max=list_value.length; i<max; i++){
                v += list_value[i];
            }
            v = v + '.' + last;
        }else{
            v = list_value[0];
        }
        v = (v == '' ? 0 : parseFloat(v) );
        return {'isNumber': (v === +v), 'value': v};
    },

})