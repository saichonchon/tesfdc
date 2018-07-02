var TIMEOUT, scrollbarW=$.getScrollbarWidth(), STATIC_VAR={}, SAVE_PART=[], SAVE_ERRORS=[], _queueTask=async.queue(queueTask, 1),
	WORK_CLS={
		'level1': 'APL_ClsGAMService.SearchLevel1', 'level2': 'APL_ClsGAMService.SearchLevel2',
		'level3': 'APL_ClsGAMService.SearchLevel3', 'level4': 'APL_ClsGAMService.SearchLevel4',
		'level5': 'APL_ClsGAMService.SearchLevel5', 'level6': 'APL_ClsGAMService.SearchLevel6',
		'other':  'APL_ClsGAMService.SearchLevelOther'
	};

;function queueTask(task, callback) {
    task.run(callback);
}

;function initCtrlDocument(){
    Globalize.culture(this.locale).numberFormat.currency.symbol = "";
    var $r_trs=$('#rtabid tr'), $l_trs=$('#ltabid tr'), $head_trs=$('#tab_head_list td'), list_trs=$l_trs.filter('.rt0').toArray();
    
    asyncEachSeries_Original(list_trs, function(item, callback){
		var $this=$(item), $prevCycle=$this.next(), $amCycle=$prevCycle.next(),
    		params=createRegionTotalJson($r_trs.eq($this.index()), $r_trs.eq($prevCycle.index()), $r_trs.eq($amCycle.index()), $this, $head_trs);
    	$this.find('div:first').append('<span class="tcodefc waitingtcode"></span>');
    	customRemoteAction(params, searchAcctFC_js, complete_searchTotalCycleFC); //this is total remote action
    }, function(err){ list_trs=[]; }, 120);
    
    initDocument();
    
    
    ;function createRegionTotalJson($curentCycle, $prevCycle, $amCycle, $this, $head_trs){
		var q_month={}, q_months={}, q_Future={}, q_cell={}, m_cell={},
			_json={'className': $this.attr('data-interface-region'), 'str_json': '{}' }, 
			params={'$row': $this, '$currentCycle': $curentCycle, '$prevCycle':$prevCycle, '$amCycle': $amCycle, 'json': '{}', 
					'qFuture': q_Future, 'qMonth': q_month, 'qMonths':q_months, 'qCell': q_cell, 'mCell':m_cell};
		
		params['currentCell']=$head_trs.filter('.crtQtotal')[0].cellIndex+1;
		$head_trs.filter('.monthCls').each(function(){
			m_cell[this.getAttribute('data-month')]=this.cellIndex;
		});	

	    $head_trs.filter('.qtotalCls').each(function(){
	    	var $qCell=$(this), isFuture=$qCell.hasClass('futurec1'), list_month=$qCell.attr('data-months').split(','), q=$qCell.attr('data-date');
	    	q_cell[q]=this.cellIndex;
	    	q_months[list_month.join(',')]=this.cellIndex;
	    	q_month[q]=list_month;
	    	for(var i=0, _month; _month=list_month[i]; i++){
		    	q_Future[_month]=isFuture;
	    	}
	    });
	    var set_gamCode = $.parseJSON($('#hidd_gamcodes').val()), str_gamCode = "";
	    
	    while(set_gamCode.length > 0){
	    	str_gamCode += ('\"'+set_gamCode.shift()+'\",');
	    }
		str_gamCode = ( str_gamCode != '' ? str_gamCode.substring(0, str_gamCode.length-1) : str_gamCode);
        _json['str_json'] = '{"level2TerritoryCode": "'+$this.attr('data-tcode')+'", "refStartDate": "'+$('#hidd_start').val()+'", ' +
        					' "refEndDate": "'+$('#hidd_end').val()+'", "periodStartDate": "'+$('#hidd_periodsdid').val()+'", '+
        					' "map_year_monthsFuture": '+$('#hidd_mapfuture').val()+', "map_year_monthsHistory": '+$('#hidd_maphistory').val()+', '+
							' "set_gamCodes": \['+str_gamCode+']\, "map_year_quartersFuture": '+$('#hidd_yearfutureid').val()+'}';

    	params['json'] = JSON.stringify(_json);
    	return params;
	}
    
}

;function initDocument(){
    appendExpand_Collapse();
    registerGAM_event();
	$('#floatscroll').css({'height': scrollbarW, 'line-height': scrollbarW});
    fixAMTableLayout();
    finalFormat();
}

;function registerGAM_event(){
    var $body_div = $('#div_body');//,
    //	scroll_attr={'$ghb': $('#globalHeaderBar'), '$abh': $('#AppBodyHeader'), '$menu':$('#menudivid'), '$floathead': $('#headmainid')};

    $body_div.find('tbody.overbody tr').off('mouseenter mouseleave').on('mouseenter mouseleave', over_table_eve)
    		.find('span.pin').off('click').on('click', event_refAMData_click);  
    $body_div.find('#ltabid tr.trt_trt').off('click').on('click', clickLeftTableTotal_eve);
    
    $body_div.find('#rCellScroll').scroll(rCellScroll_eve);
    //         .find('#rtabid input[type="text"]').off('focus change').on('focus change', input_fc_eve)
    //         .off('keyup').on('keyup', input_keyup_eve);
    $body_div.find('#ltabid tr.cp').off('click').on('click', {$divbody: $body_div}, clickLeftTable_eve);
	$('#gototopid').off('mouseenter mouseleave click').on('mouseenter mouseleave click', clickGotoTop_event);
    $(window).scroll(scroll_event).smartresize(windowReSize);
    $('#menuBtntd input').off('click').on('click', event_hideAMCalendar_click);
    $('#floatscroll').off('scroll').scroll(event_floatScroll);
}

;function scroll_event(e){
	var x=(document.body.scrollTop||document.documentElement.scrollTop), $top=$('#gototopid');
	setTimeout(function(){
		
		var h=($(document).height() - $(window).height() - 120);
		if(x >= h){ $('#floatscroll').css({'visibility': 'hidden'}); }
		else{ $('#floatscroll').css({'visibility': ''}); }
		
		if(x<=30){$top.fadeOut().hide()}else{$top.fadeIn().show()};
		
		var $floatHead=$('#headmainid'),
			xx=($('#globalHeaderBar').outerHeight()+$('#AppBodyHeader').outerHeight()+$('#menudivid').outerHeight()+ $floatHead.outerHeight()+100);
		if((x > xx) && !$floatHead.hasClass('floatheadcls')){
			$floatHead.addClass('floatheadcls').find('td.tab_head_left ').addClass('leftbt');
		}else if(!(x > xx)){
			$floatHead.removeClass('floatheadcls').find('td.tab_head_left ').removeClass('leftbt');
		}
	}, 50);
}


;function closePopUP(target){
    $('#popupbox').stop().animate({'top':-800}, 800, function(){
        $('#popupmain').fadeOut('fast');
    });
}
;function input_fc_eve(e){
    
    var _this = this, $this = $(_this), ov = '', validation_qty=/^([1-9]\d{0,16}|0)(\.\d+)?$/,  
        point='n', tv = Globalize.parseFloat($.trim(_this.value)); //focus Event
    
    ov = $this.inputFocusValueFormat(validation_qty, e);

    if(e.type == 'change'){
    	/*
        if(!validation_qty.test(tv) || (tv==ov && ov!='')){ //not changed or old value eq new value
            $this.val ( $.isNumeric(ov) ? Globalize.format(ov, point) : '' ).focus().select();
            return;
        }
        */
		ov = ($.isNumeric(ov) ? ov : 0);
        tv = ($.isNumeric(tv) ? tv : 0);
        
        _this.value = Globalize.format(tv, point);
        
        var o_cfg = getTableInfo();
        
    	switch(_this.getAttribute('data-type')){
    		case 'pos':  break;
    		case 'cma': break;
    		case 'cbc2': cbcSum(o_cfg); break;
    		case 'gpl': gplSum(o_cfg); break;
    		case 'gplpart': gplPartSum(o_cfg); break;
    		case 'otherpart': otherPart(o_cfg); break;
    	}

    }
	
    ;function cbcSum(o_cfg){
		
    	if(o_cfg['$left_trs'].filter('.trt_trt').hasClass('exp')){
    		o_cfg['$left_trs'].filter('tr.trt_trt').addClass('col').removeClass('exp').find('span.fcell').html('+');
    		o_cfg['$left_trs'].filter('tr.trt_0:not(.trt_trt)').addClass('dn');
    		o_cfg['$right_trs'].filter('tr.trt_0:not(.trt_trt)').addClass('dn');
    	}
    	
    	var total=0, accCls='.rt1.'+o_cfg['regioncls']+'.'+o_cfg['aId'], cbcCls='.rt2.'+o_cfg['regioncls']+'.'+o_cfg['aId'],
    		accIndex=o_cfg['$left_trs'].filter(accCls).index(), $l_cbcRow=o_cfg['$left_trs'].filter(cbcCls),
    		$accCell=o_cfg['$right_trs'].eq(accIndex).find('td:eq('+o_cfg['cellIndex']+')');
		
    	$l_cbcRow.each(function(){
    		var $td=o_cfg['$right_trs'].eq(this.rowIndex).find('td:eq('+o_cfg['cellIndex']+')'),
				$input=$td.find('input'), v=numberOfZero( $.trim($this.text()) );
				
    		if($input.length != 0){ v=numberOfZero( $.trim($input.val()) ); }
    		total+=v;
    	});	
    	$accCell.html(Globalize.format(total, 'n'));
		sumOfRegionTotal(o_cfg);
    }
    
    ;function gplSum(o_cfg){
    	
    	if(o_cfg['$left_trs'].filter('.trt_trt').hasClass('exp')){
    		o_cfg['$left_trs'].filter('tr.trt_trt').addClass('col').removeClass('exp').find('span.fcell').html('+');
    		o_cfg['$left_trs'].filter('tr.trt_0:not(.trt_trt)').addClass('dn');
    		o_cfg['$right_trs'].filter('tr.trt_0:not(.trt_trt)').addClass('dn');
    	}
    	
    	var cbcRowIndex=o_cfg['$left_trs'].filter( ('.rt2.'+o_cfg['aId']+'.'+o_cfg['regioncls']+'.'+o_cfg['cbc2num']) ).index(),
    		accRowIndex=o_cfg['$left_trs'].filter( ('.rt1.'+o_cfg['aId']+'.'+o_cfg['regioncls']) ).index(),
    		$cbcCell=o_cfg['$right_trs'].eq(cbcRowIndex).find('td:eq('+o_cfg['cellIndex']+')').find('input'), 
    		$accCell=o_cfg['$right_trs'].eq(accRowIndex).find('td:eq('+o_cfg['cellIndex']+')'),
    		gpl_total=0, cbc_total=0, part_total=0;

    	o_cfg['$left_trs'].filter('.rt4.'+o_cfg['regioncls']+'.'+o_cfg['aId']+'.'+o_cfg['cbc2num']+'.'+o_cfg['gid']+'_gpl').each(function(){
    		var v = o_cfg['$right_trs'].eq(this.rowIndex).find('td:eq('+o_cfg['cellIndex']+')').find('input').val();
    		part_total += numberOfZero($.trim(v));
    	});

    	if(tv < part_total){
    		$this.val( Globalize.format(part_total, 'n') );
    		return;
    	}
    	
    	o_cfg['$left_trs'].filter( ('.rt3.'+o_cfg['aId']+'.'+o_cfg['regioncls']+'.'+o_cfg['cbc2num']) ).each(function(){
    		var v = o_cfg['$right_trs'].eq(this.rowIndex).find('td:eq('+o_cfg['cellIndex']+')').find('input').val();
    		gpl_total += numberOfZero($.trim(v));
    	});
    	$cbcCell.val(Globalize.format(gpl_total, 'n'));
    	
    	o_cfg['$left_trs'].filter( ('.rt2.'+o_cfg['aId']+'.'+o_cfg['regioncls']) ).each(function(){
    		var v = o_cfg['$right_trs'].eq(this.rowIndex).find('td:eq('+o_cfg['cellIndex']+')').find('input').val();
    		cbc_total += numberOfZero($.trim(v));
    	});
    	$accCell.html(Globalize.format(cbc_total, 'n'));
		sumOfRegionTotal(o_cfg);
    }
    
    ;function gplPartSum(o_cfg){
    	var _cls=(o_cfg['aId']+'.'+o_cfg['regioncls']+'.'+o_cfg['cbc2num']+'.'+o_cfg['$ltr'].attr('data-gid')+'_gpl'),
    		$gplRow=o_cfg['$left_trs'].filter( ('.rt3.'+_cls) ),
			$gplCell=o_cfg['$right_trs'].eq($gplRow.index()).find('td:eq('+o_cfg['cellIndex']+')').find('input'),
    		gplVal=numberOfZero($.trim($gplCell.val())), part_total=0;
    	
    	o_cfg['$left_trs'].filter( ('.rt4.'+_cls) ).each(function(){
    		var t = $.trim( o_cfg['$right_trs'].eq(this.rowIndex).find('td:eq('+o_cfg['cellIndex']+') input').val() );
    		part_total += numberOfZero(t);
    	});	
    	
    	if(part_total > gplVal){
            $this.val ( Globalize.format(ov, 'n') ).focus().select();
        }
    }
    
    ;function otherPart(o_cfg){
    	var _cls=(o_cfg['aId']+'.'+o_cfg['regioncls']+'.'+o_cfg['cbc2num']),
    		$otherRow=o_cfg['$left_trs'].filter( ('.rt2.'+_cls) ), $actRow=o_cfg['$left_trs'].filter( ('.rt1.'+o_cfg['aId']+'.'+o_cfg['regioncls']) ),
			$otherCell=o_cfg['$right_trs'].eq($otherRow.index()).find('td:eq('+o_cfg['cellIndex']+')').find('input'),
    		$actCell=o_cfg['$right_trs'].eq($actRow.index()).find('td:eq('+o_cfg['cellIndex']+')'),
    		actVal=numberOfZero($.trim($actCell.text())), otherVal=numberOfZero($.trim($otherCell.val())), part_total=0;
    	
    	o_cfg['$left_trs'].filter( ('.rt4.'+_cls) ).each(function(){
    		var t = $.trim( o_cfg['$right_trs'].eq(this.rowIndex).find('td:eq('+o_cfg['cellIndex']+') input').val() );
    		part_total += numberOfZero(t);
    	});
    	
    	$otherCell.val( Globalize.format(part_total, 'n') );
    	$actCell.html( Globalize.format((actVal-otherVal+part_total), 'n') );

    }
    
    ;function getTableInfo(){
    	var o = { '$input' : $this, '$rtd' : $this.parent(), '$left_trs': $('#ltabid tr') };
    	o['$rtr'] = o['$rtd'].parent();
    	o['$right_trs'] = o['$rtr'].parent().find('tr');
    	o['$ltr'] = o['$left_trs'].eq(o['$rtr'].index());
    	o['cellIndex'] = o['$rtd'].index();
    	o['regioncls'] = o['$ltr'].attr('data-regioncls');
    	o['aId'] = o['$ltr'].attr('data-aid');
    	o['cbc2num'] = o['$ltr'].attr('data-cbc-num');
    	o['gid'] = o['$ltr'].attr('data-gid');
    	return o;
    }
    
    ;function sumOfRegionTotal(o_cfg){
    	var total = 0, idx = o_cfg['$left_trs'].filter( ('.rt0.'+o_cfg['regioncls']) ).index();
    	o_cfg['$left_trs'].filter( ('.rt1.'+o_cfg['regioncls']) ).each(function(){
    		var v = numberOfZero(o_cfg['$right_trs'].eq(this.rowIndex).find('td:eq('+o_cfg['cellIndex']+')').text());
    		total += v;
    	});
    	o_cfg['$right_trs'].eq(idx).find('td:eq('+o_cfg['cellIndex']+')').html( Globalize.format(total, 'n') );
    }
    
}

