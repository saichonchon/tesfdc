var TIMEOUT, scrollbarW=$.getScrollbarWidth(), STATIC_VAR={}, SAVE_ERRORS=[], QUEUE = async.queue(queueRun, 1),
	LAZY = {
		'fire' : function(obj, callback, timeout) {
		    timeout = timeout || 200;
		    setTimeout(function() { callback(null, obj); }, timeout);
		}
	}, 
	DECIMAL_POINT = {'n': 'n', 'n0': 'n0', 'n1': 'n1', 'n4': 'n4'},
	WORK_CLS = {
		'level1' : 'CSD_ClsRSMService.SearchLevel1', 'level2' : 'CSD_ClsRSMService.SearchLevel2', 
		'level3' : 'CSD_ClsRSMService.SearchLevel3', 'level4' : 'CSD_ClsRSMService.SearchLevel4',
		'level0' : 'CSD_ClsRSMService.SearchTotal'
	};

;function queueRun(task, callback) {
    task.run(callback);
}

;function initCtrlDocument(){
	
	Globalize.culture(this.locale).numberFormat.currency.symbol = "";
	$('#floatscroll').css({'height': scrollbarW, 'line-height': scrollbarW});
	var t=description(GLOBAL['DJSON'][1], true);

	t += description(GLOBAL['DJSON'][2], true);
	t += description(GLOBAL['DJSON'][3], true);
	t += description(GLOBAL['DJSON'][4], true);
	t += description(GLOBAL['DJSON'][5], true);
	$('#left_head table.table_fix.tabbotm').before( ('<div style="height: 20px;text-align: left;padding-left: 3px;">'+t+'</div>') );
	finallyFormat();
	
	;function description(o, isSpace){
		var space=(isSpace ? ' ': ''), t=(o['attentionString']+space);
		if(o['isRed']){
			t =('<b style="color: red;">'+o['attentionString']+'</b>'+space);
		}
		return t;
	}
	fixTableLayout();
	register_event();
	finallyFormat(appendChannelRow);
}

;function appendChannelRow(o_nonTotal){
	var monthCell={}, map_channel=$.parseJSON($('#hidd_channel').val()), cellIndex=$('#tab_head_list td.currentcls')[0].cellIndex-1,
		$lBody=$('#ltabid'), $rBody=$('#rtabid'), 
		$lTemp=$('#level2_left tr:first').clone().removeAttr('class').removeAttr('data-level').on('mouseenter mouseleave', event_table_over), 
		$rTemp=$('#level2_right tr:first').clone().on('mouseenter mouseleave', event_table_over);
	
	$('#tab_head_list td').each(function(){
		monthCell[this.getAttribute('data-month')] = this.cellIndex;
	});	
	
	//$lBody.find('tr').addClass(map_channel['nontotalchannel']['id']+'_level0 dn').filter('.mark')
	//		.attr({'data-v0': map_channel['nontotalchannel']['id']}).find('div:first').css({'margin-left': '36px'});
	//$rBody.find('tr').addClass('dn');
	
	$lTemp.addClass('external mark cp').on('click', event_existData_click).find('span.spin').remove();
	$lTemp.find('td:last').empty().parent().find('div.mgleft2').addClass('mgleft1').removeClass('mgleft2');
	//$rTemp.find('td').addClass('dn');
	
	appendTotalRow(map_channel['total'], $lBody, $rBody, $lTemp, $rTemp);
	//appendTotalRow(map_channel['nontotalchannel'], $lBody, $rBody, $lTemp, $rTemp);
	//appendTotalRow(map_channel['totalchannel'], $lBody, $rBody, $lTemp, $rTemp);
	createTotalRefDate($lBody, $rBody);
	
	var o_total={}, $lcRow=$lBody.find('tr.totalchannel'), $rcRow=$rBody.find('tr.totalchannel'), 
		$rNonChannelCells=$rBody.find('tr.nontotalchannel td'), $rTotalCells=$rBody.find('tr:first td');
	
	asyncEachSeries_Original(map_channel['channel'], function(item, call){
		var $lClone=$lTemp.clone(true), $rClone=$rTemp.clone(true), 
			attr={'data-v0': map_channel['totalchannel']['id'], 'id': item['id'], 'data-level': 'level1_1', 'data-type': item['type']},
			acls=('dn channel level1 '+item['id']+'_level1 '+map_channel['totalchannel']['id']+'_level0');

		$lClone.attr(attr).addClass(acls).find('div:first').css({'margin-left': '36px'}).parent().find('span.namecell').html(item['name']);
		$rClone.addClass('dn v1 rlevel1 channel ');
		for(var fc in item['csFC']){
			$rClone.find('td:eq('+monthCell[fc]+')').html( Globalize.format(item['csFC'][fc], DECIMAL_POINT['n0']) );
			o_total[monthCell[fc]] = (getZeroOfNumber(o_total[monthCell[fc]]) + item['csFC'][fc]);
		}
		$lcRow.after($lClone);
		$rcRow.after($rClone);
	}, function(err){
		map_channel = {};
		$('#menuBtntd input[data-type="historical"]').click();
		document.getElementById('loading-curtain-div').style.display = 'none';
		for(var o in o_nonTotal){
			map_channel[o] = o_nonTotal[o];
			$rNonChannelCells.eq(o).html( Globalize.format(o_nonTotal[o], DECIMAL_POINT['n0']) );	
		}
		for(var o in o_total){
			if(map_channel.hasOwnProperty(o)){
				map_channel[o] += o_total[o];
			}else{
				map_channel[o] = o_total[o];
			}
			$rcRow.find('td:eq('+o+')').html( Globalize.format(o_total[o], DECIMAL_POINT['n0']) );
		}

		for(var o in map_channel){
			if(o > cellIndex){
				$rTotalCells.eq(o).html( Globalize.format(map_channel[o], DECIMAL_POINT['n0']) );
			}
		}
	}, 210);
	$('#hidd_channel').val('');
	
	
	;function appendTotalRow(item, $lBody, $rBody, $lTemp, $rTemp){
		var $lClone=$lTemp.clone(true), $rClone=$rTemp.clone(true), 
			s='<img src="/s.gif" class="helpIcon" title="Billing total for histrical months, forecast total for current/future months."/> ';
		$lClone.attr({'data-type': item['type'], 'data-level': 'level0', 'id': item['id'], 'data-v0': item['id']});
		switch(item['type']){
			case 'total':
				$lClone.removeClass('mark cp').off('click').addClass('total level1').find('div:last').css({'margin-left': '40px', 'font-weight': 'bold'})
						.find('span.namecell').html( s+item['name'] ).parent().parent().find('div:first').remove();
				$lBody.find('tr:first').before($lClone);
				$rBody.find('tr:first').before($rClone.addClass('v1 rlevel1 newline totalcls'));
				break;
			case 'nontotalchannel':
				$lClone.addClass('level0 done nontotalchannel '+item['id']+'_level0').find('span.namecell').html(item['name']);
				$lBody.find('tr:first').after($lClone);
				$rBody.find('tr:first').after($rClone.addClass('nontotalchannel v0 rlevel0 newline'));
				break;
			case 'totalchannel':
				$lClone.addClass('level0 done channel totalchannel '+item['id']+'_level0').find('span.namecell').html(item['name']);
				$lBody.find('tr:last').after($lClone);
				$rBody.find('tr:last').after($rClone.addClass('v0 rlevel0 channel totalchannel newline'));
				break;
		}
	}
	;function createTotalRefDate($lBody, $rBody){
		var list_result=[], list_months=[], el_body='', 
			datas={'$lBody': $lBody, '$rBody': $rBody, 'monthCell': {}, 'cellMonth': {}, 'viewMode': $('[id*=viewmodeid]').val(),
				'cls': WORK_CLS['level0'], '$row': $lBody.find('tr:first td:first'), '$rCells': $rBody.find('tr:first td'), 
				'action': getTotalBillingData_js, 'complete': complete_refTotalBillingData
			};
		
		$('#tab_head_list td:not(.futurecls):not(.currentcls)').each(function(){
			var cell=this.cellIndex, month=this.getAttribute('data-month');
			datas['monthCell'][month] = cell;
			datas['cellMonth'][cell] = month;
			list_result.push(month);
		});

		for(var i=0, max=list_result.length; i<max; i++){
			var list_t=list_result.slice(i,i+1);
			list_months.push(list_result[i]);
			el_body += '<b data-months="'+list_result[i]+'" data-status="false" class="ref_box">[M-'+i+']</b>';
		}

		datas['$row'].append(el_body);
		asyncEachSeries_Original(list_months, function(month, callback){
			var attr_tmp=$.extend({}, datas);
			attr_tmp['smonths'] = month;
			attr_tmp['json'] = {'set_fiscalMonth': [month], 'viewMode': attr_tmp['viewMode']};
			attr_tmp['json'] = JSON.stringify(attr_tmp['json']);
			customMultipleRemoteAction(attr_tmp, attr_tmp['action'], attr_tmp['complete']); //this is remote action
		}, function(err){}, 120);
	}
	
}

