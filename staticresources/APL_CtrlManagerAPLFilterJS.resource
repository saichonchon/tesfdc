var forecastFilter={
	// Attributes: For Filter  ***** TOP *******//
	data: {},
	data_bak: [],
	fieldSet_bak: {},
	hasSearched: false,
	mapFilterId_filter: {},
	mapCategory_filters: {},
	tempSelData : [],
	templates : [],
	template : {},
	loadingImg: "{!$Resource.LoadingImg}",
	CUSTOM_DATE : "Custom Date",
	SEARCH_EXCLUSION : "Other BU Products",
	TIPS : ["--Please Select--",  "--Please Select Template--"],
	FILTER_TYPES : ["Picklist", "MultiPicklist", "Date", "Year", "Checkbox", "Text"],
	// Attributes: For Filter  ***** BOTTOM *******//
	
	map_index_oppyIds: {}, // Query forecast one batch by one batch.
	searchGroupIndex: 0,
	mappingIds_bak: "",
	jsonidprops_bak: "",
	
	// Attributes: For Search  ***** TOP *******//
	SEPERATOR : ["-"],
	SPECIAL_FILTERS : ["PLM Project No"],
	SPECIAL_API : ["Opportunity_Number__c"],
	mainTableHeight : 600,
	filterCategory: "Forecast Category", // Used for make forecast column name.
	fcByWhat: ["By Year", "By Quarter"],
	fcCategory: {"Standard Opportunity Forecast": "", "Weighted Forecast": "Wt", "New Business forecast": "NB", "Weighted New Business": "Wt NB", 
	             "NPS1 Forecast": "NPS1", "NPS2 Forecast": "NPS2", "NPS3 Forecast": "NPS3","Asia MSG": "MSG1"},//added by nelson zheng for case 00897724 add "Asia MSG": "MSG1"
	getFieldSets: function() {return oppytypes;},
	oppyFields: [], // All oppy feilds.
	fixedFieldSetName: "Opportunity",
	tableId: "inlineTable_Bottom",
	childFields: [],
	// Attributes: For Search  ***** BOTTOM *******//
	
	
	
	
	init: function(data, jsontemplates) {
		this.makeDataMap(data);
		var loadStr = '<div class="ITTLoadingDiv" id="ITTLoadingDiv"><img class="ITTLoadingImg" src="'+imgSrc+'" title="Please Wait..."/></div>';
		
		this.data = data;
		this.data_bak = backupData(data);
		this.fieldSet_bak.level = $("#fieldSetSingle").val();
		this.fieldSet_bak.detail = this.getOppyDetails2();
		
		this.jsonidprops_bak = jsonidprops;
		//this.templates = jsontemplates;
		this.template.tid = tid;
		$(".FilterDiv .FilterHeader .templateSpan").html(this.drawTemplateList());
		this.drawFilter();
		this.checkChildInit();
		this.initTitle();
		
		$(".FilterDiv .divFieldSet").html(this.drawFieldSet());
		this.fieldsetEvent();
		
		
		this.templateSelectChangeEvent();
		// Check window zooming.
	//	this.zoomWindowEvent();

		// Hide field set select box when click on other place except field set select box.
		$(document).off('click').on("click", function(e) {
			if ((!$(e.target).hasClass("checkboxMultiSel") || !$(e.target).hasClass("listText")) && 
				$(".checkboxMultiSel .selectArea").css("display") != "none") {
				$(".checkboxMultiSel .selectArea").hide();
			} else {
				//$(".checkboxMultiSel .selectArea").show();
			}
		});
		// Deprecated!
		// Show/Hide a dialog that select which field to show on table header.
		$("#SDRBtn").hover(function(){
	    	$("#colCon").css("display","block");
	    }, function(){
	    	$("#colCon").css("display","none");
	    });
	    $("#colCon").hover(function(){
	    	$("#colCon").css("display","block");
	    }, function(){
	    	$("#colCon").css("display","none");
	    });
	    // Deprecated!
	    // Show/Hide table header when selected/unselected a field on field console.
		$("#colCon input").click(function(){
			var eq = $(this).val();
			if(this.checked) {
				$("#inlineTable_Bottom > tbody > tr, #inlineTable_Bottom > thead > tr").each(function(){
					$(this).children().eq(eq).show();
				});
				$("#tableHeader > li").eq(eq).show();
			} else {
				$("#inlineTable_Bottom > tbody > tr, #inlineTable_Bottom > thead > tr").each(function(){
					$(this).children().eq(eq).hide();
				});
				$("#tableHeader > li").eq(eq).hide();
			}
			$("#tableHeader").width($("#inlineTable_Bottom").width() + 1);
		});
		
		
	},
	
	
	// This function used for make a map of data. format is <filterId, filter()>.
	makeDataMap: function(data) {
		if (!data) return;
		for(var i = 0; i < data.length; i++) {
			for(oppy in data[i]) {
				var cate = data[i][oppy];
				this.mapCategory_filters[oppy] = cate;
				for(var j = 0; j < cate.length; j++) {
					this.mapFilterId_filter[cate[j].id] = cate[j];
				}
			}
		}
	},
	
	// Change event of date select.
	dateSelectChangeEvent: function() {
		var that = this;
		$(".CBodyerTopDate .dateType").on("change", function() {
			if ($(this).val() === that.CUSTOM_DATE) {
				$(this).siblings(".dateonlycls").find(".inputDate input").removeAttr("disabled");
				$(this).siblings().find(".calendarIcon").off("click").css("cursor", "pointer");
			} else {
				$(this).siblings(".dateonlycls").find(".inputDate input").attr("disabled", "disabled");
				$(this).siblings().find(".calendarIcon").off("click").css("cursor", "default");
			}
		});
	},
	
	// Bind a SF datePicker to an input element.
	bindDatePicker: function() {
		var that = this;
		$("input[id^='startDate']").add("input[id^='endDate']").each(function(index, element) {
			that.dateInputClick(this);
			if ($(this).val() == 0 || $(this).val() == "") {
				DatePicker.insertDate(DateUtil.formatDate(new Date(), UserContext.dateFormat), $(this).attr("id"));
			}
		});
		$(".inputDate").on("click", ".calendarIcon", function(e) {
			var jq_select = $(this).parents(".fcpickselect").siblings(".dateType"),
				jq_input = $(this).siblings("input");
			
			if (jq_select.val() == that.CUSTOM_DATE) {
				that.dateIconClick(this);
			}
		});
	},
	
	dateInputClick: function(obj) {
		$(obj).off('focus click').on("focus click", function() {
			DatePicker.pickDate(true, $(this).attr("id"), false);
		});
	},
	
	dateIconClick: function(obj) {
		var jq_input = $(obj).siblings("input");
		setTimeout(function() {jq_input.click().focus();}, 10);
	},
	
	// Change event of template select.
	templateSelectChangeEvent: function() {
		var that = this;
		$(".templateName").off('change').on("change", function() {
			that.changeTemplate();
            //that.checkChildInit();
		});
	},

	
	// Deal with zoom in/out window event.
	zoomWindowEvent: function() {
		/*
		var that = this;
		$("#containerPanel_Bottom").off('scroll').on("scroll", function(e) {
			that.adjustHeaderWidth();
		});
		$(document).on("scroll", function(e) {
			that.adjustHeaderWidth();
		});
		*/
	},
	
	// Init title helper for those filters that have default value.
	initTitle: function() {
		$("#accordion .ComponentNameHTitle").filter(function() {
				
			return $(this)[0].style.display != "none";
		}).each(function () {
			var jq_text = $(".ComponentNameHText", this);
			var eleId = (jq_text[0].id).substr(3);
			
			// Some value perhaps be changed in method of "checkChildInit()".
			//if ($("#" + eleId).hasClass("dateType") && $("#" + eleId).val() == "None") $(this).hide();
			if ($("#" + eleId).val() == "None") $(this).hide();
			if ($("#" + eleId).hasClass("checkboxType")) {
				jq_text.text($("#" + eleId)[0].checked);
			} else if ($("#" + eleId).hasClass("multiple")) { // Do nothing.
			} else if ($("#" + eleId).hasClass("yearType")) { // Do nothing.
			} else {
				jq_text.text($("#" + eleId).val());
			}
		});
	},
	
	// Change text of title helper.
	changeTitleText: function(categoryName) {
		var jq_h3 = $("h3[categoryName='" + categoryName + "']"),
		titleStr = "";
		jq_h3.find(".ComponentNameHTitle").each(function() {
			if ($(this).css("display") != "none") titleStr += $(this).text() ;//+ $(this).find(".ComponentNameHText").text());
		});
		jq_h3.find(".CategoryText").attr({"title": titleStr, "alt": titleStr});
		
	},
	
	saveSuccess: function() {
		$(".LoadingDiv").hide();
	},
	
	
	hideMask: function() {
		$(".LoadingDiv").hide();
	},
	
	showMask: function() {
		$(".LoadingDiv").show();
	},
	
	// Toggle "ComponentNameHTitle" 
	checkShowSel: function(obj) {
		if(obj.text().length == 0 || obj.text() == "" || obj.text() == "None") {
			obj.parent().hide();
		} else {
			obj.parent().show();
		}
	},
    	
    //---------------------- START: Methods to draws component ---------------------------//	
	
	// Draw templates select list.
	drawTemplateList: function() {
		var templates = jsontemplates,
			template = this.template,
			selected = "",
			NEWTEMPLATE = this.TIPS[1],
			display = template.tid ? "" : 'style="display: None"',
			templateStr = '';
			
		templateStr += '<select id="templateName" class="templateName" >'
		for (var i = 0; i < templates.length; i++) {
			if (template.tid == templates[i].value) selected = "selected";
			templateStr += '<option value="' + templates[i].value + '" ' + selected + '>' + templates[i].label + '</option>';
			selected = "";
		}
		if (templates.length === 0 || !template.tid) {
			templateStr += '<option value="" selected >' + NEWTEMPLATE + '</option>';
		} else {
			templateStr += '<option value="" >' + NEWTEMPLATE + '</option>';
		}
		templateStr += '</select>';
		return templateStr;
	},

	// Add templates select list after "doSave".
	addTemplateList: function() {
		//Append data to template list.
		var t = {
				label: this.template.tname,
				value: this.template.tid,
				rptCopt: null,
				rptLvl: null
		};
		jsontemplates.push(t);
		// Refresh template picklist.
		$(".FilterDiv .FilterHeader .templateSpan").html(this.drawTemplateList());
		this.templateSelectChangeEvent();
	},

	// Draw(print) ComponentName(a component title name).
	drawDisplayName: function(displayName) {
		return ('<div class="ComponentName"><div>'+displayName+'</div></div>');
	},
	
	// Draw(assemble) category section.
	drawCategory: function(categoryName, topStr, bottomStr, headStr, topCheckboxStr, topDateStr) {
		var cateHtml = '<h3 class="CHeaderDiv" categoryName="' + categoryName + '">'
						+ '<span class="CategoryName" >'+categoryName+'</span><span class="CategoryText">'+headStr+'</span></h3>'
						+ '<div class="CBodyerDiv" categoryName="' + categoryName + '"><div class="CBodyerTopCheckbox">' + topCheckboxStr + '</div>'
						+ '<div class="CBodyerTopDate">' + topDateStr + '</div>'
						+ '<div class="CBodyerTop">' + topStr + '</div>'
						+ '<div class="CBodyerBottom">' + bottomStr + '</div></div>';
		return cateHtml;
	},
	
	// Draw all filters.
	drawFilter: function() {
		var that=this, data=this.data, str='';
		
		
		for(var i = 0; i < data.length; i++) {	// Iterate to shows all filters.
			
			for(oppy in data[i]) {	// Iterate to shows all components of a filter.
				var cate = data[i][oppy], 
					cateLength = cate.length, 
					topCheckboxStr = [], 	// Shows checkbox components on the top of component area in every filter.
					topDateStr = [], 	// Shows single select components on the top of component area in every filter.
					topStr = [], 	// Shows single select components on the top of component area in every filter.
					bottomStr = [], // Shows multiple select components on the bottom of component area in every filter.
					headStr = '';	// Shows those values that user selected next to the Filter Name.  
					
				for(var j = 0; j < cateLength; j++) {
					var val = '', lab = '';
					if(cate[j].values.length > 0) {
						val = cate[j].values[0].value;
						lab = cate[j].values[0].label;
					}
					var parentId = cate[j].pid;
					if(parentId == null) {
						parentId = '';
					}
					var checkShow = ' style="display: none;"';
					if(lab.length > 0 || (cate[j].bReq && cate[j].filterType == "Picklist") 
							|| (cate[j].filterType == "Date")) {
						checkShow = '';
					}
					if(cate[j].filterType == 'Text') { // Old is 'String'
						topStr.push(that.drawText(cate[j].displayName, cate[j].id, val));
						var checkShow;
						headStr += '<span class="ComponentNameHTitle"'+checkShow+'>'+cate[j].displayName+' : <span class="ComponentNameHText" id="lab' + 
								cate[j].id+'">'+lab+'</span>;&nbsp;&nbsp;&nbsp;</span>';
					}
					if(cate[j].filterType == 'Picklist') { // Old is 'Single'
						var allValues = [];
						allValues = cate[j].values.concat(cate[j].listDomainValues); // Concat "values" into "domainValues".
						topStr.push(that.drawSelect(cate[j].displayName, cate[j].id, allValues, val, parentId, cate[j].pvalues));
						headStr += '<span class="ComponentNameHTitle"'+checkShow+'>'+cate[j].displayName+' : <span class="ComponentNameHText" id="lab' + 
								cate[j].id+'">'+lab+'</span>;&nbsp;&nbsp;&nbsp;</span>';
						var z = {};
						z.name = cate[j].id;
						z.value =  cate[j].values;
						that.tempSelData.push(z);
					}
					if(cate[j].filterType == 'MultiPicklist') { // Old is Multiple
						bottomStr.push(that.drawMultiSelect(cate[j].displayName, cate[j].id, cate[j].listDomainValues, cate[j].values, parentId));
						lab = '';
						for(var z = 0; z < cate[j].values.length; z++) {
							lab += ', '+cate[j].values[z].label;
						}
						if(lab.length > 0) {
							checkShow = '';
						}
						headStr += '<span class="ComponentNameHTitle"'+checkShow+'>'+cate[j].displayName+' : <span class="ComponentNameHText" id="lab' + 
								cate[j].id+'">'+lab.substring(2)+'</span>;&nbsp;&nbsp;&nbsp;</span>';
						
						var z = {};
						z.name = cate[j].id;
						z.value =  cate[j].values;
						that.tempSelData.push(z);
					}
					if(cate[j].filterType == 'Date') { // New
						topDateStr.push(that.drawDate(cate[j].displayName, cate[j].id, cate[j].listDomainValues, cate[j].values, parentId));
						headStr += '<span class="ComponentNameHTitle"'+checkShow+'>'+cate[j].displayName+' : <span class="ComponentNameHText" id="lab' + 
								cate[j].id+'">'+lab+'</span>;&nbsp;&nbsp;&nbsp;</span>';
						
					}
					if(cate[j].filterType == 'Year') { // New
						topDateStr.push(that.drawYear(cate[j].displayName, cate[j].id, cate[j].listDomainValues, val, parentId));
						headStr += '<span class="ComponentNameHTitle"'+checkShow+'>'+cate[j].displayName+' : <span class="ComponentNameHText" id="lab' + 
						cate[j].id+'">'+lab.replace(":", "-")+'</span>;&nbsp;&nbsp;&nbsp;</span>';

					}
					if(cate[j].filterType == 'Checkbox') { // New
						topCheckboxStr.push(that.drawCheckbox(cate[j].displayName, cate[j].id, val, parentId));
						if (val == "false") checkShow = ' style="display: none;"';
						headStr += '<span class="ComponentNameHTitle"'+checkShow+'>'+cate[j].displayName+' : <span class="ComponentNameHText" id="lab' + 
								cate[j].id+'">'+lab+'</span>;&nbsp;&nbsp;&nbsp;</span>';

					}
				}

				// Assemble all categoriy Filters into a html string after assembled all components into a Category Filter.
				str += this.drawCategory(oppy, topStr.join(""), bottomStr.join(""), headStr, topCheckboxStr.join(""), topDateStr.join(""));
			}
		}

		//  Event for multi select.
		// Click a right button, select value from left side and put it into right side.
		$("#accordion, .divFieldSet").on("click", "div.ARBtn", function(){
			var $mapId = $("#" + $(this).attr("mapId")), 
				$mapIdSel = $('#' + $(this).attr("mapId") + 'Sel'), 
				$labId = $("#lab" + $(this).attr("mapId"));
			
			if ($mapId[0].disabled) return false; // 
			
			if($(this).hasClass("Add")) {	// Select value, and add to ComponentNameHTitle
				$mapId.find("option").each(function() {
					if($(this)[0].selected) {
						$mapIdSel.append($(this));
						if($labId.text().length > 0 ) {
							$labId.append(', ' + $(this).text());
						} else {
							$labId.append($(this).text());
						}
						
					}
				});
			} else {	// Unselect value, and remove it from ComponentNameHTitle.
				$mapIdSel.find("option").each(function(){
					if($(this)[0].selected) {
						$mapId.append($(this));
						if($labId.text().indexOf($(this).text()) > 2) {
							$labId.text($labId.text().replace(', ' + $(this).text(), ''));
						} else {
							$labId.text($labId.text().replace($(this).text(), ''));
						}
						
						if($labId.text().indexOf(",") == 0) {
							$labId.text($labId.text().substring(1).trim());
						}
					}
				});
			}
			var values = [];
			$mapIdSel.find("option").each(function(){
				values.push($(this).val());
			});
			
			/* Deprecated!
			var obj = that.getChildrenVal($(this).attr("mapId"), values);
			for(var i = 0; i < obj.name.length; i++) {
				if(i==0) {
					$("#"+obj.name[i]+"Sel").html("");
					var str = "";
					for(var j = 0; j < obj.value.length; j++) {
						str += '<option value="'+obj.value[j].value+'">'+obj.value[j].label+'</option>';
					}
					$("#"+obj.name[i]).html(str);
					$("#lab"+obj.name[i]).text("");
				} else {
					$("#"+obj.name[i]+"Sel, #"+obj.name[i]).html("");
					//$("#"+obj.name[i]).html("");
					$("#lab"+obj.name[i]).text("");
				}
				that.checkShowSel($("#lab"+obj.name[i]));
			}*/
			that.checkShowSel($labId);
			that.checkChild($(this).attr("mapid"), true, (values.length > 0 ? values : "None"));
			that.changeTitleText($(this).parents(".CBodyerDiv").attr("categoryName"));
		});
		
		// Event for single select.
		$("#accordion").on("change", "select.single", function(){
			var $labId = $("#lab" + this.id);
			var categoryName = $(this).parents(".CBodyerDiv").attr("categoryName");
			$(this).find("option").each(function() {
				if($(this)[0].selected) {
					$labId.text($(this).text());
					return false;
				}
			});
			that.checkShowSel($labId);
			that.checkChild(this.id, true, $(this).val());
			that.changeTitleText(categoryName);
		});
		
		// Event for date type. NOTE: Enable start date and end date if change to CUSTOM DATE, and put the old date if have else put today.
		$("#accordion").on("change", "select.dateType", function(){
			var $labId = $("#lab" + this.id), 
				startD = "", endD = "", 
				categoryName = $(this).parents(".CBodyerDiv").attr("categoryName");
			
			if ($(this).val() === that.CUSTOM_DATE) {
				var startDate = $(this).siblings(".dateonlycls").find(".inputDate .startDate");
				var endDate = $(this).siblings(".dateonlycls").find(".inputDate .endDate");
				
				startDate.removeAttr("disabled");
				endDate.removeAttr("disabled");
				
				// Show "start date" and "end date" on to title.
				if (startDate.attr("olddate")) {
					startDate.val(startDate.attr("olddate"));
				} else {
					startDate.val(DateUtil.formatDate(new Date(), UserContext.dateFormat));
				}
				
				if (endDate.attr("olddate")) {
					endDate.val(endDate.attr("olddate"));
				} else {
					endDate.val(DateUtil.formatDate(new Date(), UserContext.dateFormat));
				}
				startD = startDate.val();
				endD = endDate.val();
				
				/*
				if (startD != "" && endD != "") $labId.text(startD + '-' + endD);
				*/
				$(this).siblings(".dateonlycls").find(".calendarIcon").off("click").css("cursor", "pointer");
			} else {
				$(this).siblings(".dateonlycls").find(".inputDate input").val("").attr("disabled", "disabled");
				$(this).siblings(".dateonlycls").find(".calendarIcon").off("click").css("cursor", "default");
			}
			$labId.text($(this).val());
			
			// To change title.
			//if (startD != "" && endD != "") $labId.text(startD + '-' + endD);
			
			that.checkShowSel($labId);
			that.changeTitleText(categoryName);
		});
		
		// Event for year type.
		$("#accordion").on("change", "select.yearType", function(){
			var $labId = $("#lab" + this.id), result = "",
				yearFrom = 0, yearTo = 0,
				categoryName = $(this).parents(".CBodyerDiv").attr("categoryName");
			
			yearFrom = $(this).hasClass("yearFrom") ? Number($(this).val()) : Number($(this).siblings(".yearFrom").val());
			yearTo = $(this).hasClass("yearTo") ? Number($(this).val()) : Number($(this).siblings(".yearTo").val());
			if (yearFrom > yearTo) {
				var contentStr = "From year must not be greater than To year!",
					result = that.initPopWin(1, contentStr);
				$("#dialog-message").dialog("open");
			}
			
			var jq_this = this;
			$.when(result).done(function(value) {
				if (value != "cancel") {
					$labId.text(yearFrom + '-' + yearTo);
					that.checkShowSel($labId);
					that.checkChild(jq_this.id, true);
					that.changeTitleText(categoryName);
				} else {
					if ($(jq_this).hasClass("yearFrom")) $(jq_this).val($(jq_this).siblings(".yearTo").val());
					if ($(jq_this).hasClass("yearTo")) $(jq_this).val($(jq_this).siblings(".yearFrom").val());
				}
			});
		});
		
		// Deprecated. // Event for text type.
		$("#accordion").on("keyup", "input", function(){
			var $labId = $("#lab" + this.id);
			$labId.text($(this).val());
			that.checkShowSel($labId);
		});
		
		// Event for checkbox type.
		$("#accordion").on("change", "input.checkboxType", function(){
			var categoryName = $(this).parents(".CBodyerDiv").attr("categoryName");
			$("input.checkboxType").each(function() {
				var $labId = $("#lab" + this.id);
				if ($(this).is(":checked")) {
					$labId.text("true");
                } else {
                    $labId.text("");
                }
                that.checkShowSel($labId);
			});
			that.checkChild(this.id, true);
			that.changeTitleText(categoryName);
		});
        
		$("#accordion").html(str);
		
		if ($("#accordion").accordion("instance")) {
			$("#accordion").accordion("destroy");
			$("#accordion").accordion({collapsible: true, active: false});
		} else {
			$("#accordion").accordion({collapsible: true, active: false});
		}
		// Bind date picker onto date component of a filter.
		this.bindDatePicker();
		//{
			//collapsible:true, heightStyle: "fill"
			//event:'click'
			
		//}	
	},

	
	// 
	drawText: function(displayName, id, value) {
		var str = '<div class="Component">' + this.drawDisplayName(displayName);
		str += '<div class="ComponentContent"><input type="text" id="'+id+'" value="'+value+'" /></div></div>';
		return str;
	},
	
	// Draw a single select component.
	drawSelect: function(displayName, id, domainValues, value, parentId) {
	//	console.log( domainValues );
		var str = '<div class="Component">' + this.drawDisplayName(displayName);
		//var disabled = !parentId ? "" : "disabled";
		//str += '<div class="ComponentContent"><select id="' + id + '" class="single"' + disabled + '>';
		str += '<div class="ComponentContent"><select id="' + id + '" class="single">';
		
		for(var i = 0; i < domainValues.length; i++) {
			var selValue = '';
			if(value == domainValues[i].value) {
				selValue = ' selected';
			}
			str += '<option value="'+domainValues[i].value+'" '+selValue+'>'+domainValues[i].label+'</option>';
		}
		str += '</select></div></div>';
		return str;
	},
	
	// Draw a multiple select component.
	drawMultiSelect: function(displayName, id, domainValues, values, parentId) {
		var str = '<div class="Component">' + this.drawDisplayName(displayName), that = this, 
			parentVal = that.getParentSelVal(parentId);//, disabled = !parentId ? "" : "disabled";
		
		str += '<div class="ComponentContent"><div class="Layout">';
		// Left - unselected options.
		str += '<span class="selecetCell"><div class="selectTitle"><label>Available</label></div>';
		//str += '<select id="' + id + '" multiple="multiple" class="multiple" ' + disabled + '>';
		str += '<select id="' + id + '" multiple="multiple" class="multiple" parentId="' + parentId + '">';
		for(var i = 0; i < domainValues.length; i++) {
			//if(parentId.length == 0) {
				str += '<option value="'+domainValues[i].value+'">'+domainValues[i].label+'</option>';
			//}
		}
		
		// Center - buttons.
		str += '</select></span><span class="buttonCell"><div class="duelingText">Add</div><div class="ARBtnDiv"><div class="ARBtn Add" mapId="'+id+'">'
			+ '<div class="ARBtnAdd"></div></div></div><div class="ARBtnDiv"><div class="ARBtn" mapId="'+id+'"><div class="ARBtnRemove"></div></div></div>'
			+ '<div class="duelingText">Remove</div></span>';
		
		
		// Right - selected options.
		str += '<span class="selecetCell"><div class="selectTitle"><label>Selected</label></div>';
		//str += '<select id="' + id + 'Sel" multiple="multiple" class="multiple" ' + disabled + '>';
		str += '<select id="' + id + 'Sel" multiple="multiple" class="multiple" parentId="' + parentId + '">';
		
		for(var i = 0; i < values.length; i++) {
			str += '<option value="' + values[i].value + '">' + values[i].label + '</option>';
		}
		str += '</select></span></div></div></div>';

		return str;
	},
	
	// Draw a checkbox component.
	drawCheckbox: function(displayName, id, value, parentId) {
		var str = '<div class="Component">' + this.drawDisplayName(displayName);//,
			//disabled = !parentId ? "" : "disabled";
			
		//str += '<input id="' + id + '" type="checkbox" class="checkboxType" value="' + value + '" ' + disabled + '>';
		if (value == "true") {
			str += '<input id="' + id + '" type="checkbox" class="checkboxType" checked="checked"/>';
		} else {
			str += '<input id="' + id + '" type="checkbox" class="checkboxType"/>';
		}
		str += '</div>';
		return str;
	},
	
	// Draw a date component. NOTE: If not CUSTOM DATE, start date and end date shold be empty.
	drawDate: function(displayName, id, domainValues, values, parentId) {
		var str = '<div class="Component">' + this.drawDisplayName(displayName),
			cursor = '', startDate = '', endDate = '', selectedVal = "", 
			isCustomDate = (values.length > 0 && this.CUSTOM_DATE === values[0].label && !parentId) ? "" : "Disabled";//,
			//disabled = !parentId ? "" : "disabled";
			
		//str += '<div class="ComponentContent"><select id="' + id + '" class="dateType" ' + disabled + '>';
		str += '<div class="ComponentContent"><select id="' + id + '" class="dateType" >';
		for(var i = 0; i < domainValues.length; i++) {
			var selValue = '';
			if(values.length > 0 && values[0].label == domainValues[i].value) {
				selValue = ' selected';
				selectedVal = domainValues[i].value;
			}
			
			if (i == domainValues.length - 1 && selectedVal == "") {
				selectedVal = domainValues[0].value;
			}
			str += '<option value="' + domainValues[i].value + '" ' + selValue + '>' + domainValues[i].label + '</option>';
		}
		
		if (selectedVal === this.CUSTOM_DATE) {
			isCustomDate = "";
			if (values.length > 0 && values[0].value.length == 27) {
				startDate = this.removeTime(DateUtil.formatDate(new Date(Number(values[0].value.split(";")[0])), UserContext.dateFormat));
				endDate = this.removeTime(DateUtil.formatDate(new Date(Number(values[0].value.split(";")[1])), UserContext.dateFormat));
			} else {
				startDate = this.removeTime(DateUtil.formatDate(new Date(), UserContext.dateFormat));
				endDate = this.removeTime(DateUtil.formatDate(new Date(), UserContext.dateFormat));
			}
		} else {
			isCustomDate = "Disabled";
		}
		
		cursor = isCustomDate == "" ? 'style="cursor: pointer;"' : 'style="cursor: default;"',
		
		str += '</select>';
		str += '<div class="datefixcls fcpickselect dateonlycls">';
		str += '<span class="inputDate tl dateonlycls" alt="Start Date" title="Start Date">';
		str += ' <input id="startDate_' + id +  '" type="text" class="startDate" value="' + startDate + '"';
		str += ' oldDate="' + startDate + '" parentId="' + parentId + '" ' + isCustomDate + ' readonly/>';
		str += ' <span class="allimg dateonlycls calendarIcon" ' + cursor + '></span>';
		str += ' </span>';
		
		str += ' <span class="allimg title-Arrow dateonlycls"></span>';
                                   
		str += ' <span class="inputDate tl fix dateonlycls" alt="End Date" title="End Date">';
		str += ' <input id="endDate_' + id +  '" type="text" class="endDate" value="' + endDate + '"';
		str += ' oldDate="' + endDate + '" parentId="' + parentId + '" ' + isCustomDate + ' readonly/>';
		str += ' <span class="allimg dateonlycls calendarIcon" ' + cursor + '></span>';
		str += ' </span>';
		str += '</div></div></div>';
		return str;
	},
	
	// Draw a year component.
	drawYear: function(displayName, id, domainValues, value, parentId) {
		var str = '<div class="Component">' + this.drawDisplayName(displayName),
			//disabled = !parentId ? "" : "disabled",
			values = value.split(":");
		
		str += '<div class="ComponentContent">';
		for(var i = 0; i <= domainValues.length; i++) { // Normally this domainvalue is just one value.
			var yearRange = this.getYearFromTo();
			var fromStr = "", toStr = "";
			
			for (var j = 0; j < 10; j++) {
				var selFrom = "", selTo = "";
				if(values[0] == yearRange["from"][j]) {
					selFrom = "selected";
				}
				if(values[1] == yearRange["to"][j]) {
					selTo = "selected";
				}
				fromStr += '<option value="' + yearRange["from"][j] + '" ' + selFrom + '>' + yearRange["from"][j] + '</option>';
				toStr += '<option value="' + yearRange["to"][j] + '" ' + selTo + '>' + yearRange["to"][j] + '</option>';
			}
		}
		//str += 'From:<select id="' + id + '" class="yearType yearFrom"' + disabled + '>' + fromStr + '</select>  To:';
		//str += '<select id="' + id + '" class="yearType yearTo"' + disabled + '>' + toStr + '</select></div></div>';
		str += 'From:<select id="' + id + '" class="yearType yearFrom">' + fromStr + '</select>  To:';
		str += '<select id="' + id + '" class="yearType yearTo">' + toStr + '</select></div></div>';
		return str;
	},
	
    //---------------------- END: Methods to draws component ---------------------------//
	// Calculate from year and to year.
	getYearFromTo: function(fiscalYear) {
		var yearFromTo = [], 
			years = {"from": [], "to": []},
			thisYear = fiscalYear ? Number(fiscalYear) : new Date().getFullYear();
		
		for (var j = 0; j < 10; j++) {
			years.from.push(thisYear - 1);
			years.to.push(thisYear - 1);
			thisYear++;
		}
		return years;
	},
	
	// Check the initialize value of parent to disable a child, only check highest level.
	checkChildInit: function() {
		//if($.trim(this.template.tid) == ''){ //added by BYU
			var that = this;
			$("#accordion .Component :enabled").filter("select[id$='Sel'], input").not("input[id*='Date']").add("select.single").each(function() {
			//$("#accordion .Component :enabled").filter("select, input").not("select[id$='Sel'], input[id*='Date']").each(function() {
				// Filter "None" or empty value.
				var val = "";
				if ($(this).hasClass("multiple") || $(this).hasClass("single")) val = $(this).val();
				that.checkChild(this.id, false, val);
			});			
		//}

	},
	
	// Disable a filters or search child.
	// Param: filterId - The filter Id; bChg - Invoke this function from change a filter; filterVal - For Multi Picklist and Single Picklist.
	checkChild: function(filterId, bChg, filterVal) {
		// TODO: 1.When init; 2.When change parent; 3.When change template.
		var flag = false;
		for (var i = 0; i < this.data.length; i++) {
			for(oppy in this.data[i]) {
				var category = this.data[i][oppy];
				for (var j = 0; j < category.length; j++) {
					
					if (!category[j].pid) continue;
					var parentValue = $("#" + category[j].pid).val(); // Only for single select.
					
					// To disable any filters.
					if (category[j].pid == filterId && category[j].pvalues ) {
						if (category[j].pvalues.indexOf(parentValue) >= 0) {
							$("#" + category[j].id)[0].disabled = false;
							
							// Clear value for "dateType", set to "None" for "Picklist".
							if (category[j].filterType == this.FILTER_TYPES[2] && $("#" + category[j].id).val() === this.CUSTOM_DATE) {
								var startDate = $("#" + category[j].id).siblings(".dateonlycls").find(".inputDate .startDate");
								var endDate = $("#" + category[j].id).siblings(".dateonlycls").find(".inputDate .endDate");
								
								if (startDate.attr("olddate")) {
									startDate.val(startDate.attr("olddate"));
								} else {
									startDate.val(DateUtil.formatDate(new Date(), UserContext.dateFormat));
								}
								if (endDate.attr("olddate")) {
									endDate.val(endDate.attr("olddate"));
								} else {
									endDate.val(DateUtil.formatDate(new Date(), UserContext.dateFormat));
								}
							} else if (category[j].filterType == this.FILTER_TYPES[1]) {
								$("#" + category[j].id + "Sel")[0].disabled = false;
							}
						} else {
							if (category[j].filterType == this.FILTER_TYPES[2]) { // Date
								$("#" + category[j].id).val("None");
								$("#" + category[j].id).siblings(".dateonlycls").find(".inputDate input").val("").attr("disabled", "disabled");
							} else if (category[j].filterType == this.FILTER_TYPES[0]) { // Picklist
								$("#" + category[j].id).val("None");
							} else if (category[j].filterType == this.FILTER_TYPES[1]) { // MultiPicklist
								//$("#" + category[j].id)[0].disabled = true;
								$("#" + category[j].id).append($("#" + category[j].id + "Sel option"));
								$("#" + category[j].id + "Sel")[0].disabled = true;
							}
							$("#lab" + category[j].id).text("");
							$("#lab" + category[j].id).parents(".ComponentNameHTitle").css("display", "none");
							this.changeTitleText(category[j].filterCategory);
							$("#" + category[j].id)[0].disabled = true;
						}
					}
					
					// To search child.
					if ((bChg || !this.template.tid) && category[j].pid == filterId && !category[j].pvalues && this.SEARCH_EXCLUSION.indexOf(parentValue) < 0) {
						if (filterVal == "None" || filterVal == null) {
							flag = false;
						} else {
							flag = true;
						}
					}
					if (bChg && category[j].pid == filterId && !category[j].pvalues) {
						this.clearChild(category[j]);
					}
				}
			}
		}
		if (flag) {
			this.showMask();
			this.searchChild(filterId);
		}
		return "No child or dependent item!";
	},
	
	// Clear child values and update child title text.
	clearChild: function(child) {
		var childId = child.id;
		if (child.filterType == "Picklist") {
			$("#" + childId).html("");
			//this.checkChild(childId, true, "None");
			this.checkChild(childId, true);
		} else if (child.filterType == "MultiPicklist") {
			$("#" + childId).add("#" + childId + "Sel").html("");
			//this.checkChild(child.id, true, null);
			this.checkChild(childId, true);
		}
		$("#lab" + childId).text("");
		$("#lab" + childId).parents(".ComponentNameHTitle").css("display", "none");
		this.changeTitleText(child.filterCategory);
	},
	
	// Redraw a child`s value.
	redrawChild: function() {
		for (childId in ctrlValues) {
			this.changeChildValue(childId, ctrlValues[childId]);
		}
	},
	
	// Change values for child after fetched searching results, and make them useable.
	changeChildValue: function(childId, values) {
		var jq_child = $("#" + childId),
			appendStr = '';
		
		// Change value to a checkbox component.
		if (jq_child.hasClass("checkboxType")) {
			jq_child.checked = values;
		}
		
		// Change value to a date component.
		if (jq_child.hasClass("dateType")) { // TODO:
			//jq_child.html(appendStr);
		}
		
		// Change value to a single select component.
		if (jq_child.hasClass("single")) {
			if (values) {
				for (var i = 0; i < values.length; i++) {
					appendStr += '<option value="' + values[i].value + '">' + values[i].label + '</option>';
				}
			}
			jq_child.html(appendStr);
		}
		
		// Change value to a multiple select component.
		if (jq_child.hasClass("multiple")) {
			if (values) {
				for (var i = 0; i < values.length; i++) {
					appendStr += '<option value="' + values[i].value + '">' + values[i].label + '</option>';
				}
			}
			jq_child.html(appendStr);
		}
		jq_child[0].disabled = false;
	},
	
	// Deprecated!
	checkValue: function(targetId, parentId, targetVal, parentVal) {
		var ctrlData = this.ctrlData;
		for(var i = 0; i < ctrlData.length; i++) {
			if(ctrlData[i].name[0] == parentId && ctrlData[i].name[1] == targetId) {
				for(var j = 0; j < parentVal.length; j++) {
					if(JSON.stringify(ctrlData[i].value[parentVal[j]]).indexOf(targetVal) >= 0) {
						return true;
					}
				}
				return false;
			}
		}
		return false;
	},
	
	// Deprecated! Get the right options of a multi-picklist.
	getChildrenVal: function(id, values) {
		var ctrlData = this.ctrlData, arr = [], arrName = [], obj = {};
		for(var i = 0; i < ctrlData.length; i++) {
			if(ctrlData[i].name[0] == id) {
				for(var j = 0; j < values.length; j++) {
					arr = arr.concat(ctrlData[i].value[values[j]]);
				}
				arrName.push(ctrlData[i].name[1]);
				obj.value = arr;
			} 
			if(arrName.length > 0) {
				if(arrName[arrName.length - 1] == ctrlData[i].name[0]) {
					arrName.push(ctrlData[i].name[1]);
				}
			}
		}
		obj.name = arrName;
		return obj;
	},
	
	// Get the left options of a multi-picklist.
	getParentSelVal: function(parentId) {
		var arr = [];
		for(var i = this.tempSelData.length - 1; i >= 0; i--) {
			if(parentId == this.tempSelData[i].name) {
				for(var j = this.tempSelData[i].value.length - 1; j >= 0; j--) {
					arr.push(this.tempSelData[i].value[j].value);
				}
				return arr;
			}
		}
	}, 

	
	// Search dependency value(Filter -> Filters)
	searchChild: function(filterId) {
		// check data type.
		var parentId = filterId,
			obj = $("#" + filterId).hasClass("multiple") ? $("#" + filterId + "Sel") : $("#" + filterId),
			ctrlIds = [],
			pValues = [];
			
		if (!$(obj).hasClass("checkboxType") && !$(obj).hasClass("single") && !$(obj).hasClass("multiple")) return "Invalid type.";
		for (var i = 0; i < this.data.length; i++) {
			for(oppy in this.data[i]) {
				for (var j = 0; j < this.data[i][oppy].length; j++) {
					if (this.data[i][oppy][j].pid && this.data[i][oppy][j].pid == parentId) ctrlIds.push(this.data[i][oppy][j].id);
				}
			}
		}
		
		// Get checkbox type value.
		if ($(obj).hasClass("checkboxType")) {
			pValues.push($("#" + parentId)[0].cheched);
		}

		// Get single select type value.
		if ($(obj).hasClass("single")) {
			pValues.push($("#" + parentId).val());
		}
		
		// Get multiple select type value.
		if ($(obj).hasClass("multiple")) {
			$("#" + parentId + "Sel option").each(function() {
				pValues.push($(this).val());
			});
		}
		var pValuesStr = JSON.stringify(pValues); //["30042"]
		var ctrlIdsStr = JSON.stringify(ctrlIds); //["a3Vc0000000OeAOEA0"]

		getCtrlValues(pValuesStr, ctrlIdsStr, parentId, this.jsonidprops_bak); // Invoke action function.
		
	},
	
	
	//------- TOP: Button Event -----------//
	searchData: function() {
		var msg = this.validRequired();
		var msg = this.validFcCategory();

		if (msg !== "pass") {
			result = this.initPopWin(1, msg);
			$("#dialog-message").dialog("open");
			
			$.when(result).done(function(value) {
				$.noop;
			});
		} else {
			this.showMask();
			$("input[id*='jsonfilters']").val(JSON.stringify(this.getJson()));
			
			var oppyType = $("#fieldSetSingle").val(),
			//oppyDetails = JSON.stringify($(".checkboxMultiSel .listText").attr("oppyDetails").split(","));
			oppyDetails = JSON.stringify(this.getOppyDetails());
			doSearch(oppyType, oppyDetails, this.jsonidprops_bak);
		}
	},
	
	// 
	resetCache: function() {
		this.mappingIds_bak = mappingIds;
		this.setIdGroup();
		this.searchGroupIndex = 0;
		
		// Added by Qiang Liu 2015.07.10
		this.hasSearched = true; 
		this.data_bak = backupData(json);
		this.fieldSet_bak.level = $("#fieldSetSingle").val();
		this.fieldSet_bak.detail = this.getOppyDetails2();
	},
	
	// Save / Save As to be a template.
	saveData: function(newUpdate) {
		var templateId = $("#templateName").val(), that = this,
			oppyType = $("#fieldSetSingle").val(),
			//oppyDetails = $(".checkboxMultiSel .listText").attr("oppyDetails");
			oppyDetails = this.getOppyDetails().join();

		var msg = this.validRequired();

		if (msg !== "pass") {
			result = this.initPopWin(1, msg);
			$("#dialog-message").dialog("open");
			
			$.when(result).done(function(value) {
				return false;
			});
		}
		
		if (newUpdate == "New" || (newUpdate == "Update" && !templateId)) {
			var contentStr = 'Please enter a template name: <input id="templateNamePopup" />';
			var result = this.initPopWin(0, contentStr);
			$("#dialog-message").dialog("open");
			
			$.when(result).done(function(value) {

				if (value == "ok") {
					var templateName = $("#templateNamePopup").val();

					if (!templateName) return false;
					
					that.showMask();
					$("input[id*='jsonfilters']").val(JSON.stringify(that.getJson()));
					that.template.tname = templateName;
					doSave(templateName, oppyType, oppyDetails);
				}
			});
		} else {
			this.showMask();
			$("input[id*='jsonfilters']").val(JSON.stringify(this.getJson()));
			doUpdate(templateId, oppyType, oppyDetails);
		}
	},
	
	// Change a template.
	changeTemplate: function() {
		var templateId = $("#templateName").val();
		//if (templateId === "") return false;
		this.showMask();
		// Notes: Template id may be empty.
		this.template.tid = templateId;
		doTemplateSwitch(templateId);
	},
	
	// Delete a template.
	deleteTemplate: function(obj) {
		var contentStr = "", templateId = $("#templateName").val(), result = "", that = this;
		
		if (templateId === "") {
			//alert("Not select a template!"); // TODO: Replace this window with div style!
			contentStr = 'Please select a template name!';
			result = this.initPopWin(1, contentStr);
			$("#dialog-message").dialog("open");
			
			$.when(result).done(function(value) {
				$.noop();
			});
			return false;
		}
		
		contentStr = 'Are you sure?';
		result = this.initPopWin(0, contentStr);
		$("#dialog-message").dialog("open");
		
		$.when(result).done(function(value) {
			if (value == "ok") {
				that.showMask();
				doTemplateRemove(templateId);
			}
		});
	},
	//------- BOTTOM: Button Event -----------//
	
	// Assemble json string for save / search. 
	getJson: function() {
		var data = this.data;
		
		for(var i = 0; i < data.length; i++) {
			for(oppy in data[i]) {
				var cate = data[i][oppy], cateLength = cate.length, topStr = [], bottomStr = [], headStr = '';
				for(var j = 0; j < cateLength; j++) {
					var arrVal = [], obj = $("#" + cate[j].id), val = {};
					
					if(cate[j].filterType == "Picklist") { // Set value form Picklist Type.
						obj.find("option").each(function() {
							if($(this)[0].selected) {
								val.value = $(this).val();
								val.label = $(this).text();
								return false;
							}
						});
						if (val.value && val.label) arrVal.push(val);
						
					} else if(cate[j].filterType == "Date") {
						// Set value form Date Type. NOTE: Not to be saved if date type is "None". Values shold be empty if date type is not CUSTOM DATE.
						val.value = obj.val() === this.CUSTOM_DATE ? this.getCustomDate(cate[j].id) : obj.val();
						val.label = obj.val();
						if (val.value && val.label) arrVal.push(val);
					
					} else if(cate[j].filterType == "Year") { // Set value form Year Type.
						var yearFrom = $("#" + cate[j].id).val(),
							yearTo = $("#" + cate[j].id).siblings(".yearTo").val();
						val.value = yearFrom + ":" + yearTo;
						val.label = yearFrom + ":" + yearTo;
						arrVal.push(val);
						
					} else if(cate[j].filterType == "MultiPicklist") { // Set value form Multiple Select Type.
						obj = $("#" + cate[j].id + "Sel");
						for(var k = 0; k < obj.children("option").size(); k++) {
							var opt = obj.children("option").eq(k); val = {};
							//val.value = cate[j].displayName == this.SPECIAL_FILTERS[0] ? "%" + opt.attr("value") + "%" : opt.attr("value");
							//val.label = cate[j].displayName == this.SPECIAL_FILTERS[0] ? "%" + opt.text() + "%" : opt.text();
							val.value = opt.attr("value");
							val.label = opt.text();
							//arrVal.push(val);
							if (val.value && val.label) arrVal.push(val);
						}
					} else if(cate[j].filterType == "Checkbox") { // Set value form Checkbox Type.
						val.value = obj[0].checked;
						val.label = val.value;
						arrVal.push(val);
					} else {
						val.value = obj.val();
						val.label = obj.val();
						if (val.value && val.label) arrVal.push(val);
					}
					cate[j].values = arrVal;
				}
			}
		}

		return data;
	},
	
	// Assemble json string for save / search.
	getCustomDate: function(filterId) {
		var startDate = $("#" + filterId).siblings(".datefixcls").find(".startDate").val(),
			endDate = $("#" + filterId).siblings(".datefixcls").find(".endDate").val();
		
		startDate = this.removeTime(DateUtil.getDateFromFormat(startDate, UserContext.dateFormat));
		endDate = this.removeTime(DateUtil.getDateFromFormat(endDate, UserContext.dateFormat));
		return startDate + ";" + endDate;
	},
	
	// Remove time of date.
	removeTime: function(date) {
		var d = new Date(date);
		return new Date(d.getFullYear(), d.getMonth(), d.getDate()).getTime();
	},
	
	// Valid those required filter.
	validRequired: function() {
		var data = this.data;
		for(var i = 0; i < data.length; i++) {
			for(oppy in data[i]) {
				var cate = data[i][oppy];
				for(var j = 0; j < cate.length; j++) {
					if(cate[j].filterType === "MultiPicklist" && cate[j].bReq) {
						if (!$("#" + cate[j].id).val()) {
							return cate[j].displayName + " is Required!";
						}
					}
					if(cate[j].filterType === "Date" && cate[j].bReq && cate[j].values.length > 0 
							&& cate[j].values[0].label === this.CUSTOM_DATE) {
						
						var jq_startDate = $("#" + cate[j].id).siblings(".dateonlycls").find(".startDate"),
							jq_endDate = $("#" + cate[j].id).siblings(".dateonlycls").find(".endDate");
						if (jq_startDate.val() == "" || jq_endDate.val() == "") {
							return "Start Date and End Date of " + cate[j].displayName + " are Required!";
						}
					}
				}
			}
		}
		return "pass";
	},
	
	validFcCategory: function() {
		var n = $(".CBodyerDiv[categoryname='" + this.filterCategory + "']").find(".CBodyerTopCheckbox .checkboxType:checked").length;
		if (n < 1 || n > 3) {
			return "You can only select 1-3 " + this.filterCategory;
		} else {
			return "pass";
		}
		
	},
	
	// Initialize popup window.
	initPopWin: function(type, contentStr, callbackTrue, callbackFalse) {
		var returnValue = 0;
		var that = this;
		var defer = $.Deferred();
		if (type == 0) { // Confirm, Prompt
			$("#dialog-message").dialog({
			    modal: true,
			    autoOpen: false,
			    buttons: [
					{
					text: "OK",
					click: function() {
						returnValue = 1;
				        $(this).dialog( "close" );
				        //callbackTrue(that);
				        defer.resolve("ok");
					}},
					{
					text: "Cancel",
					click: function() {
						returnValue = 0;
						$(this).dialog( "close" );
						//callbackFalse(that);
						defer.resolve("cancel");
					}}
			    ]
			}).on("dialogclose", function(e, ui) {
				$(this).off("dialogclose");
			});
		}
		if (type == 1) { // Alert.
			$("#dialog-message").dialog({
				modal: true,
				autoOpen: false,
				buttons: [
					{
					text: "Ok",
					click: function() {
				        $( this ).dialog( "close" );
				        defer.resolve("cancel");
					}}
				]
			});
		}
		$("#dialog-message #popupContent").html(contentStr);
		return defer.promise();
	},
	
	//------- TOP: Deal With Field Set -----------//
	
	forecastFields: function() {
		// Get abbreviation of category.
		var fcFields = [], that = this, jq_category = $(".CBodyerDiv[categoryname='" + this.filterCategory + "']");
		$(".CBodyerTopCheckbox input:checked", jq_category[0]).each(function() {
			var displayNameStr = that.mapFilterId_filter[this.id]["displayName"], 
				displayNames = displayNameStr.split(" "), abbr = "", fcFieldNames = "";
			fcFields.push(that.fcCategory[displayNameStr]);
			
		});

		// Get years selected.
		var yearNum = [], yearFrom = Number($(".yearType.yearFrom", jq_category[0]).val()), yearTo = Number($(".yearType.yearTo", jq_category[0]).val());
		for (var i = yearFrom; i <= yearTo; i++) {
			yearNum.push(i.toString());
		}

		// Get by year or by quarter.
		var compId = _.find(this.mapCategory_filters[this.filterCategory], function(obj){
				return _.findKey(obj, function(value, key){return value == "Forecast display"})
			})["id"], finalYearNum = [], period = $("#" + compId).val();

		var byQuarter = ["Q1", "Q2", "Q3", "Q4"];
		
		// Joint column name string. "Year [Quarter] [category]", [] is option.
		var fcFieldsFinal = [];
		if (fcFields.length > 0) {
			for (var i = 0; i < yearNum.length; i++) {
				var str = "";
				if (this.fcByWhat[1] === period) {
					for (var j = 0; j < fcFields.length; j++) {
						for (var k = 0; k < byQuarter.length; k++) {
							fcFieldsFinal.push($.trim(yearNum[i] + " " + byQuarter[k] + " " + fcFields[j]));
						}
					}
				} else {
					for (var j = 0; j < fcFields.length; j++) {
						fcFieldsFinal.push($.trim(yearNum[i] + " " + fcFields[j]));
					}
				}
			}
		}
		
		return fcFieldsFinal;
	},
	
	// Get part/partner api field.
	getPartApiField: function() {
		var partApiField = [], oppyType = this.getOppyType();
		var obj = _.filter(oppytypes, function(obj) {return obj.dtype == "Picklist";});

		var type = obj[0]["incsAPIs"][oppyType];
		
		for (var i = 0; i < type.length; i++) {
			partApiField.push(type[i]);
		}
		return partApiField;
	},
	
	// Key: field label, Value: field API name. 
	mapFsApiLabel: function(action) {
		var mapApiLabel = [], fieldSets = this.getFieldSets(), oppyDetails = this.getOppyDetails();
		var oppyType = this.getOppyType();

		for (var i = 0; i < fieldSets.length; i++) {
			var dtype = fieldSets[i];
			if ("Picklist" === dtype["dtype"]) {//continue;
				for (var j = 0; j < dtype["incsAPIs"][this.fixedFieldSetName].length; j++) {
					mapApiLabel.push(dtype["incsAPIs"][this.fixedFieldSetName][j]);
				}
				if (action == "export" && oppyType != this.fixedFieldSetName) { // Just for export part/partner.
					for (var k = 0; k < dtype["incsAPIs"][oppyType].length; k++) {
						mapApiLabel.push(dtype["incsAPIs"][oppyType][k]);
					}
				}
			}
			if ("MultiPicklist" === dtype["dtype"]) {//continue;

				for (var j = 0; j < oppyDetails.length; j++) {
					for (var k = 0; k < dtype["incsAPIs"][oppyDetails[j]].length; k++) {
						mapApiLabel.push(dtype["incsAPIs"][oppyDetails[j]][k]);
					}
				}
			}

		}
		return mapApiLabel;
	},
	
	// Selected field sets and its fields.
	fieldSetsLite: function(action) {
		var selectedSets = [], fieldSets = this.getFieldSets(), oppyVal = $("#fieldSetSingle").val(), oppyDetails = this.getOppyDetails();
			this.oppyFields = [], this.childFields = [];

		for (var i = 0; i < fieldSets.length; i++) {
			var dtype = fieldSets[i];
			
			if ("Picklist" === dtype["dtype"]) { // Picklist

				for (var j = 0; j < dtype["incs"][this.fixedFieldSetName].length; j++) {
					this.oppyFields.push(dtype["incs"][this.fixedFieldSetName][j]);
				}
				
				for (fsName in dtype["incs"]) {
					if (oppyVal == fsName) {
						selectedSets[fsName] = dtype["incs"][fsName];
					}
					
					// Get part fields or partner fields.
					if (oppyVal != this.fixedFieldSetName && oppyVal == fsName) {
						for (var j = 0; j < dtype["incs"][fsName].length; j++) {
							this.childFields.push(dtype["incs"][fsName][j]);
							if (action == "export") { // Just for export part/partner.
								this.oppyFields.push(dtype["incs"][fsName][j]);
							}
						}
					}
				}
			}
			
			if ("MultiPicklist" === dtype["dtype"]) { // MultiPicklist
				for (var j = 0; j < oppyDetails.length; j++) {
					selectedSets[oppyDetails[j]] = dtype["incs"][oppyDetails[j]];
					
					for (var k = 0; k < dtype["incs"][oppyDetails[j]].length; k++) {
						this.oppyFields.push(dtype["incs"][oppyDetails[j]][k]);
					}
				}
			}
		}
		return selectedSets;
	}, 
	
	// Draw field set Picklist & MultiPicklist.
	drawFieldSet: function() {
		var str = "", fieldSets = this.getFieldSets();

		var fs = "", sel = "";
		for (var i = 0; i < fieldSets.length; i++) {
			var title = fieldSets[i]["title"],
				dtype = fieldSets[i],
				mdty = (dtype["mdty"] && "object" === typeof(dtype["mdty"])) ? dtype["mdty"].toString() : dtype["mdty"] ;
				
			str += '<div class="Component Component-fs">' + this.drawDisplayName(title);
			if ("Picklist" === dtype["dtype"]) { // Picklist
				var fsNames = [];
				str += '<div class="ComponentContent"><select id="fieldSetSingle" class="fieldSetSingle">';
				for (fsName in dtype["incs"]) {
					fsNames.push(fsName);
					for (var j = 0; j < dtype["incs"][fsName].length; j++) {
						if (mdty.indexOf(fsName) >= 0) {
							//this.oppyFields.push(dtype["incs"][fsName][j]);
							//this.fixedFields.push(dtype["incs"][fsName][j]);
						}
					}
				}
				
				for (var k = 0; k < fsNames.sort().length; k++) {
					if (this.template.tid) {
						var tid = this.template.tid;
						var tem = _.filter(jsontemplates, function(obj) {return obj.value == tid;});
						fs = typeof(tem) == "object" ? tem[0]["rptLvl"] : "";
					}
					str += '<option value="' + fsNames[k] + '"  ' + (fsNames[k] == fs ? "selected" : "") + '>' + fsNames[k] + '</option>';
				}
				str += '</select></div></div>';
			}
			
			if ("MultiPicklist" === dtype["dtype"]) { // MultiPicklist
				// Checkbox multiselect
				var fsNames = [];
				str += '<div class="ComponentContent"><div class="checkboxMultiSel"><span class="listText" oppyDetails="">' + this.TIPS[0] + '</span>';
				str += '<div class="selectArea" id="" ><ul>';
				for (fsName in dtype["incs"]) {
					fsNames.push(fsName);
					for (var j = 0; j < dtype["incs"][fsName].length; j++) {
						//this.oppyFields.push(dtype["incs"][fsName][j]);
					}
				}
				
				for (var k = 0; k < fsNames.sort().length; k++) {
					if (this.template.tid) {
						var tid = this.template.tid;
						var tem = _.filter(jsontemplates, function(obj) {return obj.value == tid;});
						fs = typeof(tem) == "object" ? tem[0]["rptCopt"] : "";
						if (fs != null && fs.length > 0) fs = fs.split(",");
					}
					if (fs == "" || fs == null) {
						str += '<li><input type="checkbox" value="' + fsNames[k] + '" /><span>' + fsNames[k] + '</span></li>';
					} else {
						str += '<li><input type="checkbox" value="' + fsNames[k] + '" ' + (_.indexOf(fs, fsNames[k]) >= 0 ? "checked" : "") 
							+ '/><span>' + fsNames[k] + '</span></li>';
					}
					
				}
				
				str += '</ul></div></div></div>';
			}
		}

		return str;
	},
	
	fieldsetEvent: function() {
		var that = this;
		// Event for checkbox multi selection.
		
		$(".divFieldSet").off("click", ".checkboxMultiSel").on("click", ".checkboxMultiSel", function(e) {
			if ($(e.target).hasClass("listText"))	$(".selectArea", this).toggle();
			e.stopImmediatePropagation();
		});
		
		
		// Event for checkbox type.
		$(".divFieldSet .selectArea input").off('change').on("change", function(e) {
			var oppyDetails = that.getOppyDetails();
			var jq_listText = $(this).parents(".checkboxMultiSel").find(".listText");
			if (oppyDetails.length <= 0) {
				jq_listText.text(that.TIPS[0]);
				jq_listText.attr("oppyDetails", "");
			} else {
				jq_listText.text(oppyDetails);
				jq_listText.attr("oppyDetails", oppyDetails);
			}

			e.stopPropagation();
		});
		
		// Check value. This can be replaced by getOppyDetails().
		var values = [];
		$(".divFieldSet .selectArea input:checked").each(function() {
			values.push($(this).val());
		});
		if (values.length > 0) $(".divFieldSet .checkboxMultiSel").find(".listText").text(values);
	},
	
	
	getOppyDetails: function() {
		var values = [];
		
		$(".divFieldSet .selectArea input:checked").each(function() {
			values.push($(this).val());
		});
		return values;
	},
	
	getOppyDetails2: function() {
		return $.trim($('div.checkboxMultiSel span.listText').text());
	},
	
	//========TOP: Main Table. ========//
	showTable: function(action) {
		try {
			$("#containerPanel_Bottom").html(this.createMainTable());
			$("#" + this.tableId + " tbody").html(this.getOppyDataStr());
			this.initForecastTable();
		} catch(e) {

		}
		
		this.adjustHeaderWidth();
		this.appendRequest("containerPanel_Bottom");
		this.expendChildEvent();
		/*
		if (action == "init") {
			//this.hideMask();
			return true;
		}*/

		// If click "Search" then need to fetch Forecast.
		if (action == "fromDoSearch") {

			//queryOppyFcst(JSON.stringify(this.getOppyIds()), this.mappingIds_bak);
			queryOppyFcst(JSON.stringify(this.map_index_oppyIds[this.searchGroupIndex]), this.mappingIds_bak);
		}
	},
	
	showFcTable: function() {
		this.searchGroupIndex++;
		if (oppyFcstResult.length > 0) {
			this.addOppyForecast();
			this.adjustHeaderWidth();

			// If have more oppy forecast, query again.
			if (this.searchGroupIndex < _.keys(this.map_index_oppyIds).length) {
				queryOppyFcst(JSON.stringify(this.map_index_oppyIds[this.searchGroupIndex]), this.mappingIds_bak);
			} else {
				this.resetCache();
				this.requested = false;
				this.hideMask();
				return true;
			}
		} else {
			this.insertEmptyForecast();
			this.requested = false;
			this.hideMask();
			return true;
		}
	},
	
	adjustHeaderWidth: function() {
		$("#tableHeader").width($("#inlineTable_Bottom").width() + 1);
		$("#inlineTable_Bottom > thead > tr:eq(0) > th").each(function(i, n){
			//$("#tableHeader > th").eq(i).width($(this).width());
			var topTh = $("#tableHeader thead th").eq(i).find("div");
			if (topTh.width() != $(this).width()) {
				topTh.width($(this).width());
			}
		});
	},
	
	adjustFcHeight: function(id) { // Part Id / Partner Id
		return $(".childTable tr[partid='" + id + "']").height();
	},
	
	requested: false,	// A frag means that previous request was already completed.
	appendOppy: function() {
		if (oppyRst.length > 0) {
			$("#inlineTable_Bottom > tbody").append(this.getOppyDataStr());
			this.adjustHeaderWidth();
			this.expendChildEvent();
			queryOppyFcst(JSON.stringify(this.getOppyIds()), this.mappingIds_bak);
		} else {
			//$("#inlineTable_Bottom > tbody").append("There is no more data!");
			$("#endTips").show();
			this.hideMask();
		}
		$("#BVLoadingDiv").hide();
	},
	
	// Get all oppy Ids to search forecasts.
	getOppyIds: function() {
		var oppyIds = _.pluck(oppyRst, "oppyId");
		return oppyIds ? oppyIds : [];
	},
	
	setIdGroup: function() {
		var len = this.getFcLength(), groupNum = Math.ceil(oppyRst.length / len);
		var ids = this.getOppyIds();

		var index = 0;
		for (var i = 0; i < groupNum; i++) {
			var endPoint = index + len;
			var startPoint = index;
			endPoint = endPoint > ids.length ? ids.length : endPoint;

			this.map_index_oppyIds[i] = [];
			for (var j = index; j < endPoint; j++) {
				this.map_index_oppyIds[i][j - startPoint] = ids[j];
				index++;
			}
		}

	},
	
	//========BOTTOM: Main Table. ========//

	
	// Asynchronously append N records to the end of searching result table.
	appendRequest: function(divId) {
		var that = this;
		if (oppyRst.length <= 0) return;
		$("#" + divId).scroll(function() {
			
			$("#tableHeader").css({"top":0 - $("#inlineTable_Bottom").position().top});
			$("#BVLoadingDiv").css({"left":0 - $("#inlineTable_Bottom").position().left});

			if (!that.requested && $("#inlineTable_Bottom").height() + $("#inlineTable_Bottom").position().top <= that.mainTableHeight) {

				$("#BVLoadingDiv").show();
				that.showMask();
				that.requested = true;
				lazySearch(that.mappingIds_bak);
			}
		});
	},
	
	// Collapse/Expend a searching result row.
	jq_childTd: {}, // Show Part/Partner.
	jq_childFCTd: {}, // Show Forecast.
	expendChildEvent: function() {
		var that = this;
		$("#inlineTable_Bottom tr").off("click").on("click", ".imgForPart", function() {

			var oppyId = $(this).parents(".mainRow").attr("oppyId"),
				jq_childTr = $(this).parents(".mainRow").next(".partCon");
			
			that.jq_childTd = jq_childTr.children(".ITTd");
			that.jq_childFCTd = jq_childTr.children(".forecastTd");
			
			var src = $(this).attr("src");
			if(src.indexOf("close") > 0) {
				$(this).attr("src", src.replace("close","open"));
				jq_childTr.show();
				
				//var $that = $(this).parentsUntil("tr").parent().next().children();
				var oppyId = $(this).parents(".mainRow").attr("oppyid");
				var childNum = $(".partCon[pid='" + oppyId + "'] .childTable tbody tr").length;
				//if($that.find("tr").size() < 2) {
				if(childNum == 0) {
					that.showMask();
					queryOppyChildrens(oppyId, that.mappingIds_bak);
					
					/*$that.prepend(loadStr);
					setTimeout(function(){
						$that.children("div").remove();
					}, 1000);*/
				}
			} else {
				$(this).attr("src", src.replace("open","close"));
				jq_childTr.hide();
			}
		});
	},
	
	showPartTable: function() {
		// Append part/partner table.

		this.jq_childTd.append(this.createChildTableHead());
		if (pRst.length <= 0) {
			this.hideMask();
			return false;
		} else {
			this.jq_childTd.find(".childTable tbody").append(this.createChildTable());
			queryOppyChildrensFcst(this.mappingIds_bak); // Query oppy part/partner forecast.
		}
	},
	
	showPartFcTable: function() {
		// Append part/partner table.

		this.jq_childFCTd.append(this.createChildFCTableHead());
		this.jq_childFCTd.find(".childFCTable tbody").append(this.createChildFCTable());
		this.adjustHeaderWidth();
	},
	
	// Create main table, includes Oppy and Oppy & Part / Oppy & Partner
	createMainTable: function() {
		this.fieldSetsLite(); // Refresh all oppy fields base on latest.
		var oppyFields = this.oppyFields, mainTableStr = this.getFixedTheadStr(), mapFsApiLabel = this.mapFsApiLabel();

		mainTableStr += '<table border="0" cellpadding="0" cellspacing="0" class="inlineTable" id="inlineTable_Bottom">' 
					+ '<thead><tr class="BackGd_Green">' 
					+ '<th class="LineHt Tdborder LeftTh TdPadding TextAl_Center "  style="width:15px;"></th>';
		
		// Make table head. TODO: Put api name into TH tag as class.
		for (var i = 0; i < oppyFields.length; i++) {
			//mainTableStr += '<th class="LineHt Tdborder LeftTh TdPadding TextAl_Center oppy">' + oppyFields[i] + '</th>';
			mainTableStr += '<th class="dataCell LineHt EmptyTdBorderB TdPadding TextAl_Center oppy" api="' + mapFsApiLabel[i] + '">' + oppyFields[i] + '</th>';
		}
		mainTableStr += '</tr></thead><tbody>';
		//mainTableStr += this.getOppyDataStr();
		
		// Make table body.
		mainTableStr += '</tbody></table>';
		mainTableStr += '<div class="BVLoadingDiv" id="BVLoadingDiv"><img class="BVLoadingImg" src="' + imgSrc + '" title="Please Wait..."/></div>';
		mainTableStr += '<div class="BVLoadingDiv" id="endTips">No more data...</div>';
		
		return mainTableStr;
	},
	
	// Create fixed thead.
	/*
	getFixedTheadStr: function() {
		var fixedTheadStr = '<ul id="tableHeader" class="BackGd_Green"><li class="LineHt Tdborder LeftTh TdPadding TextAl_Center "  style="width:15px;"></li>';
		for (var i = 0; i < this.oppyFields.length; i++) {
			fixedTheadStr += '<li class="LineHt Tdborder LeftTh TdPadding TextAl_Center">' + this.oppyFields[i] + '</li>';
		}
		fixedTheadStr += '</ul>';
		return fixedTheadStr;
	},*/
	getFixedTheadStr: function() {
		var fixedTheadStr = '<table id="tableHeader" class="BackGd_Green"><thead><tr class="BackGd_Green">';
		fixedTheadStr += '<th class="LineHt Tdborder LeftTh TdPadding TextAl_Center " ><div style="width:15px;"></div></th>';
		for (var i = 0; i < this.oppyFields.length; i++) {
			fixedTheadStr += '<th class="dataCell LineHt EmptyTdBorderB TdPadding TextAl_Center oppy"><div>' + this.oppyFields[i] + '</div></th>';
		}
		fixedTheadStr += '</table>';
		return fixedTheadStr;
	},
	
	getTh: function(oppyFc, action) {
		if (action == "export") {
			return $("#" + this.exportTableId + " thead th").filter(function() {
				if ($(this).attr(oppyFc) && $(this).attr(oppyFc) != "") return true;
			});
		} else {
			return $("#" + this.tableId + " thead th").filter(function() {
				if ($(this).attr(oppyFc) && $(this).attr(oppyFc) != "") return true;
			});
		}
		
	},
	
	// Create Row of opportunity.
	getOppyDataStr: function() {
		if (oppyRst.length === 0) return "";

		var oppyFields = this.oppyFields, mainTableStr = "", that = this, oppyNumber = this.getOppyNumber(),
			fcFields = this.forecastFields(), fieldSetsLite = this.fieldSetsLite();

		var jq_th = this.getTh("api");

		for (var k = 0; k < oppyRst.length; k++) {
			var bg = '';
			if ($(".mainRow").length == 0 || ($(".mainRow").length > 0 && !$(".mainRow:last").hasClass("BackGd_Grey"))) {
				bg = (k % 2 == 0) ? "BackGd_Grey" : "";
			} else {
				bg = (k % 2 == 1) ? "BackGd_Grey" : "";
			}
			
			mainTableStr += '<tr class="mainRow  ' + bg + '" oppyId="' + oppyRst[k]["oppyId"] + '" id="' + oppyRst[k]["oppyId"] 
						+ '"><td class="dataCell LineHt EmptyTdBorderB TdPadding TextAl_Center">'
						+ '<span class="sn">' + (oppyNumber + k + 1) + '</span>';

			if (!_.has(fieldSetsLite, this.fixedFieldSetName)) {
				mainTableStr += '<img src="' + closeImgSrc + '" class="imgForPart" width="15" />';
			}
			
			var map_entries = this.mapColName_Data(oppyRst[k]["list_entries"]);
			var oppyId = oppyRst[k].oppyId;

			jq_th.each(function() {
				var apiName = $(this).attr("api");

				if (apiName) {
					if (apiName == that.SPECIAL_API[0]) { // This is Opportunity_Number__c.
						mainTableStr += '<td class="dataCell EmptyTdBorderB TdPadding TextAl_Center" api="' + apiName +'">' 
									+ '<a href="/' + oppyId + '" target="_blank">' + map_entries[apiName] + '</a></td>';
					} else {
						mainTableStr += '<td class="dataCell EmptyTdBorderB TdPadding TextAl_Center" api="' + apiName +'">' 
									+ ((map_entries[apiName] && map_entries[apiName] != "null") ? map_entries[apiName] : that.SEPERATOR[0]) + '</td>';
					}
				} else {
					mainTableStr += '<td class="dataCell EmptyTdBorderB TdPadding TextAl_Center" api="' + apiName +'">' + that.SEPERATOR[0] + '</td>';
				}
				
			});

			mainTableStr += '</tr>';
			
			// Here insert Part or Partner information.
			mainTableStr += '<tr class="partCon" pid="' + oppyRst[k]["oppyId"] + '"><td></td>'; // Space for look good.
			mainTableStr += '<td colspan="' + oppyFields.length + '" class="ITTd">'; // Shows for Part/Partner.
			mainTableStr += '<td colspan="' + fcFields.length + '" class="forecastTd">'; // Shows for Forecast.
			
			mainTableStr += '</td></tr>';
		}

		return mainTableStr;
	},
	
	// Make table head.
	createChildTableHead: function() {
		var childFields = this.childFields, apiFields = this.getPartApiField(), childTableStr = '';

		if (pRst.length > 0) {
			childTableStr = '<table class="childTable" childNum="' + pRst.length + '" oppyId="' + pRst[0]["oppyId"] + '"><thead><tr>';
		} else {
			childTableStr = '<table class="childTable" childNum="0" "><thead><tr>';
		}
		for (var i = 0; i < apiFields.length; i++) {
			childTableStr += '<th api="' + apiFields[i] + '">' + childFields[i] + '</th>';
		}
		childTableStr += '</tr></thead><tbody></tbody></table>';
		return childTableStr;
	},
	
	// Create a Part / Partner table for a opportunity.
	createChildTable: function() {
		try {
			var childFields = this.childFields, apiFields = this.getPartApiField();
			var childTableStr = '';
			
			
			for (var i = 0; i < pRst.length; i++) {
				if (pRst[i].oppyPartId) childTableStr += '<tr id="' + pRst[i]["oppyPartId"] + '" pId="' + pRst[i]["oppyPartId"] + '">';
				if (pRst[i].oppyPartnerId) childTableStr += '<tr id="' + pRst[i]["oppyPartnerId"] + '" pId="' + pRst[i]["oppyPartnerId"] + '">';
				
				var map_entries = this.mapColName_Data(pRst[i]["list_entries"]);

				for (var j = 0; j < apiFields.length; j++) {
					var oppyVal = (map_entries[apiFields[j]] && map_entries[apiFields[j]] != "null") ? map_entries[apiFields[j]] : this.SEPERATOR[0];
					childTableStr += '<td>' + oppyVal + '</td>';
				}
				childTableStr += '</tr>';
			}
		} catch (err) {
			childTableStr = "catch error:" + err.message;
		}
		return childTableStr;
	},
	
	// Make part/partner forecast table head.
	createChildFCTableHead: function() {
		var fcFields = this.forecastFields(), childTableStr = '';
		
		childTableStr = '<table class="childFCTable"><thead><tr>';
		for (var i = 0; i < fcFields.length; i++) {
			childTableStr += '<th colname="' + fcFields[i] + '">' + fcFields[i] + '</th>';
		}
		childTableStr += '</tr></thead><tbody>';
		return childTableStr;
	},
	
	// Create a Forecast table for Part / Partner.
	createChildFCTable: function() {
		try {
			var fcFields = this.forecastFields(), childTableStr = '';

			// Draw part forecast.
			if (pRst[0].oppyPartId) {
				for (var i = 0; i < pRst.length; i++) {
					//var rowHeight = $(".childTable tr[pid='" + pRst[i].oppyPartId + "']").height();
					var rowHeight = $("#" + pRst[i].oppyPartId).height();
					var map_entries = pFcstRst.lenth > 0 ? this.mapColName_Data(pFcstRst[i]["list_innerDatas"]) : {};

					childTableStr += '<tr pId="' + pRst[i]["oppyPartId"] + '" style="height: ' + rowHeight + 'px;">';
					for (var j = 0; j < fcFields.length; j++) {
						if (map_entries[fcFields[j]] && typeof Number(map_entries[fcFields[j]]) == "number") {
							var fcVal = (map_entries[fcFields[j]] && map_entries[fcFields[j]] != "null") ? 
									Math.round(Number(map_entries[fcFields[j]]) * 100) / 100 : this.SEPERATOR[0];
							var width = $("#" + this.tableId + " thead th[colname='" + fcFields[j] + "']").width();
							childTableStr += '<td style="width: ' + width + 'px;">' + fcVal + '</td>';
						} else {
							childTableStr += '<td style="width: ' + width + 'px;">' + this.SEPERATOR[0] + '</td>';
						}
					}
					childTableStr += '</tr>';
				}
			}
			
			// Draw partner forecast.
			if (pRst[0].oppyPartnerId) {
				for (var i = 0; i < pRst.length; i++) {
					//var rowHeight = $(".childTable tr[pId='" + pRst[i].oppyPartnerId + "']").height();
					var rowHeight = $("#" + pRst[i].oppyPartnerId).height();
					var map_entries = this.mapColName_Data(pRst[i]["list_oppyFcst"]);

					childTableStr += '<tr pId="' + pRst[i]["oppyPartnerId"] + '" style="height: ' + rowHeight + 'px;">';
					for (var j = 0; j < fcFields.length; j++) {
						if (map_entries[fcFields[j]] && typeof Number(map_entries[fcFields[j]]) == "number") {
							var fcVal = (map_entries[fcFields[j]] && map_entries[fcFields[j]] != "null") ? 
									Math.round(Number(map_entries[fcFields[j]]) * 100) / 100 : this.SEPERATOR[0];
							var width = $("#" + this.tableId + " thead th[colname='" + fcFields[j] + "']").width();
							childTableStr += '<td style="width: ' + width + 'px;">' + this.getPartnerValue(pRst[i]["allocation"], fcVal) + '</td>';
						} else {
							childTableStr += '<td style="width: ' + width + 'px;">' + this.SEPERATOR[0] + '</td>';
						}
					}
					childTableStr += '</tr>';
				}
			}
			
			childTableStr += '</tbody>';
		
		} catch (err) {
			childTableStr = "catch error:" + err.message;
		}
		return childTableStr;
	},
	
	// Calculate forecast value for partner.
	getPartnerValue: function(allocation, oppyFc) {
		if (oppyFc == null || oppyFc == "null" || !oppyFc) return this.SEPERATOR[0];
		if (Number(oppyFc) == 0) return oppyFc;
		return Math.round((allocation / 100 * Number(oppyFc)) * 10) / 10;
	},
	
	// Create table of Forecast when initializing.
	initForecastTable: function() {
		// Insert forecast head.
		this.insertForecastHead();
	},
	
	
	// Create table of Forecast when loading more.
	addOppyForecast: function() {

		//if (oppyFcstResult.length <= 0) return ""; // Also draw table border even if "oppyFcstResult" is empty.
		
		var that = this, fcFields = this.forecastFields();
		var oppyIds = _.pluck(oppyFcstResult, "oppyId");
		var totalColumn = this.oppyFields.length + this.forecastFields().length + 1; // The 1 is the first empty column.

		var jq_waitingForFillTrs = $("#" + this.tableId + " tbody tr.mainRow").filter(function(index) {
			return (_.indexOf(oppyIds, $(this).attr("oppyId")) >= 0 && $("td", this).length < totalColumn)
		});
		
		
		// Insert forecast one by one. Match oppy Id; Get all oppyId from "oppyFcstResult";
		for (var k = 0; k < jq_waitingForFillTrs.length; k++) {
			this.insertForecastRow(jq_waitingForFillTrs[k], $(jq_waitingForFillTrs[k]).attr("oppyid"));
		}
	},
	
	// Insert Forecast table head. Just on initialize.
	insertForecastHead: function() {
		// Find place last column.
		var jq_lastTh = $("#" + this.tableId + " th:last");
		jq_lastTh.after(this.getForecastHead());
		
		//var jq_lastFixedLi = $("#tableHeader li:last");
		var jq_lastFixedLi = $("#tableHeader > thead > tr > th:last");
		jq_lastFixedLi.after(this.getForecastFixedHead());
	},
	
	// Get Forecast table head. Just on initialize.
	getForecastHead: function() {
		var headStr = "", fcFields = this.forecastFields();
		for (var i = 0; i < fcFields.length; i++) {
			headStr += '<th class="dataCell LineHt EmptyTdBorderB TdPadding TextAl_Center forecast" colName="' + fcFields[i] + '">' + fcFields[i] + '</th>';
		}
		return headStr;
	},
	
	// Get Forecast Fixed Head
	getForecastFixedHead: function() {
		var headStr = "", fcFields = this.forecastFields();
		for (var i = 0; i < fcFields.length; i++) {
			headStr += '<th class="dataCell LineHt EmptyTdBorderB TdPadding TextAl_Center forecast"><div>' + fcFields[i] + '</div></th>';
		}
		return headStr;
	},
	
	// Insert Forecast table row. Just on initialize.
	insertForecastRow: function(jq_waitingForFillTr, oppyId) {
		// Find place where last column of last row to start to insert base on oppy Id.
		var jq_th = this.getTh("colname");
		$(jq_waitingForFillTr).find("td:last").after(this.getForecastRow(oppyId, jq_th));
	},
	
	// Get Forecast table row. On initialize and on loading more.
	getForecastRow: function(oppyId, jq_th) {
		var rowStr = "", fcFields = this.forecastFields(), that = this;
		var fc = _.find(oppyFcstResult, function(value, key) {return value.oppyId == oppyId});

		var map_entries = fc ? this.mapColName_Data(fc["list_innerDatas"]) : {};

		jq_th.each(function() {
			var colname = $(this).attr("colname");
			
			if (fc !== undefined) {
				rowStr += '<td class="dataCell EmptyTdBorderB TdPadding TextAl_Center" colname="' + colname + '">' 
						+ ((map_entries[colname] && map_entries[colname] != "null") ? map_entries[colname] : that.SEPERATOR[0]) + '</td>';
			} else {
				rowStr += '<td class="dataCell EmptyTdBorderB TdPadding TextAl_Center">' + that.SEPERATOR[0] + '</td>';
			}
			
		});
		
		return rowStr;
	},
	
	getOppyNumber: function() {
		return $("#" + this.tableId + " tbody tr.mainRow").length;
	},
	
	insertEmptyForecast: function() {
		var that = this, jq_th = this.getTh("colname"), totalColumn = this.oppyFields.length + this.forecastFields().length + 1;;
		$("#" + this.tableId + " tbody tr.mainRow").filter(function(index) {
			return $(this).find("td").length < totalColumn;
		}).each(function() {
			$(this).find("td:last").after(that.getForecastRow($(this).attr("oppyId"), jq_th));
		});
	},
	
	mapColName_Data: function(strArray) {

		var dataMap = {};
		if (typeof strArray != "object" || (typeof strArray == "object" && !strArray.length)) return {};
		for (var i = 0; i < strArray.length; i++) {
			var splitData = strArray[i].split("=");
			dataMap[splitData[0]] = splitData[1];
		}
		return dataMap;
	},
	//--------BOTTOM: Deal With Field Set -----------//
		
	//--------TOP: Export Oppy && Part/Partner && Forecast -----------//
	/*
	 * Function 1: Export Oppys & Oppys Forecasts. 
	 * Get all oppy Ids; Calculate number of that send to server base on filter conditions; Deal with result returned; Draw oppy table; 
	 * Query oppy forecast; Draw oppy forecast table;
	 * 
	 * Function 2: Export Part & Part Forecasts. 
	 * Get all Part Ids; Calculate number of that send to server base on filter conditions; Deal with result returned; Draw oppy table; 
	 * Query oppy forecast; Draw oppy forecast table;
	 * 
	 * Function 3: Export Partner & Partner Forecasts. 
	 * Get all Partner Ids; Calculate number of that send to server base on filter conditions; Deal with result returned; Draw oppy table; 
	 * Query oppy forecast; Draw oppy forecast table;
	 * 
	 * Interface Name: oppyExport(); oppyFcstExport(); oppyPartExport(); oppyPartnerExport(); oppyPartFcstExport()
	 */
	// Attributes: For Export  ***** TOP *******//
	maxLimit: 2000,
	OPPY_TYPES: ["Opportunity", "Opportunity & Opportunity Part", "Opportunity & Partner details"],
	OPPY_FIRST_TIME: true,
	exportTableId: "inlineTable_Export",
	map_taskId_groupId: {},	// Map task id to oppy ids.
	map_taskId_status: {}, // Records status for every task.
	map_taskId_reqTimes: {}, // Count the request times for every task.
	parentStatus: false, // Records status for oppy/part/partner.
	lastIdGroup: 0, // Store last id group of oppy.
	oppyPartnerExpt_bak: {}, // Cache all partners.
	map_taskId_params: {}, // Cache all partners.
	test_counter: 0, // JUST FOR TEST.
	// Attributes: For Export  ***** BOTTOM *******//
	
	
	// Add event to Export button. Determines which method that user should to invoke.
	exportStart: function() {
		var isChanged = this.changedFilterValues(), fieldsetLevel = $("#fieldSetSingle").val(), 
			chgFieldSet = (this.fieldSet_bak.level != fieldsetLevel || this.fieldSet_bak.detail != this.getOppyDetails2());
		
		if (isChanged || chgFieldSet || !this.hasSearched) {
			result = this.initPopWin(1, "Please do 'Search' before you 'Export' this!");
			$("#dialog-message").dialog("open");
			
			$.when(result).done(function(value) {
				return false;
			});
		} else {
			var map_mapings={};
			try{
				map_mapings=$.parseJSON(mappingIds);
			}catch(e){
				this.hideMask();
				alert('Please click "Search" at first.');
			}
			if($.isEmptyObject(map_mapings)){
				this.hideMask();
				alert('Please click "Search" at first.');
				return;
			}
			
	
			this.showMask();
			this.initVar();
			this.initExportTable();
		
			event_exportCSV_click(map_mapings);
		}
	},

	// Check if filters has been changed. Added by Qiang Liu at 2015.07.11
	changedFilterValues: function() {
		var jsonData = this.getJson(), data = this.data_bak, dataLength = this.data_bak.length;
		
		for(var i = 0; i < dataLength; i++) {
			for(oppy in data[i]) {
				var cate = data[i][oppy], cateNew = jsonData[i][oppy], cateLength = cate.length;
				for(var j = 0; j < cateLength; j++) {
					console.log("cate[" + j + "].values=", cate[j]["values"] );
					console.log("cateNew[" + j + "].values=", cateNew[j]["values"] );
					
					var oldLen = cate[j]["values"].length, newLen = cateNew[j]["values"].length;
					if (oldLen == 0 && newLen == 0) continue;
					if (oldLen != newLen) return true;
					
					if(cate[j].filterType == this.FILTER_TYPES[1]) { // Multipicklist
						/*
						if (cate[j]["remove"]) delete cate[j]["remove"];
						if (_.isEqual(cate[j]["values"], cateNew[j]["values"])) return true;
						*/
						var cate_sort = _.sortBy(cate[j]["values"], "label");
						var cateNew_sort = _.sortBy(cateNew[j]["values"], "label");
						for (var k = 0; k < oldLen; k++) {
							//if(cate[j]["values"][k].label != cateNew_sort[j]["values"][k].label 
							if(cate_sort[k].label != cateNew_sort[k].label 
									|| cate_sort[k].value != cateNew_sort[k].value) {
								return true;
							}
						}
					} else if(cate[j].filterType == this.FILTER_TYPES[4]) { // Checkbox
						if(cate[j]["values"][0].label.toString() != cateNew[j]["values"][0].label.toString() 
								|| cate[j]["values"][0].value.toString() != cateNew[j]["values"][0].value.toString()) {
							return true;
						}
						
					} else {
						if(cate[j]["values"][0].label != cateNew[j]["values"][0].label 
								|| cate[j]["values"][0].value != cateNew[j]["values"][0].value) {
							return true;
						}
					}
				}
			}
		}
		return false;
	},
	
	queryOppyFcst: function() {	// Query oppy forecast.
		if (oppyExpt.length == 0 && oppyFcstExpt.length == 0) {
			this.hideMask();
			return false;
		}
		
		// Only be invoked two times in one period.
		if (oppyExpt.length > 0 && oppyFcstExpt.length == 0) {
			
			if (this.OPPY_FIRST_TIME) {
				this.OPPY_FIRST_TIME = false;
				oppyFcstExport(JSON.stringify(this.getIds()));
			} else {
				this.OPPY_FIRST_TIME = true;
				oppyExport(this.mappingIds_bak);
			}
		}
		
		
		if (oppyExpt.length > 0 && oppyFcstExpt.length > 0) {
			this.insertFcst();
			oppyFcstExport(JSON.stringify(this.getIds()));
		}
	},
	
	// OLD
	// Query part forecast.
	queryPartFcst: function() {
		if (oppyPartExpt.length == 0 && oppyPartFcstExpt.length == 0) {
			this.hideMask();
			return false;
		}
		
		if (oppyPartExpt.length > 0 && oppyPartFcstExpt.length == 0) {// Only be invoked two times in one period.
			if (this.OPPY_FIRST_TIME) {
				this.OPPY_FIRST_TIME = false;
				oppyPartFcstExport();
			} else {
				this.OPPY_FIRST_TIME = true;
				oppyPartExport(this.mappingIds_bak);
			}
		}
		
		
		if (oppyPartExpt.length > 0 && oppyPartFcstExpt.length > 0) {
			this.insertFcst();
			oppyPartFcstExport();
		}
	},
	
	// OLD
	// Query partner forecast.
	queryPartnerFcst: function() {
		try {
			// The oppyFcstExpt variable is shared by Oppy and Oppy Partner.
			if (oppyPartnerExpt.length == 0 && oppyFcstExpt.length == 0) {
				this.hideMask();
				return false;
			}
			
			// Only be invoked two times in one period.
			if (oppyPartnerExpt.length > 0 && oppyFcstExpt.length == 0) {
				if (this.OPPY_FIRST_TIME) {

					this.OPPY_FIRST_TIME = false;
					oppyPartnerFcstExport(JSON.stringify(this.getIds()));
				} else {

					this.OPPY_FIRST_TIME = true;
					oppyPartnerExport(this.mappingIds_bak);
				}
			}
			
			if (oppyPartnerExpt.length > 0 && oppyFcstExpt.length > 0) {
				this.insertFcst();
				oppyPartnerFcstExport(JSON.stringify(this.getIds()));
			}
		} catch(err) {
			alert("Error: " + err.message);
		}
	},
	
	initVar: function() {	// Clear variable.
		this.map_taskId_groupId = {};
		this.map_taskId_status = {};
		this.parentStatus = false;
		this.lastIdGroup = 0;
		this.test_counter = 0;
	},
	
	initExportTable: function() {
		$("#exportTable").html(this.createTableHeader());
	},
	
	// Create table header(Opyy | Oppy + Part|Partner) and empty body.
	createTableHeader: function() {
		this.fieldSetsLite("export"); // Refresh all oppy fields base on latest.
		var oppyFields = this.oppyFields, mainTableStr = "", mapFsApiLabel = this.mapFsApiLabel("export"), fcFields = this.forecastFields();

		mainTableStr += '<table border="0" cellpadding="0" cellspacing="0" class="inlineTable" id="' + this.exportTableId + '" style="display: none;">' 
					+ '<thead><tr class="BackGd_Green">';
		
		for (var i = 0; i < oppyFields.length; i++) {
			mainTableStr += '<th class="dataCell LineHt EmptyTdBorderB TdPadding TextAl_Center oppy" api="' + mapFsApiLabel[i] + '">' + oppyFields[i] + '</th>';
		}
		
		for (var i = 0; i < fcFields.length; i++) {
			mainTableStr += '<th class="dataCell LineHt EmptyTdBorderB TdPadding TextAl_Center oppy" colname="' + fcFields[i] + '">' + fcFields[i] + '</th>';
		}
		mainTableStr += '</tr></thead><tbody></tbody></table>';
		
		return mainTableStr;
	},
	
	// Insert oppy row.
	insertOppy: function() {
		var oppys = [], oppyType = this.getOppyType();
		if (oppyType == this.OPPY_TYPES[0]) {
			oppys = oppyExpt;
		}
		if (oppyType == this.OPPY_TYPES[1]) {
			oppys = oppyPartExpt;
		}
		if (oppyType == this.OPPY_TYPES[2]) {
			oppys = oppyPartnerExpt;
		}
		if (oppys.length == 0) return false;
		
		
		var that = this, oppyFields = this.oppyFields, mainTableStr = "", jq_th = this.getTh("api", "export");
		//TODO: Should to use one variable replace "oppyExpt", "partExpt", "partnerExpt"
		
		for (var k = 0; k < oppys.length; k++) {
			if (oppyType == this.OPPY_TYPES[0]) {
				mainTableStr += '<tr class="mainRow" oppyId="' + oppys[k]["oppyId"] + '">';
			}
			if (oppyType == this.OPPY_TYPES[1]) {
				mainTableStr += '<tr class="mainRow" oppyId="' + oppys[k]["oppyPartId"] + '">';
			}
			if (oppyType == this.OPPY_TYPES[2]) {
				//mainTableStr += '<tr class="mainRow" oppyId="' + oppys[k]["oppyPartnerId"] + '">';
				mainTableStr += '<tr class="mainRow" oppyId="' + oppys[k]["oppyId"] + '" allocation="' + oppys[k]["allocation"] + '">';
			}

			var map_entries = this.mapColName_Data(oppys[k]["list_entries"]);

			jq_th.each(function() {
				var apiName = $(this).attr("api");

				if (apiName) {
					mainTableStr += '<td class="dataCell EmptyTdBorderB TdPadding TextAl_Center" api="' + apiName +'">' 
								+ ((map_entries[apiName] && map_entries[apiName] != "null") ? map_entries[apiName] : " ") + '</td>';
				} else {
					mainTableStr += '<td class="dataCell EmptyTdBorderB TdPadding TextAl_Center" api="' + apiName +'">' + that.SEPERATOR[0] + '</td>';
				}
			});
			mainTableStr += '</tr>';
			
		}
		$("#" + this.exportTableId + " tbody").append(mainTableStr);
	},
	
	// Insert forecasts of Oppy/Part/Partner.
	insertFcst: function() {
		var forecasts = [], oppyType = this.getOppyType();
		if (oppyType == this.OPPY_TYPES[0]) {
			forecasts = oppyFcstExpt;
		}
		if (oppyType == this.OPPY_TYPES[1]) {
			forecasts = oppyPartFcstExpt;
		}
		if (oppyType == this.OPPY_TYPES[2]) {
			forecasts = oppyFcstExpt;
		}

		var that = this, jq_th = this.getTh("colname", "export"), oppyIds = this.getIds();
		var totalColumn = this.oppyFields.length + this.forecastFields().length;

		var jq_waitingForFillTrs = $("#" + this.exportTableId + " tbody tr.mainRow").filter(function(index) {
			return (_.indexOf(oppyIds, $(this).attr("oppyId")) >= 0 && $("td", this).length < totalColumn);
		});

		jq_waitingForFillTrs.each(function() {
			var rowStr = "", oppyId = $(this).attr("oppyId"); // In fact, oppyId stored oppyId and partId and partnerId.
			var map_entries = {}, allocation = Number($(this).attr("allocation"));

			var fc = _.find(forecasts, function(value, key) {
				if (value.oppyId == oppyId) return true;
				if (value.oppyPartId == oppyId) return true;
				if (value.oppyPartnerId == oppyId) return true;
			});

			map_entries = fc ? that.mapColName_Data(fc["list_innerDatas"]) : {};

			jq_th.each(function() {
				var colname = $(this).attr("colname");
				
				if (fc) {
					if (oppyType == that.OPPY_TYPES[2]) {
						// Draw partner forecast.
						rowStr += '<td class="dataCell EmptyTdBorderB TdPadding TextAl_Center">' 
								//+ that.getPartnerValue(partner[0]["allocation"], map_entries[colname]) + '</td>';
								+ that.getPartnerValue(allocation, map_entries[colname]) + '</td>';
					} else {
						rowStr += '<td class="dataCell EmptyTdBorderB TdPadding TextAl_Center" colname="' + colname + '">' 
								+ ((map_entries[colname] && map_entries[colname] != "null") ? map_entries[colname] : that.SEPERATOR[0]) + '</td>';
					}
				} else {
					rowStr += '<td class="dataCell EmptyTdBorderB TdPadding TextAl_Center">' + that.SEPERATOR[0] + '</td>';
				}
			});
			
			$(this).append(rowStr);
		});
	},
	
	// Check parent eof.
	checkParentEof: function() {
		var oppyType = this.getOppyType(), exportObj = {};
		if (oppyType == this.OPPY_TYPES[0]) {
			exportObj = oppyExpt;
		} else if (oppyType == this.OPPY_TYPES[1]) {
			exportObj = oppyPartExpt;
		} else if (oppyType == this.OPPY_TYPES[2]) {
			exportObj = oppyPartnerExpt;
		}
		
		
		// Check oppy EOF.
		if (exportObj.length == 0) {// && this.ra_checkTaskStatus() // Meet EOF.

			this.parentStatus = true;
			if (this.ra_checkTaskStatus()) {
				this.hideMask();
				return true;
			}
		} else if (exportObj.length > 0) {
			if (oppyType == this.OPPY_TYPES[0]) {
				this.queryOppyFcst2();
			} else if (oppyType == this.OPPY_TYPES[1]) {
				this.queryPartFcst2();
			} else if (oppyType == this.OPPY_TYPES[2]) {
				this.queryPartnerFcst2();
			}
		}
	},
	
	// Check oppy number for select work flow.
	ra_checkParentEof: function() {
		// Check oppy EOF.
		if (this.parentStatus && this.ra_checkTaskStatus()) {//  // Meet EOF.

			this.hideMask();
			return true;
		}
	},
	
	// Query oppy forecast.
	queryOppyFcst2: function() {
		var params = {}, groupNum = this.ra_getGroupNum(); //Math.ceil(oppyExpt.length / len);

		params["types"] = oppyFcstType;
		params["queryYears"] = queryYears;
		params["yearRangeSOQL"] = oppyFcstYearRange;
		params["mappingIds"] = this.mappingIds_bak;
		params["labels"] = labels;
		
		// Iterate to request forecast.
		var endPoint = groupNum + this.lastIdGroup;
		for (var i = this.lastIdGroup; i < endPoint; i++) {
			params["taskId"] = i;
			params["list_oppyIds"] = this.map_taskId_groupId[i];
			this.ra_queryOppyFcst(params);
			this.lastIdGroup++;
		}
		// Query more oppy.
		if (oppyExpt.length > 0) {
			oppyExport(this.mappingIds_bak);
		}
	},
	
	// oppyFcstExport(integer taskId,string types, integer queryYears,string yearRangeSOQL, list<string> list_oppyIds, string mappingIds, string labels){
	ra_queryOppyFcst: function(params) {
		var that = this, taskId = params["taskId"];
		that.test_counter++;
		that.map_taskId_params[params["taskId"]] = $.extend({}, params);
		
		Visualforce.remoting.Manager.invokeAction(oppyFcInterface, 
			params["taskId"], params["types"], params["queryYears"], params["yearRangeSOQL"], 
			params["list_oppyIds"], params["mappingIds"], params["labels"],
			function(result, event) {

				if (event.status) {
					if (result["bGood"]) {
						that.map_taskId_status[result["taskId"]] = true;
						that.ra_makeData(result);
						
					} else {
						that.handleException(result, event, taskId);
					}
					
			    } else {
			    	that.handleException(result, event, taskId);
			    }
		}, {escape: false, timeout: 120000});
	},

	
	// Query partner forecast.
	queryPartnerFcst2: function() {
		var params = {}, groupNum = this.ra_getGroupNum(); //Math.ceil(oppyExpt.length / len);

		params["types"] = oppyFcstType;
		params["queryYears"] = queryYears;
		params["yearRangeSOQL"] = oppyFcstYearRange;
		params["mappingIds"] = this.mappingIds_bak;
		params["labels"] = labels;
		
		// Iterate to request forecast.

		var endPoint = groupNum + this.lastIdGroup;
		for (var i = this.lastIdGroup; i < endPoint; i++) {
			params["taskId"] = i;
			params["list_oppyIds"] = this.map_taskId_groupId[i];
			this.ra_queryOppyFcst(params);
			this.lastIdGroup++;
		}

		// Query more partner.
		if (oppyPartnerExpt.length > 0) {

			oppyPartnerExport(this.mappingIds_bak);
		}
	},
	
	// Query part forecast.
	queryPartFcst2: function() {
		var params = {}, groupNum = this.ra_getGroupNum(); //Math.ceil(oppyPartExport.length / len);

		params["types"] = oppyFcstType;
		params["queryYears"] = queryYears;
		params["yearRangeSOQL"] = oppyFcstYearRange;
		params["list_pids"] = this.getIds();
		params["labels"] = labels;
		
		// Iterate to request forecast.
		var endPoint = groupNum + this.lastIdGroup;
		for (var i = this.lastIdGroup; i < endPoint; i++) {
			params["taskId"] = i;
			params["list_pids"] = this.map_taskId_groupId[i];
			
			this.ra_queryPartFcst(params);
			this.lastIdGroup++;
		}

		// Query more oppy.
		if (oppyPartExpt.length > 0) {
			oppyPartExport(this.mappingIds_bak);
		}
	},
	
	// oppyPartFcstExport(integer taskId,string types,integer queryYears,string yearRangeSOQL, list<string> list_pids,string labels){
	ra_queryPartFcst: function(params) {

		var that = this, taskId = params["taskId"];
		that.test_counter++;
		that.map_taskId_params[params["taskId"]] = $.extend({}, params);
		
		Visualforce.remoting.Manager.invokeAction(partFcInterface, 
			params["taskId"], params["types"], params["queryYears"], params["yearRangeSOQL"], 
			params["list_pids"], params["labels"],
			function(result, event) {

				if (event.status) {
					if (result["bGood"]) {
						that.map_taskId_status[result["taskId"]] = true;
						that.ra_makeData(result);
						
					} else {
						that.handleException(result, event, taskId);
					}
					
				} else {
					that.handleException(result, event, taskId);
				}
		}, {escape: false, timeout: 120000});
	},
	
	// Handle exception.
	handleException: function(r, e, taskId) { // r: result; e: event
		var oppyType = this.getOppyType();
		
		// Exception code.
		if (!this.map_taskId_reqTimes[taskId] || this.map_taskId_reqTimes[taskId] < 3) {
			// Reload data for 3 times and then show error message.
			this.ra_queryOppyFcst(this.map_taskId_params[taskId]);
			
			if (!this.map_taskId_reqTimes[taskId]) {
				this.map_taskId_reqTimes[taskId] = 1;
			} else {
				this.map_taskId_reqTimes[taskId] += 1;
			}
		} else {
			if (r && !r["bGood"]) { // Apex error.
				if (oppyType == this.OPPY_TYPES[0] || oppyType == this.OPPY_TYPES[2]) {
					this.ra_insertFcst_error(this.map_taskId_params["list_oppyIds"], r["msg"]);
				} else if (oppyType == this.OPPY_TYPES[1]) {
					this.ra_insertFcst_error(this.map_taskId_params["list_pids"], r["msg"]);
				}
			} else { // Net or system error.
				if (oppyType == this.OPPY_TYPES[0] || oppyType == this.OPPY_TYPES[2]) {
					this.ra_insertFcst_error(this.map_taskId_params["list_oppyIds"], e.message);
				} else if (oppyType == this.OPPY_TYPES[1]) {
					this.ra_insertFcst_error(this.map_taskId_params["list_pids"], e.message);
				}

			}
			this.map_taskId_status[taskId] = true;
		}
		this.ra_checkParentEof();
	},
	
	// Handle result.
	ra_makeData: function(data) {

		if (!data["wrappers"] || data["wrappers"].length == 0) return false;
		
		var groupId = this.map_taskId_groupId[data["taskId"]];
		
		this.ra_insertFcst(data["wrappers"], groupId);
		this.ra_checkParentEof();
		
	},
	
	// Insert forecasts of Oppy/Part/Partner. JUST FOR REMOTE ACTION.
	ra_insertFcst: function(data, groupId) {
		var forecasts = [], oppyType = this.getOppyType();
		forecasts = data;

		try {
		var that = this, jq_th = this.getTh("colname", "export"), oppyIds = groupId;
		var totalColumn = this.oppyFields.length + this.forecastFields().length;
		
		var jq_waitingForFillTrs = $("#" + this.exportTableId + " tbody tr.mainRow").filter(function(index) {
			return (_.indexOf(oppyIds, $(this).attr("oppyId")) >= 0 && $("td", this).length < totalColumn);
		});
		
		jq_waitingForFillTrs.each(function() {
			var rowStr = "", oppyId = $(this).attr("oppyId"); // In fact, oppyId stored oppyId and partId and partnerId.
			var map_entries = {}, allocation = Number($(this).attr("allocation") == "null" ? "0" : $(this).attr("allocation"));

			var fc = _.find(forecasts, function(value, key) {
				if (value.oppyId == oppyId) return true;
				if (value.oppyPartId == oppyId) return true;
				if (value.oppyPartnerId == oppyId) return true;
			});

			map_entries = fc ? that.mapColName_Data(fc["list_innerDatas"]) : {};

			jq_th.each(function() {
				var colname = $(this).attr("colname");
				
				if (fc) {
					if (oppyType == that.OPPY_TYPES[2]) {
						// Draw partner forecast.
						rowStr += '<td class="dataCell EmptyTdBorderB TdPadding TextAl_Center">' 
								//+ that.getPartnerValue(partner[0]["allocation"], map_entries[colname]) + '</td>';
								+ that.getPartnerValue(allocation, map_entries[colname]) + '</td>';
					} else {
						var fcVal = (map_entries[colname] && map_entries[colname] != "null") ? Math.round(Number(map_entries[colname]) * 100) / 100 : that.SEPERATOR[0];
						rowStr += '<td class="dataCell EmptyTdBorderB TdPadding TextAl_Center" colname="' + colname + '">' 
								+ fcVal + '</td>';
					}
				} else {
					rowStr += '<td class="dataCell EmptyTdBorderB TdPadding TextAl_Center">' + that.SEPERATOR[0] + '</td>';
				}
			});
			
			$(this).append(rowStr);
		});
		} catch (e) {

		}
	},
	
	// Insert forecasts of Oppy/Part/Partner. JUST FOR REMOTE ACTION.
	ra_insertFcst_error: function(groupId, errorMsg) {

		var totalColumn = this.oppyFields.length + this.forecastFields().length;
		
		$("#" + this.exportTableId + " tbody tr.mainRow").filter(function(index) {
			return (_.indexOf(groupId, $(this).attr("oppyId")) >= 0 && $("td", this).length < totalColumn);
		}).append('<td class="dataCell EmptyTdBorderB TdPadding TextAl_Center">' + errorMsg + '</td>');
	},
	
	//********START: Util Functions **********//
	// Get oppy type.
	getOppyType: function() {
		return $("#fieldSetSingle").val();
	},
	
	// Get all Oppy/Part/Partnerd Ids.
	getIds: function() {
		var oppyType = this.getOppyType();
		if (oppyType == this.OPPY_TYPES[0]) {
			return _.pluck(oppyExpt, "oppyId");
		}
		if (oppyType == this.OPPY_TYPES[1]) {
			return _.pluck(oppyPartExpt, "oppyPartId");
		}
		if (oppyType == this.OPPY_TYPES[2]) {
			return _.pluck(oppyPartnerExpt, "oppyId");
		}
	},
	
	// Check whether all task is already complete.
	ra_checkTaskStatus: function() {
		var taskNum = _.keys(this.map_taskId_groupId).length, statusNum = _.keys(this.map_taskId_status).length, allSuccess = true;

		if (statusNum != taskNum) return false;
		
		for (var i = 0; i < _.keys(this.map_taskId_groupId); i++) {
			if (!this.map_taskId_status[i] || this.map_taskId_status[i] == false) {
				allSuccess = false;
				break;
			}
		}
		return allSuccess;
	},
	
	// Get all Oppy/Part/Partnerd Ids.
	ra_getIds: function(fcs) {
		var oppyType = this.getOppyType();
		if (oppyType == this.OPPY_TYPES[0]) {
			return _.pluck(fcs, "oppyId");
		}
		if (oppyType == this.OPPY_TYPES[1]) {
			return _.pluck(fcs, "oppyPartId");
		}
		if (oppyType == this.OPPY_TYPES[2]) {
			return _.pluck(fcs, "oppyId");
		}
	},
	
	// Get group number.
	ra_getGroupNum: function() {
		var oppyType = this.getOppyType(), len = this.getFcLength();
		if (oppyType == this.OPPY_TYPES[0]) {
			return Math.ceil(oppyExpt.length / len);
		}
		if (oppyType == this.OPPY_TYPES[1]) {
			return Math.ceil(oppyPartExpt.length / len);
		}
		if (oppyType == this.OPPY_TYPES[2]) {
			return Math.ceil(oppyPartnerExpt.length / len);
		}
	},
	
	getFcLength: function () {
		var initVal = oppyFcstType == this.fcByWhat[0] ? 1 : 4;
		
		return Math.floor(this.maxLimit / (Number(queryYears) * initVal * 10)) * 10;
	},
	
	// Get oppyIds/partIds for query forecast.
	getIdGroup: function() {
		try {
			var len = this.getFcLength(), groupNum = this.ra_getGroupNum();// Math.ceil(oppyExpt.length / len);
			var ids = this.getIds();
			var maxTaskId = _.keys(this.map_taskId_groupId).length > 0 ? Number(_.keys(this.map_taskId_groupId)[_.keys(this.map_taskId_groupId).length - 1]) : 0;
			var index = 0;
			
			if (maxTaskId > 0) maxTaskId++;

			for (var i = 0; i < groupNum; i++) {
				var endPoint = index + len;
				var startPoint = index;
				endPoint = endPoint > ids.length ? ids.length : endPoint;
				
				this.map_taskId_groupId[maxTaskId + i] = [];

				for (var j = index; j < endPoint; j++) {
					//if (this.map_taskId_groupId[maxTaskId + i]) this.map_taskId_groupId[maxTaskId + i] = [];
					this.map_taskId_groupId[maxTaskId + i][j - startPoint] = ids[j];
					index++;
				}
			}

		} catch(e) {

		}
	}
	//--------BOTTOM: Export Oppy && Partner/Partner && Forecast -----------//
}
//--------TOP: Added by Qiang Liu -----------//
;function backupData(data) {
	var d = [], len = data.length;
	for (var i = 0; i < len; i++) {
		var o = $.extend(true, {}, data[i]);
		//var o = _.extendOwn({}, data[i]);
		d.push(o);
	}
	return d;
}
//--------BOTTOM: Added by Qiang Liu -----------//

