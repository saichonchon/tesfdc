var TIMEOUT, STATIC_VAR={}, scrollbarW=$.getScrollbarWidth(), QUEUE=async.queue(queueRun, 1),
	ISNEXT=false, LAZY = {
		'fire' : function(obj, callback, timeout) {
		    timeout = timeout || 200;
		    setTimeout(function() { callback(null, obj); }, timeout);
		}
	}, 
	DECIMAL_POINT = {'n': 'n', 'n0': 'n0', 'n1': 'n1', 'n4': 'n4'}, WORK_CLS = { };

;function queueRun(task, callback) {
    task.run(callback);
}

;function initDocument(){
	Globalize.culture(this.locale).numberFormat.currency.symbol = "";
	$('#menudivid').remove();
	try{
		WORK_CLS = $.parseJSON( $('#rsmtypeid').val() );
	}catch(e){
		
	}
	
	appendExpand_Collapse();
	$('#floatscroll').css({'height': scrollbarW, 'line-height': scrollbarW});
	register_event();
	fixTableLayout();
	finallyFormat();
	
}

;function finallyFormat(){
	
	var $lBody=$('#ltabid'), $rBody=$('#rtabid'), $head=$('#tab_head_list td'), $tcProduct=$rBody.find('tr.TCProducts td'),
		$realyTotalCells=$rBody.find('tr.NewRelayProducts td'), $relayProduct=$rBody.find('tr.OverallRelayProducts td'), 
		cellMonth={}, monthCell={}, ftCell=$head.filter('.crtQtotal')[0].cellIndex-1, qCellIndex={}, cellTotal={}, overAllTotal={};

	$head.filter('.futurecls').each(function(){
		if($(this).hasClass('futuretotalcls')){
			qCellIndex[this.cellIndex] = this.cellIndex
		}else{
			cellMonth[this.cellIndex] = this.getAttribute('data-date');
			monthCell[this.getAttribute('data-date')] = this.cellIndex;
		}
	});
	
	$rBody.find('tr.v1').each(function(){
		try{
			var $this=$(this), $nextCells=$this.next().find('td'), map_fc=$.parseJSON($this.attr('data-fc'));
			$this.find('td:gt('+ftCell+')').each(function(){
				if(!qCellIndex.hasOwnProperty(this.cellIndex)){
					var attr={'data-old': 0}, pmAttr={'data-old': 0};
					if(map_fc['csFC'] && map_fc['csFC'].hasOwnProperty( cellMonth[this.cellIndex] )){
						attr['data-old'] = (map_fc['csFC'][(cellMonth[this.cellIndex])]);	
					}
					cellTotal[this.cellIndex] = (getZeroOfNumber(cellTotal[this.cellIndex])+attr['data-old']);
					$(this).attr(attr).html( Globalize.format(attr['data-old'], DECIMAL_POINT['n']) );
					if(map_fc['pmFC'] && map_fc['pmFC'].hasOwnProperty( cellMonth[this.cellIndex] )){
						pmAttr['data-old'] = (map_fc['pmFC'][(cellMonth[this.cellIndex])]);	
					}
					$nextCells.eq(this.cellIndex).attr(pmAttr).html( Globalize.format(pmAttr['data-old'], DECIMAL_POINT['n']) );
				}
			});
		}catch(e){
		}
	});

	for(var cell in cellTotal){
		$tcProduct.eq(cell).attr({'data-old': cellTotal[cell]}).html( Globalize.format(cellTotal[cell], DECIMAL_POINT['n']) );
		$realyTotalCells.eq(cell).attr({'data-old': cellTotal[cell]}).html( Globalize.format(cellTotal[cell], DECIMAL_POINT['n']) );
	}

	$rBody.find('tr.overrelaychild').each(function(){
		var $tr=$(this), map_fc=$.parseJSON($tr.attr('data-fc'));
		$tr.find('td:gt('+ftCell+')').each(function(){
			if(!qCellIndex.hasOwnProperty(this.cellIndex)){
				var attr={'data-old': 0};
				if(map_fc && map_fc.hasOwnProperty( cellMonth[this.cellIndex] )){
					attr['data-old'] = (map_fc[(cellMonth[this.cellIndex])]);	
				}
				overAllTotal[this.cellIndex] = ( getZeroOfNumber(overAllTotal[this.cellIndex])+attr['data-old'] ) ;
				$(this).attr(attr).html( Globalize.format(attr['data-old'], DECIMAL_POINT['n']) );
			}
		});
	});
	
	for(var cell in overAllTotal){
		$relayProduct.eq(cell).attr({'data-old': overAllTotal[cell]}).html( Globalize.format(overAllTotal[cell], DECIMAL_POINT['n']) );
	}

	document.getElementById('loading-curtain-div').style.display='none';
	createRelayProduct(ftCell, qCellIndex, cellMonth, monthCell, $tcProduct);

	;function createRelayProduct(ftCell, qCellIndex, cellMonth, monthCell){
				console.log('a8');
		var _json={'cls': WORK_CLS['map_level_name']['Leveltotal'], 'json': {'managerId': $('[id*=managerid]').val(),
						'map_year_quartersFuture': $.parseJSON($('#mapquartersfuture').val()) 
					}, '$tcCells': $tcProduct, '$totalCells': $rBody.find('tr.Total td'), '$overAll': $rBody.find('tr.overrelaychild'),
					'ftCell': ftCell, 'qCellIndex': qCellIndex, 'cellMonth': cellMonth, 'monthCell': monthCell,
					'$lRow': $('#ltabid tr.RelayProducts'), '$rRow': $('#rtabid tr.RelayProducts td:gt('+ftCell+')'),
					'rowIndex': '', 'action': existObject_js, 'complete': complete_relayProduct
				};

		console.log( _json );
		if(_json['$lRow'].length == 0){
			return;
		}

		_json['json'] = JSON.stringify(_json['json']);
		_json['$lRow'].find('td:last').append('<span class="aspcell wating"></span>');
		customMultipleRemoteAction(_json, _json['action'], _json['complete']);
	}
}


;function register_event(){
	var $body_div = $('#div_body');
	
	$body_div.find('#ltabid tr.cp').off('click').on('click', event_existData_click)
				.find('span.pin').off('click').on('click', event_refData_click);
	$body_div.find('#ltabid tr.level0 span.pin').off('click').on('click', event_refData_click);
	
	$body_div.find('#rCellScroll').off('scroll').scroll(event_rCellScroll);
	$body_div.find('tbody.overbody tr').off('mouseenter mouseleave').on('mouseenter mouseleave', event_table_overout);  
	$('#menuBtntd input').off('click').on('click', event_hideCalendar_click);
	$(window).off('scroll').scroll(event_windowScroll).smartresize(windowReSize);
	$('#floatscroll').off('scroll').scroll(event_floatScroll);
}



