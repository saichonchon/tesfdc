
var cTimer, cPopupWindow=null;

;function initCtrlDocument(){
	Globalize.culture(this.locale).numberFormat.currency.symbol = "";
	
	var q = async.queue(function(task, callback) {
	    task['fn'](callback);
	}, 2);

	q.push([{fn: initExsitingBusinessLost},{fn: initOther}], function(err) {
	    console.log(err);
	});
	
	q.drain = function() {
		sumOfAllTotal();
	    console.log('all items have been processed');
	};
	$('#expando-business-unique-id th.custom-th-order, #section_other th.custom-th-order').off('click').on('click', event_order_click);
}

;function sumOfAllTotal(){
	var bcTotal=Globalize.parseFloat($('#businessCurrentTotal').html()), ocTotal=Globalize.parseFloat($('#otherCurrentTotal').html()),
		bnTotal=Globalize.parseFloat($('#businessNextTotal').html()), onTotal=Globalize.parseFloat($('#otherNextTotal').html());
		
	bcTotal = (isNumber(bcTotal) ? bcTotal : 0);	
	ocTotal = (isNumber(ocTotal) ? ocTotal : 0);	
	bnTotal = (isNumber(bnTotal) ? bnTotal : 0);	
	onTotal = (isNumber(onTotal) ? onTotal : 0);	
		
	$('#currentAllTotal').html( Globalize.format((bcTotal+ocTotal), 'n0') );
	$('#nextAllTotal').html( Globalize.format((bnTotal+onTotal), 'n0') );
}

;function event_order_click(e){
	
	var $target=$(e.currentTarget), $order=$target.find('div.custom-order'), index=$target.index(),
		$tb=$target.parent().parent().parent().find('tbody');
	
	if(!$order.hasClass('asc') && !$order.hasClass('desc')){
		orderByAsc($tb[0], index);
		$target.parent().find('div.custom-order').removeClass('desc asc');
		$order.removeClass('desc').addClass('asc');
		return;
	}
		
	if($order.hasClass('asc')){
		orderByDesc($tb[0], index);
		$target.parent().find('div.custom-order').removeClass('desc asc');
		$order.removeClass('asc').addClass('desc');
		return;
	}
	
	if($order.hasClass('desc')){
		reOrder($tb[0], 1);
		$target.parent().find('div.custom-order').removeClass('desc asc');
		$order.removeClass('desc');
		return;
	}
	
	;function reOrder(tb, n){
		var switching=true, switchcount=0, list_rows, i, x, y, shouldSwitch, dir;

		while (switching) {
			switching = false;
			list_rows = tb.getElementsByTagName("TR");
			for (i = 0; i < (list_rows.length - 1); i++) {
				shouldSwitch = false;
				x = list_rows[i].getElementsByTagName("TD")[n];
				y = list_rows[i + 1].getElementsByTagName("TD")[n];
				
				if (x.getElementsByTagName('A')[0].innerHTML > y.getElementsByTagName('A')[0].innerHTML) {
					shouldSwitch= true;
					break;
				}
			}
			
			if (shouldSwitch) {
				list_rows[i].parentNode.insertBefore(list_rows[i + 1], list_rows[i]);
				switching = true;
				switchcount ++;
			}
		}

	}
	
	;function orderByDesc(tb, n){
		var switching=true, switchcount=0, list_rows, i, x, y, shouldSwitch, dir;

		while (switching) {
			switching = false;
			list_rows = tb.getElementsByTagName("TR");
			for (i = 0; i < (list_rows.length - 1); i++) {
				shouldSwitch = false;
				x = list_rows[i].getElementsByTagName("TD")[n];
				y = list_rows[i + 1].getElementsByTagName("TD")[n];
				x = Globalize.parseFloat(x.getElementsByTagName('DIV')[0].innerHTML);
				y = Globalize.parseFloat(y.getElementsByTagName('DIV')[0].innerHTML);
				
				if (x < y) {
					shouldSwitch= true;
					break;
				}
			}
			
			if (shouldSwitch) {
				list_rows[i].parentNode.insertBefore(list_rows[i + 1], list_rows[i]);
				switching = true;
				switchcount ++;
			}
		}

	}
	
	;function orderByAsc(tb, n){
		var switching=true, switchcount=0, list_rows, i, x, y, shouldSwitch, dir;

		while (switching) {
			switching = false;
			list_rows = tb.getElementsByTagName("TR");
			for (i = 0; i < (list_rows.length - 1); i++) {
				shouldSwitch = false;
				x = list_rows[i].getElementsByTagName("TD")[n];
				y = list_rows[i + 1].getElementsByTagName("TD")[n];
				x = Globalize.parseFloat(x.getElementsByTagName('DIV')[0].innerHTML);
				y = Globalize.parseFloat(y.getElementsByTagName('DIV')[0].innerHTML);
				
				if (x > y) {
					shouldSwitch= true;
					break;
				}
			}
			
			if (shouldSwitch) {
				list_rows[i].parentNode.insertBefore(list_rows[i + 1], list_rows[i]);
				switching = true;
				switchcount ++;
			}
		}

	}
	
}

