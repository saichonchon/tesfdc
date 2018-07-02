/*** some variables global used --begin ***/
	var alertTimeControl=1,newDatePick,confidences=[],oldStatusVal={},_oldStatusVal={},optionBackup,
		isBOM,locale,currencylabel,forecastLevel,gSaveStrs,Map_Pid_Price,
		gPriceDigit=5,//gPriceDigit allow 5 digit decimal		
		map_PartIds,isAppOrIndBu,map_partData,
		tipBuPrev,tipBuNew,range4Mark,reason_options,isProgramPage = false,
		isBUEdited = false,map_OldValue;

	//specially for the picklist
	var Gconfidence1 = ['On Hold','Weak','50/50','Likely','Commit','Dead','Lost','TAM'],
		Gconfidence2 = ['Won'],
		Gstatus1 = ['Concept','Demo','Designed','Prototyped/Sampled','Quoted'],
		Gstatus2 = ['Concept','Demo','Designed','Prototyped/Sampled','Quoted','Pre-prod','Production','Ramp-down','EOL'],
		Gstatus3 = ['Concept','Designed'],
		Gstatus4 = ['Concept','Designed','Pre-prod','Production','Ramp-down','EOL'],
                // Updated Raul 2016.04.18 Begin
		Gstatus5 = ['Concept','Quoted','Designed','On Customer AVL'],
		Gstatus6 = ['Concept','Quoted','Designed','On Customer AVL','Pre-prod','Production'],
                // Updated Raul 2016.04.18 End
		GstatusFinal = ['Production'];
 
/*** some variables global used --end ***/
/* a remote action, but now useless
function calQuarterStartDate(cancelVal, inputVal, fieldId){
	ExtOppyForecastEntryPage.getForecastQuarterStartDate(inputVal,
	function(result, event) {
		if (result == '' || result == null) {
			alert("Cant't find the start date!");
			document.getElementById(fieldId).value = cancelVal;
			return false;
		}
		else{
			if (!confirm('The start date will be ' + result + ' Are you sure?')){
				document.getElementById(fieldId).value = cancelVal;
				return false;
			}
			else{
				document.getElementById(fieldId).value = result;
				return false;
			}
		}
	});
}
*/
function openLookupPopup(partId, status, fieldId,_locale,_isBOM){
	var reason = document.getElementById(fieldId + 'Reason');
	var reasonText = document.getElementById(fieldId + 'ReasonText');
	var reasonCompetitor = document.getElementById(fieldId + 'ReasonCompetitor');
	var oldStatus = document.getElementById(fieldId + 'OldStatus');
	var neighbour = $(reason).parent().next().find('select');
	//if(status == 'Won'){		-- 2012-08-30 revised by Fuqi, reason: 'Won' can be selected.
	//	alert("The status Won can't be selected manually!");
	//	document.getElementById(fieldId).value = oldStatus.value;
	//	return;
	//}
	
	// Prabhanjan : adding Won to this logic as to get the popup for Won status.
	
	if(status != 'Lost' && status != 'Dead' && status != "Won"){
		oldStatus.value = status;
		reason.value = '';
		reasonText.value = '';
		reasonCompetitor.value = '';
		oldStatusVal[fieldId] = status;
		oldStatusVal[neighbour.attr('id')] = neighbour.val();
		if(locale&&isBOM) onConfidenceSelect();
	}
	else{
		var showpopup; 
		if(status == "Won"){
            showpopup=true;
		}
		else{
			showpopup = confirm('The forecasts in part with Lost or Dead confidence status will not be calculated into total revenue. Are you sure?')
		}
		if (!showpopup) {
			//document.getElementById(fieldId).value = oldStatusVal[fieldId];
			//neighbour.val(oldStatusVal[neighbour.attr('id')]);
			resumeSel(fieldId)
			return;
		}
		else{
			$("#mask").show();
			$("#mask").css({
				visibility : 'visible'
			});
			
		 	$(   
			  '<div id="status_content_window" style="width:100% !important;" >' + '<div id="status_popcontent">'
			   + '<div id="loading">'
			   + '<img src="/changemgmt/img/spinner24.gif"/>'
			   + '</div>'
			   + '<iframe frameborder="0" id="theIframe" width="100%" height="180px" name="theIframe" src="/apex/CtrlOppyPartLookupPage?partId='+ partId + '&status=' + status + '&fieldId=' + fieldId + '&reason=' + reason.value + '&reasonText=' + reasonText.value + '&reasonCompetitor=' + reasonCompetitor.value +'"/>'
			   + '</div>'
			   + '<div style="background-color:white;text-align:center">'
			   + '</div></div>').appendTo("#status_window");	
			$("#status_window").css({
				"z-index" : 99999
			});			
		}	
	}
}
function openLookupPopupOnExtOppForecast(partId, status, fieldId,_locale,_isBOM){
	var tempId = '';
	if(fieldId.indexOf('_')){
		tempId = fieldId.toString().substring(0,fieldId.toString().length-1);
	}
	
	var reason = document.getElementById(tempId + 'Reason');
	var reasonText = document.getElementById(tempId + 'ReasonText');
	var reasonCompetitor = document.getElementById(tempId + 'ReasonCompetitor');
	var oldStatus = document.getElementById(tempId + 'OldStatus');
	var neighbour = $(reason).parent().next().find('select');
	//if(status == 'Won'){		-- 2012-08-30 revised by Fuqi, reason: 'Won' can be selected.
	//	alert("The status Won can't be selected manually!");
	//	document.getElementById(fieldId).value = oldStatus.value;
	//	return;
	//}
	if(status != 'Lost' && status != 'Dead'){
		oldStatus.value = status;
		reason.value = '';
		reasonText.value = '';
		reasonCompetitor.value = '';
		oldStatusVal[fieldId] = status;
		oldStatusVal[neighbour.attr('id')] = neighbour.val();
		if(locale&&isBOM) onConfidenceSelect();
	}
	else{
		if (!confirm('The forecasts in part with Lost or Dead confidence status will not be calculated into total revenue. Are you sure?')) {
			//document.getElementById(fieldId).value = oldStatusVal[fieldId];
			//neighbour.val(oldStatusVal[neighbour.attr('id')]);
			resumeSel(fieldId)
			return;
		}
		else{
			$("#mask").show();
			$("#mask").css({
				visibility : 'visible'
			});
			
		 	$(   
			  '<div id="status_content_window" style="width:100% !important;" >' + '<div id="status_popcontent">'
			   + '<div id="loading">'
			   + '<img src="/changemgmt/img/spinner24.gif"/>'
			   + '</div>'
			   + '<iframe frameborder="0" id="theIframe" width="100%" height="150px" name="theIframe" src="/apex/CtrlOppyPartLookupPage?partId='+ partId + '&status=' + status + '&fieldId=' +  tempId + '&fieldSPINId=' + fieldId + '&reason=' + reason.value + '&reasonText=' + reasonText.value + '&reasonCompetitor=' + reasonCompetitor.value +'"/>'
			   + '</div>'
			   + '<div style="background-color:white;text-align:center">'
			   + '</div></div>').appendTo("#status_window");	
			$("#status_window").css({
				"z-index" : 999992
			});			
		}	
	}
}
function setOldValue(field){
	var $sel = $(document.getElementById(field));
	oldStatusVal[field] = $sel.val();
	$sel = $sel.parent().next().find('select');
	oldStatusVal[$sel.attr('id')] = $sel.val();
	
	removeOptionsWhenNotAdmin(fieldId); /////MAY8,2014 fix select issue
}
//ATTENTION: This function is also used in page CtrlOppyPartLookupPageDND
//So do check if any influence to that page in case you want to modify.
function resumeSel(fieldId){ 
	var flag = false,
			isFind = false,
			status2 = Gstatus2,
			statusFinal = GstatusFinal,
			$sel = $(document.getElementById(fieldId));

		// 2014-06-09 Michael Cui: added for case 00677873		
		if(isAppliance())
		{
			status2 = Gstatus4;
		}

                // Updated Raul 2016.04.18 Begin
                if(isDND())
		{
			status2 = Gstatus6;
            //Start: Added by Rajendra Shahne 2016.09.28 for case 901088
			$sel1 = $(document.getElementById(fieldId));			
			$sel1 = $sel1.parent().next().find('select');
			//alert('val ' +$sel1.children()[1].value);
			if($sel1.children().length > 4) 
			{ 
				$sel1.children()[5].remove(); 
				$sel1.children()[4].remove(); 
			} 
			//alert('old val ' + $sel1.attr('id'));
			//alert('asdf ID ' + oldStatusVal[$sel1.attr('id')]);
			$sel1.val(oldStatusVal[$sel1.attr('id')]).change();
			//End: Added by Rajendra Shahne 2016.09.28 End for case 901088
		}
                // Updated Raul 2016.04.18 End

		$sel.val(oldStatusVal[fieldId]);		
		if('Won'==$sel.val()){
			flag = true;
		}
		$sel = $sel.parent().next().find('select');
		if(flag){
			$sel.children().each(function(){
				if(itemInArray(this.value, statusFinal) || this.value === 'Pre-prod') {
					isFind = true;
					return false;
				}
			});
			if(!isFind){
				var optStr = '<option value="Pre-prod">Pre-prod</option>';
				for(var k=0; k<statusFinal.length; k++){
					optStr += '<option value="' + statusFinal[k] + '"';						
					optStr += '>' + statusFinal[k] + '</option>';
				}
				$sel.append(optStr);
			} 

		}
		//$sel.val(oldStatusVal[$sel.attr('id')]);
		removeOptionsWhenNotAdmin(fieldId); /////MAY8,2014 fix select issue
}

function removeOptionsWhenNotAdmin(fieldId){ /////MAY8,2014 fix select issue

	if(isUserAdmin()) return;
	//if(window.console) console.log('remove option for non-admin:'+fieldId);
	var el = document.getElementById(fieldId);

	var confidenceEl,statusEl;
	if(el.className == 'selectConfidence'){
		confidenceEl = el;
		statusEl = $(el).parent().next().find('select');
	}else{
		statusEl = el;
		confidenceEl = $(el).parent().next().find('select');
	}

	if($(confidenceEl).val() != 'Won') return;

	var status1 = ['Concept','Demo','Designed','Prototyped/Sampled','Quoted'];
	var statusOldValue = oldStatusVal[$(statusEl).attr('id')];
	
	// 2014-06-09 Michael Cui: added for case 00677873	
	if(isAppliance())
	{
		status1 = Gstatus3;		
	}

        // Updated Raul 2016.04.18 Begin
        if(isDND())
        {
                status1 = Gstatus5;
        }
        // Updated Raul 2016.04.18 End

	$(statusEl).children().each(function(){
		if(itemInArray($(this).val(),status1)){
			$(this).remove();
		}else if($(this).val() == statusOldValue){
			$(this).attr('selected','selected');
		}else{
			$(this).removeAttr('selected');
		}
	});
}

function popRemove(fieldId) {
	if(fieldId){
		resumeSel(fieldId);
	}else{
		
	}
	$("#status_content_window").remove();
	$("#mask").hide();
}
/***used on program page***/
function showAllDisplays(el){
	var $el = $(el),
		title = $el.attr('title'),
		$rows = $(getParent(el,'TABLE')).children('tbody').children();
	if(title=='Show'){
		$el.attr('title','Hide').removeClass('stlb').addClass('htlb');
		$rows.each(function(idx){
			if(idx>0){
				if(idx%5!=1){
					$(this).show();
				}else{
					$(this).children().eq(0).children('img').attr('title','Hide').removeClass('stlb').addClass('htlb');
				}
			}
		});
	}else{
		$el.attr('title','Show').removeClass('htlb').addClass('stlb');
		$rows.each(function(idx){
			if(idx>0){
				if(idx%5!=1){
					$(this).hide();
				}else{
					$(this).children().eq(0).children('img').attr('title','Show').removeClass('htlb').addClass('stlb');
				}
			}
		});
	}
	$el = title = $rows = null;	
} 
/***used on program page***/
function showProDisplays(el){
	var $el = $(el),
		title = $el.attr('title'),
		$row = $el.parent().parent(),
		p = $row.prevAll().length,
		$rows = $row.parent().children(),
		i,j,allShow=true,allHide=true;
	if(title=='Show'){
		$el.attr('title','Hide').removeClass('stlb').addClass('htlb');
		for(i=1;i<5;i++){
			$rows.eq(p+i).show();
		}
	}else{
		$el.attr('title','Show').removeClass('htlb').addClass('stlb');;
		for(i=1;i<5;i++){
			$rows.eq(p+i).hide();
		}
	}
	for(i=1,j=$rows.length;i<j;i++){
		if(i%5===1){
			if('Show' == $rows.eq(i).children().eq(0).children('img').attr('title')){
				allShow = false;
			}else{
				allHide = false;
			}
			if(allShow==false && allHide==false) break;
		}
	}
	if(allShow){
		$('#opportunityBtn').attr('title','Hide').removeClass('stlb').addClass('htlb');
	}else if(allHide){
		$('#opportunityBtn').attr('title','Show').removeClass('htlb').addClass('stlb');
	}
	title = $el = $row = $rows = null;	
} 
/*** showdisplays - show or hide rows when "+","-" is clicked ***/
function kn(button,title,ctrlCls){
	var shiftRow;
	if(ctrlCls){//the 'opportunityBtn' button
		shiftRow=$(button).parent().parent();
	}
	var ary = [],$partRows,$tables;
	var p = $(button).parent().parent().prevAll().length,
		recycle = getRecycle(),
		i,j;
	p ++;
	if(ctrlCls){
		j=recycle-2;
	}else{
		j=recycle-1;
	}
	for(i=0;i<j;i++){
		ary.push(p+i);
	}
	if(title=='Show'){
		button.title = 'Hide';
		button.className = 'htlb';
		ady($('#list_TableLeft'),ary,true);
		if(ctrlCls){shiftRow.addClass('noBorderTr');}//hide the row bottom border
		ady($('#partTable'),ary,true);
		$('#yearsTableTr').children().each(function(){
			ady($(this).children(),ary,true);
		});
	}else{
		button.title = 'Show';
		button.className = 'stlb';
		
		ady($('#list_TableLeft'),ary,false);
		if(ctrlCls){shiftRow.removeClass('noBorderTr');}//show the row bottom border
		ady($('#partTable'),ary,false);
		$('#yearsTableTr').children().each(function(){
			ady($(this).children(),ary,false);
		});
	}
	ary = null;
}
/*** show or hide rows for the provided table ***/
function ady($table,ary,action){//asistDisplay
	var r = $table.children('tbody').children();
	if(action == true){//show rows
		for (var i = 0,j = ary.length; i<j; i++){
			r.eq(ary[i]).show();
		}
	}else{//hide rows
		for (var i = 0,j = ary.length; i<j; i++){
			r.eq(ary[i]).hide();
		}
	}
	r = undefined;
}
/*** when mouse in or out, show rows background color effect,"productRowMouseEffect" ***/
function om(elem, effect, flag){
	var position = $(elem).prevAll().length;
	if(effect === 1){//mouse over
		if(!flag){
			ase($('#list_TableLeft'),position,true);
		}
		ase($('#partTable'),position,true);
		$('#yearsTableTr').children().each(function(){
			ase($(this).children(),position,true);
		});
	}else{
		if(!flag){
			ase($('#list_TableLeft'),position,false);
		}
		ase($('#partTable'),position,false);
		$('#yearsTableTr').children().each(function(){
			ase($(this).children(),position,false);
		});
	}
}
/*** assit to "productRowMouseEffect" ***/
function ase($table,position,action){//asistMouseEffect
	var r = $table.children('tbody').children().eq(position);
	if(action == true){
		r.css('background-color','#E3F3FF');
	}else{
		if(r.hasClass('Qzone')) {
			r.css('background-color','#E4EDF7');
		}else{
			r.css('background-color','#FFF');
		}
	}
	r = undefined;
}		

