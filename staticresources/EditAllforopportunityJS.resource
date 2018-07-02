
    function hideNoUseStatus(){
    	$(".selectStatus select option").each(function(content){
			if(($(this).html() != 'Won'&& $(this).html() != 'Lost' && $(this).html() != 'No Bid' && $(this).html() != 'Pending')){
				$(this).css("display","none");
				$(this).remove();
			}
 		})
    }
    function clickSearch(){
    	$("input[id*='btnGo3']").click();
    }
    function sendExcelByGplCode(){
        var gplCode = $("input[id *= 'gplCode']").val();
        window.open('/apex/DownloadOpportunityParts?OppId='+oppId+'&GPL='+ gplCode); 
    }
    function sendExcelByGplDescrip(){
        var gplDescrip = $("input[id *= 'gplDescrip']").val();
        window.open('/apex/DownloadOpportunityParts?OppId='+oppId+'&GPLDes=' +gplDescrip); 
    }
    function basicPopup(pid) {
    	//popupWindow = window.open('/apex/SalesHistory?id='+pid,'popUpWindow','height=400,width=900,left=10,top=25,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no, status=yes');
        popupWindow = window.open('/apex/SalesHistory?id='+pid,'Sales History');
    }
    function autoResizeTable(){
		var curr_pageWidth = $('#AppBodyHeader').width();
		//var sideBarWidth = $('#sidebarCell').outerWidth();
		var sideBarWidth = 26;
		var rightWidth = curr_pageWidth - sideBarWidth - 20;
		$("#wrapper").css('width',rightWidth);
		$("#wrapper").css('max-width',rightWidth);
		$(window).resize(function() {
			var curr_pageWidth = $('#AppBodyHeader').width();
			//var sideBarWidth = $('#sidebarCell').outerWidth();
			var sideBarWidth = 26;
			var rightWidth = curr_pageWidth - sideBarWidth - 20;
			$("#wrapper").css('width',rightWidth);
			$("#wrapper").css('max-width',rightWidth);
			alignLeftAndRight();
		});
		
		alignLeftAndRight();
	}
	
	function alignLeftAndRight(){
		var trs_left = $("#table_left tr");
		var trs_right = $("#table_right tr");
		var array_rightTableLineHeight = new Array();
		for(var i=0;i<trs_right.length;i++){
			//console.log('rightTableLineHeight::'+i+'::',$(trs_right[i]).children()[0].offsetHeight);
			array_rightTableLineHeight.push($(trs_right[i]).children()[0].offsetHeight);
		}
		if(trs_left.length == array_rightTableLineHeight.length){
			for(var i=0;i<array_rightTableLineHeight.length;i++){
				$(trs_left[i]).height(array_rightTableLineHeight[i]);
				//console.log('leftLineHeight::'+i+'::',$(trs_left[i]).height());
			}
		}
		var array_leftTableLineHeight = new Array();
		for(var i=0;i<trs_left.length;i++){
			//console.log('leftTableLineHeight::'+i+'::',$(trs_left[i]).children()[0].offsetHeight);
			array_leftTableLineHeight.push($(trs_left[i]).children()[0].offsetHeight);
		}
		if(trs_right.length == array_leftTableLineHeight.length){
			for(var i=0;i<array_leftTableLineHeight.length;i++){
				$(trs_right[i]).height(array_leftTableLineHeight[i]);
				//console.log('rightLineHeight::'+i+'::',$(trs_right[i]).height());
			}
		}
		
		//Added by Buwen Guo 2018-05-02 from email:Functional Testing Issues - 5/1
		var width_left_div = $("#left").width();
		var width_left_table = $("#table_left").width();
		console.log('width_left_div:::'+width_left_div);
		console.log('width_left_table:::'+width_left_table);
		if(width_left_div < width_left_table){
			var total_width = Math.ceil(width_left_div/0.3);
			var width_right_virtual = total_width*0.7;
			var width_right_actual = width_right_virtual - (width_left_table - width_left_div);
			var percent_right = Math.floor((width_right_actual/total_width)*100);
			console.log('percent_right:::'+percent_right);
			$("#left").css('min-width',width_left_table + 'px');
			$("#right").css('width',percent_right + '%');
		}else{
			$("#left").css('min-width','');
			$("#right").css('width','');
			var width_left_div = $("#left").width();
			var width_left_table = $("#table_left").width();
			console.log('width_left_div2:::'+width_left_div);
			console.log('width_left_table2:::'+width_left_table);
			if(width_left_div < width_left_table){
				var total_width = Math.ceil(width_left_div/0.3);
				var width_right_virtual = total_width*0.7;
				var width_right_actual = width_right_virtual - (width_left_table - width_left_div);
				var percent_right = Math.floor((width_right_actual/total_width)*100);
				console.log('percent_right:::'+percent_right);
				$("#left").css('min-width',width_left_table + 'px');
				$("#right").css('width',percent_right + '%');
			}else{
				$("#left").css('min-width','');
				$("#right").css('width','70%');
				
			}
		}
	}
	
	//Added by Buwen Guo 2017-12-12 from email:Today's issues: 12/11 point 13
	function changeQty(target){
		//console.log('target::',target.value);
		var input_QtyPIP = 0;
		if(target.value == null || target.value == ''){
			input_QtyPIP = 0;
		}else{
			if(isNaN(target.value)){
				input_QtyPIP = 0;
			}else{
				input_QtyPIP = Number(target.value);
			}
		}
		
		var data_pip = $(target).parent().attr('data-pip');
		if(data_pip == null || data_pip == ''){
			data_pip = 1;
		}else{
			if(isNaN(data_pip)){
				data_pip = 1;
			}else{
				data_pip = Number(data_pip);
			}
		}
		
		var input_Qty = input_QtyPIP / data_pip;
		
		console.log('input_Qty::',input_Qty);
		var inputs_qty = $(target).parent().next().find('input');
		
		if(inputs_qty != null && inputs_qty.length > 0){
			inputs_qty[0].value = input_Qty;
			$(inputs_qty[0]).change();
		}
		
	}
	
	//Added by Buwen Guo 2017-12-12 from email:Today's issues: 12/11 point 14
	function changeTotalLineCost(target){
		var input_Qty = 0;
		if(target.value == null || target.value == ''){
			input_Qty = 0;
		}else{
			if(isNaN(target.value)){
				input_Qty = 0;
			}else{
				input_Qty = Number(target.value);
			}
		}
		
		var data_cost = $(target).parent().attr('data-cost');
		if(data_cost == null || data_cost == ''){
			data_cost = 0;
		}else{
			if(isNaN(data_cost)){
				data_cost = 0;
			}else{
				data_cost = Number(data_cost);
			}
		}
		
		var totalLineCost = input_Qty * data_cost;
		
		//var td_totalLineCost = $(target).parent().next().next().next().next().next().next();
		var td_totalLineCost = $("span[id*='totalCost_id']").parent();
		
		if(td_totalLineCost != null && td_totalLineCost.length > 0){
			$(td_totalLineCost[0]).text(totalLineCost);
		}
        
	}

	//Added by Tangyong Li 2017-12-14 from email:12/13 Issues point 7
	function setQuantity(target){
        //var td_currentMOQ = $(target).parent().next().next().next().next().next().next().next().next().next().next().children().val();
        var td_currentMOQ = $("input[id*='moq_id']").val();
        if(td_currentMOQ != null && td_currentMOQ != '' && target.value != null && Number(target.value.replace(/,/g,'')) < Number(td_currentMOQ.replace(/,/g,''))) {
            $(target).val(td_currentMOQ);
        }
    }
    
    function addCommaSeparator() {
    	var output_totalVal = $("span[id*='total_val_id']").text();
    	var output_totalCost = $("span[id*='total_cost_id']").text();
    	if(output_totalVal != '') {
	        var span_total = convertIntoComma(Number(output_totalVal));
			$("span[id*='total_val_id']").text(span_total);
		}
		if(output_totalCost != '') {
	        var span_total = convertIntoComma(Number(output_totalCost));
			$("span[id*='total_cost_id']").text(span_total);
		}
    }
    
    function convertIntoComma(num){
		//1234.56 --> 1,234.56
		var result = '';
		if(num == null || num == '' || num == 0){
    		num = 0.00;
    	}else{
    		num = Number(num);
    	}
    	int_num = parseInt(Number(num));
    	dec_num = getDecimal(num);
    	
    	result = '' + toThousands(int_num) + dec_num;
		return result;
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