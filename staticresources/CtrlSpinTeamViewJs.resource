var scrollbarW = $.getScrollbarWidth(), focusDate='', connectionStatus={};

;function initDocument(){
    Globalize.culture(this.locale).numberFormat.currency.symbol = "";
    
    var fc_default=this.dpicklist, op_default=this.opdefault;
    
    $('#fcpickselect option[value='+fc_default+']').attr('selected', true);
    $('#oppickselect option[value='+op_default+']').attr('selected', true);
    
    /*
    .each(function(){
        $(this).find('option[value='+pick_list+']').attr('selected', true);
    });
    */
    fixTeamTableWidth();
    $('#oppyinfomsgid').show().html(function(){ return this.getAttribute('data-msg'); });
    
    event_Register();
    hideLoading();
}


;function event_Register(){
    var $menuOppy=$('#menuoppytbodyid');
    $(window).smartresize(windowReSize);
       
    $menuOppy.find('#dateselectdivid select.oppSelect').off('change').on('change', selectDate_eve)
        .each(function(){
            checkSelectDate($(this), $('#dateselectdivid div.'+this.id));
    });
    $(document).off('click').on('click', checkSelectDateOver_eve);
  //  $('#tdmenudateopid').hoverDelay({hoverEvent: teamSelectDateOver_eve, hoverDuring: 250,outEvent: teamSelectDateOut_eve,outDelay: 200});
    $('#teamBodyId tr').off('click').on('click', teamTabUserClick_eve);
    $('#teamheadid th:not(.miximg)').off('mouseenter mouseleave click').on('mouseenter mouseleave click', teamHeadOverClick_eve);
    $('#oppyheadid th.obycls').off('mouseenter mouseleave click').on('mouseenter mouseleave click', oppyHeadOverClick_eve);
    $('#oppyBodyId span.healthsp_cls').off('mouseenter mouseleave').on('mouseenter mouseleave', healthOver_eve);
  //  .hoverDelay({hoverEvent: oppyHealthOver, hoverDuring: 100,outEvent: oppyHealthOut,outDelay: 5});
}

;function healthOver_eve(e){
    var $this=$(this), _pos=$this.position(), $health_cmt=$this.find('div.healthcmtcls');
    if($.trim($health_cmt.find('div.healthcontentbox span').html()) == ''){
        return;
    }
    eventHandle_ov_ot(e, ov, ot);
    
    ;function ov(e){
        $health_cmt.css({'top': _pos['top']-$health_cmt.outerHeight(true)+(-4), 'left':_pos['left']-64}).stop().fadeIn();
    }
    ;function ot(e){
        $health_cmt.stop().hide();
    }
}

;function oppyHealthOver(target){
    var $this=$(target), _pos=$this.position(), $health_cmt=$this.find('div:first');
    $health_cmt.css({'top': _pos['top']-$health_cmt.outerHeight(true)+15, 'left':_pos['left']-62}).stop().fadeIn();
}
;function oppyHealthOut(target){
    $(target).find('div:first').stop().hide();
}
;function addTeamPopUP(target){
    document.getElementById('popupLoading').style.display='';
    var $team_box=$('#teamaddpopupid'), _height=$team_box.height();
        $clone=$team_box.find('div.popupuserscls div.tmpteamcls:last').clone(true);

    $team_box.find('div.popupuserscls div.tmpteamcls').remove();
    $clone.find('select').remove();
    $clone.find('.addusercls').val('+')[0].setAttribute('uid', '  ');
    $team_box.find('div.popupuserscls').append($clone);
    $team_box.find('input[type="text"], textarea').val('').show();
    
    $team_box.css({'top': (_height-_height*2), 'display':''}).animate({top: '8%'}, 600, function(){
        $team_box.find('#teamaddnameid').focus();
    });
}

;function editTeamPopUP(target){
    document.getElementById('popupLoading').style.display='';
    
    var $team_box=$('#teameditpopupid'), _height=$team_box.height(),
        $option=$('#teamSelect option:selected'), _id=$option.val(), _text=$option.text(), 
        _description=$option[0].getAttribute('data-description');
        
    $('#edituserdivid div.tmpteamcls:not(:last)').remove();
    $('#editusernameid').val(_text);
    $('#selectedusernameid').html(_text);
    $('#editdescriptionid').val($.trim(_description));
    $('[id*=editteamviewid]').val($.trim(_id));
    $('#editteamconid').height(_height).show();
    $team_box.css({'top': (_height-_height*2), 'display':''}).animate({top:'8%'}, 600, function(){
        showTeamMembers();  //auction function search team users
    });
}

;function delTeamView_eve(target, _id){
    var $team_box=$('#'+_id), $show_box=$('#editteamconid'), 
        $select_option=$('#teamSelect option:selected'), teamViewId=$.trim($select_option.val());
    
    $show_box.height($team_box.height()).show();
    usedRemoteAction(teamViewId, delTeamView, delTeamViewComplete);
    
    ;function delTeamViewComplete(result, event){
        result = $.parseJSON(result);
        if (event.status) {
            $('#team_body').height(36).find('#teamBodyId tr').remove();
            $('#oppy_body').height(36).find('#oppyBodyId tr').remove();
            $('#oppyinfomsgid').show().html(function(){ return this.getAttribute('data-msg'); });
            $select_option.remove();
            $team_box.hide();
            $show_box.hide();
            
            $('#spanalltotalid').attr('title', '').html('')[0].setAttribute('data-value', '0');
            $('#teamrowtotalid th.converted, th.won, th.cwon, th.pipeline, th.total, th.hold, th.countcls').each(function(){
                this.setAttribute('data-value', ' ');
                this.innerHTML='';
            });
            $('#popupLoading').hide();
        } else{
            $show_box.hide();
            alert(result['errmsg']);
        }
    }
    
    
}
;function addTeamMembers(target, box_id, show_id, isNew){
    var $box=$('#'+box_id), $teamInput=$box.find('.addinput'), team_name=$.trim($teamInput.val()),
        team_description=$.trim($box.find('.adddescription').val());
        
    if(team_name == ''){
        $teamInput.focus();
        return;
    }

    $('#'+show_id).css('height', $box.height()).show();
    var list_userids = [], $teamSelect=$('#teamSelect'),
        newId=(!isNew ? ($.trim($teamSelect.find('option:selected').val())) : '');

    $box.find('input[type="button"].addusercls').each(function(){
        var userid=$.trim(this.getAttribute('uid'));
        if(userid != ''){ list_userids.push(userid); }
    });

    var team_json = '{"id":\"'+newId+'\", "name":\"'+team_name+'\", '+
                        '"struserids": \"'+list_userids.join(',')+'\"}';

//    usedRemoteAction(team_json, saveTeamAndMembers, saveTeamAndMembersComplete);
    usedMultipleRemoteAction(team_json, team_description, saveTeamAndMembers, saveTeamAndMembersComplete);
    ;function saveTeamAndMembersComplete(result, event){
        if (event.status) {
            if(isNew){
                result = $.parseJSON(result);
                $teamSelect.append('<option data-description="'+team_description+'" value="'+result['id']+'">'+result['name']+'</option>');
            }else{
                $teamSelect.find('option').each(function(){
                    var $this=$(this);
                    if($this.val() == newId){
                        $this.text(team_name)[0].setAttribute('data-description', team_description);
                        return false;
                    }
                });
            }
            $box.hide();
            $('#'+show_id).hide();
            document.getElementById('popupLoading').style.display='none';
        } else{
            $('#'+show_id).hide();
            alert(event['message']);
        }
        $('#searchuserdivid').hide();
    }
}

