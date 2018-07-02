var TIMEOUT, scrollbarW = $.getScrollbarWidth(), RSM_BTN='', STATIC_VAR = {}, RSM_TYPE='AM', SAVE_ERRORS=[], _queueTask = async.queue(queueTask, 1);

;function queueTask(task, callback) {
    task.run(callback);
}
;function isAM(){
	if($('[id*=selectedtypeid]').val() == 'AM'){
		return true;
	}
	return false;
}
;function initCtrlDocument(){
    Globalize.culture(this.locale).numberFormat.currency.symbol = "";
    try{
	    var map_rsmType=$.parseJSON( $('[id*=rsmtypeid]').val() ), content = '', t='';
	
	    if(!$.isEmptyObject(map_rsmType)){
	    	for(var o in map_rsmType){
	    		t += ('<div style="padding:0px 10px; display: inline-block;"><input onclick="searchRSMType(this)" data-value="'+o+'" value="'+CUSTOM_LABEL[o]+'" class="btn" style="padding-left: 10px; padding-right: 10px;" type="button" data-interface="'+map_rsmType[o]+'" /></div>');
	    	}
	    	content = '<div style="text-align: center;height: 40px;line-height: 40px;"><div id="rsmtypebtndiv">'+t+'</div></div>';
	    	document.getElementById('loading-curtain-div').style.display = 'none';
	    	art.dialog({
		        title:' ', lock:true, dblclick_hide:false, esc:false, cancel:false, id: 'rsmtypedialog',
				content: content
		    });
		    
	    	return;
	    }
	    
	    initDocument();
    }catch(e){
    	document.getElementById('loading-curtain-div').style.display='none';
    }
}

;function initDocument(){
    appendExpand_Collapse();
    register_event();
    $('#floatscroll').css({'height': scrollbarW, 'line-height': scrollbarW});
    fixTableLayout();
    finalFormat();
    
    setTimeout(function(){
    	$('#div_body').find('#ltabid tr.cp').eq(0).click()}, 1000
    );//added by nelson zheng 2015-9-16
}