/*** string to number ***/
function fmtNum(num,format,isInt,isPrice){
	if(!num) return 0;	
	if(num.indexOf('E+')>0){
		num = num.split('E+');
		var base = num[0];
		var multi = num[1];
		base = parseFloat(base);
		multi = parseInt(multi,10);
		for(var i=0;i<multi;i++)
		base *= 10;
		return base;
	}
	if(format === 0){
		format = locale;
	}
	var isEndWithK=/[K,k]$/.test(num),
		isEndWithM=/[M,m]$/.test(num),	
		isEndWithB=/[B,b]$/.test(num),
		isEndWithT=/[T,t]$/.test(num);		
		if(format==='de'){
			num=num.replace(/[^\d\,]/g,''); // filter all but number and comma
			num=num.replace(',','.');//replace with decimal
		}else{
			num=num.replace(/[^\d\.]/g,''); //filter all but number and period
		}
		num=parseFloat(num);	
		if(isNaN(num)) num=0;
		if(isEndWithK){
			num*=1000;
		}else if(isEndWithM){
			num*=1000000;
		}else if(isEndWithB){
			num*=1000000000;
		}else if(isEndWithT){
			num*=1000000000000;
		}
		if(isInt){
			num=Math.round(num);
		}else{
			if(isPrice){
				var tmp=1;
				for(var i=0;i<gPriceDigit;i++){
					tmp *=10;
				}
				num=Math.round(num*tmp)/tmp;
			}else{
				num=Math.round(num*100)/100;
			}
		}
		return num;	
}
/*** number to string ***/
function showFormat(num,a){
	num=''+num;
	var spt,deci,numint,numdec,numlen,result='',position;
	if(locale==='de'){
		spt='.',deci=',';
	}else{		
		spt=',',deci='.';
	}
	position=num.lastIndexOf('.');
	if(position>=0){
		numdec=num.substr(position+1);
		if(position>0)numint=num.substring(0,position);
	}else{
		numint=num;
	}
	numlen=numint.length; 
	while(numlen>3){
		var deduct=numlen%3;
		if(deduct === 0) {deduct = 3;}
		result+=numint.substr(0,deduct)+spt;
		numint=numint.substr(deduct);
		numlen=numlen-deduct;		
	}
	result+=numint; 
	if(position>=0){
		result=result+deci+numdec;
	}
	return result;
}

