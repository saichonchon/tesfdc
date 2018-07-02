//*********************** Configuration Start **************************//
var configObj = {
	CUSTOM_DATE : "Custom Date",
	OBJS: ['Opportunity', 'Opportunity_Part__c', 'Opportunity_Partner__c', 'APL_Billing_Result_of_Covnerted_Opp__c'],
	/************** START: for showing ******************/
	// Array used to show on page.
	map_wd_Name: { //Won Date
		'Within this FY':		'Within this FY',
		'In the past 90 days':	'In the past 90 days',
		'In the past 30 days':	'In the past 30 days',
		//'Custom Date':			'Custom Date',
		'Last Fiscal Year':		'Last Fiscal Year'
	},
	map_bt_Name: { //Billing Type
   		//'Direct':	'Direct',
   		'POS':		'POS',
   		'CMA':		'CMA'
   	},
	map_pf_Name: { //Product Family
		'None':					'None',
		'RAST':					'RAST',
		'Other BU Products':	'Other BU Products',
		'Teminals & Splices':	'Teminals & Splices',
		'Power':				'Power',
		'Signal':				'Signal',
		'Advanced Development':	'Advanced Development',
		'Magnet Wire':			'Magnet Wire',
		'Relay Products':		'Relay Products',
		'Tubing':				'Tubing',
		'Intergrated Products':	'Intergrated Products',
		'Sensor':				'Sensor'
	},
	map_gamCode_Name: { //GAM Name/Code
		// WHERE clause will be: 'Partner_GAM_Code__c = \'G077\'' on Opportunity_Partner__c.
		'None': 'None',
		'G077': 'ECI',
		'G288': 'Haier',
		'G076': 'Emerson',
		'G039': 'Whirlpool',
		'G035': 'Electrolux',
		'G289': 'Bosch Consumer',
		'G287': 'Samsung Appliance',
		'G264': 'LG Electronics Appl'//,
		//'G400': 'Mabe Mexico S de RL D'
	},
	/************** END: for showing ******************/
	
	/************** START: Maps for jointing into where clauses ******************/
	// Map of Billing Type
	
	// Map of GAM Name/Code
	// Map of Won Date: parse by back-end.
	map_wd: {
		'Within this FY':		'Won_Date__c = THIS_FISCAL_YEAR',
		'In the past 90 days':	'Won_Date__c = LAST_N_DAYS:90',
		'In the past 30 days':	'Won_Date__c = LAST_N_DAYS:30',
		//'Custom Date':			'(Won_Date__c >= :Startdate and Won_Date__c <= :Enddate)',
		'Last Fiscal Year':		'Won_Date__c =  LAST_FISCAL_YEAR'
	},
	
	// Map of Product Family
	map_pf: {
		'RAST':					"GPL__r.CBC2__c = \'30015\'",
		'Other BU Products':	"GPL__r.CBC1__c != \'30007\'",
		'Teminals & Splices':	"GPL__r.CBC2__c = \'30016\'",
		'Power':				"GPL__r.CBC2__c = \'30012\'",
		'Signal':				"GPL__r.CBC2__c = \'30014\'",
		'Advanced Development':	"GPL__r.CBC2__c = \'30013\'",
		'Magnet Wire':			"GPL__r.CBC2__c = \'30042\'",
		//change to 41553 by Lei Tang <lei.tang@capgemini.com> 2017-12-05
		'Relay Products':		"(GPL__r.CBC2__c IN (\'13213\', \'30005\') or GPL__r.CBC3__c IN (\'41553\'))",
		'Tubing':				"GPL__r.CBC2__c = \'30017\'",
		'Intergrated Products':	"GPL__r.CBC2__c = \'41204\'",
		'Sensor':               "(GPL__r.CBC2__c = \'41216\'or GPL__r.CBC2__c = \'41239\')"
	},
	/************** END: Maps for jointing into where clauses ******************/
	
	// THIS MAP IS IMPORTANT! DONT CHANGE IT!!!
	map_api_query: {
		Won_Date__c:			'map_wd',
		Partner_GAM_Code__c:	'',
		CBC_2_Name__c:			'map_pf',
		Account_Manager__c:		'',
		Field_Engineer_Name__c:	'',
		Opportunity_Owner__c:	'',
		Opportunity_Number__c:	'',
		Customer_Region__c:		'',
		Bill_Type__c:			''
	}
};

// to store oppy id part partner dom
var map_oppyid_partPartner = {};

var links = ['Opportunity_Number__c', 'Account.Account_Combined_Data__c', 'Partner_Account_Name__c'];

//*********************** Configuration End **************************//
var QUEUE = async.queue(queueRun, 1),
	//save search filter param
	filtersObj = {},
	oppyTotal = 0;


;function queueRun(task, callback) {
    task.run(callback);
}
//*********************** ChenChen Start **************************//
// Init filter value.
;function filterInit() {
	$('#accordion').accordion();
	
	// Set some filters` values.
	drawFilters(); // TODO
	
	
	// Bind events: 1.click date picker; 2. click left/right arrow symbol.
	datePickerEvt(); // TODO
	multiSelEvt();
	//subboxEvt();
	
	// Show table header(opportunity fields + forecast fields + billing fields).
	showTableHeader(); // TODO
	
	
}


;function getFilterInfo() {
	// Map filter information.
	return {
		map_filterDate: [{
			filterType: 'date',
			displayName: 'Opp Won Date',
			uniqueName: 'Won_Date__c',
			objectName: 'Opportunity_Part__c',
			valuesMap: configObj.map_wd_Name
		}
	],
	map_filterPickList: [{
			filterType: 'pickList',
			displayName: 'GAM Name/Code',
			uniqueName: 'Partner_GAM_Code__c',
			objectName: 'Opportunity_Partner__c',
			valuesMap: configObj.map_gamCode_Name
		}, {
			filterType: 'pickList',
			displayName: 'Product Family',
			uniqueName: 'CBC_2_Name__c',
			objectName: 'Opportunity_Part__c',
			valuesMap: configObj.map_pf_Name
		}
	],
	map_filterMultiple: [{
			filterType: 'multiplePickList',
			displayName: 'Account Manager',
			uniqueName: 'Account_Manager__c',
			objectName: 'Opportunity',
			valuesMap: dynFilterVal['account_Manager'] // From controller.
		}, {
			filterType: 'multiplePickList',
			displayName: 'Field Engineer',
			uniqueName: 'Field_Engineer_Name__c',
			objectName: 'Opportunity',
			valuesMap: dynFilterVal['field_Engineer'] // From controller.
		}, {
			filterType: 'multiplePickList',
			displayName: 'Opportunity Owner',
			uniqueName: 'OwnerId',
			objectName: 'Opportunity',
			valuesMap: dynFilterVal['opportunity_Owner'] // From controller.
		}, {
			filterType: 'multiplePickList',
			displayName: 'Opportunity Number',
			uniqueName: 'Opportunity_Number__c',
			objectName: 'Opportunity',
			valuesMap: dynFilterVal['opportunity_Number'] // From controller.
		}, {
			filterType: 'multiplePickList',
			displayName: 'Customer Region',
			uniqueName: 'Customer_Region__c',
			objectName: 'Opportunity',
			valuesMap: dynFilterVal['customer_Region'] // From controller.
		}, {
			filterType: 'multiplePickList',
			displayName: 'Billing Type',
			uniqueName: 'Bill_Type__c',
			objectName: 'APL_Billing_Result_of_Covnerted_Opp__c',
			valuesMap: configObj.map_bt_Name
		}
	]};
}

//Set some filters` values.
;function drawFilters() {
	var filters = getFilterInfo();
	$(".CBodyerTopDate").append(drawFilters_Date(filters.map_filterDate));
	$(".CBodyerTop").append(drawFilters_Picklist(filters.map_filterPickList));
	$(".CBodyerBottom").append(drawFilters_MulPicklist(filters.map_filterMultiple));
}

