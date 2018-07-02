var GCSV={'csvResult' : {'data': [], 'errors': [], 'meta': {}} }, MAPPING={}, SAVE_ERRORS=[], _queueTask = async.queue(queueTask, 1);

;function queueTask(task, callback) {
    task.run(callback);
}

;function initDocument() {
    
    register_event();
    document.getElementById('loading-curtain-div').style.display = 'none';
}


;function register_event(){
    var iframe = document.getElementById('theIframe');
    if (iframe.attachEvent){iframe.attachEvent("onload", iframeOnload_event);} 
    else {iframe.onload = iframeOnload_event;}
    
    $('#upsertBtn').on('click', upsertRecord_event);
    $('#downBtn').on('click', downCSV_event);
}

;function downCSV_event(e){
	exportCSVpost(this.getAttribute('data-url'), $('#jsoncsvhead').val());
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
	
    GCSV = {'csvResult' : {'data': [], 'errors': [], 'meta': {}}, 'mapping': {} };
    
    $('#errorboxtable').hide().find('#errorbodyid').empty();
	$('#totalsuccess').text(0);	
	$('#totalerror').text(0);	
    	
    if(typeof _pageError != "undefined" && _pageError != null){	//sfdc error must reload the ifream page
		$('#msgtextid').html(_pageError);
		$('#errmsgboxid').show();
		_ifream.location.reload();
		_coverBox.style.display = 'none';
		return;
	}

	if($ifream.find('[id*=isError]').val() == 'true'){
		$('#msgtextid').html($ifream.find('#errormessagedivId ul li').text());
		$('#errmsgboxid').show();
		_ifream.location.reload();
		_coverBox.style.display = 'none';
		return;
	}
	$('#errmsgboxid').hide();
	
	var $str=$ifream.find('#jsonbody'), config={ worker: true, complete: csv_completeParse };
	
	Papa.parse($str.val(), config);	
	$str.val('');

}

