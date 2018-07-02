var TIMEOUT, scrollbarW = $.getScrollbarWidth(), STATIC_VAR={}, SAVE_ERRORS=[], QUEUE = async.queue(queueRun, 1),
	DECIMAL_POINT = {'n': 'n', 'n0': 'n0', 'n1': 'n1', 'n4': 'n4'}, 
	CATCH_DATA = {'level1': {}, 'level2': {}, 'level3': {}, 'ISTOP':false, 'DEL1': {}, 'DEL2': {}, 'DEL3': {} },
	LAZY = {
		'fire' : function(obj, callback, timeout) {
		    timeout = timeout || 200;
		    setTimeout(function() { callback(null, obj); }, timeout);
		}
	}, 
	WORK_CLS = {
		'level1' : 'CSD_ClsSoldToService.SearchSoldTo', 'level2' : 'CSD_ClsSoldToService.SearchOEM', 'level3' : 'CSD_ClsSoldToService.SearchPart',
		'restsoldto': 'CSD_ClsSoldToService.SearchRestSoldTo', 'nonoems': 'CSD_ClsSoldToService.SearchNonOEMs', 'level0' : 'CSD_ClsSoldToService.SearchTotal'
	},
	EVENT_BIND ={
        'beforeunload': function(){
			$(window).unbind("beforeunload");
        },
        'beforeload': function(){
            $(window).bind("beforeunload", function(){
                return "Your change values, please do not close this window";
            });   
        }
    },
	
 /* Added by Cap team for DNDP1*/
	isTotalRowInserted = false,
	expandClickCurrentTarget = null,
	self = this,
	partInfoChangeArray = [],
	testCounter = 0;
	RestPart = false;
	ischecked = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false];
	isdelpart=false;
	toadddeletedpart =false;
	
/* End by Cap team for DNDP1*/
;function queueRun(task, callback) {
    task.run(callback);
}
/* Added by Cap Team to add Total Part Sum row logic for DNDP1 */
function addPartTotalRow() {
		if ($(this.expandClickCurrentTarget).hasClass('level2')) {
			setTimeout(function(){
				var expandClickCurrentTarget = this.expandClickCurrentTarget,
					expandClickCurrentTargetIndex = expandClickCurrentTarget.rowIndex,
					expandClickCurrentTargetId = $(expandClickCurrentTarget).attr('id'),
					partInfoChangeArray = $.unique(this.partInfoChangeArray),
					historicalColumnCount = 6;
					soldToAcctId = $('#ltabid tr:eq(' + (expandClickCurrentTargetIndex - $(expandClickCurrentTarget).prevUntil('.level1:not(.dn)').length - 1) +')').attr('id');
				$('.row-static-total_' + expandClickCurrentTargetId).remove();
				$('.row-static-total-right_' + expandClickCurrentTargetId).remove();
				var $elem = '<tr class="row-static-total row-static-total_' + expandClickCurrentTargetId +' row-static-total_'+ soldToAcctId +'">'
							+ '<td><apex:outputPanel >'
							+ '<div ><span></span></div>'
							+ '<div  ><span></span></div>'
							+ '<div><span>  </span></div>'
							+ '</apex:outputPanel></td>'
							+ '<td ><font color="red"><b>Total Part Sum</b></font></td>'
							+'</tr>';
				//$($elem).insertAfter('.ltbodycls .level2:not(.dn)');
				$($elem).insertAfter(expandClickCurrentTarget);
				
				//$('.row-static-total_' + expandClickCurrentTargetId).removeClass('dn');
				
				var counter = 0,
					endValue = $('#tab_head_list td').length,
					rightPartRow = '<tr id="totalrw" class="row-static-total-right row-static-total-right_' + expandClickCurrentTargetId +' row-static-total_'+ soldToAcctId +'">',
					historicalCount = $('#tab_head_list td:not(.futurecls):not(.currentcls)').length,
					currentCount = $('#tab_head_list td:not(.futurecls):not(.historicalcls)').length,
					futureCount = $('#tab_head_list td:not(.currentcls):not(.historicalcls)').length;
					
				for (; counter < endValue; counter++) {
					if (counter < historicalCount) {
						rightPartRow += '<td class="dn"></td>';
					} else {
						rightPartRow += '<td></td>';
					}
				}
				
				rightPartRow += '</tr>'
				
				//$(rightPartRow).insertAfter('#rtabid .rlevel2:not(.dn)');
				$(rightPartRow).insertAfter('#rtabid tr:eq(' + expandClickCurrentTargetIndex +')');
				
				isTotalRowInserted = true;
				
				var requiredRowNumber = expandClickCurrentTargetIndex + 2,
					partTotalRowNumber = requiredRowNumber - 1,
					$lBody=$(expandClickCurrentTarget).parent(),
					partTotal = [],
					$rBody=$('#rtabid'),
					hiddenPartLength = $lBody.find('tr.mark.level3.'+$(expandClickCurrentTarget).attr('id')+'_level2.'+$(expandClickCurrentTarget).attr('data-sid')+'_level1').prevUntil('.row-static-total').length;
					
					counter = 0;
					
					requiredRowNumber += hiddenPartLength;
					
					$lBody.find('tr.mark.level3.'+$(expandClickCurrentTarget).attr('id')+'_level2.'+$(expandClickCurrentTarget).attr('data-sid')+'_level1').each(function(index){
						var t;
						counter = 0;
						endValue = $('#tab_head_list td').length
						for (; counter < endValue; counter++) {
							t=Globalize.parseInt( $.trim($rBody.find('tr:eq('+(requiredRowNumber - (index * 7))+')').find('td:eq('+counter+')').text()) );
							if (!partTotal[counter]) {
								partTotal[counter] = 0;
							}
							partTotal[counter] += t;
						}
				});
					counter = 0;
					for (;counter < endValue; counter++) {
						//$rBody.find('tr:eq('+partTotalRowNumber+')').find('td:eq('+counter+')').text(partTotal[counter]);
						$rBody.find('tr:eq('+partTotalRowNumber+')').find('td:eq('+counter+')').text(Globalize.format(partTotal[counter],DECIMAL_POINT['n0']));

					}
					
					
					counter = 0;
					for (;counter < partInfoChangeArray.length; counter++) {
					
					if (ischecked[partInfoChangeArray[counter]-1] == true){	
					
					
					ischecked[partInfoChangeArray[counter]-1] = false;
					$rBody.find('tr:eq('+expandClickCurrentTargetIndex+')').find('td:eq('+(partInfoChangeArray[counter]+historicalColumnCount)+')').find('input').val(partTotal[partInfoChangeArray[counter] + historicalColumnCount]);								
					
					$rBody.find('tr:eq('+expandClickCurrentTargetIndex+')').find('td:eq('+(partInfoChangeArray[counter]+historicalColumnCount)+')').find('input').trigger('change');
					}
					}
					if(isdelpart==true){
					 counter = 0;
						for (;counter < futureCount; counter++) {
					
	
					$rBody.find('tr:eq('+expandClickCurrentTargetIndex+')').find('td:eq('+(counter+historicalColumnCount)+')').find('input').val(partTotal[counter + historicalColumnCount]); 

					$rBody.find('tr:eq('+expandClickCurrentTargetIndex+')').find('td:eq('+(counter+historicalColumnCount)+')').find('input').trigger('change');

	
					}
					isdelpart=false;
					
					}
					if(toadddeletedpart==true){
					 counter = 0;
						for (;counter < futureCount; counter++) {
					
	
					$rBody.find('tr:eq('+expandClickCurrentTargetIndex+')').find('td:eq('+(counter+historicalColumnCount)+')').find('input').val(partTotal[counter + historicalColumnCount]); 

					$rBody.find('tr:eq('+expandClickCurrentTargetIndex+')').find('td:eq('+(counter+historicalColumnCount)+')').find('input').trigger('change');

	
					}
					toadddeletedpart=false;
					
					}
					
					},65);
          }
      }
/* End by Cap Team to add Total Part Sum row logic for DNDP1 */	

;function initCtrlDocument(){
	  
	Globalize.culture(this.locale).numberFormat.currency.symbol = "";
	
	fixTableLayout();
	$('#floatscroll').css({'height': scrollbarW, 'line-height': scrollbarW});
	register_event();
	$('#menuBtntd input[data-type="historical"]').click();
	$('div.csd_menu_div span').before('<div class="csd_view_div">'+$('#hidd_managername').val()+'</div>');
	
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
	
}

;function finallyFormat(){
	try{
		var $lBody=$('#ltabid'), $rBody=$('#rtabid'), $lTotal=$lBody.find('tr:first'),
			$totalCells=$rBody.find('tr:first td').css({'font-style': 'italic', 'font-weight': 'bold'}),
			cellIndex=$('#tab_head_list td.currentcls')[0].cellIndex-1, set_selectedId=[];
		
		$lBody.find('tr.level1.'+$lTotal.attr('id')+'_level1:not(.mark)').each(function(){
			$rBody.find('tr:eq('+this.rowIndex+')').remove();
			$(this).remove();
		});
		$lTotal.off('click').removeClass('cp mark').find('td:last').empty().css({'box-shadow': 'none'}).parent()
				.find('span').empty().css({'font-weight': 'bold', 'padding-left': '34px'}).html(function(){
					return '<img src="/s.gif" class="helpIcon" title="Billing total for histrical months, forecast total for current/future months."/> '+
							$lTotal.attr('data-number');
				});
		
		createTotalRefDate($lBody, $rBody);
		
		/*
		$rBody.find('tr:not(:first)').each(function(){
			$(this).find('td').html(function(){
				return Globalize.format(getZeroOfNumber(this.getAttribute('data-old')), DECIMAL_POINT['n0'])
			});
		});
		
		*/
		$lBody.find('tr:not(:first).mark.level1').each(function(){
			var $this=$(this), number=this.getAttribute('data-number');
			if(this.getAttribute('data-isd') == 'NoDel'){
				$this.find('span.del_img').remove();
			}
			$this.find('td:last').append('<input onclick="event_commentBtn_click(event, this)" value="EOL comment" type="button" class="btn commentbtn" />');
			$this.find('span.namecell').html(number+'-[ '+this.getAttribute('data-title')+' ]');
			
			$rBody.find('tr:eq('+this.rowIndex+') td').each(function(){
				var $td=$(this), $pmFc=$td.parent().next().find('td:eq('+this.cellIndex+')'), 
					$dcFc=$pmFc.parent().next().find('td:eq('+this.cellIndex+')');
				if(this.cellIndex > cellIndex){
					$pmFc.html(function(){
						return Globalize.format(getZeroOfNumber($pmFc.attr('data-pmfc')), DECIMAL_POINT['n0']);
					});
					$dcFc.html(function(){
						return Globalize.format(getZeroOfNumber($dcFc.attr('data-dcfc')), DECIMAL_POINT['n0']);
					});
				}
				$td.html( Globalize.format(getZeroOfNumber(this.getAttribute('data-old')), DECIMAL_POINT['n0']) );
			});
			
			set_selectedId.push(number);
		});
		
		var json={'json': {'managerId': $('#hidd_manager').val(), 'map_year_monthsFuture': $.parseJSON($('#hidd_futuremonthmap').val()), 
							'set_selectedId': set_selectedId, 'startDate': $('#hidd_start').val(), 'endDate': $('#hidd_end').val()} 
				};
		json['json'] = JSON.stringify(json['json']);
		json['data-level'] = 'level1';
		json['cellIdx'] = cellIndex;
		customRemoteAction(json, autoCreateOEMForecast_js, complete_autoCreateOEMForecast);
		
	}catch(e){ }

	;function createTotalRefDate($lBody, $rBody){
		var list_result=[], list_months=[], el_body='', 
			datas={'$lBody': $lBody, '$rBody': $rBody, 'monthCell': {}, 'cellMonth': {}, 'manangerid': $('#hidd_manager').val(),
				'cls': WORK_CLS['level0'], '$row': $lBody.find('tr:first td:first'), '$rCells': $rBody.find('tr:first td'), 
				'action': getTotalBillingData_js, 'complete': complete_refTotalBillingData
			};
		
		$('#tab_head_list td:not(.futurecls):not(.currentcls)').each(function(){
			var cell=this.cellIndex, month=this.getAttribute('data-month');
			datas['monthCell'][month] = cell;
			datas['cellMonth'][cell] = month;
			list_result.push(month);
		});

		for(var i=0, max=list_result.length; i<max; i++){
			var list_t=list_result.slice(i,i+1);
			list_months.push(list_result[i]);
			el_body += '<b data-months="'+list_result[i]+'" data-status="false" class="ref_box">[M-'+i+']</b>';
		}

		datas['$row'].append(el_body);
		asyncEachSeries_Original(list_months, function(month, callback){
			var attr_tmp=$.extend({}, datas);
			attr_tmp['smonths'] = month;
			attr_tmp['json'] = {'set_fiscalMonth': [month], 'manangerId': attr_tmp['manangerid'] };
			attr_tmp['json'] = JSON.stringify(attr_tmp['json']);
			customMultipleRemoteAction(attr_tmp, attr_tmp['action'], attr_tmp['complete']); //this is remote action
		}, function(err){}, 120);
	}
}

;function register_event(){
	var $body_div = $('#div_body');
	
	$body_div.find('#'+GLOBAL['REST_SOLDTO']).removeClass('cp')
			 .find('div:first').css({'visibility':'hidden'}).parent().find('div.mgleft1')
			 .removeClass('mgleft1').find('span.fcell').remove();
	
	$body_div.find('#ltabid tr.totcls div.mgleft1').removeClass('mgleft1').find('span.fcell').removeClass('fcell').addClass('pin spin').html('&nbsp;');
	$body_div.find('#ltabid span.pin').on('click', event_refData_click);
	
	$body_div.find('#rCellScroll').scroll(event_rCellScroll);
	$body_div.find('#ltabid tr.cp').on('click', event_existData_click);
//	$body_div.find('#accountbtnid').on('click', event_popupBox_click);
	$body_div.find('tbody.overbody tr').on('mouseenter mouseleave', event_table_over);
	$('#savefcbtn').on('click', event_saveEditPart_click);
	$('#searchtext').on('keyup', event_searchText_keyup);
	$('#menuBtntd input').on('click', event_hideCalendar_click);
	$('#searchbtn').on('click', event_searchBtn_click);
	$('#addobjectbtn').on('click', event_addSearchObject_click);
	$('#popuphead input[type="checkbox"]').on('click', event_checkBox_click);
	$('#menuBtntd input:first').before('<input data-level="level1" value="Search soldto" onclick="event_popupBox_click(event, this)" type="button" class="btn btnlevel1" />');
	
	$(document).on('mousedown', {'elDrop': document.getElementById('dropBoxId'), '$aBox': $('#forecastdiv_id')}, event_dorpBox_down);

	$(window).scroll(event_windowScroll).smartresize(event_windowReSize);
	$('#floatscroll').scroll(event_floatScroll);
}

;function checkingStatus(){
	if($('#ltabid span.wating').length == 0){	//checked access remote function.
		return false;
	}
	return true;
}


;function setProgressBarStatus(pBarConfg, totalLen, $pBar){
	$('div.progress_cls').show();
	$pBar.progressbar({ max: pBarConfg['max'], change: event_pBar_change, complete: event_pBar_complete })
		.find('.ui-progressbar-value').css({ "background": pBarConfg['bgcolor'] });	
		
	$('#progresserror').css({'background': pBarConfg['rgba'], 'top': '-120%'}).animate({top: '10%'}, 360, animateComplete);
	
	/* START HELP method */
	;function animateComplete(){
		$('#prg_total').html( totalLen );
		$('#prg_scues').html(0);
		$('#prg_err').html(0);
	}
	/* END HELP method */
}

/*
* Prabhanjan: Added pasteFromClipboard() method as an attribute to inputcls data.
*/

;function setTemplateElement(data){
	var monthCell={}, cellMonth={}, $head=$('#tab_head_list td'), 
		list_hidden_td=$head.filter('.dn').toArray(), ftCell=$head.filter('.currentcls')[0].cellIndex;
	
	$head.each(function(){
//	$head.filter(':gt('+(ftCell-1)+')').each(function(){
		cellMonth[this.cellIndex] = this.getAttribute('data-month');
		monthCell[this.getAttribute('data-month')] = this.cellIndex;
	});
	data['cellMonth'] = cellMonth;
	data['monthCell'] = monthCell;
	data['ftCell']=ftCell;

	switch(data['data-level']){
		case 'level1' :
			data['$left'] = $('#ltabid tr:first');
			data['$right'] = $('#rtabid tr:first');
			data['$left_template'] = $('#soldto_left tr').clone();
			data['$right_template'] = $('#soldto_right tr').clone();
			data['$right_template'].first().find('td:gt('+ftCell+')').addClass('td_input');
			data['fn'] = appendElement_Level1;
			break;
		case 'level2' :
			data['$left'] = $( ('#ltabid tr.level1.'+data['pid']+'_level1') ).last();
			data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');
			data['$left_template'] = $('#oem_left tr').clone();
			data['$right_template'] = $('#oem_right tr').clone();
			data['$right_template'].first().find('td:gt('+ftCell+')').addClass('td_input').html('<input type="text" data-type="level2" class="inputcls" onpaste="pasteFromClipboard(event, this)"/>');
			data['fn'] = appendElement_Level2;

			break;
		case 'level3' :
			var $level2 = $( ('#ltabid tr.level2.'+data['pid']+'_level2.'+data['soldtoid']+'_level1') );
			data['$left'] = $level2.last();
			data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');
			data['sid'] = $level2.first().attr('data-sid');
			data['$left_template'] = $('#part_left tr').clone();
			data['$right_template'] = $('#part_right tr').clone();
			data['$right_template'].first().find('td:gt('+ftCell+')').addClass('td_input');//.html('<input type="text" data-type="level3" class="inputcls" onpaste="pasteFromClipboard(event, this)"/>');
			data['$left_template'].first().find('td:last').on('click', event_editPartPopupBox_click);
			data['$left_template'].find('span.pin').on('click', event_refData_click);
			data['fn'] = appendElement_Level3;
			break;
			
			
	}
	data['$right_template'].each(function(){
		var $tds = $(this).find('td');
		for(var i=0, el; el=list_hidden_td[i]; i++){
			$tds.eq(el.cellIndex).addClass('dn');
		}
	});
	data['$left_template'].on('mouseenter mouseleave', event_table_over).filter('.cp')
						  .on('click', event_existData_click)
						  .find('span.pin').on('click', event_refData_click);
	data['$right_template'].on('mouseenter mouseleave', event_table_over).find('input[type="text"]')
							.on('focus change keyup', event_input_change);
	event_windowScroll();
}

