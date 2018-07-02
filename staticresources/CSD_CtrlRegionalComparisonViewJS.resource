var TIMEOUT, scrollbarW = $.getScrollbarWidth(), STATIC_VAR={}, SAVE_ERRORS=[], QUEUE = async.queue(queueRun, 1),
	LAZY = {
		'fire' : function(obj, callback, timeout) {
		    timeout = timeout || 200;
		    setTimeout(function() { callback(null, obj); }, timeout);
		}
	}, 
	DECIMAL_POINT = {'n': 'n', 'n0': 'n0', 'n1': 'n1', 'n4': 'n4'},
	WORK_CLS = {
		'level1' : 'CSD_ClsRegionalComparisonViewService.SearchLevel1', 'level2' : 'CSD_ClsRegionalComparisonViewService.SearchLevel2', 
		'level3' : 'CSD_ClsRegionalComparisonViewService.SearchLevel3', 'level4' : 'CSD_ClsRegionalComparisonViewService.SearchLevel4'
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
	finallyFormat();
}

;function finallyFormat(){
	var $lBody=$('#ltabid'), $rBody=$('#rtabid'), all_total={}, csMonthCells={}, dcMonthCells={}, gapMonthCells={},
		$totalCells=$rBody.find('tr:first.rlevel1 td'), $leftTmp=$('#lefttemplate tr').clone().addClass('dn'), 
		$nonLeftTmp=$leftTmp.clone().addClass('dn'), $rightTmp=$('#righttemplate tr').clone().addClass('dn');
		
	$nonLeftTmp.addClass('level0').attr({'data-level': 'level1_1'}).find('div.dis_ib.mgleft1').css('margin-left', '34px');
	$leftTmp.addClass('level0').attr({'data-type': 'channel', 'data-level': 'level1_1'}).find('div.dis_ib.mgleft1').css('margin-left', '34px');
	$nonLeftTmp.find('span.namecell').html('Non - Channel');
	$leftTmp.find('span.namecell').html('Channel');
	
	$leftTmp.on('mouseenter mouseleave', event_table_over).filter('.cp').on('click', event_existData_click);
	$nonLeftTmp.on('mouseenter mouseleave', event_table_over).filter('.cp').on('click', event_existData_click);
	$rightTmp.addClass('rlevel0').on('mouseenter mouseleave', event_table_over);
//	setFirstLevelGroupByChannel($lBody, $rBody);
	
	try{

		$('#tab_head_list td').each(function(){
			var $this=$(this), attr_date=this.getAttribute('data-date');
			if($this.hasClass('historicalcls')){ csMonthCells[attr_date] = this.cellIndex; }
			if($this.hasClass('currentcls')){ dcMonthCells[attr_date] = this.cellIndex; }
			if($this.hasClass('futurecls')){ gapMonthCells[attr_date] = this.cellIndex; }
		});

		asyncEachSeries_Original($('#rtabid tr:not(:first)'), function(item, call){
			var $lItem=$lBody.find('tr:eq('+item.rowIndex+')'), $item=$(item), $tds=$item.find('td'), map_csFC=$.parseJSON($item.attr('data-csfc')), 
				map_dcFC=$.parseJSON($item.attr('data-dcfc')), map_gapFC=$.parseJSON($item.attr('data-gapfc')),
				$channel=$leftTmp.clone(true), $nonchannel=$nonLeftTmp.clone(true), _v1=$lItem.attr('data-v1');


			setCellForecast(map_csFC, csMonthCells, $tds, all_total);
			setCellForecast(map_dcFC, dcMonthCells, $tds, all_total);
			setCellForecast(map_gapFC, gapMonthCells, $tds, all_total);
			
		//	$channel.attr({'data-v2': uuid.v4(), 'data-v1': _v1, 'data-region': $lItem.attr('data-region')}).addClass(_v1+'_level1');
		//	$nonchannel.attr({'data-v2': uuid.v4(), 'data-v1': _v1, 'data-region': $lItem.attr('data-region')}).addClass(_v1+'_level1');
			
		//	$lItem.after($channel.addClass($channel.attr('data-v2')+'_level11'));
		//	$lItem.after($nonchannel.addClass($nonchannel.attr('data-v2')+'_level11'));
		//	$item.after($rightTmp.clone(true));
		//	$item.after($rightTmp.clone(true));
			
		}, function(err){
			for(var idx in all_total){
				$totalCells.eq(idx).html( Globalize.format(all_total[idx], DECIMAL_POINT['n0']) );
			}
		}, 180);
	}catch(e){ }

	document.getElementById('loading-curtain-div').style.display = 'none';
	
	;function setCellForecast(mapFC, monthCells, $t, all_total){
		for(var key in mapFC){
			$t.eq(monthCells[key]).attr('data-old', mapFC[key]).html( Globalize.format(mapFC[key], DECIMAL_POINT['n0']) );
			all_total[monthCells[key]] = (getZeroOfNumber(all_total[monthCells[key]]) + mapFC[key]);
		}
	}
	;function setFirstLevelGroupByChannel($lBody, $rBody){
		var dnCls=' dn ', $channel_l=$lBody.find('tr[data-type="totalchannel"]').removeAttr('class').removeAttr('data-v1'),
			$nonChannel_l=$lBody.find('tr[data-type="nontotalchannel"]').removeAttr('class').removeAttr('data-v1'),
			$channel_r=$rBody.find('tr:eq('+$channel_l.index()+')').removeAttr('class').addClass('v0 rlevel0'),
			$nonChannel_r=$rBody.find('tr:eq('+$nonChannel_l.index()+')').removeAttr('class').addClass('v0 rlevel0');

		$channel_l.addClass('level0 external '+$channel_l.attr('id')+'_level0 cp mark done').attr({'data-level': 'level0', 'data-v0': $channel_l.attr('id')});
		$nonChannel_l.addClass('level0 external '+$nonChannel_l.attr('id')+'_level0 cp mark done').attr({'data-level': 'level0', 'data-v0': $nonChannel_l.attr('id')});

		asyncEachSeries_Original($lBody.find('tr[data-type=""]').toArray().reverse(), function(item, call){
			var $item=$(item).attr({'data-v0': $nonChannel_l.attr('id')}).addClass(dnCls+$nonChannel_l.attr('id')+'_level0');
			$item.find('div.dis_ib.mgleft1').css('margin-left', '33px');
			$nonChannel_r.after($rBody.find('tr:eq('+item.rowIndex+')').addClass(dnCls));
			$nonChannel_l.after($item);
		}, function(err){
			
			asyncEachSeries_Original($lBody.find('tr[data-type="channel"]').toArray(), function(item, call){
				var $this=$(item).attr({'data-v0': $channel_l.attr('id')}).addClass(dnCls+$channel_l.attr('id')+'_level0');
				$this.find('div.dis_ib.mgleft1').css('margin-left', '33px');
				$channel_r.after($rBody.find('tr:eq('+item.rowIndex+')').addClass(dnCls));
				$channel_l.after($this);
			}, function(err){
				
			}, 10);
			
		}, 10);
	}
}

