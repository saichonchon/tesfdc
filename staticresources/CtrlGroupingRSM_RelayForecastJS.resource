var WORK_RELAYCLS={
	'level1': 'APL_ClsRSMRelayService.SearchLevel1', 'level2': 'APL_ClsRSMRelayService.SearchLevel2',
	'level3': 'APL_ClsRSMRelayService.SearchLevel3', 'level4': 'APL_ClsRSMRelayService.SearchLevel4',
	'level5': 'APL_ClsRSMRelayService.SearchLevel5', 'leveltotal': 'APL_ClsRSMRelayService.SearchLevelTotal'
};
;function createRelayTerritoryCodeData(){
	
	var $r_trs=$('#rtabid tr'), $l_trs=$('#ltabid tr'), $head_trs=$('#tab_head_list td'), 
		list_trs=$l_trs.filter('.rt0').toArray(), head_cell={};
    
    asyncEachSeries_Original(list_trs, function(item, callback){
		var $this=$(item), $prevCycle=$this.next(),
    		params=createTcodeTotalJson($r_trs.eq($this.index()), $r_trs.eq($prevCycle.index()), $this, $head_trs);
    	$this.find('div:first').append('<span class="tcodefc waitingtcode"></span>');
    	customRemoteAction(params, getAcct_js, complete_RelayTotalCycleFC); //this is total remote action
    }, function(err){ list_trs=[]; }, 120);
	
    $head_trs.filter('.qtotalCls').each(function(){
    	head_cell[this.getAttribute('data-date')]=this.cellIndex;
    });
	    
    $l_trs.filter('.trt_trt').each(function(){
    	var $this=$(this);
    	$this.find('div:first').append('<span class="tcodefc waitingtcode"></span>');
    	var index=$this.index(), $r_tds=$r_trs.filter('.overrulerelayfctotal'), 
    		_json={ 'className': 'ClsAPLEntityTypes.RSMRelayOverRallInfo', 
    				'str_json': '{"managerId": "'+$.trim($('#hidd_managerid').val())+
    				'", "set_rsmIds": '+$('#hidd_relayidsid').val()+', "set_displayNames": '+$('#hidd_rsmrelaydisplaynames').val()+
    				', "map_year_quartersFuture": '+$('#hidd_yearfutureid').val()+' }' },
			params={'$row': $this, 'rowIndex': index, 'json': JSON.stringify(_json), '$r_tds': $r_tds, '$r_oall_tds': $r_trs.filter('.overrulerelayfctotalall').find('td'), 'cell': head_cell};    		
    	customRemoteAction(params, getAcct_js, complete_OverAllRelayFC); //this is total remote action
    });
    
	$('#rtabid tr.relayfctotal').each(function(){
		var $this=$(this), $tds=$this.find('td'), json_val=$.parseJSON( $this.attr('data-value') );
		for(var v in json_val){
			$tds.eq(head_cell[v]).html( Globalize.format(json_val[v], 'n') );
		}
	});
	
	
	;function createTcodeTotalJson($curentCycle, $prevCycle, $this, $head_trs){
		var q_month={}, q_months={}, q_Future={}, q_cell={}, m_cell={},
			_json={'className': 'ClsAPLEntityTypes.RSMRelayTerritoryFCInfo', 'str_json': '{}' }, 
			params={'$row': $this, '$currentCycle': $curentCycle, '$prevCycle':$prevCycle, 'json': '{}', 
					'qFuture': q_Future, 'qMonth': q_month, 'qMonths':q_months, 'qCell': q_cell, 'mCell':m_cell};
		
		params['currentCell']=$head_trs.filter('.crtQtotal')[0].cellIndex+1;
		$head_trs.filter('.monthCls').each(function(){
			m_cell[this.getAttribute('data-month')]=this.cellIndex;
		});	

	    $head_trs.filter('.qtotalCls').each(function(){
	    	var $qCell=$(this), isFuture=$qCell.hasClass('futurec1'), list_month=$qCell.attr('data-months').split(','), q=$qCell.attr('data-date');
	    	q_cell[q]=this.cellIndex;
	    	head_cell[q]=this.cellIndex;
	    	q_months[list_month.join(',')]=this.cellIndex;
	    	q_month[q]=list_month;
	    	for(var i=0, _month; _month=list_month[i]; i++){
		    	q_Future[_month]=isFuture;
	    	}
	    });

        _json['str_json'] = '{"territoryCode": "'+$this.attr('data-code')+'",' +
							' "map_year_quartersFuture": '+$('#hidd_yearfutureid').val()+'}';

    	params['json'] = JSON.stringify(_json);
    	return params;
	}
	
}

;function input_price_eve(e){
	e.stopPropagation();
	
	var _this=this, $this=$(_this), ov='', validation_qty=/^([1-9]\d{0,16}|0)(\.\d+)?$/, 
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
        
        _this.value = Globalize.format(tv, point);
		sumOf_part(initTabInfo());
    }
    
    
    ;function sumOf_part(o_cfg){
    	
    	if(o_cfg['$l_trs'].filter('.trt_trt').hasClass('exp')){
    		o_cfg['$l_trs'].filter('tr.trt_0:not(.trt_trt)').each(function(){
    			o_cfg['$r_trs'].eq(this.rowIndex).addClass('dn');
    			$(this).addClass('dn');
    		});
    		o_cfg['$l_trs'].filter('tr.trt_trt').addClass('col').removeClass('exp').find('span.fcell').html('+');
    	}
    	
    	var codeIndex=o_cfg['$l_trs'].filter( '.rt0.'+o_cfg['codecls'] ).index(),
    		actIndex=o_cfg['$l_trs'].filter( '.rt1.'+o_cfg['codecls']+'.'+o_cfg['acls']).index(),
    		cbcIndex=o_cfg['$l_trs'].filter( '.rt2.'+o_cfg['codecls']+'.'+o_cfg['acls']+'.'+o_cfg['cbcnum']).index(),
    		$cbc_cell=o_cfg['$r_trs'].eq(cbcIndex).find('td'), $act_cell=o_cfg['$r_trs'].eq(actIndex).find('td'), 
    		$code_cell=o_cfg['$r_trs'].eq(codeIndex).find('td'), cCell=$('#tab_head_list td.crtQtotal')[0].cellIndex-1,
    		act_total={}, cbc_total={}, part_total={};
    	
    		
    	o_cfg['$l_trs'].filter( '.rt4.'+o_cfg['acls']+'.'+o_cfg['codecls']+'.'+o_cfg['cbcnum'] ).each(function(){
			var $this=$(this), price=numberOfZero($.trim($this.find('input.pricecls').val()));
			
			o_cfg['$r_trs'].eq(this.rowIndex).find('input').each(function(){
				var $input=$(this), el_td=$input.parent()[0], qty=numberOfZero($.trim($input.val())),
					part_val=getZeroOfNumber(part_total[el_td.cellIndex]);
				part_total[el_td.cellIndex]=(part_val + qty*price);
			});
		});
		sumOfCellInput(part_total, $cbc_cell);
		
    	o_cfg['$l_trs'].filter( '.rt2.'+o_cfg['acls']+'.'+o_cfg['codecls'] ).each(function(){
			o_cfg['$r_trs'].eq(this.rowIndex).find('input').each(function(){
				var tdCellIndex=$(this).parent()[0].cellIndex, v=numberOfZero( $.trim(this.value) ), 
					cbc_val=getZeroOfNumber(cbc_total[tdCellIndex]);
				cbc_total[tdCellIndex]=(cbc_val + v);
			});
		});
		sumOfCell(cbc_total, $act_cell);
		
    	o_cfg['$l_trs'].filter( '.rt1.'+o_cfg['codecls'] ).each(function(){
			o_cfg['$r_trs'].eq(this.rowIndex).find('td:gt('+cCell+')').each(function(){
				var v=numberOfZero( $.trim($(this).text()) ), act_val=getZeroOfNumber(act_total[this.cellIndex]);
				act_total[this.cellIndex]=(act_val + v);
			});
		});
		sumOfCell(act_total, $code_cell);
    }
    
    
    ;function sumOfCell(q_total, $tds){
    	for(var q in q_total){
    		$tds.eq(q).html( Globalize.format(q_total[q], 'n') );
    	}
    	q_total={};
    }
    ;function sumOfCellInput(q_total, $tds){
    	for(var q in q_total){
    		$tds.eq(q).find('input').val( Globalize.format(q_total[q], 'n') );
    	}
    	q_total={};
    }
    
    ;function initTabInfo(){
        var o_cfg = { '$l_td': $this.parent() };
        o_cfg['$l_tr'] = o_cfg['$l_td'].parent();
        o_cfg['$l_trs'] = o_cfg['$l_tr'].parent().find('tr');

        o_cfg['rowIdx'] = o_cfg['$l_tr'][0].rowIndex;
        o_cfg['aid'] = o_cfg['$l_tr'].attr('data-aid');
        o_cfg['acls'] = o_cfg['$l_tr'].attr('data-aidcls');
        o_cfg['code'] = o_cfg['$l_tr'].attr('data-code');
        o_cfg['cbcnum'] = o_cfg['$l_tr'].attr('data-cbc-num');
        o_cfg['codecls'] = o_cfg['$l_tr'].attr('data-codecls');
        
        o_cfg['$r_trs'] = $('#rtabid tr');
        o_cfg['$r_tr'] = o_cfg['$r_trs'].eq(o_cfg['rowIdx']);
        return o_cfg;
    }
    
}