var TIMEOUT, TIMEFLOAT, LIST_OPPYIDS=[], LIST_CSV=[], OBJECT_CSV={}, QUEUE=async.queue(queueRun, 1);

;function initCtrlDocument(){
	Globalize.culture(this.locale).numberFormat.currency.symbol = "";
}

;function initForecastTable(list_colunm, list_colunmChildren){
	var $table=$('#tableHeader'), $table_children=$('#childDiv table'), $float_head=$('#floathead'),
		element_th='<tr class="">', element_col='', element_child_col='', element_td='<tr>', 
		element_th_children='<tr>', element_td_children='<tr>';
	
	$('#fieldhideboxid').remove();
	$table.find('#tab_body').html('').parent().find('col').remove();
	
	for(var i=0, header; header=list_colunm[i]; i++){
		var cls=(i == 0 ? 'first' : ''), isfc=(header['isFC'] ? ('fccls_'+i) : header['apiName']);
	//	element_col += '<col class="'+isfc+'"/>';
		element_th += ('<th api="'+header['apiName']+'" iscomponent="'+header['iscomponent']+'" label="'+header['label']+'" isfc="'+header['isFC']+'" class="thstyle '+cls+' '+isfc+' "><div>'+header['label']+'<span asc="▲" class="filter_orderby" desc="▼">▲</span></div></th>');
		element_td += ('<td api="'+header['apiName']+'" isfc="'+header['isFC']+'" data-val="'+(header['isFC']?'-':'')+'" class="tdstyle">'+(header['isFC']?'-':' ')+'</td>');
	}
	for(var i=0, header; header=list_colunmChildren[i]; i++){
		var isfc=(header['isFC'] ? ('fccls_'+i) : header['apiName']);
	//	element_child_col += '<col class="'+isfc+'"/>';
		element_th_children += ('<th api="'+header['apiName']+'" isfc="'+header['isFC']+'" class="'+isfc+'"><div>'+header['label']+'</div></th>');
		element_td_children += ('<td api="'+header['apiName']+'" isfc="'+header['isFC']+'" class=""> </td>');
	}
	element_th += '</tr>';
	element_td += '</tr>';

	$table.append(element_col);
	$table.find('#tab_head').html(element_th);
	$table.find('#tab_foot').html(element_td);
	$float_head.html(element_th).parent().find('col').remove();
	$float_head.parent().append(element_col);
	
	$table_children.find('thead').html(element_th_children).parent().find('col').remove();
	$table_children.find('tfoot').html(element_td_children).parent().append(element_child_col);
	$('#containerPanel_Bottom').removeClass('loaddata').off('scroll').on('scroll', event_divTable_scroll);
}