;function csv_completeParse(results){
	var _coverBox=document.getElementById('loading-curtain-div'), $error_head=$('#errortheadid'),
		map_mapping=$.parseJSON($('#jsonmapping').val()), list_head=[], isMatchHead=true;

	if(results == undefined){
		$('#totalrecords').text(0);
		_coverBox.style.display = 'none';
		return;
	}
	
	list_head=results['data'].shift();
	
	for(var key in map_mapping){
		var s=list_head.join(',');
		if(s.indexOf(key) == -1){
			isMatchHead=false;
			break;
		}
	}
	
	$error_head.append('<th class="errorcls">Error message</th>');
	for(var i=0, max=list_head.length; i<max; i++){
		var t=$.trim(list_head[i].replace(/\"/g, ''));
		GCSV['mapping'][i] = map_mapping[t];
		$error_head.append('<th class="brsolid" data-field="'+map_mapping[t]+'">'+t+'</th>');
	}
	
	if(!isMatchHead){
		art.dialog({
	        title:' ', lock:true, dblclick_hide:false, esc:false, id: 'countsid',
	        content: 'Download CSV file with the current CSV file does not match.',
	        button : [ {value: 'Ok', focus: true, callback: function(){  }} ]
	    });
		_coverBox.style.display = 'none';
		return;
	}
	
	GCSV['csvResult']['errors'] = results['errors'];
	
	async.filter(results['data'], function(item, callback) {
	    setTimeout(function() {
	    	callback( ($.trim(item.join('')).length == 0 ? false : true) );
	    }, 50);
	}, function(asyncResults) {
	    GCSV['csvResult']['data'] = asyncResults;
		$('#totalrecords').text(GCSV['csvResult']['data'].length);
		_coverBox.style.display = 'none';
	});
}

;function upsertRecord_event(e){
	SAVE_ERRORS=[];
	if(GCSV['csvResult']['data'].length == 0){
		art.dialog({
	        title:' ', lock:true, dblclick_hide:false, esc:false, id: 'countsid',
	        content: 'Not found save data.',
	        button : [ {value: 'Ok', focus: true, callback: function(){  }} ]
	    });
		return;
	}
	document.getElementById('loading-curtain-div').style.display = '';
	deleteObject();
}

;function createUpsertObject(){
	$('div.progress_cls').show();
	
	var $pBar=$("#progressbar").progressbar({ value: false }), batchNumber=parseInt($("#batchNumber").val()), 
		_color=getAnimateColor(GCSV['csvResult']['data'].length, batchNumber), index=0, list_o=[];
		
	$pBar.attr('data-value', 0).progressbar({ max: _color['max'], change: pBarChange, complete: pBarComplete })
		 .find('.ui-progressbar-value').css({ "background": _color['bgcolor'] });

	async.eachSeries(GCSV['csvResult']['data'], function(item, callback) {
	    setTimeout(function() {
	    	var o = {'index': index++};
			for(var i=0, max=item.length; i<max; i++){
				o[GCSV['mapping'][i]] = $.trim(item[i].replace(/\"/g, ''));
			}
			list_o.push(o);
        	callback(null);
	    }, 5);
	}, function(err) {
		var list_save = [];
	    for(var i=0,len=list_o.length; i<len; i+=batchNumber){
	    	list_save.push( list_o.slice(i, i+batchNumber) );
		}
		
		async.eachSeries(list_save, function(item, callback) {
	    	setTimeout(function() {
	    		var ojson={'json': JSON.stringify(item), 'data': item, '$pBar': $pBar, 'percent': _color['percent'], 'max': _color['max']};
				console.log(ojson);
				customRemoteAction(ojson, upsertListObject_js, complete_upsertListObject_js);
	    		callback(null);
	    	}, 160);
		}, function(err) { list_save=[]; });
		
	    GCSV['csvResult']['data'] = [];
	});
	
	;function getAnimateColor(len, bn){
		var percent=(1 / (len/bn) * 100), max=Math.floor(percent * (len/bn)), 
		bg_color=Math.floor( Math.random()*16777215 ).toString(16), list_rgba=$.Color('#'+bg_color)._rgba, 
		rgba=( 'rgba('+list_rgba[0]+','+list_rgba[1]+','+list_rgba[2]+',0.3)' );
		return {'percent': percent, 'max': max, 'bgcolor': ('#'+bg_color), 'rgba': rgba};
	}
	
}

;function complete_upsertObject_js(result, event, data){
	_queueTask.push({name: (data['$pBar'].progressbar("value") || 0), run: function(cb){
		var isError = false;
		if(event.status){
			isError=false;
	    }else{
	    	isError=true;
	    	data['msg'] = event;
	    	var $errorTab=$('#errorboxtable'), $errorBody=$('#errorbodyid'), config={'reglt': /</g, 'reggt': />/g, 'htmllt': '&lt;', 'htmlgt': '&gt;'},
	    		el_tmp = '<td><b style="color:red;">'+event['message']+'</b></td>';
			$('#errortheadid th:not(.errorcls)').each(function(){
				var fieldName=this.getAttribute('data-field');
				el_tmp +=('<td>'+(data['data'][fieldName]).replace(config['reglt'], config['htmllt']).replace(config['reggt'], config['htmlgt'])+'</td>');
			});
			$errorBody.append(('<tr id="index'+data["data"]["index"]+'" indexData="'+data["data"]["index"]+'">'+el_tmp+'</tr>'));
			if($errorTab.css('display') == 'none'){
				$errorTab.show();
			}
	    }
		
	    var percent=parseFloat(data['$pBar'].attr('data-value')), max=data['max'];
	    
	    percent = ($.isNumeric(percent) ? percent : 0), 
	    percent = (data['percent']+percent);

	    max = (Math.round(percent) >= data['max'] ? 100 : percent);
		data['$pBar'].attr('data-value', percent).progressbar("value", max)
					 .find('div.progress-label').html(max.toFixed(2)+'%');

		progressStatusText((isError ? '#totalerror' : '#totalsuccess'));
        cb(null);
    }}, function(err){ });
	
    ;function progressStatusText(_id){
    	$(_id).html(function(){
			var t = parseInt($.trim(this.innerHTML), 10);
			return ($.isNumeric(t) ? (t+1) : 0);
		});
    }
}

;function complete_upsertListObject_js(result, event, data){
	_queueTask.push({name: (data['$pBar'].progressbar("value") || 0), run: function(cb){
		var $errorBody=$('#errorbodyid'), $ths=$('#errortheadid th:not(.errorcls)'),
    		percent=parseFloat(data['$pBar'].attr('data-value')), max=data['max'];

	    result = $.parseJSON(result);
	console.log(data);
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
			console.log(data['data'].length);
	    	progressStatusText('#totalerror', data['data'].length);
	    }
	    
	    percent = ($.isNumeric(percent) ? percent : 0), 
	    percent = (data['percent']+percent);
	    max = (Math.round(percent) >= data['max'] ? 100 : percent);
		
		data['$pBar'].attr('data-value', percent).progressbar("value", max).find('div.progress-label').html(max.toFixed(2)+'%');

        cb(null);
    }}, function(err){ });
	
    ;function progressStatusText(_id, len){
    	$(_id).html(function(){
			var t = parseInt($.trim(this.innerHTML), 10);
			return ($.isNumeric(t) ? (t+len) : 0);
		});
    }
}

;function closeProgressBox(target){
	
	var $cont=$('#errorbodyid'), $list = $cont.children('tr');
	
	$list.sorted({ reversed: false, by: function(elem){ return parseFloat(elem.attr("indexdata")) } }).prependTo($cont);
	$('#errorboxtable').show();
	$('#progressbarbtn_div').hide();
	$('#saveProgressCoverBox').fadeOut(function(){
		$(this).find('#progressbar').progressbar('destroy').find('div.progress-label').html('Loading...');
	});
	$('#saveProgressCover').fadeOut();
}

;function pBarChange(event, ui){
}

;function pBarComplete(event, ui){
	$('#progressbarbtn_div').show();
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