;function initOther(queueCallback){
	var $currentFiscal=$('#currentFiscal'), 
		o={'sql': $('#sqlOtherHide').val(), 'intCurrentFiscalYear': parseInt($currentFiscal.attr('data-year')), 'intCurrentFiscalMonth': parseInt($currentFiscal.attr('data-month'))};
	if(!o['sql']){
		$('#slds-spinner-other').addClass('slds-hide');
		return;
	}
	
	getRemoteValue(remoteOtherWon, JSON.stringify(o), function(result){
    	var $otherCurrent=$('#otherCurrentTbody'), $otherPrevious=$('#otherPreviousTbody'), 
    		cFiscalDate=new Date($('#currentFiscalHide').val()), template=document.getElementById('otherTemplate').innerHTML,
    		previousTemplate=document.getElementById('otherPreviousTemplate').innerHTML;
    	
    	result=JSON.parse(result), 
		
    	console.log('other result', result);
    	
    	async.each(result['list_other'], function(r, callback) {
    		
    	//	console.log(r['isCurrentYear'], '   ', r);
    		
    		
    		var $template=(r['isCurrentYear'] ? createTemplate($(template), r) : createTemplate($(previousTemplate), r)), 
    			$list_buttons=$template.find('td:first button');
				
			 if(r['relevantforSOP']){
			 	$list_buttons.filter('.custom-partner').addClass('slds-hide');
			 	$list_buttons.find('span.span-checked').removeClass('slds-hide').parent().attr('title', 'Remove Forecast from S&OP');
			 }else{	//"Remove Forecast from S&OP", "Add Forecast into S&OP", "Mark as in S&OP already"
			 	$list_buttons.find('span.span-checked').parent().attr('title', 'Add Forecast into S&OP');
			 }
			 
    		if(r['isCurrentYear']){
	    		$otherCurrent.append($template);
    		}else{
    			$template.find('td:last div').html('N/A');
    			$otherPrevious.append($template);
    		}
    		
    		callback();
		}, function(err) {
			
			sumOfOtherForecastTotal($otherCurrent, $otherPrevious);
			
			$('#slds-spinner-other').addClass('slds-hide');
		    queueCallback('initOther complete');
		});
    });

}

;function initExsitingBusinessLost(queueCallback){
	var sql=$('#sqlLostHide').val();
	if(!sql){
		$('#slds-spinner-lost').addClass('slds-hide');
		return;
	}
	
	var o={'sql': sql, 'periodYear': parseInt($('#currentFiscal').attr('data-periodyear'))};
	
	getRemoteValue(remoteExsitingBusinessLost, JSON.stringify(o), function(result){
    	var $currentDead=$('#lostCurrentDeadTbody'), $previousDead=$('#lostPreviousDeadTbody'), 
    		template=document.getElementById('lostTemplate').innerHTML;;
    		
    	result = JSON.parse(result), 
		
    	async.each(result['list_o'], function(r, callback) {
    		var $template=createTemplate($(template), r);

    		if( r.hasOwnProperty('Lost_Start_Fiscal_Year__c') ){
    			var lostYear = parseInt(r['Lost_Start_Fiscal_Year__c']);
    			
    			if(lostYear < o['periodYear']){	
    				var t=0;
    				if(r.hasOwnProperty('Estimated_Business_Value_Per_Quarter__c') && r.hasOwnProperty('Lost_Start_Fiscal_Month__c')){
    					var month=parseInt(r['Lost_Start_Fiscal_Month__c']);
    					t = r['Estimated_Business_Value_Per_Quarter__c']/3*(month-1);
    				}
    				
					$template.find('td[data-api="Estimated_Billing_Impact_for_Current_FY__c"] div').attr('title', -t).html(Globalize.format(-t, 'n0'));
    			
    				$template.find('td:last div').html('N/A');
    				$previousDead.append($template);
    			}else{
    				$currentDead.append($template);
    			}
    		}else{
    			var t=(r.hasOwnProperty('Estimated_Business_Value_Per_Quarter__c') ? (r['Estimated_Business_Value_Per_Quarter__c']/3*(month-1)) : 0);
				$template.find('td[data-api="Estimated_Business_Value_Per_Quarter__c"] div').attr('title', t).html(Globalize.format(t, 'n0'));
    			
    			$template.find('td:last div').html('N/A');
    			$previousDead.append($template);
    		}
    		
    		callback();
		}, function(err) {
			sumOfBusinessForecastTotal($currentDead, $previousDead, $('#userTerritoryCode').html());
		    $('#slds-spinner-lost').addClass('slds-hide');
		    queueCallback('initExsitingBusinessLost complete');
		});
    });
}