;function searchUserInput_eve(e, target){
    if(e.keyCode == 13){
        $(target).blur().parent().find('.addusercls')[0].click();
    }
}

;function addUserBtn_eve(target, el_id){
    var $this=$(target), $parent=$this.parent(), $parent_box=$parent.parent(), 
        $input=$parent.find('input[type="text"]'), _value=$.trim($input.val());
    if($.trim(target.value) == '-'){
        $parent.remove();
        return;
    }
    if(_value == ''){
        $input.focus();
        return;
    }
    var $showBox=$('#'+el_id).css('height', $('#teamaddpopupid').height()).show();

    usedRemoteAction(_value, searchUsers, searchUsersComplete);
    
    ;function searchUsersComplete(result, event){
        public_searchUsersComplete(result, event, 'adduserdivid', $showBox, $parent_box, $parent, $this);
    }
}

;function editUserBtn_eve(target, el){
    var $this=$(target), $parent=$this.parent(), $parent_box=$parent.parent(), 
        $input=$parent.find('input[type="text"]'), _value=$.trim($input.val());
    if($.trim(target.value) == '-'){
        $parent.remove();
        return;
    }
    if(_value == ''){
        $input.focus();
        return;
    }
    var $showBox=$('#'+el).css('height', $('#teameditpopupid').height()).show();

    usedRemoteAction(_value, searchUsers, searchUsersComplete);
    
    ;function searchUsersComplete(result, event){
        public_searchUsersComplete(result, event, 'edituserdivid', $showBox, $parent_box, $parent, $this);
    }
}
;function public_searchUsersComplete(result, event, el_id, $showBox, $parent_box, $parent, $this){
    
    var list_users = [], $div_users=$('#'+el_id);
    if (event.status) {
        list_users = $.parseJSON(result);
        switch(list_users.length){
            case 0 : alert('Not found User'); break;
            case 1 :
                var hasUsers=false;
                $parent_box.find('.addusercls').each(function(){
                    var uid=$.trim(this.getAttribute('uid'));
                    if(uid == list_users[0]['Id']){
                        hasUsers=true;
                    }
                });

                if(hasUsers){ $this.focus(); return; }
                
                var $clonediv=$parent.clone(true);
                $clonediv.find('.addusercls')[0].setAttribute('uid', '  ');
                $clonediv.find('.usernamecls').val('');
                $div_users.append($clonediv);
                
                $parent.find('.usernamecls').attr('readonly', 'readonly');
                $this.val('-').css('color','red')[0].setAttribute('uid', list_users[0]['Id']);
                break;
            default : 
                var str_select='<select onchange="selectSearchUser(this,\''+el_id+'\')">'+
                                '<option value="selectusers">Please select</option>';
                for(var i=0, _user; _user=list_users[i];  i++){
                    str_select += ('<option value="'+_user['Id']+'">'+_user['Name']+'</option>');
                }
                str_select += '<optgroup label="ReSearch"><option value="ReSearch">Search</option></optgroup></select>';
                $parent.append(str_select).find('.icls').hide();
                break;
        }
    } else{
        
    }
    $showBox.hide();
}
;function selectSearchUser(target, el_id){
    var $this=$(target), $parent=$this.parent(), $cloneVal=$parent.clone(true),
        $sOption=$this.find('option:selected'), _value=$sOption.val(), _text=$sOption.text();
        
    if(_value == 'selectusers'){
        return;
    }
    if(_value == 'ReSearch'){
        $this.remove();
        $parent.find('.icls').show().filter('.usernamecls').focus();
        return;
    }
    var hasUsers=false;
    $parent.parent().find('.addusercls').each(function(){
        var uid=$.trim(this.getAttribute('uid'));
        if(uid == _value){
            hasUsers=true;
        }
    });

    if(hasUsers){ return; }    

    $parent.find('.usernamecls').val(_text).attr('readonly', 'readonly');
    $parent.find('.addusercls').val('-').css('color','red')[0].setAttribute('uid', _value);
    $this.remove();
    $parent.find('.icls').show();
    $cloneVal.find('select').remove();
    $cloneVal.find('.icls').show().filter('.usernamecls').val('');
    $('#'+el_id).append($cloneVal)
        .scrollTop($('#'+el_id).height())
        .find('div.tmpteamcls:last .usernamecls').focus();;
}

;function searchUsersPopUP(target, callId){
    $('#searchuserbodyid tr').remove();
    $('#lastnameid').val('');
    var $box=$('#'+callId), $search_box=$('#searchuserdivid');
    
    
    $box.animate({height:0}, 400, function(){
        $search_box.css({'top':$box.css('top'), 'height':0, 'display':''}).animate({height: 610}, 800, function(){
            this.setAttribute('data-call', callId);

            var _width=$('#content_user_body').width();
            _width=(_width-1-scrollbarW);
            $('#popupuserheadid').width(_width);
            $('#popupuserbodyid').width(_width);
            $('#firstnameid').val('').focus();
        });
    });
}
;function searchPopUPUsers(target){
    $('#searchuserLoading').css('height',$('#searchuserdivid').outerHeight(true)).show();
    var $fistInput=$('#firstnameid'), $lastInput=$('#lastnameid');
    $('[id*=firstusernameid]').val($.trim($fistInput.val()));
    $('[id*=lastusernameid]').val($.trim($lastInput.val()));
    searchUserByFNameAndLName();    //action function search users
}
;function searchUsers_eve(e, target){
    if(e.keyCode == 13){
        $(target).blur().parent().find('#searchuserbtnid')[0].click();
    }
}
;function searchUserByFNameAndLNameComplete(){
    $('#searchuserLoading').hide();
    
    var $search_box=$('#searchuserdivid'), $searchTab=$search_box.find('#searchuserbodyid'),
        search_box_id=$search_box[0].getAttribute('data-call');
    $( ('#'+search_box_id+' .addusercls') ).each(function(){
        var uid=$.trim(this.getAttribute('uid'));
        if(uid != ''){
            $searchTab.find('label.'+uid).addClass('ulDiv-click');
        }
    });
}


;function showTeamMembersComplete(){
    $('#editteamconid').hide();
    $('#editusernameid').focus();
}