;function register_event(){
	var $body_div = $('#div_body'), s='<img src="/s.gif" class="helpIcon" title="Forecasts Total for Current and Last Cycle."/> ';
	
	$body_div.find('#ltabid tr:first').removeClass('cp').find('div.mgleft').addClass('mgleft1').css({'font-weight': 'bold', 'margin-left': '32px'})
			.find('span.namecell').before(s).parent().parent().parent().find('div.mgleft1:first').remove();
			
	$body_div.find('#rCellScroll').off('scroll').scroll(event_rCellScroll);
	$body_div.find('#ltabid tr.cp').off('click').on('click', event_existData_click);
	$body_div.find('tbody.overbody tr').off('mouseenter mouseleave').on('mouseenter mouseleave', event_table_over);
//	$('#menuBtntd input').off('click').on('click', event_hideCalendar_click);
	$('#menuBtntd input').remove();
	$(document).on('mousedown', {'elDrop': document.getElementById('dropBoxId'), '$aBox': $('#forecastdiv_id')}, event_dorpBox_down);
	
	$(window).off('scroll').scroll(event_windowScroll).smartresize(event_windowReSize);
	$('#floatscroll').off('scroll').scroll(event_floatScroll);
}

;function checkingStatus(){
	if($('#ltabid span.wating').length == 0){	//checked access remote function.
		return false;
	}
	return true;
}

