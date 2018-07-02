var TIMEOUT, scrollbarW=$.getScrollbarWidth(), STATIC_VAR={}, SAVE_ERRORS=[], QUEUE = async.queue(queueRun, 1),
	LAZY = {
		'fire' : function(obj, callback, timeout) {
		    timeout = timeout || 200;
		    setTimeout(function() { callback(null, obj); }, timeout);
		}
	}, 
	DECIMAL_POINT = {'n': 'n', 'n0': 'n0', 'n1': 'n1', 'n4': 'n4'},
	WORK_CLS = {
		'level1' : 'CSD_ClsSamsungViewService.SearchLevel1', 'level2' : 'CSD_ClsSamsungViewService.SearchLevel2', 
		'level3' : 'CSD_ClsSamsungViewService.SearchLevel3', 'level4' : 'CSD_ClsSamsungViewService.SearchLevel4',
		'level0' : 'CSD_ClsSamsungViewService.SearchTotal'
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
	//finallyFormat();
	
	;function description(o, isSpace){
		var space=(isSpace ? ' ': ''), t=(o['attentionString']+space);
		if(o['isRed']){
			t =('<b style="color: red;">'+o['attentionString']+'</b>'+space);
		}
		return t;
	}
	fixViewTemplate();
	fixTableLayout();
	register_event();
	finallyFormat();
}
;function fixViewTemplate(){
	var $lRows=$('#ltabid tr.mark'), $template=$('#level2_left tr.mark, #level3_left tr.mark, #level4_left tr.mark'),
		el_option='<div class="dopcls"><b data-type="gpl" class="dopinnercls active">G</b><b data-type="soldto" class="dopinnercls s">S</b></div>';
	
	$template.find('span.search_img, span.del_img').parent().remove();
	$template.filter('.level2').find('div:first').addClass('mgleft2').removeClass('mgleft1');
	$template.filter('.level3').find('div:first').addClass('mgleft3').removeClass('mgleft1');
	$template.filter('.prot').find('div:first').addClass('mgleft4').removeClass('mgleft1');
	$lRows.find('span.search_img').parent().remove();
	$lRows.find('td:first span:first').append(el_option).find('b').on('click', event_displayType_click);
}
;function finallyFormat(){
	try{
		var o_total={}, cellIndex=$('#tab_head_list td.currentcls')[0].cellIndex-1, $el_level=$('#rtabid tr:not(:first).v1'),
			$totalCell=$('#rtabid tr:first td').css({'font-style': 'italic', 'font-weight': 'bold'});
			
		asyncEachSeries_Original($el_level.toArray(), function(item, call){
			var $item=$(item), $pmfcItem=$item.next(), $dcfcItem=$pmfcItem.next();

			$item.find('td').html(function(){
				var cfc=getZeroOfNumber(this.getAttribute('data-old')), pmfc=getZeroOfNumber(this.getAttribute('data-pmfc')),
					dcfc=getZeroOfNumber(this.getAttribute('data-dcfc'));
				if(this.cellIndex > cellIndex){
					o_total[this.cellIndex] = (getZeroOfNumber(o_total[this.cellIndex]) + cfc);
					$pmfcItem.find('td:eq('+this.cellIndex+')').html( Globalize.format(pmfc, DECIMAL_POINT['n0']) );
					$dcfcItem.find('td:eq('+this.cellIndex+')').html( Globalize.format(dcfc, DECIMAL_POINT['n0']) );
				}
				return Globalize.format(cfc, DECIMAL_POINT['n0']);
			});
		}, function(err){
			for(var o in o_total){
				$totalCell.eq(o).html( Globalize.format(o_total[o], DECIMAL_POINT['n0']) );
			}
		}, 180);
		createTotalRefDate($('#ltabid'), $('#rtabid'));
		$('#ltabid tr.mark.level1').attr('data-type', 'gpl');
	}catch(e){ }
	$('#menuBtntd input[data-type="historical"]').click();
	document.getElementById('loading-curtain-div').style.display = 'none';
	
	;function createTotalRefDate($lBody, $rBody){
		var list_result=[], list_months=[], el_body='', 
			datas={'$lBody': $lBody, '$rBody': $rBody, 'monthCell': {}, 'cellMonth': {}, 'oemId': $('#hidd_samsungid').val(),
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
			attr_tmp['json'] = {'set_fiscalMonth': [month], 'oemId': attr_tmp['oemId']};
			attr_tmp['json'] = JSON.stringify(attr_tmp['json']);
			customMultipleRemoteAction(attr_tmp, attr_tmp['action'], attr_tmp['complete']); //this is remote action
		}, function(err){}, 120);
	}
}