;function addSearchUsers_eve(target){
    var $search_box=$('#searchuserdivid'), addId=$search_box[0].getAttribute('data-call'),
        $show_box=$( ('#'+addId) ), $add_box=$show_box.find('div.popupuserscls'),
        list_uid=[], list_append=[], $clone=$add_box.find('div.tmpteamcls:last').clone(true);
    
    $show_box.find('.addusercls').each(function(){
        var uid=$.trim( this.getAttribute('uid') );
        if(uid != ''){ list_uid.push(uid); }
    });
    
    $search_box.find('#searchuserbodyid label.ulDiv-click').each(function(){
        var dataName=this.getAttribute('data-name'), dataId=this.getAttribute('data-id');
        if(!_.contains(list_uid, dataId)){
            var $newClone=$clone.clone(true);
            $newClone.find('select').remove();
            $newClone.find('.usernamecls').val(dataName).attr('readonly', 'readonly').css('display','');
            $newClone.find('.addusercls').val('-').css('color','red').css('display','')[0].setAttribute('uid', dataId);
            list_append.push($newClone[0]);
        }
    });
    $add_box.prepend(list_append);
    $search_box.animate({height:0}, 400, function(){
        $show_box.animate({height:423}, 600, function(){
            $(this).find('input[type="text"].addinput').focus();
        });
        list_uid=list_append=[];
    });
}

;function closeSearchUserPopUP(target){
    $('#searchuserdivid').animate({height:0}, 400, function(){
        var hideId = this.getAttribute('data-call');
        $('#'+hideId).animate({height:423}, 600, function(){
            $(this).find('input[type="text"].addinput').focus();
        });
    });
}

;function closeTeamPopUP(target, _id){
    var $box=$('#'+_id), _height=$('#'+_id).height();
    $('#'+_id).animate({top: (_height-(_height+200)*2)}, 600, function(){
        $('#searchuserdivid').hide();
        $box.hide();
        document.getElementById('popupLoading').style.display='none';
    });
}

;function checkLabelStatus(target){
    var $this=$(target), $all_checkbox=$('#searchuserbodyid label.labelckbox'), all_len=$all_checkbox.length;
    if($this.hasClass('ulDiv-click')){
        $this.removeClass('ulDiv-click');
    }else{
        $this.addClass('ulDiv-click');
    }
    if(all_len == $all_checkbox.filter('.ulDiv-click').length){
        $('#allckboxid').addClass('ulDiv-click');
    }else{
        $('#allckboxid').removeClass('ulDiv-click');
    }
}
;function checkAllLabelStatus(target){
    var $this=$(target); $all_checkbox=$('#searchuserbodyid label.labelckbox'), ck_cls='ulDiv-click';
    if($this.hasClass(ck_cls)){
        $all_checkbox.removeClass(ck_cls);
        $this.removeClass(ck_cls);
    }else{
        $all_checkbox.addClass(ck_cls);
        $this.addClass(ck_cls);
    }
}
;function checkSelectDateOver_eve(e){
    if(!$(e['target']).hasClass('dateonlycls')){
        $('#selecteddivopid').stop().slideUp();
    }
}
;function teamSelectDateOver_eve(target){
    var $pickDateDiv=$('#selecteddivopid');
    if($pickDateDiv.css('display') == 'none'){
        $pickDateDiv.stop().css({'display':'', 'height':0}).animate({height: 50}, 430);
    }
}
;function teamSelectDateOut_eve(target){
    if($('#datePicker').css('display') == 'none'){
        $('#selecteddivopid').stop().slideUp();
        return;
    }
}

;function teamHeadOverClick_eve(e){
    var _this=this, $this=$(_this), _cellIndex=_this.cellIndex, $parent=$this.parent(), 
        $span=$this.find('span.team_orderby');
    eventHandle(e, ov, ot, ck);
    
    ;function ck(eve){
        var $teamBody=$('#teamBodyId'), list_team=$teamBody.find('tr').toArray();
        
        if(list_team.length <= 1){return;}
        
        cSort.clearMark($parent, _cellIndex);
        
        if((!$span.hasClass('asc') && !$span.hasClass('desc')) || $span.hasClass('desc')){
            cSort.elementAsc(_cellIndex, list_team, 'data-value', $teamBody, true);
            $span.removeClass('desc').addClass('asc').html(function(){ return this.getAttribute('asc'); });   
        }else if($span.hasClass('asc')){
            cSort.elementDesc(_cellIndex, list_team, 'data-value', $teamBody, true);
            $span.removeClass('asc').addClass('desc').html(function(){ return this.getAttribute('desc'); });
        }
    }
    
    ;function ov(eve){
        if(!$span.hasClass('asc') && !$span.hasClass('desc')){
            $span.html(function(){ return this.getAttribute('asc'); });
        }
    }
    
    ;function ot(eve){
        if(!$span.hasClass('asc') && !$span.hasClass('desc')){
            $span.html(' ');
        }
    }
}

;function selectDate_eve(e){
    checkSelectDate($(this), $('#dateselectdivid div.'+this.id));
}

;function checkSelectDate($this, $parent){
    if($.trim($this.find('option:selected').val()) == 'Custom'){
        $parent.find('input[type="text"]').off('focus').on('focus', oppyInputDate_eve)
            .removeClass('readonlycls').removeAttr('readonly');
        $parent.find('span.allimg').off('click').on('click', oppyDateFocus_eve);
    }else{
        $parent.find('input[type="text"]').off('focus').val('')
            .addClass('readonlycls').attr('readonly', 'readonly');
        $parent.find('span.allimg').off('click');
    }
}

;function oppyInputDate_eve(e, target){
    DatePicker.pickDate(false, (e==null?target:this), false);
}
;function oppyDateFocus_eve(e){
    var $input=$(this).prev(), el_input=$input[0];
    $input.focus();
    if(!isMSIE()['isTheBrowser']){
        setTimeout(function(){ oppyInputDate_eve(null, el_input); }, 260);
    }
}
;function oppyDate_eve(e){
    
    if(e.type == 'change'){
        window[this.getAttribute('dtype')]();
    }
    
    
}
;function oppystart_date(){ }
;function oppyend_date(){ }
;function fcstart_date(){ }
;function fcend_date(){ }