;function sumOfBusinessForecastTotal($currentDead, $previousDead, userTerritory){
	var cFind='td[data-api="Estimated_Billing_Impact_for_Current_FY__c"], td[data-api="Estimated_Billing_Impact_for_Next_FY__c"]',
		oFind='td[data-api="Estimated_Billing_Impact_for_Current_FY__c"], td[data-api="Estimated_Billing_Impact_for_Next_FY__c"]',
		oCurrent=sumOfSubTotal($currentDead.find(cFind), $('#lostCurrentTotal'), $('#lostNextTotal'), 'Estimated_Billing_Impact_for_Current_FY__c', 'Estimated_Billing_Impact_for_Next_FY__c', userTerritory),
		oPrevious=sumOfSubTotal($previousDead.find(oFind), $('#lostPreviousCurrentTotal'), $('#lostPreviousNextTotal'), 'Estimated_Billing_Impact_for_Current_FY__c', 'Estimated_Billing_Impact_for_Next_FY__c', userTerritory);
	
	console.log('oCurrent', oCurrent);	
	console.log('oPrevious', oPrevious);	
		
	$('#lostCurrentTotal').html( Globalize.format(oCurrent['c'], 'n0') );
	$('#lostNextTotal').html( Globalize.format(oCurrent['p'], 'n0') );
	
	$('#lostPreviousCurrentTotal').html( Globalize.format(oPrevious['c'], 'n0') );
	$('#lostPreviousNextTotal').html((oPrevious['p'] == 0 ? 'N/A' : Globalize.format(oPrevious['p'], 'n0')));
	
	$('#businessCurrent').html( Globalize.format(oCurrent['tc'], 'n0') );
	$('#businessCurrentNext').html( Globalize.format(oCurrent['tp'], 'n0') );
	
	$('#businessPreviousCurrent').html( Globalize.format(oPrevious['tc'], 'n0') );
//	$('#businessPreviousNext').html((oPrevious['p'] == 0 ? 'N/A' : Globalize.format(oPrevious['p'], 'n0')));
	
	$('#businessCurrentTotal').html( Globalize.format((oCurrent['tc']+oPrevious['tc']), 'n0') );
	$('#businessNextTotal').html( Globalize.format((oCurrent['tp']+oPrevious['tp']), 'n0') );
				
}

;function sumOfOtherForecastTotal($otherCurrent, $otherPrevious){
	var oCurrent=sumOfSubTotal($otherCurrent.find('td[data-api="CurrentFYNewBusinessIncremental"], td[data-api="NextFYNewBusinessIncremental"]'), $('#otherCurrentTotal'), $('#otherNextTotal'), 'CurrentFYNewBusinessIncremental', 'NextFYNewBusinessIncremental'),
		oPrevious=sumOfSubTotal($otherPrevious.find('td[data-api="CurrentFYNewBusinessIncremental"], td[data-api="NextFYNewBusinessIncremental"]'), $('#otherpRreviousCurrentTotal'), $('#otherpRreviousNextTotal'), 'CurrentFYNewBusinessIncremental', 'NextFYNewBusinessIncremental');
	

	$('#otherTableCurrentTotal').html(  Globalize.format(oCurrent['c'], 'n0') );
	$('#otherTableNextTotal').html( Globalize.format(oCurrent['p'], 'n0') );
	
	$('#otherTableRreviousCurrentTotal').html(  Globalize.format(oPrevious['c'], 'n0') );
	$('#otherTableRreviousNextTotal').html((oPrevious['p'] == 0 ? 'N/A' : Globalize.format(oPrevious['p'], 'n0')));
	
	$('#otherCurrent').html(  Globalize.format(oCurrent['c'], 'n0') );
	$('#otherNext').html( Globalize.format(oCurrent['p'], 'n0') );
	
	$('#otherPreviousCurrent').html( Globalize.format(oPrevious['c'], 'n0') );
	$('#otherPreviousNext').html((oPrevious['p'] == 0 ? 'N/A' : Globalize.format(oPrevious['p'], 'n0')));
	
	$('#otherCurrentTotal').html( Globalize.format((oCurrent['c']+oPrevious['c']), 'n0') );
	$('#otherNextTotal').html(  Globalize.format((oCurrent['p']+oPrevious['p']), 'n0') );
				
}

;function sumOfSubTotal($td, $current, $next, cApi, pApi, userTerritory){
	var o={c: 0, p: 0, tc: 0, tp: 0};
	
	$td.each(function(){
		var $this=$(this), api=this.getAttribute('data-api'), value=Globalize.parseFloat($this.find('div').html());

		value = (isNumber(value) ? value : 0);
		
		switch(api){
			case cApi: 
					o['c'] += value; 
					o['tc'] += (userTerritory === $this.parent().attr('data-territory') ? value : 0); 
				break;
			case pApi: 
					o['p'] += value; 
					o['tp'] += (userTerritory === $this.parent().attr('data-territory') ? value : 0); ; 
				break;
		}
	});
	
	$current.html((o['c'] == 0 ? 'N/A' : Globalize.format(o['c'], 'n0')));
	$next.html((o['p'] == 0 ? 'N/A' : Globalize.format(o['p'], 'n0')));
	
	return o;
}