;function register_event(){
	var $body_div = $('#div_body'), s='<img src="/s.gif" class="helpIcon" title="Billing total for histrical months, forecast total for current/future months."/> ';
	
	$body_div.find('#ltabid tr:first').removeClass('cp mark').find('td:last').empty().parent()
			.find('div.dis_ib.mgleft').addClass('mgleft1').css({'font-weight':'bold', 'margin-left': '35px'})
			.find('span.namecell').before(s).parent().parent().parent().find('div:not(.dis_ib.mgleft)').remove();
	
	
	//$body_div.find('#ltabid tr.totcls div.mgleft1').removeClass('mgleft1').find('span.fcell').removeClass('fcell').addClass('pin spin').html('&nbsp;');
	$body_div.find('#ltabid span.pin').on('click', event_refData_click);
	
	$body_div.find('#rCellScroll').scroll(event_rCellScroll);
	$body_div.find('#ltabid tr.cp').on('click', event_existData_click);

	$body_div.find('tbody.overbody tr').on('mouseenter mouseleave', event_table_over);

	$('#menuBtntd input').on('click', event_hideCalendar_click);
	$(document).on('mousedown', {'elDrop': document.getElementById('dropBoxId'), '$aBox': $('#forecastdiv_id')}, event_dorpBox_down);

	$(window).scroll(event_windowScroll).smartresize(event_windowReSize);
	$('#floatscroll').scroll(event_floatScroll);
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
			data['$left'] = $( ('#ltabid tr.level1.'+data['v1']+'_level1') ).last();
			data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');
			data['$gpl_left_template'] = $('#level2_left tr').clone();
			data['$gpl_right_template'] = $('#level2_right tr').clone();
			data['$soldto_left_template'] = $('#level4_left tr').clone();
			data['$soldto_right_template'] = $('#level4_right tr').clone();
			
			data['$soldto_left_template'].filter(':not(:eq(0))').each(function(){
				$(this).find('td:first').removeClass('lev3').addClass('lev1');
			});
			data['$soldto_right_template'].first().find('td:gt('+ftCell+')').addClass('td_input');
			
			hideRightColumns(data['$gpl_right_template']);
			hideRightColumns(data['$soldto_right_template']);
			
			registerEvent(data['$gpl_left_template'], data['$gpl_right_template']);
			registerEvent(data['$soldto_left_template'], data['$soldto_right_template']);
			
			break;
		case 'level3' :
			data['$left'] =  $( ('#ltabid tr.level2.'+data['v2']+'_level2.'+data['v1']+'_level1') ).last();
			data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');
			data['$left_template'] = $('#level3_left tr').clone();
			data['$right_template'] = $('#level3_right tr').clone();
			data['$right_template'].first().find('td:gt('+ftCell+')').addClass('td_input');//.html('<input type="text" data-type="level3" class="inputcls"/>');
			
			if(data['type'] == 'soldto'){
				data['$left_template'].first().removeClass('cp').find('span.pin')
						.addClass('pppin fixedleft').css({'margin-left': '25px'}).on('click', event_refData_click)
								.parent().find('span.fcell ').remove();//.find('span.fcell').addClass('cpp spin').parent()
			}
			
			hideRightColumns(data['$right_template']);
			registerEvent(data['$left_template'], data['$right_template']);
			break;
		case 'level4':

			data['$left'] = $( ('#ltabid tr.level3.'+data['v3']+'_level3.'+data['v2']+'_level2.'+data['v1']+'_level1') ).last();
			data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');

			data['$left_template'] = $('#level4_left tr').clone();
			data['$right_template'] = $('#level4_right tr').clone();
            
			data['$right_template'].first().find('td:gt('+ftCell+')').addClass('td_input');
			
			hideRightColumns(data['$right_template']);
			registerEvent(data['$left_template'], data['$right_template']);
			data['$left_template'].find('span.fcell').addClass('pin pppin').removeClass('fcell cpp').html('').on('click', event_refData_click);
			break;
		case 'level2-4':
		
			data['$left'] = $( ('#ltabid tr.level1.'+data['v1']+'_level1') ).last();
			data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');
			data['$gpl_left_template'] = $('#level2_left tr').clone();
			data['$gpl_right_template'] = $('#level2_right tr').clone();
			
			data['$part_left_template'] = $('#level3_left tr').clone();
			data['$part_right_template'] = $('#level3_right tr').clone();
			
			data['$soldto_left_template'] = $('#level4_left tr').clone();
			data['$soldto_right_template'] = $('#level4_right tr').clone();
			
			data['$soldto_left_template'].filter(':not(:eq(0))').each(function(){
				$(this).find('td:first').removeClass('lev3').addClass('lev1');
			});
			
			data['$part_right_template'].first().find('td:gt('+ftCell+')').addClass('td_input').html('<input type="text" data-type="level3" class="inputcls"/>');
			data['$soldto_right_template'].first().find('td:gt('+ftCell+')').addClass('td_input').html('<input type="text" data-type="level2" class="inputcls"/>');
			
			hideRightColumns(data['$gpl_right_template']);
			hideRightColumns(data['$part_right_template']);
			hideRightColumns(data['$soldto_right_template']);
			
			registerEvent(data['$gpl_left_template'], data['$gpl_right_template']);
			registerEvent(data['$part_left_template'], data['$part_right_template']);
			registerEvent(data['$soldto_left_template'], data['$soldto_right_template']);
			break;
	}
	event_windowScroll();
	
	;function hideRightColumns($elemetns){
		$elemetns.each(function(){
			var $tds = $(this).find('td');
			for(var i=0, el; el=list_hidden_td[i]; i++){
				$tds.eq(el.cellIndex).addClass('dn');
			}
		});
	}
	
	;function registerEvent($leftElements, $rightElements){
		$leftElements.on('mouseenter mouseleave', event_table_over).filter('.cp')
						  .on('click', event_existData_click).find('span.pin').on('click', event_refData_click);
		
		$rightElements.on('mouseenter mouseleave', event_table_over);
	}
}

