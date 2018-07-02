var QUEUE=async.queue(queueTask, 1), STATIC_QUARTER={};

;function queueTask(task, callback) {
    task.run(callback);
}
var forecastActualBillingChart = {
	subgroup:{"territoryCode":"Territory Name", "region":"Region", "rsmGrouping":"RSM Account Group", "rsmRelayGrouping":"Relay SM Account Group",  "amGrouping":"AM Grouped Account", "relayGrouping":"Relay Grouped Account", "productFamily":"Product Family"},
		
	init: function() {
		this.showSelect();
		this.listClick();
        this.boxchecked();
		this.refreshClick();
		this.exportClick();
	},
	
	drawGroup: function(objName) {
		var strLi = '';
		if (!drawgroup[objName]) return null; 
		for( var i = 0; i < drawgroup[objName].length; i++ ) {
			strLi += '<li><input type="checkbox" value="' + drawgroup[objName][i] + '" /><span>' + drawgroup[objName][i] + '</span></li>';
		}
		return strLi;
	},
	
	showSelect: function() {
		var str = ''; 
        for (objName in this.subgroup) {
            var result = this.drawGroup(objName);
            if(result != null){
                str += '<div id="' + objName + '" class="' + objName + '"><div class="listTitle">' + this.subgroup[objName] + ' </div>'
                + '<span class="listText" >---------ALL-----------------------------------------</span>'
                + '<div class="selectArea" id="' + objName + '_Select" ><ul>' + this.drawGroup(objName) + '</ul></div></div>';
            }
        }    
		$("#Component .inputDiv").before(str);
	},
	
	checkUnclick: function(elem) {
		while (elem && elem.nodeName !="BODY") {
			if($(elem).hasClass("selectArea")){
				return true;
			}
			elem = elem.parentNode;
		}
		return false;
	},
	
	listClick: function() {
		var that = this;
		$("body").on("click", function(event) {
			var $this = $(event.target);
			if(that.checkUnclick(event.target)){
	 
			} else if($this.hasClass("listText")) {				
					var ide = $this.parent().attr("id");
					$(".selectArea").not("#" + ide +"_Select").hide();
					$this.siblings(".selectArea").toggle();
			} else{
				$(".selectArea").hide();
			}
		});
	},
	
	boxchecked: function() {
		var that = this;
		$("#Component").delegate("input[type=checkbox]", "click", function() {
		//$("input[type=checkbox]").("click", function() {
			//step 1 clear listText
			var s = $(this).parentsUntil(".selectArea").parent();
			s.prev(".listText").html('---------ALL-----------------------------------------');
			var ide = s.parent().attr('id');
			
			//2,all checkbox
			//3,fill into listText 		
			$("#" + ide + " .listText").html(that.getListTextValue(ide));
			//4, check Cascade
			that.checkCascade(this);
		});
	},
	
    addOnclick: function(){
    	var that = this;
    	//step 1 clear listText
        var s = $(this).parentsUntil(".selectArea").parent();
        s.prev(".listText").html('---------ALL-----------------------------------------');
        var ide = s.parent().attr('id');
        
        //2,all checkbox
        //3,fill into listText 		
        $("#" + ide + " .listText").html(that.getListTextValue(ide));
        //4, check Cascade
        that.checkCascade(this);
	},


	checkCascade: function(checkBox) {
		//choose one checkbox cascade rsm/tcode or rsmrelay/tcode
		var that = this;
		var ide = $(checkBox).parentsUntil(".selectArea").parent().attr("id");
		if($("#sourceDiv").html() == 'RSM') {
			if(ide == "rsmGrouping_Select") {
				var str_html = '';
				var selectRsmgrouping = new Array();
				// Step1
			    //start : clear territory code
				$("#territoryCode input").prop("checked",false);
				$("#territoryCode .listText").html('---------ALL-----------------------------------------');
				//clear am grouping selected values
				$("#amGrouping .listText").html('---------ALL-----------------------------------------');                
				//END : clear territory code
				
				// Step2
				// START: get all selected options from RSM Grouping
				$("#rsmGrouping_Select input:checked").each(function(index, element) {
					//console.log('select' + $(this).val());	
					selectRsmgrouping.push($(this).val());
					//console.log('selectRsmgrouping' + selectRsmgrouping);
				});
				// END: get all selected options from RSM Grouping
				
				// Step3
				//START: rebuild the option for AM grouping based on Step 2
				// reset am groupings
				str_html = '';
				
				//case 1: there are selected option, we need to build the am groupings based on selected values
				if(selectRsmgrouping.length != 0) {
					for(var n=0; n<selectRsmgrouping.length; n++){
						var list_checkboxRSM = RSMGroupingAMGroupingMAP[selectRsmgrouping[n]];
						if(list_checkboxRSM){
							for(var j=0; j<list_checkboxRSM.length; j++){
								if(str_html.indexOf('value="' + list_checkboxRSM[j] + '"') < 0 ) {
									str_html += '<li><input type="checkbox" value="' + list_checkboxRSM[j] + '" /><span>' + list_checkboxRSM[j] + '</span></li>';
								}
							}
						}
					}
				}
				//case 2: there is no selected values, we need to show all am groupings
				else {
					for(var k=0;k<drawgroup.amGrouping.length; k++) {
						if(str_html.indexOf('value="' + drawgroup.amGrouping[k] + '"') < 0 ) {
							str_html += '<li><input type="checkbox" value="' + drawgroup.amGrouping[k] + '"  /><span>' + drawgroup.amGrouping[k] + '</span></li>';
						}
					}
				}

				$('#amGrouping_Select').children('ul').html(str_html);
				//console.log('am' + str_html);		
				
				//END: rebuild the option for AM grouping based on Step 3			
			}	
			else if(ide == "territoryCode_Select" ) {
				var str_html = '';
				var selectRsmTerritoryCode = new Array();
				// Step1
			    //start : clear rsmGrouping
				$("#rsmGrouping input").prop("checked",false);
				$("#rsmGrouping .listText").html('---------ALL-----------------------------------------');
                
				//clear am grouping selected values
				$("#amGrouping .listText").html('---------ALL-----------------------------------------');                   
				//END : clear territory code
				
				// Step2
				// START: get all selected options from RSM territoryCode
				$("#territoryCode_Select input:checked").each(function(index, element) {
					//console.log('select' + $(this).val());	
					selectRsmTerritoryCode.push($(this).val());
					//console.log('selectRsmTerritoryCode' + selectRsmTerritoryCode);
				});
				// END: get all selected options from RSM territoryCode
				
				// Step3
				//START: rebuild the option for AM grouping based on Step 2
				
				// reset am groupings
				str_html = '';
				
				//case 1: there are selected option, we need to build the am groupings based on selected values
				if(selectRsmTerritoryCode.length != 0) {
					for(n=0; n<selectRsmTerritoryCode.length; n++){
						var list_checkboxRSMTcode = TcodeAMGroupingMAP[selectRsmTerritoryCode[n]];
						if(list_checkboxRSMTcode){
							for(j=0; j<list_checkboxRSMTcode.length; j++){
								if(str_html.indexOf('value="' + list_checkboxRSMTcode[j] + '"') < 0 ) {
									str_html += '<li><input type="checkbox" value="' + list_checkboxRSMTcode[j] + '"  /><span>' + list_checkboxRSMTcode[j] + '</span></li>';
								}
							}
						}
					}					 
				}				
				//case 2: there is no selected values, we need to show all am groupings
				else {
					for(k=0;k<drawgroup.amGrouping.length; k++) {
						if(str_html.indexOf('value="' + drawgroup.amGrouping[k] + '"') < 0 ) {
							str_html += '<li><input type="checkbox" value="' + drawgroup.amGrouping[k] + '" /><span>' + drawgroup.amGrouping[k] + '</span></li>';
						}
					
					}
				}

				$('#amGrouping_Select').children('ul').html(str_html);
				//console.log('am' + str_html);
				//END: rebuild the option for AM grouping based on Step 3
			}
			
		}
		else if($("#sourceDiv").html() == 'RSMRelay'){
			if(ide == "rsmRelayGrouping_Select") {
				var str_html = '';
				var selectRsmRelaygrouping = new Array();
				// Step1
			    //start : clear territory code
				$("#territoryCode input").prop("checked",false);
				$("#territoryCode .listText").html('---------ALL-----------------------------------------');
				//clear relay grouping selected values
				$("#relayGrouping .listText").html('---------ALL-----------------------------------------');
				//END : clear territory code
				
				// Step2
				// START: get all selected options from RSMRelay Grouping
				$("#rsmRelayGrouping_Select input:checked").each(function(index, element) {
					//console.log('select' + $(this).val());	
					selectRsmRelaygrouping.push($(this).val());
					//console.log('selectRsmRelaygrouping' + selectRsmRelaygrouping);
				});
				// END: get all selected options from RSMRelay Grouping
				
				// Step3
				//START: rebuild the option for AM grouping based on Step 2
				// reset relay groupings
				str_html = '';
				
				//case 1: there are selected option, we need to build the am groupings based on selected values
				if(selectRsmRelaygrouping.length != 0) {
					for(n=0; n<selectRsmRelaygrouping.length; n++){
						var list_checkboxRSMRelay = RSMRelayGroupingRelayGroupingMAP[selectRsmRelaygrouping[n]];
						if(list_checkboxRSMRelay){
							for(j=0; j<list_checkboxRSMRelay.length; j++){
								if(str_html.indexOf('value="' + list_checkboxRSMRelay[j] + '"') < 0 ) { 
									str_html += '<li><input type="checkbox" value="' + list_checkboxRSMRelay[j] + '" /><span>' + list_checkboxRSMRelay[j] + '</span></li>';
								}
							}
						}
					}
				}
				//case 2: there is no selected values, we need to show all am groupings
				else {
					for(k=0;k<drawgroup.relayGrouping.length; k++) {
						if(str_html.indexOf('value="' + drawgroup.relayGrouping[k] + '"') < 0 ) {
							str_html += '<li><input type="checkbox" value="' + drawgroup.relayGrouping[k] + '" /><span>' + drawgroup.relayGrouping[k] + '</span></li>';
						}
					}	
				}

				$('#relayGrouping_Select').children('ul').html(str_html);
				//console.log('relay' + str_html);
				//END: rebuild the option for AM grouping based on Step 3	
				
				
			} else if(ide == "territoryCode_Select") {
				var str_html = '';
				var selectRsmRelayTerritoryCode = new Array();
				// Step1
			    //start : clear rsmRelayGrouping
				$("#rsmRelayGrouping input").prop("checked",false);
				$("#rsmRelayGrouping .listText").html('---------ALL-----------------------------------------');
				//clear relay grouping selected values
				$("#relayGrouping .listText").html('---------ALL-----------------------------------------');
				//END : clear rsmRelayGrouping
				
				// Step2
				// START: get all selected options from RSMRelay territoryCode
				$("#territoryCode_Select input:checked").each(function(index, element) {
					//console.log('select' + $(this).val());	
					selectRsmRelayTerritoryCode.push($(this).val());
					//console.log('selectRsmRelayTerritoryCode' + selectRsmRelayTerritoryCode);
				});
				// END: get all selected options from RSMRelay territoryCode
				
				// Step3
				//START: rebuild the option for AM grouping based on Step 2
				
				// reset relay groupings
				str_html = '';
				
				//case 1: there are selected option, we need to build the am groupings based on selected values
				if(selectRsmRelayTerritoryCode.length != 0) {
					for(n=0; n<selectRsmRelayTerritoryCode.length; n++){
						var list_checkboxRSMRelayTcode = TcodeRelayGroupingMAP[selectRsmRelayTerritoryCode[n]];
						if(list_checkboxRSMRelayTcode){
							for(j=0; j<list_checkboxRSMRelayTcode.length; j++){
								if(str_html.indexOf('value="' + list_checkboxRSMRelayTcode[j] + '"') < 0 ) {
									str_html += '<li><input type="checkbox" value="' + list_checkboxRSMRelayTcode[j] + '" /><span>' + list_checkboxRSMRelayTcode[j] + '</span></li>';
								}
							}
						}
					}					
				}				
				//case 2: there is no selected values, we need to show all am groupings
				else {
					for(k=0;k<drawgroup.relayGrouping.length; k++) {
						if(str_html.indexOf('value="' + drawgroup.relayGrouping[k] + '"') < 0 ) {
							str_html += '<li><input type="checkbox" value="' + drawgroup.relayGrouping[k] + '" /><span>' + drawgroup.relayGrouping[k] + '</span></li>';
						}
					}
				}

				$('#relayGrouping_Select').children('ul').html(str_html);
				//console.log('relay' + str_html);
				//END: rebuild the option for AM grouping based on Step 3
			}
		}	
	},

	getListTextValue: function(objName) {
		var str = '';
		var lSize = $(".selectArea input:checked").size();
		$("#" + objName + " .selectArea input:checked").each(function(index, element) {
			str += $(this).val() + ';';	
		});
		return str;
		if(str == '') {
			str = '---------ALL-----------------------------------------';
		}
	},
	
	getValues: function(year,quarter) {
		var listValue = {};
		$(".selectArea").each(function() {
			var ide = $(this).parent("div").attr("id");
			var str = '';
			var lSize = $("input:checked", this).size();
			$("input:checked", this).each(function(index, element) {
				if(lSize == index + 1) {
					str += $(this).val();	
				} else {
					str += $(this).val() + ';';	
				}
			});
			listValue[ide] = str;
		});
		
        if($("#territoryCodeDiv").html() != null){
            listValue["territoryCode"] = $("#territoryCodeDiv").html();
        }
        
        if($("#sourceDiv").html() != null){
            listValue["source"] = $("#sourceDiv").html();
        }   
        
        if($("#cfyDiv").html() != null){
            listValue["currentFiscalYear"] = $("#cfyDiv").html();
        }  

        if($("#cfqDiv").html() != null){
            listValue["currentFiscalQuarter"] = $("#cfqDiv").html();
        } 
        if($("#uidDiv").html() != null){
            listValue["userId"] = $("#uidDiv").html();
        } 
		listValue["fiscalYear"] = year;
		listValue["fiscalQuarter"] = quarter;
		//console.log("zzz listValue", listValue);
		return JSON.stringify(listValue);
	},
	
	refreshClick: function() {
		var that = this;
		
		$("#refreshBtn").on("click", function() {
			$(".LoadingDiv").show();
		   	myRBtn(); 
		});
	},
	
	exportClick: function() {
		var that = this;
		$("#exportBtn").on("click", event_export_click);
	},
	
	drawExport_result: function() {
		var strTd ='';
		for(var i = 0; i < 11; i++) {
			strTd += '<td class="bodyTd ' + i + '">' + i + '</td>';
		}
		return strTd;
	},
	
	showExport_result: function() {
		var strTr = '';
		for( var k = 0; k < 5; k++ ) {
			strTr += '<tr class="bodyTr ' + k + '"> ' + this.drawExport_result() + '</tr>';	
		}
		$("#reportbody").append(strTr);
	}
	
}

