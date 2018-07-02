var oldValue='', list_gSave=[],connectionStatus={};
;function initDocumentPage(){
    Globalize.culture(this.locale).numberFormat.currency.symbol = "";
    initComplete();
//    freshDocumentPage(true);
}


;function check_viewType(){
    var t = $('[id*=viewtypeid]').val();
    $('#menubtnid input[type="button"]').each(function(){
        if(this.getAttribute('viewtype') == t){
            $(this).addClass('disabled').prop({"disabled":true});
        }else{
            $(this).removeClass('disabled').prop({"disabled":false});
        }
    });
}

;function freshDocumentPage(isHide){

    appendExpand_Collapse();
    $(window).smartresize(windowReSize);
    
    lazyExecute(setBodyStyle);
    $('#rsmHeadId td.cfixqtotalw').addClass('hd').off('click').on('click', ck_headCell_eve);
    $('#rCellScroll').scroll(rCellScroll_eve);
	$('#allLeftCell').off('click').on('click', allLeftCell);
//	$('#allLeftCell').triggerHandler('click');
	
    var $lCell=$('#lcellbody'), $rTab=$('#rTabId');

    $rTab.find('tr:not(.not_total)').off('mouseenter mouseleave').on('mouseenter mouseleave', {tab:'#lcellbody'}, tab_ov_eve);
    
    $lCell.off('mousewheel').on('mousewheel', lCellScroll_eve)
          .find('table tr:not(.not_total)').off('mouseenter mouseleave').on('mouseenter mouseleave', {tab:'#rTabId'}, tab_ov_eve);

    $lCell=$rTab=null;
    if(isHide){
        loadingAnimate();
    }
}

;function appendExpand_Collapse(){//append (expand or collapse)
    $('#rsmHeadId td.cfixqtotalw div').append('<b class="fold_box collapse">-</b>');    
}
;function lCellScroll_eve(e, delta, deltaX, deltaY){
    var el_rScroll=document.getElementById('rCellScroll'), scrollHeight=this.scrollHeight,
        $rCellScroll=$(el_rScroll), r_height=$(this).height(), defaultt=el_rScroll.scrollTop-14*deltaY;

    if((this.scrollTop < (scrollHeight-r_height) && delta<0) || (el_rScroll.scrollTop != 0 && delta>0)) {
        e.preventDefault();
    }
    $rCellScroll.scrollTop(defaultt);
    $(this).scrollTop($rCellScroll.scrollTop());
}

;function tab_ov_eve(e){    //over out event
    var $this=$(this), attr='tr'+($this.hasClass('sbcell')?'.sbcell.': ':not(.sbcell).' )+this.getAttribute('ovid'),
    		over_bg='bgov', $target=$(e.data.tab).find(attr);
    eventHandle_ov_ot(e, ov, ot);
    ;function ov(e){ 
    		if(e.data.tab == '#lcellbody'){
			$target.find('div').addClass(over_bg);
    			$this.addClass(over_bg);
		}else{
	    		$target.addClass(over_bg);
	    		$this.find('div').addClass(over_bg);
		}
    }
    ;function ot(e){ 
        if(e.data.tab == '#lcellbody'){
    			$target.find('div').removeClass(over_bg); 
			$this.removeClass(over_bg);
		}else{
			$target.removeClass(over_bg); 
			$this.find('div').removeClass(over_bg);
		}
    }
}