<!--Prabhanjan adding    pasteFromClipboard -->
;function pasteFromClipboard(event, elemval){ 
setTimeout(function () {   
    var clipboardText = elemval.value; 
    var xlDatarows = clipboardText.split("\n"); 
    var xlDatacells = xlDatarows[0].split("\t");  /*this is meant for only first row of copied data */ 
    var icounter = 0;
    elemval.value = Number(xlDatacells[icounter].replace(/[^0-9\.]+/g,""));
    $(elemval).trigger("change");   
    $(elemval).parentsUntil("tr").nextAll().children().each(function() {
        icounter++;
        if(xlDatacells.length>icounter){
            $(this).val(Number(xlDatacells[icounter].replace(/[^0-9\.]+/g,"")));
            $(this).trigger("change"); 
        }    
    });
    }, 100);
     
} 


;function appendElement_Level1(data, callBack, callBackEnd){

	asyncEachSeries_Original(data['list_result'], function(item, call){
		var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true);
		$lClone.addClass( (item['id']+'_'+data['data-level']) )
				.eq(0).attr({'id': item['id'], 'title': item['name'], 'data-title': item['name'], 'data-region': item['region'], 'data-number': item['accnumber'], 'data-cmt': item['eolcomment']})
				.find('span.namecell').html(item['accnumber']+'-[ '+item['name']+' ]');
		$lClone.eq(0).find('td:last')
				.append('<input onclick="event_commentBtn_click(event, this)" value="EOL comment" type="button" class="btn commentbtn" />'); 
		
		$rClone.addClass('rlevel1').eq(0).find('td').html(function(){
			var attr={'data-old': 0};
			if(item['csFC'] && item['csFC'].hasOwnProperty( data['cellMonth'][this.cellIndex] )){
				attr['data-old'] = (item['csFC'][data['cellMonth'][this.cellIndex]]);	
			}
			this.setAttribute('data-old', attr['data-old']);
			return Globalize.format(attr['data-old'], DECIMAL_POINT['n0']);
		});
		
		setFieldValue($rClone.eq(1).find('td:gt('+(data['ftCell']-1)+')'), data, item['pmFC']);
		setFieldValue($rClone.eq(2).find('td:gt('+(data['ftCell']-1)+')'), data, item['dcFC']);
		
		if(CATCH_DATA['level1'].hasOwnProperty(item['id'])){
			delete CATCH_DATA['level1'][item['id']];
		}
		data['$left'].after($lClone);
		data['$right'].after($rClone);
		
	}, function(err){
		var o_total={}, $rBody=$('#rtabid');
		data['$left'].parent().find('tr.level1.mark').each(function(){
			$rBody.find('tr:eq('+this.rowIndex+')').find('td:gt('+(data['ftCell']-1)+')').each(function(){
				var $this=$(this), $input=$this.find('input'), t=($input.length == 0 ? $this.html() : $input.val());
				o_total[this.cellIndex] = (getZeroOfNumber(o_total[this.cellIndex]) + Globalize.parseInt(t));
			});
		});
		for(var o in o_total){
			$rBody.find('td:eq('+o+')').html( Globalize.format(o_total[o], DECIMAL_POINT['n0']) );
		}
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

;function appendElement_Level2(data, callBack, callBackEnd){

	asyncEachSeries_Original(data['list_result'], function(item, call){

		var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true);
		$lClone.addClass( (data['pid']+'_level1 '+item['id']+'_level2') ).eq(0)
				.attr({'id': item['id'], 'data-region': item['region'], 'data-sid': data['pid'], 'data-title': data['title'],
						'data-number': data['data-number'], 'title': item['region']}).find('span.namecell').html(item['name']);

		//:gt('+(data['ftCell']-1)+')
		$rClone.addClass('rlevel2').eq(0).find('td').each(function(){
			var $this=$(this), $input=$this.find('input'), attr = { 'data-old': 0, 'data-rest':0 };
			if(item['csFC'] && item['csFC'].hasOwnProperty( data['cellMonth'][this.cellIndex] )){
				attr['data-old'] = (item['csFC'][data['cellMonth'][this.cellIndex]]);	
			}
			if(item['restPNFC'] && item['restPNFC'].hasOwnProperty( data['cellMonth'][this.cellIndex] )){
				attr['data-rest'] = (item['restPNFC'][data['cellMonth'][this.cellIndex]]);	
			}
			$this.attr(attr);
			if(this.cellIndex >= data['ftCell']){
				if($input.length == 0){ $this.html( Globalize.format(attr['data-old'], DECIMAL_POINT['n0']) ); }
				else{ $input.val( Globalize.format(attr['data-old'], DECIMAL_POINT['n0']) ); }
			}else{
				$this.html( Globalize.format(attr['data-old'], DECIMAL_POINT['n0']) );
			}
		});
		
		setFieldValue($rClone.eq(1).find('td:gt('+(data['ftCell']-1)+')'), data, item['pmFC']);
		setFieldValue($rClone.eq(2).find('td:gt('+(data['ftCell']-1)+')'), data, item['dcFC']);

		if(item['id'] == GLOBAL['NON_OEM'] || item['type'] == 'NoDel'){ $lClone.find('span.del_img').remove(); }

		data['$left'].after($lClone);
		data['$right'].after($rClone);
		
		if(CATCH_DATA['level2'].hasOwnProperty(data['pid'])){
			for(var i=0, catchId; catchId=CATCH_DATA['level2'][data['pid']][i]; i++){
				if(catchId == item['id']){ 
					CATCH_DATA['level2'][data['pid']] = CATCH_DATA['level2'][data['pid']].delIndex(i);
					break;
				}
			}
		}


		/* Prabhanjan adding backlog button for OEM's only*/	
		if(item['id'] != GLOBAL['NON_OEM']){
			$lClone.eq(0).find('span:last')
					.append('<input onclick="showbacklogmodal(this)" value="Copy OEM Backlog" type="button" class="btn oembacklog" />');	

		}			
		

	}, function(err){
		if(data['insert'] == 'search'){
			setRowTotals(data);
		}
		
		var o_total={}, $rBody=$('#rtabid');
		data['$left'].parent().find('tr.level1.mark').each(function(){
			$rBody.find('tr:eq('+this.rowIndex+')').find('td:gt('+(data['ftCell']-1)+')').each(function(){
				var $this=$(this), $input=$this.find('input'), t=($input.length == 0 ? $this.html() : $input.val());
				o_total[this.cellIndex] = (getZeroOfNumber(o_total[this.cellIndex]) + Globalize.parseInt(t));
			});
		});
		for(var o in o_total){
			$rBody.find('td:eq('+o+')').html( Globalize.format(o_total[o], DECIMAL_POINT['n0']) );
		}
		callBackEnd(callBack, data);
	}, 150);
	
	;function setRowTotals(data){

		var map_fc={'csfc': {}, 'pmfc': {}, 'dcfc': {}}, $lBody=data['$left'].parent(), $rBody=data['$right'].parent(),
			$rCells=$rBody.find('tr:eq('+$lBody.find('tr.mark.level1.'+data['soldtoid']+'_level1').index()+')').find('td');
		
		$lBody.find('tr.mark.level2.'+data['soldtoid']+'_level1').each(function(){
			$rBody.find('tr:eq('+this.rowIndex+')').find('td:gt('+(data['ftCell']-1)+')').each(function(){
				var $this=$(this), $pmfc=$this.parent().next().find('td:eq('+this.cellIndex+')'),
					$dcfc=$this.parent().next().next().find('td:eq('+this.cellIndex+')'),
					cs=getZeroOfNumber($this.attr('data-old')), pm=getZeroOfNumber($pmfc.attr('data-old')),
					dc=getZeroOfNumber($dcfc.attr('data-old'));
				
				if(!map_fc['csfc'].hasOwnProperty(this.cellIndex)){
					map_fc['csfc'][this.cellIndex] = 0;
				}
				if(!map_fc['pmfc'].hasOwnProperty(this.cellIndex)){
					map_fc['pmfc'][this.cellIndex] = 0;
				}
				if(!map_fc['dcfc'].hasOwnProperty(this.cellIndex)){
					map_fc['dcfc'][this.cellIndex] = 0;
				}
				map_fc['csfc'][this.cellIndex] += cs;
				map_fc['pmfc'][this.cellIndex] += pm;
				map_fc['dcfc'][this.cellIndex] += dc;
			});
		});
		
		for(var key in map_fc['csfc']){
			$rCells.eq(key).attr('data-old', map_fc['csfc'][key]).html( Globalize.format(map_fc['csfc'][key], DECIMAL_POINT['n0']) );
		}
		for(var key in map_fc['pmfc']){
			$rCells.parent().next().eq(key).attr('data-old', map_fc['pmfc'][key]).html( Globalize.format(map_fc['pmfc'][key], DECIMAL_POINT['n0']) );
		}
		for(var key in map_fc['dcfc']){
			$rCells.parent().next().next().eq(key).attr('data-old', map_fc['dcfc'][key]).html( Globalize.format(map_fc['dcfc'][key], DECIMAL_POINT['n0']) );
		}
	}
	
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

;function appendElement_Level3(data, callBack, callBackEnd){
	var map_rest={};
	asyncEachSeries_Original(data['list_result'], function(item, call){
		var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true);
		$lClone.addClass( (data['pid']+'_level2 '+item['id']+'_level3 '+data['sid']+'_level1') )
				.eq(0).attr({'id': item['id'], 'data-sid': data['sid'], 'data-pid': data['pid'], 'title': item['region'],
							 'data-title': data['title'], 'data-region': item['region'], 'data-number': data['data-number']})
				.find('span.namecell').html(item['name']);
		//+'-[ '+item['snumber']+' ]'
		$lClone.eq(0).find('td:last').attr('data-iscft', item['hasCFTFC']);
		//:gt('+(data['ftCell']-1)+')
		$rClone.addClass('rlevel3').eq(0).find('td').each(function(){
			var attr = { 'data-nprice':0, 'data-nqty':0, 'data-price':0, 'data-qty': 0, 'data-old': 0 };
			if(!map_rest.hasOwnProperty(this.cellIndex) && this.cellIndex >= data['ftCell']){
				map_rest[this.cellIndex] = 0;
			}
			if(item['csFC'] && item['csFC'].hasOwnProperty( data['cellMonth'][this.cellIndex] )){
				var  o = item['csFC'][data['cellMonth'][this.cellIndex]];
				attr['data-nprice']=o['price'];
				attr['data-price']=o['price'];
				attr['data-nqty']=o['quantity'];
				attr['data-qty']=o['quantity'];
				attr['data-old']=o['forecast'];
			}
			if(this.cellIndex >= data['ftCell']){
				map_rest[this.cellIndex] += attr['data-old'];
			}
			$(this).attr(attr);
		});
		$rClone.eq(0).find('td').html(function(){
			var old=Globalize.format(getZeroOfNumber($(this).attr('data-old')), DECIMAL_POINT['n0']);
			toadddeletedpart=true;
			return old;
			
			
		});
		setFieldValue($rClone.eq(1).find('td:gt('+(data['ftCell']-1)+')'), data, item['pmFC']);
		setFieldValue($rClone.eq(2).find('td:gt('+(data['ftCell']-1)+')'), data, item['dcFC']);

		data['$left'].after($lClone);
		data['$right'].after($rClone);
		var soldto_oem = (data['sid']+'_'+data['pid']);
		if(CATCH_DATA['level3'].hasOwnProperty(soldto_oem)){
			for(var i=0, catchId; catchId=CATCH_DATA['level3'][soldto_oem][i]; i++){
				if(catchId == item['id']){ 
					CATCH_DATA['level3'][soldto_oem] = CATCH_DATA['level3'][soldto_oem].delIndex(i);
					break;
				}
			}
		}
		
	}, function(err){
		
		if(data['insert'] == 'search'){
			var $oemLrow=data['$left'].parent().find('tr.mark.level2.'+data['pid']+'_level2.'+data['sid']+'_level1'),
				$oemCells=data['$right'].parent().find('tr:eq('+$oemLrow.index()+')').find('td');
			for(var cell in map_rest){
				var $cell=$oemCells.eq(cell), t=getZeroOfNumber($cell.attr('data-rest')), rest=t-map_rest[cell];
				/*if(rest < 0){
					rest = (-rest);
					$cell.find('input').val( Globalize.format(rest, DECIMAL_POINT['n0']) );
				}
				$cell.attr('data-rest', rest);*/
			}
			if(toadddeletedpart==true){
          	
			addPartTotalRow();
          }
		}
		
		callBackEnd(callBack, data);
	}, 150);
	
	;function setFieldValue($rCell, data, fc){
		$rCell.each(function(){
			var attr = { 'data-old': 0 };
			if(fc && fc.hasOwnProperty( data['cellMonth'][this.cellIndex] )){
				attr['data-old'] = (fc[data['cellMonth'][this.cellIndex]]);	
			}
			$(this).attr(attr).html( Globalize.format(attr['data-old'], DECIMAL_POINT['n0']) );
		});
	}
}

;function remoteActionCreateObject(list_data, cellMonth, $pBar, $rBody){
	var list_parallel=[],  pBarConfg=getBarConfg(list_data);
	setProgressBarStatus(pBarConfg, list_data.length, $pBar);
	
	async.each(list_data, function(item, callback) {
	    setTimeout(function(){
	    	var o = {'cls': '', 'action': saveCSDsObject_js, 'complete': complete_saveSObject, 'asynComplete': function(){},
	    			 'json': '{}', 'pct': pBarConfg['pct'], 'max': pBarConfg['max'], 'cellMonth': cellMonth,
	    			 '$pBar': $pBar, '$lRow': $(item), '$rRow': $rBody.find('tr:eq('+item.rowIndex+')')};

	    	switch(item.getAttribute('data-level')){
	    		case 'level1' : 
	    			o['type'] = 'level1';
	    			o['cls'] = WORK_CLS['level1'];
	    			list_parallel.push(function(cb){ createSoldTo_JSON(o, cb); });
	    			break;
	    		case 'level2' : 
	    			o['type'] = 'level2';
	    			o['cls'] = (item.id == GLOBAL['NON_OEM'] ? WORK_CLS['nonoems'] : WORK_CLS['level2']);
	    			list_parallel.push(function(cb){ createOEM_JSON(o, cb); });
	    			break;
	    		case 'level3' : 
	    			o['type'] = 'level3';
	    			o['cls'] = WORK_CLS['level3'];
	    			list_parallel.push(function(cb){ createPart_JSON(o, cb); });
	    			break;
	    	}
	        callback(null);
	    }, 260);
	}, function(err) {
		async.parallel(list_parallel, function(err, results) { });
	});
	
	;function createSoldTo_JSON(o, cb){

		var json = {'id': o['$lRow'].attr('id'), 'name': o['$lRow'].attr('title'), 'region': o['$lRow'].attr('data-region'), 
					'managerId': $('#hidd_manager').val(), 'accnumber': o['$lRow'].attr('data-number'), 'csFC': {}};
		
		for(cell in o['cellMonth']){
			var key = (o['cellMonth'][cell]), $soldTo=o['$rRow'].find('td:eq('+cell+')'),
				value = Globalize.parseInt( $.trim($soldTo.text()) );

			json['csFC'][key] = value;
		}

		o['json'] = JSON.stringify(json);
		o['name'] = o['$lRow'].attr('title');
		customMultipleRemoteAction(o, o['action'], o['complete']);
		cb();
	}
	
	;function createOEM_JSON(o, cb){
		
		var region = (o['$lRow'].attr('id') != GLOBAL['NON_OEM'] ? o['$lRow'].attr('data-region') : 
						o['$lRow'].parent().find('tr.level1.mark.'+o['$lRow'].attr('data-sid')+'_level1').attr('data-region')
				);

		var json = {'oemId': o['$lRow'].attr('id'), 'id': o['$lRow'].attr('data-sid'), 'name': o['$lRow'].attr('data-title'), 
					'managerId': $('#hidd_manager').val(), 'accnumber': o['$lRow'].attr('data-number'), 'region': region, 'csFC': {}, 'restPNFC': {}
					};
		
		for(cell in o['cellMonth']){
			var key = (o['cellMonth'][cell]),
				value = Globalize.parseInt( $.trim(o['$rRow'].find('td:eq('+cell+') input').val()) ),
				restValue = getZeroOfNumber_Int( o['$rRow'].find('td:eq('+cell+')').attr('data-rest') );
			json['csFC'][key] = value;
			json['restPNFC'][key] = restValue;
		}

		o['json'] = JSON.stringify(json);
		o['name'] = o['$lRow'].find('span.namecell').text();
	//	o['asynComplete'] = cb;

		customMultipleRemoteAction(o, o['action'], o['complete']);
		cb();
	}
	
	;function createPart_JSON(o, cb){
		var json = {'partId': o['$lRow'].attr('id'), 'region': o['$lRow'].attr('data-region'), 'soldToId': o['$lRow'].attr('data-sid'), 
					'managerId': $('#hidd_manager').val(), 'name': o['$lRow'].attr('data-title'), 'accnumber': o['$lRow'].attr('data-number'), 'oemId': o['$lRow'].attr('data-pid'), 'csFC': {}
					};

		for(cell in o['cellMonth']){
			var $td = o['$rRow'].find('td:eq('+cell+')'), amount=Globalize.parseInt( $.trim($td.text()) ),
				oFc = {'price': $td.attr('data-nprice'), 'quantity': $td.attr('data-nqty'), 'forecast': amount},
				key = (o['cellMonth'][cell]);
			json['csFC'][key] = oFc;
		}

		o['json'] = JSON.stringify(json);
		o['name'] = o['$lRow'].find('span.namecell').text();
	//	o['asynComplete'] = cb;
		customMultipleRemoteAction(o, o['action'], o['complete']);
		cb();
	}
	
	
}


;function remoteActionDeleteObject(list_data, cellMonth, $pBar, $rBody){
	var pBarConfg=getBarConfg(list_data);
	setProgressBarStatus(pBarConfg, list_data.length, $pBar);
	asyncEachSeries_Original(list_data, function(item){
		item['pct'] = pBarConfg['pct'];
		item['max'] = pBarConfg['max'];
		item['$pBar'] = $pBar;
		item['json'] = JSON.stringify(item['json']);
		customMultipleRemoteAction(item, item['action'], item['complete']);
	}, function(err){});
	
}

;function complete_hasKeyPart(result, event, data){
	if(event.status){
		if(result == 'true' || result == true){
            data['$row'].find('span:first').before('<b class="keypartb"><span class="keypartimg"></span></b>');
		}
    }else{
		alert(event['message']);
    }
}

;function complete_autoCreateOEMForecast(result, event, data){
	QUEUE.push({name: 'autocreateoem', run: function(cb){
		if(event.status){
			var $leftTab=$('#ltabid'), $rightTab=$('#rtabid');
			try{
				data['list_result']=$.parseJSON(result);
				appendResultElement($leftTab, $rightTab, data);
			}catch(e){ console.log(e); }
	    }else{
	    	artDialogBox( ('Check MARINERS error: '+event['message']) );
	    }
		var $rest=$('#'+GLOBAL['REST_SOLDTO']);
		
		$rightTab.find('tr:eq('+$rest.index()+')').addClass('dn');	
		$rest.addClass('dn');	
	    cb(null);
	    document.getElementById('loading-curtain-div').style.display = 'none';
    }}, function(err){ });
    
    ;function appendResultElement($leftTab, $rightTab, data){
    	if(data['list_result'].length == 0){
    		return;
    	}
    	var o_total={};
		setTemplateElement(data);
	//	data['list_result'].reverse();
		while(data['list_result'].length > 0){
			var item=data['list_result'].shift(), strName=( item['id']==GLOBAL['REST_SOLDTO'] ? '' : ('-[ '+item['name']+' ]') ),
				$lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true);

			$lClone.addClass( (item['id']+'_'+data['data-level']) )
					.eq(0).attr({'id': item['id'], 'data-title': item['name'], 'title': item['name'], 'data-number': item['accnumber'], 'data-region': item['region'], 'data-cmt': item['eolcomment']})
					.find('span.namecell').html(item['accnumber']+strName);
			
			if(item['type'] == 'NoDel'){ $lClone.eq(0).find('span.del_img').remove(); }
			
			if(item['id'] == GLOBAL['REST_SOLDTO']){
				$rClone.eq(0).addClass(GLOBAL['REST_SOLDTO']);
				$lClone.eq(0).off('click').removeClass('cp').find('div:first').css({'visibility':'hidden'})
						.parent().find('div.mgleft1').removeClass('mgleft1').find('span.fcell').remove();
			}else{
				$lClone.eq(0).find('td:last')
						.append('<input onclick="event_commentBtn_click(event, this)" value="EOL comment" type="button" class="btn commentbtn" />');
			}

			$rClone.addClass('rlevel1').eq(0).find('td').each(function(){
				var $this=$(this), attr = { 'data-old': 0};
				if(item['csFC'] && item['csFC'].hasOwnProperty( data['cellMonth'][this.cellIndex] )){
					attr['data-old'] = (item['csFC'][data['cellMonth'][this.cellIndex]]);	
				}
				var fmt=Globalize.format(attr['data-old'], DECIMAL_POINT['n0']),
					t=(item['id'] == GLOBAL['REST_SOLDTO'] ? '<input value="'+fmt+'" type="text" class="inputcls restinput" data-type="restinput"/>' : fmt);
				$this.attr(attr);//.html(t);
				if(this.cellIndex >= data['ftCell']){
					$this.html(t);
				//	o_total[this.cellIndex] = (getZeroOfNumber(o_total[this.cellIndex]) + attr['data-old']);
				}else{
					$this.html(fmt);
				}
			});
			setFieldValue($rClone.eq(1).find('td:gt('+(data['ftCell']-1)+')'), data, item['pmFC']);
			setFieldValue($rClone.eq(2).find('td:gt('+(data['ftCell']-1)+')'), data, item['dcFC']);
			if(item['id'] == GLOBAL['REST_SOLDTO']){
				$leftTab.append($lClone);
				$rightTab.append($rClone);
			}else{
				$leftTab.find('tr:first').after($lClone);
				$rightTab.find('tr:first').after($rClone);
			}
		}
		
		$rightTab.find('tr.'+GLOBAL['REST_SOLDTO']).find('td.td_input:first').prev().html(function(){
			return Globalize.format(this.getAttribute('data-old'), DECIMAL_POINT['n0']);
		});
		$rightTab.find('tr.'+GLOBAL['REST_SOLDTO']).find('input').on('focus change', event_input_change);
		
		$leftTab.find('tr.mark.level1').each(function(){
			$rightTab.find('tr:eq('+this.rowIndex+') td:gt('+data['cellIdx']+')').each(function(){
				o_total[this.cellIndex] = ( getZeroOfNumber(o_total[this.cellIndex]) + parseFloat($(this).attr('data-old')) );
			});
		});

		var $totalCells=$rightTab.find('tr:first td').css({'font-style': 'italic', 'font-weight': 'bold'});
		for(var o in o_total){
			$totalCells.eq(o).html( Globalize.format(o_total[o], DECIMAL_POINT['n0']) );
		}
    }

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

;function complete_saveEOLCmt(result, event, data){

	if(event.status){
		$('#ltabid tr.mark.level1.'+data['$cmt'].attr('data-id')+'_level1').attr('data-cmt', data['$cmtTarea'].val());
		event_closeComment_click(null, null);
    }else{
		alert(event['message']);
    }
    document.getElementById('loading-curtain-div').style.display = 'none';
}

;function complete_CFTData(result, event, data){
	
	if(event.status){
		data['$td'].attr({'data-cft': result}).addClass('cftload').removeClass('waitcft');
		var html=(data['cftLabel']+'<input onclick="event_CFTData_click(event, this)" value="Copy CFT" type="button" class="btn" style="position: absolute;right: 2px;"/>'),
			cellMonth={}, map_result=$.parseJSON(result);
			
		$('#edit_left_tbody span.cftcell').parent().html(html).find('input').attr('data-cft', result);
		$('#edit_thead tr.tab_head_list td').each(function(){
			cellMonth[this.cellIndex] = this.getAttribute('data-month');
		});
		$('#edit_right_tbody tr.cftcls td').each(function(){
			this.innerHTML = Globalize.format(map_result[cellMonth[this.cellIndex]]['quantity'], DECIMAL_POINT['n0'])
		});
    }else{
		$('#edit_left_tbody span.cftcell').removeClass('wating').addClass('reload_img')
			.off('click').on('click', function(e){
				$(this).removeClass('reload_img').addClass('wating').find('b').remove();
				customMultipleRemoteAction(data, data['action'], data['complete']);
			}).append('<b class="dn">'+event['message']+'</b>');
    }
}

;function complete_aspData(result, event, data){

	if(event.status){
		data['$td'].attr({'data-asp': result}).addClass('aspload').removeClass('wait');
		var html=(data['aspLabel']+'<input value="'+Globalize.format(getZeroOfNumber(result), DECIMAL_POINT['n4'])+' USD" data-asp="'+getZeroOfNumber(result)+'" onclick="event_aspData_click(event, this)" type="button" class="btn" style="position: absolute;right: 2px;"/>');
		$('#edit_left_tbody span.aspcell').parent().html(html);
    }else{
		$('#edit_left_tbody span.aspcell').removeClass('wating').addClass('reload_img')
			.off('click').on('click', function(e){
				$(this).removeClass('reload_img').addClass('wating').find('b').remove();
				customMultipleRemoteAction(data, data['action'], data['complete']);
			}).append('<b class="dn">'+event['message']+'</b>');
    }
}

;function complete_refData(result, event, data){
	
	QUEUE.push({name: data['level'], run: function(cb){
		
		//var $status_cell=data['$row'].find('table.pinstatus td.smonths[data-months="'+data['smonths']+'"]').eq(0);
		var $status_cell=data['$billing'].find('td:first b[data-months="'+data['smonths']+'"]').eq(0);
	
		if(event.status){
			result = $.parseJSON(result);
			var map_percent=$.parseJSON($('#hidd_percent').val()),
				$billing=data['$rbody'].find('tr:eq('+data['$billing'].index()+')'), 
				$booking=data['$rbody'].find('tr:eq('+data['$booking'].index()+')'), 
				billing=result['map_billingrefdata'], booking=result['map_bookingrefdata'];

			matchRefData(billing, data, $billing.find('td'));
			matchRefData(booking, data, $booking.find('td'));
			
			$status_cell.attr('data-status', 'true').animate({backgroundColor: '#51C957'}, 130, function(){
				$status_cell.remove();
				if(data['$billing'].find('b.ref_box').length == 0){
					data['$billing'].find('td:first').empty();
					statisticalPercent(map_percent, data, $billing.find('td'), data['$rbody'].find('tr:eq('+data['$statistical'].index()+') td'));
				}
			});
			
/*
			result = $.parseJSON(result);
			$status_cell.attr('data-status', 'true').find('div').animate({backgroundColor: '#51C957'}, 130, function(){
				if($status_cell.parent().find('td.smonths[data-status="false"]').length == 0){
					data['$row'].find('div.refs_d').remove();
			    	data['$pin'].off('mouseenter mouseleave').removeClass('watingpin').addClass('donepin');
				}
			});

			var $statistica=data['$rbody'].find('tr:eq('+data['$row'].index()+')').next().next().next(),
				$billing=$statistica.next(), $booking=$billing.next(), $backlog=$booking.next(), 
				statistica=result['map_statisticalrefdata'], backlog=result['map_backlogrefdata'], 
				billing=result['map_billingrefdata'], booking=result['map_bookingrefdata'];
			
			
			matchRefData(statistica, data, $statistica.find('td'));
			matchRefData(backlog, data, $backlog.find('td'));
			matchRefData(billing, data, $billing.find('td'));
			matchRefData(booking, data, $booking.find('td'));
*/			
	    }else{
			reLoadRefData($status_cell, data);
	    }
		cb(null);
    }}, function(err){ });
	
    
    /*HELP methods*/
    ;function statisticalPercent(map_percent, data, $billingCells, $statisticalCells){
    	var cellMonth=data['cellMonth'], monthCell=data['monthCell'];
    	$statisticalCells.filter(':gt('+(data['crtCell']-1)+')').each(function(){
    		var month=cellMonth[this.cellIndex].split('_')[1];
    		if(map_percent.hasOwnProperty(month)){
    			var $prev_3=$billingCells.filter(':eq('+data['crtCell']+')').prev(),
    				$prev_2=$prev_3.prev(), $prev_1=$prev_2.prev(), total=0;
				total = (getZeroOfNumber($prev_1.attr('data-old'))+getZeroOfNumber($prev_2.attr('data-old'))+getZeroOfNumber($prev_3.attr('data-old')));
    			total = (total*(map_percent[month]/100));
    			$(this).attr('data-old', total).html( Globalize.format(total, DECIMAL_POINT['n0']) );
    		}
    	});
    	
    }
    
    ;function matchRefData(refData, data, $cell){
    	var monthCell = data['monthCell'];

    	for(var r in refData){
    		if(monthCell.hasOwnProperty(r)){
    			$cell.eq(monthCell[r]).attr({'data-old': refData[r]}).html( Globalize.format(refData[r], DECIMAL_POINT['n0']) );
    		}
    	}
    }
    
    ;function reLoadRefData($status_cell, data){
    	$status_cell.css({'cursor': 'pointer'}).attr('data-status', 'false').append('<b class="ref_msg">'+event['message']+'</b>')
					.animate({backgroundColor: '#C95151'}, 230).on('click', function(e){
						e.stopPropagation();
						$(this).off('click');
						$status_cell.animate({backgroundColor: '#517BC9'}, 130).css({'cursor': 'default'}).find('b').remove();
						customMultipleRemoteAction(data, data['action'], data['complete']);
					});
					/*
    	var btn='<span class="btnspan"><input type="button" class="btn reloadcls" value="Reload"></span>';
		$status_cell.attr('data-status', 'false').append('<b class="ref_msg">'+event['message']+'</b>')
					.animate({backgroundColor: '#C95151'}, 230);
		$status_cell.find('input[type="button"].reloadcls').on('click', function(e){
			e.stopPropagation();
			$(this).off('click');
			$status_cell.animate({backgroundColor: '#517BC9'}, 130).off('mouseenter mouseleave').find('span.btnspan').remove();
			customMultipleRemoteAction(data, data['action'], data['complete']);
		});
		*/
    }
    /*HELP methods*/
}

;function complete_refDataBacklog(result, event, data){
	
	QUEUE.push({name: data['level'], run: function(cb){
		
		var $status_cell=data['$backlog'].find('td:first b[data-months="'+data['smonths']+'"]').eq(0);
	
		if(event.status){
			result = $.parseJSON(result);
			var $backlog=data['$rbody'].find('tr:eq('+data['$backlog'].index()+')'), backlog=result['map_backlogrefdata'];
			$status_cell.attr('data-status', 'true').animate({backgroundColor: '#51C957'}, 130, function(){
				$status_cell.remove();
				if(data['$backlog'].find('b.ref_box').length == 0){
			    	data['$backlog'].addClass('loaded').find('td:first').empty();
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
    	var monthCell = data['monthCell'];

    	for(var r in refData){
    		if(monthCell.hasOwnProperty(r)){
    			var tt=Globalize.format(refData[r], DECIMAL_POINT['n0']);
    			$cell.eq(monthCell[r]).html(tt).attr({'data-old': tt});
    		}
    	}
    }
    
    ;function reLoadRefData($status_cell, data){
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

;function complete_refDataBacklog1(result, event, data){
	QUEUE.push({name: 'backlog', run: function(cb){
		var $td=$('#edit_left_tbody span.leftbacklog').parent();
		if(event.status){
		//	data['$row'].attr({'data-backlog': result});
			result = $.parseJSON(result);
			matchRefData(result['map_backlogrefdata'], data, $('#edit_right_tbody tr.backlogcls td'));
			$td.append('<input onclick="event_copyBacklog_click(event, this)" value="Copy backlog" type="button" class="btn" style="position: absolute;right: 2px;margin-top: -4px;" />');
	    }else{
	    	data['$row'].removeClass('loadedbacklog');
			console.log(data);
	    }
	    $td.find('span.leftbacklog').remove();
		cb(null);
    }}, function(err){ });
	
    
    /*HELP methods*/
    ;function matchRefData(refData, data, $cell){
    	var monthCell = data['monthCell'];
    	for(var r in refData){
    		var ft=Globalize.format(refData[r], DECIMAL_POINT['n0']);
    		$cell.filter('[data-month="'+r+'"]').html( ft );
    		if(monthCell.hasOwnProperty(r)){
    			data['$backlog'].find('td:eq('+monthCell[r]+')').attr('data-old', ft);
    		}
    	}
    }
    /*HELP methods*/
}


;function complete_refTotalBillingData(result, event, data){
	
	QUEUE.push({name: data['level'], run: function(cb){
		var $status_cell=data['$row'].find('b.ref_box[data-months="'+data['smonths']+'"]').eq(0);
	
		if(event.status){
			result = $.parseJSON(result);
			$status_cell.attr('data-status', 'true').animate({backgroundColor: '#51C957'}, 130, function(){
				$status_cell.remove();
			});
			matchRefData(result['map_billingrefdata'], data, data['$rCells']);
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
    			$cell.eq(monthCell[r]).html( Globalize.format(refData[r], DECIMAL_POINT['n0']) );
    		}
    	}
    }
    
    ;function reLoadRefData($status_cell, data){
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

;function complete_saveRestSoldTo(result, event, data){	//complete remoteaction result
	
	if(event.status){
		CATCH_DATA['level1'] = {};
		CATCH_DATA['level2'] = {};
		CATCH_DATA['level3'] = {};
		EVENT_BIND.beforeunload();
		$('#loading-curtain-div').hide();
    }else{
    	var $restBox=$('#restsoldtobox').show();
    	$restBox.find('div.restsoldmsg').html(event['message']).parent()
    		.find('input[type="button"].resavebtn').off('click').on('click', function(){
    			$restBox.hide();
    			customMultipleRemoteAction(data, data['action'], data['complete']);
    		});
    }
    
}

;function complete_saveSObject(result, event, data){	//complete remoteaction result
    QUEUE.push({name: (data['$pBar'].progressbar("value") || 0), run: function(cb){
		var isError = false;
		if(event.status){
	    //	data['asynComplete']();
			isError=false;
	    }else{
	    	isError=true;
	    	data['msg'] = event;
			SAVE_ERRORS.push(data);
	    }
		LAZY.fire('', cb, 300);
	    var pct=parseFloat(data['$pBar'].attr('data-value')), max=data['max'];

	    pct = (data['pct']+($.isNumeric(pct) ? pct : 0));
	    max = (Math.round(pct) >= data['max'] ? 100 : pct);

		progressStatusText((isError ? '#prg_err' : '#prg_scues'));	
		data['$pBar'].attr('data-value', pct).progressbar("value", max).find('div.progress-label').html(max.toFixed(2)+'%');

    }}, function(err){ });
    
    ;function progressStatusText(_id){
    	$(_id).html(function(){
			var t = parseInt($.trim(this.innerHTML), 10);
			return ($.isNumeric(t) ? (t+1) : 0);
		});
    }
}
;function complete_searchObject(result, event, data){	//complete remoteaction result
	if(event.status){
    	result = $.parseJSON(result);
	    var $tBody=$('#popupbody'), $trs=$( ('#'+data['$btn'].attr('data-level')+'_tab') ).clone().removeAttr('id');
	    asyncEachSeries_Original(result, function(item){
	    	var $tmp = $trs.clone();
	    	$tmp.find('td input[type="checkbox"]').attr('data-json', JSON.stringify(item));
	    	$tmp.attr({'id': item['id']}).find('td:not(.popup_ckboxtd)').each(function(){
	    		this.innerHTML = item[this.getAttribute('data-fieldname')];
	    	});
	    	$tBody.append($tmp);
	    }, function(err){
		    result = [];
		    $('#boxheadid').css({'width': ($('#boxbodyid').width()-scrollbarW)});
		    data['$loading'].hide();
		    data['$inputs'].removeAttr('disabled');
	    }, 60);
	   
    }else{ 
    	data['$loading'].html(event['message']);
    	data['$inputs'].removeAttr('disabled');
    }
}

;function complete_searchObjectTOP(result, event, data){
	if(event.status){
    	result = $.parseJSON(result);
	    var $tBody=$('#popupbody'), $trs=$( ('#'+data['$btn'].attr('data-level')+'_tab') ).clone().removeAttr('id');
	    asyncEachSeries_Original(result, function(item){
	    	var $tmp = $trs.clone();
	    	$tmp.find('td input[type="checkbox"]').attr('data-json', JSON.stringify(item));
	    	$tmp.attr({'id': item['id']}).find('td:not(.popup_ckboxtd)').each(function(){
	    		this.innerHTML = item[this.getAttribute('data-fieldname')];
	    	});
	    	$tBody.append($tmp);
	    }, function(err){
		    result = [];
		    data['$loading'].hide();
		    data['$inputs'].removeAttr('disabled');
	    }, 60);
	   
    }else{ 
    	data['$loading'].html(event['message']);
    	data['$inputs'].removeAttr('disabled');
    }
}

;function complete_deleteObject(result, event, data){
	QUEUE.push({name: (data['$pBar'].progressbar("value") || 0), run: function(cb){
		var isError = false;
		if(event.status){
			isError=false;
	    }else{
	    	isError=true;
	    	data['msg'] = event;
			SAVE_ERRORS.push(data);
	    }
		LAZY.fire('', cb, 300);
	    var pct=parseFloat(data['$pBar'].attr('data-value')), max=data['max'];

	    pct = (data['pct']+($.isNumeric(pct) ? pct : 0));
	    max = (Math.round(pct) >= data['max'] ? 100 : pct);

		progressStatusText((isError ? '#prg_err' : '#prg_scues'));	
		data['$pBar'].attr('data-value', pct).progressbar("value", max).find('div.progress-label').html(max.toFixed(2)+'%');

    }}, function(err){ });
    
    ;function progressStatusText(_id){
    	$(_id).html(function(){
			var t = parseInt($.trim(this.innerHTML), 10);
			return ($.isNumeric(t) ? (t+1) : 0);
		});
    }
}

;function complete_existLevel2Result(result, event, data){	//complete remoteaction result
	
	QUEUE.push({name: data['rowIndex'], run: function(cb){
		if(event.status){
			complete_remoteResultCheck(result, data, cb, appendElement_Level2, complete_appendElementEND);
	    }else{ 
			complete_errorReload(data, event, event_reloadExistData_click);
			cb(null);
	    }
	    data['$row'].find('span.del_img').removeAttr('style');
	}}, function(err){ });
}

;function complete_existLevel3Result(result, event, data){	//complete remoteaction result
	QUEUE.push({name: data['rowIndex'], run: function(cb){
		if(event.status){
			complete_remoteResultCheck(result, data, cb, appendElement_Level3, complete_appendElementEND);
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
	/* Added by Cap Team for DNDP1 */
	if (_data['data-level'] === 'level3') {
		addPartTotalRow();
	}
	/* End by Cap Team for DNDP1 */
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
		e['data'].$aBox.removeClass('w-drop-select').addClass('w-drop-unselect');
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
		e['data'].$aBox.removeClass('w-drop-unselect').addClass('w-drop-select');
		$this.off('mousemove mouseup');
		$(e['data'].elDrop).removeAttr('style');
    });
}

;function event_input_change(e){
	var _this=this,
		$this=$(_this),
		$td=$this.parent(),
		$tr=$td.parent(),
		$rBody=$tr.parent(),
		ov='',
		point=DECIMAL_POINT['n0'], 
		level=_this.getAttribute('data-type'),
		validation_qty=/^([1-9]\d{0,16}|0)(\.\d+)?$/,
		tv = Globalize.parseFloat($.trim(_this.value)); //focus Event

    ov = $this.inputFocusValueFormat(validation_qty, e);

    if(e.type == 'change'){
    	ov = ($.isNumeric(ov) ? ov : 0);
        tv = ($.isNumeric(tv) ? tv : 0);
        if((tv+'').length > 18){
        	$this.val(Globalize.format(ov, point));
        	return;
        }
        if(_this.getAttribute('data-type') == 'restinput'){
	        $this.val(Globalize.format(tv, point));
        	sumOfTotalCell($rBody, $td[0]);
        	return;
        }
        
        var $lTR=$('#ltabid tr:eq('+$tr.index()+')'), $lBody=$lTR.parent(), cellIndx=$td[0].cellIndex, partTotal=0,
        	$restPN=$tr.find('td:eq('+cellIndx+')'), restPN=getZeroOfNumber_Int($restPN.attr('data-rest'));
		
        if(!$lTR.hasClass('done')){
        	$lTR.click();
        }
        	
        if(level == 'level2' && !$lTR.hasClass('done') && tv<restPN){
        	$this.val(Globalize.format(ov, point));
        	return;
        }
        //added by 2016-03-17 Minghao Li<minghao.li@oinio.com> remove region limitation logic to forbid forecast greater than above layer
		$lBody.find('tr.mark.level3.'+$lTR.attr('id')+'_level2.'+$lTR.attr('data-sid')+'_level1').each(function(){		
    //    $lBody.find('tr.mark.level3.'+$lTR.attr('id')+'_level2.'+$lTR.attr('data-sid')+'_level1').filter('[data-region="'+$lTR.attr('data-region')+'"]').each(function(){
        	var t=Globalize.parseInt( $.trim($rBody.find('tr:eq('+this.rowIndex+')').find('td:eq('+cellIndx+')').text()) );
        	partTotal += t;
        });
        
		if((tv-partTotal) < 0){
			$this.val(Globalize.format(ov, point));
			
			return;
		}
		
       $this.val(Globalize.format(tv, point));
	   $restPN.attr('data-rest', (tv-partTotal));//.html( Globalize.format(tv-partTotal, point) );
		
		var $lRow=$lBody.find('tr.mark.level1.'+$lTR.attr('data-sid')+'_level1'), $rRow=$rBody.find('tr:eq('+$lRow.index()+')'),
            $rCell=$rRow.find('td:eq('+cellIndx+')'), oemTotal = 0, rTotal=Globalize.parseInt( $.trim($rCell.text()) ) ? Globalize.parseInt( $.trim($rCell.text()) ) : 0;
		
		$lBody.find('tr.mark.level2.'+$lTR.attr('data-sid')+'_level1').each(function(){
			var t=Globalize.parseInt( $.trim($rBody.find('tr:eq('+this.rowIndex+')').find('td:eq('+cellIndx+') input').val()) );
        	oemTotal += t ? t : 0;
		});
		
		if(level == 'level2' && !$lRow.hasClass('done')){
		    oemTotal += rTotal;
		}
		$rCell.html( Globalize.format(oemTotal, point) );
		sumOfTotalCell($rBody, $td[0]);
		EVENT_BIND.beforeload();
    }
    
    if(e.keyCode == 13){
    	$td.next().find('input').focus().select();
    }
    
    ;function sumOfTotalCell($rBody, el_td){
    	var total=0, $totCell=$rBody.find('tr:first td:eq('+el_td.cellIndex+')');
    	$('#ltabid tr.level1.mark').each(function(){
    		var $td=$rBody.find('tr:eq('+this.rowIndex+') td:eq('+el_td.cellIndex+')'), $input=$td.find('input'),
    			t=( $input.length == 0 ? Globalize.parseInt($td.html()) : Globalize.parseFloat($input.val()) );
    		total += t;
    	});
    	$totCell.html( Globalize.format(total, DECIMAL_POINT['n0']) );
    }
}

;function event_partInput_change(e){
	var _this=this, $this=$(_this), $td=$this.parent(), ov = '', vd_qty=/^([1-9]\d{0,16}|0)?$/, 
		vd_price=/^([1-9]\d{0,16}|0)(\.\d+)?$/, type=$this.attr('data-type'),
        point=(type == 'qty' ? DECIMAL_POINT['n0'] : DECIMAL_POINT['n4']), 
        tv = Globalize.parseFloat($.trim(_this.value)); //focus Event
    
    ov = $this.inputFocusValueFormat((type == 'qty' ? vd_qty : vd_price), e);
	
    if(e.type == 'change'){
    	ov = ($.isNumeric(ov) ? ov : 0);
        tv = ($.isNumeric(tv) ? tv : 0);
        
        if((tv+'').length > 18){
        	$this.val(Globalize.format(ov, point));
        	return;
        }
        
        var $body=$('#edit_right_tbody'), $unknown=$body.find('tr.'+(type=='qty'?'pricecls': 'qtycls')+' td:eq('+$td[0].cellIndex+')'), 
        	$crt=$body.find('tr.curtcls td:eq('+$td[0].cellIndex+')'), crt=Globalize.parseInt( $.trim($crt.html()) ),
        	$rest=$body.find('tr.restcls td:eq('+$td[0].cellIndex+')'), rest=getZeroOfNumber_Int( $.trim($rest.attr('data-min')) ),
        	unknownVal=$.trim($unknown.find('input').val()), total=0;

        unknownVal = Globalize.parseFloat(unknownVal);
        total = Math.round(tv*unknownVal);
        rest += crt;
        
        if($body.attr('data-region-part') != $body.attr('data-region-oem') && $body.attr('data-region-oem') != ''){
        	$this.val( Globalize.format(tv, point) ).removeAttr('style');
        	$crt.html(Globalize.format(total, DECIMAL_POINT['n0']));
        	return;
        }
        /* Comment start by Cap Team to remove existing validation on Part level */ 
          //if(total <= rest){
		/* Comment end by Cap Team to remove existing validation on Part level */ 
        
			/* Added by Cap Team to identify if rest is negative */	
			//if(total > rest){
				//RestPart = true;
			//}
		/* End by Cap Team to identify if rest is negative */
			self.partInfoChangeArray.push($(e.currentTarget).parent()[0].cellIndex);
        	$rest.attr('data-min', (rest-total)).html( Globalize.format((rest-total), DECIMAL_POINT['n0']) );
        	$crt.html(Globalize.format(total, DECIMAL_POINT['n0']));
        	$this.val( Globalize.format(tv, point) ).removeAttr('style');
        	$unknown.find('input').removeAttr('style');
			EVENT_BIND.beforeload();
        	return;
			/* Comment start by Cap Team to remove existing validation on Part level */ 		
       // }
    	//$this.val( Globalize.format(ov, point) ).css('border-bottom', '5px solid red');
	/* Comment end by Cap Team to remove existing validation on Part level */ 
        
    }
    
    if(e.keyCode == 13){
    	$td.next().find('input').focus().select();
    }
}

;function event_commentBtn_click(event, target){
	event = (event?event:window.event);
	event.cancelBubble = true;
	
	var $this=$(target), $tr=$this.parent().parent();
	$('#popupmain').show();
	$('#commentboxid').show();
	$('#cmttitle').html($tr.find('span.namecell').text()).attr({'data-id': $tr.attr('id'), 'data-number': $tr.attr('data-number')});
	$('#cmttareaid').val($tr.attr('data-cmt')).focus();
}

;function event_closeComment_click(event, target){
	$('#commentboxid').hide();
	$('#popupmain').hide();
}

;function event_saveComment_click(event, target){
	document.getElementById('loading-curtain-div').style.display = '';
	var $cmt=$('#cmttitle'), $cmtTarea=$('#cmttareaid'),
		json={'$cmt': $cmt, '$cmtTarea': $cmtTarea,
			'json': JSON.stringify({'soldtoId': $cmt.attr('data-id'), 'accnumber': $cmt.attr('data-number'), 'searchKey': $cmtTarea.val()}) };
	customRemoteAction(json, saveEOLCmt_js, complete_saveEOLCmt);
}

;function event_CFTData_click(event, target){
	
	var monthCell={}, $target=$(target), map_cft=$.parseJSON($target.attr('data-cft')), $body=$('#edit_right_tbody'), 
		$qtyCells=$body.find('tr.qtycls td'), $crtCells=$body.find('tr.curtcls td'), 
		$priceCells=$body.find('tr.pricecls td'), $restCells=$body.find('tr.restcls td'),
		region_part=$body.attr('data-region-part'), region_oem=$body.attr('data-region-oem');
	
	$('#edit_thead tr.tab_head_list td.futurecls').each(function(){
		monthCell[this.getAttribute('data-month')] = this.cellIndex;
	});
	
	for(var month in map_cft){
		if(!map_cft[month]['hasvalue'] || !monthCell.hasOwnProperty(month)){ continue; }

		var rst=map_cft[month], $input=$qtyCells.eq(monthCell[rst['dateKey']]).find('input'),
			$rest=$restCells.eq(monthCell[rst['dateKey']]), $crt=$crtCells.eq(monthCell[rst['dateKey']]),
			oldQty=Globalize.parseInt( $input.val() ),
			price=Globalize.parseFloat( $priceCells.eq(monthCell[rst['dateKey']]).find('input').val() ),
			rest=getZeroOfNumber_Int( $rest.attr('data-min') ), crt=Globalize.parseInt( $.trim($crt.text()) ), 
			oldRest=Math.round(getZeroOfNumber(oldQty*price)), total=Math.round(price*rst['quantity']);
		
		rest += oldRest;
		
		if(region_part != region_oem && region_oem != ''){
			$input.val( Globalize.format(rst['quantity'], DECIMAL_POINT['n0']) ).removeAttr('style');
            $crt.html( Globalize.format(total, DECIMAL_POINT['n0']) );
		}else{
			if(total <= rest){
				$rest.attr('data-min', (rest-total)).html( Globalize.format((rest-total), DECIMAL_POINT['n0']) );
				$input.val( Globalize.format(rst['quantity'], DECIMAL_POINT['n0']) ).removeAttr('style');
	            $crt.html( Globalize.format(total, DECIMAL_POINT['n0']) );
			}else{
				$input.css('border-bottom', '5px solid red');
			}
		}
		
	}
}
;function event_copyBacklog_click(event, target){
	
	var monthCell={}, $target=$(target), $body=$('#edit_right_tbody'), 
		$qtyCells=$body.find('tr.qtycls td'), $crtCells=$body.find('tr.curtcls td'), 
		$priceCells=$body.find('tr.pricecls td'), $restCells=$body.find('tr.restcls td'),
		region_part=$body.attr('data-region-part'), region_oem=$body.attr('data-region-oem');
	
	$('#edit_thead tr.tab_head_list td.futurecls').each(function(){
		monthCell[this.getAttribute('data-month')] = this.cellIndex;
	});
	$body.find('tr.backlogcls td:not(:first)').each(function(){
		var $td=$(this), cellIdx=this.cellIndex, $rest=$restCells.eq(cellIdx), $crt=$crtCells.eq(cellIdx),
			$input=$qtyCells.eq(cellIdx).find('input[type="text"]'), newValue=Globalize.parseInt( $.trim($td.text()) ),
			price=Globalize.parseFloat( $.trim($priceCells.eq(cellIdx).find('input').val()) ),
			crt=Globalize.parseInt( $.trim($crt.text()) ), inputVal=numberOfZero($input.val()),
			rest=getZeroOfNumber_Int( $.trim($rest.attr('data-min')) ), total=Math.round(price*newValue);
		
		rest += crt;
		if(region_part != region_oem && region_oem != ''){
			if(inputVal > newValue){
				
			}else{
				$input.val( Globalize.format( newValue, DECIMAL_POINT['n0']) ).removeAttr('style');
	            $crt.html( Globalize.format(total, DECIMAL_POINT['n0']) );
			}
		}else{
			if(total <= rest){
				if(inputVal > newValue){
					
				}else{
					$rest.attr('data-min', (rest-total)).html( Globalize.format((rest-total), DECIMAL_POINT['n0']) );
					$input.val( Globalize.format(newValue, DECIMAL_POINT['n0']) ).removeAttr('style');
		            $crt.html( Globalize.format(total, DECIMAL_POINT['n0']) );
				}
			}else{
				$input.css('border-bottom', '5px solid red');
			}
		}
	});
	
}

;function event_aspData_click(event, target){
	var $this=$(target), $trs=$('#edit_right_tbody tr'), $priceCell=$trs.filter('.pricecls').find('input'),
		$qtyCell=$trs.filter('.qtycls').find('td'), $restCell=$trs.filter('.restcls').find('td'),
		$curtCell=$trs.filter('.curtcls').find('td'), aspVal=getZeroOfNumber($this.attr('data-asp')),
		region_part=$trs.parent().attr('data-region-part'), region_oem=$trs.parent().attr('data-region-oem');

	
	$priceCell.each(function(){
		var $price=$(this), $this=$price.parent(), cellIdx=$this[0].cellIndex, $rest=$restCell.eq(cellIdx), 
			qty=Globalize.parseInt( $.trim($qtyCell.eq(cellIdx).find('input[type="text"]').val()) ),
			crt=Globalize.parseInt( $.trim($curtCell.eq(cellIdx).text()) ),
			rest=getZeroOfNumber_Int( $.trim($rest.attr('data-min')) ), total=Math.round(qty*aspVal);
		rest += crt;
		
		if(region_part != region_oem && region_oem != ''){
			$price.val(Globalize.format(aspVal, DECIMAL_POINT['n4'])).removeAttr('style');
			$curtCell.eq(cellIdx).html(Globalize.format(total, DECIMAL_POINT['n0']));
		}else{
			if(total <= rest){ 
				$rest.attr('data-min', (rest-total));
				$price.val(Globalize.format(aspVal, DECIMAL_POINT['n4'])).removeAttr('style');
				$curtCell.eq(cellIdx).html(Globalize.format(total, DECIMAL_POINT['n0']));
				$rest.attr('data-min', (rest-total)).html( Globalize.format((rest-total), DECIMAL_POINT['n0']) );
			}else{
				$price.css('border-bottom', '5px solid red');
			}
		}
		
	});
}

;function event_refData_click(e){
	e.stopPropagation();
	if($(this).hasClass('watingpin')){
		return;
	}
	var $this=$(this), $td=$this.parent().parent().parent(), $tr=$td.parent(), $statistical=$tr.next().next().next(),
		$billing=$statistical.next(), $booking=$billing.next(), $backlog=$booking.next(), execute=($this.hasClass('spin')? exp : col),
		attr={ 'findcls': '', 'json' : {}, 'cls': '', 'monthCell': {}, 'cellMonth': {}, 'data-number': $tr.attr('data-number'),
			   'crtCell': $('#tab_head_list td.currentcls')[0].cellIndex, '$pin': $this, '$row': $tr, 'level': $tr.attr('data-level'), 'manangerid': $('#hidd_manager').val(), 
			   'set_selectedId': [], 'id': $tr.attr('id'), 'sid': $tr.attr('data-sid'), 'pid': $tr.attr('data-pid'), '$booking': $booking,
			   '$lbody': $tr.parent(), '$rbody': $('#rtabid'), '$statistical' : $statistical, '$billing': $billing,
			   '$backlog': $backlog, 'action' : getRefData_js, 'actionBacklog': getBacklogRefData_js,
			   'complete' : complete_refData, 'completeBacklog': complete_refDataBacklog
			 };
		
	event_windowScroll();
	switch(attr['level']){
		case 'level1':
			attr['findcls'] = 'tr:not(.mark).level1.'+attr['id']+'_level1';
			attr['cls'] = WORK_CLS['level1'];
			attr['soldtoid'] = attr['id'];
			break;
		case 'level2':
			attr['findcls'] = 'tr:not(.mark).level2.'+attr['id']+'_level2.'+attr['sid']+'_level1';
			attr['cls'] = WORK_CLS['level2'];
			attr['soldtoid'] = attr['sid'];
			attr['oemid'] = attr['id'];
			break;
		case 'level3':
			attr['findcls'] = 'tr:not(.mark).level3.'+attr['id']+'_level3.'+attr['pid']+'_level2.'+attr['sid']+'_level1';
			attr['cls'] = WORK_CLS['level3'];
			attr['soldtoid'] = attr['sid'];
			attr['oemid'] = attr['pid'];
			attr['partid'] = attr['id'];
			break;
	}
	
	execute();

	/* START Help function */
	;function exp(){
		if(!$this.hasClass('refdata')){
			$this.addClass('refdata');
			if($tr.attr('id') == GLOBAL['REST_SOLDTO']){
				attr['$lbody'].find('tr.mark.level1:not(#'+GLOBAL['REST_SOLDTO']+')').each(function(){
					attr['set_selectedId'].push(this.getAttribute('data-number'));
				});
				attr['cls'] = WORK_CLS['restsoldto'];
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
		createMonths(list_months, $element, $('#tab_head_list td:not(.futurecls)'));

		asyncEachSeries_Original(list_months, function(list_item, callback){
			var attr_tmp=$.extend({}, attr), list_q=[];
			for(var i=0, result; result=list_item[i]; i++){
				list_q.push(result);
			}
			attr_tmp['smonths'] = list_q.join(',');
			attr_tmp['json'] = {'set_selectedId': attr_tmp['set_selectedId'], 'set_fiscalMonth': list_q, 'soldtoId': attr_tmp['soldtoid'], 'oemId': attr_tmp['oemid'], 
								'accnumber':attr_tmp['data-number'], 'partId': attr_tmp['partid'], 'manangerId': attr_tmp['manangerid']
								};
			attr_tmp['json'] = JSON.stringify(attr_tmp['json']);
			customMultipleRemoteAction(attr_tmp, attr_tmp['action'], attr_tmp['complete']); //this is remote action
		}, function(err){}, 120);
		
	}
	
	;function createFutureStatus($element){
		var list_months=[];
		createMonths(list_months, $element, $('#tab_head_list td:not(.historicalcls)'));

		asyncEachSeries_Original(list_months, function(list_item, callback){
			var attr_tmp=$.extend({}, attr), list_q=[];
			for(var i=0, result; result=list_item[i]; i++){
				list_q.push(result);
			}
			attr_tmp['smonths'] = list_q.join(',');
			attr_tmp['json'] = {'set_selectedId': attr_tmp['set_selectedId'], 'set_fiscalMonth': list_q, 'soldtoId': attr_tmp['soldtoid'], 'oemId': attr_tmp['oemid'], 
								'accnumber':attr_tmp['data-number'], 'partId': attr_tmp['partid'], 'manangerId': attr_tmp['manangerid']
								};
			attr_tmp['json'] = JSON.stringify(attr_tmp['json']);
			customMultipleRemoteAction(attr_tmp, attr_tmp['actionBacklog'], attr_tmp['completeBacklog']); //this is remote action
		}, function(err){}, 120);
		
	}
	
	;function createMonths(list_months, $element, $el_head){
		var list_result=[], el_body='<div class="ref_cover">';

		$el_head.each(function(){
			var cell=this.cellIndex, month=this.getAttribute('data-month');
			attr['monthCell'][month] = cell;
			attr['cellMonth'][cell] = month;
			list_result.push(month);
		});
		for(var i=0, max=list_result.length; i<max; i+=3){
			var list_t=list_result.slice(i,i+3);
			list_months.push(list_t);
			el_body += '<b data-months="'+list_t.join(',')+'" data-status="false" class="ref_box">[M-'+Math.round((i+1)/3)+']</b>';
		}
		el_body += '</div>';
		$element.find('td:first').append(el_body);
	}
	
	;function createRefStatus(list_months, $element){
		var list_result=[], el_body='<div class="ref_cover">';

		$('#tab_head_list td').each(function(){
			var cell=this.cellIndex, month=this.getAttribute('data-month');
			attr['monthCell'][month] = cell;
			attr['cellMonth'][cell] = month;
			list_result.push(month);
		});
		for(var i=0, max=list_result.length; i<max; i+=3){
			var list_t=list_result.slice(i,i+3);
			list_months.push(list_t);
			el_body += '<b data-months="'+list_t.join(',')+'" data-status="false" class="ref_box">[M-'+Math.round((i+1)/3)+']</b>';
		}
		el_body += '</div>';
		$element.find('td:first').append(el_body);
	}
	/*
	;function createRefStatus(list_months){
		
		var list_result=[], th='', td='';

		$('#tab_head_list td').each(function(){
			var cell=this.cellIndex, month=this.getAttribute('data-month');
			attr['monthCell'][month] = cell;
			list_result.push(month);
		});
		
		for(var i=0, max=list_result.length; i<max; i+=3){
			var list_t=list_result.slice(i,i+3);
			list_months.push(list_t);
			th += '<td class="ref_head" style="text-align: center;"> Months [ '+Math.round((i+1)/3)+' ] </td>';
			td += '<td class="smonths" data-status="false" data-months="'+list_t.join(',')+'" style="text-align: center;"><div class="refstatus str"></div></td>';
		}
		$td.append('<div class="refs_d"><table class="pinstatus" border="0" cellspacing="0" cellpadding="0" ><tr class="shead">'+th+'</tr><tr class="sbody">'+td+'</tr></table></div>')
		   .find('div.refs_d').on('mouseenter mouseleave', event_tabStatus_over);
		$this.on('mouseenter mouseleave', event_pinRefStatus_over);
		list_result=[];
	}
	*/
	/* END Help function */
}

;function event_tabStatus_over(e){
	var $this=$(this);
	eventHandle_ov_ot(e, ov, ot);
    ;function ov(e){ $this.addClass('overg'); }
    ;function ot(e){ $this.removeClass('overg').hide(); }
}

;function event_pinRefStatus_over(e){
	var $this=$(this), $refDiv=$this.parent().parent().parent().find('div.refs_d');
	eventHandle_ov_ot(e, ov, ot);
    
    ;function ov(e){ $refDiv.show(); }
    ;function ot(e){ 
    	window.clearTimeout(t);
		var t = window.setTimeout(doHide, 160);
	}
	
	;function doHide(){
		if(!$refDiv.hasClass('overg')){ $refDiv.hide(); }
	}
}


;function event_reloadExistData_click(e, $this){
	var _data = e.data.$data;
	rowIsLocked(_data['rowIndex']);
    customMultipleRemoteAction(_data, _data['action'], _data['complete']);
    $this.remove();
}

;function event_saveEditPart_click(e){
    
	/* Added by CapTeam to check RestPart is negative */ 
	//  if(RestPart==true){
		 // RestPart=false;
	    // if(!confirm('RestPart is negative, OEM value will be updated with CurrentSalesForecast$, Do you want to proceed?'))
		 // return false;
	 // }
	 
	 
     /* End by CapTeam to check RestPart is negative */ 
    var $inputs=$(this).parent().find('input').attr({'disabled': true}),
        $this=$(this), $trs=$('#edit_right_tbody tr'), $crtCell=$trs.filter('.curtcls').find('td:not(:first)'),
        $qtyCell=$trs.filter('.qtycls').find('td:not(:first)'), $priceCell=$trs.filter('.pricecls').find('td:not(:first)'),
        $restCell=$trs.filter('.restcls').find('td:not(:first)'), dataJson=$.parseJSON($this.attr('data-json')), 
        cCell=$('#tab_head_list td.currentcls')[0].cellIndex,
        partcls='#ltabid tr.mark.level3.'+dataJson['soldtoId']+'_level1.'+dataJson['oemId']+'_level2.'+dataJson['partId']+'_level3',
        restcls='#ltabid tr.mark.level2.'+dataJson['soldtoId']+'_level1.'+dataJson['oemId']+'_level2',
        $oemRest=$('#rtabid tr:eq('+$(restcls).index()+')').find('td:gt('+cCell+')'),
        $partCell=$('#rtabid tr:eq('+$(partcls).index()+')').find('td:gt('+cCell+')'),
		
		
        
  /* comment start by CapTeam for "Copy OEM Backlog" btn checkbox functionality */
  
  $AllBacklogs=$trs.filter('.OEMBacklogChkCls').find('input');
    $partCell.each(function(idx){
		
                    var _this=this, $this=$(_this), qty=$.trim($qtyCell.eq(idx).find('input').val()),
					price=$.trim($priceCell.eq(idx).find('input').val()), crtVal=$.trim($crtCell.eq(idx).text()),
					rest=getZeroOfNumber_Int($restCell.eq(idx).attr('data-min'));
			$AllBacklogs.each(function(idx2){ 
			
            
               if(idx==idx2)
			   {
				   if(this.checked == true){
						ischecked[idx2] = true;
					}
					else{
						ischecked[idx2] = false;
					}
				   
					qty=Globalize.parseInt(qty);
					price=Globalize.parseFloat(price);
                    $this.text(crtVal).attr({'data-nprice': price, 'data-nqty': qty});
					$oemRest.eq(idx).attr('data-rest', rest);//.html( Globalize.format(rest, DECIMAL_POINT['n0']) );
					
	                
	          }
			  
			   
		});
           	
        
    });
	/* comment end by CapTeam for "Copy OEM Backlog" btn checkbox functionality */
    event_closePartPopupBox_click(null, null);
    $inputs.attr({'disabled': false});
	//isdelpart = true;
	addPartTotalRow();
	
	  
}

;function event_saveSoldToForecast_click(target){
	SAVE_ERRORS = [];
	if(checkingStatus()){
		artDialogBox('Please waiting for load data.');
		return false;
	}

	var list_data=[], cellMonth={}, $rBody=$('#rtabid'), $pStatus=$('#progressstatusid').html(' '),
		$pBar=$("#progressbar").attr('data-value', 0).progressbar({ value: false }),
		$pError=$('#progresserror').attr({'data-v1': 'unknown', 'data-v2': 'unknown', 'data-v3': 'unknown'});
	
	$('#tab_head_list td.futurecls').each(function(){
		cellMonth[this.cellIndex] = this.getAttribute('data-month');
	});
	
	createDelObjectList(list_data);
	if(list_data.length != 0){
		$pStatus.html('Deleting records...');
		$pError.attr('data-v1', 'start');
		remoteActionDeleteObject(list_data, cellMonth, $pBar, $rBody);
		return;
	}
	
	list_data=$('#ltabid tr.mark:not(.totcls):not(#'+GLOBAL['REST_SOLDTO']+')').toArray();
	if(list_data.length != 0){
		$pStatus.html('Saving records...');
		$pError.attr('data-v2', 'start');
		remoteActionCreateObject(list_data, cellMonth, $pBar, $rBody);
		return;
	}
	
	
	
	
	/* START HELP method */
	;function createDelObjectList(list_del){
		for(var level in CATCH_DATA['DEL1']){
			var t={'cls': WORK_CLS['level1'], 'action': deleteCSDObject_js, 'complete': complete_deleteObject, 
					'json': {'soldtoId': level, 'accnumber': level}
				};
			list_del.push(t);
		}
		for(var level in CATCH_DATA['DEL2']){
			var o=CATCH_DATA['DEL2'][level],
				t={'cls': WORK_CLS['level2'], 'action': deleteCSDObject_js, 'complete': complete_deleteObject, 
					'json': {'accnumber': o['accnumber'], 'oemId': o['oemid']}
				};
			list_del.push(t);
		}
		for(var level in CATCH_DATA['DEL3']){
			var o=o=CATCH_DATA['DEL3'][level],
				t={'cls': WORK_CLS['level3'], 'action': deleteCSDObject_js, 'complete': complete_deleteObject, 
					'json': {'accnumber':o['accnumber'], 'oemId': o['oemid'], 'partId': o['partid']}
				};
			list_del.push(t);
		}
		/*
		for(var level in CATCH_DATA['level1']){
			var t={'cls': WORK_CLS['level1'], 'action': deleteCSDObject_js, 'complete': complete_deleteObject, 
					'json': {'soldtoId': level, 'accnumber': level}
				};
			list_del.push(t);
		}
		for(var level in CATCH_DATA['level2']){
			for(var i=0, oemId; oemId=CATCH_DATA['level2'][level][i]; i++){
				var t={'cls': WORK_CLS['level2'], 'action': deleteCSDObject_js, 'complete': complete_deleteObject, 
						'json': {'soldtoId': level, 'accnumber': level, 'oemId': oemId}
					};
				list_del.push(t);
			}
		}
		for(var level in CATCH_DATA['level3']){
			var list_t=level.split('_');
			for(var i=0, partId; partId=CATCH_DATA['level3'][level][i]; i++){
				var t={'cls': WORK_CLS['level3'], 'action': deleteCSDObject_js, 'complete': complete_deleteObject, 
						'json': {'soldtoId': list_t[0], 'accnumber': list_t[0], 'oemId': list_t[1], 'partId': partId}
					};
				list_del.push(t);
			}
		}
		*/
	}
	/* END HELP method */
}

;function event_deleteObject_click(event, target){
	event = (event?event:window.event);
	event.cancelBubble = true;
	
	QUEUE.push({name: 'deleteObject', run: function(cb){
		EVENT_BIND.beforeload();
        deleteObject(target, cb);
    }}, function(err){ });
	
    /* HELP function*/
    ;function deleteObject(target, cb){
    	
		var filterCls='', $rBody=$('#rtabid'), $this=$(target), 
			$tr=$this.parent().parent().parent().parent().parent(), id=$tr.attr('id'), 
			remote_fn={'json': {}, '$row': $tr, '$btn': $this, '$rbody': $rBody};

		$tr.off('click').find('span.search_img input[type="button"]').css({'visibility': 'hidden'}).find('span.fcell').html('+');
		$tr.find('td:last').off('click');
		$this.css({'visibility': 'hidden'}).parent().addClass('wating').find('span.del_msg').remove();
		switch($tr.attr('data-level')){
			case 'level1' :
				remote_fn['cls'] = WORK_CLS['level1'];
				remote_fn['json'] = { 'soldtoId': id };
				filterCls = 'tr.'+id+'_level1';
				break;
			case 'level2' :
				remote_fn['cls'] = WORK_CLS['level2'];
				remote_fn['json'] = { 'soldtoId': $tr.attr('data-sid'), 'oemId': id};
				filterCls = 'tr.'+id+'_level2';
				break;
			case 'level3' :
				remote_fn['cls'] = WORK_CLS['level3'];
				remote_fn['json'] = { 'soldtoId': $tr.attr('data-sid'), 'oemId': $tr.attr('data-pid'), 'partId': id };
				filterCls = 'tr.'+id+'_level3';
				break;
		}
		remote_fn['filtercls'] = filterCls;
		$tr.parent().find(filterCls).each(function(){
			if(this.rowIndex == $tr.index()){ return true; }
			$rBody.find('tr:eq('+this.rowIndex+')').addClass('dn');
			$(this).addClass('dn').find('span.fcell').html('+').parent().find('span.pin').addClass('spin');
			/** added by CapTeam to Remove Total Part Sum Row for DNDP1**/
			//var expandClickCurrentTarget = self.expandClickCurrentTarget,
				//expandClickCurrentTargetId = $(expandClickCurrentTarget).attr('id');
				//$('.row-static-total_' + expandClickCurrentTargetId).remove();
				//$('.row-static-total-right_' + expandClickCurrentTargetId).remove();
				  $('.row-static-total_' + id).addClass('dn');
                  $('.row-static-total-right_' + id).addClass('dn');

			/** Ended by CapTeam to Remove Total Part Sum Row for DNDP1**/
		});
		switch($tr.attr('data-level')){
			case 'level1' : deleteSoldTo(remote_fn); break;
			case 'level2' : deleteOEM(remote_fn); break;
			case 'level3' : deletePart(remote_fn); break;
		}
		cb(null);
    }
    
	;function deleteSoldTo(data, cb){
    	var currenCell=$('#tab_head_list td.currentcls')[0].cellIndex-1,
    		$tds_total=data['$rbody'].find('tr:first').find('td'), id=data['$row'].attr('data-number'),
    		$restRow=data['$row'].parent().find('#'+GLOBAL['REST_SOLDTO']), $pin=$restRow.find('span.pin').removeClass('refdata'), 
			$statistical=$restRow.next().next().next(), $billing=$statistical.next(), $booking=$billing.next(), $backlog=$booking.next();

    	if(!$pin.hasClass('spin')){
    		$pin.click();
    	}
    	
    	data['$rbody'].find('tr:eq('+$statistical.index()+') td').html(' ');
    	data['$rbody'].find('tr:eq('+$billing.index()+') td').removeAttr('data-old').html('');
    	data['$rbody'].find('tr:eq('+$booking.index()+') td').removeAttr('data-old').html('');
    	data['$rbody'].find('tr:eq('+$backlog.index()+') td').removeAttr('data-old').html('');	
    		
		CATCH_DATA['level1'][id]=id;
		CATCH_DATA['DEL1'][id]={'accnumber': id};
		
		if(CATCH_DATA['level2'].hasOwnProperty(id)){
			delete CATCH_DATA['level2'][id];
		}

		for(var level in CATCH_DATA['level3']){
    		var list_level=level.split('_');
    		if(list_level[0] == soldtoId){
    			delete CATCH_DATA['level3'][level];
    		}
    	}
		
    	data['$rbody'].find('tr:eq('+data['$row'].index()+')').find('td:gt('+currenCell+')').each(function(){
    		var $total=$tds_total.eq(this.cellIndex), t=Globalize.parseInt( $.trim($(this).text()) ), 
				o=Globalize.parseInt( $.trim($total.text()) );
			$total.html( Globalize.format(o-t, DECIMAL_POINT['n0']) );
    	});	
    	
    	data['$row'].parent().find(data['filtercls']).each(function(){
			data['$rbody'].find('tr:eq('+this.rowIndex+')').remove();
			$(this).remove();
		});
		
    }
    
    ;function deleteOEM(data, cb){//soldtoId=data['$row'].attr('data-sid'),
    	var o_total={}, currenCell=$('#tab_head_list td.currentcls')[0].cellIndex-1,
    		$l_body=data['$row'].parent(), oemId=data['$row'].attr('id'), soldtoId=data['$row'].attr('data-number'),
    		$l_soldto=$l_body.find('tr.level1.mark.'+data['$row'].attr('data-sid')+'_level1'),
    		$tds_soldto=data['$rbody'].find('tr:eq('+$l_soldto.index()+')').find('td');
		
    	CATCH_DATA['DEL2'][oemId]={'accnumber': soldtoId, 'oemid': oemId};	
    	
    	if(!CATCH_DATA['level2'].hasOwnProperty(soldtoId)){
			CATCH_DATA['level2'][soldtoId] = [oemId];
		}else{
			CATCH_DATA['level2'][soldtoId].push(oemId);
		}
    	
    	for(var level in CATCH_DATA['level3']){
    		var list_level=level.split('_');
    		if(list_level[0] == soldtoId && list_level[1] == oemId){
    			delete CATCH_DATA['level3'][level];
    		}
    	}
    	
    	data['$rbody'].find('tr:eq('+data['$row'].index()+')').find('td:gt('+currenCell+')').each(function(){
    		var $soldto=$tds_soldto.eq(this.cellIndex), $this=$(this), $input=$this.find('input'),
    			t=Globalize.parseInt( ($input.length == 0 ? $this.html() : $input.val()) ), 
				o=Globalize.parseInt( $.trim($soldto.text()) );
			$soldto.html( Globalize.format(o-t, DECIMAL_POINT['n0']) );
    	});	
    	
    	$l_body.find('tr.mark.level1').each(function(){
    		data['$rbody'].find('tr:eq('+this.rowIndex+')').find('td:gt('+currenCell+')').each(function(){
    			var $this=$(this), $input=$this.find('input'), v=($input.length == 0 ? $this.html() : $input.val());
    			o_total[this.cellIndex] = (getZeroOfNumber(o_total[this.cellIndex]) + Globalize.parseInt(v));
    		});
    	});
    	
    	for(var o in o_total){
    		data['$rbody'].find('tr:first td:eq('+o+')').html( Globalize.format(o_total[o], DECIMAL_POINT['n0']) );
    	}
    	
    	$l_body.find(data['filtercls']).each(function(){
    		data['$rbody'].find('tr:eq('+this.rowIndex+')').remove();
			$(this).remove();
		});
    }
    ;function deletePart(data, cb){//soldtoId=data['$row'].attr('data-sid'),
    	var $l_body=data['$row'].parent(), soldtoId=data['$row'].attr('data-number'), oemId=data['$row'].attr('data-pid'),
    		partId=data['$row'].attr('id'),	soldtoId_oemId=(soldtoId+'_'+oemId),
    		$l_oem=$l_body.find('tr.level2.mark.'+oemId+'_level2.'+data['$row'].attr('data-sid')+'_level1'),
    		$tds_oem=data['$rbody'].find('tr:eq('+$l_oem.index()+')').find('td');
		
    	CATCH_DATA['DEL3'][partId]={'accnumber': soldtoId, 'oemid': oemId, 'partid': partId};
    	if(!CATCH_DATA['level3'].hasOwnProperty(soldtoId_oemId)){
			CATCH_DATA['level3'][soldtoId_oemId] = [partId];
		}else{
			CATCH_DATA['level3'][soldtoId_oemId].push(partId);
		}	
    		
    	data['$rbody'].find('tr:eq('+data['$row'].index()+')').find('td.td_input').each(function(){
    		var $oem=$tds_oem.eq(this.cellIndex), o=Globalize.parseInt( $.trim($oem.text()) ), 
    			t=Globalize.parseInt( $.trim($(this).text()) ), rest=getZeroOfNumber_Int($oem.attr('data-rest'));
			$oem.attr('data-rest', (t+rest));//.html( Globalize.format(o+t, DECIMAL_POINT['n0']) );
    	});
    	
    	$l_body.find(data['filtercls']).each(function(){
			data['$rbody'].find('tr:eq('+this.rowIndex+')').remove();
			$(this).remove();
			isdelpart = true;
			addPartTotalRow();
			
			
		});
    }
    
    
	/* HELP function*/
}


;function event_editPartPopupBox_click(e){
	$('#popupmain').fadeIn('fast');
	
	/* Added by Cap Team */
	if ($(e.currentTarget).parent().hasClass('level3')) {
		self.partInfoChangeArray.length = 0;
	}
	/* End by Cap Team */
	appendCloneHead();

	var $this=$(this), $tr=$this.parent(), $lBody=$tr.parent(), $rBody=$('#rtabid'), 
		$backLog=$tr.next().next().next().next().next().next(), isCFT=$this.attr('data-iscft'), asplabel = '', cftlabel='',
		$rbacklog=$rBody.find('tr:eq('+$backLog.index()+')'), $leftTbody=$('#edit_left_tbody').empty(), $rightTbody=$('#edit_right_tbody').empty(),
		json={'soldtoId': $tr.attr('data-sid'), 'oemId': $tr.attr('data-pid'), 'partId': $tr.attr('id'), 'startDate': $('#hidd_start').val(),
			  'managerId': $('#hidd_manager').val(), 'accnumber': $tr.attr('data-number'), 'endDate': $('#hidd_end').val(), 'map_year_monthsFuture': $.parseJSON($('#hidd_futuremonthmap').val())
			},
		aspAttr={'$td': $this, '$row': $tr, 'aspLabel': '<span style="line-height: 25px;">Reference ASP </span>', 
				'cls': WORK_CLS['level3'], 'action': getASP_js, 'complete': complete_aspData, 'json': JSON.stringify(json)},
		cftAttr={'cls': WORK_CLS['level3'], 'action': getCFTData_js, 'complete': complete_CFTData, 'json': JSON.stringify(json),
				'$td': $this, '$row': $tr, 'cftLabel': '<span style="line-height: 25px;">CFTForecast(Unit) </span>'};			  
      

	if(!$this.hasClass('aspload') && !$this.hasClass('wait')){	//this check load asp data.
		$this.addClass('wait');
		asplabel = aspAttr['aspLabel']+'<span class="aspcell wating">&nbsp;</span>';
		customMultipleRemoteAction(aspAttr, aspAttr['action'], aspAttr['complete']);
		}else if($this.hasClass('wait')){
		asplabel = aspAttr['aspLabel']+'<span class="aspcell wating">&nbsp;</span>';
	}else{
		var t= Globalize.format(parseFloat($this.attr('data-asp')), DECIMAL_POINT['n4']);
		asplabel = aspAttr['aspLabel']+'<input value="'+t+' USD" data-asp="'+$this.attr('data-asp')+'" onclick="event_aspData_click(event, this)" type="button" class="btn" style="position: absolute;right: 2px;" />';
	}
	if(isCFT == 'true' || isCFT == true){
		if(!$this.hasClass('cftload') && !$this.hasClass('waitcft')){	//this check load asp data.
			$this.addClass('waitcft');
			cftlabel = cftAttr['cftLabel']+'<span class="cftcell wating">&nbsp;</span>';
			customMultipleRemoteAction(cftAttr, cftAttr['action'], cftAttr['complete']);
		}else if($this.hasClass('waitcft')){
			cftlabel = cftAttr['cftLabel']+'<span class="cftcell wating">&nbsp;</span>';
		}else{
			cftlabel = cftAttr['cftLabel']+'<input onclick="event_CFTData_click(event, this)" value="Copy CFT" type="button" class="btn cftbtncls" style="position: absolute;right: 2px;"/>';
		}
	}
	
	
	if(!$backLog.hasClass('loaded') && !$tr.hasClass('loadedbacklog')){
		
		var attr={ 'findcls': '', 'json' : $.extend({}, json), 'cls': WORK_CLS['level3'], 'monthCell': {}, 'cellMonth': {}, 
				'$row': $tr, '$backlog': $rbacklog,  'action' : getBacklogRefData_js, 'complete' : complete_refDataBacklog1
			 };
		attr['json']['set_fiscalMonth'] = [];
		
		$('#tab_head_list td:not(.historicalcls)').each(function(){
			var cell=this.cellIndex, month=this.getAttribute('data-month');
			$rbacklog.find('td:eq('+cell+')').attr({'data-month': month});
			attr['monthCell'][month] = cell;
			attr['cellMonth'][cell] = month;
			attr['json']['set_fiscalMonth'].push(month);
		});
		
		attr['json'] = JSON.stringify(attr['json']);
		customMultipleRemoteAction(attr, attr['action'], attr['complete']); //this is remote action
	}
	
	
	$('#savefcbtn').attr({'data-json': aspAttr['json']});
	$('#editBoxDiv').css({'width': '0%', 'display': ''}).animate({'width': '75%'}, 720, function(){
		$('#editleftth').css({'height': $('#edit_thead').height()-1.5});
		
	});
	$('#editboxtitle').html('<b>'+$tr.find('span.namecell').html()+'</b>');
	
	var $crtRow=$rBody.find('tr:eq('+$tr.index()+')').clone().removeClass('dn overbodybg'),
		$lRestRow=$lBody.find('tr.mark.level2.'+$tr.attr('data-sid')+'_level1.'+$tr.attr('data-pid')+'_level2'),
		$rRestRow=$rBody.find('tr:eq('+$lRestRow.index()+')').clone().removeClass('dn overbodybg'),
		$rBackLogRow=$rbacklog.clone().removeClass('dn overbodybg'),
		cellIdx=$crtRow.find('td').removeClass('dn').filter('.td_input:first').prev()[0].cellIndex;
	
	$crtRow.find('td').filter(':not(.td_input):not(:last)').remove();	
	$rRestRow.find('td').removeClass('dn').filter(':lt('+cellIdx+')').remove();
	$rBackLogRow.find('td').removeClass('dn').addClass('td_input').filter(':lt('+cellIdx+')').remove();
	$rRestRow.find('td').attr('data-min', function(){ return this.getAttribute('data-rest'); });
	$rightTbody.attr({'data-region-part': $tr.attr('data-region'), 'data-region-oem': $lRestRow.attr('data-region')});
	/* comment start by CapTeam for "Copy OEM Backlog" btn checkbox functionality */
	     var seleactAllbtns = '<input onclick="event_SelectAllBacklog_click(event, this)" value="Select All" type="button" class="btn"/>'
                       + '<input onclick="event_UnSelectAllBacklog_click(event, this)" value="Unselect All" type="button" class="btn"/>';
		 appendCloneColumn('<span> '+ seleactAllbtns+'</span>', 'OEMBacklogChkCls', $crtRow.clone(), $leftTbody, $rightTbody, chkInput, chkval);
    /* comment end by CapTeam for "Copy OEM Backlog" btn checkbox functionality */
	
	
	
	appendCloneColumn('<span >Quantity(Unit)</span>', 'qtycls', $crtRow.clone(), $leftTbody, $rightTbody, qtyInput, qtyText);
	if(isCFT == 'true' || isCFT == true){
		appendCFTCloneColumn(cftlabel, 'cftcls', $crtRow.clone(), $leftTbody, $rightTbody, cftText, cftText);
	}
	appendCloneColumn(asplabel, 'pricecls', $crtRow.clone(), $leftTbody, $rightTbody, priceInput, priceText);
	appendCloneColumn('RestPNsForecast($)', 'restcls', $rRestRow.clone(), $leftTbody, $rightTbody, restText, restText);
	appendCloneColumn('TotalBacklog(Unit)<span class="bkmark"></span>', 'backlogcls', $rBackLogRow, $leftTbody, $rightTbody, backlogText, backlogText);
	
	if( !$backLog.hasClass('loaded') && !$tr.hasClass('loadedbacklog') ){
		$tr.addClass('loadedbacklog');
		$('#edit_left_tbody span.bkmark').parent().append('<span class="cftcells wating leftbacklog">&nbsp;</span>');
	}else{
		$('#edit_left_tbody span.bkmark').parent().append('<input onclick="event_copyBacklog_click(event, this)" value="Copy backlog" type="button" class="btn" style="position: absolute;right: 2px;margin-top: -4px;" />');
	}
	
	
	//$leftTbody.append('<tr><td>'+$this.html()+'</td></tr>');
	$leftTbody.append('<tr><td>CurrentSalesForecast ($)</td></tr>');
	//$rightTbody.append($crtRow.addClass('curtcls')).find('input').on('focus change keyup', event_partInput_change);
	
	/* comment start by CapTeam for "Copy OEM Backlog" btn checkbox functionality */
	$rightTbody.append($crtRow.addClass('curtcls')).find("input[type='text']").on('focus change keyup', event_partInput_change);
	/* comment end by CapTeam for "Copy OEM Backlog" btn checkbox functionality */
	
	/*
	$rightTbody.find('tr.curtcls td').html(function(){
		console.log( this );
		return (Globalize.format(getZeroOfNumber(this.getAttribute('data-rest')), DECIMAL_POINT['n0']));
	});
	*/
	/* Help function*/
	;function appendCloneHead(){
		var $rHead=$('#edit_thead'), $oldHead=$('#rHeadBody');
		if($rHead.find('tr').length != 0 ){
			return;
		}
		$rHead.append($oldHead.find('tr').clone());
		$rHead.find('tr').removeAttr('id').find('th, td').removeClass('dn').filter('.historicalcls, .th_historicalcls').remove();

		$('#editBoxScroll').scroll(event_rEditCellScroll);
	}
	
	;function appendCloneColumn(label, cls, $element, $leftTbody, $rightTbody, fn_input, fn_text){
		$element.addClass(cls).find('td.td_input').html(fn_input).filter(':first').prev().html(fn_text);
		$leftTbody.append('<tr><td>'+label+'</td></tr>');
		$rightTbody.append($element);
	}
	;function appendCFTCloneColumn(label, cls, $element, $leftTbody, $rightTbody, fn_input, fn_text){
		var map_cft={}, cellMonth={};
		try{ map_cft=$.parseJSON($this.attr('data-cft')); }catch(e){ }
		
		$('#edit_thead tr.tab_head_list td').each(function(){
			cellMonth[this.cellIndex] = this.getAttribute('data-month');
		});
		$element.addClass(cls).find('td').each(function(){
			var t = (map_cft.hasOwnProperty(cellMonth[this.cellIndex]) ? map_cft[cellMonth[this.cellIndex]]['quantity'] : 0);
			this.innerHTML = Globalize.format(t, DECIMAL_POINT['n0']);
		});
		$leftTbody.append('<tr><td>'+label+'</td></tr>').find('input.cftbtncls').attr('data-cft', JSON.stringify(map_cft));
		$rightTbody.append($element);
	}
	;function qtyInput(){
		var qty = getZeroOfNumber(this.getAttribute('data-nqty'));
		return ('<input type="text" class="inputcls" data-type="qty" onpaste="pasteFromClipboard(event, this)" value="'+Globalize.format(qty, DECIMAL_POINT['n0'])+'" />');
	}
	;function qtyText(){
		return (Globalize.format(getZeroOfNumber(this.getAttribute('data-nqty')), DECIMAL_POINT['n0']));
	}
	;function priceInput(){
		var price = getZeroOfNumber(this.getAttribute('data-nprice'));
		return ('<input type="text" class="inputcls" data-type="price" onpaste="pasteFromClipboard(event, this)" value="'+Globalize.format(price, DECIMAL_POINT['n4'])+'" />');
	}
	;function priceText(){
		return (Globalize.format(getZeroOfNumber(this.getAttribute('data-nprice')), DECIMAL_POINT['n4']));
	}
	;function restText(){
		return (Globalize.format(getZeroOfNumber(this.getAttribute('data-min')), DECIMAL_POINT['n0']));
	}
	;function backlogText(){
		return this.getAttribute('data-old');
	}
	/* comment start by CapTeam for "Copy OEM Backlog" btn checkbox functionality */
	   ;function chkInput(){ 
        var qty = getZeroOfNumber(this.getAttribute('data-nqty')); 
      /*  return ('<input type="checkbox" value="'+this.getAttribute('data-old')+'" />'); */
      return ('<input type="checkbox" value="" checked/>');
    } 
    ;function chkval(){
        return (Globalize.format(getZeroOfNumber(this.getAttribute('data-nqty')), DECIMAL_POINT['n0']));
    }
	/* comment end by CapTeam for "Copy OEM Backlog" btn checkbox functionality */
	;function cftText(){
		return '';
	}
	
	
	
	/* Help function*/
}

/* Prabhanjan show backlog modal on "copy oem backlog" button click */
var mapbacklogdata;
;function complete_refDataBacklog3(result, event, data){
    var resultJSON = $.parseJSON(result);
        mapbacklogdata = resultJSON['map_backlogrefdata'];
        var months = [];
        $('#tab_head_list td:not(.historicalcls)').each(function(){
            months.push(this.getAttribute('data-month'));
        });
        
        $trs=$('#edit_right_tbody tr'),  
    $AllBacklogs=$trs.filter('.OEMBacklogChkCls').find('input');
    $AllBacklogs.each(function(idx2){ 
            this.value = mapbacklogdata[months[idx2]];
            });
    $AllBacklogslabels=$trs.filter('.backlogcls').find('td');
    $AllBacklogslabels.each(function(idx2){ 
                this.innerHTML = mapbacklogdata[months[idx2]];
            });

}
; function showbacklogmodal(btnelem){
    var $span=$(btnelem).parent();
    var $tr = $(btnelem).parent().parent().parent().parent().parent();
    var  $rBody=$('#rtabid');
    var $leftTbody=$('#edit_left_tbody').empty();
    var $rightTbody=$('#edit_right_tbody').empty();
    var list_q=[];
    var json={'soldtoId': $tr.attr('data-sid'), 'oemId': $tr.attr('id'), 'startDate': $('#hidd_start').val(), 'set_fiscalMonth':list_q,
              'managerId': $('#hidd_manager').val(), 'accnumber': $tr.attr('data-number'), 'endDate': $('#hidd_end').val(), 'map_year_monthsFuture': $.parseJSON($('#hidd_futuremonthmap').val())
            };
    var aspAttr={'$td': $span, '$row': $tr, 'aspLabel': '<span style="line-height: 25px;">Reference ASP </span>', 
                'cls': WORK_CLS['level2'], 'monthCell': {}, 'cellMonth': {}, 'actionBacklog': getBacklogRefData_js, 'complete': complete_refDataBacklog3, 'json': JSON.stringify(json)};
        
 //   console.log($tr.attr('data-sid'));
 //   console.log(aspAttr['json']);
 
    $('#popupmain').show("slide");
    
    appendCloneHead(); 
      
    $('#savefcbtn').hide();
	/* comment added by Cap team to show permanent message below save & close on part box */
	$('#msg').hide();
	//$('#msg_samsung').hide();
	/* comment added by Cap team to show permanent message below save & close on part box */
    $('#oemoverridebtn').show();
      
    $('#oemoverridebtn').attr({'data-json': aspAttr['json']});
 
    $('#editBoxDiv').css({'width': '0%', 'display': ''}).animate({'width': '75%'}, 420, function(){
        $('#editleftth').css({'height': $('#edit_thead').height()-1.5});
    });
    $('#editboxtitle').html('<b>Sold to Account: </b>'+$tr.attr('data-number')+' '+$tr.attr('data-title')+' - <b>OEM Account: </b>'+$span.html().split('<')[0]); 
     
    var $crtRow=$rBody.find('tr:eq('+$tr.index()+')').clone().removeClass('dn overbodybg'); 
    $crtRow.find('td').filter(':not(.td_input):not(:last)').remove();   
    
    $('#tab_head_list td:not(.historicalcls)').each(function(){
        
            var cell=this.cellIndex, month=this.getAttribute('data-month');
            aspAttr['monthCell'][month] = cell;
            aspAttr['cellMonth'][cell] = month;
            json['set_fiscalMonth'].push(month);
        });
    aspAttr['json'] = JSON.stringify(json);
    customMultipleRemoteAction(aspAttr, aspAttr['actionBacklog'], aspAttr['complete']);    
    var seleactAllbtns = '<input onclick="event_SelectAllBacklog_click(event, this)" value="Select All" type="button" class="btn"/>'
                       + '<input onclick="event_UnSelectAllBacklog_click(event, this)" value="Unselect All" type="button" class="btn"/>';
    appendCloneColumn1('<span> '+ seleactAllbtns+'</span>', 'OEMBacklogChkCls', $crtRow.clone(), $leftTbody, $rightTbody, chkInput, chkval);  
    appendCloneColumn1('OEM Backlog Value in $<span class="bkmark"></span>', 'backlogcls', $crtRow.clone(), $leftTbody, $rightTbody, backlogText, backlogText);
    

       
    
    ;function appendCloneHead(){

        var $rHead=$('#edit_thead'), $oldHead=$('#rHeadBody');
        if($rHead.find('tr').length != 0 ){
            return;
        }
        $rHead.append($oldHead.find('tr').clone());
        $rHead.find('tr').removeAttr('id').find('th, td').removeClass('dn').filter('.historicalcls, .th_historicalcls').remove();

        $('#editBoxScroll').scroll(event_rEditCellScroll);
    }
    
    ;function appendCloneColumn1(label, cls, $element, $leftTbody, $rightTbody, fn_input, fn_text){   
        $element.addClass(cls).find('td.td_input').addClass('OEMBacklogAmtCls').html(fn_input).filter(':first').prev().html(fn_text);
        $leftTbody.append('<tr><td style="text-align: center; vertical-align: middle;">'+label+'</td></tr>');
        $element.each(function(){
        })
        $rightTbody.append($element);
        
    }
    
    ;function chkInput(){ 
        var qty = getZeroOfNumber(this.getAttribute('data-nqty')); 
      /*  return ('<input type="checkbox" value="'+this.getAttribute('data-old')+'" />'); */
      return ('<input type="checkbox" value="" />');
    } 
    ;function chkval(){
        return (Globalize.format(getZeroOfNumber(this.getAttribute('data-nqty')), DECIMAL_POINT['n0']));
    }
    
    ;function backlogText(){
       // return this.getAttribute('data-old');
       return null;
    }
   // event.stopImmediatePropagation();
   

}
;function event_SelectAllBacklog_click(evt, target){
    var $this=$(target), $trs=$('#edit_right_tbody tr'), $AllBacklogs=$trs.filter('.OEMBacklogChkCls').find('input');
    
    $AllBacklogs.each(function(){
        this.checked = true;  
    });
}
;function event_UnSelectAllBacklog_click(evt, target){
    
    var $this=$(target), $trs=$('#edit_right_tbody tr'), $AllBacklogs=$trs.filter('.OEMBacklogChkCls').find('input');
    
    $AllBacklogs.each(function(){
        this.checked = false;  
    });
} 

;function overrideForecast(event, target){ 
       
    var $inputs=$(this).parent().find('input').attr({'disabled': true}),
    $this=$(target), $trs=$('#edit_right_tbody tr'),  
    $AllBacklogs=$trs.filter('.OEMBacklogChkCls').find('input'),
    $amountCell=$trs.filter('.OEMBacklogAmtCls').find('td:not(:first)'),
    cCell=$('#tab_head_list td.currentcls')[0].cellIndex,
    dataJson=$.parseJSON($this.attr('data-json')),  
    oemcls='#ltabid tr.mark.level2.'+dataJson['soldtoId']+'_level1.'+dataJson['oemId']+'_level2',
    $oemRest=$('#rtabid tr:eq('+$(oemcls).index()+')').find('td:gt('+cCell+')'); 
   // console.log($oemRest.parent().html()); 
      
       console.log($AllBacklogs.html());
    $oemRest.each(function(idx){
       // $oemRest.eq(idx).attr('data-rest', idx);
           
            $AllBacklogs.each(function(idx2){ 
            
               if(idx==idx2 && this.checked == true){
                   $oemRest.eq(idx).find('.inputcls').val(this.value);
                   $oemRest.eq(idx).find('.inputcls').trigger("change");
               }
                   
            });
           
        });
    $('#savefcbtn').show();
    $('#oemoverridebtn').hide();
    event_closePartPopupBox_click(event, target);

}
 
;function event_populateValues_click(event, target){
    document.getElementById('loading-curtain-div').style.display = '';
    var $cmt=$('#cmttitle'), $cmtTarea=$('#cmttareaid'),
        json={'$cmt': $cmt, '$cmtTarea': $cmtTarea,
            'json': JSON.stringify({'soldtoId': $cmt.attr('data-id'), 'accnumber': $cmt.attr('data-number'), 'searchKey': $cmtTarea.val()}) };
    customRemoteAction(json, saveEOLCmt_js, complete_saveEOLCmt);
}

;function event_closePartPopupBox_click(event, target){

	/*Prabhanjan : adding show hide methods on savefcbtn and oemoverridebt */
      $('#savefcbtn').show();
      $('#oemoverridebtn').hide(); 
	  /* comment added by Cap team to show permanent message below save & close on part box */
	  $('#msg').show();
	  //$('#msg_samsung').hide();
	  /* comment added by Cap team to show permanent message below save & close on part box */
	/*Prabhanjan : adding show hide methods on savefcbtn and oemoverridebt */
	
	$('#editBoxDiv').hide();
	$('#edit_left_tbody').empty();
	$('#edit_right_tbody input').off('focus change');
	$('#edit_right_tbody').empty();
	$('#popupmain').fadeOut('fast');
}

;function event_existData_click(e){
//	e.stopPropagation();
	var hide = 'dn', list_element = [], $right_trs=$('#rtabid tr'), _this = this, $this=$(_this),
    	$leftBody=$this.parent(), $waiting = $this.find('td:first span.fcell'), $pin=$this.find('span.pin'),
    	config={'id': $this.attr('id'), 'data-level': $this.attr('data-level'), 
    			'data-number': $this.attr('data-number'), 'rowIndx': $this.index(), 'isRemote': false
    			},
        fn = ($this.hasClass('exp')? exp : col);

    $this.find('td:first span.reload_span').remove();
    if($this.find('td:first input[type="button"].delpartbtn').hasClass('disabled_btn')){ return false; }
    if(rowIsLocked(config['rowIndx'])){ return false; }
	expandClickCurrentTarget = e.currentTarget;
    fn();
    
    
    ;function exp(){
    	
    	if(isLoadedSubData()){
    		return false;
    	}
    	
    	var levelCls = '';
    	
    	switch(config['data-level']){
    		case 'level1' : 
    				levelCls = 'tr:not(.level1).'+config['id']+'_level1';
				break;
    		case 'level2' :
    				levelCls = 'tr:not(.level2).'+config['id']+'_level2.'+$this.attr('data-sid')+'_level1';
    			break;
    		default : break;
    	}
    	
    	QUEUE.push({name: config['rowIndx'], run: function(cb){
			var expandClickCurrentTarget = self.expandClickCurrentTarget,
				expandClickCurrentTargetId = $(expandClickCurrentTarget).attr('id');
				$('.row-static-total_' + expandClickCurrentTargetId).remove();
				$('.row-static-total-right_' + expandClickCurrentTargetId).remove();
	        $leftBody.find(levelCls).addClass(hide).each(function(){
	            $right_trs.eq(this.rowIndex).addClass(hide);
	            $(this).removeClass('exp col').first().addClass('col').find('span.pin').addClass('spin')
	            		.parent().find('span.fcell').html('+');
	        });
	        rowUnLock(config['rowIndx']);
	        $this.removeClass('exp').addClass('col');
	        $waiting.html('+').removeClass('wating');
            cb(null);
        }}, function(err){ });
    }
    
    ;function col(){
    	var remote_fn={'remote':function(p){}, 'rowIndex': config['rowIndx'], 'data-number': config['data-number'], 
    					'$row': $this, 'soldtoid': $this.attr('data-sid'), 'action': existObject_js, 'complete': function(){},
    					'title': $this.attr('data-title'), 'pid': config['id']}, levelCls='',
						dataLevel = config['data-level'];
    	
    	$waiting.addClass('wating').html('&nbsp;');
    	
    	switch(dataLevel){
    		case 'level1' : 	//this search oem.
    				remote_fn['data-level'] = 'level2';
    				remote_fn['complete'] = complete_existLevel2Result;
    				levelCls = 'tr.level2.mark.'+config['id']+'_level1';
    				remoteCheck(levelCls, remote_fn, createLevel2, WORK_CLS['level2']); 
    			break;
    		case 'level2' : 	//this search part. 
    				remote_fn['data-level'] = 'level3';
    				remote_fn['complete'] = complete_existLevel3Result;
    				levelCls = 'tr.level3.mark.'+config['id']+'_level2.'+$this.attr('data-sid')+'_level1';
    				remoteCheck(levelCls, remote_fn, createLevel3, WORK_CLS['level3']); 
    			break;
    		default : break;
    	}
    	
    	remote_fn['remote'](remote_fn);
    	expandElement(levelCls, dataLevel);
    }
    
    
    
    ;function remoteCheck(findCls, remoteFn, createJSON, actionClass){
    	if($this.hasClass('done')){ return; }
    	$this.find('span.del_img').css('visibility', 'hidden');
        config['isRemote'] = true;
        remoteFn['cls'] = actionClass;
        remoteFn['json'] = createJSON(findCls);
        remoteFn['remote'] = function(p){
        	customMultipleRemoteAction(p, remoteFn['action'], remoteFn['complete']); //this is remote action
        };
        
        
        if(remoteFn['data-level'] == 'level3'){
        	var json = {'json': $.parseJSON(remoteFn['json']), '$row': $this}, list_ids=[];
        	$leftBody.find('tr.level3.mark.'+json['pid']+'_level2.'+json['sid']+'_level1').each(function(){
        		list_ids.push(this.id);
        	});
        	json['json']['set_selectedId'] = list_ids;
        	json['json'] = JSON.stringify(json['json']);
        	customRemoteAction(json, hasKeyPart_js, complete_hasKeyPart);
        }

    }
    
    
    ;function createLevel2(){
    	var t = {'soldtoId': config['id'], 'startDate': $('#hidd_start').val(), 'endDate': $('#hidd_end').val(), 'managerId': $('#hidd_manager').val(),  
    			 'accnumber': config['data-number'], 'map_year_monthsFuture': $.parseJSON($('#hidd_futuremonthmap').val())};
    	return JSON.stringify(t);
    }
    ;function createLevel3(){
    	var t = {'soldtoId': $this.attr('data-sid'), 'oemId': config['id'], 'startDate': $('#hidd_start').val(), 'endDate': $('#hidd_end').val(), 
    			 'managerId': $('#hidd_manager').val(), 'accnumber': config['data-number'], 'map_year_monthsFuture': $.parseJSON($('#hidd_futuremonthmap').val())};
    	return JSON.stringify(t);
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
	
	
    
    ;function expandElement(levelCls, dataLevel){
    	QUEUE.push({name: config['rowIndx'], run: function(cb){
            var list_element = $leftBody.find(levelCls).toArray();
			this.dataLevel = dataLevel;
			self.testCounter = 0;
			/*if (dataLevel === 'level2') {
				//$('.row-static-total').removeClass(hide);
				addPartTotalRow();
			}*/
			console.log('Length: ' + list_element.length);
            async.eachSeries(list_element, function(item, callback) {
                setTimeout(function(){
                	var $item=$(item).removeClass(hide);
                    $right_trs.eq(item.rowIndex).removeClass(hide);
					//addPartTotalRow();
					self.testCounter += 1;
					console.log('counter: ' + self.testCounter);
					//addPartTotalRow();
                    callback(null);
                }, 65);
            }, function(err){
            	list_element=[];
                if(!config['isRemote']){ 
                    rowUnLock(config['rowIndx']);
                    $waiting.html('-').removeClass('wating'); 
					addPartTotalRow();
                }
                $this.removeClass('col').addClass('exp');
                cb(null);
            });
        }}, function(err){ });
    }
}

;function event_addSearchObject_click(e){	//search object add element event
	
	var $checkboxs = $('#popupbody input[type="checkbox"]:checked'), $searchBtn=$('#searchbtn'),
		data_level=$('#searchbtn').attr('data-level'), data={ 'fn': function(){}, 'list_result': [] };
	
	if($checkboxs.length == 0){ return; }
	
	data['$inputs'] = $('#popupbox input[type="button"]').attr({'disabled': 'disabled'});
	$checkboxs.each(function(){
		data['list_result'].push($.parseJSON($(this).attr('data-json')));
	});	
	data['list_result'].reverse();	//reverse data list 
	data['data-level'] = data_level;
	data['data-number'] = $searchBtn.attr('data-number');
	data['pid'] = $searchBtn.attr('data-parent');
	data['soldtoid'] = $searchBtn.attr('data-sid');
	data['title'] = $searchBtn.attr('data-title');
	data['insert'] = 'search';
	setTemplateElement(data);
	
	data['callBackEnd'] = function(_callBack, _data){

		if($('#popupbody').attr('data-type') == 'keypart'){
			var  json = {'json': {'accnumber': _data['data-number'], 'oemId': _data['pid'], 'set_selectedId': [], 'set_deletedId': []}};
			$('#ltabid tr.level3.mark.'+_data['pid']+'_level2.'+_data['soldtoid']+'_level1').each(function(){
				json['json']['set_selectedId'].push(this.id);
			});
			
			for(var level in CATCH_DATA['level3']){ 
				if(level == (_data['data-number']+'_'+_data['pid'])){
					json['json']['set_deletedId'] = CATCH_DATA['level3'][level];
					break;
				}
			}
			
        	json['json'] = JSON.stringify(json['json']);
			customRemoteAction(json, hasKeyPart_js, function(result, event, d){
				if(event.status && (result == 'false' || result == false)){
					$('#ltabid tr.level2.mark.'+_data['pid']+'_level2.'+_data['soldtoid']+'_level1').find('b.keypartb').remove();
			    }
	    		event_closePopUP_click(null);
		        _data['$inputs'].removeAttr('disabled');
		        _callBack(null);
	    	});
	    	return;
		}
		
        event_closePopUP_click(null);
        _data['$inputs'].removeAttr('disabled');
		
		/* Added by Cap Team for DNDP1 */
		if (data_level === 'level3') {
			//isdelpart = true;
			addPartTotalRow();
		}
		/* End by Cap Team for DNDP1 */
        _callBack(null);
	};
	
    if(data['data-level'] == 'level1'){
    	var $restRow=$('#'+GLOBAL['REST_SOLDTO']), $pin=$restRow.find('span.pin').removeClass('refdata'), $statistical=$restRow.next().next().next(), 
    		$billing=$statistical.next(), $booking=$billing.next(), $backlog=$booking.next(), $rBody=$('#rtabid');
    	
    	if(!$pin.hasClass('spin')){
    		$pin.click();
    	}
    	
    	$rBody.find('tr:eq('+$statistical.index()+') td').html(' ');
    	$rBody.find('tr:eq('+$billing.index()+') td').removeAttr('data-old').html('');
    	$rBody.find('tr:eq('+$booking.index()+') td').removeAttr('data-old').html('');
    	$rBody.find('tr:eq('+$backlog.index()+') td').removeAttr('data-old').html('');
    }
    
	QUEUE.push({name: data_level, run: function(cb){
		EVENT_BIND.beforeload();
		data['fn'](data, cb, data['callBackEnd']);
    }}, function(err){ });
    
}

;function event_checkBox_click(e){	//checkbox event
	$('#popupbody input[type="checkbox"]').prop('checked', $(this).prop('checked'));
	
}

;function event_searchBtn_click(e){
	
	var $text=$('#searchtext'), t=$.trim($text.val()),
		$this=$(this), $loading=$('#popup_loading').html(' ').show(),
		$inputs=$('#popupbox input[type="button"]').attr({'disabled': 'disabled'}),
		json_data={'cls': $this.attr('data-cls'), 'level': $this.attr('data-level'),
					'$inputs': $inputs, '$btn': $this, '$loading': $loading};
	
	json_data['json']={'startDate': $('#hidd_start').val(), 'endDate': $('#hidd_end').val(), 'map_year_monthsFuture': $.parseJSON($('#hidd_futuremonthmap').val()), 
						'managerId': $('#hidd_manager').val(), 'isOtherMethod': false, 'searchKey': t, 'soldtoId': $this.attr('data-sid'), 'oemId': $this.attr('data-oid'), 
					   'accnumber': $this.attr('data-number'), 'set_deletedId': [], 'set_selectedId': $.parseJSON($this.attr('data-selectids')), 'set_deletedId': []};					

	switch(json_data['level']){
		case 'level1':
			for(var level in CATCH_DATA['level1']){ json_data['json']['set_deletedId'].push(level); }
			break;
		case 'level2':
			for(var level in CATCH_DATA['level2']){ 
				if(level == $this.attr('data-number')){
					json_data['json']['set_deletedId'] = CATCH_DATA['level2'][level];
					break;
				}
			}
			break;
		case 'level3':
			for(var level in CATCH_DATA['level3']){ 
				if(level == (json_data['json']['accnumber']+'_'+json_data['json']['oemId'])){
					json_data['json']['set_deletedId'] = CATCH_DATA['level3'][level];
					break;
				}
			}
			break;
	}
	json_data['json'] = JSON.stringify(json_data['json']);
	$('#popupbody').removeAttr('data-type').empty();
	CATCH_DATA['ISTOP'] = false;
	customMultipleRemoteAction(json_data, searchObject_js, complete_searchObject);	//this is remote action
}

;function event_searchHistoryOEM(target){
	var $this=$(target), $btn=$('#searchbtn'), $loading=$('#popup_loading').show().html('&nbsp;'),
		$inputs = $('#popupbox input[type="button"]').attr({'disabled': 'disabled'}),
		json_data={'cls': $btn.attr('data-cls'), 'json': {}, '$inputs': $inputs, '$btn': $btn, '$loading': $loading};
	
	json_data['json']={'startDate': $('#hidd_start').val(), 'endDate': $('#hidd_end').val(), 'map_year_monthsFuture': $.parseJSON($('#hidd_futuremonthmap').val()), 
						'managerId': $('#hidd_manager').val(), 'isOtherMethod': true, 'soldtoId': $btn.attr('data-sid'), 'oemId': $btn.attr('data-oid'), 
					   'accnumber': $btn.attr('data-number'), 'set_deletedId': [], 'set_selectedId': $.parseJSON($btn.attr('data-selectids'))};
	for(var level in CATCH_DATA['level2']){ 
		if(level == $this.attr('data-number')){
			json_data['json']['set_deletedId'] = CATCH_DATA['level2'][level];
			break;
		}
	}
	
	json_data['json'] = JSON.stringify(json_data['json']);
	$('#popupbody').removeAttr('data-type').empty();

	customMultipleRemoteAction(json_data, searchObject_js, complete_searchObject);	//this is remote action
}

;function event_searchTOPPart(target){
	var $this=$(this), $btn=$('#searchbtn'), $loading=$('#popup_loading').show().html('&nbsp;'),
		$inputs=$('#popupbox input[type="button"]').attr({'disabled': 'disabled'}),
		json_data={'cls': $btn.attr('data-cls'), 'json': {}, '$inputs': $inputs, '$btn': $btn, '$loading': $loading};
	
	json_data['json']={'startDate': $('#hidd_start').val(), 'endDate': $('#hidd_end').val(), 'map_year_monthsFuture': $.parseJSON($('#hidd_futuremonthmap').val()), 
						'managerId': $('#hidd_manager').val(), 'isOtherMethod': true, 'soldtoId': $btn.attr('data-sid'), 'oemId': $btn.attr('data-oid'), 
						'accnumber': $btn.attr('data-number'), 'set_deletedId': [], 'set_selectedId': $.parseJSON($btn.attr('data-selectids')) };
	/*
	if(!CATCH_DATA['ISTOP']){
		$('#popupbody').empty();
		CATCH_DATA['ISTOP'] = true;
	}
	$('#popupbody tr').each(function(){
		json_data['json']['set_selectedId'].push(this.id);
	});
	*/
	
	for(var level in CATCH_DATA['level3']){ 
		var list_t=level.split('_');
		if(list_t[0] == $btn.attr('data-number') && list_t[1] == $btn.attr('data-oid')){
			json_data['json']['set_deletedId'] = CATCH_DATA['level3'][level];
			break;
		}
	}
	
	json_data['json'] = JSON.stringify(json_data['json']);
	$('#popupbody').removeAttr('data-type').empty();
	customMultipleRemoteAction(json_data, searchObject_js, complete_searchObjectTOP);	//this is remote action
}

;function event_searchKeyPart(target){
	var $this=$(this), $btn=$('#searchbtn'), $loading=$('#popup_loading').show().html('&nbsp;'),
		$inputs = $('#popupbox input[type="button"]').attr({'disabled': 'disabled'}),
		json_data={'cls': $btn.attr('data-cls'), 'json': {}, '$inputs': $inputs, '$btn': $btn, '$loading': $loading};
	
	json_data['json']={'startDate': $('#hidd_start').val(), 'endDate': $('#hidd_end').val(), 'map_year_monthsFuture': $.parseJSON($('#hidd_futuremonthmap').val()), 
						'managerId': $('#hidd_manager').val(), 'isOtherMethod': true, 'searchKey': $.trim($('#searchtext').val()), 'soldtoId': $btn.attr('data-sid'), 'accnumber': $btn.attr('data-number'),
						'oemId': $btn.attr('data-oid'), 'set_deletedId': [], 'set_selectedId': $.parseJSON($btn.attr('data-selectids')) };
	
	$('#ltabid tr.level3.mark.'+json_data['json']['oemId']+'_level2.'+json_data['json']['soldtoId']+'.level1').each(function(){
		json_data['json']['set_selectedId'].push(this.id);
	});					

	for(var level in CATCH_DATA['level3']){ 
		var list_t=level.split('_');
		if(list_t[0] == $btn.attr('data-number') && list_t[1] == $btn.attr('data-oid')){
			json_data['json']['set_deletedId'] = CATCH_DATA['level3'][level];
			break;
		}
	}
	
	CATCH_DATA['ISTOP'] = false;
	json_data['json'] = JSON.stringify(json_data['json']);
	$('#popupbody').attr('data-type', 'keypart').empty();
	customRemoteAction(json_data, searchKeyPart_js, complete_searchObject);	//this is remote action
}

;function event_searchText_keyup(e){
	e.stopPropagation();
	if(e.keyCode == 13){ CATCH_DATA['ISTOP'] = false; document.getElementById('searchbtn').click(); }
}

;function event_popupBox_click(event, target){
	event = (event?event:window.event);
	event.cancelBubble = true;
	CATCH_DATA['ISTOP'] = false;
	$('#popup_loading').html(' ').hide();
	var list_ids=[], $this=$(target), $tr=$this.parent().parent().parent().parent().parent(),
		$popupbox=$('#popupbox'), $searchBtn=$('#searchbtn'), $lBody=$('#ltabid');
	
	if(!$tr.hasClass('exp')){
		$tr.click();
	}
	
	$('#popuphead input[type="checkbox"]').off('click');
	$searchBtn.parent().find('input[type="button"].otherbtn').remove();
	$searchBtn.parent().find('#divtext').remove();
	$('#popupmain').fadeIn('fast');
	
    $popupbox.css({'top':-1200, 'display':''}).stop().animate({'top':'10%'}, 800, function(){
    	$('#searchtext').val('').focus();
    });

	switch($this.attr('data-level')){
		case 'level1' : 
			$searchBtn.attr({'data-level': 'level1', 'data-cls': WORK_CLS['level1']});
			$('#popuphead').append($('#level1_tab td').clone()); 
			$lBody.find('tr.mark.level1').each(function(){
				list_ids.push(this.getAttribute('data-number'));
			});
			break;
		case 'level2' : 
			var soldToId=$tr.attr('id');
			$searchBtn.attr({'data-level': 'level2', 'data-cls': WORK_CLS['level2'],
							 'data-sid': soldToId, 'data-parent': soldToId})
					 .parent().append('<input value="Search history" onclick="event_searchHistoryOEM(this)" sytle="margin-left:10px;" type="button" class="btn otherbtn" />');
			$lBody.find('tr.mark.level2.'+soldToId+'_level1').each(function(){
				list_ids.push(this.id);
			});
			$('#popuphead').append($('#level2_tab td').clone()); 
			break;
		case 'level3' : 
			var soldToId=$tr.attr('data-sid'), oemId=$tr.attr('id');
			$searchBtn.attr({'data-level': 'level3', 'data-cls': WORK_CLS['level3'],
							 'data-sid': soldToId, 'data-parent': oemId, 'data-oid': oemId})
					.parent().append('<input value="Search top5" onclick="event_searchTOPPart(this)" sytle="margin-left:10px;" type="button" class="btn otherbtn" />' +
									'<input value="Search key part" onclick="event_searchKeyPart(this)" sytle="margin-left:10px;" type="button" class="btn otherbtn" />');
			$searchBtn.parent().append('<div id="divtext" class="divtextpart">Maximum Display: 100</div>');
			$lBody.find('tr.mark.level3.'+soldToId+'_level1.'+oemId+'_level2').each(function(){
				list_ids.push(this.id);
			});
			
			$('#popuphead').append($('#level3_tab td').clone()); 
			break;
	}
    $('#popuphead input[type="checkbox"]').on('click', event_checkBox_click);
	$searchBtn.attr({'data-title': $tr.attr('data-title'), 'data-selectIds': JSON.stringify(list_ids), 'data-number': $tr.attr('data-number')});
	$('#boxheadid').removeAttr('style');
}

;function event_closePopUP_click(target){
	$('#popupbox').stop().animate({'top':-1200}, 800, function(){
		$(this).find('input[type="checkbox"]').off('click');
        $('#popupmain').fadeOut('fast');
        $('#popuphead').empty();
        $('#popupbody').removeAttr('data-type').empty();
    });
}

;function event_closeErrorBox_click(target){
	$('#showerror').animate({'top': '-120%'}, 360, function(){
		$(this).find('#errtabbody tr').remove();
	});
}

;function event_closeProgressBox_click(target){
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

;function event_closeSoldToBox_click(event, target){
	$('#restsoldtobox').hide();
	$('#loading-curtain-div').hide();
}

;function event_pBar_change(e){

}

;function event_pBar_complete(e){
	var t=parseInt($.trim($('#prg_err').html()), 10), $prog_btn=$('#progressbarbtn_div');
	$prog_btn.find('input[type="button"].errbtn').remove();

	if($.isNumeric(t) && t > 0){
		$prog_btn.prepend('<input value="Show errors" onclick="event_showErrorForecast_click(this)" class="btn errbtn" type="button" /><input onclick="event_reSaveForecast_click(this)" value="Re save forecast" class="btn errbtn" style="margin: 0 10px;" type="button"/>');
		$('#progressbarbtn_div').show();
		return;
	}
	setTimeout(function(){
		var list_data=[], cellMonth={}, $rBody=$('#rtabid'), $pError=$('#progresserror');
			
		$('#tab_head_list td.futurecls').each(function(){
			cellMonth[this.cellIndex] = this.getAttribute('data-month');
		});
		
		list_data=$('#ltabid tr.mark:not(.totcls):not(#'+GLOBAL['REST_SOLDTO']+')').toArray();
		if($pError.attr('data-v1') == 'start' && list_data.length != 0){
			var $pBar=$("#progressbar").attr('data-value', 0).progressbar('destroy').progressbar({ value: false });
			$('#progressstatusid').html('Saving records...');
			$pError.attr({'data-v1': 'done', 'data-v2': 'start'});
			$pBar.find('div.progress-label').html('Loading...');
			remoteActionCreateObject(list_data, cellMonth, $pBar, $rBody);
			return;
		}
		
		$('#loading-curtain-div').show();
		event_closeProgressBox_click(null);
		var json={'id': GLOBAL['REST_SOLDTO'], 'csFC': {}},
			remote={'action': saveCSDsObject_js, 'complete': complete_saveRestSoldTo, 'cls': WORK_CLS['restsoldto'], 'json': json},
			$restTDS=$('#rtabid tr:eq('+$('#ltabid tr.level1.mark.'+GLOBAL['REST_SOLDTO']+'_level1').index()+')').find('td');

		for(cell in cellMonth){
			var key=cellMonth[cell], value=Globalize.parseInt( $.trim($restTDS.eq(cell).find('input').val()) );
			json['csFC'][key] = value;
		}

		remote['json'] = JSON.stringify(json);
		customMultipleRemoteAction(remote, remote['action'], remote['complete']);
	}, 360);
}


;function event_showErrorForecast_click(target){
	var $body = $('#errtabbody'), $tmp_tr=$('#tmperrtab tr').clone();
	$body.find('tr').remove();
	for(var i=0, error; error = SAVE_ERRORS[i]; i++){
		var $t = $tmp_tr.clone();
		$t.find('td').eq(0).text(error['name']);
		$t.find('td').eq(1).text(error['msg']['message']);
		$body.append($t);
	}
	$('#showerror').animate({'top': '20.2%'}, 360);
}

;function event_reSaveForecast_click(target){
	var $pBar=$("#progressbar").attr('data-value', 0).progressbar('destroy'), list_save=SAVE_ERRORS.slice(0),
		o_bar=getBarConfg(list_save);

	SAVE_ERRORS=[];
	setPopBoxStatus();

	$pBar.find('div.progress-label').html('Loading...');
	$('#progresserror').css({ "background": o_bar['rgba'] });
	$('#prg_total').html(list_save.length);
	
	$pBar.progressbar({ value:false, max: o_bar['max'], change: event_pBar_change, complete: event_pBar_complete })
			.find('.ui-progressbar-value').css({ "background": o_bar['bgcolor'] });
	asyncEachSeries_Original(list_save, function(item, callback){
		item['pct'] = o_bar['pct'];
		item['max'] = o_bar['max'];
        customMultipleRemoteAction(item, item['action'], item['complete']); //this is remote action
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
	fixTableLayout($('#tabContainer').width(), false);
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

;function event_windowReSize(e){
    $('#forecastdiv_id').css({'visibility': 'hidden'});
    fixTableLayout($('#tabContainer').width(), false);
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

Array.prototype.delIndex=function(n) {
	if(n<0){ return this; }
	return this.slice(0,n).concat(this.slice(n+1,this.length));
}