;function finallyFormat(callBack){
	try{
		var o_nonTotal={}, cellIndex=$('#tab_head_list td.currentcls')[0].cellIndex-1, $el_level=$('#rtabid tr.v1');
		
		asyncEachSeries_Original($el_level.toArray(), function(item, call){
			var $item=$(item);
			$item.find('td').html(function(){
				var t = getZeroOfNumber(this.getAttribute('data-old'));
				o_nonTotal[this.cellIndex] = (getZeroOfNumber(o_nonTotal[this.cellIndex]) + t);
				return Globalize.format(t, DECIMAL_POINT['n0']);
			});
			$item.next().find('td:gt('+cellIndex+')').html(function(){
				var t = getZeroOfNumber($item.attr('data-pmfc'));
				return Globalize.format(t, DECIMAL_POINT['n0']);
			});
			$item.next().next().find('td:gt('+cellIndex+')').html(function(){
				var t = getZeroOfNumber($item.attr('data-dcfc'));
				return Globalize.format(t, DECIMAL_POINT['n0']);
			});
		}, function(err){
			callBack(o_nonTotal);
		}, 30);
		
	}catch(e){ document.getElementById('loading-curtain-div').style.display = 'none'; }
	
	
}

;function register_event(){
	var $body_div = $('#div_body');

	$body_div.find('#ltabid span.pin').off('click').on('click', event_refData_click);
	$body_div.find('#rCellScroll').off('scroll').scroll(event_rCellScroll);
	$body_div.find('#ltabid tr.cp').off('click').on('click', event_existData_click);
	$body_div.find('tbody.overbody tr').off('mouseenter mouseleave').on('mouseenter mouseleave', event_table_over);
	$('#menuBtntd input').off('click').on('click', event_hideCalendar_click);
	$('#rsmswitch').off('click').on('click', event_switch_click);
	$(document).on('mousedown', {'elDrop': document.getElementById('dropBoxId'), '$aBox': $('#forecastdiv_id')}, event_dorpBox_down);
	
	$(window).off('scroll').scroll(event_windowScroll).smartresize(event_windowReSize);
	$('#floatscroll').scroll(event_floatScroll);
}


;function refreshDataComplete(){
	fixTableLayout($('#tabContainer').width());
	register_event();
	//$('#menuBtntd input').click();
	finallyFormat(appendChannelRow);

	$('#rsmswitch').toggleClass('on').toggleClass('off').find('div').html(function(){
		var o=this.innerHTML, n=this.getAttribute('data-val');
		this.setAttribute('data-val', o);
		return n;
	});
}


;function checkingStatus(){
	if($('#ltabid span.wating').length == 0){	//checked access remote function.
		return false;
	}
	return true;
}

;function setTemplateElement(data){
/* data['listMonth'] declared  by Padmaja  */
	var monthCell={}, cellMonth={}, list_month=[], $head=$('#tab_head_list td'), 
		list_hidden_td=$head.filter('.dn').toArray(), ftCell=$head.filter('.currentcls')[0].cellIndex;
	
		//.filter(':gt('+(ftCell-1)+')')
	$head.each(function(){
	var month=this.getAttribute('data-month');
		cellMonth[this.cellIndex] = month;
		monthCell[this.getAttribute('data-month')] = this.cellIndex;
		if(!$(this).hasClass('historicalcls') && list_month.length < 3){
			list_month.push(month);
		}
	});
	data['cellMonth'] = cellMonth;
	data['monthCell'] = monthCell;
	data['listMonth'] = list_month;
	data['ftCell']=ftCell;

	switch(data['data-level']){
		case 'level2' :
			data['$left'] = $( ('#ltabid tr.level1.'+data['data-v1']+'_level1') ).last();
			data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');
			data['$left_template'] = $('#level2_left tr').clone();
			data['$right_template'] = $('#level2_right tr').clone();
			data['$right_template'].first().find('td:gt('+ftCell+')').addClass('td_input');
			break;
		case 'level3' :
			data['$left'] = $( ('#ltabid tr.level3.'+data['data-v4']+'_level4.'+data['data-v3']+'_level3.'+data['data-v2']+'_level2.'+data['data-v1']+'_level1') ).last();
			data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');
			data['$left_template'] = $('#level3_left tr').clone();
			data['$right_template'] = $('#level3_right tr').clone();
			data['$right_template'].first().find('td:gt('+ftCell+')').addClass('td_input');
			break;
		case 'level3_3' :
			data['$left'] = data['$row'];//$( ('#ltabid tr.level3_3.'+data['data-v2']+'_level2.'+data['data-v1']+'_level1.nonchannel') );
			data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');
		//	data['$nonleft'] = $( ('#ltabid tr.level3_3.'+data['data-v2']+'_level2.'+data['data-v1']+'_level1.channel') );
		//	data['$nonright'] = $('#rtabid tr:eq('+data['$nonleft'].index()+')');
			data['$left_template'] = $('#level3_left tr').clone();
			data['$right_template'] = $('#level3_right tr').clone();
			data['$right_template'].first().find('td:gt('+ftCell+')').addClass('td_input');
			break;
		case 'level4' :
			var $level3 = $( ('#ltabid tr.level3.'+data['data-v4']+'_level4.'+data['data-v3']+'_level3.'+data['data-v2']+'_level2.'+data['data-v1']+'_level1') );
			data['$left'] = $level3.last();
			data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');
			data['$left_template'] = $('#level4_left tr').clone();
			data['$right_template'] = $('#level4_right tr').clone();
			data['$right_template'].first().find('td:gt('+ftCell+')').addClass('td_input');
			data['$left_template'].find('span.pin').on('click', event_refData_click);
			break;
		case 'level1_1' :
			data['$left'] = data['$row'];
			data['$right'] = $('#rtabid tr:eq('+data['$row'].index()+')');
			data['$left_template'] = $('#level2_left tr:first').clone().removeAttr('class').removeAttr('data-level').addClass('level2 external mark');
			data['$right_template'] = $('#level2_right tr:first').clone();
			data['$left_template'].find('td:last').empty().parent().find('span.fcell').html('○').parent().parent().find('span.spin').remove();
			break;
	}
	data['$right_template'].each(function(){
		var $tds = $(this).find('td');
		for(var i=0, el; el=list_hidden_td[i]; i++){
			$tds.eq(el.cellIndex).addClass('dn');
		}
	});
	data['$left_template'].on('mouseenter mouseleave', event_table_over).filter('.cp')
						  .on('click', event_existData_click).find('span.pin').on('click', event_refData_click);
	data['$right_template'].on('mouseenter mouseleave', event_table_over);
	event_windowScroll();
}