;function changViewType(target, viewtype){
	document.getElementById('pageLoading').style.display='';
    $('[id*=viewtypeid]').val(viewtype);
    $('#connbox').html('');
    changeScreen(); //this is action function
}
;function changeScreenComplete(){
	document.getElementById('connStatus_id').style.display = '';
    initComplete();
    
}
;function initComplete(){   //action function complete

    check_viewType();
    
    lazyExecute(freshDocumentPage, false);
	
    asynConnection($('#querydiv input[type="hidden"]').toArray(), asynConnectionChecking);

    ;function asynConnection(list_input, callBackChecking){
    	
        var tmp_obj, $head=$('#rsmHeadId'), map_connection=new customMap(), map_head = new customMap();

        $head.find('td:not(.cfixqtotalw)').each(function(){
            tmp_obj={'cellIndex':this.cellIndex, 'fYear':this.getAttribute('fyear'), 'fMonth':this.getAttribute('fmonth'), 'workDays':this.getAttribute('workingdays')};
            map_head.put((tmp_obj.fYear+'-'+tmp_obj.fMonth), tmp_obj);
            
            if(map_connection.containsKey(tmp_obj.fYear)){
            		map_connection.get(tmp_obj.fYear).push(tmp_obj.fMonth);
            }else{
	            map_connection.put(tmp_obj.fYear, [tmp_obj.fMonth]);
            }
        });
        var _divbox='';
        
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
        $('#connbox').html('').append('<div id="bbbm" class="bbb"><div class="connobj">'+window.cLabel['bbb']+'</div>'+_divbox+'</div>')
        				 .append('<div id="schm" class="sch"><div class="connobj">'+window.cLabel['sch']+'</div>'+_divbox+'</div>');
        map_connection.clear();
        
        map_head.put('currency', $head.find('td.currentc.currentc1')[0].cellIndex);
        map_head.put('workDay', getWorkDays($head.find('td.currentc.currentc1'), $head));
		
        while(list_input.length > 0){
        		
        		var hidden=list_input.shift();
            if(hidden['value'] != ''){
	            (function(){
		        		var json_sql = $.parseJSON(hidden['value']), _id = hidden.id,
		        			used_id=(_id.lastIndexOf('BBBM') != -1 ? '#bbbm' : '#schm');
		        			
			        setTimeout(function(){
				        for(var i in json_sql){
				            connectionStatus[i] = false;
				            var source = {'type': _id, '$tab':'', 'id': i, 'map_head': map_head, 'list_items':[], 'used_id':used_id, 'psql':json_sql[i]}, 
				            		callBack = {onSuccess: querySuccess, onFailure: queryFailure, source: source};
				            sforce.connection.query(json_sql[i], callBack); 
				            $(used_id).find('li.'+(i.split('@')[1])).animate({backgroundColor: '#1F46E2'}, 100* Math.random() + 800);
				        }
			        }, 450);
		        })();
            }
        }
        callBackChecking(map_head);
    }

    ;function getWorkDays($td, $head){
        var el_cm1=$head.find('td.cm-1')[0], el_cm2=$head.find('td.cm-2')[0], el_cm3=$head.find('td.cm-3')[0],
            el_cc1=$head.find('td._cnm0')[0], el_cc2=$head.find('td._cnm1')[0], el_cc3=$head.find('td._cnm2')[0],
            t={ 'cmtotal':0, 'cellIndex': 0,
                'cm1':parseInt(el_cm1.getAttribute('workingdays'), 10),
                'cm2':parseInt(el_cm2.getAttribute('workingdays'), 10),
                'cm3':parseInt(el_cm3.getAttribute('workingdays'), 10),
                'cmcell1': el_cm1.cellIndex, 'cmcell2': el_cm2.cellIndex, 'cmcell3': el_cm3.cellIndex,
                'nm0': $td[0].cellIndex, 'nm1': el_cc1.cellIndex, 'nm2': el_cc2.cellIndex, 'nm3': el_cc3.cellIndex
               };
        el_cm1=el_cm2=el_cm3=null;
        t[$td[0].cellIndex] = parseInt($td[0].getAttribute('workingdays'), 10);
        t[el_cc1.cellIndex] = parseInt(el_cc1.getAttribute('workingdays'), 10);
        t[el_cc2.cellIndex] = parseInt(el_cc2.getAttribute('workingdays'), 10);
        t[el_cc3.cellIndex] = parseInt(el_cc3.getAttribute('workingdays'), 10);
        
        for(var i in t){ if( !$.isNumeric(t[i]) ){t[i]=0;} }
        t['cmtotal']=(t.cm1+t.cm2+t.cm3);
    //    t['cellIndex']=[$td[0].cellIndex, el_cc1.cellIndex, el_cc2.cellIndex, el_cc3.cellIndex];
        el_cc1=el_cc2=el_cc3=null;
        return t;
    }
    
}
;function addComment(){
	
}
;function delComment(){
	
}
;function comment_ck(_id, _year, _month){
	document.getElementById('pageLoading').style.display='';
    $('[id*=acId]').val(_id);
    $('[id*=acYear]').val(_year);
    $('[id*=acMonth]').val(_month);
    getComments();  //this is action function
}
;function getCommentsComplete(){

	$('#commentBodyId td.asmval').html(function(){
		var  val = roundToKM( trimNumberOfZero(this.innerHTML) );
		return val;
	});
    $('#popCtn').fadeIn('slow');
    document.getElementById('popCmt').className='';
    windowReSize();
    loadingAnimate();
//    document.getElementById('pageLoading').style.display='none';
}
;function clsPop(){
    $('#popCtn').fadeOut('slow', function(){
        document.getElementById('popCmt').className='hide';
    });
}
;function debug_sql(isLog, _id, _query){
    if(isLog){
    	/*
        $('#dmsgid').append('<div style="border:1px solid #000; padding:5px; margin:5px;">'+
              _id +'-----'+ _query
            +'</div>');
    */
        console.log(_id + ':  ' + _query);
    }
}
;function asynConnectionChecking(map_head){
    var clearTimer = window.setInterval(function(){
    		var isStop = true;
    		for(var i in connectionStatus){ if(!connectionStatus[i]){ isStop = false; break; } }
	//isStop=false;
        if(isStop){
            clearInterval(clearTimer);
            connectionStatus = {};
            $('#connbox').slideToggle('slow', function(){
	            document.getElementById('connStatus_id').style.display = 'none';
            		$(this).removeAttr('style');
            		this.innerHTML='';
            });

            $('#rsmHeadId td.cfixqtotalw').each(function(idx){
		    		if(idx < 2){
		    			$(this).triggerHandler('click');
		    		}else if(idx >= 5){
		    			$(this).triggerHandler('click');
		    		}
		    });
            sumOf_initTotal(map_head);
        }
    }, 500);
}

;function querySuccess(result, source){

    if(typeof(result['size']) == 'undefined' || result['size'] == '0'){
        connectionStatus[source.id]=true;
        $(source['used_id']).find('li.'+source['id'].split('@')[1]).animate({backgroundColor: '#1FE26D'}, 100* Math.random() + 600);
        return;
    }

    window[source.type](result["records"], source);
    result["records"]=null;
}
;function getScheduledObject(_result, _year){

    var o={'customerid': isOther(_result), 'monthText':nullString(_result['Fiscal_Month_Text__c']), 
           'amount':nullNumber(_result['forecast']), 'fYear':_year
          };

    ;function isOther(_result){
        try{return _result['Account_Manager__c'].toString();}
        catch(e){return 'OTHER';}
    }
    
    return o;
}
;function getResultObject(_result, _year){
	//Result used Billings and DemandShipped is Exchange value.
    var o={'customerid': isOther(_result), /* 'backlog0':nullNumber(_result['Backlog0']),   */
    			'backlog0':nullNumber(_result['DemandOpen']), 'demandShipped':nullNumber(_result['Billings']),
            'backlog1':nullNumber(_result['Backlog1']), 'backlog2':nullNumber(_result['Backlog2']),
            'backlog3':nullNumber(_result['Backlog3']), 'forecasts':nullNumber(_result['Forecasts']),
            'billings':nullNumber(_result['DemandShipped']), 'book2bill':nullNumber(_result['Book2Bill']),
            'budgets':nullNumber(_result['Budgets']), 'currency1':nullNumber(_result['Currency1']),
            'currency2':nullNumber(_result['Currency2']), 'currency3':nullNumber(_result['Currency3']),
            'currency4':nullNumber(_result['Currency4']), 
            'pmforecasts':nullNumber(_result['PreviousForecast']), 'accuracyQuarterly':nullNumber(_result['beginQuarterForecast']), 
            'accuracy2m':nullNumber(_result['month2Forecast']), 'accuracy6m':nullNumber(_result['month6Forecast']), 'fYear': _year
              };

    ;function isOther(_result){
        try{return _result['Account_Manager__c'].toString();}
        catch(e){return 'OTHER';}
    }
    return o;
}