/*** compute table data and show results ***/
function tp(inputEl,year,isPart,isView){
	if(isPart===true&&isBOM!=='BOM'){
		return;
	}
	var recycle=getRecycle();
	var partArray=new Array(),
		$tables = [],
		tableArray,
		amountArray,
		elemArray = [],
		i,j,k,temp9,that,f,g,
		$el,
		hasLargeNum,
		saveStrs = [];
	if(year&&confidences.length===0){
		//if provided year and there is no 'Lost' or 'Dead',just process the year table		
		$tables.push($('#'+year+'Table'));
	}else{//otherwise considering the 'Lost' or 'Dead' influence,it is necessary to process all year tables
		$('#yearsTableTr').children().each(function(idx){
			$tables.push($(this).children());
		});
	}
	if(isView){//view mode
		if(isBOM =="BOM"){
			f=0;		
			var mod,ta = 0,td;
			for(i=0,j=$tables.length;i<j;i++){
				that = $tables[i].children('tbody').children();
				for(k=that.length-1;k>=0;k--){
					if(k>recycle){
						mod = k%recycle;
						if(mod>2||mod===0){
							td = that.eq(k).children();						
							g = parseFloat(td.children('input').val());
							f += g;
							g = showFormat(g);
							td.children('span').text(g);
						}else if(mod ===2){
							td = that.eq(k).children();
							g = parseFloat(td.children('input').val());
							td.children('span').text(showFormat(g))
						}else if(mod===1){
							that.eq(k).children().children('span').text(showFormat(f));						
							if(!itemInArray(k,confidences))ta += f*g;
							f = 0;
						}
					}else if(k<recycle){
						if(k>1){
							td = that.eq(k).children();
							g = parseFloat(td.children('input').val());
							f += g;
							g = showFormat(g);
							td.children('span').text(g);
						}else if(k===1){
							that.eq(k).children().children('span').text(roundToKM(f));
							f = 0;
						}else{
							that.eq(k).children().children('span').text(currencylabel+roundToKM(ta));
							ta = 0;
						}
					}
				}
			}
		}else{
			f=0;		
			var mod,ta = 0,td,amts = [],subAmts=[],r,s,u;
			for(i=0;i<recycle-2;i++){
				amts[i] = subAmts[i] = 0;
			}
			for(i=0,j=$tables.length;i<j;i++){
				that = $tables[i].children('tbody').children();
				for(k=that.length-1;k>=0;k--){
					if(k>recycle){
						mod = k%recycle;
						if(mod>2||mod===0){
							td = that.eq(k).children();						
							g = parseFloat(td.children('input').val());
							f += g;
							if(mod ===0)subAmts[0] = g;
							else subAmts[recycle-mod] = g;
							g = showFormat(g);
							td.children('span').text(g);
						}else if(mod ===2){
							td = that.eq(k).children();
							g = parseFloat(td.children('input').val());							
							td.children('span').text(showFormat(g));
						}else if(mod===1){
							that.eq(k).children().children('span').text(showFormat(f));						
							if(!itemInArray(k,confidences)){
								ta += f*g;
								for(r=0,s=subAmts.length;r<s;r++){
									amts[r] += subAmts[r]*g;
								}
							}
							f = 0;
						}
					}else if(k<recycle){
						if(k>1){
							td = that.eq(k).children();
							g = parseFloat(td.children('input').val());
							f += g;
							u = recycle-k-1;					
							td.children('span').text(currencylabel+roundToKM(amts[u]));
							amts[u] = 0;
						}else if(k===1){
							that.eq(k).children().children('span').text(roundToKM(f));
							f = 0;
						}else{
							that.eq(k).children().children('span').text(currencylabel+roundToKM(ta));
							ta = 0;
						}
					}
				}
			}
		}
		mod = ta = td = null;		
	}else{//edit mode
		var mapPtIdx={},mapPart2Ids = map_PartIds,isAppBu = isAppOrIndBu;
		isAppBu = (''+isAppBu).toLowerCase() == 'true'? true:false;
		var map_BuIdx,buInfo,hasMap = false,markCount = 0;
		if(isAppBu && mapPart2Ids){
			for(var f in mapPart2Ids){
				mapPtIdx[f] = recycle*(1+mapPart2Ids[f]);
			}
			map_BuIdx = transPartDataMap(mapPtIdx),hasMap = !!map_BuIdx;
		}
		var range4 = range4Mark;
		var mod;
		if(isBOM=="BOM"){//compute based on oppy inputs
			$('#partTable').children('tbody').children().each(function(idx){
				if(idx>2&&idx%recycle==1){
					$el = $(this).find('input');
					temp9=fmtNum($el.val(),0,true);
					partArray.push(temp9);
					$el.val(showFormat(temp9));
				}
			});
			hasLargeNum=false;			
			for(f=0,g=$tables.length;f<g;f++){
				that = $tables[f];
				temp9 = ''+that.attr('id'),
				saveStrs[f] = {year:temp9,data:[]},
				temp9 = temp9.substr(0,4);
				if(hasMap){
					if(!map_BuIdx[temp9])
					map_BuIdx[temp9] = {};
					buInfo = map_BuIdx[temp9];
				}
				saveStrs[f].data.push([temp9,forecastLevel,isBOM].join(';'));
				if(hasLargeNum===false){
					tableArray=[],
					elemArray = [];
					that.children('tbody').children().each(function(idx){//push input values to tableArray
						$el = $(this).children('td');//elemArray only contains td, th not included,so **be careful** of this when count the rows
						if($el.length>0){
							elemArray.push($el);
							if(idx>recycle){
								if(idx%recycle ===2){
									temp9=$el.children('input').val();
									if(!temp9){
										temp9 = 0;				
									}else{
										temp9=fmtNum(temp9,0,false,true);
									}
								}else{
									temp9=0;
								}
							}else{
								if(idx>1&&idx<recycle){
									temp9=$el.children('input').val();
									if(!temp9){
										temp9 = 0;				
									}else{
										temp9=fmtNum(temp9,0,true);
									}
								}else{
									temp9=0;
								}
							}
							tableArray.push(temp9);	
						}
					});
					amountArray=new Array(tableArray.length); //amountArray hold amounts of the current table of every td
					for(i=0,k = amountArray.length; i<k; i++){
						amountArray[i]=0;
					}
					var temp5=0; //temp5 is the total amount of Q1,Q2,...(if monthly, Q1,Q2 will be replaced with January,Febuary,...,same below)
					var temp4,tmp;
					for(i=0,k = partArray.length; i<k; i++){		
						temp4=0;//temp4 hold temporary subtotal of Q1,Q2,...of every part		
						for(j=2;j<recycle;j++){
							tmp = partArray[i]*tableArray[j];
							tableArray[recycle*(i+1)+j]= tmp;
							temp4+=tmp;				//here is subtotal, if Lost/Dead,let it be.
						}
						tableArray[recycle*(i+1)]=temp4; 		
					}
					var temp6=0;//temp6 hold the current price
					for(i=recycle+1,k=tableArray.length; i<k; i++){		
						if(i%recycle==1){
								temp6=tableArray[i];				
						}else{ 
							amountArray[i]=temp6*tableArray[i];
						}			
					}
					for(i=2;i<recycle;i++){
						temp5+=tableArray[i];
					}
					tableArray[1]=temp5;
					var temp7=0;//temp7 hold the total amount of td at first td
					var isLost=false,modN=(amountArray.length-1)%recycle,temp8,stlAry=0;
					for(i=amountArray.length-1;i>=0;i--){			
						temp8=i%recycle;			
						if(i>=recycle){	
							if(temp8>1){
								if(confidences && temp8===modN){
									for(j=confidences.length-1;j>-1;j--){
										if(i>=confidences[j]&&i<=confidences[j]+recycle){
											isLost=true;
											j=-2;//break loop
										}else{
											isLost=false;
										}
									}
								}	
								if(!isLost){		
									amountArray[temp8]+=amountArray[i];//need check if Lost/Dead
									stlAry += amountArray[i];
								}
							}else if(temp8==0 && hasMap){
								//if(!buInfo){}
								if(!buInfo[i]){buInfo[i]={};}
								
								if(typeof buInfo[i]['oldValue'] == 'undefined'){
									buInfo[i]['oldValue']=stlAry;
								}
								//if(stlAry != buInfo[i]['oldValue']){
								if((!isLost) && Math.abs(stlAry - buInfo[i]['oldValue'])/buInfo[i]['oldValue'] >= range4){
									markMc(elemArray[i]);//.find('span'));
									markCount ++;
								}else{
									unmarkMc(elemArray[i]);//.find('span'));
								}
								buInfo[i]['newValue'] = stlAry;
								
								stlAry = 0;
							}
						}else if(i>1&&i<recycle){//accumulate the amount
							temp7+=amountArray[i]; //need not check if Lost/Dead
						}
					}
					amountArray[0]=temp7;
					if(hasLargeNumber(tableArray)){//if large number appear,mark the flag and then can stop
						hasLargeNum=true;		
					}else{//otherwise show the results and make up the saveStrs for save
						var va,vc,tmp;
						for(i=0,k=elemArray.length;i<k;i++){
							tmp = i%recycle;
							if(i>recycle && tmp ===1){
								va=tableArray[i];
							}else{
								va=Math.round(tableArray[i]*100)/100;
							}
							vc=Math.round(amountArray[i]*100)/100;							
							if(i > 1){
								//tmp = i%recycle;
								if(tmp>1){
									saveStrs[f].data.push([va,vc,temp9].join(';'));
								}else if(tmp === 1){
									temp9 = va;
								}
								va = showFormat(va,locale);
								if(i<recycle){
									vc = currencylabel+roundToKM(vc,0);
									elemArray[i].find('input[type="text"]').val(va);
									elemArray[i].find('span').text(vc);
								}else{
									elemArray[i].find('input[type="text"]').val(va);
									elemArray[i].find('span').text(va);
								}
							}else if(i === 0){
								vc=roundToKM(vc,locale);
								elemArray[i].find('span').text(currencylabel+vc);
							}else if(i === 1){
								elemArray[i].find('span').text(roundToKM(va,locale));
								temp9 = 0;
							}							
						}
					}
				}else{
					break;
				}
			}
			partArray = $tables = elemArray = tableArray = null;
			if(hasLargeNum){
				saveStrs = null;
				alert("Calculation stop because of too large numbers or results,please check.");
				if(inputEl){
					$(inputEl).val('').focus();
				}
			}
		}else{//Manual, compute based on part inputs
			var isProgram = isProgramPage;
			hasLargeNum=false;		
			for(f=0,g=$tables.length;f<g;f++){
				that = $tables[f];
				temp9 = ''+that.attr('id'),
				saveStrs[f] = {year:temp9,data:[]},
				temp9 = temp9.substr(0,4);
				if(hasMap && !isProgram){
					if(!map_BuIdx[temp9])
					map_BuIdx[temp9] = {};
					buInfo = map_BuIdx[temp9];
				}
				saveStrs[f].data.push([temp9,forecastLevel,isBOM].join(';'));
				if(hasLargeNum===false){
					tableArray=[],
					elemArray = [];
					that.children('tbody').children().each(function(idx){//push part input values to tableArray
						$el = $(this).children('td');//elemArray only contains td, th not included,so **be careful** of this when count the rows
						if($el.length>0){							
							elemArray.push($el);
							if(idx>recycle){
								mod = idx%recycle;
								if(mod!==1){
									temp9=$el.children('input').val();
									if(!temp9){
										temp9 = 0;				
									}else{
										temp9=fmtNum(temp9,0,mod!==2,mod===2);
									}
								}else{
									temp9 = 0;
								}
							}else{
								temp9 = 0;
							}							
							tableArray.push(temp9);
						}
					});
					amountArray=new Array(tableArray.length);//amountArray hold the amounts
					for(i=0,k=tableArray.length; i<k; i++){
						amountArray[i]=0;
					}		
					var tprice=0,//tprice hold current price
						subqty=0,subamt=0,flag=0, 
						isLost=false,modN=(tableArray.length-1)%recycle,mod,stlAry=0;
					for(i=tableArray.length-1;i>=recycle;i--){
						mod=i%recycle;
						if(mod==(recycle-1)&&i>=recycle){
							tprice=tableArray[i-(recycle-2)];
						}
						if(i>recycle && mod>1 && mod<=(recycle-1)){
							amountArray[i]=tableArray[i]*tprice;  
							if(confidences && i%recycle===modN){
								for(j=confidences.length-1;j>-1;j--){
									if(i>=confidences[j]&&i<=confidences[j]+recycle){
										isLost=true;
										j=-2;//break loop
									}else{
										isLost=false;
									}
								}
							}
							if(!isLost){
								amountArray[mod]+=amountArray[i];  //need check Lost/Dead
								tableArray[mod]+=tableArray[i];	 //need check Lost/Dead
								stlAry += amountArray[i];
							}
							subqty+=parseFloat(tableArray[i]); 
							subamt+=amountArray[i];
						}
						if(mod==0){
							tableArray[i]=subqty; 
							amountArray[i]=subamt;
							if(hasMap && !isProgram){
								if(!buInfo[i])buInfo[i] = {};
								if(typeof buInfo[i]['oldValue'] == 'undefined')buInfo[i]['oldValue']=stlAry; //shall consider Lost/Dead ?
								
								//if(subamt != buInfo[i]['oldValue']){
								if((!isLost) && Math.abs(stlAry - buInfo[i]['oldValue'])/buInfo[i]['oldValue'] >= range4){
									markMc(elemArray[i]);//.find('span'));
									markCount ++;
								}else{
									unmarkMc(elemArray[i]);//.find('span'));
								}
								buInfo[i]['newValue'] = stlAry;
							}
							subqty=subamt=stlAry=0;
						}				
					}
					for(i=2;i<recycle;i++){
						amountArray[0]+=amountArray[i];
						tableArray[1]+=tableArray[i];
					} 
					if(hasLargeNumber(tableArray)){
						hasLargeNum=true;
					}else{//show the results and make up the saveStrs for save
						var va,tmp,vc;	
						for(i=0,k=elemArray.length;i<k;i++){
							va = tableArray[i];
							tmp = i%recycle;
							if(i<=recycle || tmp!==1){
								va=Math.round(va*100)/100;
							}							
							vc=amountArray[i];
							vc=Math.round(vc*100)/100;
							if(i >= recycle){
								//tmp = i%recycle;
								if(tmp > 1){
									saveStrs[f].data.push([va,vc,temp9].join(';'));
								}else if(tmp === 1){
									temp9 = va;
								}
								va = showFormat(va,0);
								elemArray[i].find('input[type="text"]').val(va);
								elemArray[i].find('span').text(va);
							}else if(i > 1){
								if(i%recycle > 1){
									saveStrs[f].data.push([va,vc,0].join(';'));
								}
								vc = currencylabel+roundToKM(vc,0);
								va = showFormat(va);
								elemArray[i].find('input[type="text"]').val(va);
								elemArray[i].find('span').text(vc);
							}else if(i === 0){
								vc=roundToKM(vc,0);
								elemArray[i].find('span').text(currencylabel+vc);
							}else if(i === 1){
								elemArray[i].find('span').text(roundToKM(va,0));
							}
						}				
					}
				}else{
					break;
				}
			}
			partArray = $tables = elemArray = tableArray = null;
			if(hasLargeNum){
				saveStrs = null;
				alert("Calculation stop because of too large numbers or results,please check.");
				if(inputEl){
					$(inputEl).val('').focus();
				}
			}else{
				if(hasMap)	
				transData2PartMap(map_BuIdx,recycle);
			}
		}
		if(markCount > 0){
			isBUEdited = true;
		}else{
			isBUEdited = false;
		}
		if(saveStrs){	//make up gSaveStrs(global variable) value with saveStrs;
			if(!gSaveStrs){
				gSaveStrs = saveStrs;
			}else{
				for(f=0,g=saveStrs.length; f<g; f++){
					temp9 = saveStrs[f].year;
					j = false;
					for(i=0,k=gSaveStrs.length; i<k; i++){
						if(temp9 === gSaveStrs[i].year){
							gSaveStrs[i].data = saveStrs[f].data;
							j = true;
						}
					}
					if(!j){
						gSaveStrs.push(saveStrs[f]);
					}
				}
			}
		}	
	}
	saveStrs = temp9 = i = k = f = g = j = null;
}
/*** move focus to next logical input ***/
function setNextFocus(el,srecycle){
	//temp is the number hom many td before current td, and in this way we know where td is in the table.		
	var	temp = $(getParent(el,'TR')).prevAll().length;
	var $focusEl,t;		
	if(temp<=srecycle && temp==srecycle-1){ //here we come to end of Q1,Q2,...(or months,or year) and need let focus to next Q1...		
		// if we're at the end of the top section then begin to focus on the price input
		t = $(getParent(el,'TD','TABLE')).next();//t is next year table
		if(t.length>0){	
			$focusEl=t.find('td').eq(2).find('input[type="text"]');							
		}else{//no next year,then go next part of 1st year table
			$focusEl=$(getParent(el.parentNode,'TR','TABLE')).children().eq(0).find('td').eq(temp+2).find('input[type="text"]');
		}
	}else if(temp>srecycle&&temp%srecycle==2){//this line is the price, need to let focus to next price.
		t = $(getParent(el,'TD','TABLE')).next();
		if(t.length>0){	//if next year table exist,find the price in it				
			$focusEl=t.find('td').eq(temp-1).find('input[type="text"]');
		}else{
			t = $(getParent(el,'TR','TABLE')).children().eq(0).find('td');
			if(t.eq(temp).find('input[type="text"]').is(':hidden')){
				$focusEl=t.eq(temp+srecycle-1).find('input[type="text"]');
			}else{
				$focusEl=t.eq(temp).find('input[type="text"]');
			}
		}
	}else if(temp%srecycle<srecycle&&temp%srecycle>1){						
		$focusEl=$(el.parentNode.parentNode).next().find('td input[type="text"]').focus();				
	}else if(temp>srecycle&&temp%srecycle==0){// end of part
		t = $(getParent(el,'TD','TABLE')).next();
		if(t.length>0){
			$focusEl=t.find('td').eq(temp+2-srecycle).find('input[type="text"]');
		}else{
			t = $(getParent(el,'TR','TABLE')).children().eq(0).find('td').eq(temp+1).find('input[type="text"]');
			if(t.length>0){
				$focusEl=t;
			}else{
				t = $(getParent(el,'TR','TABLE')).children().eq(0).find('td').eq(temp+2).find('input[type="text"]');
				if(t.length>0){			
					$focusEl=t;
				}
			}
		}
	}
	t = null;
	if($focusEl&&$focusEl.length>0){
		setSelect($focusEl);
	}else{
		setSelect($(el).blur());
	}
}
/*** return el's parents named with p ***/
function getParent(el,p,s){// if s provided, first get el's parent named with s, then find parent named with p based on s
	if(s){
		do{
			el = el.parentNode;
		}while(el && el.nodeName != s)
	}
	do{
		el = el.parentNode;
	}while(el && el.nodeName != p)
	return el;
}
/*** return el's previous logical input ***/
function setPrevFocus(el,srecycle){
	var temp=$(el.parentNode.parentNode).prevAll().length; //temp is the number hom many td before current td, and in this way we know where td is in the table.		
	var $focusEl,t;	
		if(temp==2){ //here we are at beginning of Q1,Q2,...(or months,or year) and need let focus to prvious Q1...		
			// if we're at the end of the top section then begin to focus on the price input
			t = $(getParent(el,'TD','TABLE')).prev();
			if(t.length>0){
				$focusEl=t.find('td').eq(srecycle-1).find('input[type="text"]');							
			}//else stop
		}else if(temp>srecycle&&temp%srecycle==2){//this line is the price, need to let focus to next price.
			t = $(getParent(el,'TD','TABLE')).prev();
			if(t.length>0){	//if next year table exist,find the price in it				
				$focusEl=t.find('td').eq(temp-1).find('input[type="text"]');
			}else{
				t = $(getParent(el,'TR','TABLE')).children().last().find('td');
				if(t.eq(temp-3).find('input[type="text"]').is(':hidden')){
					$focusEl=t.eq(temp-srecycle-1).find('input[type="text"]');
				}else{
					$focusEl=t.eq(temp-3).find('input[type="text"]');
				}				
			}			
		}else if((temp%srecycle<srecycle&&temp%srecycle>3)||(temp%srecycle==0&&srecycle>3)||(temp<srecycle&&temp%srecycle==3)){	//go to its upper cell						
			$focusEl=$(el.parentNode.parentNode).prev().find('td input[type="text"]');				
		}else if((temp>srecycle&&temp%srecycle==3)||(temp<srecycle&&temp%srecycle==2)||(srecycle==3&&temp%srecycle==0)){
			t = $(getParent(el,'TD','TABLE')).prev();
			if(t.length>0){
				$focusEl=t.find('td').eq(temp+srecycle-4).find('input[type="text"]');
			}else{
				t = $(getParent(el,'TR','TABLE')).children().last().find('td').eq(temp-2).find('input[type="text"]')
				if(t.length>0){
					$focusEl=t;
				}else {
					t = $(getParent(el,'TR','TABLE')).children().last().find('td').eq(temp-3).find('input[type="text"]');
					if(t.length>0){			
						$focusEl=t;
					}
				}
			}
		}
	t = null;
	$(el).blur();
	if($focusEl&&$focusEl.length>0){
		setSelect($focusEl);
	}else{
		setSelect($(el));
	}
}
/*** set picklist value because they are not set well by apex ***/
function spv(){
	$('#oppLevel').children().each(function(){
		if(forecastLevel == this.value){
			$(this).attr('selected','selected');
			return false;
		}
	});
	$('#oppMethod').children().each(function(){
		if(isBOM == this.value){
			$(this).attr('selected','selected');
			return false;
		}
	});
}
function initMaps(){
	setupBuMap();
	setUpPartIdMap();
}
/*** do needed work on every time page rendering ***/
// modified by min
function prepare(locale,isView){//return;
	spv();	
	if(!isView){
		initMaps();
		initialFormat();
		initReasonSel();
	}
	findConfidences(isView);
	tp(false,false,false,isView);
	var $td;//it holds the current input as a jquery object
	$('#yearsTableTr').find('input[type="text"]').live('keydown',function(event){ // tab/enter key logic for year tables
		if(event.shiftKey&&event.keyCode==9||event.keyCode==9||event.keyCode==13){	
			var srecycle=getRecycle();
			if(event.shiftKey&&event.keyCode==9){
				setPrevFocus(this,srecycle);
				return false;
			}else if(event.keyCode==9||event.keyCode==13){						
				setNextFocus(this,srecycle);
				return false;
			}			
		}
	});
	//$('#partTable').find('input.keypressInputQty').live('keypress',function(e){// tab/enter key logic for part table
	$('#partTable').find('input.partRate').live('keypress',function(e){// tab/enter key logic for part table
		if(e.shiftKey&&e.keyCode==9){
			var prevInputFocus=$(this).parent().parent().prev();
			while(prevInputFocus&&prevInputFocus.length>0&&prevInputFocus.find('input[type!="hidden"]').length===0){
				prevInputFocus=prevInputFocus.prev();
			}
			if(prevInputFocus.find('input[type!="hidden"]').length>0)
				setSelect(prevInputFocus.find('input[type!="hidden"]'));
			else
				$(this).blur();			
			return false;
		}else if(e.keyCode===9||e.keyCode===13){
			var nextInputFocus=$(this).parent().parent().next();
			while(nextInputFocus&&nextInputFocus.length>0&&nextInputFocus.find('input[type!="hidden"]').length===0){
				nextInputFocus=nextInputFocus.next();
			}
			if(nextInputFocus.find('input[type!="hidden"]').length>0)			
				setSelect(nextInputFocus.find('input[type!="hidden"]'));
			else
				$(this).blur();				
			return false;
		}
	});	
	setProperWidth();
	$(window).resize(function(){
		setProperWidth();
	});
	
	// to find the left table header tr and make it show line. --begin
	$('#tr_leftTable').prev().removeClass('noBorderTr');	
	setTimeout(function(){
		var imgBtn=$('#opportunityBtn');
		if(imgBtn.attr('title')==='Show'){		
			imgBtn.parent().parent().removeClass('noBorderTr');
		}else{		
			imgBtn.parent().parent().addClass('noBorderTr');
		}	
		imgBtn=undefined;
	},200);	
	// to find the left table header tr and make it show line. --end	
	var adm = isUserAdmin();
	optionBackup = {
		c1:[],
		c2:[],
		s1:[],
		s2:[],
		c:false,
		s:false,
		cStr:'',
		sStr:''
	};
	var confidence1 = Gconfidence1,
		confidence2 = Gconfidence2,
		status1 = Gstatus1,
		status2 = Gstatus2,
		statusFinal = GstatusFinal,
		optStr = '';

	// 2014-06-09 Michael Cui: added for case 00677873	
	if(isAppliance())
	{
		status1 = Gstatus3;
		status2 = Gstatus4;
	}

        // Updated Raul 2016.04.18 Begin
        if(isDND())
        {
                status1 = Gstatus5;
                status2 = Gstatus6;
        }
        // Updated Raul 2016.04.18 End


	confidences=[];
	$('#left_Tbody').find('select').each(function(){//process left table selects
		var $this = $(this),nextSel;
		oldStatusVal[$this.attr('id')] = $this.val();
		if($this.hasClass('selectConfidence')){ //status selects
			var stageName = $.trim($this.parent().next().find('.stageName').val()).toLowerCase();
			$(this).children().each(function(){
				// phase is new and user is non-admin, won will NOT be displayed
				if($.trim(this.value) === '' || (stageName == 'new' && !adm && itemInArray(this.value, confidence2)) ){
					$(this).remove();
				}
			});
			
			nextSel = $this.parent().next().find('select');
			if('Lost' === this.value || 'Dead' === this.value){
				confidences.push($this.parent().parent().prevAll().length);
			}
			
			// phase is new, process status is not available for non-admin users
			if(stageName == 'new'){				
				if(!adm) {
					$this.parent().next().find('select').attr('disabled',true);
				}
			}
						
			if(!itemInArray(this.value,confidence1) && !itemInArray(this.value,confidence2)) {} //do nothing
			else{				
				if(itemInArray(this.value,confidence1)){
					nextSel.children().each(function(){
						if(!itemInArray(this.value, status1) && itemInArray(this.value, status2)){
							$(this).remove();
						}
					});
				}
				// Won
				else if(itemInArray(this.value, confidence2)){
					if(!adm){
						// remove all confidence1
						$(this).children().each(function(){
							if(itemInArray(this.value, confidence1)){
								$(this).remove();
							}
						});
						// if select production or later status
						var nextSelValue = '';
						nextSel.children().each(function(){
							if($(this).attr('selected') == 'selected') nextSelValue = this.value;
							if(itemInArray(this.value, status1)){
								$(this).remove();
							}
						});
						if(itemInArray($.trim(nextSelValue), statusFinal)){
							nextSel.children().each(function(){
								if(itemInArray(this.value, status1) || $.trim(this.value) === 'Pre-prod'){
									$(this).remove();
								}
							});
						}
					}
				}
			}
		}
		
	});
}