;function createOppyJSON(_id, hide_id){
    var dateFormat='yyyy-MM-dd',
        op_start = Globalize.parseDate( $.trim(document.getElementById('opstartid').value) ),
        op_end = Globalize.parseDate( $.trim(document.getElementById('opendid').value) ),
        fc_start = Globalize.parseDate( $.trim(document.getElementById('fcstartid').value) ),
        fc_end = Globalize.parseDate( $.trim(document.getElementById('fcendid').value) );
    
    op_start = Globalize.format(op_start, dateFormat);
    if(op_start != null){ op_start = '\"'+op_start+'\"'; }
    op_end = Globalize.format(op_end, dateFormat);
    if(op_end != null){ op_end = '\"'+op_end+'\"'; }
    fc_start = Globalize.format(fc_start, dateFormat);
    if(fc_start != null){ fc_start = '\"'+fc_start+'\"'; }
    fc_end = Globalize.format(fc_end, dateFormat);
    if(fc_end != null){ fc_end = '\"'+fc_end+'\"'; }

    var json = '{"selectedMembId":\"' +_id+ 
                    '\", "oppick":\"' +$('#oppickselect option:selected').val() +
                    '\", "fcpick":\"'+ $('#fcpickselect option:selected').val() +
                    '\", "opstart":' +op_start+ ', "opend":' +op_end+
                    ', "fcstart":' +fc_start+ ', "fcend":' +fc_end+ 
                '}';

    $('[id*='+hide_id+']').val(json);
}

;function createSearchJSON(_id){
    var dateFormat='yyyy-MM-dd',
        op_start = Globalize.parseDate( $.trim(document.getElementById('opstartid').value) ),
        op_end = Globalize.parseDate( $.trim(document.getElementById('opendid').value) ),
        fc_start = Globalize.parseDate( $.trim(document.getElementById('fcstartid').value) ),
        fc_end = Globalize.parseDate( $.trim(document.getElementById('fcendid').value) );
    
    op_start = Globalize.format(op_start, dateFormat);
    if(op_start != null){ op_start = '\"'+op_start+'\"'; }
    op_end = Globalize.format(op_end, dateFormat);
    if(op_end != null){ op_end = '\"'+op_end+'\"'; }
    fc_start = Globalize.format(fc_start, dateFormat);
    if(fc_start != null){ fc_start = '\"'+fc_start+'\"'; }
    fc_end = Globalize.format(fc_end, dateFormat);
    if(fc_end != null){ fc_end = '\"'+fc_end+'\"'; }

    var json = '{"selectedMembId":\"' +_id+ 
                    '\", "oppick":\"' +$('#oppickselect option:selected').val() +
                    '\", "fcpick":\"'+ $('#fcpickselect option:selected').val() +
                    '\", "opstart":' +op_start+ ', "opend":' +op_end+
                    ', "fcstart":' +fc_start+ ', "fcend":' +fc_end+ 
                '}';

    return json;
}
;function oppyHeadOverClick_eve(e){
    var _this=this, $this=$(_this), _cellIndex=_this.cellIndex, $parent=$this.parent(),
        $span=$this.find('span.team_orderby');
    eventHandle(e, ov, ot, ck);
    
    ;function ck(e){

        var list_data=[], element_catch={}, $oppBody=$('#oppyBodyId'), list_oppys=$oppBody.find('tr').toArray();
        if(list_oppys.lenght <= 1){ return; }
        
        cSort.clearMark($parent, _cellIndex);

        if((!$span.hasClass('asc') && !$span.hasClass('desc')) || $span.hasClass('desc')){
            cSort.elementAsc(_cellIndex, list_oppys, 'data-value', $oppBody, true);
            $span.removeClass('desc').addClass('asc').html(function(){ return this.getAttribute('asc'); });   
        }else if($span.hasClass('asc')){
            cSort.elementDesc(_cellIndex, list_oppys, 'data-value', $oppBody, true);
            $span.removeClass('asc').addClass('desc').html(function(){ return this.getAttribute('desc'); });
        }

    }
    
    ;function ov(e){
        if(!$span.hasClass('asc') && !$span.hasClass('desc')){
            $span.html(function(){ return this.getAttribute('asc'); });
        }
    }
    
    ;function ot(e){
        if(!$span.hasClass('asc') && !$span.hasClass('desc')){
            $span.html(' ');
        }
    }
}


;function teamTabUserClick_eve(e){  //Team Oppy
    showLoading();
    $('#teamBodyId tr.ckTab').removeClass('ckTab');
    $(this).addClass('ckTab');
    document.getElementById('oppyinfomsgid').style.display='none';
    document.getElementById('selectedmemberid').innerHTML=this.getAttribute('data-name');
    createOppyJSON(this.id, 'datejsonhideid');
    searchOppysForMemb();   //this is Oppy action function
    $('#oppyBodyId').empty();
    $('#oppteaminfoid').fadeIn();
}

;function searchOppysForMembComplete(){
    
    var isStop=$.trim($('[id*=isstopid]').val()), list_oppys=$('#oppytmpBodyId tr').toArray(),
        $oppyBody=$('#oppyBodyId');

    async.times(list_oppys.length, oppy_format, oppy_formatComplete);

    ;function oppy_format(n, callback){
        setTimeout(function(){
            var tr_oppy=list_oppys.shift();
            
            $(tr_oppy).find('td.enddate_cls, td.amount_cls, td.precntage_cls, td.progress_cls').each(function(){
                var v, match=this.getAttribute('data-match'), value=$.trim(this.getAttribute('data-value'));
                switch(match){
                    case 'enddate':
                            v=Globalize.format(new Date(value), 'd');
                            v=(v==null?'':v);
                        break;
                    case 'precntage':
                            value=parseFloat(value);
                            v = ($.isNumeric(value) ? (Globalize.format(value, 'n')+'%') : '');
                        break;
                    case 'amount':
                            value=parseFloat(value);
                            v = ($.isNumeric(value) ? (Globalize.format(value, 'n')) : '');
                        break;
                    case 'progress':
                            v = '';
                            if(value != ''){
                                var list_color=value.split('_');
                                while(list_color.length > 0){
                                    v += ('<span class="allimg cls_progress '+list_color.shift()+'"></span>');
                                }
                            }
                        break;
                }
                this.getElementsByTagName('div')[0].innerHTML=v;
            });
            $oppyBody.append(tr_oppy);
            callback(null);
        }, (n * 360));
    }
    ;function oppy_formatComplete(){
        if($oppyBody.find('tr').length >=10) { $('#oppy_body').css('height', '361px'); }

        if(!isStop){
            searchOppysForMemb();   //this is Oppy action function
            return;
        }
        
        fixTeamOppyTableWidth();
        event_Register();
        hideLoading();
    }
}

;function teamSearch(target, selectId){
    var _id=$.trim($('#'+selectId).find('option:selected').val());
    if(_id == 'none'){ return; }
    showLoading();
    
    createOppyJSON(null, 'queryjsonsearchid');
    $('#allcontentid [id*=teamhideid]').val(_id);
    getTeamMembs(); //this is Team action function
    $('#oppyinfomsgid').show().html(function(){ return this.getAttribute('data-msg'); });
    $('#oppyBodyId tr').remove();
    $('#oppteaminfoid').fadeOut();
}

;function teamSelect_eve(target){   //Team Selected option
    
}