;function initForecastBody(){

	var map_mapings={}, opType=forecastFilter.getOppyType(), 
		p={'json': {'types': oppyFcstType, 'queryYears': parseInt(queryYears), 'list_oppyIds': [], 'mappingIds': {},
					'set_pids': [], 'querySOQL': mainSOQL, 'soqlYearRange': 'oppyFcstYearRange',
					'yearRangeSOQL': oppyFcstYearRange, 'set_labels': $.parseJSON(labels), 
					'list_fields': $.parseJSON($('[id*=jsonlistfilterid]').val()), 
					'details': $.trim($('div.checkboxMultiSel span.listText').text()).split(',') }, 'issub': true,
			'$loading': $('.LoadingDiv'), 'action': asynOppyExportNew_JS, 'complete': complete_asynOppyExportNewTable,
			'action_fc': oppyFcstExportNew_JS, 'complete_fc': complete_oppyFcstExportNewTable};
	LIST_OPPYIDS=[];
	try{
		map_mapings=$.parseJSON(mappingIds);
	}catch(e){
		p['$loading'].hide();
		alert('No Records found, please adjust your search criteria.');
		return;
	}
	if($.isEmptyObject(map_mapings)){
		p['$loading'].hide();
		alert('No Records found, please adjust your search criteria.');
		return;
	}
	if(p['$loading'].find('#statusDiv').length == 0){
		p['$loading'].append( ('<div id="statusDiv" class="statusDiv">' +
								'<div class="leftstatus"></div><div class="rightstatus"></div>' +
								'<div class="leftstatus_part"></div><div class="rightstatus_part"></div>' +
								'</div>') );
	}
	
	initFieldHide();
	
	switch(opType){
		case forecastFilter.OPPY_TYPES[0]:
			p['issub']=false;
			initOppyFcst(p, map_mapings);
			break;
		case forecastFilter.OPPY_TYPES[1]:
		case forecastFilter.OPPY_TYPES[2]:
			initOppyFcst(p, map_mapings);
			break;
		default:
			alert('Error.');
			break;
	}
	
		
	;function initFieldHide(){
		var ul='<ul class="hidefieldcls">', d=('<div id="fieldhideboxid" class="Component Component-fs">' +
				'<div class="ComponentName"><div>Hide Column</div></div>'+
				'<div class="ComponentContent comphover"><div class="checkboxMultiSel"><span class="listhideText" style="cursor: default;">--Please Select--</span>');
		
		$('#tab_head th[iscomponent="true"]').each(function(idx){
			var $this=$(this);
			ul += ('<li api="'+$this.attr('api')+'"><input type="checkbox" id="c_'+idx+'" style="vertical-align:middle;"/>' +
					'<label for="c_'+idx+'" style="vertical-align:middle;">'+$this.attr('label')+'</label></li>');
		});
		ul += '</ul>';
		$('#fieldboxid').append( d+ul+'</div></div></div>' ).find('#fieldhideboxid input').off('click').on('click', event_hideField_click);
	}

	
	;function initOppyFcst(params){

		var list_tmp=[], list_action=[];
		for(var key in map_mapings){
			LIST_OPPYIDS.push(key);
		}
		$('#tab_head th:first div').append(LIST_OPPYIDS.length);
		$('#floathead th:first div').append(LIST_OPPYIDS.length);
		list_tmp=LIST_OPPYIDS.splice(0,100);
		for(var i=0, len=list_tmp.length; i<len; i+=50){
			var s=$.extend({}, params), list_oppyIds=list_tmp.slice(i,i+50);
			s['json']['mappingIds']={};
			s['index']=i;
			while(list_oppyIds.length > 0){
				var ids=list_oppyIds.shift();
				s['json']['mappingIds'][ids]=map_mapings[ids];
			}
			s['json']=JSON.stringify(s['json']);
			list_action.push(s);
		}
		
		async.eachSeries(list_action, function(item, callback) {
	        setTimeout(function(){
	        	params['$loading'].find('#statusDiv div.leftstatus').append('<span class="statusSpan opp" data-index="opp_'+item['index']+'"></span>');
				customRemoteAction(item, item['action'], item['complete']);
				
				params['$loading'].find('#statusDiv div.rightstatus').append('<span class="statusSpan oppfc" data-index="oppfc_'+item['index']+'"></span>');
				customRemoteAction(item, item['action_fc'], item['complete_fc']);
	            callback(null);
	        }, 160);
	    }, function(err){
	    	list_action=[];
	    });
	}
}