;function commonBBBM($body, el_tr, newResult, cellIndex, isOther){
    void function(){
        var _id=(isOther ? 'OTHER' : newResult.customerid), tmp_pmfc = $body.find( 'tr.pmfc'+_id )[0].cells[cellIndex], 
            tmp_bpb = $body.find( 'tr.bpb'+_id )[0].cells[cellIndex], tmp_bill = $body.find( 'tr.bill'+_id )[0].cells[cellIndex], 
            tmp_btb = $body.find( 'tr.btb'+_id )[0].cells[cellIndex], tmp_oblog = $body.find( 'tr.oblog'+_id )[0].cells[cellIndex],
            tmp_cur = $body.find( 'tr.cur'+_id )[0].cells[cellIndex], tmp_2m = $body.find( 'tr.a2m'+_id )[0].cells[cellIndex],
            tmp_6m = $body.find( 'tr.a6m'+_id )[0].cells[cellIndex], tmp_qa = $body.find( 'tr.qa'+_id )[0].cells[cellIndex];

        tmp_2m.setAttribute('old', sumOf_value(newResult['accuracy2m'], tmp_2m.getAttribute('old')));
        tmp_6m.setAttribute('old', sumOf_value(newResult['accuracy6m'], tmp_6m.getAttribute('old')));
        tmp_qa.setAttribute('old', sumOf_value(newResult['accuracyQuarterly'], tmp_qa.getAttribute('old')));
        
		el_tr.cells[cellIndex].setAttribute('old', sumOf_value(newResult.forecasts, el_tr.cells[cellIndex].getAttribute('old')));
		
        tmp_pmfc.setAttribute('old', sumOf_value(newResult['pmforecasts'], tmp_pmfc.getAttribute('old')));
        tmp_bpb.setAttribute('old', sumOf_value(newResult['budgets'], tmp_bpb.getAttribute('old')));
        
        tmp_bill.setAttribute('old', sumOf_value(newResult['billings'], tmp_bill.getAttribute('old')));//billings is demandShipped value
        tmp_bill.setAttribute('biling', sumOf_value(newResult['demandShipped'], tmp_bill.getAttribute('biling')));	//demandShipped is billings value
        
        tmp_btb.setAttribute('old', sumOf_value(newResult['book2bill'], tmp_btb.getAttribute('old')));
        
        tmp_oblog.setAttribute('old', sumOf_value(newResult['backlog0'], tmp_oblog.getAttribute('old')));

        tmp_cur.setAttribute('c1', sumOf_value(newResult['currency1'], tmp_cur.getAttribute('c1')));
        tmp_cur.setAttribute('c2', sumOf_value(newResult['currency2'], tmp_cur.getAttribute('c2')));
        tmp_cur.setAttribute('c3', sumOf_value(newResult['currency3'], tmp_cur.getAttribute('c3')));
        tmp_cur.setAttribute('c4', sumOf_value(newResult['currency4'], tmp_cur.getAttribute('c4')));
        _id=cellIndex=tmp_pmfc=tmp_bpb=tmp_bill=tmp_btb=tmp_oblog=null;
    }();

    ;function sumOf_value(v1, v2){
        return (v1 == 'null' ? v2 : (roundFn((trimNumberOfZero(v1) + trimNumberOfZero(v2)), 2)));
    };
}

;function commonBBB_Object(list_result, source, isOther){
    var $body=$('#rTabId'), tmp_tr, source_year=(source['id'].split('@')[1].replace('_', '-'));

    if(isOther){ tmp_tr = $body.find( 'tr.OTHER')[0]; }
    
    async.eachLimit(list_result, 50, bbbResultBatch, bbbResultBatchComplete);
    
    ;function bbbResultBatch(_result, callback){
    		setTimeout(function(){
    			_result = getResultObject(_result, source_year);
    			
	        if(!isOther){ tmp_tr=$body.find( 'tr.'+_result.customerid )[0]; }
            if(typeof(tmp_tr) != 'undefined' && source.map_head.containsKey(_result.fYear)){
                commonBBBM($body, tmp_tr, _result, source.map_head.get(_result.fYear).cellIndex, isOther);
            }
	    		callback(null);
	    }, 45);
    }
    
    ;function bbbResultBatchComplete(err){
    		list_result=[];
    		$(source['used_id']).find('li.'+source['id'].split('@')[1]).animate({backgroundColor: '#1FE26D'}, 100* Math.random() + 600);
    		connectionStatus[source.id]=true; 
    }
    
}
;function accBBBM(list_result, source, isOther){ //in account
    commonBBB_Object(list_result, source, false);
}
;function othBBBM(list_result, source){ //in other account
    commonBBB_Object(list_result, source, true);
}