;function initCtrlDocument(){
	forecastActualBillingChart.init();
	document.getElementById('loadingdivid').style.display='none';
}

;function event_export_click(e){
	
	var $this=$(this), json={
		'json': {}, '$cloneRow': $('#templatefootid tr').clone(), '$appendRow': $('#reportbody'), '$headRow': $('#reporthead'),
		'quarter': null, 'quarterCell': {}, 'list_quarter':[], '$loading': $('#loadingdivid'), 
		'STATIC_VAR': {}, 'action': getExportGroup_js, 'complete': complete_getExportGroup, 
		'action_quarter': getExportData_js, 'complete_quarter': complete_getExportData
	};
	json['$appendRow'].empty();
	json['$headRow'].find('th:gt(2)').each(function(){
		var quarter=this.getAttribute('data-q');
		if(quarter.split('-').length == 2){
			json['quarterCell'][quarter]=this.cellIndex;
			json['list_quarter'].push(quarter);
			STATIC_QUARTER[quarter]=quarter;
		}
	});
	//TO DO (params)
	json['json']=forecastActualBillingChart.getValues('2015', '1');
	//json['json']=JSON.stringify(json['json']);
	json['$loading'].show();
	customRemoteAction(json, json['action'], json['complete']);
}

;function event_reLoadChart_click(y, q, cy, target){
	$(target).parent().animate({backgroundColor: '#6A9CD9'}, 130, function(){
  		searchRemoteChart(y, q, cy);
  	});
}

