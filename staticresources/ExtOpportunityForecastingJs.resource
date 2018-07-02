function showLoading(){
	document.getElementById('loading').style.display = 'block';
}

function hideLoading(){
	document.getElementById('loading').style.display = 'none';
}

$(document).ready(function() {
	addCommaSeparatorForEachLine();
});

function makeActiveInputFocus(next_td, current_tr_index, current_td_index, isSelectFocus){
	/**
	 * If the select should be focus, next td still be current td, iterate children of the current td and focus the select
	 * Else, next td is next td, iterate children of the next td and focus the input
	 * */
	var focusEleParentTd = getParentTdElement($("*:focus"));
	if(next_td && next_td[0] && next_td[0].childNodes){
		for(var i=0,len=next_td[0].childNodes.length; i<len; i++){
			console.log('i:::'+i);
			console.log('---next_td[0].childNodes[i]:::');
			console.log(next_td[0].childNodes[i]);
			if(isSelectFocus){
				if(next_td[0].childNodes[i] && next_td[0].childNodes[i].nodeName.toUpperCase() == "SPAN"){
					for(var j=0,len2=next_td[0].childNodes[i].childNodes.length; j<len2; j++){
						if(next_td[0].childNodes[i].childNodes[j].nodeName.toUpperCase() == 'SELECT'){
							if(next_td[0].childNodes[i].childNodes[j].disabled){
								current_tr_index++;
								focusEleParentTd = getParentTdElement($("*:focus"));
								next_td = $($($(focusEleParentTd).parent().siblings("tr"))[current_tr_index]).find("td").eq(current_td_index);
								makeActiveInputFocus(next_td, current_tr_index, current_td_index, false);
							}else{
								next_td[0].childNodes[i].childNodes[j].focus();
								break;
							}
						}
					}
				}
			}else{
				if(next_td[0].childNodes[i] && next_td[0].childNodes[i].nodeName.toUpperCase() == "INPUT"){
					if(next_td[0].childNodes[i].disabled){
						console.log('next_td[0].childNodes[i].disabled---'+next_td[0].childNodes[i].disabled);
						current_tr_index++;
						focusEleParentTd = getParentTdElement($("*:focus"));
						next_td = $($($(focusEleParentTd).parent().siblings("tr"))[current_tr_index]).find("td").eq(current_td_index);
						console.log('---2');
						console.log('current_tr_index---'+current_tr_index);
						console.log('current_td_index---'+current_td_index);
						console.log(next_td);
						makeActiveInputFocus(next_td, current_tr_index, current_td_index, false);
					}else{
						next_td[0].childNodes[i].focus();
						break;
					}
				}
			}
		}
	}else{
		focusEleParentTd = getParentTdElement($("*:focus"));
		current_tr_index = $(focusEleParentTd).parent().siblings().has("input").first().index();
		current_td_index++;
		next_td = $($($(focusEleParentTd).parent().siblings("tr"))[current_tr_index]).find("td").eq(current_td_index);
		if(next_td.length > 0){
			makeActiveInputFocus(next_td, current_tr_index, current_td_index,isSelectFocus);
		}

	}
}

function getParentTdElement($_currentEle){
	var focusElementParent = $_currentEle.parent();
	while(focusElementParent.get(0) && focusElementParent.get(0).nodeName != 'TD'){
		focusElementParent = getParentTdElement($(focusElementParent));
	}
	return focusElementParent;
}