;function sumOfExsitingBusinessLost($td, $current, $next){
	var o={c: 0, p: 0};
	$td.each(function(){
		var api=this.getAttribute('data-api'), value=Globalize.parseFloat($(this).find('div').html());

		value = (isNumber(value) ? value : 0);
		
		switch(api){
			case 'Estimated_Billing_Impact_for_Current_FY__c': o['c'] += value; break;
			case 'Estimated_Billing_Impact_for_Next_FY__c': o['p'] += value; break;
		}
	});
	
	$current.html((o['c'] == 0 ? 'N/A' : Globalize.format(o['c'], 'n0')));
	$next.html((o['p'] == 0 ? 'N/A' : Globalize.format(o['p'], 'n0')));
	
}

;function createTemplate($template, r){
	var stringify=JSON.stringify(r), territoryCode='';
	
	if(r.hasOwnProperty('Account_Name__r')){
		territoryCode = (r['Account_Name__r'].hasOwnProperty('SALES_TERRITORY_CDE__c') ? r['Account_Name__r']['SALES_TERRITORY_CDE__c'] : territoryCode);
	}
	
	$template.attr({'data-id': r['Id'], 'data-json': stringify, 'data-territory': territoryCode});
			 
	$template.find('td:not(:first)').each(function(){
		var api=this.getAttribute('data-api'), type=this.getAttribute('data-type').toLowerCase(), result=JSON.parse(stringify), 
			value='', title='';
		
		if(this.getAttribute('data-isInternalClass') === 'true'){
			result = result['o'];
			if(!result.hasOwnProperty(api)){
				var list_api=api.split('.'), replace=list_api[0].replace('__c', '__r').replace('Id', '');
				result = (result.hasOwnProperty(replace) ? result[replace] : result);
				api = list_api[1];
			}
		}
		
		switch(type){
			case 'double' : 
				value = (result.hasOwnProperty(api) ? result[api] : '');
				value = (isNumber(value) ? Globalize.format(parseFloat(value), 'n0') : value );
				title = value;
				break;
			case 'percent' : 
				value = (result.hasOwnProperty(api) ? result[api] : '');
				value = (isNumber(value) ? Globalize.format(parseFloat(value), 'n0')+'%' : value );
				title = value;
				break;
			case 'date' : 
				value = (result.hasOwnProperty(api) ? result[api] : '');
				value = (value ? Globalize.format(new Date(value), 'd') : value);
				title = value;
				break;
			case 'reference' :
				var replace=api.replace('__c', '__r').replace('Id', ''), 
					o=(result.hasOwnProperty(replace) ? result[replace] : {'Name': '', 'Id': ''});
				value = o['Name'];
				title = value;
				break;
			case 'link' : 
				title = result['Name'];
				value = '<a title="'+title+'" href="/'+result['oppId']+'" target="_blank">'+result['Name']+'</a>';
				break;
			default: 
				value = (result.hasOwnProperty(api) ? result[api] : '');
				title = value;
				value = (api == 'Name' ? '<a title="'+title+'" href="/'+result['Id']+'" target="_blank">'+value+'</a>' : value);
				break;
		}

		$(this).find('div').html(value).attr('title', title);
	});
	return $template;
}

;function event_otherFlag_click(target){
	if(addAPLWonForecast != '' && addAPLWonForecast == 'false') {
		alert('You have no permission to change this value.');
		return;
	}
	var $target=$(target), $span=$target.find('span.span-checked'), $tr=$target.parent().parent().parent();

	if($span.hasClass('slds-hide')){
		if(confirm("Are you sure that Add this Opportunity Forecast into S&OP Automaticlly?")){
			checkedOther(false);
		}
	}else{
		if(confirm("Are you sure that Remove this Opportunity Forecast from S&OP Automaticlly?")){
			checkedOther(true);
		}
	}
	
	;function checkedOther(flg){
		
		$('#slds-spinner-other').removeClass('slds-hide');
		
		var json=JSON.parse($tr.attr('data-json')), o={'sql': $('#sqlOtherHide').val(), 'isRemove': flg, 'idmap': json['idmap']};
		
		console.log('json', json);
		
		getRemoteValue(remoteAddRemoveOtherWon, JSON.stringify(o), function(result, event){
			if (event.status) {
				result = JSON.parse(result);
				
				$span.toggleClass('slds-hide');
				if($span.hasClass('slds-hide')){
					$target.attr('title', 'Add Forecast into S&OP');
				}else{
					$target.attr('title', 'Remove Forecast from S&OP');
				}
				$target.parent().find('button.custom-partner').toggleClass('slds-hide');
				shwoNotifySuccess(json['Name']);
			}else{
				shwoNotifyError(event['message']);
			}
			$('#slds-spinner-other').addClass('slds-hide');
		});
	
	}
	
}

