var GCSV={'csvResult' : {'data': [], 'errors': [], 'meta': {}}, 'mapping': {}, 'list_str': [], 'map_months': {} }, 
	_queueTask=async.queue(queueTask, 1);

;function queueTask(task, callback) {
    task.run(callback);
}

_queueTask.drain = function() {
	console.log('');
}

;function initDocument() {
	Globalize.culture(this.locale).numberFormat.currency.symbol = "";
    
    $('#fromdate').val( Globalize.format(new Date($('#crtfiscaldate').val()), 'd') );
    register_event();
    initReportFiscalDate();
    document.getElementById('loading-curtain-div').style.display = 'none';
}

;function register_event(){
    var iframe = document.getElementById('theIframe');    
    $('#upsertBtn').on('click', event_upsertRecord);
    $('#downBtn').on('click', event_downCSV);
    $('#reportBtn').on('click', event_viewReport);
    $('#ultabid li').on('click', event_tab_change);
    $('#filterbtn').on('click', event_filter_click);
	$('#exportbox input').on('click', event_exportCSV_click);
    if (iframe.attachEvent){iframe.attachEvent("onload", iframeOnload_event);} 
    else {iframe.onload = iframeOnload_event;}
}

;function initReportFiscalDate(){
    var $filterDateBox=$('#fiscaldatefilter'), dfSort='yyyy-M', dfLong='yyyy-MM',  
    	crtFiscalDate=getCurrentFiscalDate($('#crtfiscaldate').val()), 
    	$ths=$('#reporthead th:gt(4)'), $tds=$('#reporttmp td:gt(4)'),
    	dLong=Globalize.format(crtFiscalDate, dfLong), dSort=Globalize.format(crtFiscalDate, dfSort);
	
	$filterDateBox.append('<input value="CM+1" data-long="'+dLong+'" data-sort="'+dSort+'" onclick="event_fiscalDate_click(event, this)" type="button" class="btn pdbtn btnactive" />');
	$ths.eq(0).attr({'data-long': dLong, 'data-sort': dSort});
	$tds.eq(0).attr({'data-long': dLong, 'data-sort': dSort});
	for(var i=1; i<=18; i++){
		crtFiscalDate.setMonth(crtFiscalDate.getMonth()+1);
		dLong=Globalize.format(crtFiscalDate, dfLong);
		dSort=Globalize.format(crtFiscalDate, dfSort);
		
		$ths.eq(i).attr({'data-long': dLong, 'data-sort': dSort});
        $tds.eq(i).attr({'data-long': dLong, 'data-sort': dSort});
        if(i != 18){
			$filterDateBox.append('<input value="CM+'+(i+1)+'" data-sort="'+dSort+'" data-long="'+dLong+'" onclick="event_fiscalDate_click(event, this)" type="button" class="btn btnactive pdbtn mgleft" />');
        }
	}
}

;function public_exportCSV(list_head, list_data){
	var config={fields: list_head, data: list_data, quotes: true, delimiter: ",", newline: "\r\n"},
		strCSV=Papa.unparse(config);
	
		var t=utf8ByteLength(strCSV);

	console.log(bytesToSize(t));
	
	exportCSVpost($('#downBtn').attr('data-url'), strCSV);
	setTimeout(function(){
		list_data=[];
		document.getElementById('loading-curtain-div').style.display = 'none';
	}, 560);
}