;function getTeamMembsComplete(){   //Team Complete action function 
    
    var $teamBody = $('#teamBodyId');
    
    fixTeamOppyTableWidth();
    
    setTimeout(function(){
        
        var list_members = $.parseJSON( $.trim( $('[id*=setteammemberids]').val() ) );

        if(list_members.length == 0){
            connectionStatus['forecast'] = true;
            connectionStatus['mixforecast'] = true;
            asynConnectionChecking($teamBody);
            return;
        }
        list_members = $.trim( $('[id*=setteammemberids]').val() );
        createConnectionStatus({'forecast': 'query', 'mixforecast': 'mixQuery'});

        var json = createSearchJSON(null);
 
        setTimeout(function(){
            connectionStatus['forecast'] = false;
            var source = {'$tab':$teamBody, 'id': 'forecast', 'list_teams':[], 'list_members': list_members, 'json': json};
            usedRemoteActionResult(list_members, json, getForecastRecordsJs, getForecastRecordsJsComplete, source);
            $('#forecast_id').animate({backgroundColor: '#1F46E2'}, 560);
        }, 300);
        
        setTimeout(function(){
            connectionStatus['mixforecast'] = false;
            var source = {'$tab':$teamBody, 'id': 'mixforecast', 'list_teams':[], 'list_members': list_members, 'json': json};
            usedRemoteActionResult(list_members, json, getForecastMixRecordsJs, getForecastMixRecordsJsComplete, source);
            $('#mixforecast_id').animate({backgroundColor: '#1F46E2'}, 560);
        }, 300);
        asynConnectionChecking($teamBody);
    //    connectionQuery($teamBody); // sfdc connection query start
    }, 150);
    
//    var $teamBody=$('#team_body');
    if($teamBody.find('tr').length >= 10){ $teamBody.height(361); }
    event_Register();
}

;function getForecastRecordsJsComplete(result, event, source){
    if (event.status) {
        $('#'+source['id']+'_id').animate({backgroundColor: '#1FE26D'}, 100* Math.random() + 600);
        
        var list_result = $.parseJSON(result), list_newResult = [];

        while(list_result.length > 0){
            list_newResult.push( queryObject(list_result.shift()) );
        }
        source['list_teams'] = source['$tab'].find('tr').toArray();
        asynQueryProcess(list_newResult, source);

    } else{
        remoteActionError(event, source);
    }
    
    ;function queryObject(result){
        var o = {'amount':numberOfZero(result['Amount']), 'uid':result['Owner'], 'stage':result['Stage'], 'process':result['salesProcessId']};
        return o;
    }
    
}

;function getForecastMixRecordsJsComplete(result, event, source){
    if (event.status) {
        $('#'+source['id']+'_id').animate({backgroundColor: '#1FE26D'}, 100* Math.random() + 600);
        
        var list_result = $.parseJSON(result), list_newResult = [];
        while(list_result.length > 0){
            list_newResult.push( minQueryObject(list_result.shift()) );
        }
        source['list_teams'] = source['$tab'].find('tr').toArray();
        asynMinQueryProcess(list_newResult, source);

    } else{
        remoteActionError(event, source);
    }
    
    ;function minQueryObject(result){
        var o = {'amount':numberOfZero(result['Amount']), 'uid':result['Owner']};
        return o;
    }
}

;function remoteActionError(event, source){
    var btn='<span style="display: inline-block;" class="conercls cp"><img src="/s.gif" title="'+event['message']+'" class="errorimg conercls" /></span>'+
                '<input type="button" class="btn conercls" value="Reload" data-fn="reload" style="margin-left: 10px; margin-right: 20px;"/>'+
                '<input type="button" class="btn conercls" value="Cancel" data-fn="cancel" />';
        $('#'+source['id']+'_id').append(btn)
            .animate({backgroundColor: '#E86262'}, 100* Math.random() + 800).find('input[type="button"]')
            .each(function(){
                $(this).on('click', {source:source}, 
                            (this.getAttribute('data-fn') == 'reload' ? connection_reloada : connection_cancel));
            });
}

;function connection_reloada(e){
    var source=e.data.source;   //, callBack = {onSuccess: querySuccess, onFailure: queryFailure, source: source};
  //  console.log(source);
    $('#'+source['id']+'_id').animate({backgroundColor: '#1F46E2'}, 100* Math.random() + 800)
            .find('.conercls').remove();
    if(source['id'] == 'forecast'){
        usedRemoteActionResult(source['list_members'], source['json'], getForecastRecordsJs, getForecastRecordsJsComplete, source);
    }else{
        usedRemoteActionResult(source['list_members'], source['json'], getForecastMixRecordsJs, getForecastMixRecordsJsComplete, source);
    }
}

;function connectionQuery($teamBody){
    var $teamBody = $('#teamBodyId'), query_hide=$.trim($('[id*=queryjsonid]').val());
    if(query_hide != ''){
        var query_json=$.parseJSON(query_hide);
        createConnectionStatus(query_json);

        for(var i in query_json){
            connectionStatus[i] = false;
            var psql=query_json[i], source = {'$tab':$teamBody, 'id': i, 'psql': psql, 'list_teams':[]}, 
                callBack = {onSuccess: querySuccess, onFailure: queryFailure, source: source};
            $('#'+i+'_id').animate({backgroundColor: '#1F46E2'}, 560);
            sforce.connection.query(psql, callBack); 
        }

    }
    asynConnectionChecking($teamBody);
}

;function createConnectionStatus(query_json){
    document.getElementById('connStatus_id').style.display='';
    $('#conboxid').css({'top':'-400px', 'display':''}).animate({top:'10%'}, 560);
    var el_status=document.getElementById('constatusqueryid'), html_status='';
    for(var i in query_json){
        html_status +=('<fieldset class="conborder"><legend>'+(i=='mixQuery'?'Opportunitie Forecast': 'Opportunities')+
                    '</legend><div id="'+i+'_id" class="connyear tc"></div></fieldset>');
    }
    el_status.innerHTML=html_status;
}

;function querySuccess(result, source){

    if(typeof(result['size']) == 'undefined' || result['size'] == '0'){
        $('#'+source['id']+'_id').animate({backgroundColor: '#1FE26D'}, 100* Math.random() + 600);
        connectionStatus[source.id]=true;
        return;
    }
    var list_newResult=[], list_result=result["records"];
    source['list_teams'] = source['$tab'].find('tr').toArray();

    if(source['id'] == 'mixQuery'){   //mix and count query
        if($.isArray(list_result)){
            while(list_result.length > 0){
                list_newResult.push( minQueryObject(list_result.shift()) );
            }
        }else{
            list_newResult.push( minQueryObject(list_result) );
        }
        asynMinQueryProcess(list_newResult, source);
    }else{
        if($.isArray(list_result)){
            while(list_result.length > 0){
                list_newResult.push( queryObject(list_result.shift()) );
            }
        }else{
            list_newResult.push( queryObject(list_result) );
        }
        asynQueryProcess(list_newResult, source);
    }
    result["records"]=null;
    
    ;function minQueryObject(result){
        var o = {'amount':numberOfZero(result['Amount']), 'uid':result['Owner']};
        return o;
    }
    
    ;function queryObject(result){
        var o = {'amount':numberOfZero(result['Amount']), 'uid':result['Owner'], 'stage':result['Stage'], 'process':result['salesProcessId']};
        return o;
    }
    
}