;function appendElement_Level2(data, callBack, callBackEnd){

	var $lTemp=$('#level2_left tr:first').clone().removeAttr('class').attr({'data-level': 'level3_3'}).on('mouseenter mouseleave', event_table_over), 
		$rTemp=$('#level2_right tr:first').clone().on('mouseenter mouseleave', event_table_over);
	
	data['$right'].find('td.dn').each(function(){
		$rTemp.find('td:eq('+this.cellIndex+')').addClass('dn');
	});

	$lTemp.addClass('external nonchannel mark level3_3 cp dn').on('click', event_existData_click).find('span.spin').remove();
	$lTemp.find('td:last').empty().parent().find('div.mgleft2').css({'margin-left': '66px'});//.addClass('mgleft1').removeClass('mgleft2');
	$lTemp.find('span.namecell').html('Non - Channel');
	$rTemp.addClass('rlevel3_3 dn');
	var $lnonTemp=$lTemp.clone(true), $rnonTemp=$rTemp.clone(true);
	$lnonTemp.attr({'data-type': 'channel'}).removeClass('nonchannel').addClass('channel').find('span.namecell').html('Channel');
	data['list_result'].reverse();
	asyncEachSeries_Original(data['list_result'], function(item, call){

		var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true),
			$lTClone=$lTemp.clone(true), $lTnonClone=$lnonTemp.clone(true),
			attr={'id': uuid.v4(), 'data-v1': data['data-v1'], 'data-v2': item['id'], 'data-region': data['region']};
		
		$lClone.addClass( (data['data-v1']+'_level1 '+item['id']+'_level2 ') ).eq(0)
				.attr({'id': item['id'], 'data-v1': data['data-v1'], 'data-region': data['region']})
				.find('span.namecell').html(item['name']);

		$rClone.addClass('rlevel2').eq(0).find('td').each(function(){
			var $this=$(this), attr = { 'data-old': 0 };
			if(item['csFC'] && item['csFC'].hasOwnProperty( data['cellMonth'][this.cellIndex] )){
				attr['data-old'] = (item['csFC'][data['cellMonth'][this.cellIndex]]);
			}
			$this.attr(attr).html( Globalize.format(attr['data-old'], DECIMAL_POINT['n0']) );
		});
		
		$lTClone.attr(attr).addClass( (data['data-v1']+'_level1 '+item['id']+'_level2 '+attr['id']+'_level3') );
		attr['id'] = uuid.v4();
		$lTnonClone.attr(attr).addClass( (data['data-v1']+'_level1 '+item['id']+'_level2 '+attr['id']+'_level3') );
		
		setFieldValue($rClone.eq(1).find('td:gt('+(data['ftCell']-1)+')'), data, item['pmFC']);
		setFieldValue($rClone.eq(2).find('td:gt('+(data['ftCell']-1)+')'), data, item['dcFC']);

		data['$left'].after($lClone);
		data['$right'].after($rClone);
		
		$lClone.last().after($lTnonClone.clone(true));
		$rClone.last().after($rTemp.clone(true));
		
		$lClone.last().after($lTClone.clone(true));
		$rClone.last().after($rnonTemp.clone(true));
	}, function(err){
		callBackEnd(callBack, data);
	}, 150);
	
	
	;function setFieldValue($rCell, data, fc){
		$rCell.each(function(){
			var attr = { 'data-old': 0 };
			if(fc && fc.hasOwnProperty( data['cellMonth'][this.cellIndex] )){
				attr['data-old'] = (fc[(data['cellMonth'][this.cellIndex])]);	
			}
			$(this).attr(attr).html( Globalize.format(attr['data-old'], DECIMAL_POINT['n0']) );
		});
	}
	
}

;function appendElement_Level3(data, callBack, callBackEnd){
	
	var o_total={};
	
	data['list_result'].reverse();
	
	asyncEachSeries_Original(data['list_result'], function(item, call){
		var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true);
		$lClone.addClass( (data['data-v3']+'_level3 '+data['data-v2']+'_level2 '+item['id']+'_level4 '+data['data-v1']+'_level1 ') )
				.eq(0).attr({'id': item['id'], 'data-v1': data['data-v1'], 'data-v2': data['data-v2'], 'data-v3': data['data-v3'],
							 'title': item['name'], 'data-number': item['accnumber'], 'data-region': data['region']});
			
		$rClone.addClass('rlevel3').eq(0).find('td').each(function(){
			var $this=$(this), attr = { 'data-old': 0 };
			if(item['csFC'] && item['csFC'].hasOwnProperty( data['cellMonth'][this.cellIndex] )){
				attr['data-old'] = (item['csFC'][data['cellMonth'][this.cellIndex]]);	
			}
			o_total[this.cellIndex] = (getZeroOfNumber(o_total[this.cellIndex]) + attr['data-old']);
			$this.attr(attr).html( Globalize.format(attr['data-old'], DECIMAL_POINT['n0']) );
		});

		setFieldValue($rClone.eq(1).find('td:gt('+(data['ftCell']-1)+')'), data, item['pmFC']);
		setFieldValue($rClone.eq(2).find('td:gt('+(data['ftCell']-1)+')'), data, item['dcFC']);
		if(item['type'] == 'channel'){
			$lClone.eq(0).off('click').removeClass('cp').find('span.fcell').html('○').parent().find('span.pin').remove();
			$lClone.addClass('dn').find('span.namecell').html(item['name']);
			$rClone.addClass('dn');
		}else{
			$lClone.find('span.namecell').html(item['name']+' ['+item['accnumber']+']');
		}
		data['$left'].after($lClone);
		data['$right'].after($rClone);
		
	}, function(err){

		if(data['$row'].attr('data-type') == 'channel'){
			data['$row'].off('click').find('span.cellbox.fcell').html('○');
		}
		for(var o in o_total){
			data['$right'].find('td:eq('+o+')').html( Globalize.format(o_total[o], DECIMAL_POINT['n0']) );
		}
		
		//_data['$row'].removeClass('ready').addClass('done').find('td:first span.fcell').html('-').removeClass('wating');
	//	data['$left'].addClass('done').find('span.cellbox.fcell').removeClass('wating').html('-');
	//	data['$nonleft'].addClass('done').find('span.cellbox.fcell').removeClass('wating').html('-');
		callBackEnd(callBack, data);
	}, 150);
	
	;function setFieldValue($rCell, data, fc){
		$rCell.each(function(){
			var attr = { 'data-old': 0 };
			if(fc && fc.hasOwnProperty( data['cellMonth'][this.cellIndex] )){
				attr['data-old'] = (fc[data['cellMonth'][this.cellIndex]]);	
			}
			$(this).attr(attr).html( Globalize.format(attr['data-old'], DECIMAL_POINT['n0']) );
		});
	}
}
var lastElementleft;	
var lastElementright;	
var islastelement = 'true';