//Get html of date type filter.
;function drawFilters_Date(map_filterDate) {
	var str = '';
	for (var i = 0; i < map_filterDate.length; i++) {
		var filter = map_filterDate[i];
		str += '<div class="Component" objName="' + filter.objectName + '" filterType="' + filter.filterType + '" uniqueName="' + filter.uniqueName + '">';
		str += '<div class="ComponentName"><div>' + filter.displayName + '</div></div>';
		str += '<div class="ComponentContent">';
		str += '<select id="' + filter.uniqueName + '" class="dateType">';
		if (filter.valuesMap) {
			for (name in filter.valuesMap) {
				str += '<option value="' + name + '">' + filter.valuesMap[name] + '</option>';
			}
		}
		str += '</select>';
		/*str += '<div class="datefixcls fcpickselect dateonlycls">';
		str += '<span class="inputDate tl dateonlycls" alt="Start Date" title="Start Date">';
		str += '<input id="startDate_' + filter.uniqueName + '" type="text" class="startDate">';
		str += '<span class="allimg dateonlycls calendarIcon" style="cursor: default;"></span></span>';
		str += '<span class="allimg title-Arrow dateonlycls"></span>';
		str += '<span class="inputDate tl fix dateonlycls" alt="End Date" title="End Date">';
		str += '<input id="endDate_' + filter.uniqueName + '" type="text" class="endDate">';
		str += '<span class="allimg dateonlycls calendarIcon" style="cursor: default;"></span></span>';
		str += '</div></div></div>';*/
		str += '</div></div>';
	}
	return str;
}

//Get html of picklist type filter.
;function drawFilters_Picklist(map_filterPickList) {
	var str = '';
	for (var i = 0; i < map_filterPickList.length; i++) {
		var filter = map_filterPickList[i];
		str += '<div class="Component" objName="' + filter.objectName + '" filterType="' + filter.filterType + '" uniqueName="' + filter.uniqueName + '">';
		str += '<div class="ComponentName"><div>' + filter.displayName + '</div></div>';
		str += '<div class="ComponentContent">';
		str += '<select id="' + filter.uniqueName + '" class="single">';
		if (filter.valuesMap) {
			for (key in filter.valuesMap) {
				str += '<option value="' + key + '">' + filter.valuesMap[key] + '</option>';
			}
		}
		str += '</select></div></div>';
	}
	return str;
}

//Get html of multiple picklist type filter.
;function drawFilters_MulPicklist(map_filterMultiple) {
	var str = '';
	for (var i = 0; i < map_filterMultiple.length; i++) {
		var filter = map_filterMultiple[i];
		str += '<div class="Component" objName="' + filter.objectName + '" filterType="' + filter.filterType + '" uniqueName="' + filter.uniqueName + '">';
		str += '<div class="ComponentName"><div>' + filter.displayName + '</div></div>';
		str += '<div class="ComponentContent">';
		str += '<div class="Layout"><span class="selecetCell"><div class="selectTitle"><label>Available</label></div>';
		str += '<select id="' + filter.uniqueName + '" multiple="multiple" class="multiple">';
		if (filter.valuesMap) {
			for (key in filter.valuesMap) {
				str += '<option value="' + key + '">' + filter.valuesMap[key] + '</option>';
			}
		}
		str += '</select></span>';
		str += '<span class="buttonCell">';
		str += '<div class="duelingText">Add</div>';
		str += '<div class="ARBtnDiv"><div class="ARBtn Add" mapid="' + filter.uniqueName + '"><div class="ARBtnAdd"></div></div></div>';
		str += '<div class="ARBtnDiv"><div class="ARBtn" mapid="' + filter.uniqueName + '"><div class="ARBtnRemove"></div></div></div>';
		str += '<div class="duelingText">Remove</div></span>';
		str += '<span class="selecetCell"><div class="selectTitle"><label>Selected</label></div>';
		str += '<select id="' + filter.uniqueName + 'Sel" multiple="multiple" class="multiple" >';
        if(i == map_filterMultiple.length -1) {
        str += '<option value="Direct">Direct</option>'
        }
		str += '</select></span></div></div></div>';
	}
	//console.log('str=', str);
	return str;
}

// Bind event for date type filter.
;function datePickerEvt() {
	$("#accordion select.dateType").each(function(index, element) {
		initDateType(this);
	});
	
	// Event for date type. NOTE: Enable start date and end date if change to CUSTOM DATE, and put the old date if have else put today.
	$("#accordion select.dateType").on("change", function(){
		initDateType(this);
	});
	
	
	// Bind event to an input element.
	$("input[id^='startDate'], input[id^='endDate']").each(function(index, element) {
		var dateType = $(this).parents(".ComponentContent").find("select.dateType").val();
		if (dateType === configObj.CUSTOM_DATE) {
			DatePicker.insertDate(DateUtil.formatDate(new Date(), UserContext.dateFormat), $(this).attr("id"));
		}
		dateInputClick(this);
	});
	
	// Bind event to an icon of input element.
	$(".inputDate .calendarIcon").on("click", function(e) {
		var jq_select = $(this).parents(".fcpickselect").siblings(".dateType"),
			jq_input = $(this).siblings("input");
		
		if (jq_select.val() == configObj.CUSTOM_DATE) {
			dateIconClick(this);
		}
	});
	
	;function initDateType(obj) {
		//console.log('initDateType obj= ', obj);
		if ($(obj).val() === configObj.CUSTOM_DATE) {
			var startDate = $(obj).siblings(".dateonlycls").find(".inputDate .startDate");
			var endDate = $(obj).siblings(".dateonlycls").find(".inputDate .endDate");
			
			startDate.removeAttr("disabled");
			endDate.removeAttr("disabled");
			
			startDate.val(DateUtil.formatDate(new Date(), UserContext.dateFormat));
			endDate.val(DateUtil.formatDate(new Date(), UserContext.dateFormat));
			
			$(obj).siblings(".dateonlycls").find(".calendarIcon").off("click").css("cursor", "pointer");
		} else {
			$(obj).siblings(".dateonlycls").find(".inputDate input").val("").attr("disabled", "disabled");
			$(obj).siblings(".dateonlycls").find(".calendarIcon").off("click").css("cursor", "default");
		}
	}
	
	// Bind a SF datePicker to an input element.
	;function dateInputClick(obj) {
		$(obj).off('focus click').on("focus click", function() {
			DatePicker.pickDate(true, $(this).attr("id"), false);
		});
	}


	// Bind a SF datePicker to an icon of an input element.
	;function dateIconClick(obj) {
		var jq_input = $(obj).siblings("input");
		setTimeout(function() {
			console.log('dateIconClick jq_input=', jq_input);
			jq_input.click().focus();
			
		}, 10);
	}
}

// Bind event for left arrow symbol and right arrow symbol.
;function multiSelEvt() {
	$('#accordion , .divFieldSet').on('click', 'div.ARBtn', function() {
		var $mapId = $("#" + $(this).attr("mapId")), 
		$mapIdSel = $('#' + $(this).attr("mapId") + 'Sel');
		if ($mapId[0].disabled) return false;
		if ($(this).hasClass("Add")) {
			$mapId.find("option").each(function() {
				if($(this)[0].selected) {
					$mapIdSel.append($(this));
				}
			});
		} else {
			$mapIdSel.find("option").each(function() {
				if ($(this)[0].selected) {
					$mapId.append($(this));
				}
			});
		}
	});
}