$(document).keydown(function(e){
	if (e && e.keyCode == 9){
		var focusEleParentTd = getParentTdElement($("*:focus"));
		var focusSelect,
			current_focus_td_index,
			current_focus_tr_index,
			next_focus_td;
		/**
		 * Condition: If current td element has child input and child select, the current target nodeName is the child input,
		 * Result: the next focus should on child select, the next focus td should still be the current td element
		 * */
		if(e.target.nodeName.toUpperCase() == "INPUT"
		&& $(focusEleParentTd).html().indexOf("</select>") != -1){
				current_focus_td_index = $(focusEleParentTd).parent("tr:first").find("td").index($(focusEleParentTd));
				console.log('---current_focus_td_index---' + current_focus_td_index);
				current_focus_tr_index = $(focusEleParentTd).parent().index();
				console.log('---current_focus_tr_index---' + current_focus_tr_index);
				next_focus_td = focusEleParentTd;
				console.log('---1');
				console.log(next_focus_td);
				focusSelect = true;
		/**
		 * Condition: If current td element only has child input and the current target nodeName is the child input,
		 * Result: the next focus td should be the next td
		 * Condition: If current target nodeName is the child select,
		 * Result: the next focus td should be the next td
		 * */
		}else if((e.target.nodeName.toUpperCase() == "INPUT" && $(focusEleParentTd).html().indexOf("</select>") == -1)
				|| e.target.nodeName.toUpperCase() == "SELECT"){
			current_focus_td_index = $(focusEleParentTd).parent("tr:first").find("td").index($(focusEleParentTd));
			//console.log('---current_focus_td_index---' + current_focus_td_index);
			current_focus_tr_index = $(focusEleParentTd).parent().index();
			//console.log('---current_focus_tr_index---' + current_focus_tr_index);
			next_focus_td = $($($(focusEleParentTd).parent().siblings("tr"))[current_focus_tr_index]).find("td").eq(current_focus_td_index);
			console.log('---1');
			console.log(next_focus_td);
			focusSelect = false;
		}
		makeActiveInputFocus(next_focus_td, current_focus_tr_index, current_focus_td_index, focusSelect);
		return false;
	}
});
//========================================================================================================
function changeYearlyTotal(ele_Yearly){
	if(!inputValidator(ele_Yearly)) {
		return;
	}
	var thisYear = ele_Yearly.getAttribute('year');
	//var thisYearValue = parseInt(ele_Yearly.value);
	var thisYearValue = parseInt(convertIntoNumber(ele_Yearly.value));
	var allQuartersElementsOfThisYear = $("input[year='"+ thisYear +"'][class*='Total_Quarterly']");
	var allMonthsElementsOfThisYear = $("input[year='"+ thisYear +"'][class*='Total_Monthly']");
	var eachQuarterValue = thisYearValue / allQuartersElementsOfThisYear.length;
	var fixedYearlyTotal = eachQuarterValue.toFixed(0) * allQuartersElementsOfThisYear.length;
	allQuartersElementsOfThisYear.each(function(index){ 
		$(this).css('border-color','');
		$(this).css('box-shadow','');
		if(this.getAttribute('isAllowEdit') == 'true'){		
			this.value = eachQuarterValue.toFixed(0);
			if(fixedYearlyTotal != thisYearValue && index == (allQuartersElementsOfThisYear.length-1)){
				this.value = parseInt(this.value) + thisYearValue - fixedYearlyTotal;	
			}
			var thisYear = this.getAttribute('year');
			var thisQuarter = this.getAttribute('quarter');
			var thisQuarterValue = parseInt(this.value);
			var fixedQuarterlyTotal = parseInt((thisQuarterValue * 5/13).toFixed(0)) + parseInt((thisQuarterValue * 4/13).toFixed(0)) + parseInt((thisQuarterValue * 4/13).toFixed(0));
			var allMonthsElementsOfThisQuarter = $("input[quarter='"+ thisQuarter +"'][year='"+ thisYear +"'][class*='Total_Monthly']");
			this.value = convertIntoComma(this.value);
			allMonthsElementsOfThisQuarter.each(function(index){
				if(this.getAttribute('isAllowEdit') == 'true'){
					$(this).css('border-color','');
					$(this).css('box-shadow','');
					this.value = (index % 3 == 1)? (thisQuarterValue * 5/13).toFixed(0) : (thisQuarterValue * 4/13).toFixed(0);
					if(fixedQuarterlyTotal != thisQuarterValue.value && index == (allMonthsElementsOfThisQuarter.length-1)){
						this.value = parseInt(this.value) + thisQuarterValue - fixedQuarterlyTotal;
					}
					this.value = convertIntoComma(this.value);
				}
			});
		}
	});
}