;function commonSchedul_Object(list_result, source, isOther){
    var $body=$('#rTabId'), tmp_tr, source_year=(source['id'].split('@')[1].replace('_', '-'));
	
    if(isOther){ tmp_tr = $body.find( 'tr.OTHER')[0]; }
    
	async.eachLimit(list_result, 50, schedulResultBatch, schedulResultBatchComplete);
    
    ;function schedulResultBatch(_result, callback){
    		setTimeout(function(){
    			_result = getScheduledObject(_result, source_year);
            if(!isOther){ tmp_tr=$body.find( 'tr.'+_result.customerid )[0]; }
            if(typeof(tmp_tr) != 'undefined' && source.map_head.containsKey(_result.fYear)){
                var _id=(isOther ? 'OTHER' : _result.customerid), 
                    tmp_sched = $body.find( 'tr.sablog'+_id )[0].cells[source.map_head.get(_result.fYear).cellIndex];
        
                tmp_sched.setAttribute('old', sumOf_value(_result.amount, tmp_sched.getAttribute('old')));
            }
	    		callback(null);
	    }, 45);
    }
    
    ;function schedulResultBatchComplete(err){
    		list_result=[];
    		$(source['used_id']).find('li.'+source['id'].split('@')[1]).animate({backgroundColor: '#1FE26D'}, 100* Math.random() + 600);
    		connectionStatus[source.id]=true; 
    }

    ;function sumOf_value(v1, v2){
        return (v1 == 'null' ? v2 : (roundFn((trimNumberOfZero(v1) + trimNumberOfZero(v2)), 2)));
    };
}