//Bind event for subbox 
;function subboxEvt() {
    var oppyPartPartner = 'opportunity_part__c,opportunity_partner__c';
	$('.BottomView,#oDivL_tableHeader').on('click', '.subbox', function (){
		var $up_tr = $(this).parent('td').parent('tr'),      // find  parent  tr attribute
        	currentOppyId = String($up_tr.attr('Id')),
        	list_oppyId = [],
            isClick = $(this).attr('isClick');
		list_oppyId.push(currentOppyId);
        if(isClick === 'false') {             //  done click  do not search  
        	showMask();    
            APL_CtrlSearchForecastBilling.searchPartAndPartner(filtersObj,JSON.stringify(list_oppyId),oppyPartPartner, function(result, event) {  // find opportunity part and partner 
                if (event.status) {
                    console.log('part and partner ' , result);                   
                    drawPartAndPartnerTalbe(currentOppyId, result, event);
                    //reclone div
                    
                    
                } else {
                    handleError(result, event);
                }
            });
            $(this).attr('isClick',true);   
            $(this).html('-'); 
            hideMask();              // change + to - 
        } else{                              // judge show or hide opportunity part and partner
            if($(this).html() === '-'){
                $(this).html('+');
                $up_tr.next("tr") .hide(); 
                
            }else {
                $(this).html('-');
                $up_tr.next("tr") .show(); 
           }
            
        }
	});
}

function subboxEvtCloneDiv() {
    var oppyPartPartner = 'opportunity_part__c,opportunity_partner__c';
	$('.BottomViewCloneDiv').on('click', '.subbox', function (){
		var $up_tr = $(this).parent('td').parent('tr'),      // find  parent  tr attribute
        	currentOppyId = String($up_tr.attr('Id')).split('_')[0],   	
        	list_oppyId = [],
        	that = $(this),
            isClick = $(this).attr('isClick');
		list_oppyId.push(currentOppyId);
        if(isClick === 'false') {             //  done click  do not search  
        	showMask();    
            APL_CtrlSearchForecastBilling.searchPartAndPartner(filtersObj,JSON.stringify(list_oppyId),oppyPartPartner, function(result, event) {  // find opportunity part and partner 
                if (event.status) {
                    console.log('part and partner ' , result);                   
                    drawPartAndPartnerTalbe(currentOppyId, result, event); 
            		
                    //frozen table 
                    $("#tableHeader").RemoveFrozenTable();
  					$("#tableHeader").FrozenTable(1,0,3);
  					$("#" + currentOppyId + " .subbox, #" + currentOppyId + "_clone .subbox").attr('isClick', true).html('-');
  					console.log("that=", that);
  					subboxEvtCloneDiv();
  					$('#containerPanel_Bottom').scroll();
  					hideMask();                  
                } else {
                    handleError(result, event);
                }
            });
            //$(this).attr('isClick',true);   
            //$(this).html('-'); 
            //hideMask();              // change + to - 
        } else{                              // judge show or hide opportunity part and partner
            if($(this).html() === '-'){
            	console.log("+");
                $(this).html('+');
                $("#" + currentOppyId + " .subbox").html('+');
                //$up_tr.next("tr") .hide();
                //$("."+currentOppyId+"_subcls").hide();
                
                map_oppyid_partPartner[currentOppyId]= $(".BottomViewCloneDiv ."+currentOppyId+"_subcls");               
                $(".BottomViewCloneDiv ."+currentOppyId+"_subcls").remove();
                $(".BottomView ."+currentOppyId+"_subcls").hide(); 
                
            }else {
            	console.log("-");
                $(this).html('-');
                $("#" + currentOppyId + " .subbox").html('-');
                //$(".BottomView ."+currentOppyId+"_subcls").show(); 
                //$('.BottomViewCloneDiv .' + currentOppyId + '_subcls').remove();                
                //resizeCloneDiv(currentOppyId);
                $('.BottomViewCloneDiv #' + currentOppyId + '_clone').after(map_oppyid_partPartner[currentOppyId]);
                $(".BottomView ."+currentOppyId+"_subcls").show(); 
           }
            
        }
	});
}

//resize clone div size
;function resizeCloneDiv(oppyId){
	
	var cloneDiv = $(".BottomView ."+oppyId+"_subcls").clone();
			
	$('.BottomViewCloneDiv #' + oppyId + '_clone').after(cloneDiv);
	
	$('.BottomView .' + oppyId + '_subcls').each(function(index,item){
		var otdHeight = $(this).find('td').eq(1).innerHeight();
		var otdBorder = $(this).find('td').eq(1).css("border-bottom-width");
		console.log("otdHeight= " + otdHeight + ", otdBorder = " + otdBorder);
		
		$('.BottomViewCloneDiv .' + oppyId + '_subcls').eq(index).find('td').eq(1).css('height',otdHeight);
		//$('.BottomViewCloneDiv .' + oppyId + '_subcls').eq(index).find('td').eq(1).css('border-bottom-width',otdBorder);
		//cloneDiv.eq(index).find('td').eq(1).css('height', (otdHeight - 1.111));
	});
	
	cloneDiv.each(function(index,item){
		$(this).find("td:gt(2)").remove();
	});
	
	
		
}

;function  drawPartAndPartnerTalbe (currentOppyId,result, event) {
	//drawPartHeader(currentOppyId);    //draw oppypart and oppypartner  table hearder
	drawPartHeader(currentOppyId); //test
	//drawPartBody(result); //draw oppypart and partner  table body
	drawPartBody(result);            
}

//Show table header(opportunity fields + forecast fields + billing fields).
;function showTableHeader() {
	// TODO
	var $table = $('#tableHeader'), $float_head = $('#floathead'), 
		element_th = '<tr class="">', element_col = '', element_child_col = '', element_td = '<tr>';
	
	$('#fieldhideboxid').remove();
	$table.find('#tab_body').html('').parent().find('col').remove();
	
	element_th += '<th class="thstyle number first" class="thstyle first number"></th>';
	for (fieldKey in map_oppyFileds) {
		element_th += '<th api="' + fieldKey + '" class="thstyle js_oppy th_fix" mark="whiteBG">' + map_oppyFileds[fieldKey] + '</th>';
		element_td += '<td api="' + fieldKey + '" class="tdstyle js_oppy"></td>';
	}
	for (fieldKey in map_fcFileds) {
		element_th += '<th api="' + fieldKey + '" class="thstyle js_fc th_fix" mark="grayBG">' + map_fcFileds[fieldKey] + '</th>';
		element_td += '<td api="' + fieldKey + '" class="tdstyle js_fc"></td>';
	}
	for (fieldKey in map_billFileds) {
		if(fieldKey.indexOf('Bill') >= 0) {
			element_th += '<th api="' + fieldKey + '" class="thstyle js_bill th_fix" mark="whiteBG">' + map_billFileds[fieldKey] + '</th>';
			element_td += '<td api="' + fieldKey + '" class="tdstyle js_bill"></td>';
		}
		else {
            console.log(fieldKey.indexOf('bill'));
			element_th += '<th api="' + fieldKey + '" class="thstyle js_book th_fix" mark="grayBG">' + map_billFileds[fieldKey] + '</th>';
			element_td += '<td api="' + fieldKey + '" class="tdstyle js_book"></td>';
		}
	}
		
	
	element_th += '</tr>';
	element_td += '</tr>';
	
	$table.append(element_col);
	$table.find('#tab_head').html(element_th);
	$table.find('#tab_foot').html(element_td);
	$float_head.html(element_th).parent().find('col').remove();
	$float_head.parent().append(element_col);
	
	//$table_children.find('thead').html(element_th_children).parent().find('col').remove();
	//$table_children.find('tfoot').html(element_td_children).parent().append(element_child_col);
	//$('#containerPanel_Bottom').removeClass('loaddata').off('scroll').on('scroll', event_divTable_scroll);
}