;function event_table_overout(e){
    var $this=$(this), _idx=$this.index(), findTab=($this.parent().hasClass('ltbodycls') ? '#rtabid tr' : '#ltabid tr');
    eventHandle_ov_ot(e, ov, ot);
    
    ;function ov(e){ $(findTab).eq(_idx).addClass('overbodybg'); }
    ;function ot(e){ $(findTab).eq(_idx).removeClass('overbodybg'); }
}

;function event_existData_click(e){
//	e.stopPropagation();
	var hide = 'dn', list_element = [], $rightBody=$('#rtabid'), _this=this, $this=$(_this),
    	$leftBody=$this.parent(), $waiting=$this.find('td:first span.fcell'), $pin=$this.find('span.pin'),
    	config={'id': $this.attr('id'), 'data-level': $this.attr('data-level'), 'rowIndx': $this.index(), 'isRemote': false},
        fn = ($this.hasClass('exp')? exp : col);

    $this.find('td:first span.reload_span').remove();
    if(rowIsLocked(config['rowIndx'])){ return false; }

    fn();
    
    ;function exp(){
    	if(isLoadedSubData()){ return false; }
    	
    	var levelCls = '';
    	
    	switch(config['data-level']){
    		case 'level0' : levelCls='tr:not(.mark).'+config['id']+'_level0'; break;
    		case 'level1' : levelCls='tr:not(.level1).'+config['id']+'_level1'; break;
    		case 'level2' : levelCls='tr:not(.level2).'+config['id']+'_level2.'+$this.attr('data-v1')+'_level1'; break;
    		case 'level3' :
    				levelCls='tr:not(.level3).'+config['id']+'_level3.'+$this.attr('data-v2')+'_level2.'+$this.attr('data-v1')+'_level1';
    			break;
			case 'level4' :
					levelCls='tr:not(.level4).'+config['id']+'_level4.'+$this.attr('data-v3')+'_level3.'+$this.attr('data-v2')+'_level2.'+$this.attr('data-v1')+'_level1';
				break;
			case 'level4_4' :
					levelCls='tr:not(.level4_4).'+config['id']+'_level5.'+$this.attr('data-v4')+'_level4.'+$this.attr('data-v3')+'_level3.'+$this.attr('data-v2')+'_level2.'+$this.attr('data-v1')+'_level1';
				break;
    	}
    	QUEUE.push({name: config['rowIndx'], run: function(cb){
	        $leftBody.find(levelCls).addClass(hide).each(function(){
	            $rightBody.find('tr:eq('+this.rowIndex+')').addClass(hide).removeClass('level2 level3 level4 level5');
	            $(this).removeClass('exp col').first().addClass('col').find('span.pin').addClass('spin')
	            		.parent().find('span.fcell').html('+');
	        });
	        rowUnLock(config['rowIndx']);
	        $this.removeClass('exp').addClass('col');
			$rightBody.find('tr:eq('+$this.index()+')').removeClass(config['data-level']);
	        $waiting.html('+').removeClass('wating');
            cb(null);
        }}, function(err){ });
    }
    
    ;function col(){
    	
    	var remote_fn={'remote':function(p){}, 'rowIndex': config['rowIndx'], '$row': $this, 'data-groupname': $this.attr('data-groupname'), 'data-acnumber': $this.attr('data-acnumber'),
    					'data-code': $this.attr('data-code'), 'data-v1': $this.attr('data-v1'), 'data-v2': $this.attr('data-v2'), 'data-v3': $this.attr('data-v3'),
    					'data-v4': $this.attr('data-v4'), 'data-v5': $this.attr('data-v5'), 'data-number': $this.attr('data-number'), 'action': existObject_js, 'complete': complete_existObject
    				  }, levelCls='';
    	
    	$waiting.addClass('wating').html('&nbsp;');
    	
    	switch(config['data-level']){
    		case 'level0' : 	//this search sold to.
    				levelCls = 'tr:not(.sublevel).level0.'+config['id']+'_level0';
    			break;
    		case 'level1' : 	//this search sold to.
    				remote_fn['data-groupname'] = $.trim($this.find('span.namecell').text());
    				remote_fn['data-level'] = 'level2';
    				remote_fn['append'] = appendElement_Level2;
    				levelCls = 'tr.level2.mark.'+config['id']+'_level1';
    				remoteCheck(levelCls, remote_fn, createLevel2, WORK_CLS['map_level_name']['Level2']); 
    			break;
    		case 'level2' : 	//this search oem. 
    				remote_fn['data-level'] = 'level3';
    				remote_fn['append'] = appendElement_Level3;
    				levelCls = 'tr.level3.mark.'+config['id']+'_level2.'+$this.attr('data-v1')+'_level1';
    				var workCls=(remote_fn['data-code'] == 'Others' ? WORK_CLS['map_level_name']['LevelOther'] : WORK_CLS['map_level_name']['Level3']);
					
    				remoteCheck(levelCls, remote_fn, createLevel3,  workCls); 
    			break;
    		case 'level3' : 	//this search part. 
    				remote_fn['data-level'] = 'level4';
    				remote_fn['append'] = appendElement_Level4;
    				levelCls = 'tr.level4.mark.'+config['id']+'_level3.'+$this.attr('data-v2')+'_level2.'+$this.attr('data-v1')+'_level1';
    				var workCls=(remote_fn['data-code'] == 'Others' ? WORK_CLS['map_level_name']['LevelOther'] : WORK_CLS['map_level_name']['Level4']);

    				remoteCheck(levelCls, remote_fn, createLevel4, workCls); 
    			break;
    		case 'level4' : 	//this search part. 
    				remote_fn['data-level'] = 'level5';
    				remote_fn['append'] = appendElement_Level5;
    				if(remote_fn['data-code']=='Relay'){
    					levelCls='tr.level4_4.mark.'+config['id']+'_level4.'+$this.attr('data-v3')+'_level3.'+$this.attr('data-v2')+'_level2.'+$this.attr('data-v1')+'_level1';
    				}else{
	    				levelCls='tr.level5.mark.'+config['id']+'_level4.'+$this.attr('data-v3')+'_level3.'+$this.attr('data-v2')+'_level2.'+$this.attr('data-v1')+'_level1';
    				}
    				remoteCheck(levelCls, remote_fn, createLevel5, WORK_CLS['map_level_name']['Level5']); 
    			break;
    		case 'level4_4' : 	//this search part. 
    				remote_fn['data-level'] = 'level6';
    				remote_fn['append'] = appendElement_Level6;
    				levelCls = 'tr.level5.mark.'+config['id']+'_level5.'+$this.attr('data-v4')+'_level4.'+$this.attr('data-v3')+'_level3.'+$this.attr('data-v2')+'_level2.'+$this.attr('data-v1')+'_level1';
    				remoteCheck(levelCls, remote_fn, createLevel6, WORK_CLS['map_level_name']['Level6']); 
    			break;
    		default : break;
    	}
		console.log( remote_fn );
    	remote_fn['remote'](remote_fn);
    	expandElement(levelCls);

    }
    
    ;function remoteCheck(findCls, remoteFn, createJSON, actionClass){
    	if($this.hasClass('done')){ return; }
        config['isRemote'] = true;
        remoteFn['cls'] = actionClass;
        remoteFn['json'] = JSON.stringify( new createJSON() );
        remoteFn['remote'] = function(p){
        	customMultipleRemoteAction(p, remoteFn['action'], remoteFn['complete']); //this is remote action
        };
    }
    
    ;function createLevel2(){
    	ClsObjPrototype.call(this);	//extends base object
    	this['territoryCode'] = $.trim($this.find('span.namecell').text());
    }
    ;function createLevel3(){
    	ClsObjPrototype.call(this);	//extends base object
    	this['cbc2Code'] = $this.attr('data-code');
    	this['territoryCode'] = $this.attr('data-groupname');
    }
    ;function createLevel4(){
    	ClsObjPrototype.call(this);	//extends base object
    	this['territoryCode'] = $this.attr('data-groupname');
    	this['cbc2Code'] = $this.attr('data-code');
    	this['gplId'] = $this.attr('id');
    	this['relayCode'] = $this.attr('data-number');
    }
    ;function createLevel5(){
    	ClsObjPrototype.call(this);	//extends base object
    	this['territoryCode'] = $this.attr('data-groupname');
    	this['cbc2Code'] = $this.attr('data-code');
    	this['relayCode'] = $this.attr('data-number');
    	this['accnumber'] = $this.attr('data-acnumber');
    	this['gplId'] = $this.attr('id');
    }
    ;function createLevel6(){
    	ClsObjPrototype.call(this);	//extends base object
    	this['accnumber'] = $this.attr('data-number');
    	this['relayCode'] = $this.attr('data-acnumber');
    	this['cbc2Code'] = $this.attr('data-code');
    	this['grouping'] = $this.attr('data-v2');
    	this['rsmgrouping'] = $this.attr('data-groupname');
    }
    ;function ClsObjPrototype(){
    	this['managerId'] = $('[id*=managerid]').val();
    	this['map_year_quartersFuture'] = $.parseJSON($('#mapquartersfuture').val());
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
                	$rightBody.find('tr:eq('+item.rowIndex+')').removeClass(hide);
                    callback(null);
                }, 65);
            }, function(err){
            	list_element=[];
                if(!config['isRemote']){ 
                    rowUnLock(config['rowIndx']);
                    $waiting.html('-').removeClass('wating'); 
                }
                $this.removeClass('col').addClass('exp');
                $rightBody.find('tr:eq('+$this.index()+')').addClass(config['data-level']);
                cb(null);
            });
        }}, function(err){ });
    }
}