;function setTemplateElement(data){
	var csMonthCells={}, dcMonthCells={}, gapMonthCells={}, 
		$head=$('#tab_head_list td'), list_hidden_td=$head.filter('.dn').toArray();
	
	$('#tab_head_list td').each(function(){
		var $this=$(this), attr_date=this.getAttribute('data-date');
		if($this.hasClass('historicalcls')){
			csMonthCells[attr_date] = this.cellIndex;
		}
		if($this.hasClass('currentcls')){
			dcMonthCells[attr_date] = this.cellIndex;
		}
		if($this.hasClass('futurecls')){
			gapMonthCells[attr_date] = this.cellIndex;
		}
	});
	data['csMonthCells'] = csMonthCells;
	data['dcMonthCells'] = dcMonthCells;
	data['gapMonthCells'] = gapMonthCells;
	data['$left_template'] = $('#lefttemplate tr').clone();
	data['$right_template'] = $('#righttemplate tr').clone();
	
	switch(data['data-level']){
		case 'level2' :
			data['$left'] = data['$row'];
			data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');
			break;
		case 'level3' :
			data['$left'] = data['$row'];
			data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');
			break;
		case 'level4' :
			data['$left'] = data['$row'];
			data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');
			data['$left_template'].eq(0).removeClass('cp').find('span.fcell.mk').removeClass('mk').html('○');
			break;
	}
	
	
	data['$right_template'].each(function(){
		var $tds = $(this).find('td');
		for(var i=0, el; el=list_hidden_td[i]; i++){
			$tds.eq(el.cellIndex).addClass('dn');
		}
	});
	data['$left_template'].on('mouseenter mouseleave', event_table_over).filter('.cp')
						  .on('click', event_existData_click);
	data['$right_template'].on('mouseenter mouseleave', event_table_over);
	event_windowScroll();
}

;function appendElement_Level2(data, callBack, callBackEnd){

	var $lTemp=$('#lefttemplate tr:first').clone().removeAttr('class').attr({'data-level': 'level3_3'}),
		$rTemp=$('#righttemplate tr:first').clone(), all_total={};
	
	data['$right'].find('td.dn').each(function(){
		$rTemp.find('td:eq('+this.cellIndex+')').addClass('dn');
	});

	$lTemp.addClass('external nonchannel mark level3_3 cp dn').find('div.mgleft1').css({'margin-left': '58px'})
			.parent().find('span.namecell').html('Non - Channel');//.addClass('mgleft1').removeClass('mgleft2');

	$lTemp.addClass('level0').on('mouseenter mouseleave', event_table_over).filter('.cp').on('click', event_existData_click);
	$rTemp.addClass('rlevel0 dn').on('mouseenter mouseleave', event_table_over);
	
	var $lnonTemp=$lTemp.clone(true), $rnonTemp=$rTemp.clone(true);
	$lnonTemp.attr({'data-type': 'channel'}).removeClass('nonchannel').addClass('channel').find('span.namecell').html('Channel');
	
	
	async.sortBy(data['list_result'], function(item, callback) {
	    setTimeout(function() {
	        callback(null,(item['csFCamount']*-1));
	    }, 45);
	}, function(err,list_result) {
	    list_result.reverse();
		asyncEachSeries_Original(list_result, function(item, call){
			
			var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true),
				$lTClone=$lTemp.clone(true), $lTnonClone=$lnonTemp.clone(true),
				attr={'id': uuid.v4(), 'data-v1': data['data-v1'], 'data-v2': item['id'], 'data-region': data['region']};
			
			attr['data-v3']=attr['id'];
			$lClone.addClass( (data['data-v1']+'_level1 level2 '+item['id']+'_level2') ).eq(0)
					.attr({'id': item['id'], 'data-level': data['data-level'], 'data-v1': data['data-v1'], 'data-v2': item['id'],
							'data-type': item['type'], 'data-region': data['region']}).find('span.namecell').html(item['name']);
			$lClone.eq(0).find('div.dis_ib.mgleft1').css('margin-left', '34px');
			$rClone.addClass('rlevel2');
			
			setCellForecast(item['csFC'], data['csMonthCells'], $rClone.eq(0).find('td'), all_total);
			setCellForecast(item['dcFC'], data['dcMonthCells'], $rClone.eq(0).find('td'), all_total);
			setCellForecast(item['pmFC'], data['gapMonthCells'], $rClone.eq(0).find('td'), all_total);
			
			if(item['type'] == 'channel'){
				$lClone.removeClass('cp').off('click').find('span.fcell').html('○');
			}
			
			$lTClone.attr(attr).addClass( (data['data-v1']+'_level1 '+item['id']+'_level2 '+attr['id']+'_level3') );
			attr['id'] = uuid.v4();
			attr['data-v3']=attr['id'];
			$lTnonClone.attr(attr).addClass( (data['data-v1']+'_level1 '+item['id']+'_level2 '+attr['id']+'_level3') );
			
			data['$left'].after($lClone);
			data['$right'].after($rClone);
			
			$lClone.last().after($lTnonClone.clone(true));
			$rClone.last().after($rTemp.clone(true));
			
			$lClone.last().after($lTClone.clone(true));
			$rClone.last().after($rnonTemp.clone(true));
			
		}, function(err){
			
		//	for(var o in all_total){
		//		data['$right'].find('td:eq('+o+')').html( Globalize.format(all_total[o], DECIMAL_POINT['n0']) );
		//	}
			
			callBackEnd(callBack, data);
		}, 150);
	});
	
	
	;function setCellForecast(mapFC, monthCells, $t, all_total){
		for(var key in mapFC){
			$t.eq(monthCells[key]).html( Globalize.format(mapFC[key], DECIMAL_POINT['n0']) );
			all_total[monthCells[key]] = (getZeroOfNumber(all_total[monthCells[key]]) + mapFC[key]);
		}
	}
}