;function event_otherOwn_click(target){
	var $target=$(target), $tr=$target.parent().parent().parent();
	
	if(confirm("Pls confirm that you have already manually added this opportunity forecast into APL Sales Forecast.")){
		checkedOther(true);
	}
	
	;function checkedOther(flg){
		
		$('#slds-spinner-other').removeClass('slds-hide');
		
		var json=JSON.parse($tr.attr('data-json')), o={'sql': $('#sqlOtherHide').val(), 'isRemove': flg, 'idmap': json['idmap']};
		
		console.log('json', json);
		
		getRemoteValue(remoteAddremoveOtherWonWithinSOP, JSON.stringify(o), function(result, event){
			if (event.status) {
				result = JSON.parse(result);
				
				$target.addClass('slds-hide');
				$target.parent().find('span.span-checked').removeClass('slds-hide').parent().attr('title', 'Remove Forecast from S&OP');
				shwoNotifySuccess(json['Name']);
			}else{
				shwoNotifyError(event['message']);
			}
			$('#slds-spinner-other').addClass('slds-hide');
		});
	
	}
	
}

;function event_deleteLoast_click(target){
	if (confirm('Are you sure?')){
		
		$('#slds-spinner-lost').removeClass('slds-hide');
		
		var $parent=$(target).parent().parent().parent(), o=JSON.parse($parent.attr('data-json')), list_ids=[o['Id']];
		getRemoteValue(remoteDeleteExsitingBusinessLost, JSON.stringify(list_ids), function(result, event){
			if (event.status) {
				$parent.remove();
				sumOfBusinessForecastTotal($('#lostCurrentDeadTbody'), $('#lostPreviousDeadTbody'), $('#userTerritoryCode').html());
				sumOfAllTotal();
				shwoNotifySuccess(result['Name']);
			}else{
				console.log(event);
			
				shwoNotifyError(event['message']);
			}
			$('#slds-spinner-lost').addClass('slds-hide');
		});
		
	}
}

;function event_editLoast_click(target){
	var $parent=$(target).parent().parent().parent(), o=JSON.parse($parent.attr('data-json')), $modalBusiness=$('#modalBusiness');
	

	$modalBusiness.find('div.slds-input-field-cls').each(function(){
		var $this=$(this), type=$this.attr('data-type'), api=$this.attr('data-api');
		
		switch(type){
			case 'string' : $this.find('input[type="text"]').val(o[api]); break;
			case 'picklist' : $this.find('select option[value="'+o[api]+'"]').prop('selected', true); break;
			case 'double' : 
				if(o.hasOwnProperty(api)){
					var n=Globalize.format(parseFloat(o[api]), 'n0');
					$this.find('input[type="text"]').val(n); 
				}
				break;
			case 'date' : 
				if(o.hasOwnProperty(api)){
					var d=Globalize.format(new Date(o[api]), 'd');
					$this.find('input[type="text"]').val(d); 
				}
				break;
			case 'reference' : 
				var replace=api.replace('__c', '__r');
				if(o.hasOwnProperty(replace)){
					$this.find('input[type="hidden"]').filter('[id*=_lkid]').val(o[api]); 
					$this.find('input[type="hidden"]').filter('[id*=_lkold]').val(o[replace]['Name']); 
					$this.find('input[type="text"]').val(o[replace]['Name']); 
				}
				break;
			case 'multipicklist' : 
				if(o.hasOwnProperty(api)){
					var list_options=[], list_pick=o[api].split(';'), $unselected=$this.find('select').filter('[id*=_unselected]'),
						$selected=$this.find('select').filter('[id*=_selected]');
					
				//	list_select=$this.find('tr.multiSelectPicklistRow select').toArray();

					for(var i=0, max=list_pick.length; i<max; i++){
						var pick=list_pick[i];
						$unselected.find('option').each(function(){
							var that=this;
							if($.trim(that.innerHTML) == pick){
								list_options.push(that);
								return false; 	//each break;
							}
						});
					}
					
					$selected.append(list_options);
				}
				break;
		}
		
	});
	$('#modal-heading-01').html('Edit '+o['Name']);
	$('#btnSaveBusinessLost').attr('data-id', o['Id']);
	$modalBusiness.toggleClass('slds-hide').find('input[type="text"]:first').focus();
}

;function event_newBusinessLostOpen_click(target){
	var $modalBusiness=$('#modalBusiness');
	$('#modal-heading-01').html('New APL Lost Dead Project');
	$modalBusiness.toggleClass('slds-hide').find('input[type="text"]:first').focus();
	
}