//add event for div 'containerPanel_Bottom' scroll
function event_divTable_scroll(e) {
    
    var $this = $(this)
      , viewH = $this.height()
      , contentH = $this.get(0).scrollHeight
      , scrollTop = $this.scrollTop();
    
    if (scrollTop - 30 < 10) {
        $this.find('#floatTab').hide();
    } else {
        var $ths = $this.find('#tab_head th');
        $this.find('#floatTab').show().css({
            'top': scrollTop
        });
        /*.find('th').each(function(){
    		var fixw=(this.cellIndex != 0 ? 1 : 0);
    		$(this).css({'width': ($ths.eq(this.cellIndex).width())});
    	});*/
    }
}



//Show table  oppy part header.
//Object.getOwnPropertyNames(map_oppyFileds).length    //  Dynamic get oppy fileds length 
/*;function drawPartHeader(oppyId) {
	var part_th = '<tr class="'+oppyId+'_subcls"><td></td><td class="tdsubchildcls" colspan="'+(Object.getOwnPropertyNames(map_oppyFileds).length+Object.getOwnPropertyNames(map_billFileds).length+Object.getOwnPropertyNames(map_fcFileds).length)+'">',   //Assembly  oppy part table
        partner_th = '',    		  //Assembly  oppy partner table
		$table = $('#tableHeader'),   //get iooy table node 
        $table_partner;     		  //get oppy part table node
    
    // TODO  draw part header 
	part_th += '<table id ="'+oppyId+'table_part" class="childTable" oppyId="' + oppyId + '"><thead><tr>';
	for (fieldKey in map_partFileds) {
		part_th += '<th api="' + fieldKey + '" class="js_oppy" mark="whiteBG">' + map_partFileds[fieldKey] + '</th>';
	}
 
    for (fieldKey in map_fcFileds) {
		part_th += '<th api="' + fieldKey + '" class="thstyle js_oppyfc" mark="grayBG">' + map_fcFileds[fieldKey] + '</th>';
	}
	
	 for (fieldKey in map_billFileds) {
         if(fieldKey.indexOf('Bill') >= 0) {
			part_th += '<th api="' + fieldKey + '" class="thstyle js_oppybill" mark="whiteBG">' + map_billFileds[fieldKey] + '</th>';
         }else {
            part_th += '<th api="' + fieldKey + '" class="thstyle js_oppybook" mark="grayBG">' + map_billFileds[fieldKey] + '</th>'; 
         }
	}
	
	part_th += '</tr></thead></table></td></tr>';
	$table.find('#'+oppyId).after(part_th);
    $table_partner =  $('#'+oppyId+'table_part'); 
    
    // TODO  draw partner header 
    partner_th += '<table id ="'+oppyId+'table_partner" class="childTable" oppyId="' + oppyId + '"><thead><tr>';
    for (fieldKey in map_partnerFileds) {
		partner_th += '<th api="' + fieldKey + '" class="js_oppyPartner" mark="whiteBG">' + map_partnerFileds[fieldKey] + '</th>';
	}
	
	 for (fieldKey in map_fcFileds) {
		partner_th += '<th api="' + fieldKey + '" class="thstyle js_oppyfc" mark="grayBG">' + map_fcFileds[fieldKey] + '</th>';
	}
	
	 for (fieldKey in map_billFileds) {
        if(fieldKey.indexOf('Bill') >= 0) {
			partner_th += '<th api="' + fieldKey + '" class="thstyle js_oppybill" mark="whiteBG">' + map_billFileds[fieldKey] + '</th>';
        }else {
            partner_th += '<th api="' + fieldKey + '" class="thstyle js_oppybook" mark="grayBG">' + map_billFileds[fieldKey] + '</th>';
        }
	}
	
    partner_th += '</tr></thead></table>';
    $table_partner.after(partner_th);
}
*/

//Show table  oppy part header.
//Object.getOwnPropertyNames(map_oppyFileds).length    //  Dynamic get oppy fileds length 
;function drawPartHeader(oppyId) {
	var part_th = '<tr id ="'+oppyId+'table_part" class="'+oppyId+'_subcls"><td class="number"></td>',//Assembly  oppy part table
        partner_th ='<tr id ="'+oppyId+'table_partner" class="'+oppyId+'_subcls"><td class="number"></td>',    		  //Assembly  oppy partner table
		$table = $('#tableHeader'),   //get iooy table node 
        $table_partner;     		  //get oppy part table node
    
    // TODO  draw part header 
	for (fieldKey in map_partFileds) {
		part_th += '<td api="' + fieldKey + '" class="js_oppy thstyle" mark="whiteBG">' + map_partFileds[fieldKey] + '</td>';
	}
 
    for (fieldKey in map_fcFileds) {
		part_th += '<td api="' + fieldKey + '" class="thstyle js_oppyfc" mark="grayBG">' + map_fcFileds[fieldKey] + '</td>';
	}
	
	 for (fieldKey in map_billFileds) {
         if(fieldKey.indexOf('Bill') >= 0) {
			part_th += '<td api="' + fieldKey + '" class="thstyle js_oppybill" mark="whiteBG">' + map_billFileds[fieldKey] + '</td>';
         }else {
            part_th += '<td api="' + fieldKey + '" class="thstyle js_oppybook" mark="grayBG">' + map_billFileds[fieldKey] + '</td>'; 
         }
	}
	
	part_th += '</tr>';
	$table.find('#'+oppyId).after(part_th);
    $table_partner =  $('#'+oppyId+'table_part'); 
    
    // TODO  draw partner header 
    for (fieldKey in map_partnerFileds) {
		partner_th += '<td api="' + fieldKey + '" class="js_oppyPartner thstyle" mark="whiteBG">' + map_partnerFileds[fieldKey] + '</td>';
	}
	
	 for (fieldKey in map_fcFileds) {
		partner_th += '<td api="' + fieldKey + '" class="thstyle js_oppyfc" mark="grayBG">' + map_fcFileds[fieldKey] + '</td>';
	}
	
	 for (fieldKey in map_billFileds) {
        if(fieldKey.indexOf('Bill') >= 0) {
			partner_th += '<td api="' + fieldKey + '" class="thstyle js_oppybill" mark="whiteBG">' + map_billFileds[fieldKey] + '</td>';
        }else {
            partner_th += '<td api="' + fieldKey + '" class="thstyle js_oppybook" mark="grayBG">' + map_billFileds[fieldKey] + '</td>';
        }
	}
	
    partner_th += '</tr>';
    $table_partner.after(partner_th);
}


//Click 'Search' button.
;function searchData() {   
	showMask();
	filtersObj = getFiltersValue();
	oppyTotal = 0; // Reset this when click search.
	var oppyIds = [];
	console.log("searchData filtersObj =", filtersObj);
	
	$("#tableHeader").RemoveFrozenTable();
	// The first invoke, get all oppy Ids and to search theirs forecasts and billings.
	console.log('111111111111111111111111111111111111 searchData');
	APL_CtrlSearchForecastBilling.doSearch(filtersObj, JSON.stringify(oppyIds), function(result, event) {
		if (event.status) {
			$('#tab_body').children().remove();
			oppyTotal = 0;
			handleResult(result, filtersObj, event); 
			//hideMask();
		} else {
			handleError(result, event);
		}
	});
}


// Get a json string.
;function getFiltersValue() {
	var filters = [], objs = configObj.OBJS;
	
	for (var i = 0; i < objs.length; i++) {
		var filterValue = {objectName: objs[i]};
		
		$(".Component[objname='" + objs[i] + "']").each(function(index, element) {
			var apiName = $(this).attr('uniqueName');
			
			if (filterValue.queryString) {
				var str = getQueryStr(this,filterValue);
				if (str) {
					filterValue.queryString += ' AND ' + str;
				}
			} else { // First data
				filterValue.queryString = getQueryStr(this,filterValue);
			}
		});
		filters.push(filterValue)
	}
	
	return filters;
}

