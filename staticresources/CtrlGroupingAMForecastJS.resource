var TIMEOUT, scrollbarW = $.getScrollbarWidth(), IS_SUBMIT=false, TOP_FIRST=true, STATIC_VAR = {}, SAVE_PART=[], SAVE_ERRORS=[], 
	WORK_CLS={
		'other': 'APL_ClsAMService.SearchLevelOther', 'level1': 'APL_ClsAMService.SearchLevel1',
		'level2': 'APL_ClsAMService.SearchLevel2', 'level3': 'APL_ClsAMService.SearchLevel3',
		'level4': 'APL_ClsAMService.SearchLevel4', 'level5': 'APL_ClsAMService.SearchLevel5'
	},
	_queueTask = async.queue(queueTask, 1);

;function queueTask(task, callback) {
    task.run(callback);
}

;function initCtrlDocument(){
    Globalize.culture(this.locale).numberFormat.currency.symbol = "";
    initAMDocument();
}

;function initAMDocument(){
	$('div.removeRowNumCls').remove();
	$('input._false_').remove();
    $('#floatscroll').css({'height': scrollbarW, 'line-height': scrollbarW});
    appendExpand_Collapse();
    registerAM_event();
    fixAMTableLayout();
    finalFormat();
    document.getElementById('loading-curtain-div').style.display = 'none';
}


;function init_multiselect(){
	$.uix.multiselect.i18n["custom_i18n"] = {
	    itemsSelected_nil: 'selected option',          // 0
    	itemsSelected: 'selected option',          // 0, 1
    	itemsSelected_plural: 'selected option',  // n
    	itemsAvailable_nil: 'items available',
    	itemsAvailable: 'items available',
    	itemsAvailable_plural: 'items available',
    	itemsFiltered_nil: '0 options found',
    	itemsFiltered: '{count} option found',
    	itemsFiltered_plural: '{count} options found'
	};
    var defaultOptions = {
            availableListPosition: 'left', moveEffect: 'blind', moveEffectOptions: {direction:'vertical'}, moveEffectSpeed: 'fast'
        },
        widgets = {
            'simple': $.extend($.extend({}, defaultOptions), { sortMethod: 'standard', sortable: true })
        };
    
    var $multiselect = $('#multiselect_simple').multiselect(widgets['simple'])
        .on('multiselectChange', function(evt, ui) {

            var values = $.map(ui.optionElements, function(opt) { return JSON.stringify({'partDesc': $(opt).attr('data-desc'), 'partName': $(opt).attr('data-name'), 'partId': $(opt).attr('value')}); });
            if(ui['selected']){ while(values.length >0){ SAVE_PART.push(values.shift()); }}
            else{
                var list_new=[], list_old=SAVE_PART.slice(0);
                SAVE_PART=[];
                while(values.length > 0){
                	var dPart=values.shift();
                	for(var i=0, part; part=list_old[i]; i++){
                		if(dPart != part){
                			list_new.push(part);
                		}
                	}
                }
                SAVE_PART=list_new;
            }
        }).on('multiselectSearch', function(evt, ui) { });
	$multiselect.multiselect({ locale: "custom_i18n" });
}


;function registerAM_event(){
    var $body_div = $('#div_body');//,
    //	scroll_attr={'$ghb': $('#globalHeaderBar'), '$abh': $('#AppBodyHeader'), '$menu':$('#menudivid'), '$floathead': $('#headmainid')};

    $body_div.find('tbody.overbody tr').off('mouseenter mouseleave').on('mouseenter mouseleave', over_table_eve);  
    $body_div.find('#rCellScroll').scroll(rCellScrollAM_eve)
             .find('#rtabid input[type="text"]').off('focus change').on('focus change', input_fc_eve)
             .off('keyup').on('keyup', input_keyup_eve);
    $body_div.find('#ltabid tr.cp').off('click').on('click', {$divbody: $body_div}, clickLeftTable_eve)
			 .find('span.pin').off('click').on('click', clickLeftPin_eve);
    $body_div.find('#ltabid tr.trt_trt').off('click').on('click', clickLeftTableTotal_eve);
    $('#searchpart_inputid').off('keyup').on('keyup', input_search_key_eve);
    $('#gototopid').off('mouseenter mouseleave click').on('mouseenter mouseleave click', clickGotoTop_event);
    $(window).scroll(scroll_event).smartresize(windowReSize);
    $('#menuBtntd input').off('click').on('click', event_hideAMCalendar_click);
    $('#floatscroll').off('scroll').scroll(event_floatAMScroll);
}

;function scroll_event(e){
	var x=(document.body.scrollTop||document.documentElement.scrollTop), $top=$('#gototopid');
	setTimeout(function(){
		
		var h=($(document).height() - $(window).height() - 120);
		if(x >= h){ $('#floatscroll').css({'visibility': 'hidden'}); }
		else{ $('#floatscroll').css({'visibility': ''}); }
		
		if(x<=30){$top.fadeOut().hide()}else{$top.fadeIn().show()};
		
		var xx=($('#globalHeaderBar').outerHeight()+$('#AppBodyHeader').outerHeight()+$('#menudivid').outerHeight()+$('#headmainid').outerHeight()+100);
		if((x > xx) && !$('#headmainid').hasClass('floatheadcls')){
			$('#headmainid').addClass('floatheadcls').find('td.tab_head_left ').addClass('leftbt');
		}else if(!(x > xx)){
			$('#headmainid').removeClass('floatheadcls').find('td.tab_head_left ').removeClass('leftbt');
		}
		
	}, 50);
}

;function closePopUP(target){
    $('#popupbox').stop().animate({'top':-800}, 800, function(){
        $('#popupmain').fadeOut('fast');
    });
}
;function input_fc_eve(e){
    
    var _this = this, $this = $(_this), ov = '', validation_qty = /^([1-9]\d{0,16}|0)(\.\d+)?$/, 
    //	validation_qty = /^([1-9]\d{0,16}|0)(\.\d{1,2})?$/, 
        point='n', tv = Globalize.parseFloat($.trim(_this.value)); //focus Event
    
    ov = $this.inputFocusValueFormat(validation_qty, e);

    if(e.type == 'change'){
    	/*
        if(!validation_qty.test(tv) || tv===ov){ //not changed or old value eq new value
            this.value = ( $.isNumeric(ov) ? Globalize.format(ov, point) : '' );
            return;
        }
        */
        ov = ($.isNumeric(ov) ? ov : 0);
        tv = ($.isNumeric(tv) ? tv : 0);
        
        var o_cfg = initTabInfo();
        
        _this.value = ( $.isNumeric(tv) ? Globalize.format(tv, point) : '' );

        switch(o_cfg['rowType']){
            case 'cbc2' :       sumOf_cbc(o_cfg); break;
            case 'gpl' :        sumOf_gpl(o_cfg); break;
            case 'gpl_part' :   sumOf_gpl_part(o_cfg); break;
            case 'other_part' : sumOf_other_part(o_cfg); break;
        }
    }
    
    ;function initTabInfo(){
        var o_cfg = { '$r_td': $this.parent() };
        o_cfg['$r_tr'] = o_cfg['$r_td'].parent();
        o_cfg['cellIdx'] = o_cfg['$r_td'][0].cellIndex;
        o_cfg['rowIdx'] = o_cfg['$r_tr'][0].rowIndex
        o_cfg['rowType'] = o_cfg['$r_tr'].attr('data-row-name');
        o_cfg['$r_body'] = o_cfg['$r_tr'].parent();
        o_cfg['$l_body'] = $('#ltabid');
        o_cfg['$l_tr'] = o_cfg['$l_body'].find('tr:eq('+o_cfg['rowIdx']+')');
        o_cfg['aid'] = o_cfg['$l_tr'].attr('data-aid');
        return o_cfg;
    }
    ;function sumOf_cbc(o_cfg){
        var cbc_total = 0, aCls=o_cfg['$l_tr'].attr('data-cls');
        o_cfg['$l_body'].find('tr.rt2.'+aCls).each(function(){
            var $td = o_cfg['$r_body'].find('tr:eq('+this.rowIndex+')').find('td:eq('+o_cfg['cellIdx']+')'),
            	s = (this.getAttribute('data-cbcname') == 'Relay' ? $td.text() : $td.find('input').val());
            	
            cbc_total += numberOfZero($.trim(s));
        });
        
		aCls = o_cfg['$l_body'].find('tr.rt1.'+o_cfg['aid']).index();
        o_cfg['$r_body'].find('tr:eq('+aCls+')')
                        .find('td:eq('+o_cfg['cellIdx']+')').html(Globalize.format(cbc_total, 'n'));
                        
    	if(o_cfg['$l_body'].find('tr.trt_trt').hasClass('exp')){
    		o_cfg['$l_body'].find('tr.trt_trt').addClass('col').removeClass('exp').find('span.fcell').html('+');
    		o_cfg['$l_body'].find('tr.trt_0:not(.trt_trt)').addClass('dn');
    		o_cfg['$r_body'].find('tr.trt_0:not(.trt_trt)').addClass('dn');
    	}
    }
    ;function sumOf_gpl(o_cfg){

        var gpl_total = 0, old_cbc = 0, part_total=0, aCls=o_cfg['$l_tr'].attr('data-cls'), 
        	cbcNum=o_cfg['$l_tr'].attr('data-num');
        
        o_cfg['$l_body'].find('tr.rt4.'+aCls+'.'+cbcNum+'.'+o_cfg['$l_tr'].attr('data-gcls')).each(function(){
            var s = o_cfg['$r_body'].find('tr:eq('+this.rowIndex+')').find('td:eq('+o_cfg['cellIdx']+') input[type="text"]').val();
            part_total += numberOfZero($.trim(s));
        });

        if(tv < part_total){
        	$this.val (  Globalize.format(part_total, point) ).focus();
        	return;
        }
        o_cfg['$l_body'].find('tr.rt3.'+aCls+'.'+cbcNum).each(function(){
            var s = o_cfg['$r_body'].find('tr:eq('+this.rowIndex+')').find('td:eq('+o_cfg['cellIdx']+') input[type="text"]').val();
            gpl_total += numberOfZero($.trim(s));
        });
        o_cfg['$l_cbc_tr']=o_cfg['$l_body'].find('tr.rt2.'+aCls+'.'+cbcNum+'_root');

        var $cbc_input = o_cfg['$r_body'].find('tr:eq('+o_cfg['$l_cbc_tr'].index()+')').find('td:eq('+o_cfg['cellIdx']+') input[type="text"]');
        old_cbc = numberOfZero( $.trim($cbc_input.val()) );

        if(gpl_total == 0 && tv == 0){
	        gpl_total = (ov == 0 ? 1 : ov);
        	$this.val ( ov==0 ? Globalize.format(1, point) : Globalize.format(ov, point) ).focus();
        }
        
        
        
        $cbc_input.val(Globalize.format(gpl_total, point));
        
		var index=o_cfg['$l_body'].find('tr.rt1.'+o_cfg['$l_tr'].attr('data-aid')).index();
        o_cfg['$r_body'].find('tr:eq('+index+')').find('td:eq('+o_cfg['cellIdx']+')').html(function(){
            var t = numberOfZero($.trim(this.innerHTML));
            return Globalize.format((t - old_cbc + gpl_total), 'n');
        });
        if(o_cfg['$l_body'].find('tr.trt_trt').hasClass('exp')){
    		o_cfg['$l_body'].find('tr.trt_trt').addClass('col').removeClass('exp').find('span.fcell').html('+');
    		o_cfg['$l_body'].find('tr.trt_0:not(.trt_trt)').addClass('dn');
    		o_cfg['$r_body'].find('tr.trt_0:not(.trt_trt)').addClass('dn');
    	}
    }
    ;function sumOf_gpl_part(o_cfg){
        var aCls=o_cfg['$l_tr'].attr('data-cls'), cbcNum=o_cfg['$l_tr'].attr('data-num'), gplCls=o_cfg['$l_tr'].attr('data-gcls'),
        	$left_gpl_row=o_cfg['$l_body'].find('tr.rt3.'+aCls+'.'+cbcNum+'.'+gplCls), 
        	$input=o_cfg['$r_body'].find('tr:eq('+$left_gpl_row.index()+')').find('td:eq('+o_cfg['cellIdx']+') input[type="text"]'),
        	gpl_value = numberOfZero($.trim($input.val())), p_total = 0;

        o_cfg['$l_body'].find( ('tr.rt4.'+aCls+'.'+cbcNum+'.'+gplCls) ).each(function(){
            var s = o_cfg['$r_body'].find('tr:eq('+this.rowIndex+')').find('td:eq('+o_cfg['cellIdx']+') input[type="text"]').val();
            p_total += numberOfZero($.trim(s));
        });
        if(p_total > gpl_value){
            $this.val ( $.isNumeric(ov) ? Globalize.format(ov, point) : '' ).focus().select();
        }
    }
    ;function sumOf_other_part(o_cfg){
        var aCls=o_cfg['$l_tr'].attr('data-cls'), cbcNum=o_cfg['$l_tr'].attr('data-num'),
        	$acct_row = o_cfg['$l_body'].find( ('tr.rt2.'+aCls+'.'+cbcNum+'_root') ),
            $input = o_cfg['$r_body'].find('tr:eq('+$acct_row.index()+')').find('td:eq('+o_cfg['cellIdx']+') input[type="text"]'),
            _p_value = numberOfZero($.trim($input.val())), p_total = 0;

        o_cfg['$l_body'].find( ('tr.rt4.'+aCls+'.'+cbcNum) ).each(function(){
            var s = o_cfg['$r_body'].find('tr:eq('+this.rowIndex+')').find('td:eq('+o_cfg['cellIdx']+') input[type="text"]').val();
            p_total += numberOfZero($.trim(s));
        });
        if(p_total > _p_value){
            $this.val ( $.isNumeric(ov) ? Globalize.format(ov, point) : '' ).focus().select();
        }
    }
}