;function appendElement_Level3(data, callBack, callBackEnd){
	var o_total={};
	async.sortBy(data['list_result'], function(item, callback) {
	    setTimeout(function() {
	        callback(null,(item['csFCamount']*-1));
	    }, 45);
	}, function(err,list_result) {
		list_result.reverse();

		asyncEachSeries_Original(list_result, function(item, call){
			var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true);
			$lClone.addClass( (item['id']+'_level3 level3 '+data['data-v3']+'_level3_3 '+data['data-v2']+'_level2 '+data['data-v1']+'_level1') )
					.eq(0).attr({'id': item['id'], 'title': item['name'], 'data-number': item['accnumber'], 'data-level': data['data-level'], 
								 'data-v1': data['data-v1'], 'data-v2': data['data-v2'], 'data-v3': data['data-v3'], 'data-v4': item['id'], 'data-region': data['region']})
					.find('span.namecell').html(item['accnumber']+'-[ '+item['name']+' ]');
			
			$lClone.eq(0).find('div.dis_ib.mgleft1').css('margin-left', '82px');
			$rClone.addClass('rlevel3');
			setCellForecast(item['csFC'], data['csMonthCells'], $rClone.eq(0).find('td'), o_total);
			setCellForecast(item['dcFC'], data['dcMonthCells'], $rClone.eq(0).find('td'), o_total);
			setCellForecast(item['pmFC'], data['gapMonthCells'], $rClone.eq(0).find('td'), o_total);
			
			if(item['type'] == 'channel'){
				$lClone.attr({'data-type': 'channel'}).off('click').find('span.fcell').html('○');//.parent().find('span.pin').remove();
				$lClone.addClass('dn').find('span.namecell').html(item['name']);
				$rClone.addClass('dn');
			}else{
				$lClone.attr({'data-type': 'non-channel'}).find('span.namecell').html(item['name']+' ['+item['accnumber']+']');
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
			
			callBackEnd(callBack, data);
		}, 150);
	});
	
	
	;function setCellForecast(mapFC, monthCells, $t, o_total){
		for(var key in mapFC){
			var cellIdx=monthCells[key];
			$t.eq(cellIdx).html( Globalize.format(mapFC[key], DECIMAL_POINT['n0']) );
			o_total[cellIdx] = (getZeroOfNumber(o_total[cellIdx]) + mapFC[key]);
		}
	}
}
var lastElementleft;	
var lastElementright;	
var islastelement = 'true';
;function appendElement_Level4(data, callBack, callBackEnd){
	
	async.sortBy(data['list_result'], function(item, callback) {
	    setTimeout(function() {
	        callback(null,(item['csFCamount']*-1));
	    }, 45);
	}, function(err,list_results) {
	/* Padmaja: Added code for show more functionality REQ_00834   */
	 
		data['list_result']=[];		//clear list result
		//list_results.reverse();
		var list_topTen=list_results.splice(0,10);
		otherSoldTo={'csFC': {}, 'pmFC': {}, 'dcFC': {}},
		$lCloneother=data['$left_template'].clone(true), $rCloneother=data['$right_template'].clone(true);	
		list_topTen.reverse();
 		$lCloneother.find("span.pin").removeClass(" pin spin");
		$lCloneother.find("td.fieldwidth").css("display","none");
	
	
		//list_result.reverse();
		//Added 'title': item['name'] for REQ_00835 by Padmaja on 06/11/2015
		asyncEachSeries_Original(list_topTen, function(item, call){
			var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true);
			$lClone.addClass( (item['id']+'_level4 level4 '+data['data-v4']+'_level3 '+data['data-v3']+'_level3_3 '+data['data-v2']+'_level2 '+data['data-v1']+'_level1 ' ) )
					.eq(0).attr({'id': item['id'], 'title': item['name'], 'data-v1': data['data-v1'], 'data-v2': data['data-v2'], 'data-v3': data['data-v3'], 
								 'data-v4': data['data-v4'], 'data-v5': item['id'], 'data-level': 'level4', 'data-region': data['region']})
					.find('span.namecell').html(item['name']);
	
			$lClone.eq(0).find('div.dis_ib.mgleft1').css('margin-left', '106px');
			
			if(islastelement == 'true')
		{
			$rClone.addClass('lastElementright' + data['data-v3']);
			$lClone.addClass('lastElementleft' + data['data-v3']);
			islastelement = 'false';
		}
			
			
			$rClone.addClass('rlevel4');
			
			setCellForecast(item['csFC'], data['csMonthCells'], $rClone.eq(0).find('td'));
			setCellForecast(item['dcFC'], data['dcMonthCells'], $rClone.eq(0).find('td'));
			setCellForecast(item['pmFC'], data['gapMonthCells'], $rClone.eq(0).find('td'));
	
			data['$left'].after($lClone);
			data['$right'].after($rClone);
			
		}, function(err){
			callBackEnd(callBack, data);
		}, 150);
		
 		$lCloneother.find("div").removeClass("dis_ib mgleft1");
		$lCloneother.find("span.fcell").css("display","none");
		
		if(list_results.length > 0){
		var s = 'showlink'+data['data-v4'];
		
		$rCloneother.addClass('right'+s);	
		$lCloneother.addClass(('showmore_level4 level4 '+data['data-v4']+'_level3 '+data['data-v3']+'_level3_3 '+data['data-v2']+'_level2 '+data['data-v1']+'_level1  left' + s ) )			
				.find('span.namecell').append('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="#ShowMore">Show More</a>').click(function(e){
			    
				 //list_results.reverse();
				//newlist_topTen.push(list_results);
				var newlist_topTen=list_results.splice(0,10);
				//newlist_topTen.reverse();
			asyncEachSeries_Original( newlist_topTen, function(item, call){
		var $lClone1=data['$left_template'].clone(true), $rClone1=data['$right_template'].clone(true);
			$lClone1.addClass( (item['id']+'_level4 level4 '+data['data-v4']+'_level3 '+data['data-v3']+'_level3_3 '+data['data-v2']+'_level2 '+data['data-v1']+'_level1 ' ) )
					.eq(0).attr({'id': item['id'], 'title': item['name'], 'data-v1': data['data-v1'], 'data-v2': data['data-v2'], 'data-v3': data['data-v3'], 
								 'data-v4': data['data-v4'], 'data-v5': item['id'], 'data-level': 'level4', 'data-region': data['region']})
					.find('span.namecell').html(item['name']);
	
			$lClone1.eq(0).find('div.dis_ib.mgleft1').css('margin-left', '106px');
				
				
		$rClone1.addClass('rlevel4');
			
			setCellForecast(item['csFC'], data['csMonthCells'], $rClone1.eq(0).find('td'));
			setCellForecast(item['dcFC'], data['dcMonthCells'], $rClone1.eq(0).find('td'));
			setCellForecast(item['pmFC'], data['gapMonthCells'], $rClone1.eq(0).find('td'));
	  //      console.log("++++++++++++++"+data['$left']); 
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

	
	;function setCellForecast(mapFC, monthCells, $t){
		for(var key in mapFC){
			$t.eq(monthCells[key]).html( Globalize.format(mapFC[key], DECIMAL_POINT['n0']) );
		}
	}
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

;function event_tabStatus_over(e){
	var $this=$(this);
	eventHandle_ov_ot(e, ov, ot);
    ;function ov(e){ $this.addClass('overg'); }
    ;function ot(e){ $this.removeClass('overg').hide(); }
}


;function event_reloadExistData_click(e, $this){
	var _data = e.data.$data;
	rowIsLocked(_data['rowIndex']);
    customMultipleRemoteAction(_data, _data['action'], _data['complete']);
    $this.remove();
}



;function event_existData_click(e){
//	e.stopPropagation();
	var hide='dn', $right_trs=$('#rtabid tr'), _this=this, $this=$(_this), $leftBody=$this.parent(), 
    	$waiting=$this.find('td:first span.fcell'), $pin=$this.find('span.pin'), fn=($this.hasClass('exp')? exp : col),
    	config={'id': $this.attr('id'), 'data-level': $this.attr('data-level'), 'rowIndx': $this.index(), 'isRemote': false};

    $this.find('td:first span.reload_span').remove();
    if(rowIsLocked(config['rowIndx'])){ return false; }

    fn();
    
    ;function exp(){
    	if(isLoadedSubData()){
    		return false;
    	}
    	
    	var levelCls = '';
    	
    	switch(config['data-level']){
    		case 'level1' : 
    				levelCls='tr:not(.level1).'+config['id']+'_level1'; 
				break;
    		case 'level1_1' : 
    				levelCls='tr:not(.level0).'+$this.attr('data-v2')+'_level11.'+$this.attr('data-v1')+'_level1'; 
    			break;
    		case 'level2' : 
    				levelCls='tr:not(.level2).'+$this.attr('data-v2')+'_level2.'+$this.attr('data-v1')+'_level1'; 
    			break;
    		case 'level3_3' :
    				levelCls='tr:not(.level3_3).'+$this.attr('data-v3')+'_level3_3.'+$this.attr('data-v2')+'_level2.'+$this.attr('data-v1')+'_level1';
    			break;
    		case 'level3' :
    				levelCls='tr:not(.level3).'+$this.attr('data-v4')+'_level3.'+$this.attr('data-v3')+'_level3_3.'+$this.attr('data-v2')+'_level2.'+$this.attr('data-v1')+'_level1';
    			break;
    	}

    	QUEUE.push({name: config['rowIndx'], run: function(cb){
	        $leftBody.find(levelCls).addClass(hide).each(function(){
	        	var $this=$(this);
	            $right_trs.eq(this.rowIndex).addClass(hide).find('td');
	            $this.removeClass('exp col').first().addClass('col').find('td')
	            		.find('span.fcell').html('+').parent().find('span.pin, span.cpp').addClass('spin');
	            if(($this.attr('data-level') == 'level3' && $this.attr('data-type') == 'channel') && $this.attr('data-level') != 'level3_3'){
	            	$this.find('span.fcell').html('○');
	            }
	            if($this.attr('data-level') == 'level4'){
	            	$this.find('span.fcell').html('○');
	            }
	        });
	        rowUnLock(config['rowIndx']);
	        $this.removeClass('exp').addClass('col');
	        $waiting.html('+').removeClass('wating');
            cb(null);  
            
        }}, function(err){ });
    }
    
    ;function col(){
    	$waiting.addClass('wating').html('&nbsp;');
    	
    	var remote_fn={'remote':function(p){}, 'rowIndex': config['rowIndx'], '$row': $this, 'region': $this.attr('data-region'),
    					'data-v1': $this.attr('data-v1'), 'data-v2': $this.attr('data-v2'), 'data-v3': $this.attr('data-v3'), 'data-v4': $this.attr('data-v4'),
    					'action': existObject_js, 'complete': complete_existObject
    				  }, levelCls='';
    	
    	switch(config['data-level']){
    		case 'level1' : 
					remote_fn['data-level'] = 'level2';
					remote_fn['append'] = appendElement_Level2;
	    			levelCls='tr.level2.mark.'+config['id']+'_level1'; 
	    	//		levelCls = 'tr.level2.mark.'+remote_fn['data-v2']+'_level2.'+remote_fn['data-v1']+'_level1';
					remoteCheck(levelCls, remote_fn, ClsObjLevle2, WORK_CLS['level2']); 
				break;
			case 'level1_1' :	//this search sold to.
	    			remote_fn['data-level'] = 'level2';
					remote_fn['append'] = appendElement_Level2;
	    			levelCls = 'tr.level2.mark.'+remote_fn['data-v2']+'_level2.'+remote_fn['data-v1']+'_level1';
					remoteCheck(levelCls, remote_fn, ClsObjLevle2, WORK_CLS['level2']); 
				break;
    		case 'level2' : 	//this search channel. 
    				levelCls = 'tr.level3_3.mark.'+remote_fn['data-v2']+'_level2.'+remote_fn['data-v1']+'_level1';//+remote_fn['data-v0']+'_level0';
    				/*
    				remote_fn['data-level'] = 'level3';
    				remote_fn['append'] = appendElement_Level3;
    				levelCls = 'tr.level3.mark.'+remote_fn['data-v3']+'_level2.'+remote_fn['data-v2']+'_level11.'+remote_fn['data-v1']+'_level1';
    				remoteCheck(levelCls, remote_fn, ClsObjLevle3, WORK_CLS['level3']); 
    				*/
    			break;
			case 'level3_3' : 	//this search oem. 
					remote_fn['data-level'] = 'level3';
    				remote_fn['append'] = appendElement_Level3;
    				levelCls = 'tr.level3.mark.'+remote_fn['data-v3']+'_level3_3.'+remote_fn['data-v2']+'_level2.'+remote_fn['data-v1']+'_level1';
    				remoteCheck(levelCls, remote_fn, ClsObjLevle3, WORK_CLS['level3']); 
				break;
    		case 'level3' : 	//this search part. 
    				remote_fn['data-level'] = 'level4';
    				remote_fn['append'] = appendElement_Level4;
    				levelCls = 'tr.level4.mark.'+remote_fn['data-v4']+'_level3.'+remote_fn['data-v3']+'_level3_3.'+remote_fn['data-v2']+'_level2.'+remote_fn['data-v1']+'_level1';
    				remoteCheck(levelCls, remote_fn, ClsObjLevle4, WORK_CLS['level4']); 
    			break;
    		default : break;
    	} 
			
    	remote_fn['remote'](remote_fn);
    	expandElement(levelCls);
    }
    
    
    
    ;function remoteCheck(findCls, remoteFn, createJSON, actionClass){
    	if($this.hasClass('done')){ return; }
        config['isRemote'] = true;
        remoteFn['cls'] = actionClass;
        remoteFn['json'] = JSON.stringify( new createJSON(findCls) );
        remoteFn['remote'] = function(p){
        	customMultipleRemoteAction(p, remoteFn['action'], remoteFn['complete']); //this is remote action
        };
    }
    
    
    ;function ClsObjLevle2(){
    	ClsObjPrototype.apply(this, arguments);	//extends base object
    }
    ;function ClsObjLevle3(){
    	ClsObjLevle2.apply(this, arguments);	//extends base object
    	this['type'] = $this.attr('data-type');
    	this['oemId'] = $this.attr('data-v2');
    }
    ;function ClsObjLevle4(){
    	ClsObjLevle3.apply(this, arguments);	//extends base object
    	this['accnumber'] = $this.attr('data-number');
    }
    
    ;function ClsObjPrototype (){
    	this['region'] = $this.attr('data-region');
    	this['startDate'] = $('#hidd_start').val();
    	this['endDate'] = $('#hidd_end').val();
    	this['map_quarter_months'] = $.parseJSON($('#hiddquartermonths').val());
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
                    if($item.attr('data-level') == 'level3_3' && !$item.hasClass('done')){
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
/*
Object.prototype.JSONparse = function () {
	return JSON.parse(this.toString());
};
Object.prototype.JSONstringify = function () {
	return JSON.stringify(this);
};
*/