;function searchRemoteChart(y, q, cy){
	Visualforce.remoting.Manager.invokeAction(getChartData_js(), 
					forecastActualBillingChart.getValues(y, q), complete_getChartData );
	
	
	;function complete_getChartData(result, event){
		QUEUE.push({name: 'getChartData', run: function(cb){
		//	console.log(result );
	    //    if(result.message == 'success'){ //successful
			var $status_cell=$("#actionResult").find('b.ref_box[data-quarter="'+ y +'-'+ q +'"]');
	        if(event.status){
	            if(y == cy) {
	            	current[q] = Number(result.amount);
            	}else {
            		next[q] = Number(result.amount);
            	}
	            
	        //    var c = $("#actionResult").html();
	            
	          	$status_cell.animate({backgroundColor: '#51C957'}, 130, function(){
		            $status_cell.remove();
		    		if($("#actionResult b").length == 0){ 
		        		drawForecastChart(current, next);
		        		$(".LoadingDiv").hide();
					}
					cb(null);
	          	});
	        }
	        else{//failed, show error message and create a link to allow user to retry
	        //	var $status_cell = $("#actionResult").find('b.ref_box[data-quarter="'+ y +'-'+ q +'"]');
	        	$status_cell.attr("title",  y +'-' + q + ':' + event['message'])
	        		.animate({backgroundColor: '#C95151'}, 130, function(){
			        	var cFalse = '<span onclick="event_reLoadChart_click(' +　y　+　','　+　q　+　','　+　cy　+　', this)">Reload</span>';
			        	$status_cell.html(cFalse);
		        	});
				cb(null);
	        }
	    }}, function(err){ });
    }
}

