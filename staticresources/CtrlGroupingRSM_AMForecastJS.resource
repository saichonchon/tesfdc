var LAZY = {
		'fire' : function(obj, callback, timeout) {
		    timeout = timeout || 200;
		    setTimeout(function() { callback(null, obj); }, timeout);
		}
	},
	WORK_CLS={
		'level1': 'APL_ClsRSMAMService.SearchLevel1', 'level2': 'APL_ClsRSMAMService.SearchLevel2',
		'level3': 'APL_ClsRSMAMService.SearchLevel3', 'level4': 'APL_ClsRSMAMService.SearchLevel4',
		'level5': 'APL_ClsRSMAMService.SearchLevel5', 'level6': 'APL_ClsRSMAMService.SearchLevel6',
		'other':  'APL_ClsRSMAMService.SearchLevelOther', 'leveltotal': 'APL_ClsRSMAMService.SearchLevelTotal'
	};
;function createAMTerritoryCodeData(){
	
	var $r_trs=$('#rtabid tr'), $l_trs=$('#ltabid tr'), $head_trs=$('#tab_head_list td'), 
		overallfrozen = $('#hidd_overallfrozen').val(), list_trs=$l_trs.filter('.rt0').toArray(), head_cell={};
		
	if(overallfrozen == 'true' || overallfrozen == true){
		//$('#rtabid tr.overrulerelayfctotal input').attr('disabled', true);
		//$('#relayTotal').attr('disabled', true);//added by nelson zheng 2015-9-16
	}
	
    asyncEachSeries_Original(list_trs, function(item, callback){
		var $this=$(item), $prevCycle=$this.next(), $amCycle=$prevCycle.next(),
    		params=createTcodeTotalJson($r_trs.eq($this.index()), $r_trs.eq($prevCycle.index()), $r_trs.eq($amCycle.index()), $this, $head_trs);
    	$this.find('div:first').append('<span class="tcodefc waitingtcode"></span>');
    	customRemoteAction(params, getAcct_js, complete_AMTotalCycleFC); //this is total remote action
    }, function(err){ list_trs=[]; }, 120);
    
    $head_trs.filter('.qtotalCls').each(function(){
    	head_cell[this.getAttribute('data-date')]=this.cellIndex;
    });
    
    $l_trs.filter('.overrulerelayfctotal').each(function(){
    	var $this=$(this), $cRow=$l_trs.filter('.trt_trt');
    	$cRow.find('div:first').append('<span class="tcodefc waitingtcode"></span>');
    	var index=$this.index(), $r_tds=$r_trs.eq(index).find('td'), 
    		_json={ 'className': 'ClsAPLEntityTypes.RSMAMOverRallInfo', 
    				'str_json': '{"managerId": "'+$.trim($('#hidd_managerid').val())+
    				'", "displayName": "'+$.trim($('#hidd_amdisplayname').val())+
    				'", "map_year_quartersFuture": '+$('#hidd_yearfutureid').val()+' }' },
			params={'$crow': $cRow, '$row': $this, 'rowIndex': index, 'json': JSON.stringify(_json), '$r_tds': $r_tds, 
					'$relay_tds': $r_trs.filter('.relayfctotal').find('td'), 'cell': head_cell};    		
    	customRemoteAction(params, getAcct_js, complete_OverAllFC); //this is total remote action
    });
    
    $r_trs.filter('.relayfctotal').each(function(){
    	var $this=$(this), $tds=$this.find('td'), cfc=$.parseJSON($this.attr('data-value'));
    	for(var o in cfc){
    		$tds.eq(head_cell[o]).attr('data-old', cfc[o]).html( Globalize.format(cfc[o], 'n') );
    	}
    });
    
    ;function createTcodeTotalJson($curentCycle, $prevCycle, $amCycle, $this, $head_trs){
		var q_month={}, q_months={}, q_Future={}, q_cell={}, m_cell={},
			_json={'className': 'ClsAPLEntityTypes.RSMTerritoryFCInfo', 'str_json': '{}' }, 
			params={'$row': $this, '$currentCycle': $curentCycle, '$prevCycle':$prevCycle, '$amCycle': $amCycle, 'json': '{}', 
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


;function changeInput_AMForecast(ov, tv, $this, o_cfg){
	switch($this.attr('data-type')){
		case 'pos':  break;
		case 'cma': break;
		case 'cbc2': cbcSum(o_cfg); break;
		case 'gpl': gplSum(o_cfg); break;
		case 'gplpart': gplPartSum(o_cfg); break;
		case 'otherpart': otherPart(o_cfg); break;
		case 'overall': overall(o_cfg); break;
	}
	
	;function overall(o_cfg){
		var tc_total=o_cfg['$right_trs'].filter('.tcfctotal').find('td:eq('+o_cfg['cellIndex']+')').text(),
			$total_td=o_cfg['$right_trs'].filter('.fctotal').find('td:eq('+o_cfg['cellIndex']+')');
		
		tc_total=(numberOfZero( $.trim(tc_total) )+tv);
		$total_td.html( Globalize.format(tc_total, 'n') );
	}
	
	;function cbcSum(o_cfg){
		
		if(o_cfg['$left_trs'].filter('.trt_trt').hasClass('exp')){
    		o_cfg['$left_trs'].filter('tr.trt_0:not(.trt_trt)').each(function(){
    			o_cfg['$right_trs'].eq(this.rowIndex).addClass('dn');
    			$(this).addClass('dn');
    		});
    		o_cfg['$left_trs'].filter('tr.trt_trt').addClass('col').removeClass('exp').find('span.fcell').html('+');
    	}
    	
		var total=0, accCls='.rt1.'+o_cfg['aid']+'_cls.'+o_cfg['codecls'], cbcCls='.rt2.'+o_cfg['aid']+'_cls.'+o_cfg['codecls'],
    		accIndex=o_cfg['$left_trs'].filter(accCls).index(), $l_cbcRow=o_cfg['$left_trs'].filter(cbcCls),
    		codeIndex=o_cfg['$left_trs'].filter( '.rt0.'+o_cfg['codecls']).index(),
    		$accCell=o_cfg['$right_trs'].eq(accIndex).find('td:eq('+o_cfg['cellIndex']+')'),
    		$cbcCell=o_cfg['$right_trs'].eq(codeIndex).find('td:eq('+o_cfg['cellIndex']+')');

    	$l_cbcRow.each(function(){
    		var $td=o_cfg['$right_trs'].eq(this.rowIndex).find('td:eq('+o_cfg['cellIndex']+')'),
				$input=$td.find('input'), v=numberOfZero( $.trim($td.text()) );

    		if($input.length != 0){ v=numberOfZero( $.trim($input.val()) ); }
    		total+=v;
    	});
    	
    	$accCell.html(Globalize.format(total, 'n'));
    	total=0;
    	
    	o_cfg['$left_trs'].filter( '.rt1.'+o_cfg['codecls']).each(function(){
    		var v = o_cfg['$right_trs'].eq(this.rowIndex).find('td:eq('+o_cfg['cellIndex']+')').text();
    		total+=numberOfZero( $.trim(v) );
    	});
    	$cbcCell.html(Globalize.format(total, 'n'));
    	
	}
	
	;function gplSum(o_cfg){
		
		if(o_cfg['$left_trs'].filter('.trt_trt').hasClass('exp')){
    		o_cfg['$left_trs'].filter('tr.trt_0:not(.trt_trt)').each(function(){
    			o_cfg['$right_trs'].eq(this.rowIndex).addClass('dn');
    			$(this).addClass('dn');
    		});
    		o_cfg['$left_trs'].filter('tr.trt_trt').addClass('col').removeClass('exp').find('span.fcell').html('+');
    	}
		
    	var cbcRowIndex=o_cfg['$left_trs'].filter( ('.rt2.'+o_cfg['aid']+'_cls.'+o_cfg['codecls']+'.'+o_cfg['cbc2num']) ).index(),
    		accRowIndex=o_cfg['$left_trs'].filter( ('.rt1.'+o_cfg['aid']+'_cls.'+o_cfg['codecls']) ).index(),
    		codeRowIndex=o_cfg['$left_trs'].filter( ('.rt0.'+o_cfg['codecls']) ).index(),
    		$cbcCell=o_cfg['$right_trs'].eq(cbcRowIndex).find('td:eq('+o_cfg['cellIndex']+')').find('input'), 
    		$accCell=o_cfg['$right_trs'].eq(accRowIndex).find('td:eq('+o_cfg['cellIndex']+')'),
    		$codeCell=o_cfg['$right_trs'].eq(codeRowIndex).find('td:eq('+o_cfg['cellIndex']+')'),
    		cbcVal=numberOfZero($.trim($cbcCell.val())), accVal=numberOfZero($.trim($accCell.text())),
    		acc_total=0, cbc_total=0, gpl_total=0, part_total=0;
    	
    	ov = ($.isNumeric(ov) ? ov : 0);
    	tv = ($.isNumeric(tv) ? tv : 0);
    	
    	o_cfg['$left_trs'].filter('.rt4.'+o_cfg['codecls']+'.'+o_cfg['aid']+'_cls.'+o_cfg['cbc2num']+'.'+o_cfg['gid']+'_gpl').each(function(){
    		var v = o_cfg['$right_trs'].eq(this.rowIndex).find('td:eq('+o_cfg['cellIndex']+')').find('input').val();
    		part_total += numberOfZero($.trim(v));
    	});

    	if(tv < part_total){
    		$this.val( Globalize.format(part_total, 'n') );
    		return;
    	}
		
    	o_cfg['$left_trs'].filter( ('.rt3.'+o_cfg['aid']+'_cls.'+o_cfg['codecls']+'.'+o_cfg['cbc2num']) ).each(function(){
            var gv=o_cfg['$right_trs'].eq(this.rowIndex).find('td:eq('+o_cfg['cellIndex']+')').find('input').val();
    		gpl_total+=numberOfZero($.trim(gv));
    	});
    	
    	$cbcCell.val(Globalize.format(gpl_total, 'n'));	//current cbc2 cell value
    //	console.log(o_cfg['$left_trs'].filter( ('.rt2.'+o_cfg['aid']+'_cls.'+o_cfg['codecls']) ));
    	o_cfg['$left_trs'].filter( ('.rt2.'+o_cfg['aid']+'_cls.'+o_cfg['codecls']) ).each(function(){
    		var $cb=o_cfg['$right_trs'].eq(this.rowIndex).find('td:eq('+o_cfg['cellIndex']+')'),
            	cv=($cb.find('input').length == 0 ? $.trim($cb.text()) : $cb.find('input').val());
    		cbc_total+=numberOfZero($.trim(cv));
    	});
    	
    	$accCell.html(Globalize.format(cbc_total, 'n'));	//current account cell value
    	
    	o_cfg['$left_trs'].filter( ('.rt1.'+o_cfg['codecls']) ).each(function(){
    		var av=o_cfg['$right_trs'].eq(this.rowIndex).find('td:eq('+o_cfg['cellIndex']+')').text();
    		acc_total+=numberOfZero($.trim(av));
    	});

    	$codeCell.html( Globalize.format(acc_total, 'n') );
    }
    
    ;function gplPartSum(o_cfg){
    	var _cls=(o_cfg['aid']+'_cls.'+o_cfg['codecls']+'.'+o_cfg['cbc2num']+'.'+o_cfg['$ltr'].attr('data-gid')+'_gpl'),
    		$gplRow=o_cfg['$left_trs'].filter( ('.rt3.'+_cls) ),
			$gplCell=o_cfg['$right_trs'].eq($gplRow.index()).find('td:eq('+o_cfg['cellIndex']+')').find('input'),
    		gplVal=numberOfZero($.trim($gplCell.val())), part_total=0;
    	
    	o_cfg['$left_trs'].filter( ('.rt4.'+_cls) ).each(function(){
    		var t = $.trim( o_cfg['$right_trs'].eq(this.rowIndex).find('td:eq('+o_cfg['cellIndex']+') input').val() );
    		part_total += numberOfZero(t);
    	});	
    	
    	if(part_total > gplVal){
            $this.val ( $.isNumeric(ov) ? Globalize.format(ov, 'n') : '' ).focus().select();
        }
    }
    
    ;function otherPart(o_cfg){
    	
    	var _cls=(o_cfg['aid']+'_cls.'+o_cfg['codecls']+'.'+o_cfg['cbc2num']),
    		$otherRow=o_cfg['$left_trs'].filter( ('.rt2.'+_cls) ),
			$otherCell=o_cfg['$right_trs'].eq($otherRow.index()).find('td:eq('+o_cfg['cellIndex']+')').find('input'),
    		otherVal=numberOfZero($.trim($otherCell.val())), part_total=0;
    	
    	o_cfg['$left_trs'].filter( ('.rt4.'+_cls) ).each(function(){
    		var t = $.trim( o_cfg['$right_trs'].eq(this.rowIndex).find('td:eq('+o_cfg['cellIndex']+') input').val() );
    		part_total += numberOfZero(t);
    	});	
    	
    	if(part_total > otherVal){
            $this.val ( $.isNumeric(ov) ? Globalize.format(ov, 'n') : '' ).focus().select();
        }
    }
}

;function click_AMUnFreeze(e, $this, $span, $tr){
	$span.hide();
	
	var json=JSON.stringify({'managerId': $('#hidd_managerid').val(), 'territoryCode': $tr.attr('data-code')}),
		params={'json': json, '$this': $this, '$span': $span, '$tr': $tr};
	customRemoteAction(params, saveUnFreezeAM_js, complete_saveUnFreezeAM); //this is remote action
}

;function click_AMPin(e, _this, $this, $td, $tr, $body, $right_trs, rt, cls, acls, codeCls){
	var interFaceName= '';
	switch(rt){
		case 'root10': interFaceName='ClsAPLEntityTypes.RSMTotalFCInfo'; break;
		case 'root0':  interFaceName='ClsAPLEntityTypes.RSMTerritoryFCInfo'; break;
		case 'root1':  interFaceName=$body.find('tr.rt0.'+codeCls).attr('data-interface'); break;
		case 'root2':  interFaceName=$body.find('tr.rt1.'+acls+'.'+codeCls).attr('data-interface'); break;
		case 'root3':  interFaceName=$body.find('tr.rt2.'+acls+'.'+codeCls).attr('data-interface'); break;
	}

	createRefDataRemote($body.find(cls), interFaceName); 
	
	;function createRefDataRemote($totalRows, interFaceName){
		var isTCProd=($this.attr('data-prod') == 'tc' ? true : false),
			q_month={}, q_months={}, q_Future={}, q_cell={}, m_cell={}, $head_trs=$('#tab_head_list td'),
			_json={ "set_terrtoryCodes": $.parseJSON($('#hidd_amcodes').val()), "isTCProd": isTCProd, "acctId": $tr.attr('data-aid'), 
					"currentYear": $('#hidd_cyear').val(), "currentMonth": $('#hidd_cmonth').val(), 
					"territoryCode": $tr.attr('data-code'), "cbcCode": $tr.attr('data-cbc'), "gplId": $tr.attr('data-gid'), "list_dateKey": []
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
	    	
			new_params['root']=rt;
			new_params['quarterCell']=this.cellIndex;
			new_params['sMonths']=list_month.join(',');
			new_params['action']=getRefData_js;
			new_params['complete']=complete_getAMRefData;
			
			new_params['json']='{\"className\":\"'+interFaceName+'\", \"str_json\": '+JSON.stringify(JSON.stringify(_json))+' }';

			customRemoteAction(new_params, getRefData_js, complete_getAMRefData); //this is remote action

			th += '<td class="ref_head" style="text-align: center;">'+$qCell.find('span').text()+'</td>';
			td += '<td class="smonths" data-status="false" data-months="'+list_month.join(',')+'" style="text-align: center;"><div class="refstatus str"></div></td>';
	    });
		$td.append('<div class="refs_d"><table class="pinstatus" border="0" cellspacing="0" cellpadding="0" ><tr class="shead">'+th+'</tr><tr class="sbody">'+td+'</tr></table></div>')
		   .find('div.refs_d').off('mouseenter mouseleave').on('mouseenter mouseleave', over_refStatus_eve);
		$this.off('mouseenter mouseleave').on('mouseenter mouseleave', over_pinRefStatus_eve);
	}
}

;function clickAMLeftTab(e, target){
	var hide = 'dn', list_element = [], $right_list_trs=e.data.$divbody.find('#rtabid tr'), _this = target, $this=$(_this),
    	$parent=$this.parent(), $waiting = $this.find('td:first span.fcell'), $pin=$this.find('span.pin'),
    	o_cfg = {'rowIdx': _this.rowIndex, 'root': _this.getAttribute('data-root'), 'isRemote':false, 'o_cell': undefined}, 
        fn = ($this.hasClass('exp')? exp : col);
	
    $this.find('td:first span.reload_span').remove();
    console.log($('#ltabid tr:not(.overrulerelayfctotal) span.tcodefc'));
    if($('#ltabid tr:not(.overrulerelayfctotal) span.tcodefc').length != 0 && o_cfg['root'] == 'root10'){ 
    	console.log('1');
    	return false; 
    }
    if(o_cfg['root'] == 'root10' && $parent.find('span.readypin').length != 0){ 
    	console.log('2');
    	return false; 
    }

    if($this.find('td:first input[type="button"].delpartbtn').hasClass('disabled_btn')){
    	 console.log('3');
    	 return false; 
    }
//    if(rowIsLocked(o_cfg['rowIdx'])){ return false; }
    if($this.hasClass('ready')){ return false; }
	
    fn();
    
    ;function exp(){
    	if(isLockedData()){
    		return false;
    	}
    	
    	var code_cls= 'tr.'+_this.getAttribute('data-codecls'), tabCls='';
    	switch(o_cfg['root']){
    		case 'root10' : code_cls = 'tr.rtt0:not(.trt_trt)'; break;
    		case 'root0' : code_cls+=':not(.ttsub):not(.rt0)'; break;
            case 'root1' : 
            	code_cls = 'tr:not(.asub):not(.rt1).'+_this.getAttribute('data-aidcls'); 
            	$this.find('td').removeClass('a_bg');
				$right_list_trs.eq(o_cfg['rowIdx']).find('td').removeClass('a_bg');
				tabCls='c_bg g_bg p_bg';
        		break;
            case 'root2' : 
            	if($this.attr('data-cbc') == 'Others'){
            		code_cls='tr:not(.rt2):not(.cbcsub).'+$this.attr('data-codecls')+'.'+$this.attr('data-aidcls')+'.'+$this.attr('data-cbc-num');
            	}else{
	            	code_cls = 'tr:not(.cbcsub):not(.rt2).'+_this.getAttribute('data-aidcls')+'.'+_this.getAttribute('data-cbc-num'); 
            	}
            	$this.find('td').removeClass('c_bg');
				$right_list_trs.eq(o_cfg['rowIdx']).find('td').removeClass('c_bg');
				tabCls='g_bg p_bg';
            	break;
            case 'root3' : 
            	code_cls = 'tr:not(.gplsub):not(.rt3).'+_this.getAttribute('data-aidcls')+'.'+_this.getAttribute('data-cbc-num')+'.'+_this.getAttribute('data-gid')+'_gpl'; 
            	$this.find('td').removeClass('g_bg');
				$right_list_trs.eq(o_cfg['rowIdx']).find('td').removeClass('g_bg');
				tabCls='p_bg';
            	break;
            case 'root44' :
            	code_cls = 'tr:not(.rt33):not(.productcodesub).'+$this.attr('data-v1')+'_cls.'+$this.attr('data-v2')+'_cls.'+$this.attr('data-v3')+'.'+$this.attr('data-v4')+'_gpl.'+$this.attr('data-v5'); 
            	$this.find('td').removeClass('p_bg');
				$right_list_trs.eq(o_cfg['rowIdx']).find('td').removeClass('p_bg');
            	break;
            case 'root4' : 
            	code_cls = 'tr:not(.rt4).'+_this.getAttribute('data-aidcls')+'.'+_this.getAttribute('data-cbc-num')+'.'+_this.getAttribute('data-pid')+'_part'; 
            	code_cls += ( _this.getAttribute('data-cbc') == 'Others' ? '' : ('.'+_this.getAttribute('data-gid')+'_gpl') );
            	$this.find('td').removeClass('p_bg');
				$right_list_trs.eq(o_cfg['rowIdx']).find('td').removeClass('p_bg');
            	break;
    	}

    	_queueTask.push({name: o_cfg['rowIdx'], run: function(cb){
	        $parent.find(code_cls).addClass(hide).each(function(){
	            $right_list_trs.eq(this.rowIndex).addClass(hide).find('td').removeClass(tabCls);
	            var $tRow=$(this), $p=$tRow.removeClass('exp col').addClass('col').find('td').removeClass(tabCls)
	            				.find('span.fcell').html('+').parent().find('span.pin');
				if(!$p.hasClass('waitingpin')){ $p.addClass('spin'); }
				if($tRow.hasClass('rt110') || $tRow.hasClass('rt4')){
					$tRow.find('span.pin').addClass('spin');
				}
				if(o_cfg['root'] == 'root10'){ $(this).find('span.pin').addClass('spin'); }
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
    	
    	var codecls=_this.getAttribute('data-codecls'), actcls=_this.getAttribute('data-aidcls'),
    		find_cls= 'tr.'+codecls, 
    		remote_fn={'params':{}, 'remote':function(p){}, '$row': $this, 'data-aid': $this.attr('data-aid'), 'root': o_cfg['root'],
    			'data-code': $this.attr('data-code'), 'data-cbc': $this.attr('data-cbc'), 'data-cbc-num': $this.attr('data-cbc-num'),
    			'data-acnumber': $this.attr('data-acnumber'), 'data-gid': $this.attr('data-gid'), 'rowIndex': o_cfg['rowIdx'], 'action': existAPLsObject_js, 'complete': complete_existAMObject
    		};
    	
    	switch(o_cfg['root']){
    		case 'root10' :  //find total rows
    			find_cls = 'tr.rtt0:not(.subtotfields)';
    			sumOfAllTotal();
    			o_cfg['isRemote'] = false;
    			break;
    		case 'root0' :  //find account rows
    			find_cls += '.rt1'; 
    			check_forecast(find_cls, remote_fn, createAcct_json, getAcct_js, complete_getAcct);
    			break;
            case 'root1' : 	//find cbc2 rows
            	find_cls = ('tr:not(.asub):not(.partsub):not(.gplsub):not(.cbcsub).rt2.'+codecls+'.'+actcls);
    			check_forecast(find_cls, remote_fn, createCbc_json, getAcct_js, complete_getCBC2);
            	break;
            case 'root2' : 	//find gpl rows
            	if(remote_fn['data-cbc'] == 'Others'){
            		find_cls='tr:not(.cbcsub).rt110.'+actcls+'.'+_this.getAttribute('data-cbc-num');
            		remote_fn['append'] = appendElementAMOther_level3;
            		remoteCheck(find_cls, remote_fn, createOtherJSON, WORK_CLS['other']);
            	}else if(remote_fn['data-cbc'] == 'Relay'){
            		find_cls='tr.rt3.'+actcls+'.'+_this.getAttribute('data-cbc-num')+'.'+codecls;
            		remote_fn['append'] = appendElementAMRelay_level3;
            		remoteCheck(find_cls, remote_fn, createCBCRelayJSON, WORK_CLS['level4']);
    			}else{
	            	find_cls = 'tr.rt3.'+actcls+'.'+_this.getAttribute('data-cbc-num')+'.'+codecls;
	    			find_cls += (_this.getAttribute('data-cbc') == 'Others' ? '' : ':not(.rt4)');
	    			check_forecast(find_cls, remote_fn, createGpl_json, getAcct_js, complete_getGPL);
            	}
            	break;
            case 'root3' : 	//find part rows
            	if(remote_fn['data-cbc'] == 'Relay'){
					find_cls=('tr.rt33.'+$this.attr('data-code')+'_cls.'+$this.attr('data-aid')+'_cls.'+$this.attr('data-gid')+'_gpl.'+$this.attr('data-cbc-num'));
    				remote_fn['append'] = appendElementAMProduct_level4;
					remoteCheck(find_cls, remote_fn, createProductCodeJSON, WORK_CLS['level5']);
    			}else{
	            	find_cls = 'tr:not(.gplsub):not(.partsub):not(.rt3).'+actcls+'.'+_this.getAttribute('data-cbc-num')+'.'+_this.getAttribute('data-gid')+'_gpl.'+codecls;
	            	find_cls += ', tr.rt4.'+codecls+'.'+actcls+'.'+_this.getAttribute('data-cbc-num')+'.'+_this.getAttribute('data-gid')+'_gpl.'+codecls;
	    			check_forecast(find_cls, remote_fn, createPart_json, getAcct_js, complete_getPart);
    			}
            	break;
            case 'root44' : 
    				remote_fn['data-v1']=$this.attr('data-v1');
    				remote_fn['data-v2']=$this.attr('data-v2');
    				remote_fn['data-v3']=$this.attr('data-v3');
    				remote_fn['data-v4']=$this.attr('data-v4');
    				remote_fn['data-v5']=$this.attr('data-v5');
            		find_cls=('tr.rt4.'+$this.attr('data-v1')+'_cls.'+$this.attr('data-v2')+'_cls.'+$this.attr('data-v4')+'_gpl.'+$this.attr('data-v3')+'.'+$this.attr('data-v5'));
    				remote_fn['append'] = appendElementAMPart_level5;
					remoteCheck(find_cls, remote_fn, createPartJSON, WORK_CLS['level6']);
            	break;
            case 'root4' : 	//show part rows
            	find_cls = 'tr.partsub.'+codecls+'.'+actcls+'.'+_this.getAttribute('data-cbc-num')+'.'+_this.getAttribute('data-pid')+'_part';
            	find_cls += ( _this.getAttribute('data-code') == 'Others' ? '' : ('.'+_this.getAttribute('data-gid')+'_gpl') );
            	o_cfg['isRemote'] = false;
            	break;
    	}
		console.log( find_cls );
		//added by nelson zheng 2015-9-16 begin
		if(find_cls == 'tr.rtt0:not(.subtotfields)'){
			var manualInput = $('#manualInputForecast').val();
			
			if(manualInput == 'false'){
				$('#relayTotal').attr('value', 'Manual Enter Forecast');
				var $r_trs=$('#rtabid tr'), $l_trs=$('#ltabid tr'), $head_trs=$('#tab_head_list td'); 
				var overallfrozen = $('#hidd_overallfrozen').val(), list_trs=$l_trs.filter('.rt0').toArray(), head_cell={};
				var needToSave = false;
		        $head_trs.filter('.qtotalCls').each(function(){
					head_cell[this.getAttribute('data-date')]=this.cellIndex;
				});
		        $r_trs.filter('.relayfctotal').each(function(){
					var $this=$(this), $tds=$this.find('td'), cfc=$.parseJSON($this.attr('data-value'));
					var tds1 = $('#rtabid tr.overrulerelayfctotal').find('td');
					for(var o in cfc){
						
						if(tds1.eq(head_cell[o]).find('input').val() != Globalize.format(cfc[o], 'n')){
							needToSave = true;
						}
						tds1.eq(head_cell[o]).find('input').val(Globalize.format(cfc[o], 'n'));
					}
							   	
				});
				sumOfAllTotal();
				
				if(needToSave){
					saveAMForecast(this);
				}
				$('#rtabid tr.overrulerelayfctotal input').attr('disabled', true);
			}else{
				$('#relayTotal').attr('value', 'Use Aggregate Forecast');
			}
		}
		//added by nelson zheng 2015-9-16 end
		
    	if((remote_fn['root'] == 'root2' && (remote_fn['data-cbc'] == 'Others' || remote_fn['data-cbc'] == 'Relay')) || 
    		(remote_fn['root'] == 'root3' && remote_fn['data-cbc'] == 'Relay') || remote_fn['root'] == 'root44'){
    		remote_fn['remote'](remote_fn);
    	}else{
			remote_fn['remote'](remote_fn['params']);
    	}
		expandElement(find_cls);
		setColTabBgColor();
    }
    
    ;function sumOfAllTotal(){

    	var cell_total={}, cCell=$('#tab_head_list td.crtQtotal')[0].cellIndex-1, 
    		$overall_tds=$right_list_trs.filter('.overrulerelayfctotal').find('td'),
    		$relay_tds=$right_list_trs.filter('.relayfctotal').find('td'),
    		$total_tds=$right_list_trs.filter('.fctotal').find('td'), 
    		$tc_tds=$right_list_trs.filter('.tcfctotal').find('td');
    	
    	$parent.find('tr.rt0').each(function(){
    		$right_list_trs.eq(this.rowIndex).find('td:gt('+cCell+')').each(function(){
    			var total=getZeroOfNumber(cell_total[this.cellIndex]), v=numberOfZero($.trim(this.innerHTML));
    			cell_total[this.cellIndex] = (total+v);
    		});
    	});
    	
    	for(var cell in cell_total){
    		var overall=numberOfZero($.trim($overall_tds.eq(cell).find('input').val())), 
    			relay=numberOfZero($.trim($relay_tds.eq(cell).text())), 
    			t_c = (cell_total[cell] - relay);

    		$tc_tds.eq(cell).html( Globalize.format(t_c, 'n') );
    		$total_tds.eq(cell).html( Globalize.format( (t_c+overall), 'n') );
    	}
    	cell_total={};
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
    	this['territoryCode']=$this.attr('data-code');
		this['grouping']=$this.attr('data-aid');
		this['map_year_quartersFuture']=$.parseJSON($('[id*=hidd_yearfutureid]').val());
    }
    ;function createCBCRelayJSON(){
    	this['territoryCode']=$this.attr('data-code');
		this['grouping']=$this.attr('data-aid');
		this['map_year_quartersFuture']=$.parseJSON($('[id*=hidd_yearfutureid]').val());
    }
    ;function createProductCodeJSON(){
    	this['territoryCode']=$this.attr('data-code');
    	this['grouping']=$this.attr('data-aid');
    	this['cbc2Code']=$this.attr('data-gid');
    	this['map_year_quartersFuture']=$.parseJSON($('[id*=hidd_yearfutureid]').val());
    }
    ;function createPartJSON(){
    	this['territoryCode']=$this.attr('data-v1');
    	this['grouping']=$this.attr('data-v2');
    	this['cbc2Code']=$this.attr('data-v4');
    	this['accnumber']=$this.attr('data-accnumber');
    	this['map_year_quartersFuture']=$.parseJSON($('[id*=hidd_yearfutureid]').val());
    }
    ;function createAcct_json(acct_cls){
    	var _json = { 'className': _this.getAttribute('data-interface'), 'str_json': '{}' }, q_cell={}, 
			params={'codecls': _this.getAttribute('data-codecls'), 'code':_this.getAttribute('data-code'), 
					'$row':$this, 'rowIndex':o_cfg['rowIdx'], 'json': '{}', 'q_cell': q_cell,
					'$lastRow': $parent.find('tr.ttsub.totalBacklog.'+_this.getAttribute('data-codecls'))
					};

        _json['str_json'] = '{"territoryCode": "'+_this.getAttribute('data-code')+'", "map_year_quartersFuture": '+$.trim($('[id*=hidd_yearfutureid]').val())+'}';
    	params['json'] = JSON.stringify(_json);
    	setForecastCellIndex(q_cell);
    	return params;
    }
    ;function createCbc_json(acct_cls){

    	var code=_this.getAttribute('data-code'), aId = _this.getAttribute('data-aid'),
    		_json = { 'className': _this.getAttribute('data-interface'), 'str_json': '{}' }, q_cell={}, map_cbc={},
			params={'$cbcRows': $parent.find(acct_cls).filter('.rt2'), '$row':$this, 'rowIndex':o_cfg['rowIdx'], 
					'aid': aId, 'code':code, 'codecls': _this.getAttribute('data-codecls'), 'json': '{}', 'q_cell': q_cell};

    	list_element = params['$cbcRows'].toArray();
        while(list_element.length > 0){
            var _tr = list_element.shift();
            map_cbc[_tr.getAttribute('data-cbc')] = _tr.getAttribute('data-cbc-num');
        }
        _json['str_json'] = '{"acctId": "'+aId+'", "territoryCode": "'+code+'", "periodStartDate": "'+$('[id*=hidd_periodsdid]').val()+'", '+
        					' "map_cbcRowKey_cbcName": '+JSON.stringify(map_cbc)+', "map_year_quartersFuture": '+$.trim($('[id*=hidd_yearfutureid]').val())+'}';
    	params['json'] = JSON.stringify(_json);
    	setForecastCellIndex(q_cell);
    	return params;
    }
    
    ;function createGpl_json(acct_cls){
    	
    	var code=_this.getAttribute('data-code'), aId=_this.getAttribute('data-aid'), data_num=_this.getAttribute('data-cbc-num'), cbc=_this.getAttribute('data-cbc'),
    		_json = { 'className': _this.getAttribute('data-interface'), 'str_json': '{}' }, q_cell={},
			params={'q_cell': q_cell, '$row':$this, '$cbcBacklogRow': $parent.find('tr.cbcsub.'+code+'_cls.'+aId+'_cls.backlog.'+data_num), 
					'aid': aId, 'dataNum':data_num, 'cbcCode': cbc, 'code': code, 'rowIndex':o_cfg['rowIdx'], 'json': '{}'};

        _json['str_json'] = '{"acctId": "'+aId+'", "territoryCode": "'+code+'", "periodStartDate": "'+$('[id*=hidd_periodsdid]').val()+'", ' +
							'"cbc2Code": "'+cbc+'", "map_year_quartersFuture": '+$.trim($('[id*=hidd_yearfutureid]').val())+'}';
    	
    	params['json'] = JSON.stringify(_json);
    	setForecastCellIndex(q_cell);
    	return params;
    }
    
    ;function createPart_json(acct_cls){
    	var code=_this.getAttribute('data-code'), aId=_this.getAttribute('data-aid'), data_num=_this.getAttribute('data-cbc-num'), 
    		cbcCode=_this.getAttribute('data-cbc'), gplId=_this.getAttribute('data-gid'),
    		_json = { 'className': _this.getAttribute('data-interface'), 'str_json': '{}' }, q_cell={},
			params={'q_cell': q_cell, '$row':$this, '$partBacklogRow': $parent.find('tr.gplsub.'+aId+'_cls.backlog.'+data_num+'.'+gplId+'_gpl.'+code+'_cls'), 
					'aid': aId, 'gid':gplId, 'dataNum':data_num, 'cbcCode': cbcCode, 'code': code, 'rowIndex':o_cfg['rowIdx'], 'json': '{}'};

        _json['str_json'] = '{"acctId": "'+aId+'", "gplId": "'+gplId+'", "territoryCode": "'+code+'", "currentYear": "'+$('#hidd_cyear').val()+'", "currentMonth": "'+$('#hidd_cmonth').val()+'", ' +
        					'"refStartDate": "'+$('[id*=hidd_start]').val()+'", "refEndDate": "'+$('[id*=hidd_end]').val()+'", "periodStartDate": "'+$('[id*=hidd_periodsdid]').val()+'", "map_year_monthsHistory": '+$('[id*=hidd_maphistory]').val()+', '+
							'"cbc2Code": "'+cbcCode+'", "map_year_monthsFuture": '+$('[id*=hidd_mapfuture]').val()+', "map_year_quartersFuture": '+$('[id*=hidd_yearfutureid]').val()+'}';
    	
    	params['json'] = JSON.stringify(_json);
    	setForecastCellIndex(q_cell);
    	return params;
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
    		case 'root3' :
    			if($parent.find('tr.rt2.'+codeCls+' td:first span.waiting').length != 0 ||
    				$parent.find('tr.rt2.'+codeCls+' td:first span.reload_span').length != 0){
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
;function event_refAMData_click(e){
	e.stopPropagation();
	var $this=$(e.target), $tr=$this.parent().parent().parent(), $lBody=$tr.parent(), $rBody=$('#rtabid'), $billing=$tr.next(), $booking=$billing.next(), $backlog=$booking.next(),
		remote_fn={ '$lbody': $lBody, '$rbody': $rBody,  'monthCell': {}, 'cellMonth': {}, 'json': {}, 'cls': '', 'crtCell': $('#tab_head_list td.crtQtotal')[0].cellIndex, 
			'findcls': '', 'data-v1': $tr.attr('data-v1'), 'data-v2': $tr.attr('data-v2'), 'data-v3': $tr.attr('data-v3'),
			'data-v4': $tr.attr('data-v4'), 'data-v5': $tr.attr('data-v5'), 'data-v6': $tr.attr('data-v6'), 'root': $tr.attr('data-root'), 
			'managerId': $('#hidd_managerid').val(), 'accnumber': $tr.attr('data-accnumber'), 'cbc2Code': $tr.attr('data-v4'), 
			'$billing': $billing, '$booking': $booking, '$backlog': $backlog, 'action': getAPLsRefData_js, 'actionBacklog': getBacklogRefData_js,
			'$historicalCells': $('#tab_head_list td.historicalc.qtotalCls, td.crtQtotal'), '$futureCells': $('#tab_head_list td.qtotalCls'), 
			'complete': complete_getAPLAMRefData, 'completeBacklog': complete_getAPLAMBacklogRefData
		}, execute=($this.hasClass('spin')? exp : col);
	console.log( $this);
	switch(remote_fn['root']){
		case 'root10':
			remote_fn['isOtherMethod']=($tr.hasClass('relayfctotal') ? true : false);
			remote_fn['findcls']='tr.subtotfields.'+$tr.attr('data-tnum');
			remote_fn['cls']=WORK_CLS['leveltotal'];
			break;
		case 'root0':
			remote_fn['$billing']=$tr.next().next();
			remote_fn['$booking']=remote_fn['$billing'].next();
			remote_fn['$backlog']=remote_fn['$booking'].next();
			remote_fn['data-v1']=$tr.attr('data-code');
			remote_fn['findcls']='tr:not(.rt0).ttsub.'+remote_fn['data-v1']+'_cls';
			remote_fn['cls']=WORK_CLS['level1'];
			break;
		case 'root1':
			remote_fn['$billing']=$tr.next().next().next().next();
			remote_fn['$booking']=remote_fn['$billing'].next();
			remote_fn['$backlog']=remote_fn['$booking'].next();
			remote_fn['data-v1']=$tr.attr('data-code');
			remote_fn['data-v2']=$tr.attr('data-aid');
			remote_fn['findcls']='tr:not(.rt1).asub.'+remote_fn['data-v1']+'_cls.'+remote_fn['data-v2']+'_cls';
			remote_fn['cls']=WORK_CLS['level2'];
			break;
		case 'root2':
			remote_fn['$billing']=$tr.next().next();
			remote_fn['$booking']=remote_fn['$billing'].next();
			remote_fn['$backlog']=remote_fn['$booking'].next();
			remote_fn['data-v1']=$tr.attr('data-code');
			remote_fn['data-v2']=$tr.attr('data-aid');
			remote_fn['data-v3']=$tr.attr('data-cbc-num');
			remote_fn['cbc2Code']=$tr.attr('data-cbc');
			remote_fn['findcls']='tr:not(.rt2).cbcsub.'+remote_fn['data-v1']+'_cls.'+remote_fn['data-v2']+'_cls.'+remote_fn['data-v3'];
			remote_fn['cls']=WORK_CLS['level3'];
			break;
		case 'root3': 
			remote_fn['$billing']=$tr.next().next().next();
			remote_fn['$booking']=remote_fn['$billing'].next();
			remote_fn['$backlog']=remote_fn['$booking'].next();
			remote_fn['data-v1']=$tr.attr('data-code');
			remote_fn['data-v2']=$tr.attr('data-aid');
			remote_fn['data-v3']=$tr.attr('data-cbc-num');
			remote_fn['data-v4']=$tr.attr('data-gid');
			remote_fn['cbc2Code']=(typeof(remote_fn['cbc2Code']) == 'undefined' ? $tr.attr('data-cbc') : remote_fn['cbc2Code'])
			remote_fn['findcls']='tr:not(.rt3).gplsub.'+remote_fn['data-v1']+'_cls.'+remote_fn['data-v2']+'_cls.'+remote_fn['data-v3']+'.'+remote_fn['data-v4']+'_gpl';
			remote_fn['cls']=WORK_CLS['level4'];

			break;
		case 'root007': 
			remote_fn['findcls']='tr:not(.rt110).'+remote_fn['data-v1']+'_cls.'+remote_fn['data-v2']+'_cls.'+remote_fn['data-v3']+'.'+remote_fn['data-v4'];
			remote_fn['cls']=WORK_CLS['other'];
			break;
		case 'root44': 
			remote_fn['$billing']=$tr.next().next().next();
			remote_fn['$booking']=remote_fn['$billing'].next();
			remote_fn['$backlog']=remote_fn['$booking'].next();
			remote_fn['findcls']='tr:not(.rt33).productcodesub.'+remote_fn['data-v1']+'_cls.'+remote_fn['data-v2']+'_cls.'+remote_fn['data-v3']+'.'+remote_fn['data-v4']+'_gpl.'+remote_fn['data-v5'];
			remote_fn['cls']=WORK_CLS['level5'];
			break;
		case 'root6': 
			remote_fn['$billing']=$tr.next().next().next();
			remote_fn['$booking']=remote_fn['$billing'].next();
			remote_fn['$backlog']=remote_fn['$booking'].next();
			remote_fn['findcls']=('tr:not(.rt4).partsub.'+remote_fn['data-v1']+'_cls.'+remote_fn['data-v2']+'_cls.'+remote_fn['data-v3']+'.'
									+remote_fn['data-v4']+'_gpl.'+remote_fn['data-v5']+'.'+remote_fn['data-v6']);
			remote_fn['cls']=WORK_CLS['level6'];
			break;
	}
	console.log( remote_fn );
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
			attr_tmp['json'] = {'set_fiscalMonth': list_q, 'territoryCode': remote_fn['data-v1'], 'grouping': remote_fn['data-v2'], 
								'managerId': remote_fn['managerId'], 'cbc2Code': remote_fn['cbc2Code'], 'gplId': remote_fn['data-v4'], 
								'isOtherMethod': remote_fn['isOtherMethod'], 'accnumber': remote_fn['accnumber'], 'partId': attr_tmp['data-v6']};
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
			attr_tmp['json'] = {'set_fiscalMonth': list_q, 'territoryCode': remote_fn['data-v1'], 'grouping': remote_fn['data-v2'], 
								'managerId': remote_fn['managerId'], 'cbc2Code': remote_fn['cbc2Code'], 'gplId': remote_fn['data-v4'], 
								'isOtherMethod': remote_fn['isOtherMethod'], 'accnumber': remote_fn['accnumber'], 'partId': attr_tmp['data-v6'] };
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

;function complete_saveUnFreezeAM(result, event, data){ 
	
    if(event.status){
    	data['$this'].off('click');
    	data['$span'].remove();
    }else{
    	alert(event['message']);
    	data['$span'].show();
    }
    
}

;function complete_OverAllFC(result, event, data){ 
    if(event.status){
        _queueTask.push({name: data['rowIndex'], run: function(cb){
        	matchOverAllCell(result, data, cb);
        }}, function(err){ });
    }else{
    	addCycelError(data, event);
    }
    
	;function addCycelError(data, event){
    	var err = '<b class="waitingerror" style="display:none;">'+event['message']+'</b>';
    	data['$crow'].find('span.waitingtcode').removeClass('waitingtcode').addClass('reload_img waitingtcodeerror')
    				.append(err).off('mouseenter mouseleave click').on('mouseenter mouseleave click', function(e){
    					e.stopPropagation();
    					var $this=$(this);
    					eventHandle(e, over, out, click);
    					;function over(e){ $this.find('b').show(); }
    					;function out(e){ $this.find('b').hide(); }
    					;function click(e){
	    					$this.off('mouseenter mouseleave click').removeClass('reload_img waitingtcodeerror')
	    						 .addClass('waitingtcode').find('b').remove();
	    					customRemoteAction(data, getAcct_js, complete_OverAllFC); //this is total remote action
    					}
    				});
    	
    }
    
    ;function matchOverAllCell(result, data, queueTaskCallBack){
    	result = $.parseJSON(result);	//map_dateKey_fc
    	for(var r in result['map_dateKey_fc']){
    		var relayv=getZeroOfNumber(data['$relay_tds'].eq(data['cell'][r]).attr('data-old'));
    		relayv=( result['map_dateKey_fc'][r] == 0 ? relayv : result['map_dateKey_fc'][r] );
    		data['$r_tds'].eq(data['cell'][r]).find('input').val( Globalize.format(relayv, 'n') );
    	}
    	queueTaskCallBack(null);
    	data['$crow'].find('span.waitingtcode').remove();
    }
}

;function complete_getAcct(result, event, data){ 
	scroll_event();
	if(event.status){
        _queueTask.push({name: data['rowIndex'], run: function(cb){
        	matchAcctFC_Element(result, data, cb);
        }}, function(err){ });
    }else{
        addReloadButton(data, event, reloadAcct_eve);
    }
    
    ;function matchAcctFC_Element(result, data, queueTaskCallBack){
    	var $actRow_left=$('#acctab tbody tr').clone(), $actRow_right=$('#acctab tfoot tr').clone(),
    		$cbcRow_left=$('#cbctab tbody tr').clone(), $cbcRow_right=$('#cbctab tfoot tr').clone(),
    		$right_row=$('#rtabid tr:eq('+data['$lastRow'].index()+')');

        result = complete_resultAMCheck(result, data);
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
       // 	formatFC(false, item['amFC'], $actRow_right_clone.filter('.amFC').find('td'), data['q_cell'], '');
       // 	formatFC(true, item['posFC'], $actRow_right_clone.filter('.posFC').find('td'), data['q_cell'], 'pos');
       // 	formatFC(true, item['cmaFC'], $actRow_right_clone.filter('.cmaFC').find('td'), data['q_cell'], 'cma');

        	$cbc_left_clone.addClass(addcls).filter('.rt2').attr(attr).attr({'data-root': 'root2'})
        				.each(function(){
        					var $cbc=$(this), t=(aid+'_'+count+'_cbc');
        					$cbc_left_clone.filter(':not(.rt2).'+$cbc.attr('data-cbc-num')).addClass(t);
        					$cbc.attr('data-cbc-num', t).addClass(t);
        					count++;
        				});
        	
        	attr['data-interface']=item['rsmTypeName'];
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

;function complete_getCBC2(result, event, data){ 
	scroll_event();
	if(event.status){
        _queueTask.push({name: data['rowIndex'], run: function(cb){
        	matchCBC2FC_Element(result, data, cb);
        }}, function(err){ });
    }else{
        addReloadButton(data, event, reloadCBC2_eve);
    }
    
    ;function matchCBC2FC_Element(result, data, queueTaskCallBack){
        var $acct_rtrs=$('#rtabid tr'), $acct_lbody=data.$row.parent();

        result=complete_resultAMCheck(result, data);

        if(result.length == 0){ 
            queueTaskCallBack(null); 
            return; 
        }
		
        var isFrezeen=data['$row'].parent().find( ('tr.rt0.'+data['codecls']) ).find('input.unfreeze').length;

        asyncEachSeries_Original(result, function(item, callback){
        	var $cbcRow=data['$cbcRows'].filter( '.rt2.'+item['fieldName'] ), code=$cbcRow.attr('data-cbc'),
        		_cls=( 'tr.cbcsub.'+data['aid']+'_cls.'+data['codecls']+'.'+$cbcRow.attr('data-cbc-num') ),
				$r_cbcRows=$acct_lbody.find(_cls);

        	$cbcRow.attr('data-interface', item['rsmTypeName'])
					.on('click', {$divbody: $('#div_body')}, clickLeftTable_eve).find('span.pin')
					.on('click', clickLeftPin_eve);

        	formatFC((code == 'Relay' ? false : true), item['currentFC'], $acct_rtrs.eq($cbcRow.index()).find('td'), data['q_cell'], (code == 'Relay' ? 'Relay' : 'cbc2'));
        	formatFC(false, item['previousFC'], $acct_rtrs.eq($r_cbcRows.filter('.previousFC').index()).find('td'), data['q_cell'], '');
      //  	formatFC(false, item['amFC'], $acct_rtrs.eq($r_cbcRows.filter('.amFC').index()).find('td'), data['q_cell'], '');
        	
        	if(code == 'Others'){
     //   		$cbcRow.find('span.fcell').remove();
        		var $inputs = $acct_rtrs.eq($cbcRow.index()).find('input').on('focus change', input_fc_eve).on('keyup', input_keyup_eve);
        		if(isFrezeen != 0){
        			$inputs.removeAttr('disabled');
        		}
        	}
        	
        }, function(err){
			complete_remoteStatus(data, queueTaskCallBack);
        }, 320);
    }
}
;function complete_getGPL(result, event, data){ 
	if(event.status){
		_queueTask.push({name: data['rowIndex'], run: function(cb){
			if(data['cbcCode'] == 'Others'){ matchOtherFC_Element(result, data, cb); }
			else{ matchGPLFC_Element(result, data, cb); }
		}}, function(err){ });
    }else{
    	$('#refdatastatusid').hide();
        addReloadButton(data, event, reloadGPL_eve);
    }
    
    ;function matchGPLFC_Element(result, data, queueTaskCallBack){
    	var $gpl=$('#gpltab'), $left_gpl=$gpl.find('tbody tr').clone(), $right_gpl=$gpl.find('tfoot tr').clone(), $all_tab=$('#div_body tbody.overbody'),
    		$append_right=$all_tab.filter('.rtbodycls').find('tr:eq('+data['$cbcBacklogRow'].index()+')');

        result = complete_resultCheck(result, data);

        if(result.length == 0){ 
            queueTaskCallBack(null); 
            return; 
        }
        registerEvent($left_gpl, $right_gpl);
		hideForecastHead($right_gpl);
    	var isFrezeen=data['$row'].parent().find( ('tr.rt0.'+data['code']+'_cls') ).find('input.unfreeze').length;

        asyncEachSeries_Original(result, function(item, callback){
        	var $l_clone=$left_gpl.clone(true), $r_clone=$right_gpl.clone(true), gplName='[ '+item['gplCode']+' ] - '+item['fieldName'];
        	$l_clone.addClass( (item['prodHichyId']+'_gpl '+data['code']+'_cls '+data['aid']+'_cls '+data['dataNum']) );
        	$l_clone.eq(0).attr({'title': gplName, 'data-interface': item['rsmTypeName'], 'data-gid': item['prodHichyId'], 
									'data-code': data['code'], 'data-root': 'root3', 'data-aid': data['aid'], 'data-aidcls': data['aid']+'_cls',
        							'data-codecls': data['code']+'_cls', 'data-cbc':data['cbcCode'], 'data-cbc-num': data['dataNum']})
        					.find('td:first span.scell').html(gplName);
        					
        	formatFC((data['cbcCode'] == 'Relay' ? false : true), item['currentFC'], $r_clone.eq(0).find('td'), data['q_cell'], (data['cbcCode'] == 'Relay' ? '' : 'gpl'));
        	formatFC(false, item['previousFC'], $r_clone.eq(1).find('td'), data['q_cell'], '');
       // 	formatFC(false, item['amFC'], $r_clone.filter('.amFC').find('td'), data['q_cell'], '');
        	
        	var $inputs = $r_clone.eq(0).find('input[type="text"]').on('focus change', input_fc_eve).on('keyup', input_keyup_eve);
			
        	if(isFrezeen == 0){ $inputs.attr('disabled', true); }
        	if(item['isHighLighted']){
				$l_clone.eq(0).find('td:first div:first').before('<div class="highLighted"></div>');
			}
        	data['$cbcBacklogRow'].after($l_clone);
        	$append_right.after($r_clone);
        	
        }, function(err){
			complete_remoteStatus(data, queueTaskCallBack);
        }, 230);
        
    }
    
    ;function matchOtherFC_Element(result, data, queueTaskCallBack){
        result = complete_resultCheck(result, data);
        queueTaskCallBack(null); 
        /*
        if(result.length == 0){ 
            return; 
        }
		completePartReslut(result, data, queueTaskCallBack, data['$cbcBacklogRow'], false);
		*/
    }
    ;function registerEvent($gplRow_left, $gplRow_right){
        $gplRow_right.on('mouseenter mouseleave', overTable_eve);
        $gplRow_left.on('mouseenter mouseleave', overTable_eve).eq(0)
					.on('click', {$divbody: $('#div_body')}, clickLeftTable_eve).find('span.pin')
					.on('click', clickLeftPin_eve);
    }

}

;function complete_getPart(result, event, data){ 
	if(event.status){
		_queueTask.push({name: data['rowIndex'], run: function(cb){
			matchGplPartFC_Element(result, data, cb);
		}}, function(err){ });
    }else{
        addReloadButton(data, event, reloadPart_eve);
    }
    
    ;function matchGplPartFC_Element(result, data, queueTaskCallBack){
    	result = complete_resultCheck(result, data);

        if(result.length == 0){ 
            queueTaskCallBack(null); 
            return; 
        }
        completeAMPartReslut(result, data, queueTaskCallBack, data['$partBacklogRow'], true);
    }
}

;function complete_AMTotalCycleFC(result, event, data){

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
	    					customRemoteAction(data, getAcct_js, complete_AMTotalCycleFC); //this is total remote action
    					}
    				});
    	
    }
    
    ;function setCycelReslut(oResult, $tds){
    	for(var o in oResult){
    		$tds.eq(data['qCell'][o]).html( Globalize.format(oResult[o], 'n') );
    	}
    }
}

;function completeAMPartReslut(result, data, queueTaskCallBack, $backlogRow, isGpl){
	var $part=$('#parttab'), $left_part=$part.find('tbody tr').clone(), $right_part=$part.find('tfoot tr').clone(), $all_tab=$('#div_body tbody.overbody'),
		gplCls=(isGpl ? (data['gid']+'_gpl') : ''), $append_right=$all_tab.filter('.rtbodycls').find('tr:eq('+$backlogRow.index()+')'),
		quarter_month={'month_cell': {}, 'quarter_cell': {}};

	setMatchCell(quarter_month);
	
	registerEvent($left_part, $right_part);
	hideForecastHead($right_part);
	
	var isFrezeen=data['$row'].parent().find( ('tr.rt0.'+data['code']+'_cls') ).find('input.unfreeze').length;

	asyncEachSeries_Original(result, function(item, callback){
    	var $l_clone=$left_part.clone(true), $r_clone=$right_part.clone(true);
    	$l_clone.addClass( (item['partId']+'_part '+data['code']+'_cls '+data['aid']+'_cls '+data['dataNum']+' '+gplCls) );
    	$l_clone.eq(0).attr({'title': item['partDesc'], 
    						 'data-root': 'root4', 'data-pid': item['partId'], 'data-gid': (isGpl ? data['gid'] : ''),
							 'data-code': data['code'], 'data-codecls': data['code']+'_cls', 'data-aid': data['aid'],
							 'data-aidcls': data['aid']+'_cls', 'data-cbc': data['cbc'], 'data-cbc-num': data['dataNum']})
    				.find('td:first div:first').addClass((isGpl ? '' : 'dpd_3')).removeClass((isGpl ? '' : 'dpd_4'))
    				.find('span.scell').html( item['fieldName']);
    	
    	formatFC((data['code'] == 'Relay' ? false : true), item['currentFC'], $r_clone.eq(0).find('td'), data['q_cell'], (data['code'] == 'Relay' ? '' : (isGpl ? 'gplpart' : 'otherpart') ));
    	formatFC(false, item['previousFC'], $r_clone.eq(1).find('td'), data['q_cell'], '');
    //	formatFC(false, item['amFC'], $r_clone.filter('.amFC').find('td'), data['q_cell'], '');
		
    	matchAMHistoryData( item['backlog'], quarter_month, $r_clone.filter('.backlog').find('td') );
    	matchAMHistoryData( item['billing'], quarter_month, $r_clone.filter('.billing').find('td') );
    	matchAMHistoryData( item['booking'], quarter_month, $r_clone.filter('.booking').find('td') );
    	
		var $inputs = $r_clone.eq(0).find('input[type="text"]').on('focus change', input_fc_eve).on('keyup', input_keyup_eve);
    	
    	if(isFrezeen == 0){ $inputs.attr('disabled', true); }
		
    	$backlogRow.after($l_clone);
    	$append_right.after($r_clone);
    	
    }, function(err){
		complete_remoteStatus(data, queueTaskCallBack);
    }, 120);
    
    ;function registerEvent($partRow_left, $partRow_right){
        $partRow_left.on('mouseenter mouseleave', overTable_eve)
        			 .eq(0).on('click', {$divbody: $('#div_body')}, clickLeftTable_eve);
        $partRow_right.on('mouseenter mouseleave', overTable_eve);
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
    
}

;function complete_resultAMCheck(result, data){
	result = $.parseJSON(result);
    if(result.length == 0){ 
        rowUnLock(data['rowIndex']);
        data.$row.removeClass('ready').addClass('done').find('td:first span.fcell').html('-').removeClass('waiting');
        return []; 
    }
    return result;
}

;function complete_getAMRefData(result, event, data){
	
	var $status_cell=data['$td'].find('table.pinstatus td.smonths[data-months="'+data['sMonths']+'"]');
	if(event.status){
		_queueTask.push({name: data['sMonths'], run: function(cb){
			var bookingFieldName=(data['root'] == 'root1' || data['root'] == 'root10' || data['root'] == 'root0' ? 'totalBooking' : 'booking'),
				billingFieldName=(data['root'] == 'root1' || data['root'] == 'root10' || data['root'] == 'root0' ? 'totalBilling' : 'billing'),
				backlogFieldName=(data['root'] == 'root1' || data['root'] == 'root10' || data['root'] == 'root0' ? 'totalBacklog' : 'backlog'),
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

;function complete_saveAMFc(result, event, data){
	
    _queueTask.push({name: (data['data']['$bar'].progressbar("value") || 0), run: function(cb){
		var isError = false;

        if(event.status){
            isError=false;
        }else{
            isError=true;
            data['msg'] = event;
            SAVE_ERRORS.push(data);
        }
    	progressStatusText((isError ? '#prg_err' : '#prg_scues'));	
        
        var percent=parseFloat(data['data']['$bar'].attr('data-value')), max=data['data']['max'];
	    
	    percent = ($.isNumeric(percent) ? percent : 0), 
	    percent = (data['data']['percent']+percent);

	    max = (Math.round(percent) >= data['data']['max'] ? 100 : percent);
		data['data']['$bar'].attr('data-value', percent).progressbar("value", max).find('div.progress-label').html(max.toFixed(2)+'%');
		LAZY.fire('', cb, 300);
    }}, function(err){ });
    
    ;function progressStatusText(_id){
    	$(_id).html(function(){
			var t = parseInt($.trim(this.innerHTML), 10);
			return ($.isNumeric(t) ? (t+1) : 0);
		});
    }
}

;function complete_getAPLAMRefData(result, event, data){
	
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

;function complete_getAPLAMBacklogRefData(result, event, data){
	
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
;function appendElementAMRelay_level3(data, callBack, callBackEnd){
	
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
	
	data['$left_template'].on('mouseenter mouseleave', overTable_eve).eq(0).attr({'data-root': 'root3'})
				.on('click', {$divbody: $('#div_body')}, clickLeftTable_eve)
				.find('span.pin').on('click', event_refAMData_click);
	data['$right_template'].on('mouseenter mouseleave', overTable_eve);

	asyncEachSeries_Original(data['list_result'], function(item, call){
		var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true);
		$lClone.addClass( (item['accnumber']+'_gpl '+data['data-code']+'_cls '+data['data-aid']+'_cls '+data['data-cbc-num']) ).eq(0)
				.attr({'data-code': data['data-code'], 'data-codecls': (data['data-code']+'_cls'), 'data-aid': data['data-aid'], 
					'data-aidcls': (data['data-aid']+'_cls'), 'data-cbc-num': data['data-cbc-num'], 'data-gid': item['accnumber'],
					'title': item['name'], 'data-cbc': data['data-cbc'], 'data-accnumber': item['accnumber']})
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
;function appendElementAMOther_level3(data, callBack, callBackEnd){
	
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
	data['$left_template'].on('mouseenter mouseleave', overTable_eve).eq(0).off('click').find('span.pin').css({'cursor':'pointer'}).on('click', event_refAMData_click);
	data['$left_template'].eq(0).removeClass('cp').find('span.mark_img').addClass('mark_b').removeClass('p');
	data['$right_template'].on('mouseenter mouseleave', overTable_eve);
//	data['$left_template'].eq(0).find('span.mark_img').addClass('mark_b').removeClass('p');
	
	asyncEachSeries_Original(data['list_result'], function(item, call){

		var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true);
		$lClone.addClass( (item['id']+' '+data['data-code']+'_cls '+data['data-aid']+'_cls '+data['data-cbc-num']) ).eq(0)
				.attr({'data-v1': data['data-code'], 'data-v2': data['data-aid'], 'data-v3': data['data-cbc-num'], 'data-v4': item['id'],
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
;function appendElementAMProduct_level4(data, callBack, callBackEnd){
	
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
	data['$left_template'].on('mouseenter mouseleave', overTable_eve).eq(0).attr({'data-root': 'root44'})
				.on('click', {$divbody: $('#div_body')}, clickLeftTable_eve).find('span.pin').on('click', event_refAMData_click);
	data['$right_template'].on('mouseenter mouseleave', overTable_eve);

	asyncEachSeries_Original(data['list_result'], function(item, call){

		var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true);
		$lClone.addClass( (item['id']+' '+data['data-code']+'_cls '+data['data-aid']+'_cls '+data['data-gid']+'_gpl '+data['data-cbc-num']) ).eq(0)
				.attr({'data-accnumber': item['accnumber'], 'data-cbc': data['data-cbc'], 'data-v5': item['id'], 'data-v4': data['data-gid'],
						'data-v3': data['data-cbc-num'], 'data-v2': data['data-aid'], 'data-v1': data['data-code'], 'title': item['name']})
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
;function appendElementAMPart_level5(data, callBack, callBackEnd){
	
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
	data['$left_template'].on('mouseenter mouseleave', overTable_eve).eq(0).removeClass('cp')
				.find('div.dpd_4').addClass('dpd_5').removeClass('dpd_4')
				.find('span.cellbox.fcell').addClass('pin spin').on('click', event_refAMData_click)
				.css({'cursor':'pointer'}).removeClass('fcell').html('&nbsp;');
	
	data['$right_template'].on('mouseenter mouseleave', overTable_eve);

	asyncEachSeries_Original(data['list_result'], function(item, call){

		var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true);
		$lClone.addClass( (item['id']+' '+data['data-v1']+'_cls '+data['data-v2']+'_cls '+data['data-v3']+' '+data['data-v4']+'_gpl '+data['data-v5']) ).eq(0)
				.attr({'data-acnumber': data['data-acnumber'], 'data-cbc': data['data-cbc'], 'title': ('[ '+item['name']+' ]-'+item['snumber']), 'data-v6': item['id'], 'data-v5': data['data-v5'],
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
;function matchAMHistoryData(items, quarter_month, $cells){
	for(var fcMonth in items){
		var q_cell=quarter_month['month_cell'][fcMonth], o_month=quarter_month['quarter_cell'][q_cell], 
			o_month_cell=o_month[fcMonth], isFuture=(o_month_cell['isQcell'] && !o_month_cell['isCurrent']),
			$cell=$cells.eq( (isFuture ? q_cell : o_month_cell['cell']) ), old=$cell.attr('data-old');
			
		old=($.isNumeric(old) ? parseFloat(old) : 0);
		old+=items[fcMonth];
		$cell.attr('data-old', old);
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

;function saveAMForecast(target){
	
	var list_save=[], o_quarter=getQuarterObject(), $l_trs=$('#ltabid tr'), $r_trs=$('#rtabid tr'),
		$progss=$('div.progress_cls'), $pBar=$progss.find('#progressbar').progressbar({ value: false }).attr('data-value', 0);
	
	$progss.find('#progresserror').css({'top': '-240%'});
	$progss.find('#saveProgressCover').show();
	
	createGPL_Object();
	createOther_Object();
	createOverAll_Object();
	//console.log(list_save);
	if(list_save.length == 0){ 
		$progss.find('#saveProgressCover').hide();
		return; 
	}
	
	var pAttr=getProgressAttr();
	
	$pBar.progressbar({ max: pAttr['max'], change: pBarChange, complete: pBarComplete })
		 .find('.ui-progressbar-value').css({ "background": '#' + pAttr['bgcolor'] });
		 
	$progss.show().find('#progresserror').css({'background': pAttr['rgba']}).animate({top: '10%'}, 360, animateComplete);
				
	asyncEachSeries_Original(list_save, function(item, callback){
		item['data']['percent'] = pAttr['percent'];
		item['data']['max'] = pAttr['max'];
		item['call']=complete_saveAMFc;
        customRemoteAction(item, saveForecast_js, item['call']); //this is remote action
    }, function(err){ }, 180);

    
	/* START save forecast Helper methods*/
    
    ;function createOverAll_Object(){
    	$r_trs.filter('.overrulerelayfctotal').each(function(){
    		var $this=$(this), fc_map={}, 
    			json_save={'className': 'ClsAPLEntityTypes.RSMAMOverRallInfo', 'str_json': '{}' };
    		
    		setFcValue(fc_map, $this.find('td'));
    		json_save['str_json'] = createOverAll_json(fc_map);
    		list_save.push( {'json': JSON.stringify(json_save), 'data': {'json': json_save, '$bar': $pBar, 'name': $this.find('span.scell').text()}} );
    	});
    }
    
	;function createGPL_Object(){
		
		$l_trs.filter('.rt3[data-cbc!="Relay"]').filter('[data-cbc!="Others"]').each(function(){
			var $gpl=$(this), tCode=$gpl.attr('data-code'), aId=$gpl.attr('data-aid'), cbcCode=$gpl.attr('data-cbc'),
                $actRow=$l_trs.filter('.rt1.'+$gpl.attr('data-codecls')+'.'+$gpl.attr('data-aidcls')),
				gplId=$gpl.attr('data-gid'), json_save={'className': 'ClsAPLEntityTypes.RSMGPLFCInfo', 'str_json': {}},
				list_parts=[], fc_map={};
			
			if($l_trs.filter('.rt0.'+$gpl.attr('data-codecls')).find('input.unfreeze').length == 0 || !$actRow.hasClass('done')){
				return true;	//continue for each.
			}
			
			setFcValue(fc_map, $r_trs.eq($gpl.index()).find('td'));
			create_part_json($gpl, aId, gplId, cbcCode, list_parts);
			
			json_save['str_json']=create_josn(tCode, aId, cbcCode, gplId, fc_map, list_parts);		
			list_save.push( {'json': JSON.stringify(json_save), 'data': {'json': json_save, '$bar': $pBar, 'name': $gpl.find('span.scell').text()}} );
		});
	}
	
	;function createOther_Object(){
		$l_trs.filter('.rt2[data-cbc="Others"]').each(function(){
			var $cbc=$(this), tCode=$cbc.attr('data-code'), aId=$cbc.attr('data-aid'), cbcCode=$cbc.attr('data-cbc'),
				$actRow=$l_trs.filter('.rt1.'+$cbc.attr('data-codecls')+'.'+$cbc.attr('data-aidcls')),
				json_save={'className': 'ClsAPLEntityTypes.RSMGPLFCInfo', 'str_json': {}}, list_part=[], fc_map={};

			if($l_trs.filter('.rt0.'+$cbc.attr('data-codecls')).find('input.unfreeze').length == 0 || !$actRow.hasClass('done')){
				return true;	//continue for each.
			}	
				
			
			setFcValue(fc_map, $r_trs.eq($cbc.index()).find('td'));
			list_part.push( create_other_part_json(null, null, fc_map) );
			json_save['str_json']=create_josn(tCode, aId, cbcCode, null, fc_map, list_part);
			list_save.push( {'json': JSON.stringify(json_save), 'data': {'json': json_save, '$bar': $pBar, 'name': $cbc.find('span.scell').text()}} );
		});
	}
	
	
	;function create_josn(tCode, aId, cbcCode, gplId, j_map, list_part){
		return '{"territoryCode": "'+tCode+'", "acctId": "'+aId+'", "cbc2Code": "'+cbcCode+'", '+
			   ' "quarterNumb": "'+o_quarter['qnumber']+'", "gplId": "'+gplId+'", "map_dateKey_fc": '+JSON.stringify(j_map)+', '+
			   ' "list_parts": ['+list_part.join(',')+'], "map_year_quartersFuture": '+o_quarter['qfuture']+' }';
	}
	
	;function create_part_json($gpl, aid, gid, cbcCode, list_part){
		var cls=('.rt4.'+$gpl.attr('data-codecls')+'.'+gid+'_gpl.'+aid+'_cls.'+$gpl.attr('data-cbc-num') );
		$l_trs.filter(cls).each(function(){
			var $part=$(this), json_map={}, str_json={};
			setFcValue(json_map, $r_trs.eq(this.rowIndex).find('td'));
			str_json = create_gpl_part_json(aid, gid, $part.attr('data-pid'), cbcCode, json_map);
			list_part.push(str_json);
		});
	}
	
	;function createOverAll_json(map_dateKey_fc){
		return '{"managerId": "'+$('#hidd_managerid').val()+'", "displayName": "'+$('#hidd_amdisplayname').val()+';'+$('#manualInputForecast').val()+'", '+
				'"map_year_quartersFuture": '+$('#hidd_yearfutureid').val()+', "map_dateKey_fc": '+JSON.stringify(map_dateKey_fc)+'}';
	}
	
	;function create_gpl_part_json(accId, gId, pId, cbcCode, map_dateKey_fc){
		return '{"acctId": "'+accId+'", "gplId": "'+gId+'", "cbc2Code": "'+cbcCode+'", "map_dateKey_fc": '+JSON.stringify(map_dateKey_fc)+','+
			   ' "partId": "'+pId+'" }';
	}
	;function create_other_part_json(accId, pId, map_dateKey_fc){
		return '{"acctId": "'+accId+'", "cbc2Code": "Others", "map_dateKey_fc": '+JSON.stringify(map_dateKey_fc)+','+
			   ' "partId": "'+pId+'" }';
	}
	
	;function setFcValue(fc_map, $tds){
		for(var o in o_quarter['ocell']){
			fc_map[o_quarter['ocell'][o]]=numberOfZero($.trim($tds.eq(o).find('input[type="text"]').val()));
		}
	}
	
	;function getQuarterObject(){
		var o= {'ocell': {}, 'qfuture': $('[id*=hidd_yearfutureid]').val(), 'qnumber': $('[id*=hidd_quarternumbid]').val()};
		$('#tab_head_list td.qcell').each(function(){
			o['ocell'][this.cellIndex] = this.getAttribute('data-date');
		});
		return o;
	}
	
	;function animateComplete(){
		$('#prg_total').html( list_save.length );
		$('#prg_scues').html(0);
		$('#prg_err').html(0);
	}
	
	;function getProgressAttr(){
		var percent=(1 / list_save.length * 100), max=Math.floor(percent*list_save.length),
			bg_color=Math.floor(Math.random()*16777215).toString(16), list_rgba=$.Color('#'+bg_color)._rgba,
			rgba=( 'rgba('+list_rgba[0]+','+list_rgba[1]+','+list_rgba[2]+',0.3)' );
		return {'percent': percent, 'max': max, 'bgcolor': bg_color, 'rgba': rgba};
	}
	/* END save forecast Helper methods*/
}

;function reloadAcct_eve(e){
    reload_public_eve(e, this, getAcct_js, complete_getAcct); //this account remote action
}
;function reloadCBC2_eve(e){
    reload_public_eve(e, this, getAcct_js, complete_getCBC2); //this account cbc2 action
}
;function reloadGPL_eve(e){
    reload_public_eve(e, this, getAcct_js, complete_getGPL); //this account gpl action
}
;function reloadPart_eve(e){
    reload_public_eve(e, this, getAcct_js, complete_getPart); //this account part action
}