;function appendElement_Level4(data, callBack, callBackEnd){
console.log(' - 2 - '+JSON.stringify(data['list_result']));
console.log(' - 2 - '+JSON.stringify(data['listMonth'][0]));
async.sortBy(data['list_result'], function(item, callback) {
	    setTimeout(function() {
	    	var sum=0;
	    	//console.log(' - 2 - '+JSON.stringify(data['listMonth']));
	    	for(var i=0, month; month=data['listMonth'][i]; i++){
	    		if(item['csFC'].hasOwnProperty(month)){

	    			// sum += item['csFC'][month];
	    			sum += item['csFC'][month]['forecast'];
	    		}
	    	}
	    	item['sum']=sum;
	        callback(null, item['sum']);
	    }, 10);
	},function(err, list_results) {
	
	/* Padmaja: Added code for show more functionality REQ_00834   */
	 
		data['list_result']=[];		//clear list result
		list_results.reverse();
		var list_topTen=list_results.splice(0,10);
		otherSoldTo={'csFC': {}, 'pmFC': {}, 'dcFC': {}},
		$lCloneother=data['$left_template'].clone(true), $rCloneother=data['$right_template'].clone(true);	
		list_topTen.reverse();
 		$lCloneother.find("span.pin").removeClass(" pin spin");
		$lCloneother.find("td.fieldwidth").css("display","none");
		
		asyncEachSeries_Original(list_topTen, function(item, call){
	
     //Added 'title': item['name'] for REQ_00835 by Padmaja on 06/11/2015
	
		var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true);
		$lClone.addClass( (data['data-v4']+'_level4 '+data['data-v3']+'_level3 '+item['id']+'_level5 '+data['data-v2']+'_level2 '+data['data-v1']+'_level1 ') )
				.eq(0).attr({'id': item['id'], 'title': item['name'], 'data-v1': data['data-v1'], 'data-v2': data['data-v2'], 'data-v4': data['data-v4'],
							 'data-region': data['region'], 'data-number': data['number'], 'data-v3': data['data-v3']})
				.find('span.namecell').html(item['name']);
		if(islastelement == 'true')
		{
			$rClone.addClass('lastElementright' + data['data-v3']);
			$lClone.addClass('lastElementleft' + data['data-v3']);
			islastelement = 'false';
		}
		$rClone.addClass('rlevel4').eq(0).find('td').each(function(){
			var $this=$(this), attr = { 'data-old': 0, 'data-nprice': 0, 'data-nqty': 0 }, csFC=item['csFC'];
			if(csFC && csFC.hasOwnProperty( data['cellMonth'][this.cellIndex] )){
				attr['data-old'] = (csFC[data['cellMonth'][this.cellIndex]]['forecast']);
				attr['data-nprice'] = (csFC[data['cellMonth'][this.cellIndex]]['price']);
				attr['data-nqty'] = (csFC[data['cellMonth'][this.cellIndex]]['quantity']);
			}
			$this.attr(attr).html( Globalize.format(attr['data-old'], DECIMAL_POINT['n0']) );
		});

		setFieldValue($rClone.eq(1).find('td:gt('+(data['ftCell']-1)+')'), data, item['pmFC']);
		setFieldValue($rClone.eq(2).find('td:gt('+(data['ftCell']-1)+')'), data, item['dcFC']);

		data['$left'].after($lClone);
		data['$right'].after($rClone);
		
	}, 
	function(err){
		callBackEnd(callBack, data);
	}, 150);
		//var newlist_topTen=list_topTen;
		
		//alert("newlist_topTen"+list_topTen); 
		if(list_results.length > 0){
		var s = 'showlink'+data['data-v4'];
		
		$rCloneother.addClass('right'+s);	
		$lCloneother.addClass(('othersoldto '+data['data-v4']+'_level4 '+data['data-v3']+'_level3 '+data['data-v2']+'_level2 '+data['data-v1']+'_level1 left' + s ) )
				 				
				.find('span.namecell').append('<a href="#ShowMore">Show More</a>').click(function(e){
			    
				 //list_results.reverse();
				//newlist_topTen.push(list_results);
				var newlist_topTen=list_results.splice(0,10);
				//newlist_topTen.reverse();
			asyncEachSeries_Original( newlist_topTen, function(item, call){
		var $lClone1=data['$left_template'].clone(true), $rClone1=data['$right_template'].clone(true);
		$lClone1.addClass( (data['data-v4']+'_level4 '+data['data-v3']+'_level3 '+item['id']+'_level5 '+data['data-v2']+'_level2 '+data['data-v1']+'_level1 ') )
				.eq(0).attr({'id': item['id'], 'title': item['name'], 'data-v1': data['data-v1'], 'data-v2': data['data-v2'], 'data-v4': data['data-v4'],
							 'data-region': data['region'], 'data-number': data['number'], 'data-v3': data['data-v3']})
				.find('span.namecell').html(item['name']);
				
		$rClone1.addClass('rlevel4').eq(0).find('td').each(function(){
			var $this=$(this), attr = { 'data-old': 0, 'data-nprice': 0, 'data-nqty': 0 }, csFC=item['csFC'];
			if(csFC && csFC.hasOwnProperty( data['cellMonth'][this.cellIndex] )){
				attr['data-old'] = (csFC[data['cellMonth'][this.cellIndex]]['forecast']);
				attr['data-nprice'] = (csFC[data['cellMonth'][this.cellIndex]]['price']);
				attr['data-nqty'] = (csFC[data['cellMonth'][this.cellIndex]]['quantity']);
			}
			$this.attr(attr).html( Globalize.format(attr['data-old'], DECIMAL_POINT['n0']) );
		});

		setFieldValue($rClone1.eq(1).find('td:gt('+(data['ftCell']-1)+')'), data, item['pmFC']);
		setFieldValue($rClone1.eq(2).find('td:gt('+(data['ftCell']-1)+')'), data, item['dcFC']);
        console.log("++++++++++++++"+data['$left']); 
		//$('#level4_left tr:last').after($lClone1);
		//$('#level4_right tr:last').after($rClone1);
		var xxxs = $('.left'+s)
		$('.left'+s).first().before($lClone1);
		/*$('.left'+s).show(function() {
			$(this).before($lClone1);
		});*/
		$('.right'+s).first().before($rClone1);
		/*$('.right'+s).show(function() {
			$(this).before($rClone1);
		});*/
		$lCloneother.filter(':gt(2)').remove();
		$rCloneother.filter(':gt(2)').remove();
		
	}, function(err){
		callBackEnd(callBack, data);
	}, 150);
	 
		if(list_results.length == 0) {
			$('.left'+s).show(function() {
				$(this).remove();
			});
			$('.right'+s).show(function() {
				$(this).remove();
			});
		}            
    	}).find('span.cellbox.fcell').remove();
    
		data['$left'].after($lCloneother);
		data['$right'].after($rCloneother);

		$lCloneother.filter(':gt(2)').remove();
		$rCloneother.filter(':gt(2)').remove();
	
	
	
	}
	
	});
	;function setFieldValue($rCell, data, fc){
		$rCell.each(function(){
			var attr = { 'data-old': 0 };
			if(fc && fc.hasOwnProperty( data['cellMonth'][this.cellIndex] )){
				attr['data-old'] = (fc[data['cellMonth'][this.cellIndex]]);	
			}
			$(this).attr(attr).html( Globalize.format(attr['data-old'], DECIMAL_POINT['n0']) );
		});
	}
	
}



;function appendElement_Level1_1(data, callBack, callBackEnd){

	asyncEachSeries_Original(data['list_result'], function(item, call){
		var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true);
		$lClone.addClass( (item['id']+'_level2 '+data['pid']+'_level1 '+data['data-v0']+'_level0') )
				.eq(0).attr({'id': item['id'], 'data-v0': data['data-v0']}).find('div:first').css({'margin-left': '65px'})
				.parent().find('span.namecell').html(item['name']);

		$rClone.addClass('rlevel2').eq(0).find('td').each(function(){
			var $this=$(this), attr = { 'data-old': 0 };
			if(item['csFC'] && item['csFC'].hasOwnProperty( data['cellMonth'][this.cellIndex] )){
				attr['data-old'] = (item['csFC'][data['cellMonth'][this.cellIndex]]);	
			}
			$this.attr(attr).html( Globalize.format(attr['data-old'], DECIMAL_POINT['n0']) );
		});

		data['$left'].after($lClone);
		data['$right'].after($rClone);
		
	}, function(err){
		callBackEnd(callBack, data);
	}, 150);
}

;function complete_refData(result, event, data){

	QUEUE.push({name: data['level'], run: function(cb){
		var $status_cell=data['$billing'].find('td:first b.ref_box[data-months="'+data['smonths']+'"]').eq(0);
		if(event.status){
			result = $.parseJSON(result);
			var map_percent=$.parseJSON($('#hidd_percent').val()),
				$billing=data['$rbody'].find('tr:eq('+data['$billing'].index()+')'), 
				$booking=data['$rbody'].find('tr:eq('+data['$booking'].index()+')'), 
				billing=result['map_billingrefdata'], booking=result['map_bookingrefdata'];

			matchRefData(billing, data, $billing.find('td'));
			matchRefData(booking, data, $booking.find('td'));
			
			$status_cell.attr('data-status', 'true').animate({backgroundColor: '#51C957'}, 130, function(){
				$status_cell.remove();
				if(data['$billing'].find('b.ref_box').length == 0){
					statisticalPercent(map_percent, data, $billing.find('td'), data['$rbody'].find('tr:eq('+data['$statistical'].index()+') td'));
				}
			});
	    }else{
			reLoadRefData($status_cell, data);
	    }
		cb(null);
    }}, function(err){ });
	
    /*HELP methods*/
    ;function statisticalPercent(map_percent, data, $billingCells, $statisticalCells){
    	var cellMonth=data['cellMonth'], monthCell=data['monthCell'];
    	$statisticalCells.filter(':gt('+(data['crtCell']-1)+')').each(function(){
    		var month=cellMonth[this.cellIndex].split('_')[1];
    		if(map_percent.hasOwnProperty(month)){
    			var $prev_3=$billingCells.filter(':eq('+data['crtCell']+')').prev(),
    				$prev_2=$prev_3.prev(), $prev_1=$prev_2.prev(), total=0;
				total = (getZeroOfNumber($prev_1.attr('data-old'))+getZeroOfNumber($prev_2.attr('data-old'))+getZeroOfNumber($prev_3.attr('data-old')));
    			total = (total*(map_percent[month]/100));
    			$(this).attr('data-old', total).html( Globalize.format(total, DECIMAL_POINT['n0']) );
    		}
    	});
    	
    }
    
    ;function matchRefData(refData, data, $cell){
    	var monthCell = data['monthCell'];

    	for(var r in refData){
    		if(monthCell.hasOwnProperty(r)){
    			$cell.eq(monthCell[r]).attr({'data-old': refData[r]}).html( Globalize.format(refData[r], DECIMAL_POINT['n0']) );
    		}
    	}
    }
    
    ;function reLoadRefData($status_cell, data){
    	$status_cell.css({'cursor': 'pointer'}).attr('data-status', 'false').append('<b class="ref_msg">'+event['message']+'</b>')
					.animate({backgroundColor: '#C95151'}, 230).on('click', function(e){
						e.stopPropagation();
						$(this).off('click');
						$status_cell.animate({backgroundColor: '#517BC9'}, 130).css({'cursor': 'default'}).find('b').remove();
						customMultipleRemoteAction(data, data['action'], data['complete']);
					});
    }
    /*HELP methods*/
}
;function complete_refDataBacklog(result, event, data){
	
	QUEUE.push({name: data['level'], run: function(cb){
		var $status_cell=data['$backlog'].find('td:first b.ref_box[data-months="'+data['smonths']+'"]').eq(0);
		if(event.status){
			result = $.parseJSON(result);
			var $backlog=data['$rbody'].find('tr:eq('+data['$backlog'].index()+')'), backlog=result['map_backlogrefdata'];
			$status_cell.attr('data-status', 'true').animate({backgroundColor: '#51C957'}, 130, function(){
				$status_cell.remove();
			});
			matchRefData(backlog, data, $backlog.find('td'));
	    }else{
			reLoadRefData($status_cell, data);
	    }
		cb(null);
    }}, function(err){ });
	
    
    /*HELP methods*/
    ;function matchRefData(refData, data, $cell){
    	var monthCell = data['monthCell'];

    	for(var r in refData){
    		if(monthCell.hasOwnProperty(r)){
    			$cell.eq(monthCell[r]).html( Globalize.format(refData[r], DECIMAL_POINT['n0']) );
    		}
    	}
    }
    
    ;function reLoadRefData($status_cell, data){
		$status_cell.css({'cursor': 'pointer'}).attr('data-status', 'false').append('<b class="ref_msg">'+event['message']+'</b>')
					.animate({backgroundColor: '#C95151'}, 230).on('click', function(e){
						e.stopPropagation();
						$(this).off('click');
						$status_cell.animate({backgroundColor: '#517BC9'}, 130).css({'cursor': 'default'}).find('b').remove();
						customMultipleRemoteAction(data, data['actionBacklog'], data['completeBacklog']);
					});
    }
    /*HELP methods*/
}
;function complete_refTotalBillingData(result, event, data){
	
	QUEUE.push({name: data['level'], run: function(cb){
		var $status_cell=data['$row'].find('b.ref_box[data-months="'+data['smonths']+'"]').eq(0);
	
		if(event.status){
			result = $.parseJSON(result);
			$status_cell.attr('data-status', 'true').animate({backgroundColor: '#51C957'}, 130, function(){
				$status_cell.remove();
			});
			matchRefData(result['map_billingrefdata'], data, data['$rCells']);
	    }else{
			reLoadRefData($status_cell, data);
	    }
		cb(null);
    }}, function(err){ });
	
    
    /*HELP methods*/
    ;function matchRefData(refData, data, $cell){
    	var monthCell = data['monthCell'];

    	for(var r in refData){
    		if(monthCell.hasOwnProperty(r)){
    			$cell.eq(monthCell[r]).html( Globalize.format(refData[r], DECIMAL_POINT['n0']) );
    		}
    	}
    }
    
    ;function reLoadRefData($status_cell, data){
		$status_cell.css({'cursor': 'pointer'}).attr('data-status', 'false').append('<b class="ref_msg">'+event['message']+'</b>')
					.animate({backgroundColor: '#C95151'}, 230).on('click', function(e){
						e.stopPropagation();
						$(this).off('click');
						$status_cell.animate({backgroundColor: '#517BC9'}, 130).css({'cursor': 'default'}).find('b').remove();
						customMultipleRemoteAction(data, data['action'], data['complete']);
					});
    }
    /*HELP methods*/
}
;function complete_existObject(result, event, data){	//complete remoteaction result
	
	QUEUE.push({name: data['rowIndex'], run: function(cb){
		if(event.status){
			complete_remoteResultCheck(result, data, cb, data['append'], complete_appendElementEND);
	    }else{ 
			complete_errorReload(data, event, event_reloadExistData_click);
	    	cb(null);
	    }
	    data['$row'].find('span.del_img').removeAttr('style');
	}}, function(err){ });
}