;function input_keyup_eve(e){

    if(e.shiftKey && e.keyCode == 13){  //find prve cell input
    	var $this=$(this), $td=$this.parent();
    	$td.prev().find('input[type="text"]').focus().select();
     //   $tbody.find('tr:lt('+_rowIndex+'):not(.dn)')
     //       .find('td:eq('+_cellIndex+'):has(input)').last().find('input[type="text"]').focus().select();
    }else if(e.keyCode == 13){  //find next cell input
    	var $this=$(this), $td=$this.parent();
    	$td.next().find('input[type="text"]').focus().select();
      //  $tbody.find('tr:gt('+_rowIndex+'):not(.dn)')
      //      .find('td:eq('+_cellIndex+'):has(input)').first().find('input[type="text"]').focus().select();
    }
}


;function rowUnLock(_rowIndex){  //unlocked current row Repeat click event
    setTimeout(function(){ delete STATIC_VAR[_rowIndex]; }, 45);    //unlocked
}
;function rowIsLocked(_rowIndex){    //locked current row Repeat click event
    if(STATIC_VAR.hasOwnProperty(_rowIndex)){ return true; }    //locked 
    STATIC_VAR[_rowIndex] = '';
    return false;
}

;function clickGotoTop_event(e){
	var $this = $(this), overcls = 'over';
	;function ov(e){$this.addClass(overcls);}
	;function ot(e){$this.removeClass(overcls);}
	;function ck(e){$('html,body').animate({scrollTop: 0}, 450);}
	eventHandle(e, ov, ot, ck);
}

;function clickLeftPin_eve(e){
	e.stopPropagation();
	var _this=this, $this=$(_this), $td=$this.parent().parent(), $tr=$td.parent(), $body=$tr.parent(), $right_trs=$('#rtabid tr'),
		aId=$tr.attr('data-aid'), rt=$tr.attr('data-root'), regionCls=$tr.attr('data-regioncls'), 
		cbcNum=$tr.attr('data-cbc-num'), gplId=$tr.attr('data-gid'), cls='';
	
	if($this.hasClass('readypin')){
		return false;
	}
	
	switch(rt){
		case 'root0': cls = 'tr.rgsub.'+regionCls; break;
		case 'root1': cls = 'tr.asub.'+aId+'.'+regionCls; break;
		case 'root2': cls = 'tr.cbcsub.'+aId+'.'+regionCls+'.'+cbcNum; break;
		case 'root3': cls = 'tr.gplsub.'+aId+'.'+regionCls+'.'+cbcNum+'.'+gplId+'_gpl'; break;
	}
	
	if(!$this.hasClass('donepin') && $this.hasClass('spin')){
		$this.addClass('readypin waitingpin');
		switch(rt){
			case 'root0': 
				var p = createRegionTotalJson($body.find(cls));
				customRemoteAction(p, getGAMRefData, complete_GAMRefTotalFC); //this is total remote action
				break;
			default: 
				var interFaceName= '';
				switch(rt){
					case 'root1': interFaceName=$body.find('tr.rt0.'+regionCls).attr('data-interface'); break;
					case 'root2': interFaceName=$body.find('tr.rt1.'+regionCls).attr('data-interface'); break;
					case 'root3': interFaceName=$body.find('tr.rt2.'+regionCls+'.'+aId).attr('data-interface'); break;
				}
				createRefDataRemote($body.find(cls), interFaceName); 
				break;
		}
	}
	
	
	if(!$this.hasClass('spin')){
		$this.addClass('spin');
		$body.find(cls).addClass('dn').each(function(){
			$right_trs.eq(this.rowIndex).addClass('dn');
		});
		return;
	}
	
	$this.removeClass('spin');
	$body.find(cls).removeClass('dn').each(function(){
		$right_trs.eq(this.rowIndex).removeClass('dn');
	});
	
	;function createRefDataRemote($totalRows, interFaceName){
		var q_month={}, q_months={}, q_Future={}, q_cell={}, m_cell={}, $head_trs=$('#tab_head_list td'),
			_json={ "acctId": aId, "currentYear": $('#hidd_cyear').val(), "currentMonth": $('#hidd_cmonth').val(), 
					"cbcCode": $tr.attr('data-code'), "gplId": $tr.attr('data-gid'), "list_dateKey": []
				  }, 
			params={'$totalRow': $totalRows, '$rRow':$right_trs, '$tr': $tr, '$td': $td, '$pin': $this, 'json': '{}', 
					'qFuture': q_Future, 'qMonth': q_month, 'qMonths':q_months, 'qCell': q_cell, 'mCell':m_cell};
		
		params['currentCell']=$head_trs.filter('.crtQtotal')[0].cellIndex+1;
		$head_trs.filter('.monthCls').each(function(){
			m_cell[this.getAttribute('data-month')]=this.cellIndex;
		});	
		
		var th='',td='';
	    $head_trs.filter('.qtotalCls').each(function(){
	    	var $qCell=$(this), isFuture=$qCell.hasClass('futurec1'), q=$qCell.attr('data-date'),
	    		list_month=$qCell.attr('data-months').split(','), new_params=$.extend({}, params),
	    		new_json=$.extend({}, _json);
	    		
	    	q_month[q]=list_month;
	    	q_cell[q]=this.cellIndex;
	    	q_months[list_month.join(',')]=this.cellIndex;
	    	for(var i=0, _month; _month=list_month[i]; i++){
		    	q_Future[_month]=isFuture;
	    	}
	    	
	    	new_json['list_dateKey']=list_month;
	    	
			new_params['root']=rt;
			new_params['quarterCell']=this.cellIndex;
			new_params['sMonths']=list_month.join(',');
			new_params['action']=getGAMRefData;
			new_params['complete']=complete_getGAMRefData;
			
			new_params['json']='{\"className\":\"'+interFaceName+'\", \"str_json\": '+JSON.stringify(JSON.stringify(new_json))+' }';

			customRemoteAction(new_params, getGAMRefData, complete_getGAMRefData); //this is remote action

			th += '<td class="ref_head" style="text-align: center;">'+$qCell.find('span').text()+'</td>';
			td += '<td class="smonths" data-status="false" data-months="'+list_month.join(',')+'" style="text-align: center;"><div class="refstatus str"></div></td>';
	    });
		$td.append('<div class="refs_d"><table class="pinstatus" border="0" cellspacing="0" cellpadding="0" ><tr class="shead">'+th+'</tr><tr class="sbody">'+td+'</tr></table></div>')
		   .find('div.refs_d').off('mouseenter mouseleave').on('mouseenter mouseleave', over_refStatus_eve);
		$this.off('mouseenter mouseleave').on('mouseenter mouseleave', over_pinRefStatus_eve);
	}

	;function createRegionTotalJson($totalRows){
		var q_month={}, q_months={}, q_Future={}, q_cell={}, m_cell={}, $head_trs=$('#tab_head_list td'), 
			_json={'className': $tr.attr('data-interface-region'), 'str_json': '{}' }, 
			params={'$totalRow': $totalRows, '$rRow':$right_trs, '$row': $tr, '$pin': $this, 'json': '{}', 
					'qFuture': q_Future, 'qMonth': q_month, 'qMonths':q_months, 'qCell': q_cell, 'mCell':m_cell};
		
		params['currentCell']=$head_trs.filter('.crtQtotal')[0].cellIndex+1;
		$head_trs.filter('.monthCls').each(function(){
			m_cell[this.getAttribute('data-month')]=this.cellIndex;
		});	
			
	    $head_trs.filter('.qtotalCls').each(function(){
	    	var $qCell=$(this), isFuture=$qCell.hasClass('futurec1'), list_month=$qCell.attr('data-months').split(','), q=$qCell.attr('data-date');
	    	q_cell[q]=this.cellIndex;
	    	q_months[list_month.join(',')]=this.cellIndex;
	    	q_month[q]=list_month;
	    	for(var i=0, _month; _month=list_month[i]; i++){
		    	q_Future[_month]=isFuture;
	    	}
	    });
		var set_gamCode = $.parseJSON($('#hidd_gamcodes').val()), str_gamCode = "";
	    
	    while(set_gamCode.length > 0){
	    	str_gamCode += ('\"'+set_gamCode.shift()+'\",');
	    }
	    str_gamCode = ( str_gamCode != '' ? str_gamCode.substring(0, str_gamCode.length-1) : str_gamCode);
        _json['str_json'] = '{"level2TerritoryCode": "'+$tr.attr('data-tcode')+'", "refStartDate": "'+$('#hidd_start').val()+'", ' +
        					' "currentYear": "'+$('#hidd_cyear').val()+'", "currentMonth": "'+$('#hidd_cmonth').val()+'", '+
        					' "refEndDate": "'+$('#hidd_end').val()+'", "periodStartDate": "'+$('#hidd_periodsdid').val()+'", '+
        					' "map_year_monthsFuture": '+$('#hidd_mapfuture').val()+', "map_year_monthsHistory": '+$('#hidd_maphistory').val()+', '+
							' "set_gamCodes": \['+str_gamCode+']\, "map_year_quartersFuture": '+$.trim($('[id*=hidd_yearfutureid]').val())+'}';

    	params['json'] = JSON.stringify(_json);
    	return params;
	}
	
}

;function clickLeftTableTotal_eve(e){
	var hide='dn', _this=this, $this=$(this), o_cfg={'rowIdx':_this.rowIndex},
		$l_trs=$this.parent().find('tr'), $r_trs=$('#rtabid tr'), fn=($this.hasClass('exp')? exp : col);

	if($('#ltabid span.tcodefc').length != 0){ return false; }
	if(rowIsLocked(o_cfg['rowIdx'])){ return false; }

	fn();
	
	;function exp(){
		$l_trs.filter('.trt_0:not(.trt_trt)').addClass(hide);
		$r_trs.filter('.trt_0:not(.trt_trt)').addClass(hide);
        rowUnLock(o_cfg['rowIdx']);
        $this.removeClass('exp').addClass('col').find('span.fcell').html('+');
	}
	
	;function col(){
		var qCell=$('#tab_head_list td.crtQtotal')[0].cellIndex-1, cell_total={}, $ttCell=$r_trs.filter('.fctotal').find('td'),
			$tCell=$r_trs.filter('.tcfctotal').find('td'), $rCell=$r_trs.filter('.relayfctotal').find('td');
		$l_trs.filter('.rt0').each(function(){
			$r_trs.eq(this.rowIndex).find('td:gt('+qCell+')').each(function(){
				var total=getZeroOfNumber(cell_total[this.cellIndex]), v=numberOfZero($.trim(this.innerHTML));
				cell_total[this.cellIndex] = (total+v);
			});
		});
		
		for(var cell in cell_total){
			var v=numberOfZero( $.trim($rCell.eq(cell).html()) ), aTotal=(cell_total[cell]);
			$ttCell.eq(cell).html( Globalize.format(aTotal, 'n') );
			$tCell.eq(cell).html( Globalize.format((aTotal-v), 'n') );
		}
		
		$l_trs.filter('.trt_0:not(.trt_trt)').removeClass(hide);
		$r_trs.filter('.trt_0:not(.trt_trt)').removeClass(hide);
        rowUnLock(o_cfg['rowIdx']);
        $this.removeClass('col').addClass('exp').find('span.fcell').html('-');
	}
}