;function event_register(){
//	$('#floathead th').off('click').on('click', event_sortFloatTable_click);
//	$('#tab_head th').off('click').on('click', event_sortTable_click);
}

;function event_hideField_click(e){
	if($('#containerPanel_Bottom').hasClass('loaddata')){
		alert('Please waiting for scroll load data.');
		return false;
	}
	
	var $this=$(this), $li=$this.parent(), api=$li.attr('api'), $table=$('#tableHeader'), $thead=$('#floathead');
	
	if($this.is(':checked')){
		$table.find('td[api="'+api+'"]').addClass('dn');
		$table.find('th[api="'+api+'"]').addClass('dn');
		$thead.find('th[api="'+api+'"]').addClass('dn');
		$table.find('td.tdsubchildcls').attr('colspan', function(){
			return parseInt($(this).attr('colspan'))-1;
		});
	}else{
		$table.find('td[api="'+api+'"]').removeClass('dn');
		$table.find('th[api="'+api+'"]').removeClass('dn');
		$thead.find('th[api="'+api+'"]').removeClass('dn');
		$table.find('td.tdsubchildcls').attr('colspan', function(){
			return parseInt($(this).attr('colspan'))+1;
		});
	}
	
}

;function event_sortFloatTable_click(e){
	if($('#containerPanel_Bottom').hasClass('loaddata')){
		alert('Please waiting for scroll load data.');
		return false;
	}
	
	var _this=this, $this=$(_this), $thead=$this.parent(), $body=$('#tab_body'),
		$span=$this.find('span.filter_orderby'), config={'cell': _this.cellIndex, 'isfc': $this.attr('isfc')},
        executeFn=((!$span.hasClass('asc') && !$span.hasClass('desc')) || $span.hasClass('desc') ? sortASC : sortDESC);

	executeFn();
	
	;function sortASC(){
		QUEUE.push({name: 'asc', run: function(cb){
			async.sortBy($body.find('tr').toArray(), function(item, callback) {
			    setTimeout(function() {
			        callback(null, ($(item).find('td:eq('+config['cell']+')').attr('data-val')*+1));
			    }, 80);
			}, function(err, results) {
				$body.html(results);
				$thead.find('span.filter_orderby').removeClass('asc desc');
				$('#tab_head span.filter_orderby').removeClass('asc desc').parent().parent()
							.eq(config['cell']).find('span.filter_orderby').addClass('asc').html(function(){
					return this.getAttribute('asc');
				});
				
				$span.addClass('asc').html(function(){
					return this.getAttribute('asc');
				});
	            cb(null);
			});
        }}, function(err){ });
		
	}
	
	;function sortDESC(){
		QUEUE.push({name: 'asc', run: function(cb){
			async.sortBy($body.find('tr').toArray(), function(item, callback) {
			    setTimeout(function() {
			        callback(null, ($(item).find('td:eq('+config['cell']+')').attr('data-val')*-1) );
			    }, 60);
			}, function(err, results) {
				$body.html(results);
				$thead.find('span.filter_orderby').removeClass('asc desc');
				$('#tab_head span.filter_orderby').removeClass('asc desc').parent().parent()
							.eq(config['cell']).find('span.filter_orderby').addClass('desc').html(function(){
					return this.getAttribute('desc');
				});
				
				$span.addClass('desc').html(function(){
					return this.getAttribute('desc');
				});
	            cb(null);
			});
        }}, function(err){ });
		
	}
}