;function queryFailure(error, source){
    var has=false;
    for(var i in error){if(error.hasOwnProperty(i)){has=true;}}
    if(has){
        var btn='<span style="display: inline-block;" class="conercls cp"><img src="/s.gif" title="'+error['faultstring']+'" class="errorimg conercls" /></span>'+
                '<input type="button" class="btn conercls" value="Reload" data-fn="reload" style="margin-left: 10px; margin-right: 20px;"/>'+
                '<input type="button" class="btn conercls" value="Cancel" data-fn="cancel" />';
        $('#'+source['id']+'_id').append(btn)
            .animate({backgroundColor: '#E86262'}, 100* Math.random() + 800)
            .find('input[type="button"]').each(function(){
                    $(this).on('click', {source:source}, 
                                (this.getAttribute('data-fn') == 'reload' ? connection_reload : connection_cancel));
                });
    //    console.log(error);
    //    console.log(source);
    //    console.log('onFailure: ' + source.id);
    }
//    connectionStatus[source.id]=true; 
}
;function connection_reload(e){
    var source=e.data.source, callBack = {onSuccess: querySuccess, onFailure: queryFailure, source: source};
    $('#'+source['id']+'_id').animate({backgroundColor: '#1F46E2'}, 100* Math.random() + 800)
            .find('.conercls').remove();
    sforce.connection.query(source['psql'], callBack); 
}
;function connection_cancel(e){
    var source=e.data.source;
    $('#'+source['id']+'_id').animate({backgroundColor: '#1FE26D'}, 100* Math.random() + 800)
        .find('.conercls').remove();
    connectionStatus[source.id]=true; 
}
;function asynMinQueryProcess(list_newResult, source){
    var map_teamAttribute = new customMap(), map_amount = new customMap(),
        mix_config = $.parseJSON( $.trim($('[id*=mixoppjsonid]').val()) );

    while(source['list_teams'].length > 0){ //init team object
        var el_tr=source['list_teams'].shift(), uid=el_tr.id, roleid=$.trim(el_tr.getAttribute('data-role'));
        map_amount.put(uid, []);
        map_teamAttribute.put(uid, {'amount':0, 'count':0, 'color': '', 'roleid': roleid});
    }

    while(list_newResult.length > 0){   //set contains user id amount values
        var newResult=list_newResult.shift();
        if(map_teamAttribute.containsKey(newResult['uid'])){
            var o = map_teamAttribute.get(newResult['uid']);
            o['amount'] += newResult['amount'];
            o['count'] += 1;
            map_amount.get(newResult['uid']).push(newResult['amount']);
        }
    }

    for(var i=0, _key, _value; _key=map_amount.keys()[i], _value=map_amount.get(_key); i++){
        var team_attribute=map_teamAttribute.get(_key), list_roles=_.keys(mix_config);
        if(team_attribute['roleid'] == 'null'){    //user role id isEmtpy
            team_attribute['color'] = 'mix_green';
            continue;
        }
        var hasRole=false;
        for(var x=0, role; role=list_roles[x]; x++){    //user role id not contains
            if(team_attribute['roleid'] == role){
                hasRole=true;
                break;
            }
        }

        if(!hasRole){
            team_attribute['color'] = 'mix_green';
            continue;
        }

        var mix_attr=mix_config[team_attribute['roleid']], total_amount = team_attribute['amount'],
            fc_countThreshold = roundFn(_value.length * mix_attr['bigOppyCountThreshold'], 0),
            op_amountThreshold = roundFn(total_amount * mix_attr['bigOppyAmountThreshold'], 2),
            avgTotalAmount = (_value.length !=0 ? roundFn(total_amount/_value.length, 2) : 0);

        _value.sort(orderByMaxValue); //order by max values

        if(fc_countThreshold == 0){
            team_attribute['color'] = 'mix_green';
        }else{
            var mix_tmp=0;

            for(var k=0, max=_value.length; k<fc_countThreshold && k<max; k++){
                mix_tmp += _value[k];
            }

            mix_tmp=roundFn(mix_tmp, 2);
            if(mix_tmp <= op_amountThreshold && avgTotalAmount >= mix_attr['avgAmount']){
                team_attribute['color'] = 'mix_green';
            }else if(mix_tmp <= op_amountThreshold &&  avgTotalAmount < mix_attr['avgAmount']){
                team_attribute['color'] = 'mix_yellow';
            }else { // if(roundFn(mix_tmp, 2) > op_amountThreshold)
                team_attribute['color'] = 'mix_red';
            }

        }
    }
    map_amount.clear();


    for(var i=0, _key, _value; _key=map_teamAttribute.keys()[i], _value=map_teamAttribute.get(_key); i++){
        var $mix_cell=source['$tab'].find( ('tr#'+_key+' td.miximg') ), $count_cell=$mix_cell.next();
        $mix_cell[0].setAttribute('data-value', _value['amount']);
        $count_cell[0].setAttribute('data-value', _value['count']);
        $mix_cell.children().css('display', 'none').addClass( ('allimg '+_value['color']) );
    }

    map_teamAttribute.clear();
    $('#'+source['id']+'_id').animate({backgroundColor: '#1FE26D'}, 100* Math.random() + 600);
    connectionStatus[source.id]=true;
}

;function asynQueryProcess(list_newResult, source){

    //    console.log(source['psql']);

    var map_teamAttribute=new customMap(), o_cell = {};
        
    $('#teamheadid tr:first th.pipeline, th.converted, th.won, th.hold').each(function(){
        var stageName=$.trim(this.getAttribute('matchName'));
        if(stageName != ''){ 
            var list_p=stageName.split(';'), list_process=list_p[0].split(','), stage=list_p[1];
            o_cell[stageName] = {'amount': 0, 'cell': this.cellIndex, 'process':list_process, 'stage':stage};
        }
    });

    while(source['list_teams'].length > 0){
        var el_tr=source['list_teams'].shift(), uid=el_tr.id, clone_stageCell=jsclone(o_cell);
        map_teamAttribute.put(uid, clone_stageCell);
    }

    while(list_newResult.length > 0){
        var newResult=list_newResult.shift();

        if(map_teamAttribute.containsKey(newResult['uid'])){
            var stageName_cell = map_teamAttribute.get(newResult['uid']);

            for(var stageName in stageName_cell){

                for(var x=0, _process; _process=stageName_cell[stageName]['process'][x]; x++){
                    if(_process == newResult['process'] && stageName_cell[stageName]['stage'].indexOf(newResult['stage']) != -1){
                        stageName_cell[stageName]['amount'] += newResult['amount'];
                        break;
                    }
                }
                
                /*
                if(_eq && stageName_cell[stageName]['stage'].indexOf(newResult['stage']) != -1){
                    stageName_cell[stageName]['amount'] += newResult['amount'];
                }
                if( _.contains(stageName_cell[stageName]['process'], newResult['process']) && 
                        stageName_cell[stageName]['stage'].indexOf(newResult['stage']) != -1){
                            
                    stageName_cell[stageName]['amount'] += newResult['amount'];
                }
                */
            }
        }
    }

    for(var i=0, _key, _value; _key=map_teamAttribute.keys()[i], _value=map_teamAttribute.get(_key); i++){
        var $tr=source['$tab'].find( ('tr#'+_key) );
        for(var stageName in _value){
            $tr[0].cells[_value[stageName]['cell']].setAttribute('data-value', _value[stageName]['amount']);
        }
    }
    $('#'+source['id']+'_id').animate({backgroundColor: '#1FE26D'}, 100* Math.random() + 600);
    connectionStatus[source.id]=true;
}