;function event_refData_click(e){
	e.stopPropagation();
	if($(this).hasClass('watingpin')){
		return;
	}
	var $this=$(this), $td=$this.parent().parent().parent(), $tr=$td.parent(), $billing=$tr.next().next(), 
		$booking=$billing.next(), $backlog=$booking.next(), execute=($this.hasClass('spin')? exp : col),
		attr={ 'findcls': '', 'json' : {}, 'cls': '', 'monthCell': {}, 'cellMonth': {}, 'crtCell': $('#tab_head_list td.crtQtotal')[0].cellIndex,
				'$pin': $this, '$row': $tr, 'managerId': $('[id*=managerid]').val(), 'level': $tr.attr('data-level'), 'id': $tr.attr('id'), 
				'data-v1': $tr.attr('data-v1'), 'data-v2': $tr.attr('data-v2'), 'data-v3': $tr.attr('data-v3'), 'data-v4': $tr.attr('data-v4'), 'data-v5': $tr.attr('data-v5'),
				'data-v6': $tr.attr('data-v6'), '$lbody': $tr.parent(), '$rbody': $('#rtabid'), '$billing': $billing, '$booking': $booking, '$backlog': $backlog, 
				'action' : getRefData_js, 'actionBacklog': getBacklogRefData_js, 'complete' : complete_refData, 'completeBacklog': complete_refDataBacklog,
				'cbc2Code': $tr.attr('data-code'), 'rsmgrouping': $tr.attr('data-groupname'), '$historicalCells': $('#tab_head_list td.historicalcls.qtotalCls, td.crtQtotal'),
				'data-number': $tr.attr('data-number'), '$futureCells': $('#tab_head_list td.qtotalCls'),
				'data-acnumber': $tr.attr('data-acnumber'), 'type': $tr.attr('data-fieldname')
			 };
		console.log(attr);
	switch(attr['level']){
		case 'level0':
			attr['$billing'] = $tr.next();
			attr['$booking'] = $tr.next().next();
			attr['$backlog'] = $tr.next().next().next();
			attr['cls'] = WORK_CLS['map_level_name']['Leveltotal'];
			attr['findcls'] = 'tr.sublevel.level0.'+attr['id']+'_level0sub';
			break;
		case 'level1':
			attr['rsmgrouping'] = $.trim($tr.find('span.namecell').html());
			attr['cls'] = WORK_CLS['map_level_name']['Level1'];
			attr['findcls'] = 'tr:not(.mark).level1.'+attr['id']+'_level1';
			break;
		case 'level2':
			attr['cls'] = WORK_CLS['map_level_name']['Level2'];
			attr['findcls'] = 'tr:not(.mark).level2.'+attr['id']+'_level2.'+attr['data-v1']+'_level1';
			break;
		case 'level3':
			attr['cls'] = (attr['cbc2Code'] == 'Others' ? WORK_CLS['map_level_name']['LevelOther'] : WORK_CLS['map_level_name']['Level3']);
		//	attr['cls'] = WORK_CLS['map_level_name']['Level3'];
			attr['findcls'] = 'tr:not(.mark).level3.'+attr['id']+'_level3.'+attr['data-v2']+'_level2.'+attr['data-v1']+'_level1';
			break;
		case 'level4':
			attr['cls'] = (attr['cbc2Code'] == 'Others' ? WORK_CLS['map_level_name']['LevelOther'] : WORK_CLS['map_level_name']['Level4']);
			attr['findcls'] = 'tr:not(.mark).level4.'+attr['id']+'_level4.'+attr['data-v3']+'_level3.'+attr['data-v2']+'_level2.'+attr['data-v1']+'_level1';
			if(attr['cbc2Code'] == 'Relay'){
				attr['data-v4']=attr['data-number'];
				attr['data-number']=$tr.attr('data-acnumber');
			}
			if(WORK_CLS['map_level_name']['Relay'] == 'true'){
				attr['data-v5']=$tr.attr('data-v4');
			}
			break;
		case 'level4_4':
			attr['cls'] = WORK_CLS['map_level_name']['Level5'];
			attr['findcls'] = 'tr:not(.mark).level4_4.'+attr['id']+'_level5.'+attr['data-v4']+'_level4.'+attr['data-v3']+'_level3.'+attr['data-v2']+'_level2.'+attr['data-v1']+'_level1';
			if(attr['cbc2Code'] == 'Relay'){
				attr['data-v4']=attr['data-number'];
				attr['data-number']=$tr.attr('data-acnumber');
			}
			break;
		case 'level5':
			if(attr['cbc2Code'] == 'Relay'){
				attr['cls'] = WORK_CLS['map_level_name']['Level6'];
				attr['findcls'] = 'tr:not(.mark).level5.'+attr['id']+'_level6.'+attr['data-v5']+'_level5.'+attr['data-v4']+'_level4.'+attr['data-v3']+'_level3.'+attr['data-v2']+'_level2.'+attr['data-v1']+'_level1';
				attr['data-v5']=attr['data-v6'];
            }else{
				attr['cls'] = WORK_CLS['map_level_name']['Level5'];
				attr['findcls'] = 'tr:not(.mark).level5.'+attr['id']+'_level5.'+attr['data-v4']+'_level4.'+attr['data-v3']+'_level3.'+attr['data-v2']+'_level2.'+attr['data-v1']+'_level1';
			}
			break;
	}

	execute();

	/* START Help function */
	;function exp(){
		if(!$this.hasClass('refdata')){
			$this.addClass('refdata');
			if(WORK_CLS['map_level_name']['Relay'] == 'true'){
				attr['$billing'].find('td:eq(1)').css({'position': 'relative'}).append('<span class="topcls">Quantity</span><span class="btmcls">Amount</span>');
				attr['$booking'].find('td:eq(1)').css({'position': 'relative'}).append('<span class="topcls">Quantity</span><span class="btmcls">Amount</span>');
				attr['$backlog'].find('td:eq(1)').css({'position': 'relative'}).append('<span class="topcls">Quantity</span><span class="btmcls">Amount</span>');
			}
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
		createMonths( list_months, $element, $('#tab_head_list td.currentcls, td.historicalcls:not(.qtotalCls)') );

		asyncEachSeries_Original(list_months, function(list_item, callback){
			var attr_tmp=$.extend({}, attr), list_q=[];
			for(var i=0, result; result=list_item[i]; i++){
				list_q.push(result);
			}
			attr_tmp['smonths'] = list_q.join(',');
			attr_tmp['json'] = {'set_fiscalMonth': list_q, 'territoryCode': attr['rsmgrouping'], 'accnumber': attr_tmp['data-number'],
								'relayCode': attr_tmp['data-v4'], 'partId': attr_tmp['data-v5'], 'managerId': attr_tmp['managerId'], 
								'type': attr_tmp['type'], 'gplId': attr_tmp['data-v3'], 'cbc2Code': attr_tmp['cbc2Code']};
			attr_tmp['json'] = JSON.stringify(attr_tmp['json']);
			customMultipleRemoteAction(attr_tmp, attr_tmp['action'], attr_tmp['complete']); //this is remote action
		}, function(err){}, 120);
		
	}
	
	;function createFutureStatus($element){
		var list_months=[];
		createFutureMonths(list_months, $element, $('#tab_head_list td.qtotalCls'));

		asyncEachSeries_Original(list_months, function(list_item, callback){
			var attr_tmp=$.extend({}, attr), list_q=[];
			for(var i=0, result; result=list_item[i]; i++){
				list_q.push(result);
			}
			attr_tmp['smonths'] = list_q.join(',');
			attr_tmp['json'] = {'set_fiscalMonth': list_q, 'territoryCode': attr['rsmgrouping'], 'accnumber': attr_tmp['data-number'],
								'relayCode': attr_tmp['data-v4'], 'partId': attr_tmp['data-v5'], 'managerId': attr_tmp['managerId'], 
								'type': attr_tmp['type'], 'gplId': attr_tmp['data-v3'], 'cbc2Code': attr_tmp['cbc2Code']};
			attr_tmp['json'] = JSON.stringify(attr_tmp['json']);
			customMultipleRemoteAction(attr_tmp, attr_tmp['actionBacklog'], attr_tmp['completeBacklog']); //this is remote action
		}, function(err){}, 120);
		
	}
	
	;function createFutureMonths(list_months, $element, $el_head){
		var list_result=[], el_body='<div class="ref_cover"><b class="reload_img reloadRef" style="display:none;"></b>';

		$el_head.each(function(){
			var cell=this.cellIndex, month=this.getAttribute('data-months');
			attr['monthCell'][month] = cell;
			attr['cellMonth'][cell] = month;
			list_result.push(month.split(','));
		});
		for(var i=0, result; result=list_result[i]; i++){
			list_months.push(result);
			el_body += '<b data-months="'+result.join(',')+'" data-status="false" class="ref_box">&nbsp;</b>';
		}
		el_body += '</div>';
		$element.find('td:first').append(el_body);
	}
	
	;function createMonths(list_months, $element, $el_head){
		var list_result=[], el_body='<div class="ref_cover"><b class="reload_img reloadRef" style="display:none;"></b>';

		$el_head.each(function(){
			var cell=this.cellIndex, month=this.getAttribute('data-month');
			attr['monthCell'][month] = cell;
			attr['cellMonth'][cell] = month;
			list_result.push(month);
		});
		for(var i=0, max=list_result.length; i<max; i+=3){
			var list_t=list_result.slice(i,i+3);
			list_months.push(list_t);
			el_body += '<b data-months="'+list_t.join(',')+'" data-status="false" class="ref_box">&nbsp;</b>';
		}
		el_body += '</div>';
		$element.find('td:first').append(el_body);
	}
	/* END Help function */
}

;function event_hideCalendar_click(e){
	
	var $this=$(this), $rHead=$('#rHeadBody'), $r_trs=$('#rtabid tr'),
		findCls='', excuteType=$this.attr('data-type'), status=$this.attr('data-status');
	
	QUEUE.push({name: 'hideCalendar', run: function(cb){
		
		switch(excuteType){
			case 'historical': findCls='historicalcls'; break;
			case 'current': findCls='currentcls, td.crtQtotal'; break;
			case 'future': findCls='futurecls:not(.crtQtotal)'; break;
		}
		console.log(findCls);
		
		$rHead.find('#tab_head_list td.'+findCls).each(function(){
			var $this=$(this), cellIndex=this.cellIndex;
			if(status == 'show'){
				$this.addClass('nhide');
				$r_trs.find('td:eq('+cellIndex+')').addClass('nhide');
			}else{
				$this.removeClass('nhide');
				$r_trs.find('td:eq('+cellIndex+')').removeClass('nhide');
			}
		});
		
		if(status == 'show'){
			$rHead.find('#tab_head_data th.'+findCls).addClass('nhide');
		}else{
			$rHead.find('#tab_head_data th.'+findCls).removeClass('nhide');
		}
		
		$this.val( (status == 'show' ? $this.attr('data-show') : $this.attr('data-hide')) );
		$this.attr('data-status', (status == 'show' ? 'hide' : 'show'));

		cb(null);
	}}, function(err){ });
}

;function event_floatScroll(e){
	try{
	    var _this=this;
	    if (TIMEOUT){ clearTimeout(TIMEOUT) };
	    
	    document.getElementById('right_head').scrollLeft = _this.scrollLeft;
	    $('#rCellScroll').off('scroll').scrollLeft(_this.scrollLeft);
	    TIMEOUT = setTimeout(function(){
		    $('#rCellScroll').off('scroll').on('scroll', event_rCellScroll);
	    }, 120);
	}catch(e){
		
	}
}

;function event_rCellScroll(e){
    var scLeft=this.scrollLeft;
    if (TIMEOUT){ clearTimeout(TIMEOUT) };
    document.getElementById('right_head').scrollLeft = scLeft;
    TIMEOUT = setTimeout(function(){
	    document.getElementById('floatscroll').scrollLeft = scLeft;
    }, 120);
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

;function event_cellExpand_Collapse_click(e){

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

;function event_reloadExistData_click(e, $this){
	var _data = e.data.$data;
	rowIsLocked(_data['rowIndex']);
    customMultipleRemoteAction(_data, _data['action'], _data['complete']);
    $this.remove();
}

;function setTemplateElement(data){
	var monthCell={}, cellMonth={}, $head=$('#tab_head_list td'), 
		list_hidden_td=$head.filter('.dn').toArray(), list_nhide_td=$head.filter('.nhide').toArray(), 
		ftCell=$head.filter('.crtQtotal')[0].cellIndex-1;
	
	$head.filter('.futurecls:not(.futuretotalcls)').each(function(){
		cellMonth[this.cellIndex] = this.getAttribute('data-date');
		monthCell[this.getAttribute('data-date')] = this.cellIndex;
	});
	data['cellMonth'] = cellMonth;
	data['monthCell'] = monthCell;
	data['ftCell']=ftCell;

	switch(data['data-level']){
		case 'level2' :
			data['$left'] = data['$row'].next().next().next().next();
			data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');
			data['$left_template'] = $('#level2_left tr').clone();
			data['$right_template'] = $('#level2_right tr').clone();
			data['$left_template'].eq(0).find('span.mark_img').addClass('c').removeClass('a');
			break;
		case 'level3' :
			data['$left'] = data['$row'].next().next().next().next();
			data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');
			data['$left_template'] = $('#level3_left tr').clone();
			data['$right_template'] = $('#level3_right tr').clone();
			data['$left_template'].eq(0).find('span.mark_img').addClass('g').removeClass('c');
			break;
		case 'level4' :
			data['$left'] = data['$row'].next().next().next().next();
			data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');
			data['$left_template'] = $('#level4_left tr').clone();
			data['$right_template'] = $('#level4_right tr').clone();
			data['$left_template'].eq(0).find('span.mark_img').addClass('p').removeClass('g');
			break;
		case 'level5' :
			data['$left'] = data['$row'].next().next().next().next();
			data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');
			
			if(data['data-code'] == 'Relay'){
				data['$left_template'] = $('#level4_left tr').clone();
				data['$right_template'] = $('#level4_right tr').clone();
				data['$left_template'].eq(1).remove();
				data['$right_template'].eq(1).remove();
				data['$left_template'].removeClass('level4').addClass('level4_4')
							.eq(0).addClass('external cp mark').attr({'data-level': 'level4_4'})
							.find('div.dis_ib.mgleft4').addClass('mgleft5').removeClass('mgleft4');
							
			}else{
				data['$left_template'] = $('#level5_left tr').clone();
				data['$right_template'] = $('#level5_right tr').clone();
				data['$left_template'].eq(0).find('span.pin').on('click', event_refData_click);
			}
			break;
		case 'level6' :
			data['$left'] = data['$row'].next().next().next().next();
			data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');
			data['$left_template'] = $('#level5_left tr').clone();
			data['$right_template'] = $('#level5_right tr').clone();
			data['$left_template'].eq(0).find('span.pin').on('click', event_refData_click);
			break;
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
	
	data['$left_template'].on('mouseenter mouseleave', event_table_overout).filter('.cp')
						  .on('click', event_existData_click).find('span.pin').on('click', event_refData_click);
	data['$right_template'].on('mouseenter mouseleave', event_table_overout);
	event_windowScroll();
}

;function appendElement_Level2(data, callBack, callBackEnd){
	console.log(data);
	asyncEachSeries_Original(data['list_result'], function(item, call){

		var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true);
		
		$lClone.addClass( (data['data-v1']+'_level1 '+item['id']+'_level2 ') ).eq(0)
				.attr({'id': item['id'], 'data-v1': data['data-v1'], 'data-v2': item['id'], 'title': item['name'], 
						'data-code': item['accnumber'], 'data-groupname': data['data-groupname']})
				.find('div:first').parent().find('span.namecell').html(item['name']);

		setFieldValue($rClone.eq(0).find('td:gt('+data['ftCell']+')'), data, item['map_type_FC']['csFC']);
		setFieldValue($rClone.eq(1).find('td:gt('+data['ftCell']+')'), data, item['map_type_FC']['pmFC']);

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
				$(this).attr(attr).html( Globalize.format(attr['data-old'], DECIMAL_POINT['n']) );
			}
		//	if(!data['cellMonth'].hasOwnProperty(this.cellIndex)){ }
		});
	}
	
}

;function appendElement_Level3(data, callBack, callBackEnd){
	
	var pricePoint=$('#pricepoint').val();
	if(WORK_CLS['map_level_name']['Relay'] == 'true'){
		data['$left_template'].eq(0).find('span.mark_img').addClass('mark_new').removeClass('g');
	}else{
		if(data['data-code'] == 'Others'){
			data['$left_template'].eq(0).off('click').removeClass('cp').find('span.mark_img').addClass('mark_b').removeClass('g')
					.parent().find('span.pin').css({'margin-left': '0px'}).parent().find('span.cellbox.fcell').remove();
		}
	}
	
	asyncEachSeries_Original(data['list_result'], function(item, call){

		var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true);
		
		$lClone.addClass( (data['data-v1']+'_level1 '+data['data-v2']+'_level2 '+item['id']+'_level3 ') ).eq(0)
				.attr({'id': item['id'], 'data-v1': data['data-v1'], 'data-v2': data['data-v2'], 'data-v3': item['id'], 
						'title': item['name'], 'data-number': item['accnumber'], 'data-code': data['data-code'], 
						'data-groupname': data['data-groupname']})
				.find('div:first').parent().find('span.namecell').html(item['name']);

		setFieldValue($rClone.eq(0).find('td:gt('+data['ftCell']+')'), data, item['map_type_FC']['csFC']);
		setFieldValue($rClone.eq(1).find('td:gt('+data['ftCell']+')'), data, item['map_type_FC']['pmFC']);
		/*
		if(WORK_CLS['map_level_name']['Relay'] == 'true'){
			$lClone.eq(0).find('td:last').append('<b class="brelaycls">'+Globalize.format(item['price'], ('n'+pricePoint))+'</b>');
		}
		*/
		/*mark_new
		if(item['accnumber'] == 'Others'){
			$lClone.eq(0).removeClass('cp').off('click').find('span.pin')
					.css({'margin-left': '0px'}).parent().find('span.cellbox.fcell').remove();
		}
		if(data['data-code'] != 'Relay'){
			point = DECIMAL_POINT['n0'];
		}
		*/
		data['$left'].after($lClone);
		data['$right'].after($rClone);
		
	}, function(err){
		callBackEnd(callBack, data);
	}, 150);
	
	
	;function setFieldValue($rCell, data, fc){
		var point = (DECIMAL_POINT['n']); 

		$rCell.each(function(){
			var attr = { 'data-old': 0 };
			if(fc && fc.hasOwnProperty( data['cellMonth'][this.cellIndex] )){
				attr['data-old'] = (fc[(data['cellMonth'][this.cellIndex])]);	
			}
			$(this).attr(attr).html( Globalize.format(attr['data-old'], point) );
		});
		/*
		$rCell.each(function(){
			var attr = { 'data-old': 0 };
			if(fc && fc.hasOwnProperty( data['cellMonth'][this.cellIndex] )){
				attr['data-old'] = (fc[(data['cellMonth'][this.cellIndex])]);	
			}
			$(this).attr(attr).html( Globalize.format(attr['data-old'], DECIMAL_POINT['n']) );
		});
		*/
	}
	
}