;function event_sortTable_click(e){
	
	if($('#containerPanel_Bottom').hasClass('loaddata')){
		alert('Please waiting for scroll load data.');
		return false;
	}
	
	var _this=this, $this=$(_this), $thead=$this.parent(), $body=$('#tab_body'),
		$span=$this.find('span.filter_orderby'), config={'cell': _this.cellIndex, 'isfc': $this.attr('isfc')},
        executeFn=((!$span.hasClass('asc') && !$span.hasClass('desc')) || $span.hasClass('desc') ? sortASC : sortDESC);

	executeFn();
	
	;function sortASC(){
		
		QUEUE.push({name: 'asc', run: function(cb){
			async.sortBy($body.find('tr').toArray(), function(item, callback) {
			    setTimeout(function() {
			    	var $td=$(item).find('td:eq('+config['cell']+')'), d=$td.attr('data-val');
			    	if($td.attr('isfc') == 'true'){
			    		d = (d == '-' ? (d*+1) : (parseFloat(d)*+1));
			    	}
			        callback(null, d);
			    }, 80);
			}, function(err, results) {
				$body.html(results);
				$thead.find('span.filter_orderby').removeClass('asc desc');
				$('#floathead span.filter_orderby').removeClass('asc desc').parent().parent()
							.eq(config['cell']).find('span.filter_orderby').addClass('asc').html(function(){
					return this.getAttribute('asc');
				});
				
				$span.addClass('asc').html(function(){ return this.getAttribute('asc'); });
	            cb(null);
			});
        }}, function(err){ });
		
	}
	
	;function sortDESC(){
		
		QUEUE.push({name: 'asc', run: function(cb){
			async.sortBy($body.find('tr').toArray(), function(item, callback) {
			    setTimeout(function() {
			    	var $td=$(item).find('td:eq('+config['cell']+')'), d=$td.attr('data-val');
			    	if($td.attr('isfc') == 'true'){
			    		d = (d == '-' ? (d*-1) : (parseFloat(d)*-1));
			    	}
			        callback(null, d);
			    }, 60);
			}, function(err, results) {
				$body.html(results);
				$thead.find('span.filter_orderby').removeClass('asc desc');
				$('#floathead span.filter_orderby').removeClass('asc desc').parent().parent()
							.eq(config['cell']).find('span.filter_orderby').addClass('desc').html(function(){
					return this.getAttribute('desc');
				});
				
				$span.addClass('desc').html(function(){ return this.getAttribute('desc'); });
	            cb(null);
			});
        }}, function(err){ });
		
	}
	
}