;function clickLeftTable_eve(e){
    
    var hide = 'dn', list_element = [], $right_list_trs=e.data.$divbody.find('#rtabid tr'), _this = this, $this=$(_this),
    	$parent=$this.parent(), $waiting = $this.find('td:first span.fcell'), $pin=$this.find('span.pin'),
    	o_cfg = {'rowIdx': _this.rowIndex, 'root': _this.getAttribute('data-root'), 'isRemote':false, 'o_cell': undefined}, 
        fn = ($this.hasClass('exp')? exp : col);

    $this.find('td:first span.reload_span').remove();
    if($this.find('td:first input[type="button"].delpartbtn').hasClass('disabled_btn')){ return false; }
    if($this.hasClass('ready')){ return false; }
	
    fn();
    
    ;function exp(){
    	
    	if(isLockedData()){
    		return false;
    	}
    	
    	var region_cls= 'tr.'+_this.getAttribute('data-regioncls'), tabcls='';
    	switch(o_cfg['root']){
    		case 'root0' : 
    				region_cls+=':not(.rgsub):not(.rt0)'; 
    				tabcls='a_bg c_bg g_bg p_bg';
    			break;
            case 'root1' : 
            		region_cls = 'tr:not(.asub):not(.rt1).'+_this.getAttribute('data-aid'); 
            		$this.find('td').removeClass('a_bg');
    				$right_list_trs.eq(o_cfg['rowIdx']).find('td').removeClass('a_bg');
    				tabcls='c_bg g_bg p_bg';
            	break;
            case 'root2' : 
            		region_cls = 'tr:not(.cbcsub):not(.rt2).'+_this.getAttribute('data-aid')+'.'+_this.getAttribute('data-cbc-num'); 
        			$this.find('td').removeClass('c_bg');
    				$right_list_trs.eq(o_cfg['rowIdx']).find('td').removeClass('c_bg');
    				tabcls='g_bg p_bg';
        		break;
            case 'root3' : 
            		region_cls = 'tr:not(.gplsub):not(.rt3).'+_this.getAttribute('data-aid')+'.'+_this.getAttribute('data-cbc-num')+'.'+_this.getAttribute('data-gid')+'_gpl'; 
        			$this.find('td').removeClass('g_bg');
    				$right_list_trs.eq(o_cfg['rowIdx']).find('td').removeClass('g_bg');
        			tabcls='p_bg';
        		break;
            case 'root44' :
            	region_cls='tr:not(.rt33):not(.productcodesub).'+$this.attr('data-v1')+'.'+$this.attr('data-v2')+'.'+$this.attr('data-v3')+'.'+$this.attr('data-v4')+'_gpl.'+$this.attr('data-v5'); 
            	$this.find('td').removeClass('p_bg');
				$right_list_trs.eq(o_cfg['rowIdx']).find('td').removeClass('p_bg');
            	break;
            case 'root4' : 
            	region_cls = 'tr:not(.rt4).'+_this.getAttribute('data-aid')+'.'+_this.getAttribute('data-cbc-num')+'.'+_this.getAttribute('data-pid')+'_part'; 
            	region_cls += ( _this.getAttribute('data-code') == 'Others' ? '' : ('.'+_this.getAttribute('data-gid')+'_gpl') );
            	$this.find('td').removeClass('p_bg');
				$right_list_trs.eq(o_cfg['rowIdx']).find('td').removeClass('p_bg');
            	break;
    	}

    	_queueTask.push({name: o_cfg['rowIdx'], run: function(cb){
	        $parent.find(region_cls).addClass(hide).each(function(){
	        	var $tRow=$(this);
	            $right_list_trs.eq(this.rowIndex).addClass(hide).find('td').removeClass(tabcls);
	            $tRow.removeClass('exp col').addClass('col').find('td').removeClass(tabcls)
	            		.find('span.fcell').html('+').parent().find('span.pin').addClass('spin');
        		if($tRow.hasClass('rt110') || $tRow.hasClass('rt4')){
					$tRow.find('span.pin').addClass('spin');
				}
	        });
	        rowUnLock(o_cfg['rowIdx']);
	        $this.removeClass('exp').addClass('col');
	        $waiting.html('+').removeClass('waiting');
            cb(null);
        }}, function(err){ });
    }
    
    ;function col(){
    	if(!isLoadedData()){
    		return;
    	}
    	$waiting.addClass('waiting').html('&nbsp;');
    	
    	var regionCls=_this.getAttribute('data-regioncls'), aId=_this.getAttribute('data-aid'),
    		region_cls='tr.'+regionCls, 
    		remote_fn={'params':{}, 'remote':function(p){}, '$row': $this, 'data-aid': $this.attr('data-aid'), 'root': o_cfg['root'],
    			'data-region': $this.attr('data-region'), 'data-cbc': $this.attr('data-code'), 'data-cbc-num': $this.attr('data-cbc-num'),
    			'data-accnumber': $this.attr('data-accnumber'), 'data-gid': $this.attr('data-gid'), 'rowIndex': o_cfg['rowIdx'], 
    			'data-v1': $this.attr('data-regioncls'), 'data-v2': $this.attr('data-aid'), 'data-v3': $this.attr('data-cbc-num'),
    			'data-v4': $this.attr('data-v4'), 'data-gid': $this.attr('data-gid'), 
    			'action': existAPLsObject_js, 'complete': complete_existObject
    		};

    	switch(o_cfg['root']){
    		case 'root0' :  //find account rows
    			region_cls += '.rt1'; 
    			check_forecast(region_cls, remote_fn, createAcct_json, searchAcctFC_js, complete_searchAcctFC);
    			break;
            case 'root1' : 	//find cbc2 rows
            	region_cls = ('tr:not(.asub):not(.partsub):not(.gplsub):not(.cbcsub).rt2.'+aId);
    			check_forecast(region_cls, remote_fn, createCbc_json, searchAcctFC_js, complete_searchCBC2FC);
            	break;
            case 'root2' : 	//find gpl rows
            	if(remote_fn['data-cbc'] == 'Others'){
            		region_cls='tr:not(.cbcsub).rt110.'+regionCls+'.'+aId+'.'+remote_fn['data-cbc-num'];
            		remote_fn['append'] = appendElementOther_level3;
            		remoteCheck(region_cls, remote_fn, createOtherJSON, WORK_CLS['other']);
            	}else if(remote_fn['data-cbc'] == 'Relay'){
            		region_cls='tr:not(.cbcsub):not(.partsub):not(.productcodesub):not(.rt33):not(.gplsub).'+regionCls+'.'+aId+'.'+remote_fn['data-cbc-num'];
            		remote_fn['append'] = appendElementRelay_level3;
            		remoteCheck(region_cls, remote_fn, createRelayJSON, WORK_CLS['level4']);
    			}else{
	            	region_cls = 'tr:not(.cbcsub):not(.partsub):not(.productcodesub):not(.rt33):not(.gplsub).'+aId+'.'+_this.getAttribute('data-cbc-num')+'.'+regionCls;
	    			region_cls += (_this.getAttribute('data-code') == 'Others' ? '' : ':not(.rt4)');
	    			check_forecast(region_cls, remote_fn, createGpl_json, searchAcctFC_js, complete_searchGPLFC);
            	}
            	break;
            case 'root3' : 	//find part rows
            	if(remote_fn['data-cbc'] == 'Relay'){
            		remote_fn['data-v4']=remote_fn['data-gid'];
					region_cls=( 'tr.rt33.'+remote_fn['data-v1']+'.'+remote_fn['data-v2']+'.'+remote_fn['data-v3']+'.'+remote_fn['data-v4']+'_gpl' );
    				remote_fn['append'] = appendElementProduct_level4;
					remoteCheck(region_cls, remote_fn, createProductCodeJSON, WORK_CLS['level5']);
    			}else{
	            	region_cls = 'tr:not(.gplsub):not(.partsub):not(.rt3).'+aId+'.'+_this.getAttribute('data-cbc-num')+'.'+_this.getAttribute('data-gid')+'_gpl.'+regionCls;
	            	region_cls += ', tr.rt4.'+aId+'.'+_this.getAttribute('data-cbc-num')+'.'+_this.getAttribute('data-gid')+'_gpl.'+regionCls;
	    			check_forecast(region_cls, remote_fn, createPart_json, searchAcctFC_js, complete_searchPartFC);
    			}
            	break;
            case 'root44' : 
    				remote_fn['data-v1']=$this.attr('data-v1');
    				remote_fn['data-v2']=$this.attr('data-v2');
    				remote_fn['data-v3']=$this.attr('data-v3');
    				remote_fn['data-v4']=$this.attr('data-v4');
    				remote_fn['data-v5']=$this.attr('data-v5');
            		region_cls=('tr.rt4.'+remote_fn['data-v1']+'.'+remote_fn['data-v2']+'.'+remote_fn['data-v3']+'.'+remote_fn['data-v4']+'_gpl.'+remote_fn['data-v5']);
    				remote_fn['append'] = appendElementPart_level5;
					remoteCheck(region_cls, remote_fn, createPartJSON, WORK_CLS['level6']);
            	break;
            case 'root4' : 	//show part rows
            	region_cls = 'tr.partsub.'+aId+'.'+_this.getAttribute('data-cbc-num')+'.'+_this.getAttribute('data-pid')+'_part';
            	region_cls += ( _this.getAttribute('data-code') == 'Others' ? '' : ('.'+_this.getAttribute('data-gid')+'_gpl') );
            	o_cfg['isRemote'] = false;
            	break;
    	}

    	if((remote_fn['root'] == 'root2' && (remote_fn['data-cbc'] == 'Others' || remote_fn['data-cbc'] == 'Relay')) ||
    		(remote_fn['root'] == 'root3' && remote_fn['data-cbc'] == 'Relay') || remote_fn['root'] == 'root44'){
    		remote_fn['remote'](remote_fn);
    	}else{
			remote_fn['remote'](remote_fn['params']);
    	}
		expandElement(region_cls);	
		setColTabBgColor();
    }
    
    ;function check_forecast(acct_cls, remote_fun, createJson,remoteAction, completeRemoteAction){
    	if($this.hasClass('ready') || $this.hasClass('done')){ return; }
        $this.addClass('ready');
        o_cfg['isRemote'] = true;
        remote_fun['params'] = createJson(acct_cls);
        remote_fun['remote'] = function(p){
        	customRemoteAction(p, remoteAction, completeRemoteAction); //this is remote action
        };
    }
	;function remoteCheck(findCls, remoteFn, createJSON, actionClass){
    	if($this.hasClass('ready') || $this.hasClass('done')){ return; }
        $this.addClass('ready');
        o_cfg['isRemote'] = true;
        remoteFn['cls'] = actionClass;
        remoteFn['json'] = JSON.stringify( new createJSON() );
        remoteFn['remote'] = function(p){
        	customMultipleRemoteAction(p, remoteFn['action'], remoteFn['complete']); //this is remote action
        };
    }
    ;function createOtherJSON(){
		this['soldtoId']=$this.attr('data-aid');
		this['map_year_quartersFuture']=$.parseJSON($('[id*=hidd_yearfutureid]').val());
    }
    ;function createRelayJSON(){
		this['soldtoId']=$this.attr('data-aid');
		this['map_year_quartersFuture']=$.parseJSON($('[id*=hidd_yearfutureid]').val());
    }
    ;function createProductCodeJSON(){
    	this['soldtoId']=$this.attr('data-aid');
    	this['cbc2Code']=$this.attr('data-gid');
    	this['map_year_quartersFuture']=$.parseJSON($('[id*=hidd_yearfutureid]').val());
    }
    ;function createPartJSON(){
    	this['soldtoId']=$this.attr('data-v2');
    	this['cbc2Code']=$this.attr('data-v4');
    	this['accnumber']=$this.attr('data-accnumber');
    	this['map_year_quartersFuture']=$.parseJSON($('[id*=hidd_yearfutureid]').val());
    }
    ;function createAcct_json(acct_cls){
    	var _json = { 'className': _this.getAttribute('data-interface'), 'str_json': '{}' }, q_cell={}, list_ids = [],
			params={'$acctRow': $parent.find(acct_cls), 'region':_this.getAttribute('data-regioncls'), '$row':$this, 'rowIndex':o_cfg['rowIdx'], 'json': '{}', 'q_cell': q_cell};
			
    	list_element = params['$acctRow'].toArray();
        while(list_element.length > 0){
            var _tr = list_element.shift(), aId=('\"'+_tr.getAttribute('data-aid')+'\"');
            list_ids.push(aId);
        }
        _json['str_json'] = '{"set_acctIds": ['+list_ids.join(',')+'], "quarterNumb": "'+$.trim($('[id*=hidd_quarternumbid]').val())+'", ' +
        					' "refStartDate": "'+$('#hidd_start').val()+'", "refEndDate": "'+$('#hidd_end').val()+'", "periodStartDate": "'+$('#hidd_periodsdid').val()+'", '+
        					' "map_year_monthsFuture": '+$('#hidd_mapfuture').val()+', "map_year_monthsHistory": '+$('#hidd_maphistory').val()+', '+
							' "map_year_quartersFuture": '+$.trim($('[id*=hidd_yearfutureid]').val())+'}';
    	params['json'] = JSON.stringify(_json);
    	setForecastCellIndex(q_cell, params);
    	return params;
    }
    ;function createCbc_json(acct_cls){
    	var aId = _this.getAttribute('data-aid'),
    		_json = { 'className': _this.getAttribute('data-interface'), 'str_json': '{}' }, q_cell={}, map_cbc={},
			params={'$cbcRows': $parent.find(acct_cls).filter('.rt2'), 'region':_this.getAttribute('data-regioncls'), 'aId': aId, '$row':$this, 'rowIndex':o_cfg['rowIdx'], 'json': '{}', 'q_cell': q_cell};
			
    	list_element = params['$cbcRows'].toArray();
        while(list_element.length > 0){
            var _tr = list_element.shift();
            map_cbc[_tr.getAttribute('data-code')] = _tr.getAttribute('data-cbc-num');
        }
        _json['str_json'] = '{"acctId": "'+aId+'", "quarterNumb": "'+$.trim($('[id*=hidd_quarternumbid]').val())+'", ' +
							' "refStartDate": "'+$('#hidd_start').val()+'", "refEndDate": "'+$('#hidd_end').val()+'", "periodStartDate": "'+$('#hidd_periodsdid').val()+'", '+
        					' "map_year_monthsFuture": '+$('#hidd_mapfuture').val()+', "map_year_monthsHistory": '+$('#hidd_maphistory').val()+', '+
        					' "map_cbcRowKey_cbcName": '+JSON.stringify(map_cbc)+', "map_year_quartersFuture": '+$.trim($('[id*=hidd_yearfutureid]').val())+'}';
    	params['json'] = JSON.stringify(_json);
    	setForecastCellIndex(q_cell, params);
    	return params;
    }
    
    ;function createGpl_json(acct_cls){
    	
    	
    	var aId=_this.getAttribute('data-aid'), data_num=_this.getAttribute('data-cbc-num'), code=_this.getAttribute('data-code'),
    		_json = { 'className': _this.getAttribute('data-interface'), 'str_json': '{}' }, q_cell={},
			params={'q_cell': q_cell, '$row':$this, '$cbcBacklogRow': $parent.find('tr.cbcsub.'+aId+'.backlog.'+data_num), 
					'region':_this.getAttribute('data-regioncls'), 'aId': aId, 'dataNum':data_num, 'code': code, 'rowIndex':o_cfg['rowIdx'], 'json': '{}'};
		
		//if(code != 'Others'){ 
		//	$('#refdatastatusid').show(); 
		//	iegtTenShow();
		//}
        
        _json['str_json'] = '{"acctId": "'+aId+'", "quarterNumb": "'+$.trim($('[id*=hidd_quarternumbid]').val())+'", ' +
							' "refStartDate": "'+$('#hidd_start').val()+'", "refEndDate": "'+$('#hidd_end').val()+'", "periodStartDate": "'+$('#hidd_periodsdid').val()+'", '+
        					' "map_year_monthsFuture": '+$('#hidd_mapfuture').val()+', "map_year_monthsHistory": '+$('#hidd_maphistory').val()+', '+
        					' "cbc2Code": "'+code+'", "map_year_quartersFuture": '+$.trim($('[id*=hidd_yearfutureid]').val())+'}';
    	
    	params['json'] = JSON.stringify(_json);
    	setForecastCellIndex(q_cell, params);
    	return params;
    }
    
    ;function createPart_json(acct_cls){
    	var aId=_this.getAttribute('data-aid'), data_num=_this.getAttribute('data-cbc-num'), 
    		code=_this.getAttribute('data-code'), gplId=_this.getAttribute('data-gid'),
    		_json = { 'className': _this.getAttribute('data-interface'), 'str_json': '{}' }, q_cell={},
			params={'q_cell': q_cell, '$row':$this, '$partBacklogRow': $parent.find('tr.gplsub.'+aId+'.backlog.'+data_num+'.'+gplId+'_gpl'), 
					'region':_this.getAttribute('data-regioncls'), 'aId': aId, 'gId':gplId, 'dataNum':data_num, 'code': code, 'rowIndex':o_cfg['rowIdx'], 'json': '{}'};

        _json['str_json'] = '{"acctId": "'+aId+'", "gplId": "'+gplId+'", "quarterNumb": "'+$.trim($('[id*=hidd_quarternumbid]').val())+'", ' +
							' "currentYear": "'+$('#hidd_cyear').val()+'", "currentMonth": "'+$('#hidd_cmonth').val()+'", '+
        					' "refStartDate": "'+$('#hidd_start').val()+'", "refEndDate": "'+$('#hidd_end').val()+'", "periodStartDate": "'+$('#hidd_periodsdid').val()+'", '+
        					' "map_year_monthsFuture": '+$('#hidd_mapfuture').val()+', "map_year_monthsHistory": '+$('#hidd_maphistory').val()+', '+
        					' "cbc2Code": "'+code+'", "map_year_quartersFuture": '+$.trim($('[id*=hidd_yearfutureid]').val())+'}';
    	
    	params['json'] = JSON.stringify(_json);
    	setForecastCellIndex(q_cell, params);
    	return params;
    }
    
    ;function isLoadedData(){
    	var regionCls=_this.getAttribute('data-regioncls'), isLoaded=true;
    	switch(o_cfg['root']){
    		case 'root1' :
    			if($parent.find('tr.rt0.'+regionCls+' td:first span.fcell.waiting').length != 0 ||
    				$parent.find('tr.rt0.'+regionCls+' td:first span.reload_span').length != 0){
    				isLoaded=false;
    			}
    			break;
    		case 'root2' :
    			if($parent.find('tr.rt1.'+regionCls+' td:first span.fcell.waiting').length != 0 ||
    				$parent.find('tr.rt1.'+regionCls+' td:first span.reload_span').length != 0){
    				isLoaded=false;
    			}
    			break;
    		case 'root3' :
    			if($parent.find('tr.rt2.'+regionCls+' td:first span.fcell.waiting').length != 0 ||
    				$parent.find('tr.rt2.'+regionCls+' td:first span.reload_span').length != 0){
    				isLoaded=false;
    			}
    			break;
    			
    	}
    	if(!isLoaded){
	    	art.dialog({
		        title:' ', lock:true, dblclick_hide:false, esc:false, id: 'countsid',
		        content: CUSTOM_LABEL['clickwait'],
		        button : [ {value: 'Ok', focus: true, callback: function(){  }} ]
		    });
		    rowUnLock(o_cfg['rowIdx']);
    	}
    	return isLoaded;
    }
    
    ;function isLockedData(){
    	var count=0, isLocked=false;
    	switch(o_cfg['root']){
    		case 'root0' :
    		case 'root1' :
    		case 'root2' :
    		case 'root3' :
    			for(var idx in STATIC_VAR){ if(o_cfg['rowIdx'] != idx){ count++; } }
			break;
    	}
    	if(count != 0){
    		rowUnLock(o_cfg['rowIdx']);
    		isLocked=true;
    	}
    	return isLocked;
    }
    
    
    ;function expandElement(region_cls){
    	_queueTask.push({name: o_cfg['rowIdx'], run: function(cb){
            list_element = $parent.find(region_cls).toArray();
            async.eachSeries(list_element, function(item, callback) {
                setTimeout(function(){
                	var $item=$(item);
                    $right_list_trs.eq(item.rowIndex).removeClass(hide);
                    $item.removeClass(hide);
                    callback(null);
                }, 65);
            }, function(err){
                $this.removeClass('col').addClass('exp');
                if(!o_cfg['isRemote']){ 
                    rowUnLock(o_cfg['rowIdx']);
                    $waiting.html('-').removeClass('waiting'); 
                }
                cb(null);
            });
        }}, function(err){ });
    }
    ;function setForecastCellIndex(q_cell, params){
    	var $head_trs=$('#tab_head_list td.qcell');
    	$head_trs.each(function(){
    		q_cell[this.getAttribute('data-date')] = this.cellIndex;
    	});
    	params['currentCell']=$head_trs.filter('.crtQtotal')[0].cellIndex;
    }

	;function setColTabBgColor(){
		switch(o_cfg['root']){
            case 'root1' : 
            	$this.find('td').addClass('a_bg');
    			$right_list_trs.eq(o_cfg['rowIdx']).find('td').addClass('a_bg');
				break;
            case 'root2' : 
            	if($this.attr('data-code') != 'Others'){
	            	$this.find('td').addClass('c_bg');
	    			$right_list_trs.eq(o_cfg['rowIdx']).find('td').addClass('c_bg');
            	}
            	break;
            case 'root3' : 
            	$this.find('td').addClass('g_bg');
    			$right_list_trs.eq(o_cfg['rowIdx']).find('td').addClass('g_bg');
            	break;
            case 'root4' : 
            	$this.find('td').addClass('p_bg');
    			$right_list_trs.eq(o_cfg['rowIdx']).find('td').addClass('p_bg');
			break;
        }
	}

}
;function event_hideAMCalendar_click(e){

	var $this=$(this), $rHead=$('#tab_head_data').parent(), $r_trs=$('#rtabid tr'), crtCell=$rHead.find('#tab_head_list td.crtQtotal')[0].cellIndex,
		cIdx=0, findCls='', excuteType=$this.attr('data-type'), status=$this.attr('data-status');
	
	switch(excuteType){
		case 'historical': 
			findCls='th_historicalc'; 
			cIdx=crtCell-3;
			$rHead.find('#tab_head_list td:lt('+cIdx+')').each(function(){
				var $this=$(this), cellIndex=this.cellIndex;
				if(status == 'show'){
					$this.addClass('nhide');
					$r_trs.find('td:eq('+cellIndex+')').addClass('nhide');
				}else{
					$this.removeClass('nhide');
					$r_trs.find('td:eq('+cellIndex+')').removeClass('nhide');
				}
			});
			
			break;
		case 'current': 
			findCls='th_current:not(.futurec)'; 
			cIdx=crtCell-4;
		//	console.log( $rHead.find('#tab_head_list td:gt('+cIdx+')') );
		//	console.log( $rHead.find('#tab_head_list td:gt('+cIdx+')').filter(':lt('+(crtCell+1)+')') );
			$rHead.find('#tab_head_list td:gt('+cIdx+')').filter(':lt('+(crtCell+1)+')').each(function(){
				var $this=$(this), cellIndex=this.cellIndex;
				if(cellIndex > crtCell){
					return true; //continue;
				}
				if(status == 'show'){
					$this.addClass('nhide');
					$r_trs.find('td:eq('+cellIndex+')').addClass('nhide');
				}else{
					$this.removeClass('nhide');
					$r_trs.find('td:eq('+cellIndex+')').removeClass('nhide');
				}
			});
			break;
		case 'future': 
			findCls='futurec'; 
			$rHead.find('#tab_head_list td.futurec1').each(function(){
				var $this=$(this), cellIndex=this.cellIndex;
				if(status == 'show'){
					$this.addClass('nhide');
					$r_trs.find('td:eq('+cellIndex+')').addClass('nhide');
				}else{
					$this.removeClass('nhide');
					$r_trs.find('td:eq('+cellIndex+')').removeClass('nhide');
				}
			});
			break;
	}
	
	
	if(status == 'show'){
		$rHead.find('#tab_head_data th.'+findCls).addClass('nhide');
	}else{
		$rHead.find('#tab_head_data th.'+findCls).removeClass('nhide');
	}
	fixAMTableLayout();
	
	$this.val( (status == 'show' ? $this.attr('data-show') : $this.attr('data-hide')) );
	$this.attr('data-status', (status == 'show' ? 'hide' : 'show'));
}
;function event_chart_click(event, target){
	var _url=$.trim( $('#charturlid').val() );
	if(_url == ''){
		alert('URL error.');
		return;
	}
	if($('#openrsmgroupid').length == 0){
		$('#menudivid').append(
			'<a style="display:none;" id="openrsmgroupid" href="'+_url+'" target="_blank"></a>'
		);		
	}
	$('#openrsmgroupid')[0].click();
}
;function event_floatScroll(e){
	try{
	    var _this=this;
	    if (TIMEOUT){ clearTimeout(TIMEOUT) };
	    
	    document.getElementById('right_head').scrollLeft = _this.scrollLeft;
	    $('#rCellScroll').off('scroll').scrollLeft(_this.scrollLeft);
	    TIMEOUT = setTimeout(function(){
		    $('#rCellScroll').off('scroll').on('scroll', rCellScroll_eve);
	    }, 120);
	}catch(e){
		
	}
}