;function appendElement_Level4(data, callBack, callBackEnd){
	
	if(WORK_CLS['map_level_name']['Relay'] == 'true'){
		data['$left_template'].eq(0).off('click').removeClass('cp').find('span.cellbox.pin').css({'margin-left': '0px'})
				.parent().find('span.cellbox.fcell').remove();
	}else{
		if(data['data-code'] == 'Relay'){
			data['$left_template'].eq(0).find('span.mark_img').addClass('mark_new').removeClass('p');
		}else{
			data['$left_template'].eq(0).off('click').removeClass('cp').find('div.dis_ib.mgleft4')
						.addClass('mgleft5').removeClass('mgleft4').find('span.cellbox.fcell').remove();
		}
	}
	
	if(data['data-code'] == 'Others'){
		data['$left_template'].eq(0).off('click').removeClass('cp').find('span.cellbox.fcell').remove();
		data['$left_template'].eq(0).find('span.mark_img').addClass('mark_b').removeClass('g')
					.parent().find('span.cellbox.pin').css({'margin-left': '0px'});
		data['$left_template'].eq(1).remove();
		data['$left_template'].eq(1).remove();
		data['$right_template'].eq(1).remove();
		data['$right_template'].eq(1).remove();
	}

	if(WORK_CLS['map_level_name']['Relay'] == 'true'){
		data['$left_template'].eq(0).find('span.mark_img').addClass('p').removeClass('g');
	}
	var pricePoint=$('#pricepoint').val();
	console.log( data );
	asyncEachSeries_Original(data['list_result'], function(item, call){

		var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true);
		console.log(item);
		$lClone.addClass( (data['data-v1']+'_level1 '+data['data-v2']+'_level2 '+data['data-v3']+'_level3 '+item['id']+'_level4 ') ).eq(0)
				.attr({'id': item['id'], 'data-v1': data['data-v1'], 'data-v2': data['data-v2'], 'data-v3': data['data-v3'], 'data-v4': item['id'], 
						'data-number': data['data-number'], 'data-acnumber': item['accnumber'], 'data-code': data['data-code'], 'data-groupname': data['data-groupname'], 'title': item['snumber']})
				.find('div:first').parent().find('span.namecell').html(item['name']);
		
		if(data['data-code'] != 'Others'){
			setFieldValue($rClone.eq(0).find('td:gt('+data['ftCell']+')'), data, item['map_type_FC']['csFC']);
			setFieldValue($rClone.eq(1).find('td:gt('+data['ftCell']+')'), data, item['map_type_FC']['pmFC']);
		}
		if(item['isHighLighted'] && data['data-code'] != 'Others' && data['data-code'] != 'Relay'){
			$lClone.find('td:first span:first').before('<div class="highLighted"></div>');
		}
		/*
		if(WORK_CLS['map_level_name']['Relay'] == 'true' || data['data-code'] == 'Relay'){
			$lClone.eq(0).find('td:last').append('<b class="brelaycls">'+Globalize.format(item['price'], ('n'+pricePoint))+'</b>');
		}
		*/
		data['$left'].after($lClone);
		data['$right'].after($rClone);
		
	}, function(err){
		callBackEnd(callBack, data);
	}, 150);
	
	
	;function setFieldValue($rCell, data, fc){
		var point = (DECIMAL_POINT['n']); 
		
		$rCell.each(function(){
			var attr = { 'data-old': 0 };
			if(fc && fc.hasOwnProperty( data['cellMonth'][this.cellIndex] )){
				attr['data-old'] = (fc[(data['cellMonth'][this.cellIndex])]);	
			}
			$(this).attr(attr).html( Globalize.format(attr['data-old'], point) );
		});
	}
	
}