;function changeInput_RelayForecast(ov, tv, $this){

	if($this.attr('data-type') == 'overall'){
		sumOf_overAll();
		return;
	}
	
	var o_cfg=initTabInfo();
	
	sumOf_part(o_cfg);
	
	;function sumOf_overAll(){
		$this.val( Globalize.format(tv, 'n') );
		var total=0, $r_trs=$('#rtabid tr.trt_0'), cellIdx=$this.parent()[0].cellIndex;
		
		$r_trs.filter('.overrulerelayfctotal').each(function(){
			var v=$(this).find('td:eq('+cellIdx+') input').val();
			total += numberOfZero( $.trim(v) );
		});
		$r_trs.filter('.overrulerelayfctotalall').find('td:eq('+cellIdx+')').html( Globalize.format( total, 'n') );
	}
	
	;function sumOf_part(o_cfg){
		
		if(o_cfg['$l_trs'].filter('.trt_trt').hasClass('exp')){
    		o_cfg['$l_trs'].filter('tr.trt_0:not(.trt_trt)').each(function(){
    			o_cfg['$r_trs'].eq(this.rowIndex).addClass('dn');
    			$(this).addClass('dn');
    		});
    		o_cfg['$l_trs'].filter('tr.trt_trt').addClass('col').removeClass('exp').find('span.fcell').html('+');
    	}
		
		var codeIndex=o_cfg['$l_trs'].filter( '.rt0.'+o_cfg['codecls']).index(),
			actIndex=o_cfg['$l_trs'].filter( '.rt1.'+o_cfg['acls']+'.'+o_cfg['codecls']).index(),
			cbcIndex=o_cfg['$l_trs'].filter( '.rt2.'+o_cfg['acls']+'.'+o_cfg['codecls']+'.'+o_cfg['cbcnum']).index(),
			$cbc_cell=o_cfg['$r_trs'].eq(cbcIndex).find('td:eq('+o_cfg['cellIdx']+')'),
			$act_cell=o_cfg['$r_trs'].eq(actIndex).find('td:eq('+o_cfg['cellIdx']+')'),
			$code_cell=o_cfg['$r_trs'].eq(codeIndex).find('td:eq('+o_cfg['cellIdx']+')'),
			act_total=0, cbc_total=0, part_total=0;
			
		o_cfg['$l_trs'].filter( '.rt4.'+o_cfg['acls']+'.'+o_cfg['codecls']+'.'+o_cfg['cbcnum'] ).each(function(){
			var $this=$(this), price=numberOfZero($.trim($this.find('input.pricecls').val())),
				qty=o_cfg['$r_trs'].eq(this.rowIndex).find('td:eq('+o_cfg['cellIdx']+')').find('input').val();
			qty=numberOfZero( $.trim(qty) );
			part_total+=(qty*price);
		});
		$cbc_cell.find('input').val( Globalize.format( part_total, 'n') );
		
		o_cfg['$l_trs'].filter( '.rt2.'+o_cfg['acls']+'.'+o_cfg['codecls'] ).each(function(){
			var $this=$(this), c=o_cfg['$r_trs'].eq(this.rowIndex).find('td:eq('+o_cfg['cellIdx']+')').find('input').val();
			cbc_total+=numberOfZero( $.trim(c) );
		});
		$act_cell.html( Globalize.format( cbc_total, 'n') );

		o_cfg['$l_trs'].filter( '.rt1.'+o_cfg['codecls'] ).each(function(){
			var $this=$(this), a=o_cfg['$r_trs'].eq(this.rowIndex).find('td:eq('+o_cfg['cellIdx']+')').text();
			act_total+=numberOfZero( $.trim(a) );
		});
		$code_cell.html( Globalize.format( act_total, 'n') );
    }
    
    ;function initTabInfo(){
    	var o_cfg = {'$r_td':$this.parent(), '$l_trs': $('#ltabid tr')};
    	
    	o_cfg['$r_tr'] = o_cfg['$r_td'].parent();
        o_cfg['$r_trs'] = o_cfg['$r_tr'].parent().find('tr');
		o_cfg['$l_tr'] = o_cfg['$l_trs'].eq( o_cfg['$r_tr'].index() );
		
		o_cfg['$price'] = o_cfg['$l_tr'].find('input.pricecls');
		o_cfg['price'] = numberOfZero( $.trim(o_cfg['$price'].val()) );
        o_cfg['cellIdx'] = o_cfg['$r_td'][0].cellIndex;
        o_cfg['aid'] = o_cfg['$l_tr'].attr('data-aid');
        o_cfg['acls'] = o_cfg['$l_tr'].attr('data-aidcls');
        o_cfg['code'] = o_cfg['$l_tr'].attr('data-code');
        o_cfg['cbcnum'] = o_cfg['$l_tr'].attr('data-cbc-num');
        o_cfg['codecls'] = o_cfg['$l_tr'].attr('data-codecls');
        
        return o_cfg;
    }
	
}

;function click_RelayUnFreeze(e, $this, $span, $tr){
	$span.hide();
	
	var json=JSON.stringify({'managerId': $('#hidd_managerid').val(), 'territoryCode': $tr.attr('data-code')}),
		params={'json': json, '$this': $this, '$span': $span, '$tr': $tr};
	customRemoteAction(params, saveUnFreezeAM_js, complete_saveUnFreezeRelay); //this is remote action
}

;function click_RelayPin(e, _this, $this, $td, $tr, $body, $right_trs, rt, cls, acls, codeCls){
	var list_codes=[], interFaceName= '';
	switch(rt){
		case 'root10': 
			interFaceName='ClsAPLEntityTypes.RSMRelayTotalFCInfo';
			$body.find('tr.rt0').each(function(){
				list_codes.push(this.getAttribute('data-code'));
			});
			break;
		case 'root0': interFaceName='ClsAPLEntityTypes.RSMRelayTerritoryFCInfo'; break;
		case 'root1': interFaceName=$body.find('tr.rt0.'+codeCls).attr('data-interface'); break;
		case 'root2': interFaceName=$body.find('tr.rt1.'+acls+'.'+codeCls).attr('data-interface'); break;
	}

	createRefDataRemote($body.find(cls), interFaceName, list_codes); 
	
	;function createRefDataRemote($totalRows, interFaceName){
		var q_month={}, q_months={}, q_Future={}, q_cell={}, m_cell={}, $head_trs=$('#tab_head_list td'),
			_json={ "set_terrtoryCodes": list_codes, "acctId": $tr.attr('data-aid'), "currentYear": $('#hidd_cyear').val(), "currentMonth": $('#hidd_cmonth').val(), 
					"territoryCode": $tr.attr('data-code'), "cbc2Code": $tr.attr('data-cbc'), "list_dateKey": []
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
	    		list_month=$qCell.attr('data-months').split(','), new_params=$.extend({}, params);
	    		
	    	q_month[q]=list_month;
	    	q_cell[q]=this.cellIndex;
	    	q_months[list_month.join(',')]=this.cellIndex;
	    	for(var i=0, _month; _month=list_month[i]; i++){
		    	q_Future[_month]=isFuture;
	    	}
	    	
	    	_json['list_dateKey']=list_month;
	    	_json['currentYear']=$('#hidd_cyear').val();
	    	_json['currentMonth']=$('#hidd_cmonth').val();
	    	_json['map_year_monthsHistory']=$.parseJSON($('#hidd_maphistory').val());
	    	_json['map_year_monthsFuture']=$.parseJSON($('#hidd_mapfuture').val());
	    	
			new_params['root']=rt;
			new_params['quarterCell']=this.cellIndex;
			new_params['sMonths']=list_month.join(',');
			new_params['action']=getRefData_js;
			new_params['complete']=complete_getRelayRefData;
			
			new_params['json']='{\"className\":\"'+interFaceName+'\", \"str_json\": '+JSON.stringify(JSON.stringify(_json))+' }';

			customRemoteAction(new_params, getRefData_js, complete_getRelayRefData); //this is remote action

			th += '<td class="ref_head" style="text-align: center;">'+$qCell.find('span').text()+'</td>';
			td += '<td class="smonths" data-status="false" data-months="'+list_month.join(',')+'" style="text-align: center;"><div class="refstatus str"></div></td>';
	    });
		$td.append('<div class="refs_d"><table class="pinstatus" border="0" cellspacing="0" cellpadding="0" ><tr class="shead">'+th+'</tr><tr class="sbody">'+td+'</tr></table></div>')
		   .find('div.refs_d').off('mouseenter mouseleave').on('mouseenter mouseleave', over_refStatus_eve);
		$this.off('mouseenter mouseleave').on('mouseenter mouseleave', over_pinRefStatus_eve);
	}
	
	
}