;function complete_remoteResultCheck(result, data, queueComplete, appendCallBack, appendCallBackEND){

	data['list_result'] = $.parseJSON(result);

    if(data['list_result'].length == 0){ 
        rowUnLock(data['rowIndex']);
        data['$row'].addClass('done').find('td:first span.fcell').html('-').removeClass('wating');
        queueComplete(null);
        return;
    }
    setTemplateElement(data);
    appendCallBack(data, queueComplete, appendCallBackEND);
}

;function complete_appendElementEND(queueComplete, _data){
	rowUnLock(_data['rowIndex']);
	_data['$row'].removeClass('ready').addClass('done').find('td:first span.fcell').html('-').removeClass('wating');
	queueComplete(null); 
}


;function complete_errorReload(data, event, callBack){

    var el_reload = '<span class="reload_span"><span class="reload_img"></span><b class="reload_msg">'+event['message']+'</b></span>';
    data['$row'].removeClass('exp done').find('td:first span.wating.fcell').before(el_reload)
            .parent().find('span.reload_span').on('click', {$data: data}, function(e){
            	e.stopPropagation();
            	callBack(e, $(this));
            });
    rowUnLock(data['rowIndex']);
}

;function event_dorpBox_down(e){

	var _this=this, $this=$(_this), $target=$(e.target), _id=$target.attr('id'),
		disX = e.clientX - e['data'].elDrop.offsetLeft;;
	
	if(_this.setCapture){
		_this.setCapture();
	}else if(window.captureEvents){
		window.captureEvents(Event.MOUSEMOVE|Event.MOUSEUP);
	}

	if(_id == 'dropBoxId'){
		e['data'].$aBox.addClass('w-drop-unselect');
		$target.css({'cursor': 'col-resize', 'width': '1px', 'height': $('#forecastdiv_id').height(), 'z-index': 10000});
	}
	$this.on('mousemove', function(eve){
		var x=(eve.clientX-disX);
		if((x <= 160 || x >= 1000) && _id == 'dropBoxId'){
			return false;
		}
		
		if(_id == 'dropBoxId'){
			$target.css({'left': eve.clientX-disX});
		}
	});
	$this.on('mouseup', function(event){
		if(_this.releaseCapture){
	        _this.releaseCapture();
		}else if(window.captureEvents){
	        window.captureEvents(Event.MOUSEMOVE|Event.MOUSEUP);
		}
		if(_id == 'dropBoxId' && $target.css('left') != 'auto'){
			e['data'].$aBox.find('div.lCellw').css({'width': $target.css('left')});
			fixTableLayout($('#tabContainer').width(), false);
		}
		e['data'].$aBox.removeClass('w-drop-unselect');
		$this.off('mousemove mouseup');
		$(e['data'].elDrop).removeAttr('style');
    });
}

;function event_switch_click(e){
	var oMap=$.parseJSON($('[id*=regionmapid]').val()), $viewModeHide=$('[id*=viewmodeid]'), value=$viewModeHide.val();
	
	for(var o in oMap){
		if(oMap[o] != value){
			value=oMap[o];
			break;
		}
	}
	$viewModeHide.val(value);
	document.getElementById('loading-curtain-div').style.display = '';
	refreshData();	//this is action function.
//	$(this).toggleClass('on').toggleClass('off');
}

;function event_editPartPopupBox_click(e){
	$('#popupmain').fadeIn('fast');
	
	appendCloneHead();

	var $this=$(this), $tr=$this.parent(), $lBody=$tr.parent(), $rBody=$('#rtabid'), asplabel = '',
		$leftTbody=$('#edit_left_tbody').empty(), $rightTbody=$('#edit_right_tbody').empty();

	$('#savefcbtn').remove();
	$('#editBoxDiv').css({'width': '0%', 'display': ''}).animate({'width': '90%'}, 720, function(){});
	$('#editboxtitle').html($tr.find('span.namecell').html());
	
	var $crtRow=$rBody.find('tr:eq('+$tr.index()+')').clone().removeClass('dn overbodybg'),
		cellIdx=$crtRow.find('td').removeClass('dn').filter('.td_input:first').prev()[0].cellIndex;
	
	$crtRow.find('td').filter(':not(.td_input):not(:last)').remove();	

	appendCloneColumn('Quantity', 'qtycls', $crtRow.clone(), $leftTbody, $rightTbody, qtyText, qtyText);
	appendCloneColumn('Price', 'pricecls', $crtRow.clone(), $leftTbody, $rightTbody, priceText, priceText);

	/* Help function*/
	;function appendCloneHead(){
		var $rHead=$('#edit_thead'), $oldHead=$('#rHeadBody');
		if($rHead.find('tr').length != 0 ){
			return;
		}
		$rHead.append($oldHead.find('tr').clone());
		$rHead.find('tr').removeAttr('id').find('th, td').removeClass('dn').filter('.historicalcls, .th_historicalcls').remove();
		$('#editleftth').css({'height': $oldHead.height()-0.5});
		$('#editBoxScroll').scroll(event_rEditCellScroll);
	}
	
	;function appendCloneColumn(label, cls, $element, $leftTbody, $rightTbody, fn_input, fn_text){
		$element.addClass(cls).find('td.td_input').html(fn_input).filter(':first').prev().html(fn_text);
		$leftTbody.append('<tr><td>'+label+'</td></tr>');
		$rightTbody.append($element);
	}
	;function qtyInput(){
		var qty = getZeroOfNumber(this.getAttribute('data-nqty'));
		return Globalize.format(qty, DECIMAL_POINT['n0']);
	}
	;function qtyText(){
		return (Globalize.format(getZeroOfNumber(this.getAttribute('data-nqty')), DECIMAL_POINT['n0']));
	}
	;function priceInput(){
		var price = getZeroOfNumber(this.getAttribute('data-nprice'));
		return Globalize.format(price, DECIMAL_POINT['n4']);
	}
	;function priceText(){
		return (Globalize.format(getZeroOfNumber(this.getAttribute('data-nprice')), DECIMAL_POINT['n4']));
	}
	/* Help function*/
}