;function event_exportCSV_click(map_mapings){
	
	var opType=forecastFilter.getOppyType(), 
		p={'json': {'types': oppyFcstType, 'queryYears': parseInt(queryYears), 'list_oppyIds': [], 'mappingIds': {},
					'set_pids': [], 'querySOQL': mainSOQL, 'soqlYearRange': 'oppyFcstYearRange',
					'yearRangeSOQL': oppyFcstYearRange, 'set_labels': $.parseJSON(labels), 
					'list_fields': $.parseJSON($('[id*=jsonlistfilterid]').val()), 
					'details': $.trim($('div.checkboxMultiSel span.listText').text()).split(',') },
			'$loading': $('.LoadingDiv'), 'list_head': [], 'object_head': {}, 'object_name': {}, 'object_tmp': {}, 'object_apiName': {},
			'action_opp': asynOppyExportNew_JS, 'complete_opp': complete_asynOppyExportNew,
			'action_oppfc': oppyFcstExportNew_JS, 'complete_oppfc': complete_oppyFcstExportNew,
			'action_part': asynOppyPartExportNew_JS, 'complete_part': complete_asynOppyPartExportNew,
			'action_partfc': oppyPartFcstExportNew_JS, 'complete_partfc': complete_oppyPartFcstExportNew,
			'action_partner': asynOppyPartnerExportNew_JS, 'complete_partner': complete_asynOppyPartnerExportNew};

	if(p['$loading'].find('#statusDiv').length == 0){
		p['$loading'].append( ('<div id="statusDiv" class="statusDiv">' +
								'<div class="leftstatus"></div><div class="rightstatus"></div>' +
								'<div class="leftstatus_part"></div><div class="rightstatus_part"></div>' +
								'</div>') );
	}
	
	for(var i=0, header; header=list_exportcolumn[i]; i++){
		p['object_head'][header['apiName']]='';
		p['object_name'][header['apiName']]=header['label'];
		p['object_tmp'][header['label']]='';
		p['list_head'].push(header['label']);
	}
	/*
	$('#tab_head th:not(:first)').each(function(){
		var attribute=this.getAttribute('api'), _text=$.trim($(this).find('div').html());
		if(attribute != null){
			p['object_head'][attribute]='';
			p['object_name'][attribute]=_text;
			p['object_tmp'][_text]='';
		}
	});
	*/
	
	LIST_CSV=[];
	OBJECT_CSV={};
	
	switch(opType){
		case forecastFilter.OPPY_TYPES[0]:
			exportOppy(map_mapings, p);
			break;
		case forecastFilter.OPPY_TYPES[1]:
			exportOppyANDPart(map_mapings, p);
			break;
		case forecastFilter.OPPY_TYPES[2]:
			exportOppyANDPartner(map_mapings, p);
			break;
		default:
			alert('Error.');
			break;
	}
	
}