// 
;function getQueryStr(domEle, filterValue) {
	var filterType = $(domEle).attr("filterType"),
		apiName = $(domEle).attr("uniqueName"),
		str = "";
	
	//console.log("getQueryStr apiName=", apiName);
	if (filterType === "date") {
		var val = $("#" + apiName).val();
		if (val.toLowerCase() === "none") return "";
		
		// TODO: if CUSTOM_DATE.
        if(val === "Custom Date") {
            filterValue.valueMap = { Won_Date__c : 'Custom Date;'+$("#startDate_Won_Date__c").val()+';'+$("#endDate_Won_Date__c").val()};
            return "";
        }
		//console.log('time :: ',filterValue.valueMap); 
		str += configObj.map_wd[val];
	}
	if (filterType === "pickList") {
		var val = $("#" + apiName).val();
		if (val.toLowerCase() === "none") return "";
		if (configObj.map_api_query[apiName]) {
			str += configObj[configObj.map_api_query[apiName]][val];
		} else {
			str += apiName + '=\'' + val + '\'';
		}
	}
	if (filterType === "multiplePickList") {
		var val = ""; //$("#" + apiName + "Sel").val();
		$("#" + apiName + "Sel option").each(function(index, element) {
			if (val) {
				val += ",\'" + $(this).val() + "\'";
			} else {
				val += "\'" + $(this).val() + "\'";
			}
		});
		if(apiName === 'Account_Manager__c' ){
			apiName = 'Account.Account_Manager__c';
		}
		if (val) {
			str += apiName + ' IN(' + val + ')';
		}
	}
	//console.log("getQueryStr str=", str);
	return str;
}

// Handle result.
//SEARCH 1: 
// 1.1 map_record == null AND set_oppyId2Js == null;	(N = 0, No records!);
// 1.2 map_record == null AND set_oppyId2Js > 0;		(N > 100);
// 1.3 map_record > 0 AND set_oppyId2Js == null;		(1 < N <= 100); 
// SEARCH 2: 
// 2.1 map_record > 0 AND set_oppyId2Js == null;		(100 * X);
;function handleResult(result, filtersObj, event) {
	
	// If success 
    if((result.length == 0) || result[0].message != '') {                    //N = 0, No records!
        alert('No records!');
        hideMask();
   
    } else if(result[0].set_oppyId2Js.length > 0){  						//N > 100
    	console.log("handleResult 1111111111111111111111111111 result N > 100 =", result[0]);
        // Cut oppy ids into batches.
		// and send request asynamically.
        segmentIds(result[0].set_oppyId2Js, filtersObj);
		
    }  else {                                       						//1 < N <= 100
       // console.log('draw Table now ');
    	console.log("handleResult 1111111111111111111111111111 result <= 100");
        drawTableBody(result);
        oppyTotal = result.length;
        $(".number").text(oppyTotal);
        //freeze table
        $("#tableHeader").FrozenTable(1,0,3);
        subboxEvtCloneDiv();
       
        hideMask();
    }
}


;function handleError(result, event) {
	console.log("handleError result=", result);
	console.log("handleError event=", event);
	// alert message.
	alert(event.message);
	hideMask();
	
}

// Cut oppy ids into batches. 
// See: APL_CtrlManagerAPLFilterJS.forecastFilter.getIdGroup()
;function segmentIds(ids, filtersObj) {  
	var list_action = [];
	// TODO: 
	for(var i=0; i<ids.length; i+=100){
		var list_oppyIds=ids.slice(i,i+100);
		list_action.push(list_oppyIds);
	}
	
	console.log("segmentIds list_action=", list_action);
    async.eachSeries(list_action, function(item, callback) {       //asynchronous call
        setTimeout(function(){
            searchDataLoop(item, filtersObj, callback, item[0], false);   // Do search
            //callback(null);
        }, 100);
        }, function(err){
        	console.log("qqqq all done / err, err=", err);
        	console.log("length1111:",$('.LoadingDiv').find('.statusSpan.opp').length);
        	if($('.LoadingDiv').find('.statusSpan.error').length == 0){
        		// Write total of oppy.
        		$("#tableHeader").RemoveFrozenTable();
        		$("#tableHeader").FrozenTable(1,0,3);
        		subboxEvtCloneDiv();
        		hideMask();
        		$(".number").text(oppyTotal);
    	    	list_action=[];
    	    	$('.LoadingDiv').find('.statusSpan.opp').remove();
			}

	});
}

//Loop serch opportunity 
;function searchDataLoop(oppyIds, filtersObj, callback, oppyId, isError) {   //oppyids   or   []
	//var filtersObj = getFiltersValue();
	console.log('searchDataLoop  222222222222222222222222222222222222222 ');
	
	if(isError) {
		$('.LoadingDiv').find('span.error[data_id="opp_'+oppyId+'"]').eq(0).removeClass().addClass('statusSpan opp');
		countError ++;
	}else {
		$('.LoadingDiv').append('<span class="statusSpan opp" data_id="opp_'+oppyId+'"></span>');
	}
	var $status_cell=$('.LoadingDiv').find('span.statusSpan[data_id="opp_'+oppyId+'"]').eq(0);
    APL_CtrlSearchForecastBilling.doSearch(filtersObj, JSON.stringify(oppyIds), function(result, event) {
       console.log('searchDataLoop result = ', result);
		if(event.status && result[0].message == '') {    							// Need to return all have data to draw 
           //console.log('result : ',result);
           console.log('oppyId : ',oppyId);
			drawTableBody(result);
			oppyTotal = oppyTotal + result.length;
			$status_cell.animate({backgroundColor: '#51C957'}, 130, function(){     // search succeed  square  chage color
				$status_cell.parent().find('b.reload_img').off('click').remove();
			});
			
		} else {
           if(!event.status) {
        	   $status_cell.removeClass().addClass('statusSpan error');
        	   $status_cell.css({'cursor': 'pointer'})
				.animate({backgroundColor: '#C95151'}, 230).off('click').on('click', function(e){    // search fail  square  chage color
					e.stopPropagation();
					$(this).off('click');
					$status_cell.animate({backgroundColor: '#517BC9'}, 130).css({'cursor': 'default'}).find('b').remove();
					searchDataLoop(oppyIds, filtersObj, callback, oppyId, true); 
				}).append('<b class="ref_msg">'+event['message']+'</b>');
           }    
		}
		callback(null);
	});
  
}

// Draw  opportunity table body.
;function drawTableBody(data) {
	// TODO: 
	//console.log('data : ', data);
	for (var i = 0; i < data.length; i++) {
		$('#tableHeader #tab_body').append(getRowString(data[i], i + 1 + oppyTotal));
	}
}


// Get oppy row string.
;function getRowString(rowData, rowIndex) {
	var data = rowData.map_record;
	var row = '<tr id="' + rowData.oppyId + '" >';
	// 1. dynamic draw oppy row.
	try {
		row += '<td><span class="snnew">' + rowIndex + '</span><b class="subbox" isClick="false">+</b></td>';
		$('#tab_head tr th').not(".number").each(function(index, element) {	
			var apiName = $(this).attr('api');
            var mark = $(this).attr('mark');
             if(mark === 'whiteBG'){
            	if(data[apiName] != undefined ) {   // if no data
                    if (apiName == links[0]) {
                        row += '<td api="' + apiName + '" class="tdstyle"><a href="/' + rowData.oppyId + '" target="view_window" >' + data[apiName] + '</a></td>';
                    } else if (apiName == links[1]) {
                    	row += '<td api="' + apiName + '" class="tdstyle"><a href="/' + rowData.map_record.acctId + '"target="view_window" >' + data[apiName] + '</td>';
                    } else {
                        row += '<td api="' + apiName + '" class="tdstyle">' + commafy(data[apiName]) + '</td>';
                    }
                }else{
                    row += '<td api="' + apiName + '" class="tdstyle">' + '-'+ '</td>';
                }
            	
            }else { 								// if no data  show   0
                if(data[apiName] != undefined ) {   // if no data
                 row += '<td api="' + apiName + '" class="tdstyle grayBG">' +  commafy(data[apiName]) + '</td>';
                }else{
                    row += '<td api="' + apiName + '" class="tdstyle grayBG">' +  '-' + '</td>'; 
                }
            }
			
		});

		
	} catch (ex) {
		// console.log('draw table body error:', ex);
		return row + '<td spanCol="' + data[0].length + '"</td></tr>';
	}
	row += '</tr>';
	return row;
}