;function event_newBusinessLostClose_click(target){
	var $modalBusiness=$('#modalBusiness');
	
	$modalBusiness.find('div.slds-input-field-cls').each(function(){
		var $this=$(this), type=$this.attr('data-type');
		switch(type){
			case 'date' : 
			case 'double' : 
			case 'string' : $this.find('input[type="text"]').val(''); break;
			case 'picklist' : $this.find('select option[value=""]').prop('selected', true); break;
			case 'reference' : 
				$this.find('input[type="hidden"]').filter('[id*=_lkid]').val('000000000000000'); 
				$this.find('input[type="hidden"]').filter('[id*=_lkold]').val(''); 
				$this.find('input[type="text"]').val(''); 
				break;
			case 'multipicklist' : 
				var list_options=[], $unselected=$this.find('select').filter('[id*=_unselected]'),
					$selected=$this.find('select').filter('[id*=_selected]');
				
				$selected.find('option').each(function(){
					var that=this;
					list_options.push(that);
				});
				$unselected.append(list_options);
				break;
		}
	});
	$('#modal-heading-01').html('');
	$('#btnSaveBusinessLost').attr('data-id', '');
	$modalBusiness.toggleClass('slds-hide');
}

;function event_saveBusinessLost_click(target){
	var id=$(target).attr('data-id'), $modalBusiness=$('#modalBusiness'), o={Id: (id ? id : null)}, flg=false;
	
	$modalBusiness.find('div.slds-input-field-cls').each(function(){
		var $this=$(this), $input=$this.find('input[type="text"]'), api=$this.attr('data-api'),
			type=$this.attr('data-type'), required=$this.attr('data-required'), value=null;
		
		switch(type){
			case 'date' : 
				value = +Globalize.parseDate( $this.find('input[type="text"]').val() );
				value = (isNumber(value) && value != 0 ? value : null);
				break;
			case 'double' : 
				value = +Globalize.parseFloat( $this.find('input[type="text"]').val() );
				value = (isNumber(value) ? value : null);
				break;
			case 'string' : 
				value = $this.find('input[type="text"]').val(); 
				
				break;
			case 'reference' : 
				value = $this.find('input[type="hidden"]').filter('[id*=_lkid]').val();
				value = (value == '000000000000000' ? null : value);
				break;
			case 'picklist' : 
				value = $this.find('select option:selected').val().replace('__', ''); 
				break;
			case 'multipicklist' : 
				var list_options=[], $selected=$this.find('select').filter('[id*=_selected]');
				
				$selected.find('option').each(function(){
					var that=this;
					list_options.push($.trim(that.innerHTML));
				});
				$input = $this.find('select').filter('[id*=_unselected]');
				value = list_options.join(';');
				break;
		}
		o[api] = value;
		
		if(required == 'true' && (value == null || value == '' || value == '000000000000000') ){
			$input.focus();
			flg = true;
			return false;
		}
		
		
	});
	
	console.log(o);
	
	if(flg){
		return;
	}
	
	$('#slds-spinner-modal-lost').removeClass('slds-hide');
	
	getRemoteValue(remoteSaveExsitingBusinessLost, JSON.stringify(o), function(result, event){
		if (event.status) {
			result = JSON.parse(result);
			var $currentDead=$('#lostCurrentDeadTbody'), $previousDead=$('#lostPreviousDeadTbody'),
    			periodYear=parseInt($('#currentFiscal').attr('data-periodyear')), 
    			template=document.getElementById('lostTemplate').innerHTML, 
				$recordRow=$currentDead.find('tr[data-id="'+result['Id']+'"]');
				
			var $template=( $recordRow.length == 0 ? createTemplate($(template), result) : createTemplate($recordRow, result) );	
			
			if( result.hasOwnProperty('Lost_Start_Fiscal_Year__c') ){
    			var lostYear = parseInt( result['Lost_Start_Fiscal_Year__c'] );
    			if(lostYear == periodYear){
    				$currentDead.append($template);
    			}else if(lostYear == (periodYear - 1)){
    				var t=0;
    				if(result.hasOwnProperty('Estimated_Business_Value_Per_Quarter__c') && result.hasOwnProperty('Lost_Start_Fiscal_Month__c')){
    					var month=parseInt(result['Lost_Start_Fiscal_Month__c']);
    					t = result['Estimated_Business_Value_Per_Quarter__c']/3*(month-1);
    				}
    				
					$template.find('td[data-api="Estimated_Billing_Impact_for_Current_FY__c"] div').attr('title', -t).html(Globalize.format(-t, 'n0'));
    			
    				
    				$template.find('td:last div').html('N/A');
    				$previousDead.append($template);
    			}else{
    				console.log('lostYear', lostYear, '---', 'periodYear', periodYear);
    			}
    			sumOfBusinessForecastTotal($currentDead, $previousDead, $('#userTerritoryCode').html());
    			sumOfAllTotal();
    		}
    		
			event_newBusinessLostClose_click(null);
			
			shwoNotifySuccess(result['Name']);
		}else{
			console.log(event);
			
			shwoNotifyError(event['message']);
		}
		
		$('#slds-spinner-modal-lost').addClass('slds-hide');
	});
	
}

;function event_account_change(target){
	$('[id*=accountField]').val('');
    $('[id*=accountField_mod]').val(0);
    $('[id*=accountField_lkid]').val('000000000000000');
    $('[id*=accountField_lktp]').val('001');
    $('[id*=accountField_lspf]').val('0');
    $('[id*=accountField_lkold]').val('');
}