;function appendElement_Level2(data, callBack, callBackEnd){
	data['list_result'].reverse();
	asyncEachSeries_Original(data['list_result'], function(item, call){
console.log( item);
		var strName=(data['type'] == 'gpl' ? (item['name']+'-[ '+item['accnumber']+' ]') : (item['accnumber']+'-[ '+item['name']+' ]')),
			$lClone=data['$gpl_left_template'].clone(true), $rClone=data['$gpl_right_template'].clone(true);
		
		if(item['type'] == 'NonPart' && data['type'] == 'gpl'){
			$lClone=data['$soldto_left_template'].clone(true);
			$rClone=data['$soldto_right_template'].clone(true);
			$lClone.eq(0).find('div:first').addClass('mgleft2').removeClass('mgleft4');
		}else{
			$lClone.eq(0).attr({'title': item['name']});
		}
		
		if(item['type'] == 'NonPart' && data['type'] == 'soldto'){
		//	$lClone.first().off('click').removeClass('cp').find('span.fcell').on('click', event_refData_click)
		//				.addClass('cpp spin').parent().find('span.pin').remove();
		}
		
		$lClone.addClass( (data['v1']+'_level1 level2 '+item['id']+'_level2') ).eq(0)
				.attr({'id': item['id'], 'data-number': item['accnumber'], 'data-v1': data['v1'], 'data-level': 'level2', 'data-gplcode': data['gplcode'], 'data-familyname': data['familyname']})
				.find('span.namecell').html(strName);
		
		$rClone.addClass('rlevel2').eq(0).find('td').each(function(){
			var $this=$(this), $input=$this.find('input'), attr = { 'data-old': 0 };
			if(item['csFC'] && item['csFC'].hasOwnProperty( data['cellMonth'][this.cellIndex] )){
				attr['data-old'] = (item['csFC'][data['cellMonth'][this.cellIndex]]);	
			}
			$this.attr(attr).html( Globalize.format(attr['data-old'], DECIMAL_POINT['n0']) );
		});
		
		setFieldValue($rClone.eq(1).find('td:gt('+(data['ftCell']-1)+')'), data, item['pmFC']);
		setFieldValue($rClone.eq(2).find('td:gt('+(data['ftCell']-1)+')'), data, item['dcFC']);

		
		data['$left'].after($lClone);
		data['$right'].after($rClone);
		
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

	asyncEachSeries_Original(data['list_result'], function(item, call){

		var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true),
			gplCode=(item['gplcode'] != 'null' && item['gplcode'] != null ? (' ['+item['gplcode']+']') : '' );
		
		$lClone.addClass( (data['v2']+'_level2 '+item['id']+'_level3 '+data['v1']+'_level1') )
				.eq(0).attr({'id': item['id'], 'title': item['snumber'], 'data-v1': data['v1'], 'data-v2': data['v2'], 'data-number': data['data-number'],
							'data-familyname': data['$row'].attr('data-familyname'), 'data-gplcode': data['$row'].attr('title') })
				.find('span.namecell').html(item['name']+gplCode);

		$rClone.addClass('rlevel3').eq(0).find('td').each(function(){
			var mapRestPNFC=item['restPNFC'], mapCSFC=item['csFC'],
				$this=$(this), $input=$this.find('input'), attr={ 'data-old': 0 , 'data-restpn': 0};
			if(mapCSFC && mapCSFC.hasOwnProperty( data['cellMonth'][this.cellIndex] )){//CurrentsalesForecast
				attr['data-old'] = (mapCSFC[data['cellMonth'][this.cellIndex]]);	
			}
			/*
			if(mapRestPNFC && mapRestPNFC.hasOwnProperty( data['cellMonth'][this.cellIndex] )){//rest pn fc
				attr['data-restpn'] = (mapRestPNFC[data['cellMonth'][this.cellIndex]]);	
			}
			*/
			$this.attr(attr).html( Globalize.format(attr['data-old'], DECIMAL_POINT['n0']) );
		});
		
		setFieldValue($rClone.eq(1).find('td:gt('+(data['ftCell']-1)+')'), data, item['pmFC']);
		setFieldValue($rClone.eq(2).find('td:gt('+(data['ftCell']-1)+')'), data, item['dcFC']);

		data['$left'].after($lClone);
		data['$right'].after($rClone);
		
	}, function(err){
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

//console.log(' - 2 - '+JSON.stringify(data['list_result']));
async.sortBy(data['list_result'], function(item, callback) {
	    setTimeout(function() {
	    	var sum=0;
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
		$lClone.addClass( (item['id']+'_level4 level4 '+data['v3']+'_level3 '+data['v2']+'_level2 '+data['v1']+'_level1') )
				.eq(0).attr({'id': item['id'], 'data-level': 'level4', 'data-v3': data['v3'], 'data-v2': data['v2'], 'data-v1': data['v1'],
							 'title': item['name'], 'data-number': item['accnumber'], 'data-familyname': data['$row'].attr('data-familyname'), 'data-gplcode': data['$row'].attr('data-gplcode')})
				.find('span.namecell').html(item['accnumber']+'-[ '+item['name']+' ]');
        $lClone.eq(0).find('td:last').addClass('textcss');
        if(islastelement == 'true')
		{
			$rClone.addClass('lastElementright' + data['data-v3']);
			$lClone.addClass('lastElementleft' + data['data-v3']);
			islastelement = 'false';
		}
		$rClone.addClass('rlevel4').eq(0).find('td').each(function(){
			var attr = { 'data-nprice':0, 'data-nqty':0, 'data-price':0, 'data-qty': 0, 'data-old': 0 };
			if(item['csFC'] && item['csFC'].hasOwnProperty( data['cellMonth'][this.cellIndex] )){
				var  o = item['csFC'][data['cellMonth'][this.cellIndex]];
				attr['data-nprice']=o['price'];
				attr['data-price']=o['price'];
				attr['data-nqty']=o['quantity'];
				attr['data-qty']=o['quantity'];
				attr['data-old']=o['forecast'];
			}
			$(this).attr(attr).html( Globalize.format(attr['data-old'], DECIMAL_POINT['n0']) );
		});
		
		setFieldValue($rClone.eq(1).find('td:gt('+(data['ftCell']-1)+')'), data, item['pmFC']);
		setFieldValue($rClone.eq(2).find('td:gt('+(data['ftCell']-1)+')'), data, item['dcFC']);
		
		data['$left'].after($lClone);
		data['$right'].after($rClone);
		
	}, function(err){
	
		callBackEnd(callBack, data);
	}, 150);


		if(list_results.length > 0){
		var s = 'showlink'+data['data-v3'];
		
		$rCloneother.addClass('right'+s);	
		$lCloneother.addClass(('othersoldto_level4 '+data['data-v3']+'_level3 '+data['data-v2']+'_level2 '+data['data-v1']+'_level1 left' + s ) )
				 				
				.find('span.namecell').append('<a href="#ShowMore">Show More</a>').click(function(e){
			    
				 //list_results.reverse();
				//newlist_topTen.push(list_results);
				var newlist_topTen=list_results.splice(0,10);
				//newlist_topTen.reverse();
			asyncEachSeries_Original( newlist_topTen, function(item, call){
		var $lClone1=data['$left_template'].clone(true), $rClone1=data['$right_template'].clone(true);
		$lClone1.addClass( (item['id']+'_level4 level4 '+data['v3']+'_level3 '+data['v2']+'_level2 '+data['v1']+'_level1') )
				.eq(0).attr({'id': item['id'], 'data-level': 'level4', 'data-v3': data['v3'], 'data-v2': data['v2'], 'data-v1': data['v1'],
							 'title': item['name'], 'data-number': item['accnumber'], 'data-familyname': data['$row'].attr('data-familyname'), 'data-gplcode': data['$row'].attr('data-gplcode')})
				.find('span.namecell').html(item['accnumber']+'-[ '+item['name']+' ]');
        $lClone1.eq(0).find('td:last').addClass('textcss');
		$rClone1.addClass('rlevel4').eq(0).find('td').each(function(){
			var attr = { 'data-nprice':0, 'data-nqty':0, 'data-price':0, 'data-qty': 0, 'data-old': 0 };
			if(item['csFC'] && item['csFC'].hasOwnProperty( data['cellMonth'][this.cellIndex] )){
				var  o = item['csFC'][data['cellMonth'][this.cellIndex]];
				attr['data-nprice']=o['price'];
				attr['data-price']=o['price'];
				attr['data-nqty']=o['quantity'];
				attr['data-qty']=o['quantity'];
				attr['data-old']=o['forecast'];
			}
			$(this).attr(attr).html( Globalize.format(attr['data-old'], DECIMAL_POINT['n0']) );
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
			console.log(result);
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

;function complete_existResult(result, event, data){
	QUEUE.push({name: data['rowIndex'], run: function(cb){
		if(event.status){
			complete_remoteResultCheck(result, data, cb, data['appendElement'], complete_appendElementEND);
	    }else{ 
			complete_errorReload(data, event, event_reloadExistData_click);
	    	cb(null);
	    }
	}}, function(err){ });
}

;function complete_remoteResultCheck(result, data, queueComplete, appendCallBack, appendCallBackEND){
	data['list_result'] = $.parseJSON(result);

    if(data['list_result'].length == 0){ 
    	appendCallBackEND(queueComplete, data);
        return;
    }
    setTemplateElement(data);
    appendCallBack(data, queueComplete, appendCallBackEND);
}

;function complete_appendElementEND(queueComplete, _data){
	rowUnLock(_data['rowIndex']);
	_data['$row'].removeClass('ready').addClass('done').find('td:first span.fcell').html('-').removeClass('wating');
	_data['$row'].find('div.dopcls').removeClass('fix').find('b').on('click', event_displayType_click);
	queueComplete(null); 
}


;function complete_errorReload(data, event, callBack){

    var el_reload = '<span class="reload_span"><span class="reload_img"></span><b class="reload_msg">'+event['message']+'</b></span>';
    data['$row'].removeClass('exp done').find('td:first span.wating.fcell').before(el_reload)
            .parent().find('span.reload_span').on('click', {$data: data}, function(e){
            	e.stopPropagation();
            	callBack(e, $(this));
            });
    data['$row'].find('div.dopcls').removeClass('fix').find('b').on('click', event_displayType_click);
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

;function event_displayType_click(e){
	e.stopPropagation();
	if($(this).hasClass('active')){
		return;
	}

	var $this=$(this), $div=$this.parent(), $actives=$div.find('b'), $tr=$div.parent().parent().parent(),
		$lBody=$tr.parent(), $rBody=$('#rtabid'), id_level1=$tr.attr('id');
	
    QUEUE.push({name: id_level1, run: function(cb){
    	$lBody.find('tr.'+id_level1+'_level1:not(.level1)').each(function(){
    		$rBody.find('tr:eq('+this.rowIndex+')').remove();
    		$(this).remove();
    	});
    	
    	$tr.find('span.fcell.wating').removeClass('wating').parent().find('span.reload_span').remove();
		$tr.removeClass('done exp').attr('data-type', $this.attr('data-type')).addClass('col').find('span.fcell').html('+');
		$actives.filter('.active').removeClass('active');
		$this.addClass('active');
		cb(null);
    }}, function(err){ });	

}


;function event_refData_click(e){
	e.stopPropagation();
	if($(this).hasClass('watingpin')){
		return;
	}
	var $this=$(this), $td=$this.parent().parent().parent(), $tr=$td.parent(), $statistical=$tr.next().next().next(),
		$billing=$statistical.next(), $booking=$billing.next(), $backlog=$booking.next(), execute=($this.hasClass('spin')? exp : col),
		attr={ 'findcls': '', 'json' : {}, 'cls': '', 'monthCell': {}, 'cellMonth': {}, '$pin': $this, '$row': $tr, 
			'level': $tr.attr('data-level'), 'oemid': $('#hidd_samsungid').val(), 'crtCell': $('#tab_head_list td.currentcls')[0].cellIndex,
			'id': $tr.attr('id'), 'v1': $tr.attr('data-v1'), 'v2': $tr.attr('data-v2'), 'v3': $tr.attr('data-v3'), '$booking': $booking,
			'$statistical' : $statistical, '$billing': $billing, '$backlog': $backlog, 'actionBacklog': getBacklogRefData_js,
			'$lbody': $tr.parent(), '$rbody': $('#rtabid'), 'isExpansionSoldto': false, 'data-number': $tr.attr('data-number'), 
			'action' : getRefData_js, 'complete' : complete_refData, 'completeBacklog': complete_refDataBacklog
			 };
	
	event_windowScroll();
	switch(attr['level']){
		case 'level1':
			attr['gplfamily'] = $.trim($tr.find('span.namecell').text());
			attr['findcls'] = 'tr:not(.mark).level1.'+attr['id']+'_level1';
			attr['isOtherMethod'] = ($tr.attr('data-type') == 'soldto' ? true : false);
			attr['cls'] = WORK_CLS['level1'];
			break;
		case 'level2':
			attr['gplfamily'] = $tr.attr('data-familyname');
			attr['gplcode'] = $tr.attr('title');
			attr['isExpansionSoldto'] = $tr.hasClass('prot');
			attr['findcls'] = 'tr:not(.mark).level2.'+attr['id']+'_level2.'+attr['v1']+'_level1';
			attr['isOtherMethod'] = ($tr.parent().find('tr.mark.level1.'+attr['v1']+'_level1').attr('data-type') == 'soldto' ? true : false);
			attr['soldtoid'] = attr['id'];
			attr['cls'] = WORK_CLS['level2'];
			break;
		case 'level3':
			attr['gplfamily'] = $tr.attr('data-familyname');
			attr['gplcode'] = $tr.attr('data-gplcode');
			attr['partid'] = attr['id'];
			attr['findcls'] = 'tr:not(.mark).level3.'+attr['id']+'_level3.'+attr['v2']+'_level2.'+attr['v1']+'_level1';
			attr['isOtherMethod'] = ($tr.parent().find('tr.mark.level1.'+attr['v1']+'_level1').attr('data-type') == 'soldto' ? true : false);
			attr['soldtoid'] = attr['v2'];
			attr['cls'] = WORK_CLS['level3'];
			break;
		case 'level4':
			attr['gplfamily'] = $tr.attr('data-familyname');
			attr['gplcode'] = $tr.attr('data-gplcode');
			attr['partid'] = attr['v3'];
			attr['soldtoid'] = attr['id'];
			attr['findcls'] = 'tr:not(.mark).level4.'+attr['id']+'_level4.'+attr['v3']+'_level3.'+attr['v2']+'_level2.'+attr['v1']+'_level1';
			attr['cls'] = WORK_CLS['level4'];
			break;
	}

	execute();
	
	/* START Help function */
	;function exp(){
		if(!$this.hasClass('refdata')){
			$this.addClass('refdata');
		//	executeRemote();
			createHistoricalStatus(attr['$billing']);
			createFutureStatus(attr['$backlog']);
		}
		/*
		if(!$this.hasClass('donepin')){
			$this.addClass('watingpin');
			$tr.find('div.dopcls').addClass('fix');
			executeRemote();
		}
		*/
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
			attr_tmp['json'] = {'set_fiscalMonth': list_q, 'oemId': attr_tmp['oemid'], 'gplfamily': attr_tmp['gplfamily'], 
								'isExpansionSoldto': attr_tmp['isExpansionSoldto'], 'gplcode': attr_tmp['gplcode'], 'accnumber': attr_tmp['data-number'],
								'isOtherMethod': attr_tmp['isOtherMethod'], 'partId': attr_tmp['partid'], 'soldtoId': attr_tmp['soldtoid']};
								
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
			attr_tmp['json'] = {'set_fiscalMonth': list_q, 'oemId': attr_tmp['oemid'], 'gplfamily': attr_tmp['gplfamily'], 
								'isExpansionSoldto': attr_tmp['isExpansionSoldto'], 'gplcode': attr_tmp['gplcode'], 'accnumber': attr_tmp['data-number'],
								'isOtherMethod': attr_tmp['isOtherMethod'], 'partId': attr_tmp['partid'], 'soldtoId': attr_tmp['soldtoid']};
								
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
			attr_tmp['json'] = {'set_fiscalMonth': list_q, 'oemId': attr_tmp['oemid'], 'gplfamily': attr_tmp['gplfamily'], 
								'isExpansionSoldto': attr_tmp['isExpansionSoldto'], 'gplcode': attr_tmp['gplcode'], 'accnumber': attr_tmp['data-number'],
								'isOtherMethod': attr_tmp['isOtherMethod'], 'partId': attr_tmp['partid'], 'soldtoId': attr_tmp['soldtoid']};
								
			attr_tmp['json'] = JSON.stringify(attr_tmp['json']);
			customMultipleRemoteAction(attr_tmp, attr_tmp['action'], attr_tmp['complete']); //this is remote action
			customMultipleRemoteAction(attr_tmp, attr_tmp['actionBacklog'], attr_tmp['completeBacklog']); //this is remote action

		}, function(err){}, 120);
		
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
	var hide='dn', $right_trs=$('#rtabid tr'), _this = this, $this=$(_this), 
    	$leftBody=$this.parent(), $waiting = $this.find('td:first span.fcell'), $pin=$this.find('span.pin'),
    	config={'id': $this.attr('id'), 'data-number': $this.attr('data-number'), 'data-level': $this.attr('data-level'), 'rowIndx': $this.index(), 'isRemote': false},
        fn = ($this.hasClass('exp')? exp : col);

    $this.find('td:first span.reload_span').remove();
    if($this.find('td:first input[type="button"].delpartbtn').hasClass('disabled_btn')){ return false; }
    if(rowIsLocked(config['rowIndx'])){ return false; }

    fn();
    
    ;function exp(){
    	
    	if(isLoadedSubData()){
    		return false;
    	}
    	
    	var levelCls = '';
    	
    	switch(config['data-level']){
    		case 'level1' : 
    				levelCls = 'tr:not(.level1).'+config['id']+'_level1';
				break;
    		case 'level2' :
    				levelCls = 'tr:not(.level2).'+config['id']+'_level2.'+$this.attr('data-v1')+'_level1';
    			break;
    		case 'level3' :
    				levelCls = 'tr:not(.level3).'+config['id']+'_level3.'+$this.attr('data-v2')+'_level2.'+$this.attr('data-v1')+'_level1';
    			break;
    		default : break;
    	}

    	QUEUE.push({name: config['rowIndx'], run: function(cb){
	        $leftBody.find(levelCls).addClass(hide).each(function(){
	            $right_trs.eq(this.rowIndex).addClass(hide);//.find('td').removeClass(tabcls);
	            $(this).removeClass('exp col').first().addClass('col').find('span.pin').addClass('spin')
	            		.parent().find('span.fcell').html('+');
	        });
	        rowUnLock(config['rowIndx']);
	        $this.removeClass('exp').addClass('col');
	        $waiting.html('+').removeClass('wating');
            cb(null);
           /* Added for folding show more link by padmaja */
            
            $('.leftshowlink'+$this.attr('data-v3')).show(function() {
				$(this).hide();
			});
			$('.rightshowlink'+$this.attr('data-v3')).show(function() {
				$(this).hide();
			});
			
			$('.leftshowlink'+$this.attr('data-v2')).show(function() {
				$(this).hide();
			});
			$('.rightshowlink'+$this.attr('data-v2')).show(function() {
				$(this).hide();
			});
			
			$('.leftshowlink'+$this.attr('data-v1')).show(function() {
				$(this).hide();
			});
			$('.rightshowlink'+$this.attr('data-v1')).show(function() {
				$(this).hide();
			});
			
			$('.leftshowlink'+$this.attr('data-level')).show(function() {
				$(this).hide();
			});
			$('.rightshowlink'+$this.attr('data-level')).show(function() {
				$(this).hide();
			});
            
            
        }}, function(err){ });
    }
    
    ;function col(){
    	
    	var remote_fn={'remote':function(p){}, 'rowIndex': config['rowIndx'], 'data-number': config['data-number'],
    					'$row': $this, 'action': existObject_js, 'complete': complete_existResult,
    					'v1': $this.attr('data-v1'), 'v2': $this.attr('data-v2'), 'v3': $this.attr('data-v3')}, levelCls='';
    	
    	$waiting.addClass('wating').html('&nbsp;');
    	$this.find('div.dopcls').addClass('fix').find('b').off('click');
    	switch(config['data-level']){
    		case 'level1' : 	//this search oem.
    				remote_fn['v1'] = config['id'];
    				remote_fn['type'] = $this.attr('data-type');
    				remote_fn['data-level'] = 'level2';
    				remote_fn['familyname'] = $.trim($this.find('span.namecell').text());
    				remote_fn['appendElement'] = appendElement_Level2;
    				levelCls = 'tr.level2.mark.'+config['id']+'_level1';
    				remoteCheck(levelCls, remote_fn, createLevel2, WORK_CLS['level2']); 
    			break;
    		case 'level2' : 	//this search part. 
    				remote_fn['v2'] = config['id'];
    				remote_fn['data-level'] = 'level3';
    				remote_fn['type'] = $leftBody.find('tr.mark.level1.'+remote_fn['v1']+'_level1').attr('data-type');
    				levelCls = 'tr.level3.mark.'+config['id']+'_level2.'+remote_fn['v1']+'_level1';
    				remote_fn['appendElement'] = appendElement_Level3;
    				remoteCheck(levelCls, remote_fn, createLevel3, WORK_CLS['level3']); 
    			break;
    		case 'level3' : 	//this search part. 
    				remote_fn['v3'] = config['id'];
    				remote_fn['data-level'] = 'level4';
    				remote_fn['appendElement'] = appendElement_Level4;
    				levelCls = 'tr.level4.mark.'+config['id']+'_level3.'+remote_fn['v2']+'_level2.'+remote_fn['v1']+'_level1';
    				remoteCheck(levelCls, remote_fn, createLevel4, WORK_CLS['level4']); 
    			break;
    		default : break;
    	}
    	/* Added for folding show more link by padmaja */
    	$('.leftshowlink'+$this.attr('data-v3')).first().show();
		$('.rightshowlink'+$this.attr('data-v3')).first().show();
    	remote_fn['remote'](remote_fn);
    	expandElement(levelCls);
    }
    
    
    
    ;function remoteCheck(findCls, remoteFn, createJSON, actionClass){
    	if($this.hasClass('done')){ return; }
    	$this.find('span.del_img').css('visibility', 'hidden');
        config['isRemote'] = true;
        remoteFn['cls'] = actionClass;
        remoteFn['json'] = createJSON(findCls);
        remoteFn['remote'] = function(p){
        	customMultipleRemoteAction(p, remoteFn['action'], remoteFn['complete']); //this is remote action
        };
    }
    
    
    ;function createLevel2(){
    	var t=new createBaseLevel(), type=$this.attr('data-type');
    	t['gplfamily'] = $.trim($this.find('span.namecell').text());
    	t['isOtherMethod'] = (type == 'soldto' ? true : false);
    	return JSON.stringify(t);
    }
    ;function createLevel3(){
        var t=new createBaseLevel(), type=$leftBody.find('tr.mark.level1.'+$this.attr('data-v1')+'_level1').attr('data-type');
        t['gplfamily'] = $this.attr('data-familyname');
        t['gplcode'] = ( type == 'soldto' ? '' : $this.attr('title') );
        t['isOtherMethod'] = (type == 'soldto' ? true : false);
        t['soldtoId'] = config['id'];

    	return JSON.stringify(t);
    }
    
    ;function createLevel4(){
		var t=new createBaseLevel();
    	t['partId'] = config['id'];
    	t['gplcode'] = $this.attr('data-gplcode');
    	t['gplfamily'] = $this.attr('data-familyname');
    	return JSON.stringify(t);
    }
    
    ;function createBaseLevel(){
    	this['accnumber'] = config['data-number'];
    	this['viewMode'] = 'view';
    	this['oemId'] = $('#hidd_samsungid').val();
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
                    callback(null);
                }, 65);
            }, function(err){
            	list_element=[];
                if(!config['isRemote']){ 
                    rowUnLock(config['rowIndx']);
                    $waiting.html('-').removeClass('wating'); 
	                $this.find('div.dopcls').removeClass('fix').find('b').on('click', event_displayType_click);
                }
                $this.removeClass('col').addClass('exp');
                cb(null);
            });
        }}, function(err){ });
    }
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