;function event_refAMData_click(e){
	e.stopPropagation();
	var $this=$(this), $tr=$this.parent().parent().parent(), $lBody=$tr.parent(), $rBody=$('#rtabid'), $billing=$tr.next(), $booking=$billing.next(), $backlog=$booking.next(),
		remote_fn={ '$lbody': $lBody, '$rbody': $rBody,  'monthCell': {}, 'cellMonth': {}, 'json': {}, 'cls': '', 'crtCell': $('#tab_head_list td.crtQtotal')[0].cellIndex, 
			'findcls': '', 'data-v1': $tr.attr('data-v1'), 'data-v2': $tr.attr('data-v2'), 'data-v3': $tr.attr('data-v3'),
			'data-v4': $tr.attr('data-v4'), 'data-v5': $tr.attr('data-v5'), 'data-v6': $tr.attr('data-v6'), 'root': $tr.attr('data-root'), 
			'data-region-code': $tr.attr('data-tcode'), 'accnumber': $tr.attr('data-accnumber'), 'cbc2Code': $tr.attr('data-cbc'), 
			'$billing': $billing, '$booking': $booking, '$backlog': $backlog, 'action': getAPLsRefData_js, 'actionBacklog': getBacklogRefData_js,
			'$historicalCells': $('#tab_head_list td.historicalc.qtotalCls, td.crtQtotal'), '$futureCells': $('#tab_head_list td.qtotalCls'), 
			'gamCodes': $.parseJSON($('#hidd_gamcodes').val()), 'complete': complete_getAPLRefData, 'completeBacklog': complete_getAPLBacklogRefData
		}, execute=($this.hasClass('spin')? exp : col);
	
	switch(remote_fn['root']){
		case 'root0': 
			remote_fn['$billing']=$tr.next().next();
			remote_fn['$booking']=remote_fn['$billing'].next();
			remote_fn['$backlog']=remote_fn['$booking'].next();
			remote_fn['data-v1']=$tr.attr('data-regioncls');
			remote_fn['findcls']='tr:not(.rt0).rgsub.'+remote_fn['data-v1'];
			remote_fn['cls']=WORK_CLS['level1'];
			break;
		case 'root1': 
			remote_fn['$billing']=$tr.next().next().next().next();
			remote_fn['$booking']=remote_fn['$billing'].next();
			remote_fn['$backlog']=remote_fn['$booking'].next();
			remote_fn['data-v1']=$tr.attr('data-regioncls');
			remote_fn['data-v2']=$tr.attr('data-aid');
			remote_fn['findcls']='tr:not(.rt1).accRows.'+remote_fn['data-v1']+'.'+remote_fn['data-v2'];
			remote_fn['cls']=WORK_CLS['level2'];
			break;
		case 'root2': 
			remote_fn['cbc2Code']=$tr.attr('data-code');
			remote_fn['$billing']=$tr.next().next();
			remote_fn['$booking']=remote_fn['$billing'].next();
			remote_fn['$backlog']=remote_fn['$booking'].next();
			remote_fn['data-v1']=$tr.attr('data-regioncls');
			remote_fn['data-v2']=$tr.attr('data-aid');
			remote_fn['data-v3']=$tr.attr('data-cbc-num');
			remote_fn['findcls']='tr:not(.rt2).cbcsub.'+remote_fn['data-v1']+'.'+remote_fn['data-v2']+'.'+remote_fn['data-v3'];
			remote_fn['cls']=WORK_CLS['level3'];
			break;
		case 'root3': 
			remote_fn['cbc2Code']=$tr.attr('data-code');
			remote_fn['$billing']=$tr.next().next().next();
			remote_fn['$booking']=remote_fn['$billing'].next();
			remote_fn['$backlog']=remote_fn['$booking'].next();
			remote_fn['data-v1']=$tr.attr('data-regioncls');
			remote_fn['data-v2']=$tr.attr('data-aid');
			remote_fn['data-v3']=$tr.attr('data-cbc-num');
			remote_fn['data-v4']=$tr.attr('data-gid');
			remote_fn['findcls']='tr:not(.rt3).gplsub.'+remote_fn['data-v1']+'.'+remote_fn['data-v2']+'.'+remote_fn['data-v3']+'.'+remote_fn['data-v4']+'_gpl';
			remote_fn['cls']=WORK_CLS['level4'];
			break;
		case 'root007': 
			remote_fn['findcls']='tr:not(.rt110).'+remote_fn['data-v1']+'.'+remote_fn['data-v2']+'.'+remote_fn['data-v3']+'.'+remote_fn['data-v4'];
			remote_fn['cls']=WORK_CLS['other'];
			break;
		case 'root44': 
			remote_fn['cbc2Code']=remote_fn['data-v4'];
			remote_fn['$billing']=$tr.next().next().next();
			remote_fn['$booking']=remote_fn['$billing'].next();
			remote_fn['$backlog']=remote_fn['$booking'].next();
			remote_fn['findcls']='tr:not(.rt33).productcodesub.'+remote_fn['data-v1']+'.'+remote_fn['data-v2']+'.'+remote_fn['data-v3']+'.'+remote_fn['data-v4']+'_gpl.'+remote_fn['data-v5'];
			remote_fn['cls']=WORK_CLS['level5'];
			break;
		case 'root6': 
			remote_fn['cbc2Code']=remote_fn['data-v4'];
			remote_fn['$billing']=$tr.next().next().next();
			remote_fn['$booking']=remote_fn['$billing'].next();
			remote_fn['$backlog']=remote_fn['$booking'].next();
			remote_fn['findcls']=('tr:not(.rt4).partsub.'+remote_fn['data-v1']+'.'+remote_fn['data-v2']+'.'+remote_fn['data-v3']+'.'
									+remote_fn['data-v4']+'_gpl.'+remote_fn['data-v5']+'.'+remote_fn['data-v6']);
			remote_fn['cls']=WORK_CLS['level6'];
			break;
	}

	execute();
	
	
	;function exp(){
		if(!$this.hasClass('refdata')){
			$this.addClass('refdata');
			createHistoricalStatus(remote_fn['$billing']);
			createFutureStatus(remote_fn['$backlog']);
		}
		$lBody.find(remote_fn['findcls']).removeClass('dn').each(function(){
			$rBody.find('tr:eq('+this.rowIndex+')').removeClass('dn');
		});
		$this.removeClass('spin')
		if(!$this.hasClass('pin')){ $this.html('-'); }
	}
	
	
	;function col(){
		$lBody.find(remote_fn['findcls']).addClass('dn').each(function(){
			$rBody.find('tr:eq('+this.rowIndex+')').addClass('dn');
		});
		$this.addClass('spin')
		if(!$this.hasClass('pin')){ $this.html('+'); }
	}
	
	;function createHistoricalStatus($element){
		var list_months=[];
		createMonths( list_months, $element, $('#tab_head_list td.monthCls') );

		asyncEachSeries_Original(list_months, function(list_item, callback){
			var attr_tmp=$.extend({}, remote_fn), list_q=[];
			for(var i=0, result; result=list_item[i]; i++){
				list_q.push(result);
			}
			attr_tmp['smonths'] = list_q.join(',');
			attr_tmp['json'] = {'set_fiscalMonth': list_q, 'region': remote_fn['data-region-code'], 'soldtoId': remote_fn['data-v2'], 'gplId': remote_fn['data-v4'],
								'set_gamCodes': remote_fn['gamCodes'], 'accnumber': remote_fn['accnumber'], 'cbc2Code': remote_fn['cbc2Code'], 'partId': attr_tmp['data-v6']};
			attr_tmp['json'] = JSON.stringify(attr_tmp['json']);
			customMultipleRemoteAction(attr_tmp, attr_tmp['action'], attr_tmp['complete']); //this is remote action
		}, function(err){}, 120);
		
	}
	
	;function createFutureStatus($element){
		var list_months=[];
		createFutureMonths(list_months, $element, $('#tab_head_list td.qtotalCls'));

		asyncEachSeries_Original(list_months, function(list_item, callback){
			var attr_tmp=$.extend({}, remote_fn), list_q=[];
			for(var i=0, result; result=list_item[i]; i++){
				list_q.push(result);
			}
			attr_tmp['smonths'] = list_q.join(',');
			attr_tmp['json'] = {'set_fiscalMonth': list_q, 'region': remote_fn['data-region-code'], 'soldtoId': remote_fn['data-v2'], 'gplId': remote_fn['data-v4'],
								'set_gamCodes': remote_fn['gamCodes'], 'accnumber': remote_fn['accnumber'], 'cbc2Code': remote_fn['cbc2Code'], 'partId': attr_tmp['data-v6'] };
			attr_tmp['json'] = JSON.stringify(attr_tmp['json']);
			customMultipleRemoteAction(attr_tmp, attr_tmp['actionBacklog'], attr_tmp['completeBacklog']); //this is remote action
		}, function(err){}, 120);
		
	}
	
	;function createFutureMonths(list_months, $element, $el_head){
		var list_result=[], el_body='<div class="ref_cover"><b class="reload_img reloadRef" style="display:none;"></b>';

		$el_head.each(function(){
			var cell=this.cellIndex, month=this.getAttribute('data-months');
			remote_fn['monthCell'][month] = cell;
			remote_fn['cellMonth'][cell] = month;
			list_result.push(month.split(','));
		});
		for(var i=0, result; result=list_result[i]; i++){
			list_months.push(result);
			el_body += '<b data-months="'+result.join(',')+'" data-status="false" class="ref_box">&nbsp;</b>';
		}
		el_body += '</div>';
		if($element.find('td:first div').length == 0){
			$element.find('td:first').append(el_body);
		}else{
			$element.find('td:first div').append(el_body);
		}
	}
	
	;function createMonths(list_months, $element, $el_head){
		var list_result=[], el_body='<div class="ref_cover"><b class="reload_img reloadRef" style="display:none;"></b>';

		$el_head.each(function(){
			var cell=this.cellIndex, month=this.getAttribute('data-month');
			remote_fn['monthCell'][month] = cell;
			remote_fn['cellMonth'][cell] = month;
			list_result.push(month);
		});
		for(var i=0, max=list_result.length; i<max; i+=3){
			var list_t=list_result.slice(i,i+3);
			list_months.push(list_t);
			el_body += '<b data-months="'+list_t.join(',')+'" data-status="false" class="ref_box">&nbsp;</b>';
		}
		el_body += '</div>';
		if($element.find('td:first div').length == 0){
			$element.find('td:first').append(el_body);
		}else{
			$element.find('td:first div').append(el_body);
		}
	}
}

;function complete_appendElementEND(queueComplete, _data){
	rowUnLock(_data['rowIndex']);
	_data['$row'].removeClass('ready').addClass('done').find('td:first span.fcell').html('-').removeClass('waiting');
	queueComplete(null); 
}

