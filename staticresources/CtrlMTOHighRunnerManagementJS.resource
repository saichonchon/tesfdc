	var int_pageNum = 1;
	var int_totalPage = 0;
	var int_totalNum = 0;
	var int_pageSize = 20;
	
	var arr_allData = new Array();
	
	var isNeedRefreshPager = true;
	var lastHideColumn = [0];
	
	var mouseStart = '';
	var mouseX = '';
	var oldWidth = '';
	
	//window.onload = function(){
		//showLoading();
		//autoResizeTable();
		//SearchData(true,'',true);
	//}
	
	function autoResizeTable(){
		var curr_pageWidth = $('#AppBodyHeader').width();
		//var sideBarWidth = $('#sidebarCell').outerWidth();
		var sideBarWidth = 0;
		var rightWidth = curr_pageWidth - sideBarWidth - 20;
		$("#div_table_result").css('width',rightWidth);
		$("#div_table_result").css('max-width',rightWidth);
		$(window).resize(function() {
			var curr_pageWidth = $('#AppBodyHeader').width();
			//var sideBarWidth = $('#sidebarCell').outerWidth();
			var sideBarWidth = 0;
			var rightWidth = curr_pageWidth - sideBarWidth - 20;
			$("#div_table_result").css('width',rightWidth);
			$("#div_table_result").css('max-width',rightWidth);
		});
	}
	
	
	function hideTableColumn(num){
		lastHideColumn.push(num);
		var tab = document.getElementById("table_result");
		var trs = tab.rows;
		for(var i = 0, len = trs.length; i < len; i++){
			var cell = trs[i].cells[num];
			cell.style.display = 'none';
		}
	}
	
	function showLastTableColumn(){
		var arr_length = lastHideColumn.length - 1;
		if(arr_length <= 0){
			return false;
		}
		var num = lastHideColumn[arr_length];
		lastHideColumn.splice(arr_length,1);
		var tab = document.getElementById("table_result");
		var trs = tab.rows;
		for(var i = 0, len = trs.length; i < len; i++){
			var cell = trs[i].cells[num];
			cell.style.display = '';
		}
	}
	
	function showAllColumns(){
		var tab = document.getElementById("table_result");
		var trs = tab.rows;
		for(var i = 0, len = trs.length; i < len; i++){
			var cells = trs[i].cells;
			for(var j = 0; j < cells.length -1; j++){
				var cell = cells[j];
				cell.style.display = '';
			}
		}
	}
	
	function SearchData(bool_isRefreshPager,str_lastId,bool_isClearAllData){
		showLoading();
		if(bool_isRefreshPager){
			isNeedRefreshPager = true;
		}else{
			isNeedRefreshPager = false;
		}
		if(bool_isClearAllData){
			arr_allData =  new Array();
		}
		showAllColumns();
		var curr_fileName = $("#select_fileName").val();
		$("input[id*='hidden_param_selectFileName']").val(curr_fileName);
		$("input[id*='hidden_param_lastRecordId']").val(str_lastId);
		console.log('beginLoadData::');
		loadDataFromFileName();
	}
	
	function checkIsFinished(){
		var str_lastId = $("input[id*='hidden_param_lastRecordId']").val();
		var str_totalRecords = $("#hidden_param_datas").val();
		var arr_totalRecords = JSON.parse(str_totalRecords);
		console.log('arr_totalRecords::',arr_totalRecords);
		for(var i=0;i<arr_totalRecords.length;i++){
			arr_allData.push(arr_totalRecords[i]);
		}
		if(arr_totalRecords.length > 0){
			SearchData(true,str_lastId,false);
		}else{
			populateData();
		}
	}
	
	function populateData(){
		console.log('loadDataComplete::');
		
		autoPagerCalculator(arr_allData);
		setAndShowPageNumber();
		
		var arr_currPageData = getCurrentPageData();
		var str_currPageData = JSON.stringify(arr_currPageData);
		
		$("input[id*='hidden_param_tempListRunnersJson']").val(str_currPageData);
		renderPage();
	}
		
	function autoPagerCalculator(arr_totalRecords){
		if(arr_totalRecords != null){
			if(arr_totalRecords.length > 0){
				if(isNeedRefreshPager){	
					int_pageNum = 1;
				}else{
					console.log('NoNeedRefreshPager::',int_pageNum);
				}
				int_totalNum = arr_totalRecords.length;
				int_totalPage = Math.ceil(int_totalNum/int_pageSize);
			}else{
				int_pageNum = 1;
				int_totalNum = 0;
				int_totalPage = 0;
			}
		}else{
			int_pageNum = 1;
			int_totalNum = 0;
			int_totalPage = 0;	
		}
	}
	
	function setAndShowPageNumber(){
		$("span#span_current_pageNum").text(int_pageNum);
		$("span#span_total_pageNum").text(int_totalPage);
	}
	
	function getCurrentPageData(){
		var curPageDatas = new Array();
        var beginIndex = (int_pageNum-1)*int_pageSize;
        for(var m=beginIndex;m<int_pageNum*int_pageSize;m++){
            if(m < arr_allData.length){
                curPageDatas.push(arr_allData[m]);
            }
        }
        return curPageDatas;
	}
	
	function prevPage(){
		showLoading();
		var temp_pageNum = int_pageNum - 1;
        if(temp_pageNum < 1){
        	hideLoading();
            return false;
        }else{
            int_pageNum = temp_pageNum ;
        }
        
		setAndShowPageNumber();
		
		var arr_currPageData = getCurrentPageData();
		var str_currPageData = JSON.stringify(arr_currPageData);
		
		$("input[id*='hidden_param_tempListRunnersJson']").val(str_currPageData);
		renderPage();
	}
	
	function nextPage(){
		showLoading();
		var temp_pageNum = int_pageNum + 1;
        if(temp_pageNum > int_totalPage){
        	hideLoading();
            return false;
        }else{
            int_pageNum = temp_pageNum ;
        }
        
		setAndShowPageNumber();
		
		var arr_currPageData = getCurrentPageData();
		var str_currPageData = JSON.stringify(arr_currPageData);
		
		$("input[id*='hidden_param_tempListRunnersJson']").val(str_currPageData);
		renderPage();
	}
	
	function saveButtonClick(){
		showLoading();
		var editedData = getEditedCurrentPageData();
		var str_jsonToSave =  JSON.stringify(editedData);
		$("input[id*='hidden_param_jsonListToSave']").val(str_jsonToSave);
		saveActionFunction();
	}
	
	
	function getEditedCurrentPageData(){
		var arr_tempCurrPageEditedData = new Array();
		$("tr.tr_table_result_repeat_class").each(function(){
			var obj_temp = new Object();
			obj_temp.attributes = new Object();
			obj_temp.attributes.type = "MTO_High_Runner__c";
			obj_temp.Id = $(this).attr("data-recordid");
			obj_temp.External_Id__c = $(this).attr("data-externalid");
			
			var arr_tds = $(this).children('td[data-editable="true"]');
			for(var i = 0;i<arr_tds.length ;i++ ){
				console.log(i,'::',$(arr_tds[i]).find('input.slds-input.mCurrency'));
				var str_fieldApi = $(arr_tds[i]).attr("data-field");
				var str_currValue = $(arr_tds[i]).find('input.slds-input.mCurrency')[0].value;
				obj_temp[str_fieldApi] = parseInt(str_currValue,10);
			}
			arr_tempCurrPageEditedData.push(obj_temp);
		});
		console.log('getEditedCurrentPageData::',arr_tempCurrPageEditedData); 
		return arr_tempCurrPageEditedData;
	}
	
	function numberFieldValidator(currentInput){
		var currValue = $(currentInput).val();
		var prevValue = $(currentInput).attr('data-value');
		if(!(currValue < 100 && currValue > -100)){
			alert('Value must be 2 bit digits.');
			$(currentInput).val(prevValue);
		}
	}
	
	function checkSaveResult(){
		var str_saveResult = $("#hidden_param_importResponse").val();
		var obj_saveResult = JSON.parse(str_saveResult);
		if(obj_saveResult != null && obj_saveResult.int_errorCounter != null && obj_saveResult.int_errorCounter == 0){
			alert('Save Succeed!');
			SearchData(false,'',true);
		}else{
			if(obj_saveResult != null && obj_saveResult.list_error != null){
				var str_totalError = '';
				for(var i = 0;i<obj_saveResult.list_error.length;i++){
					str_totalError = str_totalError + obj_saveResult.list_error[i].str_errorMsg + '\r\n';
				}
				alert(str_totalError);
			}
		}
		//hideLoading();
	}
	
	function showLoading(){
    	$("#Loading_Panel").show();
    }
    
    function hideLoading(){
    	autoResizeTable();
    	$("#Loading_Panel").hide();
    }
    
    function calculateWidth(){
    	isDrag = true;
        var childObj = event.target;
        var parObj = childObj.parentNode;
        var count = 1;
        //parent element traversing to get the TH
        while(parObj.tagName != 'TH') {
            parObj = parObj.parentNode;
            count++;
        }        
        //to get the position from the left for storing the position from where user started to drag
        mouseStart = event.clientX; 
        oldWidth = parObj.offsetWidth;
    }
    
    function removeDragClass() {
    	var childObj = event.target;
        var parObj = childObj.parentNode;
        while(parObj.tagName != 'TH') {
            parObj = parObj.parentNode;
        }   
    	$(parObj.lastChild.lastChild).removeClass("drag_Div");
        $(parObj.lastChild.lastChild.lastChild).removeClass("drag_Div");
    }
    
    var isDrag = false;
    function addDragClass() {
    	if(!isDrag) {
	    	var childObj = event.target;
	        var parObj = childObj.parentNode;
	        while(parObj.tagName != 'TH') {
	            parObj = parObj.parentNode;
	        }   
	    	$(parObj.lastChild.lastChild).addClass("drag_Div");
	        $(parObj.lastChild.lastChild.lastChild).addClass("drag_Div");
    	}
    }
    
    function setIsDrag() {
    	isDrag = false;
    }
    
    function dragStart() {
    	var event = getEvent();
        event.dataTransfer.setData("Text", event.target.id);
    }
    
    function allowDrop() {
   		var event = getEvent();
   		mouseX = event.clientX;
        event.preventDefault();
    }
    
    function setNewWidth(num) {
    	var newWidth = parseFloat(event.clientX - mouseStart + oldWidth);
    	var childObj = event.target;
        var parObj = childObj.parentNode;
        //parent element traversing to get the TH
        while(parObj.tagName != 'TH') {
            parObj = parObj.parentNode;
        }
        var firstDiv = parObj.firstChild;
        var minWidth = $(firstDiv.firstChild).css("width");
        minWidth = Number(minWidth.substring(0, minWidth.indexOf("px")));
        if(newWidth < minWidth) {
            newWidth = minWidth;
        }
        
        var tab = document.getElementById("table_result");
        var trs = tab.rows;
        for(var i = 0, len = trs.length; i < len; i++){
            var cell = trs[i].cells[num];
            $(cell.firstChild).css("width", newWidth + "px");
        }
        $(firstDiv).css("width", newWidth + "px");
        $(parObj.lastChild.lastChild).addClass("drag_Div");
        $(parObj.lastChild.lastChild.lastChild).addClass("drag_Div");
        isDrag = false;
    }
    
    /*
    //ondrag:    setNewWidth('{!num}');
    function setNewWidth(num) {
    	var event = getEvent();
        var childObj = event.target;
        var parObj = childObj.parentNode;
        var count = 1;
        //parent element traversing to get the TH
        while(parObj.tagName != 'TH') {
            parObj = parObj.parentNode;
            count++;
        }
		var firstDiv = parObj.childNodes[0];
        var minWidth = $(firstDiv.childNodes[0]).css("width");
        //To calculate the new width of the column
        var newWidth = parseFloat(getEvent().clientX)- parseFloat(mouseStart)+parseFloat(oldWidth);
        //firstDiv.style.width = newWidth+'px';//assign new width to column
        minWidth = Number(minWidth.substring(0, minWidth.indexOf("px"))) + 2;
        if(newWidth > 0) {
            if(newWidth < minWidth) {
                newWidth = minWidth;
            }
            var tab = document.getElementById("table_result");
            var trs = tab.rows;
            for(var i = 0, len = trs.length; i < len; i++){
                var cell = trs[i].cells[num];
                $(cell.childNodes[0]).css("width", newWidth + "px");
            }
        }
    }*/
    
    var getEvent = function(){
	    return window.event || arguments.callee.caller.arguments[0];
	}