/*** do needed work on every time page rendering ***/
function prepare_backup(locale,isView){
	spv();	
	if(!isView){
		initialFormat();
	}
	findConfidences(isView);
	tp(false,false,false,isView);	
	var $td;//it holds the current input as a jquery object
	$('#yearsTableTr').find('input[type="text"]').live('keydown',function(event){ // tab/enter key logic for year tables
		if(event.shiftKey&&event.keyCode==9||event.keyCode==9||event.keyCode==13){	
			var srecycle=getRecycle();
			if(event.shiftKey&&event.keyCode==9){
				setPrevFocus(this,srecycle);
				return false;
			}else if(event.keyCode==9||event.keyCode==13){						
				setNextFocus(this,srecycle);
				return false;
			}			
		}
	});
	//$('#partTable').find('input.keypressInputQty').live('keypress',function(e){// tab/enter key logic for part table
	$('#partTable').find('input.partRate').live('keypress',function(e){// tab/enter key logic for part table
		if(event.shiftKey&&event.keyCode==9){
			var prevInputFocus=$(this).parent().parent().prev();
			while(prevInputFocus&&prevInputFocus.length>0&&prevInputFocus.find('input[type!="hidden"]').length===0){
				prevInputFocus=prevInputFocus.prev();
			}
			if(prevInputFocus.find('input[type!="hidden"]').length>0)
				setSelect(prevInputFocus.find('input[type!="hidden"]'));
			else
				$(this).blur();			
			return false;
		}else if(e.keyCode===9||e.keyCode===13){
			var nextInputFocus=$(this).parent().parent().next();
			while(nextInputFocus&&nextInputFocus.length>0&&nextInputFocus.find('input[type!="hidden"]').length===0){
				nextInputFocus=nextInputFocus.next();
			}
			if(nextInputFocus.find('input[type!="hidden"]').length>0)			
				setSelect(nextInputFocus.find('input[type!="hidden"]'));
			else
				$(this).blur();				
			return false;
		}
	});	
	setProperWidth();
	$(window).resize(function(){
		setProperWidth();
	});
	
	// to find the left table header tr and make it show line. --begin
	$('#tr_leftTable').prev().removeClass('noBorderTr');	
	setTimeout(function(){
		var imgBtn=$('#opportunityBtn');
		if(imgBtn.attr('title')==='Show'){		
			imgBtn.parent().parent().removeClass('noBorderTr');
		}else{		
			imgBtn.parent().parent().addClass('noBorderTr');
		}	
		imgBtn=undefined;
	},200);	
	// to find the left table header tr and make it show line. --end	
	var adm = isUserAdmin();
	optionBackup = {
		c1:[],
		c2:[],
		s1:[],
		s2:[],
		c:false,
		s:false,
		cStr:'',
		sStr:''
	};
	var confidence1 = ['On Hold','Weak','50/50','Likely','Commit','Dead','Lost','TAM'],
		confidence2 = ['Won'],
		status1 = ['Concept','Demo','Designed','Prototyped/Sampled','Quoted'],
		status2 = ['Pre-prod','Production','Ramp-down','EOL'],
		optStr = '';
	confidences=[];
	$('#left_Tbody').find('select').each(function(){//process left table selects
		var $this = $(this),nextSel;
					
		if(!$this.hasClass('selectConfidence')){ //status selects
			if(!optionBackup.s){ // optionBackup.status haven't been done
				$this.children().each(function(){
					if(this.value && itemInArray(this.value,status1)){
						optionBackup.s1.push(this.value);
					}else if(this.value && itemInArray(this.value,status2)){
						optionBackup.s2.push(this.value);
					}
				});				
				optionBackup.s = true;
			}
			//if(adm){
				if(!itemInArray($this.val(),status1) && !itemInArray($this.val(),status2)) {}// do nothing
				else{
					if(itemInArray($this.val(),status1)){
						$this.children().each(function(){
							if(itemInArray(this.value,status2)){
								$(this).remove();
							}
						});				
					}else if(itemInArray($this.val(),status2)){
						$this.children().each(function(){
							if(itemInArray(this.value,status1)){
								$(this).remove();
							}
						});
					}
				}				
			//}
			if($.trim(this.value) === 'Concept'){
				if($.trim($this.siblings().filter('.stageName').val()).toLowerCase() === 'new'){					
					//$this.parent().prev().find('select').attr('disabled',true);
					if(!adm) {
						$this.attr('disabled',true);
						$this.parent().prev().find('select').find('option[value="Won"]').remove();
					}
				}
			}
		}else { // confidence selects
			if('Lost' === this.value || 'Dead' === this.value){
				confidences.push($this.parent().parent().prevAll().length);
			}
			if(!optionBackup.c){ // optionBackup.confidence haven't been done
				$this.children().each(function(){
					if(this.value && itemInArray(this.value,confidence1)){
						optionBackup.c1.push(this.value);
					}else if(this.value && itemInArray(this.value,confidence2)){
						optionBackup.c2.push(this.value);
					}
				});
				optionBackup.c = true;
			}
			nextSel = $this.parent().next().find('select');
			if(!optionBackup.s){ // optionBackup.status haven't been done
				nextSel.children().each(function(){
					if(this.value && itemInArray(this.value,status1)){
						optionBackup.s1.push(this.value);
					}else if(this.value && itemInArray(this.value,status2)){
						optionBackup.s2.push(this.value);
					}
				});				
				optionBackup.s = true;
			}
			
			if($.trim(this.value) === 'Won' && !adm){
				$(this).empty().append('<option value="Won" selected="selected">Won</option>');	
				optStr = '';
				for(var k=0,j=optionBackup.s2.length; k<j; k++){
					optStr += '<option value="' + optionBackup.s2[k] + '"';
					if( $.trim(nextSel.val()) == optionBackup.s2[k] ){
						optStr += 'selected="selected"';
					}
					optStr += '>' + optionBackup.s2[k] + '</option>';
				}
				nextSel.empty().append(optStr);	
			}
		}
		
		if('new' === $.trim($this.siblings().filter('.stageName').val()).toLowerCase()){
			//$this.parent().prev().find('select').find('option[value="Dead"]').remove();
		}
	});
}

/*** process number format on page rendering ***/
function initialFormat(){
	if(locale === 'de'){
		var $td,$span,$input,tmp;
		$('#partTable').children('tbody').children().each(function(i){
			$td = $(this).children();
			$span = $td.children('span');
			if($span.length > 0){
				tmp = $span.text();
				if(/^\d+\.\d+$/.test(tmp))
				tmp = tmp.replace('.',',');
				$span.text(tmp);
			}
			//in part table, it is apex:input, need not set format
			/*
			$input = $td.children('input');
			if($input.length > 0){
				tmp = $input.val().replace('.',',');
				$input.val(tmp);
			}
			*/
		});
		$('#yearsTableTr').children().each(function(){
			$(this).children('table').children('tbody').children().each(function(i){
				$td = $(this).children();
				$span = $td.children('span');
				if($span.length > 0){
					tmp = $span.text();
					if(/^\d+\.\d+$/.test(tmp))
					tmp = tmp.replace('.',',');
					$span.text(tmp);
				}
				$input = $td.children('input');
				if($input.length > 0){
					tmp = $input.val();
					if(/^\d+\.\d+$/.test(tmp))
					tmp = tmp.replace('.',',');
					$input.val(tmp);
				}
			});
		});
		$td = $span = $input = tmp = undefined;
	}
}