;function complete_getAPLRefData(result, event, data){
	
	_queueTask.push({name: data['level'], run: function(cb){
		
		var $status_cell=data['$billing'].find('td:first b.ref_box[data-months="'+data['smonths']+'"]').eq(0);
		if(event.status){
			result = $.parseJSON(result);

			var $billing=data['$rbody'].find('tr:eq('+data['$billing'].index()+')'), 
				$booking=data['$rbody'].find('tr:eq('+data['$booking'].index()+')'), 
				billing=result['map_billingrefdata'], booking=result['map_bookingrefdata'];

			matchRefData(billing, data, $billing.find('td'));
			matchRefData(booking, data, $booking.find('td'));
			
			$status_cell.attr('data-status', 'true').animate({backgroundColor: '#51C957'}, 130, function(){
				$status_cell.remove();
				if(data['$billing'].find('b.ref_box').length == 0){
					data['$billing'].find('span.reloadRef').remove();
				}
			});
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
    			$cell.eq(monthCell[r]).attr({'data-old': refData[r]}).html( Globalize.format(refData[r], 'n') );
    		}
    	}
    	var cellIdx=data['$historicalCells'].filter('[data-months="'+data['smonths']+'"]')[0].cellIndex,
    		$qCell=$cell.eq(cellIdx), $q3=$qCell.prev(), $q2=$q3.prev(), $q1=$q2.prev(),
    		q1=getZeroOfNumber($q1.attr('data-old')), q2=getZeroOfNumber($q2.attr('data-old')), q3=getZeroOfNumber($q3.attr('data-old'));
    	$qCell.html( Globalize.format((q1+q2+q3), 'n') );

    }
    
    ;function reLoadRefData($status_cell, data){
    	data['$billing'].find('b.reloadRef').show().off('click').on('click', function(e){
    		e.stopPropagation();
			$(this).hide().off('click');
			data['$billing'].find('b.ref_box').click();
    	});
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

;function complete_getAPLBacklogRefData(result, event, data){
	
	_queueTask.push({name: data['level'], run: function(cb){
		var $status_cell=data['$backlog'].find('td:first b.ref_box[data-months="'+data['smonths']+'"]').eq(0);
		if(event.status){
			result = $.parseJSON(result);

			var $backlog=data['$rbody'].find('tr:eq('+data['$backlog'].index()+')'), backlog=result['map_backlogrefdata'];
			$status_cell.attr('data-status', 'true').animate({backgroundColor: '#51C957'}, 130, function(){
				$status_cell.remove();
				if(data['$backlog'].find('b.ref_box').length == 0){
					data['$backlog'].find('span.reloadRef').remove();
				}
			});
			matchRefData(backlog, data, $backlog.find('td'));
	    }else{
			reLoadRefData($status_cell, data);
	    }
		cb(null);
    }}, function(err){ });
	
    
    /*HELP methods*/
    ;function matchRefData(refData, data, $cell){
		
    	var total=0, cellIdx=data['$futureCells'].filter('[data-months="'+data['smonths']+'"]')[0].cellIndex;
    	if(cellIdx < data['crtCell'] || cellIdx == data['crtCell']){
    		var monthCell = data['monthCell'];
	    	for(var r in refData){
	    		if(monthCell.hasOwnProperty(r)){
	    			$cell.eq(monthCell[r]).attr({'data-old': refData[r]}).html( Globalize.format(refData[r], 'n') );
	    		}
	    	}
	    	var cellIdx=data['$historicalCells'].filter('[data-months="'+data['smonths']+'"]')[0].cellIndex,
	    		$qCell=$cell.eq(cellIdx), $q3=$qCell.prev(), $q2=$q3.prev(), $q1=$q2.prev(),
	    		q1=getZeroOfNumber($q1.attr('data-old')), q2=getZeroOfNumber($q2.attr('data-old')), q3=getZeroOfNumber($q3.attr('data-old'));
	    	$qCell.html( Globalize.format((q1+q2+q3), 'n') );
    	}else{
	    	for(var r in refData){ total += refData[r]; }
	    	$cell.eq(cellIdx).html( Globalize.format(total, 'n') );
    	}
    	
    }
    
    ;function reLoadRefData($status_cell, data){
    	data['$backlog'].find('b.reloadRef').show().off('click').on('click', function(e){
    		e.stopPropagation();
			$(this).hide().off('click');
			data['$backlog'].find('b.ref_box').click();
    	});
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


;function complete_GAMRefTotalFC(result, event, data){

	if(event.status){
        _queueTask.push({name: data['$row'].index(), run: function(cb){
        	result = $.parseJSON(result);

			setMonthsReslut(result['totalBacklog'], data['$rRow'].eq( data['$totalRow'].filter('.rgsub.totalBacklog').index() ).find('td'));
			setMonthsReslut(result['totalBilling'], data['$rRow'].eq( data['$totalRow'].filter('.rgsub.totalBilling').index() ).find('td'));
			setMonthsReslut(result['totalBooking'], data['$rRow'].eq( data['$totalRow'].filter('.rgsub.totalBooking').index() ).find('td'));
        	
        	data['$totalRow'].each(function(){
        		$(this).removeClass('dn');
        		data['$rRow'].eq(this.rowIndex).removeClass('dn');
        	});
        	data['$pin'].removeClass('readypin waitingpin').addClass('donepin');
        	
        	cb(null);
        	
        }}, function(err){ });
    }else{
        addReloadTotalButton(data, event, reloadTotalFC_eve);
    }
    
    
    ;function setCycelReslut(oResult, $tds){
    	for(var o in oResult){
    		$tds.eq(data['qCell'][o]).html( Globalize.format(oResult[o], 'n') );
    	}
    }
    ;function setMonthsReslut(refData, $r_tds){
    	for(var rDate in refData){
    		if(data['qFuture'][rDate]){
    			for(var months in data['qMonths']){
	    			if( (months+'').indexOf(rDate) != -1){
	    				var $td=$r_tds.eq(data['qMonths'][months]), old=getZeroOfNumber($td.attr('data-old'));
	    				$td.attr('data-old', (refData[rDate]+old));
	    			}
    			}
    		}else{
	    		$r_tds.eq(data['mCell'][rDate]).attr('data-old', refData[rDate]).html( Globalize.format(refData[rDate], 'n') );
    		}
		}
		$r_tds.filter(':lt('+data['currentCell']+').qtotalCls').each(function(){
			var $this=$(this), m1=getZeroOfNumber($this.prev().attr('data-old')), m2=getZeroOfNumber($this.prev().prev().attr('data-old')), 
				m3=getZeroOfNumber($this.prev().prev().prev().attr('data-old'));
			m1 = (m1+m2+m3);
			$this.attr('data-old', m1).html( Globalize.format(m1, 'n') );
		});
		$r_tds.filter(':gt('+(data['currentCell']-1)+')').each(function(){
			var $this=$(this), v=getZeroOfNumber($this.attr('data-old'));
			$this.html( Globalize.format(v, 'n') );
		});
    }
}

;function complete_searchTotalCycleFC(result, event, data){

	if(event.status){
        _queueTask.push({name: data['$row'].index(), run: function(cb){
        	result = $.parseJSON(result);
        	setCycelReslut(result['currentFC'], data['$currentCycle'].find('td'));
        	setCycelReslut(result['previousFC'], data['$prevCycle'].find('td'));
        //	setCycelReslut(result['amFC'], data['$amCycle'].find('td'));
        	data['$row'].find('span.waitingtcode').remove();
        	cb(null);
        }}, function(err){ });
    }else{
        addCycelError(data, event);
    }
    
    
    ;function addCycelError(data, event){
    	var err = '<b class="waitingerror" style="display:none;">'+event['message']+'</b>';
    	data['$row'].find('span.waitingtcode').removeClass('waitingtcode').addClass('reload_img waitingtcodeerror')
    				.append(err).off('mouseenter mouseleave click').on('mouseenter mouseleave click', function(e){
    					e.stopPropagation();
    					var $this=$(this);
    					eventHandle(e, over, out, click);
    					;function over(e){ $this.find('b').show(); }
    					;function out(e){ $this.find('b').hide(); }
    					;function click(e){
	    					$this.off('mouseenter mouseleave click').removeClass('reload_img waitingtcodeerror')
	    						 .addClass('waitingtcode').find('b').remove();
	    					customRemoteAction(data, searchAcctFC_js, complete_searchTotalCycleFC); //this is total remote action
    					}
    				});
    	
    }
    
    
    ;function setCycelReslut(oResult, $tds){
    	for(var o in oResult){
    		$tds.eq(data['qCell'][o]).html( Globalize.format(oResult[o], 'n') );
    	}
    }
}

;function complete_searchAcctFC(result, event, data){ 
	if(event.status){
        _queueTask.push({name: data['rowIndex'], run: function(cb){
        	matchAcctFC_Element(result, data, cb);
        }}, function(err){ });
    }else{
        addReloadButton(data, event, reloadAcctFC_eve);
    }
    
    ;function matchAcctFC_Element(result, data, queueTaskCallBack){
    	var $acct_rtrs=$('#rtabid tr'), $acct_lbody=data.$row.parent(), $head=$('#tab_head_list td'), 
			list_hidden_td=$head.filter('.dn').toArray(), list_nhide_td=$head.filter('.nhide').toArray();
        
        result=complete_resultCheck(result, data);

        if(result.length == 0){ 
            queueTaskCallBack(null); 
            return; 
        }
        
        
        asyncEachSeries_Original(result, function(item, callback){
        	var $acctRows=$acct_lbody.find('tr.accRows.'+item['acctId']+'.'+data['region']);
        	$acctRows.filter('.rt1').attr({'data-tcode': data['$row'].attr('data-tcode'),  'data-interface': item['gamTypeName']});
        	formatFC(false, item['currentFC'], $acct_rtrs.eq($acctRows.filter('.currentFC').index()).find('td'), data['q_cell'], '');
        	formatFC(false, item['previousFC'], $acct_rtrs.eq($acctRows.filter('.previousFC').index()).find('td'), data['q_cell'], '');

        }, function(err){
			complete_remoteStatus(data, queueTaskCallBack);
        }, 120);
        
    }
    
}

;function complete_searchCBC2FC(result, event, data){ 
	scroll_event();
	_queueTask.push({name: data['rowIndex'], run: function(cb){
	    if(event.status){
			matchCBC2FC_Element(result, data, cb);
	    }else{
	        addReloadButton(data, event, reloadCBC2FC_eve);
	        cb(null);
	    }
	}}, function(err){ });
    
    ;function matchCBC2FC_Element(result, data, queueTaskCallBack){
        result = complete_resultCheck(result, data);
        var $right_tr=$('#rtabid tr'), $left_trs=$('#ltabid tr');//,  list_fc=[];
        
    	
        if(result.length == 0){ 
            queueTaskCallBack(null); 
            return; 
        }

        asyncEachSeries_Original(result, function(item, callback){
        	
        	var $cbcRow=data['$cbcRows'].filter( '.'+item['fieldName'] ), code=$cbcRow.attr('data-code');

        	$cbcRow.attr('data-interface', item['gamTypeName']);
        	formatFC((code == 'Relay' ? false : true), item['currentFC'], $right_tr.eq($cbcRow.index()).find('td'), data['q_cell'], (code == 'Relay' ? '' : 'cbc2'));
        	formatFC(false, item['previousFC'], $right_tr.eq( ($cbcRow.index()+1) ).find('td'), data['q_cell'], '');
       // 	formatFC(false, item['amFC'], $right_tr.eq( ($cbcRow.index()+2) ).find('td'), data['q_cell'], '');
        	
        	if(code == 'Others'){
        	//	$cbcRow.find('span.fcell').remove();
        		$right_tr.eq($cbcRow.index()).find('input').removeAttr('disabled')
        				 .on('focus change', input_fc_eve).on('keyup', input_keyup_eve);
        	}

        }, function(err){
    		complete_remoteStatus(data, queueTaskCallBack);
        }, 230);
        
    }

}

;function complete_searchGPLFC(result, event, data){ 
	scroll_event();
    if(event.status){
		_queueTask.push({name: data['rowIndex'], run: function(cb){
			result = complete_resultCheck(result, data);

	        if(result.length == 0){ 
	            cb(null); 
	            return; 
	        }
			
			if(data['code'] == 'Others'){ matchOtherFC_Element(result, data, cb); }
			else{ matchGPLFC_Element(result, data, cb); }
		}}, function(err){ });
    }else{
    	$('#refdatastatusid').hide();
        addReloadButton(data, event, reloadGPLFC_eve);
    }
    
    ;function matchGPLFC_Element(result, data, queueTaskCallBack){
    	var $gpl=$('#gpltab'), $left_gpl=$gpl.find('tbody tr').clone(), 
    		$right_gpl=$gpl.find('tfoot tr').clone(), $head=$('#tab_head_list td'), 
			list_hidden_td=$head.filter('.dn').toArray(), list_nhide_td=$head.filter('.nhide').toArray();

		setHideForecastHead($right_gpl);
		data['$right_cbcBacklog']=$('#rtabid tr:eq('+data['$cbcBacklogRow'].index()+')');
		$left_gpl.on('mouseenter mouseleave', over_table_eve).eq(0)
				 .on('click', {$divbody: $('#div_body')}, clickLeftTable_eve)
				 .find('span.pin').on('click', event_refAMData_click);
		$right_gpl.on('mouseenter mouseleave', over_table_eve)
			.each(function(){
				var $tds = $(this).find('td');
				for(var i=0, el; el=list_hidden_td[i]; i++){
					$tds.eq(el.cellIndex).addClass('dn');
				}
				for(var i=0, el; el=list_nhide_td[i]; i++){
					$tds.eq(el.cellIndex).addClass('nhide');
				}
			});
        
		
        asyncEachSeries_Original(result, function(item, callback){
        	var $l_clone=$left_gpl.clone(true), $r_clone=$right_gpl.clone(true), gplName='[ '+item['gplCode']+' ] - '+item['fieldName'];
        	$l_clone.addClass( (item['prodHichyId']+'_gpl '+data['region']+' '+data['aId']+' '+data['dataNum']) );
        	$l_clone.eq(0).attr({'title': gplName, 'data-interface': item['gamTypeName'], 'data-gid': item['prodHichyId'], 
									'data-code': data['code'], 'data-root': 'root3', 'data-aid': data['aId'], 'data-accnumber': item['gplCode'],
        							'data-regioncls': data['region'], 'data-cbc-num': data['dataNum']})
        					.find('td:first span.scell').html(gplName);

        	formatFC((data['code'] == 'Relay' ? false : true), item['currentFC'], $r_clone.eq(0).find('td'), data['q_cell'], (data['code'] == 'Relay' ? '' : 'gpl'));
        	formatFC(false, item['previousFC'], $r_clone.eq(1).find('td'), data['q_cell'], '');
       // 	formatFC(false, item['amFC'], $r_clone.eq(2).find('td'), data['q_cell'], '');
        	$r_clone.eq(0).find('input[type="text"]').on('focus change', input_fc_eve).on('keyup', input_keyup_eve);
        	
        	if(item['isHighLighted']){
				$l_clone.eq(0).find('td:first div:first').before('<div class="highLighted"></div>');
			}
        	        	
        	data['$cbcBacklogRow'].after($l_clone);
        	data['$right_cbcBacklog'].after($r_clone);
			
        }, function(err){
        	result=[];
			complete_remoteStatus(data, queueTaskCallBack);
        }, 340);
        
    }
    
    ;function matchOtherFC_Element(result, data, queueTaskCallBack){
		completePartReslut(result, data, queueTaskCallBack, data['$cbcBacklogRow'], false);
    }
}

;function complete_searchPartFC(result, event, data){ 
	if(event.status){
		_queueTask.push({name: data['rowIndex'], run: function(cb){
			result = complete_resultCheck(result, data);

	        if(result.length == 0){ 
	            cb(null); 
	            return; 
	        }
	        completePartReslut(result, data, cb, data['$partBacklogRow'], true);
		}}, function(err){ });
    }else{
        addReloadButton(data, event, reloadPartFC_eve);
    }
}

;function completePartReslut(result, data, queueTaskCallBack, $backlogRow, isGpl){
	var $part=$('#parttab'), $left_part=$part.find('tbody tr').clone(), $right_part=$part.find('tfoot tr').clone(), 
		gplCls=(isGpl ? (data['gId']+'_gpl') : ''), $append_right=$('#rtabid tr:eq('+$backlogRow.index()+')'),
		quarter_month={'month_cell': {}, 'quarter_cell': {}}, $head=$('#tab_head_list td'), 
		list_hidden_td=$head.filter('.dn').toArray(), list_nhide_td=$head.filter('.nhide').toArray();
		
	setMatchCell(quarter_month);
	setHideForecastHead($right_part);
	
	$left_part.on('mouseenter mouseleave', over_table_eve).on('click', {$divbody: $('#div_body')}, clickLeftTable_eve);
	$right_part.on('mouseenter mouseleave', over_table_eve)
    	.each(function(){
			var $tds = $(this).find('td');
			for(var i=0, el; el=list_hidden_td[i]; i++){
				$tds.eq(el.cellIndex).addClass('dn');
			}
			for(var i=0, el; el=list_nhide_td[i]; i++){
				$tds.eq(el.cellIndex).addClass('nhide');
			}
		});
			
	asyncEachSeries_Original(result, function(item, callback){
    	var $l_clone=$left_part.clone(true), $r_clone=$right_part.clone(true);
    	$l_clone.addClass( (item['partId']+'_part '+data['region']+' '+data['aId']+' '+data['dataNum']+' '+gplCls) );
    	$l_clone.eq(0).attr({'data-root': 'root4', 'data-pid': item['partId'], 'data-gid': data['gId'],
    							'data-code': data['code'], 'data-aid': data['aId'], 'title': item['fieldName'],
    							'data-regioncls': data['region'], 'data-cbc-num': data['dataNum']})
    				.find('td:first').addClass((isGpl ? '' : 'pd_others')).removeClass((isGpl ? '' : 'pd_4'))
    				.find('span.scell').html( item['partDesc'] );
    	
    	formatFC((data['code'] == 'Relay' ? false : true), item['currentFC'], $r_clone.eq(0).find('td'), data['q_cell'], (data['code'] == 'Relay' ? '' : (isGpl ? 'gplpart' : 'otherpart') ));
    	formatFC(false, item['previousFC'], $r_clone.eq(1).find('td'), data['q_cell'], '');
    //	formatFC(false, item['amFC'], $r_clone.eq(2).find('td'), data['q_cell'], '');
    	
    	matchHistoryData( item['backlog'], quarter_month, $r_clone.filter('.backlog').find('td') );
        matchHistoryData( item['billing'], quarter_month, $r_clone.filter('.billing').find('td') );
        matchHistoryData( item['booking'], quarter_month, $r_clone.filter('.booking').find('td') );
		
        $r_clone.filter('.backlog, .billing, .booking').each(function(){
        	$(this).find('td').html(function(idx){
	        	var $t=$(this), t=$t.attr('data-old');
	        	t=($.isNumeric(t) ? parseFloat(t) : 0);
	        	if(idx <= data['currentCell'] && $t.hasClass('qtotalCls')){//(data['currentCell']+1)
	        		var month_1=$t.prev().attr('data-old'), month_2=$t.prev().prev().attr('data-old'), month_3=$t.prev().prev().prev().attr('data-old');
					month_1=($.isNumeric(month_1) ? parseFloat(month_1) : 0);
					month_2=($.isNumeric(month_2) ? parseFloat(month_2) : 0);
					month_3=($.isNumeric(month_3) ? parseFloat(month_3) : 0);
					t=(month_1+month_2+month_3);
	        	}
	        	return Globalize.format(t, 'n');
	        });
        });
        $r_clone.eq(0).find('input[type="text"]').on('focus change', input_fc_eve).on('keyup', input_keyup_eve);
    	$backlogRow.after($l_clone);
    	$append_right.after($r_clone);
    	
    }, function(err){
    	result=quarter_month=[];
		complete_remoteStatus(data, queueTaskCallBack);
    }, 320);
    
	;function matchHistoryData(items, quarter_month, $cells){
		for(var fcMonth in items){
			var q_cell=quarter_month['month_cell'][fcMonth], o_month=quarter_month['quarter_cell'][q_cell], 
				o_month_cell=o_month[fcMonth], isFuture=(o_month_cell['isQcell'] && !o_month_cell['isCurrent']),
				$cell=$cells.eq( (isFuture ? q_cell : o_month_cell['cell']) ), old=$cell.attr('data-old');
				
			old=($.isNumeric(old) ? parseFloat(old) : 0);
			old+=items[fcMonth];
			$cell.attr('data-old', old);
		}
	}

}

;function complete_getGAMRefData(result, event, data){
	
	var $status_cell=data['$td'].find('table.pinstatus td.smonths[data-months="'+data['sMonths']+'"]');
	if(event.status){	
		_queueTask.push({name: data['sMonths'], run: function(cb){
			var bookingFieldName=(data['root'] == 'root1' ? 'totalBooking' : 'booking'),
				billingFieldName=(data['root'] == 'root1' ? 'totalBilling' : 'billing'),
				backlogFieldName=(data['root'] == 'root1' ? 'totalBacklog' : 'backlog'),
				$bookingCell=data['$rRow'].eq(data['$totalRow'].filter( ('.'+bookingFieldName) ).index()).find('td'),
				$billingCell=data['$rRow'].eq(data['$totalRow'].filter( ('.'+billingFieldName) ).index()).find('td'),
				$backlogCell=data['$rRow'].eq(data['$totalRow'].filter( ('.'+backlogFieldName) ).index()).find('td');
				
			result = $.parseJSON(result);
			matchRefData(data, result[bookingFieldName], $bookingCell);
			matchRefData(data, result[billingFieldName], $billingCell);
			matchRefData(data, result[backlogFieldName], $backlogCell);
			complete_finallyRefData(data, $status_cell, cb);
		}}, function(err){ });	
    }else{
		complete_finallyErrorRefData(data, event, $status_cell);
    }
    
    ;function matchRefData(data, refData, $r_tds){
		var total=0;
		for(var rDate in refData){
	    	if(!data['isFuture']){
	    		$r_tds.eq(data['mCell'][rDate]).attr('data-old', refData[rDate]).html( Globalize.format(refData[rDate], 'n') );
	    	}
	    	total+=refData[rDate];
		}
		$r_tds.eq(data['quarterCell']).attr('data-old', total).html( Globalize.format(total, 'n') );
	}
}



;function complete_finallyRefData(data, $status_cell, cb){
	
	$status_cell.attr('data-status', 'true').find('div').animate({backgroundColor: '#51C957'}, 130);

	if(data['$td'].find('table.pinstatus td.smonths[data-status="false"]').length == 0){
		data['$td'].find('div.refs_d').remove();
    	data['$pin'].off('mouseenter mouseleave').removeClass('readypin waitingpin').addClass('donepin');
	}
	cb(null);
    
}

;function complete_finallyErrorRefData(data, event, $status_cell){

	var btn='<span class="btnspan"><input type="button" class="btn reloadcls" value="Reload"></span>';
	$status_cell.append(btn).attr('data-status', 'false').find('div')
				.html('<b class="berrormsg" style="display:none;">'+event['message']+'</b>')
				.on('mouseenter mouseleave', over_refErrorMsg_eve).animate({backgroundColor: '#C95151'}, 230);
	$status_cell.find('input[type="button"].reloadcls').on('click', function(e){
		e.stopPropagation();
		$(this).off('click');
		$status_cell.find('span.btnspan').remove();
		$status_cell.attr('data-status', 'false').find('div').animate({backgroundColor: '#517BC9'}, 130).off('mouseenter mouseleave').html('&nbsp;');
		customRemoteAction(data, data['action'], data['complete']);  
	});
}

;function complete_remoteStatus(data, taskCallBack){
	rowUnLock(data['rowIndex']);
	data.$row.removeClass('ready').addClass('done').find('td:first span.fcell').html('-').removeClass('waiting');
	taskCallBack(null); 
}

;function complete_resultCheck(result, data){
	result = $.parseJSON(result);
    if(result.length == 0){ 
        rowUnLock(data['rowIndex']);
        data.$row.removeClass('ready').addClass('done').find('td:first span.fcell').html('-').removeClass('waiting');
        return []; 
    }
    return result;
}
;function complete_existObject(result, event, data){	//complete remoteaction result

	_queueTask.push({name: data['rowIndex'], run: function(cb){

		if(event.status){
			
			data['list_result'] = $.parseJSON(result);

		    if(data['list_result'].length == 0){ 
		        rowUnLock(data['rowIndex']);//rowIndex
		        data['$row'].removeClass('ready').addClass('done').find('td:first span.fcell').html('-').removeClass('waiting');
		        cb(null);
		        return;
		    }

		    data['append'](data, cb, complete_appendElementEND);
			
		//	complete_remoteResultCheck(result, data, cb, data['append'], complete_appendElementEND);
	    }else{ 
			var el_reload = '<span class="reload_span reload_spanfix"><span class="reload_img fixreload"></span><b class="reload_msg reload_msg_relayfix" >'+event['message']+'</b></span>';
		    data['$row'].removeClass('ready done').find('td:first span.waiting.fcell').before(el_reload)
		            .parent().find('span.reload_span').off('click').on('click', {$data: data}, function(e){
		            	e.stopPropagation();
		            	rowUnLock(data['rowIndex']);
					    customMultipleRemoteAction(data, data['action'], data['complete']);
					    $(this).remove();
		            });
		            
		    rowUnLock(data['rowIndex']);
	    	cb(null);
	    }

	}}, function(err){ });
	
}
;function appendElementRelay_level3(data, callBack, callBackEnd){
	
	var monthCell={}, cellMonth={}, $head=$('#tab_head_list td'), 
		list_hidden_td=$head.filter('.dn').toArray(), list_nhide_td=$head.filter('.nhide').toArray(),
		ftCell=$head.filter('.crtQtotal')[0].cellIndex-1;
	
	$head.each(function(){
		cellMonth[this.cellIndex] = this.getAttribute('data-date');
		monthCell[this.getAttribute('data-date')] = this.cellIndex;
	});
	data['cellMonth'] = cellMonth;
	data['monthCell'] = monthCell;
	data['ftCell']=ftCell;

	data['$left'] = data['$row'].next().next().next().next();
	data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');
	data['$left_template'] = $('#gpltab tbody tr').clone();
	data['$right_template'] = $('#gpltab tfoot tr').clone();

	data['$right_template'].each(function(){
		var $tds = $(this).find('td');
		for(var i=0, el; el=list_hidden_td[i]; i++){
			$tds.eq(el.cellIndex).addClass('dn');
		}
		for(var i=0, el; el=list_nhide_td[i]; i++){
			$tds.eq(el.cellIndex).addClass('nhide');
		}
	});

	data['$left_template'].on('mouseenter mouseleave', over_table_eve).eq(0).attr({'data-root': 'root3'}).addClass('relay_cbc')
				.on('click', {$divbody: $('#div_body')}, clickLeftTable_eve).find('span.pin').on('click', event_refAMData_click);
	data['$right_template'].on('mouseenter mouseleave', over_table_eve);

	asyncEachSeries_Original(data['list_result'], function(item, call){

		var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true);
		$lClone.addClass( (item['accnumber']+'_gpl '+data['data-v1']+' '+data['data-v2']+' '+data['data-v3']) ).eq(0)
				.attr({'data-regioncls': data['data-v1'], 'data-aid': data['data-v2'], 'data-cbc-num': data['data-cbc-num'], 'data-v4': item['id'],
						'title': item['name'], 'data-code': data['data-cbc'], 'data-gid': item['accnumber'], 'data-accnumber': item['accnumber']})
				.find('span.scell').html( item['name'] );
	
		setFieldValue($rClone.eq(0).find('td:gt('+(data['ftCell'])+')'), data, item['map_type_FC']['csFC']);	
		setFieldValue($rClone.eq(1).find('td:gt('+(data['ftCell'])+')'), data, item['map_type_FC']['pmFC']);
		
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
			$(this).attr(attr).html( Globalize.format(attr['data-old'], 'n') );
		});
	}
	
}
;function appendElementOther_level3(data, callBack, callBackEnd){
	
	var monthCell={}, cellMonth={}, $head=$('#tab_head_list td'), 
		list_hidden_td=$head.filter('.dn').toArray(), list_nhide_td=$head.filter('.nhide').toArray(),
		ftCell=$head.filter('.crtQtotal')[0].cellIndex-1;
	
	$head.each(function(){
		cellMonth[this.cellIndex] = this.getAttribute('data-date');
		monthCell[this.getAttribute('data-date')] = this.cellIndex;
	});
	data['cellMonth'] = cellMonth;
	data['monthCell'] = monthCell;
	data['ftCell']=ftCell;

	data['$left'] = data['$row'].next().next().next().next();
	data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');
	data['$left_template'] = $('#othertab tbody tr').clone();
	data['$right_template'] = $('#othertab tfoot tr').clone();

	data['$right_template'].each(function(){
		var $tds = $(this).find('td');
		for(var i=0, el; el=list_hidden_td[i]; i++){
			$tds.eq(el.cellIndex).addClass('dn');
		}
		for(var i=0, el; el=list_nhide_td[i]; i++){
			$tds.eq(el.cellIndex).addClass('nhide');
		}
	});
	data['$left_template'].on('mouseenter mouseleave', over_table_eve).eq(0).off('click').find('span.pin').css({'cursor':'pointer'}).on('click', event_refAMData_click);
	data['$left_template'].eq(0).removeClass('cp').find('td:first div:first').css({'margin-left': '114px'})
						.find('span.mark_img').addClass('mark_b').removeClass('p');
						
	data['$right_template'].on('mouseenter mouseleave', over_table_eve);
	
	asyncEachSeries_Original(data['list_result'], function(item, call){

		var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true);
		$lClone.addClass( (item['id']+' '+data['data-v1']+' '+data['data-v2']+' '+data['data-v3']) ).eq(0)
				.attr({'data-v1': data['data-v1'], 'data-v2': data['data-v2'], 'data-v3': data['data-v3'], 'data-v4': item['id'],
						'title': item['name'], 'data-root': 'root007', 'data-cbc': data['data-cbc'], 'data-accnumber': item['accnumber']})
				.find('span.scell').html( item['name'] );
	
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
			$(this).attr(attr).html( Globalize.format(attr['data-old'], 'n') );
		});
	}
	
}
;function appendElementProduct_level4(data, callBack, callBackEnd){
	
	var monthCell={}, cellMonth={}, $head=$('#tab_head_list td'), 
		list_hidden_td=$head.filter('.dn').toArray(), list_nhide_td=$head.filter('.nhide').toArray(),
		ftCell=$head.filter('.crtQtotal')[0].cellIndex-1;
	
	$head.each(function(){
		cellMonth[this.cellIndex] = this.getAttribute('data-date');
		monthCell[this.getAttribute('data-date')] = this.cellIndex;
	});
	data['cellMonth'] = cellMonth;
	data['monthCell'] = monthCell;
	data['ftCell']=ftCell;

	data['$left'] = data['$row'].next().next().next().next().next();
	data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');
	data['$left_template'] = $('#productcode tbody tr').clone();
	data['$right_template'] = $('#productcode tfoot tr').clone();

	data['$right_template'].each(function(){
		var $tds = $(this).find('td');
		for(var i=0, el; el=list_hidden_td[i]; i++){
			$tds.eq(el.cellIndex).addClass('dn');
		}
		for(var i=0, el; el=list_nhide_td[i]; i++){
			$tds.eq(el.cellIndex).addClass('nhide');
		}
	});
	data['$left_template'].on('mouseenter mouseleave', over_table_eve).eq(0).attr({'data-root': 'root44'})
				.on('click', {$divbody: $('#div_body')}, clickLeftTable_eve).find('span.pin').on('click', event_refAMData_click);
	data['$right_template'].on('mouseenter mouseleave', over_table_eve);

	asyncEachSeries_Original(data['list_result'], function(item, call){

		var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true);
		$lClone.addClass( (item['id']+' '+data['data-v1']+' '+data['data-v2']+' '+data['data-v3']+' '+data['data-v4']+'_gpl') ).eq(0)
				.attr({'data-v1': data['data-v1'], 'data-v2': data['data-v2'], 'data-v3': data['data-v3'], 'data-v4': data['data-v4'],
						'title': item['name'], 'data-v5': item['id'], 'data-cbc': data['data-cbc'], 'data-accnumber': item['accnumber']})
				.find('span.scell').html( item['name'] );

		setFieldValue($rClone.eq(0).find('td:gt('+(data['ftCell'])+')'), data, item['map_type_FC']['csFC']);	
		setFieldValue($rClone.eq(1).find('td:gt('+(data['ftCell'])+')'), data, item['map_type_FC']['pmFC']);
		if(item['isHighLighted']){
			$lClone.eq(0).find('td:first div:first').before('<div class="highLighted"></div>');
		}
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
			$(this).attr(attr).html( Globalize.format(attr['data-old'], 'n') );
		});
	}
	
}
;function appendElementPart_level5(data, callBack, callBackEnd){
	
	var monthCell={}, cellMonth={}, $head=$('#tab_head_list td'), 
		list_hidden_td=$head.filter('.dn').toArray(), list_nhide_td=$head.filter('.nhide').toArray(), 
		ftCell=$head.filter('.crtQtotal')[0].cellIndex-1;
	
	$head.each(function(){
		cellMonth[this.cellIndex] = this.getAttribute('data-date');
		monthCell[this.getAttribute('data-date')] = this.cellIndex;
	});
	data['cellMonth'] = cellMonth;
	data['monthCell'] = monthCell;
	data['ftCell']=ftCell;

	data['$left'] = data['$row'].next().next().next().next().next();
	data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');
	data['$left_template'] = $('#parttab tbody tr').clone();
	data['$right_template'] = $('#parttab tfoot tr').clone();

	data['$right_template'].each(function(){
		var $tds = $(this).find('td');
		for(var i=0, el; el=list_hidden_td[i]; i++){
			$tds.eq(el.cellIndex).addClass('dn');
		}
		for(var i=0, el; el=list_nhide_td[i]; i++){
			$tds.eq(el.cellIndex).addClass('nhide');
		}
	});
	data['$left_template'].on('mouseenter mouseleave', over_table_eve).eq(0).removeClass('cp')
				.find('div.dpd_4').addClass('dpd_5').removeClass('dpd_4')
				.find('span.cellbox.fcell').addClass('pin spin').on('click', event_refAMData_click)
				.css({'cursor':'pointer'}).removeClass('fcell').html('&nbsp;');
	
	data['$right_template'].on('mouseenter mouseleave', over_table_eve);

	asyncEachSeries_Original(data['list_result'], function(item, call){

		var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true);
		$lClone.addClass( (item['id']+' '+data['data-v1']+' '+data['data-v2']+' '+data['data-v3']+' '+data['data-v4']+'_gpl '+data['data-v5']) ).eq(0)
				.attr({'data-accnumber': data['data-accnumber'], 'data-cbc': data['data-cbc'], 'title': ('[ '+item['name']+' ]-'+item['snumber']), 'data-v6': item['id'], 'data-v5': data['data-v5'],
						'data-root': 'root6', 'data-v4': data['data-v4'], 'data-v3': data['data-v3'], 'data-v2': data['data-v2'], 'data-v1': data['data-v1']})
				.find('span.scell').html( '[ '+item['name']+' ]-'+item['snumber'] );

		setFieldValue($rClone.eq(0).find('td:gt('+(data['ftCell'])+')'), data, item['map_type_FC']['csFC']);
		setFieldValue($rClone.eq(1).find('td:gt('+(data['ftCell'])+')'), data, item['map_type_FC']['pmFC']);

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
			$(this).attr(attr).html( Globalize.format(attr['data-old'], 'n') );
		});
	}
	
}
;function setMatchCell(quarter_month){
	var $tab_heads=$('#tab_head_list td');
	$tab_heads.filter('.qtotalCls').each(function(){
    	var $this=$(this), quarter=$this.attr('data-date'), list_monts=$this.attr('data-months').split(','), s={};
    	for(var i=0, month; month=list_monts[i]; i++){
    		quarter_month['month_cell'][month]=this.cellIndex;
    		s[month]={'quarter':quarter, 'cell':$tab_heads.filter('[data-month="'+month+'"]').index(), 'isQcell': $this.hasClass('qcell'), 'isCurrent': $this.hasClass('crtQtotal')};
    	}
    	quarter_month['quarter_cell'][this.cellIndex]=s;
    });
}

