	//This param save the all data in the upload csv file.
	var arr_allDataFromCSV = new Array();
	//This param save the number of all data in the upload csv file.
	var int_allDataSizeFromCSV = 0;
	//This param save the field mappings of all data in the upload csv file.
	var arr_fieldMapping = new Array();
	//This param save the label of all data in the upload csv file.
	var arr_labelInCSV = new Array();
	//This param save the current file name of the upload csv file.
	var str_currFileName = '';
	//自定义csv文件分隔符，默认是逗号。
	var flag_customSeparated = ',';
	
	//每次import剩下的obj数组
	var arr_remainObjToInsert = new Array();
	
	$(function(){ 
		initMappingFields();
	});
	
	//ImportData
	function ImportData(){
		showLoading();
		$("#input_result_totalSuccess").val(0);
    	$("#input_result_totalErrors").val(0);
		var arr_objToInsertAll = new Array();
		var arr_objToInsertCurr = new Array();
		var arr_objToInsertRemain = new Array();
		if(arr_allDataFromCSV != null && arr_allDataFromCSV.length >= 1){
			//the first line in csv file is the field label not the data,so skip it.
			for(var i=1;i<arr_allDataFromCSV.length;i++){
				var temp_obj = createRecord(arr_allDataFromCSV[i]);
				arr_objToInsertAll.push(temp_obj);
			}
			if(arr_objToInsertAll.length > 0){
				console.log('arr_objToInsertAll::',arr_objToInsertAll);
				if(arr_objToInsertAll.length > 200){
					for(var i=0;i<200;i++){
						arr_objToInsertCurr.push(arr_objToInsertAll[i]);
					}
					for(var j=200;j<arr_objToInsertAll.length;j++){
						arr_objToInsertRemain.push(arr_objToInsertAll[j]);
					}
				}else{
					arr_objToInsertCurr = arr_objToInsertAll;
				}
				arr_remainObjToInsert = arr_objToInsertRemain;
				console.log('ImportData::arr_objToInsertCurr::',arr_objToInsertCurr);
				var str_json =  JSON.stringify(arr_objToInsertCurr);
				$("input[id*='hidden_param_newFileName']").val(str_currFileName);
				$("input[id*='hidden_param_records']").val(str_json);
				importFile();
				//importRecords();
			}
		}else{
			alert('No data to import.');
			hideLoading();
		}
		//hideLoading();
	}
	
	//js read file content
    function getFileContents(files) {
    	showLoading();
    	$("#input_result_totalSuccess").val(0);
    	$("#input_result_totalErrors").val(0);
    	var temp_files = files.files;
    	if (temp_files.length) {
            var file = temp_files[0];
            console.log('current file::',file);
            str_currFileName = file.name;
        }
        var bool_fileExisted = checkFileExisting();
		if(!bool_fileExisted){
			arr_allDataFromCSV = new Array();
			int_allDataSizeFromCSV = 0;
			arr_labelInCSV = new Array();
			str_currFileName = '';
			caculateTotalRecords();
			hideLoading();
			return false;
		}
        $(files).csv2arr(function(arr){
        	arr_allDataFromCSV = arr;
        	int_allDataSizeFromCSV = arr.length - 1;
        	if(arr_allDataFromCSV != null && arr_allDataFromCSV.length >0){
        		arr_labelInCSV = arr_allDataFromCSV[0];
        	}
        	caculateTotalRecords();
        	hideLoading();
        	//console.log('allDataFromCSV::',arr_allDataFromCSV);
        	//console.log('int_allDataSizeFromCSV::',int_allDataSizeFromCSV);
        });
    }
    
    function checkFileExisting(){
    	var str_existFileNames = $('#hidden_param_existFileNames').val();
    	var arr_existFileNames = JSON.parse(str_existFileNames);
    	var returnflag = true;
    	if(str_currFileName != null && str_currFileName != ''){
	    	for(var i = 0;i<arr_existFileNames.length;i++){
	    		if(str_currFileName == arr_existFileNames[i]){
	    			alert('This file has been imported.Please check again.');
	    			returnflag = false;
	    			break;
	    		}
	    	}
    	}else{
    		returnflag = false;
    		alert('File name encode error.');
    	}
    	return returnflag;
    }
    
    function initMappingFields(){
    	var str_fieldMapping = $('#hidden_param_fieldMapping').val();
    	arr_fieldMapping = JSON.parse(str_fieldMapping);
    	//console.log('mappingFields::',arr_fieldMapping);
    }
    
    function createRecord(arr_records){
    	var temp_obj = new Object();
    	if(arr_records != null && arr_records.length > 0 && arr_labelInCSV != null && arr_labelInCSV.length >0  && arr_records.length == arr_labelInCSV.length){
    		for(var j=0;j<arr_records.length;j++){
    			var str_label = arr_labelInCSV[j];
    			var str_apiName = getApiNameFromLabel(str_label);
    			if(str_apiName != null){
    				temp_obj[str_apiName] = arr_records[j];
    			}
    		}
    	}
    	temp_obj.Filename__c = str_currFileName;
    	if(temp_obj.Customer__c == null || temp_obj.Customer__c == undefined){temp_obj.Customer__c = '';}
    	if(temp_obj.TE_part_number__c == null || temp_obj.TE_part_number__c == undefined){temp_obj.TE_part_number__c = '';}
    	temp_obj.External_Id__c = str_currFileName+'_'+temp_obj.Customer__c+'_'+temp_obj.TE_part_number__c;
    	return temp_obj;
    }
    
    function getApiNameFromLabel(str_label){
    	if(str_label != null){
    		str_label = trim(str_label);
    	}
    	var str_returnValue = null;
    	if(arr_fieldMapping != null && arr_fieldMapping.length > 0){
    		for(var j=0;j<arr_fieldMapping.length;j++){
    			if(arr_fieldMapping[j].Name == str_label){
    				str_returnValue = arr_fieldMapping[j].API_Name__c;
    			}
    		}
    	}
    	return str_returnValue;
    }
    
    function keepOnImport(){
    	console.log('keepOnImport::arr_remainObjToInsert::',arr_remainObjToInsert.length);
    	if(arr_remainObjToInsert.length > 0){
			var arr_objToInsertCurr = new Array();
			var arr_objToInsertRemain = new Array();
			if(arr_remainObjToInsert.length > 200){
				for(var i=0;i<200;i++){
					arr_objToInsertCurr.push(arr_remainObjToInsert[i]);
				}
				for(var j=200;j<arr_remainObjToInsert.length;j++){
					arr_objToInsertRemain.push(arr_remainObjToInsert[j]);
				}
			}else{
				arr_objToInsertCurr = arr_remainObjToInsert;
			}
			arr_remainObjToInsert = arr_objToInsertRemain;
			console.log('keepOnImport::arr_objToInsertCurr::',arr_objToInsertCurr);
			var str_json =  JSON.stringify(arr_objToInsertCurr);
			$("input[id*='hidden_param_records']").val(str_json);
			importRecords();
		}
    }
    
    function checkResponse(){
    	console.log('checkResponse::');
    	var str_response = $("#hidden_param_importResponse").val();
    	var obj_response = JSON.parse(str_response);
    	var prev_success = $("#input_result_totalSuccess").val();
    	var prev_error = $("#input_result_totalErrors").val();
    	prev_success = parseInt(prev_success);
    	prev_error = parseInt(prev_error);
    	
    	var total_success = prev_success + obj_response.int_successCounter;
    	var total_error = prev_error + obj_response.int_errorCounter;
    	
    	$("#input_result_totalSuccess").val(total_success);
    	$("#input_result_totalErrors").val(total_error);
    	
    	if(arr_remainObjToInsert != null && arr_remainObjToInsert.length > 0){
    		console.log('remain::',arr_remainObjToInsert.length);
    		keepOnImport();
    		return false;
    	}
		console.log('jieshula');
    	clearFile();
		
    	refreshFileNames();
    	//hideLoading();
    }
    
    function clearFile(){
    	str_currFileName = '';
    	arr_allDataFromCSV = new Array();
    	int_allDataSizeFromCSV = 0;
    	arr_labelInCSV = new Array();
    	
    	if(!isIE11()){
			$("#input_file_main").val(null);
			$("#input_file_main").attr('value',null);
			$("#input_file_main").prop('value',null);
    	}else{
			var fileInput = $("#input_file_main");  
			fileInput.replaceWith(fileInput.clone());  
		}
		
    }
    
    function showLoading(){
    	$("#Loading_Panel").show();
    }
    
    function hideLoading(){
    	$("#Loading_Panel").hide();
    }
    
    function caculateTotalRecords(){
    	$("#input_result_totalRecords").val(int_allDataSizeFromCSV);
    }
    
    function trim(str){
		return str.replace(/(^\s*)|(\s*$)/g,'');
	}
    
    //Export function script section start
    var arr_datasForExport = new Array();
    
    function loadDataToCreateCSV(str_lastId){
    	showLoading();
    	arr_datasForExport = new Array();
    	var str_selectFileName = $("#select_reason").val();
    	console.log('str_selectFileName::',str_selectFileName);
    	if(str_selectFileName != null && trim(str_selectFileName)!= ''){
	    	$("input[id*='hidden_param_selectFileName']").val(str_selectFileName);
	    	$("input[id*='hidden_param_lastRecordId']").val(str_lastId);
	    	loadDataFromFileName();
    	}else{
    		alert('Please select a file.');
    	}
    }
    
    function keepOnLoadDataToCreateCSV(){
    	var str_lastId = $("input[id*='hidden_param_lastRecordId']").val();
    	var str_datasJson = $("#hidden_param_datas").val();
    	var arr_datas = JSON.parse(str_datasJson);
    	console.log('arr_datas:::',arr_datas);
    	for(var i=0;i<arr_datas.length;i++){
    		arr_datasForExport.push(arr_datas[i]);
    	}
    	
    	if(str_lastId == '' && arr_datas.length == 0){
    		populateDataTables();
    	}else{
    		var str_selectFileName = $("#select_reason").val();
    		$("input[id*='hidden_param_lastRecordId']").val(str_lastId);
    		$("input[id*='hidden_param_selectFileName']").val(str_selectFileName);
    		loadDataFromFileName();
    	}
    }
    
    function populateDataTables(){
		var arr_datas = arr_datasForExport;
    	var arr_tempApiName = new Array();
    	$("#tr_dataTable_teTable").html('');
    	$("#tbody_dataTable_teTable").html('');
    	for(var i=0;i<arr_fieldMapping.length;i++){
	    	if(arr_fieldMapping[i].API_Name__c != 'OwnerText__c'){
	    		var str_tempLabel = arr_fieldMapping[i].Name;
	    		var str_tempTheadColumn = '<th scope="col"><span class="slds-truncate">'+ str_tempLabel +'</span></th>';
	    		$("#tr_dataTable_teTable").append(str_tempTheadColumn);
	    		var str_tempApiName = arr_fieldMapping[i].API_Name__c;
	    		arr_tempApiName.push(str_tempApiName);
    		}
    	}
    	console.log('arr_tempApiName:::',arr_tempApiName);
    	var int_dataPopulateCounter = 0;
    	var int_dataPopulateTotalSize = arr_datas.length;
    	for(var j=0;j<arr_datas.length;j++){
    		var str_tempTbodyTr = '<tr>';
			for(var k=0;k<arr_tempApiName.length;k++){
				if(arr_tempApiName[k] != 'OwnerText__c'){
					var obj_tempData = arr_datas[j];
					var str_ApiName = arr_tempApiName[k];
					var temp_value = obj_tempData[str_ApiName];
					if(temp_value == null ||temp_value == undefined ){temp_value = ''}
					var str_tempTbodyTrTd = '<td>' + temp_value + '</td>';
					str_tempTbodyTr = str_tempTbodyTr + str_tempTbodyTrTd;
				}
    		}
    		str_tempTbodyTr = str_tempTbodyTr + '</tr>';
    		$("#tbody_dataTable_teTable").append(str_tempTbodyTr);
    		int_dataPopulateCounter = int_dataPopulateCounter + 1;
    	}
    	if(int_dataPopulateCounter == int_dataPopulateTotalSize){
    		//Begin create csv.
    		hideLoading();
    		AutoExcel();
    	}
    }
    
    function AutoExcel(){
		var aLink = document.createElement('a');
		var script = document.getElementById('teTable').getElementsByTagName('script');
		$(script).remove();
		if(isIE11()){
			//IE 6。0-10。0 弹窗下载
		    //var tabledata1 = getTblData();
		    //if(tabledata1 != false){
		    	//doFileExport(getFileName(),tabledata1);
		    //}
		    
		    //IE11  新版blob推送下载
		    if (window.navigator.msSaveOrOpenBlob) {  
	            var tabledata3 =getTblData1();
		    	//console.log('tabledata3::',tabledata3);
		    	if(tabledata3 != false){
			    	var blob = new Blob([tabledata3], { type: "text/csv" });
			    	var fileName = getFileName();
			    	navigator.msSaveBlob(blob, fileName);  
			    }
	        }
	    }else{
	    	//Chrome,Firefox,Opera(Above version 13)
	    	var tabledata3 =getTblData1();
	    	//console.log('tabledata3::',tabledata3);
	    	if(tabledata3 != false){
		    	var blob = new Blob([tabledata3], { type: "text/csv" });
			    var evt = document.createEvent("HTMLEvents");
			    evt.initEvent("click", false, false);
			    aLink.download = getFileName();
			    aLink.href = URL.createObjectURL(blob);
			    $("#div_linkSection_forchrome").html('');
			    $("#div_linkSection_forchrome").append(aLink);
			    $("#div_linkSection_forchrome").find('a')[0].click();
			    //aLink.dispatchEvent(evt);
		    }
	    }
	}
	
	var isIE11 = function(){
		var u = window.navigator.userAgent.toLocaleLowerCase(),
		ie11 = /(trident)\/([\d.]+)/,
		b = u.match(ie11);
		if(b){
			return true;       
		}else{
			return false;
		}
	}
	
	function getTblData() {
	    var rows = 0;
	    //var curTbl = document.getElementById("teTable").getElementsByTagName("tbody")[0];
	    //var outStr = "Project Code"+ ";"+"Engagement"+ ";"+"Resource Name"+ ";"+"Date"+ ";"+"Total Hours"+ ";"+"Non-billable Hours"+ ";"+"Goodwill"+ ";"+"Billable Hours"+ ";"+"Notes"+ ";\n";
	    var curTbl = document.getElementById("teTable");
	    var outStr = "";
	    if (curTbl != null) {
	        for (var j = 0; j < curTbl.rows.length; j++) {
	            for (var i = 0; i < curTbl.rows[j].cells.length; i++) {
	                outStr += ''+curTbl.rows[j].cells[i].innerText +''+flag_customSeparated;
	            }
	            outStr += "\r\n";
	        }
	    }
	    else {
	        outStr = null;
	        alert("No data  !");
	        return false;
	    }
	    return outStr;
	}
	
	function getTblData1() {
	    var rows = 0;
	    //var curTbl = document.getElementById("teTable").getElementsByTagName("tbody")[0];
	    //var outStr = "Project Code"+ ";"+"Engagement"+ ";"+"Resource Name"+ ";"+"Date"+ ";"+"Total Hours"+ ";"+"Non-billable Hours"+ ";"+"Goodwill"+ ";"+"Billable Hours"+ ";"+"Notes"+ "\n";
	    var curTbl = document.getElementById("teTable");
	    var outStr = "";
	    if (curTbl != null) {
	        for (var j = 0; j < curTbl.rows.length; j++) {
	            for (var i = 0; i < curTbl.rows[j].cells.length; i++) {
	            	var strwithout1 = curTbl.rows[j].cells[i].innerText.replace(/(^\s*)|(\s*$)/g, "");
	            	//var strwithout2 = strwithout1.replace(",",".");
	                //outStr += strwithout2 + ",";
	                var strwithout2 = strwithout1;
	                if(strwithout1.indexOf(',') >= 0){
	                	strwithout2 = '"' + strwithout1 +'"';
	                }
	                outStr += strwithout2 + flag_customSeparated;
	            }
	            outStr += "\r\n";
	        }
	    }
	    else {
	        outStr = null;
	        alert("No data  !");
	        return false;
	    }
	    return outStr;
	}
	
	 function doFileExport(inName, inStr) {
	    var xlsWin = null;
	    var width = 6;
	    var height = 4;
	    var openPara = "left=" + (window.screen.width / 2 - width / 2)
		   + ",top=" + (window.screen.height / 2 - height / 2)
		   + ",scrollbars=no,width=" + width + ",height=" + height;
	    xlsWin = window.open("", "_blank", openPara);
	    xlsWin.document.write(inStr);
	    xlsWin.document.close();
	    var saveboolean = xlsWin.document.execCommand('Saveas', false, inName);
	    if(saveboolean){
	    	alert('Save Succeed!');
	    }else{
	    	alert('Save Failed!Please try again later.');
	    }
	    xlsWin.close();
	}
	
	function getFileName(){
		var str_name = '';
		var str_selectFileName = $("#select_reason").val();
		str_name += str_selectFileName;
		return str_name;
	}
	
	//Export function script section end