;function event_refData_click(e){
	e.stopPropagation();
	if($(this).hasClass('watingpin')){
		return;
	}
	var $this=$(this), $td=$this.parent().parent().parent(), $tr=$td.parent(), $statistical=$tr.next().next().next(),
		$billing=$statistical.next(), $booking=$billing.next(), $backlog=$booking.next(), execute=($this.hasClass('spin')? exp : col),
		attr={ 'findcls': '', 'json' : {}, 'cls': '', 'monthCell': {}, 'cellMonth': {}, 'viewMode': $('[id*=viewmodeid]').val(),
			'$pin': $this, '$row': $tr, 'level': $tr.attr('data-level'), 'number': $tr.attr('data-number'), 'crtCell': $('#tab_head_list td.currentcls')[0].cellIndex,
			'id': $tr.attr('id'), 'data-v1': $tr.attr('data-v1'), 'data-v2': $tr.attr('data-v2'), 'data-v3': $tr.attr('data-v3'), 'data-v4': $tr.attr('data-v4'),
			'$lbody': $tr.parent(), '$rbody': $('#rtabid'), 'region': $tr.attr('data-region'), '$booking': $booking,
			'$statistical' : $statistical, '$billing': $billing, '$backlog': $backlog, 'actionBacklog': getBacklogRefData_js,
			'action' : getRefData_js, 'complete' : complete_refData, 'completeBacklog': complete_refDataBacklog
			 };
		
	event_windowScroll();
	switch(attr['level']){
		case 'level1':
			attr['region'] = $.trim($tr.find('span.namecell').text());
			attr['cls'] = WORK_CLS['level1'];
			attr['findcls'] = 'tr:not(.mark).level1.'+attr['id']+'_level1';
			break;
		case 'level2':
			attr['oemId'] = attr['id'];
			attr['cls'] = WORK_CLS['level2'];
			attr['findcls'] = 'tr:not(.mark).level2.'+attr['id']+'_level2.'+attr['data-v1']+'_level1';
			break;
		case 'level3':
			attr['oemId'] = attr['data-v2'];
			attr['cls'] = WORK_CLS['level3'];
			attr['findcls'] = 'tr:not(.mark).level3.'+attr['id']+'_level4.'+attr['data-v3']+'_level3.'+attr['data-v2']+'_level2.'+attr['data-v1']+'_level1';
			break;
		case 'level4':
			attr['oemId'] = attr['data-v2'];
			attr['partid'] = attr['id'];
			attr['cls'] = WORK_CLS['level4'];
			attr['findcls'] = 'tr:not(.mark).level4.'+attr['id']+'_level5.'+attr['data-v4']+'_level4.'+attr['data-v3']+'_level3.'+attr['data-v2']+'_level2.'+attr['data-v1']+'_level1';
			break;
	}

	execute();
	
	
	
	/* START Help function */
	;function exp(){
		if(!$this.hasClass('refdata')){
			$this.addClass('refdata');
			createHistoricalStatus(attr['$billing']);
			createFutureStatus(attr['$backlog']);
		}
		$this.removeClass('spin');
		attr['$lbody'].find(attr['findcls']).each(function(){
			attr['$rbody'].find('tr:eq('+this.rowIndex+')').removeClass('dn');
			$(this).removeClass('dn');
		});
	}
	
	
	;function col(){
		$this.addClass('spin');
		attr['$lbody'].find(attr['findcls']).each(function(){
			attr['$rbody'].find('tr:eq('+this.rowIndex+')').addClass('dn');
			$(this).addClass('dn');
		});
	}
	
	;function createHistoricalStatus($element){
		var list_months=[];
		createMonths(list_months, $element, $('#tab_head_list td:not(.futurecls)'));

		asyncEachSeries_Original(list_months, function(list_item, callback){
			var attr_tmp=$.extend({}, attr), list_q=[];
			for(var i=0, result; result=list_item[i]; i++){
				list_q.push(result);
			}
			attr_tmp['smonths'] = list_q.join(',');
			attr_tmp['json'] = {'set_fiscalMonth': list_q, 'oemId': attr_tmp['oemId'], 
								'partId': attr_tmp['partid'], 'viewMode': attr_tmp['viewMode'],
								'accnumber': attr_tmp['number'], 'region': attr_tmp['region']};
			attr_tmp['json'] = JSON.stringify(attr_tmp['json']);
			customMultipleRemoteAction(attr_tmp, attr_tmp['action'], attr_tmp['complete']); //this is remote action
		}, function(err){}, 120);
		
	}
	
	;function createFutureStatus($element){
		var list_months=[];
		createMonths(list_months, $element, $('#tab_head_list td:not(.historicalcls)'));

		asyncEachSeries_Original(list_months, function(list_item, callback){
			var attr_tmp=$.extend({}, attr), list_q=[];
			for(var i=0, result; result=list_item[i]; i++){
				list_q.push(result);
			}
			attr_tmp['smonths'] = list_q.join(',');
			attr_tmp['json'] = {'set_fiscalMonth': list_q, 'oemId': attr_tmp['oemId'], 
								'partId': attr_tmp['partid'], 'viewMode': attr_tmp['viewMode'],
								'accnumber': attr_tmp['number'], 'region': attr_tmp['region']};
			attr_tmp['json'] = JSON.stringify(attr_tmp['json']);
			customMultipleRemoteAction(attr_tmp, attr_tmp['actionBacklog'], attr_tmp['completeBacklog']); //this is remote action
		}, function(err){}, 120);
		
	}
	
	;function createMonths(list_months, $element, $el_head){
		var list_result=[], el_body='<div class="ref_cover">';

		$el_head.each(function(){
			var cell=this.cellIndex, month=this.getAttribute('data-month');
			attr['monthCell'][month] = cell;
			attr['cellMonth'][cell] = month;
			list_result.push(month);
		});
		for(var i=0, max=list_result.length; i<max; i+=3){
			var list_t=list_result.slice(i,i+3);
			list_months.push(list_t);
			el_body += '<b data-months="'+list_t.join(',')+'" data-status="false" class="ref_box">[M-'+Math.round((i+1)/3)+']</b>';
		}
		el_body += '</div>';
		$element.find('td:first').append(el_body);
	}
	/*
	;function executeRemote(){
		var list_months=[];
		createRefStatus(list_months, attr['$billing']);
		list_months=[];	//clear first months.
		createRefStatus(list_months, attr['$backlog']);
		
		asyncEachSeries_Original(list_months, function(list_item, callback){
			var attr_tmp=$.extend({}, attr), list_q=[];
			for(var i=0, result; result=list_item[i]; i++){
				list_q.push(result);
			}
			attr_tmp['smonths'] = list_q.join(',');
			attr_tmp['json'] = {'set_fiscalMonth': list_q, 'oemId': attr_tmp['oemid'], 'soldtoId': attr_tmp['soldtoid'], 
								'partId': attr_tmp['partid'], 'viewMode': attr_tmp['viewMode'],
								'accnumber': attr_tmp['number'], 'region': attr_tmp['region']};
			attr_tmp['json'] = JSON.stringify(attr_tmp['json']);
			customMultipleRemoteAction(attr_tmp, attr_tmp['action'], attr_tmp['complete']); //this is remote action
			customMultipleRemoteAction(attr_tmp, attr_tmp['actionBacklog'], attr_tmp['completeBacklog']); //this is remote action

		}, function(err){}, 190);
		
	}
	
	;function createRefStatus(list_months, $element){
		var list_result=[], el_body='<div class="ref_cover">';

		$('#tab_head_list td').each(function(){
			var cell=this.cellIndex, month=this.getAttribute('data-month');
			attr['monthCell'][month] = cell;
			attr['cellMonth'][cell] = month;
			list_result.push(month);
		});
		for(var i=0, max=list_result.length; i<max; i+=3){
			var list_t=list_result.slice(i,i+3);
			list_months.push(list_t);
			el_body += '<b data-months="'+list_t.join(',')+'" data-status="false" class="ref_box">[M-'+Math.round((i+1)/3)+']</b>';
		}
		el_body += '</div>';
		$element.find('td:first').append(el_body);
	}
	*/
	/* END Help function */
}

;function event_tabStatus_over(e){
	var $this=$(this);
	eventHandle_ov_ot(e, ov, ot);
    ;function ov(e){ $this.addClass('overg'); }
    ;function ot(e){ $this.removeClass('overg').hide(); }
}