;function complete_getExportGroup(result, event, data){
	
	QUEUE.push({name: data['json'], run: function(cb){

		if(event.status){

			for(var key in result){

				var $subClone=data['$cloneRow'].clone();
				var r = result[key];
				var a = r.split("|");
				for(var n=0; n<a.length; n++){				
                    $subClone.find('td:eq(' + n + ')').html(a[n]);		
				}

				$subClone.attr({'data-key': r});
				data['$appendRow'].append($subClone);  			
			}
			
			asyncEachSeries_Original(data['list_quarter'], function(item, callback){
				var d={};
				$.extend(d, data);          
				d['quarter']=item;
                var y,q;
                if(item.indexOf("-") != -1){
                    y = item.substring(0,item.indexOf("-"));
                    //console.log('y: ' + y);
                    q = item.substring(item.indexOf("-")+2, item.length);
                    //console.log('q: ' + q);                    
                }
				d['json']=forecastActualBillingChart.getValues(y, q);	//TO DO (params)
				//d['json']=JSON.stringify(d['json']);
		        customRemoteAction(d, d['action_quarter'], d['complete_quarter']);
		    }, function(err){
				cb(null);
			}, 180);
		    
	    }else{
	    	reloadExportRow(data, event);
			cb(null);
	    }
    }}, function(err){ });
	
    
    /*HELP methods*/
    ;function reloadExportRow(data, event){
    	data['$loading'].find('#reloadbox').css({'display': 'inline-block'}).find('#reloadmsg').html(event['message'])
    			.parent().find('#reloadpoint').off('click').on('click', function(e){
					var $this=$(this);
					customRemoteAction(data, data['action'], data['complete']);
					$this.off('click').parent().hide();
		    	});
    }
    /*HELP methods*/
}