/*** number to string, round to KM ***/
function roundToKM(txt,a){//ok
	if(txt<100000){
			txt=Math.round(txt*100)/100;
			txt=showFormat(txt,a);
	}
	else if(txt<1000000){
			txt=Math.round(txt/10)/100;
			txt=showFormat(txt,a);
			txt+='K';
	}
	else if(txt<1000000000){
			txt=Math.round(txt/10000)/100;
			txt=showFormat(txt,a);
			txt+='M';				
	}else if(txt<1000000000000){
			txt=Math.round(txt/10000000)/100;
			txt=showFormat(txt,a);
			txt+='B';
	}else if(txt<1000000000000000){
			txt=Math.round(txt/10000000000)/100;
			txt=showFormat(txt,a);
			txt+='T';
	}else{
		txt='?';
	}
	return txt;
}
/*** on price input changed,check and compute ***/
function ptp(el,year){//priceTableCompute ok	
	if(/[M,m,B,b,T,t]$/.test(el.value)){
		alert('Price ending with M/B/T is not accepted.');
		el.value = '';
		return false;
	}else{
		tp(el,year);
	}
}
/*** assist to setSelect($el) ***/
function setSelectionRange(input, selectionStart, selectionEnd) {//ok
	  if (input.setSelectionRange) {
	    input.focus();
	    input.setSelectionRange(selectionStart, selectionEnd);
	  }
	  else if (input.createTextRange) {
	    var range = input.createTextRange();
	    range.collapse(true);
	    range.moveEnd('character', selectionEnd);
	    range.moveStart('character', selectionStart);		        
	    range.select();		        
	  }
}
/*** make input content selected ***/
function setSelect($el){//ok
	var contentLength;
	if(!$el||!($el.val()||$el.val()=='')){
		return false;
	}	
	if($el.val()==''){
		$el.val(0);
	}
	contentLength=$el.val().length;
	var el=$el.get(0);
	setSelectionRange(el,0,contentLength);	
}
/***set proper width according to user's browser***/
function setProperWidth(){//ok
	var wW=$('body').width(); 
	var wH=$(window).height();
	if(wH<600){
		$('#inlineTable').parent().height(wH-80);
	}
	if(wW>500){		
		var extraWidth=Math.floor((wW-970)/100)*100; 
		var leftWidth=0,updatedOuterWidth=0,updatedInnerWidth=0;
		var leftColumnNum=$('#leftTableHeadTr').children().length;
		if(leftColumnNum===3){
			leftWidth=265;
		}else if(leftColumnNum===4){
			leftWidth=365;
		}else if(leftColumnNum===5){
			leftWidth=515;
		}else if(leftColumnNum===6){
			leftWidth=610;
		}
		//updatedOuterWidth=975+extraWidth;//-- 2012-08-31 by Fuqi revised since page column are added
		updatedOuterWidth=996+extraWidth;
		//updatedInnerWidth=990+extraWidth-leftWidth-80;	//945
		if(leftColumnNum===5){
			updatedInnerWidth=895+extraWidth-leftWidth-80;	
		}else if(leftColumnNum===6){
			updatedInnerWidth=890+extraWidth-leftWidth-80;
		}
		if(updatedOuterWidth>500){
			$('#inlineTable').parent().width(updatedOuterWidth);	
			$('#innerWidthToSet').width(updatedInnerWidth);		
		}		
	}	
}
/***check if array has large number***/
function hasLargeNumber(ary){//ok
	if(!ary) return false;
	for(var i=0,j=ary.length;i<j;i++){
		if(ary[i]>9999999999){
			return true;
		}
	}
	return false;
}
/***move forecast***/
function pdc(el){
	var $el=$(el),
		thisDay = DateUtil.getDateFromFormat($el.val(),UserContext.dateFormat),
		today = new Date(),
		todayYear = today.getFullYear(),
		todayMonth = today.getMonth();
		today = new Date(todayYear,todayMonth,today.getDate()); // make it today's 00:00 time value
	if(today > thisDay){
		alert(getMsgInvalidStartDate());
		$el.val('').focus();
	}else{
		//check if move period valid --begin
		var d = new Date(thisDay),
			y = d.getFullYear(),
			m = d.getMonth(),
			movePeriod = getMovePeroid(y,m),
			options = $('#addYearBtn').prev().children(),
			flag = false,
			optionYears = [],allYears=[];
		options.each(function(){
			if(!isNaN(parseInt(this.value,10))){//check if target move year in select options
				if(parseInt(this.value,10) == parseInt(movePeriod.posYear,10)){
					flag = true;
				}
				optionYears.push(parseInt(this.value,10));
				allYears.push(parseInt(this.value,10));
			}
		});
		if(!flag){
			$('#yearsTableTr').children().each(function(i){//check if target move year in year tables
				temp = (''+$(this).children('table').attr('id')).substr(0,4);
				if(parseInt(movePeriod.posYear,10) === parseInt(temp,10)){
					flag = true;
				}
			});
			if(!flag){
				alert(getMsgInvalidYear());
				$el.val('').focus();
				return false;
			}
		}
		//check if move period valid --end
		if(!confirm(movePeriod.str)){
			$el.val('').focus();
			return false;
		}else{//begin move
			var mapData = map_partData;
			var baseData=[],i,j,k,recycle = getRecycle(),startIdx={col:-1,row:-1},map_idx_year={},temp,f;
			var tableYears = [];
			$('#yearsTableTr').children().each(function(i){//collect data into baseData
				temp = $(this).children('table');
				var tyear = (''+temp.attr('id')).substr(0,4);
				map_idx_year[i]=tyear;
				allYears.push(parseInt(tyear,10));
				if(tyear < y) tableYears.push(tyear);
				baseData.push(getTableData(temp,recycle));
			});
			if(baseData.length===0){//check whether data available
				return false;
			}
			/////
			for(i=0,j=tableYears.length;i<j;i++){
				resetYearBuInfo(tableYears[i],true);
			}
			/////
			for(i=0,j=baseData.length;i<j;i++){//find first position which has not-0 numbers
				for(k=2;k<recycle;k++){
					if(fmtNum( baseData[i][k],locale) !=0 ){
						startIdx.col = i;
						startIdx.row = k;
						break;
					}
				}
				if(startIdx.col >= 0){
					break;
				}
			}
			var moveY = movePeriod.position - (startIdx.row - 2);//if moveY < 0, it means move up some steps, otherwise move down
			if(moveY === 0){//need not move up or down, if year,also this way
			}else{
				if(moveY > 0){//move down
					baseData.push(new Array(baseData[0].length));
					for(i=baseData.length - 2;i>=startIdx.col;i--){
					//optionYears.splice(0, 1);
						for(j=baseData[i].length-1;j>=0;j--){
							k = j%recycle;
							if(j>recycle){
								if(k == 0 || k>(recycle-moveY)){ //move to next
									baseData[i+1][j-(recycle - 2 -moveY)] = baseData[i][j];									
									baseData[i][j]=0;									
								}else if(k>2){//move in this column
									baseData[i][j+moveY] = baseData[i][j];
									baseData[i][j]=0;
								}
							}else if(j<recycle){
								if(k >(recycle-moveY-1)){
									baseData[i+1][j-(recycle - 2 -moveY)] = baseData[i][j];
									baseData[i][j]=0;
								}else if(k >=2){
									baseData[i][j+moveY] = baseData[i][j];
									baseData[i][j]=0;
								}
							}
						}
					}
				}else{//move up
					j=baseData.length;
					for(i=startIdx.col,j=baseData.length;i<j;i++){
						//optionYears.splice(0, 0, parseInt(optionYears[0]) - 1);
						for(f=0,temp=baseData[i].length;f<temp;f++){
							k = f%recycle;
							if(f>recycle){
								if(k >2 && k<= 2-moveY){//move to prev //moveY<0
									if(i >startIdx.col){//in the first column,no data need to move to prev
										baseData[i-1][f+recycle+moveY-2] = baseData[i][f];//moveY<0
										baseData[i][f] = 0; // clear itself
									}
								}else if(k>2-moveY||k===0){//move in this column //moveY<0
									baseData[i][f+moveY] = baseData[i][f];//moveY<0
									baseData[i][f] = 0; // clear itself
								}
							}else if(f<recycle){
								if(f >1 && f <= 1-moveY){//moveY<0
									if(i >startIdx.col){//in the first column,no data need to move to prev
										baseData[i-1][f+recycle+moveY-2] = baseData[i][f];//moveY<0
										baseData[i][f] = 0; // clear itself
									}
								}else if(f > 1-moveY){//moveY<0
									baseData[i][f+moveY] = baseData[i][f];
									baseData[i][f] = 0; // clear itself
								}
							}
						}
					}
				}
			}
			flag = false;
			for(i=baseData.length-1;i>=0;i--){//remove the all-0 column from baseData end
				for(j=0,k=baseData[i].length;j<k;j++){
					f = parseFloat(baseData[i][j]);
					if(!isNaN(f)&& f!==0){
						flag = true;
					}					
				}
				if(!flag){
					//baseData.splice(i,1);
				}else{
					break;
				}
			}
			// begin to put data into tables
			f = parseInt(movePeriod.posYear,10);
			allYears.sort(function(a,b){
				if(a>b) return 1;
				else if(a<b) return -1;
				else return 0;
			});
			var startYear = parseInt($('#yearsTableTr').children().eq(0).children('table').attr('id').substr(0,4), 10);
			var jump = parseInt(movePeriod.posYear,10) - startYear;
			for(var i = 0; i < optionYears.length; i++) {
				delYear(false,optionYears[i]);
			}
			/*if(jump > 0) {
				for(var i = 0; i < jump; i++) {
					optionYears.splice(0, 1);
				}
			}
			if(jump < 0) {
				for(var i = 0; i < jump; i++) {
					optionYears.splice(0, 0, parseInt(optionYears[0], 10) - 1);
				}
			}*/
			k = baseData.length-startIdx.col;
			var targetYears =[]; //the target years to put data into
				//addYears = []; //the years needed to add into yearTablesTr
			temp=0;
			var removeYears=[];
			for(i=0,j=allYears.length;i<j;i++){
				if(allYears[i] < f){
					if(itemInArray(allYears[i],optionYears)){
						addYear(false,allYears[i]);
						optionYears.splice(0,1);
					}else{
						clearTableToZero(allYears[i]);
					}					
				}else if(allYears[i] == f){
					if(itemInArray(allYears[i],optionYears)){
						addYear(false,allYears[i]);
						optionYears.splice(0,1);
					}
					targetYears.push(allYears[i]);
					temp = 1;
				}else if(temp<k){//even if allYears[0]>f, also in control
					if(itemInArray(allYears[i],optionYears)){
						addYear(false,allYears[i]);
						optionYears.splice(0,1);
					}
					targetYears.push(allYears[i]);
					temp ++;
				}else{
					//delYear(false,allYears[i]);
				}				
			}			
			//for(var j )
			for(i = 0; i < jump; i++) {
				if(allYears[i] == optionYears[i]){
					jump++;
				}
				else{
					addYear(false,optionYears[i]);
				}
			}
			temp = baseData.length;
			for(i=0,j=targetYears.length;i<j;i++){
				if(i+startIdx.col <temp){
					$('#'+targetYears[i]+'Table').children('tbody').children().each(function(idx){						
						f = $(this).children().children('input');
						if(f.length>0)
						f.val(baseData[i+startIdx.col][idx]);						
					});
				}else{
					delYear(false,targetYears[i]);
				}
			}
			temp = 0;
			$('#addYearBtn').prev().children().each(function(){//clear possible repeated options
				if(temp == this.value){
					$(this).remove();
				}else{
					temp = this.value;
				}
			});
			gSaveStrs = null;
			tp(false,false);//since table compute has many limit and condition, it is better to call tableCompute directly
			targetYears = allYears = f = i = j = k = null;
		}
	}
}
function clearTableToZero(year){
	var temp,recycle = getRecycle(),r = currencylabel+'0';
	$('#'+year+'Table').children('tbody').children().each(function(idx){
		if(idx>recycle||idx===1){
			temp = $(this).children();
			temp.children('input').val(0);
			temp.children('span').text(0);
		}else if(idx<recycle){
			temp = $(this).children();
			temp.children('input').val(0);
			temp.children('span').text(r);
		}
	});
}
/*** get data from given table ***/
function getTableData($table,recycle){
	var ary=[];
	$table.children('tbody').children().each(function(i){
		if(i>recycle){
			if(i%recycle == 1){
				ary.push(0);
			}else{
				ary.push($(this).children().children('input').val());
			}
		}else if(i>1 && i< recycle){
			ary.push($(this).children().children('input').val());
		}else{
			ary.push(0);//to hold place
		}
	});
	return ary;
}
/*** get move peroid info with given year and month ***/
function getMovePeroid(year,month){
	var result = {str:'The start date will be ',
					position:0,
					posYear:0};
	switch(forecastLevel){
		case 'Yearly':
			if(month < 9){
				result.str += year;
				result.posYear = year;
			}else{ 
				result.str += (year + 1);
				result.posYear = year + 1;
			}
			break;
		case 'Quarterly':
			if(month < 3){
				result.str +=  'FQ2 Qty of ' + year;
				result.position = 1;
				result.posYear = year;
			}else if(month < 6){
				result.str +=  'FQ3 Qty of ' + year;
				result.position = 2;
				result.posYear = year;
			}else if(month < 9){
				result.str +=  'FQ4 Qty of ' + year;
				result.position = 3;
				result.posYear = year;
			}else{
				result.str +=  'FQ1 Qty of ' + (year+1);//result.position = 0;
				result.posYear = year + 1;
			}
			break;
		case 'Monthly':
			var map = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
			if(month < 6){
				result.str += 'FM0' + (month+4) + ' ' + map[month] + ' of ' + year;
				result.position = month+3;
				result.posYear = year;
			}else if(month < 9){
				result.str += 'FM' + (month+4) + ' ' + map[month] + ' of ' + year;
				result.position = month + 3;
				result.posYear = year;
			}else{
				result.str += 'FM0' + (month-8) + ' ' + map[month] + ' of ' + (year+1);
				result.position = month-9;
				result.posYear = year + 1;
			}
			break;
	}
	return result;
}
/*** return message ***/
function getMsgInvalidYear(){
	return document.getElementById("LabelMsgInvalidYear").value;
}
/*** return message ***/
function getMsgInvalidStartDate(){
	return document.getElementById("LabelInvalidStartDate").value;
}
/*** check 'Lost' or 'Dead' row number,and push them into confidences, which is useful in table calculation ***/
var hhh;
function findConfidences(isView){//ok	
	confidences=[];//make it empty
	var v;
	//added by bin yuan 2014-04-11 due to remove Process status for spin 
	var isSpin = document.getElementById("hiddenSPINId").value;
	//end 
	if(isView){
		$('#left_Tbody').children().each(function(i){
            //added by bin yuan 2014-04-11 due to remove Process status for spin 
            if(isSpin && isSpin == 'true' || isSpin === true) {
                v = $(this).children().last().children('div').text();
            }
            else{
            	v = $(this).children().last().prev().children('div').text();
            }
            //end
			//v = $(this).children().last().prev().children('div').text();
			if('Lost' === v || 'Dead' === v){
				confidences.push(i);
			}
		});
	}else{
		$('#left_Tbody').children().each(function(i){
			//hhh = $(this).children().last().prev();
            if(isSpin && isSpin == 'true' || isSpin === true) {
                v = $(this).find('td:last select.selectConfidence option:selected').val();
            }
            else{
            	v = $(this).children().last().prev().children('select.selectConfidence').val();
            }
			//v = $(this).children().last().prev().children('select.selectConfidence').val();
			
			if('Lost' === v || 'Dead' === v){
				confidences.push(i);
			}
		});
	}
}
/*** check if user is admin ***/
function isUserAdmin(){//ok
	var s = document.getElementById('isAdmin').value;
	s = s.replace(/^\s+|\s+$/,'').toLowerCase();
	if(s == 'true')
		return true;
	else
		return false;
}

/*** check if oppty is appliance oppty ***/
function isAppliance(){
	var s = document.getElementById('hiddenAPLId').value;
	s = s.replace(/^\s+|\s+$/,'').toLowerCase();
	if(s == 'true')
		return true;
	else
		return false;
}

// Updated Raul 2016.04.18 Begin
/*** check if oppty is DND oppty ***/
function isDND(){
	var s = document.getElementById('hiddenDNDId').value;
	s = s.replace(/^\s+|\s+$/,'').toLowerCase();
	if(s == 'true')
		return true;
	else
		return false;
}
// Updated Raul 2016.04.18 End

/*** make select list dependent ***/	
function checkSelect(elem,type){
	var isAdmin;	
	if(isUserAdmin()){
		isAdmin = true;
	}else{
		isAdmin = false;
	}
	if(isAdmin && type === 1){
		return true;
	}
	if(!elem.value) return true;
	var confidence1 = Gconfidence1,
		confidence2 = Gconfidence2,
		status1 = Gstatus1,
		status2 = Gstatus2,
		statusFinal = GstatusFinal,

		neighbour,
		leftInGroup1,
		leftInGroup2,
		rightInGroup1,
		rightInGroup2,
		elemOptNum = $(elem).children().length,
		stageName,
		optStr,
		isPrevDeadLost = false;

	// 2014-06-09 Michael Cui: added for case 00677873	
	if(isAppliance())
	{
		status1 = Gstatus3;
		status2 = Gstatus4;
	}

        // Updated Raul 2016.04.18 Begin
        if(isDND())
        {
                status1 = Gstatus5;
                status2 = Gstatus6;
        }
        // Updated Raul 2016.04.18 End

	if(type === 0) neighbour = $(elem).parent().next().find('select');
	else neighbour = $(elem).parent().prev().find('select');
	var neighbourVal;
	neighbour.children().each(function(){
		if($(this).attr('selected') == 'selected') neighbourVal = this.value;
	});
	
	
	
	if(type === 0){//current select is confidence
		if(!itemInArray(elem.value, confidence1) && !itemInArray(elem.value, confidence2)) {return false;} // do nothing
		else{
			
			if(oldStatusVal[elem.id]=='Dead'||oldStatusVal[elem.id]=='Lost'){
				isPrevDeadLost = true;
			}
			if(itemInArray(elem.value, confidence1)){

				//manage the options - begin
				var valuesOfStatus1 = [];

				neighbour.children().each(function(){
					if(itemInArray(this.value,status1)){
						valuesOfStatus1.push(this.value);
					}
				});

				if(valuesOfStatus1.length < status1.length){//some options is missing, need make up
					optStr = '';
					for(var k=0; k<status1.length; k++){
						optStr += '<option value="' + status1[k] + '"';						
						optStr += '>' + status1[k] + '</option>';
					}
					neighbour.empty().append(optStr).val(oldStatusVal[neighbour.attr('id')]);
				}
				neighbour.children().each(function(){
					if(!itemInArray(this.value,status1)){
						$(this).remove();
					}
				});
				//manage the options - end

				if(elem.value=='Dead'||elem.value=='Lost') {					
					//oldStatusVal[neighbour.attr('id')] = neighbourVal;
				}			
				if(itemInArray(neighbourVal, status1)){
					neighbour.children().each(function(){
						if(itemInArray(this.value, statusFinal) || this.value === 'Pre-prod') $(this).remove();
					});
				}
				else if(!itemInArray(neighbourVal, status1) && itemInArray(neighbourVal, status2)){
					neighbour.children().each(function(){
						if($(this).val() === 'Concept') {
							$(this).attr('selected', 'selected');
							neighbour.val($(this).val());
						}
						if(itemInArray(this.value, statusFinal) || this.value === 'Pre-prod') $(this).remove();
					});
				}
				else if(!itemInArray(neighbourVal, status1) && !itemInArray(neighbourVal, status2)){
					neighbour.children().each(function(){
						if(itemInArray(this.value, statusFinal) || this.value === 'Pre-prod') $(this).remove();
					});
				}
				if(elem.value=='Dead'||elem.value=='Lost'||elem.value=='Won') {
					//oldStatusVal[elem.id] = elem.value;
					//oldStatusVal[neighbour.attr('id')] = neighbour.val();
					return true;
				}	
			}
			// Won
			else if(itemInArray(elem.value, confidence2)){
				var isFind = false;
				optStr = '';
				neighbour.children().each(function(){
					if(itemInArray(this.value, statusFinal) || this.value === 'Pre-prod') isFind = true;
				});
				if(!isFind){					
					neighbour.val('Pre-prod');
					optStr = '<option value="Pre-prod" selected="selected">Pre-prod</option>';
					for(var k=0; k<statusFinal.length; k++){
						optStr += '<option value="' + statusFinal[k] + '"';						
						optStr += '>' + statusFinal[k] + '</option>';
					}
					neighbour.append(optStr);
				} 
				//add on May 8,2014 by Fuqi. - begin
				//Reason:when user is not admin, and select 'Won', he can not select value of status 1
				if(!isAdmin){
					neighbour.children().each(function(){
						if(itemInArray(this.value, status1) ) {
							$(this).remove();
						}
					});
				}
                //Prabhanjan : allowing Won status to go to modal window for Only DND Record Type.
                var isDND_jsvar = document.getElementById("dndid").value;
                if(isDND_jsvar=='true'){
                	return true;
                }  
                //Prabhanjan : allowing Won status to go to modal window for ADM Record Type.
                var isADM_jsvar = document.getElementById("admrecordtypeid").value;
                if(isADM_jsvar=='true'){
                	return true;
                }    
				//add on May 8,2014 by Fuqi. - end
			}			
		}
	}
	// process status is selected
	else{
		//if(itemInArray(elem.value, status1))
		if(!itemInArray(elem.value, status1) && itemInArray(elem.value, status2)){
			if(!itemInArray(neighbourVal, confidence2)){
				neighbour.children().each(function(){
					if($(this).val() === confidence2[0]) {
						$(this).attr('selected', 'selected');
						neighbour.val($(this).val());
					}
				});
			}
		}
	}
	oldStatusVal[elem.id] = elem.value;
	oldStatusVal[neighbour.attr('id')] = neighbour.val();
	//if(isPrevDeadLost){
		findConfidences();
		tp(false,false,false,false);
	//}
}