//Draw  oppy part and partner  table body
/*;function drawPartBody(data) {
	// TODO: 
	for (var i = 0; i < data.length; i++) {
    	if(data[i].objectName === 'Opportunity_Part__c') {
        	$('#'+data[i].oppyId+'table_part').append(getPartRowString(data[i]));
            
        }else{
            $('#'+data[i].oppyId+'table_partner').append(getPartnerRowString(data[i]));
        } 
	}
}
*/
//Draw  oppy part and partner  table body
;function drawPartBody(data) {
	// TODO: 
	for (var i = 0; i < data.length; i++) {
    	if(data[i].objectName === 'Opportunity_Part__c') {
        	$('#'+data[i].oppyId+'table_part').after(getPartRowString(data[i]));
            
        }else{
            $('#'+data[i].oppyId+'table_partner').after(getPartnerRowString(data[i]));
        } 
	}
}

// Get part row string.
/*;function getPartRowString(rowData) {
	var data = rowData.map_record;
	var row = '<tr id="' + rowData.objectId + '" >';
	 // 1. dynamic draw oppy part row.
	try {        
       $('#'+rowData.oppyId+'table_part tr th').each(function(index, element) {	
			var apiName = $(this).attr('api');
            var mark = $(this).attr('mark');      //mark back ground color 
           if(mark === 'whiteBG') {
               //row += '<td api="' + apiName + '" class="tdstyle">' + data[apiName] + '</td>';
        	   if(apiName!=='Part_Number__c' && apiName!=='Won_Date__c' &&apiName !=='GPL_Name__c'){
        		   row += '<td api="' + apiName + '" class="">' + commafy(data[apiName]) + '</td>'; 
        	   }else{
        		   row += '<td api="' + apiName + '" class="">' + data[apiName] + '</td>';
        	   }
              
           }else {
             row += '<td api="' + apiName + '" class="grayBG">' + commafy(data[apiName]) + '</td>';
           }		
		});
		
	} catch (ex) {
		return row + '<td spanCol="' + data[0].length + '"</td></tr>';
	}
	row += '</tr>';
	return row;
}*/

// Get part row string.
;function getPartRowString(rowData) {
	var data = rowData.map_record;
	var row = '<tr id="' + rowData.objectId + '" class="' + rowData.oppyId + '_subcls"><td></td>';
	 // 1. dynamic draw oppy part row.
	try {        
       $('#'+rowData.oppyId+'table_part td').not(".number").each(function(index, element) {	
			var apiName = $(this).attr('api');
            var mark = $(this).attr('mark');      //mark back ground color 
           if(mark === 'whiteBG') {
               //row += '<td api="' + apiName + '" class="tdstyle">' + data[apiName] + '</td>';
        	   if(apiName!=='Part_Number__c' && apiName!=='Won_Date__c' && apiName !=='GPL_Name__c' && apiName !=='Part_Number_txt__c' ){
        		   row += '<td api="' + apiName + '" class="tdstyle">' + commafy(data[apiName]) + '</td>'; 
        	   }else{
        		   row += '<td api="' + apiName + '" class="tdstyle">' + data[apiName] + '</td>';
        	   }
              
           }else {
             row += '<td api="' + apiName + '" class="tdstyle grayBG">' + commafy(data[apiName]) + '</td>';
           }

		});
		
	} catch (ex) {
		return row + '<td spanCol="' + data[0].length + '"</td></tr>';
	}
	row += '</tr>';
	return row;
}

//To convert data permil format
;function  commafy(num){  
    num  =  num+"";  
    var  re=/(-?\d+)(\d{3})/  
    while(re.test(num)){  
                num=num.replace(re,"$1"+thousandSep+"$2")  
    }  
    return  num;  
} 

// Get partner row string.
/*;function getPartnerRowString(rowData) {
    var data = rowData.map_record;
	var row = '<tr id="' + rowData.objectId + '" >';
	 // 1. dynamic draw oppy part row.
	try {        
       $('#'+rowData.oppyId+'table_partner tr th').each(function(index, element) {	
			var apiName = $(this).attr('api');
            var mark = $(this).attr('mark');         			//mark back ground color
           if(mark === 'whiteBG'){
                if(apiName === 'Partner_Account_Name__c'  ) {   //partner link to current partner page
                   row += '<td api="' + apiName + '" class=""><a href="/' + rowData.objectId + '" target="view_window" >' + data[apiName] + '</td>';
                }else if(apiName === 'Partner_Account_Number__c'  ) { 
                   row += '<td api="' + apiName + '" class="">' + data[apiName] + '</td>';
           		}else{
           			row += '<td api="' + apiName + '" class="">' + commafy(data[apiName]) + '</td>';
           		}
           }else {
                row += '<td api="' + apiName + '" class="grayBG">' + commafy(data[apiName]) + '</td>';
           }
          
		});
		
	} catch (ex) {
		return row + '<td spanCol="' + data[0].length + '"</td></tr>';
	}
	row += '</tr>';
	return row;
}
*/
// 

// Get partner row string.
;function getPartnerRowString(rowData) {
    var data = rowData.map_record;
	var row = '<tr id="' + rowData.objectId + '" class="' + rowData.oppyId + '_subcls"><td></td>';
	 // 1. dynamic draw oppy part row.
	try {        
       $('#'+rowData.oppyId+'table_partner td').not(".number").each(function(index, element) {	
			var apiName = $(this).attr('api');
            var mark = $(this).attr('mark');         			//mark back ground color
           if(mark === 'whiteBG'){
                if(apiName === 'Partner_Account_Name__c'  ) {   //partner link to current partner page
                   row += '<td api="' + apiName + '" class="tdstyle"><a href="/' + rowData.objectId + '" target="view_window" >' + data[apiName] + '</td>';
               }else if(apiName === 'Partner_Account_Number__c'  ) { 
                   row += '<td api="' + apiName + '" class="tdstyle">' + data[apiName] + '</td>';
           		}else{
           			row += '<td api="' + apiName + '" class="tdstyle">' + commafy(data[apiName]) + '</td>';
           		}
           }else {
                row += '<td api="' + apiName + '" class="tdstyle grayBG">' + commafy(data[apiName]) + '</td>';
           }
          
			
		});
		
	} catch (ex) {
		return row + '<td spanCol="' + data[0].length + '"</td></tr>';
	}
	row += '</tr>';
	return row;
}

// event export of page 
;function exportStart() {
	// TODO: 
	showMask();
	searchDataToExport();  // Search date to export 
	
}
//search data 
;function searchDataToExport() {   
	
	filtersObj = getFiltersValue();
	var oppyIds = [];
	
	//search opportunity data
	APL_CtrlSearchForecastBilling.doSearch(filtersObj, JSON.stringify(oppyIds), function(result, event) { 
		if (event.status) {
			handleResult_export(result, filtersObj, event);     // handle result  
		} else {
			handleError_export(result, event);
		}
	});
	
}