;function setHideForecastHead($right_tr){
	$('#tab_head_list td.dn').each(function(){
        $right_tr.find('td:eq('+this.cellIndex+')').addClass('dn');
    });
}

;function formatFC(isInput, fc, $tds, data_cell, inputCls){
	if(isInput){
		var point='n', _disabled = (inputCls == 'cbc2' ? 'disabled="disabled"' : '');
    	for(var f in fc){
    		$tds.eq(data_cell[f]).html('<input type="text" '+_disabled+' data-type="'+inputCls+'" value="'+
    										Globalize.format(fc[f], point)+'" class="inputcls '+inputCls+' "/>');
    	}
    	return;
	}
	for(var f in fc){
		$tds.eq(data_cell[f]).text(Globalize.format(fc[f], 'n'));
	}
}

;function complete_saveForecast(result, event, data){
	var isError = false;

	if(event.status){
		isError=false;
    }else{
    	isError=true;
    	data['msg'] = event;
		SAVE_ERRORS.push(data);
    }
    
    _queueTask.push({name: (data['data']['bar'].progressbar("value") || 0), run: function(cb){
	    var percent=parseFloat(data['data']['bar'].attr('data-value')), max=data['data']['max'];
	    
	    percent = ($.isNumeric(percent) ? percent : 0), 
	    percent = (data['data']['percent']+percent);

	    max = (Math.round(percent) >= data['data']['max'] ? 100 : percent);
		data['data']['bar'].attr('data-value', percent).progressbar("value", max).find('div.progress-label').html(max.toFixed(2)+'%');
		progressStatusText((isError ? '#prg_err' : '#prg_scues'));	
        cb(null);
    }}, function(err){ });
    
    ;function progressStatusText(_id){
    	$(_id).html(function(){
			var t = parseInt($.trim(this.innerHTML), 10);
			return ($.isNumeric(t) ? (t+1) : 0);
		});
    }
}

