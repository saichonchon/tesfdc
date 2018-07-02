var oldValue='', scrollbarW = $.getScrollbarWidth(), timeStatus = {}, list_color=[],
	connectionStatus={}, list_gSave = [];
;function initDocumentPage(){
    Globalize.culture(this.locale).numberFormat.currency.symbol = "";
	list_color=$.parseJSON(document.getElementById('colorid').value);

    freshDocumentPage();
}
;function saveGSM(target){
    matchSaveData();    //push Global arrays

    if(list_gSave.length == 0){
        artMsg($label['notdata'], target, function(target){});
        return;
    }
    
    $('[id*=savejsonid]').val(list_gSave.shift());
    saveGSMForecast();  //this is action function
    
    ;function matchSaveData(){
        var tmp, map_cells=new customMap(), $body=$('#rTabId'), list_save=[];
        $('#rsmHeadId td.futurec:not(.cfixqtotalw)').each(function(){
            tmp={'cell':this.cellIndex, 'workingdays':this.getAttribute('workingdays'), 'fyear':(this.getAttribute('fyear')+'-'+this.getAttribute('fmonth'))};
            map_cells.put(this.cellIndex, tmp);
        });

        $body.find('tr.findTab').each(function(){
            var _row=this;
            for(var i=0, _cell; _cell=map_cells.keys()[i]; i++){
                tmp = {'gsmName': _row.getAttribute('gsmname'), 'gsmDate':map_cells.get(_cell).fyear,
                			'fc': numberTrimHasKMBTOfZero( $(_row.cells[_cell]).find('input[type="text"]').val() )
            			  };
                list_save.push(tmp);
            }
        });
        map_cells.clear();
        tmp=$body=null;
        list_gSave=[];
        for(var i=0,len=list_save.length;i<len;i+=1000){
            var t = '{"RSMForecastItem" : '+ JSON.stringify(list_save.slice(i,i+1000)) +'}';
            list_gSave.push(t);
        }
        list_save=null;
    }
    
}
;function saveGSMForecastComplete(){
    if(list_gSave.length > 0){
        $('[id*=savejsonid]').val(list_gSave.shift());
        saveGSMForecast();     //this is action function
        return;
    }
    loadingAnimate();
}
;function clsPop(){
	$('#popCtn').fadeOut('slow', function(){
        document.getElementById('popCmt').className='hide';
    });
}
;function showComment(target, year, id){
	var list_ids = [], $target = $(target), $td = $target.parent().parent(), ocls = $td.parent()[0].getAttribute('ocls');
	
	$('#rTabId tr.fn_'+ocls).each(function(){
		list_ids.push(this.getAttribute('ocls'));
	});
	$('[id*=fdateid]').val(year);
	$('[id*=fid]').val(JSON.stringify(list_ids));
	document.getElementById('tmpvalid').innerHTML = $('#rsmHeadId td:eq('+$td[0].cellIndex+') span').text();
	
	actionRSMComments();		//this is action function
}
;function actionRSMCommentsComplete(){
	$('#popCtn').fadeIn('slow');
	$('#commentBodyId td.rsmvaluecls').html(function(){
		var val=Globalize.format( roundToKM(numberOfZero($.trim(this.innerHTML))), 'n0');
		return val;
	});
    document.getElementById('popCmt').className='';
	document.getElementById('popTitle').innerHTML = document.getElementById('tmpvalid').innerHTML;
    loadingAnimate();
}
;function searchRegion(target){
    $('[id*=sregionid]').val($('#regionselectid option:selected').val());
    document.getElementById('defidivid').className='dn';
    init(); //this is action function
}
;function initComplete(){
    freshDocumentPage();
}
;function freshDocumentPage(){
	
    setTimeout(function(){ appendExpand_Collapse(); }, 300);
    setBodyStyle();
    document.getElementById('defidivid').className='';
    
    $('#rCellScroll').scroll(rCellScroll_eve);
//	$('#menudivid').off('mouseenter mouseleave').on('mouseenter mouseleave', menu_over_eve);
	
	$('#menudivid').hoverDelay({hoverEvent: menuHover_eve, hoverDuring: 450,outEvent: menuOut_eve,outDelay: 200});

	
	$('#gsmmenu').off('mouseenter mouseleave').on('mouseenter mouseleave', menu1_over_eve);
    var $lCell=$('#lcellbody'), $rTab=$('#rTabId');

    $rTab.find('tr:not(.not_total)').off('mouseenter mouseleave').on('mouseenter mouseleave', {tab:'#lcellbody'}, tab_ov_eve);
    $rTab.find('input[type="text"]').off('focus change').on('focus change', input_fc_eve)
    									.off('keyup').on('keyup', input_keyup_eve);;
    
    
    $lCell.off('mousewheel').on('mousewheel', lCellScroll_eve)
          .find('table tr:not(.not_total)').off('mouseenter mouseleave').on('mouseenter mouseleave', {tab:'#rTabId'}, tab_ov_eve);

    $lCell=$rTab=null;
    
    asynConnection($('#querydiv input[type="hidden"]').toArray(), asynCheckingConnection);
}