;function asynConnectionChecking($teamBody){
    var clearTimer = window.setInterval(function(){
            var isStop = true;
            for(var i in connectionStatus){ if(!connectionStatus[i]){ isStop = false; break; } }
    //isStop=false;
        if(isStop){
            clearInterval(clearTimer);
            connectionStatus = {};
            
            setTimeout(function(){
                $('#conboxid').animate({'top': '-400px'}, 660, function(){
                    document.getElementById('connStatus_id').style.display = 'none';
                });
            }, 1200);
            
            sumOf_team($teamBody);
        }
    }, 500);
}

;function sumOf_team($teamBody){
    
    var allTotal=0, o_total={}, el_teamRow=document.getElementById('teamrowtotalid'), list_teams=$teamBody.find('tr').toArray();
    
    $('#teamheadid tr:first th:gt(0)').each(function(){ o_total[this.cellIndex]=0; });

    async.times(list_teams.length, asynTeamSum, asynTeamSumComplete);
    
    
    ;function asynTeamSum(n, callback){
        setTimeout(function(){
            sumOf_Converted_Won_Pending_Total(list_teams.shift(), function(err) {
                callback(err);
            });
        },delay(n));
    }
    
    ;function asynTeamSumComplete(err){
        document.getElementById('spanalltotalid').setAttribute('data-value', allTotal);
        for(var o in o_total){
            el_teamRow.cells[o].setAttribute('data-value', o_total[o]);
        }

        o_total={};
        finally_format($teamBody, el_teamRow);
    }

    ;function sumOf_Converted_Won_Pending_Total(el_teams, callBack){
        var $teams=$(el_teams), 
            cell_converted=$teams.find('td.converted')[0], val_converted=numberOfZero(cell_converted.getAttribute('data-value')),
            cell_won=$teams.find('td.won')[0], val_won=numberOfZero(cell_won.getAttribute('data-value')),
            cell_cwon=$teams.find('td.cwon')[0], val_cwon=0,
            cell_pending=$teams.find('td.pipeline')[0], val_pending=numberOfZero(cell_pending.getAttribute('data-value')),
            cell_total=$teams.find('td.total')[0], val_total=0,
            cell_onhold=$teams.find('td.hold')[0], val_onhold=numberOfZero(cell_onhold.getAttribute('data-value')),
            cell_mix=$teams.find('td.miximg')[0], val_mix=numberOfZero(cell_mix.getAttribute('data-value')),
            cell_count=$teams.find('td.countcls')[0], val_count=numberOfZero(cell_count.getAttribute('data-value'));
            
        val_cwon=(val_converted+val_won);
        val_total=(val_cwon+val_pending);
        allTotal += val_total;
        
        cell_cwon.setAttribute('data-value', val_cwon);
        cell_total.setAttribute('data-value', val_total);
        
        o_total[cell_converted.cellIndex] += val_converted;
        o_total[cell_won.cellIndex] += val_won;
        o_total[cell_cwon.cellIndex] += val_cwon;
        o_total[cell_pending.cellIndex] += val_pending;
        o_total[cell_total.cellIndex] += val_total;
        
        o_total[cell_onhold.cellIndex] += val_onhold;
        o_total[cell_mix.cellIndex] += val_mix;
        o_total[cell_count.cellIndex] += val_count;
        
        callBack(null);
    }
    
}

;function finally_format($teamBody, el_teamRow){

    var list_tds=$teamBody.find('td.w2, td.w3, td.w4, td.w5, td.w6, td.w7, td.w9').toArray();
    
    async.times(list_tds.length, asynTeamFormat, asynTeamFormatComplete);
    async.times(el_teamRow.cells.length, asynTeamFootFormat, function(err){});
    
    
    ;function asynTeamFootFormat(n, callback){
        setTimeout(function(){
            var cell_td=el_teamRow.cells[n];
            if(n > 0){
                var $celltd=$(cell_td), decimalPoint=($celltd.hasClass('countcls') ? 'n0' : 'n');
                    _value=numberOfZero( $.trim(cell_td.getAttribute('data-value')) );
                    
                if($celltd.hasClass('miximg')){
                    
                }else{
                    $celltd.find('div.valcls').html(Globalize.format(_value, decimalPoint));
                }
            }
            callback(null);
        },delay(n));
    }
    
    
    ;function asynTeamFormat(n, callback){
        setTimeout(function(){
            var _this=list_tds.shift(), $this=$(_this), decimalPoint=($this.hasClass('countcls') ? 'n0' : 'n'),
                _value=numberOfZero( $.trim(_this.getAttribute('data-value')) );
            $this.find('div').html(Globalize.format(_value, decimalPoint));
            callback(null);
        },delay(n));
    }
    
    ;function asynTeamFormatComplete(err){
        hideLoading();
        $teamBody.find('td.w8').each(function(){
            $(this).find('div').fadeIn(800);
        });
        var el_alltotal=document.getElementById('spanalltotalid'), alltotal=numberOfZero(el_alltotal.getAttribute('data-value'));
        alltotal = '$ ' + (Globalize.format(alltotal, 'n'));
        el_alltotal.title = alltotal;
        el_alltotal.innerHTML = alltotal;
    }

}

;function windowReSize(){
    fixTeamTableWidth();
}
;function fixTeamTableWidth(resize_width){
    $('#allcontentid').width($('#AppBodyHeader').outerWidth(true)-60).css({'visibility':'visible'});
    fixTeamOppyTableWidth();
}
;function fixTeamOppyTableWidth(){
    var $teamBox=$('#team_box'), w=$teamBox.outerWidth(true)-scrollbarW+1;
    $('div.fix_width').css({'width': w})
        .find('th:last div.headright, th:last div.footright')
        .removeClass('headright footright');
}
;function hideLoading(){
    document.getElementById('pageLoading').style.display='none';
}
;function showLoading(){
    document.getElementById('pageLoading').style.display='';
}




;function numberOfZero(t){
    return ($.isNumeric(t) ? parseFloat(t) : 0);
}

