var OTHER_OPTION_VALUE='empty', scrollbarW = $.getScrollbarWidth(), Territory_CODE = '';

;function initDocument(){

    Globalize.culture(this.locale).numberFormat.currency.symbol = "";
    var _code = $.parseJSON($('[id*=jsonmaptypecodeid]').val());

    if($.isEmptyObject(_code)){
        reloadDocument();
		
        return;
    }

	if (this.isTool == null || this.isTool == '') {
		createTerritoryCode(_code);
		document.getElementById('loading-curtain-div').style.display='none';
	}
	

}
;function createTerritoryCode(_code){
    var content = '';
    Territory_CODE = '';
    for(var o in _code){
        var option='<select>', t = '', tt = '';
        while(_code[o].length > 0){
            var s = _code[o].shift();
            option += ('<option data-free="'+s['isFrozen']+'" value="'+s['territoryCode']+'">'+s['territoryCode']+'</option>');
        }
        option += '</select>';
        t = '<div class="code_box"><div><div style="width: 170px; float: left;">'+CUSTOM_LABEL[o]+' : </div><div>'+option+'<input type="button" data-first="false" onclick="search'+o+'_pop_eve(this)" class="btn" value="Next"/></div></div></div>';
        content += t;
        Territory_CODE += ('<span class="dn menu_code_box"> <span>'+option+
                            '<input type="button" onclick="search'+o+'_eve(this)" class="btn" id="'+o+'_id" value="Search '+o+'"/></span></span>');
    }
    art.dialog({
        title:' ', lock:true, dblclick_hide:false, esc:false, cancel:false, id: 'territorycodedialog',
        content: content
    });
	setTerritoryCode();
}
;function reloadDocument(){
    fixPageSize();
    register_event();
    initAccountTree();
}

;function saveAcctGroup_eve(target){

    artMsg($label['savemsg'], target, createJSON_save, cancel_save);
    
    ;function createJSON_save(target){
        document.getElementById('loading-curtain-div').style.display='';
        createAcct_JSON();
        document.getElementById('nextforecastid').setAttribute('data-forward', 'false');
        saveAcctGroup();        //this is action function save account.
    }
    
    ;function cancel_save(){ }
}

;function searchAM_pop_eve(target){
	document.getElementById('loading-curtain-div').style.display='';

    var $this=$(target), $option=$this.parent().find('select option:selected'), _value=$option.val(), isFree=$option.attr('data-free');
    $('[id*=isrealyid]').val(false);
    $('[id*=territorycodeid]').val(_value);

    art.dialog({id: 'territorycodedialog'}).close();
    if(isFree=='true' || isFree == true){
    	$('[id*=hidd_frezz]').val(true);
    	setTimeout(function(){
		    frozenNext();  //this is action function
	    }, 80);
    }else{
    	$('[id*=hidd_frezz]').val(false);
    	setTimeout(function(){
		    searchGroupsAccounts();  //this is action function
	    }, 80);
    }
	
//	document.getElementById('AM_id').click();
}

;function searchRelay_pop_eve(target){
	document.getElementById('loading-curtain-div').style.display='';

    var $this=$(target), $option=$this.parent().find('select option:selected'), _value=$option.val(), isFree=$option.attr('data-free');

    $('[id*=isrealyid]').val(true);
    $('[id*=territorycodeid]').val(_value);

    art.dialog({id: 'territorycodedialog'}).close();
    
    if(isFree=='true' || isFree == true){
    	$('[id*=hidd_frezz]').val(true);
    	setTimeout(function(){
		    frozenNext();  //this is action function
	    }, 80);
    }else{
    	$('[id*=hidd_frezz]').val(false);
    	setTimeout(function(){
		    searchGroupsAccounts();  //this is action function
	    }, 80);
    }
    
	
//    document.getElementById('Relay_id').click();
}