;function appendElement_Level5(data, callBack, callBackEnd){
	if(data['data-code'] == 'Relay'){
		data['$left_template'].eq(0).off('click').removeClass('cp').find('span.mark_img').addClass('p').removeClass('g')
			.parent().find('span.cellbox.pin').css({'margin-left': '0px'}).parent().find('span.cellbox.fcell').remove();
	}else{
		data['$left_template'].eq(0).off('click');
	}
	var pricePoint=$('#pricepoint').val();
	asyncEachSeries_Original(data['list_result'], function(item, call){

		var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true);
		
		$lClone.addClass( (data['data-v1']+'_level1 '+data['data-v2']+'_level2 '+data['data-v3']+'_level3 '+data['data-v4']+'_level4 '+item['id']+'_level5 ') ).eq(0)
				.attr({'id': item['id'], 'data-v1': data['data-v1'], 'data-v2': data['data-v2'], 'data-v3': data['data-v3'], 'data-v4': data['data-v4'], 'data-v5': item['id'],
						'data-acnumber': data['data-acnumber'], 'data-number': data['data-number'], 'data-code': data['data-code'], 'data-groupname': data['data-groupname'], 'title': item['name']})
				.find('div:first').parent().find('span.namecell').html(item['name']);
		
		if(WORK_CLS['map_level_name']['Relay'] == 'true'){
			$lClone.eq(0).attr({'title': item['name']}).find('span.namecell').html(item['accnumber']);
		//	$lClone.eq(0).find('td:last').append('<b class="brelaycls">'+Globalize.format(item['price'], ('n'+pricePoint))+'</b>');
		}
		if(data['data-code'] == 'Relay' && WORK_CLS['map_level_name']['Relay'] == 'false'){
		//	$lClone.eq(0).find('td:last').append('<b class="brelaycls">'+Globalize.format(item['price'], ('n'+pricePoint))+'</b>');
		}
		setFieldValue($rClone.eq(0).find('td:gt('+data['ftCell']+')'), data, item['map_type_FC']['csFC']);
		setFieldValue($rClone.eq(1).find('td:gt('+data['ftCell']+')'), data, item['map_type_FC']['pmFC']);
		if(item['isHighLighted'] && data['data-code'] == 'Relay'){
			$lClone.find('td:first span:first').before('<div class="highLighted"></div>');
		}
		
		data['$left'].after($lClone);
		data['$right'].after($rClone);
		
	}, function(err){
		callBackEnd(callBack, data);
	}, 150);
	
	
	;function setFieldValue($rCell, data, fc){
		var point = (DECIMAL_POINT['n']); 
		if(data['data-code'] == 'Relay' && WORK_CLS['map_level_name']['Relay'] == 'false'){
			point=DECIMAL_POINT['n0'];
		}
		$rCell.each(function(){
			var attr = { 'data-old': 0 };
			if(fc && fc.hasOwnProperty( data['cellMonth'][this.cellIndex] )){
				attr['data-old'] = (fc[(data['cellMonth'][this.cellIndex])]);	
			}
			$(this).attr(attr).html( Globalize.format(attr['data-old'], point) );
		});
	}
	
}
;function appendElement_Level6(data, callBack, callBackEnd){
	var pricePoint=$('#pricepoint').val();
	data['$left_template'].eq(0).off('click').find('div.mgleft5').css({'margin-left': '155px'});
	asyncEachSeries_Original(data['list_result'], function(item, call){

		var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true);
		
		$lClone.addClass( (data['data-v1']+'_level1 '+data['data-v2']+'_level2 '+data['data-v3']+'_level3 '+data['data-v4']+'_level4 '+data['data-v5']+'_level5 '+item['id']+'_level6 ') ).eq(0)
				.attr({'id': item['id'], 'data-v1': data['data-v1'], 'data-v2': data['data-v2'], 'data-v3': data['data-v3'], 'data-v4': data['data-v4'], 'data-v5': data['data-v5'], 'data-v6': item['id'],
						'data-number': data['data-number'], 'data-acnumber': data['data-acnumber'], 'data-code': data['data-code'], 'data-groupname': data['data-groupname'], 'title': item['name']})
				.find('div:first').parent().find('span.namecell').html(item['accnumber']);
		
		setFieldValue($rClone.eq(0).find('td:gt('+data['ftCell']+')'), data, item['map_type_FC']['csFC']);
		setFieldValue($rClone.eq(1).find('td:gt('+data['ftCell']+')'), data, item['map_type_FC']['pmFC']);
		//	$lClone.eq(0).find('td:last').append('<b class="brelaycls">'+Globalize.format(item['price'], ('n'+pricePoint))+'</b>');
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

;function appendExpand_Collapse(){//append (expand or collapse)
    var $thead=$('#tab_head_list'), $td_cells=$thead.find('td.exp_coll'), $total_cells=$thead.find('td.futurecls.qtfcls');
    
    $td_cells.off('click').on('click', event_cellExpand_Collapse_click).find('div').append('<b class="exp_coll_box collapse">-</b>');
    $td_cells.each(function(idx){ if(idx < 4){ $(this).triggerHandler('click'); } });
}

;function complete_existObject(result, event, data){	//complete remoteaction result
	
	QUEUE.push({name: data['rowIndex'], run: function(cb){
		if(event.status){
			complete_remoteResultCheck(result, data, cb, data['append'], complete_appendElementEND);
	    }else{ 
			complete_errorReload(data, event, event_reloadExistData_click);
			cb(null);
	    }
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

;function complete_refData(result, event, data){
	console.log( data );
	QUEUE.push({name: data['level'], run: function(cb){
		var $status_cell=data['$billing'].find('td:first b.ref_box[data-months="'+data['smonths']+'"]').eq(0);
		if(event.status){
			result = $.parseJSON(result);
			var $billing=data['$rbody'].find('tr:eq('+data['$billing'].index()+')'), 
				$booking=data['$rbody'].find('tr:eq('+data['$booking'].index()+')'), 
				billing=result['map_billingrefdata'], booking=result['map_bookingrefdata'];

			matchRefData(billing, data, $billing.find('td'), result['map_billingrefdataQty']);
			matchRefData(booking, data, $booking.find('td'), result['map_bookingrefdataQty']);
			
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
    ;function matchRefData(refData, data, $cell, refQty){
    	var monthCell = data['monthCell'];
    	if(WORK_CLS['map_level_name']['Relay'] == 'true'){
	    	for(var r in refData){
	    		if(monthCell.hasOwnProperty(r)){
	    			$cell.eq(monthCell[r]).attr({'data-old': refData[r], 'data-qty': refQty[r]}).html( 
	    				'<div>'+Globalize.format(refQty[r], 'n0')+'</div><div style="background-color: rgb(179, 225, 254);">'+Globalize.format(refData[r], 'n')+'</div>'
	    			);
	    		}
	    	}
	    	var cellIdx=data['$historicalCells'].filter('[data-months="'+data['smonths']+'"]')[0].cellIndex,
	    		$qCell=$cell.eq(cellIdx), $q3=$qCell.prev(), $q2=$q3.prev(), $q1=$q2.prev(),
	    		q1=getZeroOfNumber($q1.attr('data-old')), q2=getZeroOfNumber($q2.attr('data-old')), q3=getZeroOfNumber($q3.attr('data-old')),
	    		qty1=getZeroOfNumber($q1.attr('data-qty')), qty2=getZeroOfNumber($q2.attr('data-qty')), qty3=getZeroOfNumber($q3.attr('data-qty'));
	    	
	    	$qCell.html( 
	    		'<div>'+Globalize.format((qty1+qty2+qty3), 'n0')+'</div><div style="background-color: rgb(179, 225, 254);">'+Globalize.format((q1+q2+q3), 'n')+'</div>'
	    	);
    	}else{
	    	for(var r in refData){
	    		if(monthCell.hasOwnProperty(r)){
	    			$cell.eq(monthCell[r]).attr({'data-old': refData[r]}).html( Globalize.format(refData[r], DECIMAL_POINT['n']) );
	    		}
	    	}
	    	var cellIdx=data['$historicalCells'].filter('[data-months="'+data['smonths']+'"]')[0].cellIndex,
	    		$qCell=$cell.eq(cellIdx), $q3=$qCell.prev(), $q2=$q3.prev(), $q1=$q2.prev(),
	    		q1=getZeroOfNumber($q1.attr('data-old')), q2=getZeroOfNumber($q2.attr('data-old')), q3=getZeroOfNumber($q3.attr('data-old'));
	    	$qCell.html( Globalize.format((q1+q2+q3), DECIMAL_POINT['n']) );
    	}

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

;function complete_refDataBacklog(result, event, data){
	console.log(data);
	QUEUE.push({name: data['level'], run: function(cb){
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
			matchRefData(backlog, data, $backlog.find('td'), result['map_backlogrefdataQty']);
	    }else{
			reLoadRefData($status_cell, data);
	    }
		cb(null);
    }}, function(err){ });
	
    
    /*HELP methods*/
    ;function matchRefData(refData, data, $cell, refQty){
    	var total=0, qtyTotal=0, cellIdx=data['$futureCells'].filter('[data-months="'+data['smonths']+'"]')[0].cellIndex;
    	if(WORK_CLS['map_level_name']['Relay'] == 'true'){
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
    	}else{
	    	if(cellIdx < data['crtCell'] || cellIdx == data['crtCell']){
	    		var monthCell = data['monthCell'];
		    	for(var r in refData){
		    		if(monthCell.hasOwnProperty(r)){
		    			$cell.eq(monthCell[r]).attr({'data-old': refData[r]}).html( Globalize.format(refData[r], DECIMAL_POINT['n']) );
		    		}
		    	}
		    	var cIdx=data['$historicalCells'].filter('[data-months="'+data['smonths']+'"]')[0].cellIndex,
		    		$qCell=$cell.eq(cIdx), $q3=$qCell.prev(), $q2=$q3.prev(), $q1=$q2.prev(),
		    		q1=getZeroOfNumber($q1.attr('data-old')), q2=getZeroOfNumber($q2.attr('data-old')), q3=getZeroOfNumber($q3.attr('data-old'));
		    	$qCell.html( Globalize.format((q1+q2+q3), DECIMAL_POINT['n']) );
	    	}else{
		    	for(var r in refData){ total += refData[r]; }
		    	$cell.eq(cellIdx).html( Globalize.format(total, DECIMAL_POINT['n']) );
	    	}
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

;function complete_relayProduct(result, event, data){

	if(event.status){
		result = $.parseJSON(result);
		
		var cellTotal={}, cellTmpTotal={};

		data['$rRow'].each(function(){
			if(!data['qCellIndex'].hasOwnProperty(this.cellIndex)){
				var attr={'data-old': 0}, pmAttr={'data-old': 0};
				if(result && result.hasOwnProperty( data['cellMonth'][this.cellIndex] )){
					attr['data-old'] = (result[(data['cellMonth'][this.cellIndex])]);	
				}
				cellTotal[this.cellIndex] = (getZeroOfNumber(cellTotal[this.cellIndex])+attr['data-old']);
				$(this).attr(attr).html( Globalize.format(attr['data-old'], DECIMAL_POINT['n']) );
			}
		});

		for(var cell in cellTotal){
			var $this=data['$tcCells'].eq(cell), t=getZeroOfNumber($this.attr('data-old'));
			t=(t-cellTotal[cell]);
			$this.attr({'data-old': t}).html( Globalize.format(t, DECIMAL_POINT['n']) );
			cellTmpTotal[cell] = (getZeroOfNumber(cellTmpTotal[cell])+t);
		}

		data['$overAll'].each(function(){
			var $tds=$(this).find('td');
			for(var cell in cellTmpTotal){
				var t=getZeroOfNumber($tds.eq(cell).attr('data-old'));
				cellTmpTotal[cell] = (cellTmpTotal[cell]+t);
			}
		});

		for(var cell in cellTmpTotal){
			data['$totalCells'].eq(cell).html( Globalize.format(cellTmpTotal[cell], DECIMAL_POINT['n']) );
		}
		data['$lRow'].find('span.aspcell').remove();

    }else{
		var el_reload = '<span class="reload_span" style="top:3px;cursor: pointer;"><span class="reload_img"></span><b class="reload_msg">'+event['message']+'</b></span>';
    	data['$lRow'].find('td:last span').before(el_reload)
            .parent().find('span.reload_span').on('click', {$data: data}, function(e){
            	e.stopPropagation();
            	$(this).off('click').remove();
            	customMultipleRemoteAction(data, data['action'], data['complete']);
            });
    }
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


;function windowReSize(e){
    $('#forecastdiv_id').css({'visibility': 'hidden'});
    fixTableLayout($('#tabContainer').width(), false);
}

;function rowUnLock(_rowIndex){  //unlocked current row Repeat click event
    setTimeout(function(){ delete STATIC_VAR[_rowIndex]; }, 45);    //unlocked
}
;function rowIsLocked(_rowIndex){    //locked current row Repeat click event
    if(STATIC_VAR.hasOwnProperty(_rowIndex)){ return true; }    //locked 
    STATIC_VAR[_rowIndex] = '';
    return false;
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