var oldValue='', list_color=[], list_delcatch=[], map_cmtcatch=new customMap(), scrollbarW = $.getScrollbarWidth(), connectionStatus = {},
    map_cmtasmcatch=new customMap(), list_gSave=[], list_asm_overcatch=[], isover=false, isfull=false;
var isEdit=undefined;
;function initDocumentPage(){
	
	isEdit = document.getElementById('saveid');
    Globalize.culture(this.locale).numberFormat.currency.symbol = "";
    list_color=$.parseJSON(document.getElementById('colorid').value);

    var $select = $('#region_select'), len = $select.find('option').length-1;

    $select.find('option').each(function(){
        this.innerHTML = this.innerHTML.replace('_', ' - ');
    });

    if(len > 0 && len <=1){
        $select.find('option:first').remove();
        searchrsm(null);
        return;
    }
    freshDocumentPage(true);
}
;function freshDocumentPage(isHide){
	setBodyStyle();
//	lazyExecute( setBodyStyle );
    appendExpand_Collapse();
    $(window).smartresize(windowReSize);
    
    $('#rsmHeadId td.cfixqtotalw').addClass('hd').off('click').on('click', ck_headCell_eve);
    $('#rCellScroll').scroll(rCellScroll_eve);
    
//	$('#menudivid').off('mouseenter mouseleave').on('mouseenter mouseleave', menu_over_eve);
	$('#menudivid').hoverDelay({hoverEvent: menuHover_eve, hoverDuring: 360,outEvent: menuOut_eve,outDelay: 100});

	$('#gsmmenu').off('mouseenter mouseleave').on('mouseenter mouseleave', menu1_over_eve);
	
    var $lCell=$('#lcellbody'), $rTab=$('#rTabId');

    $rTab.find('tr:not(.not_total)').off('mouseenter mouseleave').on('mouseenter mouseleave', {tab:'#lcellbody'}, tab_ov_eve);
    $rTab.find('input[type="text"]').off('focus change').on('focus change', input_fc_eve)
    									.off('keyup').on('keyup', input_keyup_eve);
   
    $rTab.find('img').hoverDelay({hoverEvent: hoverEvent_eve, hoverDuring: 800,outEvent: outEvent_eve,outDelay: 200});

    $lCell.off('mousewheel').on('mousewheel', lCellScroll_eve)
          .find('table tr:not(.not_total)').off('mouseenter mouseleave').on('mouseenter mouseleave', {tab:'#rTabId'}, tab_ov_eve);

    $lCell=$rTab=null;
    var $document = $(document);
    $document.keyup(function(e){
    		switch(e.keyCode){
    			case 27:
		    		var isFullScreen = document.fullScreen || document.mozFullScreen || document.webkitIsFullScreen;
				if(!isFullScreen){
    					smallScreenStyle(document.getElementById('fullid'));
    				}
    				break;
    		}
    });
    $document.bind('fullscreenchange webkitfullscreenchange mozfullscreenchange', checkScreenChange);
    
    
    if(isHide){ loadingAnimate(); }
    
    ;function checkScreenChange(e){
    		var isFullScreen = document.fullScreen || document.mozFullScreen || document.webkitIsFullScreen;
		if(!isFullScreen){
			smallScreenStyle(document.getElementById('fullid'));
		}
    }
    
}

;function menuHover_eve(target){
	var $this=$(target), _offset=$this.offset();
	$('#gsmmenu').stop().css({'height':'0px', 'visibility':'visible', 'top': ($this.height()+_offset.top), 'left':_offset.left})
			.animate({height:'27%'}, 360);
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

			if(e.target.tagName.toLowerCase() == 'select'){
				return;
			}
			
			$this.animate({height:'0px'}, 460, function(){
				$(this).removeClass('hover').css({'visibility':'hidden'});
			});
		break;
	}
}