;function event_accountLockup_click(a, target){
	-1 != navigator.appName.indexOf("Microsoft") && (a = window.event);
            
    cPopup();
    
    var $inputAccount=$('#accountInput'), url='/apex/CtrlWithOutToolEnhancementLockUp?s='+$inputAccount.val();

    cPopupWindow=window.open(url, '', 'width=660,height=420,top='+(a.screenY+10)+',left='+(a.screenX-300)+',status=yes,scrollbars=yes,resizable=yes');

    if(cPopupWindow){
        cPopupWindow.focus();
        cTimer=window.setInterval(function(){
            if(cPopupWindow.closed){
                window.clearInterval(cTimer);
                console.log(window._returnValue);
                if(window._returnValue){
	                var oReturn=JSON.parse(window._returnValue);
	                
	                $inputAccount.val(oReturn['value']).attr({'data-id': oReturn['id']});
                    $('[id*=accountField]').val(oReturn['value']);
                    $('[id*=accountField_mod]').val(1);
                    $('[id*=accountField_lkid]').val(oReturn['id']);
                    $('[id*=accountField_lktp]').val('01t');
                    $('[id*=accountField_lspf]').val('0');
                    $('[id*=accountField_lkold]').val(oReturn['value']);
	                
                }
            }
        }, 500);
    }
}

;function cPopup() {
    cTimer && (clearInterval(cTimer), cTimer = null);
    if (null != cPopupWindow) {
        try {
            if (cPopupWindow.confirmOnClose && cPopupWindow.confirm(cPopupWindow.confirmOnCloseLabel))
                return cPopupWindow.confirmOnClose = !1,
                cPopupWindow.focus(),
                !1;
            cPopupWindow.close()
        } catch (a) {}
        cPopupWindow = null
    }
}

;function event_notifyClose(target, notifyId){
	$('#'+notifyId).addClass('slds-hide');
}

;function shwoNotifyError(message){
	$('#slds-notify-error').removeClass('slds-hide').find('#eMessage').html(message);
}

;function shwoNotifySuccess(message){
	$('#slds-notify-success').removeClass('slds-hide').find('#sMessage').html(message);
	setTimeout(function(){
		$('#slds-notify-success').addClass('slds-hide').find('#sMessage').html('');
	}, 2600);
}

;function event_taskAttachment_change(event, target){
	-1 != navigator.appName.indexOf("Microsoft") && (event = window.event);
	
	var file=target.files[0], MAX_FILE_SIZE=4500000; /* 6 000 000 * 3/4 to account for base64 */
	
	console.log(target.files.length);
	
	if(target.files.length == 0){
		return;
	}
	
	if (file.size > MAX_FILE_SIZE) {
        alert('File size cannot exceed ' + (MAX_FILE_SIZE/1024/1024).toFixed(2) + ' MB.\n' + 'Selected file size: ' + (file.size/1024/1024).toFixed(2)+' MB');
	    return;
    }
	
    $('#uploadLabel').html(file['name']);
	
    
    var fileInput=target, file=fileInput.files[0], fr=new FileReader();
		console.log(file);
    

    fr.onload = function(e){
		var workbook = new wijmo.xlsx.Workbook();
		workbook.load(e.target.result);
    	console.log(workbook);
    	
        
	};
	
//	fr.readAsBinaryString(file);
    fr.readAsDataURL(file);
    
}

;function event_sectionTotal_click(target){
	var $section_total=$('#section_total');
	$section_total.toggleClass('slds-is-open');
	
	setApexCookie('apex__total');
	
	
}
;function event_sectionBusiness_click(target){
	var $section_business=$('#section_business');
	$section_business.toggleClass('slds-is-open');
	
	setApexCookie('apex__lost');
}
;function event_sectionOther_click(target){
	var $section_other=$('#section_other');
	$section_other.toggleClass('slds-is-open');
	
	setApexCookie('apex__other');
}