;function asynConnection(list_sql, connectionCheckingCallBack){
    var map_head = new customMap(), map_connection=new customMap(), $head=$('#rsmHeadId'), $body=$('#rTabId'), 
        list_tmp = $head.find('td:not(.cfixqtotalw)').toArray();
    
    while(list_tmp.length > 0){
        var _this = list_tmp.shift(),
            tmp_obj={'cellIndex':_this.cellIndex, 'fYear':_this.getAttribute('fyear'), 'fMonth':_this.getAttribute('fmonth'), 'workDays':_this.getAttribute('workingdays')};
        map_head.put((tmp_obj.fYear+'-'+tmp_obj.fMonth), tmp_obj);
        if(map_connection.containsKey(tmp_obj.fYear)){
        		map_connection.get(tmp_obj.fYear).push(tmp_obj.fMonth);
        }else{
            map_connection.put(tmp_obj.fYear, [tmp_obj.fMonth]);
        }
    }
        
    map_head.put('currency', $head.find('td.currentc.currentc1')[0].cellIndex);
    map_head.put('workDay', getWorkDays($head.find('td.currentc.currentc1'), $head));
    
    createConnectionStatus();
    async.eachLimit($body.find('tr.findTab').toArray(), 2, gsmLimitProcess, gsmLimitCallBack);
    
    async.each(list_sql, sqlProcess, function(err){});
	
	;function sqlProcess(hidden, callback){
		setTimeout(function(){
			if(hidden.value != ''){
	        		var json_sql = $.parseJSON(hidden.value), _id = hidden.id,
	        			used_id=(_id.lastIndexOf('bbbsql') != -1 ? '#bbbm' : '#schm');
		        for(var i in json_sql){
		            connectionStatus[i] = false;
		            var source = {'type': _id, '$tab':$body, 'id': i, 'map_year': map_head, 'used_id':used_id, 'psql':json_sql[i]}, 
		            		callBack = {onSuccess: querySuccess, onFailure: queryFailure, source: source};
		            sforce.connection.query(json_sql[i], callBack); 
					$( (used_id + ' li.'+(i.split('@')[1])) ).animate({backgroundColor: '#1F46E2'}, 460);
		        }
	        }
	        callback(null);
	    }, 460);
	}

	;function gsmLimitCallBack(err){
		async.eachLimit($body.find('tr.fso:not(.t_fso)').toArray(), 2, 
						rsmLimitProcess, rsmLimitCallBack);
	}
	;function rsmLimitCallBack(err){
		connectionCheckingCallBack(map_head);
	}

    ;function gsmLimitProcess(item, callback){
		setTimeout(function(){
	        var $item=$(item), pmfc = $.parseJSON(item.getAttribute('pmfc')), 
	        		managerfc = $.parseJSON(item.getAttribute('managerfc'));
			for(var f in managerfc){
	        		if(typeof( $item.find('td.'+f+'_c')[0] ) != 'undefined'){
	        			$item.find('td.'+f+'_c')[0].setAttribute('old', managerfc[f]);
	        		}
	        }
	        for(var o in pmfc){
	        		if(typeof( $item.find('td.'+o+'_c')[0] ) != 'undefined'){
	        			var cell = $item.find('td.'+o+'_c')[0].cellIndex;
	        			$item.next().find('td:eq('+cell+')')[0].setAttribute('old', pmfc[o]);
	        		}
	        }
	        callback(null);
	    }, 500);
	}
	
    ;function rsmLimitProcess(item, callback){
		setTimeout(function(){
	        var	$item=$(item), pmfc = $.parseJSON(item.getAttribute('pmfc')), 
	        		managerfc = $.parseJSON(item.getAttribute('managerfc'));
	
	        for(var f in managerfc){
	        		if(typeof( $item.find('td.'+f)[0] ) != 'undefined'){
	        			$item.find('td.'+f)[0].setAttribute('old', managerfc[f]);
	        		}
	        }
	        for(var o in pmfc){
	        		if(typeof( $item.find('td.'+o)[0] ) != 'undefined'){
	        			var cell = $item.find('td.'+o)[0].cellIndex;
	        			$item.next().find('td:eq('+cell+')')[0].setAttribute('old', pmfc[o]);
	        		}
	        }
	        callback(null);
	    }, 500);
	}
	
	;function createConnectionStatus(){
		document.getElementById('connStatus_id').style.display='';
	    var $comp_box=$('#connbox').html(''), _divbox='';
	    for(var i=0, _keys; _keys=map_connection.keys()[i]; i++){
	    		var list_month=map_connection.get(_keys),
				_ul='<ul class="ulbox"><li class="connyear firstyear">'+_keys+'</li>';
	    		 for(var j=0, _month; _month=list_month[j]; j++){
	    		 	_ul += '<li class="connyear '+_keys+'_'+_month+'">'+_month+'</li>';
	    		 }
	    		 _ul += '</ul>';
	    		 _ul = '<div class="dyearbox">'+_ul+'</div>';
	    		 _divbox +=_ul;
	    }
	    map_connection.clear();
		var _divbox='<div id="bbbm" class="bbb"><div class="connobj">'+window.$label['bbb']+'</div>'+_divbox+'</div>'+
				'<div id="schm" class="sch"><div class="connobj">'+window.$label['sch']+'</div>'+_divbox+'</div>';
	    $comp_box.html(_divbox);
	    _divbox='';
	}
	
	
    ;function getWorkDays($td, $head){
        var el_cm1=$head.find('td.cm-1')[0], el_cm2=$head.find('td.cm-2')[0], el_cm3=$head.find('td.cm-3')[0],
            el_cc1=$head.find('td._cnm0')[0], el_cc2=$head.find('td._cnm1')[0], el_cc3=$head.find('td._cnm2')[0],
            t={ 'cmtotal':0, 'cellIndex': 0, 'cm1': 0, 'cm2': 0, 'cm3': 0,
              //  'cm1':parseInt(el_cm1.getAttribute('workingdays'), 10),
             //  'cm2':parseInt(el_cm2.getAttribute('workingdays'), 10),
             //   'cm3':parseInt(el_cm3.getAttribute('workingdays'), 10),
                'cmcell1': el_cm1.cellIndex, 'cmcell2': el_cm2.cellIndex, 'cmcell3': el_cm3.cellIndex,
                'nm0': $td[0].cellIndex, 'nm1': el_cc1.cellIndex, 'nm2': el_cc2.cellIndex, 'nm3': el_cc3.cellIndex
               };
        el_cm1=el_cm2=el_cm3=null;
        t[$td[0].cellIndex] = 0;		//parseInt($td[0].getAttribute('workingdays'), 10);
        t[el_cc1.cellIndex] = 0;		//parseInt(el_cc1.getAttribute('workingdays'), 10);
        t[el_cc2.cellIndex] = 0;		//parseInt(el_cc2.getAttribute('workingdays'), 10);
        t[el_cc3.cellIndex] = 0;		//parseInt(el_cc3.getAttribute('workingdays'), 10);
        
        for(var i in t){ if( !$.isNumeric(t[i]) ){t[i]=0;} }
    //    t['cmtotal']=(t.cm1+t.cm2+t.cm3);
        el_cc1=el_cc2=el_cc3=null;
        return t;
    }
}
;function querySuccess(result, source){

    if(typeof(result['size']) == 'undefined' || result['size'] == '0'){
        connectionStatus[source.id]=true;
        $( (source['used_id']+' li.'+source['id'].split('@')[1]) ).animate({backgroundColor: '#1FE26D'}, 100* Math.random() + 600);
        return;
    }

    var list_newResult=[], list_result=result["records"], source_year=(source['id'].split('@')[1]);
    result["records"] = null;
    source['list_items'] = source.$tab.find( ('td.'+source_year) ).toArray();

    if(source['type'] == 'bbbsqlid'){   //BBBM result
        if($.isArray(list_result)){
            while(list_result.length > 0){
                list_newResult.push( getBBBMObject(list_result.shift(), source_year) );
            }
        }else{
            list_newResult.push( getBBBMObject(list_result, source_year) );
        }
        asynBBBMProcess(list_newResult, source);
    }else{  //schedule result
        if($.isArray(list_result)){
            while(list_result.length > 0){
                list_newResult.push( getScheduledObject(list_result.shift(), source_year) );
            }
        }else{
            list_newResult.push( getScheduledObject(list_result, source_year) );
        }
        asynScheduledProcess(list_newResult, source);
    }
    
    
    ;function getScheduledObject(_result, year){
        var o={'category':nullString(_result['Category']), 'classification': nullString(_result['classification']),
               'region':nullString(_result['region']), 'forecast':nullNumber(_result['forecast']), 'fYear': year,
				'scheduled': function(t, el){
					if(t['forecast'] != 'null'){
                        el.setAttribute('old', roundFn( (numberOfZero(el.getAttribute('old'))+ t['forecast']), 2));
                    }
                }
              };
        return o;
    }

    
    ;function getBBBMObject(_result, year){
        var o = {'backlog0':nullNumber(_result['DemandOpen']), 'demandShipped':nullNumber(_result['Billings']),
                'region':nullString(_result['region']), 'classification':nullString(_result['classification']),
                'category':nullString(_result['Category']), 'center':nullString(_result['profitCtr']), 
               /* 'backlog0':nullNumber(_result['Backlog0']), */ 'billings':nullNumber(_result['DemandShipped']), 
                'book2bill':nullNumber(_result['Book2Bill']), 'currency1':nullNumber(_result['Currency1']), 
                'currency2':nullNumber(_result['Currency2']), 'currency3':nullNumber(_result['Currency3']), 
                'currency4':nullNumber(_result['Currency4']), 'forecasts':nullNumber(_result['Forecasts']), 
            /*    'pmforecasts':nullNumber(_result['PreviousForecast']), */ 'accuracyQuarterly':nullNumber(_result['beginQuarterForecast']), 
                'accuracy2m':nullNumber(_result['month2Forecast']), 'accuracy6m':nullNumber(_result['month6Forecast']), 
                'fYear': year, 
                'setval':function(t, el){
                    if(t != 'null'){
                        el.setAttribute('old', roundFn( (numberOfZero(el.getAttribute('old'))+ t), 2));
                    }
                },
                'crcy' : function(t, el, o_n){
                    var cIndx = el.cellIndex;
                    if(cIndx == o_n['nm0'] || cIndx == o_n['nm1'] || cIndx == o_n['nm2'] || cIndx == o_n['nm3']){
                        if(t['currency1'] != 'null'){
                            el.setAttribute('c1', roundFn( (numberOfZero(el.getAttribute('c1'))+ t), 2));
                        }
                        if(t['currency2'] != 'null'){
                            el.setAttribute('c2', roundFn( (numberOfZero(el.getAttribute('c2'))+ t), 2));
                        }
                        if(t['currency3'] != 'null'){
                            el.setAttribute('c3', roundFn( (numberOfZero(el.getAttribute('c3'))+ t), 2));
                        }
                        if(t['currency4'] != 'null'){
                            el.setAttribute('c4', roundFn( (numberOfZero(el.getAttribute('c4'))+ t), 2));
                        }
                    }
                },
                'billing': function(t, el){ 
                		o['setval'](t['billings'], el); //set DemandShipped
                		if(t['demandShipped'] != 'null'){//set Billing
                			el.setAttribute('billing', roundFn( (numberOfZero(el.getAttribute('billing'))+ t['demandShipped']), 2));
                		}
                },
                'amfc': function(t, el){ o['setval'](t['forecasts'], el); },
                'btbill': function(t, el){ o['setval'](t['book2bill'], el); },
                'obacklog': function(t, el){ o['setval'](t['backlog0'], el); },
                'a2m': function(t, el){ o['setval'](t['accuracy2m'], el); },
                'a6m': function(t, el){ o['setval'](t['accuracy6m'], el); },
                'aqty': function(t, el){ o['setval'](t['accuracyQuarterly'], el); }
              };
        return o;
    }
    
}
;function queryFailure(error, source){
    var has=false;
    for(var i in error){if(error.hasOwnProperty(i)){has=true; break;}}
    if(has){
    		var $li=$( (source['used_id']+' li.'+source['id'].split('@')[1]) ), _text=$.trim($li.text()).substring(0, 2),
    			d=' <div id="conneerrorid" class="connerror" style="display:none;"><div><input type="button" t="reload" class="btn" value="'+window.$label['reload']+'" /><input type="button" class="btn" value="'+window.$label['cancel']+'" /></div><div>'+error['faultstring']+'</div></div>';
    		
    		$li.html('').text(_text).append(d)
    			.off('mouseenter mouseleave').on('mouseenter mouseleave', {source:source}, conn_error_eve)
    			.animate({backgroundColor: '#D34619'}, 100* Math.random() + 800)
    			.find('#conneerrorid').on('mouseenter mouseleave', {source:source}, conn_error_over_eve)
    			.find('input[type="button"]').each(function(){
    				$(this).on('click', {source:source}, 
    							(this.getAttribute('t') == 'reload' ? connection_reload : connection_cancel));
    			});
    //    console.log(error);
    //    console.log('onFailure: ' + source.id);
    //    connectionStatus[source.id]=true; 
    }
}
;function connection_reload(e){
	var source=e.data.source, callBack = {onSuccess: querySuccess, onFailure: queryFailure, source: source},
		$li=$( (source['used_id']+' li.'+source['id'].split('@')[1]) ), _text=$.trim($li.text()).substring(0, 2);

    $li.html('').text(_text)
		.animate({backgroundColor: '#1F46E2'}, 100* Math.random() + 800);

	sforce.connection.queryAll(source['psql'], callBack); 
}
;function connection_cancel(e){
	var source=e.data.source;
	connectionStatus[source.id]=true; 
	$((source['used_id']+' li.'+source['id'].split('@')[1])).off('mouseenter mouseleave')
				.animate({backgroundColor: '#1FE26D'}, 100* Math.random() + 800)
				.find('div.connerror').removeClass('hover').hide();
}
;function conn_error_over_eve(e){
	switch(e.type){
		case 'mouseenter': $(this).addClass('hover'); break;
		case 'mouseleave': $(this).removeClass('hover'); break;
	}
}
;function conn_error_eve(e){
	var source=e.data.source, $div=$( (source['used_id']+' li.'+source['id'].split('@')[1]+' div.connerror') );
	switch(e.type){
		case 'mouseenter':
			$div.show();
			break;
			
		case 'mouseleave':
			setTimeout(function () {
			if (!$div.hasClass('hover')) { $div.hide(); }
		}, 200);
			break;
	}
}
;function asynCheckingConnection(map_head){
    var clearTimer = window.setInterval(function(){
        var isStop = true;
        for(var i in connectionStatus){ if(!connectionStatus[i]){ isStop = false; break; } }
        if(isStop){
            clearInterval(clearTimer);
            connectionStatus = {};
            
            $('#connbox').slideToggle('slow', function(){
	            document.getElementById('connStatus_id').style.display = 'none';
            		this.innerHTML='';
            		$(this).removeAttr('style');
            });
            
            $('#rsmHeadId td.cfixqtotalw').each(function(idx){
		    		if(idx < 2){
		    			$(this).triggerHandler('click');
		    		}else if(idx >= 5){
		    			$(this).triggerHandler('click');
		    		}
		    });
            lazyExecute(function(){ sumOf_initTotal(map_head); }, null, 500);
        }
    }, 1500);
}
;function asynBBBMProcess(list_result, source){

	async.eachLimit(list_result, 1, bbbResultBatch, function(err){
		$( (source['used_id']+' li.'+source['id'].split('@')[1]) ).animate({backgroundColor: '#1FE26D'}, 100* Math.random() + 600);
	    source['list_items'] = [];//source.$tab.find('tr.crcy').toArray();
	    connectionStatus[source.id]=true;
	});
	
	;function bbbResultBatch(_result, callback){
		setTimeout(function(){
	        for(var j=0, _item; _item=source.list_items[j]; j+=1){
	            var oItem_tmp=getItemObject(_item.parentNode);     //oItem_tmp is Interim method(asynResultProcess) variables  

	    			for(var i=0, list_rsm=oItem_tmp['repeatdef']['list_gsmDefinitions'], _rsm; _rsm=list_rsm[i]; i++){
					var list_ex=undefinedArray(_rsm['categoryExclude']), list_in=undefinedArray(_rsm['categoryInclude']);
					
					if(_result.category == '' && _result['region']==_rsm['region'] && _result['center']==_rsm['profitCenter'] && 
														_result['classification'] == _rsm['classification'] && list_in.length ==0){
						putMatchRow(_result,  source, _item, ('tr.each'+oItem_tmp['id']+':not(.pmfc):not(.scheduled):not(.backlog)'));
					}else{
						if(list_ex.length ==0){
							if(_result['region']==_rsm['region'] && _result['center']==_rsm['profitCenter'] && 
																_result['classification'] == _rsm['classification'] && list_in.length == 0){
								putMatchRow(_result,  source, _item, ('tr.each'+oItem_tmp['id']+':not(.pmfc):not(.scheduled):not(.backlog)'));
							}else if( _result['region']==_rsm['region'] && _result['center']==_rsm['profitCenter'] && 
																_result['classification'] == _rsm['classification'] && _.contains(list_in, _result.category) ){
								putMatchRow(_result, source, _item, ('tr.each'+oItem_tmp['id']+':not(.pmfc):not(.scheduled):not(.backlog)'));
							}
						}else if( !_.contains(list_ex, _result.category) ){
							if(_result['region']==_rsm['region'] && _result['center']==_rsm['profitCenter'] && 
																		_result['classification'] == _rsm['classification'] && list_in.length == 0){
									putMatchRow(_result, source, _item, ('tr.each'+oItem_tmp['id']+':not(.pmfc):not(.scheduled):not(.backlog)'));
							}else if( _result['region']==_rsm['region'] && _result['center']==_rsm['profitCenter'] && 
																		_result['classification'] == _rsm['classification'] && _.contains(list_in, _result.category) ){
									putMatchRow(_result, source, _item, ('tr.each'+oItem_tmp['id']+':not(.pmfc):not(.scheduled):not(.backlog)'));
							}
						}
					}
				}
	    			
	    			
	        }
	        callback(null);
	    }, 180);    
	}
	
}
;function asynScheduledProcess(list_result, source){
	
	async.eachLimit(list_result, 1, schedulResultBatch, function(err){
		$( (source['used_id']+' li.'+source['id'].split('@')[1]) ).animate({backgroundColor: '#1FE26D'}, 100* Math.random() + 600);
		list_result = source['list_items'] = [];
    		connectionStatus[source.id]=true;
	});
	
	;function schedulResultBatch(_result, callback){
		setTimeout(function(){
	        for(var j=0, _item; _item=source.list_items[j]; j+=1){
	            var oItem_tmp=getItemObject(_item.parentNode);     //oItem_tmp is Interim method(asynResultProcess) variables  
				for(var i=0, list_rsm=oItem_tmp['repeatdef']['list_gsmDefinitions'], _rsm; _rsm=list_rsm[i]; i++){
					var list_ex=undefinedArray(_rsm['categoryExclude']), list_in=undefinedArray(_rsm['categoryInclude']);
		            
		            if(_result.category == '' && _result['region']==_rsm['region'] && 
		            						_result['classification'] == _rsm['classification'] && list_in.length ==0){
		                putMatchRow(_result, source, _item, ('tr.scheduled.each'+oItem_tmp['id']));
		            }else{
		                if(list_ex.length ==0){
		                    if(_result['region']==_rsm['region'] && 
		                    					_result['classification'] == _rsm['classification'] && list_in.length == 0){
		                        putMatchRow(_result, source, _item, ('tr.scheduled.each'+oItem_tmp['id']));
		                    }else if( _result['region']==_rsm['region'] && 
		                    					_result['classification'] == _rsm['classification'] && _.contains(list_in, _result.category) ){
		                        putMatchRow(_result, source, _item, ('tr.scheduled.each'+oItem_tmp['id']));
		                    }
		                }else if( !_.contains(list_ex, _result.category) ){
		                    if(_result['region']==_rsm['region'] && 
		                    				_result['classification'] == _rsm['classification'] && list_in.length == 0){
		                    		putMatchRow(_result, source, _item, ('tr.scheduled.each'+oItem_tmp['id']));
		                    }else if( _result['region']==_rsm['region'] && 
		                    				_result['classification'] == _rsm['classification'] && _.contains(list_in, _result.category) ){
		                    		putMatchRow(_result, source, _item, ('tr.scheduled.each'+oItem_tmp['id']));
		                    }
		                }
		            }
				}
	        }
	        callback(null);
		}, 45);
	}
	
}
;function putMatchRow(_result, source, _item, findcls){
    var list_t = source.$tab.find(findcls).toArray();
    while(list_t.length > 0){
        var el_tr = list_t.shift();
        if(typeof(el_tr) != 'undefined'){
            _result[el_tr.getAttribute('fn')](_result, el_tr.cells[_item.cellIndex], source['map_year'].get('workDay'));
        }
    }
}
;function getItemObject(_item){
    var o={ 'id':_item.getAttribute('ocls'),
    			'repeatdef' : $.parseJSON( $.trim(_item.getAttribute('repeatdef')) )
			};
    return o;
}
/*
;function getItemObject(_item){
    var o={ 'id':_item.getAttribute('ocls'),
            'center':nullString(_item.getAttribute('pcenter')), 
            'region':nullString(_item.getAttribute('region')), 
            'classification':nullString(_item.getAttribute('classification')), 
            'list_ex':undefinedArray(_item.getAttribute('categoryexclude')), 
            'list_in':undefinedArray(_item.getAttribute('categoryinclude'))
          //  'list_st':undefinedArray(_item.getAttribute('industrialsalesteaminclude'))
            };
    return o;
}
*/
;function sumOf_initTotal(map_head){
	var $body = $('#rTabId');

	sumOf_currencyFields($body.find('tr.crcy').toArray());


	sumOf_subTotal($body.find('tr.acls.backlog').toArray());	//category A Backlog sub total
	sumOf_subTotal($body.find('tr.bcls.backlog').toArray());	//category B Backlog sub total
	sumOf_subTotal($body.find('tr.ccls.backlog').toArray());	//category Channel Backlog sub total
	
	sumOf_qTotal($body.find('tr.acls td.cfixqtotalw').toArray());	//category A RSM sub qTotal
	sumOf_qTotal($body.find('tr.bcls td.cfixqtotalw').toArray());	//category B RSM sub qTotal
	sumOf_qTotal($body.find('tr.ccls td.cfixqtotalw').toArray());	//category Channel RSM sub qTotal

	match_rsmRows($body.find('tr.acls.fso:not(.t_fso)').toArray(), $body);	//category A RSM
	match_rsmRows($body.find('tr.bcls.fso:not(.t_fso)').toArray(), $body);	//category B RSM
	match_rsmRows($body.find('tr.ccls.fso:not(.t_fso)').toArray(), $body);	//category Channel RSM

	sumOf_GSMlineRowTotal($body.find('tr.acls.findTab').toArray(), $body, 'tr.acls.');	//category A GSM
	sumOf_GSMlineRowTotal($body.find('tr.bcls.findTab').toArray(), $body, 'tr.bcls.');	//category B GSM
	sumOf_GSMlineRowTotal($body.find('tr.ccls.findTab').toArray(), $body, 'tr.ccls.');	//category Channel GSM
	
	sumOf_gsmLineRows($body.find('tr.acls.findTab').toArray(), $body);	//set Historical billing value to gsm line
	sumOf_gsmLineRows($body.find('tr.bcls.findTab').toArray(), $body);	//set Historical billing value to gsm line
	sumOf_gsmLineRows($body.find('tr.ccls.findTab').toArray(), $body);	//set Historical billing value to gsm line
	
	/** start fixed check qtotal bug  2014-05-8 minghao.li@itbconsult.com */
	sumOf_qTotal($body.find('tr.acls td.cfixqtotalw').toArray());	//category A RSM sub qTotal
	sumOf_qTotal($body.find('tr.bcls td.cfixqtotalw').toArray());	//category B RSM sub qTotal
	sumOf_qTotal($body.find('tr.ccls td.cfixqtotalw').toArray());	//category Channel RSM sub qTotal
	/** end   fixed check qtotal bug  2014-05-8 minghao.li@itbconsult.com*/
	
	sumOf_allTotal($body, map_head);		//All Total sum
	
	
	;function sumOf_currencyFields(list_items){
	//	var json_workdays = $.parseJSON($.trim($('[id*=workingdaysid]').val())), 
		var workDay = map_head.get('workDay');
	    
	    while(list_items.length > 0){
	    		var _items = list_items.shift(), find_id=$.trim(_items.getAttribute('ocls')).split('_')[0],
	    			_region = $.trim($body.find('tr.'+find_id)[0].getAttribute('region')), workday_obj = '';
	        
	    		var nm0=_items.cells[workDay.nm0], nm1=_items.cells[workDay.nm1], 
	            nm2=_items.cells[workDay.nm2], nm3=_items.cells[workDay.nm3],
	            cm1=_items.cells[workDay.cmcell1], cm2=_items.cells[workDay.cmcell2], cm3=_items.cells[workDay.cmcell3],
	        
	            cm1_1=numberOfZero(cm1.getAttribute('c1')),cm1_2=numberOfZero(cm1.getAttribute('c2')),
	            cm1_3=numberOfZero(cm1.getAttribute('c3')),cm1_4=numberOfZero(cm1.getAttribute('c4')),
	            
	            cm2_1=numberOfZero(cm2.getAttribute('c1')),cm2_2=numberOfZero(cm2.getAttribute('c2')),
	            cm2_3=numberOfZero(cm2.getAttribute('c3')),cm2_4=numberOfZero(cm2.getAttribute('c4')),
	            
	            cm3_1=numberOfZero(cm3.getAttribute('c1')),cm3_2=numberOfZero(cm3.getAttribute('c2')),
	            cm3_3=numberOfZero(cm3.getAttribute('c3')),cm3_4=numberOfZero(cm3.getAttribute('c4'));
	        cm1=cm2=cm3=null;
	        
	        if(workDay['cmtotal'] != 0){
	            var o = workDay_sumOf(cm1_1,cm2_1,cm3_1, workDay['cm1'], workDay['cm2'], workDay['cm3']);
	            cm1_1 = ceilFn(o['ctotal']/o['workday'], 2)*workDay[nm0.cellIndex];
	            o = workDay_sumOf(cm1_2,cm2_2,cm3_2, workDay['cm1'], workDay['cm2'], workDay['cm3']);
	            cm1_2 = ceilFn(o['ctotal']/o['workday'], 2)*workDay[nm1.cellIndex];
	            o = workDay_sumOf(cm1_3,cm2_3,cm3_3, workDay['cm1'], workDay['cm2'], workDay['cm3']);
	            cm1_3 = ceilFn(o['ctotal']/o['workday'], 2)*workDay[nm2.cellIndex];
	            o = workDay_sumOf(cm1_4,cm2_4,cm3_4, workDay['cm1'], workDay['cm2'], workDay['cm3']);
	            cm1_4 = ceilFn(o['ctotal']/o['workday'], 2)*workDay[nm3.cellIndex];
	        }else{
	        		cm1_1=cm1_2=cm1_3=cm1_4=0;
	        }
	        
	        nm0.setAttribute('old', ceilFn(cm1_1, 2));
	        nm1.setAttribute('old', ceilFn(cm1_2, 2));
	        nm2.setAttribute('old', ceilFn(cm1_3, 2));
	        nm3.setAttribute('old', ceilFn(cm1_4, 2));
	    }
    }
	
	;function sumOf_gsmLineRows(list_elements, $body){
		while(list_elements.length > 0){
			var _element = list_elements.shift(), pm_element=$(_element).next()[0],
                el_billing =  $(_element).next().next().next()[0];
			for(var i=0, max=max=map_head.get('workDay')['nm1']; i<max; i+=1){
				var pmfc=pm_element.cells[i].getAttribute('old'), billing=el_billing.cells[i].getAttribute('billing');
				if(pmfc != 'null' && pmfc != '0'){
				    _element.cells[i].setAttribute('old', pmfc);
				}else{
				    if(billing != 'null' && billing != '0'){
				        _element.cells[i].setAttribute('old', billing);
				    }
				}
			}
		}
	}
	
    ;function sumOf_GSMlineRowTotal(list_elements, $body, findcls){
    	
		while(list_elements.length > 0){
			var _element = list_elements.shift(), $ele = $(_element), el_rsmfctotal = $ele.next().next()[0],
				el_billingtotal = $ele.next().next().next()[0], el_backlogtotal = $ele.next().next().next().next()[0],
				el_currencytotal = $ele.next().next().next().next().next()[0], 
				list_find_el = $body.find(findcls+_element.getAttribute('findcls')).toArray(), 
				list_new_billingtotal = [], list_rsmtotal = [], list_backlogtotal = [], list_billingtotal = [], list_currencytotal = [];

			while(list_find_el.length > 0){
				var el_rsmfc = list_find_el.shift(), $rsm = $(el_rsmfc), 
					el_billing = $rsm.next().next().next()[0], 
					el_backlog = $rsm.next().next().next().next().next()[0], 
					el_currency = $rsm.next().next().next().next().next().next().next().next()[0];
				
				for(var i=0, _el; _el=el_rsmfc.cells[i]; i+=1){	//rsm total
					list_rsmtotal[i] = (list_rsmtotal[i] == undefined ? 0 : list_rsmtotal[i]);
					list_rsmtotal[i] += numberOfZero(_el.getAttribute('old'));
				}
				for(var i=0, max=el_billing.cells.length; i<max; i++){	//DemandShipped total
					list_billingtotal[i] = (list_billingtotal[i] == undefined ? 0 : list_billingtotal[i]);
					list_billingtotal[i] += numberOfZero(el_billing.cells[i].getAttribute('old'));
				}
				for(var i=0, max=el_billing.cells.length; i<max; i++){	//billing total
					list_new_billingtotal[i] = (list_new_billingtotal[i] == undefined ? 0 : list_new_billingtotal[i]);
					list_new_billingtotal[i] += numberOfZero(el_billing.cells[i].getAttribute('billing'));
				}
				for(var i=0, max=el_backlog.cells.length; i<max; i++){	//backlog and currency total
					list_backlogtotal[i] = (list_backlogtotal[i] == undefined ? 'null' : list_backlogtotal[i]);
					if(el_backlog.cells[i].getAttribute('old') != 'null'){
						list_backlogtotal[i] = numberOfZero(list_backlogtotal[i]) + numberOfZero(el_backlog.cells[i].getAttribute('old'));
					}
					
					list_currencytotal[i] = (list_currencytotal[i] == undefined ? 'null' : list_currencytotal[i]);
					if(el_currency.cells[i].getAttribute('old') != 'null'){
						list_currencytotal[i] = numberOfZero(list_currencytotal[i]) + numberOfZero(el_currency.cells[i].getAttribute('old'));
					}

				}
			}

			for(var i=0, max=list_rsmtotal.length; i<max; i+=1){
				el_rsmfctotal.cells[i].setAttribute('old', list_rsmtotal[i]);
			}
			list_rsmtotal=[];
			
			for(var i=0, max=list_billingtotal.length; i<max; i+=1){
				el_billingtotal.cells[i].setAttribute('old', list_billingtotal[i]);
			}
			list_billingtotal=[];
			
			for(var i=0, max=list_new_billingtotal.length; i<max; i+=1){//set DemandShipped total
				el_billingtotal.cells[i].setAttribute('billing', list_new_billingtotal[i]);
			}
			list_new_billingtotal=[];
			
			for(var i=0, max=list_backlogtotal.length; i<max; i++){//set billing total
				el_backlogtotal.cells[i].setAttribute('old', list_backlogtotal[i]);
			}
			list_backlogtotal=[];
			for(var i=0, max=list_currencytotal.length; i<max; i++){
				if(i >= map_head.get('currency')){
					el_currencytotal.cells[i].setAttribute('old', list_currencytotal[i]);
				}
			}
			list_currencytotal=[];
		}
	}
	
    ;function match_rsmRows(list_elements, $body){
		while(list_elements.length > 0){
			var _elements = list_elements.shift(), _id=_elements.getAttribute('ocls'), 
				billing_el = $body.find('tr.billing.each'+_id)[0], 
				pm_el = $body.find('tr.pmfc.each'+_id)[0], am_el = $body.find('tr.amfc.each'+_id)[0];

			for(var i=0, max=map_head.get('currency'); i<max; i+=1){
			    if(pm_el.cells[i].getAttribute('old') != 'null' && pm_el.cells[i].getAttribute('old') !='0'){ //2014-11-13 edit minghao.li@itbconsult.com
			        _elements.cells[i].setAttribute('old', pm_el.cells[i].getAttribute('old'));
			    }else{
    				if(billing_el.cells[i].getAttribute('billing') != 'null'){	//billing is empty
    					_elements.cells[i].setAttribute('old', billing_el.cells[i].getAttribute('billing'));
    				}else if(pm_el.cells[i].getAttribute('old') != 'null' ){	//rsm Previous Month Forecast
    					_elements.cells[i].setAttribute('old', pm_el.cells[i].getAttribute('old'));
    				}else if(am_el.cells[i].getAttribute('old') != 'null'){	//AM total forecast
    					_elements.cells[i].setAttribute('old', am_el.cells[i].getAttribute('old'));
    				}
			    }
			}
		}
	}
	
	
	
	;function sumOf_subTotal(list_elements){	//backlog 
		while(list_elements.length > 0){
			var _element = list_elements.shift(), $_element = $(_element), oblog_element = $_element.next()[0], schedul_element = $_element.next().next()[0];
			for(var i=0, max=_element.cells.length; i<max; i+=1){
				var t = 'null', oblog_v = oblog_element.cells[i].getAttribute('old'), schedul_v = schedul_element.cells[i].getAttribute('old');
				if(oblog_v != 'null'){t = accAdd((t=='null'?0:t), numberOfZero(oblog_v));}
				if(schedul_v != 'null'){t = accAdd((t=='null'?0:t), numberOfZero(schedul_v));}
				if(t != 'null'){_element.cells[i].setAttribute('old', t);}
			}
			/*
			for(var i=map_head.get('currency'), max=_element.cells.length; i<max; i+=1){
				var t = 'null', oblog_v = oblog_element.cells[i].getAttribute('old'), schedul_v = schedul_element.cells[i].getAttribute('old');
				if(oblog_v != 'null'){t = accAdd((t=='null'?0:t), numberOfZero(oblog_v));}
				if(schedul_v != 'null'){t = accAdd((t=='null'?0:t), numberOfZero(schedul_v));}
				if(t != 'null'){_element.cells[i].setAttribute('old', t);}
			}
			*/
		}
		
	}
	;function sumOf_qTotal(list_elements){
		while(list_elements.length > 0){
			var _qTotal=list_elements.shift(), t='null', _tr = _qTotal.parentNode, _cell=_qTotal.cellIndex,
                v1=_tr.cells[_cell-1].getAttribute('old'), v2=_tr.cells[_cell-2].getAttribute('old'), 
                v3=_tr.cells[_cell-3].getAttribute('old');

            if(v1 != 'null'){ t = accAdd((t=='null'?0:t), numberOfZero(v1)); }
            if(v2 != 'null'){ t = accAdd((t=='null'?0:t), numberOfZero(v2)); }
            if(v3 != 'null'){ t = accAdd((t=='null'?0:t), numberOfZero(v3)); }
            if(t !='null'){_qTotal.setAttribute('old', ceilFn(t, 2));}
            if($(_tr).hasClass('billing')){
            		t = 'null';
            		v1=_tr.cells[_cell-1].getAttribute('billing'), 
            		v2=_tr.cells[_cell-2].getAttribute('billing'), 
                v3=_tr.cells[_cell-3].getAttribute('billing');
            		if(v1 != 'null'){ t = accAdd((t=='null'?0:t), numberOfZero(v1)); }
	            if(v2 != 'null'){ t = accAdd((t=='null'?0:t), numberOfZero(v2)); }
	            if(v3 != 'null'){ t = accAdd((t=='null'?0:t), numberOfZero(v3)); }
	            if(t !='null'){_qTotal.setAttribute('billing', ceilFn(t, 2));}
            }
		}
	}
	
	;function workDay_sumOf(c1, c2, c3, d1, d2, d3){    //check historical cm1,cm2,cm3 of sum working days
        var o={'ctotal': 0, 'workday': 0};
        if(c1 != 0){
            o['ctotal'] += c1;
            o['workday'] += d1;
        }
        if(c2 != 0){ 
            o['ctotal'] += c2;
            o['workday'] += d2;
        }
        if(c3 != 0){
            o['ctotal'] += c3;
            o['workday'] += d3;
        }
        return o;
    }
	
}
;function sumOf_allTotal($body, map_head){
	
	map_head.put('ftuIndx', $('#rsmHeadId td._cnm0')[0].cellIndex);
    	map_head.put('currentMaxTotal', (map_head.get('ftuIndx')-1) );
	
	var a = { 'total':[], 'myfc':[], 'billing':[], 'backlog':[], 'currency': [], 'rsm':[], 'new_billing':[] },
		b = { 'total':[], 'myfc':[], 'billing':[], 'backlog':[], 'currency': [], 'rsm':[], 'new_billing':[] },
		c = { 'total':[], 'myfc':[], 'billing':[], 'backlog':[], 'currency': [], 'rsm':[], 'new_billing':[] },
		el_atotal=document.getElementById('faTabId'),el_btotal=document.getElementById('fbTabId'),
		el_ctotal=document.getElementById('fcTabId'),el_ab = document.getElementById('abTotalId'), 
		el_bc = document.getElementById('bcTotalId');
		
	sumOf_lineTotal($body.find('tr.acls.findTab').toArray(), el_atotal, a);	//GSM category A line total
	sumOf_lineTotal($body.find('tr.bcls.findTab').toArray(), el_btotal, b);	//GSM category B line total
	sumOf_lineTotal($body.find('tr.ccls.findTab').toArray(), el_ctotal, c);	//GSM category Channel line total
	
	sumOf_ABC_total(a['total'], b['total'], c['total'], el_ab, el_bc);
	a['total'] = b['total'] = c['total'] = [];
	sumOf_ABC_total(a['myfc'], b['myfc'], c['myfc'], $(el_ab).next()[0], $(el_bc).next()[0]);
	a['myfc'] = b['myfc'] = c['myfc'] = [];
	
	sumOf_ABC_total(a['rsm'], b['rsm'], c['rsm'], $(el_ab).next().next()[0], $(el_bc).next().next()[0]);
	a['rsm'] = b['rsm'] = c['rsm'] = [];
	
	
	sumOf_Billing_total(a['new_billing'], b['new_billing'], c['new_billing'], $(el_ab).next().next().next()[0], $(el_bc).next().next().next()[0]);
	sumOf_ABC_total(a['billing'], b['billing'], c['billing'], $(el_ab).next().next().next()[0], $(el_bc).next().next().next()[0]);
	
	a['billing'] = b['billing'] = c['billing'] = [];
	
	sumOf_ABC_total(a['backlog'], b['backlog'], c['backlog'], $(el_ab).next().next().next().next()[0], $(el_bc).next().next().next().next()[0]);
	a['backlog'] = b['backlog'] = c['backlog'] = [];
	
	sumOf_ABC_total(a['currency'], b['currency'], c['currency'], $(el_ab).next().next().next().next().next()[0], $(el_bc).next().next().next().next().next()[0]);
	a['currency'] = b['currency'] = c['currency'] = [];

	var map_a_region = new customMap(), map_b_region = new customMap(), map_c_region = new customMap();
	sumOf_GSM_Contains_RSM_LineTotal($body.find('tr.acls.fso').toArray(), map_a_region);	//GSM  Contains category A all RSM
	sumOf_GSM_Contains_set_RSM_LineTotal($body.find('tr.aTotal.t_fso').toArray(), map_a_region);
	
	sumOf_GSM_Contains_RSM_LineTotal($body.find('tr.bcls.fso').toArray(), map_b_region);	//GSM  Contains category B all RSM
	sumOf_GSM_Contains_set_RSM_LineTotal($body.find('tr.bTotal.t_fso').toArray(), map_b_region);
	
	sumOf_GSM_Contains_RSM_LineTotal($body.find('tr.ccls.fso').toArray(), map_c_region);	//GSM  Contains category Channel all RSM
	sumOf_GSM_Contains_set_RSM_LineTotal($body.find('tr.cTotal.t_fso').toArray(), map_c_region);
	
	sumOf_GMS_Contains_A_B_C_total(map_a_region, map_b_region);	//A + B
	sumOf_GSM_Contains_set_RSM_LineTotal($body.find('tr.abTotal.t_fso').toArray(), map_b_region);
	
	sumOf_GMS_Contains_A_B_C_total(map_b_region, map_c_region);	// A + B + C
	sumOf_GSM_Contains_set_RSM_LineTotal($body.find('tr.bcTotal.t_fso').toArray(), map_c_region);

	booktoBill($body.find('tr.btbill').toArray());	//RSM Book to Bill
	booktoBill($body.find('tr.tfmt_btbill').toArray());	//All RSM Book to Bill
	
	sumOf_AccuracyPercent($body.find('tr.acls.a2m, tr.acls.a6m, tr.acls.aqty').toArray(), $body, false);	//2M, 6M, Quarterly Accuracy Percent
	sumOf_AccuracyPercent($body.find('tr.bcls.a2m, tr.bcls.a6m, tr.bcls.aqty').toArray(), $body, false);	//2M, 6M, Quarterly Accuracy Percent
	sumOf_AccuracyPercent($body.find('tr.ccls.a2m, tr.ccls.a6m, tr.ccls.aqty').toArray(), $body, false);	//2M, 6M, Quarterly Accuracy Percent
	
	sumOf_AccuracyPercent($body.find('tr.aTotal.tfmt_a2m, tr.aTotal.tfmt_a6m, tr.aTotal.tfmt_aqty').toArray(), $body, true);	//Total 2M, 6M, Quarterly Accuracy Percent
	sumOf_AccuracyPercent($body.find('tr.bTotal.tfmt_a2m, tr.bTotal.tfmt_a6m, tr.bTotal.tfmt_aqty').toArray(), $body, true);	//Total 2M, 6M, Quarterly Accuracy Percent
	sumOf_AccuracyPercent($body.find('tr.cTotal.tfmt_a2m, tr.cTotal.tfmt_a6m, tr.cTotal.tfmt_aqty').toArray(), $body, true);	//Total 2M, 6M, Quarterly Accuracy Percent
	
	sumOf_AccuracyPercent($body.find('tr.abTotal.tfmt_a2m, tr.abTotal.tfmt_a6m, tr.abTotal.tfmt_aqty').toArray(), $body, true);	//Total 2M, 6M, Quarterly Accuracy Percent
	sumOf_AccuracyPercent($body.find('tr.bcTotal.tfmt_a2m, tr.bcTotal.tfmt_a6m, tr.bcTotal.tfmt_aqty').toArray(), $body, true);	//Total 2M, 6M, Quarterly Accuracy Percent
	
	
	finally_format(map_head);
	
	;function sumOf_AccuracyPercent(list_element, $body, isTotal){
		while(list_element.length > 0){
			var el_accuracy = list_element.shift(), ocls_shipped = el_accuracy.getAttribute('ocls'),
				ocls_open=el_accuracy.getAttribute('ocls');
			if(isTotal){
				var t = '', s='';
				if($(el_accuracy).hasClass('aTotal')){
					t = 'aTotal'+ocls_shipped.split('_')[0] +'_'+ ocls_shipped.split('_')[1];
					s = 'aTotal'+ocls_open.split('_')[0] +'_'+ ocls_open.split('_')[1];
				}else if($(el_accuracy).hasClass('bTotal')){
					t = 'bTotal'+ocls_shipped.split('_')[0] +'_'+ ocls_shipped.split('_')[1];
					s = 'bTotal'+ocls_open.split('_')[0] +'_'+ ocls_open.split('_')[1];
				}else if($(el_accuracy).hasClass('cTotal')){
					t = 'cTotal'+ocls_shipped.split('_')[0] +'_'+ ocls_shipped.split('_')[1];
					s = 'cTotal'+ocls_open.split('_')[0] +'_'+ ocls_open.split('_')[1];
				}else if($(el_accuracy).hasClass('abTotal')){
					t = 'abTotal'+ocls_shipped.split('_')[0] +'_'+ ocls_shipped.split('_')[1]+'_'+ocls_shipped.split('_')[2];
					s = 'abTotal'+ocls_open.split('_')[0] +'_'+ ocls_open.split('_')[1]+'_'+ocls_open.split('_')[2];
				}else if($(el_accuracy).hasClass('bcTotal')){
					t = 'bcTotal'+ocls_shipped.split('_')[0] +'_'+ ocls_shipped.split('_')[1]+'_'+ocls_shipped.split('_')[2];
					s = 'bcTotal'+ocls_open.split('_')[0] +'_'+ ocls_open.split('_')[1]+'_'+ocls_open.split('_')[2];
				}
				ocls_shipped = 'tr.tfmt_billing.'+t;
				ocls_open = 'tr.tfmt_backlog.'+s;
				/*
				var el_billing = $body.find(ocls)[0];
	
				for(var i=0, max=map_head.get('ftuIndx'); i<max; i++){
					var accuracy = el_accuracy.cells[i].getAttribute('old'), billing = el_billing.cells[i].getAttribute('billing');
					accuracy = (!$.isNumeric(accuracy) ? 0 : accuracy);
	            		billing = (!$.isNumeric(billing) ? 0 : billing);
	            		billing = (billing != 0 ? ceilFn(accuracy/billing, 2) : 0);
					el_accuracy.cells[i].setAttribute('old', billing);
				}
				*/	
			}else{
				ocls_shipped = 'tr.billing.each'+ocls_shipped.split('_')[0];
				ocls_open = 'tr.backlog.each'+ocls_open.split('_')[0];
			}
			var tr_shipped=$body.find(ocls_shipped)[0], tr_open=$body.find(ocls_open)[0];
			for(var i=0, max=map_head.get('ftuIndx'); i<max; i++){
				var accuracy = el_accuracy.cells[i].getAttribute('old'), 
					shipped=tr_shipped.cells[i].getAttribute('old'), 
					open=tr_open.cells[i].getAttribute('old');

				accuracy = (!$.isNumeric(accuracy) ? 0 : parseFloat(accuracy));
				shipped = (!$.isNumeric(shipped) ? 0 : parseFloat(shipped));
				open = (!$.isNumeric(open) ? 0 : parseFloat(open));
				open=(open+shipped);

            		accuracy = (open != 0 ? ceilFn(accuracy/open, 2) : 0);
				el_accuracy.cells[i].setAttribute('old', accuracy);
			}
		}
	}
	
	;function sumOf_GMS_Contains_A_B_C_total(map_a, map_b){
		var map_ab = new customMap();
		for(var i=0, _key, _value; _key=map_b.keys()[i], _value=map_b.values()[i]; i++){
			map_a.put(_key, _value);
		}
		map_b.clear();
		for(var i=0, _key; _key=map_a.keys()[i]; i++){
			var _value=map_a.values()[i];
			if(map_b.containsKey(_key)){
				var uniqueValue = map_b.get(_key);
				rsm_region_total(_value, uniqueValue);
				map_b.remove(_key);
			}
			map_b.put(_key, _value);
		}
		map_a.clear();
	}
	
	;function sumOf_GSM_Contains_set_RSM_LineTotal(list_rsm, map_region){
		while(list_rsm.length > 0){
			var _rsm = list_rsm.shift(), _region = _rsm.getAttribute('region');
			if(!map_region.containsKey(_region)){ continue; }
			var value=map_region.get(_region), $rsm=$(_rsm);
			set_field_total(_rsm, value, 'rsm');
			set_field_total($rsm.next()[0], value, 'pmfc');
			set_field_total($rsm.next().next()[0], value, 'amfc');
			
			set_field_total($rsm.next().next().next()[0], value, 'billing');	//set DemandShipped
			
			for(var i=0,row_billing=$rsm.next().next().next()[0], _td; _td=row_billing.cells[i]; i++){
				_td.setAttribute('billing', value['newbilling'][i]);
			}

			set_field_total($rsm.next().next().next().next()[0], value, 'bill');
			set_field_total($rsm.next().next().next().next().next()[0], value, 'backlog');
			set_field_total($rsm.next().next().next().next().next().next()[0], value, 'obacklog');
			set_field_total($rsm.next().next().next().next().next().next().next()[0], value, 'sched');
			set_field_total($rsm.next().next().next().next().next().next().next().next()[0], value, 'crcy');
			set_field_total($rsm.next().next().next().next().next().next().next().next().next()[0], value, 'a2m');
			set_field_total($rsm.next().next().next().next().next().next().next().next().next().next()[0], value, 'a6m');
			set_field_total($rsm.next().next().next().next().next().next().next().next().next().next().next()[0], value, 'qty');
		}
	}
	;function sumOf_GSM_Contains_RSM_LineTotal(list_rsm, map_uniqueRegion){
		var map_rsm_region = new customMap();
		while(list_rsm.length > 0){
			var o = {'rsm':[], 'pmfc':[], 'amfc':[], 'billing':[], 'newbilling':[], 'bill':[], 'backlog':[], 
				 'obacklog':[], 'sched':[], 'crcy':[], 'a2m':[], 'a6m':[], 'qty':[]
				}, _rsm = list_rsm.shift(), $rsm=$(_rsm);
				
			sumOf_field_total(_rsm, o, 'rsm'); 
			sumOf_field_total($rsm.next()[0], o, 'pmfc');
			sumOf_field_total($rsm.next().next()[0], o, 'amfc'); 
			
			sumOf_field_total($rsm.next().next().next()[0], o, 'billing');
			for(var i=0, row_billing=$rsm.next().next().next()[0], _cell; _cell=row_billing.cells[i]; i+=1){
				o['newbilling'][i] = (typeof(o['newbilling'][i]) == 'undefined' ? 0 : o['newbilling'][i]);
				o['newbilling'][i] += numberOfZero(_cell.getAttribute('billing'));
			}
		
		
			sumOf_field_total($rsm.next().next().next().next()[0], o, 'bill'); 
			sumOf_field_total($rsm.next().next().next().next().next()[0], o, 'backlog');
			sumOf_field_total($rsm.next().next().next().next().next().next()[0], o, 'obacklog'); 
			sumOf_field_total($rsm.next().next().next().next().next().next().next()[0], o, 'sched');
			sumOf_field_total($rsm.next().next().next().next().next().next().next().next()[0], o, 'crcy'); 
			sumOf_field_total($rsm.next().next().next().next().next().next().next().next().next()[0], o, 'a2m');
			sumOf_field_total($rsm.next().next().next().next().next().next().next().next().next().next()[0], o, 'a6m'); 
			sumOf_field_total($rsm.next().next().next().next().next().next().next().next().next().next().next()[0], o, 'qty');

			map_rsm_region.put(_rsm.getAttribute('region'), o);
		}

		for(var i=0, _key; _key=map_rsm_region.keys()[i]; i++){
			var _value=map_rsm_region.values()[i];
			if(map_uniqueRegion.containsKey(_key)){
				var uniqueValue = map_uniqueRegion.get(_key);
				rsm_region_total(_value, uniqueValue);
				map_uniqueRegion.remove(_key);
			}
			map_uniqueRegion.put(_key, _value);
		}
		map_rsm_region.clear();
	}

	;function rsm_region_total(list_old, list_new){
		for(var v=0, max=list_new['rsm'].length; v<max; v++){
			list_old['rsm'][v] += list_new['rsm'][v];
		}
		for(var v=0, max=list_new['pmfc'].length; v<max; v++){
			list_old['pmfc'][v] += list_new['pmfc'][v];
		}
		for(var v=0, max=list_new['amfc'].length; v<max; v++){
			list_old['amfc'][v] += list_new['amfc'][v];
		}
		for(var v=0, max=list_new['billing'].length; v<max; v++){
			list_old['billing'][v] += list_new['billing'][v];
		}
		for(var v=0, max=list_new['newbilling'].length; v<max; v++){
			list_old['newbilling'][v] += list_new['newbilling'][v];
		}
		for(var v=0, max=list_new['bill'].length; v<max; v++){
			list_old['bill'][v] += list_new['bill'][v];
		}
		for(var v=0, max=list_new['backlog'].length; v<max; v++){
			list_old['backlog'][v] += list_new['backlog'][v];
		}
		for(var v=0, max=list_new['obacklog'].length; v<max; v++){
			list_old['obacklog'][v] += list_new['obacklog'][v];
		}
		for(var v=0, max=list_new['sched'].length; v<max; v++){
			list_old['sched'][v] += list_new['sched'][v];
		}
		for(var v=0, max=list_new['crcy'].length; v<max; v++){
			list_old['crcy'][v] += list_new['crcy'][v];
		}
		for(var v=0, max=list_new['a2m'].length; v<max; v++){
			list_old['a6m'][v] += list_new['a6m'][v];
		}
		for(var v=0, max=list_new['qty'].length; v<max; v++){
			list_old['qty'][v] += list_new['qty'][v];
		}
	}
	
	
	;function sumOf_ABC_total(list_a, list_b, list_c, el_ab, el_bc){
		var list_ab = [], list_bc = [];
		for(var i=0, max=list_a.length; i<max; i++){//(A + B) total
			list_ab.push( (list_a[i] + list_b[i]) );
		}
		list_a = list_b = [];	//clear list values
		for(var i=0, _td; _td=el_ab.cells[i]; i++){	//set (A + B)  totoal
			_td.setAttribute('old', list_ab[i]);
		}
		
		for(var i=0, max=list_ab.length; i<max; i++){//(AB + Channel) total
			list_bc.push( (list_ab[i] + list_c[i]) );
		}
		list_ab = list_c = [];	//clear list values
		for(var i=0, _td; _td=el_bc.cells[i]; i++){//set (AB + Channel) total
			_td.setAttribute('old', list_bc[i]);
		}
		list_bc = [];
	}
	
	;function sumOf_Billing_total(list_a, list_b, list_c, el_ab, el_bc){
		var list_ab = [], list_bc = [];
		for(var i=0, max=list_a.length; i<max; i++){//(A + B) total
			list_ab.push( (list_a[i] + list_b[i]) );
		}
		list_a = list_b = [];	//clear list values
		for(var i=0, _td; _td=el_ab.cells[i]; i++){	//set (A + B)  totoal
			_td.setAttribute('billing', list_ab[i]);
		}
		
		for(var i=0, max=list_ab.length; i<max; i++){//(AB + Channel) total
			list_bc.push( (list_ab[i] + list_c[i]) );
		}
		list_ab = list_c = [];	//clear list values
		for(var i=0, _td; _td=el_bc.cells[i]; i++){//set (AB + Channel) total
			_td.setAttribute('billing', list_bc[i]);
		}
		list_bc = [];
	}
	;function booktoBill(list_trs){  // (Book to Bill/Billings)
        while(list_trs.length > 0){
            var bill_trs = list_trs.shift(), billing_trs = $(bill_trs).prev()[0];
            for(var i=0, max=map_head.get('ftuIndx'); i<max; i++){
            		var book_bill = parseFloat(bill_trs.cells[i].getAttribute('old')),
            			billing = parseFloat(billing_trs.cells[i].getAttribute('billing'));
            		book_bill = (!$.isNumeric(book_bill) ? 0 : book_bill);
            		billing = (!$.isNumeric(billing) ? 0 : billing);
            		billing = (billing != 0 ? ceilFn(book_bill/billing, 2) : 0);
				bill_trs.cells[i].setAttribute('old', billing);
            }
        }
    }
	;function sumOf_lineTotal(list_rows, tr_el_total, o_total){
		while(list_rows.length > 0){
			var _rows=list_rows.shift(), $row=$(_rows), el_myfc = $row.next()[0], el_rsm=$row.next().next()[0], 
				el_billing=$row.next().next().next()[0], el_backlog=$row.next().next().next().next()[0],
				el_currency=$row.next().next().next().next().next()[0];
			
			sumOf_field_total(_rows, o_total, 'total');
			sumOf_field_total(el_myfc, o_total, 'myfc');
			sumOf_field_total(el_rsm, o_total, 'rsm');
			
			sumOf_field_total(el_billing, o_total, 'billing');	//sum of DemandShipped total
			
			for(var i=0, _cell; _cell=el_billing.cells[i]; i+=1){	//sum of Billings total
				o_total['new_billing'][i] = (typeof(o_total['new_billing'][i]) == 'undefined' ? 0 : o_total['new_billing'][i]);
				o_total['new_billing'][i] += numberOfZero(_cell.getAttribute('billing'));
			}
			
			sumOf_field_total(el_backlog, o_total, 'backlog');
			sumOf_field_total(el_currency, o_total, 'currency');

		}
		var $el_total=$(tr_el_total), el_myfc = $el_total.next()[0], el_rsm=$el_total.next().next()[0], 
			el_billing=$el_total.next().next().next()[0], el_backlog=$el_total.next().next().next().next()[0],
			el_currency=$el_total.next().next().next().next().next()[0];
			
		set_field_total(tr_el_total, o_total, 'total');
		set_field_total(el_myfc, o_total, 'myfc');
		set_field_total(el_rsm, o_total, 'rsm');
		
		set_field_total(el_billing, o_total, 'billing');//set DemandShipped total
		
		for(var i=0, _td; _td=el_billing.cells[i]; i++){//sum of Billings total
			_td.setAttribute('billing', o_total['new_billing'][i]);
		}
		
		set_field_total(el_backlog, o_total, 'backlog');
		set_field_total(el_currency, o_total, 'currency');

	}
	;function set_field_total(el_total, o_total, field){
		for(var i=0, _td; _td=el_total.cells[i]; i++){
			_td.setAttribute('old', o_total[field][i]);
		}
	}
	;function sumOf_field_total(_rows, o_total, field){
		for(var i=0, _cell; _cell=_rows.cells[i]; i+=1){
			o_total[field][i] = (typeof(o_total[field][i]) == 'undefined' ? 0 : o_total[field][i]);
			o_total[field][i] += numberOfZero(_cell.getAttribute('old'));
		}
	}
}
;function finally_format(map_head){

    var $body = $('#rTabId'),
    		findcls='tr.findTab, tr.not_total, tr.fso, tr.rsmtot, tr.ft_rsmtot';
	
    	timedProcess1(fmtRow, null, fmtComplete, $body.find(findcls).toArray());
    	
    	findcls='tr.pmtot, tr.ft_pmtot, tr.tfmt_pmfc, tr.tfmt_amfc, tr.pmfc, tr.amfc';
    	timedProcess1(fmtRightRow, null, fmtComplete, $body.find(findcls).toArray());
    	
    	findcls='tr.backlogtot, tr.ft_backlogtot, tr.tfmt_backlog, tr.tfmt_obacklog, tr.tfmt_scheduled, tr.backlog, tr.obacklog, tr.scheduled';
    	timedProcess1(fmtRow, null, fmtComplete, $body.find(findcls).toArray());
    	
    	findcls='tr.billingtot, tr.ft_billingtot, tr.tfmt_billing, tr.billing';
    	timedProcess1(fmtRow, null, fmtComplete, $body.find(findcls).toArray());

    	findcls='tr.tfmt_btbill, tr.btbill';
    	timedProcess1(function(row){		//set Book to Bill
    		if(typeof(row) != 'undefined'){
	//    		$(row).find('td:gt('+(map_head.get('ftuIndx')-1)+')').addClass('nobg');	//add right color
	    		delay_left_fn(map_head.get('ftuIndx')-1, row, function(callIndex, target){
	            var _cell = target.cells[callIndex];
				_cell.innerHTML = Globalize.format( numberOfZero(_cell.getAttribute('old')), 'n' );
	        });
		}
    	}, null, fmtComplete, $body.find(findcls).toArray());
    	
    	findcls='tr.tfmt_crcy, tr.ft_currencytot, tr.currencytot, tr.crcy';
    	timedProcess1(fmtCurrencyRow, null, fmtComplete, $body.find(findcls).toArray());
    	
    	findcls='tr.tfmt_a2m, tr.tfmt_a6m, tr.tfmt_aqty, tr.a2m, tr.a6m, tr.aqty';
    	timedProcess1(fmtPercentageRow, null, fmtComplete, $body.find(findcls).toArray());
	
	findcls='tr.findTab';
    	timedProcess1(fmtColorRow, null, loadingAnimate, $body.find(findcls).toArray());	//set colors
    	
	$(window).smartresize(windowReSize);
    
    ;function fmtColorRow(row){
    		if(typeof(row) != 'undefined'){
	    		delay_right_fn(map_head.get('currency')+1, row, function(callIndex, target){
		    		if(!$(target.cells[callIndex]).hasClass('cfixqtotalw')){
			    		var _cell = target.cells[callIndex],
			    	//	($(target.cells[(callIndex-1)]).hasClass('cfixqtotalw') ? target.cells[callIndex-2] : target.cells[callIndex-1]), 
			            gsm_val = numberOfZero(_cell.getAttribute('old')),
		            		rsm_val = numberOfZero( $(row).next().next()[0].cells[callIndex].getAttribute('old') );
					animateColors($(target.cells[callIndex]), gsm_val, rsm_val);
		    		}
	        });
    		}
    }
    	
    	;function fmtRow(row){
    		if(typeof(row) != 'undefined'){
	    		delay_fn(row, function(callIndex, target){
	            var _cell = target.cells[callIndex], _v = roundToKM( numberOfZero(_cell.getAttribute('old')) ),
	            		$input = $(_cell).find('input[type="text"]');
	            if(typeof($input[0]) != 'undefined' ){ $input.val(_v); }
	            else{ _cell.innerHTML = _v; }
	        });
		}
    	}
    	;function fmtPercentageRow(row){
    		if(typeof(row) != 'undefined'){
	//    		$(row).find('td:gt('+(map_head.get('ftuIndx')-1)+')').addClass('nobg');	//add right color
	    		delay_left_fn(map_head.get('ftuIndx')-1, row, function(callIndex, target){
	            var _cell = target.cells[callIndex];
				_cell.innerHTML = Globalize.format( numberOfZero(_cell.getAttribute('old')), 'n0' )+ '%';
	        });
       }
    	}
    	;function fmtCurrencyRow(row){
    	//	$(row).find('td:lt('+map_head.get('currency')+')').addClass('nobg');	//add left color
    		for(var i=map_head.get('currency'), max=map_head.get('ftuIndx')+3; i<=max; i++){
    			var _cell = row.cells[i];
			_cell.innerHTML = roundToKM( numberOfZero(_cell.getAttribute('old')) );
    		}
    	}
    	;function fmtLeftRow(row){
    		if(typeof(row) != 'undefined'){
	//    		$(row).find('td:gt('+(map_head.get('ftuIndx')-1)+')').addClass('nobg');	//add right color
	    		delay_left_fn(map_head.get('ftuIndx')-1, row, function(callIndex, target){
	            var _cell = target.cells[callIndex];
				_cell.innerHTML = roundToKM( numberOfZero(_cell.getAttribute('old')) );
	        });
	    }
    	}
    	;function fmtRightRow(row){
    		if(typeof(row) != 'undefined'){
	 //   		$(row).find('td:lt('+map_head.get('currency')+')').addClass('nobg');	//add left color
	    		delay_right_fn(map_head.get('currency'), row, function(callIndex, target){
	            var _cell = target.cells[callIndex];
				_cell.innerHTML = roundToKM( numberOfZero(_cell.getAttribute('old')) );
	        });
	    }
    	}
    	
    	;function fmtComplete(){
    		
    	}

	
}
;function animateColors($el, gsm_val, rsm_val){
	rsm_val=(roundFn(rsm_val/1000, 0) == 0 ? 0 : rsm_val);
	if( !$el.hasClass('cfixqtotalw') && (gsm_val == 0 && rsm_val ==0) ){
		$el.animate({backgroundColor: '#ffffff'}, 100* Math.random() + 600, function(){
		            		$(this).css({'color':'#000'});
		            })
		            		.find('img').removeClass('commentimg').addClass('cmtimg');
		return;
	}
	
	if(gsm_val !=0 && rsm_val != 0){
		gsm_val = roundFn(((rsm_val-gsm_val)/gsm_val), 2);
	}else if(rsm_val == 0 && gsm_val != 0){
		gsm_val = 1;
	}else if(rsm_val != 0 && gsm_val == 0){
		gsm_val = -1;
	}else if(rsm_val == 0 && gsm_val == 0){
		gsm_val = 0;
	}

	var tmpel= document.createElement('div');
	for(var j=0, _color; _color=list_color[j]; j+=1){
        if(!$el.hasClass('cfixqtotalw')){
            tmpel.style.backgroundColor = _color['color'];
            if(_color['maxValue'] !=null && _color['minValue'] !=null){
            		if(gsm_val >= _color['minValue'] && gsm_val < _color['maxValue']){
            			if(tmpel.style.backgroundColor == 'rgb(255, 255, 255)'){
						$el.animate({backgroundColor: '#ffffff'}, 100* Math.random() + 600, function(){
			            		$(this).css({'color':'#000'});
			            })
		            		.find('img').removeClass('commentimg').addClass('cmtimg');
            			}else{
            				
			            $el.animate({backgroundColor: tmpel.style.backgroundColor}, 100* Math.random() + 600, function(){
			            		$(this).css({'color':'#fff'});
			            }).find('img').removeClass('cmtimg').addClass('commentimg');
            			}
		            break;
		        }
            }else if(_color['maxValue'] != null && _color['minValue'] ==null){
            		if(gsm_val <= _color['maxValue']){
            			if(tmpel.style.backgroundColor == 'rgb(255, 255, 255)'){
						$el.animate({backgroundColor: '#ffffff'}, 100* Math.random() + 600, function(){
			            		$(this).css({'color':'#000'});
			            })
		            		.find('img').removeClass('commentimg').addClass('cmtimg');
            			}else{
						$el.animate({backgroundColor: tmpel.style.backgroundColor}, 100* Math.random() + 600, function(){
						 	$(this).css({'color':'#fff'});
						}).find('img').removeClass('cmtimg').addClass('commentimg');
					}
		        		break;
		        }
            }else if(_color['maxValue'] == null && _color['minValue'] !=null){
            		if(gsm_val >= _color['minValue']){
            			if(tmpel.style.backgroundColor == 'rgb(255, 255, 255)'){
						$el.animate({backgroundColor: '#ffffff'}, 100* Math.random() + 600, function(){
			            		$(this).css({'color':'#000'});
			            })
		            		.find('img').removeClass('commentimg').addClass('cmtimg');
            			}else{
						$el.animate({backgroundColor: tmpel.style.backgroundColor}, 100* Math.random() + 600, function(){
			        		 	$(this).css({'color':'#fff'});
						}).find('img').removeClass('cmtimg').addClass('commentimg');
            				
            			}
		        		break;
		        }
            }
	    }
    }
}
;function tab_ov_eve(e){    //over out event
    var over_bg='bgov', _this=this, $this=$(_this), attr='tr.'+_this.getAttribute('ocls'),
    		$target=$(e.data.tab).find(attr);
    		
	switch(e.type){
    		case 'mouseenter':
    			if(e.data.tab == '#lcellbody'){
	    			$target.find('div').addClass(over_bg);
		    		_this.className += (' '+over_bg);
	    		}else{
		    		$target.addClass(over_bg);
		    		$this.find('div').addClass(over_bg);
	    		}
    		break;    	
    		case 'mouseleave':
    			if(e.data.tab == '#lcellbody'){
    				$target.find('div').removeClass(over_bg); 
				$this.removeClass(over_bg);
    			}else{
    				$target.removeClass(over_bg); 
				$this.find('div').removeClass(over_bg);
    			}
    		break;    	
    }
}