function changeQuarterlyTotal(ele_Quarterly){
	if(!inputValidator(ele_Quarterly)) {
		return;
	}
	var thisYear = ele_Quarterly.getAttribute('year');
	var thisQuarter = ele_Quarterly.getAttribute('quarter');
	var allMonthsElementsOfThisQuarter = $("input[quarter='"+ thisQuarter +"'][year='"+ thisYear +"'][class*='Total_Monthly']");
	var thisYearElement = document.getElementById(thisYear);
	var allQuartersElementsOfThisYear = $("input[year='"+ thisYear +"'][class*='Total_Quarterly']");
	var tempTotalValueOfthisYearElement = 0;
	var fixedQuarterlyTotal = parseInt((convertIntoNumber(ele_Quarterly.value) * 5/13).toFixed(0)) + parseInt((convertIntoNumber(ele_Quarterly.value) * 4/13).toFixed(0)) + parseInt((convertIntoNumber(ele_Quarterly.value) * 4/13).toFixed(0));
	var isAllMonthValid = true;
	var isAllQuarterValid = true;
	
	allMonthsElementsOfThisQuarter.each(function(index){
		$(this).css('border-color','');
		$(this).css('box-shadow','');
		if(this.getAttribute('isAllowEdit') == 'true'){
			this.value = (index % 3 == 1)? (convertIntoNumber(ele_Quarterly.value) * 5/13).toFixed(0) : (convertIntoNumber(ele_Quarterly.value) * 4/13).toFixed(0);
			if(fixedQuarterlyTotal != convertIntoNumber(ele_Quarterly.value) && index == (allMonthsElementsOfThisQuarter.length-1)){
				this.value = parseInt(this.value) + parseInt(convertIntoNumber(ele_Quarterly.value)) - parseInt(fixedQuarterlyTotal);
			}
			this.value = convertIntoComma(this.value);
		}
	});
	
	allQuartersElementsOfThisYear.each(function(){
		if(this.value != '' && isNaN(convertIntoNumber(this.value))) {
			isAllQuarterValid = false;
		}
		if(this.value != null && this.value.trim() != ''){
			tempTotalValueOfthisYearElement += parseFloat(convertIntoNumber(this.value));
		}
	});
	
	//thisYearElement.value = tempTotalValueOfthisYearElement.toFixed(0);
	if(isAllQuarterValid && isAllMonthValid) {
		$(thisYearElement).css('border-color','');
		$(thisYearElement).css('box-shadow','');
		thisYearElement.value = convertIntoComma(tempTotalValueOfthisYearElement.toFixed(0));
	}
}

function changeMonthlyTotal(ele_Monthly){
	if(!inputValidator(ele_Monthly)) {
		return;
	}
	var thisYear = ele_Monthly.getAttribute('year');
	var thisQuarter = ele_Monthly.getAttribute('quarter');
	var quarterElementId = thisYear+ "_" + thisQuarter;

	var thisYearElement = document.getElementById(thisYear);
	var allMonthsElementsOfThisQuarterAndYear = $("input[quarter='"+ thisQuarter +"'][year='"+ thisYear +"'][class*='Total_Monthly']");
	var thisQuarterElementOfThisYear = document.getElementById(quarterElementId);
	var allQuartersElementsOfThisYear = $("input[year='"+ thisYear +"'][class*='Total_Quarterly']");
	var tempTotalValueOfThisQuarter = 0;
	var tempTotalValueOfthisYearElement = 0;
	var isAllMonthValid = true;
	var isAllQuarterValid = true;
	
	allMonthsElementsOfThisQuarterAndYear.each(function(){
		if(this.value != '' && isNaN(convertIntoNumber(this.value))) {
			isAllMonthValid = false;
		}
		if(this.value != null && this.value.trim() != ''){
			var currValue = convertIntoNumber(this.value);
			console.log('AAA::::  ', currValue);
			tempTotalValueOfThisQuarter += parseFloat(convertIntoNumber(this.value));
		}
	});
	if(isAllMonthValid) {
		$(thisQuarterElementOfThisYear).css('border-color','');
		$(thisQuarterElementOfThisYear).css('box-shadow','');
		thisQuarterElementOfThisYear.value = convertIntoComma(tempTotalValueOfThisQuarter.toFixed(0));
	}
	
	allQuartersElementsOfThisYear.each(function(){
		if(this.value != '' && isNaN(convertIntoNumber(this.value))) {
			isAllQuarterValid = false;
		}
		if(this.value != null && this.value.trim() != ''){
			tempTotalValueOfthisYearElement += parseFloat(convertIntoNumber(this.value));
		}
	});
	if(isAllQuarterValid && isAllMonthValid) {
		$(thisYearElement).css('border-color','');
		$(thisYearElement).css('box-shadow','');
		thisYearElement.value = convertIntoComma(tempTotalValueOfthisYearElement.toFixed(0));
	}
} 

function openEditMode(){
	$("*[id*='showMsg']").hide();
	$("#theTable").attr("mode","edit");
	$("#btn_UseOppyProbability").show();
	$(".btn_Edit").hide();
	$(".btn_Save").show();
	$("#btn_Cancel").show();
	$("input[isAllowEdit='true'],select[isAllowEdit='true']").removeAttr("disabled");
	$("input[isAllowEdit='false'],select[isAllowEdit='false']").css("background","#0066A1").attr("title","You can not edit it.");
	$("input[isAllowEdit='true'],select").show();
	$('.number_nocommas_class').show();
	$('.number_commas_class').hide();
}