;function event_pinRefStatus_over(e){
	var $this=$(this), $refDiv=$this.parent().parent().parent().find('div.refs_d');
	eventHandle_ov_ot(e, ov, ot);
    
    ;function ov(e){ $refDiv.show(); }
    ;function ot(e){ 
    	window.clearTimeout(t);
		var t = window.setTimeout(doHide, 160);
	}
	
	;function doHide(){
		if(!$refDiv.hasClass('overg')){ $refDiv.hide(); }
	}
}


;function event_reloadExistData_click(e, $this){
	var _data = e.data.$data;
	rowIsLocked(_data['rowIndex']);
    customMultipleRemoteAction(_data, _data['action'], _data['complete']);
    $this.remove();
}



;function event_existData_click(e){
//	e.stopPropagation();
	var hide = 'dn', list_element = [], $right_trs=$('#rtabid tr'), _this = this, $this=$(_this),
    	$leftBody=$this.parent(), $waiting = $this.find('td:first span.fcell'), $pin=$this.find('span.pin'),
    	config={'id': $this.attr('id'), 'data-level': $this.attr('data-level'), 'rowIndx': $this.index(), 'isRemote': false},
        fn = ($this.hasClass('exp')? exp : col);

    $this.find('td:first span.reload_span').remove();
  //  if(rowIsLocked(config['rowIndx'])){ return false; }

    fn();
    
    ;function exp(){
    	if(isLoadedSubData()){ return false; }
    	
    	var levelCls = '';
    	
    	switch(config['data-level']){
    		case 'level0' : levelCls = 'tr:not(.level0).'+config['id']+'_level0'; break;
    		case 'level1': levelCls = 'tr:not(.level1).'+config['id']+'_level1'; break;
    		case 'level1_1': levelCls = 'tr:not(.level1).'+config['id']+'_level1'; break;
    		case 'level2' : levelCls = 'tr:not(.level2).'+config['id']+'_level2.'+$this.attr('data-v1')+'_level1'; break;
    		case 'level3' : levelCls = 'tr:not(.level3).'+config['id']+'_level4.'+$this.attr('data-v3')+'_level3.'+$this.attr('data-v2')+'_level2.'+$this.attr('data-v1')+'_level1'; break;
    		case 'level3_3' : levelCls = 'tr:not(.level3_3).'+config['id']+'_level3.'+$this.attr('data-v2')+'_level2.'+$this.attr('data-v1')+'_level1'; break;
    		default : break;
    	}

    	QUEUE.push({name: config['rowIndx'], run: function(cb){
	        $leftBody.find(levelCls).addClass(hide).each(function(){
	            $right_trs.eq(this.rowIndex).addClass(hide);//.find('td').removeClass(tabcls);
	            $(this).removeClass('exp col').first().addClass('col').find('span.pin').addClass('spin')
	            		.parent().find('span.fcell').html('+');
	        //	if(this.getAttribute('data-type') == 'channel'){
	        //	}
        		$(this).find('span.fcell').html('+');
	        });
	        rowUnLock(config['rowIndx']);
	        $this.removeClass('exp').addClass('col');
	        $waiting.html('+').removeClass('wating');
            cb(null); 
            
        }}, function(err){ });
    }
    
    ;function col(){
    	
    	var remote_fn={'remote':function(p){}, 'rowIndex': config['rowIndx'], '$row': $this, 'region': $this.attr('data-region'),
    					'data-v1': $this.attr('data-v1'), 'data-v2': $this.attr('data-v2'), 'data-v3': $this.attr('data-v3'),
    					'data-type': $this.attr('data-type'), 'number': $this.attr('data-number'), 'action': existObject_js, 'complete': complete_existObject
    				  }, levelCls='';
    	
    	$waiting.addClass('wating').html('&nbsp;');
    	
    	switch(config['data-level']){
    		case 'level0':
    			levelCls = 'tr.level1.mark.'+remote_fn['data-v0']+'_level0';
    			break;
    		case 'level1' : 	//this search sold to.
    				remote_fn['data-v1'] = config['id'];
    				remote_fn['region'] = $.trim($this.find('span.namecell').text());
    				remote_fn['data-level'] = 'level2';
    				remote_fn['append'] = appendElement_Level2;
    				levelCls = 'tr.level2.mark.'+config['id']+'_level1';
    				remoteCheck(levelCls, remote_fn, createLevel2, WORK_CLS['level2']); 
    			break;
    		case 'level2' : 	//this search oem. 
    				levelCls = 'tr.level3_3.mark.'+config['id']+'_level2.'+remote_fn['data-v1']+'_level1';//+remote_fn['data-v0']+'_level0';
    			break;
    		case 'level3' : 	//this search part. 
    				remote_fn['data-level'] = 'level4';
    				remote_fn['append'] = appendElement_Level4;
    				remote_fn['data-v4'] = config['id'];
    				levelCls = 'tr.level4.mark.'+config['id']+'_level4.'+$this.attr('data-v3')+'_level3.'+$this.attr('data-v2')+'_level2.'+$this.attr('data-v1')+'_level1';//+remote_fn['data-v0']+'_level0';
    				remoteCheck(levelCls, remote_fn, createLevel4, WORK_CLS['level4']); 
    			break;
    		case 'level1_1' :
	    			remote_fn['data-level'] = 'level1_1';
					remote_fn['append'] = appendElement_Level1_1;
					levelCls = 'tr.level2.mark.'+config['id']+'_level1';//+remote_fn['data-v0']+'_level0';
					remoteCheck(levelCls, remote_fn, createLevel2, WORK_CLS['level2']); 
    			break;
    		case 'level3_3' :
    				remote_fn['data-v3'] = config['id'];
	    			remote_fn['data-level'] = 'level3_3';
					remote_fn['append'] = appendElement_Level3;
					levelCls = 'tr.level3.mark.'+config['id']+'_level3.'+remote_fn['data-v2']+'_level2.'+remote_fn['data-v1']+'_level1';
	    			remoteDoubleCheck(levelCls, remote_fn, createLevel3, WORK_CLS['level3']); 
    			break;
    		default : break;
    	} 
    	remote_fn['remote'](remote_fn);
    	expandElement(levelCls);
    }
    
    ;function remoteDoubleCheck(findCls, remoteFn, createJSON, actionClass){
    	if($this.hasClass('done')){ return; }
    	config['isRemote'] = true;
        remoteFn['cls'] = actionClass;
        remoteFn['json'] = JSON.stringify( new createJSON() );
        remoteFn['remote'] = function(p){
        	customMultipleRemoteAction(p, remoteFn['action'], remoteFn['complete']); //this is remote action
        };
    }
    
    ;function remoteCheck(findCls, remoteFn, createJSON, actionClass){
    	if($this.hasClass('done')){ return; }
    //	$this.find('span.del_img').css('visibility', 'hidden');
        config['isRemote'] = true;
        remoteFn['cls'] = actionClass;
        remoteFn['json'] = JSON.stringify( new createJSON() );
        remoteFn['remote'] = function(p){
        	customMultipleRemoteAction(p, remoteFn['action'], remoteFn['complete']); //this is remote action
        };
    }
    
    
    ;function createLevel2(){
    	ClsObjPrototype.call(this, $.trim($this.find('span.namecell').text()));	//extends base object
    }
    ;function createLevel3(){
    	ClsObjPrototype.call(this, $this.attr('data-region'));	//extends base object
    	this['type'] = ($this.attr('data-type') == 'channel' ? 'channel' : null);
    	this['oemId'] = $this.attr('data-v2');
    }
    ;function createLevel4(){
    	ClsObjPrototype.call(this, $this.attr('data-region'));	//extends base object
    	this['accnumber'] = $this.attr('data-number');
    	this['oemId'] = $this.attr('data-v2');
    }
    
    ;function ClsObjPrototype(region){
    	this['region'] = region;
    	this['type'] = $this.attr('data-type');
    	this['viewMode'] = $('[id*=viewmodeid]').val();
    	this['startDate'] = $('#hidd_start').val();
    	this['endDate'] = $('#hidd_end').val();
    	this['map_year_monthsFuture'] = $.parseJSON($('#hidd_futuremonthmap').val());
    }
    
    ;function isLoadedSubData(){
    	var count=0;
    	switch(config['data-level']){
    		case 'level1' :
    			count = $leftBody.find('tr.level2.'+config['id']+'_level1.cp').find('span.fcell.wating').length;
			break;
    	}
    	if(count != 0){
    		rowUnLock(config['rowIndx']);
    		return true;
    	}
    	return false;
    }
    
    ;function expandElement(levelCls){

    	QUEUE.push({name: config['rowIndx'], run: function(cb){
            var list_element = $leftBody.find(levelCls).toArray();
            async.eachSeries(list_element, function(item, callback) {
                setTimeout(function(){
                	var $item=$(item).removeClass(hide);
                    $right_trs.eq(item.rowIndex).removeClass(hide);
                    if(config['data-level'] == 'level2' && !$item.hasClass('done')){
                    	$item.click();
                    }
                    callback(null);
                }, 65);
            }, function(err){
            	list_element=[];
                if(!config['isRemote']){ 
                    rowUnLock(config['rowIndx']);
                    $waiting.html('-').removeClass('wating'); 
                }
                $this.removeClass('col').addClass('exp');
                cb(null);
            });
        }}, function(err){ });
    }
}