;function input_keyup_eve(e){
    var $this=$(this), $td=$this.parent(), $tr=$td.parent(), $tbody=$tr.parent(),
        _cellIndex=$td[0].cellIndex, _rowIndex=$tr[0].rowIndex;

    if(e.shiftKey && e.keyCode == 13){  //find prve cell input
    	/*
        $tbody.find('tr:lt('+_rowIndex+'):not(.dn)')
            .find('td:eq('+_cellIndex+'):has(input)').last().find('input[type="text"]').focus().select();
    	*/
    	$td.prev().find('input[type="text"]').focus().select();
    }else if(e.keyCode == 13){  //find next cell input
    	/*
        $tbody.find('tr:gt('+_rowIndex+'):not(.dn)')
            .find('td:eq('+_cellIndex+'):has(input)').first().find('input[type="text"]').focus().select();
    	*/
    	$td.next().find('input[type="text"]').focus().select();
    	
    }
}
;function input_search_key_eve(e){
    var $this = $(this);
    if(e.keyCode == 13){  //find next cell input
        document.getElementById('searchpart_btnid').click();
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
	var _this=this, $this=$(_this), $td=$this.parent().parent(), $tr=$td.parent(), $body=$tr.parent(), 
		$right_trs=$('#rtabid tr'), aId=$tr.attr('data-aid'), rt=$tr.attr('data-hierarchy'), 
		dataNum=$tr.attr('data-num'), gplId=$tr.attr('data-gid'), cls='',
		remote_fn={'$lbody': $body, '$rbody': $('#rtabid'),  'monthCell': {}, 'cellMonth': {}, 'json': {}, 'cls': '', 'crtCell': $('#tab_head_list td.crtQtotal')[0].cellIndex, 
			'data-v1': $tr.attr('data-v1'), 'data-v2': $tr.attr('data-v2'), 'data-v3': $tr.attr('data-v3'), 'data-v4': $tr.attr('data-v4'),
			'data-v5': $tr.attr('data-v5'), 'accnumber': $tr.attr('data-gid'), 'gplId': $tr.attr('data-gid'), '$billing': $tr.next(), '$booking': $tr.next().next(), '$backlog': $tr.next().next().next(), 
			'action': getAPLsRefData_js, 'actionBacklog': getBacklogRefData_js, 'complete': complete_getRefData, 'completeBacklog': complete_getBacklogRefData,
			'$historicalCells': $('#tab_head_list td.historicalc.qtotalCls, td.crtQtotal'), '$futureCells': $('#tab_head_list td.qtotalCls'),
			'relayCode': $tr.attr('data-cbcnumber'), 'currencyIso': $tr.attr('data-isocode'), 'territoryCode': $('#hidd_territorycodeid').val(), 'cbc': $tr.attr('data-cbcname')
		};
	
	if($this.hasClass('readypin')){ return false; }
		
	switch(rt){
		case 'root1': 
			cls = 'tr.actsub.'+aId+'_cls'; 
			remote_fn['data-v1']=$tr.attr('data-aid');
			remote_fn['$billing']=$tr.next().next().next().next().next();
			remote_fn['$booking']=remote_fn['$billing'].next();
			remote_fn['$backlog']=remote_fn['$booking'].next();
			remote_fn['cls']=WORK_CLS['level1'];
			break;
		case 'root2': 
			remote_fn['data-v1']=$tr.attr('data-aid');
			remote_fn['$billing']=$tr.next().next().next();
			remote_fn['$booking']=remote_fn['$billing'].next();
			remote_fn['$backlog']=remote_fn['$booking'].next();
			remote_fn['cls']=WORK_CLS['level2'];
			cls = 'tr.cbcsub.'+aId+'_cls.'+dataNum; 
			break;
		case 'root3': 
			if(remote_fn['cbc'] == 'Relay'){
				remote_fn['accnumber']=$tr.attr('data-number');
			}
			remote_fn['data-v1']=$tr.attr('data-aid');
			remote_fn['$billing']=$tr.next().next().next().next().next();
			remote_fn['$booking']=remote_fn['$billing'].next();
			remote_fn['$backlog']=remote_fn['$booking'].next();
			remote_fn['cls']=WORK_CLS['level3'];

			cls='tr.gplsub.'+aId+'_cls.'+dataNum+'.'+$tr.attr('data-gcls'); 
			break;
		case 'root4': 
			remote_fn['accnumber']=(remote_fn['cbc']=='Relay'?$tr.attr('data-number'): remote_fn['accnumber']);
			remote_fn['$billing']=$tr.next().next().next().next();
			remote_fn['$booking']=remote_fn['$billing'].next();
			remote_fn['$backlog']=remote_fn['$booking'].next();
			remote_fn['cls']=WORK_CLS['level4'];
			cls = 'tr.productsub.'+remote_fn['data-v1']+'_cls.'+remote_fn['data-v2']+'.'+remote_fn['data-v3']+'_gpl.'+remote_fn['data-v4']; 
			break;
		case 'root5': 
			remote_fn['$billing']=$tr.next().next().next().next();
			remote_fn['$booking']=remote_fn['$billing'].next();
			remote_fn['$backlog']=remote_fn['$booking'].next();
			remote_fn['cls']=WORK_CLS['level5'];
			cls = 'tr.partsub.'+remote_fn['data-v1']+'_cls.'+remote_fn['data-v2']+'.'+remote_fn['data-v3']+'_gpl.'+remote_fn['data-v4']+'.'+remote_fn['data-v5']; 
			break;
		case 'root08': 
			remote_fn['accnumber']=$tr.attr('data-number');
			remote_fn['cls']=WORK_CLS['other'];
			cls = 'tr.gplsub.'+$tr.attr('data-v1')+'_cls.'+$tr.attr('data-v2')+'.'+$tr.attr('data-v3'); 
			break;
	}

	if(!$this.hasClass('donepin') && $this.hasClass('spin')){	//check loaded reference data.
		$this.addClass('donepin');
		createHistoricalStatus(remote_fn['$billing']);
		createFutureStatus(remote_fn['$backlog']);
		if(rt == 'root08' || rt == 'root4' || rt == 'root5' || (rt == 'root3' && remote_fn['cbc'] == 'Relay')){
		}else{
		//	$this.addClass('readypin waitingpin');
		//	createRefDataRemote($body.find(cls));
		}
	}

	if(!$this.hasClass('spin')){
		$this.addClass('spin');
		$body.find(cls).addClass('dn').each(function(){
			$right_trs.eq(this.rowIndex).addClass('dn');
		});
		if(rt == 'root5'){
			$this.html('+');
		}
		return;
	}
	
	$this.removeClass('spin');
	$body.find(cls).removeClass('dn').each(function(){
		$right_trs.eq(this.rowIndex).removeClass('dn');
	});
	if(rt == 'root5'){
		$this.html('-');
	}
	/** Help method */
	;function createHistoricalStatus($element){
		var list_months=[];
		createMonths( list_months, $element, $('#tab_head_list td.monthCls') );

		asyncEachSeries_Original(list_months, function(list_item, callback){
			var attr_tmp=$.extend({}, remote_fn), list_q=[];
			for(var i=0, result; result=list_item[i]; i++){
				list_q.push(result);
			}
			attr_tmp['smonths'] = list_q.join(',');
			attr_tmp['json'] = {'set_fiscalMonth': list_q, 'territoryCode': remote_fn['territoryCode'], 'grouping': remote_fn['data-v1'], 'gplId': remote_fn['gplId'],
								'relayCode': remote_fn['relayCode'], 'currencyIso': remote_fn['currencyIso'], 'accnumber': remote_fn['accnumber'], 'cbc2Code': remote_fn['cbc'], 'partId': remote_fn['data-v5']
								};
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
			attr_tmp['json'] = {'set_fiscalMonth': list_q, 'territoryCode': remote_fn['territoryCode'], 'grouping': remote_fn['data-v1'], 'gplId': remote_fn['gplId'],
								'relayCode': remote_fn['relayCode'], 'currencyIso': remote_fn['currencyIso'], 'accnumber': remote_fn['accnumber'], 'cbc2Code': remote_fn['cbc'], 'partId': remote_fn['data-v5']
								};
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
		$element.find('td:first div').append(el_body);
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
		$element.find('td:first div').append(el_body);
	}
	
	;function createRefDataRemote($totalRows){
		var q_month={}, q_months={}, q_Future={}, q_cell={}, m_cell={}, $head_trs=$('#tab_head_list td'),
			_json={ "aid": (aId == 'customother' ? OTHER_ID : aId), "territoryCode": $('#hidd_territorycodeid').val(), "cbcCode": $tr.attr('data-cbcname'),
					"gplId": $tr.attr('data-gid'), "currentYear": $('#hidd_cyear').val(), "currentMonth": $('#hidd_cmonth').val(),
					"map_acctId_currencyIso": $.parseJSON($('#hidd_actcurrencyid').val()), "list_dateKey": []
				  }, 
			params={'$totalRow': $totalRows, '$rRow':$right_trs, '$tr': $tr, '$td': $td, '$pin': $this, 'json': {}, 
					'qFuture': q_Future, 'qMonth': q_month, 'qMonths':q_months, 'qCell': q_cell, 'mCell':m_cell};
		
		params['currentCell']=$head_trs.filter('.crtQtotal')[0].cellIndex+1;
		$head_trs.filter('.monthCls').each(function(){
			m_cell[this.getAttribute('data-month')]=this.cellIndex;
		});	
		
		var th='',td='';
	    $head_trs.filter('.qtotalCls').each(function(){
	    	var $qCell=$(this), isFuture=$qCell.hasClass('futurec1'), q=$qCell.attr('data-date'),
	    		list_month=$qCell.attr('data-months').split(','), new_params=$.extend({}, params);
	    		
	    	q_month[q]=list_month;
	    	q_cell[q]=this.cellIndex;
	    	q_months[list_month.join(',')]=this.cellIndex;
	    	for(var i=0, _month; _month=list_month[i]; i++){
		    	q_Future[_month]=isFuture;
	    	}
	    	
	    	_json['list_dateKey']=list_month;
	    	
			new_params['json'] = JSON.stringify(_json);
			new_params['quarterCell']=this.cellIndex;
			new_params['sMonths']=list_month.join(',');
			
			switch(rt){	//this is remote action
				case 'root1': 
					new_params['action']=searchRefDataTotal_js;
					new_params['complete']=complete_searchRefDataTotal;
					customRemoteAction(new_params, searchRefDataTotal_js, complete_searchRefDataTotal);  
					break;
				case 'root2': 
					new_params['action']=searchRefDataCBC_js;
					new_params['complete']=complete_searchRefDataCBC;
					customRemoteAction(new_params, searchRefDataCBC_js, complete_searchRefDataCBC);  
					break;
				case 'root3': 
					new_params['action']=searchRefDataGPL_js;
					new_params['complete']=complete_searchRefDataGPL;
					customRemoteAction(new_params, searchRefDataGPL_js, complete_searchRefDataGPL);  
					break;
			}
			
			th += '<td class="ref_head" style="text-align: center;">'+$qCell.find('span').text()+'</td>';
			td += '<td class="smonths" data-status="false" data-months="'+list_month.join(',')+'" style="text-align: center;"><div class="refstatus str"></div></td>';
	    });
		$td.append('<div class="refs_d"><table class="pinstatus" border="0" cellspacing="0" cellpadding="0" ><tr class="shead">'+th+'</tr><tr class="sbody">'+td+'</tr></table></div>')
		   .find('div.refs_d').off('mouseenter mouseleave').on('mouseenter mouseleave', over_refStatus_eve);
		$this.off('mouseenter mouseleave').on('mouseenter mouseleave', over_pinRefStatus_eve);
	}
	/** Help method */
}

;function clickLeftTableTotal_eve(e){
	var hide='dn', _this=this, $this=$(this), o_cfg={'rowIdx':_this.rowIndex},
		$l_trs=$this.parent().find('tr'), $r_trs=$('#rtabid tr'), fn=($this.hasClass('exp')? exp : col);
	
	$this.find('td:first span.reload_span').remove();
	if(rowIsLocked(o_cfg['rowIdx'])){ return false; }

	fn();
	
	;function exp(){
		$l_trs.filter('.trt_0:not(.trt_trt)').addClass(hide);
		$r_trs.filter('.trt_0:not(.trt_trt)').addClass(hide);
        rowUnLock(o_cfg['rowIdx']);
        $this.removeClass('exp').addClass('col').find('span.fcell').html('+');
	}
	
	;function col(){
		var $head_trs=$('#tab_head_list td'), cell_total={}, $tc_cell=$r_trs.filter('.tcfctotal').find('td'),
			$relay_cell=$r_trs.filter('.relayfctotal').find('td'), $total_cell=$r_trs.filter('.fctotal').find('td'),
			startCell=$head_trs.filter('.crtQtotal')[0].cellIndex-1;
		$l_trs.filter('.rt1').each(function(){
			var reat=$.trim($(this).find('td:first b.fmt_cls').attr('data-reat')), isoCode=this.getAttribute('data-isocode');
			reat=($.isNumeric(reat) ? parseFloat(reat) : 0);
			$r_trs.eq(this.rowIndex).find('td:gt('+startCell+')').each(function(){
				var total=cell_total[this.cellIndex], fc=numberOfZero($.trim(this.innerHTML));
				if(isoCode != 'USD'){fc=(fc*reat);}
				total=($.isNumeric(total) ? total : 0);
				cell_total[this.cellIndex]=(total+fc);
			});
		});

		$l_trs.filter('.trt_0:not(.trt_trt)').removeClass(hide);
		$r_trs.filter('.trt_0:not(.trt_trt)').removeClass(hide);
        rowUnLock(o_cfg['rowIdx']);
        
        for(var cell in cell_total){
        	var realy_val=Globalize.parseFloat($relay_cell.eq(cell).text()), aTotal=(cell_total[cell]);
			$total_cell.eq(cell).html( Globalize.format(aTotal, 'n') );
        	$tc_cell.eq(cell).html( Globalize.format((aTotal-realy_val), 'n') );
        }

        $this.removeClass('col').addClass('exp').find('span.fcell').html('-');
	}
}

;function clickLeftTable_eve(e){

    if(e['target'].tagName.toUpperCase() != 'SPAN'){
    	return false;
    }
    
    var list_element=[], indx=this.rowIndex, hide='dn', _this=this, $this=$(_this), _rowIndex=_this.rowIndex, $parent=$this.parent(),
		o_cfg={'root': _this.getAttribute('data-hierarchy'), 'rowIdx': indx, 'isRemote':false, 'o_cell': undefined},
        $waiting=$this.find('span.fcell'), $pin=$this.find('span.pin'), aid=$.trim(_this.getAttribute('data-aid')),
        $right_list_trs=e.data.$divbody.find('#rtabid tr'), fn=($this.hasClass('exp')? exp : col);

    $this.find('td:first span.reload_span').remove();	

    if($this.find('td:first input[type="button"].delpartbtn').hasClass('disabled_btn')){ return false; }
    if(rowIsLocked(o_cfg['rowIdx'])){ return false; }
    if($this.hasClass('ready')){ return false; }

    fn();
    
    ;function exp(){
    	if(isLockedData()){
    		return false;
    	}
    	_queueTask.push({name: o_cfg['rowIdx'], run: function(cb){

	        var findcls=getExpAccountCls();
	        $parent.find(findcls['aCls']).addClass(hide).each(function(){
	        	
	            $right_list_trs.eq(this.rowIndex).addClass(hide).find('td').removeClass(findcls['tCls']);
	            $(this).removeClass('exp col').addClass('col').find('td').removeClass(findcls['tCls'])
	            		.find('span.fcell').html('+');//.parent().find('span.pin').addClass('spin');
				$(this).find('span.pin').addClass('spin');
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
    	
    	var aCls=_this.getAttribute('data-cls'), aId=_this.getAttribute('data-aid'), cbcNum=_this.getAttribute('data-num'), 
    		gplCls=_this.getAttribute('data-gcls'), partCls=_this.getAttribute('data-pcls'), cbcName=_this.getAttribute('data-cbcname'),
    		remote_fn={'params':{}, 'remote':function(p){}, 'action': existAPLsObject_js, 'complete': complete_existAMObject,
    			'rowIndex': o_cfg['rowIdx'], 'data-v1': aId, 'data-v2': cbcNum, 'data-cbc': $this.attr('data-cbcname'), '$row': $this, 'data-gid': $this.attr('data-gid'),
    			'data-v3': $this.attr('data-v3'), 'data-v4': $this.attr('data-v4'), 'data-number': $this.attr('data-number')
    		};

    	if(cbcName != 'Relay' && cbcName != 'Others' && o_cfg['root'] == 'root2'){
    		$right_list_trs.eq(o_cfg['rowIdx']).find('input').each(function(){
				if(numberOfZero($.trim(this.value)) == 0){
					o_cfg['o_cell'] = this.parentNode.cellIndex;
					return false;	//Break for each.
				}
    		});
    	}
        
    	if(typeof(o_cfg['o_cell']) != 'undefined'){
    		rowUnLock(o_cfg['rowIdx']);
    		$right_list_trs.eq(o_cfg['rowIdx']).find('td:eq('+o_cfg['o_cell']+') input').focus().select();
    		return;
    	}

    	$waiting.addClass('waiting').html('&nbsp;');
    	switch(o_cfg['root']){
    		case 'root1' :
            	aCls = ('tr.rt2.'+aCls);
			//	aCls += ($pin.hasClass('spin') ? '' : (', tr.actsub.'+aId+'_cls'));
    			check_forecast(aCls, remote_fn, createCBC2JSON, searchCBC2_js, complete_searchCBC2);
    			break;
    		case 'root2' :
    			switch(cbcName){
    				case 'Others': 
    					aCls = ('tr.rt3.'+aCls+'.'+cbcNum);
    					remote_fn['append'] = appendElementOther_level3;
    					remoteCheck(aCls, remote_fn, createOtherCBCJSON, WORK_CLS['other']);
    					break;
    				case 'Relay': 
    					aCls = ('tr.rt3.'+aCls+'.'+cbcNum);
    					remote_fn['append'] = appendElementCBCRelay_level2;
    					remoteCheck(aCls, remote_fn, createRelayJSON, WORK_CLS['level3']);
    				//	check_forecast(aCls, remote_fn, createGPLJSON, searchRelayGPL_js, complete_searchGPL_Relay);
    					break;
    				default :
    					aCls = ('tr.rt3.'+aCls+'.'+cbcNum);
    					check_forecast(aCls, remote_fn, createGPLJSON, searchGPL_js, complete_searchGPL);	//check GPL is loaded.
    					break;
    			}
    		
    			break;
    		case 'root3' :
				
				remote_fn['data-v3']=$this.attr('data-gid');
    			if(remote_fn['data-cbc'] == 'Relay'){
					aCls = ('tr.rt6.'+aCls+'.'+gplCls+'.'+cbcNum);
    				remote_fn['append'] = appendElementProduct_level4;
					remoteCheck(aCls, remote_fn, createProductCodeJSON, WORK_CLS['level4']);
    			}else{
    				aCls = ('tr.rt4.'+aCls+'.'+gplCls+'.'+cbcNum);
					check_forecast(aCls, remote_fn, createPartJSON, searchPart_js, complete_searchPart);	//check Part is loaded.
    			//	check_forecast(aCls, remote_fn, createPartJSON, (cbcName == 'Relay' ? searchRelayPart_js : searchPart_js), complete_searchPart);	//check Part is loaded.
    			}
    			break;
    		case 'root4' :
    			remote_fn['data-v1']=$this.attr('data-v1');
    			remote_fn['data-v2']=$this.attr('data-v2');
    			if(cbcName == 'Relay'){
    				aCls = ('tr.rt4.'+remote_fn['data-v1']+'_cls.'+remote_fn['data-v2']+'.'+remote_fn['data-v3']+'_gpl.'+remote_fn['data-v4']);
    				remote_fn['append'] = appendElementPart_level5;
    				remoteCheck(aCls, remote_fn, createRelayPartJSON, WORK_CLS['level5']);
    			}else{
	    			aCls = ('tr.partsub.'+aCls+'.'+cbcNum+(cbcName == 'Others' ? '' : '.'+gplCls)+'.'+partCls);
	            	o_cfg['isRemote'] = false;
    			}
    			break;
    	}

    	if((o_cfg['root'] == 'root2' && cbcName == 'Others') || (o_cfg['root'] == 'root3' && cbcName == 'Relay') ||
    		(o_cfg['root'] == 'root4' && cbcName == 'Relay') || (o_cfg['root'] == 'root2' && cbcName == 'Relay')){
    		remote_fn['remote'](remote_fn);
    	}else{
	    	remote_fn['remote'](remote_fn['params']);
    	}
    	
		expandElement(aCls);	
		setColTabBgColor();
    }
    ;function createRelayJSON(){
    	this['territoryCode']=$.trim($('[id*=hidd_territorycodeid]').val());
    	this['grouping']=($this.attr('data-aid') == 'customother' ? OTHER_LABEL: $this.attr('data-aid'));
    	this['map_year_quartersFuture']=$.parseJSON($('#hidd_yearfutureid').val());
    	this['currencyIso']=$this.attr('data-isocode');
    }
    ;function createOtherCBCJSON(){
    	this['territoryCode']=$.trim($('[id*=hidd_territorycodeid]').val());
    	this['grouping']=($this.attr('data-aid') == 'customother' ? OTHER_LABEL: $this.attr('data-aid'));
    	this['map_year_quartersFuture']=$.parseJSON($('#hidd_yearfutureid').val());
    	this['currencyIso']=$this.attr('data-isocode');
    }
    ;function createProductCodeJSON(){
    	this['territoryCode']=$.trim($('[id*=hidd_territorycodeid]').val());
    	this['grouping']=($this.attr('data-aid') == 'customother' ? OTHER_LABEL: $this.attr('data-aid'));
    	this['map_year_quartersFuture']=$.parseJSON($('#hidd_yearfutureid').val());
    	this['gid']=$this.attr('data-gid');
    	this['accnumber']=$this.attr('data-number');
    	this['currencyIso']=$this.attr('data-isocode');
    }
    ;function createRelayPartJSON(){
    	this['territoryCode']=$.trim($('[id*=hidd_territorycodeid]').val());
    	this['grouping']=($this.attr('data-v1') == 'customother' ? OTHER_LABEL: $this.attr('data-v1'));
    	this['map_year_quartersFuture']=$.parseJSON($('#hidd_yearfutureid').val());
    	this['gid']=$this.attr('data-gid');
    	this['accnumber']=$this.attr('data-number');
    	this['currencyIso']=$this.attr('data-isocode');
    }
    ;function createCBC2JSON(cls){

	    var o = {'json' : '', '$row':$this, 'rowIndex':o_cfg['rowIdx'], 'o_cell': {} }, t = '', aId=$this.attr('data-aid');
	    aId = (aId == 'customother' ? OTHER_LABEL: aId);
	    o['$cbcRows']=$parent.find(cls).filter('.rt2');
	    o['$cbcRows'].each(function(){
	    	t += ('\"'+ this.getAttribute('data-cbcname') +'\":\"'+this.getAttribute('data-cbcname')+'\",');
	    });
	    if(t == ''){ t = '{}'; }
	    else{ t = ('{' + t.substring(0, t.length-1) + '}'); }
	    
	    t = ('{ "map_cbcName": '+ t +', "aid": \"'+aId+'\", "periodStartDate": "'+$('#hidd_periodsdid').val()+'"'+
	    	 ',"map_acctId_currencyIso": '+$('#hidd_actcurrencyid').val()+', "map_year_monthsFuture": '+$('#hidd_mapfuture').val()+', "refStartDate": "'+$('#hidd_start').val()+'", "refEndDate": "'+$('#hidd_end').val()+'" '+
	         ',"map_year_monthsHistory": '+$('#hidd_maphistory').val()+', "map_year": '+$('#hidd_yearfutureid').val()+', "territoryCode": \"'+$.trim($('[id*=hidd_territorycodeid]').val())+'\"}');
	    o['json'] = t;
	    setForecastCellIndex(o);

	    return o;
    }
    ;function createGPLJSON(cls){

    	var isPercentage=($('#rTabDataId tr:eq('+$this.index()+')').find('input[data-old="0"]').length == 0 ? false : true),
			acls=$this.attr('data-cls'), cbcNum=$this.attr('data-num'),aId=$this.attr('data-aid'), cbcName=$this.attr('data-cbcname'),
    		$lastRow=$parent.find('tr.backlog.cbcsub.'+acls+'.'+cbcNum),
    		o = {	
    			'$lastRow': $lastRow, '$row':$this, 'rowIndex':o_cfg['rowIdx'], 'o_cell':{}, 'aid':aId,
				'cbcNum': cbcNum, 'cbcName': cbcName, 'acls': acls, 'isRelay' : (cbcName=='Relay'? true : false),
         		'json': '{"aid": \"'+(aid == 'customother' ? OTHER_LABEL: aid)+'\", "cbc2Name": \"'+cbcName+'\", "periodStartDate": "'+$('#hidd_periodsdid').val()+'", '+
     					' "isNeedBillPercentage": '+isPercentage+', "map_acctId_currencyIso": '+$('#hidd_actcurrencyid').val()+', "map_year_monthsFuture": '+$('#hidd_mapfuture').val()+', "refStartDate": "'+$('#hidd_start').val()+'", "refEndDate": "'+$('#hidd_end').val()+'", '+
						' "map_year_monthsHistory": '+$('#hidd_maphistory').val()+', "isRelay": '+(cbcName=='Relay'? true : false)+', "map_year": '+$('#hidd_yearfutureid').val()+', "territoryCode": \"'+$.trim($('[id*=hidd_territorycodeid]').val())+'\" }'
            };

	    setForecastCellIndex(o);
	    return o;
    }
    ;function createPartJSON(cls){
    	var acls=$this.attr('data-cls'), cbcNum=$this.attr('data-num'),aId=$this.attr('data-aid'), gplId=$this.attr('data-gid'), 
    		gplcls=$this.attr('data-gcls'), cbcName=$this.attr('data-cbcname'),
    		$lastRow=$parent.find('tr.backlog.gplsub.'+acls+'.'+cbcNum+'.'+gplcls), 
    		o = {	'isRelay' : (cbcName=='Relay'? true : false),
    			'$lastRow': $lastRow, '$row':$this, 'rowIndex':o_cfg['rowIdx'], 'o_cell':{}, 'aid':aId,
				'cbcNum': cbcNum, 'cbcName': cbcName, 'acls':acls, 'gId':gplId, 'gcls': gplcls,
         		'json': '{"aid": \"'+(aid == 'customother' ? OTHER_LABEL: aid)+'\", "cbc2Name": \"'+cbcName+'\", "gplId": \"'+gplId+'\", "periodStartDate": "'+$('#hidd_periodsdid').val()+'", '+
         				' "currentYear": "'+$('#hidd_cyear').val()+'", "currentMonth": "'+$('#hidd_cmonth').val()+'", '+
						' "map_acctId_currencyIso": '+$('#hidd_actcurrencyid').val()+', "map_year_monthsFuture": '+$('#hidd_mapfuture').val()+', "refStartDate": "'+$('#hidd_start').val()+'", "refEndDate": "'+$('#hidd_end').val()+'", '+
         				' "map_year_monthsHistory": '+$('#hidd_maphistory').val()+',"isRelay" : '+(cbcName=='Relay'? true : false)+', "isOther": '+(cbcName == 'Others' ? true : false)+', "map_year": '+$('#hidd_yearfutureid').val()+', "territoryCode": \"'+$.trim($('[id*=hidd_territorycodeid]').val())+'\" }'
            };
	    
	    setForecastCellIndex(o);
	    return o;
    }
    ;function setForecastCellIndex(o){
    	var $head_trs=$('#tab_head_list td.qcell');
    	$head_trs.each(function(){
    		o['o_cell'][this.getAttribute('data-date')] = this.cellIndex;
    	});
    	o['currentCell']=$head_trs.filter('.crtQtotal')[0].cellIndex;
    }
    ;function check_forecast(find_cls, remote_fun, createJson,remoteAction, completeRemoteAction){
    	if($this.hasClass('ready') || $this.hasClass('done')){ return; }
        $this.addClass('ready');
        o_cfg['isRemote'] = true;
        remote_fun['params'] = createJson(find_cls);
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
    
    ;function isLockedData(){
    	var count=0, isLocked=false;
    	switch(o_cfg['root']){
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
        
    ;function isLoadedData(){
    	var isLoaded=true;
    	if((o_cfg['root']=='root2' && typeof($parent.find('tr.rt1.'+$this.attr('data-aid')+' span.reload_span')[0]) != 'undefined')
    			|| $parent.find('tr.rt1.'+$this.attr('data-aid')+' td:first span').hasClass('waiting')){ 
    		
		    isLoaded = false;
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
    
    ;function expandElement(cls){
    	_queueTask.push({name: o_cfg['rowIdx'], run: function(cb){
            list_element = $parent.find(cls).toArray();
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
    
    ;function getExpAccountCls(){
    	var aCls=_this.getAttribute('data-cls'), cbcNum=_this.getAttribute('data-num'), tabCls='',
    		gplCls=_this.getAttribute('data-gcls'), partCls=_this.getAttribute('data-pcls');

        switch(o_cfg['root']){
            case 'root1' : 
            		aCls = ('tr:not(.actsub).'+aCls); 
            		$this.find('td').removeClass('a_bg');
    				$right_list_trs.eq(o_cfg['rowIdx']).find('td').removeClass('a_bg');
    				tabCls='c_bg g_bg p_bg';
            	break;
            case 'root2' : 
            		aCls = ('tr:not(.cbcsub).'+aCls+'.'+cbcNum);
        			$this.find('td').removeClass('c_bg');
    				$right_list_trs.eq(o_cfg['rowIdx']).find('td').removeClass('c_bg');
    				tabCls='g_bg p_bg';
        		break;
            case 'root3' : 
            		aCls = ('tr:not(.gplsub):not(.rt3).'+aCls+'.'+cbcNum+'.'+gplCls);
            		$this.find('td').removeClass('g_bg');
    				$right_list_trs.eq(o_cfg['rowIdx']).find('td').removeClass('g_bg');
    				tabCls='p_bg';
        		break;
            case 'root4' : 
            		if(_this.getAttribute('data-cbcname') == 'Relay'){
            			aCls=('tr:not(.productsub):not(.rt6).'+$this.attr('data-v1')+'_cls.'+$this.attr('data-v2')+'.'+$this.attr('data-v3')+'_gpl.'+$this.attr('data-v4'));
            		}else{
            			gplCls = (_this.getAttribute('data-cbcname') == 'Others' ? '.' : '.'+gplCls+'.');
            			aCls = ('tr:not(.rt4).'+aCls+'.'+cbcNum+gplCls+partCls);
            		}
            		$this.find('td').removeClass('p_bg');
    				$right_list_trs.eq(o_cfg['rowIdx']).find('td').removeClass('p_bg');
        		break;
        }

        return {'aCls': aCls, 'tCls': tabCls};
    }
	;function setColTabBgColor(){
		switch(o_cfg['root']){
            case 'root1' : 
            	$this.find('td').addClass('a_bg');
    			$right_list_trs.eq(o_cfg['rowIdx']).find('td').addClass('a_bg');
				break;
            case 'root2' : 
            	$this.find('td').addClass('c_bg');
    			$right_list_trs.eq(o_cfg['rowIdx']).find('td').addClass('c_bg');
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
	/*
	;function setColSubTabBgColr($item){
		switch(o_cfg['root']){
            case 'root1' : 
            //	if(!$item.hasClass('rt2')){ $item.find('td:first').addClass('a_css'); }
        		$item.find('td').removeClass('c_bg g_bg p_bg');
        		$right_list_trs.eq($item.index()).find('td').removeClass('c_bg g_bg p_bg');
            	break;
            case 'root2' : 
            //	if(!$item.hasClass('rt3')){ $item.find('td:first').addClass('c_css'); } 
        		$item.find('td').removeClass('g_bg p_bg');
        		$right_list_trs.eq($item.index()).find('td').removeClass('g_bg p_bg');
            	break;
            case 'root3' : 
            //	if(!$item.hasClass('rt4')){ $item.find('td:first').addClass('g_css'); } 
        		$item.find('td').removeClass('p_bg');
        		$right_list_trs.eq($item.index()).find('td').removeClass('p_bg');
            	break;
            case 'root4' : 
            //	if(!$item.hasClass('rt4')){ $item.find('td:first').addClass('p_css'); } 
            	break;
        }
	}
*/
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

;function event_floatAMScroll(e){
	try{
	    var _this=this;
	    if (TIMEOUT){ clearTimeout(TIMEOUT) };
	    
	    document.getElementById('right_head').scrollLeft = _this.scrollLeft;
	    $('#rCellScroll').off('scroll').scrollLeft(_this.scrollLeft);
	    TIMEOUT = setTimeout(function(){
		    $('#rCellScroll').off('scroll').on('scroll', rCellScrollAM_eve);
	    }, 120);
	}catch(e){
		
	}
}
;function addGPLOver_eve(e){
    var $this=$(this);
    eventHandle_ov_ot(e, ov, ot);
    
    ;function ov(e){ $this.find('div').show(); }
    ;function ot(e){ 
        if($this.find('input[type="button"].addpartbtn').hasClass('disabled_btn')){
            return;
        }
        $this.find('div').hide(); 
    }
}

;function addReloadButton(data, event, reloadButtonEventCallBack){

    var el_reload = '<span class="reload_span"><span class="reload_img"></span><b class="reload_msg" style="display:none;">'+event['message']+'</b></span>';
    data.$row.removeClass('ready done').find('td:first div:first').before(el_reload)
            .parent().find('span.reload_img').off('mouseenter mouseleave click')
            .on('mouseenter mouseleave click', {$data: data}, reloadButtonEventCallBack);
    rowUnLock(data['rowIndex']);
}

;function addPartLeftTabCss($clone, data, item, isOther){
    var list_element = $clone.toArray(), aCls = (data['acls']+' '+data['cbcNum']+' ');
    aCls += (isOther ? '' : data['gcls']);

    for(var i=0, _tr; _tr=list_element[i]; i++){
    	var $tr=$(_tr);
        if(i == 0){
        	$tr.attr({
        		'data-aid': data['aid'], 'data-cls': data['acls'], 'data-cbcname': data['cbcName'],
        		'data-gid': data['gId'], 'data-gcls': data['gcls'], 'data-num': data['cbcNum'],
        		'data-pid': item['partId'], 'data-pcls': item['partId']+'_part', 'data-hierarchy': 'root4',
        		'title': item['fieldName']
        	});
            $tr.find('span.scell').text(item['partDesc']);
        }
        $tr.addClass( (aCls + ' '+ item['partId'] + '_part') );
    }
}

;function addedSearchPartResult(result, data, isTop, $multiselect){
	var $left_trs=$('#ltabid tr'), o_json=$.parseJSON(data['json']), t = '', o_part={};
	
	$left_trs.filter('.'+o_json['aId']+'_cls.rt4').each(function(){
		var part_id=this.getAttribute('data-pid');
		o_part[part_id] = part_id;
	});

    while(result.length > 0){
        var s = result.shift(), hasPart = (o_part.hasOwnProperty(s['partId']) ? 'disabled="disabled"' : '');
        t += ('<option '+hasPart+' value="'+s['partId']+'"  data-desc="'+s['description']+'" data-name="'+s['partName']+'">['+s['partName']+'] - '+s['description']+'</option>');
    }
	
    $multiselect.append(t).multiselect('refresh');
    $('#popup_loading').hide();
}

;function complete_searchCBC2(result, event, data){       //search gpl forecast remote event
	scroll_event();
    if(event.status){ 
    	_queueTask.push({name: data['rowIndex'], run: function(cb){
	    	matchCBC2Result(cb); 
        }}, function(err){ });
	}
    else{ addReloadButton(data, event, reloadCBC2Fc_eve); }
    
    ;function matchCBC2Result(cb){

        result = $.parseJSON(result);
        
        if($.isEmptyObject(result)){ 
        	rowUnLock(data['rowIndex']);
        	data.$row.removeClass('ready').addClass('done').find('td:first span.fcell').html('-').removeClass('waiting');
        	return; 
    	}
        var $right_tr=$('#rtabid tr'), $left_trs=$('#ltabid tr');
		setMatchForecast(result, $right_tr, $left_trs, data, cb);
    }
    
    ;function setMatchForecast(result, $right_tr, $left_trs, data, queueTaskCallBack){

		for(var o in result){
        	var $l_cbc_row=$left_trs.filter('.'+data['$row'].attr('data-cls')+'.rt2[data-cbcname="'+o+'"]'), $current_fc=$right_tr.eq($l_cbc_row.index()), 
        		$previou_fc=$current_fc.next(), $rsmFC=$previou_fc.next(), fc=$.parseJSON(result[o]), current_fc=fc['currentFC'], previou_fc=fc['previousFC'], rsmFC=fc['rsmFC'];
	        /* 2015-05-29
	        if(o == 'Others'){
		        $l_cbc_row.off('click').find('span.fcell').remove();
	        }
	        */
        	$l_cbc_row.attr({'data-isocode': data['$row'].attr('data-isocode')});
        		
	        $current_fc.attr('data-row-name', 'cbc2');
	        formatResultCurrency(current_fc, previou_fc);
	        matchRightTableForecast(current_fc, previou_fc, data['o_cell'], $current_fc, $previou_fc, true, ($l_cbc_row.attr('data-cbcname') == 'Others' ? false : true));
        	for(var fc in rsmFC){ 
        		$rsmFC.find('td:eq('+data['o_cell'][fc]+')').attr({'data-old': rsmFC[fc]}).text( Globalize.format(rsmFC[fc], 'n') ); 
        	}
        }
        result={};
        rowUnLock(data['rowIndex']);
        queueTaskCallBack(null);
		data.$row.removeClass('ready').addClass('done').find('td:first span.fcell').html('-').removeClass('waiting');
    }

}

;function complete_searchGPL(result, event, data){       //search gpl remote event
	scroll_event();
    if(event.status){
        _queueTask.push({name: data['rowIndex'], run: function(cb){
            createGPLElement(result, data, false, cb);
        }}, function(err){ });
    }else{ 
    	$('#refdatastatusid').hide(); 
    	addReloadButton(data, event, reloadGPL_eve); 
	}
}  

;function complete_searchPart(result, event, data){       //search part forecast remote event
    if(event.status){
        _queueTask.push({name: data['rowIndex'], run: function(cb){
            createPartElement(result, data, cb);
        }}, function(err){ });
    }else{ addReloadButton(data, event, reloadPartFc_eve); }
}

;function complete_searchGPL_Relay(result, event, data){       //search gpl relay remote event
    if(event.status){
        _queueTask.push({name: data['rowIndex'], run: function(cb){
            createGPLElement(result, data, true, cb);
        }}, function(err){ });
    }else{ 
    	$('#refdatastatusid').hide();
        addReloadButton(data, event, reloadGPLRelay_eve);
    }
}

;function complete_searchGPL_Others(result, event, data){       //search others part remote event
    if(event.status){
        _queueTask.push({name: data['rowIndex'], run: function(cb){
            createPartOthersElement(result, data, cb);
        }}, function(err){ });
    }else{ 
        addReloadButton(data, event, reloadGPLOther_eve);
    }
    
}
;function complete_resultCheck(result, data, $right_tr){
    result = $.parseJSON(result);
    if(result.length == 0){ 
        rowUnLock(data['rowIndex']);
        data.$row.removeClass('ready').addClass('done').find('td:first span.fcell').html('-').removeClass('waiting');
        return []; 
    }

    $('#tab_head_list td.dn').each(function(){
        $right_tr.find('td:eq('+this.cellIndex+')').addClass('dn');
    });
    return result;
}
;function complete_deletePart(result, event, data){
    var $left_trs = $('#ltabid tr'), $right_trs=$('#rtabid tr'), ele_idx=data['$element'].index();

    if(event.status){

        result = $.parseJSON(result);
        data['$parts'].each(function(){
        	$right_trs.eq(this.rowIndex).remove();
        });
        data['$parts'].remove();

    }else{
        var $errdiv = $left_trs.eq(ele_idx).find('td:first input[type="button"].delpartbtn').removeClass('disabled_btn').val(CUSTOM_LABEL['delpart']).parent();
        $errdiv.find('b').remove();
        $errdiv.append('<b class="borders">'+event['message']+'</b>');
    }
}

;function complete_searchTopPart(result, event, data){  //added top5 sales
    if(event.status){
    		addedSearchPartResult($.parseJSON(result), data, true, $('#multiselect_simple'))
    }else{
    		$('#popup_loading').html(event['message']);
    }
	$('#popupbox input[type="button"]').removeAttr('disabled');
}

;function complete_searchAddedPart(result, event, data){
    
    if(event.status){
		var $multiselect=$('#multiselect_simple');
		$multiselect.find('option').remove();
        addedSearchPartResult($.parseJSON(result), data, false, $multiselect);
    }else{
        $('#popup_loading').html(event['message']);
    }
    $('#popupbox input[type="button"]').removeAttr("disabled");
    
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

;function complete_searchRefDataTotal(result, event, data){
	
	var $status_cell=data['$td'].find('table.pinstatus td.smonths[data-months="'+data['sMonths']+'"]');
	
	if(event.status){
		_queueTask.push({name: data['sMonths'], run: function(cb){
			result = $.parseJSON(result);
			matchRefData(data, result['totalBooking'], data['$rRow'].eq(data['$totalRow'].filter('.totalBooking').index()).find('td'));
			matchRefData(data, result['totalBilling'], data['$rRow'].eq(data['$totalRow'].filter('.totalBilling').index()).find('td'));
			matchRefData(data, result['totalBacklog'], data['$rRow'].eq(data['$totalRow'].filter('.totalBacklog').index()).find('td'));
			complete_finallyRefData(data, $status_cell, cb);
    	}}, function(err){ });	
    }else{
		complete_finallyErrorRefData(data, event, $status_cell);
    }
}
;function complete_searchRefDataCBC(result, event, data){
	
	var $status_cell=data['$td'].find('table.pinstatus td.smonths[data-months="'+data['sMonths']+'"]');
	
	if(event.status){
		_queueTask.push({name: data['sMonths'], run: function(cb){
			result = $.parseJSON(result);
			matchRefData(data, result['booking'], data['$rRow'].eq(data['$totalRow'].filter('.booking').index()).find('td'));
			matchRefData(data, result['billing'], data['$rRow'].eq(data['$totalRow'].filter('.billing').index()).find('td'));
			matchRefData(data, result['backlog'], data['$rRow'].eq(data['$totalRow'].filter('.backlog').index()).find('td'));
			complete_finallyRefData(data, $status_cell, cb);
		}}, function(err){ });	
    }else{
		complete_finallyErrorRefData(data, event, $status_cell);
    }
}
;function complete_searchRefDataGPL(result, event, data){
	
	var $status_cell=data['$td'].find('table.pinstatus td.smonths[data-months="'+data['sMonths']+'"]');
	
	if(event.status){
		_queueTask.push({name: data['sMonths'], run: function(cb){
			result = $.parseJSON(result);
	
			matchRefData(data, result['booking'], data['$rRow'].eq(data['$totalRow'].filter('.booking').index()).find('td'));
			matchRefData(data, result['billing'], data['$rRow'].eq(data['$totalRow'].filter('.billing').index()).find('td'));
			matchRefData(data, result['backlog'], data['$rRow'].eq(data['$totalRow'].filter('.backlog').index()).find('td'));
			
			complete_finallyRefData(data, $status_cell, cb);
		
		}}, function(err){ });
    }else{
		complete_finallyErrorRefData(data, event, $status_cell);
    }
}
;function complete_finallyRefData(data, $status_cell, queueTaskCallBack){
	
	$status_cell.attr('data-status', 'true').find('div').animate({backgroundColor: '#51C957'}, 130);

	if(data['$td'].find('table.pinstatus td.smonths[data-status="false"]').length == 0){
		data['$td'].find('div.refs_d').remove();
    	data['$pin'].off('mouseenter mouseleave').removeClass('readypin waitingpin').addClass('donepin');
	}
	setTimeout(function(){ queueTaskCallBack(null); }, 120);
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

;function complete_getAddPartRefData(result, event, data){
	if(event.status){
		result=$.parseJSON(result);
		$.map(result, function(values, key){
			matchRefPartData(values['backlog'], data, '.backlog');
			matchRefPartData(values['billing'], data, '.billing');
			matchRefPartData(values['booking'], data, '.booking');
		});
		
		data['$rcell'].filter('.backlog, .billing, .booking').each(function(){
			$(this).find('td').each(function(idx){
				var $cell=$(this), isQcell=$cell.hasClass('qtotalCls'), old=getZeroOfNumber( $cell.attr('data-old') );

				if(isQcell && (idx<data['currentCell'])){
					var v1=getZeroOfNumber( $cell.prev().attr('data-old') ), 
						v2=getZeroOfNumber( $cell.prev().prev().attr('data-old') ), 
						v3=getZeroOfNumber( $cell.prev().prev().prev().attr('data-old') );
					old=(v1+v2+v3);
				}
				$cell.html( Globalize.format(old, 'n') );
			});
		});
		
    }else{
    	addReloadButton(data, event, reloadAddPart_eve);
    }
    
    ;function matchRefPartData(refData, data, filterCls){
    	var $cells=data['$rcell'].filter(filterCls).find('td');
    	
    	for(var d in refData){
    		var mt=data['mCell'][d], rd=refData[d];
    		if(mt['isFuture']){
    			var s=parseFloat($cells.eq(mt['cell']).attr('data-old'));
    			rd += ($.isNumeric(s) ? s : 0);
    		}
			$cells.eq(mt['cell']).attr('data-old', rd);
    	}
    }
    
}

;function complete_existAMObject(result, event, data){	//complete remoteaction result
	
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
			var el_reload = '<span class="reload_span reload_spanfix"><span class="reload_img fixreload"></span><b class="reload_msg" >'+event['message']+'</b></span>';
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

;function complete_getRefData(result, event, data){
	
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

;function complete_getBacklogRefData(result, event, data){
	
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
;function appendElementCBCRelay_level2(data, callBack, callBackEnd){
	
	var monthCell={}, cellMonth={}, $head=$('#tab_head_list td'), 
		list_hidden_td=$head.filter('.dn').toArray(), ftCell=$head.filter('.crtQtotal')[0].cellIndex-1;
	
	$head.each(function(){
		cellMonth[this.cellIndex] = this.getAttribute('data-date');
		monthCell[this.getAttribute('data-date')] = this.cellIndex;
	});
	data['cellMonth'] = cellMonth;
	data['monthCell'] = monthCell;
	data['ftCell']=ftCell;

	data['$left'] = data['$row'].next().next().next().next().next();
	data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');
	data['$left_template'] = $('#gpltab tbody tr').clone();
	data['$right_template'] = $('#gpltab tfoot tr').clone();

	data['$right_template'].each(function(){
		var $tds = $(this).find('td');
		for(var i=0, el; el=list_hidden_td[i]; i++){
			$tds.eq(el.cellIndex).addClass('dn');
		}
	});
	data['$left_template'].on('mouseenter mouseleave', over_table_eve).eq(0).attr({'data-hierarchy': 'root3', 'data-isocode': data['$row'].attr('data-isocode')})
				.addClass('realyrow').on('click', {$divbody: $('#div_body')}, clickLeftTable_eve).find('span.pin').on('click', clickLeftPin_eve);
	data['$right_template'].on('mouseenter mouseleave', over_table_eve);

	asyncEachSeries_Original(data['list_result'], function(item, call){

		var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true);
		$lClone.addClass( (item['id']+'_gpl '+data['data-v1']+'_cls '+data['data-v2']) ).eq(0)
				.attr({'data-number': item['accnumber'], 'data-cbcname': data['data-cbc'], 'data-v3': item['id'], 'data-gid': item['id'],
						'data-gcls': (item['id']+'_gpl'), 'data-aid': data['data-v1'], 'data-cls': (data['data-v1']+'_cls'), 'data-num': data['data-v2']})
				.find('span.scell').html( item['name'] );

		setFieldValue($rClone.eq(0).find('td:gt('+(data['ftCell'])+')'), data, item['map_type_FC']['csFC']);	
		setFieldValue($rClone.eq(1).find('td:gt('+(data['ftCell'])+')'), data, item['map_type_FC']['pmFC']);	
		setFieldValue($rClone.eq(2).find('td:gt('+(data['ftCell'])+')'), data, item['map_type_FC']['rsmFC']);	
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
		list_hidden_td=$head.filter('.dn').toArray(), ftCell=$head.filter('.crtQtotal')[0].cellIndex-1;
	
	$head.each(function(){
		cellMonth[this.cellIndex] = this.getAttribute('data-date');
		monthCell[this.getAttribute('data-date')] = this.cellIndex;
	});
	data['cellMonth'] = cellMonth;
	data['monthCell'] = monthCell;
	data['ftCell']=ftCell;

	data['$left'] = data['$row'].next().next().next().next().next();
	data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');
	data['$left_template'] = $('#otherbuproduct tbody tr').clone();
	data['$right_template'] = $('#otherbuproduct tfoot tr').clone();

	data['$right_template'].each(function(){
		var $tds = $(this).find('td');
		for(var i=0, el; el=list_hidden_td[i]; i++){
			$tds.eq(el.cellIndex).addClass('dn');
		}
	});
	data['$left_template'].on('mouseenter mouseleave', over_table_eve).eq(0).attr({'data-isocode': data['$row'].attr('data-isocode')}).find('span.pin').on('click', clickLeftPin_eve);
	data['$right_template'].on('mouseenter mouseleave', over_table_eve);
	data['$left_template'].eq(0).find('span.mark_img').addClass('mark_b').removeClass('g');
	asyncEachSeries_Original(data['list_result'], function(item, call){

		var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true);
		$lClone.addClass( (item['id']+' '+data['data-v1']+'_cls '+data['data-v2']) ).eq(0)
				.attr({'data-number': item['accnumber'], 'data-cbcname': data['data-cbc'], 'data-aid': data['data-v1'],
						'data-v3': item['id'], 'data-v2': data['data-v2'], 'data-v1': data['data-v1']})
				.find('span.scell').html( item['name'] );

		setFieldValue($rClone.eq(0).find('td:gt('+(data['ftCell'])+')'), data, item['map_type_FC']['csFC']);	
				
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
		list_hidden_td=$head.filter('.dn').toArray(), ftCell=$head.filter('.crtQtotal')[0].cellIndex-1;
	
	$head.each(function(){
		cellMonth[this.cellIndex] = this.getAttribute('data-date');
		monthCell[this.getAttribute('data-date')] = this.cellIndex;
	});
	data['cellMonth'] = cellMonth;
	data['monthCell'] = monthCell;
	data['ftCell']=ftCell;

	data['$left'] = data['$row'].next().next().next().next().next().next().next();
	data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');
	data['$left_template'] = $('#productcode tbody tr').clone();
	data['$right_template'] = $('#productcode tfoot tr').clone();

	data['$right_template'].each(function(){
		var $tds = $(this).find('td');
		for(var i=0, el; el=list_hidden_td[i]; i++){
			$tds.eq(el.cellIndex).addClass('dn');
		}
	});
	data['$left_template'].on('mouseenter mouseleave', over_table_eve).eq(0).attr({'data-hierarchy': 'root4', 'data-isocode': data['$row'].attr('data-isocode')})
				.on('click', {$divbody: $('#div_body')}, clickLeftTable_eve).find('span.pin').on('click', clickLeftPin_eve);
	data['$right_template'].on('mouseenter mouseleave', over_table_eve);

	asyncEachSeries_Original(data['list_result'], function(item, call){

		var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true);
		$lClone.addClass( (item['id']+' '+data['data-v1']+'_cls '+data['data-v2']+' '+data['data-v3']+'_gpl ') ).eq(0)
				.attr({'data-number': item['accnumber'], 'data-cbcname': data['data-cbc'], 'data-v4': item['id'], 'title': item['name'], 
						'data-cbcnumber': data['data-number'], 'data-v3': data['data-v3'], 'data-v2': data['data-v2'], 'data-v1': data['data-v1']})
				.find('span.scell').html( item['name'] );

		setFieldValue($rClone.eq(0).find('td:gt('+(data['ftCell'])+')'), data, item['map_type_FC']['csFC']);	
		setFieldValue($rClone.eq(1).find('td:gt('+(data['ftCell'])+')'), data, item['map_type_FC']['pmFC']);	
		setFieldValue($rClone.eq(2).find('td:gt('+(data['ftCell'])+')'), data, item['map_type_FC']['rsmFC']);	
		
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
		list_hidden_td=$head.filter('.dn').toArray(), ftCell=$head.filter('.crtQtotal')[0].cellIndex-1;
	
	$head.each(function(){
		cellMonth[this.cellIndex] = this.getAttribute('data-date');
		monthCell[this.getAttribute('data-date')] = this.cellIndex;
	});
	data['cellMonth'] = cellMonth;
	data['monthCell'] = monthCell;
	data['ftCell']=ftCell;

	data['$left'] = data['$row'].next().next().next().next().next().next();
	data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');
	data['$left_template'] = $('#parttab tbody tr').clone();
	data['$right_template'] = $('#parttab tfoot tr').clone();

	data['$right_template'].each(function(){
		var $tds = $(this).find('td');
		for(var i=0, el; el=list_hidden_td[i]; i++){
			$tds.eq(el.cellIndex).addClass('dn');
		}
	});
	data['$left_template'].on('mouseenter mouseleave', over_table_eve).eq(0).attr({'data-hierarchy': 'root5', 'data-isocode': data['$row'].attr('data-isocode')})
				.addClass('relayrow_part').find('div.dpd_4').addClass('dpd_5').removeClass('dpd_4')
				.find('span.fcell').addClass('spin').on('click', clickLeftPin_eve).parent().find('span.part_d').remove();
	
	data['$right_template'].on('mouseenter mouseleave', over_table_eve);
	
	asyncEachSeries_Original(data['list_result'], function(item, call){

		var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true);
		$lClone.addClass( (item['id']+' '+data['data-v1']+'_cls '+data['data-v2']+' '+data['data-v3']+'_gpl '+data['data-v4']) ).eq(0)
				.attr({'data-number': item['accnumber'], 'data-cbcname': data['data-cbc'], 'title': item['name'], 'data-v5': item['id'],
						'data-gid': data['data-gid'], 'data-v4': data['data-v4'], 'data-v3': data['data-v3'], 'data-v2': data['data-v2'], 'data-v1': data['data-v1']})
				.find('span.scell').html( item['snumber'] );

		setFieldValue($rClone.eq(0).find('td:gt('+(data['ftCell'])+')'), data, item['map_type_FC']['csFC']);
		setFieldValue($rClone.eq(1).find('td:gt('+(data['ftCell'])+')'), data, item['map_type_FC']['pmFC']);	
		setFieldValue($rClone.eq(2).find('td:gt('+(data['ftCell'])+')'), data, item['map_type_FC']['rsmFC']);	
				
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
;function createGPLElement(result, data, isRelay, queueTaskCallBack){
    var $gpl_tab=$('#gpltab'), $right_trs=$('#rtabid tr'), $left_tr=$gpl_tab.find('tbody tr').clone(), 
    	$right_tr=$gpl_tab.find('tfoot tr').clone(), $head=$('#tab_head_list td'), 
		list_hidden_td=$head.filter('.dn').toArray(), list_nhide_td=$head.filter('.nhide').toArray();

    result = complete_resultCheck(result, data, $right_tr);
    if(result.length == 0){  queueTaskCallBack(null); return; }
	
//$l_cbc_row.attr({'data-isocode': data['$row'].attr('data-isocode')});
	$left_tr.on('mouseenter mouseleave', over_table_eve).eq(0).attr({'data-isocode': data['$row'].attr('data-isocode')})
			.on('click', {$divbody: $('#div_body')}, clickLeftTable_eve).find('span.pin').on('click', clickLeftPin_eve);//.find('td:first');//.prepend('<span class="mark_img g"></span>');;
	$right_tr.on('mouseenter mouseleave', over_table_eve);
	
    var o_element=getAppendElment(data);
	
    $right_tr.each(function(){
		var $tds = $(this).find('td');
		for(var i=0, el; el=list_hidden_td[i]; i++){
			$tds.eq(el.cellIndex).addClass('dn');
		}
		for(var i=0, el; el=list_nhide_td[i]; i++){
			$tds.eq(el.cellIndex).addClass('nhide');
		}
	});
    
    asyncEachSeries_Original(result, function(item, callback){

        var $left_clone=$left_tr.clone(true), $right_clone=$right_tr.clone(true), current_fc=item['currentFC'], 
        	previou_fc=item['previousFC'], rsmFC=item['rsmFC'];

        if(!isRelay){    // Allocation CBC2 current forecast values
        	$right_trs.eq(data['$row'].index()).find('input[type="text"]').each(function(){ 
                var _value= numberOfZero($.trim(this.value)), _old= numberOfZero($.trim(this.getAttribute('data-old'))),
                	_cellIndex=$(this).parent()[0].cellIndex;
                if(_old == 0){
                    current_fc[o_element['cells'][_cellIndex]] = (_value * item['precent']);
                }
            }).attr('disabled', true);
            $right_clone.eq(0).attr('data-row-name', 'gpl');
            
            if(item['isHighLighted']){
				$left_clone.eq(0).find('td:first div:first').before('<div class="highLighted"></div>');
			}
        }else{
        	$left_clone.eq(0).addClass('gpl_relay');
        }

        addGPLLeftTabCss($left_clone, data, item);
        formatResultCurrency(current_fc, previou_fc);
        matchRightTableForecast(current_fc, previou_fc, data['o_cell'], $right_clone.eq(0), $right_clone.eq(1), (isRelay ? false : true), false);
        for(var fc in rsmFC){ 
    		$right_clone.eq(2).find('td:eq('+data['o_cell'][fc]+')').text( Globalize.format(rsmFC[fc], 'n') ); 
    	}
        	
    //    $left_clone.eq(0).on('click', {$divbody: $('#div_body')}, clickLeftTable_eve).find('span.pin').on('click', clickLeftPin_eve);
        $right_clone.find('input[type="text"]').on('focus change', input_fc_eve).on('keyup', input_keyup_eve);
        
        o_element['$right_lastRow'].after($right_clone);
        data['$lastRow'].after($left_clone);

    }, function(err){
    	result=[];
    	rowUnLock(data['rowIndex']);
		data['$row'].removeClass('ready').addClass('done').find('span.fcell').html('-').removeClass('waiting');
        setTimeout(function(){ queueTaskCallBack(null); }, 120);
    }, 180);
    
    
    ;function addGPLLeftTabCss($left_clone, data, result){
	    var list_element = $left_clone.toArray(), acls=(data['acls']+' '+data['cbcNum']+' ');
	    for(var i=0, _tr; _tr=list_element[i]; i++){
	    	var $tr=$(_tr), _text=('[ '+ result['gplCode']+' ] - ' + result['fieldName'] );
	        if(i == 0){
	        	$tr.attr({ 'title': _text,
	        		'data-aid': data['aid'], 'data-num': data['cbcNum'], 'data-cbcname': data['cbcName'], 'data-hierarchy': 'root3',
	        		'data-gid': result['prodHichyId'], 'data-gcls': (result['prodHichyId']+'_gpl'), 'data-cls': data['acls']
	        	}).find('span.scell').text( _text );
	        }
	        $tr.addClass( (acls + result['prodHichyId']+'_gpl') );
	    }
	}
	
	;function getAppendElment(data){
		var o = { '$tbody': $('#div_body tbody.overbody'), 'cells': {}}, o_cell = data['o_cell'];
	    o['$right_lastRow']=o['$tbody'].filter('.rtbodycls').find('tr:eq('+data['$lastRow'].index()+')');
	    for(var s in o_cell){ o['cells'][o_cell[s]] = s; }	    
	    return o;
	}
}

;function createPartElement(result, data, queueTaskCallBack){
    var $partner_tab=$('#parttab'), $left_tr=$partner_tab.find('tbody tr').clone(), 
    	$right_tr=$partner_tab.find('tfoot tr').clone(), $head=$('#tab_head_list td'), 
		list_hidden_td=$head.filter('.dn').toArray(), list_nhide_td=$head.filter('.nhide').toArray();
  
    result = complete_resultCheck(result, data, $right_tr);

	if(!data['isRelay']){
		data['add_element'] = '<span class="gplsearch"><div style="display:none;" class="errordiv"><input class="btn addpartbtn" type="button" value="'+CUSTOM_LABEL['searchpart']+'"/></div></span>';
		
    //	data.$row.find('td:first').prepend(data['add_element'])
    	data.$row.find('td:first div.tovhide.dpd_3').before(data['add_element']).parent().parent()
            .find('span.gplsearch').on('mouseenter mouseleave', addGPLOver_eve)
            .find('input[type="button"].addpartbtn').on('click', {isOther : false}, addGPLBtn_eve);
	}
    if(result.length == 0){ 
        queueTaskCallBack(null); 
        return; 
    }
    
    data['$right_lastRow']=$('#rtabid tr:eq('+data['$lastRow'].index()+')');
    
    $left_tr.on('mouseenter mouseleave', over_table_eve).eq(0).attr({'data-isocode': data['$row'].attr('data-isocode')});
    $right_tr.on('mouseenter mouseleave', over_table_eve);
	
    $right_tr.each(function(){
		var $tds = $(this).find('td');
		for(var i=0, el; el=list_hidden_td[i]; i++){
			$tds.eq(el.cellIndex).addClass('dn');
		}
		for(var i=0, el; el=list_nhide_td[i]; i++){
			$tds.eq(el.cellIndex).addClass('nhide');
		}
	});
    
    var total_row={'billing': {}, 'booking': {}, 'backlog': {}}, isFrezen=$('[id*=hidd_frezz]').val(), 
    	quarter_month={'month_cell': {}, 'quarter_cell': {}};

	setMatchCell(quarter_month);

    asyncEachSeries_Original(result, function(item, callback){
        var $l_clone=$left_tr.clone(true), $r_clone=$right_tr.clone(true), current_fc=item['currentFC'], 
        	previou_fc=item['previousFC'], rsmFC=item['rsmFC'];

        matchHistoryData( item['backlog'], total_row['backlog'], quarter_month, $r_clone.filter('.backlog').find('td') );
        matchHistoryData( item['billing'], total_row['billing'], quarter_month, $r_clone.filter('.billing').find('td') );
        matchHistoryData( item['booking'], total_row['booking'], quarter_month, $r_clone.filter('.booking').find('td') );
        
        formatResultCurrency(current_fc, previou_fc);
        matchRightTableForecast(current_fc, previou_fc, data['o_cell'], $r_clone.eq(0), $r_clone.eq(1), (data['isRelay'] ? false : true), false);
        
        addPartLeftTabCss($l_clone, data, item, false);
        
        for(var fc in rsmFC){ 
    		$r_clone.eq(2).find('td:eq('+data['o_cell'][fc]+')').text( Globalize.format(rsmFC[fc], 'n') ); 
    	}
        
        if(isFrezen == 'true'){
        	$l_clone.eq(0).find('span.part_d').remove();
        }
        
        if(!data['isRelay']){
        	if(item['isHighLighted']){
				$l_clone.eq(0).find('td:first').css({'background-color': '#6B8DF1'});
			}
            $l_clone.eq(0).find('span.part_d').on('mouseenter mouseleave', over_partDel_eve)
                    .find('input[type="button"].delpartbtn').on('click', deletePartBtn_eve);
			
            $r_clone.eq(0).attr('data-row-name', 'gpl_part');
        }else{
        	$l_clone.eq(0).addClass('part_relay').find('span.part_d').remove();
        }
        
		$l_clone.eq(0).on('click', {$divbody: $('#div_body')}, clickLeftTable_eve);
        $r_clone.find('input[type="text"]').on('focus change', input_fc_eve).on('keyup', input_keyup_eve);
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
        data['$right_lastRow'].after($r_clone);
		data['$lastRow'].after($l_clone);
		        
    }, function(err){
	    rowUnLock(data['rowIndex']);
	    data['$row'].removeClass('ready').addClass('done').find('td:first span.fcell').html('-').removeClass('waiting');
        setTimeout(function(){ queueTaskCallBack(null); }, 120);
    }, 120);
}

;function createPartOthersElement(result, data, queueTaskCallBack){
    var $partner_tab=$('#parttab'), $left_tr=$partner_tab.find('tbody tr').clone(), $right_tr=$partner_tab.find('tfoot tr').clone(),
		ele_search = '<span class="othersearch"><div style="display:none;" class="errordiv"><input class="btn addpartbtn" type="button" value="'+CUSTOM_LABEL['searchpart']+'"/></div></span>';

    result = complete_resultCheck(result, data, $right_tr);

    data.$row.find('td:first').prepend(ele_search)
                    .find('span.othersearch').on('mouseenter mouseleave', addGPLOver_eve)
                    .find('input[type="button"].addpartbtn').on('click', {isOther : true}, addGPLBtn_eve);
    
    if(result.length == 0){ 
        queueTaskCallBack(null); 
        return; 
    }
	$left_tr.on('mouseenter mouseleave', over_table_eve);
	$right_tr.on('mouseenter mouseleave', over_table_eve);
    data['$right_lastRow']=$('#rtabid tr:eq('+data['$lastRow'].index()+')');

    $left_tr.on('mouseenter mouseleave', over_table_eve).eq(0).find('td:first div:first').addClass('dpd_3').removeClass('dpd_4');
    //		.prepend('<span class="mark_img p"></span>');
    $right_tr.on('mouseenter mouseleave', over_table_eve);
					
    var total_row={'billing': {}, 'booking': {}, 'backlog': {}}, quarter_month={'month_cell': {}, 'quarter_cell': {}};

	setMatchCell(quarter_month);

    asyncEachSeries_Original(result, function(item, callback){
        var $l_clone=$left_tr.clone(true), $r_clone=$right_tr.clone(true),
            current_fc = item['currentFC'], previou_fc = item['previousFC'];

        addPartLeftTabCss($l_clone, data, item, true);
        matchHistoryData( item['backlog'], total_row['backlog'], quarter_month, $r_clone.filter('.backlog').find('td') );
        matchHistoryData( item['billing'], total_row['billing'], quarter_month, $r_clone.filter('.billing').find('td') );
        matchHistoryData( item['booking'], total_row['booking'], quarter_month, $r_clone.filter('.booking').find('td') );
        
        formatResultCurrency(current_fc, previou_fc);
        matchRightTableForecast(current_fc, previou_fc, data['o_cell'], $r_clone.eq(0), $r_clone.eq(1), true, false);
		
		if(item['isHighLighted']){
			$l_clone.eq(0).find('td:first').css({'background-color': '#6B8DF1'});
		}

        $l_clone.eq(0).on('click', {$divbody: $('#div_body')}, clickLeftTable_eve)
        		.find('span.part_d').on('mouseenter mouseleave', over_partDel_eve)
                .find('input[type="button"].delpartbtn').on('click', deletePartBtn_eve);
        $r_clone.eq(0).attr('data-row-name', 'other_part')
        		.find('input[type="text"]').on('focus change', input_fc_eve).on('keyup', input_keyup_eve);
		
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
        		
        data['$lastRow'].after($l_clone);
        data['$right_lastRow'].after($r_clone);
    }, function(err){

    	rowUnLock(data['rowIndex']);
		data.$row.removeClass('ready').addClass('done').find('td:first span.fcell').html('-').removeClass('waiting');
        setTimeout(function(){ queueTaskCallBack(null); }, 120);
    }, 120);
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

;function matchHistoryData(items, total_cells, quarter_month, $cells){
	for(var fcMonth in items){
		var q_cell=quarter_month['month_cell'][fcMonth], o_month=quarter_month['quarter_cell'][q_cell], 
			o_month_cell=o_month[fcMonth], isFuture=(o_month_cell['isQcell'] && !o_month_cell['isCurrent']),
			$cell=$cells.eq( (isFuture ? q_cell : o_month_cell['cell']) ), old=$cell.attr('data-old'),
			total_old=total_cells[$cell[0].cellIndex];
			
		old=($.isNumeric(old) ? parseFloat(old) : 0);
		old+=items[fcMonth];
		$cell.attr('data-old', old);
		$cell.attr('data-old-o', items[fcMonth]);
		total_old=($.isNumeric(total_old) ? parseFloat(total_old) : 0);
		total_old+=items[fcMonth];
		total_cells[$cell[0].cellIndex]=total_old;
	}

	$cells.parent().find('td').each(function(){
		var $this=$(this)
		if(!$this.hasClass('futurec1') && $this.hasClass('qtotalCls')){
			var v1=parseFloat($this.prev().attr('data-old-o')), v2=parseFloat($this.prev().prev().attr('data-old-o')),
				v3=parseFloat($this.prev().prev().prev().attr('data-old-o'));
			v1=(($.isNumeric(v1) ? v1 : 0)+($.isNumeric(v2) ? v2 : 0)+($.isNumeric(v3) ? v3 : 0));
			$this.attr('data-old', old).html(Globalize.format(v1, 'n'));
		}else{
			var val=parseFloat($this.attr('data-old-o'));
			$this.html( Globalize.format(($.isNumeric(val) ? val : 0), 'n') );
		}
	});

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


;function setFilterParts(data_json, list_parts){
	$( ('#ltabid tr.rt4.'+data_json['aId']+'_cls') ).each(function(){
		list_parts.push( (this.getAttribute('data-pid')) );
	});
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

;function over_partDel_eve(e){
    var $this=$(this);
    eventHandle_ov_ot(e, ov, ot);
    
    ;function ov(e){ $this.find('div').show(); }
    ;function ot(e){ 
        if($this.find('input[type="button"].delpartbtn').hasClass('disabled_btn')){
            return;
        }
        $this.find('div').hide(); 
    }
}

;function over_table_eve(e){
    var $this=$(this), _idx=$this.index(), findTab=($this.parent().hasClass('ltbodycls') ? '#rtabid tr' : '#ltabid tr.onetr');
    eventHandle_ov_ot(e, ov, ot);
    
    ;function ov(e){ $(findTab).eq(_idx).addClass('overbodybg'); }
    ;function ot(e){ $(findTab).eq(_idx).removeClass('overbodybg'); }
}

;function deletePartBtn_eve(e){
    e.stopPropagation();
    var $this=$(this);
    if($this.hasClass('disabled_btn')){ return false; }
    $this.val(' ').addClass('disabled_btn');
    
    var $part_tr = $this.parent().parent().parent().parent().parent(), element_tr=$part_tr[0],
        aid=$part_tr.attr('data-aid'), pid=$part_tr.attr('data-pid'), gid=$part_tr.attr('data-gid'),
    	cbcName=$part_tr.attr('data-cbcname'), isOther=($part_tr.attr('data-cbcname') == 'Others' ? true : false),
        cbcNum=$part_tr.attr('data-num'),
    	$parts=$part_tr.parent().find('tr.'+aid+'_cls.'+cbcNum+'.'+pid+'_part'+(isOther?'':'.'+gid+'_gpl'));
    
    gid = (isOther ? null : gid);
    aid = (aid == 'customother' ? OTHER_LABEL: aid);

    var params = {'json': '{"map_year": '+$.trim($('[id*=hidd_yearfutureid]').val())+',"territoryCode": \"'+$.trim($('[id*=hidd_territorycodeid]').val())
    				+'\", "isOther": '+isOther+', "aId": \"'+aid+'\", "partId": \"'+pid
    				+'\", "cbc2Name": \"'+cbcName+'\", "gplId": \"'+gid+'\"}', 'rowIndex': element_tr.rowIndex, '$element': $part_tr, '$parts': $parts};

    customRemoteAction(params, deletePart_js, complete_deletePart); //delete part remote action
}

;function searchTopPartBtn_eve(target){

	if(TOP_FIRST){
    		TOP_FIRST=false;
		$('#multiselect_simple').find('option').remove();
	}
	
	$('#popupbox input[type="button"]').attr('disabled', true);
	$('#popup_loading').html(' ').show();
	var o_json = $.parseJSON($('#saveSearchPartId').attr('data-val')), list_parts=[];
	
	setFilterParts(o_json, list_parts);
	setFilterSearchTopPart(list_parts);
	
	o_json['json'] = $.parseJSON(o_json['json']);
	o_json['json']['isTop'] = true;
	o_json['json']['territoryCode'] = $('#hidd_territorycodeid').val();
	o_json['hasTop'] = true;
	o_json['json']['json_partIds'] = list_parts;

	o_json['json'] = JSON.stringify(o_json['json']);
console.log( o_json );
	customRemoteAction(o_json, addedPart_js, complete_searchTopPart); //add part remote action
	
	;function setFilterSearchTopPart(list_parts){
		$('#multiselect_simple').find('option').each(function(){
			list_parts.push(this.value);
		});
	}
}


;function searchPartPopUP(target){
	TOP_FIRST=true;
    SAVE_PART = [];     //clear search part list

    var $popbox = $('#popupbox'), $input = $('#searchpart_inputid'), $loading = $popbox.find('#popup_loading'),
        data_json = $.parseJSON($popbox.find('#saveSearchPartId').attr('data-val')), list_parts=[];
        

    $loading.html(' ').show();
    setFilterParts(data_json, list_parts);

    $popbox.find('input[type="button"]').attr('disabled', true);
	
    data_json['json'] = $.parseJSON(data_json['json']);
    data_json['json']['isTop'] = false;
    data_json['json']['partName'] = $.trim($input.val());
//    o_json['territoryCode'] = $('#hidd_territorycodeid').val();
    data_json['json']['json_partIds'] = list_parts;
    data_json['json'] =  JSON.stringify(data_json['json']);
    customRemoteAction(data_json, searchAllPart_js, complete_searchAddedPart); 
}

;function addGPLBtn_eve(e){
    e.stopPropagation();
    var $this=$(this), $element_tr = $this.parent().parent().parent().parent(), 
    	$body=$element_tr.parent(), aid=$element_tr.attr('data-aid'), gid=$element_tr.attr('data-gid'),
    	cbcNum=$element_tr.attr('data-num'), cbc2_code=$element_tr.attr('data-cbcname'),
        $popupbox=$('#popupbox'), $multiselect = $popupbox.find('#multiselect_simple'), hasError = false;
	
    gid = (typeof(gid) == 'undefined' ? null : gid);
 
    var params = {'json': '{"currentYear": "'+$('#hidd_cyear').val()+'", "currentMonth": "'+$('#hidd_cmonth').val()+'", "quarterNumb": \"'+$('#hidd_quarternumbid').val()+'\", "map_year": '+$('#hidd_yearfutureid').val()+
    						', "isTop": '+false+', "isOther": '+e.data['isOther']+', "cbc2Name": \"'+cbc2_code+'\", "aId": \"'+aid+'\", "gplId": \"'+gid+'\"}',
    				'cbcCode': cbc2_code, 'cbcNum': cbcNum, 'rowIndex': $element_tr.index(), 'isOther': e.data['isOther'], 'aId': aid, 'gid': gid};

    $multiselect.find('option').remove();
    $popupbox.find('#saveSearchPartId').attr('data-val', JSON.stringify(params));
    $popupbox.find('#popup_loading').html(' ').hide();
    
    try{  $multiselect.multiselect('refresh'); }
    catch(e){ hasError = true;}
    
    $('#popupmain').fadeIn('fast');
    $popupbox.css({'top':-800, 'display':''}).stop().animate({'top':'10%'}, 800, function(){
        if(hasError){
            $multiselect.css('min-width', $popupbox.find('#popup_title').outerWidth(true));
            init_multiselect();
        }
        $popupbox.find('#searchpart_inputid').val('').focus();
    });
}

;function submitAMForecast(target){
	var el_save=document.getElementById('saveaminputid');
	
	if(el_save.getAttribute('data-submit') == 'no'){
		IS_SUBMIT=false;
		saveAndSubmitAMForecast();
		return;
	}
	
	IS_SUBMIT=true;
	el_save.click();
}

;function saveAndSubmitAMForecast(){
	document.getElementById('loading-curtain-div').style.display='';
	var str_json=JSON.stringify({'managerId': $('#hidd_managerid').val(), 'territoryCode': $('#hidd_territorycodeid').val()});
	$('#submitamhidd').val(str_json);
	submitAM();	//this is action function.
}

;function submitAMComplete(){
	$('[id*=hidd_frezz]').val(true);
	$('#saveaminputid').remove();
	$('#submitamfcid').parent().remove();
	$('#ltabid span.part_d').remove();
	document.getElementById('loading-curtain-div').style.display='none';
}

;function saveSearchPart(target){

    if(SAVE_PART.length == 0){
        $('#searchpart_inputid').focus();
        return;
    }

    $('#popup_loading').html(CUSTOM_LABEL['savemsg']).show();
    var $this=$(target), o_json=$.parseJSON(target.getAttribute('data-val')), $popbox=$('#popupbox'), 
        $l_append=$('#ltabid tr.'+(o_json['isOther'] ? 'cbcsub' : 'gplsub')+'.'+o_json['aId']+'_cls.backlog.'+o_json['cbcNum']+(o_json['isOther'] ? '' : '.'+o_json['gid']+'_gpl')), 
        $r_append=$('#rtabid tr:eq('+$l_append.index()+')'), list_part=SAVE_PART.slice(0),
        $partner_tab=$('#parttab'), $left_tr=$partner_tab.find('tbody tr').clone(), $right_tr=$partner_tab.find('tfoot tr').clone();

	SAVE_PART=[];   
    $popbox.find('input[type="button"]').attr('disabled', true);
    o_json['json'] = $.parseJSON(o_json['json']);
    
    setRefDataJSON();
    
    $left_tr.on('mouseenter mouseleave', over_table_eve).eq(0).on('click', {$divbody: $('#div_body')}, clickLeftTable_eve);
    $right_tr.on('mouseenter mouseleave', over_table_eve)
    		 .find('input[type="text"]').on('focus change', input_fc_eve).on('keyup', input_keyup_eve);

    $('#tab_head_list td.dn').each(function(){
        $right_tr.find('td:eq('+this.cellIndex+')').addClass('dn');
    });

    asyncEachSeries_Original(list_part, function(item, callback){
        var item_json=$.parseJSON(item), $l_clone=$left_tr.clone(true), $r_clone=$right_tr.clone(true);

		addPartAttr($l_clone, o_json, item_json);
        if(o_json['isOther']){
			$l_clone.eq(0).find('td:first').addClass('tpd_3').removeClass('tpd_4');
			$r_clone.eq(0).addClass('other_part').attr('data-row-name', 'other_part');
		}else{
			$r_clone.eq(0).addClass('gpl_part').attr('data-row-name', 'gpl_part');
		}
        $l_clone.eq(0).find('span.part_d').on('mouseenter mouseleave', over_partDel_eve)
				.find('input[type="button"].delpartbtn').on('click', deletePartBtn_eve);
		
		$l_append.after($l_clone);
		$r_append.after($r_clone);
		
		var newJson=$.extend({}, o_json);
		newJson['$rcell']=$r_clone;
		newJson['json']['set_partIds']=[item_json['partId']];
        newJson['json']=JSON.stringify(newJson['json']);

		customRemoteAction(newJson, getAddPartRefData_js, complete_getAddPartRefData);
		
    }, function(err){
        $('#popup_loading').html(CUSTOM_LABEL['savemsgsuccess']).fadeOut(1200);
        $popbox.find('input[type="button"]').removeAttr('disabled');
        closePopUP(null);
    }, 120);
	

    ;function addPartAttr($l_clone, o_json, o_part){
		var gcls = (o_json['gid']==null ? '' : o_json['gid']+'_gpl'),
			aCls=(o_json['aId']+'_cls '+o_json['cbcNum']+' '+gcls+' '+o_part['partId']+'_part');
    
    	$l_clone.addClass(aCls).eq(0)
    			.attr({
    				'title': o_part['partName'],
	        		'data-aid': o_json['aId'], 'data-cls': o_json['aId']+'_cls', 'data-hierarchy':'root4',
	        		'data-num': o_json['cbcNum'], 'data-gid': o_json['gid'], 'data-gcls': gcls,
	        		'data-pid': o_part['partId'], 'data-pcls': o_part['partId']+'_part', 'data-cbcname':o_json['cbcCode']
	        	});//.find('td:first').prepend('<span class="t_img p '+(o_json['isOther'] ? '' : 'pfix')+'"></span>');
    	$l_clone.find('span.scell').text(o_part['partDesc']);
    }
    
    ;function setRefDataJSON(){//hidd_mapfuture
    	
    	var mCell={}, $list_head=$('#tab_head_list td');
		$list_head.filter('.qtotalCls').each(function(){
			var isFuture=$(this).hasClass('futurec1'), months=this.getAttribute('data-months').split(',');
			for(var i=0, month; month=months[i]; i++){
				var cell=(isFuture ? this.cellIndex : $list_head.filter('[data-month="'+month+'"]')[0].cellIndex);
				mCell[month]={'cell': cell, 'isFuture': isFuture};
			}
		});
		o_json['mCell']=mCell;
    	o_json['currentCell']=$list_head.filter('.crtQtotal')[0].cellIndex+1;
    	o_json['json']['map_year_monthsHistory']=$.parseJSON( $('[id*=hidd_maphistory]').val() );
    	o_json['json']['map_year_monthsFuture']=$.parseJSON( $('[id*=hidd_mapfuture]').val() );
    	o_json['json']['map_acctId_currencyIso']=$.parseJSON( $('[id*=hidd_actcurrencyid]').val() );
		o_json['json']['map_year']=$.parseJSON( $('#hidd_yearfutureid').val() );
		o_json['json']['territoryCode']=$('[id*=hidd_territorycodeid]').val();
		o_json['json']['periodStartDate']=$('[id*=hidd_periodsdid]').val();
		o_json['json']['refStartDate']=$('[id*=hidd_start]').val();
		o_json['json']['refEndDate']=$('[id*=hidd_end]').val();
		o_json['json']['set_partIds']=[];
    	
    	
    	//"map_year_monthsFuture": '+$('#hidd_mapfuture').val()
    }
    
}

;function saveAMForecast(target){
	
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
		$left_trs=$('#ltabid tr'), $right_trs=$('#rtabid tr'), qNumber=getQuarterNumber(),
		actCurrency=getActCurrency(), $progressbar = $("#progressbar").progressbar({ value: false }).attr('data-value', 0);		
	$('#tab_head_list td.qcell').each(function(){
		o_cell[this.cellIndex] = this.getAttribute('data-date');
	});
	
	findForecastGpl(list_save);
	findForecastOther(list_save);

	if(list_save.length == 0){ 
		$('div.progress_cls').hide();
		if(IS_SUBMIT){
			saveAndSubmitAMForecast();
		}
		return; 
	}
	
	if(!IS_SUBMIT){ $(target).attr('data-submit', 'no'); }
	
	var percent=(1 / list_save.length * 100), max=Math.floor(percent*list_save.length), bg_color=Math.floor( Math.random() * 16777215 ).toString( 16 ), 
		list_rgba=$.Color('#'+bg_color)._rgba, rgba=( 'rgba('+list_rgba[0]+','+list_rgba[1]+','+list_rgba[2]+',0.3)' );

	$progressbar.progressbar({ max: max, change: progressbarChange, complete: progressbarComplete }).find('.ui-progressbar-value')
				.css({ "background": '#' + bg_color });
	asyncEachSeries_Original(list_save, function(item, callback){
		item['data']['percent'] = percent;
		item['data']['max'] = max;
        customRemoteAction(item, saveForecast_js, complete_saveForecast); //this is remote action
    }, function(err){  }, 180);
    
	$('#progresserror').css({'background': rgba, 'top': '-20%'}).animate({top: '10%'}, 360, animateComplete);

	/* START save forecast Helper methods*/
	;function animateComplete(){
		$('#prg_total').html( list_save.length );
		$('#prg_scues').html(0);
		$('#prg_err').html(0);
	}

	;function findForecastOther(list_save){
		var $left_parts=$left_trs.filter('.rt4:not(.part_relay)');
		$left_trs.filter('.rt2.cls_other').each(function(){
			var $this=$(this), json_map={}, list_part=[], json_act = {'className': 'ClsAPLForecastObjects.OtherCBCObject', 'str_json': {}},
				aid=$this.attr('data-aid'), data_num=$this.attr('data-num'), isoCode=$this.parent().find('tr.rt1.'+aid).attr('data-isocode'),
				$tds=$right_trs.eq(this.rowIndex).find('td');
			
			if(!$left_trs.filter('.rt1.'+aid).hasClass('done')){
				return true;	//continue for each.
			}
				
			
			setForecastValues(json_map, $tds);
		//	list_part.push( create_part_josn(false, false, null, null, null, $this.attr('data-cbcname'), null, null, isoCode, json_map, null, null) );
			
			json_act['str_json'] = create_josn(false, qNumber, territoryCode, getAcctId(aid), null, null, null, isoCode, json_map, list_part, map_year_quartersFuture, actCurrency);
			list_save.push( {'json': JSON.stringify(json_act), 'data': {'json': json_act, 'bar': $progressbar, 'name': $(this).find('span.cbc_cell').text()}} );
		});
	}
	
	;function findForecastGpl(list_save){
		var $left_parts=$left_trs.filter('.rt4:not(.relayrow_part):not(.part_relay)');
		
		$left_trs.filter('.rt3:not(.realyrow):not(.gpl_relay):not([data-cbcname="Others"])').each(function(){
			var $this=$(this), json_map={}, json_act = {'className': 'ClsAPLForecastObjects.GplObject', 'str_json': {}},
				aid=$this.attr('data-aid'), gid=$this.attr('data-gid'), data_num=$this.attr('data-num'),
				code=$this.attr('data-cbcname'), isoCode=$this.parent().find('tr.rt1.'+aid).attr('data-isocode'),
				$tds=$right_trs.eq(this.rowIndex).find('td'), list_part=[];
			setForecastValues(json_map, $tds);
			set_GPL_Part($left_parts, aid, data_num, gid, isoCode, list_part);
			/*
			if(list_part.length == 0){
				return true;	//continue for each.
			}
			*/
			json_act['str_json'] = create_josn(false, qNumber, territoryCode, getAcctId(aid), code, gid, null, isoCode, json_map, list_part, map_year_quartersFuture, actCurrency);

			list_save.push( {'json': JSON.stringify(json_act), 'data': {'json': json_act, 'bar': $progressbar, 'name': $(this).find('span.scell').text()}} );
		});
	}

	;function set_GPL_Part($left_parts, aid, data_num, gid, isoCode, list_part){
		var list_parts=$left_parts.filter('.'+aid+'_cls.'+data_num+'.'+gid+'_gpl').toArray();
		while(list_parts.length > 0){
			var _part=list_parts.shift(), $part=$(_part), json_map={}, str_json={}, pid=_part.getAttribute('data-pid'),
				code=$(_part).attr('data-cbcname'), $tds=$right_trs.eq(_part.rowIndex).find('td');
			setForecastValues(json_map, $tds);
			str_json = create_part_josn(false, false, qNumber, territoryCode, getAcctId(aid), code, gid, pid, isoCode, json_map, map_year_quartersFuture, actCurrency);
			list_part.push(str_json);
		}
	}

	;function getAcctId(aid){ return (aid == 'customother' ? OTHER_LABEL : aid); }
	;function getTerritoryCode(){ return $.trim($('[id*=hidd_territorycodeid]').val()); }
	;function getQuarterFuture(){ return $.trim($('[id*=hidd_yearfutureid]').val()); }
	;function getQuarterNumber(){ return $.trim($('[id*=hidd_quarternumbid]').val()); }
	;function getActCurrency(){ return $.trim($('#hidd_actcurrencyid').val()); }
	;function setForecastValues(json_map, $tds){
		for(var o in o_cell){
			json_map[o_cell[o]] = numberOfZero($.trim($tds.eq(o).find('input[type="text"]').val()));
		}
	}
	;function create_josn(isRelay, qNumber, territoryCode, aid, cbcCode, gplId, partId, isoCode, j_map, list_part, map_qf, actCurrency){
		return '{"isRelay": '+isRelay+',"territoryCode": "'+territoryCode+'", "parentId": "'+aid+'", "cbc2Code": "'
				+cbcCode+'", "currencyIso": "'+isoCode+'", "quarterNumb": "'+qNumber+'", "gplId": "'+gplId+'", "partId": "'+partId+'", "map_dateKey_fc": '
				+JSON.stringify(j_map)+', "list_partFC": ['+list_part.join(',')+'], "map_year_quartersFuture": '+map_qf+', "map_acctId_currencyIso": '+actCurrency+' }';
	}
	;function create_part_josn(isOther, isRelay, qNumber, territoryCode, aid, cbcCode, gplId, partId, isoCode, j_map, map_qf, actCurrency){
		return '{"isOther": '+isOther+', "isRelay": '+isRelay+',"territoryCode": "'+territoryCode+'", "parentId": "'+aid+'", "cbc2Code": "'
				+cbcCode+'", "currencyIso": "'+isoCode+'", "quarterNumb": "'+qNumber+'", "gplId": "'+gplId+'", "partId": "'+partId+'", "map_dateKey_fc": '
				+JSON.stringify(j_map)+', "map_year_quartersFuture": '+map_qf+', "map_acctId_currencyIso": '+actCurrency+' }';
	}
	/* END save forecast Helper methods*/
}

;function reSaveForecast(target){
	var $progressbar = $("#progressbar").progressbar('destroy').attr('data-value', 0), list_save=SAVE_ERRORS.slice(0), 
		percent=(1 / list_save.length * 100), max=Math.floor(percent*list_save.length), bg_color=Math.floor( Math.random() * 16777215 ).toString( 16 ), 
		list_rgba=$.Color('#'+bg_color)._rgba, rgba=( 'rgba('+list_rgba[0]+','+list_rgba[1]+','+list_rgba[2]+',0.3)' );
	
	SAVE_ERRORS=[];
	setPopBoxStatus();
	$('#progresserror').css({ "background": rgba });
	$('#prg_total').html(list_save.length);
	$progressbar.find('div.progress-label').html('Loading...');
	
	$progressbar.progressbar({ value:false, max: max, change: progressbarChange, complete: progressbarComplete })
			.find('.ui-progressbar-value').css({ "background": '#' + bg_color });
	asyncEachSeries_Original(list_save, function(item, callback){
		item['data']['percent'] = percent;
		item['data']['max'] = max;
        customRemoteAction(item, saveForecast_js, complete_saveForecast); //this is remote action
    }, function(err){ list_save = [];}, 180);

	;function setPopBoxStatus(){
		setTimeout(function(){
			$('#showerror').animate({'top': '-120%'}, 360, function(){
				$(this).find('#errtabbody tr').remove();
			});
			$('#progressbarbtn_div').hide().find('input[type="button"].errors').remove();
			$('#prg_scues').html(0);
			$('#prg_err').html(0);
		}, 60);
	}
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
		$('#progressbarbtn_div').show();
		return;
	}
	if(IS_SUBMIT){
		setTimeout(function(){ 
			closeProgressBox();
			saveAndSubmitAMForecast(); 
		}, 210);
		return;
	}else{
		$('#progressbarbtn_div').show();
	}
	
}

;function matchRightTableForecast(current_fc, previou_fc, o_cell, $current_fc, $previou_fc, isInput, isCBC2){
    if(isInput){
    //    var isZero = true;
        for(var fc in current_fc){
            var $input = $current_fc.find('td:eq('+o_cell[fc]+') input[type="text"]'), _value=numberOfZero(current_fc[fc]);
            if($input.length == 0){ $current_fc.find('td:eq('+o_cell[fc]+')').text(Globalize.format(_value, 'n')); }
            else{ $input.val(current_fc[fc]).attr('data-old', _value); }
            if(_value != 0 && isCBC2){ $input.attr('disabled', true); }
        }
    //    if(!isZero && isCBC2){ $current_fc.find('input[type="text"]').attr('disabled', true); }
    }else{
        for(var fc in current_fc){ $current_fc.find('td:eq('+o_cell[fc]+')').text(current_fc[fc]); }
    }
    for(var fc in previou_fc){ $previou_fc.find('td:eq('+o_cell[fc]+')').text(previou_fc[fc]); }
}
;function formatResultCurrency(current, previou){
	var point='n';//+$('#hidd_price').val();
    for(var s in current){ current[s] = Globalize.format(current[s], point); }
    for(var s in previou){ previou[s] = Globalize.format(previou[s], 'n'); }
}

;function addReloadPinButton(data, event, reloadButtonEventCallBack){

	data['$pin'].addClass('reload_img').removeClass('pin').off('mouseenter mouseleave click')
				.on('mouseenter mouseleave click', {$data: data}, reloadButtonEventCallBack)
				.append('<b class="reload_msg" style="display:none;">'+event['message']+'</b>');
}


;function reloadCBC2Fc_eve(e){
    reload_public_eve(e, this, searchCBC2_js, complete_searchCBC2); //this cbc2 remote action
}
;function reloadGPL_eve(e){
    reload_gpl_eve(e, this, searchGPL_js, complete_searchGPL);   //this gpl remote action
}
;function reloadGPLOther_eve(e){
    reload_public_eve(e, this, searchOthersGPL_js, complete_searchGPL_Others);  //this other gpl remote action
}
;function reloadGPLRelay_eve(e){
    reload_gpl_eve(e, this, searchRelayGPL_js, complete_searchGPL_Relay);    //this relay gpl remote action
}
;function reloadAddPart_eve(e){
	reload_public_eve(e, this, getAddPartRefData_js, complete_getAddPartRefData);  //this part remote action
}
;function reloadPartFc_eve(e){
    reload_public_eve(e, this, searchPart_js, complete_searchPart);  //this part remote action
}
;function reload_gpl_eve(e, target, searchRemoteAction, complete_searchRemoteAction){
    e.stopPropagation();
    
    var _data = e.data.$data, _this = target, $this = $(_this), $span=$this.parent(),
        $td=$span.parent().parent(), $tr=$td.parent();

    eventHandle(e, ov, ot, click);
    
    ;function ov(){ 
        if(navigator.userAgent.indexOf("Firefox")>0){
            $span.find('b').css({'left': 86, 'display': 'inline-block'});
        }else{
            $span.find('b').css({'display': 'inline-block'});
        }
    }
    ;function ot(){ $span.find('b').hide(); }
    ;function click(){
        $('#refdatastatusid').show();
        rowIsLocked(_data['rowIndex']);
        $tr.addClass('ready');
        $td.find('span.fcell').addClass('waiting');
        customRemoteAction(_data, searchRemoteAction, complete_searchRemoteAction);
        $this.off('mouseenter mouseleave click').parent().remove();
    }
}
;function reload_public_eve(e, target, searchRemoteAction, complete_searchRemoteAction){
    e.stopPropagation();
    
    var _data = e.data.$data, _this = target, $this = $(_this), $span=$this.parent(),
        $td=$span.parent().parent(), $tr=$td.parent();

    eventHandle(e, ov, ot, click);
    
    ;function ov(){ 
        if(navigator.userAgent.indexOf("Firefox")>0){
            $span.find('b').css({'left': 86, 'display': 'inline-block'});
        }else{
            $span.find('b').css({'display': 'inline-block'});
        }
    }
    ;function ot(){ $span.find('b').hide(); }
    ;function click(){
        rowIsLocked(_data['rowIndex']);
        $tr.addClass('ready');
        $td.find('span.fcell').addClass('waiting');
        customRemoteAction(_data, searchRemoteAction, complete_searchRemoteAction);
        $this.off('mouseenter mouseleave click').parent().remove();
    }
}

;function windowReSize(e){
    $('#forecastdiv_id').css({'visibility': 'hidden'});
    fixAMTableLayout($('#tabContainer').width(), false);
}
;function rCellScrollAM_eve(e){
    var _this=this, scLeft=_this.scrollLeft;
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
    fixAMTableLayout($('#tabContainer').width(), false);
    
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
        if($this.hasClass('firstHistory') && (!isMSIE()['isTheBrowser'])){
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
        
        if($this.hasClass('firstHistory') && (!isMSIE()['isTheBrowser'])){
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
        $compbody.css('visibility', 'visible');
        $('#floatscroll').css({'width': rightCell_w, 'left': $('#rCellScroll').offset()['left']}).find('#innerData').css('width', $('#rTabDataId').width());
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
    var qCell={}, $tab_body=$('#div_body'), $head_td_list=$('#tab_head_list td'), 
    	startQcell=$head_td_list.filter('.qcell:first').index()-1, reatPoint='n'+$('#hidd_currency').val();

    $head_td_list.filter('.qtotalCls').each(function(){
    	qCell[this.getAttribute('data-date')]=this.cellIndex;
    });
    
	$tab_body.find('#ltabid tr').filter('.posFC.actsub, .cmaFC.actsub, .totalSA.actsub').each(function(){
		this.className += ' nhide ';
		$tab_body.find('#rtabid tr').eq(this.rowIndex).addClass('nhide');
	});
    $tab_body.find('b.fmt_cls').html(function(){
        var reat = parseFloat( $.trim(this.getAttribute('data-reat')) );
        this.innerHTML = (this.getAttribute('data-code') + ' ' + Globalize.format(reat, reatPoint));
    });
    $tab_body.find('#rtabid tr.fmt_rcls').find('td:gt('+startQcell+')').each(function(){
        var $this=$(this), $rmsCell=$this.parent().next().find('td:eq('+this.cellIndex+')'),
        	_rsmVal=getZeroOfNumber($rmsCell.attr('data-value')), _value=getZeroOfNumber($.trim(this.getAttribute('data-value')));
        $rmsCell.html( Globalize.format(_rsmVal, 'n') );
        this.innerHTML = Globalize.format(_value, 'n');
    });
    $tab_body.find('#rtabid tr.relayfctotal').each(function(){
    	var $this=$(this), json=$.parseJSON($this.attr('data-total')), $tds=$this.find('td');
    	for(var date in qCell){
	    	$tds.eq(qCell[date]).html( Globalize.format(json[date], 'n') );
    	}
    });
}

;function cancelGroup(target){
    document.getElementById('loading-curtain-div').style.display='';
    window.location.href='/home/home.jsp';
}

;function backForecast_eve(target, _url) {
    document.getElementById('loading-curtain-div').style.display = '';
    if($('[id*=hidd_frezz]').val() == 'true'){
    	window.location.reload();
    	return;
    }
    if(_url == ''){
        backForecast();     //this is CtrlAccountGrouping.cls action function
        return;
    }
    window.location.href = _url;
}

;function backForecastComplete(){
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
;function addListener (element, event, fn, params) {
    var eventHandler = ( params ? function(){ fn.call(params); } : fn );
    if (window.attachEvent) {
        element.attachEvent('on' + event, eventHandler);
    } else {
        element.addEventListener(event, eventHandler, false);
    }
}