;function addReloadButton(data, event, reloadButtonEventCallBack){

    var el_reload = '<span class="reload_span"><span class="reload_img"></span><b class="reload_msg" style="display:none;">'+event['message']+'</b></span>';
    data.$row.removeClass('ready done').find('td:first').prepend(el_reload)
			.parent().find('span.reload_img').off('mouseenter mouseleave click')
            .on('mouseenter mouseleave click', {$data: data}, reloadButtonEventCallBack);
    rowUnLock(data['rowIndex']);
}
;function addReloadTotalButton(data, event, reloadButtonEventCallBack){

	data['$pin'].addClass('reload_img').removeClass('pin').off('mouseenter mouseleave click')
				.on('mouseenter mouseleave click', {$data: data}, reloadButtonEventCallBack)
				.append('<b class="reload_msg" style="display:none;">'+event['message']+'</b>');
}

;function saveGAMForecast(target){
	
	if(!$.isEmptyObject(STATIC_VAR)){
		art.dialog({
	        title:' ', lock:true, dblclick_hide:false, esc:false, id: 'countsid',
	        content: CUSTOM_LABEL['clickwait'],
	        button : [ {value: 'Ok', focus: true, callback: function(){  }} ]
	    });
		return;
	}
	
	SAVE_ERRORS = [];
	
	$('div.progress_cls').show();
	var list_save=[], o_cell = {}, territoryCode=getTerritoryCode(), map_year_quartersFuture=getQuarterFuture(),
		qNumber=getQuarterNumber(), $left_trs=$('#ltabid tr'), $right_trs=$('#rtabid tr'),
		$pBar=$("#progressbar").progressbar({ value: false }).attr('data-value', 0);	
	
	$('#tab_head_list td.qcell').each(function(){
		o_cell[this.cellIndex] = this.getAttribute('data-date');
	});
	
//	findForecastAccount(list_save);
	findForecastGpl(list_save)
	findForecastOthers(list_save);

	if(list_save.length == 0){ 
		$('div.progress_cls').hide();
		return; 
	}
	
	var o_bar=getBarColor(list_save);
	
	$pBar.progressbar({ max: o_bar['max'], change: progressbarChange, complete: progressbarComplete })
				.find('.ui-progressbar-value').css({ "background": o_bar['bgcolor'] });
				
	asyncEachSeries_Original(list_save, function(item, callback){
		item['data']['percent'] = o_bar['percent'];
		item['data']['max'] = o_bar['max'];
        customRemoteAction(item, saveGAMFC_js, complete_saveForecast); //this is remote action
    }, function(err){ }, 180);
    
	$('#progresserror').css({'background': o_bar['rgba'], 'top': '-20%'}).animate({top: '10%'}, 360, animateComplete);

	/* START save forecast Helper methods*/

	;function animateComplete(){
		$('#prg_total').html( list_save.length );
		$('#prg_scues').html(0);
		$('#prg_err').html(0);
	}
	;function findForecastAccount(list_save){	//account create
		$left_trs.filter('.rt1').each(function(){
			var json_map={}, json_act = {'className': 'ClsAPLEntityTypes.GAMAcctFCInfo', 'str_json': {}},
				aid=this.getAttribute('data-aid'), $tds=$right_trs.eq(this.rowIndex).find('td');

			setActForecastValues(json_map, $tds);
			json_act['str_json'] = create_acct_json(aid, qNumber, json_map, map_year_quartersFuture);
			list_save.push( {'json': JSON.stringify(json_act), 'data': {'json': json_act, 'bar': $pBar, 'name': $(this).find('span.scell').text()}} );
		});
	}
	
	;function findForecastGpl(list_save){		//gpl create
		$left_trs.filter('.rt3:not(.relay_cbc)').each(function(){
			var json_map={}, json_act = {'className': 'ClsAPLEntityTypes.GAMGPLFCInfo', 'str_json': {}},
				aid=this.getAttribute('data-aid'), gid=this.getAttribute('data-gid'), cbc2Code=this.getAttribute('data-code'),
				$tds=$right_trs.eq(this.rowIndex).find('td'), list_part=[];

			setForecastValues(json_map, $tds);
			set_gpl_part($left_trs, this, aid, gid, list_part);
			
			json_act['str_json'] = create_gpl_json(aid, gid, cbc2Code, qNumber, json_map, map_year_quartersFuture, list_part);

			list_save.push( {'json': JSON.stringify(json_act), 'data': {'json': json_act, 'bar': $pBar, 'name': $(this).find('span.scell').text()}} );
		});
	}
	;function findForecastOthers(list_save){	//others create
		$left_trs.filter('.rt2[data-code="Others"]').each(function(){
			var json_map={}, json_act = {'className': 'ClsAPLEntityTypes.GAMGPLFCInfo', 'str_json': {}},
				cbcCode=this.getAttribute('data-code'), aid=this.getAttribute('data-aid'), 
				$tds=$right_trs.eq(this.rowIndex).find('td'), list_part=[];

			setForecastValues(json_map, $tds);
			
			if(!$left_trs.filter('.rt1.'+this.getAttribute('data-regioncls')+'.'+aid).hasClass('done')){
				return true;	//continue for each.
			}
			
		//create_other_part_json(aid, qNumber, json_map, map_year_quartersFuture, pid);
		//	list_part.push(str_json);	
		//	set_Other_part($left_trs, this, aid, list_part);
			
			list_part.push( create_other_part_json(null, null, json_map, map_year_quartersFuture, null) );
			
			json_act['str_json'] = create_other_json(aid, cbcCode, qNumber, json_map, map_year_quartersFuture, list_part);
			list_save.push( {'json': JSON.stringify(json_act), 'data': {'json': json_act, 'bar': $pBar, 'name': $(this).find('span.scell').text()}} );
		});
	}

	;function getAcctId(aid){ return (aid == 'customother' ? OTHER_LABEL : aid); }
	;function getTerritoryCode(){ return $.trim($('[id*=hidd_territorycodeid]').val()); }
	;function getQuarterFuture(){ return $.trim($('[id*=hidd_yearfutureid]').val()); }
	;function getQuarterNumber(){ return $.trim($('[id*=hidd_quarternumbid]').val()); }
	
	;function set_Other_part($left_parts, target, aid, list_part){
		var list_parts=$left_parts.filter('.rt4.'+target.getAttribute('data-regioncls')+'.'+aid+'.'+target.getAttribute('data-cbc-num')).toArray();
		while(list_parts.length > 0){
			var _part=list_parts.shift(), $part=$(_part), json_map={}, str_json={},
				aid=_part.getAttribute('data-aid'), pid=_part.getAttribute('data-pid'),
				$tds=$right_trs.eq(_part.rowIndex).find('td');

			setForecastValues(json_map, $tds);
			str_json = create_other_part_json(aid, qNumber, json_map, map_year_quartersFuture, pid);
			list_part.push(str_json);
		}
	}
	;function set_gpl_part($left_parts, target, aid, gid, list_part){

		var cls=('.rt4.'+target.getAttribute('data-regioncls')+'.'+gid+'_gpl.'+aid+'.'+target.getAttribute('data-cbc-num') ),
			list_parts=$left_parts.filter(cls).toArray();

		while(list_parts.length > 0){
			var _part=list_parts.shift(), $part=$(_part), json_map={}, str_json={},
				aid=_part.getAttribute('data-aid'), pid=_part.getAttribute('data-pid'),
				$tds=$right_trs.eq(_part.rowIndex).find('td');
			setForecastValues(json_map, $tds);
			str_json = create_gpl_part_json(aid, gid, pid, qNumber, json_map, map_year_quartersFuture);
			list_part.push(str_json);
		}
	}
	
	;function setForecastValues(json_map, $tds){
		for(var o in o_cell){
			json_map[o_cell[o]] = numberOfZero($.trim($tds.eq(o).find('input[type="text"]').val()));
		}
	}
	;function setActForecastValues(json_map, $tds){
		for(var o in o_cell){
			json_map[o_cell[o]] = numberOfZero($.trim($tds.eq(o).text()));
		}
	}
	
	;function create_acct_json(parentId, quarterNumb, map_dateKey_fc, map_year_quartersFuture){
		return '{"acctId": "'+parentId+'", "quarterNumb": "'+quarterNumb+'", "map_dateKey_fc": '+JSON.stringify(map_dateKey_fc)+', "map_year_quartersFuture": '+map_year_quartersFuture+'}';
	}
	
	;function create_other_json(parentId, cbcCode, quarterNumb, map_dateKey_fc, map_year_quartersFuture, list_part){
		return '{"acctId": "'+parentId+'", "cbc2Code": "'+cbcCode+'", "quarterNumb": "'+quarterNumb+'", "gplId": "null", "map_dateKey_fc": '+JSON.stringify(map_dateKey_fc)+', "map_year_quartersFuture": '+map_year_quartersFuture+
				', "list_parts" : ['+list_part.join(',')+'] }';
	}
	
	;function create_gpl_json(parentId, gid, cbc2Code, quarterNumb, map_dateKey_fc, map_year_quartersFuture, list_part){
		return '{"acctId": "'+parentId+'", "gplId": "'+gid+'", "cbc2Code": "'+cbc2Code+'", "quarterNumb": "'+quarterNumb+'", "map_dateKey_fc": '+JSON.stringify(map_dateKey_fc)+', "map_year_quartersFuture": '+map_year_quartersFuture+
				', "list_parts" : ['+list_part.join(',')+'] }';
	}
	
	;function create_gpl_part_json(parentId, gid, pid, quarterNumb, map_dateKey_fc, map_year_quartersFuture){
		return '{"acctId": "'+parentId+'", "gplId": "'+gid+'", "partId": "'+pid+'", "quarterNumb": "'+quarterNumb+'", "map_dateKey_fc": '+JSON.stringify(map_dateKey_fc)+', "map_year_quartersFuture": '+map_year_quartersFuture+'}';
	}
	;function create_other_part_json(parentId, quarterNumb, map_dateKey_fc, map_year_quartersFuture, partId){
		return '{"acctId": "'+parentId+'", "quarterNumb": "'+quarterNumb+'", "map_dateKey_fc": '+JSON.stringify(map_dateKey_fc)+', "map_year_quartersFuture": '+map_year_quartersFuture+
				', "partId": "'+partId+'" }';
	}

	/* END save forecast Helper methods*/
}
;function reSaveForecast(target){
	var $pBar = $("#progressbar").progressbar('destroy').attr('data-value', 0), list_save=SAVE_ERRORS.slice(0),
		o_bar=getBarColor(list_save);
	
	SAVE_ERRORS=[];
	setPopBoxStatus();
	$pBar.find('div.progress-label').html('Loading...');
	$('#progresserror').css({ "background": o_bar['rgba'] });
	$('#prg_total').html(list_save.length);
	
	$pBar.progressbar({ value:false, max: o_bar['max'], change: progressbarChange, complete: progressbarComplete })
			.find('.ui-progressbar-value').css({ "background": o_bar['bgcolor'] });
	asyncEachSeries_Original(list_save, function(item, callback){
		item['data']['percent'] = o_bar['percent'];
		item['data']['max'] = o_bar['max'];
        customRemoteAction(item, saveGAMFC_js, complete_saveForecast); //this is remote action
    }, function(err){ }, 180);
    
    
	;function setPopBoxStatus(){
		setTimeout(function(){
			$('#showerror').animate({'top': '-220%'}, 360, function(){
				$(this).find('#errtabbody tr').remove();
			});
			$('#progressbarbtn_div').hide().find('input[type="button"].errors').remove();
			$('#prg_scues').html(0);
			$('#prg_err').html(0);
		}, 60);
	}
}


    
;function getBarColor(list_save){
	var percent=(1 / list_save.length * 100), max=Math.floor(percent*list_save.length), 
		bg_color=Math.floor( Math.random()*16777215 ).toString(16), list_rgba=$.Color('#'+bg_color)._rgba, 
		rgba=( 'rgba('+list_rgba[0]+','+list_rgba[1]+','+list_rgba[2]+',0.3)' );
	return {'percent': percent, 'max': max, 'bgcolor': ('#'+bg_color), 'rgba': rgba};
}