//Get the part data through an asynchronous method
;function searchPart(oppyIds, filtersObj, callback, oppyId, isError){
	filtersObj = getFiltersValue();
	var str_partOrPart ='opportunity_part__c';
	if(isError) { // is error square clicked 
		$('.LoadingDiv').find('span.error[data_id="part_'+oppyId+'"]').eq(0).removeClass().addClass('statusSpan part');
		countError --;
	}else{
		$('.LoadingDiv').append('<span class="statusSpan part" data_id="part_'+oppyId+'"></span>');
	}
	var $status_cell=$('.LoadingDiv').find('span.statusSpan[data_id="part_'+oppyId+'"]').eq(0);
	//search opportunity part  data
	APL_CtrlSearchForecastBilling.searchPartAndPartner(filtersObj,JSON.stringify(oppyIds),str_partOrPart, function(result, event) {
		if (event.status) {
			//console.log('part result :',result);
			generateData(result,str_partOrPart);                         							// generate Data  
			$status_cell.animate({backgroundColor: '#51C957'}, 130, function(){                     // search succeed  square  chage color
				$status_cell.parent().find('b.reload_img').off('click').remove();
			});
		
		} else {
			console.log('Error to search opportunity part');
			countError ++;
			//handleError_export(result, event);
      	   	$status_cell.removeClass().addClass('statusSpan error');
      	   	$status_cell.css({'cursor': 'pointer'})
				.animate({backgroundColor: '#C95151'}, 230).off('click').on('click', function(e){   // search fail  square  chage color
					e.stopPropagation();
					$(this).off('click');
					$status_cell.animate({backgroundColor: '#517BC9'}, 130).css({'cursor': 'default'}).find('b').remove();
					searchPart(oppyIds, filtersObj, callback, oppyId, true); 
				}).append('<b class="ref_msg">'+event['message']+'</b>');
		}
		callback(null);
	});	
}

//Get the partner data through an asynchronous method
;function searchPartner(oppyIds, filtersObj, callback, oppyId, isError){
	filtersObj = getFiltersValue();
	var str_partOrPartner ='opportunity_partner__c';
	if(isError){
		$('.LoadingDiv').find('span.error[data_id="partner_'+oppyId+'"]').eq(0).removeClass().addClass('statusSpan partner');
		countError --;
	}else {
		$('.LoadingDiv').append('<span class="statusSpan partner" data_id="partner_'+oppyId+'"></span>');
	}
	var $status_cell=$('.LoadingDiv').find('span.statusSpan[data_id="partner_'+oppyId+'"]').eq(0);
	//search opportunity  partner data
	APL_CtrlSearchForecastBilling.searchPartAndPartner(filtersObj,JSON.stringify(oppyIds),str_partOrPartner, function(result, event) {
		
		if (event.status) {
			generateData(result,str_partOrPartner);                      // generate Data 
			$status_cell.animate({backgroundColor: '#51C957'}, 130, function(){
				$status_cell.parent().find('b.reload_img').off('click').remove();
			});
		} else {
			//handleError_export(result, event);                        // alert error message 
			countError ++;
      	   	$status_cell.removeClass('').addClass('statusSpan error');
      	   	$status_cell.css({'cursor': 'pointer'})
				.animate({backgroundColor: '#C95151'}, 230).off('click').on('click', function(e){
					e.stopPropagation();
					$(this).off('click');
					$status_cell.animate({backgroundColor: '#517BC9'}, 130).css({'cursor': 'default'}).find('b').remove();
					searchPartner(oppyIds, filtersObj, callback, oppyId, true); 
				}).append('<b class="ref_msg">'+event['message']+'</b>');
		}
		callback(null);
	});
}


//handle  search  opportunity result  to exprort 
;function handleResult_export(result, filtersObj, event){ 
	// If success 
    if((result.length == 0) || result[0].message != '') {             //N = 0, No records!
        alert(result[0].message);
        hideMask();
        
    } else if(result[0].set_oppyId2Js.length > 0){  				  //N > 100
    	
        segmentIds_export(result[0].set_oppyId2Js, filtersObj);
		
    }  else {                                      					 //1 < N <= 100
    	 console.log("export result now  where result <= 100",result);
    	 for(var i=0; i<result.length; i++ ) {      				 // Store searched opportunity id to in oppyIds array	
  			
             oppyIds_export.push(result[i].oppyId);
  		 }
		 generateData(result,'opportunity');
         exoprtData(LIST_CSVOPPY,'apl_opportunity_billing.csv');
         LIST_CSVOPPY ={};
         dataArry =[];
         segmentOppyIds_part(oppyIds_export,filtersObj);            //start to export part data  when oppy id <100 
    }
}
var LIST_CSV=[] ;
var oppyIds_export=[];
var LIST_CSVOPPY={},dataArry = [],countError = 0;

var arry_oppFiled = ["Opportunity_Number__c","Name","Account.Account_Combined_Data__c","Customer_Region__c","Customer_Country__c",
                     "GAM_Code__c","Account_Manager__c","Field_Engineer_Name__c","New_Business_Percentage__c","Initial_12_months__c",
                     "FY"+(fiscalYear-1),"FY"+fiscalYear+"_Q1","FY"+fiscalYear+"_Q2","FY"+fiscalYear+"_Q3","FY"+fiscalYear+"_Q4","FY"+fiscalYear,"FY"+(fiscalYear+1),"Bill_Prior_Year_1_Amount_Document__c",
                     "Bill_Prior_Year_1_to_Date_Amount_Do__c","Bill_Prior_Year_Amount_USD__c","Bill_Prior_Year_to_Date_Amount_USD__c",
                     "Bill_Year_to_Date_Amount_USD__c","Billing_Diff_Vs_Pre_FY","Bill_Forecast_Achieve_Ratio","Book_Prior_Year_Amount_USD__c",
                     "Book_Prior_Year_To_Date_Amount_USD__c","Book_Year_to_Date_Amount_USD__c","Booking_Diff_Vs_Pre_FY"];

var arry_partFiled = ["opportunity","oppyName","oppyNumber","Part_Number__c","Won_Date__c","Account_Name__c","Customer_Region__c","CBC_1_Name__c","CBC_2_Name__c","GPL_Name__c",
                     "Product_Code_Name__c","Opportunity_owner__c","Part_Number_txt__c","Initial_12_months__c",
                     "FY"+(fiscalYear-1),"FY"+fiscalYear+"_Q1","FY"+fiscalYear+"_Q2","FY"+fiscalYear+"_Q3","FY"+fiscalYear+"_Q4","FY"+fiscalYear,"FY"+(fiscalYear+1),"Bill_Prior_Year_1_Amount_Document__c",
                     "Bill_Prior_Year_1_to_Date_Amount_Do__c","Bill_Prior_Year_Amount_USD__c","Bill_Prior_Year_to_Date_Amount_USD__c",
                     "Bill_Year_to_Date_Amount_USD__c","Billing_Diff_Vs_Pre_FY","Bill_Forecast_Achieve_Ratio","Book_Prior_Year_Amount_USD__c",
                     "Book_Prior_Year_To_Date_Amount_USD__c","Book_Year_to_Date_Amount_USD__c","Booking_Diff_Vs_Pre_FY"];