;function searchAM_eve(target){
    document.getElementById('loading-curtain-div').style.display='';
    art.dialog({id: 'territorycodedialog'}).close();

    var $this=$(target), _value=$this.parent().find('select option:selected').val();
    $('[id*=isrealyid]').val(false);
    $('[id*=territorycodeid]').val(_value);
	setTimeout(function(){
	    searchGroupsAccounts();  //this is action function
    }, 80);
}

;function searchRelay_eve(target){
    document.getElementById('loading-curtain-div').style.display='';
    art.dialog({id: 'territorycodedialog'}).close();

    var $this=$(target), _value=$this.parent().find('select option:selected').val();
    $('[id*=isrealyid]').val(true);
    $('[id*=territorycodeid]').val(_value);
    setTimeout(function(){
	    searchGroupsAccounts();  //this is action function
    }, 80);
}
;function event_chart_click(event, target){
	var _url=$.trim( $('#charturlid').val() );
	if(_url == ''){
		alert('URL error.');
		return;
	}
	if($('#openrsmgroupid').length == 0){
		$('#menudivid').append(
			'<a style="display:none;" id="openrsmgroupid" href="'+_url+'" target="_blank"></a>'
		);		
	}
	$('#openrsmgroupid')[0].click();
}
;function searchGroupsAccountsComplete(){    //search account complete
    setTerritoryCode();
    publicForecastComplete();   //init account tree 
}

;function setTerritoryCode(){
    var t_code = $.trim($('[id*=territorycodeid]').val());
    $('#menu_divid span.group_menu').before(Territory_CODE).parent()
        .find('option[value='+t_code+']').attr('selected', true);
}

;function createAcct_JSON(){
    
    var list_parent_json=[], list_data = $('#jstreedivid').data('uiFancytree').getTree().rootNode['children'];

    while(list_data != null && list_data.length > 0){   //create parent account json data
        var _data=list_data.shift(), $pdata=$(_data.span), $tr=$pdata.parent().parent(), 
            pid=$.trim($pdata.find('span.pbcls')[0].id), ptitle=$.trim($pdata.find('span.pbcls').html()),
            pisocode=$tr.find('option:selected').val(), displayName=$.trim($tr.find('input').val()),
            list_child=_data['children'], list_child_data=[];

        create_child_json(ptitle, list_child, list_child_data, pid, displayName); //create child account json data
        
        
        OTHER_OPTION_VALUE=(pisocode == 'empty' ? 'empty' : pisocode);  //set static option values

        pisocode = (pisocode == 'empty' ? OTHER_ID : pisocode);

        var s=('{"parentAcctIsoCode": \"'+pisocode+'\", "oldParentId": "'+_data.data['oldParentId']+'", "parentAcctId": \"'+pid+'\", "oldCurrency": \"'+_data.data['oldCurrency']+'\", '+
                '"displayName": \"'+displayName+'\", "list_childAccts": [' + list_child_data.join(',') + ']}');
        list_parent_json.push(s);
    }

    $('[id*=jsonacctsid]').val( ('['+list_parent_json.join(',')+']') );

    ;function create_child_json(ptitle, list_child, list_child_data, pid, displayName){
        if(list_child == null){ return; }
        if(pid == OTHER_ID){      //other child element 
            var is_other_isocode=(pisocode == 'empty' ? true : false);
            while(list_child.length > 0){
                var _child = list_child.shift(), cid=$.trim(_child['data']['acctId']),
                    cisocode=$.trim(_child['data']['acctIsoCode']);
                //    ctitle=$.trim(_child['data']['acctName']), 
                    
                if(!is_other_isocode){ cisocode = pisocode; }

                list_child_data.push( ('{"parentAcctId": \"'+OTHER_ID+'\", "oldParentId": "'+_child.data['oldParentId']+'", "oldCurrency": \"'+_child.data['oldCurrency']+'\", "acctIsoCode": \"'+cisocode+'\", "acctId": \"'+cid+'\"}') );
            }
        }else{  
            while(list_child.length > 0){
                var _child = list_child.shift(), cid=$.trim(_child['data']['acctId']);//, 
                //    ctitle=$.trim(_child['data']['acctName']), dname = $.trim($(_child.span).find('input').val());

                list_child_data.push( ('{"parentAcctId": \"'+pid+'\", "oldParentId": "'+_data.data['oldParentId']+'", "oldCurrency": \"'+_child.data['oldCurrency']+'\", "acctIsoCode": \"'+pisocode+'\", "acctId": \"'+cid+'\", "displayName": \"'+displayName+'\"}') );
            }
        }
    }
}