function openViewMode(){
	$("#theTable").attr("mode","view");
	$("#btn_UseOppyProbability").hide();
	$(".btn_Edit").show();
	$(".btn_Save").hide();
	$("#btn_Cancel").hide();
	addCommaSeparatorForEachLine();
}

function useOppyProbability(){
	
	console.log('oppyProbability:::' + oppyProbability);
	$(".Select_Monthly, .Select_Quarterly, .Select_Yearly").each(function(){
		$(this).val(oppyProbability);
	});
	$(".Select_Monthly, .Select_Quarterly, .Select_Yearly").each(function(){
		console.log($(this).val());
	});
}

function saveOppyForecasts(){
	if(!checkAllValidator()) return;
	var array_OppyForecastObjs = [];
	$("input[isAllowEdit='true'][class*='Total_Monthly']").each(function(){
		var year = $(this).attr('year'),
			quarter = $(this).attr('quarter'),
			month = $(this).attr('monthNum');
		console.log(this.value);
		var oppyForecastObj = {
				YearName : year,
				QuarterName : quarter,
				MonthNumber : month,
				MonthlyForecastAmount : (this.value)? convertIntoNumber(this.value) : null,
				ConfidenceLevel : $("select[year='"+ year +"'][quarter='"+ quarter +"'][monthNum='"+ month +"']").val(),
				OppyForeCastId : $(this).attr('oppyForecastId')
		};
		array_OppyForecastObjs.push(oppyForecastObj);
	});
	
	saveOppyForecastsToDatabase(JSON.stringify(array_OppyForecastObjs));
}

function refreshOppyPage(){
	var isRefresh = $("*[id*='theHiddenInput']").val();
	console.log('---isRefresh:::' + isRefresh);
	if(isRefresh === 'true'){
		parent.location.href='/'+ currentOpportunityId;		
	}
}

function changeTotalQuarterPercent(currElement,str_year,str_quarter){
	var currValue = $(currElement).val();
	console.log('before:::'+currValue);
	if(currValue.trim() == ''){return false;}
	console.log('after:::'+currValue);
	console.log('changeTotalQuarterPercent::year::quarter::value:',str_year,str_quarter,currValue);
	$("select[year='"+ str_year +"'][quarter='"+ str_quarter +"']").each(function(){
		console.log($(this));
		$(this).val(currValue);
		var ops = $(this).find('option');
		for(var i = 0; i<ops.length; i++){
			console.log(ops[i]);
			if($(ops[i]).val() == currValue){
				$(ops[i]).attr('selected','selected');
			}else{
				$(ops[i]).removeAttr('selected');
			}
		}
	});
}

function changeTotalYearPercent(currElement,str_year){
	var currValue = $(currElement).val();
	console.log('before:::'+currValue);
	if(currValue.trim() == ''){return false;}
	console.log('after:::'+currValue);
	console.log('changeTotalYearPercent::year::value:',str_year,currValue);
	$("select[year='"+ str_year +"']").each(function(){
		console.log($(this));
		$(this).val(currValue);
		var ops = $(this).find('option');
		for(var i = 0; i < ops.length; i++){
			console.log(ops[i]);
			if($(ops[i]).val() == currValue){
				$(ops[i]).attr('selected','selected');
			}else{
				$(ops[i]).removeAttr('selected');
			}
		}
	});
}

function addNumFormat(currObj) {
	if($(currObj).val() != '') {
		if(!isNaN(convertIntoNumber($(currObj).val()))){
			if(!isNaN(Number($(currObj).val()))) {
				var span_total = convertIntoComma(Number($(currObj).val()));
				$(currObj).val(span_total);
			}
		}
	}
}

function removeNumFormat(currObj) {
	if($(currObj).val() != '') {
		if(!isNaN(convertIntoNumber($(currObj).val()))) {
			$(currObj).val(convertIntoNumber($(currObj).val()));
		};
	}
}

function addCommaSeparatorForEachLine(){
	$(".number_commas_class").each(function() {
		var input_total = $(this).text();
		if(input_total != '') {
	        var span_total = convertIntoComma(Math.round(Number(input_total)));
			$(this).text(span_total);
		}
	})
	$(".number_nocommas_class").each(function() {
		var input_total = $(this).val();
		if(input_total != '') {
	        var span_total = convertIntoComma(Math.round(Number(input_total)));
			$(this).val(span_total);
		}
	})
}

