var TIMEOUT, STATIC_VAR = {}, SAVE_PART=[], IS_RELAY_SUBMIT=false, TOP_RelayFIRST=true, SAVE_ERRORS=[], 
	WORK_RELAYCLS={
		'level1': 'APL_ClsRelayService.SearchLevel1', 'level2': 'APL_ClsRelayService.SearchLevel2',
		'level3': 'APL_ClsRelayService.SearchLevel3', 'level4': 'APL_ClsRelayService.SearchLevel4'
	},
	_queueTask = async.queue(queueTask, 1);

;function queueTask(task, callback) {
    task.run(callback);
}

;function initCtrlDocument(){
    Globalize.culture(this.locale).numberFormat.currency.symbol = "";
    initRelayDocument();
}

;function initRelayDocument(){
    $('#floatscroll').css({'height': scrollbarW, 'line-height': scrollbarW});
    appendRelayExpCol();
    registerRelay_event();
    fixTableLayoutRelay();
    finalFormatRelay();
    document.getElementById('loading-curtain-div').style.display = 'none';
}


;function init_multiselectRelay(){
	$.uix.multiselect.i18n["custom_i18n"] = {
	    itemsSelected_nil: 'selected option',          // 0
    	itemsSelected: 'selected option',          // 0, 1
    	itemsSelected_plural: 'selected option',  // n
    	itemsAvailable_nil: 'items available', itemsAvailable: 'items available',
    	itemsAvailable_plural: 'items available', itemsFiltered_nil: '0 options found',
    	itemsFiltered: '{count} option found', itemsFiltered_plural: '{count} options found'
	};
    var defaultOptions = {
            availableListPosition: 'left', moveEffect: 'blind', moveEffectOptions: {direction:'vertical'}, moveEffectSpeed: 'fast'
        },
        widgets = { 'simple': $.extend($.extend({}, defaultOptions), { sortMethod: 'standard', sortable: true }) };
    
    var $multiselect=$('#multiselect_simple').multiselect(widgets['simple'])
				        .on('multiselectChange', function(evt, ui) {
				            var values = $.map(ui.optionElements, function(opt) {
				            //	var o={'partDesc': $(opt).attr('data-desc'), 'gId': $(opt).attr('data-gid'), 'partName': $(opt).attr('data-name'), 'partId': $(opt).attr('value')};
				            	return $(opt).attr('data-json'); 
				            });
				            if(ui['selected']){ while(values.length >0){ SAVE_PART.push(values.shift()); } }
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


;function registerRelay_event(){
	var $body_div = $('#div_body');
    //	scroll_attr={'$ghb': $('#globalHeaderBar'), '$abh': $('#AppBodyHeader'), '$menu':$('#menudivid'), '$floathead': $('#headmainid')};

    $body_div.find('tbody.overbody tr').off('mouseenter mouseleave').on('mouseenter mouseleave', overTableRelay_eve);  
    $body_div.find('#rCellScroll').scroll(rCellScroll_eve);
    $body_div.find('#ltabid tr.cp').off('click').on('click', {$divbody: $body_div}, clickLeftTableRelay_eve)
			 .find('span.pin').off('click').on('click', clickLeftRelayPin_eve);
	$body_div.find('#ltabid tr.trt_trt').off('click').on('click', clickLeftTableTotalRelay_eve);
    $('#searchpart_inputid').off('keyup').on('keyup', input_search_key_eve);
    $('#gototopid').off('mouseenter mouseleave click').on('mouseenter mouseleave click', clickGotoTopRelay_eve);
    $(window).scroll(scroll_eventRelay).smartresize(windowReSizeRelay);
    $('#menuBtntd input').off('click').on('click', event_hideRelayCalendar_click);
    $('#floatscroll').off('scroll').scroll(event_floatRelayScroll);
}

;function scroll_eventRelay(e){
	var x=(document.body.scrollTop||document.documentElement.scrollTop), $top=$('#gototopid');
	setTimeout(function(){
		
		var h=($(document).height() - $(window).height() - 120);
		if(x >= h){ $('#floatscroll').css({'visibility': 'hidden'}); }
		else{ $('#floatscroll').css({'visibility': ''}); }
		
		if(x<=30){$top.fadeOut().hide()}else{$top.fadeIn().show()};
		
		var xx=($('#globalHeaderBar').outerHeight()+$('#AppBodyHeader').outerHeight()+$('#menudivid').outerHeight()+$('#headmainid').outerHeight()+60);
		if((x > xx) && !$('#headmainid').hasClass('floatheadcls')){
			$('#headmainid').addClass('floatheadcls').find('td.tab_head_left ').addClass('leftbt');
		}else if(!(x > xx)){
			$('#headmainid').removeClass('floatheadcls').find('td.tab_head_left ').removeClass('leftbt');
		}
		
	}, 50);
}

;function input_fc_relay_eve(e){
    
    var _this=this, $this=$(_this), ov='', validation_qty=/^([1-9]\d{0,16}|0)(\.\d+)?$/, 
        tv=Globalize.parseFloat($.trim(_this.value)); //focus Event
    
    ov = $this.inputFocusValueFormat(validation_qty, e);

    if(e.type == 'change'){
    	/*
        if(!validation_qty.test(tv) || (tv==ov && ov!='')){ //not changed or old value eq new value
            this.value = Globalize.format(ov, 'n0');
            return;
        }
        */
        var o_cfg = initTabInfo();
        ov = ($.isNumeric(ov) ? ov : 0);
        tv = ($.isNumeric(tv) ? tv : 0);
        _this.value = Globalize.format(tv, 'n0');

        switch(o_cfg['rowType']){
        //    case 'cbc2' :	sumOf_cbc(o_cfg); break;
            case 'part' :   sumOf_part(o_cfg); break;
        }
    }
    
    ;function initTabInfo(){
        var o_cfg = { '$r_td': $this.parent().parent() };
        o_cfg['$r_tr'] = o_cfg['$r_td'].parent();
        o_cfg['$r_trs'] = o_cfg['$r_tr'].parent().find('tr');
        o_cfg['cellIdx'] = o_cfg['$r_td'][0].cellIndex;
        o_cfg['rowIdx'] = o_cfg['$r_tr'][0].rowIndex;
        o_cfg['rowType'] = o_cfg['$r_tr'].attr('data-row-name');
        o_cfg['$l_trs'] = $('#ltabid tr');
        o_cfg['$l_tr'] = o_cfg['$l_trs'].eq(o_cfg['rowIdx']);
        o_cfg['aid'] = o_cfg['$l_tr'].attr('data-aid');
        o_cfg['acls'] = o_cfg['$l_tr'].attr('data-aidcls');
        o_cfg['cbcnum'] = o_cfg['$l_tr'].attr('data-cbc-num');
        return o_cfg;
    }
    ;function sumOf_cbc(o_cfg){
    }
    
    ;function sumOf_part(o_cfg){
    	
    	if(o_cfg['$l_trs'].filter('.trt_trt').hasClass('exp')){
    		o_cfg['$l_trs'].filter('.trt_trt').addClass('col').removeClass('exp').find('span.fcell').html('+');
    		o_cfg['$l_trs'].filter('.trt_0:not(.trt_trt)').addClass('dn');
    		o_cfg['$r_trs'].filter('.trt_0:not(.trt_trt)').addClass('dn');
    	}
    	
    	var $acct_row=o_cfg['$l_trs'].filter( '.rt1.'+o_cfg['acls']), 
    		$cbc_row=o_cfg['$l_trs'].filter('.rt2.'+o_cfg['acls']+'.'+o_cfg['cbcnum']),
    		$acct_cell=o_cfg['$r_trs'].eq($acct_row.index()).find('td:eq('+o_cfg['cellIdx']+')'), 
    		$cbc_cell=o_cfg['$r_trs'].eq($cbc_row.index()).find('td:eq('+o_cfg['cellIdx']+')'),
    		part_total=0, cbc_total=0;

    	o_cfg['$l_trs'].filter('.rt3.'+o_cfg['acls']+'.'+o_cfg['cbcnum']).each(function(){
    		var part_price=$(this).find('td:last input').val(), 
    			part_qty = o_cfg['$r_trs'].eq(this.rowIndex).find('td:eq('+o_cfg['cellIdx']+') input').val();
    		part_qty = numberOfZero($.trim(part_qty));
    		part_price = numberOfZero($.trim(part_price));
    		part_total += (part_qty*part_price);
    	});
    	$cbc_cell.html( Globalize.format(part_total, 'n') );
    	
    	o_cfg['$l_trs'].filter('.rt2.'+o_cfg['acls']).each(function(){
    		var cbc_v = $.trim(o_cfg['$r_trs'].eq(this.rowIndex).find('td:eq('+o_cfg['cellIdx']+')').text());
			cbc_total += numberOfZero(cbc_v);
    	});
    	$acct_cell.html( Globalize.format(cbc_total, 'n') );
    }
}

;function input_price_eve(e){
	e.stopPropagation();
	
	var _this=this, $this=$(_this), ov=0, validation_qty=/^([1-9]\d{0,16}|0)(\.\d+)?$/, 
        point='n'+$('#hidd_price').val(), tv=Globalize.parseFloat($.trim(_this.value)); //focus Event
    
    ov = $this.inputFocusValueFormat(validation_qty, e);

    if(e.type == 'change'){
    	/*
        if(!validation_qty.test(tv) || (tv==ov && ov!='')){ //not changed or old value eq new value
            $this.val( Globalize.format(ov, point) ).focus().select();
            return;
        }
        */
        ov = ($.isNumeric(ov) ? ov : 0);
        tv = ($.isNumeric(tv) ? tv : 0);
        _this.value =  Globalize.format(tv, point);
		sumOf_part(initTabInfo());
    }
    
    
    ;function sumOf_part(o_cfg){
    	var $acct_row=o_cfg['$l_trs'].filter( '.rt1.'+o_cfg['acls']), cbc_total={},
    		$cbc_row=o_cfg['$l_trs'].filter('.rt2.'+o_cfg['acls']+'.'+o_cfg['cbcnum']),
    		$acct_cell=o_cfg['$r_trs'].eq($acct_row.index()).find('td'), 
    		$cbc_cell=o_cfg['$r_trs'].eq($cbc_row.index()).find('td');

    	o_cfg['$l_trs'].filter('.rt3.'+o_cfg['acls']+'.'+o_cfg['cbcnum']).each(function(){
    		var $part_price=$(this).find('input[type="text"]'), price=numberOfZero($part_price.val());
    		o_cfg['$r_trs'].eq(this.rowIndex).find('input').each(function(){
	    		var $input=$(this), qty=numberOfZero( $.trim($input.val()) ),
	    			$td=$input.parent().parent(), cbc_cell_total = cbc_total[$td[0].cellIndex];
    			cbc_total[$td[0].cellIndex]=($.isNumeric(cbc_cell_total) ? cbc_cell_total : 0)+(price*qty);
    		});
    	});
    	
    	for(var cell in cbc_total){
    		var $c_cell=$cbc_cell.eq(cell), cbc_old_val=numberOfZero( $.trim($c_cell.text()) ),
    			$a_cell=$acct_cell.eq(cell), act_old_val=numberOfZero( $.trim($a_cell.text()) );
			
    		act_old_val=(act_old_val-cbc_old_val+cbc_total[cell]);
    		$c_cell.html( Globalize.format(cbc_total[cell], 'n') );
    		$a_cell.html( Globalize.format(act_old_val, 'n') );
    	}
    	if(o_cfg['$l_trs'].filter('.trt_trt').hasClass('exp')){
    		o_cfg['$l_trs'].filter('.trt_trt').addClass('col').removeClass('exp').find('span.fcell').html('+');
    		o_cfg['$l_trs'].filter('.trt_0:not(.trt_trt)').addClass('dn');
    		o_cfg['$r_trs'].filter('.trt_0:not(.trt_trt)').addClass('dn');
    	}
    }
    
    
    ;function initTabInfo(){
        var o_cfg = { '$l_td': $this.parent() };
        o_cfg['$l_tr'] = o_cfg['$l_td'].parent();
        o_cfg['$l_trs'] = o_cfg['$l_tr'].parent().find('tr');
        o_cfg['cellIdx'] = o_cfg['$l_td'][0].cellIndex;
        o_cfg['rowIdx'] = o_cfg['$l_tr'][0].rowIndex;
        o_cfg['aid'] = o_cfg['$l_tr'].attr('data-aid');
        o_cfg['acls'] = o_cfg['$l_tr'].attr('data-aidcls');
        o_cfg['cbcnum'] = o_cfg['$l_tr'].attr('data-cbc-num');
        o_cfg['rowType'] = o_cfg['$l_tr'].attr('data-row-name');
        
        o_cfg['$r_trs'] = $('#rtabid tr');
        o_cfg['$r_tr'] = o_cfg['$r_trs'].eq(o_cfg['rowIdx']);
        return o_cfg;
    }
    
}

;function input_keyup_relay_eve(e){
    var $this=$(this), $td=$this.parent().parent(), $tr=$td.parent(), $tbody=$tr.parent(),
        _cellIndex=$td[0].cellIndex, _rowIndex=$tr[0].rowIndex;

    if(e.shiftKey && e.keyCode == 13){  //find prve cell input
    	$td.prev().find('input[type="text"]').focus().select();
    }else if(e.keyCode == 13){  //find next cell input  	
    	$td.next().find('input[type="text"]').focus().select();
    }
}

;function input_search_key_eve(e){
    var $this = $(this);
    if(e.keyCode == 13){  //find next cell input
        document.getElementById('searchpart_btnid').click();
    }
}

;function clickGotoTopRelay_eve(e){
	var $this = $(this), overcls = 'over';
	;function ov(e){$this.addClass(overcls);}
	;function ot(e){$this.removeClass(overcls);}
	;function ck(e){$('html,body').animate({scrollTop: 0}, 450);}
	eventHandle(e, ov, ot, ck);
}

;function clickLeftTableTotalRelay_eve(e){
	var hide='dn', _this=this, $this=$(this), o_cfg={'rowIdx':_this.rowIndex},
		$l_trs=$this.parent().find('tr'), $r_trs=$('#rtabid tr'), fn=($this.hasClass('exp')? exp : col);
	
	if(rowIsLockedRelay(o_cfg['rowIdx'])){ return false; }

	fn();
	
	;function exp(){
		$l_trs.filter('.trt_0:not(.trt_trt)').addClass(hide);
		$r_trs.filter('.trt_0:not(.trt_trt)').addClass(hide);
        rowUnLockRelay(o_cfg['rowIdx']);
        $this.removeClass('exp').addClass('col').find('span.fcell').html('+');
	}
	
	;function col(){
		var $head_trs=$('#tab_head_list td'), cell_total={}, $tc_cell=$r_trs.filter('.relayfctotal').find('td'),
			$relay_cell=$r_trs.filter('.relayfctotal').find('td'),
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
        rowUnLockRelay(o_cfg['rowIdx']);
        
        for(var cell in cell_total){
        	var realy_val=Globalize.parseFloat($relay_cell.eq(cell).text());
        	$tc_cell.eq(cell).html( Globalize.format(cell_total[cell], 'n') );
        }

        $this.removeClass('col').addClass('exp').find('span.fcell').html('-');
	}
}



;function clickExpColRelay_eve(e){
    var $this=$(this), $b=$this.find('b'), _c1=$this[0].cellIndex, $cols=$('#rsmcolspanid'),
        fn={'excute':($b.hasClass('expand') ? expand : collapse)};
        
	if(!$.isEmptyObject(STATIC_VAR)){
		return false;
	}
	
    fn.excute($('#tab_head_list, #rTabDataId tr:not(.notcell)').toArray());
    fixTableLayoutRelay($('#tabContainer').width(), false);
    
    ;function expand(list_el){
        while(list_el.length > 0){
            var item = list_el.shift();
            $(item.cells[_c1-1]).removeClass('dn');
            $(item.cells[_c1-2]).removeClass('dn');
            $(item.cells[_c1-3]).removeClass('dn');
        }
        if($this.hasClass('crtQtotal') && (!isMSIE()['isTheBrowser'])){
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
        if($this.hasClass('crtQtotal') && (!isMSIE()['isTheBrowser'])){
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

;function clickLeftRelayPin_eve(e){
	e.stopPropagation();
	var _this=this, $this=$(_this), $tr=$this.parent().parent().parent(), $lBody=$tr.parent(), $rBody=$('#rtabid'),
		$billing=$tr.next().next().next(), $booking=$billing.next(), $backlog=$booking.next(),
		remote_fn={ '$lbody': $lBody, '$rbody': $rBody,  'monthCell': {}, 'cellMonth': {}, 'json': {}, 'cls': '', 'crtCell': $('#tab_head_list td.crtQtotal')[0].cellIndex, 
			'findcls': '', 'data-v1': $tr.attr('data-v1'), 'data-v2': $tr.attr('data-v2'), 'data-v3': $tr.attr('data-v3'),
			'data-v4': $tr.attr('data-v4'), 'root': $tr.attr('data-hierarchy'), 'currencyIso': $tr.attr('data-isocode'), 
			'accnumber': $tr.attr('data-number'), 'cbc2Code': $tr.attr('data-cbc-code'), 'territoryCode': $.trim($('[id*=hidd_territorycodeid]').val()),
			'$billing': $billing, '$booking': $booking, '$backlog': $backlog, 'action': getAPLsRefData_js, 'actionBacklog': getBacklogRefData_js,
			'$historicalCells': $('#tab_head_list td.historicalc.qtotalCls, td.crtQtotal'), '$futureCells': $('#tab_head_list td.qtotalCls'), 
			'complete': complete_getRelayRefData, 'completeBacklog': complete_getRelayBacklogRefData
		}, execute=($this.hasClass('spin')? exp : col);

	switch(remote_fn['root']){
		case 'root1': 
			remote_fn['$billing']=$tr.next().next().next().next().next();
			remote_fn['$booking']=remote_fn['$billing'].next();
			remote_fn['$backlog']=remote_fn['$booking'].next();
			remote_fn['cls']=WORK_RELAYCLS['level1'];
			remote_fn['data-v1']=$tr.attr('data-aid');
			remote_fn['findcls']='tr:not(.cp).level1.'+remote_fn['data-v1']+'_cls';
			break;
		case 'root2': 
			remote_fn['cls']=WORK_RELAYCLS['level2'];
			remote_fn['data-v2']=$tr.attr('data-cbc-num');
			remote_fn['findcls']=('tr:not(.cp).level2.cbcsub.'+remote_fn['data-v1']+'_cls.'+remote_fn['data-v2']);
			break;
		case 'root3': 
			remote_fn['cls']=WORK_RELAYCLS['level3'];
			remote_fn['findcls']=('tr:not(.cp).level3.'+remote_fn['data-v1']+'_cls.'+remote_fn['data-v2']+'.'+
								remote_fn['data-v3']+'_level3');
			break;
		case 'root4': 
			remote_fn['cls']=WORK_RELAYCLS['level4'];
			remote_fn['findcls']=('tr:not(.cp).partsub.'+remote_fn['data-v1']+'_cls.'+remote_fn['data-v2']+'.'+
								remote_fn['data-v3']+'_level3.'+remote_fn['data-v4']+'_level4'); 
			break;
	}
	
	execute();
	
	
	;function exp(){
		if(!$this.hasClass('refdata')){
			$this.addClass('refdata');
			remote_fn['$billing'].find('td:eq(1)').css({'position': 'relative'}).append('<span class="topcls">Quantity</span><span class="btmcls">Amount</span>');
			remote_fn['$booking'].find('td:eq(1)').css({'position': 'relative'}).append('<span class="topcls">Quantity</span><span class="btmcls">Amount</span>');
			remote_fn['$backlog'].find('td:eq(1)').css({'position': 'relative'}).append('<span class="topcls">Quantity</span><span class="btmcls">Amount</span>');
			
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
			attr_tmp['json'] = {'set_fiscalMonth': list_q, 'territoryCode': remote_fn['territoryCode'], 'grouping': remote_fn['data-v1'], 'cbc2Code': remote_fn['cbc2Code'],
								'accnumber': remote_fn['accnumber'], 'partId': attr_tmp['data-v4'], 'currencyIso': remote_fn['currencyIso'] };
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
			attr_tmp['json'] = {'set_fiscalMonth': list_q, 'territoryCode': remote_fn['territoryCode'], 'grouping': remote_fn['data-v1'], 'cbc2Code': remote_fn['cbc2Code'],
								'accnumber': remote_fn['accnumber'], 'partId': attr_tmp['data-v4'], 'currencyIso': remote_fn['currencyIso'] };
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
		//	el_body += '<b data-months="'+list_t.join(',')+'" data-status="false" class="ref_box">[M-'+Math.round((i+1)/3)+']</b>';
		}
		el_body += '</div>';
		$element.find('td:first div').append(el_body);
	}
}
;function clickLeftTableRelay_eve(e){

	if(e.target.tagName.toUpperCase() == 'INPUT'){return false;}	//check part rows event for input.
	
    var list_element=[], hide='dn', _this=this, $this=$(_this), $parent=$this.parent(),
        o_cfg={'isRemote':false, 'rowIdx':_this.rowIndex, 'root':_this.getAttribute('data-hierarchy'), 'aid': _this.getAttribute('data-aid'), 'o_cell': undefined},
        $waiting=$this.find('td:first span.fcell'), $pin=$this.find('span.pin'), 
        $right_list_trs=$('#rtabid tr'), fn=($this.hasClass('exp')? exp : col);

    $this.find('td:first span.reload_span').remove();
    if($this.find('td:first input[type="button"].delpartbtn').hasClass('disabled_btn')){ return false; }
//    if(rowIsLockedRelay(o_cfg['rowIdx'])){ return false; }
    if($this.hasClass('ready')){ return false; }

    fn();
    
    ;function exp(){
    	if(isLockedData()){
    		return false;
    	}
    	
    	_queueTask.push({name: o_cfg['rowIdx'], run: function(cb){
	        
	        var expCls=getExpAccountCls(), $right_body_trs=$('#rtabid tr');

	        $parent.find(expCls['aCls']).addClass(hide).each(function(){
	            $right_body_trs.eq(this.rowIndex).addClass(hide).find('td').removeClass(expCls['tCls']);
	            $(this).removeClass('exp col').addClass('col').find('td').removeClass(expCls['tCls'])
						.find('span.fcell').html('+').parent().find('span.pin').addClass('spin');
	        });
	        rowUnLockRelay(o_cfg['rowIdx']);
	        $this.removeClass('exp').addClass('col');
	        $waiting.html('+').removeClass('waiting');
            cb(null);
        }}, function(err){ });
    }
    
    ;function col(){
    	/*
    	if(!isLoadedData()){
    		return;
    	}
    	*/
        var aCls=_this.getAttribute('data-aidcls'), cbcNum=_this.getAttribute('data-cbc-num'), pid=_this.getAttribute('data-pid'), 
			remote_fn={'params':{}, 'rowIndex': o_cfg['rowIdx'], '$row': $this, 'json': {}, 'data-level': o_cfg['root'],
						'data-v1': $this.attr('data-aid'), 'data-v2': cbcNum, 'data-v3': $this.attr('data-v3'), 
						'data-number': $this.attr('data-number'), 'data-cbc-code': $this.attr('data-cbc-code'), 'data-isocode': $this.attr('data-isocode'),
						'remote':function(p){}, 'action': existAPLsObject_js, 'complete': complete_existObject};
        
    	$waiting.addClass('waiting').html('&nbsp;');
    	switch(o_cfg['root']){
    		case 'root1' :
    			aCls = ('tr.rt2.'+aCls);
    			remote_fn['append'] = appendElementRelay_Level2;
    			remoteCheck(aCls, remote_fn, createCbc2JSON, WORK_RELAYCLS['level2']);
    		//	check_forecast(aCls, remote_fn, createCBC2JSON, searchRelayCBC2_js, complete_searchCBC2Relay);
    			break;
    		case 'root2' :
    			remote_fn['data-v1'] = $this.attr('data-v1');
    			aCls = ('tr.rt3:not(.cbcsub).'+remote_fn['data-v1']+'_cls.'+cbcNum);
    			remote_fn['append'] = appendElementRelay_Level3;
    			remote_fn['event-search'] = event_productCode_click;
    			remote_fn['data-label'] = 'Search ProductCode';//CUSTOM_LABEL['searchpart'];
    			remoteCheck(aCls, remote_fn, createProductCodeJSON, WORK_RELAYCLS['level3']);
    			break;
    		case 'root3' :
    			remote_fn['data-v1'] = $this.attr('data-v1');
    			remote_fn['data-v2'] = $this.attr('data-v2');
    			remote_fn['event-search'] = addGPLBtn_relay_eve;
    			remote_fn['data-label'] = CUSTOM_LABEL['searchpart'];
    			remote_fn['append'] = appendElementRelay_Level4;
    			aCls = ('tr.rt4:not(.cbcsub).'+remote_fn['data-v1']+'_cls.'+remote_fn['data-v2']+'.'+remote_fn['data-v3']+'_level3');
    			remoteCheck(aCls, remote_fn, createPartJSON, WORK_RELAYCLS['level4']);
    		//	check_forecast(aCls, remote_fn, createPartJSON, searchRelayPartFC_js, complete_searchPartFCRelay);
    			break;
    	}

		remote_fn['remote'](remote_fn);
		expandElement(aCls);
    }
    
    ;function remoteCheck(findCls, remoteFn, createJSON, actionClass){
    	if($this.hasClass('ready') || $this.hasClass('done')){ return; }
        $this.addClass('ready');
        o_cfg['isRemote'] = true;
        $this.find('span.delprduct').css({'visibility': 'hidden'});
        remoteFn['cls'] = actionClass;
        remoteFn['json'] = JSON.stringify( new createJSON() );
        remoteFn['remote'] = function(p){
        	customMultipleRemoteAction(p, remoteFn['action'], remoteFn['complete']); //this is remote action
        };
    }
    
    ;function check_forecast(find_cls, remote_fun, createJson,remoteAction, completeRemoteAction){
    	if($this.hasClass('ready') || $this.hasClass('done')){ return; }
        $this.addClass('ready');
        o_cfg['isRemote'] = true;
        remote_fun['params'] = createJson(find_cls);
        remote_fun['remote'] = function(p){
        	customRemoteActionRelay(p, remoteAction, completeRemoteAction); //this is remote action
        };
    }

    ;function createCbc2JSON(){
    	this['grouping'] = (o_cfg['aid'] == 'customother' ? OTHER_LABEL : o_cfg['aid']);
		this['currencyIso'] = $this.attr('data-isocode');
		this['territoryCode'] = $.trim($('[id*=hidd_territorycodeid]').val());
		this['map_year_quartersFuture'] = $.parseJSON($('#hidd_yearfutureid').val());
    }
    
    ;function createProductCodeJSON(cls){
		this['grouping'] = ($this.attr('data-v1') == 'customother' ? OTHER_LABEL : $this.attr('data-v1'));
		this['cbc2Code'] = $this.attr('data-cbc-code');
		this['currencyIso'] = $this.attr('data-isocode');
		this['territoryCode'] = $.trim($('[id*=hidd_territorycodeid]').val());
		this['map_year_quartersFuture'] = $.parseJSON($('#hidd_yearfutureid').val());
    }
    
    ;function createPartJSON(cls){
		this['territoryCode'] = $.trim($('[id*=hidd_territorycodeid]').val());
    	this['grouping'] = ($this.attr('data-v1') == 'customother' ? OTHER_LABEL : $this.attr('data-v1'));
		this['accnumber'] = $this.attr('data-number');
		this['map_year_quartersFuture'] = $.parseJSON($('#hidd_yearfutureid').val());
		this['currencyIso'] = $this.attr('data-isocode');
		this['cbc2Code'] = $this.attr('data-cbc-code');
    }

    ;function setForecastCellIndex(o){
    	var $head_trs=$('#tab_head_list td.qcell');
    	$head_trs.each(function(){
    		o['o_cell'][this.getAttribute('data-date')] = this.cellIndex;
    	});
    	o['currentCell']=$head_trs.filter('.crtQtotal')[0].cellIndex;
    }
    ;function expandElement(cls){
    	_queueTask.push({name: o_cfg['rowIdx'], run: function(cb){
            list_element = $parent.find(cls).toArray();

            setColTabBgColor();
            async.eachSeries(list_element, function(item, callback) {
                setTimeout(function(){
                	var $item=$(item);
                    $right_list_trs.eq(item.rowIndex).removeClass(hide);
                    $item.removeClass(hide);
                    callback(null);
                }, 120);
            }, function(err){
                $this.removeClass('col').addClass('exp');
                if(!o_cfg['isRemote']){ 
                    rowUnLockRelay(o_cfg['rowIdx']);
                    $waiting.html('-').removeClass('waiting'); 
                }
                cb(null);
            });
        }}, function(err){ });
    }
    
    ;function getExpAccountCls(){
    	var aCls=_this.getAttribute('data-aidcls'), tabCls='';
        switch(o_cfg['root']){
            case 'root1' : 
            		aCls = ('tr:not(.actsub):not(.rt1).'+aCls);
            		$this.find('td').removeClass('a_bg');
    				$right_list_trs.eq(o_cfg['rowIdx']).find('td').removeClass('a_bg');
    				tabCls='c_bg p_bg';
            	break;
            case 'root2' : 
            		aCls = ('tr:not(.cbcsub):not(.rt1):not(.rt2).'+_this.getAttribute('data-v1')+'_cls.'+_this.getAttribute('data-v2'));
        			$this.find('td').removeClass('c_bg');
    				$right_list_trs.eq(o_cfg['rowIdx']).find('td').removeClass('c_bg');
    				tabCls='g_bg p_bg';
        		break;
            case 'root3' : 
            		aCls = ('tr.level4.'+_this.getAttribute('data-v1')+'_cls.'+_this.getAttribute('data-v2')+'.'+_this.getAttribute('data-v3')+'_level3');
            		$this.find('td').removeClass('g_bg');
    				$right_list_trs.eq(o_cfg['rowIdx']).find('td').removeClass('g_bg');
        		break;
        	case 'root4' : 
            		aCls = ('tr.partsub.'+aCls+'.'+_this.getAttribute('data-cbc-num')+'.'+_this.getAttribute('data-pid')+'_part');
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
        }
	}
	
	;function isLockedData(){
    	var count=0, isLocked=false;
    	switch(o_cfg['root']){
    		case 'root1' :
    		case 'root2' :
    			for(var idx in STATIC_VAR){ if(o_cfg['rowIdx'] != idx){ count++; } }
			break;
    	}
    	if(count != 0){
    		rowUnLockRelay(o_cfg['rowIdx']);
    		isLocked=true;
    	}
    	return isLocked;
    }
}
;function event_hideRelayCalendar_click(e){

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
	fixTableLayoutRelay();
	$this.val( (status == 'show' ? $this.attr('data-show') : $this.attr('data-hide')) );
	$this.attr('data-status', (status == 'show' ? 'hide' : 'show'));
}

;function event_floatRelayScroll(e){
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
;function event_reloadExistData_click(e, $this){
	var _data = e.data.$data;
	rowUnLockRelay(_data['rowIndex']);
    customMultipleRemoteAction(_data, _data['action'], _data['complete']);
    $this.remove();
}

;function event_searchProduct_click(target){
	SAVE_PART = [];     //clear search part list
	$('#popup_loading').show();
	$('#popupbox input[type="button"]').attr({'disabled': 'disabled'});
	var $this=$(target), v=$.trim($('#searchpart_inputid').val()), _json=$.parseJSON($('#addproductcodeid').attr('data-val'));
	_json['json']['searchKey']=v;
	_json['action']=searchAPLsObject_js;
	_json['complete']=complete_searchProductCodeObject;
	_json['cls']=WORK_RELAYCLS['level3'];
	_json['json']=JSON.stringify( _json['json'] );

	customMultipleRemoteAction(_json, _json['action'], _json['complete']);
}

;function event_addProduct_click(target){
	if(SAVE_PART.length == 0){
        $('#searchpart_inputid').focus();
        return;
    }

    $('#popup_loading').html(CUSTOM_LABEL['savemsg']).show();

    var $this=$(target), o_json=$.parseJSON($this.attr('data-val')), $popbox=$('#popupbox');
    
    
    appendProductCode();
	
    ;function appendProductCode(){
    	$popbox.find('input[type="button"]').attr('disabled', true);
    	
    	var $lRow=$('#ltabid tr.cbcsub.backlog.'+o_json['data-v1']+'_cls.'+o_json['data-v2']), $rRow=$('#rtabid tr:eq('+$lRow.index()+')'),
    		$left_template=$('#productcode tbody tr').clone(), $right_template=$('#productcode tfoot tr').clone(), 
    		point='n'+$('#hidd_price').val(), celIndex=$('#tab_head_list td.crtQtotal')[0].cellIndex-1;
	
		$('#tab_head_list td.dn').each(function(){
	        $right_template.find('td:eq('+this.cellIndex+')').addClass('dn');
	    });
	    
	    $left_template.on('mouseenter mouseleave', overTableRelay_eve).eq(0).on('click', clickLeftTableRelay_eve)
						  .find('span.pin').on('click', clickLeftRelayPin_eve);
	    $left_template.eq(0).find('td:last').on('mouseenter mouseleave', overPriceTab_relay_eve)
						  .append('<input type="text" value="" data-type="productcode" class="zidxInput pricecls" style="margin-left: -20px;"/>')
						  .find('input').on('focus change', event_priceRelay_change);
		$left_template.eq(0).find('span.mark_img').addClass('mark_new').removeClass('p');
		$left_template.eq(0).find('input[type="button"].delpartbtn').off('click').on('click', event_deleteProductCode_click);

		$right_template.on('mouseenter mouseleave', overTableRelay_eve).eq(0)
					.find('input').on('focus change', event_qtyInputRelay_change).on('keyup', event_qtyInputRelay_keyup);

    	asyncEachSeries_Original(SAVE_PART, function(item, callback){
    		item=$.parseJSON(item);
			var $lClone=$left_template.clone(true), $rClone=$right_template.clone(true);
			$lClone.addClass( (item['id']+'_level3 '+o_json['data-v2']+' '+o_json['data-v1']+'_cls') ).eq(0)
					.attr({'title': ('[ '+item['accnumber']+' ] '+item['name']), 'data-number': item['accnumber'], 'data-isocode': o_json['data-isocode'], 'data-v3': item['id'], 
							'data-name': item['name'], 'data-cbc-code': o_json['data-code'], 'data-v2': o_json['data-v2'], 'data-v1': o_json['data-v1']})
					.find('span.scell').html( '[ '+item['accnumber']+' ] '+item['name']);
			
			$lClone.eq(0).find('td:last input').val( Globalize.format(0, point) );
			
			$rClone.eq(0).find('td:gt('+celIndex+')').each(function(){
				$(this).attr({'data-old': 0, 'data-amount': 0}).find('input').val( Globalize.format(0, 'n0') );
				$lClone.eq(1).find('td:eq('+this.cellIndex+')').attr({'data-old': 0}).html( Globalize.format(0, 'n') );
			});
			
			$lRow.after($lClone);
			$rRow.after($rClone);
			
		}, function(err){ 
			SAVE_PART=[]; 
			$popbox.find('input[type="button"]').removeAttr('disabled');
			$popbox.find('#popup_loading').html(' ').hide();
			closePopUP(null);
		}, 120);
    	
    }
}

;function event_productCode_click(e){
	e.stopPropagation();
	SAVE_PART=[];
    var $this=$(this), $tr=$this.parent().parent().parent().parent(), hasError = false,
    	$popupbox=$('#popupbox'), $multiselect=$popupbox.find('#multiselect_simple'), 
		$popbottom=$popupbox.find('div.popup_box_bottom'), $poptitle=$popupbox.find('#popup_title'),
    	strJson={'json': {'set_selectedId': [], 'grouping': $tr.attr('data-v1'), 'cbc2Code': $tr.attr('data-cbc-code'), 
    						'territoryCode': $('[id*=hidd_territorycodeid]').val(), 'map_year_quartersFuture': $.parseJSON($('#hidd_yearfutureid').val())},
    				'data-v1': $tr.attr('data-v1'), 'data-v2': $tr.attr('data-cbc-num'), 'data-code': $tr.attr('data-cbc-code'), 'data-isocode': $tr.attr('data-isocode')
				};

	strJson['json']['grouping']=(strJson['json']['grouping'] == 'customother' ? OTHER_LABEL : strJson['json']['grouping']);
    
    $multiselect.find('option').remove();
    
    $popupbox.find('input[type="button"].top_cls').hide();
    $popupbox.find('#searchpart_btnid').hide();
    $popupbox.find('#saveSearchPartId').hide();
    $popupbox.find('#popup_loading').html(' ').hide();
    
    if($poptitle.find('#searchproductcodeid').length == 0){
    	$poptitle.append('<input onclick="event_searchProduct_click(this)" id="searchproductcodeid" value="Search ProductCode" type="button" class="btn"/>');
    	$popbottom.find('#saveSearchPartId').before('<input onclick="event_addProduct_click(this)" id="addproductcodeid" value="add ProductCode" type="button" class="btn"/>');
    }
    
    $tr.parent().find('tr.level3.cp.'+strJson['json']['grouping']+'_cls.'+$tr.attr('data-cbc-num')).each(function(){
    	strJson['json']['set_selectedId'].push(this.getAttribute('data-number'));
    });
    
    $poptitle.find('#searchproductcodeid').show();
    $popbottom.find('#addproductcodeid').show().attr('data-val', JSON.stringify(strJson));;
    
    try{  $multiselect.multiselect('refresh'); }
    catch(e){ hasError = true;}
    
    $('#popupmain').fadeIn('fast');
    $popupbox.css({'top':-1200, 'display':''}).stop().animate({'top':'10%'}, 800, function(){
        if(hasError){
            $multiselect.css('min-width', $popupbox.find('#popup_title').outerWidth(true));
            init_multiselectRelay();
        }
        $popupbox.find('#searchpart_inputid').val('').focus();
    });
}

;function event_deleteProductCode_click(e){
	e.stopPropagation();
	var $this=$(this), $tr=$this.parent().parent().parent().parent().parent(),
		json={'cls': WORK_RELAYCLS['level3'], 'action': delAPLsOjbect_js, 'complete': complete_delRelayProductCode,
				'json': {'grouping': $tr.attr('data-v1'), 'accnumber': $tr.attr('data-number'), 'territoryCode': $('#hidd_territorycodeid').val(),
						'cbc2Code': $tr.attr('data-cbc-code'), 'map_year_quartersFuture': $.parseJSON($('#hidd_yearfutureid').val())},
			  '$btn': $this, '$row': $tr, 'data-v1': $tr.attr('data-v1'), 'data-v2': $tr.attr('data-v2'), 'data-v3': $tr.attr('data-v3')
			 };
			 
	if($tr.hasClass('ready')){ return; }
	$this.hide().parent().parent().addClass('delloaded');
	$tr.off('click');
	
	json['json']['grouping']=(json['json']['grouping'] == 'customother' ? OTHER_LABEL : json['json']['grouping']);

	json['json'] = JSON.stringify(json['json']);
	
	customMultipleRemoteAction(json, json['action'], json['complete']);
}

;function event_deletePart_click(e){
	e.stopPropagation();
	
	var $this=$(this), $tr=$this.parent().parent().parent().parent().parent(),
		json={'cls': WORK_RELAYCLS['level3'], 'action': delRelayPart_js, 'complete': complete_deletePartRelay,
				'json': {'aId': $tr.attr('data-v1'), 'partId': $tr.attr('data-v4'), 'territoryCode': $('#hidd_territorycodeid').val(),
						'cbc2Name': $tr.attr('data-cbc-code'), 'map_year_quartersFuture': $.parseJSON($('#hidd_yearfutureid').val())},
			  '$btn': $this, '$row': $tr, 'data-v1': $tr.attr('data-v1'), 'data-v2': $tr.attr('data-v2'), 'data-v3': $tr.attr('data-v3'), 'data-v4': $tr.attr('data-v4')
			 };

	$this.hide().parent().parent().addClass('delloaded');

	json['json']['aId']=(json['json']['aId'] == 'customother' ? OTHER_LABEL : json['json']['aId']);
	json['json'] = JSON.stringify(json['json']);

	customRemoteActionRelay(json, json['action'], json['complete']);
}

;function event_priceRelay_change(e){
	e.stopPropagation();
	
	var _this=this, $this=$(_this), ov=0, validation_qty=/^([1-9]\d{0,16}|0)(\.\d+)?$/, 
		tv=Globalize.parseFloat($.trim(_this.value)); //focus Event
    
    ov = $this.inputFocusValueFormat(validation_qty, e);

    if(e.type == 'change'){
    	var oJson={'point': ('n'+$('#hidd_price').val()), 'type': _this.getAttribute('data-type'), '$rBody': $('#rtabid'), 
    				'$lRow': $this.parent().parent(), 'crtCell': $('#tab_head_list td.crtQtotal')[0].cellIndex-1
				};
        ov = ($.isNumeric(ov) ? ov : 0);
        tv = ($.isNumeric(tv) ? tv : 0);
        
        oJson['$rRow']=oJson['$rBody'].find('tr:eq('+oJson['$lRow'].index()+')');
		_this.value = Globalize.format(tv, oJson['point']);
		
		if(oJson['type'] == 'part'){
			sumOfCheckAmount_Qty(oJson, function(){});
		}else{
			if( !oJson['$lRow'].hasClass('done') ){
				art.dialog({
			        title:' ', lock:true, dblclick_hide:false, esc:false, id: 'countsid',
			        content: 'Please load part data.',
			        button : [ {value: 'Ok', focus: true, callback: function(){  }} ]
			    });
			    _this.value = Globalize.format(0, 'n0');
				return;
			}
			
			sumOfCheckAmount_Qty(oJson, sumOfAllRow);
		}
        
    }
    
    ;function sumOfCheckAmount_Qty(oJson, callBack){
    	var findCls=(oJson['$lRow'].attr('data-v1')+'_cls.'+oJson['$lRow'].attr('data-v2')+'.'+oJson['$lRow'].attr('data-v3')+'_level3'),
    		$pclRow=oJson['$lRow'].parent().find('tr.rt3.'+findCls), $pcrRow=oJson['$rBody'].find('tr:eq('+$pclRow.index()+')'), 
    		pcPrice=numberOfZero($pclRow.find('input.pricecls').val()), partCellTotal={}, pcCellTotal={}, flg=false;

    	oJson['$lRow'].parent().find('tr.rt4.'+findCls).each(function(){
    		var price=numberOfZero($(this).find('input.pricecls').val());
    		oJson['$rBody'].find('tr:eq('+this.rowIndex+') td:gt('+oJson['crtCell']+')').each(function(){
				var qty=numberOfZero( $(this).find('input').val() );
				if(!partCellTotal.hasOwnProperty(this.cellIndex)){
	    			partCellTotal[this.cellIndex]={'amount': (price*qty), 'qty': qty};
				}else{
					partCellTotal[this.cellIndex]={'amount': (price*qty)+partCellTotal[this.cellIndex]['amount'], 'qty': qty+partCellTotal[this.cellIndex]['qty']};
				}
    		});
    	});
    	
    	$pcrRow.find('td:gt('+oJson['crtCell']+')').each(function(){
    		var qty=numberOfZero( $(this).find('input').val() );
    		pcCellTotal[this.cellIndex]={'amount': (pcPrice*qty), 'qty': qty};
    	});

    	for(var cell in partCellTotal){
    		var partTotal=partCellTotal[cell], pcTotal=pcCellTotal[cell];
    		if(partTotal['amount'] > pcTotal['amount']){
    			flg=true;
    			break;
    		}
    		if(partTotal['qty'] > pcTotal['qty']){
    			flg=true;
    			break;
    		}
    	}

    	tv = (flg ? ov : tv);
    	_this.value = Globalize.format(tv, oJson['point']);

    	oJson['$rRow'].find('td:gt('+oJson['crtCell']+')').each(function(){
    		var $this=$(this), qty=numberOfZero($this.find('input').val());
    		$this.attr({'data-amount': tv*qty});
    	});
    	
    	
		if(!flg){
			callBack(oJson);
		}else{
			alertRelayMessage('Please check the amount, quantity or price you just entered.');
		}
    }
    
    ;function sumOfAllRow(oJson){
    	
    	var findCls=(oJson['$lRow'].attr('data-v1')+'_cls.'+oJson['$lRow'].attr('data-v2')),
    		$lBody=oJson['$lRow'].parent(), $cbcLRow=$lBody.find('tr.rt2.'+findCls), $cbcRCells=oJson['$rBody'].find('tr:eq('+$cbcLRow.index()+') td'), 
    		$accLRow=$lBody.find('tr.rt1.'+oJson['$lRow'].attr('data-v1')+'_cls'), $accRCells=oJson['$rBody'].find('tr:eq('+$accLRow.index()+') td'), 
    		productTotal={}, cbcTotal={}, accTotal={};
    		
    	if($lBody.find('.trt_trt').hasClass('exp')){
    		$lBody.find('.trt_trt').addClass('col').removeClass('exp').find('span.fcell').html('+');
    		$lBody.find('.trt_0:not(.trt_trt)').addClass('dn');
    		oJson['$rBody'].find('.trt_0:not(.trt_trt)').addClass('dn');
    	}
    	
    	$lBody.find('tr.rt3.'+findCls).each(function(){	//ProductCode total
    		oJson['$rBody'].find('tr:eq('+this.rowIndex+') td:gt('+oJson['crtCell']+')').each(function(){
				productTotal[this.cellIndex]=(getZeroOfNumberRelay(productTotal[this.cellIndex])+getZeroOfNumberRelay($(this).attr('data-amount')));
    		});
    	});
    	for(var cell in productTotal){
    		$cbcRCells.eq(cell).html( Globalize.format(productTotal[cell], 'n') );
    	}
    	
    	
    	$lBody.find('tr.rt2.'+oJson['$lRow'].attr('data-v1')+'_cls').each(function(){ //CBC2 total
    		oJson['$rBody'].find('tr:eq('+this.rowIndex+') td:gt('+oJson['crtCell']+')').each(function(){
				cbcTotal[this.cellIndex]=(getZeroOfNumberRelay(cbcTotal[this.cellIndex])+numberOfZero($(this).html()));
    		});
    	});
    	for(var cell in cbcTotal){
    		$accRCells.eq(cell).html( Globalize.format(cbcTotal[cell], 'n') );
    	}
    	
    }
    
}

;function event_qtyInputRelay_change(e){
	var _this=this, $this=$(_this), ov='', validation_qty=/^([1-9]\d{0,16}|0)(\.\d+)?$/, 
        tv=Globalize.parseFloat($.trim(_this.value)); //focus Event
    
    ov = $this.inputFocusValueFormat(validation_qty, e);

    if(e.type == 'change'){
    	var oJson={'$lBody': $('#ltabid'), '$rCell': $this.parent().parent(), '$rRow': $this.parent().parent().parent(),
    		'type': $this.attr('data-type')
    	};
    	oJson['$lRow']=oJson['$lBody'].find('tr:eq('+oJson['$rRow'].index()+')');
    	oJson['iCell']=oJson['$rCell'][0].cellIndex;
    	oJson['iCellPrice']=numberOfZero(oJson['$lRow'].find('input.pricecls').val());
    	oJson['oldAmount']=getZeroOfNumberRelay(oJson['$rCell'].attr('data-amount'));
    	
		if(oJson['type'] == 'part'){
			sumOfPart(oJson);
		}else{
			if( !oJson['$lRow'].hasClass('done') ){
				art.dialog({
			        title:' ', lock:true, dblclick_hide:false, esc:false, id: 'countsid',
			        content: 'Please load part data.',
			        button : [ {value: 'Ok', focus: true, callback: function(){  }} ]
			    });
			    _this.value = Globalize.format(0, 'n0');
				return;
			}
			sumOfProductCode(oJson);
		}
    }
    
    ;function sumOfPart(oJson){
		_this.value = Globalize.format(tv, 'n0');
		oJson['$rCell'].attr({'data-amount': tv*oJson['iCellPrice']});
    	checkQty(oJson, function(oJson){});
    }
    
    ;function sumOfProductCode(oJson){
    	if(oJson['$lBody'].find('.trt_trt').hasClass('exp')){
    		oJson['$lBody'].find('.trt_trt').addClass('col').removeClass('exp').find('span.fcell').html('+');
    		oJson['$lBody'].find('.trt_0:not(.trt_trt)').addClass('dn');
            oJson['$rRow'].parent().find('.trt_0:not(.trt_trt)').addClass('dn');
    		oJson['$rRow'].parent().find('.trt_0:not(.trt_trt)').addClass('dn');
    	}
    	_this.value = Globalize.format(tv, 'n0');
		oJson['$rCell'].attr({'data-amount': tv*oJson['iCellPrice']});

    	checkQty(oJson, sumOfAccountTotal);
    	
    }
    
    ;function sumOfAccountTotal(oJson){
		var findCls=(oJson['$lRow'].attr('data-v1')+'_cls.'+oJson['$lRow'].attr('data-v2')), $rBody=oJson['$rRow'].parent(),
			$lCbcRow=oJson['$lBody'].find('tr.rt2.'+findCls), 
			$lARow=oJson['$lBody'].find('tr.rt1.'+oJson['$lRow'].attr('data-v1')+'_cls'), 
			product_amount=0;
			
		
		oJson['$lBody'].find( ('tr.rt3.'+findCls) ).each(function(){
    		var $cell=$rBody.find('tr:eq('+this.rowIndex+') td:eq('+oJson['iCell']+')');
    		product_amount += getZeroOfNumberRelay($cell.attr('data-amount'));
    	});

    	$rBody.find('tr:eq('+$lCbcRow.index()+') td:eq('+oJson['iCell']+')').html( Globalize.format(product_amount, 'n') );
		
    	product_amount=0;
    	oJson['$lBody'].find('tr.rt2.'+oJson['$lRow'].attr('data-v1')+'_cls').each(function(){
    		var $cell=$rBody.find('tr:eq('+this.rowIndex+') td:eq('+oJson['iCell']+')');
    		product_amount += numberOfZero($.trim($cell.html()));
    	});
		$rBody.find('tr:eq('+$lARow.index()+') td:eq('+oJson['iCell']+')').html( Globalize.format(product_amount, 'n') );
    }
    
    ;function checkQty(oJson, callBack){
    	var findCls=(oJson['$lRow'].attr('data-v1')+'_cls.'+oJson['$lRow'].attr('data-v2')+'.'+oJson['$lRow'].attr('data-v3')+'_level3'),
    		$rBody=oJson['$rRow'].parent(), $pcLRow=oJson['$lBody'].find('tr.rt3.'+findCls), 
    		$pcRCell=$rBody.find('tr:eq('+$pcLRow.index()+') td:eq('+oJson['iCell']+')'), partCellVal={'amount': 0, 'qty': 0},
    		productCellVal={'amount': getZeroOfNumberRelay($pcRCell.attr('data-amount')), 'qty': Globalize.parseInt($pcRCell.find('input').val())};

    	oJson['$lBody'].find('tr.rt4.'+findCls).each(function(){
    		var $partCell=$rBody.find('tr:eq('+this.rowIndex+') td:eq('+oJson['iCell']+')');
    		partCellVal['amount'] += getZeroOfNumberRelay($partCell.attr('data-amount'));
    		partCellVal['qty'] += Globalize.parseInt($partCell.find('input').val());
    	});
    	
    	if(partCellVal['amount'] > productCellVal['amount']){
    		_this.value = Globalize.format(ov, 'n0');
    		oJson['$rCell'].attr({'data-amount': oJson['oldAmount']});
    		alertRelayMessage('Please check the amount, quantity or price you just entered.');
    		return;
    	}
    	if(productCellVal['amount'] > partCellVal['amount'] && partCellVal['qty'] > productCellVal['qty']){
    		_this.value = Globalize.format(ov, 'n0');
    		oJson['$rCell'].attr({'data-amount': oJson['oldAmount']});
    		alertRelayMessage('Please check the amount, quantity or price you just entered.');
    		ar
    		return;
    	}
    	callBack(oJson);
    }
    
}

;function event_qtyInputRelay_keyup(e){
	var $this=$(this), $td=$this.parent().parent(), $tr=$td.parent(), $tbody=$tr.parent(),
        _cellIndex=$td[0].cellIndex, _rowIndex=$tr[0].rowIndex;

    if(e.shiftKey && e.keyCode == 13){  //find prve cell input
    	$td.prev().find('input[type="text"]').focus().select();
    }else if(e.keyCode == 13){  //find next cell input  	
    	$td.next().find('input[type="text"]').focus().select();
    }
}

;function setTemplateElementRelay(data){
	
	var monthCell={}, cellMonth={}, $head=$('#tab_head_list td'), 
		list_hidden_td=$head.filter('.dn').toArray(), ftCell=$head.filter('.crtQtotal')[0].cellIndex-1;
	
	$head.each(function(){
		cellMonth[this.cellIndex] = this.getAttribute('data-date');
		monthCell[this.getAttribute('data-date')] = this.cellIndex;
	});
	data['cellMonth'] = cellMonth;
	data['monthCell'] = monthCell;
	data['ftCell']=ftCell;

	switch(data['data-level']){
		case 'root1' : 
			data['$left'] = data['$row'].next().next().next().next().next().next().next();
			data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');
			data['$left_template'] = $('#gpltmplete tbody tr').clone();
			data['$right_template'] = $('#gpltmplete tfoot tr').clone();
			break;
		case 'root2' : 
			data['$left'] = data['$row'].next().next().next().next().next();
			data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');
			data['$left_template'] = $('#productcode tbody tr').clone();
			data['$right_template'] = $('#productcode tfoot tr').clone();
			data['$left_template'].eq(0).find('input[type="button"].delpartbtn').off('click').on('click', event_deleteProductCode_click);
			break;
		case 'root3' :
			data['$left'] = data['$row'].next().next().next().next().next();
			data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');
			data['$left_template'] = $('#parttab tbody tr').clone();
			data['$right_template'] = $('#parttab tfoot tr').clone();
			data['$left_template'].eq(0).find('input[type="button"].delpartbtn').off('click').on('click', event_deletePart_click);
			break;
		case 'root4' : break;
	}

	data['$right_template'].each(function(){
		var $tds = $(this).find('td');
		for(var i=0, el; el=list_hidden_td[i]; i++){
			$tds.eq(el.cellIndex).addClass('dn');
		}
	});
	data['$left_template'].on('mouseenter mouseleave', overTableRelay_eve).filter('.cp')
						  .on('click', clickLeftTableRelay_eve)
						  .find('span.pin').on('click', clickLeftRelayPin_eve);
	data['$right_template'].on('mouseenter mouseleave', overTableRelay_eve)
							.eq(0).find('input').on('focus change', event_qtyInputRelay_change).on('keyup', event_qtyInputRelay_keyup);
	scroll_eventRelay();
}

;function appendElementRelay_Level2(data, callBack, callBackEnd){

	asyncEachSeries_Original(data['list_result'], function(item, call){

		var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true);
		$lClone.addClass( (item['id']+' '+data['data-v1']+'_cls') ).eq(0)
				.attr({'data-cbc-num': item['id'], 'data-isocode': data['data-isocode'], 'title': item['name'],
						'data-cbc-code': item['accnumber'], 'data-v2': item['id'], 'data-v1': data['data-v1']})
				.find('span.cbc_cell').html( item['name'] );

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

;function appendElementRelay_Level3(data, callBack, callBackEnd){
	
	var point='n'+$('#hidd_price').val();

	data['$left_template'].eq(0).find('td:last').on('mouseenter mouseleave', overPriceTab_relay_eve)
		  .append('<input type="text" data-type="productcode" value="" class="zidxInput pricecls" style="margin-left: -20px;"/>')
		  .find('input').on('focus change', event_priceRelay_change);

	data['$left_template'].eq(0).find('span.mark_img').addClass('mark_new').removeClass('p');

	asyncEachSeries_Original(data['list_result'], function(item, call){

		var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true);
		$lClone.addClass( (item['id']+'_level3 '+data['data-v2']+' '+data['data-v1']+'_cls') ).eq(0)
				.attr({'title': ('[ '+item['accnumber']+' ] '+item['name']), 'data-number': item['accnumber'], 'data-isocode': data['data-isocode'], 'data-v3': item['id'], 
						'data-name': item['name'], 'data-cbc-code': data['data-cbc-code'], 'data-v2': data['data-v2'], 'data-v1': data['data-v1']})
				.find('span.scell').html( '[ '+item['accnumber']+' ] '+item['name']);
		
		$lClone.eq(0).find('td:last input').val( Globalize.format(item['price'], point) );
		
		setFieldValue($rClone.eq(0).find('td:gt('+(data['ftCell'])+')'), data, item['map_type_FC']['quantity'], item['price']);
		setFieldValue1($rClone.eq(1).find('td:gt('+(data['ftCell'])+')'), data, item['map_type_FC']['pmFC']);	
		setFieldValue1($rClone.eq(2).find('td:gt('+(data['ftCell'])+')'), data, item['map_type_FC']['rsmFC']);	
		if(item['isHighLighted']){
			$lClone.eq(0).find('td:first div:first').before('<div class="highLighted"></div>');
		}
		data['$left'].after($lClone);
		data['$right'].after($rClone);
		
	}, function(err){
		callBackEnd(callBack, data);
	}, 150);
	
	;function setFieldValue($rCell, data, fc, price){
		$rCell.each(function(){
			var attr = { 'data-old': 0 , 'data-amount': 0};
			if(fc && fc.hasOwnProperty( data['cellMonth'][this.cellIndex] )){
				attr['data-old'] = (fc[data['cellMonth'][this.cellIndex]]);	
			}
			attr['data-amount'] = price*attr['data-old'];
			$(this).attr(attr).find('input').val( Globalize.format(attr['data-old'], 'n0') );
		});
	}
	;function setFieldValue1($rCell, data, fc){
		$rCell.each(function(){
			var attr = { 'data-old': 0 };
			if(fc && fc.hasOwnProperty( data['cellMonth'][this.cellIndex] )){
				attr['data-old'] = (fc[data['cellMonth'][this.cellIndex]]);	
			}
			$(this).attr(attr).html( Globalize.format(attr['data-old'], 'n') );
		});
	}
	
}

;function appendElementRelay_Level4(data, callBack, callBackEnd){

	var point='n'+$('#hidd_price').val();
		
    data['$left_template'].eq(0).off('click').find('td:last').on('mouseenter mouseleave', overPriceTab_relay_eve)
		  .append('<input type="text" value="" data-type="part" class="zidxInput pricecls" style="margin-left: -20px;"/>')
		  .find('input').on('focus change', event_priceRelay_change);
    data['$left_template'].eq(0).find('span.cellbox.fcell').on('click', clickLeftRelayPin_eve);
    
	asyncEachSeries_Original(data['list_result'], function(item, call){

		var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true);
		$lClone.addClass( (item['id']+'_level4 '+data['data-v3']+'_level3 '+data['data-v2']+' '+data['data-v1']+'_cls') ).eq(0)
				.attr({'data-number': item['accnumber'], 'data-isocode': data['data-isocode'], 'data-v3': data['data-v3'], 'data-v4': item['id'],
						'title': item['name'], 'data-cbc-code': data['data-cbc-code'], 'data-v2': data['data-v2'], 'data-v1': data['data-v1']})
				.find('span.scell').html( item['snumber'] );
		
		$lClone.eq(0).find('td:last input').attr({'price': item['price']}).val( Globalize.format(item['price'], point) );
		
		setFieldValue($rClone.eq(0).find('td:gt('+(data['ftCell'])+')'), data, item['map_type_FC']['quantity']);
		setFieldValue1($rClone.eq(1).find('td:gt('+(data['ftCell'])+')'), data, item['map_type_FC']['pmFC']);	
		setFieldValue1($rClone.eq(2).find('td:gt('+(data['ftCell'])+')'), data, item['map_type_FC']['rsmFC']);	
		
		
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
			$(this).attr(attr).find('input').val( Globalize.format(attr['data-old'], 'n0') );
		});
	}
	;function setFieldValue1($rCell, data, fc){
		$rCell.each(function(){
			var attr = { 'data-old': 0 };
			if(fc && fc.hasOwnProperty( data['cellMonth'][this.cellIndex] )){
				attr['data-old'] = (fc[data['cellMonth'][this.cellIndex]]);	
			}
			$(this).attr(attr).html( Globalize.format(attr['data-old'], 'n') );
		});
	}
	
}

;function complete_getRelayRefData(result, event, data){

	_queueTask.push({name: data['level'], run: function(cb){
		
		var $status_cell=data['$billing'].find('td:first b.ref_box[data-months="'+data['smonths']+'"]').eq(0);
		if(event.status){
			result = $.parseJSON(result);
		//	data['$billing'].find('td:eq(1)').css({'position': 'relative'}).append('<span class="topcls">Quantity</span><span class="btmcls">Amount</span>');
		//	data['$booking'].find('td:eq(1)').css({'position': 'relative'}).append('<span class="topcls">Quantity</span><span class="btmcls">Amount</span>');
			
			var $billing=data['$rbody'].find('tr:eq('+data['$billing'].index()+')'), 
				$booking=data['$rbody'].find('tr:eq('+data['$booking'].index()+')'), 
				billing=result['map_billingrefdata'], booking=result['map_bookingrefdata'];

			matchRefData(billing, result['map_billingrefdataQty'], data, $billing.find('td'));
			matchRefData(booking, result['map_bookingrefdataQty'], data, $booking.find('td'));
			
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
    ;function matchRefData(refData, refQty, data, $cell){
    	var monthCell = data['monthCell'];
    	for(var r in refData){
    		if(monthCell.hasOwnProperty(r)){
    			$cell.eq(monthCell[r]).attr({'data-old': refData[r], 'data-qty': refQty[r]}).html( 
    				'<div>'+Globalize.format(refQty[r], 'n0')+'</div><div style="background-color: rgb(179, 225, 254);">'+Globalize.format(refData[r], 'n')+'</div>'
    			//Globalize.format(refData[r], 'n') 
    			);
    		}
    	}
    	var cellIdx=data['$historicalCells'].filter('[data-months="'+data['smonths']+'"]')[0].cellIndex,
    		$qCell=$cell.eq(cellIdx), $q3=$qCell.prev(), $q2=$q3.prev(), $q1=$q2.prev(),
    		q1=getZeroOfNumber($q1.attr('data-old')), q2=getZeroOfNumber($q2.attr('data-old')), q3=getZeroOfNumber($q3.attr('data-old')),
    		qty1=getZeroOfNumber($q1.attr('data-qty')), qty2=getZeroOfNumber($q2.attr('data-qty')), qty3=getZeroOfNumber($q3.attr('data-qty'));
    	
    	$qCell.html( 
    		'<div>'+Globalize.format((qty1+qty2+qty3), 'n0')+'</div><div style="background-color: rgb(179, 225, 254);">'+Globalize.format((q1+q2+q3), 'n')+'</div>'
    	//Globalize.format((q1+q2+q3), 'n') 
    	);

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

;function complete_getRelayBacklogRefData(result, event, data){
	
	_queueTask.push({name: data['level'], run: function(cb){
		var $status_cell=data['$backlog'].find('td:first b.ref_box[data-months="'+data['smonths']+'"]').eq(0);
		if(event.status){
			result = $.parseJSON(result);
		//	data['$backlog'].find('td:eq(1)').css({'position': 'relative'}).append('<span class="topcls">Quantity</span><span class="btmcls">Amount</span>');
			
			var $backlog=data['$rbody'].find('tr:eq('+data['$backlog'].index()+')'), backlog=result['map_backlogrefdata'];
			$status_cell.attr('data-status', 'true').animate({backgroundColor: '#51C957'}, 130, function(){
				$status_cell.remove();
				if(data['$backlog'].find('b.ref_box').length == 0){
					data['$backlog'].find('span.reloadRef').remove();
				}
			});
			matchRefData(backlog, result['map_backlogrefdataQty'], data, $backlog.find('td'));
	    }else{
			reLoadRefData($status_cell, data);
	    }
		cb(null);
    }}, function(err){ });
	
    
    /*HELP methods*/
    ;function matchRefData(refData, refQty, data, $cell){
		
    	var total=0, qtyTotal=0, cellIdx=data['$futureCells'].filter('[data-months="'+data['smonths']+'"]')[0].cellIndex;
    	if(cellIdx < data['crtCell'] || cellIdx == data['crtCell']){
    		var monthCell = data['monthCell'];
	    	for(var r in refData){
	    		if(monthCell.hasOwnProperty(r)){
	    			$cell.eq(monthCell[r]).attr({'data-old': refData[r], 'data-qty': refQty[r]}).html( 
	    				'<div>'+Globalize.format(refQty[r], 'n0')+'</div><div style="background-color: rgb(179, 225, 254);">'+Globalize.format(refData[r], 'n')+'</div>'
	    			);
	    		}
	    	}
	    	var cIdx=data['$historicalCells'].filter('[data-months="'+data['smonths']+'"]')[0].cellIndex,
	    		$qCell=$cell.eq(cIdx), $q3=$qCell.prev(), $q2=$q3.prev(), $q1=$q2.prev(),
	    		q1=getZeroOfNumber($q1.attr('data-old')), q2=getZeroOfNumber($q2.attr('data-old')), q3=getZeroOfNumber($q3.attr('data-old')),
	    		qty1=getZeroOfNumber($q1.attr('data-qty')), qty2=getZeroOfNumber($q2.attr('data-qty')), qty3=getZeroOfNumber($q3.attr('data-qty'));
	    	$qCell.html( 
	    		'<div>'+Globalize.format((qty1+qty2+qty3), 'n0')+'</div><div style="background-color: rgb(179, 225, 254);">'+Globalize.format((q1+q2+q3), 'n')+'</div>'
	    	);
    	}else{
	    	for(var r in refData){ 
	    		qtyTotal += refQty[r];
	    		total += refData[r]; 
    		}
	    	$cell.eq(cellIdx).html( 
	    		'<div>'+Globalize.format(qtyTotal, 'n0')+'</div><div style="background-color: rgb(179, 225, 254);">'+Globalize.format(total, 'n')+'</div>'
	    	);
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

;function complete_delRelayProductCode(result, event, data){
	_queueTask.push({name: data['$row'].index(), run: function(cb){
		if(event.status){ }
	    else{ }
	    
	    var cell_total={}, $rBody=$('#rtabid'), $lBody=data['$row'].parent(),
	    	findCls=(data['data-v1']+'_cls.'+data['data-v2']+'.'+data['data-v3']+'_level3'),
	    	$cbcLRow=$lBody.find('tr.rt2.'+data['data-v1']+'_cls.'+data['data-v2']), $cbcRCell=$rBody.find('tr:eq('+$cbcLRow.index()+') td'),
	    	$accLRow=$lBody.find('tr.rt1.'+data['data-v1']+'_cls'), $accRCell=$rBody.find('tr:eq('+$accLRow.index()+') td');
	    
	    $rBody.find('tr:eq('+data['$row'].index()+') td:gt('+($('#tab_head_list td.crtQtotal')[0].cellIndex-1)+')').each(function(){
	    	cell_total[this.cellIndex]=getZeroOfNumberRelay($(this).attr('data-amount'));
	    });

	    for(cell in cell_total){
	    	var $ccell=$cbcRCell.eq(cell), $acell=$accRCell.eq(cell), 
	    		c=numberOfZero( $.trim($ccell.html()) ), a=numberOfZero( $.trim($acell.html()) );
	    	$ccell.html( Globalize.format(c-cell_total[cell], 'n') );
	    	$acell.html( Globalize.format(a-cell_total[cell], 'n') );
	    }
	    
		$lBody.find('tr.level4.'+findCls+', tr.level3.'+findCls).each(function(){
			$rBody.find('tr:eq('+this.rowIndex+')').remove();
			$(this).remove();
		});
    	cb(null);
	}}, function(err){ });
}

;function complete_deletePartRelay(result, event, data){
    _queueTask.push({name: data['rowIndex'], run: function(cb){
	    if(event.status){
			
		    var $rBody=$('#rtabid'), findCls=(data['data-v1']+'_cls.'+data['data-v2']+'.'+data['data-v3']+'_level3.'+data['data-v4']+'_level4');
			data['$row'].parent().find('tr.level4.'+findCls).each(function(){
				$rBody.find('tr:eq('+this.rowIndex+')').remove();
				$(this).remove();
			});
	    }else{
	        var $errdiv=data['$row'].find('td:first input[type="button"].delpartbtn').removeClass('disabled_btn').val(CUSTOM_LABEL['delpart']).parent();
	        $errdiv.find('b').remove();
	        $errdiv.append('<b class="borders">'+event['message']+'</b>');
	    }
	    cb(null);
    }}, function(err){ });

}

;function complete_searchProductCodeObject(result, event, data){

	var $multiselect=$('#multiselect_simple');
    if(event.status){
		$multiselect.find('option').remove();
    	matchSearchResult($.parseJSON(result), data, $multiselect);
    }else{
        $('#popup_loading').html(event['message']);
    }
    $('#popupbox input[type="button"]').removeAttr("disabled");
    
    
    ;function matchSearchResult(list_result, data, $multiselect){
    	var t = '';//, o_part={}, $left_trs=$('#ltabid tr'), o_json=$.parseJSON(data['json']);
    	while(list_result.length > 0){
	        var s=list_result.shift();//, hasPart = (o_part.hasOwnProperty(s['partId']) ? 'disabled="disabled"' : '');
	        t += ('<option value="'+s['id']+'" data-json=\''+JSON.stringify(s)+'\'>[ '+s['accnumber']+' ] - '+s['name']+'</option>');
	    }
	    $multiselect.append(t).multiselect('refresh');
	    $('#popup_loading').hide();
    }
    
}

;function complete_remoteResultCheck(result, data, queueComplete, appendCallBack, appendCallBackEND){

	data['list_result'] = $.parseJSON(result);
	
	if(data['data-level'] != 'root1'){
		var el_search='<span class="gplsearch" ><div style="display:none;" class="errordiv">' +
					'<input class="btn addpartbtn" type="button" value="'+data['data-label']+'"/></div></span>';
		
		data['$row'].find('td:first div.fdclsmark').before(el_search).parent().parent().find('span.gplsearch').on('mouseenter mouseleave', addGPLOver_relay_eve)
	    			.find('input[type="button"].addpartbtn').on('click', data['event-search']);
		
	}

    if(data['list_result'].length == 0){ 
        rowUnLockRelay(data['rowIndex']);//rowIndex
        data['$row'].removeClass('ready').addClass('done').find('td:first span.fcell').html('-').removeClass('waiting');
        queueComplete(null);
        return;
    }
    setTemplateElementRelay(data);
    appendCallBack(data, queueComplete, appendCallBackEND);
}

;function complete_appendElementEND(queueComplete, _data){
	rowUnLockRelay(_data['rowIndex']);
	_data['$row'].removeClass('ready').addClass('done').find('td:first span.fcell').html('-').removeClass('waiting');
	queueComplete(null); 
}

;function complete_errorReload(data, event, callBack){

	var el_reload = '<span class="reload_span reload_spanfix"><span class="reload_img fixreload"></span><b class="reload_msg" >'+event['message']+'</b></span>';
    data['$row'].removeClass('ready done').find('td:first span.waiting.fcell').before(el_reload)
            .parent().find('span.reload_span').off('click').on('click', {$data: data}, function(e){
            	e.stopPropagation();
            	callBack(e, $(this));
            });
    rowUnLockRelay(data['rowIndex']);
}

;function complete_existObject(result, event, data){	//complete remoteaction result
	
	_queueTask.push({name: data['rowIndex'], run: function(cb){
		if(event.status){
			complete_remoteResultCheck(result, data, cb, data['append'], complete_appendElementEND);
	    }else{ 
			complete_errorReload(data, event, event_reloadExistData_click);
	    	cb(null);
	    }
	    data['$row'].find('span.delprduct').removeAttr('style');
		//$this.find('span.delprduct').css({'visibility': 'hidden'});
	}}, function(err){ });
	
}

;function complete_searchCBC2Relay(result, event, data){       //search cbc2 forecast remote event
	scroll_eventRelay();
    if(event.status){ matchCBC2Result(); }
    else{ addReloadButtonRelay(data, event, reCBC2FC_relay_eve); }
    
    ;function matchCBC2Result(){
        result = $.parseJSON(result);

        if($.isEmptyObject(result)){ 
        	rowUnLockRelay(data['rowIndex']);
        	data.$row.removeClass('ready').addClass('done').find('td:first span.fcell').html('-').removeClass('waiting');
        	return; 
    	}
		
        var $right_tr=$('#rtabid tr'), $left_trs=$('#ltabid tr'), list_fc=[], quarter_month={'month_cell': {}, 'quarter_cell': {}},
        	total_row={'totalBilling': {}, 'totalBooking': {}, 'totalBacklog': {}};
        	
        
    	setMatchCellRelay(quarter_month);
        setMatchForecast(result, $right_tr, $left_trs, data, list_fc);

        asyncEachSeries_Original(list_fc, function(item, callback){
    		var cls=('tr:not(.previousFC).cbcsub.'+item['$leftRow'].attr('data-aidcls')+'.'+item['$leftRow'].attr('data-cbc-num')),
    			$l_fields=item['$leftRow'].parent().find(cls), $cells=null, celltype='';

        	switch(item['type']){//billing   booking   backlog   
        		case 'booking' : $cells=$right_tr.eq($l_fields.filter('.booking').index()).find('td'); celltype='totalBooking'; break;
        		case 'billing' : $cells=$right_tr.eq($l_fields.filter('.billing').index()).find('td'); celltype='totalBilling'; break;
        		case 'backlog' : $cells=$right_tr.eq($l_fields.filter('.backlog').index()).find('td'); celltype='totalBacklog'; break;
        	}

        	if($cells != null){
				for(var fcMonth in item['fc']){
					var q_cell=quarter_month['month_cell'][fcMonth], o_month=quarter_month['quarter_cell'][q_cell], 
						o_month_cell=o_month[fcMonth], isFuture=(o_month_cell['isQcell'] && !o_month_cell['isCurrent']),
						$cell=$cells.eq( (isFuture ? q_cell : o_month_cell['cell']) ), old=$cell.attr('data-old'),
						total_old=total_row[celltype][$cell[0].cellIndex];
						
					old=($.isNumeric(old) ? parseFloat(old) : 0);
					old+=item['fc'][fcMonth];
					$cell.attr('data-old', old);

					total_old=($.isNumeric(total_old) ? parseFloat(total_old) : 0);
					total_old+=item['fc'][fcMonth];
					total_row[celltype][$cell[0].cellIndex]=total_old;
				}
				$cells.parent().find('td').each(function(){
					var $this=$(this)
					if(!$this.hasClass('futurec1') && $this.hasClass('qtotalCls')){
						var v1=parseFloat($this.prev().attr('data-old')), v2=parseFloat($this.prev().prev().attr('data-old')),
							v3=parseFloat($this.prev().prev().prev().attr('data-old'));
						v1=(($.isNumeric(v1) ? v1 : 0)+($.isNumeric(v2) ? v2 : 0)+($.isNumeric(v3) ? v3 : 0));
						$this.attr('data-old', v1).html(Globalize.format(v1, 'n'));
					}else{
						var val=parseFloat($this.attr('data-old'));
						$this.html(Globalize.format(($.isNumeric(val) ? val : 0), 'n'));
					}
				});
        	}
        }, function(err){ // finally total account total
        	list_fc=quarter_month=[];		//clear forecast 		

        //	var $left_rows=$left_trs.filter( ('.actsub.'+data.$row.attr('data-aidcls')) );
        //	matchTotal_Billing_Backlog_Booking_Relay(total_row, data, '.totalBilling, .totalBooking, .totalBacklog', $left_rows, $right_tr);
        }, 120);
        
        rowUnLockRelay(data['rowIndex']);
        data.$row.removeClass('ready').addClass('done').find('td:first span.fcell').html('-').removeClass('waiting');
    }
    
    ;function setMatchForecast(result, $right_tr, $left_trs, data, list_fc){

    	for(var o in result){
        	var $current_fc = $right_tr.eq(o), $previou_fc = $current_fc.next(), _json=$.parseJSON(result[o]);
		    matchRightCBCForecast(_json['currentFC'], _json['previousFC'], data['o_cell'], $current_fc, $previou_fc);

        //	list_fc.push({'type': 'booking', '$leftRow': $left_trs.eq(o), 'fc': _json['booking']});
        //	list_fc.push({'type': 'billing', '$leftRow': $left_trs.eq(o), 'fc': _json['billing']});
        //	list_fc.push({'type': 'backlog', '$leftRow': $left_trs.eq(o), 'fc': _json['backlog']});
        }
        result={};
    }
}

;function complete_searchPartFCRelay(result, event, data){       //search part remote event
	if(event.status){
        _queueTask.push({name: data['rowIndex'], run: function(cb){
        	createPartElementRelay(result, data, cb);
        }}, function(err){ });
    }else{ addReloadButtonRelay(data, event, rePartFC_relay_eve); }
    
    ;function createPartElementRelay(result, data, queueTaskCallBack){
		var $part_tab=$('#parttab'), $left_tr=$part_tab.find('tbody tr').clone(), $right_tr=$part_tab.find('tfoot tr').clone(),
			el_search='<span class="gplsearch" ><div style="display:none;" class="errordiv"><input class="btn addpartbtn" type="button" value="'+CUSTOM_LABEL['searchpart']+'"/></div></span>',
			partCls=(data['aid']+'_cls '+data['cbcNum']+' ');
	    
	    result = completeResultRelayCheck(result, data, $right_tr);

	    data.$row.find('td:first').prepend(el_search).find('span.gplsearch')
    			.on('mouseenter mouseleave', addGPLOver_relay_eve)
	            .find('input[type="button"].addpartbtn').on('click', addGPLBtn_relay_eve);
	    
	    if(result.length == 0){  queueTaskCallBack(null); return; }
	    
	    var quarter_month={'month_cell': {}, 'quarter_cell': {}}, point='n'+$('#hidd_price').val(), 
	    	total_row={'billing': {}, 'booking': {}, 'backlog': {}}, isFrezen=$('[id*=hidd_frezz]').val();

		setMatchCellRelay(quarter_month);
	    
	    data['$right_backlog']=$('#rtabid tr').eq(data['$backlog'].index());
	    
	    $right_tr.on('mouseenter mouseleave', overTableRelay_eve);
	    $left_tr.on('mouseenter mouseleave', overTableRelay_eve).eq(0).attr({
	    	'data-aid': data['aid'], 'data-aidcls': (data['aid']+'_cls'), 'data-cbc-code': data['cbcCode'], 
	    	'data-cbc-num': data['cbcNum'], 'data-hierarchy': 'root3'
	    }).find('td:last').on('mouseenter mouseleave', overPriceTab_relay_eve)
		  .append('<input type="text" value="" class="zidxInput pricecls" style="margin-left: -20px;"/>')
		  .find('input').on('focus change', input_price_eve);

	    asyncEachSeries_Original(result, function(item, callback){

	        var $l_clone = $left_tr.clone(true), $r_clone = $right_tr.clone(true),
	            current_fc = item['currentFC'], previou_fc = item['previousFC'];
	        
	        matchHistoryDataRelay( item['backlog'], total_row['backlog'], quarter_month, $r_clone.filter('.backlog').find('td') );
			matchHistoryDataRelay( item['billing'], total_row['billing'], quarter_month, $r_clone.filter('.billing').find('td') );
			matchHistoryDataRelay( item['booking'], total_row['booking'], quarter_month, $r_clone.filter('.booking').find('td') );

	        $l_clone.eq(0).find('span.scell').text(item['fieldName']);
	        $l_clone.addClass( (partCls+' '+item['partId']+'_part') ).eq(0)
        			.attr({'data-gid': item['gplId'], 'data-pid': item['partId'], 'title': item['partDesc']});
			
	        if(isFrezen == 'true'){
	        	$l_clone.eq(0).find('span.part_d').remove();
	        }
	        
	        $l_clone.eq(0).on('click', {$divbody: $('#div_body')}, clickLeftTableRelay_eve)
        			.find('span.part_d').on('mouseenter mouseleave', delPartOverRelay_eve)
                    .find('input[type="button"].delpartbtn').on('click', delPartBtnRelay_eve);

	        matchForecast(current_fc, previou_fc, data['o_cell'], $r_clone.eq(0), $r_clone.eq(1), $l_clone.eq(0).find('input[type="text"].pricecls'), point);
	        
	        $r_clone.eq(0).addClass('part').attr('data-row-name', 'part');
	        $r_clone.find('input').on('focus change', input_fc_relay_eve).on('keyup', input_keyup_relay_eve);
	        
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
	        
	        
	        data['$backlog'].after($l_clone);
	        data['$right_backlog'].after($r_clone);
	        
	    }, function(err){

			rowUnLockRelay(data['rowIndex']);
			data.$row.removeClass('ready').addClass('done').find('td:first span.fcell').html('-').removeClass('waiting');
	        setTimeout(function(){ queueTaskCallBack(null); }, 120);

	    //   var $left_rows=$('#ltabid tr.cbcsub.'+data.$row.attr('data-aidcls')+'.'+data.$row.attr('data-cbc-num'));
		//	matchTotal_Billing_Backlog_Booking_Relay(total_row, data, '.backlog, .billing, .booking', $left_rows, $('#rtabid tr'));
	        
	    }, 120);
	}
	
	;function matchForecast(current_fc, previou_fc, o_cell, $current_fc, $previou_fc, $input_price, point){
		for(var fc in current_fc){	//quantity
			var cFc=$.parseJSON(current_fc[fc]);
			if(cFc['price'] != 0){ $input_price.val(Globalize.format(cFc['price'], point)); }
			$current_fc.find('td:eq('+o_cell[fc]+') input').val(Globalize.format(cFc['quantity'], 'n0'));
	    }
	    for(var fc in previou_fc){
	    	var pFc=$.parseJSON(previou_fc[fc]);
			$previou_fc.find('td:eq('+o_cell[fc]+')').html(Globalize.format(pFc['quantity'], 'n0'));
	    }
	}
}

;function complete_searchRelayPart(result, event, data){       //added part event

    if(event.status){
    	var $multiselect=$('#multiselect_simple');
		$multiselect.find('option').remove();
    	matchSearchPartResultRelay($.parseJSON(result), data)
    }else{
        $('#popup_loading').html(event['message']);
    }
    $('#popupbox input[type="button"]').removeAttr("disabled");

}
;function complete_searchTopPartRelay(result, event, data){
	if(event.status){
    	matchSearchPartResultRelay($.parseJSON(result), data)
    }else{
    	$('#popup_loading').html(event['message']);
    }
	$('#popupbox input[type="button"]').removeAttr('disabled');
}

;function complete_saveForecastRelay(result, event, data){
    _queueTask.push({name: (data['data']['$bar'].progressbar("value") || 0), run: function(cb){
		var isError = false;
		if(event.status){
			isError=false;
	    }else{
	    	isError=true;
	    	data['msg'] = event;
	    	SAVE_ERRORS.push(data);
	    }
    
	    var percent=parseFloat(data['data']['$bar'].attr('data-value')), max=data['data']['max'];
	    
	    percent = ($.isNumeric(percent) ? percent : 0), 
	    percent = (data['data']['percent']+percent);

	    max = (Math.round(percent) >= data['data']['max'] ? 100 : percent);
		data['data']['$bar'].attr('data-value', percent).progressbar("value", max).find('div.progress-label').html(max.toFixed(2)+'%');
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

;function complete_addPartRefDataRelay(result, event, data){
	if(event.status){

		result=$.parseJSON(result);
		$.map(result, function(values, key){
			matchRefPartData(values['backlog'], data, '.backlog');
			matchRefPartData(values['billing'], data, '.billing');
			matchRefPartData(values['booking'], data, '.booking');
		});
		
		data['$rcell'].filter('.backlog, .billing, .booking').each(function(){
			$(this).find('td').each(function(idx){
				var $cell=$(this), isQcell=$cell.hasClass('qtotalCls'), old=getZeroOfNumberRelay( $cell.attr('data-old') );

				if(isQcell && (idx<data['currentCell'])){
					var v1=getZeroOfNumberRelay( $cell.prev().attr('data-old') ), 
						v2=getZeroOfNumberRelay( $cell.prev().prev().attr('data-old') ), 
						v3=getZeroOfNumberRelay( $cell.prev().prev().prev().attr('data-old') );
					old=(v1+v2+v3);
				}
				$cell.html( Globalize.format(old, 'n') );
			});
		});
		
    }else{
		addReloadButton(data, event, reAddPart_eve);
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

;function completeResultRelayCheck(result, data, $right_tr){
    result = $.parseJSON(result);
    if(result.length == 0){ 
        rowUnLockRelay(data['rowIndex']);
        data.$row.removeClass('ready').addClass('done').find('td:first span.fcell').html('-').removeClass('waiting');
        return []; 
    }

    $('#tab_head_list td.dn').each(function(){
        $right_tr.find('td:eq('+this.cellIndex+')').addClass('dn');
    });
    return result;
}

;function setMatchCellRelay(quarter_month){
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

;function matchHistoryDataRelay(items, total_cells, quarter_month, $cells){
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

;function matchTotal_Billing_Backlog_Booking_Relay(total_row, data, filterCls, $left_rows, $right_tr){

	for(var row in total_row){
		var $td_cells=$right_tr.eq( $left_rows.filter(('.'+row)).index() ).find('td');
		for(var cell in total_row[row]){
			$td_cells.eq(cell).attr('data-old', total_row[row][cell]).html(Globalize.format(total_row[row][cell], 'n'));
		}
	}

	$left_rows.filter(filterCls).each(function(){
		$right_tr.eq(this.rowIndex).find('td:lt('+(data['currentCell']+1)+')').filter('.qtotalCls')
				 .each(function(){
					var $this=$(this), month_1=$this.prev().attr('data-old'),
						month_2=$this.prev().prev().attr('data-old'), month_3=$this.prev().prev().prev().attr('data-old');
					month_1=($.isNumeric(month_1) ? parseFloat(month_1) : 0);
					month_2=($.isNumeric(month_2) ? parseFloat(month_2) : 0);
					month_3=($.isNumeric(month_3) ? parseFloat(month_3) : 0);
					month_1=(month_1+month_2+month_3);
					$this.attr('data-old', month_1).html(Globalize.format(month_1, 'n'));
				 });
	});
}

;function addReloadButtonRelay(data, event, reloadButtonEventCallBack){

    var el_reload = '<span class="reload_span"><span class="reload_img"></span><b class="reload_msg" style="display:none;">'+event['message']+'</b></span>';
    data.$row.removeClass('ready done').find('td:first span.fcell').before(el_reload)
            .parent().find('span.reload_img').off('mouseenter mouseleave click')
            .on('mouseenter mouseleave click', {$data: data}, reloadButtonEventCallBack);
    rowUnLockRelay(data['rowIndex']);
}

;function matchRightCBCForecast(current_fc, previou_fc, o_cell, $current_fc, $previou_fc){
    for(var fc in current_fc){
        $current_fc.find('td:eq('+o_cell[fc]+')').html(Globalize.format(current_fc[fc], 'n'));
    }
    for(var fc in previou_fc){
		$previou_fc.find('td:eq('+o_cell[fc]+')').html(Globalize.format(previou_fc[fc], 'n'));
    }
}

;function matchSearchPartResultRelay(result, data){
	var o_part={}, t = '', $left_trs=$('#ltabid tr'), o_json=$.parseJSON(data['json']), $multiselect=$('#multiselect_simple'),
		list_part=$left_trs.filter('.'+(o_json['aId'] == OTHER_LABEL ? 'customother' : o_json['aId'])+'_cls.cp.partner').toArray();
/*
    while(list_part.length > 0){	//set loaded part
        var _part = list_part.shift(), part_id=_part.getAttribute('data-pid');
        o_part[part_id] = part_id;
    }
*/	
    //$multiselect.find('option').remove();
    while(result.length > 0){	//check part is added
        var s=result.shift(), hasPart=(o_part.hasOwnProperty(s['partId']) ? 'disabled="disabled"' : '');
    //    t += ('<option '+hasPart+' value="'+s['partId']+'" data-gid="'+s['gplId']+'" data-desc="'+s['Description']+'" data-name="'+s['partName']+'">['+s['partName']+'] - '+s['Description']+'</option>');
        t += ('<option value="'+s['id']+'" data-json=\''+JSON.stringify(s)+'\'>['+s['name']+'] - '+s['snumber']+'</option>');
    }

    $multiselect.append(t).multiselect('refresh');
    $('#popup_loading').hide();
}

;function delPartOverRelay_eve(e){
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

;function delPartBtnRelay_eve(e){
    e.stopPropagation();
    var $this=$(this);
    if($this.hasClass('disabled_btn')){ return false; }
    $this.val(' ').addClass('disabled_btn');
    
    var $part_tr = $this.parent().parent().parent().parent().parent(), aid=$part_tr.attr('data-aid'), 
        pid=$part_tr.attr('data-pid'), cbcName=( $part_tr.attr('data-cbc-code') ), cbcNum=$part_tr.attr('data-cbc-num'),
        $parts=$part_tr.parent().find('tr.'+aid+'_cls.'+cbcNum+'.'+pid+'_part');

    aid=(aid == 'customother' ? OTHER_LABEL : aid);

    var params = {'json': '{"map_year": '+$.trim($('[id*=hidd_yearfutureid]').val())+',"territoryCode": \"'+$.trim($('[id*=hidd_territorycodeid]').val())
    				+'\", "aId": \"'+aid+'\", "partId": \"'+pid +'\", "cbc2Name": \"'+cbcName+'\" }', 
				  'rowIndex': $part_tr.index(), '$part' : $part_tr, '$parts': $parts};

    customRemoteActionRelay(params, delRelayPart_js, complete_deletePartRelay); //delete part remote action
}

;function saveSearchPartRelay(target){
    if(SAVE_PART.length == 0){
        $('#searchpart_inputid').focus();
        return;
    }
    $('#popup_loading').html(CUSTOM_LABEL['savemsg']).show();

    var $this=$(target), o_json=$.parseJSON($this.attr('data-val')), $popbox=$('#popupbox');
    
    appendPart();
    
    
    ;function appendPart(){
		$popbox.find('input[type="button"]').attr('disabled', true);
		
		var $lRow=$('#ltabid tr.level3.backlog.'+o_json['data-v1']+'_cls.'+o_json['data-v2']+'.'+o_json['data-v3']+'_level3'), 
			$rRow=$('#rtabid tr:eq('+$lRow.index()+')'),
			$left_template=$('#parttab tbody tr').clone(), $right_template=$('#parttab tfoot tr').clone(), 
			point='n'+$('#hidd_price').val(), celIndex=$('#tab_head_list td.crtQtotal')[0].cellIndex-1;
	
		$('#tab_head_list td.dn').each(function(){
			$right_template.find('td:eq('+this.cellIndex+')').addClass('dn');
		});
		
		$left_template.on('mouseenter mouseleave', overTableRelay_eve).eq(0)
						  .find('span.spin').on('click', clickLeftRelayPin_eve);
		$left_template.eq(0).find('td:last').on('mouseenter mouseleave', overPriceTab_relay_eve)
						  .append('<input type="text" data-type="part" value="" class="zidxInput pricecls" style="margin-left: -20px;"/>')
						  .find('input').on('focus change', event_priceRelay_change);
		$left_template.eq(0).find('input[type="button"].delpartbtn').off('click').on('click', event_deletePart_click);

		$right_template.on('mouseenter mouseleave', overTableRelay_eve).find('input')
					.on('focus change', event_qtyInputRelay_change).on('keyup', event_qtyInputRelay_keyup);
		
		asyncEachSeries_Original(SAVE_PART, function(item, callback){
			item=$.parseJSON(item);

			var $lClone=$left_template.clone(true), $rClone=$right_template.clone(true);
			$lClone.addClass( (item['id']+'_level4 '+o_json['data-v3']+'_level3 '+o_json['data-v2']+' '+o_json['data-v1']+'_cls') ).eq(0)
					.attr({'data-number': o_json['data-number'], 'data-isocode': o_json['data-isocode'], 'data-v3': o_json['data-v3'], 
							'title': item['name'], 'data-v4': item['id'], 'data-v2': o_json['data-v2'], 'data-v1': o_json['data-v1'], 'data-cbc-code': o_json['data-code'] })
					.find('span.scell').html(item['snumber']);
			
			$lClone.eq(0).find('td:last input').val( Globalize.format(0, point) );
			
			$rClone.eq(0).find('td:gt('+celIndex+')').each(function(){
				$(this).attr({'data-old': 0, 'data-amount': 0}).find('input').val( Globalize.format(0, 'n0') );
				$rClone.eq(1).find('td:eq('+this.cellIndex+')').attr({'data-old': 0}).html( Globalize.format(0, 'n') );
			});
			
			$lRow.after($lClone);
			$rRow.after($rClone);
			
		}, function(err){ 
			SAVE_PART=[]; 
			$popbox.find('input[type="button"]').removeAttr('disabled');
			$popbox.find('#popup_loading').html(CUSTOM_LABEL['savemsgsuccess']).fadeOut(1200);
			closePopUP(null);
		}, 120);
		
	}
    
    /*
    
    ,
        $left_append=$('#ltabid tr.cbcsub.backlog.'+o_json['aid']+'_cls.'+o_json['cbcNum']), $right_append=$('#rtabid tr:eq('+$left_append.index()+')'),
        $partner_tab=$('#parttab'), $left_tr=$partner_tab.find('tbody tr').clone(), $right_tr=$partner_tab.find('tfoot tr').clone(),
		aCls=(o_json['aid']+'_cls '+o_json['cbcNum']);

    $popbox.find('input[type="button"]').attr('disabled', true);
    
    o_json['json'] = $.parseJSON(o_json['json']);
	
    setRefDataJSON();
    
    $('#tab_head_list td.dn').each(function(){
        $right_tr.find('td:eq('+this.cellIndex+')').addClass('dn');
    });
    $right_tr.on('mouseenter mouseleave', overTableRelay_eve).find('input')
    		 .on('focus change', input_fc_relay_eve).on('keyup', input_keyup_relay_eve);
    $left_tr.on('mouseenter mouseleave', overTableRelay_eve).eq(0)
    		.attr({'data-aid': o_json['aid'], 'data-aidcls': o_json['aid']+'_cls', 'data-hierarchy': 'root3', 
					'data-cbc-num': o_json['cbcNum'], 'data-cbc-code': o_json['cbcCode']})
			.on('click', {$divbody: $('#div_body')}, clickLeftTableRelay_eve);
			
	$left_tr.eq(0).find('td:last').on('mouseenter mouseleave', overPriceTab_relay_eve)
			.append('<input type="text" value="" class="zidxInput" style="margin-left: -20px;"/>')
			.find('input').on('focus change', input_price_eve);

    asyncEachSeries_Original(SAVE_PART, function(item, callback){
        var item_json=$.parseJSON(item), $left_clone=$left_tr.clone(true), $r_clone=$right_tr.clone(true);
        
        $left_clone.addClass( (aCls+' '+item_json['partId']+'_part') )
        		   .eq(0).attr({'data-gid': item_json['gId'], 'data-pid': item_json['partId'], 'title': item_json['partDesc']}).find('span.scell').text(item_json['partName']);
			
		$left_clone.eq(0).find('span.part_d').on('mouseenter mouseleave', delPartOverRelay_eve)
				   .find('input[type="button"].delpartbtn').on('click', delPartBtnRelay_eve);
				   
		$r_clone.eq(0).addClass('part').attr('data-row-name', 'part');
		
		$left_append.after($left_clone);
		$right_append.after($r_clone);			
		
		var newJson=$.extend({}, o_json);
		newJson['$rcell']=$r_clone;
		newJson['json']['set_partIds']=[item_json['partId']];
        newJson['json']=JSON.stringify(newJson['json']);

		customRemoteActionRelay(newJson, addPartRefData_js, complete_addPartRefDataRelay);
		
    }, function(err, data, $tbody){
		SAVE_PART=[];
        $popbox.find('input[type="button"]').removeAttr('disabled');
        $('#popup_loading').html(CUSTOM_LABEL['savemsgsuccess']).fadeOut(1200);
        closePopUP(null);
    }, 120, null, null);
    
    
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

		o_json['json']['territoryCode']=$('[id*=hidd_territorycodeid]').val();
		o_json['json']['periodStartDate']=$('[id*=hidd_periodsdid]').val();
		o_json['json']['refStartDate']=$('[id*=hidd_start]').val();
		o_json['json']['refEndDate']=$('[id*=hidd_end]').val();
		o_json['json']['set_partIds']=[];
    	
    	
    	//"map_year_monthsFuture": '+$('#hidd_mapfuture').val()
    }
    */
}


;function submitRelayForecast(target){
	var el_save=document.getElementById('saverelayinputid');
	
	if(el_save.getAttribute('data-submit') == 'no'){
		IS_RELAY_SUBMIT=false;
		saveAndSubmitRelayForecast();
		return;
	}
	
	IS_RELAY_SUBMIT=true;
	el_save.click();
}

;function saveAndSubmitRelayForecast(){
	
	document.getElementById('loading-curtain-div').style.display='';
	var str_json=JSON.stringify({'managerId': $('#hidd_managerid').val(), 'territoryCode': $('#hidd_territorycodeid').val()});
	$('#submitamhidd').val(str_json);
	submitRelay();	//this is action function.
}

;function submitRelayComplete(){
	$('[id*=hidd_frezz]').val(true);
	$('#saverelayinputid').remove();
	$('#submitamfcid').parent().remove();
	$('#ltabid span.part_d').remove();
	document.getElementById('loading-curtain-div').style.display='none';
}

;function saveRelayForecast(target){
	
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
	
	var $pBar=$("#progressbar").progressbar({ value: false }).attr('data-value', 0), $lBody=$('#ltabid'), $rBody=$('#rtabid'), 
		oData={ 'territorycode': $.trim($('[id*=hidd_territorycodeid]').val()), 'map_year_quartersFuture': $.parseJSON($('#hidd_yearfutureid').val()),
				'oCell': {}, 'crtCell': $('#tab_head_list td.crtQtotal')[0].cellIndex-1
		}, list_save=[];

	$('#tab_head_list td.qcell').each(function(){
		oData['oCell'][this.cellIndex]=this.getAttribute('data-date');
	});
	
	setProductCode(list_save, $lBody, $rBody, oData);
	setPart(list_save, $lBody, $rBody, oData);

	if(list_save.length == 0){ 
		$('div.progress_cls').hide();
		if(IS_RELAY_SUBMIT){
			saveAndSubmitRelayForecast();
		}else{
			art.dialog({
		        title:' ', lock:true, dblclick_hide:false, esc:false, id: 'countsid',
		        content: 'Not found save data.',
		        button : [ {value: 'Ok', focus: true, callback: function(){  }} ]
		    });
		}
		return; 
	}
	
	if(!IS_RELAY_SUBMIT){ $(target).attr('data-submit', 'no'); }
	
	var percent=(1 / list_save.length * 100), max=Math.floor(percent*list_save.length), bg_color=Math.floor( Math.random() * 16777215 ).toString( 16 ), 
		list_rgba=$.Color('#'+bg_color)._rgba, rgba=( 'rgba('+list_rgba[0]+','+list_rgba[1]+','+list_rgba[2]+',0.3)' );

	$pBar.progressbar({ max: max, change: progressbarChangeRelay, complete: progressbarCompleteRelay })
				.find('.ui-progressbar-value').css({ "background": '#'+bg_color });
				
	asyncEachSeries_Original(list_save, function(item, callback){
		item['data']['percent']=percent;
		item['data']['max']=max;
		item['data']['$bar']=$pBar;
		item['json']=JSON.stringify(item['json']);
		customMultipleRemoteAction(item, item['action'], item['complete']);
    //    customRemoteActionRelay(item, saveRelayForecast_js, complete_saveForecastRelay); //this is remote action
    }, function(err){ }, 180);
    
	$('#progresserror').css({'background': rgba, 'top': '-20%'}).animate({top: '10%'}, 360, animateComplete);

	/* START save forecast Helper methods*/
	;function setProductCode(list_save, $lBody, $rBody, oData){

		$lBody.find('tr.rt3').each(function(){
			var $this=$(this), price=Globalize.parseFloat( $.trim($this.find('input.pricecls').val()) ),
				o={'json': {'grouping': $this.attr('data-v1'), 'cbc2Code': $this.attr('data-cbc-code'), 'productcode': $this.attr('data-number'),
							'productname': $this.attr('data-name'), 'territoryCode': oData['territorycode'], 'price': price, 'currencyIso': $this.attr('data-isocode'),
							'map_year_quartersFuture': oData['map_year_quartersFuture'], 'map_datekey_csFC': {}
							},
					'data': {'percent': 0, 'max': 0, 'name': $this.find('span.snamecell').html()},
					'cls': WORK_RELAYCLS['level3'], 'action': saveAPLsObject_js, 'complete': complete_saveForecastRelay
				};
			$rBody.find('tr:eq('+this.rowIndex+') td:gt('+oData['crtCell']+')').each(function(){
				var key=oData['oCell'][this.cellIndex];
				o['json']['map_datekey_csFC'][key] = Globalize.parseFloat( $.trim($(this).find('input').val()) );
			});
			list_save.push(o);
		});
	}
	
	
	;function setPart(list_save, $lBody, $rBody, oData){
		$lBody.find('tr.rt4').each(function(){
			var $this=$(this), price=Globalize.parseFloat( $.trim($this.find('input.pricecls').val()) ),
				o={'json': {'grouping': $this.attr('data-v1'), 'cbc2Code': $this.attr('data-cbc-code'), 'partId': $this.attr('data-v4'), 
							'territoryCode': oData['territorycode'], 'price': price, 'currencyIso': $this.attr('data-isocode'),
							'map_year_quartersFuture': oData['map_year_quartersFuture'], 'map_datekey_csFC': {}
							},
					'data': {'percent': 0, 'max': 0, 'name': $this.find('span.cellbox.scell').html()},
					'cls': WORK_RELAYCLS['level4'], 'action': saveAPLsObject_js, 'complete': complete_saveForecastRelay
				};

			$rBody.find('tr:eq('+this.rowIndex+') td:gt('+oData['crtCell']+')').each(function(){
				var key=oData['oCell'][this.cellIndex];
				o['json']['map_datekey_csFC'][key] = Globalize.parseFloat( $.trim($(this).find('input').val()) );
			});
			list_save.push(o);
		});
	}
	
	
	;function animateComplete(){
		$('#prg_total').html( list_save.length );
		$('#prg_scues').html(0);
		$('#prg_err').html(0);
	}
	/* END save forecast Helper methods*/
}
;function reSaveFCRelay(target){
	
	var $pBar=$("#progressbar").progressbar('destroy').attr('data-value', 0), list_save=SAVE_ERRORS.slice(0),
		percent=(1 / list_save.length * 100), max=Math.floor(percent*list_save.length), 
		bg_color=Math.floor( Math.random() * 16777215 ).toString( 16 ), list_rgba=$.Color('#'+bg_color)._rgba, 
		rgba=( 'rgba('+list_rgba[0]+','+list_rgba[1]+','+list_rgba[2]+',0.3)' );
	
	SAVE_ERRORS=[];
	setPopBoxStatus();
	$('#progresserror').css({ "background": rgba });
	$('#prg_total').html(list_save.length);
	$pBar.find('div.progress-label').html('Loading...');
	
	$pBar.progressbar({ value:false, max: max, change: progressbarChangeRelay, complete: progressbarCompleteRelay })
			.find('.ui-progressbar-value').css({ "background": '#'+bg_color });

	asyncEachSeries_Original(list_save, function(item, callback){
		item['data']['percent'] = percent;
		item['data']['max'] = max;
		customMultipleRemoteAction(item, item['action'], item['complete']);
    //    customRemoteActionRelay(item, saveRelayForecast_js, complete_saveForecastRelay); //this is remote action
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
;function showFCErrorsRelay(target){

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
;function progressbarChangeRelay(event, ui){
}

;function progressbarCompleteRelay(event, ui){
	var t = parseInt($.trim($('#prg_err').html()), 10), $prog_btn=$('#progressbarbtn_div');
	$prog_btn.find('input[type="button"].errbtn').remove();
	if($.isNumeric(t) && t > 0){
		$prog_btn.prepend('<input value="Show errors" onclick="showFCErrorsRelay(this)" class="btn errbtn" type="button" /><input onclick="reSaveFCRelay(this)" value="Re save forecast" class="btn errbtn" style="margin: 0 10px;" type="button"/>');
		$('#progressbarbtn_div').show();
		return;
	}
	if(IS_RELAY_SUBMIT){
		setTimeout(function(){ 
			closeProgressBox();
			saveAndSubmitRelayForecast(); 
		}, 210);
		return;
	}else{
		$('#progressbarbtn_div').show();
	}
	
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

;function reCBC2FC_relay_eve(e){
    rePublic_eve_relay(e, this, searchRelayCBC2_js, complete_searchCBC2Relay); //this cbc2 remote action
}
;function rePartFC_relay_eve(e){
    rePublic_eve_relay(e, this, searchRelayPartFC_js, complete_searchPartFCRelay);  //this part remote action
}
;function reAddPart_eve(e){
	reload_public_eve(e, this, addPartRefData_js, complete_addPartRefDataRelay);  //this part remote action
}
;function rePublic_eve_relay(e, target, searchRemoteAction, complete_searchRemoteAction){
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
        rowIsLockedRelay(_data['rowIndex']);
        $tr.addClass('ready');
        $td.find('span.fcell').addClass('waiting');
        customRemoteActionRelay(_data, searchRemoteAction, complete_searchRemoteAction);
        $this.off('mouseenter mouseleave click').parent().remove();
    }
}

;function closePopUP(target){
    $('#popupbox').stop().animate({'top':-800}, 800, function(){
        $('#popupmain').fadeOut('fast');
    });
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

;function overTableRelay_eve(e){
    var $this=$(this), _idx=$this.index(), findTab=($this.parent().hasClass('ltbodycls') ? '#rtabid tr' : '#ltabid tr');
    eventHandle_ov_ot(e, ov, ot);
    
    ;function ov(e){ $(findTab).eq(_idx).addClass('overbodybg'); }
    ;function ot(e){ $(findTab).eq(_idx).removeClass('overbodybg overbodybg'); }
}

;function overPriceTab_relay_eve(e){

	var $this=$(this);
	eventHandle_ov_ot(e, ov, ot);
	
	;function ov(e){//margin-left: -120px;
		$this.find('input').stop().animate({'margin-left': '-120px'}, 190, function(){
			$(this).focus().select();
		});
	}
	;function ot(e){
		$this.find('input').blur().animate({'margin-left': '-20px'}, 160);
	}
}


;function windowReSizeRelay(e){
    document.getElementById('forecastdiv_id').style.visibility='hidden';
    fixTableLayoutRelay($('#tabContainer').width(), false);
}
;function rCellScroll_eve(e){
	var _this=this, scLeft=_this.scrollLeft;
    if (TIMEOUT){ clearTimeout(TIMEOUT) };
    document.getElementById('right_head').scrollLeft = scLeft;
    TIMEOUT = setTimeout(function(){
	    document.getElementById('floatscroll').scrollLeft = scLeft;
    }, 120);
}


;function appendRelayExpCol(){//append (expand or collapse)
    var $td_cells = $('#tab_head_list td.exp_coll');
    
    $td_cells.off('click').on('click', clickExpColRelay_eve)
            .find('div').append('<b class="exp_coll_box collapse">-</b>');
        
    $td_cells.each(function(idx){
        if(idx < 4){
            $(this).triggerHandler('click');
        }
    });    
}

;function addGPLOver_relay_eve(e){
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

;function addGPLBtn_relay_eve(e){
    e.stopPropagation();

    var $this=$(this), $tr=$this.parent().parent().parent().parent(), hasError = false,
    	$popupbox=$('#popupbox'), $multiselect=$popupbox.find('#multiselect_simple'),
    	params={'json': {'set_selectedId': [], 'grouping': $tr.attr('data-v1'), 'cbc2Code': $tr.attr('data-cbc-code'), 'accnumber': $tr.attr('data-number'),
    						'territoryCode': $('[id*=hidd_territorycodeid]').val(), 'map_year_quartersFuture': $.parseJSON($('#hidd_yearfutureid').val())},
    				'data-v1': $tr.attr('data-v1'), 'data-v2': $tr.attr('data-v2'), 'data-v3': $tr.attr('data-v3'), 
    				'data-code': $tr.attr('data-cbc-code'), 'data-isocode': $tr.attr('data-isocode'), 'data-number': $tr.attr('data-number')
				};
				
    $multiselect.find('option').remove();
    $popupbox.find('#searchproductcodeid').hide();
    $popupbox.find('#addproductcodeid').hide();
    
    $popupbox.find('#searchpart_btnid').show();
    $popupbox.find('input.addpartbtn.top_cls').show();
    $popupbox.find('#saveSearchPartId').show().attr('data-val', JSON.stringify(params));
    
    $popupbox.find('#popup_loading').html(' ').hide();
    
    try{  $multiselect.multiselect('refresh'); }
    catch(e){ hasError = true;}
    
    $('#popupmain').fadeIn('fast');
    $popupbox.css({'top':-800, 'display':''}).stop().animate({'top':'10%'}, 800, function(){
        if(hasError){
            $multiselect.css('min-width', $popupbox.find('#popup_title').outerWidth(true));
            init_multiselectRelay();
        }
        $popupbox.find('#searchpart_inputid').val('').focus();
    });
}

;function searchTopPartBtn_eveRelay(target){
	
	if(TOP_RelayFIRST){
		TOP_RelayFIRST=false;
		$('#multiselect_simple').find('option').remove();
	}
	
	$('#popupbox input[type="button"]').attr('disabled', true);
	$('#popup_loading').html(' ').show();
	var o_json=$.parseJSON($('#saveSearchPartId').attr('data-val')), list_parts=[];
	
	setFilterPartsRelay(o_json, list_parts);
	setFilterSearchTopPart(list_parts);
	
	o_json['hasTop'] = true;

	o_json['json']['isOtherMethod'] = true;
	o_json['json']['set_selectedId'] = list_parts;
    o_json['json'] = JSON.stringify(o_json['json']);
    
	o_json['action'] = searchAPLsObject_js;
	o_json['complete'] = complete_searchTopPartRelay;
	o_json['cls'] = WORK_RELAYCLS['level4'];

//    customRemoteActionRelay(data_json, searchRelayPagePart_js, complete_searchRelayPart); 
    customMultipleRemoteAction(o_json, o_json['action'], o_json['complete']);

//	o_json['json'] = JSON.stringify(o_json['json']);

//	customRemoteActionRelay(o_json, searchRelayTopPart_js, complete_searchTopPartRelay); //add part remote action
	
	
	;function setFilterPartsRelay(data_json, list_parts){
		$( ('#ltabid tr.rt4.'+data_json['data-v1']+'_cls.'+data_json['data-v2']+'.'+data_json['data-v3']+'_level3') ).each(function(){
			list_parts.push( (this.getAttribute('data-v4')) );
		});
	}
	
	;function setFilterSearchTopPart(){
		$('#multiselect_simple').find('option').each(function(){
			list_parts.push(this.value);
		});
	}
	
}


;function searchPartPopUPRelay(target){
	TOP_RelayFIRST=true;
    SAVE_PART = [];     //clear search part list

    var $popbox=$('#popupbox'), $input=$('#searchpart_inputid'), $loading=$popbox.find('#popup_loading'),
        data_json=$.parseJSON($popbox.find('#saveSearchPartId').attr('data-val')), list_parts=[];

    $loading.html(' ').show();
    setFilterPartsRelay(data_json, list_parts);
    
    $popbox.find('input[type="button"]').attr('disabled', true);

	data_json['json']['isOtherMethod'] = false;
	data_json['json']['searchKey'] = $.trim($input.val());
	data_json['json']['set_selectedId'] = list_parts;
    data_json['json'] = JSON.stringify(data_json['json']);
    
	data_json['action'] = searchAPLsObject_js;
	data_json['complete'] = complete_searchRelayPart;
	data_json['cls'] = WORK_RELAYCLS['level4'];

//    customRemoteActionRelay(data_json, searchRelayPagePart_js, complete_searchRelayPart); 
    customMultipleRemoteAction(data_json, data_json['action'], data_json['complete']);
    
    
    ;function setFilterPartsRelay(data_json, list_parts){
		$( ('#ltabid tr.rt4.'+data_json['data-v1']+'_cls.'+data_json['data-v2']+'.'+data_json['data-v3']+'_level3') ).each(function(){
			list_parts.push( (this.getAttribute('data-v4')) );
		});
	}
    
}

;function fixTableLayoutRelay(resize_width){
    var $compbody=$('#forecastdiv_id'), min_cw= parseInt($compbody.css('min-width').replace('px', ''), 10), 
        max_ow=(typeof(resize_width) != 'undefined' ? resize_width : $('#contentallid').outerWidth(true));

    min_cw = (max_ow < min_cw ? min_cw : (max_ow-20));
    document.getElementById('contentallid').style.width = (min_cw)+'px';    //set all div width

    var lCellw=$compbody.find('#left_body').width(), window_h = $(window).height(),
        rightCell_w=parseInt((min_cw-lCellw-2), 10)-20,
        usedHeight = ($('#dmsgid').outerHeight(true) + $('#AppBodyHeader').outerHeight(true) + $('div.bPageFooter.noTableFooter').outerHeight(true) + 50),
        v_height= (window_h - usedHeight - 90);

    document.getElementById('rCellScroll').style.width = rightCell_w+'px';
    document.getElementById('right_head').style.width = rightCell_w+'px';
    $compbody.css('visibility', 'visible');
	$('#floatscroll').css({'width': rightCell_w, 'left': $('#rCellScroll').offset()['left']-7}).find('#innerData').css('width', $('#rTabDataId').width());
}
;function rowUnLockRelay(_rowIndex){  //unlocked current row Repeat click event
    setTimeout(function(){ delete STATIC_VAR[_rowIndex]; }, 75);    //unlocked
}
;function rowIsLockedRelay(_rowIndex){    //locked current row Repeat click event
    if(STATIC_VAR.hasOwnProperty(_rowIndex)){ return true; }    //locked 
    STATIC_VAR[_rowIndex] = '';
    return false;
}
;function alertRelayMessage(content){
	art.dialog({
        title:' ', lock:true, dblclick_hide:false, esc:false, id: 'countsid',
        content: content,
        button : [ {value: 'Ok', focus: true, callback: function(){  }} ]
    });
}
;function finalFormatRelay(){
    var $tab_body = $('#div_body'), $head_td_list=$('#tab_head_list td'), 
    	startQcell=$head_td_list.filter('.qcell:first').index()-1, reatPoint='n'+$('#hidd_currency').val();

    $tab_body.find('b.fmt_cls').html(function(){
        var reat = parseFloat( $.trim(this.getAttribute('data-reat')) );
        this.innerHTML = (this.getAttribute('data-code') + ' ' + Globalize.format(reat, reatPoint));
    });
    $tab_body.find('#rtabid tr.fmt_rcls, tr.rsmFC').find('td:gt('+startQcell+')').each(function(){
    	var _data_value=$.trim(this.getAttribute('data-value'));
		_data_value=($.isNumeric(_data_value) ? parseFloat(_data_value) : 0)
        this.innerHTML = Globalize.format(_data_value, 'n');
    });
    $tab_body.find('#ltabid tr').filter('.posFC.actsub, .cmaFC.actsub, .totalSA.actsub').each(function(){
		this.className += ' nhide ';
		$tab_body.find('#rtabid tr').eq(this.rowIndex).addClass('nhide');
	});
	/*
	$tab_body.find('#ltabid tr.totalBilling, tr.totalBooking, tr.totalBacklog').each(function(){
		$(this).find('td:eq(1)').css({'position': 'relative'}).append('<span class="topcls">Q</span><span class="btmcls">A</span>');
	});
	*/
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
;function customRemoteActionRelay(strParam, callFunction, callResult) {
    Visualforce.remoting.Manager.invokeAction(
        callFunction(), strParam['json'], function(result, event){ callResult(result, event, strParam); }, {escape: false, timeout:120000}
    );
}

;function getZeroOfNumberRelay(t){
	t=parseFloat(t);
	return ($.isNumeric(t) ? t : 0);
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
;function addListener (element, event, fn, params) {
    var eventHandler = ( params ? function(){ fn.call(params); } : fn );
    if (window.attachEvent) {
        element.attachEvent('on' + event, eventHandler);
    } else {
        element.addEventListener(event, eventHandler, false);
    }
}