({
	helperMethod : function() {
		
	},
    
    manual_total_help: function(comp, event, number, year){
        var totalQty=0, map_forecast=comp.get('v.map_forecast'), list_part=comp.get('v.list_part');
        for(var i=0, part; part=list_part[i]; i++){
            var pId=part.part.Id, status=part.part.Status__c, map_fc=map_forecast[pId];
            if(status == 'Dead' || status == 'Lost'){
                continue;
            }
            
            if(map_fc.hasOwnProperty(year)){
                var list_fc=map_fc[year], fc=list_fc[number];
                if(fc){
                    totalQty += fc['Quantity__c'];
                }
            //    totalQty += (fc.Quantity__c * fc.Sales_Price__c);
                
            }
        }
        
        totalQty = Math.round(totalQty * Math.pow(10, 2)) / Math.pow(10, 2);
        totalQty = this.roundToKM(totalQty);
        comp.set('v.value', totalQty);
    },
    
    event_nextInput_keydown: function(comp, event) {
        
        
        
        var that=this, keyCode=event.keyCode;
        if(!(event.shiftKey && event.keyCode == 9) && keyCode != 13 && keyCode != 9){
            return;
        }
        if(keyCode == 9 || (event.shiftKey && event.keyCode == 9)){
            event.preventDefault();
        }
        var target=event.currentTarget, uid=comp.get('v.uniqueId'), isPrice=$A.util.hasClass(target, 'custom-price'), 
            $td=$(target).parent().parent().parent(), $tr=$td.parent(), maxIndex=$tr.find('td').length-1, cellIndex=$td[0].cellIndex;
        
        if(event.shiftKey && event.keyCode == 9){
            prevFocus();
            return;
        }
        
		nextFocus();
        
        function prevFocus(){
            if(isPrice){
                if($td.prev().length == 0){
                    var $prevTr=$tr.prev().prev();
                    if($prevTr.hasClass('custom-year-tr')){
						var $input=$tr.parent().parent().find('thead tr:last td:last input');
                        if($input.attr('readonly') === undefined){
                            that.setSelectionRange($input[0], 0, $input.val().length);
                        //    $input.focus();
                        }
                    }else if($prevTr.length != 0 && !$prevTr.hasClass('custom-display-none')){
                        var $input=$prevTr.find('td:eq('+maxIndex+') input');
                        that.setSelectionRange($input[0], 0, $input.val().length);
                    //    $prevTr.find('td:eq('+maxIndex+') input').focus();
                    }
                    
                }else{
                    var $input=$td.prev().find('input');
                    that.setSelectionRange($input[0], 0, $input.val().length);
                //    $td.prev().find('input').focus();
                }
                return;
            }
            
            if( (cellIndex != 0 && $tr.prev().hasClass('custom-tr-price')) || $tr.prev().hasClass('quantity_cls') ){
                var $input=$tr.parent().find('tr.'+uid+':last td:eq('+(cellIndex-1)+') input');
                that.setSelectionRange($input[0], 0, $input.val().length);
            //    $tr.parent().find('tr.'+uid+':last td:eq('+(cellIndex-1)+') input').focus();
            }else if(!$tr.prev().hasClass('custom-tr-price')){
                var $input=$tr.prev().find('td:eq('+cellIndex+') input');
                that.setSelectionRange($input[0], 0, $input.val().length);
           //     $tr.prev().find('td:eq('+cellIndex+') input').focus();
            }else{
                var $input=$tr.parent().find('tr.'+uid).eq(0).find('td:last input');
                that.setSelectionRange($input[0], 0, $input.val().length);
            //    $tr.parent().find('tr.'+uid).eq(0).find('td:last input').focus();
            }

        }
        
        function nextFocus(){
            if(isPrice){
                if($td.next().length == 0){
                    var $input=$tr.next().find('td:eq(0) input');
                	that.setSelectionRange($input[0], 0, $input.val().length);
                //    $tr.next().find('td:eq(0) input').focus();
                }else{
                    var $input=$td.next().find('input');
                	that.setSelectionRange($input[0], 0, $input.val().length);
                //    $td.next().find('input').focus();
                }
                return;
            }
            
            var $findInput=$tr.next().find('td:eq('+cellIndex+') input');
            
            if($findInput.length == 0){
            	var nextIndex=$td.next().index(), $nextTr=$tr.next().next();
                
                
                
                if(maxIndex == cellIndex && $nextTr.length != 0 && !$nextTr.hasClass('custom-display-none')){
                    var $input=$nextTr.find('td:eq(0) input');
                	that.setSelectionRange($input[0], 0, $input.val().length);
                //    $nextTr.find('td:eq(0) input').focus();
                }else if($nextTr.length !=0 && nextIndex != -1){
                    var $input=$tr.parent().find('tr:not(.custom-tr-price).'+uid).eq(0).find('td:eq('+nextIndex+') input');
                	that.setSelectionRange($input[0], 0, $input.val().length);
                //    $tr.parent().find('tr:not(.custom-tr-price).'+uid).eq(0).find('td:eq('+nextIndex+') input').focus();
                }else if($nextTr.length == 0){
                    if(nextIndex != -1){
                        
                        var $input=$tr.parent().find('tr:not(.quantity_cls):not(.custom-tr-price).'+uid).eq(0).find('td:eq('+nextIndex+') input');
                		that.setSelectionRange($input[0], 0, $input.val().length);
                    //    $tr.parent().find('tr:not(.quantity_cls).'+uid).eq(0).find('td:eq('+nextIndex+') input').focus();
                    }else{
                        var $nextInput=$tr.parent().parent().find('tbody tr:eq(2) td:eq(0) input');
                        
                        if($nextInput.length != 0){
                			that.setSelectionRange($nextInput[0], 0, $nextInput.val().length);
                        //    $nextInput.focus();
                        }else{
                            
                        }
                    }
                }
                return;
            }
            if($findInput.attr('readonly') === undefined){
                that.setSelectionRange($findInput[0], 0, $findInput.val().length);
            //	$findInput.focus();
                return;
            }
            
        }
	},
    
    setSelectionRange: function(input, selectionStart, selectionEnd) {
          if (input.setSelectionRange) {
            input.focus();
            input.setSelectionRange(selectionStart, selectionEnd);
          }else if (input.createTextRange) {
            var range = input.createTextRange();
            range.collapse(true);
            range.moveEnd('character', selectionEnd);
            range.moveStart('character', selectionStart);		        
            range.select();		        
          }
    },
    
    
    event_totalQty_changeHelp: function(comp, target){
        var list_uniqueId=[], that=this, value=that.numberResult(target.value), year=comp.get('v.year'), point=comp.get('v.number'),
            list_part=comp.get('v.list_part'), map_forecast=comp.get('v.map_forecast'), map_totalForecast=comp.get('v.map_totalForecast');

        value = (!value['isNumber'] ? 0 : value['value']);       
        map_totalForecast[year][point].Quantity__c = value;
        
    	for(var i=0, part; part=list_part[i]; i++){
			list_uniqueId.push(part.part['Id']);
            var partQty=part.part.Quantity__c;
            if(map_forecast.hasOwnProperty(part.part.Id)){
                var map_fc=map_forecast[part.part.Id];
                if(map_fc.hasOwnProperty(year)){
                    map_fc[year][point].Quantity__c = value*partQty;
                }
            }
        }
        
        comp.set('v.map_totalForecast', map_totalForecast);
        comp.set('v.map_forecast', map_forecast);
		that.anyChangRecord(comp, list_uniqueId, year);
    },
    
    event_qty_changeHelp: function(comp, target){
        var that=this, year=comp.get('v.year'), point=comp.get('v.number'),
            uniqueId=comp.get('v.uniqueId'), map_forecast=comp.get('v.map_forecast'), map_fc=map_forecast[uniqueId];
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

        if(!$A.util.isUndefined(map_fc)){
            var list_fc=map_fc[year];
            list_fc[point]['Quantity__c'] = value;
        }
        comp.set('v.map_forecast', map_forecast);
		
		that.anyChangRecord(comp, [uniqueId], year);
		
    },
    
	anyChangRecord: function(comp, list_uniqueId, year){
		var map_change=comp.get('v.map_change');
        
        if(map_change){
            if(map_change['isChange']){
                return;
            }
            
            for(var i=0, max=list_uniqueId.length; i<max; i++){
                var uniqueId=list_uniqueId[i];
                if(!map_change.hasOwnProperty(uniqueId)){
                    map_change[uniqueId] = {};
                }
                var map_year = map_change[uniqueId];
                if(!map_year.hasOwnProperty(year)){
                    map_year[year] = year;
                }
                
                map_change[uniqueId] = map_year;
            }
            comp.set('v.map_change', map_change);
        }
		
	},
	
    anyChange: function(comp){
        comp.set('v.map_change', {isChange: true});
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
        
        v = parseFloat(v);
        return {'isNumber': (v === +v), 'value': v};
    },
    
    roundToKM: function(txt){
        if(txt<100000){
            txt=Math.round(txt*100)/100;
            txt=this.showFormat(txt);
        }
        else if(txt<1000000){
            txt=Math.round(txt/10)/100;
            txt=this.showFormat(txt);
            txt+='K';
        }
        else if(txt<1000000000){
            txt=Math.round(txt/10000)/100;
            txt=this.showFormat(txt);
            txt+='M';				
        }else if(txt<1000000000000){
            txt=Math.round(txt/10000000)/100;
            txt=this.showFormat(txt);
            txt+='B';
        }else if(txt<1000000000000000){
            txt=Math.round(txt/10000000000)/100;
            txt=this.showFormat(txt);
            txt+='T';
        }else{
            txt='Error';
        }
        return txt;
    },
    
    showFormat: function(value){
        var newvalue = $A.localizationService.getDefaultNumberFormat().format(value);
        //console.log("newvalue", newvalue);
        return newvalue;
    },
    
    shwoFormatDecimal: function(num, decimals){
        var decimalString = '0.';
    	while (decimals-- > 0) decimalString += '#';
        return $A.localizationService.getNumberFormat( $A.get("$Locale.numberFormat").replace('0.###', decimalString) ).format(num);
    },
    
    shwoFormatPercent: function(num, decimals){
        var decimalString = '0.';
    	while (decimals-- > 0) decimalString += '0';
        return $A.localizationService.getNumberFormat( $A.get("$Locale.percentFormat").replace('0', decimals) ).format(num);
    },
    
    
})