;function event_exportCSV_click(e){
	var list_head=[], o_head={}, $this=$(this), fn={'execute': $this.attr('data-type') == 'all' ? export_all : export_filter} ;
	
	$('#reporthead th:not(.none)').each(function(){
		var t=$.trim(this.innerHTML), field=this.getAttribute('data-mapping'), dsort=this.getAttribute('data-sort');
		if(dsort == null){
			o_head[t]=field;
		}else{
			o_head[t]=dsort;
		}
		list_head.push(t);
	});

	fn['execute']();
	
	
	;function export_all(){
		document.getElementById('loading-curtain-div').style.display = '';
		var filterDate='',
			json={'list_head': list_head, 'o_head': o_head, 'list_data': [], 'o_map': {}, 'limit': 10000, 'orderby': ' order by  id asc limit ', 'where': ' where id != null ',
					'query': 'select Id, Quantity__c, Fiscal_Date__c, Sold_To_Number__c, Sold_To_Name__c, Billing_Region__c, Fiscal_Year__c, Fiscal_Month__c, OEM__c, OEM__r.Name, Part__r.Name, Part__c, LastModifiedDate from CSD_CFT_Forecast__c ',
					'filterDate': ' AND () ',
					'json': '', '$tr': $('#reporttmp').clone().removeAttr('id').removeAttr('style')};
		
		$('#fiscaldatefilter input').each(function(idx){
	    	var isAND=(idx == 0 ? ' ' : ' OR ');
	    	filterDate += (isAND + ' Fiscal_Date__c  = ' + $(this).attr('data-long')+'-15  ');
	    });
	    filterDate = ' AND ( ' + filterDate + ' ) ';
	    json['filterDate'] = filterDate;
		json['json'] = (json['query']+json['where']+json['filterDate']+json['orderby']+json['limit']);
		
		console.log(json);
		customRemoteAction(json, runAllReportData_js, complete_runAllReportData);	
	}
	
	;function export_filter(){
		
		document.getElementById('loading-curtain-div').style.display = '';
		
		var dateFormat='yyyy-MM-dd', filterDate = '', tmp='',
	        json={'json': '', 'list_head': list_head, 'o_head': o_head, 'list_data': [], 'o_map': {}, 
	        	'query': 'select Id, Quantity__c, Fiscal_Date__c, Sold_To_Number__c, Sold_To_Name__c, Billing_Region__c, Fiscal_Year__c, Fiscal_Month__c, OEM__c, OEM__r.Name, Part__r.Name, Part__c, LastModifiedDate From CSD_CFT_Forecast__c',
	        	'where': ' Where Id != null ', 'filter': '', 'orderby': ' order by id asc ', 'limit': ' limit 10000'
	        };
	
	    $('#fiscaldatefilter input.btnactive').each(function(idx){
	    	var isAND=(idx == 0 ? ' ' : ' OR ');
	    	filterDate += (isAND + ' Fiscal_Date__c  = ' + $(this).attr('data-long')+'-15  ');
	    });
		 
		$('#filterbox input[type="button"].querycheck').each(function(idx){
			var $this=$(this), $parent=$this.parent().parent(), logic=$parent.find('select.logicselect option:selected').val(),
				logicField=$parent.find('select.fieldselect option:selected').val(), logicFilter=$parent.find('select.string option:selected').attr('data-filter'),
				logicString=$.trim($parent.find('input[type="text"].filtervalue').val());
			
			if(logicFilter == 'in' || logicFilter == 'not in'){
	            logicString = logicString.split(',');
	            var t=''
	            for(var i=0, max=logicString.length; i<max; i++){
	                t += ('\''+logicString[i]+'\',');
	            }
	            t = (t.length > 0 ? t.substring(0, t.length-1): '');
	            logicString = ('('+t+')');
	        }else if(logicFilter == 'like'){
	        	logicString = ' \''+logicString+'%\' ';
	        }else{
	            logicString = ' \'' +logicString+ '\' ';
	        }
	        
			logic = ' '+ (idx == 0 ? '' : logic)+ ' ';
			tmp +=  (logic+logicField+ ' ' + logicFilter + logicString);
		});
		
		filterDate = ' AND ( ' + filterDate + ' ) ';
		filterDate += (tmp == '' ? ' ': ' AND ('+tmp+') ');

		json['filter']=filterDate;
		json['json'] = (json['query']+json['where']+json['filter']+json['orderby']+json['limit']);
		console.log(json);
		customRemoteAction(json, runFilterReportData_js, complete_runFilterReportData);	
	}
	
	;function export_result(){
		var $body=$('#reportbody'), list_data=[], list_tr=$body.find('tr');
		if(list_tr.length == 0){
			artDialogBox('Not found search result.');
			return;
		}
		document.getElementById('loading-curtain-div').style.display = '';
		asyncEachSeries_Original(list_tr, function(item){
            var list_t=[], $tds=$(item).find('td:not(.none)');
            $tds.each(function(){
                list_t.push(this.getAttribute('data-old'));
            });
            list_data.push(list_t);
        }, function(err){
        	public_exportCSV(list_head, list_data);
        }, 30);
	}
}

;function event_fiscalDate_click(event, target){
	event = (event?event:window.event);
	event.cancelBubble = true;
	
	var $this=$(target), $parent=$this.parent(), $body=$('#reportbody'), fiscaldate=$this.attr('data-long');
	if($body.find('tr').length > 0){
		artDialogBoxCancel('The results will be deleted, whether or not to continue.', function(){
			$body.empty();
		});
		return;
	}
	
	if($this.hasClass('btnactive')){
		if($parent.find('input.btnactive').length <= 1){
			artDialogBox('FiscalDate cannot be zero.');
			return;
		}
		$this.removeClass('btnactive');
		$('#reporthead th[data-long="'+fiscaldate+'"]').addClass('none');
		return;
	}

	$this.addClass('btnactive');
	$('#reporthead th[data-long="'+fiscaldate+'"]').removeClass('none');
	
}

;function event_addFilter_click(event, target){
	event = (event?event:window.event);
	event.cancelBubble = true;
	
	var $this=$(target), $filterBox=$this.parent().parent();
	
	if($this.hasClass('new')){
		$filterBox.find('div:not(:last)').find('input, select').prop({'disabled': true});
		$this.addClass('edit').removeClass('new').val($this.attr('data-edit'));
		return;
	}
	$filterBox.find('div:not(:last)').find('input, select').prop({'disabled': false});
	$this.addClass('new').removeClass('edit').val($this.attr('data-ok'));
	
}

;function event_cancelFilter_click(event, target){
	event = (event?event:window.event);
	event.cancelBubble = true;
	var $parent=$(target).parent().parent(), $parentBox=$parent.parent();

	$parent.remove();
	$parentBox.find('div.filter-box:first').find('div.logic').css({'visibility': 'hidden'});
}

;function event_filter_click(e){//visibility: hidden;
	var $template=$('#filtertemplate div.filter-box').clone(), $filterBox=$('#filterbox'), $box=$filterBox.find('div.filter-box');
	if($box.length == 0){
		$template.find('div.logic').css({'visibility': 'hidden'});
	}
	if($box.length > 0 && !$box.first().find('div.btnbox input:first').hasClass('edit')){
		alert('Please make sure the first filter.');
		return false;
	}
	$filterBox.append($template);
}