;function event_exportToExcel_click(target){
	
	
	var list_rows=[];
	
    setElementCells($('#totalTable tr'), list_rows);
    
    setElementEmptyRows(list_rows);
    list_rows.push([$('#currentFiscalYearLostDead').html()]);
	setElementCells($('#lostCurrentTable thead tr'), list_rows);
    setElementCells($('#lostCurrentTable tbody tr'), list_rows);
    setElementTotalCells($('#lostCurrentTable tfoot tr td'), list_rows);
    
    setElementEmptyRows(list_rows);
    list_rows.push([$('#currentPreviousFiscalYearLostDead').html()]);
    setElementCells($('#lostPreviousTable thead tr'), list_rows);
    setElementCells($('#lostPreviousTable tbody tr'), list_rows);
    setElementTotalCells($('#lostPreviousTable tfoot tr td'), list_rows);
    
	setElementEmptyRows(list_rows);
    list_rows.push([$('#otherCurrentFiscalyearWon').html()]);
    setElementCells($('#otherCurrentTable thead tr'), list_rows);
    setElementCells($('#otherCurrentTable tbody tr'), list_rows);
    setElementTotalCells($('#otherCurrentTable tfoot tr td'), list_rows);
    
    setElementEmptyRows(list_rows);
    list_rows.push([$('#otherPreviousFiscalyearWon').html()]);
    setElementCells($('#otherPreviousTable thead tr'), list_rows);
    setElementCells($('#otherPreviousTable tbody tr'), list_rows);
    setElementTotalCells($('#otherPreviousTable tfoot tr td'), list_rows);

    
	downloadCSV('APL Forecast Tool Enhancement.csv', Papa.unparse(list_rows));
	
    ;function setElementEmptyRows(list_rows){
        for(var i=0; i<2; i++){
            list_rows.push([]);
        }
    }
    
    ;function setElementCells($rows, list_rows){
       
        $rows.each(function(){
             var list_cells=[];
            $(this).find('th:not(.actionCls), td:not(.actionCls)').each(function(){
                var $this=$(this);
                $this = ($this.find('div').length == 0 ? $this : $this.find('div'));
                $this = ($this.find('a').length == 0 ? $this : $this.find('a'));
                list_cells.push($this.html());
            });
            list_rows.push(list_cells);
        });
        
    }
    
    ;function setElementTotalCells($cells, list_rows){
        var list_cells=[];
        $cells.each(function(){
            var $this=$(this), colspan=$this.attr('colspan');
            if(colspan && colspan > 1){
                colspan = colspan-1;
                for(var i=0; i<colspan; i++){
                    list_cells.push('');
                }
            }else{
                list_cells.push($this.find('div').html());
            }
        });
        list_rows.push(list_cells);
    }
    
	return;
	
	
}

;function downloadCSV(fileName, csv){
    var link, reader, click, blob=new Blob([csv], {type: 'text/csv'});
    if (navigator.msSaveBlob) {
        navigator.msSaveBlob(blob, fileName);
    } else if (URL.createObjectURL) {
        link = document.createElement('a');
        click = function (element) {
            var evnt = document.createEvent('MouseEvents');
            evnt.initMouseEvent('click', true, false, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
            element.dispatchEvent(evnt);
        };
        link.download = fileName;
        link.href = URL.createObjectURL(blob);
        click(link);
        link = null;
    } else {
        reader = new FileReader();
        link = document.createElement('a');
        click = function (element) {
            var evnt = document.createEvent('MouseEvents');
            evnt.initMouseEvent('click', true, false, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
            element.dispatchEvent(evnt);
        };
        reader.onload = function () {
            link.download = fileName;
            link.href = reader.result;
            click(link);
            link = null;
        };
        reader.readAsDataURL(blob);
    }
}

;function setApexCookie(key){
	var result=null, rdecode=/(%[0-9A-Z]{2})+/g, list_cookies=document.cookie ? document.cookie.split('; ') : [];
	
	for(var i=0, max=list_cookies.length; i<max; i++){
		var list_part=list_cookies[i].split('='), cookie=list_part.slice(1).join('=');
		if(cookie.charAt(0) === '"') {
			cookie = cookie.slice(1, -1);
		}
		var name=list_part[0].replace(rdecode, decodeURIComponent);
		
		if(key === name){
			result = cookie;
			break;
		}
	}
	
	result = (result == 'true' ? 'false' : 'true');
	if(result){
		document.cookie = (key+'='+result+';path=/');
	}
	
}

;function isNumber(obj) {
    return obj === +obj;
}

function createUUID(len, radix) {
    var chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'.split('');
    var uuid = [], i;
    radix = radix || chars.length;
 
    if (len) {
		for (i = 0; i < len; i++) uuid[i] = chars[0 | Math.random()*radix];
    } else {
		var r;
		uuid[8] = uuid[13] = uuid[18] = uuid[23] = '-';
		uuid[14] = '4';
		
		for (i = 0; i < 36; i++) {
			if (!uuid[i]) {
				r = 0 | Math.random()*16;
				uuid[i] = chars[(i == 19) ? (r & 0x3) | 0x8 : r];
			}
		}
    }
 
    return uuid.join('');
}

;function getRemoteValue(fn, searchText, callBack) {
    Visualforce.remoting.Manager.invokeAction(
		fn(), searchText,  
		function(result, event){
			var r='[]';
	    	if (event.status) { r=result; } 
	    	else if (event.type === 'exception') { } 
	    	else { }
	    	callBack(r, event);
		}, {escape: false}
    );
}

;function addListener (element, event, fn, params) {
    var eventHandler = ( params ? function(){ fn.call(params); } : fn );
    if (window.attachEvent) {
        element.attachEvent('on' + event, eventHandler);
    } else {
        element.addEventListener(event, eventHandler, false);
    }
}
;function nextForecastAcctGroup() {//Added by Tangyong Li 2017-10-24
	window.location.href="/apex/CtrlAccountGrouping?isForecastTool=true";
}