;function complete_getExportData(result, event, data){
	
	QUEUE.push({name: data['json'], run: function(cb){

		if(event.status){
			var qCell=data['quarterCell'][data['quarter']];
			//console.log( qCell );
			//console.log( result );
			for(var key in result){
				data['$appendRow'].find('tr[data-key="'+key+'"] td:eq('+qCell+')').html(result[key]);
			}
			
			if(STATIC_QUARTER.hasOwnProperty(data['quarter'])){	//check quarter remote action
				delete STATIC_QUARTER[data['quarter']];
			}
			
			if($.isEmptyObject(STATIC_QUARTER)){
				generateCSV_file(data);
			}
	    }else{
	    	reloadExportRow(data, event);
	    }
		cb(null);
    }}, function(err){ });
	
    
    /*HELP methods*/
    ;function generateCSV_file(data){
    	var list_head=[], list_data=[];
		
    	data['$headRow'].find('th').each(function(){
    		list_head.push($(this).html());
    	});
		
		data['$appendRow'].find('tr').each(function(){
			var list_t=[];
			$(this).find('td').each(function(){
                if($(this).html() != '&nbsp;'){
                    list_t.push($(this).html());
                } 
                else{
                    list_t.push('0');
                }
			});
			list_data.push(list_t);
		});
		var config={fields: list_head, data: list_data, quotes: true, delimiter: ",", newline: "\r\n"},
			strCSV=Papa.unparse(config);
			
		exportCSVpost($('#exportBtn').attr('data-url'), strCSV);
	
		data['$loading'].hide();
    }
    
    ;function reloadExportRow(data, event){
    	data['$loading'].find('#reloadbox').css({'display': 'inline-block'}).find('#reloadmsg').html(event['message'])
    			.parent().find('#reloadpoint').off('click').on('click', function(e){
					var $this=$(this);
					
					customRemoteAction(data, data['action_quarter'], data['complete_quarter']);
					$this.off('click').parent().hide();
		    	});
    }
    /*HELP methods*/
}