;function event_runReport_click(event, target){
	event = (event?event:window.event);
	event.cancelBubble = true;
	document.getElementById('loading-curtain-div').style.display = '';
    
	var list_head=[], o_head={};
	
	$('#reporthead th:not(.none)').each(function(){
		var t=$.trim(this.innerHTML), field=this.getAttribute('data-mapping'), dsort=this.getAttribute('data-sort');
		if(dsort == null){
			o_head[t]=field;
		}else{
			o_head[t]=dsort;
		}
		list_head.push(t);
	});
	
	var dateFormat='yyyy-MM-dd', filterDate = '', tmp='',
        json={'json': '', 'list_head': list_head, 'o_head': o_head, 'list_data': [], 'o_map': {}, '$body': $('#reportbody').empty(),
        	'query': 'select Id, Quantity__c, Fiscal_Date__c, Sold_To_Number__c, Sold_To_Name__c, Billing_Region__c, Fiscal_Year__c, Fiscal_Month__c, OEM__c, OEM__r.Name, Part__r.Name, Part__c, LastModifiedDate From CSD_CFT_Forecast__c',
        	'where': ' Where Id != null ', 'filter': '', 'orderby': ' order by id asc ', 'limit': ' limit 10000'
        };

    $('#fiscaldatefilter input.btnactive').each(function(idx){
    	var isAND=(idx == 0 ? ' ' : ' OR ');
    	filterDate += (isAND + ' Fiscal_Date__c  = ' + $(this).attr('data-long')+'-15  ');
    });
	 
	$('#filterbox input[type="button"].querycheck').each(function(idx){
		var $this=$(this), $parent=$this.parent().parent(), logic=$parent.find('select.logicselect option:selected').val(),
			logicField=$parent.find('select.fieldselect option:selected').val(), logicFilter=$parent.find('select.string option:selected').attr('data-filter'),
			logicString=$.trim($parent.find('input[type="text"].filtervalue').val());
		
		if(logicFilter == 'in' || logicFilter == 'not in'){
            logicString = logicString.split(',');
            var t=''
            for(var i=0, max=logicString.length; i<max; i++){
                t += ('\''+logicString[i]+'\',');
            }
            t = (t.length > 0 ? t.substring(0, t.length-1): '');
            logicString = ('('+t+')');
        }else if(logicFilter == 'like'){
        	logicString = ' \''+logicString+'%\' ';
        }else{
            logicString = ' \'' +logicString+ '\' ';
        }
        
		logic = ' '+ (idx == 0 ? '' : logic)+ ' ';
		tmp +=  (logic+logicField+ ' ' + logicFilter + logicString);
	});
	
	filterDate = ' AND ( ' + filterDate + ' ) ';
	filterDate += (tmp == '' ? ' ': ' AND ('+tmp+') ');

	json['filter']=filterDate;
	json['json'] = (json['query']+json['where']+json['filter']+json['orderby']+json['limit']);
	console.log(json);
	customRemoteAction(json, runFilterReportData_js, complete_runFilterReportData_page);	
	
	
        /*
	var dateFormat='yyyy-MM-dd', filterDate = '',
		searchField=' Id, Quantity__c, Fiscal_Date__c, Sold_To_Number__c, Sold_To_Name__c, Billing_Region__c, Fiscal_Year__c, Fiscal_Month__c, OEM__c, OEM__r.Name, Part__r.Name, Part__c, LastModifiedDate ',
        query='select '+searchField+' From CSD_CFT_Forecast__c Where ', json={'json': query, '$body': $('#reportbody').empty()}, tmp='';
	
    $('#fiscaldatefilter input.btnactive').each(function(idx){
    	var isAND=(idx == 0 ? ' ' : ' OR ');
    	filterDate += (isAND + ' Fiscal_Date__c  = ' + $(this).attr('data-long')+'-15  ');
    });
	 
	$('#filterbox input[type="button"].querycheck').each(function(idx){
		var $this=$(this), $parent=$this.parent().parent(), logic=$parent.find('select.logicselect option:selected').val(),
			logicField=$parent.find('select.fieldselect option:selected').val(), logicFilter=$parent.find('select.string option:selected').attr('data-filter'),
			logicString=$.trim($parent.find('input[type="text"].filtervalue').val());
		
		if(logicFilter == 'in' || logicFilter == 'not in'){
            logicString = logicString.split(',');
            var t=''
            for(var i=0, max=logicString.length; i<max; i++){
                t += ('\''+logicString[i]+'\',');
            }
            t = (t.length > 0 ? t.substring(0, t.length-1): '');
            logicString = ('('+t+')');
        }else if(logicFilter == 'like'){
        	logicString = ' \''+logicString+'%\' ';
        }else{
            logicString = ' \'' +logicString+ '\' ';
        }
        
		logic = ' '+ (idx == 0 ? '' : logic)+ ' ';
		tmp +=  (logic+logicField+ ' ' + logicFilter + logicString);
	});
	
	filterDate = '( ' + filterDate + ' ) ';
	filterDate += (tmp == '' ? ' ': ' AND ('+tmp+')');
	query += (filterDate+' order by LastModifiedDate desc limit 12000');
	json['json'] = query;
	console.log(json);
	customRemoteAction(json, runReportData_js, complete_runReportData);	
	
		*/
}

;function event_tab_change(e){
	
	var _this=this, $this=$(_this), $parent=$this.parent(), 
		fn={'execute': $this.attr('data-type') == 'import' ? importTab : reportTab};
    if($this.hasClass('active')){
        return false;
    }
	
	fn['execute']();
	$this.addClass('active');
	
	
	;function importTab(){
		var $reportBtn = $parent.find('li[data-type="report"]');
		$reportBtn.removeClass('active');
		$('#import').addClass('active');
		$('#report').removeClass('active');
		$('#runtabmsg').hide();
		$('#errorboxtable').show();
	}
	
	;function reportTab(){
		var $importBtn = $parent.find('li[data-type="import"]');
		$importBtn.removeClass('active');
		$('#import').removeClass('active');
		$('#report').addClass('active');
		$('#runtabmsg').show();
		$('#errorboxtable').hide();
	}
	
}