;function input_keyup_eve(e){
	var $this=$(this);
	if(e.shiftKey && e.keyCode == 13){
		prevCellInput();
	}else if(e.keyCode == 13){
		nextCellInput();
	}

	;function prevCellInput(){
		var cellIndex=$this.parent()[0].cellIndex, rowIndex=$this.parent().parent()[0].rowIndex,
			list_trs=$this.parent().parent().parent().find('tr.findTab').toArray();
		for(var i=0, _tr; _tr=list_trs[i]; i+=1){
			if(_tr.rowIndex == rowIndex){
				var t = list_trs[(i-1)];
				if(typeof(t) != 'undefined'){
					$(t).find('td:eq('+cellIndex+') input[type="text"]').focus();
					break;
				}
			}
		}
	}
	
	;function nextCellInput(){
		var cellIndex=$this.parent()[0].cellIndex, rowIndex=$this.parent().parent()[0].rowIndex;
		$this.parent().parent().parent().find('tr.findTab').each(function(){
			if(this.rowIndex > rowIndex){
				$(this).find('td:eq('+cellIndex+') input[type="text"]').focus();
				return false; 	//this is js break;
			}
		});
	}
}

;function input_fc_eve(e){

    var $this = $(this), ov = '', validation_qty = /^([1-9]\d{0,16}|0)(\.\d{1,2})?$/, 
        _cell = $this.parent()[0].cellIndex, tv = Globalize.parseFloat($.trim(this.value)); //focus Event
    
    ov = $this.inputFocusKMT(validation_qty, e);

    if(e.type == 'change'){

        if($.trim(this.value) == ''){ 
            sumOf_qTotal(getElementTags($this.parent(), _cell), _cell, $this.parent());
            return; 
        }
        if(!validation_qty.test(tv) || (tv==ov && ov!='')){
            this.value = ( ov == '' ? '' : roundToKM(ov*1000) );
            return;
        }

        this.value = roundToKM( (tv*1000) );
        sumOf_qTotal(getElementTags($this.parent(), _cell), _cell, $this.parent());
    }
    
    ;function getElementTags($td, _cell){
        if(_cell%2 == 1){
            return {'current' : $td, 'prev': $td.prev(), 'next': $td.next(), 'total': $td.next().next()};
        }
        var $t =  ($td.next().hasClass('cfixqtotalw') ? $td.prev() : $td.next());
        return {'current' : $t, 'prev': $t.prev(), 'next': $t.next(), 'total': $t.next().next()};
    }
    
    ;function sumOf_qTotal(el_tags, _cell, $td){

        var p=numberTrimHasKMBTOfZero( (typeof(el_tags.prev.find('input[type="text"]')[0]) != 'undefined' ? el_tags.prev.find('input').val() : el_tags.prev.text()) ),
        //    c=numberTrimHasKMBTOfZero(el_tags.current.find('input').val()),
            c=numberTrimHasKMBTOfZero( (typeof(el_tags.current.find('input[type="text"]')[0]) != 'undefined' ? el_tags.current.find('input').val() : el_tags.current.text()) ),
            n=numberTrimHasKMBTOfZero(el_tags.next.find('input').val()), q_total = 0;
        
        p = ceilFn(accAdd(accAdd(p, c), n), 2);
        q_total = p;
        p = el_tags.total.text( roundToKM(p) ).parent();

        if(p.hasClass('faTab')){
            sumOf_subTotal(_cell, el_tags.total[0].cellIndex, 'faTab');
        }else if(p.hasClass('fbTab')){
            sumOf_subTotal(_cell, el_tags.total[0].cellIndex, 'fbTab');
        }else if(p.hasClass('fcTab')){
            sumOf_subTotal(_cell, el_tags.total[0].cellIndex, 'fcTab');
        }

		var cur=numberTrimHasKMBTOfZero($this.val()),
			prve_fc=numberOfZero($this.parent().parent().next().next()[0].cells[_cell].getAttribute('old'));
		animateColors($td, cur, prve_fc);
		
        p=c=n=el_tags = null;
    }
    
    ;function sumOf_subTotal(_cell, _totalCell, cls){
        var tmp_total, tmp_qtotal, _cell_val=0, _cell_total_val=0, $body=$('#rTabId'), el_tr_total=$body.find('tr#'+cls+'Id')[0],
            el_total = el_tr_total.cells[_cell], el_qTotal = el_tr_total.cells[_totalCell];

        $body.find('tr.findTab.'+cls).each(function(){
            tmp_total = numberTrimHasKMBTOfZero( $(this.cells[_cell]).find('input').val() );
            _cell_val = ceilFn((_cell_val+tmp_total), 2);
            
            tmp_qtotal = numberTrimHasKMBTOfZero( $(this.cells[_totalCell]).text() );
            _cell_total_val = ceilFn((_cell_total_val+tmp_qtotal), 2);
        });

        el_total.innerHTML = roundToKM(_cell_val);
        el_qTotal.innerHTML = roundToKM(_cell_total_val);
        
        tmp_total=tmp_qtotal=_cell_val=_cell_total_val=el_tr_total=el_total=el_qTotal=null;
        
        sumOf_total($body, _cell, _totalCell);
    }
    
    ;function sumOf_total($body, _cell, _totalCell){
        var el_tr_a=$body.find('tr#faTabId')[0], el_tr_b=$body.find('tr#fbTabId')[0], el_tr_ab=$body.find('tr#abTotalId')[0], 
            el_tr_c=$body.find('tr#fcTabId')[0], el_tr_bc=$body.find('tr#bcTotalId')[0],
            
            av=numberTrimHasKMBTOfZero(el_tr_a.cells[_cell].innerHTML), 
            atv=numberTrimHasKMBTOfZero(el_tr_a.cells[_totalCell].innerHTML), 
            
            bv=numberTrimHasKMBTOfZero(el_tr_b.cells[_cell].innerHTML), 
            btv=numberTrimHasKMBTOfZero(el_tr_b.cells[_totalCell].innerHTML), 
            
            cv=numberTrimHasKMBTOfZero(el_tr_c.cells[_cell].innerHTML), 
            ctv=numberTrimHasKMBTOfZero(el_tr_c.cells[_totalCell].innerHTML);
  
        el_tr_a=el_tr_b=el_tr_c=null;
        
        el_tr_ab.cells[_cell].innerHTML= roundToKM( ceilFn(av+bv, 2) ); //ab total
        el_tr_ab.cells[_totalCell].innerHTML= roundToKM( ceilFn(atv+btv, 2) );  //ab qtotal
        
        el_tr_ab=null;
        el_tr_bc.cells[_cell].innerHTML= roundToKM( ceilFn(av+bv+cv, 2) );  //c total
        el_tr_bc.cells[_totalCell].innerHTML= roundToKM( ceilFn(atv+btv+ctv, 2) );  //bc qtotal
        
        av=bv=cv=atv=btv=ctv=el_tr_bc=$body=null;
    }
    
    
    
}