;function showForecastErrors(target){

	var $body = $('#errtabbody'), $tmp_tr=$('#tmperrtab tr').clone();
	$body.find('tr').remove();
	for(var i=0, error; error = SAVE_ERRORS[i]; i++){
		var $t = $tmp_tr.clone();
		$t.find('td').eq(0).text(error['data']['name']);
		$t.find('td').eq(1).text(error['msg']['message']);
		$body.append($t);
	}
	$('#showerror').animate({'top': '20.2%'}, 360);
}
;function closeErrorBox(target){
	$('#showerror').animate({'top': '-120%'}, 360, function(){
		$(this).find('#errtabbody tr').remove();
	});
}

;function closeProgressBox(target){
	$('#showerror').animate({'top': '-120%'}, 360, function(){
		$(this).find('#errtabbody tr').remove();
	});
	$('#progresserror').animate({'top': '-20%'});
	$('#progressbarbtn_div').hide();
	$('#saveProgressCoverBox').fadeOut(function(){
		$(this).find('#progressbar').progressbar('destroy').find('div.progress-label').html('Loading...');
	});
	$('#saveProgressCover').fadeOut();
}

;function progressbarChange(event, ui){
}

;function progressbarComplete(event, ui){
	var t = parseInt($.trim($('#prg_err').html()), 10), $prog_btn=$('#progressbarbtn_div');
	$prog_btn.find('input[type="button"].errbtn').remove();

	if($.isNumeric(t) && t > 0){
		$prog_btn.prepend('<input value="Show errors" onclick="showForecastErrors(this)" class="btn errbtn" type="button" /><input onclick="reSaveForecast(this)" value="Re save forecast" class="btn errbtn" style="margin: 0 10px;" type="button"/>');
	}
	$('#progressbarbtn_div').show();
	
}


;function reloadTotalFC_eve(e){
    e.stopPropagation();
    
    var _data = e.data.$data, _this=this, $this=$(_this);
    
    eventHandle(e, ov, ot, click);
    
    ;function ov(){ _data['$pin'].find('b').show(); }
    ;function ot(){ _data['$pin'].find('b').hide(); }
    ;function click(){
    	_data['$pin'].addClass('pin').removeClass('reload_img').find('b').remove();
        _data['$pin'].off('mouseenter mouseleave click').on('click', clickLeftPin_eve);
        customRemoteAction(_data, getGAMRefData, complete_GAMRefTotalFC);
    }
}
;function reloadAcctFC_eve(e){
    reload_public_eve(e, this, searchAcctFC_js, complete_searchAcctFC); //this account remote action
}
;function reloadCBC2FC_eve(e){
    reload_public_eve(e, this, searchAcctFC_js, complete_searchCBC2FC); //this account cbc2 action
}
;function reloadGPLFC_eve(e){
    reload_gpl_eve(e, this, searchAcctFC_js, complete_searchGPLFC); //this account gpl action
}
;function reloadPartFC_eve(e){
    reload_public_eve(e, this, searchAcctFC_js, complete_searchPartFC); //this account gpl action
}

;function reload_gpl_eve(e, target, searchRemoteAction, complete_searchRemoteAction){
    e.stopPropagation();
    
    var _data = e.data.$data, _this = target, $this = $(_this), $span=$this.parent(),
        $td=$span.parent().parent(), $tr=$td.parent();

    eventHandle(e, ov, ot, click);
    
    ;function ov(){ 
        if(navigator.userAgent.indexOf("Firefox")>0){
            $span.find('b').css({'left': 40}).show(); 
        }else{
            $span.find('b').show(); 
        }
    }
    ;function ot(){ $span.find('b').hide(); }
    ;function click(){
        $('#refdatastatusid').show();
        rowIsLocked(_data['rowIndex']);
        $tr.addClass('ready');
        $td.find('span.fcell').addClass('waiting');
        $this.off('mouseenter mouseleave click').parent().remove();
        customRemoteAction(_data, searchRemoteAction, complete_searchRemoteAction);
    }
}
;function reload_public_eve(e, target, searchRemoteAction, complete_searchRemoteAction){
    e.stopPropagation();
    
    var _data = e.data.$data, _this = target, $this = $(_this), $span=$this.parent(),
        $td=$span.parent().parent(), $tr=$td.parent();

    eventHandle(e, ov, ot, click);
    
    ;function ov(){ 
        if(navigator.userAgent.indexOf("Firefox")>0){
            $span.find('b').css({'left': 40}).show(); 
        }else{
            $span.find('b').show(); 
        }
    }
    ;function ot(){ $span.find('b').hide(); }
    ;function click(){
        rowIsLocked(_data['rowIndex']);
        $tr.addClass('ready');
        $td.find('span.fcell').addClass('waiting');
        $this.off('mouseenter mouseleave click').parent().remove();
        customRemoteAction(_data, searchRemoteAction, complete_searchRemoteAction);
    }
}

;function over_pinRefStatus_eve(e){
	var $this=$(this), $refDiv=$this.parent().parent().find('div.refs_d');
	
	eventHandle_ov_ot(e, ov, ot);
    
    ;function ov(e){ $refDiv.show(); }
    ;function ot(e){ 
    	window.clearTimeout(t);
		var t = window.setTimeout(doHide,160);
	}
	
	;function doHide(){
		if(!$refDiv.hasClass('overg')){ $refDiv.hide(); }
	}
}
;function over_refStatus_eve(e){
	var $this=$(this);
	
	eventHandle_ov_ot(e, ov, ot);
    
    ;function ov(e){ $this.addClass('overg'); }
    ;function ot(e){ $this.removeClass('overg').hide(); }
}

;function over_refErrorMsg_eve(e){
	var $this=$(this), $msg=$this.find('b');
	
	eventHandle_ov_ot(e, ov, ot);
    
    ;function ov(e){ $msg.show(); }
    ;function ot(e){ $msg.hide(); }
}

;function over_table_eve(e){
    var $this=$(this), _idx=$this.index(), findTab=($this.parent().hasClass('ltbodycls') ? '#rtabid tr' : '#ltabid tr.lefttrs');
    eventHandle_ov_ot(e, ov, ot);
    
    ;function ov(e){ $(findTab).eq(_idx).addClass('overbodybg'); }
    ;function ot(e){ $(findTab).eq(_idx).removeClass('overbodybg'); }
}

;function windowReSize(e){
    $('#forecastdiv_id').css({'visibility': 'hidden'});
    fixAMTableLayout($('#tabContainer').width(), false);
}
;function rCellScroll_eve(e){
	var scLeft=this.scrollLeft;
    if (TIMEOUT){ clearTimeout(TIMEOUT) };
    document.getElementById('right_head').scrollLeft = scLeft;
    TIMEOUT = setTimeout(function(){
	    document.getElementById('floatscroll').scrollLeft = scLeft;
    }, 120);
}


;function appendExpand_Collapse(){//append (expand or collapse)
    var $td_cells = $('#tab_head_list td.exp_coll');
    $td_cells.off('click').on('click', cellExpand_Collapse_eve)
             .find('div').append('<b class="exp_coll_box collapse">-</b>');
        
    $td_cells.each(function(idx){ if(idx < 4){ $(this).triggerHandler('click'); } });    
}

;function cellExpand_Collapse_eve(e){
	
	if(!$.isEmptyObject(STATIC_VAR)){
		return false;
	}
	
	
    var $this=$(this), $b=$this.find('b'), _c1=(this.cellIndex), $cols=$('#rsmcolspanid'),
        fn={'excute':($b.hasClass('expand') ? expand : collapse)};
	
    fn.excute($('#tab_head_list, #rTabDataId tr').toArray());
    fixAMTableLayout();
    
    ;function expand(list_el){

        while(list_el.length > 0){
            var item = list_el.shift();
            $(item.cells[_c1-1]).removeClass('dn');
            $(item.cells[_c1-2]).removeClass('dn');
            $(item.cells[_c1-3]).removeClass('dn');
        }
        if($this.hasClass('crtQtotal')){
        	$('#tab_head_data th.th_current div.current_cls').removeAttr('style');
        }
        if($this.hasClass('firstHistory')){
        //	$this.removeAttr('style').parent().find('td:eq(0)').css('border-left', '1px solid #fff');
        }
        $b.removeClass('expand').addClass('collapse').html('-');
        $this.prev().prev().prev().prev().removeClass('exp_right');
        hasCurrentQtotal(3);
    }
    
    ;function collapse(list_el){
        while(list_el.length > 0){
            var item = list_el.shift();
            item.cells[_c1-1].className += ' dn';
            item.cells[_c1-2].className += ' dn';
            item.cells[_c1-3].className += ' dn';
        }
        if($this.hasClass('crtQtotal')){
        	$('#tab_head_data th.th_current div.current_cls').css('width', '65px');
        }
        if($this.hasClass('firstHistory')){
        //	$this.css('border-left', '1px solid #017598');
        }
        $b.removeClass('collapse').addClass('expand').html('+');
        $this.prev().prev().prev().prev().addClass('exp_right');
        hasCurrentQtotal(-3);
    }
    ;function hasCurrentQtotal(pos){
        var $td_data = $('#tab_head_data th:eq('+(($this.hasClass('crtQtotal') ? 1 : 0))+')'), t = $td_data.prop('colspan');
        $td_data.prop('colspan', pos+t);
    }
    ;function hasHistorical(s){
        if(!$td.hasClass('futurec1')){
            var $th_head=$cols.find('th:first'),  t = $th_head.prop('colspan');
            $th_head.prop('colspan', t+s);
        }
    }
}

;function fixAMTableLayout(resize_width){
    try{
        var $compbody=$('#forecastdiv_id'), min_cw= parseInt($compbody.css('min-width').replace('px', ''), 10), 
            max_ow=(typeof(resize_width) != 'undefined' ? resize_width : $('#contentallid').outerWidth(true));
    
        min_cw = (max_ow < min_cw ? min_cw : (max_ow-40));
        
        document.getElementById('contentallid').style.width = (min_cw)+'px';    //set all div width
    
        var lCellw=$compbody.find('#left_body').width(), window_h = $(window).height(),
            rightCell_w=parseInt((min_cw-lCellw-2), 10),
            usedHeight = ($('#dmsgid').outerHeight(true) + $('#AppBodyHeader').outerHeight(true) + $('div.bPageFooter.noTableFooter').outerHeight(true) + 50),
            v_height= (window_h - usedHeight - 90);
        
    
        document.getElementById('rCellScroll').style.width = rightCell_w+'px';
        document.getElementById('right_head').style.width = rightCell_w+'px';
        $('#floatscroll').css({'width': rightCell_w, 'left': $('#rCellScroll').offset()['left']}).find('#innerData').css('width', $('#rTabDataId').width());
        $compbody.css('visibility', 'visible');
    }catch(e){
        
    }
/*
    document.getElementById('right_head').style.width = (rightCell_w-scrollbarW-1)+'px';
    if($compbody.find('#lcellbody div.nodata').length != 3){
        document.getElementById('rCellScroll').style.height = v_height+'px';
        document.getElementById('left_body').style.height = (v_height+1-scrollbarW-0.7)+'px';
    }else if(isHeight){
        document.getElementById('rCellScroll').style.height = v_height+'px';
        document.getElementById('left_body').style.height = (v_height+1-scrollbarW-0.7)+'px';
    }
*/
    
}

;function finalFormat(){
	var o_cell={}, o_total={}, $head_td_list=$('#tab_head_list td'), $r_tab_trs=$('#rtabid tr'), 
		$total_trs=$r_tab_trs.filter('.trt_0'), $l_tab_trs=$('#ltabid tr');
	
	$l_tab_trs.filter('.fc2MAccuracy, .fc3MAccuracy, .fc6MAccuracy').each(function(){
		$r_tab_trs.eq(this.rowIndex).addClass('nhide');
		$(this).addClass('nhide');
	});
		
	$head_td_list.filter('.qtotalCls').each(function(){
		o_cell[(this.getAttribute('data-date'))]=this.cellIndex;
	});
	
	$total_trs.filter('.relayfctotal').each(function(){
		var $this=$(this), $tds=$this.find('td'), oJson=$.parseJSON(this.getAttribute('data-total'));
		for(var oYear in oJson){
			var t=o_total[o_cell[oYear]];
			o_total[o_cell[oYear]] = (getZeroOfNumber(t)+oJson[oYear]);
			$tds.eq(o_cell[oYear]).html(Globalize.format(oJson[oYear], 'n'));
		}
	});
	
	for(var cell in o_total){
		$total_trs.filter('.fctotal').find('td:eq('+cell+')').html( Globalize.format(o_total[cell], 'n') );
	}
	
    //$head_td_list.filter('.qtotalCls:first').addClass('firstHistory').css('border-left', '1px solid #017598');
	document.getElementById('loading-curtain-div').style.display = 'none';
}

;function cancelGroup(target){
    document.getElementById('loading-curtain-div').style.display='';
    window.location.href='/home/home.jsp';
}

;function backForecast_eve(target, _url) {
    document.getElementById('loading-curtain-div').style.display = '';
    if(_url == ''){
        backForecast();     //this is CtrlAccountGrouping.cls action function
        return;
    }
    window.location.href = _url;
}

;function backForecastComplete(){
    if($('#sidebarCell').hasClass('sidebarCollapsed')){
        try{
            document.getElementById('handlebarContainer').click(); 
        }catch(e){ }
    }
    setTerritoryCode();     //this is CtrlAccountGrouping.cls action function
    reloadDocument();   //used the CtrlAccountGroupingJs.Resource
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

;function iegtTenShow(){
	var browser=isMSIE();
	if(browser['isTheBrowser'] && browser['actualVersion'] < 10){
		document.getElementById('loading-curtain-div').style.display = '';
	}
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

;function customMultipleRemoteAction(strParam, callFunction, callResult) {
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
;function generateUID(separator) {
    var delim = separator || "_";

    function S4() {
        return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
    }

    return (S4() + S4() + delim + S4() + delim + S4() + delim + S4() + delim + S4() + S4() + S4());
};
;function addListener (element, event, fn, params) {
    var eventHandler = ( params ? function(){ fn.call(params); } : fn );
    if (window.attachEvent) {
        element.attachEvent('on' + event, eventHandler);
    } else {
        element.addEventListener(event, eventHandler, false);
    }
}