var arry_partnerFiled = ["opportunity","oppyName","oppyNumber","Partner_Account_Name__c","Partner_Role__c","Allocation__c", "Partner_Account_Number__c",
                     "Partner_Region__c","Partner_Country__c","Partner_GAM_Code__c","Partner_Account_Manager__c","Partner_City__c","Opportunity_Owner__c","Initial_12_months__c",
                     "FY"+(fiscalYear-1),"FY"+fiscalYear+"_Q1","FY"+fiscalYear+"_Q2","FY"+fiscalYear+"_Q3","FY"+fiscalYear+"_Q4","FY"+fiscalYear,"FY"+(fiscalYear+1),"Bill_Prior_Year_1_Amount_Document__c",
                     "Bill_Prior_Year_1_to_Date_Amount_Do__c","Bill_Prior_Year_Amount_USD__c","Bill_Prior_Year_to_Date_Amount_USD__c",
                     "Bill_Year_to_Date_Amount_USD__c","Billing_Diff_Vs_Pre_FY","Bill_Forecast_Achieve_Ratio","Book_Prior_Year_Amount_USD__c",
                     "Book_Prior_Year_To_Date_Amount_USD__c","Book_Year_to_Date_Amount_USD__c","Booking_Diff_Vs_Pre_FY"];

//generateData
;function generateData(data,str) {
    //console.log('data',data);
    //console.log('str',str);
    if(str==='opportunity') {       //Export opportunity data
    	 while(data.length > 0){ 
    		var o ={},object=data.shift().map_record;
            
             for(var key in object){
            	o[key] = object[key];
            }
            dataArry.push(o);
            LIST_CSVOPPY.data = dataArry;
    	}
    	 LIST_CSVOPPY.fields = arry_oppFiled;
    }else {                         //Export opportunity  part and partner data
    	 while(data.length > 0){
		 	var oppyId = data[0].oppyId;
		 	var oppyName = data[0].oppyName;
		 	var oppyNumber = data[0].oppyNumber;
		 	var o ={},  object=data.shift().map_record;
		 	o.opportunity = oppyId;
		 	o.oppyName = oppyName;
		 	o.oppyNumber = oppyNumber;
	        for(var key in object){
                o[key] = object[key]; 
            }
	        dataArry.push(o);
            LIST_CSVOPPY.data = dataArry; 
    	    }
    	 if(str==='opportunity_part__c'){
        	 LIST_CSVOPPY.fields = arry_partFiled;
        }else{
        	LIST_CSVOPPY.fields = arry_partnerFiled;
        }
    }
   
   
}

;function handleError_export(result, event) {
    console.log("handleError event=", event);
	// alert message.
	alert(event.message);
}

//The asynchronous invocation method of background data
;function segmentIds_export(ids, filtersObj) { 
	var list_action = [];
	// TODO: 
	for(var i=0; i<ids.length; i+=100){
		var list_oppyIds=ids.slice(i,i+100);
		list_action.push(list_oppyIds);
	}
	
	console.log("segmentIds list_action=", list_action);
    async.eachSeries(list_action, function(item, callback) {                       //asynchronous call
        setTimeout(function(){
            searchDataLoop_export(item, filtersObj, callback, item[0], false);     // Do search   opportunity
        }, 100);
        }, function(err){
        	console.log("search data all done / err, err=", err);
        	if(countError == 0) {
            	exoprtData(LIST_CSVOPPY,'apl_opportunity_billing.csv');            //export csv file
            	LIST_CSVOPPY = {};
            	dataArry =[];
            	segmentOppyIds_part(oppyIds_export,filtersObj);                    //Start to export partner data when oppy id >100
    	    	list_action=[];
        	}	
	});

}

// segment oppy id invok searchPart mothed 
;function segmentOppyIds_part(ids, filtersObj) {
	var list_action = [];
	for(var i=0; i<ids.length; i+=10){
		var list_oppyIds=ids.slice(i,i+10);
		list_action.push(list_oppyIds);
	}
	
	//console.log("segmentIds list_action=", list_action);
    async.eachSeries(list_action, function(item, callback) {            //asynchronous call
        setTimeout(function(){
        	searchPart(item, filtersObj, callback, item[0], false);     // Do search  part 
        }, 100);
        }, function(err){
        	console.log("search data part done / err, err=", err);
        	//??csv ??
        	if(countError == 0){										
        		exoprtData(LIST_CSVOPPY,'apl_opportunity_billing_part.csv');
            	LIST_CSVOPPY = {};
            	dataArry =[];
            	segmentOppyIds_partner(oppyIds_export,filtersObj);		 //Start to export partner data when oppy id <100
    	    	list_action=[];
        	}
        	
	});

}

//segment oppy id invok searchPartner mothed 
;function segmentOppyIds_partner(ids, filtersObj) {
	//console.log("segmentOppyIds_partner");
	var list_action = [];
	// TODO: 
	for(var i=0; i<ids.length; i+=100){
		var list_oppyIds=ids.slice(i,i+100);
		list_action.push(list_oppyIds);
	}
	
	console.log("segmentIds list_action partner =", list_action);
    async.eachSeries(list_action, function(item, callback) {                       //asynchronous call
        setTimeout(function(){
        	searchPartner(item, filtersObj, callback, item[0], false);             // Do search partner
        }, 100);
        }, function(err){
        	console.log("search data partner done / err, err=", err);
        	console.log("countError partner ::", countError);                       //??csv ??
        	if(countError == 0) {
        		exoprtData(LIST_CSVOPPY,'apl_opportunity_billing_partner.csv');
            	LIST_CSVOPPY = {};
            	dataArry = [];
            	if($('.LoadingDiv').find('.statusSpan.error').length == 0){
            		hideMask();
        	    	list_action=[];
        	    	oppyIds_export =[];
        	    	$('.LoadingDiv').find('.statusSpan').remove();
    			}	
        	}
        	
	});

}
// loop call doSearch method get opportunity data
;function searchDataLoop_export(oppyIds, filtersObj, callback, oppyId, isError) {
	if(isError) {
		$('.LoadingDiv').find('span.error[data_id="opp_'+oppyId+'"]').eq(0).removeClass().addClass('statusSpan opp');
		countError ++;
	}else {
		$('.LoadingDiv').append('<span class="statusSpan opp" data_id="opp_'+oppyId+'"></span>');
	}
	var $status_cell=$('.LoadingDiv').find('span.statusSpan[data_id="opp_'+oppyId+'"]').eq(0);
	
   APL_CtrlSearchForecastBilling.doSearch(filtersObj, JSON.stringify(oppyIds), function(result, event) {
		if(event.status && result[0].message == '') {    				// Need to return all have data to export 
			for(var i =0; i<result.length; i++ ) {       				// Store searched opportunity id to in oppyIds array
				oppyIds_export.push(result[i].oppyId);
			}
			generateData(result,'opportunity');                        //Converts the results to generate CSV file data		 
			$status_cell.animate({backgroundColor: '#51C957'}, 130, function(){
				$status_cell.parent().find('b.reload_img').off('click').remove();
			});
		} else {
           if(!event.status) {
        	   countError ++;
         	   $status_cell.removeClass().addClass('statusSpan error');
         	   $status_cell.css({'cursor': 'pointer'})
 				.animate({backgroundColor: '#C95151'}, 230).off('click').on('click', function(e){
 					e.stopPropagation();
 					$(this).off('click');
 					$status_cell.animate({backgroundColor: '#517BC9'}, 130).css({'cursor': 'default'}).find('b').remove();
 					searchDataLoop_export(oppyIds, filtersObj, callback, oppyId, true); 
 				}).append('<b class="ref_msg">'+event['message']+'</b>');
           }    
		}
		callback(null);
	});
}

// export date method 
;function exoprtData(data,fileName){
    console.log('exportDate method come in!! ');
    var	blob=new Blob([Papa.unparse(data)], { type: 'text/csv;charset=utf-8'});
	saveAs(blob, fileName);
}

// Show a mask during executing a action.
;function showMask() {
	$(".LoadingDiv").show();
}

// Hide mask after finished an action.
;function hideMask() {
	$(".LoadingDiv").hide();
}
//*********************** ChenChen End **************************//