;function setBodyStyle(resize_width, isHeight){

    var $compbody=$('#compbodyall'), min_cw= parseInt($compbody.css('min-width').replace('px', ''), 10), 
        max_ow=(typeof(resize_width) != 'undefined' ? resize_width : $('#contentallid').outerWidth(true));

    min_cw = (max_ow < min_cw ? min_cw : (max_ow-40));
    document.getElementById('compbodyall').style.width = min_cw+'px';    //set all div width

    var lCellw=$compbody.find('#lcellbody').width(), window_h = $(window).height(),
		rightCell_w=parseInt((min_cw-lCellw-2), 10),
        usedHeight = ($('#dmsgid').outerHeight(true) + $('#AppBodyHeader').outerHeight(true) + $('div.bPageFooter.noTableFooter').outerHeight(true) + 50),
        v_height= (window_h - usedHeight - 90);
	

	//if(isfull){ v_height += 85; }
    
    document.getElementById('rCellScroll').style.width = (rightCell_w-1)+'px';
    document.getElementById('rcellhead').style.width = (rightCell_w-scrollbarW-1)+'px';

    if($compbody.find('#lcellbody div.nodata').length != 3){
        document.getElementById('rCellScroll').style.height = v_height+'px';
        document.getElementById('lcellbody').style.height = (v_height+1-scrollbarW-0.7)+'px';
    }else if(isHeight){
        document.getElementById('rCellScroll').style.height = v_height+'px';
        document.getElementById('lcellbody').style.height = (v_height+1-scrollbarW-0.7)+'px';
    }

    document.getElementById('compbodyall').style.visibility='';
}
;function windowReSize(){
    document.getElementById('compbodyall').style.visibility='hidden';
    setBodyStyle($('#tabContainer').width(), false);
}