/*** make select list dependent ***/	
function checkSelect_backup(elem,type){
	var isAdmin;
	if(isUserAdmin()){
		isAdmin = true;
	}else{
		isAdmin = false;
	}
	if(isAdmin && type === 1){
		return true;
	}
	if(!elem.value) return true;
	var confidence1 = ['On Hold','Weak','50/50','Likely','Commit','Dead','Lost','TAM'],
		confidence2 = ['Won'],
		status1 = ['Concept','Demo','Designed','Prototyped/Sampled','Quoted'],
		status2 = ['Pre-prod','Production','Ramp-down','EOL'],
		
		//oldVal = oldStatusVal[elem.id],
		neighbour,
		neighbourVal,
		leftInGroup1,
		leftInGroup2,
		rightInGroup1,
		rightInGroup2,
		elemOptNum = $(elem).children().length,
		stageName,
		optStr;
		//oldVal = typeof oldVal !== 'undefined'?oldVal:elem.value; 
	if(type === 0){//current select is confidence
		neighbour = $(elem).parent().next().find('select'), 
		neighbourVal = neighbour.val(),
		leftInGroup1 = itemInArray(elem.value,confidence1),
		leftInGroup2 = itemInArray(elem.value,confidence2),
		rightInGroup1 = itemInArray(neighbourVal,status1),
		rightInGroup2 = itemInArray(neighbourVal,status2);
		oldStatusVal[elem.id] = elem.value,
		maxLength = Math.max(optionBackup.s1.length,optionBackup.s2.length);		
		if(leftInGroup1){
			/*if(!isAdmin){
				 $(elem).children().each(function(){
				 	if(itemInArray(this.value,optionBackup.c2)){
						$(this).remove();
					}
				 });
			}*/			
			if(rightInGroup2){	
				optStr = '';
				for(var k=0,j = optionBackup.s1.length; k<j; k++){
					optStr += '<option value="' + optionBackup.s1[k] + '"';
					if( k == 0 ){
						optStr += 'selected="selected"';
					}
					optStr += '>' + optionBackup.s1[k] + '</option>';
				}	
				neighbour.empty().append(optStr);
				return false;
			}else{
				if(elemOptNum > maxLength){
					neighbour.children().each(function(){
						if(itemInArray(this.value,optionBackup.s2)){
							$(this).remove();
						}
					});					
				}
				return true;
			}
		}else if(leftInGroup2){
			if(!isAdmin){
				 $(elem).children().each(function(){
				 	if(itemInArray(this.value,optionBackup.c1)){
						//$(this).remove();
					}
				 });
			}
			if(rightInGroup1){
				optStr = '';
				for(var k = 0,j=optionBackup.s2.length; k<j; k++){
					optStr += '<option value="' + optionBackup.s2[k] + '"';
					if( k == 0 ){
						optStr += 'selected="selected"';
					}
					optStr += '>' + optionBackup.s2[k] + '</option>';
				}	
				neighbour.empty().append(optStr);
				return false;
			}else{
				if(elemOptNum > maxLength){
					neighbour.children().each(function(){
						if(itemInArray(this.value,optionBackup.s1)){
							$(this).remove();
						}
					});
				}
				return true;
			}
		}
	}else{
		neighbour = $(elem).parent().prev().find('select'), 
		neighbourVal = neighbour.val(),
		leftInGroup1 = itemInArray(neighbourVal,confidence1),
		leftInGroup2 = itemInArray(neighbourVal,confidence2),
		rightInGroup1 = itemInArray(elem.value,status1),
		rightInGroup2 = itemInArray(elem.value,status2);
		stageName = $.trim($(elem).siblings().filter('.stageName').val()).toLowerCase(),
		maxLength = Math.max(optionBackup.c1.length,optionBackup.c2.length);		
		/*if(stageName == 'new'){
			if(oldStatusVal[elem.id] === 'Concept'){
				alert('Option "Concept" with Opportunity phase "New" can NOT be changed.');
				elem.value = 'Concept';
				return false;
			}else{
				if(elem.value === 'Concept'){
					oldStatusVal[elem.id] = '-Concept';
				}else{
					oldStatusVal[elem.id] = elem.value;
				}
			}
		}*/
		if(rightInGroup2 ){
			if(!isAdmin){
				 $(elem).children().each(function(){
				 	if(itemInArray(this.value,optionBackup.s1)){
						//$(this).remove();
					}
				 });
			}	
			if(leftInGroup1){
				optStr = '';
				for(var k=0,j=optionBackup.c2.length; k<j; k++){
					optStr += '<option value="' + optionBackup.c2[k] + '"';
					if( k == 0 ){
						optStr += 'selected="selected"';
					}
					optStr += '>' + optionBackup.c2[k] + '</option>';
				}
				neighbour.empty().append(optStr);
				return false;
			}else{
				if(elemOptNum > maxLength){					
					neighbour.children().each(function(){
						if(itemInArray(this.value,optionBackup.c1)){
							$(this).remove();
						}
					});
				}
				return true;
			}
		}else if(rightInGroup1){
			if(!isAdmin){
				 $(elem).children().each(function(){
				 	if(itemInArray(this.value,optionBackup.s2)){
						//$(this).remove();
					}
				 });
			}			
			if(leftInGroup2){
				/*
				if(stageName == 'new'){ // if stageName is 'New', option 'Dead' should be deleted.
					neighbour.empty().append('<option value="On Hold">On Hold</option><option value="Weak">Weak</option><option value="50/50" selected="selected">50/50</option><option value="Likely">Likely</option><option value="Commit">Commit</option><option value="Lost">Lost</option><option value="TAM">TAM</option>');
				}else{
					neighbour.empty().append('<option value="On Hold">On Hold</option><option value="Weak">Weak</option><option value="50/50" selected="selected">50/50</option><option value="Likely">Likely</option><option value="Commit">Commit</option><option value="Dead">Dead</option><option value="Lost">Lost</option><option value="TAM">TAM</option>');
				}*/
							
				optStr = '';			
				for(var k=0,j=optionBackup.c1.length; k<j; k++){
					//if(stageName != 'new' || optionBackup.c1[k] != 'Dead'){// if stageName is 'New', option 'Dead' should be deleted.
					if(stageName != 'new'){
						optStr += '<option value="' + optionBackup.c1[k] + '"';
						if( k == 0 ){
							optStr += 'selected="selected"';
						}
						optStr += '>' + optionBackup.c1[k] + '</option>';
					}
				}
				neighbour.empty().append(optStr);				
				return false;
			}else{
				if(elemOptNum >= maxLength){
					neighbour.children().each(function(){
						if(itemInArray(this.value,optionBackup.c2)){
							$(this).remove();
						}
					});
				}
				return true;
			}
		}
	}
}

/*** check if item in given array ***/
function itemInArray(item,ary){//ok
	if(!item && (ary.length ===5||ary.length ===4)) return true; // just for ary including empty item
	for(var k in ary){
		if(ary[k] === item) {return true;}
	}
	return false;
}
/*** change Forecast Method ***/
function selectMethod(){
	var p = $('#inlineTable');
	var method;
	if(p.hasClass('isManual')){
		p.removeClass('isManual').addClass('isBom');
		method = isBOM = 'BOM';
		// min
		$(p).find('#firstTableTd').children('input[type="hidden"]').each(function(){
			if(this.id.indexOf('oppyMethod') != -1) $(this).val('BOM');	
		});
		tp(false,false,false,false);
		displayByMethod('BOM');
	}else{
		p.removeClass('isBom').addClass('isManual');
		method = isBOM = 'Manual';
		// min
		$(p).find('#firstTableTd').find('input[type="hidden"]').each(function(){
			if(this.id.indexOf('oppyMethod') != -1) $(this).val('Manual');	
		});
		displayByMethod('Manual');
	}	
	p = undefined;
	//need to update the oppy method in gSaveStrs, but it is troublesome as below. 
	//Just take its apex inputHidden value
	
	var saveStr;
	if(saveStr = gSaveStrs){
		var f,g,data,str,omthod = (method == 'BOM'?'Manual':'BOM');
		for(f=0,g=saveStr.length; f<g; f++){
			data = saveStr[f]['data'];
			str = data[0];
			str = str.replace(omthod,method);
			data[0] = str;
		}
		gSaveStrs = saveStr;
	}
}

// min
function displayByMethod(method){
	if(method == 'BOM'){
		$('#inlineTable').find('tr.bomShow').each(function(){
			this.style.display = '';
		});
	}
	else{
		$('#inlineTable').find('tr.bomShow').each(function(){
			this.style.display = 'none';
		});
	}
}