;function saveAcctGroupComplete(){
//    console.log( 'saveAcctGroupComplete ' + $.trim($('[id*=lastforecast_id]').val()) );
    if($.trim($('[id*=errorstopid]').val()) == 'true'){
    	publicForecastComplete();
    	return;
    }
    if($.trim($('[id*=lastforecast_id]').val()) != ''){
        updateAPLSalesFCForSave();      //this is action function
        return;
    }
    publicForecastComplete();
}

;function updateAPLSalesFCForSaveComplete(){
    
//    console.log( 'updateAPLSalesFCForSaveComplete ' + $.trim($('[id*=lastforecast_id]').val()) );
    
	if($.trim($('[id*=errorstopid]').val()) == 'true'){
    	publicForecastComplete();
    	return;
    }
	
    if($.trim($('[id*=lastforecast_id]').val()) != ''){
        updateAPLSalesFCForSave();      //this is action function
        return;
    }
    
    if($('[id*=isrealyid]').val() == 'true'){
    	removeRelayOtherFc()	//this is action function remove relay other forecast.
    	return;
    }
    publicForecastComplete();
}

;function publicForecastComplete(){
    try{
        $("#jstreedivid").fancytree("destroy");
    }catch(e){
    //    console.log(e);
    }
    initAccountTree();

    document.getElementById('loading-curtain-div').style.display='none';
}

;function nextForecast_eve(target){
    artMsg($label['savemsg'], target, function(target){
        document.getElementById('loading-curtain-div').style.display = '';
        createAcct_JSON();
	    nextForecast();        //this is action function save account.
    }, function(){
        history.back();
    });
}

;function nextForecastTool_eve(target){
    artMsg_tool($label['savemsg'], target, function(target){
        document.getElementById('loading-curtain-div').style.display = '';
        //createAcct_JSON();
		nextForecast_Tool();
		isForecastTool = 'false';
    }, function(){
        history.back();
    });
}

;function nextForecastComplete(){
	
	if($.trim($('[id*=errorstopid]').val()) == 'true'){
    	publicForecastComplete();
    	return;
    }
	
    if($.trim($('[id*=lastforecast_id]').val()) != ''){
        updateAPLSalesFCForNext();      //this is action function
        return;
    }
    publicNextForecastComplete();
}

;function updateAPLSalesFCForNextComplete(){
	
	if($.trim($('[id*=errorstopid]').val()) == 'true'){
    	publicForecastComplete();
    	return;
    }
	
    if($.trim($('[id*=lastforecast_id]').val()) != ''){
        updateAPLSalesFCForNext();      //this is action function
        return;
    }
    publicNextForecastComplete();
}

;function publicNextForecastComplete(){
	
	if($.trim($('[id*=errorstopid]').val()) == 'true'){
    	publicForecastComplete();
    	return;
    }

    if($('[id*=isrealyid]').val() == 'true'){
    	removeRelayOtherFcNext()	//this is action function remove relay other forecast.
    }else{
    	initAMDocument();       //used the CtrlGroupingAMForecastJs.Resource
    }
}

;function removeRelayOtherFcComplete(){
	if($.trim($('[id*=errorstopid]').val()) == 'true'){
    	publicForecastComplete();
    	return;
    }
    
	if($('[id*=lastremove_id]').val() != ''){
		removeRelayOtherFc();	//this is action function
		return;
	}
	publicForecastComplete();
}