;function appendExpand_Collapse(){//append (expand or collapse)
	$('#rsmHeadId td.cfixqtotalw')
	    .addClass('hd').off('click').on('click', ck_headCell_eve)
		.find('div').append('<b class="fold_box collapse">-</b>');
}

;function menuHover_eve(target){
	var $this=$(target), _offset=$this.offset();
	$('#gsmmenu').stop().css({'height':'0px', 'visibility':'visible', 'top': ($this.height()+_offset.top), 'left':_offset.left})
			.animate({height:'17%'}, 360);
}
;function menuOut_eve(target){
	var $showMenu=$('#gsmmenu');
	setTimeout(function () {
		if (!$showMenu.hasClass('hover')) {
			$showMenu.animate({height:'0px'}, 460, function(){
				$(this).css({'visibility':'hidden'});
			});
		}
	}, 200);
}
;function menu1_over_eve(e){
	var $this = $(this);
	switch (e.type) {
		case 'mouseenter': $this.addClass('hover'); break;
		case 'mouseleave': 
			$this.animate({height:'0px'}, 460, function(){
				$(this).removeClass('hover').css({'visibility':'hidden'});
			});
		break;
	}
}
;function rCellScroll_eve(e){
    var _this=this;
	document.getElementById('lcellbody').scrollTop = _this.scrollTop;
	document.getElementById('rcellhead').scrollLeft = _this.scrollLeft;
}