;function event_viewReport(e){
	var _d = document.getElementById('reportA'), reportId = _d.getAttribute('data-reportid');
	if(reportId == ''){
		art.dialog({
	        title:' ', lock:true, dblclick_hide:false, esc:false, id: 'countsid',
	        content: 'Please set custom setting ->CSD Configuration -> Manager -> CFT Report ID.',
	        button : [ {value: 'Ok', focus: true, callback: function(){  }} ]
	    });
		return;
	}
	_d.href = ('/'+reportId);
	_d.click();
}

;function event_downCSV(e){
	exportCSVpost(this.getAttribute('data-url'), $('#jsoncsvnewhead').val());
}

;function deleteObjectComplete(){
	
	var isStop=$('[id*=isstopid]').val(), isError=$('[id*=iserrorid]').val();
	
	if(isStop == 'false' || isStop == false){
		deleteObject();	//this is action function
		return;
	}
	
	if((isStop == 'true' || isStop == true) && (isError == 'false' || isError == false)){
		document.getElementById('loading-curtain-div').style.display = 'none';
		createUpsertObject();
		return;
	}
	
	document.getElementById('loading-curtain-div').style.display = 'none';
}



;function iframeOnload_event(){
    var $ifream = $('#theIframe').contents(), _ifream = $ifream[0], 
    	_pageError = _ifream.getElementById("theErrorPage:theError"),
    	_coverBox=document.getElementById('loading-curtain-div'), 
    	$totalRecords=$('#totalrecords').text(0),
    	$error_head=$('#errortheadid').empty();

    GCSV = {'csvResult' : {'data': [], 'errors': [], 'meta': {}}, 'mapping': {}, 'list_str': [], 'map_months': {} };
    
    $('#errorboxtable').hide().find('#errorbodyid').empty();
	$('#totalsuccess').text(0);	
	$('#totalerror').text(0);	
    	
    if(typeof _pageError != "undefined" && _pageError != null){	//sfdc error must reload the ifream page
		_ifream.location.reload();
		$('#msgtextid').html(_pageError);
		$('#errmsgboxid').show();
		_coverBox.style.display = 'none';
		return;
	}

	if($ifream.find('[id*=isError]').val() == 'true'){
		$('#msgtextid').html($ifream.find('#errormessagedivId ul li').text());
		$('#errmsgboxid').show();
		_coverBox.style.display = 'none';
		return;
	}
	$('#errmsgboxid').hide();
	
	var $str=$ifream.find('#jsonbody'), config={worker: true, complete: csv_completeParse };
	
	Papa.parse($str.val(), config);	
	$str.val('');
}