;function removeRelayOtherFcNextComplete(){
	if($.trim($('[id*=errorstopid]').val()) == 'true'){
    	publicForecastComplete();
    	return;
    }
	
	if($.trim($('[id*=errorstopid]').val()) == 'true'){
    	publicForecastComplete();
    	return;
    }
	
	if($('[id*=lastremove_id]').val() != ''){
		removeRelayOtherFcNext();	//this is action function
		return;
	}
	initRelayDocument();    //used the CtrlGroupingRelayForecastJs.Resource
}

;function frozenNextComplete(){
	if($('[id*=isrealyid]').val() == 'true'){   //check is relay user
        initRelayDocument();    //used the CtrlGroupingRelayForecastJs.Resource
    }else{
        initAMDocument();       //used the CtrlGroupingAMForecastJs.Resource
    }
}

;function cancelGroup(target){
    document.getElementById('loading-curtain-div').style.display='';
    window.location.href='/home/home.jsp';
}

;function initAccountTree(){

    var $span_option=$('#iso_option_span_id select'),
        options={
            source: getAccountSource(), extensions: [ "dnd", "table", "gridnav" ],
            createNode: createNode_Element, 
            dnd: {
                preventVoidMoves: false, preventRecursiveMoves: true, autoExpandMS: 400,
                dragStart: function(node, data) { return true; },
                dragEnter: dragEnter_Status,
                dragDrop: dragDrop_End
            }
        };
    
    var $tree=$("#jstreedivid"), 
        _index=$tree.fancytree(options).find('tbody tr.othercls').index();//this init tree element
    
    $tree.find('tbody tr:gt('+_index+') input').hide();
    
    document.getElementById('loading-curtain-div').style.display='none';

    
    ;function createNode_Element(event, data){
        var node = data.node, $tdList = $(node.tr).find("td");
		console.log( data );
		$tdList.eq(3).html(node.data['billingprovince']);
		$tdList.eq(4).html(node.data['username']);
	//	console.log(node.data['acctId']);
        if( node.data['acctId'] == OTHER_ID ){
            var select_html = '<select>'+
                               //     '<option value="empty">Please select currency</option>'+
                                    '<option value="USD">USD</option>'+
                              '<select>';
            $tdList.eq(1).html(select_html); 
        }else{
            var $span_clone=$span_option.clone();
            $span_clone.find('option[value="'+node.data['acctIsoCode']+'"]').attr('selected', true);
            $tdList.eq(1).append($span_clone); 
            $tdList.eq(2).html('<input type="text" class="displaynamecls" value="'+node.data['displayName']+'" style="display:none;" />'); 
        }
        if(node.data['acctId'] == OTHER_ID){
            $tdList.parent().addClass('othercls');
        }

        if(node.data.hasOwnProperty('list_childAccts')){
            $tdList.find('select').css({'display': ''});
            $tdList.find('input').show();
        }

    }
    
    ;function dragEnter_Status(node, data){     // return ["before", "after"];

        if(data.otherNode.children != null || data.otherNode.data['parentAcctName'] == OTHER_LABEL){
            return false;       
        }

        return ($(node.span).find('span.pbcls').hasClass('scls') ? false : true);
    }
    
    ;function dragDrop_End(node, data){

        data.otherNode.moveTo(node, data.hitMode);
        
        var _val='', _span=$(data.otherNode.span), _parent=data.otherNode.parent, 
            $target=$(_span).find('span.pbcls'), $tr=$(_span).parent().parent();

        if(_parent.parent != null){
            $target.addClass('scls').removeClass('pcls');
            $tr.find('select,input').hide();
        }else{
            $target.addClass('pcls').removeClass('scls');
            $tr.find('select,input').show();
        }
        data.otherNode.title=$target.parent().html();

    }
}       