;function ck_headCell_eve(e){
    ck_headCell(this.getElementsByTagName('b')[0]);
}

;function ck_headCell(target){
    var $this=$(target), $td=$this.parent().parent(), _c1=$td[0].cellIndex, $cols=$('#rsmcolspanid'),
        $head=$('#rsmHeadId'), fn={'excute':($this.hasClass('expand') ? expand : collapse)};

    fn.excute($('#rsmHeadId, #rTabId tr').toArray());
    
    ;function expand(list_el){
    		while(list_el.length > 0){
    			var item = list_el.shift();
    			$(item.cells[_c1-1]).removeClass('dn');
            $(item.cells[_c1-2]).removeClass('dn');
            $(item.cells[_c1-3]).removeClass('dn');
    		}
		$this.removeClass('expand').addClass('collapse').html('-');
		$td.prev().prev().prev().prev().removeClass('exp_right');
		var pos=3;
		if($td.hasClass('futurec currentc1 cfixqtotalw')){
			var lastQtotal= parseInt( $cols.find('th:first')[0].getAttribute('old') )%3;
			if(lastQtotal != 0){ pos=lastQtotal; }
		}
        hasHistorical(pos);
    }
    
    ;function collapse(list_el){
    		while(list_el.length > 0){
    			var item = list_el.shift();
    			item.cells[_c1-1].className += ' dn';
            item.cells[_c1-2].className += ' dn';
            item.cells[_c1-3].className += ' dn';
    		}
		$this.removeClass('collapse').addClass('expand').html('+');
		$td.prev().prev().prev().prev().addClass('exp_right');
		var pos=-3;
		if($td.hasClass('futurec currentc1 cfixqtotalw')){//click lastQtotal event
			var lastQtotal= parseInt( $cols.find('th:first')[0].getAttribute('old') )%3;
			if(lastQtotal != 0){ pos = (lastQtotal -lastQtotal*2); }
		}
        hasHistorical(pos);
    }
    
    ;function hasHistorical(s){
        if(!$td.hasClass('futurec1')){
	        var $th_head=$cols.find('th:first'),  t = $th_head.prop('colspan');
            $th_head.prop('colspan', t+s);
        }
    }
    
}
;function ck_leftCellImg(target, id, searTab, isAll){
    ck_leftCell($(target).parent()[0], id, searTab, isAll);
}
;function ck_leftCell(target, id, searTab, isAll){
    var $this=$(target), $b = $this.find('b'),
    		fn={'execute':($b.hasClass('expand') ? expand : collapse)};

    fn.execute($this, id, ('#'+searTab), isAll);

    ;function expand($this, id, searTab, isAll){
        id=(isAll ? (id+':not(.sbcell)') : id+'.sbcell');
        $b.removeClass('expand').addClass('collapse col').html(function(){
        		return this.getAttribute('exp');
        });
        var $leftTab = $(searTab).find(('tr.'+id)).removeClass('dn');
		if(isAll){
	        $this.addClass('pd_0_0');
	        if($this.hasClass('left_titlebg')){
		        $this.addClass('coll');
		        $leftTab.find('td').addClass('collapse_left');
	        }else if($this.hasClass('dTabbg')){ 
	        		$leftTab.find('td:eq(1)').addClass('collapse_left1');
	        }
		}else{
			
		}
        
        $('#rTabId tr.'+id).removeClass('dn');
    }
    ;function collapse($this, id, searTab, isAll){
        var $tab=$(searTab);
        $b.removeClass('collapse').addClass('expand').html(function(){
        		return this.getAttribute('col');
        });
        $tab.find(('tr.'+id+' b.subp')).removeClass('collapse col').addClass('expand');
        if(isAll){
	        $this.removeClass('pd_0_0');
            $('#rTabId tr.'+id).not('.findTab').addClass('dn');
        }else{
	        $('#rTabId tr.sbcell.'+id).addClass('dn');
        }
        
    		id=(isAll ? ('tr.'+id) : ('tr.sbcell.'+id));
        var $leftTab = $tab.find(id).addClass('dn');
        if(isAll){
	        if($this.hasClass('left_titlebg')){
		        $this.removeClass('coll');
		        $leftTab.find('td').removeClass('collapse_left');
	        }else{
		        $leftTab.find('td:eq(1)').removeClass('collapse_left1');
	        }
        }else{
        	
        }
    }
}
;function ck_allCell(target, cls, id, _cls){
    var $img=$(target.getElementsByTagName('b')[0]),
        fn={'excute':($img.hasClass('expand') ? expand : collapse)};
    fn.excute();
    ;function expand(){
        $('#'+id).find('.'+cls+':not(.nodata)').addClass('dn');
        $('#'+id).find('.'+_cls+':not(.nodata)').removeClass('dn');
        $img.removeClass('expand').addClass('collapse').html('-');
    }
    
    ;function collapse(){
		var $find = $('#'+id+' .'+cls).addClass('dn');
        	$find.find('td.coll, td.collapse_left, td.collapse_left1').removeClass('coll collapse_left collapse_left1');
        	$find.find('b.collapse, b.col').removeClass('collapse col').addClass('expand').html(function(){
        			return this.getAttribute('col');
        		});
        $img.removeClass('collapse').addClass('expand').html('+');
    }        

}
;function lCellScroll_eve(e, delta, deltaX, deltaY){

	var el_rScroll=document.getElementById('rCellScroll'), scrollHeight=this.scrollHeight,
        r_height=$(this).height(), defaultt=el_rScroll.scrollTop-14*deltaY;

    if((this.scrollTop < (scrollHeight-r_height) && delta<0) || (el_rScroll.scrollTop != 0 && delta>0)) {
        e.preventDefault();
    }
    el_rScroll.scrollTop = defaultt;
    this.scrollTop = el_rScroll.scrollTop;
}