;function exportOppyANDPartner(map_mapings, p){

	var list_tmp=[], list_action=[];

	for(var key in map_mapings){
		list_tmp.push(key);
	}
	
	for(var i=0, len=list_tmp.length; i<len; i+=300){
		var s=$.extend({}, p), list_oppyIds=list_tmp.slice(i,i+300);
		s['json']['mappingIds']={};
		s['index']=i;
		while(list_oppyIds.length > 0){
			var ids=list_oppyIds.shift();
			s['json']['mappingIds'][ids]=map_mapings[ids];
		}
		s['json']=JSON.stringify(s['json']);
		list_action.push(s);
	}
	
	async.eachSeries(list_action, function(item, callback) {
        setTimeout(function(){
        	p['$loading'].find('#statusDiv div.leftstatus_part').append('<span class="statusSpan partner" data-index="partner_'+item['index']+'"></span>');
			customRemoteAction(item, item['action_partner'], item['complete_partner']);
            callback(null);
        }, 160);
    }, function(err){
    	map_mapings={};
    });
}

;function exportOppyANDPart(map_mapings, p){
	var str_element='<tr>', $template=$('#exportTable'), list_tmp=[], list_part_tmp=[], list_action=[], list_part_action=[];
	for(var key in map_mapings){
		list_tmp.push(key);
		Array.prototype.push.apply(list_part_tmp, map_mapings[key]); 
	}

	for(var i=0, len=list_part_tmp.length; i<len; i+=500){
		var s=$.extend({}, p), list_partIds=list_part_tmp.slice(i,i+500);
		s['index']=i;
		s['json']['set_pids']=list_partIds;
		s['json']=JSON.stringify(s['json']);
		list_part_action.push(s);
	}
	
	$template.find('thead th').each(function(){
		str_element +='<td api="'+this.getAttribute('api')+'" colname="'+this.getAttribute('colname')+'"> </td>';
	});
	str_element += '</tr>';

	async.eachSeries(list_part_action, function(item, callback) {
        setTimeout(function(){
        	item['str_element'] = str_element;
        	p['$loading'].find('#statusDiv div.leftstatus_part').append('<span class="statusSpan part" data-index="part_'+item['index']+'"></span>');
			customRemoteAction(item, item['action_part'], item['complete_part']);
			
			p['$loading'].find('#statusDiv div.rightstatus_part').append('<span class="statusSpan partfc" data-index="partfc_'+item['index']+'"></span>');
			customRemoteAction(item, item['action_partfc'], item['complete_partfc']);
            callback(null);
        }, 160);
    }, function(err){
    	list_part_action=[];
    	map_mapings={};
    });
}

;function exportOppy(map_mapings, p){
	var list_tmp=[], list_action=[], list_action=[];
	for(var key in map_mapings){
		list_tmp.push(key);
	}
	for(var i=0, len=list_tmp.length; i<len; i+=300){
		var s=$.extend({}, p), list_oppyIds=list_tmp.slice(i,i+300);
		s['json']['mappingIds']={};
		s['index']=i;
		while(list_oppyIds.length > 0){
			var ids=list_oppyIds.shift();
			s['json']['mappingIds'][ids]=map_mapings[ids];
		}
		s['json']=JSON.stringify(s['json']);
		list_action.push(s);
	}
	
	async.eachSeries(list_action, function(item, callback) {
		
        setTimeout(function(){
        	p['$loading'].find('#statusDiv div.leftstatus').append('<span class="statusSpan opp" data-index="opp_'+item['index']+'"></span>');
			customRemoteAction(item, item['action_opp'], item['complete_opp']);
			
			p['$loading'].find('#statusDiv div.rightstatus').append('<span class="statusSpan oppfc" data-index="oppfc_'+item['index']+'"></span>');
			customRemoteAction(item, item['action_oppfc'], item['complete_oppfc']);
            callback(null);
        }, 160);
    }, function(err){
    	list_action=[];
    	map_mapings={};
    });
	
}

;function complete_actionfunction_doSearch(){
	forecastFilter.resetCache();
	console.log('list_colunm: '+list_colunm);
	console.log('list_colunmChildren: '+list_colunmChildren);
	initForecastTable(list_colunm, list_colunmChildren);
	initForecastBody();	//this is init remoteaction
	event_register();
}

;function complete_asynOppyPartnerExportNew(result, event, data){
	QUEUE.push({name: data['index'], run: function(cb){

		var $status_cell=data['$loading'].find('span.partner[data-index="partner_'+data['index']+'"]').eq(0);

		if(event.status){
			result=$.parseJSON(result);
    		while(result.length > 0){
    			var object=result.shift(), o=$.extend({}, data['object_tmp']);

    			for(var key in object['map_field_value']){
    				if(data['object_head'].hasOwnProperty(key)){
    					var keyText=data['object_name'][key];
    					o[keyText]=object['map_field_value'][key];
    				}
				}
				LIST_CSV.push(o);
    		}
    		
    		$status_cell.animate({backgroundColor: '#51C957'}, 130, function(){
    			$status_cell.parent().find('b.reload_img').off('click').remove();
				$status_cell.remove();
				if(data['$loading'].find('span.statusSpan').length == 0){
					
					var map_empty=$.extend({}, data['object_head']), obj_empty={};
					
					for(var key in map_empty){
						var keyText=data['object_name'][key];
						obj_empty[keyText]=' ';
					}
					LIST_CSV.push(obj_empty);
					generateCSVfile(LIST_CSV, 'apl_apl_Opportunity Partner.csv');
					$('div.LoadingDiv').hide();
					LIST_CSV=[];
				}
	    		cb(null);
			});
		}else{
			reLoadRefData($status_cell, data);
			cb(null);
		}
		
    }}, function(err){ });

    ;function reLoadRefData($status_cell, data){
		var $parent=$status_cell.parent();
		if($parent.find('b.reload_img').length == 0){
			$parent.find('span:first').before('<b class="reload_img"></b>');
		}
    	$status_cell.css({'cursor': 'pointer'})
					.animate({backgroundColor: '#C95151'}, 230).on('click', function(e){
						e.stopPropagation();
						$(this).off('click');
						$status_cell.animate({backgroundColor: '#517BC9'}, 130).css({'cursor': 'default'}).find('b').remove();
						customRemoteAction(data, data['action_partner'], data['complete_partner']);
					}).append('<b class="ref_msg">'+event['message']+'</b>');
    	event_publicReload_click($parent);
    }

}

;function complete_oppyPartFcstExportNew(result, event, data){
	QUEUE.push({name: data['index'], run: function(cb){

		var $status_cell=data['$loading'].find('span.partfc[data-index="partfc_'+data['index']+'"]').eq(0);
		
		if(event.status){
    		var $export_tbody=$('#exportTable tbody'), $clone_tr=$(data['str_element']).clone();

    		while(result['wrappers'].length > 0){
    			var object=result['wrappers'].shift(), o=$.extend({}, data['object_tmp']);

    			if(OBJECT_CSV.hasOwnProperty(object['oppyPartId'])){
    				o=OBJECT_CSV[object['oppyPartId']];
    			}
    			while(object['list_innerDatas'].length > 0){
					var list_innerDatas=object['list_innerDatas'].shift().split('=');
					if(data['object_head'].hasOwnProperty(list_innerDatas[0])){
    					var keyText=data['object_name'][list_innerDatas[0]];
    					o[keyText]=list_innerDatas[1];
    					OBJECT_CSV[object['oppyPartId']]=o;
    				}
				}
    		}
    		
    		$status_cell.animate({backgroundColor: '#51C957'}, 130, function(){
    			$status_cell.parent().find('b.reload_img').off('click').remove();
				$status_cell.remove();
				if(data['$loading'].find('span.statusSpan').length == 0){
					var list_csv=[];
					for(var key in OBJECT_CSV){
						list_csv.push( OBJECT_CSV[key] );
					}
					list_csv.push($.extend({}, data['object_head']));
					generateCSVfile(list_csv, 'apl_Opportunity part.csv');
					$('div.LoadingDiv').hide();
					OBJECT_CSV={};
				}
	    		cb(null);
			});
		}else{
			reLoadRefData($status_cell, data);
			cb(null);
		}
		
    }}, function(err){ });

    ;function reLoadRefData($status_cell, data){
		var $parent=$status_cell.parent();
		if($parent.find('b.reload_img').length == 0){
			$parent.find('span:first').before('<b class="reload_img"></b>');
		}
    	$status_cell.css({'cursor': 'pointer'})
					.animate({backgroundColor: '#C95151'}, 230).on('click', function(e){
						e.stopPropagation();
						$(this).off('click');
						$status_cell.animate({backgroundColor: '#517BC9'}, 130).css({'cursor': 'default'}).find('b').remove();
						customRemoteAction(data, data['action_partfc'], data['complete_partfc']);
					}).append('<b class="ref_msg">'+event['message']+'</b>');
    	event_publicReload_click($parent);
    }

}

;function complete_asynOppyPartExportNew(result, event, data){
	
	QUEUE.push({name: (data['index']+'_1'), run: function(cb){
		var $status_cell=data['$loading'].find('span.part[data-index="part_'+data['index']+'"]').eq(0);
		if(event.status){
    		var $export_tbody=$('#exportTable tbody'), $clone_tr=$(data['str_element']).clone();
    		while(result['wrappers'].length > 0){
    			var object=result['wrappers'].shift(), o=$.extend({}, data['object_tmp']);

    			if(OBJECT_CSV.hasOwnProperty(object['oppyPartId'])){
    				o=OBJECT_CSV[object['oppyPartId']];
    			}
    			while(object['list_entries'].length > 0){
					var list_innerDatas=object['list_entries'].shift().split('=');
					if(data['object_head'].hasOwnProperty(list_innerDatas[0])){
    					var keyText=data['object_name'][list_innerDatas[0]];
    					o[keyText]=list_innerDatas[1];
    					OBJECT_CSV[object['oppyPartId']]=o;
    				}
				}
    		}
    		
    		$status_cell.animate({backgroundColor: '#51C957'}, 130, function(){
    			$status_cell.parent().find('b.reload_img').off('click').remove();
				$status_cell.remove();
				if(data['$loading'].find('span.statusSpan').length == 0){
					var list_csv=[];
					for(var key in OBJECT_CSV){
						list_csv.push( OBJECT_CSV[key] );
					}
					list_csv.push($.extend({}, data['object_head']));
					generateCSVfile(list_csv, 'apl_Opportunity part.csv');
					$('div.LoadingDiv').hide();
					OBJECT_CSV={};
				}
	    		cb(null);
			});
		}else{
			reLoadRefData($status_cell, data);
			cb(null);
		}
		
    }}, function(err){ });

    ;function reLoadRefData($status_cell, data){
    	var $parent=$status_cell.parent();
		if($parent.find('b.reload_img').length == 0){
			$parent.find('span:first').before('<b class="reload_img"></b>');
		}
    	$status_cell.css({'cursor': 'pointer'})
					.animate({backgroundColor: '#C95151'}, 230).on('click', function(e){
						e.stopPropagation();
						$(this).off('click');
						$status_cell.animate({backgroundColor: '#517BC9'}, 130).css({'cursor': 'default'}).find('b').remove();
						customRemoteAction(data, data['action_part'], data['complete_part']);
					}).append('<b class="ref_msg">'+event['message']+'</b>');
    	event_publicReload_click($parent);
    }

	
}

;function complete_oppyFcstExportNew(result, event, data){
	QUEUE.push({name: data['index'], run: function(cb){

		var $status_cell=data['$loading'].find('span.oppfc[data-index="oppfc_'+data['index']+'"]').eq(0);

		if(event.status){
    		var $export_tbody=$('#exportTable tbody'), $clone_tr=$('#inlineTable_Bottom tbody tr:eq(0)').clone();
    		$clone_tr.removeAttr('oppyid').find('td').html('').eq(0).remove();
    		while(result['wrappers'].length > 0){
    			var object=result['wrappers'].shift(), o=$.extend({}, data['object_tmp']);

    			if(OBJECT_CSV.hasOwnProperty(object['oppyId'])){
    				o=OBJECT_CSV[object['oppyId']];
    			}
    			while(object['list_innerDatas'].length > 0){
					var list_innerDatas=object['list_innerDatas'].shift().split('=');
					if(data['object_head'].hasOwnProperty(list_innerDatas[0])){
    					var keyText=data['object_name'][list_innerDatas[0]];
    					o[keyText]=list_innerDatas[1];
    					OBJECT_CSV[object['oppyId']]=o;
    				}
				}
    		}
    		
    		$status_cell.animate({backgroundColor: '#51C957'}, 130, function(){
    			$status_cell.parent().find('b.reload_img').off('click').remove();
				$status_cell.remove();
				if(data['$loading'].find('span.statusSpan').length == 0){
					var list_csv=[];
					for(var key in OBJECT_CSV){
						list_csv.push( OBJECT_CSV[key] );
					}
					list_csv.push($.extend({}, data['object_head']));
					generateCSVfile(list_csv, 'apl_Opportunity.csv');
					$('div.LoadingDiv').hide();
					OBJECT_CSV={};
				}
	    		cb(null);
			});
		}else{
			reLoadRefData($status_cell, data);
			cb(null);
		}
		
    }}, function(err){ });

    ;function reLoadRefData($status_cell, data){
		var $parent=$status_cell.parent();
		
    	if($parent.find('b.reload_img').length == 0){
			$parent.find('span:first').before('<b class="reload_img"></b>');
		}
    	
    	$status_cell.css({'cursor': 'pointer'})
					.animate({backgroundColor: '#C95151'}, 230).on('click', function(e){
						e.stopPropagation();
						$(this).off('click');
						$status_cell.animate({backgroundColor: '#517BC9'}, 130).css({'cursor': 'default'}).find('b').remove();
						customRemoteAction(data, data['action_oppfc'], data['complete_oppfc']);
					}).append('<b class="ref_msg">'+event['message']+'</b>');
    	
    	event_publicReload_click($parent);
    }

}

;function complete_asynOppyExportNew(result, event, data){
	
	QUEUE.push({name: (data['index']+'_1'), run: function(cb){

		var $status_cell=data['$loading'].find('span.opp[data-index="opp_'+data['index']+'"]').eq(0);

		if(event.status){
    		var $export_tbody=$('#exportTable tbody'), $clone_tr=$('#inlineTable_Bottom tbody tr:eq(0)').clone();
    		$clone_tr.removeAttr('oppyid').find('td').html('').eq(0).remove();
    		while(result['wrappers'].length > 0){
    			var object=result['wrappers'].shift(), o=$.extend({}, data['object_tmp']);

    			if(OBJECT_CSV.hasOwnProperty(object['oppyId'])){
    				o=OBJECT_CSV[object['oppyId']];
    			}
    			while(object['list_entries'].length > 0){
					var list_innerDatas=object['list_entries'].shift().split('=');
					if(data['object_head'].hasOwnProperty(list_innerDatas[0])){
    					var keyText=data['object_name'][list_innerDatas[0]];
    					o[keyText]=list_innerDatas[1];
    					OBJECT_CSV[object['oppyId']]=o;
    				}
				}
    		}
    		
    		$status_cell.animate({backgroundColor: '#51C957'}, 130, function(){
    			$status_cell.parent().find('b.reload_img').off('click').remove();
				$status_cell.remove();
				if(data['$loading'].find('span.statusSpan').length == 0){
					var list_csv=[];
					for(var key in OBJECT_CSV){
						list_csv.push( OBJECT_CSV[key] );
					}
					list_csv.push($.extend({}, data['object_head']));
					
					generateCSVfile(list_csv, 'apl_Opportunity.csv');
					$('div.LoadingDiv').hide();
					OBJECT_CSV={};
				}
	    		cb(null);
			});
		}else{
			reLoadRefData($status_cell, data);
			cb(null);
		}
		
    }}, function(err){ });

    ;function reLoadRefData($status_cell, data){
		var $parent=$status_cell.parent();
		if($parent.find('b.reload_img').length == 0){
			$parent.find('span:first').before('<b class="reload_img"></b>');
		}
	
    	$status_cell.css({'cursor': 'pointer'})
					.animate({backgroundColor: '#C95151'}, 230).off('click').on('click', function(e){
						e.stopPropagation();
						$(this).off('click');
						$status_cell.animate({backgroundColor: '#517BC9'}, 130).css({'cursor': 'default'}).find('b').remove();
						customRemoteAction(data, data['action_opp'], data['complete_opp']);
					}).append('<b class="ref_msg">'+event['message']+'</b>');
    	
    	event_publicReload_click($parent);
    }

	
}

