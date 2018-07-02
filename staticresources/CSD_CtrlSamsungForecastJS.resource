var TIMEOUT, restCal, scrollbarW = $.getScrollbarWidth(), STATIC_VAR={}, SAVE_ERRORS=[], QUEUE = async.queue(queueRun, 1),
        CATCH_DATA = {'level2': {}, 'level3': {}, 'level4': {}, 'GF': {}, 'DEL2': {}, 'DEL3': {}, 'DEL4': {} },
        LAZY = {
               'fire' : function(obj, callback, timeout) {
                   timeout = timeout || 200;
                   setTimeout(function() { callback(null, obj); }, timeout);
               },
               'inc' : function(n, callback, timeout) {
                   timeout = timeout || 200;
                   setTimeout(function() { callback(null, n+1); }, timeout);
               },
               'err' : function(errMsg, callback, timeout) {
                   timeout = timeout || 200;
                   setTimeout(function() { callback(errMsg); }, timeout);
               }
        }, 
        DECIMAL_POINT = {'n': 'n', 'n0': 'n0', 'n1': 'n1', 'n4': 'n4'},
        WORK_CLS = {
               'level1' : 'CSD_ClsOEMService.SearchLevel1', 'level2' : 'CSD_ClsOEMService.SearchLevel2', 
               'level3' : 'CSD_ClsOEMService.SearchLevel3', 'level4' : 'CSD_ClsOEMService.SearchLevel4',
               'level0' : 'CSD_ClsOEMService.SearchTotal'
        };
/* Added by Cap team for DNDP1*/
isTotalRowInserted = false,
expandClickCurrentTarget = null,
self = this,
partInfoChangeArray = [],
isInputBoxChangeTriggeredManually = false;
testCounter = 0;
RestPart = false;
isdelsoldto=false;
/* End by Cap team for DNDP1*/
;function queueRun(task, callback) {
    task.run(callback);
}

/* Added by Cap Team to add Total Part Sum row logic for DNDP1 */
function addPartTotalRow() {
if ($(this.expandClickCurrentTarget).hasClass('level3')) {
setTimeout(function(){
var expandClickCurrentTarget = this.expandClickCurrentTarget,
expandClickCurrentTargetIndex = expandClickCurrentTarget.rowIndex,
expandClickCurrentTargetId = $(expandClickCurrentTarget).attr('id'),
partInfoChangeArray = $.unique(this.partInfoChangeArray),
historicalColumnCount = 6;
soldToAcctId = $('#ltabid tr:eq(' + (expandClickCurrentTargetIndex - $(expandClickCurrentTarget).prevUntil('.level2:not(.dn)').length - 1) +')').attr('id');
soldToAcctId2 = $('#ltabid tr:eq(' + (expandClickCurrentTargetIndex - $(expandClickCurrentTarget).prevUntil('.level1:not(.dn)').length - 1) +')').attr('id');
$('.row-static-total_' + expandClickCurrentTargetId).remove();
$('.row-static-total-right_' + expandClickCurrentTargetId).remove();
var $elem = '<tr class="row-static-total row-static-total_' + expandClickCurrentTargetId +' row-static-total_'+ soldToAcctId2 +' row-static-total_'+ soldToAcctId +'">'
+ '<td><apex:outputPanel >'
+ '<div ><span></span></div>'
+ '<div  ><span></span></div>'
+ '<div><span>  </span></div>'
+ '</apex:outputPanel></td>'
+ '<td ><font color="red"><b>Total SoldTo Sum</b></font></td>'
+'</tr>';
//$($elem).insertAfter('.ltbodycls .level2:not(.dn)');
$($elem).insertAfter(expandClickCurrentTarget);
//$('.row-static-total_' + expandClickCurrentTargetId).removeClass('dn');
var counter = 0,
endValue = $('#tab_head_list td').length,
rightPartRow = '<tr class="row-static-total-right row-static-total-right_' + expandClickCurrentTargetId +' row-static-total_'+ soldToAcctId +'">',
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
hiddenPartLength = $lBody.find('tr.mark.level4.'+$(expandClickCurrentTarget).attr('id')+'_level3.'+$(expandClickCurrentTarget).attr('data-v2')+'_level2.'+$(expandClickCurrentTarget).attr('data-v1')+'_level1').prevUntil('.row-static-total').length;
counter = 0;
requiredRowNumber += hiddenPartLength;
$lBody.find('tr.mark.level4.'+$(expandClickCurrentTarget).attr('id')+'_level3.'+$(expandClickCurrentTarget).attr('data-v2')+'_level2.'+$(expandClickCurrentTarget).attr('data-v1')+'_level1').each(function(index){
var t;
counter = 0;
endValue = $('#tab_head_list td').length
for (; counter < endValue; counter++) {
t=Globalize.parseInt( $.trim($rBody.find('tr:eq('+(requiredRowNumber - (index * 7))+')').find('td:eq('+counter+')').text()) );
if (!partTotal[counter]) {
partTotal[counter] = 0;
}
partTotal[counter] += isNaN(t) ? 0 : t;
}
});
counter = 0;
for (;counter < endValue; counter++) {
//$rBody.find('tr:eq('+partTotalRowNumber+')').find('td:eq('+counter+')').text(partTotal[counter]);
$rBody.find('tr:eq('+partTotalRowNumber+')').find('td:eq('+counter+')').text(Globalize.format(partTotal[counter],DECIMAL_POINT['n0']));
}
counter = 0;
for (;counter < partInfoChangeArray.length; counter++) {

self.isInputBoxChangeTriggeredManually = true;	
$rBody.find('tr:eq('+expandClickCurrentTargetIndex+')').find('td:eq('+(partInfoChangeArray[counter]+historicalColumnCount)+')').find('input').val(partTotal[partInfoChangeArray[counter] + historicalColumnCount]); 

//self.isInputBoxChangeTriggeredManually = true;
$rBody.find('tr:eq('+expandClickCurrentTargetIndex+')').find('td:eq('+(partInfoChangeArray[counter]+historicalColumnCount)+')').find('input').trigger('change');
}

if(isdelsoldto==true){
counter = 0;
for (;counter < futureCount; counter++) {
	
	//self.isInputBoxChangeTriggeredManually = true;
$rBody.find('tr:eq('+expandClickCurrentTargetIndex+')').find('td:eq('+(counter+historicalColumnCount)+')').find('input').val(partTotal[counter + historicalColumnCount]); 

$rBody.find('tr:eq('+expandClickCurrentTargetIndex+')').find('td:eq('+(counter+historicalColumnCount)+')').find('input').trigger('change');

	
}
isdelsoldto=false;
}
},65);

          }
      }
/* End by Cap Team to add Total Part Sum row logic for DNDP1 */ 

;function initCtrlDocument(){
        
        Globalize.culture(this.locale).numberFormat.currency.symbol = "";
        $('#floatscroll').css({'height': scrollbarW, 'line-height': scrollbarW});
        
        var t=description(GLOBAL['DJSON'][1], true);

        t += description(GLOBAL['DJSON'][2], true);
        t += description(GLOBAL['DJSON'][3], true);
        t += description(GLOBAL['DJSON'][4], true);
        t += description(GLOBAL['DJSON'][5], true);
        
        $('#left_head table.table_fix.tabbotm').before( ('<div style="height: 20px;text-align: left;padding-left: 3px;">'+t+'</div>') );
        
        fixTableLayout();
        register_event();
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
               var o_total={}, cellIndex=$('#tab_head_list td.currentcls')[0].cellIndex-1, $el_level=$('#rtabid tr:not(:first).v1'),
                       $totalCell=$('#rtabid tr:first td').css({'font-style': 'italic', 'font-weight': 'bold'});
               
               asyncEachSeries_Original($el_level.toArray(), function(item, call){
                       var $item=$(item), $pmfcItem=$item.next(), $dcfcItem=$pmfcItem.next();
                       $item.find('td').html(function(){
                               var cfc=getZeroOfNumber(this.getAttribute('data-old')), pmfc=getZeroOfNumber(this.getAttribute('data-pmfc')),
                                      dcfc=getZeroOfNumber(this.getAttribute('data-dcfc'));
                               if(this.cellIndex > cellIndex){
                                      o_total[this.cellIndex] = (getZeroOfNumber(o_total[this.cellIndex]) + cfc);
                                      $pmfcItem.find('td:eq('+this.cellIndex+')').html( Globalize.format(pmfc, DECIMAL_POINT['n0']) );
                                      $dcfcItem.find('td:eq('+this.cellIndex+')').html( Globalize.format(dcfc, DECIMAL_POINT['n0']) );
                               }
                               return Globalize.format(cfc, DECIMAL_POINT['n0']);
                       });
               }, function(err){
                       for(var o in o_total){
                               $totalCell.eq(o).html( Globalize.format(o_total[o], DECIMAL_POINT['n0']) );
                       }
               }, 180);
               
               createTotalRefDate($('#ltabid'), $('#rtabid'));
               $('div.csd_menu_div span').before('<div class="csd_view_div">'+$('#hidd_managername').val()+'</div>');
               
               /*
               $('#ltabid tr.level1.mark').each(function(){
                       var $gf=$(this).find('span.namecell'), t=$.trim($gf.text());
                       CATCH_DATA['GF'][t] = {'isRemote': true};
               });
               */
        }catch(e){ }
        $('#menuBtntd input[data-type="historical"]').click();
        document.getElementById('loading-curtain-div').style.display = 'none';
        
        ;function createTotalRefDate($lBody, $rBody){
               var list_result=[], list_months=[], el_body='', 
                       datas={'$lBody': $lBody, '$rBody': $rBody, 'monthCell': {}, 'cellMonth': {}, 'managerId': $('#hidd_manager').val(),
                               'oemId': $('#hidd_samsungid').val(), 'cls': WORK_CLS['level0'], '$row': $lBody.find('tr:first td:first'), '$rCells': $rBody.find('tr:first td'), 
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
                       attr_tmp['json'] = {'set_fiscalMonth': [month], 'managerId': attr_tmp['managerId'], 'oemId': attr_tmp['oemId']};
                       attr_tmp['json'] = JSON.stringify(attr_tmp['json']);
                       customMultipleRemoteAction(attr_tmp, attr_tmp['action'], attr_tmp['complete']); //this is remote action
               }, function(err){}, 120);
        }
}

;function register_event(){
        var $body_div = $('#div_body'), s='<img src="/s.gif" class="helpIcon" title="Billing total for histrical months, forecast total for current/future months."/> ';
        
        $body_div.find('#ltabid tr:first').removeClass('cp mark').find('td:last').empty().parent()
                       .find('div:last').addClass('mgleft1').css({'font-weight':'bold', 'margin-left': '35px'})
                     .find('span.namecell').before(s).parent().parent().find('div:not(:last)').remove();
        
//      $body_div.find('#ltabid tr.totcls div.mgleft1').removeClass('mgleft1').find('span.fcell').removeClass('fcell').addClass('pin spin').html('&nbsp;');
        
        $body_div.find('#ltabid span.pin').on('click', event_refData_click);
        
        $body_div.find('#rCellScroll').scroll(event_rCellScroll);
        $body_div.find('#ltabid tr.cp').on('click', event_existData_click);

        $body_div.find('tbody.overbody tr').on('mouseenter mouseleave', event_table_over);
        $('#savefcbtn').on('click', event_saveEditPart_click);
        $('#searchtext').on('keyup', event_searchText_keyup);
        $('#menuBtntd input').on('click', event_hideCalendar_click);
        $('#searchbtn').on('click', event_searchBtn_click);
        $('#addobjectbtn').on('click', event_addSearchObject_click);
        $(document).on('mousedown', {'elDrop': document.getElementById('dropBoxId'), '$aBox': $('#forecastdiv_id')}, event_dorpBox_down);

        $(window).scroll(event_windowScroll).smartresize(event_windowReSize);
        $('#floatscroll').scroll(event_floatScroll);
}