;function accScheduled(list_result, source){
    commonSchedul_Object(list_result, source, false);
    
}
;function othScheduled(list_result, source){
    commonSchedul_Object(list_result, source, true);
}
;function queryFailure(error, source){
    var has=false;
    for(var i in error){if(error.hasOwnProperty(i)){has=true;}}
    if(has){
    		var $li=$(source['used_id']).find('li.'+source['id'].split('@')[1]), _text=$.trim($li.text()).substring(0, 1),
    			d='<div id="conneerrorid" class="connerror" style="display:none;"><div><input type="button" t="reload" class="btn" value="'+window.cLabel['reload']+'" /><input type="button" class="btn" value="'+window.cLabel['cancel']+'" /></div><div>'+error['faultstring']+'</div></div>';
    		
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
	var source=e.data.source, callBack = {onSuccess: querySuccess, onFailure: queryFailure, source: source};
	$(source['used_id']).find('li.'+source['id'].split('@')[1]).animate({backgroundColor: '#1F46E2'}, 100* Math.random() + 800)
	.find('div.connerror').removeClass('hover').hide();
	sforce.connection.queryAll(source['psql'], callBack); 
}
;function connection_cancel(e){
	var source=e.data.source;
	connectionStatus[source.id]=true; 
	$(source['used_id']).find('li.'+source['id'].split('@')[1]).off('mouseenter mouseleave')
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
	var source=e.data.source, $div=$(source['used_id']).find('li.'+source['id'].split('@')[1]+' div.connerror');
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


;function finall_Format($body, map_head){
    var currentMonth_index=map_head.get('currency'), list_color=$.parseJSON(document.getElementById('colorid').value),
		list_element = $body.find('tr#rTotalid, tr.findTab, tr.cpforecastcls, tr.shippedcls, tr.demandopencls, tr.ordercls, tr.schedulingagr').toArray();
		
    async.times(list_element.length, function(n, callback){
	    setTimeout(function(){
	    		delay_fn(list_element.shift(), function(cellIndex, target){
	            var _td = target.cells[cellIndex];
	            if(typeof( $(_td).find('img')[0] ) == 'undefined'){
	                _td.innerHTML = ( roundToKM( numberOfZero(_td.getAttribute('old')) ) );
	            }else{
	                $(_td).find('span span').text( roundToKM( numberOfZero(_td.getAttribute('old')) ) );
	            }
	        });
	        callback();
	    }, delay(n));
	}, asynTimeResult);


	;function asynTimeResult(err){
		var cls='tr:not(.bookbillcls):not(.percent):not(.findTab):not(.shippedcls):not(.demandopencls):not(.schedulingagr)';
		list_element = $body.find(cls).toArray();
		async.times(list_element.length, function(n, callback){
		    setTimeout(function(){
		    		delay_fn(list_element.shift(), function(cellIndex, target){
		            var _td = target.cells[cellIndex];
		            if(_td.getAttribute('old') == 'null' || ($(target).hasClass('innobg') && cellIndex < currentMonth_index)){ return; }
		            _td.innerHTML = ( roundToKM( numberOfZero(_td.getAttribute('old')) ) );
		        });
		    }, delay(n));
		}, asynTimeResult1);
	}
    ;function asynTimeResult1(err){
    	
    }
    
    var currentMonthTotal_index = $('#rsmHeadId td.futurec.currentc1.cfixqtotalw')[0].cellIndex;
    processArray($body.find('tr.bookbillcls').toArray(), function(item){
        delay_fn(item, function(cellIndex, target){
            var _td = target.cells[cellIndex];
            if(_td.getAttribute('old') == 'null' || cellIndex > currentMonth_index){ return; }
            _td.innerHTML =  Globalize.format(numberOfZero(_td.getAttribute('old')), 'n2');
        });
    }, function(){});

    processArray($body.find('tr.findTab').toArray().sort(function(){ return (0.5 - Math.random()); }) , function(item){
        void function(item, len, el_pmfc, list_color){
            var i=len+1, max=item.cells.length, _v1, _v2, tmpel= document.createElement('div');
            (function(){
                if(i>=max){ return; }
                if(!$(item.cells[i]).hasClass('cfixqtotalw')){

	                _v1 = trimNumberOfZero(item.cells[i].getAttribute('old'));
	                _v2 = trimNumberOfZero(el_pmfc.cells[i].getAttribute('old'));
	                _v2 = (roundFn(_v2/1000, 0) == 0 ? 0 : _v2);
	                if(_v1 ==0 && _v2 ==0){
	                		return;
	                }
	                
	                if(_v1 !=0 && _v2 !=0){
		                _v1 = (_v1-_v2)/_v2;
					}else if(_v2 == 0 && _v1 != 0){
						_v1 = 1;
					}else if(_v2 != 0 && _v1 == 0){
						_v1 = -1;
					}else if(_v2 == 0 && _v1 == 0){
						_v1 = 0;
					}
	                
	                for(var j=0, _color; _color=list_color[j]; j+=1){
                        tmpel.style.backgroundColor = _color['colorName'];
                        
                        if(_color['maxValue'] !=null && _color['minValue'] !=null){
			            		if(_v1 >= _color['minValue'] && _v1 < _color['maxValue']){
						        $(item.cells[i]).animate({backgroundColor: tmpel.style.backgroundColor}, 100* Math.random() + 400, function(){
			                    		$(this).css({'color': '#fff'}).find('img').addClass('commentimg');
			                    });
					            break;
					        }
			            }else if(_color['maxValue'] != null && _color['minValue'] ==null){
			            		if(_v1 <= _color['maxValue']){
					        		$(item.cells[i]).animate({backgroundColor: tmpel.style.backgroundColor}, 100* Math.random() + 400, function(){
			                    		$(this).css({'color': '#fff'}).find('img').addClass('commentimg');
			                    });
			                    break;
					        }
			            }else if(_color['maxValue'] == null && _color['minValue'] !=null){
			            		if(_v1 >= _color['minValue']){
					        		$(item.cells[i]).animate({backgroundColor: tmpel.style.backgroundColor}, 100* Math.random() + 400, function(){
			                    		$(this).css({'color': '#fff'}).find('img').addClass('commentimg');
			                    });
			                    break;
					        }
			            }

	                }
                }
                i+=1;
                window.setTimeout(arguments.callee, (100* Math.random() + 200));
            })();
        }(item, currentMonth_index, $body.find('tr.pmfc'+item.getAttribute('ovid'))[0], list_color);

    }, function(){});
    
    var data_len=$('#leftTbody tr').length;
    if(data_len == 1){
        loadingAnimate();
    }else{
        data_len = (data_len > 5 ? 5 : data_len);
        setTimeout(function(){
            loadingAnimate();
        }, (100*data_len));
    }
    
}
function delay(n){return (n+12) % 7 *100;}
;function loadingAnimate(){
    $('#pageLoading').animate({top:'50%', left:'50%',width:0, height:0}, 800, function(){
        $(this).removeAttr('style');
        this.style.display='none';
    });
}

;function delay_fn(el_tr, callBack){
    var i=0, len=el_tr.cells.length;
    (function(){
        if(i>=len){ return; }
        callBack(i, el_tr);
        i+=1;
        window.setTimeout(arguments.callee,35);
    })();
}
;function sumOf_currencyWorkingDays($body, map_head, currencyComplete){
	var list_currency=$body.find('tr.currency').toArray();
	async.times(list_currency.length, currencyWorkingDays, currencyComplete);
	
	function currencyWorkingDays(n, callback){
	    setTimeout(function(){
			var oItem_tmp=list_currency.shift(), field_tmp= map_head.get('workDay');
	        
	        var nm0=oItem_tmp.cells[field_tmp.nm0], nm1=oItem_tmp.cells[field_tmp.nm1], 
	            nm2=oItem_tmp.cells[field_tmp.nm2], nm3=oItem_tmp.cells[field_tmp.nm3],
	            cm1=oItem_tmp.cells[field_tmp.cmcell1], cm2=oItem_tmp.cells[field_tmp.cmcell2], cm3=oItem_tmp.cells[field_tmp.cmcell3],
	        
	        cm1_1=numberOfZero(cm1.getAttribute('c1')),cm1_2=numberOfZero(cm1.getAttribute('c2')),
	        cm1_3=numberOfZero(cm1.getAttribute('c3')),cm1_4=numberOfZero(cm1.getAttribute('c4')),
	        
	        cm2_1=numberOfZero(cm2.getAttribute('c1')),cm2_2=numberOfZero(cm2.getAttribute('c2')),
	        cm2_3=numberOfZero(cm2.getAttribute('c3')),cm2_4=numberOfZero(cm2.getAttribute('c4')),
	        
	        cm3_1=numberOfZero(cm3.getAttribute('c1')),cm3_2=numberOfZero(cm3.getAttribute('c2')),
	        cm3_3=numberOfZero(cm3.getAttribute('c3')),cm3_4=numberOfZero(cm3.getAttribute('c4'));
	        cm1=cm2=cm3=null;
	        if(field_tmp['cmtotal'] != 0){
	            var o = workDay_sumOf(cm1_1,cm2_1,cm3_1, field_tmp['cm1'], field_tmp['cm2'], field_tmp['cm3']);
	            cm1_1 = ceilFn(o['ctotal']/o['workday'], 2)*field_tmp[nm0.cellIndex];
	            o = workDay_sumOf(cm1_2,cm2_2,cm3_2, field_tmp['cm1'], field_tmp['cm2'], field_tmp['cm3']);
	            cm1_2 = ceilFn(o['ctotal']/o['workday'], 2)*field_tmp[nm1.cellIndex];
	            o = workDay_sumOf(cm1_3,cm2_3,cm3_3, field_tmp['cm1'], field_tmp['cm2'], field_tmp['cm3']);
	            cm1_3 = ceilFn(o['ctotal']/o['workday'], 2)*field_tmp[nm2.cellIndex];
	            o = workDay_sumOf(cm1_4,cm2_4,cm3_4, field_tmp['cm1'], field_tmp['cm2'], field_tmp['cm3']);
	            cm1_4 = ceilFn(o['ctotal']/o['workday'], 2)*field_tmp[nm3.cellIndex];
	        }else{
	            cm1_1=cm1_2=cm1_3=cm1_4=0;
	        }
	        nm0.setAttribute('old', ceilFn(cm1_1, 2));
	        nm1.setAttribute('old', ceilFn(cm1_2, 2));
	        nm2.setAttribute('old', ceilFn(cm1_3, 2));
	        nm3.setAttribute('old', ceilFn(cm1_4, 2));
	        callback(null);
	    }, delay(n));
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
;function sumOf_initTotal(map_head){
    var $body=$('#rTabId'), list_trs=$body.find('tr.findTab').toArray(), list_total=[];
    
	sumOf_currencyWorkingDays($body, map_head, function(err){
		async.times(list_trs.length, accountLine_total, accountLine_totalComplete);
	});
	
	;function accountLine_total(n, callback){//all line sum of total
		setTimeout(function(){
	    		var _trs=list_trs.shift(), oid=_trs.getAttribute('ovid'), t,
                el_bill=$body.find( 'tr.bill'+oid )[0], el_calcul=$body.find( 'tr.cpfc'+oid )[0], el_pmfc=$body.find( 'tr.pmfc'+oid )[0];
            for(var i=0, max=_trs.cells.length; i<max; i+=1){
            		if(i < map_head.get('currency')){	//check the index manager forcast
            		    if(el_pmfc.cells[i].getAttribute('old') != 'null' && el_pmfc.cells[i].getAttribute('old') != '0'){
            		           _trs.cells[i].setAttribute('old', el_pmfc.cells[i].getAttribute('old'));
            		    }else{
                			if(el_bill.cells[i].getAttribute('biling') != 'null'){ //if the Billings
                        		_trs.cells[i].setAttribute('old', el_bill.cells[i].getAttribute('biling'));
        	                }else{//if the Previous Month Forecast else the Calculated Forecast Proposal
        	                    t=(el_pmfc.cells[i].getAttribute('old') != 'null' ? el_pmfc.cells[i].getAttribute('old') : el_calcul.cells[i].getAttribute('old'));
        	                    _trs.cells[i].setAttribute('old', t);
        	                }
            		    }
            		}
                
                list_total[i] = (typeof(list_total[i]) == 'undefined' ? 'null' : list_total[i]);
                if(_trs.cells[i].getAttribute('old') != 'null'){
                    list_total[i] = ceilFn(trimNumberOfZero(list_total[i])+trimNumberOfZero(_trs.cells[i].getAttribute('old')));
                }
            }
	        callback(null);
	    }, delay(n));
	}
	;function accountLine_totalComplete(err){//next line backlog sum of
		for(var i=0, tr_total=document.getElementById('rTotalid'), max=tr_total.cells.length; i<max; i+=1){
            tr_total.cells[i].setAttribute('old', list_total.shift());  //sum Of cell total
        }
        list_trs=$body.find('tr.blogcls').toArray();
        async.times(list_trs.length, backlogLine_total, backlogLine_totalComplete);	//next
	}
	
	;function backlogLine_total(n, callback){
		setTimeout(function(){
			var tr_blog=list_trs.shift(), tr_order=$body.find('tr.oblog'+tr_blog.getAttribute('sid'))[0], 
	                tr_sched=$body.find('tr.sablog'+tr_blog.getAttribute('sid'))[0];
            for(var i=0, _td, _order, _sched; _td=tr_blog.cells[i]; i+=1){
                _order=tr_order.cells[i].getAttribute('old');
                _sched=tr_sched.cells[i].getAttribute('old');
                if(_order != 'null' || _sched != 'null'){
                    _td.setAttribute('old', ceilFn( (numberOfZero(_order)+numberOfZero(_sched)) , 2));
                }
            }
            callback(null);
		}, delay(n));
		
	}
	;function backlogLine_totalComplete(err){
		list_trs=$body.find('td.cfixqtotalw').toArray();
		async.times(list_trs.length, subQtotal, subQtotalComplete);
	}
	;function subQtotal(n, callback){
		setTimeout(function(){
			var _qTotal = list_trs.shift(), $qTotal=$(_qTotal), 
	            e1=$qTotal.prev()[0].getAttribute('old'), e2=$qTotal.prev().prev()[0].getAttribute('old'), e3=$qTotal.prev().prev().prev()[0].getAttribute('old');
	        if(e1 != 'null' || e2 != 'null' || e3 != 'null'){
	            e1 = ceilFn(trimNumberOfZero(e1)+trimNumberOfZero(e2)+trimNumberOfZero(e3) , 2);
	            _qTotal.setAttribute('old', e1);
	        }
	        if($qTotal.parent()[0].getAttribute('fn') == 'billings'){
	        		e1=$qTotal.prev()[0].getAttribute('biling');
	        		e2=$qTotal.prev().prev()[0].getAttribute('biling');
	        		e3=$qTotal.prev().prev().prev()[0].getAttribute('biling');
	        		e1 = ceilFn(trimNumberOfZero(e1)+trimNumberOfZero(e2)+trimNumberOfZero(e3) , 2);
	            _qTotal.setAttribute('biling', e1);
	        }
			callback(null);
		}, delay(n));
	}
	
	;function subQtotalComplete(err){//2M Accuracy, 6M Accuracy, Quarterly Accuracy
		list_trs=$body.find('tr.percent').toArray();
		async.times(list_trs.length, accuracyLine_total, accuracyLine_totalComplete);	//next
	}
	
	;function accuracyLine_total(n, callback){
		setTimeout(function(){
			var pc_trs=list_trs.shift(), tr_shipped=$body.find('tr.bill'+pc_trs.getAttribute('sid'))[0],
				td_open=$body.find('tr.blog'+pc_trs.getAttribute('sid'))[0];
            for(var i=0, _val, _tr, max=map_head.get('currency'); i<max; i+=1){
            		var td_accuracy=pc_trs.cells[i], _accuracy=numberOfZero(td_accuracy.getAttribute('old')),
            			shipped=numberOfZero(tr_shipped.cells[i].getAttribute('old')),
            			open=numberOfZero(td_open.cells[i].getAttribute('old'));
				
				open=(open+shipped);
				_accuracy=(open == 0 ? 0 : (_accuracy/open)) * 100;
                td_accuracy.innerHTML = _accuracy.toFixed(2) + '%';
            }
			callback(null);
		}, delay(n));
		
	}
	;function accuracyLine_totalComplete(err){
		list_trs=$body.find('tr.bookbillcls').toArray();
		async.times(list_trs.length, booktoBill_total, booktoBill_totalComplete);	//next
	}
	;function booktoBill_total(n, callback){	// (Book to Bill/Billing)
		setTimeout(function(){
			var bill_trs = list_trs.shift(), billing_trs = $(bill_trs).prev()[0];
        		for(var i=0, _td, billing_td; _td=bill_trs.cells[i], billing_td=billing_trs.cells[i]; i+=1){
                var old = parseFloat(_td.getAttribute('old')), billing_old = parseFloat(billing_td.getAttribute('biling'));
                if($.isNumeric(billing_old) && billing_old != 0){
                    old = ($.isNumeric(old) ? old : 0);
                    _td.setAttribute('old', ceilFn(old/billing_old, 2));
                }else{
                		_td.setAttribute('old', 0);
                }
            }
			callback(null);
		}, delay(n));
	}
	
	;function booktoBill_totalComplete(err){
		
		var list_cpfc=$body.find('tr.cpforecastcls').toArray();
	//	console.log(list_cpfc);
		while(list_cpfc.length > 0){
			var list_sum=[], el_cpfc=list_cpfc.shift(), _id=el_cpfc.getAttribute('oid'),
				el_dopen=$body.find('tr.demandopencls.blog'+_id)[0],
				el_curency=$body.find('tr.currency.cur'+_id)[0];
			
			for(var i=0, max=el_dopen.cells.length; i<max; i++){
				var _dopen=trimNumberOfZero( el_dopen.cells[i].getAttribute('old') ),
					_curency=trimNumberOfZero( el_curency.cells[i].getAttribute('old') );
				list_sum.push( (_dopen+_curency) );
			}
			
			for(var i=0, max=el_cpfc.cells.length; i<max; i++){
				el_cpfc.cells[i].setAttribute('old', list_sum[i]);
			}
		}
		
		setTimeout(function(){  //format currency
	        finall_Format($('#rTabId'), map_head);
	    }, 450);
	}
}
function processArray(items, timeProcess, callback){
    if(items.length == 0){return;}
    (function(){
        setTimeout(function(){
            timeProcess(items.shift());
            if (items.length > 0){
                setTimeout(arguments.callee, 45);
            }else{
                callback();
            }
        }, 60);
    })();
}

;function on_over(target){$(target).addClass('bgov');}
;function on_out(target){$(target).removeClass('bgov');}
;function rCellScroll_eve(e){
    var $lCell=$('#lcellbody'), $rCell=$('#rcellhead'), $this=$(this);
    $lCell.scrollTop($this.scrollTop());
    $rCell.scrollLeft($this.scrollLeft());
}


;function windowReSize(){
    setBodyStyle($('#tabContainer').width());
}

;function setBodyStyle(resize_width, isHeight){

    var scrollbarW = $.getScrollbarWidth(), $compbody=$('#compbodyall'), min_cw= parseInt($compbody.css('min-width').replace('px', ''), 10), 
        max_ow=(typeof(resize_width) != 'undefined' ? resize_width : $('#contentallid').outerWidth(true));

    min_cw = (max_ow < min_cw ? min_cw : (max_ow-40));
    document.getElementById('compbodyall').style.width = min_cw+'px';    //set all div width

    var lCellw=$compbody.find('#lcellbody').width(), window_h = $(window).height(),
        r_tab_h = $('#rTabId').height(), rightCell_w=parseInt((min_cw-lCellw-2), 10),
        v_height=0;
    
    v_height = window_h - $('#dmsgid').outerHeight(true) - $('#globalHeaderBar').outerHeight(true) - $('#AppBodyHeader').outerHeight(true) - $('div.bPageFooter.noTableFooter').outerHeight(true);

	v_height = v_height-200;

    document.getElementById('rCellScroll').style.width = (rightCell_w-1)+'px';
    document.getElementById('rcellhead').style.width = (rightCell_w-scrollbarW-1)+'px';
    if($compbody.find('#leftTbody tr').length > 1){
        document.getElementById('rCellScroll').style.height = v_height+'px';
        document.getElementById('lcellbody').style.height = (v_height-scrollbarW-0.3)+'px';
    }else if(isHeight){
        document.getElementById('rCellScroll').style.height = v_height+'px';
        document.getElementById('lcellbody').style.height = (v_height-scrollbarW-0.3)+'px';
    }
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
        var eq=(0), t = $cols.find('th:first').prop('colspan');
        if(!$td.hasClass('futurec1')){
            $cols.find('th:first').prop('colspan', t+s);
        }
    }
}
;function ck_thLeftCell(target, id, searTab, isAll){
    var h = document.getElementById('rCellScroll');
    if(h.style.height == ''){ setBodyStyle(undefined, true); }
    h=null;
    ck_leftCell(target.getElementsByTagName('b')[0] ,id, searTab, isAll);
}

;function allLeftCell(e){
	var target_b = this.getElementsByTagName('b')[0], $b=$(target_b), $left_tab=$('#leftTbody td.left_titlebg'),
		fn={'execute':($b.hasClass('expandall') ? expand : collapse)};
	
	
	fn.execute();
	if($b.hasClass('allbug')){
		$b.removeClass('allbug collapse').addClass('expand');
	}
		
	;function expand(){
		$left_tab.trigger('click');
        $b.removeClass('expandall').addClass('collapseall').parent().find('span').html(function(){
        		return this.getAttribute('exp');
        });
    }
    ;function collapse(){
		$left_tab.trigger('click');
        $b.removeClass('collapseall').addClass('expandall').parent().find('span').html(function(){
        		return this.getAttribute('col');
        });
    }
}

;function ck_leftCell(target, id, searTab, isAll){
    var $this=$(target), fn={'execute':($this.hasClass('expand') ? expand : collapse)};

    fn.execute($this, id, ('#'+searTab), isAll);
    
    ;function expand($this, id, searTab, isAll){
        id=(isAll ? (id+':not(.sbcell)') : id+'.sbcell');
        $this.removeClass('expand').addClass('collapse').css({'float':'right', 'margin-right': '10px'})
        		.parent().parent().removeClass('border_l').addClass('coll pd_0_0').find('div').removeClass('pd_0_0');
        $(searTab).find(('tr.'+id)).removeClass('dn').find('td').addClass('collapse_left ');
        $('#rTabId tr.'+id).removeClass('dn');
    }
    ;function collapse($this, id, searTab, isAll){
        var $tab=$(searTab);
        $this.removeClass('collapse').addClass('expand').css({'float':'left', 'margin-right': '0px'})
			.parent().parent().removeClass('coll pd_0_0').addClass('border_l').find('div').addClass('pd_0_0');
        $tab.find(('tr.'+id+' img.subp')).removeClass('collapse').addClass('expand');   //set img status
        if(isAll){
            $tab.find(('tr.'+id)).addClass('dn');
            $('#rTabId tr.'+id).not('.findTab').addClass('dn');
        }else{
            $tab.find(('tr.sbcell.'+id)).addClass('dn').find('td').removeClass('collapse_left');
            $('#rTabId tr.sbcell.'+id).addClass('dn');
        }
    }
}


;function artMsg(content, target, callBackOk){
    art.dialog({
        title:' ', lock:true, dblclick_hide:false, esc:false, id: 'countsid',
        content: content,
        button : [ {value: 'OK', focus: true, callback: function(){ callBackOk(target); }} ]
    });
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
;function trimNumberOfZero(t){
    t=$.trim(t);
    return ($.isNumeric(t) ? parseFloat(t) : 0);
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

;function roundHasKM(num){
    if(!$.isNumeric(Globalize.parseFloat(num))){ return ''; }
    return (Globalize.parseFloat(num)*1000);
}
;function roundToKM(txt,a){//ok
    txt=Math.round(txt/10)/100;
 //   var point=(/\.0+$/.test(txt.toFixed(2)) ? 'n0' : 'n');
 //   return (Globalize.format(txt, point));
    return (Globalize.format(txt, 'n0'));
}

;function roundToKMBT(txt,type, prefix){//ok
    var point=(/\.0+$/.test(txt.toFixed(2)) ? 'n0' : 'n');
    switch(type){
        case 'K' :
            txt=Math.round(txt/10)/100;
            txt=formatePrefix(txt, point, 'K', prefix);
            break;
        case 'K_M' :
            if(txt<1000000){
                txt=Math.round(txt/10)/100;
                txt=formatePrefix(txt, point, 'K', prefix);
            }
            else{
                txt=Math.round(txt/10000)/100;
                txt=formatePrefix(txt, point, 'M', prefix);
            }
            break;
        case 'M' :
            txt=Math.round(txt/10000)/100;
            txt=formatePrefix(txt, point, 'M', prefix);
            break;
        case 'M_B' :
            if(txt<1000000000){
                txt=Math.round(txt/10000)/100;
                txt=formatePrefix(txt, point, 'M', prefix);
            }else{
                txt=Math.round(txt/10000000)/100;
                txt=formatePrefix(txt, point, 'B', prefix);
            }
            break;
        case 'B' :
            txt=Math.round(txt/10000000)/100;
            txt=formatePrefix(txt, point, 'B', prefix);
            break;
        case 'B_T' :
            if(txt<1000000000000){
                txt=Math.round(txt/10000000)/100;
                txt=formatePrefix(txt, point, 'B', prefix);
            }else{
                txt=Math.round(txt/10000000000)/100;
                txt=formatePrefix(txt, point, 'T', prefix);
            }
            break;
        case 'T' :
            txt=Math.round(txt/10000000000)/100;
            txt=formatePrefix(txt, point, 'T', prefix);
            break;
        case 'K_M_B_T' :
            if(txt<1000000){
                txt=Math.round(txt/10)/100;
                txt=formatePrefix(txt, point, 'K', prefix);
            }else if(txt<1000000000){
                txt=Math.round(txt/10000)/100;
                txt=formatePrefix(txt, point, 'M', prefix);
            }else if(txt<1000000000000){
                txt=Math.round(txt/10000000)/100;
                txt=formatePrefix(txt, point, 'B', prefix);
            }else{
                txt=Math.round(txt/10000000000)/100;
                txt=formatePrefix(txt, point, 'T', prefix);
            }
            break;
        default: txt=Globalize.format(txt, point); break;  
    }
    ;function formatePrefix(txt, point, fx, prefix){
        txt=(Globalize.format(txt, point));
        if(prefix){txt+=fx;}
        return txt;
    }
    return txt;
}