;function complete_asynOppyExportNewTable(result, event, data){
	console.log("export");
	QUEUE.push({name: (data['index']+'_1'), run: function(cb){

		var $status_cell=data['$loading'].find('span.opp[data-index="opp_'+data['index']+'"]').eq(0);

		if(event.status){
			
			complete_publicfcst(result['wrappers'], 'list_entries', $status_cell, data, true, cb, false);

		}else{
			reLoadRefData($status_cell, data);
			cb(null);
		}
		
    }}, function(err){ });

    ;function reLoadRefData($status_cell, data){
		var $parent=$status_cell.parent();
		if($parent.find('b.reload_img').length == 0){
			$parent.find('span:first').before('<b class="reload_img"></b>');
		}
	
    	$status_cell.css({'cursor': 'pointer'})
					.animate({backgroundColor: '#C95151'}, 230).off('click').on('click', function(e){
						e.stopPropagation();
						$(this).off('click');
						$status_cell.animate({backgroundColor: '#517BC9'}, 130).css({'cursor': 'default'}).find('b').remove();
						customRemoteAction(data, data['action'], data['complete']);
					}).append('<b class="ref_msg">'+event['message']+'</b>');
    	
    	event_publicReload_click($parent);
    }

	
}
;function complete_oppyFcstExportNewTable(result, event, data){
	QUEUE.push({name: data['index'], run: function(cb){

		var $status_cell=data['$loading'].find('span.oppfc[data-index="oppfc_'+data['index']+'"]').eq(0);

		if(event.status){
    		complete_publicfcst(result['wrappers'], 'list_innerDatas', $status_cell, data, false, cb, true);
		}else{
			reLoadRefData($status_cell, data);
			cb(null);
		}
		
    }}, function(err){ });

    ;function reLoadRefData($status_cell, data){
		var $parent=$status_cell.parent();
		
    	if($parent.find('b.reload_img').length == 0){
			$parent.find('span:first').before('<b class="reload_img"></b>');
		}
    	
    	$status_cell.css({'cursor': 'pointer'})
					.animate({backgroundColor: '#C95151'}, 230).on('click', function(e){
						e.stopPropagation();
						$(this).off('click');
						$status_cell.animate({backgroundColor: '#517BC9'}, 130).css({'cursor': 'default'}).find('b').remove();
						customRemoteAction(data, data['action_fc'], data['complete_fc']);
					}).append('<b class="ref_msg">'+event['message']+'</b>');
    	
    	event_publicReload_click($parent);
    }

}
;function complete_asynOppyExportNewTableScroll(result, event, data){
	
	QUEUE.push({name: (data['index']+'_1'), run: function(cb){

		var $status_cell=data['$body'].find('#loadScroll span.left').eq(0);

		if(event.status){
			complete_publicfcstScroll(result['wrappers'], 'list_entries', $status_cell, data, true, cb, false);

		}else{
			reLoadRefData($status_cell, data);
			cb(null);
		}
		
    }}, function(err){ });

    ;function reLoadRefData($status_cell, data){
    	$status_cell.css({'cursor': 'pointer'})
					.animate({backgroundColor: '#C95151'}, 230).off('click').on('click', function(e){
						e.stopPropagation();
						$(this).off('click');
						$status_cell.animate({backgroundColor: '#517BC9'}, 130).css({'cursor': 'default'}).find('b').remove();
						customRemoteAction(data, data['action'], data['complete']);
					}).append('<b class="ref_msg">'+event['message']+'</b>');

    }

	
}
;function complete_oppyFcstExportNewTableScroll(result, event, data){
	QUEUE.push({name: data['index'], run: function(cb){

		var $status_cell=data['$body'].find('#loadScroll span.right').eq(0);

		if(event.status){
    		complete_publicfcstScroll(result['wrappers'], 'list_innerDatas', $status_cell, data, false, cb, true);
		}else{
			reLoadRefData($status_cell, data);
			cb(null);
		}
		
    }}, function(err){ });

    ;function reLoadRefData($status_cell, data){
    	$status_cell.css({'cursor': 'pointer'})
					.animate({backgroundColor: '#C95151'}, 230).on('click', function(e){
						e.stopPropagation();
						$(this).off('click');
						$status_cell.animate({backgroundColor: '#517BC9'}, 130).css({'cursor': 'default'}).find('b').remove();
						customRemoteAction(data, data['action_fc'], data['complete_fc']);
					}).append('<b class="ref_msg">'+event['message']+'</b>');
    }

}

;function complete_existOppyPartnerChildForecast(result, event, data){
	QUEUE.push({name: data['index'], run: function(cb){

		if(event.status){
    		result=$.parseJSON(result);
    		var $clone_tab=$('#childDiv table').clone(), $clone_tr=$clone_tab.find('tfoot tr').clone();
    		while(result.length > 0){
	    		var object=result.shift(), $cloneNew=$clone_tr.clone();
    			for(var key in object['map_field_value']){
    				var isfc=$cloneNew.find('td[api="'+key+'"]').attr('isfc');
    				$cloneNew.find('td[api="'+key+'"]').html((isfc == 'true' ? Globalize.format(parseFloat(object['map_field_value'][key]), 'n') : object['map_field_value'][key]));
				}
				$clone_tab.find('tbody').append($cloneNew);
    		}
    		data['$row'].addClass('done').after( '<tr class="'+data['_id']+'_subcls"><td></td><td class="tdsubchildcls" colspan="'+data['colspan']+'"></td></tr>' );
    		data['$row'].parent().find('tr.'+data['_id']+'_subcls td:eq(1)').append($clone_tab);
    		data['$exp'].removeClass('subchildren_img');
    		cb(null);
		}else{
			reLoadRefData(data);
			cb(null);
		}
		
    }}, function(err){ });

    ;function reLoadRefData(data){
		
    }

}

;function complete_existOppyPartChildForecast(result, event, data){
	QUEUE.push({name: data['index'], run: function(cb){

		if(event.status){
    		result=$.parseJSON(result);
    		var $clone_tab=$('#childDiv table').clone(), $clone_tr=$clone_tab.find('tfoot tr').clone();
    		while(result.length > 0){
	    		var object=result.shift(), $cloneNew=$clone_tr.clone();

    			for(var key in object['map_field_value']){
    				var isfc=$cloneNew.find('td[api="'+key+'"]').attr('isfc');
    				$cloneNew.find('td[api="'+key+'"]').html((isfc == 'true' ? Globalize.format(parseFloat(object['map_field_value'][key], 'n')) : object['map_field_value'][key]));
				}
				$clone_tab.find('tbody').append($cloneNew);
    		}
    		data['$row'].addClass('done').after( '<tr class="'+data['_id']+'_subcls"><td></td><td class="tdsubchildcls" colspan="'+data['colspan']+'"></td></tr>' );
    		data['$row'].parent().find('tr.'+data['_id']+'_subcls td:eq(1)').append($clone_tab);
    		data['$exp'].removeClass('subchildren_img');
    		cb(null);
		}else{
			reLoadRefData(data);
			cb(null);
		}
		
    }}, function(err){ });

    ;function reLoadRefData(data){
		
    }

}

;function complete_publicfcstScroll(list_result, field, $status_cell, data, isFc, callBack, isFormat){
	var $original_tr=$('#tab_foot tr').clone().addClass('new');

	asyncEachSeries_Original(list_result, function(item, call){
		var $tr=data['$body'].find('tr#'+item['oppyId']);
		if($tr.length == 0){
			$tr=$original_tr.clone().attr({'id': item['oppyId']});
		}
		while(item[field].length > 0){
			var list_oppy=item[field].shift().split('='), $t=$tr.find('td[api="'+list_oppy[0]+'"]'), d=list_oppy[1];
			if(isFormat){
				d = (d == '' ? '-' : d);
			}
			$t.attr({'data-val': (list_oppy[0] == 'New_Business_Percentage__c' ? d.replace('%', '') : d)});
			if(isFormat && d != '-'){
				d = Globalize.format(parseFloat(d), 'n');
			}
			$t.html( d );
		}
		if(isFc){
			$tr.find('td:eq(1)').html(function(){
				return '<a href="/'+item['oppyId']+'" target="_blank">'+this.innerHTML+'</a>';
			});
		}
		data['$body'].append($tr);
	}, function(err){
		list_result=[];
		$status_cell.animate({backgroundColor: '#51C957'}, 130, function(){
			$status_cell.parent().find('b.reload_img').off('click').remove();
			$status_cell.remove();
			if(data['$body'].find('#loadScroll span.statusSpan').length == 0){
				addSerialNumber(data);
			}
    		callBack(null);
		});
	}, 60);
	
	;function addSerialNumber(data){
		var exp=(data['issub'] ? '<b class="subbox">+</b>' : '');
		data['$body'].find('#loadScroll').remove();
		data['$body'].find('tr.new:even').addClass('treven');
		asyncEachSeries_Original(data['$body'].find('tr.new').toArray(), function(item, call){
			$(item).removeClass('new').find('td').eq(0).attr({'data-val': item.rowIndex}).html( ('<span class="snnew">'+(item.rowIndex)+'</span>'+exp) )
					.find('b.subbox').off('click').on('click', event_existChildren_click);
		}, function(err){
			data['$scroll'].removeClass('loaddata');
		}, 20);
	}
	
}

;function complete_publicfcst(list_result, field, $status_cell, data, isFc, callBack, isFormat){
	var $original_tr=$('#tab_foot tr').clone(), $tbody=$('#tab_body');

	asyncEachSeries_Original(list_result, function(item, call){
		var $tr=$tbody.find('tr#'+item['oppyId']);
		if($tr.length == 0){
			$tr=$original_tr.clone().attr({'id': item['oppyId']});
		}
		while(item[field].length > 0){
			var list_oppy=item[field].shift().split('='), $t=$tr.find('td[api="'+list_oppy[0]+'"]'), d=list_oppy[1];
			if(isFormat){
				d = (d == '' ? '-' : d);
			}
			$t.attr({'data-val': (list_oppy[0] == 'New_Business_Percentage__c' ? d.replace('%', '') : d)});
			if(isFormat && d != '-'){
				d = Globalize.format(parseFloat(d), 'n');
			}
			$t.html( d );
		}
		if(isFc){
			$tr.find('td:eq(1)').html(function(){
				return '<a href="/'+item['oppyId']+'" target="_blank">'+this.innerHTML+'</a>';
			});
		}
		$tbody.append($tr);
	}, function(err){
		list_result=[];
		$status_cell.animate({backgroundColor: '#51C957'}, 130, function(){
			$status_cell.parent().find('b.reload_img').off('click').remove();
			$status_cell.remove();
			if(data['$loading'].find('span.statusSpan').length == 0){
				addSerialNumber($tbody, data);
			}
    		callBack(null);
		});
	}, 60);
	
	;function addSerialNumber($tbody, data){
		var exp=(data['issub'] ? '<b class="subbox">+</b>' : '');
		asyncEachSeries_Original($tbody.find('tr').toArray(), function(item, call){
			$(item).find('td').eq(0).attr({'data-val': item.rowIndex}).html( ('<span class="snnew">'+(item.rowIndex)+'</span>'+exp) )
					.find('b.subbox').off('click').on('click', event_existChildren_click);
		}, function(err){
		}, 30);
		$tbody.find('tr:even').addClass('treven');
		data['$loading'].hide();
	}
	
}

;function event_divTable_scroll(e){
	
	var $this=$(this), viewH=$this.height(), contentH=$this.get(0).scrollHeight, scrollTop=$this.scrollTop();

    if(scrollTop-30 < 10){
    	$this.find('#floatTab').hide();
    }else{
    	var $ths=$this.find('#tab_head th');
    	$this.find('#floatTab').show().css({'top': scrollTop});
    	/*.find('th').each(function(){
    		var fixw=(this.cellIndex != 0 ? 1 : 0);
    		$(this).css({'width': ($ths.eq(this.cellIndex).width())});
    	});*/
    }
	
	if(LIST_OPPYIDS.length == 0){$this.removeClass('loaddata'); return false;}
	if($this.hasClass('loaddata')){return false;}
	if($('#loadScroll').length != 0){return false;}
	
	if (TIMEOUT){ clearTimeout(TIMEOUT) };
	
	if(scrollTop/(contentH -viewH)>=0.95){
		TIMEOUT = setTimeout(function(){
		    $this.addClass('loaddata');
		    
		    if(LIST_OPPYIDS.length > 0){
		    	loadOppyRemote(LIST_OPPYIDS.splice(0, 50), $this);
		    }
		    
	    }, 120);
    }
	
    
    ;function loadOppyRemote(list_tmp, $scroll){
    	var list_action=[], map_mapings={}, opType=forecastFilter.getOppyType(), 
    		p={'json': {'types': oppyFcstType, 'queryYears': parseInt(queryYears), 'list_oppyIds': [], 'mappingIds': {},
					'set_pids': [], 'querySOQL': mainSOQL, 'soqlYearRange': 'oppyFcstYearRange',
					'yearRangeSOQL': oppyFcstYearRange, 'set_labels': $.parseJSON(labels), 
					'list_fields': $.parseJSON($('[id*=jsonlistfilterid]').val()), 
					'details': $.trim($('div.checkboxMultiSel span.listText').text()).split(',') }, 'issub': true,
				'$body': $('#tab_body'), 'index': 'sub100', '$scroll': $scroll, 
				'action': asynOppyExportNew_JS, 'complete': complete_asynOppyExportNewTableScroll,
				'action_fc': oppyFcstExportNew_JS, 'complete_fc': complete_oppyFcstExportNewTableScroll};
		
		try{
			map_mapings=$.parseJSON(mappingIds);
		}catch(e){
			$('.LoadingDiv').hide();
			alert('No Records found, please adjust your search criteria.');
			return;
		}
		if($.isEmptyObject(map_mapings)){
			$('.LoadingDiv').hide();
			alert('No Records found, please adjust your search criteria.');
			return;
		}
		
		switch(opType){
			case forecastFilter.OPPY_TYPES[0]: p['issub']=false; break;
		}

		while(list_tmp.length > 0){
			var ids=list_tmp.shift();
			p['json']['mappingIds'][ids]=map_mapings[ids];
		}
		p['json']=JSON.stringify(p['json']);
		p['$body'].find('tr:last').after('<tr class="scroll" id="loadScroll"><td style="height: 50px;" colspan="999"></td></tr>');
		
		async.eachSeries([1], function(item, callback) {
			setTimeout(function(){
				p['$body'].find('#loadScroll td').append('<span class="statusSpan left opp" data-index="opp_'+p['index']+'"></span>');
				customRemoteAction(p, p['action'], p['complete']);
	
				p['$body'].find('#loadScroll td').append('<span class="statusSpan right opp" data-index="opp_'+p['index']+'"></span>');
				customRemoteAction(p, p['action_fc'], p['complete_fc']);
			}, 160);
		}, function(err){
		});
    }
    
}

;function event_existChildren_click(e){
	var $this=$(this), $tr=$this.parent().parent(), opType=forecastFilter.getOppyType(), 
		config={'isRemote': false}, fn=($this.hasClass('exp')? exp : col);
	
	if($this.hasClass('subchildren_img')){ return false; }

	fn();
	
	;function exp(){
		$tr.next().hide();
		$this.removeClass('exp').addClass('col').html('+');
	}
	
	;function col(){
		$this.addClass('subchildren_img');
		var map_ids={}, remote_fn={'json': {'types': oppyFcstType, 'queryYears': parseInt(queryYears), 'list_oppyIds': [], 'mappingIds': map_ids,
									'set_pids': [], 'querySOQL': mainSOQL, 'soqlYearRange': 'oppyFcstYearRange',
									'yearRangeSOQL': oppyFcstYearRange, 'set_labels': $.parseJSON(labels), 
									'list_fields': $.parseJSON($('[id*=jsonlistfilterid]').val()), 
									'details': $.trim($('div.checkboxMultiSel span.listText').text()).split(',') },
						'_id': $tr.attr('id'), 'colspan': $tr.find('td:not(:first)').length,
						'remote':function(p){}, '$row': $tr, '$exp': $this, 'action': function(){}, 'complete': function(){}
    				  }, map_mapings={}, levelCls='';

		try{ map_mapings=$.parseJSON(mappingIds); }catch(e){ }
		
		switch(opType){
			case forecastFilter.OPPY_TYPES[1]:
				levelCls=$tr.attr('id')+'_sub';
				map_ids[remote_fn['_id']]=map_mapings[remote_fn['_id']];
				remote_fn['mappingIds']=map_ids;
				remote_fn['action']=existOppyPartChildForecast_JS;
				remote_fn['complete']=complete_existOppyPartChildForecast;
				remoteCheck(remote_fn);
				break;
			case forecastFilter.OPPY_TYPES[2]:
				levelCls=$tr.attr('id')+'_sub';
				map_ids[remote_fn['_id']]=map_mapings[remote_fn['_id']];
				remote_fn['mappingIds']=map_ids;
				remote_fn['action']=existOppyPartnerChildForecast_JS;
				remote_fn['complete']=complete_existOppyPartnerChildForecast;
				remoteCheck(remote_fn);
				break;
			default:
				alert('Error.');
				return;
		}

		remote_fn['remote'](remote_fn);
		expandElement(levelCls);
	}
		
		
	;function remoteCheck(remoteFn){
    	if($tr.hasClass('done')){ return; }
    	config['isRemote'] = true;
    	remoteFn['json']=JSON.stringify( remoteFn['json'] );
        remoteFn['remote'] = function(p){
        	customRemoteAction(p, remoteFn['action'], remoteFn['complete']); //this is remote action
        };
    }

	
	;function expandElement(findCls){
		$tr.next().show();
    	if(!config['isRemote']){ 
			$this.removeClass('subchildren_img');
        }
		$this.removeClass('col').addClass('exp').html('-');
    }
	
}

;function event_publicReload_click($parent){
	$parent.find('b.reload_img').off('click').on('click', function(){
		var $this=$(this);
		asyncEachSeries_Original($parent.find('span.statusSpan'), function(item, call){
			$(item).click();
		}, function(err){
			$this.remove();
		}, 60);
	//	$parent.find('span.statusSpan').click();
	});
}

;function generateCSVfile(list_csv, fileName){
	console.log("called");
	for(var i = 0;i<list_csv.length;i++){
		console.log(list_csv[i]);
	}
//	var type=(navigator.userAgent.indexOf("Safari")>0 ? 'data:attachment/csv;charset=utf-8' : 'text/csv;charset=utf-8'),
	var	blob=new Blob([Papa.unparse(list_csv)], { type: 'text/csv;charset=utf-8'});
		
	saveAs(blob, fileName);
}

;function exportCSVpost(URL, PARAMS) {
	var temp = document.createElement("form"), hidden = document.createElement("input");
	temp.action = URL;
	temp.id = "exportcsvform";
	temp.method = "POST";
	temp.enctype = "multipart/form-data";
	temp.style.display = "none";
	
	hidden.type = "hidden";
	hidden.name = 'exp';
	hidden.value = PARAMS;
	temp.appendChild(hidden);
	document.body.appendChild(temp);
	temp.submit();
	$('#exportcsvform').remove();
	return temp;
}

;function detectZoom() { 
    var ratio = 0,
        screen = window.screen,
        ua = navigator.userAgent.toLowerCase();
    
    if (ua.indexOf('firefox')) {
        if (window.devicePixelRatio) ratio = window.devicePixelRatio;
    } else if (ua.indexOf('msie')){
        if (screen.deviceXDPI && screen.logicalXDPI) ratio = screen.deviceXDPI / screen.logicalXDPI;
    } else if (window.outerWidth && window.innerWidth) {
        ratio = window.outerWidth / window.innerWidth;
    }

    if (ratio) ratio = Math.round( ratio * 100 );
    return ratio;
}

;function queueRun(task, callback) {
    task.run(callback);
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
;function getZeroOfNumber(t){
	t=parseFloat(t);
	return ($.isNumeric(t) ? t : 0);
}
;function customRemoteAction(strParam, callFunction, callResult) {
    Visualforce.remoting.Manager.invokeAction(
        callFunction(), strParam['json'], function(result, event){ callResult(result, event, strParam); }, {escape: false, timeout:120000}
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