;function getAccountSource(){
    var act_value=$.trim($('[id*=jsonacctsid]').val());

    if(act_value == ''){ return []; }
    
    var source=$.parseJSON(act_value);

    try{
        for(var i=0, _acct; _acct=source[i]; i++){
            _acct['children']=$.parseJSON($.trim(_acct['children']));
            _acct['title']=( '<span class="pcls pbcls" id="'+_acct['acctId']+'">'+_acct['title']+'</span>');
    
            for(var j=0, _child; _child=_acct['children'][j]; j++){
                _child['title']=( '<span class="scls pbcls" id="'+_child['acctId']+'">'+_child['title']+'</span>' );
            }
        }
    }catch(err){
        source = [];
    }
//	console.log(source);
    return source;
}
;function treeAll_click(target){
    
    var $this=$(target), hasExp=$this.hasClass('exp');
    if(hasExp){
        $(target).removeClass('exp').addClass('col').val(function(){
            return this.getAttribute('col');
        });
    }else{
        $(target).removeClass('col').addClass('exp').val(function(){
            return this.getAttribute('exp');
        });
    }
    try{
        $("#jstreedivid").fancytree("getRootNode").visit(function(node){
            node.setExpanded(hasExp);
        });
    }catch(e){
        
    }
    
}

;function register_event(){
//    $(document).off('click').on('click', sidebar_click_eve);
    $(window).smartresize(windowReSize);
}
;function sidebar_click_eve(e){
    var $target=$(e['target']);
    if($target.hasClass('handlebarContainer') || $target.hasClass('indicator') || $target.hasClass('pinBox')){
        fixPageSize();
    }
}
;function windowReSize(){
    fixPageSize();
}

;function fixPageSize(){
    $('#contentallid').width($('#AppBodyHeader').outerWidth(true)-60-$('#sidebarCell').outerWidth(true));
    /*
    var w_height=$(window).height(),
        usedHeight = ($('#dmsgid').outerHeight(true) + $('#AppBodyHeader').outerHeight(true) + 
                    $('div.bPageFooter.noTableFooter').outerHeight(true) + 50);
                        
    $('#jstreedivid').height( (w_height-usedHeight-90-$('#menu_divid').outerHeight(true)) );
    */
}

;function artMsg(content, target, callBackOk, callBackCancel){
    art.dialog({
        title:' ', lock:true, dblclick_hide:false, esc:false, id: 'countsid',
        content: content,
        button : [ {value: 'OK', focus: true, callback: function(){ callBackOk(target); }},
                        {value: 'Cancel', callback: function(){ callBackCancel(); }}
         ]
    });
}
;function artMsg_tool(content, target, callBackOk, callBackCancel){

    var dialogReturn = art.dialog({
        title:' ', lock:true, dblclick_hide:false, esc:false, id: 'countsid',
        content: content,
        button : [ {value: 'OK', focus: true, callback: function(){ callBackOk(target); }},
                        {value: 'Cancel', callback: function(){ callBackCancel(); }}
         ]
    });
    if(dialogReturn){
    	$(".d-outer").hide();
    	setTimeout(function(){
    		dialogReturn.dom.buttons[0].childNodes[0].click();
    	},500);
    }
}

;function customMultipleRemoteAction(strParam, callFunction, callResult) {
    Visualforce.remoting.Manager.invokeAction(
        callFunction(), strParam['cls'], strParam['json'], function(result, event){ callResult(result, event, strParam); }, {escape: false, timeout:120000}
    );
}

;function addListener (element, event, fn, params) {
    var eventHandler = ( params ? function(){ fn.call(params); } : fn );
    if (window.attachEvent) {
        element.attachEvent('on' + event, eventHandler);
    } else {
        element.addEventListener(event, eventHandler, false);
    }
}
;function nextForecastTool() {
	window.location.href="/apex/CtrlOppyForecastToolEnhancementAPL";
}