function toThousands(num) {
	if(thousandSep == null || thousandSep == ''){
		thousandSep = ',';
	}
    var num = (num || 0).toString(), result = '';
    while (num.length > 3) {
        result = thousandSep + num.slice(-3) + result;
        num = num.slice(0, num.length - 3);
    }
    if (num) { result = num + result; }
    return result;
}

function getDecimal(num) {
	if(decimalSep == null || decimalSep == ''){
		decimalSep = '.';
	}
    var result = '';
    num = ''+num;
    if(num.indexOf('.') > -1){
    	var b = num.split(".");
		result = decimalSep + b[1];
		if(b[1].length == 1){
			result = result + '0';
		}
    }else{
    	result = decimalSep + '00';
    }
    return result;
}

function convertIntoComma(num){
	//1234.56 --> 1,234.56
	var result = '';
	int_num = parseInt(Number(num));
	
	if(isNaN(num)) {
		result = num;
	} else {
		result = '' + toThousands(int_num);
	}
	return result;
}

function convertIntoNumber(str){
	//1,234.56 --> 1234.56
	var result = '';
	
	if(str != null && str != ''){
		str = trimForNumber(str);
		if(str.indexOf(thousandSep) > -1 || str.indexOf(decimalSep) > -1){
			if(decimalSep == '.'){
				if(str.indexOf(decimalSep) > -1){
					//have decimal dot
					if(str.indexOf(thousandSep) > -1){
						//have thousand comma
						var isValidNumber = /^(-)?\d{1,3}(,\d{3})*(.\d+)?$/.test(String(str));
						if(isValidNumber){
							result = str.replace(/,/g, '');
						}else{
							result = 'error';
						}
					}else{
						//no thousand comma
						result = str;
					}
				}else{
					//no decimal dot
					if(str.indexOf(thousandSep) > -1){
						//have thousand comma
						var isValidNumber = /^(-)?\d{1,3}(,\d{3})*(.\d+)?$/.test(String(str));
						if(isValidNumber){
							result = str.replace(/,/g, '');
						}else{
							result = 'error';
						}
					}else{
						//no thousand comma
						result = str;
					}
				}
				result = Number(result);
			}else{
				if(str.indexOf(decimalSep) > -1){
					//have decimal comma
					if(str.indexOf(thousandSep) > -1){
						//have thousand dot
						var isValidNumber = /^(-)?\d{1,3}(.\d{3})*(,\d+)?$/.test(String(str));
						if(isValidNumber){
							result = str.replace(/\./g, '');
							result = result.replace(/,/g, '.');
						}else{
							result = 'error';
						}
					}else{
						//no thousand dot
						result = str.replace(/,/g, '.');
					}
				}else{
					//no decimal comma
					if(str.indexOf(thousandSep) > -1){
						//have thousand dot
						var isValidNumber = /^(-)?\d{1,3}(.\d{3})*(,\d+)?$/.test(String(str));
						if(isValidNumber){
							result = str.replace(/\./g, '');
						}else{
							result = 'error';
						}
					}else{
						//no thousand dot
						result = str;
					}
				}
				result = Number(result);
			}
		}else{
			//no comma,dot number.
			result = Number(str);
		}
	}else{
		result = 0;
	}
	return result;
}

//remove dot,comma,space at string's start and end.
function trimForNumber(str){
	str = str.toString().replace(/\s/g, '');
	while (str.charAt(0) == '.' || str.charAt(0) == ',' || str.charAt(0) == ' ') {
		str = str.substring(1);
	}
	while (str.charAt(str.length-1) == '.' || str.charAt(str.length-1) == ',' || str.charAt(str.length-1) == ' ') {
		str = str.substring(0,str.length-1);
	}
	return str;
}

function inputValidator(htmlObj){
	var isValid = true;
	var input = $(htmlObj);
	if(input.val() != '') {
		if(isNaN(convertIntoNumber(input.val()))){
			input.css('border-color','red');
			input.css('box-shadow','0 0 3px red');
			alert('Please enter a correct number!');
			isValid = false;
		}else{
			input.css('border-color','');
			input.css('box-shadow','');
			$(htmlObj).val(convertIntoNumber(input.val()).toFixed(0));
		}
	}
	return isValid;
}

function checkAllValidator(){
	var result = true;
	$("input[isAllowEdit='true'][class*='Total_Monthly']").each(function(){
		var input = $(this);
		if(isNaN(convertIntoNumber(input.val()))){
			result = false;
			input.css('border-color','red');
			input.css('box-shadow','0 0 3px red');
		}else{
			input.css('border-color','');
			input.css('box-shadow','');
		}
	});
	if(!result){
		alert('Please enter a correct number!');
	}
	return result;
}