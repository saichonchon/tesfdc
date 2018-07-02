function showLoading(){
	$("#Loading_Panel").show();
}

function hideLoading(){
	$("#Loading_Panel").hide();
}

function slideDownRelatedDetailedRow(downArrowEle){
	var $downArrowEle = $(downArrowEle);
	$downArrowEle.hide();
	var probability = $downArrowEle.attr('probability');
	$("img[probability='"+ probability +"'][class*='arrowUp']").show();
	$("."+ probability + 'detailRowStyle').show();
}

function changeSelectedSalesHierarchy(){
	showLoading();
	var selectOption = $("#territory option:selected");
	$("#territory option[value=' ']").remove();
	getMonthlyOppyForecast(selectOption.text().trim(), selectOption.val());
}

function slideUpRelatedDetailedRow(upArrowEle){
	var $upArrowEle = $(upArrowEle);
	$upArrowEle.hide();
	var probability = $upArrowEle.attr('probability');
	$("img[probability='"+ probability +"'][class*='arrowDown']").show();
	$("."+ probability + 'detailRowStyle').hide();
}

function monthSelectChange(){
	showLoading();
	//alert('aaa');
	var selectedMonth = $('#select_month').val();
	var selectOption = $("#territory option:selected");
	$("input[id*='hidden_param_selectMonthValue']").val(selectedMonth);
	getMonthlyOppyForecast(selectOption.text().trim(), selectOption.val());
}

function SaveTotalForecast(){
	showLoading();
	var selectedMonth = $('#select_month').val();
	$("input[id*='hidden_param_selectMonthValue']").val(selectedMonth);
	var enteredValue = $('#input_totalForecast').val();
	$("input[id*='hidden_param_forecastInputValue']").val(enteredValue);
	saveModifiedOppyForecastValue();
	saveInputValue();
}

function makeChangedFlag(ele){
	$(ele).attr('isChanged','true');
	var confidenceLevel = $(ele).attr("probability");
	var totalValue = 0;
	console.log($(".detailMonthlyForecast[probability='"+ confidenceLevel+"']"));
	$(".detailMonthlyForecast[probability='"+ confidenceLevel+"']").each(function(){
		console.log($(this));
		totalValue += parseInt($(this).val());
	});
	console.log("totalValue::::  ", totalValue);
	//var currentElementValue = $(ele).val().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,");
	//$(ele).val(currentElementValue);
	$(".totalMonthlyForecast[probability='"+ confidenceLevel+"']").html((totalValue*(confidenceLevel/100)).toFixed(0).replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"));
}

function saveModifiedOppyForecastValue(){
	var array_MonthlyOppyForecasts = [];
	$(".editable_input[isChanged='true']").each(function(){
		var monthlyForecast = {
			oppForId : $(this).attr("oppyForecastId"),
			FcValue : $(this).val()
		};
		array_MonthlyOppyForecasts.push(monthlyForecast);
	});
	console.log(array_MonthlyOppyForecasts);
	console.log(array_MonthlyOppyForecasts.length);
	if(array_MonthlyOppyForecasts.length > 0){
		var str_MonthlyOppyForecasts = JSON.stringify(array_MonthlyOppyForecasts);
		console.log('---');
		saveOppyForecastsValue(str_MonthlyOppyForecasts);
	}
}

function refresh(){
	monthSelectChange();
}

function delayDOMrefresh(){
	var t = setTimeout("setSelectValue()",100);
}

function setSelectValue(){
	var selectedMonth = $('#select_month').attr('value');
	console.log('selectedMonth::',selectedMonth);
	$("#select_month option").each(function(){
		if($(this).val() == selectedMonth){
			$(this).attr("selected","selected");
		}else{
			$(this).removeAttr("selected");
		}
	});
	hideLoading();
	formatForecastValue();
}

function formatForecastValue(){
	var formatValue = $('#input_totalForecast').val().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,");
	$('#input_totalForecast').val(formatValue);
	/*$(".totalMonthlyForecast").each(function(){
		var formatOppyForecastValue = $(this).val().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,");
		$(this).val(formatOppyForecastValue);
	});*/
}

$(function(){
	formatForecastValue();

})	

function inputFcValue(obj) {
	$(obj).css("display","none");
	$(obj).prev().css("display","block");
}