;function loadingAnimate(){
    $('#loading-curtain-div').animate({top:'50%', left:'50%',width:0, height:0}, 800, function(){
        this.setAttribute('style', '');
        this.style.display='none';
    });
}

function asynProcess(items, asynTimeProcess, callback){
    var todo = items.concat();
    setTimeout(function(){
        asynTimeProcess(todo.shift());
        if (todo.length > 0){ setTimeout(arguments.callee, 35); }
        else{ callback(); }
    }, 55);
}
;function artMsg(content, target, callBackOk){
    art.dialog({
        title:' ', lock:true, dblclick_hide:false, esc:false, id: 'countsid',
        content: content,
        button : [ {value: 'OK', focus: true, callback: function(){ callBackOk(target); }} ]
    });
}
;function delay_fn(el_tr, callBack){
    var i=0, len=el_tr.cells.length;
    (function(){
        if(i>=len){ return; }
        callBack(i, el_tr);
        i+=1;
        window.setTimeout(arguments.callee,65);
    })();
}
;function delay_fn1(startI, el_tr, callBack){
    var i=startI, len=el_tr.cells.length;
    (function(){
        if(i>=len){ return; }
        callBack(i, el_tr);
        i+=1;
        window.setTimeout(arguments.callee,65);
    })();
}
;function delay_right_fn(startI, el_tr, callBack){
    var i=startI, len=el_tr.cells.length;
    (function(){
        if(i>=len){ return; }
        callBack(i, el_tr);
        i+=1;
        window.setTimeout(arguments.callee,65);
    })();
}
;function delay_left_fn(end_len, el_tr, callBack){
    var i=0, len=end_len;
    (function(){
        if(i>len){ return; }
        callBack(i, el_tr);
        i+=1;
        window.setTimeout(arguments.callee,65);
    })();
}
;function addListener (element, event, fn, params) {
    var eventHandler = ( params ? function(){ fn.call(params); } : fn );
    if (window.attachEvent) {
        element.attachEvent('on' + event, eventHandler);
    } else {
        element.addEventListener(event, eventHandler, false);
    }
}
;function eventHandle(e, _over, _out, _click){
    var customMouser = {mouseenter: _over,mouseleave: _out,click: _click};
    customMouser[e.type].call(this, e);customMouser = {};
}
;function eventHandle_ov_ot(e, _over, _out){
    var customMouser = {mouseenter: _over,mouseleave: _out};
    customMouser[e.type].call(this, e);customMouser = {};
}
function timedProcess(items, process, context, callback){
    var todo = items;
    for(var i=1,max=todo.length; i<=max; i+=1){ timeStatus[i] = false; }
    setTimeout(function(){
		var start = +new Date();
		do { 
			var len = todo.length;
			process.call(context, todo.shift(), len); 
		} 
		while (todo.length > 0 && (+new Date() - start < 50));
		
		if (todo.length > 0){ setTimeout(arguments.callee, 25); } 
		else { callback(); }
     }, 25);
}
function timedProcess1(process, context, callback, items){
    var todo = items;
    setTimeout(function(){
		var start = +new Date();
		do { process.call(context, todo.shift()); } 
		while (todo.length > 0 && (+new Date() - start < 50));
		
		if (todo.length > 0){ setTimeout(arguments.callee, 65); } 
		else { callback(); }
	}, 45);
}
;function lazyExecute(fn, p, time){
    setTimeout(function(){
        fn(p);
    }, (time | 45));
}
;function numberTrimHasKMBTOfZero(v){
    v=roundHasKM( $.trim(v) );
    v=($.isNumeric(v) ? v : 0);
    return v;
}
;function numberOfZero(t){
    return ($.isNumeric(t) ? parseFloat(t) : 0);
}
;function numberOfNull(t){
    return ($.isNumeric(t) ? parseFloat(t) : null);
}