;function csv_completeParse(results){
	var _coverBox=document.getElementById('loading-curtain-div');
	if(typeof(results) == 'undefined'){
		$('#totalrecords').text(0);
		_coverBox.style.display = 'none';
		return;
	}
	
	var $error_head=$('#errortheadid').empty(), map_mapping=$.parseJSON($('#jsonmapping').val()), 
		list_t=$('#jsoncsvnewhead').val().split(','), list_data_head=results['data'].shift(), 
		list_str=list_t.splice(0, 4), list_months=list_t.splice(0, list_t.length), isMatchHead=true;

	$error_head.append('<th class="errorcls">Error message</th>');

	for(var i=0, max=list_data_head.length; i<max; i++){
		var t=$.trim(list_data_head[i].replace(/\"/g, ''));
		GCSV['mapping'][i] = map_mapping[t];
		$error_head.append('<th class="brsolid" data-field="'+map_mapping[t]+'">'+t+'</th>');
		if(!map_mapping.hasOwnProperty(t) && t != 'LastModifiedDate'){
			isMatchHead=false;
		}
	}

	if(!isMatchHead){
		_coverBox.style.display = 'none';
		artDialogBox('Download CSV file with the current CSV file does not match.');
		return;
	}
	
	createMonths(list_months);
	GCSV['csvResult']['errors'] = results['errors'];
	GCSV['list_str'] = list_str;

	
	async.filter(results['data'], function(item, callback) {
	    setTimeout(function() {
	    	callback( ($.trim(item.join('')).length == 0 ? false : true) );
	    }, 30);
	}, function(asyncResults) {
	    GCSV['csvResult']['data'] = asyncResults;
		$('#totalrecords').text(GCSV['csvResult']['data'].length);
		_coverBox.style.display = 'none';
	});
	
	
	;function createMonths(list_t){
		var fiscalDate=getCurrentFiscalDateLess($('#crtfiscaldate').val());
		while(list_t.length > 0){
			var month = $.trim(list_t.shift());
			fiscalDate.setMonth(fiscalDate.getMonth()+1);
			GCSV['map_months'][map_mapping[month]] = {'year': fiscalDate.getFullYear(), 'month': (fiscalDate.getMonth()+1)};
		}
	}
	
}

;function event_upsertRecord(e){

	if(GCSV['csvResult']['data'].length == 0){
		art.dialog({
	        title:' ', lock:true, dblclick_hide:false, esc:false, id: 'countsid',
	        content: 'Not found save data.',
	        button : [ {value: 'Ok', focus: true, callback: function(){  }} ]
	    });
		return;
	}
	
	createUpsertObject();
	//document.getElementById('loading-curtain-div').style.display = '';
	//	deleteObject();

}

;function createUpsertObject(){
		
	$('div.progress_cls').show();
	
	var $pBar=$("#progressbar").progressbar({ value: false }), saveListL=GCSV['csvResult']['data'].length,
		batchNumber=parseInt($("#batchNumber").val(), 10), _color=getAnimateColor(saveListL, batchNumber), 
		sDate=$('#crtfiscaldate').val(), index=0, list_o=[];

	$pBar.attr('data-value', 0).progressbar({ max: _color['max'], change: pBarChange, complete: pBarComplete })
		 .find('.ui-progressbar-value').css({ "background": _color['bgcolor'] });
	
	async.eachSeries(GCSV['csvResult']['data'], function(item, callback) {
	    setTimeout(function() {
	    	var o = {'list_qty': [], 'index': index++};//, crtFiscalDate=getCurrentFiscalDate(sDate);
			for(var i=0, max=item.length; i<max; i++){
				o[GCSV['mapping'][i]] = $.trim(item[i].replace(/\"/g, ''));
			}
			
			for(var key in GCSV['map_months']){
				if(o.hasOwnProperty(key)){
					o['list_qty'].push( {'fYear': GCSV['map_months'][key]['year'], 'fMonth': GCSV['map_months'][key]['month'], 'qty': getZeroOfNumber(o[key])} );
				}
			}
			list_o.push(o);
        	callback(null);
	    }, 5);
	}, function(err) {
		var list_save = [];
		for(var i=0,len=list_o.length; i<len; i+=batchNumber){
			list_save.push(list_o.slice(i, i+batchNumber));
		}
		console.log( list_save );
		async.eachSeries(list_save, function(item, callback) {
	    	setTimeout(function() {
	    		var ojson={'json': JSON.stringify(item), 'data': item, '$pBar': $pBar, 'percent': _color['percent'], 'max': _color['max']};
				customRemoteAction(ojson, upsertListCFTForecast_js, complete_upsertCFTForecast_js);
	    		callback(null);
	    	}, 160);
		}, function(err) { list_save=[]; });
	    GCSV['csvResult']['data'] = [];
	});	 

	;function createMonths(o, d){
		
		
		/*
		
		o['list_qty'].push({ 'fYear': d.getFullYear(), 'fMonth': (d.getMonth()+1), 'qty': getZeroOfNumber(o['m1']) });
		
		d.setMonth(d.getMonth()+1);
		o['list_qty'].push({ 'fYear': d.getFullYear(), 'fMonth': (d.getMonth()+1), 'qty': getZeroOfNumber(o['m2']) });

		d.setMonth(d.getMonth()+1);
		o['list_qty'].push({ 'fYear': d.getFullYear(), 'fMonth': (d.getMonth()+1), 'qty': getZeroOfNumber(o['m3']) });
		
		d.setMonth(d.getMonth()+1);
		o['list_qty'].push({ 'fYear': d.getFullYear(), 'fMonth': (d.getMonth()+1), 'qty': getZeroOfNumber(o['m4']) });
		
		d.setMonth(d.getMonth()+1);
		o['list_qty'].push({ 'fYear': d.getFullYear(), 'fMonth': (d.getMonth()+1), 'qty': getZeroOfNumber(o['m5']) });
		
		d.setMonth(d.getMonth()+1);
		o['list_qty'].push({ 'fYear': d.getFullYear(), 'fMonth': (d.getMonth()+1), 'qty': getZeroOfNumber(o['m6']) });
		
		d.setMonth(d.getMonth()+1);
		o['list_qty'].push({ 'fYear': d.getFullYear(), 'fMonth': (d.getMonth()+1), 'qty': getZeroOfNumber(o['m7']) });
		
		d.setMonth(d.getMonth()+1);
		o['list_qty'].push({ 'fYear': d.getFullYear(), 'fMonth': (d.getMonth()+1), 'qty': getZeroOfNumber(o['m8']) });
		
		d.setMonth(d.getMonth()+1);
		o['list_qty'].push({ 'fYear': d.getFullYear(), 'fMonth': (d.getMonth()+1), 'qty': getZeroOfNumber(o['m9']) });
		
		d.setMonth(d.getMonth()+1);
		o['list_qty'].push({ 'fYear': d.getFullYear(), 'fMonth': (d.getMonth()+1), 'qty': getZeroOfNumber(o['m10']) });
		
		d.setMonth(d.getMonth()+1);
		o['list_qty'].push({ 'fYear': d.getFullYear(), 'fMonth': (d.getMonth()+1), 'qty': getZeroOfNumber(o['m11']) });
		
		d.setMonth(d.getMonth()+1);
		o['list_qty'].push({ 'fYear': d.getFullYear(), 'fMonth': (d.getMonth()+1), 'qty': getZeroOfNumber(o['m12']) });
		*/
	}
	
	
	;function getAnimateColor(len, bn){
		var percent=(1 / (len/bn) * 100), max=Math.floor(percent * (len/bn)), 
		bg_color=Math.floor( Math.random()*16777215 ).toString(16), list_rgba=$.Color('#'+bg_color)._rgba, 
		rgba=( 'rgba('+list_rgba[0]+','+list_rgba[1]+','+list_rgba[2]+',0.3)' );
		return {'percent': percent, 'max': max, 'bgcolor': ('#'+bg_color), 'rgba': rgba};
	}
	
}
;function getCurrentFiscalDate(s){
	var list_date=s.split('-'), d=new Date();
	d.setFullYear( parseInt(list_date[0], 10) );
	d.setMonth( (parseInt(list_date[1], 10)-1) );
    d.setDate(15);
	return d;
}

;function getCurrentFiscalDateLess(s){
	var list_date=s.split('-'), d=new Date();
	d.setFullYear( parseInt(list_date[0], 10) );
	d.setMonth( (parseInt(list_date[1], 10)-2) );
    d.setDate(15);
	return d;
}
;function complete_runAllReportData(result, event, data){
	if(event.status){
		result = $.parseJSON(result);

		while(result['list_reports'].length > 0){
			var item=result['list_reports'].shift(), strDate=(item['fYear']+'-'+item['fMonth']),
				externalKey=item['externalKey'], 
				o={'soldToName': item['soldToName'], 'oemName': item['oemName'], 'partName': item['partName'],
					'billingRegion': item['billingRegion'], 'LastModifiedDate': item['LastModifiedDate']};
			if(!data['o_map'].hasOwnProperty(externalKey)){
				data['o_map'][externalKey]=o;
				data['o_map'][externalKey][strDate]=item['qty'];
			}else{
				data['o_map'][externalKey][strDate]=item['qty'];
			}
		}
		
		if(result['lastId'] != ''){
			var lastID = (' AND Id > \''+result['lastId']+'\' ');
			data['json'] = (data['query']+data['where']+data['filterDate']+lastID+data['orderby']+data['limit']);
			customRemoteAction(data, runAllReportData_js, complete_runAllReportData);
			result={};
			return;
		}
		if( $.isEmptyObject(data['o_map']) ){
			document.getElementById('loading-curtain-div').style.display = 'none';
			return;
		}

		var list_data=[];

		for(var key in data['o_map']){
			var item=data['o_map'][key], list_tmp=[];
			for(var i=0, head; head=data['list_head'][i]; i++){
				var keyField=data['o_head'][head];
				list_tmp.push(item[keyField]);
			}
			list_data.push(list_tmp);
		}
		console.log( list_data.length );
		public_exportCSV(data['list_head'], list_data);

	}else{
		alert(event['message']);
		data['list_data'] = [];
		document.getElementById('loading-curtain-div').style.display = 'none';
	}

}
;function complete_runFilterReportData(result, event, data){
	if(event.status){
		result = $.parseJSON(result);
		while(result['list_reports'].length > 0){
			var item=result['list_reports'].shift(), strDate=(item['fYear']+'-'+item['fMonth']),
				externalKey=item['externalKey'], 
				o={'soldToName': item['soldToName'], 'oemName': item['oemName'], 'partName': item['partName'],
					'billingRegion': item['billingRegion'], 'LastModifiedDate': item['LastModifiedDate']};

			if(!data['o_map'].hasOwnProperty(externalKey)){
				data['o_map'][externalKey]=o;
				data['o_map'][externalKey][strDate]=item['qty'];
			}else{
				data['o_map'][externalKey][strDate]=item['qty'];
			}
		}
		
		if(result['lastId'] != ''){
			var lastID = (' AND Id > \''+result['lastId']+'\' ');
			data['json'] = (data['query']+data['where']+data['filter']+lastID+data['orderby']+data['limit']);
			customRemoteAction(data, runFilterReportData_js, complete_runFilterReportData);
			result={};
			return;
		}
		if( $.isEmptyObject(data['o_map']) ){
			document.getElementById('loading-curtain-div').style.display = 'none';
			return;
		}

		var list_data=[];

		for(var key in data['o_map']){
			var item=data['o_map'][key], list_tmp=[];
			for(var i=0, head; head=data['list_head'][i]; i++){
				var keyField=data['o_head'][head];
				list_tmp.push(item[keyField]);
			}
			list_data.push(list_tmp);
		}

		public_exportCSV(data['list_head'], list_data);

	}else{
		alert(event['message']);
		data['list_data'] = [];
		document.getElementById('loading-curtain-div').style.display = 'none';
	}

}
;function complete_runFilterReportData_page(result, event, data){
	if(event.status){
		result = $.parseJSON(result);
		while(result['list_reports'].length > 0){
			var item=result['list_reports'].shift(), strDate=(item['fYear']+'-'+item['fMonth']),
				externalKey=item['externalKey'], 
				o={'soldToName': item['soldToName'], 'oemName': item['oemName'], 'partName': item['partName'],
					'billingRegion': item['billingRegion'], 'accName': item['accName'], 'LastModifiedDate': item['LastModifiedDate']};

			if(!data['o_map'].hasOwnProperty(externalKey)){
				data['o_map'][externalKey]=o;
				data['o_map'][externalKey][strDate]=item['qty'];
			}else{
				data['o_map'][externalKey][strDate]=item['qty'];
			}
		}
		
		if(result['lastId'] != ''){
			var lastID = (' AND Id > \''+result['lastId']+'\' ');
			data['json'] = (data['query']+data['where']+data['filter']+lastID+data['orderby']+data['limit']);
			customRemoteAction(data, runFilterReportData_js, complete_runFilterReportData_page);
			result={};
			return;
		}
		if( $.isEmptyObject(data['o_map']) ){
			document.getElementById('loading-curtain-div').style.display = 'none';
			return;
		}
		
		var $tr=$('#reporttmp').clone().removeAttr('id').removeAttr('style');
			
		$('#reporthead th.none').each(function(){
			$tr.find('td:eq('+this.cellIndex+')').addClass('none');
		});
		
		for(var key in data['o_map']){
			var item=data['o_map'][key], $clone=$tr.clone();

			for(var i=0, head; head=data['list_head'][i]; i++){
				var keyField=data['o_head'][head];
				$clone.find('td[data-sort="'+keyField+'"]').html(Globalize.format(item[keyField], 'n0')).attr({'data-old': item[keyField]});
				if(head == 'LastModifiedDate'){
					$clone.find('td[data-mapping="'+keyField+'"]').html( Globalize.format(item[keyField], 'd') );
				}else{
					$clone.find('td[data-mapping="'+keyField+'"]').html(item[keyField]).attr({'title': item['accName'], 'data-old': item[keyField]});
				}
			}
			data['$body'].append($clone);
		}
		
		document.getElementById('loading-curtain-div').style.display = 'none';
	}else{
		alert(event['message']);
		data['list_data'] = [];
		document.getElementById('loading-curtain-div').style.display = 'none';
	}

}
;function complete_runReportData(result, event, data){
	if(event.status){
		result = $.parseJSON(result);
		var $body=$('#reportbody'), $tr=$('#reporttmp').clone().removeAttr('id').removeAttr('style');
			
		$('#reporthead th.none').each(function(){
			$tr.find('td:eq('+this.cellIndex+')').addClass('none');
		});

		asyncEachSeries_Original(result, function(items, call){
			var $clone=$tr.clone();
			while (items['list_cft'].length > 0) {
				var item=items['list_cft'].shift(), strDate=(item['fYear']+'-'+item['fMonth']);
				console.log( item );
				$clone.find('td[data-mapping="soldToName"]').html(item['soldToName']).attr({'title': item['accName'], 'data-old': item['soldToName']});
                $clone.find('td[data-mapping="oemName"]').html(item['oemName']).attr({'data-old': item['oemName']});
				$clone.find('td[data-mapping="partName"]').html(item['partName']).attr({'data-old': item['partName']});
				$clone.find('td[data-mapping="billingRegion"]').html(item['billingRegion']).attr({'data-old': item['billingRegion']});
				$clone.find('td[data-sort="'+strDate+'"]').html(Globalize.format(item['qty'], 'n0')).attr({'data-old': item['qty']});
			}
			$body.append($clone);
		}, function(err){
			result=[];
			document.getElementById('loading-curtain-div').style.display = 'none';
		}, 10);
		
/*
		for(var key in result){
			(function(key, list_item, $body, $tr){
				_queueTask.push({name: key, run: function(cb){
					var $clone=$tr.clone();
					for(var i=0, item; item=list_item[i]; i++){
					//	var item=list_item.shift();
						var strDate=(item['fYear']+'-'+item['fMonth']);
	                    $clone.find('td[data-mapping="soldToName"]').html(item['soldToName']).attr({'title': item['accName'], 'data-old': item['soldToName']});
	                    $clone.find('td[data-mapping="oemName"]').html(item['oemName']).attr({'data-old': item['oemName']});
						$clone.find('td[data-mapping="partName"]').html(item['partName']).attr({'data-old': item['partName']});
						$clone.find('td[data-mapping="billingRegion"]').html(item['billingRegion']).attr({'data-old': item['billingRegion']});
						$clone.find('td[data-sort="'+strDate+'"]').html(Globalize.format(item['qty'], 'n0')).attr({'data-old': item['qty']});
					}
					list_item=[];
					//while (list_item.length > 0) {
					//}
					$body.append($clone);
					cb(null);
			    }}, function(err){ });
			})(key, result[key], $body, $tr);
		}
		*/
	}else{
		document.getElementById('loading-curtain-div').style.display = 'none';
	}
}

;function complete_upsertCFTForecast_js(result, event, data){
	
    _queueTask.push({name: (data['$pBar'].progressbar("value") || 0), run: function(cb){
    	
    	var $errorBody=$('#errorbodyid'), $ths=$('#errortheadid th:not(.errorcls)'),
    		percent=parseFloat(data['$pBar'].attr('data-value')), max=data['max'];

	    result = $.parseJSON(result);

		if(event.status){
			for(var i=0, er; er=result[i]; i++){
		    	for(var j=0, der; der=data['data'][j]; j++){
		    		if(der['index'] == er['index']){
		    			var el_t='<td><b style="color:red;" class="errorbcls">'+er['errorMsg']+'</b></td>';
						$ths.each(function(){
							var fieldName=this.getAttribute('data-field');
							el_t +=('<td>'+(der[fieldName])+'</td>');
						});
		    			$errorBody.append(('<tr id="index'+der["index"]+'" indexData="'+der["index"]+'">'+el_t+'</tr>'));
						progressStatusText('#totalerror', 1);
		    		}
		    	}
		    }
		    progressStatusText('#totalsuccess', data['data'].length-result.length);
	    }else{
	    	data['msg'] = event;

			for(var i=0, der; der=data['data'][i]; i++){
				var el_t='<td><b style="color:red;" class="errorbcls">'+event['message']+'</b></td>';
				$ths.each(function(){
					var fieldName=this.getAttribute('data-field');
					el_t +=('<td>'+(der[fieldName])+'</td>');
				});
    			$errorBody.append(('<tr id="index'+der["index"]+'" indexData="'+der["index"]+'">'+el_t+'</tr>'));
			}
			
	    	progressStatusText('#totalerror', data['data'].length);
	    }
	    
	    percent = ($.isNumeric(percent) ? percent : 0), 
	    percent = (data['percent']+percent);
	    max = (Math.round(percent) >= data['max'] ? 100 : percent);
		
		data['$pBar'].attr('data-value', percent).progressbar("value", max).find('div.progress-label').html(max.toFixed(2)+'%');

        cb(null);
    }}, function(err){ });
	
    ;function progressStatusText(_id, total){
    	$(_id).html(function(){
			var t = parseInt($.trim(this.innerHTML), 10);
			return ($.isNumeric(t) ? (t+total) : 0);
		});
    }
    
}

;function closeProgressBox(target){
	var $cont = $('#errorbodyid'), $list = $cont.children('tr');	
	$list.sorted({ reversed: false, by: function(elem){ return parseFloat(elem.attr("indexdata")) } }).prependTo($cont);

	$('#progressbarbtn_div').hide();
	$('#saveProgressCoverBox').fadeOut(function(){
		$(this).find('#progressbar').progressbar('destroy').find('div.progress-label').html('Loading...');
	});
	$('#saveProgressCover').fadeOut();
	
	if($('#errorbodyid tr').length != 0){
		$('#errorboxtable').show();
	}
	
}

;function pBarChange(event, ui){
}

;function pBarComplete(event, ui){
	$('#progressbarbtn_div').show();
}

;function getZeroOfNumber(t){
	t=parseFloat(t);
	return ($.isNumeric(t) ? t : 0);
}

;function exportCSVpost(URL, PARAMS) {
	var temp=document.createElement("form"), hidden=document.createElement("input");
	temp.action=URL;
	temp.id = "exportcsvform";
	temp.method="POST";
	temp.style.display="none";
	
	hidden.type="hidden";
	hidden.name='exp';
	hidden.value=PARAMS;
	temp.appendChild(hidden);
	document.body.appendChild(temp);
	temp.submit();
	$('#exportcsvform').remove();
	return temp;
}

;function customRemoteAction(strParam, callFunction, callResult) {
    Visualforce.remoting.Manager.invokeAction(
        callFunction(), strParam['json'], function(result, event){ callResult(result, event, strParam); }, {escape: false, timeout:120000}
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

;function artDialogBox(content){
	art.dialog({
        title:' ', lock:true, dblclick_hide:false, esc:false, id: 'countsid', content: content,
        button : [ {value: 'Ok', focus: true, callback: function(){  }} ]
    });
}
;function artDialogBoxCancel(content, call){
	art.dialog({
        title:' ', lock:true, dblclick_hide:false, esc:false, id: 'countsid', content: content,
        button : [ {value: 'Ok', focus: true, callback: function(){ call(); }}, 
        			{value: 'Cancel', focus: false, callback: function(){  }} 
    			]
    });
}

;function asyncEachSeries_Original(result, asyncCallBack, asyncCallBackComplete, time){
    async.eachSeries(result, function(item, callback){
        setTimeout(function(){
            asyncCallBack(item, callback);
            callback(null);
        }, (time||120));
    }, function(err){
        asyncCallBackComplete(err);
    });
}

;function isMSIE(){
    var ret, isTheBrowser, actualVersion, jscriptMap, jscriptVersion;
     
    isTheBrowser = false;
    jscriptMap = {
        "5.5": "5.5", "5.6": "6",
        "5.7": "7", "5.8": "8",
        "9": "9", "10": "10", "11": "11"
    };
    jscriptVersion = new Function("/*@cc_on return @_jscript_version; @*/")();
 
    if (jscriptVersion !== undefined) {
        isTheBrowser = true;
        actualVersion = jscriptMap[jscriptVersion];
    }
 
    ret = {
        isTheBrowser: isTheBrowser,
        actualVersion: actualVersion
    };
 
    return ret;
}

function bytesToSize(bytes) {
	if(bytes == 0) return '0 Byte';
	var k=1000, sizes=['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'],
		i=Math.floor(Math.log(bytes) / Math.log(k));
	return (bytes / Math.pow(k, i)).toPrecision(3) + ' ' + sizes[i];
}

/*
 * encodeURI replaces each instance of certain characters by one, two, three, or four escape sequences
 * representing the UTF-8 encoding of the character.
 * Each one in the escape sequences is represented in the format of ��%NN��, where ��N�� is one Hex number.
 *
 * @return the UTF-8 byte length of a string.
*/
function utf8ByteLength(str) {
    if (!str) return 0;
    var escapedStr = encodeURI(str), match = escapedStr.match(/%/g);
    return match ? (escapedStr.length - match.length *2) : escapedStr.length;
}
/*
 * The method charCodeAt returns the numeric Unicode value of the character at the given index.
 *
 * @return the unicode byte length of a string.
 */
function unicodeByteLength(str) {
    if (!str) return 0;
    var ch;
    var count = 0;
    for ( var i = 0; i < str.length; i++) {
        ch = str.charCodeAt(i);
        do {
            count++;
            ch = ch >> 8; // shift value down by 1 byte
        } while (ch);
    }
    return count;
}
/*
 * The DBSC encodes , like BIG5,GBK , use two bytes to represent a none-ASCII character, which is represented by multiple bytes in Unicode.
 *
 * @return the double-byte character set (DBCS) byte length of a string.
 */
function dbcsByteLength(str) {
    if (!str) return 0;
    var count = 0;
    for ( var i = 0; i < str.length; i++) {
        count++;
        if(str.charCodeAt(i) >> 8) count++;
    }
    return count;
}