;function numberOfZero1(t){
    return ($.isNumeric(t) ? parseInt(t, 10) : 0);
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

function delay(n){return (n+12) % 7 *100;}
function orderByMaxValue(a,b){return (a<b?1:-1);}
;function artMsg(content, target, callBackOk){
    art.dialog({
        title:' ', lock:true, dblclick_hide:false, esc:false, id: 'countsid',
        content: content,
        button : [ {value: 'OK', focus: true, callback: function(){ callBackOk(target); }} ]
    });
}
$.fn.inputFocusDate = function(validationType, e){       //input the history of value is saved
    var eventConfig = {
        focus : function(){
            focusDate = '';
            var focus_val = $.trim($(this).val());
            if(validationType.test(focus_val)){focusDate = focus_val;}
        }
    };
    if($.isFunction(eventConfig[e.type])){eventConfig[e.type].call(this, e);}
    return oldValue;
}
;function addListener (element, event, fn, params) {
    var eventHandler = ( params ? function(){ fn.call(params); } : fn );
    if (window.attachEvent) {
        element.attachEvent('on' + event, eventHandler);
    } else {
        element.addEventListener(event, eventHandler, false);
    }
}
;function eventHandle_ov_ot(e, _over, _out){
    var customMouser = {mouseenter: _over,mouseleave: _out};
    customMouser[e.type].call(this, e);customMouser = {};
}
;function eventHandle(e, _over, _out, _click){
    var customMouser = {mouseenter: _over,mouseleave: _out,click: _click};
    customMouser[e.type].call(this, e);customMouser = {};
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
var cSort = (function(){
    var cSort = {};
    
    cSort.elementAsc = function (_cellIndex, list_element, attrName, $element, isMatch){
        var list_data=[], element_catch={};
        if(isMatch){
            var isNumber= matchSetElementValue(_cellIndex, list_data, element_catch, list_element, attrName);
            if(isNumber){
                list_data.sort(compare_number_asc);
            }else{
                list_data.sort(compare_asc);
            }
        }else{
            setElementValue(_cellIndex, list_data, element_catch, list_element, attrName);
            list_data.sort(compare_asc);
        }
        appendSortByValues(list_data, element_catch, $element);
        list_data=element_catch='';
    };
    cSort.elementDesc = function (_cellIndex, list_element, attrName, $element, isMatch){
        var list_data=[], element_catch={};
        if(isMatch){
            var isNumber = matchSetElementValue(_cellIndex, list_data, element_catch, list_element, attrName);
            if(isNumber){
                list_data.sort(compare_number_desc);
            }else{
                list_data.sort(compare_desc);
            }
        }else{
            setElementValue(_cellIndex, list_data, element_catch, list_element, attrName);
            list_data.sort(compare_desc);
        }
        appendSortByValues(list_data, element_catch, $element);
        list_data=element_catch='';
    };
    
    cSort.clearMark = function($parent, cellIndex){
        $parent.find('th').each(function(idx){
            if(idx != cellIndex){
                $(this).find('span.asc, span.desc').removeClass('asc desc').html(' ');
            }
        });
    };
    
    cSort.expReplace = function(v){
        var m = /([\w\W]+)@@@@@@@@@@[\w\W]+$/.exec(v);
        return (m==null || typeof(m) == 'undefined' ? '' : m[1]);
    };
    return cSort;
    
    ;function compare_asc(x, y){
        x=cSort.expReplace(x); 
        y=cSort.expReplace(y);
        if (x > y) {return 1;}
        if (x < y) {return -1;}
        else{ return 0;}
    };
    
    ;function compare_desc(x, y){
        x=cSort.expReplace(x); 
        y=cSort.expReplace(y);
        if (x > y) {return -1;}
        if (x < y) {return 1;}
        else{ return 0;}
    };
    ;function compare_number_asc(x, y){
        x=cSort.expReplace(x); 
        y=cSort.expReplace(y);
        x=($.isNumeric(x)? parseFloat(x) : 0);
        y=($.isNumeric(y)? parseFloat(y) : 0);
        return (x-y);
    };
    ;function compare_number_desc(x, y){
        x=cSort.expReplace(x); 
        y=cSort.expReplace(y);
        x=($.isNumeric(x)? parseFloat(x) : x);
        y=($.isNumeric(y)? parseFloat(y) : y);
        return (y-x);
    };
    
    ;function matchSetElementValue(cellIndex, list_data, element_catch, list_element, attrName){
        var isNumber=false;
        for(var i=0, _element; _element=list_element[i]; i++){
            var match_name=$.trim( _element.cells[cellIndex].getAttribute('data-match') ), 
                sortName=$.trim( _element.cells[cellIndex].getAttribute(attrName) );
                
            if(match_name == 'size' || match_name == 'health' || match_name == 'projected'){
                sortName = numberOfZero1($.trim(sortName.split('_')[2]));
                if(sortName == 'empty'){ sortName=0; }
                isNumber=true;
            }else if(match_name == 'enddate'){
                sortName = (+new Date(sortName));
                sortName = numberOfZero1(sortName);
                isNumber=true;
            }else if(match_name == 'precntage' || match_name == 'amount'){
                isNumber=true;
            }else if(match_name == 'converted' || match_name == 'won' || match_name == 'cwon' || match_name == 'pending' || match_name == 'total' || match_name == 'hold' || match_name == 'count'){
                isNumber=true;
            }
            sortName=(sortName+'@@@@@@@@@@'+i);
            element_catch[sortName] = _element;
            list_data.push(sortName);
        }
        return isNumber;
    }
    ;function setElementValue(cellIndex, list_data, element_catch, list_element, attrName){
        for(var i=0, _element; _element=list_element[i]; i++){
            var sortName=$.trim(_element.cells[cellIndex].getAttribute(attrName)+'@@@@@@@@@@'+i);
            element_catch[sortName] = _element;
            list_data.push(sortName);
        }
    }
    ;function appendSortByValues(list_data, element_catch, $element){
        for(var i=0, _data; _data=list_data[i]; i++){
            var cls=(i%2 == 0 ? '' : 'old');
            $element.append($(element_catch[_data]).removeClass('old').addClass(cls));
        }
    }
}());

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

function usedRemoteAction(strParam, callFunction, callResult) {
    Visualforce.remoting.Manager.invokeAction(
        callFunction(), strParam, function(result, event){ callResult(result, event); }, {escape: false}
    );
}

function usedRemoteActionResult(strParam, strParam1, callFunction, callResult, t) {
    Visualforce.remoting.Manager.invokeAction(
        callFunction(), strParam, strParam1, function(result, event){ callResult(result, event, t); }, {escape: false}
    );
}

function usedMultipleRemoteAction(strParam, strParam1, callFunction, callResult) {
    Visualforce.remoting.Manager.invokeAction(
        callFunction(), strParam,  strParam1, function(result, event){ callResult(result, event); }, {escape: false}
    );
}