;function exportCSVpost(URL, PARAMS) {
	var temp=document.createElement("form"), hidden=document.createElement("input");
	temp.action=URL;
	temp.id = "exportcsvform";
	temp.method="POST";
	temp.style.display="none";
	
	hidden.type="hidden";
	hidden.name='exp';
	hidden.value=PARAMS;
	temp.appendChild(hidden);
	document.body.appendChild(temp);
	temp.submit();
	$('#exportcsvform').remove();
	return temp;
}

;function addListener (element, event, fn, params) {
    var eventHandler = ( params ? function(){ fn.call(params); } : fn );
    if (window.attachEvent) {
        element.attachEvent('on' + event, eventHandler);
    } else {
        element.addEventListener(event, eventHandler, false);
    }
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
;function customRemoteAction(strParam, callFunction, callResult) {
    Visualforce.remoting.Manager.invokeAction(
        callFunction(), strParam['json'], function(result, event){ callResult(result, event, strParam); }, {escape: false, timeout:120000}
    );
}
;function customMultipleRemoteAction(strParam, callFunction, callResult) {
    Visualforce.remoting.Manager.invokeAction(
        callFunction(), strParam['cls'], strParam['json'], function(result, event){ callResult(result, event, strParam); }, {escape: false, timeout:120000}
    );
}