;function event_closePartPopupBox_click(event, target){
	$('#editBoxDiv').hide();
	$('#edit_left_tbody').empty();
	$('#edit_right_tbody').empty();
	$('#popupmain').fadeOut('fast');
}

;function event_hideCalendar_click(e){
	
	if(checkingStatus()){
		return false;
	}
	
	var $this=$(this), $rHead=$('#rHeadBody'), $r_trs=$('#rtabid tr'),
		findCls='', excuteType=$this.attr('data-type'), status=$this.attr('data-status');
	
	switch(excuteType){
		case 'historical': findCls='historicalcls'; break;
		case 'current': findCls='currentcls'; break;
		case 'future': findCls='futurecls'; break;
	}
	
	$rHead.find('#tab_head_list td.'+findCls).each(function(){
		var $this=$(this), cellIndex=this.cellIndex;
		if(status == 'show'){
			$this.addClass('dn');
			$rHead.find('#tab_head_data th.th_'+findCls).addClass('dn');
			$r_trs.find('td:eq('+cellIndex+')').addClass('dn');
		}else{
			$this.removeClass('dn');
			$rHead.find('#tab_head_data th.th_'+findCls).removeClass('dn');
			$r_trs.find('td:eq('+cellIndex+')').removeClass('dn');
		}
	});
	$this.val( (status == 'show' ? $this.attr('data-show') : $this.attr('data-hide')) );
	$this.attr('data-status', (status == 'show' ? 'hide' : 'show'));
}

;function event_table_over(e){
	e.stopPropagation();
    var $this=$(this).removeClass('overbodybg'), _idx=$this.index(), findTab=($this.parent().hasClass('ltbodycls') ? '#rtabid tr' : '#ltabid tr.external');
    eventHandle_ov_ot(e, ov, ot);

    ;function ov(e){ $(findTab).eq(_idx).addClass('overbodybg'); }
    ;function ot(e){ $(findTab).eq(_idx).removeClass('overbodybg overbodybg'); }
}

;function event_windowScroll(e){
	var x=(document.body.scrollTop||document.documentElement.scrollTop), $top=$('#gototopid');
	setTimeout(function(){
		var h=($(document).height() - $(window).height() - 120);
		if(x >= h){ $('#floatscroll').css({'visibility': 'hidden'}); }
		else{ $('#floatscroll').css({'visibility': ''}); }

		var $floatHead=$('#headmainid'),
			xx=($('#globalHeaderBar').outerHeight()+$('#AppBodyHeader').outerHeight()+$('#menudivid').outerHeight()+ $floatHead.outerHeight()+80);
		if((x > xx) && !$floatHead.hasClass('floatheadcls')){
			$floatHead.addClass('floatheadcls').find('td.tab_head_left ').addClass('leftbt');
		}else if(!(x > xx)){
			$floatHead.removeClass('floatheadcls').find('td.tab_head_left ').removeClass('leftbt');
		}
	}, 190);
}

;function event_windowReSize(e){
    $('#forecastdiv_id').css({'visibility': 'hidden'});
    fixTableLayout($('#tabContainer').width(), false);
}

;function event_rCellScroll(e){
    var scLeft=this.scrollLeft;
    if (TIMEOUT){ clearTimeout(TIMEOUT) };
    document.getElementById('right_head').scrollLeft = scLeft;
    TIMEOUT = setTimeout(function(){
	    document.getElementById('floatscroll').scrollLeft = scLeft;
    }, 120);
}

;function event_floatScroll(e){
    var _this=this;
    if (TIMEOUT){ clearTimeout(TIMEOUT) };
    
    document.getElementById('right_head').scrollLeft = _this.scrollLeft;
    $('#rCellScroll').off('scroll').scrollLeft(_this.scrollLeft);
    TIMEOUT = setTimeout(function(){
	    $('#rCellScroll').off('scroll').on('scroll', event_rCellScroll);
    }, 120);
}

;function event_rEditCellScroll(e){
    var _this=this;
    document.getElementById('editLefthead').scrollLeft = _this.scrollLeft;
}

;function getBarConfg(list_rows){
	var pct=(1/list_rows.length * 100), max=Math.floor(pct*list_rows.length), 
	bgColor=Math.floor( Math.random()*16777215 ).toString(16), list_rgba=$.Color('#'+bgColor)._rgba, 
	rgba=( 'rgba('+list_rgba[0]+','+list_rgba[1]+','+list_rgba[2]+',0.3)' );
	return {'pct': pct, 'max': max, 'bgcolor': ('#'+bgColor), 'rgba': rgba};
}

;function fixTableLayout(resize_width){
    try{
        var $compbody=$('#forecastdiv_id'), min_cw= parseInt($compbody.css('min-width').replace('px', ''), 10), 
            max_ow=(typeof(resize_width) != 'undefined' ? resize_width : $('#contentallid').outerWidth(true));
    
        min_cw = (max_ow < min_cw ? min_cw : (max_ow-40));
        
        document.getElementById('contentallid').style.width = (min_cw)+'px';    //set all div width
    
        var lCellw=$compbody.find('#left_body').width(), rightCell_w=parseInt((min_cw-lCellw-2), 10);
        document.getElementById('rCellScroll').style.width = rightCell_w+'px';
        document.getElementById('right_head').style.width = rightCell_w+'px';
        $('#floatscroll').css({'width': rightCell_w, 'left': $('#rCellScroll').offset()['left']}).find('#innerData').css('width', $('#rTabDataId').width());
        $compbody.css('visibility', 'visible');
    }catch(e){
        
    }
}

;function artDialogBox(content){
	art.dialog({
        title:' ', lock:true, dblclick_hide:false, esc:false, id: 'countsid', content: content,
        button : [ {value: 'Ok', focus: true, callback: function(){  }} ]
    });
}

;function numberOfZero(t){
    if(t == ''){return 0;}
    t = Globalize.parseFloat(t);
    return ($.isNumeric(t) ? t : 0);
}

;function getZeroOfNumber(t){
	t=parseFloat(t);
	return ($.isNumeric(t) ? t : 0);
}

;function getZeroOfNumber_Int(t){
	t=parseInt(t, 10);
	return ($.isNumeric(t) ? t : 0);
}

;function rowUnLock(_rowIndex){  //unlocked current row Repeat click event
    setTimeout(function(){ delete STATIC_VAR[_rowIndex]; }, 45);    //unlocked
}
;function rowIsLocked(_rowIndex){    //locked current row Repeat click event
    if(STATIC_VAR.hasOwnProperty(_rowIndex)){ return true; }    //locked 
    STATIC_VAR[_rowIndex] = '';
    return false;
}

;function asyncEachSeries(result, asyncCallBack, asyncCallBackComplete, time, _data, $tbody){
    async.eachSeries(result, function(item, callback){
        setTimeout(function(){
            asyncCallBack(item, callback);
            callback(null);
        }, (time||120));
    }, function(err){
        asyncCallBackComplete(err, _data, $tbody);
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

function customRemoteAction(strParam, callFunction, callResult) {
    Visualforce.remoting.Manager.invokeAction(
        callFunction(), strParam['json'], function(result, event){ callResult(result, event, strParam); }, {escape: false, timeout:120000}
    );
}

function customMultipleRemoteAction(strParam, callFunction, callResult) {
    Visualforce.remoting.Manager.invokeAction(
        callFunction(), strParam['cls'], strParam['json'], function(result, event){ callResult(result, event, strParam); }, {escape: false, timeout:120000}
    );
}

;function eventHandle(e, _over, _out, _click){
    var customMouser = {mouseenter: _over,mouseleave: _out,click: _click};
    customMouser[e.type].call(this, e);customMouser = {};
}

;function eventHandle_ov_ot(e, _over, _out){
    var customMouser = {mouseenter: _over,mouseleave: _out};
    customMouser[e.type].call(this, e);customMouser = {};
}

;function addListener (element, event, fn, params) {
    var eventHandler = ( params ? function(){ fn.call(params); } : fn );
    if (window.attachEvent) {
        element.attachEvent('on' + event, eventHandler);
    } else {
        element.addEventListener(event, eventHandler, false);
    }
}