;function nullString(s){
    return (s==null||typeof(s)=='undefined'?'':s);
}
;function nullNumber(s){
    return (!$.isNumeric(s)? 'null' : parseFloat(s));
}
;function undefinedArray(s){
    return (typeof(s)=='undefined' || s=='' ? [] : s.split(','));
}
$.fn.inputFocusKMT = function(validationType, e){       //input the history of value is saved
    var eventConfig = {
        focus : function(){
            oldValue = '';
            var focus_val = $.trim($(this).val());
            if(validationType.test(focus_val)){oldValue = focus_val;}
        }
    };
    if($.isFunction(eventConfig[e.type])){eventConfig[e.type].call(this, e);}
    return oldValue;
}
;function roundHasKM(num){
    if(!$.isNumeric(Globalize.parseFloat(num))){ return ''; }
    return (Globalize.parseFloat(num)*1000);
}
;function roundToKM(txt,a){//ok
    txt=Math.round(txt/10)/100;
  //  var point = 'n0'; //(/\.0+$/.test(txt.toFixed(2)) ? 'n0' : 'n0');
    return (Globalize.format(roundFn(txt, 0), 'n0'));
}
function jsclone(obj) {
    var o;
    if (typeof obj == "object") {
        if (obj === null) {
            o = null;
        } else {
            if (obj instanceof Array) {
                o = [];
                for (var i = 0, len = obj.length; i < len; i++) { o.push(jsclone(obj[i])); }
            } else {
                o = {};
                for (var j in obj) { o[j] = jsclone(obj[j]); }
            }
        }
    } else { o = obj; }
    return o;
}
(function($){
    $.fn.hoverDelay = function(options){
		var hoverTimer, outTimer,
			defaults = {
			hoverDuring: 200, outDuring: 200,
			hoverEvent: function(target){ $.noop(); },
			outEvent: function(target){ $.noop(); }
		}, sets = $.extend(defaults,options || {});
	
		return $(this).each(function(){
			var _this=this;
			$(_this).hover(function(eve){
				clearTimeout(outTimer);
				hoverTimer = setTimeout(function(){
					sets.hoverEvent(_this);
				}, sets.hoverDuring);
			},function(eve){
				clearTimeout(hoverTimer);
				outTimer = setTimeout(function(){
					sets.outEvent(_this);
				}, sets.outDuring);
			});    
		});
	};
})(jQuery);