/*** get Map_Pid_Price ***/
function getMap_Pid_Price(){
	if(typeof Map_Pid_Price == 'string'){//set the value for next use
		var str = Map_Pid_Price,map={},item,i,j;
		if(str){
			str = str.split(';');//in case only 1 part, there will be no ';' contained
			j=str.length;
			for(i=0;i<j;i++){
				item = str[i];
				item = item.replace('[','').replace(']','');
				item = item.split(',');
				if(item.length == 2){
					map[item[0]] = parseFloat(item[1]);
				}
			}
			Map_Pid_Price = map;
		}
	}
	return Map_Pid_Price;
}
/*** add year table with given option or year ***/
function addYear(el,yearVal){
	var year=[];
	if(yearVal){
		if(isNaN(parseInt(yearVal,10))){
			return false;
		}
		//year = yearVal		
		year = [yearVal];
		el = $('#addYearBtn');
	}else{
		var tmp1 = parseInt($(el).prev().val(),10),tmp2;
		if(isNaN(tmp1)||$(el).prev().val() == '--None--'){
			return false;
		}
		
		else{
			$(el).prev().children().each(function(){
				tmp2 = parseInt($(this).val(),10);
				if(tmp2<tmp1){
					year.push(tmp2);
				}
			});
			year.push(tmp1);
		}
	}
	var	base,
		temp,
		display,
		imgSrc = getSrc(),
		recycle = getRecycle(),
		$partrows = $('#partTable').children(),
		str,
		ary,
		g,
		p1,
		p2,
		priceValue,
		map_pid_price = getMap_Pid_Price(),
		k,
		partId,
		hasPart,
		partData,
		map_data,
		isApprvl = isAppOrIndBu;
		isApprvl = (''+isApprvl).toLowerCase()=='true'?true:false;
		if(isApprvl) map_data = map_partData;
		
	for(g=0;g<year.length;g++){
		str = ['<td class="Ytd"><table id="'+year[g]+'Table" class="list tableNoLeftBorder" cellspacing="0" cellpadding="0" border="0"><thead><tr class="headerRow"><th class="thyear headerCenter">'],
		ary = [[year[g],forecastLevel,isBOM].join(';')];
		priceValue = 0;//reset its value
		$partrows.each(function(i){//make up rows based on part table rows
			if(i===0){//thead
				str.push('<img src="'+imgSrc+'" onclick="if (!confirm(getAreYouSure())) return;else delYear(this);" title="Delete" width="10px" height="10px"/> <span>'+year[g]+'</span></th></tr></thead><tbody>');
			}else if(i ===1){//tbody
				$(this).children().each(function(j){
					if($(this).is(':hidden')){
						display = ' style="display:none;"';
					}else{
						display = '';
					}
					if(j === 0){
						str.push('<tr class="dataRow widedataRow" onmouseOver="om(this,1,true);" onmouseOut="om(this,0,true);"><td class="twidedataCell tdTwo"  title="'+year[g]+'"><span>'+currencylabel+'0</span></td></tr>');
					}else if(j===1){
						str.push('<tr class="dataRow bomShow" onmouseOver="om(this,1,true);" onmouseOut="om(this,0,true);"><td class="dataCell tdTwo"><span>0</span></td></tr>');
					}else if(j<recycle){
						str.push('<tr class="dataRow Qzone"'+display+' onmouseOver="om(this,1,true);" onmouseOut="om(this,0,true);"><td class="dataCell tdTwo"><input type="text" value="0" class="bomShow" onchange="tp(this,'+year[g]+')"/><span class="bomHide">'+currencylabel+'0</span></td></tr>');
						ary.push('0;0;0;');
					}else if(j === recycle){
						str.push('<tr class="headerRow"><th class="thyear headerCenter">'+year[g]+'</th></tr>');
					}else{
						if(j%recycle>2 || j%recycle === 0){
							str.push('<tr class="dataRow Qzone"'+display+' onmouseOver="om(this,1,true);" onmouseOut="om(this,0,true);"><td class="dataCell tdTwo"><input type="text" value="0" class="bomHide" onchange="tp(this,'+year[g]+')"/><span class="bomShow">0</span></td></tr>');
							ary.push('0;0;'
							+ fmtNum(priceValue,0,false,true)
							+';');
						}else if(j%recycle === 1){
							str.push('<tr class="dataRow" onmouseOver="om(this,1,true);" onmouseOut="om(this,0,true);"><td class="dataCell tdTwo" onmouseover="ov(1,this,'+year[g]+');"><span class="Total">0</span><div class="rpd"></div></td></tr>');
						}else if(j%recycle === 2){
							var pid = $(this).attr('data_pid');
							priceValue = map_pid_price[pid]||0;
							//changed to formated string
							priceValue = showFormat(priceValue);
							str.push('<tr class="dataRow Qprice"'+display+' onmouseOver="om(this,1,true);" onmouseOut="om(this,0,true);"><td class="dataCell tdTwo"><input type="text" value="',priceValue,'" class="priceInput" onchange="ptp(this,'+year[g]+')"/></td></tr>');
						}
					}
				});
			}
		});
		str.push('</tbody></table></td>');
		base = $('#yearsTableTr').children();//decide where to insert --begin
		if(base.length > 0){
			p1 = p2 = -1;
			base.each(function(i){
				temp = $(this).children().attr('id');
				temp = temp.substr(0,4);
				if(parseInt(temp,10) < parseInt(year[g],10)){
					p1 = i;
				}else{
					if(p2===-1){
						p2 = i;
					}
				}
			});
			if(p1 >= 0 && p2 >= 0){
				base.eq(p1).after(str.join(''));
			}else if(p1 >= 0 && p2 <0){
				base.eq(p1).after(str.join(''));
			}else if(p1 < 0 && p2 >=0){
				base.eq(p2).before(str.join(''));
			}
		}else{
			$('#yearsTableTr').append(str.join(''));
		}			//decide where to insert --end
		base = temp = str = null;
		if(gSaveStrs){// update gSsaveStr for possible save function
			gSaveStrs.push({year:year[g]+'Table',data:ary});
		}else{
			gSaveStrs=[{year:year[g]+'Table',data:ary}];
		}
		$(el).prev().children().each(function(i){//update the year options
			if(i === 0){
				$(this).attr('selected',true);
			}
			if(year[g] == this.value){
				$(this).remove();
				return false;
			}		
		});
		//make up the buInfo data
		if(isApprvl){
			for(partId in map_data){
				partData = map_data[partId];
				if(!partData)partData = [];
				hasPart = false;
				for(k=partData.length-1;k>=0;k--){
					if(parseInt(partData['fiscalYear'],10)==parseInt(year[g],10)){
						hasPart = true;
					}
				}
				if(!hasPart){
					partData.push({'fiscalYear':year[g],'newValue':0,'oldValue':0});
				}
			}
		}
	}
}
/*** delete year table data with given element or year ***/
function delYear(el,_year){
	if(el){//clear table data
		while(el.parentNode){
			el = el.parentNode;
			tmp = (''+el.nodeName).toUpperCase();
			if(tmp == 'TABLE'){
				break;
			}
		}
		year = $(el).attr('id');
		year = parseInt(year.substr(0,4),10);
		$(el).children('tbody').children().each(function(){
			$(this).children().children('input').val(0);
		});
		resetYearBuInfo(year);
		tp(false,year,false,false);
	}else{//remove year table
		year = _year,
		el = document.getElementById(year+'Table');
		var options = $('#addYearBtn').prev().children();
		tmp = -1;
		options.each(function(i){
			if(i>0 && parseInt(this.value,10)> parseInt(year,10)){
				tmp = i;
				return false;
			}
		});
		if(tmp > -1){
			$('<option value="'+year+'">'+year+'</option>').insertBefore(options.eq(tmp));
			flag1=1;
		}else{
			$('<option value="'+year+'">'+year+'</option>').insertAfter(options.last());
			flag1=1;
		}
		if(flag1===1){
			$(el).parent().remove();
		}else{
			alert('Error occurred,please check or retry.');
		}
		resetYearBuInfo(year);
		if(!gSaveStrs){
			tp(false,false,false,false);
		}else{
			for(var i=gSaveStrs.length-1; i>=0; i--){
				tmp = gSaveStrs[i].year.substr(0,4);
	        	if(tmp == year){
	        		gSaveStrs.splice(i,1);
	        	}
	        }
	    }
	}	
}
function resetYearBuInfo(year,notAddNew){
	var isApprvl = isAppOrIndBu;
		isApprvl = (''+isApprvl).toLowerCase()=='true'?true:false;
	if(isApprvl){
	var map_data = map_partData,partId,partData,hasPart,k;
		for(partId in map_data){
			partData = map_data[partId];
			if(!partData)partData = [];
			hasPart = false;
			for(k=partData.length-1;k>=0;k--){
				if(parseInt(partData[k]['fiscalYear'],10)==parseInt(year,10)){
					partData[k]['newValue'] = 0;
					hasPart = true;
				}
			}
			if(!hasPart && !notAddNew){
				partData.push({'fiscalYear':year,'newValue':0,'oldValue':0});
			}
		}
	}
}
/*** return message ***/
function getSrc(){
	return document.getElementById("deleteSrc").value;
}
/*** return message ***/
function getAreYouSure(){
	return document.getElementById("msgAreYouSure").value;
}
/*** return recycle value ***/
function getRecycle(){
	var recycle = 0;
	if(forecastLevel==='Quarterly'){
		recycle=6;
	}else if(forecastLevel==='Monthly'){
		recycle=14;
	}else if(forecastLevel==='Yearly'){
		recycle=3;
	}
	return recycle
}
/*** add rows or remove rows in left table ***/
function addLinesForLeft(lineNum){
	var mod,display,recycle;
	if(lineNum===8||lineNum===-3){
		recycle = 6;
	}else if(lineNum>0){// +3,+11 rows
		recycle = 3;
	}else {//-8,-11 rows
		recycle = 14;
	}
	if(lineNum>0){//add rows
		$('#list_TableLeft').children('tbody').children().each(function(idx){
			if(idx>recycle){
				mod = idx%recycle;
				if(mod ===0){
					if($(this).is(':hidden')){
						display = ' style="display:none;"';
					}else{
						display = '';
					}
					$(this).after(getPartLeftString(display,1,lineNum));
				}
			}else if(idx ===recycle-1){
				if($(this).is(':hidden')){
					display = ' style="display:none;"';
				}else{
					display = '';
				}
				$(this).addClass('noBorderTr').after(getPartLeftString(display,0,lineNum));
			}
		});
	}else{//remove rows
		var rows = $('#list_TableLeft').children('tbody').children();
		for(var i=rows.length-1;i>1;i--){
			if(i>recycle){
				mod = i%recycle;
				if(mod>recycle+lineNum||mod===0){
					rows.eq(i).remove();
				}
			}else if(i<recycle){
				if(i>recycle-1+lineNum){
					rows.eq(i).remove();
				}else if(i===recycle-1+lineNum){
					rows.eq(i).removeClass('noBorderTr');
				}
			}
		}
		rows = null;
	}
	findConfidences(false);//update the confidences data
}
/*** add or remove rows in part table ***/
function addLinesForPart(lineNum){
	var mod,display,map,recycle;
	switch(lineNum){
		case 8:
			map = ['FM01 Oct','FM02 Nov','FM03 Dec','FM04 Jan','FM05 Feb','FM06 Mar','FM07 Apr','FM08 May','FM09 Jun','FM10 Jul','FM11 Aug','FM12 Sep'];
			recycle = 6;
			break;
		case 3:
			map = ['FQ1 Qty.','FQ2 Qty.','FQ3 Qty.','FQ4 Qty.'];
			recycle = 3;
			break;
		case 11:
			map = ['FM01 Oct','FM02 Nov','FM03 Dec','FM04 Jan','FM05 Feb','FM06 Mar','FM07 Apr','FM08 May','FM09 Jun','FM10 Jul','FM11 Aug','FM12 Sep'];
			recycle = 3;
			break;
		case -3:
			map = ['Year Qty'];
			recycle = 6;
			break;
		case -8:
			map = ['FQ1 Qty.','FQ2 Qty.','FQ3 Qty.','FQ4 Qty.'];
			recycle = 14;
			break;
		case -11:
			map = ['Year Qty'];
			recycle = 14;
		break;
	}	
	if(lineNum>0){
		$('#partTable').children('tbody').children().each(function(idx){
			if(idx>recycle){
				mod = idx%recycle;
				if(mod>2){
					$(this).children().text(map[mod-3]);
				}else if(mod ===0){
					$(this).children().text(map[recycle-3]);
					if($(this).is(':hidden')){
						display = ' style="display:none;"';
					}else{
						display = '';
					}
					$(this).after(getPartRowString(display,0,map,recycle-2))
				}
			}else{
				if(idx>1 && idx<recycle){
					$(this).children().text(map[idx-2]);
					if(idx ===recycle-1){
						if($(this).is(':hidden')){
							display = ' style="display:none;"';
						}else{
							display = '';
						}
						$(this).after(getPartRowString(display,0,map,idx-1));
					}
				}
			}
		});
	}else{
		var rows = $('#partTable').children('tbody').children(),
			mod;
		for(var i=rows.length-1;i>1;i--){
			if(i>recycle){
				mod = i%recycle;
				if(mod>recycle+lineNum||mod===0){
					rows.eq(i).remove();
				}else if(mod>2){
					rows.eq(i).children().text(map[mod-3]);//Q-->Y,M-->Q,or M-->Y, all in control
				}
			}else if(i<recycle){
				if(i>recycle-1+lineNum){
					rows.eq(i).remove();
				}else if(i>1){
					rows.eq(i).children().text(map[i-2]);//Q-->Y,M-->Q,or M-->Y, all in control
				}
			}
		}
	}
}
/*** change forecast level ***/
function selectLevel(newLevel){
	var originLevel = forecastLevel;
	if(newLevel === originLevel){
		return false;
	}
	try{
		forecastLevel = newLevel;
		var mod,ary=[],tmp0,tmp1,tmp2,display,year,map;
		if(originLevel==='Quarterly'){
			if(newLevel ==='Monthly'){
				//add 8 rows 
				addLinesForLeft(8);
				addLinesForPart(8);
				addLinesForYearTable(8);			
			}else{//yearly
				addLinesForLeft(-3);
				addLinesForPart(-3);
				addLinesForYearTable(-3);
			}
		}else if(originLevel==='Monthly'){
			if(newLevel ==='Quarterly'){
				addLinesForLeft(-8);
				addLinesForPart(-8);
				addLinesForYearTable(-8);
			}else{//yearly
				addLinesForLeft(-11);
				addLinesForPart(-11);
				addLinesForYearTable(-11);
			}
		}else{//origin is Yearly
			if(newLevel ==='Quarterly'){
				//addLines = 3;
				addLinesForLeft(3);
				addLinesForPart(3);
				addLinesForYearTable(3);
			}else{// newLevel is Monthly
				addLinesForLeft(11);
				addLinesForPart(11);
				addLinesForYearTable(11);
			}
		}	
	}catch(e){
		forecastLevel = originLevel;
	}	
}
/*** add or remove rows in year table ***/
function addLinesForYearTable(lineNum){
	var recycle,year,mod,tmp0,tmp1,tmp2,tmp3,tmp4,ary=[],tempArray,i,flag,excpt = false;
	if(lineNum===8||lineNum ===-3){
		recycle = 6;
	}else if(lineNum===3||lineNum ===11){
		recycle = 3;
	}else{
		recycle = 14;
	}
	try{
		if(lineNum>0){//add
			$('#yearsTableTr').children().each(function(){
				year = $(this).children('table').attr('id').substr(0,4);
				$(this).children('table').children('tbody').children().each(function(idx){
					flag = 0;
					if(idx>recycle){
						mod = idx%recycle;
						if(mod>2||mod===0){
							flag = 1;					
						}				
					}else{
						if(idx>1 && idx<recycle){
							flag = 2;
						}				
					}
					if(flag >0){
						//***********************// deal with the numbers
						tmp0 = $(this).children().children('input'),
						tmp1 = fmtNum(tmp0.val(),locale,false);
						if(lineNum === 8){
							tmp2 = Math.round(tmp1*4/13),
							tmp1 = showFormat(tmp1-2*tmp2),
							tmp2 = showFormat(tmp2);
							ary.push(tmp2,tmp1,tmp2);
						}else if(lineNum === 3){
							tmp2 = Math.floor(tmp1/4),
							tmp3 = tmp1%4;
							tempArray = [tmp2,tmp2,tmp2,tmp2];
							for(i=0;i<tmp3;i++){
								tempArray[i]++
							}
							ary = ary.concat(tempArray);
						}else{
							tmp2 = Math.floor(tmp1/4),
							tmp3 = tmp1%4;
							tempArray = [tmp2,tmp2,tmp2,tmp2];
							for(i=0;i<tmp3;i++){
								tempArray[i]++
							}
							
							for(i=0;i<4;i++){
								tmp2 = Math.round(tempArray[i]*4/13),
								tmp1 = showFormat(tempArray[i]-2*tmp2),
								tmp2 = showFormat(tmp2);
								ary.push(tmp2,tmp1,tmp2);
							}
						}
						//**************************//
						if(flag === 1){
							if(mod ===0){
								tmp0.val(ary[recycle-3]);
								if($(this).is(':hidden')){
									display = ' style="display:none;"';
								}else{
									display = '';
								}
								$(this).after(getRowString(display,year,ary,recycle-2,1));
								ary = [];
							}else{
								tmp0.val(ary[mod-3]);
							}
						}else{
							tmp0.val(ary[idx-2]);
							if(idx === recycle-1){
								if($(this).is(':hidden')){
									display = ' style="display:none;"';
								}else{
									display = '';
								}
								$(this).after(getRowString(display,year,ary,recycle-2,0));							
								ary = [];
							}
						}
					}
				});
				//if(confirm('compute?'))tp(false,year);////////////////>>
			});
		}else{//remove
			var rows,subTotal=0,counter=0,tempArray=[];
			if(lineNum ===-8){//M-->Q
				$('#yearsTableTr').children().each(function(index){
					rows = $(this).children('table').children('tbody').children();
					for(i=rows.length-1;i>1;i--){
						if(i>recycle){
							mod = i%recycle;
							if(mod>recycle+lineNum||mod===0){
								subTotal += fmtNum(rows.eq(i).children().children('input').val(),locale,false);
								counter ++;
								if(counter === 3){
									tempArray.push(subTotal);
									counter = subTotal = 0;
								}							
								rows.eq(i).remove();
							}else if(mod>2){//mod:3,4,5,6
								subTotal += fmtNum(rows.eq(i).children().children('input').val(),locale,false);
								counter ++;
								if(counter === 3){
									tempArray.push(subTotal);
									counter = subTotal = 0;
								}
								rows.eq(i).children().children('input').val(showFormat(tempArray[6-mod]));
								if(mod===3){
									tempArray=[];
								}
							}
						}else if(i<recycle){
							if(i>recycle-1+lineNum){
								subTotal += fmtNum(rows.eq(i).children().children('input').val(),locale,false);
								counter ++;
								if(counter === 3){
									tempArray.push(subTotal);
									counter = subTotal = 0;
								} 
								rows.eq(i).remove();
							}else if(i>1){
								subTotal += fmtNum(rows.eq(i).children().children('input').val(),locale,false);
								counter ++;
								if(counter === 3){
									tempArray.push(subTotal);
									counter = subTotal = 0;
								}
								rows.eq(i).children().children('input').val(showFormat(tempArray[5-i]));
								if(i===2){
									tempArray=[];
								}
							}
						}
					}
					rows = null;
					//tp(false,$(this).children('table').attr('id').substr(0,4)); will cause problem
				});	
						//>>>>
			}else{//M-->Y or Q-->Y
				$('#yearsTableTr').children().each(function(index){
					rows = $(this).children('table').children('tbody').children();
					for(i=rows.length-1;i>1;i--){
						if(i>recycle){
							mod = i%recycle;
							if(mod>recycle+lineNum||mod===0){
								subTotal += fmtNum(rows.eq(i).children().children('input').val(),locale,false);							
								rows.eq(i).remove();
							}else if(mod>2){//Q-->Y,or M-->Y, all in control
								subTotal += fmtNum(rows.eq(i).children().children('input').val(),locale,false);
								rows.eq(i).children().children('input').val(showFormat(subTotal));
								subTotal = 0;
							}
						}else if(i<recycle){
							if(i>recycle-1+lineNum){
								subTotal += fmtNum(rows.eq(i).children().children('input').val(),locale,false);
								rows.eq(i).remove();
							}else if(i>1){//Q-->Y,or M-->Y, all in control
								subTotal += fmtNum(rows.eq(i).children().children('input').val(),locale,false);
								rows.eq(i).children().children('input').val(showFormat(subTotal));
								subTotal = 0;
							}
						}
					}
					rows = null;
					//tp(false,$(this).children('table').attr('id').substr(0,4)); //>>>>>
				});			
			}
		}
	}catch(ex){
		excpt = true;
	}
	if(!excpt)tp(false,false);
}
/*** make up row string for year table ***/
function getRowString(display,year,ary,start,oppy){
	var temp = [];
	if(oppy ===0){
		for(var i=start,j=ary.length;i<j;i++){
			temp.push('<tr class="dataRow Qzone"',display,
			' onmouseOver="om(this,1,true);" onmouseOut="om(this,0,true);"><td class="dataCell tdTwo"><input type="text" class="bomShow" onchange="tp(this,',
			year,')" value="',ary[i],'"/><span class="bomHide">0</span></td></tr>');
		}
	}else{
		for(var i=start,j=ary.length;i<j;i++){
			temp.push('<tr class="dataRow Qzone"',display,
			' onmouseOver="om(this,1,true);" onmouseOut="om(this,0,true);"><td class="dataCell tdTwo"><input type="text" class="bomHide" onchange="tp(this,',
			year,')" value="',ary[i],'"/><span class="bomShow">0</span></td></tr>');
		}
	}
	return temp.join('');
}
/*** make up row string for part table ***/
function getPartRowString(display,year,map,start){
	var temp = [];
	for(var i=start,j=map.length;i<j;i++){
		temp.push('<tr class="dataRow Qzone"',display,
		' onmouseOver="om(this,1,true);" onmouseOut="om(this,0,true);"><td class="dataCell partLabel tdRight">',
		map[i],'</td></tr>');
	}
	return temp.join('');
}
/*** make up row string for left table ***/
function getPartLeftString(display,type,rownum){
	var temp=[];
	if(type ===0){
		for(var i=0;i<rownum;i++){
			temp.push('<tr class="dataRow',i==rownum-1?'"':' noBorderTr"',display,
			'><td class="dataCell  tdTwo"><span class="iea">|</span></td><td class="dataCell"></td><td class="dataCell"></td><td class="dataCell"></td><td class="dataCell"></td></tr>' );
		}
	}else{
		for(var i=0;i<rownum;i++){
			temp.push('<tr class="dataRow" onmouseOver="om(this,1);" onmouseOut="om(this,0);"',display,
			'><td class="dataCell partLabel trleftBorder"><span class="iea">|</span></td><td class="dataCell partLabel"></td><td class="dataCell partLabel"></td><td class="dataCell partLabel"></td><td class="dataCell partLabel"></td></tr>');
		}
	}
	return temp.join('');
}
if(!window.showCurrency){
	window.showCurrency = function(){};
}