;function clickRelayLeftTab(e, target){
	
	if(e.target.tagName.toUpperCase() == 'INPUT'){return false;}
	
	var hide='dn', list_element=[], $right_list_trs=$('#rtabid tr'), _this=target, $this=$(_this),
    	$parent=$this.parent(), $waiting = $this.find('td:first span.fcell'), $pin=$this.find('span.pin'),
    	o_cfg = {'rowIdx': _this.rowIndex, 'root': _this.getAttribute('data-root'), 'isRemote':false, 'o_cell': undefined}, 
        fn = ($this.hasClass('exp')? exp : col);

    $this.find('td:first span.reload_span').remove();
    if(o_cfg['root'] == 'root10' && $parent.find('span.readypin').length != 0){ return false; }
    if($this.hasClass('ready')){ return false; }
	
    fn();
    
    ;function exp(){
    	
    	if(isLockedData()){
    		return false;
    	}
    	
    	var code_cls='', tabCls='';
    	switch(o_cfg['root']){
    		case 'root10' : code_cls='tr.rtt0:not(.trt_trt)'; break;
    		case 'root0' : 
    			code_cls='tr:not(.rt0):not(.ttsub).'+$this.attr('data-codecls'); 
    			tabCls='a_bg c_bg p_bg';
    			break;
            case 'root1' : 
            	code_cls='tr:not(.asub):not(.rt1).'+$this.attr('data-v1')+'_cls.'+$this.attr('data-v2')+'_level2'; 
            	$this.find('td').removeClass('a_bg');
				$right_list_trs.eq(o_cfg['rowIdx']).find('td').removeClass('a_bg');
				tabCls='c_bg p_bg';
            	break;
            case 'root2' : 
            	code_cls='tr:not(.cbcsub):not(.rt2).'+$this.attr('data-v1')+'_cls.'+$this.attr('data-v2')+'_level2.'+$this.attr('data-v3')+'_level3'; 
            	$this.find('td').removeClass('c_bg');
				$right_list_trs.eq(o_cfg['rowIdx']).find('td').removeClass('c_bg');
				tabCls='p_bg';
            	break;
            case 'root3' : 
            	code_cls='tr:not(.prcodesub):not(.rt4).'+$this.attr('data-v1')+'_cls.'+$this.attr('data-v2')+'_level2.'+$this.attr('data-v3')+'_level3.'+$this.attr('data-v4')+'_level4'; 
            	$this.find('td').removeClass('p_bg');
    				$right_list_trs.eq(o_cfg['rowIdx']).find('td').removeClass('p_bg');
            	break;
    	}

    	_queueTask.push({name: o_cfg['rowIdx'], run: function(cb){
	        $parent.find(code_cls).addClass(hide).each(function(){
	            $right_list_trs.eq(this.rowIndex).addClass(hide).find('td').removeClass(tabCls);
	            $(this).removeClass('exp col').addClass('col').find('td').removeClass(tabCls)
	            		.find('span.fcell').html('+');
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
    	$waiting.addClass('waiting').html('&nbsp;');
    	
    	var remote_fn={'params':{}, 'rowIndex': o_cfg['rowIdx'], '$row': $this, 'json': {}, 'data-level': o_cfg['root'],
				'data-v1': $this.attr('data-v1'), 'data-v2': $this.attr('data-v2'), 'data-v3': $this.attr('data-v3'), 
				'data-v4': $this.attr('data-v4'), 'data-cbc-code': $this.attr('data-cbc-code'), 'data-number': $this.attr('data-number'),
				'remote':function(p){}, 'action': existAPLsObject_js, 'complete': complete_existObject
			}, find_cls='';

    	switch(o_cfg['root']){
    		case 'root10' :  //find account rows
    			find_cls = 'tr.rtt0:not(.subtotfields)';
    			sumOfAllTotal();
    			o_cfg['isRemote'] = false;
    			break;
    		case 'root0' :  //find account rows
    			remote_fn['data-v1']=$this.attr('data-code');
    			find_cls = ('tr.rt1.'+remote_fn['data-v1']+'_cls');
            	remote_fn['append'] = appendElementRelay_Level2;
            	remoteCheck(find_cls, remote_fn, createAccountJSON, WORK_RELAYCLS['level2']);
    			break;
            case 'root1' : 	//find cbc2 rows
            	find_cls = ('tr.rt2.'+remote_fn['data-v1']+'_cls.'+remote_fn['data-v2']+'_level2');
            	remote_fn['append'] = appendElementRelay_Level3;
            	remoteCheck(find_cls, remote_fn, createCBC2JSON, WORK_RELAYCLS['level3']);
            	break;
            case 'root2' : 	//find part rows
            	find_cls = ('tr.rt4.'+remote_fn['data-v3']+'_level3.'+remote_fn['data-v2']+'_level2.'+remote_fn['data-v1']+'_cls');
            	remote_fn['append'] = appendElementRelay_Level4;
            	remoteCheck(find_cls, remote_fn, createProductJSON, WORK_RELAYCLS['level4']);
            	break;
            case 'root3' : 	//find part rows
            	find_cls = ('tr.rt5.'+remote_fn['data-v4']+'_level4.'+remote_fn['data-v3']+'_level3.'+remote_fn['data-v2']+'_level2.'+remote_fn['data-v1']+'_cls');
            	remote_fn['append'] = appendElementRelay_Level5;
            	remoteCheck(find_cls, remote_fn, createPartJSON, WORK_RELAYCLS['level5']);
    	//		remoteCheck(find_cls, remote_fn, createPart_json, getAcct_js, complete_getPartRelay);
            	break;
    	}

		remote_fn['remote'](remote_fn);
		expandElement(find_cls);
		setColTabBgColor();
    }
    
    ;function sumOfAllTotal(){
    	var cell_total={}, cCell=$('#tab_head_list td.crtQtotal')[0].cellIndex-1, 
    		$relay_tds=$right_list_trs.filter('.relayfctotal').find('td');
    		
    	$parent.find('tr.rt0').each(function(){
    		$right_list_trs.eq(this.rowIndex).find('td:gt('+cCell+')').each(function(){
    			var total=getZeroOfNumber(cell_total[this.cellIndex]), v=numberOfZero($.trim(this.innerHTML));
    			cell_total[this.cellIndex] = (total+v);
    		});
    	});
    	for(var cell in cell_total){
    		$relay_tds.eq(cell).html( Globalize.format(cell_total[cell], 'n') );
    	}
    	cell_total={};
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

	;function createAccountJSON(){
		this['territoryCode']=_this.getAttribute('data-code');
		this['map_year_quartersFuture']=$.parseJSON( $('[id*=hidd_yearfutureid]').val() );
	}
	;function createCBC2JSON(){
		this['territoryCode']=_this.getAttribute('data-v1');
		this['grouping']=_this.getAttribute('data-v2');
		this['map_year_quartersFuture']=$.parseJSON( $('[id*=hidd_yearfutureid]').val() );
	}
    ;function createProductJSON(){
    	this['territoryCode']=_this.getAttribute('data-v1');
    	this['grouping']=_this.getAttribute('data-v2');
    	this['cbc2Code']=_this.getAttribute('data-cbc-code');
		this['map_year_quartersFuture']=$.parseJSON( $('[id*=hidd_yearfutureid]').val() );
    }
    ;function createPartJSON(){
    	this['territoryCode']=_this.getAttribute('data-v1');
    	this['grouping']=_this.getAttribute('data-v2');
    	this['cbc2Code']=_this.getAttribute('data-cbc-code');
    	this['accnumber']=_this.getAttribute('data-number');
		this['map_year_quartersFuture']=$.parseJSON( $('[id*=hidd_yearfutureid]').val() );
    }

    ;function isLoadedData(){
    	var codeCls=_this.getAttribute('data-codecls'), isLoaded=true;
    	switch(o_cfg['root']){
    		case 'root1' :
    			if($parent.find('tr.rt0.'+codeCls+' td:first span.waiting').length != 0 ||
    				$parent.find('tr.rt0.'+codeCls+' td:first span.reload_span').length != 0){
    				isLoaded=false;
    			}
    			break;
    		case 'root2' :
    			if($parent.find('tr.rt1.'+codeCls+' td:first span.waiting').length != 0 ||
    				$parent.find('tr.rt1.'+codeCls+' td:first span.reload_span').length != 0){
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
    ;function setForecastCellIndex(q_cell){
    	$('#tab_head_list td.qcell').each(function(){
    		q_cell[this.getAttribute('data-date')] = this.cellIndex;
    	});
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
            	$this.find('td').addClass('p_bg');
    			$right_list_trs.eq(o_cfg['rowIdx']).find('td').addClass('p_bg');
            	break;
        }
	}

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
    	var findCls=(oJson['$lRow'].attr('data-v1')+'_cls.'+oJson['$lRow'].attr('data-v2')+'_level2.'+oJson['$lRow'].attr('data-v3')+'_level3.'+oJson['$lRow'].attr('data-v4')+'_level4'),
    		$pclRow=oJson['$lRow'].parent().find('tr.rt4.'+findCls), $pcrRow=oJson['$rBody'].find('tr:eq('+$pclRow.index()+')'), 
    		pcPrice=numberOfZero($pclRow.find('input.pricecls').val()), partCellTotal={}, pcCellTotal={}, flg=false;

    	oJson['$lRow'].parent().find('tr.rt5.'+findCls).each(function(){
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
    	var findCls=(oJson['$lRow'].attr('data-v1')+'_cls.'+oJson['$lRow'].attr('data-v2')+'_level2.'+oJson['$lRow'].attr('data-v3')+'_level3'),
    		$lBody=oJson['$lRow'].parent(), $cbcLRow=$lBody.find('tr.rt2.'+findCls), $cbcRCells=oJson['$rBody'].find('tr:eq('+$cbcLRow.index()+') td'), 
    		$accLRow=$lBody.find('tr.rt1.'+oJson['$lRow'].attr('data-v1')+'_cls.'+oJson['$lRow'].attr('data-v2')+'_level2'),
    		$accRCells=oJson['$rBody'].find('tr:eq('+$accLRow.index()+') td'), 
    		$tLRow=$lBody.find('tr.rt0.'+oJson['$lRow'].attr('data-v1')+'_cls'), $tRCells=oJson['$rBody'].find('tr:eq('+$tLRow.index()+') td'),
    		productTotal={}, cbcTotal={}, accTotal={};
    		
    	
    	$lBody.find('tr.rt4.'+findCls).each(function(){	//ProductCode total
    		oJson['$rBody'].find('tr:eq('+this.rowIndex+') td:gt('+oJson['crtCell']+')').each(function(){
				productTotal[this.cellIndex]=(getZeroOfNumberRelay(productTotal[this.cellIndex])+getZeroOfNumberRelay($(this).attr('data-amount')));
    		});
    	});
    	for(var cell in productTotal){
    		$cbcRCells.eq(cell).html( Globalize.format(productTotal[cell], 'n') );
    	}
    	
    	
    	$lBody.find('tr.rt2.'+oJson['$lRow'].attr('data-v1')+'_cls.'+oJson['$lRow'].attr('data-v2')+'_level2').each(function(){ //CBC2 total
    		oJson['$rBody'].find('tr:eq('+this.rowIndex+') td:gt('+oJson['crtCell']+')').each(function(){
				cbcTotal[this.cellIndex]=(getZeroOfNumberRelay(cbcTotal[this.cellIndex])+numberOfZero($(this).html()));
    		});
    	});
    	for(var cell in cbcTotal){
    		$accRCells.eq(cell).html( Globalize.format(cbcTotal[cell], 'n') );
    	}
    	
    	
    	$lBody.find('tr.rt1.'+oJson['$lRow'].attr('data-v1')+'_cls').each(function(){ //Account total
    		oJson['$rBody'].find('tr:eq('+this.rowIndex+') td:gt('+oJson['crtCell']+')').each(function(){
				accTotal[this.cellIndex]=(getZeroOfNumberRelay(accTotal[this.cellIndex])+numberOfZero($(this).html()));
    		});
    	});
    	for(var cell in accTotal){
    		$tRCells.eq(cell).html( Globalize.format(accTotal[cell], 'n') );
    	}

    }

}

;function event_qtyInputRelay_change(e){
	var _this=this, $this=$(_this), ov='', validation_qty=/^([1-9]\d{0,16}|0)(\.\d+)?$/, 
        tv=Globalize.parseFloat($.trim(_this.value)); //focus Event
    
    ov = $this.inputFocusValueFormat(validation_qty, e);

    if(e.type == 'change'){
    	
		ov = ($.isNumeric(ov) ? ov : 0);
        tv = ($.isNumeric(tv) ? tv : 0);
    	
    	var oJson={'$lBody': $('#ltabid'), '$rCell': $this.parent(), '$rRow': $this.parent().parent(),
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
			    _this.value = Globalize.format(ov, 'n0');
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
    		$rBody.find('.trt_0:not(.trt_trt)').addClass('dn');
    	}
    	_this.value = Globalize.format(tv, 'n0');
		oJson['$rCell'].attr({'data-amount': tv*oJson['iCellPrice']});

    	checkQty(oJson, sumOfAccountTotal);
    	
    }
    
    ;function sumOfAccountTotal(oJson){
		var findCls=(oJson['$lRow'].attr('data-v1')+'_cls.'+oJson['$lRow'].attr('data-v2')+'_level2'), 
			$rBody=oJson['$rRow'].parent(), $lCbcRow=oJson['$lBody'].find( ('tr.rt2.'+findCls+'.'+oJson['$lRow'].attr('data-v3')+'_level3') ), 
			$lARow=oJson['$lBody'].find('tr.rt1.'+oJson['$lRow'].attr('data-v1')+'_cls.'+oJson['$lRow'].attr('data-v2')+'_level2'), 
			$lTRow=oJson['$lBody'].find('tr.rt0.'+oJson['$lRow'].attr('data-v1')+'_cls'),
			product_amount=0;

		oJson['$lBody'].find( ('tr.rt4.'+findCls+'.'+oJson['$lRow'].attr('data-v3')+'_level3') ).each(function(){	//Product Code
    		var $cell=$rBody.find('tr:eq('+this.rowIndex+') td:eq('+oJson['iCell']+')');
    		product_amount += getZeroOfNumberRelay($cell.attr('data-amount'));
    	});
    	$rBody.find('tr:eq('+$lCbcRow.index()+') td:eq('+oJson['iCell']+')').html( Globalize.format(product_amount, 'n') );

    	product_amount=0;
    	oJson['$lBody'].find( 'tr.rt2.'+findCls ).each(function(){	//CBC2
    		var $cell=$rBody.find('tr:eq('+this.rowIndex+') td:eq('+oJson['iCell']+')');
    		product_amount += numberOfZero($.trim($cell.html()));
    	});
		$rBody.find('tr:eq('+$lARow.index()+') td:eq('+oJson['iCell']+')').html( Globalize.format(product_amount, 'n') );
		
		product_amount=0;
    	oJson['$lBody'].find('tr.rt1.'+oJson['$lRow'].attr('data-v1')+'_cls').each(function(){	//ACCOUNT
    		var $cell=$rBody.find('tr:eq('+this.rowIndex+') td:eq('+oJson['iCell']+')');
    		product_amount += numberOfZero($.trim($cell.html()));
    	});
		$rBody.find('tr:eq('+$lTRow.index()+') td:eq('+oJson['iCell']+')').html( Globalize.format(product_amount, 'n') );
    }
    
    ;function checkQty(oJson, callBack){
    	var findCls=(oJson['$lRow'].attr('data-v1')+'_cls.'+oJson['$lRow'].attr('data-v2')+'_level2.'+oJson['$lRow'].attr('data-v3')+'_level3.'+oJson['$lRow'].attr('data-v4')+'_level4'),
    		$rBody=oJson['$rRow'].parent(), $pcLRow=oJson['$lBody'].find('tr.rt4.'+findCls), 
    		$pcRCell=$rBody.find('tr:eq('+$pcLRow.index()+') td:eq('+oJson['iCell']+')'), partCellVal={'amount': 0, 'qty': 0},
    		productCellVal={'amount': getZeroOfNumberRelay($pcRCell.attr('data-amount')), 'qty': Globalize.parseInt($pcRCell.find('input').val())};

    	oJson['$lBody'].find('tr.rt5.'+findCls).each(function(){
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
    		return;
    	}
    	callBack(oJson);
    }
    
}

;function event_qtyInputRelay_keyup(e){
	var $this=$(this), $td=$this.parent(), $tr=$td.parent(), $tbody=$tr.parent(),
        _cellIndex=$td[0].cellIndex, _rowIndex=$tr[0].rowIndex;

    if(e.shiftKey && e.keyCode == 13){  //find prve cell input
    	$td.prev().find('input[type="text"]').focus().select();
    }else if(e.keyCode == 13){  //find next cell input  	
    	$td.next().find('input[type="text"]').focus().select();
    }
}

;function event_relayRefData_click(e, target){

	var $this=$(target), $tr=$this.parent().parent().parent(), $lBody=$tr.parent(), $rBody=$('#rtabid'),
		$billing=$tr.next().next(), $booking=$billing.next(), $backlog=$booking.next(),
		remote_fn={ '$lbody': $lBody, '$rbody': $rBody,  'monthCell': {}, 'cellMonth': {}, 'json': {}, 'cls': '', 'crtCell': $('#tab_head_list td.crtQtotal')[0].cellIndex, 
			'findcls': '', 'data-v1': $tr.attr('data-v1'), 'data-v2': $tr.attr('data-v2'), 'data-v3': $tr.attr('data-v3'),
			'data-v4': $tr.attr('data-v4'), 'data-v5': $tr.attr('data-v5'), 'root': $tr.attr('data-root'), 
			'managerId': $('#hidd_managerid').val(), 'accnumber': $tr.attr('data-number'), 'cbc2Code': $tr.attr('data-cbc-code'), 
			'$billing': $billing, '$booking': $booking, '$backlog': $backlog, 'action': getAPLsRefData_js, 'actionBacklog': getBacklogRefData_js,
			'$historicalCells': $('#tab_head_list td.historicalc.qtotalCls, td.crtQtotal'), '$futureCells': $('#tab_head_list td.qtotalCls'), 
			'complete': complete_getAPLRelayRefData, 'completeBacklog': complete_getAPLRelayBacklogRefData
		}, execute=($this.hasClass('spin')? exp : col);

	switch(remote_fn['root']){
		case 'root10': 
			remote_fn['findcls']='tr.'+$tr.attr('data-tnum');
			remote_fn['$billing']=$tr.next();
			remote_fn['$booking']=remote_fn['$billing'].next();
			remote_fn['$backlog']=remote_fn['$booking'].next();
			remote_fn['cls']=WORK_RELAYCLS['leveltotal'];
			break;
		case 'root0': 
			remote_fn['data-v1']=$tr.attr('data-code');
			remote_fn['cls']=WORK_RELAYCLS['level1'];
			remote_fn['findcls']='tr.ttsub.'+remote_fn['data-v1']+'_cls';
			break;
		case 'root1': 
			remote_fn['cls']=WORK_RELAYCLS['level2'];
			remote_fn['$billing']=$tr.next().next().next().next().next();
			remote_fn['$booking']=remote_fn['$billing'].next();
			remote_fn['$backlog']=remote_fn['$booking'].next();
			remote_fn['findcls']='tr.asub.'+remote_fn['data-v1']+'_cls.'+remote_fn['data-v2']+'_level2';
			break;
		case 'root2': 
			remote_fn['cls']=WORK_RELAYCLS['level3'];
			remote_fn['findcls']=('tr.cbcsub.'+remote_fn['data-v1']+'_cls.'+remote_fn['data-v2']+'_level2.'+remote_fn['data-v3']+'_level3');
			break;
		case 'root3': 
			remote_fn['$billing']=$tr.next().next().next();
			remote_fn['$booking']=remote_fn['$billing'].next();
			remote_fn['$backlog']=remote_fn['$booking'].next();
			remote_fn['cls']=WORK_RELAYCLS['level4'];
			remote_fn['findcls']=('tr.'+remote_fn['data-v1']+'_cls.'+remote_fn['data-v2']+'_level2.'+
								remote_fn['data-v3']+'_level3.'+remote_fn['data-v4']+'_level4');
			break;
		case 'root4': 
			remote_fn['$billing']=$tr.next().next().next();
			remote_fn['$booking']=remote_fn['$billing'].next();
			remote_fn['$backlog']=remote_fn['$booking'].next();
			remote_fn['cls']=WORK_RELAYCLS['level5'];
			remote_fn['findcls']=('tr.partsub.'+remote_fn['data-v1']+'_cls.'+remote_fn['data-v2']+'_level2.'+
								remote_fn['data-v3']+'_level3.'+remote_fn['data-v4']+'_level4.'+remote_fn['data-v5']+'_level5'); 
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
	//	if(remote_fn['root'] == 'root4'){ $this.html('-'); }
	}
	
	
	;function col(){
		$lBody.find(remote_fn['findcls']).addClass('dn').each(function(){
			$rBody.find('tr:eq('+this.rowIndex+')').addClass('dn');
		});
		$this.addClass('spin')
	//	if(remote_fn['root'] == 'root4'){ $this.html('+'); }
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
			attr_tmp['json'] = {'set_fiscalMonth': list_q, 'territoryCode': remote_fn['data-v1'], 'grouping': remote_fn['data-v2'], 'cbc2Code': remote_fn['cbc2Code'],
								'accnumber': remote_fn['accnumber'], 'partId': attr_tmp['data-v5'], 'managerId': remote_fn['managerId'] };
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
			attr_tmp['json'] = {'set_fiscalMonth': list_q, 'territoryCode': remote_fn['data-v1'], 'grouping': remote_fn['data-v2'], 'cbc2Code': remote_fn['cbc2Code'],
								'accnumber': remote_fn['accnumber'], 'partId': attr_tmp['data-v5'], 'managerId': remote_fn['managerId'] };
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
	
}
;function event_reloadExistData_click(e, $this){
	var _data = e.data.$data;
	rowUnLock(_data['rowIndex']);
    customMultipleRemoteAction(_data, _data['action'], _data['complete']);
    $this.remove();
}
;function complete_getAPLRelayRefData(result, event, data){
	
	_queueTask.push({name: data['level'], run: function(cb){
		
		var $status_cell=data['$billing'].find('td:first b.ref_box[data-months="'+data['smonths']+'"]').eq(0);
		if(event.status){
			result = $.parseJSON(result);

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
    			);
    		//	$cell.eq(monthCell[r]).attr({'data-old': refData[r]}).html( Globalize.format(refData[r], 'n') );
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
   // 	$qCell.html( Globalize.format((q1+q2+q3), 'n') );
    }
    
    ;function reLoadRefData($status_cell, data){
    	data['$billing'].find('span.reloadRef').show().off('click').on('click', function(e){
    		e.stopPropagation();
			$(this).hide().off('click');
			data['$billing'].find('span.ref_box').click();
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

;function complete_getAPLRelayBacklogRefData(result, event, data){
	
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
	    	/*
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
	    	*/
    	}else{
    		for(var r in refData){ 
	    		qtyTotal += refQty[r];
	    		total += refData[r]; 
    		}
	    	$cell.eq(cellIdx).html( 
	    		'<div>'+Globalize.format(qtyTotal, 'n0')+'</div><div style="background-color: rgb(179, 225, 254);">'+Globalize.format(total, 'n')+'</div>'
	    	);
	    	/*
	    	for(var r in refData){ total += refData[r]; }
	    	$cell.eq(cellIdx).html( Globalize.format(total, 'n') );
	    	*/
    	}
    	
    }
    
    ;function reLoadRefData($status_cell, data){
    	data['$backlog'].find('span.reloadRef').show().off('click').on('click', function(e){
    		e.stopPropagation();
			$(this).hide().off('click');
			data['$backlog'].find('span.ref_box').click();
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

;function complete_remoteResultCheck(result, data, queueComplete, appendCallBack, appendCallBackEND){

	data['list_result'] = $.parseJSON(result);

    if(data['list_result'].length == 0){ 
        rowUnLock(data['rowIndex']);//rowIndex
        data['$row'].removeClass('ready').addClass('done').find('td:first span.fcell').html('-').removeClass('waiting');
        queueComplete(null);
        return;
    }
    setTemplateElementRelay(data);
    appendCallBack(data, queueComplete, appendCallBackEND);
}

;function complete_appendElementEND(queueComplete, _data){
	rowUnLock(_data['rowIndex']);
	_data['$row'].removeClass('ready').addClass('done').find('td:first span.fcell').html('-').removeClass('waiting');
	queueComplete(null); 
}

;function complete_errorReload(data, event, callBack){

	var el_reload = '<span class="reload_span reload_spanfix"><span class="reload_img fixreload"></span><b class="reload_msg reload_msg_relayfix" >'+event['message']+'</b></span>';
    data['$row'].removeClass('ready done').find('td:first span.waiting.fcell').before(el_reload)
            .parent().find('span.reload_span').off('click').on('click', {$data: data}, function(e){
            	e.stopPropagation();
            	callBack(e, $(this));
            });
    rowUnLock(data['rowIndex']);
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

;function complete_saveUnFreezeRelay(result, event, data){
	if(event.status){
    	data['$this'].off('click');
    	data['$span'].remove();
    }else{
    	alert(event['message']);
    	data['$span'].show();
    }
}

;function complete_OverAllRelayFC(result, event, data){ 

    if(event.status){
        _queueTask.push({name: data['rowIndex'], run: function(cb){
        	matchOverAllCell(result, data, cb);
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
	    					customRemoteAction(data, getAcct_js, complete_OverAllRelayFC); //this is total remote action
    					}
    				});
    	
    }
    
    ;function matchOverAllCell(result, data, queueTaskCallBack){
    	result = $.parseJSON(result);	//map_dateKey_fc
    	
    	var overall_total={}, overallfrozen = $('#hidd_overallfrozen').val();
    	
		while(result.length > 0){
			var overAll = result.shift(), $o_tds=data['$r_tds'].filter('[data-overall-name="'+overAll['name']+'"]').find('td');
			for(var r in overAll['map_dateKey_fc']){
				var t=getZeroOfNumber( overall_total[data['cell'][r]] );
	    		$o_tds.eq(data['cell'][r]).html('<input value="'+Globalize.format(overAll['map_dateKey_fc'][r], 'n')+'" data-type="overall" type="text" class="inputcls" />');
	    		overall_total[data['cell'][r]]=(t+overAll['map_dateKey_fc'][r]);
	    	}
		}

		for(var cell in overall_total){
			data['$r_oall_tds'].eq(cell).html( Globalize.format(overall_total[cell], 'n') );
		}
		data['$r_tds'].find('input').on('focus change', input_fc_eve).on('keyup', input_keyup_eve);

		if(overallfrozen == 'true' || overallfrozen == true){
			$('#rtabid tr.overrulerelayfctotal input').attr('disabled', true);
		}
		
    	queueTaskCallBack(null);
    	data['$row'].find('span.waitingtcode').remove();
    }
}

;function complete_RelayTotalCycleFC(result, event, data){

	if(event.status){
        _queueTask.push({name: data['$row'].index(), run: function(cb){
        	result = $.parseJSON(result);
        	setCycelReslut(result['currentFC'], data['$currentCycle'].find('td'));
        	setCycelReslut(result['previousFC'], data['$prevCycle'].find('td'));
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
	    					customRemoteAction(data, getAcct_js, complete_RelayTotalCycleFC); //this is total remote action
    					}
    				});
    	
    }
    
    ;function setCycelReslut(oResult, $tds){
    	for(var o in oResult){
    		$tds.eq(data['qCell'][o]).html( Globalize.format(oResult[o], 'n') );
    	}
    }
}

;function complete_getAcctRelay(result, event, data){ 
	scroll_event();
	if(event.status){
        _queueTask.push({name: data['rowIndex'], run: function(cb){
        	matchAcctFC_Element(result, data, cb);
        }}, function(err){ });
    }else{
        addReloadButton(data, event, reloadAcctRelay_eve);
    }
    
    ;function matchAcctFC_Element(result, data, queueTaskCallBack){
    	var $actRow_left=$('#acctab tbody tr').clone(), $actRow_right=$('#acctab tfoot tr').clone(),
    		$cbcRow_left=$('#cbctab tbody tr').clone(), $cbcRow_right=$('#cbctab tfoot tr').clone(),
    		$right_row=$('#rtabid tr:eq('+data['$lastRow'].index()+')');
    		
        result = complete_resultRelayCheck(result, data);

        if(result.length == 0){ 
            queueTaskCallBack(null); 
            return; 
        }
		registerEvent($actRow_left, $actRow_right, $cbcRow_left, $cbcRow_right);
		hideForecastHead($actRow_right);
		hideForecastHead($cbcRow_right);
		
        asyncEachSeries_Original(result, function(item, callback){
        	var $actRow_left_clone=$actRow_left.clone(true), $actRow_right_clone=$actRow_right.clone(true),
        		$cbc_left_clone=$cbcRow_left.clone(true), $cbc_right_clone=$cbcRow_right.clone(true),
        		aid=item['acctId'], addcls=(data['codecls']+' '+aid+'_cls '), count=0, attr={
        			'data-aid': aid, 'data-aidcls': aid+'_cls', 'data-code': data['code'], 'data-codecls': data['codecls']
        		};
			
        	data['$lastRow'].after($actRow_left_clone);
        	$right_row.after($actRow_right_clone);
        	$actRow_left_clone.last().after($cbc_left_clone);
        	$actRow_right_clone.last().after($cbc_right_clone);	
        		
        	formatFC(false, item['currentFC'], $actRow_right_clone.filter('.currentFC').find('td'), data['q_cell'], '');
        	formatFC(false, item['previousFC'], $actRow_right_clone.filter('.previousFC').find('td'), data['q_cell'], '');
        	formatFC(false, item['amFC'], $actRow_right_clone.filter('.amFC').find('td'), data['q_cell'], '');
        	formatFC(true, item['posFC'], $actRow_right_clone.filter('.posFC').find('td'), data['q_cell'], 'pos');
        	formatFC(true, item['cmaFC'], $actRow_right_clone.filter('.cmaFC').find('td'), data['q_cell'], 'cma');

        	$cbc_left_clone.addClass(addcls).filter('.rt2').attr(attr).attr({'data-root': 'root2'})
        				.each(function(){
        					var $cbc=$(this), t=(aid+'_'+count+'_cbc');
        					$cbc_left_clone.filter(':not(.rt2).'+$cbc.attr('data-cbc-num')).addClass(t);
        					$cbc.attr('data-cbc-num', t).addClass(t);
        					count++;
        				});
        	
        	attr['data-interface']=item['rsmRelayTypeName'];
        	$actRow_left_clone.addClass(addcls).eq(0).attr(attr).attr('data-root', 'root1').find('span.scell').text(item['fieldName']);

        	$actRow_right_clone.find('input').find('input[type="text"]').on('focus change', input_fc_eve).on('keyup', input_keyup_eve);
        	
        }, function(err){
			complete_remoteStatus(data, queueTaskCallBack);
        }, 320);
    }
    
    ;function registerEvent($actRow_left, $actRow_right, $cbcRow_left, $cbcRow_right){
        $cbcRow_right.on('mouseenter mouseleave', overTable_eve);
        $cbcRow_left.on('mouseenter mouseleave', overTable_eve);
        $actRow_left.on('mouseenter mouseleave', overTable_eve).eq(0)
        			.on('click', {$divbody: $('#div_body')}, clickLeftTable_eve)
					.find('span.pin').on('click', clickLeftPin_eve);
        $actRow_right.on('mouseenter mouseleave', overTable_eve).find('input').on('focus change', input_fc_eve).on('keyup', input_keyup_eve);
    }
    
}

;function complete_getCBC2Relay(result, event, data){ 
	scroll_event();
	if(event.status){
        _queueTask.push({name: data['rowIndex'], run: function(cb){
        	matchCBC2FC_Element(result, data, cb);
        }}, function(err){ });
    }else{
        addReloadButton(data, event, reloadCBC2Relay_eve);
    }
    
    ;function matchCBC2FC_Element(result, data, queueTaskCallBack){
    	var $acct_rtrs=$('#rtabid tr'), $acct_lbody=data.$row.parent();
    		
        result = complete_resultRelayCheck(result, data);

        if(result.length == 0){ 
            queueTaskCallBack(null); 
            return; 
        }
        asyncEachSeries_Original(result, function(item, callback){
        	var $cbcRow=data['$cbcRows'].filter( '.rt2.'+item['fieldName'] ), code=$cbcRow.attr('data-cbc'),
        		_cls=( 'tr.cbcsub.'+data['aid']+'_cls.'+data['codecls']+'.'+$cbcRow.attr('data-cbc-num') ),
				$acctRows=$acct_lbody.find(_cls);
        	$cbcRow.attr('data-interface', item['rsmRelayTypeName'])
					.on('click', {$divbody: $('#div_body')}, clickLeftTable_eve).find('span.pin')
					.on('click', clickLeftPin_eve);
        	formatFC(true, item['currentFC'], $acct_rtrs.eq($cbcRow.index()).find('td'), data['q_cell'], 'cbc2');
        	formatFC(false, item['previousFC'], $acct_rtrs.eq($acctRows.filter('.previousFC').index()).find('td'), data['q_cell'], '');
        	formatFC(false, item['amFC'], $acct_rtrs.eq($acctRows.filter('.amFC').index()).find('td'), data['q_cell'], '');
        	
        }, function(err){
			complete_remoteStatus(data, queueTaskCallBack);
        }, 320);
    }
}

;function complete_getPartRelay(result, event, data){ 
	if(event.status){
		_queueTask.push({name: data['rowIndex'], run: function(cb){
			matchPartFC_Element(result, data, cb);
		}}, function(err){ });
    }else{
        addReloadButton(data, event, reloadPartRelay_eve);
    }
    
    ;function matchPartFC_Element(result, data, queueTaskCallBack){
    	result = complete_resultRelayCheck(result, data);

        if(result.length == 0){ 
            queueTaskCallBack(null); 
            return; 
        }
        complete_partReslutRelay(result, data, queueTaskCallBack, data['$partBacklogRow'], true);
    }
}

;function complete_partReslutRelay(result, data, queueTaskCallBack, $backlogRow, isGpl){
	var $part=$('#parttab'), $left_part=$part.find('tbody tr').clone(), $right_part=$part.find('tfoot tr').clone(), 
		$all_tab=$('#div_body tbody.overbody'), $append_right=$all_tab.filter('.rtbodycls').find('tr:eq('+$backlogRow.index()+')'),
		point='n'+$('#hidd_price').val();
	
	registerEvent($left_part, $right_part);
	hideForecastHead($right_part);
	createDataMonths(data)
	
	var isFrezeen=data['$row'].parent().find( ('tr.rt0.'+data['code']+'_cls') ).find('input.unfreeze').length;
	
	asyncEachSeries_Original(result, function(item, callback){
    	var $l_clone=$left_part.clone(true), $r_clone=$right_part.clone(true);
    	$l_clone.addClass( (item['partId']+'_part '+data['code']+'_cls '+data['aid']+'_cls '+data['dataNum']) );
    	$l_clone.eq(0).attr({'data-gid': item['gplId'], 'data-root': 'root4', 'data-pid': item['partId'], 'data-code': data['code'], 
    						 'data-codecls': data['code']+'_cls', 'data-aid': data['aid'], 'title': item['partDesc'],
							 'data-aidcls': data['aid']+'_cls', 'data-cbc': data['cbc'], 'data-cbc-num': data['dataNum']})
    				.find('td:first span.scell').html( item['fieldName']);
    	
    	matchFormatFCResult(item['currentFC'], item['previousFC'], item['amFC'], data['q_cell'], $r_clone.eq(0).find('td'), 
    						$r_clone.filter('.previousFC').find('td'), $r_clone.filter('.amFC').find('td'), $l_clone.eq(0).find('input[type="text"].pricecls'), point, 'part');
		
    	matchPartRefData(data, item['backlog'], $r_clone.filter('.backlog').find('td'));					
    	matchPartRefData(data, item['billing'], $r_clone.filter('.billing').find('td'));					
    	matchPartRefData(data, item['booking'], $r_clone.filter('.booking').find('td'));					
    	
		var $inputs = $r_clone.eq(0).find('input[type="text"]').on('focus change', input_fc_eve).on('keyup', input_keyup_eve);
    	
    	if(isFrezeen == 0){
    		$inputs.attr('disabled', true);
    		$l_clone.find('input[type="text"]').attr('disabled', true);
    	}
		
    	$backlogRow.after($l_clone);
    	$append_right.after($r_clone);
    	
    }, function(err){
		complete_remoteStatus(data, queueTaskCallBack);
    }, 120);
    
    ;function registerEvent($partRow_left, $partRow_right){
        $partRow_right.on('mouseenter mouseleave', overTable_eve);
        $partRow_left.on('mouseenter mouseleave', overTable_eve)
        			 .eq(0).on('click', {$divbody: $('#div_body')}, clickLeftTable_eve)
					 .find('td:last').on('mouseenter mouseleave', overPriceTab_relay_eve)
					 .append('<input type="text" value="" class="zidxInput pricecls" style="margin-left: -20px;" />')
					 .find('input').on('focus change click', input_price_eve);
    }
    
	;function matchFormatFCResult(current_fc, previou_fc, am_fc, o_cell, $current_fc, $previou_fc, $am_fc, $input_price, point){

		for(var fc in current_fc){	//quantity
			var cFc=$.parseJSON(current_fc[fc]);
			$input_price.val( Globalize.format(cFc['price'], point) );
			$current_fc.eq(o_cell[fc]).html('<input type="text" class="inputcls " '+
											' value="'+Globalize.format(cFc['quantity'], 'n0')+'"/>');
	    }
	    for(var p in previou_fc){
	    	var pFc=$.parseJSON(previou_fc[p]);
			$previou_fc.eq(o_cell[p]).html(Globalize.format(pFc['quantity'], 'n0'));
	    }

	    for(var am in am_fc){
			$am_fc.eq(o_cell[am]).html(Globalize.format(am_fc[am], 'n'));
	    }
	}
	
	;function matchPartRefData(data, refData, $r_tds){
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
	
	;function createDataMonths(data){
		var $head_tds=$('#tab_head_list td'), q_month={}, q_months={}, q_Future={}, q_cell={}, m_cell={};
		
		data['qCell'] = q_cell;
		data['mCell'] = m_cell;
		data['qMonth'] = q_month;
		data['qFuture'] = q_Future;
		data['qMonths'] = q_months;
		data['currentCell']=$head_tds.filter('.crtQtotal')[0].cellIndex+1;
		$head_tds.filter('.monthCls').each(function(){
			m_cell[this.getAttribute('data-month')]=this.cellIndex;
		});	
		
		$head_tds.filter('.qtotalCls').each(function(){
	    	var $qCell=$(this), isFuture=$qCell.hasClass('futurec1'), q=$qCell.attr('data-date'),
	    		list_month=$qCell.attr('data-months').split(',');
	    		
	    	q_month[q]=list_month;
	    	q_cell[q]=this.cellIndex;
	    	q_months[list_month.join(',')]=this.cellIndex;
	    	
	    	for(var i=0, _month; _month=list_month[i]; i++){
		    	q_Future[_month]=isFuture;
	    	}
	    });
	}
	
}

;function complete_resultRelayCheck(result, data){
	result = $.parseJSON(result);
    if(result.length == 0){ 
        rowUnLock(data['rowIndex']);
        data.$row.removeClass('ready').addClass('done').find('td:first span.fcell').html('-').removeClass('waiting');
        return []; 
    }
    return result;
}


;function complete_getRelayRefData(result, event, data){
	
	var $status_cell=data['$td'].find('table.pinstatus td.smonths[data-months="'+data['sMonths']+'"]');
	if(event.status){	
		_queueTask.push({name: data['sMonths'], run: function(cb){
			var bookingFieldName=(data['root'] == 'root0' || data['root'] == 'root1' || data['root'] == 'root10' ? 'totalBooking' : 'booking'),
				billingFieldName=(data['root'] == 'root0' || data['root'] == 'root1' || data['root'] == 'root10' ? 'totalBilling' : 'billing'),
				backlogFieldName=(data['root'] == 'root0' || data['root'] == 'root1' || data['root'] == 'root10' ? 'totalBacklog' : 'backlog'),
				$bookingCell=data['$rRow'].eq(data['$totalRow'].filter( ('.'+bookingFieldName) ).index()).find('td'),
				$billingCell=data['$rRow'].eq(data['$totalRow'].filter( ('.'+billingFieldName) ).index()).find('td'),
				$backlogCell=data['$rRow'].eq(data['$totalRow'].filter( ('.'+backlogFieldName) ).index()).find('td');
			
			result = $.parseJSON(result);
			
			matchRefData(data, result[bookingFieldName], $bookingCell);
			matchRefData(data, result[billingFieldName], $billingCell);
			matchRefData(data, result[backlogFieldName], $backlogCell);
			complete_finallyRelayRefData(data, $status_cell, cb);
    	}}, function(err){ });	
    	
    }else{
		complete_finallyErrorRelayRefData(data, event, $status_cell);
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



;function complete_finallyRelayRefData(data, $status_cell, cb){

	$status_cell.attr('data-status', 'true').find('div').animate({backgroundColor: '#51C957'}, 130);

	if(data['$td'].find('table.pinstatus td.smonths[data-status="false"]').length == 0){
		data['$td'].find('div.refs_d').remove();
    	data['$pin'].off('mouseenter mouseleave').removeClass('readypin waitingpin').addClass('donepin');
	}
	cb(null);

}

;function complete_finallyErrorRelayRefData(data, event, $status_cell){

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

;function complete_saveRelayForecast(result, event, data){
	var isError = false;
	
	if(event.status){
		isError=false;
    }else{
    	isError=true;
    	data['msg'] = event;
    	SAVE_ERRORS.push(data);
    }
    
    _queueTask.push({name: (data['data']['$bar'].progressbar("value") || 0), run: function(cb){
	    var percent=parseFloat(data['data']['$bar'].attr('data-value')), max=data['data']['max'];
	    
	    percent = ($.isNumeric(percent) ? percent : 0), 
	    percent = (data['data']['percent']+percent);

	    max = (Math.round(percent) >= data['data']['max'] ? 100 : percent);
		data['data']['$bar'].attr('data-value', percent).progressbar("value", max).find('div.progress-label').html(max+'%');
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

;function complete_saveRSMForecastRelay(result, event, data){
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
		oData={ 'map_year_quartersFuture': $.parseJSON($('#hidd_yearfutureid').val()),
				'oCell': {}, 'crtCell': $('#tab_head_list td.crtQtotal')[0].cellIndex-1
		}, list_save=[];
	
	$('#tab_head_list td.qcell').each(function(){
		oData['oCell'][this.cellIndex]=this.getAttribute('data-date');
	});
	
	setProductCode(list_save, $lBody, $rBody, oData);
	setPart(list_save, $lBody, $rBody, oData);
	setOverAllProduct(list_save, $lBody, $rBody, oData);
	
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

	var pBarSetting=getProgressSetting(list_save);
	
	$pBar.progressbar({ max: pBarSetting['max'], change: pBarChange, complete: pBarComplete })
		 .find('.ui-progressbar-value').css({ "background": ('#'+pBarSetting['bgcolor']) });
				
	asyncEachSeries_Original(list_save, function(item, callback){
		item['data']['percent'] = pBarSetting['percent'];
		item['data']['max'] = pBarSetting['max'];
		item['data']['$bar']=$pBar;
		item['json']=JSON.stringify(item['json']);
		customMultipleRemoteAction(item, item['action'], item['complete']);
    }, function(err){ }, 180);
    
	$('#progresserror').css({'background':pBarSetting['rbga'], 'top':'-120%'}).animate({top: '10%'}, 360, animateComplete);

	/*
	var list_save=[], o_cell={}, map_year_quartersFuture=getQuarterFuture(), 
		$l_trs=$('#ltabid tr'), $r_trs=$('#rtabid tr'), $pBar=$("#progressbar").progressbar({ value: false }).attr('data-value', 0);		
	
	$('#tab_head_list td.qcell').each(function(){
		o_cell[this.cellIndex]=this.getAttribute('data-date');
	});
	
	findForecastCBC2(list_save);
	findOverAll(list_save);

	if(list_save.length == 0){ 
		document.getElementById('saveProgressCover').style.display = 'none'; return; 
	}
	
	var pBarSetting=getProgressSetting(list_save);
	
	$pBar.progressbar({ max: pBarSetting['max'], change: pBarChange, complete: pBarComplete })
		 .find('.ui-progressbar-value').css({ "background": ('#'+pBarSetting['bgcolor']) });
				
	asyncEachSeries_Original(list_save, function(item, callback){
		item['data']['percent'] = pBarSetting['percent'];
		item['data']['max'] = pBarSetting['max'];
		item['call']=complete_saveRelayForecast;
        customRemoteAction(item, saveForecast_js, complete_saveRelayForecast); //this is remote action
    }, function(err){ }, 180);
    
	$('#progresserror').css({'background':pBarSetting['rbga'], 'top':'-120%'}).animate({top: '10%'}, 360, animateComplete);
*/
	
	/* START save forecast Helper methods*/
	
	;function setOverAllProduct(list_save, $lBody, $rBody, oData){
		
		var cfg={'managerId': $('#hidd_managerid').val(), 'set_rsmIds': $.parseJSON($('#hidd_relayidsid').val()),
			'set_displayNames': $.parseJSON($('#hidd_rsmrelaydisplaynames').val())
		};

		$rBody.find('.overrulerelayfctotal').each(function(){
			var $this=$(this), _name=$this.attr('data-overall-name'), map_name={}, map_dateKey_fc={},
				o={'json': {'managerId': cfg['managerId'], 'set_rsmIds': cfg['set_rsmIds'], 'set_displayNames': cfg['set_displayNames'],
							'map_year_quartersFuture': oData['map_year_quartersFuture'], 'map_name_map_dateKey_fc': map_name
							},
					'data': {'percent': 0, 'max': 0, 'name': _name},
					'cls': WORK_RELAYCLS['leveltotal'], 'action': saveAPLsObject_js, 'complete': complete_saveRSMForecastRelay
				};
			map_name[_name]=map_dateKey_fc;
			$rBody.find('tr:eq('+this.rowIndex+') td:gt('+oData['crtCell']+')').each(function(){
				var key=oData['oCell'][this.cellIndex];
				map_dateKey_fc[key]=Globalize.parseFloat( $.trim($(this).find('input').val()) );
			});
			list_save.push(o);
		});
	}
	
	;function setProductCode(list_save, $lBody, $rBody, oData){

		$lBody.find('tr.rt4').each(function(){
			var $this=$(this), price=Globalize.parseFloat( $.trim($this.find('input.pricecls').val()) ),
				o={'json': {'territoryCode': $this.attr('data-v1'), 'grouping': $this.attr('data-v2'), 'cbc2Code': $this.attr('data-cbc-code'), 
							'productname': $this.attr('data-name'), 'productcode': $this.attr('data-number'), 'price': price,
							'map_year_quartersFuture': oData['map_year_quartersFuture'], 'map_datekey_csFC': {}
							},
					'data': {'percent': 0, 'max': 0, 'name': $this.find('span.cellbox.scell').html()},
					'cls': WORK_RELAYCLS['level4'], 'action': saveAPLsObject_js, 'complete': complete_saveRSMForecastRelay
				};
			$rBody.find('tr:eq('+this.rowIndex+') td:gt('+oData['crtCell']+')').each(function(){
				var key=oData['oCell'][this.cellIndex];
				o['json']['map_datekey_csFC'][key] = Globalize.parseFloat( $.trim($(this).find('input').val()) );
			});
			list_save.push(o);
		});
	}
	
	
	;function setPart(list_save, $lBody, $rBody, oData){
		$lBody.find('tr.rt5').each(function(){
			var $this=$(this), price=Globalize.parseFloat( $.trim($this.find('input.pricecls').val()) ),
				o={'json': {'territoryCode': $this.attr('data-v1'), 'grouping': $this.attr('data-v2'), 'cbc2Code': $this.attr('data-cbc-code'), 
							'partId': $this.attr('data-v5'), 'price': price, 
							'map_year_quartersFuture': oData['map_year_quartersFuture'], 'map_datekey_csFC': {}
							},
					'data': {'percent': 0, 'max': 0, 'name': $this.find('span.cellbox.scell').html()},
					'cls': WORK_RELAYCLS['level5'], 'action': saveAPLsObject_js, 'complete': complete_saveRSMForecastRelay
				};

			$rBody.find('tr:eq('+this.rowIndex+') td:gt('+oData['crtCell']+')').each(function(){
				var key=oData['oCell'][this.cellIndex];
				o['json']['map_datekey_csFC'][key] = Globalize.parseFloat( $.trim($(this).find('input').val()) );
			});
			list_save.push(o);
		});
	}
	
	;function getProgressSetting(list_save){
		var o = {'percent': (1/list_save.length*100), 'bgcolor': Math.floor(Math.random()*16777215).toString(16)};
		o['max'] = Math.floor(o['percent']*list_save.length);
		o['listrbga']=$.Color('#'+o['bgcolor'])._rgba;
		o['rbga']=( 'rgba('+o['listrbga'][0]+','+o['listrbga'][1]+','+o['listrbga'][2]+',0.3)' );
		return o;
	}
	
	;function animateComplete(){
		$('#prg_total').html(list_save.length);
		$('#prg_scues').html(0);
		$('#prg_err').html(0);
	}
	
	;function findOverAll(list_svae){
		$r_trs.filter('.overrulerelayfctotal').each(function(){
			var $this=$(this), json_map={}, name_map={}, $tds=$this.find('td'),
				json_act={'className': 'ClsAPLEntityTypes.RSMRelayOverRallInfo', 'str_json': {}};
			
			for(var o in o_cell){
				var total=$.trim($tds.eq(o).find('input').val());
				json_map[o_cell[o]] = numberOfZero(total);
			}
			
			name_map[$this.attr('data-disname')]=json_map;
			
			json_act['str_json']=create_overall_josn(name_map, map_year_quartersFuture);
			
			list_save.push( {'json': JSON.stringify(json_act), 'data': {'json': json_act, '$bar': $pBar, 'name': $(this).attr('data-overall-name')}} );
		});
	}
	
	;function findForecastCBC2(list_save){
		$l_trs.filter('.rt2').each(function(){
			var $this=$(this), json_map={}, list_part=[], aid=$this.attr('data-aid'), cbcCode=$this.attr('data-cbc'),
				tCode=$this.attr('data-code'), cbcNum=$this.attr('data-cbc-num'), $tds=$r_trs.eq(this.rowIndex).find('td'),
				json_act={'className': 'ClsAPLEntityTypes.RSMRelayCBCFCInfo', 'str_json': {}};
			
			if($l_trs.filter('.rt0.'+$this.attr('data-codecls')).find('input.unfreeze').length == 0){
				return true;	//continue for each.
			}	
				
			setFcValues(json_map, $tds);
			set_CBC2_Part($l_trs, aid, cbcNum, cbcCode, tCode, list_part);

			json_act['str_json']=create_josn(tCode, aid, cbcCode, list_part, map_year_quartersFuture);

			list_save.push( {'json': JSON.stringify(json_act), 'data': {'json': json_act, '$bar': $pBar, 'name': $(this).find('span.cbc_cell').text()}} );
		});
	}

	;function set_CBC2_Part($left_parts, aid, cbcNum, cbcCode, tCode, list_part){

		var list_parts=$left_parts.filter('.rt4.'+tCode+'_cls.'+aid+'_cls.'+cbcNum).toArray();
		while(list_parts.length > 0){
			var json_map={}, str_json={}, _part=list_parts.shift(), $part=$(_part), price=$part.find('input[type="text"]').val(),
				pid=$part.attr('data-pid'), gid=$part.attr('data-gid'), $tds=$r_trs.eq(_part.rowIndex).find('td'),
				isoCode=$part.parent().find('tr.rt1.'+aid+'_cls').attr('data-isocode');

			setPartFcValues(json_map, $tds, numberOfZero(price));
			str_json=create_part_josn(tCode,aid, cbcCode, pid, gid, json_map, map_year_quartersFuture);
			list_part.push(str_json);
		}
	}
	
	;function getQuarterFuture(){ return $.trim($('[id*=hidd_yearfutureid]').val()); }

	;function setFcValues(json_map, $tds){
		for(var o in o_cell){
			var total=$.trim($tds.eq(o).find('input').val());
			json_map[o_cell[o]] = {'total' : numberOfZero(total)};
		}
	}
	;function setPartFcValues(json_map, $tds, price){
		for(var o in o_cell){
			var qty=$.trim($tds.eq(o).find('input').val());
			json_map[o_cell[o]] = {'amount' : numberOfZero(qty), 'price': price, 'total': (qty*price)};
		}
	}
	;function create_overall_josn(j_map, map_qf){
		return '{ "managerId": "'+$('#hidd_managerid').val()+'", "map_name_map_dateKey_fc": '+JSON.stringify(j_map)+', '+
				' "set_rsmIds": '+$('#hidd_relayidsid').val()+', "set_displayNames": '+$('#hidd_rsmrelaydisplaynames').val()+', "map_year_quartersFuture": '+map_qf+' }';
	}
	
	;function create_josn(territoryCode, aid, cbcCode, list_part, map_qf){
		return '{ "territoryCode": "'+territoryCode+'", "parentId": "'+aid+'", "cbc2Code": "'+cbcCode+'", '+
				' "list_partFC": ['+list_part.join(',')+'], "map_year_quartersFuture": '+map_qf+' }';
	}
	;function create_part_josn(territoryCode, aid, cbcCode, partId, gid, j_map, map_qf){
		return '{ "territoryCode": "'+territoryCode+'", "parentId": "'+aid+'", "cbc2Code": "'+cbcCode+'", '+
				' "gplId": "'+gid+'", "partId": "'+partId+ '", "map_dateKey_relayFC": '+JSON.stringify(j_map)+', '+
				' "map_year_quartersFuture": '+map_qf+'}';
	}
	/* END save forecast Helper methods*/
	
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

;function reloadAcctRelay_eve(e){
    reload_public_eve(e, this, getAcct_js, complete_getAcctRelay); //this account remote action
}
;function reloadCBC2Relay_eve(e){
    reload_public_eve(e, this, getAcct_js, complete_getCBC2Relay); //this account cbc2 action
}
;function reloadPartRelay_eve(e){
    reload_public_eve(e, this, getAcct_js, complete_getPartRelay); //this account part action
}

;function setTemplateElementRelay(data){
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

	switch(data['data-level']){
		case 'root0' : 
			data['$left'] = data['$row'].next().next().next().next();
			data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');
			data['$left_template'] = $('#acctab tbody tr').clone();
			data['$right_template'] = $('#acctab tfoot tr').clone();
			break;
		case 'root1' : 
			data['$left'] = data['$row'].next().next().next().next().next().next().next().next().next().next().next();
			data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');
			data['$left_template'] = $('#cbctab tbody tr').clone();
			data['$right_template'] = $('#cbctab tfoot tr').clone();
		//	data['$right_template'].eq(0).find('td:gt('+ftCell+')').html('<input data-type="productcode" type="text" class="inputcls" />');
			break;
		case 'root2' : 
			data['$left'] = data['$row'].next().next().next().next();
			data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');
			data['$left_template'] = $('#productcodetab tbody tr').clone();
			data['$right_template'] = $('#productcodetab tfoot tr').clone();
			data['$right_template'].eq(0).find('td:gt('+ftCell+')').html('<input data-type="productcode" type="text" class="inputcls" />');
			break;
		case 'root3' :
			data['$left'] = data['$row'].next().next().next().next().next();
			data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');
			data['$left_template'] = $('#parttab tbody tr').clone();
			data['$right_template'] = $('#parttab tfoot tr').clone();
			data['$right_template'].eq(0).find('td:gt('+ftCell+')').html('<input data-type="part" type="text" class="inputcls" />');
			break;
		case 'root4' : break;
	}

	data['$right_template'].each(function(){
		var $tds = $(this).find('td');
		for(var i=0, el; el=list_hidden_td[i]; i++){
			$tds.eq(el.cellIndex).addClass('dn');
		}
		for(var i=0, el; el=list_nhide_td[i]; i++){
			$tds.eq(el.cellIndex).addClass('nhide');
		}
	});
	data['$left_template'].on('mouseenter mouseleave', overTable_eve).filter('.cp')
						  .on('click', clickLeftTable_eve)
						  .find('span.pin').on('click', clickLeftPin_eve);
	data['$right_template'].on('mouseenter mouseleave', overTable_eve)
							.eq(0).find('input').on('focus change', event_qtyInputRelay_change).on('keyup', event_qtyInputRelay_keyup);
}

;function appendElementRelay_Level2(data, callBack, callBackEnd){
	
	var point='n'+$('#hidd_price').val();

	asyncEachSeries_Original(data['list_result'], function(item, call){

		var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true);
		$lClone.addClass( (item['id']+'_level2 '+data['data-v1']+'_cls') ).eq(0)
				.attr({'title': item['name'], 'data-root': 'root1', 'data-v2': item['id'], 'data-v1': data['data-v1'], 'data-name': item['name']})
				.find('span.scell').html( item['name']);

		setFieldValue($rClone.eq(0).find('td:gt('+(data['ftCell'])+')'), data, item['map_type_FC']['csFC']);
		setFieldValue($rClone.eq(1).find('td:gt('+(data['ftCell'])+')'), data, item['map_type_FC']['pmFC']);
		setFieldValue($rClone.eq(2).find('td:gt('+(data['ftCell'])+')'), data, item['map_type_FC']['amFC']);
				
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
	
	asyncEachSeries_Original(data['list_result'], function(item, call){

		var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true);
		$lClone.addClass( (item['id']+'_level3 '+data['data-v2']+'_level2 '+data['data-v1']+'_cls') ).eq(0)
				.attr({'data-v3': item['id'], 'data-v2': data['data-v2'], 'data-v1': data['data-v1'], 
						'title': item['name'], 'data-root': 'root2', 'data-name': item['name'], 'data-cbc-code': item['accnumber'] })
				.find('span.scell').html( item['name']);
		
		$lClone.eq(0).find('td:last input').val( Globalize.format(item['price'], point) );

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

;function appendElementRelay_Level4(data, callBack, callBackEnd){
	
	var point='n'+$('#hidd_price').val(), 
		isFrezeen=data['$row'].parent().find( ('tr.rt0.'+data['data-v1']+'_cls') ).find('input.unfreeze').length;

	data['$left_template'].eq(0).find('td:last').on('mouseenter mouseleave', overPriceTab_relay_eve)
		  .append('<input type="text" data-type="productcode" value="" class="zidxInput pricecls" style="margin-left: -20px;"/>')
		  .find('input').on('focus change', event_priceRelay_change);
	data['$left_template'].eq(0).find('span.mark_img').addClass('mark_new').removeClass('p');
	if(isFrezeen == 0){
		data['$left_template'].eq(0).find('input.pricecls').attr('disabled', true);
		data['$right_template'].find('input').attr('disabled', true);
	}

	asyncEachSeries_Original(data['list_result'], function(item, call){

		var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true);
		$lClone.addClass( (item['id']+'_level4 '+data['data-v3']+'_level3 '+data['data-v2']+'_level2 '+data['data-v1']+'_cls') ).eq(0)
				.attr({'data-number': item['accnumber'], 'data-v4': item['id'], 'data-v3': data['data-v3'], 'data-v2': data['data-v2'],
						'title': ('[ '+item['accnumber']+' ] - '+ item['name']), 'data-root': 'root3', 'data-v1': data['data-v1'], 'data-name': item['name'], 'data-cbc-code': data['data-cbc-code'] })
				.find('span.scell').html( '[ '+item['accnumber']+' ] - '+ item['name']);
		
		$lClone.eq(0).find('td:last input').val( Globalize.format(item['price'], point) );
		
		setFieldValue($rClone.eq(0).find('td:gt('+(data['ftCell'])+')'), data, item['map_type_FC']['quantity'], item['price']);
		setFieldValue1($rClone.eq(1).find('td:gt('+(data['ftCell'])+')'), data, item['map_type_FC']['pmFC']);
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

;function appendElementRelay_Level5(data, callBack, callBackEnd){

	var point='n'+$('#hidd_price').val(),
		isFrezeen=data['$row'].parent().find( ('tr.rt0.'+data['data-v1']+'_cls') ).find('input.unfreeze').length;;
		
    data['$left_template'].eq(0).off('click').find('td:last').on('mouseenter mouseleave', overPriceTab_relay_eve)
		  .append('<input type="text" value="" data-type="part" class="zidxInput pricecls" style="margin-left: -20px;"/>')
		  .find('input').on('focus change', event_priceRelay_change);
  //  data['$left_template'].eq(0).find('span.cellbox fcell').on('click', clickLeftPin_eve);

	if(isFrezeen == 0){
		data['$left_template'].eq(0).find('input.pricecls').attr('disabled', true);
		data['$right_template'].find('input').attr('disabled', true);
	}
    
    data['$left_template'].eq(0).find('span.pin.partpinfix').html('&nbsp;');
	asyncEachSeries_Original(data['list_result'], function(item, call){

		var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true);
		$lClone.addClass( (item['id']+'_level5 '+data['data-v4']+'_level4 '+data['data-v3']+'_level3 '+data['data-v2']+'_level2 '+data['data-v1']+'_cls') ).eq(0)
				.attr({'data-v5': item['id'], 'data-v4': data['data-v4'], 'data-v3': data['data-v3'], 'data-v2': data['data-v2'], 'data-v1': data['data-v1'],
						'data-root': 'root4', 'title': item['name'], 'data-cbc-code': data['data-cbc-code'], 'data-number': data['data-number']})
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
;function alertRelayMessage(content){
	art.dialog({
        title:' ', lock:true, dblclick_hide:false, esc:false, id: 'countsid',
        content: content,
        button : [ {value: 'Ok', focus: true, callback: function(){  }} ]
    });
}
;function getZeroOfNumberRelay(t){
	t=parseFloat(t);
	return ($.isNumeric(t) ? t : 0);
}