;function hoverEvent_eve(target){
	var _this=target, $this=$(_this), $tips=$('#asmcmtoverid'),
		_position = $this.parent().parent().offset(),
		list_params = $this.attr('onclick').split('showComment(this, ')[1].split(',');

	for(var i=0, max=list_params.length; i<max; i++){
		list_params[i] = $.trim( list_params[i].replace(/['\)]/g, '') );
		list_params[i] = list_params[i].replace(/-/g, '_');
	}
	$tips.find('#asmovershowbodyid tr').css({'display':'none'});
	var len=($tips.find('#asmovershowbodyid tr.'+list_params[1]+list_params[0]).length+
			$tips.find('#asmoverbottom tr.'+list_params[1]+list_params[0]).length
		), json = '{"cls1":"'+$this.parent().parent().parent()[0].getAttribute('category')+'", "cls2":"'+list_params[1]+'", "cls3":"'+list_params[0]+'"}',
		jq_json = $.parseJSON(json);
	
	$tips.find('#tips_loading').css({'display':''});	
	$tips.css({'display': '','top': (_position['top']-5), 'left':(_position['left']+20)});


	if(_.contains(list_asm_overcatch, (jq_json['cls1']+jq_json['cls2']+jq_json['cls3'])) || len>0){
		$tips.find('#tips_loading').css({'display':'none'});
		$tips.find('#asmovershowbodyid tr.'+list_params[1]+list_params[0]).css({'display':''});
		$tips.find('#asmoverbottom tr.'+list_params[1]+list_params[0]).css({'display':''});
		return;
	}

	$('[id*=hidectmasmoverid]').val(json);	
	actionASMHoverComt();	//this is action function
}

;function outEvent_eve(){
	var $tips=$('#asmcmtoverid');
	$tips.find('#tips_loading').css({'display':''});
	$tips.css({'display': 'none'}).find('#asmovershowbodyid tr').css({'display':'none'});
	$tips.find('#asmoverbottom tr:not(.notnone)').css({'display':'none'});
}
;function cmt_ov_eve(e){
	var _this=this, $this=$(_this), $tips=$('#asmcmtoverid');
	if(e.type == 'mouseenter'){
		$tips.find('#tips_loading').css({'display':''});
		var _position = $this.parent().parent().offset(), sTime = +new Date();
		
    		var list_params = $this.attr('onclick').split('showComment(this, ')[1].split(',');
    		for(var i=0, max=list_params.length; i<max; i++){
    			list_params[i] = $.trim( list_params[i].replace(/['\)]/g, '') );
    			list_params[i] = list_params[i].replace(/-/g, '_');
    		}
		var len=($tips.find('#asmovershowbodyid tr.'+list_params[1]+list_params[0]).length+
				$tips.find('#asmoverbottom tr.'+list_params[1]+list_params[0]).length
				);
		$tips.css({'display': '','top': (_position['top']-5), 'left':(_position['left']+20)});
    		if (len > 0){
    			$tips.find('#tips_loading').css({'display':'none'});
    			$tips.find('#asmovershowbodyid tr.'+list_params[1]+list_params[0]).css({'display':''});
    			$tips.find('#asmoverbottom tr.'+list_params[1]+list_params[0]).css({'display':''});
    			
    			return;
    		}
    		
    		var json = '{"cls1":"'+$this.parent().parent().parent()[0].getAttribute('category')+'", "cls2":"'+list_params[1]+'", "cls3":"'+list_params[0]+'"}';
		$('[id*=hidectmasmoverid]').val(json);	
		actionASMHoverComt();	//this is action function

    }else if(e.type == 'mouseleave'){
    		$tips.find('#tips_loading').css({'display':''});
    		$tips.css({'display': 'none'}).find('#asmovershowbodyid tr').css({'display':'none'});
    		$tips.find('#asmoverbottom tr:not(.notnone)').css({'display':'none'});
    }
}
;function actionASMHoverComtComplete(){
	var $resultBody = $('#asmoverbody'),
		json_hide = $.parseJSON( $('[id*=hidectmasmoverid]').val() );
	$resultBody.find('tr').addClass(json_hide['cls2']+json_hide['cls3']);
	
	list_asm_overcatch.push( (json_hide['cls1']+json_hide['cls2']+json_hide['cls3']) );
	$resultBody.find('td.asmoverval').html(function(){
		var val=Globalize.format( roundToKM(numberOfZero($.trim(this.innerHTML))), 'n0');
		return val;
	});
	$('#asmovershowbodyid').append($resultBody.find('tr.asm_top'));
	$('#asmoverbottom').append($resultBody.find('tr.asm_btm'));
	$('#tips_loading').css({'display':'none'});
}
function fullAutomaticScreenPage(isfull) {
	var el = document.documentElement,
		rfs = el.requestFullScreen || el.webkitRequestFullScreen || el.mozRequestFullScreen || el.msRequestFullScreen;
	if(!isfull){

	    if (typeof rfs != "undefined" && rfs) {
	        rfs.call(el, Element.ALLOW_KEYBOARD_INPUT);
	    } else if (typeof window.ActiveXObject != "undefined") {// for Internet Explorer
	    		try{
		        var wscript = new ActiveXObject("WScript.Shell");
		        if (wscript != null) { wscript.SendKeys("{F11}"); }
	    		}catch(e){
	    			alert('ActiveXObject: '+e);
	    		}
	    }
		
	}else{
		rfs = document.cancelFullScreen||document.webkitCancelFullScreen||document.mozCancelFullScreen||document.exitFullscreen;
		if (typeof rfs != "undefined" && rfs) {
			rfs.call(document);
		}else if (typeof window.ActiveXObject != "undefined") {// for Internet Explorer
			try{
		        var wscript = new ActiveXObject("WScript.Shell");
		        if (wscript != null) { wscript.SendKeys("{F11}"); }
			}catch(e){
	    			alert('ActiveXObject: '+e);
	    		}
        }
	}

}
;function smallScreenStyle(target){
	$('html body').removeAttr('style');
	$('#AppBodyHeader').removeAttr('style');
	$('#bodyTable').removeAttr('style').parent().removeAttr('style')
		.children().children().children().children().removeAttr('style');
	$('div.bPageFooter').removeAttr('style');
	target.setAttribute('screen', 'small');
	isfull = false;
	setBodyStyle(undefined, true);
}
;function fullScreenStyle(target){
	$('html body').css({'margin': '0px', 'background-color':'#fff'});
	$('#AppBodyHeader').css({'height':'0.1px', 'overflow':'hidden'});
	$('#bodyTable').css({'margin':'0px', 'padding':'0px'}).parent().css({'border-top':'0px'})
		.children().children().children().children().css({
			'padding-top': '0px', 'padding-left': '0px','padding-right': '0px' });
	$('div.bPageFooter').css({'display':'none'});
	target.setAttribute('screen', 'full');
	isfull = true;
	setBodyStyle(undefined, true);
}
;function fullScreen(target){
	$('#gsmmenu').css({'visibility':'hidden'});
	if(navigator.userAgent.indexOf('Firefox') != -1 || navigator.userAgent.indexOf('Chrome') != -1){
		fullAutomaticScreenPage(isfull);
		if(target.getAttribute('screen') == 'small'){
			fullScreenStyle(target);
		}else{
			smallScreenStyle(target);
		}
	}else{
		art.dialog({
			title:' ', lock:true, dblclick_hide:false, esc:false, id:'fullscreen_artid',
			content: $label['browsermsg'],
			button : [{
				value: 'OK', focus: false,
		        callback: function () { }
			}]
		});
	}
}
;function amfcComment_ov_eve(e){
	if(isover){return;}
	var $this=$(this);
	
    eventHandle_ov_ot(e, ov, ot);
    ;function ov(e){
    		isover = true;
    		var $parent=$this.parent(), _id=$parent[0].getAttribute('sid'), 
    			_category=$parent.parent().find('tr.'+_id)[0].getAttribute('category'),
        		el_head = document.getElementById('rsmHeadId').cells[$this[0].cellIndex],
        		_year = (el_head.getAttribute('fyear') + '_' + el_head.getAttribute('fmonth')),
        		json = '{"cls1":"'+_category+'", "cls2":"'+_id+'", "cls3":"'+_year+'"}';
		$('[id*=cmtasmstrid]').val(json);
    		actionASMComments();		//this is action function
    }
    ;function ot(e){  }
}
;function actionASMCommentsComplete(){
	isover = false;
    $('#popCtn1').fadeIn('slow');
    document.getElementById('popCmt1').className='';
    loadingAnimate();
}
;function clsASMPop(){
	$('#popCtn1').fadeOut('slow', function(){
        document.getElementById('popCmt1').className='hide';
    });
}
;function clsPop(){
	var el_tmp = document.getElementById('tmpvalid'), _id=el_tmp.getAttribute('did'), _year=el_tmp.getAttribute('year');
	if(map_cmtcatch.containsKey((_id+_year))){
		map_cmtcatch.remove((_id+_year));
	}
	map_cmtcatch.put((_id+_year), $('#commentBodyId tr').clone(true));
    $('#popCtn').fadeOut('slow', function(){
        document.getElementById('popCmt').className='hide';
		$('#commentBodyId').empty();
    });
    var asm_json = $.parseJSON($('[id*=cmtasmstrid]').val()), _key = (asm_json['cls1']+asm_json['cls2']+asm_json['cls3']);	//cls1: "A", cls2: "a2cL00000004NprIAE", cls3: "2014_4"
    if(!map_cmtasmcatch.containsKey(_key)){
	    map_cmtasmcatch.put(_key, $('#asmbodyid tr').clone().toArray());
    }
}
;function saveCmt(){
	var asm_json = $.parseJSON($('[id*=cmtasmstrid]').val()), _key = (asm_json['cls1']+asm_json['cls2']+asm_json['cls3']);	//cls1: "A", cls2: "a2cL00000004NprIAE", cls3: "2014_4"
    if(!map_cmtasmcatch.containsKey(_key)){
	    map_cmtasmcatch.put(_key, $('#asmbodyid tr').clone().toArray());
    }
	var list_comments = $('#commentBodyId tr').toArray(),
		el_tmp = document.getElementById('tmpvalid'), 
		_id=el_tmp.getAttribute('did'), _year=el_tmp.getAttribute('year');

	for(var i=0, _el; _el=list_comments[i]; i+=1){
		_el.setAttribute('isv', 'true');
	}

	if(map_cmtcatch.containsKey((_id+_year))){ map_cmtcatch.remove((_id+_year)); }
	if(list_comments.length > 0){
		map_cmtcatch.put((_id+_year), $('#commentBodyId tr').clone(true));
		list_comments = list_delcatch.slice(0);
		list_delcatch = [];
		for(var i=0, _key; _key=map_cmtcatch.keys()[i]; i+=1){
			while(list_comments.length > 0){
				var _el = list_comments.shift(), _id_year = (_el.getAttribute('did')+_el.getAttribute('dyear'));
				if(_key != _id_year){ list_delcatch.push(_el); }
			}
		}
	}

	$('#popCtn').fadeOut('slow', function(){
        document.getElementById('popCmt').className='hide';
        $('#commentBodyId').empty();
    });
}
;function addComment(){
	var clone_ele = $('#comment_tmpid tr').clone(true)[0], el_tmp = document.getElementById('tmpvalid');
	clone_ele.setAttribute('did', el_tmp.getAttribute('did'));
	clone_ele.setAttribute('dyear', el_tmp.getAttribute('year'));
	$('#commentBodyId').append( clone_ele ).find('input[type="text"].inputrsmval')
		.off('focus change').on('focus change', rsmCmtInput_eve);
}
;function delComment(target){
	var $target_tr=$(target).parent().parent();
	if($('#commentBodyId tr').length <= 1){
		list_delcatch.push($target_tr.clone()[0]);
	}
	
	document.getElementById('commentBodyId').deleteRow($target_tr.index());

}
;function showTableComment(showType){
	switch(showType){
		case 'rsm':
			$('#rsmcmtid').show();
			$('#rsmbtncenterid').show();
			$('#asmcmtid').hide();
			break;
		case 'asm':
			$('#asmcmtid').show();
			$('#rsmcmtid').hide();
			$('#rsmbtncenterid').hide();
			break;
		default: break;
	}
}
;function showComment(target, year, definition_id){
	var hasLoad=false;
	if(map_cmtcatch.containsKey((definition_id+year))){
		$('#commentBodyId').append( map_cmtcatch.get((definition_id+year)) );
		hasLoad = true;
	}
	var el_tmp = document.getElementById('tmpvalid');
	el_tmp.innerHTML = $('#rsmHeadId td:eq('+$(target).parent().parent()[0].cellIndex+') span').text();
	el_tmp.setAttribute('did', definition_id);
	el_tmp.setAttribute('year', year);

	if(hasLoad){
		$('#popCtn').fadeIn('slow');
	    document.getElementById('popCmt').className='';
	    var $asmBody = $('#asmbodyid'), _category=$(target).parent().parent().parent()[0].getAttribute('category'),
	    		_key = (_category+definition_id+year.replace('-', '_'));

	    $asmBody.empty();
	    if(map_cmtasmcatch.containsKey(_key)){
	    		$asmBody.append($(map_cmtasmcatch.get(_key)));
	    }
	    loadingAnimate();
		return;
	}	
	var _category=$(target).parent().parent().parent()[0].getAttribute('category'),
		json = '{"cls1":"'+_category+'", "cls2":"'+definition_id+'", "cls3":"'+year.replace('-', '_')+'"}';
	
	$('[id*=cmtasmstrid]').val(json);
	$('[id*=cmtstrid]').val( '{\n"'+definition_id+'" : "'+year+'"\n}');	
	actionComments();	//this is action function
}
;function actionCommentsComplete(){
	$('#asmbodyid td.asmoverval').html(function(){
		var val=Globalize.format( roundToKM(numberOfZero($.trim(this.innerHTML))), 'n0');
		return val;
	});
	
	
	$('#commentBodyId input[type="text"].inputrsmval').val(function(){
		var val=Globalize.format( roundToKM(numberOfZero($.trim(this.value))), 'n0');
		return val;
	}).off('focus change').on('focus change', rsmCmtInput_eve);
	
	
	$('#popCtn').fadeIn('slow');
	document.getElementById('popTitle').innerHTML = document.getElementById('tmpvalid').innerHTML;
    document.getElementById('popCmt').className='';
    loadingAnimate();
}
;function rsmCmtInput_eve(e){
	var $this = $(this), ov = '', validation_qty = /^([1-9]\d{0,16}|0)(\.\d{1,2})?$/, 
		tv = Globalize.parseFloat($.trim(this.value)); //focus Event
    
    ov = $this.inputFocusKMT(validation_qty, e);

    if(e.type == 'change'){

        if($.trim(this.value) == ''){ 
            return; 
        }
        if(!validation_qty.test(tv) || (tv==ov && ov != '')){
            this.value = ( ov == '' ? '' : roundToKM(ov*1000) );
            return;
        }

        this.value = roundToKM( (tv*1000) );
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

        if(!validation_qty.test(tv) || (tv==ov && ov != '')){
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

;function saveItem(target){
    matchSaveData();    //push Global arrays
    
    if(list_gSave.length == 0){
        artMsg($label['notdata'], target, function(target){});
        return;
    }

    $('[id*=saveDataId]').val(list_gSave.shift());
    saveForecast();     //this is action function

    ;function matchSaveData(){
        var tmp, map_cells=new customMap(), $body=$('#rTabId'), list_save=[];
        $('#rsmHeadId td:not(.currentc):not(.historicalc):not(.cfixqtotalw)').each(function(){
            tmp={'cell':this.cellIndex, 'workingdays':this.getAttribute('workingdays'), 'fyear':(this.getAttribute('fyear')+'-'+this.getAttribute('fmonth'))};
            map_cells.put(this.cellIndex, tmp);
        });

        $body.find('tr.findTab').each(function(){
            var _row=this, _id=_row.getAttribute('ovid');
            for(var i=0, _cell; _cell=map_cells.keys()[i]; i++){
                var td_cell = _row.cells[_cell],
                    rsmforecast = numberTrimHasKMBTOfZero(typeof($(td_cell).find('input')[0]) != 'undefined' ? $(td_cell).find('input').val() : td_cell.innerHTML);
                    asmForecast = numberTrimHasKMBTOfZero($body.find('tr.oaft'+_id)[0].cells[_cell].innerHTML),
                    billings = numberTrimHasKMBTOfZero($body.find('tr.obling'+_id)[0].cells[_cell].innerHTML),
                    bookings = numberTrimHasKMBTOfZero($body.find('tr.obtb'+_id)[0].cells[_cell].innerHTML);

                tmp={'rsmforecast':rsmforecast, 'asmForecast':asmForecast, 'billings':billings, 'bookings': bookings,
                       'definition':_id, 'fiscalDate': map_cells.get(_cell).fyear};
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
;function saveForecastComplete(){
    if(list_gSave.length > 0){
        $('[id*=saveDataId]').val(list_gSave.shift());
        saveForecast();     //this is action function
        return;
    }
    saveComt();	//save catch comment
}
;function saveComt(){

	var strSave = '', map_tmp = new customMap(), isdel = false, issave = false;
	while(list_delcatch.length > 0){
		var _el=list_delcatch.shift(), tid=_el.getAttribute('did'), tyear=_el.getAttribute('dyear');
		strSave += '"'+tid+'": "'+tyear+'",';
	}
	if(strSave != ''){
		strSave = '{\n'+strSave.substring(0, strSave.length-1)+'\n}';
		isdel=true;
	}
	$('[id*=cmtdelid]').val(strSave);

	strSave = '';
	
	for(var i=0, max=map_cmtcatch.values().length; i<max; i+=1){
		var list_cmt=[], tid = '', tyear = '', list_el = map_cmtcatch.values()[i].toArray();
		while(list_el.length > 0){
			var _id,_year, _value, _cmt, _el = list_el.shift();
			if(_el.getAttribute('isv') == 'true'){
				tid=_el.getAttribute('did'), tyear=_el.getAttribute('dyear'),
				_value = $.trim(_el.cells[1].getElementsByClassName('valcls')[0].value), 
				_cmt = $.trim(_el.cells[2].getElementsByClassName('cmtcls')[0].value);
				if(_cmt != '' && _value != ''){
					list_cmt.push({"comment": _cmt, "value": numberOfZero(_value*1000)});
				}
			}
		}
		if(list_cmt.length > 0 && tid != '' && tyear != ''){
			var t = '';
			if(map_tmp.containsKey(tid)){
				t = (map_tmp.get(tid) + ',"'+tyear+'" : '+JSON.stringify(list_cmt));
				map_tmp.remove(tid);
			}else{
				t = '{"'+tyear+'" : '+JSON.stringify(list_cmt)+'';
			}
			map_tmp.put(tid, t);
		//	strSave +='"'+tid+'" : {"'+tyear+'" : '+JSON.stringify(list_cmt)+'},';
		}
	}

	map_cmtcatch.clear();		//clear RSM catch comment
	map_cmtasmcatch.clear();		//clear ASM catch comment
	
	if(map_tmp.size() != 0){
		for(var i=0, _key, _value; _key=map_tmp.keys()[i], _value=map_tmp.get(_key); i+=1){
			strSave += ('"'+_key+'":'+_value+ '},');
		}
		if(strSave != ''){
			strSave = '{\n'+strSave.substring(0, strSave.length-1)+'\n}';
		}
		map_tmp.clear();
	}

	if(strSave != ''){ issave=true; }
	$('[id*=cmtsaveid]').val(strSave);

	if((issave || isdel) || (issave && isdel)){
		saveComments();	//this ia action function
	}else{
		loadingAnimate();
	}
}

;function saveCommentsComplete(){
	loadingAnimate();
}
;function appendExpand_Collapse(){//append (expand or collapse)
    $('#rsmHeadId td.cfixqtotalw div').append('<b class="fold_box collapse">-</b>');
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


;function region_eve(target){   //Region select option event
    var op_val=$(target).find('option:selected').val();
    if(op_val == '' || op_val == 'none'){
        $('#psmsgid').removeClass('dn');
        $('#pcentdataid div.pcentercls').addClass('dn');
    }else{
        $('#psmsgid').addClass('dn');
        $('#pcentdataid div.pcentercls').addClass('dn');
        $(('#'+op_val)).removeClass('dn');
    }
}
;function tab_ov_eve(e){    //over out event
    var over_bg='bgov', _this=this, $this=$(_this), attr='tr'+($this.hasClass('sbcell')?'.sbcell.': ':not(.sbcell).' )+_this.getAttribute('ovid'),
    		$target = $(e.data.tab).find(attr);
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

;function pcenter_eve(e){   //pcenter over out event
    var $this=$(this), $pcenterData=$('#pcentdataid');
    eventHandle_ov_ot(e, ov, ot);
    
    ;function ov(e){
        $this.addClass('bgopov');
        $pcenterData.removeClass('dn');
    }
    ;function ot(e){
        $this.removeClass('bgopov');
        setTimeout(function () {
            if (!$pcenterData.hasClass('hover')) { $pcenterData.addClass('dn'); }
        }, 200);
    }
}
;function pcenterData_eve(e){   //Pcenter multiple selection event
    var $this=$(this);
    eventHandle_ov_ot(e, ov, ot);
    
    ;function ov(e){$this.addClass('hover');}
    ;function ot(e){$this.removeClass('hover').addClass('dn');}
}
;function searchrsm(target){
    var $option=$('#region_select option:selected'), region_val=$.trim($option.val());

    if(region_val=='' || region_val=='none'){
        artMsg($label.pleaseselect, target, function(target){});
        return;
    }
  //  document.getElementById('defidivid').className='dn';
    $('[id*=regionCentersId]').val( region_val );
    init();   //this is action function
    list_delcatch=[];
    map_cmtcatch.clear();
    map_cmtasmcatch.clear();		//clear ASM catch comment
}

;function initComplete(){   //action function complete
	var map_head = new customMap(), $body=$('#rTabId'), $head=$('#rsmHeadId');

	freshDocumentPage(false);
	
	setTimeout(function(){
	    createMap_head();
    		
		async.eachLimit($body.find('tr.findTab').toArray(), 1, pmfcResultBatch, function(err){
	    		connection_sql($('#querydiv input[type="hidden"]').toArray(), map_head, asynCheckingConnection);
		});
		
	}, 1800);
	
    
    ;function createMap_head(){
    		document.getElementById('connStatus_id').style.display='';
	    
    		var _divbox='', map_connection=new customMap(), $comp_box=$('#connbox').html('');
    		
		map_head.put('currency', $head.find('td.currentc.currentc1')[0].cellIndex);
	    map_head.put('workDay', getWorkDays($head.find('td.currentc.currentc1'), $head));
    		$head.find('td:not(.cfixqtotalw)').each(function(){
			var tmp_obj={'cellIndex':this.cellIndex, 'fYear':this.getAttribute('fyear'), 'fMonth':this.getAttribute('fmonth'), 'workDays':this.getAttribute('workingdays')};
	        map_head.put((tmp_obj.fYear+'-'+tmp_obj.fMonth), tmp_obj);
	        if(map_connection.containsKey(tmp_obj.fYear)){
	        		map_connection.get(tmp_obj.fYear).push(tmp_obj.fMonth);
	        }else{
	            map_connection.put(tmp_obj.fYear, [tmp_obj.fMonth]);
	        }
	    });
	    
	    for(var i=0, list_keys=map_connection.keys(), _keys; _keys=list_keys[i]; i++){
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
		_divbox='<div id="bbbm" class="bbb"><div class="connobj">'+window.$label['bbb']+'</div>'+_divbox+'</div>'+
				'<div id="schm" class="sch"><div class="connobj">'+window.$label['sch']+'</div>'+_divbox+'</div>';
	    $comp_box.html(_divbox);
	    _divbox='';
    }

    ;function pmfcResultBatch(_this, callback){

    		setTimeout(function(){
    			var pmfc = $.parseJSON(_this.getAttribute('pmfc')),
                el_pm = $body.find( ('tr.opmf'+_this.getAttribute('ovid')) )[0], hasProperty = false;
            
            for(var o in pmfc){ hasProperty = true; break;}
            if(pmfc != null && hasProperty){
                for(var i=0, max=_this.cells.length; i<max; i++){
                    var _td = _this.cells[i], month=_td.getAttribute('month');
                    if(typeof(pmfc[month]) != 'undefined'){
                        el_pm.cells[i].setAttribute('old', pmfc[month]);
                    }
                }
            }
	    		callback(null);
	    }, 460);
    }
    
    ;function connection_sql(list_input,map_head, callBackChecking){
		while(list_input.length > 0){
        		var hidden=list_input.shift();
            if(hidden.value != ''){
	            (function(){
		        		var json_sql = $.parseJSON(hidden.value), _id = hidden.id,
						used_id=(_id.lastIndexOf('BBBM') != -1 ? '#bbbm' : '#schm');
			        setTimeout(function(){
				        for(var i in json_sql){
				            connectionStatus[i] = false;
				            var source = {'type': _id, '$tab':$body, 'id': i, 'map_head': map_head, 'list_items':[], 'used_id':used_id, 'psql':json_sql[i]}, 
				            		callBack = {onSuccess: querySuccess, onFailure: queryFailure, source: source};
				            sforce.connection.query(json_sql[i], callBack); 
					        $( (used_id + ' li.'+(i.split('@')[1])) ).animate({backgroundColor: '#1F46E2'}, 460);
				        }
			        }, 100* Math.random() + 500);
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
        el_cc1=el_cc2=el_cc3=null;
        return t;
    }

}

;function asynCheckingConnection(map_head){
    var clearTimer = window.setInterval(function(){
        var isStop = true;

        for(var i in connectionStatus){ if(!connectionStatus[i]){ isStop = false; break; } }
    //    isStop=false;
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
            workingDaySumOf(map_head);
            lazyExecute(function(){ sumOf_initTotal(map_head); }, null, 500);
        }
    }, 1500);
}

;function querySuccess(result, source){
    
    if(typeof(result['size']) == 'undefined' || result['size'] == '0'){
        connectionStatus[source.id]=true;
        $( (source['used_id']+' li.'+source['id'].split('@')[1]) ).animate({backgroundColor: '#1FE26D'}, 100* Math.random() + 600);
        return;
    }

    var list_newResult=[], list_result=result["records"],
    		source_year=(source['id'].split('@')[1].replace('_', '-'));

    result['records']=null;   //clear sforce result record list
    
    source['list_items'] = source.$tab.find('tr.findTab').toArray();
    if(source['type'] == 'BBBM'){
        if($.isArray(list_result)){
	        while(list_result.length > 0){
	            list_newResult.push( getBBBMObject(list_result.shift(), source_year) );
	        }
    		}else{
    			list_newResult.push( getBBBMObject(list_result, source_year) );
    		}
        asynBBBMProcess(list_newResult, source);
    }else{
        if($.isArray(list_result)){
    			while(list_result.length > 0){
            		list_newResult.push( getScheduledObject(list_result.shift(), source_year) );
        		}
    		}else{
            list_newResult.push( getScheduledObject(list_result, source_year) );
    		}
        asynScheduledProcess(list_newResult, source);
    }

    list_newResult=null;

    ;function getScheduledObject(_result, _year){
        var o={'category':nullString(_result['Category']), 'salesteam':nullString(_result['SalesTeam']),
        			'amount':nullNumber(_result['forecast']), 'classification': nullString(_result['classification']), 'fYear': _year
              };
        return o;
    }

    
    ;function getBBBMObject(_result, _year){
        var o={ 'demandShipped':nullNumber(_result['Billings']), 'billings':nullNumber(_result['DemandShipped']), 
        		'center':nullString(_result['SAP_Profit_Center__c']), 'category': nullString(_result['Category']), 
            'salesteam':nullString(_result['SalesTeam']),/* 'backlog0':nullNumber(_result['Backlog0']), */ 'backlog0':nullNumber(_result['DemandOpen']),
            'book2bill':nullNumber(_result['Book2Bill']),
            'budgets':nullNumber(_result['Budgets']), 'currency1':nullNumber(_result['Currency1']),
            'currency2':nullNumber(_result['Currency2']), 'currency3':nullNumber(_result['Currency3']),
            'currency4':nullNumber(_result['Currency4']), 'amforecasts':nullNumber(_result['Forecasts']), /*'pmforecasts':nullNumber(_result['PreviousForecast']), */
            'accuracyQuarterly':nullNumber(_result['beginQuarterForecast']), 'accuracy2m':nullNumber(_result['month2Forecast']),
            'accuracy6m':nullNumber(_result['month6Forecast']), 'classification': nullString(_result['classification']), 'fYear': _year
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

	sforce.connection.query(source['psql'], callBack); 
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
;function asynScheduledProcess(list_result, source){
    var cell_tmp, cell_value_tmp, list_tmp, oItem_tmp, field_tmp;

    while(list_result.length > 0){
        var _result=list_result.shift();

        for(var j=0, _item; _item=source.list_items[j]; j++){
            oItem_tmp=getItemObject(_item);     //oItem_tmp is Interim method(asynResultProcess) variables
            if(_result['classification'] == oItem_tmp['classification'] && _result.category == '' && oItem_tmp.list_in.length ==0){
                list_tmp=source.$tab.find( ('tr.scheduled.osaisat'+oItem_tmp.id) ).toArray();
            //    $body.find(('tr.scheduled.osaisat'+oItem_tmp.id)).toArray();
                putMatchRow(_result, oItem_tmp, list_tmp, source['map_head'], _item);
            }else{
                if(_result['classification'] == oItem_tmp['classification'] && oItem_tmp.list_ex.length ==0){
                    if(_result['classification'] == oItem_tmp['classification'] && oItem_tmp.list_in.length == 0){
                        list_tmp=source.$tab.find( ('tr.scheduled.osaisat'+oItem_tmp.id) ).toArray();
                        putMatchRow(_result, oItem_tmp, list_tmp, source['map_head'], _item);
                    }else if(_result['classification'] == oItem_tmp['classification'] && _.contains(oItem_tmp.list_in, _result.category)){
                        list_tmp=source.$tab.find( ('tr.scheduled.osaisat'+oItem_tmp.id) ).toArray();
                        putMatchRow(_result, oItem_tmp, list_tmp, source['map_head'], _item);
                    }
                }else if(_result['classification'] == oItem_tmp['classification'] && !_.contains(oItem_tmp.list_ex, _result.category)){
                    if(_result['classification'] == oItem_tmp['classification'] && oItem_tmp.list_in.length == 0){
                        list_tmp=source.$tab.find( ('tr.scheduled.osaisat'+oItem_tmp.id) ).toArray();
                        putMatchRow(_result, oItem_tmp, list_tmp, source['map_head'], _item);
                    }else if(_result['classification'] == oItem_tmp['classification'] && _.contains(oItem_tmp.list_in, _result.category)){
                        list_tmp=source.$tab.find( ('tr.scheduled.osaisat'+oItem_tmp.id) ).toArray();
                        putMatchRow(_result, oItem_tmp, list_tmp, source['map_head'], _item);
                    }
                }
            }

        }
    }

    source['list_items']=null;
    connectionStatus[source.id]=true; 
    $( (source['used_id']+' li.'+source['id'].split('@')[1]) ).animate({backgroundColor: '#1FE26D'}, 100* Math.random() + 600);
    
    ;function putMatchRow(oResult, oItem, list_fields, map_year, $item){
        while(list_fields.length > 0){
            var tr_fields=list_fields.shift();
            if(oResult['amount'] == 'null'){ continue; }
            
            cell_tmp=tr_fields.cells[map_year.get(oResult.fYear)['cellIndex']];
            if(oResult.salesteam != '' && oItem.list_st.length != 0 && _.contains(oItem.list_st, oResult.salesteam) && $(tr_fields).hasClass('scheduled_in')){
                cell_value_tmp = cell_tmp.getAttribute('old');
                cell_value_tmp = roundFn(accAdd(numberOfZero(cell_value_tmp), oResult['amount']), 2);
                cell_tmp.setAttribute('old', cell_value_tmp);
            }else {
                cell_tmp = $(tr_fields).next()[0].cells[cell_tmp.cellIndex];
                cell_value_tmp = cell_tmp.getAttribute('old');
                cell_value_tmp = roundFn(accAdd(numberOfZero(cell_value_tmp), oResult['amount']), 2);
                cell_tmp.setAttribute('old', cell_value_tmp);
            }
        }
    }
}

;function asynBBBMProcess(list_result, source){
    var fn={'pmforecasts':pmforecasts, 'amforecasts':amforecasts, 'billings':billings, 
            'book2bill': book2bill, 'backlog0':backlog0, 'currency':currency, 
            'accuracy2m': accuracy2m, 'accuracy6m': accuracy6m, 'accuracyQuarterly': accuracyQuarterly},
		cell_tmp, cell_value_tmp, list_tmp, oItem_tmp, field_tmp;

    while(list_result.length > 0){
        var _result=list_result.shift();
        for(var j=0, _item; _item=source.list_items[j]; j++){
            oItem_tmp=getItemObject(_item);     //oItem_tmp is Interim method(asynResultProcess) variables
            
            if(_result['classification'] == oItem_tmp['classification'] && _result.category == '' && oItem_tmp.list_in.length ==0){
                list_tmp=source.$tab.find(('tr.eachtr'+oItem_tmp.id+':not(.scheduled)')).not('.not_oth').toArray();
                putMatchRow(_result, oItem_tmp, list_tmp, source['map_head'], _item);
            }else{
                if(_result['classification'] == oItem_tmp['classification'] && oItem_tmp.list_ex.length ==0){
                    if(_result['classification'] == oItem_tmp['classification'] && oItem_tmp.list_in.length == 0){
                        list_tmp=source.$tab.find(('tr.eachtr'+oItem_tmp.id+':not(.scheduled)')).not('.not_oth').toArray();
                        putMatchRow(_result, oItem_tmp, list_tmp, source['map_head'], _item);
                    }else if(_result['classification'] == oItem_tmp['classification'] && _.contains(oItem_tmp.list_in, _result.category)){
                        list_tmp=source.$tab.find(('tr.eachtr'+oItem_tmp.id+':not(.scheduled)')).not('.not_oth').toArray();
                        putMatchRow(_result, oItem_tmp, list_tmp, source['map_head'], _item);
                    }
                }else if(_result['classification'] == oItem_tmp['classification'] && !_.contains(oItem_tmp.list_ex, _result.category)){
                    if(_result['classification'] == oItem_tmp['classification'] && oItem_tmp.list_in.length == 0){
                        list_tmp=source.$tab.find(('tr.eachtr'+oItem_tmp.id+':not(.scheduled)')).not('.not_oth').toArray();
                        putMatchRow(_result, oItem_tmp, list_tmp, source['map_head'], _item);
                    }else if(_result['classification'] == oItem_tmp['classification'] && _.contains(oItem_tmp.list_in, _result.category)){
                        list_tmp=source.$tab.find(('tr.eachtr'+oItem_tmp.id+':not(.scheduled)')).not('.not_oth').toArray();
                        putMatchRow(_result, oItem_tmp, list_tmp, source['map_head'], _item);
                    }
                }
            }
        }
    }

    field_tmp=cell_tmp=cell_value_tmp=list_tmp=oItem_tmp=list_result=source['list_items']=null;

    setTimeout(function(){
        $( (source['used_id']+' li.'+source['id'].split('@')[1]) ).animate({backgroundColor: '#1FE26D'}, 100* Math.random() + 600);
        connectionStatus[source.id]=true; 
    },500);


    ;function putMatchRow(oResult, oItem, list_fields, map_year, $item){
        while(list_fields.length > 0){
            var tr_fields=list_fields.shift();
            field_tmp=tr_fields.getAttribute('fn'); //field_tmp is js function name

            if(field_tmp != 'currency'){    //if the not (Current Month)
                cell_tmp=tr_fields.cells[map_year.get(oResult.fYear)['cellIndex']];
            }
            fn[field_tmp](oResult, oItem, cell_tmp, tr_fields, cell_value_tmp, field_tmp, map_year);
        }
    }
    
    ;function pmforecasts(oResult, oItem, td_element, tr_element, cell_value, field){
        /*
        if(oResult[field] != 'null'){
            td_element.setAttribute('old', roundFn( (numberOfZero(td_element.getAttribute('old'))+oResult[field]), 2));
        }
        */
    }
    ;function budgets(oResult, oItem, td_element, tr_element, cell_value, field){
        if(oResult[field] != 'null'){
            td_element.setAttribute('old', roundFn( (numberOfZero(td_element.getAttribute('old'))+oResult[field]), 2));
        }
    }
    
    ;function amforecasts(oResult, oItem, td_element, tr_element, cell_value, field){
        common_teamSum(oResult, oItem, td_element, tr_element, cell_value, field);
    }

    ;function billings(oResult, oItem, td_element, tr_element, cell_value, field){//Billing -> Demand shipped
        
        if(oResult['demandShipped'] != 'null'){//this is billing value
        		var el_bill = $('#rTabId tr.obling'+oItem['id'])[0].cells[td_element.cellIndex],
        			bill_v = numberOfZero(el_bill.getAttribute('billing'));
        		el_bill.setAttribute('billing', (bill_v+oResult['demandShipped']));
        }
        
        common_teamSum(oResult, oItem, td_element, tr_element, cell_value, field);//this is demandShipped value
    }
    ;function book2bill(oResult, oItem, td_element, tr_element, cell_value, field){
        if(oResult[field] != 'null'){
            td_element.setAttribute('old', roundFn( (numberOfZero(td_element.getAttribute('old'))+oResult[field]), 2));
        }
    }
    ;function backlog0(oResult, oItem, td_element, tr_element, cell_value, field, map_year){//Backlog: Demand open
        common_teamSum(oResult, oItem, td_element, tr_element, cell_value, field);
    }
    
    ;function currency(oResult, oItem, td_element, tr_element, cell_value, field, map_year){
        if(oResult.salesteam !='' && oItem.list_st.length !=0 && _.contains(oItem.list_st, oResult.salesteam) && $(tr_element).hasClass( (field+'_in') )){
            td_element = tr_element.cells[map_year.get(oResult.fYear)['cellIndex']];
            common_currency(td_element, oResult);
        }else {
            td_element = $(tr_element).next()[0].cells[map_year.get(oResult.fYear)['cellIndex']];
            common_currency(td_element, oResult);
        }
    }
    
    ;function accuracy2m(oResult, oItem, td_element, tr_element, cell_value, field){
        if(oResult[field] != 'null' &&  td_element.cellIndex < source['map_head'].get('currency')){
            td_element.setAttribute('old', roundFn( (numberOfZero(td_element.getAttribute('old'))+oResult[field]), 2));
        }
    }
    ;function accuracy6m(oResult, oItem, td_element, tr_element, cell_value, field){
        if(oResult[field] != 'null' && td_element.cellIndex < source['map_head'].get('currency')){
            td_element.setAttribute('old', roundFn( (numberOfZero(td_element.getAttribute('old'))+oResult[field]), 2));
        }
    }
    ;function accuracyQuarterly(oResult, oItem, td_element, tr_element, cell_value, field){
        if(oResult[field] != 'null' && td_element.cellIndex < source['map_head'].get('currency')){
            td_element.setAttribute('old', roundFn( (numberOfZero(td_element.getAttribute('old'))+oResult[field]), 2));
        }
    }

    ;function common_teamSum(oResult, oItem, td_element, tr_element, cell_value, field){
        if(oResult[field] != 'null'){
            if(oItem.list_st.length !=0 && oResult.salesteam != '' && _.contains(oItem.list_st, oResult.salesteam) && $(tr_element).hasClass( (field+'_in') )){
                cell_value = roundFn( numberOfZero(td_element.getAttribute('old'))+ oResult[field] , 2);
                td_element.setAttribute('old', cell_value);
            }else{
                td_element = $(tr_element).next()[0].cells[td_element.cellIndex];
                cell_value = roundFn( numberOfZero(td_element.getAttribute('old'))+ oResult[field] , 2);
                td_element.setAttribute('old', cell_value);
            }
        }
    }
    ;function common_currency(td_element, oResult){
        var c1=td_element.getAttribute('c1'), c2=td_element.getAttribute('c2'), c3=td_element.getAttribute('c3'), c4=td_element.getAttribute('c4');
        if(oResult['currency1'] != 'null'){
            td_element.setAttribute('c1', roundFn(numberOfZero(c1)+oResult['currency1'], 2));
        }
        if(oResult['currency2'] != 'null'){
            td_element.setAttribute('c2', roundFn(numberOfZero(c2)+oResult['currency2'], 2));
        }
        if(oResult['currency3'] != 'null'){
            td_element.setAttribute('c3', roundFn(numberOfZero(c3)+oResult['currency3'], 2));
        }
        if(oResult['currency4'] != 'null'){
            td_element.setAttribute('c4', roundFn(numberOfZero(c4)+oResult['currency4'], 2));
        }
    }
}

;function workingDaySumOf(map_head){
	//var field_tmp=map_head.get('workDay'), list_batch=$('＃rTabId tr.currency').toArray();
	var field_tmp=map_head.get('workDay'), list_batch=$('#rTabId tr.currency').toArray();
    while(list_batch.length > 0){//currency working days setAttribute
        var oItem_tmp=list_batch.shift(),
        		nm0=oItem_tmp.cells[field_tmp.nm0], nm1=oItem_tmp.cells[field_tmp.nm1], 
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

;function getItemObject(_item){
    var o={ 'id':_item.getAttribute('ovid'),
            'center':nullString(_item.getAttribute('profitcenter')), 
            'category':undefinedArray(_item.getAttribute('category')), 
            'classification':nullString(_item.getAttribute('classification')), 
            'list_ex':undefinedArray(_item.getAttribute('categoryexclude')), 
            'list_in':undefinedArray(_item.getAttribute('categoryinclude')), 
            'list_st':undefinedArray(_item.getAttribute('industrialsalesteaminclude'))};
    return o;
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

;function delay_fn(el_tr, callBack){
    var i=0, len=el_tr.cells.length;
    (function(){
        if(i>=len){ return; }
        callBack(i, el_tr);
        i+=1;
        window.setTimeout(arguments.callee,65);
    })();
}
;function finall_Format($body, map_head){
    var $head=$('#rsmHeadId');
    
    map_head.put('ftuIndx', $head.find('td._cnm0')[0].cellIndex);
    	map_head.put('currentMaxTotal', (map_head.get('ftuIndx')-1) );
    	
    var findcls='tr.findTab, tr.not_total';
    	timedProcess1(fmtRow1, null, function(){ }, $body.find(findcls).toArray());
    	
    	findcls='tr.amforecast, tr.bcamfc, tr.amforecasts, tr.findamfc, tr.amfc, tr.pmforecasts, tr.bcpmfc, tr.findpmfc';
    	timedProcess1(fmtRightRow, null, fmtComplete, $body.find(findcls).toArray());
    	
    	findcls='tr.bcblog, tr.bcblogorder, tr.findblog, tr.findblogorder, tr.blogorder, tr.findblog, tr.backlog, tr.orderbacklog, tr.backlog0, tr.bcblogsched, tr.blogsched, tr.findblogsched, tr.backlogscheduled, tr.scheduled';
    	timedProcess1(fmtRow, null, fmtComplete, $body.find(findcls).toArray());

    	findcls='tr.gtcurrency, tr.currency, tr.findcurrencytotal, tr.currencytotal, tr.bccurrencytotal';
    	timedProcess1(fmtCurrencyRow, null, fmtComplete, $body.find(findcls).toArray());
    	
    	findcls='tr.percent, tr.percenttotal';
    	timedProcess1(fmtPercentageRow, null, fmtComplete, $body.find(findcls).toArray());
    	
    	findcls='tr.billing, tr.billings, tr.findbling, tr.bling, tr.bcbling';
    	timedProcess1(fmtRow, null, fmtComplete, $body.find(findcls).toArray());
    	
    	findcls='tr.findTab';
    	timedProcess1(fmtColorRow, null, loadingAnimate, $body.find(findcls).toArray());	//set colors
    	
    	findcls='tr.findbtb, tr.book2bill, tr.bcbtb';
    	timedProcess1(function(row){		//set Book to Bill
	    	if(typeof(row) != 'undefined'){
	    	//	$(row).find('td:gt('+(map_head.get('ftuIndx')-1)+')').addClass('nobg');	//add right color
	    		delay_left_fn(map_head.get('ftuIndx')-1, row, function(callIndex, target){
	            var _cell = target.cells[callIndex];
				_cell.innerHTML = Globalize.format( numberOfZero(_cell.getAttribute('old')), 'n' );
	        });
	    }
    	}, null, fmtComplete, $body.find(findcls).toArray());
    	
	;function fmtPercentageRow(row){
		if(typeof(row) != 'undefined'){
	    	//	$(row).find('td:gt('+(map_head.get('ftuIndx')-1)+')').addClass('nobg');	//add right color
	    		delay_left_fn(map_head.get('ftuIndx')-1, row, function(callIndex, target){
	            var _cell = target.cells[callIndex];
				_cell.innerHTML = Globalize.format( numberOfZero(_cell.getAttribute('old')), 'n0' )+ '%';
	        });
	    }
    	}
    	;function fmtCurrencyRow(row){
	    	if(typeof(row) != 'undefined'){
	    	//	$(row).find('td:lt('+map_head.get('currency')+')').addClass('nobg');	//add left color
	    		for(var i=map_head.get('currency'), max=map_head.get('ftuIndx')+3; i<=max; i++){
	    			var _cell = row.cells[i];
				_cell.innerHTML = roundToKM( numberOfZero(_cell.getAttribute('old')) );
	    		}
	    }
    	}
    	;function fmtLeftRow(row){
    		if(typeof(row) != 'undefined'){
    		//	$(row).find('td:gt('+(map_head.get('ftuIndx')-1)+')').addClass('nobg');	//add right color
	    		delay_left_fn(map_head.get('ftuIndx')-1, row, function(callIndex, target){
	            var _cell = target.cells[callIndex];
				_cell.innerHTML = roundToKM( numberOfZero(_cell.getAttribute('old')) );
	        });
    		}
    		
    	}
	;function fmtRightRow(row){
		if(typeof(row) != 'undefined'){
	    	//	$(row).find('td:lt('+map_head.get('currency')+')').addClass('nobg');	//add left color
	    		delay_right_fn(map_head.get('currency'), row, function(callIndex, target){
	            var _cell = target.cells[callIndex];
				_cell.innerHTML = roundToKM( numberOfZero(_cell.getAttribute('old')) );
	        });
	    	}
    	}
    	
    	;function fmtColorRow(row){
	    	if(typeof(row) != 'undefined'){
	    		delay_right_fn((map_head.get('currency')+1), row, function(callIndex, target){
	            var _cell = target.cells[callIndex],
	            //($(target.cells[(callIndex-1)]).hasClass('cfixqtotalw') ? target.cells[callIndex-2] : target.cells[callIndex-1]), 
		            val = numberOfZero(_cell.getAttribute('old')),
	            		asm_val = numberOfZero( $(row).next().next()[0].cells[callIndex].getAttribute('old') );
				animateColors($(target.cells[callIndex]), val, asm_val);
	        });
	    }
    }
    ;function fmtRow(row){
    		delay_fn(row, function(callIndex, target){
            var _cell = target.cells[callIndex], _v = roundToKM( numberOfZero(_cell.getAttribute('old')) ),
            		$input = $(_cell).find('input[type="text"]');
            if(typeof($input[0]) != 'undefined' ){ $input.val(_v); }
            else{ _cell.innerHTML = _v; }
        });
    	}
    	
    ;function fmtRow1(row){
    		delay_fn(row, function(callIndex, target){
            var _cell = target.cells[callIndex], _v = roundToKM( numberOfZero(_cell.getAttribute('old')) ),
            		$input = $(_cell).find('input[type="text"]');
            if(typeof($input[0]) != 'undefined' ){ $input.val(_v); }
            else{ 
	            $(_cell).append(_v);
	            /*
	            .html(function(){
	            	//	$(this).find('img').addClass('fixfreeimg');
	            		return (this.innerHTML + _v);
	            	});
	            	*/
	            	//.find('img').hoverDelay({hoverEvent: hoverEvent_eve, hoverDuring: 800,outEvent: outEvent_eve,outDelay: 200}); 
            	}
        });
    	}
    ;function fmtComplete(){
    	
    }
}
;function animateColors($el, gsm_val, rsm_val){
	rsm_val=(roundFn(rsm_val/1000, 0) == 0 ? 0 : rsm_val);
	if(!$el.hasClass('cfixqtotalw') && (gsm_val == 0 && rsm_val == 0)){
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
			            		if(typeof(isEdit) == 'undefined' || isEdit==null){
			            			$(this).css({'color':'#fff'});
			            		}
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
							if(typeof(isEdit) == 'undefined' || isEdit==null){
			        		 		$(this).css({'color':'#fff'});
			        		 	}
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
			        		 	if(typeof(isEdit) == 'undefined' || isEdit==null){
			        		 		$(this).css({'color':'#fff'});
			        		 	}
						}).find('img').removeClass('cmtimg').addClass('commentimg');
					}
		        		break;
		        }
            }
	    }
    }
}
;function sumOf_initTotal(map_head){

    var tmp_cls, $body=$('#rTabId'), list_subRow=$body.find('tr.subrow').toArray(), 
        $trTeam=$body.find('tr.sbcell'), cellCls='td.cfixmonthw, td.cfixcurentmonthw';
    
    sumOf_SubCell(list_subRow.slice(0), cellCls, $trTeam, true);  //all sales team sum of cell
    
    sumOf_SubCell($body.find('tr.backlog').toArray(), cellCls, $(list_subRow), false);    //all Backlog sum of cell
    
    sumOf_RowsCell($body.find('tr.findTab').toArray(), cellCls, $body);   //all records cell total
    
    $trTeam=cellCls=tmp_cls=list_subRow=undefined;
    
    sumOf_QtotalCell($body.find('td.cfixqtotalw').toArray());    
    sumOf_AccuracyPercent($body.find('tr.percent').toArray(), $body);
    
	sumOf_ABC_Total($body);
	lazyExecute(function(){ sumOf_initFields_Total($body, map_head); }, null, 500);
    
    
    ;function sumOf_ABC_Total($body){
        var i, el_tmp, list_a = [], list_b = [], list_ab = [], list_c = [],
            _total=document.getElementById('abTotalId'), cell_length=_total.cells.length;

        sumOf_CommonTotal(list_a, $body, 'tr.faTab', 'faTabId', cell_length, i, el_tmp);
        sumOf_CommonTotal(list_b, $body, 'tr.fbTab', 'fbTabId', cell_length, i, el_tmp);
        sumOf_CommonTotal(list_c, $body, 'tr.fcTab', 'fcTabId', cell_length, i, el_tmp);

        sumOf_CommonArgTotal(list_a, list_b, list_c, list_ab, cell_length, _total, i);
    }
    
    ;function sumOf_CommonArgTotal(list_a, list_b, list_c, list_ab, cell_length, el_total, i){
        for(i=0; i<cell_length; i++){
            list_ab[i] = accAdd((typeof(list_a[i])== 'undefined' ? 0 : list_a[i]), (typeof(list_b[i])== 'undefined' ? 0 : list_b[i]));
            el_total.cells[i].setAttribute('old', list_ab[i]);
        }
        list_a=list_b=null;   //clear
        el_total = document.getElementById('bcTotalId');
        for(i=0; i<cell_length; i++){
            el_total.cells[i].setAttribute('old', accAdd((typeof(list_c[i])== 'undefined' ? 0 : list_c[i]), list_ab[i]));
        }
        el_total=list_ab=list_c=null;
    }
    
    ;function sumOf_CommonTotal(list_t, $body, cls, el_id, cell_length, i, el_tmp){
        $body.find(cls).each(function(){
            el_tmp=this;
            for(i=0; i<cell_length; i++){
                list_t[i] = (typeof(list_t[i]) == 'undefined' ? 0 : list_t[i]);
                list_t[i] = accAdd( list_t[i], numberOfZero(el_tmp.cells[i].getAttribute('old')) );
            }
        });
        el_tmp = document.getElementById(el_id);
        for(i=0; i<cell_length; i++){
            el_tmp.cells[i].setAttribute('old', (typeof(list_t[i])== 'undefined' ? 0 : ceilFn(list_t[i], 2)));
        }
        el_tmp=null;
    }
    
    ;function sumOf_AccuracyPercent(list_percent, $body){
    		var c_cellIndex=$('#rsmHeadId td.futurec.currentc1.cfixqtotalw')[0].cellIndex;
        while(list_percent.length > 0){
            var tr_percent=list_percent.shift(), tr_open=$body.find('tr.oblog'+tr_percent.getAttribute('pid'))[0],
            		tr_shipped = $body.find('tr.obling'+tr_percent.getAttribute('pid'))[0];
            for(var j=0; j<=c_cellIndex; j++){
                var el_percent=tr_percent.cells[j], _percent=numberOfZero( el_percent.getAttribute('old') ),
                		shipped=numberOfZero( tr_shipped.cells[j].getAttribute('old') ),
                		open=numberOfZero( tr_open.cells[j].getAttribute('old') );

            		open=(shipped+open);
                el_percent.setAttribute('old', ( open !=0 ? ceilFn(_percent/open, 0) : 0 ));
            }
        }
    }
    
    ;function sumOf_QtotalCell(list_qTotal){
        while(list_qTotal.length > 0){
            var _qTotal=list_qTotal.shift(), t='null', _tr = _qTotal.parentNode, _cell=_qTotal.cellIndex,
                v1=_tr.cells[_cell-1].getAttribute('old'), v2=_tr.cells[_cell-2].getAttribute('old'), 
                v3=_tr.cells[_cell-3].getAttribute('old');
                
            if(v1 != 'null'){ t = accAdd((t=='null'?0:t), numberOfZero(v1)); }
            if(v2 != 'null'){ t = accAdd((t=='null'?0:t), numberOfZero(v2)); }
            if(v3 != 'null'){ t = accAdd((t=='null'?0:t), numberOfZero(v3)); }
            if(t !='null'){_qTotal.setAttribute('old', ceilFn(t, 2));}
            if($(_tr).hasClass('billing')){	//billing - minghao.li
            		t = 'null';
            		v1=_tr.cells[_cell-1].getAttribute('billing');
                v2=_tr.cells[_cell-2].getAttribute('billing');
                v3=_tr.cells[_cell-3].getAttribute('billing');
	            if(v1 != 'null'){ t = accAdd((t=='null'?0:t), numberOfZero(v1)); }
	            if(v2 != 'null'){ t = accAdd((t=='null'?0:t), numberOfZero(v2)); }
	            if(v3 != 'null'){ t = accAdd((t=='null'?0:t), numberOfZero(v3)); }
	            if(t !='null'){_qTotal.setAttribute('billing', ceilFn(t, 2));}
            }
        }
    }
    
    ;function sumOf_RowsCell(list_row, cellCls, $body){
        while(list_row.length > 0){
            var _row = list_row.shift(), list_tdTotal_cell = $(_row).find(cellCls).toArray(),
                managerfc = $.parseJSON(_row.getAttribute('managerfc'));
            tmp_cls = _row.getAttribute('ovid');

			
            var el_bling = $body.find( ('tr.obling'+tmp_cls) )[0], 
                el_pmforecast = $body.find( ('tr.pm'+tmp_cls) )[0], 
                el_amforecast = $body.find( ('tr.am'+tmp_cls) )[0];
                
            while(list_tdTotal_cell.length > 0){
                var _td=list_tdTotal_cell.shift(), _cell=_td.cellIndex, month=_td.getAttribute('month'),
                    bling_cell_val = el_bling.cells[_cell].getAttribute('old'),
                    pm_cell_val = el_pmforecast.cells[_cell].getAttribute('old'),
                    am_cell_val = el_amforecast.cells[_cell].getAttribute('old');

                if( _cell >= map_head.get('currency') ){
                    var t = (typeof(managerfc[month]) == 'undefined' ? 'null' : managerfc[month]);
                    t = (t != 'null' ? t : 0);
                    _td.setAttribute( 'old', t );
                }else{
                    if(pm_cell_val != 'null' && pm_cell_val != '0'){  //2014-11-13 edit minghao.li@itbconsult.com
                        _td.setAttribute('old',  pm_cell_val);
                    }else{
                        bling_cell_val = ( bling_cell_val != 'null' ? bling_cell_val : (pm_cell_val != 'null' ? pm_cell_val : am_cell_val) );
                        _td.setAttribute('old',  bling_cell_val);
                    }
                }
            }
            /*
            var el_bling = $body.find( ('tr.obling'+tmp_cls) )[0], 
                el_pmforecast = $body.find( ('tr.pm'+tmp_cls) )[0], 
                el_amforecast = $body.find( ('tr.am'+tmp_cls) )[0];
            while(list_tdTotal_cell.length > 0){
                var _td=list_tdTotal_cell.shift(), _cell=_td.cellIndex, month=_td.getAttribute('month'),
                    bling_cell_val = el_bling.cells[_cell].getAttribute('old'),
                    pm_cell_val = el_pmforecast.cells[_cell].getAttribute('old'),
                    am_cell_val = el_amforecast.cells[_cell].getAttribute('old');

                if( _cell >= map_head.get('currency') ){
                    var t = (typeof(managerfc[month]) == 'undefined' ? 'null' : managerfc[month]);
                    t = (t != 'null' ? t : (pm_cell_val > 0 ? pm_cell_val : am_cell_val));
                    _td.setAttribute( 'old', t );
                }else{
                    bling_cell_val = ( bling_cell_val != 'null' ? bling_cell_val : (pm_cell_val != 'null' ? pm_cell_val : am_cell_val) );
                    _td.setAttribute('old',  bling_cell_val);
                }
            }
            */
        }
    }

    ;function sumOf_SubCell(list_subRow, cellCls, $items, isTeam){
        while(list_subRow.length > 0){
            var _row=list_subRow.shift(), list_tdTotal_cell, list_trs_cell;
            if(isTeam){//is sales Team
                tmp_cls=( '.'+_row.getAttribute('cls')+'.eachtr'+_row.getAttribute('sid') );
            }else{  //is Backlog
                tmp_cls=( '.'+_row.getAttribute('blid') );
            }
            list_tdTotal_cell=$(_row).find(cellCls).toArray();  //the sub row cell
            list_trs_cell=$items.filter( tmp_cls ).toArray();   //the sub rows and cells total

            while(list_tdTotal_cell.length > 0){
                var _val='null', _cell=list_tdTotal_cell.shift();
                for(var i=0, _tr_cell; _tr_cell=list_trs_cell[i]; i+=1){
                    var td_cell=_tr_cell.cells[_cell.cellIndex];
                    if(td_cell.getAttribute('old') != 'null'){
                        _val = accAdd((_val=='null'?0:_val), numberOfZero( td_cell.getAttribute('old') ));
                    }
                }
                _cell.setAttribute('old', (_val == 'null' ? 'null' : ceilFn(_val, 2)) );
            }
        }
    }
}
;function sumOf_initFields_Total($body, map_head){
    var fn={'pmfc':pmfc, 'amfc':amfc, 'amfcin':amfcin, 'amfcoth':amfcoth, 'bling':bling, 'blingin':blingin,
            'blingoth':blingoth, 'btb':btb, 'blog':blog, 'blogorder':blogorder, 'blogorderin':blogorderin,
            'blogorderoth':blogorderoth, 'currencytotal':currencytotal, 'currencytotalin':currencytotalin, 
            'currencytotaloth':currencytotaloth, 'ac2m':ac2m, 'ac6m':ac6m, 'acquart':acquart,
            'blogsched':blogsched, 'blogschedoth':blogschedoth, 'blogschedin':blogschedin},
        list_tmp, tmp;

    sumOf_Fields_Total($body.find('tr.aTotal').toArray(), 'tr.acls', false);   //A Total
    sumOf_Fields_Total($body.find('tr.bTotal').toArray(), 'tr.bcls', false);   //B & Other BU Total
    sumOf_Fields_Total($body.find('tr.cTotal').toArray(), 'tr.ccls', false);   //Channel Total
    
    sumOf_Fields_Total($body.find('tr.abTotal').toArray(), 'tr.aTotal, tr.bTotal', true);  //A + B = Total Direct
    sumOf_Fields_Total($body.find('tr.bcTotal').toArray(), 'tr.abTotal, tr.cTotal', true);   //Total Direct + Total Channel = Total
    
    sumOf_Fields_Percent($body.find('tr.aTotal.percenttotal').toArray(), document.getElementById('faTabId') );
    sumOf_Fields_Percent($body.find('tr.bTotal.percenttotal').toArray(), document.getElementById('fbTabId') );
    sumOf_Fields_Percent($body.find('tr.cTotal.percenttotal').toArray(), document.getElementById('abTotalId') );
    sumOf_Fields_Percent($body.find('tr.abTotal.percenttotal').toArray(),document.getElementById('fcTabId') );
    sumOf_Fields_Percent($body.find('tr.bcTotal.percenttotal').toArray(),document.getElementById('bcTotalId') );
    
    list_tmp=tmp=fn=null;
    list_tmp = [];
	sumOf_Fields_Billing(document.getElementById('faTabId'), $body.find('tr.acls.billing').toArray(), list_tmp);
	sumOf_Fields_Billing(document.getElementById('fbTabId'), $body.find('tr.bcls.billing').toArray(), list_tmp);
	sumOf_Fields_Billing_total(document.getElementById('abTotalId'), list_tmp);
	sumOf_Fields_Billing(document.getElementById('fcTabId'), $body.find('tr.ccls.billing').toArray(), list_tmp);
	sumOf_Fields_Billing_total(document.getElementById('bcTotalId'), list_tmp);
    list_tmp=[];
    
    booktoBill($body.find('tr.book2bill').toArray(), $body);
    
    booktoBillTotal($body.find('tr.aTotal.findbtb')[0], document.getElementById('faTabId'));
    booktoBillTotal($body.find('tr.bTotal.findbtb')[0], document.getElementById('fbTabId'));
    booktoBillTotal($body.find('tr.abTotal.findbtb')[0], document.getElementById('abTotalId'));
    booktoBillTotal($body.find('tr.cTotal.findbtb')[0], document.getElementById('fcTabId'));
    booktoBillTotal($body.find('tr.bcTotal.bcbtb')[0], document.getElementById('bcTotalId'));
    
    /*
    booktoBillTotal($body.find('tr.aTotal.findbtb')[0], $body.find('tr.aTotal.findbling')[0]);
    booktoBillTotal($body.find('tr.bTotal.findbtb')[0], $body.find('tr.bTotal.findbling')[0]);
    booktoBillTotal($body.find('tr.abTotal.findbtb')[0], $body.find('tr.abTotal.findbling')[0]);
    booktoBillTotal($body.find('tr.cTotal.findbtb')[0], $body.find('tr.cTotal.findbling')[0]);
    booktoBillTotal($body.find('tr.bcTotal.bcbtb')[0], $body.find('tr.bcTotal.bcbling')[0]);
	*/
    
    finall_Format($body, map_head);
    ;function sumOf_Fields_Billing_total(el_total, list_t){
    		for(var i=0, max=list_t.length; i<max; i++){
    			el_total.cells[i].setAttribute('billing', list_t[i]);
    		}
    }
    ;function sumOf_Fields_Billing(el_total, list_bilings, list_tmp){
    		while(list_bilings.length > 0){
    			var el_billing = list_bilings.shift();
    			for(var i=0, max=el_billing.cells.length; i<max; i++){
    				var tmp=el_billing.cells[i].getAttribute('billing');
	            list_tmp[i] = (typeof(list_tmp[i]) == 'undefined' ? 'null' : list_tmp[i]);
	            if(tmp != 'null'){
	                list_tmp[i]= accAdd(numberOfZero(list_tmp[i]), numberOfZero(tmp));
	            }
    			}
    		}
    		for(var i=0, max=list_tmp.length; i<max; i++){
    			el_total.cells[i].setAttribute('billing', list_tmp[i]);
    		}
    }
    ;function booktoBillTotal(bill_tr, billing_tr){
        for(var i=0, _td, billing_td; _td=bill_tr.cells[i], billing_td=billing_tr.cells[i]; i+=1){
            var old = parseFloat(_td.getAttribute('old')), billing_old = parseFloat(billing_td.getAttribute('billing'));
            if($.isNumeric(billing_old) && billing_old != 0){
                old = ($.isNumeric(old) ? old : 0);
                _td.setAttribute('old', ceilFn(old/billing_old, 2));
            }else{
            		_td.setAttribute('old', 0);
            }
        }
    }
    
    ;function booktoBill(list_trs, $body){  // (Book to Bill/Billings)
        while(list_trs.length > 0){
            var bill_trs = list_trs.shift(), billing_trs = $body.find( ('tr.obling'+bill_trs.getAttribute('ovid').replace('obtb', '')) )[0];
            for(var i=0, _td, billing_td; _td=bill_trs.cells[i], billing_td=billing_trs.cells[i]; i+=1){
                var old = parseFloat(_td.getAttribute('old')), billing_old = parseFloat(billing_td.getAttribute('billing'));
                if($.isNumeric(billing_old) && billing_old != 0){
                    old = ($.isNumeric(old) ? old : 0);
                    _td.setAttribute('old', ceilFn(old/billing_old, 2));
                }else{
                		_td.setAttribute('old', 0);
                }
            }
        }
    }
    
    ;function sumOf_Fields_Percent(list_trs, tr_bling){
    		var c_cellIndex=$('#rsmHeadId td.futurec.currentc1.cfixqtotalw')[0].cellIndex;
        for(var i=0, _percent; _percent=list_trs[i]; i++){
            for(var j=0; j<=c_cellIndex; j+=1){
                var el_percent=_percent.cells[j], el_p=el_percent.getAttribute('old'),
                    el_bling=tr_bling.cells[j], el_b=el_bling.getAttribute('billing');
                el_p=numberOfZero(el_p);    
                el_b=numberOfZero(el_b);
                el_percent.setAttribute('old', ( el_b !=0 ? ceilFn(el_p/el_b, 0) : 0 ));
            }
        }
        tr_bling=list_trs=null;
    }
    
    
    ;function sumOf_Fields_Total(list_trs, cls, isTotal){
        var list_batch=[];
        for(var i=0, max=list_trs.length; i<max; i+=5){
            list_batch.push( list_trs.slice(i, i+5) );
        }
        list_trs=null;
        while(list_batch.length > 0){
            var list_stmp=list_batch.shift();
            while(list_stmp.length > 0){
                var _tr=list_stmp.shift();
                list_tmp=[];
                fn[_tr.getAttribute('fn')](_tr, cls, list_tmp, isTotal); //attribute is fields. 
                for(var j=0, _td; _td=_tr.cells[j]; j++){
                    _td.setAttribute('old', (typeof(list_tmp[j]) == 'undefined' ? 'null' : list_tmp[j]));
                }
            }
        }
    }

    ;function commons_sum(el_tr, list_tmp){
        for(var i=0, _td; _td=el_tr.cells[i]; i++){
            tmp=_td.getAttribute('old');
            list_tmp[i] = (typeof(list_tmp[i]) == 'undefined' ? 'null' : list_tmp[i]);
            if(tmp != 'null'){
                list_tmp[i]= accAdd(numberOfZero(list_tmp[i]), numberOfZero(tmp));
            }
        }
    }
    ;function commons_getcls(el_tr, cls, isTotal, t){
        if(isTotal){
            cls = cls.split(',');
            cls = cls[0]+'.find'+el_tr.getAttribute('fn')+', '+cls[1]+'.find'+el_tr.getAttribute('fn');
        }else{
            cls +=t ;
        }
        return cls;
    }
    ;function pmfc(el_tr, cls, list_tmp, isTotal){
        $body.find(commons_getcls(el_tr, cls, isTotal, '.pmforecasts')).each(function(){
            commons_sum(this, list_tmp);
        });
    }

    ;function amfc(el_tr, cls, list_tmp, isTotal){

        $body.find(commons_getcls(el_tr, cls, isTotal, '.amforecast')).each(function(){
            commons_sum(this, list_tmp);
        });
    }
    ;function amfcin(el_tr, cls, list_tmp, isTotal){
        $body.find( commons_getcls(el_tr, cls, isTotal, '.amforecasts_in') ).each(function(){
            commons_sum(this, list_tmp);
        });
    }
    ;function amfcoth(el_tr, cls, list_tmp, isTotal){
        $body.find( commons_getcls(el_tr, cls, isTotal, '.amforecasts_oth') ).each(function(){
            commons_sum(this, list_tmp);
        });
    } 
    ;function bling(el_tr, cls, list_tmp, isTotal){
        $body.find( commons_getcls(el_tr, cls, isTotal, '.billing') ).each(function(){
            commons_sum(this, list_tmp);
        });
    }
    ;function blingin(el_tr, cls, list_tmp, isTotal){
        $body.find( commons_getcls(el_tr, cls, isTotal, '.billings_in') ).each(function(){
            commons_sum(this, list_tmp);
        });
    }
    ;function blingoth(el_tr, cls, list_tmp, isTotal){
        $body.find( commons_getcls(el_tr, cls, isTotal, '.billings_oth') ).each(function(){
            commons_sum(this, list_tmp);
        });
    }
    ;function btb(el_tr, cls, list_tmp, isTotal){
        $body.find( commons_getcls(el_tr, cls, isTotal, '.book2bill') ).each(function(){
            commons_sum(this, list_tmp);
        });
    }
    ;function blog(el_tr, cls, list_tmp, isTotal){
        $body.find( commons_getcls(el_tr, cls, isTotal, '.backlog') ).each(function(){
            commons_sum(this, list_tmp);
        });
    }
    ;function blogorder(el_tr, cls, list_tmp, isTotal){
        $body.find( commons_getcls(el_tr, cls, isTotal, '.orderbacklog') ).each(function(){
            commons_sum(this, list_tmp);
        });
    }
    ;function blogorderin(el_tr, cls, list_tmp, isTotal){
        $body.find( commons_getcls(el_tr, cls, isTotal, '.backlog0_in') ).each(function(){
            commons_sum(this, list_tmp);
        });
    }
    ;function blogorderoth(el_tr, cls, list_tmp, isTotal){
        $body.find( commons_getcls(el_tr, cls, isTotal, '.backlog0_oth') ).each(function(){
            commons_sum(this, list_tmp);
        });
    }
    ;function blogsched(el_tr, cls, list_tmp, isTotal){
        $body.find( commons_getcls(el_tr, cls, isTotal, '.backlogscheduled') ).each(function(){
            commons_sum(this, list_tmp);
        });
    }
    ;function blogschedin(el_tr, cls, list_tmp, isTotal){
        $body.find( commons_getcls(el_tr, cls, isTotal, '.scheduled_in') ).each(function(){
            commons_sum(this, list_tmp);
        });
    }
    ;function blogschedoth(el_tr, cls, list_tmp, isTotal){
        $body.find( commons_getcls(el_tr, cls, isTotal, '.scheduled_oth') ).each(function(){
            commons_sum(this, list_tmp);
        });
    }
    ;function currencytotal(el_tr, cls, list_tmp, isTotal){
        $body.find( commons_getcls(el_tr, cls, isTotal, '.gtcurrency') ).each(function(){
            commons_sum(this, list_tmp);
        });
    }
    ;function currencytotalin(el_tr, cls, list_tmp, isTotal){
        $body.find( commons_getcls(el_tr, cls, isTotal, '.currency_in') ).each(function(){
            commons_sum(this, list_tmp);
        });
    }
    ;function currencytotaloth(el_tr, cls, list_tmp, isTotal){
        $body.find( commons_getcls(el_tr, cls, isTotal, '.currency_oth') ).each(function(){
            commons_sum(this, list_tmp);
        });
    }
    ;function ac2m(el_tr, cls, list_tmp, isTotal){
        $body.find( commons_getcls(el_tr, cls, isTotal, '.percent_2am') ).each(function(){
            commons_sum(this, list_tmp);
        });
    }
    ;function ac6m(el_tr, cls, list_tmp, isTotal){
        $body.find( commons_getcls(el_tr, cls, isTotal, '.percent_6am') ).each(function(){
            commons_sum(this, list_tmp);
        });
    }
    ;function acquart(el_tr, cls, list_tmp, isTotal){
        $body.find( commons_getcls(el_tr, cls, isTotal, '.percent_qty') ).each(function(){
            commons_sum(this, list_tmp);
        });
    }
}

;function rCellScroll_eve(e){
    var _this=this;
	document.getElementById('lcellbody').scrollTop = _this.scrollTop;
	document.getElementById('rcellhead').scrollLeft = _this.scrollLeft;
}


;function windowReSize(){
    document.getElementById('compbodyall').style.visibility='hidden';
    setBodyStyle($('#tabContainer').width(), false);
}

;function setBodyStyle(resize_width, isHeight){

    var $compbody=$('#compbodyall'), min_cw= parseInt($compbody.css('min-width').replace('px', ''), 10), 
        max_ow=(typeof(resize_width) != 'undefined' ? resize_width : $('#contentallid').outerWidth(true));

    min_cw = (max_ow < min_cw ? min_cw : (max_ow-40));
    $compbody.css({'width':min_cw, 'visibility': 'visible'});

    var lCellw=$compbody.find('#lcellbody').width(), window_h = $(window).height(),
        r_tab_h = $('#rTabId').height(), rightCell_w=parseInt((min_cw-lCellw-2), 10),
        v_height=0, usedHeight = ($('#dmsgid').outerHeight(true) + $('#AppBodyHeader').outerHeight(true) + $('div.bPageFooter.noTableFooter').outerHeight(true) + 50);
    
    
    v_height = (window_h - usedHeight - 90);
	if(isfull){ v_height += 75; }
	
    document.getElementById('rCellScroll').style.width = (rightCell_w-1)+'px';
    document.getElementById('rcellhead').style.width = (rightCell_w-scrollbarW-1)+'px';

    if($compbody.find('#lcellbody div.nodata').length != 3){
        document.getElementById('rCellScroll').style.height = v_height+'px';
        document.getElementById('lcellbody').style.height = (v_height+1-scrollbarW-0.7)+'px';
    }else if(isHeight){
        document.getElementById('rCellScroll').style.height = v_height+'px';
        document.getElementById('lcellbody').style.height = (v_height+1-scrollbarW-0.7)+'px';
    }
}
;function ck_headCell_eve(e){
    ck_headCell(this.getElementsByTagName('b')[0]);
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
        var $find = $(('#'+id+' .'+cls)).addClass('dn');
        	$find.find('td.coll, td.collapse_left, td.collapse_left1').removeClass('coll collapse_left collapse_left1');
	    $find.find('b.collapse, b.col').removeClass('collapse col').addClass('expand').html(function(){
	        		return this.getAttribute('col');
	        });
        $img.removeClass('collapse').addClass('expand').html('+');
    }        

}

;function loadingAnimate(){
    $('#loading-curtain-div').animate({top:'50%', left:'50%',width:0, height:0}, 800, function(){
        $(this).attr('style', '');
        this.style.display='none';
    });
}

;function ck_headCell(target){
    var $this=$(target), $td=$this.parent().parent(), _c1=$td[0].cellIndex, $cols=$('#rsmcolspanid'),
        $head=$('#rsmHeadId'), fn={'excute':($this.hasClass('expand') ? expand : collapse)};

    fn.excute($('#rsmHeadId, #rTabId tr').toArray());
    
    ;function expand(list_el){
    		async.eachLimit(list_el, 100, function(item, callback) {
		    setTimeout(function() {
		    		$(item.cells[_c1-1]).removeClass('dn');
	            $(item.cells[_c1-2]).removeClass('dn');
	            $(item.cells[_c1-3]).removeClass('dn');
	            callback();
		    }, 45);
		}, function(err) {
			list_el=[];
		    $this.removeClass('expand').addClass('collapse').html('-');
		    $td.prev().prev().prev().prev().removeClass('exp_right');
		});
		var pos=3;
		if($td.hasClass('futurec currentc1 cfixqtotalw')){
			var lastQtotal= parseInt( $cols.find('th:first')[0].getAttribute('old') )%3;
			if(lastQtotal != 0){ pos=lastQtotal; }
		}
        hasHistorical(pos);
		
    }
    
    ;function collapse(list_el){
    		async.eachLimit(list_el, 100, function(item, callback) {
		    setTimeout(function() {
		    		item.cells[_c1-1].className += ' dn';
	            item.cells[_c1-2].className += ' dn';
	            item.cells[_c1-3].className += ' dn';
	            callback();
		    }, 45);
		}, function(err) {
			list_el=[];
		    $this.removeClass('collapse').addClass('expand').html('+');
		    $td.prev().prev().prev().prev().addClass('exp_right');
		});
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
;function ck_thLeftCell(target, id, searTab, isAll){
    var h = document.getElementById('rCellScroll');
    if(h.style.height == ''){ setBodyStyle(undefined, true); }
    h=target.getElementsByTagName('b')[0];
    if($(h).hasClass('expand')){
	    $(target).addClass('coll');
	    $('#'+searTab).find(('tr.'+id)).find('td:eq(1)').addClass('collapse_left1');
    }
    ck_leftCell(h, id, searTab, isAll);
    
}

;function ck_tdLeftCell(target, id, searTab, isAll){
    var h = document.getElementById('rCellScroll'), $target=$(target);
    if(h.style.height == ''){ setBodyStyle(undefined, true); }
    
    h=target.getElementsByTagName('b')[0];
    if($(h).hasClass('expand')){
	    $target.addClass('coll');
	    $('#'+searTab).find(('tr.'+id)).find('td').addClass('collapse_left');
    }

    ck_leftCell(h, id, searTab, isAll);
	if($(h).hasClass('expand')){
		$target.addClass('border_l').removeClass('pd_0_0').find('div').addClass('pd_0_0');
	}else{
    		$target.removeClass('border_l').addClass('pd_0_0').find('div').removeClass('pd_0_0');
	}
}
;function ck_tdSubLeftCell(target, id, searTab, isAll){
	if($(target).hasClass('hd')){
	    ck_leftCell(target.getElementsByTagName('b')[0] ,id, searTab, isAll);
	}
}
;function ck_leftCell(target, id, searTab, isAll){
    var $this=$(target), fn={'execute':($this.hasClass('expand') ? expand : collapse)};

    fn.execute($this, id, ('#'+searTab), isAll);
    
    ;function expand($this, id, searTab, isAll){
        id=(isAll ? (id+':not(.sbcell)') : id+'.sbcell');
        $this.removeClass('expand').addClass('collapse col').html($this[0].getAttribute('exp'));
        $(searTab).find(('tr.'+id)).removeClass('dn');
        $('#rTabId tr.'+id).removeClass('dn');
    }
    ;function collapse($this, id, searTab, isAll){
        var $tab=$(searTab);
        $this.removeClass('collapse').addClass('expand').html($this[0].getAttribute('col'))
        		.parent().parent().removeClass('coll');
        $tab.find(('tr.'+id+' .subbox')).removeClass('collapse col').addClass('expand').html(function(){
        		return this.getAttribute('col');
        });   //set img status
        if(isAll){
            $tab.find(('tr.'+id)).addClass('dn');
            $('#rTabId tr.'+id).not('.findTab').addClass('dn').removeClass('collapse_left1');
        }else{
            $tab.find(('tr.sbcell.'+id)).addClass('dn');
            $('#rTabId tr.sbcell.'+id).addClass('dn').removeClass('collapse_left');
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


function asynProcess(items, asynTimeProcess, callback){
    var todo = items.concat();
    setTimeout(function(){
        asynTimeProcess(todo.shift());
        if (todo.length > 0){ setTimeout(arguments.callee, 35); }
        else{ callback(); }
    }, 55);
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
    var point = 'n0'; //(/\.0+$/.test(txt.toFixed(2)) ? 'n0' : 'n0');
    return (Globalize.format(roundFn(txt, 0), point));
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