;function register_event(){
    var $body_div = $('#div_body');
    //	scroll_attr={'$ghb': $('#globalHeaderBar'), '$abh': $('#AppBodyHeader'), '$menu':$('#menudivid'), '$floathead': $('#headmainid')};

    $body_div.find('tbody.overbody tr').off('mouseenter mouseleave').on('mouseenter mouseleave', overTable_eve)
    		.find('span.pin').off('click').on('click', clickLeftPin_eve);  
    $body_div.find('#rCellScroll').scroll(rCellScroll_eve)
             .find('#rtabid input[type="text"]').off('focus change').on('focus change', input_fc_eve)
             .off('keyup').on('keyup', input_keyup_eve);

    $body_div.find('#ltabid tr.cp').off('click').on('click', {$divbody: $body_div}, clickLeftTable_eve)
    		 .find('input.unfreeze').off('click').on('click', clickUnFreeze_eve);
    		 
	$('#gototopid').off('mouseenter mouseleave click').on('mouseenter mouseleave click', clickGotoTop_event);
    $(window).scroll(scroll_event).smartresize(windowReSize);
    $('#floatscroll').off('scroll').scroll(event_floatScroll);
    $('#menuBtntd input').off('click').on('click', event_hideCalendar_click);
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
;function searchRSMType(target){
	document.getElementById('loading-curtain-div').style.display = '';
	RSM_BTN=$('#rsmtypebtndiv').css('display', 'inline-block');
	art.dialog({id: 'rsmtypedialog'}).close();
	$('[id*=selectedtypeid]').val(target.getAttribute('data-value'));

	setTerritory();		//this is action function
}
;function setTerritoryComplete(){	//action function complete
	SAVE_ERRORS=[];
	STATIC_VAR = {};
	
	if(isAM()){
		createAMTerritoryCodeData();
		
	}else{
		createRelayTerritoryCodeData();
	}
	
//	$('#menudivid span.rsmbtnspan').before(RSM_BTN);
	initDocument();
}


;function input_fc_eve(e){
    
    var _this = this, $this = $(_this), ov = '', validation_qty = /^([1-9]\d{0,16}|0)(\.\d{1,2})?$/, 
        tv = Globalize.parseFloat($.trim(_this.value)); //focus Event
    
    ov = $this.inputFocusValueFormat(validation_qty, e);
	
    if(e.type == 'change'){
    	/*
        if(!validation_qty.test(tv) || (tv==ov && ov!='')){ //not changed or old value eq new value
            $this.val ( $.isNumeric(ov) ? Globalize.format(ov, 'n') : '' ).focus().select();
            return;
        }
        */
		ov = ($.isNumeric(ov) ? ov : 0);
        tv = ($.isNumeric(tv) ? tv : 0);
        
        if(isAM()){
	        _this.value = Globalize.format(tv, 'n');
	        var o_cfg = getTableInfo();
        	changeInput_AMForecast(ov, tv, $this, o_cfg);
        	return;
        }
        _this.value = Globalize.format(tv, 'n0');
    	changeInput_RelayForecast(ov, tv, $this);
        
    	
    }

    ;function getTableInfo(){
    	var o = { '$input' : $this, '$rtd' : $this.parent(), '$left_trs': $('#ltabid tr') };
    	o['$rtr'] = o['$rtd'].parent();
    	o['$right_trs'] = o['$rtr'].parent().find('tr');
    	o['$ltr'] = o['$left_trs'].eq(o['$rtr'].index());
    	o['cellIndex'] = o['$rtd'].index();
    	o['codecls'] = o['$ltr'].attr('data-codecls');
    	o['aid'] = o['$ltr'].attr('data-aid');
    	o['cbc2num'] = o['$ltr'].attr('data-cbc-num');
    	o['gid'] = o['$ltr'].attr('data-gid');
    	return o;
    }
}

;function input_keyup_eve(e){
	
    var $this=$(this), $td=$this.parent(), $tr=$td.parent(), $tbody=$tr.parent(),
        _cellIndex=$td[0].cellIndex, _rowIndex=$tr[0].rowIndex;

    if(e.shiftKey && e.keyCode == 13){  //find prve cell input
    	$td.prev().find('input[type="text"]').focus().select();
    //    $tbody.find('tr:lt('+_rowIndex+'):not(.dn)')
    //        .find('td:eq('+_cellIndex+'):has(input)').last().find('input[type="text"]').focus().select();
    }else if(e.keyCode == 13){  //find next cell input
    	$td.next().find('input[type="text"]').focus().select();
    //    $tbody.find('tr:gt('+_rowIndex+'):not(.dn)')
    //        .find('td:eq('+_cellIndex+'):has(input)').first().find('input[type="text"]').focus().select();
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
;function event_hideCalendar_click(e){

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
	fixTableLayout();
	$this.val( (status == 'show' ? $this.attr('data-show') : $this.attr('data-hide')) );
	$this.attr('data-status', (status == 'show' ? 'hide' : 'show'));
}
;function event_openRSMgroup_click(target){
//	document.getElementById('loading-curtain-div').style.display = '';

	if($('#openrsmgroupid').length == 0){
		var json={'userId': $('[id*=hidd_managerid]').val(), 'viewMode': $('[id*=selectedtypeid]').val(), 'isOtherMethod': false};
		json=JSON.stringify(json);
	//	var sType=$('[id*=selectedtypeid]').val(), userId=$('[id*=hidd_managerid]').val();
		$('#menudivid').append(
			'<a style="display:none;" id="openrsmgroupid" href="'+('/apex/APL_CtrlRSMGroupingForecast?uid='+Base64.encode(json) )+'" target="_blank"></a>'
		);		
	}
	$('#openrsmgroupid')[0].click();
	//	window.location.href = ('/apex/APL_CtrlRSMGroupingForecast?uid='+Base64.encode( (userId+'_'+sType) ) );
	//selectedtypeid
}
;function event_chart_click(event, target){
	var _url=$.trim( $('#charturlid').val() );
	if(_url == ''){
		alert('URL error.');
		return;
	}
	if($('#openrsmchartid').length == 0){
		$('#menudivid').append(
			'<a style="display:none;" id="openrsmchartid" href="'+_url+'" target="_blank"></a>'
		);		
	}
	$('#openrsmchartid')[0].click();
}
;function clickGotoTop_event(e){
	var $this = $(this), overcls = 'over';
	;function ov(e){$this.addClass(overcls);}
	;function ot(e){$this.removeClass(overcls);}
	;function ck(e){$('html,body').animate({scrollTop: 0}, 450);}
	eventHandle(e, ov, ot, ck);
}

;function clickUnFreeze_eve(e){
	e.stopPropagation();
	var $this=$(this), $span=$this.parent(), $tr=$span.parent().parent().parent();
	if(isAM()){
		click_AMUnFreeze(e, $this, $span, $tr);	//CtrlGroupingRSM_AMForecastJS resource
	}else{
		click_RelayUnFreeze(e, $this, $span, $tr);		//CtrlGroupingRSM_RelayForecastJS resource
	}
}

;function clickLeftPin_eve(e){
	e.stopPropagation();
	
	if(!isAM()){
		event_relayRefData_click(e, this);
		return;
	}else{
		event_refAMData_click(e);
		return;
	}
	
	var _this=this, $this=$(_this), $td=$this.parent().parent(), $tr=$td.parent(), $body=$tr.parent(), $right_trs=$('#rtabid tr'),
		aId=$tr.attr('data-aidcls'), root=$tr.attr('data-root'), codeCls=$tr.attr('data-codecls'), 
		cbcNum=$tr.attr('data-cbc-num'), gplId=$tr.attr('data-gid'), cls='';
		
	if($this.hasClass('readypin')){
		return false;
	}
	
	switch(root){
		case 'root10': cls = 'tr.'+$tr.attr('data-tnum'); break;
		case 'root0':  cls = 'tr.ttsub.'+codeCls; break;
		case 'root1':  cls = 'tr.asub.'+aId+'.'+codeCls; break;
		case 'root2':  cls = 'tr.cbcsub.'+aId+'.'+codeCls+'.'+cbcNum; break;
		case 'root3':  cls = 'tr.gplsub.'+aId+'.'+codeCls+'.'+cbcNum+'.'+gplId+'_gpl'; break;
		default: return;
	}
	
	
	if(!$this.hasClass('donepin') && $this.hasClass('spin')){
		$this.addClass('readypin waitingpin');
		
		if(isAM()){
			click_AMPin(e, _this, $this, $td, $tr, $body, $right_trs, root, cls, aId, codeCls);	//CtrlGroupingRSM_AMForecastJS resource
		}else{
			click_RelayPin(e, _this, $this, $td, $tr, $body, $right_trs, root, cls, aId, codeCls);		//CtrlGroupingRSM_RelayForecastJS resource
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
}
;function clickLeftTable_eve(e){
	console.log(e);
	if(isAM()){
		clickAMLeftTab(e, this);	//CtrlGroupingRSM_AMForecastJS resource
		return;
	}
	clickRelayLeftTab(e, this);		//CtrlGroupingRSM_RelayForecastJS resource
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

;function complete_remoteStatus(data, taskCallBack){
	rowUnLock(data['rowIndex']);
	data.$row.removeClass('ready').addClass('done').find('td:first span.fcell').html('-').removeClass('waiting');
	taskCallBack(null); 
}

;function hideForecastHead($right_tr){
	var $head=$('#tab_head_list td'), list_hidden_td=$head.filter('.dn').toArray(), 
		list_nhide_td=$head.filter('.nhide').toArray();
	
	$right_tr.each(function(){
		var $tds = $(this).find('td');
		for(var i=0, el; el=list_hidden_td[i]; i++){
			$tds.eq(el.cellIndex).addClass('dn');
		}
		for(var i=0, el; el=list_nhide_td[i]; i++){
			$tds.eq(el.cellIndex).addClass('nhide');
		}
	});	
	/*
	$('#tab_head_list td.dn').each(function(){
        $right_tr.find('td:eq('+this.cellIndex+')').addClass('dn');
    });
    */
}

;function formatFC(isInput, fc, $tds, data_cell, inputCls){
	if(isInput){
		var _disabled = (inputCls == 'cbc2' ? 'disabled="disabled"' : '');
    	for(var f in fc){
    		$tds.eq(data_cell[f]).html('<input type="text" '+_disabled+' data-type="'+inputCls+'" value="'+
    										Globalize.format(fc[f], 'n')+'" class="inputcls '+inputCls+' "/>');
    	}
    	return;
	}
	for(var f in fc){
		$tds.eq(data_cell[f]).text(Globalize.format(fc[f], 'n'));
	}
}

;function addReloadButton(data, event, reloadButtonEventCallBack){

    var el_reload = '<span class="reload_span"><span class="reload_img"></span><b class="reload_msg" style="display:none;">'+event['message']+'</b></span>';
    data.$row.removeClass('ready done').find('td:first').prepend(el_reload)
			.parent().find('span.reload_img').off('mouseenter mouseleave click')
            .on('mouseenter mouseleave click', {$data: data}, reloadButtonEventCallBack);
    rowUnLock(data['rowIndex']);
}

;function reSaveForecast(target){
	var $pBar=$("#progressbar").progressbar('destroy'), list_save=SAVE_ERRORS.slice(0),
		progAttr=getProgressAttr(list_save);
	
	SAVE_ERRORS=[];
	setPopBoxStatus();
	$('#prg_total').html(list_save.length);
	$pBar.find('div.progress-label').html('Loading...');
	$('#progresserror').css({ "background": progAttr['rgba'] });
	
	$pBar.progressbar({ value:false, max: progAttr['max'], change: pBarChange, complete: pBarComplete })
			.find('.ui-progressbar-value').css({ "background": progAttr['bgColor'] });
	asyncEachSeries_Original(list_save, function(item, callback){
		item['data']['percent']=progAttr['percent'];
		item['data']['max']=progAttr['max'];
        customRemoteAction(item, saveForecast_js, item['call']); //this is remote action
    }, function(err){ list_save=[];}, 180);

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
	;function getProgressAttr(list_save){
		var bg_color=Math.floor( Math.random()*16777215 ).toString(16),
			list_rgba=$.Color('#'+bg_color)._rgba, percent=(1/list_save.length*100);
		return {
			'bgColor': '#'+bg_color, 'list_rgba': list_rgba, 
			'rgba': ( 'rgba('+list_rgba[0]+','+list_rgba[1]+','+list_rgba[2]+',0.3)' ),
			'percent': percent, 'max': Math.floor(percent*list_save.length)
		};
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
;function pBarChange(event, ui){
}

;function pBarComplete(event, ui){
	var t = parseInt($.trim($('#prg_err').html()), 10), $prog_btn=$('#progressbarbtn_div');
	$prog_btn.find('input[type="button"].errbtn').remove();

	if($.isNumeric(t) && t > 0){
		$prog_btn.prepend('<input value="Show errors" onclick="showForecastErrors(this)" class="btn errbtn" type="button" /><input onclick="reSaveForecast(this)" value="Re save forecast" class="btn errbtn" style="margin: 0 10px;" type="button"/>');
	}
	$('#progressbarbtn_div').show();
	
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

;function reload_public_eve(e, target, searchRemoteAction, complete_searchRemoteAction){
    e.stopPropagation();
    
    var _data = e.data.$data, _this = target, $this = $(_this), $span=$this.parent(),
        $td=$span.parent().parent(), $tr=$td.parent();

    eventHandle(e, ov, ot, click);
    
    ;function ov(){ 
        if(navigator.userAgent.indexOf("Firefox")>0){
            $span.find('b').css({'left': -156}).show(); 
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
	
	;function doHide(){ if(!$refDiv.hasClass('overg')){ $refDiv.hide(); } }
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

;function overTable_eve(e){
    var $this=$(this), _idx=$this.index(), findTab=($this.parent().hasClass('ltbodycls') ? '#rtabid tr' : '#ltabid tr.lefttrs');
    eventHandle_ov_ot(e, ov, ot);
    
    ;function ov(e){ $(findTab).eq(_idx).addClass('overbodybg'); }
    ;function ot(e){ $(findTab).eq(_idx).removeClass('overbodybg overbodybg'); }
}

;function windowReSize(e){
    $('#forecastdiv_id').css({'visibility': 'hidden'});
    fixTableLayout($('#tabContainer').width(), false);
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
    fixTableLayout($('#tabContainer').width(), false);
    
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
       // 	$this.removeAttr('style').parent().find('td:eq(0)').css('border-left', '1px solid #fff');
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

;function fixTableLayout(resize_width){
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
}

;function finalFormat(){
	document.getElementById('loading-curtain-div').style.display = 'none';
}

;function cancelGroup(target){
    document.getElementById('loading-curtain-div').style.display='';
    window.location.href='/home/home.jsp';
}
;function getZeroOfNumber(t){
	t=parseFloat(t);
	return ($.isNumeric(t) ? t : 0);
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
;function customRemoteAction(strParam, callFunction, callResult) {
    Visualforce.remoting.Manager.invokeAction(
        callFunction(), strParam['json'], function(result, event){ callResult(result, event, strParam); }, {escape: false, timeout:120000}
    );
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