/////////
function markMc(el){
    el.addClass('mc');
}
function unmarkMc(el){
    el.removeClass('mc');
}

function setUpPartIdMap(){
	var isBu = isAppOrIndBu;
	if(isBu && (''+isBu).toLowerCase()=='true'){
	    var m = {};
	    $('#partIdInfo').children().each(function(idx){
	        m[$(this).text()] = idx;
	    });
	    map_PartIds = m;
   }else
   		map_PartIds = null;
}
function transPartDataMap(mapIdx){
	if(!mapIdx) return null;
	var m = map_partData;
	if(!m) return null;
	var id,i,j,tmp,result={};
	var fyear;
	for(id in m){
		tmp = m[id];
		for(i=0,j=tmp.length;i<j;i++){
			fyear = tmp[i]['fiscalYear'];
			if(!result[fyear])result[fyear] = {};
			result[fyear][mapIdx[id]] = {oldValue:tmp[i]['oldValue'],newValue:tmp[i]['newValue']}
		}
	}
	return result;
}
function transData2PartMap(mapData,recycle){
	var year,idx,tmp,
	mapIdxPart = {},
	mapPt2Idx = map_PartIds,//{pid1:0,pid1:1,...}
	id,
	map_parts = map_partData,
	data,i,j,tidx,isfound;
	if(mapPt2Idx){
		for(var f in mapPt2Idx){
			mapIdxPart[mapPt2Idx[f]] = f;
		}
		for(year in mapData){
			tmp = mapData[year];
			for(idx in tmp){
				
				tidx = idx/recycle - 1;
				
				id = mapIdxPart[tidx];
				
				data = map_parts[id];
				if(!data){
					map_parts[id] = [];
					data = map_parts[id];
				}
				isfound = false;
				for(i=0,j=data.length;i<j;i++){
					if(data[i]['fiscalYear']==year){
						data[i]['newValue'] = tmp[idx]['newValue'];
						data[i]['oldValue'] = tmp[idx]['oldValue'];
						isfound = true;
					}
				}
				if(!isfound){
					data.push({'fiscalYear':year,'newValue':tmp[idx]['newValue'],'oldValue':tmp[idx]['oldValue']});
				}
			}
		}
	}
}
function ov(tp,el,year,evt){
	if(tp!=1){
		return false;
	}
	var tip1 = tipBuPrev,tip2 = tipBuNew;
	if(!tip1)tip1 = 'Old: ';
	if(!tip2)tip2 = 'New: ';
	
		if(el.title) return;

		var elCls = el.className;
		if(elCls && elCls.indexOf('mc')>=0){
			var $span = $(el);//actually el is td now
			var partId,mapIdx = map_PartIds,recycle = getRecycle(),pos,row,oldVal,newVal;
			
			row = getParent(el,'TR');
			pos = $(row).prevAll().length;
			pos = (pos-1)/recycle-1;
			
			for(var id in mapIdx){
				if(mapIdx[id] == pos){
					partId = id;
					break;
				}
			}
			var str = '',data = map_partData;
			if(partId && data){
				if(partId in data){
					data = data[partId];
					for(var i=0,j=data.length;i<j;i++){
						if(data[i]['fiscalYear']==year){
							oldVal= data[i]['oldValue'],newVal=data[i]['newValue'];
							oldVal = Math.round(oldVal*100)/100;
							if(oldVal > 10000)
							oldVal = roundToKM(oldVal);
							else
							oldVal = showFormat(oldVal);

							newVal = Math.round(newVal*100)/100;
							if(newVal > 10000)
							newVal = roundToKM(newVal);
							else
							newVal = showFormat(newVal);

							if(str) str += '\r\n';
							if(map_OldValue[partId+'_'+data[i]['fiscalYear']]){
								str+= tip1+ ' ' + oldVal;
							}
							//str += '\r\n' + tip2+ ' ' + newVal;
						}
					}
					el.title = str;
				}
			}
		}
/*
	var tip1 = tipBuPrev,tip2 = tipBuNew;
	if(!tip1)tip1 = 'Old: ';
	if(!tip2)tip2 = 'New: ';
	if(tp!=1){
		$('#tipBox').addClass('hide');
		return false;
	}else{
		var elCls = el.className;
		if(elCls && elCls.indexOf('mc')>=0){
			var $span = $(el);
			var box = $('#tipBox');
			if($span.next('#tipBox').length == 0 || box.hasClass('hide')){
				var partId,mapIdx = map_PartIds,recycle = getRecycle(),pos,row,oldVal,newVal;
				
				row = getParent(el,'TR');
				pos = $(row).prevAll().length;
				pos = (pos-1)/recycle-1;
				
				for(var id in mapIdx){
					if(mapIdx[id] == pos){
						partId = id;
						break;
					}
				}
				var str = '',data = map_partData;
				if(partId && data){
					if(partId in data){
						data = data[partId];
						for(var i=0,j=data.length;i<j;i++){
							if(data[i]['fiscalYear']==year){
								oldVal= data[i]['oldValue'],newVal=data[i]['newValue'];
								oldVal = Math.round(oldVal*100)/100;
								if(oldVal > 10000)
								oldVal = roundToKM(oldVal);
								else
								oldVal = showFormat(oldVal);

								newVal = Math.round(newVal*100)/100;
								if(newVal > 10000)
								newVal = roundToKM(newVal);
								else
								newVal = showFormat(newVal);
								//str += '<div>'+tip1+'</div><div class="tnum">'+showFormat(data[i]['oldValue'])+'</div>'
								//+'<div>'+tip2+'</div><div class="tnum">'+showFormat(data[i]['newValue'])+'</div>';			
								//str+= tip1+ oldVal+' '+tip2+newVal;
								str+= '<div>' + tip1+ ' ' + oldVal + '</div><div>' + tip2+ ' ' + newVal + '</div>';
							}
						}
						$span.next().append(box.html(str).removeClass('hide'));
						
					}
				}
			}
		}
	}
	*/
}
function initialTipBox(){
	$('body').append($('#tipBox'));//.appendTo();
}
function setupBuMap(){   
	var map_data = $('#buDataInfo').children('input').val();
	map_OldValue = {};
    if(map_data){
        map_data = $.parseJSON(map_data);
        for(var k in map_data){
        	if(!k) delete map_data[k];
        }
        map_partData = map_data;
    }else map_partData = {};
   var d;
   for(var k in map_data){
   	d =  map_data[k];
   	for(var i=0;i<d.length;i++){
   		if(typeof d[i]['oldValue'] != 'undefined'){
   			map_OldValue[k+'_'+d[i]['fiscalYear']] = true;
   		}
   	}
   }
}

//////

function closePopUp(){
    popRemove();
}
function onConfidenceSelect(){//example: ('de','BOM')
    findConfidences();
    tp(false,false,false);
}
var gpNubr = -1;
function makeGroups(){
    var j = gSaveStrs.length,
        limit = 3000;
    if(j == 1) return 1;
    var t,l=gSaveStrs[0].data.length;
    for(var i=1; i<=j; i++){
            t = j%i;
            if(t > 0)
            t = (j+i-t)/i;
            else 
            t = j/i;
            if(t*l <limit)
            break;
        }
    return t;    
}
function doSave(){
//alert("0 - "+ document.getElementById("j_id0:oppyPB:j_id52:j_id86:0:statusTAMchk").checked);
//alert("1 - "+ document.getElementById("j_id0:oppyPB:j_id52:j_id86:0:statusSSPerc").value);

	var isAppBu = isAppOrIndBu;
		isAppBu = (''+isAppBu).toLowerCase() == 'true'? true:false;
	setReason();
	if(isAppBu)
	clsSave();
    var i,j,k,isEnd,hasData,hasStr,buData = map_partData,bu2Save = {},fyear,partId,ary,w,z;
    
    if(!gSaveStrs){
        showLoad();
        setTimeout(function(){hideLoad()},200);
        return false;
    }else if(gSaveStrs.length ==0){
        gSaveStrs = false;
        saveForecasts('Completed');
    }else{
        if(gpNubr < 0){
            gpNubr = makeGroups();
        }
        
        k = [],
        isEnd = hasData = hasStr = false;
        for(i=0,j=gSaveStrs.length; i<j; i++){
            fyear = gSaveStrs[i].year;
            if(fyear && !isNaN(parseInt(fyear,10))){
                hasData = true;
                break;
            }
        }
        if(!hasData){
            gSaveStrs = false;
            saveForecasts('Completed');
        }else{
            var str = '',aryItm,range4 = range4Mark;
            for(var t = 0; t < gpNubr; t ++){
                 if(i+t < j){
                     fyear = gSaveStrs[i+t].year;
                     fyear = fyear.replace(/\D/g,'');
                     
                     gSaveStrs[i+t].year = false;
                     if(t ==0){
                         str += gSaveStrs[i+t].data.join('#');
                     }else{
                         str += '@@' + gSaveStrs[i+t].data.join('#');
                     }
                     if(i+t+1 == j){
                         str+= '@@Completed';
                         isEnd = true;
                     }
                     hasStr = true;
                     if(isAppBu){
                     	for(partId in buData){
	                         ary = buData[partId];
	                         
	                         for(w=0,z=ary.length;w<z;w++){
	                         	aryItm = ary[w];
	           				 	if(aryItm['fiscalYear']==fyear){
	           				 		aryItm['newValue'] = Math.round(aryItm['newValue'] * 1000) / 1000;
	   				 				if(!(partId in bu2Save)){
	   				 					bu2Save[partId] = [];
	   				 				}
	       				 			bu2Save[partId].push(aryItm);
	           				 	}
	                         }
	                     }

                     }
                     
                 } 
            }
            
                    
            if(hasStr){
            	if(isAppBu){
            		bu2Save = JSON.stringify(bu2Save);
                	$('#buDataInfo').children('input').val(bu2Save);
            	}else{
            		$('#buDataInfo').children('input').val('');
            	}
                saveForecasts(str);
                str = null;
            }else{
                gSaveStrs = false;//
                saveForecasts('Completed');
            } 
        }
    }
}
function checkGSaveStrs(){//if data available,return true
 if(!gSaveStrs) return false;
    var isErr = $(document.getElementById('isError')).children('input').val();
    var errMsg = ''+$(document.getElementById('errorMsg')).children().text();
    if(errMsg.length>0||isErr == 'true'){
        return false;
    }
    var result = false,flag=0;      
    for(var i=0,j=gSaveStrs.length; i<j; i++){
        if(gSaveStrs[i].year && !isNaN(parseInt(gSaveStrs[i].year,10))){
            result = true;
            break;
        }
        else{
            gSaveStrs[i].data = null;
        }
    }
    if(result === false||gSaveStrs.length ==0){
        gSaveStrs = null;
        result = false;
    }
    return result;
}
function confirmSave(){
	var isBu = isAppOrIndBu;
	if(isBu && isBu.toLowerCase()=='true' && isBUEdited){
		$('#popCmt').removeClass('hide');
		$('#popCtn').removeClass('hide');
	}else{
		doSave();
	}
}
function cancelSave(){
	clsSave();
}
function clsSave(){
	$('#popCmt').addClass('hide');
	$('#popCtn').addClass('hide');
}
function setReason(){
	$('#reasonInfo').children('input').val($('#pickReason').children('select').val());
}
function initReasonSel(){
	var opts = $.parseJSON(reason_options),str='<select>';
	for(var i=0,j=opts.length;i<j;i++){
		if($.trim(opts[i]) != '')
		str += '<option value="'+opts[i]+'">'+opts[i]+'</option>';
	}
	str = str + '</select>';
	$('#pickReason').html(str);
}