;function checkingStatus(){
        if($('#ltabid span.wating').length == 0){     //checked access remote function.
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

;function setTemplateElement(data){
        var monthCell={}, cellMonth={}, $head=$('#tab_head_list td'), 
               list_hidden_td=$head.filter('.dn').toArray(), ftCell=$head.filter('.currentcls')[0].cellIndex;
        
        $head.filter(':gt('+(ftCell-1)+')').each(function(){
               cellMonth[this.cellIndex] = this.getAttribute('data-month');
               monthCell[this.getAttribute('data-month')] = this.cellIndex;
        });
        data['cellMonth'] = cellMonth;
        data['monthCell'] = monthCell;
        data['ftCell']=ftCell;

        switch(data['data-level']){
               case 'level2' :
                       data['$left'] = $( ('#ltabid tr.level1.'+data['v1']+'_level1') ).last();
                       data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');
                       data['$gpl_left_template'] = $('#level2_left tr').clone();
                       data['$gpl_right_template'] = $('#level2_right tr').clone();
                       data['$soldto_left_template'] = $('#level4_left tr').clone();
                       data['$soldto_right_template'] = $('#level4_right tr').clone();
                       
                       data['$soldto_left_template'].filter(':not(:eq(0))').each(function(){
                               $(this).find('td:first').removeClass('lev3').addClass('lev1');
                       });
               data['$soldto_right_template'].first().find('td:gt('+ftCell+')').addClass('td_input').html('<input type="text" data-type="level2" class="inputcls"/>');
                       
                       hideRightColumns(data['$gpl_right_template']);
                       hideRightColumns(data['$soldto_right_template']);
                       
                       registerEvent(data['$gpl_left_template'], data['$gpl_right_template']);
                       registerEvent(data['$soldto_left_template'], data['$soldto_right_template']);
                       data['$soldto_left_template'].find('span.fcell').removeClass('cpp fcell').addClass('pin pppin')
                                                     .html('').on('click', event_refData_click);
                       break;
               case 'level3' :
                       data['$left'] =  $( ('#ltabid tr.level2.'+data['v2']+'_level2.'+data['v1']+'_level1') ).last();
                       data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');
                       data['$left_template'] = $('#level3_left tr').clone();
                       data['$right_template'] = $('#level3_right tr').clone();
               data['$right_template'].first().find('td:gt('+ftCell+')').addClass('td_input').html('<input type="text" data-type="level3" class="inputcls"/>');

                       hideRightColumns(data['$right_template']);
                       registerEvent(data['$left_template'], data['$right_template']);
                       break;
               case 'level4':

                       data['$left'] = $( ('#ltabid tr.level3.'+data['v3']+'_level3.'+data['v2']+'_level2.'+data['v1']+'_level1') ).last();
                       data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');

                       data['$left_template'] = $('#level4_left tr').clone();
                       data['$right_template'] = $('#level4_right tr').clone();
            
            data['$left_template'].first().find('td:last').on('click', event_editPartPopupBox_click);
               data['$right_template'].first().find('td:gt('+ftCell+')').addClass('td_input');//.html('<input type="text" data-type="level4" class="inputcls"/>');
                       
                       hideRightColumns(data['$right_template']);
                       registerEvent(data['$left_template'], data['$right_template']);
                       data['$left_template'].find('span.fcell').removeClass('cpp fcell').addClass('pin pppin')
                                                     .html('').on('click', event_refData_click).parent().css({'margin-left': '80px'});
                       break;
               case 'level2-4':
               
                       data['$left'] = $( ('#ltabid tr.level1.'+data['v1']+'_level1') ).last();
                       data['$right'] = $('#rtabid tr:eq('+data['$left'].index()+')');
                       data['$gpl_left_template'] = $('#level2_left tr').clone();
                       data['$gpl_right_template'] = $('#level2_right tr').clone();
                       
                       data['$part_left_template'] = $('#level3_left tr').clone();
                       data['$part_right_template'] = $('#level3_right tr').clone();
                       
                       data['$soldto_left_template'] = $('#level4_left tr').clone();
                       data['$soldto_right_template'] = $('#level4_right tr').clone();
                       
                       data['$soldto_left_template'].filter(':not(:eq(0))').each(function(){
                               $(this).find('td:first').removeClass('lev3').addClass('lev1');
                       });
                       
               data['$part_right_template'].first().find('td:gt('+ftCell+')').addClass('td_input').html('<input type="text" data-type="level3" class="inputcls"/>');
               data['$soldto_right_template'].first().find('td:gt('+ftCell+')').addClass('td_input').html('<input type="text" data-type="level2" class="inputcls"/>');
                       
                       hideRightColumns(data['$gpl_right_template']);
                       hideRightColumns(data['$part_right_template']);
                       hideRightColumns(data['$soldto_right_template']);
                       
                       registerEvent(data['$gpl_left_template'], data['$gpl_right_template']);
                       registerEvent(data['$part_left_template'], data['$part_right_template']);
                       registerEvent(data['$soldto_left_template'], data['$soldto_right_template']);
                       data['$soldto_left_template'].find('span.fcell').removeClass('cpp fcell').addClass('pin pppin')
                                                     .html('').on('click', event_refData_click);
                       break;
        }

        ;function hideRightColumns($elemetns){
               $elemetns.each(function(){
                       var $tds = $(this).find('td');
                       for(var i=0, el; el=list_hidden_td[i]; i++){
                               $tds.eq(el.cellIndex).addClass('dn');
                       }
               });
        }
        
        ;function registerEvent($leftElements, $rightElements){
               $leftElements.on('mouseenter mouseleave', event_table_over).filter('.cp')
                                                .on('click', event_existData_click).find('span.pin').on('click', event_refData_click);
               
               $rightElements.on('mouseenter mouseleave', event_table_over).find('input[type="text"]').on('focus change keyup', event_input_change);
        }
        event_windowScroll();
}

;function appendElement_Level2(data, callBack, callBackEnd){
        data['list_result'].reverse();
        asyncEachSeries_Original(data['list_result'], function(item, call){

               var $lClone=data['$gpl_left_template'].clone(true), $rClone=data['$gpl_right_template'].clone(true),
                       name=item['name'];

               if(item['type'] == 'NonPart'){
                       name=item['accnumber']+'-[ '+item['name']+' ]';
                       $lClone=data['$soldto_left_template'].clone(true);
                       $rClone=data['$soldto_right_template'].clone(true);
                       $lClone.eq(0).attr({'title': item['name']}).find('div.mgleft1').addClass('fix');
                       $lClone.eq(0).find('input[type="button"]').addClass('btnlevel2 fix').removeClass('btnlevel4');
                       if(CATCH_DATA['level2'].hasOwnProperty(data['v1'])){
                               for(var i=0, oCatch; oCatch=CATCH_DATA['level2'][data['v1']][i]; i++){
                                      if(oCatch['data-number'] == item['accnumber']){ 
                                              CATCH_DATA['level2'][data['v1']] = CATCH_DATA['level2'][data['v1']].delIndex(i);
                                              break;
                                      }
                               }
                       }

                       
               }else{
                       name += '-[ '+item['accnumber']+' ]';
                       if(CATCH_DATA['level2'].hasOwnProperty(data['v1'])){
                               for(var i=0, oCatch; oCatch=CATCH_DATA['level2'][data['v1']][i]; i++){
                                      if(oCatch['gplcode'] == item['gplcode']){ 
                                              CATCH_DATA['level2'][data['v1']] = CATCH_DATA['level2'][data['v1']].delIndex(i);
                                              break;
                                      }
                               }
                       }
               }

               $lClone.addClass( (data['v1']+'_level1 level2 '+item['id']+'_level2') ).eq(0)
                               .attr({'id': item['id'], 'data-number': item['accnumber'], 'data-v1': data['v1'], 'data-level': 'level2', 
                                              'title': item['accnumber'], 'data-name': item['name'], 'data-gplcode': item['name'], 'data-familyname': data['familyname']})
                               .find('span.namecell').html(name);
               
               $rClone.addClass('rlevel2').eq(0).find('td').each(function(){
                       var $this=$(this), $input=$this.find('input'), attr = { 'data-old': 0 };
                       if(item['csFC'] && item['csFC'].hasOwnProperty( data['cellMonth'][this.cellIndex] )){
                               attr['data-old'] = (item['csFC'][data['cellMonth'][this.cellIndex]]);   
                       }
                       $this.attr(attr);
                       if($input.length == 0){ $this.html( Globalize.format(attr['data-old'], DECIMAL_POINT['n0']) ); }
                       else{ $input.val( Globalize.format(attr['data-old'], DECIMAL_POINT['n0']) ); }
               });
               
               setFieldValue($rClone.eq(1).find('td:gt('+(data['ftCell']-1)+')'), data, item['pmFC']);
               setFieldValue($rClone.eq(2).find('td:gt('+(data['ftCell']-1)+')'), data, item['dcFC']);

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

;function appendElement_Level2_4(data, callBack, callBackEnd){

        var list_result=data['list_result'], $lTable=$('#ltabid'), $rTable=$('#rtabid');
        
        if(data['tabtype'] != 'level3'){
               data['gplresult'] = [];
               var codeTmp={}, list_gplCode=[];
               for(var i=0, result; result=list_result[i]; i++){
                       codeTmp[result['gplcode']] = {'id': result['id'], 'type': result['type'], 'name': result['accnumber']};
               }
               for(var code in codeTmp){
                       var tmp=codeTmp[code], _id=(tmp['id']+'_uniqueid'), 
                               o={'id': _id, 'gplcode': code, 'type': tmp['type'], 'accnumber': tmp['name'], 'list_part': []};

                       for(var i=0, result; result=list_result[i]; i++){
                               if(code == result['gplcode']){ 
                                      result['gpl_uniqueid'] = _id;
                                      o['list_part'].push(result);
                               }
                       }
                       list_gplCode.push(o);
               }
               list_result=list_gplCode;
        }

        asyncEachSeries_Original(list_result, function(item, call){  //append gpl code

               var $lClone=data['$gpl_left_template'].clone(true), $rClone=data['$gpl_right_template'].clone(true), name=item['gplcode'];

               if(item['type'] == 'NonPart'){
                       name=item['accnumber']+'-[ '+item['name']+' ]';
                       $lClone=data['$soldto_left_template'].clone(true);
                       $rClone=data['$soldto_right_template'].clone(true);
                       $lClone.eq(0).find('div.mgleft1').addClass('fix');
                       $lClone.eq(0).find('input[type="button"]').addClass('btnlevel2 fix').removeClass('btnlevel4');
               
                       if(CATCH_DATA['level2'].hasOwnProperty(data['v1'])){
                               for(var i=0, oCatch; oCatch=CATCH_DATA['level2'][data['v1']][i]; i++){
                                      if(oCatch['data-number'] == item['accnumber']){ 
                                              CATCH_DATA['level2'][data['v1']] = CATCH_DATA['level2'][data['v1']].delIndex(i);
                                              break;
                                      }
                               }
                       }
               
               }else{
                       name += '-[ '+item['accnumber']+' ]';
                       $lClone.eq(0).addClass('done');
                       if(CATCH_DATA['level2'].hasOwnProperty(data['v1'])){
                               for(var i=0, oCatch; oCatch=CATCH_DATA['level2'][data['v1']][i]; i++){
                                      if(oCatch['gplcode'] == item['gplcode']){ 
                                              CATCH_DATA['level2'][data['v1']] = CATCH_DATA['level2'][data['v1']].delIndex(i);
                                              break;
                                      }
                               }
                       }
                       
               }

               $lClone.addClass( (data['v1']+'_level1 level2 '+item['id']+'_level2') ).eq(0)
                               .attr({'id': item['id'], 'data-number': item['accnumber'], 'data-v1': data['v1'], 'data-level': 'level2', 
                                              'title': item['accnumber'], 'data-name': item['name'], 'data-gplcode': item['gplcode'], 'data-familyname': data['familyname']})
                               .find('span.namecell').html(name);
               
               $rClone.addClass('rlevel2').eq(0).find('td').each(function(){
                       var $this=$(this), $input=$this.find('input'), attr = { 'data-old': 0 };
                       if(item['csFC'] && item['csFC'].hasOwnProperty( data['cellMonth'][this.cellIndex] )){
                               attr['data-old'] = (item['csFC'][data['cellMonth'][this.cellIndex]]);   
                       }
                       $this.attr(attr);
                       if($input.length == 0){ $this.html( Globalize.format(attr['data-old'], DECIMAL_POINT['n0']) ); }
                       else{ $input.val( Globalize.format(attr['data-old'], DECIMAL_POINT['n0']) ); }
               });
               
               setFieldValue($rClone.eq(1).find('td:gt('+(data['ftCell']-1)+')'), data, item['pmFC']);
               setFieldValue($rClone.eq(2).find('td:gt('+(data['ftCell']-1)+')'), data, item['dcFC']);

               data['$left'].after($lClone);
               data['$right'].after($rClone);
               
               /*
               if(CATCH_DATA['level2'].hasOwnProperty(data['v1'])){
                       for(var i=0, oCatch; oCatch=CATCH_DATA['level2'][data['v1']][i]; i++){
                               if(oCatch['v2'] == item['id'] && item['type'] == 'NonPart'){ 
                                      CATCH_DATA['level2'][data['v1']] = CATCH_DATA['level2'][data['v1']].delIndex(i);
                                      break;
                               }else if(oCatch['gplcode'] == item['gplcode']){
                                      CATCH_DATA['level2'][data['v1']] = CATCH_DATA['level2'][data['v1']].delIndex(i);
                                      break;
                               }
                       }
               }
               */
               if(item['type'] != 'NonPart'){
                       var $lRow=$lTable.find('tr.level2.'+item['id']+'_level2.'+data['v1']+'_level1').last(),
                               $rRow=$rTable.find('tr:eq('+$lRow.index()+')'), list_part=item['list_part'],
                               gplResult={'gplid': item['id'], 'csfc': {}, 'dcfc': {}, 'pmfc': {}};
                       
                       for(var i=0, part; part=list_part[i]; i++){
                               appendPartElement(part, data, gplResult, $lRow, $rRow);
                       }
                       data['gplresult'].push(gplResult);
               }
               
        }, function(err){

               if(data['tabtype'] != 'level3'){
                       while (data['gplresult'].length > 0) {
                               var gplResult=data['gplresult'].shift(), $gplLrow=$lTable.find('tr.mark.level2.'+gplResult['gplid']+'_level2'),
                                       $gplRrow=$rTable.find('tr:eq('+$gplLrow.index()+')'), $gplCScell=$gplRrow.find('td'),
                                      $gplDCcell=$gplRrow.next().find('td'), $gplPMcell=$gplRrow.next().next().find('td');
                               
                               for(var cell in gplResult['csfc']){
                                      $gplCScell.eq(cell).attr('data-old', gplResult['csfc'][cell]).html( Globalize.format(gplResult['csfc'][cell], DECIMAL_POINT['n0']) );
                               }
                               for(var cell in gplResult['pmfc']){
                                      $gplPMcell.eq(cell).attr('data-old', gplResult['pmfc'][cell]).html( Globalize.format(gplResult['pmfc'][cell], DECIMAL_POINT['n0']) );
                               }
                               for(var cell in gplResult['dcfc']){
                                      $gplDCcell.eq(cell).attr('data-old', gplResult['dcfc'][cell]).html( Globalize.format(gplResult['dcfc'][cell], DECIMAL_POINT['n0']) );
                               }
                       }
               }
               var o_total={}, map_total={ 'csfc': {}, 'pmfc': {}, 'dcfc': {} }, $rRow=$rTable.find('tr:eq('+data['$row'].index()+')'), 
                       $totalCells=$rTable.find('tr:first td'), $csCells=$rRow.find('td'), $pmCells=$rRow.next().find('td'), $dcCells=$rRow.next().next().find('td');
                       
               $lTable.find('tr.mark.level2.'+data['v1']+'_level1').each(function(){
                       var $rRow=$rTable.find('tr:eq('+this.rowIndex+')'), $csCells=$rRow.find('td:gt('+(data['ftCell']-1)+')'),
                               $pmCells=$rRow.next().find('td:gt('+(data['ftCell']-1)+')'), $dcCells=$rRow.next().next().find('td:gt('+(data['ftCell']-1)+')');

                       setSumOfCells($csCells, 'csfc', map_total);
                       setSumOfCells($pmCells, 'pmfc', map_total);
                       setSumOfCells($dcCells, 'dcfc', map_total);
               });
               
               setTotalCells(map_total['csfc'], $csCells);   
               setTotalCells(map_total['pmfc'], $pmCells);   
               setTotalCells(map_total['dcfc'], $dcCells);   
               
               $lTable.find('tr.mark.level1').each(function(){
                       $rTable.find('tr:eq('+this.rowIndex+') td:gt('+(data['ftCell']-1)+')').each(function(){
                               o_total[this.cellIndex] = (getZeroOfNumber(o_total[this.cellIndex]) + Globalize.parseInt(this.innerHTML));
                       });
               });

               for(var o in o_total){
                       $totalCells.eq(o).html( Globalize.format(o_total[o], DECIMAL_POINT['n0']) );
               }
               
               callBackEnd(callBack, data);
        }, 150);
        
        ;function setSumOfCells($cells, strFC, map_total){
               $cells.each(function(){
                       var t=getZeroOfNumber(this.getAttribute('data-old'));
                       if(!map_total[strFC].hasOwnProperty(this.cellIndex)){
                               map_total[strFC][this.cellIndex] = 0;
                       }
                       map_total[strFC][this.cellIndex] += t;
               });
        }
        
        ;function setTotalCells(map_fc, $cells){
               for(var key in map_fc){
                       $cells.eq(key).attr('data-old', map_fc[key]).html( Globalize.format(map_fc[key], DECIMAL_POINT['n0']) );
               }
        }
        
        ;function appendPartElement(part, data, gplResult, $lRow, $rRow){
               
               var $plClone=data['$part_left_template'].clone(true), $prClone=data['$part_right_template'].clone(true);
                       
               $plClone.addClass( (part['gpl_uniqueid']+'_level2 '+part['id']+'_level3 '+data['v1']+'_level1 dn ') )
                       .eq(0).attr({'id': part['id'], 'title': part['snumber'], 'data-v1': data['v1'], 'data-v2': part['gpl_uniqueid'], 
                                              'data-familyname': data['familyname'], 'data-gplcode': part['gplcode'] })
                       .find('span.namecell').html(part['name']+'-[ '+part['snumber']+'] ');

               $prClone.addClass('dn rlevel3').eq(0).find('td').each(function(){
                       var mapRestPNFC=part['restPNFC'], mapCSFC=part['csFC'],
                               $this=$(this), $input=$this.find('input'), attr={ 'data-old': 0 , 'data-restpn': 0};
                       if(mapCSFC && mapCSFC.hasOwnProperty( data['cellMonth'][this.cellIndex] )){//CurrentsalesForecast
                               attr['data-old'] = (mapCSFC[data['cellMonth'][this.cellIndex]]); 
                               
                       }
                       if(mapRestPNFC && mapRestPNFC.hasOwnProperty( data['cellMonth'][this.cellIndex] )){//rest pn fc
                               attr['data-restpn'] = (mapRestPNFC[data['cellMonth'][this.cellIndex]]);    
                       }
                       if(!gplResult['csfc'].hasOwnProperty(this.cellIndex)){
                               gplResult['csfc'][this.cellIndex] = 0;
                       }
                       gplResult['csfc'][this.cellIndex] += attr['data-old'];
                       $this.attr(attr);
                       if($input.length == 0){ $this.html( Globalize.format(attr['data-old'], DECIMAL_POINT['n0']) ); }
                       else{ $input.val( Globalize.format(attr['data-old'], DECIMAL_POINT['n0']) ); }
               });
               
               setFieldValue($prClone.eq(1).find('td:gt('+(data['ftCell']-1)+')'), data, part['pmFC'], gplResult, 'pmfc');
               setFieldValue($prClone.eq(2).find('td:gt('+(data['ftCell']-1)+')'), data, part['dcFC'], gplResult, 'dcfc');
               
               $lRow.after($plClone);
               $rRow.after($prClone);
               
               var v1_v2 = (data['v1']+'_'+data['v2']);
               if(CATCH_DATA['level3'].hasOwnProperty(v1_v2)){
                       for(var i=0, oCatch; oCatch=CATCH_DATA['level3'][v1_v2][i]; i++){
                               if(oCatch['v3'] == item['id']){ 
                                      CATCH_DATA['level3'][v1_v2] = CATCH_DATA['level3'][v1_v2].delIndex(i);
                                      break;
                               }
                       }
               }
               
        }
        
        ;function setFieldValue($rCell, data, fc, gplResult, strFC){
               $rCell.each(function(){
                       var attr = { 'data-old': 0 };
                       if(fc && fc.hasOwnProperty( data['cellMonth'][this.cellIndex] )){
                               attr['data-old'] = (fc[(data['cellMonth'][this.cellIndex])]);    
                       }
                       if(gplResult && strFC){
                               if(!gplResult[strFC].hasOwnProperty(this.cellIndex)){
                                      gplResult[strFC][this.cellIndex] = 0;
                               }
                               gplResult[strFC][this.cellIndex] += attr['data-old'];
                       }
                       
                       $(this).attr(attr).html( Globalize.format(attr['data-old'], DECIMAL_POINT['n0']) );
               });
        }
        
}

;function appendElement_Level3(data, callBack, callBackEnd){

        asyncEachSeries_Original(data['list_result'], function(item, call){
               var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true),
                       gplCode=$.trim(data['$row'].attr('data-gplcode'));
               $lClone.addClass( (data['v2']+'_level2 '+item['id']+'_level3 '+data['v1']+'_level1') )
                               .eq(0).attr({'id': item['id'], 'data-v1': data['v1'], 'data-v2': data['v2'], 'title': item['snumber'],
                                                     'data-familyname': data['$row'].attr('data-familyname'), 'data-gplcode': gplCode })
                               .find('span.namecell').html(item['name']+'-['+item['snumber']+']');

               $rClone.addClass('rlevel3').eq(0).find('td').each(function(){
                       var mapRestPNFC=item['restPNFC'], mapCSFC=item['csFC'],
                               $this=$(this), $input=$this.find('input'), attr={ 'data-old': 0 , 'data-restpn': 0};
                       if(mapCSFC && mapCSFC.hasOwnProperty( data['cellMonth'][this.cellIndex] )){//CurrentsalesForecast
                               attr['data-old'] = (mapCSFC[data['cellMonth'][this.cellIndex]]); 
                       }
                       if(mapRestPNFC && mapRestPNFC.hasOwnProperty( data['cellMonth'][this.cellIndex] )){//rest pn fc
                               attr['data-restpn'] = (mapRestPNFC[data['cellMonth'][this.cellIndex]]);    
                       }
                       $this.attr(attr);
                       if($input.length == 0){ $this.html( Globalize.format(attr['data-old'], DECIMAL_POINT['n0']) ); }
                       else{ $input.val( Globalize.format(attr['data-old'], DECIMAL_POINT['n0']) ); }
               });
               
               setFieldValue($rClone.eq(1).find('td:gt('+(data['ftCell']-1)+')'), data, item['pmFC']);
               setFieldValue($rClone.eq(2).find('td:gt('+(data['ftCell']-1)+')'), data, item['dcFC']);

               data['$left'].after($lClone);
               data['$right'].after($rClone);
               
               var v1_v2 = (data['v1']+'_'+gplCode);
               if(CATCH_DATA['level3'].hasOwnProperty(v1_v2)){
                       for(var i=0, oCatch; oCatch=CATCH_DATA['level3'][v1_v2][i]; i++){
                               if(oCatch['v3'] == item['id']){ 
                                      CATCH_DATA['level3'][v1_v2] = CATCH_DATA['level3'][v1_v2].delIndex(i);
                                      break;
                               }
                       }
               }
               
        }, function(err){
               if(data['insert'] == 'search'){
                       var o_total={}, $lBody=data['$left'].parent(), $rBody=data['$right'].parent(), $totalCells=$rBody.find('tr:first td');
                       
                       setRowTotals(data, $lBody, $rBody, $rBody.find('tr:eq('+data['$row'].index()+')').find('td'), 
                                                             ('tr.level3.mark.'+data['v1']+'_level1.'+data['v2']+'_level2') );
                       setRowTotals(data, $lBody, $rBody, $rBody.find('tr:eq('+$lBody.find('tr.level1.mark.'+data['v1']+'_level1').index()+')').find('td'), 
                                                             ('tr.level2.mark.'+data['v1']+'_level1'));
                       
                       $lBody.find('tr.mark.level1').each(function(){
                               $rBody.find('tr:eq('+this.rowIndex+') td:gt('+(data['ftCell']-1)+')').each(function(){
                                      o_total[this.cellIndex] = (getZeroOfNumber(o_total[this.cellIndex]) + Globalize.parseInt(this.innerHTML));
                               });
                       });
               
                       for(var o in o_total){
                               $totalCells.eq(o).html( Globalize.format(o_total[o], DECIMAL_POINT['n0']) );
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
        
        
        ;function setRowTotals(data, $lBody, $rBody, $tds, cls){
               var cell_total={'csfc': {}, 'pmfc': {}, 'dcfc': {}}, $pmCells=$tds.parent().next().find('td'),
                       $dcCells=$tds.parent().next().next().find('td');
               $lBody.find(cls).each(function(){
                       $rBody.find('tr:eq('+this.rowIndex+')').find('td:gt('+(data['ftCell']-1)+')').each(function(){
                               var $this=$(this), $pmfc=$this.parent().next().find('td:eq('+this.cellIndex+')'),
                                       $dcfc=$this.parent().next().next().find('td:eq('+this.cellIndex+')'),
                                      cs=getZeroOfNumber(this.getAttribute('data-old')), pm=getZeroOfNumber($pmfc.attr('data-old')),
                                      dc=getZeroOfNumber($dcfc.attr('data-old'));
                               if(!cell_total['csfc'].hasOwnProperty(this.cellIndex)){
                                      cell_total['csfc'][this.cellIndex] = 0;
                               }
                               if(!cell_total['pmfc'].hasOwnProperty(this.cellIndex)){
                                      cell_total['pmfc'][this.cellIndex] = 0;
                               }
                               if(!cell_total['dcfc'].hasOwnProperty(this.cellIndex)){
                                      cell_total['dcfc'][this.cellIndex] = 0;
                               }
                               cell_total['csfc'][this.cellIndex] += cs;
                               cell_total['pmfc'][this.cellIndex] += pm;
                               cell_total['dcfc'][this.cellIndex] += dc;
                       });
               });
               for(var cell in cell_total['csfc']){
                       $tds.eq(cell).attr('data-old', cell_total['csfc'][cell]).html(Globalize.format(cell_total['csfc'][cell], DECIMAL_POINT['n0']));
               }
               for(var cell in cell_total['pmfc']){
                       $pmCells.eq(cell).attr('data-old', cell_total['pmfc'][cell]).html(Globalize.format(cell_total['pmfc'][cell], DECIMAL_POINT['n0']));
               }
               for(var cell in cell_total['dcfc']){
                       $dcCells.eq(cell).attr('data-old', cell_total['dcfc'][cell]).html(Globalize.format(cell_total['dcfc'][cell], DECIMAL_POINT['n0']));
               }
        }
        
}

;function appendElement_Level4(data, callBack, callBackEnd){
        var map_rest={};
        asyncEachSeries_Original(data['list_result'], function(item, call){
               var $lClone=data['$left_template'].clone(true), $rClone=data['$right_template'].clone(true);
               $lClone.addClass( (item['id']+'_level4 level4 '+data['v3']+'_level3 '+data['v2']+'_level2 '+data['v1']+'_level1') )
                               .eq(0).attr({'id': item['id'], 'title': item['name'], 'data-level': 'level4', 'data-v3': data['v3'], 'data-v2': data['v2'], 'data-v1': data['v1'],
                                                     'data-number': item['accnumber'], 'data-familyname': data['$row'].attr('data-familyname'), 'data-gplcode': data['$row'].attr('data-gplcode')})
                               .find('span.namecell').css({'width': '148px'}).html(item['accnumber']+'-[ '+item['name']+' ]');
        
        $lClone.eq(0).find('td:last').addClass('textcss').attr('data-iscft', item['hasCFTFC']);
               $rClone.addClass('rlevel4').eq(0).find('td').each(function(){
                       var attr = { 'data-nprice':0, 'data-nqty':0, 'data-price':0, 'data-qty': 0, 'data-old': 0 };
                       if(!map_rest.hasOwnProperty(this.cellIndex)){
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
                       map_rest[this.cellIndex] += attr['data-old'];
                       $(this).attr(attr).html( Globalize.format(attr['data-old'], DECIMAL_POINT['n0']) );
               });
               
               setFieldValue($rClone.eq(1).find('td:gt('+(data['ftCell']-1)+')'), data, item['pmFC']);
               setFieldValue($rClone.eq(2).find('td:gt('+(data['ftCell']-1)+')'), data, item['dcFC']);
               
               data['$left'].after($lClone);
               data['$right'].after($rClone);
               
               var v1_v2_3 = (data['v1']+'_'+data['$row'].attr('data-gplcode')+'_'+data['v3']);
               if(CATCH_DATA['level4'].hasOwnProperty(v1_v2_3)){
                       for(var i=0, oCatch; oCatch=CATCH_DATA['level4'][v1_v2_3][i]; i++){
                              if(oCatch['data-number'] == item['accnumber']){ 
                                      CATCH_DATA['level4'][v1_v2_3] = CATCH_DATA['level4'][v1_v2_3].delIndex(i);
                                      break;
                               }
                       }
               }
               
        }, function(err){
               
               if(data['insert'] == 'search'){
                       var $cells=data['$right'].parent().find('tr:eq('+data['$row'].index()+')').find('td');
                       for(var cell in map_rest){
                               var $cell=$cells.eq(cell), t=getZeroOfNumber($cell.attr('data-restpn')), rest=t-map_rest[cell];
                               if(rest < 0){
                                      rest = (-rest);
                                      $cell.find('input').val( Globalize.format(rest, DECIMAL_POINT['n0']) );
                               }
                               $cell.attr('data-restpn', rest);
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

;function createCheckRest_RemoteAction(list_save, oemId, cellMonth, $pBar, $rBody){
        var pBarConfg=getBarConfg(list_save), $lBody=$('#ltabid'), managerId=$('#hidd_manager').val();
        setProgressBarStatus(pBarConfg, list_save.length, $pBar);
        
        for(var i=0, item; item=list_save[i]; i++){
               var o={'action': checkPartRest_js, 'complete': complete_saveSObject,
                       'json': '{}', 'pct': pBarConfg['pct'], 'max': pBarConfg['max'], 'cellMonth': cellMonth,
                       '$pBar': $pBar, '$lRow': $(item), '$rRow': $rBody.find('tr:eq('+item.rowIndex+')')};
               createPart_JSON(o, managerId);
        }
        
        ;function createPart_JSON(o, managerId){
               var json={'gplfamily': o['$lRow'].attr('data-familyname'), 'managerId': managerId, 'oemId': oemId, 'partId': o['$lRow'].attr('id'), 'set_selectedId': []};
                $lBody.find('tr.level4.mark.'+json['partId']+'_level3.'+o['$lRow'].attr('data-v2')+'_level2.'+o['$lRow'].attr('data-v1')+'_level1').each(function(){
                       json['set_selectedId'].push(this.getAttribute('data-number'));
               });
               o['json'] = JSON.stringify(json);
               o['name'] = o['$lRow'].find('span.namecell').text();
               customRemoteAction(o, o['action'], o['complete']);
        }
        
}

;function createDelObjectList(oemId){
        var list_del = [];
        
        for(var level in CATCH_DATA['DEL2']){
               var o=CATCH_DATA['DEL2'][level],
                       t={'cls': (o['isnon'] ? WORK_CLS['level4'] : WORK_CLS['level2']), 'action': deleteCSDObject_js, 'complete': complete_deleteObject, 
                                      'json': {'isExpansionSoldto': true, 'accnumber': o['data-number'], 'soldtoId': o['v2'], 'gplfamily': o['family'], 'gplcode': o['gc'], 'oemId': oemId}
                               };
               list_del.push(t);
        }
        
        for(var level in CATCH_DATA['DEL3']){
               var o=CATCH_DATA['DEL3'][level],
                       t={'cls': WORK_CLS['level3'], 'action': deleteCSDObject_js, 'complete': complete_deleteObject, 
                                      'json': {'partId': o['v3'], 'gplfamily': o['family'], 'gplcode': o['gplcode'], 'oemId': oemId}
                               };
               list_del.push(t);
        }
        
        for(var level in CATCH_DATA['DEL4']){
               var o=CATCH_DATA['DEL4'][level],
                       t={'cls': WORK_CLS['level4'], 'action': deleteCSDObject_js, 'complete': complete_deleteObject, 
                                      'json': {'isExpansionSoldto': false, 'accnumber': o['data-number'], 'partId': o['v3'], 'soldtoId': o['v2'], 'gplfamily': o['family'], 'gplcode': o['gplcode'], 'oemId': oemId}
                               };
               list_del.push(t);
        }

        /*
        for(var level in CATCH_DATA['level2']){
               var list_t=CATCH_DATA['level2'][level];
               
               for(var i=0, o; o=list_t[i]; i++){
                       var t={'cls': (o['isnon'] ? WORK_CLS['level4'] : WORK_CLS['level2']), 'action': deleteCSDObject_js, 'complete': complete_deleteObject, 
                                      'json': {'isExpansionSoldto': true, 'accnumber': o['data-number'], 'soldtoId': o['v2'], 'gplfamily': o['family'], 'gplcode': o['gplcode'], 'oemId': oemId}
                               };
                       list_del.push(t);
               }
               
        }
        for(var level in CATCH_DATA['level3']){
               var list_t=CATCH_DATA['level3'][level];
               for(var i=0, o; o=list_t[i]; i++){
                       var t={'cls': WORK_CLS['level3'], 'action': deleteCSDObject_js, 'complete': complete_deleteObject, 
                                      'json': {'partId': o['v3'], 'gplfamily': o['family'], 'gplcode': o['gplcode'], 'oemId': oemId}
                               };
                       list_del.push(t);
               }
               
        }
        for(var level in CATCH_DATA['level4']){
               var list_t=CATCH_DATA['level4'][level];
               for(var i=0, o; o=list_t[i]; i++){
                       var t={'cls': WORK_CLS['level4'], 'action': deleteCSDObject_js, 'complete': complete_deleteObject, 
                                      'json': {'isExpansionSoldto': false, 'accnumber': o['data-number'], 'soldtoId': o['v4'], 'partId': o['v3'], 'gplfamily': o['family'], 'gplcode': o['gplcode'], 'oemId': oemId}
                               };
                       list_del.push(t);
               }
               
        }
        */
        return list_del;
}

;function createLevel4_RemoteAction(list_save, oemId, cellMonth, $pBar, $rBody){
        var pBarConfg=getBarConfg(list_save), managerId=$('#hidd_manager').val();
        setProgressBarStatus(pBarConfg, list_save.length, $pBar);
        for(var i=0, item; item=list_save[i]; i++){
               var o={'cls': WORK_CLS['level4'], 'action': saveCSDsObject_js, 'complete': complete_saveSObject,
                       'json': '{}', 'pct': pBarConfg['pct'], 'max': pBarConfg['max'], 'cellMonth': cellMonth,
                       '$pBar': $pBar, '$lRow': $(item), '$rRow': $rBody.find('tr:eq('+item.rowIndex+')')};
               createPart_SoldTo_JSON(o, oemId, managerId);
        }
        
        ;function createPart_SoldTo_JSON(o, oemId, managerId){
               var json = {'soldToId': o['$lRow'].attr('id'), 'partId': o['$lRow'].attr('data-v3'), 'gplcode': o['$lRow'].attr('data-gplcode'), 'managerId': managerId, 
                                      'name': o['$lRow'].attr('title'), 'accnumber': o['$lRow'].attr('data-number'), 'gplfamily': o['$lRow'].attr('data-familyname'), 'oemId': oemId, 'csFC': {}};

               for(cell in o['cellMonth']){
                       var $td = o['$rRow'].find('td:eq('+cell+')'), amount=Globalize.parseInt( $.trim($td.text()) ),
                               oFc = {'price': $td.attr('data-nprice'), 'quantity': $td.attr('data-nqty'), 'forecast': amount},
                               key = (o['cellMonth'][cell]);
                       json['csFC'][key] = oFc;
               }

               o['json'] = JSON.stringify(json);
               o['name'] = o['$lRow'].find('span.namecell').text();
               customMultipleRemoteAction(o, o['action'], o['complete']);
        }
        
}
;function createLevel3_RemoteAction(list_save, oemId, cellMonth, $pBar, $rBody){
        var pBarConfg=getBarConfg(list_save), managerId=$('#hidd_manager').val();
        setProgressBarStatus(pBarConfg, list_save.length, $pBar);
        
        for(var i=0, item; item=list_save[i]; i++){
               var o={'cls': WORK_CLS['level3'], 'action': saveCSDsObject_js, 'complete': complete_saveSObject,
                       'json': '{}', 'pct': pBarConfg['pct'], 'max': pBarConfg['max'], 'cellMonth': cellMonth,
                       '$pBar': $pBar, '$lRow': $(item), '$rRow': $rBody.find('tr:eq('+item.rowIndex+')')};
               createPart_JSON(o, oemId, managerId);
        }
        
        ;function createPart_JSON(o, oemId, managerId){
               var json = {'partId': o['$lRow'].attr('id'), 'gplcode': o['$lRow'].attr('data-gplcode'), 'managerId': managerId, 
                                      'gplfamily': o['$lRow'].attr('data-familyname'), 'oemId': oemId, 'csFC': {}};

               for(cell in o['cellMonth']){
                       var $td = o['$rRow'].find('td:eq('+cell+')'), amount=Globalize.parseInt( $.trim($td.find('input').val()) ),
                               oFc = {'restPNFC': getZeroOfNumber_Int($td.attr('data-restpn')), 'forecast': amount},
                               key = (o['cellMonth'][cell]);
                       json['csFC'][key] = oFc;
               }

               o['json'] = JSON.stringify(json);
               o['name'] = o['$lRow'].find('span.namecell').text();

               customMultipleRemoteAction(o, o['action'], o['complete']);
        }
}
;function createLevel2_RemoteAction(list_save, oemId, cellMonth, $pBar, $rBody){
        var pBarConfg=getBarConfg(list_save), managerId=$('#hidd_manager').val();
        setProgressBarStatus(pBarConfg, list_save.length, $pBar);
        
        for(var i=0, item; item=list_save[i]; i++){
               var o={'cls': WORK_CLS['level4'], 'action': saveCSDsObject_js, 'complete': complete_saveSObject,
                       'json': '{}', 'pct': pBarConfg['pct'], 'max': pBarConfg['max'], 'cellMonth': cellMonth,
                       '$pBar': $pBar, '$lRow': $(item), '$rRow': $rBody.find('tr:eq('+item.rowIndex+')')};
               createSoldTo_JSON(o, oemId, managerId);
        }
        
        ;function createSoldTo_JSON(o, oemId, managerId){
               var json = {'soldToId': o['$lRow'].attr('id'), 'name': o['$lRow'].attr('data-name'), 'accnumber': o['$lRow'].attr('data-number'), 
                                      'managerId': managerId, 'gplfamily': o['$lRow'].attr('data-familyname'), 'oemId': oemId, 'csFC': {}};

               for(cell in o['cellMonth']){
                       var $td = o['$rRow'].find('td:eq('+cell+')'), amount=Globalize.parseInt( $.trim($td.find('input').val()) ),
                               oFc = {'forecast': amount},
                               key = (o['cellMonth'][cell]);
                       json['csFC'][key] = oFc;
               }

               o['json'] = JSON.stringify(json);
               o['name'] = o['$lRow'].find('span.namecell').text();
               customMultipleRemoteAction(o, o['action'], o['complete']);
        }
}

;function complete_saveSamsungOEMLevel(result, event, data){
        if(event.status){
               $('#loading-curtain-div').hide();
        }else{
               var $restBox=$('#restsoldtobox').show();
               $restBox.find('div.restsoldmsg').html(event['message']).parent()
                       .find('input[type="button"].resavebtn').off('click').on('click', function(){
                               $restBox.hide();
                               customRemoteAction(data, data['action'], data['complete']);
                       });
        }
}

;function complete_checkSoldTo(result, event, data){

        if(event.status){
               var list_element=[], list_contens=[], $lBody=$('#ltabid');
               result = $.parseJSON(result);

               for(var i=0, r; r=result[i]; i++){
                       var $soldto=$lBody.find('tr[data-number="'+r+'"].prot.level2.'+data['data']['v1']+'_level1');
                       if($soldto.length != 0){
                               list_element.push($soldto);
                               list_contens.push(r);
                       }
               }

               if(list_element.length == 0){
                       appendElemnt_checkResult(data['data']);
                   return;
               }
               
               var content=('Please be aware that all Sold tos relate to the parts you would like to add have already been individually picked out for forecasting, '+
                                              'forecasts for layer 2 Sold to ['+list_contens.join(', ')+'] will be deleted.');
               art.dialog({
                title:' ', lock:true, dblclick_hide:false, esc:false, id: 'countsid', content: content,
                button : [ {value: 'Ok', focus: true, callback: function(){ 
                                              while(list_element.length > 0){
                                                      list_element.shift().find('span.del_img input').click();
                                              }
                                              appendElemnt_checkResult(data['data']); }
                                      },
                                       {value: 'Cancel', callback: function(){ 
                                                      $('#popup_loading').hide();
                                              }
                                       } 
                ]
            });
    }else{
        $('#popup_loading').html(event['message']);
    }
    $('#searchtabid').removeAttr('style');
    data['data']['$inputs'].removeAttr('disabled');
    
    
    
        ;function appendElemnt_checkResult(data){
               QUEUE.push({name: data['data-level'], run: function(cb){
                       setTemplateElement(data);
                       data['call'](data, cb, callBackEnd);
               }}, function(err){ });
               
        }
        ;function callBackEnd(_callBack, _data){
               event_closePopUP_click(null);
               _data['$inputs'].removeAttr('disabled');
               $('#searchtabid').removeAttr('style');
               $('#popup_loading').hide();
               _callBack(null);
        }

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

               var html=(data['aspLabel']+'<input value="'+Globalize.format(getZeroOfNumber(result), DECIMAL_POINT['n4'])+' USD" data-asp="'+result+'" onclick="event_aspData_click(event, this)" type="button" class="btn popeditbtn" />');
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
               var $status_cell=data['$billing'].find('td:first b.ref_box[data-months="'+data['smonths']+'"]').eq(0);
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
                                      statisticalPercent(map_percent, data, $billing.find('td'), data['$rbody'].find('tr:eq('+data['$statistical'].index()+') td'));
                               }
                       });
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
    }
    /*HELP methods*/
}
;function complete_refDataBacklog(result, event, data){
        
        QUEUE.push({name: data['level'], run: function(cb){
               var $status_cell=data['$backlog'].find('td:first b.ref_box[data-months="'+data['smonths']+'"]').eq(0);
               if(event.status){
                       result = $.parseJSON(result);
                       var $backlog=data['$rbody'].find('tr:eq('+data['$backlog'].index()+')'), backlog=result['map_backlogrefdata'];
                       $status_cell.attr('data-status', 'true').animate({backgroundColor: '#51C957'}, 130, function(){
                               $status_cell.remove();
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
                                              customMultipleRemoteAction(data, data['actionBacklog'], data['completeBacklog']);
                                      });
    }
    /*HELP methods*/
}

;function complete_refDataBacklog1(result, event, data){
        QUEUE.push({name: 'backlog', run: function(cb){
               var $td=$('#edit_left_tbody span.leftbacklog').parent();
               if(event.status){
               //      data['$row'].attr({'data-backlog': result});
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
;function complete_saveSObject(result, event, data){ //complete remoteaction result
    
    QUEUE.push({name: (data['$pBar'].progressbar("value") || 0), run: function(cb){
               var isError = false, $pError=$('#progresserror');
               if(event.status){
                       isError=false;
  
                       if(($pError.attr('data-check') == 'start' && result == 'false' && data['$rRow'].find('td.td_input[data-restpn!="0"]').length != 0)){
  
  isError=true;
                       data['msg'] = {
                                      'message': 'Please be aware that all sold to relate to this part have been picked out and the amount of forecast you enter at part level does not equal to the total amount you enter at the sold to level'    
                       };
                              SAVE_ERRORS.push(data);
                       }
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
        //      cb(null);
    }}, function(err){ });

    ;function progressStatusText(_id){
        $(_id).html(function(){
                       var t = parseInt($.trim(this.innerHTML), 10);
                       return ($.isNumeric(t) ? (t+1) : 0);
               });
    }
}
;function complete_searchObject(result, event, data){ //complete remoteaction result
        if(event.status){
            var $tBody=$('#popupbody'), $trs=$( ('#'+data['$btn'].attr('data-tabid')+'_tab') ).clone().removeAttr('id');

            result = $.parseJSON(result);
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
                       $('#boxheadid').css({'width': ($('#boxbodyid').width()-scrollbarW)});
            }, 60);
           
    }else{ 
        data['$loading'].html(event['message']);
        data['$inputs'].removeAttr('disabled');
    }
    $('#searchtabid').removeAttr('style');
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

;function complete_existResult(result, event, data){
        QUEUE.push({name: data['rowIndex'], run: function(cb){
               if(event.status){
                       complete_remoteResultCheck(result, data, cb, data['appendElement'], complete_appendElementEND);
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
if (_data['data-level'] === 'level4') { 
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
               e['data'].$aBox.addClass('w-drop-unselect');
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
               e['data'].$aBox.removeClass('w-drop-unselect');
               $this.off('mousemove mouseup');
               $(e['data'].elDrop).removeAttr('style');
    });
}

;function event_input_change(e){
        var _this=this, $this=$(_this), $td=$this.parent(), $tr=$td.parent(), $rBody=$tr.parent(), ov='', point=DECIMAL_POINT['n0'], 
               level=_this.getAttribute('data-type'), validation_qty=/^([1-9]\d{0,16}|0)(\.\d+)?$/, tv=Globalize.parseFloat($.trim(_this.value)); //focus Event
    
ov = $this.inputFocusValueFormat(validation_qty, e);
    if(e.type == 'change'){
        ov = ($.isNumeric(ov) ? ov : 0);
        tv = ($.isNumeric(tv) ? tv : 0);
               
        if((tv+'').length > 18){
               $this.val(Globalize.format(ov, point));
               return;
        }
        
        var restPn=getZeroOfNumber_Int($td.attr('data-restpn')), $lPart=$('#ltabid tr:eq('+$tr.index()+')'), 
               $lBody=$lPart.parent(), cellIndx=$td[0].cellIndex, soldToTotal=0;
restCal = tv-ov;
console.log(tv-ov)
        
        if(level == 'level3' && !$lPart.hasClass('done') && tv < restPn){
               $this.val(Globalize.format(ov, point));
               return;
        }
        switch(level){
               case 'level3':
                       $lBody.find('tr.mark.level4.'+$lPart.attr('id')+'_level3.'+$lPart.attr('data-v2')+'_level2.'+$lPart.attr('data-v1')+'_level1').each(function(){
                              var t=Globalize.parseInt( $.trim($rBody.find('tr:eq('+this.rowIndex+')').find('td:eq('+cellIndx+')').text()) );
                              soldToTotal += t ? t : 0;
 
                       });
                       break;
        }

               if(level == 'level3' && (tv-soldToTotal) < 0){
                       $this.val(Globalize.format(ov, point));
                       return;
               }
               if(level == 'level3'){
  if (self.isInputBoxChangeTriggeredManually) {
  self.isInputBoxChangeTriggeredManually = false;
  
  } 
 else {
  //                     $td.attr('data-restpn', tv-ov+restPn);
 $td.attr('data-restpn', tv-soldToTotal); // $td.attr('data-restpn', tv-ov);
  }
               }
               
               $this.val(Globalize.format(tv, point));
               if(level == 'level3'){
                       sumOfGplCode(tv, ov, cellIndx, $lPart, $lBody);
               }
               sumOfFamily(cellIndx, level, $lPart, $lBody);
               sumOfTotal(cellIndx, $lBody, $rBody);
    }
    
    if(e.keyCode == 13){
        $td.next().find('input').focus().select();
    }
    
    ;function sumOfGplCode(newVal, oldVal, cellIndx, $lPart, $lBody){
        var idx=$lBody.find('tr.mark.level2.'+$lPart.attr('data-v2')+'_level2.'+$lPart.attr('data-v1')+'_level1').index();
        $rBody.find('tr:eq('+idx+')').find('td:eq('+cellIndx+')').html(function(){
               var v=Globalize.parseInt($.trim(this.innerHTML));
  //return Globalize.format((v-oldVal+newVal), point);
               return Globalize.format((newVal), point);
  
        });
    }
    
    ;function sumOfFamily(cellIndx, level, $lPart, $lBody){
        var $family=$lBody.find('tr.mark.level1.'+$lPart.attr('data-v1')+'_level1'),
               $familyCell=$rBody.find('tr:eq('+$family.index()+')'), gplCodeTotal=0,
          familyTotal=Globalize.parseInt($.trim($familyCell.find('td:eq('+cellIndx+')').text()));

        $lBody.find('tr.mark.level2.'+$lPart.attr('data-v1')+'_level1').each(function(){
               var $gplCell=$rBody.find('tr:eq('+this.rowIndex+')').find('td:eq('+cellIndx+')'), $input=$gplCell.find('input'),
                       v=Globalize.parseInt($.trim($gplCell.text()));

               v = ($input.length == 0 ? v : Globalize.parseInt($.trim($input.val())));
               gplCodeTotal += v;
        });
        if(level == 'level2' && !$family.hasClass('done')){
               gplCodeTotal += familyTotal;
        }
               $familyCell.find('td:eq('+cellIndx+')').html( Globalize.format(gplCodeTotal, point) );
    }
    
    ;function sumOfTotal(cellIndx, $lBody, $rBody){
        var total=0, $totalCell=$rBody.find('tr:first td:eq('+cellIndx+')');
        $lBody.find('tr.mark.level1').each(function(){
               var t=$rBody.find('tr:eq('+this.rowIndex+') td:eq('+cellIndx+')').html();
               total += Globalize.parseInt(t);
        });
        $totalCell.html( Globalize.format(total, point) );
    }
}

;function event_soldToInput_change(e){
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
       
/*if($crt.html() == "0"){
$.trim($crt.html("0"));
}*/
        var $body=$('#edit_right_tbody'), $unknown=$body.find('tr.'+(type=='qty'?'pricecls': 'qtycls')+' td:eq('+$td[0].cellIndex+')'), 
               $crt=$body.find('tr.curtcls td:eq('+$td[0].cellIndex+')'), crt=Globalize.parseInt( $.trim($crt.html())),
               $rest=$body.find('tr.restcls td:eq('+$td[0].cellIndex+')'), rest=getZeroOfNumber_Int( $.trim($rest.attr('data-min')) ),
               unknownVal=$.trim($unknown.find('input').val()), total=0;

// console.log(crt)
if(isNaN(crt)){
crt = 0;
}
        unknownVal = Globalize.parseFloat(unknownVal);
        total = Math.round(tv*unknownVal);
        rest += crt;
          /* Comment start by Cap Team to remove existing validation on Part level */ 
          //if(total <= rest){
/* Comment end by Cap Team to remove existing validation on Part level */ 
self.partInfoChangeArray.push($(e.currentTarget).parent()[0].cellIndex);
               $rest.attr('data-min', (rest-total)).html( Globalize.format((rest-total), DECIMAL_POINT['n0']) );
               $crt.html(Globalize.format(total, DECIMAL_POINT['n0']));
               $this.val( Globalize.format(tv, point) ).removeAttr('style');
               $unknown.find('input').removeAttr('style');
   
//crt= $.trim($crt.html("012"));
               return;
  /* Comment start by Cap Team to remove existing validation on Part level */
        //}
       // $this.val( Globalize.format(ov, point) ).css('border-bottom', '5px solid red');
  /* Comment end by Cap Team to remove existing validation on Part level */ 
    }
    
    if(e.keyCode == 13){
        $td.next().find('input').focus().select();
    }
}

;function event_aspData_click(event, target){
        var $this=$(target), $trs=$('#edit_right_tbody tr'), $priceCell=$trs.filter('.pricecls').find('input'),
               $qtyCell=$trs.filter('.qtycls').find('td'), $restCell=$trs.filter('.restcls').find('td'),
               $curtCell=$trs.filter('.curtcls').find('td'), aspVal=getZeroOfNumber($this.attr('data-asp'));
        
        $priceCell.each(function(){
               var $price=$(this), $this=$price.parent(), cellIdx=$this[0].cellIndex, $rest=$restCell.eq(cellIdx), 
                       qty=Globalize.parseInt( $.trim($qtyCell.eq(cellIdx).find('input[type="text"]').val()) ),
                       crt=Globalize.parseInt( $.trim($curtCell.eq(cellIdx).text()) ),
                       rest=getZeroOfNumber_Int( $.trim($rest.attr('data-min')) ), total=Math.round(qty*aspVal);
               rest += crt;
               if(total <= rest){ 
                       $rest.attr('data-min', (rest-total));
                       $price.val(Globalize.format(aspVal, DECIMAL_POINT['n4'])).removeAttr('style');
                       $curtCell.eq(cellIdx).html(Globalize.format(total, DECIMAL_POINT['n0']));
                       $rest.attr('data-min', (rest-total)).html( Globalize.format((rest-total), DECIMAL_POINT['n0']) );
               }else{
                       $price.css('border-bottom', '5px solid red');
               }
        });
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

;function event_searchTab_click(event, target){
        var $this=$(target), $parent=$this.parent(), $searchBtn=$('#searchbtn'),
               excute = {'isActive': !$this.hasClass('inactive'), 'fn': ($this.attr('data-type')=='part'? partTab : soldToTab )};
        if(excute['isActive']){
               return false;
        }

        $('#popuphead input[type="checkbox"]').off('click');
        excute['fn']();
        $parent.find('span:not(.inactive)').addClass('inactive');
        $this.removeClass('inactive');
        $('#popupbody').empty();
    $('#popuphead input[type="checkbox"]').on('click', event_checkBox_click);
    
        ;function partTab(){
               $('#popuphead').empty().append($('#level1_tab td').clone()); 
               $searchBtn.attr({'data-gplcode': '', 'data-isexpan': false, 'data-cls': WORK_CLS['level2'], 'data-tabid': 'level1'});
        }
        
        ;function soldToTab(){
               $('#popuphead').empty().append($('#level3_tab td').clone()); 
               $searchBtn.attr({'data-gplcode': '', 'data-isexpan': true, 'data-cls': WORK_CLS['level4'], 'data-tabid': 'level3'});
        }
        
}

;function event_refData_click(e){
        e.stopPropagation();
        if($(this).hasClass('watingpin')){
               return;
        }
        var $this=$(this), $td=$this.parent().parent().parent(), $tr=$td.parent(), $statistical=$tr.next().next().next(),
               $billing=$statistical.next(), $booking=$billing.next(), $backlog=$booking.next(), execute=($this.hasClass('spin')? exp : col),
               attr={ 'findcls': '', 'json' : {}, 'cls': '', 'monthCell': {}, 'cellMonth': {}, '$pin': $this, '$row': $tr, 'crtCell': $('#tab_head_list td.currentcls')[0].cellIndex, 
                       'level': $tr.attr('data-level'), 'oemid': $('#hidd_samsungid').val(), 'managerid': $('#hidd_manager').val(),
                       'id': $tr.attr('id'), 'v1': $tr.attr('data-v1'), 'v2': $tr.attr('data-v2'), 'v3': $tr.attr('data-v3'),
                       '$lbody': $tr.parent(), '$rbody': $('#rtabid'), 'isExpansionSoldto': false, '$booking': $booking,
                       '$statistical' : $statistical, '$billing': $billing, '$backlog': $backlog, 'actionBacklog': getBacklogRefData_js,
                       'data-number': $tr.attr('data-number'), 'action' : getRefData_js, 'complete' : complete_refData, 'completeBacklog': complete_refDataBacklog
                       };
               
        event_windowScroll();
        switch(attr['level']){
               case 'level1':
                       attr['gplfamily'] = $.trim($tr.find('span.namecell').text());
                       attr['findcls'] = 'tr:not(.mark).level1.'+attr['id']+'_level1';
                       attr['cls'] = WORK_CLS['level1'];
                       break;
               case 'level2':
                       attr['gplfamily'] = $tr.attr('data-familyname');
                       attr['gplcode'] = $tr.attr('data-gplcode');
                       attr['isExpansionSoldto'] = $tr.hasClass('prot');
                       attr['findcls'] = 'tr:not(.mark).level2.'+attr['id']+'_level2.'+attr['v1']+'_level1';
                       attr['cls'] = WORK_CLS['level2'];
                       break;
               case 'level3':
                       attr['gplfamily'] = $tr.attr('data-familyname');
                       attr['gplcode'] = $tr.attr('data-gplcode');
                       attr['partid'] = attr['id'];
                       attr['findcls'] = 'tr:not(.mark).level3.'+attr['id']+'_level3.'+attr['v2']+'_level2.'+attr['v1']+'_level1';
                       attr['cls'] = WORK_CLS['level3'];
                       break;
               case 'level4':
                       attr['gplfamily'] = $tr.attr('data-familyname');
                       attr['gplcode'] = $tr.attr('data-gplcode');
                       attr['partid'] = attr['v3'];
                       attr['soldtoid'] = attr['id'];
                       attr['findcls'] = 'tr:not(.mark).level4.'+attr['id']+'_level4.'+attr['v3']+'_level3.'+attr['v2']+'_level2.'+attr['v1']+'_level1';
                       attr['cls'] = WORK_CLS['level4'];
                       break;
        }

        execute();
        
        
        /* START Help function */
        ;function exp(){
               
               if(!$this.hasClass('refdata')){
                       $this.addClass('refdata');
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
                       attr_tmp['json'] = {'set_fiscalMonth': list_q, 'oemId': attr_tmp['oemid'], 'gplfamily': attr_tmp['gplfamily'], 
                                                             'managerId': attr_tmp['managerid'], 'isExpansionSoldto': attr_tmp['isExpansionSoldto'], 'gplcode': attr_tmp['gplcode'], 
                                                             'partId': attr_tmp['partid'], 'soldtoId': attr_tmp['soldtoid'], 'accnumber': attr_tmp['data-number']};
                                                             
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
                       attr_tmp['json'] = {'set_fiscalMonth': list_q, 'oemId': attr_tmp['oemid'], 'gplfamily': attr_tmp['gplfamily'], 
                                                             'managerId': attr_tmp['managerid'], 'isExpansionSoldto': attr_tmp['isExpansionSoldto'], 'gplcode': attr_tmp['gplcode'], 
                                                             'partId': attr_tmp['partid'], 'soldtoId': attr_tmp['soldtoid'], 'accnumber': attr_tmp['data-number']};
                                                             
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
        /*
        ;function executeRemote(){
               var list_months=[];
               
               createRefStatus(list_months, attr['$billing']);
               list_months=[]; //clear first months.
               createRefStatus(list_months, attr['$backlog']);
               
               asyncEachSeries_Original(list_months, function(list_item, callback){
                       var attr_tmp=$.extend({}, attr), list_q=[];
                       for(var i=0, result; result=list_item[i]; i++){
                               list_q.push(result);
                       }
                       attr_tmp['smonths'] = list_q.join(',');
                       attr_tmp['json'] = {'set_fiscalMonth': list_q, 'oemId': attr_tmp['oemid'], 'gplfamily': attr_tmp['gplfamily'], 
                                                             'managerId': attr_tmp['managerid'], 'isExpansionSoldto': attr_tmp['isExpansionSoldto'], 'gplcode': attr_tmp['gplcode'], 
                                                             'partId': attr_tmp['partid'], 'soldtoId': attr_tmp['soldtoid'], 'accnumber': attr_tmp['data-number']};
                                                             
                       attr_tmp['json'] = JSON.stringify(attr_tmp['json']);
                       customMultipleRemoteAction(attr_tmp, attr_tmp['action'], attr_tmp['complete']); //this is remote action
                       customMultipleRemoteAction(attr_tmp, attr_tmp['actionBacklog'], attr_tmp['completeBacklog']); //this is remote action

               }, function(err){}, 120);
               
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
        
        var $this=$(this), $inputs=$this.parent().find('input').attr({'disabled': true}),
               $trs=$('#edit_right_tbody tr'), $crtCell=$trs.filter('.curtcls').find('td:not(:first)'),
               $qtyCell=$trs.filter('.qtycls').find('td:not(:first)'), $priceCell=$trs.filter('.pricecls').find('td:not(:first)'),
               $restCell=$trs.filter('.restcls').find('td:not(:first)'), dataJson=$.parseJSON($this.attr('data-json')), 
               cCell=$('#tab_head_list td.currentcls')[0].cellIndex,
               partcls='#ltabid tr.mark.level4.'+dataJson['v4']+'_level4.'+dataJson['v3']+'_level3.'+dataJson['v2']+'_level2.'+dataJson['v1']+'_level1',
               restcls='#ltabid tr.mark.level3.'+dataJson['v3']+'_level3.'+dataJson['v2']+'_level2.'+dataJson['v1']+'_level1',
               $oemRest=$('#rtabid tr:eq('+$(restcls).index()+')').find('td:gt('+cCell+')'),
               $partCell=$('#rtabid tr:eq('+$(partcls).index()+')').find('td:gt('+cCell+')');
               
/* comment start by CapTeam for "Copy OEM Backlog" btn checkbox functionality */
// $AllBacklogs=$trs.filter('.OEMBacklogChkCls').find('input');
         $partCell.each(function(idx){
               var _this=this, $this=$(_this), qty=$.trim($qtyCell.eq(idx).find('input').val()),
                       price=$.trim($priceCell.eq(idx).find('input').val()), crtVal=$.trim($crtCell.eq(idx).text()),
                       //rest=getZeroOfNumber_Int($restCell.eq(idx).attr('data-min'));
                       rest=0;
               //$AllBacklogs.each(function(idx2)
 // { 
//  if(idx==idx2 )
//  {
                   qty=Globalize.parseInt(qty);
                   price=Globalize.parseFloat(price);
                   $this.text(crtVal).attr({'data-nprice': price, 'data-nqty': qty});
                   $oemRest.eq(idx).attr('data-restpn', rest);
 // }
//});
      });
 /* comment end by CapTeam for "Copy OEM Backlog" btn checkbox functionality */
        event_closePartPopupBox_click(null, null);
        $inputs.attr({'disabled': false});
		//isdelsoldto=true;
        addPartTotalRow();
		
}

;function event_saveSamSungForecast_click(target){
        
        $('#savestepid').parent().remove();
        SAVE_ERRORS = [];
        if(checkingStatus()){
               artDialogBox('Please waiting for load data.');
               return false;
        }
        
        var oemId=$('#hidd_samsungid').val(), $pBar=$("#progressbar").attr('data-value', 0).progressbar({ value: false }),
               cellMonth={}, $pError=$('#progresserror').attr({'data-v4': 'unknown', 'data-v3': 'unknown', 'data-v2': 'unknown', 'data-v5': 'unknown', 'data-check': 'unknown'}),
               $pStatus=$('#progressstatusid').html(' '), $lBody=$('#ltabid'), $rBody=$('#rtabid'), list_save=createDelObjectList(oemId);
        
        console.log(list_save);
        $('#tab_head_list td.futurecls').each(function(){
               cellMonth[this.cellIndex] = this.getAttribute('data-month');
        });            

        if(list_save.length == 0 && $lBody.find('tr.prot.mark.level2, tr.mark.level3, tr.mark.level4').length == 0){
               artDialogBox('Not found save data.');
               return;
        }       
        
        $('#tab_head_list td.futurecls').each(function(){
               cellMonth[this.cellIndex] = this.getAttribute('data-month');
        });     
        
        if(list_save.length != 0){
               $pStatus.html('Deleting records...');
               $pError.attr('data-v5', 'start');
               remoteActionDeleteObject(list_save, cellMonth, $pBar, $rBody);
               return;
        }
        
        $pStatus.html('Checking records...');
        list_save=$lBody.find('tr.mark.level3').toArray();
        if(list_save.length != 0){
               $pError.attr({'data-v5': 'done', 'data-check': 'start'});
               createCheckRest_RemoteAction(list_save, oemId, cellMonth, $pBar, $rBody);
               return;
        }
        
        $pStatus.html('Saving records...');
        list_save = $lBody.find('tr.mark.level4').toArray();
        if(list_save.length != 0){
               $pError.attr({'data-v5': 'done', 'data-check': 'done', 'data-v4': 'start'});
               createLevel4_RemoteAction(list_save, oemId, cellMonth, $pBar, $rBody);
               return;
        }
        
        list_save=$lBody.find('tr.mark.level3').toArray();
        if(list_save.length != 0){
               $pError.attr({'data-v3': 'start', 'data-v4': 'done', 'data-v5': 'done', 'data-check': 'done'});
               createLevel3_RemoteAction(list_save, oemId, cellMonth, $pBar, $rBody);
               return;
        }
        
        list_save=$lBody.find('tr.prot.mark.level2').toArray();
        if(list_save.length != 0){
               $pError.attr({'data-v2': 'start', 'data-v3': 'done', 'data-v4': 'done', 'data-v5': 'done', 'data-check': 'done'});
               createLevel2_RemoteAction(list_save, oemId, cellMonth, $pBar, $rBody);
               return;
        }

        /* START HELP method */
        
        /* END HELP method */
}

;function event_deleteObject_click(event, target){
        event = (event?event:window.event);
        event.cancelBubble = true;
        
        QUEUE.push({name: 'deleteObject', run: function(cb){
        deleteObject(target, cb);
    }}, function(err){ });
        
    /* HELP function*/
    ;function deleteObject(target, cb){
        
               var filterCls='', $rBody=$('#rtabid'), $this=$(target), 
                       $tr=$this.parent().parent().parent().parent().parent(), level=$tr.attr('data-level'), id=$tr.attr('id'), 
                       remote_fn={'json': {}, '$row': $tr, '$btn': $this, '$rbody': $rBody, 'cellIndex': $('#tab_head_list td.currentcls')[0].cellIndex};

               $tr.off('click').find('span.search_img input[type="button"]').css({'visibility': 'hidden'}).find('span.fcell').html('+');
               $tr.find('td:last').off('click');
               $this.css({'visibility': 'hidden'}).parent().addClass('wating').find('span.del_msg').remove();
                switch(level){
                       case 'level2' :
                               remote_fn['cls'] = WORK_CLS['level2'];
                               filterCls = 'tr.'+id+'_level2.'+$tr.attr('data-v1')+'_level1';
                               break;
                       case 'level3' :
                               remote_fn['cls'] = WORK_CLS['level3'];
                               filterCls = 'tr.'+id+'_level3.'+$tr.attr('data-v2')+'_level2.'+$tr.attr('data-v1')+'_level1';
                               break;
                       case 'level4' :
                               remote_fn['cls'] = WORK_CLS['level4'];
                               filterCls = 'tr.'+id+'_level4.'+$tr.attr('data-v3')+'_level3.'+$tr.attr('data-v2')+'_level2.'+$tr.attr('data-v1')+'_level1';
                               break;
               }
               remote_fn['filtercls'] = filterCls;
               $tr.parent().find(filterCls).each(function(){
                       if(this.rowIndex == $tr.index()){ return true; }
                       $rBody.find('tr:eq('+this.rowIndex+')').addClass('dn');
               $(this).addClass('dn').find('span.fcell').html('+').parent().find('span.pin').addClass('spin');
			   /** added by CapTeam to Remove Total SoldTo Sum Row for DNDP1**/
			 // var expandClickCurrentTarget = self.expandClickCurrentTarget,
				//expandClickCurrentTargetId = $(expandClickCurrentTarget).attr('id');
				//$('.row-static-total_' + expandClickCurrentTargetId).remove();
				//$('.row-static-total-right_' + expandClickCurrentTargetId).remove();
			   $('.row-static-total_' + id).addClass('dn');
               $('.row-static-total-right_' + id).addClass('dn');

			/** Ended by CapTeam to Remove Total SoldTo Sum Row for DNDP1**/
               });

               switch(level){
                       case 'level2' : deleteLevel2(remote_fn); break;
                       case 'level3' : deleteLevel3(remote_fn); break;
                       case 'level4' : deleteLevel4(remote_fn); break;
               }
               cb(null);
    }
    
    
    
    ;function deleteLevel2(data){

        var $l_body=data['$row'].parent(), v1=data['$row'].attr('data-v1'), v2=data['$row'].attr('id'),
               $fmRow=$l_body.find('tr.mark.level1.'+v1+'_level1'), $fmrRow=data['$rbody'].find('tr:eq('+$fmRow.index()+')'),
               $totalCells=data['$rbody'].find('tr:first td'), gplCode=data['$row'].find('span.namecell').text(),
               oc={'isnon': data['$row'].hasClass('prot'), 'data-number': data['$row'].attr('data-number'), 
                       'family':data['$row'].attr('data-familyname'), 'gplcode': gplCode, 'v1': v1, 'v2': v2, 'gc': data['$row'].attr('data-gplcode') };
               
        CATCH_DATA['DEL2'][oc['gplcode']]=oc;
                       
        if(!CATCH_DATA['level2'].hasOwnProperty(v1)){
                CATCH_DATA['level2'][v1]=[oc];
        }else{
               CATCH_DATA['level2'][v1].push(oc);
        }

        for(var level in CATCH_DATA['level3']){
               var list_t=level.split('_');
               if(list_t[0] == v1 && list_t[1] == gplCode){
                       delete CATCH_DATA['level3'][level];
               }
        }
               
        for(var level in CATCH_DATA['level4']){
               var list_t=level.split('_');
               if(list_t[0] == v1 && list_t[1] == gplCode){
                       delete CATCH_DATA['level4'][level];
               }
        }
        
     data['$rbody'].find('tr:eq('+data['$row'].index()+')').find('td:gt('+(data['cellIndex']-1)+')').each(function(){
               var $this=$(this), $input=$this.find('input'), $familyCell=$fmrRow.find('td:eq('+this.cellIndex+')'),
                       o=Globalize.parseInt($.trim($this.text())), t=Globalize.parseInt($.trim($familyCell.text()));
               
               o = ($input.length == 0 ? o : Globalize.parseInt($input.val()));            
                       $familyCell.html( Globalize.format(t-o, DECIMAL_POINT['n0']) );
                       $totalCells.eq(this.cellIndex).html(function(){
                               var ts=Globalize.parseInt(this.innerHTML);
                               return Globalize.format(ts-o, DECIMAL_POINT['n0']);
                       });
        });
        removeElement(data);
    }

    ;function deleteLevel3(data){
        var v1=data['$row'].attr('data-v1'), v2=data['$row'].attr('data-v2'), v3=data['$row'].attr('id'), 
               gplCode=data['$row'].attr('data-gplcode'), v1_v2=(v1+'_'+gplCode), o_total={},
               oc={'family': data['$row'].attr('data-familyname'), 'gplcode': gplCode, 'v1': v1, 'v2': v2, 'v3': v3},
               $l_body=data['$row'].parent(), $familyRow=$l_body.find('tr.mark.level1.'+v1+'_level1'),
               $gplCodeRow=$l_body.find('tr.mark.level2.'+v2+'_level2.'+v1+'_level1'),
               $gplRightRow=data['$rbody'].find('tr:eq('+$gplCodeRow.index()+')'), 
               $familyRightRow=data['$rbody'].find('tr:eq('+$familyRow.index()+')'),
               $totalCells=data['$rbody'].find('tr:first td');
               
        CATCH_DATA['DEL3'][v3]=oc;     
        
        if(!CATCH_DATA['level3'].hasOwnProperty(v1_v2)){
                CATCH_DATA['level3'][v1_v2]=[oc];
        }else{
               CATCH_DATA['level3'][v1_v2].push(oc);
        }       
        
        for(var level in CATCH_DATA['level4']){
               var list_t=level.split('_');
               if(list_t[0] == v1 && list_t[1] == gplCode && list_t[2] == v3){
                       delete CATCH_DATA['level4'][level];
               }
        }
        
     data['$rbody'].find('tr:eq('+data['$row'].index()+')').find('td:gt('+(data['cellIndex']-1)+')').each(function(){
               var $this=$(this), $input=$this.find('input'), $gplCell=$gplRightRow.find('td:eq('+this.cellIndex+')'),
                       $familyCell=$familyRightRow.find('td:eq('+this.cellIndex+')'),
                       part=Globalize.parseInt($.trim($this.text())), gpl=Globalize.parseInt($.trim($gplCell.text())),
                       f=Globalize.parseInt($.trim($familyCell.text()));

               part = ($input.length == 0 ? part : Globalize.parseInt($input.val()));
               $gplCell.html( Globalize.format((gpl-part), DECIMAL_POINT['n0']) );
               $familyCell.html( Globalize.format((f-part), DECIMAL_POINT['n0']) );
        });
        
        $l_body.find('tr.mark.level1').each(function(){
               data['$rbody'].find('tr:eq('+this.rowIndex+') td:gt('+(data['cellIndex']-1)+')').each(function(){
                       o_total[this.cellIndex] = (getZeroOfNumber(o_total[this.cellIndex]) + Globalize.parseInt(this.innerHTML));
               });
        });

        for(var o in o_total){
               $totalCells.eq(o).html( Globalize.format(o_total[o], DECIMAL_POINT['n0']) );
        }
        removeElement(data);
    }
    ;function deleteLevel4(data){
        var v1=data['$row'].attr('data-v1'), v2=data['$row'].attr('data-v2'), v3=data['$row'].attr('data-v3'), v4=data['$row'].attr('id'),
               gplCode=data['$row'].attr('data-gplcode'), v1_v2_v3=(v1+'_'+gplCode+'_'+v3), $l_body=data['$row'].parent(), 
                $pRow=$l_body.find('tr.mark.level3.'+v3+'_level3.'+v2+'_level2.'+v1+'_level1'),
               $prRow=data['$rbody'].find('tr:eq('+$pRow.index()+')'),
               oc={'family':data['$row'].attr('data-familyname'), 'data-number': data['$row'].attr('data-number'), 'gplcode': gplCode, 'v1': v1, 'v2': v2, 'v3': v3, 'v4': v4};
        
        CATCH_DATA['DEL4'][oc['data-number']]=oc;
        
        if(!CATCH_DATA['level4'].hasOwnProperty(v1_v2_v3)){
                CATCH_DATA['level4'][v1_v2_v3]=[oc];
        }else{
               CATCH_DATA['level4'][v1_v2_v3].push(oc);
        }       
        
     data['$rbody'].find('tr:eq('+data['$row'].index()+')').find('td:gt('+(data['cellIndex'])+')').each(function(){
               var $this=$(this), $partCell=$prRow.find('td:eq('+this.cellIndex+')'),
                       o=Globalize.parseInt($.trim($this.text())), t=getZeroOfNumber_Int($partCell.attr('data-restpn'));
                       $partCell.attr('data-restpn', (t+o));
        });
        removeElement(data);
    }
    
    ;function removeElement(data){
        data['$row'].parent().find(data['filtercls']).each(function(){
                       data['$rbody'].find('tr:eq('+this.rowIndex+')').remove();
                       $(this).remove();
					   isdelsoldto=true;
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

        var $this=$(this), $tr=$this.parent(), $lBody=$tr.parent(), $rBody=$('#rtabid'), isCFT=$this.attr('data-iscft'), asplabel = '', cftlabel='',
               $backLog=$tr.next().next().next().next().next().next(), $rbacklog=$rBody.find('tr:eq('+$backLog.index()+')'), 
               $leftTbody=$('#edit_left_tbody').empty(), $rightTbody=$('#edit_right_tbody').empty(),
               json={'soldtoId': $tr.attr('id'), 'partId': $tr.attr('data-v3'), 'startDate': $('#hidd_start').val(), 'oemId': $('#hidd_samsungid').val(),
                               'accnumber': $tr.attr('data-number'), 'endDate': $('#hidd_end').val(), 'map_year_monthsFuture': $.parseJSON($('#hidd_futuremonthmap').val())
                       },
               attr={'$td': $this, '$row': $tr, 'aspLabel': '<span style="line-height: 25px;">Reference ASP: </span>', 
              'action': getASP_js, 'complete': complete_aspData, 'cls': WORK_CLS['level4'], 'json': JSON.stringify(json)
                         },
               cftAttr={'cls': WORK_CLS['level4'], 'action': getCFTData_js, 'complete': complete_CFTData, 'json': JSON.stringify(json),
                               '$td': $this, '$row': $tr, 'cftLabel': '<span style="line-height: 25px;">CFTForecast </span>'},
               tmpJSON={'v1': $tr.attr('data-v1'), 'v2': $tr.attr('data-v2'), 'v3': $tr.attr('data-v3'), 'v4': $tr.attr('id')};


        if(!$this.hasClass('aspload') && !$this.hasClass('wait')){   //this check load asp data.
               $this.addClass('wait');
               asplabel = attr['aspLabel']+'<span class="aspcell wating">&nbsp;</span>';
               customMultipleRemoteAction(attr, attr['action'], attr['complete']);
        }else if($this.hasClass('wait')){
               asplabel = attr['aspLabel']+'<span class="aspcell wating">&nbsp;</span>';
        }else{
               var t= Globalize.format(parseFloat($this.attr('data-asp')), DECIMAL_POINT['n4']);
               asplabel = attr['aspLabel']+'<input value="'+t+' USD" data-asp="'+$this.attr('data-asp')+'" onclick="event_aspData_click(event, this)" type="button" class="btn popeditbtn" />';
        }
        
        if(isCFT == 'true' || isCFT == true){
               if(!$this.hasClass('cftload') && !$this.hasClass('waitcft')){ //this check load asp data.
                       $this.addClass('waitcft');
                       cftlabel = cftAttr['cftLabel']+'<span class="cftcell wating">&nbsp;</span>';
                       customMultipleRemoteAction(cftAttr, cftAttr['action'], cftAttr['complete']);
               }else if($this.hasClass('waitcft')){
                       cftlabel = cftAttr['cftLabel']+'<span class="cftcell wating">&nbsp;</span>';
               }else{
                       cftlabel = cftAttr['cftLabel']+'<input onclick="event_CFTData_click(event, this)" value="Copy CFT" type="button" class="btn cftbtncls popeditbtn" style="position: absolute;right: 2px;"/>';
               }
        }
        
        if(!$backLog.hasClass('loaded') && !$tr.hasClass('loadedbacklog')){
               
               var attr={ 'findcls': '', 'json' : $.extend({}, json), 'cls': WORK_CLS['level4'], 'monthCell': {}, 'cellMonth': {}, 
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
        
        
        $('#savefcbtn').attr({'data-json': JSON.stringify(tmpJSON)});
/* comment added by Cap team to show permanent message below save & close on part box */
  // $('#msg').hide();
/* comment added by Cap team to show permanent message below save & close on part box */
        $('#editBoxDiv').css({'width': '0%', 'display': ''}).animate({'width': '75%'}, 720, function(){
               $('#editleftth').css({'height': $('#edit_thead').height()-1.5});
        });
        $('#editboxtitle').html($tr.find('span.namecell').html());
        
        
        var $crtRow=$rBody.find('tr:eq('+$tr.index()+')').clone().removeClass('dn overbodybg'),
               $partRow=$lBody.find('tr.mark.level3.'+$tr.attr('data-v3')+'_level3.'+$tr.attr('data-v2')+'_level2.'+$tr.attr('data-v1')+'_level1'),
               $rRestRow=$crtRow.clone(), $rPartRow=$rBody.find('tr:eq('+$partRow.index()+')'),
               $rBackLogRow=$rbacklog.clone().removeClass('dn overbodybg'),
        cellIdx=$crtRow.find('td').removeClass('dn').filter('.td_input:first').prev()[0].cellIndex;

        $rRestRow.find('td').attr('data-min', function(){ 
               return ($rPartRow.find('td:eq('+this.cellIndex+')').attr('data-restpn'));
        });
        $crtRow.find('td').filter(':lt('+cellIdx+')').remove();      
        $rRestRow.find('td').removeClass('dn').filter(':lt('+cellIdx+')').remove();
$rBackLogRow.find('td').removeClass('dn').addClass('td_input').filter(':lt('+cellIdx+')').remove();
       
  /* comment start by CapTeam for "Copy OEM Backlog" btn checkbox functionality */
   /* var seleactAllbtns = '<input onclick="event_SelectAllBacklog_click(event, this)" value="Select All" type="button" class="btn"/>'
                       + '<input onclick="event_UnSelectAllBacklog_click(event, this)" value="Unselect All" type="button" class="btn"/>';
appendCloneColumn('<span> '+ seleactAllbtns+'</span>', 'OEMBacklogChkCls', $crtRow.clone(), $leftTbody, $rightTbody, chkInput, chkval);*/
       /* comment end by CapTeam for "Copy OEM Backlog" btn checkbox functionality */
  
        appendCloneColumn('<span style="line-height: 25px;">Quantity(Unit)</span>', 'qtycls', $crtRow.clone(), $leftTbody, $rightTbody, qtyInput, qtyText);
        if(isCFT == 'true' || isCFT == true){
               appendCFTCloneColumn(cftlabel, 'cftcls', $crtRow.clone(), $leftTbody, $rightTbody, qtyInput, qtyText);
                                              
               //'<span style="line-height: 25px;">Quantity</span> <input onclick="event_CFTData_click(event, this)" value="Copy CFT" type="button" class="btn popeditbtn" />', 
        }
$('#rtabid tr.level3').each(function() {
var customerId = $(this).find("td.td_input").value;
console.log (customerId)
});
        appendCloneColumn(asplabel, 'pricecls', $crtRow.clone(), $leftTbody, $rightTbody, priceInput, priceText);
        appendCloneColumn('RestPNsForecast($)', 'restcls', $rRestRow, $leftTbody, $rightTbody, restText, restText);
        appendCloneColumn('TotalBacklog(Unit)<span class="bkmark"></span>', 'backlogcls', $rBackLogRow, $leftTbody, $rightTbody, backlogText, backlogText);
        
        if( !$backLog.hasClass('loaded') && !$tr.hasClass('loadedbacklog') ){
               $tr.addClass('loadedbacklog');
               $('#edit_left_tbody span.bkmark').parent().append('<span class="cftcells wating leftbacklog">&nbsp;</span>');
        }else{
               $('#edit_left_tbody span.bkmark').parent().append('<input onclick="event_copyBacklog_click(event, this)" value="Copy backlog" type="button" class="btn" style="position: absolute;right: 2px;margin-top: -4px;" />');
        }

        //$leftTbody.append('<tr><td>'+$this.html()+'</td></tr>');
        $leftTbody.append('<tr><td>CurrentSalesForecast ($)</td></tr>');
        $rightTbody.append($crtRow.addClass('curtcls')).find('input').on('focus change keyup', event_soldToInput_change);
/* comment start by CapTeam for "Copy OEM Backlog" btn checkbox functionality */
      //$rightTbody.append($crtRow.addClass('curtcls')).find("input[type='text']").on('focus change keyup', event_soldToInput_change);
/* comment end by CapTeam for "Copy OEM Backlog" btn checkbox functionality */

        /* Help function*/
        ;function appendCloneHead(){
               var $rHead=$('#edit_thead'), $oldHead=$('#rHeadBody');
               if($rHead.find('tr').length != 0 ){
                       return;
               }
               $rHead.append($oldHead.find('tr').clone());
               $rHead.find('tr').removeAttr('id').find('th, td').removeClass('dn').filter('.historicalcls, .th_historicalcls').remove();
        //      $('#editleftth').css({'height': $oldHead.height()-0.5});
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
  console.log(map_cft)
             $leftTbody.append('<tr><td>'+label+'</td></tr>').find('input.cftbtncls').attr('data-cft', JSON.stringify(map_cft));
               $rightTbody.append($element);
        }
        
        ;function qtyInput(){
               var qty = getZeroOfNumber(this.getAttribute('data-nqty'));
               return ('<input type="text" class="inputcls" data-type="qty" value="'+Globalize.format(qty, DECIMAL_POINT['n0'])+'" />');
        }
        ;function qtyText(){
               return (Globalize.format(getZeroOfNumber(this.getAttribute('data-nqty')), DECIMAL_POINT['n0']));
        }
        ;function priceInput(){
               var price = getZeroOfNumber(this.getAttribute('data-nprice'));
               return ('<input type="text" class="inputcls" data-type="price" value="'+Globalize.format(price, DECIMAL_POINT['n4'])+'" />');
        }
        ;function priceText(){
               return (Globalize.format(getZeroOfNumber(this.getAttribute('data-nprice')), DECIMAL_POINT['n4']));
        }
        ;function backlogText(){
               return this.getAttribute('data-old');
        }
        ;function restText(){
var s1 = restCal
//console.log(s1)
               return (Globalize.format(getZeroOfNumber(this.getAttribute('data-min')), DECIMAL_POINT['n0']));
        }
   /* comment start by CapTeam for "Copy OEM Backlog" btn checkbox functionality */
   /*;function chkInput(){ 
        var qty = getZeroOfNumber(this.getAttribute('data-nqty')); 
       return ('<input type="checkbox" value="'+this.getAttribute('data-old')+'" />'); 
     // return ('<input type="checkbox" value="" checked/>');
    } */
   /* ;function chkval(){
        return (Globalize.format(getZeroOfNumber(this.getAttribute('data-nqty')), DECIMAL_POINT['n0']));
    }*/
/* comment end by CapTeam for "Copy OEM Backlog" btn checkbox functionality */
        /* Help function*/
}

/* comment start by CapTeam for "Copy OEM Backlog" btn checkbox functionality */
/*;function event_SelectAllBacklog_click(evt, target){
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
} */
/* comment end by CapTeam for "Copy OEM Backlog" btn checkbox functionality */
;function event_closePartPopupBox_click(event, target){
/* comment added by Cap team to show permanent message below save & close on part box */
// $('#msg_samsung').show();
 //$('#msg').hide();
    /* comment added by Cap team to show permanent message below save & close on part box */
        $('#editBoxDiv').hide();
        $('#edit_left_tbody').empty();
        $('#edit_right_tbody input').off('focus change');
        $('#edit_right_tbody').empty();
        $('#popupmain').fadeOut('fast');
}

;function event_existData_click(e){
//      e.stopPropagation();
        var hide = 'dn', list_element = [], $right_trs=$('#rtabid tr'), _this = this, $this=$(_this),
        $leftBody=$this.parent(), $waiting = $this.find('td:first span.fcell'), $pin=$this.find('span.pin'),
        config={'id': $this.attr('id'), 'data-level': $this.attr('data-level'), 'rowIndx': $this.index(), 'isRemote': false},
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
        
        var levelCls='';
        
        switch(config['data-level']){
               case 'level1' : 
                               levelCls='tr:not(.level1).'+config['id']+'_level1';
                               break;
               case 'level2' :
                               levelCls='tr:not(.level2).'+config['id']+'_level2.'+$this.attr('data-v1')+'_level1';
                       break;
               case 'level3' :
                               levelCls='tr:not(.level3).'+config['id']+'_level3.'+$this.attr('data-v2')+'_level2.'+$this.attr('data-v1')+'_level1';
                       break;
               default : break;
        }

        QUEUE.push({name: config['rowIndx'], run: function(cb){
var expandClickCurrentTarget = self.expandClickCurrentTarget, 
expandClickCurrentTargetId = $(expandClickCurrentTarget).attr('id'); 
$('.row-static-total_' + expandClickCurrentTargetId).remove(); 
$('.row-static-total-right_' + expandClickCurrentTargetId).remove();
                $leftBody.find(levelCls).addClass(hide).each(function(){
                    $right_trs.eq(this.rowIndex).addClass(hide).find('td');
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
        
        var remote_fn={'remote':function(p){}, 'rowIndex': config['rowIndx'], '$row': $this,
                                      'action': existObject_js, 'complete': complete_existResult,
                                      'v1': $this.attr('data-v1'), 'v2': $this.attr('data-v2'), 'v3': $this.attr('data-v3')}, levelCls='',
dataLevel = config['data-level'];
        $waiting.addClass('wating').html('&nbsp;');
        
        switch(dataLevel){
               case 'level1' :        //this search oem.
                               remote_fn['v1'] = config['id'];
                               remote_fn['data-level'] = 'level2';
                               remote_fn['familyname'] = $.trim($this.find('span.namecell').text());
                               remote_fn['appendElement'] = appendElement_Level2;
                               levelCls = 'tr.level2.mark.'+config['id']+'_level1';
                               remoteCheck(levelCls, remote_fn, createLevel2, WORK_CLS['level2']); 
                       break;
               case 'level2' :        //this search part. 
                               remote_fn['v2'] = config['id'];
                               remote_fn['data-level'] = 'level3';
                               levelCls = 'tr.level3.mark.'+config['id']+'_level2.'+remote_fn['v1']+'_level1';
                               remote_fn['appendElement'] = appendElement_Level3;
                               remoteCheck(levelCls, remote_fn, createLevel3, WORK_CLS['level3']); 
                       break;
               case 'level3' :        //this search part. 
                               remote_fn['v3'] = config['id'];
                               remote_fn['data-level'] = 'level4';
                               remote_fn['appendElement'] = appendElement_Level4;
                               levelCls = 'tr.level4.mark.'+config['id']+'_level3.'+remote_fn['v2']+'_level2.'+remote_fn['v1']+'_level1';
                               remoteCheck(levelCls, remote_fn, createLevel4, WORK_CLS['level4']); 
                       break;
               default : break;
        }
        
        remote_fn['remote'](remote_fn);
        expandElement(levelCls,dataLevel);
    }
    
    
    
    ;function remoteCheck(findCls, remoteFn, createJSON, actionClass){
        if($this.hasClass('done')){ return; }
        $this.find('span.del_img').css('visibility', 'hidden');
        config['isRemote'] = true;
        remoteFn['cls'] = actionClass;
        remoteFn['json'] = JSON.stringify( new createJSON() );
        remoteFn['remote'] = function(p){
               customMultipleRemoteAction(p, remoteFn['action'], remoteFn['complete']); //this is remote action
        };
    }
    
    
    ;function createLevel2(){
        ClsObjPrototype.call(this, $.trim($this.find('span.namecell').text()));        //extends base object
    }
    ;function createLevel3(){
        ClsObjPrototype.call(this, $this.attr('data-familyname'));   //extends base object
        this['gplcode'] = $.trim($this.attr('data-gplcode'));
    }
    
    ;function createLevel4(){
        ClsObjPrototype.call(this, $this.attr('data-familyname'));   //extends base object
        this['partId'] = config['id'];
    }
    
    ;function ClsObjPrototype(gplfamily){
        this['gplfamily'] = gplfamily;
        this['oemId'] = $('#hidd_samsungid').val();
       this['startDate'] = $('#hidd_start').val();
        this['endDate'] = $('#hidd_end').val();
        this['managerId'] = $('#hidd_manager').val();
        this['map_year_monthsFuture'] = $.parseJSON($('#hidd_futuremonthmap').val());
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
    
 ;function expandElement(levelCls,dataLevel){
		var setFlag = false;
        QUEUE.push({name: config['rowIndx'], run: function(cb){
            var list_element = $leftBody.find(levelCls).toArray();
			this.dataLevel = dataLevel;		
			self.testCounter = 0;
			console.log('Length: ' + list_element.length);
            async.eachSeries(list_element, function(item, callback) {
                setTimeout(function(){
                       var $item=$(item).removeClass(hide);
					   if ($(item).hasClass('level4')) {
						   var rowNum = item.rowIndex;
						   while(!$right_trs.eq(rowNum).hasClass('rlevel4')) {
							   setFlag = true;
							   break;
						   }
						   if(setFlag == true){
							   rowNum++;
						   }
						   $right_trs.eq(rowNum).removeClass(hide);
					   } else {
							$right_trs.eq(item.rowIndex).removeClass(hide);
					   }
					self.testCounter += 1;		
					console.log('counter: ' + self.testCounter);
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

;function event_addSearchObject_click(e){     //search object add element event
        
        var $checkboxs = $('#popupbody input[type="checkbox"]:checked'), $searchBtn=$('#searchbtn'),
data_level=$('#searchbtn').attr('data-level'),
               data={ 'data-level': $searchBtn.attr('data-level'), 'v1': $searchBtn.attr('data-v1'),
                       'v2': $searchBtn.attr('data-v2'), 'v3': $searchBtn.attr('data-v3'), 'tabtype': $searchBtn.attr('data-tabid'),
                       'familyname': $searchBtn.attr('data-familyname'), 'list_result': [],
                       '$row': $, 'call': function(){}, 'callBackEnd': callBackEnd
               };
        data['o-level'] = $searchBtn.attr('data-level');
        if($checkboxs.length == 0){ return; }
        
        $('#searchtabid').css('visibility', 'hidden');
        data['$inputs'] = $('#popupbox input[type="button"]').attr({'disabled': 'disabled'});
        $checkboxs.each(function(){
               data['list_result'].push($.parseJSON($(this).attr('data-json')));
        });     

        $('#popup_loading').html(' ').show();
        
        switch(data['o-level']){
               case 'level1': 
                       data['data-level'] = 'level2-4';
                       data['$row'] = $('#ltabid tr.mark.level1.'+data['v1']+'_level1');
                       data['call'] = appendElement_Level2_4;
                       break;
               case 'level2': 
                       data['data-level'] = 'level3';
                       data['$row'] = $('#ltabid tr.mark.level2.'+data['v2']+'_level2.'+data['v1']+'_level1');
                       data['call'] = appendElement_Level3;
                       break;
               case 'level3': 
                       data['data-level'] = 'level4';
                       data['$row'] = $('#ltabid tr.mark.level3.'+data['v3']+'_level3.'+data['v2']+'_level2.'+data['v1']+'_level1');
                       data['call'] = appendElement_Level4;
                       break;
        }
        data['insert'] = 'search';
        data['list_result'].reverse(); //reverse data list 

        if( (data['o-level']=='level1' && data['tabtype'] == 'level1' ) || data['o-level']=='level2' ){ // && CATCH_DATA['GF'].hasOwnProperty(data['familyname'])
               checkSoldToPart(data);
               return;
        }

        
        QUEUE.push({name: data['data-level'], run: function(cb){
               setTemplateElement(data);
               data['call'](data, cb, data['callBackEnd']);
    }}, function(err){ });
    
    ;function callBackEnd(_callBack, _data){
        event_closePopUP_click(null);
        _data['$inputs'].removeAttr('disabled');
/* Added by Cap Team for DNDP1 */ 
if (data_level === 'level3') {
isdelsoldto=true;	
addPartTotalRow(); 
} 
/* End by Cap Team for DNDP1 */
        $('#searchtabid').removeAttr('style');
        _callBack(null);
        }
    
        ;function checkSoldToPart(data){
               
               var $lBody=$('#ltabid'), jsonCheck={'oemId': $('#hidd_samsungid').val(), 'gplfamily': data['familyname'], 'managerId' : $('#hidd_manager').val(), 
                                              'set_selectdsoldtonumbers': [], 'set_selectedId': [], 'set_deletedId': [], 'set_gplcodedeletedId': []
                                      };

               for(var i=0, result; result=data['list_result'][i]; i++){
                       jsonCheck['set_selectedId'].push(result['id']);
               }
               
               $lBody.find('tr.mark.level3.'+data['v1']+'_level1').each(function(){
                       jsonCheck['set_selectedId'].push(this.id);
               });
               $lBody.find('tr.'+data['v1']+'_level1.prot.mark.level2').each(function(){
                       jsonCheck['set_selectdsoldtonumbers'].push( this.getAttribute('data-number') );
               });

                       /*
               if(data['o-level']=='level2'){ //search part
               }else{//search sold to
                       var $lBody=$('#ltabid');
                       $lBody.find('tr.'+data['v1']+'_level1.mark.level3').each(function(){
                               jsonCheck['set_selectedPartIds'].push( this.id );
                       });
               }
                       */
               
               if(CATCH_DATA['level2'].hasOwnProperty(data['v1'])){
                       var list_gpl = CATCH_DATA['level2'][data['v1']];
                       for(var i=0, gpl; gpl=list_gpl[i]; i++){
                               if(typeof(gpl['gplcode']) != 'undefined'){
                                      jsonCheck['set_gplcodedeletedId'].push( gpl['gplcode'] );
                               }
                       }
               }
               for(var level in CATCH_DATA['level3']){
                       var list_t=level.split('_'), list_delPart = CATCH_DATA['level3'][level];
                       if(list_t[0] == data['v1']){
                               for(var i=0, part; part=list_delPart[i]; i++){
                                      jsonCheck['set_deletedId'].push( part['v3'] );
                               }
                       }
               }

               customRemoteAction({'json': JSON.stringify(jsonCheck), 'data': data}, checkSoldTo_js, complete_checkSoldTo);
        }
        
}

;function event_checkBox_click(e){    //checkbox event
        $('#popupbody input[type="checkbox"]').prop('checked', $(this).prop('checked'));
}

;function event_searchBtn_click(e){
        
        var $this=$(this), $row=$('#ltabid tr.mark.level1.'+$this.attr('data-v1')+'_level1'), $wating=$row.find('span.fcell'), 
               data_level=$this.attr('data-level'), $inputs=$('#popupbox input[type="button"]').attr({'disabled': 'disabled'});

        if(data_level=='level1' && $wating.hasClass('wating')){
               $inputs.removeAttr('disabled');
               artDialogBox('Please waiting for load data.');
               return;
        }
        
        $('#popupbody').empty();
        $('#searchtabid').css('visibility', 'hidden');

        var $loading=$('#popup_loading').html(' ').show(),
               json={'startDate': $('#hidd_start').val(), 'endDate': $('#hidd_end').val(), 'map_year_monthsFuture': $.parseJSON($('#hidd_futuremonthmap').val()), 
                               'searchKey': $.trim($('#searchtext').val()), 'oemId': $('#hidd_samsungid').val(), 'gplfamily': $this.attr('data-familyname'), 
                               'accnumber':$this.attr('data-number'), 'hasGPLCode': (data_level =='level2' ? true : false), 'managerId': $('#hidd_manager').val(), 
                               'set_deletedId': [], 'set_selectedId': [], 'gplcode': $this.attr('data-gplcode'), 'set_deletedsoldtonumbers': [],
                               'set_selectedPartIds': [], 'set_deletedPartIds': [], 'set_deletedgplcodes': [], 'set_selectdsoldtonumbers': [],
                               'partId': $this.attr('data-v3'), 'isExpansionSoldto': ($this.attr('data-isexpan') == 'false' ? false : true)},
               json_data={'cls': $this.attr('data-cls'), 'json': '{}', '$inputs': $inputs, '$btn': $this, '$loading': $loading};
        
        switch(data_level){
               case 'level1': 
                       var v1=$row.attr('id');
                       if($this.attr('data-tabid') == 'level1'){
                               $('#ltabid tr:not(.prot).mark.level2.'+v1+'_level1').each(function(){
                                      json['set_selectedId'].push( $(this).attr('data-gplcode') );
                               });
                               
                               if(CATCH_DATA['level2'].hasOwnProperty(v1)){
                                      var list_v1=CATCH_DATA['level2'][v1];
                                      for(var i=0, v; v=list_v1[i]; i++){
                                              if(!v['isnon']){ json['set_deletedId'].push(v['gplcode']); }
                                      }
                               }
                       }else{
                               var $lBody=$('#ltabid');
                               $lBody.find('tr.'+v1+'_level1.mark.level3').each(function(){
                                      json['set_selectedPartIds'].push( this.id );
                               });
                               $lBody.find('tr.'+v1+'_level1.prot.mark.level2').each(function(){
                                      json['set_selectdsoldtonumbers'].push( this.getAttribute('data-number') );
                               });

                               if(CATCH_DATA['level2'].hasOwnProperty(v1)){
                                      var list_gpl = CATCH_DATA['level2'][v1];
                                      for(var i=0, gpl; gpl=list_gpl[i]; i++){
                                              if(typeof(gpl['gplcode']) != 'undefined'){
                                                     json['set_deletedgplcodes'].push( gpl['gplcode'] );
                                              }
                                              if(typeof(gpl['data-number']) != 'undefined'){
                                                      json['set_deletedsoldtonumbers'].push( gpl['data-number'] );
                                              }
                                      }
                               }
                               for(var level in CATCH_DATA['level3']){
                                      var list_t=level.split('_'), list_delPart = CATCH_DATA['level3'][level];
                                      if(list_t[0] == v1){
                                              for(var i=0, part; part=list_delPart[i]; i++){
                                                     json['set_deletedPartIds'].push( part['v3'] );
                                              }
                                      }
                               }
                               /*
                               
                               $('#ltabid tr.prot.mark.level2.'+v1+'_level1').each(function(){
                                      list_selectIds.push(this.getAttribute('data-number'));
                               });
                               
                               if(CATCH_DATA['level2'].hasOwnProperty(v1)){
                                      var list_v1=CATCH_DATA['level2'][v1];
                                      for(var i=0, v; v=list_v1[i]; i++){
                                              if(v['isnon']){ list_deletedId.push(v['data-number']); }
                                       }
                               }
                               */
                       }
                       break;
               case 'level2': 
                       var v1=$this.attr('data-v1'), v2=$this.attr('data-v2'), gplCode=$this.attr('data-gplcode');
                       
                       $('#ltabid tr.mark.level3.'+v2+'_level2.'+v1+'_level1').each(function(){
                               json['set_selectedId'].push(this.id);
                       });

                       if( CATCH_DATA['level3'].hasOwnProperty((v1+'_'+gplCode)) ){
                               var list_v2=CATCH_DATA['level3'][(v1+'_'+gplCode)];
                               for(var i=0, v; v=list_v2[i]; i++){
                                      json['set_deletedId'].push(v['v3']);
                               }
                       }
                       break;
               case 'level3': 
                       var v1=$this.attr('data-v1'), v2=$this.attr('data-v2'), v3=$this.attr('data-v3'), gplCode=$this.attr('data-gplcode');
                       
                       $('#ltabid tr.prot.mark.level4.'+v3+'_level3.'+v2+'_level2.'+v1+'_level1').each(function(){
                               json['set_selectedId'].push(this.getAttribute('data-number'));
                       });
                       
                       if(CATCH_DATA['level4'].hasOwnProperty((v1+'_'+gplCode+'_'+v3))){
                               var list_v2=CATCH_DATA['level4'][(v1+'_'+gplCode+'_'+v3)];
                               for(var i=0, v; v=list_v2[i]; i++){
                                      json['set_deletedId'].push(v['data-number']);
                               }
                       }
                       break;
        }

        json_data['json'] = JSON.stringify(json);
        customMultipleRemoteAction(json_data, searchObject_js, complete_searchObject);        //this is remote action
}

;function event_CFTData_click(event, target){
        var monthCell={}, $target=$(target), map_cft=$.parseJSON($target.attr('data-cft')), $body=$('#edit_right_tbody'), 
               $qtyCells=$body.find('tr.qtycls td'), $crtCells=$body.find('tr.curtcls td'), 
               $priceCells=$body.find('tr.pricecls td'), $restCells=$body.find('tr.restcls td');
        
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
               if(total <= rest){
                       $rest.attr('data-min', (rest-total)).html( Globalize.format((rest-total), DECIMAL_POINT['n0']) );
                       $input.val( Globalize.format(rst['quantity'], DECIMAL_POINT['n0']) ).removeAttr('style');
            $crt.html( Globalize.format(total, DECIMAL_POINT['n0']) );
               }else{
                       $input.css('border-bottom', '5px solid red');
               }
        }

}

;function event_searchText_keyup(e){
        e.stopPropagation();
        if(e.keyCode == 13){ document.getElementById('searchbtn').click(); }
}

;function event_popupBox_click(event, target){
        event = (event?event:window.event);
        event.cancelBubble = true;
        
        $('#popup_loading').html(' ').hide();
        var list_ids=[], $this=$(target), $tr=$this.parent().parent().parent().parent().parent(),
               $popupbox=$('#popupbox'), $searchBtn=$('#searchbtn'), $lBody=$('#ltabid');
        
        if(!$tr.hasClass('exp')){
               $tr.click();
        }
               
        $('#popuphead input[type="checkbox"]').off('click');
        $searchBtn.parent().find('input[type="button"].otherbtn').remove();
        $('#popupmain').fadeIn('fast');
        
    $popupbox.css({'top':-1200, 'display':''}).stop().animate({'top':'10%'}, 800, function(){
        $('#searchtext').val('').focus();
    });
        $('#searchtabid').remove();
        switch($tr.attr('data-level')){
               case 'level1' : 
                       var attr={'data-level': 'level1', 'data-cls': WORK_CLS['level2'], 'data-isexpan': false, 'data-tabid': 'level1',
                                              'data-gplcode': '', 'data-v1': $tr.attr('id'), 'data-familyname': $.trim($tr.find('span.namecell').text())};
                       $searchBtn.attr(attr);
                       $popupbox.find('#searchtext').before('<div id="searchtabid" class="searchTab"><span class="searchTabBox" data-type="part" onclick="event_searchTab_click(event, this)">Part</span><span  data-type="soldto" onclick="event_searchTab_click(event, this)" class="searchTabBox inactive">Sold To</span></div>');
                       $('#popuphead').append($('#level1_tab td').clone()); 
                       break;
               case 'level2' : 
                       var attr={'data-v1': $tr.attr('data-v1'), 'data-v2': $tr.attr('id'), 'data-tabid': 'level1',
                                              'data-level': 'level2', 'data-cls': WORK_CLS['level3'], 'data-isexpan': false,
                                              'data-familyname': $tr.attr('data-familyname'), 'data-gplcode': $tr.attr('data-gplcode')};
                       $searchBtn.attr(attr);
                       $('#popuphead').append($('#level1_tab td').clone()); 
                       break;
               case 'level3' : 
                       var attr={'data-v1': $tr.attr('data-v1'), 'data-v2': $tr.attr('data-v2'), 'data-v3': $tr.attr('id'),
                                              'data-level': 'level3', 'data-cls': WORK_CLS['level4'], 'data-isexpan': false, 'data-tabid': 'level3',
                                              'data-familyname': $tr.attr('data-familyname'), 'data-gplcode': $tr.attr('data-gplcode')};
                       $searchBtn.attr(attr);
                       $('#popuphead').append($('#level3_tab td').clone()); 
                       break;
        }
        
        $searchBtn.attr({'data-selectIds': JSON.stringify(list_ids), 'data-number': $tr.attr('data-number')});
        $('#popuphead input[type="checkbox"]').on('click', event_checkBox_click);
        $('#boxheadid').css({'width': ($('#boxbodyid').width()-scrollbarW)});
}

;function event_closePopUP_click(target){
        $('#popupbox').stop().animate({'top':-1200}, 800, function(){
               $(this).find('input[type="checkbox"]').off('click');
        $('#popupmain').fadeOut('fast');
        $('#popuphead').empty();
        $('#popupbody').empty();
    });
}

;function event_closeErrorBox_click(target){
        $('#showerror').animate({'top': '-120%'}, 360, function(){
               $(this).find('#errtabbody tr').remove();
        });
}

;function event_closeProgressBox_click(target){
        SAVE_ERRORS = [];
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
        var t=parseInt($.trim($('#prg_err').html()), 10), $pError=$('#progresserror'), $prog_btn=$('#progressbarbtn_div');

        $prog_btn.find('input[type="button"].errbtn').remove();
        if($.isNumeric(t) && t > 0){
               var list_btn=[
                       '<input value="Show errors" onclick="event_showErrorForecast_click(this)" class="btn errbtn" type="button" />',
                       '<input onclick="event_reSaveForecast_click(this)" value="Re save forecast" class="btn errbtn" style="margin: 0 10px;" type="button"/>'
               ];
               /*
               if($pError.attr('data-check') == 'start'){
                       list_btn.delIndex(1);
               }
               */
               $prog_btn.prepend(list_btn.join(''));
               $('#progressbarbtn_div').show();
               return;
        }
        setTimeout(function(){
               var $lBody=$('#ltabid'), $rBody=$('#rtabid'), oemId=$('#hidd_samsungid').val(), 
                       $pBar=$("#progressbar").attr('data-value', 0).progressbar('destroy').progressbar({ value: false }),
                       cellMonth={}, list_save=$lBody.find('tr.mark.level3').toArray();
               
               $pBar.find('div.progress-label').html('Loading...');  
               
               $('#tab_head_list td.futurecls').each(function(){
                       cellMonth[this.cellIndex] = this.getAttribute('data-month');
               });
               
               if($pError.attr('data-v5') != 'done' && list_save.length != 0){
                       $('#progressstatusid').html('Checking records...');
                       $pError.attr({'data-v5': 'done', 'data-check': 'start'});
                       createCheckRest_RemoteAction(list_save, oemId, cellMonth, $pBar, $rBody);
                       return;
               }
               
               list_save=$lBody.find('tr.mark.level4').toArray()
               if($pError.attr('data-check') != 'done' && list_save.length != 0){
                       $('#progressstatusid').html('Saving records...');
                       $pError.attr({'data-v5': 'done', 'data-check': 'done', 'data-v4': 'start'});
                       createLevel4_RemoteAction(list_save, oemId, cellMonth, $pBar, $rBody);
                       return;
               }
               
               list_save=$lBody.find('tr.mark.level3').toArray()
               if($pError.attr('data-v4') != 'done' && list_save.length != 0){
                       $('#progressstatusid').html('Saving records...');
                       $pError.attr({'data-check': 'done', 'data-v4': 'done', 'data-v3': 'start'});
                       createLevel3_RemoteAction(list_save, oemId, cellMonth, $pBar, $rBody);
                       return;
               }

               list_save=$lBody.find('tr.prot.mark.level2').toArray();
               if($pError.attr('data-v3') != 'done' && list_save.length != 0){
                       $('#progressstatusid').html('Saving records...');
                       $pError.attr({'data-check': 'done', 'data-v4': 'done', 'data-v3': 'done', 'data-v2': 'start'});
                       createLevel2_RemoteAction(list_save, oemId, cellMonth, $pBar, $rBody);
                       return;
               }
               CATCH_DATA['level2'] = {};
               CATCH_DATA['level3'] = {};
               CATCH_DATA['level4'] = {};
               
               CATCH_DATA['DEL2'] = {};
               CATCH_DATA['DEL3'] = {};
               CATCH_DATA['DEL4'] = {};
               
               $('#loading-curtain-div').show();
               event_closeProgressBox_click(null);
               
               var json={'json': JSON.stringify({'managerId': $('#hidd_manager').val(), 'startDate': $('#hidd_start').val(), 'endDate': $('#hidd_end').val()}),
                                 'action': saveSamsungOEMLevel_js, 'complete': complete_saveSamsungOEMLevel};
               customRemoteAction(json, json['action'], json['complete']);

        //      $pBar.find('div.progress-label').html('100%');
        //      $('#progressbarbtn_div').show();
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
               o_bar=getBarConfg(list_save), $pError=$('#progresserror');

        SAVE_ERRORS=[];
        setPopBoxStatus();

        $pBar.find('div.progress-label').html('Loading...');
        $pError.css({ "background": o_bar['rgba'] });
        $('#prg_total').html(list_save.length);
        
        $pBar.progressbar({ value:false, max: o_bar['max'], change: event_pBar_change, complete: event_pBar_complete })
                       .find('.ui-progressbar-value').css({ "background": o_bar['bgcolor'] });
        asyncEachSeries_Original(list_save, function(item, callback){
               item['pct'] = o_bar['pct'];
               item['max'] = o_bar['max'];
               if($pError.attr('data-check') == 'start'){
                       customRemoteAction(item, item['action'], item['complete']); //this is remote action
               }else{
                customMultipleRemoteAction(item, item['action'], item['complete']); //this is remote action
               }
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

;function event_windowReSize(e){
    $('#forecastdiv_id').css({'visibility': 'hidden'});
    fixTableLayout($('#tabContainer').width(), false);
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